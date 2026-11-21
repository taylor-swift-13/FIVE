From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Maps Integers AST Values Memory Events Globalenvs Errors Ctypes Ctypesdefs Csyntax Csem Ctyping Smallstep.
Require PprzTrigInit.Source PprzTrigInit.Execution.
From PprzTrigRelationSupport Require Import LowDispatcher.
From PprzTrigCBMC Require Import TypedGuards.
Local Open Scope Z_scope.
Local Opaque PprzTrigInit.Source.prog.

Lemma original_init_program_well_typed : Ctyping.wt_program PprzTrigInit.Source.prog.
Proof.
 apply(@Ctyping.typecheck_program_sound PprzTrigInit.Source.prog PprzTrigInit.Source.prog).
 Transparent PprzTrigInit.Source.prog.
 vm_compute;reflexivity.
Qed.
Local Opaque PprzTrigInit.Source.prog.

Theorem internal_entry_well_typed : forall p f address args m,
 Ctyping.wt_program p ->Genv.find_funct(Csem.globalenv p)address=Some(Internal f)->
 Ctyping.wt_state p(Callstate(Internal f)args Kstop m).
Proof.
 intros p f address args m PROGRAM FIND.
 eapply Ctyping.wt_call_state with(b:=address).
 - constructor.
 - exact(@Ctyping.wt_find_funct p PROGRAM address(Internal f)FIND).
 - exact FIND.
Qed.
Theorem typed_reachable : forall p initial,
 Ctyping.wt_program p ->Ctyping.wt_state p initial ->forall t s,
 star Csem.step(Csem.globalenv p)initial t s ->Ctyping.wt_state p s.
Proof.
 intros p initial PROGRAM START t s PATH;induction PATH;[exact START|].
 apply IHPATH;exact(@Ctyping.preservation p PROGRAM _ _ _ H START).
Qed.
Theorem original_initializer_reachable_typed : forall args m t s,
 star Csem.step PprzTrigInit.Execution.ge(PprzTrigInit.Execution.entry args m)t s ->
 Ctyping.wt_state PprzTrigInit.Source.prog s.
Proof.
 intros args m t s PATH;eapply typed_reachable;[exact original_init_program_well_typed| |exact PATH].
 destruct(@source_function_link PprzTrigInit.Source.prog PprzTrigInit.Source._pprz_trig_int_init
   PprzTrigInit.Source.f_pprz_trig_int_init ltac:(vm_compute;reflexivity))as[b[SYMBOL FUNCTION]].
 exact(@internal_entry_well_typed PprzTrigInit.Source.prog PprzTrigInit.Source.f_pprz_trig_int_init
   (Vptr b Ptrofs.zero)args m original_init_program_well_typed FUNCTION).
Qed.

Lemma typed_eval_short_range : forall x,Ctyping.wt_val(Vint x)tshort->signed16(Int.signed x).
Proof.
 intros x W;inversion W;subst.
 match goal with H:Ctyping.wt_int x I16 Signed|-_=>change(Int.sign_ext 16 x=x)in H;rewrite<-H end.
 pose proof(Int.sign_ext_range 16 x ltac:(change(0<16<32);lia))as B.
 change(-32768<=Int.signed(Int.sign_ext 16 x)<32768)in B;unfold signed16;lia.
Qed.
Lemma typed_eval_ushort_range : forall x,Ctyping.wt_val(Vint x)tushort->0<=Int.signed x<=65535.
Proof.
 intros x W;inversion W;subst.
 assert(U:0<=Int.unsigned x<65536).
 { match goal with H:Ctyping.wt_int x I16 Unsigned|-_=>change(Int.zero_ext 16 x=x)in H;rewrite<-H end.
   exact(Int.zero_ext_range 16 x ltac:(change(0<=16<32);lia)). }
 rewrite Int.signed_eq_unsigned by(change(Int.unsigned x<=2147483647);lia);lia.
Qed.
Lemma typed_eval_uchar_range : forall x,Ctyping.wt_val(Vint x)tuchar->0<=Int.signed x<=255.
Proof.
 intros x W;inversion W;subst.
 assert(U:0<=Int.unsigned x<256).
 { match goal with H:Ctyping.wt_int x I8 Unsigned|-_=>change(Int.zero_ext 8 x=x)in H;rewrite<-H end.
   exact(Int.zero_ext_range 8 x ltac:(change(0<=8<32);lia)). }
 rewrite Int.signed_eq_unsigned by(change(Int.unsigned x<=2147483647);lia);lia.
Qed.

Theorem original_reachable_operand_typed : forall args m prefix f C k e mp v ty,
 star Csem.step PprzTrigInit.Execution.ge(PprzTrigInit.Execution.entry args m)prefix
   (ExprState f(C(Eval v ty))k e mp) ->Csem.context RV RV C ->Ctyping.wt_val v ty.
Proof.
 intros args m prefix f C k e mp v ty PATH CONTEXT.
 pose proof(@original_initializer_reachable_typed args m prefix _ PATH)as STATE.
 inversion STATE;subst.
 match goal with E:Ctyping.wt_rvalue _ ?TE(C(Eval v ty))|-_=>
   pose proof(@Ctyping.wt_subexpr(Csem.globalenv PprzTrigInit.Source.prog)TE(Eval v ty)RV RV C CONTEXT E)as VALUE end.
 inversion VALUE;subst;assumption.
Qed.
Theorem original_reachable_short_operand_range : forall args m prefix f C k e mp x,
 star Csem.step PprzTrigInit.Execution.ge(PprzTrigInit.Execution.entry args m)prefix
   (ExprState f(C(Eval(Vint x)tshort))k e mp) ->Csem.context RV RV C ->signed16(Int.signed x).
Proof. intros;eapply typed_eval_short_range;eapply original_reachable_operand_typed;eauto. Qed.
Theorem original_reachable_ushort_operand_range : forall args m prefix f C k e mp x,
 star Csem.step PprzTrigInit.Execution.ge(PprzTrigInit.Execution.entry args m)prefix
   (ExprState f(C(Eval(Vint x)tushort))k e mp) ->Csem.context RV RV C ->0<=Int.signed x<=65535.
Proof. intros;eapply typed_eval_ushort_range;eapply original_reachable_operand_typed;eauto. Qed.
Theorem original_reachable_uchar_operand_range : forall args m prefix f C k e mp x,
 star Csem.step PprzTrigInit.Execution.ge(PprzTrigInit.Execution.entry args m)prefix
   (ExprState f(C(Eval(Vint x)tuchar))k e mp) ->Csem.context RV RV C ->0<=Int.signed x<=255.
Proof. intros;eapply typed_eval_uchar_range;eapply original_reachable_operand_typed;eauto. Qed.
Print Assumptions original_init_program_well_typed.
