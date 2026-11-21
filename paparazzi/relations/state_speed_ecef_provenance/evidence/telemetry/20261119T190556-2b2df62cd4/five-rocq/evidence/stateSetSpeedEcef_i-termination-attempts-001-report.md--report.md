All-successor termination.

All raw argument lists and all CompCert memories satisfy Acc for the reverse successor relation of original Csem.step at the original entry. The source is loop-free and call-free; expression/statement ranks strictly decrease on every successor. This is independent of the legitimate accepted-call safety precondition.

Development compilation used direct Rocq argv under a 3GiB inherited address-space cap. Print Assumptions exposes only inherited CompCert/Flocq, classical and extensionality declarations; the source has no external calls. The final shared checker snapshots the current dependency closure, recompiles it cold, binds every requested theorem to its exact type, and independently kernel checks proof and certificate.

All actual authoring retries remain in shared run20261119T190556-2b2df62cd4. Command059 had an accidental concurrent-writer collision: surviving raw logs and the full incident are preserved, and missing historical CPU/peak metrics remain unknown. No per-problem token allocation is invented. See costs.json and the shared raw run.
