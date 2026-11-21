From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Maps AST Integers Values Memory Events Globalenvs Ctypes Ctypesdefs Csyntax Csem Smallstep.
From FiveShared.verification Require Import Obligations.
From FiveShared.pure_semantics Require Import SemanticsSupport.
Require PprzTrigPlain.Source PprzTrigPlain.Execution PprzTrigLow.Source PprzTrigLow.Execution PprzTrigInit.Source PprzTrigInit.Execution.
From PprzTrigRelation Require Import Spec.
From PprzTrigRelationSupport Require Import Total InitialMemory InitComplete PlainClosed LowClosed LowDecoder ClosedCalls.
From PprzTrigCBMC Require Import GlobalMemory GlobalSource ArrayCoverage ArrayBases ArrayState ArrayMachine ArrayOwners ArrayEntry ArrayEvents GuardedControl LowGuarded.
Import ListNotations.
Local Open Scope Z_scope.
Definition EventBound(ge:Csem.genv)(elem:type)(owner:function->list(ident*Z)->Prop)(f:function)(b:block)(ofs:ptrofs):Prop:=
 exists ids id n index,owner f ids/\In(id,n)ids/\Genv.find_symbol ge id=Some b/\
 ofs=Ptrofs.repr(sizeof ge elem*Int.signed index)/\0<=Int.signed index<n.
Lemma low_owner_allowed:forall f ids,low_array_owner f ids->ClosedCalls.actual_allowed f.
Proof. intros f ids OWN;inversion OWN;subst;unfold ClosedCalls.actual_allowed,ClosedCalls.internal_functions;cbn;auto 12. Qed.
Lemma low_call_array_origins:forall f ids args m prefix s,low_array_owner f ids ->
 star Csem.step PprzTrigLow.Execution.ge(Callstate(Internal f)args Kstop m)prefix s ->
 array_state PprzTrigLow.Execution.ge tuchar low_array_owner s.
Proof.
 intros f ids args m prefix s OWN PATH.
 eapply(@ArrayMachine.original_array_every_prefix PprzTrigLow.Execution.ge tuchar low_array_owner
 ClosedCalls.actual_allowed ClosedCalls.direct_ids low_allowed_owned low_array_bodies low_array_locals
 ClosedCalls.actual_step_closed(Callstate(Internal f)args Kstop m)prefix s).
 - apply ClosedCalls.allowed_start_closed;eapply low_owner_allowed;exact OWN.
 - apply(low_array_start f ids args m);exact OWN.
 - exact PATH.
Qed.
Lemma low_call_silent:forall f ids args m prefix s,low_array_owner f ids ->
 star Csem.step PprzTrigLow.Execution.ge(Callstate(Internal f)args Kstop m)prefix s ->silent_state PprzTrigLow.Execution.ge s.
Proof.
 intros f ids args m prefix s OWN PATH;apply(@ClosedCalls.closed_silent PprzTrigLow.Execution.ge ClosedCalls.actual_allowed ClosedCalls.direct_ids s).
 eapply ClosedCalls.actual_star_closed;[exact PATH|]. apply ClosedCalls.allowed_start_closed;eapply low_owner_allowed;exact OWN.
Qed.
Lemma init_owner_global_bounds:forall initial,Spec.initial_low initial->forall f ids id n b,
 low_array_owner f ids->In(id,n)ids->Genv.find_symbol PprzTrigInit.Execution.ge id=Some b ->
 0<sizeof PprzTrigInit.Execution.ge tuchar<=2 /\0<=sizeof PprzTrigInit.Execution.ge tuchar*n<=12868 /\
 global_state b(sizeof PprzTrigInit.Execution.ge tuchar*n)(PprzTrigInit.Execution.entry[]initial).
