-- Migration: 20261102123000_support_author_key_follows_and_rls.sql
-- Purpose:
--   1. Allow following both registered user profiles (UUID author_id) and
--      seeded editorial columnists (canonical author_key) in public.author_follows,
--      matching public.author_ratings.
--   2. Ensure the follower's profile row exists before insert and add an UPDATE
--      RLS policy so PostgREST upsert operations never fail with RLS 42501.

ALTER TABLE public.author_follows
  ADD COLUMN IF NOT EXISTS author_key text,
  ADD COLUMN IF NOT EXISTS author_name text NOT NULL DEFAULT 'Editorial Staff';

UPDATE public.author_follows
SET author_key = COALESCE(
  NULLIF(pg_catalog.lower(pg_catalog.btrim(author_key)), ''),
  pg_catalog.lower(author_id::text)
)
WHERE author_key IS NULL OR pg_catalog.btrim(author_key) = '';

ALTER TABLE public.author_follows
  DROP CONSTRAINT IF EXISTS author_follows_pkey;

ALTER TABLE public.author_follows
  ALTER COLUMN author_id DROP NOT NULL,
  ALTER COLUMN author_key SET NOT NULL;

ALTER TABLE public.author_follows
  ADD CONSTRAINT author_follows_pkey PRIMARY KEY (follower_id, author_key);

ALTER TABLE public.author_follows
  DROP CONSTRAINT IF EXISTS author_follows_no_self_follow;

ALTER TABLE public.author_follows
  ADD CONSTRAINT author_follows_no_self_follow CHECK (
    (author_id IS NULL OR follower_id <> author_id)
    AND pg_catalog.lower(pg_catalog.btrim(author_key)) <> pg_catalog.lower(follower_id::text)
  );

CREATE INDEX IF NOT EXISTS author_follows_author_key_idx
  ON public.author_follows USING btree (author_key);

CREATE OR REPLACE FUNCTION public.handle_author_follow_before_write()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
BEGIN
  PERFORM public.ensure_user_profile_exists(NEW.follower_id, 'Reader');

  IF NEW.author_id IS NOT NULL THEN
    NEW.author_key := pg_catalog.lower(NEW.author_id::text);
  ELSE
    NEW.author_key := pg_catalog.lower(
      pg_catalog.btrim(
        COALESCE(NULLIF(pg_catalog.btrim(NEW.author_key), ''), NEW.author_name, '')
      )
    );
  END IF;

  IF NEW.author_key IS NULL OR NEW.author_key = '' THEN
    RAISE EXCEPTION 'author_key or author_id is required to follow an author';
  END IF;

  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS on_author_follow_before_write ON public.author_follows;
CREATE TRIGGER on_author_follow_before_write
  BEFORE INSERT OR UPDATE ON public.author_follows
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_author_follow_before_write();

DROP POLICY IF EXISTS author_follows_select_public ON public.author_follows;
CREATE POLICY author_follows_select_public ON public.author_follows
  FOR SELECT TO public USING (true);

DROP POLICY IF EXISTS author_follows_insert_own ON public.author_follows;
CREATE POLICY author_follows_insert_own ON public.author_follows
  FOR INSERT TO public WITH CHECK ((SELECT auth.uid()) = follower_id);

DROP POLICY IF EXISTS author_follows_update_own ON public.author_follows;
CREATE POLICY author_follows_update_own ON public.author_follows
  FOR UPDATE TO public
  USING ((SELECT auth.uid()) = follower_id)
  WITH CHECK ((SELECT auth.uid()) = follower_id);

DROP POLICY IF EXISTS author_follows_delete_own ON public.author_follows;
CREATE POLICY author_follows_delete_own ON public.author_follows
  FOR DELETE TO public USING ((SELECT auth.uid()) = follower_id);

GRANT SELECT ON public.author_follows TO anon;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.author_follows TO authenticated;
