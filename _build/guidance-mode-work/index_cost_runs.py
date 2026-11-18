from pathlib import Path
import json
R=Path('/home/yangfp/five');files=set(R.glob('_build/guidance-mode-*/*/five-*/run.json'))|set(R.glob('runs/guidance_mode/*/five-*/run.json'))
for p in R.glob('runs/*/five-*/run.json'):
 d=json.loads(p.read_text());txt=json.dumps(d.get('scope',{}))
 if '/root/guidance_mode_complete_medium' in txt:files.add(p)
rows=[]
for p in sorted(files):
 d=json.loads(p.read_text());rows.append({'run':str(p.parent.relative_to(R)),'skill':d['skill'],'status':d['status'],'started_at':d['started_at'],'scope':d.get('scope',{}),'accounting':'Shared primary receipt; deduplicate token events and overlapping windows; root/global wrapper is not an additional token total.'})
for row in rows:
 if 'guidance-mode-checker/20261106T135140-a28ddbd7c3' in row['run']:
  row['actual_actor_path']='/root/guidance_mode_complete_medium/guidance_checker'
  row['historical_scope_correction']={'field':'scope.actor','recorded':'/root/guidance_mode_complete_medium/guidance_allorder','actual':'/root/guidance_mode_complete_medium/guidance_checker','basis':'Actual session first header agent_path and runtime receipt; historical run is unchanged.','runtime_evidence':'_build/guidance-mode-checker/20261106T135140-a28ddbd7c3/five-rocq/evidence/runtime-receipt.json'}
out=R/'paparazzi/report/guidance_mode/evidence/cost-run-index.json';out.parent.mkdir(parents=True,exist_ok=True);out.write_text(json.dumps({'schema':'five-task-cost-run-index/1','status':'live inventory; refresh after all closures','runs':rows,'nested_exports':'CompCert backend nested export invocations are provenance-only; outer measured export command accounts their tool work. Root runtime/pre-wrapper/closing cost receipts are added by independent review.'},indent=2)+'\n')
print(len(rows),'actual task run records indexed')
