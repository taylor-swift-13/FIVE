From Stdlib Require Import Bool List ZArith Lia.
From compcert Require Import Coqlib Errors Maps Integers Floats AST Values Memory Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cexec Cstrategy Smallstep.
Require PprzTrigLow.Source.
From PprzTrigRelationSupport Require Import PlainCore PureEval PureProgress Total BranchPure TrigData MachineData LowDecoder.
From PprzTrigInitSupport Require Import Control.
From PprzTrigCBMC Require Import MathCoverage GuardedCover GuardedControl DecoderMath.
Import ListNotations Csyntaxdefs.CsyntaxNotations.
Local Open Scope Z_scope.
Local Opaque PprzTrigLow.Source.prog.
Lemma set_high_guarded : forall ge Q f kont e m bk x,
 (x=0\/x=1\/x=2\/x=3) ->e!PprzTrigLow.Source._k=Some(bk,tshort) ->
 Mem.valid_access m Mint16signed bk 0 Writable ->
 (forall middle,Mem.store Mint16signed m bk 0(Vint(Int.repr(x*4096)))=Some middle ->
 guarded_covers ge Q(State f Sskip kont e middle)) ->
 guarded_covers ge Q(State f(set_high x)kont e m).
Proof.
 intros ge Q f kont e m bk x BX EK VA END.
 destruct(Mem.valid_access_store _ _ _ _ (Vint(Int.repr(x*4096)))VA)as[middle STORE].
 eapply do_flat_math_guarded with(v:=Vint(Int.repr(x*4096)))(mf:=middle).
 - reflexivity.
 - reflexivity.
 - reflexivity.
 - exact(set_high_math ge e m x BX).
 - apply short_assign_value with(b:=bk);auto;try reflexivity.
   + destruct BX as[EQ|[EQ|[EQ|EQ]]];subst;vm_compute;reflexivity.
   + destruct BX as[EQ|[EQ|[EQ|EQ]]];subst;vm_compute;reflexivity.
 - apply END;exact STORE.
Qed.
Lemma decoder_select_guarded : forall ge Q f kont e m bv bk a,
 e!PprzTrigLow.Source._val=Some(bv,tshort) ->e!PprzTrigLow.Source._k=Some(bk,tshort) ->
 Mem.load Mint16signed m bv 0=Some(Vint a) ->Mem.valid_access m Mint16signed bk 0 Writable ->
 (forall middle,Mem.store Mint16signed m bk 0(Vint(machine_high_bits a))=Some middle ->
 guarded_covers ge Q(State f Sskip kont e middle)) ->
 guarded_covers ge Q(State f decoder_select kont e m).
Proof.
 intros ge Q f kont e m bv bk a EV EK LOAD VA END;rewrite decoder_select_shape.
 eapply if_math_guarded with(v:=Val.of_bool(Int.cmp Clt a(Int.repr 2145)))(choice:=Int.cmp Clt a(Int.repr 2145)).
 - reflexivity.
 - eapply threshold_value;eauto.
 - apply decoder_threshold_math.
 - destruct(Int.cmp Clt a(Int.repr 2145));reflexivity.
 - destruct(Int.cmp Clt a(Int.repr 2145))eqn:C2;simpl.
   + eapply if_math_guarded with(v:=Val.of_bool(Int.cmp Clt a(Int.repr 1035)))(choice:=Int.cmp Clt a(Int.repr 1035)).
     * reflexivity.
     * eapply threshold_value;eauto.
     * apply decoder_threshold_math.
     * destruct(Int.cmp Clt a(Int.repr 1035));reflexivity.
     * destruct(Int.cmp Clt a(Int.repr 1035))eqn:C1;simpl;
       eapply set_high_guarded;eauto;intros middle STORE;apply END;unfold machine_high_bits;rewrite C2,C1;exact STORE.
   + eapply if_math_guarded with(v:=Val.of_bool(Int.cmp Clt a(Int.repr 3474)))(choice:=Int.cmp Clt a(Int.repr 3474)).
     * reflexivity.
     * eapply threshold_value;eauto.
     * apply decoder_threshold_math.
     * destruct(Int.cmp Clt a(Int.repr 3474));reflexivity.
     * destruct(Int.cmp Clt a(Int.repr 3474))eqn:C3;simpl;
       eapply set_high_guarded;eauto;intros middle STORE;apply END;unfold machine_high_bits;rewrite C2,C3;exact STORE.
