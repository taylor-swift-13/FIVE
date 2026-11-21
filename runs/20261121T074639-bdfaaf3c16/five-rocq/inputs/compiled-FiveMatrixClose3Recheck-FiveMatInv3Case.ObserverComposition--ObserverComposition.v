From Stdlib Require Import Bool List ZArith Lia.
From compcert Require Import Coqlib Maps Integers Floats AST Values Memory Memdata Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cstrategy Smallstep.
From FivePprzFloatMatInv3d Require Import Source Execution.
From FiveMatInv3Case Require Import Contract Scalar Observer Memcpy36 RecheckSupport Assertions TraceInputs SequentialReplay PairExtend GuardWitness.
From FiveMatrixInverseSupport Require Import Kernels.
Require FiveMatInv3Functional.Spec FiveMatInv3Functional.Proof.
Import ListNotations.
Local Open Scope Z_scope.
Definition ObserverFunction:=Source.f_float_mat_inv_3d.
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
Lemma cell_word_value:forall m b i v,0<=i<9->Mem.load Mint32 m b(4*i)=Some(Vint v)->
 eval_simple_rvalue Execution.ge empty_env m(Cell b i tuint)(Vint v).
Proof.
 intros m b i v I L;unfold Cell;eapply esr_rvalof with(b:=b)(ofs:=Ptrofs.repr(4*i))(bf:=Full).
 - apply esl_deref;eapply esr_binop;[constructor|constructor|].
   assert(i=0\/i=1\/i=2\/i=3\/i=4\/i=5\/i=6\/i=7\/i=8)by lia;
   repeat destruct H as[H|H];subst i;reflexivity.
 - reflexivity.
 - reflexivity.
 - eapply deref_loc_value;[reflexivity|reflexivity|].
   unfold Mem.loadv;rewrite Ptrofs.unsigned_repr by(change Ptrofs.max_unsigned with 18446744073709551615;lia).
   rewrite zle_true;[exact L|change(size_chunk Mint32)with 4;change Ptrofs.modulus with 18446744073709551616;lia].
Qed.
Lemma cell_single_value:forall m b i v,0<=i<9->Mem.load Mfloat32 m b(4*i)=Some(Vsingle v)->
 eval_simple_rvalue Execution.ge empty_env m(Cell b i tfloat)(Vsingle v).
Proof.
 intros m b i v I L;unfold Cell;eapply esr_rvalof with(b:=b)(ofs:=Ptrofs.repr(4*i))(bf:=Full).
 - apply esl_deref;eapply esr_binop;[constructor|constructor|].
   assert(i=0\/i=1\/i=2\/i=3\/i=4\/i=5\/i=6\/i=7\/i=8)by lia;
   repeat destruct H as[H|H];subst i;reflexivity.
 - reflexivity.
 - reflexivity.
 - eapply deref_loc_value;[reflexivity|reflexivity|].
   unfold Mem.loadv;rewrite Ptrofs.unsigned_repr by(change Ptrofs.max_unsigned with 18446744073709551615;lia).
   rewrite zle_true;[exact L|change(size_chunk Mfloat32)with 4;change Ptrofs.modulus with 18446744073709551616;lia].
Qed.
Definition WordEq(b:block)(i w:Z):expr:=Ebinop Oeq(Cell b i tuint)(Eval(Vint(Int.repr w))tuint)tint.
Lemma word_eq_true:forall m b i w,0<=i<9->Mem.load Mint32 m b(4*i)=Some(Vint(Int.repr w))->
 Reduces m(WordEq b i w)(Eval(Vint Int.one)tint).
Proof. intros m b i w I L;apply reduces_simple;unfold WordEq;eapply esr_binop with(v1:=Vint(Int.repr w))(v2:=Vint(Int.repr w));[apply cell_word_value;[exact I|exact L]|constructor|].
 change(Some(Val.of_bool(Int.eq(Int.repr w)(Int.repr w)))=Some(Vint Int.one));rewrite Int.eq_true;reflexivity. Qed.
Definition WordAssertion(b:block)(ws:list Z):expr:=
 fold_left(fun a i=>Eseqand a(WordEq b i(nth(Z.to_nat i)ws 0))tint)
 [1;2;3;4;5;6;7;8](WordEq b 0(nth 0 ws 0)).
