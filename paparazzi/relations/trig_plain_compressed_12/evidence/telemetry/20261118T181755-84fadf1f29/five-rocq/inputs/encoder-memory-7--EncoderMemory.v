From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Maps Integers AST Values Memory Events Globalenvs Ctypes Cop Csyntax Csem Cexec.
From PprzTrigInit Require Import Source.
From PprzTrigRelationSupport Require Import InitState.
From PprzTrigInitSupport Require Import Control PostIncrement FreeList.
Import ListNotations.
Local Open Scope Z_scope.
Local Opaque Source.prog.
Definition pointer_type := Tpointer short_type noattr.

Record encoder_setup (m:mem)(value previous count:Z)(tb:block)(tofs:ptrofs)
  (e:env)(mp:mem) : Prop := {
  es_entry : exists ma,
    do_alloc_variables (Csem.globalenv Source.prog) empty_env m
      (fn_params Source.f_table_encode_12++fn_vars Source.f_table_encode_12)=(e,ma) /\
    sem_bind_parameters (Csem.globalenv Source.prog) Control.quiet e ma
      (fn_params Source.f_table_encode_12)
      [Vint(Int.repr value);Vint(Int.repr previous);Vint(Int.repr count);Vptr tb tofs]=Some mp;
  es_value : short_cell e mp Source._val value;
  es_previous : short_cell e mp Source._val_prev previous;
  es_count : short_cell e mp Source._cnt count;
  es_pointer : exists b,e!Source._tab=Some(b,pointer_type) /\
    Mem.load Mptr mp b 0=Some(Vptr tb tofs);
  es_no_buffer_shadow : e!Source._data_buf_12=None;
  es_regions_distinct : NoDup(map region_block(blocks_of_env(Csem.globalenv Source.prog)e));
  es_regions_freeable : Forall(region_freeable mp)(blocks_of_env(Csem.globalenv Source.prog)e);
  es_regions_fresh : Forall(region_fresh m)(blocks_of_env(Csem.globalenv Source.prog)e);
  es_frame : Mem.unchanged_on(fun b _=>Mem.valid_block m b)m mp
}.

Lemma pointer_assign : forall ge w m b tb tofs mf,
  Mem.store Mptr m b 0(Vptr tb tofs)=Some mf ->
  Cexec.do_assign_loc ge w pointer_type m b Ptrofs.zero Full(Vptr tb tofs)=
    Some(w,E0,mf,Vptr tb tofs).
Proof.
  intros ge w m b tb tofs mf STORE.
  change (Mem.store Mint64 m b 0(Vptr tb tofs)=Some mf) in STORE.
  cbv beta iota zeta delta [Cexec.do_assign_loc pointer_type type_is_volatile
    attr_of_type attr_volatile noattr access_mode Mem.storev size_chunk Mptr Archi.ptr64].
  rewrite Ptrofs.unsigned_zero.
  rewrite STORE,zle_true by (change(8<=18446744073709551616);lia).
  reflexivity.
Qed.
Lemma freeable_writable : forall m ch b,
  Mem.valid_access m ch b 0 Freeable -> Mem.valid_access m ch b 0 Writable.
Proof. intros;eapply Mem.valid_access_implies;[eassumption|constructor]. Qed.
Lemma old_frame_store : forall initial ch m b ofs v mf,
  ~Mem.valid_block initial b -> Mem.store ch m b ofs v=Some mf ->
  Mem.unchanged_on(fun b _=>Mem.valid_block initial b)m mf.
Proof.
  intros;eapply Mem.store_unchanged_on;eauto;intros i RANGE OLD;contradiction.
Qed.

Theorem encoder_setup_exists : forall m value previous count tb tofs,
  0<=value<=16383 ->0<=previous<=16383 ->0<=count<=16383 ->
  exists e mp,encoder_setup m value previous count tb tofs e mp.
