# MindFeed — End-to-End Supabase Backend, Feature Implementation, Clean Architecture Refactoring & Security Audit Report

Date: 2026-10-17
Database: Supabase (Project ID: `tsqruoqiajkbrdhprfxa`, Name: `MindFeed`, Region: `eu-west-1`)
Repository Path: `C:/Users/Hp/OneDrive/Documents/Projects/MindFeed/MindFeed-main`
Git Branch: `feature/supabase-implementation` (Uncommitted working tree changes on top of merged `origin/main` `8398e2c`)

---

## 1. Executive Summary

This report documents everything accomplished during this engineering session, the architectural and mechanical rationale behind every decision ("why certain things were done"), the complete file-by-file and migration-by-migration diff inventory, and the empirical verification evidence across both the Flutter application and the live hosted Supabase PostgreSQL database.

### Summary of Outcomes
1. **Branch Synchronization with `origin/main`**: Merged the 9 upstream commits from `origin/main` into `feature/supabase-implementation`, resolving conflicts in core DI, routing, auth, onboarding categories, and profile layers without losing upstream Clean Architecture use cases or local editorial UI styling.
2. **End-to-End Feature & Backend Wiring (4 Parallel Subagents A–D)**:
   - Implemented full Markdown article authoring, field-level validation (1–12 title words, >=300 body words, landscape cover image dimension validation via `ImageStream`, 1 category, 1–5 fixed tags), draft saving, live preview, and publishing.
   - Implemented the live Markdown article reader (`ArticleView`), optimistic star endorsement (`ToggleStarUseCase`) and bookmarking (`ToggleBookmarkUseCase`) with rollback on failure, and text-only offline article downloads (`DownloadArticleTextUseCase` / `DownloadsCubit`).
   - Implemented debounced (350ms) live keyword search (`SearchArticlesUseCase`), live category filtering (`GetArticlesByCategoryUseCase`), and tag filtering (`SearchCubit`), and purged all mock fallbacks (`EditorialMockData`) in compliance with Business Rule BR-12.
   - Implemented profile article management (`ProfileArticlesCubit`) enforcing the 30-day edit/delete immutability window (`isEditableWithinWindow`) and updated navigation (`CustomDrawer`, `SettingsViewBody`).
3. **Clean Architecture & Single Responsibility Principle (SRP) Refactoring (4 Parallel Subagents R1–R4)**:
   - Decoupled **100% of presentation-layer views and cubits** from `supabase_flutter` and `hive` by introducing `CurrentUserSession` (`lib/core/services/current_user_session.dart`).
   - Decomposed **12 monolithic presentation files** (previously up to 667 lines) into focused, single-responsibility widgets, bringing all main view files to **60–159 lines** and all extracted widget files under **200 lines**.
4. **Live Supabase Backend Completion & Security Hardening (`20261017004329`, `20261017011850`, `20261017012309`)**:
   - Populated all 14 live published articles in `public.articles` with 393–409 word structured Markdown bodies and landscape cover image URLs (`1200x675`).
   - Added missing composite and GIN indexes (`articles_status_published_at_idx`, `articles_tags_gin_idx`) and hardened RLS policies (`profiles_update_own`, `articles_update_author`, `articles_delete_author`).
   - Revoked `CREATE ON SCHEMA public` from `PUBLIC, anon, authenticated` and configured `SET search_path = ''` on all 7 functions in `public` with schema-qualified references.
   - Executed a **22-case live adversarial database test suite** under `SET LOCAL ROLE authenticated` proving server-side enforcement of every publishing, tagging, immutability, deletion, and `star_count` rule (**22/22 passed**).
5. **Verification & Build Readiness**:
   - `flutter analyze`: **0 issues found**.
   - `flutter test`: **194/194 tests passed**.
   - `flutter build apk --debug`: **Built `build\app\outputs\flutter-apk\app-debug.apk`**.
   - Repository token hygiene scan: **0 matches** for `sbp_` in the working tree, untracked source files, git commit history, or shell environment variables.

---

## 2. Why Certain Decisions Were Made (Architectural & Mechanical Rationale)

