# delayed_first_order_lowpass_initialize

This case shares its CompCert Csyntax source with group `delayed_filter_lifecycle`. The execution model accepts arbitrary machine arguments and memory states. The generated safety and termination goals and the concrete precondition are pending.

Upstream definition: `sw/airborne/filters/delayed_first_order_lowpass_filter.h:120`. The target, frontend options and file hashes are in [manifest.json](manifest.json). Actual attributable command measurements and their batch cost references are in [costs.json](costs.json).

## Case interface migration

`source/bindings.json` records known provenance and explicitly marks unaudited bindings and redirects. Historical reports and cost records are preserved. No new CBMC or proof was run. Historical per-case model generation costs await a separately measured rerun.
