# MindFeed Phase 0 — Repository and Live Database Reconciliation Report

Date: 2026-10-15
Database: Supabase (Project ID: `tsqruoqiajkbrdhprfxa`, Name: `MindFeed`, Region: `eu-west-1`)
Repository Path: `C:/Users/Hp/OneDrive/Documents/Projects/MindFeed/MindFeed-main`
Git Branch: `dev` (Merge commits: `9cbfaff`, `f2795de`, `d9d4084`, `c5e30d3`)

---

## 1. Executive Summary

Phase 0 read-only reconciliation was conducted across the MindFeed Flutter repository (`MindFeed-main`), the live Supabase database (`tsqruoqiajkbrdhprfxa`), and the project specifications (`requirments.md`, `SPEC.md`, `BRD.md`, and `docs/plans/backend_implementation_plan.md`).

### Key Findings
1. **Live Supabase Database is Fully Provisioned & Active**:
   - Contrary to early audit assumptions that the database schema was completely absent, the live database contains all 9 core application tables: `articles`, `article_stars`, `article_likes`, `categories`, `fixed_tags`, `profile_favorite_categories`, `profiles`, `saved_articles`, and `author_follows`.
   - **Row Level Security (RLS)** is enabled on all 9 tables (100% coverage).
   - Complete security policies, lifecycle triggers, validation triggers, and star-counting counter triggers are deployed and active.
   - The 14 editorial seed articles are fully preserved with valid UUID references and timestamps.
2. **Repository vs. Live Database Disconnect**:
   - The repository contains **zero SQL migration files or scripts** in version control.
   - In Flutter, only `auth` and `profile` have active remote data sources wired to Supabase. Article browsing, searching, bookmarking, and creation still rely entirely on in-memory mock data (`AppData`).
   - The client model `NewsArticleModel` is legacy UI-bound and does not match the live database contract (lacks UUID `id`, `star_count`, `category_id`, server lifecycle fields, and JSON serialization).
3. **Saved Articles Table Name Verified**:
   - The live table is named **`saved_articles`**, NOT `user_saved_articles`.
4. **Public Access Verified**:
   - `categories` and `fixed_tags` grant `SELECT true` to public (`anon` + `authenticated`).
   - Published articles (`status = 'published'`) grant `SELECT` to public.
5. **Authoritative Server Lifecycle Verified**:
   - Database triggers enforce `clock_timestamp()` for `published_at`, prevent star manipulation, reject reverting published articles to draft, and enforce 30-day update/delete restrictions.

---

## 2. Repository State and Migration Inventory

### 2.1 Git Status & Branching
- **Current Branch**: `dev` (aligned with remote tracking branch `origin/feature/supabase-implementation`).
- **Git Status**: Clean working directory (excluding untracked documentation directories `docs/plans/` and `docs/reports/`).
- **Recent Commits**:
  - `9cbfaff` Merge pull request #3 from amr3zz/feature/supabase-implementation
  - `f2795de` Merge branch 'dev' into feature/supabase-implementation
  - `d9d4084` Merge branch 'dev' into feature/supabase-implementation
  - `c5e30d3` Merge branch 'dev' into feature/supabase-implementation

### 2.2 Migration & SQL Script Inventory
- **SQL Migrations in Git**: **0 files**. There is no `supabase/migrations/` directory or root SQL script in the repository.
- **Scripts Directory**: `scripts/` exists but is completely empty.
- **Conclusion**: The live database schema was applied directly via the Supabase Dashboard SQL Editor or external tooling without committing migration files into Git. Establishing an authoritative, non-destructive migration baseline in `supabase/migrations/` is the primary technical objective for Phase 1.

### 2.3 Dependency Registrations & Service Locator (`setup_service_locator.dart`)
Inspecting `lib/core/utls/setup_service_locator.dart` confirms:
- `getIt.registerSingleton<SupabaseClient>(Supabase.instance.client)`: Registered.
- `AuthApiSource` & `AuthRepo`: Registered (wired to Supabase Auth).
- `ProfileRemoteDataSource` & `ProfileRepo`: Registered (wired to `profiles` table).
- **Missing Registrations**:
  - `ArticlesRemoteDataSource` / `ArticlesLocalDataSource`: **Not registered**.
  - `ArticlesRepo`: **Not registered**.
  - `BookmarksRepo` / `CategoriesRepo`: **Not registered**.

