from pathlib import Path
from collections import Counter
import sys,json,hashlib,importlib.util
r=Path('/home/yangfp/five');sys.path.insert(0,str(r/'scripts'))
s=importlib.util.spec_from_file_location('artifact_validator',r/'scripts/check-example-artifacts.py')
vmod=importlib.util.module_from_spec(s);s.loader.exec_module(vmod)
v=vmod.Validator(r,allowed_proof_efforts={'ultra'})
rows=[]
for name,expected in [('stateSetSpeedNed_i',32),('stateSetSpeedEcef_i',32),('stateGetSpeedEcef_f',276)]:
 c=r/'paparazzi/models'/name
 for stage in ['prepare','cbmc','align']:
  h=json.loads((c/stage/'handoff.json').read_text())
  assert h['schema']=='five-stage-handoff/1' and h['paths_relative_to']=='case'
  v.bound(c,h['outputs']);v.costs(c/stage/'report/costs.json');v.links(c/stage/'report/report.md')
 d=json.loads((c/'cbmc/properties.json').read_text())
 raw_run=json.loads((r/d['run']/'run.json').read_text())
 cmd=next(x for x in raw_run['commands'] if x['id']==d['command_id'])
 assert Path(cmd['argv'][0]).name=='cbmc'
 forbidden=['--replace-call-with-contract','--enforce-contract','--apply-loop-contracts','--dfcc']
 assert not any(any(a==f or a.startswith(f+'=') for f in forbidden) for a in cmd['argv'])
 raw=json.loads((r/d['json_stdout']).read_text())
 actual=[p for item in raw for p in item.get('result',[])]
 assert len(actual)==expected and len(d['properties'])==expected
 actualmap={x['property']:x['status'] for x in actual}
 ledger={x['id']:x['status'] for x in d['properties']}
 assert actualmap==ledger and len(ledger)==expected
 for path,want in d['inputs'].items():
  p=r/path;assert hashlib.sha256(p.read_bytes()).hexdigest()==want,path
  captured=[x for x in raw_run['inputs'] if x.get('source')==str(p.resolve()) and x.get('sha256')==want]
  assert captured,(name,path,'not directly captured in raw CBMC inputs')
  for x in captured:assert hashlib.sha256((r/d['run']/x['path']).read_bytes()).hexdigest()==want
 failed=sorted(k for k,x in ledger.items() if x=='FAILURE')
 if name=='stateGetSpeedEcef_f':
  assert failed==['main.assertion.10','main.assertion.8','main.assertion.9']
  assert cmd['exit_code']==10 and cmd['status']=='failed'
 else:assert not failed and cmd['exit_code']==0 and cmd['status']=='passed'
 rows.append({'case':name,'actual_property_count':expected,'raw_ledger_exact':True,
 'status_counts':dict(Counter(ledger.values())),'functional_failures':failed,'actual_command_id':cmd['id'],
 'direct_original_inputs_captured':len(d['inputs'])})
print(json.dumps({'stage_handoff_and_cost_errors':v.errors,'case_ledger_audit':rows,
 'note':'Source/model generation is not a proof; Rocq obligations are pending separately.'},indent=2))
raise SystemExit(bool(v.errors))

