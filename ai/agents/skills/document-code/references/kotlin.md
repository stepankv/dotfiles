# Kotlin Documentation

Apply the general `document-code` rules.

## Format and tags

- Use KDoc (`/** ... */`) with Markdown and `[Declaration]` links; do not impose Java-specific Javadoc requirements.
- `@param`, `@return`: Use when they add semantics, not for every parameter or result.
- `@throws` / `@exception`: Describe contractual exception conditions.
- `@receiver`: Explain non-obvious extension receiver semantics.
- `@property`, `@constructor`: Explain additional property or constructor semantics.
- `@sample`: Prefer for non-trivial examples backed by existing, compilable Kotlin code.
- `@see`: Reference related APIs when useful.

## Kotlin contracts and deprecation

- For coroutines and Flow, explain relevant execution timing, cancellation, error propagation, and cold/hot semantics.
  Coroutine usage and Kotlin types alone do not establish thread safety.
- Use Kotlin's `@Deprecated` annotation rather than a KDoc `@deprecated` tag;
  include `ReplaceWith` when a valid replacement expression exists.

## Validation

Validate KDoc links and `@sample` references with Dokka when configured.
