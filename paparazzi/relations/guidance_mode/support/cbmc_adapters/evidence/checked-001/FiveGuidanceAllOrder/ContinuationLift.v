From Stdlib Require Import Bool List ZArith.
From compcert Require Import Coqlib Errors Maps Integers Floats AST Values Memory Events Globalenvs Ctypes Cop Csyntax Csem Cexec Cstrategy Smallstep.
From FiveGuidanceAllOrder Require Import PureSyntax PureDenotation PureProgress AtomicDenotation AtomicProgress CallfreeExecution.
Import ListNotations.

Fixpoint plug_cont(base k:cont):cont :=
 match k with
 | Kstop=>base
 | Kseq s k=>Kseq s(plug_cont base k)
 | Kdo k=>Kdo(plug_cont base k)
 | Kifthenelse s1 s2 k=>Kifthenelse s1 s2(plug_cont base k)
 | Kreturn k=>Kreturn(plug_cont base k)
 | _=>k end.
Definition plug_state(base:cont)(s:Csem.state):Csem.state :=
 match s with
 | State f s k e m=>State f s(plug_cont base k)e m
 | ExprState f a k e m=>ExprState f a(plug_cont base k)e m
 | Callstate fd args k m=>Callstate fd args(plug_cont base k)m
 | Returnstate v k m=>Returnstate v(plug_cont base k)m
 | Stuckstate=>Stuckstate end.
Lemma plug_cont_call: forall base k,
 is_call_cont base -> normal_cont k=true -> call_cont(plug_cont base k)=base.
Proof.
 intros base k BASE;induction k;simpl;intros;core_unpack;try discriminate;auto.
 destruct base;simpl in BASE;try contradiction;reflexivity.
Qed.
Lemma plug_cont_is_call: forall base k,
 normal_cont k=true -> is_call_cont(plug_cont base k) ->
 k=Kstop /\ is_call_cont base.
Proof. destruct k;simpl;intros;core_unpack;try discriminate;tauto. Qed.
Lemma plug_normal_sstep: forall ge base s t next,
 is_call_cont base -> normal_state s=true -> Csem.sstep ge s t next ->
 Csem.sstep ge(plug_state base s)t(plug_state base next).
Proof.
 intros ge base s t next BASE NORMAL STEP.
 inversion STEP;subst;simpl in NORMAL;core_unpack;try discriminate;
 cbn[plug_state plug_cont];try solve[constructor;auto].
 - replace(plug_cont base(call_cont k))with(call_cont(plug_cont base k)).
   + eapply step_return_0;eauto.
   + rewrite(normal_cont_call _ NORMAL);cbn[plug_cont];apply plug_cont_call;auto.
 - replace(plug_cont base(call_cont k))with(call_cont(plug_cont base k)).
   + eapply step_return_2;eauto.
   + rewrite(normal_cont_call _ NORMAL);cbn[plug_cont];apply plug_cont_call;auto.
 - assert(HK:k=Kstop) by(eapply normal_cont_is_call;eauto);subst;cbn[plug_cont].
   eapply step_skip_call;eauto.
 - destruct k;simpl in NORMAL;try discriminate;cbn[plug_cont].
   eapply step_internal_function;eauto.
Qed.
Lemma plug_normal_estep: forall ge base s t next,
 normal_state s=true -> Csem.estep ge s t next ->
 Csem.estep ge(plug_state base s)t(plug_state base next).
Proof.
 intros ge base s t next NORMAL STEP;inversion STEP;subst;cbn[plug_state].
 - eapply step_lred;eauto.
 - eapply step_rred;eauto.
 - exfalso;eapply normal_no_callred;eauto.
 - eapply step_stuck;eauto.
Qed.
Theorem plug_normal_step: forall ge base s t next,
 is_call_cont base -> normal_state s=true -> Csem.step ge s t next ->
 Csem.step ge(plug_state base s)t(plug_state base next).
Proof.
 intros ge base s t next BASE NORMAL[ES|SS].
 - left;eapply plug_normal_estep;eauto.
 - right;eapply plug_normal_sstep;eauto.
Qed.
Theorem plug_normal_path: forall ge base s t next,
 is_call_cont base -> normal_state s=true -> star Csem.step ge s t next ->
 star Csem.step ge(plug_state base s)t(plug_state base next).
Proof.
 intros ge base s t next BASE NORMAL PATH;revert NORMAL.
 induction PATH;intros NORMAL;[constructor|].
 eapply star_step;[eapply plug_normal_step;eauto| |eauto].
 apply IHPATH;exact(proj1(normal_step_backward _ _ _ _ NORMAL H)).
Qed.
Print Assumptions plug_normal_path.

Lemma call_cont_plug_normal: forall base k,
 is_call_cont base -> normal_cont k=true ->
 plug_cont base(call_cont k)=call_cont(plug_cont base k).
Proof.
 intros;rewrite(normal_cont_call _ H0);cbn[plug_cont];symmetry;apply plug_cont_call;auto.
Qed.
Lemma plug_sstep_inverse: forall ge base s t next,
 is_call_cont base -> normal_state s=true -> ~normal_return s ->
 Csem.sstep ge(plug_state base s)t next ->
 exists raw,next=plug_state base raw /\ Csem.sstep ge s t raw.