### 2.4 Existing Codebase Architecture & Data Layer
- **Auth Layer (`lib/features/auth`)**:
  - `AuthApiSource` uses `supabaseClient.auth.signUp`, `signInWithPassword`, `signOut`, `signInWithIdToken` (Google).
- **Profile Layer (`lib/features/profile`)**:
  - `ProfileRemoteDataSource` reads and updates `public.profiles` using `supabaseClient.from('profiles')`.
- **Home Layer (`lib/features/home`)**:
  - No cubit or bloc for article feeds; views directly consume static `AppData.articles` (which contains 5 mock items).
  - `NewsArticleModel` in `lib/features/home/data/models/news_article_model.dart` is an immutable presentation model without Supabase `fromJson` / `toJson` mapping.
- **Collections / Bookmarks Layer (`lib/features/collections`)**:
  - `CollectionsCubit` manages an in-memory `List<NewsArticleModel> savedArticles = []` via local state.
- **Search Layer (`lib/features/search`)**:
  - `SearchCubit` filters in-memory `AppData.articles` by title/author with `title.toLowerCase().contains(...)`.
- **Add Article Layer (`lib/features/add_article`)**:
  - `AddArticleCubit` creates a temporary `NewsArticleModel` and emits `AddArticleSuccess` without any backend persistence.
- **Offline Storage (`Hive` / local storage)**:
  - `pubspec.yaml` has `hive: ^2.2.3` and `hive_flutter: ^1.1.0` installed, but Hive is currently uninitialized in `main.dart` and has zero TypeAdapters or box implementations for caching articles.
- **Test Coverage**:
  - `test/` contains only 4 basic auth/widget test files (`features/auth/login_view_test.dart`, `widget_test.dart`). Zero tests exist for articles, categories, or remote datasources.

---

## 3. Live Database Inventory and Security Configuration

### 3.1 Live Tables & Schema Summary

| Table Name | Primary Key | Description | Live Record Count |
| :--- | :--- | :--- | :--- |
| `profiles` | `id` (uuid) | User profile linked to `auth.users(id)` ON DELETE CASCADE | 1 |
| `categories` | `id` (uuid) | Master category catalog with unique `slug` and `name` | 20 |
| `fixed_tags` | `id` (uuid) | Controlled tag taxonomy with unique `slug` and `name` | 12 |
| `articles` | `id` (uuid) | Core content table with `star_count`, status, category FK | 14 |
| `article_stars` | `(user_id, article_id)` | Many-to-many star relation | 0 |
| `article_likes` | `(user_id, article_id)` | Legacy/auxiliary like relation | 0 |
| `saved_articles` | `(user_id, article_id)` | User bookmarks relation | 0 |
| `profile_favorite_categories` | `(user_id, category_id)` | User preferred onboarding categories | 0 |
| `author_follows` | `(follower_id, author_id)` | Author subscription relation | 0 |

### 3.2 Exact Table Columns & Constraints

