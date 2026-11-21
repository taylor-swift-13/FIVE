From Stdlib Require Import List.
From compcert Require Import Coqlib AST Values Memory Events Determinism Ctypes Csyntax Csem Cexec Smallstep.
Require PprzTrigPlain.Source PprzTrigPlain.Execution PprzTrigLow.Source PprzTrigLow.Execution PprzTrigInit.Source PprzTrigInit.Execution.
From PprzTrigRelationSupport Require Import PlainCore PlainBody ClosedCalls.
Import ListNotations.
Definition exec_edge(ge:Csem.genv)(cb asm:PprzTrigPlain.Execution.callback)(w:world)(_:unit)(s:Csem.state)(t:trace)(next:Csem.state):Prop:=
 exists rule,In(TR rule t next)(Cexec.do_step ge cb asm w s).
Section TRACE_TRANSFER.
Variable ge:Csem.genv.
Variable start:Csem.state.
Variable cb asm:PprzTrigPlain.Execution.callback.
Variable w:world.
Hypothesis EDGE:forall prefix s t next,star Csem.step ge start prefix s ->
 (exec_edge ge cb asm w tt s t next <-> Csem.step ge s t next).
Lemma source_prefix_extend:forall p s t next,star Csem.step ge start p s ->Csem.step ge s t next ->
 star Csem.step ge start(p**t)next.
Proof. intros;eapply star_trans;[eassumption|apply star_one;eassumption|reflexivity]. Qed.
Lemma source_star_to_exec:forall s t next,star Csem.step ge s t next ->
 forall prefix,star Csem.step ge start prefix s ->star(exec_edge ge cb asm w)tt s t next.
Proof.
 intros s t next H;induction H;intros p P.
 - constructor.
 - eapply star_step;[apply(proj2(EDGE p s1 t1 s2 P));exact H| |exact H1].
   apply IHstar with(prefix:=p**t1);eapply source_prefix_extend;eauto.
Qed.
Lemma exec_star_to_source:forall s t next,star(exec_edge ge cb asm w)tt s t next ->
 forall prefix,star Csem.step ge start prefix s ->star Csem.step ge s t next.
Proof.
 intros s t next H;induction H;intros p P.
 - constructor.
 - assert(ST:Csem.step ge s1 t1 s2)by(apply(proj1(EDGE p s1 t1 s2 P));exact H).
   eapply star_step;[exact ST| |exact H1].
   apply IHstar with(prefix:=p**t1);eapply source_prefix_extend;eauto.
Qed.
Theorem finite_exact:forall t next,
 star(exec_edge ge cb asm w)tt start t next <->star Csem.step ge start t next.
Proof. intros;split;intro H;[eapply exec_star_to_source|eapply source_star_to_exec];[exact H|constructor|exact H|constructor]. Qed.
Lemma source_forever_to_exec:forall s p T,star Csem.step ge start p s ->
 forever Csem.step ge s T ->forever(exec_edge ge cb asm w)tt s T.
Proof.
 cofix CIH;intros s p T P F;inversion F;subst.
 econstructor;[apply(proj2(EDGE p s t s2 P));exact H|].
 eapply CIH;[eapply source_prefix_extend;[exact P|exact H]|exact H0].
Qed.
Lemma exec_forever_to_source:forall s p T,star Csem.step ge start p s ->
 forever(exec_edge ge cb asm w)tt s T ->forever Csem.step ge s T.
Proof.
 cofix CIH;intros s p T P F;inversion F;subst.
 assert(ST:Csem.step ge s t s2)by(apply(proj1(EDGE p s t s2 P));exact H).
 econstructor;[exact ST|].
 eapply CIH;[eapply source_prefix_extend;[exact P|exact ST]|exact H0].
Qed.
Theorem infinite_exact:forall T,forever(exec_edge ge cb asm w)tt start T <->forever Csem.step ge start T.
Proof. intros;split;intro H;[eapply exec_forever_to_source|eapply source_forever_to_exec];[constructor|exact H|constructor|exact H]. Qed.
Theorem exhaustion_exact:forall prefix s,star Csem.step ge start prefix s ->
 (nostep(exec_edge ge cb asm w)tt s <->nostep Csem.step ge s).
Proof.
 intros p s P;unfold nostep;split;intros N t next ST;apply(N t next).
 - apply(proj2(EDGE p s t next P));exact ST.
 - apply(proj1(EDGE p s t next P));exact ST.
Qed.
End TRACE_TRANSFER.
Lemma plain_body_core:PlainCore.core_stmt(fn_body PprzTrigPlain.Source.f_pprz_itrig_sin)=true.
Proof. reflexivity. Qed.
Lemma plain_reachable_core:forall args m prefix s,
 star Csem.step PprzTrigPlain.Execution.ge(PprzTrigPlain.Execution.entry args m)prefix s ->
 PlainCore.source_state PprzTrigPlain.Source.f_pprz_itrig_sin s.
Proof.
 intros args m prefix s H;remember(PprzTrigPlain.Execution.entry args m)as start eqn:E.
 assert(INV:PlainCore.source_state PprzTrigPlain.Source.f_pprz_itrig_sin start)by(subst start;split;reflexivity).
 clear E;induction H;[exact INV|]. apply IHstar;exact(proj2(PlainCore.source_step_invariant _ plain_body_core _ _ _ _ INV H)).
Qed.
Theorem plain_edge_exact:forall args m prefix s cb asm w t next,
 star Csem.step PprzTrigPlain.Execution.ge(PprzTrigPlain.Execution.entry args m)prefix s ->
 (exec_edge PprzTrigPlain.Execution.ge cb asm w tt s t next <->Csem.step PprzTrigPlain.Execution.ge s t next).
Proof. intros;eapply PlainCore.source_do_step_exact;eapply plain_reachable_core;eassumption. Qed.
Print Assumptions finite_exact.
Print Assumptions infinite_exact.
Print Assumptions plain_edge_exact.
