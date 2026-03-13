# Phase 3: Citations - Research

**Researched:** 2026-03-13
**Domain:** Typst bibliography, CSL citation styles, hanging indent
**Confidence:** HIGH

## Summary

Phase 3 implements APA 7th edition citations in the MISQ template using a bundled CSL file copied from the sibling `ambivalent-amcis` project. The CSL (`new-apa.csl`) is already available at `/Users/ryanschuetzler/code/ambivalent-amcis/template/new-apa.csl` and has been proven to work with Typst. Three technical mechanisms are needed: (1) auto-applying the CSL via `set bibliography(style:)` inside `misq()`, (2) applying a hanging indent to bibliography entries, and (3) formatting the REFERENCES heading via show rule.

The hanging indent is the most technically complex piece. The `new-apa.csl` file contains `hanging-indent="true"` in its `<bibliography>` tag (line 2107), which conflicts with Typst's `par` hanging-indent setting. The confirmed solution (verified against Typst 0.13.0+ and current 0.14.2) is: copy `new-apa.csl` as a modified copy with `hanging-indent="false"`, then apply a show rule using `par(hanging-indent: 0.5in, ...)` inside a `show block` rule targeting bibliography entries. The simpler `show bibliography: set par(hanging-indent:)` approach does NOT work for APA (author-date) style.

**Primary recommendation:** Copy `new-apa.csl` → project root, change its `hanging-indent="true"` to `hanging-indent="false"`, add `set bibliography(style: "new-apa.csl")` inside `misq()`, and use the confirmed block-level show rule to apply the 0.5-inch hanging indent.

---

<user_constraints>
## User Constraints (from CONTEXT.md)

### Locked Decisions
- Bundle `new-apa.csl` from the ambivalent-amcis project (proven to work with Typst)
- Place CSL file at project root alongside `misq.typ` — part of the package, not a template resource
- Copy the file from ambivalent-amcis; do not modify it
- Auto-apply the bundled CSL via a show rule in `misq.typ` so authors don't need to specify `style:`
- Allow author overrides — if an author explicitly passes `style:` to `#bibliography()`, their choice should win
- Authors still call `#bibliography("references.bib")` explicitly (Phase 2 decision: no `bib` parameter)
- Auto-apply 0.5-inch left hanging indent on bibliography entries via a show rule in `misq.typ`
- Auto-format the bibliography title: centered, bold, uppercase — via show rule in `misq.typ`
- Auto-uppercase whatever title text the author passes (e.g., `title: "References"` renders as "REFERENCES")
- No automatic page break before bibliography — authors handle `#pagebreak()` manually
- Simplify template/main.typ: remove the manual `#align(center, text(...)[REFERENCES])` line

### Claude's Discretion
- Exact show rule implementation for CSL auto-application with override support
- How to implement hanging indent in Typst (par indent vs. block-level approach)
- Verification approach for comparing output against LaTeX template's sample references
- Whether to expand references.bib with more entry types (book, conference, etc.) for testing

### Deferred Ideas (OUT OF SCOPE)
None — discussion stayed within phase scope
</user_constraints>

---

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|-----------------|
| CITE-01 | APA 7th edition in-text citations work via `@key` syntax | `@key` syntax is native Typst; CSL `et-al-min="3"` in new-apa.csl gives (Author, year) for 1–2 authors and (Author et al., year) for 3+ |
| CITE-02 | Bibliography renders from .bib file with APA 7th formatting | new-apa.csl is the APA 7th CSL; needs `hanging-indent="false"` modification + show rule for indent |
| CITE-03 | Bundled APA 7th CSL file for precise citation formatting | new-apa.csl at project root; auto-applied via `set bibliography(style: "new-apa.csl")` inside misq() |
| TYPO-06 | References have 0.5-inch left hanging indent | Block-level show rule required; simple `set par(hanging-indent:)` does NOT work for APA author-date style |
</phase_requirements>

---