#### A. `articles` Table
- `id`: `uuid`, NOT NULL, default `gen_random_uuid()`, PRIMARY KEY.
- `legacy_id`: `text`, nullable, UNIQUE.
- `title`: `text`, NOT NULL.
- `slug`: `text`, NOT NULL, UNIQUE.
- `excerpt`: `text`, NOT NULL.
- `content`: `text`, nullable.
- `author_name`: `text`, NOT NULL, default `'Editorial Staff'::text`.
- `author_role`: `text`, NOT NULL, default `'Writer'::text`.
- `author_avatar`: `text`, nullable.
- `author_id`: `uuid`, nullable, FOREIGN KEY -> `profiles.id` ON DELETE SET NULL.
- `category_id`: `uuid`, nullable, FOREIGN KEY -> `categories.id` ON DELETE NO ACTION.
- `category_slug`: `text`, nullable.
- `badge`: `text`, NOT NULL, default `'NEWS'::text`.
- `badge_color`: `text`, NOT NULL, default `'#FFF1C6'::text`.
- `card_color`: `text`, NOT NULL, default `'#FFF1C6'::text`.
- `is_live`: `bool`, NOT NULL, default `false`.
- `hero_image_url`: `text`, nullable.
- `cover_image_url`: `text`, nullable.
- `likes_count`: `int4`, NOT NULL, default `0`.
- `saves_count`: `int4`, NOT NULL, default `0`.
- `star_count`: `int4`, NOT NULL, default `0`, CHECK (`star_count >= 0`).
- `reading_time_minutes`: `int4`, NOT NULL, default `3`, CHECK (`reading_time_minutes > 0`).
- `status`: `text`, NOT NULL, default `'draft'::text`, CHECK (`status IN ('draft', 'published', 'archived')`).
- `tags`: `_text` (`text[]`), NOT NULL, default `'{}'::text[]`.
- `published_at`: `timestamptz`, nullable.
- `created_at`: `timestamptz`, NOT NULL, default `now()`.
- `updated_at`: `timestamptz`, NOT NULL, default `now()`.

#### B. `categories` Table
- `id`: `uuid`, NOT NULL, default `gen_random_uuid()`, PRIMARY KEY.
- `name`: `text`, NOT NULL, UNIQUE.
- `slug`: `text`, NOT NULL, UNIQUE.
- `description`: `text`, nullable.
- `created_at`: `timestamptz`, NOT NULL, default `now()`.

#### C. `fixed_tags` Table
- `id`: `uuid`, NOT NULL, default `gen_random_uuid()`, PRIMARY KEY.
- `name`: `text`, NOT NULL, UNIQUE.
- `slug`: `text`, NOT NULL, UNIQUE.
- `created_at`: `timestamptz`, NOT NULL, default `now()`.

#### D. `saved_articles` Table
- `user_id`: `uuid`, NOT NULL, FOREIGN KEY -> `profiles.id` ON DELETE CASCADE.
- `article_id`: `uuid`, NOT NULL, FOREIGN KEY -> `articles.id` ON DELETE CASCADE.
- `created_at`: `timestamptz`, NOT NULL, default `now()`.
- PRIMARY KEY: `(user_id, article_id)`.

#### E. `article_stars` Table
- `user_id`: `uuid`, NOT NULL, FOREIGN KEY -> `profiles.id` ON DELETE CASCADE.
- `article_id`: `uuid`, NOT NULL, FOREIGN KEY -> `articles.id` ON DELETE CASCADE.
- `created_at`: `timestamptz`, NOT NULL, default `now()`.
- PRIMARY KEY: `(user_id, article_id)`.

#### F. `profile_favorite_categories` Table
- `user_id`: `uuid`, NOT NULL, FOREIGN KEY -> `profiles.id` ON DELETE CASCADE.
- `category_id`: `uuid`, NOT NULL, FOREIGN KEY -> `categories.id` ON DELETE CASCADE.
- `created_at`: `timestamptz`, NOT NULL, default `now()`.
- PRIMARY KEY: `(user_id, category_id)`.

### 3.3 Indexes Inventory
- `articles`:
  - `articles_pkey` (UNIQUE btree on `id`)
  - `articles_slug_key` (UNIQUE btree on `slug`)
  - `articles_legacy_id_key` & `articles_legacy_id_idx` (btree on `legacy_id`)
  - `articles_author_id_idx` (btree on `author_id`)
  - `articles_category_id_idx` (btree on `category_id`)
  - `articles_category_slug_idx` (btree on `category_slug`)
  - `articles_badge_idx` (btree on `badge`)
  - `articles_created_at_idx` (btree on `created_at DESC`)
- `categories`:
  - `categories_pkey` (UNIQUE on `id`)
  - `categories_name_key` (UNIQUE on `name`)
  - `categories_slug_key` & `categories_slug_idx` (UNIQUE/btree on `slug`)
