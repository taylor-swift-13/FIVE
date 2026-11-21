from pathlib import Path
import json,hashlib,sys
r=Path('/home/yangfp/five');sys.path.insert(0,str(r/'scripts'))
from example_proof_gate import validate_current
from compcert_gate import check_spec_recheck
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
rows=[];props=[]
for dim in ['2d','3d']:
 c=r/f'paparazzi/models/float_mat_inv_{dim}'
 for kind in ['no_error','termination','functional','execution_correspondence','cbmc_recheck']:
  p=c/f'rocq/{kind}/problem';status=json.loads((p/'status.json').read_text());active=(p/status['active_attempt']).resolve();assert status['status']==('refuted'if kind=='cbmc_recheck'else'proved');validate_current(r,p,active,status);rows.append({'case':c.name,'problem':kind,'status':status['status'],'active_attempt':str(active.relative_to(r)),'goal_count':len(status['requested_goals']),'strict_validate_current':'passed'});print(c.name,kind,'PASS',len(status['requested_goals']))
 manifest_path=c/'align/model/compcert-manifest.json';m=json.loads(manifest_path.read_text());source=m['source']['path'];execbindings={source:sha(r/source),m['files']['Source.v']['path']:sha(r/m['files']['Source.v']['path']),m['files']['Execution.v']['path']:sha(r/m['files']['Execution.v']['path'])}
 result=check_spec_recheck(r,str((c/'rocq/spec-recheck.json').relative_to(r)),m['request']['sha256'],sha(manifest_path),source,execbindings);props.append({'case':c.name,'proved':result['proved'],'refuted':result['refuted'],'spec_recheck_gate':'passed'});print(c.name,'actual original CBMC ledger PASS',result['proved'],result['refuted'])
out=r/'_build/matrix-current-evidence/20261121T082634-fedfee5341/five-verify/evidence/current-all-ten-validation.json'
data={'schema':'five-matrix-current-acceptance/1','status':'passed','requested_named_problems':len(rows),'typed_case_goals':sum(x['goal_count']for x in rows),'actual_cbmc_properties':sum(x['proved']+x['refuted']for x in props),'proved_cbmc_properties':sum(x['proved']for x in props),'refuted_cbmc_properties':sum(x['refuted']for x in props),'pending':0,'problems':rows,'original_ledgers':props,'numeric_relation':'Six independently accepted numeric goals are owned and separately checked by root; this check does not duplicate that claim.'};assert data['typed_case_goals']==423 and data['actual_cbmc_properties']==398 and data['proved_cbmc_properties']==394 and data['refuted_cbmc_properties']==4;out.write_text(json.dumps(data,indent=2)+'\n');print(out)
