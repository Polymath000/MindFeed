# MindFeed — End-to-End Supabase Backend, Feature Implementation, Clean Architecture Refactoring & Security Audit Report

Date: 2026-10-17
Database: Supabase (Project ID: `tsqruoqiajkbrdhprfxa`, URL: `https://tsqruoqiajkbrdhprfxa.supabase.co`, Name: `MindFeed`, Region: `eu-west-1`)
Repository Path: `C:/Users/Hp/OneDrive/Documents/Projects/MindFeed/MindFeed-main`
Git Branch: `feature/supabase-implementation`

---

## 1. Executive Summary

This report documents everything accomplished across the entire engineering session, the architectural and mechanical rationale behind every decision ("why certain things were done"), the complete file-by-file and migration-by-migration diff inventory, and the empirical verification evidence across both the Flutter application and the live hosted Supabase PostgreSQL database (`tsqruoqiajkbrdhprfxa`).

### Summary of Outcomes
1. **Branch Synchronization with `origin/main`**: Merged the 9 upstream commits from `origin/main` into `feature/supabase-implementation`, resolving conflicts in core DI, routing, auth, onboarding categories, and profile layers without losing upstream Clean Architecture use cases or local editorial UI styling.
2. **End-to-End Feature & Backend Wiring (4 Parallel Subagents A–D)**:
   - Implemented full Markdown article authoring, field-level validation (1–12 title words, >=300 body words, landscape cover image dimension validation via `ImageStream`, 1 category, 1–5 fixed tags), draft saving, live preview, and publishing.
   - Implemented the live Markdown article reader (`ArticleView`), optimistic endorsements and bookmarking (`ToggleBookmarkUseCase`) with rollback on failure, and text-only offline article downloads (`DownloadArticleTextUseCase` / `DownloadsCubit`).
   - Implemented debounced (350ms) live keyword search (`SearchArticlesUseCase`), live category filtering (`GetArticlesByCategoryUseCase`), and tag filtering (`SearchCubit`), and purged all mock fallbacks (`EditorialMockData`) in compliance with Business Rule BR-12.
   - Implemented profile article management (`ProfileArticlesCubit`) enforcing the 30-day edit/delete immutability window (`isEditableWithinWindow`) and updated navigation (`CustomDrawer`, `SettingsViewBody`).
3. **Clean Architecture & Single Responsibility Principle (SRP) Refactoring (4 Parallel Subagents R1–R4)**:
   - Decoupled **100% of presentation-layer views and cubits** from `supabase_flutter` and `hive` by introducing `CurrentUserSession` (`lib/core/services/current_user_session.dart`).
   - Decomposed **12 monolithic presentation files** (previously up to 667 lines) into focused, single-responsibility widgets, bringing all main view files under **160 lines** and all extracted widget files under **215 lines**.
4. **Emulator Deployment, Environment Injection & Auth OTP Verification**:
   - Diagnosed and resolved the emulator `Create Account` error (`Supabase libraries not initialized`): `String.fromEnvironment` requires compile-time `--dart-define-from-file=.env` when building/running on the Android emulator (`emulator-5554`), keeping zero fallback credentials in source code.
   - Documented and verified the end-to-end Supabase Forgot Password / Email OTP recovery flow (`resetPasswordForEmail` -> `verifyOTP(type: OtpType.recovery)` -> `UserAttributes(password: newPassword)` -> `signOut(scope: SignOutScope.others)`).
5. **Home Feed Gestures (Swipe-Right Save, Swipe-Left Next & Vertical Scroll Passthrough) + Article Creation**:
   - Enhanced `EditorialCardStack` so **swiping right** saves the top article (`ToggleBookmarkUseCase` with idempotent `.upsert(..., onConflict: 'user_id,article_id')` and live `saves_count` trigger), **swiping left** advances to the card behind it without saving, and **swiping down/up** forwards vertical drag deltas directly to the parent `HomeViewBody` `ListView` to scroll smoothly through the `More Stories` section below.
   - Hardened backend article creation (`handle_article_lifecycle` auto-provisioning `public.profiles`, generating unique slugs, category badges, excerpts, and reading times) and added preset landscape cover chips and Profile/Home write entry points.
