From Stdlib Require Import Bool List ZArith Lia.
From compcert Require Import Coqlib Maps AST Integers Values Memory Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cexec Cstrategy.
From PidPositionRunPos Require Import Source Execution.
From FiveGuidanceAllOrder Require Import PureSyntax PureDenotation.
From FiveGuidanceEntry Require Import BigstepSupport.
From PidPositionSafety Require Import PureSound.
From PidPositionTranslationSupport Require Import MemoryLayout.
From PidPositionTranslationCore Require Import FactorySemantics CoreSemantics ClampSemantics CoreClamp FlightSemantics GetterInstances.
From CoreCBMC Require Import ArithmeticTree BasicAnnotations NumericBounds ClampAnnotations.
Open Scope Z_scope.
Definition ki_rvalue:expr:=Evalof(Efield(Evalof(Evar S._guidance_pid pid_type)pid_type)S._ki tint)tint.
Definition pd_rvalue(id:ident):expr:=Evalof(Evar id tint)tint.
Definition integral_add_expr(axis pdid:ident):expr:=
 Eassignop Oadd(integral_lvalue axis)(Ebinop Omul ki_rvalue(pd_rvalue pdid)tint)tint tint.
Definition command_add_expr(axis:ident):expr:=
 Eassignop Oadd(cmd_lvalue axis)(Ebinop Oshr(Evalof(integral_lvalue axis)tint)source_count16 tint)tint tint.
Lemma original_flight_arithmetic_source:flight_yes=
 Ssequence(Sdo(integral_add_expr S._x S._pd_x))
 (Ssequence(Sdo(integral_add_expr S._y S._pd_y))
 (Ssequence(Ssequence(Sdo(integral_clamp_expr S._x))(Sdo(integral_clamp_expr S._y)))
 (Ssequence(Sdo(command_add_expr S._x))(Sdo(command_add_expr S._y))))).
Proof. reflexivity. Qed.
Theorem original_flight_axis_annotations:forall e m bpd bp bi bt axis pdid ofs pd ki integral command,
 e!pdid=Some(bpd,tint) ->
 e!S._guidance_pid=None ->Genv.find_symbol ge S._guidance_pid=Some bp ->
 e!S._guidance_pid_trim_att_integrator=None ->Genv.find_symbol ge S._guidance_pid_trim_att_integrator=Some bi ->
 e!S._traj_max_bank=None ->Genv.find_symbol ge S._traj_max_bank=Some bt ->
 (axis=S._x /\ofs=0)\/(axis=S._y /\ofs=4) ->
 Mem.load Mint32 m bpd 0=Some(Vint pd) ->Mem.load Mint32 m bp 8=Some(Vint ki) ->
 Mem.load Mint32 m bi ofs=Some(Vint integral) ->
 Mem.load Mint32 m bp(32+ofs)=Some(Vint command) ->
 Mem.load Mint32 m bt 0=Some(Vint(Int.repr 1429)) ->
 0<=Int.signed ki<=100 ->int_bound pd 12800 ->
 int_bound integral 101280000 ->int_bound command 2858 ->
 arithmetic_tree ge e m(integral_add_expr axis pdid) /\
 arithmetic_tree ge e m(integral_clamp_expr axis) /\
 arithmetic_tree ge e m(command_add_expr axis).
