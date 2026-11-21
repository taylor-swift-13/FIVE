From Stdlib Require Import Bool List ZArith Lia.
From compcert Require Import Coqlib Maps Integers Floats AST Values Memory Memdata Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cstrategy Smallstep.
From FivePprzFloatMatInv2d Require Import Source Execution.
From FiveMatInv3Case Require Import MatrixMemory.
From FiveInv2Case Require Import Contract Call Observer Memcpy16 RecheckSupport.
From FiveMatrixInverseSupport Require Import Kernels.
Import ListNotations.
Local Open Scope Z_scope.
Definition ObserverFunction:=Source.f_float_mat_inv_2d.
(** These object-bound expressions are the original harness expressions after
    resolving caller-local base addresses. Indexing and every actual load,
    arithmetic operation, comparison and short-circuit remain Csyntax/Csem. *)
Definition Cell(b:block)(i:Z)(ty:type):expr:=Evalof(Ederef(Ebinop Oadd
 (Eval(Vptr b Ptrofs.zero)(tptr ty))(Eval(Vlong(Int64.repr i))tlong)(tptr ty))ty)ty.
Definition Reduces(m:mem)(a b:expr):Prop:=forall C,Csem.context RV RV C->
 star Csem.step Execution.ge(ExprState ObserverFunction(C a)Kstop empty_env m)E0
 (ExprState ObserverFunction(C b)Kstop empty_env m).
Lemma reduces_refl:forall m a,Reduces m a a.
Proof. intros m a C HC;constructor. Qed.
Lemma reduces_trans:forall m a b c,Reduces m a b->Reduces m b c->Reduces m a c.
Proof. intros m a b c A B C HC;eapply star_trans;[apply A;exact HC|apply B;exact HC|reflexivity]. Qed.
Lemma reduces_head:forall m a b,Csem.rred Execution.ge a m E0 b m->Reduces m a b.
Proof. intros m a b H C HC;apply star_one;left;eapply step_rred;[exact H|exact HC]. Qed.
Lemma reduces_lift:forall m a b D,Csem.context RV RV D->Reduces m a b->Reduces m(D a)(D b).
Proof. intros m a b D HD H C HC;apply(H(fun x=>C(D x)));eapply Cstrategy.context_compose;eauto. Qed.
Lemma reduces_simple:forall m a v,eval_simple_rvalue Execution.ge empty_env m a v->Reduces m a(Eval v(typeof a)).
Proof. intros m a v E C HC;eapply eval_simple_rvalue_steps;[exact E|exact HC]. Qed.
Lemma reduces_and_true:forall m a b,typeof a=tint->typeof b=tint->
 Reduces m a(Eval(Vint Int.one)tint)->Reduces m b(Eval(Vint Int.one)tint)->
 Reduces m(Eseqand a b tint)(Eval(Vint Int.one)tint).
Proof.
 intros m a b TA TB A B.
 eapply reduces_trans;[eapply reduces_lift with(D:=fun x=>Eseqand x b tint);[apply ctx_seqand;constructor|exact A]|].
 eapply reduces_trans;[apply reduces_head;apply red_seqand_true;reflexivity|].
 eapply reduces_trans;[eapply reduces_lift with(D:=fun x=>Eparen x type_bool tint);[apply ctx_paren;constructor|exact B]|].
 apply reduces_head;apply red_paren;reflexivity.
Qed.
Lemma reduces_and_false:forall m a b,Reduces m a(Eval(Vint Int.zero)tint)->
 Reduces m(Eseqand a b tint)(Eval(Vint Int.zero)tint).
Proof. intros m a b A;eapply reduces_trans;[eapply reduces_lift with(D:=fun x=>Eseqand x b tint);[apply ctx_seqand;constructor|exact A]|];apply reduces_head;apply red_seqand_false;reflexivity. Qed.
Lemma reduces_or_false:forall m a b,Reduces m a(Eval(Vint Int.zero)tint)->Reduces m b(Eval(Vint Int.zero)tint)->
 Reduces m(Eseqor a b tint)(Eval(Vint Int.zero)tint).
