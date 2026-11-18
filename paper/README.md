# Verification chapter draft

The verification chapter describes the rationale, architecture, semantic baseline,
generated obligations and proof responsibilities of CBMC + CompCert + Rocq.
Preceding chapters are unchanged by this revision. The appendix reports an executed sum3 comparison across WP, QCP, CompCert and native x86-64 execution. Broader aerospace evaluation numbers remain pending.

The vector framework figure is figures/five-framework.pdf. Its editable Graphviz
source is ../docs/workflow.dot; ../docs/workflow.svg supplies the same figure to
the repository README. Regenerate the PDF with Graphviz dot -Tpdf.

Build main.tex with pdflatex, bibtex, then pdflatex twice, using an ACM-compatible
LaTeX installation. The unchanged supplied archive is in ../references/.

The measured comparison inputs, exact results, raw evidence and stage costs are in [experiments/sum3](experiments/sum3/README.md). Four result-bit theorems were independently kernel-checked.

Appendix B uses the [float-byte experiment](experiments/float-bytes/README.md) to connect the framework-selection argument to WP's actual exported encoding interface, with native outputs and solver logs.

The PID discussion under label sec:pid-rounding-relations connects the ideal
reference equations to three actual-execution results: single-call sign
asymmetry, symbolic arbitrary-horizon integral drift, and input-order
sensitivity at integral saturation. Tables preserve signed integer-code
units and decoded angles. Specifications, proofs, explanation and costs:
[sign symmetry](../paparazzi/relations/pid_sign_symmetry/),
[integral drift](../paparazzi/relations/pid_alternating_bias/) and
[input order](../paparazzi/relations/pid_input_order/).
The mathematical comparison with ideal equations is distinguished from a
direct theorem between two separately executable models.
