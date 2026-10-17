alter table public.profiles
  add column if not exists rating_avg numeric(3,2) not null default 0.00,
  add column if not exists rating_count integer not null default 0;

alter table public.articles
  add column if not exists author_rating_avg numeric(3,2) not null default 0.00,
  add column if not exists author_rating_count integer not null default 0;

create table if not exists public.author_ratings (
  user_id uuid not null references public.profiles(id) on delete cascade,
  author_key text not null,
  author_id uuid references public.profiles(id) on delete set null,
  author_name text not null default 'Editorial Staff',
  stars integer not null check (stars >= 1 and stars <= 5),
  created_at timestamptz not null default pg_catalog.now(),
  updated_at timestamptz not null default pg_catalog.now(),
  primary key (user_id, author_key)
);

create index if not exists idx_author_ratings_author_key on public.author_ratings(author_key);
create index if not exists idx_author_ratings_author_id on public.author_ratings(author_id);

alter table public.author_ratings enable row level security;

do $$
begin
  if not exists (
    select 1 from pg_policies
    where schemaname = 'public' and tablename = 'author_ratings' and policyname = 'author_ratings_select_public'
  ) then
    create policy author_ratings_select_public on public.author_ratings
      for select using (true);
  end if;

  if not exists (
    select 1 from pg_policies
    where schemaname = 'public' and tablename = 'author_ratings' and policyname = 'author_ratings_insert_own'
  ) then
    create policy author_ratings_insert_own on public.author_ratings
      for insert with check ((select auth.uid()) = user_id);
  end if;

  if not exists (
    select 1 from pg_policies
    where schemaname = 'public' and tablename = 'author_ratings' and policyname = 'author_ratings_update_own'
  ) then
    create policy author_ratings_update_own on public.author_ratings
      for update using ((select auth.uid()) = user_id)
      with check ((select auth.uid()) = user_id);
  end if;

  if not exists (
    select 1 from pg_policies
    where schemaname = 'public' and tablename = 'author_ratings' and policyname = 'author_ratings_delete_own'
  ) then
    create policy author_ratings_delete_own on public.author_ratings
      for delete using ((select auth.uid()) = user_id);
  end if;
end;
$$;

create or replace trigger on_author_rating_ensure_profile
before insert on public.author_ratings
for each row execute function public.handle_saved_or_starred_user_profile();

create or replace trigger on_article_like_ensure_profile
before insert on public.article_likes
for each row execute function public.handle_saved_or_starred_user_profile();

create or replace function public.handle_article_like_change()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  if TG_OP = 'INSERT' then
    update public.articles
    set likes_count = likes_count + 1
    where id = NEW.article_id;
    return NEW;
  elsif TG_OP = 'DELETE' then
    update public.articles
    set likes_count = greatest(0, likes_count - 1)
    where id = OLD.article_id;
    return OLD;
  end if;
  return null;
end;
$$;

create or replace trigger on_article_like_changed
after insert or delete on public.article_likes
for each row execute function public.handle_article_like_change();

create or replace function public.handle_author_rating_change()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_key text;
  v_author_id uuid;
  v_avg numeric(3,2);
  v_cnt integer;
begin
  if TG_OP = 'DELETE' then
    v_key := OLD.author_key;
    v_author_id := OLD.author_id;
  else
    v_key := NEW.author_key;
    v_author_id := NEW.author_id;
  end if;

  select
    coalesce(pg_catalog.round(pg_catalog.avg(stars)::numeric, 2), 0.00)::numeric(3,2),
    pg_catalog.count(*)::integer
  into v_avg, v_cnt
  from public.author_ratings
  where author_key = v_key;

  update public.articles
  set
    author_rating_avg = v_avg,
    author_rating_count = v_cnt
  where coalesce(author_id::text, pg_catalog.lower(pg_catalog.btrim(author_name))) = v_key;

  if v_author_id is not null then
    update public.profiles
    set
      rating_avg = v_avg,
      rating_count = v_cnt
    where id = v_author_id;
  end if;

  if TG_OP = 'DELETE' then
    return OLD;
  end if;
  return NEW;
end;
$$;

create or replace trigger on_author_rating_changed
after insert or update or delete on public.author_ratings
for each row execute function public.handle_author_rating_change();

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
  v_author_key text;
  v_avg numeric(3,2);
  v_cnt integer;