Lemma word_assertion_true:forall m b ws,
 (forall i,0<=i<9->Mem.load Mint32 m b(4*i)=Some(Vint(Int.repr(nth(Z.to_nat i)ws 0))))->
 Reduces m(WordAssertion b ws)(Eval(Vint Int.one)tint).
Proof.
 intros m b ws LOAD;unfold WordAssertion;cbn[fold_left].
 repeat first[eapply reduces_and_true;[reflexivity|reflexivity| |]|apply word_eq_true;[lia|apply LOAD;lia]].
Qed.
Definition CopiedObservation(m:mem)(src dst:block)(f:Z->float32)(ws:list Z):Prop:=
 exists obs bytes, Mem.loadbytes m src 0 36=Some bytes /\Mem.storebytes m dst 0 bytes=Some obs /\
 extcall_memcpy_sem 36 1(Genv.to_senv(Csem.genv_genv Execution.ge))[Vptr dst Ptrofs.zero;Vptr src Ptrofs.zero]m E0 Vundef obs /\
 Mem.loadbytes obs dst 0 36=Some bytes /\CopyFrame m obs dst /\
 (forall i,0<=i<9->Mem.load Mint32 obs dst(4*i)=Some(Vint(Float32.to_bits(Output f i)))) /\
 Reduces obs(WordAssertion dst ws)(Eval(Vint Int.one)tint).
Lemma copied_observation:forall m src dst f ws,CopyPre m src dst->
 (forall i,0<=i<9->Mem.loadbytes m src(4*i)4=Some(encode_val Mfloat32(Vsingle(Output f i))))->
 words3 f=map Int.repr ws->length ws=9%nat->CopiedObservation m src dst f ws.
Proof.
 intros m src dst f ws PRE CELLS WORD LEN.
 destruct(copy36_exact(Genv.to_senv(Csem.genv_genv Execution.ge))m src dst PRE)as[obs[bytes[SAFE[READ[BLEN[STORE[CALL[BYTES FRAME]]]]]]]].
 assert(LOAD:forall i,0<=i<9->Mem.load Mint32 obs dst(4*i)=Some(Vint(Float32.to_bits(Output f i)))).
 { intros i I;exact(FiveMatInv3Case.Observer.memcpy_word_observation m src dst obs bytes (Output f) READ STORE CELLS i I). }
 assert(W:forall i,0<=i<9->Float32.to_bits(Output f i)=Int.repr(nth(Z.to_nat i)ws 0)).
 { intros i I;unfold words3 in WORD.
   pose proof(f_equal(fun l=>nth(Z.to_nat i)l(Int.repr 0))WORD)as E.
   cbn beta in E;rewrite map_nth in E.
   assert(IX:i=0\/i=1\/i=2\/i=3\/i=4\/i=5\/i=6\/i=7\/i=8)by lia.
   repeat destruct IX as[IX|IX];subst i;cbn[map nth]in E;exact E. }
 exists obs,bytes;repeat split;try assumption.
 apply word_assertion_true;intros i I;rewrite <-W by exact I;apply LOAD;exact I.
Qed.
Definition FixedObserver(f:Z->float32)(ws:list Z):Prop:=forall m bo bi pi,
 bo<>bi->WriteRegion m bo Ptrofs.zero 9->Reads m bi pi 9 f->forall t v mf,
 star Csem.step Execution.ge(Execution.entry(Args bo bi Ptrofs.zero pi)m)t(Returnstate v Kstop mf)->
 forall dst,CopyPre mf bo dst->CopiedObservation mf bo dst f ws.
Theorem fixed_observer:forall f ws,Accept f=true->words3 f=map Int.repr ws->length ws=9%nat->FixedObserver f ws.
Proof.
 intros f ws ACCEPT WORD LEN m bo bi pi NE W RD t v mf PATH dst PRE.
 destruct(FiveMatInv3Functional.Proof.all_normal_observations m bo bi Ptrofs.zero pi f NE W RD t v mf PATH)as[V[BYTES REST]].
 apply copied_observation;try assumption.
 intros i I;unfold OutputBytes in BYTES;rewrite ACCEPT in BYTES;pose proof(BYTES i I)as B;rewrite Ptrofs.unsigned_zero,Z.add_0_l in B;exact B.
