# MindFeed Editorial UI Transformation Plan

## Goal

Transform the existing Flutter UI into a coherent editorial news experience matching `reference/target-news-ui.jpg`, then carry the same visual system into login and signup without disturbing authentication domain/data behavior.

## Reference UI description

The supplied composition shows three iPhone screens against a muted blue-gray studio backdrop.

- **Overall system:** a high-contrast mobile news product. Primary surfaces are ink black and warm butter/cream. Story layers add pale blush, powder blue, and lilac. The palette is sparse and memorable rather than evenly distributed.
- **Typography:** oversized, heavy geometric sans headlines with tight line height and strong black/cream contrast. Supporting metadata is small and quiet; article body copy is compact but readable. Hierarchy comes primarily from scale and weight, not decoration.
- **Home/trending screen:** an ink-black shell with a compact brand masthead (`Z News` in the reference), a circular utility button, and horizontally arranged topic tabs. A dominant cream story card floats above partially visible pastel cards, implying a swipeable or stacked feed. The lead card has a tiny red `LIVE` capsule, large truncated headline, timestamp, author avatar/byline, a dark `Follow` pill, summary copy, and circular like/save/share actions. A floating bottom control uses three overlapping dark circular buttons; the active destination is a light circle with a dark icon.
- **Saved screen:** an ink-black page with circular back control, bold `Saved News` title, and a dark rounded search field. Saved stories appear as a vertical deck of large overlapping pastel cards, each mostly typographic. The visible overlaps make the collection feel tactile and sortable rather than like a generic list.
- **Article screen:** a warm cream full-page reading surface. A translucent circular back control sits above a very large multi-line headline, subdued update time, avatar/byline, and compact dark `Follow` pill. Body copy follows directly, then a large rounded editorial image. Like/save/share actions float as dark circles over the image edge.
- **Geometry and spacing:** generous 16–24px page gutters, 20–28px card radii, 44–52px circular controls, tight but consistent internal spacing, and intentional overlap. Corners are soft but not bubbly.
- **Motion/interaction:** implied card depth and swipe/scroll movement; controls should respond quickly with restrained 150–250ms transitions and no bounce. Respect reduced-motion settings.
- **Responsive intent:** preserve the single-column mobile composition from roughly 320–600 logical pixels. On wider canvases, constrain the content rather than stretching headlines and cards indefinitely.

## Architecture decisions

1. Add a small shared editorial design layer under `lib/core/design/` for palette, spacing, radii, and reusable primitives. Do not embed feature data or navigation in it.
2. Keep feature-specific composition under each feature’s `presentation/` directory.
3. Preserve existing BLoC/use-case/repository boundaries and route names.
4. Use existing dependencies and bundled assets only; no package installation or upgrades.
5. Prefer immutable data fixtures/models for UI demo content over repeated literal widget trees.
6. Replace the obsolete counter test with focused widget/contract tests for the redesigned surfaces.

## Stages

### S1 — Editorial reading shell

Scope: shared editorial tokens/primitives, theme alignment, home/trending, saved news, article reading surface, search alignment, main navigation, and focused widget tests.

Acceptance:
- Home, saved, and article surfaces visibly implement the reference palette, hierarchy, card depth, and floating circular controls.
- Main navigation is a floating three-destination editorial pill for Home, Search, and Saved; profile remains accessible from the masthead/utility action rather than a fourth generic tab.
- All essential controls have semantics and >=44px targets.
- Layout remains usable at 320, 390, and 600 logical pixels and with large text.
- No new dependency is added.
- `flutter analyze` on the changed editorial scope exits 0.
- `flutter test` exits 0.

### S2 — Auth refinement

Scope: login/signup presentation and auth-specific/shared form primitives only.

Acceptance:
- Login and signup feel native to the same ink/cream/pastel editorial system.
- Forms retain existing Cubit/use-case behavior and validation, preserve input on errors, expose useful labels, password visibility, loading, and focus states.
- Layout remains keyboard-safe and scrollable on small devices.
- Duplicate success UI and obvious presentation defects are removed without editing auth domain/data layers.
- Focused analyze and `flutter test` exit 0.

## Final validation

Hermes will independently run:

```text
flutter analyze lib/config/themes lib/core/design lib/core/widgets lib/features/home lib/features/collections lib/features/main lib/features/search lib/features/auth/presentation test
flutter test
flutter build web
```

Hermes will also launch the app in Chrome, inspect the rendered home/login/signup/article routes where feasible, and capture the final viewport evidence.

## Baseline evidence

- Repository arrived without `.git`; Hermes initialized a local Git work tree solely to satisfy the bounded executor and preserve pre/post evidence. No commit was created.
- All project files are therefore pre-existing untracked files.
- `flutter analyze` initially exited 1 with 35 existing issues.
- The obsolete default counter widget test initially exited 1 because `MyApp` requires `ThemeModeCubit` and the test expected a counter UI that does not exist.
- The baseline analyze resolved dependencies and updated three locked transitive versions in `pubspec.lock`; this occurred before executor dispatch and is pre-existing dirty state.
