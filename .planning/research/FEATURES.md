# Feature Research

**Domain:** Academic journal submission template (Typst)
**Researched:** 2026-03-12
**Confidence:** HIGH — derived from official MISQ LaTeX template and direct comparison with AMCIS IS conference template (same author ecosystem)

## Feature Landscape

### Table Stakes (Users Expect These)

Features that must exist or the template cannot produce a compliant MISQ submission.

| Feature | Why Expected | Complexity | Notes |
|---------|--------------|------------|-------|
| 12pt Times New Roman body font | MISQ LaTeX template specifies `\usepackage{times}` at 12pt | LOW | Typst built-in: `set text(font: "Times New Roman", size: 12pt)`. Font must be system-available. |
| US Letter page size | MISQ LaTeX template: `letterpaper` class option | LOW | Typst built-in: `set page(paper: "us-letter")` |
| 1" side margins, ~0.5" top, ~1" bottom | MISQ LaTeX: `\oddsidemargin=0in`, `\textwidth=6.5in`, `\textheight=9in` | LOW | Derive from LaTeX dimensions: left=1in, right=1in, top=0.5in+header, bottom calculated |
| Double-spaced body text | MISQ LaTeX: `\baselinestretch{2.0}` | LOW | Typst: `set par(leading: 2em)` or equivalent line spacing |
| 1.5-spaced abstract | MISQ LaTeX: `\baselinestretch{1.5}` in abstract env | MEDIUM | Different spacing than body requires scoped override for abstract block |
| Single-spaced references | MISQ LaTeX: `\baselinestretch{1.0}` in references section | MEDIUM | Scoped spacing override for references section |
| Hanging indent on references | MISQ LaTeX: `\hangindent=0.5in`, `\hangafter=1` | MEDIUM | Typst: each reference entry needs `par(hanging-indent: 0.5in)` |
| Centered uppercase Level-1 headings | MISQ LaTeX: `\section{\centering\MakeUppercase{...}}` | LOW | Typst show rule: `show heading.where(level: 1): it => align(center, upper(it.body))` |
| Centered title-case Level-2 headings (bold) | MISQ LaTeX: `\subsection{\centering{...}}` — bold normal size | LOW | Typst show rule: `show heading.where(level: 2): ...` |
| Left-aligned bold Level-3 headings | MISQ LaTeX: `\subsubsection{...}` — no centering, bold | LOW | Typst default heading style, customized to match size/weight |
| No heading numbering | MISQ submissions use unnumbered sections | LOW | Typst: `set heading(numbering: none)` |
| Title on page 1 (bold) | MISQ LaTeX: `\maketitle` with `\textbf{...}` title | LOW | Typst: `align(center, text(weight: "bold", ...)[#title])` |
| Abstract on page 1 with "Abstract" label | MISQ LaTeX template includes abstract on page 1 | LOW | Typst block with heading or styled label |
| Keywords section after abstract | MISQ template: `\textbf{Keywords:}` block after abstract | LOW | Simple bold label + content block |
| Introduction starts on page 2 | MISQ template: `\newpage` before Introduction section | LOW | Typst: `pagebreak()` before first heading |
| APA 7th edition in-text citations | MISQ uses APA author-date format (from template examples) | MEDIUM | Typst native `bibliography()` with `style: "apa"` OR custom CSL file |
| References section: no section number, centered uppercase | MISQ: `\section*{\centering{REFERENCES}}` | LOW | Use unnumbered heading override, uppercase |
| Bibliography from .bib file | Standard academic workflow | LOW | Typst native: `bibliography("references.bib")` |
| No author information (blind review) | MISQ blind review requirement — submission only | LOW | Template simply omits author fields; no toggle needed since always blind |
| No date on title page | MISQ LaTeX: `\date{}` empty | LOW | Typst: simply omit date from title area |
| Page numbers | MISQ LaTeX: `\pagestyle{plain}` (page numbers in footer) | LOW | Typst: `set page(numbering: "1")` |
| Example/sample document | Project requirement: working .typ file with sample citations | MEDIUM | Requires template file + populated main.typ using references.bib |

### Differentiators (Competitive Advantage)

Features not strictly required by MISQ spec but that make the template more useful.

