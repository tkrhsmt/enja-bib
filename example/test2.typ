#import "../src/lib.typ": *

#import bib_setting_jsme: *
#show: bib_init

#set text(font: ("Times New Roman", "Harano Aji Mincho"))


#bibliography-list(
  bib-tex(`
  @inbook{Alligood:Springer1996,
    author      = {Kathleen T. Alligood and Tim D. Sauer and James A. Yorke},
    title       = {Chaos: An Introduction to Dynamical Systems},
    publisher   = {Springer-Verlag New York},
    pages       = {105--147},
    year        = {1996},
    doi         = {10.1007/b97589}
}
  `)
)
