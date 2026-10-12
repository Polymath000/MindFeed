# Mind Feed - Project Context & Overview

## Project Summary
Mind Feed is an editorial-first Flutter mobile application tailored for reading, discovering, drafting, previewing, and publishing articles across 20 curated categories. It combines clean visual design with offline text-reading capabilities, theme personalization, and a structured Clean Architecture implementation.

## Project Documentation Authority
The project is documented across two complementary authorities:
1. **Business Requirements Document:** [`BRD.md`](file:///media/windows/workspace/My_Apps/Mind_Feed/mind_feed/BRD.md)
   * High-level business strategy, vision, problem statement, business KPIs, competitive landscape, monetization roadmap, and governance policies.
2. **Product Requirements Document (Feature Spec):** [`SPEC.md`](file:///media/windows/workspace/My_Apps/Mind_Feed/mind_feed/SPEC.md) (`mindfeed.core.mvp`)
   * User personas, user stories, functional acceptance criteria (GIVEN/WHEN/THEN), edge cases, publishing validations, and testable proof contract.

## Key Product & Business Decisions
- **Authentication:** Mandatory via Supabase supporting both Email/Password and Google OAuth (no guest mode).
- **User Roles:** Single unified dashboard user (every authenticated user can read, bookmark, star, share, draft, preview, and publish articles; no separate author tier).
- **Backend:** 100% real Supabase cloud integration for authentication and database operations (no mock or simulated data).
- **The 20 Fixed Categories:**
  1. Technology
  2. Science
  3. Business & Entrepreneurship
  4. Personal Development
  5. Health & Wellness
  6. Education & Learning
  7. News & Current Events
  8. Politics
  9. Finance & Investing
  10. Lifestyle
  11. Travel & Culture
  12. Food & Cooking
  13. Sports
  14. Entertainment & Movies
  15. Books & Literature
  16. Art & Design
  17. Programming & Software Development
  18. History
  19. Psychology
  20. Environment & Sustainability
- **Category Preference Management:** Users pick categories during onboarding and can update them anytime via Settings; updates immediately re-prioritize the Home feed.
- **Drafts & Publishing:**
  - Dedicated Drafts page to view, edit, and manage drafts.
  - Drafts are part of the articles domain model with a status transition (`draft` -> `published`).
  - Pre-publish article Preview mode allows authors to inspect the exact reader rendering before publishing.
  - Validation: Title max 12 words, content min 300 words, cover image required (landscape only), exactly 1 of the 20 categories, 1 to 5 fixed tags.
  - Article Lifecycle: Author can edit or delete their article within 30 days of publication. After 30 days, the article is permanently locked.
- **Starring & Sharing:** Users can star articles (binary toggle, live public counter) and share articles via native OS share sheets.
- **Offline Reading:** Downloaded articles store text and metadata only. Network images are not downloaded or cached locally to conserve storage and data.
- **Logout Purge:** When a user logs out, all offline downloaded articles and cached sessions are cleared from the device.
- **Notifications:** Deferred to Phase 2.

## Tech Stack & Core Libraries
- **Framework:** Flutter 3.9+ / Dart 3.9+
- **State Management:** BLoC / Cubit (`flutter_bloc: ^9.1.1`)
- **Dependency Injection:** GetIt (`get_it: ^8.2.0`)
- **Persistence & Cache:** Hive (`hive_flutter: ^1.1.0`), SharedPreferences
- **Backend & Network:** Supabase (`supabase_flutter: ^2.18.2`), Dio with interceptors
- **Error Handling Pattern:** Native Dart 3 sealed class `ApiResult<T>` with `Failure` hierarchy

## Architecture & Directory Layout
Following Feature-First Clean Architecture:
```text
lib/
├── config/              # Themes (app_colors, app_text_styles), AppRoutes (onGenerateRoute)
├── core/                # Shared utilities, constants, networking, errors, widgets
└── features/
    ├── onboarding/      # First-run onboarding experience & 20-category selection
    ├── auth/            # Auth (Email/Password & Google Sign-In via Supabase)
    ├── home/            # Main feed, editorial cards, article reader view, sharing
    ├── search/          # Keyword search, category & tag discovery
    ├── collections/     # Saved bookmarks, offline downloaded articles (text-only)
    ├── add_article/     # Article drafting, dedicated Drafts page, Preview mode, publishing
    ├── author/          # Author profile and bio
    ├── profile/         # User profile management
    ├── settings/        # Light/Dark mode, preferred categories editing, logout wipe
```

## Recent Maintenance
- **Dependency Pruning:** Removed 4 unused dependencies (`cupertino_icons`, `flutter_localization`, `google_nav_bar`, `line_icons`). Configured official `flutter_localizations` from Flutter SDK and `intl`.
- **Asset Pruning:** Scanned and removed 9 unused asset files from `assets/images/` (`back.jpeg`, `news_logo.jpg`, `right_phone.jpg`, `right_phone_actual.jpg`, `top_bar_ref.jpg`, `top_right_bright.jpg`, `top_right_ref.jpg`, `top_right_ref2.jpg`, `wade_avatar.jpg`). Synced `app_images.dart` and updated `AuthorCard` to use valid avatar.
- **Logo Migration:** Replaced the legacy SVG emblem (`assets/images/logo.svg`) with the high-resolution raster emblem `assets/images/MindFeedLogo.png`. Updated all UI usages (`Logo`, `SignUpFormBody`, `CustomDrawer`, `HomeViewBody`) to use Flutter's `Image.asset`, deleted `assets/images/logo.svg`, and cleaned up asset constant declarations in `lib/core/utls/app_images.dart`.
