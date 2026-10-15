# MindFeed Editorial UI Specification & Architecture

## Overview
This document outlines the complete editorial design implementation for MindFeed, matching the visual aesthetic and interaction model from the design guidelines and reference material.

---

## 1. Visual Design Language (`lib/core/design/editorial_design.dart`)

### Palette
* **Deep Ink (`0xFF171614`)**: Primary dark canvas background.
* **Elevated Charcoal (`0xFF262422`)**: Search bars, input fields, and secondary containers.
* **Warm Cream (`0xFFFFF1C6`)**: Primary card surface and reading background.
* **Butter (`0xFFFFE8A1`)**: Warm accent surface.
* **Blush Rose (`0xFFFFDDE0`)**: Secondary card accent surface.
* **Powder Blue (`0xFFDCEEFF`)**: Tertiary card accent surface.
* **Soft Lilac (`0xFFE9DEFF`)**: Policy, commentary, and sports accent surface.
* **Mint (`0xFFD7F5E8`)**: Science and climate accent surface.
* **Peach (`0xFFFFE5D0`)**: Health and biology accent surface.
* **Sand (`0xFFF5EEDC`)**: Astrobiology and wellness accent surface.
* **Soft Cream (`0xFFFFF8E6`)**: Primary typographic text color for maximum legibility on dark surfaces.
* **Muted Ink (`0xFF514D46` / `0xFFAAA49B`)**: Subtitles, dates, bylines, and secondary metadata.

### Geometry & Radii
* **Cards**: `BorderRadius.circular(26.0)`
* **Controls & Inputs**: `BorderRadius.circular(24.0)`
* **Badges & Pills**: `BorderRadius.circular(16.0)`

---

## 2. Reusable Modular Components

### Data Models & Repository (`lib/core/design/editorial_models.dart`, `editorial_mock_data.dart`)
* `EditorialNewsItem`: Immutable entity carrying story metadata, badge label/color, title, timestamp, author profile, excerpt, background color, and reactive bookmark/like states.
* `EditorialMockData`: Centralized dataset providing 14+ test articles across diverse topics (Technology, Science, Health, Culture, Sports, Design, Climate, Space, AI).

### Card Component (`lib/core/design/editorial_card.dart`)
* Self-contained responsive card with badge pill, high-contrast typography, author bylines, follow chip, scrollable excerpt, and action triggers (like, bookmark, share).

### Stacked Deck with Dismiss & Open Animations (`lib/core/design/editorial_card_stack.dart`)
* Multi-card depth perspective (`0.94`, `0.97`, `1.0` scale).
* Horizontal swipe with physics-based angular rotation and ease-out recycling.
* Swipe-up or tap gesture to open full article reader.

### Saved Stack with Swipe-to-Delete (`lib/core/design/editorial_saved_stack.dart`)
* Cascading paper pile layout (-24px margin overlap).
* Swipe-to-delete with background trash indicator and SnackBar undo.
* Instant tap-to-read.

### Floating Editorial Navigation (`lib/features/main/presentation/widgets/main_navigation_bar.dart`)
* Translucent dark floating pill dock (`72px`) with Home, Search, and Saved destinations.

---

## 3. Screen Implementations

1. **MindFeed Home Feed (`lib/features/home/presentation/widgets/home_view_body.dart`)**:
   * Masthead with official MindFeed emblem (`assets/images/MindFeedLogo.png`) and typography.
   * Interactive topic filters: All, Trending, Tech, Science, Health, Sports.
   * `EditorialCardStack` deck cycling through 14+ test articles.

2. **Saved Stories (`lib/features/collections/presentation/views/articles_saved.dart`)**:
   * Live search filter for saved articles.
   * `EditorialSavedStack` with swipe dismissal.

3. **Authentication Surfaces (`lib/features/auth/presentation/`)**:
   * **Login View**: Deep ink radial glow, MindFeed emblem, charcoal inputs, and warm cream action button.
   * **Sign Up View**: Responsive form layout, real-time password criteria checklist, and security recommendations.
   * **Password Reset & Code Verification**: Clean flow with email confirmation and verification code input.

4. **Profile & "My Articles" (`lib/features/profile/`, `lib/features/author/`)**:
   * **Profile View**: Golden ring avatar frame, author bio, stats (Articles, Followers, Following), and "My Articles" editorial cards with edit, delete, and share actions.
   * **Author Profile**: Dedicated author layout displaying published stories.

5. **Article Reader (`lib/features/home/presentation/views/article_view.dart`)**:
   * Full-bleed warm cream canvas, pills hero image, Wade Warren avatar, and action dock.

---

## 4. Documentation & Verification Assets
All screenshots are captured from the live running web instance (`http://localhost:8088`) and stored in `docs/screenshots/`:
* `docs/screenshots/desired_ui.jpg` (Design reference)
* `docs/screenshots/current_home.png` (MindFeed Home with logo and topics)
* `docs/screenshots/current_login.png` (Refined Login)
* `docs/screenshots/current_signup.png` (Refined SignUp)
* `docs/screenshots/current_profile.png` (Profile & My Articles)
* `docs/screenshots/current_author.png` (Author Profile)
* `docs/screenshots/current_saved.png` (Saved News Stack)
* `docs/screenshots/current_article.png` (Article Reader)

## 5. Automated Tests
* `test/widget_test.dart`: MindFeed masthead, navigation dock, responsive constraints.
* `test/editorial_stack_test.dart`: Stack gestures (swipe-up to open, swipe to cycle, swipe-to-delete).
* `test/web_service_locator_test.dart`: Multi-platform service locator safety.
