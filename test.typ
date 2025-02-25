#import "bib_style/bib_style.typ": *

//#show: bib_init

// JSME 用のスタイル設定
#show: bib_init.with(..bib_init_style_jsme)
#let citet = citet.with(..bib_citet_style_jsme)
#let citep = citep.with(..bib_citep_style_jsme)
#let citen = citen.with(..bib_citen_style_jsme)
#let bibliography-list = bibliography-list.with(..bib_bibliography-list_style_jsme)
#let bib-file = bib-file.with(..bib_tex_style_jsme)
#let bib-tex = bib-tex.with(..bib_tex_style_jsme)

#set text(font: ("Times New Roman", "Harano Aji Mincho"))

#heading(numbering: none)[引用例]

+ @Reynolds:PhilTransRoySoc1883
+ #citet(<Matsukawa:ICFD2022>)
+ #citep(<Matsukawa:ICFD2022>)
+ #citen(<Matsukawa:ICFD2022>)
+ @Reynolds:PhilTransRoySoc1883[Manual String]

#bibliography-list(
  ..bib-file(include "mybib_jp.bib"),
  ..bib-file(include "mybib_en.bib")
)
