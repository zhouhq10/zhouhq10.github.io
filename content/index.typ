#import "../config.typ": template, tufted
#show: template

#tufted.margin-note[
  #image("hanqizhou.jpg")
]

#let hover-note(text, tip) = html.elem(
  "span",
  attrs: (class: "hover-note", tabindex: "0"),
  text + html.elem("span", attrs: (class: "hover-tip"), tip),
)

= Hanqi Zhou

Hi there! Thank you for dropping by. I am Hanqi Zhou (周涵琪#hover-note("*", [_qi_ is similar to "chee" in cheese; _Zh_ is most similar to "j" in _Bonjour_.])).

I am a PhD student at the #link("https://uni-tuebingen.de/en/research/core-research/cluster-of-excellence-machine-learning/home/")[University of Tübingen] and the #link("https://imprs.is.mpg.de/")[International Max Planck Research School for Intelligent Systems (IMPRS-IS)].

I am supervised by #link("https://hmc-lab.com/people/charley_wu/index.md")[Charley Wu] at the #link("https://hmc-lab.com/")[Human and Machine Cognition Lab], where I work on computational models of human cognition. I also work closely with #link("https://www.mpg.de/12309370/biological-cybernetics-dayan")[Peter Dayan] and #link("https://motivationsciencelab.com/")[Kou Murayama].

I am interested in how humans think, learn, and make decisions, especially when we are short on computation and memory. I like to start from theory, build computational models (with symbolic representations, e.g. program induction), and test them through online experiments.

== News

#html.elem("ul", attrs: (class: "news-list"), {
  html.elem("li", [*May 2026* — Visiting the #link("https://cicl.stanford.edu/")[Causality in Cognition Lab (CiCL)] at Stanford. Let's grab a coffee if you are around!])
  html.elem("li", [*Mar 2026* — Gave a talk at a reading group on resource-rational program induction.])
  html.elem("li", [*Jan 2026* — New preprint out on compositional generalization in human learners.])
  html.elem("li", [*Nov 2025* — Attended NeurIPS 2025 in San Diego; presented a poster on memory-bounded inference.])
  html.elem("li", [*Sep 2025* — Co-organized a workshop at CogSci on computational models of cognition.])
  html.elem("li", [*Jun 2025* — Started a research visit at MPI for Biological Cybernetics.])
  html.elem("li", [*Apr 2025* — Paper accepted at CogSci 2025.])
  html.elem("li", [*Feb 2025* — Passed PhD qualifying milestones.])
  html.elem("li", [*Oct 2024* — Joined IMPRS-IS cohort.])
  html.elem("li", [*Sep 2024* — Started PhD at the University of Tübingen.])
})
