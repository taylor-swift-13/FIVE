From Stdlib Require Import List ZArith.
From compcert Require Import Coqlib Errors Maps AST Integers Values Memory Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cstrategy Smallstep.
From PidPositionRunPos Require Import Source Execution.
From FiveGuidanceEntry Require Import BigstepSupport.
From PidPositionTranslationSupport Require Import MemoryLayout.
Import ListNotations.
Open Scope Z_scope.
Module Source := PidPositionRunPos.Source.
Module Execution := PidPositionRunPos.Execution.
Definition state_expr := Evalof(Evar Source._state state_type) state_type.
Definition cache_expr (field:ident) :=
 Eunop Onotbool
 (Ebinop Oand (Ebinop Oshr (Evalof(Efield state_expr field tushort)tushort)
 (Eval(Vint Int.one)tint)tint) (Eval(Vint Int.one)tint)tint)tint.
Definition ned_ptr := tptr(Tstruct Source._NedCoor_i noattr).
Definition getter_address (field:ident) := Eaddrof(Efield state_expr field (Tstruct Source._NedCoor_i noattr)) ned_ptr.
Lemma cached_mask_shift : forall flags,
 Int.and flags (Int.repr 2)=Int.repr 2 -> Int.and(Int.shr flags Int.one) Int.one=Int.one.
Proof.
 intros flags H;pose proof(f_equal(fun x=>Int.shr x Int.one)H) as S.
 rewrite <-Int.and_shr in S. change(Int.and(Int.shr flags Int.one)Int.one=Int.one)in S;exact S.
Qed.
Section SYMBOLIC.
Variable m:mem.
Variable b:block.
Variable co:composite.
Hypothesis SYM:Genv.find_symbol Execution.ge Source._state=Some b.
Hypothesis CO:PTree.get Source._State (genv_cenv Execution.ge)=Some co.
Lemma state_pointer_value : eval_simple_rvalue Execution.ge empty_env m state_expr (Vptr b Ptrofs.zero).
Proof.
 unfold state_expr;eapply esr_rvalof.
 - apply esl_var_global;[reflexivity|exact SYM].
 - reflexivity.
 - reflexivity.
 - apply deref_loc_copy;reflexivity.
Qed.
Lemma state_field_address : forall field fty delta,
 field_offset Execution.ge field (co_members co)=OK(delta,Full) ->
 eval_simple_lvalue Execution.ge empty_env m (Efield state_expr field fty) b (Ptrofs.repr delta) Full.
Proof.
 intros field fty delta OFF.
 replace(Ptrofs.repr delta)with(Ptrofs.add Ptrofs.zero(Ptrofs.repr delta))by(apply Ptrofs.add_zero_l).
 eapply esl_field_struct;[exact state_pointer_value|reflexivity|exact CO|exact OFF].
Qed.
Lemma cache_expression_false : forall field flags,
 field_offset Execution.ge field (co_members co)=OK(2,Full) ->
 Mem.load Mint16unsigned m b 2=Some(Vint flags) ->
 Int.and flags (Int.repr 2)=Int.repr 2 ->
 eval_simple_rvalue Execution.ge empty_env m (cache_expr field) (Vint Int.zero).
Proof.
 intros field flags OFF LOAD VALID;unfold cache_expr.
 eapply esr_unop with(v1:=Vint Int.one).
 - eapply esr_binop with(v1:=Vint(Int.shr flags Int.one))(v2:=Vint Int.one).
   + eapply esr_binop with(v1:=Vint flags)(v2:=Vint Int.one).
     * eapply BigstepSupport.read_scalar with(b:=b)(ofs:=Ptrofs.repr 2)(bf:=Full)(chunk:=Mint16unsigned).
       -- apply state_field_address;exact OFF.
       -- reflexivity.
       -- reflexivity.
       -- reflexivity.
       -- exact LOAD.
     * constructor.
     * reflexivity.
   + constructor.
   + change(Some(Vint(Int.and(Int.shr flags Int.one)Int.one))=Some(Vint Int.one)).
     rewrite(cached_mask_shift flags VALID);reflexivity.
 - reflexivity.
Qed.
Lemma getter_return_expression : forall field delta,
 field_offset Execution.ge field (co_members co)=OK(delta,Full) ->
 eval_simple_rvalue Execution.ge empty_env m (getter_address field) (Vptr b(Ptrofs.repr delta)).
Proof. intros;apply esr_addrof;apply state_field_address;assumption. Qed.
Theorem original_position_getter_cached_normal : forall flags delta,
 field_offset Execution.ge Source._pos_status (co_members co)=OK(2,Full) ->
 field_offset Execution.ge Source._ned_pos_i (co_members co)=OK(delta,Full) ->
 Mem.load Mint16unsigned m b 2=Some(Vint flags) ->
 Int.and flags (Int.repr 2)=Int.repr 2 ->
 star Csem.step Execution.ge (Callstate(Internal Source.f_stateGetPositionNed_i)[] Kstop m) E0
 (Returnstate(Vptr b(Ptrofs.repr delta))Kstop m).
Proof.
 intros flags delta STATUS POS LOAD VALID.
 apply BigstepSupport.funcall_original_normal.
 eapply Cstrategy.eval_funcall_internal with(e:=empty_env)(m1:=m)(m2:=m)(m3:=m)
 (out:=Out_return(Some(Vptr b(Ptrofs.repr delta),ned_ptr))).
 - constructor.
 - constructor.
 - constructor.
 - cbn[Source.f_stateGetPositionNed_i fn_body].
   eapply BigstepSupport.sequence_normal.
   + eapply Cstrategy.exec_Sifthenelse with(v1:=Vint Int.zero)(b:=false)(m1:=m)(t1:=E0)(t2:=E0).
     * apply BigstepSupport.simple_expression;[apply cache_expression_false;assumption|reflexivity].
     * reflexivity.
     * constructor.
   + apply Cstrategy.exec_Sreturn_some.
     apply BigstepSupport.simple_expression;[apply getter_return_expression;exact POS|reflexivity].
 - cbn[Cstrategy.outcome_result_value Source.f_stateGetPositionNed_i fn_return].
   split;[discriminate|reflexivity].
 - reflexivity.
Qed.
End SYMBOLIC.
