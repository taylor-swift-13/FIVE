#!/usr/bin/env python3
"""Publish final lowpass metadata only after exact current proof receipts pass.
Never edits .v, check.py, spec maps, CBMC/align artifacts or stage handoffs.
"""
from pathlib import Path
import argparse,hashlib,importlib.util,json,os,re,sys
from datetime import datetime
R=Path('/home/yangfp/five');sys.path.insert(0,str(R/'scripts'))
from example_proof_gate import validate_current
MAIN=R/'_build/lowpass-recovery-work/20261106T192316-c89d343f94/five-rocq'
SESSION=Path('/mnt/c/Users/50635/.codex/sessions/2026/11/07/rollout-2026-11-07T02-22-16-01a1b218-dcc5-74a0-b1f1-89c18851c460.jsonl')
OWN=Path((R/'_build/lowpass-execution-worker/final-metadata-active.txt').read_text().strip())
ENTRIES=['init_first_order_low_pass','update_first_order_low_pass_tau','reset_first_order_low_pass']
KINDS=['no_error','functional','termination','execution_correspondence','cbmc_recheck']
REL=R/'paparazzi/relations/lowpass_recovery'
PROBLEMS=[R/'paparazzi/models'/e/'rocq'/k/'problem' for e in ENTRIES for k in KINDS]+[REL/'problem']
OWNED=[p for p in PROBLEMS if p==REL/'problem' or p.parent.name in ['no_error','functional','termination']]
HISTORICAL=[R/'paparazzi/models'/e/'rocq/termination/attempts/001' for e in ENTRIES]
OLD=R/'_build/lowpass-recovery-work/20261106T184407-e47c999b12/five-rocq'
COST_INDEX=OWN/'evidence/final-proof-shared-costs.json'
def read(p):return json.loads(Path(p).read_text())
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def dump(p,data):p=Path(p);p.parent.mkdir(parents=True,exist_ok=True);p.write_text(json.dumps(data,indent=2)+'\n')
def relative(p,base):return os.path.relpath(p,base).replace(os.sep,'/')
def link(label,p,base):return '['+label+']('+relative(p,base)+')'
def active(p):s=read(p/'status.json');return (p/s['active_attempt']).resolve(),s
def validator():
 s=importlib.util.spec_from_file_location('unchanged_reference_validator',R/'scripts/check-example-artifacts.py');m=importlib.util.module_from_spec(s);s.loader.exec_module(m);return m.Validator(R)
def stamp(s):return datetime.fromisoformat(s.replace('Z','+00:00'))
def runtime(run):
 d=read(run/'run.json');start=stamp(d['started_at']);end=stamp(d['finished_at']);all_rows=[]
 for line in SESSION.read_text().splitlines():
  o=json.loads(line)
  if o.get('type')=='turn_context':
   x=o['payload'];all_rows.append({'type':'turn_context','timestamp':o.get('timestamp'),'model':x.get('model'),'effort':x.get('effort')})
 chosen=[x for x in all_rows if start<=stamp(x['timestamp'])<=end]
 preceding=[x for x in all_rows if stamp(x['timestamp'])<=start]
 if preceding:chosen=[preceding[-1]]+chosen
 assert chosen and all(x['model']=='gpt-6.1-sol' and x['effort']=='medium' for x in chosen),'Actual model/effort mismatch or missing receipt'
 p=OWN/'evidence'/('main-runtime-'+d['run_id']+'.json');dump(p,{'session_source':str(SESSION),'run':str(run.relative_to(R)),'scope':'Whitelisted actual turn_context configuration at the run boundary and within its interval; no conversation or reasoning exported.','selected_runtime_metadata':chosen});return p

def physical_run(run):
 d=read(run/'run.json');assert d['status']=='passed','Required formal run is not CLOSED passed: '+str(run)
 for x in d.get('inputs',[]):
  assert x.get('sha256'),'Missing actual captured file digest'
  physical=run/x['path'];assert physical.is_file() and sha(physical)==x['sha256'],'Physical captured input SHA mismatch: '+str(physical)
  source=Path(x['source']);assert source.is_file() and sha(source)==x['sha256'],'Captured source changed: '+str(source)
 return d

