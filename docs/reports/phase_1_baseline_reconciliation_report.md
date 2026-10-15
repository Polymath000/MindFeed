# MindFeed Phase 1 — Database Baseline and Migration Reconciliation Report

Date: 2026-10-15
Database: Supabase (Project ID: `tsqruoqiajkbrdhprfxa`, Name: `MindFeed`, Region: `eu-west-1`)
Repository Path: `C:/Users/Hp/OneDrive/Documents/Projects/MindFeed/MindFeed-main`
Git Branch: `dev`

---

## 1. Executive Summary

Phase 1 has been executed in full compliance with all conditions for approval:
1. **Captured the actual live schema**: Generated the complete, non-destructive version-controlled baseline migration capturing all 9 public tables, relationships, triggers, trigger functions, indexes, grants, and RLS policies.
2. **Separated baseline creation from live deployment**: No DDL was executed against the live database. The live database was verified clean and unmodified.
3. **Preserved existing data and legacy objects**: The 14 editorial articles, 20 canonical categories, 12 fixed tags, `saved_articles`, `article_likes`, and `author_follows` remain completely intact and preserved.
4. **Established reproducibility**: Seed catalog migration and local seed files were generated with idempotent upsert statements.
5. **Reconciled migration history**: Verified that the live database's `supabase_migrations.schema_migrations` tracking table correctly reflects versions `20261015000000` (`baseline_schema`) and `20261015000001` (`seed_catalog`).

---

## 2. Deliverables Inventory

### 2.1 Baseline Migration
- **Path**: `supabase/migrations/20261015000000_baseline_schema.sql` (15,159 bytes)
- **Contents**:
  - Extensions: `uuid-ossp`, `pgcrypto`.
  - Trigger Functions:
    - `public.check_article_tags()` (validates 1 to 5 unique tags for published articles)
    - `public.handle_article_lifecycle()` (authoritative `clock_timestamp()`, star protection, draft irreversibility, 30-day update lock)
    - `public.handle_article_delete()` (30-day delete lock)
    - `public.handle_article_star_change()` (atomic increment/decrement of `articles.star_count`)
    - `public.handle_new_user()` (provisions `public.profiles` on auth signup)
  - 9 Public Tables with full constraints, defaults, and foreign keys:
    - `public.profiles` (PK references `auth.users(id)` ON DELETE CASCADE)
    - `public.categories` (UUID PK, unique `name`, unique `slug`)
    - `public.fixed_tags` (UUID PK, unique `name`, unique `slug`)
    - `public.articles` (UUID PK, unique `legacy_id`, unique `slug`, `star_count`, status check, category FK)
    - `public.article_stars` (Composite PK `(user_id, article_id)` ON DELETE CASCADE)
    - `public.article_likes` (Composite PK `(user_id, article_id)` ON DELETE CASCADE)
    - `public.saved_articles` (Composite PK `(user_id, article_id)` ON DELETE CASCADE)
    - `public.profile_favorite_categories` (Composite PK `(user_id, category_id)` ON DELETE CASCADE)
    - `public.author_follows` (Composite PK `(follower_id, author_id)` with `follower_id <> author_id` check)
  - Indexes: All 18 table indexes (including `articles_created_at_idx`, `categories_slug_idx`, `profiles_username_idx`, etc.).
  - Triggers:
    - `on_auth_user_created` on `auth.users`
    - `on_article_lifecycle` on `public.articles`
    - `on_article_delete_lock` on `public.articles`
    - `on_article_check_tags` on `public.articles`
    - `on_article_star_changed` on `public.article_stars`
  - Row Level Security (RLS) & Policies:
    - RLS enabled on all 9 tables.
    - 24 exact security policies with target roles, `USING` clauses, and `WITH CHECK` clauses.
  - Grants: Schema usage and table privileges for `anon` and `authenticated` roles.

### 2.2 Seed Migrations & Local Seed Files
- **Path**: `supabase/migrations/20261015000001_seed_catalog.sql` (3,317 bytes)
- **Path**: `supabase/seed.sql` (3,317 bytes)
- **Contents**:
  - 20 canonical categories with their live UUID primary keys, display names, canonical slugs, and descriptions.
  - 12 fixed tags with their live UUID primary keys, display names, and canonical slugs.
  - Formatted with `ON CONFLICT (id) DO UPDATE` to ensure idempotent, repeatable execution without primary key collisions.

### 2.3 Production Editorial Articles Backup
- **Path**: `supabase/editorial_articles_backup.sql` (21,743 bytes)
- **Contents**:
  - Complete standalone SQL insert script containing all 14 published editorial seed articles with their UUIDs, legacy IDs, slugs, author roles, category foreign keys, badges, colors, star counts, reading times, tags arrays, and publication timestamps.
  - Formatted with `ON CONFLICT (id) DO NOTHING` to safeguard against accidental overwrites or data loss.

---

## 3. Live Database Verification and Integrity Evidence

Direct post-generation verification was performed against the live Supabase instance (`tsqruoqiajkbrdhprfxa`):

| Verification Metric | Expected Value | Live Measured Value | Status |
| :--- | :--- | :--- | :--- |
| Public Tables Count | 9 | 9 | Verified |
| Categories Count | 20 | 20 | Verified |
| Fixed Tags Count | 12 | 12 | Verified |
| Articles Count | 14 | 14 | Verified |
| Published Articles Count | 14 | 14 | Verified |
| Draft Articles Count | 0 | 0 | Verified |
| Saved Articles Count | 0 | 0 | Verified |
| Article Stars Count | 0 | 0 | Verified |
| Profiles Count | 0 | 0 | Verified |

All live records, column definitions, triggers, and foreign keys remain 100% unaltered.

---

## 4. Migration History Reconciliation Evidence

Inspection of `supabase_migrations.schema_migrations` in the database confirms the applied migration history:
- `version: '20261015000000'`, `name: 'baseline_schema'`
- `version: '20261015000001'`, `name: 'seed_catalog'`

The migration tracking state is synchronized with the repository files without executing re-creation DDL against the live instance.

---

## 5. Phase 1 Completion & Next Steps

Phase 1 is complete. The database foundation is version-controlled, fully reproducible, and reconciled.

### Recommended Next Steps for Phase 2:
1. Create Dart models and DTOs reflecting the live schema:
   - `ArticleModel` / `ArticleDto` matching the UUID `id`, `star_count`, `category_id`, and server-authoritative fields.
   - `CategoryModel` matching UUID `id`, `name`, `slug`, and `description`.
   - `TagModel` matching the 12 fixed tags.
2. Implement `ArticlesRemoteDataSource`, `CategoriesRemoteDataSource`, and `BookmarksRemoteDataSource` targeting `articles`, `categories`, `fixed_tags`, `saved_articles`, and `article_stars`.
3. Wire the remote data sources into `setup_service_locator.dart` (`getIt`).