Qed.
Definition ComposedAssert4:=FixedObserver base3 BaseWords.
Theorem composed_assertion4:ComposedAssert4.
Proof. apply fixed_observer;[vm_compute;reflexivity|exact(proj2(proj2 base3_kernel))|reflexivity]. Qed.
Definition ComposedAssert8:=FixedObserver large3 LargeWords.
Theorem composed_assertion8:ComposedAssert8.
Proof. apply fixed_observer;[vm_compute;reflexivity|exact(proj2(proj2 large3_kernel))|reflexivity]. Qed.
Print Assumptions composed_assertion4.
Print Assumptions composed_assertion8.








(** Exact failing assertions: bool statuses undergo the original C integer
    promotions; all real literals retain binary32 type. *)
Definition ScaleAssertion:expr:=Ebinop Oeq
 (Ecast(Eval(Status base3)type_bool)tint)(Ecast(Eval(Status small3)type_bool)tint)tint.
Lemma scale_assertion_false:forall m,Reduces m ScaleAssertion(Eval(Vint Int.zero)tint).
Proof.
 intro m;apply reduces_simple;unfold ScaleAssertion;rewrite(proj1 base3_kernel),(proj1 small3_kernel).
 eapply esr_binop;[eapply esr_cast;[constructor|reflexivity]|eapply esr_cast;[constructor|reflexivity]|reflexivity].
Qed.
Definition ResidualExpression(input output:block):expr:=Ebinop Osub
 (Ebinop Omul(Cell input 0 tfloat)(Cell output 0 tfloat)tfloat)(Eval(Vsingle one)tfloat)tfloat.
Definition ResidualRead(b:block):expr:=Evalof(Eloc b Ptrofs.zero Full tfloat)tfloat.
Definition ResidualAssignment(input output residual:block):expr:=
 Eassign(Eloc residual Ptrofs.zero Full tfloat)(ResidualExpression input output)tfloat.
Definition ResidualAssertion(residual:block):expr:=Eseqor
 (Ebinop One(Ecast(Eval(Status large3)type_bool)tint)(Eval(Vint Int.zero)tint)tint)
 (Eseqand(Ebinop Ogt(ResidualRead residual)(Eunop Oneg(Eval(Vsingle(Float32.of_bits(Int.repr 1056964608)))tfloat)tfloat)tint)
 (Ebinop Olt(ResidualRead residual)(Eval(Vsingle(Float32.of_bits(Int.repr 1056964608)))tfloat)tint)tint)tint.
Lemma residual_expression_value:forall m input output,
 Mem.load Mfloat32 m input 0=Some(Vsingle(large3 0))->
 Mem.load Mfloat32 m output 0=Some(Vsingle(Output large3 0))->
 eval_simple_rvalue Execution.ge empty_env m(ResidualExpression input output)(Vsingle(residual3 large3)).
Proof.
 intros m input output IN OUT;unfold ResidualExpression,residual3.
 eapply esr_binop with(v1:=Vsingle(Float32.mul(large3 0)(Output large3 0)))(v2:=Vsingle one).
 - eapply esr_binop;[apply cell_single_value;[lia|exact IN]|apply cell_single_value;[lia|exact OUT]|reflexivity].
 - constructor.
 - reflexivity.
Qed.
Lemma residual_read_value:forall m b,Mem.load Mfloat32 m b 0=Some(Vsingle(residual3 large3))->
 eval_simple_rvalue Execution.ge empty_env m(ResidualRead b)(Vsingle(residual3 large3)).
Proof. intros m b L;unfold ResidualRead;eapply esr_rvalof;[constructor|reflexivity|reflexivity|].
 eapply deref_loc_value;[reflexivity|reflexivity|];unfold Mem.loadv;rewrite Ptrofs.unsigned_zero,zle_true;[exact L|change(4<=18446744073709551616);lia]. Qed.
