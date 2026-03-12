// template/main.typ — Minimal test document for misq.typ
// Exercises all spacing regions: body (2x), abstract (1.5x), references/figures/tables (1x)

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
  bib: "template/references.bib",
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

= Sample Figure

The following figure uses a rectangle placeholder to test figure single-spacing:

#figure(
  rect(width: 4in, height: 2in, fill: luma(230)),
  caption: [
    A sample figure caption. This caption text should appear single-spaced,
    which is noticeably tighter than the double-spaced body text above.
    The figure content itself is also rendered at single spacing.
  ]
)

= Sample Table

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
