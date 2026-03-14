# Project Retrospective

*A living document updated after each milestone. Lessons feed forward into future planning.*

## Milestone: v1.0 — MVP

**Shipped:** 2026-03-13
**Phases:** 5 | **Plans:** 10 | **Timeline:** 2 days (2026-03-12 → 2026-03-13)

### What Was Built
- `misq.typ` Typst template with US Letter geometry, 12pt Times New Roman, and calibrated spacing (2x body, 1.5x abstract, 1x references/figures/tables)
- Complete document structure: 3-level numbered headings, title page, page flow (Introduction on page 2), page numbers
- APA 7th citations via bundled new-apa.csl with Typst hanging-indent workaround (combined show bibliography rule)
- Full package: `typst.toml`, rich sample document with figures/tables/citations/appendix, inline formatting comments
- Makefile publish workflow with sparse checkout, thumbnail generation, README and MIT license for Typst Universe

### What Worked
- Phased approach: foundation → structure → citations → package → deployment meant each phase built cleanly on the previous one
- Calibrating spacing empirically (rather than calculating from first principles) produced correct visual output on first PDF review
- The combined `show bibliography:` rule pattern solved the transformational-rule-overwrite problem cleanly
- Reusing the ambivalent-amcis package structure as a reference eliminated package manifest uncertainty

### What Was Inefficient
- Phase 3 (Citations) plan listed 1 plan but tool counted it out of sync with ROADMAP — caused apparent inconsistency in ROADMAP progress table (Citations showed 0/1 even after completion)
- The CSL hanging-indent problem required discovering Typst GitHub issue #2639 and the workaround mid-phase; could have been caught in research phase
- Phase 5 had a gap closure plan (05-03) for a package name mismatch that could have been caught earlier by checking typst.toml vs README consistency before execution

### Patterns Established
- **Combined bibliography show rule**: All bibliography formatting (spacing, heading, hanging indent) in one `show bibliography:` rule — multiple transformational rules overwrite each other
- **CSL hanging-indent="false"**: Always set in bundled CSL files; let Typst par-level control the indent measurement
- **`set bibliography(style:)` in template**: Auto-applies CSL at template level so authors' `#bibliography()` calls need no `style:` argument
- **Makefile --root .**: When template file imports from project root, compile with `--root .` not `--root template/`

### Key Lessons
1. Verify cross-file consistency (typst.toml name, Makefile PKG_NAME, README import line) before starting the deployment phase — name mismatches are cheap to catch early and expensive to fix late
2. Research Typst-specific workarounds for bibliography/CSL formatting during the research phase, not mid-execution
3. Gap closure plans (decimal phases) work well for small targeted fixes but signal a missed verification step earlier in the phase chain

### Cost Observations
- Model mix: ~100% sonnet (claude-sonnet-4-6 balanced profile)
- Sessions: ~5-6 sessions across 2 days
- Notable: Very fast execution (2 min phases common) for a well-scoped formatting-only project with clear LaTeX reference

---

## Cross-Milestone Trends

### Process Evolution

| Milestone | Phases | Plans | Key Change |
|-----------|--------|-------|------------|
| v1.0 | 5 | 10 | Initial milestone — established all baseline patterns |

### Cumulative Quality

| Milestone | Requirements | Coverage | Gap Closure Plans |
|-----------|-------------|----------|------------------|
| v1.0 | 31/31 | 100% | 1 (05-03 package name) |

### Top Lessons (Verified Across Milestones)

1. Verify cross-file naming consistency before deployment phases
2. Research library-specific workarounds (CSL, Typst quirks) during research phase, not execution
