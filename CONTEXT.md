# Project Context: Mind Feed

## 1. Overview
Mind Feed is a Flutter content and article reading application featuring an editorial paper-aesthetic UI, clean architecture, and simulated client-side authentication and content flows.

## 2. Architecture & Directory Structure
The codebase follows **Feature-First Clean Architecture**:
- `lib/config/`: App routing (`onGenerateRoute`), themes, color palette, typography.
- `lib/core/`: Reusable components, shared article domain & data kernel (`core/articles/`), design system primitives (`editorial_card`, `editorial_card_stack`), network utilities, local cache helpers, constants, and dependency injection (`setup_service_locator.dart`).
- `lib/features/`: Feature modules adhering to strict `presentation → domain → data` layers:
  - `article/`: Dedicated Article Reader feature (`ArticleReaderCubit`, `ArticleReaderState`, `ArticleView`, 15 `article_*` reader widgets, `ArticleReaderDetails`, and 8 reader-specific domain use cases).
  - `auth/`: Authentication (login, sign-up, OTP verification, password recovery, pure Dart `UserEntity`, and data-layer `UserEntityAdapter`).
  - `home/`: Editorial home feed (`HomeFeedCubit`, `HomeView`, `HomeViewBody`, `HomeMastheadHeader`, `HomeLeadStorySection`), card deck navigation, and home-feed-specific use cases (`GetHomeFeedUseCase`, `GetUserFeedTopicsUseCase`, `FilterArticlesByTopicUseCase`).
  - `collections/`: Saved news bookmarks (`CollectionsCubit`) and offline downloaded articles (`DownloadsCubit`, `DeleteDownloadedArticleUseCase`).
  - `author/`: Author profiles and author articles (`AuthorCubit`).
  - `search/`: Search and category filtering (`SearchCubit`, `SearchArticlesUseCase`, `GetArticlesByCategoryUseCase`).
  - `settings/`: App settings, profile summary, archive cache management, and theme mode toggles (`SettingsCubit`, `ThemeModeCubit`).
  - `profile/`: User profile, category onboarding (`CategoriesCubit`, `CategoriesView`), category sync reconciliation (`ReconcileCategorySyncUseCase`), and authored articles (`ProfileArticlesCubit`, `ProfileInfoCubit`).
  - `add_article/`: Article authoring (`AddArticleCubit`, `PublishArticleUseCase`, `SaveDraftUseCase`, `UpdateArticleUseCase`) and drafts management (`DraftsCubit`).
  - `main/`: Root navigation shell (`MainView`, `MainShellCubit`).
  - `splash/`: Startup session & onboarding gate (`SplashCubit`, `CheckAppStartupUseCase`).
  - `onboarding/`: Editorial onboarding carousel.

## 3. Technology Stack & Key Libraries
- **Framework**: Flutter 3.9+ / Dart 3.9+
- **State Management**: BLoC / Cubit (`flutter_bloc`)
- **Dependency Injection**: `get_it`
- **Local Storage**: `hive`, `hive_flutter`, `shared_preferences`
- **Backend & Network**: `supabase_flutter`, `http`, `connectivity_plus` with custom `SupabaseInterceptor`
- **Markdown & Editorial Rendering**: `flutter_markdown_plus` (migrated to maintained fork from discontinued `flutter_markdown` / `markdown_widget`)
- **Zero Firebase Dependency**: Fully decoupled from Firebase SDKs, CLI configurations, and external Google services.

## 4. Recent Project Changes
- **CI/CD Build & Release Automation**:
  - Configured GitHub Actions release workflows for automated builds on `push` to `main` and release tags (`v*`).
  - `.github/workflows/ios-unsigned-ipa.yml`: Builds unsigned iOS IPA (`macos-latest`), securely injects Supabase secrets, uploads build artifacts, and automatically publishes the IPA asset to GitHub Releases using `gh release`.
  - `.github/workflows/build-apk.yml`: Builds Android APKs (`ubuntu-latest` with Java 17 and Flutter 3.41.3) producing universal APK (`MindFeed-v<version>-universal.apk`) and ABI-split APKs (`arm64-v8a`, `armeabi-v7a`, `x86_64`), uploads artifacts, and publishes all APK assets to the matching GitHub Release.
- **Secret Management & Build Packaging**:
  - Secret keys are never committed in the source code.
  - Dedicated 1Password vault `MindFeed` created with item `Supabase` containing `PROJECT_URL` and `SUPABASE_PUBLISHABLE_KEY`.
  - Credentials injected via 1Password CLI (`op inject` / `op run`) or `--dart-define` / `--dart-define-from-file`.
  - In code, constants resolve via `String.fromEnvironment('PROJECT_URL')` and `String.fromEnvironment('SUPABASE_PUBLISHABLE_KEY')` with fallback to `SUPABASE_URL` / `SUPABASE_ANON_KEY`.
  - `.env` files are strictly ignored in `.gitignore`.
  - Android package namespace and applicationId updated to `mind.feed.pol4b`.
  - Production APK build command standard:
    ```bash
    flutter build apk --release --dart-define-from-file=.env --obfuscate --split-debug-info=build/app/outputs/symbols
    ```
- **Supabase & Networking Architecture**:
  - Replaced legacy REST/Dio infrastructure with `supabase_flutter`.
  - Added `SupabaseInterceptor` to trace and debug requests in debug mode.
  - Migrated network connectivity checks to `connectivity_plus` (`NetworkInfoImpl`).
- **Error Handling & Architecture Synchronization**:
  - Synced error models with `AcademIQ` using native Dart 3 sealed class `ApiResult<T>`, `Failure`, and `ApiErrorHandler` (supporting `AuthException` and `PostgrestException`).
- **Styling and Constants Centralization**:
  - Eliminated raw icon usages in favor of `AppIcons`.
  - Centralized colors and removed obsolete constants.
- **State Management & Build Upgrades**:
  - Encapsulated `CollectionsCubit` provision inside `ArticlesSaved` widget hierarchy, fixing `ProviderNotFoundException` when mounted inside `MainView` (`IndexedStack`).
  - Upgraded Gradle wrapper to `9.3.1`, AGP to `9.1.0`, and Kotlin to `2.4.0`. Migrated Android Gradle DSL (`android/app/build.gradle.kts`) to modern `kotlin { compilerOptions { jvmTarget = JVM_17 } }` and configured Kotlin target validation warnings.
- **Onboarding View Theme Alignment**:
  - Re-themed onboarding screens (`OnboardingView`, `OnboardingViewBody`, `OnBoardingBackground`, `OnBoardingPageView`, `PageViewItem`, `DotsWidget`, `NextButton`, `SkipButton`) to match the app-wide editorial paper/ink design system.
  - Applied `AppColors.ink` as primary background and dark vignette blend.
  - Switched titles to `GoogleFonts.playfairDisplay` with `AppColors.softCream` and body descriptions to `AppColors.greyText`.
  - Replaced decoupled dot indicators with an integrated progress action button in `NextButton`: includes a subtle literary chapter badge (`01 / 03`), label morphing (`Continue` -> `Get Started`), and a smooth hairline progress track along the button's bottom edge.
  - Replaced raw text button with an editorial styled pill `SkipButton` featuring `AppColors.charcoal`, `AppColors.borderDark`, and `AppColors.softCream`.
- **Logo Modernization & Asset Cleanup**:
  - Replaced legacy SVG emblem and unused image assets (`MeJustForTest.jpg`, `back.jpeg`, `news_logo.jpg`, etc.) with official `MindFeedLogo.png`.
  - Updated `Assets.assetsImagesMindFeedLogo` and modernized all references (`Logo`, `SignUpFormBody`, `CustomDrawer`, `HomeViewBody`, `AuthorCard`).
- **Splash Screen & Dynamic App Startup Flow**:
  - Implemented `SplashView` with breathing brand logo animation and curated edition tagline in `lib/features/splash/`.
  - Created `CheckAppStartupUseCase` and `SplashCubit` with sealed states (`SplashNavigateToOnboarding`, `SplashNavigateToLogin`, `SplashNavigateToMain`) checking `isOnboardingSeenKey`.
  - Integrated `AppRoutes.splash` into `onGenerateRoute` and set `initialRoute: AppRoutes.splash` in `MyApp`.
  - Registered `CheckAppStartupUseCase` and `SplashCubit` in `setupServiceLocator`.
  - Persisted onboarding completion in `NextButton` and `SkipButton` via `SharedPreferencesSingleton`.
  - Added full test suite in `test/splash_test.dart` (15 passing tests total).
