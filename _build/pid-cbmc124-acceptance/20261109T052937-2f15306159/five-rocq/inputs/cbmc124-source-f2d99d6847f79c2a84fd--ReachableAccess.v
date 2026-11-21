From Stdlib Require Import Classical ZArith Lia.
From compcert Require Import Coqlib Maps AST Integers Values Memory Events Ctypes Cop Csyntax Csem Smallstep.
From PidPositionRunPos Require Import Source Execution.
From PidPositionTranslationProblem Require Import Spec.
From PidPositionTranslationAttempt002 Require Import MainGoals.
From PidPositionSafety Require Import MappedEntrySafety.
Open Scope Z_scope.
Module E:=PidPositionRunPos.Execution.
Lemma stuck_source_error:E.source_error Stuckstate.
Proof.
 split.
 - intros[v[m EQ]];discriminate.
 - intros t next[ES|SS];inversion ES||inversion SS.
Qed.
Theorem original_reachable_not_stuck:forall m gh ret flight,
 InputGood m gh ret ->forall t f a k e ma,
 star Csem.step E.ge(E.entry(call_args gh ret flight)m)t(ExprState f a k e ma) ->
 not_stuck E.ge e a ma.
Proof.
 intros m gh ret flight GOOD t f a k e ma PATH from C red CT EQ.
 apply NNPP;intro UNSAFE.
 assert(STEP:Csem.step E.ge(ExprState f a k e ma)E0 Stuckstate).
 { rewrite EQ;left;eapply step_stuck;[exact CT|exact UNSAFE]. }
 assert(BADPATH:star Csem.step E.ge(E.entry(call_args gh ret flight)m)(t**E0)Stuckstate).
 { eapply star_trans;[exact PATH|apply star_one;exact STEP|reflexivity]. }
 exact(proved_no_error gh ret m flight GOOD(t**E0)Stuckstate BADPATH stuck_source_error).
Qed.
Definition ready_read(b:block)(ofs:ptrofs)(ty:type):expr:=Evalof(Eloc b ofs Full ty)ty.
Inductive read_hole(b:block)(ofs:ptrofs)(ty:type):kind->(expr->expr)->expr->Prop:=
| rh_whole:read_hole b ofs ty RV(fun x=>x)(ready_read b ofs ty)
| rh_loc:read_hole b ofs ty LV(fun x=>Evalof x ty)(Eloc b ofs Full ty).
Lemma read_context_decompose:forall from C a b ofs ty,
 context from RV C ->C a=ready_read b ofs ty ->read_hole b ofs ty from C a.
Proof.
 intros from C a b ofs ty CT EQ;unfold ready_read in EQ.
 inversion CT;subst;cbn in EQ;try discriminate.
 - subst;constructor.
 - inversion EQ;subst.
   match goal with CT0:Csem.context _ LV ?D,EQ0:?D a=Eloc _ _ _ _|-_=>
   inversion CT0;subst;cbn in EQ0;try discriminate end.
   subst;constructor.
Qed.
Lemma ready_read_safe:forall ge e m b ofs ty,
 imm_safe ge e RV(ready_read b ofs ty)m ->
 exists t v,deref_loc ge ty m b ofs Full t v.
Proof.
 intros ge e m b ofs ty SAFE;unfold ready_read in SAFE;inversion SAFE;subst.
 all:match goal with CT:Csem.context ?from RV ?C,EQ:?C ?a=Evalof(Eloc ?bb ?oo Full ?tt)?tt|-_=>
 pose proof(read_context_decompose from C a bb oo tt CT EQ)as HH;inversion HH;subst end.
 - match goal with RED:lred _ _ _ _ _ _|-_=>inversion RED end.
 - match goal with RED:rred _ _ _ _ _ _|-_=>inversion RED;subst end.
   eauto.
 - match goal with RED:callred _ _ _ _ _ _|-_=>inversion RED end.
Qed.
Lemma nonvolatile_scalar_read:forall ge e m b ofs ty chunk,
 access_mode ty=By_value chunk ->type_is_volatile ty=false ->
 imm_safe ge e RV(ready_read b ofs ty)m ->
 exists v,Mem.load chunk m b(Ptrofs.unsigned ofs)=Some v.
Proof.
 intros ge e m b ofs ty chunk AM NV SAFE.
 destruct(ready_read_safe ge e m b ofs ty SAFE)as[t[v D]];inversion D;subst;try congruence.
 rewrite AM in H;injection H as SAME;subst chunk0.
 unfold Mem.loadv in H1;destruct(zle(Ptrofs.unsigned ofs+size_chunk chunk)Ptrofs.modulus)in H1;try discriminate.
 exists v;exact H1.
Qed.
Theorem original_ready_read_access:forall m gh ret flight,
 InputGood m gh ret ->forall t f C k e ma b ofs ty chunk,
 star Csem.step E.ge(E.entry(call_args gh ret flight)m)t
 (ExprState f(C(ready_read b ofs ty))k e ma) ->
 context RV RV C ->access_mode ty=By_value chunk ->type_is_volatile ty=false ->
 exists v,Mem.load chunk ma b(Ptrofs.unsigned ofs)=Some v /\
 Mem.valid_access ma chunk b(Ptrofs.unsigned ofs)Readable.
Proof.
 intros m gh ret flight GOOD t f C k e ma b ofs ty chunk PATH CT AM NV.
 pose proof(original_reachable_not_stuck m gh ret flight GOOD t f _ k e ma PATH)as NS.
 destruct(nonvolatile_scalar_read E.ge e ma b ofs ty chunk AM NV(NS RV C _ CT eq_refl))as[v LOAD].
 exists v;split;[exact LOAD|eapply Mem.load_valid_access;exact LOAD].
Qed.
Theorem original_ready_int32_read_span:forall m gh ret flight,
 InputGood m gh ret ->forall t f C k e ma b ofs,
 star Csem.step E.ge(E.entry(call_args gh ret flight)m)t
 (ExprState f(C(ready_read b ofs(Tint I32 Signed noattr)))k e ma) ->
 context RV RV C ->readable_span ma b(Ptrofs.unsigned ofs)4.
Proof.
 intros m gh ret flight GOOD t f C k e ma b ofs PATH CT.
 destruct(original_ready_read_access m gh ret flight GOOD t f C k e ma b ofs
 (Tint I32 Signed noattr)Mint32 PATH CT eq_refl eq_refl)as[v[LOAD ACCESS]].
 apply range_readable_span;[lia|exact(proj1 ACCESS)].
Qed.
Print Assumptions original_ready_read_access.
Print Assumptions original_ready_int32_read_span.
