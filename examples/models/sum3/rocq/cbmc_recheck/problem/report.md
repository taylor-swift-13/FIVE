# Original sum3 CBMC recheck problem

`Spec.v` preserves `ResultBitsGoal` and defines the complete `HarnessPrefix`, `MemcpySafety`, `ByteObservation` and `FullHarnessGoal`. The exact original ten property IDs and locations are retained by `align/spec-map.json` and `rocq/spec-recheck.json`. The original harness is unchanged: arbitrary first call, concrete second call, actual four-byte memcpy and uint32 equality.

Attempt 001 proves returned-value bits only and is historical incomplete evidence. Attempt 002 proves the full byte observation and independent exact builtin-guard implications, permission checks and assertion theorem; its report identifies the scoped harness adapter and trusted semantics. No numerical domain restriction is imposed.
