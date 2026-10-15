Implemented the S1 editorial reading shell.

- Added shared editorial tokens/primitives in `lib/core/design/editorial_design.dart`.
- Redesigned Home, Saved News, Article, Search, and the three-item floating navigation.
- Kept Profile reachable via the Home masthead action.
- Replaced the obsolete counter test with three Firebase-free editorial widget tests.
- Repaired local analyzer issues in the required feature scope.
- Did not modify dependencies, lockfile, auth, assets, or out-of-scope systems.

Validation:

- `flutter analyze … test` — exit 0, no issues.
- `flutter test` — exit 0, 3 passed.
- `flutter build web` — exit 0.

Model: requested unspecified; actual inherited `gpt-5.4`, high reasoning.

Remaining risk: no runnable-browser screenshot capture was available here, so the reference comparison was reviewed from the supplied image and implemented structurally, but not scored through a visual screenshot verdict. No Hermes review/final stage was claimed.