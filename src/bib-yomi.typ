#import "@preview/auto-jrubby:0.3.4": tokenize

#let kana = (
  // 拗音を先に処理
  "キャ": "Kya",
  "キュ": "Kyu",
  "キョ": "Kyo",
  "ギャ": "Gya",
  "ギュ": "Gyu",
  "ギョ": "Gyo",
  "シャ": "Sha",
  "シュ": "Shu",
  "ショ": "Sho",
  "ジャ": "Ja",
  "ジュ": "Ju",
  "ジョ": "Jo",
  "チャ": "Cha",
  "チュ": "Chu",
  "チョ": "Cho",
  "ニャ": "Nya",
  "ニュ": "Nyu",
  "ニョ": "Nyo",
  "ヒャ": "Hya",
  "ヒュ": "Hyu",
  "ヒョ": "Hyo",
  "ビャ": "Bya",
  "ビュ": "Byu",
  "ビョ": "Byo",
  "ピャ": "Pya",
  "ピュ": "Pyu",
  "ピョ": "Pyo",
  "ミャ": "Mya",
  "ミュ": "Myu",
  "ミョ": "Myo",
  "リャ": "Rya",
  "リュ": "Ryu",
  "リョ": "Ryo",

  // 特殊な拗音
  "ティ": "Ti",
  "ディ": "Di",
  "トゥ": "Tu",
  "ドゥ": "Du",
  "ファ": "Fa",
  "フィ": "Fi",
  "フェ": "Fe",
  "フォ": "Fo",
  "ウィ": "Wi",
  "ウェ": "We",
  "ウォ": "Wo",
  "ヴァ": "Va",
  "ヴィ": "Vi",
  "ヴェ": "Ve",
  "ヴォ": "Vo",

  // 清音
  "ア": "A",
  "イ": "I",
  "ウ": "U",
  "エ": "E",
  "オ": "O",
  "カ": "Ka",
  "キ": "Ki",
  "ク": "Ku",
  "ケ": "Ke",
  "コ": "Ko",
  "サ": "Sa",
  "シ": "Shi",
  "ス": "Su",
  "セ": "Se",
  "ソ": "So",
  "タ": "Ta",
  "チ": "Chi",
  "ツ": "Tsu",
  "テ": "Te",
  "ト": "To",
  "ナ": "Na",
  "ニ": "Ni",
  "ヌ": "Nu",
  "ネ": "Ne",
  "ノ": "No",
  "ハ": "Ha",
  "ヒ": "Hi",
  "フ": "Fu",
  "ヘ": "He",
  "ホ": "Ho",
  "マ": "Ma",
  "ミ": "Mi",
  "ム": "Mu",
  "メ": "Me",
  "モ": "Mo",
  "ヤ": "Ya",
  "ユ": "Yu",
  "ヨ": "Yo",
  "ラ": "Ra",
  "リ": "Ri",
  "ル": "Ru",
  "レ": "Re",
  "ロ": "Ro",
  "ワ": "Wa",
  "ヲ": "Wo",

  // 濁音
  "ガ": "Ga",
  "ギ": "Gi",
  "グ": "Gu",
  "ゲ": "Ge",
  "ゴ": "Go",
  "ザ": "Za",
  "ジ": "Ji",
  "ズ": "Zu",
  "ゼ": "Ze",
  "ゾ": "Zo",
  "ダ": "Da",
  "ヂ": "Ji",
  "ヅ": "Zu",
  "デ": "De",
  "ド": "Do",
  "バ": "Ba",
  "ビ": "Bi",
  "ブ": "Bu",
  "ベ": "Be",
  "ボ": "Bo",

  // 半濁音
  "パ": "Pa",
  "ピ": "Pi",
  "プ": "Pu",
  "ペ": "Pe",
  "ポ": "Po",

  // 小書き母音
  "ァ": "a",
  "ィ": "i",
  "ゥ": "u",
  "ェ": "e",
  "ォ": "o",

  // その他
  "ヮ": "wa",
)

#let romaji(text) = {
  let result = text

  // 長音記号はそのまま扱う。
  // 「トウ」→ Tou のように、仮名「ウ」は通常通り U になる。
  result = result.replace("ー", "-")

  // 拗音など、2文字以上の組み合わせを先に置換
  for pair in kana.pairs() {
    result = result.replace(pair.at(0), pair.at(1))
  }

  // 促音「ッ」の処理
  // 直後のローマ字の先頭子音を重ねる。
  result = result.replace(regex("ッ([KSTCPFBGHJMR])"), m => {
    let c = m.captures.at(0)
    c + c
  })

  // 残った「ッ」
  result = result.replace("ッ", "")

  // ン
  result = result.replace("ン", "N")

  // 長音記号
  result = result.replace("-", "")

  lower(result)
}

#let auto-make-yomi(biblist, bib_str) = {
  if biblist.fields.lang == "ja" {
    let name = biblist.parsed_names.values().sum().map(x => x.at("family") + x.at("given")).join(",")
    let ruby-table = tokenize(name).map(x => x.details)
    let ruby = ()
    for val in ruby-table {
      if val.len() == 9 {
        ruby.push(val.at(8))
      }
    }
    return romaji(ruby.join(","))
  } else {
    return bib_str
  }
}
