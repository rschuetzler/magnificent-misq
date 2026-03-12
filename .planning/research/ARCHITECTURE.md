# Architecture Research

**Domain:** Typst academic journal template package
**Researched:** 2026-03-12
**Confidence:** HIGH (based on direct inspection of reference implementation and peer packages)

## Standard Architecture

### System Overview

```
┌─────────────────────────────────────────────────────────────┐
│                      Package Root                            │
├──────────────────────┬──────────────────────────────────────┤
│  misq.typ            │  typst.toml                          │
│  (template engine)   │  (package manifest)                  │
│                      │                                       │
│  - misq() function   │  [package] metadata                  │
│  - set rules         │  entrypoint = "misq.typ"             │
│  - show rules        │  [template] path = "template"        │
│  - page layout       │  entrypoint = "main.typ"             │
│  - spacing logic     │  thumbnail = "thumbnail.png"         │
└──────────────────────┴──────────────────────────────────────┘
         │ imported by
         ▼
┌─────────────────────────────────────────────────────────────┐
│                   template/ (example document)               │
├─────────────────────────────────────────────────────────────┤
│  main.typ                       references.bib              │
│                                                              │
│  #import "@preview/misq:0.1.0": misq                        │
│  #show: misq.with(              Sample BibTeX entries        │
│    title: [...],                matching MISQ's APA          │
│    abstract: [...],             reference examples           │
│    keywords: [...],                                          │
│    bib: bibliography(...),                                   │
│  )                                                           │
│                                                              │
│  = Introduction                                              │
│  Body content here...                                        │
└─────────────────────────────────────────────────────────────┘
```

### Component Responsibilities

| Component | Responsibility | What It Does NOT Do |
|-----------|----------------|---------------------|
| `misq.typ` | All formatting rules, page layout, font config, spacing logic, heading styles, bibliography injection | Does not contain actual document content |
| `typst.toml` | Package identity (name, version, author, license, entrypoint) and template discovery metadata | Does not affect rendering |
| `template/main.typ` | Demonstrates usage; imports and calls `misq()` with sample content; serves as starting point users copy | Does not define any formatting |
| `template/references.bib` | Sample bibliography entries using MISQ-style APA references | Not part of the template engine |
| `thumbnail.png` | Preview image for the Typst package registry listing | Required by Typst registry submission |

## Recommended Project Structure

```
typst-misq/
├── misq.typ              # Template engine — all formatting logic lives here
├── typst.toml            # Package manifest
├── thumbnail.png         # Registry preview image (required for publishing)
├── LICENSE               # MIT license
├── README.md             # Usage documentation
└── template/
    ├── main.typ          # Example document users start from
    └── references.bib    # Sample BibTeX entries for APA 7th edition examples
```

### Structure Rationale

- **`misq.typ` at root:** The `typst.toml` `entrypoint` field points here. This is what users import when they write `#import "@preview/misq:0.1.0": misq`. All logic in one file keeps the package simple for its scope.
- **`template/` folder:** The Typst registry requires a `[template]` section in `typst.toml` pointing to a folder. This folder is what gets copied to a user's workspace when they start from the template. Users copy `template/main.typ` and `template/references.bib` to start writing.
- **No `src/` subdirectory:** Appropriate for a single-function template. Larger templates (e.g., `apa7-ish`) split into `src/apa7ish.typ`, `src/definitions.typ`, `src/utils.typ` — but MISQ's scope is simple enough that one file is cleaner.

## Architectural Patterns

### Pattern 1: The Wrapping Function (`#show: fn.with(...)`)

**What:** The template exposes one public function (e.g., `misq`) that takes the entire document as its final positional argument (`body`). Users apply it with `#show: misq.with(param: value)`.

**When to use:** Always. This is the canonical Typst template pattern. It lets `set` and `show` rules inside the function apply document-wide without polluting the user's namespace.

**Trade-offs:** Simple and clean. The function receives the whole document body, applies all rules, then returns the formatted result. The only downside is that parameters must all be passed at the `#show:` call site — no per-section overrides unless you design for them.