### 2.1 Why `origin/main` Was Merged Before Feature Orchestration
- **Problem**: `feature/supabase-implementation` was 9 commits behind `origin/main`, where Phase 2–4 domain entities, repository interfaces, use cases (`SaveDraftUseCase`, `PublishArticleUseCase`, `UpdateArticleUseCase`, `DeleteArticleUseCase`, `ToggleStarUseCase`, `DownloadArticleTextUseCase`, etc.), and initial auth/category wiring had been landed.
- **Why We Resolved Conflicts the Way We Did**:
  - For **architecture, DI (`setup_service_locator.dart`), routing (`app_routes.dart`), and tests**, we took `origin/main`'s Clean Architecture use-case registrations so all downstream features could consume real Supabase repositories via `getIt`.
  - For **visual presentation (`categories_view.dart`, `profile_view.dart`, `personal_infromation.dart`)**, we combined `origin/main`'s live cubit state management with `feature/supabase-implementation`'s responsive constraints (`ConstrainedBox(maxWidth: 500)`) and editorial typography.

### 2.2 Why the Shared Foundation Was Laid By the Orchestrator First
- **Problem**: Spawning 4 subagents concurrently on a single working tree risks write collisions if multiple agents need to extend shared models (`EditorialNewsItem`, `ArticleEntity`, `DownloadedArticleEntity`) or route constants (`AppRoutes`).
- **Decision**: Before launching Subagents A–D, the orchestrator updated `lib/core/design/editorial_models.dart`, `lib/features/home/domain/entities/article_entity.dart`, `lib/features/home/domain/entities/downloaded_article_entity.dart`, and `lib/config/routes/app_routes.dart` in a single atomic pass, establishing `isEditableWithinWindow`, `content`, `coverImageUrl`, `authorId`, `publishedAt`, `readingTimeMinutes`, `status`, `starCount`, and `isStarred`. Each subagent was then given strict, non-overlapping file ownership boundaries.

### 2.3 Why `CurrentUserSession` Was Created (`lib/core/services/current_user_session.dart`)
- **Problem**: Presentation-layer views and cubits (`AddArticleCubit`, `DraftsCubit`, `HomeViewBody`, `ArticleReaderCubit`, `CollectionsCubit`, `ProfileArticlesCubit`, `PersonalInformation`, `SettingsViewBody`) were importing `package:supabase_flutter/supabase_flutter.dart` and `package:hive/hive.dart` directly to read `Supabase.instance.client.auth.currentUser` or `Hive.box<UserEntity>(kUserBox)`.
- **Why This Violated Clean Architecture**:
  1. Presentation code depended directly on infrastructure SDKs (`supabase_flutter`, `hive`).
  2. Widget and cubit tests crashed whenever `Supabase.instance` or Hive boxes were not initialized, forcing brittle `try/catch` blocks inside UI files.
- **Solution**: Extracted `CurrentUserSession` and `CurrentUserSnapshot` in `lib/core/services/current_user_session.dart`. It encapsulates session resolution, display-name fallback chains (Hive cached `UserEntity` -> Supabase user metadata -> email prefix -> `'Anonymous'`), and category cache persistence, while allowing deterministic injection (`userResolver` / `userIdResolver`) in unit and widget tests. **Zero files under `lib/features/**/presentation/` now import `supabase_flutter` or `hive`.**

### 2.4 Why Monolithic Views Were Decomposed (<150 Lines per View)
- **Problem**: Twelve presentation files had grown between 242 and 667 lines (`settings_view_body.dart` at 667 lines, `home_view_body.dart` at 628 lines, `add_article.dart` at 611 lines, `article_view.dart` at 529 lines), mixing state initialization, business flag computation, complex conditional banners, dialogs, and deeply nested inline `BoxDecoration` trees inside a single `build()` method.
- **Solution**: Applied the Single Responsibility Principle (SRP):
  - Extracted pure payload/filter logic into domain helpers (`ArticlePayloadBuilder` in `lib/features/add_article/domain/helpers/article_payload_builder.dart` and `SearchFilterHelper` in `lib/features/search/domain/helpers/search_filter_helper.dart`).
  - Extracted feed orchestration out of `StatefulWidget` (`HomeViewBody`) into a dedicated `HomeFeedCubit` (`lib/features/home/presentation/cubit/home_feed/home_feed_cubit.dart`).
  - Extracted every cohesive visual section (warning banners, title/content/cover/category/tag form fields, action bars, masthead headers, lead/secondary story cards, status views, OTP boxes, settings sections, and dialogs) into standalone widget files under 200 lines.
  - Replaced inline boolean expressions with named getters on state classes (e.g., `AddArticleState.hasLockoutError`, `AddArticleState.isReadOnly`, `AddArticleState.titleWordCount`, `AddArticleState.contentWordCount`).

