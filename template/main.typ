// template/main.typ — Test document for misq.typ
// Exercises: title page, abstract, keywords, page break, heading levels, body spacing,
//            figures, tables, bibliography, appendix, paragraph-style indent mode

#import "../misq.typ": misq

#show: misq.with(
  title: [MISQ Template Test Document],
  abstract: [
    This is the abstract of the test document. It should appear with 1.5x line spacing,
    which is noticeably tighter than the double-spaced body text but looser than the
    single-spaced bibliography. The abstract should span multiple lines to make the
    spacing visible. This text is intentionally long enough to wrap across several lines
    so that the line spacing can be clearly evaluated.
  ],
  keywords: ("information systems", "template", "typst", "formatting"),
  paragraph-style: "indent",
)

= Introduction

This is the introduction section of the test document. It should appear with double
line spacing, matching the MISQ submission requirements. The body text is set in
12pt Times New Roman at double spacing (equivalent to LaTeX baselinestretch 2.0).

This second paragraph continues the body text. Both paragraphs should appear clearly
double-spaced, with the same visual density as a Word or LaTeX document set to
double spacing. Compare the spacing here to the abstract above and the bibliography
below — the body text should be noticeably more spread out.

A third paragraph is included here to provide additional comparison material for
evaluating the line spacing calibration. The spacing between lines within this
paragraph (leading) and between this paragraph and the previous one (spacing) should
both appear consistent with standard double-spacing.

= Literature Review

This section reviews prior work relevant to the study. It should also appear at
double line spacing consistent with the MISQ formatting requirements.

== Theoretical Background

This is a level 2 heading (centered, bold, numbered 2.1). The body text continues
with standard double-spacing. This subsection demonstrates the second-level heading
style which should be centered and bold, matching the MISQ style guide.

=== Key Constructs

This is a level 3 heading (left-aligned, bold, numbered 2.1.1). Level 3 headings
follow left alignment. This subsubsection demonstrates the third-level heading style.
The body text here continues the standard double-spaced formatting.

== Prior Research

This is a second level-2 heading within the Literature Review section (numbered 2.2).
This helps verify that the numbering sequence works correctly across multiple
subsections within a given section.

= Methodology

This section describes the research methodology. The figure and table below test
the single-spacing show rules from Phase 1.

The following figure uses a rectangle placeholder to test figure single-spacing:

#figure(
  rect(width: 4in, height: 2in, fill: luma(230)),
  caption: [
    A sample figure caption. This caption text should appear single-spaced,
    which is noticeably tighter than the double-spaced body text above.
    The figure content itself is also rendered at single spacing.
  ]
)

The following table tests table single-spacing:

#figure(
  table(
    columns: (2fr, 1fr, 1fr),
    table.header(
      [Variable], [Mean], [SD],
    ),
    [Information quality], [3.84], [0.72],
    [System usability], [4.12], [0.65],
    [User satisfaction], [3.97], [0.81],
    [Task performance], [4.23], [0.58],
  ),
  caption: [Descriptive statistics for key study variables.]
)

= Discussion

This section contains body text that cites the sample references
@brown2023fault and @gupta2018economic. The bibliography at the end of this document
should appear in single-spaced APA format, visually tighter than the body text.

The body text in this section continues to be double-spaced, providing a clear
visual contrast with the single-spaced bibliography that follows.

#pagebreak()

#align(center, text(weight: "bold")[REFERENCES])

#bibliography("references.bib", style: "apa", title: none)

#pagebreak()

#align(center, text(weight: "bold", size: 12pt)[APPENDIX])

This appendix contains supplementary materials for the test document. The appendix
heading above should appear centered and bold, on its own page, separated from the
references by a page break. This demonstrates the author-managed appendix approach
per the MISQ template design decisions.

Authors may include multiple appendices by repeating this pattern with distinct
headings such as "APPENDIX A" and "APPENDIX B" as needed for their manuscript.
