# Codebase Review Remediation Plan

Date: 2026-07-07 (reviewed item-by-item with Petrus; every item below carries a
**Decision**)
Scope: Fix bugs, security issues, dead code, missing DB constraints, and Rails
framework-default debt accumulated since 2011. **No formatting or stylistic
changes** — git history is preserved; every diff is the minimal change for its fix.

Suggested order: Phase 1 (security) → Phase 2 (crashes) → Phase 3 (data
integrity) → Phase 5 (tests, written alongside 1–3) → Phase 4 (dead code) →
Phase 6 (framework defaults, one PR per Rails version). Phases 1–3 fit in a
handful of small PRs; Phase 6 is the only long-running effort.

Timeline: next election is autumn 2027 or later (confirmed) — all phases can
proceed in order now, including Phase 6 and the session-invalidating /
schema-changing deploys, with ample margin before the next election window.

Key facts established during review:

- Manage pages (`/manage/*`, CSV exports, danger zone) are **admin-only** by
  intent; the current accidental denial of the secretary role matches intent.
- The **secretary role is no longer used at all** → scheduled for removal
  (Phase 4).
- Team members editing each other's alliances is a **bug**; team membership
  grants read-only access.
- `candidates.student_number` partial unique index (unique only where not
  cancelled) is **intentional and correct** — a cancelled candidacy frees the
  student number.
- `config.load_defaults 6.1` is the only defaults setting in effect; all
  `new_framework_defaults_{5_2..8_0}.rb` files are 100% commented-out
  templates. The only live extra flag anywhere is
  `ssl_options = { hsts: { subdomains: true } }` in the Rails 5.0-era
  `new_framework_defaults.rb` (its other 4 active lines are redundant with 6.1).

---

## Phase 1 — Security fixes (highest priority)

### 1.1 Session fixation in Haka/SAML login — **Decision: fix as planned**
`app/controllers/haka_auth_controller.rb:63` (`consume`) and `:16`
(`create_fake_authentication`) write `session[:haka_attrs]` into the
*pre-existing* session. An attacker who plants a session cookie before the
victim logs in inherits the authenticated session.

**Fix:** call `reset_session` immediately before setting `session[:haka_attrs]`
in both actions. Nothing else in the session needs to survive login.

### 1.2 State-changing GET actions — **Decision: fix `done` only**
- `app/admin/electoral_alliances.rb` — `member_action :done` (freeze alliance)
  defaults to GET and is triggered by a plain `link_to`. CSRF-able.
  **Fix:** `member_action :done, method: :post` + `link_to ..., method: :post`
  (pattern already used for `cancel_admin_candidate_path`).
- Logout GETs (`haka/auth/sign_out` route, Devise `sign_out_via = :get`):
  **left as-is** (nuisance-level risk; changing breaks ActiveAdmin links).
  Documented, no action.

### 1.3 Mass email double-send has no guard — **Decision: fix as planned**
`app/models/email.rb#enqueue!` enqueues a send-to-all-candidates job and only
afterwards stamps `enqueued_at`; nothing checks it. The send button in
`app/admin/emails.rb` stays visible after sending.

**Fix:** guard in the model (`return false if enqueued_at?` — root cause, all
callers covered), hide the button in the show view when `enqueued_at` is
present, and add `data: { confirm: ... }` to the button.

### 1.4 Fragile `authorize!` with always-nil subject in Manage controllers — **Decision: fix as planned**
All `Manage::*Controller#authorize_this!` methods call
`authorize! :something, @current_admin_user`, but `@current_admin_user` is nil
at argument-evaluation time (Devise memoizes only when the *method* is called).
Admin passes only because `can :manage, :all` matches a nil subject; secretary
is denied by accident.

**Fix:** add `can :access, :manage_pages` to the admin role in
`app/models/ability.rb`; change every `authorize_this!` to
`authorize! :access, :manage_pages`; gate the dashboard "Ylläpidon toiminnot"
links with `if can? :access, :manage_pages`. (The dashboard gating becomes
mostly moot once the secretary role is removed in Phase 4, but keep it — it is
the correct expression of intent.)

