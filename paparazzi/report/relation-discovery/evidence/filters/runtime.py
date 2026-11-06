import json,pathlib,hashlib
p=pathlib.Path('/mnt/c/Users/50635/.codex/sessions/2026/11/05/rollout-2026-11-05T23-54-44-01a1ac6b-6dee-7093-90c3-0d1d9cd1e1ed.jsonl')
events=[json.loads(x) for x in p.read_text().splitlines()]
meta=next(e for e in events if e['type']=='session_meta')
assert meta['payload']['source']['subagent']['thread_spawn']['agent_path']=='/root/relations_filters_medium'
t=next(e for e in events if e['type']=='turn_context')
out=pathlib.Path('/home/yangfp/five/_build/paparazzi-relation-discovery/filters-evidence/runtime.json')
out.write_text(json.dumps({'schema':'five-discovery-runtime/1','session':str(p),'agent_path':'/root/relations_filters_medium','requested_model':'gpt-6.1-sol','requested_effort':'medium','observed_model':t['payload'].get('model'),'observed_effort':t['payload'].get('effort'),'runtime_event_timestamp':t.get('timestamp'),'status':'recorded','scope':'discovery only; no proof worker or theorem'},indent=2)+'\n')