6. **Floating & Retractable Slow-Scroll Reader, Under-Author 5-Star Ratings & Article Likes**:
   - Built `ArticleSlowScrollBar` with selectable paces (`0.5x`, `1.0x`, `1.5x`, `2.0x`) and a **far-right retractable bar handle** (`Key('slow_scroll_retract_button')`), anchored in a `Stack` at the **bottom-right** of `ArticleView` (`Positioned(bottom: 16, left: 20, right: 20)`) so it stays floating across the entire article scroll depth without creating any blank space above the Back button or Category badge.
   - Separated **5-Star Author Ratings** (rendered directly beneath the author name in `ArticleReaderAuthorBar`, backed by `public.author_ratings` and RPCs `public.rate_author` / `public.get_author_rating_summary`) from **Article Likes** (`public.article_likes`, rendered in `ArticleReaderActionBar` and on `EditorialCard`).
7. **Live Supabase Security Hardening & Adversarial Verification (`14` Applied Migrations)**:
   - Revoked `CREATE ON SCHEMA public` from `PUBLIC, anon, authenticated` and configured `SET search_path = ''` on all functions in `public` with schema-qualified references.
   - Protected `public.profiles` rating aggregates (`rating_avg`, `rating_count`) via `public.handle_profile_rating_protection()` (`SECURITY INVOKER SET search_path = ''`, gating on `pg_catalog.pg_trigger_depth() <= 1`, `uses_current_user: false`).
   - Protected `public.articles` counter columns (`star_count`, `likes_count`, `saves_count`, `author_rating_avg`, `author_rating_count`) on both `INSERT` and `UPDATE` in `public.handle_article_lifecycle()` (`SECURITY INVOKER SET search_path = ''`, gating on `pg_catalog.pg_trigger_depth() <= 1`).
   - Hardened `public.rate_author` and `public.validate_and_normalize_author_rating()` to derive and validate canonical `(author_key, author_id, author_name)` server-side against `public.articles` and `public.profiles`, and revoked `EXECUTE` on `public.rate_author` from `PUBLIC` and `anon`.
8. **Verification & Build Readiness**:
   - `flutter analyze`: **0 issues found**.
   - `flutter test`: **225/225 tests passed** (`194 -> 206 -> 223 -> 225` fully reconciled).
   - `flutter build apk --debug --dart-define-from-file=.env`: **Built and installed on `emulator-5554`**.
   - Repository token and screenshot hygiene scan: **0 matches** for `sbp_` in the repository or git history, and **0 temporary screenshots** left on disk.

---

## 2. Why Certain Decisions Were Made (Architectural & Mechanical Rationale)

### 2.1 Why `origin/main` Was Merged Before Feature Orchestration
- **Problem**: `feature/supabase-implementation` was 9 commits behind `origin/main`, where Phase 2–4 domain entities, repository interfaces, use cases (`SaveDraftUseCase`, `PublishArticleUseCase`, `UpdateArticleUseCase`, `DeleteArticleUseCase`, `ToggleStarUseCase`, `DownloadArticleTextUseCase`, etc.), and initial auth/category wiring had been landed.
- **Why We Resolved Conflicts the Way We Did**:
  - For **architecture, DI (`setup_service_locator.dart`), routing (`app_routes.dart`), and tests**, we took `origin/main`'s Clean Architecture use-case registrations so all downstream features could consume real Supabase repositories via `getIt`.
  - For **visual presentation (`categories_view.dart`, `profile_view.dart`, `personal_infromation.dart`)**, we combined `origin/main`'s live cubit state management with `feature/supabase-implementation`'s responsive constraints (`ConstrainedBox(maxWidth: 500)`) and editorial typography.

