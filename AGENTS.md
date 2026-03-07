# Agent Instructions

## Testing

- All new features and bug fixes must be accompanied by tests.
- Run `bin/rails test` before committing — all tests must pass.
- Controller tests go in `test/controllers/`, model tests in `test/models/`.
- To authenticate a player in controller tests, set `cookies[:player_id] = player.uuid` in `setup` — this uses the anonymous auth fallback in `Authentication#resume_session` without requiring a real login session.
- Fixtures use a pre-hashed password (`$2a$12$dUE8mqkdZdQLjm7etdI7UuctpetWmq9zAluJLPC3ShchYiGf3Zpmm`) which corresponds to the plaintext `password`.

## Migrations

- Always commit `db/schema.rb` alongside any migration file.
- Backfill data in the migration where possible, using raw SQL via `update_all` rather than Ruby-level attribute assignment to avoid column cache issues.

## General

- Run tests before pushing. Do not push a branch with failing tests.
