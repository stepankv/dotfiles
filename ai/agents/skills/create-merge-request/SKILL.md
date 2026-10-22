---
name: create-merge-request
description: >-
  Prepares a branch for a merge request by squashing commits and composing the final commit message and MR description.
  Uses the `create-commit-message` skill to compose the final (squashed) commit message.
---

# create-merge-request

A skill for preparing a branch for a merge request according to project rules.

## When to use

- The user asks to "create an MR", "prepare a merge request", "squash and push", or "prepare the branch for merging".
- A feature branch needs to follow the "one commit = one MR" convention.

## Main project rule

**All commits on the branch must be squashed into one before pushing.**
Leave the base branch (`main`/`master`/`develop`) untouched: squash only the current branch's commits relative to the base branch.

## Workflow

### 1. Check repository status

```bash
git status
git branch --show-current
```

- Ensure the working tree is clean (no uncommitted changes). Otherwise, ask the user to commit or stash them.
- Ensure the current branch is **not** a base branch (`main`, `master`, `develop`). If it is, stop.

### 2. Determine the base branch

Default to `main`. If it does not exist, try `master`, then `develop`.
Ask the user if the choice is unclear.

```bash
git fetch origin
BASE=origin/main   # this variable is used throughout the following steps
```

### 3. Gather information about the branch's commits

```bash
git log --oneline $BASE..HEAD
git diff $BASE...HEAD --stat
git diff $BASE...HEAD
```

Pay particular attention to branches with **a single commit**: squashing is technically unnecessary, but this **does not mean step 4 can be skipped**.
The existing commit message may no longer match the final contents after `git commit --amend`: amend adds changes, but authors rarely rewrite the message.

Therefore, regardless of the number of commits:

- always compare the current message (or the combined meaning of multiple commits) with the actual diff against the base branch;
- if they differ, rewrite the message in step 4.

### 4. Compose the final commit message

Invoke the **`create-commit-message`** skill, providing:

- the list of original commits (the branch's `git log`),
- the combined diff against the base branch.

Obtain the final commit message. Show it to the user for approval.

**This step is mandatory even when the branch has a single commit**: the existing message may be outdated after `git commit --amend`. If the comparison confirms that the current message fully matches the diff, it may be kept unchanged, but make this decision after checking, not by default.

### 5. Squash or update the commit

Write the approved message to `/tmp/commit-msg.txt` and run:

```bash
./scripts/squash-to-base.sh "$BASE" /tmp/commit-msg.txt
```

The script chooses the action automatically:
- `squashed`: performed a soft reset and created a new commit;
- `amended`: ran `git commit --amend`;
- `noop`: a single commit already had the correct message; nothing changed.

Use this value in step 6 to determine whether a force push is needed.

### 6. Push the branch

- `squashed` or `amended` → `git push --force-with-lease`.
- `noop` and the branch has already been pushed → do nothing.
- `noop` and the branch has not been pushed → `git push -u origin <branch>`.

Do not force push to base branches.

## 7. Create the MR/PR

Determine the provider from the remote URL:

```bash
git remote get-url origin
```

Selection rules (top to bottom, first match wins):

1. The URL points to the **company's internal GitLab** (a corporate domain, such as `gitlab.<corporate-domain>`) → `providers/gitlab-company.md` (the `dp` CLI).
2. The URL contains `github.com` → `providers/github.md` (the `gh` CLI).
4. No match: ask the user which provider to use and offer the options in `providers/`.

After selecting a provider, read the corresponding file in `providers/` and follow its instructions. Do not guess commands.

## Completion checks

- [ ] The branch has exactly one commit relative to the base: `git rev-list --count $BASE..HEAD` → `1`.
- [ ] The final commit message has been approved by the user and matches the diff.
- [ ] The branch has been pushed (`git status` shows "up to date with origin/...").
- [ ] The user has been shown the MR title and description.

## What NOT to do

- Do not force push to base branches (`main`/`master`/`develop`).
- Do not run `git reset --hard`: use only `--soft` to avoid losing changes.
- Do not squash or amend without showing the final commit message to the user.
- Do not assume a single commit's message is automatically correct: check it.
- Do not invent MR contents: use only the actual diff and commits.