### 2.2 Why `CurrentUserSession` Was Created (`lib/core/services/current_user_session.dart`)
- **Problem**: Presentation-layer views and cubits (`AddArticleCubit`, `DraftsCubit`, `HomeViewBody`, `ArticleReaderCubit`, `CollectionsCubit`, `ProfileArticlesCubit`, `PersonalInformation`, `SettingsViewBody`) were importing `package:supabase_flutter/supabase_flutter.dart` and `package:hive/hive.dart` directly.
- **Solution**: Extracted `CurrentUserSession` and `CurrentUserSnapshot` in `lib/core/services/current_user_session.dart`. It encapsulates session resolution, display-name fallback chains (Hive cached `UserEntity` -> Supabase user metadata -> email prefix -> `'Anonymous'`), and category cache persistence, while allowing deterministic injection (`userResolver` / `userIdResolver`) in unit and widget tests. **Zero files under `lib/features/**/presentation/` import `supabase_flutter` or `hive`.**

### 2.3 Why Monolithic Views Were Decomposed (<150 Lines per View)
- **Problem**: Twelve presentation files had grown between 242 and 667 lines (`settings_view_body.dart` at 667 lines, `home_view_body.dart` at 628 lines, `add_article.dart` at 611 lines, `article_view.dart` at 529 lines), mixing state initialization, business flag computation, conditional banners, dialogs, and nested `BoxDecoration` trees inside a single `build()` method.
- **Solution**: Applied the Single Responsibility Principle (SRP):
  - Extracted pure payload/filter logic into domain helpers (`ArticlePayloadBuilder` and `SearchFilterHelper`).
  - Extracted feed orchestration out of `StatefulWidget` (`HomeViewBody`) into `HomeFeedCubit`.
  - Extracted every cohesive visual section into standalone widget files under 220 lines.

### 2.4 Why `--dart-define-from-file=.env` Is Used Instead of Hardcoded Fallbacks
- **Problem**: When building the APK on `emulator-5554` without `--dart-define-from-file=.env`, `String.fromEnvironment('SUPABASE_URL')` and `String.fromEnvironment('SUPABASE_ANON_KEY')` evaluated to empty strings at compile time (`const`), causing `Supabase.initialize` to be skipped in `main.dart` and throwing `Supabase libraries not initialized` when pressing `Create Account`.
- **Why We Refused Hardcoded Fallbacks**: Embedding fallback URLs or API keys in Dart source files violates repository credential hygiene. Passing `--dart-define-from-file=.env` at compile time (`flutter build apk --debug --dart-define-from-file=.env` / `flutter run --dart-define-from-file=.env`) injects the credentials into the binary without committing secrets to source control.

### 2.5 Why `EditorialCardStack` Forwards Vertical Drag Deltas to the Parent `Scrollable`
- **Problem**: `EditorialCardStack` sits at the top of `HomeViewBody`'s `ListView` and registers an `onPanUpdate` gesture recognizer on the card stack. Without vertical scroll forwarding, vertical swipe gestures on the card stack were consumed by the card's pan recognizer rather than scrolling the page down to the `More Stories` list.
- **Solution**: Inside `EditorialCardStack._onPanUpdate`, when `_dragOffset.dx.abs() < 24` and `details.delta.dy.abs() > details.delta.dx.abs()` and an ancestor `Scrollable` with `maxScrollExtent > 0` exists, the vertical delta is forwarded directly via `scrollable.position.jumpTo(...)`. When rendered standalone without a scrollable parent (as in isolated widget tests), it preserves the standalone vertical drag and swipe-up-to-open gesture.

