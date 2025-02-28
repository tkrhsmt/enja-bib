#import "bib_style/lib.typ": *

#import bib_setting_jsme: *

#show: bib_init

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
