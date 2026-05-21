#import "../index.typ": template, tufted
#show: template.with(
  title: "Travel",
  description: "Little moments that made me pause.",
)

#let photo(src, caption) = html.elem("figure", attrs: (class: "photo"), {
  html.elem("img", attrs: (src: "photos/" + src, alt: caption))
  html.elem("figcaption", caption)
})

#let row(..items) = html.elem("div", attrs: (class: "photo-row"), items.pos().join())

= Travel

Little moments that made me pause :)

#row(
  photo("tuebingen.jpg", "Tübingen, Germany"),
  photo("sf.jpg", "San Francisco, US"),
)

#row(
  photo("milan.jpg", "Milan, Italy"),
  photo("lakecomo.jpg", "Lake Como, Italy"),
  photo("Naples_in_hamburg_Miniatur Wunderland.jpg", "(Mini)Naples — Hamburg Miniatur Wunderland"),
)

#row(
  photo("konstanz.jpg", "Konstanz, Germany"),
  photo("dusseldorf.jpg", "Düsseldorf, Germany"),
  photo("hamilton.jpg", "Hamilton in Hamburg, Germany — yes, all in German; the rap still slaps ;)"),
)

#row(
  photo("shinjuku.jpg", "Shinjuku, Japan"),
  photo("shenyang.jpg", "Shenyang, China"),
)

#row(
  photo("istanbul.jpg", "Istanbul, Turkey"),
  photo("jerusalem.jpeg", "Jerusalem, Israel"),
  photo("vienna.jpg", "Vienna, Austria"),
)

#row(
  photo("copenhagen.jpg", "Copenhagen, Denmark"),
  photo("greece.jpg", "Corinth Canal, Greece"),
  photo("grancanaria.jpg", "Gran Canaria, Spain"),
)
