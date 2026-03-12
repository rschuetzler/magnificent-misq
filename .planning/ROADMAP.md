# Roadmap: typst-misq

## Overview

Build a Typst package that accurately reproduces MISQ's formatting requirements so authors can submit manuscripts without using LaTeX. The work proceeds in five phases: establish the formatting foundation, build the document structure, implement APA 7th citations, assemble the complete package with a working sample document, then create a publish script for Typst Universe submission.

## Phases

**Phase Numbering:**
- Integer phases (1, 2, 3): Planned milestone work
- Decimal phases (2.1, 2.2): Urgent insertions (marked with INSERTED)

Decimal phases appear between their surrounding integers in numeric order.

- [x] **Phase 1: Foundation** - Page geometry, font, and spacing infrastructure (completed 2026-03-12)
- [ ] **Phase 2: Structure** - Title page, heading styles, and page flow
- [ ] **Phase 3: Citations** - APA 7th bibliography from .bib file
- [ ] **Phase 4: Package** - Sample document, manifest, and release artifacts
- [ ] **Phase 5: Deployment** - Publish script for Typst Universe submission

## Phase Details

### Phase 1: Foundation
**Goal**: A compilable `misq.typ` stub with correct page geometry, Times New Roman at 12pt with font fallbacks, and calibrated line spacing constants for all three spacing regions (body 2x, abstract 1.5x, references 1x).
**Depends on**: Nothing (first phase)
**Requirements**: PAGE-01, PAGE-02, TYPO-01, TYPO-02, TYPO-03, TYPO-04, TYPO-05
**Success Criteria** (what must be TRUE):
  1. A `.typ` file compiles to a US Letter PDF with 1-inch side margins and correct top/bottom margins
  2. Body text renders as 12pt Times New Roman (confirmed in PDF, not just fallback font)
  3. Body paragraphs are visually double-spaced and abstract text is visually 1.5x-spaced
  4. References and figure/table regions are single-spaced when the scoped spacing blocks are applied
**Plans**: 1 plan
Plans:
- [ ] 01-01-PLAN.md — Create misq.typ with page geometry, font, spacing; scaffold template directory

### Phase 2: Structure
**Goal**: Complete document structure — page 1 with bold title, abstract, and keywords; three heading levels correctly styled; Introduction starting on page 2; plain page numbers.
**Depends on**: Phase 1
**Requirements**: HEAD-01, HEAD-02, HEAD-03, HEAD-04, STRC-01, STRC-02, STRC-03, STRC-04, PAGE-03
**Success Criteria** (what must be TRUE):
  1. Page 1 shows a bold centered title, 1.5x-spaced abstract with "Abstract" label, and bold "Keywords:" line
  2. The Introduction begins at the top of page 2 with no blank page between
  3. Level 1 headings render centered, uppercase, bold, 12pt; level 2 render centered, bold, 12pt; level 3 render left-aligned, bold, 12pt
  4. No headings show numbering of any kind
  5. Page numbers appear centered in the footer on every page
**Plans**: TBD

### Phase 3: Citations
**Goal**: Working APA 7th citations from a `.bib` file using a bundled CSL, with the references section single-spaced and hanging-indented, output verified against MISQ's sample reference entries.
**Depends on**: Phase 2
**Requirements**: CITE-01, CITE-02, CITE-03, TYPO-06
**Success Criteria** (what must be TRUE):
  1. In-text `@key` citations render in APA 7th format for 1-author, 2-author, and 3+-author (et al.) cases
  2. The bibliography renders from a `.bib` file with APA 7th formatting that matches MISQ's sample reference entries
  3. The references section text is single-spaced with a 0.5-inch left hanging indent on each entry
**Plans**: TBD

### Phase 4: Package
**Goal**: A complete, distributable Typst package — `misq.typ` at root, `template/main.typ` demonstrating all features, `template/references.bib` with sample entries, `typst.toml` manifest, and inline comments explaining formatting decisions.
**Depends on**: Phase 3
**Requirements**: PACK-01, PACK-02, PACK-03, PACK-04, PACK-05, PACK-06, PACK-07
**Success Criteria** (what must be TRUE):
  1. `typst compile template/main.typ` succeeds and produces a correctly-formatted MISQ submission PDF
  2. The sample document demonstrates all heading levels, multiple citation patterns, at least one figure, and at least one table with captions
  3. The sample document includes an appendix section that renders with the correct heading and page break
  4. `typst.toml` exists at the root with correct package metadata
  5. `misq.typ` includes inline comments explaining key formatting decisions (spacing values, heading rules, font fallbacks)
**Plans**: TBD

### Phase 5: Deployment
**Goal**: A self-contained publish script that packages the template for Typst Universe submission — sparse-clones a `typst/packages` fork, copies versioned files into the correct directory structure, generates a thumbnail, and commits on a release branch ready for a PR. The script should be easily copyable into other Typst package projects.
**Depends on**: Phase 4
**Requirements**: DEPLOY-01, DEPLOY-02, DEPLOY-03, DEPLOY-04
**Success Criteria** (what must be TRUE):
  1. Running the publish script from the project root creates a correctly structured `packages/preview/{name}/{version}/` directory in a local packages fork
  2. The script uses sparse checkout (not a full clone of the massive typst/packages repo)
  3. A `thumbnail.png` exists at the project root, generated from the first page of the template at >= 1080px
  4. The script is portable — changing the package name and username at the top is sufficient to reuse it in another Typst project
**Plans**: TBD

## Progress

**Execution Order:**
Phases execute in numeric order: 1 → 2 → 3 → 4 → 5

| Phase | Plans Complete | Status | Completed |
|-------|----------------|--------|-----------|
| 1. Foundation | 1/1 | Complete   | 2026-03-12 |
| 2. Structure | 0/TBD | Not started | - |
| 3. Citations | 0/TBD | Not started | - |
| 4. Package | 0/TBD | Not started | - |
| 5. Deployment | 0/TBD | Not started | - |
