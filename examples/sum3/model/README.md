# CompCert model and mapping

`Source.v` is the retained CompCert Csyntax model, and `Execution.v` exposes its Cexec entry and transitions. `SourceInvariant.v` supports the existing safety proof. `rerun/` contains the separately regenerated source, execution wrapper, pending goals and exporter manifest; the original files used by the proof were not overwritten. `spec-map.json` inventories all actual CBMC properties and marks the Csem-return and harness observations that remain unproved.

Generation/audit evidence and partial align costs are linked from [`../report/costs.json`](../report/costs.json), stage `five-align`.
