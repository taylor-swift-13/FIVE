From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Maps AST Integers Values Memory Ctypes Ctypesdefs Csyntax Csem Globalenvs.
Require PprzTrigInit.Source.
From PprzTrigRelationSupport Require Import TrigData TrigTrace TrigEmission PackedPrefix InitState ChunkMachine.
From PprzTrigInitSupport Require Import Frame.
Import ListNotations.
Open Scope Z_scope.
Definition init_local_ids:list ident :=map fst(fn_vars PprzTrigInit.Source.f_pprz_trig_int_init).
Record init_shape(e:env)(base:mem)(input buffer:block):Prop :={
 sh_cover:forall id,In id init_local_ids->exists b,e!id=Some(b,tshort);
 sh_domain:forall id b ty,e!id=Some(b,ty)->In id init_local_ids /\ty=tshort;
 sh_injective:forall id1 id2 b1 b2,e!id1=Some(b1,tshort)->e!id2=Some(b2,tshort)->id1<>id2->b1<>b2;
 sh_fresh:forall id b,e!id=Some(b,tshort)->~Mem.valid_block base b;
 sh_input_valid:Mem.valid_block base input;
 sh_buffer_valid:Mem.valid_block base buffer;
 sh_input_buffer:input<>buffer
}.
Record protocol_core(e:env)(base:mem)(input buffer:block)(m:mem):Prop :={
 pc_shape:init_shape e base input buffer;
 pc_freeable:forall id b,e!id=Some(b,tshort)->Mem.range_perm m b 0 2 Cur Freeable;
 pc_input:forall i,0<=i<1690->Mem.load Mint8unsigned m input i=Some(Vint(Int.repr(nth(Z.to_nat i)compressed_bytes 0)));
 pc_frame:Mem.unchanged_on(protected base buffer)base m
}.
Lemma shape_local_not_buffer : forall e base input buffer id b,
 init_shape e base input buffer->e!id=Some(b,tshort)->b<>buffer.
Proof. intros e base input buffer id b S B E;subst b;exact(sh_fresh _ _ _ _ S id buffer B(sh_buffer_valid _ _ _ _ S)). Qed.
Lemma shape_local_not_input : forall e base input buffer id b,
 init_shape e base input buffer->e!id=Some(b,tshort)->b<>input.
Proof. intros e base input buffer id b S B E;subst b;exact(sh_fresh _ _ _ _ S id input B(sh_input_valid _ _ _ _ S)). Qed.
Lemma protocol_core_frame : forall e base input buffer m mf,
 protocol_core e base input buffer m ->Mem.unchanged_on(protected m buffer)m mf ->
 protocol_core e base input buffer mf.
Proof.
 intros e base input buffer m mf C F. destruct C as[S FREE READ OLD]. constructor;[exact S| | |].
 - intros id b B i I. eapply Mem.perm_unchanged_on;[exact F| |apply(FREE id b B);exact I].
   split;[eapply Mem.perm_valid_block;apply(FREE id b B);exact I|eapply shape_local_not_buffer;eauto].
 - intros i I. eapply Mem.load_unchanged_on;[exact F| |apply READ;exact I].
   intros ofs RANGE;split.
   + eapply Mem.valid_block_unchanged_on;[exact OLD|exact(sh_input_valid _ _ _ _ S)].
   + exact(sh_input_buffer _ _ _ _ S).
 - apply Mem.unchanged_on_trans with m;[exact OLD|].
   eapply Mem.unchanged_on_implies;[exact F|]. intros b ofs[VALID NE]BEFORE;split;[eapply Mem.valid_block_unchanged_on;eauto|exact NE].
Qed.
Lemma protocol_core_local_store : forall e base input buffer m mf id b ch ofs v,
 protocol_core e base input buffer m ->e!id=Some(b,tshort)->Mem.store ch m b ofs v=Some mf ->
 protocol_core e base input buffer mf.
Proof.
 intros e base input buffer m mf id b ch ofs v C B STORE. destruct C as[S FREE READ OLD]. constructor;[exact S| | |].
 - intros id' b' B' i I. eapply Mem.perm_store_1;[exact STORE|apply(FREE id' b' B');exact I].
 - intros i I. erewrite Mem.load_store_other;[apply READ;exact I|exact STORE|]. left.
   intro E;apply(shape_local_not_input _ _ _ _ _ _ S B);congruence.
 - apply Mem.unchanged_on_trans with m;[exact OLD|]. eapply protected_store;[exact STORE|]. right;eapply sh_fresh;eauto.
Qed.
Definition previous_at(cnt:Z):Z :=if Z.eqb cnt 0 then 0 else table_at(cnt-1).
Definition frontier_count(cs:list chunk):Z :=match cs with c::_=>count_before c|[]=>6434 end.
Definition fixed_inner_cells(e:env)(m:mem)(c:chunk):Prop :=
 short_cell e m PprzTrigInit.Source._i(pos c+consumed c) /\short_cell e m PprzTrigInit.Source._tab_12 0 /\
 (if multi c then short_cell e m PprzTrigInit.Source._temp(third c) /\short_cell e m PprzTrigInit.Source._k(k_value c)
 else short_cell e m PprzTrigInit.Source._temp(first c)).
Inductive iteration_phase :=BeforeEncode|AfterEncode|AfterPrevious|AfterCount|AfterValue.
Definition iteration_count(c:chunk)(j:Z)(p:iteration_phase):Z :=count_before c+j+
 match p with AfterCount|AfterValue=>1|_=>0 end.
Definition iteration_value(c:chunk)(j:Z)(p:iteration_phase):Z :=value_before c+
 (j+match p with AfterValue=>1|_=>0 end)*delta c.
Definition iteration_prefix(c:chunk)(j:Z)(p:iteration_phase):Z :=count_before c+j+
 match p with BeforeEncode=>0|_=>1 end.
Definition iteration_previous(c:chunk)(j:Z)(p:iteration_phase):Z :=
 match p with BeforeEncode|AfterEncode=>previous_at(count_before c+j)|_=>value_before c+j*delta c end.
Definition iteration_inv(e:env)(base:mem)(input buffer:block)(c:chunk)(j:Z)(p:iteration_phase)(m:mem):Prop :=
 protocol_core e base input buffer m /\packed_prefix(iteration_prefix c j p)m buffer /\fixed_inner_cells e m c /\
 short_cell e m PprzTrigInit.Source._j j /\short_cell e m PprzTrigInit.Source._cnt(iteration_count c j p) /\
 short_cell e m PprzTrigInit.Source._val(iteration_value c j p) /\short_cell e m PprzTrigInit.Source._val_prev(iteration_previous c j p).
Definition outer_inv(e:env)(base:mem)(input buffer:block)(cs:list chunk)(m:mem):Prop :=
 protocol_core e base input buffer m /\packed_prefix(frontier_count cs)m buffer /\
 short_cell e m PprzTrigInit.Source._i(match cs with c::_=>pos c|[]=>3379 end) /\
 short_cell e m PprzTrigInit.Source._cnt(frontier_count cs) /\short_cell e m PprzTrigInit.Source._tab_12 0 /\
 match cs with c::_=>short_cell e m PprzTrigInit.Source._val(value_before c) /\
 short_cell e m PprzTrigInit.Source._val_prev(previous_at(count_before c))|[]=>True end.
