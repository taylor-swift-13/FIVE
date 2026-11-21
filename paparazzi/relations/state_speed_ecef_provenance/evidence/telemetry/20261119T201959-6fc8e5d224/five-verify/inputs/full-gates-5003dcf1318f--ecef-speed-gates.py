from pathlib import Path
import hashlib,json,sys
r=Path('/home/yangfp/five');sys.path.insert(0,str(r/'scripts'))
from five_telemetry import Run
admin=Run((r/'_build/state-speed-ecef-provenance/admin-run.txt').read_text().strip())
if '--inner'not in sys.argv:
 admin.capture(Path(__file__),'full-gates-'+hashlib.sha256(Path(__file__).read_bytes()).hexdigest()[:12],area='inputs')
 c=admin.command(['python3',str(Path(__file__)),'--inner'],'final-official-compcert-acceptance-all-three-cases',timeout=600,cwd=r)
 print((admin.folder/c['stdout']).read_text());print((admin.folder/c['stderr']).read_text());raise SystemExit(c['exit_code'])
import compcert_gate
original=compcert_gate.kernel_record;cached={}
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def once(root,ref):
 p=(Path(root)/ref).resolve();key=(str(p),sha(p))
 if key not in cached:cached[key]=original(root,ref)
 return dict(cached[key])
compcert_gate.kernel_record=once
results=[]
for name in ('stateSetSpeedNed_i','stateSetSpeedEcef_i','stateGetSpeedEcef_f'):
 case=r/'paparazzi/models'/name;handoff=json.loads((case/'rocq/handoff.json').read_text())
 rows=[x for x in handoff['outputs']if x['role']=='execution-contract'];assert len(rows)==1
 request=case/'prepare/report/request.json'
 result=compcert_gate.accept_compcert_delivery(r,
  request_path=str(request.relative_to(r)),expected_request_sha256=sha(request),
  contract_path=str((case/rows[0]['path']).relative_to(r)),
  manifest_path=str((case/'align/model/compcert-manifest.json').relative_to(r)),
  spec_recheck_path=str((case/'rocq/spec-recheck.json').relative_to(r)))
 results.append({'case':name,**result})
# All per-property/entry checks above execute; identical immutable kernel
# receipts are fully validated once, and their bound bytes are rechecked here.
for hashes in cached.values():
 for name,want in hashes.items():
  p=Path(name);p=p if p.is_absolute()else r/p
  assert sha(p)==want,('Changed during final gate',str(p))
print(json.dumps({'official_gate_function':'compcert_gate.accept_compcert_delivery','results':results,'all_accepted':all(x['status']=='accepted'for x in results)},indent=2))
