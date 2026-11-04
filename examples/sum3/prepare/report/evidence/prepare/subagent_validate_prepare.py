from pathlib import Path
import json,hashlib
c=Path('/home/yangfp/five/examples/sum3');h=json.loads((c/'prepare/handoff.json').read_text());m=json.loads((c/'prepare/report/manifest.json').read_text())
assert sorted(p.name for p in c.iterdir() if p.is_dir())==['align','cbmc','prepare','rocq']
assert h['stage']=='five-prepare' and h['status']=='passed'
for e in h['outputs']:
 f=c/e['path'];assert f.is_file() and hashlib.sha256(f.read_bytes()).hexdigest()==e['sha256'],str(f)
for n in ('five-cbmc','five-align','five-rocq'):assert m['stages'][n]['status']=='not_run'
assert h['verification_request']['status']=='not_specified'
print('PASS: four folders, source/manifest hashes, handoff, and not-run downstream states.')
