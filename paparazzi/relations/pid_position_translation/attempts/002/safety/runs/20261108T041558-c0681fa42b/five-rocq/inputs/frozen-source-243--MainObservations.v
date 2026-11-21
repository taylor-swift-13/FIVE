From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Maps AST Integers Values Memory Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Smallstep.
From PidPositionRunPos Require Import Source Execution.
From PidPositionTranslationSupport Require Import MemoryLayout.
From PidPositionTranslationProblem Require Import Spec.
From PidPositionSafety Require Import SnapshotInts AssertionSyntax AssertionEval LocalObservations MappedMain AssertionGlobals.
Import ListNotations.
Open Scope Z_scope.
Module E:=PidPositionRunPos.Execution.
Local Opaque E.ge.

Theorem main_assertion_observation_1:MainAssertionObservation1Goal.
Proof.
 intros gh ret a b dx dy flight af bf PAIR A B.
 destruct(main_assertion_1 gh ret a b dx dy flight af bf PAIR A B S._x ltac:(cbn;auto))as[x[AX BX]].
 destruct(main_assertion_1 gh ret a b dx dy flight af bf PAIR A B S._y ltac:(cbn;auto))as[y[AY BY]].
 destruct(loaded_global_has_symbol Mint32 af S._guidance_pid_pos_err vec_type [S._x](Vint x)AX)as[bp[SYM ARAW]].
 rewrite(load_global_at_symbol Mint32 bf S._guidance_pid_pos_err vec_type [S._x] bp SYM)in BX.
 rewrite(load_global_at_symbol Mint32 bf S._guidance_pid_pos_err vec_type [S._y] bp SYM)in BY.
 change(Mem.load Mint32 bf bp 0=Some(Vint x))in BX.
 change(Mem.load Mint32 bf bp 4=Some(Vint y))in BY.
 assert(BOUNDS:Forall(cell_bounds(sizeof E.ge vec_type))[(0,x);(4,y)]).
 { rewrite assertion_ge_ce;snapshot_bounds 8. }
 destruct(typed_snapshot_exists vec_type bf[(0,x);(4,y)] BOUNDS ltac:(snapshot_separated))
 as[snapshot[observed[SNAP FRAME]]].
 assert(SX:Mem.load Mint32 observed snapshot 0=Some(Vint x)).
 { apply(proj1(proj2 SNAP));cbn;auto. }
 assert(SY:Mem.load Mint32 observed snapshot 4=Some(Vint y)).
 { apply(proj1(proj2 SNAP));cbn;auto. }
 assert(GX:Mem.load Mint32 observed bp 0=Some(Vint x))by(apply FRAME;exact BX).
 assert(GY:Mem.load Mint32 observed bp 4=Some(Vint y))by(apply FRAME;exact BY).
 exists x,y,snapshot,observed;split;[exact AX|];split;[exact AY|];split;[exact SNAP|].
 apply evaluates_true_intro;eapply assertion_1_true with(bp:=bp)(bs:=snapshot)(x:=x)(y:=y);
 [reflexivity|exact SYM|reflexivity|exact GX|exact GY|exact SX|exact SY].
Qed.
Print Assumptions main_assertion_observation_1.

