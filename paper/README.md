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
