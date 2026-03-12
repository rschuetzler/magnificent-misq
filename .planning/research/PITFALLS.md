# Pitfalls Research

**Domain:** Typst academic journal template (LaTeX-to-Typst conversion, MISQ)
**Researched:** 2026-03-12
**Confidence:** MEDIUM — Based on Typst official documentation knowledge and direct LaTeX source analysis. Web search unavailable; some version-specific behaviors flagged as LOW confidence where Typst evolves rapidly.

---

## Critical Pitfalls

### Pitfall 1: Mixed Line Spacing via Show Rules Affects Everything

**What goes wrong:**
Using `set par(leading: ...)` or `set block(spacing: ...)` globally then trying to override it per-region fails silently or applies incorrectly. The MISQ template requires three distinct spacing regions: double-spaced body, 1.5x abstract, single-spaced references. Developers who set global spacing and then attempt local overrides often find the override applies to the wrong scope or is overridden by a parent show rule.

**Why it happens:**
Typst's styling cascade works via context and show rules, not via local assignments like LaTeX's `\renewcommand{\baselinestretch}`. The `set` rule in Typst applies to all content in its scope. When developers try to recreate `\renewcommand{\baselinestretch}{1.5}\normalsize` inside a block, they use `set par(leading: ...)` but forget that Typst measures `leading` in absolute units (e.g., `0.65em`) not as a multiplier. Getting the multiplier-to-absolute conversion wrong is nearly universal.

**How to avoid:**
- Define named spacing constants at the top: `let body-leading = 1em` (for 12pt font, 2x = 24pt, so leading after baseline = 12pt = 1em)
- Use `show: it => { set par(leading: body-leading); it }` as a wrapper for body sections
- For abstract: wrap the abstract content in a function that applies `set par(leading: 0.5em)` (1.5x for 12pt = 18pt total, leading = 6pt = 0.5em)
- For references: apply single spacing via a dedicated show rule on the references heading or wrapping function
- Test each region independently before integrating

**Warning signs:**
- Abstract looks the same spacing as body text
- References section appears double-spaced
- Line spacing changes after a heading but not within the paragraph

**Phase to address:** Core typography setup phase (foundational — get this right before any other content)

---

### Pitfall 2: `hangindent` Reference Formatting Does Not Translate Directly

**What goes wrong:**
The LaTeX template uses `\hangindent=0.5in \hangafter=1` applied once to an entire `flushleft` block with entries separated by `\\`. This is a LaTeX-specific hack. In Typst, there is no single-line `hangindent` property applied to a block of `\\`-separated entries. Developers who attempt to replicate this using `par(hanging-indent: 0.5in)` on a block will find either (a) it applies to every paragraph including the first line, or (b) multi-line entries don't indent correctly.

**Why it happens:**
Typst's `par(hanging-indent: ...)` does implement hanging indent, but each reference entry must be a distinct paragraph for it to work correctly. The LaTeX source uses `\\` line breaks inside a single flushleft environment — this means all entries in the LaTeX template are actually one paragraph with forced line breaks, not separate paragraphs. Typst doesn't have the `\hangafter` concept; its hanging indent applies from the second line of each paragraph automatically.

**How to avoid:**
- Treat each reference as a separate Typst paragraph (blank line between entries, or use a list structure)
- Apply `set par(hanging-indent: 0.5in, first-line-indent: 0in)` inside the references block
- Use a `block` or `stack` to contain all references with the correct par settings
- If using a citation manager (hayagriva/biblatex), verify the CSL or bib style outputs APA 7th with correct formatting — don't hand-code references
- Test with a 3+ line reference entry to confirm second and third lines indent correctly

**Warning signs:**
- First reference entry has correct hanging indent but subsequent entries do not
- Multi-line entries have the second line flush left instead of indented
- Reference block looks correct for 1-line entries but breaks on long titles

**Phase to address:** References/bibliography phase

---

### Pitfall 3: Font Availability — Times New Roman vs. "Times"

