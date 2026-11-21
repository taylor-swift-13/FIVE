#!/usr/bin/env python3
from pathlib import Path
import argparse,hashlib,importlib.util,json,sys,tempfile
ATTEMPT=Path(__file__).resolve().parent
ROOT=ATTEMPT.parents[4]
CASE=ROOT/"paparazzi/models/update_pid_df"
NS="FivePidDfRoundoff"
NAMES=["ExactArithmetic","CoefficientPerturbation","NumericInvariant","LocalRoundoff","ArbitraryHorizon","OriginalInitCoefficients","ExecutionExists","EveryExecution","Nonvacuity"]
LEMMAS=["exact_arithmetic","coefficient_deviation","numeric_invariant","local_roundoff","arbitrary_horizon","original_init_coefficients","execution_exists","every_execution","nonvacuity"]
def digest(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def dump(p,o):p.parent.mkdir(parents=True,exist_ok=True);p.write_text(json.dumps(o,ensure_ascii=False,indent=2)+chr(10))
def driver():
 spec=importlib.util.spec_from_file_location("pid_build",CASE/"rocq/support/build.py")
 mod=importlib.util.module_from_spec(spec);spec.loader.exec_module(mod)
 mod.MAPPINGS.update({"FiveLowpassRoundoffSupport":"paparazzi/relations/lowpass_roundoff_bound/support",
 "FivePidDfRoundoffSupport":"paparazzi/relations/pid_df_positional_roundoff/support",
 NS:"paparazzi/relations/pid_df_positional_roundoff/problem"})
 old=mod.resolve
 def resolve(name):
  if name==NS+".Proof":return ATTEMPT/"Proof.v"
  return old(name)
 mod.resolve=resolve
 return mod
def main():
 parser=argparse.ArgumentParser();parser.add_argument("--record-run");parser.add_argument("--build");a=parser.parse_args()
 mod=driver()
 if not a.record_run:
  with tempfile.TemporaryDirectory(prefix="five-pid-df-roundoff-")as tmp:
   flags,src,bindings,command=mod.compile_target(NS+".Proof",None,Path(tmp))
   command(["/home/yangfp/.opam/five/bin/rocq","check","-silent",*flags,NS+".Proof"],"independent-kernel")
  return
 sys.path.insert(0,str(ROOT/"scripts"));from five_telemetry import Run
 from example_proof_gate import certificate_source
 run=Run(a.record_run)
 build=Path(a.build).resolve()if a.build else ROOT/"_build/pid-df-numeric"/("checked-"+run.folder.parent.name)
 order=mod.closure(NS+".Proof")
 for i,(n,p)in enumerate(order):run.capture(p,build.name+"-source-"+str(i),area="inputs")
 flags,sources,bindings,command=mod.compile_target(NS+".Proof",run,build)
 for i,p in enumerate(sources):run.capture(p,build.name+"-snapshot-"+str(i),area="inputs")
 goals=[{"requested_goal":g,"theorem":NS+".Proof."+t,"type":NS+".Spec."+g}for g,t in zip(NAMES,LEMMAS)]
 cert=build/NS/"GoalBinding.v";cert.write_text(certificate_source([NS+".Spec",NS+".Proof"],goals))
 run.capture(cert,build.name+"-goal-certificate",area="inputs")
 comp=command(["/home/yangfp/.opam/five/bin/rocq","compile",*flags,str(cert)],"pid-roundoff-goal-certificate")
 kernel=command(["/home/yangfp/.opam/five/bin/rocq","check","-silent",*flags,NS+".Proof",NS+".GoalBinding"],"pid-roundoff-independent-kernel")
 evidence=ATTEMPT/"evidence";rp=str(run.folder.relative_to(ROOT))
 deps={str(p.relative_to(ROOT)):digest(p)for p in sources}
 receipt={"kind":"rocq-kernel-check","run":rp,"command_id":kernel["id"],"theorems":[g["theorem"]for g in goals],"statement_artifacts":[str((build/NS/"Spec.v").relative_to(ROOT)),str((build/NS/"Proof.v").relative_to(ROOT))],"dependency_sha256":deps}
 dump(evidence/"kernel-evidence.json",receipt)
 cr={**receipt,"theorems":[NS+".GoalBinding.goal_"+str(i)for i in range(len(goals))],"statement_artifacts":[str(cert.relative_to(ROOT))],"dependency_sha256":{**deps,str(cert.relative_to(ROOT)):digest(cert)}}
 dump(evidence/"certificate-kernel-evidence.json",cr)
 indexed={x["path"]:x["sha256"]for x in bindings}
 for rel in ("prepare/source/update_pid_df.c","prepare/source/bindings.json","align/request.json","align/model/compcert-manifest.json","align/model/preprocessed.i","cbmc/harness.c","cbmc/properties.json","align/spec-map.json"):
  p=CASE/rel;indexed[str(p.relative_to(ROOT))]=digest(p);run.capture(p,build.name+"-"+rel.replace("/","-"),area="inputs")
 indexed[str((ATTEMPT/"check.py").relative_to(ROOT))]=digest(ATTEMPT/"check.py")
 dump(ATTEMPT/"provenance.json",{"schema":"five-proof-attempt-provenance/1","files":[{"path":p,"sha256":h}for p,h in sorted(indexed.items())]})
 bound={x["path"]:x for x in bindings}
 for p,h in indexed.items():bound.setdefault(p,{"path":p,"sha256":h})
 validation={"schema":"five-proof-validation/1","index":{"path":str((ATTEMPT/"provenance.json").relative_to(ROOT)),"sha256":digest(ATTEMPT/"provenance.json")},"inputs":list(bound.values()),"kernel_evidence":str((evidence/"kernel-evidence.json").relative_to(ROOT)),"goal_bindings":goals,"certificate":{"path":str(cert.relative_to(ROOT)),"sha256":digest(cert),"module":NS+".GoalBinding","imports":[NS+".Spec",NS+".Proof"],"run":rp,"compile_command_id":comp["id"],"kernel_command_id":kernel["id"],"kernel_evidence":str((evidence/"certificate-kernel-evidence.json").relative_to(ROOT))}}
 dump(evidence/"goal-validation.json",validation)
 print(json.dumps({"status":"proved","goals":len(goals),"sources":len(sources),"kernel_command":kernel["id"],"build":str(build)}))
if __name__=="__main__":main()
