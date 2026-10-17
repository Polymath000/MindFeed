create or replace function public.handle_profile_rating_protection()
returns trigger
language plpgsql
security invoker
set search_path = ''
as $$
begin
  if TG_OP = 'INSERT' then
    if pg_catalog.pg_trigger_depth() <= 1 then
      if coalesce(NEW.rating_avg, 0.00) <> 0.00 or coalesce(NEW.rating_count, 0) <> 0 then
        raise exception 'Direct modification of profile rating aggregates is not allowed';
      end if;
      NEW.rating_avg := 0.00;
      NEW.rating_count := 0;
    end if;
    return NEW;
  elsif TG_OP = 'UPDATE' then
    if pg_catalog.pg_trigger_depth() <= 1 and (
      NEW.rating_avg is distinct from OLD.rating_avg or
      NEW.rating_count is distinct from OLD.rating_count
    ) then
      raise exception 'Direct modification of profile rating aggregates is not allowed';
    end if;
    return NEW;
  end if;
  return NEW;
end;
$$;