### 2.5 Why All Mock Fallbacks (`EditorialMockData`) Were Deleted
- **Problem**: Previously, when offline or when a repository call failed, `HomeViewBody`, `CollectionsCubit`, `ArticleView`, and `UserArticles` silently fell back to hardcoded mock stories from `EditorialMockData`.
- **Why It Was Removed**: Business Rule **BR-12** mandates that the application never display fake/mock stories in production; network or backend failures must surface an honest offline/error state with retry capability, while offline reading is served exclusively from the user's explicit local downloads (`DownloadedArticleEntity` in Hive). Consequently, `lib/core/design/editorial_mock_data.dart` and obsolete placeholder views (`favorite_movies_view.dart`, `home_of_add_article_view.dart`) were deleted completely.

### 2.6 Why the Supabase Database Functions & Triggers Were Hardened (`SET search_path = ''`)
- **Problem 1 — Schema Privilege & Search Path Hijacking Risk**:
  - Initially, functions were configured with `SET search_path = public, pg_temp`. If any untrusted role holds `CREATE` privilege on `public`, a `SECURITY DEFINER` function (`handle_article_star_change`, `handle_new_user`, `rls_auto_enable`) could be tricked into executing a malicious function or operator placed in `public`.
  - **Why We Used `SET search_path = ''` AND Revoked `CREATE ON SCHEMA public`**:
    - Following Supabase and PostgreSQL security guidance, we executed `REVOKE CREATE ON SCHEMA public FROM PUBLIC, anon, authenticated;` (defense in depth so no API role can create objects in `public`) AND set `SET search_path = ''` on all 7 functions in `public`, explicitly qualifying every table (`public.articles`, `public.fixed_tags`, `public.profiles`, `public.categories`, `public.user_favorite_categories`) and catalog function (`pg_catalog.*`).
- **Problem 2 — Why `coalesce`, `nullif`, and `greatest` Must Not Be Prefixed with `pg_catalog.`**:
  - During live adversarial testing of `SET search_path = ''`, calling `pg_catalog.coalesce(...)` threw `ERROR: 42883: function pg_catalog.coalesce(integer, integer) does not exist`.
  - **Mechanical Reason**: In PostgreSQL's SQL parser (`gram.y`), `COALESCE`, `NULLIF`, `GREATEST`, and `LEAST` are **built-in grammar constructs** (`CoalesceExpr`, `NullIfExpr`, `MinMaxExpr`), not entries in `pg_proc`. Prefixing them with `pg_catalog.` forces PostgreSQL to bypass the grammar keyword and search `pg_proc` for a regular function that does not exist. Writing them as unqualified SQL keywords (`coalesce(...)`, `nullif(...)`, `greatest(...)`) resolves at parse time regardless of `search_path = ''`.
- **Problem 3 — Why Client-Side Validation Alone Is Insufficient**:
  - Any authenticated user can call the Supabase REST/PostgREST API directly using the public `anon` key and their user JWT, bypassing the Flutter UI.
  - Therefore, `public.handle_article_lifecycle()`, `public.check_article_tags()`, and `public.handle_article_delete()` were hardened to enforce all constraints at the database trigger layer:
    - **Title word count (1..12 words)** and **Content word count (>=300 words)** on published articles using `pg_catalog.regexp_split_to_array(nullif(pg_catalog.btrim(coalesce(...)), ''), '\s+')`.
    - **Non-null `category_id`** on published articles.
    - **Explicit `NULL` and `{}` empty tag array rejection**: Because `pg_catalog.array_length('{}'::text[], 1)` returns `NULL` in PostgreSQL, `check_article_tags()` explicitly rejects `NEW.tags IS NULL` when `NEW.status = 'published'` and wraps `array_length` in `coalesce(pg_catalog.array_length(NEW.tags, 1), 0)` so empty arrays (`0`) and `> 5` tags are deterministically rejected.
    - **30-Day Cutoff Precision**: Used `OLD.published_at <= (pg_catalog.now() - interval '30 days')` on both `UPDATE` and `DELETE` triggers so articles at or past the exact 30-day mark are immutable and non-deletable.
    - **`star_count` Integrity via `pg_trigger_depth()`**: Direct client `INSERT` (with non-zero `star_count`) or `UPDATE` of `star_count` executes at `pg_catalog.pg_trigger_depth() = 1` and is rejected (`Direct modification of star_count is not allowed`). Legitimate `INSERT`/`DELETE` on `public.article_stars` fires `public.handle_article_star_change()` (`SECURITY DEFINER`), which updates `public.articles.star_count` at `pg_catalog.pg_trigger_depth() = 2` and succeeds.

