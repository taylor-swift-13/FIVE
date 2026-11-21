From Stdlib Require Import Bool List ZArith Lia.
From compcert Require Import Coqlib Maps Integers AST Values Memory Events Globalenvs Ctypes Ctypesdefs Cop Csyntax Csem Cexec.
Require PprzTrigLow.Source.
From PprzTrigRelationSupport Require Import LowDecoder LowEntry MachineData BranchPure PureEval.
From PprzTrigCBMC Require Import TypedGuards SourceObservations DecoderGuards MathCoverage SineMath.
Local Open Scope Z_scope.
Lemma math_other_binop : forall ge e m op l r ty,
 (forall v w,binary_math_guard op v w)->math_guarded ge e m l->math_guarded ge e m r->
 math_guarded ge e m(Ebinop op l r ty).
Proof. intros ge e m op l r ty G L R;cbn[math_guarded];repeat first[assumption|split];auto. Qed.
Lemma decoder_threshold_math : forall ge e m n,math_guarded ge e m(threshold n).
Proof. intros;apply math_other_binop;[intros v w;destruct v,w;exact I|exact I|exact I]. Qed.
Lemma set_high_math : forall ge e m x,
 (x=0\/x=1\/x=2\/x=3)->math_guarded ge e m(match set_high x with Sdo a=>a|_=>Eval Vundef tint end).
Proof.
 intros ge e m x X;change(True /\math_guarded ge e m(Ebinop Oshl(Eval(Vint(Int.repr x))tint)(Eval(Vint(Int.repr 12))tint)tint));split;[exact I|].
 eapply math_binop;[exact I|exact I|reflexivity|reflexivity|].
 destruct X as[->|[->|[->|->]]];change(0<=_ /\0<=12<32 /\signed32(_*2^12));unfold signed32;cbn;lia.
Qed.
Theorem decoder_expression_math : forall(ge:Csem.genv)e m bv bb a hi,
 0<=Int.signed a<6434->e!PprzTrigLow.Source._val=Some(bv,tshort)->e!PprzTrigLow.Source._data_buf_12=None->
 Genv.find_symbol ge PprzTrigLow.Source._data_buf_12=Some bb->Mem.load Mint16signed m bv 0=Some(Vint a)->
 Mem.load Mint8unsigned m bb(Ptrofs.unsigned(high_offset a))=Some(Vint hi)->
 math_guarded ge e m decoder_expr.
Proof.
 intros ge e m bv bb a hi A EV EB SYM LV LH.
 pose proof(proj2(source_val_observation ge e m bv a EV LV))as VAL.
 pose proof(proj2(source_buffer_observation ge e m bb EB SYM))as BUF.
 pose proof(proj2(source_high_index_observation ge e m bv a EV LV))as IX.
 pose proof(proj2(source_high_read_observation ge e m bv bb a hi EV EB SYM LV LH))as HR.
 pose proof(proj2(proj1(source_ternary_observation ge e m bv a EV LV)))as TC.
 destruct(decoder_source_pc_guards ge e m bv bb a hi A EV EB SYM LV LH)
  as[_[_[_[ADD[_[_[_[HB[SB SH]]]]]]]]].
 assert(SHR:branch_rval ge e m(Ebinop Oshr read_val(Eval(Vint(Int.repr 1))tint)tint)=Some(Vint(Int.shr a(Int.repr 1)))).
 { cbn[branch_rval];rewrite VAL;reflexivity. }
 assert(IM:math_guarded ge e m decoder_high_index).
 { change(math_guarded ge e m(Ebinop Oadd(Eval(Vint(Int.repr 6434))tint)(Ebinop Oshr read_val(Eval(Vint(Int.repr 1))tint)tint)tint)).
   eapply math_binop;[exact I|apply math_other_binop;[intros v w;destruct v,w;exact I|exact I|exact I]|reflexivity|exact SHR|exact ADD]. }
 assert(HM:math_guarded ge e m decoder_high_read).
 { change(math_guarded ge e m(Ebinop Oadd decoder_buffer decoder_high_index(tptr tuchar))).
   eapply math_binop;[exact I|exact IM|exact BUF|exact IX|exact I]. }
 assert(CM:math_guarded ge e m decoder_shift_choice).
 { change(math_guarded ge e m(Econdition(Ebinop Omod read_val(Eval(Vint(Int.repr 2))tint)tint)
    (Eval(Vint(Int.repr 4))tint)(Eval(Vint(Int.repr 8))tint)tint)).
   cbn[math_guarded];split;[apply math_other_binop;[intros v w;destruct v,w;exact I|exact I|exact I]|split;exact I]. }
 assert(SM:math_guarded ge e m decoder_shift_expr).
 { change(math_guarded ge e m(Ebinop Oshl decoder_high_read decoder_shift_choice tint)).
   eapply math_binop;[exact HM|exact CM|exact HR|exact TC|].
   change(0<=Int.signed hi /\0<=Int.signed(machine_shift a)<32 /\signed32(Int.signed hi*2^Int.signed(machine_shift a))));split;[lia|split;assumption]. }
 assert(LM:math_guarded ge e m decoder_low_read).
 { change(math_guarded ge e m(Ebinop Oadd decoder_buffer read_val(tptr tuchar))).
   eapply math_binop;[exact I|exact I|exact BUF|exact VAL|exact I]. }
 change(math_guarded ge e m(Ebinop Oor(Ebinop Oor read_k(Ebinop Oand decoder_shift_expr(Eval(Vint(Int.repr 3840))tint)tint)tint)decoder_low_read tint)).
 apply math_other_binop;[intros v w;destruct v,w;exact I| |exact LM].
 apply math_other_binop;[intros v w;destruct v,w;exact I|exact I|].
 apply math_other_binop;[intros v w;destruct v,w;exact I|exact SM|exact I].
Qed.
Print Assumptions decoder_expression_math.
