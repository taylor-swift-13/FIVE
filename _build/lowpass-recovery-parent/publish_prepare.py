from pathlib import Path
import json,hashlib,shutil,os
R=Path("/home/yangfp/five");t=json.loads((R/"_build/lowpass-recovery-parent/task.json").read_text())
names=["init_first_order_low_pass","reset_first_order_low_pass","update_first_order_low_pass_tau"]
runs=sorted((R/"_build/lowpass-recovery-work").glob("*/five-prepare"))+[Path(t["prepare_finalization_run"]),Path(t["prepare_freeze_run"])]
dest=R/"paparazzi/report/lowpass_recovery/prepare";dest.mkdir(parents=True,exist_ok=True)
def write(p,d):p.parent.mkdir(parents=True,exist_ok=True);p.write_text(json.dumps(d,indent=2)+chr(10))
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
records=[];events={}
for run in runs:
 raw=json.loads((run/"run.json").read_text());m=json.loads((run/"metrics.json").read_text())
 assert raw["status"]!="running"
 target=dest/"evidence"/run.parent.name;shutil.copytree(run,target/"raw",dirs_exist_ok=False)
 session=Path(raw["codex_usage_boundary"]["session_file"])
 context=None;sid=None
 for line in session.read_text().splitlines():
  row=json.loads(line);payload=row.get("payload",{})
  if row.get("type")=="session_meta" and sid is None:sid=payload["id"]
  if row.get("type")=="turn_context":context=payload
 assert context["model"]=="gpt-6.1-sol" and context["effort"]=="medium"
 runtime={"model":context["model"],"actual_reasoning_effort":context["effort"],"requested_reasoning_effort":"medium","session_id":sid,"source_session":str(session),"source":"Observed actual turn_context model/effort; no conversation content exported"}
 write(target/"runtime-config.json",runtime);write(target/"cost-audit.json",raw["cost_audit"])
 for event in raw["tokens"].get("events",[]):events[event["event_id"]]=event
 rel=lambda p:str(p.relative_to(dest))
 row={"stage":"five-prepare","run":rel(target/"raw"),"status":"recorded","shared_batch_id":"lowpass_recovery_prepare","shared_cases":names,"measurement_scope":"Actual shared three-case preparation batch receipt; references from each case denote the same work and must be counted once. Original receipt and failures are immutable.","agent":{"model":"gpt-6.1-sol","requested_reasoning_effort":"medium","actual_reasoning_effort":"medium","session_id":sid,"evidence":rel(target/"runtime-config.json")},"time":{"wall_seconds":m["time"]["wall_seconds"],"tool_cpu_seconds":m["time"]["cpu_tool_seconds"]},"token":{"input":m["tokens"]["input_tokens"],"output":m["tokens"]["output_tokens"],"total":m["tokens"]["total_tokens"],"cached_input":m["tokens"]["cached_input_tokens"],"reasoning_output":m["tokens"]["reasoning_output_tokens"]},"memory":{"tool_peak_rss_bytes":m["memory"]["peak_process_tree_rss_sampled_bytes"],"tool_max_individual_process_rss_bytes":m["memory"]["max_individual_process_rss_bytes"]},"evidence":[rel(target/"raw/run.json"),rel(target/"raw/metrics.json"),rel(target/"cost-audit.json"),rel(target/"runtime-config.json")],"cost_audit_status":raw["cost_audit"]["status"],"cost_audit_issues":raw["cost_audit"]["issues"]}
 if str(run)==t["prepare_finalization_run"]:
  row["metadata_correction"]="Initial invocation_kind defaulted to tool-workflow although actual model analysis and authoring followed a measured session boundary; original receipt remains unchanged. Final freeze uses explicit skill-session. Reset syntax process completed too briefly for a sampled per-command RSS peak; observed batch peak is retained."
 records.append(row)
shared={"schema":"five-stage-costs/1","records":records,"accounting":"One shared prepare batch, referenced by all three cases; do not add the same records three times.","unique_token_total":sum(e["input_tokens"]+e["output_tokens"] for e in events.values()),"memory_scope":"Observed tool process RSS; sampled peaks may miss short processes and exclude model-serving memory."}
write(dest/"costs.json",shared)
for name in names:
 c=R/"paparazzi/models"/name;p=c/"prepare";out=p/"report"
 rows=json.loads(json.dumps(records))
 for row in rows:
  row["run"]=os.path.relpath(dest/row["run"],out)
  row["evidence"]=[os.path.relpath(dest/q,out) for q in row["evidence"]]
  row["agent"]["evidence"]=os.path.relpath(dest/row["agent"]["evidence"],out)
  row["shared_costs"]=os.path.relpath(dest/"costs.json",out)
 write(out/"costs.json",{"schema":"five-stage-costs/1","records":rows,"accounting":shared["accounting"]})
 b=json.loads((p/"source/bindings.json").read_text())
 outputs=[]
 for f in sorted(p.rglob("*")):
  if f.is_file() and f.name!="handoff.json":outputs.append({"path":str(f.relative_to(c)),"sha256":sha(f)})
 write(p/"handoff.json",{"schema":"five-stage-handoff/1","case_id":name,"stage":"five-prepare","status":"passed","entry":name,"entry_file":"prepare/source/"+name+".c","signature":b["signature"],"target":b["target"],"dependency_closure":{"callees":[],"external_calls":[],"types":["FirstOrderLowPass"],"globals":[]},"outputs":outputs,"current_preparation":os.path.relpath(dest/"evidence"/Path(t["prepare_freeze_run"]).parent.name/"raw",c),"source_correspondence":b["source_correspondence"]})
print(json.dumps({"prepare_handoffs":"passed","cases":names,"shared_token_total":shared["unique_token_total"],"receipts":len(records)},indent=2))
