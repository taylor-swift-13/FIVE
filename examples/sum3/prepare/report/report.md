# sum3 preparation

Original C and target/bindings were preserved; the four-stage handoff is prepared. CBMC, align and Rocq were not run. Prepare cost has a dedicated child-session token record; tool CPU/RSS cover metered commands, excluding pre-meter read-only checks at the user's request. See `costs.json` for the scope.


The parent independently checked the stage handoff. The parent coordination and interrupted-run records are separate from child prepare; their event-ID union is in `costs.json`. CBMC, align and Rocq have not run. Whole-task tool CPU and memory remain unavailable because some calls were not instrumented.
