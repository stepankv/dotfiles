# Rust Documentation (rustdoc)

Apply the general `document-code` rules.

## Format and contracts

- Use `///` for items and `//!` for modules and crates, with Markdown and intra-doc links such as [`Self::push`].
- Prefer third-person summaries (`Returns`, `Creates`, `Panics`) when no project convention exists.
- Do not use `#[doc(hidden)]` as a substitute for proper API visibility.
- Explain ownership, borrowing, and lifetime constraints when not evident from the signature.
- Use `#[deprecated]` with `since` and `note` when appropriate.

## Sections

- `# Examples`: For public APIs whose usage is non-obvious.
- `# Errors`: Meaningful failure conditions for functions returning `Result`.
- `# Panics`: Actual conditions under which an API may panic, without speculative cases.
- `# Safety`: Caller obligations and safety invariants for public `unsafe` APIs.

## Examples and validation

- Prefer executable doctests. Use `no_run` to compile without executing and `compile_fail` for rejected code.
- Use hidden lines (`#`) only for setup needed to compile examples.
- Run `cargo doc` and `cargo test --doc` when feasible; check intra-doc links and existing rustdoc lints.