### 2.6 Why the Floating Retractable Slow-Scroll Bar Is Anchored at Bottom-Right in a `Stack`
- **Problem 1 — Scrolling Off-Screen**: When `ArticleSlowScrollBar` was placed inside `ListView.children`, starting slow scroll immediately scrolled the control bar off the top of the viewport, leaving the user unable to pause or stop scrolling once the header left the screen.
- **Problem 2 — Top Header Blank Space**: Placing the floating bar at `top: 10` required `68px` of top padding on the `ListView` to avoid overlapping the `←` Back button and Category badge; when the bar was retracted into a compact handle on the top-right, the left/center of that `68px` band appeared as wasted empty space above the Back button and Category badge.
- **Solution**: Wrapped the `ListView` (`padding: EdgeInsets.fromLTRB(20, 16, 20, 80)`) inside a `Stack` in `ArticleView` and anchored `ArticleSlowScrollBar` at `Positioned(bottom: 16, left: 20, right: 20, child: Align(alignment: Alignment.bottomRight, ...))`:
  - The `←` Back button and Category badge sit cleanly at `16px` from the top with zero wasted space.
  - The slow-scroll bar floats within easy thumb reach at the bottom-right throughout the entire article.
  - Tapping the far-right vertical bar handle (`Key('slow_scroll_retract_button')`) collapses the bar into a compact floating edge pill (`< |`, with an amber play indicator when active) and re-extends it on tap at any point in the article.

### 2.7 Why Author 5-Star Ratings and Article Likes Use Separate Tables, Triggers, and RPC Validation
- **Domain Separation**:
  - **5-Star Rating (`1..5`)** evaluates the **Author** (`public.author_ratings`, keyed by `(user_id, author_key)`), displayed directly beneath the author's name in `ArticleReaderAuthorBar`. Trigger `on_author_rating_changed` (`public.handle_author_rating_change()`, `SECURITY DEFINER SET search_path = ''`) automatically recalculates and updates `author_rating_avg` and `author_rating_count` on `public.articles` and `rating_avg` and `rating_count` on `public.profiles`.
  - **Likes** endorse the **Article** (`public.article_likes`, keyed by `(user_id, article_id)`), displayed in `ArticleReaderActionBar` inside `ArticleView` and on `EditorialCard` in the Home feed. Trigger `on_article_like_changed` (`public.handle_article_like_change()`, `SECURITY DEFINER SET search_path = ''`) maintains `public.articles.likes_count`.
- **Why Counter & Aggregate Protection Triggers Use `SECURITY INVOKER` + `pg_catalog.pg_trigger_depth() <= 1` (Without `current_user` Allowlists)**:
  - In PostgreSQL, if a trigger function is declared `SECURITY DEFINER`, `current_user` inside the function body switches to the function owner (`postgres`). Any guard condition that exempts `current_user IN ('postgres', ...)` inside a `SECURITY DEFINER` function would inadvertently exempt all callers!
  - Therefore, both `public.handle_profile_rating_protection()` (on `public.profiles`) and `public.handle_article_lifecycle()` (on `public.articles`) are configured as **`SECURITY INVOKER` (`is_security_definer = false`) with `SET search_path = ''`** and **do not check `current_user` at all (`uses_current_user = false`)**. They gate exclusively on `pg_catalog.pg_trigger_depth() <= 1`:
    - Direct client `INSERT` or `UPDATE` statements via PostgREST execute at `pg_trigger_depth() == 1` and are deterministically rejected if they supply non-zero counters or modify `rating_avg`, `rating_count`, `likes_count`, `saves_count`, `star_count`, `author_rating_avg`, or `author_rating_count`.
    - Trusted cascading updates from `on_author_rating_changed`, `on_article_like_changed`, `on_article_save_changed`, and `on_article_star_changed` execute at `pg_trigger_depth() == 2` (`> 1`) and succeed.

---

## 3. Clean Architecture & SRP File Inventory