Theorem main_assertion_observation_2:MainAssertionObservation2Goal.
Proof.
 intros gh ret a b dx dy flight af bf PAIR A B.
 destruct(main_assertion_2 gh ret a b dx dy flight af bf PAIR A B S._x ltac:(cbn;auto))as[x[AX BX]].
 destruct(main_assertion_2 gh ret a b dx dy flight af bf PAIR A B S._y ltac:(cbn;auto))as[y[AY BY]].
 destruct(loaded_global_has_symbol Mint32 af S._guidance_pid pid_type [S._cmd_earth;S._x](Vint x)AX)as[bp[SYM ARAW]].
 rewrite(load_global_at_symbol Mint32 bf S._guidance_pid pid_type [S._cmd_earth;S._x] bp SYM)in BX.
 rewrite(load_global_at_symbol Mint32 bf S._guidance_pid pid_type [S._cmd_earth;S._y] bp SYM)in BY.
 change(Mem.load Mint32 bf bp 32=Some(Vint x))in BX.
 change(Mem.load Mint32 bf bp 36=Some(Vint y))in BY.
 assert(BOUNDS:Forall(cell_bounds(sizeof E.ge pid_type))[(32,x);(36,y)]).
 { rewrite assertion_ge_ce;snapshot_bounds 48. }
 destruct(typed_snapshot_exists pid_type bf[(32,x);(36,y)] BOUNDS ltac:(snapshot_separated))
 as[snapshot[observed[SNAP FRAME]]].
 assert(SX:Mem.load Mint32 observed snapshot 32=Some(Vint x)).
 { apply(proj1(proj2 SNAP));cbn;auto. }
 assert(SY:Mem.load Mint32 observed snapshot 36=Some(Vint y)).
 { apply(proj1(proj2 SNAP));cbn;auto. }
 assert(GX:Mem.load Mint32 observed bp 32=Some(Vint x))by(apply FRAME;exact BX).
 assert(GY:Mem.load Mint32 observed bp 36=Some(Vint y))by(apply FRAME;exact BY).
 exists x,y,snapshot,observed;split;[exact AX|];split;[exact AY|];split;[exact SNAP|].
 apply evaluates_true_intro;eapply assertion_2_true with(bp:=bp)(bs:=snapshot)(x:=x)(y:=y);
 [reflexivity|exact SYM|reflexivity|exact GX|exact GY|exact SX|exact SY].
Qed.
Print Assumptions main_assertion_observation_2.

Theorem main_assertion_observation_3:MainAssertionObservation3Goal.
Proof.
 intros gh ret a b dx dy flight af bf PAIR A B.
 destruct(main_assertion_3 gh ret a b dx dy flight af bf PAIR A B S._x ltac:(cbn;auto))as[x[AX BX]].
 destruct(main_assertion_3 gh ret a b dx dy flight af bf PAIR A B S._y ltac:(cbn;auto))as[y[AY BY]].
 destruct(loaded_global_has_symbol Mint32 af S._guidance_pid_trim_att_integrator vec_type [S._x](Vint x)AX)as[bp[SYM ARAW]].
 rewrite(load_global_at_symbol Mint32 bf S._guidance_pid_trim_att_integrator vec_type [S._x] bp SYM)in BX.
 rewrite(load_global_at_symbol Mint32 bf S._guidance_pid_trim_att_integrator vec_type [S._y] bp SYM)in BY.
 change(Mem.load Mint32 bf bp 0=Some(Vint x))in BX.
 change(Mem.load Mint32 bf bp 4=Some(Vint y))in BY.
 assert(BOUNDS:Forall(cell_bounds(sizeof E.ge vec_type))[(0,x);(4,y)]).
 { rewrite assertion_ge_ce;snapshot_bounds 8. }
 destruct(typed_snapshot_exists vec_type bf[(0,x);(4,y)] BOUNDS ltac:(snapshot_separated))
 as[snapshot[observed[SNAP FRAME]]].
 assert(SX:Mem.load Mint32 observed snapshot 0=Some(Vint x)).
 { apply(proj1(proj2 SNAP));cbn;auto. }
 assert(SY:Mem.load Mint32 observed snapshot 4=Some(Vint y)).
 { apply(proj1(proj2 SNAP));cbn;auto. }
 assert(GX:Mem.load Mint32 observed bp 0=Some(Vint x))by(apply FRAME;exact BX).
 assert(GY:Mem.load Mint32 observed bp 4=Some(Vint y))by(apply FRAME;exact BY).
 exists x,y,snapshot,observed;split;[exact AX|];split;[exact AY|];split;[exact SNAP|].
 apply evaluates_true_intro;eapply assertion_3_true with(bp:=bp)(bs:=snapshot)(x:=x)(y:=y);
 [reflexivity|exact SYM|reflexivity|exact GX|exact GY|exact SX|exact SY].
Qed.
Print Assumptions main_assertion_observation_3.

