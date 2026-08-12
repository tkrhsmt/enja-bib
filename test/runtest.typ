#import "../src/bib-setting-function.typ": *
#import "../src/bib-tex.typ": *
#import "../src/bib-style.typ": *

// content 型と文字列を同じ方法で比較するための補助関数。
#let text-of(value) = if type(value) == str { value } else { contents-to-str(value) }

// 著者整形テストで共通利用する入力データ。prefix / suffix と複数著者を含める。
#let english-names = (
  (family: "Smith", given: "john paul", prefix: "de", suffix: "Jr"),
  (family: "Jones", given: "amy", prefix: "", suffix: ""),
  (family: "Brown", given: "bob", prefix: "", suffix: ""),
)

// 日本語の姓名と、引用時の「他」表記を確認するための入力データ。
#let japanese-names = (
  (family: "山田", given: "太郎", prefix: "", suffix: ""),
  (family: "佐藤", given: "花子", prefix: "", suffix: ""),
  (family: "鈴木", given: "次郎", prefix: "", suffix: ""),
)

// citegeist が返す文献辞書を模した、最小の英語・日本語 BibTeX エントリ。
#let english-bib(fields: (:), names: english-names) = (
  fields: (lang: "en", author: "John Smith", title: "Title", pages: "12-18", ..fields),
  parsed_names: (author: names),
)

#let japanese-bib(names: japanese-names) = (
  fields: (lang: "ja", author: "山田 太郎", title: "題名", pages: "12-18"),
  parsed_names: (author: names),
)

// ---------------------------------------------------------------------------
// bib-setting-function.typ: content・文字列・フィールド整形
// ---------------------------------------------------------------------------

#let test-contents-to-str() = {
  // 通常のテキスト、子 content、空 content の各経路を確認する。
  assert(contents-to-str([hello world]) == "hello world")
  assert(contents-to-str([hello #emph[world]]) == "hello world")
  assert(contents-to-str([ ]) == " ")
}

#let test-space-functions() = {
  // 空白あり・なしを両端それぞれで確認する。
  assert(remove-space-l("  text ") == "text ")
  assert(remove-space-l("text") == "text")
  assert(remove-space-r(" text  ") == " text")
  assert(remove-space-r("text") == "text")
  assert(remove-space("  text  ") == "text")
}

#let test-field-formatters() = {
  let bib = english-bib(fields: (url: "https://example.com", doi: "doi:example"))
  assert(all-return(bib, "title") == "Title")
  assert(all-return(bib, "missing") == "")
  assert(text-of(all-bold(bib, "title")) == "Title")
  assert(text-of(all-emph(bib, "title")) == "Title")
  // URL 優先、DOI、リンクなしの順にフォールバックする。
  assert(text-of(set-url(bib, "title")) == "Title")
  assert(text-of(set-url(english-bib(fields: (doi: "doi:example")), "title")) == "Title")
  assert(set-url(english-bib(), "title") == "Title")
  // ページ範囲（ハイフン2種）と単ページを確認する。
  assert(page-set(english-bib(), "pages") == "pp.~12--18")
  assert(page-set(english-bib(fields: (pages: "12–18")), "pages") == "pp.~12–18")
  assert(page-set(english-bib(fields: (pages: "12")), "pages") == "p.~12")
  assert(page-set-without-p(english-bib(), "pages") == "12--18")
  assert(page-set-without-p(english-bib(fields: (pages: "12–18")), "pages") == "12–18")
  assert(page-set-without-p(english-bib(fields: (pages: "12")), "pages") == "12")
}