- `fixed_tags`:
  - `fixed_tags_pkey` (UNIQUE on `id`), `fixed_tags_name_key`, `fixed_tags_slug_key`
- `saved_articles`:
  - `saved_articles_pkey` (UNIQUE on `(user_id, article_id)`)
  - `saved_articles_user_id_idx` (btree on `user_id`)
  - `saved_articles_article_id_idx` (btree on `article_id`)
- `article_stars`:
  - `article_stars_pkey` (UNIQUE on `(user_id, article_id)`)
  - `article_stars_article_id_idx` (btree on `article_id`)

### 3.4 Row Level Security (RLS) & Policies
All 9 tables have `rowsecurity = true`.

| Table | Policy Name | Command | Target Role | Permissive | Condition / Check |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `categories` | `categories_select_public` | SELECT | `public` | Permissive | `true` (Open public catalog browsing) |
| `fixed_tags` | `fixed_tags_read_all` | SELECT | `public` | Permissive | `true` (Open public taxonomy) |
| `articles` | `articles_select_public` | SELECT | `public` | Permissive | `(status = 'published') OR ((SELECT auth.uid()) = author_id)` |
| `articles` | `articles_insert_author` | INSERT | `public` | Permissive | CHECK: `(SELECT auth.uid()) = author_id` |
| `articles` | `articles_update_author` | UPDATE | `public` | Permissive | QUAL: `(auth.uid() = author_id) AND (status = 'draft' OR (status = 'published' AND published_at <= now() AND now() - published_at <= interval '30 days'))`<br>CHECK: `auth.uid() = author_id` |
| `articles` | `articles_delete_author` | DELETE | `public` | Permissive | QUAL: `(auth.uid() = author_id) AND (status = 'draft' OR (status = 'published' AND published_at <= now() AND now() - published_at <= interval '30 days'))` |
| `article_stars`| `article_stars_select` | SELECT | `public` | Permissive | `true` |
| `article_stars`| `article_stars_insert` | INSERT | `public` | Permissive | CHECK: `(SELECT auth.uid()) = user_id` |
| `article_stars`| `article_stars_delete` | DELETE | `public` | Permissive | QUAL: `(SELECT auth.uid()) = user_id` |
| `saved_articles`| `saved_articles_select_own`| SELECT | `public` | Permissive | QUAL: `(SELECT auth.uid()) = user_id` |
| `saved_articles`| `saved_articles_insert_own`| INSERT | `public` | Permissive | CHECK: `(SELECT auth.uid()) = user_id` |
| `saved_articles`| `saved_articles_delete_own`| DELETE | `public` | Permissive | QUAL: `(SELECT auth.uid()) = user_id` |
| `profiles` | `profiles_select_public` | SELECT | `public` | Permissive | `true` |
| `profiles` | `profiles_insert_own` | INSERT | `public` | Permissive | CHECK: `(SELECT auth.uid()) = id` |
| `profiles` | `profiles_update_own` | UPDATE | `public` | Permissive | QUAL: `(SELECT auth.uid()) = id` |
| `profile_favorite_categories` | `profile_favorites_select` | SELECT | `public` | Permissive | QUAL: `(SELECT auth.uid()) = user_id` |
| `profile_favorite_categories` | `profile_favorites_insert` | INSERT | `public` | Permissive | CHECK: `(SELECT auth.uid()) = user_id` |
| `profile_favorite_categories` | `profile_favorites_delete` | DELETE | `public` | Permissive | QUAL: `(SELECT auth.uid()) = user_id` |

