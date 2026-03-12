# Phase 1: Foundation - Research

**Researched:** 2026-03-12
**Domain:** Typst page layout, typography, line spacing
**Confidence:** HIGH

<user_constraints>
## User Constraints (from CONTEXT.md)

### Locked Decisions

**Font fallback chain:**
- System-installed Times New Roman only — do not bundle font files
- Fallback chain: "Times New Roman" → "Times" → generic serif
- Silent fallback — no warning or error if TNR is unavailable
- Add a code comment noting TNR is the required font, but no runtime check

**Spacing calibration:**
- Visually equivalent to LaTeX output, not pixel-perfect point matching
- LaTeX uses baselinestretch 2.0 (body), 1.5 (abstract), 1.0 (references/figures/tables)
- Typst par.leading values should produce the same visual feel — exact pt values may differ
- Use inline values where spacing is applied, not named constants
- Use show rules for spacing regions, not helper wrapper functions

**Template function signature:**
- Define full parameter signature upfront even though not all params are functional in Phase 1
- Parameters: title, abstract, keywords, bib, body (plus any others needed for later phases)
- Keywords as a list of strings: `keywords: ("keyword1", "keyword2")` — template formats with commas
- Bib as a parameter: `bib: "references.bib"` — template handles #bibliography() call internally
- Follows the amcis() function pattern from ambivalent-amcis

**File structure:**
- Move references.bib from project root to template/references.bib in Phase 1

### Claude's Discretion

- Whether to scaffold template/main.typ and typst.toml early or wait for Phase 4
- Whether to include a minimal test document for verifying compilation

### Deferred Ideas (OUT OF SCOPE)

None — discussion stayed within phase scope
</user_constraints>

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|-----------------|
| PAGE-01 | Document uses US Letter page size | `set page(paper: "us-letter")` — confirmed in Typst docs |
| PAGE-02 | Side margins 1 inch, top ~0.5 inch, bottom yields 9-inch text height | `set page(margin: ...)` with computed values from LaTeX source; see Margin Calculation section |
| TYPO-01 | Body text is 12pt Times New Roman | `set text(font: ("Times New Roman", "Times"), size: 12pt)` — array fallback syntax confirmed |
| TYPO-02 | Body text is double-spaced (LaTeX baselinestretch 2.0) | `set par(leading: ...)` with empirically calibrated value; requires PDF measurement to nail down |
| TYPO-03 | Abstract text is 1.5-spaced (LaTeX baselinestretch 1.5) | `show` rule scoping `set par(leading: ...)` to abstract content |
| TYPO-04 | References section text is single-spaced | `show bibliography: set par(leading: 0.65em, spacing: 0.65em)` pattern confirmed |
| TYPO-05 | Text in figures and tables is single-spaced | `show figure: set par(leading: 0.65em)` and `show table: set par(leading: 0.65em)` |
</phase_requirements>

## Summary

Phase 1 establishes the document foundation: a compilable `misq.typ` with correct page geometry, Times New Roman font with fallbacks, and calibrated line spacing for three regions. All required Typst APIs (`set page`, `set text`, `set par`, `show` rules) are stable in Typst 0.14.2 (currently installed).

The primary technical challenge is spacing calibration. Typst's `par.leading` measures the gap between the bottom edge of one line and the top of the next — not baseline-to-baseline distance as LaTeX's `\baselinestretch` does. There is no direct conversion formula. The CONTEXT.md wisely specifies "visually equivalent" rather than exact point matching. Starting values can be derived (see Spacing section), but empirical PDF comparison against the LaTeX output is the only reliable verification method.

The reference implementation (`ambivalent-amcis`) provides directly usable patterns for the function signature, `set page`, `set text`, font fallbacks, and `show` rule structure. The main difference is font (Georgia → Times New Roman) and spacing (no leading changes in amcis vs. calibrated multi-region leading in misq).

