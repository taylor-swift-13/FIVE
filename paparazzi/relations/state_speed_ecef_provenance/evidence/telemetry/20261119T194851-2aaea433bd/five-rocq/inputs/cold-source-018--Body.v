From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib AST Integers Floats Values Memory Events Globalenvs Maps Ctypes Cop Csyntax Csyntaxdefs Csem Cexec.
From FiveGuidanceAllOrder Require Import PureSyntax PureDenotation AtomicDenotation CallfreeExecution.
From StateSpeedSetterSupport Require Import MemoryFacts Certificates.
From StateSpeedGetterSupport Require Import Setup Layout.
Import ListNotations.
Open Scope Z_scope.
Local Opaque ge E.ge.
Lemma commit_float:forall m b ofs v mf,
 0<=ofs<=Ptrofs.max_unsigned->ofs+4<=Ptrofs.modulus->Mem.store Mfloat32 m b ofs(Vsingle v)=Some mf->
 commit ge m tfloat(b,Ptrofs.repr ofs,Full)(Vsingle v)tfloat=Some(Vsingle v,mf).
Proof.
 intros m b ofs v mf RANGE END STORE.
 change((match Cexec.do_assign_loc ge quiet_world tfloat m b(Ptrofs.repr ofs)Full(Vsingle v)with Some(_,_,mm,vf)=>Some(vf,mm)|None=>None end)=Some(Vsingle v,mf)).
 unfold Cexec.do_assign_loc;cbn[tfloat access_mode type_is_volatile];unfold Mem.storev.
 rewrite Ptrofs.unsigned_repr by exact RANGE;rewrite zle_true by exact END;rewrite STORE;reflexivity.
Qed.
Lemma assignment_evaluates:forall e m mf sb axis delta i,
 e!S._state=None->Genv.find_symbol ge S._state=Some sb->
 layout S._NedCoor_i axis=Some(delta,Full)->layout S._EcefCoor_f axis=Some(delta,Full)->0<=delta<=8->
 Mem.load Mint32 m sb(296+delta)=Some(Vint i)->Mem.store Mfloat32 m sb(328+delta)(Vsingle(decode i))=Some mf->
 atomic_eval ge e m(match assignment axis with Sdo a=>a|_=>Eval Vundef tvoid end)=Some(Vsingle(decode i),mf).
Proof.
 intros e m mf sb axis delta i NONE SYM NI FF RANGE LOAD STORE.
 cbn[assignment atomic_eval typeof];rewrite dec_eq_true.
 rewrite(float_axis_address e m sb axis delta NONE SYM FF).
 rewrite(conversion_value e m sb axis delta i NONE SYM NI RANGE LOAD).
 apply commit_float;[change(0<=328+delta<=18446744073709551615);lia|change(328+delta+4<=18446744073709551616);lia|exact STORE].
Qed.
Lemma marker_evaluates:forall e m mf sb,
 e!S._state=None->Genv.find_symbol ge S._state=Some sb->Mem.load Mint16unsigned m sb 280=Some(Vint Int.one)->
 Mem.store Mint16unsigned m sb 280(Vint(Int.repr 33))=Some mf->
 atomic_eval ge e m(match marker with Sdo a=>a|_=>Eval Vundef tvoid end)=Some(Vint(Int.repr 33),mf).
Proof.
 intros e m mf sb NONE SYM LOAD STORE.
 cbn[marker atomic_eval typeof];rewrite dec_eq_true;unfold status_lvalue.
 rewrite(state_field_address e m sb S._speed_status tushort 280 NONE SYM status_layout).
 rewrite(scalar_deref ge m tushort Mint16unsigned sb 280(Vint Int.one)eq_refl eq_refl ltac:(change(0<=280<=18446744073709551615);lia)ltac:(change(280+2<=18446744073709551616);lia)LOAD).
 change((match Cexec.do_assign_loc ge quiet_world tushort m sb(Ptrofs.repr 280)Full(Vint(Int.repr 33))with Some(_,_,mm,vf)=>Some(vf,mm)|None=>None end)=Some(Vint(Int.repr 33),mf)).
 unfold Cexec.do_assign_loc;cbn[tushort access_mode type_is_volatile];unfold Mem.storev.
 rewrite Ptrofs.unsigned_repr by(change(0<=280<=18446744073709551615);lia).
 rewrite zle_true by(change(280+2<=18446744073709551616);lia);rewrite STORE;reflexivity.
Qed.
Theorem body_evaluates:forall e m m1 m2 m3 mf sb x y z,
 e!S._state=None->Genv.find_symbol ge S._state=Some sb->
 Mem.load Mint16unsigned m sb 280=Some(Vint Int.one)->
 Mem.load Mint32 m sb 296=Some(Vint x)->Mem.load Mint32 m sb 300=Some(Vint y)->Mem.load Mint32 m sb 304=Some(Vint z)->
 Mem.store Mfloat32 m sb 328(Vsingle(decode x))=Some m1->Mem.store Mfloat32 m1 sb 332(Vsingle(decode y))=Some m2->
 Mem.store Mfloat32 m2 sb 336(Vsingle(decode z))=Some m3->Mem.store Mint16unsigned m3 sb 280(Vint(Int.repr 33))=Some mf->
 stmt_eval ge e tvoid(Ssequence conversion_block marker)m=Some(Nnormal,mf).
Proof.
 intros e m m1 m2 m3 mf sb x y z NONE SYM STATUS A B C X Y ZS ST.
 destruct ned_axes as[NX[NY NZ]];destruct float_axes as[FX[FY FZ]].
 assert(B1:Mem.load Mint32 m1 sb 300=Some(Vint y)).
 { erewrite Mem.load_store_other;[exact B|exact X|right;left;cbn;lia]. }
 assert(C2:Mem.load Mint32 m2 sb 304=Some(Vint z)).
 { erewrite Mem.load_store_other;[|exact Y|right;left;cbn;lia].
   erewrite Mem.load_store_other;[exact C|exact X|right;left;cbn;lia]. }
 assert(S3:Mem.load Mint16unsigned m3 sb 280=Some(Vint Int.one)).
 { erewrite Mem.load_store_other;[|exact ZS|right;left;cbn;lia].
   erewrite Mem.load_store_other;[|exact Y|right;left;cbn;lia].
   erewrite Mem.load_store_other;[exact STATUS|exact X|right;left;cbn;lia]. }
 pose proof(assignment_evaluates e m m1 sb S._x 0 x NONE SYM NX FX ltac:(lia)A X)as AX.
 pose proof(assignment_evaluates e m1 m2 sb S._y 4 y NONE SYM NY FY ltac:(lia)B1 Y)as AY.
 pose proof(assignment_evaluates e m2 m3 sb S._z 8 z NONE SYM NZ FZ ltac:(lia)C2 ZS)as AZ.
 pose proof(marker_evaluates e m3 mf sb NONE SYM S3 ST)as MARK.
 eapply sequence_evaluates with(ma:=m3).
 - unfold conversion_block;eapply sequence_evaluates with(ma:=m1);[eapply atomic_statement_evaluates;exact AX|].
   eapply sequence_evaluates with(ma:=m2);eapply atomic_statement_evaluates;[exact AY|exact AZ].
 - eapply atomic_statement_evaluates;exact MARK.
Qed.
Print Assumptions body_evaluates.
