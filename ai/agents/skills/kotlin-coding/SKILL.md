---
name: kotlin-coding
description: Guidelines for writing, modifying, refactoring, and verifying Kotlin code.
---

# Kotlin Coding Guidelines

Apply these rules whenever writing, modifying, reviewing, or refactoring Kotlin code.

## 1. Coding conventions

- Follow the official [Kotlin Coding Conventions](https://kotlinlang.org/docs/coding-conventions.html) maintained by
  JetBrains.
- Prefer idiomatic Kotlin over Java-style constructs.
- Follow existing project conventions when they do not conflict with the explicit rules in this skill.
- When rules conflict, the explicit rules in this skill take precedence over the general Kotlin Coding Conventions.

## 2. Explicit lambda parameters

Never use implicit `it` in lambda expressions.

Always declare lambda parameters explicitly and give them meaningful names reflecting their purpose.

Bad:

```kotlin
users.filter { it.isActive }
    .map { it.email }
```

Good:

```kotlin
users.filter { user -> user.isActive }
    .map { user -> user.email }
```

This rule also applies to nested lambdas and scope functions.

Bad:

```kotlin
user?.let {
    println(it.email)
}
```

Good:

```kotlin
user?.let { currentUser ->
    println(currentUser.email)
}
```

## 3. Collection transformations

Avoid unnecessary intermediate collections.

When mapping an `Iterable` to a set, prefer `mapTo(mutableSetOf())` over
`map { ... }.toSet()` when a mutable backing collection is acceptable.

Bad:

```kotlin
val emails: Set<String> = users
    .map { user -> user.email }
    .toSet()
```

Good:

```kotlin
val emails: Set<String> = users.mapTo(mutableSetOf()) { user -> user.email }
```

Apply this optimization only when the collection semantics are preserved.

- Do not introduce mutable collections unnecessarily.
- Preserve the expected collection type and behavior.
- Do not sacrifice readability for insignificant optimizations.
- Avoid redundant collection conversions and intermediate allocations where a direct operation is available.

## 4. Callable references

Prefer Kotlin callable references (`::`) over lambdas that only delegate to an existing function or property.

Bad:

```kotlin
users.map { user -> user.toDto() }
```

Good:

```kotlin
users.map(User::toDto)
```

Bad:

```kotlin
users.forEach { user -> processUser(user) }
```

Good:

```kotlin
users.forEach(::processUser)
```

Use callable references when:

- The reference is type-compatible with the expected function type.
- Behavior remains identical.
- The resulting code is at least as readable as the lambda.

Do not force callable references when they require additional logic, change behavior, or reduce clarity.

## 5. Function declarations

Expression bodies (`=`) are allowed when the function consists of a single expression.

Use block bodies (`{}`) for functions with multiple statements, with explicit `return` statements
when a value must be returned. Do not wrap multiple statements in `run` or another scope function
solely to use an expression body.

Allowed — single expression:

```kotlin
fun getUser(id: Long): User = repository.findById(id)

override fun toString(): String = name
```

Use a block body for multiple statements:

```kotlin
fun getUser(id: Long): User {
    require(id > 0) { "User ID must be positive" }
    return repository.findById(id)
}
```

This rule applies to regular functions, extension functions, local functions, and overridden functions.

Do not apply this rule to property declarations, lambda expressions, or property accessors.

## 6. Build and test verification

After modifying Kotlin code, verify the changes using the project's existing build system.

### Build system detection

- Identify the build system from the project files.
- Prefer the project's wrapper over globally installed tools.
- Use the project's existing test, lint, and verification configuration.
- Do not introduce new build tools or dependencies solely to verify changes.

### Gradle

For projects with `gradlew`, use the wrapper. The commands below are typical for Kotlin/JVM;
choose the actual tasks from the project's existing configuration and CI workflow.

Typical test command:

```bash
./gradlew test
```

Typical verification command (runs tests and other checks attached to `check`):

```bash
./gradlew check
```

For multi-module projects, prefer targeted verification during development:

```bash
./gradlew :module-name:test
./gradlew :module-name:check
```

When appropriate, run verification for the full project after targeted checks.

### Maven

For projects with `mvnw`, use the wrapper. The commands below are typical;
use the project's existing configuration and CI workflow to select the required checks.

Typical test command:

```bash
./mvnw test
```

Typical verification command:

```bash
./mvnw verify
```

For multi-module projects, verify affected modules and their required dependencies:

```bash
./mvnw -pl module-name -am test
```

If no Maven wrapper exists, use `mvn`.

### Other build systems

For other build systems, use the project's documented build and test commands.

Do not assume that Gradle or Maven is available.

### Verification requirements

- Run relevant tests after modifying production code.
- Run relevant tests after modifying test code.
- Run configured formatting, lint, and static analysis checks when available.
- Prefer targeted checks during development and broader checks before completion.
- If a check fails, investigate the failure, fix issues caused by the changes, and rerun the relevant check.
- Do not disable, delete, or skip failing tests merely to obtain a successful build.
- Do not modify unrelated code solely to make verification pass.
- Do not claim tests passed unless they were actually executed successfully.
- If verification cannot be performed, explicitly report what was not executed and why.
- Report the executed commands, their results, and any remaining failures.

## 7. Scope of changes

- Preserve existing behavior unless a behavior change is explicitly requested.
- Keep modifications focused on the requested task.
- Do not refactor unrelated code.
- Follow the project's established architecture and APIs.
- Do not introduce new dependencies without a concrete need.
