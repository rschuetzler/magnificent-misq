# Phase 4: Package - Research

**Researched:** 2026-03-13
**Domain:** Typst package manifest, template file authoring, example document completeness
**Confidence:** HIGH

## Summary

Phase 4 is a packaging and documentation phase, not an implementation phase. All MISQ formatting rules are already implemented in `misq.typ` (Phases 1-3 complete). The work is: write `typst.toml`, improve `misq.typ` inline comments, and upgrade `template/main.typ` to a production-quality example document that demonstrates all features an MISQ author would use.

The current `template/main.typ` is a functional test document but is authored as a dev test (placeholder text, no appendix heading auto-formatted, cites three references but doesn't demonstrate all citation patterns). For Typst Universe submission the template must compile using a full package import (`@preview/misq:0.1.0`) not a relative import (`../misq.typ`), but during development the relative import is correct — Phase 5 (Deploy) handles publication. Phase 4 produces the package-ready files that Phase 5 will publish.

`misq.typ` already has substantial inline comments on most formatting decisions (added in Phases 1-3). Phase 4 needs to audit those comments and fill gaps. The `typst.toml` is entirely absent and must be created from scratch following the established `ambivalent-amcis` pattern.

**Primary recommendation:** Write `typst.toml` first (single task, all fields clear), then audit/enhance `misq.typ` comments, then expand `template/main.typ` to a complete showcase document. All three are independent and can be parallelized.

---

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|-----------------|
| PACK-01 | `misq.typ` at project root contains the template definition function | Already exists at project root from Phases 1-3; Phase 4 adds/audits inline comments |
| PACK-02 | `template/main.typ` is a working example document demonstrating all features | Exists; needs expansion to showcase all heading levels, citation patterns, figure, table, appendix |
| PACK-03 | `template/references.bib` contains sample references | Exists with 3 entries (1-author, 2-author, 3-author); may need book/conference entries for richer demo |
| PACK-04 | `typst.toml` package manifest with correct metadata | Does not exist yet; must create using ambivalent-amcis structure as pattern |
| PACK-05 | Example document includes sample citations from references.bib | Exists (Discussion section has 3 @key citations); may need prose-form example added |
| PACK-06 | Example document includes figure and table examples with captions | Exists (rect placeholder figure + stats table in Methodology section); may need labels added |
| PACK-07 | Template file includes inline comments explaining formatting decisions | Partial — most sections have comments; need audit for completeness, especially spacing values |
</phase_requirements>

---

## Standard Stack

### Core
| Library | Version | Purpose | Why Standard |
|---------|---------|---------|--------------|
| Typst native | 0.14.2 | Compiles .typ files, resolves typst.toml | No alternatives; Typst CLI is the build tool |
| typst.toml | n/a (TOML format) | Package manifest for Typst Universe submission | Required by Typst package registry |

### Supporting
| Library | Version | Purpose | When to Use |
|---------|---------|---------|-------------|
| BibTeX (.bib format) | native | Sample bibliography entries for template | Already in use; expand entry types for richer demo |
| apa.csl | bundled (project root) | APA 7th citation formatting | Already bundled and wired in misq.typ |

### Alternatives Considered
| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| typst.toml at root | No manifest | No typst.toml = not publishable to Typst Universe; required |
| Relative `../misq.typ` import in template | `@preview/misq:0.1.0` | Full package import is correct for published packages; relative import is correct during development; Phase 5 handles the switch |

**Installation:** No new packages needed. This phase is file creation/editing only.

---

## Architecture Patterns

### Recommended Project Structure (Phase 4 target)
```
typst-misq/
├── misq.typ          # Template function — already complete; add/audit comments (PACK-01, PACK-07)
├── apa.csl           # Bundled APA 7th CSL — already present; no changes needed
├── typst.toml        # NEW: package manifest (PACK-04)
└── template/
    ├── main.typ      # Expand to full showcase document (PACK-02, PACK-05, PACK-06)
    └── references.bib  # Possibly expand; already has 3 entries (PACK-03)
```

### Pattern 1: typst.toml Manifest Structure
**What:** TOML file at project root with `[package]` section (always) and `[template]` section (for template packages).
**When to use:** Required for all Typst Universe submissions.
**Example:**
```toml
# Source: ambivalent-amcis/typst.toml (same author, proven pattern)
[package]
name = "misq"
version = "0.1.0"
entrypoint = "misq.typ"
authors = ["Ryan Schuetzler <ryan.schuetzler@byu.edu>"]
license = "MIT"
description = "A Typst template for MIS Quarterly manuscript submissions"
keywords = [
  "MISQ",
  "MIS Quarterly",
  "academic",
  "management information systems",
  "APA"
]
categories = ["paper"]
disciplines = ["computer-science"]
exclude = ["template/main.pdf"]

[template]
path = "template"
entrypoint = "main.typ"
thumbnail = "thumbnail.png"
```

**Notes on specific fields:**
- `version`: Start at `"0.1.0"` — SemVer, full major.minor.patch required
- `entrypoint`: `"misq.typ"` (the template definition file, not template/main.typ)
- `categories`: `"paper"` is the correct category for academic paper templates (valid values confirmed from Typst packages CATEGORIES.md: `paper`, `report`, `thesis`, `book`, `poster`, etc.)
- `disciplines`: `"computer-science"` matches ambivalent-amcis pattern; IS research is closest to computer-science in Typst's taxonomy
- `exclude`: Exclude `template/main.pdf` (large binary, regeneratable) — mirrors ambivalent-amcis pattern
- `thumbnail`: Phase 5 requirement (DEPLOY-04); declare path here even though thumbnail doesn't exist yet — or omit until Phase 5 generates it

**IMPORTANT:** The `thumbnail` field in `[template]` is required for Typst Universe submission but is NOT required for `typst compile` to succeed. Phase 4 can declare the path in typst.toml without the file existing. Phase 5 generates it.

### Pattern 2: Template/main.typ Example Document Structure
**What:** A showcase document that MISQ authors can copy and adapt as their starting point. Must demonstrate every feature so authors see how to use it.
**When to use:** Any Typst template package that targets a specific submission format.

**Required demonstration items (from success criteria):**
1. All three heading levels (level 1 = centered uppercase bold, level 2 = centered bold, level 3 = left bold)
2. Multiple citation patterns: parenthetical `@key`, prose form `#cite(<key>, form: "prose")`
3. At least one figure with caption
4. At least one table (inside `#figure()`) with caption
5. Appendix section that renders with the correct heading and page break

**Current state of template/main.typ (post Phase 3):**
- All three heading levels: PRESENT (Introduction=L1, Theoretical Background=L2, Key Constructs=L3)
- Citations: PRESENT (3 @key citations in Discussion); MISSING prose-form `#cite(form: "prose")` example
- Figure: PRESENT (rect placeholder in Methodology)
- Table: PRESENT (stats table in Methodology)
- Appendix: PRESENT (`#align(center, text(weight: "bold", size: 12pt)[APPENDIX])` + content)
- Body text: PRESENT but content is "test document" — needs polishing to look like real MISQ use

**Gap analysis:**
- Success criterion 2 requires "multiple citation patterns" — current has only `@key` parenthetical; should add prose form
- Success criterion 3 requires appendix section "renders with the correct heading and page break" — current appendix uses manual inline formatting, not the pattern an author would use; document it clearly
- Content reads as a dev test document — Phase 4 should rewrite as a professional looking MISQ sample (but keep the structure the same)

### Pattern 3: Inline Comment Style in misq.typ
**What:** Comments in `misq.typ` explain WHY formatting decisions were made, not just WHAT the code does. They reference MISQ requirements (PAGE-01, TYPO-02, etc.) and explain calibration rationale.
**When to use:** Every non-obvious set rule and show rule in the template file.

**Established comment style (from existing misq.typ):**
```typst
// --- Section name (REQUIREMENT-IDs) ---
// What the rule does: plain English
// Why this value/approach: calibration note, LaTeX equivalence, or constraint reference
set rule(...)
```

**Existing comments — audit findings:**
- Page geometry: GOOD — explains US Letter, margins, LaTeX equivalence
- Font: GOOD — explains TNR requirement, Times fallback policy
- Body spacing: GOOD — explains double-spacing calibration values (1.85em)
- Paragraph style toggle: GOOD — explains "indent" vs "block" modes
- Citation style: GOOD — explains auto-apply and override behavior
- Bibliography show rule: PARTIAL — explains STRC-03 heading formatting but missing explanation of WHY hanging-indent requires block-level show rule (GitHub issue #2639 workaround)
- Heading numbering: GOOD — explains "1.1" pattern and trailing dot avoidance
- Heading show rules: GOOD — explains counter(heading).display() need
- Abstract spacing: GOOD — explains 1.5x calibration
- Page break: GOOD — explains weak: true

**Missing comments (PACK-07 gaps):**
- Bibliography block show rule (lines 64-72): Needs comment explaining CSL `hanging-indent="false"` requirement and the block-level workaround
- Figure single-spacing rule: PARTIAL — explains what but not the `show figure: set par()` scoping mechanism
- `all: true` in first-line-indent: Needs comment explaining why `all: true` is required (propagates indent to paragraphs following headings)

### Pattern 4: Appendix Pattern for Authors
**What:** Authors place appendix content after bibliography using a manual page break and heading.
**Why manual:** Phase 2 decision — bib parameter removed from misq(); authors control placement for appendix ordering.
**Example pattern to document in template/main.typ:**
```typst
#pagebreak()

#bibliography("references.bib", title: "References")

#pagebreak()

// Appendix: manual heading — MISQ style: centered, bold, uppercase
// Use plain text (not a = heading) to avoid auto-numbering
#align(center, text(weight: "bold", size: 12pt)[APPENDIX])

Your appendix content here.
```

**Why `#align()` not `= APPENDIX`:** Using a Typst heading (`= APPENDIX`) would auto-number it (e.g., "4 APPENDIX") following the preceding numbered sections. The manual approach matches MISQ's unnumbered appendix heading pattern. This should be clearly explained in template/main.typ comments.

---

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Package metadata format | Custom format | typst.toml TOML standard | Typst CLI parses typst.toml; any deviation breaks `typst init` and Universe submission |
| Citation in bib file | Custom cite syntax | Standard BibTeX format | Typst's native bibliography() parses BibTeX; hayagriva format also supported but BibTeX is more portable |
| Appendix heading | Custom macros | Direct `#align(center, text(...)[APPENDIX])` | Template already establishes this as the approved pattern (Phase 2 decision); document it, don't change it |

---

## Common Pitfalls

### Pitfall 1: thumbnail Required for Universe but Not for Compile
**What goes wrong:** Planner includes thumbnail creation in Phase 4 (which lacks image-generation tooling), blocking the typst.toml from being valid.
**Why it happens:** The `[template]` section's `thumbnail` field is mentioned as a requirement in manifest docs. It is required for UNIVERSE SUBMISSION (Phase 5), not for `typst compile` to succeed.
**How to avoid:** In Phase 4, declare `thumbnail = "thumbnail.png"` in typst.toml but do NOT require the file to exist. Phase 5 (Deploy) generates the thumbnail from the PDF. The file absence does not break compilation.
**Warning signs:** Task that tries to generate a screenshot or PNG in Phase 4.

### Pitfall 2: Template entrypoint vs Package entrypoint
**What goes wrong:** Setting `entrypoint` in `[package]` to `"template/main.typ"` instead of `"misq.typ"`.
**Why it happens:** Confusion between "what file do I compile" (template/main.typ) and "what file is the package library" (misq.typ).
**How to avoid:**
- `[package] entrypoint = "misq.typ"` — this is what gets imported when someone writes `#import "@preview/misq:0.1.0": misq`
- `[template] entrypoint = "main.typ"` — path relative to `[template] path = "template"`; this is what gets copied to a new project
**Warning signs:** `typst init @preview/misq` creates a project that doesn't compile because entrypoint points to template file.

### Pitfall 3: Template/main.typ Relative Import in Published Package
**What goes wrong:** Published package has `#import "../misq.typ": misq` which breaks when users run `typst init @preview/misq`.
**Why it happens:** During development, the relative import works because template/ is a subdirectory. After `typst init`, the user's project only has `template/` contents copied — `../misq.typ` doesn't exist in their project.
**How to avoid:** Phase 5 (Deploy) switches `#import "../misq.typ"` to `#import "@preview/misq:0.1.0"`. Phase 4 keeps the relative import for dev compilation.
**Warning signs:** Phase 4 task tries to change the import path.

### Pitfall 4: Bibliography Compile Needs --root Flag
**What goes wrong:** `typst compile template/main.typ` fails with "file not found" for `apa.csl`.
**Why it happens:** `apa.csl` is at project root. When compiling from `template/main.typ`, Typst resolves relative paths in `misq.typ` from `misq.typ`'s directory (project root). However, without `--root`, Typst may restrict file access to the directory containing the entry file.
**How to avoid:** Compile with `typst compile --root . template/main.typ` OR from the project root. The verification command should always use `--root .`.
**Warning signs:** Phase 3 verification used `typst compile --root . template/main.typ` — continue this pattern.

### Pitfall 5: disciplines Field Values
**What goes wrong:** Using `"information-systems"` or `"management"` as discipline values — these may not be valid Typst taxonomy values.
**Why it happens:** The Typst disciplines list doesn't perfectly map to all academic fields.
**How to avoid:** Use `"computer-science"` which is confirmed valid (used in ambivalent-amcis). MISQ is an IS journal but Typst's taxonomy doesn't have IS; computer-science is the nearest match and is the established pattern for this author's packages.
**Warning signs:** Typst Universe submission validator rejects manifest.

---

## Code Examples

Verified patterns from official sources and project files:

### typst.toml — Complete Manifest (based on ambivalent-amcis pattern)
```toml
# Source: ambivalent-amcis/typst.toml (same author, verified submission)
[package]
name = "misq"
version = "0.1.0"
entrypoint = "misq.typ"
authors = ["Ryan Schuetzler <ryan.schuetzler@byu.edu>"]
license = "MIT"
description = "A Typst template for MIS Quarterly manuscript submissions"
keywords = [
  "MISQ",
  "MIS Quarterly",
  "academic",
  "management information systems",
  "APA",
  "IS research"
]
categories = ["paper"]
disciplines = ["computer-science"]
exclude = ["template/main.pdf"]

[template]
path = "template"
entrypoint = "main.typ"
thumbnail = "thumbnail.png"
```

### Inline Comment Pattern for Spacing Values
```typst
// --- Bibliography formatting (TYPO-04, TYPO-06, STRC-03) ---
// Single-spacing (0.65em) + 0.5-inch hanging indent + REFERENCES heading.
// 0.65em leading/spacing = single-spacing for 12pt Times (matches par.leading at 1x).
// Hanging indent requires block-level show rule because apa.csl has hanging-indent="false"
// (CSL hanging-indent="true" blocks Typst par-level overrides — Typst issue #2639).
// All formatting combined in ONE show bibliography rule — multiple transformational
// show rules for the same element cause the last to overwrite earlier ones.
show bibliography: it => {
  ...
}
```

### Appendix Pattern for template/main.typ
```typst
// Source: MISQ LaTeX template (MISQ_Submission_Template_LaTeX.tex line 89)
// LaTeX: \section*{\centering{APPENDIX}}
// Typst equivalent: manual heading to avoid auto-numbering
// Note: using = APPENDIX would produce "4 APPENDIX" (auto-numbered heading)
#pagebreak()

#align(center, text(weight: "bold", size: 12pt)[APPENDIX])

This appendix contains supplementary materials. Authors may use "APPENDIX A",
"APPENDIX B", etc. for multiple appendices.
```

### Prose-form Citation Pattern for template/main.typ
```typst
// Source: https://typst.app/docs/reference/model/cite/
// Parenthetical (default): @orlikowski1992duality → (Orlikowski, 1992)
// Prose form: #cite(<orlikowski1992duality>, form: "prose") → Orlikowski (1992)
#cite(<orlikowski1992duality>, form: "prose") demonstrated the duality of technology.
Later work by @brown2023fault extended this finding.
```

### Figure with Label Pattern for template/main.typ
```typst
// Source: https://typst.app/docs/reference/model/figure/
#figure(
  rect(width: 4in, height: 2in, fill: luma(230)),
  caption: [A sample figure caption in single-spaced text.]
) <fig:example>

// Cross-reference:
As shown in @fig:example, the figure demonstrates...
```

---

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| No typst.toml | typst.toml required for Universe | Typst 0.6+ | Template packages must declare [template] section |
| Relative imports in template | Full `@preview/` import recommended | Typst 0.9+ (typst init feature) | Template entrypoint must compile after `typst init` copies files |
| thumbnail optional | thumbnail required for Universe submission | Policy (not version-gated) | PNG or lossless WebP, ≥1080px longer edge, ≤3 MiB |

**Deprecated/outdated:**
- `#import "../misq.typ"` in published template: Breaks after `typst init`; must become `@preview/misq:0.1.0` before publication (Phase 5 concern)

---

## Open Questions

1. **thumbnail in typst.toml during Phase 4**
   - What we know: thumbnail.png is a Phase 5 (DEPLOY-04) deliverable; typst.toml [template] thumbnail field points to it
   - What's unclear: Whether declaring `thumbnail = "thumbnail.png"` in typst.toml when the file doesn't exist causes any compilation or validation error
   - Recommendation: Include `thumbnail = "thumbnail.png"` in Phase 4's typst.toml. Typst CLI does NOT validate thumbnail existence during compile — only the Universe submission checker does. Confirmed by ambivalent-amcis pattern (thumbnail.png is present there but Phase 4 doesn't generate it).

2. **references.bib expansion scope**
   - What we know: Current bib has 3 entries covering all author-count citation cases (1, 2, 3+); all are journal articles
   - What's unclear: Whether Phase 4 success criteria require additional entry types (book, conference proceeding, etc.) for a richer demo
   - Recommendation: Add one book entry to template/references.bib to demonstrate APA book citation format in the sample document. Keep total entries ≤ 5 to avoid padding the template.

3. **Package name / version**
   - What we know: The package follows ambivalent-amcis structure; version should start at 0.1.0
   - What's unclear: Whether the author wants `name = "misq"` or a more descriptive name like `"typst-misq"` or `"misq-template"`
   - Recommendation: Use `"misq"` — it's the shortest unambiguous name, matches the entrypoint filename, and is consistent with how AMCIS used `"ambivalent-amcis"`. Check Typst Universe for existing `"misq"` packages to confirm no conflict.

---

## Validation Architecture

### Test Framework
| Property | Value |
|----------|-------|
| Framework | Visual PDF inspection (no automated test suite) |
| Config file | none |
| Quick run command | `typst compile --root . template/main.typ` |
| Full suite command | `typst compile --root . template/main.typ && open template/main.pdf` |

### Phase Requirements → Test Map
| Req ID | Behavior | Test Type | Automated Command | File Exists? |
|--------|----------|-----------|-------------------|-------------|
| PACK-01 | `misq.typ` exists at root with `misq()` function | smoke | `typst compile --root . template/main.typ` | ✅ misq.typ |
| PACK-02 | `template/main.typ` compiles and produces correctly-formatted PDF | smoke | `typst compile --root . template/main.typ` | ✅ template/main.typ |
| PACK-03 | `template/references.bib` exists with sample entries | smoke | `typst compile --root . template/main.typ` (bibliography call fails if bib missing) | ✅ template/references.bib |
| PACK-04 | `typst.toml` exists with correct metadata | smoke | `cat typst.toml` + field check | ❌ Wave 0: create typst.toml |
| PACK-05 | Example document includes sample citations | visual | `typst compile --root . template/main.typ` + PDF review | ✅ citations present in main.typ |
| PACK-06 | Example document includes figure and table with captions | visual | `typst compile --root . template/main.typ` + PDF review | ✅ figure + table in main.typ |
| PACK-07 | `misq.typ` has inline comments explaining formatting decisions | manual | Read misq.typ and audit comments | ✅ partial — needs audit |

### Sampling Rate
- **Per task commit:** `typst compile --root . template/main.typ`
- **Per wave merge:** `typst compile --root . template/main.typ && open template/main.pdf` (visual check)
- **Phase gate:** All 7 requirements verified before `/gsd:verify-work`

### Wave 0 Gaps
- [ ] `typst.toml` — covers PACK-04 (must be created; compilation does not require it but it is a required deliverable)

*(No new test files needed — existing template/main.typ is the test artifact. Visual PDF inspection is the verification method for this phase.)*

---

## Sources

### Primary (HIGH confidence)
- `/Users/ryanschuetzler/code/typst-misq/misq.typ` — Current template file; read line-by-line for comment audit
- `/Users/ryanschuetzler/code/typst-misq/template/main.typ` — Current example document; gap-analyzed against success criteria
- `/Users/ryanschuetzler/code/ambivalent-amcis/typst.toml` — Reference typst.toml from same author's published package
- `/Users/ryanschuetzler/code/typst-misq/MISQ_Submission_Template_LaTeX.tex` — Source of truth for MISQ formatting; appendix pattern on line 89

### Secondary (MEDIUM confidence)
- https://github.com/typst/packages/blob/main/docs/manifest.md — typst.toml field definitions (fetched via WebFetch)
- https://github.com/typst/packages/blob/main/docs/typst.md — Template file standards: full package import requirement for published templates
- CATEGORIES.md from typst/packages — confirmed `"paper"` as valid category value

### Tertiary (LOW confidence)
- WebSearch results about typst.toml categories/disciplines — general background; verified against primary sources

---

## Metadata

**Confidence breakdown:**
- typst.toml structure: HIGH — copied directly from ambivalent-amcis (same author's proven published pattern) + verified against manifest docs
- template/main.typ gaps: HIGH — gap analysis performed against success criteria by reading actual file contents
- misq.typ comment audit: HIGH — read full file, identified specific gaps
- Pitfalls: HIGH — thumbnail/entrypoint issues verified against official docs; import path issue confirmed from typst.md template standards

**Research date:** 2026-03-13
**Valid until:** 2026-06-13 (typst.toml format is stable; categories list changes rarely)
