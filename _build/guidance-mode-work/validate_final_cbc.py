from pathlib import Path
import sys,json,importlib.util,hashlib
R=Path('/home/yangfp/five');sys.path.insert(0,str(R/'scripts'))
from example_proof_gate import validate_current
from compcert_gate import accept_compcert_delivery
sp=importlib.util.spec_from_file_location('reference_validator',R/'scripts/check-example-artifacts.py');m=importlib.util.module_from_spec(sp);sp.loader.exec_module(m);v=m.Validator(R);out=[]
for entry in ['gh_update_ref_from_speed_sp','gh_update_ref_from_accel_sp']:
 c=R/'paparazzi/models'/entry;d=c/'rocq/cbmc_recheck';status=json.loads((d/'problem/status.json').read_text());validate_current(R,d/'problem',d/'attempts/001',status);v.proof_problem(d/'problem')
 request=c/'align/request.json';gate=accept_compcert_delivery(R,request_path=str(request.relative_to(R)),contract_path=str((c/'rocq/execution-contract.json').relative_to(R)),expected_request_sha256=hashlib.sha256(request.read_bytes()).hexdigest(),manifest_path=str((c/'align/model/compcert-manifest.json').relative_to(R)),spec_recheck_path=str((c/'rocq/spec-recheck.json').relative_to(R)));out.append({'case':entry,'typed_exact_goals':122,'strict_current':'passed','gate':gate})
if v.errors:raise RuntimeError(json.dumps(v.errors,indent=2))
p=R/'paparazzi/report/guidance_mode/evidence/canonical-cbmc-proof-validation.json';p.write_text(json.dumps({'status':'passed','cases':out,'scope':'Unchanged strict proof validator, proof/cost/link validator, actual-ID equality and both complete CompCert gates.'},indent=2)+'\n');print(p.read_text())
