from pathlib import Path
import json,sys,hashlib
ROOT=Path('/home/yangfp/five');sys.path.insert(0,str(ROOT/'scripts'));from example_proof_gate import validate_current
case=ROOT/'paparazzi/models/float_mat_inv_3d';problem=case/'rocq/cbmc_recheck/problem';attempt=case/'rocq/cbmc_recheck/attempts/003'
statusfile=problem/'status.json';old=json.loads(statusfile.read_text());candidate=dict(old);candidate['status']='refuted';candidate['active_attempt']='../attempts/003'
validate_current(ROOT,problem,attempt,candidate)
statusfile.write_text(json.dumps(candidate,indent=2)+'\n')
validate_current(ROOT,problem,attempt,candidate)
print(json.dumps({'status':'passed','case':'float_mat_inv_3d','active_attempt':'003','result':'refuted:206originalSUCCESS proved and2originalFAILURE refuted','exact_properties':208,'status_sha256':hashlib.sha256(statusfile.read_bytes()).hexdigest(),'goal_validation':str((attempt/'evidence/goal-validation.json').relative_to(ROOT))},indent=2))
