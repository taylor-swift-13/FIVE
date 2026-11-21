From Stdlib Require Import Bool List ZArith Lia.
From compcert Require Import Coqlib Maps AST Integers Values Memory Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cexec Cstrategy.
From PidPositionRunPos Require Import Source Execution.
From FiveGuidanceAllOrder Require Import PureSyntax PureDenotation.
From FiveGuidanceEntry Require Import BigstepSupport.
From PidPositionSafety Require Import PureSound.
From PidPositionTranslationSupport Require Import MemoryLayout.
From PidPositionTranslationCore Require Import FactorySemantics CoreSemantics ClampSemantics CoreClamp FlightSemantics GetterInstances.
From CoreCBMC Require Import ArithmeticTree BasicAnnotations NumericBounds.
Open Scope Z_scope.
Definition source_count16:expr:=Ebinop Oadd(Eval(Vint(Int.repr 12))tint)
 (Ebinop Omul(Eval(Vint(Int.repr 2))tint)(Eval(Vint(Int.repr 2))tint)tint)tint.
Definition source_integral_limit:expr:=Ebinop Oshl(max_rvalue S._traj_max_bank)source_count16 tint.
Definition integral_lvalue(axis:ident):expr:=
 Efield(Evalof(Evar S._guidance_pid_trim_att_integrator vec_type)vec_type)axis tint.
Definition integral_clamp_expr(axis:ident):expr:=
 Eassign(integral_lvalue axis)(clamp_expr(Evalof(integral_lvalue axis)tint)source_integral_limit)tint.
Definition flight_yes:statement:=match flight_statement with Sifthenelse _ yes _=>yes|_=>Sskip end.
Lemma original_integral_clamp_source:
 top_statement 2 flight_yes=Ssequence(Sdo(integral_clamp_expr S._x))(Sdo(integral_clamp_expr S._y)).
Proof. reflexivity. Qed.
Lemma source_count16_value:forall ge0 e m,
 pure_rval ge0 e m source_count16=Some(Vint(Int.repr 16)).
Proof. reflexivity. Qed.
Lemma source_count16_tree:forall ge0 e m,arithmetic_tree ge0 e m source_count16.
Proof. intros;vm_compute;repeat split;congruence. Qed.
Lemma max_value:forall e m id block value,
 e!id=None ->Genv.find_symbol ge id=Some block ->Mem.load Mint32 m block 0=Some(Vint value) ->
 pure_rval ge e m(max_rvalue id)=Some(Vint value).
Proof.
 intros e m id block value LOCAL SYM LOAD.
 apply(proj1(simple_big_denotation ge e m));[|reflexivity].
 unfold max_rvalue;eapply read_scalar with(chunk:=Mint32)(b:=block)(ofs:=Ptrofs.zero);
 [apply esl_var_global;assumption|reflexivity|reflexivity|reflexivity|exact LOAD].
Qed.
Lemma original_integral_limit_tree:forall e m bt,
 e!S._traj_max_bank=None ->Genv.find_symbol ge S._traj_max_bank=Some bt ->
 Mem.load Mint32 m bt 0=Some(Vint(Int.repr 1429)) ->
 arithmetic_tree ge e m source_integral_limit /\
 pure_rval ge e m source_integral_limit=Some(Vint(Int.repr 93650944)).
Proof.
 intros e m bt LOCAL SYM LOAD;pose proof(max_value e m S._traj_max_bank bt(Int.repr 1429)LOCAL SYM LOAD)as MAX.
 split.
 - unfold source_integral_limit;eapply binary_values_tree.
   + apply data_expression_tree;reflexivity.
   + apply source_count16_tree.
   + exact MAX.
   + apply source_count16_value.
   + change(Int.unsigned(Int.repr 16)<32 /\0<=Int.signed(Int.repr 1429) /\signed32(Int.signed(Int.repr 1429)*two_p(Int.unsigned(Int.repr 16)))).
     vm_compute;repeat split;congruence.
 - unfold source_integral_limit,binary_condition;cbn[pure_rval];fold(pure_rval ge e m).
   rewrite MAX,source_count16_value;reflexivity.
Qed.
Theorem original_integrator_clamp_annotation:forall e m bt axis,
 e!S._traj_max_bank=None ->Genv.find_symbol ge S._traj_max_bank=Some bt ->
 Mem.load Mint32 m bt 0=Some(Vint(Int.repr 1429)) ->
 arithmetic_tree ge e m(integral_clamp_expr axis).
Proof.
 intros e m bt axis LOCAL SYM LOAD.
 destruct(original_integral_limit_tree e m bt LOCAL SYM LOAD)as[TREE VALUE].
 unfold integral_clamp_expr;cbn[arithmetic_tree];split.
 - apply data_expression_tree;reflexivity.
 - eapply int32_clamp_tree;[apply data_expression_tree;reflexivity|exact TREE|reflexivity|exact VALUE|].
   change(93650944<> -2147483648);lia.
Qed.
Theorem original_command_clamp_annotation:forall e m bm maxid axis maximum,
 e!maxid=None ->Genv.find_symbol ge maxid=Some bm ->
 Mem.load Mint32 m bm 0=Some(Vint maximum) ->Int.signed maximum<> -2147483648 ->
 match clamp_assignment(cmd_lvalue axis)(max_rvalue maxid)with
 Sdo a=>arithmetic_tree ge e m a|_=>False end.
Proof.
 intros e m bm maxid axis maximum LOCAL SYM LOAD NOTMIN.
 unfold clamp_assignment;cbn[arithmetic_tree];split.
 - apply data_expression_tree;reflexivity.
 - eapply int32_clamp_tree.
   + apply data_expression_tree;reflexivity.
   + apply data_expression_tree;reflexivity.
   + reflexivity.
   + eapply max_value;eassumption.
   + exact NOTMIN.
Qed.
Print Assumptions original_integrator_clamp_annotation.
Print Assumptions original_command_clamp_annotation.
