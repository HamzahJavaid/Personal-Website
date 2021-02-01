---
title: "Algorithmic Collusion Detection"
authors:
- "Matteo Courthoud"
date: "2021-02-01"
doi: ""

# Schedule page publish date (NOT publication's date).
publishDate: "2017-01-01"

# Publication type.
# Legend: 0 = Uncategorized; 1 = Conference paper; 2 = Journal article;
# 3 = Preprint / Working Paper; 4 = Report; 5 = Book; 6 = Book section;
# 7 = Thesis; 8 = Patent
publication_types: []

# Publication name and optional abbreviated publication name.
publication: ""
publication_short: ""

abstract: Reinforcement learning algorithms are gradually replacing humans in many decision making processes, such as pricing in high-frequency markets. Recent studies on algorithmic pricing have shown that algorithms can learn sophisticated grim-trigger strategies with the intent of keeping supracompetitive prices. One suggestion to detect algorithmic collusion is to look at the inputs of the dynamic strategies. In this paper, I show that this approach might not be sufficient since the algorithms can learn reward-punishment schemes that are fully independent from the rival’s actions. Moreover, I show that the crucial ingredient in algorithmic collusion is synchronous learning. When one algorithm is unilaterally retrained, it learns more competitive strategies that exploit collusive behavior. Since this change in strategies happens only when algorithms are colluding, retraining can be used as an instrument to detect algorithmic collusion. Lastly, I show how one can get the same insights on collusive behavior by retraing the algorithms on boostrapped samples of historical data.

# Summary. An optional shortened abstract.
summary: I show that algorithms can learn reward-punishment schemes that are fully independent from the rival’s actions and I propose a model-free test for algorithmic collusion based on historical data.

tags:
- Industrial Organization
- Computation
- Dynamics
featured: false

links:
url_pdf: 'files/courthoud2021algorithms.pdf'
url_code: ''
url_dataset: ''
url_poster: ''
url_project: ''
url_slides: ''
url_source: ''
url_video: ''

# Featured image
# To use, add an image named `featured.jpg/png` to your page's folder. 
image:
  caption: 'Algorithms learn self-punishment schemes to keep supracompetitive prices'
  focal_point: ""
  preview_only: false

# Associated Projects (optional).
#   Associate this publication with one or more of your projects.
#   Simply enter your project's folder or file name without extension.
#   E.g. `internal-project` references `content/project/internal-project/index.md`.
#   Otherwise, set `projects: []`.
projects:
- internal-project

# Slides (optional).
#   Associate this publication with Markdown slides.
#   Simply enter your slide deck's filename without extension.
#   E.g. `slides: "example"` references `content/slides/example/index.md`.
#   Otherwise, set `slides: ""`.
slides: example
---