- **Category Onboarding & Catalog Expansion**:
  - Expanded onboarding and search categories catalog to the 20 official categories matching Supabase seed: `Technology`, `Science`, `Business & Entrepreneurship`, `Personal Development`, `Health & Wellness`, `Education & Learning`, `News & Current Events`, `Politics`, `Finance & Investing`, `Lifestyle`, `Travel & Culture`, `Food & Cooking`, `Sports`, `Entertainment & Movies`, `Books & Literature`, `Art & Design`, `Programming & Software Development`, `History`, `Psychology`, and `Environment & Sustainability`.
  - Added individual category icon definitions and `getCategoryIcon()` lookup helper in `lib/core/constants/app_icons.dart`.
  - Completely migrated `CategoryCard` from `SvgPicture` image assets to vector Material `Icon` widgets sourced through `AppIcons`, strictly fulfilling the zero-image guideline.
  - Extracted `CategoryItem` and `categories` list into a dedicated shared constants file at `lib/core/constants/category_items.dart`.
  - Redesigned the category selection interface into compact elliptical pill badges `(icon title)` using `BorderRadius.circular(100)` and `Wrap(spacing: 8, runSpacing: 10)`.
  - Upgraded `CategoryCard` interaction to use `Material` + `InkWell` directly on the pill shape with animated checkmark indicator badge `(icon title ✓)` upon selection, ensuring unmistakable visual feedback and touch responsiveness.
  - Fixed `CategoriesView` Cubit lifecycle to use `BlocProvider(create: ...)` preventing Cubit recreation on rebuilds, and bound `CategoryCard.isSelected` directly to `state.selectedCategories`.
  - Pinned the `CustomButton` ("Continue") into a sticky bottom navigation bar wrapped in `SafeArea` inside `CategoriesViewBody`, ensuring it is always visible, accessible, and clickable without scrolling.
  - Updated widget test harness in `test/features/auth/categories_view_test.dart` to cover the full catalog, selection toggles, and checkmark display.
- **ValueNotifier State Management Optimization in Auth Forms**:
  - Replaced multiple unnecessary `setState` calls in `CheckCodeViewBody`, `SendCodeViewBody`, and `PasswordTextField` with `ValueNotifier` and `ValueListenableBuilder`.
  - Eliminated full widget tree rebuilds during cooldown countdown timer ticks, text entry, obscured password toggles, and form validation updates.
- **Mandatory Category Onboarding Gate & Deferred Sign-In Persistence**:
  - Enforced mandatory category selection prior to finalizing sign-in or navigating to the home page (`AppRoutes.main`).
  - Added `AppConstants.hasCompletedCategoriesKey` (`hasCompletedCategories`) flag in `lib/core/constants/constants.dart`.
  - Created `CheckUserHasCategoriesUseCase` in `lib/features/profile/domain/usecases/check_user_has_categories_use_case.dart` (registered in `setup_service_locator.dart`), checking local SharedPreferences, Hive cache, and remote profile favorites.
  - Deferred session and token persistence: `AuthRepoImpl.signup`, `AuthRepoImpl.verifyOtp`, `AuthRepoImpl.login`, and `CheckCodeViewBody` no longer prematurely persist `tokenKey` into `SharedPreferences`.
  - In `LoginCubit`, verified whether the authenticated user already completed category onboarding. If categories exist, persists session and emits `LoginSuccess()`. If not, emits `LoginRequiresCategories(userEntity)` and routes to `AppRoutes.categories`.
  - In `SignUpViewBody` and `CheckCodeViewBody`, routed authenticated users directly to `AppRoutes.categories` with `userEntity`.
  - In `CategoriesCubit.saveCategories`, validated that at least one category is selected for initial onboarding, saved categories locally and synced remotely, and finalized sign-in persistence by setting `hasCompletedCategoriesKey = true`, storing `tokenKey`, and updating cached `UserEntity` in Hive.
  - In `CheckAppStartupUseCase`, verified `hasCompletedCategories`. If a user starts sign-up or verification but leaves/kills the app before saving categories, the incomplete session/token and Hive user are purged and the app opens to `StartupLogin()` (the user remains signed out).
  - Cleaned up `hasCompletedCategoriesKey` on logout in `AuthRepoImpl.logout()`.
  - Added full test coverage in `test/features/auth/category_onboarding_gate_test.dart` and updated `splash_test.dart`, `categories_view_test.dart`, and `email_confirmation_and_auth_flow_test.dart` (all 87 tests passing with zero analyze warnings).
- **Forgot Password & Change Password Architecture (Supabase Auth)**:
  - Implemented end-to-end password recovery flow using Supabase Auth and native Dart 3 sealed `ApiResult<T>`.
  - Added `isPasswordReset` support to `AuthApiSource.verifyOtp`, `AuthApiSource.resendOtp`, `AuthRepository.verifyOtp`, `AuthRepository.resendOtp`, `VerifyOtpUseCase`, and `ResendOtpUseCase` to cleanly switch between `OtpType.signup` and `OtpType.recovery`.
  - Added `updatePassword({required String newPassword})` to `AuthApiSource`, `AuthRepository`, and `AuthRepoImpl`, securely updating the authenticated user's password via Supabase `auth.updateUser(UserAttributes(password: newPassword))`.
  - Created domain use cases `ForgetPasswordUseCase` and `UpdatePasswordUseCase` in `lib/features/auth/domain/usecases/`.
  - Created `CheckCodeArgs` entity with `email` and `isPasswordReset` in `lib/features/auth/domain/entities/check_code_args.dart`, and updated `AppRoutes.checkCode` in `lib/config/routes/app_routes.dart` to support both `CheckCodeArgs` and legacy arguments backwards-compatibly.
  - Implemented `ForgetPasswordCubit` and `ForgetPasswordState` (sealed class: `ForgetPasswordInitial`, `ForgetPasswordLoading`, `ForgetPasswordSuccess`, `ForgetPasswordFailure`) in `lib/features/auth/presentation/controllers/forget_password_cubit/`.
  - Implemented `ChangePasswordCubit` and `ChangePasswordState` (sealed class: `ChangePasswordInitial`, `ChangePasswordLoading`, `ChangePasswordSuccess`, `ChangePasswordFailure`) in `lib/features/auth/presentation/controllers/change_password_cubit/`.
  - Registered use cases and cubits in `setup_service_locator.dart`.
  - Connected `SendCodeView` and `SendCodeViewBody`: wrapped with `BlocConsumer<ForgetPasswordCubit, ForgetPasswordState>`, validated email, triggered `sendResetInstructions`, and navigated to `AppRoutes.checkCode` with `CheckCodeArgs(email: email, isPasswordReset: true)`.
  - Connected `CheckCodeView` and `CheckCodeViewBody`: inspected `isPasswordReset` flag; upon successful OTP verification, navigated to `AppRoutes.changePassword` with the recovery email.
  - Connected `ChangePasswordView` and `ChangePasswordForm`: wrapped with `BlocConsumer<ChangePasswordCubit, ChangePasswordState>`, used `ValueNotifier` for password inputs and form validation, enforced password match checking, called `updatePassword`, and routed back to `AppRoutes.login` with success confirmation.
  - Wrapped titles in `SendCodeViewBody` and `ChangePasswordViewBody` with `Expanded` to guarantee responsive rendering across varying display densities.
  - Entire test suite passes (89/89 tests) with zero static analyzer issues.
- **Button Loading UX & Custom Loading Indicator**:
  - Eliminated full-screen `ModalProgressHUD` veils and button-hiding conditional replacements across all authentication screens (`LoginForm`, `LoginViewBody`, `SignUpFormBody`, `SignUpViewBody`, `CheckCodeViewBody`, `SendCodeViewBody`, `ChangePasswordForm`, `CategoriesViewBody`).
  - Redesigned `CustomLoadingIndicator` with custom smooth rotation animation, customizable size, stroke width, and editorial palette defaults (`AppColors.ink` on cream backgrounds).
  - Enhanced `CustomButton` with an `isLoading` property: when active, the button stays in place without layout shifts or height collapse, disables double submissions, and renders the `CustomLoadingIndicator` centered directly inside the button.
- **Profile Favorite Categories Resolution & Post-Login Flow**:
  - Aligned category storage with the Supabase schema: user favorite categories are persisted and read directly from the `profiles` table under the `favorite_categories` column (`text[] DEFAULT '{}'::text[]`).
  - Updated `ProfileRemoteDataSource.getFavoriteCategories` to resolve the authenticated user UUID (`_client.auth.currentUser?.id`) and query `profiles.favorite_categories` as the single source of truth. When the profile exists and `favorite_categories` is empty (`[]`) or null, it returns `[]` immediately without false-positive fallbacks.
  - Added `ProfileRemoteDataSource.saveFavoriteCategoriesToProfile` and updated `ProfileRepoImpl.syncFavoriteCategories` to write selections directly to `profiles.favorite_categories`.
  - In `ProfileRepoImpl.getFavoriteCategories`, set `AppConstants.hasCompletedCategoriesKey = favorites.isNotEmpty` in `SharedPreferencesSingleton`, ensuring any stale local cache is cleared when the remote profile is empty.
  - In `LoginCubit`, verified category completion using `CheckUserHasCategoriesUseCase`. When `profiles.favorite_categories` is empty (`[]`), `LoginCubit` emits `LoginRequiresCategories` and routes the user to `AppRoutes.categories`. When categories already exist, `LoginCubit` emits `LoginSuccess` directly and navigates to `AppRoutes.main`.
  - Added unit test suite in `test/features/auth/login_category_check_test.dart` (95/95 tests passing with zero static analyzer issues).