### 3.1 Main View & New Feature File Line Counts
| File Path | Lines | Limit | Comments | Responsibility |
| :--- | :---: | :---: | :---: | :--- |
| `lib/features/home/presentation/views/article_view.dart` | **145** | < 150 | 0 | Reader scaffold, `ScrollController` timer, and bottom-right floating `ArticleSlowScrollBar` `Stack` |
| `lib/features/home/presentation/widgets/widgets/article_slow_scroll_bar.dart` | **200** | < 220 | 0 | Retractable slow-scroll control bar with `0.5x–2.0x` pace chips and far-right retract handle |
| `lib/features/home/presentation/widgets/widgets/article_reader_header.dart` | **214** | < 220 | 0 | Cover image, metadata header, author byline, and under-author 5-star interactive rating row |
| `lib/features/home/presentation/widgets/widgets/article_reader_action_bar.dart` | **138** | < 220 | 0 | Article like button + count, bookmark, offline download, and share actions |
| `lib/features/home/presentation/cubit/article_reader/article_reader_cubit.dart` | **211** | < 220 | 0 | Reader state management: slow scroll, retraction, author 5-star rating, article like, bookmark, download |
| `lib/features/home/presentation/cubit/article_reader/article_reader_state.dart` | **102** | < 220 | 0 | Immutable Equatable state for `ArticleReaderCubit` |
| `lib/features/home/presentation/widgets/home_view_body.dart` | **118** | < 150 | 0 | Home feed `ListView` with `EditorialCardStack` swipe handlers and `More Stories` vertical list |
| `lib/core/design/editorial_card_stack.dart` | **206** | < 220 | 0 | Swipe-right save, swipe-left next, `SAVE`/`NEXT` badges, and vertical scroll passthrough |
| `lib/features/add_article/presentation/views/add_article.dart` | **126** | < 150 | 0 | Declarative article editor view |
| `lib/features/add_article/presentation/views/drafts_view.dart` | **97** | < 150 | 0 | User drafts management view |
| `lib/features/add_article/presentation/views/article_preview_view.dart` | **60** | < 150 | 0 | Read-only Markdown preview view |
| `lib/features/search/presentation/views/search_view.dart` | **100** | < 150 | 0 | Debounced live search & category/tag filter view |
| `lib/features/profile/presentation/widget/user_articles.dart` | **138** | < 150 | 0 | Author articles list with `Write` button and 30-day immutability badges |

---

## 4. Supabase Backend Migrations & Live Security Verification (`tsqruoqiajkbrdhprfxa`)

### 4.1 Complete 14-Migration Inventory (`supabase/migrations/`)
All 14 migrations are synchronized 1-to-1 between `supabase/migrations/` in the repository and `supabase_migrations.schema_migrations` on live Supabase project `tsqruoqiajkbrdhprfxa`:
1. `20261015000000_baseline_schema.sql`
2. `20261015000001_seed_catalog.sql`
3. `20261015000002_atomic_favorite_categories.sql`
4. `20261015041325_harden_favorite_categories_rpc.sql`
5. `20261015042422_convert_rpc_to_security_invoker.sql`
6. `20261017004329_complete_supabase_backend_and_seed_content.sql`
7. `20261017011850_harden_search_paths_and_strict_constraints.sql`
8. `20261017012309_fix_sql_keywords_in_empty_search_path_functions.sql`
9. `20261017021143_create_article_and_save_counter_hardening.sql`
10. `20261017021318_fix_greatest_keyword_in_article_triggers.sql`
11. `20261017024001_author_star_ratings_and_article_likes_triggers.sql`
12. `20261017033059_harden_profile_ratings_likes_and_author_rpc.sql`
13. `20261017033315_fix_handle_article_lifecycle_counter_columns.sql`
14. `20261017035848_set_profile_rating_protection_security_invoker.sql`

