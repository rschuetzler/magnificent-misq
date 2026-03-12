---
phase: 1
slug: foundation
status: draft
nyquist_compliant: false
wave_0_complete: false
created: 2026-03-12
---

# Phase 1 — Validation Strategy

> Per-phase validation contract for feedback sampling during execution.

---

## Test Infrastructure

| Property | Value |
|----------|-------|
| **Framework** | Manual compilation + visual PDF comparison |
| **Config file** | none (Typst compilation is the validator) |
| **Quick run command** | `typst compile misq.typ` |
| **Full suite command** | `typst compile misq.typ && pdffonts misq.pdf` |
| **Estimated runtime** | ~2 seconds |

---

## Sampling Rate

- **After every task commit:** Run `typst compile misq.typ`
- **After every plan wave:** Run `typst compile misq.typ` + visual PDF inspection against LaTeX reference
- **Before `/gsd:verify-work`:** Full compile + all visual checks must pass
- **Max feedback latency:** 2 seconds

---

## Per-Task Verification Map

| Task ID | Plan | Wave | Requirement | Test Type | Automated Command | File Exists | Status |
|---------|------|------|-------------|-----------|-------------------|-------------|--------|
| 01-01-01 | 01 | 1 | PAGE-01 | smoke | `typst compile misq.typ` | ❌ W0 | ⬜ pending |
| 01-01-02 | 01 | 1 | PAGE-02 | manual | Visual inspect PDF margins | ❌ W0 | ⬜ pending |
| 01-01-03 | 01 | 1 | TYPO-01 | manual | `pdffonts misq.pdf` shows Times-Roman | ❌ W0 | ⬜ pending |
| 01-01-04 | 01 | 1 | TYPO-02 | manual | Compare body spacing vs LaTeX PDF | ❌ W0 | ⬜ pending |
| 01-01-05 | 01 | 1 | TYPO-03 | manual | Compare abstract spacing vs LaTeX PDF | ❌ W0 | ⬜ pending |
| 01-01-06 | 01 | 1 | TYPO-04 | manual | Visual inspect references region | ❌ W0 | ⬜ pending |
| 01-01-07 | 01 | 1 | TYPO-05 | manual | Visual inspect figure/table regions | ❌ W0 | ⬜ pending |

*Status: ⬜ pending · ✅ green · ❌ red · ⚠️ flaky*

---

## Wave 0 Requirements

- [ ] `misq.typ` — the template file itself (does not exist yet)
- [ ] LaTeX reference PDF — generate with `pdflatex MISQ_Submission_Template_LaTeX.tex` for visual comparison

*Typst compilation itself is the primary verification mechanism. No separate test framework needed.*

---

## Manual-Only Verifications

| Behavior | Requirement | Why Manual | Test Instructions |
|----------|-------------|------------|-------------------|
| 1" side margins, correct top/bottom | PAGE-02 | Requires visual/ruler measurement in PDF | Open PDF, verify margins with ruler tool |
| 12pt Times New Roman renders | TYPO-01 | Font embedding requires `pdffonts` check | Run `pdffonts misq.pdf`, confirm Times-Roman |
| Body double-spaced | TYPO-02 | Visual spacing comparison | Compare against LaTeX reference PDF |
| Abstract 1.5x-spaced | TYPO-03 | Visual spacing comparison | Compare abstract region against LaTeX reference PDF |
| References single-spaced | TYPO-04 | Visual spacing comparison | Inspect references region in compiled PDF |
| Figures/tables single-spaced | TYPO-05 | Visual spacing comparison | Inspect figure/table regions in compiled PDF |

---

## Validation Sign-Off

- [ ] All tasks have `<automated>` verify or Wave 0 dependencies
- [ ] Sampling continuity: no 3 consecutive tasks without automated verify
- [ ] Wave 0 covers all MISSING references
- [ ] No watch-mode flags
- [ ] Feedback latency < 2s
- [ ] `nyquist_compliant: true` set in frontmatter

**Approval:** pending
