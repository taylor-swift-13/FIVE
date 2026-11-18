# Low-pass recovery relation

Completed: actual `update_first_order_low_pass_tau(tau,h)` then actual `reset_first_order_low_pass(value)` has the same final12 object bytes as actual `init_first_order_low_pass(tau,h,value)`, from independent writable objects whose old contents may differ or be uninitialized. No update cycles are included.

The target is pinned CompCert3.17 Csem/Cexec on x86-64 Linux, little endian, binary32 nearest-even with its fixed NaN policy. All typed float32 patterns are allowed, including NaN, infinity and zero sampling time. The natural memory condition is an aligned nonwrapping writable12-byte region; the generated models themselves accept every raw argument list and memory.

The canonical question proves both workflows have a normal completion, every permitted normal result has exact `(time_const,last_in,last_out)` representation `(2.0f*tau/h,value,value)` in source operation order, and all original valid memory blocks outside the object retain bytes. Reset returns the exact input value bits; init returns void, so their returns are not compared. A real distinct-block allocation witness establishes nonvacuity.

- [Canonical question](problem/Spec.v) and [scope](problem/report.md)
- [Current solution](attempts/001/Proof.v), [independent checker](attempts/001/check.py), [report](attempts/001/report.md) and [recorded costs](attempts/001/costs.json)
- [Init model](../../models/init_first_order_low_pass/README.md), [retune model](../../models/update_first_order_low_pass_tau/README.md), [reset model](../../models/reset_first_order_low_pass/README.md)

The final traditional CBMC scope covers all safety/copy/frame/return assertions. Coefficient arithmetic is separately proved over the unrestricted typed-input CompCert domain in Rocq. Earlier arithmetic CBMC timeouts and all evidence-packaging failures remain visible history; they are not reported as arithmetic CBMC successes.
