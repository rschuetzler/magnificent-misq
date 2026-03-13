---
phase: 3
slug: citations
status: draft
nyquist_compliant: false
wave_0_complete: false
created: 2026-03-13
---

# Phase 3 — Validation Strategy

> Per-phase validation contract for feedback sampling during execution.

---

## Test Infrastructure

| Property | Value |
|----------|-------|
| **Framework** | Visual PDF inspection (no automated test suite) |
| **Config file** | none — manual compilation and visual verification |
| **Quick run command** | `typst compile template/main.typ` |
| **Full suite command** | `typst compile template/main.typ && open template/main.pdf` |
| **Estimated runtime** | ~2 seconds |

---

## Sampling Rate

- **After every task commit:** Run `typst compile template/main.typ`
- **After every plan wave:** Run `typst compile template/main.typ && open template/main.pdf`
- **Before `/gsd:verify-work`:** Full suite must be green
- **Max feedback latency:** 2 seconds

---

## Per-Task Verification Map

| Task ID | Plan | Wave | Requirement | Test Type | Automated Command | File Exists | Status |
|---------|------|------|-------------|-----------|-------------------|-------------|--------|
| 03-01-01 | 01 | 1 | CITE-03 | visual | `typst compile template/main.typ` | ✅ | ⬜ pending |
| 03-01-02 | 01 | 1 | CITE-01, CITE-02, TYPO-06 | visual | `typst compile template/main.typ` | ✅ | ⬜ pending |

*Status: ⬜ pending · ✅ green · ❌ red · ⚠️ flaky*

---

## Wave 0 Requirements

Existing infrastructure covers all phase requirements:
- `template/main.typ` already contains `@brown2023fault` and `@gupta2018economic` citations
- `template/references.bib` has 2 sample entries (2-author and 3-author)
- `MISQ_Submission_Template_LaTeX.tex` provides reference output to compare against

*No new test files needed.*

---

## Manual-Only Verifications

| Behavior | Requirement | Why Manual | Test Instructions |
|----------|-------------|------------|-------------------|
| In-text citations render APA 7th format | CITE-01 | Visual formatting check against APA standard | Compile PDF, verify `@brown2023fault` → "(Brown & Sias, 2023)" and `@gupta2018economic` → "(Gupta et al., 2018)" |
| Bibliography entries match MISQ LaTeX sample | CITE-02 | Character-level comparison to LaTeX reference | Compare bibliography section to LaTeX template lines 80-83 |
| CSL auto-applies without explicit style: | CITE-03 | Smoke test — bibliography renders correctly without style param | Remove `style: "apa"` from main.typ, compile, verify output unchanged |
| 0.5-inch hanging indent on entries | TYPO-06 | Visual measurement in PDF | Open PDF, verify subsequent lines of each reference entry are indented 0.5" from left margin |

---

## Validation Sign-Off

- [ ] All tasks have `<automated>` verify or Wave 0 dependencies
- [ ] Sampling continuity: no 3 consecutive tasks without automated verify
- [ ] Wave 0 covers all MISSING references
- [ ] No watch-mode flags
- [ ] Feedback latency < 2s
- [ ] `nyquist_compliant: true` set in frontmatter

**Approval:** pending