def gate():
 physical_run(MAIN);seen={MAIN};rows=[]
 for p in PROBLEMS:
  a,s=active(p);data=read(a/'evidence/goal-validation.json');receipt=read(R/data['kernel_evidence']);run=R/receipt['run']
  if p in OWNED:assert run==MAIN and data['certificate']['run']==str(MAIN.relative_to(R)),'Main active goals do not bind fresh current formal run: '+str(p)
  else:assert s['status']=='proved','Other owner must close current problem first: '+str(p)
  if run not in seen:physical_run(run);seen.add(run)
  validate_current(R,p.resolve(),a,{**s,'status':'proved'})
  if p.parent.name=='cbmc_recheck':
   props=read(p.parents[2]/'cbmc/properties.json');assert len(s['requested_goals'])==len(props) and all(x['status']=='SUCCESS' for x in props)
  rows.append({'problem':str(p.relative_to(R)),'active_attempt':str(a.relative_to(R)),'goals':s['requested_goals'],'spec_sha256':sha(p/'Spec.v'),'proof_sha256':sha(a/'Proof.v'),'validation_sha256':sha(a/'evidence/goal-validation.json'),'run':str(run.relative_to(R))})
 assert len(rows)==16
 return rows

def write_cost_index():
 explicit=[MAIN,OLD,R/'_build/lowpass-recovery-work/20261106T190518-8d27304b10/five-rocq',R/'_build/lowpass-recovery-work/20261106T190222-912614879e/five-rocq',R/'_build/lowpass-recovery-work/20261106T191900-099f8ec038/five-rocq',R/'runs/20261106T182428-935707452d/five-rocq',R/'runs/20261106T190214-4df2f61493/five-rocq',R/'_build/lowpass-execution-worker/20261106T182525-bd199eec90/five-rocq',R/'_build/lowpass-execution-worker/20261106T182650-71719bc71d/five-rocq',R/'_build/lowpass-execution-worker/20261106T184023-8bd0fac8b2/five-rocq',OWN]
 for p in PROBLEMS:
  a,s=active(p);v=a/'evidence/goal-validation.json'
  if v.exists():explicit.append(R/read(R/read(v)['kernel_evidence'])['run'])
 rows=[]
 for run in dict.fromkeys(explicit):
  assert (run/'metrics.json').is_file(),run
  m=read(run/'metrics.json');d=read(run/'run.json');t=m['time'];tok=m['tokens'];mem=m['memory'];closed=d['status']!='running'
  rows.append({'stage':'five-rocq','run':str(run.relative_to(R)),'run_id':d['run_id'],'status':'recorded','run_outcome':d['status'],'time':{'wall_seconds':t.get('wall_seconds') if closed else None,'tool_cpu_seconds':t.get('cpu_tool_seconds') if closed else None,'observed_recorded_tool_cpu_seconds':t.get('cpu_recorded_tool_seconds') if closed else None},'token':{k:(tok.get(v) if closed else None) for k,v in [('input','input_tokens'),('output','output_tokens'),('total','total_tokens'),('cached_input','cached_input_tokens'),('reasoning_output','reasoning_output_tokens')]},'memory':{'tool_peak_rss_bytes':mem.get('peak_process_tree_rss_sampled_bytes') if closed else None},'evidence':[relative(run/'run.json',COST_INDEX.parent),relative(run/'metrics.json',COST_INDEX.parent)],'evidence_sha256':{relative(q,COST_INDEX.parent):sha(q) for q in [run/'run.json',run/'metrics.json']} if closed else {},'measurement_scope':'Actual shared run; no exclusive per-problem allocation. Active metadata run has null pending allocations with final raw receipts linked.' if not closed else 'Immutable actual shared metrics, including failures and retries; unknown observed totals remain null and raw observed subtotals are retained.','raw_measurement_status':m.get('measurement_status'),'cost_audit':d.get('cost_audit'),'missing_reason':'Historical timeout killed GNU time where stated; short diagnostics may lack samples; physical-capture-invalid runs are not accepted proofs. No replay repairs missing historical resources.'})
 support=R/'paparazzi/report/lowpass_recovery/support/retune_reset/costs.json'
 dump(COST_INDEX,{'schema':'five-stage-costs/1','records':rows,'additional_shared_costs':{'path':str(support.relative_to(R)),'sha256':sha(support)},'setup_usage_index':str((R/'paparazzi/report/lowpass_recovery/cost-inputs/setup-prefix-index.json').relative_to(R)),'aggregation':'Reference shared evidence once. Token event-ID union; tool identity (run_id,command_id), including cloned receipts, counted once. Wall is measured end-to-end, never summed across overlaps. Combined concurrent RSS is unknown. Setup prefixes remain setup_unattributed; unmetered setup/diagnostic CPU/RSS are unknown, never zero.'})

