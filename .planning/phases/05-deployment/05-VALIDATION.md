---
phase: 5
slug: deployment
status: draft
nyquist_compliant: false
wave_0_complete: false
created: 2026-03-13
---

# Phase 5 — Validation Strategy

> Per-phase validation contract for feedback sampling during execution.

---

## Test Infrastructure

| Property | Value |
|----------|-------|
| **Framework** | None — Makefile/bash + Typst project |
| **Config file** | None (no test framework config) |
| **Quick run command** | `make thumbnail` |
| **Full suite command** | `make publish` dry-run + manual inspection |
| **Estimated runtime** | ~10 seconds |

---

## Sampling Rate

- **After every task commit:** Run `make thumbnail`
- **After every plan wave:** Run `make publish` dry-run, inspect output
- **Before `/gsd:verify-work`:** Full suite must be green
- **Max feedback latency:** 10 seconds

---

## Per-Task Verification Map

| Task ID | Plan | Wave | Requirement | Test Type | Automated Command | File Exists | Status |
|---------|------|------|-------------|-----------|-------------------|-------------|--------|
| 05-01-01 | 01 | 1 | DEPLOY-04 | smoke | `make thumbnail && python3 -c "from PIL import Image; img=Image.open('thumbnail.png'); assert max(img.size) >= 1080"` | ❌ W0 | ⬜ pending |
| 05-01-02 | 01 | 1 | DEPLOY-01 | smoke | `make publish` then inspect temp dir | ❌ W0 | ⬜ pending |
| 05-01-03 | 01 | 1 | DEPLOY-02 | manual | Inspect git log in temp dir | manual-only | ⬜ pending |
| 05-01-04 | 01 | 1 | DEPLOY-03 | manual | Read Makefile, change PKG_NAME, verify | manual-only | ⬜ pending |

*Status: ⬜ pending · ✅ green · ❌ red · ⚠️ flaky*

---

## Wave 0 Requirements

- [ ] `Makefile` — does not exist yet, Wave 1 creates it
- [ ] `thumbnail.png` — does not exist yet, created by `make thumbnail`
- [ ] `README.md` — does not exist yet, required by Typst Universe

*No test framework installation needed — Makefile targets are the "tests"*

---

## Manual-Only Verifications

| Behavior | Requirement | Why Manual | Test Instructions |
|----------|-------------|------------|-------------------|
| Sparse checkout used (not full clone) | DEPLOY-02 | Requires inspecting git internals in temp dir | Run `make publish`, check temp dir has sparse checkout config |
| Portability — config variables at top | DEPLOY-03 | Requires human judgment on code organization | Read Makefile top, verify PKG_NAME/GH_USER are configurable |

---

## Validation Sign-Off

- [ ] All tasks have `<automated>` verify or Wave 0 dependencies
- [ ] Sampling continuity: no 3 consecutive tasks without automated verify
- [ ] Wave 0 covers all MISSING references
- [ ] No watch-mode flags
- [ ] Feedback latency < 10s
- [ ] `nyquist_compliant: true` set in frontmatter

**Approval:** pending
