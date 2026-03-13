# Phase 2: Structure - Research

**Researched:** 2026-03-13
**Domain:** Typst heading show rules, page layout, paragraph indentation, document structure
**Confidence:** HIGH

## Summary

Phase 2 builds on the Phase 1 foundation (`misq.typ`) to add complete document structure: a title page with bold centered title, centered "Abstract" label, and keywords; three heading levels with numbered styling (1, 1.1, 1.1.1); an explicit page break placing the Introduction on page 2; and centered footer page numbers.

All required capabilities are well-supported in Typst's stable API. The primary implementation tools are `show heading.where(level: N)` rules for per-level styling, `set heading(numbering: "1.1.")` for hierarchical numbering, `upper()` for level-1 uppercase transformation, `set block(above:, below:)` within show rules for heading spacing, and `set page(numbering: "1")` for centered footer page numbers (already partially in place from Phase 1). The `bib` parameter removal and new `paragraph-style` parameter are straightforward function signature changes.

**Primary recommendation:** Implement all heading styles, title page updates, page break, and paragraph-style toggle as modifications to `misq.typ` using show rules and the existing `misq()` function pattern established in Phase 1.

<user_constraints>
## User Constraints (from CONTEXT.md)

### Locked Decisions

#### Title page layout
- Title bold, centered, rendered in author's original casing (no auto-uppercase)
- Title vertical spacing should match the Word template (`MISQ-Manuscript-Template-Word.docx`)
- "Abstract" label centered and bold above the abstract text (update from current left-aligned)
- Keywords line stays as-is: bold "Keywords:" left-aligned with comma-separated terms

#### Page flow
- Page break after keywords — Introduction starts at top of page 2
- Page numbers centered in footer (already partially implemented with `numbering: "1"`)

#### Heading styles
- Level 1: centered, uppercase, bold, 12pt, numbered (1, 2, 3, ...)
- Level 2: centered, bold, 12pt, numbered (1.1, 1.2, ...)
- Level 3: left-aligned, bold, 12pt, numbered (1.1.1, 1.1.2, ...)
- All headings numbered — updating HEAD-04 requirement from "no numbering" to "numbered (1, 1.1, 1.1.1)"

#### Heading spacing
- Visual equivalence to LaTeX, not exact value matching (consistent with Phase 1 approach)
- Uniform spacing before/after all heading levels (no differentiation by level)

#### Paragraph style
- New `paragraph-style` parameter on misq(): `"indent"` (default) or `"block"`
- `"indent"`: first-line indent (~0.25-0.5in), no extra paragraph spacing — matches LaTeX template
- `"block"`: no indent, extra space between paragraphs — matches Word template
- Default to `"indent"` since it reads better with double-spacing

#### Bibliography parameter removal
- Remove the `bib` parameter from misq() function signature
- Authors write `#bibliography("references.bib", style: "apa")` explicitly in their document
- This allows appendices to appear after the bibliography
- Template show rules for bibliography styling (single-spacing) still apply automatically

#### Appendix handling
- No special appendix API or function
- Authors manage appendices manually with `#pagebreak()` and headings
- Authors handle their own lettering (Appendix A, Appendix B, etc.)

#### Special headings (REFERENCES, APPENDIX)
- No auto-styling via show rules — author handles formatting manually
- The example document (Phase 4) will demonstrate the correct markup

### Claude's Discretion
- Exact heading spacing values (visually calibrated)
- Page number footer implementation details
- How to implement the paragraph-style toggle internally

### Deferred Ideas (OUT OF SCOPE)
None — discussion stayed within phase scope
</user_constraints>

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|-----------------|
| HEAD-01 | Level 1 headings: centered, uppercase, bold, 12pt, numbered (1, 2, 3) | show heading.where(level:1) + set align(center) + upper(it.body) + set heading(numbering:) |
| HEAD-02 | Level 2 headings: centered, bold, 12pt, numbered (1.1, 1.2) | show heading.where(level:2) + set align(center) + same numbering scheme |
| HEAD-03 | Level 3 headings: left-aligned, bold, 12pt, numbered (1.1.1, 1.1.2) | show heading.where(level:3) + set align(left) |
| HEAD-04 | All headings use numbering (updated: 1, 1.1, 1.1.1 pattern) | set heading(numbering: "1.1.") — pattern covers all levels |
| STRC-01 | Page 1: bold centered title, abstract with label, keywords | align(center) on title, update abstract label alignment |
| STRC-02 | Introduction begins on page 2 (explicit page break after title page) | pagebreak() after keywords block in misq() |
| STRC-03 | References: centered uppercase "REFERENCES" heading | Author handles manually (decided in CONTEXT.md) — documented in Phase 4 example |
| STRC-04 | Appendix: page break + centered uppercase "APPENDIX" heading | Author handles manually (decided in CONTEXT.md) — documented in Phase 4 example |
| PAGE-03 | Page numbers appear in plain footer (centered, bottom) | set page(numbering: "1") already in place — verify number-align: center |
</phase_requirements>

