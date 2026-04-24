# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

Phoenix v1.8 application (OTP app name `:smartwrk`, modules under `Smartwrk` / `SmartwrkWeb`). It is a content-driven site: Markdown posts under `priv/posts/**/*.md` are compiled at build time by `NimblePublisher` and served by Phoenix. A custom Mix task renders every route to flat HTML for static hosting.

`AGENTS.md` at the repo root is authoritative for Phoenix/LiveView/HEEx/Tailwind conventions — read it before writing templates, LiveViews, or forms. The guidance below does **not** restate it.

## Commands

- `mix setup` — fetch deps, install tailwind/esbuild, build assets (run once after clone).
- `mix phx.server` — dev server at http://localhost:4000 (LiveDashboard at `/dev/dashboard`, Swoosh mailbox at `/dev/mailbox`).
- `mix precommit` — must pass before committing. Runs `compile --warnings-as-errors`, `deps.unlock --unused`, `format`, and `test`. `precommit` forces `MIX_ENV=test` via `cli/0` in `mix.exs`.
- `mix test test/path/to/file_test.exs` — single file. `mix test --failed` — re-run last failures only.
- `mix assets.build` / `mix assets.deploy` — dev / minified+digested asset builds.
- `mix smartwrk.export` — render the whole site to `docs/` (see below).

## Architecture

### Blog is compile-time, not runtime

`Smartwrk.Blog` (`lib/smartwrk/blog.ex`) uses `NimblePublisher` to read every `priv/posts/**/*.md` at **compile time** into module attributes (`@posts`, `@tags`). `all_posts/0`, `all_tags/0`, and `get_post_by_id!/1` return those baked-in values — there is no database, no runtime fetch, and no cache to invalidate. Adding or editing a post requires a recompile (`mix phx.server` handles this in dev via `phoenix_live_reload`).

Post filenames encode the date and slug: `priv/posts/YYYY/MM-DD-slug.md`. `Smartwrk.Blog.Post.build/3` parses that path — if you change the layout, update `build/3` to match. Front-matter keys (`:title`, `:description`, `:tags`) are enforced by `@enforce_keys` on the struct, so a post missing any of them fails compilation.

### Static-site export is route-driven

`mix smartwrk.export` (`lib/mix/tasks/smartwrk.export.ex`) spins up the app, walks a hardcoded list of paths (`/`, `/about`, `/posts`, `/tags`, plus one per post and per tag), dispatches each through `SmartwrkWeb.Endpoint` via `Phoenix.ConnTest`, and writes the HTML response to `docs/<path>/index.html`. Anything you want exported must both (a) be a real route in `SmartwrkWeb.Router` and (b) be listed in `exportable_paths/0`. The base URL in `sitemap/1` is a placeholder (`https://yoursite.com`) — update it before shipping a real sitemap.

Tag URLs use `Smartwrk.Blog.tag_slug/1` so tags with spaces or punctuation map to URL-safe segments. Keep that helper as the single source of truth for tag → URL conversion.

### Web layer

Standard Phoenix 1.8 layout: `SmartwrkWeb.Endpoint` → `SmartwrkWeb.Router` → controllers in `lib/smartwrk_web/controllers/` with colocated `*_html.ex` view modules and `.heex` templates. `SmartwrkWeb.Layouts` / `core_components.ex` are the shared UI primitives — per `AGENTS.md`, every LiveView template must start with `<Layouts.app flash={@flash} ...>`.

## Assets

Tailwind v4 (no `tailwind.config.js`) + esbuild, both invoked through Mix tasks (`tailwind smartwrk`, `esbuild smartwrk`) — configured in `config/config.exs`. Only `assets/js/app.js` and `assets/css/app.css` are bundled; vendor code must be imported into those, not referenced via `<script src>` in layouts.
