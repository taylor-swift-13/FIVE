From Stdlib Require Import List ZArith Lia.
From compcert Require Import AST Coqlib Integers Floats Values Memory Memdata Ctypes Csem Smallstep.
From FiveGuidanceAllOrder Require Import PureSyntax CallfreeExecution.
From FiveLowpassSupport Require Import LowpassMemory Straightline.
Require FiveQuatVmult.Execution FiveRmatOfQuat.Execution FiveRmatVmult.Execution.
Require FiveQuatVmultCase.Contract FiveQuatVmultCase.Body FiveQuatVmultCase.Call.
Require FiveRmatOfQuatCase.Contract FiveRmatOfQuatCase.Output FiveRmatOfQuatCase.CallSummary.
Require FiveRmatVmultCase.Contract FiveRmatVmultCase.Call FiveRmatVmultCase.Access.
From FiveQuatRotation Require Import Spec.
Import ListNotations.
Local Open Scope Z_scope.
Module D:=FiveQuatVmultCase.Contract.
Module DB:=FiveQuatVmultCase.Body.
Module DC:=FiveQuatVmultCase.Call.
Module M:=FiveRmatOfQuatCase.Contract.
Module MO:=FiveRmatOfQuatCase.Output.
Module MC:=FiveRmatOfQuatCase.CallSummary.
Module R:=FiveRmatVmultCase.Contract.
Module RC:=FiveRmatVmultCase.Call.
Definition WCells(m:mem)(b:block)(count:Z):Prop:=forall i,0<=i<count->Mem.valid_access m Mfloat32 b(4*i)Writable.
Definition Anchor(m:mem)(b:block):Prop:=forall old,Mem.valid_block m old->Pos.le old b.
Lemma old_block_anchor:forall m m' anchor,Anchor m anchor->Mem.valid_block m' anchor->forall b,Mem.valid_block m b->Mem.valid_block m' b.
Proof. intros m m' a H VA b VB;unfold Mem.valid_block in *;eapply Pos.le_lt_trans;[exact(H b VB)|exact VA]. Qed.
Lemma W_valid:forall m b n,0<n->WCells m b n->Mem.valid_block m b.
Proof. intros m b n N W;eapply Mem.valid_access_valid_block;eapply Mem.valid_access_implies;[exact(W 0 ltac:(lia))|constructor]. Qed.
Lemma W_writable12:forall m b,WCells m b 3->writable12 m b Ptrofs.zero.
Proof.
 intros m b W;split;[rewrite Ptrofs.unsigned_zero;exists 0;lia|];split;[rewrite Ptrofs.unsigned_zero;change(12<=18446744073709551616);lia|].
 rewrite Ptrofs.unsigned_zero;intros ofs RANGE.
 destruct(Z_lt_ge_dec ofs 4)as[A|A].
 - exact(proj1(W 0 ltac:(lia)) ofs ltac:(cbn[size_chunk];lia)).
 - destruct(Z_lt_ge_dec ofs 8)as[B|B].
 + exact(proj1(W 1 ltac:(lia)) ofs ltac:(cbn[size_chunk];lia)).
 + exact(proj1(W 2 ltac:(lia)) ofs ltac:(cbn[size_chunk];lia)).
Qed.
Lemma preserve_load:forall m mf b ch ofs value,
 Mem.load ch m b ofs=Some value->
 (forall z n,Mem.loadbytes mf b z n=Mem.loadbytes m b z n)->Mem.load ch mf b ofs=Some value.
Proof.
 intros m mf b ch ofs value L F;destruct(Mem.load_loadbytes _ _ _ _ _ L)as[bytes[BY DE]].
 rewrite DE;eapply Mem.loadbytes_load;[rewrite F;exact BY|exact(proj2(Mem.load_valid_access _ _ _ _ _ L))].
Qed.
Definition MV(qi qx qy qz:float32):list float32:=MO.matrix_values qi qx qy qz.
Definition Mat(qi qx qy qz:float32)(i:Z):float32:=nth(Z.to_nat i)(MV qi qx qy qz)Float32.zero.
Definition Vec(vx vy vz:float32)(i:Z):float32:=if Z.eqb i 0 then vx else if Z.eqb i 1 then vy else vz.
Definition DirectBytes(qi qx qy qz vx vy vz:float32):list memval:=
 encode_val Mfloat32(Vsingle(DB.output_x qi qx qy qz vx vy vz))++encode_val Mfloat32(Vsingle(DB.output_y qi qx qy qz vx vy vz))++encode_val Mfloat32(Vsingle(DB.output_z qi qx qy qz vx vy vz)).
Definition MatrixPathBytes(qi qx qy qz vx vy vz:float32):list memval:=
 let f:=Mat qi qx qy qz in let v:=Vec vx vy vz in
 encode_val Mfloat32(Vsingle(R.Row f v 0))++encode_val Mfloat32(Vsingle(R.Row f v 3))++encode_val Mfloat32(Vsingle(R.Row f v 6)).
