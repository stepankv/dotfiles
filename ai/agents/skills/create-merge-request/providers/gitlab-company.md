# Company's internal GitLab (the `dp` CLI)

## How to identify the repository

If `git remote get-url origin` contains the company's corporate GitLab domain, this is an internal repository: use `dp`.

## CLI

Use the `dp` CLI to create a merge request.
Command: `dp gitlab create-merge-request`.

## Create an MR

First prepare `/tmp/mr-description.txt` according to "MR description" below
and show the user the final title and description. When submitting, only
read the prepared description; do not run preparation again.

Basic invocation after preparation:

```bash
TITLE=$(sed -n '1p' /tmp/commit-msg.txt)

DESCRIPTION=$(cat /tmp/mr-description.txt)

dp gitlab create-merge-request \
  --tenant <tenant> \
  --repository <repo> \
  --source-branch "$(git branch --show-current)" \
  --target-branch <base-branch> \
  --title "$TITLE" \
  --description "$DESCRIPTION" \
  --remove-source-branch \
  --squash
```

The CLI prints the created MR's ID and URL: show them to the user.

## How to determine parameter values

| Flag | How to determine the value |
|------|----------------------------|
| `--tenant` / `-t` | From the `origin` URL: `git remote get-url origin` → the group/namespace preceding the repository name. Ask if ambiguous. |
| `--repository` / `-r` | The repository name (the last URL segment without `.git`). |
| `--source-branch` | `git branch --show-current`. |
| `--target-branch` | The base branch from step 2 of the main SKILL.md (without the `origin/` prefix). |
| `--title` | The first line (subject) of the final commit message from step 4. |
| `--description` | See "MR description" below. If a template exists, use the completed template; otherwise, use the final commit message's body. |

## Required project flags

- `--remove-source-branch`: the branch must be deleted after merging.
- `--squash`: a GitLab-side safeguard. Our rule requires squashing **before** pushing (step 5 of SKILL.md), but keep this flag in case additional commits are added to the branch after opening the MR.

## Optional flags

- `--draft`: if the MR is not ready for review. Use when the user explicitly requests a draft or the title contains markers such as "WIP" or "in progress".
- `--source-project`: only for a **cross-project** MR (from a fork to the main repository). The usual scenario is within a single repository and does not need this flag. Use it only if:
  - `git remote get-url origin` points to a fork,
  - and the user explicitly wants an MR to upstream.

  The value is the full path (`group/repo`) or numeric ID of the source project.

## MR description

### If the repository has an MR template

Look for: `.gitlab/merge_request_templates/*.md`.

**Template selection:**
- One template → use it.
- Multiple templates → **ask the user** which one to use. Do not select automatically based on the branch name or other heuristics.

**Filling in the template:**
- Descriptive sections ("Changes", "Description", "Context", etc.) → fill based on the diff against the base branch.
- Sections such as "How to test" and "Steps to reproduce" → fill if the information can be inferred from the diff; otherwise, leave the placeholder.
- Checklists (`- [ ]`) → **do not check items**; leave them as in the template (the author checks them before merging).
- Placeholder comments (`<!-- ... -->`) → replace with content or leave unchanged if no content is available.

When a template exists, the final commit message's body **is not used**: the template determines the description's structure and content.

Save the result to `/tmp/mr-description.txt` and show it to the user before submitting.

### If there is no template

Use the **final commit message's body** (everything after the subject and the blank separator line) as the MR description, unchanged:

```bash
tail -n +3 /tmp/commit-msg.txt > /tmp/mr-description.txt
```

If the body is empty, pass an empty description (`--description ""`) or ask the user whether to add anything.

## Linking a task

If the branch name contains a task key (such as `feature/JIRA-123-foo` or `JIRA-123/foo`), add it to the MR title (usually at the beginning).

## Verify the result

- [ ] The CLI returned an ID and URL: show them to the user.
- [ ] If the command fails (invalid tenant, missing permissions, conflict), show stderr to the user and do not try to "fix" the invocation by guessing parameters.

## What NOT to do

- Do not pass `--source-project` unless the cross-project scenario is confirmed.
- Do not guess `--tenant` or `--repository`: if parsing the `origin` URL is ambiguous, ask the user.
- Do not check MR template checklist items yourself.
- Do not mix template contents and the commit body: use one or the other according to the rules above.