def cost_row(a,receipt,run=MAIN):
 return {'schema':'five-stage-costs/1','records':[{'stage':'five-rocq','run':str(run.relative_to(R)),'status':'recorded','time':{'wall_seconds':None,'tool_cpu_seconds':None},'token':dict.fromkeys(['input','output','total','cached_input','reasoning_output']),'memory':{'tool_peak_rss_bytes':None},'agent':{'model':'gpt-6.1-sol','requested_reasoning_effort':'medium','actual_reasoning_effort':'medium','evidence':relative(receipt,a)},'shared_costs':relative(COST_INDEX,a),'evidence':[relative(run/'metrics.json',a),relative(run/'run.json',a)],'measurement_scope':'No independent exclusive problem allocation existed. Null values are unallocated, not zero; exact actual shared stage metrics, historical failures, source-worker cost links and event IDs are in the shared cost index. Never sum shared records once per problem.'}]}

ASSUMPTIONS='The actual theorem-specific Print Assumptions output is retained in the bound compile and GoalBinding stdout logs. Across these dependencies, printed inherited declarations include ClassicalDedekindReals.sig_not_dec, ClassicalDedekindReals.sig_forall_dec, FunctionalExtensionality.functional_extensionality_dep and Classical_Prop.classic. SourceGuards receipts additionally expose CompCert external_functions_sem and inline_assembly_sem semantic parameters; inspect each theorem receipt for its exact subset. No new goal axiom or admitted proof is introduced.'
BOUNDARY='Target: CompCert 3.17 original Csyntax/Csem/Cexec, x86-64 Linux standard ABI, little endian, IEEE binary32 nearest ties-to-even and manifest-bound CompCert/Archi NaN policy. C frontend/source export and inherited library semantics remain the trusted boundary. No GCC, native-hardware, or cross-tool NaN-payload equivalence is claimed.'
HISTORY='Prior main run184407-e47c999b12 contains real memory-proof development and invalid nested termination command indices; main run190518-8d27304b10 contains real mathematical work but invalid physical captures caused by basename collisions. Both remain CLOSED failed and are not accepted proof evidence. Current fresh run192316-c89d343f94 binds independently checked exact source snapshots, physical copies and typed GoalBinding certificates. Correction run190222-912614879e and physical-copy preflight191900-099f8ec038 remain separate successful evidence. Historical termination attempt001 retains its report/sources/receipts and is not accepted; active002 governs the current termination claim.'
COST_NOTE='Costs record exact real shared token events, elapsed intervals and observed tool receipts. The first main120second memory compilation timeout lost its GNU time CPU receipt; the full CPU total stays null, with the actually observed subtotal retained. Source support costs retain their original unmetered direct-diagnostic CPU/RSS caveat. Other missing samples and setup CPU/RSS remain unknown. No post-hoc per-problem split, resource estimate, or replay substitutes them. Raw telemetry terminology is preserved in machine receipts.'
FUNCTIONAL={
 'init_first_order_low_pass':'For every float32 tau,h,value and writable12 caller object, a normal Csem return exists and every normal return is Vundef with all twelve bytes equal to encode_val Mfloat32 of coefficient=(2.0f*tau)/h, value, value in source operation order. Every Mem.loadbytes observation outside that twelve-byte interval on initially valid blocks is unchanged.',
 'update_first_order_low_pass_tau':'For every float32 tau,h and writable12 caller object, a normal Csem return exists and every normal return is Vundef with the first four bytes equal to encode_val Mfloat32 of coefficient=(2.0f*tau)/h in source operation order. All Mem.loadbytes observations outside those first four bytes on initially valid blocks are unchanged, including both previous fields even when their bytes are unknown.',
 'reset_first_order_low_pass':'For every float32 value and writable12 caller object, a normal Csem return exists and every normal return is Vsingle value with the eight bytes at offsets4..11 equal to two encode_val Mfloat32 copies of value. Every Mem.loadbytes observation outside that eight-byte interval on initially valid blocks is unchanged, including the prior coefficient bytes even when unknown.'}
