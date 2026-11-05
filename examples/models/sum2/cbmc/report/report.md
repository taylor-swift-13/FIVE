Traditional CBMC 6.11.0 passed all 1 emitted properties (main.assertion.1). Unrestricted nondeterministic binary32 first call, concrete ties-to-even second call. No loops, pointers or byte observation; no automatic memory IDs emitted. No universal NaN payload equivalence claimed.

Observed costs: wall 141.825563 s; tool CPU 0.03 s; input/output/total tokens 473849/3649/477498; cached input 454528; reasoning output 681; sampled tool peak RSS 19595264 bytes. Cost audit complete.

Supplemental canonical evidence run 20261105T131753-bb98ff0621: wall 60.713344 s; tool CPU 0.03 s; tokens input/output/total 413094/1623/414717; sampled tool RSS 20291584 bytes. Both initial and supplemental cost audits complete; all records retained once.

The initial raw telemetry scope label mentioned a finite-input planning option. That option was superseded before the actual CBMC run; the frozen verification request, harness and every actual CBMC command have no finite-input assumptions.

One intermediate API-created tool-workflow run retained its failed cost audit classification unchanged. Automatic approval review rejected retroactive relabeling as potentially misleading provenance. A genuinely new CLI skill-session repeated the actual check with input snapshots and passed its cost audit; all three measured CBMC records are preserved once in costs.json.
