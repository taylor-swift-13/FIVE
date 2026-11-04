# sum3: execution and proof status

See the [stage guide](../README.md), [manifest](manifest.json) and [costs](costs.json).

* A native x86-64 run returned `0x00000000` for `(16777216.0f, 1.0f, -16777216.0f)`. Traditional CBMC 6.11 checked the same concrete-input output-bit assertion successfully.
* `Core.sum3_all_bits_no_error` and `NoError.generated_no_error` were rebuilt and independently kernel checked: for three typed binary32 arguments (including all NaN and infinity bit patterns) and arbitrary initial CompCert memory, no reachable execution state is an error. The theorem and its inherited assumptions are in `evidence/rocq/logs/001-compile-and-check.stdout.log`.
* `Functional.sum3_concrete_bits` was rebuilt and kernel checked for the pure CompCert Float32 operation. It is not yet connected to the Csem function return or the CBMC memory observation. `model/spec-map.json` and `proof/spec-recheck.json` mark that gap.
* The termination proposition has not been proved. No final end-to-end verification gate is claimed. Costs are partial because recorded intervals contain unrelated directory work and not all stage boundaries were captured.
