#import "tufted-lib/tufted.typ" as tufted

#let template = tufted.tufted-web.with(
  header-links: (
    "/": "Home",
    "/Research/": "Research",
    "/Talks/": "Talks",
    "/Writing/": "Writing",
    "/Personal/": "Personal",
    "/LetsChat/": "Let's chat",
  ),

  website-title: "Hanqi Zhou",
  author: "Hanqi Zhou",
  description: "Personal website of Hanqi Zhou, PhD student in computational cognitive science at the University of Tübingen.",
  website-url: "https://zhouhq10.github.io/",
  lang: "en",
  feed-dir: ("/Writing/",),

  footer-elements: (
    [© #datetime.today().year() Hanqi Zhou],
    [Built with #link("https://github.com/Yousa-Mirage/Tufted-Blog-Template")[Tufted-Blog-Template] and #link("https://typst.app/")[Typst]],
  ),
)
