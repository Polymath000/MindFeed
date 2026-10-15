CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

CREATE OR REPLACE FUNCTION public.check_article_tags()
RETURNS trigger
LANGUAGE plpgsql
AS $$
declare
  tag_count integer;
  unique_count integer;
begin
  if NEW.status = 'published' then
    tag_count := cardinality(NEW.tags);
    if tag_count is null or tag_count < 1 or tag_count > 5 then
      raise exception 'Published articles must have between 1 and 5 tags';
    end if;

    select count(distinct t) into unique_count
    from unnest(NEW.tags) as t;

    if unique_count <> tag_count then
      raise exception 'Article tags must be unique';
    end if;
  end if;

  return NEW;
end;
$$;

CREATE OR REPLACE FUNCTION public.handle_article_lifecycle()
RETURNS trigger
LANGUAGE plpgsql
AS $$
begin
  if TG_OP = 'INSERT' then
    if NEW.status = 'published' then
      NEW.published_at := clock_timestamp();
    else
      NEW.published_at := null;
    end if;
    NEW.star_count := 0;
  elsif TG_OP = 'UPDATE' then
    if current_user in ('authenticated', 'anon') and NEW.star_count is distinct from OLD.star_count then
      NEW.star_count := OLD.star_count;
    end if;

    if OLD.status = 'draft' and NEW.status = 'published' then
      NEW.published_at := clock_timestamp();
    elsif OLD.status = 'published' and NEW.status = 'draft' then
      raise exception 'Published articles cannot be reverted to draft';
    end if;

    if OLD.status = 'published' and OLD.published_at is not null and OLD.published_at < (now() - interval '30 days') then
      raise exception 'Articles cannot be modified after 30 days of publication';
    end if;

    NEW.updated_at := clock_timestamp();
  end if;

  return NEW;
end;
$$;

CREATE OR REPLACE FUNCTION public.handle_article_delete()
RETURNS trigger
LANGUAGE plpgsql
AS $$
begin
  if OLD.status = 'published' and OLD.published_at is not null and OLD.published_at < (now() - interval '30 days') then
    raise exception 'Articles cannot be deleted after 30 days of publication';
  end if;
  return OLD;
end;
$$;

CREATE OR REPLACE FUNCTION public.handle_article_star_change()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
begin
  if TG_OP = 'INSERT' then
    update public.articles
    set star_count = star_count + 1
    where id = NEW.article_id;
  elsif TG_OP = 'DELETE' then
    update public.articles
    set star_count = greatest(star_count - 1, 0)
    where id = OLD.article_id;
  end if;
  return null;
end;
$$;

CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
begin
  insert into public.profiles (id, username, display_name, avatar_url)
  values (
    NEW.id,
    NEW.raw_user_meta_data->>'username',
    coalesce(NEW.raw_user_meta_data->>'display_name', NEW.raw_user_meta_data->>'full_name'),
    NEW.raw_user_meta_data->>'avatar_url'
  );
  return NEW;
end;
$$;