#let test-author-formatters() = {
  let author = english-names.at(0)
  assert(author-en(author) == "de Smith J. P. Jr")
  assert(author-en2(author) == "de Smith")
  assert(author-en3(author) == "de Smith J J")
  assert(author-en4(author) == "de john paul Smith Jr")
  assert(author-ja(japanese-names.at(0)) == "山田太郎")
  assert(author-set(english-bib(), "author") == "de Smith J. P. Jr, Jones A. and Brown B.")
  assert(author-set2(english-bib(), "author") == "de Smith J J, Jones A and Brown B")
  assert(author-set3(english-bib(), "author") == "de john paul Smith Jr, amy Jones and bob Brown")
  assert(author-set(japanese-bib(), "author") == "山田太郎, 佐藤花子, 鈴木次郎")
  // 引用用表記は、英日それぞれで1名・2名・3名以上を確認する。
  assert(author-set-cite(english-bib(names: english-names.slice(0, 1)), "author") == "de Smith")
  assert(author-set-cite(english-bib(names: english-names.slice(0, 2)), "author") == "de Smith and Jones")
  assert(author-set-cite(english-bib(), "author") == "de Smith et al.")
  assert(author-set-cite(japanese-bib(names: japanese-names.slice(0, 1)), "author") == "山田")
  assert(author-set-cite(japanese-bib(names: japanese-names.slice(0, 2)), "author") == "山田, 佐藤")
  assert(author-set-cite(japanese-bib(), "author") == "山田他")
  assert(author-set-cite(english-bib(), "missing") != "missing")
}

#let test-citation-formatters() = {
  // cite-arr: (著者, 年, 文献番号, 文献全体) は bib-style.typ の内部形式。
  let cite = ("Smith", "2024", 7, [Full entry])
  assert(bib-citet-default(cite) != none)
  assert(bib-citep-default(cite) != none)
  assert(bib-citen-default(cite) == "7")
  assert(text-of(bib-citefull-default(cite)) == "Full entry")
  assert(bib-cite-authoronly(cite) == "Smith")
  assert(bib-cite-yearonly(cite) == "2024")
}

#let test-vancouver-manual() = {
  // 英語・日本語、複数著者、年の欠損を確認する。
  assert(bib-vancouver-manual-default(("Smith", "2024")) == "[Smi24]")
  assert(bib-vancouver-manual-default(("Smith and Jones", "2024")) == "[SJ24]")
  assert(bib-vancouver-manual-default(("Smith et al.", "")) == "[Smi+??]")
  assert(bib-vancouver-manual-default(("山田, 佐藤", "2024")) == "[山佐24]")
  assert(bib-vancouver-manual-default(("山田他", "2024")) == "[山+24]")
  assert(bib-vancouver-manual-default((none, "")) == "[????]")
}

// ---------------------------------------------------------------------------
// bib-tex.typ: 言語判定・BibTeX 変換
// ---------------------------------------------------------------------------

#let test-language-and-conversion-helpers() = {
  // 日本語の自動判定と、既存 lang を上書きしないことを確認する。
  assert(check-japanese-tex-str("日本語"))
  assert(not check-japanese-tex-str("English"))
  assert(check-japanese-tex((title: "日本語", year: "2024")))
  assert(not check-japanese-tex((title: "English", year: "2024")))
  assert(add-dict-lang((fields: (title: "日本語")), auto).fields.lang == "ja")
  assert(add-dict-lang((fields: (title: "English")), auto).fields.lang == "en")
  assert(add-dict-lang((fields: (lang: "ja", title: "English")), auto).fields.lang == "ja")
  assert(add-dict-lang((fields: (title: "English")), "ja").fields.lang == "ja")

  // bibtex-to-bib 用の最小スタイル。author の後に year を連結する。
  let elements = (
    ("author", (none, "", all-return, "", " ", (), "")),
    ("year", (none, "", all-return, "", "", ("author",), "")),
  )
  let bib = english-bib(fields: (author: "Smith", year: "2024"))
  assert(text-of(bibtex-to-bib("%year", bib, elements).sum().sum()) == "Smith 2024")
  assert(bibtex-to-cite(author-set-cite, all-return, bib) == ("de Smith et al.", "2024"))
  // yomi がない日本語文献では、著者名から読みを自動生成する。
  assert(bibtex-yomi(japanese-bib(), (([日本語文献],),)) == "yamada,taro,sato,hanako,suzuki,jiro")

  // 英語文献の既定値と、明示した content 型 yomi の両方を確認する。
  assert(bibtex-yomi(bib, (([Alpha],),)) == "alpha")
  assert(bibtex-yomi(english-bib(fields: (yomi: [\{Beta\}])), (([Alpha],),)) == "beta")
}

