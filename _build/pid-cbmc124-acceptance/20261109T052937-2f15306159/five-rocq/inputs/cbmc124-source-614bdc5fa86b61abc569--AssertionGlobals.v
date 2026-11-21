From compcert Require Import AST Values Memory Globalenvs Ctypes Csem.
From PidPositionRunPos Require Import Execution.
From PidPositionTranslationSupport Require Import MemoryLayout.
Local Opaque Execution.ge.
Lemma load_global_at_symbol:forall chunk m id ty path b,
 Genv.find_symbol Execution.ge id=Some b ->
 load_global chunk m id ty path=load_path chunk m b ty path.
Proof. intros;unfold load_global;rewrite H;reflexivity. Qed.
Lemma loaded_global_has_symbol:forall chunk m id ty path value,
 load_global chunk m id ty path=Some value ->
 exists b,Genv.find_symbol Execution.ge id=Some b /\
 load_path chunk m b ty path=Some value.
Proof.
 intros chunk m id ty path value LOAD;unfold load_global in LOAD.
 destruct(Genv.find_symbol Execution.ge id)as[b|]eqn:SYM;[exists b;auto|discriminate].
Qed.
