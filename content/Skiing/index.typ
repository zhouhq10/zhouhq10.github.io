#import "../index.typ": template, tufted
#show: template.with(
  title: "Skiing",
  description: "Snowy memories.",
)

#let photo(src, caption) = html.elem("figure", attrs: (class: "photo"), {
  html.elem("img", attrs: (src: "photos/" + src, alt: caption))
  html.elem("figcaption", caption)
})

#let row(..items) = html.elem("div", attrs: (class: "photo-row"), items.pos().join())

= Skiing

#row(
  photo("ontheroad.jpeg", "Somewhere on the road"),
  photo("valthoren.jpeg", "Val Thorens, France"),
)

#row(
  photo("feldberg.png", "Snowstorm in Feldberg, Germany"),
  photo("tahoe.jpg", "Lake Tahoe, US"),
)

#row(
  photo("stanton.png", "Saint Anton, Austria"),
  photo("chamonix.jpg", "Chamonix, France"),
)

#row(
  photo("La Plagne.jpg", "La Plagne, France"),
)
