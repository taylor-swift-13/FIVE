# Reports and costs

`manifest.json` lists each stage's actual inputs, outputs, hashes, status and limitations. `report.md` summarizes the substantive results. `costs.json` records the five stage entries and points to the raw evidence under `evidence/`. `historical-costs.json`, `historical-manifest.json` and `theorem.txt` preserve earlier records without relabelling them as new results.

Each measured run includes wall time, tool CPU time, sampled tool-process RSS and available usage receipts. Token totals are marked partial or null when the session window includes unrelated work or omits earlier work; they are not estimated. The original CBMC JSON, native output, Rocq compilation/assumptions, and separate kernel-check command are retained in the evidence directories. Verify orchestration itself was not independently timed and is reported as partial.
