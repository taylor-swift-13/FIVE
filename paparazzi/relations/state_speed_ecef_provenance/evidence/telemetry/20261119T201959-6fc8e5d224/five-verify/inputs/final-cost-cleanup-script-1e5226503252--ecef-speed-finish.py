from pathlib import Path
from datetime import datetime,timezone
import json,sys,hashlib,os,shutil
r=Path('/home/yangfp/five');rel=r/'paparazzi/relations/state_speed_ecef_provenance'
sys.path.insert(0,str(r/'scripts'))
from five_telemetry import Run
root=Run((r/'_build/state-speed-ecef-provenance/root-run.txt').read_text().strip())
admin=Run((r/'_build/state-speed-ecef-provenance/admin-run.txt').read_text().strip())
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def load(p):return json.loads(Path(p).read_text())
def dump(p,d):p=Path(p);p.parent.mkdir(parents=True,exist_ok=True);p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n')
def rr(p):return str(Path(p).resolve().relative_to(r))
def archive(p):
 p=Path(p)
 if p.is_symlink():return p.resolve()
 p=p.resolve();d=load(p/'run.json');assert d['status']!='running'
 dest=rel/'evidence/telemetry'/d['run_id']/d['skill']
 assert p.is_relative_to(r/'runs')and dest.is_relative_to(rel/'evidence/telemetry')and not dest.exists()
 dest.parent.mkdir(parents=True,exist_ok=True);shutil.move(str(p),str(dest))
 p.symlink_to(os.path.relpath(dest,p.parent),target_is_directory=True)
 return dest

