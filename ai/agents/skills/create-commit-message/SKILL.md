---
name: create-commit-message
description: >
  Builds a commit message from the changes made in the project, following the
  repository's own rules. Use when the user asks to create, review, or fix a
  commit message, or when preparing a merge request.
---

# Writing a commit message

## 1. Gather the change context

The message must describe the whole branch, not just the staged files.

```bash
git status --short
git symbolic-ref --short refs/remotes/origin/HEAD   # base branch, usually origin/main
git diff --stat "$BASE...HEAD"
git diff "$BASE...HEAD"
git log --no-merges --pretty=%s "$BASE..HEAD"       # what the branch already says
git rev-parse --abbrev-ref HEAD                     # branch name, see step 4
```

If the base branch cannot be determined, ask the user what to compare against.

## 2. Determine the repository rules

Check for `policy.yml` in the repository root and read the RegExp from
`push_rules.commit_message`.

- No file, or no `push_rules.commit_message` field → use
  [Conventional Commits](https://www.conventionalcommits.org), matching the style
  of recent commits.
- The RegExp syntax is Go-based (RE2): no lookahead, lookbehind, or backreferences.
  If the rule contains `(?=...)`, `(?!...)`, or `\1`, the engine is not RE2 — treat
  the expression as PCRE.

## 3. Determine the message language

If the RegExp does not constrain the language, use whatever the repository already uses:

```bash
git log -10 --no-merges --pretty=%s
```

Exclude service and bot commits from the sample (`Merge branch`, `Revert`, `Bump`,
commits from `*-bot`, `dependabot`). If the remaining ones are written in different
languages, pick English.

## 4. Task identifier

The task identifier **always** goes in the subject line, whether or not the RegExp
requires it.

Source it from the current branch name (`feature/PROJ-412-rate-limit` → `PROJ-412`).
If the branch name yields no key, look through the branch's commit subjects
(`git log --no-merges --pretty=%s "$BASE..HEAD"`). Still nothing — ask the user.
If the user confirms there is no task, write the message without a key and say so
in your reply. Never invent an identifier.

Key placement:

- the RegExp defines the position → follow it;
- otherwise mirror the convention of recent commits;
- with Conventional Commits, place it right after the colon: `fix(auth): PROJ-412 ...`;
- no rule and no precedent → prefix the subject: `PROJ-412 ...`.

## 5. Write the message

Subject line:

- 72 characters max, including the task identifier;
- imperative mood, capitalized, no trailing period.

Body (when the change is large):

- separated from the subject by a blank line;
- wrapped at 72 characters;
- lists use `-`;
- plain text, no markdown headers or formatting: `git log` does not render them and
  they just become visual noise. Markdown belongs in the merge request description.

Describe **what changed and why**, do not restate the diff.

## 6. Verify the result

Before handing the message over, check that:

- the subject matches the RegExp from `policy.yml` (if present);
- the task identifier is there;
- the subject is 72 characters or fewer;
- there is no trailing period on the subject;
- a blank line precedes the body.

If something fails, rewrite and check again. Do not hand over a message that
violates the repository rule.

## 7. Deliver the result

By default, print the finished message for the user. Only run `git commit` if the
user explicitly asked for it.

## Examples

Small change, Conventional Commits, branch `fix/PROJ-98-refresh-tokens`:

```
fix(auth): PROJ-98 reject expired refresh tokens
```

Large change with a body, branch `feature/PROJ-412-rate-limit`:

```
PROJ-412: Add per-tenant rate limiting

Requests are now counted per tenant instead of per IP, which fixes
throttling of users behind shared NAT.

- add RateLimiter backed by Redis sliding window
- read limits from tenant settings with a global fallback
- return 429 with Retry-After instead of 503
```