Proof.
 intros initial INIT f ids id n b OWN IN SYMBOL;inversion OWN;subst;cbn[buffer_descriptor rom_descriptor]in IN;try contradiction;
 destruct IN as[EQ|[]];inversion EQ;subst id n;change(sizeof PprzTrigInit.Execution.ge tuchar)with 1;
 split;[lia|];split;[lia|].
 - exact(buffer_initial_bounds initial b INIT SYMBOL).
 - exact(rom_initial_bounds initial b INIT SYMBOL).
 - exact(buffer_initial_bounds initial b INIT SYMBOL).
Qed.
Lemma initialized_rom_bounds:forall initial after b,Spec.initial_low initial->
 Genv.find_symbol PprzTrigInit.Execution.ge PprzTrigInit.Source._pprz_trig_int_compr=Some b ->
 Spec.init_returns initial(Vint Int.zero)after ->global_bounds b 1690 after.
Proof.
 intros initial after b INIT SYMBOL[t PATH].
 exact(global_bounds_reachable PprzTrigInit.Execution.ge(PprzTrigInit.Execution.entry[]initial)b 1690 t _
 (rom_initial_bounds initial b INIT SYMBOL)PATH).
Qed.
Lemma after_owner_global_bounds:forall initial after,Spec.initial_low initial->Spec.init_returns initial(Vint Int.zero)after ->
 forall f ids id n b,low_array_owner f ids->In(id,n)ids->Genv.find_symbol PprzTrigLow.Execution.ge id=Some b ->
 0<sizeof PprzTrigLow.Execution.ge tuchar<=2 /\0<=sizeof PprzTrigLow.Execution.ge tuchar*n<=12868 /\
 global_bounds b(sizeof PprzTrigLow.Execution.ge tuchar*n)after.
Proof.
 intros initial after INIT RETURN f ids id n b OWN IN SYMBOL;inversion OWN;subst;cbn[buffer_descriptor rom_descriptor]in IN;try contradiction;
 destruct IN as[EQ|[]];inversion EQ;subst id n;change(sizeof PprzTrigLow.Execution.ge tuchar)with 1;
 split;[lia|];split;[lia|].
 - exact(initialized_buffer_bounds initial after b INIT SYMBOL RETURN).
 - exact(initialized_rom_bounds initial after b INIT SYMBOL RETURN).
 - exact(initialized_buffer_bounds initial after b INIT SYMBOL RETURN).
Qed.
Lemma plain_owner_global_bounds:forall initial,Spec.initial_plain initial->forall f ids id n b,
 plain_array_owner f ids->In(id,n)ids->Genv.find_symbol PprzTrigPlain.Execution.ge id=Some b ->
 0<sizeof PprzTrigPlain.Execution.ge tshort<=2 /\0<=sizeof PprzTrigPlain.Execution.ge tshort*n<=12868 /\
 global_state b(sizeof PprzTrigPlain.Execution.ge tshort*n)(PprzTrigPlain.Execution.entry[]initial).
Proof.
 intros initial INIT f ids id n b[FF ID]IN SYMBOL;subst f ids;cbn[plain_descriptor]in IN;destruct IN as[EQ|[]];inversion EQ;subst id n.
 change(sizeof PprzTrigPlain.Execution.ge tshort)with 2;split;[lia|];split;[lia|].
 exact(plain_initial_bounds initial b INIT SYMBOL).
Qed.
Theorem every_initialized_array_event:forall initial prefix f a k e m b ofs,
 Spec.initial_low initial ->star Csem.step PprzTrigInit.Execution.ge(PprzTrigInit.Execution.entry[]initial)prefix(ExprState f a k e m) ->
 ArrayEvent tuchar a b ofs ->EventBound PprzTrigInit.Execution.ge tuchar low_array_owner f b ofs.
