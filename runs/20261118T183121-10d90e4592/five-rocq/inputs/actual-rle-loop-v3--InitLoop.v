From Stdlib Require Import List ZArith Lia Bool.
From compcert Require Import Coqlib Maps AST Integers Values Memory Ctypes Ctypesdefs Cop Csyntax Csem Cstrategy.
Require PprzTrigInit.Source PprzTrigInit.Execution.
From PprzTrigRelationSupport Require Import PureEval Total TrigData TrigTrace TrigEmission InitState.
From PprzTrigInitSupport Require Import Control.
Import ListNotations.
Open Scope Z_scope.
Fixpoint sequence_tail(n:nat)(s:statement):statement :=
 match n,s with O,_=>s |S k,Ssequence _ t=>sequence_tail k t|_,_=>Sskip end.
Definition outer_with_init := match sequence_tail 4(fn_body PprzTrigInit.Source.f_pprz_trig_int_init)with Ssequence s _=>s|_=>Sskip end.
Definition outer_condition := match outer_with_init with Sfor _ c _ _=>c|_=>Eval Vundef tint end.
Definition outer_body := match outer_with_init with Sfor _ _ _ b=>b|_=>Sskip end.
Definition outer_loop := Sfor Sskip outer_condition Sskip outer_body.
Definition chunk_suffix(cs:list chunk):Prop := exists pre,literal_chunks=pre++cs.
Definition frontier_pos(cs:list chunk):Z := match cs with c::_=>pos c|[]=>3379 end.
Lemma suffix_tail : forall c cs,chunk_suffix(c::cs)->chunk_suffix cs.
Proof. intros c cs[pre E]. exists(pre++[c]);rewrite E,<-app_assoc;reflexivity. Qed.
Lemma suffix_head_in : forall c cs,chunk_suffix(c::cs)->In c literal_chunks.
Proof. intros c cs[pre E];rewrite E;apply in_or_app;right;cbn;auto. Qed.
Lemma outer_condition_shape : outer_condition=
 Ebinop Olt(Evalof(Evar PprzTrigInit.Source._i tshort)tshort)(Eval(Vint(Int.repr 3379))tint)tint.
Proof. reflexivity. Qed.
Lemma short_read_value : forall ge e m id z,short_cell e m id z ->
 pure_rval ge e m(Evalof(Evar id tshort)tshort)=Some(Vint(Int.repr z)).
Proof.
 intros ge e m id z[b[B[L R]]].
 cbn [pure_rval pure_lval typeof]. rewrite dec_eq_true,B,dec_eq_true.
 cbn [Cexec.do_deref_loc type_is_volatile attr_of_type attr_volatile noattr access_mode Mem.loadv].
 rewrite Ptrofs.unsigned_zero. try rewrite zle_true by(change(2<=18446744073709551616);lia).
 exact L.
Qed.
Lemma outer_guard_value : forall e m z,short_cell e m PprzTrigInit.Source._i z ->
 pure_rval PprzTrigInit.Execution.ge e m outer_condition=Some(Val.of_bool(Int.cmp Clt(Int.repr z)(Int.repr 3379))).
Proof.
 intros e m z C. rewrite outer_condition_shape.
 change(match pure_rval PprzTrigInit.Execution.ge e m(Evalof(Evar PprzTrigInit.Source._i tshort)tshort)with
 |Some v=>sem_binary_operation PprzTrigInit.Execution.ge Olt v tshort(Vint(Int.repr 3379))tint m|None=>None end=_).
 rewrite(short_read_value _ _ _ _ _ C). reflexivity.
Qed.
Lemma outer_guard_true : forall e m z,0<=z<3379 ->short_cell e m PprzTrigInit.Source._i z ->
 pure_rval PprzTrigInit.Execution.ge e m outer_condition=Some(Vint Int.one).
Proof.
 intros e m z Z C;rewrite(outer_guard_value _ _ _ C). unfold Int.cmp,Int.lt.
 rewrite!Int.signed_repr by(change(-2147483648<=_<=2147483647);lia).
 rewrite zlt_true by lia;reflexivity.
Qed.
Lemma outer_guard_false : forall e m,short_cell e m PprzTrigInit.Source._i 3379 ->
 pure_rval PprzTrigInit.Execution.ge e m outer_condition=Some(Vint Int.zero).
Proof.
 intros e m C;rewrite(outer_guard_value _ _ _ C). vm_compute;reflexivity.
Qed.
Theorem rle_outer_loop_total : forall Q k e(P:list chunk->mem->Prop),
 (forall cs m,chunk_suffix cs->P cs m->short_cell e m PprzTrigInit.Source._i(frontier_pos cs)) ->
 (forall m,P[]m->Total.total PprzTrigInit.Execution.ge Q(State PprzTrigInit.Source.f_pprz_trig_int_init Sskip k e m)) ->
 (forall c cs m,chunk_suffix(c::cs)->P(c::cs)m ->
  (forall mf,P cs mf->Total.total PprzTrigInit.Execution.ge Q
    (State PprzTrigInit.Source.f_pprz_trig_int_init Sskip(Kfor3 outer_condition Sskip outer_body k)e mf)) ->
  Total.total PprzTrigInit.Execution.ge Q
    (State PprzTrigInit.Source.f_pprz_trig_int_init outer_body(Kfor3 outer_condition Sskip outer_body k)e m)) ->
 forall cs m,chunk_suffix cs->P cs m ->Total.total PprzTrigInit.Execution.ge Q
 (State PprzTrigInit.Source.f_pprz_trig_int_init outer_loop k e m).
Proof.
 intros Q k e P CELL FINISH BODY cs;induction cs as[|c cs IH];intros m SUF INV;unfold outer_loop.
 - eapply for_false_pure_total with(v:=Vint Int.zero).
   + reflexivity.
   + apply outer_guard_false;apply CELL with(cs:=[]);assumption.
   + reflexivity.
   + apply FINISH;exact INV.
 - eapply for_true_pure_total with(v:=Vint Int.one).
   + reflexivity.
   + apply outer_guard_true with(z:=pos c).
     * pose proof(literal_chunk_bounds c(suffix_head_in c cs SUF))as H.
       repeat match goal with H:_/\_ |- _=>destruct H end.
       unfold consumed in *;destruct(multi c);cbn in *;lia.
     * exact(CELL(c::cs)m SUF INV).
   + reflexivity.
   + apply BODY with(c:=c)(cs:=cs);auto.
     intros mf POST;apply for_skip_body_total;apply for_skip_advance_total.
     apply IH;[apply suffix_tail with(c:=c);exact SUF|exact POST].
Qed.
