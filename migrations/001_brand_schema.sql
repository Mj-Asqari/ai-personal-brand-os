-- 001_brand_schema
-- Core Personal Brand OS schema: 11 tables + 2 enums.
-- Applied to project bnxqgvjdvjmdtqvbhnpu on 2026-07-26.

create schema if not exists brand;

create type brand.conf_level as enum
  ('public','anonymized','internal','restricted');

create type brand.draft_status as enum
  ('draft','in_review','approved','rejected','published');

create table brand.sources (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  url text,
  publisher text,
  published_at date,
  summary text,
  source text not null default 'research',
  confidentiality_level brand.conf_level not null default 'public',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table brand.experiences (
  id uuid primary key default gen_random_uuid(),
  code text unique not null,
  title text not null,
  kind text not null,
  body text not null,
  numbers jsonb default '{}'::jsonb,
  interview_ref text,
  source text not null default 'interview',
  confidentiality_level brand.conf_level not null default 'anonymized',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table brand.projects (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  problem text,
  stack text,
  scale jsonb default '{}'::jsonb,
  outcome text,
  source text not null default 'interview',
  confidentiality_level brand.conf_level not null default 'anonymized',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table brand.ideas (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  angle text,
  experience_id uuid references brand.experiences(id),
  score_positioning int check (score_positioning between 0 and 25),
  score_evidence int check (score_evidence between 0 and 25),
  score_value int check (score_value between 0 and 20),
  score_lead int check (score_lead between 0 and 20),
  score_effort int check (score_effort between 0 and 10),
  score_total int generated always as (
    coalesce(score_positioning,0)+coalesce(score_evidence,0)
    +coalesce(score_value,0)+coalesce(score_lead,0)+coalesce(score_effort,0)
  ) stored,
  source text not null default 'system',
  confidentiality_level brand.conf_level not null default 'public',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table brand.content_briefs (
  id uuid primary key default gen_random_uuid(),
  idea_id uuid references brand.ideas(id),
  pillar text,
  hook text,
  key_points jsonb default '[]'::jsonb,
  citations jsonb default '[]'::jsonb,
  cta text,
  source text not null default 'system',
  confidentiality_level brand.conf_level not null default 'public',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table brand.drafts (
  id uuid primary key default gen_random_uuid(),
  brief_id uuid references brand.content_briefs(id),
  version int not null default 1,
  body_fa text not null,
  status brand.draft_status not null default 'draft',
  prompt_version_id uuid,
  source text not null default 'writer',
  confidentiality_level brand.conf_level not null default 'anonymized',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table brand.reviews (
  id uuid primary key default gen_random_uuid(),
  draft_id uuid references brand.drafts(id) on delete cascade,
  has_implementation_detail boolean not null default false,
  has_tradeoff boolean not null default false,
  has_failure boolean not null default false,
  has_number boolean not null default false,
  experience_score int generated always as (
    has_implementation_detail::int + has_tradeoff::int
    + has_failure::int + has_number::int
  ) stored,
  editorial_pass boolean not null default false,
  factcheck_pass boolean not null default false,
  confidentiality_pass boolean not null default false,
  verdict text,
  notes text,
  source text not null default 'review',
  confidentiality_level brand.conf_level not null default 'public',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table brand.publications (
  id uuid primary key default gen_random_uuid(),
  draft_id uuid references brand.drafts(id),
  platform text not null default 'linkedin',
  published_at timestamptz,
  post_url text,
  approved_by text,
  source text not null default 'manual',
  confidentiality_level brand.conf_level not null default 'public',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table brand.metrics (
  id uuid primary key default gen_random_uuid(),
  publication_id uuid references brand.publications(id),
  captured_at date not null,
  impressions int,
  reactions int,
  comments_count int,
  meaningful_comments int,
  dms int,
  consult_requests int,
  source text not null default 'manual_weekly',
  confidentiality_level brand.conf_level not null default 'public',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table brand.prompt_versions (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  version text not null,
  body text not null,
  model text,
  active boolean not null default true,
  source text not null default 'repo',
  confidentiality_level brand.conf_level not null default 'internal',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (name, version)
);

create table brand.workflow_runs (
  id uuid primary key default gen_random_uuid(),
  flow_name text not null,
  status text not null,
  input jsonb default '{}'::jsonb,
  output jsonb default '{}'::jsonb,
  error text,
  duration_ms int,
  source text not null default 'activepieces',
  confidentiality_level brand.conf_level not null default 'internal',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