Definition CallPath(m:mem)(q v a r b:block)(md mr mf:mem):Prop:=
 NormalCall FiveQuatVmult.Execution.ge FiveQuatVmult.Execution.entry(D.Args a q v)m md /\
 NormalCall FiveRmatOfQuat.Execution.ge FiveRmatOfQuat.Execution.entry(M.Args r q)md mr /\
 NormalCall FiveRmatVmult.Execution.ge FiveRmatVmult.Execution.entry(R.Args b r v Ptrofs.zero Ptrofs.zero Ptrofs.zero)mr mf.
Lemma sep_five:forall q v a r b:block,NoDup[q;v;a;r;b]->
 q<>v /\q<>a /\q<>r /\q<>b /\v<>a /\v<>r /\v<>b /\a<>r /\a<>b /\r<>b.
Proof. intros q v a r b N;repeat match goal with H:NoDup(_::_)|-_=>inversion H;subst;clear H end;simpl in *;intuition congruence. Qed.
Theorem protocol:forall m q v a r b anchor qi qx qy qz vx vy vz,
 NoDup[q;v;a;r;b]->D.Inputs m q v a qi qx qy qz vx vy vz->WCells m r 9->WCells m b 3->WCells m anchor 3->Anchor m anchor->
 exists md mr mf,CallPath m q v a r b md mr mf /\
 Mem.loadbytes mf a 0 12=Some(DirectBytes qi qx qy qz vx vy vz) /\
 Mem.loadbytes mf b 0 12=Some(MatrixPathBytes qi qx qy qz vx vy vz) /\FrameOutside m mf a r b /\
 (forall ch old ofs perm,Mem.valid_access m ch old ofs perm->Mem.valid_access mf ch old ofs perm).
