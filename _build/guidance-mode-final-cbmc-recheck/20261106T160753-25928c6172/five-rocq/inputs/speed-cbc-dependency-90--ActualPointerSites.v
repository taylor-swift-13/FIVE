From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Maps Integers Floats AST Values Memory Events Globalenvs Ctypes Csyntax Csyntaxdefs Csem Smallstep.
From FiveShared.verification Require Import Obligations.
From FivePaparazziState Require Import State.
From FiveGuidanceEntry Require Import Entry.
From FiveGuidanceMode Require Import Spec.
From FiveGuidanceAllOrder Require Import Unconditional.
From FiveGuidanceCbmcAdapters Require Import MemoryGuards CanonicalCalls NormReadSites SaturationPrelimit SaturationAccess.
Import ListNotations.
Local Open Scope Z_scope.
Module Speed.
Module S:=FiveGhSpeed.Source.
Module P:=FiveGuidanceEntry.SymbolicPrefix.
Module B:=FiveGuidanceEntry.SaturationBody.
Module Local:=SaturationPrelimit.Speed.
Import P B.
Definition ReadPacket(m:mem)(ba bc:block)(a:vector)(maximum:float32)(k:cont):Prop:=
 exists e mb bp,
 star Csem.step ge(Callstate(Internal S.f_gh_saturate_accel)[Vptr ba Ptrofs.zero]k m)E0
 (State S.f_gh_saturate_accel norm_statement(Kseq(Sifthenelse condition_expr sat_branch_statement Sskip)k)e mb) /\
 GuardPair mb ba /\Mem.range_perm mb ba 0 8 Cur Writable /\
 e!S._accel_sp=Some(bp,tptr vt) /\Mem.load Mint64 mb bp 0=Some(Vptr ba Ptrofs.zero).
Definition BranchPacket(m:mem)(ba bc:block)(a:vector)(maximum:float32)(k:cont):Prop:=
 exists e mn bp bn bf,
 Local.local_point e mn bp bn bf ba bc a maximum /\
 star Csem.step ge(Callstate(Internal S.f_gh_saturate_accel)[Vptr ba Ptrofs.zero]k m)E0
 (State S.f_gh_saturate_accel(if saturation_branch maximum a then sat_branch_statement else Sskip)k e mn) /\
 GuardPair mn ba /\
 (saturation_branch maximum a=true->SaturationAccess.Speed.ScalePacket e mn ba bf a maximum k).
Lemma actual_packets:forall m ba bc a maximum k,
 Genv.find_symbol ge S._gh_max_accel=Some bc->Mem.load Mfloat32 m bc 0=Some(Vsingle maximum)->
 Mem.load Mfloat32 m ba 0=Some(Vsingle(vx a))->Mem.load Mfloat32 m ba 4=Some(Vsingle(vy a))->
 Mem.valid_access m Mfloat32 ba 0 Writable->Mem.valid_access m Mfloat32 ba 4 Writable->
 ReadPacket m ba bc a maximum k /\BranchPacket m ba bc a maximum k.
Proof.
 intros m ba bc a maximum k SYM MAX X Y A0 A4;split.
 - destruct(NormReadSites.Speed.norm_read_sites m ba bc a maximum k SYM MAX X Y A0 A4)
   as(e&mb&bp&bn&bf&PATH&G0&G4&W&LP&LN&LF&PTR&RX&RY).
   exists e,mb,bp;split;[exact PATH|]. split;[split;assumption|]. split;[exact W|]. auto.
 - destruct(Local.saturation_to_branch m ba bc a maximum k SYM MAX X Y A0 A4)
   as(e&mn&bp&bn&bf&POINT&PATH).
   exists e,mn,bp,bn,bf;split;[exact POINT|]. split;[exact PATH|]. split.
   + pose proof POINT as Q;destruct Q as(ES&EM&LP&LN&LF&PTR&NL&ML&LX&LY&SEP&FREE&AN&AF&AX&AY&W&REST).
     apply range_guard_pair;exact W.
   + intros BR;eapply SaturationAccess.Speed.scale_write_sites;[exact POINT|exact SYM].
Qed.
Definition ActualSites:Prop:=forall taken s m bg src o,
 CanonicalControls s->speed_initial s(speed_command taken)m bg src o->
 no_error ge(FiveGhSpeed.Execution.entry[Vptr src o]m) /\
 exists si t k mr ba bc,
 integrate s=Some si /\
 star Csem.step ge(FiveGhSpeed.Execution.entry[Vptr src o]m)t
 (Callstate(Internal S.f_gh_saturate_accel)[Vptr ba Ptrofs.zero]k mr) /\
 ReadyVector ge S._gh_max_accel mr ba(accel_command taken) /\
 ReadPacket mr ba bc(accel_command taken)fixed_maximum k /\
 BranchPacket mr ba bc(accel_command taken)fixed_maximum k.
Theorem actual_sites:ActualSites.
Proof.
 intros taken s m bg src o CONTROL INIT;split.
 - exact(proj1(speed_safe_termination s(speed_command taken)m bg src o INIT)).
 - destruct(canonical_speed_ready taken s m bg src o CONTROL INIT)
   as(si&t&k&mr&ba&INT&PATH&REP&READY).
   pose proof READY as R;destruct R as(ARG&A0&A4&W&bc&SYM&MAX).
   destruct ARG as(X&Y&LOW&HI&BYTES);rewrite Ptrofs.unsigned_zero in X,Y;cbn in Y.
   destruct(actual_packets mr ba bc(accel_command taken)fixed_maximum k SYM MAX X Y A0 A4)as[READ BRANCH].
   exists si,t,k,mr,ba,bc;auto.
