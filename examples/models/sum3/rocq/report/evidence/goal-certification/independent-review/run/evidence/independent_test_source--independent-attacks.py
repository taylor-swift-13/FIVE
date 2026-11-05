from pathlib import Path
import sys,json,hashlib,importlib.util
from unittest.mock import patch
ROOT=Path('/home/yangfp/five');sys.path.insert(0,str(ROOT/'scripts'))
spec=importlib.util.spec_from_file_location('goldvalidator',ROOT/'scripts/check-example-artifacts.py')
gate=importlib.util.module_from_spec(spec);spec.loader.exec_module(gate)
from example_proof_gate import certificate_source
rawtext=Path.read_text;rawbytes=Path.read_bytes
problem=ROOT/'examples/models/sum3/rocq/no_error/problem'
active=problem.parent/'attempts/001';validation=active/'evidence/goal-validation.json';index=active/'inputs.json'
def digest(data):return hashlib.sha256(data).hexdigest()
def jbytes(data):return (json.dumps(data,indent=2)+'\n').encode()
def inspect_case(overrides):
 # Refresh superficial handoff hashes exactly as an artifact repackager would;
 # compiler receipts, source snapshots and their run-input hashes stay genuine.
 for _ in range(4):
  for case in (ROOT/'examples/models/sum2',ROOT/'examples/models/sum3'):
   for stage in ('prepare','cbmc','align','rocq'):
    path=case/stage/'handoff.json';data=json.loads(overrides.get(path,rawbytes(path)))
    for row in data.get('outputs',[]):
     target=(case/row['path']).resolve()
     if target in overrides:row['sha256']=digest(overrides[target])
    updated=jbytes(data)
    # Preserve exact bytes when output rows did not actually change.
    if data!=json.loads(rawtext(path)):overrides[path]=updated
 def text(p,*a,**k):
  return overrides[p.resolve()].decode() if p.resolve() in overrides else rawtext(p,*a,**k)
 def data(p):return overrides[p.resolve()] if p.resolve() in overrides else rawbytes(p)
 with patch.object(Path,'read_text',text),patch.object(Path,'read_bytes',data):
  return gate.Validator(ROOT).run()
def changed_source(target,replacement):
 overrides={target:replacement.encode()}
 oldhash=digest(rawbytes(target));newhash=digest(overrides[target])
 # Treat original index hashes as superficially editable descriptors in this
 # attack too; the immutable genuine compiler receipt still must protect us.
 overrides[index]=rawtext(index).replace(oldhash,newhash).encode()
 data=json.loads(rawtext(validation));data['index']['sha256']=digest(overrides[index])
 for row in data['inputs']:
  if (ROOT/row['path']).resolve()==target:row['sha256']=newhash
 overrides[validation]=jbytes(data)
 return overrides
results=[]
def expect(name,overrides,pattern):
 result=inspect_case(overrides)
 assert result['status']=='failed',name+' unexpectedly accepted'
 assert any(pattern in error for error in result['errors']),name+': unrelated rejection '+str(result['errors'])
 results.append({'case':name,'status':'rejected','expected_reason':pattern,'errors':result['errors']})
baseline=inspect_case({});assert baseline['status']=='passed',baseline
results.append({'case':'actual-seven-current-proofs','status':'passed','active_attempts':baseline['active_attempts']})
expect('unrelated-True-proof-plus-refreshed-index-currentbinding-handoff-hashes',changed_source(active/'Proof.v','Theorem irrelevant : True. Proof. exact I. Qed.\n'),'compiled snapshot')
expect('weakened-Spec-plus-refreshed-index-currentbinding-handoff-hashes',changed_source(problem/'Spec.v','Definition Goal : Prop := True.\n'),'compiled snapshot')
data=json.loads(rawtext(validation));data['kernel_evidence']='examples/relations/sum2_sum3/attempts/001/evidence/goal-binding/proof-kernel-evidence.json'
expect('unrelated-successful-kernel-receipt',{validation:jbytes(data)},'kernel dependency closure')
statuspath=problem/'status.json';status=json.loads(rawtext(statuspath));status['requested_goals']=['UnrelatedGoal']
expect('renamed-requested-goal',{statuspath:jbytes(status)},'requested goals differ')
data=json.loads(rawtext(validation));data['inputs']=[]
expect('missing-current-input-bindings',{validation:jbytes(data)},'missing current input bindings')
data=json.loads(rawtext(validation));data['goal_bindings'][0]['type']='True'
certificate=ROOT/data['certificate']['path'];fakecert=certificate_source(data['certificate']['imports'],data['goal_bindings']).encode();data['certificate']['sha256']=digest(fakecert)
expect('wrong-goal-type-and-certificate-text-but-genuine-old-compiler-receipt',{validation:jbytes(data),certificate:fakecert},'certificate run omitted actual certificate')
data=json.loads(rawtext(validation));data['goal_bindings'][0]['theorem']='FiveSum3Proof.Attempt.nonexistent'
expect('nonexistent-theorem-with-successful-module-receipt',{validation:jbytes(data)},'goal theorem is not claimed')
print(json.dumps({'status':'passed','scope':'Full real-tree Validator.run with in-memory current source/descriptor substitution; no canonical file mutated. Genuine compile snapshots and raw receipts retained.','cases':results},indent=2))
