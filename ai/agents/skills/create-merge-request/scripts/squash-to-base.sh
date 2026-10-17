#!/usr/bin/env bash
# Leaves the current branch with one commit on top of the base.
#
# Usage:
#   squash-to-base.sh <base-ref> <commit-message-file>
#
# Behavior based on the number of commits in $base..HEAD:
#   0  → error (nothing to merge).
#   1  → if the message matches the current commit, do nothing;
#        otherwise, run `git commit --amend -F <msg-file>`.
#   >1 → `git reset --soft $(git merge-base HEAD <base>) && git commit -F <msg-file>`.
#        If commit fails, restores the original HEAD via a soft reset,
#        preserving the index and working tree, including any hook changes.
#
# Prints one of `noop`, `amended`, or `squashed` to stdout so the caller
# can determine whether a force push is needed.

set -euo pipefail

BASE="${1:?usage: squash-to-base.sh <base-ref> <commit-message-file>}"
MSG_FILE="${2:?usage: squash-to-base.sh <base-ref> <commit-message-file>}"

# --- Environment checks -----------------------------------------------------

if [ ! -f "$MSG_FILE" ]; then
  echo "commit message file not found: $MSG_FILE" >&2
  exit 1
fi

if [ ! -s "$MSG_FILE" ]; then
  echo "commit message file is empty: $MSG_FILE" >&2
  exit 1
fi

# Clean working tree
if [ -n "$(git status --porcelain)" ]; then
  echo "working tree is not clean, commit or stash changes first" >&2
  git status --short >&2
  exit 1
fi

# Disallow base branches
CURRENT="$(git branch --show-current)"
case "$CURRENT" in
  main|master|develop|"")
    echo "refuse to operate on base branch: '$CURRENT'" >&2
    exit 1
    ;;
esac

# Base ref exists
if ! git rev-parse --verify --quiet "$BASE" >/dev/null; then
  echo "base ref not found: $BASE" >&2
  exit 1
fi

# --- Logic ------------------------------------------------------------------

COUNT="$(git rev-list --count "$BASE..HEAD")"

if [ "$COUNT" = "0" ]; then
  echo "no commits ahead of $BASE, nothing to squash" >&2
  exit 1
fi

NEW_MSG="$(cat "$MSG_FILE")"

if [ "$COUNT" = "1" ]; then
  CURRENT_MSG="$(git log -1 --pretty=%B HEAD | sed -e :a -e '/^$/{$d;N;ba' -e '}')"
  NEW_MSG_TRIMMED="$(printf '%s' "$NEW_MSG" | sed -e :a -e '/^$/{$d;N;ba' -e '}')"

  if [ "$CURRENT_MSG" = "$NEW_MSG_TRIMMED" ]; then
    echo "noop"
    exit 0
  fi

  git commit --amend -F "$MSG_FILE" >/dev/null
  echo "amended"
  exit 0
fi

MERGE_BASE="$(git merge-base HEAD "$BASE")"
ORIGINAL_HEAD="$(git rev-parse HEAD)"

git reset --soft "$MERGE_BASE" >/dev/null

if git commit -F "$MSG_FILE" >/dev/null; then
  echo "squashed"
else
  COMMIT_STATUS=$?
  if git reset --soft "$ORIGINAL_HEAD" >/dev/null; then
    echo "commit failed; restored HEAD to $ORIGINAL_HEAD; index and working tree preserved" >&2
  else
    echo "commit failed; could not restore HEAD; original HEAD: $ORIGINAL_HEAD" >&2
    echo "to restore it, run: git reset --soft $ORIGINAL_HEAD" >&2
  fi
  exit "$COMMIT_STATUS"
fi
