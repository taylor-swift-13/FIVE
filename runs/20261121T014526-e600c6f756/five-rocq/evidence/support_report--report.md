# Binary32 accumulator absorption support

Proved in FivePidDfRoundoffSupport.Absorption for all finite binary32 inputs including subnormals under CompCert Float32 nearest ties to even semantics.

RN_upper_endpoint and RN_lower_endpoint prove generic real rounding of +/-16777217 gives +/-16777216. Actual Float32 bit-pattern addition evaluations and CompCert's checked lifting establish these. Monotonicity bounds every rounded real input in this interval.

add_absorption assumes |r32 x|<=2^24 and |r32 y|<=1. It proves finite result, magnitude<=2^24, generic error<=u*|r32 x+r32 y|+eta, and growth<=|r32 x|+3. add_absorption_error_two gives error<=2. add_real_absorption_safe lifts exact sums of magnitude<=2^25 to generic RN. No pending support goal remains. C-level/native-hardware correspondence is outside this helper's scope.

Frozen source SHA256 bindings: evidence/source-bindings.json. Fresh compile, exact goal binding, independent kernel receipts: evidence/kernel-evidence.json. Reproduce via evidence/check.py under telemetry. Print Assumptions reports only ClassicalDedekindReals.sig_not_dec, ClassicalDedekindReals.sig_forall_dec, FunctionalExtensionality.functional_extensionality_dep, Classical_Prop.classic. No Axiom or Admitted added.

Observed runtime gpt-6.1-sol effort ultra is in evidence/runtime-receipt.json. The explicit ultra request overrides the reference default medium. Dedicated skill-session started before substantive proof work. Scope records earlier WSL-denied/bootstrap session-identification work without fabricated CPU/RSS. All proof attempts and source writes were measured, including the unsuccessful bit-identity attempt corrected to real-observation equality. One metadata-wrapper Python syntax error occurred before Run.command dispatch, after the successful kernel check; its tool wall time1.195149s is known but its GNU CPU/RSS are unavailable. It changed no proof or artifact.

Final resource figures in metrics.json include raw timing/RSS and session token receipts. Root aggregation includes the dedicated-session tail once by event ID.
