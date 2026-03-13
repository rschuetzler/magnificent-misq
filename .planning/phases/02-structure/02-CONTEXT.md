# Phase 2: Structure - Context

**Gathered:** 2026-03-13
**Status:** Ready for planning

<domain>
## Phase Boundary

Complete document structure — page 1 with bold centered title, centered "Abstract" label, and keywords; three numbered heading levels correctly styled; Introduction starting on page 2; plain page numbers. Remove the `bib` parameter so authors control bibliography/appendix ordering.

</domain>

<decisions>
## Implementation Decisions

### Title page layout
- Title bold, centered, rendered in author's original casing (no auto-uppercase)
- Title vertical spacing should match the Word template (`MISQ-Manuscript-Template-Word.docx`)
- "Abstract" label centered and bold above the abstract text (update from current left-aligned)
- Keywords line stays as-is: bold "Keywords:" left-aligned with comma-separated terms

### Page flow
- Page break after keywords — Introduction starts at top of page 2
- Page numbers centered in footer (already partially implemented with `numbering: "1"`)

### Heading styles
- Level 1: centered, uppercase, bold, 12pt, numbered (1, 2, 3, ...)
- Level 2: centered, bold, 12pt, numbered (1.1, 1.2, ...)
- Level 3: left-aligned, bold, 12pt, numbered (1.1.1, 1.1.2, ...)
- All headings numbered — updating HEAD-04 requirement from "no numbering" to "numbered (1, 1.1, 1.1.1)"

### Heading spacing
- Visual equivalence to LaTeX, not exact value matching (consistent with Phase 1 approach)
- Uniform spacing before/after all heading levels (no differentiation by level)

### Paragraph style
- New `paragraph-style` parameter on misq(): `"indent"` (default) or `"block"`
- `"indent"`: first-line indent (~0.25-0.5in), no extra paragraph spacing — matches LaTeX template
- `"block"`: no indent, extra space between paragraphs — matches Word template
- Default to `"indent"` since it reads better with double-spacing

### Bibliography parameter removal
- Remove the `bib` parameter from misq() function signature
- Authors write `#bibliography("references.bib", style: "apa")` explicitly in their document
- This allows appendices to appear after the bibliography
- Template show rules for bibliography styling (single-spacing) still apply automatically

### Appendix handling
- No special appendix API or function
- Authors manage appendices manually with `#pagebreak()` and headings
- Authors handle their own lettering (Appendix A, Appendix B, etc.)

### Special headings (REFERENCES, APPENDIX)
- No auto-styling via show rules — author handles formatting manually
- The example document (Phase 4) will demonstrate the correct markup

### Claude's Discretion
- Exact heading spacing values (visually calibrated)
- Page number footer implementation details
- How to implement the paragraph-style toggle internally

</decisions>

<specifics>
## Specific Ideas

- Use the Word template (`MISQ-Manuscript-Template-Word.docx`) as the primary visual reference for title page spacing
- LaTeX template is the secondary reference for heading structure and spacing feel
- Headings should be numbered contrary to the LaTeX template — actual MISQ guidelines use numbered sections

</specifics>

<code_context>
## Existing Code Insights

### Reusable Assets
- `misq.typ`: Already has abstract rendering (needs label centering update), keywords rendering (keep as-is), page geometry, font, and spacing calibration
- `MISQ_Submission_Template_LaTeX.tex`: Reference for heading `\section` spacing values (-3.5ex before, 2.3ex after for sections)
- `MISQ-Manuscript-Template-Word.docx`: Primary visual reference for title page layout

### Established Patterns
- Phase 1 used inline spacing values rather than named constants — continue this pattern
- Phase 1 used show rules for bibliography/figure single-spacing — heading styles will follow the same show-rule pattern
- Visual equivalence to LaTeX, not pixel-perfect matching

### Integration Points
- `misq()` function signature: remove `bib` parameter, add `paragraph-style` parameter
- Heading show rules added to misq.typ alongside existing show rules for bibliography/figure
- Abstract label needs update from left-aligned to centered

</code_context>

<deferred>
## Deferred Ideas

None — discussion stayed within phase scope

</deferred>

---

*Phase: 02-structure*
*Context gathered: 2026-03-13*
