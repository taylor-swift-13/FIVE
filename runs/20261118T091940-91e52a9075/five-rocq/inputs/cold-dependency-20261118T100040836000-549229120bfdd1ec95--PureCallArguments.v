From Stdlib Require Import List Bool ZArith.
From compcert Require Import Coqlib Errors Maps Integers Values Memory Events Globalenvs Determinism Ctypes Cop Csyntax Csem Cexec Cstrategy Smallstep.
From FiveGuidanceAllOrder Require Import PureDenotation PureProgress CallfreeExecution.
From PidPositionSafety Require Import PureSound.
Import ListNotations.
Section PURE_ARGUMENTS.
Variable ge:genv.
Variable e:env.
Variable m:mem.
Lemma rval_transport:forall a b v,
 simple a=true ->simple b=true ->pure_rval ge e m a=pure_rval ge e m b ->
 eval_simple_rvalue ge e m a v ->eval_simple_rvalue ge e m b v.
Proof.
 intros a b v SA SB EQ EV.
 apply(proj1(pure_eval_big b ge e m SB)).
 rewrite <-EQ;exact(proj1(simple_big_denotation ge e m)a v EV SA).
Qed.
Lemma pure_replace_lred:forall to C a b mf,
 context LV to C ->simple(C a)=true ->lred ge e a m b mf ->
 mf=m /\typeof(C a)=typeof(C b)/\simple(C b)=true/\pure_eq ge e m to(C a)(C b).
Proof.
 intros to C a b mf CT SI STEP.
 destruct(pure_lred ge e a m b mf STEP)as[MM[TY[SB EQ]]];subst mf.
 repeat split;auto.
 - apply(context_type_eq _ _ _ CT);symmetry;exact TY.
 - exact(simple_context_replace _ _ _ CT a b (eq_sym TY) SI SB).
 - eapply pure_context_congr;[exact CT|symmetry;exact TY|exact EQ].
Qed.
Lemma pure_replace_rred:forall to C a b t mf,
 context RV to C ->simple(C a)=true ->rred ge a m t b mf ->
 mf=m /\t=E0/\typeof(C a)=typeof(C b)/\simple(C b)=true/\pure_eq ge e m to(C a)(C b).
Proof.
 intros to C a b t mf CT SI STEP.
 pose proof(simple_context_hole _ _ _ CT a SI)as SUB.
 destruct(pure_rred ge e a m t b mf SUB STEP)as[MM[TT[TY[SB EQ]]]];subst mf t.
 repeat split;auto.
 - apply(context_type_eq _ _ _ CT);symmetry;exact TY.
 - exact(simple_context_replace _ _ _ CT a b (eq_sym TY) SI SB).
 - eapply pure_context_congr;[exact CT|symmetry;exact TY|exact EQ].
Qed.
Lemma simplelist_hole:forall from C,contextlist from C ->forall a,
 simplelist(C a)=true ->simple a=true.
Proof.
 induction 1;simpl;intros a SI;apply andb_true_iff in SI as[A B].
 - eapply simple_context_hole;eauto.
 - eapply IHcontextlist;eauto.
Qed.
Lemma arguments_transport:forall from C,contextlist from C ->forall a b params vals,
 typeof a=typeof b ->simple b=true ->pure_eq ge e m from a b ->
 simplelist(C a)=true ->eval_simple_list ge e m(C a)params vals ->
 simplelist(C b)=true /\eval_simple_list ge e m(C b)params vals.
Proof.
 intros from C CT;induction CT;intros a b params vals TY SB EQ SI EV;
 cbn[simplelist]in SI;apply andb_true_iff in SI as[SA SREST];
 inversion EV;subst.
 - pose proof(simple_context_replace _ _ _ H a b TY SA SB)as SN.
   pose proof(pure_context_congr ge e m _ _ _ H a b TY EQ)as DEN.
   split;[cbn[simplelist];rewrite SN,SREST;reflexivity|].
   eapply esrl_cons with(v':=v').
   + eapply rval_transport;[exact SA|exact SN|exact DEN|eassumption].
   + rewrite <-(context_type_eq _ _ _ H a b TY);eassumption.
   + eassumption.
 - destruct(IHCT a b tyl vl TY SB EQ SREST ltac:(eassumption))as[SR EVR].
   split;[cbn[simplelist];rewrite SA,SR;reflexivity|].
   eapply esrl_cons;eauto.
Qed.
Lemma big_subexpression_safe:forall from to C a,
 context from to C ->simple(C a)=true ->big_defined ge e m to(C a) ->
 imm_safe ge e from a m.
Proof.
 intros from to C a CT SI BD.
 pose proof(big_context_hole _ _ _ CT a ge e m SI BD)as SUB.
 destruct from;cbn[big_defined]in SUB.
 - destruct SUB as[b[ofs[bf EV]]];exact(proj2(big_immediate ge e m)a b ofs bf EV).
 - destruct SUB as[v EV];exact(proj1(big_immediate ge e m)a v EV).
Qed.
Lemma arguments_subexpression_safe:forall from C,contextlist from C ->forall a params vals,
 simplelist(C a)=true ->eval_simple_list ge e m(C a)params vals ->
 imm_safe ge e from a m.
