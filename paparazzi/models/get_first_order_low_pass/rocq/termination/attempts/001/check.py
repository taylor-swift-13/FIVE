#!/usr/bin/env python3
"""Compile exact dependency snapshots, assumptions, and independent kernel check."""
from pathlib import Path
import argparse, hashlib, json, re, shutil, subprocess, sys, tempfile
attempt=Path(__file__).resolve().parent
root=attempt.parents[6]
case=attempt.parents[3]
problem=attempt.parents[1]
def digest(p): return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def dump(p,o): p.parent.mkdir(parents=True,exist_ok=True);p.write_text(json.dumps(o,indent=2)+chr(10))
mappings={'FiveLowpassGet':root/'paparazzi/models/get_first_order_low_pass/align/model','FiveLowpassGetCase':root/'paparazzi/models/get_first_order_low_pass/rocq/support','FiveLowpassReset':root/'paparazzi/models/reset_first_order_low_pass/align/model','FiveLowpassResetCase':root/'paparazzi/models/reset_first_order_low_pass/rocq/support','FiveGuidanceSemantics':root/'paparazzi/relations/guidance_mode/support/semantics','FiveShared':root/'shared','FiveLowpassSupport':root/'paparazzi/relations/lowpass_recovery/support','FiveGuidanceAllOrder':root/'paparazzi/relations/guidance_mode/support/allorder','FiveGuidanceAllocation':root/'paparazzi/relations/guidance_mode/support/allocation','FiveGuidanceEntry':root/'paparazzi/relations/guidance_mode/support/entry','FiveGuidanceCbmcAdapters':root/'paparazzi/relations/guidance_mode/support/cbmc_adapters','FiveLowpassGetNoError':root/'paparazzi/models/get_first_order_low_pass/rocq/no_error/problem','FiveLowpassGetTermination':root/'paparazzi/models/get_first_order_low_pass/rocq/termination/problem','FiveLowpassGetFunctional':root/'paparazzi/models/get_first_order_low_pass/rocq/functional/problem','FiveLowpassGetExecutionCorrespondence':root/'paparazzi/models/get_first_order_low_pass/rocq/execution_correspondence/problem','FiveLowpassGetRecheck':root/'paparazzi/models/get_first_order_low_pass/rocq/cbmc_recheck/problem','FiveLowpassResetFunctional':root/'paparazzi/models/reset_first_order_low_pass/rocq/functional/problem','FiveLowpassReadback':root/'paparazzi/relations/lowpass_readback/problem'}
special={'FiveLowpassGetNoError.Spec':root/'paparazzi/models/get_first_order_low_pass/rocq/no_error/problem/Spec.v','FiveLowpassGetNoError.Proof':root/'paparazzi/models/get_first_order_low_pass/rocq/no_error/attempts/001/Proof.v','FiveLowpassGetTermination.Spec':root/'paparazzi/models/get_first_order_low_pass/rocq/termination/problem/Spec.v','FiveLowpassGetTermination.Proof':root/'paparazzi/models/get_first_order_low_pass/rocq/termination/attempts/001/Proof.v','FiveLowpassGetFunctional.Spec':root/'paparazzi/models/get_first_order_low_pass/rocq/functional/problem/Spec.v','FiveLowpassGetFunctional.Proof':root/'paparazzi/models/get_first_order_low_pass/rocq/functional/attempts/001/Proof.v','FiveLowpassGetExecutionCorrespondence.Spec':root/'paparazzi/models/get_first_order_low_pass/rocq/execution_correspondence/problem/Spec.v','FiveLowpassGetExecutionCorrespondence.Proof':root/'paparazzi/models/get_first_order_low_pass/rocq/execution_correspondence/attempts/001/Proof.v','FiveLowpassGetExecutionCorrespondence.Closure':root/'paparazzi/models/get_first_order_low_pass/rocq/execution_correspondence/problem/Closure.v','FiveLowpassGetRecheck.Spec':root/'paparazzi/models/get_first_order_low_pass/rocq/cbmc_recheck/problem/Spec.v','FiveLowpassGetRecheck.Proof':root/'paparazzi/models/get_first_order_low_pass/rocq/cbmc_recheck/attempts/001/Proof.v','FiveLowpassResetFunctional.Spec':root/'paparazzi/models/reset_first_order_low_pass/rocq/functional/problem/Spec.v','FiveLowpassResetFunctional.Proof':root/'paparazzi/models/reset_first_order_low_pass/rocq/functional/attempts/001/Proof.v','FiveLowpassReadback.Spec':root/'paparazzi/relations/lowpass_readback/problem/Spec.v','FiveLowpassReadback.Proof':root/'paparazzi/relations/lowpass_readback/attempts/001/Proof.v'}
def resolve(name):
 if name in special:return special[name]
 for ns,d in mappings.items():
  if name.startswith(ns+"."):return d.joinpath(*name[len(ns)+1:].split(".")).with_suffix(".v")
 return None
