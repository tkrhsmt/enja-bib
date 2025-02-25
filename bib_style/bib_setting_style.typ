

// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// ------------------------------- JSME SETTINGS -------------------------------
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#let bib_init_style_jsme = {

  import "bib_setting_custom/bib_setting_jsme.typ": *

  let output_dict = (:)

  output_dict.insert("bib-cite", bib-cite)
  output_dict.insert("bib-citet", bib-citet)
  output_dict.insert("bib-citep", bib-citep)
  output_dict.insert("bib-citen", bib-citen)

  output_dict
}

#let bib_citet_style_jsme = {

  import "bib_setting_custom/bib_setting_jsme.typ": *

  let output_dict = (:)

  output_dict.insert("bib-citet", bib-citet)

  output_dict
}

#let bib_citep_style_jsme = {

  import "bib_setting_custom/bib_setting_jsme.typ": *

  let output_dict = (:)

  output_dict.insert("bib-citep", bib-citep)

  output_dict
}

#let bib_citen_style_jsme = {

  import "bib_setting_custom/bib_setting_jsme.typ": *

  let output_dict = (:)

  output_dict.insert("bib-citen", bib-citen)

  output_dict
}

#let bib_bibliography-list_style_jsme = {

  import "bib_setting_custom/bib_setting_jsme.typ": *

  let output_dict = (:)

  output_dict.insert("year-doubling", year-doubling)
  output_dict.insert("bib-sort", bib-sort)
  output_dict.insert("bib-sort-ref", bib-sort-ref)
  output_dict.insert("bib-full", bib-full)
  output_dict.insert("bib-vancouver", bib-vancouver)
  output_dict.insert("vancouver_style", vancouver_style)
  output_dict.insert("bib-year-doubling", bib-year-doubling)
  output_dict.insert("bib-vancouver-manual", bib-vancouver-manual)

  output_dict
}

#let bib_tex_style_jsme = {

  import "bib_setting_custom/bib_setting_jsme.typ": *

  let output_dict = (:)

  output_dict.insert("bibtex-article-en", bibtex-article-en)
  output_dict.insert("bibtex-article-ja", bibtex-article-ja)
  output_dict.insert("bibtex-book-en", bibtex-book-en)
  output_dict.insert("bibtex-book-ja", bibtex-book-ja)
  output_dict.insert("bibtex-booklet-en", bibtex-booklet-en)
  output_dict.insert("bibtex-booklet-ja", bibtex-booklet-ja)
  output_dict.insert("bibtex-inbook-en", bibtex-inbook-en)
  output_dict.insert("bibtex-inbook-ja", bibtex-inbook-ja)
  output_dict.insert("bibtex-incollection-en", bibtex-incollection-en)
  output_dict.insert("bibtex-incollection-ja", bibtex-incollection-ja)
  output_dict.insert("bibtex-inproceedings-en", bibtex-inproceedings-en)
  output_dict.insert("bibtex-inproceedings-ja", bibtex-inproceedings-ja)
  output_dict.insert("bibtex-conference-en", bibtex-conference-en)
  output_dict.insert("bibtex-conference-ja", bibtex-conference-ja)
  output_dict.insert("bibtex-manual-en", bibtex-manual-en)
  output_dict.insert("bibtex-manual-ja", bibtex-manual-ja)
  output_dict.insert("bibtex-mastersthesis-en", bibtex-mastersthesis-en)
  output_dict.insert("bibtex-mastersthesis-ja", bibtex-mastersthesis-ja)
  output_dict.insert("bibtex-misc-en", bibtex-misc-en)
  output_dict.insert("bibtex-misc-ja", bibtex-misc-ja)
  output_dict.insert("bibtex-online-en", bibtex-online-en)
  output_dict.insert("bibtex-online-ja", bibtex-online-ja)
  output_dict.insert("bibtex-phdthesis-en", bibtex-phdthesis-en)
  output_dict.insert("bibtex-phdthesis-ja", bibtex-phdthesis-ja)
  output_dict.insert("bibtex-proceedings-en", bibtex-proceedings-en)
  output_dict.insert("bibtex-proceedings-ja", bibtex-proceedings-ja)
  output_dict.insert("bibtex-techreport-en", bibtex-techreport-en)
  output_dict.insert("bibtex-techreport-ja", bibtex-techreport-ja)
  output_dict.insert("bibtex-unpublished-en", bibtex-unpublished-en)
  output_dict.insert("bibtex-unpublished-ja", bibtex-unpublished-ja)
  output_dict.insert("bib-cite-author", bib-cite-author)
  output_dict.insert("bib-cite-year", bib-cite-year)

  output_dict
}