// ---------------------------------------------------------------------------
// bib-style.typ: 公開 API・スタイル適用・描画
// ---------------------------------------------------------------------------

#let test-bib-item-and-styles() = {
  // content、分割配列、文字列の各入力形式を確認する。
  let item = bib-item([Entry], author: "Author", year: "2024", label: <entry>)
  assert(text-of(item.at(0).sum().sum()) == "Entry")
  assert(item.at(1) == ("Author", "2024"))
  assert(item.at(2) == "Entry")
  assert(item.at(3) == <entry>)
  let split = bib-item(("Before", "After"), yomi: "custom")
  assert(text-of(split.at(0).sum().sum()) == "BeforeAfter")
  assert(split.at(2) == "custom")
  assert(text-of(bib-item("Text entry").at(0).sum().sum()) == "Text entry")

  // TOML 内の関数名が callable な関数へ置き換えられることを確認する。
  let style = toml("../src/bib-setting-custom/plain.toml")
  let configured = set-style(style)
  assert(type(configured.bib-init) == function)
  assert(type(configured.bib-file) == function)
  assert(type(configured.citet) == function)
  assert(get-element-function(style, (entry_type: "article", fields: (lang: "en"))) != none)
  let style-with-utils = toml("../src/bib-setting-custom/plain.toml")
  assert(type(set-style(style-with-utils, add-utils: (custom: all-return)).bib-tex) == function)
}

#let test-bibtex-integration() = {
  let style = toml("../src/bib-setting-custom/plain.toml")
  let configured = set-style(style)
  // @comment を無視し、article エントリだけを読み込む結合テスト。
  let source = "@comment{ignored}\n@article{sample, author = {John Smith}, title = {Sample Title}, journal = {Journal}, year = {2024}, pages = {1-2}}"
  let entry = (configured.bib-tex)(source)
  assert(entry.at(1) == ("Smith", "2024"))
  assert(entry.at(3) == "sample")
  assert((configured.bib-file)(source).len() == 1)
}

#let test-bibliography-rendering() = {
  // Harvard（ソート・重複年）と Vancouver manual の描画経路を実行する。
  assert(bib-init(bib-cite: ("", bib-citet-default, "; ", ""))[Text] != none)
  bibliography-list(title: none, bib-full: true, bib-sort: true,
    bib-item([Alpha], author: "Smith", year: "2024", yomi: "alpha", label: <alpha>),
    bib-item(([Beta ], [2024]), author: "Smith", year: "2024", yomi: "beta", label: <beta>),
  )
  bibliography-list(title: none, vancouver-style: true, bib-vancouver: "manual",
    bib-vancouver-manual: bib-vancouver-manual-default,
    bib-item([Gamma], author: "Smith", year: "2024", label: <gamma>),
  )
}

#let test-multiple-citations() = {
  // 単一・複数ラベルの共通処理と、引用順ソートの経路を確認する。
  let style = toml("../src/bib-setting-custom/plain.toml")
  let configured = set-style(style)
  assert((configured.bib-init)[
    #(configured.citep)(<first>, <second>)
    #(configured.bibliography-list)(title: none, bib-sort-ref: true,
      (configured.bib-item)([First], author: "First", year: "2024", label: <first>),
      (configured.bib-item)([Second], author: "Second", year: "2024", label: <second>),
    )
  ] != none)
}