def imports(p):
 s=re.sub(r"\(\*.*?\*\)","",p.read_text(),flags=re.S)
 rows=[]
 for prefix,names in re.findall(r"From\s+([A-Za-z0-9_.]+)\s+Require\s+(?:Import\s+|Export\s+)?([A-Za-z0-9_.\s]+?)\.",s):
  rows += [prefix+"."+x for x in names.split()]
 s=re.sub(r"From\s+[A-Za-z0-9_.]+\s+Require\s+(?:Import\s+|Export\s+)?[A-Za-z0-9_.\s]+?\.","",s)
 for names in re.findall(r"Require\s+(?:Import\s+|Export\s+)?([A-Za-z0-9_.\s]+?)\.(?=\s|$)",s):rows+=names.split()
 return rows
order=[];seen=set()
def visit(name):
 p=resolve(name)
 if p is None:return
 if name in seen:return
 seen.add(name)
 if not p.is_file():raise FileNotFoundError(str(p))
 for n in imports(p):visit(n)
 order.append((name,p))

def audit_input_copies(run):
 rows=run.read("inputs/manifest.json");paths={}
 for row in rows:
  path=(run.folder/row["path"]).resolve()
  if not path.is_relative_to(run.folder):raise RuntimeError("Input copy escapes run")
  if not path.is_file()or digest(path)!=row.get("sha256"):raise RuntimeError("Input copy SHA mismatch: "+str(path))
  if str(path)in paths and paths[str(path)]!=row["sha256"]:raise RuntimeError("Input copy path reused with different SHA")
  paths[str(path)]=row["sha256"]
 return len(rows)
def safe_capture(run,path,role,area="inputs"):
 source=Path(path).resolve();target=run.folder/area/(re.sub(r"[^A-Za-z0-9_.-]+","-",role)+"--"+source.name)
 audit_input_copies(run)
 if target.exists()and digest(target)!=digest(source):raise RuntimeError("Blocked input overwrite with different SHA: "+str(target))
 row=run.capture(source,role,area=area);audit_input_copies(run);return row

def main():
 parser=argparse.ArgumentParser();parser.add_argument("--record-run");parser.add_argument("--capture-preflight-run");args=parser.parse_args()
 provenance=attempt/"provenance.json"
 if provenance.exists():
  for row in json.loads(provenance.read_text())["files"]:
   if (root/row["path"]).suffix in (".v",".c") and digest(root/row["path"])!=row["sha256"]:raise RuntimeError("Changed proof input: "+row["path"])
 visit("FiveLowpassGetTermination.Proof")

 if args.capture_preflight_run:
  sys.path.insert(0,str(root/"scripts"));from five_telemetry import Run
  from example_proof_gate import certificate_source
  run=Run(args.capture_preflight_run)
  for name,p in order:safe_capture(run,p,"preflight-"+name,area="inputs")
  goals=[{"requested_goal":g,"theorem":"FiveLowpassGetTermination.Proof."+t,"type":"FiveLowpassGetTermination.Spec."+g}for g,t in zip(['AllSuccessorsTerminate'],['termination'])]
  cert=run.folder/"evidence/FiveLowpassGetTermination/GoalBinding.v";cert.parent.mkdir(parents=True,exist_ok=True);cert.write_text(certificate_source(["FiveLowpassGetTermination.Spec","FiveLowpassGetTermination.Proof"],goals))
  safe_capture(run,cert,"preflight-FiveLowpassGetTermination.GoalBinding",area="inputs")
  print(json.dumps({"preflight":"passed","module":"FiveLowpassGetTermination","manifest_rows":audit_input_copies(run)}));return

 if args.record_run:
  sys.path.insert(0,str(root/"scripts"))
  from five_telemetry import Run
  run=Run(args.record_run);build=root/"paparazzi/report/lowpass_readback/evidence"/("checked-"+run.folder.parent.name)
  build.mkdir(parents=True,exist_ok=True)
  recorded(run,build)
 else:
  with tempfile.TemporaryDirectory(prefix="five-lowpass-readback-") as tmp:
   build=Path(tmp);compile_all(build,None)

def compile_all(build,run):
 flags=[];nsmap={}
 for ns in dict.fromkeys([*mappings,"FiveLowpassGetTermination"]):
  d=build/ns;d.mkdir(parents=True,exist_ok=True);nsmap[ns]=d;flags += ["-Q",str(d),ns]
 sources=[];bindings=[]
 for name,p in order:
  ns=next(n for n in nsmap if name.startswith(n+"."))
  dest=nsmap[ns].joinpath(*name[len(ns)+1:].split(".")).with_suffix(".v");dest.parent.mkdir(parents=True,exist_ok=True)
  if dest.exists() and digest(dest)!=digest(p):raise RuntimeError("Immutable shared snapshot differs: "+str(dest))
  if not dest.exists():shutil.copyfile(p,dest)
  sources.append(dest);bindings.append({"path":str(p.relative_to(root)),"sha256":digest(p),"snapshot":str(dest.relative_to(root)) if dest.is_relative_to(root) else None})
 def command(argv,label):
  if run:return run.command(argv,label,timeout=600,cwd=str(root))
  subprocess.run(argv,cwd=root,check=True);return None
 if run:
  for i,p in enumerate(sources):safe_capture(run,p,build.name+"-"+"FiveLowpassGetTermination-dependency-"+str(i)+"-"+p.name,area="inputs")
 for i,p in enumerate(sources):
  argv=["/home/yangfp/.opam/five/bin/rocq","compile",*flags,str(p)]
  earlier=run.read("commands.json") if run else []
  if run and p.with_suffix(".vo").exists() and any(x.get("argv")==argv and x.get("status")=="passed" and x.get("exit_code")==0 for x in earlier):continue
  command(argv,"FiveLowpassGetTermination-dependency-"+str(i))
 kernel=None if run else command(["/home/yangfp/.opam/five/bin/rocq","check","-silent",*flags,"FiveLowpassGetTermination.Proof"],"get_first_order_low_pass-independent-kernel")
 return flags,sources,bindings,kernel,command

