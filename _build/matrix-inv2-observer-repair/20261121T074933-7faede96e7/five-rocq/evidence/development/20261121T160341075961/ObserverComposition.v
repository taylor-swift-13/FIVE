From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Maps Integers Floats AST Values Memory Memdata Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cexec Cstrategy Smallstep.
From FiveGuidanceAllOrder Require Import PureSyntax PureDenotation PureProgress.
From FiveMatInv3Case Require Import MatrixMemory GuardWitness PairExtend.
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
Definition ScaleAssertion:expr:=Ebinop Oeq(Ecast(Eval(Result base2)type_bool)tint)(Ecast(Eval(Result small2)type_bool)tint)tint.
Definition SuccessTest:expr:=Ebinop One(Ecast(Eval(Result large2)type_bool)tint)(Eval(Vint Int.zero)tint)tint.
Definition Lower(res:block):expr:=Ebinop Ogt(Load0 res)(Eunop Oneg(Eval(Vsingle(Float32.of_bits(Int.repr 1056964608)))tfloat)tfloat)tint.
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
Lemma lower_value:forall e m res,Mem.load Mfloat32 m res 0=Some(Vsingle MinusOne)->pure_rval Execution.ge e m(Lower res)=Some(Vint Int.zero).
Proof. intros e m res LD;change(match pure_rval Execution.ge e m(Load0 res)with
 |Some v=>sem_binary_operation Execution.ge Ogt v tfloat(Vsingle(Float32.neg(Float32.of_bits(Int.repr 1056964608))))tfloat m|None=>None end=Some(Vint Int.zero)).
 rewrite(load0_value e m res MinusOne LD);vm_compute;reflexivity. Qed.
Lemma success_test_value:forall e m,pure_rval Execution.ge e m SuccessTest=Some(Vint Int.zero).
Proof. intros;vm_compute;reflexivity. Qed.
Theorem residual_assignment:forall m after input output res,
 Mem.load Mfloat32 m input 0=Some(Vsingle(large2 0))->
 Mem.load Mfloat32 m output 0=Some(Vsingle(Output large2 0))->
 Mem.store Mfloat32 m res 0(Vsingle MinusOne)=Some after->
 ExprReturns m after(Eassign(Eloc res Ptrofs.zero Full tfloat)(ResidualExpr input output)tfloat)(Vsingle MinusOne).
Proof. intros m after input output res LI LO ST fn k e.
 eapply plus_star;eapply Cstrategy.estep_simulation.
 change(Cstrategy.estep Execution.ge(ExprState fn((fun x=>x)(Eassign(Eloc res Ptrofs.zero Full tfloat)(ResidualExpr input output)tfloat))k e m)E0(ExprState fn((fun x=>x)(Eval(Vsingle MinusOne)tfloat))k e after)).
 eapply Cstrategy.step_assign with(v:=Vsingle MinusOne)(v1:=Vsingle MinusOne).
 - constructor.
 - constructor.
 - exact(proj1(pure_eval_big(ResidualExpr input output)Execution.ge e m eq_refl)(Vsingle MinusOne)(residual_value e m input output LI LO)).
 - reflexivity.
 - eapply assign_loc_value with(chunk:=Mfloat32);try reflexivity;change(Mem.store Mfloat32 m res(Ptrofs.unsigned Ptrofs.zero)(Vsingle MinusOne)=Some after);rewrite Ptrofs.unsigned_zero;exact ST.
 - reflexivity.
