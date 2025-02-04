#let test = [
  @article{室田:2003,
      author={室田, 知也},
      title={エネルギー伝達の局所スケール間平衡近似から導出されたダイナミック渦粘性モデル},
      journal={理論応用力学講演会 講演論文集},
      publisher={日本学術会議 「機械工学委員会・土木工学・建築学委員会合同IUTAM分科会」},
      year={2003},
      volume={52},
      pages={430},
      DOI={10.11345/japannctam.52.0.430.0},
      URL={https://cir.nii.ac.jp/crid/1390282680565636864},
      yomi={Murota, Tomoya}
  }
]

// 文字列から，最初の{までを取り除く関数
#let remove_brace_l(text, remove_str: "{") = {

  // 出力文字列
  let output_str = ""
  // {で分割
  output_str = text.split(remove_str)
  // 最初の要素を削除
  output_str.remove(0)
  // 最初の{以降を返す
  return output_str.sum()
}

// 文字列から，最後の}までを取り入れる関数
#let remove_brace_r(text, remove_str: "}") = {

  // 出力文字列
  let output_str = ""
  // {で分割
  output_str = text.split(remove_str)
  // 最初の要素のみを返す
  return output_str.at(0)
}


#let bibtex_to_dict(bibtex) = {

  // dictionaryの作成
  let biblist = (empty : "empty")
  let brace = false
  let label_input = false
  let label_name = ""
  let contents = ()
  let contents_name = ""
  let remove_str = "{"

  for value in bibtex.children{

    if value.has("target"){//ターゲットの種類
      biblist.insert("target", str(value.target))
      label_input = true
    }
    else if value.has("text"){//テキストの場合

      if brace == false or label_input{
        if value.text.contains(("{")){//{が含まれている場合
          let tmp = value.text
          tmp = remove_brace_l(tmp)

          if value.text.contains(("}")){//{と}の両方が含まれている場合
            tmp = remove_brace_r(tmp)
            biblist.insert(contents_name, (tmp, ))
          }
          else{//{のみが含まれている場合
            if label_input{
              label_name += tmp
            }
            else{
              brace = true
              contents = (tmp, )
            }
          }
        }
        else{
          if label_input{
            if value.text.contains(","){
              label_input = false
              label_name += value.text.replace(",", "")
              biblist.insert("label", label(label_name))
            }
            else{
              label_name += value.text
            }
          }
          else if value != [=] {
            contents_name = value.text
          }
        }
      }
      else {
        if value.text.contains(("}")){//}のみが含まれている場合
          brace = false
          let tmp = value.text
          tmp = remove_brace_r(tmp)
          contents.push(tmp)
          biblist.insert(contents_name, contents)
        }
        else{//{と}が含まれていない場合
          contents.push(value.text)
        }
      }
    }
    else if brace{
      if value.has("dest"){
        contents.push(value.dest)
      }
      else{
        if value == smartquote(double: true){
          biblist.insert(contents_name, contents)
          brace = false
        }
        else{
          contents.push(value)
        }
      }

    }
    else if value != [ ]{
      if value == smartquote(double: true){
        brace = true
      }
    }
  }


  let a = biblist.remove("empty")

  biblist
}

#bibtex_to_dict(test)
