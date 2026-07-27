-- 005_brand_grants
-- Table privileges are a separate gate from RLS. 002 created policies but no grants.

grant usage on schema brand to service_role, authenticated, anon;

grant select, insert, update, delete
  on all tables in schema brand to service_role;

grant select, insert, update, delete
  on all tables in schema brand to authenticated;

-- anon gets nothing: no grant, and RLS policies exclude it.

alter default privileges in schema brand
  grant select, insert, update, delete on tables to service_role, authenticated;
