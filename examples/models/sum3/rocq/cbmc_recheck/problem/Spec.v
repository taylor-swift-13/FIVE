From Stdlib Require Import ZArith.
From compcert Require Import Integers Floats Values Csem Smallstep.
From FiveSum3Proof Require Import SourceInvariant.

Definition ResultBitsGoal : Prop := forall m t v mf,
 star Csem.step sum3_ge
   (sum3_start (Vsingle (Float32.of_bits (Int.repr 1266679808)))
               (Vsingle (Float32.of_bits (Int.repr 1065353216)))
               (Vsingle (Float32.of_bits (Int.repr 3414163456))) m)
   t (Returnstate v Kstop mf) ->
 exists f, v = Vsingle f /\ Float32.to_bits f = Int.zero.