Proof.
  intros m value previous count tb tofs V P C.
  destruct(Mem.alloc m 0 2)as[a1 b1]eqn:A1.
  destruct(Mem.alloc a1 0 2)as[a2 b2]eqn:A2.
  destruct(Mem.alloc a2 0 2)as[a3 b3]eqn:A3.
  destruct(Mem.alloc a3 0 8)as[a4 b4]eqn:A4.
  assert(F1:~Mem.valid_block m b1)by(eapply Mem.fresh_block_alloc;eauto).
  assert(F2:~Mem.valid_block m b2).
  { intro OLD;apply(Mem.fresh_block_alloc _ _ _ _ _ A2);eauto using Mem.valid_block_alloc. }
  assert(F3:~Mem.valid_block m b3).
  { intro OLD;apply(Mem.fresh_block_alloc _ _ _ _ _ A3);eauto using Mem.valid_block_alloc. }
  assert(F4:~Mem.valid_block m b4).
  { intro OLD;apply(Mem.fresh_block_alloc _ _ _ _ _ A4);eauto using Mem.valid_block_alloc. }
  assert(D12:b1<>b2).
  { eapply(Mem.valid_not_valid_diff a1);[eapply Mem.valid_new_block;exact A1|eapply Mem.fresh_block_alloc;exact A2]. }
  assert(D13:b1<>b3).
  { eapply(Mem.valid_not_valid_diff a2).
    - eapply Mem.valid_block_alloc;[exact A2|eapply Mem.valid_new_block;exact A1].
    - eapply Mem.fresh_block_alloc;exact A3. }
  assert(D14:b1<>b4).
  { eapply(Mem.valid_not_valid_diff a3).
    - eapply Mem.valid_block_alloc;[exact A3|]. eapply Mem.valid_block_alloc;[exact A2|eapply Mem.valid_new_block;exact A1].
    - eapply Mem.fresh_block_alloc;exact A4. }
  assert(D23:b2<>b3).
  { eapply(Mem.valid_not_valid_diff a2);[eapply Mem.valid_new_block;exact A2|eapply Mem.fresh_block_alloc;exact A3]. }
  assert(D24:b2<>b4).
  { eapply(Mem.valid_not_valid_diff a3).
    - eapply Mem.valid_block_alloc;[exact A3|eapply Mem.valid_new_block;exact A2].
    - eapply Mem.fresh_block_alloc;exact A4. }
  assert(D34:b3<>b4).
  { eapply(Mem.valid_not_valid_diff a3);[eapply Mem.valid_new_block;exact A3|eapply Mem.fresh_block_alloc;exact A4]. }
  assert(VA1:Mem.valid_access a4 Mint16signed b1 0 Freeable).
  { eapply Mem.valid_access_alloc_other;[exact A4|].
    eapply Mem.valid_access_alloc_other;[exact A3|].
    eapply Mem.valid_access_alloc_other;[exact A2|].
    eapply Mem.valid_access_alloc_same;[exact A1|cbn;lia|cbn;lia|exists 0;reflexivity]. }
  assert(VA2:Mem.valid_access a4 Mint16signed b2 0 Freeable).
  { eapply Mem.valid_access_alloc_other;[exact A4|].
    eapply Mem.valid_access_alloc_other;[exact A3|].
    eapply Mem.valid_access_alloc_same;[exact A2|cbn;lia|cbn;lia|exists 0;reflexivity]. }
  assert(VA3:Mem.valid_access a4 Mint16signed b3 0 Freeable).
  { eapply Mem.valid_access_alloc_other;[exact A4|].
    eapply Mem.valid_access_alloc_same;[exact A3|cbn;lia|cbn;lia|exists 0;reflexivity]. }
  assert(VA4:Mem.valid_access a4 Mptr b4 0 Freeable).
  { change(Mem.valid_access a4 Mint64 b4 0 Freeable).
    eapply Mem.valid_access_alloc_same;[exact A4|cbn;lia|cbn;lia|exists 0;reflexivity]. }
  destruct(Mem.valid_access_store a4 Mint16signed b1 0(Vint(Int.repr value))
    (freeable_writable _ _ _ VA1))as[s1 S1].
  assert(VW2:Mem.valid_access s1 Mint16signed b2 0 Writable).
  { apply freeable_writable;eapply Mem.store_valid_access_1;[exact S1|exact VA2]. }
  destruct(Mem.valid_access_store s1 Mint16signed b2 0(Vint(Int.repr previous))VW2)as[s2 S2].
  assert(VW3:Mem.valid_access s2 Mint16signed b3 0 Writable).
  { apply freeable_writable;eapply Mem.store_valid_access_1;[exact S2|].
    eapply Mem.store_valid_access_1;[exact S1|exact VA3]. }
  destruct(Mem.valid_access_store s2 Mint16signed b3 0(Vint(Int.repr count))VW3)as[s3 S3].
  assert(VW4:Mem.valid_access s3 Mptr b4 0 Writable).
  { apply freeable_writable;eapply Mem.store_valid_access_1;[exact S3|].
    eapply Mem.store_valid_access_1;[exact S2|].
    eapply Mem.store_valid_access_1;[exact S1|exact VA4]. }
  destruct(Mem.valid_access_store s3 Mptr b4 0(Vptr tb tofs)VW4)as[mp S4].
  set(e:=PTree.set Source._tab(b4,pointer_type)
    (PTree.set Source._cnt(b3,short_type)
    (PTree.set Source._val_prev(b2,short_type)
    (PTree.set Source._val(b1,short_type)(PTree.empty(block*type)))))).
  assert(E1:e!Source._val=Some(b1,short_type))by(unfold e;vm_compute;reflexivity).
  assert(E2:e!Source._val_prev=Some(b2,short_type))by(unfold e;vm_compute;reflexivity).
  assert(E3:e!Source._cnt=Some(b3,short_type))by(unfold e;vm_compute;reflexivity).
  assert(E4:e!Source._tab=Some(b4,pointer_type))by(unfold e;vm_compute;reflexivity).
  assert(L1:Mem.load Mint16signed mp b1 0=Some(Vint(Int.repr value))).
  { erewrite(Mem.load_store_other _ _ _ _ _ _ S4)by(left;exact D14).
    erewrite(Mem.load_store_other _ _ _ _ _ _ S3)by(left;exact D13).
    erewrite(Mem.load_store_other _ _ _ _ _ _ S2)by(left;exact D12).
    pose proof(Mem.load_store_same _ _ _ _ _ _ S1)as L.
    cbn [Val.load_result]in L;rewrite nonnegative_short_cast in L by exact V;exact L. }
  assert(L2:Mem.load Mint16signed mp b2 0=Some(Vint(Int.repr previous))).
  { erewrite(Mem.load_store_other _ _ _ _ _ _ S4)by(left;exact D24).
    erewrite(Mem.load_store_other _ _ _ _ _ _ S3)by(left;exact D23).
    pose proof(Mem.load_store_same _ _ _ _ _ _ S2)as L.
    cbn [Val.load_result]in L;rewrite nonnegative_short_cast in L by exact P;exact L. }
  assert(L3:Mem.load Mint16signed mp b3 0=Some(Vint(Int.repr count))).
  { erewrite(Mem.load_store_other _ _ _ _ _ _ S4)by(left;exact D34).
    pose proof(Mem.load_store_same _ _ _ _ _ _ S3)as L.
    cbn [Val.load_result]in L;rewrite nonnegative_short_cast in L by exact C;exact L. }
  assert(L4:Mem.load Mptr mp b4 0=Some(Vptr tb tofs)).
  { pose proof(Mem.load_store_same _ _ _ _ _ _ S4)as L;exact L. }
  assert(VF1:Mem.valid_access mp Mint16signed b1 0 Freeable).
  { eapply Mem.store_valid_access_1;[exact S4|]. eapply Mem.store_valid_access_1;[exact S3|].
    eapply Mem.store_valid_access_1;[exact S2|]. eapply Mem.store_valid_access_1;[exact S1|exact VA1]. }
  assert(VF2:Mem.valid_access mp Mint16signed b2 0 Freeable).
  { eapply Mem.store_valid_access_1;[exact S4|]. eapply Mem.store_valid_access_1;[exact S3|].
    eapply Mem.store_valid_access_1;[exact S2|]. eapply Mem.store_valid_access_1;[exact S1|exact VA2]. }
  assert(VF3:Mem.valid_access mp Mint16signed b3 0 Freeable).
  { eapply Mem.store_valid_access_1;[exact S4|]. eapply Mem.store_valid_access_1;[exact S3|].
    eapply Mem.store_valid_access_1;[exact S2|]. eapply Mem.store_valid_access_1;[exact S1|exact VA3]. }
  assert(VF4:Mem.valid_access mp Mptr b4 0 Freeable).
  { eapply Mem.store_valid_access_1;[exact S4|]. eapply Mem.store_valid_access_1;[exact S3|].
    eapply Mem.store_valid_access_1;[exact S2|]. eapply Mem.store_valid_access_1;[exact S1|exact VA4]. }
  assert(BLOCKS:blocks_of_env(Csem.globalenv Source.prog)e=[(b3,0,2);(b4,0,8);(b2,0,2);(b1,0,2)]).
  { unfold e;vm_compute;reflexivity. }
  exists e,mp;constructor.
  - exists a4;split.
    + change(do_alloc_variables(Csem.globalenv Source.prog)empty_env m
        [(Source._val,short_type);(Source._val_prev,short_type);(Source._cnt,short_type);(Source._tab,pointer_type)]=(e,a4)).
      cbn [do_alloc_variables short_type pointer_type sizeof].
      rewrite A1,A2,A3,A4;reflexivity.
    + change(sem_bind_parameters(Csem.globalenv Source.prog)Control.quiet e a4
        [(Source._val,short_type);(Source._val_prev,short_type);(Source._cnt,short_type);(Source._tab,pointer_type)]
        [Vint(Int.repr value);Vint(Int.repr previous);Vint(Int.repr count);Vptr tb tofs]=Some mp).
      rewrite sem_bind_parameters_equation,E1,dec_eq_true,(short_assign _ _ _ _ _ _ S1).
      cbn [E0].
      rewrite sem_bind_parameters_equation,E2,dec_eq_true,(short_assign _ _ _ _ _ _ S2).
      cbn [E0].
      rewrite sem_bind_parameters_equation,E3,dec_eq_true,(short_assign _ _ _ _ _ _ S3).
      cbn [E0].
      rewrite sem_bind_parameters_equation,E4,dec_eq_true,(pointer_assign _ _ _ _ _ _ _ S4).
      cbn [E0];rewrite sem_bind_parameters_equation;reflexivity.
  - exists b1;repeat split;try assumption;apply(proj1(freeable_writable _ _ _ VF1)).
  - exists b2;repeat split;try assumption;apply(proj1(freeable_writable _ _ _ VF2)).
  - exists b3;repeat split;try assumption;apply(proj1(freeable_writable _ _ _ VF3)).
  - exists b4;auto.
  - unfold e;vm_compute;reflexivity.
  - rewrite BLOCKS;cbn [map region_block];repeat constructor;simpl;intuition congruence.
  - rewrite BLOCKS;repeat constructor;cbn [region_freeable];
      first[exact(proj1 VF1)|exact(proj1 VF2)|exact(proj1 VF3)|exact(proj1 VF4)].
  - rewrite BLOCKS;repeat constructor;cbn [region_fresh region_block];assumption.
  - eapply Mem.unchanged_on_trans;[eapply Mem.alloc_unchanged_on;exact A1|].
    eapply Mem.unchanged_on_trans;[eapply Mem.alloc_unchanged_on;exact A2|].
    eapply Mem.unchanged_on_trans;[eapply Mem.alloc_unchanged_on;exact A3|].
    eapply Mem.unchanged_on_trans;[eapply Mem.alloc_unchanged_on;exact A4|].
    eapply Mem.unchanged_on_trans;[eapply old_frame_store;[exact F1|exact S1]|].
    eapply Mem.unchanged_on_trans;[eapply old_frame_store;[exact F2|exact S2]|].
    eapply Mem.unchanged_on_trans;[eapply old_frame_store;[exact F3|exact S3]|].
    eapply old_frame_store;[exact F4|exact S4].
Qed.
