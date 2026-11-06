#!/usr/bin/env python3
"""Compile exact dependency snapshots, assumptions, and independent kernel check."""
from pathlib import Path
import argparse, hashlib, json, re, shutil, subprocess, sys, tempfile
attempt=Path(__file__).resolve().parent
root=attempt.parents[4]
relation=attempt.parents[1]
def digest(p): return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def dump(p,o): p.parent.mkdir(parents=True,exist_ok=True);p.write_text(json.dumps(o,indent=2)+chr(10))
mappings={
 "FiveGhSetOmega":root/"paparazzi/models/gh_set_omega/align/model",
 "FiveGhSetOmegaProof":root/"paparazzi/models/gh_set_omega/rocq/support",
 "FiveGhSetZeta":root/"paparazzi/models/gh_set_zeta/align/model",
 "FiveGhSetZetaProof":root/"paparazzi/models/gh_set_zeta/rocq/support",
 "FiveShared":root/"shared", "FivePaparazziState":relation/"support"}
special={"FiveParameterOrder.Spec":relation/"problem/Spec.v","FiveParameterOrder.Proof":attempt/"Proof.v"}
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
 parser=argparse.ArgumentParser();parser.add_argument("--record-run");args=parser.parse_args()
 provenance=attempt/"provenance.json"
 if provenance.exists():
  validation=attempt/"evidence/goal-validation.json"
  current={r["path"]:r["sha256"] for r in json.loads(validation.read_text())["inputs"]} if validation.exists() else {}
  for row in json.loads(provenance.read_text())["files"]:
   expected=row["sha256"] if Path(row["path"]).suffix in (".v",".c") else current.get(row["path"],row["sha256"])
   if digest(root/row["path"])!=expected:raise RuntimeError("Changed proof input: "+row["path"])
 visit("FiveParameterOrder.Proof")
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
 for ns in [*mappings,"FiveParameterOrder"]:
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
 for i,p in enumerate(sources):command(["rocq","compile",*flags,str(p)],"relation-dependency-"+str(i))
 kernel=command(["rocq","check","-silent",*flags,"FiveParameterOrder.Proof"],"relation-independent-kernel")
 return flags,sources,bindings,kernel,command

def recorded(run,build):
 flags,sources,bindings,kernel,command=compile_all(build,run)
 names=["NormalCompletion","AllFinalStateFormula","AllFinalNamedBits","SatisfiableInitial"]
 lemmas=["normal_completion","all_final_state_formula","all_final_named_bits","satisfiable_initial"]
 goals=[{"requested_goal":g,"theorem":"FiveParameterOrder.Proof."+t,"type":"FiveParameterOrder.Spec."+g} for g,t in zip(names,lemmas)]
 from example_proof_gate import certificate_source
 cert=build/"FiveParameterOrder/GoalBinding.v";cert.write_text(certificate_source(["FiveParameterOrder.Spec","FiveParameterOrder.Proof"],goals));run.capture(cert,"goal-binding-certificate",area="inputs")
 comp=command(["rocq","compile",*flags,str(cert)],"relation-goal-certificate")
 check=command(["rocq","check","-silent",*flags,"FiveParameterOrder.GoalBinding"],"relation-certificate-kernel")
 evidence=attempt/"evidence";runpath=str(run.folder.relative_to(root));deps={str(p.relative_to(root)):digest(p) for p in sources}
 receipt={"kind":"rocq-kernel-check","run":runpath,"command_id":kernel["id"],"theorems":[g["theorem"] for g in goals],"statement_artifacts":[str((build/"FiveParameterOrder/Spec.v").relative_to(root)),str((build/"FiveParameterOrder/Proof.v").relative_to(root))],"dependency_sha256":deps}
 dump(evidence/"kernel-evidence.json",receipt)
 cr={**receipt,"command_id":check["id"],"theorems":["FiveParameterOrder.GoalBinding.goal_"+str(i) for i in range(len(goals))],"statement_artifacts":[str(cert.relative_to(root))],"dependency_sha256":{**deps,str(cert.relative_to(root)):digest(cert)}}
 dump(evidence/"certificate-kernel-evidence.json",cr)
 indexed={row["path"]:row["sha256"] for row in bindings}
 for e in ("gh_set_omega","gh_set_zeta"):
  c=root/"paparazzi/models"/e
  for rel in ("prepare/source/"+e+".c","prepare/source/bindings.json","align/handoff.json","align/model/compcert-manifest.json","align/model/preprocessed.i"):
   p=c/rel;indexed[str(p.relative_to(root))]=digest(p)
 indexed[str((attempt/"check.py").relative_to(root))]=digest(attempt/"check.py")
 dump(attempt/"provenance.json",{"schema":"five-proof-attempt-provenance/1","files":[{"path":p,"sha256":h} for p,h in sorted(indexed.items())]})
 bound={x["path"]:x for x in bindings}
 for p,h in indexed.items():bound.setdefault(p,{"path":p,"sha256":h})
 validation={"schema":"five-proof-validation/1","index":{"path":str((attempt/"provenance.json").relative_to(root)),"sha256":digest(attempt/"provenance.json")},"inputs":list(bound.values()),"kernel_evidence":str((evidence/"kernel-evidence.json").relative_to(root)),"goal_bindings":goals,"certificate":{"path":str(cert.relative_to(root)),"sha256":digest(cert),"module":"FiveParameterOrder.GoalBinding","imports":["FiveParameterOrder.Spec","FiveParameterOrder.Proof"],"run":runpath,"compile_command_id":comp["id"],"kernel_command_id":check["id"],"kernel_evidence":str((evidence/"certificate-kernel-evidence.json").relative_to(root))}}
 dump(evidence/"goal-validation.json",validation)
 print("All four exact goals compiled, assumptions emitted, independently kernel checked.")
if __name__=="__main__":main()