CREATE TABLE IF NOT EXISTS public.profiles (
    id uuid NOT NULL PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    username text UNIQUE,
    display_name text,
    avatar_url text,
    bio text,
    favorite_categories text[] DEFAULT '{}'::text[],
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.categories (
    id uuid NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
    name text NOT NULL UNIQUE,
    slug text NOT NULL UNIQUE,
    description text,
    created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.fixed_tags (
    id uuid NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
    name text NOT NULL UNIQUE,
    slug text NOT NULL UNIQUE,
    created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.articles (
    id uuid NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
    legacy_id text UNIQUE,
    title text NOT NULL,
    slug text NOT NULL UNIQUE,
    excerpt text NOT NULL,
    content text,
    author_name text NOT NULL DEFAULT 'Editorial Staff'::text,
    author_role text NOT NULL DEFAULT 'Writer'::text,
    author_avatar text,
    author_id uuid REFERENCES public.profiles(id) ON DELETE SET NULL,
    category_id uuid REFERENCES public.categories(id) ON DELETE NO ACTION,
    category_slug text,
    badge text NOT NULL DEFAULT 'NEWS'::text,
    badge_color text NOT NULL DEFAULT '#FFF1C6'::text,
    card_color text NOT NULL DEFAULT '#FFF1C6'::text,
    is_live boolean NOT NULL DEFAULT false,
    hero_image_url text,
    cover_image_url text,
    likes_count integer NOT NULL DEFAULT 0,
    saves_count integer NOT NULL DEFAULT 0,
    star_count integer NOT NULL DEFAULT 0 CHECK (star_count >= 0),
    reading_time_minutes integer NOT NULL DEFAULT 3 CHECK (reading_time_minutes > 0),
    status text NOT NULL DEFAULT 'draft'::text CHECK (status IN ('draft', 'published')),
    tags text[] NOT NULL DEFAULT '{}'::text[],
    published_at timestamptz,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.article_stars (
    user_id uuid NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    article_id uuid NOT NULL REFERENCES public.articles(id) ON DELETE CASCADE,
    created_at timestamptz NOT NULL DEFAULT now(),
    PRIMARY KEY (user_id, article_id)
);

CREATE TABLE IF NOT EXISTS public.article_likes (
    user_id uuid NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    article_id uuid NOT NULL REFERENCES public.articles(id) ON DELETE CASCADE,
    created_at timestamptz NOT NULL DEFAULT now(),
    PRIMARY KEY (user_id, article_id)
);

CREATE TABLE IF NOT EXISTS public.saved_articles (
    user_id uuid NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    article_id uuid NOT NULL REFERENCES public.articles(id) ON DELETE CASCADE,
    created_at timestamptz NOT NULL DEFAULT now(),
    PRIMARY KEY (user_id, article_id)
);

CREATE TABLE IF NOT EXISTS public.profile_favorite_categories (
    user_id uuid NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    category_id uuid NOT NULL REFERENCES public.categories(id) ON DELETE CASCADE,
    created_at timestamptz NOT NULL DEFAULT now(),
    PRIMARY KEY (user_id, category_id)
);

CREATE TABLE IF NOT EXISTS public.author_follows (
    follower_id uuid NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    author_id uuid NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    created_at timestamptz NOT NULL DEFAULT now(),
    PRIMARY KEY (follower_id, author_id),
    CONSTRAINT author_follows_no_self_follow CHECK (follower_id <> author_id)
);

CREATE INDEX IF NOT EXISTS profiles_username_idx ON public.profiles USING btree (username);
CREATE INDEX IF NOT EXISTS categories_slug_idx ON public.categories USING btree (slug);
CREATE INDEX IF NOT EXISTS articles_author_id_idx ON public.articles USING btree (author_id);
CREATE INDEX IF NOT EXISTS articles_category_id_idx ON public.articles USING btree (category_id);
CREATE INDEX IF NOT EXISTS articles_category_slug_idx ON public.articles USING btree (category_slug);
CREATE INDEX IF NOT EXISTS articles_badge_idx ON public.articles USING btree (badge);
CREATE INDEX IF NOT EXISTS articles_created_at_idx ON public.articles USING btree (created_at DESC);
CREATE INDEX IF NOT EXISTS articles_legacy_id_idx ON public.articles USING btree (legacy_id);
CREATE INDEX IF NOT EXISTS article_stars_article_id_idx ON public.article_stars USING btree (article_id);
CREATE INDEX IF NOT EXISTS article_likes_user_id_idx ON public.article_likes USING btree (user_id);
CREATE INDEX IF NOT EXISTS article_likes_article_id_idx ON public.article_likes USING btree (article_id);
CREATE INDEX IF NOT EXISTS saved_articles_user_id_idx ON public.saved_articles USING btree (user_id);
CREATE INDEX IF NOT EXISTS saved_articles_article_id_idx ON public.saved_articles USING btree (article_id);
CREATE INDEX IF NOT EXISTS profile_favorite_categories_category_id_idx ON public.profile_favorite_categories USING btree (category_id);
CREATE INDEX IF NOT EXISTS author_follows_follower_id_idx ON public.author_follows USING btree (follower_id);
CREATE INDEX IF NOT EXISTS author_follows_author_id_idx ON public.author_follows USING btree (author_id);

DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

DROP TRIGGER IF EXISTS on_article_lifecycle ON public.articles;
CREATE TRIGGER on_article_lifecycle
    BEFORE INSERT OR UPDATE ON public.articles
    FOR EACH ROW EXECUTE FUNCTION public.handle_article_lifecycle();

DROP TRIGGER IF EXISTS on_article_delete_lock ON public.articles;
CREATE TRIGGER on_article_delete_lock
    BEFORE DELETE ON public.articles
    FOR EACH ROW EXECUTE FUNCTION public.handle_article_delete();

DROP TRIGGER IF EXISTS on_article_check_tags ON public.articles;
CREATE TRIGGER on_article_check_tags
    BEFORE INSERT OR UPDATE OF status, tags ON public.articles
    FOR EACH ROW EXECUTE FUNCTION public.check_article_tags();

DROP TRIGGER IF EXISTS on_article_star_changed ON public.article_stars;
CREATE TRIGGER on_article_star_changed
    AFTER INSERT OR DELETE ON public.article_stars
    FOR EACH ROW EXECUTE FUNCTION public.handle_article_star_change();

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.fixed_tags ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.articles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.article_stars ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.article_likes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.saved_articles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.profile_favorite_categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.author_follows ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS profiles_select_public ON public.profiles;
CREATE POLICY profiles_select_public ON public.profiles
    FOR SELECT TO public USING (true);

DROP POLICY IF EXISTS profiles_insert_own ON public.profiles;
CREATE POLICY profiles_insert_own ON public.profiles
    FOR INSERT TO public WITH CHECK ((SELECT auth.uid()) = id);

DROP POLICY IF EXISTS profiles_update_own ON public.profiles;
CREATE POLICY profiles_update_own ON public.profiles
    FOR UPDATE TO public USING ((SELECT auth.uid()) = id);

DROP POLICY IF EXISTS categories_select_public ON public.categories;
CREATE POLICY categories_select_public ON public.categories
    FOR SELECT TO public USING (true);

DROP POLICY IF EXISTS fixed_tags_read_all ON public.fixed_tags;
CREATE POLICY fixed_tags_read_all ON public.fixed_tags
    FOR SELECT TO public USING (true);

DROP POLICY IF EXISTS articles_select_public ON public.articles;
CREATE POLICY articles_select_public ON public.articles
    FOR SELECT TO public USING ((status = 'published') OR ((SELECT auth.uid()) = author_id));

DROP POLICY IF EXISTS articles_insert_author ON public.articles;
CREATE POLICY articles_insert_author ON public.articles
    FOR INSERT TO public WITH CHECK ((SELECT auth.uid()) = author_id);

DROP POLICY IF EXISTS articles_update_author ON public.articles;
CREATE POLICY articles_update_author ON public.articles
    FOR UPDATE TO public
    USING (((SELECT auth.uid()) = author_id) AND (status = 'draft' OR (status = 'published' AND published_at <= now() AND (now() - published_at) <= interval '30 days')))
    WITH CHECK ((SELECT auth.uid()) = author_id);

DROP POLICY IF EXISTS articles_delete_author ON public.articles;
CREATE POLICY articles_delete_author ON public.articles
    FOR DELETE TO public
    USING (((SELECT auth.uid()) = author_id) AND (status = 'draft' OR (status = 'published' AND published_at <= now() AND (now() - published_at) <= interval '30 days')));

DROP POLICY IF EXISTS article_stars_select ON public.article_stars;
CREATE POLICY article_stars_select ON public.article_stars
    FOR SELECT TO public USING (true);

DROP POLICY IF EXISTS article_stars_insert ON public.article_stars;
CREATE POLICY article_stars_insert ON public.article_stars
    FOR INSERT TO public WITH CHECK ((SELECT auth.uid()) = user_id);

DROP POLICY IF EXISTS article_stars_delete ON public.article_stars;
CREATE POLICY article_stars_delete ON public.article_stars
    FOR DELETE TO public USING ((SELECT auth.uid()) = user_id);

DROP POLICY IF EXISTS article_likes_select_public ON public.article_likes;
CREATE POLICY article_likes_select_public ON public.article_likes
    FOR SELECT TO public USING (true);

DROP POLICY IF EXISTS article_likes_insert_own ON public.article_likes;
CREATE POLICY article_likes_insert_own ON public.article_likes
    FOR INSERT TO public WITH CHECK ((SELECT auth.uid()) = user_id);

DROP POLICY IF EXISTS article_likes_delete_own ON public.article_likes;
CREATE POLICY article_likes_delete_own ON public.article_likes
    FOR DELETE TO public USING ((SELECT auth.uid()) = user_id);

DROP POLICY IF EXISTS saved_articles_select_own ON public.saved_articles;
CREATE POLICY saved_articles_select_own ON public.saved_articles
    FOR SELECT TO public USING ((SELECT auth.uid()) = user_id);

DROP POLICY IF EXISTS saved_articles_insert_own ON public.saved_articles;
CREATE POLICY saved_articles_insert_own ON public.saved_articles
    FOR INSERT TO public WITH CHECK ((SELECT auth.uid()) = user_id);

DROP POLICY IF EXISTS saved_articles_delete_own ON public.saved_articles;
CREATE POLICY saved_articles_delete_own ON public.saved_articles
    FOR DELETE TO public USING ((SELECT auth.uid()) = user_id);

DROP POLICY IF EXISTS profile_favorites_select ON public.profile_favorite_categories;
CREATE POLICY profile_favorites_select ON public.profile_favorite_categories
    FOR SELECT TO public USING ((SELECT auth.uid()) = user_id);

DROP POLICY IF EXISTS profile_favorites_insert ON public.profile_favorite_categories;
CREATE POLICY profile_favorites_insert ON public.profile_favorite_categories
    FOR INSERT TO public WITH CHECK ((SELECT auth.uid()) = user_id);

DROP POLICY IF EXISTS profile_favorites_delete ON public.profile_favorite_categories;
CREATE POLICY profile_favorites_delete ON public.profile_favorite_categories
    FOR DELETE TO public USING ((SELECT auth.uid()) = user_id);

DROP POLICY IF EXISTS author_follows_select_public ON public.author_follows;
CREATE POLICY author_follows_select_public ON public.author_follows
    FOR SELECT TO public USING (true);

DROP POLICY IF EXISTS author_follows_insert_own ON public.author_follows;
CREATE POLICY author_follows_insert_own ON public.author_follows
    FOR INSERT TO public WITH CHECK ((SELECT auth.uid()) = follower_id);

DROP POLICY IF EXISTS author_follows_delete_own ON public.author_follows;
CREATE POLICY author_follows_delete_own ON public.author_follows
    FOR DELETE TO public USING ((SELECT auth.uid()) = follower_id);

GRANT USAGE ON SCHEMA public TO anon, authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO authenticated;
GRANT SELECT ON public.categories, public.fixed_tags, public.articles, public.article_stars, public.article_likes, public.profiles, public.author_follows TO anon;
