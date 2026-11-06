From compcert Require Import Integers Floats AST Values Memory Ctypes Cop Csyntaxdefs Csem.
Lemma uint_bits_equal:forall ge x m,
 sem_binary_operation ge Oeq(Vint(Float32.to_bits x))tuint(Vint(Float32.to_bits x))tuint m=Some(Vint Int.one).
Proof.
 intros ge x m.
 assert(CAST:sem_cast(Vint(Float32.to_bits x))tuint (Tint I32 Unsigned noattr) m=Some(Vint(Float32.to_bits x)))by reflexivity.
 unfold sem_binary_operation,sem_cmp,sem_binarith;simpl.
 rewrite CAST;simpl;rewrite Int.eq_true;reflexivity.
Qed.
