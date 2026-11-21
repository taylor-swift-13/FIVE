From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib AST Integers Values Memory Globalenvs Ctypes Csyntax Csem.
Require PprzTrigInit.Source.
From PprzTrigRelationSupport Require Import InitialMemory PackedPrefix.
Open Scope Z_scope.
Lemma source_initial_range : forall (p:Csyntax.program)m b(gv:globvar Ctypes.type),
 Genv.init_mem p=Some m ->Genv.find_var_info(Csem.globalenv p)b=Some gv ->
 Mem.range_perm m b 0(init_data_list_size(gvar_init gv))Cur(Genv.perm_globvar gv).
Proof.
 intros p m b gv INIT VAR.
 exact(proj1(@Genv.init_mem_characterization Csyntax.fundef Ctypes.type(Ctypes.program_of_program p)b gv m VAR INIT)).
Qed.
Lemma buffer_initial_prefix : forall m b,
 Genv.init_mem PprzTrigInit.Source.prog=Some m ->
 Genv.find_var_info(Csem.globalenv PprzTrigInit.Source.prog)b=Some PprzTrigInit.Source.v_data_buf_12 ->
 packed_prefix 0 m b.
Proof.
 intros m b INIT VAR.
 pose proof(source_initial_range PprzTrigInit.Source.prog m b PprzTrigInit.Source.v_data_buf_12 INIT VAR)as R.
 change(Mem.range_perm m b 0 9651 Cur Writable)in R.
 pose proof(source_initial_data PprzTrigInit.Source.prog m b PprzTrigInit.Source.v_data_buf_12 INIT VAR eq_refl)as D.
 change(Genv.read_as_zero m b 0 9651 /\ True)in D. destruct D as[ZERO _].
 split;[exact R|]. intros i I. rewrite buffer_view_zero by exact I.
 apply(ZERO Mint8unsigned i);cbn [size_chunk align_chunk];try lia;exists i;lia.
Qed.
