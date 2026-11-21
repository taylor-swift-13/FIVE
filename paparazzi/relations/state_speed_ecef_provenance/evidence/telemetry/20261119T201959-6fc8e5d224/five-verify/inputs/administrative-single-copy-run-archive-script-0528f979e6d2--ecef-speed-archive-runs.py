from pathlib import Path
import json,os,sys,shutil,hashlib
repo=Path('/home/yangfp/five');sys.path.insert(0,str(repo/'scripts'))
from five_telemetry import Run
admin=Run((repo/'_build/state-speed-ecef-provenance/admin-run.txt').read_text().strip())
if '--inner' not in sys.argv:
 admin.capture(Path(__file__),'administrative-single-copy-run-archive-script-'+hashlib.sha256(Path(__file__).read_bytes()).hexdigest()[:12],area='inputs')
 cmd=admin.command(['python3',str(Path(__file__)),'--inner'],'archive-closed-workers-and-paused-author-once',timeout=45,cwd=repo)
 print((admin.folder/cmd['stdout']).read_text());print((admin.folder/cmd['stderr']).read_text())
 raise SystemExit(cmd['exit_code'])
items=[
 ('20261119T183325-cef130029f','five-verify'),
 ('20261119T190205-3f37a58899','five-align'),
 ('20261119T190248-afbe288364','five-align'),
 ('20261119T190331-cda2c8f96b','five-align'),
 ('20261119T190556-2b2df62cd4','five-rocq'),
 ('20261119T190859-f7887a34ba','five-rocq'),
 ('20261119T191206-e9665beca7','five-rocq'),
 ('20261119T195101-bd31374838','five-rocq'),
 ('20261119T195957-33f946921e','five-rocq'),
 ('20261119T201826-89d7844c80','five-rocq'),
 ('20261119T203342-fee1a795eb','five-rocq'),
 ('20261119T203851-092f782609','five-rocq'),
 ('20261119T203543-767dbdbbcb','five-rocq'),
 ('20261119T194851-2aaea433bd','five-rocq')]
output=[]
base=repo/'paparazzi/relations/state_speed_ecef_provenance/evidence/telemetry'
root_start=json.loads((Path((repo/'_build/state-speed-ecef-provenance/root-run.txt').read_text().strip())/'run.json').read_text())['start_epoch']
for ident,skill in items:
 src=repo/'runs'/ident/skill;dest=base/ident/skill
 if src.is_symlink():
  assert src.resolve()==dest.resolve() and dest.is_dir()
  output.append({'run_id':ident,'already_archived':True,'archive':str(dest.relative_to(repo))});continue
 assert src.resolve()==src and src.is_dir() and src.is_relative_to(repo/'runs')
 assert dest.is_relative_to(base) and not dest.exists()
 data=json.loads((src/'run.json').read_text())
 assert data['run_id']==ident and data['skill']==skill and data['start_epoch']>=root_start
 if data['status']=='running':assert ident=='20261119T194851-2aaea433bd','An unpaused active worker cannot be moved'
 dest.parent.mkdir(parents=True,exist_ok=True)
 shutil.move(str(src),str(dest))
 src.symlink_to(os.path.relpath(dest,src.parent),target_is_directory=True)
 assert src.resolve()==dest and (src/'run.json').read_bytes()==(dest/'run.json').read_bytes()
 output.append({'run_id':ident,'archive':str(dest.relative_to(repo)),'status':data['status'],'single_copy':True,'local_compatibility_alias':str(src.relative_to(repo))})
main=base/'20261119T194851-2aaea433bd/five-rocq'
(repo/'_build/state-speed-ecef-provenance/getter-ultra-run.txt').write_text(str(main))
admin.evidence('single-copy-worker-archives.json',{'archives':output,'policy':'Raw run bytes untouched; old local paths are relative symlinks, not duplicate copies. The active author was explicitly paused between commands before moving.'})
print(json.dumps({'archives':output,'active_getter_run':str(main)},indent=2))