def recorded(run,build):
 flags,sources,bindings,kernel,command=compile_all(build,run)
 names=['AllSuccessorsTerminate']
 lemmas=['termination']
 goals=[{"requested_goal":g,"theorem":"FiveLowpassGetTermination.Proof."+t,"type":"FiveLowpassGetTermination.Spec."+g} for g,t in zip(names,lemmas)]
 from example_proof_gate import certificate_source
 cert=build/"FiveLowpassGetTermination/GoalBinding.v";cert.write_text(certificate_source(["FiveLowpassGetTermination.Spec","FiveLowpassGetTermination.Proof"],goals));safe_capture(run,cert,build.name+"-"+"FiveLowpassGetTermination-goal-binding-certificate",area="inputs")
 comp=command(["/home/yangfp/.opam/five/bin/rocq","compile",*flags,str(cert)],"get_first_order_low_pass-goal-certificate")
 check=command(["/home/yangfp/.opam/five/bin/rocq","check","-silent",*flags,"FiveLowpassGetTermination.Proof","FiveLowpassGetTermination.GoalBinding"],"get_first_order_low_pass-certificate-kernel")
 kernel=check
 evidence=attempt/"evidence";runpath=str(run.folder.relative_to(root));deps={str(p.relative_to(root)):digest(p) for p in sources}
 receipt={"kind":"rocq-kernel-check","run":runpath,"command_id":kernel["id"],"theorems":[g["theorem"] for g in goals],"statement_artifacts":[str((build/"FiveLowpassGetTermination/Spec.v").relative_to(root)),str((build/"FiveLowpassGetTermination/Proof.v").relative_to(root))],"dependency_sha256":deps}
 dump(evidence/"kernel-evidence.json",receipt)
 original=case/"prepare/source/get_first_order_low_pass.c";safe_capture(run,original,build.name+"-"+"FiveLowpassGetTermination-raw-source",area="inputs")
 dump(evidence/"gate-kernel-evidence.json",{**receipt,"dependency_sha256":{**deps,str(original.relative_to(root)):digest(original)}})
 cr={**receipt,"command_id":check["id"],"theorems":["FiveLowpassGetTermination.GoalBinding.goal_"+str(i) for i in range(len(goals))],"statement_artifacts":[str(cert.relative_to(root))],"dependency_sha256":{**deps,str(cert.relative_to(root)):digest(cert)}}
 dump(evidence/"certificate-kernel-evidence.json",cr)
 indexed={row["path"]:row["sha256"] for row in bindings}
 for e in ("get_first_order_low_pass","reset_first_order_low_pass"):
  c=root/"paparazzi/models"/e
  for rel in ("prepare/source/"+e+".c","prepare/source/bindings.json","align/request.json","align/model/compcert-manifest.json","align/model/preprocessed.i"):
   p=c/rel;indexed[str(p.relative_to(root))]=digest(p)
 indexed[str((attempt/"check.py").relative_to(root))]=digest(attempt/"check.py")
 dump(attempt/"provenance.json",{"schema":"five-proof-attempt-provenance/1","files":[{"path":p,"sha256":h} for p,h in sorted(indexed.items())]})
 bound={x["path"]:x for x in bindings}
 for p,h in indexed.items():bound.setdefault(p,{"path":p,"sha256":h})
 validation={"schema":"five-proof-validation/1","index":{"path":str((attempt/"provenance.json").relative_to(root)),"sha256":digest(attempt/"provenance.json")},"inputs":list(bound.values()),"kernel_evidence":str((evidence/"kernel-evidence.json").relative_to(root)),"goal_bindings":goals,"certificate":{"path":str(cert.relative_to(root)),"sha256":digest(cert),"module":"FiveLowpassGetTermination.GoalBinding","imports":["FiveLowpassGetTermination.Spec","FiveLowpassGetTermination.Proof"],"run":runpath,"compile_command_id":comp["id"],"kernel_command_id":check["id"],"kernel_evidence":str((evidence/"certificate-kernel-evidence.json").relative_to(root))}}
 dump(evidence/"goal-validation.json",validation)
 print("All exact goals compiled, assumptions emitted, independently kernel checked.")
if __name__=="__main__":main()
