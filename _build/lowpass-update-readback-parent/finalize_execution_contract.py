
from pathlib import Path
import json,hashlib
root=Path('/home/yangfp/five'); c=root/'paparazzi/models/update_first_order_low_pass'
sha=lambda p:hashlib.sha256(Path(p).read_bytes()).hexdigest()
ep=c/'rocq/execution_correspondence/attempts/001/evidence/gate-kernel-evidence.json'; e=json.loads(ep.read_text()); run=root/e['run']; metadata=json.loads((run/'run.json').read_text())
cmd=next(x for x in metadata['commands'] if x['id']==e['command_id'])
assert cmd['status']=='passed' and cmd['exit_code']==0 and len(e['theorems'])==8
sources=[c/'prepare/source/update_first_order_low_pass.c',c/'align/model/Source.v',c/'align/model/Execution.v']
matched={}
for p in sources:
 rows=[x for x in metadata['inputs'] if x.get('source')==str(p.resolve()) and x.get('sha256')==sha(p)]
 assert rows,('Original proof input not captured',str(p))
 for x in rows:
  physical=(run/x['path']).resolve();assert physical.is_relative_to(run) and sha(physical)==sha(p)
 key=str(p.relative_to(root)); matched[key]=sha(p); e['dependency_sha256'][key]=sha(p)
ep.write_text(json.dumps(e,indent=2)+chr(10))
old=root/'paparazzi/models/get_first_order_low_pass/rocq/execution-contract.json'
d=json.loads(json.dumps(json.loads(old.read_text())).replace('get_first_order_low_pass','update_first_order_low_pass').replace('FiveLowpassGet','FiveLowpassUpdate'))
d['request_sha256']=sha(c/'align/request.json'); d['backend_manifest_sha256']=sha(c/'align/model/compcert-manifest.json')
d['execution_entry']['source']=str((c/'align/model/Execution.v').relative_to(root)); d['execution_entry']['sha256']=sha(c/'align/model/Execution.v')
d['source_semantics']['source_sha256']=matched
d['source_semantics']['target']=json.loads((c/'align/model/compcert-manifest.json').read_text())['target']
assert d['domain_restrictions']==[] and len(d['obligations'])==8
for obligation in d['obligations']:
 assert obligation['status']=='proof-backed'; obligation['evidence']=[str(ep.relative_to(root))]
out=c/'rocq/execution-contract.json'; assert not out.exists(); out.write_text(json.dumps(d,indent=2)+chr(10))
assert json.loads(out.read_text())['execution_entry']['module']=='FiveLowpassUpdate.Execution'
print(json.dumps({'status':'aggregated-existing-eight-kernel-proofs','contract':str(out.relative_to(root)),'source_bindings':matched,'evidence':str(ep.relative_to(root)),'proof_run':str(run.relative_to(root)),'kernel_command':e['command_id']}))
