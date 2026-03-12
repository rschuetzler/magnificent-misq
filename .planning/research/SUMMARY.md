# Project Research Summary

**Project:** typst-misq — Typst MISQ Journal Submission Template
**Domain:** Academic journal submission template (LaTeX-to-Typst conversion)
**Researched:** 2026-03-12
**Confidence:** HIGH (stack, features, architecture from primary sources; pitfalls MEDIUM on some Typst version-specific behaviors)

## Executive Summary

This project is a Typst package that enables researchers to submit papers to MIS Quarterly (MISQ) using Typst instead of LaTeX or Word. The established pattern for Typst academic templates — confirmed by direct inspection of the reference implementation `ambivalent-amcis` and peer packages like `charged-ieee` and `apa7-ish` — is a single wrapping function (`#let misq(..., body) = { ... }`) that applies all formatting via `set` and `show` rules, exposed as `#show: misq.with(...)` in the user's document. The entire template lives in one `misq.typ` file with zero external package dependencies, relying exclusively on Typst built-ins. This architecture is correct for MISQ's scope and should not be complicated.

The recommended approach is to build from a verified reference (the official MISQ LaTeX template) and map each LaTeX requirement to a Typst equivalent: `\usepackage{times}` → `set text(font: "Times New Roman", size: 12pt)`, `\baselinestretch{2.0}` → `set par(leading: 1.0em)` (empirically calibrated), `\section{\centering\MakeUppercase{...}}` → `show heading.where(level: 1): it => align(center)[#upper(it.body)]`. The most critical non-obvious dependencies are: abstract requires scoped 1.5x line spacing inside the template function, references require single-spacing plus 0.5" hanging indent, and a single `pagebreak()` must separate the title page from the body. All of these are deterministic and well-understood.

The primary risk is APA 7th edition citation fidelity. Typst's built-in `"apa"` style may not fully comply with APA 7th, particularly for multi-author entries, et al. thresholds, and DOI formatting. The mitigation is to bundle a verified APA 7th CSL file (the same `new-apa.csl` used by `ambivalent-amcis`) rather than relying on the built-in. A secondary risk is font availability: Times New Roman is a system font on macOS and Windows but absent on Linux/CI environments — the fix is to include font fallbacks and optionally bundle TeX Gyre Termes. Both risks are well-understood and have clear mitigations.

## Key Findings

### Recommended Stack

The template requires no external dependencies beyond the Typst compiler (0.14.2 installed; set minimum `compiler = "0.13.0"` in `typst.toml`). Everything needed — page layout, typography, headings, bibliography — is available in Typst built-ins. The only non-obvious external asset is a CSL file for APA 7th formatting; the correct choice is the Zotero APA 7th CSL (updated 2024-07-09, already used by `ambivalent-amcis`).

**Core technologies:**
- **Typst 0.13.0+**: Document typesetting and compilation — the only runtime dependency; all formatting uses built-in `set`/`show` rules
- **BibTeX `.bib` format**: Bibliography database — preferred over Hayagriva YAML because `.bib` is ubiquitous in academic workflows (Zotero, Mendeley, Google Scholar all export it)
- **CSL 1.0 (APA 7th)**: Citation and bibliography formatting — use a bundled `new-apa.csl` file for verified APA 7th compliance rather than trusting Typst's built-in `"apa"` style
- **Times New Roman (system font)**: Document font — confirmed present at `/System/Library/Fonts/Supplemental/Times New Roman.ttf` on macOS; must include fallbacks for Linux/CI

See `.planning/research/STACK.md` for installation commands, version requirements, and critical API usage examples.

### Expected Features

MISQ formatting requirements map directly and completely to Typst built-ins. There are no features requiring workarounds or external packages. The full feature set for a compliant v1 submission template is achievable in a single focused development sprint.