Proof.
 intros ge base s t next BASE NORMAL NF STEP.
 destruct s as [f st k e m|f a k e m|fd args k m|v k m|];
 cbn[normal_state plug_state] in NORMAL,STEP;try discriminate.
 - destruct st;cbn[normal_stmt] in NORMAL;core_unpack;try discriminate;
   destruct k;cbn[normal_cont plug_cont] in *;core_unpack;try discriminate;
   try solve[inversion STEP;subst;eexists;split;[|econstructor;eauto];reflexivity].
   all: destruct base;cbn[is_call_cont] in BASE;try contradiction;
   cbn[plug_cont] in STEP;inversion STEP;subst;
   try solve[eexists;split;[|econstructor;eauto];reflexivity].
   all: eexists;split;[|eapply step_return_0;eauto];cbn[plug_state plug_cont call_cont].
   all: f_equal;symmetry;apply call_cont_plug_normal;auto.

 - destruct k;cbn[normal_state] in NORMAL;try discriminate;core_unpack;
   cbn[plug_cont] in STEP;inversion STEP;subst;
   try solve[eexists;split;[|econstructor;eauto];reflexivity].
   eexists;split;[|eapply step_return_2;eauto];cbn[plug_state plug_cont];
   f_equal;symmetry;apply call_cont_plug_normal;auto.
 - destruct fd;try discriminate;destruct k;try discriminate;cbn[plug_cont] in STEP.
   inversion STEP;subst;eexists;split;[|eapply step_internal_function;eauto];reflexivity.
 - destruct k;try discriminate;exfalso;apply NF;unfold normal_return;eauto.
 - inversion STEP.
Qed.

Lemma plug_estep_inverse: forall ge base s t next,
 normal_state s=true ->
 Csem.estep ge(plug_state base s)t next ->
 exists raw,next=plug_state base raw /\ Csem.estep ge s t raw.
Proof.
 intros ge base s t next NORMAL STEP.
 destruct s;cbn[plug_state] in STEP;try solve[inversion STEP].
 inversion STEP;subst.
 - eexists;split;[|eapply step_lred;eauto];reflexivity.
 - eexists;split;[|eapply step_rred;eauto];reflexivity.
 - exfalso;eapply normal_no_callred;eauto.
 - exists Stuckstate;split;[reflexivity|eapply step_stuck;eauto].
Qed.
Theorem plug_step_inverse: forall ge base s t next,
 is_call_cont base -> normal_state s=true -> ~normal_return s ->
 Csem.step ge(plug_state base s)t next ->
 exists raw,next=plug_state base raw /\ Csem.step ge s t raw.
Proof.
 intros ge base s t next BASE NORMAL NF[ES|SS].
 - destruct(plug_estep_inverse _ _ _ _ _ NORMAL ES)as [raw[EQ STEP]].
   exists raw;split;auto;left;exact STEP.
 - destruct(plug_sstep_inverse _ _ _ _ _ BASE NORMAL NF SS)as [raw[EQ STEP]].
   exists raw;split;auto;right;exact STEP.
Qed.
Print Assumptions plug_step_inverse.

Definition callee_invariant(ge:genv)(base:cont)(v:val)(mf:mem)(s:Csem.state):Prop :=
 exists raw,s=plug_state base raw /\ execution_invariant ge raw /\
 state_eval ge raw=Some(v,mf).
Lemma callee_invariant_entry: forall ge base initial tw v mf,
 normal_state initial=true -> call_names initial ->
 star Csem.step ge initial tw(Returnstate v Kstop mf) ->
 callee_invariant ge base v mf(plug_state base initial).
Proof.
 intros ge base initial tw v mf NORMAL NAMES WIT.
 pose proof(all_order_normal_correspondence ge initial tw v mf NORMAL WIT)as DEN.
 exists initial;split;auto;split;auto;split;auto;split;auto;exists(v,mf);exact DEN.
Qed.
Theorem callee_invariant_progress: forall ge base v mf s,
 is_call_cont base -> callee_invariant ge base v mf s ->
 s=Returnstate v base mf \/
 exists t next,Csem.step ge s t next /\ callee_invariant ge base v mf next.
Proof.
 intros ge base v mf s BASE[raw[EQ[INV DEN]]];subst s.
 destruct(invariant_progress ge raw INV)as [[vr[mr RETURN]]|[t[next STEP]]].
 - subst raw;cbn[state_eval] in DEN;inversion DEN;subst;left;reflexivity.
 - right;exists t,(plug_state base next);split.
   + apply plug_normal_step;auto;exact(proj1 INV).
   + exists next;split;auto;split.
     * eapply invariant_preserved;eauto.
     * exact(proj2(normal_step_forward _ _ _ _ _ (proj1 INV) DEN STEP)).
Qed.
Theorem callee_invariant_all_successors: forall ge base v mf s t next,
 is_call_cont base -> callee_invariant ge base v mf s ->
 s<>Returnstate v base mf -> Csem.step ge s t next ->
 callee_invariant ge base v mf next.
Proof.
 intros ge base v mf s t next BASE[raw[EQ[INV DEN]]] NF STEP;subst s.
 assert(NR:~normal_return raw).
 { intros[vr[mr RETURN]];subst raw;cbn[state_eval] in DEN;inversion DEN;subst.
   apply NF;reflexivity. }
 destruct(plug_step_inverse ge base raw t next BASE(proj1 INV)NR STEP)
  as [raw'[EQ STEP']].
 exists raw';split;auto;split.
 - eapply invariant_preserved;eauto.
 - exact(proj2(normal_step_forward _ _ _ _ _ (proj1 INV) DEN STEP')).
Qed.
Print Assumptions callee_invariant_all_successors.
Print Assumptions callee_invariant_progress.
