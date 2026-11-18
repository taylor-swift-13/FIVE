# Retune and reset support proofs

Final source proofs directly compile and pass independent full-dependency Rocq kernel checks. Retune and reset accept arbitrary binary32 values and arbitrary aligned offsets under twelve writable bytes and unsignedp+12<=2^64. No initialized old fields are assumed.

The final retune summary additionally preserves every original valid block; its previous theorem interface remains a proved corollary. Full call proofs include allocation, parameter binding, actual original Csyntax body, cleanup, exact byte writes and original-valid-block frame. Canonical per-model and relation goals are validated separately.

Actual model: GPT-6.1 Sol, medium. Model configurations and immutable original run receipts are in [costs.json](costs.json). Shared support work is counted once.

|Run|Wall seconds|Tokens|Sampled tool RSS bytes|
|---|---:|---:|---:|
|evidence/20261106T184706-94cb317cd8/raw|1225.3222637176514|6335652|1390215168|
|evidence/20261106T190803-e438aec165/raw|213.78762364387512|1532464|991764480|

The first development run retains a kernel timeout and its missing GNU-time CPU receipt: total tool CPU is null, with the observed command subtotal retained. A later full-dependency retry and final source checks passed. No resource value is estimated. Each run has a readable report recording its iterations.
