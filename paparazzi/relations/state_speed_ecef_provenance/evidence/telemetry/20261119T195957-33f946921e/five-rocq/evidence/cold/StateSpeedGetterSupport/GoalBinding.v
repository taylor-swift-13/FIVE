
From Stdlib Require Import List.
From compcert Require Import Values Memory Events Csem Cexec Smallstep.
From FiveShared.verification Require Import Obligations.
From StateSpeedGetEcefF Require Import Execution.
From StateSpeedGetterSupport Require Import GetterSource.
Definition RawAllSuccessorTermination:
 forall(args:list val)(m:mem),Acc(successor Execution.ge)(Execution.entry args m):=
 GetterSource.all_successor_termination.
Definition RawOneStepCorrespondence:
 forall cb asm w s t next,GetterSource.source_state s->
 ((exists rule,List.In(TR rule t next)(Cexec.do_step Execution.ge cb asm w s))<->
 Csem.step Execution.ge s t next):=GetterSource.one_step_correspondence.
Definition RawWholeExecutionCorrespondence:
 forall args m t final,
 star(Execution.model_step Execution.no_external Execution.no_external Execution.quiet_world)tt(Execution.entry args m)t final<->
 star Csem.step Execution.ge(Execution.entry args m)t final:=
 GetterSource.whole_execution_correspondence.
Definition RawInvalidOperationCorrespondence:
 forall args m t reached,
 star Csem.step Execution.ge(Execution.entry args m)t reached->
 (Execution.source_error reached<->
 ~Execution.normal_return reached /\ nostep(Execution.model_step Execution.no_external Execution.no_external Execution.quiet_world)tt reached):=
 GetterSource.invalid_operation_correspondence.
Print Assumptions RawAllSuccessorTermination.
Print Assumptions RawOneStepCorrespondence.
Print Assumptions RawWholeExecutionCorrespondence.
Print Assumptions RawInvalidOperationCorrespondence.