Proof.
 intros m a b A B;eapply reduces_trans;[eapply reduces_lift with(D:=fun x=>Eseqor x b tint);[apply ctx_seqor;constructor|exact A]|].
 eapply reduces_trans;[apply reduces_head;apply red_seqor_false;reflexivity|].
 eapply reduces_trans;[eapply reduces_lift with(D:=fun x=>Eparen x type_bool tint);[apply ctx_paren;constructor|exact B]|].
 apply reduces_head;apply red_paren;reflexivity.
Qed.
Lemma cell_word_value:forall m b i v,0<=i<4->Mem.load Mint32 m b(4*i)=Some(Vint v)->
 eval_simple_rvalue Execution.ge empty_env m(Cell b i tuint)(Vint v).
Proof.
 intros m b i v I L;unfold Cell;eapply esr_rvalof with(b:=b)(ofs:=Ptrofs.repr(4*i))(bf:=Full).
 - apply esl_deref;eapply esr_binop;[constructor|constructor|].
   assert(i=0\/i=1\/i=2\/i=3)by lia;
   repeat destruct H as[H|H];subst i;reflexivity.
 - reflexivity.
 - reflexivity.
 - eapply deref_loc_value;[reflexivity|reflexivity|].
   unfold Mem.loadv;rewrite Ptrofs.unsigned_repr by(change Ptrofs.max_unsigned with 18446744073709551615;lia).
   rewrite zle_true;[exact L|change(size_chunk Mint32)with 4;change Ptrofs.modulus with 18446744073709551616;lia].
Qed.
Lemma cell_single_value:forall m b i v,0<=i<4->Mem.load Mfloat32 m b(4*i)=Some(Vsingle v)->
 eval_simple_rvalue Execution.ge empty_env m(Cell b i tfloat)(Vsingle v).
Proof.
 intros m b i v I L;unfold Cell;eapply esr_rvalof with(b:=b)(ofs:=Ptrofs.repr(4*i))(bf:=Full).
 - apply esl_deref;eapply esr_binop;[constructor|constructor|].
   assert(i=0\/i=1\/i=2\/i=3)by lia;
   repeat destruct H as[H|H];subst i;reflexivity.
 - reflexivity.
 - reflexivity.
 - eapply deref_loc_value;[reflexivity|reflexivity|].
   unfold Mem.loadv;rewrite Ptrofs.unsigned_repr by(change Ptrofs.max_unsigned with 18446744073709551615;lia).
   rewrite zle_true;[exact L|change(size_chunk Mfloat32)with 4;change Ptrofs.modulus with 18446744073709551616;lia].
Qed.
Definition WordEq(b:block)(i w:Z):expr:=Ebinop Oeq(Cell b i tuint)(Eval(Vint(Int.repr w))tuint)tint.
Lemma word_eq_true:forall m b i w,0<=i<4->Mem.load Mint32 m b(4*i)=Some(Vint(Int.repr w))->
 Reduces m(WordEq b i w)(Eval(Vint Int.one)tint).
Proof. intros m b i w I L;apply reduces_simple;unfold WordEq;eapply esr_binop with(v1:=Vint(Int.repr w))(v2:=Vint(Int.repr w));[apply cell_word_value;[exact I|exact L]|constructor|].
 change(Some(Val.of_bool(Int.eq(Int.repr w)(Int.repr w)))=Some(Vint Int.one));rewrite Int.eq_true;reflexivity. Qed.
Definition WordAssertion(b:block)(ws:list Z):expr:=
 fold_left(fun a i=>Eseqand a(WordEq b i(nth(Z.to_nat i)ws 0))tint)
 [1;2;3](WordEq b 0(nth 0 ws 0)).
Lemma word_assertion_true:forall m b ws,
 (forall i,0<=i<4->Mem.load Mint32 m b(4*i)=Some(Vint(Int.repr(nth(Z.to_nat i)ws 0))))->
 Reduces m(WordAssertion b ws)(Eval(Vint Int.one)tint).
Proof.
 intros m b ws LOAD;unfold WordAssertion;cbn[fold_left].
 repeat first[eapply reduces_and_true;[reflexivity|reflexivity| |]|apply word_eq_true;[lia|apply LOAD;lia]].
