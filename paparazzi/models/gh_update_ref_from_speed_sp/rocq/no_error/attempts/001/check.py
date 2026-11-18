#!/usr/bin/env python3
"""Compile exact dependency snapshots, assumptions, and independent kernel check."""
from pathlib import Path
import argparse, hashlib, json, re, shutil, subprocess, sys, tempfile
attempt=Path(__file__).resolve().parent
root=next(p for p in attempt.parents if(p/'scripts/five_telemetry.py').is_file())
relation=root/"paparazzi/relations/parameter_order"
case=attempt.parents[3]
problem=attempt.parents[1]
def digest(p): return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def dump(p,o): p.parent.mkdir(parents=True,exist_ok=True);p.write_text(json.dumps(o,indent=2)+chr(10))
mappings={'FivePaparazziState':root/'paparazzi/relations/parameter_order/support','FiveGhSpeed':root/'paparazzi/models/gh_update_ref_from_speed_sp/align/model','FiveGhAccel':root/'paparazzi/models/gh_update_ref_from_accel_sp/align/model','FiveGuidanceEntry':root/'paparazzi/relations/guidance_mode/support/entry','FiveGuidanceAllocation':root/'paparazzi/relations/guidance_mode/support/allocation','FiveGuidanceSemantics':root/'paparazzi/relations/guidance_mode/support/semantics','FiveGuidanceAllOrder':root/'paparazzi/relations/guidance_mode/support/allorder','FiveGuidanceSoftwareProof':root/'paparazzi/relations/guidance_mode/support/software','FiveGuidanceMode':root/'paparazzi/relations/guidance_mode/problem','FiveGuidanceRelationSupport':root/'paparazzi/relations/guidance_mode/support/relation','FiveShared':root/'shared'}
special={"FiveGhSpeedNoError.Spec":problem/"problem/Spec.v","FiveGhSpeedNoError.Proof":attempt/"Proof.v"}
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
def main():
 parser=argparse.ArgumentParser();parser.add_argument("--record-run");parser.add_argument("--reuse-checked");args=parser.parse_args()
 global reuse_checked
 reuse_checked=Path(args.reuse_checked)if args.reuse_checked else None
 provenance=attempt/"provenance.json"
 if provenance.exists():
  for row in json.loads(provenance.read_text())["files"]:
   if (root/row["path"]).suffix in (".v",".c") and digest(root/row["path"])!=row["sha256"]:raise RuntimeError("Changed proof input: "+row["path"])
 visit("FiveGhSpeedNoError.Proof")
 if args.record_run:
  sys.path.insert(0,str(root/"scripts"))
  from five_telemetry import Run
  run=Run(args.record_run);build=attempt/"evidence"/("checked-"+str(len(list((attempt/"evidence").glob("checked-*")))+1).zfill(3))
  if build.exists():raise RuntimeError("Immutable checked snapshot already exists")
  build.mkdir(parents=True)
  recorded(run,build)
 else:
  with tempfile.TemporaryDirectory(prefix="five-parameter-order-") as tmp:
   build=Path(tmp);compile_all(build,None)

def compile_all(build,run):
 flags=[];nsmap={}
 for ns in dict.fromkeys([*mappings,"FiveGhSpeedNoError"]):
  d=build/ns;d.mkdir(parents=True,exist_ok=True);nsmap[ns]=d;flags += ["-Q",str(d),ns]
 sources=[];bindings=[]
 for name,p in order:
  ns=next(n for n in nsmap if name.startswith(n+"."))
  dest=nsmap[ns].joinpath(*name[len(ns)+1:].split(".")).with_suffix(".v");dest.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(p,dest)
  sources.append(dest);bindings.append({"path":str(p.relative_to(root)),"sha256":digest(p),"snapshot":str(dest.relative_to(root)) if dest.is_relative_to(root) else None})
 def command(argv,label):
  if run:return run.command(argv,label,timeout=600,cwd=str(root))
  subprocess.run(argv,cwd=root,check=True);return None
 if run:
  for i,p in enumerate(sources):run.capture(p,"dependency-"+str(i),area="inputs")
 for i,p in enumerate(sources):
  old=reuse_checked/p.relative_to(build)if reuse_checked else None
  if old is not None and old.is_file()and old.read_bytes()==p.read_bytes()and old.with_suffix('.vo').is_file():
   shutil.copyfile(old.with_suffix('.vo'),p.with_suffix('.vo'))
  else:command(["/home/yangfp/.opam/five/bin/rocq","compile",*flags,str(p)],"relation-dependency-"+str(i))
 kernel=None if run else command(["/home/yangfp/.opam/five/bin/rocq","check","-silent",*flags,"FiveGhSpeedNoError.Proof"],"relation-independent-kernel")
 return flags,sources,bindings,kernel,command

