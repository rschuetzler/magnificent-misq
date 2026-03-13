# Phase 3: Citations - Context

**Gathered:** 2026-03-13
**Status:** Ready for planning

<domain>
## Phase Boundary

Working APA 7th citations from a `.bib` file using a bundled CSL, with the references section single-spaced and hanging-indented, output verified against MISQ's sample reference entries. No new document structure, no new parameters — just citations and bibliography formatting.

</domain>

<decisions>
## Implementation Decisions

### CSL source
- Bundle `new-apa.csl` from the ambivalent-amcis project (proven to work with Typst)
- Place CSL file at project root alongside `misq.typ` — part of the package, not a template resource
- Copy the file from ambivalent-amcis with one required modification: change `hanging-indent="true"` to `hanging-indent="false"` on line 2107 (required for Typst hanging indent show rule to function — see GitHub issue #2639)

### Citation style application
- Auto-apply the bundled CSL via a show rule in `misq.typ` so authors don't need to specify `style:`
- Allow author overrides — if an author explicitly passes `style:` to `#bibliography()`, their choice should win
- Authors still call `#bibliography("references.bib")` explicitly (Phase 2 decision: no `bib` parameter)

### Hanging indent
- Auto-apply 0.5-inch left hanging indent on bibliography entries via a show rule in `misq.typ`
- Consistent with how single-spacing is already auto-applied (TYPO-04)
- Satisfies TYPO-06 requirement

### REFERENCES heading
- Auto-format the bibliography title: centered, bold, uppercase — via show rule in `misq.typ`
- Auto-uppercase whatever title text the author passes (e.g., `title: "References"` renders as "REFERENCES")
- No automatic page break before bibliography — authors handle `#pagebreak()` manually
- This simplifies template/main.typ: remove the manual `#align(center, text(...)[REFERENCES])` line

### Claude's Discretion
- Exact show rule implementation for CSL auto-application with override support
- How to implement hanging indent in Typst (par indent vs. block-level approach)
- Verification approach for comparing output against LaTeX template's sample references
- Whether to expand references.bib with more entry types (book, conference, etc.) for testing

</decisions>

<specifics>
## Specific Ideas

- Source `new-apa.csl` from the ambivalent-amcis sibling project (same author's prior work)
- LaTeX template shows exact reference formatting: `\hangindent=0.5in \hangafter=1` with two sample MISQ references (Brown 2023, Gupta 2018)
- The existing show rule `show bibliography: set par(leading: 0.65em, spacing: 0.65em)` in misq.typ already handles single-spacing; Phase 3 extends this with hanging indent and CSL

</specifics>

<code_context>
## Existing Code Insights

### Reusable Assets
- `misq.typ` line 46: `show bibliography: set par(leading: 0.65em, spacing: 0.65em)` — existing single-spacing show rule to extend
- `template/references.bib`: 2 sample MISQ articles (Brown 2023, Gupta 2018) matching LaTeX template
- `template/main.typ` line 104: `#bibliography("references.bib", style: "apa", title: none)` — current explicit call to update
- `MISQ_Submission_Template_LaTeX.tex` lines 76-84: Reference formatting with exact hangindent values
- ambivalent-amcis project: `new-apa.csl` file to copy

### Established Patterns
- Show rules for bibliography styling (Phase 1 pattern) — extend with hanging indent and CSL
- Inline values rather than named constants (Phase 1 decision)
- Visual equivalence to LaTeX, not pixel-perfect matching

### Integration Points
- `misq.typ`: Add show rules for CSL auto-application, hanging indent, and REFERENCES title formatting
- `template/main.typ`: Simplify bibliography call (remove explicit style, use auto-formatted title)
- Project root: Add `new-apa.csl` file

</code_context>

<deferred>
## Deferred Ideas

None — discussion stayed within phase scope

</deferred>

---

*Phase: 03-citations*
*Context gathered: 2026-03-13*
