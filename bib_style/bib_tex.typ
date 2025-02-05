
#import "bib_setting.typ": *

//---------- 文字列から，最初の{までを取り除く関数 ---------- //
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

//---------- 文字列から，最後の}までを取り入れる関数 ---------- //
#let remove_brace_r(text, remove_str: "}") = {

  // 出力文字列
  let output_str = ""
  // {で分割
  output_str = text.split(remove_str)
  // 最初の要素のみを返す
  return output_str.at(0)
}

//---------- 文字列の一部から，ラベル名を取得する関数 ---------- //
#let text_to_label(bib_text) = {

  // 出力文字列
  let output_str = ""
  // 出力bool
  let output_bool = true

  if bib_text.contains("{") {//文字列に{が含まれる場合
    // {を削除した文字列を取得
    output_str = remove_brace_l(bib_text)
  }
  else {
    // {が含まれない場合，そのまま代入
    output_str = bib_text
  }

  if output_str.contains(",") {//出力文字列に,が含まれる場合
    // ,で分割し，最初の要素を取得
    output_str = output_str.split(",").at(0)
    // ラベル名を全て取得完了
    output_bool = false
  }

  return (output_str, output_bool)

}

//---------- 文字列の一部から，辞書型に変換する関数 ---------- //

#let text_to_dict(bib_text, contents_num, brace_num) = {

  let name_list = ()//名前のリスト
  let contents = ()//内容のリスト
  let tmp_str = ""//一時保存用
  let num = contents_num//現在の位置
  let num_list = (num,)//位置のリスト

  for value in bib_text{//一文字ずつ取得

    if num == 1{//位置が1のとき
      if value == "=" {//=のとき，名前が全て取得完了
        name_list.push(tmp_str)
        tmp_str = ""
        num = 2//位置を2に変更
        num_list.push(num)
      }
      else{//それ以外のとき，名前を追加
        tmp_str += value
      }
    }
    else if num == 2{//位置が2のとき
      if value == "{"{//{のとき，位置を3に変更
        num = 3
        num_list.push(num)
      }
    }
    else if num == 3{//位置が3のとき
      if value == "}" and brace_num == 1{//}かつ外側の括弧であるとき
        contents.push(tmp_str)
        tmp_str = ""
        num = 4//位置を4に変更
        num_list.push(num)
      }
      else{//それ以外のとき
        if value == "{"{//{のとき，これ以降は括弧の内側となる
          brace_num += 1
        }
        else if value == "}"{//}のとき，これ以降は括弧の外側となる
          brace_num -= 1
        }
        tmp_str += value//文字列の追加
      }
    }
    else if num == 4{//位置が4のとき
      if value == ","{// ,のとき，位置を1に変更
        num = 1
        num_list.push(num)
      }
    }
  }

  if tmp_str != ""{//最後の文字列を追加
    if num == 3{//位置が3のとき，contentsに追加
      contents.push(tmp_str)
    }
    else if num == 1{//位置が1のとき，name_listに追加
      name_list.push(tmp_str)
    }
  }

  return (name_list, contents, num, num_list, brace_num)
}

//---------- bibtexの文字列から辞書型を返す関数 ---------- //

#let bibtex_to_dict(bibtex) = {

  // dictionaryの作成
  let biblist = (empty : "empty")
  let contents_num = -1 //現在の位置(-1: ラベル前, 0: ラベル取得位置,
                        // hoge = { hoge } ,
                        //1      2 3      4
  let label_name = "" // ラベル名
  let contents = () // 項目の一時保存
  let contents_list = () // 項目のリスト
  let contents_name = ""
  let brace_num = 1//括弧の数

  for value in bibtex.children{

    if value.has("target"){//ターゲットの種類
      biblist.insert("target", str(value.target))
      contents_num = 0
    }
    else if value.has("text"){//テキストの場合

      if contents_num == 0 {//ラベルを取得する場合
        //ラベル名の取得
        contents = text_to_label(value.text)
        //ラベル名の代入
        label_name += contents.at(0)
        if contents.at(1) == false {//ラベル名を全て取得できたかどうか (未: true, 済: false)
          contents_num = 1
        }

        if contents_num == 1 {//ラベル名を全て取得できた場合，ラベルをbiblistに代入
          biblist.insert("label", label(label_name))
        }
      }
      else{//ラベル以外の場合
        contents = text_to_dict(value.text, contents_num, brace_num)//辞書型に変換

        for value_num in contents.at(3){//辞書へ順番に代入

          if value_num == 1 and contents.at(0) != (){//1のとき，名前を代入
            contents_name += contents.at(0).remove(0)
          }
          else if value_num == 2{//2のとき，括弧をリセットする
            brace_num = 1
          }
          else if value_num == 3 and contents.at(1) != (){//3のとき，内容を代入
            contents_list.push(contents.at(1).remove(0))
          }
          else if value_num == 4 and contents_name != "" and contents_list != (){//4のとき，項目を辞書に追加
            biblist.insert(lower(contents_name), contents_list)
            contents_name = ""
            contents_list = ()
          }
        }
        // 次の位置へ
        contents_num = contents.at(2)
        brace_num = contents.at(4)
      }
    }
    else if value == smartquote(double: true){//ダブルクォートの場合，{や}と同様にcontents_numを変更
        if contents_num == 2{
          contents_num = 3
        }
        else if contents_num == 3{
          contents_num = 4
        }
    }
    else if contents_num == 3{//括弧の内側の場合，contents_listに追加
      if value.has("dest"){//URLなどは，その中身の文字列を取得
        contents_list.push(value.dest)
      }
      else{//それ以外の場合，そのまま追加
        contents_list.push(value)
      }
    }
  }
  biblist.remove("empty")

  return biblist
}