Qed.
Theorem residual_assertion_false:forall m res,Mem.load Mfloat32 m res 0=Some(Vsingle MinusOne)->ExprReturns m m(ResidualAssertion res)(Vint Int.zero).
Proof. intros m res LD fn k e;unfold ResidualAssertion.
 eapply star_trans with(s2:=ExprState fn(Eparen(Eseqand(Lower res)(Upper res)tint)type_bool tint)k e m)(t1:=E0)(t2:=E0).
 - eapply plus_star;eapply Cstrategy.estep_simulation.
   change(Cstrategy.estep Execution.ge(ExprState fn((fun x=>x)(Eseqor SuccessTest(Eseqand(Lower res)(Upper res)tint)tint))k e m)E0(ExprState fn((fun x=>x)(Eparen(Eseqand(Lower res)(Upper res)tint)type_bool tint))k e m)).
   eapply Cstrategy.step_seqor_false with(v:=Vint Int.zero).
   + constructor.
   + exact(proj1(pure_eval_big SuccessTest Execution.ge e m eq_refl)(Vint Int.zero)(success_test_value e m)).
   + reflexivity.
 - eapply star_trans with(s2:=ExprState fn(Eparen(Eval(Vint Int.zero)tint)type_bool tint)k e m)(t1:=E0)(t2:=E0).
   + eapply plus_star;eapply Cstrategy.estep_simulation.
     change(Cstrategy.estep Execution.ge(ExprState fn((fun x=>Eparen x type_bool tint)(Eseqand(Lower res)(Upper res)tint))k e m)E0(ExprState fn((fun x=>Eparen x type_bool tint)(Eval(Vint Int.zero)tint))k e m)).
     eapply Cstrategy.step_seqand_false with(v:=Vint Int.zero).
     * constructor;constructor.
     * exact(proj1(pure_eval_big(Lower res)Execution.ge e m eq_refl)(Vint Int.zero)(lower_value e m res LD)).
     * reflexivity.
   + eapply plus_star;eapply Cstrategy.estep_simulation.
     change(Cstrategy.estep Execution.ge(ExprState fn((fun x=>x)(Eparen(Eval(Vint Int.zero)tint)type_bool tint))k e m)E0(ExprState fn((fun x=>x)(Eval(Vint Int.zero)tint))k e m)).
     eapply Cstrategy.step_paren with(v1:=Vint Int.zero);constructor||reflexivity.
   + reflexivity.
 - reflexivity.
Qed.
Definition ResidualObservation(m mf:mem)(output input:block):Prop:=exists allocated res after,
 Mem.alloc mf 0 4=(allocated,res)/\Mem.store Mfloat32 allocated res 0(Vsingle MinusOne)=Some after/\
 ExprReturns allocated after(Eassign(Eloc res Ptrofs.zero Full tfloat)(ResidualExpr input output)tfloat)(Vsingle MinusOne)/\
 Mem.load Mfloat32 after res 0=Some(Vsingle MinusOne)/\ExprReturns after after(ResidualAssertion res)(Vint Int.zero).
Theorem large_post_observation:forall m mf output input,Post m mf output input Ptrofs.zero Ptrofs.zero large2->ResidualObservation m mf output input.
Proof. intros m mf output input POST;destruct(large_post_loads m mf output input POST)as[LI LO].
 destruct(Mem.alloc mf 0 4)as[allocated res]eqn:AL.
 assert(LIA:Mem.load Mfloat32 allocated input 0=Some(Vsingle(large2 0)))by(eapply Mem.load_alloc_other;eauto).
 assert(LOA:Mem.load Mfloat32 allocated output 0=Some(Vsingle(Output large2 0)))by(eapply Mem.load_alloc_other;eauto).
 assert(VA:Mem.valid_access allocated Mfloat32 res 0 Writable).
 { eapply Mem.valid_access_implies;[eapply Mem.valid_access_alloc_same;[exact AL|lia|reflexivity|change(4|0);exists 0;lia]|constructor]. }
 destruct(Mem.valid_access_store allocated Mfloat32 res 0(Vsingle MinusOne)VA)as[after ST].
 assert(LD:Mem.load Mfloat32 after res 0=Some(Vsingle MinusOne)).
 { erewrite Mem.load_store_same by exact ST;reflexivity. }
 exists allocated,res,after;split;[exact AL|];split;[exact ST|];split;[eapply residual_assignment;eauto|];split;[exact LD|apply residual_assertion_false;exact LD].
