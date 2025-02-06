#import "bib_style/bib_style.typ": *

#show: bib_init

#citet(<Lozano:2022>)

#citet(<ahrendt-1951>)

#set text(font: ("Times New Roman", "Harano Aji Mincho"))
#bibliography-list(
  bib-tex[
  @article{Lozano:2022,
        title = {information-theoretic formulation of dynamical systems: Causality, modeling, and control},
        author = {Lozano-{Durán}, Adrián and Arranz, Gonzalo},
        journal = {Physical Review Research},
        volume = {4},
        issue = {2},
        note = {023195},
        numpages = {24},
        year = {2022},
        month = {Jun},
        publisher = {American Physical Society},
        doi = {10.1103/PhysRevResearch.4.023195},
        url = {https://link.aps.org/doi/10.1103/PhysRevResearch.4.023195}
      }
  ],
  bib-tex[
  @book{ahrendt-1951,
      title     ={Automatic Feedback Control},
      author    ={Ahrendt, William Robert and Taplin, John Ferguson},
      year      ={1951},
      publisher ={McGraw-Hill},
      language  ={English},
      url       ={https://nla.gov.au/nla.cat-vn2276067},
    }
  ]
)
