#!/usr/bin/env python3
"""Exact core goal checking with unique captures and one shared physical build.
Default: check this attempt. --all-core: check all five replacement attempts once.
"""
from pathlib import Path
import argparse,hashlib,json,re,shutil,subprocess,sys,tempfile
ROOT=next(p for p in Path(__file__).resolve().parents if(p/'scripts/five_telemetry.py').is_file())
MAPPINGS={
 'FivePaparazziState':'paparazzi/relations/parameter_order/support',
 'FiveGhSpeed':'paparazzi/models/gh_update_ref_from_speed_sp/align/model',
 'FiveGhAccel':'paparazzi/models/gh_update_ref_from_accel_sp/align/model',
 'FiveGuidanceEntry':'paparazzi/relations/guidance_mode/support/entry',
 'FiveGuidanceAllocation':'paparazzi/relations/guidance_mode/support/allocation',
 'FiveGuidanceSemantics':'paparazzi/relations/guidance_mode/support/semantics',
 'FiveGuidanceAllOrder':'paparazzi/relations/guidance_mode/support/allorder',
 'FiveGuidanceSoftwareProof':'paparazzi/relations/guidance_mode/support/software',
 'FiveGuidanceMode':'paparazzi/relations/guidance_mode/problem',
 'FiveGuidanceRelationSupport':'paparazzi/relations/guidance_mode/support/relation',
 'FiveShared':'shared'}
