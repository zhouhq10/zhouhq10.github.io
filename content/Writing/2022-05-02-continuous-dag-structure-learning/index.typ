#import "../index.typ": template, tufted
#show: template.with(
  title: "Learning DAGs by Continuous Optimization",
  description: "How continuous optimization reshaped DAG structure learning — the acyclicity trick behind NOTEARS, the wave of follow-up work, and where the open problems sit.",
  date: datetime(year: 2022, month: 5, day: 2),
  lang: "en",
)

= Learning DAGs by Continuous Optimization

A lot of scientific questions reduce to recovering a #emph[directed acyclic graph (DAG)]: which variables causally influence which others. I try to trace a single idea that reorganized the field that the discrete obstacle of acyclicity can be made smooth.

== Why structure learning is hard

Given data $bold(X) in RR^(n times d)$ over $d$ variables, #emph[score-based] structure learning looks for the graph that best explains the data under some scoring function. The trouble is the search space. Two properties make a naive search intractable:

+ #strong[Directedness] means the graph is described by an #emph[asymmetric] weight matrix $W in RR^(d times d)$.
+ #strong[Acyclicity] is a #emph[combinatorial] constraint. The number of DAGs grows super-exponentially in $d$, and "is this matrix a DAG?" is a discrete, non-smooth question.

For decades this pushed the field toward combinatorial search and conditional-independence tests. Most such methods return a single graph, or the #strong[Markov equivalence class (MEC)] of graphs that imply the same independencies.

#tufted.margin-note[
  A useful baseline fact: in a linear–Gaussian structural equation model (SEM), the least-squares estimator and the maximum-likelihood estimator coincide — which is why early continuous methods could lean on a simple squared-error loss.
]

== Make acyclicity smooth

The 2018 paper #strong[NOTEARS] (Zheng et al.),instead of searching over discrete graphs, expresses acyclicity as a #emph[single smooth equality constraint], turning the whole problem into continuous optimization that off-the-shelf solvers can handle:

$ min_(W in RR^(d times d)) F(W) quad "subject to" quad h(W) = 0. $

For a linear SEM $X = W^top X + Z$, the score is just least squares,

$ ell(W \; bold(X)) = 1/(2 n) norm(bold(X) - bold(X) W)_F^2, $

and the magic is in the constraint:

$ h(W) = op("tr")(e^(W compose W)) - d = 0, $

where $compose$ is the elementwise (Hadamard) product. This quantity is exactly zero #strong[if and only if] $W$ encodes a DAG, and crucially, it is smooth, with an analytic gradient. Acyclicity becomes something we can do gradient descent on.

== Three directions the follow-ups took

The literature after NOTEARS roughly splits along three axes.

=== 1. Beyond linearity

Real mechanisms are rarely linear. A nonlinear SEM $X_i = f_i (X) + Z_i$ no longer exposes a clean adjacency matrix, so the challenge becomes #emph[re-encoding acyclicity] when the structure is hidden inside a neural network.

- #strong[Nonlinear NOTEARS] (Zheng et al., AISTATS 2020) and #strong[GraN-DAG] (Lachapelle et al., ICLR 2020) push the constraint onto network weights — GraN-DAG reads dependencies off a product of weight-magnitude matrices, $C eq.delta abs(W^((L+1))) dots.c abs(W^((1)))$, where $C_(k i) = 0$ means output $k$ is independent of input $i$.
- #strong[DAG-GNN] (Yu et al., ICML 2019) keeps an explicit weight matrix inside a variational autoencoder, modeling $X = f_2 ((I - A^top)^(-1) f_1 (Z))$ and inverting it on the encoder side.

A recurring contrast: GraN-DAG-style methods optimize a #emph[log-likelihood], while the NOTEARS line optimizes a #emph[least-squares] error which matters more than it first appears (see below).

=== 2. Better objectives and constraints

The original least-squares-plus-augmented-Lagrangian recipe has known pain points, and a second strand of work attacked them directly.

