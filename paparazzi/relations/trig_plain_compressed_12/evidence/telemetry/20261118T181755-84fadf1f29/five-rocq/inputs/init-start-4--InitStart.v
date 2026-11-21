From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Maps AST Integers Values Memory Ctypes Ctypesdefs Cop Csyntax Csem Cstrategy Cexec.
Require PprzTrigInit.Source PprzTrigInit.Execution.
From PprzTrigRelationSupport Require Import InitProtocol InitLoop InitState InitAssign PackedPrefix PureEval Total TrigData.
From PprzTrigInitSupport Require Import Control InitAllocation InitFinish.
Import ListNotations.
Local Open Scope Z_scope.
Local Opaque PprzTrigInit.Source.prog.

Definition zero_assignment(id:ident):statement:=
 Sdo(Eassign(Evar id tshort)(Eval(Vint Int.zero)tint)tshort).
Definition zero_cells(ids:list ident)(e:env)(m:mem):Prop:=
 forall id,In id ids->short_cell e m id 0.
Fixpoint zero_sequence(ids:list ident)(tail:statement):statement:=
 match ids with []=>tail|id::rest=>Ssequence(zero_assignment id)(zero_sequence rest tail)end.

Lemma zero_assignment_cells_total : forall ge Q f k e base input buffer m id known,
 protocol_core e base input buffer m ->packed_prefix 0 m buffer ->In id init_local_ids ->
 zero_cells known e m ->
 (forall mf,protocol_core e base input buffer mf /\packed_prefix 0 mf buffer /\zero_cells(id::known)e mf ->
 Total.total ge Q(State f Sskip k e mf)) ->
 Total.total ge Q(State f(zero_assignment id)k e m).