PRE='writable12 means four-byte alignment of Ptrofs.unsigned p, p+12 within the pointer modulus without wrapping, and current Writable permission across all twelve bytes. The safety precondition additionally fixes the typed pointer/float argument list. It requires no initialized old field, finite value, nonNaN value or nonzero sample time. Unknown memvals remain unknown in frame observations.'

def identity_table(case,p,a):
 items=[('prepared C',case/'prepare/source'/(case.name+'.c')),('Source.v',case/'align/model/Source.v'),('Execution.v',case/'align/model/Execution.v'),('manifest',case/'align/model/compcert-manifest.json'),('canonical Spec.v',p/'Spec.v'),('active Proof.v',a/'Proof.v')]
 contract=case/'rocq/support/Contract.v'
 if contract.exists():items.append(('explicit Contract.v',contract))
 return '\n'.join('| '+label+' | '+sha(q)+' |' for label,q in items)

def planned_reports(runtime_current,runtime_old):
 files={}
 for p in OWNED:
  a,s=active(p);base=a;case=p.parents[2] if p!=REL/'problem' else R/'paparazzi/models/init_first_order_low_pass';kind=p.parent.name if p!=REL/'problem' else 'relation';entry=REL.name if kind=='relation' else case.name
  if kind=='functional':scope=FUNCTIONAL[entry]+' Nonvacuity supplies an actual writable object witness. NormalCompletion gives return existence; AllReturns quantifies every trace and normal return.'
  elif kind=='no_error':scope='For every typed argument list and memory satisfying the explicit Precondition, no_error holds for every state reachable through original Csem execution. This is all-reachable-state safety; it does not select one evaluation order or one successful path. '+PRE
  elif kind=='termination':scope='For every raw list val argument list and arbitrary CompCert memory, including malformed calls and invalid or uninitialized states, Acc(successor Execution.ge)(Execution.entry args m) holds. This covers every original Csem successor and evaluation order, with no fuel or fixed step bound. Safety is separately established under its explicit precondition.'
  else:scope='For arbitrary tau,h,value and two independent writable12 caller objects/memories, retune followed by reset and direct init both have normal completions. Every pair of normal executions has exact return values (Vundef,Vsingle value,Vundef), identical twelve-byte encode_val coefficient/value/value observations, preserved writable objects and unchanged Mem.loadbytes frames outside each twelve-byte caller region on initially valid blocks. Nonvacuity constructs distinct blocks with writable objects. Coefficient arithmetic retains all float32 inputs and the fixed CompCert NaN policy.'
  if kind=='relation':ids='\n\nParticipating model/source hashes:\n\n'+ '\n\n'.join('**'+e+'**\n\n| Artifact | SHA256 |\n|---|---|\n'+identity_table(R/'paparazzi/models'/e,p,a) for e in ENTRIES)
  else:ids='\n\n| Artifact | SHA256 |\n|---|---|\n'+identity_table(case,p,a)
  data=read(a/'evidence/goal-validation.json');receipt=read(R/data['kernel_evidence']);run=R/receipt['run'];commands=read(run/'run.json')['commands'];cert=data['certificate'];compile_cmd=next(c for c in commands if c['id']==cert['compile_command_id']);assumptions=run/compile_cmd['stdout']
  text='# '+entry+': '+kind+' current proof\n\nProved requested goals: '+', '.join(s['requested_goals'])+'.\n\n'+scope+'\n\n'+(PRE+'\n\n' if kind in ['functional','relation'] else '')+BOUNDARY+'\n\nCanonical question: '+link('Spec.v',p/'Spec.v',base)+'; checked proof: '+link('Proof.v',a/'Proof.v',base)+'; reproducible cold checker: '+link('check.py',a/'check.py',base)+'. Default check.py rebuilds the full source dependency closure in an empty temporary directory and performs independent kernel checking; no repository .vo cache supplies proof dependencies.\n\n'+link('Current exact theorem/type and physical-snapshot bindings',a/'evidence/goal-validation.json',base)+'; '+link('independent kernel evidence',R/data['kernel_evidence'],base)+'; '+link('typed GoalBinding Print Assumptions output',assumptions,base)+'. Actual direct compile/kernel command IDs are in these receipts.\n\nActual worker runtime: gpt-6.1-sol, requested and observed medium, '+link('whitelisted actual configuration receipt',runtime_current,base)+'.\n\n'+ASSUMPTIONS+'\n\n'+HISTORY+'\n\n'+COST_NOTE+' See '+link('costs',a/'costs.json',base)+' and its shared metrics links.'+ids+'\n'
  names=sorted({name for name in re.findall(r'^([A-Za-z_][A-Za-z_0-9.]*)[ \t]*:',assumptions.read_text(),flags=re.M) if '.' in name or '_' in name})
  text+='\nExact printed declaration names for this certificate: '+(', '.join('`'+name+'`' for name in names) if names else 'no names parsed; the linked actual stdout remains authoritative')+'. Print Assumptions stdout SHA256: '+sha(assumptions)+'.\n'
  files[a/'report.md']=text;files[a/'costs.json']=cost_row(a,runtime_current)
 for a in HISTORICAL:
  if not (a/'costs.json').exists():files[a/'costs.json']=cost_row(a,runtime_old,OLD)
 for e in ENTRIES:
  case=R/'paparazzi/models'/e;stage=case/'rocq/report';props=read(case/'cbmc/properties.json');count=len(props);rows=[]
  for k in KINDS:
   p=case/'rocq'/k/'problem';a,s=active(p);rows.append('| '+k+' | '+link('question',p/'Spec.v',stage)+' | '+link('active proof report',a/'report.md',stage)+' | '+str(len(s['requested_goals']))+' |')
  text='# '+e+': Rocq evidence\n\nAll five canonical questions are proved under their stated scopes: no-error1, functional3, termination1, execution correspondence8, plus '+str(count)+' independent actual CBC property rechecks. The three cases jointly cover all24 raw execution correspondence goals and the final77 actual CBC IDs (31/19/27).\n\n| Problem | Canonical question | Current proof | Requested goals |\n|---|---|---|---|\n'+'\n'.join(rows)+'\n\n'+FUNCTIONAL[e]+'\n\n'+PRE+'\n\nSafety quantifies every reachable original Csem state under the typed/writable precondition. Termination is Acc for every successor for all raw argument lists and arbitrary memory. Functional questions separately establish existence, all normal returns and a nonempty precondition. Raw Cexec/Csem correspondence retains all operations, traces, values, byte changes and error prefixes without cutting down the input/memory model.\n\nFinal CBC scope is all original source/memcpy safety guards and complete binary32-bit init value copies, retune frame fields and reset return/copies/frame. CBC does not claim coefficient arithmetic equality; all original/guarded arithmetic CBC attempts remain unresolved history. The unrestricted exact original-model coefficient theorem is independently established in the functional proof above. Each of the '+str(count)+' actual CBC IDs has its own canonical Rocq recheck goal; CBC results are not axioms.\n\n'+BOUNDARY+'\n\n'+ASSUMPTIONS+'\n\n'+HISTORY+'\n\n'+COST_NOTE+'\n\n'+link('Shared actual source-proof support costs',R/'paparazzi/report/lowpass_recovery/support/retune_reset/costs.json',stage)+'; '+link('stage cost references',stage/'costs.json',stage)+'; '+link('conditional cross-model relation',REL/'problem/Spec.v',stage)+'.\n'
  files[stage/'report.md']=text
  files[stage/'costs.json']={'schema':'five-stage-costs/1','records':[{'stage':'five-rocq','run':str(MAIN.relative_to(R)),'status':'recorded','time':dict.fromkeys(['wall_seconds','tool_cpu_seconds']),'token':dict.fromkeys(['input','output','total','cached_input','reasoning_output']),'memory':{'tool_peak_rss_bytes':None},'shared_costs':relative(COST_INDEX,stage),'evidence':[relative(MAIN/'metrics.json',stage),relative(R/'paparazzi/report/lowpass_recovery/support/retune_reset/costs.json',stage)],'measurement_scope':'Shared authoring/dependency/proof/check costs are not exclusive case allocations. Actual records and event IDs are linked once; unknown historical CPU/RSS remains null with observed subtotal preserved.'}]}
  if all((case/s/'report/report.md').exists() or s=='rocq' for s in ['prepare','cbmc','align','rocq']):
   files[case/'README.md']='# '+e+'\n\nAll current requested canonical proof goals are proved. Safety/functional preconditions, unrestricted raw termination and execution correspondence, exact byte/frame observations, independent CBC rechecks and actual cost limitations are specified in the reports. CBC covers safety/copy/frame/reset; unrestricted coefficient arithmetic is a separate Rocq theorem.\n\n| Stage | Canonical report |\n|---|---|\n'+'\n'.join('| '+s+' | '+link('report',case/s/'report/report.md',case)+' |' for s in ['prepare','cbmc','align','rocq'])+'\n\n'+link('Cross-model recovery relation',REL/'problem/Spec.v',case)+'.\n'
 return files

