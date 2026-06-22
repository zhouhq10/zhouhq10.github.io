#import "../index.typ": template, tufted
#show: template.with(
  title: "Learning DAGs by continuous optimization",
  description: "How continuous optimization reshaped DAG structure learning.",
  date: datetime(year: 2022, month: 5, day: 2),
  lang: "en",
)

= Learning DAGs by continuous optimization

I keep thinking about directed acyclic graphs (DAGs) because they sit one step before the questions I am interested in. Ask which variables #emph[cause] which, and I am already assuming a causal graph; but before that graph exists, someone has to recover a set of dependencies that are directed and don't loop back on themselves. 
They also turn up in other places: e.g., a knowledge graph in education is a DAG over concepts, arithmetic points to algebra, and never need algebra to get back to arithmetic.

#tufted.margin-note[
  Curriculum prerequisites are directed and acyclic almost by definition -- which is exactly why learning one from student data runs into the same wall as causal discovery.
]

What surprised me is how badly the usual machine-learning playbook fails on it. Almost everything that scaled deep learning runs on gradients. However, asking "Is this graph acyclic?" is a yes-or-no question over a discrete space that explodes super-exponentially -- there is no slope to descend. So structure learning stayed in the world of combinatorial search and independence tests, more or less watching the gradient-powered rest of the field pull away.

== Why structure learning is hard

Given data $bold(X) in RR^(n times d)$ over $d$ variables, #emph[score-based] structure learning looks for the graph that best explains the data under some scoring function. The trouble is the search space. Two properties make a naive search intractable:

+ #strong[Directedness] means the graph is described by an #emph[asymmetric] weight matrix $W in RR^(d times d)$.
+ #strong[Acyclicity] is a #emph[combinatorial] constraint. The number of DAGs grows super-exponentially in $d$, and "is this matrix a DAG?" is a discrete, non-smooth question.

This pushed the field toward combinatorial search and conditional-independence tests. Most such methods return a single graph, or the #strong[Markov equivalence class (MEC)] of graphs that imply the same independencies.

#tufted.margin-note[
  AIn a linear–Gaussian structural equation model (SEM), the least-squares estimator and the maximum-likelihood estimator coincide -- which is why early continuous methods could lean on a simple squared-error loss.
]

== Make acyclicity smooth

The 2018 paper #strong[NOTEARS] (Zheng et al.),instead of searching over discrete graphs, expresses acyclicity as a #emph[single smooth equality constraint], turning the whole problem into continuous optimization that off-the-shelf solvers can handle:

$ min_(W in RR^(d times d)) F(W) quad "subject to" quad h(W) = 0. $

For a linear SEM $X = W^top X + Z$, the score is just least squares,

$ ell(W \; bold(X)) = 1/(2 n) norm(bold(X) - bold(X) W)_F^2, $

and the interesting part is in the constraint:

$ h(W) = op("tr")(e^(W compose W)) - d = 0, $

where $compose$ is the elementwise (Hadamard) product. This quantity is exactly zero #strong[if and only if] $W$ encodes a DAG, and crucially, it is smooth, with an analytic gradient. 

== Three directions the follow-ups took

The literature after NOTEARS roughly splits along three axes.

=== 1. Beyond linearity

A nonlinear SEM $X_i = f_i (X) + Z_i$ no longer exposes a clean adjacency matrix, so the challenge becomes #emph[re-encoding acyclicity] when the structure is hidden inside a neural network.

- #strong[Nonlinear NOTEARS] (Zheng et al., AISTATS 2020) and #strong[GraN-DAG] (Lachapelle et al., ICLR 2020) push the constraint onto network weights -- GraN-DAG reads dependencies off a product of weight-magnitude matrices, $C eq.delta abs(W^((L+1))) dots.c abs(W^((1)))$, where $C_(k i) = 0$ means output $k$ is independent of input $i$.
- #strong[DAG-GNN] (Yu et al., ICML 2019) keeps an explicit weight matrix inside a variational autoencoder, modeling $X = f_2 ((I - A^top)^(-1) f_1 (Z))$ and inverting it on the encoder side.

A recurring contrast: GraN-DAG-style methods optimize a #emph[log-likelihood], while the NOTEARS line optimizes a #emph[least-squares] error which matters more than it first appears (see below).

=== 2. Better objectives and constraints

The original least-squares-plus-augmented-Lagrangian method has known pain points.

- #strong[GOLEM] (Ng et al., NeurIPS 2020) replaces least squares with a proper #emph[likelihood] score and shows that only #strong[soft] sparsity and DAG penalties are needed to recover an equivalent DAG, converting the constrained problem into a much easier unconstrained one.#footnote[Its critique of NOTEARS is that minimizing least squares ignores the log-determinant term of the Gaussian likelihood, so it is #emph[related to] but does not #emph[directly maximize] the data likelihood.]
- #strong[DAGs with No Fears] (Wei et al., NeurIPS 2020) points out that NOTEARS is not guaranteed to converge to a truly feasible ($h(A) = 0$) solution, and tightens the constraint.
- A practical line of works, augmented-Lagrangian methods need the penalty coefficient to grow toward infinity to enforce acyclicity, which invites numerical and ill-conditioning trouble.#footnote[Analyzed by Ng et al. (AISTATS 2022) on the convergence of constrained structure learning.] Reformulations using the #strong[spectral radius] (e.g., NO-BEARS) or other algebraic surrogates aim to be cheaper and more stable.

