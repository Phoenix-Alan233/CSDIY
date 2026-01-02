#let template-title-row(
  title: "",
  authors: (),
  date: none,
  lang: "en",
  body
) = {
  //////////********** Document properties **********//////////
  set document(author: authors.map(a => a.name), title: title)
  set page(numbering: "1", number-align: right, margin: 20mm, paper: "a3", columns: 2)

  //////////********** Type settings **********//////////
  // Set basic typographical properties.
  let font-serif = (
    "Libertinus Serif",
    "Noto Serif CJK SC"
  )
  set text(font: font-serif, lang: lang, )
  set math.equation(numbering: "(1)")
  // show math.equation: set text(size: 0.7em)
  show heading: set block(below: 1em, above: 1.3em)
  set heading(numbering: "1.1")

  // Code styles
  show raw.where(block: true): block.with(
    width: 100%,
    // commented out by xks, better for printing
    // fill: luma(240),
    inset: 10pt,
    radius: 4pt
  )
  show raw.where(block: false): box.with(
    // commented out by xks, better for printing
    // fill: luma(240),
    inset: (x: 3pt, y: 0pt),
    outset: (y: 3pt),
    radius: 2pt,
  )

  // Chinese font in math equation
  show math.equation: it => {
    show regex("\p{script=Han}"): set text(font: "Noto Serif CJK TC")
    it
  }

  show raw: it => {
    show regex("\p{script=Han}"): set text(font: "Noto Sans Mono CJK SC")
    it
  }

  //////////********** Title row **********//////////
  align(center)[
    #block(text(weight: 700, 1.75em, title))
    #v(1em, weak: true)
    #date
  ]

  // Author info
  pad(
    top: 0.5em,
    bottom: 0.5em,
    x: 2em,
    grid(
      columns: (1fr,) * calc.min(3, authors.len()),
      gutter: 1em,
      ..authors.map(author => align(center)[
        *#author.name*
      ]),
    ),
  )

  set par(justify: true)
  body
}

//////////********** Callout **********//////////
#let callout(
  title: "",
  color: blue,
  content
) = {
  let _inset = 0.8em
  let _color = color.darken(5%)
  v(0.2em)
  block(
    below: 1em,
    stroke: 0.5pt + _color,
    radius: 3pt,
    width: 100%,
    inset: _inset
  )[
    #place(
      top + left,
      dy: -6pt - _inset,
      dx: 8pt - _inset,
      block(fill: white, inset: 2pt)[
        #set text(fill: _color)
        #title
      ]
    )
    #set text(fill: _color)
    #set par(first-line-indent: 0em)
    #content
  ]
}

#let callout-styles = (
  example:      (title: "Example", it) =>     callout(title: title, color: rgb(100, 100, 100))[#it],
  proof:        (title: "Proof", it) =>       callout(title: title, color: rgb(120, 120, 120))[#it],
  abstract:     (title: "Abstract", it) =>    callout(title: title, color: rgb(0, 133, 143))[#it],
  summary:      (title: "Summary", it) =>     callout(title: title, color: rgb(0, 133, 143))[#it],
  info:         (title: "Info", it) =>        callout(title: title, color: rgb(68, 115, 218))[#it],
  note:         (title: "Note", it) =>        callout(title: title, color: rgb(68, 115, 218))[#it],
  tip:          (title: "Tip", it) =>         callout(title: title, color: rgb(0, 133, 91))[#it],
  hint:         (title: "Hint", it) =>        callout(title: title, color: rgb(0, 133, 91))[#it],
  success:      (title: "Success", it) =>     callout(title: title, color: rgb(62, 138, 0))[#it],
  important:    (title: "Important", it) =>   callout(title: title, color: rgb(62, 138, 0))[#it],
  help:         (title: "Help", it) =>        callout(title: title, color: rgb(153, 110, 36))[#it],
  warning:      (title: "Warning", it) =>     callout(title: title, color: rgb("#e17909"))[#it],
  attention:    (title: "Attention", it) =>   callout(title: title, color: rgb(216, 58, 49))[#it],
  caution:      (title: "Caution", it) =>     callout(title: title, color: rgb(216, 58, 49))[#it],
  failure:      (title: "Failure", it) =>     callout(title: title, color: rgb(216, 58, 49))[#it],
  danger:       (title: "Danger", it) =>      callout(title: title, color: rgb(216, 58, 49))[#it],
  error:        (title: "Error", it) =>       callout(title: title, color: rgb(216, 58, 49))[#it],
  bug:          (title: "Bug", it) =>         callout(title: title, color: rgb(204, 51, 153))[#it],
  quote:        (title: "Quote", it) =>       callout(title: title, color: rgb(132, 90, 231))[#it],
  cite:         (title: "Cite", it) =>        callout(title: title, color: rgb(132, 90, 231))[#it],
  experiment:   (title: "Experiment", it) =>  callout(title: title, color: rgb(132, 90, 231))[#it],
  question:     (title: "Question", it) =>    callout(title: title, color: rgb(132, 90, 231))[#it],
  analysis:     (title: "Analysis", it) =>    callout(title: title, color: rgb(0, 133, 91))[#it],
)

// shorthand for callout
#let c = callout-styles

//////////********** Codex implementation **********//////////
#let codex(
  code,
  lang: none,
  size: 1em,
) = {
  if code.len() > 0 {
    if code.ends-with("\n") {
      code = code.slice(0, code.len() - 1)
    }
  } else {
    code = "// no code"
  }
  set text(size: size)
  align(left)[
    #raw(lang: lang, block: true, code)
  ]
}

// added by xks
#let colred(x) = text(fill:red, $#x$)
#let colblue(x) = text(fill:blue, $#x$)

// added by ct
// usage:
// #resizeEquation(size: 0.7em)[$F=ma$]
#let resizeEquation(
  size: 0.5em,
  body
) = {
  show math.equation: set text(size: size)
  body
}

// added by xks
// for a2 paper. if you use a3, replaces this with
// #let eqcolumns(n, gutter: 4%, content) = content;
// to bypass it. 
// https://github.com/typst/typst/issues/466
#let eqcolumns(n, gutter: 4%, content) = {
  layout(size => [
    #let (height,) = measure(
      block(
        width: (1/n) * size.width * (1 - float(gutter)*n), 
        content
      )
    )
    #block(
      height: height / n,
      columns(n, gutter: gutter, content)
    )
  ])
}