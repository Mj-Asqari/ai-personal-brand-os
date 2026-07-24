# ai-personal-brand-os

Version control for prompts, DB migrations, and workflow exports.

**No secrets in this repo. Ever.**

## Structure
- `docs/` — charter, voice profile, policies, architecture
- `migrations/` — Supabase SQL, numbered, forward-only
- `prompts/` — versioned prompt files (`name.vN.md`)
- `flows/` — ActivePieces exports, secrets stripped

## Stack
Notion (human interface) · Supabase (data) · ActivePieces (orchestration) · OpenRouter (models)

## Rules
- Secrets live in ActivePieces Connections only
- Every prompt change = new version file + row in `prompt_versions`
- Flow exports must be scrubbed before commit
