From compcert Require Import Ctypes Csem.
Require PprzTrigInit.Source PprzTrigLow.Source PprzTrigInit.Execution PprzTrigLow.Execution.
Lemma compressed_program_identical : PprzTrigInit.Source.prog=PprzTrigLow.Source.prog.
Proof. reflexivity. Qed.
Lemma compressed_ge_identical : PprzTrigInit.Execution.ge=PprzTrigLow.Execution.ge.
Proof. reflexivity. Qed.
