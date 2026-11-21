From Stdlib Require Import List ZArith Lia.
From compcert Require Import AST Integers Values Memory Ctypes.
From PidPositionRunPos Require Import Source Execution.
From PidPositionTranslationSupport Require Import MemoryLayout TranslationArithmetic.
From PidPositionTranslationProblem Require Import Spec.
From PidPositionTranslationAttempt002 Require Import MainGoals RelationalConsequences.
Import ListNotations.
Open Scope Z_scope.
Module S:=PidPositionRunPos.Source.
Lemma physical_delta_signed:forall r p d,physical_translation r p d ->
 Int.min_signed<=d<=Int.max_signed.
Proof. unfold physical_translation,signed32;intros;change(-2147483648<=d<=2147483647);tauto. Qed.
Lemma original_axis_additions:forall gh a b axis delta,
 AxisTranslation gh a b axis delta ->
 exists r p rb pb,
 load_path Mint32 a gh gh_type(ref_pos axis)=Some(Vint r) /\
 load_global Mint32 a S._state state_type(measured_pos axis)=Some(Vint p) /\
 load_path Mint32 b gh gh_type(ref_pos axis)=Some(Vint rb) /\
 load_global Mint32 b S._state state_type(measured_pos axis)=Some(Vint pb) /\
 signed32(Int.signed r+delta)/\signed32(Int.signed p+delta) /\
 Int.add r(Int.repr delta)=rb /\Int.add p(Int.repr delta)=pb.
Proof.
 intros gh a b axis delta[r[p[rb[pb[LR[LP[LB[LQ[PHY[ER EP]]]]]]]]]].
 exists r,p,rb,pb;split;[exact LR|];split;[exact LP|];split;[exact LB|];split;[exact LQ|].
 split;[unfold physical_translation in PHY;tauto|].
 split;[unfold physical_translation in PHY;tauto|]. split.
 - rewrite Int.add_signed,Int.signed_repr by(eapply physical_delta_signed;exact PHY).
   rewrite <-ER,Int.repr_signed;reflexivity.
 - rewrite Int.add_signed,Int.signed_repr by(eapply physical_delta_signed;exact PHY).
   rewrite <-EP,Int.repr_signed;reflexivity.
Qed.
Definition MainAdditionGoal(axis:ident)(measured:bool):Prop:=
 forall gh ret a b dx dy,InputPair gh ret a b dx dy ->
 let d:=if Pos.eqb axis S._x then dx else dy in
 exists u v,
 (if measured then load_global Mint32 a S._state state_type(measured_pos axis)
 else load_path Mint32 a gh gh_type(ref_pos axis))=Some(Vint u) /\
 (if measured then load_global Mint32 b S._state state_type(measured_pos axis)
 else load_path Mint32 b gh gh_type(ref_pos axis))=Some(Vint v) /\
 signed32(Int.signed u+d)/\Int.add u(Int.repr d)=v.
Theorem main_addition_x:forall measured,MainAdditionGoal S._x measured.
Proof.
 intros measured gh ret a b dx dy[_[_[_[X Y]]]];cbn.
 destruct(original_axis_additions gh a b S._x dx X)as(r&p&rb&pb&LR&LP&LB&LQ&SR&SP&AR&AP).
 destruct measured;[exists p,pb|exists r,rb];auto.
Qed.
Theorem main_addition_y:forall measured,MainAdditionGoal S._y measured.
Proof.
 intros measured gh ret a b dx dy[_[_[_[X Y]]]];cbn.
 destruct(original_axis_additions gh a b S._y dy Y)as(r&p&rb&pb&LR&LP&LB&LQ&SR&SP&AR&AP).
 destruct measured;[exists p,pb|exists r,rb];auto.
Qed.
Definition main_overflow_1:MainAdditionGoal S._x false:=main_addition_x false.
Definition main_overflow_2:MainAdditionGoal S._y false:=main_addition_y false.
Definition main_overflow_3:MainAdditionGoal S._x true:=main_addition_x true.
Definition main_overflow_4:MainAdditionGoal S._y true:=main_addition_y true.
Definition main_overflow_5:MainAdditionGoal S._x false:=main_addition_x false.
Definition main_overflow_6:MainAdditionGoal S._y false:=main_addition_y false.
Definition MainControllerAssertion(integral:bool):Prop:=
 forall gh ret a b dx dy flight af bf,InputPair gh ret a b dx dy ->
 NormalCall gh ret flight a af ->NormalCall gh ret flight b bf ->
 forall axis,In axis[S._x;S._y] ->
 if integral then same_loaded_int32
 (load_global Mint32 af S._guidance_pid_trim_att_integrator vec_type[axis])
 (load_global Mint32 bf S._guidance_pid_trim_att_integrator vec_type[axis])
 else same_loaded_int32
 (load_global Mint32 af S._guidance_pid pid_type[S._cmd_earth;axis])
 (load_global Mint32 bf S._guidance_pid pid_type[S._cmd_earth;axis]).
Theorem main_assertion_2:MainControllerAssertion false.
Proof.
 intros gh ret a b dx dy flight af bf PAIR A B axis AX.
 pose proof(proj2(proved_position_translation gh ret a b dx dy flight PAIR)af bf A B)as[CE AE].
 exact(proj1(CE axis AX)).
Qed.
Theorem main_assertion_3:MainControllerAssertion true.
Proof.
 intros gh ret a b dx dy flight af bf PAIR A B axis AX.
 pose proof(proj2(proved_position_translation gh ret a b dx dy flight PAIR)af bf A B)as[CE AE].
 exact(proj2(CE axis AX)).
