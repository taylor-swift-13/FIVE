# sum2 termination problem

Status: specified. The problem is [Spec.v](Spec.v). Its solution is [attempt 001](../attempts/001/report.md).

Target: The initial state is accessible under the full successor relation: every possible successor execution terminates, without a fuel bound.

Precondition: exactly two `Vsingle` binary32 values; arbitrary initial CompCert memory. All IEEE values, including NaNs, infinities, subnormals and signed zero, are included. No numerical exclusions or environment condition is imposed. Typed arguments are a satisfiable calling-convention condition, independently defined in the no_error problem and reused by termination. The generated align model and obligations are unchanged.

Configuration: CompCert 3.17 Csem/Cexec, x86-64 Linux standard ABI, little endian, binary32 nearest ties to even; entry sum2; no source external callees. Spec version 1; exact hashes are in the attempt inputs.json. Remaining specification work: none for this problem. Problem construction costs are included once in the shared safety/termination skill-session record at ../../support/evidence/shared-costs.json.