### 4.2 Live `pg_proc` Function Security & Ownership Inventory (`tsqruoqiajkbrdhprfxa`)
| Function Name | Owner | `is_security_definer` | `uses_current_user` | `proconfig` (`search_path`) |
| :--- | :---: | :---: | :---: | :---: |
| `public.check_article_tags` | `postgres` | `false` (`INVOKER`) | `false` | `["search_path=\"\""]` |
| `public.handle_article_delete` | `postgres` | `false` (`INVOKER`) | `false` | `["search_path=\"\""]` |
| `public.handle_article_lifecycle` | `postgres` | `false` (`INVOKER`) | `false` | `["search_path=\"\""]` |
| `public.handle_profile_rating_protection` | `postgres` | `false` (`INVOKER`) | `false` | `["search_path=\"\""]` |
| `public.rate_author` | `postgres` | `false` (`INVOKER`) | `false` | `["search_path=\"\""]` |
| `public.get_author_rating_summary` | `postgres` | `false` (`INVOKER`) | `false` | `["search_path=\"\""]` |
| `public.set_user_favorite_categories` | `postgres` | `false` (`INVOKER`) | `false` | `["search_path=\"\""]` |
| `public.validate_and_normalize_author_rating` | `postgres` | `true` (`DEFINER`) | `false` | `["search_path=\"\""]` |
| `public.handle_author_rating_change` | `postgres` | `true` (`DEFINER`) | `false` | `["search_path=\"\""]` |
| `public.handle_article_like_change` | `postgres` | `true` (`DEFINER`) | `false` | `["search_path=\"\""]` |
| `public.handle_article_save_change` | `postgres` | `true` (`DEFINER`) | `false` | `["search_path=\"\""]` |
| `public.handle_article_star_change` | `postgres` | `true` (`DEFINER`) | `false` | `["search_path=\"\""]` |
| `public.ensure_user_profile_exists` | `postgres` | `true` (`DEFINER`) | `false` | `["search_path=\"\""]` |
| `public.handle_new_user` | `postgres` | `true` (`DEFINER`) | `false` | `["search_path=\"\""]` |
| `public.rls_auto_enable` | `postgres` | `true` (`DEFINER`) | `false` | `["search_path=\"\""]` |

### 4.3 Live Adversarial Security Verification Suite (`SET LOCAL ROLE authenticated`)
| # | Adversarial / Functional Test Case | Expected | Live Database Result (`tsqruoqiajkbrdhprfxa`) | Verdict |
| :--- | :--- | :--- | :--- | :---: |
| 1 | `handle_new_user` trigger under `search_path = ''` | Accepted | `Accepted (profile_count=1)` | **PASS** |
| 2 | Published article with valid title (1..12w), body (>=300w), category, and 1..5 fixed tags | Accepted | `Accepted` | **PASS** |
| 3 | Published article with 0 or 13 title words | Rejected | `Rejected: Published article title must be between 1 and 12 words` | **PASS** |
| 4 | Published article with < 300 body words | Rejected | `Rejected: Published article content must be at least 300 words` | **PASS** |
| 5 | Published article without `category_id` | Rejected | `Rejected: Published articles must specify a valid category_id` | **PASS** |
| 6 | Published article with `NULL`, `{}` (0), or 6 tags | Rejected | `Rejected: Published articles must have between 1 and 5 tags` | **PASS** |
| 7 | Published article with duplicate or unknown tags | Rejected | `Rejected: Article tags must be unique` / `must belong to the fixed_tags catalog` | **PASS** |
| 8 | Reversion from `published` to `draft` | Rejected | `Rejected: Published articles cannot be reverted to draft` | **PASS** |
| 9 | Edit or delete before 30-day cutoff (`29d 23h`) | Accepted | `Accepted` | **PASS** |
| 10 | Edit or delete at exact 30-day boundary (`30d`) or after (`31d`) | Rejected | `Rejected: Articles cannot be modified/deleted after 30 days of publication` | **PASS** |
| 11 | Client `INSERT` into `public.articles` with forged `star_count`, `likes_count`, `saves_count`, or `author_rating_avg/count` | Rejected | `Rejected: Direct modification of star_count / likes_count / saves_count / author rating aggregates is not allowed` | **PASS** |
| 12 | Client `UPDATE` on `public.articles` modifying `star_count`, `likes_count`, `saves_count`, or `author_rating_avg/count` | Rejected | `Rejected: Direct modification of ... is not allowed` | **PASS** |
| 13 | Client `UPDATE` on own `public.profiles` modifying `rating_avg` or `rating_count` | Rejected | `Rejected: Direct modification of profile rating aggregates is not allowed` | **PASS** |
| 14 | `has_function_privilege('anon', 'public.rate_author(...)', 'EXECUTE')` | `false` | `false` (`anon` and `PUBLIC` cannot execute `rate_author`) | **PASS** |
| 15 | `rate_author` called with spoofed `p_author_name`, mismatched `p_author_id`, or unknown `p_author_key` | Rejected | `Rejected: Inconsistent author_key and author_name/id supplied` / `Cannot rate unknown author` | **PASS** |
| 16 | Legitimate `rate_author`, `article_likes`, `saved_articles`, and `article_stars` operations | Accepted | All counters and rating averages updated accurately via trusted triggers | **PASS** |

