From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib AST Integers Values Memory Events Maps Ctypes Cop Csyntax Csyntaxdefs Csem Cexec.
From FiveGuidanceAllOrder Require Import PureSyntax PureDenotation AtomicDenotation CallfreeExecution.
From StateSpeedSetterSupport Require Import MemoryFacts StoreEffects Certificates.
From StateSpeedSetNedISupport Require Import Setup Layout.
Import ListNotations.
Open Scope Z_scope.
Local Opaque ge E.ge.

Lemma commit_integer:forall m b ofs v mf,
 0<=ofs<=Ptrofs.max_unsigned ->ofs+4<=Ptrofs.modulus ->
 Mem.store Mint32 m b ofs(Vint v)=Some mf ->
 commit ge m tint(b,Ptrofs.repr ofs,Full)(Vint v)tint=Some(Vint v,mf).
Proof.
 intros m b ofs v mf RANGE END STORE.
 change((match Cexec.do_assign_loc ge quiet_world tint m b(Ptrofs.repr ofs)Full(Vint v)with
 | Some(_,_,mm,vf)=>Some(vf,mm)|None=>None end)=Some(Vint v,mf)).
 unfold Cexec.do_assign_loc;cbn[tint access_mode type_is_volatile].
 unfold Mem.storev;rewrite Ptrofs.unsigned_repr by exact RANGE.
 rewrite zle_true by exact END;rewrite STORE;reflexivity.
Qed.
Lemma copy_one_evaluates:forall e m mf sb bp src axis delta v,
 e!S._state=None ->Genv.find_symbol ge S._state=Some sb ->
 e!S._ned_speed=Some(bp,tptr vtype) ->Mem.load Mptr m bp 0=Some(Vptr src Ptrofs.zero) ->
 layout S._NedCoor_i axis=Some(delta,Full) ->0<=delta<=8 ->
 Mem.load Mint32 m src delta=Some(Vint v) ->
 Mem.store Mint32 m sb(destination_offset+delta)(Vint v)=Some mf ->
 atomic_eval ge e m(match copy_one axis with Sdo a=>a|_=>Eval Vundef tvoid end)=Some(Vint v,mf).
Proof.
 intros e m mf sb bp src axis delta v NONE SYMBOL LOOK PTR LAYOUT RANGE WORD STORE.
 cbn[copy_one atomic_eval typeof];rewrite dec_eq_true.
 rewrite(destination_axis e m sb axis delta NONE SYMBOL LAYOUT).
 rewrite(input_axis_value e m bp src axis delta v LOOK PTR LAYOUT RANGE WORD).
 apply commit_integer;[change(0<=296+delta<=18446744073709551615);lia|
 change(296+delta+4<=18446744073709551616);lia|exact STORE].
Qed.
Lemma status_evaluates:forall e m mf sb,
 e!S._state=None ->Genv.find_symbol ge S._state=Some sb ->
 Mem.store Mint16unsigned m sb 280(Vint(Int.repr selected_status))=Some mf ->
 atomic_eval ge e m(match status_write with Sdo a=>a|_=>Eval Vundef tvoid end)=Some(Vint(Int.repr selected_status),mf).
Proof.
 intros e m mf sb NONE SYMBOL STORE.
 cbn[status_write atomic_eval typeof];rewrite dec_eq_true.
 rewrite(state_field_address e m sb S._speed_status tushort 280 NONE SYMBOL status_layout).
 change((match Mem.store Mint16unsigned m sb 280(Vint(Int.repr selected_status))with
 |Some mm=>Some(Vint(Int.repr selected_status),mm)|None=>None end)=Some(Vint(Int.repr selected_status),mf)).
 rewrite STORE;reflexivity.
Qed.

Theorem body_evaluates:forall e m m1 m2 m3 mb sb bp src x y z,
 e!S._state=None ->Genv.find_symbol ge S._state=Some sb ->
 e!S._ned_speed=Some(bp,tptr vtype) ->bp<>sb ->src<>sb ->
 Mem.load Mptr m bp 0=Some(Vptr src Ptrofs.zero) ->VecRead m src x y z ->
 Mem.store Mint32 m sb destination_offset(Vint x)=Some m1 ->
 Mem.store Mint32 m1 sb(destination_offset+4)(Vint y)=Some m2 ->
 Mem.store Mint32 m2 sb(destination_offset+8)(Vint z)=Some m3 ->
 Mem.store Mint16unsigned m3 sb 280(Vint(Int.repr selected_status))=Some mb ->
 stmt_eval ge e tvoid copy_body m=Some(Nnormal,mb).
Proof.
 intros e m m1 m2 m3 mb sb bp src x y z NONE SYMBOL LOOK BP SRC PTR[A[B C]]X Y ZS ST.
 destruct axis_layout as[XL[YL ZL]].
 assert(PTR1:Mem.load Mptr m1 bp 0=Some(Vptr src Ptrofs.zero)).
 { erewrite Mem.load_store_other;[exact PTR|exact X|left;exact BP]. }
 assert(PTR2:Mem.load Mptr m2 bp 0=Some(Vptr src Ptrofs.zero)).
 { erewrite Mem.load_store_other;[exact PTR1|exact Y|left;exact BP]. }
 assert(B1:Mem.load Mint32 m1 src 4=Some(Vint y)).
 { erewrite Mem.load_store_other;[exact B|exact X|left;exact SRC]. }
 assert(C2:Mem.load Mint32 m2 src 8=Some(Vint z)).
 { erewrite Mem.load_store_other;[|exact Y|left;exact SRC].
   erewrite Mem.load_store_other;[exact C|exact X|left;exact SRC]. }
 pose proof(copy_one_evaluates e m m1 sb bp src S._x 0 x NONE SYMBOL LOOK PTR XL ltac:(lia)A ltac:(replace(destination_offset+0)with destination_offset by lia;exact X))as AX.
 pose proof(copy_one_evaluates e m1 m2 sb bp src S._y 4 y NONE SYMBOL LOOK PTR1 YL ltac:(lia)B1 Y)as AY.
 pose proof(copy_one_evaluates e m2 m3 sb bp src S._z 8 z NONE SYMBOL LOOK PTR2 ZL ltac:(lia)C2 ZS)as AZ.
 pose proof(status_evaluates e m3 mb sb NONE SYMBOL ST)as AS.
 cbn[copy_body stmt_eval];rewrite AX,AY,AZ,AS;reflexivity.
Qed.
Lemma body_defined:forall e m mb mf,
 stmt_eval ge e tvoid copy_body m=Some(Nnormal,mb) ->
 Mem.free_list mb(blocks_of_env ge e)=Some mf ->
 normal_state(State f copy_body Kstop e m)=true /\call_names(State f copy_body Kstop e m) /\
 state_eval ge(State f copy_body Kstop e m)=Some(Vundef,mf).
Proof.
 intros e m mb mf BODY FREE;split;[reflexivity|];split;[exact I|].
 change((match stmt_eval ge e tvoid copy_body m with
 |Some(out,mm)=>cont_eval ge e tvoid Kstop out mm|None=>None end)=Some(Vundef,mf)).
 rewrite BODY;cbn[cont_eval];rewrite FREE;reflexivity.
Qed.
Print Assumptions body_evaluates.
Print Assumptions body_defined.
