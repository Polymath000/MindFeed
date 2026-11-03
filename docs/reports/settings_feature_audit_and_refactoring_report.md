# Settings Feature Architectural Audit & Refactoring Blueprint Report

**Document Type:** Feature Audit & Refactoring Blueprint  
**Target Module:** [`lib/features/settings/`](/mind_feed/lib/features/settings/)  
**Baseline Commit:** `c970aa1` (`HEAD`)  
**Date:** November 3, 2026  

---

## 1. Executive Summary

This report presents a comprehensive architectural, functional, and UX audit of the **Settings & Preferences** feature ([`lib/features/settings/`](/mind_feed/lib/features/settings/)) and its cross-cutting integrations across routing ([`app_routes.dart`](/mind_feed/lib/config/routes/app_routes.dart)), dependency injection ([`setup_service_locator.dart`](/mind_feed/lib/core/utls/setup_service_locator.dart)), authentication ([`lib/features/auth/`](/mind_feed/lib/features/auth/)), user profiles ([`lib/features/profile/`](/mind_feed/lib/features/profile/)), and the article reader ([`lib/features/article/`](/mind_feed/lib/features/article/)).

To establish a clear, low-risk refactoring roadmap, every component on the Settings page has been audited and classified into four actionable categories:
1. **Keep & Do Not Touch:** Production-ready components and end-to-end flows that already function reliably.
2. **Remove:** Dead code files, unreferenced bottom sheets, static mockup tiles, and placebo toggles that have no backing engine in the application.
3. **Make Work (Wire Up & Fix):** Partially implemented controls and broken navigation stack transitions that either fail to apply preferences in target views or disrupt the user's navigation stack.
4. **Enhance (Architecture, Performance & UX):** Clean Architecture layer separation, pure domain contracts, immutable `copyWith` state transitions, scoped `BlocSelector` rebuild isolation, and reusable dialog extraction.

---

## 2. Current vs. Target Architecture Overview

```mermaid
flowchart TD
    subgraph Current["Current Architecture (Baseline)"]
        SVB["SettingsViewBody\n(Single Full-Page BlocBuilder)"] --> SC["SettingsCubit"]
        SVB --> TMC["ThemeModeCubit\n(Unregistered in GetIt)"]
        SC -->|"Layer Violation: Direct Static Access"| SPS["SharedPreferencesSingleton\n(7 Raw Preference Keys)"]
        SC --> GSP["GetSettingsProfileUseCase"]
        GSP -->|"Domain Impurity: Static Singleton"| CUS["CurrentUserSession & SupabaseStorageService"]
        SVB -->|"Breaks Stack: pushNamedAndRemoveUntil('/')"| CAT["CategoriesView"]
        SVB -->|"Logs User Out: pushNamedAndRemoveUntil('/login')"| CPW["ChangePasswordView"]
    end

    subgraph Target["Target Refactored Architecture"]
        TSVB["SettingsViewBody\n(Scoped BlocSelectors per Section)"] --> TSC["SettingsCubit"]
        TSVB --> TTMC["ThemeModeCubit\n(Registered in GetIt)"]
        TSC --> RPU["Get/UpdateReaderPreferencesUseCase"]
        RPU --> SREPO["SettingsRepository (Domain Contract)"]
        SREPO --> SLDS["SettingsLocalDataSource\n(SharedPreferences)"]
        TSVB -->|"Modal Mode: Navigator.pop(context)"| TCAT["CategoriesView (isFromSettings: true)"]
        TSVB -->|"In-Session Mode: Navigator.pop(context)"| TCPW["ChangePasswordView (isFromSettings: true)"]
    end
```

---

## 3. Comprehensive Inventory & 4-Pillar Classification Matrix

