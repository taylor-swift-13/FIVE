# Paparazzi CompCert cases

This collection has 570 aligned entry cases from Paparazzi, including 138 state interfaces. The horizontal guidance reference awaits the original generated aircraft configuration, as recorded in [limitations](reports/limitations.md).

Every case has the same internal structure as the existing FIVE cases:

```text
cases/<function>/
  source/Program.c
  source/preprocessed.i
  source/LICENSE
  cbmc/README.md
  model/Source.v
  model/Execution.v
  proof/Precondition.v
  proof/Obligations.v
  proof/Proofs.v
  report/report.md
  report/manifest.json
  report/costs.json
```

[Browse cases](cases/) · [Search the case catalog](catalog.json) · [Total and average costs](COSTS.md) · [State and guidance](reports/state-guidance.md) · [Proof families](reports/connected-families.md) · [Navigation and vision](reports/navigation-vision-families.md) · [Limitations](reports/limitations.md)

Functions exported from the same source group contain byte-identical copies of the group `Source.v`; their manifests bind the shared AST hash and namespace. The `_shared` directory holds the group originals and upstream dependency snapshots. Historical evidence remains in `reports/`.

Each case's `report/costs.json` identifies the individually measured goal-generation commands and references its shared group and stage costs. Historical batches did not have independent per-case token or wall-time boundaries, so these fields are unavailable instead of being estimated.

The concrete preconditions and program-property proofs remain pending for this collection. External call environments, source slicing and combined translation units retain the stated correspondence obligations.
