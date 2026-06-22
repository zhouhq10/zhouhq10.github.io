#import "../index.typ": template, tufted
#show: template.with(
  title: "Knowledge tracing: can we measure what someone knows?",
  description: "An introduction to knowledge tracing -- estimating a student's latent, changing knowledge from a stream of right and wrong answers. A map of the main model families, what I learned reproducing a few of them, and some questions I don't have answers to yet.",
  date: datetime(year: 2022, month: 6, day: 15),
  lang: "en",
)

= A map of the field

Knowledge tracing asks: given a student answering exercise after exercise, can we estimate what they actually know, and how that changes as they practice? I spent part of my first year reading the canon and reproducing some of the models taken to be state of the art. 

== The problem

A learner produces a sequence of interactions $(e_t, a_t)$: an exercise $e_t$, tagged with one or more #emph[knowledge components] (KCs), and a response $a_t in {0, 1}$. A knowledge-tracing model keeps a belief about the learner's mastery and predicts how they'll do next, $P(a_(t+1) = 1 | e_(t+1), "history")$.

What makes this hard is that the thing we care about is not observed, i.e., mastery is latent; it (at least is assumed to) changes over time, going up with practice and down with forgetting; and it's revealed only through a single bit per step -- that mixes knowing with guessing, slipping, and exercise difficulty. A lot of the field's ingenuity is about recovering a rich, moving, hidden state from this very thin signal. 

== To model the latent state

#strong[Probabilistic models.] The foundation is Bayesian Knowledge Tracing (Corbett & Anderson, 1994), per skill, a two-state hidden Markov model -- a KC is learned or unlearned -- with four parameters, the prior $P(L_0)$, a learning transition $P(T)$, a guess rate $P(G)$, and a slip rate $P(S)$. Its great virtue is that every parameter means something we could explain to a teacher. While classic BKT has no forgetting and assumes KCs are independent, much of what follows is the field relaxing those assumptions one at a time, for instance with dynamic Bayesian networks that model prerequisite structure between skills (Käser et al., 2017).

#strong[Logistic / factor models.] Instead of a latent Markov chain, this family predicts correctness with a logistic function of additive features, close in spirit to item response theory. Learning Factors Analysis (Cen et al., 2006) uses initial knowledge, KC easiness, and a learning rate; Performance Factors Analysis (Pavlik et al., 2009) swaps in counts of prior successes and failures, which lets it tell students apart; Knowledge Tracing Machines (Vie & Kashima, 2019) generalize the whole family as factorization machines, so arbitrary side information can be encoded as features. 

#strong[Deep models.] After 2015 the field moved here, trading interpretability for fit. Deep Knowledge Tracing (Piech et al., 2015) runs an LSTM over the interaction sequence and reads mastery off the hidden state. Dynamic Key-Value Memory Networks (Zhang et al., 2017) make memory explicit, with a static key matrix over latent concepts and a dynamic value matrix for mastery. Attention models -- SAKT (Pandey & Karypis, 2019), AKT (Ghosh et al., 2020), which uses a monotonic, distance-decaying attention -- replace recurrence with self-attention; graph-based models like GKT (Nakagawa et al., 2019) and structure-based KT (Tong et al., 2020) put the KC graph into the architecture itself. These predict the next answer better; the cost is that the latent state becomes hard to read.

== Forgetting and structure

Two extensions reappear across all three families, which I think is a useful signal about what the base models are missing.

The first is #strong[forgetting]. BKT's zero-forgetting assumption is plainly unrealistic, so the field keeps reintroducing time. The cheap version adds a lag-time feature (Nagatani et al., 2019); the more principled versions model decay like DAS3H for scheduling distributed practice (Choffin et al., 2019), or HawkesKT (Wang et al., 2021), which treats a learning history as a point process where each past interaction excites future correctness through a kernel that decays over time.

