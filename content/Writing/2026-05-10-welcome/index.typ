#import "../index.typ": template, tufted
#show: template.with(
  title: "Welcome — and why I'm starting this notebook",
  description: "First post on the new site.",
  date: datetime(year: 2026, month: 5, day: 10),
  lang: "en",
)

= Welcome

This is the first post on a new version of my site, redesigned in the spirit of Edward Tufte#footnote[See #link("https://edwardtufte.github.io/tufte-css/")[Tufte CSS] for the canonical web translation of his typographic ideas.] — wide margins, sidenotes, content first.

#tufted.margin-note[
  _Sidenotes_ live in the margin and don't break the reading flow. They are for things you want the reader to glance at, but not be forced through.
]

I wanted a place that was less of a CV-shaped homepage and more of a notebook — somewhere I can put down half-formed ideas without them needing to be a paper, a thread, or a talk. Most of what I think about — resource-rational cognition, intrinsic motivation, where values come from — moves slowly. Slow ideas deserve a slow medium.

== Why this format

Two reasons.

First, *margins as thinking space*. In academic writing we hide caveats and asides behind footnotes that nobody reads. Sidenotes pull them up to where the eye is.#footnote[The earliest example I keep coming back to: Tufte's _Visual Display of Quantitative Information_, where the marginalia carry as much weight as the main text.]

Second, *figures as first-class citizens*. The page width here is wide enough that a figure does not need to interrupt the flow.

#tufted.margin-note[
  This is roughly the visual grammar I want for future posts: text in the main column, asides and small images in the margin, larger figures spanning the full width when they earn it.
]

== What's coming

Probably a mix of:

- _Reading notes._ I read a lot of papers; most of the value is lost if I don't write down what I took away.
- _Half-baked ideas._ Things that aren't paper-shaped yet but I want to think out loud about.
- _Pointers._ Other people's writing I want to remember and recommend.

If something here is useful — or wrong — please #link("/LetsChat/")[reach out].
