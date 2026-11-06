From Stdlib Require Import List ZArith.
From compcert Require Import AST Values Memory Events Ctypes Csyntax Csem Cexec Smallstep.
From FiveGhSetOmega Require Import Source Execution.
From FiveGhSetOmegaProof Require Import SourceInvariant.
Import ListNotations.
Definition closed_step := Execution.model_step Execution.no_external Execution.no_external Execution.quiet_world.
Definition domain_preservation_goal:Prop:=forall args m,
 Execution.entry args m=Callstate(Internal Source.f_gh_set_omega)args Kstop m /\
 source_state(Execution.entry args m).

Definition one_step_correspondence_goal:Prop:=forall s t next,
 source_state s -> (closed_step tt s t next <-> Csem.step Execution.ge s t next).

Definition whole_execution_correspondence_goal:Prop:=forall args m t final,
 star closed_step tt(Execution.entry args m)t final <->
 star Csem.step Execution.ge(Execution.entry args m)t final.

Definition invalid_operation_correspondence_goal:Prop:=forall args m t reached,
 star Csem.step Execution.ge(Execution.entry args m)t reached ->
 (Execution.source_error reached <-> ~Execution.normal_return reached /\ nostep closed_step tt reached).

Definition normal_result_memory_correspondence_goal:Prop:=forall v m b ofs n,
 Execution.normal_return(Returnstate v Kstop m) /\
 Execution.observe_bytes m b ofs n=Mem.loadbytes m b ofs n.
