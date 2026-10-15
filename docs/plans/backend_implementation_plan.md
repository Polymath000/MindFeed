# MindFeed Backend Implementation Plan

## Executive Summary & Alignment

This plan governs the backend, data source, Supabase, and offline integration for MindFeed. It incorporates the architectural review and directly reconciles the live Supabase database with the repository.

Rather than rebuilding existing cloud objects, this plan establishes a strict baseline against the live schema (UUID category foreign keys, `star_count` naming, server-authoritative lifecycle triggers, and public category access), establishes versioned database migrations, and builds the Clean Architecture data and domain layers without altering the presentation shell.

---

## 1. Critical Schema & Architectural Reconciliations

| Area | Audit Draft | Live Verified Contract | Revised Resolution |
| :--- | :--- | :--- | :--- |
| **Category Identifiers** | `text` slug primary keys | `uuid` primary key with unique slug | Keep `id uuid PRIMARY KEY`, `slug text UNIQUE NOT NULL`, `name text NOT NULL`. `articles.category_id` is a UUID foreign key. |
| **Star Counter** | `stars_count` | `star_count` | Retain `star_count int NOT NULL DEFAULT 0` across SQL triggers, `ArticleModel`, remote datasources, and entities. |
| **Publication & Timestamping** | Client assigns `published_at = now()` | Database trigger assigns `clock_timestamp()` | Client updates `status = 'published'`. The database trigger sets `published_at`, blocks client timestamp forgery, and enforces the 30-day immutability ceiling. |
| **Category Access** | Authenticated only | Public catalog access | Categories and published articles are readable by `anon` and `authenticated`. Drafts, user favorites, bookmarks, and stars remain restricted to `authenticated`. |
| **Database State** | Assumed unbuilt | Live objects + 14 editorial articles exist | Distinguish missing Git migration files from missing cloud objects. Generate baseline migration without dropping or duplicating live data. |

---

## 2. Technical Implementation Boundaries

### 2.1 Feed Ranking & Category Prioritization
Feed ordering requires explicit prioritization of user favorites over pure recency:
* When `preferredCategoryIds` is non-empty:
  1. Fetch published articles where `category_id IN (preferredCategoryIds)` ordered by `published_at DESC`.
  2. Append remaining published articles where `category_id NOT IN (preferredCategoryIds)` ordered by `published_at DESC`.
* When `preferredCategoryIds` is empty: order strictly by `published_at DESC`.
* Query implementation utilizes a database function or PostgREST composite ordering:
  ```sql
  ORDER BY (category_id = ANY(ARRAY['...']::uuid[])) DESC, published_at DESC
  ```

### 2.2 Content & Image Validation
* **Title & Word Count:**
  * Title: Maximum 12 words (`array_length(regexp_split_to_array(trim(title), '\s+'), 1) <= 12`).
  * Content: Minimum 300 words (`array_length(regexp_split_to_array(trim(content), '\s+'), 1) >= 300`).
  * Enforced via Postgres `CHECK` constraints on `articles` and mirrored in `PublishArticleUseCase`.
* **Cover Image Aspect Ratio:**
  * Client-side validation: decode image dimensions via Flutter `decodeImageFromList` or `ImageStreamListener` to assert `width > height` (landscape only) before initiating upload or record creation.
* **Tag Membership:**
  * Tags validated against the fixed tags domain:
    `tags <@ ARRAY['AI & Machine Learning', 'Mobile Dev', 'UI/UX Design', 'Leadership', 'Startups', 'Deep Work', 'Mental Health', 'Psychology', 'Future of Tech', 'Writing & Creativity', 'Software Architecture', 'Product Strategy']::text[]`
  * Array length constrained between 1 and 5.

### 2.3 Search, Filtering & Pagination
* Full-text search supported via generated `tsvector` column (`to_tsvector('english', title || ' ' || content)`) with GIN index.
* Tag filtering uses Postgres array intersection (`tags && ARRAY['...']::text[]`).
* Pagination implemented via stable cursor (`published_at < cursor_timestamp`) with a fallback limit/offset for category grids.

### 2.4 Star & Bookmark Separation
* `article_stars`: Tracks peer curation endorsement. Binary toggle per user, public aggregate counter on `articles.star_count` maintained atomically via trigger.
* `user_saved_articles`: Private user collection/bookmarking. Synced to Supabase for multi-device parity. Completely separated from local offline text downloads.

### 2.5 Offline Text-Only Storage (BR-04, BR-06)
* Hive box `downloaded_articles` persists `DownloadedArticleEntity` (id, title, content, authorName, authorAvatar, categoryId, categoryName, tags, publishedAt, readingTimeMinutes, downloadedAt).
* Network images are strictly omitted from local caching.
* When offline, only explicitly downloaded articles are served. Network failures on the live feed return `Failure.offline()` rather than injecting stale or mock data.
* `LogoutUseCase` executes local cleanup in a fail-safe `finally` block: local caches and Hive boxes are purged even if the remote Supabase `signOut()` network call encounters an error or timeout.

