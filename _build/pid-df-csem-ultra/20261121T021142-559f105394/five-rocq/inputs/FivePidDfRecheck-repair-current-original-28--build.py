"""Measured exact-source Rocq compiler used by PID proof checkers."""
from pathlib import Path
import argparse,hashlib,json,re,shutil,sys,tempfile,subprocess
ROOT=Path(__file__).resolve().parents[5]
CASE=ROOT/"paparazzi/models/update_pid_df"
COMMON={
"FiveShared":"shared",
"FiveGuidanceCbmcAdapters":"paparazzi/relations/guidance_mode/support/cbmc_adapters",
"FiveGuidanceSemantics":"paparazzi/relations/guidance_mode/support/semantics",
"FiveGuidanceAllOrder":"paparazzi/relations/guidance_mode/support/allorder",
"FiveGuidanceAllocation":"paparazzi/relations/guidance_mode/support/allocation",
"FiveGuidanceEntry":"paparazzi/relations/guidance_mode/support/entry",
"FiveLowpassSupport":"paparazzi/relations/lowpass_recovery/support",
"FivePidDf":"paparazzi/models/update_pid_df/align/model",
"FivePidDfCase":"paparazzi/models/update_pid_df/rocq/support"}
PROBLEMS={"NoError":"no_error","Termination":"termination","Functional":"functional","ExecutionCorrespondence":"execution_correspondence","Recheck":"cbmc_recheck"}
MAPPINGS={**COMMON,**{"FivePidDf"+n:"paparazzi/models/update_pid_df/rocq/"+p+"/problem" for n,p in PROBLEMS.items()}}
def digest(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def dump(p,o):p.parent.mkdir(parents=True,exist_ok=True);p.write_text(json.dumps(o,indent=2)+"\n")
def resolve(n):
 for key,p in PROBLEMS.items():
  ns="FivePidDf"+key
  if n==ns+".Proof":return CASE/"rocq"/p/"attempts/001/Proof.v"
 for ns,rel in MAPPINGS.items():
  if n.startswith(ns+"."):return (ROOT/rel).joinpath(*n[len(ns)+1:].split(".")).with_suffix(".v")
 return None
def imports(p):
 s=re.sub(r"\(\*.*?\*\)","",p.read_text(),flags=re.S)
 rows=[]
 for prefix,names in re.findall(r"From\s+([A-Za-z0-9_.]+)\s+Require\s+(?:Import\s+|Export\s+)?([A-Za-z0-9_.\s]+?)\.",s):rows += [prefix+"."+x for x in names.split()]
 s=re.sub(r"From\s+[A-Za-z0-9_.]+\s+Require\s+(?:Import\s+|Export\s+)?[A-Za-z0-9_.\s]+?\.","",s)
 for names in re.findall(r"Require\s+(?:Import\s+|Export\s+)?([A-Za-z0-9_.\s]+?)\.(?=\s|$)",s):rows+=names.split()
 return rows
def closure(target):
 order=[];seen=set()
 def visit(n):
  p=resolve(n)
  if p is None:return
  if n in seen:return
  seen.add(n)
  if not p.is_file():raise FileNotFoundError(str(p))
  for m in imports(p):visit(m)
  order.append((n,p))
 visit(target)
 return order
def verify_handoff():
 d=json.loads((CASE/"align/handoff.json").read_text())
 for row in d["outputs"]:
  p=CASE/row["path"]
  if not p.is_file()or digest(p)!=row["sha256"]:raise RuntimeError("Changed align input: "+str(p))
 return d
def compile_target(target,run,build):
 verify_handoff();order=closure(target)
 flags=[];dirs={}
 for ns in MAPPINGS:
  dirs[ns]=build/ns;dirs[ns].mkdir(parents=True,exist_ok=True);flags+=["-Q",str(dirs[ns]),ns]
 bindings=[];sources=[]
 for n,p in order:
  ns=next(ns for ns in dirs if n.startswith(ns+"."))
  dest=dirs[ns].joinpath(*n[len(ns)+1:].split(".")).with_suffix(".v");dest.parent.mkdir(parents=True,exist_ok=True)
  if dest.exists()and digest(dest)!=digest(p):raise RuntimeError("Changed immutable snapshot "+str(dest))
  if not dest.exists():shutil.copyfile(p,dest)
  bindings.append({"path":str(p.relative_to(ROOT)),"sha256":digest(p),"snapshot":str(dest.relative_to(ROOT))})
  sources.append(dest)
 def command(argv,label):
  if run:return run.command(argv,label,timeout=600,cwd=str(ROOT))
  subprocess.run(argv,cwd=ROOT,check=True);return None
 for p in sources:
  if run:
   role="compiled-snapshot-"+str(p.relative_to(ROOT)).replace("/","-")
   captured=run.folder/"inputs"/(role+"--"+p.name)
   if captured.exists()and digest(captured)!=digest(p):raise RuntimeError("Changed actual compiled snapshot input")
   if not captured.exists():run.capture(p,role,area="inputs")
 for i,p in enumerate(sources):
  argv=["/home/yangfp/.opam/five/bin/rocq","compile",*flags,str(p)]
  if run and p.with_suffix(".vo").exists()and any(x.get("argv")==argv and x.get("status")=="passed" for x in run.read("commands.json")):continue
  command(argv,target+"-compile-"+str(i))
 return flags,sources,bindings,command
def main():
 parser=argparse.ArgumentParser();parser.add_argument("target");parser.add_argument("--run",required=True);parser.add_argument("--build",required=True);a=parser.parse_args()
 sys.path.insert(0,str(ROOT/"scripts"));from five_telemetry import Run
 run=Run(a.run);build=Path(a.build).resolve()
 flags,sources,bindings,command=compile_target(a.target,run,build)
 print(json.dumps({"target":a.target,"compiled":len(sources),"bindings":bindings}))


def verify_problem(attempt,namespace,goals,record_run=None,build_directory=None):
 attempt=Path(attempt).resolve();problem=attempt.parents[1]
 provenance=attempt/"provenance.json"
 if provenance.exists():
  for row in json.loads(provenance.read_text())["files"]:
   p=ROOT/row["path"]
   if digest(p)!=row["sha256"]:raise RuntimeError("Changed frozen proof input: "+row["path"])
 sys.path.insert(0,str(ROOT/"scripts"))
 from five_telemetry import Run
 from example_proof_gate import certificate_source
 run=Run(record_run)if record_run else None
 if build_directory is not None:build=Path(build_directory).resolve()
 elif run:build=ROOT/"_build/pid-df-final"/run.folder.parent.name
 else:build=Path(tempfile.mkdtemp(prefix="pid-df-independent-",dir=ROOT/"_build"))
 flags,sources,bindings,command=compile_target(namespace+".Proof",run,build)
 cert=build/namespace/"GoalBinding.v"
 text=certificate_source([namespace+".Spec",namespace+".Proof"],goals)
 if cert.exists()and cert.read_text()!=text:raise RuntimeError("Changed immutable certificate")
 cert.write_text(text)
 comp=command(["/home/yangfp/.opam/five/bin/rocq","compile",*flags,str(cert)],namespace+"-goal-certificate")
 kernel=command(["/home/yangfp/.opam/five/bin/rocq","check","-silent",*flags,namespace+".Proof",namespace+".GoalBinding"],namespace+"-independent-kernel")
 if not run:
  print("Exact canonical goals compiled, assumptions printed, independent kernel check passed.");return
 evidence=attempt/"evidence";runpath=str(run.folder.relative_to(ROOT))
 deps={str(p.relative_to(ROOT)):digest(p)for p in sources}
 receipt={"kind":"rocq-kernel-check","run":runpath,"command_id":kernel["id"],"theorems":[g["theorem"]for g in goals],"statement_artifacts":[str((build/namespace/"Spec.v").relative_to(ROOT)),str((build/namespace/"Proof.v").relative_to(ROOT))],"dependency_sha256":deps}
 dump(evidence/"kernel-evidence.json",receipt)
 original=CASE/"prepare/source/update_pid_df.c"
 dump(evidence/"gate-kernel-evidence.json",{**receipt,"dependency_sha256":{**deps,str(original.relative_to(ROOT)):digest(original)}})
 cr={**receipt,"theorems":[namespace+".GoalBinding.goal_"+str(i)for i in range(len(goals))],"statement_artifacts":[str(cert.relative_to(ROOT))],"dependency_sha256":{**deps,str(cert.relative_to(ROOT)):digest(cert)}}
 dump(evidence/"certificate-kernel-evidence.json",cr)
 indexed={row["path"]:row["sha256"]for row in bindings}
 handoff=verify_handoff()
 for row in handoff["outputs"]:
  p=CASE/row["path"];indexed[str(p.relative_to(ROOT))]=digest(p)
 for p in [CASE/"align/handoff.json",attempt/"check.py",Path(__file__).resolve(),CASE/"rocq/support/runtime-receipt.json"]:
  indexed[str(p.relative_to(ROOT))]=digest(p)
 for row in sorted(indexed.items()):
  p=ROOT/row[0];role=namespace+"-"+row[0].replace("/","-")
  target=run.folder/"inputs"/(role+"--"+p.name)
  if target.exists()and digest(target)!=row[1]:raise RuntimeError("Input capture overwrite")
  if not target.exists():run.capture(p,role,area="inputs")
 dump(provenance,{"schema":"five-proof-attempt-provenance/1","files":[{"path":p,"sha256":h}for p,h in sorted(indexed.items())]})
 bound={row["path"]:row for row in bindings}
 for p,h in indexed.items():bound.setdefault(p,{"path":p,"sha256":h})
 run.capture(cert,namespace+"-canonical-goal-binding",area="inputs")
 validation={"schema":"five-proof-validation/1","index":{"path":str(provenance.relative_to(ROOT)),"sha256":digest(provenance)},"inputs":list(bound.values()),"kernel_evidence":str((evidence/"kernel-evidence.json").relative_to(ROOT)),"goal_bindings":goals,"certificate":{"path":str(cert.relative_to(ROOT)),"sha256":digest(cert),"module":namespace+".GoalBinding","imports":[namespace+".Spec",namespace+".Proof"],"run":runpath,"compile_command_id":comp["id"],"kernel_command_id":kernel["id"],"kernel_evidence":str((evidence/"certificate-kernel-evidence.json").relative_to(ROOT))}}
 dump(evidence/"goal-validation.json",validation)
 print(namespace+": exact canonical goals and certificate independently kernel checked.")

if __name__=="__main__":main()
