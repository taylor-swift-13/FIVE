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

From Stdlib Require Import List ZArith.
From compcert Require Import Coqlib Maps Integers Floats AST Values Memory Memdata Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Smallstep.
From FiveSum3Proof Require Import SourceInvariant.
Import ListNotations.
Local Open Scope Z_scope.

Definition bits_id : ident := 9001%positive.
Definition bits_env (bb:block) : env := PTree.set bits_id (bb,tuint) empty_env.
Definition bits_assertion : expr :=
 Ebinop Oeq (Evalof (Evar bits_id tuint) tuint) (Eval (Vint Int.zero) tuint) tint.

(** The two objects are the final two locals in main. All preceding locals and
    arbitrary caller memory are included in m. Allocations precede both calls. *)
Inductive HarnessPrefix (m:mem) (a b c:float32) : block -> block -> mem -> val -> Prop :=
| harness_prefix : forall mr br mh bb t1 v1 m1 t2 v2 m2,
 Mem.alloc m 0 4 = (mr,br) -> Mem.alloc mr 0 4 = (mh,bb) ->
 star Csem.step sum3_ge (sum3_start (Vsingle a)(Vsingle b)(Vsingle c) mh) t1 (Returnstate v1 Kstop m1) ->
 star Csem.step sum3_ge
  (sum3_start (Vsingle(Float32.of_bits(Int.repr 1266679808)))
   (Vsingle(Float32.of_bits(Int.repr 1065353216)))
   (Vsingle(Float32.of_bits(Int.repr 3414163456))) m1) t2 (Returnstate v2 Kstop m2) ->
 HarnessPrefix m a b c br bb m2 v2.

(** CBMC's library uses internal pointer guards. Their portable memory-safety
    content is object separation, live base/one-past pointers, and region
    permissions; no C order is imposed between unrelated CompCert blocks. *)
Record MemcpySafety (m:mem) (br bb:block) : Prop := {
 memcpy_pointer_1 : br <> bb;
 memcpy_pointer_arithmetic_1 : Mem.valid_pointer m br 0 = true;
 memcpy_pointer_arithmetic_2 : Mem.weak_valid_pointer m bb 4 = true;
 memcpy_pointer_2 : bb <> br;
 memcpy_pointer_arithmetic_3 : Mem.valid_pointer m bb 0 = true;
 memcpy_pointer_arithmetic_4 : Mem.weak_valid_pointer m br 4 = true;
 main_precondition_instance_1 : br <> bb \/ 0+4 <= 0 \/ 0+4 <= 0;
 main_precondition_instance_2 : Mem.range_perm m br 0 4 Cur Readable;
 main_precondition_instance_3 : Mem.range_perm m bb 0 4 Cur Writable
}.
Definition ByteObservation (br bb:block) (m:mem) (v:val) : Prop :=
 exists stored copied bytes,
 Mem.store Mfloat32 m br 0 v = Some stored /\
 MemcpySafety stored br bb /\
 Mem.loadbytes stored br 0 4 = Some bytes /\
 bytes = encode_val Mfloat32 v /\
 extcall_memcpy_sem 4 1 (Genv.to_senv (Csem.genv_genv sum3_ge)) [Vptr bb Ptrofs.zero;Vptr br Ptrofs.zero] stored E0 Vundef copied /\
 Mem.loadbytes copied bb 0 4 = Some bytes /\
 Mem.load Mint32 copied bb 0 = Some(Vint Int.zero) /\
 star Csem.step sum3_ge
  (ExprState sum3_function bits_assertion Kstop (bits_env bb) copied) E0
  (ExprState sum3_function (Eval (Vint Int.one) tint) Kstop (bits_env bb) copied).
Definition FullHarnessGoal : Prop := forall m (a b c:float32) br bb mf v,
 HarnessPrefix m a b c br bb mf v -> ByteObservation br bb mf v.