| Feature | Value Proposition | Complexity | Notes |
|---------|-------------------|------------|-------|
| Appendix section support | MISQ template includes appendix — easy to add | LOW | Unnumbered `APPENDIX` heading with `pagebreak()` before it |
| Separate CSL file for APA 7th | More accurate APA formatting than Typst's built-in "apa" style | MEDIUM | The AMCIS template bundles `new-apa.csl` (updated 2024-07-09) alongside the template for precise compliance |
| Inline citation syntax examples in sample doc | Users unfamiliar with Typst citation syntax need examples | LOW | Document the `@key`, `#cite(<key>, form: "prose")`, and `#cite(<key>, form: "year")` patterns |
| Comment-rich template file | Reduces learning curve for first-time Typst users switching from Word/LaTeX | LOW | Inline comments explaining each formatting decision |
| Typst `typst.toml` manifest for package registry | Enables `typst init @preview/misq-template` if published | MEDIUM | Required fields: name, version, entrypoint, authors, categories |
| Figure and table support with captions | Academic papers routinely include figures/tables | LOW | Typst native `#figure()` works; document the pattern in example |
| Cross-reference support | `@label` syntax for referencing figures/tables/sections | LOW | Typst native; demonstrate in example document |

### Anti-Features (Commonly Requested, Often Problematic)

| Feature | Why Requested | Why Problematic | Alternative |
|---------|---------------|-----------------|-------------|
| Author information fields (name, affiliation, email) | Authors eventually need camera-ready version | MISQ is submission-only (blind review); adding author fields creates risk of accidentally including them; camera-ready has different formatting outside template scope | Document clearly: "this template is for blind submission only; remove author info from your .bib file too" |
| Camera-ready / blind toggle (like AMCIS) | AMCIS template has this pattern | MISQ does not publish a camera-ready template — published papers use journal typesetting; adding a toggle adds complexity for zero benefit | Keep template submission-only |
| Automated word count | Authors want to track length | Typst has no built-in word count; external tools (tinymist word count, `typst query`) are more appropriate | Document that `typst query` or editor word count should be used |
| Multi-column layout | Some journals use two-column | MISQ uses single-column throughout | Keep single-column; explicitly do not add column config |
| Custom header/footer with running title | Some academic templates include these | MISQ template only shows plain page numbers; headers add complexity without compliance requirement | Page numbers only in footer/page area |
| Hyperlinked DOIs in references | Nice for digital reading | APA 7th style via CSL handles this automatically; manual hyperlinking adds maintenance burden | Let the CSL style handle link formatting |
| Abstract word count enforcement | Common in conference templates | Word count enforcement in Typst is unreliable and creates confusing compile errors | Note in comments that MISQ requires 150-250 word abstract; user verifies manually |

## Feature Dependencies

```
Page layout (margins, paper size)
    └──required by──> All content layout features

Font configuration (Times New Roman, 12pt)
    └──required by──> Body text, headings, abstract, references

Double-spacing configuration
    └──required by──> Body text
    └──overridden by──> Abstract (1.5x), References (1.0x)

Bibliography (.bib file)
    └──required by──> In-text citations
    └──required by──> References section
    └──required by──> Sample document

APA CSL style file
    └──required by──> Bibliography formatting
    └──required by──> In-text citation format

Heading show rules
    └──required by──> Level-1 (UPPERCASE centered)
    └──required by──> Level-2 (centered bold)
    └──required by──> Level-3 (left bold)

Page 1 structure (title + abstract + keywords)
    └──required by──> Page break before Introduction
```

### Dependency Notes

- **Abstract spacing requires body spacing**: The 1.5x abstract override only makes sense after establishing the 2.0x body baseline. Both must be implemented together, likely via a named function wrapping the abstract content.
- **References section requires bibliography**: The references section layout (single-spaced, hanging indent) is tied to how `bibliography()` renders entries. Need to verify whether Typst's `bibliography()` function respects `par(hanging-indent:...)` or requires post-processing.
- **CSL file requires bundling**: If distributing as a Typst package, the APA CSL file must be included in the package directory. The AMCIS template bundles `new-apa.csl` — same approach should be used here.
- **Sample document requires all other features**: The example .typ file depends on every formatting feature being correctly implemented first.

## MVP Definition

### Launch With (v1)

Minimum viable product — what's needed to produce a MISQ-compliant PDF.

- [ ] US Letter page, 1" side margins, ~0.5" top margin — geometry foundation
- [ ] 12pt Times New Roman throughout — font foundation
- [ ] Double-spaced body text — body spacing
- [ ] Level-1 headings: centered, uppercase, bold, unnumbered — primary heading style
- [ ] Level-2 headings: centered, bold, title case, unnumbered — subsection style
- [ ] Level-3 headings: left-aligned, bold, unnumbered — sub-subsection style
- [ ] Page 1 structure: title (bold), abstract (1.5x spacing), keywords — front matter
- [ ] Page break before Introduction (Introduction starts page 2) — page flow
- [ ] Single-spaced references section with 0.5" hanging indent — references layout
- [ ] APA 7th edition bibliography from references.bib — citation system
- [ ] Page numbering (plain, bottom) — navigation
- [ ] Sample main.typ demonstrating all heading levels, citations, and references — usability