---

## 3. Clean Architecture & SRP Refactoring Inventory

### 3.1 Monolithic View Line-Count Reduction Summary
| File Path | Lines Before | Lines After | Reduction | Extracted Single-Responsibility Components |
| :--- | :---: | :---: | :---: | :--- |
| `lib/features/settings/presentation/widgets/settings_view_body.dart` | 667 | **159** | -76.2% | `settings_account_card.dart`, `settings_reading_section.dart`, `settings_archive_section.dart`, `settings_dialogs.dart`, `settings_tile_primitives.dart` |
| `lib/features/home/presentation/widgets/home_view_body.dart` | 628 | **110** | -82.5% | `home_feed_cubit.dart`, `home_feed_state.dart`, `home_masthead_header.dart`, `home_lead_story_section.dart`, `home_feed_status_views.dart` |
| `lib/features/add_article/presentation/views/add_article.dart` | 611 | **126** | -79.4% | `article_edit_warning_banner.dart`, `article_title_field.dart`, `article_cover_image_field.dart`, `article_category_selector.dart`, `article_tag_selector.dart`, `article_content_field.dart`, `article_editor_action_bar.dart` |
| `lib/features/home/presentation/views/article_view.dart` | 529 | **136** | -74.3% | `article_reader_top_bar.dart`, `article_reader_header.dart`, `article_reader_markdown_body.dart`, `article_reader_action_bar.dart` |
| `lib/features/settings/presentation/widgets/settings_menu.dart` | 463 | **115** | -75.2% | Reuses `settings_tile_primitives.dart` |
| `lib/features/add_article/presentation/views/drafts_view.dart` | 378 | **97** | -74.3% | `draft_item_card.dart`, `drafts_status_views.dart` |
| `lib/features/auth/presentation/widgets/check_code_view_body.dart` | 351 | **83** | -76.4% | `check_code_otp_boxes.dart`, `check_code_actions_section.dart` |
| `lib/features/collections/presentation/widgets/downloaded_articles_view_body.dart` | 327 | **81** | -75.2% | `downloaded_article_card_tile.dart`, `downloaded_articles_empty_state.dart` |
| `lib/features/search/presentation/views/search_view.dart` | 281 | **100** | -64.4% | `search_filter_chips_bar.dart`, `search_results_view.dart`, `search_filter_helper.dart` |
| `lib/features/profile/presentation/widget/user_articles.dart` | 254 | **155** | -39.0% | `profile_articles_status_views.dart` |
| `lib/features/profile/presentation/widget/personal_infromation.dart` | 252 | **120** | -52.4% | `profile_avatar_and_stats.dart` |
| `lib/features/add_article/presentation/views/article_preview_view.dart` | 242 | **60** | -75.2% | `article_preview_header.dart` |

### 3.2 Deleted Obsolete / Mock Files
- `lib/core/design/editorial_mock_data.dart` (purged all hardcoded mock stories)
- `lib/features/add_article/presentation/views/home_of_add_article_view.dart` (legacy local file-picker markdown screen)
- `lib/features/add_article/presentation/widget/format_markdown.dart` (legacy unused toolbar)
- `lib/features/add_article/presentation/widget/markdown_text_input.dart` (legacy unused input widget)
- `lib/features/collections/presentation/views/favorite_movies_view.dart` (obsolete movie template screen)
- `lib/features/collections/presentation/widgets/favorite_movies_view_body.dart` (obsolete movie template widget)
- `lib/features/home/presentation/widgets/subtitle_listTile_of_article_card.dart` (unused legacy widget)

---

## 4. Supabase Backend Migrations & Database Verification

