from pathlib import Path
import sys,json,importlib.util
ROOT=Path('/home/yangfp/five');RUN=ROOT/'runs/20261121T074639-bdfaaf3c16/five-rocq'
sys.path.insert(0,str(ROOT/'scripts'))
spec=importlib.util.spec_from_file_location('evidence_tools',ROOT/'paparazzi/report/quat_rotation_paths/evidence_tools.py');e=importlib.util.module_from_spec(spec);spec.loader.exec_module(e)
config=json.loads((ROOT/'paparazzi/models/float_mat_inv_3d/rocq/cbmc_recheck/attempts/002/checker-config.json').read_text())
config['root']=str(ROOT);config['build']=str((RUN/'evidence/checked').relative_to(ROOT))
result=e.check(config,record_run=str(RUN))
(RUN/'evidence/final-check-result.json').write_text(json.dumps(result,indent=2)+'\n')
print(json.dumps(result,indent=2))
