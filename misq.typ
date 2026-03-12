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
  // Typst `leading` is a gap (space between bottom of one line and top of next),
  // not baseline-to-baseline distance. At 12pt Times New Roman:
  //   LaTeX 2x: baselineskip = 2 * 14.4pt = 28.8pt → Typst leading = 28.8 - 12 = 16.8pt ≈ 1.4em
  // Calibrated against LaTeX reference values; both leading (intra-paragraph)
  // and spacing (inter-paragraph) are set to the same value for uniform double-spacing.
  set par(justify: true, leading: 1.4em, spacing: 1.4em)

  // --- Single-spacing for bibliography (TYPO-04) ---
  // Matches LaTeX \baselinestretch{1.0} for references section
  // At 12pt Times: LaTeX 1x = 14.4pt → Typst leading = 14.4 - 12 = 2.4pt ≈ 0.2em
  // Using 0.65em (Typst default) which produces standard readable single-spacing
  show bibliography: set par(leading: 0.65em, spacing: 0.65em)

  // --- Single-spacing for figures and tables (TYPO-05) ---
  // Captions and figure/table content rendered at single-spacing (same as bibliography)
  show figure: set par(leading: 0.65em, spacing: 0.65em)

  // --- Front matter: abstract (TYPO-03) ---
  if abstract != none {
    text(weight: "bold")[Abstract]
    linebreak()
    // 1.5x spacing: visually equivalent to LaTeX \baselinestretch{1.5}
    // At 12pt Times: LaTeX 1.5x = 1.5 * 14.4pt = 21.6pt → Typst leading = 21.6 - 12 = 9.6pt ≈ 0.8em
    // Scoped to abstract block only; body spacing is restored after this block
    block({
      set par(leading: 0.8em, spacing: 0.8em)
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
