"""Execution correspondence contract validation."""
import json
import re
from pathlib import Path
from five_telemetry import sha


PURPOSES = {'execution-translation','functional-model','bounded-equivalence'}
EXECUTION_OBLIGATIONS = {
    'domain-preservation','floating-point-correspondence',
    'machine-integer-correspondence','memory-access-correspondence',
    'control-and-exhaustion-correspondence','normal-result-and-memory-correspondence',
    'invalid-operation-correspondence','whole-execution-correspondence'}


def _execution_contract(root, request_path, contract_path, *, expected_request_sha256):
    if request_path is None or contract_path is None:
        raise RuntimeError('Execution-layer delivery requires a fixed user-request contract and checked execution-correspondence evidence; functional checks are insufficient')
    request_path,contract_path=Path(request_path),Path(contract_path)
    if not request_path.is_absolute():request_path=root/request_path
    if not contract_path.is_absolute():contract_path=root/contract_path
    if not isinstance(expected_request_sha256,str) or not re.fullmatch(r'[0-9a-f]{64}',expected_request_sha256) or sha(request_path)!=expected_request_sha256:
        raise RuntimeError('Execution request differs from the independently fixed upstream request hash')
    request=json.loads(request_path.read_text())
    contract=json.loads(contract_path.read_text())
    if not isinstance(request.get('domain'),(dict,str)) or not request['domain']:
        raise RuntimeError('Execution request requires a nonempty fixed domain')
    if not isinstance(request.get('target'),dict) or not request['target']:
        raise RuntimeError('Execution request requires an explicit target configuration')
    if request.get('purpose')!='execution-translation' or contract.get('purpose')!='execution-translation':
        raise RuntimeError('Execution purpose does not match the original requested deliverable')
    if contract.get('request_sha256')!=sha(request_path):
        raise RuntimeError('Execution contract does not match the fixed user request')
    if contract.get('execution_domain')!=request.get('domain'):
        raise RuntimeError('Execution domain does not match the fixed user request')
    if contract.get('domain_restrictions'):
        raise RuntimeError('Translation-side domain restrictions cannot narrow execution delivery')
    rows=contract.get('obligations',[])
    by_id={r.get('id'):r for r in rows}
    if len(by_id)!=len(rows) or not EXECUTION_OBLIGATIONS.issubset(by_id):
        raise RuntimeError('Execution contract omits mandatory semantic obligations')
    pending=[key for key in sorted(EXECUTION_OBLIGATIONS) if by_id[key].get('status')!='proof-backed' or not by_id[key].get('evidence')]
    if pending or contract.get('status')!='proved' or not contract.get('execution_entry') or not contract.get('source_semantics'):
        raise RuntimeError('Faithful C execution layer is incomplete; missing checked correspondence: '+', '.join(pending))
    semantics=contract['source_semantics']
    entry=contract['execution_entry']
    if not isinstance(semantics,dict) or any(not semantics.get(k) for k in ['id','version','target','source_sha256']):
        raise RuntimeError('Source semantics requires a versioned reference, target and source hashes')
    if semantics['target']!=request['target']:
        raise RuntimeError('Source semantics target differs from the fixed request')
    if not isinstance(semantics['source_sha256'],dict):
        raise RuntimeError('Source semantics hashes must be a nonempty mapping')
    if not isinstance(entry,dict) or any(not entry.get(k) for k in ['module','symbol','source','sha256']):
        raise RuntimeError('Execution entry requires a version-bound module, symbol and source')
    if sha(root/entry['source'])!=entry['sha256']:
        raise RuntimeError('Stale executable model entry')
    semantic_bindings={entry['source']:entry['sha256']}
    for name,value in semantics['source_sha256'].items():
        if sha(root/name)!=value:raise RuntimeError('Stale source-semantics dependency: '+name)
        semantic_bindings[name]=value
    # Evidence is accepted only as version-bound records of real kernel checks.
    dependencies={}
    for key in sorted(EXECUTION_OBLIGATIONS):
        for ref in by_id[key]['evidence']:
            evidence_path=root/ref
            evidence=json.loads(evidence_path.read_text())
            if evidence.get('kind')!='rocq-kernel-check' or not evidence.get('theorems') or not evidence.get('statement_artifacts'):
                raise RuntimeError('Execution evidence requires audited correspondence statements and kernel-check records')
            proof_run=root/evidence['run']
            meta=json.loads((proof_run/'run.json').read_text())
            checks=[c for c in meta.get('commands',[]) if c.get('id')==evidence.get('command_id')]
            if meta.get('status')!='passed' or len(checks)!=1 or checks[0].get('exit_code')!=0 or checks[0].get('status')!='passed':
                raise RuntimeError('Execution proof check is absent, failed or ambiguous')
            argv=checks[0].get('argv',checks[0].get('args',[]))
            if len(argv)<2 or Path(argv[0]).name not in {'rocq','coqchk'} or (Path(argv[0]).name=='rocq' and argv[1]!='check'):
                raise RuntimeError('Execution correspondence requires an independent Rocq kernel check')
            args=argv[2:] if Path(argv[0]).name=='rocq' else argv[1:]
            modules=[];index=0
            while index<len(args):
                arg=args[index]
                if arg in {'-Q','-R'}:
                    if index+2>=len(args):raise RuntimeError('Incomplete kernel load-path option')
                    index+=3;continue
                if arg=='-I':
                    if index+1>=len(args):raise RuntimeError('Incomplete kernel include option')
                    index+=2;continue
                if arg=='-silent':index+=1;continue
                if not re.fullmatch(r'[A-Za-z_][A-Za-z_0-9]*(?:\.[A-Za-z_][A-Za-z_0-9]*)*',arg):
                    raise RuntimeError('Kernel evidence may not use help/version/admit/norec or unchecked options')
                modules.append(arg);index+=1
            theorem_modules={name.rsplit('.',1)[0] for name in evidence['theorems'] if isinstance(name,str) and '.' in name}
            if not modules or len(theorem_modules)==0 or not theorem_modules.issubset(modules):
                raise RuntimeError('Kernel command must check the modules containing the claimed correspondence theorems')
            hashes=evidence.get('dependency_sha256',{})
            if not hashes or not set(evidence['statement_artifacts']).issubset(hashes):
                raise RuntimeError('Execution statements and dependencies are not version bound')
            for name,value in hashes.items():
                if sha(root/name)!=value:raise RuntimeError('Stale execution proof dependency: '+name)
                dependencies[name]=value
            dependencies[str(evidence_path.relative_to(root))]=sha(evidence_path)
    bindings={str(request_path.relative_to(root)):sha(request_path),str(contract_path.relative_to(root)):sha(contract_path),**semantic_bindings,**dependencies}
    return bindings


