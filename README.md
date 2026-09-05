# Vitality

A Rails fitness-tracking app: workout logging with progressive-overload
suggestions and PR detection, plus calorie/macro tracking against a
TDEE (Mifflin-St Jeor) baseline. Built with Hotwire/Turbo + Tailwind,
backed by PostgreSQL, and installable as a PWA.

## Stack

- Ruby 3.3.12 / Rails (Hotwire, Turbo, Tailwind CSS)
- PostgreSQL
- RSpec, FactoryBot, Faker for tests
- Docker + Docker Compose for local development

## Running locally (Docker)

The app is developed and run via Docker Compose — this is the supported way
to run it locally, on **http://localhost:3000**.

```bash
docker compose up --build
```

This starts two services:

- `db` — Postgres 16, with a healthcheck so `web` waits for it to be ready
- `web` — the Rails app, started via `bin/dev`

First-time setup (in a second terminal, once containers are up):

```bash
docker compose exec web bin/rails db:create db:migrate db:seed
```

Then visit http://localhost:3000.

To keep it running in the background instead of holding a terminal open:

```bash
docker compose up -d --build
```

Docker Compose will restart the containers automatically on `docker
restart`/host reboot only if a `restart` policy is set; by default this
project does not set one, so after a host reboot you'll need to run `docker
compose up -d` again.

### Running tests

```bash
docker compose exec web bin/rails db:test:prepare
docker compose exec web bundle exec rspec
```

## Fixed / Updated

**Views not picking up style changes in Docker (fixed).** The `web` service
originally ran the Rails server directly:

```
bundle exec rails server -b 0.0.0.0
```

That starts Puma only — it never starts the Tailwind CLI watcher, so
`app/assets/builds/tailwind.css` was only built once (at image build time)
and never regenerated when a view or `app/assets/tailwind/application.css`
changed. Pages would render, but with stale or missing styles until the
image was rebuilt.

The fix (commit `f4ea8a8`) switches the container command to `bin/dev`,
which uses Foreman to run both processes from `Procfile.dev`:

```
web: bin/rails server -b 0.0.0.0
css: bin/rails tailwindcss:watch
```

`bin/rails server -b 0.0.0.0` was also made explicit in `Procfile.dev`
itself — Puma's default bind is `127.0.0.1` in some contexts, which is not
reachable from outside the container even with the port published in
`docker-compose.yml`. Binding to `0.0.0.0` ensures the host's
`localhost:3000` actually reaches Puma inside the container.

With both fixes, editing a view or Tailwind class now rebuilds CSS live and
the change is visible on refresh — no image rebuild required.

**Login page appearing broken / login not working (fixed, 2026-09-05).** This
wasn't a code bug — the `web` container had crashed (`bash: line 1: bin/dev:
No such file or directory`, exit 127) and stayed down while `db` kept
running, so `localhost:3000` was serving nothing (or a stale cached page).
Fix: `docker compose up -d --build web` to recreate the container from a
clean build. If you see this again, check `docker compose ps` — if `web`
shows `Exited` while `db` shows `Up`, that's the same failure mode; a
rebuild resolves it since the cause is stale container/image state, not the
application code.

**Login POST failing with `ActionController::InvalidAuthenticityToken` (fixed,
2026-09-05).** This surfaced right after the container-crash issue above and
is a real defect in the offline PWA setup, not user error. The service
worker (`app/views/pwa/service-worker.js`) caches `/login` once at install
time as its offline fallback:

```js
event.respondWith(fetch(event.request).catch(() => caches.match(OFFLINE_URL)));
```

While `web` was down, any visit to `/login` failed at the network level, so
the browser silently got served that stale cached copy instead — a normal-
looking page, but with a CSRF token minted at install time. Once the server
came back, submitting that still-open stale page sent a token the current
session no longer recognized, raising `InvalidAuthenticityToken` (shown as
Rails' full unhandled-exception page in dev, since
`consider_all_requests_local = true`).

Two fixes, both applied:

1. `ApplicationController` now has
   `rescue_from ActionController::InvalidAuthenticityToken` → resets the
   session and redirects to a fresh `/login` with a "Your session expired,
   please try again" flash, instead of raising. This is a general
   robustness fix independent of the PWA — any stale/forged token now fails
   gracefully.
2. The service worker's fetch handler now re-caches `/login` every time it's
   fetched live and returns OK, instead of only once at install. This keeps
   the offline fallback's embedded CSRF token close to current rather than
   frozen at whatever moment the service worker first installed, shrinking
   (but not eliminating — a fallback page cached during a long outage can
   still go stale) the staleness window.

If you hit this again: a hard refresh (bypassing the SW cache) of `/login`
before logging in resolves it immediately.

Separately, if you see Postgres logging repeated
`FATAL: database "vitality" does not exist` — that's not this app. This
codebase's `config/database.yml` always connects to `vitality_development`,
`vitality_test`, or `app_production` explicitly. A bare `vitality` database
name means some other local process is connecting to `localhost:5432`
without specifying a database (Postgres defaults to a DB named after the
connecting user). Look for another tool/script/container pointed at that
port rather than debugging this app for it.

## Where exercise and food data comes from

There is no external API call for either. Both are plain Postgres tables
(`exercises`, `foods`) that the app queries directly:

- `ExercisesController#index` / `#show` just run `Exercise.where(...)` /
  `Exercise.find(...)` — a normal ActiveRecord query against the local DB.
- The data itself is hardcoded in `db/seeds.rb`: 30 exercises (name, muscle
  group, equipment, instructions) and 30 common foods (name, serving size,
  calories, macros), loaded via `Exercise.find_or_create_by!` /
  `Food.find_or_create_by!` when you run `db:seed`.
- `Food` additionally has a `source` enum (`manual` vs `database`, default
  `database`) — seeded foods are tagged `database`; a food a user creates
  themselves through the app would be tagged `manual`. There's no admin UI
  or import pipeline for foods beyond the seed file today — adding more
  means editing `db/seeds.rb` and re-running `db:seed`, or creating rows
  through the app for `manual` entries.

## CI

`.github/workflows/ci.yml` runs on every push to `main` and every PR:

- `scan_ruby` — Brakeman static security scan
- `scan_js` — `bin/importmap audit` for JS dependency vulnerabilities
- `lint` — Rubocop

**Note:** the RSpec suite (54 examples, model + service specs) is not part
of CI yet — it only runs when invoked locally. Consider adding a `test` job
that runs `bundle exec rspec` against a Postgres service container if you
want PRs blocked on test failures.

`.github/dependabot.yml` opens daily dependency-update PRs for both
`bundler` and `github-actions`.
