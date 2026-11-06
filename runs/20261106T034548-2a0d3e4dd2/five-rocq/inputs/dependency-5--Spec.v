From Stdlib Require Import List ZArith.
From compcert Require Import AST Values Memory Events Ctypes Csyntax Csem Cexec Smallstep.
From FiveGhSetZeta Require Import Source Execution.
From FiveGhSetZetaProof Require Import SourceInvariant WholeExecution.
Import ListNotations.
Definition DomainGoal:Prop:=forall args m,Execution.entry args m=Callstate(Internal Source.f_gh_set_zeta)args Kstop m /\ source_state(Execution.entry args m).
Definition FloatGoal:Prop:=forall s t next,source_state s -> (closed_step tt s t next <-> Csem.step Execution.ge s t next).
Definition IntGoal:Prop:=forall s t next,source_state s -> (closed_step tt s t next <-> Csem.step Execution.ge s t next).
Definition MemoryGoal:Prop:=forall s t next,source_state s -> (closed_step tt s t next <-> Csem.step Execution.ge s t next).
Definition ControlGoal:Prop:=forall args m t final,star closed_step tt(Execution.entry args m)t final <-> star Csem.step Execution.ge(Execution.entry args m)t final.
Definition WholeGoal:Prop:=forall args m t final,star closed_step tt(Execution.entry args m)t final <-> star Csem.step Execution.ge(Execution.entry args m)t final.
Definition NormalGoal:Prop:=forall v m b ofs n,Execution.normal_return(Returnstate v Kstop m) /\ Execution.observe_bytes m b ofs n=Mem.loadbytes m b ofs n.
Definition InvalidGoal:Prop:=forall args m t reached,star Csem.step Execution.ge(Execution.entry args m)t reached -> (Execution.source_error reached <-> ~Execution.normal_return reached /\ nostep closed_step tt reached).
