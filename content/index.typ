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
  html.elem("li", [*2026.05* — Submitted my thesis (finally!).])
  html.elem("li", [*2025.12* — Presented a poster at NeurIPS in San Diego.])
  html.elem("li", [*2025.12* — Attended #link("https://www.dagstuhl.de/en/seminars/seminar-calendar/seminar-details/25491")[Approaches and Applications of Inductive Programming] at Dagstuhl.])
  html.elem("li", [*2025.08* — Presented a talk at RLC in Alberta.])
  html.elem("li", [*2025.07* — Presented a poster and a talk at CogSci in San Francisco.])
  html.elem("li", [*2025.03* — Started research visit #link("https://cicl.stanford.edu/")[Causality in Cognition Lab (CiCL)] at Stanford.])
  html.elem("li", [*2025.01* — Presented an invited talk at Gesellschaft für Empirische Bildungsforschung in Mannheim.])
  html.elem("li", [*2024.07* — Presented a poster at CogSci in Rotterdam.])
  html.elem("li", [*2024.05* — Presented a poster at ICLR in Vienna.])
  html.elem("li", [*2023.08* — Presented a poster at CCN in Oxford.])
  html.elem("li", [*2023.07* — Organized and presented at #link("https://mlcolab.org/public-events/introml-workshop-series")[IntroML workshop].])
  html.elem("li", [*2023.06* — Attended and presented at RLSS in Barcelona.])
  html.elem("li", [*2022.07* — Presented a poster and a talk at 4th Cluster Conference Machine Learning in Science.])
  html.elem("li", [*2022.04* — Joined #link("https://imprs.is.mpg.de/")[IMPRS-IS] cohort.])
  html.elem("li", [*2022.04* — Started PhD at the University of Tübingen.])
})
