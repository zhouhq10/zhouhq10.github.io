# zhouhq10.github.io

Personal website of Hanqi Zhou — built with [Typst](https://typst.app/) compiled to static HTML, using the [Tufted-Blog-Template](https://github.com/Yousa-Mirage/Tufted-Blog-Template). Tufte-style: wide margins, sidenotes, content first.

Live at **https://zhouhq10.github.io/**.

---

## How it works

You write content in **Typst** (`.typ` files) under `content/`. A Python script (`build.py`) compiles each `.typ` into an HTML page, copies static assets, and generates a sitemap + RSS feed into `_site/`. GitHub Actions does the same on every push to `tufted-redesign` and publishes `_site/` to GitHub Pages.

```
content/         # your pages, written in Typst — this is what you edit
  index.typ      #   the home page
  Research/index.typ, Talks/index.typ, ...   # one folder per nav section
  Writing/       #   blog: index.typ lists posts, one folder per post
config.typ       # site-wide config: nav links, title, author, footer
tufted-lib/      # the template engine (Typst) — rarely touch
assets/          # CSS + JS (theme, sidenotes, table of contents, ...)
build.py         # the build/preview script
_site/           # build output — generated, gitignored, do not edit
_hugo_archive/   # the old Hugo site, kept for reference only
```

## Running locally

Prerequisites — install once:

- [Typst](https://typst.app/open-source/#download) (`brew install typst` on macOS)
- [uv](https://docs.astral.sh/uv/) (`brew install uv`) — runs `build.py`

Then, from the repo root:

```bash
# Live preview with a local server (default http://localhost:8000)
uv run build.py preview

# pick a different port
uv run build.py preview -p 3000

# One-off full build into _site/
uv run build.py build

# Force a clean rebuild (ignore the incremental cache)
uv run build.py build -f
```

Other commands: `uv run build.py html` (HTML only), `pdf`, `assets`, `clean`. Run `uv run build.py --help` for everything. Builds are incremental — only changed files (and their dependencies) recompile; use `-f` if something looks stale.

## Editing content

**Add or edit a page.** Each nav section is a folder under `content/` with an `index.typ`. Every page starts by importing the template:

```typst
#import "../config.typ": template, tufted
#show: template.with(
  title: "Research",
  description: "Short summary used for the page <title> and SEO.",
)

= Research

Body text in Typst markup. Links: #link("https://example.com")[label].
```

**Add a nav item.** Edit `header-links` in `config.typ` — the key is the URL path, the value is the label. The folder name under `content/` must match the path (e.g. `/Talks/` → `content/Talks/index.typ`).

**Add a blog post.** Create `content/Writing/YYYY-MM-DD-slug/index.typ`:

```typst
#import "../index.typ": template, tufted
#show: template.with(
  title: "Post title",
  description: "One-line summary.",
  date: datetime(year: 2026, month: 5, day: 10),
)

= Post title

Your text...
```

Then add a link to it under the right year in `content/Writing/index.typ`. Posts under `/Writing/` are included in the RSS feed (`feed.xml`).

**Images.** Put them next to the `.typ` that uses them and reference with a relative path, e.g. `#image("hanqizhou.jpg")`. Photo galleries live in per-section `photos/` folders (see `content/Skiing/`, `content/Travel/`).

### Tufte features (the house style)

These are what make the site look the way it does — use them.

- **Sidenotes / margin notes** — pulls an aside into the margin without breaking the reading flow:
  ```typst
  #tufted.margin-note[Lives in the margin. Good for asides and small images.]
  ```
- **Footnotes** — `#footnote[...]` renders as a numbered margin note automatically.
- **Full-width blocks** — `#tufted.full-width[...]` spans the whole page beyond the text column (good for big figures).
- **Figures** — standard Typst `#figure(...)`; the caption renders as a margin note.
- **Table of contents** — long Writing posts get an automatic TOC (see `assets/toc.js`).
- **Dark/light theme** — handled by `assets/theme-toggle.js`; no action needed when writing.

Links to external sites or files open in a new tab automatically; internal links (`/Talks/`, anchors) stay in-page. This is handled by the template — just use `#link`.

## Deploying

Deployment is automatic: **push to the `tufted-redesign` branch** and the [`Deploy` workflow](.github/workflows/deploy.yml) builds the site and publishes it to GitHub Pages. You can also trigger it manually from the Actions tab (`workflow_dispatch`). No need to commit `_site/` — it is built in CI and gitignored.

> Note: the deploy branch is currently `tufted-redesign`, not `main`. If you make `main` the source of truth later, update the branch in `deploy.yml`.

The `Update` workflow (`update.yml`, manual only) opens a PR to sync changes from the upstream Tufted template.

## Conventions / rules of thumb

- **Edit `content/` and `config.typ`.** Leave `tufted-lib/` alone unless you're changing the engine; tweak presentation in `assets/*.css`.
- **Never edit `_site/`** — it's regenerated on every build.
- **`_hugo_archive/` is frozen** — the previous Hugo site, kept for reference. Don't build from it.
- Keep blog folder names in `YYYY-MM-DD-slug` form so they sort and date correctly.
- Preview locally (`uv run build.py preview`) before pushing.

## Credits

Built with the [Tufted-Blog-Template](https://github.com/Yousa-Mirage/Tufted-Blog-Template), [Typst](https://typst.app/), and [Tufte CSS](https://edwardtufte.github.io/tufte-css/).
