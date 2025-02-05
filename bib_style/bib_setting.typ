
// 著者・年が同じ文献がある場合に番号を付与するため，その番号を付与する位置を指定する特殊文字列
// !! この変数はbib_tex.typで使用されているため，変数名を変更しないように注意 !!
#let year-doubling = "%year-doubling"


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

#let remove-space(text) = {
  let output_str = remove-space-l(text)
  output_str = remove-space-r(output_str)
  return output_str
}

#let all_return(biblist, name) = {
  return biblist.at(name).sum()
}

#let author-en(biblist, name) = {
  let author_str = biblist.at(name).sum()
  let author_arr = author_str.split("and")
  let author_arr2 = ()
  for value in author_arr{
    let arr = value.split(",")
    for num in range(arr.len()){
      arr.at(num) = remove-space(arr.at(num))
    }
    author_str = arr.at(0)
    if arr.len() > 1{
      arr = arr.at(1).split(" ")
      arr.insert(0, author_str)
    }
    author_arr2.push(arr)
  }
  //リストの完成

  author_arr = ()
  author_str = ""
  for value in author_arr2{
    let an_author = value
    let author_first = an_author.remove(0)
    if author_first.len() != 0{
      author_str = upper(author_first.at(0))
      if author_first.len() > 1{
        author_str += lower(author_first.slice(1))
      }
    }
    for value in an_author{
      author_str += " "
      if value.len() != 0{
        author_str += upper(value.at(0)) + "."
      }
    }
    author_arr.push(author_str)
  }

  return author_arr.join(", ", last: " and ")
}

#let set-url(biblist, name) = {

  if biblist.at("url", default: none) != none{//urlがある場合
    let url = biblist.at("url").sum()
    if type(url) == content{
      url = contents-to-str(url)
    }
    return link(url, biblist.at(name).sum())
  }
  else{//urlがない場合
    return biblist.at(name).sum()
  }

}

#let page(biblist, name) = {
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


#let bibtex-article-author-en = (none,"",author-en, "", ", ", (), ".")

#let bibtex-article-title-en = (none,"",all_return, "", ", ", (), ".")

#let bibtex-article-journal-en = (none,"",set-url, "", ", ", (), ".")

#let bibtex-article-year-en = (" ","(",all_return, "%year-doubling)", ", ", ("author","title","journal"), "%year-doubling).")

#let bibtex-article-volume-en = (none,"Vol.~",all_return, "", ", ", (), ".")

#let bibtex-article-number-en = (none,"No.~",all_return, "", ", ", (), ".")

#let bibtex-article-pages-en = (none,"",page, "", ", ", (), ".")

#let bibtex-article-note-en = (none,"",all_return, "", ", ", (), ".")


// articleの要素を表示する順に並べる
// !! この変数はbib_tex.typで使用されているため，変数名を変更しないように注意 !!
#let bibtex-article-en = (
  ("author", bibtex-article-author-en),
  ("title", bibtex-article-title-en),
  ("journal", bibtex-article-journal-en),
  ("year", bibtex-article-year-en),
  ("volume", bibtex-article-volume-en),
  ("number", bibtex-article-number-en),
  ("pages", bibtex-article-pages-en),
  ("note", bibtex-article-note-en)
)