Qed.
Print Assumptions residual_assignment.
Print Assumptions residual_assertion_false.
Print Assumptions large_post_observation.
Definition CompletedPrefix(m:mem)(og ig ob ib os is0 ol il:block)(md:mem):Prop:=exists ma mb mc,
 NormalCall m og ig(Ptrofs.repr 4)Ptrofs.zero trace_input ma/\Post m ma og ig(Ptrofs.repr 4)Ptrofs.zero trace_input/\
 NormalCall ma ob ib Ptrofs.zero Ptrofs.zero base2 mb/\Post ma mb ob ib Ptrofs.zero Ptrofs.zero base2/\
 NormalCall mb os is0 Ptrofs.zero Ptrofs.zero small2 mc/\Post mb mc os is0 Ptrofs.zero Ptrofs.zero small2/\
 NormalCall mc ol il Ptrofs.zero Ptrofs.zero large2 md/\Post mc md ol il Ptrofs.zero Ptrofs.zero large2.
Lemma prefix_exists:forall m og ig ob ib os is0 ol il,InitializedLayout m og ig ob ib os is0 ol il->exists md,CompletedPrefix m og ig ob ib os is0 ol il md.
Proof. intros m og ig ob ib os is0 ol il[G[B[S[L[OB[OS[OL SEP]]]]]]].
 destruct G as[NE[W[RD OTHER]]];assert(IG:Inputs m og ig(Ptrofs.repr 4)Ptrofs.zero trace_input)by(split;[exact NE|];split;[exact W|exact RD]).
 destruct(original_trace_four_calls m og ig ob ib os is0 ol il IG B S L SEP)as[ma[mb[mc[md CALLS]]]].
 exists md,ma,mb,mc;exact CALLS.
Qed.
Lemma prefix_large_loads:forall m og ig ob ib os is0 ol il md,CompletedPrefix m og ig ob ib os is0 ol il md->
 Mem.load Mfloat32 md il 0=Some(Vsingle(large2 0))/\Mem.load Mfloat32 md ol 0=Some(Vsingle(Output large2 0)).
Proof. intros m og ig ob ib os is0 ol il md[ma[mb[mc[PG[QG[PB[QB[PS[QS[PL QL]]]]]]]]]];eapply large_post_loads;exact QL. Qed.
Lemma post_access_preserved:forall m mf bo bi po pi f ch b z p,Post m mf bo bi po pi f->Mem.valid_access m ch b z p->Mem.valid_access mf ch b z p.
Proof. intros m mf bo bi po pi f ch b z p[W[RD[FR[VB[BY AC]]]]]VA;apply AC;[eapply Mem.valid_access_valid_block;eapply Mem.valid_access_implies;[exact VA|destruct p;constructor]|exact VA]. Qed.
Lemma prefix_access_preserved:forall m og ig ob ib os is0 ol il md ch b z p,
 CompletedPrefix m og ig ob ib os is0 ol il md->Mem.valid_access m ch b z p->Mem.valid_access md ch b z p.
Proof. intros m og ig ob ib os is0 ol il md ch b z p[ma[mb[mc[PG[QG[PB[QB[PS[QS[PL QL]]]]]]]]]]VA.
 eapply post_access_preserved;[exact QL|];eapply post_access_preserved;[exact QS|];eapply post_access_preserved;[exact QB|];eapply post_access_preserved;[exact QG|exact VA]. Qed.
Lemma layout_alloc:forall m og ig ob ib os is0 ol il allocated res,
 InitializedLayout m og ig ob ib os is0 ol il->Mem.alloc m 0 4=(allocated,res)->InitializedLayout allocated og ig ob ib os is0 ol il.
