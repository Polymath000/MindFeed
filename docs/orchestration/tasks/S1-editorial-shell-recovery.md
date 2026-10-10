# Continuation Packet: S1-editorial-shell-recovery

## Task ID

`S1-editorial-shell-recovery`

## Previous execution

- Run state: `C:\Users\Hp\OneDrive\Documents\Projects\MindFeed\MindFeed-main\docs\orchestration\runs\S1-editorial-shell.json`
- Prior task: `S1-editorial-shell`
- Hermes review: `docs/orchestration/results/S1-editorial-shell-review.md`

## Model and reasoning

- Previous: `gpt-5.6-terra/low`
- Continuation: `gpt-5.6-terra/medium`
- Escalation reason: `low_incomplete`

## Exit condition

The prior executor exited 0 and static gates passed, but Hermes blocked review because the full Main shell renders a blank body, the release web artifact throws `Unsupported operation: InternetAddress` before the first frame, saved cards lack the target's layered treatment, and the prior run changed `docs/orchestration/state.md` outside its lease.

## Completed work

- Shared editorial palette, spacing, radii, icon, and follow-button primitives exist.
- Home, Article, Saved, Search, and three-item navigation use the target's ink/cream/pastel visual language.
- Focused analyzer, three widget tests, and web build currently exit 0.
- The original counter test was replaced with Firebase-free editorial widget tests.

## Files modified

- See the verified `executor_changed_files` list in `runs/S1-editorial-shell.json`.
- Do not repeat broad discovery or redesign the completed theme, Home, Article, or Search work.

## Tests already passing

- Focused packet analyzer — exit 0, evidence `docs/orchestration/results/S1-editorial-shell-validation.json`.
- `flutter test` — exit 0, 3 tests, same evidence.
- `flutter build web` — exit 0, same evidence.

## Current failures

1. `MainNavigationBar` is installed as `Scaffold.bottomNavigationBar` but wraps its fixed control in an unconstrained `Center`. In the 390×844 full-shell render, the navigation consumes the body allocation, appears around the vertical center, and the Home surface is blank. Evidence: `docs/orchestration/results/S1-main-390x844.png`.
2. A release-web runtime smoke reaches Firebase and Hive, then throws `Unsupported operation: InternetAddress` while `setupServiceLocator()` constructs `DataConnectionChecker`. No first frame renders. Evidence: `docs/orchestration/results/S1-home-release-390x844.png` and the exact CDP exception recorded in the prior Hermes review.
3. Saved News uses simple contiguous full-width cards. Refine only this view so the stack more closely matches the supplied reference's overlapping, slightly offset/angled editorial sheets while remaining readable and scrollable at 320px and with large text.

## Unverified claims

- A successful `flutter build web` does not prove the app starts in a browser.
- The prior executor's route claim of `gpt-5.4`/high is rejected; the runner proves `gpt-5.6-terra`/low.
- Image decode and action overlays in a real release browser remain unproven because startup fails first.

## Continuation objective

Repair the two runtime/layout blockers and tighten the Saved News stack so the already-built S1 editorial shell is actually usable and visually faithful without redesigning completed surfaces.

## Exact remaining work

1. Constrain the bottom navigation to its intended bottom footprint. At 390×844, Home content must paint from the top and the navigation must sit near the bottom without covering the primary card; controls remain at least 44×44.
2. Add a regression widget test that pumps the full `MainView` at 390×844 and proves `Z News` paints in the upper region and the Home navigation control paints in the lower region. Finder presence alone is insufficient; assert render positions/bounds.
3. Refactor network-status registration behind the existing `NetworkInfo` abstraction so `setupServiceLocator()` does not instantiate `DataConnectionChecker` on web. Use clean conditional/platform composition without adding packages, exposing credentials, or changing auth domain/API behavior. Do not hard-code “online” when the browser can expose an appropriate connectivity signal with existing SDK APIs; if a clean SDK-only signal is impractical, stop and report rather than conceal the limitation.
4. Add a focused web-platform test that initializes the service locator and proves no `InternetAddress` exception occurs. Make cleanup deterministic so the test can run with the full suite.
5. Refine the existing Saved News view into a controlled layered editorial stack closer to `docs/orchestration/reference/target-news-ui.jpg`: restrained overlap and slight variation, readable text, no accidental clipping, stable scrolling, 320px support, and no generic card-grid redesign.
6. Run every listed validation command and report exact exit codes.

## Exact files to inspect

- `lib/features/main/presentation/views/main_view.dart`
- `lib/features/main/presentation/widgets/main_navigation_bar.dart`
- `lib/features/collections/presentation/views/articles_saved.dart`
- `lib/core/network/network_info.dart`
- `lib/core/helpers/setup_service_locator.dart`
- `lib/features/auth/data/repos/auth_repo_impl.dart` (read-only contract)
- `test/widget_test.dart`

## Allowed edit scope

- `lib/features/main/presentation/views/main_view.dart`
- `lib/features/main/presentation/widgets/main_navigation_bar.dart`
- `lib/features/collections/presentation/views/articles_saved.dart`
- `lib/core/network`
- `lib/core/helpers/setup_service_locator.dart`
- `test`

## Exact validation commands

```text
flutter analyze lib/features/main/presentation/views/main_view.dart lib/features/main/presentation/widgets/main_navigation_bar.dart lib/features/collections/presentation/views/articles_saved.dart lib/core/network lib/core/helpers/setup_service_locator.dart test
flutter test
flutter test --platform chrome test/web_service_locator_test.dart
flutter build web
```

## Areas that must not be redesigned

- Shared editorial tokens and ThemeConfig.
- Home, Article, Search, routes, auth data/domain/API behavior, Firebase configuration, assets, dependencies, and package lockfile.
- Do not change orchestration files, including this packet and `docs/orchestration/state.md`.

## Safety constraints

- Work only inside the exact repository and allowed edit scope.
- Preserve all pre-existing work.
- Do not read `.env`, `.antigravitycli`, Firebase files, credential stores, token files, keychains, cloud profiles, or authentication material; do not print secrets/environment values.
- Do not commit, push, reset, rebase, stash, switch/delete branches, or rewrite history.
- Do not install or upgrade packages.
- Do not perform destructive database/storage operations.
- Do not reformat or clean unrelated files.

## Stop conditions

Stop if the continuation needs broader scope, a second automatic recovery, destructive/external action, credentials, package installation, or a changed architecture.

## Required final report

Use `execution-result.md` and distinguish preserved prior work from new continuation work. Report requested/actual model and reasoning, exact files changed, every validation command and exit code, remaining failures, and whether each continuation requirement is proven. Never claim Hermes review or stage completion.