### 1.5 Team member can edit another member's alliance — **Decision: fix as planned**
`app/controllers/advocates/alliances_controller.rb:63-72` — `find_alliance`
falls back to `advocate_team.electoral_alliances` and is used for `:show,
:edit, :update`. Team access is read-only by intent.

**Fix:** team fallback only for `show`; `edit`/`update` resolve strictly via
`current_advocate_user.electoral_alliances`. Regression spec: team member
GET/PATCH another member's alliance → show allowed, edit/update denied.
(Same method also gets the nil-guard from 2.3 — one diff.)

### 1.6 Initial passwords over email — **Decision: keep flow, lengthen password**
`app/concerns/devise_user_behaviour.rb#generate_password` creates an
8-character password that is emailed in cleartext. Decision: the email-the-
password flow stays (operationally convenient for HYY), but the password gets
longer: `Devise.friendly_token.first(20)`.

### 1.7 Stored XSS in admin Email preview — **Decision: fix as planned**
`app/admin/emails.rb` show page: `raw "<pre>#{email.content}</pre>"`.

**Fix:** `pre { email.content }` (Arbre escapes automatically) — one line.

### 1.8 Notes, explicitly no action (all four confirmed as accepted)
- 4-character invite codes: brute-forceable in principle but low impact
  (logged-in student + advocate must accept). Accepted risk.
- SAML attribute debug logging (PII): inert at production `info` level. Kept.
- CSP not configured: skipped (ActiveAdmin inline scripts make it costly).
- `doc/vaalit_2009_ehdokkaat.csv`: verified test data — henkilötunnus column
  empty on all 909 rows, addresses/emails fake. No action.

### 1.9 Narrow advocate `can :update, Candidate` (defense in depth) — **Decision: do it**
`app/models/ability.rb#advocate_user` grants a *global*
`can [:update], Candidate`; only the controller lookup restricts advocates to
their own alliances' candidates. Decision: also scope the ability:
`can :update, Candidate, electoral_alliance: { primary_advocate_id: <advocate id> }`.

Implementation note: inside `Ability#advocate_user(user)` the `user` is the
**HakaUser**, so the advocate id is `user.advocate_user.id`. Applies to the
nomination-period and correction-period grants. The haka-user's own-candidate
rules (`student_number: ...`) are separate `can` rules and OR together —
unaffected. Verify all advocate-side `authorize!` calls pass instances (they
do: `authorize! :update, @candidate` etc.).

---

## Phase 2 — Crash bugs (5xx in normal use)

### 2.1 Nil candidate in update/cancel — **Decision: fix as planned**
`app/controllers/registrations/candidates_controller.rb` — `edit` guards
`@candidate.nil?` but `update` (:21) and `cancel` (:31) don't; double-cancel or
back-button resubmit → `NoMethodError`.

**Fix:** one nil-guard in a shared before_action for `edit/update/cancel`
(redirect to `registrations_candidate_path` with the existing alert text).

### 2.2 Candidate creation with a stale invite code crashes — **Decision: fix as planned**
`#create` with nil `find_alliance` → validation fails → `render :new` →
`@alliance.name` in `new.html.erb` → 500.

**Fix:** in `create`, when `@alliance.nil?` redirect to
`registrations_root_path` with the existing "Kutsukoodi ei ole voimassa" alert.

### 2.3 Advocate viewing a foreign alliance id crashes — **Decision: fix as planned**
`advocates/alliances_controller.rb#find_alliance` — advocate *without* a team
+ foreign id → `@alliance = nil` (the raising `.find` is only in the team
branch) → `show.html.erb` → 500.

**Fix:** after both lookups, redirect to `advocates_alliances_path` with the
existing alert when nil. Same diff as 1.5.

### 2.4 Deleting an alliance with candidates always 500s — **Decision: `restrict_with_error`**
`electoral_alliance.rb:8` `dependent: :nullify` vs `candidates.
electoral_alliance_id` NOT NULL + FK → Postgres error on any destroy of an
alliance that ever had a candidate. Invariant confirmed: *a candidate always
has an alliance*.

