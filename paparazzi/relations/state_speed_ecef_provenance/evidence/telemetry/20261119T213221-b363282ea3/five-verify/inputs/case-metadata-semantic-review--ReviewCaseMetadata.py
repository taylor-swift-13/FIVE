from pathlib import Path
import hashlib,json,sys,collections
read=lambda p:json.loads(Path(p).read_text())
sha=lambda p:hashlib.sha256(Path(p).read_bytes()).hexdigest()
root=Path("paparazzi/relations/state_speed_ecef_provenance")
receipt=root/"evidence/cold-checks/20261119T211947849575/source-bound-kernel-evidence.json"
theorems=set(read(receipt)["theorems"])
bindings={}
for c in ["stateSetSpeedNed_i","stateSetSpeedEcef_i","stateGetSpeedEcef_f"]:
 for prob in ["no_error","termination","execution_correspondence","cbmc_recheck"]:
  for b in read(Path("paparazzi/models")/c/"rocq"/prob/"attempts/001/evidence/goal-validation.json")["goal_bindings"]:
   bindings[b["theorem"]]=b["type"]
seen=set();counts=collections.Counter();cases=[];exec_count=0
for name,n in [("stateSetSpeedNed_i",32),("stateSetSpeedEcef_i",32),("stateGetSpeedEcef_f",276)]:
 case=Path("paparazzi/models")/name
 raw=read(case/"cbmc/properties.json")["properties"]
 ledger_path=case/"rocq/spec-recheck.json";ledger=read(ledger_path)
 ps=ledger["properties"]
 assert len(raw)==len(ps)==n
 assert [p["id"] for p in raw]==[p["property_id"] for p in ps]
 for p,l in zip(raw,ps):
  assert l["cbmc_status"]==p["status"]
  assert l["scope"]["source_location"]==p["source_location"]
  assert l["scope"]["description"]==p["description"]
  assert l["case_qualified_id"]==name+":"+p["id"]
  assert l["case_qualified_id"] not in seen;seen.add(l["case_qualified_id"])
  expected="proved" if p["status"]=="SUCCESS" else "refuted"
  assert l["status"]==l["proof_status"]==expected
  assert l["theorem"] in theorems
  assert bindings[l["theorem"]]==l["goal_type"]
  assert l["evidence"]==[str(receipt)]
  assert l["scope"]["model_domain_restrictions"]==[]
  assert sha(l["scope"]["harness"])==l["scope"]["harness_sha256"]
  if expected=="refuted":
   assert name=="stateGetSpeedEcef_f" and p["id"] in ["main.assertion.8","main.assertion.9","main.assertion.10"]
   assert Path(l["counterexample_replay"]).is_file()
  counts[expected]+=1
 assert ledger["gaps"]==[]
 contract_path=case/"rocq/execution_correspondence/attempts/001/evidence/execution-contract.json"
 contract=read(contract_path)
 assert contract["status"]=="proved" and contract["domain_restrictions"]==[]
 assert contract["execution_domain"]=={"arguments":"all raw machine values","memory":"all CompCert memories","execution_filtering":False}
 assert len(contract["obligations"])==8
 for ob in contract["obligations"]:
  assert ob["status"]=="proved" and ob["theorem"] in theorems
  assert bindings[ob["theorem"]]==ob["goal_type"]
  assert ob["evidence"]==[str(receipt)]
  exec_count+=1
 handoff=read(case/"rocq/handoff.json")
 roles=[v for v in handoff["outputs"] if v["role"]=="execution-contract"]
 assert len(roles)==1 and roles[0]["path"]==str(contract_path.relative_to(case))
 assert roles[0]["sha256"]==sha(contract_path)
 cases.append({"case":name,"properties":n,"ledger_sha256":sha(ledger_path),"contract_sha256":sha(contract_path)})
assert len(seen)==340 and counts=={"proved":337,"refuted":3} and exec_count==24
out={"status":"passed","case_property_counts":cases,"mapped_original_IDs":len(seen),"proof_status_counts":dict(counts),"unrestricted_execution_obligations":exec_count,"source_bound_kernel":str(receipt),"scope":"Read-only semantic mapping review; human report polishing and final report/cost handoff hash refresh remain parent-owned"}
Path(sys.argv[1]).write_text(json.dumps(out,indent=2))
print(json.dumps(out,indent=2))
