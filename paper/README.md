# Verification chapter draft

The verification chapter describes the rationale, architecture, semantic baseline,
generated obligations and proof responsibilities of CBMC + CompCert + Rocq.
Preceding chapters are unchanged by this revision. Evaluation numbers remain
pending; model generation and historical proof evidence are not new results.

The vector framework figure is figures/five-framework.pdf. Its editable Graphviz
source is ../docs/workflow.dot; ../docs/workflow.svg supplies the same figure to
the repository README. Regenerate the PDF with Graphviz dot -Tpdf.

Build main.tex with pdflatex, bibtex, then pdflatex twice, using an ACM-compatible
LaTeX installation. The unchanged supplied archive is in ../references/.