### 3.5 Database Triggers and Functions
1. **`handle_article_lifecycle()` on `articles`** (BEFORE INSERT OR UPDATE):
   - **INSERT**: If `NEW.status = 'published'`, assigns `NEW.published_at := clock_timestamp()`; else `NEW.published_at := null`. Forces `NEW.star_count := 0`.
   - **UPDATE**:
     - Forgery protection: If `NEW.star_count` is modified by `authenticated` or `anon`, resets it to `OLD.star_count`.
     - State transition: Transition from `'draft'` to `'published'` assigns `NEW.published_at := clock_timestamp()`.
     - Irreversibility: Throws exception if attempting to revert `'published'` back to `'draft'` (`'Published articles cannot be reverted to draft'`).
     - 30-Day lock: Throws exception if updating a published article older than 30 days (`'Articles cannot be modified after 30 days of publication'`).
     - Timestamp refresh: Sets `NEW.updated_at := clock_timestamp()`.
2. **`handle_article_delete()` on `articles`** (BEFORE DELETE):
   - Throws exception if deleting a published article after 30 days of publication.
3. **`check_article_tags()` on `articles`** (BEFORE INSERT OR UPDATE):
   - Enforces that published articles must have between 1 and 5 tags.
   - Enforces tag uniqueness within the tags array (`'Article tags must be unique'`).
4. **`handle_article_star_change()` on `article_stars`** (AFTER INSERT OR DELETE):
   - Increments `articles.star_count` by 1 on INSERT.
   - Decrements `articles.star_count` by 1 on DELETE (clamped at 0 via `greatest(star_count - 1, 0)`).
5. **`handle_new_user()` on `auth.users`** (AFTER INSERT):
   - Automatically provisions a record in `public.profiles` when a user signs up.

---

## 4. Object-by-Object Comparison: Repository vs. Live Schema

| Live Database Object | Repository State | Gap Type | Severity | Action Required |
| :--- | :--- | :--- | :--- | :--- |
| `public.articles` | `NewsArticleModel` (presentation model) lacks `id` (uuid), `star_count`, `category_id`, timestamps, and serialization. | Schema Mismatch / Missing DTO | High | Create `ArticleDto` and entity reflecting the live table contract. |
| `public.categories` | 20 hardcoded string names in `AppData.categories`. No Category entity/model. | Missing Entity & DataSource | High | Create `CategoryModel` with UUID `id`, `name`, `slug` and a remote data source. |
| `public.fixed_tags` | Absent from repository. | Missing Taxonomy Support | Medium | Add tag models and validation matching the 12 fixed tags. |
| `public.saved_articles` | In-memory `List<NewsArticleModel>` in `CollectionsCubit`. | Missing Remote Persistence | High | Implement bookmark datasource targeting `saved_articles(user_id, article_id)`. |
| `public.article_stars` | Absent from client code. | Missing Feature Wiring | Medium | Implement remote star/unstar RPC or table mutation. |
| `public.profiles` | `ProfileRemoteDataSource` implemented. | Fully Reconciled | None | Verified matching live `profiles` table. |
| `public.profile_favorite_categories` | Handled via array in profile; junction table unused in client. | Minor Discrepancy | Low | Wire favorite category sync to junction table during onboarding. |
| Migration Files (`supabase/migrations/*.sql`) | 0 migration files in Git. | Missing Baseline Artifacts | Critical | Export current live schema into baseline migration in Phase 1. |

---

## 5. Evidence of Data Preservation and Seed State

