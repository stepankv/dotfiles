---
name: lsp-analysis
description: >-
  Use when reading, reviewing, debugging, or modifying source code and
  semantic understanding is needed: symbol definitions, references, types,
  implementations, call relationships, refactoring, or diagnostics.
  Applies across languages through available LSP tools.
---

# LSP-assisted code analysis

Use available LSP tools proactively, without waiting for the user to ask.
For Rust code, read [Rust guidance](references/rust.md).
Load other references only when relevant to the task.

## Availability and workspace

- Discover the actual tools exposed by the LSP adapter. Do not assume that
  protocol method names are directly callable tool names.
- Use the server associated with the target file and workspace.
- Respect the capabilities exposed by both the server and adapter.
- If initialization or project loading is incomplete, inspect available
  status information and retry when appropriate. Avoid unbounded polling.
- If LSP is unavailable, briefly report the limitation and continue with
  source inspection and project checks.

## Navigation and understanding

Prefer semantic operations when the answer depends on symbol identity:

- Workspace symbols: locate declarations by name.
- Document symbols: inspect the structure of an unfamiliar large file.
- Definition/type definition: resolve declarations and types.
- References: identify usages and affected consumers.
- Implementation: locate implementations of interfaces or traits.
- Hover: inspect inferred types and signatures.
- Call/type hierarchy: investigate relationships when supported.

Read relevant implementations and tests before drawing conclusions about
behavior. Symbol summaries and call hierarchies do not replace source code.

Use rg or grep for filenames, literals, configuration, textual patterns, and to
supplement incomplete semantic results.

## Changes and refactoring

- Before renaming a symbol or changing its signature, collect references
  and inspect affected usages.
- Prefer LSP rename when available. Inspect and apply the returned edits,
  then review the resulting diff.
- For file moves, use file-rename support when available and verify imports,
  module declarations, paths, and configuration.
- Do not assume semantic results cover inactive configurations, generated
  code, macros, reflection, or dynamically constructed names.

## Diagnostics and verification

- After edits, ensure the server has received the current file contents
  through the adapter's synchronization mechanism.
- Obtain fresh diagnostics for changed files and affected consumers,
  within the server's supported scope.
- Distinguish an empty successful result from stale data, unsupported
  operations, timeouts, and failures.
- Never infer successful validation merely from an empty diagnostic list.
- Use diagnostics for fast feedback; retain required project checks and
  tests that validate changed behavior.
- Avoid repeating an equivalent completed check without a concrete reason.
- If freshness, completion, or coverage cannot be established, run an
  appropriate project check directly.
- Report checks actually performed and material gaps in their coverage.
