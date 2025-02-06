
#import "bib_tex.typ": *

// --------------------------------------------------
//  MAIN FUNCTION
// --------------------------------------------------

//メイン関数


// ---------- 文献形式に出力する関数 ---------- //
#let bib-tex(it, lang: auto) = {
  let dict = bibtex_to_dict(it)
  let dict = add_dict_lang(dict, lang)
  //bibtex-to-bib(dict)
  bibtex-to-bib(dict, get_element_function(dict)).sum().sum()
  let cite_arr = bibtex-to-cite(dict)
  linebreak()
  linebreak()
  cite_arr.at(0).sum().sum()
}
