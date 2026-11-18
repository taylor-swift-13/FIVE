#!/usr/bin/python3
"""Exact external SMT solver driver: change check strategy only, retain formula."""
from pathlib import Path
import hashlib,json,subprocess,sys,uuid,datetime
EVIDENCE=Path('/home/yangfp/five/_build/lowpass-execution-worker/20261106T185522-44760c3180/five-cbmc/evidence/smt-tactic')
SOLVER=Path('/home/yangfp/.local/bin/z3')
def sha_bytes(b):return hashlib.sha256(b).hexdigest()
folder=EVIDENCE/uuid.uuid4().hex;folder.mkdir(parents=True,exist_ok=False)
paths=[Path(x) for x in sys.argv[1:] if not x.startswith('-') and Path(x).is_file()]
raw=paths[-1].read_bytes() if paths else sys.stdin.buffer.read()
(folder/'original.smt2').write_bytes(raw)
needle=b'(check-sat)';replacement=b'(check-sat-using (then simplify solve-eqs smt))'
count=raw.count(needle)
transformed=raw.replace(needle,replacement)
(folder/'transformed.smt2').write_bytes(transformed)
manifest={'schema':'five-exact-smt-tactic/1','started_at':datetime.datetime.now(datetime.timezone.utc).isoformat(),'driver_argv':sys.argv,'input_path':str(paths[-1]) if paths else None,'original_sha256':sha_bytes(raw),'transformed_sha256':sha_bytes(transformed),'replacement_count':count,'only_transformation':{'from':needle.decode(),'to':replacement.decode()},'driver_sha256':sha_bytes(Path(__file__).read_bytes()),'solver':str(SOLVER),'solver_sha256':sha_bytes(SOLVER.read_bytes()),'status':'started'}
(folder/'manifest.json').write_text(json.dumps(manifest,indent=2)+'\n')
if not raw or count==0:
 manifest.update({'status':'failed-closed','reason':'Input is empty or contains no literal check-sat command.'});(folder/'manifest.json').write_text(json.dumps(manifest,indent=2)+'\n');sys.stderr.write('SMT strategy driver rejected unsupported or empty protocol input.\n');sys.exit(2)
assert transformed==raw.replace(needle,replacement)
p=subprocess.run([str(SOLVER),'-in','-smt2'],input=transformed,stdout=subprocess.PIPE,stderr=subprocess.PIPE)
(folder/'solver.stdout').write_bytes(p.stdout);(folder/'solver.stderr').write_bytes(p.stderr)
manifest.update({'status':'completed','exit_code':p.returncode,'finished_at':datetime.datetime.now(datetime.timezone.utc).isoformat(),'solver_stdout_sha256':sha_bytes(p.stdout),'solver_stderr_sha256':sha_bytes(p.stderr)});(folder/'manifest.json').write_text(json.dumps(manifest,indent=2)+'\n')
sys.stdout.buffer.write(p.stdout);sys.stdout.buffer.flush();sys.stderr.buffer.write(p.stderr);sys.stderr.buffer.flush();sys.exit(p.returncode)
