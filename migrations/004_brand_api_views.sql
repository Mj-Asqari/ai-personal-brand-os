-- 004_brand_api_views
-- PostgREST-facing views. ActivePieces writes here; data lands in brand.*
-- security_invoker keeps RLS semantics of the underlying table.

create or replace view public.brand_experiences
  with (security_invoker = true) as
  select * from brand.experiences;

create or replace view public.brand_projects
  with (security_invoker = true) as
  select * from brand.projects;

create or replace view public.brand_sources
  with (security_invoker = true) as
  select * from brand.sources;

create or replace view public.brand_ideas
  with (security_invoker = true) as
  select * from brand.ideas;

create or replace view public.brand_content_briefs
  with (security_invoker = true) as
  select * from brand.content_briefs;

create or replace view public.brand_drafts
  with (security_invoker = true) as
  select * from brand.drafts;

create or replace view public.brand_reviews
  with (security_invoker = true) as
  select * from brand.reviews;

create or replace view public.brand_publications
  with (security_invoker = true) as
  select * from brand.publications;

create or replace view public.brand_metrics
  with (security_invoker = true) as
  select * from brand.metrics;

create or replace view public.brand_prompt_versions
  with (security_invoker = true) as
  select * from brand.prompt_versions;

create or replace view public.brand_workflow_runs
  with (security_invoker = true) as
  select * from brand.workflow_runs;

-- generated columns (score_total, experience_score) are not insertable through a view
grant select, insert, update, delete on
  public.brand_experiences, public.brand_projects, public.brand_sources,
  public.brand_ideas, public.brand_content_briefs, public.brand_drafts,
  public.brand_reviews, public.brand_publications, public.brand_metrics,
  public.brand_prompt_versions, public.brand_workflow_runs
to service_role;

grant usage on schema brand to service_role, authenticated;