Qed.
Definition CopiedObservation(m:mem)(src dst:block)(f:Z->float32)(ws:list Z):Prop:=
 exists obs bytes, Mem.loadbytes m src 0 16=Some bytes /\Mem.storebytes m dst 0 bytes=Some obs /\
 extcall_memcpy_sem 16 1(Genv.to_senv(Csem.genv_genv Execution.ge))[Vptr dst Ptrofs.zero;Vptr src Ptrofs.zero]m E0 Vundef obs /\
 Mem.loadbytes obs dst 0 16=Some bytes /\CopyFrame m obs dst /\
 (forall i,0<=i<4->Mem.load Mint32 obs dst(4*i)=Some(Vint(Float32.to_bits(Output f i)))) /\
 Reduces obs(WordAssertion dst ws)(Eval(Vint Int.one)tint).
Lemma copied_observation:forall m src dst f ws,CopyPre m src dst->
 (forall i,0<=i<4->Mem.loadbytes m src(4*i)4=Some(encode_val Mfloat32(Vsingle(Output f i))))->
 words2 f=map Int.repr ws->length ws=4%nat->CopiedObservation m src dst f ws.
Proof.
 intros m src dst f ws PRE CELLS WORD LEN.
 destruct(copy16_exact(Genv.to_senv(Csem.genv_genv Execution.ge))m src dst PRE)as[obs[bytes[SAFE[READ[BLEN[STORE[CALL[BYTES FRAME]]]]]]]].
 assert(LOAD:forall i,0<=i<4->Mem.load Mint32 obs dst(4*i)=Some(Vint(Float32.to_bits(Output f i)))).
 { intros i I;exact(FiveInv2Case.Observer.memcpy_word_observation m src dst obs bytes (Output f) READ STORE CELLS i I). }
 assert(W:forall i,0<=i<4->Float32.to_bits(Output f i)=Int.repr(nth(Z.to_nat i)ws 0)).
 { intros i I;unfold words2 in WORD.
   pose proof(f_equal(fun l=>nth(Z.to_nat i)l(Int.repr 0))WORD)as E.
   cbn beta in E;rewrite map_nth in E.
   assert(IX:i=0\/i=1\/i=2\/i=3)by lia.
   repeat destruct IX as[IX|IX];subst i;cbn[map nth]in E;exact E. }
 exists obs,bytes;repeat split;try assumption.
 apply word_assertion_true;intros i I;rewrite <-W by exact I;apply LOAD;exact I.
Qed.

Definition FixedObserver(f:Z->float32)(ws:list Z):Prop:=forall m bo bi pi,
 Inputs m bo bi Ptrofs.zero pi f->forall t v mf,
 star Csem.step Execution.ge(Execution.entry(Args bo bi Ptrofs.zero pi)m)t(Returnstate v Kstop mf)->
 forall dst,CopyPre mf bo dst->CopiedObservation mf bo dst f ws.
Lemma fixed_observer:forall f ws,Reject f=false->words2 f=map Int.repr ws->length ws=4%nat->FixedObserver f ws.
Proof. intros f ws ACCEPT WORD LEN m bo bi pi IN t v mf PATH dst PRE.
 destruct(call_summary m bo bi Ptrofs.zero pi f IN)as[expected[RETURN[POST[SAFE ALL]]]].
 destruct(ALL t v mf PATH)as[VALUE MEM];subst v mf.
 apply copied_observation;try assumption.
 intros i I;pose proof(successful_post_cells m expected bo bi Ptrofs.zero pi f POST ACCEPT i I)as BY;rewrite Ptrofs.unsigned_zero,Z.add_0_l in BY;exact BY.
Qed.
Definition ComposedAssert4:=FixedObserver base2[1065353216;2147483648;2147483648;1065353216].
Theorem composed_assertion4:ComposedAssert4.
Proof. apply fixed_observer;[vm_compute;reflexivity|exact(proj2(proj2 base2_kernel))|reflexivity]. Qed.
Definition ComposedAssert8:=FixedObserver large2[0;2147483648;2147483648;0].
Theorem composed_assertion8:ComposedAssert8.
Proof. apply fixed_observer;[vm_compute;reflexivity|exact(proj2(proj2 large2_kernel))|reflexivity]. Qed.
Print Assumptions composed_assertion4.
Print Assumptions composed_assertion8.
