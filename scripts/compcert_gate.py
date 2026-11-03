"""five-verify acceptance: provenance + five-rocq proofs + CBMC spec recheck.

This gate is not a completion requirement for five-align's generated artifacts.
"""
import json,re
from pathlib import Path
from five_telemetry import sha
from execution_contract import _execution_contract
from compcert_backend import audit

CONTRACT_REPLACEMENT_FLAGS={'--apply-loop-contracts','--replace-call-with-contract',
 '--enforce-contract','--enforce-contract-rec','--function-contracts'}

def kernel_record(root,ref):
    root=Path(root);p=root/ref;e=json.loads(p.read_text())
    if e.get('kind')!='rocq-kernel-check' or not e.get('theorems') or not e.get('statement_artifacts'):
        raise RuntimeError('Spec recheck requires actual Rocq theorem statements and kernel evidence')
    r=json.loads((root/e['run']/'run.json').read_text())
    rows=[c for c in r.get('commands',[]) if c['id']==e.get('command_id')]
    if r.get('status')!='passed' or len(rows)!=1 or rows[0].get('status')!='passed' or rows[0].get('exit_code')!=0:
        raise RuntimeError('Spec kernel check missing, failed or ambiguous')
    a=rows[0]['argv'];tool=Path(a[0]).name
    if tool=='rocq' and len(a)>1 and a[1]=='check':a=a[2:]
    elif tool=='coqchk':a=a[1:]
    else:raise RuntimeError('Spec evidence is not independent kernel checking')
    modules=[];i=0
    while i<len(a):
        if a[i] in ['-Q','-R']:i+=3;continue
        if a[i]=='-I':i+=2;continue
        if a[i]=='-silent':i+=1;continue
        if not re.fullmatch(r'[A-Za-z_][A-Za-z_0-9]*(?:\.[A-Za-z_][A-Za-z_0-9]*)*',a[i]):
            raise RuntimeError('Unchecked/admit/help kernel option rejected')
        modules.append(a[i]);i+=1
    if not {t.rsplit('.',1)[0] for t in e['theorems']}.issubset(modules):
        raise RuntimeError('Kernel check did not check the claimed theorem modules')
    hashes=e.get('dependency_sha256',{})
    if not set(e['statement_artifacts']).issubset(hashes):raise RuntimeError('Unbound recheck statements')
    snapshots={Path(x['source']).resolve():x['sha256'] for x in r.get('inputs',[])}
    for n,h in hashes.items():
        if sha(root/n)!=h:raise RuntimeError('Stale recheck proof dependency: '+n)
        if snapshots.get((root/n).resolve())!=h:
            raise RuntimeError('Recheck dependency differs from the actual kernel-run input snapshot: '+n)
    for statement in e['statement_artifacts']:
        compiled=False
        for command in r.get('commands',[]):
            argv=command['argv']
            is_compile=(Path(argv[0]).name=='rocq' and len(argv)>1 and argv[1]=='compile') or Path(argv[0]).name=='coqc'
            if is_compile and command.get('status')=='passed' and any(
                arg.endswith('.v') and (Path(command['cwd'])/arg).resolve()==(root/statement).resolve() for arg in argv[1:]):
                compiled=True
        if not compiled:raise RuntimeError('Claimed statement was not compiled in its bound proof run: '+statement)
    return {str(p):sha(p),**hashes}