**Fix:** `dependent: :restrict_with_error` + friendly alert in ActiveAdmin when
destroy is blocked. NOT NULL stays. Fossils that assume orphan candidates
(`Candidate.without_alliance` scope, `give_numbers!` orphan check, admin form
comment) → evaluated for removal in Phase 4.

### 2.5 `nil.strip!` crashes in before_validation callbacks — **Decision: fix as planned**
`electoral_alliance.rb:84-91` and `electoral_coalition.rb`
(`strip_whitespace_from_name_fields!`, `upcase_invite_code!`) raise on nil
input instead of producing a validation error.

**Fix:** safe navigation (`self.name&.strip!` etc.). Candidate's
`strip_whitespace!` is `before_save` (post-validation) and safe — untouched.

### 2.6 ActiveAdmin has_many-ids overrides — **Decision: delete the overrides (root cause confirmed from git history)**
`app/admin/advocate_teams.rb`, `advocate_users.rb`, `electoral_coalitions.rb`
override `create`/`update` to assign `*_ids` from raw `params` (admin-only
mass-assignment bypass; crashes when the checkbox group is absent; dead
wrong-key line in advocate_teams create).

**Why they exist (investigated per review):** introduced in the 2016
Rails 5 migration (commit `909f5ea`, "Replace attr_accessible with Strong
Parameters"). `permit_params` declares `:electoral_alliance_ids` as a
**scalar**, but the checkbox form submits an **array**; strong params silently
drops an array under a scalar key — hence the comment "just not available
through permitted_params". The correct declaration was `permit_params
electoral_alliance_ids: []`. The workaround was later copy-pasted to
advocate_teams and electoral_coalitions. No domain reason.

**Fix:** switch to array-style `permit_params ..., *_ids: []` and delete all
six controller overrides (~60 lines). Manual QA in admin: create+edit team /
advocate / coalition, including with an empty checkbox selection.

### 2.7 `GlobalConfiguration.advocate_login_enabled?` crashes on empty table — **Decision: fix as planned**
`global_configuration.rb:45-47`. **Fix:** `!!first&.advocate_login_enabled?`.

### 2.8 Numbering-order endpoints crash on missing params — **Decision: fix as planned**
`order_alliances` / `order_coalitions` member_actions pass possibly-nil
`params[:alliances]` / `params[:coalitions]` into `.each`.
**Fix:** early return on blank in the two member_actions
(`app/admin/electoral_coalitions.rb`).

### 2.9 `has_all_candidates?` nil crash on legacy rows — **Decision: fix as planned**
`electoral_alliance.rb:60-62` — one nil `expected_candidate_count` row kills
the whole admin dashboard. **Fix:** `expected_candidate_count.to_i > 0`.

---

## Phase 3 — Data-integrity bugs

### 3.1 Phantom audit rows when save fails — **Decision: fix as planned**
`candidate.rb#log_and_update_attributes` writes `CandidateAttributeChange`
rows *before* `save`; a false return commits audit rows for a change that
never happened. The change log is the legally relevant record.

**Fix:** save first; on success write the log from `previous_changes`
(filtered to the changed attrs). Same return-value contract. Regression spec:
failed update → zero log rows; successful update → correct rows.

### 3.2 `give_numbers!` stamps cancelled candidates with 0 — **Decision: fix + add unique index on candidate_number**
`candidate.rb:95-115` — `update_all candidate_number: 0` hits all rows;
cancelled ones keep `0` (they must have no number; the column is exported).

**Fix (two parts, order matters):**
1. `update_all candidate_number: nil` (all rows), then number valid candidates
   as today.
2. New migration: `add_index :candidates, :candidate_number, unique: true` —
   Postgres allows multiple NULLs, so cancelled candidates are fine. **The
   0→nil fix is a prerequisite**: the current `update_all 0` would violate the
   index immediately. The per-candidate sequential assignment inside the
   transaction assigns distinct values and stays valid.
Numbering intentionally starts at 2 (`with_index(2)`) — election convention,
not touched.

### 3.3 Missing unique index: `advocate_users.student_number` — **Decision: add it**
Model-only `validates_uniqueness_of` (race-prone; Haka login resolves
advocates by student_number). **Fix:** migration
`add_index :advocate_users, :student_number, unique: true`. Pre-check
production data for duplicates before deploying. Bundle in the same
schema-changing deploy as 3.2's index and Phase 4's column drop.

### 3.4 `.deliver` in mailer calls — **Decision: minimal fix only (`deliver_now`)**
`advocate_user.rb:35` and `admin_user.rb#send_password` use `.deliver`
(Delegator fallthrough to `Mail::Message#deliver` — works but bypasses
ActionMailer instrumentation and is fragile across upgrades).

**Fix:** `.deliver` → `.deliver_now`. Explicitly decided **not** to move
`after_create` → `after_commit`: a mail failure visibly failing the creation
is acceptable (admin notices immediately).

### 3.5 Dead validation line — **Decision: delete**
`electoral_alliance.rb:33` — `validates_presence_of :expected_candidate_count,
allow_nil: true` is a no-op (the numericality rule on the next line does the
real work). Delete; behavior unchanged.

---

## Phase 4 — Dead code, dead dependencies, doc rot — **Decision: all items approved**

Each item is delete-only; none changes behavior. One commit per bullet-group.

- **Gem `json_builder`** (`Gemfile:18`, has a TODO asking this): zero
  references. Remove from Gemfile + lockfile.
- **`app/concerns/extended_poro_behaviour.rb`**: zero includes. Delete.
- **`config/secrets.yml`**: dead since Rails 7.2 removed
  `Rails.application.secrets` (dev/test key comes from `tmp/local_secret.txt`,
  production from `ENV["SECRET_KEY_BASE"]`). Delete after grepping.
- **`Vaalit::Aws.connect?`** (`000_vaalit.rb:49-53`): zero callers. Delete.
- **`electoral_alliances.secondary_advocate_id`** column + FK: unused since
  2012. Drop in the same migration deploy as 3.2/3.3 indexes.
- **`EnqueueCandidateEmails#perform`**: `puts` → `Rails.logger.info`; delete
  the no-op `.inspect` in `CandidateAttributeChange.create_from!`.
- **`candidate.rb#strip_whitespace!`**: normalize `self&.address&.strip!` →
  `self.address&.strip!` only because the file is already edited in 3.1/3.2.
- **`Candidate.without_alliance` + `give_numbers!` orphan check**: provably
  dead once 2.4 lands (column is NOT NULL). Remove during 2.4 review.
- **Secretary role removal** (decided during review: role is no longer used):
  `ability.rb#secretary` branch, `AdminUser` enum value / `scope
  :secretaries` / `is_secretary?` / role validation collapse, seed-task
  secretary user, README mentions. **Data note:** check production for
  existing `role: "secretary"` rows and convert/remove them first; the
  `role` column itself can stay (single value) to keep the diff small.
  `secretarial_freeze` on alliances is a domain field, not the role — stays.
  `RegistrationMailer#welcome_secretary` is used for *all* admin users via
  `send_password` — **decided: keep the name** (smallest diff, history stays
  clean); add a one-line comment noting the name is a historical relic.
- **README refresh** (factual only): RVM-era setup, dead `heroku pgbackups`
  commands, path casing (`app/models/AdminUser.rb`), foreman port 5000 vs puma
  3000, old app name `hyy-vaalit`. Keep operational lore (Pekka's tips,
  worker/retry notes).
- **`HakaUser#parse_student_number`** (`haka_user.rb:40-68`): unreachable
  `elsif value.blank?` / final `else` branches; debug line logs `value`
  (always nil there) instead of `raw`. Simplify to Array/String/else-raise,
  log `raw`.

---

## Phase 5 — Tests — **Decision: expanded scope**

Current coverage: 3 model specs, ~60 lines. rspec + factory_bot already
installed — no new test dependencies. Three tracks:

1. **One regression spec per fix** in Phases 1–3, smallest spec that fails
   without the fix. Model-level where possible (3.1, 3.2, 2.5, 2.7, 2.9),
   request-level where the bug is in a controller (1.1, 1.3, 1.5, 2.1–2.4).
2. **Authorization request specs** (the boundaries are the product):
   - guest: all `/registrations`, `/advocates`, `/manage` paths → 401/302
   - Haka user: read/update/cancel only own candidate; create only during
     nomination period; nothing when frozen
   - advocate: CRUD only own alliances' candidates (now also enforced in
     ability, 1.9); team alliances readable, not editable (1.5); nothing when
     `advocate_login_enabled` off
   - admin: manage pages accessible; (secretary specs dropped — role removed)
   - fake auth: unavailable when `STAGE=production` even with
     `FAKE_AUTH_ENABLED=yes`