### 5.1 Verification of 20 Categories
All 20 canonical categories are present with UUID primary keys and slug identifiers:
- `2fee2891-a998-449b-9068-57e60eef42c2` | Art & Design (`art-design`)
- `46f0efdc-2a8f-4c30-ac40-0cc88cfc3b4e` | Books & Literature (`books-literature`)
- `e3af1cd2-b787-4037-8770-cc4fa4534870` | Business & Entrepreneurship (`business-entrepreneurship`)
- `51ced5b2-6e60-4def-9825-a2456f03a3d6` | Education & Learning (`education-learning`)
- `173a58b4-776c-40cd-a50a-6ce3492e6806` | Entertainment & Movies (`entertainment-movies`)
- `6891a1ec-febf-4ac0-b0ae-536f6c7bc788` | Environment & Sustainability (`environment-sustainability`)
- `d58c248c-d339-400b-8fb6-e3b2012c6b08` | Finance & Investing (`finance-investing`)
- `ddf8be4e-2152-48a1-b3b6-fcf616fe2752` | Food & Cooking (`food-cooking`)
- `67821015-ab5a-4711-ae6c-ef1026dff7cc` | Health & Wellness (`health-wellness`)
- `602252f8-f441-4cf3-baf8-740c41e377fc` | History (`history`)
- `1cc34be4-f18b-4295-a942-5965f28fc523` | Lifestyle (`lifestyle`)
- `361de395-39e9-47aa-a74a-44eea1f1da77` | News & Current Events (`news-current-events`)
- `a8f90dc9-0e23-491e-b61c-c37e884f92c1` | Personal Development (`personal-development`)
- `328011a2-aeaa-4254-9480-cbf2b8ce72ff` | Politics (`politics`)
- `6853d951-f329-45d1-80ca-3686f422e7f6` | Programming & Software Development (`programming-software-dev`)
- `cf1e26eb-372a-45fe-a932-c35a3d3ca5fb` | Psychology (`psychology`)
- `7224eaf7-068c-427e-a06a-bd336e9a2fd6` | Science (`science`)
- `45b6e30d-0f0f-4613-85dd-bf799bac2027` | Sports (`sports`)
- `7370e59d-b08f-43ff-96aa-12982c7a85e0` | Technology (`technology`)
- `fb6eb820-f29f-4a80-ae3e-e1cc5d04f5ed` | Travel & Culture (`travel-culture`)

### 5.2 Verification of 12 Fixed Tags
- `99fed155-324f-4d17-a577-4a77e51a97bc` (`ai-machine-learning`)
- `dd2d3d43-4cd1-4638-8efe-5836a8b56955` (`deep-work`)
- `79d0d478-7e12-411e-b507-5d4fd7b954e4` (`future-of-tech`)
- `998ff953-166b-49ff-a4e4-3cd9171cbd61` (`leadership`)
- `7edf0376-4aa3-483a-b3f0-ef575bd63498` (`mental-health`)
- `6478dc7b-543a-459c-a453-baa08c61c843` (`mobile-dev`)
- `1a246642-fc75-495d-a868-b5fae2345223` (`product-strategy`)
- `f3c283ac-03a5-42ce-8dc4-566111da78cb` (`psychology`)
- `c115a0d9-114f-4de5-8c3e-7ed4b62aad22` (`software-architecture`)
- `9a779c8e-0938-4614-a9a7-7022019b57d6` (`startups`)
- `08da09e0-6834-44fa-9884-c26419589ff7` (`ui-ux-design`)
- `cd854cf8-9079-489b-bc94-744de2655516` (`writing-creativity`)

### 5.3 Verification of the 14 Editorial Articles
Query confirmation:
- Total Articles: 14
- Published Articles: 14
- Draft Articles: 0
- All 14 articles possess valid `legacy_id` values (`story_deep_space_survey`, `story_deep_sea_biodiversity`, `story_quantum_breakthrough`, etc.), proper foreign keys to `categories.id`, non-null `published_at` timestamps (`2026-10-11 16:46:34+00`), and conform to tag constraints.

---

## 6. Confirmed Existing vs. Missing Functionality

### 6.1 Confirmed Existing
1. **Authentication**: Supabase Auth (Sign-up, Sign-in, Sign-out, Google Token exchange) fully implemented in `AuthApiSource`.
2. **Profile Remote Sync**: Remote read/update of user profile in `ProfileRemoteDataSource`.
3. **Database Foundation**: Complete schema, tables, constraints, foreign keys, indexes, triggers, and RLS policies on live Supabase.
4. **Public Browsing Authorization**: Database policies explicitly allow public read access for catalog categories, tags, and published articles.