**Example:**
```typst
// misq.typ
#let misq(
  title: [Untitled],
  abstract: none,
  keywords: (),
  bib: none,
  body            // <-- the whole document flows in here
) = {
  // All set/show rules go inside this function body
  set page(paper: "us-letter", margin: 1in, ...)
  set text(font: "Times New Roman", size: 12pt)
  set par(leading: 2em - 1em)  // double-spacing approximation

  // Render title block
  align(center)[#text(weight: "bold")[#title]]

  // Render abstract with different spacing
  if abstract != none {
    set par(leading: 0.5em)  // 1.5x spacing for abstract
    abstract
  }

  // Body flows here
  body

  // Bibliography at end
  if bib != none {
    set par(leading: 0em)    // single-spacing for references
    set par(hanging-indent: 0.5in)
    heading("REFERENCES", level: 1)
    set bibliography(title: none, style: "apa")
    bib
  }
}
```

### Pattern 2: Scoped Spacing Overrides

**What:** Different sections of an MISQ paper require different line spacing — 2x for body, 1.5x for abstract, 1x for references. In Typst, line spacing is controlled by `par.leading` (the gap between baselines beyond the text size itself). You scope changes using content blocks.

**When to use:** Whenever a section needs spacing that differs from the document default.

**Trade-offs:** Typst's `leading` is the *extra* space between lines, not a multiplier. For 12pt text, double-spacing means ~24pt total line height, so `leading` = 24pt - 12pt (cap-height) minus descenders — in practice, `leading: 1em` applied with `set text(top-edge: "cap-height", bottom-edge: "baseline")` approximates it. Exact values require testing against reference output. The `apa7-ish` package sets `set text(top-edge: 1em, bottom-edge: "baseline")` with very tight `leading` (2pt) for dense spacing — the opposite end of the spectrum.

**Example:**
```typst
// In misq() function body:

// 1.5x spacing for abstract section
if abstract != none {
  [
    #set par(leading: 0.65em)  // calibrate for 1.5x visual appearance
    #abstract
  ]
}

// 2x spacing restored for body
[
  #set par(leading: 1.2em)   // calibrate for 2x visual appearance
  #body
]

// 1x (single) spacing for references
[
  #set par(leading: 0.65em, hanging-indent: 0.5in)
  #set bibliography(title: none, style: "apa")
  #bib
]
```

### Pattern 3: Show Rules for Heading Styles

**What:** Use `show heading.where(level: N)` with `set text(...)` and `align(...)` to apply MISQ's three heading styles declaratively. Level 1 = centered bold uppercase, level 2 = centered bold, level 3 = left-aligned bold.

**When to use:** All heading formatting. Show rules are composable — they stack correctly and the `.where()` selector narrows to specific levels.

**Trade-offs:** `show heading.where(level: 1): set text(...)` only sets text properties. For alignment and text transformation (uppercase), you need `show heading.where(level: 1): it => align(center)[#upper(it.body)]` — a transform rule, not just a set rule. The `it.body` pattern is required to avoid rendering the `heading` wrapper itself.

**Example:**
```typst
// Level 1: centered, bold, uppercase (normalsize = 12pt)
show heading.where(level: 1): it => {
  v(1em, weak: true)
  align(center)[#text(weight: "bold", size: 12pt)[#upper(it.body)]]
  v(0.5em, weak: true)
}

// Level 2: centered, bold (normalsize)
show heading.where(level: 2): it => {
  v(0.75em, weak: true)
  align(center)[#text(weight: "bold", size: 12pt)[#it.body]]
  v(0.5em, weak: true)
}

// Level 3: left-aligned, bold (normalsize)
show heading.where(level: 3): set text(weight: "bold", size: 12pt)
```

### Pattern 4: Bibliography as a Parameter

**What:** Accept the `bibliography(...)` call as a named parameter rather than hardcoding it. Users pass `bib: bibliography("./references.bib")` at the `#show:` call site. The template function injects it at the end with the correct style.

**When to use:** Always, in academic templates. It gives users control over which `.bib` file they use while the template enforces APA style.

