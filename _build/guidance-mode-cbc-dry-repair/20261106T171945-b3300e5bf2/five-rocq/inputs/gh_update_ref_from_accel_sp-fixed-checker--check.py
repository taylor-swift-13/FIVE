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
mappings={'FivePaparazziState':root/'paparazzi/relations/parameter_order/support','FiveGhSpeed':root/'paparazzi/models/gh_update_ref_from_speed_sp/align/model','FiveGhAccel':root/'paparazzi/models/gh_update_ref_from_accel_sp/align/model','FiveGuidanceEntry':root/'paparazzi/relations/guidance_mode/support/entry','FiveGuidanceAllocation':root/'paparazzi/relations/guidance_mode/support/allocation','FiveGuidanceSemantics':root/'paparazzi/relations/guidance_mode/support/semantics','FiveGuidanceAllOrder':root/'paparazzi/relations/guidance_mode/support/allorder','FiveGuidanceSoftwareProof':root/'paparazzi/relations/guidance_mode/support/software','FiveGuidanceMode':root/'paparazzi/relations/guidance_mode/problem','FiveGuidanceRelationSupport':root/'paparazzi/relations/guidance_mode/support/relation','FiveShared':root/'shared','FiveGuidanceCbmcAdapters':root/'paparazzi/relations/guidance_mode/support/cbmc_adapters'}
special={"FiveGhAccelCBC.Spec":problem/"problem/Spec.v","FiveGhAccelCBC.Proof":attempt/"Proof.v"}
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
 parser=argparse.ArgumentParser();parser.add_argument("--record-run");parser.add_argument("--reuse-checked");parser.add_argument("--same-run-dependencies");args=parser.parse_args()
 global reuse_checked,same_run_dependencies
 same_run_dependencies=Path(args.same_run_dependencies).resolve()if args.same_run_dependencies else None
 if same_run_dependencies and not args.record_run:raise RuntimeError("Same-run reuse requires an actual bound recorded run")
 reuse_checked=Path(args.reuse_checked)if args.reuse_checked else None
 provenance=attempt/"provenance.json"
 if provenance.exists():
  for row in json.loads(provenance.read_text())["files"]:
   if (root/row["path"]).suffix in (".v",".c") and digest(root/row["path"])!=row["sha256"]:raise RuntimeError("Changed proof input: "+row["path"])
 visit("FiveGhAccelCBC.Proof")
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
 flags=[];nsmap={};same_run_reused={}
 def same_run_receipt(p):
  if run is None:return None
  captured={Path(x['source']).resolve():x['sha256']for x in run.read('inputs/manifest.json')if 'sha256'in x}
  if captured.get(p.resolve())!=digest(p):return None
  for row in run.read('commands.json'):
   av=row['argv']
   if row.get('status')=='passed'and row.get('exit_code')==0 and Path(av[0]).name=='rocq'and len(av)>1 and av[1]=='compile'and any(x.endswith('.v')and(Path(row['cwd'])/x).resolve()==p.resolve()for x in av[2:]):return row['id']
  return None
 for ns in dict.fromkeys([*mappings,"FiveGhAccelCBC"]):
  d=build/ns
  family=[(n,p)for n,p in order if n.startswith(ns+'.')]
  if same_run_dependencies and ns!="FiveGhAccelCBC":
   candidate=same_run_dependencies/ns;checks=[]
   for name,original in family:
    old=candidate.joinpath(*name[len(ns)+1:].split('.')).with_suffix('.v')
    if not old.is_file()or not old.with_suffix('.vo').is_file()or old.read_bytes()!=original.read_bytes():checks=[];break
    receipt=same_run_receipt(old)
    if not receipt:checks=[];break
    checks.append({'module':name,'source':str(old.relative_to(root)),'sha256':digest(old),'compile_command_id':receipt})
   if family and len(checks)==len(family):d=candidate;same_run_reused.update({x['source']:x for x in checks})
  d.mkdir(parents=True,exist_ok=True);nsmap[ns]=d;flags += ["-Q",str(d),ns]
 sources=[];bindings=[]
 for name,p in order:
  ns=next(n for n in nsmap if name.startswith(n+"."))
  dest=nsmap[ns].joinpath(*name[len(ns)+1:].split(".")).with_suffix(".v");dest.parent.mkdir(parents=True,exist_ok=True)
  if run and dest.is_relative_to(root) and str(dest.relative_to(root))in same_run_reused:
   if dest.read_bytes()!=p.read_bytes():raise RuntimeError('Changed same-run shared source')
  else:shutil.copyfile(p,dest)
  sources.append(dest);bindings.append({"path":str(p.relative_to(root)),"sha256":digest(p),"snapshot":str(dest.relative_to(root)) if dest.is_relative_to(root) else None})
 if same_run_reused:dump(build/'same-run-source-reuse.json',{'scope':'Exact same immutable physical source paths actually compiled in this same bound run; no object relocation.','run':str(run.folder.relative_to(root)),'sources':list(same_run_reused.values())})
 def command(argv,label):
  if run:return run.command(argv,label,timeout=600,cwd=str(root))
  subprocess.run(argv,cwd=root,check=True);return None
 if run:
  for i,p in enumerate(sources):run.capture(p,"accel-cbc-dependency-"+str(i),area="inputs")
 for i,p in enumerate(sources):
  if run and p.is_relative_to(root) and str(p.relative_to(root))in same_run_reused:continue
  old=reuse_checked/p.relative_to(build)if reuse_checked else None
  if old is not None and old.is_file()and old.read_bytes()==p.read_bytes()and old.with_suffix('.vo').is_file():
   shutil.copyfile(old.with_suffix('.vo'),p.with_suffix('.vo'))
  else:command(["/home/yangfp/.opam/five/bin/rocq","compile",*flags,str(p)],"relation-dependency-"+str(i))
 kernel=None if run else command(["/home/yangfp/.opam/five/bin/rocq","check","-silent",*flags,"FiveGhAccelCBC.Proof"],"relation-independent-kernel")
 return flags,sources,bindings,kernel,command

