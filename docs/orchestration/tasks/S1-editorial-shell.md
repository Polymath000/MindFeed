# Task Packet: S1-editorial-shell

## Task ID

`S1-editorial-shell`

## Objective

Implement one bounded, independently reviewable editorial reading shell: shared visual tokens/primitives plus the Home/Trending, Saved News, Article, Search, and main navigation presentation needed to match the supplied news UI reference.

## Current project state

- Repository is an initialized but commit-less Git work tree; all source files are pre-existing untracked content.
- Read `docs/orchestration/plan.md`, `.impeccable.md`, and inspect `docs/orchestration/reference/target-news-ui.jpg` before editing.
- Baseline `flutter analyze` exits 1 with 35 existing issues; issues within this task’s edit scope should be fixed, but unrelated features must not be cleaned up.
- Baseline `flutter test` exits 1 because `test/widget_test.dart` is the obsolete Flutter counter template.
- `pubspec.lock` was changed by Hermes’s baseline dependency resolution before dispatch; do not edit it.

## Prerequisites

- Reference image copied inside the repository.
- Flutter 3.41.3 and Dart 3.11.1 are available.
- Architecture and visual contract are explicit in `docs/orchestration/plan.md` and `.impeccable.md`.

## Previously completed work

None. This is the first executor stage.

## Exact repository path

`C:\Users\Hp\OneDrive\Documents\Projects\MindFeed\MindFeed-main`

## Relevant files and directories

- `docs/orchestration/plan.md` — approved visual and architecture contract.
- `docs/orchestration/reference/target-news-ui.jpg` — visual source of truth.
- `lib/config/themes/` — current Material theme wrappers.
- `lib/core/widgets/` — existing shared widgets; avoid auth-specific rewrites in this stage.
- `lib/features/home/` — home feed and article view.
- `lib/features/collections/` — saved-news surface.
- `lib/features/main/` — main shell and navigation.
- `lib/features/search/` — search destination.
- `test/widget_test.dart` — obsolete test to replace.

## Allowed edit scope

- `lib/config/themes`
- `lib/core/design`
- `lib/core/widgets/custom_app_bar.dart`
- `lib/core/widgets/search_bar.dart`
- `lib/features/home`
- `lib/features/collections`
- `lib/features/main`
- `lib/features/search`
- `lib/config/routes/on_generate_routes.dart`
- `test`

## Files or systems that must not be modified

- Everything outside the allowed edit scope.
- `pubspec.yaml` and `pubspec.lock`.
- `lib/features/auth/` (reserved for S2).
- Git history, branches, remotes, credentials, and orchestration state.
- `.antigravitycli/`, Firebase configuration, `.vscode/`, platform folders, generated localization files, and assets.

## Implementation requirements

1. Create a compact immutable editorial design system under `lib/core/design/` with named palette, spacing, radii, elevation, and reusable circular/pill controls. Use warm cream, ink, muted butter, blush, powder blue, and lilac; avoid pure black/white where practical.
2. Align `ThemeConfig`/theme wrappers to the editorial tokens without breaking light/dark support. Do not add a dependency or reference an unavailable font asset. Use a deliberate platform-safe sans fallback and a strong fixed app-UI type scale.
3. Redesign Home as a dark trending-news shell with brand masthead, topic tabs, a dominant warm lead card, visible pastel layered stories, author/follow metadata, summary, and like/save/share controls. Use immutable demo data instead of ten repeated literals.
4. Redesign Saved News as a dark page with title, search field, and overlapping pastel typographic cards inspired by the reference.
5. Redesign Article View as a warm cream reading surface with back control, large headline, timestamp, author/follow row, readable body copy, rounded existing editorial image, and floating like/save/share controls.
6. Replace the generic four-item navigation with a floating Home/Search/Saved control matching the reference. Preserve access to Profile via an explicit masthead/utility action. Keep route behavior coherent.
7. Bring Search into the same visual system so the navigation destination is not visibly inconsistent.
8. Keep presentation composition in feature directories and shared visual primitives in `lib/core/design/`. Do not move or alter domain/data/auth behavior.
9. Use semantic labels/tooltips, visible pressed/focus states, at least 44 logical-pixel touch targets, safe areas, constrained wide layouts, large-text resilience, and `MediaQuery.disableAnimations`/equivalent reduced-motion awareness.
10. Replace the obsolete counter test with focused widget tests that prove core editorial motifs and navigation render without exceptions at representative small and standard phone sizes. Do not require Firebase initialization in widget tests.
11. Remove new analyzer warnings in changed files. Correct existing warnings only when they are in files you must edit and the correction is local.
12. Do not use bounce/elastic motion, gradient text, glassmorphism, or generic blue-purple tech gradients.

## Acceptance criteria

- [ ] Home visibly implements the supplied reference’s dark shell, warm lead card, pastel depth, oversized headline, and circular actions.
- [ ] Saved News implements a dark search header and a layered pastel story deck.
- [ ] Article implements the warm reading canvas and reference hierarchy.
- [ ] Main navigation exposes Home, Search, and Saved in a floating pill; Profile remains reachable.
- [ ] Search is visually coherent.
- [ ] Shared tokens/primitives are centralized and feature composition remains separated.
- [ ] Small-screen and large-text widget tests pass.
- [ ] No dependency or non-scope file is modified.
- [ ] Focused analyzer command exits 0.
- [ ] Full `flutter test` exits 0.

## Exact focused test commands

```text
flutter analyze lib/config/themes lib/core/design lib/core/widgets/custom_app_bar.dart lib/core/widgets/search_bar.dart lib/features/home lib/features/collections lib/features/main lib/features/search lib/config/routes/on_generate_routes.dart test
flutter test
```

## Exact broader validation commands

```text
flutter build web
```

## Known failures

- Baseline full analyze: 35 issues, including unrelated files.
- Baseline test: obsolete counter template fails with missing `ThemeModeCubit` and nonexistent counter widgets.

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
- Do not read `.env`, `.antigravitycli`, Firebase credential/config files, token stores, keychains, cloud profiles, or authentication material; do not print secrets/environment values.
- Do not commit, push, reset, rebase, stash, switch/delete branches, or rewrite history.
- Do not install/upgrade packages.
- Do not perform destructive database/storage operations.
- Do not reformat or clean unrelated files.

## Required final report

Report requested/actual model and reasoning, files inspected/changed, commands with exit codes, tests/builds, failures, risks, and whether every acceptance criterion is proven. Never claim Hermes review or final stage completion.