**Trade-offs:** Typst's `bibliography()` function can only be called once per document — this is a known constraint. Accepting it as a parameter lets the template control placement and style injection without the user needing to know the correct `style:` argument.

**Example:**
```typst
// In misq() function signature:
#let misq(
  ...
  bib: none,
  body
) = {
  ...
  body
  if bib != none {
    set bibliography(title: none, style: "apa")  // enforce APA 7th ed
    bib
  }
}

// In template/main.typ:
#show: misq.with(
  ...
  bib: bibliography("./references.bib"),
)
```

## Data Flow

### Document Rendering Flow

```
template/main.typ
    |
    | #import "misq.typ": misq
    | #show: misq.with(title: ..., abstract: ..., bib: ...)
    |
    v
misq() function receives (title, abstract, keywords, bib, body)
    |
    | 1. Apply set rules (page, text, par) — document-wide defaults
    | 2. Apply show rules (headings, links, figures)
    | 3. Render title block
    | 4. Render abstract block (with scoped 1.5x spacing)
    | 5. Render keywords line
    | 6. page break
    | 7. Render body (with 2x spacing active)
    | 8. Render bibliography (with 1x spacing + hanging indent)
    |
    v
Typst engine compiles to PDF
```

### Key Data Flows

1. **Title/metadata:** Passed as named parameters to `misq()`, rendered inline at top of document before page break.
2. **Body content:** Flows through the `body` parameter — everything after `#show: misq.with(...)` in `main.typ` is captured as `body`.
3. **Bibliography:** Passed as a `bibliography(...)` call object, injected by the template at the end with `style: "apa"` override applied.
4. **Spacing context:** Set rules inside scoped blocks `[...]` override the document default for that content block only — no explicit scope-exit needed.

## Component Boundaries: misq.typ vs template/main.typ

| Concern | misq.typ | template/main.typ |
|---------|----------|-------------------|
| Page margins, paper size | YES | No |
| Font family and size | YES | No |
| Line spacing values | YES | No |
| Heading show rules | YES | No |
| Bibliography style injection | YES | No |
| Page numbering | YES | No |
| Title/abstract rendering logic | YES | No |
| Title content (actual words) | No | YES |
| Abstract content | No | YES |
| Keywords list | No | YES |
| Section headings and body text | No | YES |
| Which .bib file to use | No | YES |
| Import statement | No | YES |

**Rule:** If it is formatting or layout, it belongs in `misq.typ`. If it is content or configuration specific to a document instance, it belongs in `template/main.typ`.

## Build Order (Component Dependencies)

Build in this order — each step depends on the previous:

```
1. typst.toml
   (no dependencies — pure metadata)

2. misq.typ
   (depends only on Typst builtins — no external imports)
   Build order within misq.typ:
   a. page set rule (margins, numbering, paper size)
   b. text set rule (font, size)
   c. par set rule (document-default spacing = 2x body)
   d. heading set rule (numbering: none)
   e. show rules for heading levels 1, 2, 3
   f. title rendering block
   g. abstract block (scoped 1.5x par)
   h. keywords line
   i. pagebreak
   j. body
   k. bibliography block (scoped 1x par + hanging indent)

3. template/references.bib
   (no Typst dependencies — standalone BibTeX)

4. template/main.typ
   (depends on misq.typ being complete and importable)
   - Import misq.typ
   - Fill in sample content exercising all heading levels
   - Include sample citations from references.bib

5. thumbnail.png
   (depends on template/main.typ rendering correctly)
   - Compile template/main.typ to PDF
   - Screenshot first page as PNG
   - Required for Typst registry submission
```

## Anti-Patterns

### Anti-Pattern 1: Hardcoding Bibliography Path

**What people do:** Put `bibliography("references.bib", style: "apa")` directly inside `misq.typ`.

**Why it's wrong:** The path is relative to the file that calls it. When `misq.typ` is installed as a package, the path resolves relative to the package directory, not the user's project. The bibliography file won't be found.

