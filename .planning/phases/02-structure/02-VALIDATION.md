---
phase: 2
slug: structure
status: draft
nyquist_compliant: false
wave_0_complete: false
created: 2026-03-13
---

# Phase 2 — Validation Strategy

> Per-phase validation contract for feedback sampling during execution.

---

## Test Infrastructure

| Property | Value |
|----------|-------|
| **Framework** | typst compile + visual inspection |
| **Config file** | none — Typst projects use direct compilation |
| **Quick run command** | `typst compile template/main.typ` |
| **Full suite command** | `typst compile template/main.typ && open template/main.pdf` |
| **Estimated runtime** | ~2 seconds |

---

## Sampling Rate

- **After every task commit:** Run `typst compile template/main.typ`
- **After every plan wave:** Run `typst compile template/main.typ && open template/main.pdf`
- **Before `/gsd:verify-work`:** Full suite must compile cleanly
- **Max feedback latency:** 2 seconds

---

## Per-Task Verification Map

| Task ID | Plan | Wave | Requirement | Test Type | Automated Command | File Exists | Status |
|---------|------|------|-------------|-----------|-------------------|-------------|--------|
| 02-01-01 | 01 | 1 | STRC-01 | compile | `typst compile template/main.typ` | ✅ | ⬜ pending |
| 02-01-02 | 01 | 1 | STRC-02 | compile | `typst compile template/main.typ` | ✅ | ⬜ pending |
| 02-01-03 | 01 | 1 | STRC-03 | compile+visual | `typst compile template/main.typ` | ✅ | ⬜ pending |
| 02-01-04 | 01 | 1 | STRC-04 | compile+visual | `typst compile template/main.typ` | ✅ | ⬜ pending |
| 02-01-05 | 01 | 1 | HEAD-01 | compile+visual | `typst compile template/main.typ` | ✅ | ⬜ pending |
| 02-01-06 | 01 | 1 | HEAD-02 | compile+visual | `typst compile template/main.typ` | ✅ | ⬜ pending |
| 02-01-07 | 01 | 1 | HEAD-03 | compile+visual | `typst compile template/main.typ` | ✅ | ⬜ pending |
| 02-01-08 | 01 | 1 | HEAD-04 | compile+visual | `typst compile template/main.typ` | ✅ | ⬜ pending |
| 02-01-09 | 01 | 1 | PAGE-03 | compile+visual | `typst compile template/main.typ` | ✅ | ⬜ pending |

*Status: ⬜ pending · ✅ green · ❌ red · ⚠️ flaky*

---

## Wave 0 Requirements

*Existing infrastructure covers all phase requirements — Typst compile is the test framework.*

---

## Manual-Only Verifications

| Behavior | Requirement | Why Manual | Test Instructions |
|----------|-------------|------------|-------------------|
| Title is bold, centered, 14pt on page 1 | STRC-01 | Visual formatting | Compile and inspect page 1 title |
| Abstract has "Abstract" label, 1.5x spacing | STRC-02 | Visual formatting | Compile and inspect abstract section |
| Keywords line is bold with "Keywords:" prefix | STRC-03 | Visual formatting | Compile and inspect keywords line |
| Introduction starts at top of page 2 | STRC-04 | Layout check | Compile and verify page break |
| L1 headings: centered, uppercase, bold, 12pt | HEAD-01 | Visual formatting | Compile and inspect L1 headings |
| L2 headings: centered, bold, 12pt | HEAD-02 | Visual formatting | Compile and inspect L2 headings |
| L3 headings: left-aligned, bold, 12pt | HEAD-03 | Visual formatting | Compile and inspect L3 headings |
| No heading numbering visible | HEAD-04 | Visual check | Confirm no numbers before heading text |
| Page numbers centered in footer | PAGE-03 | Visual check | Check footer on all pages |

---

## Validation Sign-Off

- [ ] All tasks have `<automated>` verify or Wave 0 dependencies
- [ ] Sampling continuity: no 3 consecutive tasks without automated verify
- [ ] Wave 0 covers all MISSING references
- [ ] No watch-mode flags
- [ ] Feedback latency < 2s
- [ ] `nyquist_compliant: true` set in frontmatter

**Approval:** pending