Proof. intros m og ig ob ib os is0 ol il allocated res[G[B[S[L[OB[OS[OL SEP]]]]]]]AL.
 assert(LP:LoadPreserved m allocated)by(intros ch b z VB;apply Mem.load_alloc_unchanged with(lo:=0)(hi:=4)(b:=res);assumption).
 assert(AP:AccessPreserved m allocated)by(intros ch b z p VA;eapply Mem.valid_access_alloc_other;eauto).
 unfold InitializedLayout;split;[eapply extension_guarded;eauto|];split;[eapply extension_inputs;eauto|];split;[eapply extension_inputs;eauto|];split;[eapply extension_inputs;eauto|];split;[eapply extension_reads;eauto;lia|];split;[eapply extension_reads;eauto;lia|];split;[eapply extension_reads;eauto;lia|exact SEP].
Qed.
Definition ComposedRefutation9:Prop:=exists m og ig ob ib os is0 ol il md,
 InitializedLayout m og ig ob ib os is0 ol il/\CompletedPrefix m og ig ob ib os is0 ol il md/\ExprReturns md md ScaleAssertion(Vint Int.zero).
Theorem composed_refutation9:ComposedRefutation9.
Proof. destruct initialized_layout_inhabited as[m[og[ig[ob[ib[os[is0[ol[il L]]]]]]]]].
 destruct(prefix_exists m og ig ob ib os is0 ol il L)as[md P].
 exists m,og,ig,ob,ib,os,is0,ol,il,md;split;[exact L|];split;[exact P|apply scale_assertion_false]. Qed.
Definition ComposedRefutation10:Prop:=exists m0 m og ig ob ib os is0 ol il res md obs,
 Mem.alloc m0 0 4=(m,res)/\InitializedLayout m og ig ob ib os is0 ol il/\CompletedPrefix m og ig ob ib os is0 ol il md/\
 Mem.load Mfloat32 md il 0=Some(Vsingle(large2 0))/\Mem.load Mfloat32 md ol 0=Some(Vsingle(Output large2 0))/\
 Mem.store Mfloat32 md res 0(Vsingle MinusOne)=Some obs/\Float32.to_bits MinusOne=Int.repr 3212836864/\
 ExprReturns md obs(Eassign(Eloc res Ptrofs.zero Full tfloat)(ResidualExpr il ol)tfloat)(Vsingle MinusOne)/\
 ExprReturns obs obs(ResidualAssertion res)(Vint Int.zero).
Theorem composed_refutation10:ComposedRefutation10.
Proof. destruct initialized_layout_inhabited as[m0[og[ig[ob[ib[os[is0[ol[il L0]]]]]]]]].
 destruct(Mem.alloc m0 0 4)as[m res]eqn:AL.
 assert(L:InitializedLayout m og ig ob ib os is0 ol il)by(eapply layout_alloc;eauto).
 destruct(prefix_exists m og ig ob ib os is0 ol il L)as[md P];destruct(prefix_large_loads m og ig ob ib os is0 ol il md P)as[LI LO].
 assert(VA:Mem.valid_access md Mfloat32 res 0 Writable).
 { eapply prefix_access_preserved;[exact P|];eapply Mem.valid_access_implies;[eapply Mem.valid_access_alloc_same;[exact AL|lia|reflexivity|exists 0;lia]|constructor]. }
 destruct(Mem.valid_access_store md Mfloat32 res 0(Vsingle MinusOne)VA)as[obs ST].
 exists m0,m,og,ig,ob,ib,os,is0,ol,il,res,md,obs;split;[exact AL|];split;[exact L|];split;[exact P|];split;[exact LI|];split;[exact LO|];split;[exact ST|];split;[apply Float32.to_of_bits|];split.
 - eapply residual_assignment;eauto.
 - apply residual_assertion_false;erewrite Mem.load_store_same by exact ST;reflexivity.
Qed.
Print Assumptions composed_refutation9.
Print Assumptions composed_refutation10.
