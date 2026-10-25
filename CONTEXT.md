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
- **Secret Management (1Password & Environment)**:
  - Secret keys are never committed in the source code.
  - Dedicated 1Password vault `MindFeed` created with item `Supabase` containing `PROJECT_URL` and `SUPABASE_PUBLISHABLE_KEY`.
  - Credentials injected via 1Password CLI (`op inject` / `op run`) or `--dart-define` / `--dart-define-from-file`.
  - In code, constants resolve via `String.fromEnvironment('PROJECT_URL')` and `String.fromEnvironment('SUPABASE_PUBLISHABLE_KEY')` with fallback to `SUPABASE_URL` / `SUPABASE_ANON_KEY`.
  - `.env` files are strictly ignored in `.gitignore`.
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



