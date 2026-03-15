# Design System — Blog

Typography-first, book-like reading experience.
Warm neutral palette, borders-only depth, no decoration without purpose.

## Colors

| Token | Value | Usage |
|-------|-------|-------|
| `$color-bg` | `#faf9f7` | Page background |
| `$color-surface` | `#f5f4f0` | Table headers, code block bg |
| `$color-border` | `#e0dfd8` | All borders, dividers |
| `$color-heading` | `#1a1916` | Headings, titles, link text |
| `$color-body` | `#3d3c38` | Body text, hover states |
| `$color-muted` | `#9a9890` | Meta text, captions, nav, dates |
| `$color-link-underline` | `#c8c6be` | Default link underline |
| `$color-link-underline-hover` | `#9a9890` | Hover link underline |
| `$color-code-inline-bg` | `#efede8` | Inline code background |
| `$color-code-inline` | `#4a4845` | Inline code text |

All colors must be tokens in `_variables.scss`. No hardcoded hex in component files (except `_syntax.scss`).

## Typography

### Fonts
- Body: `Noto Serif`, `Noto Serif KR`, Georgia, serif
- Code: `JetBrains Mono`, Menlo, monospace

### Font Size Scale
| Size | Usage | Frequency |
|------|-------|-----------|
| `0.82rem` | Meta, dates, counts, labels | 10x |
| `0.85rem` | Descriptions, captions | 2x |
| `0.88rem` | Nav links, secondary text | 6x |
| `1rem` | Body titles, site title | 4x |
| `1.06rem` | H3 | 2x |
| `1.25rem` / `1.3rem` | H2 (mobile / desktop) | — |
| `1.5rem` / `1.65rem` | H1 (mobile / desktop) | — |
| `3rem` | 404 page number | 1x |
| `0.78rem` | TOC links (intentional exception) | 1x |

### Font Weights
- `400` — body text, titles
- `700` — headings, strong emphasis

### Line Heights
- `1.75` — body text
- `1.5` — lists, descriptions
- `1.4` — post list titles
- `1.3` — headings
- `1.6` — code blocks

## Spacing

Base unit: `0.25em`, scaled by multiplier.

| Value | Frequency | Usage |
|-------|-----------|-------|
| `0.25em` | 4x | Small inner gaps |
| `0.5em` | 7x | Tight spacing |
| `0.75em` | 3x | Medium inner gaps |
| `1em` | 4x | Standard gap |
| `1.25em` | 3x | Component padding |
| `1.5em` | 14x | Section padding, paragraph margin |
| `2em` | 4x | Section heading margin-top |
| `2.5em` | 5x | Section gaps |
| `3em` | 3x | Large section breaks |
| `4em` | 2x | Footer/page level spacing |

Mobile padding: `24px` (`$padding-mobile`).

## Depth

**Borders only.** Zero box-shadows.

- Dividers: `1px solid $color-border`
- Component borders: `1px solid $color-border`
- Blockquote: `2px solid $color-border` (left border)

## Radius

`4px` — the only value. Thumbnails, series-nav, code blocks, inline code.

## Breakpoints

| Token | Value | Usage |
|-------|-------|-------|
| `$bp-desktop` | `720px` | Font size bump, typography |
| `$bp-toc` | `1100px` | TOC visibility |

## Layout

- Content width: `640px` (`$content-width`)
- TOC width: `200px`, gap `48px` from content
- Container: centered with `$padding-mobile` horizontal padding

## Patterns

### Link Hover (6 components)
```scss
text-decoration: underline;
text-decoration-color: $color-link-underline-hover;
text-underline-offset: 3px;
text-decoration-thickness: 1px;
```

### Nav Link (muted → body on hover)
```scss
color: $color-muted;
text-decoration: none;
&:hover { color: $color-body; }
```

### Caption (images and tables)
```scss
display: block;
text-align: center;
font-size: 0.85em;
color: $color-muted;
font-style: italic;
margin-top: 0.4em;
```

### Section Divider
```scss
margin-top: 3em;
padding-top: 1.5em;
border-top: 1px solid $color-border;
```

## Syntax Highlighting

Warm neutral theme in `_syntax.scss`. Standalone — does not use design tokens.

| Role | Color |
|------|-------|
| Base text | `#4a4845` |
| Comments | `#9a9890` (italic) |
| Keywords | `#7a6858` |
| Strings | `#5a7a38` |
| Numbers | `#7a6040` |
| Types/Classes | `#8a7028` |
| Errors | `#a0522d` |
