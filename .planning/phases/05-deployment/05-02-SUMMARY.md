---
phase: 05-deployment
plan: 02
subsystem: infra
tags: [makefile, typst, publish, thumbnail, typst-universe, sparse-checkout]

requires:
  - phase: 05-01
    provides: README.md and LICENSE required by PKG_FILES include list

provides:
  - Makefile with help, thumbnail, publish, and clean targets
  - thumbnail.png generated from template first page (2750x2125px, 1.0 MiB)
  - Portable publish automation for Typst Universe submission

affects: [05-deployment]

tech-stack:
  added: [make, typst compile --format png]
  patterns:
    - "Sparse clone with --filter=blob:none --sparse --depth 1 for efficient fork checkout"
    - "Config variables at top of Makefile for cross-project portability"
    - "help target using grep/awk on ## comments for self-documenting Makefile"

key-files:
  created:
    - Makefile
    - thumbnail.png
  modified: []

key-decisions:
  - "Added --root . to typst compile so template/main.typ can resolve ../misq.typ import (auto-fix)"
  - "ONESHELL: enables set -euo pipefail across entire publish recipe as single shell invocation"
  - "Template files copied explicitly (main.typ, references.bib) rather than cp -r to avoid .DS_Store"

patterns-established:
  - "Makefile publish pattern: sparse clone fork -> copy PKG_FILES -> commit -> push branch -> print PR URL"

requirements-completed: [DEPLOY-01, DEPLOY-02, DEPLOY-03, DEPLOY-04]

duration: 2min
completed: 2026-03-13
---

# Phase 5 Plan 02: Makefile and Thumbnail Summary

**Portable Makefile with sparse-clone publish automation and thumbnail.png (2750x2125px) generated via typst compile --format png**

## Performance

- **Duration:** ~2 min
- **Started:** 2026-03-13T20:43:15Z
- **Completed:** 2026-03-13T20:45:00Z
- **Tasks:** 2 (+ 1 checkpoint pending human approval)
- **Files modified:** 2

## Accomplishments

- Makefile with `help`, `thumbnail`, `publish`, and `clean` targets; config block at top with PKG_NAME, GITHUB_USER, FORK_REPO
- `make publish` sparse-clones fork, copies PKG_FILES and template/, commits "Add misq 0.1.0", pushes branch, prints PR URL
- thumbnail.png generated: 2750x2125px (longer edge 2750px >= 1080px required), 1.0 MiB (<= 3 MiB limit)

## Task Commits

Each task was committed atomically:

1. **Task 1: Create Makefile with publish automation** - `c653a97` (feat)
2. **Task 2: Generate thumbnail.png (+ --root fix)** - `4b43b9e` (feat)
3. **Task 3: Verify Makefile and thumbnail (checkpoint:human-verify)** - Approved by user 2026-03-13

## Files Created/Modified

- `Makefile` - Publish automation: help, thumbnail, publish, clean targets with config block for portability
- `thumbnail.png` - Template preview image, 2750x2125px, 1.0 MiB

## Decisions Made

- `--root .` passed to `typst compile` so the template's `#import "../misq.typ"` resolves correctly (the template is a subdirectory)
- `.ONESHELL:` used so the publish recipe runs as a single shell invocation, enabling `set -euo pipefail` across the whole block
- Template files copied individually (`main.typ`, `references.bib`) rather than `cp -r template/` to avoid `.DS_Store` and other hidden files

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 1 - Bug] Added --root . to typst compile command**
- **Found during:** Task 2 (Generate thumbnail.png)
- **Issue:** `typst compile` failed with "access denied: cannot read file outside of project root" because `template/main.typ` imports `../misq.typ` which is outside the default template/ root
- **Fix:** Added `--root .` flag to the thumbnail target so typst uses the project root
- **Files modified:** Makefile
- **Verification:** `make thumbnail` succeeded, generating 2750x2125px thumbnail.png
- **Committed in:** 4b43b9e (Task 2 commit)

---

**Total deviations:** 1 auto-fixed (1 bug)
**Impact on plan:** Essential fix — thumbnail could not be generated without it. No scope creep.

## Issues Encountered

None beyond the --root fix documented above.

## User Setup Required

None - all automation complete.

## Next Phase Readiness

- Makefile and thumbnail.png are committed and verified by user
- Plan 05-02 is complete — Phase 5 deployment is fully done
- To publish: run `make publish` with a typst-packages fork configured, then open the printed PR URL to submit

---
*Phase: 05-deployment*
*Completed: 2026-03-13*
