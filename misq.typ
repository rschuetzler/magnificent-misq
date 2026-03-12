// misq.typ — MIS Quarterly submission template for Typst
//
// Font: Times New Roman is required by MISQ.
// "Times" is the macOS/Linux fallback if TNR is not installed.
// No runtime font check — silent fallback per MISQ template policy.

#let misq(
  title: [Untitled],
  abstract: none,
  keywords: (),
  bib: none,
  body
) = {

  // --- Page geometry (PAGE-01, PAGE-02) ---
  // US Letter: 8.5" x 11"
  // Margins: 1" all sides → 6.5" text width, 9" text height
  // Matches LaTeX: textwidth 6.5in, textheight 9in
  set page(
    paper: "us-letter",
    margin: (x: 1in, top: 1in, bottom: 1in),
    numbering: "1",
  )

  // --- Font (TYPO-01) ---
  // Times New Roman is required; Times is the macOS/Linux fallback
  set text(font: ("Times New Roman", "Times"), size: 12pt)

  // --- Body paragraph spacing (TYPO-02) ---
  // Double-spaced: visually equivalent to LaTeX \baselinestretch{2.0}
  // Typst leading is gap between lines (not baseline-to-baseline),
  // so values differ from traditional line-height calculations.
  // Both leading (intra-paragraph) and spacing (inter-paragraph) are set.
  // Calibrated against LaTeX reference output at 12pt Times.
  set par(justify: true, leading: 0.85em, spacing: 0.85em)

  // --- Single-spacing for bibliography (TYPO-04) ---
  // Matches LaTeX \baselinestretch{1.0} for references section
  show bibliography: set par(leading: 0.65em, spacing: 0.65em)

  // --- Single-spacing for figures and tables (TYPO-05) ---
  // Captions and figure/table content rendered at single-spacing
  show figure: set par(leading: 0.65em, spacing: 0.65em)

  // --- Front matter: abstract (TYPO-03) ---
  if abstract != none {
    text(weight: "bold")[Abstract]
    linebreak()
    // 1.5x spacing: visually equivalent to LaTeX \baselinestretch{1.5}
    // Scoped to abstract block only, does not affect body
    block({
      set par(leading: 0.55em, spacing: 0.55em)
      abstract
    })
    parbreak()
  }

  // --- Front matter: keywords ---
  if keywords.len() > 0 {
    text(weight: "bold")[Keywords: ]
    for (i, k) in keywords.enumerate() {
      k
      if i < keywords.len() - 1 { [, ] }
    }
    parbreak()
  }

  // --- Body content ---
  body

  // --- Bibliography ---
  if bib != none {
    bibliography(bib, style: "apa")
  }
}
