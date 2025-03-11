
// ---------- contentsをstringsに変換する関数 ---------- //
// !! この関数はbib_tex.typで使用されているため，関数名・および中身を変更しないように注意 !!
#let contents-to-str(content) = {
  let str = ""
  if content.has("text") {
    str = content.text
    str
  } else if content.has("children") {
    str = content.children.map(contents-to-str).join("")
    str
  } else if content.has("body") {
    contents-to-str(content.body)
  } else if content == [ ] {
    " "
  } else if content.has("child"){
    contents-to-str(content.child)
  }
}

// ---------- 文字列の左側のスペースを削除する関数 ---------- //
#let remove-space-l(text) = {
  let output_str = text
  for value in text{
    if value == " "{
      output_str = output_str.slice(1)
    }
    else{
      break
    }
  }
  return output_str
}

// ---------- 文字列の右側のスペースを削除する関数 ---------- //
#let remove-space-r(text) = {
  let output_str = text
  for value in text.rev(){
    if value == " "{
      output_str = output_str.slice(0,-1)
    }
    else{
      break
    }
  }
  return output_str
}

// ---------- 文字列の両側のスペースを削除する関数 ---------- //
#let remove-space(text) = {
  let output_str = remove-space-l(text)
  output_str = remove-space-r(output_str)
  return output_str
}

// ---------- 項目内をそのまま返す関数 ---------- //
#let all_return(biblist, name) = {
  return biblist.at(name, default: ("",)).sum()
}

// ---------- 項目内を太文字にして返す関数 ---------- //
#let all-bold(biblist, name) = {
  return strong(biblist.at(name).sum())
}

// ---------- 項目内を斜体にして返す関数 ---------- //
#let all-emph(biblist, name) = {
  return emph(biblist.at(name).sum())
}

// ---------- 英語の著者名(例：Reynolds, Osborne)を型(例：Reynolds O.)に変換 ---------- //
#let author-en(author_arr) = {

  let an_author = author_arr
  let author_str = ""
  let author_first = an_author.remove(0)

  if author_first.len() != 0{
    let brace_num = 0
    let num = 0
    for value in author_first{
      if value == "{"{
        brace_num += 1
      }
      else if value == "}"{
        brace_num -= 1
      }
      else{

        if value == "-"{// ハイフンの直後の文字を大文字にする
          num = -1
        }

        if brace_num == 0{
          if num == 0{
            author_str += upper(value)
          }
          else{
            author_str += lower(value)
          }
        }
        else{
          author_str += value
        }
      }
      num += 1
    }
    if an_author != (){// 著者名にカンマ以降が含まれない場合は，カンマを追加しない
      author_str += ", "
    }
  }
  for value in an_author{
    author_str += " "
    if value.len() != 0{
      author_str += upper(value.at(0)) + "."
    }
  }

  return author_str

}

// ---------- 英語の著者名(例：Reynolds, Osborne)を型(例：Reynolds)に変換 ---------- //
#let author-en2(author_arr) = {

  let an_author = author_arr
  let author_str = ""
  let author_first = an_author.remove(0)

  if author_first.len() != 0{
    let brace_num = 0
    let num = 0
    for value in author_first{
      if value == "{"{
        brace_num += 1
      }
      else if value == "}"{
        brace_num -= 1
      }
      else{

        if value == "-"{// ハイフンの直後の文字を大文字にする
          num = -1
        }

        if brace_num == 0{
          if num == 0{
            author_str += upper(value)
          }
          else{
            author_str += lower(value)
          }
        }
        else{
          author_str += value
        }
      }
      num += 1
    }
  }

  return author_str

}


// ---------- 英語の著者名(例：Reynolds, Osborne)を型(例：O Reynolds)に変換 ---------- //
#let author-en3(author_arr) = {

  let an_author = author_arr
  let author_str = ""
  let author_str2 = ""
  let author_first = an_author.remove(0)

  if author_first.len() != 0{
    let brace_num = 0
    let num = 0
    for value in author_first{
      if value == "{"{
        brace_num += 1
      }
      else if value == "}"{
        brace_num -= 1
      }
      else{

        if value == "-"{// ハイフンの直後の文字を大文字にする
          num = -1
        }

        if brace_num == 0{
          if num == 0{
            author_str += upper(value)
          }
          else{
            author_str += lower(value)
          }
        }
        else{
          author_str += value
        }
      }
      num += 1
    }
  }
  for value in an_author{
    if value.len() != 0{
      author_str2 += upper(value.at(0)) + " "
    }
  }

  return author_str2 + author_str
}


// ---------- 英語の著者名(例：Reynolds, Osborne)を型(例：Osborne Reynolds)に変換 ---------- //
#let author-en4(author_arr) = {

  let an_author = author_arr
  let author_first = an_author.remove(0)

  if author_first != ""{
    author_first = " " + author_first
  }

  return an_author.join(" ") + author_first
}

