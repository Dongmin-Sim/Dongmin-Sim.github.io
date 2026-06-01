# Blog — Project Guide

## Run Locally

Use `preview.sh` — picks a view in one word, live-reload always on:

```bash
./preview.sh          # all: drafts + unpublished posts (default, for writing)
./preview.sh pub      # published only (matches the real site)
./preview.sh ready    # only stage: ready posts (home list)
./preview.sh all 4001 # change port (default 4000)
```

The script activates rbenv (ruby 3.2.6) itself, so it works from a non-interactive
shell too. Stop with `Ctrl-C`. Site at `http://localhost:4000`.

Raw jekyll still works (`bundle exec jekyll serve [--drafts] [--unpublished]`).
Build output in `_site/` (gitignored).

## What Has Been Built

### Theme & Layout
- Custom warm neutral Jekyll theme (Noto Serif, `#faf9f7` palette)
- Responsive single-column layout (640px content width)
- Sticky table of contents (right side, visible above 1100px)
- Custom 404 page with recent posts

### Content Features
- 118 migrated posts from old Chirpy blog (flat `_posts/` structure)
- Post thumbnails (`image.path` / `image.alt` in front matter)
- Post descriptions shown in home list
- Series system (`_data/series.yml`) with navigation between posts
- Tags page
- Maturity workflow: `_drafts/` (in-progress) → `_posts/` (ready/published), with a
  `stage:` front matter field (`seed` / `draft` / `ready`) — see "Post Maturity Model"

### Styling
- Syntax highlighting (Rouge, warm neutral theme)
- Table styling (borders, alternating rows, mobile scroll)
- Image and table captions (italic, centered, muted)
- Inline code styling (warm background, JetBrains Mono)

### Infrastructure
- GitHub Actions deployment (`.github/workflows/deploy.yml`)
- Deployed to `dongmin-sim.github.io`
- Design system documented in `.interface-design/system.md`

## Key Design Decisions

- **Borders only** — no box-shadows anywhere
- **All colors as tokens** in `_sass/_variables.scss`, no hardcoded hex in components
- **`published: false`** keeps a post out of the real site until flipped to `true`
- **`_posts/` and `_drafts/` split by maturity** — `_drafts/` holds in-progress work
  (not built unless `--drafts`), `_posts/` holds ready/published. No subdirectories in
  either. `_posts/` files are `YYYY-MM-DD-slug.md`; `_drafts/` files may drop the date.
- **Images organized by post slug** — `assets/images/{post-slug}/filename.png`
- **Thumbnails** in `assets/images/thumbnails/`
- **TOC font size 0.78rem** — intentional exception from the 0.82rem scale

## Post Maturity Model

Two orthogonal axes describe every post:

- **`published: true/false`** — is it on the live site? (the deploy gate)
- **`stage: seed | draft | ready`** — how finished is it? (the maturity)
  - `seed` — title/outline/notes only, or near-empty. A topic placeholder.
  - `draft` — has substance but unfinished or rough.
  - `ready` — coherent enough to publish with light polish.

Folder location follows maturity:

- **`_drafts/`** holds `seed` + `draft` — never deployed, no date needed in filename.
  New posts start here (e.g. seeded from a topic idea). Move to `_posts/` when `ready`.
- **`_posts/`** holds `ready` + already-published. Files are `YYYY-MM-DD-slug.md`.

So a typical life: `_drafts/topic.md` (seed) → fill in (draft) → polish (ready) →
`git mv` to `_posts/YYYY-MM-DD-slug.md` → flip `published: true` to ship.

Preview a single maturity with `./preview.sh ready` (home list filtered by stage; the
filter in `_layouts/home.html` is guarded by `site.preview_stage`, set only by
`_config_ready.yml`, so normal/deploy builds are unaffected).

> The current `stage` values were seeded in bulk by a heuristic (count of completed
> sentences), then refined by hand as posts get opened. Treat a single post's `stage`
> as a hint until reviewed.

## Known Issues / TODO

- 34 posts have dates derived from file mtime (may not reflect actual writing date)
- 49 broken image references commented out (Obsidian paste artifacts never committed)
- 5 orphaned thumbnails not referenced by any post (`docker.png`, `spring-boot.png`, `spring-framework.png`, `spring.svg`, `web-mvc.png`)
- `assets/thumbnail/` (singular) directory still exists — duplicate of `assets/images/thumbnails/`, safe to delete
- Some posts have auto-generated titles from slug (e.g., "Fork Join Framework") — should be replaced with proper Korean titles
- Series pages (`series/*.html`) are manually created per series

## File Structure

```
_config.yml              # Jekyll config, kramdown + Rouge
_data/series.yml         # Series definitions
_drafts/                 # In-progress posts: stage seed+draft (not built unless --drafts)
_includes/series-nav.html # Post series navigation
_layouts/
  default.html           # Base layout with header/footer
  home.html              # Post list with descriptions
  post.html              # Post with TOC, thumbnail, series nav
  series.html            # Individual series page
_pages/series.html       # Series index
_posts/                  # Ready/published posts (flat): stage ready
preview.sh               # Local preview launcher (pub / all / ready modes)
_config_ready.yml        # Overlay used by preview.sh ready mode
_sass/
  _variables.scss        # Design tokens
  _base.scss             # Reset, body, links
  _typography.scss       # Headings, paragraphs, lists
  _code.scss             # Inline code and code blocks
  _syntax.scss           # Rouge syntax highlighting theme
  _layout.scss           # All layout components
assets/
  css/main.scss          # Sass entry point
  images/{slug}/         # Post images by slug
  images/thumbnails/     # Post thumbnail images
  images/orphan/         # Unreferenced images
series/                  # Individual series page files
404.html                 # Custom 404
.interface-design/system.md # Design system reference
```