**What goes wrong:**
The LaTeX template uses `\usepackage{times}` which loads URW Nimbus Roman (a Times Roman clone). In Typst, `font: "Times New Roman"` requires the actual TrueType/OpenType font to be installed on the build system. On Linux CI/CD or cloud environments (Typst web app, GitHub Actions), Times New Roman is typically not installed. The build silently falls back to a different serif font, producing output that visually looks correct locally but differs on other systems.

**Why it happens:**
Typst resolves fonts from the system font registry. Times New Roman is a proprietary Microsoft font not shipped with most Linux distributions. Developers test locally on macOS or Windows where it is available, never notice the fallback, and ship a template that fails on others' machines.

**How to avoid:**
- Explicitly list fallbacks: `set text(font: ("Times New Roman", "TeX Gyre Termes", "Liberation Serif", "serif"))`
- TeX Gyre Termes is a high-quality free Times clone — bundle it with the template as a `fonts/` directory
- Document font requirements in the template README
- Test on a machine without Times New Roman installed (or use Typst's `--font-path` to test with only bundled fonts)
- Consider shipping the font file in the repo (check licensing: TeX Gyre fonts are freely redistributable)

**Warning signs:**
- Template renders differently on collaborator's machine
- PDF metadata shows a different font name than "Times New Roman"
- CI/CD build produces a font warning in stderr

**Phase to address:** Initial template setup phase (font resolution must be confirmed before any other formatting)

---

### Pitfall 4: Heading Hierarchy — Uppercase Transform and Centering

**What goes wrong:**
The MISQ template requires section (level 1) headings to be centered AND uppercase, subsection (level 2) headings to be centered but NOT uppercase, and subsubsection (level 3) headings to be left-aligned and not uppercase. The LaTeX template achieves this by passing `\centering \MakeUppercase{...}` inside the `\section{}` argument. Developers implementing this in Typst either (a) apply `upper()` to all headings via a single show rule, or (b) use a single `show heading` rule that doesn't differentiate levels.

**Why it happens:**
Typst's `show heading: it => ...` rule fires for ALL heading levels unless filtered by `show heading.where(level: 1): it => ...`. Without level filtering, uppercase transform bleeds into subsections. Additionally, Typst's `text(style: "uppercase")` does not exist — the correct function is `upper(it.body)` — and developers sometimes look for a CSS-like `text-transform` equivalent.

**How to avoid:**
```typst
show heading.where(level: 1): it => {
  set align(center)
  set text(weight: "bold")
  upper(it.body)
  v(0.5em)
}
show heading.where(level: 2): it => {
  set align(center)
  set text(weight: "bold")
  it.body
  v(0.25em)
}
show heading.where(level: 3): it => {
  set align(left)
  set text(weight: "bold")
  it.body
  v(0.25em)
}
```
- Never use `show heading` without `.where(level: N)` when levels have different formatting
- Verify all three heading levels render before calling styling complete

**Warning signs:**
- ALL headings appear uppercase, not just level 1
- Level 2 headings are left-aligned instead of centered
- Headings appear bold in some levels and not others

**Phase to address:** Heading hierarchy phase

---

### Pitfall 5: Page Break After Title Page Is Not Automatic

**What goes wrong:**
The LaTeX template inserts `\newpage` before the Introduction section to enforce: title + abstract + keywords on page 1, body starting on page 2. In Typst, `pagebreak()` must be placed explicitly. Developers sometimes use `set heading(...)` spacing to create large vertical gaps, which approximates the page break visually but breaks at different font sizes or content lengths.

**Why it happens:**
There's no direct LaTeX `\newpage` equivalent that can be embedded in style rules. Typst's `pagebreak()` is a content element, not a style property. Developers familiar with LaTeX expect style-level control but Typst requires an explicit content-level page break, which means it must either be placed in the template body or triggered by a show rule on a specific heading.

**How to avoid:**
- Place `pagebreak()` explicitly between the keywords block and the Introduction section in the template
- Or use a show rule: `show heading.where(level: 1): it => { pagebreak(weak: true); it }` — but use `weak: true` to avoid a blank page if a heading falls at a natural page boundary
- Avoid relying on vertical spacing to simulate page breaks
- Note: MISQ only wants a page break before Introduction (first level-1 heading), not before all level-1 headings — use a state variable or `counter` to trigger the break only once

**Warning signs:**
- Title, abstract, keywords, and introduction all appear on page 1
- A blank page appears between every major section
- Page break appears inconsistently depending on abstract length

**Phase to address:** Page layout / title page phase

---

### Pitfall 6: Unnumbered Headings for References and Appendix

**What goes wrong:**
The LaTeX template uses `\section*{REFERENCES}` (starred, unnumbered) for references and appendix. Developers building a Typst template sometimes apply section numbering globally and then struggle to exclude specific headings. A common mistake is setting `set heading(numbering: "1.")` globally and then trying to use a different selector to disable it for specific headings — this is not straightforward in Typst.

**Why it happens:**
Typst's `set heading(numbering: "1.")` applies a numbering scheme, but disabling numbering on a per-heading basis requires either (a) using `heading(numbering: none, ...)` on specific headings, or (b) structuring the template so numbered headings are the explicit subset rather than the default. Many developers get this backwards.

**How to avoid:**
- Since MISQ does NOT number headings at all (Introduction, Major Header, etc. are all unnumbered), do NOT set `heading(numbering: ...)` globally — this simplifies the problem entirely
- Verify the LaTeX source: MISQ uses `\section{...}` not `\section{1. ...}` — numbering is absent
- If future versions need numbering, use `heading(numbering: none)` on individual references/appendix headings rather than fighting global rules

**Warning signs:**
- "1. INTRODUCTION", "2. MAJOR HEADER" appears in the rendered output
- References section shows "3. REFERENCES" with a number

**Phase to address:** Heading hierarchy phase (check numbering behavior early)

---

### Pitfall 7: APA 7th Citation Style — Typst Citation Ecosystem Immaturity

**What goes wrong:**
Typst's native citation system uses hayagriva (`.yml` format) and CSL styles. APA 7th edition CSL exists but has known rendering differences from the gold-standard LaTeX `apacite` or `biblatex-apa` output. Author name formatting ("Brown, S., & Sias, R."), ampersand before last author, hanging indent, and DOI formatting all have edge cases. Developers who import `.bib` files and apply `#cite(...)` with `style: "apa"` often find that multi-author entries, "et al." thresholds, and DOI URL formatting deviate from strict APA 7th.

**Why it happens:**
The CSL ecosystem for Typst is still maturing. The `apa.csl` style file may not fully implement every APA 7th rule. Additionally, Typst's biblio rendering does not automatically produce hanging indents — that must be configured separately in the `bibliography` function call or via show rules.

**How to avoid:**
- Test the bibliography output against the reference entries given in the LaTeX template (`Brown & Sias, 2023` and `Gupta et al., 2018`)
- Compare journal name italics, volume bold/no-bold, page range formatting, DOI formatting character by character against APA 7th spec
- Check `bibliography(style: "apa")` specifically — this is the built-in style; verify it matches APA 7th (not APA 6th)
- If output deviates, consider a custom CSL file or post-process the bibliography output
- Test in-text citation formats: (Author, Year) for single author, (Author1 & Author2, Year) for two authors, (Author1 et al., Year) for 3+

**Warning signs:**
- Authors formatted as "Brown SA" instead of "Brown, S. A."
- Missing ampersand before last author in reference list
- "et al." threshold wrong (APA 7th: 3+ authors use et al. in citations; references list up to 20 authors)
- DOI formatted as plain text instead of `https://doi.org/...`

**Phase to address:** Citations and bibliography phase (treat as high-risk, allocate extra time)

---

### Pitfall 8: `set par(first-line-indent: ...)` Interaction with Headings

**What goes wrong:**
MISQ body text uses standard paragraph indentation (implied by academic convention, though not explicit in the template). When `set par(first-line-indent: 0.5in)` is set globally in Typst, it also applies the indent to paragraphs immediately following headings, which is typically not desired (and not how LaTeX works — LaTeX suppresses indent after headings by default via the `indentfirst` package behavior).

**Why it happens:**
In LaTeX, the `indentfirst` package is not loaded by default, so paragraphs after headings have no indent. In Typst, `first-line-indent` applies to ALL paragraphs including those after headings unless explicitly suppressed.

**How to avoid:**
- Use `show heading: it => { it; set par(first-line-indent: 0pt) }` — but this only affects the paragraph immediately following the heading
- Or set `first-line-indent: 0pt` for the template and use explicit indentation only where needed
- Review the MISQ template carefully: the LaTeX source does not show explicit `\parindent` settings, suggesting the default LaTeX behavior (indent most paragraphs, suppress after headings) is expected
- Test: place two paragraphs after a heading — the first should NOT be indented, the second SHOULD be indented

**Warning signs:**
- First paragraph after every heading has an unexpected indent
- All paragraphs lack indentation even when they should have it

**Phase to address:** Core typography setup phase

---

## Technical Debt Patterns

| Shortcut | Immediate Benefit | Long-term Cost | When Acceptable |
|----------|-------------------|----------------|-----------------|
| Hard-code spacing values (e.g., `leading: 13.2pt`) | Matches LaTeX output exactly | Breaks when font size changes; unreadable | Never — use em-relative values |
| Skip font fallback, use only "Times New Roman" | Less setup code | Template fails silently on Linux/cloud | Never for a distributed template |
| Use `\\` line breaks between references instead of separate paragraphs | Replicates LaTeX source structure | Hanging indent impossible to implement correctly | Never |
| Apply single `show heading` rule without level filter | Simpler code | Formatting bleeds across heading levels | Never |
| Use `pagebreak()` without `weak: true` | Explicit control | Creates blank pages at natural page boundaries | Only if blank pages are intentional |
| Hard-code "INTRODUCTION" as a special case for page break | Avoids state management | Breaks if section name changes | MVP only — replace with state counter |
| Use bibliography's default output without verifying APA 7th compliance | Fast initial setup | Silent non-compliance with journal requirements | Never for submission template |

---

## Integration Gotchas

| Integration | Common Mistake | Correct Approach |
|-------------|----------------|------------------|
| `.bib` to Typst bibliography | Import `.bib` directly without verifying hayagriva compatibility | Run `hayagriva convert` or test with `bibliography("refs.bib", style: "apa")` and inspect output |
| APA CSL style | Assume `style: "apa"` is APA 7th | Verify: Typst's built-in "apa" may be APA 6th or a version of CSL-APA; compare against official APA 7th examples |
| Typst Universe template packaging | Forget `typst.toml` manifest | Template won't install via `typst package install`; add manifest from the start |
| System fonts in CI | Assume local fonts available everywhere | Use `--font-path` or bundle fonts; test in clean Docker container |
| Multi-author in-text citations | Assume automatic "et al." | Verify threshold: APA 7th uses et al. for 3+ authors in citations |

---

## Performance Traps

For a document template, "performance" means compilation speed and output fidelity, not user-scale performance.

| Trap | Symptoms | Prevention | When It Breaks |
|------|----------|------------|----------------|
| Excessive use of `context` blocks for spacing | Slow compilation on long documents | Use `set` rules instead of context-dependent sizing | Documents >50 pages |
| Large embedded images without caching | Full recompile on every change | Use Typst's incremental compilation; avoid re-embedding same image | Any document with figures |
| Complex show rules that re-render every paragraph | Slow compile | Keep show rules simple; avoid layout-querying functions inside paragraph show rules | Long documents |

---

## "Looks Done But Isn't" Checklist

- [ ] **Line spacing:** Verify with ruler/measurement that abstract is 1.5x, body is 2x, references are 1x — visual inspection is insufficient
- [ ] **Font:** Check PDF metadata or use Typst's `--diagnostic` output to confirm Times New Roman (not a fallback font) is embedded in the output PDF
- [ ] **Hanging indent:** Test with a reference entry that wraps to 3 lines — all continuation lines should indent 0.5in from left margin
- [ ] **Page break:** Verify that title+abstract+keywords are on page 1 and Introduction starts at the top of page 2 with a full page break (not just large spacing)
- [ ] **Heading levels:** Test all three heading levels (section, subsection, subsubsection) — verify: level 1 is centered + uppercase + bold, level 2 is centered + bold (not uppercase), level 3 is left-aligned + bold (not centered, not uppercase)
- [ ] **Unnumbered headings:** Verify References and Appendix have no section numbers
- [ ] **APA citations:** Test in-text citation with 1, 2, and 3+ authors — verify et al. behavior and ampersand usage
- [ ] **APA bibliography:** Compare output reference list entry against the two sample entries in the LaTeX template character by character
- [ ] **Margins:** Verify 1-inch margins on all sides (LaTeX: `\textwidth{6.5in}` on `letterpaper` = 1in each side)
- [ ] **Keywords:** Verify "Keywords:" label is bold and single-spaced (matches LaTeX: `\baselinestretch{1.0}` after abstract)

---

## Recovery Strategies

| Pitfall | Recovery Cost | Recovery Steps |
|---------|---------------|----------------|
| Wrong line spacing throughout | MEDIUM | Refactor to named leading constants; rebuild spacing from scratch with test document |
| Hanging indent broken | LOW | Replace `\\`-separated block with individual paragraphs; apply `par(hanging-indent:)` per-paragraph |
| Font fallback discovered late | LOW | Add font fallback list and bundle TeX Gyre Termes; test on clean machine |
| APA citation style non-compliant | HIGH | May require custom CSL file; involves learning CSL XML format; allocate 1-2 days |
| Page break logic wrong | LOW | Replace spacing hack with `pagebreak(weak: true)` in correct location |
| All headings uppercase when only level 1 should be | LOW | Add `.where(level: 1)` filter to uppercase show rule |

---

## Pitfall-to-Phase Mapping

| Pitfall | Prevention Phase | Verification |
|---------|------------------|--------------|
| Mixed line spacing | Phase: Core typography (early) | Print line count per page; count lines in abstract vs body |
| Hanging indent references | Phase: References/bibliography | Test with 3-line reference entry |
| Font availability | Phase: Initial setup (day 1) | Build on clean Linux VM or GitHub Actions |
| Heading level formatting | Phase: Heading hierarchy | Screenshot all three heading levels side-by-side |
| Page break after title page | Phase: Page layout / title page | PDF page 1 ends after keywords, page 2 starts with Introduction heading |
| Unnumbered headings | Phase: Heading hierarchy | Search PDF text for "1." prefix on any heading |
| APA 7th citation fidelity | Phase: Citations/bibliography (high risk) | Manual diff against APA 7th Publication Manual examples |
| First-line indent after headings | Phase: Core typography | Test paragraph immediately after heading has no indent |

---

## Sources

- Direct analysis of `/Users/ryanschuetzler/code/typst-misq/MISQ_Submission_Template_LaTeX.tex` (HIGH confidence — primary source)
- Typst language specification knowledge: `par`, `heading`, `bibliography`, `pagebreak` function behaviors (MEDIUM confidence — training data, no live doc verification available)
- APA 7th edition citation rules: author formatting, et al. thresholds, DOI formatting (MEDIUM confidence — well-established spec)
- Typst font resolution behavior on Linux/CI environments (MEDIUM confidence — widely reported community issue, training data)
- Typst hayagriva/CSL bibliography system maturity (LOW confidence — ecosystem evolves rapidly; verify current APA CSL compliance against latest Typst release)

---
*Pitfalls research for: Typst academic journal template (MISQ LaTeX-to-Typst conversion)*
*Researched: 2026-03-12*