**Do this instead:** Accept `bib: none` as a parameter. Users pass `bib: bibliography("./references.bib")` from `main.typ` where the path is in their project.

### Anti-Pattern 2: Using `baselinestretch` Thinking (LaTeX Mental Model)

**What people do:** Try to apply a 2.0x line-spacing multiplier the way LaTeX's `\baselinestretch{2.0}` works.

**Why it's wrong:** Typst's `par.leading` is the *extra space between lines* beyond what the font naturally occupies — it is not a multiplier of font size. For 12pt text, double-spacing is approximately 24pt baseline-to-baseline, so `leading` must be calibrated by testing, not calculated as `2.0 * 12pt`.

**Do this instead:** Set `par.leading` empirically. A starting point: for 12pt Times New Roman, `leading: 1.0em` (≈ 12pt extra) gives approximately double-spaced output. Verify against a PDF measurement of the LaTeX reference.

### Anti-Pattern 3: Applying Spacing with show Rules on `par`

**What people do:** `show par: it => { set par(leading: ...); it }` — trying to make spacing context-sensitive via show rules on paragraphs.

**Why it's wrong:** Show rules on `par` apply to every paragraph including those inside heading show rules, figures, and captions, causing unexpected tight or wide spacing in those contexts.

**Do this instead:** Use content blocks `[...]` with `set par(leading: ...)` inside to scope spacing changes. Use this for the abstract section (1.5x) and bibliography section (1x). Let the document-level `set par(leading: ...)` handle body text (2x).

### Anti-Pattern 4: Unnested Show Rules for Multiple Heading Properties

**What people do:** Write separate `show heading.where(level: 1): set text(...)` and another `show heading.where(level: 1): it => align(center)[...]` expecting them to compose.

**Why it's wrong:** Multiple show rules on the same selector do not always compose predictably — the second rule receives the output of the first, which may already be a block element, breaking alignment.

**Do this instead:** Use a single transform rule `show heading.where(level: 1): it => { ... }` that handles all properties (spacing, alignment, text style, uppercase) for that level in one place.

## Integration Points

### External Dependencies

| Dependency | Integration | Notes |
|------------|-------------|-------|
| Times New Roman font | System font or bundled | Must be present on the user's system. The Typst app includes it; local compilation requires the font installed. Consider documenting this requirement in README. |
| APA 7th edition CSL | Built into Typst stdlib as `"apa"` | Typst ships with built-in APA style. No external CSL file needed unless customizing. The amcis template uses a custom `new-apa.csl` in the template folder — MISQ may need similar customization if the built-in APA doesn't match exactly. |
| Typst compiler | `>=0.11.0` recommended | Set `compiler` field in `typst.toml` to the minimum version tested against. |

### Internal Boundaries

| Boundary | Communication | Notes |
|----------|---------------|-------|
| `typst.toml` → `misq.typ` | `entrypoint` field declares which file is the package root | One-way declaration |
| `typst.toml` → `template/main.typ` | `[template].entrypoint` declares the example document | One-way declaration |
| `template/main.typ` → `misq.typ` | `#import "@preview/misq:0.1.0": misq` | After publishing; during development use `#import "../misq.typ": misq` |
| `misq.typ` → APA style | `set bibliography(style: "apa")` or custom CSL | Built-in APA may need verification against MISQ's specific citation style expectations |

## Sources

- Direct inspection of `rschuetzler/ambivalent-amcis` (reference implementation): `amcis.typ`, `typst.toml`, `template/main.typ` — HIGH confidence
- Direct inspection of `typst/packages` — `charged-ieee` v0.1.2: `lib.typ`, `typst.toml` — HIGH confidence
- Direct inspection of `typst/packages` — `apa7-ish` v0.3.0: `src/apa7ish.typ`, `src/definitions.typ` — HIGH confidence
- Typst package registry structure: https://github.com/typst/packages — HIGH confidence
- MISQ LaTeX template (`MISQ_Submission_Template_LaTeX.tex`) for layout requirements — HIGH confidence (source material)

---
*Architecture research for: Typst academic journal template package (MISQ)*
*Researched: 2026-03-12*
