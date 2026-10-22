---
name: document-code
description: >-
  Use when writing, modifying, or reviewing code that contains API documentation,
  doc comments, or implementation comments. Keep documentation accurate,
  concise, and consistent with API contracts and language conventions.
---

# Code Documentation

Write English documentation that lets callers use an API without reading its implementation.
Keep changes within the requested scope; do not add documentation merely to increase coverage.

## Conventions

Inspect nearby documentation and tooling. Follow project conventions first, language conventions second,
and this skill's defaults last. Preserve correct documentation rather than rewriting it for style alone.
Conventions never justify factual inaccuracies.

Load only the reference for the language being documented:

- Java: [Javadoc](references/java.md).
- Kotlin: [KDoc](references/kotlin.md).
- Rust: [rustdoc](references/rust.md).

For other languages, follow their documentation conventions; do not import another language's syntax or tags.

## Verify the contract

- Verify documented behavior against the declared contract, implementation,
  and relevant tests. Report inconsistencies instead of silently treating
  implementation details as contractual guarantees.
- Distinguish contractual guarantees from incidental implementation behavior, including thread safety.
- Describe significant error conditions that actually occur; do not invent error handling.
- When code changes, update affected documentation and remove stale comments. Preserve correct documentation
  for changes that affect only implementation.

## API documentation

API boundaries follow architecture and language conventions, not access modifiers alone.
Document what callers need, without restating names, types, or unambiguous nullability annotations.
Start with a concise purpose sentence in the project's grammatical style (`Return` or `Returns`).
Add details only where they affect correct usage:

- Parameter and return-value semantics; distinguish absence (`null`, empty, or missing) from failure.
- Preconditions, postconditions, invariants, edge cases, side effects, and idempotency.
- Error or exception conditions and how failures reach the caller.
- State, immutability, concurrent use, external synchronization, and visibility or ordering guarantees.
- For async or lazy APIs: execution timing, blocking, cancellation and its consequences, retries,
  completion guarantees, and required executors or runtimes.

Describe observable behavior rather than internal call sequences, helper locations, or implementation history.
Do not add empty sections or boilerplate statements about every possible characteristic.

Use the language's deprecation mechanism, identify replacements and migration constraints when known,
and preserve existing markers unless the contract changes. Record introduction versions only when the project
tracks them; do not invent deprecation versions or promise removal dates without a confirmed decision.

Link related declarations using the language's documentation syntax. Add minimal examples only when usage
is non-obvious, using real APIs; prefer compilable or executable examples when tooling supports validation.

## Implementation comments

Explain non-obvious constraints, invariants, or reasons for unusual choices when misunderstanding could
compromise correctness. For example: `Preserve insertion order to ensure deterministic serialization.`
Avoid narrating code or documenting obvious private members; prefer clear names and structure.
Add `TODO` comments only when necessary.

## Review and validation

Check affected contracts, links, and examples using configured documentation tooling where available.
During review, prioritize accuracy and usefulness over documentation volume.