def publish():
 try:rows=gate()
 except BaseException as error:
  failures=OWN/'evidence/prepublish-gate-failures';failures.mkdir(parents=True,exist_ok=True)
  dump(failures/('attempt-'+str(len(list(failures.glob('attempt-*.json')))+1).zfill(3)+'.json'),{'schema':'five-metadata-prepublish-failure/1','status':'failed','error_type':type(error).__name__,'error':str(error),'case_metadata_changed':False,'formal_run':str(MAIN.relative_to(R)),'finalizer_sha256':sha(Path(__file__))})
  raise
 current=runtime(MAIN);old=runtime(OLD);write_cost_index();files=planned_reports(current,old)
 for p in OWNED:
  a,s=active(p);new={**s,'status':'proved','packaging_note':'Current fresh active attempt is accepted against CLOSED passed formal run192316-c89d343f94 with exact physical input SHA, typed GoalBinding and independent kernel receipts. Historical invalid receipts remain unaccepted.'};files[p/'status.json']=new
 previous={p:(p.read_bytes() if p.exists() else None) for p in files}
 try:
  for p,value in files.items():
   assert p.suffix!='.v' and p.name!='check.py' and '/align/' not in str(p) and '/cbmc/' not in str(p),'Forbidden edit target'
   if isinstance(value,dict):dump(p,value)
   else:p.parent.mkdir(parents=True,exist_ok=True);p.write_text(value)
  v=validator()
  for p in PROBLEMS:
   a,s=active(p);v.proof_problem(p);v.costs(a/'costs.json',proof=True);v.links(p/'report.md');v.links(a/'report.md');validate_current(R,p.resolve(),a,s)
  for e in ENTRIES:
   c=R/'paparazzi/models'/e;v.links(c/'rocq/report/report.md');v.costs(c/'rocq/report/costs.json')
   if c/'README.md' in files:v.links(c/'README.md')
  assert not v.errors,'\n'.join(v.errors)
  gate();dump(OWN/'evidence/final-all16-validation.json',{'schema':'five-final-problem-validation/1','status':'passed','unchanged_validator':str((R/'scripts/check-example-artifacts.py').relative_to(R)),'proof_gate':str((R/'scripts/example_proof_gate.py').relative_to(R)),'problems':rows,'all16_current_receipts':True,'published_files':[str(p.relative_to(R)) for p in files]})
 except BaseException as error:
  for p,value in previous.items():
   if value is None:p.unlink(missing_ok=True)
   else:p.write_bytes(value)
  failure_dir=OWN/'evidence/metadata-failures';failure_dir.mkdir(parents=True,exist_ok=True)
  dump(failure_dir/('attempt-'+str(len(list(failure_dir.glob('attempt-*.json')))+1).zfill(3)+'.json'),{'schema':'five-metadata-publish-failure/1','status':'failed','error_type':type(error).__name__,'error':str(error),'metadata_rolled_back':True,'formal_run':str(MAIN.relative_to(R)),'finalizer_sha256':sha(Path(__file__)),'verified_problems_before_metadata':rows,'planned_paths':[str(p.relative_to(R)) for p in files]})
  raise
 print('All16 original strict problem/cost/link/goal validators passed;10 main statuses and final reports published. No mathematical/checker/spec-map/CBMC/align source edited.')

if __name__=='__main__':
 parser=argparse.ArgumentParser();parser.add_argument('--publish',action='store_true');parser.add_argument('--cost-index-only',action='store_true');args=parser.parse_args()
 if args.publish:publish()
 elif args.cost_index_only:write_cost_index();print(COST_INDEX)
 else:
  d=read(MAIN/'run.json');print('Finalizer prepared. Required main run status:',d['status']);print('Owned main problems:',len(OWNED),'total exact problems:',len(PROBLEMS));print('No publication performed. Main authorization and passed closed current receipts required.')
