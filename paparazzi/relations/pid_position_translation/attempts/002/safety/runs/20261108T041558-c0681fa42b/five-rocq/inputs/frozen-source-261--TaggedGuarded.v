From Stdlib Require Import List Bool Classical.
From compcert Require Import Coqlib Maps AST Values Memory Events Ctypes Cop Csyntax Csem Cstrategy Smallstep.
From FiveGuidanceAllOrder Require Import PureSyntax PureDenotation CallfreeExecution ContinuationLift PureIfShell PhaseComposition.
Import ListNotations.

From PidPositionSafety Require Import GuardedCallee TaggedCallee.
Theorem tagged_guarded_callee_certificate:forall ge f m condition yes tail testval result,
 fn_params f=[] ->fn_vars f=[] ->
 fn_body f=Ssequence(Sifthenelse condition yes Sskip)tail ->
 simple condition=true ->pure_rval ge empty_env m condition=Some testval ->
 Cop.bool_val testval(typeof condition)m=Some false ->
 normal_stmt tail=true ->
 star Csem.step ge(State f tail Kstop empty_env m)E0(Returnstate result Kstop m) ->
 forall base,is_call_cont base ->
 exists P,certificate ge P(Returnstate result base m) /\P(Callstate(Internal f)[]base m)/\(forall s,P s->function_scope f s).
Proof.
 intros ge f m condition yes tail testval result PA VA BODY SI EV BOOL NT TAIL base BASE.
 set(Q:=tagged_callee_invariant ge f base result m).
 assert(QC:certificate ge Q(Returnstate result base m)).
 { split.
   - intros s INV;apply tagged_callee_progress;auto.
   - intros;eapply tagged_callee_successors;eauto. }
 assert(QI:Q(State f tail base empty_env m)).
 { pose proof(tagged_callee_entry ge f base(State f tail Kstop empty_env m)E0 result m
 ltac:(simpl;rewrite NT;reflexivity)I eq_refl TAIL)as H;exact H. }
 set(Q1:=fun s=>s=State f Sskip(Kseq tail base)empty_env m\/Q s).
 assert(C1:certificate ge Q1(Returnstate result base m)).
 { apply certificate_prepend with(next:=State f tail base empty_env m);auto using skip_sequence_unique. }
 pose proof(PureIfShell.if_certificate ge f empty_env(Kseq tail base)m condition yes Sskip testval false SI EV BOOL)as IF.
 set(PIF:=PureIfShell.invariant ge f empty_env(Kseq tail base)m condition yes Sskip testval false).
 set(Q2:=fun s=>PIF s\/Q1 s).
 assert(C2:certificate ge Q2(Returnstate result base m)).
 { eapply certificate_join;[exact IF|exact C1|left;reflexivity]. }
 assert(I2:Q2(State f(Sifthenelse condition yes Sskip)(Kseq tail base)empty_env m)).
 { left;apply PureIfShell.initial. }
 set(Q3:=fun s=>s=State f(fn_body f)base empty_env m\/Q2 s).
 assert(C3:certificate ge Q3(Returnstate result base m)).
 { apply certificate_prepend with(next:=State f(Sifthenelse condition yes Sskip)(Kseq tail base)empty_env m);auto.
   rewrite BODY;apply sequence_unique. }
 set(Q4:=fun s=>s=Callstate(Internal f)[]base m\/Q3 s).
 assert(C4:certificate ge Q4(Returnstate result base m)).
 { apply certificate_prepend with(next:=State f(fn_body f)base empty_env m);auto.
   - apply internal_nil_unique;auto.
   - left;reflexivity. }
 exists Q4;split;[exact C4|];split;[left;reflexivity|].
 intros s IN;unfold Q4,Q3,Q2,Q1 in IN.
 destruct IN as[EQ|[EQ|[IFP|[EQ|TAILP]]]];try(subst s;reflexivity).
 - unfold PIF,PureIfShell.invariant in IFP.
   destruct IFP as[EQ|[[a[EQ REST]]|EQ]];subst s;reflexivity.
 - eapply tagged_callee_scope;exact TAILP.
Qed.

Print Assumptions tagged_guarded_callee_certificate.