Lemma residual_assertion_false:forall m b,Mem.load Mfloat32 m b 0=Some(Vsingle(residual3 large3))->
 Reduces m(ResidualAssertion b)(Eval(Vint Int.zero)tint).
Proof.
 intros m b L;unfold ResidualAssertion;apply reduces_or_false.
 - apply reduces_simple;rewrite(proj1 large3_kernel);eapply esr_binop;[eapply esr_cast;[constructor|reflexivity]|constructor|reflexivity].
 - apply reduces_and_false;apply reduces_simple.
   eapply esr_binop with(v1:=Vsingle(residual3 large3))(v2:=Vsingle(Float32.neg(Float32.of_bits(Int.repr 1056964608)))).
   + apply residual_read_value;exact L.
   + eapply esr_unop;[constructor|reflexivity].
   + vm_compute;reflexivity.
Qed.
Lemma residual_assignment_steps:forall m input output b obs,
 Mem.load Mfloat32 m input 0=Some(Vsingle(large3 0))->
 Mem.load Mfloat32 m output 0=Some(Vsingle(Output large3 0))->
 Mem.store Mfloat32 m b 0(Vsingle(residual3 large3))=Some obs->
 star Csem.step Execution.ge(ExprState ObserverFunction(ResidualAssignment input output b)Kstop empty_env m)E0
 (ExprState ObserverFunction(Eval(Vsingle(residual3 large3))tfloat)Kstop empty_env obs).
Proof.
 intros m input output b obs IN OUT STORE;unfold ResidualAssignment.
 eapply star_trans with(s2:=ExprState ObserverFunction(Eassign(Eloc b Ptrofs.zero Full tfloat)(Eval(Vsingle(residual3 large3))tfloat)tfloat)Kstop empty_env m).
 - exact(reduces_simple m(ResidualExpression input output)(Vsingle(residual3 large3))
   (residual_expression_value m input output IN OUT)(fun x=>Eassign(Eloc b Ptrofs.zero Full tfloat)x tfloat)(ctx_assign_right _ _ _ _ (ctx_top RV))).
 - apply star_one;left;eapply step_rred with(C:=fun x=>x);[|constructor].
   eapply red_assign;[reflexivity|].
   eapply assign_loc_value;[reflexivity|reflexivity|].
   unfold Mem.storev;rewrite Ptrofs.unsigned_zero;rewrite zle_true;[exact STORE|change(4<=18446744073709551616);lia].
 - reflexivity.
Qed.
Definition CompletedPrefix(f:Z->float32)(m:mem)(og ig ob ib os is0 ol il:block)(ml:mem):Prop:=exists ma mb ms,
 NormalCall m og ig(Ptrofs.repr 4)f ma /\FiveMatInv3Functional.Spec.Post m ma og ig(Ptrofs.repr 4)Ptrofs.zero f /\
 NormalCall ma ob ib Ptrofs.zero base3 mb /\FiveMatInv3Functional.Spec.Post ma mb ob ib Ptrofs.zero Ptrofs.zero base3 /\
 NormalCall mb os is0 Ptrofs.zero small3 ms /\FiveMatInv3Functional.Spec.Post mb ms os is0 Ptrofs.zero Ptrofs.zero small3 /\
 NormalCall ms ol il Ptrofs.zero large3 ml /\FiveMatInv3Functional.Spec.Post ms ml ol il Ptrofs.zero Ptrofs.zero large3.
Lemma prefix_exists:forall f m og ig ob ib os is0 ol il,Layout f m og ig ob ib os is0 ol il->
 exists ml,CompletedPrefix f m og ig ob ib os is0 ol il ml.
Proof. intros f m og ig ob ib os is0 ol il L;destruct(original_sequential_calls f m og ig ob ib os is0 ol il L)as[ma[mb[ms[ml C]]]];exists ml,ma,mb,ms;exact C. Qed.
Lemma load_single_bytes:forall m b z v,Mem.loadbytes m b z 4=Some(encode_val Mfloat32(Vsingle v))->(4|z)->
 Mem.load Mfloat32 m b z=Some(Vsingle v).
