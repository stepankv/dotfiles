---
name: nix-environment
description: >-
  Use when operating in an environment managed by Nix, including NixOS,
  nix-darwin, and Nix on macOS. Guides tool discovery, temporary dependencies,
  dev shells, package lookup, Nix diagnostics, and safe configuration changes.
---

# Working in Nix environments

Use the existing declarative environment instead of modifying the host to make
an individual task work. Prefer project-local, reproducible operations and
read-only inspection before builds or activation.

## Detect the environment

- Reuse established environment facts within the session; probe missing or changed
  facts only. Determine the OS with `uname -s`, not the existence of `/nix/store`.
- Check `command -v nix` before relying on Nix commands; inspect `nix --version`
  and relevant `nix --help` output when CLI behavior is version-dependent.
- On Linux, inspect `/etc/os-release` to distinguish NixOS from other distros.
- On macOS, distinguish nix-darwin from standalone Nix only when relevant;
  check for `darwin-rebuild`, not just the existence of `/nix`.
- Locate the project configuration (`flake.nix`, `flake.lock`, `shell.nix`,
  `default.nix`, `.envrc`, `devenv.nix`) before selecting a workflow.
- Before composing new commands, inspect relevant recipes in `justfile`,
  `Makefile`, or project scripts and prefer those that fit the task. Check
  their commands and dependencies to distinguish checks and builds from
  formatting, activation, deployment, garbage collection, or disk formatting.
- Detect an active dev shell from its effective tools and environment, not from
  any single environment variable. Avoid entering nested shells needlessly.
- Never assume GNU userland on macOS or FHS paths on NixOS; resolve executables
  through `command -v` and inspect their actual behavior.

## Resolve executables and packages

Use this order:

1. Check the current environment: `command -v TOOL` and `TOOL --version` when safe.
2. If the project defines a dev shell, use its existing workflow, for example
   `nix develop -c TOOL ARGS` (or `direnv exec . TOOL ARGS` if configured).
3. For a one-off tool, prefer the project's pinned nixpkgs input with
   `nix shell` or `nix run` when their semantics fit.
4. Fall back to registry references such as `nixpkgs#PACKAGE` only when no
   suitable pinned project input is available. State when the reference
   resolves outside the project lock.
5. Modify declared project dependencies only when the task requires a persistent
   change. Do not use `nix profile install`, `nix-env -i`, `brew install`,
   `apt install`, or `sudo` just to satisfy a one-off tool requirement.

- Do not scan or grep all of `/nix/store` to find an executable. Store directory
  names are implementation details and may represent multiple package versions.
- To inspect an installed tool's location, use `command -v TOOL` and
  `readlink`/`realpath` as supported by the current OS.
- To discover a package by name, use `nix search nixpkgs QUERY` when appropriate.
  If `nix-locate` is already available, it can help find packages providing a
  particular file; do not assume it is installed or its database populated.
- To inspect a specific package output, use `nix build --no-link INSTALLABLE`
  followed by `nix path-info INSTALLABLE` as appropriate. Building can fetch or
  compile dependencies; do not assume a command is read-only merely because it
  does not produce a `result` symlink.
- Do not hard-code `/nix/store/<hash>-...` paths in project configuration,
  generated scripts, or documentation. Use Nix references or discovered paths.

## Flakes and reproducibility

- Inspect relevant output definitions and locked inputs before changing outputs.
  Use `nix flake show` when output discovery is needed, rather than as a routine check.
- Preserve `flake.lock` unless the requested change requires a lock update.
  Never run `nix flake update` as a routine troubleshooting step.
- Local Git-backed flakes generally only include Git-tracked files. When a new
  file is absent during evaluation, check `git status --short` and whether Git
  knows about the file. Stage only the necessary file if permitted; do not
  commit changes without authorization.
- Prefer existing project inputs, overlays, package sets, and platform-specific
  branches. Avoid introducing a second nixpkgs source unnecessarily.
- Check `builtins.currentSystem`, `system`, `stdenv.hostPlatform`, and cross
  compilation context only where relevant; do not assume `x86_64-linux`.
- Avoid `--impure`, `--override-input`, `--extra-experimental-features`,
  `--option sandbox false`, or changing substituters without a clear reason.
  Explain why such overrides are needed and keep them command-scoped.

## Diagnose before changing

- For effective NixOS settings, prefer `nix eval --json .#ATTRIBUTE`, using
  `--apply` to project the relevant fields. Avoid serializing an entire `config`
  or module option set: unrelated or removed options can fail evaluation.
  Prefer flake attribute selection over constructing `builtins.getFlake`
  expressions that need impurity for an unlocked local reference.
- Read locked module/package/CLI sources when evaluation cannot explain behavior
  such as installer handoff or shell hooks. Search relevant symbols first, then
  read bounded surrounding code; reuse source paths already discovered.
- Use `nix flake check --no-build` for evaluation-level checks where supported;
  build the relevant outputs or checks when required by the task.
- Keep verbose build logs in a local file and return the relevant errors/context.
  Use `nix log INSTALLABLE` for the failing derivation; follow dependency failures
  to the original error before changing a package set or adding an override.
- If concurrent evaluation reports a busy Nix SQLite cache, let the existing
  evaluation finish and retry sequentially; do not disable caching as a first fix.
- Distinguish evaluation errors, missing attributes, unsupported platforms,
  sandbox restrictions, failed downloads/substitutions, build failures,
  and runtime failures. Do not treat them as equivalent.
- Distinguish the agent's execution sandbox from Nix's build sandbox. Permission
  errors in Nix caches or at the daemon socket do not justify `sudo` or disabling
  Nix build sandboxing. When an authorized operation needs broader access, use
  the execution environment's approval mechanism instead of changing Nix or
  project settings to bypass the restriction.
- Use `nix path-info --closure-size` for closure analysis and
  `nix why-depends ROOT DEPENDENCY` when tracing runtime store references.
- Check for shell pollution, architecture mismatches, and macOS versus GNU
  utility differences before changing dependencies.

## System changes and safety

- Treat evaluation, build, activation, and boot configuration changes as
  separate operations. Prefer validating without activation.
- On NixOS, use `nixos-rebuild build --flake PATH#HOST` for a system build;
  `test`, `switch`, and `boot` alter system state and require authorization.
- With nix-darwin, use `darwin-rebuild build --flake PATH#HOST` for a build;
  `switch` activates the result and requires authorization.
- For Home Manager, inspect the actual installation/workflow rather than
  assuming standalone `home-manager switch` is used.
- Never run garbage collection, delete generations, repair the store, alter
  trust settings, or change substituters automatically.
- Avoid `sudo` unless a specifically authorized task requires it.
- Treat Nix store outputs as immutable. Fix source expressions and rebuild,
  rather than editing files under `/nix/store`.
- Never expose tokens or credentials through Nix expressions, build logs,
  command arguments, or generated derivations; do not embed secrets in store
  outputs, which may be readable by other users.

## Reporting

- State which environment and configuration were actually detected.
- Give the exact relevant command and whether it only evaluated, built, or
  activated something.
- Distinguish existing project dependencies from temporary tools fetched via
  Nix, and disclose any unpinned or network-dependent operation.
- When a command fails, report its failure class and evidence before proposing
  a persistent configuration change.
