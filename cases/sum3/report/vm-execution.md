# Direct sum3 vm_compute attempt

Inputs: 0x4B800000 (16777216), 0x3F800000 (1), 0xCB800000 (-16777216).

Full Cexec driver: no returned bit pattern obtained. Raw evaluation, evaluation with memory definitions made locally transparent, and an evaluation without pretty-printing each timed out after 30 seconds. No extraction backend was used.

Separate arithmetic-only evaluation returned Z=0 (0x00000000); the vm_compute equality proof passed independent kernel checking. This is not reported as successful complete C execution.

An isolated empty-range permission probe did not reduce to a boolean: its residual term contains Zwf.Zwf_up_well_founded 0 0. This confirms a direct-reduction barrier in the existing memory decision procedure; increasing the timeout alone does not establish full executability in the VM.

Reproduce after building the model modules with the standard load paths: import VmRun and issue Eval vm_compute in result. VmArithmetic.v contains the separate successful arithmetic computation and equality proof.