Proof.
 intros e m bpd bp bi bt axis pdid ofs pd ki integral command ENV NP SP NI SI NT ST AX PD KI ILOAD CLOAD LIMIT GAIN PDB IB CB.
 assert(DPV:pure_rval ge e m(pd_rvalue pdid)=Some(Vint pd)).
 { apply(proj1(simple_big_denotation ge e m));[|reflexivity].
   unfold pd_rvalue;eapply read_scalar with(chunk:=Mint32)(b:=bpd)(ofs:=Ptrofs.zero);
   [apply esl_var_local;exact ENV|reflexivity|reflexivity|reflexivity|exact PD]. }
 assert(KPV:pure_rval ge e m ki_rvalue=Some(Vint ki)).
 { apply(proj1(simple_big_denotation ge e m));[|reflexivity].
   unfold ki_rvalue,pid_type;core_rv I I I NP I I SP I I I I I I. }
 assert(ILV:eval_simple_lvalue ge e m(integral_lvalue axis)bi(Ptrofs.repr ofs)Full).
 { destruct AX as[[-> ->]|[-> ->]];unfold integral_lvalue,vec_type;
   lazymatch goal with|-eval_simple_lvalue _ _ _ _ _(Ptrofs.repr ?n)_ =>
    replace(Ptrofs.repr n)with(Ptrofs.add Ptrofs.zero(Ptrofs.repr n))by reflexivity end;
   core_lv I I I I I I I I I NI SI I I. }
 assert(CLV:eval_simple_lvalue ge e m(cmd_lvalue axis)bp(Ptrofs.repr(32+ofs))Full).
 { destruct AX as[[-> ->]|[-> ->]];unfold cmd_lvalue,pid_type,vec_type;
   lazymatch goal with|-eval_simple_lvalue _ _ _ _ _(Ptrofs.repr ?n)_ =>
    replace(Ptrofs.repr n)with(Ptrofs.add(Ptrofs.add Ptrofs.zero(Ptrofs.repr 32))(Ptrofs.repr(n-32)))by reflexivity end;
   core_lv I I I NP I I SP I I I I I I. }
 assert(ILP:pure_lval ge e m(integral_lvalue axis)=Some(bi,Ptrofs.repr ofs,Full)).
 { apply(proj2(simple_big_denotation ge e m));[exact ILV|reflexivity]. }
 assert(CLP:pure_lval ge e m(cmd_lvalue axis)=Some(bp,Ptrofs.repr(32+ofs),Full)).
 { apply(proj2(simple_big_denotation ge e m));[exact CLV|reflexivity]. }
 assert(IREAD:Cexec.do_deref_loc ge quiet_world tint m bi(Ptrofs.repr ofs)Full=Some(quiet_world,E0,Vint integral)).
 { eapply raw_deref_complete with(ch:=Mint32);[reflexivity|reflexivity|].
   destruct AX as[[-> ->]|[-> ->]];exact ILOAD. }
 assert(CREAD:Cexec.do_deref_loc ge quiet_world tint m bp(Ptrofs.repr(32+ofs))Full=Some(quiet_world,E0,Vint command)).
 { eapply raw_deref_complete with(ch:=Mint32);[reflexivity|reflexivity|].
   destruct AX as[[-> ->]|[-> ->]];exact CLOAD. }
 assert(IPV:pure_rval ge e m(Evalof(integral_lvalue axis)tint)=Some(Vint integral)).
 { cbn[pure_rval];fold(pure_lval ge e m).
   rewrite ILP;change(match Cexec.do_deref_loc ge quiet_world tint m bi(Ptrofs.repr ofs)Full with
   |Some(_,_,v)=>Some v|None=>None end=Some(Vint integral));rewrite IREAD;reflexivity. }
 assert(MULPV:pure_rval ge e m(Ebinop Omul ki_rvalue(pd_rvalue pdid)tint)=Some(Vint(Int.mul ki pd))).
 { cbn[pure_rval];fold(pure_rval ge e m);rewrite KPV,DPV;reflexivity. }
 destruct(gain_product_bound ki pd 12800 GAIN PDB ltac:(lia)ltac:(lia))as[MULBOUND MULSAFE].
 destruct(bounded_sum integral(Int.mul ki pd)101280000 1280000 IB MULBOUND ltac:(lia)ltac:(lia)ltac:(lia))as[SUMBOUND SUMSAFE].
 assert(MULTREE:arithmetic_tree ge e m(Ebinop Omul ki_rvalue(pd_rvalue pdid)tint)).
 { eapply binary_values_tree;[apply data_expression_tree;reflexivity|apply data_expression_tree;reflexivity|exact KPV|exact DPV|exact MULSAFE]. }
 assert(SHPV:pure_rval ge e m(Ebinop Oshr(Evalof(integral_lvalue axis)tint)source_count16 tint)=Some(Vint(Int.shr integral(Int.repr 16)))).
 { change((match pure_rval ge e m(Evalof(integral_lvalue axis)tint),pure_rval ge e m source_count16 with
   |Some a,Some b=>sem_binary_operation ge Oshr a tint b tint m|_,_=>None end)=Some(Vint(Int.shr integral(Int.repr 16)))).
   rewrite IPV,source_count16_value;reflexivity. }
 assert(SHTREE:arithmetic_tree ge e m(Ebinop Oshr(Evalof(integral_lvalue axis)tint)source_count16 tint)).
 { eapply binary_values_tree;[apply data_expression_tree;reflexivity|apply source_count16_tree|exact IPV|apply source_count16_value|].
   change(Int.unsigned(Int.repr 16)<32);vm_compute;congruence. }
 assert(SHBOUND:int_bound(Int.shr integral(Int.repr 16))1546).
 { eapply shift_bound with(d:=65536)(bound:=101280000);
   [exact IB|lia|reflexivity|vm_compute;congruence|vm_compute;congruence]. }
 destruct(bounded_sum command(Int.shr integral(Int.repr 16))2858 1546 CB SHBOUND ltac:(lia)ltac:(lia)ltac:(lia))as[COMBOUND COMSAFE].
 split.
 - unfold integral_add_expr;eapply compound_add_tree.
   + apply data_expression_tree;reflexivity.
   + exact MULTREE.
   + reflexivity.
   + reflexivity.
   + exact ILP.
   + exact IREAD.
   + exact MULPV.
   + exact SUMSAFE.
 - split.
   + eapply original_integrator_clamp_annotation;eassumption.
   + unfold command_add_expr;eapply compound_add_tree.
     * apply data_expression_tree;reflexivity.
     * exact SHTREE.
     * reflexivity.
     * reflexivity.
     * exact CLP.
     * exact CREAD.
     * exact SHPV.
     * exact COMSAFE.
Qed.
Print Assumptions original_flight_axis_annotations.