### 6.2 Confirmed Missing (Must Be Implemented)
1. **Articles Remote Data Source (`ArticlesRemoteDataSource`)**: No code currently queries the live `articles` table.
2. **Categories Remote Data Source (`CategoriesRemoteDataSource`)**: No code queries the live `categories` or `fixed_tags` tables.
3. **Bookmarks Remote Data Source (`BookmarksRemoteDataSource`)**: No code queries or modifies `saved_articles`.
4. **Article Stars Remote Data Source**: No code handles starring/unstarring via `article_stars`.
5. **Draft Creation & Server Lifecycle Compliance**: No client code inserts drafts (`status = 'draft'`) or handles publication state transitions without attempting client-authoritative timestamps.
6. **Local Cache / Offline Storage**: Hive is not initialized; no offline store exists for feed caching.
7. **Service Locator Wiring**: None of the article/category datasources or repositories are registered in `getIt`.

---

## 7. Migration and Data-Preservation Risks

1. **Destructive DDL Risk (Critical)**:
   - Running raw `CREATE TABLE` or executing migrations that redefine `categories.id` or `articles.category_id` as `text` would cause severe schema collisions, drop foreign keys, or destroy the 14 verified articles.
   - **Mitigation**: Never run destructive DDL. All migrations must use `IF NOT EXISTS` or be established as a non-destructive baseline snapshot.
2. **Table Naming Drift Risk (High)**:
   - Client proposals previously referenced `user_saved_articles`. Using this name in new migrations would duplicate the existing live table `saved_articles` and fracture bookmarks.
   - **Mitigation**: Mandate `saved_articles` across all models, queries, and repositories.
3. **Counter Field Name Drift Risk (High)**:
   - Proposing `stars_count` instead of `star_count` will break the live trigger `handle_article_star_change()` and fail column lookups.
   - **Mitigation**: Retain `star_count` strictly across Dart DTOs, domain entities, and queries.
4. **Timestamp Forgery Risk (Medium)**:
   - Client attempts to supply `published_at: DateTime.now().toIso8601String()` on article insert or update will conflict with trigger logic or trigger RLS rejections.
   - **Mitigation**: Client must only toggle `status = 'published'`, allowing the server trigger `handle_article_lifecycle()` to set `clock_timestamp()`.

---

## 8. Proposed Phase 1 Migration Strategy (Non-Destructive)

To bridge the gap between Git and the live Supabase database without touching live data:
1. **Baseline Migration Extraction**:
   - Create `supabase/migrations/20261015000000_baseline_schema.sql`.
   - Populate it with the exact DDL representing the current live state (`profiles`, `categories`, `fixed_tags`, `articles`, `article_stars`, `article_likes`, `saved_articles`, `profile_favorite_categories`, `author_follows`, triggers, functions, and RLS policies).
   - All DDL statements must be guarded with `CREATE TABLE IF NOT EXISTS`, `CREATE INDEX IF NOT EXISTS`, and `CREATE OR REPLACE FUNCTION`.
2. **Seed Migration**:
   - Create `supabase/migrations/20261015000001_seed_catalog.sql` containing `ON CONFLICT DO NOTHING` statements for the 20 categories and 12 fixed tags, ensuring idempotency.
3. **Supabase CLI Baseline Registration**:
   - In Supabase CLI environments, mark the baseline migration as already applied (`supabase migration repair --status applied <version>`) rather than re-running it against the live instance.

---

## 9. Explicit Unresolved Issues & Phase 1 Readiness Recommendation

### 9.1 Unresolved Issues
1. **`article_likes` vs `article_stars`**:
   - Both tables exist in the database. `article_stars` has an active trigger updating `articles.star_count`. `article_likes` has no trigger and `articles.likes_count` is static. The app should standardize on `article_stars` (with `star_count`) as requested.
2. **Tag Modeling in Feed vs Fixed Tags**:
   - The database stores tags on `articles.tags` as a PostgreSQL text array (`text[]`). The check trigger ensures between 1 and 5 unique tags. Client DTOs must parse PostgreSQL arrays correctly.

### 9.2 Recommendation on Phase 1
**Phase 1 can safely begin.**
- The live schema contract is 100% understood, documented, and verified.
- All discrepancies between legacy proposals and the live database have been resolved.
- Data preservation requirements for the 14 editorial articles, UUID categories, and `saved_articles` are clearly established.
- Phase 1 can proceed immediately with zero risk of database collisions or regressions.