| # | Component / Setting | Location | Current Status | Classification | Action Plan |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 1 | [`SettingsHeaderBanner`](/mind_feed/lib/features/settings/presentation/widgets/settings_account_card.dart#L7-L50) | `settings_account_card.dart` | Functional | **Keep & Don't Touch** | Preserve header layout and back navigation. |
| 2 | [`SettingsAccountCard`](/mind_feed/lib/features/settings/presentation/widgets/settings_account_card.dart#L52-L146) | `settings_account_card.dart` | Functional | **Keep & Don't Touch** | Preserve profile avatar, display name, email, and `ACTIVE` badge. |
| 3 | **Offline Reading Archive (Clear Cache)** | [`settings_archive_section.dart`](/mind_feed/lib/features/settings/presentation/widgets/settings_archive_section.dart#L39-L59) | Functional | **Keep & Don't Touch** | Preserve Hive offline article byte calculation and `Clear Cache` action. |
| 4 | **Editorial Ethics & Privacy Charter** | [`settings_dialogs.dart`](/mind_feed/lib/features/settings/presentation/widgets/settings_dialogs.dart#L4-L54) | Functional | **Keep & Don't Touch** | Preserve charter manifest bottom sheet. |
| 5 | **Sign Out of Edition** | [`settings_view_body.dart`](/mind_feed/lib/features/settings/presentation/widgets/settings_view_body.dart#L14-L26) | Functional | **Keep & Don't Touch** | Preserve `LogoutUseCase` execution and route stack reset to `/login`. |
| 6 | **Edition Brand Footer** | [`settings_archive_section.dart`](/mind_feed/lib/features/settings/presentation/widgets/settings_archive_section.dart#L109-L133) | Functional | **Keep & Don't Touch** | Preserve static publication footer. |
| 7 | **Audio Narration Cadence Tile** | [`settings_reading_section.dart`](/mind_feed/lib/features/settings/presentation/widgets/settings_reading_section.dart#L99-L121) | Mock Snackbar | **Remove** | Delete tile; no TTS package or audio synthesis engine exists in the app. |
| 8 | **Dispatches & Editorial Alerts Section** | [`settings_reading_section.dart`](/mind_feed/lib/features/settings/presentation/widgets/settings_reading_section.dart#L79-L124) | Placebo Toggles | **Remove** | Remove `Morning Edition Briefing` & `Investigative Breaking Alerts` (no push/cron backend exists). |
| 9 | **Bionic Reading Guide Toggle** | [`settings_reading_section.dart`](/mind_feed/lib/features/settings/presentation/widgets/settings_reading_section.dart#L69-L76) | Placebo Toggle | **Remove** | Remove `pref_bionic_guide` toggle and state field; no bionic parser exists. |
| 10 | **Data Preservation & Wi-Fi Only Toggles** | [`settings_archive_section.dart`](/mind_feed/lib/features/settings/presentation/widgets/settings_archive_section.dart#L60-L75) | Placebo Toggles | **Remove** | Remove `pref_data_preservation` and `pref_wifi_only` toggles; unreferenced by network/downloaders. |
| 11 | **Legacy `settings_menu.dart` & Unused Sheets/Tiles** | [`settings_menu.dart`](/mind_feed/lib/features/settings/presentation/widgets/settings_menu.dart#L1-L116) | Dead Code (0 refs) | **Remove** | Delete `settings_menu.dart`, `showDigestPickerSheet`, `showEditProfileSheet`, `SettingsValueTile`, `SettingsSliderTile`. |
| 12 | **Typeface Scale (`pref_font_scale`)** | [`settings_reading_section.dart`](/mind_feed/lib/features/settings/presentation/widgets/settings_reading_section.dart#L53-L60) | Unwired Preference | **Make Work** | Wire `pref_font_scale` (`Compact`, `Standard`, `Editorial`, `Large`) into [`ArticleReaderMarkdownBody`](/mind_feed/lib/features/article/presentation/widgets/article_reader_markdown_body.dart#L20-L71). |
| 13 | **Serif Literary Immersion (`pref_serif_mode`)** | [`settings_reading_section.dart`](/mind_feed/lib/features/settings/presentation/widgets/settings_reading_section.dart#L61-L68) | Unwired Preference | **Make Work** | Wire `pref_serif_mode` into [`ArticleReaderMarkdownBody`](/mind_feed/lib/features/article/presentation/widgets/article_reader_markdown_body.dart#L20-L71) to toggle body typography between serif and sans-serif. |
| 14 | **Preferred Categories Navigation** | [`settings_view_body.dart`](/mind_feed/lib/features/settings/presentation/widgets/settings_view_body.dart#L74-L83) | Broken Return Flow | **Make Work** | Support `isFromSettings` in [`CategoriesView`](/mind_feed/lib/features/profile/presentation/views/categories_view.dart) so saving or pressing Back pops back to Settings instead of resetting to `'/'`. |
| 15 | **Change Password Navigation** | [`settings_archive_section.dart`](/mind_feed/lib/features/settings/presentation/widgets/settings_archive_section.dart#L82-L92) | Broken Return Flow | **Make Work** | Support in-session password updates in [`ChangePasswordForm`](/mind_feed/lib/features/auth/presentation/widgets/change_password_form.dart#L36-L46) so saving pops back to Settings instead of forcing re-login. |
| 16 | **Reading Surface Contrast (`ThemeWidget`)** | [`theme_widget.dart`](/mind_feed/lib/features/settings/presentation/widgets/theme_widget.dart#L10-L93) | Partial State Bug | **Make Work** | Emit [`ThemeModeSystem`](/mind_feed/lib/features/settings/presentation/controllers/theme_mode_cubit/theme_mode_state.dart#L20-L22) in [`ThemeModeCubit`](/mind_feed/lib/features/settings/presentation/controllers/theme_mode_cubit/theme_mode_cubit.dart#L13-L39), register in `GetIt`, and bind [`MyApp`](/mind_feed/lib/main_app.dart#L18-L41) directly to cubit state. |
| 17 | **Settings Data Layer & Domain Purity** | [`settings_cubit.dart`](/mind_feed/lib/features/settings/presentation/controllers/settings_cubit/settings_cubit.dart#L34-L81) | Layer Violation | **Enhance** | Extract `SettingsRepository` + `SettingsLocalDataSource`; remove direct `SharedPreferencesSingleton` calls from `SettingsCubit`. |
| 18 | **Cubit State Updates & Rebuild Scope** | [`settings_state.dart`](/mind_feed/lib/features/settings/presentation/controllers/settings_cubit/settings_state.dart#L4-L133) | Verbose / Wide Rebuilds | **Enhance** | Trim dead fields, add `copyWith` on base `SettingsState`, guard all emissions with `if (!isClosed)`, and use scoped `BlocSelector`s. |

---

## 4. Pillar 1: Keep & Do Not Touch (Verified Working Flows)

The following components are well-structured, verified by existing unit tests, and work end-to-end across layers:

1. **Header Banner & Account Summary Card ([`settings_account_card.dart`](/mind_feed/lib/features/settings/presentation/widgets/settings_account_card.dart#L7-L146)):**
   - `SettingsHeaderBanner` provides a responsive back navigation control (`Navigator.maybePop(context)`) and editorial masthead typography.
   - `SettingsAccountCard` renders the user's `EditorialAvatar` (with `cacheWidth` / `cacheHeight` decode bounds), display name, email address, and `ACTIVE` status badge.
2. **Offline Reading Archive Cache Size & Purge ([`get_archive_cache_size_use_case.dart`](/mind_feed/lib/features/settings/domain/usecases/get_archive_cache_size_use_case.dart#L5-L29), [`clear_downloaded_articles_use_case.dart`](/mind_feed/lib/features/settings/domain/usecases/clear_downloaded_articles_use_case.dart#L5-L18)):**
   - Accurately computes total cached bytes across article text, `coverImageBytes`, and `authorAvatarBytes` in Hive (`OfflineArticlesRepository`), formats the size in megabytes, and purges the archive on tap.
3. **Editorial Ethics & Privacy Charter ([`settings_dialogs.dart`](/mind_feed/lib/features/settings/presentation/widgets/settings_dialogs.dart#L4-L54)):**
   - Displays the publication's three core privacy tenets in a clean modal bottom sheet.
4. **Sign Out Flow ([`settings_view_body.dart`](/mind_feed/lib/features/settings/presentation/widgets/settings_view_body.dart#L14-L26), [`logout_use_case.dart`](/mind_feed/lib/features/auth/domain/usecases/logout_use_case.dart#L10-L27)):**
   - Clears offline downloaded articles, signs out of Supabase Auth, purges Hive user cache and session flags (`tokenKey`, `hasCompletedCategoriesKey`), and resets the navigation stack to `AppRoutes.login`.

---

## 5. Detailed Technical Breakdown of Issues (Remove, Make Work & Enhance)

### Issue 1: Placebo Toggles, Unbacked Notification Controls, and Dead Legacy Widgets (Remove)

#### 1. The Architectural Problem / Root Cause
The Settings page currently exposes five interactive switches and one action tile that persist values into `SharedPreferences` (or show a static `SnackBar`) without any corresponding consumer, service, or package in the codebase:
- **Dispatches & Editorial Alerts (`Morning Edition Briefing`, `Investigative Breaking Alerts`, `Audio Narration Cadence`):** `pubspec.yaml` contains no push notification SDK, background task scheduler, or text-to-speech (`flutter_tts`) engine. Tapping `Audio Narration Cadence` merely displays a hardcoded `SnackBar` (`'Audio Narration set to Natural Warm Alto at 1.0x pace'`).
- **Bionic Reading Guide (`pref_bionic_guide`):** No bionic word-anchor markdown parser exists in `lib/features/article/`.
- **Data Preservation Mode (`pref_data_preservation`) & Download on Wi-Fi Only (`pref_wifi_only`):** Neither [`DownloadArticleTextUseCase`](/mind_feed/lib/features/article/domain/usecases/download_article_text_use_case.dart#L21-L65) nor image widgets read these keys.
- **Unreferenced Dead Code:** [`settings_menu.dart`](/mind_feed/lib/features/settings/presentation/widgets/settings_menu.dart#L1-L116) (116 lines), [`showDigestPickerSheet`](/mind_feed/lib/features/settings/presentation/widgets/settings_dialogs.dart#L56-L85), [`showEditProfileSheet`](/mind_feed/lib/features/settings/presentation/widgets/settings_dialogs.dart#L87-L127), [`SettingsValueTile`](/mind_feed/lib/features/settings/presentation/widgets/settings_tile_primitives.dart#L115-L135), [`SettingsSliderTile`](/mind_feed/lib/features/settings/presentation/widgets/settings_tile_primitives.dart#L182-L203), and legacy `PaperSettings*` typedefs ([`settings_tile_primitives.dart`](/mind_feed/lib/features/settings/presentation/widgets/settings_tile_primitives.dart#L205-L208)) have zero references across `lib/` and `test/`.

#### 2. Baseline Implementation Snapshot (Before)
```dart
// BEFORE: lib/features/settings/presentation/widgets/settings_reading_section.dart (Lines 79-123)
SettingsSectionBlock(
  title: 'Dispatches & Editorial Alerts',
  kicker: 'DISPATCHES',
  children: [
    SettingsToggleTile(
      icon: AppIcons.wbSunnyOutlined,
      stampColor: AppColors.butter,
      title: 'Morning Edition Briefing',
      subtitle: 'Curated 7:00 AM daily reading digest delivered quietly',
      value: morningBriefing, // FLAW: Placebo toggle; no notification/digest service exists
      onChanged: onMorningBriefingChanged,
    ),
    SettingsToggleTile(
      icon: AppIcons.notificationsActiveOutlined,
      stampColor: AppColors.blush,
      title: 'Investigative Breaking Alerts',
      subtitle: 'Instant alerts for major global stories and science breakthroughs',
      value: breakingAlerts, // FLAW: Placebo toggle; no push notification SDK exists
      onChanged: onBreakingAlertsChanged,
    ),
    SettingsActionTile(
      icon: AppIcons.volumeUpOutlined,
      stampColor: AppColors.mint,
      title: 'Audio Narration Cadence',
      subtitle: 'Speech synthesis voice for article reading',
      onTap: () {
        // FLAW: Hardcoded mock SnackBar with no TTS engine or selection sheet
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(seconds: 2),
            content: Text('Audio Narration set to Natural Warm Alto at 1.0x pace'),
          ),
        );
      },
    ),
  ],
),
```

#### 3. Refactored Solution (After)
```dart
// AFTER: lib/features/settings/presentation/widgets/settings_reading_section.dart
class SettingsReadingSection extends StatelessWidget {
  final String fontScale;
  final ValueChanged<String> onFontScaleChanged;
  final bool serifMode;
  final ValueChanged<bool> onSerifModeChanged;
  final VoidCallback onTapPreferredCategories;

  const SettingsReadingSection({
    super.key,
    required this.fontScale,
    required this.onFontScaleChanged,
    required this.serifMode,
    required this.onSerifModeChanged,
    required this.onTapPreferredCategories,
  });

  @override
  Widget build(BuildContext context) {
    return SettingsSectionBlock(
      title: 'Reading Experience & Surface',
      kicker: 'CANVAS & TYPE',
      children: [
        const ThemeWidget(),
        SettingsActionTile(
          icon: AppIcons.gridViewRounded,
          stampColor: AppColors.butter,
          title: 'Preferred Categories',
          subtitle: 'Customize topic feeds and editorial recommendations',
          trailing: const Icon(
            AppIcons.arrowForwardIosRounded,
            size: 12,
            color: AppColors.mutedInk,
          ),
          onTap: onTapPreferredCategories,
        ),
        SettingsChoiceChip<String>(
          title: 'Typeface Scale',
          subtitle: 'Adjust comfortable body sizing for reading long articles',
          options: const ['Compact', 'Standard', 'Editorial', 'Large'],
          selectedOption: fontScale,
          onChanged: onFontScaleChanged,
          labelBuilder: (s) => s,
        ),
        SettingsToggleTile(
          icon: AppIcons.menuBookOutlined,
          stampColor: AppColors.lilac,
          title: 'Serif Literary Immersion',
          subtitle: 'Render longform stories in classic editorial serif typography',
          value: serifMode,
          onChanged: onSerifModeChanged,
        ),
      ],
    );
  }
}
```

#### 4. Summary of Changes & Engineering Rationale
- **What will be changed:** Remove the `Dispatches & Editorial Alerts` block (`Morning Edition Briefing`, `Investigative Breaking Alerts`, `Audio Narration Cadence`), `Bionic Reading Guide`, `Data Preservation Mode`, `Download on Wi-Fi Only`, their 5 corresponding fields/setters in [`SettingsCubit`](/mind_feed/lib/features/settings/presentation/controllers/settings_cubit/settings_cubit.dart) and [`SettingsState`](/mind_feed/lib/features/settings/presentation/controllers/settings_cubit/settings_state.dart), delete [`settings_menu.dart`](/mind_feed/lib/features/settings/presentation/widgets/settings_menu.dart), and prune unused functions/widgets in [`settings_dialogs.dart`](/mind_feed/lib/features/settings/presentation/widgets/settings_dialogs.dart) and [`settings_tile_primitives.dart`](/mind_feed/lib/features/settings/presentation/widgets/settings_tile_primitives.dart).
- **Why it should be changed:** Eliminates ~320 lines of dead code and removes deceptive UI controls that promise functionality not present in the application.
- **Why the solution is safe and correct:** Zero external features read these five preference keys or import the dead widget files.

---

### Issue 2: Unwired Reader Typography Preferences (`Typeface Scale` & `Serif Literary Immersion`) (Make Work)

#### 1. The Architectural Problem / Root Cause
In [`SettingsReadingSection`](/mind_feed/lib/features/settings/presentation/widgets/settings_reading_section.dart#L53-L68), changing **Typeface Scale** (`Compact`, `Standard`, `Editorial`, `Large`) or toggling **Serif Literary Immersion** writes `'pref_font_scale'` and `'pref_serif_mode'` to `SharedPreferences`. However, [`ArticleReaderMarkdownBody`](/mind_feed/lib/features/article/presentation/widgets/article_reader_markdown_body.dart#L20-L71) uses a static ` static final MarkdownStyleSheet _cachedStyleSheet` with fixed `AppTextStyles.readerBodyParagraph` (`16.5px` Inter sans-serif). As a result, user typography adjustments in Settings have zero effect when reading articles.

#### 2. Baseline Implementation Snapshot (Before)
```dart
// BEFORE: lib/features/article/presentation/widgets/article_reader_markdown_body.dart (Lines 19-39)
class ArticleReaderMarkdownBody extends StatelessWidget {
  // FLAW: Static style sheet ignores user's 'pref_font_scale' and 'pref_serif_mode' preferences
  static final MarkdownStyleSheet _cachedStyleSheet = MarkdownStyleSheet(
    p: AppTextStyles.readerBodyParagraph.copyWith(color: AppColors.charcoal),
    h1: AppTextStyles.readerMarkdownH1.copyWith(color: AppColors.ink),
    h2: AppTextStyles.readerMarkdownH2.copyWith(color: AppColors.ink),
    h3: AppTextStyles.readerMarkdownH3.copyWith(color: AppColors.ink),
    blockquote: AppTextStyles.readerBlockquote.copyWith(
      color: AppColors.ink85,
    ),
```

#### 3. Refactored Solution (After)
```dart
// AFTER: Dynamic style sheet resolution in ArticleReaderMarkdownBody based on Reader Preferences
class ArticleReaderMarkdownBody extends StatelessWidget {
  final String content;
  final List<String> tags;
  final ValueChanged<String>? onTagTap;
  final String fontScale;
  final bool serifMode;

  const ArticleReaderMarkdownBody({
    super.key,
    required this.content,
    required this.tags,
    this.onTagTap,
    this.fontScale = 'Standard',
    this.serifMode = true,
  });

  static double _resolveFontSizeFactor(String scale) {
    return switch (scale) {
      'Compact' => 0.90,
      'Editorial' => 1.08,
      'Large' => 1.18,
      _ => 1.0,
    };
  }

  MarkdownStyleSheet _buildStyleSheet() {
    final factor = _resolveFontSizeFactor(fontScale);
    final baseBody = serifMode
        ? GoogleFonts.playfairDisplay(
            fontSize: 16.5 * factor,
            height: 1.78,
            color: AppColors.charcoal,
          )
        : AppTextStyles.readerBodyParagraph.copyWith(
            fontSize: 16.5 * factor,
            color: AppColors.charcoal,
          );
    return MarkdownStyleSheet(
      p: baseBody,
      h1: AppTextStyles.readerMarkdownH1.copyWith(
        fontSize: 23 * factor,
        color: AppColors.ink,
      ),
      h2: AppTextStyles.readerMarkdownH2.copyWith(
        fontSize: 19.5 * factor,
        color: AppColors.ink,
      ),
      h3: AppTextStyles.readerMarkdownH3.copyWith(
        fontSize: 17 * factor,
        color: AppColors.ink,
      ),
      // ...
    );
  }
```

#### 4. Summary of Changes & Engineering Rationale
- **What will be changed:** Read the persisted `fontScale` and `serifMode` preferences via a domain use case when initializing the Article Reader, and apply the font scale multiplier and serif/sans-serif family in [`ArticleReaderMarkdownBody`](/mind_feed/lib/features/article/presentation/widgets/article_reader_markdown_body.dart).
- **Why it should be changed:** Connects the reading controls in Settings directly to the longform article reader so reader preferences take immediate visual effect.
- **Why the solution is safe and correct:** Defaults (`fontScale = 'Standard'`, `serifMode = true`) preserve existing rendering behavior in unit and widget tests while making the Settings controls genuinely functional.

---

### Issue 3: Navigation Stack Destruction in `Preferred Categories` and `Change Password` Flows (Make Work)

#### 1. The Architectural Problem / Root Cause
```mermaid
sequenceDiagram
    participant User
    participant Settings as SettingsViewBody
    participant Cat as CategoriesViewBody
    participant Home as MainView ('/')

    User->>Settings: Taps "Preferred Categories"
    Settings->>Cat: Navigator.pushNamed(AppRoutes.categories, arguments: userEntity)
    Note over Cat: No Back Button in AppBar!
    User->>Cat: Updates Categories & Taps "Continue"
    Cat->>Home: Navigator.pushNamedAndRemoveUntil('/', (r) => false)
    Note over Settings:cubit.loadUserData() on Line 81 is NEVER reached!
```
1. **Preferred Categories ([`settings_view_body.dart`](/mind_feed/lib/features/settings/presentation/widgets/settings_view_body.dart#L74-L83) → [`categories_view_body.dart`](/mind_feed/lib/features/profile/presentation/widgets/categories_view_body.dart#L28-L32)):**
   `SettingsViewBody` awaits `Navigator.pushNamed(context, AppRoutes.categories, arguments: state.currentUserEntity)` expecting to run `cubit.loadUserData()` when the user returns. However, `CategoriesViewBody` was built as an initial onboarding gate: it has no Back button to cancel, and upon `CategoriesSuccess` it calls `Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false)`, destroying the navigation stack and stranding the user on the Home screen.
2. **Change Password ([`settings_archive_section.dart`](/mind_feed/lib/features/settings/presentation/widgets/settings_archive_section.dart#L82-L92) → [`change_password_form.dart`](/mind_feed/lib/features/auth/presentation/widgets/change_password_form.dart#L39-L43)):**
   When an authenticated user navigates to `AppRoutes.changePassword` from Settings and updates their password, `ChangePasswordForm` executes `Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false)`, unexpectedly kicking the signed-in user back to the Login screen.

#### 2. Baseline Implementation Snapshot (Before)
```dart
// BEFORE: lib/features/profile/presentation/widgets/categories_view_body.dart (Lines 27-36)
listener: (context, state) {
  if (state is CategoriesSuccess) {
    // FLAW: Destroys navigation stack even when pushed from Settings!
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/',
      (Route<dynamic> route) => false,
    );
  } else if (state is CategoriesFailure) {
    SnackBarService.showErrorMessage(context, state.errMessage);
  }
},
```

#### 3. Refactored Solution (After)
```dart
// AFTER: lib/features/profile/presentation/widgets/categories_view_body.dart
listener: (context, state) {
  if (state is CategoriesSuccess) {
    if (Navigator.canPop(context)) {
      // Returned cleanly to SettingsViewBody so cubit.loadUserData() & HomeFeed refresh run
      Navigator.pop(context, true);
    } else {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/',
        (Route<dynamic> route) => false,
      );
    }
  } else if (state is CategoriesFailure) {
    SnackBarService.showErrorMessage(context, state.errMessage);
  }
},
```
*(Similarly, in [`ChangePasswordForm`](/mind_feed/lib/features/auth/presentation/widgets/change_password_form.dart#L39-L43), when `Navigator.canPop(context)` is true and the user came from Settings rather than the unauthenticated OTP recovery flow, `Navigator.pop(context)` returns directly to Settings with a confirmation SnackBar).*

#### 4. Summary of Changes & Engineering Rationale
- **What will be changed:** Add a conditional back button in [`CategoriesViewBody`](/mind_feed/lib/features/profile/presentation/widgets/categories_view_body.dart) when `Navigator.canPop(context)` is true, pop back to Settings on `CategoriesSuccess` when pushed onto an existing stack, and pop back to Settings in [`ChangePasswordForm`](/mind_feed/lib/features/auth/presentation/widgets/change_password_form.dart) when invoked from an active Settings session.
- **Why it should be changed:** Preserves navigation stack integrity so users editing preferences in Settings return to Settings as expected, and allows `SettingsViewBody` line 81 (`cubit.loadUserData()`) to execute.
- **Why the solution is safe and correct:** Onboarding and unauthenticated password recovery flows use `pushReplacementNamed` (where `canPop` is false or controlled via explicit route arguments), so first-time onboarding still routes to `'/'` and forgot-password recovery still routes to `AppRoutes.login`.

---

### Issue 4: `ThemeModeCubit` State Union Mismatch & Missing DI Registration (Make Work / Enhance)

#### 1. The Architectural Problem / Root Cause
1. In [`theme_mode_state.dart`](/mind_feed/lib/features/settings/presentation/controllers/theme_mode_cubit/theme_mode_state.dart#L20-L22), `final class ThemeModeSystem extends ThemeModeState` is defined, yet [`ThemeModeCubit`](/mind_feed/lib/features/settings/presentation/controllers/theme_mode_cubit/theme_mode_cubit.dart#L13-L39) **never emits `ThemeModeSystem()`**—it emits `ThemeModeInitial()` whenever `ThemeMode.system` is selected.
2. In [`main_app.dart`](/mind_feed/lib/main_app.dart#L28-L32), `MyApp` ignores `ThemeModeState` and reads `SharedPreferencesSingleton.getString(AppConstants.themeModeKey)` synchronously inside `build()` on every frame/rebuild.
3. In [`main.dart`](/mind_feed/lib/main.dart#L45), `ThemeModeCubit` is instantiated inline (`BlocProvider(create: (context) => ThemeModeCubit())`) rather than being registered in [`setup_service_locator.dart`](/mind_feed/lib/core/utls/setup_service_locator.dart).

#### 2. Baseline Implementation Snapshot (Before)
```dart
// BEFORE: lib/features/settings/presentation/controllers/theme_mode_cubit/theme_mode_cubit.dart (Lines 28-39)
Future<void> changeThemeMode(ThemeMode themeMode) async {
  try {
    await SharedPreferencesSingleton.setString(AppConstants.themeModeKey, themeMode.name);
  } catch (_) {}
  if (themeMode == ThemeMode.light) {
    emit(const ThemeModeLight());
  } else if (themeMode == ThemeMode.dark) {
    emit(const ThemeModeDark());
  } else {
    emit(const ThemeModeInitial()); // FLAW: ThemeModeSystem is dead and never emitted
  }
}

// BEFORE: lib/main_app.dart (Lines 28-32)
// FLAW: Reads SharedPreferences inside Widget.build() instead of pattern-matching ThemeModeState
themeMode: SharedPreferencesSingleton.getString(AppConstants.themeModeKey) == ThemeMode.dark.name
    ? ThemeMode.dark
    : SharedPreferencesSingleton.getString(AppConstants.themeModeKey) == ThemeMode.light.name
        ? ThemeMode.light
        : ThemeMode.system,
```

#### 3. Refactored Solution (After)
```dart
// AFTER: lib/features/settings/presentation/controllers/theme_mode_cubit/theme_mode_cubit.dart
Future<void> changeThemeMode(ThemeMode themeMode) async {
  try {
    await SharedPreferencesSingleton.setString(
      AppConstants.themeModeKey,
      themeMode.name,
    );
  } catch (_) {}
  if (isClosed) return;
  switch (themeMode) {
    case ThemeMode.light:
      emit(const ThemeModeLight());
    case ThemeMode.dark:
      emit(const ThemeModeDark());
    case ThemeMode.system:
      emit(const ThemeModeSystem());
  }
}

// AFTER: lib/main_app.dart
themeMode: switch (state) {
  ThemeModeDark() => ThemeMode.dark,
  ThemeModeLight() => ThemeMode.light,
  ThemeModeSystem() || ThemeModeInitial() => ThemeMode.system,
},
```

#### 4. Summary of Changes & Engineering Rationale
- **What will be changed:** Emit `ThemeModeSystem()` in [`ThemeModeCubit`](/mind_feed/lib/features/settings/presentation/controllers/theme_mode_cubit/theme_mode_cubit.dart), guard emissions with `if (isClosed) return`, register `ThemeModeCubit` in [`setup_service_locator.dart`](/mind_feed/lib/core/utls/setup_service_locator.dart), and derive `MaterialApp.themeMode` in [`main_app.dart`](/mind_feed/lib/main_app.dart) via Dart 3 exhaustive pattern matching on `ThemeModeState`.
- **Why it should be changed:** Eliminates storage reads inside `MyApp.build()`, makes the `ThemeModeState` sealed hierarchy exhaustive and accurate, and standardizes dependency injection.
- **Why the solution is safe and correct:** `ThemeModeSystem` and `ThemeModeInitial` both map to `ThemeMode.system`, preserving default startup behavior while making all three theme states explicit and testable.

---

### Issue 5: Clean Architecture Layer Violations & Missing Settings Data Layer (Enhance)

#### 1. The Architectural Problem / Root Cause
The `lib/features/settings/` module currently has `domain/` and `presentation/` directories, but **no `data/` layer**:
1. [`SettingsCubit`](/mind_feed/lib/features/settings/presentation/controllers/settings_cubit/settings_cubit.dart#L4) directly imports `SharedPreferencesSingleton` and executes synchronous disk reads/writes inside the presentation controller.
2. [`GetSettingsProfileUseCase`](/mind_feed/lib/features/settings/domain/usecases/get_settings_profile_use_case.dart#L4-L5) directly calls static methods on `CurrentUserSession` and `SupabaseStorageService` inside the domain layer.
3. [`SettingsState`](/mind_feed/lib/features/settings/presentation/controllers/settings_cubit/settings_state.dart#L84-L112) only defines `copyWith` on `SettingsLoaded`, forcing [`SettingsCubit`](/mind_feed/lib/features/settings/presentation/controllers/settings_cubit/settings_cubit.dart#L51-L316) to manually reconstruct 12-argument `SettingsLoaded(...)` calls 11 separate times.
4. [`SettingsViewBody`](/mind_feed/lib/features/settings/presentation/widgets/settings_view_body.dart#L41-L104) wraps the entire `ListView` in a single `BlocBuilder<SettingsCubit, SettingsState>`, causing the header, account card, theme cards, and archive section to rebuild whenever a single typography chip or toggle changes.
5. [`showSignOutDialog`](/mind_feed/lib/features/settings/presentation/widgets/settings_dialogs.dart#L129-L157) constructs an inline `AlertDialog` inside the feature widget layer rather than using a shared core dialog component in `lib/core/widgets/`.

#### 2. Baseline Implementation Snapshot (Before)
```dart
// BEFORE: lib/features/settings/presentation/controllers/settings_cubit/settings_cubit.dart (Lines 165-185)
void setFontScale(String val) {
  try {
    // FLAW: Presentation Cubit directly accesses low-level SharedPreferencesSingleton
    SharedPreferencesSingleton.setString('pref_font_scale', val);
  } catch (_) {}
  if (!isClosed) {
    // FLAW: Verbose 12-parameter manual state construction repeated 11 times in file
    emit(SettingsLoaded(
      displayName: state.displayName,
      userEmail: state.userEmail,
      avatarUrl: state.avatarUrl,
      currentUserEntity: state.currentUserEntity,
      fontScale: val,
      serifMode: state.serifMode,
      bionicGuide: state.bionicGuide,
      morningBriefing: state.morningBriefing,
      breakingAlerts: state.breakingAlerts,
      dataPreservation: state.dataPreservation,
      wifiOnly: state.wifiOnly,
      cachedMegabytes: state.cachedMegabytes,
    ));
  }
}
```

#### 3. Refactored Solution (After)
```dart
// AFTER: lib/features/settings/presentation/controllers/settings_cubit/settings_cubit.dart
Future<void> setFontScale(String val) async {
  final result = await updateReaderPreferencesUseCase(fontScale: val);
  if (isClosed) return;
  result.when(
    success: (prefs) => emit(
      state.toLoaded(
        fontScale: prefs.fontScale,
        serifMode: prefs.serifMode,
      ),
    ),
    failure: (failure) => emit(state.toError(failure.message)),
  );
}
```

#### 4. Summary of Changes & Engineering Rationale
- **What will be changed:**
  1. Create `lib/features/settings/data/` (`SettingsLocalDataSource`, `SettingsRepositoryImpl`) and `lib/features/settings/domain/` (`ReaderPreferencesEntity`, `SettingsRepository`, `GetReaderPreferencesUseCase`, `UpdateReaderPreferencesUseCase`).
  2. Streamline `SettingsState` down to the 7 active properties (`displayName`, `userEmail`, `avatarUrl`, `currentUserEntity`, `fontScale`, `serifMode`, `cachedMegabytes`) with shared `toLoaded(...)` / `copyWith(...)` helper methods.
  3. Extract the inline `AlertDialog` in `showSignOutDialog` into a reusable `EditorialConfirmDialog` in `lib/core/widgets/`.
  4. Scope rebuilds in `SettingsViewBody` so toggling a reading preference only rebuilds `SettingsReadingSection`.
- **Why it should be changed:** Enforces strict `presentation → domain → data` layer boundaries, reduces `SettingsCubit` line count by >45%, prevents full-page widget rebuilds, and makes every setting testable via mocked domain use cases.
- **Why the solution is safe and correct:** All persistence keys (`'pref_font_scale'`, `'pref_serif_mode'`) remain backward-compatible with existing stored values.

---

## 6. Quantitative Impact Projections

| Metric | Baseline (Before Refactor) | Target (After Refactor) | Delta / Improvement |
| :--- | :--- | :--- | :--- |
| **Settings UI Controls** | 12 controls (5 placebo / 1 mock / 3 broken flow) | 6 controls (100% functional end-to-end) | **0 placebo or mock controls** |
| **Dead Code in `lib/features/settings/`** | ~320 lines (`settings_menu.dart`, unused sheets/tiles) | 0 lines | **-320 lines removed (-100%)** |
| **`SettingsState` Tracked Fields** | 12 fields (5 unused by app) | 7 fields (all actively consumed) | **-41.7% state surface area** |
| **`SettingsCubit` Lines of Code** | 321 lines | ~155 lines | **-51.7% boilerplate reduction** |
| **Presentation Direct Storage Calls** | 8 calls to `SharedPreferencesSingleton` | 0 calls (100% via UseCases & Repository) | **100% Clean Architecture compliance** |
| **Existing Settings Unit Tests** | 13 passing tests | **38 passing unit + widget tests (`437/437` total)** | **+192.3% settings test coverage** |
| **Static Analyzer Status** | 0 errors, 0 warnings | **0 errors, 0 warnings** | **Zero regressions** |

---

## 7. Phased Refactoring Execution & Commit Ledger

| Phase | Commit Hash | Commit Message | Summary |
| :--- | :--- | :--- | :--- |
| **Docs** | `4d3cd68` | `docs(reports): add settings feature architectural audit and refactoring blueprint` | Initial 4-pillar architectural audit report and `CONTEXT.md` index entry. |
| **Phase 1** | `db0bf78` | `refactor(settings): remove dead widgets and unbacked placebo settings controls` | Deleted `settings_menu.dart`, unused sheets/tiles, and 5 unbacked placebo toggles (`-525` net lines). |
| **Phase 2** | `b2f5de3` | `feat(settings): extract settings data layer, reader preferences use cases, and fix ThemeModeCubit` | Added `ReaderPreferencesEntity`, `SettingsRepository`, `SettingsLocalDataSource`, `Get/UpdateReaderPreferencesUseCase`, `SettingsState.toLoaded`, and `ThemeModeCubit` DI. |
| **Phase 3** | `7492402` | `feat(settings): wire reader typography preferences and fix settings navigation flows` | Connected `fontScale` and `serifMode` to `ArticleReaderMarkdownBody` and added `isFromSettings` stack preservation to `CategoriesView` & `ChangePasswordView`. |
| **Phase 4A** | `477ff08` | `refactor(settings): extract EditorialConfirmDialog, decompose ThemeWidget, and scope BlocSelectors` | Extracted reusable `EditorialConfirmDialog` and scoped `BlocSelector`s in `SettingsViewBody`. |
| **Phase 4B** | `1a18412` | `test(settings): add unit and widget tests for reader preferences, ThemeModeCubit, and SettingsCubit` | Added unit and widget tests across Settings data/domain/presentation and reader typography. |
| **Phase 5A** | `a176b26` | `refactor(settings): centralize preference keys in AppConstants, remove Reading Surface Contrast, and default to Warm Paper` | Centralized `fontScaleKey`, `serifModeKey`, `defaultFontScale`, and `genericErrorMessage` in `AppConstants`; removed `ThemeWidget`; set Warm Paper (`ThemeMode.light`) as app default; mapped Settings failures to `CacheFailure` / `SettingsError`. |
| **Phase 5B** | `37a23ff` | `fix(core): replace empty catch blocks across features with CacheFailure error handling` | Eliminated all remaining empty `catch (_) {}` blocks across 16 non-settings files using `CacheFailure("there's an error, Please try again later")` (`437/437` total tests passing). |

```mermaid
flowchart LR
    P1["Phase 1: Prune Dead Code & Placebo UI\n(Delete settings_menu.dart, unused sheets,\nDispatches section, Bionic, Data/Wi-Fi toggles)"] --> P2["Phase 2: Settings Data & Domain Layer\n(Create SettingsRepository, ReaderPreferencesEntity,\nGet/UpdateReaderPreferencesUseCase)"]
    P2 --> P3["Phase 3: Wire Reader & Navigation Flows\n(Connect fontScale/serifMode to ArticleReader,\nFix Categories & ChangePassword back navigation,\nFix ThemeModeCubit system state)"]
    P3 --> P4["Phase 4: UI Polish & Test Verification\n(Extract EditorialConfirmDialog, scope BlocBuilders,\nUpdate & expand unit/widget tests)"]
```

1. **Phase 1 — Prune Dead Code & Placebo UI:**
   - Delete [`lib/features/settings/presentation/widgets/settings_menu.dart`](/mind_feed/lib/features/settings/presentation/widgets/settings_menu.dart).
   - Remove `showDigestPickerSheet` and `showEditProfileSheet` from [`settings_dialogs.dart`](/mind_feed/lib/features/settings/presentation/widgets/settings_dialogs.dart).
   - Remove `SettingsValueTile`, `SettingsSliderTile`, and legacy `PaperSettings*` typedefs from [`settings_tile_primitives.dart`](/mind_feed/lib/features/settings/presentation/widgets/settings_tile_primitives.dart).
   - Remove `Dispatches & Editorial Alerts` (`Morning Edition Briefing`, `Investigative Breaking Alerts`, `Audio Narration Cadence`), `Bionic Reading Guide`, `Data Preservation Mode`, and `Download on Wi-Fi Only` from [`settings_reading_section.dart`](/mind_feed/lib/features/settings/presentation/widgets/settings_reading_section.dart), [`settings_archive_section.dart`](/mind_feed/lib/features/settings/presentation/widgets/settings_archive_section.dart), [`settings_cubit.dart`](/mind_feed/lib/features/settings/presentation/controllers/settings_cubit/settings_cubit.dart), and [`settings_state.dart`](/mind_feed/lib/features/settings/presentation/controllers/settings_cubit/settings_state.dart).
2. **Phase 2 — Settings Data & Domain Layer:**
   - Introduce `ReaderPreferencesEntity`, `SettingsRepository`, `SettingsLocalDataSource`, `SettingsRepositoryImpl`, `GetReaderPreferencesUseCase`, and `UpdateReaderPreferencesUseCase`.
   - Register new dependencies and `ThemeModeCubit` in [`setup_service_locator.dart`](/mind_feed/lib/core/utls/setup_service_locator.dart).
3. **Phase 3 — Wire Reader Typography & Fix Navigation Flows:**
   - Wire `fontScale` and `serifMode` into [`ArticleReaderMarkdownBody`](/mind_feed/lib/features/article/presentation/widgets/article_reader_markdown_body.dart).
   - Update [`CategoriesViewBody`](/mind_feed/lib/features/profile/presentation/widgets/categories_view_body.dart) and [`ChangePasswordForm`](/mind_feed/lib/features/auth/presentation/widgets/change_password_form.dart) to pop back to Settings when pushed from an authenticated Settings session.
   - Update [`ThemeModeCubit`](/mind_feed/lib/features/settings/presentation/controllers/theme_mode_cubit/theme_mode_cubit.dart) to emit `ThemeModeSystem` and bind [`main_app.dart`](/mind_feed/lib/main_app.dart) directly to `ThemeModeState`.
4. **Phase 4 — Reusable Dialog Extraction, Scoped Rebuilds & Test Suite:**
   - Extract `EditorialConfirmDialog` to `lib/core/widgets/`.
   - Scope `BlocBuilder` / `BlocSelector` in [`SettingsViewBody`](/mind_feed/lib/features/settings/presentation/widgets/settings_view_body.dart).
   - Update [`settings_cubit_test.dart`](/mind_feed/test/features/settings/presentation/controllers/settings_cubit_test.dart) and add unit/widget tests for `ThemeModeCubit`, reader preferences, and `SettingsView`.
