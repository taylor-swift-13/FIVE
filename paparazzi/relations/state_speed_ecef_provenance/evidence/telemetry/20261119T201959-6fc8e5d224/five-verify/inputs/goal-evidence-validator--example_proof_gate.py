"""Strict current proof receipt validation; historical attempts remain immutable."""
import hashlib
import json
from pathlib import Path
import re


def digest(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def certificate_source(imports, bindings):
    return ''.join(f'Require Import {name}.\n' for name in imports) + ''.join(
        f'Definition goal_{i} : {row["type"]} := {row["theorem"]}.\nPrint Assumptions goal_{i}.\n'
        for i, row in enumerate(bindings))


def input_index(root, active):
    """Explicit adapters for retained index formats, never a default empty list."""
    choices = [p for p in (active / 'inputs.json', active / 'provenance.json') if p.is_file()]
    if len(choices) != 1:
        raise ValueError('exactly one input index is required: ' + str(active))
    path = choices[0]
    data = json.loads(path.read_text())
    schema = data.get('schema')
    if schema == 'five-proof-attempt-provenance/1':
        groups = [(root, data.get('files'))]
    elif schema == 'five-proof-provenance/1':
        stages = [p for p in active.parents if p.name == 'rocq']
        if len(stages) != 1 or not data.get('model_configuration'):
            raise ValueError('invalid case provenance context: ' + str(path))
        groups = [(stages[0].parent, data.get('inputs')), (root, data.get('shared_inputs'))]
    elif schema == 'five-proof-inputs/1':
        hashes = data.get('dependency_sha256')
        semantics = data.get('semantic_dependencies')
        if not isinstance(hashes, dict) or not hashes or not isinstance(semantics, dict) or not semantics:
            raise ValueError('missing dependency/semantic hash maps: ' + str(path))
        for name, value in semantics.items():
            source = Path(name)
            if not source.is_absolute() or not source.is_file() or digest(source) != value:
                raise ValueError('stale external semantic dependency: ' + str(source))
        groups = [(root, [{'path': name, 'sha256': value} for name, value in hashes.items()])]
    elif path.name == 'inputs.json' and schema is None:
        # The two published pre-versioned layouts have distinct path bases.
        keys = [key for key in ('inputs', 'artifacts') if key in data]
        if len(keys) != 1:
            raise ValueError('ambiguous/missing legacy input rows: ' + str(path))
        key = keys[0]
        groups = [(active if key == 'artifacts' else root, data.get(key))]
    else:
        raise ValueError('unsupported input index schema: ' + str(path))
    rows = []
    for base, entries in groups:
        if not isinstance(entries, list) or not entries:
            raise ValueError('empty/malformed input index: ' + str(path))
        rows.extend((base, row) for row in entries)
    resolved = {}
    for base, row in rows:
        if not isinstance(row, dict) or not isinstance(row.get('path'), str) or not row['path'] or not re.fullmatch('[0-9a-f]{64}', str(row.get('sha256', ''))):
            raise ValueError('malformed input row: ' + str(path))
        source = (base / row['path']).resolve()
        if source in resolved or not source.is_file():
            raise ValueError('duplicate/missing indexed input: ' + str(source))
        resolved[source] = row['sha256']
    return path, resolved


def validate_current(root, problem, active, status):
    from compcert_gate import kernel_record
    root = Path(root).resolve()
    path = active / 'evidence/goal-validation.json'
    data = json.loads(path.read_text())
    if data.get('schema') != 'five-proof-validation/1':
        raise ValueError('unsupported current proof validation schema')
    def checked(row):
        if not isinstance(row, dict) or not isinstance(row.get('path'), str):
            raise ValueError('malformed current binding')
        source = (root / row['path']).resolve()
        if not source.is_relative_to(root) or not source.is_file() or digest(source) != row.get('sha256'):
            raise ValueError('stale/missing current binding: ' + str(source))
        return source
    index, historical = input_index(root, active)
    if checked(data.get('index')) != index:
        raise ValueError('wrong input index binding')
    rows = data.get('inputs')
    if not isinstance(rows, list) or not rows:
        raise ValueError('missing current input bindings')
    current, snapshots = {}, {}
    for row in rows:
        source = checked(row)
        if source in current:
            raise ValueError('duplicate current input')
        current[source] = row['sha256']
        if row.get('snapshot'):
            snapshot = (root / row['snapshot']).resolve()
            if not snapshot.is_relative_to(root) or not snapshot.is_file() or digest(snapshot) != row['sha256']:
                raise ValueError('current source differs from compiled snapshot: ' + str(source))
            if snapshot in snapshots:
                raise ValueError('ambiguous compiled snapshot')
            snapshots[snapshot] = source
    required = set(historical) | {problem / 'Spec.v', active / 'Proof.v', active / 'check.py'}
    if not required.issubset(current):
        raise ValueError('current bindings omit indexed/proof/spec/checker inputs')
    # Old manifest histories are immutable, but current executable sources must
    # still match their original index as well as their fresh compiled snapshot.
    for source, old_hash in historical.items():
        if source.suffix in ('.v', '.c') and current[source] != old_hash:
            raise ValueError('source differs from retained input index: ' + str(source))
    if not {problem / 'Spec.v', active / 'Proof.v'}.issubset(set(snapshots.values())):
        raise ValueError('current Proof/Spec missing compiled snapshots')
    receipt_ref = data['kernel_evidence']
    kernel_record(root, receipt_ref)
    receipt = json.loads((root / receipt_ref).read_text())
    dependencies = {(root / name).resolve(): value for name, value in receipt['dependency_sha256'].items()}
    if set(dependencies) != set(snapshots):
        raise ValueError('current source bindings do not cover exact kernel dependency closure')
    if any(current[snapshots[p]] != value for p, value in dependencies.items()):
        raise ValueError('kernel dependency hash differs from current source')
    proof_run = json.loads((root / receipt['run'] / 'run.json').read_text())
    def full_compile(command):
        # Reference full-build shape only: load paths, harmless output flags,
        # and exactly one source. Output/module overrides can leave stale .vo
        # files at the path later consumed by the kernel, so fail closed.
        argv = command.get('argv', [])
        if not argv or command.get('status') != 'passed' or command.get('exit_code') != 0:
            return False
        if Path(argv[0]).name == 'rocq' and argv[1:2] == ['compile']:
            args = argv[2:]
        elif Path(argv[0]).name == 'coqc':
            args = argv[1:]
        else:
            return False
        sources = 0
        i = 0
        while i < len(args):
            if args[i] in ('-Q', '-R') and i + 2 < len(args):
                i += 3
            elif args[i] == '-I' and i + 1 < len(args):
                i += 2
            elif args[i] in ('-q', '-quiet', '-time'):
                i += 1
            elif not args[i].startswith('-') and args[i].endswith('.v'):
                sources += 1
                i += 1
            else:
                return False
        return sources == 1
    compiled = set()
    for command in proof_run.get('commands', []):
        argv = command.get('argv', [])
        if full_compile(command):
            compiled.update((Path(command['cwd']) / arg).resolve() for arg in argv[1:] if arg.endswith('.v'))
    if not set(dependencies).issubset(compiled):
        raise ValueError('kernel dependency source was not compiled in the bound proof run')
    kernel_commands = [c for c in proof_run.get('commands', []) if c.get('id') == receipt['command_id']]
    def module_candidates(command, module):
        args = command['argv']; mappings = []
        for i, arg in enumerate(args):
            if arg in ('-Q', '-R') and i + 2 < len(args):
                mappings.append((args[i + 2], (Path(command['cwd']) / args[i + 1]).resolve()))
        matching = [(prefix, directory) for prefix, directory in mappings if module == prefix or module.startswith(prefix + '.')]
        if not matching:
            return []
        longest = max(len(prefix) for prefix, _ in matching)
        matching = [(prefix, directory) for prefix, directory in matching if len(prefix) == longest]
        if len(matching) != 1:
            raise ValueError('ambiguous logical namespace mapping: ' + module)
        prefix, directory = matching[0]
        return [directory.joinpath(*module[len(prefix):].strip('.').split('.')).with_suffix('.v')]
    for theorem in receipt['theorems']:
        module = theorem.rsplit('.', 1)[0]
        candidates = module_candidates(kernel_commands[0], module)
        if len(candidates) != 1 or candidates[0] not in dependencies:
            raise ValueError('kernel theorem module does not resolve to bound dependency snapshot')
        source = candidates[0]
        matching_compiles = [c for c in proof_run.get('commands', []) if full_compile(c) and any((Path(c['cwd']) / arg).resolve() == source for arg in c['argv'] if arg.endswith('.v'))]
        if not matching_compiles or any(module_candidates(c, module) != [source] for c in matching_compiles):
            raise ValueError('proof compile and kernel namespace mappings differ')
    bindings = data.get('goal_bindings')
    goals = status.get('requested_goals')
    if not isinstance(bindings, list) or not bindings or not isinstance(goals, list) or len(set(goals)) != len(goals):
        raise ValueError('missing/malformed goal bindings')
    if [r.get('requested_goal') for r in bindings] != goals:
        raise ValueError('requested goals differ from certified goals')
    ident = r'[A-Za-z_][A-Za-z_0-9]*(?:\.[A-Za-z_][A-Za-z_0-9]*)*'
    for row in bindings:
        if not re.fullmatch(ident, str(row.get('theorem', ''))) or not isinstance(row.get('type'), str) or not row['type'].strip() or any(token in row['type'] for token in ('(*', '*)', '\n', '\r')) or re.search(r'\.(?:\s|$)', row['type']):
            raise ValueError('malformed theorem/type binding')
        if row['theorem'] not in receipt['theorems']:
            raise ValueError('goal theorem is not claimed by kernel receipt')
    cert = data['certificate']
    certificate = checked(cert)
    imports = cert.get('imports')
    if not isinstance(imports, list) or not imports or not all(re.fullmatch(ident, str(n)) for n in imports):
        raise ValueError('malformed certificate imports')
    if certificate.read_text() != certificate_source(imports, bindings):
        raise ValueError('certificate does not express exact theorem-to-goal bindings')
    run = json.loads((root / cert['run'] / 'run.json').read_text())
    if run.get('status') != 'passed':
        raise ValueError('certificate run did not pass')
    run_inputs = {Path(x['source']).resolve(): x['sha256'] for x in run.get('inputs', [])}
    if run_inputs.get(certificate) != cert['sha256'] or any(run_inputs.get(p) != h for p, h in dependencies.items()):
        raise ValueError('certificate run omitted actual certificate/dependency snapshot')
    def command(command_id):
        rows = [c for c in run.get('commands', []) if c.get('id') == command_id]
        if len(rows) != 1 or rows[0].get('exit_code') != 0 or rows[0].get('status') != 'passed':
            raise ValueError('missing/failed certificate command')
        return rows[0]
    compile_row = command(cert['compile_command_id'])
    stdout = compile_row.get('stdout')
    if not isinstance(stdout, str) or not (root / cert['run'] / stdout).is_file() or not (root / cert['run'] / stdout).stat().st_size:
        raise ValueError('missing actual certificate Print Assumptions output')
    argv = compile_row['argv']
    if not full_compile(compile_row) or not any((Path(compile_row['cwd']) / arg).resolve() == certificate for arg in argv if arg.endswith('.v')):
        raise ValueError('certificate was not actually compiled')
    # Reuse canonical independent-kernel and compilation/snapshot checks for
    # certificate module, avoiding a second permissive argv implementation.
    certificate_receipt = cert['kernel_evidence']
    kernel_record(root, certificate_receipt)
    ce = json.loads((root / certificate_receipt).read_text())
    if ce['run'] != cert['run'] or ce['command_id'] != cert['kernel_command_id'] or ce['theorems'] != [cert['module'] + '.goal_' + str(i) for i in range(len(bindings))] or ce['statement_artifacts'] != [cert['path']] or ce['dependency_sha256'] != {**receipt['dependency_sha256'], cert['path']: cert['sha256']}:
        raise ValueError('certificate kernel receipt differs from exact certification')
    # Imports must resolve to the very same compiled dependency source paths.
    for row in (compile_row, command(cert['kernel_command_id'])):
        for module in set(imports) | {b['theorem'].rsplit('.', 1)[0] for b in bindings} | {b['type'].rsplit('.', 1)[0] for b in bindings if re.fullmatch(ident, b['type']) and '.' in b['type']}:
            candidates = module_candidates(row, module)
            if not any(p in dependencies for p in candidates):
                raise ValueError('certificate import not bound to actual compiled snapshot: ' + module)
        if certificate not in module_candidates(row, cert['module']):
            raise ValueError('certificate module does not resolve to actual compiled certificate')
