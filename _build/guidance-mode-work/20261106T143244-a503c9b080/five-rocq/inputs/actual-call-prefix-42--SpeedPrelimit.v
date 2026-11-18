From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Maps Integers Floats AST Values Memory Events Globalenvs Ctypes Csyntax Csyntaxdefs Csem Smallstep.
From FivePaparazziState Require Import State.
From FiveGuidanceEntry Require Import Entry BigstepSupport SymbolicPrefix PrelimitBody EntryPrelimit.
From FiveGuidanceAllocation Require Import StackAllocation StackWrapper.
From FiveGuidanceMode Require Import Spec.
Require FiveGhSpeed.Source FiveGhSpeed.Execution.
Import ListNotations.
Local Open Scope Z_scope.
Module S:=FiveGhSpeed.Source.
Definition SpeedPrelimitZero(s:state)(sp:vector)(m:mem)(bp:block)(o:ptrofs):Prop:=
 exists si t k reached local global,
 integrate s=Some si /\
 star Csem.step FiveGhSpeed.Execution.ge(FiveGhSpeed.Execution.entry[Vptr bp o]m)t
  (Callstate(Internal FiveGhSpeed.Source.f_gh_saturate_accel)[Vptr local Ptrofs.zero]k reached) /\
 argument_repr(raw_speed_accel si sp)reached local Ptrofs.zero /\
 Genv.find_symbol FiveGhSpeed.Execution.ge FiveGhSpeed.Source._gh_ref=Some global /\
 repr si reached global.
Theorem speed_prelimit_zero:forall s sp ma ba pa oa,
 speed_initial s sp ma ba pa oa ->SpeedPrelimitZero s sp ma pa oa.
