from pathlib import Path
import json
R=Path('/home/yangfp/five');session=Path('/mnt/c/Users/50635/.codex/sessions/2026/11/06/rollout-2026-11-06T19-04-29-01a1b088-114c-7292-ac9e-b0886f7537c3.jsonl');contexts=[]
for line in session.read_text().splitlines():
 r=json.loads(line)
 if r.get('type')=='turn_context':
  p=r['payload'];contexts.append({'type':'turn_context','timestamp':r.get('timestamp'),'model':p.get('model'),'effort':p.get('effort')})
assert contexts and all(x['model']=='gpt-6.1-sol'and x['effort']=='medium'for x in contexts)
runtime={'actor_path':'/root/guidance_mode_complete_medium','session_source':str(session),'actual':{'model':'gpt-6.1-sol','effort':'medium'},'selected_runtime_metadata':contexts}
for entry in ['gh_update_ref_from_speed_sp','gh_update_ref_from_accel_sp']:
 p=R/'paparazzi/models'/entry/'rocq/cbmc_recheck/attempts/001/evidence/runtime-metadata.json';p.parent.mkdir(parents=True,exist_ok=True);p.write_text(json.dumps(runtime,indent=2)+'\n')
print('Actual Sol medium runtime evidence bound for both fresh CBC proof attempts.')