Qed.
Definition MainReturnTagsAssertion:Prop:=
 forall gh ret a b dx dy flight af bf,InputPair gh ret a b dx dy ->
 NormalCall gh ret flight a af ->NormalCall gh ret flight b bf ->
 same_loaded_int32(load_path Mint32 af ret sp_type[S._type])(load_path Mint32 bf ret sp_type[S._type]) /\
 same_loaded_int32(load_path Mint32 af ret sp_type[S._format])(load_path Mint32 bf ret sp_type[S._format]).
Theorem main_assertion_4:MainReturnTagsAssertion.
Proof.
 intros gh ret a b dx dy flight af bf PAIR A B.
 pose proof(proj2(proved_position_translation gh ret a b dx dy flight PAIR)af bf A B)as[CE[T1[T2[F1[F2 REST]]]]].
 split;[exists(Int.repr 2)|exists Int.zero];auto.
Qed.
Definition MainReturnPayloadAssertion:Prop:=
 forall gh ret a b dx dy flight af bf,InputPair gh ret a b dx dy ->
 NormalCall gh ret flight a af ->NormalCall gh ret flight b bf ->
 forall path,In path[[S._sp;S._ltp_i;S._vect;S._x];[S._sp;S._ltp_i;S._vect;S._y];[S._sp;S._ltp_i;S._heading]] ->
 same_loaded_int32(load_path Mint32 af ret sp_type path)(load_path Mint32 bf ret sp_type path).
Theorem main_assertion_5:MainReturnPayloadAssertion.
Proof.
 intros gh ret a b dx dy flight af bf PAIR A B.
 pose proof(proj2(proved_position_translation gh ret a b dx dy flight PAIR)af bf A B)as[CE[T1[T2[F1[F2 REST]]]]].
 exact REST.
Qed.
Definition MainReferenceTranslationAssertion:Prop:=
 forall gh ret a b dx dy,InputPair gh ret a b dx dy ->
 (exists rx rbx,load_path Mint32 a gh gh_type(ref_pos S._x)=Some(Vint rx) /\
 load_path Mint32 b gh gh_type(ref_pos S._x)=Some(Vint rbx)/\Int.add rx(Int.repr dx)=rbx) /\
 (exists ry rby,load_path Mint32 a gh gh_type(ref_pos S._y)=Some(Vint ry) /\
 load_path Mint32 b gh gh_type(ref_pos S._y)=Some(Vint rby)/\Int.add ry(Int.repr dy)=rby).
Theorem main_assertion_6_inputs:MainReferenceTranslationAssertion.
Proof.
 intros gh ret a b dx dy PAIR;split.
 - destruct(main_addition_x false gh ret a b dx dy PAIR)as[u[v[L[R[SR A]]]]];exists u,v;auto.
 - destruct(main_addition_y false gh ret a b dx dy PAIR)as[u[v[L[R[SR A]]]]];exists u,v;auto.
Qed.
Print Assumptions main_addition_x.
Print Assumptions main_assertion_2.
Print Assumptions main_assertion_3.
Print Assumptions main_assertion_4.
Print Assumptions main_assertion_5.
Print Assumptions main_assertion_6_inputs.

Definition MainPositionErrorsAssertion:Prop:=
 forall gh ret a b dx dy flight af bf,InputPair gh ret a b dx dy ->
 NormalCall gh ret flight a af ->NormalCall gh ret flight b bf ->
 forall axis,In axis[S._x;S._y] ->
 same_loaded_int32(load_global Mint32 af S._guidance_pid_pos_err vec_type[axis])
 (load_global Mint32 bf S._guidance_pid_pos_err vec_type[axis]).
Theorem main_assertion_1:MainPositionErrorsAssertion.
Proof. exact all_normal_position_errors_equal. Qed.
Definition MainFinalReferenceAssertion:Prop:=
 forall gh ret a b dx dy flight af bf,InputPair gh ret a b dx dy ->
 NormalCall gh ret flight a af ->NormalCall gh ret flight b bf ->
 (exists rx rbx,load_path Mint32 af gh gh_type(ref_pos S._x)=Some(Vint rx) /\
 load_path Mint32 bf gh gh_type(ref_pos S._x)=Some(Vint rbx)/\Int.add rx(Int.repr dx)=rbx) /\
 (exists ry rby,load_path Mint32 af gh gh_type(ref_pos S._y)=Some(Vint ry) /\
 load_path Mint32 bf gh gh_type(ref_pos S._y)=Some(Vint rby)/\Int.add ry(Int.repr dy)=rby).
Theorem main_assertion_6:MainFinalReferenceAssertion.
Proof.
 intros gh ret a b dx dy flight af bf PAIR A B.
 pose proof(main_assertion_6_inputs gh ret a b dx dy PAIR)as[AX AY].
 assert(FA:forall axis,In axis[S._x;S._y] ->
 load_path Mint32 af gh gh_type(ref_pos axis)=load_path Mint32 a gh gh_type(ref_pos axis)).
 { apply all_normal_reference_positions_preserved with(ret:=ret)(flight:=flight);[exact(proj1 PAIR)|exact A]. }
 assert(FB:forall axis,In axis[S._x;S._y] ->
 load_path Mint32 bf gh gh_type(ref_pos axis)=load_path Mint32 b gh gh_type(ref_pos axis)).
 { apply all_normal_reference_positions_preserved with(ret:=ret)(flight:=flight);[exact(proj1(proj2 PAIR))|exact B]. }
 split.
 - destruct AX as[x[y[L[R EQ]]]];exists x,y;rewrite FA,FB by(cbn;auto);auto.
 - destruct AY as[x[y[L[R EQ]]]];exists x,y;rewrite FA,FB by(cbn;auto);auto.
Qed.
Print Assumptions main_assertion_1.
Print Assumptions main_assertion_6.
