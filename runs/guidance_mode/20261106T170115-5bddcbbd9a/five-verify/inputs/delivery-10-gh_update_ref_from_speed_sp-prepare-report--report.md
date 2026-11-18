# Preparation: gh_update_ref_from_speed_sp

Exact pinned original entry/callee/types/macros retain the full64byte GuidanceHRef. This revision explicitly binds sqrtf to the included common loop-free C five_sqrtf implementation. Both CBMC and CompCert consume this identical prepared source and dependency, with no tool-dependent macro. The prior __builtin_sqrt attempt is preserved in the scoped history and failed because CBMC6.11.0 has no body for that callee. Software accuracy/native libm equivalence is not asserted as proved; the verification target is exact execution of this fixed C binding.

Current binding revision is integer-restoring-v2, with 23 explicit subnormal normalization blocks and 24 explicit restoring steps. The prior binary-search/double-square implementation is preserved as historical input after complete and sliced CBMC attempts timed out during SSA conversion; no property failure was claimed from those timeouts.