// ---------- 日本語の著者名はそのまま繋げて出力 ---------- //
#let author-ja(author_arr) = {
  return author_arr.sum()
}

// ---------- 項目を著者配列にして返す関数 ---------- //
#let author-make-arr(biblist, name) = {
  let author_str = biblist.at(name).sum()
  if type(author_str) == content{
      author_str = contents-to-str(author_str)
  }

  let author_arr = author_str.split("and")
  let author_arr2 = ()
  for value in author_arr{
    let arr = value.split(",")
    for num in range(arr.len()){
      arr.at(num) = remove-space(arr.at(num))
    }

    if arr.len() == 1{
      let arr2 = arr.at(0).split(" ")
      arr = (arr2.remove(-1), )
      if arr2 != () {
        arr.push(arr2.join(" "))
      }
      for num in range(arr.len()){
        arr.at(num) = remove-space(arr.at(num))
      }
    }

    author_str = arr.at(0)
    if arr.len() > 1{
      arr = arr.at(1).split(" ")
      arr.insert(0, author_str)
    }
    author_arr2.push(arr)
  }

  return author_arr2
}

// ---------- 項目を著者型にして返す関数 ---------- //
#let author-set(biblist, name) = {

  let author_arr = ()
  let author_arr2 = author-make-arr(biblist, name)

  for author in author_arr2{

    let authorsum = author.sum()
    let check = (regex("[\p{scx:Han}\p{scx:Hira}\p{scx:Kana}]") in authorsum)

    if check{
      author_arr.push(author-ja(author))
    }
    else{
      author_arr.push(author-en(author))
    }
  }

  if biblist.lang == "ja"{
    return author_arr.join(", ")
  }
  else{
    return author_arr.join(", ", last: " and ")
  }
}

// ---------- 項目を著者型にして返す関数(author-en3型) ---------- //
#let author-set2(biblist, name) = {

  let author_arr = ()
  let author_arr2 = author-make-arr(biblist, name)

  for author in author_arr2{

    let authorsum = author.sum()
    let check = (regex("[\p{scx:Han}\p{scx:Hira}\p{scx:Kana}]") in authorsum)

    if check{
      author_arr.push(author-ja(author))
    }
    else{
      author_arr.push(author-en3(author))
    }
  }

  if biblist.lang == "ja"{
    return author_arr.join(", ")
  }
  else{
    return author_arr.join(", ", last: " and ")
  }
}


// ---------- 項目を著者型にして返す関数(author-en4型) ---------- //
#let author-set3(biblist, name) = {

  let author_arr = ()
  let author_arr2 = author-make-arr(biblist, name)

  for author in author_arr2{

    let authorsum = author.sum()
    let check = (regex("[\p{scx:Han}\p{scx:Hira}\p{scx:Kana}]") in authorsum)

    if check{
      author_arr.push(author-ja(author))
    }
    else{
      author_arr.push(author-en4(author))
    }
  }

  if biblist.lang == "ja"{
    return author_arr.join(", ")
  }
  else{
    return author_arr.join(", ", last: " and ")
  }
}

// ---------- 項目をciteの著者型にして返す関数 ---------- //
#let author-set-cite(biblist, name) = {

  let author_str = biblist.at(name, default:("",)).sum()
  if type(author_str) == content{
      author_str = contents-to-str(author_str)
  }

  let author_arr = author_str.split("and")
  let author_arr2 = ()
  for value in author_arr{
    let arr = value.split(",")
    for num in range(arr.len()){
      arr.at(num) = remove-space(arr.at(num))
    }

    if arr.len() == 1{
      let arr2 = arr.at(0).split(" ")
      arr = (arr2.remove(-1), )
      if arr2 != () {
        arr.push(arr2.join(" "))
      }
      for num in range(arr.len()){
        arr.at(num) = remove-space(arr.at(num))
      }
    }

    author_str = arr.at(0)
    if arr.len() > 1{
      arr = arr.at(1).split(" ")
      arr.insert(0, author_str)
    }
    author_arr2.push(arr)
  }

  author_arr = ()

  for author in author_arr2{

    let authorsum = author.sum()
    let check = (regex("[\p{scx:Han}\p{scx:Hira}\p{scx:Kana}]") in authorsum)

    if check{
      author_arr.push(author.at(0))
    }
    else{
      author_arr.push(author-en2(author))
    }
  }

  if biblist.lang == "ja"{// 日本語の場合
    if author_arr.len() == 1{// 著者が1人の場合
      return author_arr.sum()
    }
    else if author_arr.len() == 2{// 著者が2人の場合
      return author_arr.join(", ")
    }
    else{// 著者が3人以上の場合
      let tmp = (author_arr.at(0), "他")
      return tmp.sum()
    }
  }
  else{// 英語の場合
    if author_arr.len() == 1{// 著者が1人の場合
      return author_arr.sum()
    }
    else if author_arr.len() == 2{// 著者が2人の場合
      return author_arr.join(" and ")
    }
    else{// 著者が3人以上の場合
      let tmp = (author_arr.at(0), " et al.")
      return tmp.sum()
    }
  }
}

