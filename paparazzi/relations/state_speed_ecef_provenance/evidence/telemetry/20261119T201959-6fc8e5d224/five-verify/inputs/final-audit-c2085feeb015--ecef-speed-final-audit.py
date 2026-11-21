from pathlib import Path
from collections import Counter
import sys, json, hashlib, importlib.util, re
repo = Path('/home/yangfp/five')
sys.path.insert(0, str(repo/'scripts'))
import compcert_gate
_kernel_record = compcert_gate.kernel_record
_checked_receipts = {}
def cached_kernel_record(root, ref):
    path=(Path(root)/ref).resolve()
    key=(str(path), hashlib.sha256(path.read_bytes()).hexdigest())
    if key not in _checked_receipts:
        _checked_receipts[key]=_kernel_record(root,ref)
    return dict(_checked_receipts[key])
# Mathematical sources are frozen throughout this read-only validation. Every
# distinct receipt is fully checked once; all per-ID checks still run. Shared
# source/hash dependencies are checked again below before accepting the result.
compcert_gate.kernel_record=cached_kernel_record
spec = importlib.util.spec_from_file_location('five_artifact_validator', repo/'scripts/check-example-artifacts.py')
mod = importlib.util.module_from_spec(spec)
spec.loader.exec_module(mod)
v = mod.Validator(repo, allowed_proof_efforts={'ultra'})
root_run = Path((repo/'_build/state-speed-ecef-provenance/root-run.txt').read_text().strip())
freeze = json.loads((root_run/'evidence/pre-existing-artifact-freeze.json').read_text())['files']
def digest(p):
    return hashlib.sha256(p.read_bytes()).hexdigest()
unchanged = []
for old in freeze:
    path = repo/old['path']
    if not path.is_file() or digest(path) != old['sha256']:
        unchanged.append(old['path'])
assert not unchanged, {'changed_preexisting_files': unchanged}
rows = []
for name, count in [('stateSetSpeedNed_i',32), ('stateSetSpeedEcef_i',32), ('stateGetSpeedEcef_f',276)]:
    case = repo/'paparazzi/models'/name
    v.case(case)
    # The additional unrestricted execution correspondence problem is also an actual proof.
    v.proof_problem(case/'rocq/execution_correspondence/problem')
    ledger = json.loads((case/'cbmc/properties.json').read_text())
    actual = {x['id']:x for x in ledger['properties']}
    recheck = json.loads((case/'rocq/spec-recheck.json').read_text())
    rechecked = recheck['properties']
    if isinstance(rechecked, list):
        def get_id(x):
            return x.get('id', x.get('property_id', x.get('property')))
        rechecked = {get_id(x):x for x in rechecked}
    assert len(actual)==count and set(actual)==set(rechecked), (name,'actual IDs differ')
    for ident, item in actual.items():
        want = {'SUCCESS':'proved','FAILURE':'refuted'}[item['status']]
        assert rechecked[ident]['status']==want, (name,ident,'incorrect recheck result')
    for file in ('Source.v','Execution.v'):
        path = case/'align/model'/file
        bound = [x for x in json.loads((root_run/'run.json').read_text())['inputs']
                 if x.get('source')==str(path)]
        # Generation was owned by the child; raw align inputs/manifest already gate its original AST.
        if bound:
            assert all(x.get('sha256')==digest(path) for x in bound)
    rows.append({'case':name, 'actual_property_count':count,
                 'CBMC':dict(Counter(x['status'] for x in actual.values())),
                 'Rocq':dict(Counter(x['status'] for x in rechecked.values()))})
rel = repo/'paparazzi/relations/state_speed_ecef_provenance'
v.proof_problem(repo/'paparazzi/models/stateGetSpeedEcef_f/rocq/functional/problem')
v.proof_problem(rel/'problem')
if (rel/'README.md').is_file():
    v.links(rel/'README.md')
for base in [rel, *[repo/'paparazzi/models'/n/'rocq' for n in ('stateSetSpeedNed_i','stateSetSpeedEcef_i','stateGetSpeedEcef_f')]]:
    for path in base.rglob('*.v'):
        if '/evidence/' in str(path):
            continue
        text = re.sub(r'\(\*.*?\*\)', '', path.read_text(), flags=re.S)
        assert not re.search(r'\b(?:Admitted|admit)\b', text), str(path)
        assert not re.search(r'(?m)^\s*(?:(?:Local|Global|Polymorphic|Monomorphic)\s+)*(?:Axiom|Axioms)\s+', text), str(path)
for checked in _checked_receipts.values():
    for name, expected in checked.items():
        p=Path(name)
        if not p.is_absolute():p=repo/p
        assert p.is_file() and digest(p)==expected, ('Changed checked receipt/dependency',str(p))
result = {'status':'failed' if v.errors else 'passed',
          'scope':'Independent artifact/provenance/actual-property coverage audit; theorem adequacy is reviewed separately by root.',
          'preexisting_files_unchanged':len(freeze),
          'cases':rows,
          'active_attempts':[str(p.relative_to(repo)) for p in v.active],
          'errors':v.errors}
print(json.dumps(result,indent=2))
raise SystemExit(bool(v.errors))