def check_spec_recheck(root,path,request_sha,manifest_sha,original_c,execution_bindings=None):
    root=Path(root);p=root/path;s=json.loads(p.read_text())
    if s.get('schema')!='five-cbmc-rocq-recheck/1' or s.get('request_sha256')!=request_sha or s.get('backend_manifest_sha256')!=manifest_sha:
        raise RuntimeError('Missing/stale CBMC-to-Rocq recheck ledger')
    if s.get('verification_method')!='traditional-bounded-model-checking':
        raise RuntimeError('CBMC must use traditional symbolic execution/BMC, not contract replacement')
    run=json.loads((root/s['cbmc_run']/'run.json').read_text())
    cmds=[c for c in run.get('commands',[]) if c['id']==s.get('cbmc_command_id')]
    if len(cmds)!=1 or Path(cmds[0]['argv'][0]).name!='cbmc':raise RuntimeError('Missing original CBMC invocation')
    argv=cmds[0]['argv']
    if cmds[0].get('exit_code') not in [0,10] or cmds[0].get('status') not in ['passed','failed']:
        raise RuntimeError('CBMC invocation did not complete with a verification result')
    if any(a.split('=')[0] in CONTRACT_REPLACEMENT_FLAGS for a in argv):
        raise RuntimeError('Contract-replacement CBMC mode is outside the requested BMC workflow')
    bindings=s.get('cbmc_input_sha256',{})
    snapshots={Path(x['source']).resolve():x['sha256'] for x in run.get('inputs',[])}
    if original_c not in bindings:raise RuntimeError('CBMC ledger does not bind the original C implementation')
    for n,h in bindings.items():
        if sha(root/n)!=h:raise RuntimeError('Stale CBMC harness/source: '+n)
        if snapshots.get((root/n).resolve())!=h:raise RuntimeError('CBMC input differs from actual run snapshot: '+n)
    if not any(a.endswith('.c') for a in argv[1:]):raise RuntimeError('CBMC must inspect raw C, not a pre-replaced goto model')
    for arg in argv[1:]:
        if arg.endswith('.c'):
            actual=(Path(cmds[0]['cwd'])/arg).resolve()
            if not any((root/n).resolve()==actual for n in bindings):raise RuntimeError('Unbound CBMC C input')
    cb=root/s['cbmc_json'];raw=json.loads(cb.read_text())
    if cb.resolve()!=(root/s['cbmc_run']/cmds[0]['stdout']).resolve():
        raise RuntimeError('CBMC JSON is not the recorded invocation output')
    properties=[r for block in raw for r in block.get('result',[])]
    statuses={r['property']:r['status'] for r in properties}
    if len(statuses)!=len(properties):raise RuntimeError('Duplicate CBMC property IDs')
    if not statuses:raise RuntimeError('No actual CBMC properties')
    entries=s.get('properties',[]);mapped={x.get('property_id'):x for x in entries}
    if len(mapped)!=len(entries) or set(mapped)!=set(statuses):raise RuntimeError('Rocq recheck omits/duplicates actual CBMC properties')
    result={str(p):sha(p),str(cb):sha(cb),**bindings}
    for ident,status in statuses.items():
        row=mapped[ident]
        if status not in ['SUCCESS','FAILURE']:raise RuntimeError('Unknown/incomplete CBMC property: '+ident)
        expected='proved' if status=='SUCCESS' else 'refuted'
        if row.get('status')!=expected or not row.get('scope') or not row.get('theorem') or not row.get('evidence'):
            raise RuntimeError('Missing exact-scope Rocq reproof/refutation: '+ident)
        if status=='FAILURE':
            if not row.get('counterexample_replay'):
                raise RuntimeError('Real CBMC failure requires bit/byte/prefix counterexample replay')
            replay_path=root/row['counterexample_replay'];replay=json.loads(replay_path.read_text())
            trace=next(r for r in properties if r['property']==ident).get('trace')
            if not trace or replay.get('status')!='reproduced' or replay.get('property_id')!=ident or replay.get('request_sha256')!=request_sha or replay.get('backend_manifest_sha256')!=manifest_sha or replay.get('cbmc_json_sha256')!=sha(cb):
                raise RuntimeError('Counterexample replay is missing, stale or unbound to real trace')
            if not {'input_state','fault_operation','memory_prefix','bit_observations'}.issubset(replay):
                raise RuntimeError('Counterexample replay omits input/operation/bytes/bits')
            result[str(replay_path)]=sha(replay_path)
        for ref in row['evidence']:
            evidence=json.loads((root/ref).read_text())
            if row['theorem'] not in evidence.get('theorems',[]):raise RuntimeError('Claimed recheck theorem not kernel-bound')
            for name,h in (execution_bindings or {}).items():
                if evidence.get('dependency_sha256',{}).get(name)!=h:raise RuntimeError('Recheck theorem is not bound to the actual execution model')
            result.update(kernel_record(root,ref))
    failed=sum(v=='FAILURE' for v in statuses.values())
    if cmds[0]['exit_code']!=(10 if failed else 0):raise RuntimeError('CBMC result and exit status disagree')
    return {'bindings':result,'proved':len(statuses)-failed,'refuted':failed}

