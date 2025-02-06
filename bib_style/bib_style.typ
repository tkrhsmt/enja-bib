
#import "bib_tex.typ": *

// --------------------------------------------------
//  INITIALIZATION
// --------------------------------------------------

#let bib-cite-turn = state("bib-cite-turn", ())
#let bib-output-list

#let bib_init(body) = {
  show ref: it =>{

      if it.has("element") and it.element != none{
        if it.element.kind == "bib"{

          let cite-arr = eval(it.element.supplement.text)

          bib-cite-turn.update(bib_info => {
            let output_arr = bib_info
            let add_num = cite-arr.at(2)
            if output_arr.contains(add_num) == false{
              output_arr.push(add_num)
            }
            output_arr
          })

          if it.supplement == [citet]{//citetのとき
            cite-arr.at(0) + " (" + cite-arr.at(1) + ")"
          }
          else if it.supplement == [citep]{//citepのとき
            "(" + cite-arr.at(0) + ", " + cite-arr.at(1) + ")"
          }
          else if it.supplement == [citet1]{//citet 2つのうち最初
            cite-arr.at(0) + " (" + cite-arr.at(1) + "); "
          }
          else if it.supplement == [citep1]{//citep 2つのうち最初
            "(" + cite-arr.at(0) + ", " + cite-arr.at(1) + "; "
          }
          else if it.supplement == [citep2]{//citep 2つのうち最後
            cite-arr.at(0) + ", " + cite-arr.at(1) + ")"
          }
          else{//その他
            "(" + cite-arr.at(0) + ", " + cite-arr.at(1) + ")"
          }

        }
        else{
          it
        }
      }
  }
  body
}



#let from_content_to_output(content_raw) = {

  let contents = content_raw.pos()

  // ----- ソートする場合 ----- //
  if bib-sort{
    let yomi_arr = ()//yomiの配列
    let num = 0//番号
    for value in contents{//各文献ごとにyomi_arrに追加
      yomi_arr.push((value.at(2), num))
      num += 1
    }
    yomi_arr = yomi_arr.sorted()//yomi_arrをソート
    let sorted_contents = ()//ソートされた文献の配列
    for value in yomi_arr{//yomi_arrの順番にcontentsをソート
      sorted_contents.push(contents.at(value.at(1)))
    }
    contents = sorted_contents//contentsをソートされたものに変更
  }


  for value in range(contents.len()){
    contents.at(value).push(value)
  }

  // ----- bib-cite-turn に文献を代入 ----- //

  bib-cite-turn.update(bib_info => {
    let output_arr = bib_info
    if output_arr == (){
      output_arr = range(contents.len())
    }
    output_arr
  })

  bib-cite-turn.update(bib_info => {
    let output_arr = ()

    if bib-sort-ref{//引用された順番に文献を出力
      for value in bib_info{
        output_arr.push(contents.at(value))
      }
    }
    else{
      for value in range(contents.len()){
        output_arr.push(contents.at(value))
      }
    }

    if bib-full{//全文献を出力
      let num = 0
      for value in contents{
        if bib_info.contains(num) == false{
          output_arr.push(value)
        }
        num += 1
      }
    }

    output_arr
  })

  // ----- 出力 ----- //


  bib-cite-turn.update(bib_info => {
    let num = 0
    let output_content = ()

    if vancouver_style{
      for value in bib_info{
        let cite-arr = value.at(1)
        cite-arr.push(value.at(4))
        output_content.push([+ #figure(value.at(0).sum().sum(), kind: "bib", supplement: [#cite-arr])#value.at(3)\ ])
      }
    }
    else{
      let num = 0
      let bibnum = bib_info.len()
      for value in bib_info{
        let cite-arr = value.at(1)
        cite-arr.push(value.at(4))
        output_content.push([#figure(value.at(0).sum().sum(), kind: "bib", supplement: [#cite-arr])#value.at(3)])

        if num != bibnum - 1{
          output_content.push(linebreak())
        }

        num += 1
      }
    }
    output_content
  }
  )

  if vancouver_style{
    set enum(numbering: bib-vancouver)
    context bib-cite-turn.get().sum()
  }
  else{
    set par(hanging-indent: 2em)
    context bib-cite-turn.final().sum()
  }


}

// --------------------------------------------------
//  MAIN FUNCTION
// --------------------------------------------------

//メイン関数
#let bibliography-list(lang: "jp", ..body) = {

  if lang == "jp"{
    heading("文　　　献", numbering: none)
  }
  else if lang == "en"{
    heading("References", numbering: none)
  }
  set par(first-line-indent: 0em)
  set par(leading: 1em)

  show figure.where(kind: "bib"): it =>{
    align(left, it)
    v(-2em)
  }

  let bib_content = body
  from_content_to_output(bib_content)
}

// ---------- 文献形式に出力する関数 ---------- //
#let bib-tex(it, lang: auto) = {
  let dict = bibtex_to_dict(it)
  let dict = add_dict_lang(dict, lang)

  let output_arr = ()
  output_arr.push(bibtex-to-bib(dict, get_element_function(dict)))
  output_arr.push(bibtex-to-cite(dict))
  output_arr.push(bibtex-yomi(dict))
  output_arr.push(dict.label)

  return output_arr
}

// --------------------------------------------------
//  CITE FUNCTION
// --------------------------------------------------

#let citet(label) = {
    ref(label, supplement: "citet")
}

#let citep(label) = {
    ref(label, supplement: "citep")
}

#let citet2(label1, label2) = {
    let tmp1 = ref(label1, supplement: "citet1")
    let tmp2 = ref(label2, supplement: "citet")
    tmp1 + tmp2
}

#let citep2(label1, label2) = {
    let tmp1 = ref(label1, supplement: "citep1")
    let tmp2 = ref(label2, supplement: "citep2")
    tmp1 + tmp2
}
