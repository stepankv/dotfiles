#!/usr/bin/env bash
# Prepares source material for an MR description.
#
# Usage:
#   prepare-mr-description.sh <commit-message-file> [template-file]
#
# Behavior:
#   - If template-file is provided and exists, copies its contents to stdout
#     unchanged (the model fills it in).
#   - Otherwise, extracts the final commit message's body (everything after
#     the first line and the blank separator line) and prints it to stdout.
#
# Separately reports `source: template` or `source: commit-body` to stderr.

set -euo pipefail

MSG_FILE="${1:?usage: prepare-mr-description.sh <commit-message-file> [template-file]}"
TEMPLATE_FILE="${2:-}"

if [ ! -f "$MSG_FILE" ]; then
  echo "commit message file not found: $MSG_FILE" >&2
  exit 1
fi

if [ -n "$TEMPLATE_FILE" ]; then
  if [ ! -f "$TEMPLATE_FILE" ]; then
    echo "template file not found: $TEMPLATE_FILE" >&2
    exit 1
  fi
  echo "source: template ($TEMPLATE_FILE)" >&2
  cat "$TEMPLATE_FILE"
  exit 0
fi

echo "source: commit-body" >&2
# Everything after the first line and the first blank line
awk 'NR==1 {next} NR==2 && /^$/ {found=1; next} found {print}' "$MSG_FILE"