Proof.
 intros initial prefix f a k e m b ofs INIT PATH EVENT.
 eapply every_array_event_origin_and_bounds with(ch:=Mint8unsigned).
 - exact(proj1(InitComplete.initializer_total_proved initial INIT)).
 - intros p s H;eapply init_source_silent;exact H.
 - exact(init_owner_global_bounds initial INIT).
 - exact PATH.
 - exact(init_reachable_array_origins[]initial prefix _ PATH).
 - exact EVENT.
 - reflexivity.
 - reflexivity.
Qed.
Theorem every_plain_array_event:forall initial input prefix f a k e m b ofs,
 Spec.initial_plain initial->Spec.normalized_angle input ->
 star Csem.step PprzTrigPlain.Execution.ge(PprzTrigPlain.Execution.entry[Vint input]initial)prefix(ExprState f a k e m) ->
 ArrayEvent tshort a b ofs ->EventBound PprzTrigPlain.Execution.ge tshort plain_array_owner f b ofs.
Proof.
 intros initial input prefix f a k e m b ofs INIT RANGE PATH EVENT.
 eapply every_array_event_origin_and_bounds with(ch:=Mint16signed).
 - exact(proj1(PlainClosed.plain_sine_total_normalized_proved initial input INIT RANGE)).
 - intros p s H;eapply plain_source_silent;exact H.
 - exact(plain_owner_global_bounds initial INIT).
 - exact PATH.
 - exact(plain_reachable_array_origins[Vint input]initial prefix _ PATH).
 - exact EVENT.
 - reflexivity.
 - reflexivity.
Qed.
Theorem every_low_array_event:forall initial after input prefix f a k e m b ofs,
 Spec.initial_low initial->Spec.init_returns initial(Vint Int.zero)after->Spec.normalized_angle input ->
 star Csem.step PprzTrigLow.Execution.ge(PprzTrigLow.Execution.entry[Vint input]after)prefix(ExprState f a k e m) ->
 ArrayEvent tuchar a b ofs ->EventBound PprzTrigLow.Execution.ge tuchar low_array_owner f b ofs.
Proof.
 intros initial after input prefix f a k e m b ofs INIT RETURN RANGE PATH EVENT.
 eapply every_array_event_origin_and_bounds with(ch:=Mint8unsigned).
 - exact(low_source_no_error initial after input INIT RETURN RANGE).
 - intros p s H;eapply low_source_silent;exact H.
 - exact(after_owner_global_bounds initial after INIT RETURN).
 - exact PATH.
 - exact(low_reachable_array_origins[Vint input]after prefix _ PATH).
 - exact EVENT.
 - reflexivity.
 - reflexivity.
Qed.
Theorem every_initialized_decoder_array_event:forall initial after index prefix f a k e m b ofs,
 Spec.initial_low initial->Spec.init_returns initial(Vint Int.zero)after->0<=Int.signed index<6434 ->
 star Csem.step PprzTrigLow.Execution.ge(Callstate(Internal LowDecoder.decoder)[Vint index]Kstop after)prefix(ExprState f a k e m) ->
 ArrayEvent tuchar a b ofs ->EventBound PprzTrigLow.Execution.ge tuchar low_array_owner f b ofs.
Proof.
 intros initial after index prefix f a k e m b ofs INIT RETURN RANGE PATH EVENT.
 eapply every_array_event_origin_and_bounds with(ch:=Mint8unsigned).
 - eapply Total.total_no_error;apply guarded_total_forget;exact(LowGuarded.original_initialized_decoder_math initial after index INIT RETURN RANGE).
 - intros p s H;eapply low_call_silent with(ids:=buffer_descriptor);[constructor|exact H].
 - exact(after_owner_global_bounds initial after INIT RETURN).
 - exact PATH.
 - eapply low_call_array_origins with(ids:=buffer_descriptor);[constructor|exact PATH].
 - exact EVENT.
 - reflexivity.
 - reflexivity.
Qed.
Print Assumptions every_initialized_array_event.
Print Assumptions every_plain_array_event.
Print Assumptions every_low_array_event.
Print Assumptions every_initialized_decoder_array_event.