**Primary recommendation:** Structure `misq.typ` after `amcis.typ` with a single entrypoint function. Apply global `set par(leading: X)` for body double-spacing, then use `show` rules to override leading for abstract (1.5x) and figures/tables/bibliography (default/single). Compile and visually compare against the LaTeX PDF to verify leading values before locking them in.

## Standard Stack

### Core

| Library | Version | Purpose | Why Standard |
|---------|---------|---------|--------------|
| Typst | 0.14.2 (installed) | Document compiler | The entire project target platform |

### Supporting

No external Typst packages needed for Phase 1. All required functionality is in the Typst standard library.

**Installation:**

Typst is already installed at `/opt/homebrew/bin/typst`. No package installs needed for this phase.

## Architecture Patterns

### Recommended Project Structure (Phase 1)

```
typst-misq/
├── misq.typ              # Package entrypoint — the misq() function
├── template/             # (Claude's Discretion: scaffold now or Phase 4)
│   ├── main.typ          # Minimal example doc (if scaffolded)
│   └── references.bib    # Moved from project root
└── MISQ_Submission_Template_LaTeX.tex  # Source of truth (keep for reference)
```

### Pattern 1: Template Entrypoint Function

**What:** A single `#let misq(...)` function in `misq.typ` that wraps the document body using `set` and `show` rules.
**When to use:** Always — this is the package API pattern for Typst templates.
**Example (adapted from amcis.typ):**

```typst
// Source: /Users/ryanschuetzler/code/ambivalent-amcis/amcis.typ
#let misq(
  title: [Untitled],
  abstract: none,
  keywords: (),
  bib: none,
  body
) = {
  // Page layout
  set page(
    paper: "us-letter",
    margin: (x: 1in, top: 1in, bottom: 1in),
  )

  // Body text: 12pt Times New Roman with fallbacks
  // Times New Roman is required by MISQ; "Times" is the macOS/Linux fallback
  set text(font: ("Times New Roman", "Times"), size: 12pt)
  set par(justify: true)

  // Body: double-spaced (calibrate this value empirically against LaTeX output)
  set par(leading: 0.85em)  // Starting estimate — verify with PDF comparison

  // Abstract: 1.5x spaced (applied via show rule wrapping abstract content)
  // References: single-spaced
  show bibliography: set par(leading: 0.65em, spacing: 0.65em)

  // Figures and tables: single-spaced
  show figure: set par(leading: 0.65em)
  show table: set par(leading: 0.65em)

  // ... front matter rendering ...

  body

  if bib != none {
    bib
  }
}
```

### Pattern 2: Font Fallback Chain

**What:** Pass an array to `set text(font:)` — Typst tries each font in order, falling back silently.
**When to use:** Any time a specific commercial font (like TNR) is required but may not be installed.

```typst
// Source: https://typst.app/docs/reference/text/text/
// Typst does NOT support generic "serif" — must name actual fonts
set text(font: ("Times New Roman", "Times"), size: 12pt)
// If neither is found, Typst's fallback: true (default) will use best available
```

**Key fact:** Typst does NOT support generic font families like "serif". Must use real font names. The `fallback: true` default (cannot be set to silent-but-named-only) means if neither "Times New Roman" nor "Times" is found, Typst will silently use its built-in Libertinus Serif.

### Pattern 3: Scoped Spacing with Show Rules

**What:** Use `show ElementType: set par(leading: X)` to override spacing within specific content regions.
**When to use:** Whenever a document region requires different line spacing than the global default.

```typst
// Source: https://forum.typst.app/t/how-to-change-spacing-between-entries-within-bibliography/1366
// Requires Typst 0.12.0+ (we have 0.14.2)

// Single-space the bibliography
show bibliography: set par(leading: 0.65em, spacing: 0.65em)

// Single-space figure and table content
show figure: set par(leading: 0.65em)
show table: set par(leading: 0.65em)
```

