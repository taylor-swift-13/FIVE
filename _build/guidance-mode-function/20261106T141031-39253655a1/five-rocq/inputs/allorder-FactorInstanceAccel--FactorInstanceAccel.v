From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Maps Integers Floats AST Values Memory Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cexec Cstrategy Smallstep.
From FiveGuidanceEntry Require Import Entry SoftwareSqrt BigstepSupport AccelPrefix SaturationBodyAccel.
From FiveGuidanceAllOrder Require Import PhaseComposition PhaseWiring FactorShell LeafInstances.
Import ListNotations.
Theorem factor_certificate:forall e m bn bf bc n maximum f k,
 sqrt_call_contract ->e!S._five_sqrtf=None ->e!S._gh_max_accel=None ->
 Genv.find_symbol ge S._gh_max_accel=Some bc ->
 e!S._a_norm2=Some(bn,tfloat) ->e!S._factor=Some(bf,tfloat) ->
 Mem.load Mfloat32 m bn 0=Some(Vsingle n) ->Mem.load Mfloat32 m bc 0=Some(Vsingle maximum) ->
 Mem.valid_access m Mfloat32 bf 0 Writable ->
 exists mf mc P,
 certificate ge P(State f Sskip k e mf) /\P(State f factor_statement k e m) /\
 Mem.store Mfloat32 mc bf 0(Vsingle(Float32.div maximum(software_sqrt n)))=Some mf /\
 access_preserved m mf /\
 (forall ch b ofs,Mem.valid_block m b ->b<>bf ->Mem.load ch mf b ofs=Mem.load ch m b ofs) /\
 (forall b ofs nbytes,Mem.valid_block m b ->b<>bf ->Mem.loadbytes mf b ofs nbytes=Mem.loadbytes m b ofs nbytes).
Proof.
 intros e m bn bf bc n maximum f k CONTRACT ES EM SYM LN LF LOADN LOADC ACCESS.
 destruct(CONTRACT m n)as[mc[CALL[KEEP[FRAME BFRAME]]]].
 assert(CVALID:Mem.valid_block m bc)by(eapply loaded_valid_block;exact LOADC).
 assert(LOADMC:Mem.load Mfloat32 mc bc 0=Some(Vsingle maximum))by(rewrite FRAME by exact CVALID;exact LOADC).
 destruct(Mem.valid_access_store mc Mfloat32 bf 0(Vsingle(Float32.div maximum(software_sqrt n)))(KEEP _ _ _ _ ACCESS))as[mf STORE].
 pose proof(funcall_original_normal _ _ _ _ _ _ _ CALL)as WIT.
 exists mf,mc,(factor_invariant ge e f k S._factor S._gh_max_accel S._five_sqrtf S._a_norm2 bf bc sqrt_block bn m maximum n(software_sqrt n)mc mf).
 split.
 - split.
   + eapply factor_progress with(leaf:=S.f_five_sqrtf);
     eauto using single_deref,single_assign,sqrt_symbol,sqrt_funct,accel_leaf_syntax,accel_leaf_names;reflexivity.
   + eapply factor_all_successors with(leaf:=S.f_five_sqrtf);
     eauto using single_deref,single_assign,sqrt_symbol,sqrt_funct,accel_leaf_syntax,accel_leaf_names;reflexivity.
 - split;[left;reflexivity|]. split;[exact STORE|]. split.
   + unfold access_preserved in *;intros;eapply Mem.store_valid_access_1;[exact STORE|apply KEEP;assumption].
   + split.
     * intros ch b ofs VB D;erewrite Mem.load_store_other by(exact STORE||(left;exact D));apply FRAME;exact VB.
     * intros b ofs nbytes VB D;erewrite Mem.loadbytes_store_other by(exact STORE||(left;exact D));apply BFRAME;exact VB.
Qed.
Print Assumptions factor_certificate.
