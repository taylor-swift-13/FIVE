From Stdlib Require Import List.
From compcert Require Import AST Values Memory Events Determinism Ctypes Csem Cexec Smallstep.
Require PprzTrigLow.Source PprzTrigLow.Execution.
From PprzTrigRelationSupport Require Import ExecutionAlignment.
(** All machine values, memories, callbacks and worlds, without a verification precondition. *)
Definition EdgeExact:Prop:=forall args m prefix s cb asm w t next,
 star Csem.step PprzTrigLow.Execution.ge(PprzTrigLow.Execution.entry args m)prefix s ->
 (PprzTrigLow.Execution.model_step cb asm w tt s t next <->Csem.step PprzTrigLow.Execution.ge s t next).
Definition FiniteExact:Prop:=forall args m cb asm w t next,
 star(PprzTrigLow.Execution.model_step cb asm w)tt(PprzTrigLow.Execution.entry args m)t next <->
 star Csem.step PprzTrigLow.Execution.ge(PprzTrigLow.Execution.entry args m)t next.
Definition ExhaustionExact:Prop:=forall args m prefix s cb asm w,
 star Csem.step PprzTrigLow.Execution.ge(PprzTrigLow.Execution.entry args m)prefix s ->
 (nostep(PprzTrigLow.Execution.model_step cb asm w)tt s <->nostep Csem.step PprzTrigLow.Execution.ge s).
Definition domain_preservation:Prop:=forall args m,PprzTrigLow.Execution.entry args m=
 Callstate(Ctypes.Internal PprzTrigLow.Source.f_pprz_itrig_sin)args Kstop m.
(** Same-state, same-trace transition equality preserves bit constructors, pointer
    arithmetic, every byte and permission, and both successful and stuck reductions.
    This stronger statement covers each operation class, including malformed inputs. *)
Definition floating_point_correspondence:Prop:=EdgeExact.
Definition machine_integer_correspondence:Prop:=EdgeExact.
Definition memory_access_correspondence:Prop:=EdgeExact.
Definition control_and_exhaustion_correspondence:Prop:=FiniteExact /\ ExhaustionExact.
Definition normal_result_and_memory_correspondence:Prop:=forall args m cb asm w t v mf,
 star(PprzTrigLow.Execution.model_step cb asm w)tt(PprzTrigLow.Execution.entry args m)t(Returnstate v Kstop mf) <->
 star Csem.step PprzTrigLow.Execution.ge(PprzTrigLow.Execution.entry args m)t(Returnstate v Kstop mf).
Definition invalid_operation_correspondence:Prop:=forall args m prefix s cb asm w,
 star Csem.step PprzTrigLow.Execution.ge(PprzTrigLow.Execution.entry args m)prefix s ->
 (PprzTrigLow.Execution.source_error s <->
 (~PprzTrigLow.Execution.normal_return s /\nostep(PprzTrigLow.Execution.model_step cb asm w)tt s)).
Definition whole_execution_correspondence:Prop:=FiniteExact /\forall args m cb asm w T,
 forever(PprzTrigLow.Execution.model_step cb asm w)tt(PprzTrigLow.Execution.entry args m)T <->
 forever Csem.step PprzTrigLow.Execution.ge(PprzTrigLow.Execution.entry args m)T.
