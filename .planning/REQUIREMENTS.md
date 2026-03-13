# Requirements: typst-misq

**Defined:** 2026-03-12
**Core Value:** Accurately reproduce MISQ's formatting requirements in Typst so authors can write and submit manuscripts without wrestling with LaTeX.

## v1 Requirements

Requirements for initial release. Each maps to roadmap phases.

### Page Layout

- [x] **PAGE-01**: Document uses US Letter page size
- [x] **PAGE-02**: Side margins are 1 inch, top margin ~0.5 inch (accounting for header space), bottom margin yields 9-inch text height
- [x] **PAGE-03**: Page numbers appear in plain footer (centered, bottom)

### Typography

- [x] **TYPO-01**: Body text is 12pt Times New Roman
- [x] **TYPO-02**: Body text is double-spaced (matching LaTeX `\baselinestretch{2.0}`)
- [x] **TYPO-03**: Abstract text is 1.5-spaced (matching LaTeX `\baselinestretch{1.5}`)
- [x] **TYPO-04**: References section text is single-spaced
- [x] **TYPO-05**: Text in figures and tables is single-spaced
- [x] **TYPO-06**: References have 0.5-inch left hanging indent

### Headings

- [x] **HEAD-01**: Level 1 headings are centered, uppercase, bold, numbered (1, 2, 3), normalsize (12pt)
- [x] **HEAD-02**: Level 2 headings are centered, bold, numbered (1.1, 1.2), normalsize (12pt)
- [x] **HEAD-03**: Level 3 headings are left-aligned, bold, numbered (1.1.1, 1.1.2), normalsize (12pt)
- [x] **HEAD-04**: All headings use hierarchical numbering (1, 1.1, 1.1.1)

### Document Structure

- [x] **STRC-01**: Page 1 contains bold centered title, abstract (with label), and keywords
- [x] **STRC-02**: Introduction begins on page 2 (explicit page break after title page)
- [x] **STRC-03**: References section uses centered uppercase "REFERENCES" heading
- [x] **STRC-04**: Appendix section support with page break and centered uppercase "APPENDIX" heading

### Citations

- [x] **CITE-01**: APA 7th edition in-text citations work via `@key` syntax
- [x] **CITE-02**: Bibliography renders from .bib file with APA 7th formatting
- [x] **CITE-03**: Bundled APA 7th CSL file for precise citation formatting

### Package

- [x] **PACK-01**: `misq.typ` at project root contains the template definition function
- [x] **PACK-02**: `template/main.typ` is a working example document demonstrating all features
- [x] **PACK-03**: `template/references.bib` contains sample references
- [x] **PACK-04**: `typst.toml` package manifest with correct metadata
- [x] **PACK-05**: Example document includes sample citations from references.bib
- [x] **PACK-06**: Example document includes figure and table examples with captions
- [x] **PACK-07**: Template file includes inline comments explaining formatting decisions

### Deployment

- [ ] **DEPLOY-01**: A publish script that copies package files to a local `typst/packages` fork, creates a versioned branch, and commits — ready for a PR
- [ ] **DEPLOY-02**: The publish script uses sparse checkout to avoid cloning the full `typst/packages` repo
- [x] **DEPLOY-03**: The publish script is self-contained and copyable into other Typst package projects with minimal config changes
- [ ] **DEPLOY-04**: A `thumbnail.png` is generated from the template (first page, >= 1080px longer edge, <= 3 MiB)

## v2 Requirements

### Enhancements

- **ENH-01**: Cross-reference examples in sample document (`@label` syntax)

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
| PAGE-01 | Phase 1 | Complete |
| PAGE-02 | Phase 1 | Complete |
| PAGE-03 | Phase 2 | Complete |
| TYPO-01 | Phase 1 | Complete |
| TYPO-02 | Phase 1 | Complete |
| TYPO-03 | Phase 1 | Complete |
| TYPO-04 | Phase 1 | Complete |
| TYPO-05 | Phase 1 | Complete |
| TYPO-06 | Phase 3 | Complete |
| HEAD-01 | Phase 2 | Complete |
| HEAD-02 | Phase 2 | Complete |
| HEAD-03 | Phase 2 | Complete |
| HEAD-04 | Phase 2 | Complete |
| STRC-01 | Phase 2 | Complete |
| STRC-02 | Phase 2 | Complete |
| STRC-03 | Phase 2 | Complete |
| STRC-04 | Phase 2 | Complete |
| CITE-01 | Phase 3 | Complete |
| CITE-02 | Phase 3 | Complete |
| CITE-03 | Phase 3 | Complete |
| PACK-01 | Phase 4 | Complete |
| PACK-02 | Phase 4 | Complete |
| PACK-03 | Phase 4 | Complete |
| PACK-04 | Phase 4 | Complete |
| PACK-05 | Phase 4 | Complete |
| PACK-06 | Phase 4 | Complete |
| PACK-07 | Phase 4 | Complete |
| DEPLOY-01 | Phase 5 | Pending |
| DEPLOY-02 | Phase 5 | Pending |
| DEPLOY-03 | Phase 5 | Complete |
| DEPLOY-04 | Phase 5 | Pending |

**Coverage:**
- v1 requirements: 31 total
- Mapped to phases: 31
- Unmapped: 0

---
*Requirements defined: 2026-03-12*
*Last updated: 2026-03-12 after roadmap creation*
