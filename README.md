# Mind Feed

A modern Flutter application for managing and consuming content articles with a beautiful, intuitive user interface.

## Overview

Mind Feed is a feature-rich Flutter application designed to provide an exceptional reading experience. The app follows clean architecture principles with proper separation of concerns across presentation, domain, and data layers.

> **Note**: This application is **UI-only** and does not have a backend. All features including authentication, data storage, and content management are simulated on the client side for demonstration and UI/UX development purposes.

## Features

- **Onboarding Flow**: Smooth introduction screens for new users
- **Authentication**: Login and signup UI with form validation
  - Email-based authentication
  - Password requirements display
  - Category selection
  - Password reset flow (code verification)
- **Home Screen**: Article feed with cards, filtering, and favorites
- **Search**: Content search functionality
- **Collections**: Saved articles and favorites management
- **Settings**: Theme customization (light/dark mode)
- **Localization**: Multi-language support

## Architecture

The project follows **Clean Architecture** with three main layers:

```
lib/
├── config/           # App configuration, themes, extensions
├── core/             # Shared utilities, constants, network, database, widgets
│   ├── constants/    # App constants
│   ├── database/    # Local storage (cache, API endpoints)
│   ├── errors/      # Error handling
│   ├── helpers/     # Utility helpers
│   ├── network/     # Network configuration
│   ├── services/    # Shared services
│   ├── utls/        # Images, utilities
│   └── widgets/    # Reusable widgets
├── features/        # Feature modules
│   ├── auth/       # Authentication (login, signup, password reset)
│   ├── collections/# Saved articles and favorites
│   ├── home/       # Home feed and articles
│   ├── onboarding/ # Onboarding screens
│   └── settings/   # App settings and themes
└── l10n/           # Localization files
```

## Technology Stack

- **Framework**: Flutter 3.9+
- **State Management**: BLoC (flutter_bloc)
- **Dependency Injection**: GetIt
- **Network**: Dio with interceptors
- **Local Storage**: Hive, SharedPreferences
- **Functional Programming**: dartz (Either type for error handling)

### Key Dependencies

| Package | Purpose |
|---------|---------|
| flutter_bloc | State management |
| get_it | Dependency injection |
| dio | HTTP client |
| hive | Local NoSQL database |
| shared_preferences | Key-value storage |
| flutter_localization | Internationalization |

## Getting Started

### Prerequisites

- Flutter SDK 3.9 or higher
- Dart SDK 3.9 or higher
- Android Studio / VS Code with Flutter extensions

### Installation

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd mind_feed
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Generate localization files (if needed):
   ```bash
   flutter gen-l10n
   ```

4. Run the app:
   ```bash
   flutter run
   ```

### Building APK

```bash
# Debug build
flutter build apk --debug

# Release build
flutter build apk --release
```

## Recent Changes

The following changes were made in the latest updates:

- **Loading Indicator**: Implemented `CustomLoadingIndicator` for consistent loading UI across the application
- **Signup Logic**: Completed the domain and data layers for signup functionality with state management using Cubit
- **Dependency Injection**: Configured GetIt to create and manage instances of `AuthRepoImpl`
- **Security Improvements**: Enhanced failure handling and made error messages more meaningful; removed password variable from user model and entity for better security
- **Firebase Removal**: Completely removed Firebase dependencies, configurations, and plugins, switching to client-side simulated local authentication

## Screenshots

The app includes the following main screens:
- Onboarding (3-page intro)
- Login / Sign Up
- Password Reset (send code, check code, change password)
- Home Feed
- Search
- Collections / Favorites
- Settings

## License

This project is for demonstration purposes.