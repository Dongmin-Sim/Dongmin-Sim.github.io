# Blog — Project Guide

## Run Locally

```bash
bundle install
bundle exec jekyll serve          # published posts only
bundle exec jekyll serve --drafts # include drafts
```

Site at `http://localhost:4000`. Build output in `_site/` (gitignored).

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
- Draft/published workflow (`published: true/false`)

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
- **`published: false`** on all migrated posts — flip to `true` individually when ready
- **Flat `_posts/`** — no subdirectories, all files named `YYYY-MM-DD-slug.md`
- **Images organized by post slug** — `assets/images/{post-slug}/filename.png`
- **Thumbnails** in `assets/images/thumbnails/`
- **TOC font size 0.78rem** — intentional exception from the 0.82rem scale

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
_drafts/                 # Draft posts (not built by default)
_includes/series-nav.html # Post series navigation
_layouts/
  default.html           # Base layout with header/footer
  home.html              # Post list with descriptions
  post.html              # Post with TOC, thumbnail, series nav
  series.html            # Individual series page
_pages/series.html       # Series index
_posts/                  # All posts (flat)
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