Proof.
 intros ge Q f k e base input buffer m id known CORE PREFIX IN CELLS END.
 unfold zero_assignment;eapply short_assignment_action with(base:=base)(input:=input)(buffer:=buffer)(p:=0)(z:=0).
 - exact CORE.
 - exact PREFIX.
 - exact IN.
 - reflexivity.
 - reflexivity.
 - reflexivity.
 - right;left;reflexivity.
 - lia.
 - intros mf[C[P[NEW KEEP]]];apply END;split;[exact C|];split;[exact P|].
   intros id' IN';destruct IN' as[EQ|IN'];[subst id';exact NEW|].
   destruct(peq id' id)as[EQ|NE];[subst id';exact NEW|apply KEEP;[exact NE|apply CELLS;exact IN']].
Qed.

Lemma zero_sequence_total : forall ge Q f k e base input buffer ids known m tail,
 protocol_core e base input buffer m ->packed_prefix 0 m buffer ->
 (forall id,In id ids->In id init_local_ids) ->zero_cells known e m ->
 (forall mf,protocol_core e base input buffer mf /\packed_prefix 0 mf buffer /\zero_cells(ids++known)e mf ->
 Total.total ge Q(State f tail k e mf)) ->
 Total.total ge Q(State f(zero_sequence ids tail)k e m).
Proof.
 intros ge Q f k e base input buffer ids;induction ids as[|id rest IH];intros known m tail CORE PREFIX LOCALS CELLS END.
 - apply END;split;[exact CORE|];split;assumption.
 - cbn[zero_sequence];apply sequence_total.
   eapply zero_assignment_cells_total with(base:=base)(input:=input)(buffer:=buffer)(known:=known);try eassumption.
   + apply LOCALS;left;reflexivity.
   + intros mf[C[P Z]];apply skip_sequence_total.
     apply(IH(id::known)mf tail C P).
     * intros x IN;apply LOCALS;right;exact IN.
     * exact Z.
     * intros mn[C'[P' Z']];apply END;split;[exact C'|];split;[exact P'|].
       intros x IN;apply Z';apply in_or_app.
       change(id=x \/In x(rest++known))in IN.
       destruct IN as[EQ|IN];[right;left;exact EQ|].
       apply in_app_or in IN;destruct IN as[IN|IN];[left;exact IN|right;right;exact IN].
Qed.

Definition init_first_ids:=[PprzTrigInit.Source._tab_12;PprzTrigInit.Source._cnt;
 PprzTrigInit.Source._val;PprzTrigInit.Source._val_prev].
Lemma init_body_prefix_shape : fn_body PprzTrigInit.Source.f_pprz_trig_int_init=
 zero_sequence init_first_ids(Ssequence outer_with_init init_finish_statement).
Proof. reflexivity. Qed.
Lemma init_outer_start_shape : outer_with_init=Sfor(zero_assignment PprzTrigInit.Source._i)
 outer_condition Sskip outer_body.
Proof. reflexivity. Qed.

Theorem init_body_prefix_total : forall Q k e base input buffer m,
 protocol_core e base input buffer m ->packed_prefix 0 m buffer ->
 (forall mf,outer_inv e base input buffer literal_chunks mf->
 Total.total PprzTrigInit.Execution.ge Q(State PprzTrigInit.Source.f_pprz_trig_int_init
   outer_loop(Kseq init_finish_statement k)e mf)) ->
 Total.total PprzTrigInit.Execution.ge Q(State PprzTrigInit.Source.f_pprz_trig_int_init
   (fn_body PprzTrigInit.Source.f_pprz_trig_int_init)k e m).
Proof.
 intros Q k e base input buffer m CORE PREFIX LOOP;rewrite init_body_prefix_shape.
 eapply zero_sequence_total with(base:=base)(input:=input)(buffer:=buffer)(known:=[]).
 - exact CORE.
 - exact PREFIX.
 - intros id IN;cbn[init_first_ids]in IN;destruct IN as[EQ|[EQ|[EQ|[EQ|BAD]]]];try contradiction;
   subst id;vm_compute;tauto.
 - intros id IN;contradiction.
 - intros mf[C[P CELLS]];apply sequence_total;rewrite init_outer_start_shape.
   apply for_start_total;[discriminate|].
   eapply zero_assignment_cells_total with(base:=base)(input:=input)(buffer:=buffer)(known:=init_first_ids++[]).
   + exact C.
   + exact P.
   + vm_compute;tauto.
   + exact CELLS.
   + intros mn[C'[P' CELLS']];apply skip_sequence_total;apply LOOP.
     change(protocol_core e base input buffer mn /\packed_prefix 0 mn buffer /\
       short_cell e mn PprzTrigInit.Source._i 0 /\short_cell e mn PprzTrigInit.Source._cnt 0 /\
       short_cell e mn PprzTrigInit.Source._tab_12 0 /\
       short_cell e mn PprzTrigInit.Source._val 0 /\short_cell e mn PprzTrigInit.Source._val_prev 0).
     split;[exact C'|];split;[exact P'|];repeat split;apply CELLS';cbn[init_first_ids];tauto.
Qed.

Theorem init_source_entry_prefix_total : forall Q k base input buffer,
 Mem.valid_block base input ->Mem.valid_block base buffer ->input<>buffer ->
 (forall i,0<=i<1690->Mem.load Mint8unsigned base input i=
   Some(Vint(Int.repr(nth(Z.to_nat i)compressed_bytes 0)))) ->packed_prefix 0 base buffer ->
 (forall e m,outer_inv e base input buffer literal_chunks m->
 Total.total PprzTrigInit.Execution.ge Q(State PprzTrigInit.Source.f_pprz_trig_int_init
   outer_loop(Kseq init_finish_statement k)e m)) ->
 Total.total PprzTrigInit.Execution.ge Q
 (Callstate(Internal PprzTrigInit.Source.f_pprz_trig_int_init)[]k base).
Proof.
 intros Q k base input buffer INPUT BUFFER DISTINCT READ PREFIX LOOP.
 destruct(init_entry_allocation base input buffer INPUT BUFFER DISTINCT READ PREFIX)
   as[e[mp[ALLOC[BIND[SHAPE[CORE[P EMPTY]]]]]]].
 eapply internal_function_total with(e:=e)(m1:=mp)(m2:=mp).
 - vm_compute;repeat constructor;intuition discriminate.
 - exact ALLOC.
 - exact BIND.
 - eapply init_body_prefix_total;[exact CORE|exact P|]. intros mf INV;apply LOOP;exact INV.
Qed.
