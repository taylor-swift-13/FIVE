# Sum3: actual tool and native execution comparison

Run on 2026-11-03 in x86-64 WSL2 Linux. Target: binary32, little endian,
nearest-even rounding, MXCSR 0x1f80 (masked exceptions, gradual underflow).

| Execution / model | Finite input result bits | NaN input result bits |
| --- | --- | --- |
| CompCert 3.17 operations in Rocq | 00000000 | 7fc00042 |
| CompCert 3.17 compiled function, native execution | 00000000 | 7fc00042 |
| GCC 11.4 compiled function, native execution | 00000000 | 7fc00042 |
| QCP v2.1.4 FloatLib operations in Rocq | 00000000 | 7f800001 |

Finite input words: 4b800000, 3f800000, cb800000.
NaN input words: 7fc00042, 00000000, 00000000.

Frama-C/WP 31.0 was run with Typed+real and Typed+float, using Qed.
Real proves the result is 1 and reduces the zero-result obligation to false.
Float retains two add_f32 operations and reports both result obligations Unknown.
These proof statuses are distinct from returned runtime values.

The original QCP release binary performs symbolic execution of qcp.c with
64-bit, little-endian settings and finite-value VCs disabled. Its actual return
expression contains two left-associated fp32_add operations. Sum3Bits.v evaluates
that expression using the unchanged release FloatLib.v and CompCert's own
Float32.add; all four bit-result theorems pass an independent Rocq kernel check.
The generated QCP separation-logic proof templates are not counted as completed
proofs. The initial equality contract is retained in the evidence: IEEE equality
is unsuitable for observing NaN bits, so the final input uses Ensure emp.

The CompCert-compiled function has two addss instructions. It is linked to the
GCC-compiled bit-pattern harness. CompCert and GCC native results agree with the
CompCert arithmetic model on both recorded inputs.

## Reproduction and evidence

results.json contains configurations, source hashes and results. evidence.tar.gz
contains the complete measured run: commands, raw outputs, GNU time records,
process-tree RSS observations, token receipts, inputs and proof evidence. Extract
it into a temporary directory to inspect run.json and repeat its command argv
entries in order, adjusting only installation paths. Tool versions and binary
hashes are recorded. The QCP release URLs and file hashes are included.

Core commands, from the repository root (set tool paths for the pinned versions):

```sh
frama-c -machdep x86_64 -wp -wp-model Typed+real -wp-prover qed -wp-print paper/experiments/sum3/wp.c
frama-c -machdep x86_64 -wp -wp-model Typed+float -wp-prover qed -wp-print paper/experiments/sum3/wp.c
symexec --input-file=paper/experiments/sum3/qcp.c --coq-output-dir=BUILD/qcp --arch=64 --endian=little --no-float-finite-vc
ccomp -c paper/experiments/sum3/sum3.c -o BUILD/sum3.ccomp.o
gcc -std=c11 -O0 -fno-fast-math -ffp-contract=off -frounding-math paper/experiments/sum3/native.c BUILD/sum3.ccomp.o -lm -o BUILD/ccomp-native
gcc -std=c11 -O0 -fno-fast-math -ffp-contract=off -frounding-math paper/experiments/sum3/sum3.c paper/experiments/sum3/native.c -lm -o BUILD/gcc-native
BUILD/ccomp-native
BUILD/gcc-native
# Put the unmodified release FloatLib.v and Sum3Bits.v in BUILD:
rocq c -Q BUILD Comparison BUILD/FloatLib.v
rocq c -Q BUILD Comparison BUILD/Sum3Bits.v
rocq check -Q BUILD Comparison Comparison.Sum3Bits
```

The native harness sets RNE and MXCSR before both calls. Runtime inputs enter
through memcpy, and the tested function is a separate translation unit.
The proof input snapshots, original QCP library and its license are in the archive.
Cost measurements cover experiment construction and execution from the recorded
session boundary; initial environment discovery and later paper editing are outside
that interval. Raw library assumptions and the initial contract attempt remain visible.

## Recorded stage costs

| Metric | Observed value |
| --- | --- |
| Wall time | 528.845587 s |
| Tool CPU time | 29.35 s |
| Input tokens | 2,354,770 |
| Cached input (included above) | 2,337,152 |
| Output tokens | 11,056 |
| Total tokens | 2,365,826 |
| Observed process-tree RSS peak | 1,351,790,592 bytes |
| GNU time maximum individual-process RSS | 1,354,866,688 bytes |

The strict cost audit is partial because the two short native executions
finished without a nonzero process-tree sample at the 10 ms sampling interval.
Their raw time records are preserved. The reported stage peak was observed
during the measured tools; it excludes model-server memory. Cached input and
reasoning output are subsets, not additional token charges. Verification results
and measurement completeness are recorded separately.