## Standard Stack

### Core

| Library | Version | Purpose | Why Standard |
|---------|---------|---------|--------------|
| Typst built-in `heading` | stable | Section headings with numbering and styling | Native element, no deps |
| Typst `upper()` | stable | Uppercase text transformation for level-1 headings | Only built-in case transform |
| Typst `pagebreak()` | stable | Explicit page break after title page | Native layout control |
| Typst `counter(page)` | stable | Page number display in footer | Native page counter |

### Supporting

| Library | Version | Purpose | When to Use |
|---------|---------|---------|-------------|
| `set block(above:, below:)` within show rules | stable | Heading spacing | Controlling space before/after headings |
| `set par(first-line-indent:)` | stable | Paragraph indentation | `"indent"` paragraph-style mode |
| `align(center)[...]` | stable | Center content in title page | Title and abstract label centering |

### Alternatives Considered

| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| `set heading(numbering: "1.1.")` (global) | Per-level numbering functions | Global pattern is simpler; numbering functions needed only if different patterns per level are required |
| `upper(it.body)` in show rule | `set text(...)` with CSS-like text-transform | Typst has no text-transform parameter; `upper()` is the only option |
| `pagebreak()` in misq() template body | Requiring author to insert `#pagebreak()` | Template-inserted break is cleaner UX; author should not have to know about it |

**Installation:** No additional packages needed — all built-in to Typst.

## Architecture Patterns

### File to Modify

All changes go into a single file:

```
misq.typ         # Template definition — the only file modified in this phase
template/
└── main.typ     # Update to remove bib: parameter and test new features
```

### Pattern 1: Per-Level Heading Show Rules

**What:** Use `show heading.where(level: N): it => block(...)` to apply different styling per heading level. All three levels share a global `set heading(numbering: "1.1.")` but differ in alignment and uppercase transformation.

**When to use:** Whenever heading levels need distinct visual treatment.

**Example:**
```typst
// Source: https://typst.app/docs/reference/model/heading/
// Global numbering pattern covers all levels: 1, 1.1, 1.1.1
set heading(numbering: "1.1.")

// Level 1: centered, uppercase, bold
show heading.where(level: 1): it => block(
  above: 1.4em,
  below: 0.8em,
  {
    set align(center)
    set text(weight: "bold", size: 12pt)
    upper(it.body)
  }
)

// Level 2: centered, bold (no uppercase)
show heading.where(level: 2): it => block(
  above: 1.4em,
  below: 0.8em,
  {
    set align(center)
    set text(weight: "bold", size: 12pt)
    it.body
  }
)

// Level 3: left-aligned, bold
show heading.where(level: 3): it => block(
  above: 1.4em,
  below: 0.8em,
  {
    set align(left)
    set text(weight: "bold", size: 12pt)
    it.body
  }
)
```

**Critical note:** The `block()` wrapper in show rules prevents orphaned headings (heading at bottom of page, body on next page). Per Typst docs: "make sure to wrap the content in a block."

**Critical note 2:** When using a full transformational show rule (`it => block(...)`), the heading's built-in numbering from `set heading(numbering:)` is NOT automatically included in `it.body`. The number must be accessed via `it.counter.display(it.numbering)` or the heading must be re-rendered with `it` (the full element) rather than `it.body` alone. See "Common Pitfalls" section for the recommended pattern.

### Pattern 2: Title Page Layout

**What:** Centered bold title using `align(center)` and `text(weight: "bold")`, then abstract with centered bold "Abstract" label, then keywords, then explicit `pagebreak()`.

