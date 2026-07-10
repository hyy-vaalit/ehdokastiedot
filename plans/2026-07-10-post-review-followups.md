# Post-Remediation Follow-ups

Date: 2026-07-10
Source: re-review of master after the 2026-07-07 remediation plan was fully
merged. Master itself is healthy: all remediation items verified implemented,
full suite green (76/76), `zeitwerk:check` passes. The items below are the
only things left, ordered by priority.

---

## 1. Unblock the devise 5 upgrade with ActiveAdmin ~> 3.5 (in progress)

Dependabot PR #62 (devise 4.9.4 → 5.0.4) breaks app boot as-is: ActiveAdmin
3.3.0 hard-requires devise `>= 4.0, < 5` and raises
`ActiveAdmin::DependencyError` when routes load (`config/routes.rb:3`).
Verified by running the suite on the dependabot branch (everything fails) vs
master (green).

Fix path (already started on branch `dependabot/bundler/devise-5.0.4`):
Gemfile bumped to `activeadmin ~> 3.5`, lockfile resolves activeadmin 3.5.1 +
devise 5.0.4 (AA 3.4+ dropped the `< 5` devise pin; 3.5.1 no longer declares
a hard devise dependency at all).

Remaining steps:

1. Run the full suite on the branch (needs local Postgres; a throwaway
   `postgres:16-alpine` container with `PGHOST=localhost PGUSER=postgres`
   works — see item 2 for making this unnecessary).
2. Skim changelogs for surprises:
   - ActiveAdmin 3.3 → 3.5 (minor releases, expected safe).
   - Devise 4.9 → 5.0 (drops old Rails support — we are on 8.0, fine;
     check `config/initializers/devise.rb` for removed/renamed config keys
     and fix any boot-time deprecation warnings).
3. Manual admin smoke test (the parts specs do not fully exercise):
   log in, dashboard renders, candidate cancel link (`data-method: :post`),
   alliance "done" freeze action, email send button, and the three
   has_many-checkbox forms (team / advocate / coalition) with empty and
   non-empty selections.
4. Commit both Gemfile and Gemfile.lock to the branch so the Dependabot PR
   turns into "devise 5 + activeadmin 3.5", or open a separate PR and close
   Dependabot's. Merge.

## 2. Add CI that runs the test suite

There is no `.github/workflows/` at all — the only Actions activity is
Dependabot itself, whose "success" only means the PR was created. The broken
devise PR would have merged without any signal; the 76-spec suite written in
Phase 5 only protects whoever remembers to run it locally.

Plan:

1. Add `.github/workflows/test.yml`:
   - trigger: `push` to master + `pull_request`
   - `postgres:16` service container
   - `ruby/setup-ruby` with `bundler-cache: true` (version from
     `.ruby-version`)
   - `bundle exec rails db:prepare && bundle exec rspec`
   - `PGHOST`/`PGUSER`/`PGPASSWORD` env pointing at the service; the rest of
     the required ENV comes from the committed `.env.test` via dotenv-rails.
   - `CI=true` is set by Actions automatically, which also turns on
     `config.eager_load` in test env (config/environments/test.rb), so a
     boot-time dependency error like the devise one fails CI even before
     specs run.
2. In GitHub repo settings, mark the workflow as a required status check for
   master so red Dependabot PRs cannot be merged (manual step, not code).

## 3. Clean up `app/admin/candidates.rb` fossils (Phase 4 leftover)

The 2026-07-07 plan flagged the "orphan candidate" fossils for removal once
2.4 (`dependent: :restrict_with_error` + NOT NULL FK) landed. The
`Candidate.without_alliance` scope and `give_numbers!` orphan check were
removed, but the admin form fossil was not:

1. The `controller do ... create/update` override comments (lines 27, 43)
   claim the overrides exist "because :electoral_alliance_ids is not
   available in permitted_params" — false; the overrides exist to redirect
   to the alliance page instead of the candidate page. Rewrite the comments
   to say that. (The overrides themselves stay — they are behavior, not
   dead code.)
2. The form's "alliance was deleted" branch is now provably dead:
   `candidates.electoral_alliance_id` is NOT NULL and an alliance with
   candidates cannot be destroyed. Remove:
   - the `find_by_id` + `"Vaaliliitto puuttuu"` fallback (lines ~109–113) —
     an existing candidate always has an alliance,
   - the `else` branch rendering an alliance dropdown (lines ~150–154);
     always render the hidden `electoral_alliance_id` field.
   The `params[:action] == "new" && alliance_id.nil?` guard at the top of
   the form stays — it is the real entry path for "create candidate without
   picking an alliance first".
3. Existing admin request specs cover create/edit; extend the happy-path
   spec with one GET of the admin candidate edit form if it is not already
   rendered somewhere.

Delete-only plus comment fixes; no behavior change.

## 4. Make GlobalConfiguration a real singleton (nil-guard leftover from 2.7)

2.7 fixed only the reader (`advocate_login_enabled?`). These still crash
with `NoMethodError` on an empty table:

- `Manage::ConfigurationsController#enable_advocate_login` /
  `#disable_advocate_login` / `#find_configuration`
- `Manage::DangerZonesController#show`

Root-cause fix, one place: add `GlobalConfiguration.instance` defined as
`first_or_create!` (the only column, `advocate_login_enabled`, defaults to
`false`, so auto-creating the row is safe), use it in the four call sites
and in `advocate_login_enabled?`. One model spec: `instance` on an empty
table creates the row and `advocate_login_enabled?` returns false.

Low urgency — the row is seeded in every real environment — but the fix is
smaller than the guard-every-caller alternative.

## Explicitly accepted, no action

- `Email#enqueue!` check-then-act race between two simultaneous admin
  clicks: the POST button + confirm dialog is enough for an admin-only,
  once-per-election action.
- Admin candidates index defaulting to the "Peruneet" (cancelled) scope:
  intentional (commit f00c879, 2022).
- GET logout, 4-char invite codes: accepted in the 2026-07-07 plan, still
  stand.

## Pre-deploy checklist (carry-over, now attached to the next deploy)

Because framework defaults jumped 6.1 → 8.0 in a single PR (instead of the
planned per-version steps), all of the plan's QA gates apply to one deploy:

1. Test SAML login against the real Haka test IdP
   (`cookies_same_site_protection = :lax` vs the POST consume callback).
2. The deploy invalidates all sessions and remember-me cookies
   (`hash_digest_class = SHA256` key-generator change) — deploy off-season,
   which is now (next election autumn 2027 or later).
3. Before running the three 2026-07-07 migrations in production, check for
   duplicates in `advocate_users.student_number` — the new unique index
   fails on existing dupes.
4. Before each election: run the email pipeline end-to-end in QA
   (Email → `enqueue!` → delayed_job worker → SES sandbox).