def check_external_support(root,manifest,contract):
    from ast_library_audit import audit_source
    root=Path(root).resolve()
    registry_path=root/'shared/compcert_libc/registry.json'
    registry=json.loads(registry_path.read_text())
    inventory=audit_source(root/manifest['files']['Source.v']['path'],[manifest['function']],registry,root)
    if not inventory['support_inventory_complete']:
        raise RuntimeError('AST contains unresolved calls, unsupported system interfaces, builtins or worlds')
    ordinary={r['support']['name']:r['support'] for r in inventory['static_calls']
              if r.get('support',{}).get('status')=='ordinary-adapter-available'}
    sources=contract.get('source_semantics',{}).get('source_sha256',{})
    for name,row in ordinary.items():
        needed={str(registry_path.relative_to(root)):sha(registry_path),**row['dependency_sha256']}
        for path,digest in needed.items():
            if sources.get(path)!=digest:
                raise RuntimeError('Ordinary library adapter/spec/proof/registry not bound: '+path)
        binding=contract.get('external_library_bindings',{}).get(name,{})
        if binding.get('callback')!=row['adapter']['callback'] or binding.get('specification')!=row['adapter']['specification'] or not binding.get('assumption'):
            raise RuntimeError('Missing explicit callback, specification or trusted library-contract assumption: '+name)
    return inventory

def accept_compcert_delivery(root,*,request_path,contract_path,expected_request_sha256,
                            manifest_path,spec_recheck_path):
    root=Path(root).resolve();manifest_path=root/manifest_path
    m=json.loads(manifest_path.read_text());req=json.loads((root/request_path).read_text())
    if req.get('execution_backend')!='compcert-csyntax-cexec':
        raise RuntimeError('Current delivery requires a frozen CompCert-backed request; historical approval is not migrated')
    if not m.get('request') or m['request']['sha256']!=expected_request_sha256:
        raise RuntimeError('CompCert export is not bound to the frozen request')
    if m['target']!=req.get('target'):raise RuntimeError('CompCert target differs from request')
    provenance=audit(manifest_path)
    contract=json.loads((root/contract_path).read_text())
    if contract.get('execution_backend')!='compcert-csyntax-cexec' or contract.get('backend_manifest_sha256')!=sha(manifest_path):
        raise RuntimeError('Execution proof contract is not bound to this CompCert export')
    external_inventory=check_external_support(root,m,contract)
    issues=contract.get('alignment_issues')
    if not isinstance(issues,list) or len({x.get('issue_id') for x in issues})!=len(issues) or any(x.get('status')!='resolved' for x in issues):
        raise RuntimeError('Missing or unresolved alignment issues')
    hashes=_execution_contract(root,request_path,contract_path,expected_request_sha256=expected_request_sha256)
    for row in contract['obligations']:
        for ref in row['evidence']:kernel_record(root,ref)
    entry=contract['execution_entry'];wrapper=m['files']['Execution.v']
    if entry['source']!=wrapper['path'] or entry['sha256']!=wrapper['sha256'] or entry['symbol']!='entry' or entry['module']!=m['namespace']+'.Execution':
        raise RuntimeError('Contract execution entry is not the generated original-Cexec wrapper')
    dependencies=contract['source_semantics']['source_sha256']
    for row in [m['source'],m['files']['Source.v'],wrapper]:
        if dependencies.get(row['path'])!=row['sha256']:raise RuntimeError('Proof contract does not bind original C/AST/wrapper')
    spec=check_spec_recheck(root,spec_recheck_path,expected_request_sha256,sha(manifest_path),m['source']['path'],
      {row['path']:row['sha256'] for row in [m['source'],m['files']['Source.v'],wrapper]})
    return {'status':'accepted','workflow':'compcert-single-agent','execution_layer_accepted':True,
      'external_support_inventory_complete':external_inventory['support_inventory_complete'],
      'library_implementation_verified':False,
      'cbmc_method':'traditional-bounded-model-checking','cbmc_specifications_rechecked_in_rocq':True,
      'issues_found':len(issues),'resolved':len(issues),'open':0,
      'cbmc_properties_proved':spec['proved'],'cbmc_properties_refuted':spec['refuted'],
      'implementation_properties_all_proved':spec['refuted']==0,
      'checked_bindings':len({**hashes,**provenance['bindings'],**spec['bindings']}),
      'trust_note':'Metadata binds real exports/proofs; proposition adequacy and frontend/FFI assumptions remain explicit.'}