## Standard Stack

### Core
| Library | Version | Purpose | Why Standard |
|---------|---------|---------|--------------|
| Typst native `bibliography()` | 0.14.2 (current) | Renders .bib files with CSL styling | Built into Typst; no extra package needed |
| new-apa.csl | Updated 2024-07-09 | APA 7th citation/bibliography formatting | Proven working in sibling ambivalent-amcis project; already in repo |

### Supporting
| Library | Version | Purpose | When to Use |
|---------|---------|---------|-------------|
| `@key` citation syntax | native | In-text author-date citations | Standard Typst cite syntax |
| `#cite(<key>, form: "prose")` | native | Prose-form citations ("Author (year)...") | When mentioning author in text |

### Alternatives Considered
| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| new-apa.csl (bundled) | Built-in `"apa"` style | Built-in style may not be APA 7th; new-apa.csl is verified APA 7th and already proven in project |
| Modified new-apa.csl (hanging-indent="false") | Unmodified new-apa.csl | Unmodified has hanging-indent="true" which conflicts with Typst par rules; must disable in CSL |

**Installation:** No package installation required — CSL file copy only.

---

## Architecture Patterns

### Recommended Project Structure
```
typst-misq/
├── misq.typ          # Template function — add set bibliography() + show rules here
├── new-apa.csl       # Copied from ambivalent-amcis, hanging-indent="false" modification
└── template/
    ├── main.typ      # Simplify: remove manual REFERENCES heading, remove style: "apa"
    └── references.bib  # Existing 2-entry bib file (optionally expand for testing)
```

### Pattern 1: Auto-Apply CSL Default with Author Override Support

**What:** Use `set bibliography(style: "new-apa.csl")` inside the `misq()` function body. Because `style` is a settable parameter, this establishes a default. Any later `#bibliography("file.bib", style: "other.csl")` call by the author overrides it.

**When to use:** Whenever the template should provide a sensible default that authors can still override.

**Example:**
```typst
// In misq.typ, inside the misq() function body, after other set rules:
// --- Citation style (CITE-03) ---
// Auto-apply bundled APA 7th CSL so authors call #bibliography() with no style: needed.
// Authors may override: #bibliography("refs.bib", style: "chicago-author-date")
set bibliography(style: "new-apa.csl")
```

**Source:** Typst docs confirm `style` parameter is "Settable" — https://typst.app/docs/reference/model/bibliography/

### Pattern 2: Hanging Indent via Block-Level Show Rule

**What:** APA is an author-date (non-grid) bibliography style. Simple `show bibliography: set par(hanging-indent:)` does NOT work because Typst's APA/author-date bibliography entries are rendered as blocks, not as flat paragraphs, when `hanging-indent="true"` is in the CSL. The fix requires: (1) set `hanging-indent="false"` in the CSL, and (2) reconstruct each entry paragraph manually in a show rule.

**When to use:** Any Typst APA (author-date) bibliography with hanging indent requirement.

**Example:**
```typst
// In misq.typ — TYPO-06: 0.5-inch hanging indent on bibliography entries
// NOTE: show bibliography: set par(hanging-indent:) does NOT work for APA (author-date style).
// CSL must have hanging-indent="false"; then reconstruct par-level indent here.
show bibliography: it_bib => {
  set block(inset: 0pt)
  show block: it_block => {
    if it_block.body.func() != [].func() {
      it_block.body
    } else {
      par(first-line-indent: 0in, hanging-indent: 0.5in, it_block.body)
    }
  }
  it_bib
}
```

**Source:** GitHub issue #2639 confirmed working solution (tested Typst 0.13.0+, confirmed on 0.14.2): https://github.com/typst/typst/issues/2639

### Pattern 3: REFERENCES Heading Auto-Formatting via Show Rule

**What:** Use `show bibliography: it => { ... }` (or extend Pattern 2) to intercept the bibliography heading and apply centered + bold + uppercase formatting. The heading content is whatever `title:` value the author passes to `#bibliography()`.

