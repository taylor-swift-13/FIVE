# sum3

This case uses four sequential stage folders: `prepare/` → `cbmc/` → `align/` → `rocq/`. Only prepare has run. Each stage reads its preceding handoff and checks referenced paths and hashes. The selected entry `sum3` is in `prepare/source/sum3.c`; its inspected call closure contains no additional functions. The original translation unit is retained under `prepare/provenance/`. The target and bindings are in `prepare/source/`; stage status and cost evidence are in `prepare/report/`; `prepare/handoff.json` is the CBMC input. The CBMC property has not been specified.

The `.gitkeep` files only preserve the empty future directories; they are not stage results.