def recorded(run,build):
 flags,sources,bindings,kernel,command=compile_all(build,run)
 names=['Goal001', 'Goal002', 'Goal003', 'Goal004', 'Goal005', 'Goal006', 'Goal007', 'Goal008', 'Goal009', 'Goal010', 'Goal011', 'Goal012', 'Goal013', 'Goal014', 'Goal015', 'Goal016', 'Goal017', 'Goal018', 'Goal019', 'Goal020', 'Goal021', 'Goal022', 'Goal023', 'Goal024', 'Goal025', 'Goal026', 'Goal027', 'Goal028', 'Goal029', 'Goal030', 'Goal031', 'Goal032', 'Goal033', 'Goal034', 'Goal035', 'Goal036', 'Goal037', 'Goal038', 'Goal039', 'Goal040', 'Goal041', 'Goal042', 'Goal043', 'Goal044', 'Goal045', 'Goal046', 'Goal047', 'Goal048', 'Goal049', 'Goal050', 'Goal051', 'Goal052', 'Goal053', 'Goal054', 'Goal055', 'Goal056', 'Goal057', 'Goal058', 'Goal059', 'Goal060', 'Goal061', 'Goal062', 'Goal063', 'Goal064', 'Goal065', 'Goal066', 'Goal067', 'Goal068', 'Goal069', 'Goal070', 'Goal071', 'Goal072', 'Goal073', 'Goal074', 'Goal075', 'Goal076', 'Goal077', 'Goal078', 'Goal079', 'Goal080', 'Goal081', 'Goal082', 'Goal083', 'Goal084', 'Goal085', 'Goal086', 'Goal087', 'Goal088', 'Goal089', 'Goal090', 'Goal091', 'Goal092', 'Goal093', 'Goal094', 'Goal095', 'Goal096', 'Goal097', 'Goal098', 'Goal099', 'Goal100', 'Goal101', 'Goal102', 'Goal103', 'Goal104', 'Goal105', 'Goal106', 'Goal107', 'Goal108', 'Goal109', 'Goal110', 'Goal111', 'Goal112', 'Goal113', 'Goal114', 'Goal115', 'Goal116', 'Goal117', 'Goal118', 'Goal119', 'Goal120', 'Goal121', 'Goal122']
 lemmas=['goal001', 'goal002', 'goal003', 'goal004', 'goal005', 'goal006', 'goal007', 'goal008', 'goal009', 'goal010', 'goal011', 'goal012', 'goal013', 'goal014', 'goal015', 'goal016', 'goal017', 'goal018', 'goal019', 'goal020', 'goal021', 'goal022', 'goal023', 'goal024', 'goal025', 'goal026', 'goal027', 'goal028', 'goal029', 'goal030', 'goal031', 'goal032', 'goal033', 'goal034', 'goal035', 'goal036', 'goal037', 'goal038', 'goal039', 'goal040', 'goal041', 'goal042', 'goal043', 'goal044', 'goal045', 'goal046', 'goal047', 'goal048', 'goal049', 'goal050', 'goal051', 'goal052', 'goal053', 'goal054', 'goal055', 'goal056', 'goal057', 'goal058', 'goal059', 'goal060', 'goal061', 'goal062', 'goal063', 'goal064', 'goal065', 'goal066', 'goal067', 'goal068', 'goal069', 'goal070', 'goal071', 'goal072', 'goal073', 'goal074', 'goal075', 'goal076', 'goal077', 'goal078', 'goal079', 'goal080', 'goal081', 'goal082', 'goal083', 'goal084', 'goal085', 'goal086', 'goal087', 'goal088', 'goal089', 'goal090', 'goal091', 'goal092', 'goal093', 'goal094', 'goal095', 'goal096', 'goal097', 'goal098', 'goal099', 'goal100', 'goal101', 'goal102', 'goal103', 'goal104', 'goal105', 'goal106', 'goal107', 'goal108', 'goal109', 'goal110', 'goal111', 'goal112', 'goal113', 'goal114', 'goal115', 'goal116', 'goal117', 'goal118', 'goal119', 'goal120', 'goal121', 'goal122']
 goals=[{"requested_goal":g,"theorem":"FiveGhAccelCBC.Proof."+t,"type":"FiveGhAccelCBC.Spec."+g} for g,t in zip(names,lemmas)]
 from example_proof_gate import certificate_source
 cert=build/"FiveGhAccelCBC/GoalBinding.v";cert.write_text(certificate_source(["FiveGhAccelCBC.Spec","FiveGhAccelCBC.Proof"],goals));run.capture(cert,"accel-cbc-goal-binding-certificate",area="inputs")
 comp=command(["/home/yangfp/.opam/five/bin/rocq","compile",*flags,str(cert)],"relation-goal-certificate")
 check=command(["/home/yangfp/.opam/five/bin/rocq","check","-silent",*flags,"FiveGhAccelCBC.Proof","FiveGhAccelCBC.GoalBinding"],"relation-certificate-kernel")
 kernel=check
 evidence=attempt/"evidence";runpath=str(run.folder.relative_to(root));deps={str(p.relative_to(root)):digest(p) for p in sources}
 receipt={"kind":"rocq-kernel-check","run":runpath,"command_id":kernel["id"],"theorems":[g["theorem"] for g in goals],"statement_artifacts":[str((build/"FiveGhAccelCBC/Spec.v").relative_to(root)),str((build/"FiveGhAccelCBC/Proof.v").relative_to(root))],"dependency_sha256":deps}
 dump(evidence/"kernel-evidence.json",receipt)
 cr={**receipt,"command_id":check["id"],"theorems":["FiveGhAccelCBC.GoalBinding.goal_"+str(i) for i in range(len(goals))],"statement_artifacts":[str(cert.relative_to(root))],"dependency_sha256":{**deps,str(cert.relative_to(root)):digest(cert)}}
 dump(evidence/"certificate-kernel-evidence.json",cr)
 # The final CompCert gate also binds the original C and original generated
 # Source/Execution paths to byte-identical compiled snapshots. These are
 # captured original inputs, not a claim that live paths were recompiled.
 gate_deps=dict(deps)
 for entry in ("gh_update_ref_from_speed_sp","gh_update_ref_from_accel_sp"):
  c=root/"paparazzi/models"/entry
  for rel in ("prepare/source/"+entry+".c","prepare/source/five_sqrtf.c","prepare/source/bindings.json","align/model/Source.v","align/model/Execution.v"):
   p=c/rel;run.capture(p,"accel-cbc-gate-original-"+entry+"-"+p.name,area="inputs");gate_deps[str(p.relative_to(root))]=digest(p)
 dump(evidence/"gate-kernel-evidence.json",{**receipt,"dependency_sha256":gate_deps})

 indexed={row["path"]:row["sha256"] for row in bindings}
 for e in ("gh_update_ref_from_speed_sp","gh_update_ref_from_accel_sp"):
  c=root/"paparazzi/models"/e
  for rel in ("prepare/source/"+e+".c","prepare/source/bindings.json","prepare/source/five_sqrtf.c","align/request.json","align/model/compcert-manifest.json","align/model/preprocessed.i"):
   p=c/rel;indexed[str(p.relative_to(root))]=digest(p)
 for rel in ("cbmc/harness.c","cbmc/properties.json","cbmc/report/scope.json","rocq/cbmc_recheck/property-map.json"):
  p=case/rel;indexed[str(p.relative_to(root))]=digest(p)
 indexed[str((attempt/"check.py").relative_to(root))]=digest(attempt/"check.py")
 dump(attempt/"provenance.json",{"schema":"five-proof-attempt-provenance/1","files":[{"path":p,"sha256":h} for p,h in sorted(indexed.items())]})
 bound={x["path"]:x for x in bindings}
 for p,h in indexed.items():bound.setdefault(p,{"path":p,"sha256":h})
 validation={"schema":"five-proof-validation/1","index":{"path":str((attempt/"provenance.json").relative_to(root)),"sha256":digest(attempt/"provenance.json")},"inputs":list(bound.values()),"kernel_evidence":str((evidence/"kernel-evidence.json").relative_to(root)),"goal_bindings":goals,"certificate":{"path":str(cert.relative_to(root)),"sha256":digest(cert),"module":"FiveGhAccelCBC.GoalBinding","imports":["FiveGhAccelCBC.Spec","FiveGhAccelCBC.Proof"],"run":runpath,"compile_command_id":comp["id"],"kernel_command_id":check["id"],"kernel_evidence":str((evidence/"certificate-kernel-evidence.json").relative_to(root))}}
 dump(evidence/"goal-validation.json",validation)
 print("All exact goals compiled, assumptions emitted, independently kernel checked.")
if __name__=="__main__":main()