**When to use:** When the template must enforce a specific heading style regardless of what title text the author provides.

**Example:**
```typst
// In misq.typ — STRC-03: centered, bold, uppercase REFERENCES heading
// Extend the bibliography show rule to also format the heading:
show bibliography: it => {
  // The heading within bibliography is rendered as a heading element.
  // We intercept it to force centered, bold, uppercase styling.
  show heading: it_h => align(center, block(
    above: 1.85em,
    below: 1.85em,
    {
      set text(weight: "bold", size: 12pt)
      upper(it_h.body)
    }
  ))
  it
}
```

**Note:** The hanging-indent show rule (Pattern 2) and the heading show rule (Pattern 3) must be combined into one `show bibliography:` rule, or written as separate chained rules — Typst only applies the last `show bibliography:` rule if they are separate.

**Alternative:** Use two separate chained show rules — the first targeting `show bibliography: set heading(...)` (set rule, not show rule) and the second doing the full block manipulation. Set rules chain; show rules for the same element overwrite.

### Pattern 4: CSL Modification

**What:** The `new-apa.csl` file must be copied from `ambivalent-amcis/template/new-apa.csl` to the project root and one attribute changed: `hanging-indent="true"` → `hanging-indent="false"` on line 2107.

**Why:** The CSL's own hanging-indent signal prevents Typst from applying `par(hanging-indent:)` overrides. Disabling it in the CSL lets Typst's show rule control the indent measurement (0.5in).

**Location in CSL:**
```xml
<!-- Line 2107 in new-apa.csl — change this: -->
<bibliography hanging-indent="true" et-al-min="21" et-al-use-first="19" ...>
<!-- to this: -->
<bibliography hanging-indent="false" et-al-min="21" et-al-use-first="19" ...>
```

### Anti-Patterns to Avoid

