---
phase: 4
slug: package
status: draft
nyquist_compliant: false
wave_0_complete: false
created: 2026-03-13
---

# Phase 4 — Validation Strategy

> Per-phase validation contract for feedback sampling during execution.

---

## Test Infrastructure

| Property | Value |
|----------|-------|
| **Framework** | Visual PDF inspection + smoke compilation |
| **Config file** | none |
| **Quick run command** | `typst compile --root . template/main.typ` |
| **Full suite command** | `typst compile --root . template/main.typ && open template/main.pdf` |
| **Estimated runtime** | ~2 seconds |

---

## Sampling Rate

- **After every task commit:** Run `typst compile --root . template/main.typ`
- **After every plan wave:** Run `typst compile --root . template/main.typ && open template/main.pdf`
- **Before `/gsd:verify-work`:** Full suite must be green
- **Max feedback latency:** 2 seconds

---

## Per-Task Verification Map

| Task ID | Plan | Wave | Requirement | Test Type | Automated Command | File Exists | Status |
|---------|------|------|-------------|-----------|-------------------|-------------|--------|
| 04-01-01 | 01 | 1 | PACK-01 | smoke | `typst compile --root . template/main.typ` | ✅ misq.typ | ⬜ pending |
| 04-01-02 | 01 | 1 | PACK-04 | smoke | `cat typst.toml` | ❌ W0 | ⬜ pending |
| 04-01-03 | 01 | 1 | PACK-02 | smoke | `typst compile --root . template/main.typ` | ✅ template/main.typ | ⬜ pending |
| 04-01-04 | 01 | 1 | PACK-03 | smoke | `typst compile --root . template/main.typ` | ✅ template/references.bib | ⬜ pending |
| 04-01-05 | 01 | 1 | PACK-05 | visual | `typst compile --root . template/main.typ` + PDF review | ✅ | ⬜ pending |
| 04-01-06 | 01 | 1 | PACK-06 | visual | `typst compile --root . template/main.typ` + PDF review | ✅ | ⬜ pending |
| 04-01-07 | 01 | 1 | PACK-07 | manual | Read misq.typ and audit comments | ✅ partial | ⬜ pending |

*Status: ⬜ pending · ✅ green · ❌ red · ⚠️ flaky*

---

## Wave 0 Requirements

- [ ] `typst.toml` — create package manifest (PACK-04)

*Existing infrastructure covers all other phase requirements.*

---

## Manual-Only Verifications

| Behavior | Requirement | Why Manual | Test Instructions |
|----------|-------------|------------|-------------------|
| Sample document demonstrates all heading levels | PACK-02 | Visual formatting check | Open PDF, verify H1-H4 rendering |
| Figure and table captions formatted correctly | PACK-06 | Visual formatting check | Open PDF, verify caption placement and style |
| Appendix renders with correct heading and page break | PACK-02 | Visual layout check | Open PDF, verify appendix section |
| Inline comments explain formatting decisions | PACK-07 | Code review | Read misq.typ, audit comment coverage |

---

## Validation Sign-Off

- [ ] All tasks have `<automated>` verify or Wave 0 dependencies
- [ ] Sampling continuity: no 3 consecutive tasks without automated verify
- [ ] Wave 0 covers all MISSING references
- [ ] No watch-mode flags
- [ ] Feedback latency < 2s
- [ ] `nyquist_compliant: true` set in frontmatter

**Approval:** pending
