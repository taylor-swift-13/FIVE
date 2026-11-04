# Paparazzi construction costs

This report covers the five recorded align windows for the 570-entry Paparazzi collection. The four independent original cases have their own historical records.

| Align window | Completed entries | Input tokens | Output tokens | Wall seconds | Recorded tool CPU seconds | Observed peak MiB |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| `20261103T135838-d67130d489` | 45 | 4,421,175 | 23,508 | 1186.62 | 550.15 | 1386.4 |
| `20261103T142645-a9b6ea29fc` | 229 | 5,369,523 | 16,382 | 1162.98 | 1035.28 | 1387.2 |
| `20261103T144950-76bfe2a685` | 77 | 3,141,155 | 16,452 | 890.88 | 546.44 | 1386.6 |
| `20261104T015710-dafaaf8a7a` | 81 | 11,225,885 | 23,657 | 1056.68 | 896.94 | 1386.1 |
| `20261104T025249-007137ea5d` | 138 | 29,002,884 | 50,087 | 1531.07 | 460.79 | 1385.0 |

Across the recorded windows, the event-ID union contains **53,160,622 input tokens and 130,086 output tokens**, including 52,734,208 cached input tokens. The sum of directly measured stage wall times is **5828.23 s**. Recorded tool CPU is at least **3489.60 s** and the largest observed process-tree peak is **1387.2 MiB**.

Dividing these window totals by 570 completed entries gives **93492.47 tokens**, **10.22 wall seconds**, and at least **6.12 recorded tool CPU seconds** per entry. These are amortized batch averages, not individual case measurements. The current window includes case packaging and time spent handling user feedback; the sum is not continuous end-to-end elapsed time. Peak memory is not additive and is not divided by the number of cases.

The stage aggregation initially omitted 87 independently recorded provenance-audit runs. The first four historical reports omitted 83, and four current-stage audit runs were incorporated before the current stage closed. The table adds their recorded CPU and sampled peaks once. Stage wall times already include those runs. Some read-only and authoring shell commands were not wrapped by the tool meter, so total tool CPU and memory coverage is partial and cannot be reconstructed exactly.

Each case has its own `report/costs.json`. Historical case-level model token and wall-time values are null because no independent event boundaries were captured. Individually timed goal-generation commands are included where available, and shared export/typechecking costs remain in [groups.json](reports/costs/groups.json).

[Machine-readable totals](reports/costs/summary.json) · [Recovered audit commands](reports/costs/audit-supplement.json) · [Earlier stage evidence](reports/cost-evidence.tar.gz) · [Supplementary stage and audit evidence](reports/costs/supplementary-evidence.tar.gz)
