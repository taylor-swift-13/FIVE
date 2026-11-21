from pathlib import Path
import hashlib,json,sys

def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def read(p):return json.loads(Path(p).read_text())
base=Path("paparazzi/relations/state_speed_ecef_provenance")
cold=base/"evidence/cold-checks/20261119T211947849575"
k=read(cold/"source-bound-kernel-evidence.json")
for p,h in k["dependency_sha256"].items():assert sha(p)==h,p
for pair in k["canonical_to_compiled_snapshot"]:
 assert sha(pair["source"])==pair["sha256"]==sha(pair["snapshot"]),pair
attempts=[]
for name in ["stateSetSpeedNed_i","stateSetSpeedEcef_i","stateGetSpeedEcef_f"]:
 for problem in ["no_error","termination","execution_correspondence","cbmc_recheck"]:
  attempts.append(Path("paparazzi/models")/name/"rocq"/problem/"attempts/001")
attempts.append(Path("paparazzi/models/stateGetSpeedEcef_f/rocq/functional/attempts/001"))
attempts.append(base/"attempts/001")
allbindings=[];checked_inputs={}
for attempt in attempts:
 v=read(attempt/"evidence/goal-validation.json")
 for entry in v["inputs"]:
  p,h=entry["path"],entry["sha256"]
  assert sha(p)==h,p
  checked_inputs[p]=h
 cert=v["certificate"]
 assert sha(cert["path"])==cert["sha256"],cert["path"]
 assert Path(cert["kernel_evidence"]).is_file()
 index=v["index"]
 assert sha(index["path"])==index["sha256"],index["path"]
 status=read(attempt.parents[1]/"problem/status.json")
 assert set(status["requested_goals"])=={b["requested_goal"] for b in v["goal_bindings"]},str(attempt)
 assert all(s in ["proved","refuted"] for s in status["goal_status"].values()),status
 allbindings.extend(v["goal_bindings"])
assert len(attempts)==14
assert len(allbindings)==379
assert len({b["theorem"] for b in allbindings})==379
assert set(k["theorems"])=={b["theorem"] for b in allbindings}
summary={"status":"passed","canonical_source_snapshot_pairs":len(k["canonical_to_compiled_snapshot"]),"source_bound_dependencies":len(k["dependency_sha256"]),"canonical_attempts":len(attempts),"exact_goal_bindings":len(allbindings),"unique_validated_input_paths":len(checked_inputs),"scope":"Read-only source integrity and exact goal-publication review; uses existing actual independent kernel receipts"}
Path(sys.argv[1]).write_text(json.dumps(summary,indent=2)+"
")
print(json.dumps(summary,indent=2))