def digest(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def dump(p,o):p.parent.mkdir(parents=True,exist_ok=True);p.write_text(json.dumps(o,indent=2)+'\n')
def targets():
 rows=json.loads((ROOT/'paparazzi/relations/guidance_mode/support/allorder/canonical-attempts.json').read_text());out=[]
 for row in rows:
  old=ROOT/row['attempt'];new=old.parent/'002';data=json.loads((old/'evidence/goal-validation.json').read_text())
  out.append({'namespace':row['namespace'],'attempt':new,'spec':old.parents[1]/'problem/Spec.v','goals':data['goal_bindings']})
 return out
def imports(p):
 s=re.sub(r'\(\*.*?\*\)','',p.read_text(),flags=re.S);rows=[]
 for prefix,names in re.findall(r'From\s+([A-Za-z0-9_.]+)\s+Require\s+(?:Import\s+|Export\s+)?([A-Za-z0-9_.\s]+?)\.',s):rows +=[prefix+'.'+x for x in names.split()]
 s=re.sub(r'From\s+[A-Za-z0-9_.]+\s+Require\s+(?:Import\s+|Export\s+)?[A-Za-z0-9_.\s]+?\.','',s)
 for names in re.findall(r'Require\s+(?:Import\s+|Export\s+)?([A-Za-z0-9_.\s]+?)\.(?=\s|$)',s):rows+=names.split()
 return rows
def graph(selected):
 special={}
 for t in selected:special[t['namespace']+'.Spec']=t['spec'];special[t['namespace']+'.Proof']=t['attempt']/'Proof.v'
 def resolve(q):
  if q in special:return special[q]
  ns=q.split('.')[0]
  return ROOT/MAPPINGS[ns]/(q[len(ns)+1:].replace('.','/')+'.v')if ns in MAPPINGS else None
 order=[];seen=set();closure={}
 def visit(q):
  p=resolve(q)
  if p is None:return set()
  if q in closure:return closure[q]
  if q in seen:raise RuntimeError('Dependency cycle: '+q)
  seen.add(q)
  if not p.is_file():raise FileNotFoundError(str(p))
  result={q}
  for dep in imports(p):result |= visit(dep)
  closure[q]=result;order.append((q,p));return result
 for t in selected:visit(t['namespace']+'.Proof')
 return order,closure
def run_checks(selected,build,run):
 order,closure=graph(selected);names=list(dict.fromkeys([*MAPPINGS,*[t['namespace']for t in selected]]));flags=[]
 for ns in names:d=build/ns;d.mkdir(parents=True,exist_ok=True);flags+=['-Q',str(d),ns]
 source={};snapshot={};rows=[]
 for q,p in order:
  dst=build/(q.replace('.','/')+'.v');dst.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(p,dst)
  source[q]=p;snapshot[q]=dst;rows.append({'module':q,'source':str(p.relative_to(ROOT)),'sha256':digest(p),'snapshot':str(dst.relative_to(ROOT))if dst.is_relative_to(ROOT)else None})
  if run:run.capture(dst,'core-source-'+q,area='inputs')
 def command(argv,label):
  if run:return run.command(argv,label,timeout=600,cwd=str(ROOT))
  subprocess.run(argv,cwd=ROOT,check=True);return None
 for i,(q,p)in enumerate(order):command(['/home/yangfp/.opam/five/bin/rocq','compile',*flags,str(snapshot[q])],'core-direct-'+q)
 sys.path.insert(0,str(ROOT/'scripts'));from example_proof_gate import certificate_source
 certs={};compiles={}
 for t in selected:
  ns=t['namespace'];cert=build/ns/'GoalBinding.v';cert.write_text(certificate_source([ns+'.Spec',ns+'.Proof'],t['goals']));certs[ns]=cert
  if run:run.capture(cert,'core-certificate-'+ns,area='inputs')
  compiles[ns]=command(['/home/yangfp/.opam/five/bin/rocq','compile',*flags,str(cert)],'core-typed-goalbinding-'+ns)
 modules=[m for t in selected for m in[t['namespace']+'.Proof',t['namespace']+'.GoalBinding']]
 kernel=command(['/home/yangfp/.opam/five/bin/rocq','check','-silent',*flags,*modules],'core-all-five-independent-kernel')
 if not run:return
 dump(build/'shared-source-index.json',{'schema':'five-shared-core-build/1','scope':'Every dependency has one immutable physical source path, captured under a unique qualified role and directly compiled once in this bound run.','sources':rows,'proof_modules':modules})
 runpath=str(run.folder.relative_to(ROOT))
 for t in selected:
  ns=t['namespace'];attempt=t['attempt'];goals=t['goals'];cert=certs[ns];qs=closure[ns+'.Proof'];evidence=attempt/'evidence';evidence.mkdir(parents=True,exist_ok=True)
  selected_rows=[r for r in rows if r['module']in qs];deps={str(snapshot[q].relative_to(ROOT)):digest(snapshot[q])for q in qs}
  receipt={'kind':'rocq-kernel-check','run':runpath,'command_id':kernel['id'],'theorems':[g['theorem']for g in goals],'statement_artifacts':[str(snapshot[ns+'.Spec'].relative_to(ROOT)),str(snapshot[ns+'.Proof'].relative_to(ROOT))],'dependency_sha256':deps}
  dump(evidence/'kernel-evidence.json',receipt)
  cr={**receipt,'theorems':[ns+'.GoalBinding.goal_'+str(i)for i in range(len(goals))],'statement_artifacts':[str(cert.relative_to(ROOT))],'dependency_sha256':{**deps,str(cert.relative_to(ROOT)):digest(cert)}}
  dump(evidence/'certificate-kernel-evidence.json',cr)
  indexed={str(source[q].relative_to(ROOT)):digest(source[q])for q in qs}
  for entry in ['gh_update_ref_from_speed_sp','gh_update_ref_from_accel_sp']:
   case=ROOT/'paparazzi/models'/entry
   for rel in ['prepare/source/'+entry+'.c','prepare/source/five_sqrtf.c','prepare/source/bindings.json','align/request.json','align/model/compcert-manifest.json','align/model/preprocessed.i']:
    p=case/rel;indexed[str(p.relative_to(ROOT))]=digest(p)
  checker=attempt/'check.py';indexed[str(checker.relative_to(ROOT))]=digest(checker);run.capture(checker,'core-checker-'+ns,area='inputs')
  dump(attempt/'provenance.json',{'schema':'five-proof-attempt-provenance/1','files':[{'path':p,'sha256':h}for p,h in sorted(indexed.items())]})
  bound={r['source']:{'path':r['source'],'sha256':r['sha256'],'snapshot':r['snapshot']}for r in selected_rows}
  for p,h in indexed.items():bound.setdefault(p,{'path':p,'sha256':h})
  validation={'schema':'five-proof-validation/1','index':{'path':str((attempt/'provenance.json').relative_to(ROOT)),'sha256':digest(attempt/'provenance.json')},'inputs':list(bound.values()),'kernel_evidence':str((evidence/'kernel-evidence.json').relative_to(ROOT)),'goal_bindings':goals,'certificate':{'path':str(cert.relative_to(ROOT)),'sha256':digest(cert),'module':ns+'.GoalBinding','imports':[ns+'.Spec',ns+'.Proof'],'run':runpath,'compile_command_id':compiles[ns]['id'],'kernel_command_id':kernel['id'],'kernel_evidence':str((evidence/'certificate-kernel-evidence.json').relative_to(ROOT))}}
  dump(evidence/'goal-validation.json',validation)
  dump(evidence/'shared-build.json',{'run':runpath,'source_index':str((build/'shared-source-index.json').relative_to(ROOT)),'source_index_sha256':digest(build/'shared-source-index.json'),'scope':'Same physical dependency paths; no object relocation or cross-run cache reuse.'})
 print('All selected exact core goals directly compiled once and independently kernel checked.')
def main():
 ap=argparse.ArgumentParser();ap.add_argument('--record-run');ap.add_argument('--all-core',action='store_true');args=ap.parse_args();selected=targets()
 if not args.all_core:
  selected=[t for t in selected if t['attempt']==Path(__file__).resolve().parent]
  if not selected:raise RuntimeError('Invoke an attempt checker or use --all-core')
 for t in selected:
  index=t['attempt']/'provenance.json'
  if index.is_file():
   for row in json.loads(index.read_text())['files']:
    if Path(row['path']).suffix in('.v','.c')and digest(ROOT/row['path'])!=row['sha256']:raise RuntimeError('Changed proof input: '+row['path'])
 if args.record_run:
  sys.path.insert(0,str(ROOT/'scripts'));from five_telemetry import Run
  run=Run(args.record_run);build=run.folder/'evidence'/('shared-core-'+str(len(list((run.folder/'evidence').glob('shared-core-*')))+1).zfill(3))
  if build.exists():raise RuntimeError('Immutable shared build exists')
  build.mkdir();run_checks(selected,build,run)
 else:
  with tempfile.TemporaryDirectory(prefix='five-core-input-repair-')as tmp:run_checks(selected,Path(tmp),None)
if __name__=='__main__':main()