---

## 5. Complete Test Suite Progression & Reconciliation (`194 -> 206 -> 223 -> 225`)

Zero tests were deleted or lost during the session. Every increase in the test count corresponds to newly added or expanded test files:

| Milestone | Test Files Added / Expanded | Net Delta | Cumulative Total |
| :--- | :--- | :---: | :---: |
| **1. Clean Architecture Refactor Baseline** | 21 test files (`article_reader_cubit_test.dart`: 9 tests; `article_view_widget_test.dart`: 4 tests; `editorial_stack_test.dart`: 3 tests) | — | **194** |
| **2. Home Feed Swipe & Article Creation** | • `test/editorial_stack_test.dart`: `3 -> 4` (**+1**)<br>• `test/features/reader/home_feed_cubit_test.dart`: new file (**+9**)<br>• `test/features/add_article/domain/helpers/article_payload_builder_test.dart`: new file (**+1**)<br>• `test/features/add_article/presentation/views/add_article_view_test.dart`: `2 -> 3` (**+1**) | **+12** | **206** |
| **3. Slow Scroll, Author 5-Star Ratings & Article Likes** | • `test/features/reader/author_rating_and_like_data_test.dart`: new file (**+13**)<br>• `test/features/reader/article_reader_cubit_test.dart`: `9 -> 11` (**+2**)<br>• `test/features/reader/article_view_widget_test.dart`: `4 -> 6` (**+2**) | **+17** | **223** |
| **4. Floating Retractable Slow-Scroll Bar** | • `test/features/reader/article_reader_cubit_test.dart`: `11 -> 12` (**+1**)<br>• `test/features/reader/article_view_widget_test.dart`: `6 -> 7` (**+1**) | **+2** | **225** |

---

## 6. Final Verification Gates & Remaining Manual Actions

| Gate | Command Executed | Empirical Output | Status |
| :--- | :--- | :--- | :---: |
| **Working Tree Token Scan** | `git grep -i "sbp_"` | `0 matches` | **PASS** |
| **Git History Token Scan** | `git log --all -S "sbp_" --oneline` | `0 matches` | **PASS** |
| **Temporary Screenshots Removed** | `Test-Path .../article_screen.png` | `False` | **PASS** |
| **Static Analysis** | `flutter analyze` | `No issues found!` | **PASS** |
| **Automated Tests** | `flutter test` | `00:12 +225: All tests passed!` (225/225 tests passed) | **PASS** |
| **Android Emulator Build & Install** | `flutter build apk --debug --dart-define-from-file=.env && flutter install -d emulator-5554` | `✓ Built app-debug.apk` & installed on `sdk gphone16k x86 64` | **PASS** |
| **Knowledge Graph** | `graphify update .` | Code graph updated (`0 topology warnings`) | **PASS** |

### Manual Account/Dashboard Actions for Project Owner
1. **Revoke Previously Exposed PAT in Supabase Account Dashboard**:
   - Rotate the personal access token pasted in an earlier turn at **[https://supabase.com/dashboard/account/tokens](https://supabase.com/dashboard/account/tokens)**.
2. **Supabase Auth Leaked Password Protection (`auth_leaked_password_protection`)**:
   - Enable HaveIBeenPwned password checking under **Supabase Dashboard -> Authentication -> Providers -> Email -> Password Security** (available on Supabase Pro and above).
