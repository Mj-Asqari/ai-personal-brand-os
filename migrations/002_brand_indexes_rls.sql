-- 002_brand_indexes_rls
-- Indexes, updated_at trigger, and RLS on every brand table.

create index on brand.experiences (kind);
create index on brand.experiences (confidentiality_level);
create index on brand.ideas (score_total desc);
create index on brand.drafts (status);
create index on brand.drafts (brief_id);
create index on brand.reviews (draft_id);
create index on brand.reviews (experience_score);
create index on brand.publications (published_at desc);
create index on brand.metrics (captured_at desc);
create index on brand.workflow_runs (flow_name, created_at desc);
create index on brand.workflow_runs (status);

create or replace function brand.touch_updated_at()
returns trigger language plpgsql as $$
begin new.updated_at = now(); return new; end $$;

do $$
declare t text;
begin
  for t in select tablename from pg_tables where schemaname='brand'
  loop
    execute format(
      'create trigger trg_touch before update on brand.%I
       for each row execute function brand.touch_updated_at()', t);
    execute format('alter table brand.%I enable row level security', t);
    execute format(
      'create policy authenticated_all on brand.%I
       for all to authenticated using (true) with check (true)', t);
  end loop;
end $$;
