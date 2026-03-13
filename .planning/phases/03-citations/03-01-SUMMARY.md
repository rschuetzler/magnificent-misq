---
phase: 03-citations
plan: 01
subsystem: citations
tags: [typst, csl, apa, bibliography, citations, hanging-indent]

# Dependency graph
requires:
  - phase: 02-structure
    provides: misq.typ show rules and heading formatting infrastructure
provides:
  - APA 7th CSL file (new-apa.csl) with Typst-compatible hanging-indent=false modification
  - Combined bibliography show rule in misq.typ handling spacing, heading, and hanging indent
  - Auto-applied CSL via set bibliography(style:) so authors need no style: argument
  - Simplified template bibliography call pattern
affects:
  - Any future phase touching bibliography, references, or citation formatting

# Tech tracking
tech-stack:
  added: [new-apa.csl (bundled APA 7th CSL from ambivalent-amcis)]
  patterns:
    - set bibliography(style:) at template level to auto-apply CSL without per-call style:
    - Single combined show bibliography rule to avoid transformational rule overwrite problem
    - CSL hanging-indent="false" + Typst par hanging-indent to work around GitHub issue #2639

key-files:
  created:
    - new-apa.csl
  modified:
    - misq.typ
    - template/main.typ
    - template/references.bib

key-decisions:
  - "CSL hanging-indent must be 'false' — CSL hanging-indent='true' blocks Typst par-level override (GitHub issue #2639)"
  - "Single combined show bibliography rule — multiple transformational show bibliography rules overwrite each other (only last applies)"
  - "set bibliography(style:) in misq.typ auto-applies CSL — authors call bibliography() with no style: argument"
  - "Manual REFERENCES heading removed from template — misq.typ show rule handles centered/bold/uppercase heading from title: parameter"

patterns-established:
  - "Pattern 1: Combined show bibliography rule — all bibliography formatting (spacing, heading, hanging indent) in ONE show rule"
  - "Pattern 2: CSL at template level via set bibliography — authors get correct APA formatting without knowing which CSL to use"
  - "Pattern 3: bibliography(title: 'References') — show rule auto-uppercases the title to REFERENCES"

requirements-completed: [CITE-01, CITE-02, CITE-03, TYPO-06]

# Metrics
duration: 2min
completed: 2026-03-13
---

# Phase 3 Plan 01: Citations Summary

**APA 7th bibliography via bundled new-apa.csl with Typst hanging-indent workaround, auto-applied from misq.typ so authors use a single `#bibliography()` call**

## Performance

- **Duration:** ~2 min
- **Started:** 2026-03-13T15:37:06Z
- **Completed:** 2026-03-13T15:38:54Z
- **Tasks:** 2
- **Files modified:** 4

## Accomplishments

- Bundled new-apa.csl at project root with hanging-indent="false" to enable Typst par-level override
- Replaced single-line bibliography show rule with combined rule handling single-spacing, REFERENCES heading auto-formatting, and 0.5-inch hanging indent
- Simplified template/main.typ bibliography call — authors need only `#bibliography("references.bib", title: "References")`
- Added 1-author reference to cover all three APA citation author-count patterns (1, 2, 3+)

## Task Commits

Each task was committed atomically:

1. **Task 1: Bundle CSL and add bibliography show rules to misq.typ** - `4dd6e38` (feat)
2. **Task 2: Update template and verify citation output** - `390b129` (feat)

**Plan metadata:** (docs commit — see below)

## Files Created/Modified

- `/Users/ryanschuetzler/code/typst-misq/new-apa.csl` - APA 7th CSL file with hanging-indent="false" (modified from original "true" to enable Typst par override)
- `/Users/ryanschuetzler/code/typst-misq/misq.typ` - Replaced single bibliography show rule with combined rule: set bibliography(style:), heading formatting, single-spacing, hanging indent
- `/Users/ryanschuetzler/code/typst-misq/template/main.typ` - Simplified bibliography call, removed manual REFERENCES heading, updated Discussion citations
- `/Users/ryanschuetzler/code/typst-misq/template/references.bib` - Added orlikowski1992duality (1-author) for full author-count test coverage

## Decisions Made

- CSL hanging-indent set to "false": The CSL's own hanging-indent signal prevents Typst from applying par-level indent overrides (Typst GitHub issue #2639). Disabling it lets the Typst show rule control the 0.5in measurement precisely.
- Single combined show bibliography rule: Multiple transformational `show bibliography:` rules cause the last to overwrite earlier ones. All formatting goes inside one rule.
- set bibliography(style:) in misq.typ: Auto-applies the bundled CSL. Authors writing `#bibliography("refs.bib", title: "References")` get correct APA output without knowing CSL details.
- Manual heading removed from template: The show rule inside `show bibliography:` auto-formats the `title:` parameter to centered/bold/uppercase, matching STRC-03.

## Deviations from Plan

None - plan executed exactly as written.

## Issues Encountered

None.

## User Setup Required

None - no external service configuration required.

## Next Phase Readiness

- Citation formatting is complete: in-text @key citations and bibliography output both use APA 7th
- Authors use the single simplified bibliography call pattern
- Visual PDF verification should confirm REFERENCES heading, hanging indent, and in-text citation formats
- Ready to proceed to next phase (04 or remaining citation validation work)

---
*Phase: 03-citations*
*Completed: 2026-03-13*

## Self-Check: PASSED

- new-apa.csl: FOUND
- misq.typ: FOUND
- template/main.typ: FOUND
- template/references.bib: FOUND
- 03-01-SUMMARY.md: FOUND
- Commit 4dd6e38: FOUND
- Commit 390b129: FOUND
- typst compile template/main.typ: SUCCESS