The second is #strong[structure] dropping the pretense that KCs are independent. Prerequisite-driven DKT (Chen et al., 2018) regularizes toward a prerequisite graph; GKT and structure-based KT propagate mastery along the knowledge graph; RKT (Pandey & Srivastava, 2020) folds exercise relations and a time-decay kernel into attention.

== How the field measures itself

I reproduced the temporal and structural end of this: HawkesKT, SKT, and RKT. This was only possible because of how much the community has open-sourced, from reference implementations like USTC's EduKTM to benchmarks such as pyKT (Liu et al., 2022) that standardize datasets and evaluation. 

In practice, almost everything is judged by AUC on next-answer prediction (sometimes accuracy or RMSE).
But predicting the next answer is not the same as recovering the latent state these models claim to estimate, and the two come apart. The clearest demonstration I found is "How Deep is Knowledge Tracing?" (Khajah, Lindsey & Mozer, 2016): give BKT the same advantages the deep models enjoy, forgetting, student ability, item difficulty, and most of deep learning's lead disappears. Good next-answer prediction, then, can come from capturing effects a simple interpretable model captures too. 

However, when the latent state is legible enough to inspect, it is often visibly incoherent. Yeung & Yeung (2018) show that DKT's mastery estimates jump around non-monotonically -- knowledge spiking after a wrong answer, or for skills the student never practiced -- even while the model predicts well. So a model can win on next-answer prediction while the trajectory it reports is not a believable account of learning at all. 

My worry is also larger as the field has gradually swapped its real goal, modeling and improving how people learn, for a tractable proxy, predicting the next answer on passively logged data, scored by AUC. "State of the art" rests on datasets from a few tutoring platforms, and some of them are even from decades ago. It is hard to say how much of the steady AUC creep is insight into how people learn, and how much is overfitting to the quirks of ASSISTments and its cousins. When pyKT re-ran much of the field under one fixed pipeline, several widely cited models turned out to have been leaking the current response into their own inputs. In other words, some of the creep was never about learning at all.

- Recording each interaction as correct or incorrect discards almost everything educationally interesting, e.g., why an answer was wrong, the misconception behind it, the strategy the student tried. This flattening comes from the data itself, before any model sees it, so no architecture downstream can recover what the encoding already threw away.
- The datasets are a record of what a particular system decided to show. A tutoring system picks the next exercise by its own policy, e.g., get a few right and it serves something harder, so observed correctness is partly engineered by that policy, and the policy is invisible to the modeler. A model fit to predict correctness may be learning the system's control loop as much as the student's knowledge. Though the goal is intervention, what to teach next, how to space it, the evidence is observational and policy-confounded, and we almost never test whether acting on a model actually helps someone learn.

AUC on next-answer prediction can go up for years while our account of how people learn stands still. No leaderboard scores these questions: what memory is, how concepts depend on one another, what it even means to #emph[know] something. 

== References

