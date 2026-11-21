From Stdlib Require Import ZArith Lia.
Local Open Scope Z_scope.
Search (_ <= Z.quot _ _).
Search (Z.quot _ _ <= _).
Search (Z.abs(Z.rem _ _) < _).
Search (0 <= Z.rem _ _).
Search (_ <= Z.land _ _).
Search (Z.land _ _ <= _).
Check Z.land_ones.
