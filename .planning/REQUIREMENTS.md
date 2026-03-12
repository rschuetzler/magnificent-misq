# Requirements: typst-misq

**Defined:** 2026-03-12
**Core Value:** Accurately reproduce MISQ's formatting requirements in Typst so authors can write and submit manuscripts without wrestling with LaTeX.

## v1 Requirements

Requirements for initial release. Each maps to roadmap phases.

### Page Layout

- [ ] **PAGE-01**: Document uses US Letter page size
- [ ] **PAGE-02**: Side margins are 1 inch, top margin ~0.5 inch (accounting for header space), bottom margin yields 9-inch text height
- [ ] **PAGE-03**: Page numbers appear in plain footer (centered, bottom)

### Typography

- [ ] **TYPO-01**: Body text is 12pt Times New Roman
- [ ] **TYPO-02**: Body text is double-spaced (matching LaTeX `\baselinestretch{2.0}`)
- [ ] **TYPO-03**: Abstract text is 1.5-spaced (matching LaTeX `\baselinestretch{1.5}`)
- [ ] **TYPO-04**: References section text is single-spaced
- [ ] **TYPO-05**: Text in figures and tables is single-spaced
- [ ] **TYPO-06**: References have 0.5-inch left hanging indent

### Headings

- [ ] **HEAD-01**: Level 1 headings are centered, uppercase, bold, unnumbered, normalsize (12pt)
- [ ] **HEAD-02**: Level 2 headings are centered, bold, unnumbered, normalsize (12pt)
- [ ] **HEAD-03**: Level 3 headings are left-aligned, bold, unnumbered, normalsize (12pt)
- [ ] **HEAD-04**: All headings use no numbering

### Document Structure

- [ ] **STRC-01**: Page 1 contains bold centered title, abstract (with label), and keywords
- [ ] **STRC-02**: Introduction begins on page 2 (explicit page break after title page)
- [ ] **STRC-03**: References section uses centered uppercase "REFERENCES" heading
- [ ] **STRC-04**: Appendix section support with page break and centered uppercase "APPENDIX" heading

### Citations

- [ ] **CITE-01**: APA 7th edition in-text citations work via `@key` syntax
- [ ] **CITE-02**: Bibliography renders from .bib file with APA 7th formatting
- [ ] **CITE-03**: Bundled APA 7th CSL file for precise citation formatting

### Package

- [ ] **PACK-01**: `misq.typ` at project root contains the template definition function
- [ ] **PACK-02**: `template/main.typ` is a working example document demonstrating all features
- [ ] **PACK-03**: `template/references.bib` contains sample references
- [ ] **PACK-04**: `typst.toml` package manifest with correct metadata
- [ ] **PACK-05**: Example document includes sample citations from references.bib
- [ ] **PACK-06**: Example document includes figure and table examples with captions
- [ ] **PACK-07**: Template file includes inline comments explaining formatting decisions

## v2 Requirements

### Enhancements

- **ENH-01**: Cross-reference examples in sample document (`@label` syntax)
- **ENH-02**: Package registry publication to Typst Universe

## Out of Scope

| Feature | Reason |
|---------|--------|
| Camera-ready / author mode | MISQ is submission-only (blind review); camera-ready uses journal typesetting |
| Author information fields | Blind review — no author info should appear |
| Multi-column layout | MISQ uses single-column throughout |
| Running headers/footers | MISQ submission uses plain page numbers only |
| Automated word count | Typst has no reliable built-in; use external tools |
| Abstract word count enforcement | Creates confusing compile errors; user verifies manually |

## Traceability

Which phases cover which requirements. Updated during roadmap creation.

| Requirement | Phase | Status |
|-------------|-------|--------|
| PAGE-01 | — | Pending |
| PAGE-02 | — | Pending |
| PAGE-03 | — | Pending |
| TYPO-01 | — | Pending |
| TYPO-02 | — | Pending |
| TYPO-03 | — | Pending |
| TYPO-04 | — | Pending |
| TYPO-05 | — | Pending |
| TYPO-06 | — | Pending |
| HEAD-01 | — | Pending |
| HEAD-02 | — | Pending |
| HEAD-03 | — | Pending |
| HEAD-04 | — | Pending |
| STRC-01 | — | Pending |
| STRC-02 | — | Pending |
| STRC-03 | — | Pending |
| STRC-04 | — | Pending |
| CITE-01 | — | Pending |
| CITE-02 | — | Pending |
| CITE-03 | — | Pending |
| PACK-01 | — | Pending |
| PACK-02 | — | Pending |
| PACK-03 | — | Pending |
| PACK-04 | — | Pending |
| PACK-05 | — | Pending |
| PACK-06 | — | Pending |
| PACK-07 | — | Pending |

**Coverage:**
- v1 requirements: 27 total
- Mapped to phases: 0
- Unmapped: 27 ⚠️

---
*Requirements defined: 2026-03-12*
*Last updated: 2026-03-12 after initial definition*
