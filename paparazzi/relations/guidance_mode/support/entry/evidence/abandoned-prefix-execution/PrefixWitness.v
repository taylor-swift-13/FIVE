From Stdlib Require Import List ZArith Bool.
From compcert Require Import Coqlib Integers Floats AST Values Memory Events Globalenvs Ctypes Csyntax Csem Cexec Smallstep.
From FiveGuidanceEntry Require Import Entry.
From FiveGuidanceSemantics Require Import SemanticsSupport.
Require FiveGhSpeed.Source FiveGhSpeed.Execution.
Import ListNotations.
Local Open Scope Z_scope.
Definition supported (s : Csem.state) : bool :=
 match s with
 | ExprState _ a _ _ _ => no_builtin a
 | Callstate (External ef _ _ _) _ _ _ => executable_builtin ef
 | _ => true
 end.
Lemma supported_correct : forall s, supported s=true -> callback_free_state s.
Proof. destruct s; simpl; auto; destruct fd; simpl; auto. Qed.
Definition nonstuck (s : Csem.state) : bool :=
 match s with Stuckstate => false | _ => true end.
Lemma nonstuck_correct : forall s, nonstuck s=true -> s<>Stuckstate.
Proof. destruct s; simpl; congruence. Qed.
Definition helper_call (s : Csem.state) : bool :=
 match s with
 | Callstate (Internal f) _ _ _ => Nat.eqb (length (fn_vars f)) 2
 | _ => false
 end.
Fixpoint checked_prefix (fuel : nat) (s : Csem.state) : option Csem.state :=
 if helper_call s then Some s else
 match fuel with
 | O => None
 | S n => if supported s then
   match FiveGhSpeed.Execution.closed_transitions s with
   | TR _ [] next :: _ => if nonstuck next then checked_prefix n next else None
   | _ => None
   end else None
 end.
Lemma checked_prefix_sound : forall n s last,
 checked_prefix n s=Some last ->
 star Csem.step FiveGhSpeed.Execution.ge s E0 last /\ helper_call last=true.
Proof.
 induction n as [|n IH];intros s last H; cbn [checked_prefix] in H.
 - destruct (helper_call s) eqn:STOP; try discriminate; injection H as <-; split; [constructor|exact STOP].
 - destruct (helper_call s) eqn:STOP.
   + injection H as <-; split; [constructor|exact STOP].
   + destruct (supported s) eqn:SUP; try discriminate.
     destruct (FiveGhSpeed.Execution.closed_transitions s) as [|[rule t next] rest] eqn:STEP;try discriminate.
     destruct t;try discriminate. destruct (nonstuck next)eqn:NS;try discriminate.
     destruct (IH _ _ H) as [PATH END];split;[|exact END].
     eapply star_step with (t1:=E0)(t2:=E0);[|exact PATH|reflexivity].
     eapply (supported_nonstuck_transition FiveGhSpeed.Execution.ge FiveGhSpeed.Execution.no_external FiveGhSpeed.Execution.no_external FiveGhSpeed.Execution.quiet_world s rule E0 next).
     * apply supported_correct;exact SUP.
     * change (In (TR rule E0 next) (FiveGhSpeed.Execution.closed_transitions s));rewrite STEP;left;reflexivity.
     * apply nonstuck_correct;exact NS.
Qed.
Definition speed_block : block :=
 match Genv.find_symbol FiveGhSpeed.Execution.ge FiveGhSpeed.Source._gh_ref with
 | Some b=>b | None=>1%positive end.
Fixpoint dummy_blocks (n : nat) (m : mem) : mem :=
 match n with O=>m | S k=> let '(ma,b):=Mem.alloc m 0 0 in dummy_blocks k ma end.
