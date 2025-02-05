
#import "bib_tex.typ": *

// --------------------------------------------------
//  MAIN FUNCTION
// --------------------------------------------------

//メイン関数


// ---------- 文献形式に出力する関数 ---------- //
#let bib-tex(it, lang: auto) = {
  let dict = bibtex_to_dict(it)
  //bibtex-to-bib(dict)
  bibtex-to-bib(dict).sum().sum()
}