=== 3. From a single graph to a posterior

Returning one DAG hides genuine uncertainty because many graphs are plausible with finite data. #strong[Bayesian] structure learning instead targets a posterior,

$ p(bold(Z), bold(G), bold(Theta), cal(D)) = p(bold(Z)) thin p(bold(G) | bold(Z)) thin p(bold(Theta) | bold(G)) thin p(cal(D) | bold(G), bold(Theta)), $

and methods such as #strong[DiBS] (Lorch et al., NeurIPS 2021) make this differentiable by working in a continuous latent space over graphs. This is, in a sense, the natural marriage of the smoothness that made NOTEARS work also makes gradient-based Bayesian inference over structures feasible.

== How do we measure success?

Two metrics dominate evaluation, and they answer different questions:

- #strong[Structural Hamming Distance (SHD)]: the number of edge insertions, deletions, or flips needed to turn the estimated graph into the ground truth. Purely structural.
- #strong[Structural Intervention Distance (SID)] (Peters & Bühlmann, 2015): how much two DAGs disagree about #emph[interventional] predictions. Two graphs can be close in SHD yet far in SID if the misplaced edges happen to be the causally consequential ones.

#tufted.margin-note[
  SHD tells whether you drew the right picture, SID whether the picture supports the right causal conclusions.
]

== Open problems (and where I think it's interesting)

+ #strong[Bayesian + continuous optimization.] Output a posterior over DAGs, approximated with a neural network keeping the differentiability of NOTEARS while honestly representing uncertainty.
+ #strong[Incomplete data.] Jointly learn features and structure when observations are missing. EM is the obvious baseline, but the real question is the #emph[inductive bias]: e.g., an underlying stochastic process governing how features are distributed over the graph (cf. Kemp's work on structured priors), and whether the node set is fixed or grows over a lifetime.
+ #strong[Scaling.] The adjacency matrix is $d times d$; everything about high-dimensional structure learning -- optimization stability, identifiability, compute -- gets harder as $d$ grows.

The throughline of this whole literature is a single reframing: #emph[acyclicity, the discrete obstacle, can be made smooth.] Almost every advance since has been about choosing a better objective to put on top of that smooth constraint, or a better way to represent uncertainty about the graph underneath it.

== References

- Zheng, X., Aragam, B., Ravikumar, P., & Xing, E. P. (2018). #link("https://arxiv.org/abs/1803.01422")[DAGs with NO TEARS: Continuous optimization for structure learning]. _Advances in Neural Information Processing Systems (NeurIPS)_.
- Zheng, X., Dan, C., Aragam, B., Ravikumar, P., & Xing, E. P. (2020). #link("https://arxiv.org/abs/1909.13189")[Learning sparse nonparametric DAGs]. _International Conference on Artificial Intelligence and Statistics (AISTATS)_.
- Yu, Y., Chen, J., Gao, T., & Yu, M. (2019). #link("https://arxiv.org/abs/1904.10098")[DAG-GNN: DAG structure learning with graph neural networks]. _International Conference on Machine Learning (ICML)_.
- Lachapelle, S., Brouillard, P., Deleu, T., & Lacoste-Julien, S. (2020). #link("https://arxiv.org/abs/1906.02226")[Gradient-based neural DAG learning]. _International Conference on Learning Representations (ICLR)_.
- Ng, I., Ghassami, A., & Zhang, K. (2020). #link("https://arxiv.org/abs/2006.10201")[On the role of sparsity and DAG constraints for learning linear DAGs]. _Advances in Neural Information Processing Systems (NeurIPS)_.
- Wei, D., Gao, T., & Yu, Y. (2020). #link("https://arxiv.org/abs/2010.09133")[DAGs with no fears: A closer look at continuous optimization for learning Bayesian networks]. _Advances in Neural Information Processing Systems (NeurIPS)_.
- Ng, I., Lachapelle, S., Ke, N. R., Lacoste-Julien, S., & Zhang, K. (2022). #link("https://arxiv.org/abs/2011.11150")[On the convergence of continuous constrained optimization for structure learning]. _International Conference on Artificial Intelligence and Statistics (AISTATS)_.
- Lorch, L., Rothfuss, J., Schölkopf, B., & Krause, A. (2021). #link("https://arxiv.org/abs/2105.11839")[DiBS: Differentiable Bayesian structure learning]. _Advances in Neural Information Processing Systems (NeurIPS)_.
- Peters, J., & Bühlmann, P. (2015). #link("https://arxiv.org/abs/1306.1043")[Structural intervention distance for evaluating causal graphs]. _Neural Computation_, 27(3), 771–799.
