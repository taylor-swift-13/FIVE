From Stdlib Require Import Extraction ExtrOcamlBasic ExtrOcamlString.
From FiveSum3 Require Import Execution.
Extraction Language OCaml.
Extraction "/home/yangfp/five/examples/sum3/align/model/execution.ml" entry transitions closed_transitions.
