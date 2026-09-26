# Task Packet: S2-auth-refinement

## Task ID

`S2-auth-refinement`

## Objective

Refine Login and Sign Up as one bounded authentication-presentation behavior cluster so both screens match the approved editorial news design while preserving all existing Cubit/use-case/repository behavior.

## Current project state

This packet may run only after S1 has a Hermes `passed` verdict. Re-read the actual S1 design primitives and do not duplicate them.

## Prerequisites

- S1 review passed.
- Shared editorial tokens/primitives exist under `lib/core/design/`.

## Previously completed work

- Editorial visual system, app shell, and reading surfaces from S1. Use its review evidence and current source as the contract.

## Exact repository path

`C:\Users\Hp\OneDrive\Documents\Projects\MindFeed\MindFeed-main`

## Relevant files and directories

- `.impeccable.md` and `docs/orchestration/plan.md` — design contract.
- `lib/core/design/` — S1 shared tokens/primitives; read-only in this task.
- `lib/core/widgets/custom_button.dart` and `custom_text_field.dart` — current auth form primitives.
- `lib/features/auth/presentation/views/` — login/signup shells.
- `lib/features/auth/presentation/widgets/` — auth composition and fields.
- `test/` — add/update auth presentation tests.

## Allowed edit scope

- `lib/core/widgets/custom_button.dart`
- `lib/core/widgets/custom_text_field.dart`
- `lib/features/auth/presentation`
- `test`

## Files or systems that must not be modified

- Everything outside the allowed edit scope.
- `lib/core/design/` (reuse, do not change).
- Auth data, domain, repositories, Cubits, routes, Firebase configuration, package manifests/lockfile, Git state, and orchestration state.

## Implementation requirements

1. Build a reusable auth presentation scaffold inside `lib/features/auth/presentation/widgets/` that extends the S1 ink/cream/pastel language rather than creating a second design system.
2. Login and signup must have clear editorial masthead/eyebrow, confident heading, concise supporting copy, warm cream form surface, dark ink controls, and restrained pastel depth. No gradient button.
3. Preserve existing form values on validation/API errors, keep current Cubit/use-case calls, and remove the duplicate local “Login successful” snackbar so success feedback occurs once.
4. Improve field contracts: semantic labels, correct keyboard/autofill hints, password visibility toggle, visible focus/error states, stable controllers, and no immutable-widget warnings.
5. Keep forms scrollable above the keyboard, respect SafeArea, support 320px-wide screens and large text, and ensure all primary controls are at least 44px high.
6. Preserve password requirements and signup validation, but present them compactly and accessibly within the shared surface.
7. Reuse S1 tokens/primitives by import; do not duplicate palette/radius constants.
8. Add focused widget tests for Login and Sign Up that inject the required Cubits with fakes/mocks only if possible using existing dependencies. At minimum prove both presentation bodies render the expected labels and remain overflow-free at a small viewport without performing network calls.
9. Keep analyzer output clean for changed files and do not install packages.

## Acceptance criteria

- [ ] Login and Sign Up unmistakably belong to the same product as S1.
- [ ] Existing authentication submission paths and validation remain intact.
- [ ] Duplicate login success snackbar is removed.
- [ ] Fields expose accessible labels, visibility controls, focus/error states, and appropriate autofill/keyboard hints.
- [ ] Small-screen auth widget tests pass without network/Firebase calls.
- [ ] No domain/data/Cubit/dependency file is modified.
- [ ] Focused analyzer and full test commands exit 0.

## Exact focused test commands

```text
flutter analyze lib/core/widgets/custom_button.dart lib/core/widgets/custom_text_field.dart lib/features/auth/presentation test
flutter test
```

## Exact broader validation commands

```text
flutter build web
```

## Known failures

None expected after S1. Stop if S1 is not passed or current source conflicts with this packet.

## Stop conditions

Stop and report without widening permissions when:

- The approved architecture cannot satisfy the requirement.
- A required operation is denied by workspace-write/approval-never.
- Credentials, destructive data operations, package installation, or external side effects would be required but are not explicitly authorized.
- The task would require edits outside the allowed scope.
- The working tree materially differs from this packet.

## Safety constraints

- Work only inside the exact repository and allowed edit scope.
- Preserve all pre-existing user changes.
- Do not read `.env`, `.antigravitycli`, Firebase files, credential stores, token files, keychains, cloud profiles, or authentication material; do not print secrets/environment values.
- Do not commit, push, reset, rebase, stash, switch/delete branches, or rewrite history.
- Do not install/upgrade packages.
- Do not perform destructive database/storage operations.
- Do not reformat or clean unrelated files.

## Required final report

Report requested/actual model and reasoning, files inspected/changed, commands with exit codes, tests/builds, failures, risks, and whether every acceptance criterion is proven. Never claim Hermes review or final stage completion.
