# typst-misq

## What This Is

A Typst template package for MIS Quarterly (MISQ) manuscript submissions. It converts the official MISQ LaTeX submission template into a Typst template, following the same package structure as the ambivalent-amcis template (root `misq.typ` definition + `template/` folder with example document).

## Core Value

Accurately reproduce MISQ's formatting requirements in Typst so authors can write and submit manuscripts without wrestling with LaTeX.

## Requirements

### Validated

(None yet — ship to validate)

### Active

- [ ] Page layout: US letter, 1" margins (with specific top margin per MISQ guidelines)
- [ ] Font: 12pt Times New Roman for body text
- [ ] Line spacing: double-spaced body text
- [ ] Line spacing: 1.5-spaced abstract on first page
- [ ] Line spacing: single-spaced references with hanging indent
- [ ] Line spacing: single-spaced text in figures and tables
- [ ] Title page: title, abstract, keywords on page 1; introduction starts page 2
- [ ] Heading styles: centered uppercase bold section headings (normalsize), centered bold subsection headings, bold left-aligned sub-subsection headings
- [ ] APA 7th edition citations and bibliography formatting
- [ ] References section with left hanging indent, single-spaced
- [ ] Example document using references.bib with sample citations
- [ ] Submission-only mode (no author names — blind review)
- [ ] Package structure: `misq.typ` at root, `template/main.typ`, `typst.toml`
- [ ] Page numbering (centered footer, plain style)
- [ ] Appendix section support

### Out of Scope

- Camera-ready / author-visible mode — submission only for now
- Header/footer with running title — not in MISQ submission format
- Multiple paper types — single submission format only

## Context

- Source material: official MISQ LaTeX submission template (`MISQ_Submission_Template_LaTeX.tex`)
- Reference implementation: `ambivalent-amcis` Typst template package on GitHub
- MISQ uses APA 7th edition references
- The LaTeX template uses `\baselinestretch{2.0}` for body, `1.5` for abstract, `1.0` for references
- Headings are all normalsize (12pt) — sections centered+bold+uppercase, subsections centered+bold, sub-subsections left-aligned+bold
- References are manually formatted in the LaTeX template (no BibTeX integration), but the Typst version should use proper bibliography management with the provided references.bib

## Constraints

- **Font**: Times New Roman 12pt — required by MISQ guidelines
- **Package structure**: Must follow Typst package conventions (typst.toml, entrypoint, template folder) matching ambivalent-amcis pattern
- **Citation style**: APA 7th edition — required by MISQ
- **Page size**: US Letter only

## Key Decisions

| Decision | Rationale | Outcome |
|----------|-----------|---------|
| Times New Roman over Georgia | MISQ LaTeX template specifies Times; Georgia is AMCIS-specific | — Pending |
| Submission-only (no camera-ready toggle) | User preference — keep it simple for now | — Pending |
| Follow ambivalent-amcis package structure | Proven pattern, user's own prior work | — Pending |

---
*Last updated: 2026-03-12 after initialization*
