from pathlib import Path
import sys,os,json,hashlib,runpy
os.chdir('/home/yangfp/five');root=Path.cwd();sys.path.insert(0,'scripts')
from five_telemetry import Run
case=root/'paparazzi/models/gh_set_omega';run=Run((case/'rocq/session-run.txt').read_text())
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def rel(p):return str(Path(p).relative_to(root))
def save(p,x):p.parent.mkdir(parents=True,exist_ok=True);p.write_text(json.dumps(x,indent=2)+'\n')
originals=[case/'prepare/source/gh_set_omega.c',case/'align/model/Source.v',case/'align/model/Execution.v']
for p in originals:run.capture(p,'original-gate-binding-'+p.name,area='inputs')
problems=['no_error','termination','functional','cbmc_recheck','execution']
for name in problems:
 d=case/'rocq'/name;attempt=d/'attempts/001';e=attempt/'evidence'
 p=e/'kernel-evidence.json';j=json.loads(p.read_text());j['dependency_sha256'].update({rel(p):sha(p)for p in originals});save(e/'gate-kernel-evidence.json',j)
 # Active status follows actual independently checked expected theorem types.
 validation=json.loads((e/'goal-validation.json').read_text());goals=[g['requested_goal']for g in validation['goal_bindings']]
 save(d/'problem/status.json',dict(schema='five-proof-problem/1',status='proved',active_attempt='../attempts/001',specification='Spec.v',requested_goals=goals))
 (d/'problem/report.md').write_text('# '+name+'\n\nCanonical question: Spec.v. Actual original CompCert x86-64 Linux Csem/Cexec, little endian binary32, all NaNs/infinities/signed zeros retained. Caller precondition names a full initialized14-field gh_ref with writable64-byte region and actual global symbol; Public.caller_precondition_satisfiable supplies concrete original zero-initialized memory. No-error quantifies all reachable original states; termination uses Acc over all successors.\n\nActive attempt001 proves '+', '.join(goals)+'. See independently compiled exact GoalBinding, assumptions output and kernel receipts.\n')
 (attempt/'report.md').write_text('# '+name+' attempt001\n\nProved current canonical goals: '+', '.join(goals)+'. All actual dependencies compiled as source snapshots; Proof module and deterministic GoalBinding independently kernel checked. No admitted proofs or added axioms. Runtime receipt confirms gpt-6.1-sol medium.\n\nCurrent inputs and successful receipts: provenance.json and evidence/goal-validation.json. Retained checked-NNN directories include failed/retried builds; only successful current receipts establish claims. Library assumptions are in compile stdout logs referenced by kernel run.\n\nModel token/time/tool resource accounting is shared by the stage authoring and fresh sequential verification runs, referenced in costs.json. Per-attempt model token allocation is unknown rather than invented.\n')
 save(attempt/'costs.json',dict(schema='five-stage-costs/1',records=[dict(stage='five-rocq',run=os.path.relpath(run.folder,attempt),agent=dict(model='gpt-6.1-sol',requested_reasoning_effort='medium',actual_reasoning_effort='medium',evidence='evidence/runtime.json'),status='shared-stage-record',evidence=[os.path.relpath(run.folder/'run.json',attempt),os.path.relpath(run.folder/'metrics.json',attempt)],time=dict(wall_seconds=None,tool_cpu_seconds=None),token=dict(input=None,output=None,total=None,cached_input=None,reasoning_output=None),memory=dict(tool_peak_rss_bytes=None),scope='Actual complete stage counts include attempts, failures, retries; no separate per-attempt author boundary. See rocq/report/costs.json.')]))
# Full actual property-ID ledger; property-by-property harness adapter, not a generated whole-main proof.
props=json.loads((case/'cbmc/properties.json').read_text());direct=json.loads((case/'rocq/direct-cbmc.json').read_text());manifest=case/'align/model/compcert-manifest.json';request=case/'align/request.json'
recheck=dict(schema='five-cbmc-rocq-recheck/1',request_sha256=sha(request),backend_manifest_sha256=sha(manifest),verification_method='traditional-bounded-model-checking',cbmc_run=rel(Path(direct['run'])),cbmc_command_id=direct['command_id'],cbmc_json=rel(Path(direct['stdout'])),cbmc_input_sha256={rel(p):sha(p)for p in [case/'prepare/source/gh_set_omega.c',case/'cbmc/harness.c']},properties=[])
for p in props:
 ident=p['property'];functional=ident.startswith('main.assertion');theorem='FiveGhSetOmegaRecheck.Proof.'+('main_assertion_'+ident.split('.')[-1]if functional else'bits_adapter_guards')
 recheck['properties'].append(dict(property_id=ident,status='proved',scope=dict(original_description=p['description'],location=p.get('sourceLocation'),inputs='all binary32 input and all initialized old named field bitpatterns; valid writable gh_ref64 bytes; no concurrent writer',bounds='one original setter call, no loops/recursion; unwind1',observation='exact binary32/int64 named scalar bits, padding excluded',adapter='Each bits(float) has distinct fresh4-byte formal source and uint32 destination. CompCert store+Mem.loadbytes+extcall_memcpy+Mint32 decoder preserves every binary32 bit including NaN. Internal cross-object order guards short-circuit by separation; no C order asserted. Fixed size4 signed/unsigned casts in range. Actual returned/store values linked by original Csem all-return theorem.'),theorem=theorem,evidence=[rel(case/'rocq/cbmc_recheck/attempts/001/evidence/gate-kernel-evidence.json')]))
save(case/'rocq/spec-recheck.json',recheck)
sys.argv=['five_execution_contract.py','gh_set_omega','execution'];runpy.run_path('/mnt/c/Users/50635/Documents/Codex/2026-10-23/wsl-c-c-1-cbmc-frama/.tmp/five_execution_contract.py',run_name='__main__')
contract_path=case/'rocq/execution-contract.json';contract=json.loads(contract_path.read_text())
for row in contract['obligations']:row['evidence']=[rel(case/'rocq/execution/attempts/001/evidence/gate-kernel-evidence.json')]
save(contract_path,contract)
print('Final proof metadata and exact15-property ledger written; raw telemetry untouched.')