def recorded(run,build):
 flags,sources,bindings,kernel,command=compile_all(build,run)
 names=['Goal']
 lemmas=['no_error']
 goals=[{"requested_goal":g,"theorem":"FiveGhSpeedNoError.Proof."+t,"type":"FiveGhSpeedNoError.Spec."+g} for g,t in zip(names,lemmas)]
 from example_proof_gate import certificate_source
 cert=build/"FiveGhSpeedNoError/GoalBinding.v";cert.write_text(certificate_source(["FiveGhSpeedNoError.Spec","FiveGhSpeedNoError.Proof"],goals));run.capture(cert,"goal-binding-certificate",area="inputs")
 comp=command(["/home/yangfp/.opam/five/bin/rocq","compile",*flags,str(cert)],"relation-goal-certificate")
 check=command(["/home/yangfp/.opam/five/bin/rocq","check","-silent",*flags,"FiveGhSpeedNoError.Proof","FiveGhSpeedNoError.GoalBinding"],"relation-certificate-kernel")
 kernel=check
 evidence=attempt/"evidence";runpath=str(run.folder.relative_to(root));deps={str(p.relative_to(root)):digest(p) for p in sources}
 receipt={"kind":"rocq-kernel-check","run":runpath,"command_id":kernel["id"],"theorems":[g["theorem"] for g in goals],"statement_artifacts":[str((build/"FiveGhSpeedNoError/Spec.v").relative_to(root)),str((build/"FiveGhSpeedNoError/Proof.v").relative_to(root))],"dependency_sha256":deps}
 dump(evidence/"kernel-evidence.json",receipt)
 cr={**receipt,"command_id":check["id"],"theorems":["FiveGhSpeedNoError.GoalBinding.goal_"+str(i) for i in range(len(goals))],"statement_artifacts":[str(cert.relative_to(root))],"dependency_sha256":{**deps,str(cert.relative_to(root)):digest(cert)}}
 dump(evidence/"certificate-kernel-evidence.json",cr)
 indexed={row["path"]:row["sha256"] for row in bindings}
 for e in ("gh_update_ref_from_speed_sp","gh_update_ref_from_accel_sp"):
  c=root/"paparazzi/models"/e
  for rel in ("prepare/source/"+e+".c","prepare/source/bindings.json","prepare/source/five_sqrtf.c","align/request.json","align/model/compcert-manifest.json","align/model/preprocessed.i"):
   p=c/rel;indexed[str(p.relative_to(root))]=digest(p)
 indexed[str((attempt/"check.py").relative_to(root))]=digest(attempt/"check.py")
 dump(attempt/"provenance.json",{"schema":"five-proof-attempt-provenance/1","files":[{"path":p,"sha256":h} for p,h in sorted(indexed.items())]})
 bound={x["path"]:x for x in bindings}
 for p,h in indexed.items():bound.setdefault(p,{"path":p,"sha256":h})
 validation={"schema":"five-proof-validation/1","index":{"path":str((attempt/"provenance.json").relative_to(root)),"sha256":digest(attempt/"provenance.json")},"inputs":list(bound.values()),"kernel_evidence":str((evidence/"kernel-evidence.json").relative_to(root)),"goal_bindings":goals,"certificate":{"path":str(cert.relative_to(root)),"sha256":digest(cert),"module":"FiveGhSpeedNoError.GoalBinding","imports":["FiveGhSpeedNoError.Spec","FiveGhSpeedNoError.Proof"],"run":runpath,"compile_command_id":comp["id"],"kernel_command_id":check["id"],"kernel_evidence":str((evidence/"certificate-kernel-evidence.json").relative_to(root))}}
 dump(evidence/"goal-validation.json",validation)
 print("All exact goals compiled, assumptions emitted, independently kernel checked.")
if __name__=="__main__":main()
