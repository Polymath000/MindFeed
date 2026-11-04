-- Migration: 20261101114500_support_custom_tags_and_auto_catalog.sql
-- Purpose: Enable authenticated users to insert new custom tags and auto-catalog tags upon publishing.

-- 1. Allow authenticated users to insert new tags into fixed_tags
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies 
    WHERE tablename = 'fixed_tags' AND policyname = 'fixed_tags_insert_authenticated'
  ) THEN
    CREATE POLICY fixed_tags_insert_authenticated ON public.fixed_tags
      FOR INSERT TO authenticated
      WITH CHECK (true);
  END IF;
END $$;

GRANT INSERT ON public.fixed_tags TO authenticated;

-- 2. Update check_article_tags trigger function to automatically catalog custom tags into fixed_tags
CREATE OR REPLACE FUNCTION public.check_article_tags()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
DECLARE
  tag_count integer;
  unique_count integer;
BEGIN
  if NEW.tags is null then
    if NEW.status = 'published' then
      raise exception 'Published articles must have between 1 and 5 tags';
    end if;
    NEW.tags := '{}'::text[];
  end if;

  if NEW.status = 'published' then
    tag_count := coalesce(pg_catalog.array_length(NEW.tags, 1), 0);
    if tag_count < 1 or tag_count > 5 then
      raise exception 'Published articles must have between 1 and 5 tags';
    end if;

    select pg_catalog.count(distinct pg_catalog.lower(t)) into unique_count
    from pg_catalog.unnest(NEW.tags) as t;
    if unique_count <> tag_count then
      raise exception 'Article tags must be unique';
    end if;

    -- Automatically catalog any new custom tags into fixed_tags
    INSERT INTO public.fixed_tags (name, slug)
    SELECT DISTINCT t, pg_catalog.lower(pg_catalog.regexp_replace(t, '[^a-zA-Z0-9]+', '-', 'g'))
    FROM pg_catalog.unnest(NEW.tags) as t
    WHERE NOT EXISTS (
      SELECT 1 FROM public.fixed_tags ft
      WHERE pg_catalog.lower(ft.name) = pg_catalog.lower(t) or pg_catalog.lower(ft.slug) = pg_catalog.lower(t)
    )
    ON CONFLICT (name) DO NOTHING;
  end if;

  RETURN NEW;
END;
$$;
