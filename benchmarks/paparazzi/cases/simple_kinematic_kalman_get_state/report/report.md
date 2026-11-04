# simple_kinematic_kalman_get_state

This case shares its CompCert Csyntax source with group `kalman_lifecycle`. The execution model accepts arbitrary machine arguments and memory states. The generated safety and termination goals and the concrete precondition are pending.

Upstream definition: `sw/airborne/filters/simple_kinematic_kalman.c:103`. The target, frontend options and file hashes are in [manifest.json](manifest.json). Actual attributable command measurements and their batch cost references are in [costs.json](costs.json).

## Case interface migration

`source/bindings.json` records known provenance and explicitly marks unaudited bindings and redirects. Historical reports and cost records are preserved. No new CBMC or proof was run. Historical per-case model generation costs await a separately measured rerun.