Qed.
Print Assumptions actual_sites.
End Speed.
Module Accel.
Module S:=FiveGhAccel.Source.
Module P:=FiveGuidanceEntry.AccelPrefix.
Module B:=FiveGuidanceEntry.SaturationBodyAccel.
Module Local:=SaturationPrelimit.Accel.
Import P B.
Definition ReadPacket(m:mem)(ba bc:block)(a:vector)(maximum:float32)(k:cont):Prop:=
 exists e mb bp,
 star Csem.step ge(Callstate(Internal S.f_gh_saturate_accel)[Vptr ba Ptrofs.zero]k m)E0
 (State S.f_gh_saturate_accel norm_statement(Kseq(Sifthenelse condition_expr sat_branch_statement Sskip)k)e mb) /\
 GuardPair mb ba /\Mem.range_perm mb ba 0 8 Cur Writable /\
 e!S._accel_sp=Some(bp,tptr vt) /\Mem.load Mint64 mb bp 0=Some(Vptr ba Ptrofs.zero).
Definition BranchPacket(m:mem)(ba bc:block)(a:vector)(maximum:float32)(k:cont):Prop:=
 exists e mn bp bn bf,
 Local.local_point e mn bp bn bf ba bc a maximum /\
 star Csem.step ge(Callstate(Internal S.f_gh_saturate_accel)[Vptr ba Ptrofs.zero]k m)E0
 (State S.f_gh_saturate_accel(if saturation_branch maximum a then sat_branch_statement else Sskip)k e mn) /\
 GuardPair mn ba /\
 (saturation_branch maximum a=true->SaturationAccess.Accel.ScalePacket e mn ba bf a maximum k).
Lemma actual_packets:forall m ba bc a maximum k,
 Genv.find_symbol ge S._gh_max_accel=Some bc->Mem.load Mfloat32 m bc 0=Some(Vsingle maximum)->
 Mem.load Mfloat32 m ba 0=Some(Vsingle(vx a))->Mem.load Mfloat32 m ba 4=Some(Vsingle(vy a))->
 Mem.valid_access m Mfloat32 ba 0 Writable->Mem.valid_access m Mfloat32 ba 4 Writable->
 ReadPacket m ba bc a maximum k /\BranchPacket m ba bc a maximum k.
Proof.
 intros m ba bc a maximum k SYM MAX X Y A0 A4;split.
 - destruct(NormReadSites.Accel.norm_read_sites m ba bc a maximum k SYM MAX X Y A0 A4)
   as(e&mb&bp&bn&bf&PATH&G0&G4&W&LP&LN&LF&PTR&RX&RY).
   exists e,mb,bp;split;[exact PATH|]. split;[split;assumption|]. split;[exact W|]. auto.
 - destruct(Local.saturation_to_branch m ba bc a maximum k SYM MAX X Y A0 A4)
   as(e&mn&bp&bn&bf&POINT&PATH).
   exists e,mn,bp,bn,bf;split;[exact POINT|]. split;[exact PATH|]. split.
   + pose proof POINT as Q;destruct Q as(ES&EM&LP&LN&LF&PTR&NL&ML&LX&LY&SEP&FREE&AN&AF&AX&AY&W&REST).
     apply range_guard_pair;exact W.
   + intros BR;eapply SaturationAccess.Accel.scale_write_sites;[exact POINT|exact SYM].
Qed.
Definition ActualSites:Prop:=forall taken s m bg src o,
 CanonicalControls s->accel_initial s(accel_command taken)m bg src o->
 no_error ge(FiveGhAccel.Execution.entry[Vptr src o]m) /\
 exists si t k mr ba bc,
 integrate s=Some si /\
 star Csem.step ge(FiveGhAccel.Execution.entry[Vptr src o]m)t
 (Callstate(Internal S.f_gh_saturate_accel)[Vptr ba Ptrofs.zero]k mr) /\
 ReadyVector ge S._gh_max_accel mr ba(accel_command taken) /\
 ReadPacket mr ba bc(accel_command taken)fixed_maximum k /\
 BranchPacket mr ba bc(accel_command taken)fixed_maximum k.
Theorem actual_sites:ActualSites.
Proof.
 intros taken s m bg src o CONTROL INIT;split.
 - exact(proj1(accel_safe_termination s(accel_command taken)m bg src o INIT)).
 - destruct(canonical_accel_ready taken s m bg src o CONTROL INIT)
   as(si&t&k&mr&ba&INT&PATH&REP&READY).
   pose proof READY as R;destruct R as(ARG&A0&A4&W&bc&SYM&MAX).
   destruct ARG as(X&Y&LOW&HI&BYTES);rewrite Ptrofs.unsigned_zero in X,Y;cbn in Y.
   destruct(actual_packets mr ba bc(accel_command taken)fixed_maximum k SYM MAX X Y A0 A4)as[READ BRANCH].
   exists si,t,k,mr,ba,bc;auto.
Qed.
Print Assumptions actual_sites.
End Accel.
