# Stack Research

**Domain:** Typst academic journal template package
**Researched:** 2026-03-12
**Confidence:** HIGH (primary source: installed Typst 0.14.2, direct inspection of ambivalent-amcis reference implementation, Typst package cache)

## Recommended Stack

### Core Technologies

| Technology | Version | Purpose | Why Recommended |
|------------|---------|---------|-----------------|
| Typst | 0.14.2 | Document typesetting and compilation | Installed version on this machine; use `compiler = "0.13.0"` or similar in typst.toml as minimum, not pinned to exact version |
| typst.toml | — | Package manifest | Required for all Typst packages; governs name, version, entrypoint, categories, disciplines, thumbnail |
| BibTeX / `.bib` | — | Bibliography database | Standard format; Typst's built-in `bibliography()` function natively parses `.bib` files |
| CSL (Citation Style Language) | 1.0 | Citation and bibliography formatting | Typst supports CSL files directly in `bibliography(style: "path/to/file.csl")`; the official APA 7th CSL from Zotero (updated 2024-07-09) is what ambivalent-amcis uses and is the correct choice |

### Supporting Libraries

| Library | Version | Purpose | When to Use |
|---------|---------|---------|-------------|
| No external Typst packages required | — | — | This template uses only Typst built-ins: `set page()`, `set text()`, `set par()`, `show heading`, `bibliography()`, `figure()`, `table()` |

**Rationale for zero external dependencies:** The ambivalent-amcis reference implementation (confirmed by inspection) imports no packages from `@preview/`. It relies entirely on Typst built-in functions. This is correct practice for academic templates — fewer dependencies means fewer breakage vectors and simpler user setup. Do the same for MISQ.

### Development Tools

| Tool | Purpose | Notes |
|------|---------|-------|
| typst CLI 0.14.2 | Compile `.typ` to PDF | Installed via Homebrew at `/opt/homebrew/Cellar/typst/0.14.2/bin/typst`. Use `typst watch template/main.typ` for live preview |
| `typst fonts` | List available system fonts | Use to verify "Times New Roman" is detected before setting `font: "Times New Roman"` |
| Local package symlink | Dev testing without publishing | Symlink project dir into `~/Library/Application Support/typst/packages/local/<name>/<version>/`, then import as `@local/<name>:<version>` |

## Installation

```bash
# No npm/pip — this is a pure Typst project.
# Install Typst via Homebrew (macOS):
brew install typst

# Verify version:
typst --version
# → Typst 0.14.2

# Verify Times New Roman is present:
typst fonts | grep "Times New Roman"

# Local dev: symlink the package so you can test with @local import
mkdir -p ~/Library/Application\ Support/typst/packages/local/misq/0.1.0
ln -s /Users/ryanschuetzler/code/typst-misq ~/Library/Application\ Support/typst/packages/local/misq/0.1.0
# Then in template/main.typ: #import "@local/misq:0.1.0": misq
```

## Alternatives Considered

| Recommended | Alternative | When to Use Alternative |
|-------------|-------------|-------------------------|
| Custom CSL file (new-apa.csl from Zotero) | Built-in `style: "apa"` string | Use the built-in "apa" only if Typst's bundled APA matches APA 7th exactly — it may not. The amcis pattern uses an explicit CSL file for control. Use a custom CSL for verified APA 7th output. |
| Times New Roman (system font) | Bundling font files in `fonts/` | Bundle only if targeting environments without Times New Roman (e.g., Linux CI). On macOS/Windows, Times New Roman is a system font. MISQ submitters are likely on those platforms. Include `fonts/` dir as optional but exclude from package with `exclude = ["fonts/"]` in typst.toml. |
| Zero external package deps | `@preview/` packages | Add packages only if a built-in solution is missing (e.g., complex table formatting). None needed for the MISQ requirements. |
| `.bib` BibTeX format | Hayagriva `.yml` format | BibTeX is ubiquitous in academic workflows; Zotero, Mendeley, and Google Scholar all export it. Typst supports both, but `.bib` has better ecosystem support. |

## What NOT to Use

| Avoid | Why | Use Instead |
|-------|-----|-------------|
| `set par(leading: ...)` alone for line spacing | Typst's `par.leading` controls space between lines in a paragraph but does not replicate LaTeX's `\baselinestretch`. Use `set par(leading: Xem)` with calibrated values. For double-spacing at 12pt, `leading: 1.0em` produces approximately 2× line height (baseline-to-baseline = font size + leading). Test empirically. | `set par(leading: 1.0em)` for body (double-spaced), `leading: 0.65em` for abstract (1.5-spaced), `leading: 0em` for references (single-spaced) — verify by measuring compiled PDF |
| `set text(size: 12pt)` without specifying font | Without `font: "Times New Roman"`, Typst falls back to its embedded "Linux Libertine" serif. MISQ requires Times New Roman. | `set text(font: "Times New Roman", size: 12pt)` |
| Hardcoding heading styles with `text()` blocks | Bypasses Typst's heading show rules; breaks outline/accessibility features. | Use `show heading.where(level: 1): it => ...` pattern to style headings while keeping them semantic |
| `@preview/` packages for bibliography | Adds unnecessary dependency; Typst's built-in `bibliography()` handles APA via CSL. Packages like `citegeist` or `pergamon` are for edge cases. | Built-in `bibliography("refs.bib", style: "apa7.csl", title: none)` |
| Embedding fonts in the published package | Typst package format does NOT support embedded fonts; fonts are always referenced from the user's system or a `fonts/` directory the user provides. Attempting to bundle fonts in the package root will not automatically make them available. | Document in README that users need Times New Roman (system font on macOS/Windows); provide optional `fonts/` folder in template dir with instructions |