### 4.1 Migration Inventory (`supabase/migrations/`)
All 8 migrations are synchronized 1-to-1 between `supabase/migrations/` locally and `supabase_migrations.schema_migrations` on the remote hosted database (`tsqruoqiajkbrdhprfxa`):
1. `20261015000000_baseline_schema.sql`
2. `20261015000001_seed_catalog.sql`
3. `20261015000002_atomic_favorite_categories.sql`
4. `20261015041325_harden_favorite_categories_rpc.sql`
5. `20261015042422_convert_rpc_to_security_invoker.sql`
6. `20261017004329_complete_supabase_backend_and_seed_content.sql`
7. `20261017011850_harden_search_paths_and_strict_constraints.sql`
8. `20261017012309_fix_sql_keywords_in_empty_search_path_functions.sql`

### 4.2 Schema Privilege & `search_path` Audit Evidence (Check A)
Live catalog query executed on `tsqruoqiajkbrdhprfxa`:
```sql
SELECT
    has_schema_privilege('anon', 'public', 'CREATE') AS anon_can_create,
    has_schema_privilege('authenticated', 'public', 'CREATE') AS authenticated_can_create,
    has_schema_privilege('service_role', 'public', 'CREATE') AS service_role_can_create,
    has_schema_privilege('public', 'public', 'CREATE') AS public_role_can_create;
```
Result:
- `anon_can_create`: `false`
- `authenticated_can_create`: `false`
- `service_role_can_create`: `false`
- `public_role_can_create`: `false`

Live `pg_proc` configuration check for all functions in `public`:
| Function Name | `SECURITY DEFINER` | `proconfig` (`search_path`) |
| :--- | :---: | :---: |
| `public.check_article_tags` | `false` | `["search_path=\"\""]` |
| `public.handle_article_delete` | `false` | `["search_path=\"\""]` |
| `public.handle_article_lifecycle` | `false` | `["search_path=\"\""]` |
| `public.handle_article_star_change` | `true` | `["search_path=\"\""]` |
| `public.handle_new_user` | `true` | `["search_path=\"\""]` |
| `public.rls_auto_enable` | `true` | `["search_path=\"\""]` |
| `public.set_user_favorite_categories` | `false` | `["search_path=\"\""]` |

### 4.3 Live Adversarial Database Test Suite Evidence (Check B)
Executed inside a transactional rollback block on the live Supabase database under `SET LOCAL ROLE authenticated` (`request.jwt.claim.sub = '00000000-0000-4000-8000-000000000099'`):

