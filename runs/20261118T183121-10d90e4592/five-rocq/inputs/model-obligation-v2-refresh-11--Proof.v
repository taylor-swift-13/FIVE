From Stdlib Require Import List.
From compcert Require Import AST Values Memory Events Determinism Ctypes Csem Cexec Smallstep.
From PprzTrigPlainCorrespondence Require Import Spec.
From PprzTrigRelationSupport Require Import ExecutionAlignment ClosedCalls.
Require PprzTrigPlain.Execution.
Theorem edge:Spec.EdgeExact.
Proof. exact ExecutionAlignment.plain_edge_exact. Qed.
Theorem finite:Spec.FiniteExact.
Proof. intros args m cb asm w t next;eapply ExecutionAlignment.finite_exact;intros prefix s tr after PATH;exact(edge args m prefix s cb asm w tr after PATH). Qed.
Theorem exhaustion:Spec.ExhaustionExact.
Proof. intros args m prefix s cb asm w PATH;eapply ExecutionAlignment.exhaustion_exact;[|exact PATH]. intros p st tr after P;exact(edge args m p st cb asm w tr after P). Qed.
Theorem domain:Spec.domain_preservation.
Proof. intros;reflexivity. Qed.
Theorem floating_point:Spec.floating_point_correspondence.
Proof. exact edge. Qed.
Theorem machine_integer:Spec.machine_integer_correspondence.
Proof. exact edge. Qed.
Theorem memory_access:Spec.memory_access_correspondence.
Proof. exact edge. Qed.
Theorem control_and_exhaustion:Spec.control_and_exhaustion_correspondence.
Proof. split;[exact finite|exact exhaustion]. Qed.
Theorem normal_result_and_memory:Spec.normal_result_and_memory_correspondence.
Proof. intros;apply finite. Qed.
Theorem invalid_operation:Spec.invalid_operation_correspondence.
Proof. intros args m prefix s cb asm w PATH;unfold PprzTrigPlain.Execution.source_error;rewrite(exhaustion args m prefix s cb asm w PATH);reflexivity. Qed.
Theorem whole_execution:Spec.whole_execution_correspondence.
Proof.
 split;[exact finite|]. intros args m cb asm w T;eapply ExecutionAlignment.infinite_exact.
 intros p st tr after PATH;exact(edge args m p st cb asm w tr after PATH).
Qed.
Print Assumptions domain.
Print Assumptions floating_point.
Print Assumptions machine_integer.
Print Assumptions memory_access.
Print Assumptions control_and_exhaustion.
Print Assumptions normal_result_and_memory.
Print Assumptions invalid_operation.
Print Assumptions whole_execution.
