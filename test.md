$$
\begin{array}{ccc}
A_1 & \text{pragmatic asker} & P_{A_1}(w \mid u) \propto P_{E_1}(u \mid w) \cdot P(w) \\
\downarrow & & \\
E_1 & \text{pragmatic explainer} & P_{E_1}(u \mid w) \propto \exp \left(\alpha U_{E_1}(u ; w)\right) \\
\downarrow & & \\
A_0 &  \text{literal asker} & P_{A_0}(w \mid u) \propto \llbracket u \rrbracket(w) \cdot P(w)
\end{array}
$$


$\begin{array}{rlr}U(u ; w)= & \log P_{A_0} (w, v \mid u)+\log P_{A_0} (\pi \mid w, v)+\log P_{A_0} (r \mid w, v, \pi) & \text {asker performance } \\ & +\operatorname{cost}(u) & \text {explainer resource} \\ & + \text { effort }(P(w, v \mid u)+P(\pi \mid w, v)) & \text {asker motivation/agency} \\ & + \text { accuracy }(P_{A_0}) & \text { trustful future collaboration }\end{array}$