- **`show bibliography: set par(hanging-indent: 0.5in)`:** Does NOT work for APA/MLA author-date styles. The CSL-driven hanging-indent="true" blocks this. Confirmed broken in Typst 0.13.0+ (GitHub issue #2639).
- **Multiple separate `show bibliography:` rules:** The last one wins; earlier ones are silently ignored. Combine heading formatting + hanging indent into one `show bibliography:` rule.
- **Unmodified new-apa.csl:** Using the file as-is with `hanging-indent="true"` will produce CSL-controlled indentation that cannot be customized via Typst show rules.
- **Leaving `style: "apa"` in template/main.typ:** The built-in `"apa"` style may not be APA 7th. After switching to `set bibliography(style: "new-apa.csl")` in misq.typ, the explicit `style:` argument in main.typ must be removed.

---

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| APA 7th citation formatting | Custom citation macros | new-apa.csl | 2138-line CSL handles all edge cases: et al., disambiguation, multiple authors, dates, URLs, DOIs |
| Et al. logic | Manual author-count conditionals | CSL `et-al-min="3"` attribute | CSL handles 1-author, 2-author, 3+-author cases automatically |
| BibTeX parsing | Custom .bib parser | Native `bibliography()` | Typst natively supports BibLaTeX .bib files |
| Bibliography sorting | Manual sort | CSL `<sort>` block | new-apa.csl sorts by author then date automatically |

**Key insight:** CSL is a mature, battle-tested standard. The new-apa.csl handles hundreds of edge cases in 2138 lines. The only custom code needed is Typst show rules for visual formatting (indent, spacing, heading).

---

## Common Pitfalls

### Pitfall 1: APA Hanging Indent Doesn't Work with Simple Show Rule
**What goes wrong:** Developer adds `show bibliography: set par(hanging-indent: 0.5in)` and sees no effect, or sees entries double-indented / misaligned.
**Why it happens:** When CSL has `hanging-indent="true"`, Typst handles indentation at the block level using CSL's own mechanism, bypassing `par` settings. This is a known Typst limitation (GitHub issue #2639, open since 2023).
**How to avoid:** Disable `hanging-indent` in the CSL (`hanging-indent="false"`), then use the block-level show rule pattern (Pattern 2 above).
**Warning signs:** `set par(hanging-indent:)` has no visible effect on bibliography output.

### Pitfall 2: Multiple show bibliography Rules (Last Wins)
**What goes wrong:** Developer writes separate show rules for heading formatting and hanging indent; only the last one applies.
**Why it happens:** In Typst, multiple show rules targeting the same element — when both are full transformational show rules (not set rules) — the last one in document order wins.
**How to avoid:** Combine all bibliography show rule logic (heading formatting + hanging indent) into a single `show bibliography:` rule, or use `set` rules for simpler properties and a single `show` rule for complex transformations.
**Warning signs:** Heading formatting disappears after adding hanging-indent show rule, or vice versa.

### Pitfall 3: CSL File Path Relative to Typst Source
**What goes wrong:** `set bibliography(style: "new-apa.csl")` fails with "file not found."
**Why it happens:** The path must be relative to the `.typ` file that contains the rule — i.e., `misq.typ` at project root. If `main.typ` is compiled from `template/`, the path resolution follows the compilation entry point, not the template file location.
**How to avoid:** When compiling `template/main.typ` which imports `../misq.typ`, the CSL path `"new-apa.csl"` in `misq.typ` resolves relative to `misq.typ`'s directory (project root). Verify by compiling `typst compile template/main.typ` and confirming no path error.
**Warning signs:** Compile error: "failed to load CSL file" or similar.

### Pitfall 4: et-al Behavior Mismatch
**What goes wrong:** Citations show wrong author format — 3-author entries not collapsing to "et al."
**Why it happens:** The new-apa.csl has `et-al-min="3"` in the `<citation>` block (line 2092), meaning 3+ authors → "First Author et al." The existing references.bib has Brown (2-author) and Gupta (3-author) — these test 1/2/3+ author cases. But if references.bib only has 2 entries, some cases won't be verified.
**How to avoid:** Add at least one 3+-author entry to references.bib and verify it renders as "et al." in the PDF.
**Warning signs:** All in-text citations show all author names regardless of count.

### Pitfall 5: title: none vs title: "References" Behavior
**What goes wrong:** Heading show rule doesn't fire because `title: none` suppresses the heading element entirely.
**Why it happens:** When authors pass `title: none` to `#bibliography()`, no heading is emitted at all — the show rule targeting headings inside bibliography never runs.
**How to avoid:** The CONTEXT.md decision says to auto-uppercase whatever title the author passes. Template/main.typ should call `#bibliography("references.bib", title: "References")` (not `title: none`) and let the show rule uppercase it. The existing manual `#align(center, text(...)[REFERENCES])` in main.typ gets removed; the heading emerges from the bibliography call itself.
**Warning signs:** No "REFERENCES" heading appears even though bibliography content renders.

---

## Code Examples

Verified patterns from official sources and confirmed working code:

### Setting Default CSL Style (Settable Parameter Pattern)
```typst
// Source: https://typst.app/docs/reference/model/bibliography/ (style is "Settable")
// Inside misq() function body:
set bibliography(style: "new-apa.csl")
```

### In-Text Citation Syntax
```typst
// Source: https://typst.app/docs/reference/model/cite/
// Basic author-date citation:
@brown2023fault          // renders: (Brown & Sias, 2023)
@gupta2018economic       // renders: (Gupta et al., 2018)  [3 authors → et al.]

// Prose form:
#cite(<brown2023fault>, form: "prose")  // renders: Brown and Sias (2023)

// Year-only:
#cite(<brown2023fault>, form: "year")   // renders: 2023
```

### Bibliography Call in main.typ (Simplified)
```typst
// Before (current main.typ lines 102-104):
#align(center, text(weight: "bold")[REFERENCES])
#bibliography("references.bib", style: "apa", title: none)

// After (Phase 3 result):
#bibliography("references.bib", title: "References")
// style: omitted → inherits set bibliography(style: "new-apa.csl") from misq.typ
// title: "References" → show rule uppercases to "REFERENCES", centers, bolds
```

### Hanging Indent Show Rule (Confirmed Working, Typst 0.13.0+)
```typst
// Source: GitHub issue #2639 confirmed solution (June 2025)
// Requires: new-apa.csl has hanging-indent="false"
show bibliography: it_bib => {
  set block(inset: 0pt)
  show block: it_block => {
    if it_block.body.func() != [].func() {
      it_block.body
    } else {
      par(first-line-indent: 0in, hanging-indent: 0.5in, it_block.body)
    }
  }
  it_bib
}
```

### CSL Modification (new-apa.csl line 2107)
```xml
<!-- Before (original new-apa.csl): -->
<bibliography hanging-indent="true" et-al-min="21" et-al-use-first="19" et-al-use-last="true" entry-spacing="0" line-spacing="2">

<!-- After (modified for misq project): -->
<bibliography hanging-indent="false" et-al-min="21" et-al-use-first="19" et-al-use-last="true" entry-spacing="0" line-spacing="2">
```

### REFERENCES Heading Show Rule
```typst
// Target heading elements inside bibliography for centered + bold + uppercase formatting
// Must be combined with (or chained before) the hanging-indent show rule
show bibliography: set heading(numbering: none)  // ensure no stray numbers
show bibliography: it => {
  show heading: it_h => align(center, block(
    above: 1.85em,
    below: 1.85em,
    {
      set text(weight: "bold", size: 12pt)
      upper(it_h.body)
    }
  ))
  it
}
```

**NOTE:** If `show bibliography: it_bib => { ... }` (the hanging-indent rule) comes after the heading rule, it will override the heading rule. Two options: (a) combine both into one `show bibliography:` rule, or (b) put the heading show rule using `set` inside the hanging-indent show rule body.

---

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| Built-in `"apa"` style | Custom `new-apa.csl` (CSL file) | Typst 0.9+ added CSL support | APA 7th compliance; built-in "apa" is not guaranteed to be 7th edition |
| `show bibliography: set par(hanging-indent:)` | Modified CSL + block show rule | Typst 0.13.0 (broke earlier workarounds) | Simple par approach no longer reliable; block-level reconstruction required |
| Manual REFERENCES heading before bibliography | Show rule auto-uppercases title | Phase 3 decision | Cleaner author API; single `#bibliography()` call handles everything |

**Deprecated/outdated:**
- `show bibliography: set par(hanging-indent: 0.5in)`: Broken for APA style since Typst 0.13.0. Use block-level show rule (Pattern 2) instead.
- `style: "apa"` in bibliography call: Not verified as APA 7th; replace with `new-apa.csl`.

---

## Open Questions

1. **Combined show bibliography rule ordering**
   - What we know: Heading show rule and hanging-indent show rule both target `bibliography`; last wins for full show rules
   - What's unclear: Whether a `set heading(...)` inside the hanging-indent show rule body is the cleanest combination
   - Recommendation: During implementation, verify both heading formatting and hanging indent render correctly in a single pass; combine into one rule if needed

2. **CSL file path resolution with template/ compilation**
   - What we know: `set bibliography(style: "new-apa.csl")` in misq.typ uses path relative to misq.typ's directory
   - What's unclear: Whether Typst resolves set-rule style paths from the template's own directory or the compilation entry point
   - Recommendation: Test `typst compile template/main.typ` first; if path fails, may need `"../new-apa.csl"` or move CSL to template/

3. **Expanding references.bib for testing**
   - What we know: Current bib has 2 entries: Brown (2-author) and Gupta (3-author) — covers 2 of 3 citation cases
   - What's unclear: Whether a 1-author entry is needed for complete APA author-format verification
   - Recommendation: Add one 1-author entry to verify "(Lastname, year)" vs "(Lastname & Other, year)" vs "(Lastname et al., year)"

---

## Validation Architecture

### Test Framework
| Property | Value |
|----------|-------|
| Framework | Visual PDF inspection (no automated test suite detected) |
| Config file | none — manual compilation and visual verification |
| Quick run command | `typst compile template/main.typ` |
| Full suite command | `typst compile template/main.typ && open template/main.pdf` |

### Phase Requirements → Test Map
| Req ID | Behavior | Test Type | Automated Command | File Exists? |
|--------|----------|-----------|-------------------|-------------|
| CITE-01 | `@brown2023fault` renders "(Brown & Sias, 2023)"; `@gupta2018economic` renders "(Gupta et al., 2018)" | visual | `typst compile template/main.typ` | ✅ template/main.typ (has citations at line 94) |
| CITE-02 | Bibliography renders 2 MISQ entries in APA 7th format matching LaTeX sample | visual | `typst compile template/main.typ` | ✅ template/references.bib |
| CITE-03 | No `style:` argument needed in bibliography call; bundled CSL auto-applies | visual/smoke | `typst compile template/main.typ` | ✅ after removing style: from main.typ |
| TYPO-06 | Each bibliography entry has 0.5-inch hanging indent (subsequent lines indent, first line flush) | visual | `typst compile template/main.typ` | ✅ template/main.typ |

### Sampling Rate
- **Per task commit:** `typst compile template/main.typ`
- **Per wave merge:** `typst compile template/main.typ && open template/main.pdf` (visual check against LaTeX reference)
- **Phase gate:** All 4 requirements verified visually before `/gsd:verify-work`

### Wave 0 Gaps
None — existing test infrastructure (template/main.typ + references.bib) covers all phase requirements. No new test files needed; verification is visual PDF comparison against `MISQ_Submission_Template_LaTeX.tex` reference output.

---

## Sources

### Primary (HIGH confidence)
- https://typst.app/docs/reference/model/bibliography/ — Confirmed `style` is a settable parameter; full function signature verified
- https://typst.app/docs/reference/model/cite/ — `@key` syntax, `form:` parameter variants
- `/Users/ryanschuetzler/code/ambivalent-amcis/template/new-apa.csl` — Local file; line 2107 contains `hanging-indent="true"` and CSL citation attributes
- `/Users/ryanschuetzler/code/typst-misq/MISQ_Submission_Template_LaTeX.tex` — Lines 77-82 provide exact reference formatting to match: `\hangindent=0.5in`, sample Brown/Gupta entries

### Secondary (MEDIUM confidence)
- https://github.com/typst/typst/issues/2639 — Confirmed working hanging-indent solution for APA in Typst 0.13.0+ (FlorwsNelson, June 2025); block-level show rule verified
- https://typst.app/docs/changelog/0.14.0/ — Confirms CSL `strong`/`emph`/`smallcaps` rendering changes; no regressions to bibliography show rules
- https://forum.typst.app/t/the-last-resort-for-correcting-the-format-of-bibliography-for-60-styles/5303 — Confirms APA (author-date) does NOT use grid layout; grid-based solutions won't work

### Tertiary (LOW confidence)
- WebSearch results about Typst bibliography patterns — general background, superseded by primary sources above

---

## Metadata

**Confidence breakdown:**
- Standard stack: HIGH — CSL file exists locally, Typst bibliography API verified from official docs
- Architecture: HIGH — `set bibliography(style:)` confirmed settable; hanging-indent solution confirmed from GitHub issue with Typst 0.13.0+ testing
- Pitfalls: HIGH — Issues 2639 directly documents hanging-indent failure modes; Typst 0.13.0 changelog confirms par/block scope behavior change

**Research date:** 2026-03-13
**Valid until:** 2026-06-13 (Typst releases frequently; verify show rule behavior on any major version bump)