Definition seed_memory : option (mem*block) :=
 let base:=dummy_blocks (Nat.pred(Pos.to_nat speed_block)) Mem.empty in
 let '(m0,bh):=Mem.alloc base 0 64 in
 let '(mk,bk):=Mem.alloc m0 0 4 in
 match Mem.store Mfloat32 mk bk 0 (Vsingle fixed_maximum) with |None=>None|Some mk0=>
 match Mem.store Mint64 mk0 bh 16 (Vlong Int64.zero) with |None=>None|Some mk1=>
 match Mem.store Mint64 mk1 bh 24 (Vlong Int64.zero) with |None=>None|Some mk2=>
 match Mem.store Mfloat32 mk2 speed_block 0 (Vsingle ftwo) with | None=>None |Some m1=>
 match Mem.store Mfloat32 m1 speed_block 4 (Vsingle ftwo) with | None=>None |Some m2=>
 match Mem.store Mfloat32 m2 speed_block 8 (Vsingle fone) with | None=>None |Some m3=>
 match Mem.store Mfloat32 m3 speed_block 12 (Vsingle fone) with | None=>None |Some m4=>
 match Mem.store Mfloat32 m4 speed_block 56 (Vsingle ftwo) with | None=>None |Some m5=>
 match Mem.store Mfloat32 m5 speed_block 60 (Vsingle (State.dt sample_state)) with | None=>None |Some m6=>
 let '(ma,arg) := Mem.alloc m6 0 8 in
 match Mem.store Mfloat32 ma arg 0 (Vsingle fone) with | None=>None |Some mb=>
 match Mem.store Mfloat32 mb arg 4 (Vsingle fone) with | None=>None |Some mc=>
 Some(mc,arg)
 end end end end end end end end end end end.
Definition prefix_witness : option Csem.state :=
 match seed_memory with
 | Some(m,arg)=>checked_prefix 1000 (FiveGhSpeed.Execution.entry [Vptr arg Ptrofs.zero] m)
 |None=>None end.
Definition single_bits (m : mem) (b : block) (ofs : Z) : option Z :=
 match Mem.load Mfloat32 m b ofs with
 |Some(Vsingle f)=>Some(Int.unsigned(Float32.to_bits f))|_=>None end.
Definition long_signed (m : mem) (b : block) (ofs : Z) : option Z :=
 match Mem.load Mint64 m b ofs with
 |Some(Vlong i)=>Some(Int64.signed i)|_=>None end.
Definition prefix_observation (s : Csem.state) : option (list (option Z)) :=
 match s with
 | Callstate (Internal f) [Vptr arg ofs] _ m=>
 Some [single_bits m arg (Ptrofs.unsigned ofs);single_bits m arg (Ptrofs.unsigned ofs+4);
 single_bits m speed_block 8;single_bits m speed_block 12;
 long_signed m speed_block 16;long_signed m speed_block 24]
 | _=>None end.
Lemma actual_prelimit_observation :
 option_map prefix_observation prefix_witness =
 Some(Some [Some 3154116608;Some 3154116608;
 Some 1065385984;Some 1065385984;Some 268435456;Some 268435456]).
Proof. vm_compute; reflexivity. Qed.
Theorem actual_prelimit_reachable : exists m arg last,
 seed_memory=Some(m,arg) /\
 star Csem.step FiveGhSpeed.Execution.ge
 (FiveGhSpeed.Execution.entry [Vptr arg Ptrofs.zero] m) E0 last /\
 helper_call last=true /\
 prefix_observation last=Some [Some 3154116608;Some 3154116608;
 Some 1065385984;Some 1065385984;Some 268435456;Some 268435456].
Proof.
 pose proof actual_prelimit_observation as OBS.
 unfold prefix_witness in OBS.
 destruct seed_memory as [[m arg]|]eqn:SEED;try discriminate.
 destruct (checked_prefix 1000 (FiveGhSpeed.Execution.entry [Vptr arg Ptrofs.zero] m)) as [last|]eqn:RUN;try discriminate.
 injection OBS as OBS.
 destruct (checked_prefix_sound _ _ _ RUN)as[PATH END].
 exists m,arg,last;auto.
Qed.
Print Assumptions actual_prelimit_reachable.
