REVOKE CREATE ON SCHEMA public FROM PUBLIC, anon, authenticated;

CREATE OR REPLACE FUNCTION public.check_article_tags()
RETURNS trigger
LANGUAGE plpgsql
SET search_path = ''
AS $$
declare
  tag_count integer;
  unique_count integer;
  invalid_tag_count integer;
begin
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

    select pg_catalog.count(distinct t) into unique_count
    from pg_catalog.unnest(NEW.tags) as t
    where t is not null;

    if unique_count <> tag_count then
      raise exception 'Article tags must be unique';
    end if;

    select pg_catalog.count(*) into invalid_tag_count
    from pg_catalog.unnest(NEW.tags) as t
    where t is null or not exists (
      select 1 from public.fixed_tags ft
      where ft.name = t or ft.slug = t
    );

    if invalid_tag_count > 0 then
      raise exception 'All article tags must belong to the fixed_tags catalog';
    end if;
  end if;

  return NEW;
end;
$$;

CREATE OR REPLACE FUNCTION public.handle_article_lifecycle()
RETURNS trigger
LANGUAGE plpgsql
SET search_path = ''
AS $$
declare
  title_word_count integer;
  content_word_count integer;
begin
  if TG_OP = 'INSERT' then
    if pg_catalog.pg_trigger_depth() <= 1 and coalesce(NEW.star_count, 0) <> 0 then
      raise exception 'Direct modification of star_count is not allowed';
    end if;
    NEW.star_count := 0;

    if NEW.status = 'published' then
      NEW.published_at := coalesce(NEW.published_at, pg_catalog.clock_timestamp());
    else
      NEW.published_at := null;
    end if;
  elsif TG_OP = 'UPDATE' then
    if NEW.star_count is distinct from OLD.star_count then
      if pg_catalog.pg_trigger_depth() <= 1 then
        raise exception 'Direct modification of star_count is not allowed';
      end if;
      return NEW;
    end if;

    if OLD.status = 'draft' and NEW.status = 'published' then
      NEW.published_at := pg_catalog.clock_timestamp();
    elsif OLD.status = 'published' and NEW.status = 'draft' then
      raise exception 'Published articles cannot be reverted to draft';
    end if;

    if OLD.status = 'published' and OLD.published_at is not null and OLD.published_at <= (pg_catalog.now() - interval '30 days') then
      raise exception 'Articles cannot be modified after 30 days of publication';
    end if;

    NEW.updated_at := pg_catalog.clock_timestamp();
  end if;

  if NEW.status = 'published' then
    title_word_count := coalesce(
      pg_catalog.array_length(
        pg_catalog.regexp_split_to_array(nullif(pg_catalog.btrim(coalesce(NEW.title, '')), ''), '\s+'),
        1
      ),
      0
    );
    if title_word_count < 1 or title_word_count > 12 then
      raise exception 'Published article title must be between 1 and 12 words';
    end if;

    content_word_count := coalesce(
      pg_catalog.array_length(
        pg_catalog.regexp_split_to_array(nullif(pg_catalog.btrim(coalesce(NEW.content, '')), ''), '\s+'),
        1
      ),
      0
    );
    if content_word_count < 300 then
      raise exception 'Published article content must be at least 300 words';
    end if;

    if NEW.category_id is null then
      raise exception 'Published articles must specify a valid category_id';
    end if;
  end if;

  return NEW;
end;
$$;

CREATE OR REPLACE FUNCTION public.handle_article_delete()
RETURNS trigger
LANGUAGE plpgsql
SET search_path = ''
AS $$
begin
  if OLD.status = 'published' and OLD.published_at is not null and OLD.published_at <= (pg_catalog.now() - interval '30 days') then
    raise exception 'Articles cannot be deleted after 30 days of publication';
  end if;
  return OLD;
end;
$$;

CREATE OR REPLACE FUNCTION public.handle_article_star_change()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
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
SET search_path = ''
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

CREATE OR REPLACE FUNCTION public.rls_auto_enable()
RETURNS event_trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
DECLARE
  cmd record;
  tbl name;
BEGIN
  FOR cmd IN
    SELECT *
    FROM pg_catalog.pg_event_trigger_ddl_commands()
    WHERE command_tag IN ('CREATE TABLE', 'CREATE TABLE AS', 'SELECT INTO')
      AND object_type IN ('table','partitioned table')
  LOOP
     IF cmd.schema_name IS NOT NULL AND cmd.schema_name IN ('public') AND cmd.schema_name NOT IN ('pg_catalog','information_schema') AND cmd.schema_name NOT LIKE 'pg_toast%' AND cmd.schema_name NOT LIKE 'pg_temp%' THEN
      BEGIN
        SELECT c.relname INTO tbl FROM pg_catalog.pg_class c WHERE c.oid = cmd.objid;
        EXECUTE pg_catalog.format('alter table if exists %I.%I enable row level security', cmd.schema_name, tbl);
        RAISE LOG 'rls_auto_enable: enabled RLS on %', cmd.object_identity;
      EXCEPTION
        WHEN OTHERS THEN
          RAISE LOG 'rls_auto_enable: failed to enable RLS on %', cmd.object_identity;
      END;
     ELSE
        RAISE LOG 'rls_auto_enable: skip % (either system schema or not in enforced list: %.)', cmd.object_identity, cmd.schema_name;
     END IF;
  END LOOP;
END;
$$;

ALTER POLICY articles_update_author ON public.articles
    USING ((SELECT auth.uid()) = author_id)
    WITH CHECK ((SELECT auth.uid()) = author_id);

ALTER POLICY articles_delete_author ON public.articles
    USING ((SELECT auth.uid()) = author_id);
