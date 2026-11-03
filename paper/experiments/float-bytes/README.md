# Floating-point object bytes: a WP model boundary

Measured on 2026-11-03: Frama-C/WP 31.0 Gallium, x86_64, binary32,
little endian; Alt-Ergo 2.6.2 and Z3 4.13.3, 5 seconds per proof attempt.
The program reads the four bytes of 1.0f through unsigned char and rebuilds
the word. This is character access to an object's representation, without
an incompatible uint32_t pointer dereference or an external memcpy contract.

| Configuration | Observed result |
| --- | --- |
| GCC 11.4 native program | 3f800000 |
| CompCert 3.17 compiled native program | 3f800000 |
| WP Typed+float, Qed | Incompatible-pointer-cast model warning; target Unknown |
| WP Bytes+raw+float, Qed | Target Unknown |
| WP Bytes+raw+float, Alt-Ergo and Z3 | All four read-validity obligations and assigns obligation proved; result-encoding obligation timed out in both provers |

The stronger evidence is in WP's actual exported solver input. Its float
encoding interface declares float32_to_int and int_to_float32 and supplies
inverse axioms. It does not define them as the target IEEE binary32 codec.
The initial-value constraint is:

    int_to_float32(read_uint32(mem_0, address_of_x)) = to_f32(1.0)

The postcondition needs the concrete word 1065353216 (0x3f800000).
The missing link is the IEEE value-to-encoding relation. This directly tests
FIVE's byte-level requirement, unlike an arithmetic-only sum3 benchmark.
The current WP 33.0 manual, section 3.8, also documents that float encoding
is assumed rather than concretely defined:
https://www.frama-c.com/download/frama-c-wp-manual.pdf

This experiment establishes a documented and inspected WP model gap under
the listed configurations. Timeout is the observed solver outcome; it is
not by itself evidence of a wrong C execution result. A concrete encoding
model and its supporting properties are the required integration work.

## Reproduce

    frama-c -machdep x86_64 -wp -wp-rte -wp-model Typed+float -wp-prover qed -wp-print bytes.c
    frama-c -machdep x86_64 -wp -wp-rte -wp-model Bytes+raw+float -wp-prover qed,alt-ergo,z3 -wp-timeout 5 -wp-print -wp-out wp bytes.c
    gcc -O0 bytes.c driver.c -o native
    ./native
    ccomp -c bytes.c -o bytes.o
    gcc -O0 bytes.o driver.c -o compcert-native
    ./compcert-native

The evidence archive includes the source, raw tool logs, generated solver
inputs, complete commands, hashes and actual token/time/memory receipts.
The cost audit records missing short-process samples explicitly. No new
Rocq proof or claim about other Frama-C plugins is part of this experiment.