Qed.

Theorem decoder_body_guarded : forall (ge:Csem.genv)Q kont e m bv bk bb a hi lo,
 0<=Int.signed a<6434->e!PprzTrigLow.Source._val=Some(bv,tshort) ->e!PprzTrigLow.Source._k=Some(bk,tshort) ->e!PprzTrigLow.Source._data_buf_12=None ->
 Genv.find_symbol ge PprzTrigLow.Source._data_buf_12=Some bb ->bv<>bk ->bb<>bk ->
 Mem.load Mint16signed m bv 0=Some(Vint a) ->Mem.valid_access m Mint16signed bk 0 Writable ->
 Mem.load Mint8unsigned m bb(Ptrofs.unsigned(low_offset a))=Some(Vint lo) ->
 Mem.load Mint8unsigned m bb(Ptrofs.unsigned(high_offset a))=Some(Vint hi) ->
 (forall middle,Mem.store Mint16signed m bk 0(Vint(machine_high_bits a))=Some middle ->
  exists mf,Mem.free_list middle(blocks_of_env ge e)=Some mf /\
   guarded_covers ge Q(Returnstate(Vint(Int.sign_ext 16(raw_decoder(machine_high_bits a)a hi lo)))(call_cont kont)mf)) ->
 guarded_covers ge Q(State decoder(fn_body decoder)kont e m).
Proof.
 intros ge Q kont e m bv bk bb a hi lo A EV EK EB SYM NE NK LV VA LL LH END.
 change(guarded_covers ge Q(State decoder(Ssequence decoder_select(Sreturn(Some decoder_expr)))kont e m)).
 apply sequence_guarded;apply decoder_select_guarded with(bv:=bv)(bk:=bk)(a:=a);auto.
 intros middle STORE. apply skip_sequence_guarded.
 destruct(END _ STORE)as[mf[FREE OBS]].
 apply return_start_guarded. eapply math_observation_prefix_guarded with(v:=Vint(raw_decoder(machine_high_bits a)a hi lo)).
 - apply decoder_expr_branch_simple.
 - apply decoder_expression_reads with(bv:=bv)(bk:=bk)(bb:=bb);auto.
   + rewrite(Mem.load_store_other _ _ _ _ _ _ STORE Mint16signed bv 0)by auto;exact LV.
   + rewrite(Mem.load_store_same _ _ _ _ _ _ STORE). cbn[Val.load_result]. rewrite high_bits_short;reflexivity.
   + rewrite(Mem.load_store_other _ _ _ _ _ _ STORE Mint8unsigned bb(Ptrofs.unsigned(low_offset a)))by auto;exact LL.
   + rewrite(Mem.load_store_other _ _ _ _ _ _ STORE Mint8unsigned bb(Ptrofs.unsigned(high_offset a)))by auto;exact LH.
 - apply decoder_expression_math with(bv:=bv)(bb:=bb)(a:=a)(hi:=hi);auto.
   + rewrite(Mem.load_store_other _ _ _ _ _ _ STORE Mint16signed bv 0)by auto;exact LV.
   + rewrite(Mem.load_store_other _ _ _ _ _ _ STORE Mint8unsigned bb(Ptrofs.unsigned(high_offset a)))by auto;exact LH.
 - eapply return_value_guarded;[reflexivity|exact FREE|exact OBS].
Qed.
Print Assumptions decoder_body_guarded.