- **Home Masthead Animated Title (`animated_text_kit`)**:
  - Replaced static app name in `HomeMastheadHeader` with an editorial rotating text animation using `RotateAnimatedText` from `animated_text_kit`.
  - Created modular `HomeMastheadAnimatedTitle` component in `lib/features/home/presentation/widgets/widgets/home_masthead_header.dart`.
  - Added centralized rotating phrases `AppConstants.mastheadRotatingWords` in `lib/core/constants/constants.dart`: includes `AppConstants.appName` ("MindFeed"), "Daily Reads", "Deep Insights", and "Feed Your Mind".
  - Configured left-aligned vertical slide transitions (`Alignment.centerLeft`) styled with `GoogleFonts.playfairDisplay` and `AppColors.softCream`.
  - Fitted inside `FittedBox(fit: BoxFit.scaleDown, alignment: Alignment.centerLeft)` and `Expanded` to prevent layout shifts or overflow on compact screens.
  - Added test suite in `test/features/home/home_masthead_animated_title_test.dart` (all tests passing).
- **Home Write Article Floating Action Button**:
  - Moved the `EditorialIconButton` ("Write article") from `HomeMastheadHeader` to an editorial `FloatingActionButton` (`HomeWriteArticleFab`) positioned at the bottom-right.
  - Styled with editorial theme tokens (`AppColors.cream`, `AppColors.ink`, and `AppBorders.control`).
  - Elevated with a 64px bottom margin to clear the floating `MainNavigationBar` on mobile screens.
  - Wrapped `HomeViewBody` in `_HomeViewScaffold` under `BlocProvider<HomeFeedCubit>` to guarantee clean access to `HomeFeedCubit` on post-creation refresh.
  - Added dedicated widget test in `test/features/home/home_write_article_fab_test.dart` (all 228 tests passing).
- **Navigation Bar Profile Action Integration**:
  - Moved the `EditorialIconButton` ("Open profile", `AppIcons.gridViewRounded`) from `HomeMastheadHeader` into the floating `MainNavigationBar`.
  - Expanded `MainNavigationBar` container width from `174` to `228` with four balanced icons (`Home`, `Search`, `Saved news`, and `Open profile`).
  - Added optional `onProfilePressed` callback in `MainNavigationBar` with fallback default to `Navigator.pushNamed(context, AppRoutes.profile)`.
  - Fully decluttered `HomeMastheadHeader` down to the brand logo and the expanding `HomeMastheadAnimatedTitle`, removing all top action buttons and unused imports.
  - Updated widget tests in `test/widget_test.dart` to verify `Open profile` in navigation bar and write article FAB in home view (all 228 tests passing).
- **Home Page Skeletonizer Loading State (`skeletonizer`)**:
  - Added `skeletonizer` (`^3.0.0`) to `pubspec.yaml`.
  - Replaced `CircularProgressIndicator` in `HomeFeedLoadingView` with `Skeletonizer` wrapping placeholder `EditorialCardStack` and `HomeSecondaryStoryTile` items styled with warm editorial shimmer (`ShimmerEffect(baseColor: AppColors.greyBrown, highlightColor: AppColors.creamDark)`).
  - Wrapped `HomeTopicTabsBar` in `HomeViewBody` with `Skeletonizer(enabled: isLoading)` so topic filter pills also shimmer during initial/loading states.
- **Navigation Bar Profile Tab Integration & In-Stack View**:
  - Integrated `ProfileView` directly into `MainView`'s `IndexedStack` at destination tab index 3 alongside Home (0), Search (1), and Saved News (2).
  - Configured `MainNavigationBar` with 4 destination tabs (`Home`, `Search`, `Saved news`, and `Profile`) with active pill indicator styling and instant switching without pushing new routes.
  - Made the back button in `ProfileAppBar` conditional on `Navigator.canPop(context)` so it automatically hides when viewed within the bottom navigation bar and displays when pushed standalone.
  - Resolved `RenderFlex` horizontal overflow issues on compact mobile screens:
    - In `lib/features/profile/presentation/widget/user_articles.dart`, replaced rigid `Spacer()` with `Expanded` title truncation and balanced spacing.
    - In `lib/features/profile/presentation/widget/profile_avatar_and_stats.dart`, reduced stats divider horizontal margins from 24px to 16px to prevent 1.3px overflow.
    - In `lib/features/home/presentation/widgets/widgets/home_lead_story_section.dart`, replaced `Row` with `Wrap` in `HomeSecondaryStoryTile` badge and reading time row to prevent 4.5px overflow on compact devices.
  - Updated test suite (`test/widget_test.dart`) to test 4-destination navigation and verified all 229 tests pass.
- **HomeTopicTabsBar User-Selected Categories**:
  - Updated `HomeFeedState` default `topics` to `const ['All']` and enhanced `filteredArticles` matching to support multi-word user-selected category names (e.g. `Artificial Intelligence`, `Health & Wellness`) as well as keyword/tag matching.
  - Updated `HomeFeedCubit` to initialize `topics` from cached `CurrentUserSession.resolveCachedUserEntity()?.favoriteCategories` (`['All', ...cachedCategories]`) and fetch the user's selected categories via `ProfileRepository.getFavoriteCategories` (supporting both `profiles.favorite_categories` `{'name': ..., 'category_name': ...}` maps and junction `{'categories': {'name': ...}}` maps).
  - Updated `HomeTopicTabsBar` in `lib/features/home/presentation/widgets/widgets/home_masthead_header.dart` so `'All'` is always guaranteed to be the first tab followed by the user's selected categories (`['All', ...selectedCategories]`).
- **Floating Navigation Bar & High-Performance Static Background**:
  - Eliminated the continuous background animation (`HomeBreathingBackground`) which ran 60fps tickers and multiple full-screen radial gradient repaints on every frame, eliminating CPU/GPU overhead and battery drain.
  - Replaced it with a high-performance static editorial dark background (`AppColors.ink`) across `MainView` and all tabs.
  - Eliminated the solid dark rectangular background that previously obscured the bottom of the screen behind the floating `MainNavigationBar`.
  - Replaced nested `Scaffold` implementations in `SearchView`, `ArticlesSaved`, and `ProfileView` with transparent `Material(color: Colors.transparent)` shells.
  - Set `SafeArea(top: true, bottom: false)` across all tabs so background and scrolling content extend all the way behind the floating navigation pill to the bottom device edge.
  - Updated scroll views and list view padding across all tabs (e.g. `EdgeInsets.fromLTRB(20, 14, 20, 100 + bottomInset)`) so items scroll smoothly behind the floating bar without being obscured at the bottom of the scroll view.
  - Verified with `flutter test` (all 229 tests passing with zero static analyzer issues) and verified visually on active emulator via screen captures across all 4 tabs.
- **Dart DevTools Performance Profile Optimizations**:
  - Analyzed exported DevTools timeline (`dart_devtools_2026-10-17_17_07_21.029.json`, 2,796 frames) and resolved all 4 root causes of Raster/UI jank:
  - **Masthead Title Animation Isolation & Finite Cycle (`home_masthead_header.dart`)**:
    - Wrapped `HomeMastheadAnimatedTitle` in `RepaintBoundary` so text rotation no longer invalidates the parent scroll view or card stack.
    - Configured `AnimatedTextKit` with `repeatForever: false, totalRepeatCount: 1`, and appended a final non-rotating `RotateAnimatedText` entry so the title cycles through the rotating phrases once and settles permanently on `"MindFeed"` (0% idle CPU/GPU).
  - **Eliminated `Canvas::saveLayer` Offscreen Passes & Drag Rebuilds (`editorial_card_stack.dart`, `editorial_card.dart`)**:
    - Replaced `Opacity` widgets on background stack cards (`op = 0.85` / `0.95`) with direct surface color interpolation (`Color.lerp(AppColors.ink, _cards[i].color, op)`), eliminating 6,150 `Canvas::saveLayer` / `RenderPassGLES` offscreen GPU passes.
    - Wrapped each card in `RepaintBoundary` and replaced `_onPanUpdate` `setState` calls with a `ValueNotifier<Offset>` merged into `AnimatedBuilder` via `Listenable.merge`, eliminating widget tree rebuilds during card drag gestures.
  - **Image Decode Sizing & Asset Downscaling**:
    - Added `cacheWidth` and `cacheHeight` to `Image.asset` and `Image.network` widgets across `HomeMastheadHeader`, `EditorialCard`, `ArticleReaderCoverImage`, `ArticleReaderAuthorBar`, `ProfileAvatarAndStats`, `SettingsAccountCard`, `Logo`, and `SplashLogoWidget`.
    - Downscaled oversized bundled assets: `assets/images/wade_avatar.png` (`1024x1024` 547KB -> `256x256` 81KB) and `assets/images/onBoarding_1.jpg` (`3163x3954` 825KB -> `1080x1350` 145KB), reducing decoded GPU texture memory by >90%.
  - **Lazy Tab Mounting & Sliver Virtualization (`main_view.dart`, `home_view_body.dart`)**:
    - Updated `MainView` `IndexedStack` to lazy-mount tabs (`_visitedTabs = {0}`) on first selection and wrapped each tab in `TickerMode(enabled: selectedIndex == index)` and `RepaintBoundary`.
    - Converted `HomeViewBody` from an eager `ListView(children: ...)` to a `CustomScrollView` with `SliverList.builder` and `RepaintBoundary` for secondary stories.