- #strong[GOLEM] (Ng et al., NeurIPS 2020) replaces least squares with a proper #emph[likelihood] score and shows that only #strong[soft] sparsity and DAG penalties are needed to recover an equivalent DAG, converting the constrained problem into a much easier unconstrained one.#footnote[Its critique of NOTEARS is sharp: minimizing least squares ignores the log-determinant term of the Gaussian likelihood, so it is #emph[related to] but does not #emph[directly maximize] the data likelihood.]
- #strong[DAGs with No Fears] (Wei et al., NeurIPS 2020) points out that NOTEARS is not guaranteed to converge to a truly feasible ($h(A) = 0$) solution, and tightens the constraint.
- A practical thread, augmented-Lagrangian methods need the penalty coefficient to grow toward infinity to enforce acyclicity, which invites numerical and ill-conditioning trouble.#footnote[Analyzed by Ng et al. (AISTATS 2022) on the convergence of constrained structure learning.] Reformulations using the #strong[spectral radius] (e.g., NO-BEARS) or other algebraic surrogates aim to be cheaper and more stable.

=== 3. From a single graph to a posterior

Returning one DAG hides genuine uncertainty because many graphs are plausible with finite data. #strong[Bayesian] structure learning instead targets a posterior,

$ p(bold(Z), bold(G), bold(Theta), cal(D)) = p(bold(Z)) thin p(bold(G) | bold(Z)) thin p(bold(Theta) | bold(G)) thin p(cal(D) | bold(G), bold(Theta)), $

and methods such as #strong[DiBS] (Lorch et al., NeurIPS 2021) make this differentiable by working in a continuous latent space over graphs. This is, in a sense, the natural marriage of the two ideas: the smoothness that made NOTEARS work also makes gradient-based Bayesian inference over structures feasible.

== How do we measure success?

Two metrics dominate evaluation, and they answer different questions:

- #strong[Structural Hamming Distance (SHD)]: the number of edge insertions, deletions, or flips needed to turn the estimated graph into the ground truth. Purely structural.
- #strong[Structural Intervention Distance (SID)] (Peters & Bühlmann, 2015): how much two DAGs disagree about #emph[interventional] predictions. Two graphs can be close in SHD yet far in SID if the misplaced edges happen to be the causally consequential ones.

#tufted.margin-note[
  Reporting both is good practice: SHD tells you whether you drew the right picture, SID whether the picture supports the right causal conclusions.
]

== Open problems (and where I think it's interesting)

+ #strong[Bayesian + continuous optimization.] Output a posterior over DAGs, approximated with a neural network keeping the differentiability of NOTEARS while honestly representing uncertainty.
+ #strong[Incomplete data.] Jointly learn features and structure when observations are missing. EM is the obvious baseline, but the real question is the #emph[inductive bias]: e.g., an underlying stochastic process governing how features are distributed over the graph (cf. Kemp's work on structured priors), and whether the node set is fixed or grows over a lifetime.
+ #strong[Scaling.] The adjacency matrix is $d times d$; everything about high-dimensional structure learning — optimization stability, identifiability, compute — gets harder as $d$ grows.

The throughline of this whole literature is a single reframing: #emph[acyclicity, the discrete obstacle, can be made smooth.] Almost every advance since has been about choosing a better objective to put on top of that smooth constraint, or a better way to represent uncertainty about the graph underneath it.

== References

- Zheng, Aragam, Ravikumar, Xing. #strong[DAGs with NO TEARS: Continuous Optimization for Structure Learning.] NeurIPS 2018.
- Zheng, Dan, Aragam, Ravikumar, Xing. #strong[Learning Sparse Nonparametric DAGs.] AISTATS 2020. #emph[(nonlinear NOTEARS)]
- Yu, Chen, Gao, Yu. #strong[DAG-GNN: DAG Structure Learning with Graph Neural Networks.] ICML 2019.
- Lachapelle, Brouillard, Deleu, Lacoste-Julien. #strong[Gradient-Based Neural DAG Learning (GraN-DAG).] ICLR 2020.
- Ng, Ghassami, Zhang. #strong[On the Role of Sparsity and DAG Constraints for Learning Linear DAGs (GOLEM).] NeurIPS 2020.
- Wei, Gao, Yu. #strong[DAGs with No Fears: A Closer Look at Continuous Optimization for Learning Bayesian Networks.] NeurIPS 2020.
- Ng, Lachapelle, Ke, Lacoste-Julien, Zhang. #strong[On the Convergence of Continuous Constrained Optimization for Structure Learning.] AISTATS 2022.
- Lorch, Rothfuss, Schölkopf, Krause. #strong[DiBS: Differentiable Bayesian Structure Learning.] NeurIPS 2021.
- Peters, Bühlmann. #strong[Structural Intervention Distance (SID) for Evaluating Causal Graphs.] Neural Computation, 2015.