**When to use:** Template front-matter rendering in the `misq()` function body.

**Example:**
```typst
// Title: centered and bold (STRC-01)
align(center, text(weight: "bold", title))
v(1em)  // spacing calibrated to Word template visually

// Abstract label: centered bold (update from Phase 1's left-aligned)
if abstract != none {
  align(center, text(weight: "bold")[Abstract])
  linebreak()
  block({
    set par(leading: 0.8em, spacing: 0.8em)
    abstract
  })
  parbreak()
}

// Keywords: left-aligned bold "Keywords:" (unchanged from Phase 1)
if keywords.len() > 0 {
  text(weight: "bold")[Keywords: ]
  ...
  parbreak()
}

// Page break: Introduction on page 2 (STRC-02)
pagebreak()
```

### Pattern 3: Paragraph Style Toggle

**What:** `paragraph-style` parameter controls whether body text uses first-line indentation (LaTeX style) or block spacing (Word style).

**When to use:** Provides author choice between two common academic conventions.

**Example:**
```typst
// Source: https://typst.app/docs/reference/model/par/
#let misq(
  title: [Untitled],
  abstract: none,
  keywords: (),
  paragraph-style: "indent",  // new parameter; "indent" or "block"
  body
) = {
  // ... page/font/spacing setup ...

  // Apply paragraph style
  if paragraph-style == "indent" {
    // LaTeX-style: indent + no extra spacing
    set par(first-line-indent: (amount: 0.5in, all: false), spacing: 1.4em)
  } else if paragraph-style == "block" {
    // Word-style: no indent + extra spacing between paragraphs
    set par(first-line-indent: 0pt, spacing: 2em)
  }

  // ... rest of template ...
}
```

**Note:** `all: false` (default) indents all paragraphs except the first after a heading, which is standard typographic convention. `all: true` would indent even the first paragraph after a heading — decide during calibration.

### Pattern 4: Footer Page Numbers

**What:** `set page(numbering: "1")` is already in Phase 1's code. The `number-align` parameter defaults to `center + bottom`, so centering is automatic.

**When to use:** Already implemented; verify it works correctly.

**Example:**
```typst
// Source: https://typst.app/docs/guides/page-setup/
// Already in misq.typ from Phase 1 — verify number-align default is center
set page(
  paper: "us-letter",
  margin: (x: 1in, top: 1in, bottom: 1in),
  numbering: "1",
  number-align: center + bottom,  // explicit (default value)
)
```

### Anti-Patterns to Avoid

- **Transformational show rule without block wrapper:** `show heading: it => text(...)` without `block()` causes orphaned headings. Always wrap in `block()`.
- **Using `it.body` alone when numbering is needed:** When writing `it => block({ it.body })`, the heading counter/number is lost. Use `it` (the full heading element) or reconstruct the number display. See Pitfall 1.
- **`set align(center)` outside show rule:** Setting align globally affects all content. Scope it inside the show rule.
- **Using `#v()` spacers for heading spacing:** Using vertical spacers in show rules is fragile. Use `set block(above:, below:)` instead.
- **Both first-line-indent AND extra paragraph spacing:** Typographically, choose one or the other per paragraph-style mode.

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Uppercase heading text | String manipulation function | `upper(it.body)` | Built-in, handles all Unicode |
| Per-level heading styling | Conditional logic on heading level in a single show rule | `show heading.where(level: N): ...` | Typst's native selector; cleaner, composable |
| Page break detection | State tracking for "are we still on page 1?" | `pagebreak()` in template body | Direct and reliable |
| Page counter display | Manual counter state | `set page(numbering: "1")` | Native page numbering |
| Paragraph indentation | Manual `h()` spacers at paragraph start | `set par(first-line-indent:)` | Native, applies correctly |

**Key insight:** Typst's show rule system with `where()` selectors was designed specifically for per-level heading customization. Do not fight it with conditional logic.

## Common Pitfalls

### Pitfall 1: Lost Heading Numbers in Transformational Show Rules

**What goes wrong:** Writing `show heading.where(level: 1): it => block({ upper(it.body) })` discards the heading's automatic number. The rendered heading shows only "INTRODUCTION" instead of "1. INTRODUCTION".

