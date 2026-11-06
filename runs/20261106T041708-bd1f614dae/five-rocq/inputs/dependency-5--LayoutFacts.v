From Stdlib Require Import List ZArith.
From compcert Require Import Coqlib Errors Maps AST Ctypes Csyntaxdefs Csem.
From FiveGhSetOmega Require Import Source Execution.
Import ListNotations.
Local Open Scope Z_scope.
Definition actual_members: list(ident*Z):=
 [(Source._accel,0);(Source._speed,8);(Source._pos,16);(Source._tau,32);(Source._omega,36);(Source._zeta,40);(Source._max_speed,44);(Source._zeta_omega,48);(Source._omega_2,52);(Source._inv_tau,56);(Source._dt,60)].
Definition GeneratedLayout:Prop:=
 sizeof Execution.ge(Tstruct Source._GuidanceHRef noattr)=64 /\
 alignof Execution.ge(Tstruct Source._GuidanceHRef noattr)=8 /\
 (forall id ofs,In(id,ofs)actual_members -> exists co,
 PTree.get Source._GuidanceHRef(genv_cenv Execution.ge)=Some co /\ field_offset Execution.ge id(co_members co)=OK(ofs,Full)) /\
 (forall sid fid ofs,In(sid,fid,ofs)[(Source._FloatVect2,Source._x,0);(Source._FloatVect2,Source._y,4);(Source._Int64Vect2,Source._x,0);(Source._Int64Vect2,Source._y,8)] -> exists co,
 PTree.get sid(genv_cenv Execution.ge)=Some co /\ field_offset Execution.ge fid(co_members co)=OK(ofs,Full)).
Lemma actual_cenv_layout:GeneratedLayout.
Proof.
 split;[reflexivity|]. split;[reflexivity|]. split.
 - intros id ofs IN;unfold actual_members in IN;simpl in IN.
   repeat match goal with H:_ \/ _|-_=>destruct H as[H|H]end;try contradiction;
   repeat match goal with E:_=_|-_=>inversion E;subst;clear E end;eexists;split;reflexivity.
 - intros sid fid ofs IN;simpl in IN.
   repeat match goal with H:_ \/ _|-_=>destruct H as[H|H]end;try contradiction;
   repeat match goal with E:_=_|-_=>inversion E;subst;clear E end;eexists;split;reflexivity.
Qed.
Print Assumptions actual_cenv_layout.
