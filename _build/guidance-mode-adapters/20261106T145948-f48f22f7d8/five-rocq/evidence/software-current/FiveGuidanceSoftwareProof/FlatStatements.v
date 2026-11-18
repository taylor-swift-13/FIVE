From Stdlib Require Import Bool List ZArith.
From compcert Require Import Coqlib Errors Maps Integers Floats AST Values Memory Events Globalenvs Ctypes Cop Csyntax Csem Cexec Cstrategy.
From FiveGuidanceAllOrder Require Import PureSyntax PureDenotation PureProgress.
From FiveGuidanceEntry Require Import BigstepSupport.
Import ListNotations.
Lemma source_simple_implies_simple : forall a,source_simple a=true -> simple a=true.
Proof.
 induction a;simpl;intros H;try discriminate;auto;
 repeat match goal with H:_ && _=true |- _=>apply andb_true_iff in H;destruct H end;
 repeat rewrite andb_true_iff;auto.
Qed.
Definition source_flat (a:expr):bool :=
 match a with Eassign l r _=>source_simple l && source_simple r|_=>source_simple a end.
Lemma source_flat_implies_flat : forall a,source_flat a=true -> flat_expr a=true.
Proof.
 intros a H;destruct a;simpl in *;try reflexivity;try discriminate;try(eapply source_simple_implies_simple;exact H).
 all:apply andb_true_iff in H as[L R];apply andb_true_iff;split;first[assumption|apply source_simple_implies_simple;assumption].
Qed.
Lemma source_flat_simple : forall a,simple a=true -> source_flat a=source_simple a.
Proof. destruct a;simpl;intros H;try discriminate;reflexivity. Qed.
Lemma core_nonvolatile : forall a,core_expr a=true -> nv(typeof a)=true.
Proof. destruct a;simpl;intros H;core_unpack;auto;discriminate. Qed.
Lemma pure_expression_sound : forall ge e m a v,
 source_simple a=true -> pure_rval ge e m a=Some v ->
 Cstrategy.eval_expression ge e m a E0 m v.
Proof.
 intros ge e m a v SIMPLE EV;apply simple_expression.
 - eapply(proj1(pure_eval_big a ge e m (source_simple_implies_simple a SIMPLE)));exact EV.
 - exact SIMPLE.
Qed.
Lemma flat_statement_sound : forall ge e m a v mf,
 source_flat a=true -> core_expr a=true -> flat_eval ge e m a=Some(v,mf) ->
 Cstrategy.exec_stmt ge e m(Sdo a)E0 mf Out_normal.
Proof.
 intros ge e m a v mf SFL CORE EV;pose proof(source_flat_implies_flat a SFL)as FL.
 destruct(flat_split _ FL)as[SIMPLE|[l[r[ty[EQ[SL SR]]]]]].
 - rewrite(source_flat_simple a SIMPLE)in SFL.
   rewrite(flat_eval_simple ge e m a SIMPLE)in EV.
   destruct(pure_rval ge e m a)eqn:RV;try discriminate;inversion EV;subst.
   eapply Cstrategy.exec_Sdo;eapply pure_expression_sound;eauto.
 - subst a;simpl in CORE,SFL;core_unpack.
   unfold flat_eval in EV;option_cases EV;inversion EV;subst.
   match goal with L:pure_lval _ _ _ _=Some _ |- _=>
    pose proof(proj2(pure_eval_big _ ge e m SL)_ _ _ L)as LV end.
   match goal with R:pure_rval _ _ _ _=Some _ |- _=>
    pose proof(proj1(pure_eval_big _ ge e m SR)_ R)as RV end.
   match goal with D:Cexec.do_assign_loc _ _ _ _ _ _ _ _=Some _ |- _=>
    destruct(Cexec.do_assign_loc_sound _ _ _ _ _ _ _ _ _ _ _ _ D)as[AS PT] end.
   assert(SILENT:forall t b ofs bf vc mx vr,assign_loc ge(typeof l)m b ofs bf vc t mx vr -> t=E0).
   { intros tq bq oq bfq vq mq rq STORE;eapply(PureSyntax.assign_loc_silent ge(typeof l)m bq oq bfq vq tq mq rq);[apply(core_nonvolatile l);assumption|exact STORE]. }
   match goal with AS:assign_loc _ _ _ _ _ _ _ ?t _ _ |- _=>
    pose proof(SILENT _ _ _ _ _ _ _ AS)as Z;subst t end.
   eapply atomic_assign;[exact LV| |exact RV| |eassumption|eassumption|congruence].
   all: assumption.
