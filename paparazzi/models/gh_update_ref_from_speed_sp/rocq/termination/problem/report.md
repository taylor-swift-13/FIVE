# gh_update_ref_from_speed_sp: termination

Proved for the frozen CompCert 3.17 x86-64 little-endian Csyntax/Csem model with the explicit integer-restoring five_sqrtf C binding. Specification: Spec.v; current attempt: ../attempts/001.

Domain: every CompCert list val argument list and every CompCert mem, including malformed, invalid and uninitialized inputs. No numerical or memory precondition narrows this domain. The source/model graph retains errors. Termination means Acc for every original Csem successor; execution correspondence preserves all evaluation orders, operations, errors, returned values and exact memory.

This problem does not assert no-error or the high-level guidance numerical update specification. C frontend provenance and inherited CompCert/Flocq classical and external-semantic declarations remain the documented boundary.
