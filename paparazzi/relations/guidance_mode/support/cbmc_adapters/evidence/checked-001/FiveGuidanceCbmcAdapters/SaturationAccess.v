From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Maps Integers Floats AST Values Memory Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cstrategy Smallstep.
From FiveGuidanceEntry Require Import Entry SoftwareSqrt BigstepSupport StackCleanup.
From FiveGuidanceAllOrder Require Import Unconditional.
From FiveGuidanceCbmcAdapters Require Import MemoryGuards SaturationPrelimit.
Require FiveGuidanceEntry.SymbolicPrefix FiveGuidanceEntry.AccelPrefix FiveGuidanceEntry.SaturationBody FiveGuidanceEntry.SaturationBodyAccel.
Import ListNotations.
Local Open Scope Z_scope.
Definition GuardPair(m:mem)(ba:block):Prop:=VectorAccessGuards m ba 0 /\VectorAccessGuards m ba 4.
Lemma range_guard_pair:forall m ba,Mem.range_perm m ba 0 8 Cur Writable->GuardPair m ba.
Proof. intros;split;apply vector_access_guards;auto. Qed.
Lemma normal_statement_context:forall ge e m st mf,
 Cstrategy.exec_stmt ge e m st E0 mf Out_normal->forall f k,
 star Csem.step ge(State f st k e m)E0(State f Sskip k e mf).
Proof.
 intros ge e m st mf EXEC f k.
 destruct(Cstrategy.exec_stmt_to_steps ge e m st E0 mf Out_normal EXEC f k)as[reached[PATH END]].
 inversion END;subst;apply strategy_star_csem;exact PATH.
Qed.
Module Speed.
Module S:=FiveGhSpeed.Source.
Module P:=FiveGuidanceEntry.SymbolicPrefix.
Module B:=FiveGuidanceEntry.SaturationBody.
Module Local:=SaturationPrelimit.Speed.
Import P B.
Definition ScalePacket(e:env)(m:mem)(ba bf:block)(a:vector)(maximum:float32)(k:cont):Prop:=
 exists m2 mc ms mf,
 Cstrategy.exec_stmt ge e m factor_statement E0 m2 Out_normal /\
 Cstrategy.exec_stmt ge e m2 scale_pair E0 mf Out_normal /\
 Mem.store Mfloat32 mc bf 0(Vsingle(Float32.div maximum(software_sqrt(norm2 a))))=Some m2 /\
 Mem.store Mfloat32 m2 ba 0(Vsingle(Float32.mul(vx a)(Float32.div maximum(software_sqrt(norm2 a)))))=Some ms /\
 Mem.store Mfloat32 ms ba 4(Vsingle(Float32.mul(vy a)(Float32.div maximum(software_sqrt(norm2 a)))))=Some mf /\
 star Csem.step ge(State S.f_gh_saturate_accel sat_branch_statement k e m)E0(State S.f_gh_saturate_accel Sskip k e mf) /\
 GuardPair m ba /\GuardPair m2 ba /\GuardPair ms ba /\GuardPair mf ba.
Theorem scale_write_sites:forall e m bp bn bf ba bc a maximum k,
 Local.local_point e m bp bn bf ba bc a maximum->Genv.find_symbol ge S._gh_max_accel=Some bc->
 ScalePacket e m ba bf a maximum k.
Proof.
 intros e m bp bn bf ba bc a maximum k POINT SYM.
 destruct POINT as(ES&EM&LP&LN&LF&PTR&LN1&LC1&LX1&LY1&SEP&FREE&AN&AF1&AA01&AA41&W8&DAP&DNP&DNA&DNC&DFP&DFA).
 destruct(factor_statement_exec e m bn bf bc(norm2 a)maximum speed_sqrt_contract ES EM SYM LN LF LN1 LC1 AF1)
 as(m2&mc&FACTOR&SF&APF&FRAME&BFRAME).
 assert(PTR2:Mem.load Mint64 m2 bp 0=Some(Vptr ba Ptrofs.zero)).
 { rewrite FRAME;[exact PTR|eapply loaded_valid_block;exact PTR|congruence]. }
 assert(LX2:Mem.load Mfloat32 m2 ba 0=Some(Vsingle(vx a))).
 { rewrite FRAME;[exact LX1|eapply loaded_valid_block;exact LX1|congruence]. }
 assert(LY2:Mem.load Mfloat32 m2 ba 4=Some(Vsingle(vy a))).
 { rewrite FRAME;[exact LY1|eapply loaded_valid_block;exact LY1|congruence]. }
 assert(LF2:Mem.load Mfloat32 m2 bf 0=Some(Vsingle(Float32.div maximum(software_sqrt(norm2 a))))).
 { erewrite Mem.load_store_same by exact SF;reflexivity. }
 destruct(scale_pair_exec e m2 bp ba bf a(Float32.div maximum(software_sqrt(norm2 a)))
 LP LF DAP ltac:(congruence) PTR2 LX2 LY2 LF2(APF _ _ _ _ AA01)(APF _ _ _ _ AA41))
 as(mf&ms&SCALE&AX&AY&APS&SX&SY).
 assert(W2:Mem.range_perm m2 ba 0 8 Cur Writable).
 { eapply range_perm_access_preserved;[exact APF|exact W8]. }
 assert(WS:Mem.range_perm ms ba 0 8 Cur Writable).
 { eapply range_perm_access_preserved;[|exact W2]. unfold access_preserved;intros;eapply Mem.store_valid_access_1;eauto. }
 assert(WF:Mem.range_perm mf ba 0 8 Cur Writable).
 { eapply range_perm_access_preserved;[exact APS|exact W2]. }
 exists m2,mc,ms,mf;split;[exact FACTOR|]. split;[exact SCALE|]. split;[exact SF|]. split;[exact SX|]. split;[exact SY|]. split.
 - eapply normal_statement_context;unfold sat_branch_statement;eapply sequence_normal;[exact FACTOR|exact SCALE].
 - split;[apply range_guard_pair;exact W8|]. split;[apply range_guard_pair;exact W2|]. split;apply range_guard_pair;assumption.
