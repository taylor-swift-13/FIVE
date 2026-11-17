From Stdlib Require Import ZArith Lia.
From compcert Require Import Coqlib Maps AST Integers Values Memory Memdata Events Ctypes Cop Csyntax Csem Smallstep.
From PidPositionRunPos Require Import Execution.
From PidPositionTranslationProblem Require Import Spec.
From PidPositionSafety Require Import MappedEntrySafety ReachableAccess.
Open Scope Z_scope.
Module E:=PidPositionRunPos.Execution.
Definition ready_copy(dst src:block)(od os:ptrofs)(ty:type):expr:=
 Eassign(Eloc dst od Full ty)(Eval(Vptr src os)ty)ty.
Inductive copy_hole(dst src:block)(od os:ptrofs)(ty:type):kind->(expr->expr)->expr->Prop:=
| cp_whole:copy_hole dst src od os ty RV(fun x=>x)(ready_copy dst src od os ty)
| cp_lhs:copy_hole dst src od os ty LV(fun x=>Eassign x(Eval(Vptr src os)ty)ty)(Eloc dst od Full ty)
| cp_rhs:copy_hole dst src od os ty RV(fun x=>Eassign(Eloc dst od Full ty)x ty)(Eval(Vptr src os)ty).
Lemma copy_context_decompose:forall from C a dst src od os ty,
 context from RV C ->C a=ready_copy dst src od os ty ->copy_hole dst src od os ty from C a.
Proof.
 intros from C a dst src od os ty CT EQ;unfold ready_copy in EQ.
 inversion CT;subst;cbn in EQ;try discriminate.
 - subst;constructor.
 - inversion EQ;subst.
   match goal with CT0:Csem.context _ LV ?D,EQ0:?D a=Eloc _ _ _ _|-_=>
   inversion CT0;subst;cbn in EQ0;try discriminate end.
   subst;constructor.
 - inversion EQ;subst.
   match goal with CT0:Csem.context _ RV ?D,EQ0:?D a=Eval _ _|-_=>
   inversion CT0;subst;cbn in EQ0;try discriminate end.
   subst;constructor.
Qed.
Lemma ready_copy_safe:forall ge e m dst src od os ty,
 imm_safe ge e RV(ready_copy dst src od os ty)m ->
 exists vc t mf copied,sem_cast(Vptr src os)ty ty m=Some vc/\
 assign_loc ge ty m dst od Full vc t mf copied.
Proof.
 intros ge e m dst src od os ty SAFE;unfold ready_copy in SAFE;inversion SAFE;subst.
 all:match goal with CT:Csem.context ?from RV ?C,
 EQ:?C ?a=Eassign(Eloc ?dd ?do Full ?tt)(Eval(Vptr ?ss ?so)?tt)?tt|-_=>
 pose proof(copy_context_decompose from C a dd ss do so tt CT EQ)as HH;inversion HH;subst end.
 - match goal with RED:lred _ _ _ _ _ _|-_=>inversion RED end.
 - match goal with RED:rred _ _ _ _ _ _|-_=>inversion RED;subst end.
   do 4 eexists;split;eassumption.
 - match goal with RED:rred _ _ _ _ _ _|-_=>inversion RED end.
 - match goal with RED:callred _ _ _ _ _ _|-_=>inversion RED end.
 - match goal with RED:callred _ _ _ _ _ _|-_=>inversion RED end.
Qed.
Theorem original_ready_copy_access:forall m gh ret flight,
 InputGood m gh ret ->forall t f C k e ma dst src od os ty,
 star Csem.step E.ge(E.entry(call_args gh ret flight)m)t
 (ExprState f(C(ready_copy dst src od os ty))k e ma) ->
 context RV RV C ->access_mode ty=By_copy ->
 sem_cast(Vptr src os)ty ty ma=Some(Vptr src os) ->
 exists bytes mf,
 Mem.loadbytes ma src(Ptrofs.unsigned os)(sizeof E.ge ty)=Some bytes /\
 Mem.storebytes ma dst(Ptrofs.unsigned od)bytes=Some mf /\
 Mem.range_perm ma src(Ptrofs.unsigned os)(Ptrofs.unsigned os+sizeof E.ge ty)Cur Readable.
Proof.
 intros m gh ret flight GOOD t f C k e ma dst src od os ty PATH CT AM CAST.
 pose proof(original_reachable_not_stuck m gh ret flight GOOD t f _ k e ma PATH)as NS.
 destruct(ready_copy_safe E.ge e ma dst src od os ty(NS RV C _ CT eq_refl))
 as[vc[tr[mf[copied[CV AS]]]]].
 rewrite CAST in CV;injection CV as EQ;subst vc.
 inversion AS;subst;try congruence.
 do 2 eexists;split;[eassumption|];split;[eassumption|eapply Mem.loadbytes_range_perm;eassumption].
Qed.
Theorem original_ready_copy_span:forall m gh ret flight,
 InputGood m gh ret ->forall t f C k e ma dst src od os ty,
 star Csem.step E.ge(E.entry(call_args gh ret flight)m)t
 (ExprState f(C(ready_copy dst src od os ty))k e ma) ->
 context RV RV C ->access_mode ty=By_copy ->
 sem_cast(Vptr src os)ty ty ma=Some(Vptr src os) ->
 0<sizeof E.ge ty ->readable_span ma src(Ptrofs.unsigned os)(sizeof E.ge ty).
Proof.
 intros m gh ret flight GOOD t f C k e ma dst src od os ty PATH CT AM CAST POS.
 destruct(original_ready_copy_access m gh ret flight GOOD t f C k e ma dst src od os ty PATH CT AM CAST)
 as[bytes[mf[READ[WRITE RANGE]]]].
 apply range_readable_span;assumption.
Qed.
Print Assumptions original_ready_copy_access.
Print Assumptions original_ready_copy_span.