3. **Happy-path request specs** (added per review decision): candidate
   registration form flow (new→create→show), advocate alliance+candidate
   creation and edit, admin CSV exports (all six dashboard export links return
   parseable CSV in both encodings), alliance done/freeze flow, candidate
   numbering end-to-end (`give_numbers!` via danger zone).

Period-dependent abilities are driven by the three `CANDIDATE_*_AT` env vars —
stub `Vaalit::Config` constants or use `.env.test` overrides; no new gems.

Plus one **manual pre-election verification checklist** item (not code): run
the full email pipeline (Email → `enqueue!` → delayed_job worker → SES sandbox)
in QA before each election — the stack (delayed_job YAML of AR objects on
Ruby 3.4/psych 4 + aws-actionmailer-ses v1) has churned recently. A minimal
automated spec asserting `Email#enqueue!` creates a `Delayed::Job` row that
deserializes and performs against mailer test-deliveries backs this up.

---

## Phase 6 — Rails framework defaults 6.1 → 8.0 — **Decision: full path approved**

Verified during review: `config.load_defaults 6.1` (`config/application.rb:12`)
is the only defaults setting in effect. All `new_framework_defaults_*.rb`
version files are fully commented out (0 active lines each); the Rails 5.0-era
`new_framework_defaults.rb` has 5 active lines of which 4 are redundant with
6.1 defaults and only `ssl_options = { hsts: { subdomains: true } }` matters.
The app genuinely runs Rails 8.0.3 with Rails 6.1 behavior.

