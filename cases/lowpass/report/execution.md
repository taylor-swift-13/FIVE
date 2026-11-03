# Concrete lowpass execution

Input: a=[0.5,0.25], b=[0.25,0.5], i=[2,-1], o=[1,-2], value=4 (0x40800000).

Executed original Cexec via standard Rocq OCaml extraction, using formal floating-point definitions, with no custom native-float mappings. The driver selects the first actual successor. One concrete run returned after 177 steps: 0x3FE00000 (1.75f).

Full before/after 32-byte memory is in execution.json. Changed byte offsets: 18,22,23,26,30,31. Coefficients at bytes 0..15 are unchanged.

Rocq vm_compute attempt timed out after 15 seconds. The displayed numeric result is from extraction, not an in-kernel equality proof. ConcreteRun.v and the generic theorem drive_follows_actual_model passed independent kernel checking; this theorem establishes that the driver follows a finite path of the original model.

Reproduce from the WSL project root: source scripts/env.sh; python3 scripts/run-lowpass-example.py
