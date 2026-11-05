From FiveSum2Proof.support Require Import NormalCorrespondence.
From FiveShared.pure_semantics Require Import SemanticsSupport.
From Stdlib Require Import ZArith.
From compcert Require Import AST Integers Floats Values Memory Maps Cop Ctypes Csyntax Csyntaxdefs Csem Smallstep.
From FiveSum2Proof Require Import SourceInvariant Invariant.
Definition input_large := Float32.of_bits (Int.repr 1266679808).
Definition input_one := Float32.of_bits (Int.repr 1065353216).
Definition expected := input_large.
Definition AssertionGoal : Prop := forall m t v mf,
 star Csem.step sum2_ge (sum2_start (Vsingle input_large) (Vsingle input_one) m)
   t (Returnstate v Kstop mf) ->
 exists f, v = Vsingle f /\ Float32.to_bits f = Int.repr 1266679808 /\
   sem_binary_operation sum2_ge Oeq v tfloat (Vsingle expected) tfloat mf = Some (Vint Int.one).
Definition ReturnExistsGoal : Prop := forall m (a b:float32),
 exists t v mf, star Csem.step sum2_ge (sum2_start (Vsingle a) (Vsingle b) m)
   t (Returnstate v Kstop mf).
Definition ArbitrarySafetyGoal : Prop := forall m (a b:float32) t s,
 star Csem.step sum2_ge (sum2_start (Vsingle a) (Vsingle b) m) t s -> ~source_error s.

Definition local_r : positive := 1%positive.
Definition local_env (br:block) : Csem.env := PTree.set local_r (br,tfloat) empty_env.
Definition local_assertion : Csyntax.expr :=
 Csyntax.Ebinop Oeq (Csyntax.Evalof (Csyntax.Evar local_r tfloat) tfloat)
   (Csyntax.Eval (Vsingle expected) tfloat) tint.
Definition LocalObservation (v:val) (m:mem) : Prop :=
 exists ma br mr,
 Mem.alloc m 0 4 = (ma,br) /\
 sem_cast v tfloat tfloat ma = Some v /\
 Mem.store AST.Mfloat32 ma br 0 v = Some mr /\
 Mem.load AST.Mfloat32 mr br 0 = Some v /\
 pure_rval sum2_ge (local_env br) mr local_assertion = Some (Vint Int.one) /\
 star Csem.step sum2_ge
   (ExprState sum2_function local_assertion Kstop (local_env br) mr) Events.E0
   (ExprState sum2_function (Csyntax.Eval (Vint Int.one) tint) Kstop (local_env br) mr).
Definition FullAssertionGoal : Prop := forall m t v mf,
 star Csem.step sum2_ge (sum2_start (Vsingle input_large) (Vsingle input_one) m)
   t (Returnstate v Kstop mf) -> LocalObservation v mf.
