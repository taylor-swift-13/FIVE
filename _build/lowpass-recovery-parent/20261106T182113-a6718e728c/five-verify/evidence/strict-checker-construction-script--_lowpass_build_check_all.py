from pathlib import Path

root = Path('/home/yangfp/five')
source = (root / 'paparazzi/report/guidance_mode/check_all.py').read_text()
source = source.replace('guidance problem', 'lowpass-recovery problem')
source = source.replace('guidance_mode/problem', 'lowpass_recovery/problem')
source = source.replace("('gh_update_ref_from_speed_sp','gh_update_ref_from_accel_sp')", 'CASES')
marker = 'root=Path(__file__).resolve().parents[3]'
source = source.replace(marker, marker + '''
CASES=('init_first_order_low_pass','reset_first_order_low_pass','update_first_order_low_pass_tau')
REQUIRED_PROBLEMS={'no_error','termination','cbmc_recheck','execution_correspondence','functional'}''')
needle = "  case=root/'paparazzi/models'/name;validator.case(case)"
assert needle in source
source = source.replace(needle, needle + '''
  actual={p.parent.name for p in (case/'rocq').glob('*/problem')}
  validator.require(REQUIRED_PROBLEMS<=actual,'missing requested proof problems: '+name+': '+str(sorted(REQUIRED_PROBLEMS-actual)))
  for problem in sorted((case/'rocq').glob('*/problem')):
   status=validator.read(problem/'status.json')
   validator.require(status.get('status')=='proved','requested problem not proved: '+str(problem))''')
needle = " validator.proof_problem(root/'paparazzi/relations/lowpass_recovery/problem')"
assert needle in source
source = source.replace(needle, needle + '''
 status=validator.read(root/'paparazzi/relations/lowpass_recovery/problem/status.json')
 validator.require(status.get('status')=='proved','requested relation is not proved')''')
assert 'gh_update' not in source
output = root / 'paparazzi/report/lowpass_recovery/check_all.py'
compile(source, str(output), 'exec')
output.write_text(source)
print('Created strict three-case/all-problems/input-copy/full-CompCert checker.')