Theorem main_assertion_observation_4:MainAssertionObservation4Goal.
Proof.
 intros gh ret a b dx dy flight af bf PAIR A B.
 destruct(main_assertion_4 gh ret a b dx dy flight af bf PAIR A B)
 as[[tag[AT BT]][fmt[AF BF]]].
 assert(BOUNDS:Forall(cell_bounds(sizeof E.ge sp_type))[(0,tag);(4,fmt)]).
 { rewrite assertion_ge_ce;snapshot_bounds 36. }
 destruct(typed_snapshot_exists sp_type bf[(0,tag);(4,fmt)] BOUNDS ltac:(snapshot_separated))
 as[ba[mid[SA FA]]].
 destruct(typed_snapshot_exists sp_type mid[(0,tag);(4,fmt)] BOUNDS ltac:(snapshot_separated))
 as[bb[observed[SB FB]]].
 assert(A0:Mem.load Mint32 mid ba 0=Some(Vint tag))by(apply(proj1(proj2 SA));cbn;auto).
 assert(A4:Mem.load Mint32 mid ba 4=Some(Vint fmt))by(apply(proj1(proj2 SA));cbn;auto).
 assert(A0F:Mem.load Mint32 observed ba 0=Some(Vint tag))by(apply FB;exact A0).
 assert(A4F:Mem.load Mint32 observed ba 4=Some(Vint fmt))by(apply FB;exact A4).
 assert(B0F:Mem.load Mint32 observed bb 0=Some(Vint tag))by(apply(proj1(proj2 SB));cbn;auto).
 assert(B4F:Mem.load Mint32 observed bb 4=Some(Vint fmt))by(apply(proj1(proj2 SB));cbn;auto).
 exists tag,fmt,ba,bb,mid,observed.
 split;[exact AT|];split;[exact AF|];split;[exact BT|];split;[exact BF|];
 split;[exact SA|];split;[exact SB|].
 apply evaluates_true_intro;eapply assertion_4_true with(ba:=ba)(bb:=bb)(tag:=tag)(fmt:=fmt);
 [reflexivity|reflexivity|exact A0F|exact A4F|exact B0F|exact B4F].
Qed.
Print Assumptions main_assertion_observation_4.
Theorem main_assertion_observation_5:MainAssertionObservation5Goal.
Proof.
 intros gh ret a b dx dy flight af bf PAIR A B.
 destruct(main_assertion_5 gh ret a b dx dy flight af bf PAIR A B
 [S._sp;S._ltp_i;S._vect;S._x]ltac:(cbn;auto))as[x[AX BX]].
 destruct(main_assertion_5 gh ret a b dx dy flight af bf PAIR A B
 [S._sp;S._ltp_i;S._vect;S._y]ltac:(cbn;auto))as[y[AY BY]].
 destruct(main_assertion_5 gh ret a b dx dy flight af bf PAIR A B
 [S._sp;S._ltp_i;S._heading]ltac:(cbn;auto))as[h[AH BH]].
 assert(BOUNDS:Forall(cell_bounds(sizeof E.ge sp_type))[(8,x);(12,y);(16,h)]).
 { rewrite assertion_ge_ce;snapshot_bounds 36. }
 destruct(typed_snapshot_exists sp_type bf[(8,x);(12,y);(16,h)] BOUNDS ltac:(snapshot_separated))
 as[ba[mid[SA FA]]].
 destruct(typed_snapshot_exists sp_type mid[(8,x);(12,y);(16,h)] BOUNDS ltac:(snapshot_separated))
 as[bb[observed[SB FB]]].
 assert(A8:Mem.load Mint32 mid ba 8=Some(Vint x))by(apply(proj1(proj2 SA));cbn;auto).
 assert(A12:Mem.load Mint32 mid ba 12=Some(Vint y))by(apply(proj1(proj2 SA));cbn;auto).
 assert(A16:Mem.load Mint32 mid ba 16=Some(Vint h))by(apply(proj1(proj2 SA));cbn;auto).
 assert(A8F:Mem.load Mint32 observed ba 8=Some(Vint x))by(apply FB;exact A8).
 assert(A12F:Mem.load Mint32 observed ba 12=Some(Vint y))by(apply FB;exact A12).
 assert(A16F:Mem.load Mint32 observed ba 16=Some(Vint h))by(apply FB;exact A16).
 assert(B8F:Mem.load Mint32 observed bb 8=Some(Vint x))by(apply(proj1(proj2 SB));cbn;auto).
 assert(B12F:Mem.load Mint32 observed bb 12=Some(Vint y))by(apply(proj1(proj2 SB));cbn;auto).
 assert(B16F:Mem.load Mint32 observed bb 16=Some(Vint h))by(apply(proj1(proj2 SB));cbn;auto).
 exists x,y,h,ba,bb,mid,observed.
 split;[exact AX|];split;[exact AY|];split;[exact AH|];
 split;[exact BX|];split;[exact BY|];split;[exact BH|];
 split;[exact SA|];split;[exact SB|].
 apply evaluates_true_intro;eapply assertion_5_true with(ba:=ba)(bb:=bb)(x:=x)(y:=y)(h:=h);
 [reflexivity|reflexivity|exact A8F|exact A12F|exact A16F|exact B8F|exact B12F|exact B16F].