- **Home Feature Clean Architecture & Engineering Rules Refactoring**:
  - **Dead Code Removal & Flat Widget Structure**: Removed 11 unused legacy widget files from `lib/features/home/presentation/widgets/` and flattened `presentation/widgets/widgets/` into `presentation/widgets/`.
  - **Centralized Constants, Theming & Reusable Components**: Replaced raw `Icons.*`, `Colors.white.withAlpha(...)`, `BorderRadius.circular(...)`, inline `TextStyle(...)`, and inline `ElevatedButton`/`OutlinedButton` in Home widgets with centralized `AppIcons`, `AppColors`, `AppBorders`, `AppTextStyles`, and `CustomButton`.
  - **Domain Layer Purification & UseCase Extraction**:
    - Removed `package:flutter/material.dart`, `AppColors`, `AppImages`, and `EditorialNewsItem` from `ArticleEntity` and `DownloadedArticleEntity`, moving `toEditorialNewsItem()` to extensions (`ArticleEntityEditorialMapper`, `DownloadedArticleEntityEditorialMapper`) in `lib/core/design/editorial_models.dart`.
    - Moved `ArticlesLocalDataSource` out of `domain/repos/` into `data/datasources/articles_local_data_source.dart` implementing `OfflineArticlesRepository` in `domain/repos/articles_repo.dart`.
    - Created `GetUserFeedTopicsUseCase` and `FilterArticlesByTopicUseCase` in `lib/features/home/domain/usecases/`.
  - **Dart 3 Sealed State, Immutable Cubit Updates & DI**:
    - Migrated `HomeFeedState` to a Dart 3 `sealed class` hierarchy (`HomeFeedInitial`, `HomeFeedLoading`, `HomeFeedLoaded`, `HomeFeedError`) with `SwipeSaveStatus`.
    - Refactored `HomeFeedCubit` and `HomeViewBody` into small `<20`-line methods, guarded all emissions with `if (!isClosed)`, eliminated `StatefulBuilder` mutation workarounds via immutable list emissions, and registered `GetUserFeedTopicsUseCase`, `FilterArticlesByTopicUseCase`, and `HomeFeedCubit` in `setup_service_locator.dart`.
  - Detailed report available in `docs/reports/home_feature_clean_architecture_and_engineering_report.md`.
- **Article Reader Clean Architecture, Sealed State Machine & VSYNC Auto-Scrolling**:
  - **Domain Layer Purification & Aggregate Modeling**:
    - Created immutable `ArticleReaderDetails` aggregate domain entity in `lib/features/home/domain/entities/article_reader_details.dart`.
    - Created `LoadArticleReaderDetailsUseCase` in `lib/features/home/domain/usecases/load_article_reader_details_use_case.dart` encapsulating article details, offline status, engagement status, and author rating summaries.
    - Created atomic focused use cases: `CheckArticleDownloadedUseCase`, `IsArticleLikedUseCase`, and `IsArticleSavedUseCase`.
  - **Dart 3 Sealed State Machine & Immutable State Transitions**:
    - Migrated `ArticleReaderState` to a Dart 3 `sealed class` hierarchy (`ArticleReaderInitial`, `ArticleReaderLoading`, `ArticleReaderLoaded`, `ArticleReaderError`) with backward-compatible getters for seamless consumption.
    - Refactored `ArticleReaderCubit` to use constructor-injected domain use cases, safe `if (!isClosed)` async emission guards, zero in-place entity mutations (using `.copyWith(...)`), and clean `.when()` pattern matching for `ApiResult<T>`.
    - Deprecated runtime reflection in `article_reader_deps.dart`.
  - **Component Decomposition & Theme Centralization**:
    - Decomposed monolithic `article_reader_header.dart` into single-responsibility widgets: `ArticleReaderCoverImage`, `ArticleReaderMetadataHeader`, and `ArticleReaderAuthorBar`.
    - Decomposed `article_reader_markdown_body.dart` and extracted `ArticleReaderTagsWrap`.
    - Decomposed `article_view.dart` into 5 modular, single-responsibility widgets: `ArticleViewContent` (stateful Ticker shell & feedback handler), `ArticleReaderScrollView` (scrollable content hierarchy), `ArticleAuthorSection` (isolated 5-star author rating BlocSelector), `ArticleActionBarSection` (isolated like/bookmark BlocSelector), and `ArticleSlowScrollBarSection` (isolated slow-scroll BlocSelector), reducing `ArticleView` to a concise 45-line entry point.
    - Replaced discontinued `markdown_widget: ^2.3.2+8` (which depended on abandoned `general_framework`) with production-grade `flutter_markdown: ^0.7.7+1`, completely eliminating 4 unused transitive packages (`flutter_highlight`, `highlight`, `scroll_to_index`, `visibility_detector`) from the dependency graph.
    - Cached `MarkdownStyleSheet` (`_cachedStyleSheet`) mapped directly to centralized design tokens (`AppTextStyles`, `AppBorders`, `AppColors`), eliminating repeated style object instantiations per frame.
    - Replaced hardcoded text styles, arbitrary border radii, and raw opacity overlays with `AppTextStyles`, `AppBorders`, and `AppColors`.
  - **UI Shell & VSYNC Auto-Scrolling Performance**:
    - Converted `ArticleSlowScrollBar` to a pure `StatelessWidget`, removing dual-state `setState` conflicts.
    - Replaced the drifting 32ms software timer in `ArticleView` with a hardware VSYNC-synchronized Flutter `Ticker` (`SingleTickerProviderStateMixin`) with delta-time calculation.
    - Isolated rebuild scopes using `BlocSelector` (`ArticleAuthorSection`, `ArticleActionBarSection`, `ArticleSlowScrollBarSection`) so heavy markdown rendering and cover images never re-render during engagement interactions.
    - Registered `ArticleReaderCubit` in `setup_service_locator.dart`.
    - Detailed report available in `docs/reports/article_reader_clean_architecture_and_performance_report.md`.
- **Comprehensive Architectural & Evolution Reports Suite**:
  - Authored dedicated technical reports in `docs/reports/` documenting the complete engineering journey of MindFeed, key architectural pivots, and performance milestones.
- **Feature Splitting & Cross-Feature Clean Architecture Refactoring**:
  - **Shared `features/articles/` Domain Kernel Extraction**: Extracted shared entities (`ArticleEntity`, `CategoryEntity`, `TagEntity`, `DownloadedArticleEntity`, `AuthorRatingSummary`), repository contracts (`ArticlesRepository`, `OfflineArticlesRepository`, `ArticleEngagementRepository`), shared multi-feature use cases, remote/local data sources, models, and `ArticlesRepositoryImpl` out of `features/home/` into `lib/features/articles/`.
  - **Single-Owner Use Case Relocation**: Relocated single-owner use cases to their owning vertical slices (`PublishArticleUseCase`, `SaveDraftUseCase`, `UpdateArticleUseCase` -> `add_article`; `SearchArticlesUseCase`, `GetArticlesByCategoryUseCase` -> `search`; `DeleteDownloadedArticleUseCase` -> `collections`), reducing cross-feature imports into `home` by 98.3% (`59 -> 1`).
  - **Eliminated All Layer-Skipping & DI Fallback Anti-Patterns**:
    - Created pure `settings/domain/` layer (`SettingsProfileSummary`, `GetSettingsProfileUseCase`, `GetArchiveCacheSizeUseCase`, `ClearDownloadedArticlesUseCase`) and refactored `SettingsCubit` + `SettingsViewBody` (13 new unit tests).
    - Relocated `CategoriesCubit`, `CategoriesView`, `CategoriesViewBody`, and `CategoryCard` from `auth/presentation/` to `profile/presentation/`, stripping inline `ProfileRepoImpl` / `ProfileRemoteDataSourceImpl` instantiation.
    - Converted `CategorySyncReconciler` into `ReconcileCategorySyncUseCase` (`profile/domain/usecases/`) orchestrated by `MainShellCubit` (`main/presentation/`).
    - Refactored `CheckAppStartupUseCase` (`splash/domain/`) to depend on `AuthRepository` (`hasActiveSession()`, `logout()`) instead of `AuthApiSource` (`auth/data/`).
    - Created `IsArticleStarredUseCase`, `GetUserProfileUseCase`, `GetFavoriteCategoriesUseCase`, `ProfileInfoCubit`, and `AuthorCubit`, and refactored `DownloadsCubit`, `CollectionsCubit`, `HomeFeedCubit`, `ArticleReaderCubit`, `DraftsCubit`, `AddArticleCubit`, `SearchCubit`, and `ProfileArticlesCubit` to require constructor-injected use cases only.
  - **Domain Layer Purity & Directory Naming Standardization**:
    - Stripped Hive annotations/imports from `UserEntity` and `DownloadedArticleEntity`, moving `UserEntityAdapter` and `DownloadedArticleEntityAdapter` to `data/models/`.
    - Relocated `SearchFilterHelper` and `ArticlePayloadBuilder` out of `domain/` into `presentation/`.
    - Broke circular UI navigation between `home` and `collections`/`settings` via `AppRoutes`, extracted shared `CustomArticleCardOfProfile` to `lib/core/widgets/article_card.dart`, and standardized all feature presentation folders to `controllers/` and `widgets/` (282/282 tests passing, 0 analyzer issues).
