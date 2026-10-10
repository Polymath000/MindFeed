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
- **Networking**: `dio` (with mock local auth datasource)
- **Zero Firebase Dependency**: Fully decoupled from Firebase SDKs, CLI configurations, and external Google services.

## 4. Recent Project Changes
- **Firebase Completely Removed**:
  - Removed `firebase_core` and `cloud_firestore` from `pubspec.yaml`.
  - Removed `com.google.gms.google-services` plugin from Android Gradle build files (`android/app/build.gradle.kts` and `android/settings.gradle.kts`).
  - Removed `lib/firebase_options.dart`, `firebase.json`, and `android/app/google-services.json`.
  - Removed Firebase initialization call (`Firebase.initializeApp`) from `lib/main.dart`.
  - Updated `EndPoint` and `AuthApiSource` to provide simulated client-side mock authentication without Firebase Identity Toolkit dependencies.
- **Android Build Toolchain Upgraded**:
  - Upgraded Gradle distribution from `8.12` to `8.14` in `android/gradle/wrapper/gradle-wrapper.properties`.
  - Upgraded Android Gradle Plugin (AGP) from `8.7.3` to `8.11.1` in `android/settings.gradle.kts`.
  - Upgraded Kotlin Gradle Plugin from `2.1.0` to `2.2.20` in `android/settings.gradle.kts`.