Proof.
 intros m q v a r b anchor qi qx qy qz vx vy vz SEP INPUT WR WB WAN ANCHOR.
 destruct(sep_five _ _ _ _ _ SEP)as[QV[QA[QR[QB[VA[VR[VB[AR[AB RB]]]]]]]]].
 pose proof(W_valid m r 9 ltac:(lia) WR)as R_VALID.
 pose proof(W_valid m b 3 ltac:(lia) WB)as B_VALID.
 assert(Q_VALID:Mem.valid_block m q)by(eapply Mem.valid_access_valid_block;eapply Mem.valid_access_implies;[eapply Mem.load_valid_access;exact(D.lqi _ _ _ _ _ _ _ _ _ _ _ INPUT)|constructor]).
 assert(V_VALID:Mem.valid_block m v)by(eapply Mem.valid_access_valid_block;eapply Mem.valid_access_implies;[eapply Mem.load_valid_access;exact(D.lvx _ _ _ _ _ _ _ _ _ _ _ INPUT)|constructor]).
 assert(A_VALID:Mem.valid_block m a)by(eapply Mem.valid_access_valid_block;eapply Mem.valid_access_implies;[exact(D.wout _ _ _ _ _ _ _ _ _ _ _ INPUT 0 ltac:(simpl;tauto))|constructor]).
 destruct(DC.call_summary m q v a qi qx qy qz vx vy vz INPUT)as[md[ED[FD[BD[AD LD]]]]].
 assert(WBD:WCells md b 3)by(intros i I;apply AD;apply WB;exact I).
 assert(WAND:WCells md anchor 3)by(intros i I;apply AD;apply WAN;exact I).
 assert(VALID_D:forall old,Mem.valid_block m old->Mem.valid_block md old).
 { exact(old_block_anchor m md anchor ANCHOR(W_valid md anchor 3 ltac:(lia) WAND)). }
 assert(IM:M.Inputs md q r qi qx qy qz).
 { constructor;[exact QR| | | | |].
 - rewrite(LD Mfloat32 q 0 Q_VALID QA);exact(D.lqi _ _ _ _ _ _ _ _ _ _ _ INPUT).
 - rewrite(LD Mfloat32 q 4 Q_VALID QA);exact(D.lqx _ _ _ _ _ _ _ _ _ _ _ INPUT).
 - rewrite(LD Mfloat32 q 8 Q_VALID QA);exact(D.lqy _ _ _ _ _ _ _ _ _ _ _ INPUT).
 - rewrite(LD Mfloat32 q 12 Q_VALID QA);exact(D.lqz _ _ _ _ _ _ _ _ _ _ _ INPUT).
 - intros ofs I;apply AD;destruct I as[<-|[<-|[<-|[<-|[<-|[<-|[<-|[<-|[<-|I]]]]]]]]];try contradiction;
   match goal with |-Mem.valid_access m Mfloat32 r ?ofs Writable=>let i:=eval vm_compute in(ofs/4)in exact(WR i ltac:(lia)) end. }
 destruct(MC.call_summary md q r qi qx qy qz IM)as[mr[EM[FM[BM[LM AM]]]]].
 assert(WBR:WCells mr b 3)by(intros i I;apply AM;[apply VALID_D;exact B_VALID|apply WBD;exact I]).
 assert(WANR:WCells mr anchor 3)by(intros i I;apply AM;[apply VALID_D;exact(W_valid m anchor 3 ltac:(lia) WAN)|apply WAND;exact I]).
 assert(VALID_R:forall old,Mem.valid_block m old->Mem.valid_block mr old).
 { exact(old_block_anchor m mr anchor ANCHOR(W_valid mr anchor 3 ltac:(lia) WANR)). }
 assert(RM:R.Reads mr r Ptrofs.zero 9(Mat qi qx qy qz)).
 { split;[rewrite Ptrofs.unsigned_zero;exists 0;lia|];split;[rewrite Ptrofs.unsigned_zero;change(36<=18446744073709551616);lia|].
 intros i I;rewrite Ptrofs.unsigned_zero;unfold Mat.
 replace(0+4*i)with(Z.of_nat(Z.to_nat i)*4)by(rewrite Z2Nat.id by lia;lia).
 apply LM;apply Nat2Z.inj_lt;rewrite Z2Nat.id by lia;lia. }
 assert(RV:R.Reads mr v Ptrofs.zero 3(Vec vx vy vz)).
 { split;[rewrite Ptrofs.unsigned_zero;exists 0;lia|];split;[rewrite Ptrofs.unsigned_zero;change(12<=18446744073709551616);lia|].
 intros i I;assert(I3:i=0\/i=1\/i=2)by lia;destruct I3 as[EQ|[EQ|EQ]];subst i;unfold Vec;cbn[Z.eqb];rewrite Ptrofs.unsigned_zero.
 - eapply preserve_load with(m:=md);[change(Mem.load Mfloat32 md v 0=Some(Vsingle vx));rewrite(LD Mfloat32 v 0 V_VALID VA);exact(D.lvx _ _ _ _ _ _ _ _ _ _ _ INPUT)|intros z n;apply FM;[apply VALID_D;exact V_VALID|left;exact VR]].
 - eapply preserve_load with(m:=md);[change(Mem.load Mfloat32 md v 4=Some(Vsingle vy));rewrite(LD Mfloat32 v 4 V_VALID VA);exact(D.lvy _ _ _ _ _ _ _ _ _ _ _ INPUT)|intros z n;apply FM;[apply VALID_D;exact V_VALID|left;exact VR]].
 - eapply preserve_load with(m:=md);[change(Mem.load Mfloat32 md v 8=Some(Vsingle vz));rewrite(LD Mfloat32 v 8 V_VALID VA);exact(D.lvz _ _ _ _ _ _ _ _ _ _ _ INPUT)|intros z n;apply FM;[apply VALID_D;exact V_VALID|left;exact VR]]. }
 destruct(RC.call_summary mr b r v Ptrofs.zero Ptrofs.zero Ptrofs.zero(Mat qi qx qy qz)(Vec vx vy vz)ltac:(congruence)ltac:(congruence)ltac:(congruence)(W_writable12 mr b WBR)RM RV)as[mf[ER[BR[FR WBF]]]].
 destruct(FiveRmatVmultCase.Access.call_access mr b r v Ptrofs.zero Ptrofs.zero Ptrofs.zero(Mat qi qx qy qz)(Vec vx vy vz)ltac:(congruence)ltac:(congruence)ltac:(congruence)(W_writable12 mr b WBR)RM RV)as[mf'[ER' ACCESS_R]].
 assert(MEQ:mf'=mf)by(congruence);subst mf'.
 exists md,mr,mf;split.
 - unfold CallPath,NormalCall;split.
   + exact(defined_evaluator_return_exists FiveQuatVmult.Execution.ge(FiveQuatVmult.Execution.entry(D.Args a q v)m)Vundef md ltac:(vm_compute;reflexivity)ltac:(vm_compute;repeat constructor;simpl;intuition discriminate) ED).
   + split.
     * exact(defined_evaluator_return_exists FiveRmatOfQuat.Execution.ge(FiveRmatOfQuat.Execution.entry(M.Args r q)md)Vundef mr ltac:(vm_compute;reflexivity)ltac:(vm_compute;repeat constructor;simpl;intuition discriminate) EM).
     * exact(defined_evaluator_return_exists FiveRmatVmult.Execution.ge(FiveRmatVmult.Execution.entry(R.Args b r v Ptrofs.zero Ptrofs.zero Ptrofs.zero)mr)Vundef mf ltac:(vm_compute;reflexivity)ltac:(vm_compute;repeat constructor;simpl;intuition discriminate) ER).
 - split.
 + rewrite(FR a 0 12(VALID_R a A_VALID)ltac:(left;exact AB)).
   rewrite(FM a 0 12(VALID_D a A_VALID)ltac:(left;exact AR));exact BD.
 + split;[exact BR|];split.
 * intros old z n OLD [OA[OR OB]].
 rewrite(FR old z n(VALID_R old OLD)ltac:(left;exact OB)).
 rewrite(FM old z n(VALID_D old OLD)ltac:(left;exact OR)).
 apply FD;[exact OLD|left;exact OA].
 * intros ch old ofs perm VA0.
 assert(VOLD:Mem.valid_block m old)by(eapply Mem.valid_access_valid_block;eapply Mem.valid_access_implies;[exact VA0|constructor]).
 apply ACCESS_R;[apply VALID_R;exact VOLD|];apply AM;[apply VALID_D;exact VOLD|];apply AD;exact VA0.
Qed.
Print Assumptions protocol.