Proof.
 intros m b z v B AL;pose proof(Mem.loadbytes_load Mfloat32 m b z _ B AL)as L.
 pose proof(decode_encode_val_similar(Vsingle v)Mfloat32 Mfloat32 _ eq_refl eq_refl(decode_encode_val_general(Vsingle v)Mfloat32 Mfloat32))as DE.
 change(decode_val Mfloat32(encode_val Mfloat32(Vsingle v))=Vsingle v)in DE;rewrite DE in L;exact L.
Qed.
Lemma prefix_large_loads:forall f m og ig ob ib os is0 ol il ml,
 Layout f m og ig ob ib os is0 ol il->CompletedPrefix f m og ig ob ib os is0 ol il ml->
 Mem.load Mfloat32 ml il 0=Some(Vsingle(large3 0))/\Mem.load Mfloat32 ml ol 0=Some(Vsingle(Output large3 0)).
Proof.
 intros f m og ig ob ib os is0 ol il ml[G[B[S[L SEP]]]][ma[mb[ms[PG[QG[PB[QB[PS[QS[PL QL]]]]]]]]]];destruct SEP.
 assert(LA:Ready ma ol il Ptrofs.zero large3 SequentialReplay.OldFixed)by(eapply post_preserves_ready;eauto).
 assert(LB:Ready mb ol il Ptrofs.zero large3 SequentialReplay.OldFixed)by(eapply post_preserves_ready;eauto).
 assert(LS:Ready ms ol il Ptrofs.zero large3 SequentialReplay.OldFixed)by(eapply post_preserves_ready;eauto).
 destruct LS as[NE[W[RD RO]]].
 destruct QL as[BY[FR[WF[VB[AC INPUT]]]]].
 split.
 - pose proof(proj2(proj2 RD)0 ltac:(lia))as IN;rewrite Ptrofs.unsigned_zero in IN;change(Mem.load Mfloat32 ms il 0=Some(Vsingle(large3 0)))in IN.
   eapply frame_load_kept;[exact FR|exact(reads_valid ms il Ptrofs.zero 9 large3 ltac:(lia)RD)|left;congruence|exact IN].
 - unfold OutputBytes in BY;assert(A:Accept large3=true)by(vm_compute;reflexivity);rewrite A in BY.
   pose proof(BY 0 ltac:(lia))as CELL;rewrite Ptrofs.unsigned_zero in CELL;change(Mem.loadbytes ml ol 0 4=Some(encode_val Mfloat32(Vsingle(Output large3 0))))in CELL.
   apply load_single_bytes;[exact CELL|exists 0;lia].
Qed.
Lemma post_access_preserved:forall m mf bo bi po pi f ch b z p,
 FiveMatInv3Functional.Spec.Post m mf bo bi po pi f->Mem.valid_access m ch b z p->Mem.valid_access mf ch b z p.
Proof. intros m mf bo bi po pi f ch b z p[BY[FR[WF[VB[AC INPUT]]]]]VA;apply AC;[eapply Mem.valid_access_valid_block;eapply Mem.valid_access_implies;[exact VA|destruct p;constructor]|exact VA]. Qed.
Lemma prefix_access_preserved:forall f m og ig ob ib os is0 ol il ml ch b z p,
 CompletedPrefix f m og ig ob ib os is0 ol il ml->Mem.valid_access m ch b z p->Mem.valid_access ml ch b z p.
Proof.
 intros f m og ig ob ib os is0 ol il ml ch b z p[ma[mb[ms[PG[QG[PB[QB[PS[QS[PL QL]]]]]]]]]]VA.
 eapply post_access_preserved;[exact QL|];eapply post_access_preserved;[exact QS|];eapply post_access_preserved;[exact QB|];eapply post_access_preserved;[exact QG|exact VA].
Qed.
Lemma layout_alloc:forall f m og ig ob ib os is0 ol il ma b,
 Layout f m og ig ob ib os is0 ol il->Mem.alloc m 0 4=(ma,b)->Layout f ma og ig ob ib os is0 ol il.
Proof.
 intros f m og ig ob ib os is0 ol il ma b[G[B[S[L SEP]]]]A.
 assert(LP:LoadPreserved m ma)by(intros ch bx z VB;apply Mem.load_alloc_unchanged with(lo:=0)(hi:=4)(b:=b);assumption).
 assert(AP:AccessPreserved m ma)by(intros ch bx z p VA;eapply Mem.valid_access_alloc_other;eauto).
 split;[eapply guarded_preserved;eauto|];split;[eapply ready_preserved;eauto|];split;[eapply ready_preserved;eauto|];split;[eapply ready_preserved;eauto|exact SEP].
