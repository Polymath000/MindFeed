# Project Context: Mind Feed

## 1. Overview
Mind Feed is a Flutter content and article reading application featuring an editorial paper-aesthetic UI, clean architecture, and simulated client-side authentication and content flows.

## 2. Architecture & Directory Structure
The codebase follows **Feature-First Clean Architecture**:
- `lib/config/`: App routing (`onGenerateRoute`), themes, color palette, typography.
- `lib/core/`: Reusable components, design system primitives (`editorial_card`, `editorial_card_stack`), network utilities, local cache helpers, constants, and dependency injection (`setup_service_locator.dart`).
- `lib/features/`: Feature modules adhering to presentation, domain, and data layers:
  - `auth/`: Authentication (login, sign-up, password reset, categories).
  - `home/`: Editorial home feed, article cards, card deck navigation.
  - `articles_saved/`: Saved news stack and bookmarks.
  - `author/`: Author profiles and author articles.
  - `search/`: Search and category filtering.
  - `settings/`: App settings and theme mode toggles.
  - `profile/`: User profile and authored articles.
  - `add_article/`: Local article authoring and device preferences.

## 3. Technology Stack & Key Libraries
- **Framework**: Flutter 3.9+ / Dart 3.9+
- **State Management**: BLoC / Cubit (`flutter_bloc`)
- **Dependency Injection**: `get_it`
- **Local Storage**: `hive`, `hive_flutter`, `shared_preferences`
- **Backend & Network**: `supabase_flutter`, `http`, `connectivity_plus` with custom `SupabaseInterceptor`
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
  - Streamlined `HomeMastheadHeader`, giving full horizontal breathing room to the animated app title and leaving only the profile icon button on the right.
  - Wrapped `HomeViewBody` in `_HomeViewScaffold` under `BlocProvider<HomeFeedCubit>` to guarantee clean access to `HomeFeedCubit` on post-creation refresh.
  - Added dedicated widget test in `test/features/home/home_write_article_fab_test.dart` (all 228 tests passing).



