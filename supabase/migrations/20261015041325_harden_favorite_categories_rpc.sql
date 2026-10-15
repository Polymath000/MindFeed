REVOKE EXECUTE ON FUNCTION public.set_user_favorite_categories(uuid[]) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.set_user_favorite_categories(uuid[]) TO authenticated, service_role;