// ---------- 英語のタイトルを先頭だけ大文字にしてそれ以外を小文字にして返す関数 ---------- //
#let title-en(biblist, name) = {
  let title = biblist.at(name)
  let output = ()
  let first = true
  let brace_num = 0

  for title_element in title{
    if type(title_element) == str{
      for value in title_element{
        if value == "{"{
          brace_num += 1
          first = false
        }
        else if value == "}"{
          brace_num -= 1
          first = false
        }
        else{
          if brace_num == 0{
            if first{
              output.push(upper(value))
              first = false
            }
            else{
              output.push(lower(value))
            }
          }
          else{
            output.push(value)
          }
        }
      }
    }
    else{
      output.push(title_element)
      first = false
    }
  }
  return output.sum()
}

// ---------- {と}を削除して返す関数 ---------- //
#let remove-str-brace(biblist, name) = {

  let contents = biblist.at(name)
  let output = ()

  for value in contents{
    if type(value) == str{
      output.push(value.split(regex("[{}]")).sum())
    }
    else{
      output.push(value)
    }
  }

  return output.sum()

}

// ---------- URLを付与して返す関数 ---------- //
#let set-url(biblist, name) = {

  if biblist.at("url", default: none) != none{//urlがある場合
    let url = biblist.at("url").sum()
    if type(url) == content{
      url = contents-to-str(url)
    }
    return link(url, text(fill: blue, biblist.at(name).sum()))
  }
  else if biblist.at("doi", default: none) != none{//doiがある場合
    let url = biblist.at("doi").sum()
    if type(url) == content{
      url = contents-to-str(url)
    }
    return link(url, text(fill: blue, biblist.at(name).sum()))
  }
  else{//urlがない場合
    return biblist.at(name).sum()
  }

}

// ---------- ページ形式にして返す関数 ---------- //
#let page-set(biblist, name) = {
  let pagestr = biblist.at(name).sum()
  if type(pagestr) == content{
    pagestr = contents-to-str(pagestr)
  }

  if pagestr.contains("--") or pagestr.contains("–"){
    return "pp.~" + pagestr
  }
  else if pagestr.contains("-"){
    pagestr = pagestr.replace("-", "--")
    return "pp.~" + pagestr
  }
  else{
    return "p.~" + pagestr
  }
}

// ---------- ページ形式にして返す関数(ppを表示しない) ---------- //
#let page-set-without-p(biblist, name) = {
  let pagestr = biblist.at(name).sum()
  if type(pagestr) == content{
    pagestr = contents-to-str(pagestr)
  }

  if pagestr.contains("--") or pagestr.contains("–"){
    return pagestr
  }
  else if pagestr.contains("-"){
    pagestr = pagestr.replace("-", "--")
    return pagestr
  }
  else{
    return pagestr
  }
}

// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// bib-vancouver = "manual"のときの設定関数
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#let bib-vancouver-manual-default(bib_cite_contents) = {

  let tmp = bib_cite_contents.at(0).split(regex("and|, "))
  let bib_cite_name_arr = ()
  let is_japanese = false
  for value in tmp{
    let tmp2 = remove-space(value)
    bib_cite_name_arr.push(tmp2)
    if (regex("[\p{scx:Han}\p{scx:Hira}\p{scx:Kana}]") in tmp2){
      is_japanese = true
    }
  }

  let bib_cite_name = ""

  if is_japanese{
    if (regex(".*他") in bib_cite_name_arr.at(-1)){//3人以上の場合
      bib_cite_name = bib_cite_name_arr.at(0)
      bib_cite_name = bib_cite_name.slice(0,bib_cite_name.len() - "他".len()) + [+]
    }
    else{
      bib_cite_name = bib_cite_name_arr.join()
    }
  }
  else{
    if (regex(" et al\.") in bib_cite_name_arr.at(-1)){//3人以上の場合
      bib_cite_name = bib_cite_name_arr.at(0)
      bib_cite_name = bib_cite_name.slice(0,bib_cite_name.len() - " et al.".len()) + [+]
    }
    else if bib_cite_name_arr.len() == 1{
      bib_cite_name = bib_cite_name_arr.sum()
    }
    else{
      for index in range(bib_cite_name_arr.len()){
        bib_cite_name += bib_cite_name_arr.at(index).at(0)
      }
    }
  }


  return [\[] + bib_cite_name + bib_cite_contents.at(1).slice(2,4) + [\]]
}

// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// 各引用の表示形式設定関数
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#let bib-citet-default(bib_cite_contents) = {
  return bib_cite_contents.at(0) + [~(] + bib_cite_contents.at(1) + [)]
}

#let bib-citep-default(bib_cite_contents) = {
  return bib_cite_contents.at(0) + [,~] + bib_cite_contents.at(1)
}

#let bib-citen-default(bib_cite_contents) = {
  return str(bib_cite_contents.at(2))
}
