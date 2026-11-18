from pathlib import Path
import sys,importlib.util,tempfile,json,hashlib
root=Path('/home/yangfp/five');sys.path.insert(0,str(root/'scripts'))
from five_telemetry import Run
checker=root/'paparazzi/models/init_first_order_low_pass/rocq/cbmc_recheck/attempts/002/check.py'
s=importlib.util.spec_from_file_location('corrected_checker',checker);m=importlib.util.module_from_spec(s);s.loader.exec_module(m)
results={}
with tempfile.TemporaryDirectory(prefix='five-capture-regression-')as temp:
 folder=Path(temp);fixture=Run.start(folder/'runs','five-rocq',[],{'purpose':'Ephemeral actual Run API regression fixture; no model-work claim'},invocation_kind='tool-workflow')
 a=folder/'a.txt';a.write_text('first');b=folder/'b.txt';b.write_text('second')
 evidence=m.safe_capture(fixture,a,'CorrectionRegression-default')
 assert evidence['path'].startswith('evidence/')and fixture.read('inputs/manifest.json')==[]
 results['default_capture_area_evidence']=True
 ra=m.safe_capture(fixture,a,'CorrectionRegression-input-a',area='inputs');rb=m.safe_capture(fixture,b,'CorrectionRegression-input-b',area='inputs')
 assert not(fixture.folder/'inputs/manifest.json').exists()
 assert m.audit_input_copies(fixture)==2
 results['all_virtual_manifest_rows_scanned']=2
 target=fixture.folder/ra['path'];assert target.resolve().is_relative_to(folder.resolve());saved=target.read_bytes();target.write_text('deliberate test corruption')
 try:m.safe_capture(fixture,b,'CorrectionRegression-before-corruption',area='inputs')
 except RuntimeError as e:assert'Input copy SHA mismatch'in str(e);results['corrupted_existing_copy_rejected']=True
 else:raise AssertionError('Corrupt prior physical copy was not detected')
 target.write_bytes(saved);assert m.audit_input_copies(fixture)==2
 a.write_text('different current source')
 try:m.safe_capture(fixture,a,'CorrectionRegression-input-a',area='inputs')
 except RuntimeError as e:assert'Blocked input overwrite'in str(e);results['same_target_different_sha_rejected']=True
 else:raise AssertionError('Different-SHA target overwrite was not blocked')
 assert target.read_bytes()==saved
results['checker_sha256']=hashlib.sha256(checker.read_bytes()).hexdigest()
results['status']='passed';print(json.dumps(results,indent=2))
