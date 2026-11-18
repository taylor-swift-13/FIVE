
from pathlib import Path
import json,re,hashlib
root=Path('/home/yangfp/five'); c=root/'paparazzi/models/update_first_order_low_pass'
sha=lambda p:hashlib.sha256(Path(p).read_bytes()).hexdigest()
h=json.loads((c/'cbmc/handoff.json').read_text())
assert h['stage']=='cbmc' and h['status']=='passed'
for row in h['outputs']:
 p=(c/row['path']).resolve(); assert p.is_relative_to(c) and sha(p)==row['sha256'],row
ce=h['cbmc_evidence']; raw=json.loads((root/ce['json']).read_text())
actual=[v for row in raw if 'result' in row for v in row['result']]
props=json.loads((c/'cbmc/properties.json').read_text())
assert len(props)==36 and len({p['property'] for p in props})==36
assert {p['property']:p for p in props}=={p['property']:p for p in actual}
meta=json.loads((root/ce['run']/'run.json').read_text())
cmd=next(x for x in meta['commands'] if x['id']==ce['command_id'])
assert cmd['status']=='passed' and cmd['exit_code']==0 and Path(cmd['argv'][0]).name=='cbmc'
assert not any('contract' in x for x in cmd['argv'])
spec=c/'rocq/cbmc_recheck/problem/Spec.v'; text=spec.read_text()
source_hash={str((c/p).relative_to(root)):sha(c/p) for p in ['prepare/source/update_first_order_low_pass.c','cbmc/harness.c']}
d={'schema':'five-cbmc-rocq-map/1','verification_method':'traditional-bounded-model-checking','status':'mapped','request_sha256':sha(c/'align/request.json'),'backend_manifest_sha256':sha(c/'align/model/compcert-manifest.json'),'cbmc_run':ce['run'],'cbmc_command_id':ce['command_id'],'cbmc_json':ce['json'],'cbmc_input_sha256':source_hash,'properties':[]}
for p in props:
 pid=p['property']; assert p['status']=='SUCCESS'; sym='P_'+re.sub('[^A-Za-z0-9_]','_',pid)
 assert len(re.findall(r'Definition\s+'+re.escape(sym)+r'\s*:',text))==1,sym
 state='Original Csem entry and actual parameter/local/field atomic-prefix guard witnesses; all-reachable-state safety is a separate NoError theorem.' if pid.startswith('update_') else 'Actual normal-return Csem executions and official memcpy BitsRun allocation/store/copy/uint32 observations, both legal operand orders.'
 scope={'description':p.get('description'),'location':p.get('sourceLocation'),'input_preconditions':'All binary32 tc/last_in/last_out/input bits in initialized aligned nonwrapping writable12-byte harness object; no finite or nonzero denominator restriction.','source_harness_sha256':source_hash,'observation':'Exact returned/stored last_out bits, last_in input bytes and preserved time_const bytes; source guard prefixes and official memcpy helpers.','mapped_statement':'FiveLowpassUpdateRecheck.Spec.'+sym,'original_property_id':pid,'cbmc_bounds':{'entry':'main','unwind':1,'unwinding_assertions':True,'source_loops':False,'source_recursion':False},'command_scope':{'run':ce['run'],'command_id':ce['command_id'],'argv':cmd['argv']}}
 d['properties'].append({'property_id':pid,'cbmc_status':p['status'],'scope':scope,'rocq_goal':{'module':'FiveLowpassUpdateRecheck.Spec','symbol':sym,'declaration_file':'rocq/cbmc_recheck/problem/Spec.v','paths_relative_to':'case','declaration_sha256':sha(spec)},'theorem':'FiveLowpassUpdateRecheck.Proof.prove_'+sym,'mapping_status':'mapped','proof_status':'pending','correspondence':{'inputs':'Same unchanged source/harness and all typed binary32 bit patterns; original CompCert execution model remains unrestricted.','state':state,'observation':'Three exact-byte/bit assertions,24 source guards and9 helper guards, preserving actual scope and property identity.'}})
assert len(d['properties'])==36
out=c/'align/model/spec-map-final.json'; assert not out.exists(); out.write_text(json.dumps(d,indent=2)+'\n')
print(json.dumps({'status':'mapped','properties':36,'proof_status':'pending','path':str(out.relative_to(root)),'sha256':sha(out)}))
