-- Ensure public buckets exist for avatars and article-media
insert into storage.buckets (id, name, public)
values
  ('avatars', 'avatars', true),
  ('article-media', 'article-media', true)
on conflict (id) do update
set public = true;

-- Public read access for avatars and article-media
drop policy if exists "storage_public_select_avatars_and_article_media" on storage.objects;
create policy "storage_public_select_avatars_and_article_media"
on storage.objects
for select
to public
using (bucket_id in ('avatars', 'article-media'));

-- Authenticated users can upload objects into their own user folder in avatars and article-media
drop policy if exists "storage_authenticated_insert_own_folder" on storage.objects;
create policy "storage_authenticated_insert_own_folder"
on storage.objects
for insert
to authenticated
with check (
  bucket_id in ('avatars', 'article-media')
  and (storage.foldername(name))[1] = (select auth.uid()::text)
);

-- Authenticated users can update objects inside their own user folder
drop policy if exists "storage_authenticated_update_own_folder" on storage.objects;
create policy "storage_authenticated_update_own_folder"
on storage.objects
for update
to authenticated
using (
  bucket_id in ('avatars', 'article-media')
  and (storage.foldername(name))[1] = (select auth.uid()::text)
)
with check (
  bucket_id in ('avatars', 'article-media')
  and (storage.foldername(name))[1] = (select auth.uid()::text)
);

-- Authenticated users can delete their own uploaded objects (never defaultAvatar.png)
drop policy if exists "storage_authenticated_delete_own_folder" on storage.objects;
create policy "storage_authenticated_delete_own_folder"
on storage.objects
for delete
to authenticated
using (
  bucket_id in ('avatars', 'article-media')
  and name <> 'defaultAvatar.png'
  and (storage.foldername(name))[1] = (select auth.uid()::text)
);