## Stack Patterns by Variant

**For the `misq.typ` entrypoint (template function definition):**
- Define a single `#let misq(title, abstract, keywords, bib, doc) = { ... }` function
- Use `set` rules inside the function body to scope all formatting to the document
- Accept `bib` as a parameter (following amcis pattern) so the user passes `bibliography(...)` from their main.typ
- This keeps the entrypoint clean and testable

**For the `template/main.typ` (example document):**
- Import from `@local/misq:0.1.0` during development, switch to `@preview/misq:0.1.0` for publication
- Keep a working `references.bib` in `template/` alongside `main.typ`
- Keep the CSL file (`apa7.csl` or similar) in `template/` — it must be co-located with the `.bib` file, not in the package root

**For font handling:**
- Times New Roman is a system font on macOS (confirmed: `/System/Library/Fonts/Supplemental/Times New Roman.ttf`) and Windows
- Provide a `fonts/` directory in the template folder as optional fallback for Linux/CI environments
- Add `exclude = ["template/main.pdf", "fonts/"]` to `typst.toml` so font files are not distributed with the package (same pattern as amcis)

**For line spacing (critical for MISQ compliance):**
- Body text (double-spaced): `set par(leading: 1.0em)` — test against printed output
- Abstract (1.5-spaced): override with `set par(leading: 0.65em)` in a scoped block
- References (single-spaced): override with `set par(leading: 0.5em)` in references block
- Note: Typst's `leading` is additional space between lines, not total line height. At 12pt, "single-spaced" ≈ `leading: 0.5em`, "double-spaced" ≈ `leading: 1.0em`. These need empirical tuning against the LaTeX reference.

## Version Compatibility

| Component | Minimum Version | Notes |
|-----------|-----------------|-------|
| Typst | 0.13.0 | Set `compiler = "0.13.0"` in typst.toml as minimum; 0.13 is when `context` keyword stabilized and `show heading.where()` pattern works reliably. ambivalent-amcis 0.1.0 omits `compiler` field; add it for MISQ |
| CSL format | 1.0 | APA CSL from Zotero (updated 2024-07-09) is CSL 1.0 and confirmed working in ambivalent-amcis |
| BibTeX `.bib` | — | No version concerns; Typst's built-in parser handles standard BibTeX |

## Key Typst Built-in APIs Used

These are the specific Typst built-in functions this template will rely on (all verified available in Typst 0.14.2):

```typst
// Page layout
set page(paper: "us-letter", margin: (x: 1in, y: 1in), numbering: "1", number-align: center)

// Font and body text
set text(font: "Times New Roman", size: 12pt)
set par(justify: true, leading: 1.0em)     // double-spaced body

// Heading styles (no numbering, specific alignment/case)
set heading(numbering: none)
show heading.where(level: 1): it => align(center)[#upper(strong(it.body))]
show heading.where(level: 2): it => align(center)[#strong(it.body)]
show heading.where(level: 3): it => strong(it.body)   // left-aligned bold

// Bibliography
bibliography("./references.bib", style: "apa7.csl", title: none)

// In-text citations (user syntax)
@brown2023fault           // → (Brown & Sias, 2023)
#cite(<brown2023fault>, form: "prose")   // → Brown and Sias (2023)
#cite(<brown2023fault>, form: "year")    // → 2023
```

## Sources

- Direct inspection of `typst.toml`, `amcis.typ`, `template/main.typ` in `/Users/ryanschuetzler/code/ambivalent-amcis/` — HIGH confidence (primary source, owner's own template)
- Typst 0.14.2 CLI installed at `/opt/homebrew/Cellar/typst/0.14.2/` — HIGH confidence (running version)
- `typst fonts` output confirming "Times New Roman" as system font — HIGH confidence
- `typst info` output showing package paths and embedded font support — HIGH confidence
- Cached packages at `/Users/ryanschuetzler/Library/Caches/typst/packages/preview/` (ambivalent-amcis 0.1.0, citegeist 0.2.1, pergamon 0.7.2) examined for manifest format patterns — HIGH confidence
- `new-apa.csl` from ambivalent-amcis template (Zotero APA 7th CSL, updated 2024-07-09) — HIGH confidence
- MISQ LaTeX template `MISQ_Submission_Template_LaTeX.tex` — HIGH confidence (official source document for formatting requirements)
- Note: WebSearch and WebFetch were unavailable during this research session. Findings are based entirely on local sources (installed software, reference implementation, official template). No web-sourced claims are made.

---
*Stack research for: Typst academic journal template package (MISQ)*
*Researched: 2026-03-12*
