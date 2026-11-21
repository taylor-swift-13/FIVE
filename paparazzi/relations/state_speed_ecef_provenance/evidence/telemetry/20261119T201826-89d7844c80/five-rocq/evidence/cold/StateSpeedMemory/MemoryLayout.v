From Stdlib Require Import List ZArith.
From compcert Require Import Errors Maps AST Integers Values Memory Globalenvs Ctypes Csyntaxdefs Ctypesdefs Csem.
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
Definition ce_N:=N.prog.(prog_comp_env).
Definition ce_E:=E.prog.(prog_comp_env).
Definition state_type:=Tstruct G._State noattr.
Definition ecef_i_type:=Tstruct G._EcefCoor_i noattr.
Definition ned_i_type:=Tstruct G._NedCoor_i noattr.
Definition ecef_f_type:=Tstruct G._EcefCoor_f noattr.
Definition ned_f_type:=Tstruct G._NedCoor_f noattr.
Definition composite_member_in (env:composite_env)(sid fid:ident)(union:bool):option(type*Z):=
 match PTree.get sid env with
 | None=>None
 | Some co=>match field_type fid(co_members co)with
 | Error _=>None
 | OK ty=>if union then Some(ty,0)else
 match field_offset env fid(co_members co)with
 | OK(ofs,_)=>Some(ty,ofs)|Error _=>None end end end.
Definition composite_member:=composite_member_in ce.
Definition one_member_in(env:composite_env)(ty:type)(fid:ident):option(type*Z):=
 match ty with Tstruct id _=>composite_member_in env id fid false
 |Tunion id _=>composite_member_in env id fid true|_=>None end.
Definition one_member:=one_member_in ce.
Fixpoint path_info_in(env:composite_env)(ty:type)(path:list ident){struct path}:option(type*Z):=
 match path with []=>Some(ty,0)|f::fs=>match one_member_in env ty f with
 |None=>None|Some(next,ofs)=>match path_info_in env next fs with
 |None=>None|Some(last,tail)=>Some(last,ofs+tail)end end end.
Definition path_info:=path_info_in ce.
Definition load_path ch m b ty path:=
 match path_info ty path with None=>None|Some(_,ofs)=>Mem.load ch m b ofs end.
Definition store_path ch m b ty path value:=
 match path_info ty path with None=>None|Some(_,ofs)=>Mem.store ch m b ofs value end.

Theorem setter_composites_equal:N.composites=E.composites.
Proof. reflexivity. Qed.
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
Proof. vm_compute; repeat split; reflexivity. Qed.
Theorem common_state_symbols:
 Genv.find_symbol NE.ge N._state=Genv.find_symbol GE.ge G._state /\
 Genv.find_symbol EE.ge E._state=Genv.find_symbol GE.ge G._state.
Proof. split; lazy; reflexivity. Qed.

(* The getter has two extra local composites.  These projections assert only
   equality of layouts actually used by the shared State interface. *)
Definition layout_projection (env:composite_env)(sid:ident):=
 match PTree.get sid env with
 | None=>None
 | Some co=>Some(co_su co,co_members co,co_attr co,co_sizeof co,co_alignof co,co_rank co)
 end.
Definition interface_composites: list ident :=
 [G._State;G._EcefCoor_i;G._NedCoor_i;G._EcefCoor_f;G._NedCoor_f;G._LtpDef_f;G._FloatRMat].
Theorem common_layout_projections:
 map(layout_projection ce_N)interface_composites=map(layout_projection ce)interface_composites /\
 map(layout_projection ce_E)interface_composites=map(layout_projection ce)interface_composites.
Proof. vm_compute; split; reflexivity. Qed.

Definition state_layout (env:composite_env):Prop :=
 sizeof env state_type=656 /\ alignof env state_type=4 /\
 sizeof env ecef_i_type=12 /\ alignof env ecef_i_type=4 /\
 sizeof env ned_i_type=12 /\ alignof env ned_i_type=4 /\
 sizeof env ecef_f_type=12 /\ alignof env ecef_f_type=4 /\
 sizeof env ned_f_type=12 /\ alignof env ned_f_type=4 /\
 path_info_in env state_type [G._speed_status]=Some(tushort,280) /\
 path_info_in env state_type [G._speed_input_filter]=Some(tushort,282) /\
 path_info_in env state_type [G._ecef_speed_i;G._x]=Some(tint,284) /\
 path_info_in env state_type [G._ecef_speed_i;G._y]=Some(tint,288) /\
 path_info_in env state_type [G._ecef_speed_i;G._z]=Some(tint,292) /\
 path_info_in env state_type [G._ned_speed_i;G._x]=Some(tint,296) /\
 path_info_in env state_type [G._ned_speed_i;G._y]=Some(tint,300) /\
 path_info_in env state_type [G._ned_speed_i;G._z]=Some(tint,304) /\
 path_info_in env state_type [G._ecef_speed_f;G._x]=Some(tfloat,328) /\
 path_info_in env state_type [G._ecef_speed_f;G._y]=Some(tfloat,332) /\
 path_info_in env state_type [G._ecef_speed_f;G._z]=Some(tfloat,336) /\
 path_info_in env state_type [G._ned_speed_f;G._x]=Some(tfloat,340) /\
 path_info_in env state_type [G._ned_speed_f;G._y]=Some(tfloat,344) /\
 path_info_in env state_type [G._ned_speed_f;G._z]=Some(tfloat,348) /\
 path_info_in env state_type [G._ned_origin_f]=Some(Tstruct G._LtpDef_f noattr,168) /\
 path_info_in env state_type [G._ned_origin_f;G._ltp_of_ecef;G._m]=Some(tarray tfloat 9,192).
Theorem actual_state_interface_layout:
 state_layout ce_N /\ state_layout ce_E /\ state_layout ce.
Proof. vm_compute; repeat split; reflexivity. Qed.

Theorem common_state_block:
 exists b,
 Genv.find_symbol NE.ge N._state=Some b /\
 Genv.find_symbol EE.ge E._state=Some b /\
 Genv.find_symbol GE.ge G._state=Some b.
Proof. eexists; lazy; repeat split; reflexivity. Qed.

Theorem actual_state_variable_information:
 forall b, Genv.find_symbol GE.ge G._state=Some b ->
 Genv.find_var_info NE.ge b=Some N.v_state /\
 Genv.find_var_info EE.ge b=Some E.v_state /\
 Genv.find_var_info GE.ge b=Some G.v_state.
Proof.
 intros b H. lazy in H. inversion H; subst b.
 lazy; repeat split; reflexivity.
Qed.

Theorem common_state_variable_types:
 N.v_state.(gvar_info)=state_type /\
 E.v_state.(gvar_info)=state_type /\
 G.v_state.(gvar_info)=state_type.
Proof. repeat split; reflexivity. Qed.

Print Assumptions actual_State_layout.
Print Assumptions common_state_symbols.
Print Assumptions common_layout_projections.
Print Assumptions actual_state_interface_layout.
Print Assumptions common_state_block.
Print Assumptions actual_state_variable_information.
Print Assumptions common_state_variable_types.