- **Supabase Storage (`avatars` & `article-media`), `profiles.avatar_url` Sync, Offline Image Caching & Asset Cleanup**:
  - **Centralized Storage Service (`lib/core/services/supabase_storage_service.dart`) & RLS Migration (`supabase/migrations/20261025193000_storage_buckets_and_policies.sql`)**:
    - Configured public `avatars` and `article-media` buckets with per-user folder RLS policies and protection for `defaultAvatar.png`.
    - Added URL resolution (`resolveAvatarUrl`, `resolveArticleMediaUrl`), custom avatar replacement with automatic deletion of the previous non-default avatar object in `avatars`, and cover image upload in `article-media`.
  - **Reusable `EditorialAvatar` (`lib/core/widgets/editorial_avatar.dart`) & `profiles.avatar_url` Integration**:
    - Added `avatarUrl` to `UserEntity`, `UserModel`, `UserEntityAdapter` (Hive field 4), and `CurrentUserSession.cacheUserAvatarUrl`.
    - Implemented `UploadProfileAvatarUseCase`, `ProfileRepository.uploadAvatar`, `ProfileInfoCubit.uploadAvatar`, and interactive avatar upload via `FilePicker` on `ProfileAvatarAndStats`, updating `public.profiles.avatar_url`, auth metadata, and authored articles.
    - Replaced hardcoded `Image.asset` calls across `EditorialCard`, `ArticleReaderAuthorBar`, `AuthorPersonalInfo`, `ProfileAvatarAndStats`, `SettingsAccountCard`, and `ArticlePreviewHeader` with `EditorialAvatar`.
  - **Article Cover Image Upload (`article-media` Bucket)**:
    - Implemented `UploadArticleCoverImageUseCase`, `ArticleValidator.validateCoverImageBytesDimensions` (enforcing landscape aspect ratio prior to upload), `AddArticleCubit.uploadCoverImage`, and the "Upload Cover Image" button in `ArticleCoverImageField`.
  - **Offline Image Downloading (`DownloadedArticleEntity`)**:
    - Extended `DownloadedArticleEntity` and `DownloadedArticleEntityAdapter` with `coverImageUrl` (field 13), `coverImageBytes` (field 14), and `authorAvatarBytes` (field 15).
    - Enhanced `DownloadArticleTextUseCase` to download and persist cover and avatar image bytes for offline reading, rendered via `Image.memory` in `ArticleReaderCoverImage`, `EditorialAvatar`, and `DownloadedArticleCardTile`, and counted in `GetArchiveCacheSizeUseCase`.
  - **Asset & Dead Code Cleanup**:
    - Removed unused image assets (`MIT_News-AI_coding.png`, `pills.jpg`, `justTest.webp`, `wade_avatar.png` — ~1.51 MB total) and 5 unused legacy mock widgets in `collections/presentation/widgets/` (350/350 tests passing, 0 analyzer issues).

## 5. Architectural Reports & Documentation Index
Detailed technical reports documenting audits, optimizations, and architectural refactoring are maintained in `docs/reports/`:
- **Settings Feature Architectural Audit & Refactoring Blueprint Report** (`docs/reports/settings_feature_audit_and_refactoring_report.md`): 4-pillar audit (`Keep & Don't Touch`, `Remove`, `Make Work`, `Enhance`) of `lib/features/settings/` and its cross-feature integrations (`ArticleReader`, `CategoriesView`, `ChangePasswordView`, `ThemeModeCubit`, and Clean Architecture `SettingsRepository` extraction).
- **Feature Splitting & Cross-Feature Clean Architecture Refactoring Report** (`docs/reports/feature_splitting_and_clean_architecture_report.md`): Comprehensive audit and refactoring of all 10 feature modules, detailing shared `features/articles/` domain kernel extraction, single-owner use case relocation, elimination of presentation-to-data/repository and domain-to-data/presentation violations, Hive adapter migration, and folder naming normalization.
- **Article Reader Clean Architecture, Sealed State Machine & VSYNC Auto-Scrolling Report** (`docs/reports/article_reader_clean_architecture_and_performance_report.md`): Detailed analysis of the Article Reader refactoring, covering domain aggregate extraction, Dart 3 sealed state machine, VSYNC `Ticker` scrolling, component decomposition, rebuild scope isolation, and the supply-chain security migration from discontinued `markdown_widget` to `flutter_markdown`.
- **Legacy Prototype & Architectural Evolution Report** (`docs/reports/legacy_prototype_and_evolution_report.md`): Chronological audit of the 38 foundational commits from genesis (`b6782b4`) up to Pull Request #1 (`ba0ed81`), detailing early UI prototypes, feature consolidation (`cd8a116`), password security remediation (`a2a03eb`), and the editorial card stack pivot (`0ba79bd`).
- **Mandatory Category Onboarding Gate & Password Recovery Architecture Report** (`docs/reports/category_onboarding_and_auth_architecture_report.md`): Architectural analysis of commits `f7e3024` to `39e50a4`, documenting deferred session and token persistence, 20-category vector pill modernization, Supabase password recovery pipeline, and `ValueNotifier` form optimizations.
- **Dart DevTools Performance Profile & Raster Jank Optimization Report** (`docs/reports/devtools_performance_and_raster_optimization_report.md`): Quantitative timeline comparison (`17_07_21.029.json` vs. `18_08_16.161.json`) for commit `921c7eb`, detailing the elimination of 6,150 `saveLayer` passes via `Color.lerp`, masthead ticker isolation, asset downscaling, and sliver virtualization (78.8% raster time reduction).
- **Home Feature Clean Architecture & Engineering Report** (`docs/reports/home_feature_clean_architecture_and_engineering_report.md`): Detailed breakdown of the 7 architectural rule violations in `lib/features/home/` and their systematic refactoring across 4 atomic Git commits.
- **Backend & Clean Architecture Audit Report** (`docs/reports/backend_and_clean_architecture_session_report.md`): Supabase database schema, RPC functions, and offline data sync.
- **Flutter Refactor Analysis Report** (`docs/reports/flutter_refactor_analysis_report.md`): Baseline code health and refactoring recommendations.

## 6. Knowledge Graph Architecture & Codebase Navigation (Graphify)
The MindFeed repository maintains a persistent GraphRAG knowledge graph under `graphify-out/` representing the entire codebase AST, community structures, call flows, and symbol dependencies:
- **`graphify-out/graph.json`**: Primary machine-readable graph comprising 4,108 AST nodes, 6,710 edges, and 193 communities.
- **`graphify-out/GRAPH_REPORT.md`**: Architectural audit report detailing God Nodes (e.g. `CacheHelper`, `AppColors`, `AppRoutes`), cross-module bridges, and community cohesion scores.
- **`graphify-out/graph.html`**: Interactive visual web canvas for graphical dependency navigation.

### Graph Navigation Protocols for Antigravity & Developers
1. **Targeted Subgraph Inquiries**:
   ```bash
   graphify query "<question>"
   ```
   Answers questions about feature workflows, caller hierarchies, and data paths without grepping or reading raw files blindly.
2. **Shortest Architectural Path**:
   ```bash
   graphify path "<SourceSymbol>" "<TargetSymbol>"
   ```
   Traces direct and transitive connections between features, use cases, or data sources.
3. **Symbol Explanation**:
   ```bash
   graphify explain "<Symbol>"
   ```
   Inspects callers, incoming references, outgoing dependencies, and cluster membership for any specific symbol.
4. **Graph Synchronization**:
   - Automated via git post-commit hooks (`.git/hooks/post-commit`).
   - Manual incremental synchronization:
     ```bash
     graphify . --update --code-only
     graphify cluster-only .
     ```

## 7. Android Release Configuration & Network Permissions
- **Release Manifest Internet Permissions (`android/app/src/main/AndroidManifest.xml`)**:
  - Added `android.permission.INTERNET` and `android.permission.ACCESS_NETWORK_STATE` to `android/app/src/main/AndroidManifest.xml`.
  - While Flutter's template includes `INTERNET` in `android/app/src/debug/AndroidManifest.xml` and `android/app/src/profile/AndroidManifest.xml` for debug tools, release builds only merge the `main` manifest. Declaring these permissions in `main` ensures release builds (`flutter build apk --release`) can perform DNS lookups, authenticate via Supabase Auth endpoints, and query network status.

## 8. Publishing Tags Refactor & Custom Tag Creation (`refactor/publish-article`)
- **Tags Search Bar & Autocomplete (`lib/features/add_article/presentation/widgets/article_tag_selector.dart`)**:
  - Replaced static cloud of chip selections with a reactive tag search bar (`tag_search_field`) with real-time matching against available tags.
  - Selected tags are presented as removable chips with close buttons (`InputChip`, `tag_chip_$tag`), showing active counter `$count / 5 selected`.
  - Added inline custom tag creation (`add_new_tag_chip`, submit button, and keyboard done action) directly from the search bar, alongside dialog fallback.
- **Tag Validation & State Transformation (`lib/features/add_article/domain/helpers/`)**:
  - Updated `ArticleStateTransformers.applyCustomTag` to match existing tags across name and slug without duplication.
  - Updated `ArticleValidator.validateTags` to perform case-insensitive validation against `allowedTagNames`.
- **Backend & Remote Data Source Integration**:
  - Added migration `supabase/migrations/20261101114500_support_custom_tags_and_auto_catalog.sql` granting authenticated users INSERT policy on `fixed_tags` and upgrading `check_article_tags()` trigger to auto-catalog custom tags into `public.fixed_tags`.
  - Added `_ensureTagsExist` in `ArticlesRemoteDataSourceImpl.saveDraft` and `updateArticle` to synchronize tags with `fixed_tags`.