def main():
 assert admin.read('run.json')['status']=='running'and root.read('run.json')['status']=='running'
 admin.capture(Path(__file__),'final-cost-cleanup-script-'+sha(__file__)[:12],area='inputs')
 commands=admin.read('commands.json')
 audit=next(x for x in reversed(commands)if x['id'].endswith('independent-final-14-problem-and-actual-property-audit')and x['status']=='passed')
 gate=next(x for x in reversed(commands)if x['id'].endswith('final-official-compcert-acceptance-all-three-cases')and x['status']=='passed')
 audit_data=load(admin.folder/audit['stdout'])
 gate_text=(admin.folder/gate['stdout']).read_text();start=gate_text.index('{\n  "official_gate_function"')
 gate_data=json.loads(gate_text[start:]);assert gate_data['all_accepted']and not audit_data['errors']
 acceptance={'status':'complete','source_commit':'abfee3dd56eeab12c528635504a429db3daf409a',
  'scope':'Three original CompCert API models and explicit state-speed provenance relation; native diagnosis, traditional CBMC, all actual property rechecks and checked refutations.',
  'cold_sources':100,'canonical_problems':14,'exact_typed_goals':379,
  'actual_cbmc_properties':340,'proved_properties':337,'refuted_properties':3,
  'metadata_audit':audit_data,'official_gates':gate_data,
  'proof_kernel':'paparazzi/relations/state_speed_ecef_provenance/evidence/cold-checks/20261119T211947849575/proof-kernel-evidence.json',
  'source_bound_kernel':'paparazzi/relations/state_speed_ecef_provenance/evidence/cold-checks/20261119T211947849575/source-bound-kernel-evidence.json',
  'program_result':'Read-after-write and old-NED-history independence refuted; this is a functional error, not a proven runtime crash.'}
 dump(rel/'evidence/final-acceptance.json',acceptance)
 # Metadata-only final pass after the last readable-report/hash refresh.
 import importlib.util
 s=importlib.util.spec_from_file_location('final_metadata',r/'scripts/check-example-artifacts.py');m=importlib.util.module_from_spec(s);s.loader.exec_module(m)
 v=m.Validator(r,allowed_proof_efforts={'ultra'})
 cases=[r/'paparazzi/models'/n for n in ('stateSetSpeedNed_i','stateSetSpeedEcef_i','stateGetSpeedEcef_f')]
 for case in cases:
  h=load(case/'rocq/handoff.json');v.bound(case,h['outputs']);v.links(case/'rocq/report/report.md');v.costs(case/'rocq/report/costs.json')
 for problem in [p for case in cases for p in(case/'rocq').glob('*/problem')]+[rel/'problem']:
  v.links(problem/'report.md');a=(problem/load(problem/'status.json')['active_attempt']).resolve()
  v.links(a/'report.md');v.costs(a/'costs.json',proof=True)
 assert not v.errors,v.errors
 freeze=root.read('evidence/pre-existing-artifact-freeze.json')['files']
 assert all((r/x['path']).is_file()and sha(r/x['path'])==x['sha256']for x in freeze)
 # Remove only reproducible Rocq caches under the three new cases/relation.
 removed=[]
 protected=set()
 for case in cases:
  for h in case.glob('*/handoff.json'):
   protected.update((case/x['path']).resolve()for x in load(h).get('outputs',[]))
 for base in [*cases,rel]:
  assert base.resolve().is_relative_to(r/'paparazzi')
  for p in base.rglob('*'):
   if '/evidence/telemetry/'in str(p)or p.resolve()in protected:continue
   if p.is_file()and(p.suffix in {'.vo','.vos','.vok','.glob','.aux'}or p.name in {'.lia.cache','.nia.cache'}):
    removed.append(rr(p));p.unlink()
 dump(rel/'evidence/cache-cleanup.json',{'removed_count':len(removed),'scope':'Only reproducible Rocq caches inside the three new models and new relation; every source and raw receipt retained.','extensions':['.vo','.vos','.vok','.glob','.aux','.lia.cache','.nia.cache']})
 outputs={'acceptance':rel/'evidence/final-acceptance.json','readable-relation':rel/'problem/report.md'}
 for case in cases:outputs[case.name+'-handoff']=case/'rocq/handoff.json'
 admin.evidence('administrative-measurement-scope.json',{'role':'Python evidence packaging and independent metadata review; no mathematical theorem authoring.',
  'scope':'Registered actor tokens and wall interval. Only Run.command tools have GNU CPU/RSS; direct outer WSL inspections/transport and the first direct publisher invocation have unknown CPU/RSS. No exhaustive total-resource claim.',
  'proof_authors':'Actual gpt-6.1-sol Ultra; Root administrative actor is separately identified by its own runtime receipt.'})
 admin.finish('passed','All three official gates accepted; 14 problem metadata checks, readable reports and source hashes passed; only generated caches cleaned.',outputs)
 admin_archive=archive(admin.folder)
 (r/'_build/state-speed-ecef-provenance/admin-run.txt').write_text(str(admin_archive))
 # Preserve newly emitted tool-only provenance audits and closed review stages.
 known=[]
 owned_ids={'20261119T213221-b363282ea3','20261119T213151-f8dbc21bb6',
  '20261119T214757-d0f8e8a4e3','20261119T214924-f3845029c8',
  '20261119T214925-a4ef92287e','20261119T214925-0bb6270b93'}
 for p in sorted((r/'runs').glob('*/five-*/run.json')):
  if p.parent.parent.name not in owned_ids:continue
  if p.parent.is_symlink():continue
  d=load(p)
  if d.get('start_epoch',0)>=root.read('run.json')['start_epoch']and d.get('status')!='running':
   known.append(archive(p.parent))
 root.evidence('final-verification.json',acceptance)
 root.evidence('final-resource-scope.json',{'aggregate_time':'Direct registered root elapsed time, not sum of worker durations.',
  'tokens':'Actual session-event union across root and registered children; cached/reasoning are subsets. Bootstrap/delivery outside explicit boundaries is not estimated.',
  'cpu_memory':'Unobserved outer transport/inspection CPU/RSS, interrupted receipts, command059 collision and simultaneous worker combined RSS remain unknown. Recorded tool subsets and every raw audit are retained.',
  'fresh_review_invocation_defect':'213221 has actual Ultra session token events but its default invocation_kind was tool-workflow; keep its audit warning. Failed213151 had no usage boundary; its actor interval is included in main194851.',
  'standalone_tool_audits':'Fresh gate provenance audit runs are already inside the measured parent gate command CPU tree; do not add their child CPU a second time.'})
 root.finish('passed','Original C, CBMC and checked CompCert/Rocq witnesses establish the ECEF speed wrong-field functional bug. All requested models, proofs, property rechecks, reports and gates completed.',outputs)
 root_archive=archive(root.folder)
 (r/'_build/state-speed-ecef-provenance/root-run.txt').write_text(str(root_archive))
 metrics=load(root_archive/'metrics.json');t=metrics['tokens'];mem=metrics['memory'];tm=metrics['time']
 registry=sorted({p.parent.resolve()for p in(rel/'evidence/telemetry').glob('*/five-*/run.json')}|
  {p.parent.resolve()for p in cases[2].glob('*/report/evidence/telemetry/*/five-*/run.json')})
 cost={'schema':'five-stage-costs/1','records':[{'stage':'five-verify','run':rr(root_archive),'status':'recorded',
  'time':{'wall_seconds':tm['wall_seconds'],'tool_cpu_seconds':None},
  'token':{'input':t['input_tokens'],'output':t['output_tokens'],'total':t['total_tokens'],'cached_input':t['cached_input_tokens'],'reasoning_output':t['reasoning_output_tokens']},
  'memory':{'tool_peak_rss_bytes':None},
  'observed_subsets':{'recorded_tool_cpu_seconds':tm['cpu_recorded_tool_seconds'],'largest_observed_tool_tree_rss_bytes':mem.get('max_child_tree_rss_sampled_bytes'),'largest_observed_individual_process_rss_bytes':mem.get('max_individual_process_rss_bytes')},
  'measurement_scope':'Registered root interval with actual token-event union. Shared author/case records and inclusive children must not be added again. Raw scope/audit warnings remain intact.',
  'missing_reason':'Exhaustive CPU and simultaneous aggregate memory are unobserved; source transport, timeouts and writer-collision limits are explicitly retained. Final deterministic cost serialization/cleanup delivery is outside the closed observer.',
  'evidence':[os.path.relpath(root_archive/'run.json',rel/'evidence'),os.path.relpath(root_archive/'metrics.json',rel/'evidence'),os.path.relpath(root_archive/'evidence/final-resource-scope.json',rel/'evidence')]}],
  'run_registry':[rr(p)for p in registry],'counting_rule':'Unique event IDs; root wall direct elapsed; no CPU double-add for nested tool audits; no estimated parallel RSS.'}
 dump(rel/'evidence/workflow-costs.json',cost)
 # Single readable roll-up, beside the canonical problem rather than a new stage.
 with(rel/'problem/report.md').open('a')as f:f.write('\n[最终门禁与完整目标核验](../evidence/final-acceptance.json) · [汇总成本与共享记录](../evidence/workflow-costs.json)\n')
 print(json.dumps({'status':'complete','acceptance':rr(rel/'evidence/final-acceptance.json'),'report':rr(rel/'problem/report.md'),'workflow_costs':rr(rel/'evidence/workflow-costs.json'),
  'root_run':rr(root_archive),'admin_run':rr(admin_archive),'cache_files_removed':len(removed),'token_total':t['total_tokens'],'wall_seconds':tm['wall_seconds']},indent=2))
if __name__=='__main__':main()