### Add After Validation (v1.x)

Features to add once core formatting is working and verified.

- [ ] Appendix section support — simple pagebreak + unnumbered APPENDIX heading
- [ ] Bundled APA CSL file for more precise citation formatting — replace built-in "apa" style
- [ ] Figure and table examples in sample document — demonstrate native Typst figure syntax
- [ ] Cross-reference examples in sample document — demonstrate @label syntax
- [ ] typst.toml manifest — enables package registry publication

### Future Consideration (v2+)

Features to defer; not needed for a working submission template.

- [ ] Package registry publication — requires typst.toml, thumbnail, and Typst maintainer approval process
- [ ] Tinymist/IDE integration hints — documentation improvement, not template code

## Feature Prioritization Matrix

| Feature | User Value | Implementation Cost | Priority |
|---------|------------|---------------------|----------|
| Page geometry (margins, paper size) | HIGH | LOW | P1 |
| Times New Roman 12pt font | HIGH | LOW | P1 |
| Double-spaced body text | HIGH | LOW | P1 |
| Level-1 heading: centered uppercase | HIGH | LOW | P1 |
| Level-2 heading: centered bold | HIGH | LOW | P1 |
| Level-3 heading: left bold | HIGH | LOW | P1 |
| 1.5x abstract spacing | HIGH | MEDIUM | P1 |
| 1.0x references + hanging indent | HIGH | MEDIUM | P1 |
| APA 7th citation + bibliography | HIGH | MEDIUM | P1 |
| Page 1 structure (title/abstract/keywords) | HIGH | LOW | P1 |
| Page break before Introduction | HIGH | LOW | P1 |
| Page numbering | HIGH | LOW | P1 |
| Sample .typ document | HIGH | MEDIUM | P1 |
| Appendix section | MEDIUM | LOW | P2 |
| Bundled CSL file | MEDIUM | LOW | P2 |
| Figure/table examples in sample | MEDIUM | LOW | P2 |
| typst.toml manifest | LOW | LOW | P2 |
| Package registry publication | LOW | MEDIUM | P3 |

**Priority key:**
- P1: Must have for launch — required for any compliant MISQ submission
- P2: Should have, add when possible — improves usability and completeness
- P3: Nice to have, future consideration

## Competitor Feature Analysis

| Feature | MISQ LaTeX Template (official) | AMCIS Typst Template (same author, IS conference) | MISQ Typst (this project) |
|---------|--------------------------------|---------------------------------------------------|---------------------------|
| Font | Times New Roman 12pt | Georgia 10pt | Times New Roman 12pt |
| Body spacing | Double (2.0x) | Single with 6pt paragraph gap | Double (2.0x) |
| Abstract spacing | 1.5x | Implicit single | 1.5x |
| Citations | Manual APA in source | CSL-based APA via .bib | CSL-based APA via .bib |
| Heading L1 | Centered uppercase bold | Left-aligned bold 13pt | Centered uppercase bold |
| Blind review | Manual (no author fields in template) | camera-ready toggle | Submission-only (no toggle needed) |
| Reference layout | Hanging indent, single-spaced | Via CSL/APA bibliography | Hanging indent, single-spaced |
| Page numbers | Footer, plain | Footer right, with conference info | Footer, plain |
| Appendix | Yes | No | Yes |
| Keywords | Yes (after abstract) | Yes (camera-ready only) | Yes (always shown) |
| Package format | .tex file (no package) | Typst package (@preview) | Typst package or standalone .typ |

## Sources

- `/Users/ryanschuetzler/code/typst-misq/MISQ_Submission_Template_LaTeX.tex` — Official MISQ LaTeX template (HIGH confidence, authoritative MISQ formatting spec)
- `/Users/ryanschuetzler/Library/Caches/typst/packages/preview/ambivalent-amcis/0.1.0/amcis.typ` — AMCIS Typst template implementation (HIGH confidence, same domain, same author)
- `/Users/ryanschuetzler/Library/Caches/typst/packages/preview/ambivalent-amcis/0.1.0/template/main.typ` — AMCIS sample document (HIGH confidence, reference implementation patterns)
- Typst built-in bibliography styles including "apa" — MEDIUM confidence (built-in "apa" style exists; exact APA 7th compliance vs custom CSL needs validation)

---
*Feature research for: Typst MISQ journal submission template*
*Researched: 2026-03-12*
