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

