From Stdlib Require Import Bool List ZArith Lia.
From compcert Require Import Coqlib Errors Maps Integers Floats AST Values Memory Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cexec Cstrategy Smallstep.
From PprzTrigPlain Require Import Source Execution.
From PprzTrigRelationSupport Require Import Normalizer PlainCore PureEval PureProgress Total PlainBody.
From PprzTrigInitSupport Require Import Control.
Import ListNotations Csyntaxdefs.CsyntaxNotations.
Local Open Scope Z_scope.
Definition old_blocks(m:mem)(b:block)(_ofs:Z):Prop := Mem.valid_block m b.
Lemma fold_memory_frame : forall initial local a before after,
 ~Mem.valid_block initial local -> fold_memory local a before after ->
 Mem.unchanged_on(old_blocks initial)before after.
Proof.
 intros initial local a before after FRESH FM;unfold fold_memory in FM.
 destruct(Int.cmp Cgt a(Int.repr 6433));
 [eapply Mem.store_unchanged_on;[exact FM|intros;exact FRESH]|].
 destruct(Int.cmp Clt a(Int.repr(-6433)));
 [eapply Mem.store_unchanged_on;[exact FM|intros;exact FRESH]|].
 subst;apply Mem.unchanged_on_refl.
Qed.
Lemma fold_finish_frame : forall ge initial local a before after,
 ~Mem.valid_block initial local -> fold_finish ge local a before after ->
 Mem.unchanged_on(old_blocks initial)before after.
Proof.
 intros ge initial local a before after FRESH[mid[FM FREE]].
 eapply Mem.unchanged_on_trans;[eapply fold_memory_frame;eauto|].
 rewrite angle_env_blocks in FREE;cbn[Mem.free_list]in FREE.
 destruct(Mem.free mid local 0 4)eqn:F;try discriminate;inversion FREE;subst.
 eapply Mem.free_unchanged_on;[exact F|intros;exact FRESH].
Qed.
Lemma bind_angle : forall ge local m a m',Mem.store Mint32 m local 0(Vint a)=Some m' ->
 Cexec.sem_bind_parameters ge Control.quiet(angle_env local)m[(_angle,tint)][Vint a]=Some m'.
Proof.
 intros ge local m a m' STORE. apply sem_bind_parameters_complete.
 eapply bind_parameters_cons with(v1':=Vint a)(b:=local)(m1:=m').
 - unfold angle_env;apply PTree.gss.
 - eapply assign_loc_value with(chunk:=Mint32);try reflexivity.
   cbn[Mem.storev size_chunk]. rewrite Ptrofs.unsigned_zero.
   destruct(zle(0+4)Ptrofs.modulus);[exact STORE|].
   assert(PB:Ptrofs.modulus=18446744073709551616)by reflexivity;lia.
 - constructor.
Qed.
Theorem plain_entry_total : forall (ge:Csem.genv)m table a lookup,
 -12867<=Int.signed a<=12867 -> Genv.find_symbol ge _pprz_trig_int=Some table ->
 (forall n,0<=n<6434 -> Mem.load Mint16signed m table(2*n)=Some(Vint(lookup n))) ->
 Total.total ge
 (fun v mf=>v=Vint(table_result lookup(folded a)) /\ Mem.unchanged_on(old_blocks m)m mf)
 (Callstate(Internal fun_sin)[Vint a]Kstop m).
Proof.
 intros ge m table a lookup RANGE SYM TABLE.
 destruct(Mem.alloc m 0 4)as[m1 local]eqn:ALLOC.
 assert(FRESH:~Mem.valid_block m local)by(eapply Mem.fresh_block_alloc;eauto).
 assert(TVALID:Mem.valid_block m table).
 { eapply Mem.valid_access_valid_block.
   eapply Mem.valid_access_implies;[eapply Mem.load_valid_access;apply(TABLE 0);lia|constructor]. }
 assert(NE:table<>local)by(congruence).
 assert(VAF:Mem.valid_access m1 Mint32 local 0 Freeable).
 { eapply Mem.valid_access_alloc_same;[exact ALLOC|lia|cbn;lia|]. exists 0;reflexivity. }
 assert(VAW:Mem.valid_access m1 Mint32 local 0 Writable)by(eapply Mem.valid_access_freeable_any;eauto).
 destruct(Mem.valid_access_store _ _ _ _ (Vint a) VAW)as[m2 STORE].
 eapply internal_function_total with(e:=angle_env local)(m1:=m1)(m2:=m2).
 - cbn[fun_sin fn_params fn_vars var_names];repeat constructor;cbn;auto.
 - change(Cexec.do_alloc_variables ge empty_env m[(_angle,tint)]=(angle_env local,m1)).
   cbn[Cexec.do_alloc_variables];change(match Mem.alloc m 0 4 with
      |(mm,bb)=>(PTree.set _angle(bb,tint)empty_env,mm)end=(angle_env local,m1)).
   rewrite ALLOC;reflexivity.
 - apply bind_angle;exact STORE.
 - apply plain_body_total with(table:=table)(a:=a)(lookup:=lookup);auto.
   + exact(Mem.load_store_same _ _ _ _ _ _ STORE).
   + eapply Mem.store_valid_access_1;[exact STORE|exact VAW].
   + intros ofs B;eapply Mem.perm_store_1;[exact STORE|].
     exact(Mem.perm_alloc_2 _ _ _ _ _ ALLOC ofs Cur B).
   + intros n B. rewrite(Mem.load_store_other _ _ _ _ _ _ STORE Mint16signed table(2*n))by auto.
     rewrite(Mem.load_alloc_unchanged _ _ _ _ _ ALLOC Mint16signed table(2*n))by exact TVALID.
     apply TABLE;exact B.
   + intros mf FIN;split;[reflexivity|].
     eapply Mem.unchanged_on_trans with(m2:=m1).
     * eapply Mem.alloc_unchanged_on;exact ALLOC.
     * eapply Mem.unchanged_on_trans with(m2:=m2).
       -- eapply Mem.store_unchanged_on;[exact STORE|intros;exact FRESH].
       -- eapply fold_finish_frame;eauto.
Qed.

Lemma total_exists_return : forall ge Q s,Total.total ge Q s ->
 exists v mf t,star Csem.step ge s t(Returnstate v Kstop mf) /\ Q v mf.
Proof.
 intros ge Q s T;induction T.
 - exists v,m,[];split;[constructor|exact H].
 - destruct H as[t[next STEP]].
   destruct(H1 t next STEP)as[v[mf[u[PATH OBS]]]].
   exists v,mf,(t**u);split;auto. eapply star_left;eauto.
Qed.
Print Assumptions plain_entry_total.
