# GitHub (the `gh` CLI)

## How to identify the repository

Use this provider if the hostname in the URL returned by
`git remote get-url origin` is `github.com`. Both HTTPS and SSH URLs are supported.

## CLI

Use the GitHub CLI to create a pull request: `gh pr create`.
Check that `gh` is installed and authenticated: `gh auth status --hostname github.com`.
If the CLI is missing or authentication is unavailable, inform the user.

## Create a PR

First prepare `/tmp/mr-description.txt` according to "PR description" below
and show the user the final title and description. When submitting, only
read the prepared description; do not run preparation again.

Basic invocation for a PR within the same repository, after pushing the branch:

```bash
TITLE=$(sed -n '1p' /tmp/commit-msg.txt)

gh pr create \
  --repo <owner/repo> \
  --head "$(git branch --show-current)" \
  --base <base-branch> \
  --title "$TITLE" \
  --body-file /tmp/mr-description.txt
```

The CLI prints the created PR's URL: show it to the user.

## How to determine parameter values

| Flag | How to determine the value |
|------|----------------------------|
| `--repo` | `owner/repo` from the `origin` URL, without `.git`. For a PR from a fork, use the target upstream repository. Ask if the target is ambiguous. |
| `--head` | The current published branch; see below for forks. |
| `--base` | The base branch from step 2 of the main SKILL.md, without the `origin/` prefix. |
| `--title` | The final commit message's subject, following "Linking a task". |
| `--body-file` | The prepared PR description in `/tmp/mr-description.txt`. |

## GitHub specifics

The main SKILL.md rule to squash **before** pushing still applies.
Do not configure the merge method or branch deletion as part of PR creation.

## Optional parameters

- `--draft`: if the user requests a draft or the title contains markers
  such as "WIP" or "in progress".
- A PR from a fork to upstream: only if the user requests this scenario.
  Set `--repo` to the target `owner/repo` and `--head` to
  `<source-owner>:<branch>`. First identify both repositories from the remotes.
  The `--head <user>:<branch>` syntax does not support an organization as the
  source repository's owner; in that case, stop and report the limitation.
- Set reviewers, assignees, labels, and milestone only when requested by
  the user or required by explicit project rules.

## PR description

### If the repository has a PR template

Look for `pull_request_template.md` in the root, `.github/`, and `docs/`, as well
as templates in their `PULL_REQUEST_TEMPLATE/` subdirectories.
Account for filename case variations, such as `PULL_REQUEST_TEMPLATE.md`.
For a PR from a fork, look for templates in the target upstream repository.

**Template selection:**

- One template → use it.
- Multiple templates → ask the user which one to use.
  Do not select automatically based on the branch name or other heuristics.

**Filling in the template:**

- Fill descriptive sections based on the diff against the base branch.
- Fill "How to test" and "Steps to reproduce" sections if the information
  can be inferred from the changes; otherwise, leave the placeholder.
- Do not check checklist items (`- [ ]`): the author checks them before merging.
- Replace placeholder comments with content or leave them if no information is available.

Do not append the commit body separately to the template. Save the completed description
to `/tmp/mr-description.txt` and show it to the user before submitting.
Pass the prepared file via `--body-file`, without `--template` or `--fill`.

### If there is no template

Use the final commit message's body unchanged:

```bash
tail -n +3 /tmp/commit-msg.txt > /tmp/mr-description.txt
```

If the body is empty, leave the file empty or ask the user
whether to add a description.

## Linking a task

If the branch name contains a task key, add it to the PR title unless it
is already present. Do not add `Closes` / `Fixes` for GitHub issues without
explicit intent to close the issue upon merging.

## Verify the result

- The CLI returned the created PR's URL: show it to the user.
- If the command fails, report the reason. If the outcome is ambiguous,
  check whether the PR exists before submitting again.
- If a PR already exists, show its URL; do not create a duplicate or modify
  the existing PR without a user request.

## What NOT to do

- Do not merge or enable auto-merge when creating a PR.
- Do not guess the target repository for a PR from a fork.
- Do not check template checklist items yourself.
- Do not overwrite the prepared description with the original template when submitting.

## Documentation

- [gh pr create](https://cli.github.com/manual/gh_pr_create)
- [Pull request templates](https://docs.github.com/en/communities/using-templates-to-encourage-useful-issues-and-pull-requests/creating-a-pull-request-template-for-your-repository)
