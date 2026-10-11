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
  - Upgraded Gradle wrapper to `9.1.0`, AGP to `9.0.1`, and Kotlin to `2.3.20`, eliminating all build deprecation warnings.
