# Rust guidance

Apply these rules across Rust projects. Determine project-specific commands,
features, targets, and toolchain from repository instructions and CI.

## Semantic analysis

- Use rust-analyzer definitions, references, implementations, and hover
  when correctness depends on symbol identity, trait relationships,
  inferred types, aliases, or wrapper types.
- Inspect relevant trait implementations and callers before changing APIs.
- Treat macro expansion, generated code, and inactive cfg branches as
  potential gaps in analysis.
- Interpret results within the loaded Cargo workspace, features, and target.

## Diagnostics and Cargo

- Prefer fresh rust-analyzer diagnostics for intermediate feedback.
- Distinguish native diagnostics from Cargo check or Clippy diagnostics.
  Do not assume Clippy is configured.
- If an equivalent Cargo check or Clippy run through rust-analyzer has
  demonstrably completed with suitable coverage, avoid repeating it.
- If completion or coverage cannot be established, run the appropriate
  Cargo command directly.
- For Cargo.toml, build.rs, dependencies, feature flags, target-specific
  code, or generated code changes, explicitly validate affected configurations.
- Select packages, targets, and feature combinations according to the
  change and CI. Do not add --all-features automatically.
- Run relevant tests after behavior changes. Changes to calculation logic
  require tests covering the affected scenarios.
- Format changed Rust code according to repository conventions.
- Run mandatory project checks even if LSP diagnostics are clean.
- Build release artifacts when required by the task or project checks.

## Scope

Fix diagnostics introduced by the change. Do not expand the task to clean up
unrelated existing warnings. Report existing issues when they block validation.