**Why it happens:** `it.body` contains only the text the author wrote. The number is rendered separately by the default heading show rule, which is bypassed when you provide a full transformation.

**How to avoid:** Either (a) display the number manually using the heading's counter, or (b) use a show-set rule style (`show heading.where(level: 1): set align(center)`) for properties that don't need full replacement, and only use `it => block(...)` when the number display can be reconstructed.

**Recommended pattern for numbered headings with custom styling:**
```typst
// Source: https://typst.app/docs/reference/model/heading/
show heading.where(level: 1): it => block(
  above: 1.4em,
  below: 0.8em,
  {
    set align(center)
    set text(weight: "bold", size: 12pt)
    // Render number if heading has numbering configured
    if it.numbering != none {
      counter(heading).display(it.numbering)
      [ ]
    }
    upper(it.body)
  }
)
```

**Warning signs:** Headings show text but no numbers; or headings show numbers but wrong text.

### Pitfall 2: `set heading(numbering:)` Position Matters

**What goes wrong:** Placing `set heading(numbering: "1.1.")` inside the `misq()` function body after the front matter means it may not apply correctly, or numbering counts the front-matter headings.

**Why it happens:** Typst's set rules apply from their position forward. If numbering is set before the page break and body, the counter starts counting at page 1 content.

**How to avoid:** Place `set heading(numbering: "1.1.")` early in the `misq()` function so it covers the whole document. The front matter in Phase 2 has no headings (title is not a `=` heading — it's rendered as content), so no counter offset issues arise.

**Warning signs:** Numbering starts at 2 instead of 1; or heading numbers are offset.

### Pitfall 3: `first-line-indent` Behavior After Headings

**What goes wrong:** With `set par(first-line-indent: ...)`, the paragraph immediately following a heading may or may not be indented depending on `all:` setting. LaTeX convention is to NOT indent the first paragraph after a heading.

**Why it happens:** By default (`all: false`), Typst does NOT indent the first paragraph after a block-level element (like a heading). This matches LaTeX convention. Setting `all: true` would indent it, which is typically wrong.

**How to avoid:** Use `all: false` (default) for the "indent" paragraph style. The first paragraph after a heading will not be indented; subsequent paragraphs will be. This is correct MISQ/academic convention.

**Warning signs:** First paragraph after each heading has an unexpected indent.

### Pitfall 4: `upper()` in Show Rule Receives Heading Element, Not String

**What goes wrong:** `upper(it)` (the full heading element) may not behave as expected. `upper()` works on strings or content.

**Why it happens:** `it` is the heading element. `it.body` is content (the author's heading text).

**How to avoid:** Always use `upper(it.body)` not `upper(it)`.

### Pitfall 5: Abstract Label Was Left-Aligned in Phase 1

**What goes wrong:** Phase 1's `misq.typ` renders "Abstract" with `text(weight: "bold")[Abstract]` — this is left-aligned by default (follows document flow). The CONTEXT.md decision is to make it centered.

**Why it happens:** Phase 1 didn't implement centering for the abstract label.

**How to avoid:** Wrap the label in `align(center, ...)` in the updated template:
```typst
align(center, text(weight: "bold")[Abstract])
```

## Code Examples

Verified patterns from official sources:

### Numbered Heading Set Rule
```typst
// Source: https://typst.app/docs/reference/model/heading/
// Hierarchical numbering: "1", "1.1", "1.1.1"
#set heading(numbering: "1.1.")
```

### Level-Specific Show Rule (Set Rule Style — No Number Loss)
```typst
// Source: https://typst.app/docs/reference/model/heading/
// Show-SET rules do not bypass default rendering — numbers preserved
#show heading.where(level: 1): set align(center)
#show heading.where(level: 1): set text(weight: "bold", size: 12pt)
// But this approach cannot apply upper() — needs full transformation for that
```

### Level-Specific Show Rule (Full Transformation with Number Reconstruction)
```typst
// Source: https://typst.app/docs/reference/model/heading/ + community pattern
#show heading.where(level: 1): it => block(
  above: 1.4em,
  below: 0.8em,
  {
    set align(center)
    if it.numbering != none {
      counter(heading).display(it.numbering)
      [ ]
    }
    upper(it.body)
  }
)
```

### Uppercase Function
```typst
// Source: https://typst.app/docs/reference/text/upper/
#upper("introduction")    // => "INTRODUCTION"
#upper[*my heading*]      // Works with formatted content
```

### Page Break After Title Page
```typst
// Source: https://typst.app/docs/reference/layout/pagebreak/
// weak: true skips break if page is already empty (avoids blank page)
pagebreak(weak: true)
```

### Centered Footer Page Numbers
```typst
// Source: https://typst.app/docs/guides/page-setup/
// number-align defaults to center+bottom — explicit for clarity
set page(
  numbering: "1",
  number-align: center + bottom,
)
```

### First-Line Indent Paragraph Style
```typst
// Source: https://typst.app/docs/reference/model/par/
// "indent" mode: first-line indent, no extra between-paragraph spacing
set par(
  justify: true,
  leading: 1.4em,
  spacing: 1.4em,       // no extra spacing — indent signals paragraph break
  first-line-indent: (amount: 0.5in, all: false),
)

// "block" mode: no indent, extra between-paragraph spacing
set par(
  justify: true,
  leading: 1.4em,
  spacing: 2em,         // extra spacing signals paragraph break
  first-line-indent: 0pt,
)
```

### Heading Spacing via Block
```typst
// Source: https://forum.typst.app/t/how-to-change-spacing-between-a-paragraph-and-the-next-subheading/2178
// Uniform spacing for all heading levels
#show heading: set block(above: 1.4em, below: 0.8em)
// Or per-level:
#show heading.where(level: 1): set block(above: 1.75em, below: 0.85em)
```

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| Manual `#v()` spacers for heading spacing | `show heading: set block(above:, below:)` | Typst 0.x → stable | Cleaner, no brittle manual spacing |
| `first-line-indent` length only | `first-line-indent` accepts dict `{amount:, all:}` | Added in recent Typst version | More control over first-paragraph behavior |
| Heading numbering via manual counters | `set heading(numbering: "1.1.")` | Typst early versions | Native, zero-maintenance numbering |

**Deprecated/outdated:**
- Manual counter manipulation for heading numbers: Use `set heading(numbering:)` instead.
- `parbreak()` for paragraph separation: Still valid but `v(...)` or block spacing is preferred for programmatic use.

## Open Questions

1. **Numbering format: "1." vs "1.1." vs custom function**
   - What we know: `"1.1."` produces "1", "1.1", "1.1.1" for levels 1/2/3 — this is exactly what CONTEXT.md specifies
   - What's unclear: Whether the trailing period in "1." at level 1 is desired (CONTEXT.md says "1, 2, 3" — no period)
   - Recommendation: Use a numbering function or `"1.1"` (no trailing dot) and test the rendered output; may need a custom function to suppress the trailing period

2. **Heading number + uppercase reconstruction in show rule**
   - What we know: Full transformational show rules bypass default number rendering
   - What's unclear: Whether `counter(heading).display(it.numbering)` works correctly when `it.numbering` is inherited from `set heading(numbering:)` vs set on the element
   - Recommendation: Implement and test; fall back to show-set rules with a separate `#show heading.where(level:1): it => upper(it)` if counter reconstruction is complex

3. **Title vertical spacing calibration**
   - What we know: Must visually match Word template (`MISQ-Manuscript-Template-Word.docx`)
   - What's unclear: Exact `v()` values before/after title
   - Recommendation: Implement with approximate values (1em before abstract, 1em after title), then open the Word doc and PDF side-by-side to calibrate

4. **`first-line-indent` with double-spacing interaction**
   - What we know: `set par(leading: 1.4em, spacing: 1.4em, first-line-indent: 0.5in)` — the spacing and indent coexist
   - What's unclear: Whether indent mode should reduce `spacing` (body text already double-spaced, so `spacing: 1.4em` keeps double-spacing between paragraphs even in indent mode)
   - Recommendation: Keep `spacing: 1.4em` in both modes; in "indent" mode the visual difference between paragraphs comes from the indent, not reduced spacing — this is the LaTeX behavior

## Validation Architecture

> nyquist_validation key absent from config.json — treating as enabled.

### Test Framework

| Property | Value |
|----------|-------|
| Framework | None — this is a Typst template project with no automated test framework |
| Config file | none |
| Quick run command | `typst compile template/main.typ template/main.pdf` |
| Full suite command | `typst compile template/main.typ template/main.pdf && open template/main.pdf` |

This project's validation is visual PDF inspection, not automated unit tests. All "tests" are compile-and-inspect.

### Phase Requirements → Test Map

| Req ID | Behavior | Test Type | Automated Command | File Exists? |
|--------|----------|-----------|-------------------|-------------|
| HEAD-01 | Level 1 headings: centered, uppercase, bold, 12pt, numbered | visual | `typst compile template/main.typ` | ✅ main.typ exists |
| HEAD-02 | Level 2 headings: centered, bold, 12pt, numbered | visual | `typst compile template/main.typ` | ✅ main.typ exists |
| HEAD-03 | Level 3 headings: left-aligned, bold, 12pt, numbered | visual | `typst compile template/main.typ` | ✅ main.typ exists |
| HEAD-04 | Numbered headings (1, 1.1, 1.1.1) | visual | `typst compile template/main.typ` | ✅ main.typ exists |
| STRC-01 | Page 1: bold centered title, abstract label, keywords | visual | `typst compile template/main.typ` | ✅ main.typ exists |
| STRC-02 | Introduction on page 2 | visual | `typst compile template/main.typ` | ✅ main.typ exists |
| STRC-03 | REFERENCES heading (author-managed) | visual | `typst compile template/main.typ` | ❌ Wave 0: add REFERENCES section to main.typ |
| STRC-04 | APPENDIX heading (author-managed) | visual | `typst compile template/main.typ` | ❌ Wave 0: add APPENDIX section to main.typ |
| PAGE-03 | Centered footer page numbers | visual | `typst compile template/main.typ` | ✅ main.typ exists |

### Sampling Rate

- **Per task commit:** `typst compile template/main.typ template/main.pdf`
- **Per wave merge:** `typst compile template/main.typ template/main.pdf` + open PDF for visual inspection
- **Phase gate:** All requirements visually verified in PDF before `/gsd:verify-work`

### Wave 0 Gaps

- [ ] `template/main.typ` — add level 2 and level 3 heading examples (currently only `=` headings)
- [ ] `template/main.typ` — add `paragraph-style: "indent"` and `paragraph-style: "block"` example usage
- [ ] `template/main.typ` — add manual REFERENCES section (`#pagebreak()` + bold centered "REFERENCES")
- [ ] `template/main.typ` — add manual APPENDIX section (`#pagebreak()` + bold centered "APPENDIX")
- [ ] `template/main.typ` — remove `bib:` parameter from `#show: misq.with(...)` call

## Sources

### Primary (HIGH confidence)
- https://typst.app/docs/reference/model/heading/ — heading parameters, numbering patterns, where() selectors, show rule patterns
- https://typst.app/docs/reference/text/upper/ — upper() function for uppercase transformation
- https://typst.app/docs/reference/layout/page/ — page numbering, footer, number-align
- https://typst.app/docs/guides/page-setup/ — page numbering centered footer, number-align defaults
- https://typst.app/docs/reference/model/par/ — first-line-indent parameter including `all:` dictionary form
- https://typst.app/docs/reference/layout/pagebreak/ — pagebreak() function, weak: parameter

### Secondary (MEDIUM confidence)
- https://forum.typst.app/t/how-to-change-spacing-between-a-paragraph-and-the-next-subheading/2178 — heading spacing via `show heading: set block(above:, below:)`
- https://github.com/typst/typst/discussions/1363 — selective heading numbering patterns including per-level control
- https://typst.app/docs/tutorial/advanced-styling/ — it.body, it.level access in transformational show rules

### Tertiary (LOW confidence)
- None — all key claims verified with official documentation

## Metadata

**Confidence breakdown:**
- Standard stack: HIGH — all APIs verified against official Typst docs
- Architecture: HIGH — patterns follow official show rule guidance
- Pitfalls: MEDIUM — Pitfall 1 (lost numbers) is well-documented; exact calibration values (heading spacing, title spacing) require empirical tuning
- Paragraph-style toggle: HIGH for mechanism; MEDIUM for exact indent values (0.25–0.5in range specified in CONTEXT.md)

**Research date:** 2026-03-13
**Valid until:** 2026-09-13 (Typst APIs are stable; valid ~6 months)