### 2.6 Immutability & Deletion Retention
* Articles older than 30 days (`published_at < now() - interval '30 days'`) cannot be updated or deleted by authors.
* Soft-deletion vs hard-deletion:
  * Draft deletion performs hard delete.
  * Published article deletion within 30 days performs cascade deletion on `article_stars` and `user_saved_articles`. Offline downloaded copies on user devices are invalidated during subsequent synchronization checks.

---

## 3. Phased Execution Roadmap

### Phase 0: Reconcile Repository & Live Database (Authorized for Immediate Execution)
* **Objective:** Inspect live Supabase schema and align repository state with zero destructive operations.
* **Tasks:**
  1. Inspect existing live tables (`profiles`, `categories`, `profile_favorite_categories`, `articles`, `article_stars`, `fixed_tags`).
  2. Document exact live column types, default values, UUIDs, foreign key actions, and trigger signatures.
  3. Verify the 14 existing editorial articles and their schema integrity.
  4. Inspect active RLS policies and grants for `anon` and `authenticated` roles.
  5. Audit repository code (`ProfileRemoteDataSourceImpl`, `AuthApiSource`) against the live schema findings.
* **Deliverable:** Verified schema gap report distinguishing live objects from missing Git artifacts.

### Phase 1: Establish Versioned Database Contract
* **Objective:** Codify the live database contract into repeatable Git migrations and add missing tables.
* **Tasks:**
  1. Create baseline schema migration (`supabase/migrations/20261015000000_baseline_schema.sql`) capturing existing verified structures.
  2. Create migration for confirmed missing objects (e.g., `user_saved_articles` join table).
  3. Ensure RLS policies enforce:
     * Public `SELECT` on `categories` and published `articles`.
     * Strict user ownership on `article_stars`, `user_saved_articles`, `profile_favorite_categories`, and drafts.
     * 30-day modification lock on published articles.
* **Verification:** Migration syntax checks and local/dry-run schema verification.

### Phase 2: Implement Article Data Layer (Remote & Domain)
* **Objective:** Replace UI mock references with live Supabase client integrations.
* **Tasks:**
  1. Create `CategoryModel` and `CategoryEntity` with UUID `id`, `slug`, and `name`.
  2. Create `ArticleModel` and `ArticleEntity` with `star_count`, UUID foreign keys, author profile join, and tags parsing.
  3. Implement `ArticlesRemoteDataSource`:
     * Read path: `getHomeFeed`, `getArticleById`, `getArticlesByCategory`, `getArticlesByAuthor`, `searchArticles`.
     * Write path: `saveDraft`, `publishArticle` (status transition only; server stamps `published_at`), `updateArticle`, `deleteArticle`.
     * Interaction: `starArticle`, `unstarArticle`, `saveBookmark`, `removeBookmark`, `getSavedArticles`.
  4. Implement `ArticlesRepositoryImpl` returning `ApiResult<T>` with `NetworkInfoImpl` connectivity checks.
  5. Implement domain use cases:
     * `GetHomeFeedUseCase`, `SearchArticlesUseCase`, `GetArticleDetailsUseCase`.
     * `ToggleStarUseCase`, `ToggleBookmarkUseCase`, `GetSavedArticlesUseCase`.
     * `SaveDraftUseCase`, `PublishArticleUseCase`, `UpdateArticleUseCase`, `DeleteArticleUseCase`.

### Phase 3: Text-Only Offline Storage & Logout Cleanup
* **Objective:** Implement persistent offline reading without network image caching.
* **Tasks:**
  1. Define `DownloadedArticleEntity` and generate Hive TypeAdapter.
  2. Implement `ArticlesLocalDataSource`:
     * `saveDownloadedArticle`, `getDownloadedArticles`, `getDownloadedArticleById`, `deleteDownloadedArticle`, `clearAllDownloadedArticles`.
  3. Implement offline use cases:
     * `DownloadArticleTextUseCase`, `GetDownloadedArticlesUseCase`, `DeleteDownloadedArticleUseCase`.
  4. Implement `LogoutUseCase`:
     * Guarantees complete erasure of `downloaded_articles` Hive box, user session cache, and secure preferences regardless of network reachability.

### Phase 4: Integrated Verification & Quality Gates
* **Objective:** Comprehensive testing of data contracts, security policies, and offline behavior.
* **Tasks:**
  1. Unit tests for `ArticleModel` serialization, tag validation, and word count calculation.
  2. Unit tests for `ArticlesRemoteDataSource` PostgREST query builders and error mapping.
  3. Integration tests for `ArticlesLocalDataSource` Hive CRUD and logout wipe sequence.
  4. Validation tests for `PublishArticleUseCase` (12-word title ceiling, 300-word body floor, landscape orientation).
  5. Validation tests for 30-day edit/delete immutability enforcement.
  6. Service locator wiring verification in `lib/core/utls/setup_service_locator.dart`.
  7. Run `flutter analyze` and `flutter test` across all modified data and domain files.

---

## 4. Current Authorization State

* **Authorized Scope:** **Phase 0 only**.
* **Transition Gate:** Progression to Phase 1 and subsequent phases requires sign-off on the Phase 0 live database audit findings.