| # | Test Case ID | Scenario Tested | Expected | Live Database Result | Verdict |
| :--- | :--- | :--- | :--- | :--- | :---: |
| 0 | `00_handle_new_user_trigger_empty_search_path` | `INSERT INTO auth.users` fires `handle_new_user()` under `search_path = ''` | Accepted (`profile_count=1`) | `Accepted (profile_count=1)` | **PASS** |
| 1 | `01_valid_published_article` | Valid published article (6w title, 305w body, category, 2 valid tags) | Accepted | `Accepted` | **PASS** |
| 2 | `02a_published_title_0_words` | Published article with whitespace-only title (0 words) | Rejected | `Rejected: Published article title must be between 1 and 12 words` | **PASS** |
| 3 | `02b_published_title_13_words` | Published article with 13 title words | Rejected | `Rejected: Published article title must be between 1 and 12 words` | **PASS** |
| 4 | `03_published_body_under_300_words` | Published article with 120 body words (< 300 words) | Rejected | `Rejected: Published article content must be at least 300 words` | **PASS** |
| 5 | `04_published_without_category` | Published article with `category_id = NULL` | Rejected | `Rejected: Published articles must specify a valid category_id` | **PASS** |
| 6 | `05a_published_null_tags_array` | Published article with `tags = NULL` | Rejected | `Rejected: Published articles must have between 1 and 5 tags` | **PASS** |
| 7 | `05b_published_empty_tags_array` | Published article with `tags = '{}'::text[]` (0 tags) | Rejected | `Rejected: Published articles must have between 1 and 5 tags` | **PASS** |
| 8 | `05c_published_6_tags_over_limit` | Published article with 6 valid tags (> 5 tags) | Rejected | `Rejected: Published articles must have between 1 and 5 tags` | **PASS** |
| 9 | `06a_published_duplicate_tags` | Published article with duplicate tags (`['Deep Work', 'Deep Work']`) | Rejected | `Rejected: Article tags must be unique` | **PASS** |
| 10 | `06b_published_unknown_tag` | Published article with unknown tag (`['Deep Work', 'NonExistentBogusTag']`) | Rejected | `Rejected: All article tags must belong to the fixed_tags catalog` | **PASS** |
| 11 | `07_reversion_published_to_draft` | `UPDATE public.articles SET status = 'draft'` on published article | Rejected | `Rejected: Published articles cannot be reverted to draft` | **PASS** |
| 12 | `08a_edit_before_30d_cutoff_29d23h` | `UPDATE` published article at `now() - interval '29 days 23 hours'` | Accepted | `Accepted` | **PASS** |
| 13 | `08b_edit_at_exact_30d_boundary` | `UPDATE` published article at exact `now() - interval '30 days'` boundary | Rejected | `Rejected: Articles cannot be modified after 30 days of publication` | **PASS** |
| 14 | `08c_edit_after_30d_cutoff_31d` | `UPDATE` published article at `now() - interval '31 days'` | Rejected | `Rejected: Articles cannot be modified after 30 days of publication` | **PASS** |
| 15 | `08d_delete_before_30d_cutoff_29d23h` | `DELETE` published article at `now() - interval '29 days 23 hours'` | Accepted | `Accepted` | **PASS** |
| 16 | `08e_delete_at_exact_30d_boundary` | `DELETE` published article at exact `now() - interval '30 days'` boundary | Rejected | `Rejected: Articles cannot be deleted after 30 days of publication` | **PASS** |
| 17 | `08f_delete_after_30d_cutoff_31d` | `DELETE` published article at `now() - interval '31 days'` | Rejected | `Rejected: Articles cannot be deleted after 30 days of publication` | **PASS** |
| 18 | `09a_direct_insert_forged_star_count` | Direct client `INSERT` into `public.articles` with `star_count = 50` | Rejected | `Rejected: Direct modification of star_count is not allowed` | **PASS** |
| 19 | `09b_direct_update_star_count_by_client` | Direct client `UPDATE public.articles SET star_count = 999` | Rejected | `Rejected: Direct modification of star_count is not allowed` | **PASS** |
| 20 | `10a_legitimate_star_insert_increments_counter` | `INSERT INTO public.article_stars` by `authenticated` user | `star_count = 1` | `star_count = 1` | **PASS** |
| 21 | `10b_legitimate_star_delete_decrements_counter` | `DELETE FROM public.article_stars` by `authenticated` user | `star_count = 0` | `star_count = 0` | **PASS** |

---

## 5. Security, Static Analysis, Test Suite & Build Verification (Check C)

| Gate | Command Executed | Empirical Output | Status |
| :--- | :--- | :--- | :---: |
| **Working Tree Token Scan** | `git grep -i "sbp_"` | `0 matches` | **PASS** |
| **Git History Token Scan** | `git log --all -S "sbp_" --oneline` | `0 matches` | **PASS** |
| **All Files Token Scan** | `Get-ChildItem -Recurse -File \| Select-String -Pattern "sbp_"` | `0 matches` in source/config/docs/migrations | **PASS** |
| **Env Token Check** | `npx supabase db diff --linked` | `AccessTokenRequiredError` (confirms `SUPABASE_ACCESS_TOKEN` is not set in shell env) | **PASS** |
| **Static Analysis** | `flutter analyze` | `No issues found! (ran in 4.0s)` | **PASS** |
| **Automated Tests** | `flutter test` | `00:11 +194: All tests passed!` (194/194 tests passed) | **PASS** |
| **Android APK Build** | `flutter build apk --debug` | `✓ Built build\app\outputs\flutter-apk\app-debug.apk` (89.0s) | **PASS** |
| **Knowledge Graph** | `graphify update .` | Updated (`3221 nodes, 5043 edges, 178 communities`) | **PASS** |

---

## 6. Remaining Manual Release Actions for Project Owner

1. **Revoke Previously Exposed PAT in Supabase Dashboard**:
   - Although no `sbp_...` token exists anywhere in the repository, git history, or environment variables, a token was pasted in an earlier conversation turn. Revoke and rotate it in **[https://supabase.com/dashboard/account/tokens](https://supabase.com/dashboard/account/tokens)**.
2. **Supabase Auth Leaked Password Protection (`auth_leaked_password_protection`)**:
   - Enable HaveIBeenPwned password checking under **Supabase Dashboard -> Authentication -> Providers -> Email -> Password Security** (requires Supabase Pro plan if currently on the Free tier).