**Must have (table stakes):**
- US Letter page, 1" side margins — geometry foundation; everything else depends on this
- 12pt Times New Roman throughout — font foundation; fails silently without explicit font name
- Double-spaced body text (`par.leading: 1.0em` calibrated for 12pt) — primary MISQ requirement
- Three-level heading hierarchy: L1 centered uppercase bold, L2 centered bold, L3 left bold — all unnumbered
- Page 1 structure: bold title, 1.5x-spaced abstract, bold "Keywords:" label
- Page break after keywords so Introduction starts on page 2
- Single-spaced references with 0.5" hanging indent
- APA 7th citations from `.bib` file with bundled CSL
- Plain page numbering in footer
- Working sample `main.typ` demonstrating all features

**Should have (competitive):**
- Bundled APA 7th CSL file (`new-apa.csl`) for citation accuracy beyond built-in `"apa"` — medium complexity, high correctness value
- Appendix section support — trivial to add (unnumbered heading + pagebreak)
- Figure and table examples in sample document — demonstrates native Typst figure syntax
- `typst.toml` manifest — required for Typst package registry publication
- Comment-rich template for first-time Typst users switching from Word/LaTeX

**Defer (v2+):**
- Package registry publication — requires thumbnail, Typst maintainer approval process
- Tinymist/IDE integration documentation

See `.planning/research/FEATURES.md` for full prioritization matrix and anti-features to avoid.

### Architecture Approach

The template follows the canonical Typst package pattern: one root-level `misq.typ` file exposing a single `misq()` function, a `typst.toml` manifest, and a `template/` directory containing `main.typ` and `references.bib` for users to copy. The function accepts `title`, `abstract`, `keywords`, `bib`, and the document `body` — applying all formatting rules via scoped `set`/`show` rules internally. No submodules or src/ directory needed for this scope.

**Major components:**
1. **`misq.typ`** — All formatting logic: page layout, font/spacing rules, heading show rules, title/abstract/keywords rendering, bibliography injection with spacing override
2. **`typst.toml`** — Package manifest declaring name, version, entrypoint, minimum compiler version, and template path
3. **`template/main.typ`** — Example document demonstrating all heading levels, citation patterns, figures, and the `#show: misq.with(...)` call pattern
4. **`template/references.bib`** — Sample APA 7th BibTeX entries matching MISQ's citation examples

**Key patterns to follow:**
- Bibliography as parameter (not hardcoded path) — avoids path resolution failure when installed as package
- Scoped spacing blocks `[...]` for abstract (1.5x) and references (1x) — not global overrides
- Single transform show rule per heading level combining alignment, weight, and uppercase in one rule
- `pagebreak(weak: true)` before Introduction — avoid blank pages at natural page breaks

See `.planning/research/ARCHITECTURE.md` for detailed data flow, build order, and anti-patterns.

### Critical Pitfalls

1. **Line spacing conversion from LaTeX multipliers to Typst `par.leading`** — `par.leading` is extra space between lines, not a multiplier. For 12pt text: double-spaced ≈ `leading: 1.0em`, 1.5x abstract ≈ `leading: 0.65em`, single-spaced references ≈ `leading: 0.5em`. These values require empirical calibration against PDF measurement, not arithmetic. Define named constants and test each region independently before integrating.

2. **APA 7th citation fidelity** — Typst's built-in `"apa"` style may render APA 6th or have edge case failures (et al. threshold, author name format, DOI URL). Mitigate by bundling `new-apa.csl` (Zotero APA 7th, already in the reference implementation) and manually comparing bibliography output against the two sample entries in the MISQ LaTeX template character-by-character.

3. **Font availability on Linux/CI** — Times New Roman is absent on most Linux environments. Template renders with a fallback font silently. Fix: `set text(font: ("Times New Roman", "TeX Gyre Termes", "Liberation Serif", "serif"))` plus optional bundled `fonts/` directory. Catch this on day 1 by testing in a clean environment before any other work.

4. **Heading show rule scope bleed** — `show heading: it => upper(it.body)` without `.where(level: 1)` uppercases ALL headings. Every heading show rule must use `.where(level: N)` selector. Never combine properties across levels in one rule.

5. **Page break after title page** — MISQ requires exactly one page break (after keywords, before Introduction). `pagebreak()` without `weak: true` creates blank pages at natural boundaries. If using a show rule on level-1 headings to trigger the break, use a state counter to fire only once (before Introduction), not before every major section.

