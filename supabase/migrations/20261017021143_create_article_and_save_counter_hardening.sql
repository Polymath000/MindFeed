create or replace function public.ensure_user_profile_exists(p_user_id uuid, p_fallback_name text default 'Reader')
returns void
language plpgsql
security definer
set search_path = ''
as $$
begin
  if p_user_id is null then
    return;
  end if;

  insert into public.profiles (id, display_name)
  select
    u.id,
    coalesce(
      nullif(pg_catalog.btrim(u.raw_user_meta_data ->> 'display_name'), ''),
      nullif(pg_catalog.btrim(u.raw_user_meta_data ->> 'user_name'), ''),
      nullif(pg_catalog.btrim(p_fallback_name), ''),
      pg_catalog.split_part(u.email, '@', 1),
      'Reader'
    )
  from auth.users u
  where u.id = p_user_id
  on conflict (id) do nothing;
end;
$$;

create or replace function public.handle_article_save_change()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  if TG_OP = 'INSERT' then
    update public.articles
    set saves_count = saves_count + 1
    where id = NEW.article_id;
    return NEW;
  elsif TG_OP = 'DELETE' then
    update public.articles
    set saves_count = pg_catalog.greatest(0, saves_count - 1)
    where id = OLD.article_id;
    return OLD;
  end if;
  return null;
end;
$$;

create or replace trigger on_article_save_changed
after insert or delete on public.saved_articles
for each row execute function public.handle_article_save_change();

create or replace function public.handle_saved_or_starred_user_profile()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  perform public.ensure_user_profile_exists(NEW.user_id, 'Reader');
  return NEW;
end;
$$;

create or replace trigger on_saved_article_ensure_profile
before insert on public.saved_articles
for each row execute function public.handle_saved_or_starred_user_profile();

create or replace trigger on_article_star_ensure_profile
before insert on public.article_stars
for each row execute function public.handle_saved_or_starred_user_profile();

create or replace function public.handle_article_lifecycle()
returns trigger
language plpgsql
set search_path = ''
as $$
declare
  title_word_count integer;
  content_word_count integer;
  resolved_cat_slug text;
  resolved_cat_name text;
  clean_excerpt text;
  base_slug text;
begin
  if TG_OP = 'INSERT' then
    if pg_catalog.pg_trigger_depth() <= 1 and coalesce(NEW.star_count, 0) <> 0 then
      raise exception 'Direct modification of star_count is not allowed';
    end if;
    NEW.star_count := 0;
    NEW.saves_count := coalesce(NEW.saves_count, 0);

    if NEW.author_id is null and auth.uid() is not null then
      NEW.author_id := auth.uid();
    end if;

    if NEW.author_id is not null then
      perform public.ensure_user_profile_exists(NEW.author_id, coalesce(NEW.author_name, 'Writer'));
    end if;

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

    if NEW.saves_count is distinct from OLD.saves_count and pg_catalog.pg_trigger_depth() > 1 then
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

  if NEW.category_id is not null then
    select c.slug, c.name
    into resolved_cat_slug, resolved_cat_name
    from public.categories c
    where c.id = NEW.category_id;

    if resolved_cat_slug is not null and (NEW.category_slug is null or pg_catalog.btrim(NEW.category_slug) = '') then
      NEW.category_slug := resolved_cat_slug;
    end if;

    if resolved_cat_name is not null and (NEW.badge is null or pg_catalog.btrim(NEW.badge) = '' or NEW.badge = 'NEWS') then
      NEW.badge := pg_catalog.upper(resolved_cat_name);
    end if;
  end if;

  if NEW.slug is null or pg_catalog.btrim(NEW.slug) = '' then
    base_slug := pg_catalog.regexp_replace(
      pg_catalog.lower(coalesce(NEW.title, 'article')),
      '[^a-z0-9]+',
      '-',
      'g'
    );
    base_slug := pg_catalog.btrim(base_slug, '-');
    if base_slug = '' then
      base_slug := 'article';
    end if;
    NEW.slug := base_slug || '-' || (pg_catalog.date_part('epoch', pg_catalog.clock_timestamp()) * 1000)::bigint::text;
  end if;

  content_word_count := coalesce(
    pg_catalog.array_length(
      pg_catalog.regexp_split_to_array(nullif(pg_catalog.btrim(coalesce(NEW.content, '')), ''), '\s+'),
      1
    ),
    0
  );

  if NEW.reading_time_minutes is null or NEW.reading_time_minutes <= 0 then
    NEW.reading_time_minutes := pg_catalog.greatest(1, pg_catalog.ceil(content_word_count / 200.0)::integer);
  end if;

  if NEW.excerpt is null or pg_catalog.btrim(NEW.excerpt) = '' then
    clean_excerpt := pg_catalog.btrim(
      pg_catalog.regexp_replace(
        pg_catalog.regexp_replace(coalesce(NEW.content, ''), '[#*`_~\[\]]', '', 'g'),
        '\s+',
        ' ',
        'g'
      )
    );
    if clean_excerpt = '' then
      NEW.excerpt := 'Draft excerpt';
    else
      NEW.excerpt := pg_catalog.left(clean_excerpt, 160);
    end if;
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

create or replace function public.create_article(
  p_title text,
  p_content text default '',
  p_category_id uuid default null,
  p_cover_image_url text default null,
  p_tags text[] default '{}'::text[],
  p_status text default 'draft',
  p_excerpt text default null,
  p_slug text default null,
  p_author_name text default null,
  p_reading_time_minutes integer default null
)
returns public.articles
language plpgsql
security invoker
set search_path = ''
as $$
declare
  v_user_id uuid;
  v_author_name text;
  v_article public.articles;
begin
  v_user_id := auth.uid();
  if v_user_id is null then
    raise exception 'Authentication required to create an article';
  end if;

  perform public.ensure_user_profile_exists(v_user_id, coalesce(p_author_name, 'Writer'));

  select coalesce(
    nullif(pg_catalog.btrim(p_author_name), ''),
    nullif(pg_catalog.btrim(p.display_name), ''),
    'Editorial Staff'
  )
  into v_author_name
  from public.profiles p
  where p.id = v_user_id;

  insert into public.articles (
    title,
    slug,
    excerpt,
    content,
    author_id,
    author_name,
    category_id,
    cover_image_url,
    tags,
    status,
    reading_time_minutes
  )
  values (
    pg_catalog.btrim(coalesce(p_title, '')),
    p_slug,
    p_excerpt,
    coalesce(p_content, ''),
    v_user_id,
    coalesce(v_author_name, 'Editorial Staff'),
    p_category_id,
    nullif(pg_catalog.btrim(coalesce(p_cover_image_url, '')), ''),
    coalesce(p_tags, '{}'::text[]),
    coalesce(p_status, 'draft'),
    p_reading_time_minutes
  )
  returning * into v_article;

  return v_article;
end;
$$;

grant execute on function public.create_article(text, text, uuid, text, text[], text, text, text, text, integer) to authenticated;

update public.articles a
set saves_count = (
  select pg_catalog.count(*)::integer
  from public.saved_articles s
  where s.article_id = a.id
);