## 9. Article Preview Page Unification (`ArticleView(isPreview: true)`)
- **Canonical Article Layout Reuse (`lib/features/add_article/presentation/views/article_preview_view.dart`)**:
  - Replaced the bespoke preview screen with the canonical `ArticleView(isPreview: true)`, giving writers an authentic rendering of their story using the exact same typography, markdown styling, cover image presentation, and metadata layout.
- **Preview Mode Adjustments (`lib/features/article/presentation/`)**:
  - Added `isPreview: true` support to `ArticleView`, `ArticleViewContent`, `ArticleReaderScrollView`, and `ArticleReaderTopBar`.
  - In preview mode:
    - Provides a clean top bar with only the Back button (`_BackButton`, `preview_back_button`) to return directly to the editor or drafts list.
    - Omit engagement action bars (`ArticleActionBarSection` for likes, bookmarks, and downloads) and floating auto-scroll controls (`ArticleSlowScrollBarSection`), preventing extraneous interactions on draft content.

## 10. Production IndexedStack Navigation & Shell Hardening (`MainView`)
- **System / Hardware Back Button Navigation (`PopScope`)**:
  - Integrated `PopScope(canPop: _selectedIndex == 0)` so that pressing the Android back button / predictive back gesture from any non-home tab (`Search`, `Saved`, `Profile`) navigates directly back to `Home` (`_selectedIndex = 0`). Exiting the app only occurs when pressing back while on `Home`.
- **Ghost Input / Keyboard Dismissal**:
  - Added `FocusScope.of(context).unfocus()` on tab transition so open keyboards (e.g., from `SearchView`) do not remain visible across different tabs.
- **Widget Tree Caching**:
  - Replaced ad-hoc `builder()` invocations in `build()` with an instantiated cache (`_cachedTabs[index] ??= ...`), preventing widget reconstruction and unnecessary sub-tree churn on each rebuild.
- **Active Tab Re-selection Handling**:
  - Added `_handleSameTabTapped(index)` to handle re-tapping the active tab (refreshing saved articles and supporting future scroll-to-top behaviors).
- **GPU & Animation Performance**:
  - Preserved lazy mounting (`_visitedTabs`), `TickerMode(enabled: isSelected)` to freeze hidden tab tickers, and `RepaintBoundary` to prevent cross-layer redraws.

## 11. Share Article & Author Profile UI Removal
- **Removed Placeholder Share Sheet, Article Share Controls & Author Profile Share Button**:
  - Removed `showEditorialShareSheet` and `_buildShareAction` from `lib/core/design/editorial_design.dart`.
  - Removed `onShare` callbacks and `'Share article'` action buttons across `EditorialCard`, `EditorialCardStack`, `HomeLeadStoryCard`, `ArticleCard`, `ArticleCardOfAuthor`, `ArticleReaderActionBar`, and `ArticleActionBarSection` (simplifying `ArticleActionBarSection` to a `const` constructor inside `ArticleReaderScrollView`).
  - Removed the `'Share profile'` action button and mock clipboard `SnackBar` from `AuthorAppBar` (`lib/features/author/presentation/widgets/author_app_bar.dart`).
  - Updated `test/features/reader/article_view_widget_test.dart` and `test/features/author/author_view_test.dart` to assert that `'Share article'` and `'Share profile'` are no longer rendered.

## 12. Author Dossier Redesign, Article Card Separation, Real Supabase `author_follows` & Profile `Drafts` Entry
- **Real Supabase `public.author_follows` Domain & Data Layer (`lib/core/articles/`, `supabase/migrations/20261102123000_support_author_key_follows_and_rls.sql`)**:
  - Created `AuthorFollowSummary`, `AuthorFollowRepository`, `AuthorFollowRemoteDataSourceImpl`, `AuthorFollowRepositoryImpl`, `AuthorFollowValidator`, `GetAuthorFollowSummaryUseCase`, and `ToggleAuthorFollowUseCase` backed by `public.author_follows` (`follower_id`, `author_key`, nullable `author_id`, `author_name`).
  - Added migration `20261102123000_support_author_key_follows_and_rls.sql` (canonical `author_key` primary key, `ensure_user_profile_exists` trigger, and `UPDATE` RLS policy) plus `ignoreDuplicates: true` on PostgREST `.upsert()` with graceful backward-compatible fallback, allowing readers to follow both registered UUID user authors and seeded editorial columnists (while hiding Follow on own articles/profiles).
  - Converted `EditorialFollowButton` into a stateless, Cubit-driven widget, removed it from `EditorialCard` feed cards, and wired real Follow / Unfollow into `AuthorView` and `ArticleReaderAuthorBar` (with automatic engagement refresh when returning from `AuthorView`).
- **Article Card Separation (`Profile` vs. `Author` vs. `TagArticles`)**:
  - Relocated creator-only `CustomArticleCardOfProfile` (`PUBLISHED`/`DRAFT`, `Archived · locked`, `Edit`, `Delete`) to `lib/features/profile/presentation/widgets/custom_article_card_of_profile.dart` and deleted `lib/core/widgets/article_card.dart`.
  - Replaced `ArticleCardOfAuthor` (`lib/features/author/presentation/widgets/article_card_of_author.dart`) with a dark-editorial reader dossier card (category pill, publish date, reading time, title, excerpt, optional cached cover thumbnail, `#tag` pills, and zero owner controls).
  - Updated `TagArticlesView` to render `EditorialCard` (layout-safe in unbounded scroll views).
- **Creator `ProfileView` Enhancements (`Drafts (N)` Button & 4 Real Stats)**:
  - Replaced hardcoded `'0' 'Followers'` in `ProfileAvatarAndStats` with 4 real database stats: `Articles` (published count) · `Followers` (`author_follows.author_id`) · `Following` (`author_follows.follower_id`) · `Topics` (`favorite_categories`).
  - Filtered `My Articles` in `UserArticles` to show **only published articles** and added a dedicated **`Drafts` / `Drafts (N)` button** navigating directly to `AppRoutes.drafts` (`DraftsView`) with automatic profile reload on return.
- **Public Editorial Columnist Dossier (`AuthorView`)**:
  - Created `AuthorDossierEntity` and `LoadAuthorProfileDossierUseCase` enforcing `status == 'published'` filtering and aggregating real profile bio/avatar, `AuthorFollowSummary`, `AuthorRatingSummary`, and distinct category `topics`.
  - Replaced `AuthorPersonalInfo` (and all hardcoded `'Wade Warren'` / `'86'` / `'48.2K'` / `'192'` mock values) with left-aligned `AuthorDossierHeader`, `AuthorTopicFilterBar`, `AuthorStatusViews`, and a virtualized `SliverList.builder` in `AuthorView`.

## 13. Home Feed Deck Position Preservation & Latest Articles Randomization
- **Card Stack Rotation Preservation & Save/Like State Sync (`lib/core/design/editorial_card_stack.dart`)**:
  - Updated `_EditorialCardStackState.didUpdateWidget` to check `_hasSameOrderedIds(oldWidget.items, widget.items)`: when `HomeFeedCubit._syncArticleInState` emits an updated `EditorialNewsItem` list for an in-place bookmark or like update, `_cards` preserves its current rotated deck order and updates matching items in place (`_syncCardsInPlace`) instead of resetting back to card `0`.
  - Fixed `_handleSaveTap` and `_handleLikeTap` in `EditorialCardStack` so `top.isSaved` and `top.isLiked` are not prematurely mutated before invoking `widget.onToggleSave` / `widget.onToggleLike` (`HomeFeedCubit.toggleBookmark` / `toggleStar`), eliminating double-flip cancellation when saving from the card button.
- **Latest Home Feed Articles Randomization (`lib/features/home/`)**:
  - Extended `GetHomeFeedUseCase.call(...)` with pure-Dart `bool randomize = false` and optional `Random? random`, copying and shuffling the latest fetched published articles (`limit = 20`) when enabled without mutating repository data or affecting chronological callers (`LoadAuthorProfileDossierUseCase`).
  - Enabled `randomizeFeed = true` by default in `HomeFeedCubit` (with injectable `Random?` for deterministic unit tests) so each app launch / feed load presents a fresh randomized ordering of the latest published stories.
- **Saved Articles Vertical Scroll Unblocking (`lib/core/design/editorial_saved_stack.dart`)**:
  - Removed the inner `GestureDetector(onVerticalDragEnd: ...)` wrapper around cards in `EditorialSavedStack`, which previously won Flutter's vertical drag Gesture Arena over the parent `ListView` in `ArticlesSaved` and accidentally triggered `onOpenArticle` during upward scroll gestures. Vertical drags anywhere over saved cards now scroll `ListView` smoothly, while single taps (`InkWell.onTap`) open the article and horizontal swipes (`Dismissible`) delete with undo.
- **Search Filter Dialog for Categories & Tags (`lib/core/widgets/editorial_filter_dialog.dart`, `lib/features/search/`)**:
  - Extracted reusable `EditorialFilterDialog` (`showEditorialFilterDialog`) into `lib/core/widgets/editorial_filter_dialog.dart` using `ValueNotifier` state for instant in-dialog search, single-select category chips, multi-select `#tag` chips, `Reset`, and `Apply Filters (N)`.
  - Replaced the full inline `Categories` and `Filter by tags` chip clouds on `SearchView` with a compact `SearchFilterTriggerButton` beside `CustomSearchBar` and `SearchActiveFiltersBar` displaying only the user's currently active category and `#tag` chips (each individually removable via `×` or `Clear all`).
  - Added `applyFilters`, `clearFilters`, and `GetArticlesByTagUseCase` support in `SearchCubit` so users can filter by category, tags alone, or combined category + tags directly from the dialog.