Proof.
 intros s sp m bg src o INIT.
 destruct INIT as(REP&W&ARG&SAFE&SYM&bc&CSYM&CONST).
 destruct ARG as(LXS&LYS&RANGE&HI&BYTES).
 destruct SAFE as(dx&dy&CX&CY&NX&NY).
 destruct(prepare_vector_entry ge(fn_vars S.f_gh_update_ref_from_speed_sp)S._speed_sp vt
 m s bg bc src o(vx sp)(vy sp)eq_refl eq_refl eq_refl
 ltac:(repeat constructor;simpl;intuition discriminate)REP W CONST LXS LYS)
 as(e&ma&mb&param&AV&BIND&LP&LX&LY&REP1&W1&C1&SEP&NONE&ALL).
 destruct(ALL S._pos_step vt ltac:(simpl;intuition congruence))as(bp&LPS&FP&PP).
 destruct(ALL S._speed_step vt ltac:(simpl;intuition congruence))as(bs&LSS&FS&PS).
 destruct(ALL S._pos_update it ltac:(simpl;intuition congruence))as(bu&LPU&FU&PU).
 destruct(ALL S._speed_err vt ltac:(simpl;intuition congruence))as(be&LE&FE&PE).
 destruct(ALL S._accel_sp vt ltac:(simpl;intuition congruence))as(ba&LA&FA&PA).
 destruct(ALL S._speed_sp vt ltac:(simpl;intuition congruence))as(p2&LP2&FPARAM&PPARAM).
 rewrite LP in LP2;injection LP2 as EQ;subst p2.
 assert(VG:Mem.valid_block m bg).
 { eapply Mem.perm_valid_block with(ofs:=0)(k:=Cur)(p:=Writable);apply W;lia. }
 assert(DGP:bg<>bp)by(intro EQ;subst bp;apply FP;exact VG).
 assert(DGS:bg<>bs)by(intro EQ;subst bs;apply FS;exact VG).
 assert(DGU:bg<>bu)by(intro EQ;subst bu;apply FU;exact VG).
 assert(DGE:bg<>be)by(intro EQ;subst be;apply FE;exact VG).
 assert(DGA:bg<>ba)by(intro EQ;subst ba;apply FA;exact VG).
 assert(DPG:param<>bg)by(intro EQ;subst param;apply FPARAM;exact VG).
 assert(DPS:bp<>bs)by(eapply separated_blocks;[exact SEP| |exact LPS|exact LSS];discriminate).
 assert(DPU:bp<>bu)by(eapply separated_blocks;[exact SEP| |exact LPS|exact LPU];discriminate).
 assert(DSU:bs<>bu)by(eapply separated_blocks;[exact SEP| |exact LSS|exact LPU];discriminate).
 assert(DPP:param<>bp)by(eapply separated_blocks;[exact SEP| |exact LP|exact LPS];discriminate).
 assert(DPSP:param<>bs)by(eapply separated_blocks;[exact SEP| |exact LP|exact LSS];discriminate).
 assert(DPUA:param<>bu)by(eapply separated_blocks;[exact SEP| |exact LP|exact LPU];discriminate).
 assert(DPE:param<>be)by(eapply separated_blocks;[exact SEP| |exact LP|exact LE];discriminate).
 assert(DPA:param<>ba)by(eapply separated_blocks;[exact SEP| |exact LP|exact LA];discriminate).
 assert(DEA:be<>ba)by(eapply separated_blocks;[exact SEP| |exact LE|exact LA];discriminate).
 assert(ENV:e!S._gh_ref=None)by(apply NONE;vm_compute;intuition discriminate).
 assert(EH:e!S._gh_saturate_accel=None)by(apply NONE;vm_compute;intuition discriminate).
 change(Mem.range_perm mb bp 0 8 Cur Freeable)in PP.
 change(Mem.range_perm mb bs 0 8 Cur Freeable)in PS.
 change(Mem.range_perm mb bu 0 16 Cur Freeable)in PU.
 change(Mem.range_perm mb be 0 8 Cur Freeable)in PE.
 change(Mem.range_perm mb ba 0 8 Cur Freeable)in PA.
 destruct(body_prelimit s sp e mb bg param bp bs bu be ba dx dy ENV SYM EH LP LPS LSS LPU LE LA
 DGP DGS DGU DPS DPU DSU DPG DPP DPSP DPUA DGE DGA DPE DPA DEA REP1 W1 LX LY
 (freeable_vector_access _ _ _ PP(or_introl eq_refl))(freeable_vector_access _ _ _ PP(or_intror eq_refl))
 (freeable_vector_access _ _ _ PS(or_introl eq_refl))(freeable_vector_access _ _ _ PS(or_intror eq_refl))
 (freeable_longvector_access _ _ _ PU(or_introl eq_refl))(freeable_longvector_access _ _ _ PU(or_intror eq_refl))
 (freeable_vector_access _ _ _ PE(or_introl eq_refl))(freeable_vector_access _ _ _ PE(or_intror eq_refl))
 (freeable_vector_access _ _ _ PA(or_introl eq_refl))(freeable_vector_access _ _ _ PA(or_intror eq_refl))CX CY)
 as(mf&kc&BODY&RF&WF&KEEP&AX&AY&ABYTES).
 unfold SpeedPrelimitZero;exists(integrated s dx dy),E0,kc,mf,ba,bg.
 split;[unfold integrate;rewrite CX,CY;reflexivity|].
 split.
 - eapply star_step with(t1:=E0)(t2:=E0);[|exact BODY|reflexivity].
   unfold FiveGhSpeed.Execution.entry;right;eapply Csem.step_internal_function.
   + repeat constructor;simpl;intuition discriminate.
   + exact AV.
   + exact BIND.
 - split.
   + unfold argument_repr;rewrite Ptrofs.unsigned_zero.
     split;[exact AX|]. split;[exact AY|]. split;[lia|]. split;[vm_compute;intuition discriminate|exact ABYTES].
   + auto.
Qed.
Print Assumptions speed_prelimit_zero.