Proof.
 intros from C CT;induction CT;intros a params vals SI EV;
 cbn[simplelist]in SI;apply andb_true_iff in SI as[SA SR];inversion EV;subst.
 - eapply big_subexpression_safe;[exact H|exact SA|].
   unfold big_defined;eexists;eassumption.
 - eapply IHCT;eauto.
Qed.
Fixpoint all_literals(al:exprlist):bool:=
 match al with Enil=>true|Econs a rest=>literal RV a&&all_literals rest end.
Lemma ready_arguments_cast:forall al params vals,
 eval_simple_list ge e m al params vals ->all_literals al=true ->
 cast_arguments m al params vals.
Proof.
 induction 1;intros READY;[constructor|].
 cbn[all_literals]in READY;apply andb_true_iff in READY as[LIT REST].
 destruct(literal_r_inv r LIT)as[v0[ty0 EQ]];subst r;inversion H;subst.
 econstructor;eauto.
Qed.
Lemma cast_values_unique:forall al params x y,
 cast_arguments m al params x ->eval_simple_list ge e m al params y ->x=y.
Proof.
 intros al params x y CAST;revert y;induction CAST;intros y EV;inversion EV;subst;auto.
 match goal with V:eval_simple_rvalue _ _ _ (Eval _ _) _ |- _=>inversion V;subst end.
 cbn[typeof]in *;match goal with A:sem_cast _ _ _ _=Some _,B:sem_cast _ _ _ _=Some _ |- _=>
 rewrite A in B;injection B as EQ;subst end.
 f_equal;apply IHCAST;assumption.
Qed.
Lemma arguments_ready_or_step:forall al params vals,
 eval_simple_list ge e m al params vals ->
 all_literals al=true \/exists C a,
 contextlist RV C /\al=C a/\literal RV a=false/\imm_safe ge e RV a m.
Proof.
 induction 1.
 - left;reflexivity.
 - destruct(literal RV r)eqn:LIT.
   + destruct IHeval_simple_list as[READY|[C[a[CT[EQ[NL SAFE]]]]]].
     * left;cbn[all_literals];rewrite LIT,READY;reflexivity.
     * subst rl;right;exists(fun x=>Econs r(C x)),a;repeat split;auto;constructor;exact CT.
   + right;exists(fun x=>Econs x rl),r;repeat split;auto.
     * constructor;constructor.
     * exact(proj1(big_immediate ge e m)r v' H).
Qed.
Lemma call_immediate:forall fn al params ret cc vf fd vals ty,
 eval_simple_rvalue ge e m fn vf ->
 eval_simple_list ge e m al params vals ->
 classify_fun(typeof fn)=fun_case_f params ret cc ->
 Genv.find_funct ge vf=Some fd ->type_of_fundef fd=Tfunction params ret cc ->
 imm_safe ge e RV(Ecall fn al ty)m.
Proof.
 intros fn al params ret cc vf fd vals ty FV ARGS CLASS FIND SIG.
 destruct(literal RV fn)eqn:LIT.
 - destruct(literal_r_inv fn LIT)as[v[fty EQ]];subst fn;inversion FV;subst.
   destruct(arguments_ready_or_step al params vals ARGS)as[READY|[C[a[CT[EQ[NL SAFE]]]]]].
   + eapply imm_safe_callred with(C:=fun x=>x).
     * eapply red_call with(vargs:=vals)(tyargs:=params)(tyres:=ret)(cconv:=cc);
       [exact FIND|exact(ready_arguments_cast al params vals ARGS READY)|exact SIG|exact CLASS].
     * constructor.
   + subst al;eapply lift_immediate with(from:=RV)(C:=fun x=>Ecall(Eval vf fty)(C x)ty);
     [apply ctx_call_right;exact CT|exact NL|exact SAFE].
 - eapply lift_immediate with(from:=RV)(C:=fun x=>Ecall x al ty).
   + constructor;constructor.
   + exact LIT.
   + exact(proj1(big_immediate ge e m)fn vf FV).
Qed.
Lemma call_not_stuck:forall fn al params ret cc vf fd vals ty,
 simple fn=true ->simplelist al=true ->
 eval_simple_rvalue ge e m fn vf ->eval_simple_list ge e m al params vals ->
 classify_fun(typeof fn)=fun_case_f params ret cc ->
 Genv.find_funct ge vf=Some fd ->type_of_fundef fd=Tfunction params ret cc ->
 Csem.not_stuck ge e(Ecall fn al ty)m.
Proof.
 intros fn al params ret cc vf fd vals ty SF SA FV ARGS CLASS FIND SIG from C a CT EQ.
 inversion CT;subst;cbn in EQ;try discriminate.
 - subst a;eapply call_immediate;eauto.
 - inversion EQ;subst;eapply big_subexpression_safe;[eassumption|exact SF|].
   unfold big_defined;eexists;exact FV.
 - inversion EQ;subst;eapply arguments_subexpression_safe;eauto.
Qed.
End PURE_ARGUMENTS.
Print Assumptions call_not_stuck.
