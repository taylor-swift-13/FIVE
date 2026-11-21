from pathlib import Path
import json,hashlib,sys
ROOT=Path('/home/yangfp/five')
RUN=ROOT/'runs/20261119T190556-2b2df62cd4/five-rocq'
sys.path.insert(0,str(ROOT/'scripts'))
from five_telemetry import Run
run=Run(RUN)
scope=json.loads((ROOT/'_build/state-speed-ecef-provenance/setter-goal-bindings.json').read_text())
def h(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def write(p,s):p.parent.mkdir(parents=True,exist_ok=True);p.write_text(s)
def js(p,o):write(p,json.dumps(o,indent=2,ensure_ascii=False)+'\n')
session=Path('/mnt/c/Users/50635/.codex/sessions/2026/11/19/rollout-2026-11-19T12-16-55-01a1f205-99b5-72c0-9ccc-9dffc94ac154.jsonl')
contexts=[]
for line in session.open():
 try:row=json.loads(line)
 except json.JSONDecodeError:continue
 if row.get('type')=='turn_context':
  p=row.get('payload',{});eff=p.get('effort',p.get('reasoning_effort'))
  contexts.append({'timestamp':row.get('timestamp'),'model':p.get('model'),'effort':eff})
runtime={'schema':'five-runtime-config-evidence/1','session_id':'01a1f205-99b5-72c0-9ccc-9dffc94ac154','session':str(session),'requested_model':'gpt-6.1-sol','requested_reasoning_effort':'ultra','actual_contexts':contexts,'scope':'Runtime metadata only; no message or reasoning text exported.'}
js(RUN/'evidence/runtime-config.json',runtime)
sharedref={'schema':'five-stage-costs/1','records':[{'stage':'five-rocq','run':'runs/20261119T190556-2b2df62cd4/five-rocq','status':'shared-record','agent':{'model':'gpt-6.1-sol','requested_reasoning_effort':'ultra','actual_reasoning_effort':'ultra','evidence':'runs/20261119T190556-2b2df62cd4/five-rocq/evidence/runtime-config.json'},'measurement_scope':'One shared two-setter authoring session, including specification construction, failures, timeouts, development compilation and reporting. Reference once in aggregate; no per-case or per-problem allocation. Final raw metrics are in the closed shared run.','time':{'wall_seconds':None,'tool_cpu_seconds':None},'token':{'input':None,'output':None,'total':None,'cached_input':None,'reasoning_output':None},'memory':{'tool_peak_rss_bytes':None,'tool_max_individual_process_rss_bytes':None},'unobserved_reason':'No separate per-case/problem boundaries. One command059 collision also lost original GNU timing, so complete historical tool CPU/peak cannot be reconstructed; raw surviving resources are retained as a measured subset.','evidence':['runs/20261119T190556-2b2df62cd4/five-rocq/metrics.json','runs/20261119T190556-2b2df62cd4/five-rocq/evidence/command-059-collision.json']},{'stage':'five-rocq','run':'runs/20261119T190859-f7887a34ba/five-rocq','status':'shared-reference','measurement_scope':'Separate actual Ultra GuardShell author. Shared by all three cases; count once globally. Not included in setter authoring run.','shared_costs':'runs/20261119T190859-f7887a34ba/five-rocq/metrics.json'}]}
descriptions={
'no_error':('Safety and original normal return','For every explicit InputGood accepted call, every original Csem reachable state avoids source_error. A genuine finite original call returns Vundef, writes all three words and the exact status, supplies all 12 encoded bytes, preserves the source input and permissions of every pre-existing block, and preserves arbitrary byte intervals outside the actual State vector/status writes. Every normal final memory equals this constructed result. No future return or desired output is assumed.'),
'termination':('All-successor termination','All raw argument lists and all CompCert memories satisfy Acc for the reverse successor relation of original Csem.step at the original entry. The source is loop-free and call-free; expression/statement ranks strictly decrease on every successor. This is independent of the legitimate accepted-call safety precondition.'),
'execution_correspondence':('Eight execution correspondence obligations','The emitted Cexec relation and original Csem have the same reachable one-step and finite-star executions for all raw arguments and memories. The eight obligations bind source-domain preservation, floating-point and machine-integer steps, memory accesses, control/exhaustion, exact normal result and full byte observation, invalid operations, and whole executions. There is no execution-domain filter or replacement C recurrence.'),
'cbmc_recheck':('All 32 original CBMC IDs','The exact actual emitted CBMC IDs are independently rechecked with explicit Rocq formulas: eight memset/memcpy memory and guarded comparison conditions; copy with genuine normal-return existence and universal final-memory uniqueness; exact selected status; the State/before byte-loop pointer, bound and load guards for every index0..655; full byte-frame equality; and six distinct source-pointer guards for each of x/y/z together with all-reachable original Csem safety. HarnessPreparationGoal constructs the original zero/filter/snapshot setup from raw legal memory. No CBMC result is used as an axiom.')}
for p in scope['problems']:
 problem=ROOT/p['problem'];attempt=ROOT/p['attempt'];folder=problem.parent.name
 title,description=descriptions[folder]
 requested=[b['requested_goal']for b in p['bindings']]
 js(problem/'status.json',{'schema':'five-proof-problem/1','status':'pending','active_attempt':'../attempts/001','specification':'Spec.v','requested_goals':requested})
 write(problem/'report.md',f'{title}.\n\n{description}\n\nThe canonical specification is Spec.v; attempt001 provides the proof. Current acceptance is determined by status.json and the typed goal/kernel receipts in the active attempt.\n')
 write(attempt/'report.md',f'{title}.\n\n{description}\n\nDevelopment compilation used direct Rocq argv under a 3GiB inherited address-space cap. Print Assumptions exposes only inherited CompCert/Flocq, classical and extensionality declarations; the source has no external calls. The final shared checker snapshots the current dependency closure, recompiles it cold, binds every requested theorem to its exact type, and independently kernel checks proof and certificate.\n\nAll actual authoring retries remain in shared run20261119T190556-2b2df62cd4. Command059 had an accidental concurrent-writer collision: surviving raw logs and the full incident are preserved, and missing historical CPU/peak metrics remain unknown. No per-problem token allocation is invented. See costs.json and the shared raw run.\n')
 js(attempt/'costs.json',sharedref)
for case,ns,offset,status in [('stateSetSpeedNed_i','StateSpeedSetNedI',296,2),('stateSetSpeedEcef_i','StateSpeedSetEcefI',284,1)]:
 base=ROOT/'paparazzi/models'/case;rocq=base/'rocq'
 ledger=json.loads((base/'align/spec-map.json').read_text())
 ledger['schema']='five-cbmc-rocq-recheck/1';ledger['status']='pending'
 ledger['harness_preparation']={'theorem':ns+'RecheckAttempt001.Proof.proved_harness_preparation','goal':ns+'RecheckProblem.Spec.HarnessPreparationGoal','scope':'Actual 656-byte zeroing, ANY filter store, full State snapshot load and copy into a distinct live caller buffer, with source input preserved.'}
 for i,p in enumerate(ledger['properties']):
  p['status']='pending';p['proof_status']='pending'
  p['theorem']=ns+f'RecheckAttempt001.Proof.proved_property_{i}'
  p['proof_declaration']=f'paparazzi/models/{case}/rocq/cbmc_recheck/attempts/001/Proof.v'
  p['goal_type']=ns+f'RecheckProblem.Spec.property_{i}'
  p['evidence']=[]
  p['scope']['input_preconditions']='RawHarnessGood legal distinct full State/source/before regions for library guards; HarnessGood derived by harness_preparation for original call and observations. Source int32 words arbitrary; accepted_id is ANY.'
  p['scope']['state_layout']={'size':656,'status':[280,282],'selected_vector':[offset,offset+12],'selected_status':status}
  if i in [2,3]:p['scope']['guard_mapping']='Actual CBMC builtin memcpy source first disjunct is POINTER_OBJECT(dst)!=POINTER_OBJECT(src). Distinct CompCert blocks discharge it; cross-object ordering is never assumed.'
  if i>=14:p['scope']['guard_mapping']='The six CBMC pointer tags map to null-constructor exclusion, live block, Max nonempty permission, Cur nonempty permission, typed word access/range/representable offset, and exclusion of integer-address constructors. Every guard additionally carries no_error for all original Csem reachable states.'
 js(rocq/'spec-recheck.json',ledger)
 contract=json.loads((base/'align/execution-contract.json').read_text())
 contract['status']='pending';contract['source_contract']='align/execution-contract.json'
 names={b['requested_goal']:b for p in scope['problems']if p['problem']==f'paparazzi/models/{case}/rocq/execution_correspondence/problem'for b in p['bindings']}
 for obligation in contract['obligations']:
  key=obligation['id'].replace('-','_');obligation['theorem']=names[key]['theorem'];obligation['goal_type']=names[key]['type'];obligation['status']='pending';obligation['evidence']=[]
 js(rocq/'execution_correspondence/attempts/001/evidence/execution-contract.json',contract)
 write(rocq/'report/report.md',f'Original {case} accepted-call verification.\n\nThe original body and model are immutable. The only C exposure change is static-inline storage exposure; the body is unchanged. State uses the original656-byte layout, ushort filter/status and three int32 coordinates. InputGood states a State symbol, full State write permission, loaded ANY filter, three readable input words and source/State separation. The original call returns and copies to offsets{offset},{offset+4},{offset+8}, stores status{status}, preserves the input, all old permissions and all bytes outside the14 actual written bytes.\n\nNo-error covers every reachable original Csem state under InputGood. Acc termination and the eight execution-translation obligations cover the complete raw argument/memory domain. All32 actual original CBMC IDs are independently mapped and rechecked; the proof constructs the original zero/filter/snapshot harness preparation and covers every byte index0..655.\n\nDevelopment proofs compile under actual GPT-6.1 Sol Ultra. Final typed-goal and independent-kernel receipts are produced by the shared checker; canonical status files and spec-recheck.json record acceptance. No original source, CBMC harness/result or align artifact was modified. CompCert3.17 x86-64 Linux little-endian C semantics is the boundary; this stage asserts no compiled GCC or hardware equivalence.\n\nCosts are one shared two-setter authoring interval plus a separate GuardShell helper interval, each counted once globally. Command059 lost part of the historical timing due a writer collision; the surviving subset and incident are retained, so missing complete CPU/peak metrics remain null.\n')
 js(rocq/'report/costs.json',sharedref)
 frozen={str(p.relative_to(ROOT)):h(p)for p in rocq.rglob('*.v')if'evidence'not in p.parts}
 js(rocq/'report/evidence/source-freeze.json',{'schema':'five-proof-source-freeze/1','sha256':frozen,'validation':'Development compiled; final current-source closure certification is separate.'})
print('Drafted eight canonical problem/attempt records and both per-ID ledgers; statuses remain pending shared cold kernels.')