begin
  if TG_OP = 'INSERT' then
    if pg_catalog.pg_trigger_depth() <= 1 and coalesce(NEW.star_count, 0) <> 0 then
      raise exception 'Direct modification of star_count is not allowed';
    end if;
    NEW.star_count := 0;
    NEW.saves_count := coalesce(NEW.saves_count, 0);
    NEW.likes_count := coalesce(NEW.likes_count, 0);

    if NEW.author_id is null and auth.uid() is not null then
      NEW.author_id := auth.uid();
    end if;

    if NEW.author_id is not null then
      perform public.ensure_user_profile_exists(NEW.author_id, coalesce(NEW.author_name, 'Writer'));
    end if;

    v_author_key := coalesce(NEW.author_id::text, pg_catalog.lower(pg_catalog.btrim(coalesce(NEW.author_name, 'Editorial Staff'))));
    select
      coalesce(pg_catalog.round(pg_catalog.avg(stars)::numeric, 2), 0.00)::numeric(3,2),
      pg_catalog.count(*)::integer
    into v_avg, v_cnt
    from public.author_ratings
    where author_key = v_author_key;

    NEW.author_rating_avg := coalesce(v_avg, 0.00);
    NEW.author_rating_count := coalesce(v_cnt, 0);

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

    if pg_catalog.pg_trigger_depth() > 1 and (
      NEW.saves_count is distinct from OLD.saves_count or
      NEW.likes_count is distinct from OLD.likes_count or
      NEW.author_rating_avg is distinct from OLD.author_rating_avg or
      NEW.author_rating_count is distinct from OLD.author_rating_count
    ) then
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
    NEW.reading_time_minutes := greatest(1, pg_catalog.ceil(content_word_count / 200.0)::integer);
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

create or replace function public.rate_author(
  p_author_key text,
  p_stars integer,
  p_author_id uuid default null,
  p_author_name text default 'Editorial Staff'
)
returns jsonb
language plpgsql
security invoker
set search_path = ''
as $$
declare
  v_user_id uuid;
  v_norm_key text;
  v_avg numeric(3,2);
  v_cnt integer;
begin
  v_user_id := auth.uid();
  if v_user_id is null then
    raise exception 'Authentication required to rate an author';
  end if;

  if p_stars < 1 or p_stars > 5 then
    raise exception 'Author star rating must be between 1 and 5';
  end if;

  v_norm_key := coalesce(
    p_author_id::text,
    nullif(pg_catalog.lower(pg_catalog.btrim(coalesce(p_author_key, ''))), ''),
    pg_catalog.lower(pg_catalog.btrim(coalesce(p_author_name, 'editorial staff')))
  );

  perform public.ensure_user_profile_exists(v_user_id, 'Reader');

  insert into public.author_ratings (user_id, author_key, author_id, author_name, stars, updated_at)
  values (
    v_user_id,
    v_norm_key,
    p_author_id,
    coalesce(nullif(pg_catalog.btrim(p_author_name), ''), 'Editorial Staff'),
    p_stars,
    pg_catalog.clock_timestamp()
  )
  on conflict (user_id, author_key) do update
  set
    stars = excluded.stars,
    author_id = coalesce(excluded.author_id, public.author_ratings.author_id),
    author_name = excluded.author_name,
    updated_at = pg_catalog.clock_timestamp();

  select
    coalesce(pg_catalog.round(pg_catalog.avg(stars)::numeric, 2), 0.00)::numeric(3,2),
    pg_catalog.count(*)::integer
  into v_avg, v_cnt
  from public.author_ratings
  where author_key = v_norm_key;

  return pg_catalog.jsonb_build_object(
    'author_key', v_norm_key,
    'user_stars', p_stars,
    'rating_avg', v_avg,
    'rating_count', v_cnt
  );
end;
$$;

create or replace function public.get_author_rating_summary(
  p_author_key text,
  p_author_id uuid default null,
  p_author_name text default 'Editorial Staff'
)
returns jsonb
language plpgsql
security invoker
set search_path = ''
as $$
declare
  v_user_id uuid;
  v_norm_key text;
  v_user_stars integer;
  v_avg numeric(3,2);
  v_cnt integer;
begin
  v_user_id := auth.uid();
  v_norm_key := coalesce(
    p_author_id::text,
    nullif(pg_catalog.lower(pg_catalog.btrim(coalesce(p_author_key, ''))), ''),
    pg_catalog.lower(pg_catalog.btrim(coalesce(p_author_name, 'editorial staff')))
  );

  select
    coalesce(pg_catalog.round(pg_catalog.avg(stars)::numeric, 2), 0.00)::numeric(3,2),
    pg_catalog.count(*)::integer
  into v_avg, v_cnt
  from public.author_ratings
  where author_key = v_norm_key;

  if v_user_id is not null then
    select stars into v_user_stars
    from public.author_ratings
    where user_id = v_user_id and author_key = v_norm_key;
  end if;

  return pg_catalog.jsonb_build_object(
    'author_key', v_norm_key,
    'user_stars', coalesce(v_user_stars, 0),
    'rating_avg', coalesce(v_avg, 0.00),
    'rating_count', coalesce(v_cnt, 0)
  );
end;
$$;

grant execute on function public.rate_author(text, integer, uuid, text) to authenticated;
grant execute on function public.get_author_rating_summary(text, uuid, text) to anon, authenticated;

update public.articles a
set likes_count = (
  select pg_catalog.count(*)::integer
  from public.article_likes l
  where l.article_id = a.id
);