- **Unified Black Category Badges Across All Article Cards**:
  - Standardized category badge backgrounds to pure black (`AppColors.black`) with high-contrast white labels (`AppColors.white`) and centralized `AppBorders` tokens across `EditorialCard`, `HomeSecondaryStoryTile`, `CustomArticleCardOfProfile`, `ArticleCardOfAuthor`, and `DownloadedArticleCardTile`, while preserving `EditorialNewsItem.badgeColor` data mapping for non-card surfaces.
- **Skeletonizer Shimmer Loading Across Saved Articles, Profile, Search & Author Pages**:
  - Created centralized `EditorialShimmer` (`paperEffect` & `darkEffect` in `lib/core/design/editorial_shimmer.dart`) shared across `HomeFeedLoadingView` and all loading surfaces.
  - Replaced `CircularProgressIndicator` loading spinners with `Skeletonizer` shimmer views matching each screen's real editorial layout:
    - **Saved Articles (`ArticlesSaved`)**: `SavedArticlesLoadingView` skeletonizing `EditorialSavedStack`.
    - **Profile (`ProfileView`)**: `ProfileInfoLoading` emission in `ProfileInfoCubit.loadProfileData`, `Skeletonizer` wrapping `ProfileAvatarAndStats` (and avatar upload state) in `PersonalInfromation`, and `ProfileArticlesLoadingView` skeletonizing `CustomArticleCardOfProfile` cards.
    - **Search (`SearchView` & `TagArticlesView`)**: `SearchLoadingView` skeletonizing `EditorialCard` results.
    - **Author (`AuthorView`)**: `Skeletonizer` wrapping `AuthorDossierHeader` during `AuthorLoading` and `AuthorLoadingView` skeletonizing the `'Published Stories'` header and `ArticleCardOfAuthor` cards.

## 14. Settings Page Clean Architecture & Functional Refactoring (`refactor/settings-page`)
- **Pruned Dead Code & Unbacked Placebo Controls (`db0bf78`)**:
  - Deleted unreferenced `lib/features/settings/presentation/widgets/settings_menu.dart` and removed unused `showDigestPickerSheet`, `showEditProfileSheet`, `SettingsValueTile`, `SettingsSliderTile`, and legacy `PaperSettings*` typedefs.
  - Removed unbacked placebo toggles (`Morning Edition Briefing`, `Investigative Breaking Alerts`, `Audio Narration Cadence`, `Bionic Reading Guide`, `Data Preservation Mode`, `Download on Wi-Fi Only`) and their 5 unused fields/setters from `SettingsState`, `SettingsCubit`, `SettingsReadingSection`, and `SettingsArchiveSection`.
- **Extracted Settings Data & Domain Layer & Fixed `ThemeModeCubit` (`b2f5de3`)**:
  - Created `ReaderPreferencesEntity`, `SettingsRepository`, `SettingsLocalDataSource`, `SettingsRepositoryImpl`, `GetReaderPreferencesUseCase`, and `UpdateReaderPreferencesUseCase`, removing direct `SharedPreferencesSingleton` access from `SettingsCubit`.
  - Added `SettingsState.toLoaded(...)` helper to eliminate repetitive constructor calls across `SettingsCubit`.
  - Updated `ThemeModeCubit` to emit `ThemeModeSystem` (registered in `setup_service_locator.dart`) and updated `MyApp` (`lib/main_app.dart`) to pattern-match `ThemeModeState` directly instead of reading `SharedPreferencesSingleton` inside `build()`.
- **Wired Reader Typography Preferences & Fixed In-Session Navigation (`7492402`)**:
  - Wired `fontScale` (`Compact` 0.90x, `Standard` 1.0x, `Editorial` 1.08x, `Large` 1.18x) into `ArticleReaderMarkdownBody` with cached `scale` `MarkdownStyleSheet` lookup.
  - Added `isFromSettings` support to `CategoriesView` / `CategoriesViewBody` and `ChangePasswordView` / `ChangePasswordForm` / `AppRoutes` so editing categories or changing password from Settings pops cleanly back to Settings instead of resetting the navigation stack to `'/'` or `/login`.
- **Reusable `EditorialConfirmDialog`, Rebuild Isolation & Test Suite (`477ff08`, `1a18412`)**:
  - Extracted `EditorialConfirmDialog` (`showEditorialConfirmDialog`) into `lib/core/widgets/editorial_confirm_dialog.dart` and scoped `BlocSelector`s per section in `SettingsViewBody`.
- **Centralized `AppConstants` Keys, Warm Paper Default Theme & App-Wide `CacheFailure` Handling (`a176b26`, `37a23ff`)**:
  - Centralized `AppConstants.fontScaleKey` (`'pref_font_scale'`), `AppConstants.defaultFontScale` (`'Standard'`), and `AppConstants.genericErrorMessage` (`"there's an error, Please try again later"`).
  - Removed "Serif Literary Immersion" completely across domain entities, use cases, repository, local data sources, cubits, settings UI, article reader markdown body, and test suites.
  - Removed the `Reading Surface Contrast` (`ThemeWidget`) selector from `SettingsReadingSection` (deleting `theme_widget.dart`) and configured **Warm Paper (`ThemeMode.light`)** as the default theme across `ThemeModeCubit` and `MyApp`.
  - Replaced all empty `catch (_) {}` and silent `failure: (_) {}` blocks across `lib/` (42 occurrences across 24 files) with `CacheFailure` / `FailureResult` error propagation and `SettingsError` state emissions (`38/38` Settings tests passing; `437/437` total tests passing, `0` analyzer issues).

## 15. Article Category Badge Dynamic Topic Color Resolution
- **Category Color Mapping (`lib/core/constants/category_items.dart`)**:
  - Implemented `getCategoryColor(slugOrNameOrBadge)` mapping each category to distinct, high-contrast background colors: Science (`#065F46`), Space (`#7C3AED`), Technology (`#2563EB`), Business (`#4338CA`), Personal Development (`#D97706`), Health & Wellness (`#0D9488`), Education (`#4F46E5`), News (`#EF4444`), Finance (`#0E7490`), Lifestyle (`#C026D3`), Travel & Culture (`#EA580C`), Food & Cooking (`#E11D48`), Sports (`#0F172A`), Entertainment (`#DB2777`), Art & Design (`#B45309`), History (`#78350F`), Psychology (`#6D28D9`), Environment (`#047857`), and default Ink (`#171614`).
  - Added `getCategoryColorHex(slugOrNameOrBadge)` returning formatted `#RRGGBB` strings.
- **Top Bar Badge Resolution & Publishing Payload**:
  - In `ArticleEntityEditorialMapper.toEditorialNewsItem`, resolved `badgeColor` so that if `badgeColor` is empty, null, or `#FFF1C6` (the schema default that previously matched the paper background), it resolves to `getCategoryColor(categorySlug.isNotEmpty ? categorySlug : badge)`, preventing the badge from blending into the page background.
  - In `DownloadedArticleEntityEditorialMapper.toEditorialNewsItem`, assigned `badgeColor: getCategoryColor(categorySlug)`.
  - In `ArticlePayloadBuilder.buildPublishPayload`, stored `'badge_color': getCategoryColorHex(category.slug)` for newly published articles.
  - Added unit and widget tests in `test/core/constants/category_items_test.dart`, `test/core/design/editorial_models_category_color_test.dart`, and `test/features/article/presentation/widgets/article_reader_top_bar_test.dart` (446/446 tests passing, 0 analyzer issues).

## 16. Dynamic App Version Resolution & Settings Footer (Option C)
- **Runtime Version Inspection (`lib/core/services/app_info_service.dart`)**:
  - Integrated `package_info_plus` to automatically read the current version and build number directly from `pubspec.yaml` (e.g., `version: 1.0.0+1`), eliminating hardcoded version numbers in the UI.
  - Created `AppInfoService` singleton with safe default fallbacks (`'1.0.0'`, `'1'`) and test mocking hooks (`setMockInstance`, `reset`), ensuring widget and unit tests never throw `LateInitializationError`.
  - Initialized `await AppInfoService.init()` in `main.dart` and registered `PackageInfo` in `setup_service_locator.dart` if initialized.
- **Ultra-Light Dynamic Settings Footer (`lib/features/settings/presentation/widgets/settings_footer.dart`)**:
  - Implemented Option C (Ultra-Light Dynamic Stamp) as a dedicated, reusable `SettingsFooter` widget.
  - Dynamically renders `MINDFEED v{version}+{buildNumber} · VERIFIED JOURNALISM` and tagline `Built for thoughtful and uninterrupted reading` using `AppColors.mutedInk`.
  - Replaced the previous hardcoded static text block (`MINDFEED v2.4 · VERIFIED JOURNALISM`) in `SettingsArchiveSection` with `const SettingsFooter()`.
