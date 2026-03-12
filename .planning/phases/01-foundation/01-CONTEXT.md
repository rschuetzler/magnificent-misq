# Phase 1: Foundation - Context

**Gathered:** 2026-03-12
**Status:** Ready for planning

<domain>
## Phase Boundary

A compilable `misq.typ` stub with correct page geometry (US Letter, 1" margins), Times New Roman at 12pt with font fallbacks, and calibrated line spacing for all three spacing regions (body 2x, abstract 1.5x, references/figures/tables 1x). No headings, no title page layout, no citations — those come in later phases.

</domain>

<decisions>
## Implementation Decisions

### Font fallback chain
- System-installed Times New Roman only — do not bundle font files
- Fallback chain: "Times New Roman" → "Times" → generic serif
- Silent fallback — no warning or error if TNR is unavailable
- Add a code comment noting TNR is the required font, but no runtime check

### Spacing calibration
- Visually equivalent to LaTeX output, not pixel-perfect point matching
- LaTeX uses baselinestretch 2.0 (body), 1.5 (abstract), 1.0 (references/figures/tables)
- Typst par.leading values should produce the same visual feel — exact pt values may differ
- Use inline values where spacing is applied, not named constants
- Use show rules for spacing regions, not helper wrapper functions

### Template function signature
- Define full parameter signature upfront even though not all params are functional in Phase 1
- Parameters: title, abstract, keywords, bib, body (plus any others needed for later phases)
- Keywords as a list of strings: `keywords: ("keyword1", "keyword2")` — template formats with commas
- Bib as a parameter: `bib: "references.bib"` — template handles #bibliography() call internally
- Follows the amcis() function pattern from ambivalent-amcis

### File structure
- Move references.bib from project root to template/references.bib in Phase 1
- Claude's Discretion: whether to scaffold template/main.typ and typst.toml early or wait for Phase 4
- Claude's Discretion: whether to include a minimal test document for verifying compilation

</decisions>

<specifics>
## Specific Ideas

- Follow the ambivalent-amcis package structure pattern (root .typ definition + template/ folder)
- LaTeX template source is available at `MISQ_Submission_Template_LaTeX.tex` with exact margin values: topmargin -0.5in, oddsidemargin 0in, textwidth 6.5in, textheight 9in, headheight 15pt
- The amcis template uses `new-apa.csl` in template/ for APA citations — same approach planned for Phase 3

</specifics>

<code_context>
## Existing Code Insights

### Reusable Assets
- `MISQ_Submission_Template_LaTeX.tex`: Source of truth for all formatting values (margins, spacing, heading styles)
- `references.bib`: 2 sample MISQ references (Brown 2023, Gupta 2018) — will move to template/
- `ambivalent-amcis` (sibling project): Working reference for Typst package structure, function signature pattern, typst.toml format

### Established Patterns
- ambivalent-amcis uses a single entrypoint function (`amcis()`) that wraps document with `set` and `show` rules
- Parameters include front matter (title, abstract, keywords), bib path, and body content
- typst.toml declares entrypoint, template path, and package metadata

### Integration Points
- misq.typ at root is the package entrypoint
- template/main.typ will import and call misq()
- references.bib moves to template/ for use by the example document

</code_context>

<deferred>
## Deferred Ideas

None — discussion stayed within phase scope

</deferred>

---

*Phase: 01-foundation*
*Context gathered: 2026-03-12*
