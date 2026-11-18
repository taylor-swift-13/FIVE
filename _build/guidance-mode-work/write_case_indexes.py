from pathlib import Path
R=Path('/home/yangfp/five')
for entry in ['gh_update_ref_from_speed_sp','gh_update_ref_from_accel_sp']:
 c=R/'paparazzi/models'/entry
 (c/'README.md').write_text(f'''# {entry}

This case verifies the extracted Paparazzi horizontal guidance entry with its real CompCert Csyntax/Csem/Cexec execution and the fixed common C `sqrtf` binding. [Preparation](prepare/report/report.md) records exact source extraction, target and binding scope. [CBMC](cbmc/report/report.md) records two nonzero scenarios with both saturation branches and every emitted property. [Alignment](align/report/report.md) records unrestricted execution models and the property map.

Canonical questions and immutable proof attempts are separate:

| Question | Specification | Active proof record |
|---|---|---|
| All reachable states are safe under the natural valid-input precondition | [no_error](rocq/no_error/problem/report.md) | [attempt](rocq/no_error/problem/status.json) |
| All successors terminate | [termination](rocq/termination/problem/report.md) | [attempt](rocq/termination/problem/status.json) |
| Normal completion exists and every return has the exact complete state update | [functional](rocq/functional/problem/report.md) | [attempt](rocq/functional/problem/status.json) |
| Every actual CBMC assertion and automatic guard is independently rechecked | [cbmc_recheck](rocq/cbmc_recheck/problem/report.md) | [attempt](rocq/cbmc_recheck/problem/status.json) |
| Eight execution-correspondence categories, including invalid states | [execution_correspondence](rocq/execution_correspondence/problem/report.md) | [attempt](rocq/execution_correspondence/problem/status.json) |

The execution model accepts every machine argument list and CompCert memory. Safety/functionality assume a typed writable64-byte GuidanceHRef object, the readable fixed maximum-acceleration global, a valid readable8-byte vector argument, successful source-ordered float-to-int64 position-step conversion, and nonoverflowing signed position addition. All other allowable float patterns remain in the Rocq domain, including NaNs where these preconditions hold. Signed addition wraps in CompCert Csem; the explicit no-overflow condition additionally gives the intended ISO-C/nonwrapping position meaning.

Observations preserve every named field bit, including signed zero and the pinned CompCert NaN policy; padding is not an extra named-state assertion. Actual memory execution and frame lemmas use typed loads and byte observations. Source-order operations are never algebraically reassociated.

The [guidance-mode relation](../../relations/guidance_mode/problem/report.md) compares this entry against the other route from the same logical old state in independent represented memories. Matching acceleration is the actual pre-saturation command computed after integration. The [aggregate report](../../report/guidance_mode/report.md) records all current goals, historical attempts and event-deduplicated costs. No native-libm/IEEE-accuracy equivalence or GCC/hardware equivalence is claimed.
''')
p=R/'paparazzi/README.md';s=p.read_text() if p.exists() else '# Paparazzi verification cases\n';link='[Horizontal guidance mode relation](relations/guidance_mode/problem/report.md)'
if link not in s:s+='\n## Horizontal guidance update verification\n\n'+link+' compares the speed-command and acceleration-command routes after source-ordered integration. The two [speed](models/gh_update_ref_from_speed_sp/README.md) and [acceleration](models/gh_update_ref_from_accel_sp/README.md) cases retain separate canonical questions and proof attempts. Scope, status and costs are in the [aggregate report](report/guidance_mode/report.md).\n'
p.write_text(s)
print('Created two case indexes and added one Paparazzi index link.')