For the abstract (1.5x spacing), the show rule target is `show [abstract-block]: set par(leading: Y)`. Since the abstract is passed as a parameter rather than using a named Typst element, it needs to be rendered inside a block with explicit `set par` applied:

```typst
// Abstract spacing applied inside the function body
if abstract != none {
  set par(leading: 0.55em)  // 1.5x estimate — verify empirically
  abstract
}
```

Or using a `block` wrapper with a `set par` inside it:
```typst
block({
  set par(leading: 0.55em)  // 1.5x
  abstract
})
```

### Anti-Patterns to Avoid

- **Named spacing constants:** CONTEXT.md explicitly locks inline values. Do not define `let body_leading = ...` constants.
- **Helper wrapper functions for spacing:** Use `show` rules, not functions like `double_space(content)`.
- **Bundling font files:** Do not copy TNR .ttf/.otf into the project. System-installed only.
- **Generic font family names:** `set text(font: "serif")` does not work in Typst — always use real font names.
- **`\topmargin` negative values:** LaTeX uses negative topmargin to reduce space; Typst uses direct positive margin values. Do not try to replicate the LaTeX negative trick.

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Font fallback | Custom font-detection code | `set text(font: ("TNR", "Times"))` array | Typst handles this natively |
| Scoped line spacing | Wrapper functions that set par | `show rule: set par(leading:)` | Typst's cascading set rules handle scope correctly |
| Page size | Manual width/height calculations | `set page(paper: "us-letter")` | Built-in paper size constant |
| Bibliography placement | Manual bibliography rendering | `bib` parameter passed as `#bibliography(...)` from user | Keeps bib callable outside template |

**Key insight:** Typst's set/show rule cascade is the correct mechanism for scoped styling. Fighting it with wrapper functions creates maintenance problems in later phases.

## Common Pitfalls

### Pitfall 1: Leading Measures Gap, Not Baseline Distance

**What goes wrong:** Setting `par.leading: 2em` expecting "double spacing" — this sets 2em of GAP between line bottom and next line top, producing a much larger than double-spaced result.
**Why it happens:** LaTeX's `\baselinestretch` multiplies baseline-to-baseline distance. Typst's `leading` is only the gap (space between line edges, not baselines). The actual baseline-to-baseline distance is `leading + top-edge + bottom-edge` of the text box.
**How to avoid:** Start with smaller em values and verify visually. The Typst community notes `0.65em` default produces roughly 1x single spacing visually. Empirical calibration is required.
**Warning signs:** Output looks triple or quadruple spaced when you set `leading: 2em`.

**Calibration starting points** (unverified empirically — must compare against LaTeX PDF):
- Single-space (1x): `leading: 0.65em` (Typst default)
- 1.5x spacing: `leading: 0.55em` (estimate — the 0.75em normalization formula suggests ~`1.5em - 0.75em = 0.75em` but community reports vary)
- Double-space (2x): `leading: 0.85em` (conservative estimate; `2em - 0.65em` normalization gives `1.35em` which may be too much)

**Correct approach:** The planner should include a task to compile, measure PDF line spacing against LaTeX output, and adjust. The decision context specifies "visually equivalent" — so visual comparison is the acceptance criterion, not a formula.

### Pitfall 2: Top Margin Translation from LaTeX

