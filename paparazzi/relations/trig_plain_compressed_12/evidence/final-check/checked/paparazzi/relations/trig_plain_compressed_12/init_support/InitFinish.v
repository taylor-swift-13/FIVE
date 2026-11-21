From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Maps AST Integers Values Memory Ctypes Ctypesdefs Cop Csyntax Csem Cstrategy.
Require PprzTrigInit.Source PprzTrigInit.Execution.
From PprzTrigRelationSupport Require Import InitProtocol InitLoop InitState PackedPrefix PureEval Total.
From PprzTrigInitSupport Require Import Control InitCleanup.
Import ListNotations.
Local Open Scope Z_scope.
Local Opaque PprzTrigInit.Source.prog.

Definition init_finish_statement:=sequence_tail 5(fn_body PprzTrigInit.Source.f_pprz_trig_int_init).
Definition init_finish_condition:=Ebinop One
 (Evalof(Evar PprzTrigInit.Source._cnt tshort)tshort)(Eval(Vint(Int.repr 6434))tint)tint.
Definition init_zero_return:=Sreturn(Some(Eval(Vint Int.zero)tint)).
Lemma init_finish_shape : init_finish_statement=
 Ssequence(Sifthenelse init_finish_condition
   (Sreturn(Some(Eunop Oneg(Eval(Vint Int.one)tint)tint)))Sskip)init_zero_return.
Proof. reflexivity. Qed.

Lemma init_finish_guard : forall e m,
 short_cell e m PprzTrigInit.Source._cnt 6434 ->
 pure_rval PprzTrigInit.Execution.ge e m init_finish_condition=Some(Vint Int.zero).
Proof.
 intros e m CELL;unfold init_finish_condition.
 change(match pure_rval PprzTrigInit.Execution.ge e m
   (Evalof(Evar PprzTrigInit.Source._cnt tshort)tshort)with
 |Some v=>sem_binary_operation PprzTrigInit.Execution.ge One v tshort(Vint(Int.repr 6434))tint m
 |None=>None end=Some(Vint Int.zero)).
 rewrite(short_read_value _ _ _ _ _ CELL);reflexivity.
Qed.

Theorem init_finish_total : forall e base input buffer m,
 outer_inv e base input buffer [] m ->
 exists mf,packed_prefix 6434 mf buffer /\
 Mem.unchanged_on(Frame.protected base buffer)base mf /\
 (forall Q k,Total.total PprzTrigInit.Execution.ge Q(Returnstate(Vint Int.zero)(call_cont k)mf)->
 Total.total PprzTrigInit.Execution.ge Q
   (State PprzTrigInit.Source.f_pprz_trig_int_init init_finish_statement k e m)).
Proof.
 intros e base input buffer m[CORE[PREFIX[CI[CC REST]]]].
 destruct(init_locals_free e base input buffer m 6434 CORE PREFIX)as[mf[FREE[FRAME[PROTECTED COMPLETE]]]].
 exists mf;split;[exact COMPLETE|];split;[exact PROTECTED|].
 intros Q k END;rewrite init_finish_shape;apply sequence_total.
 eapply if_pure_total with(v:=Vint Int.zero)(choice:=false).
 - reflexivity.
 - apply init_finish_guard;exact CC.
 - reflexivity.
 - apply skip_sequence_total.
   eapply return_pure_total with(v:=Vint Int.zero)(res:=Vint Int.zero)(mf:=mf).
   + reflexivity.
   + reflexivity.
   + reflexivity.
   + exact FREE.
   + exact END.
Qed.