- **Unified App Name via `AppInfoService.appName`**:
  - Deleted `AppConstants.appName` from `lib/core/constants/constants.dart`.
  - Migrated all app-wide references (`MyApp.title`, `SettingsFooter`, `HomeMastheadAnimatedTitle`, and `AppConstants.mastheadRotatingWords`) to read `AppInfoService.appName` dynamically.
- **Testing & Verification**:
  - Added unit tests in `test/core/services/app_info_service_test.dart` and widget tests in `test/features/settings/presentation/widgets/settings_footer_test.dart` (452/452 tests passing, 0 analyzer issues).

## 17. GitHub Pages Editorial Ethics & Privacy Policy Website
- **Stand-alone Web Portal (`/media/windows/workspace/My_Apps/Mind_Feed/privacy-policy/`)**:
  - Created a responsive static web application designed for GitHub Pages hosting containing MindFeed's full Editorial Ethics Charter and Privacy Policy.
  - Aligned with MindFeed's warm paper design system:
    - **Palette**: Warm Paper (`#F6F0E4` canvas / `#FFFDF8` card) and Night Edition (`#141311` canvas / `#1E1D19` card) with refined hairline borders (`#E5DECE`).
    - **Typography**: Google Fonts pairing of `Newsreader` (editorial serif) and `Plus Jakarta Sans` (modern sans).
    - **Animations**: Live reading progress bar, smooth scroll-triggered section reveal (`IntersectionObserver`), active section scrollspy tracking, and animated theme switcher.
    - **Responsive Architecture**: Sticky table of contents and focused reading well on PC; horizontal scrollable pill navigation on smartphones.
  - Tailored policy content addressing:
    - Author sovereignty & non-exclusive intellectual property retention.
    - Constructive community standards and abuse prevention.
    - Zero ad-trackers guarantee (no advertising exchanges, profiling, or data selling).
    - Necessary encrypted account credentials and on-device storage sovereignty (instant cache clearing).
    - Clear reader rights to access and complete account/data deletion.

## 18. In-App Integration with Policy Website via `url_launcher`
- **Settings Screen Action Tile Launch (`lib/features/settings/presentation/widgets/settings_archive_section.dart`)**:
  - Configured `AppConstants.privacyPolicyUrl` (defaulting to `https://mindfeed-org.github.io/Privacy-Policy/` with configurable `PRIVACY_POLICY_URL` environment override).
  - Wired the "Editorial Ethics & Privacy Charter" tile in the Settings screen to launch the external web page directly in the device's browser using `url_launcher`.
  - Added robust fallback to `showPrivacyManifestDialog` if the platform browser cannot be launched or when running in restricted environments.
  - Updated `showPrivacyManifestDialog` copy in `lib/features/settings/presentation/widgets/settings_dialogs.dart` to match the refined charter (Author Sovereignty, Zero-Trackers, Reader Sovereignty).
  - Repositories transitioned to organization `MindFeed-Org`:
    - Mobile App: `https://github.com/MindFeed-Org/MindFeed`
    - Privacy Policy Site: `https://github.com/MindFeed-Org/Privacy-Policy` (deployed to `https://mindfeed-org.github.io/Privacy-Policy/`)

## 19. Text-Only Offline Article Downloads & Bottom Navigation Bar Integration
- **Text-Only Offline Persistence (`DownloadArticleTextUseCase` & `ArticleReaderDependencies`)**:
  - Updated `DownloadArticleTextUseCase` (`lib/features/article/domain/usecases/download_article_text_use_case.dart`), `ArticleReaderDependencies.mapToDownloadedEntity` (`lib/features/article/presentation/controllers/article_reader/article_reader_deps.dart`), and `DownloadedArticleEntityEditorialMapper.toEditorialNewsItem` (`lib/core/design/editorial_models.dart`) so downloading an article persists **only the article text content and metadata** (`coverImageUrl: null`, `coverImageBytes: null`, `authorAvatarBytes: null`) without downloading or storing cover images.
- **Always-Accessible Bottom Navigation Bar Tab (`MainNavigationBar` & `MainView`)**:
  - Added the **Downloads** destination (`AppIcons.download`, label `'Downloads'`) directly to the floating bottom navigation bar (`lib/features/main/presentation/widgets/main_navigation_bar.dart`) at index `3` (between `Saved news` at index `2` and `Profile` at index `4`), expanding the pill width to `304px`.
  - Integrated `DownloadedArticlesView(refreshSeed: _downloadsRefreshSeed)` into `MainView` (`lib/features/main/presentation/views/main_view.dart`) so switching to or re-tapping the Downloads tab automatically refreshes the local Hive list, making downloaded articles accessible anytime whether online or completely offline.
- **Modernized Editorial Downloads UI (`DownloadedArticlesView`, `DownloadedArticlesViewBody`, `DownloadedArticleCardTile`)**:
  - Removed the legacy `AdvancedDrawer` / `CustomDrawer` wrapper from `DownloadedArticlesView` and aligned `DownloadedArticlesViewBody` with the transparent floating nav shell (`Material(color: Colors.transparent)`, `SafeArea(top: true, bottom: false)`).
  - Removed cover image banners from `DownloadedArticleCardTile` in favor of a clean text-first editorial card layout with category badge, title, 2-line excerpt preview, reading time, download date, author name, and swipe/button deletion.

## 20. Dedicated Offline Article Reader View (`DownloadedArticleReaderView`)
- **Focused Offline Reading View (`lib/features/collections/presentation/views/downloaded_article_reader_view.dart`)**:
  - Implemented `DownloadedArticleReaderView` specifically tailored for reading downloaded articles offline without unnecessary network or interactive clutter.
  - Displays **only** essential reading elements:
    - Top bar: back button (`article_reader_back_button`) and category badge (`article.categorySlug.toUpperCase()` or `'OFFLINE'` with `getCategoryColor`).
    - Article title and metadata header (`ArticleReaderMetadataHeader`) displaying title, `'Offline edition'`, and `readingTimeMinutes`.
    - Markdown body (`ArticleReaderMarkdownBody`) rendering article text content and excerpt.
    - Floating slow-scroll bar (`ArticleSlowScrollBar`) supporting continuous hands-free slow scroll, selectable speed paces (`0.5x`, `1.0x`, `1.5x`, `2.0x`), and extend/retract toggling.
  - Excludes online-only and redundant elements: author profile card, author 5-star rating bar, cover image, like/save/download action bar, and tag cloud.
  - Uses `ValueNotifier<({bool isScrolling, double pace, bool isRetracted})>` to manage the slow-scroll bar UI state cleanly without rebuilding the entire article scroll view.
- **Route & Tile Integration**:
  - Registered `AppRoutes.downloadedArticleReader` (`'/downloaded-article-reader'`) in `lib/config/routes/app_routes.dart`.
  - Updated `DownloadedArticleCardTile.onTap` (`lib/features/collections/presentation/widgets/downloaded_article_card_tile.dart`) to push `AppRoutes.downloadedArticleReader` passing the `DownloadedArticleEntity` directly.
- **Testing & Verification**:
  - Created `test/features/collections/presentation/views/downloaded_article_reader_view_test.dart` verifying all offline rendering rules, absent widgets (author, rating, cover image, action bar), slow-scroll controls, and null-article empty state handling (`6/6` tests passing, `0` analyzer issues).

## 21. Fast-Fail Offline Resolution & Unified Offline Error UI Across Home & Profile
- **Root-Cause Fix for Offline Delays (`ProfileRepoImpl`, `GetUserFeedTopicsUseCase`, `ProfileInfoCubit`, `ArticlesRepositoryImpl`)**:
  - Added fast-fail `_isOnline()` connectivity checks across `ProfileRepoImpl` (`getProfile`, `updateProfile`, `getCategories`, `getFavoriteCategories`, `syncFavoriteCategories`, `reconcilePendingCategorySync`) and injected `NetworkInfo` via `setup_service_locator.dart`. Previously, `ProfileRepoImpl` attempted unguarded remote Supabase requests when offline, causing both `HomeFeedCubit.fetchFeed()` (via `GetUserFeedTopicsUseCase`) and `ProfileInfoCubit.loadProfileData()` to wait for TCP socket timeouts.
  - Updated `GetUserFeedTopicsUseCase` to skip secondary `getCategories()` lookups if `_loadRemoteFavorites()` fails.
  - Parallelized the 4 remote queries in `ProfileInfoCubit.loadProfileData()` using `Future.wait([...])` instead of 4 sequential `await` calls, and added 6-second request timeouts in `ProfileRepoImpl` and `ArticlesRepositoryImpl` (`getHomeFeed`, `getArticlesByAuthor`).
- **Unified Offline Error State & View on Profile (`ProfileArticlesCubit` & `ProfileArticlesErrorView`)**:
  - Updated `ProfileArticlesCubit` to map offline/network/socket/timeout errors to `'You are currently offline. Please check your internet connection.'`, matching `HomeFeedCubit`.
  - Updated `ProfileArticlesErrorView` (`lib/features/profile/presentation/widgets/profile_articles_status_views.dart`) to render `AppIcons.wifiOffRounded`, `AppTextStyles.homeErrorMessage`, and `CustomButton` (`Retry`), matching `HomeFeedErrorView`, and wired `onRetry` in `UserArticles` to refresh both `ProfileArticlesCubit` and `ProfileInfoCubit`.