- Corbett, A. T., & Anderson, J. R. (1994). #link("https://doi.org/10.1007/BF01099821")[Knowledge tracing: Modeling the acquisition of procedural knowledge]. _User Modeling and User-Adapted Interaction_, 4(4), 253–278. _(BKT)_
- Cen, H., Koedinger, K., & Junker, B. (2006). #link("https://doi.org/10.1007/11774303_17")[Learning factors analysis: A general method for cognitive model evaluation and improvement]. _Intelligent Tutoring Systems (ITS)_.
- Pavlik, P. I., Cen, H., & Koedinger, K. R. (2009). #link("https://eric.ed.gov/?id=ED506305")[Performance factors analysis: A new alternative to knowledge tracing]. _Artificial Intelligence in Education (AIED)_.
- Vie, J.-J., & Kashima, H. (2019). #link("https://arxiv.org/abs/1811.03388")[Knowledge tracing machines: Factorization machines for knowledge tracing]. _AAAI Conference on Artificial Intelligence (AAAI)_.
- Piech, C., Bassen, J., Huang, J., Ganguli, S., Sahami, M., Guibas, L., & Sohl-Dickstein, J. (2015). #link("https://arxiv.org/abs/1506.05908")[Deep knowledge tracing]. _Advances in Neural Information Processing Systems (NeurIPS)_.
- Zhang, J., Shi, X., King, I., & Yeung, D.-Y. (2017). #link("https://arxiv.org/abs/1611.08108")[Dynamic key-value memory networks for knowledge tracing]. _The Web Conference (WWW)_.
- Pandey, S., & Karypis, G. (2019). #link("https://arxiv.org/abs/1907.06837")[A self-attentive model for knowledge tracing]. _Educational Data Mining (EDM)_.
- Ghosh, A., Heffernan, N., & Lan, A. S. (2020). #link("https://arxiv.org/abs/2007.12324")[Context-aware attentive knowledge tracing]. _ACM SIGKDD (KDD)_.
- Nakagawa, H., Iwasawa, Y., & Matsuo, Y. (2019). #link("https://doi.org/10.1145/3350546.3352513")[Graph-based knowledge tracing: Modeling student proficiency using graph neural networks]. _IEEE/WIC/ACM International Conference on Web Intelligence (WI)_.
- Käser, T., Klingler, S., Schwing, A. G., & Gross, M. (2017). #link("https://doi.org/10.1109/TLT.2017.2689017")[Dynamic Bayesian networks for student modeling]. _IEEE Transactions on Learning Technologies_, 10(4), 450–462.
- Khajah, M., Lindsey, R. V., & Mozer, M. C. (2016). #link("https://arxiv.org/abs/1604.02416")[How deep is knowledge tracing?] _Educational Data Mining (EDM)_.
- Yeung, C.-K., & Yeung, D.-Y. (2018). #link("https://arxiv.org/abs/1806.02180")[Addressing two problems in deep knowledge tracing via prediction-consistent regularization]. _ACM Conference on Learning at Scale (L\@S)_.
- Nagatani, K., Zhang, Q., Sato, M., Chen, Y.-Y., Chen, F., & Ohkuma, T. (2019). #link("https://doi.org/10.1145/3308558.3313565")[Augmenting knowledge tracing by considering forgetting behavior]. _The Web Conference (WWW)_.
- Choffin, B., Popineau, F., Bourda, Y., & Vie, J.-J. (2019). #link("https://arxiv.org/abs/1905.06873")[DAS3H: Modeling student learning and forgetting for optimally scheduling distributed practice of skills]. _Educational Data Mining (EDM)_.
- Wang, C., Ma, W., Zhang, M., Lv, C., Wan, F., Lin, H., Tang, T., Liu, Y., & Ma, S. (2021). #link("https://doi.org/10.1145/3437963.3441802")[Temporal cross-effects in knowledge tracing]. _ACM International Conference on Web Search and Data Mining (WSDM)_. _(HawkesKT)_
- Tong, S., Liu, Q., Huang, W., Huang, Z., Chen, E., Liu, C., Ma, H., & Wang, S. (2020). #link("https://doi.org/10.1109/ICDM50108.2020.00063")[Structure-based knowledge tracing: An influence propagation view]. _IEEE International Conference on Data Mining (ICDM)_. _(SKT)_
- Pandey, S., & Srivastava, J. (2020). #link("https://arxiv.org/abs/2008.12736")[RKT: Relation-aware self-attention for knowledge tracing]. _ACM International Conference on Information and Knowledge Management (CIKM)_.
- Chen, P., Lu, Y., Zheng, V. W., & Pian, Y. (2018). #link("https://doi.org/10.1109/ICDM.2018.00019")[Prerequisite-driven deep knowledge tracing]. _IEEE International Conference on Data Mining (ICDM)_.
- Liu, Z., Liu, Q., Chen, J., Huang, S., Tang, J., & Luo, W. (2022). #link("https://arxiv.org/abs/2206.11460")[pyKT: A Python library to benchmark deep learning based knowledge tracing models]. _Advances in Neural Information Processing Systems (NeurIPS), Datasets and Benchmarks Track_.
