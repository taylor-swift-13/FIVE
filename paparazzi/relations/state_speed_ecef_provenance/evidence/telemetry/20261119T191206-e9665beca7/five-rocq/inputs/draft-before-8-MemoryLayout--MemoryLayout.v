From Stdlib Require Import List ZArith.
From compcert Require Import Errors Maps AST Integers Values Memory Globalenvs Ctypes Csem.
From StateSpeedSetNedI Require Import Source Execution.
From StateSpeedSetEcefI Require Import Source Execution.
From StateSpeedGetEcefF Require Import Source Execution.
Import ListNotations.
Open Scope Z_scope.
Module N:=StateSpeedSetNedI.Source.
Module E:=StateSpeedSetEcefI.Source.
Module G:=StateSpeedGetEcefF.Source.
Module NE:=StateSpeedSetNedI.Execution.
Module EE:=StateSpeedSetEcefI.Execution.
Module GE:=StateSpeedGetEcefF.Execution.
Definition ce:=G.prog.(prog_comp_env).
Definition state_type:=Tstruct G._State noattr.
Definition ecef_i_type:=Tstruct G._EcefCoor_i noattr.
Definition ned_i_type:=Tstruct G._NedCoor_i noattr.
Definition ecef_f_type:=Tstruct G._EcefCoor_f noattr.
Definition composite_member(sid fid:ident)(union:bool):option(type*Z):=
 match PTree.get sid ce with
 | None=>None
 | Some co=>match field_type fid(co_members co)with
 | Error _=>None
 | OK ty=>if union then Some(ty,0)else
 match field_offset ce fid(co_members co)with
 | OK(ofs,_)=>Some(ty,ofs)|Error _=>None end end end.
Definition one_member(ty:type)(fid:ident):option(type*Z):=
 match ty with Tstruct id _=>composite_member id fid false
 |Tunion id _=>composite_member id fid true|_=>None end.
Fixpoint path_info(ty:type)(path:list ident):option(type*Z):=
 match path with []=>Some(ty,0)|f::fs=>match one_member ty f with
 |None=>None|Some(next,ofs)=>match path_info next fs with
 |None=>None|Some(last,tail)=>Some(last,ofs+tail)end end end.
Definition load_path ch m b ty path:=
 match path_info ty path with None=>None|Some(_,ofs)=>Mem.load ch m b ofs end.
Definition store_path ch m b ty path value:=
 match path_info ty path with None=>None|Some(_,ofs)=>Mem.store ch m b ofs value end.

Theorem identical_composites:N.composites=E.composites /\E.composites=G.composites.
Proof. split;reflexivity. Qed.
Theorem shared_composite_environments:N.prog.(prog_comp_env)=ce /\E.prog.(prog_comp_env)=ce.
Proof.
 pose proof(prog_comp_env_eq N.prog)as HN.
 pose proof(prog_comp_env_eq E.prog)as HE.
 pose proof(prog_comp_env_eq G.prog)as HG.
 change(build_composite_env N.composites=OK N.prog.(prog_comp_env))in HN.
 change(build_composite_env E.composites=OK E.prog.(prog_comp_env))in HE.
 change(build_composite_env G.composites=OK ce)in HG.
 destruct identical_composites as[NE EG];rewrite NE,EG in HN;rewrite EG in HE.
 rewrite HG in HN,HE;split;congruence.
Qed.
Theorem common_state_identifiers:N._State=G._State /\E._State=G._State /\
 N._state=G._state /\E._state=G._state.
Proof. repeat split;reflexivity. Qed.
Theorem actual_State_layout:
 sizeof ce state_type=656 /\alignof ce state_type=4 /\
 path_info state_type[G._speed_status]=Some(tushort,280) /\
 path_info state_type[G._speed_input_filter]=Some(tushort,282) /\
 path_info state_type[G._ecef_speed_i;G._x]=Some(tint,284) /\
 path_info state_type[G._ned_speed_i;G._x]=Some(tint,296) /\
 path_info state_type[G._ecef_speed_f;G._x]=Some(tfloat,328).
Proof. repeat split;reflexivity. Qed.
Theorem common_state_symbols:
 Genv.find_symbol NE.ge N._state=Genv.find_symbol GE.ge G._state /\
 Genv.find_symbol EE.ge E._state=Genv.find_symbol GE.ge G._state.
Proof. split;reflexivity. Qed.
Print Assumptions shared_composite_environments.
