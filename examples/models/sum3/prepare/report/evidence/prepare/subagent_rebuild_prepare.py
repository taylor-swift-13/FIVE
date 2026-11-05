from pathlib import Path
import hashlib,json,os,shutil,tempfile
root=Path('/home/yangfp/five');case=root/'examples/sum3';old=case/'prepare/source/Program.c'
assert old.is_file()
original=old.read_bytes();d=hashlib.sha256(original).hexdigest();old_target=json.loads((case/'prepare/source/bindings.json').read_text())['target']
stage=Path(tempfile.mkdtemp(prefix='.sum3-build-',dir=case.parent));assert stage.parent.resolve()==case.parent.resolve()
for n in ('prepare','cbmc','align','rocq'):(stage/n).mkdir()
for n in ('cbmc','align','rocq'):(stage/n/'.gitkeep').touch()
p=stage/'prepare';(p/'source').mkdir();(p/'report').mkdir()
(p/'source/Program.c').write_bytes(original)
def save(path,x):path.write_text(json.dumps(x,indent=2)+'\n')
binding={'schema':'five-source-bindings/1','entry':'sum3','original_source':{'path':'prepare/source/Program.c','sha256':d},'prepared_source':{'path':'prepare/source/Program.c','sha256':d},'preparation':'The original C file is unchanged; the selected entry has no external calls.','dependencies':[],'target':old_target,'c_dialect':None,'c_dialect_reason':'No dialect fixed during preparation; record actual later tool options.','preprocessor_arguments':[],'frontend_options':[],'external_call_bindings':[],'redirections':[],'external_environment':[],'correspondence_obligations':['Connect mapped CBMC properties to CompCert execution and observations.']}
save(p/'source/bindings.json',binding)
def sha(path):return hashlib.sha256(path.read_bytes()).hexdigest()
def item(path):return {'path':path,'sha256':sha(stage/path)}
stages=['five-prepare','five-cbmc','five-align','five-rocq','five-verify']
def stat(s):return {'status':s,'inputs':[],'outputs':[],'logs':[],'limitations':[]}
ss={s:stat('not_run') for s in stages};ss['five-prepare']=stat('passed');ss['five-prepare']['inputs']=[item('prepare/source/Program.c')];ss['five-prepare']['outputs']=[item('prepare/source/Program.c'),item('prepare/source/bindings.json')]
save(p/'report/manifest.json',{'schema':'five-case-manifest/1','case_id':'sum3','target':old_target,'stages':ss})
def cost():return {'status':'not_run','input_tokens':None,'output_tokens':None,'total_tokens':None,'wall_seconds':None,'tool_cpu_seconds':None,'tool_peak_rss_bytes':None,'measurement_method':None,'evidence':[],'missing_reason':'Stage has not run in this reconstruction.'}
costs={s:cost() for s in stages};costs['five-prepare']=cost();costs['five-prepare']['status']='pending';costs['five-prepare']['missing_reason']='Real usage and cost records are pending while this run is active.'
save(p/'report/costs.json',{'schema':'five-case-costs/1','stages':costs,'shared_batches':[]})
(p/'report/report.md').write_text('# sum3 preparation\n\nThe original C, entry, target and actual bindings have been frozen. No CBMC, CompCert export or Rocq proof was run. See `costs.json` and `handoff.json` for measured evidence and the next stage.\n')
handoff={'schema':'five-stage-handoff/1','case_id':'sum3','stage':'five-prepare','status':'passed','target':old_target,'paths_relative_to':'sum3 case root','outputs':[{'role':'prepared_c',**item('prepare/source/Program.c')},{'role':'bindings',**item('prepare/source/bindings.json')},{'role':'stage_manifest',**item('prepare/report/manifest.json')}],'next_stage':'five-cbmc','verification_request':{'status':'not_specified','properties':None,'input_assumptions':None,'bounds':None,'reason':'No CBMC property or bounds have been specified.'},'limitations':['The actual cost report is prepare/report/costs.json; its final values are recorded after this run closes.']}
save(p/'handoff.json',handoff)
(stage/'README.md').write_text('''# sum3

This case uses four sequential stage folders: `prepare/` → `cbmc/` → `align/` → `rocq/`. Only prepare has run. Each stage reads its preceding handoff and checks referenced paths and hashes. The prepared C, target and bindings are in `prepare/source/`; stage status and cost evidence are in `prepare/report/`; `prepare/handoff.json` is the CBMC input. The CBMC property has not been specified.

The `.gitkeep` files only preserve the empty future directories; they are not stage results.
''')
assert case.resolve()==Path('/home/yangfp/five/examples/sum3')
shutil.rmtree(case);stage.rename(case)
assert sha(case/'prepare/source/Program.c')==d
print('Rebuilt from original source with sha256',d,'; downstream stages not run.')