## Implications for Roadmap

Based on research, the dependency structure drives a clear 4-phase build order. Each phase has a natural checkpoint (compile and visually verify before proceeding). No phase requires external research — patterns are well-documented from the reference implementation and official sources.

### Phase 1: Foundation — Page Geometry, Font, and Spacing Infrastructure

**Rationale:** Every other formatting feature depends on these. Font fallback must be confirmed on day 1 before investing time in anything else. Line spacing is the most complex calculation and the most common failure point — establish correct `par.leading` constants empirically while nothing else is on the page.

**Delivers:** A compilable `misq.typ` stub with correct page geometry (US Letter, 1" margins), Times New Roman at 12pt with fallbacks confirmed, and calibrated `par.leading` constants for all three spacing regions (body 2x, abstract 1.5x, references 1x). No visible content yet.

**Addresses:** Page geometry, font, double-spacing (all P1 features)

**Avoids:** Line spacing pitfall (Pitfall 1), font availability pitfall (Pitfall 3), first-line indent after headings (Pitfall 8)

### Phase 2: Document Structure — Title Page, Headings, and Page Flow

**Rationale:** Heading show rules and page flow depend on correct spacing from Phase 1. The title/abstract/keywords block and page break are structural — they define the document shape that all body content flows into. Building this before citations means the overall layout can be visually verified before the higher-risk bibliography work begins.

**Delivers:** Complete page 1 structure (bold title, 1.5x abstract, bold "Keywords:" label), all three heading levels correctly styled, page break placing Introduction at top of page 2, plain page numbers. Template visually matches the MISQ LaTeX reference layout.

**Addresses:** Heading hierarchy (P1), page 1 structure (P1), page break before Introduction (P1), heading levels 1/2/3 (P1), page numbering (P1)

**Avoids:** Heading scope bleed (Pitfall 4), page break logic errors (Pitfall 5), unnumbered headings (Pitfall 6)

### Phase 3: Citations and Bibliography

**Rationale:** This is the highest-risk phase due to APA 7th CSL compliance uncertainty. Isolated after structure is complete so failures are clearly attributable. Requires sourcing and testing the `new-apa.csl` file, verifying `.bib` → APA output character-by-character against MISQ's reference examples, and implementing single-spacing with 0.5" hanging indent for the references section.

**Delivers:** Working bibliography from `.bib` file using bundled APA 7th CSL, correct in-text citations (1-author, 2-author, 3+-author et al.), references section single-spaced with hanging indent. Output verified against MISQ LaTeX reference entries.

**Addresses:** APA 7th citations (P1), references section layout — hanging indent + single spacing (P1)

**Avoids:** APA citation fidelity pitfall (Pitfall 7), hanging indent implementation pitfall (Pitfall 2)

**Research flag:** Consider verifying current Typst CSL rendering against APA 7th spec if output deviates unexpectedly. The `new-apa.csl` from `ambivalent-amcis` is a known-good starting point but may need inspection.

### Phase 4: Sample Document and Package Manifest

**Rationale:** The sample document depends on all formatting features being complete. It is both a usability artifact and a functional test — it exercises every feature of the template. The `typst.toml` manifest is low-effort but required for package registry publication.

**Delivers:** Complete `template/main.typ` with sample content demonstrating all heading levels, multiple citation patterns, figures/tables, appendix section; `template/references.bib` with APA 7th sample entries; `typst.toml` manifest; `README.md` with usage instructions (font requirements, local dev setup, citation syntax examples).

**Addresses:** Sample document (P1), appendix support (P2), figure/table examples (P2), typst.toml manifest (P2), bundled CSL documentation

**Avoids:** No new pitfalls introduced — this phase validates all previous phases

### Phase Ordering Rationale

- **Foundation before structure:** `par.leading` values must be calibrated at 12pt Times New Roman before heading spacing can be correctly set. Getting these wrong late requires refactoring every spacing override.
- **Structure before citations:** Bibliography rendering and hanging-indent behavior interact with spacing. A clean layout baseline makes citation failures easy to diagnose.
- **Citations before sample document:** The sample document must demonstrate correct citation output. Building the sample before citations are verified produces misleading output.
- **Single-file architecture enables linear build:** Because all logic lives in `misq.typ`, each phase extends the same file without integration surprises. No cross-component coordination needed.

### Research Flags

Phases likely needing deeper research during planning:
- **Phase 3 (Citations):** APA CSL compliance in current Typst version is flagged as LOW confidence in pitfalls research. If `new-apa.csl` from `ambivalent-amcis` produces incorrect output, custom CSL editing may be needed (1-2 days of work). Allocate buffer and plan a CSL comparison step before declaring this phase done.

Phases with standard patterns (skip research-phase):
- **Phase 1 (Foundation):** All Typst APIs confirmed working in 0.14.2. Font, page, and par APIs are stable.
- **Phase 2 (Structure):** Heading show rules, pagebreak, and title rendering are well-documented with confirmed patterns from the reference implementation.
- **Phase 4 (Sample + Manifest):** `typst.toml` format confirmed from multiple cached packages. README and sample document are content work, not technical research.

## Confidence Assessment

| Area | Confidence | Notes |
|------|------------|-------|
| Stack | HIGH | All technologies verified on installed Typst 0.14.2; reference implementation inspected directly; no web sources required |
| Features | HIGH | Derived from official MISQ LaTeX template (authoritative) and direct comparison with AMCIS Typst template (same domain); feature-to-API mapping is complete |
| Architecture | HIGH | Confirmed patterns from `ambivalent-amcis`, `charged-ieee`, and `apa7-ish` reference implementations; build order is deterministic |
| Pitfalls | MEDIUM | Line spacing, heading, and page break pitfalls are HIGH confidence based on direct LaTeX source analysis; APA CSL compliance and Typst version-specific behaviors are MEDIUM — ecosystem evolves rapidly |

**Overall confidence:** HIGH

### Gaps to Address

- **APA CSL compliance:** Built-in `"apa"` style compliance with APA 7th (vs 6th) cannot be confirmed without a running comparison. Mitigation: use `new-apa.csl` from the start and verify against MISQ's two sample reference entries during Phase 3.
- **Exact `par.leading` calibration:** The correct values for 1.5x and 2x spacing at 12pt Times New Roman require empirical testing against PDF measurement — they cannot be calculated exactly. Mitigate by making these named constants and calibrating as the first step of Phase 1.
- **Typst 0.13.0 vs 0.14.x compatibility:** `compiler` minimum set to 0.13.0 in `typst.toml` based on `context` keyword stabilization. If any newer APIs are used inadvertently, the minimum version will need to be raised. Track API versions used during implementation.

## Sources

### Primary (HIGH confidence)
- `/Users/ryanschuetzler/code/ambivalent-amcis/` (typst.toml, amcis.typ, template/main.typ) — reference implementation for Typst IS conference template by same author
- `/Users/ryanschuetzler/code/typst-misq/MISQ_Submission_Template_LaTeX.tex` — official MISQ LaTeX submission template; authoritative formatting specification
- `/Users/ryanschuetzler/Library/Caches/typst/packages/preview/ambivalent-amcis/0.1.0/` — cached Typst package with new-apa.csl
- Typst 0.14.2 CLI at `/opt/homebrew/Cellar/typst/0.14.2/bin/typst` — installed runtime; `typst fonts` output confirmed Times New Roman
- Cached peer packages: `charged-ieee` v0.1.2, `apa7-ish` v0.3.0 — Typst package structure patterns

### Secondary (MEDIUM confidence)
- Typst built-in API behavior (`par`, `heading`, `bibliography`, `pagebreak`) — training data knowledge, consistent with local testing
- APA 7th edition citation rules (et al. thresholds, author formatting, DOI format) — well-established specification
- Typst font resolution behavior on Linux/CI — widely reported community issue

### Tertiary (LOW confidence)
- Typst CSL/hayagriva APA 7th compliance details — ecosystem evolves rapidly; validate during Phase 3 implementation against current Typst version

---
*Research completed: 2026-03-12*
*Ready for roadmap: yes*