Qed.

Fixpoint source_statement (s:statement):bool :=
 match s with
 | Sskip |Sreturn None=>true
 | Sdo a=>source_flat a && core_expr a
 | Sreturn(Some a)=>source_simple a && core_expr a
 | Ssequence a b=>source_statement a && source_statement b
 | Sifthenelse a yes no=>source_simple a && core_expr a && source_statement yes && source_statement no
 | _=>false end.
Fixpoint statement_eval (ge:genv)(e:env)(s:statement)(m:mem):option(outcome*mem) :=
 match s with
 | Sskip=>Some(Out_normal,m)
 | Sdo a=>match flat_eval ge e m a with Some(_,mf)=>Some(Out_normal,mf)|None=>None end
 | Ssequence a b=>match statement_eval ge e a m with
   |Some(Out_normal,mf)=>statement_eval ge e b mf
   |Some(out,mf)=>Some(out,mf)|None=>None end
 | Sifthenelse a yes no=>match pure_rval ge e m a with
   |Some v=>match bool_val v(typeof a)m with
     |Some b=>statement_eval ge e(if b then yes else no)m|None=>None end
   |None=>None end
 | Sreturn None=>Some(Out_return None,m)
 | Sreturn(Some a)=>match pure_rval ge e m a with
   |Some v=>Some(Out_return(Some(v,typeof a)),m)|None=>None end
 | _=>None end.
Theorem statement_eval_sound : forall s ge le m out mf,
 source_statement s=true -> statement_eval ge le s m=Some(out,mf) ->
 Cstrategy.exec_stmt ge le m s E0 mf out.
Proof.
 induction s;intros ge le m out mf VALID EV;simpl in VALID,EV;core_unpack;try discriminate.
 - inversion EV;subst;constructor.
 - destruct(flat_eval ge le m e)as[[v mx]|]eqn:F;try discriminate;inversion EV;subst.
   eapply flat_statement_sound;eauto.
 - destruct(statement_eval ge le s1 m)as[[o1 m1]|]eqn:F;try discriminate.
   destruct o1.
   + inversion EV;subst;eapply Cstrategy.exec_Sseq_2;[eapply IHs1;eauto|discriminate].
   + inversion EV;subst;eapply Cstrategy.exec_Sseq_2;[eapply IHs1;eauto|discriminate].
   + eapply sequence_normal with(ma:=m1);[eapply IHs1;[eassumption|exact F]|eapply IHs2;[eassumption|exact EV]].
   + inversion EV;subst;eapply Cstrategy.exec_Sseq_2;[eapply IHs1;eauto|discriminate].
 - destruct(pure_rval ge le m e)as[v|]eqn:R;try discriminate.
   destruct(bool_val v(typeof e)m)as[b|]eqn:B;try discriminate.
   replace E0 with(E0**E0)by reflexivity.
   eapply Cstrategy.exec_Sifthenelse;[eapply pure_expression_sound;eauto|exact B|].
   destruct b;[eapply IHs1|eapply IHs2];eauto.
 - destruct o as[a|];simpl in VALID,EV;core_unpack.
   + destruct(pure_rval ge le m a)as[v|]eqn:R;try discriminate;inversion EV;subst.
     eapply Cstrategy.exec_Sreturn_some;eapply pure_expression_sound;eauto.
   + inversion EV;subst;constructor.
Qed.
Print Assumptions statement_eval_sound.
