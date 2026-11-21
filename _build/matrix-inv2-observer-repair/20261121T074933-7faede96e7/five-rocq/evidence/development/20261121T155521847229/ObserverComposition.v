From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Maps Integers Floats AST Values Memory Memdata Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cexec Cstrategy Smallstep.
From FiveGuidanceAllOrder Require Import PureSyntax PureDenotation PureProgress.
From FiveMatInv3Case Require Import MatrixMemory.
From FivePprzFloatMatInv2d Require Import Execution.
From FiveInv2Case Require Import Contract Expressions RecheckSupport Replay ExactReplay TraceInputs.
From FiveMatrixInverseSupport Require Import Kernels.
Import ListNotations.
Local Open Scope Z_scope.
(** These are the original harness expressions after Csem has bound the call
    results and reduced the three local array names to their actual blocks.
    No numerical matrix is substituted for a memory load. *)
Definition Load0(b:block):expr:=Evalof(Eloc b Ptrofs.zero Full tfloat)tfloat.
Definition ResidualExpr(input output:block):expr:=
 Ebinop Osub(Ebinop Omul(Load0 input)(Load0 output)tfloat)(Eval(Vsingle one)tfloat)tfloat.
Definition ScaleAssertion:expr:=Ebinop Oeq(Eval(Result base2)type_bool)(Eval(Result small2)type_bool)tint.
Definition SuccessTest:expr:=Ebinop One(Eval(Result large2)type_bool)(Eval(Vint Int.zero)tint)tint.
Definition Lower(res:block):expr:=Ebinop Ogt(Load0 res)(Eval(Vsingle(Float32.of_bits(Int.repr 3204448256)))tfloat)tint.
Definition Upper(res:block):expr:=Ebinop Olt(Load0 res)(Eval(Vsingle(Float32.of_bits(Int.repr 1056964608)))tfloat)tint.
Definition ResidualAssertion(res:block):expr:=Eseqor SuccessTest(Eseqand(Lower res)(Upper res)tint)tint.
Definition MinusOne:float32:=Float32.of_bits(Int.repr 3212836864).
Definition ExprReturns(m mf:mem)(a:expr)(v:val):Prop:=forall fn k e,
 star Csem.step Execution.ge(ExprState fn a k e m)E0(ExprState fn(Eval v(typeof a))k e mf).
Lemma pure_returns:forall m a v,simple a=true->(forall e,pure_rval Execution.ge e m a=Some v)->ExprReturns m m a v.
Proof. intros m a v SI EV fn k e;refine(Cstrategy.eval_simple_rvalue_steps Execution.ge fn k e m a v _ (fun x=>x) _).
 - exact(proj1(pure_eval_big a Execution.ge e m SI)v(EV e)).
 - constructor.
Qed.
Lemma load0_value:forall e m b x,Mem.load Mfloat32 m b 0=Some(Vsingle x)->pure_rval Execution.ge e m(Load0 b)=Some(Vsingle x).
Proof. intros e m b x LD;cbv[Load0 pure_rval pure_lval Cexec.do_deref_loc tfloat noattr access_mode type_is_volatile attr_of_type attr_volatile Mem.loadv].
 rewrite ?dec_eq_true,Ptrofs.unsigned_zero;rewrite zle_true by(change(4<=18446744073709551616);lia);rewrite LD;reflexivity. Qed.
Lemma residual_value:forall e m input output,
 Mem.load Mfloat32 m input 0=Some(Vsingle(large2 0))->
 Mem.load Mfloat32 m output 0=Some(Vsingle(Output large2 0))->
 pure_rval Execution.ge e m(ResidualExpr input output)=Some(Vsingle MinusOne).
Proof. intros e m input output LI LO.
 assert(N:residual2 large2=MinusOne)by(rewrite <-(Float32.of_to_bits(residual2 large2)),large2_residual;reflexivity);rewrite <-N;unfold ResidualExpr,residual2.
 eapply rval_sub;try reflexivity.
 eapply rval_mul;try reflexivity;eapply load0_value;eauto. Qed.
Lemma large_post_loads:forall m mf output input,
 Post m mf output input Ptrofs.zero Ptrofs.zero large2->
 Mem.load Mfloat32 mf input 0=Some(Vsingle(large2 0))/\
 Mem.load Mfloat32 mf output 0=Some(Vsingle(Output large2 0)).
Proof. intros m mf output input POST;split.
 - pose proof(proj2(proj2(proj1(proj2 POST)))0 ltac:(lia))as LD;rewrite Ptrofs.unsigned_zero in LD;exact LD.
 - assert(R:Reject large2=false)by(vm_compute;reflexivity).
   pose proof(successful_post_cells m mf output input Ptrofs.zero Ptrofs.zero large2 POST R 0 ltac:(lia))as BY;rewrite Ptrofs.unsigned_zero in BY.
   pose proof(Mem.loadbytes_load Mfloat32 mf output 0 _ BY ltac:(change(4|0);exists 0;lia))as LD.
   pose proof(decode_encode_val_general(Vsingle(Output large2 0))Mfloat32 Mfloat32)as DE.
   change(decode_val Mfloat32(encode_val Mfloat32(Vsingle(Output large2 0)))=Vsingle(Output large2 0))in DE;rewrite DE in LD;exact LD.
Qed.
Theorem scale_assertion_false:forall m,ExprReturns m m ScaleAssertion(Vint Int.zero).
Proof. intros m;apply pure_returns;[reflexivity|intros;vm_compute;reflexivity]. Qed.
Print Assumptions large_post_loads.
Print Assumptions scale_assertion_false.