**What goes wrong:** Directly translating LaTeX's `\topmargin{-0.5in}` as if it means "top margin = -0.5 inch" in Typst.
**Why it happens:** LaTeX adds a 1-inch implicit offset to `\topmargin`. The effective top margin area = 1" + (-0.5") = 0.5". This 0.5" includes the `\headheight` (15pt ≈ 0.208") and `\headsep` space before the text block.
**How to avoid:** Calculate from the LaTeX `\textheight` (9 inches) and page height (11 inches): `11 - 9 = 2 inches` total for top+bottom. With 1" bottom margin → top margin = 1". For Phase 1 (no header), use `margin: (x: 1in, top: 1in, bottom: 1in)`. Phase 2 can refine top margin when headers are added.
**Warning signs:** Text area is not 9 inches tall when measured.

**LaTeX MISQ Margin Values (authoritative):**
```
Page:     8.5" x 11" US Letter
Left:     1" (oddsidemargin 0in + LaTeX 1" offset)
Right:    1" (textwidth 6.5in → 8.5 - 1 - 6.5 = 1)
Text:     6.5" wide, 9" tall
Top+Bot:  2" total (11 - 9 = 2)
```
Phase 1 target: `margin: (x: 1in, top: 1in, bottom: 1in)` → 9" text area. Phase 2 can refine top when header region is added.

### Pitfall 3: `par.spacing` vs `par.leading` Are Both Needed

**What goes wrong:** Setting only `par.leading` — the spacing between PARAGRAPHS (par.spacing, default 1.2em) remains single-spaced even when leading is set for double-spacing.
**Why it happens:** `leading` controls intra-paragraph line spacing; `spacing` controls inter-paragraph gap. Both must be set to achieve consistent double-spaced appearance.
**How to avoid:** When setting double-space body text, set both: `set par(leading: X, spacing: Y)` where Y ≈ X (so paragraph breaks look like normal lines in a double-spaced document).
**Warning signs:** Lines within a paragraph look double-spaced but gaps between paragraphs look different.

### Pitfall 4: Typst 0.12+ Required for Show-Set on Par

**What goes wrong:** Using older Typst syntax `#show par: set block(spacing: ...)` — deprecated in 0.12+.
**Why it happens:** Pre-0.12, paragraph spacing was on `block`. Post-0.12, it moved to `par(spacing:)`.
**How to avoid:** Use `set par(spacing: ...)` directly. We have 0.14.2, so this is fine.
**Warning signs:** Compiler warnings about deprecated show-set syntax.

### Pitfall 5: Font Not Confirmed in PDF

**What goes wrong:** Template compiles but body text renders in Libertinus Serif (Typst default) instead of Times New Roman, because TNR is not installed.
**Why it happens:** Typst silently falls back when named fonts are unavailable — `fallback: true` by default.
**How to avoid:** The CONTEXT.md decision says "add a code comment but no runtime check." After implementing, verify TNR is actually rendering by checking the PDF's embedded font information (e.g., `pdffonts output.pdf` on macOS) or by visual comparison.
**Warning signs:** Text looks slightly different from expected Times New Roman proportions.

## Code Examples

Verified patterns from official sources and reference implementation:

### Page Setup

```typst
// Source: https://typst.app/docs/reference/layout/page/
// Phase 1: 1" all margins → 9" text height on US Letter
set page(
  paper: "us-letter",
  margin: (x: 1in, top: 1in, bottom: 1in),
)
```

### Font with Fallback Chain

```typst
// Source: https://typst.app/docs/reference/text/text/
// "Times New Roman" is the required MISQ font (system-installed only)
// "Times" is the macOS/Linux system fallback
// Typst fallback: true (default) handles all other cases silently
set text(font: ("Times New Roman", "Times"), size: 12pt)
```

### Global Body Spacing

```typst
// Source: https://typst.app/docs/reference/model/par/
// These values are ESTIMATES — verify empirically against LaTeX PDF output
// Leading = gap between bottom of line and top of next; NOT baseline-to-baseline
set par(
  justify: true,
  leading: 0.85em,   // ~2x spacing — calibrate against LaTeX
  spacing: 0.85em,   // Inter-paragraph gap matches intra-paragraph leading
)
```

### Scoped Single-Spacing (Bibliography)

```typst
// Source: https://forum.typst.app/t/how-to-change-spacing-between-entries-within-bibliography/1366
// Requires Typst 0.12.0+ (we have 0.14.2)
show bibliography: set par(leading: 0.65em, spacing: 0.65em)
```

### Scoped Single-Spacing (Figures and Tables)

```typst
// Source: Community pattern, consistent with Typst show-set rule model
show figure: set par(leading: 0.65em)
show table: set par(leading: 0.65em)
```

### Abstract 1.5x Spacing (Show Rule on Content Block)

```typst
// The abstract is passed as a content parameter; scope the spacing with a block
// This value is an estimate — calibrate against LaTeX abstract output
block({
  set par(leading: 0.55em, spacing: 0.55em)  // ~1.5x — verify empirically
  abstract
})
```

### Full Function Signature (forward-declared parameters)

```typst
// Source: Adapted from amcis.typ (/Users/ryanschuetzler/code/ambivalent-amcis/amcis.typ)
// Parameters defined upfront per CONTEXT.md decision; not all functional in Phase 1
#let misq(
  title: [Untitled],
  abstract: none,
  keywords: (),
  bib: none,
  body,            // positional, required — must be last
) = {
  // ... set and show rules ...
  body
  if bib != none { bib }
}
```

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| `show par: set block(spacing: X)` | `set par(spacing: X)` | Typst 0.12.0 | Old syntax deprecated; use par.spacing directly |
| Single `font:` string | `font:` array for fallback | Stable | Array syntax works in all current Typst versions |

**Current Typst version:** 0.14.2 (installed). All patterns above are valid for this version.

## Open Questions

1. **Exact leading values for 2x / 1.5x / 1x at 12pt Times New Roman**
   - What we know: Default leading is 0.65em. Formula-based conversion from LaTeX baselinestretch is unreliable due to different leading models.
   - What's unclear: The exact em values that produce visually equivalent output to LaTeX baselinestretch 2.0 and 1.5 with Times New Roman at 12pt.
   - Recommendation: Planner should include a dedicated calibration task — compile misq.typ with starting values, export PDF, visually compare line spacing against the LaTeX template PDF (generate with `pdflatex MISQ_Submission_Template_LaTeX.tex`), and iterate. This is explicitly accepted by the CONTEXT.md decision ("exact pt values may differ").

2. **`par.spacing` interaction with `par.leading` for double-spacing feel**
   - What we know: Both control vertical space in a paragraph. `spacing` is inter-paragraph; `leading` is intra-paragraph.
   - What's unclear: Whether setting both to the same value produces the right visual feel for double-spacing (where a blank line between paragraphs looks like a normal line break).
   - Recommendation: Set both to the same calibrated leading value initially and adjust based on visual comparison.

3. **Abstract spacing mechanism**
   - What we know: The abstract is a content parameter, not a named Typst element like `figure`. `show figure:` scoping won't work for it.
   - What's unclear: Whether `block({ set par(...); abstract })` correctly scopes the set rule to only the abstract content.
   - Recommendation: Planner should include a verification step that confirms the abstract leading does not bleed into surrounding content.

## Validation Architecture

> nyquist_validation is absent from config.json — treated as enabled.

### Test Framework

| Property | Value |
|----------|-------|
| Framework | Manual compilation + visual PDF comparison |
| Config file | none (no automated test framework for Typst output) |
| Quick run command | `typst compile misq.typ` |
| Full suite command | `typst compile misq.typ && pdffonts misq.pdf` (if pdffonts available) |

**Note:** Typst has no automated testing framework analogous to pytest/jest. "Tests" are compile-and-inspect operations. The Typst compiler itself is the validator — if it compiles without errors, structural requirements are met. Visual requirements (spacing, font rendering) require manual PDF inspection or visual diffing tools.

### Phase Requirements → Test Map

| Req ID | Behavior | Test Type | Automated Command | File Exists? |
|--------|----------|-----------|-------------------|-------------|
| PAGE-01 | US Letter paper size | smoke | `typst compile misq.typ` (page size in output) | ❌ Wave 0 |
| PAGE-02 | 1" side margins, 9" text height | manual | Visual inspect compiled PDF ruler measurement | ❌ Wave 0 |
| TYPO-01 | 12pt Times New Roman renders | manual | `pdffonts misq.pdf` shows Times-Roman embedded | ❌ Wave 0 |
| TYPO-02 | Body double-spaced visually | manual | Compare PDF against LaTeX reference PDF | ❌ Wave 0 |
| TYPO-03 | Abstract 1.5x-spaced visually | manual | Compare abstract region against LaTeX reference PDF | ❌ Wave 0 |
| TYPO-04 | References single-spaced | manual | Visual inspect references region in compiled PDF | ❌ Wave 0 |
| TYPO-05 | Figures/tables single-spaced | manual | Visual inspect figure/table regions in compiled PDF | ❌ Wave 0 |

### Sampling Rate

- **Per task commit:** `typst compile /Users/ryanschuetzler/code/typst-misq/misq.typ` (no errors)
- **Per wave merge:** Full compile + visual PDF inspection against LaTeX reference
- **Phase gate:** All requirements confirmed visually before `/gsd:verify-work`

### Wave 0 Gaps

- [ ] `misq.typ` — the template file itself (does not exist yet)
- [ ] `template/main.typ` — minimal test document (if scaffolded per Claude's Discretion)
- [ ] `template/references.bib` — moved from project root
- [ ] LaTeX reference PDF — generate with `pdflatex MISQ_Submission_Template_LaTeX.tex` for visual comparison

*(No automated test files needed — Typst compilation itself is the primary verification mechanism)*

## Sources

### Primary (HIGH confidence)

- [Typst Page Function docs](https://typst.app/docs/reference/layout/page/) — paper, margin parameters confirmed
- [Typst Text Function docs](https://typst.app/docs/reference/text/text/) — font array syntax, fallback behavior confirmed
- [Typst Par Function docs](https://typst.app/docs/reference/model/par/) — leading, spacing parameters confirmed; default 0.65em confirmed
- [Typst Page Setup Guide](https://typst.app/docs/guides/page-setup/) — margin structure and header-ascent behavior
- `/Users/ryanschuetzler/code/ambivalent-amcis/amcis.typ` — reference implementation patterns (direct file read)
- `/Users/ryanschuetzler/code/typst-misq/MISQ_Submission_Template_LaTeX.tex` — authoritative source for all margin and spacing values (direct file read)

### Secondary (MEDIUM confidence)

- [Typst Forum: Bibliography spacing](https://forum.typst.app/t/how-to-change-spacing-between-entries-within-bibliography/1366) — `show bibliography: set par(...)` syntax verified as working in 0.12+
- [GitHub Discussion #4542: Line spacing](https://github.com/typst/typst/discussions/4542) — `set par(spacing: 2em)` current method; legacy `show par: set block(spacing:)` deprecated in 0.12+
- [Typst Forum: 1.5x spacing equivalent](https://forum.typst.app/t/whats-the-equivalent-of-ms-words-1-5-line-spacing/1057) — normalization approach documented (subtract 0.75em from desired multiplier)

### Tertiary (LOW confidence)

- Leading calibration starting values (0.85em for 2x, 0.55em for 1.5x) — derived from normalization heuristics found in community posts, not empirically verified against MISQ LaTeX output. Require calibration task.

## Metadata

**Confidence breakdown:**
- Standard stack: HIGH — Typst is the only dependency; version confirmed installed
- Architecture: HIGH — patterns directly adapted from working reference implementation (amcis.typ)
- Page/margin setup: HIGH — official docs confirm all parameters
- Font fallback: HIGH — official docs confirm array syntax and behavior
- Line spacing calibration: LOW — no reliable formula from LaTeX baselinestretch to Typst par.leading; empirical calibration required
- Show rule scoping: MEDIUM — bibliography/figure/table patterns have community verification; abstract block scoping is less well-documented

**Research date:** 2026-03-12
**Valid until:** 2026-06-12 (stable Typst APIs; check if major Typst version released)
