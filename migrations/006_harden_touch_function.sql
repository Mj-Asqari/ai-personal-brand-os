-- 006_harden_touch_function
-- Security linter flagged brand.touch_updated_at for a mutable search_path.
-- Pinning it prevents a shadowing schema from hijacking the trigger.

create or replace function brand.touch_updated_at()
returns trigger
language plpgsql
security invoker
set search_path = pg_catalog
as $$
begin
  new.updated_at = now();
  return new;
end $$;
