CREATE OR REPLACE FUNCTION public.set_user_favorite_categories(p_category_ids uuid[])
RETURNS void
LANGUAGE plpgsql
SECURITY INVOKER
SET search_path = ''
AS $$
DECLARE
    v_user_id uuid;
BEGIN
    v_user_id := auth.uid();
    IF v_user_id IS NULL THEN
        RAISE EXCEPTION 'Not authenticated';
    END IF;

    IF p_category_ids IS NULL OR array_length(p_category_ids, 1) IS NULL THEN
        DELETE FROM public.profile_favorite_categories
        WHERE user_id = v_user_id;
    ELSE
        DELETE FROM public.profile_favorite_categories
        WHERE user_id = v_user_id
          AND category_id != ALL(p_category_ids);

        INSERT INTO public.profile_favorite_categories (user_id, category_id)
        SELECT DISTINCT v_user_id, unnest(p_category_ids)
        ON CONFLICT (user_id, category_id) DO NOTHING;
    END IF;
END;
$$;

REVOKE ALL ON FUNCTION public.set_user_favorite_categories(uuid[]) FROM PUBLIC, anon, service_role;
GRANT EXECUTE ON FUNCTION public.set_user_favorite_categories(uuid[]) TO authenticated;
