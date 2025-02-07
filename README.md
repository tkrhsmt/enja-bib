# typst-BibTeX-jp
日本語／英語文献 Typstパッケージ

![test_image](/test_image.png)

## 本パッケージの特徴

- 日本語文献と英語文献が混在した文書に対応
    - 日本語文献と英語文献で異なる設定が可能
    - yomiフィールドの利用で，日本語文献のアルファベット順に並び替えが可能
- typstで使用される`bibliography`関数を使用しないため，CSLファイルによる設定が不要（代わりに`bib_style/bib_setting.typ`ファイル内で設定）
- 文中のどこでも引用が可能（`citet`，`citep`関数が利用可能）
- 「アルファベット順並び替え／リスト順」「引用文献のみ／全て表示」「バンクーバー／ハーバード方式表示」の切り替えが可能

> デフォルトで設定されている `bib_setting.typ` は，日本機械学会の原稿テンプレートに沿っています．
> しかし`bib_setting.typ`を書き換えることで，ほとんどの学会の文献形式に変更できるはずです．


## パッケージの使い方

1. `bib_style`フォルダを自分のディレクトリにコピー
1. 自分のtypstファイルの最初の方に以下を追記
    ```typst
    #import "bib_style/bib_style.typ": *
    #show: bib_init
    ```
1. 自分のtypstファイルの中で文献を挿入したい部分に，`bibliography-list`関数を利用して文献を書く
    ```typst
    #bibliography-list(
        bib-tex[
            ...
        ],
        bib-tex[
            ...
        ], ...
    )
    ```

## それぞれの関数の使い方

### `bibliography-list`関数

この関数の中に，`bib-tex`関数を入れる．
それぞれの文献ごとにカンマで区切ること．

任意引数
- `lang` : 文献のheadingの言語（`"ja"`：日本語，`"en"`：英語，`none`：表示しない），デフォルトは日本語

### `bib-tex`関数

この中にBibTeXを入れる

例：
```typst
#bibliography-list(
    bib-tex[
        @article{Reynolds:PhilTransRoySoc1883,
            author  = {Reynolds, Osborne},
            title   = {An experimental investigation of the circumstances which determine whether the motion of water shall be direct or sinuous, and of the law of resistance in parallel channels},
            journal = {Philosophical Transactions of the Royal Society of London},
            volume  = {174},
            number  = {},
            pages   = {935--982},
            year    = {1883},
            doi     = {10.1098/rstl.1883.0029},
            url     = {https://royalsocietypublishing.org/doi/abs/10.1098/rstl.1883.0029}
        }
    ]
)
```

任意引数
- `lang` : 文献の言語（`"ja"`：日本語，`"en"`：英語，`auto`：自動判別），デフォルトは`auto`

### `bib-item`関数

`bib-tex`関数の代わりに，文献を直書きする

例：
```typst
bib-item(
    label: <Reynolds:PhilTransRoySoc1883>,
    author: "Reynolds",
    year: "1883",
    yomi: "reynolds, o.",
    (
        [Reynolds, O., An experimental investigation of the circumstances which determine whether the motion of water shall be direct or sinuous, and of the law of resistance in parallel channels, Philosophical Transactions of the Royal Society of London (1883],
        [), Vol. 174, pp. 935–982]
    )
)
```

引数
- `label` : ラベル（引用する際には必須）
- `author` : 著者名（引用時・重複判別に用いられる）
- `year` : 年（引用時・重複判別に用いられる）
- `yomi` : 読み（並び替えに用いられる）

### `citet`，`citep`，`citen`関数

文中で引用するときに使用する関数．`@...`のように書いても引用できるが，
```typst
    #citet(<Reynolds:PhilTransRoySoc1883>)
```
のように書くことで引用も可能．
それぞれの関数は，複数の文献入力にも対応（例：`#citet(<Reynolds:PhilTransRoySoc1883>, <Matsukawa:ICFD2022>)`
