# gh_set_omega verification

Proved all requested original-Csem no-error, all-successor Acc termination, normal-return existence and exact functional return/global-state update for arbitrary initialized14-field writable gh_ref and all binary32 inputs including NaNs/infinities/signed zeros. Caller precondition satisfiable from original Genv.init_mem. All15 actual CBMC IDs independently rechecked via exact returned/stored bits, source-order products, named frame and explicit4-byte memcpy adapter with Csem integer equality. Generated model remains unrestricted over all machine argument lists/memories.

Five canonical problems: no_error, termination, functional, cbmc_recheck (15 exact property-ID GoalBindings), execution (five strong theorems cover eight gate categories). Every active attempt001 has fresh dependency snapshots, actual assumptions, independent kernel receipts and deterministic exact-type GoalBinding kernel receipts. No generated whole-main execution claimed: each actual harness assertion/guard has an explicit property adapter linked to all-final original setter execution.

Trust boundary: pinned CompCert3.17 Csyntax/Csem/Cexec frontend+library assumptions, little-endian x86-64 binary32; no GCC/hardware or cross-tool NaN-payload equivalence. Original source-order multiplication payload policy retained.

Costs retain initial failed/slow CBMC attempts and author/proof retries. Initial author-run accidental overlapping Public/checker commands have explicitly unknown normalized tool CPU/RSS. Author tokens/wall remain measured; active certificate run is fresh and strictly sequential with unique command IDs. Raw records are immutable.
