# Java Documentation

Apply the general `document-code` rules.

## Format and tags

- Prefer Markdown Javadoc (`///`) for new documentation on JDK 23+ when project tooling supports it;
  otherwise use `/** ... */`. Preserve the surrounding style without converting existing comments.
- Prefer Markdown to HTML in `///` comments. Use `package-info.java` and `module-info.java` for package
  and module documentation.
- `@param`, `@return`: Describe meaningful semantics and satisfy configured doclint requirements;
  do not omit required tags merely to avoid repetition.
- `@throws`: Include contractual checked and relevant unchecked exceptions, not incidental implementation exceptions.
- `@deprecated`: Use with `@Deprecated`; identify a replacement when available.
- `@apiNote`, `@implSpec`, `@implNote`: Custom tags for API notes, implementation requirements, and implementation notes.
  Use only when configured through `-tag`, a taglet, or equivalent doclet support; otherwise use ordinary text.
- `{@link}` / Markdown links: Use the syntax supported by the comment format.
- `{@snippet}`: Prefer for examples benefiting from validation or reuse, when supported by the project's JDK and tooling.

## Validation

Follow the project's Javadoc and doclint configuration; check references and missing-tag warnings.