Strategy: one Rails-version step per PR, deployed and verified in QA between
steps, executed outside the election window.

1. **7.0 step** (the risky one):
   - `cookies_serializer` already `:json` — no marshal migration needed.
   - `cookies_same_site_protection = :lax` — **the** critical QA test: SAML
     POST callback (`/haka/auth/consume`) must still get a session. The
     session write happens after the POST (and 1.1 resets it anyway), so
     expected OK — verify against real Haka test IdP.
   - `hash_digest_class = SHA256` + key-generator change: invalidates existing
     sessions/remember-me cookies → deploy in the off-season.
   - Audit the few `button_to`s (admin email send) for 7.0 form changes.
   Uncomment flags in `new_framework_defaults_7_0.rb` first; when green, flip
   `load_defaults 7.0` and delete the file.
2. **7.1 step**: same uncomment→flip→delete cycle.
3. **7.2 + 8.0 steps**: small deltas; keep delayed_job wiring untouched and
   verify jobs still run.
4. After 8.0: delete all remaining `new_framework_defaults*.rb`; move the
   `ssl_options hsts subdomains` line into `production.rb`.

Explicitly **out of scope** (confirmed): sprockets/jquery/sassc replacement,
ActiveAdmin 4 beta, delayed_job → Solid Queue, trimming `rails/all`, Heroku
stack changes.

---

## Deliberately not touching — **confirmed as-is**

- Formatting, hash-rocket syntax, `validates_*_of` style, comment style —
  everywhere. Old git history stays readable.
- Candidate numbering starting at 2, ranked-model setup, paper-form-era flow.
- 4-char invite codes (accepted risk, 1.8).
- Logout via GET (1.2).
- `freeze!` method name on ElectoralAlliance.

## Resolved during review (no longer open)

1. Advocate candidate-update ability narrowed in `ability.rb` → item 1.9.
2. Secretary role is unused → removal added to Phase 4.