Qed.
Definition ScaleReplay(f:Z->float32):Prop:=exists m og ig ob ib os is0 ol il ml,
 Layout f m og ig ob ib os is0 ol il /\CompletedPrefix f m og ig ob ib os is0 ol il ml /\
 Reduces ml ScaleAssertion(Eval(Vint Int.zero)tint).
Theorem scale_replay:forall f:Z->float32,ScaleReplay f.
Proof.
 intro f;destruct(layout_inhabited f)as[m[og[ig[ob[ib[os[is0[ol[il L]]]]]]]]].
 destruct(prefix_exists f m og ig ob ib os is0 ol il L)as[ml P].
 exists m,og,ig,ob,ib,os,is0,ol,il,ml;split;[exact L|];split;[exact P|apply scale_assertion_false].
Qed.
Definition ResidualReplay(f:Z->float32):Prop:=exists m0 m og ig ob ib os is0 ol il br ml obs,
 Mem.alloc m0 0 4=(m,br) /\Layout f m og ig ob ib os is0 ol il /\CompletedPrefix f m og ig ob ib os is0 ol il ml /\
 Mem.load Mfloat32 ml il 0=Some(Vsingle(large3 0)) /\Mem.load Mfloat32 ml ol 0=Some(Vsingle(Output large3 0)) /\
 Mem.store Mfloat32 ml br 0(Vsingle(residual3 large3))=Some obs /\
 Float32.to_bits(residual3 large3)=Int.repr 3212836864 /\
 star Csem.step Execution.ge(ExprState ObserverFunction(ResidualAssignment il ol br)Kstop empty_env ml)E0
 (ExprState ObserverFunction(Eval(Vsingle(residual3 large3))tfloat)Kstop empty_env obs) /\
 Reduces obs(ResidualAssertion br)(Eval(Vint Int.zero)tint).
Theorem residual_replay:forall f:Z->float32,ResidualReplay f.
Proof.
 intro f;destruct(layout_inhabited f)as[m0[og[ig[ob[ib[os[is0[ol[il L0]]]]]]]]].
 destruct(Mem.alloc m0 0 4)as[m br]eqn:A.
 assert(L:Layout f m og ig ob ib os is0 ol il)by(eapply layout_alloc;eauto).
 destruct(prefix_exists f m og ig ob ib os is0 ol il L)as[ml P].
 destruct(prefix_large_loads f m og ig ob ib os is0 ol il ml L P)as[IN OUT].
 assert(W:Mem.valid_access ml Mfloat32 br 0 Writable).
 { eapply prefix_access_preserved;[exact P|];eapply Mem.valid_access_freeable_any;eapply Mem.valid_access_alloc_same;[exact A|lia|change(0+4<=4);lia|exists 0;lia]. }
 destruct(Mem.valid_access_store ml Mfloat32 br 0(Vsingle(residual3 large3))W)as[obs STORE].
 exists m0,m,og,ig,ob,ib,os,is0,ol,il,br,ml,obs;split;[exact A|];split;[exact L|];split;[exact P|];split;[exact IN|];split;[exact OUT|];split;[exact STORE|];split;[exact large3_residual|];split.
 - apply residual_assignment_steps;assumption.
 - apply residual_assertion_false;erewrite Mem.load_store_same by exact STORE;reflexivity.
Qed.
Definition ComposedRefutation9:Prop:=ScaleReplay arbitrary_0 /\ScaleReplay arbitrary_1.
Theorem composed_refutation9:ComposedRefutation9.
Proof. split;apply scale_replay. Qed.
Definition ComposedRefutation10:Prop:=ResidualReplay arbitrary_0 /\ResidualReplay arbitrary_1.
Theorem composed_refutation10:ComposedRefutation10.
Proof. split;apply residual_replay. Qed.
Print Assumptions composed_refutation9.
Print Assumptions composed_refutation10.



