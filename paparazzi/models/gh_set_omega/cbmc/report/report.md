# gh_set_omega CBMC

Traditional CBMC SMT bitvector Z3 passed all 15 actual emitted properties. All binary32 and initialized old named fields, including NaNs. Four functional assertions check returned/stored clamp bits, both source-order multiplication bits, and all unaffected named fields. All automatic pointer/bounds/overflow/conversion/shift checks enabled; no loops or recursion.

First propositional conversion interrupted after six minutes; native-FPA experiment interrupted after symbolic NaN-bit trace generation (unsupported exact bit observation backend). Both retained; authoritative successful run uses bitvector FP with Z3, not native FPA.
