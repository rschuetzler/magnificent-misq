# typst-misq

## What This Is

A Typst template package for MIS Quarterly (MISQ) manuscript submissions. It converts the official MISQ LaTeX submission template into a Typst template, following the same package structure as the ambivalent-amcis template (root `misq.typ` definition + `template/` folder with example document). v1.0 shipped with complete formatting, APA 7th citations, and a Typst Universe publish workflow.

## Core Value

Accurately reproduce MISQ's formatting requirements in Typst so authors can write and submit manuscripts without wrestling with LaTeX.

## Requirements

### Validated

- ✓ Page layout: US letter, 1" side margins, calibrated top/bottom margins — v1.0
- ✓ Font: 12pt Times New Roman for body text (silent Times fallback) — v1.0
- ✓ Line spacing: double-spaced body text (1.85em leading) — v1.0
- ✓ Line spacing: 1.5-spaced abstract on first page — v1.0
- ✓ Line spacing: single-spaced references with 0.5in hanging indent — v1.0
- ✓ Line spacing: single-spaced text in figures and tables — v1.0
- ✓ Title page: title, abstract, keywords on page 1; Introduction starts page 2 — v1.0
- ✓ Heading styles: centered uppercase bold (L1), centered bold (L2), left-aligned bold (L3) — all normalsize — v1.0
- ✓ APA 7th edition citations and bibliography formatting via bundled new-apa.csl — v1.0
- ✓ References section with 0.5in left hanging indent, single-spaced, REFERENCES heading auto-formatted — v1.0
- ✓ Example document with sample citations, figure, table, appendix — v1.0
- ✓ Submission-only mode (no author names — blind review) — v1.0
- ✓ Package structure: `misq.typ` at root, `template/main.typ`, `typst.toml` — v1.0
- ✓ Page numbering (centered footer, plain style) — v1.0
- ✓ Appendix section support — v1.0
- ✓ Makefile publish automation with sparse checkout and thumbnail generation — v1.0

### Active

- [ ] Cross-reference examples in sample document (`@label` syntax) — ENH-01

### Out of Scope

- Camera-ready / author-visible mode — submission only; MISQ is blind review
- Running headers/footers with title — not in MISQ submission format
- Multiple paper types — single submission format only
- Automated word count — no reliable Typst built-in; use external tools
- Abstract word count enforcement — creates confusing compile errors; authors verify manually
- Mobile/offline support — not applicable

## Context

- Shipped v1.0 with 273 LOC Typst across `misq.typ`, `template/main.typ`, and `new-apa.csl`
- Tech stack: Typst, CSL (new-apa.csl), Makefile, typst.toml
- Source material: official MISQ LaTeX submission template
- Reference implementation: `ambivalent-amcis` Typst package (same author)
- Package name: `magnificent-misq` (Typst Universe namespace)
- Publish workflow: Makefile `make publish` with sparse checkout to typst/packages fork

## Constraints

- **Font**: Times New Roman 12pt — required by MISQ guidelines; silent Times fallback for systems without TNR
- **Package structure**: Must follow Typst package conventions (typst.toml, entrypoint, template folder)
- **Citation style**: APA 7th edition — required by MISQ; bundled via new-apa.csl
- **Page size**: US Letter only

## Key Decisions

| Decision | Rationale | Outcome |
|----------|-----------|---------|
| Times New Roman over Georgia | MISQ LaTeX template specifies Times; Georgia is AMCIS-specific | ✓ Good — confirmed in PDF output |
| Submission-only (no camera-ready toggle) | Keep scope focused; MISQ is blind review only | ✓ Good |
| Follow ambivalent-amcis package structure | Proven pattern, prior work | ✓ Good |
| Silent TNR→Times fallback (no runtime check) | MISQ requires TNR but Typst silently falls back; avoids compile errors | ✓ Good |
| Inline spacing values (no named constants) | Values visible at use site, easier to adjust | ✓ Good |
| Show rules for single-spacing regions | bibliography/figure/table use `show T: set par(...)` instead of wrappers | ✓ Good |
| bib parameter removed from misq() | Authors call `bibliography()` explicitly for appendix placement control | ✓ Good |
| Numbering: `'1.1'` (no trailing dot) | Avoids `'1.'` rendered output at L1 headings | ✓ Good |
| CSL hanging-indent="false" | CSL `hanging-indent="true"` blocks Typst par-level override (Typst #2639) | ✓ Good — workaround works |
| Single combined show bibliography rule | Multiple transformational `show bibliography:` rules overwrite each other | ✓ Good |
| set bibliography(style:) in misq.typ | Auto-applies CSL; authors need no `style:` argument | ✓ Good |
| disciplines=["computer-science"] in typst.toml | No information-systems category in Typst taxonomy | — Pending (accepted) |
| Package name: magnificent-misq | Typst Universe namespace requirement | ✓ Good |
| Makefile --root . for typst compile | template/main.typ imports ../misq.typ outside template/ root | ✓ Good |
| README omits version number | Avoids staleness on future releases; import line uses 0.1.0 as declared | ✓ Good |

---
*Last updated: 2026-03-13 after v1.0 milestone*
