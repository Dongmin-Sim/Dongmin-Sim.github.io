# Design System: Blog

## Direction

Typography-first, book-like reading experience.
Text earns its place. No decoration without purpose.
Light mode, warm neutral palette, borders-only depth.

## Foundation

Warm neutral — paper-like warmth, not clinical white.

## Colors

| Token              | Value     | Role                    |
|--------------------|-----------|-------------------------|
| `color-bg`         | `#faf9f7` | Page background         |
| `color-surface`    | `#f5f4f0` | Header, footer, code bg |
| `color-border`     | `#e0dfd8` | All borders             |
| `color-heading`    | `#1a1916` | Headings, hover text    |
| `color-body`       | `#3d3c38` | Body text, link text    |
| `color-muted`      | `#9a9890` | Meta, nav, captions     |
| `color-link-under` | `#c8c6be` | Link underline default  |

## Typography

| Role       | Family                          | Weight  |
|------------|---------------------------------|---------|
| Body       | Noto Serif, Noto Serif KR       | 400     |
| Headings   | Noto Serif, Noto Serif KR       | 700     |
| Code       | JetBrains Mono                  | 400     |

### Scale

| Element    | Mobile    | Desktop   |
|------------|-----------|-----------|
| Body       | 16px      | 17px      |
| H1         | 1.5rem    | 1.65rem   |
| H2         | 1.25rem   | 1.3rem    |
| H3         | 1.06rem   | 1.06rem   |
| Meta/nav   | 0.82rem   | 0.82rem   |
| Nav links  | 0.88rem   | 0.88rem   |
| Code inline| 0.875em   | 0.875em   |
| Code block | 0.84em    | 0.84em    |

### Line Heights

- Body: 1.75 (generous for Korean mixed text)
- Headings: 1.3
- Post list titles: 1.4
- Code blocks: 1.6

## Spacing

Unit: `em` (scales with font size).

| Use case           | Value    |
|--------------------|----------|
| Paragraph gap      | 1.5em    |
| Section gap (h2)   | 2em top  |
| Content padding    | 24px (mobile), auto margins (desktop) |
| Post list item gap | 1.75em   |
| Header padding     | 2em top, 1.5em bottom |
| Footer margin-top  | 4em      |

## Layout

- Content max-width: 640px, centered
- Breakpoint: 720px
- Mobile padding: 24px sides
- Single column, no sidebar

## Depth

Borders only. Zero box-shadows.

| Pattern          | Style                    |
|------------------|--------------------------|
| Horizontal rule  | 1px solid `color-border` |
| Header/footer    | 1px solid `color-border` |
| Code inline      | 1px solid `color-border` |
| Blockquote       | 2px solid `color-border` |

## Radius

- Inline code: 3px
- Code blocks: 4px
- Nothing else uses radius

## Patterns

### Header
- Flex row, space-between, baseline aligned
- Site title: 1rem, weight 700, no underline
- Nav links: 0.88rem, muted color, no underline

### Post List (Home)
- No borders, no cards
- Title: 1rem, weight 400, heading color
- Date below title: 0.82rem, muted, Korean format (YYYY년 MM월 DD일)
- Items separated by 1.75em whitespace

### Post Page
- Date above title: 0.82rem, muted
- Title: h1
- Content follows with 2.5em gap from header
- Tags at bottom: separated by top border, 0.82rem, muted

### Code Block
- Background: `color-surface`
- Border: 1px solid `color-border`
- Padding: 1em
- Radius: 4px
- Horizontal scroll on overflow

### Blockquote
- Left border: 2px solid `color-border`
- Italic, muted color
- Left padding: 1.25em

### Links
- Same color as body text
- Underline color: `color-link-under`
- Hover: heading color, darker underline
- Understated — no bright blue