Qed.
Print Assumptions main_assertion_observation_5.
Theorem main_assertion_observation_6:MainAssertionObservation6Goal.
Proof.
 intros gh ret a b dx dy flight af bf PAIR A B.
 destruct(main_assertion_6 gh ret a b dx dy flight af bf PAIR A B)
 as[[x[rbx[AX[BX ADDX]]]][y[rby[AY[BY ADDY]]]]].
 assert(BA:Forall(cell_bounds(sizeof E.ge gh_type))[(44,x);(48,y)]).
 { rewrite assertion_ge_ce;snapshot_bounds 84. }
 assert(BB:Forall(cell_bounds(sizeof E.ge gh_type))[(44,rbx);(48,rby)]).
 { rewrite assertion_ge_ce;snapshot_bounds 84. }
 assert(BDX:Forall(cell_bounds(sizeof E.ge tint))[(0,Int.repr dx)]).
 { snapshot_bounds 4. }
 assert(BDY:Forall(cell_bounds(sizeof E.ge tint))[(0,Int.repr dy)]).
 { snapshot_bounds 4. }
 destruct(typed_snapshot_exists gh_type bf[(44,x);(48,y)] BA ltac:(snapshot_separated))
 as[ba[m1[SA FA]]].
 destruct(typed_snapshot_exists gh_type m1[(44,rbx);(48,rby)] BB ltac:(snapshot_separated))
 as[bb[m2[SB FB]]].
 destruct(typed_snapshot_exists tint m2[(0,Int.repr dx)] BDX ltac:(snapshot_separated))
 as[bdx[m3[SX FX]]].
 destruct(typed_snapshot_exists tint m3[(0,Int.repr dy)] BDY ltac:(snapshot_separated))
 as[bdy[observed[SY FY]]].
 assert(A44:Mem.load Mint32 observed ba 44=Some(Vint x)).
 { apply FY;apply FX;apply FB;apply(proj1(proj2 SA));cbn;auto. }
 assert(A48:Mem.load Mint32 observed ba 48=Some(Vint y)).
 { apply FY;apply FX;apply FB;apply(proj1(proj2 SA));cbn;auto. }
 assert(B44:Mem.load Mint32 observed bb 44=Some(Vint rbx)).
 { apply FY;apply FX;apply(proj1(proj2 SB));cbn;auto. }
 assert(B48:Mem.load Mint32 observed bb 48=Some(Vint rby)).
 { apply FY;apply FX;apply(proj1(proj2 SB));cbn;auto. }
 assert(DX0:Mem.load Mint32 observed bdx 0=Some(Vint(Int.repr dx))).
 { apply FY;apply(proj1(proj2 SX));cbn;auto. }
 assert(DY0:Mem.load Mint32 observed bdy 0=Some(Vint(Int.repr dy))).
 { apply(proj1(proj2 SY));cbn;auto. }
 exists x,y,rbx,rby,ba,bb,bdx,bdy,m1,m2,m3,observed.
 split;[exact AX|];split;[exact AY|];split;[exact BX|];split;[exact BY|];
 split;[exact SA|];split;[exact SB|];split;[exact SX|];split;[exact SY|].
 apply evaluates_true_intro;eapply assertion_6_true with(ba:=ba)(bb:=bb)(bx:=bdx)(bdy:=bdy)
 (x:=x)(y:=y)(dx:=Int.repr dx)(dy:=Int.repr dy);
 [reflexivity|reflexivity|reflexivity|reflexivity|exact A44|exact A48|
  rewrite ADDX;exact B44|rewrite ADDY;exact B48|exact DX0|exact DY0].
Qed.
Print Assumptions main_assertion_observation_6.