Qed.
Print Assumptions scale_write_sites.
End Speed.
Module Accel.
Module S:=FiveGhAccel.Source.
Module P:=FiveGuidanceEntry.AccelPrefix.
Module B:=FiveGuidanceEntry.SaturationBodyAccel.
Module Local:=SaturationPrelimit.Accel.
Import P B.
Definition ScalePacket(e:env)(m:mem)(ba bf:block)(a:vector)(maximum:float32)(k:cont):Prop:=
 exists m2 mc ms mf,
 Cstrategy.exec_stmt ge e m factor_statement E0 m2 Out_normal /\
 Cstrategy.exec_stmt ge e m2 scale_pair E0 mf Out_normal /\
 Mem.store Mfloat32 mc bf 0(Vsingle(Float32.div maximum(software_sqrt(norm2 a))))=Some m2 /\
 Mem.store Mfloat32 m2 ba 0(Vsingle(Float32.mul(vx a)(Float32.div maximum(software_sqrt(norm2 a)))))=Some ms /\
 Mem.store Mfloat32 ms ba 4(Vsingle(Float32.mul(vy a)(Float32.div maximum(software_sqrt(norm2 a)))))=Some mf /\
 star Csem.step ge(State S.f_gh_saturate_accel sat_branch_statement k e m)E0(State S.f_gh_saturate_accel Sskip k e mf) /\
 GuardPair m ba /\GuardPair m2 ba /\GuardPair ms ba /\GuardPair mf ba.
Theorem scale_write_sites:forall e m bp bn bf ba bc a maximum k,
 Local.local_point e m bp bn bf ba bc a maximum->Genv.find_symbol ge S._gh_max_accel=Some bc->
 ScalePacket e m ba bf a maximum k.
Proof.
 intros e m bp bn bf ba bc a maximum k POINT SYM.
 destruct POINT as(ES&EM&LP&LN&LF&PTR&LN1&LC1&LX1&LY1&SEP&FREE&AN&AF1&AA01&AA41&W8&DAP&DNP&DNA&DNC&DFP&DFA).
 destruct(factor_statement_exec e m bn bf bc(norm2 a)maximum accel_sqrt_contract ES EM SYM LN LF LN1 LC1 AF1)
 as(m2&mc&FACTOR&SF&APF&FRAME&BFRAME).
 assert(PTR2:Mem.load Mint64 m2 bp 0=Some(Vptr ba Ptrofs.zero)).
 { rewrite FRAME;[exact PTR|eapply loaded_valid_block;exact PTR|congruence]. }
 assert(LX2:Mem.load Mfloat32 m2 ba 0=Some(Vsingle(vx a))).
 { rewrite FRAME;[exact LX1|eapply loaded_valid_block;exact LX1|congruence]. }
 assert(LY2:Mem.load Mfloat32 m2 ba 4=Some(Vsingle(vy a))).
 { rewrite FRAME;[exact LY1|eapply loaded_valid_block;exact LY1|congruence]. }
 assert(LF2:Mem.load Mfloat32 m2 bf 0=Some(Vsingle(Float32.div maximum(software_sqrt(norm2 a))))).
 { erewrite Mem.load_store_same by exact SF;reflexivity. }
 destruct(scale_pair_exec e m2 bp ba bf a(Float32.div maximum(software_sqrt(norm2 a)))
 LP LF DAP ltac:(congruence) PTR2 LX2 LY2 LF2(APF _ _ _ _ AA01)(APF _ _ _ _ AA41))
 as(mf&ms&SCALE&AX&AY&APS&SX&SY).
 assert(W2:Mem.range_perm m2 ba 0 8 Cur Writable).
 { eapply range_perm_access_preserved;[exact APF|exact W8]. }
 assert(WS:Mem.range_perm ms ba 0 8 Cur Writable).
 { eapply range_perm_access_preserved;[|exact W2]. unfold access_preserved;intros;eapply Mem.store_valid_access_1;eauto. }
 assert(WF:Mem.range_perm mf ba 0 8 Cur Writable).
 { eapply range_perm_access_preserved;[exact APS|exact W2]. }
 exists m2,mc,ms,mf;split;[exact FACTOR|]. split;[exact SCALE|]. split;[exact SF|]. split;[exact SX|]. split;[exact SY|]. split.
 - eapply normal_statement_context;unfold sat_branch_statement;eapply sequence_normal;[exact FACTOR|exact SCALE].
 - split;[apply range_guard_pair;exact W8|]. split;[apply range_guard_pair;exact W2|]. split;apply range_guard_pair;assumption.
Qed.
Print Assumptions scale_write_sites.
End Accel.
