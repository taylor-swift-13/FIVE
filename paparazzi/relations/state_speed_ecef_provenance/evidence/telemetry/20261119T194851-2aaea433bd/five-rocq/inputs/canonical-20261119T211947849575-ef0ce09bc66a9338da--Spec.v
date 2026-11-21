From Stdlib Require Import List ZArith.
From compcert Require Import Values Memory Events Ctypes Csyntax Csem Smallstep.
From FiveShared.verification Require Import Obligations.
From StateSpeedGetterSupport Require Import Setup.
Import ListNotations.
Open Scope Z_scope.
From StateSpeedGetEcefF Require Import Source Execution.
Require StateSpeedGetterSupport.GetterSource.
Module GS:=StateSpeedGetterSupport.GetterSource.
Definition domain_preservation_goal:Prop:=forall args m,Execution.entry args m=Callstate(Internal Source.f_stateGetSpeedEcef_f)args Kstop m /\ GS.source_state(Execution.entry args m).
Definition reachable_step_goal:Prop:=forall args m t reached tr next,star Csem.step Execution.ge(Execution.entry args m)t reached->(GS.closed_step tt reached tr next<->Csem.step Execution.ge reached tr next).
Definition floating_point_correspondence_goal:=reachable_step_goal.
Definition machine_integer_correspondence_goal:=reachable_step_goal.
Definition memory_access_correspondence_goal:=reachable_step_goal.
Definition control_and_exhaustion_correspondence_goal:Prop:=forall args m t final,star GS.closed_step tt(Execution.entry args m)t final<->star Csem.step Execution.ge(Execution.entry args m)t final.
Definition normal_result_and_memory_correspondence_goal:Prop:=forall args m t v mf b ofs n,(star GS.closed_step tt(Execution.entry args m)t(Returnstate v Kstop mf)<->star Csem.step Execution.ge(Execution.entry args m)t(Returnstate v Kstop mf)) /\ Execution.observe_bytes mf b ofs n=Mem.loadbytes mf b ofs n.
Definition invalid_operation_correspondence_goal:Prop:=forall args m t reached,star Csem.step Execution.ge(Execution.entry args m)t reached->(Execution.source_error reached<->~Execution.normal_return reached /\ nostep GS.closed_step tt reached).
Definition whole_execution_correspondence_goal:=control_and_exhaustion_correspondence_goal.
