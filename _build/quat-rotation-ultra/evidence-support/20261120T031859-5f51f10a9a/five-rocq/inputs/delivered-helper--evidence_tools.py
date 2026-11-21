#!/usr/bin/env python3
"""Exact dependency snapshots and strict Rocq theorem/goal receipts.

Use check(config, record_run=RUN_DIR), or this module's CLI. A recorded invocation
adds measured commands to an already-open five-rocq phase. The caller finishes
that phase after all work; this utility never fabricates a completed run status.
"""
from pathlib import Path
import argparse
import hashlib
import json
import re
import shutil
import subprocess
import sys
import tempfile

IDENT = r'[A-Za-z_][A-Za-z_0-9]*(?:\.[A-Za-z_][A-Za-z_0-9]*)*'


def digest(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def dump(path, data):
    path = Path(path)
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(data, indent=2) + '\n')


def imports(path):
    """Read static Require imports without interpreting or rewriting Rocq."""
    source = re.sub(r'\(\*.*?\*\)', '', Path(path).read_text(), flags=re.S)
    result = []
    pattern = r'From\s+(' + IDENT + r')\s+Require\s+(?:Import\s+|Export\s+)?([A-Za-z0-9_.\s]+?)\.(?=\s|$)'
    for prefix, names in re.findall(pattern, source):
        result.extend(prefix + '.' + name for name in names.split())
    source = re.sub(pattern, '', source)
    pattern = r'Require\s+(?:Import\s+|Export\s+)?([A-Za-z0-9_.\s]+?)\.(?=\s|$)'
    for names in re.findall(pattern, source):
        result.extend(names.split())
    return result


def _resolve_path(root, value):
    path = (root / value).resolve()
    if not path.is_relative_to(root):
        raise ValueError('Source outside repository: ' + str(path))
    return path


def dependency_order(root, mappings, modules, roots):
    """Resolve the requested imports; installed Stdlib/CompCert stay external."""
    order, seen, active = [], set(), set()
    def resolve(name):
        if name in modules:
            return _resolve_path(root, modules[name])
        prefixes = [prefix for prefix in mappings if name.startswith(prefix + '.')]
        if not prefixes:
            if name.startswith(('Stdlib.', 'Coq.', 'compcert.', 'Flocq.')):
                return None
            raise ValueError('Unmapped project import: ' + name)
        prefix = max(prefixes, key=len)
        return _resolve_path(root, mappings[prefix]).joinpath(*name[len(prefix) + 1:].split('.')).with_suffix('.v')
    def visit(name):
        if name in seen:
            return
        path = resolve(name)
        if path is None:
            return
        if name in active:
            raise ValueError('Cyclic project import: ' + name)
        if not path.is_file():
            raise FileNotFoundError(str(path))
        active.add(name)
        for child in imports(path):
            visit(child)
        active.remove(name)
        seen.add(name)
        order.append((name, path))
    for name in roots:
        visit(name)
    if not order:
        raise ValueError('Empty proof dependency closure')
    return order


def _safe_capture(run, path, role):
    """Do not reuse an input-copy name with different bytes."""
    path = Path(path).resolve()
    role = re.sub(r'[^A-Za-z0-9_.-]+', '-', role)
    target = run.folder / 'inputs' / (role + '--' + path.name)
    if target.exists() and digest(target) != digest(path):
        raise ValueError('Immutable run input-copy conflict: ' + str(target))
    prior = run.read('inputs/manifest.json')
    existing = [row for row in prior if row.get('source') == str(path)]
    if existing and any(row.get('sha256') != digest(path) for row in existing):
        raise ValueError('Source changed within a proof run: ' + str(path))
    if not existing:
        run.capture(path, role, area='inputs')


def _check_configuration(config, root):
    required = ('attempt', 'namespace', 'mappings', 'modules', 'imports', 'goal_bindings')
    for key in required:
        if not config.get(key):
            raise ValueError('Missing configuration: ' + key)
    namespace = config['namespace']
    if not re.fullmatch(IDENT, namespace):
        raise ValueError('Invalid certificate namespace')
    goals = config['goal_bindings']
    names = [row.get('requested_goal') for row in goals]
    if len(set(names)) != len(names) or not all(isinstance(name, str) and name for name in names):
        raise ValueError('Missing or duplicate requested goals')
    for row in goals:
        if not re.fullmatch(IDENT, str(row.get('theorem', ''))):
            raise ValueError('Invalid theorem name')
        ty = row.get('type')
        if not isinstance(ty, str) or not ty.strip() or any(t in ty for t in ('(*', '*)', '\n', '\r')) or re.search(r'\.(?:\s|$)', ty):
            raise ValueError('Invalid exact expected Rocq type')
    attempt = _resolve_path(root, config['attempt'])
    for relative in ('Proof.v', 'check.py'):
        if not (attempt / relative).is_file():
            raise FileNotFoundError(str(attempt / relative))
    return attempt


def check(config, record_run=None):
    """Compile exact closure and certify every requested theorem's expected type.

    Configuration keys: root, attempt, namespace, mappings, modules, imports,
    goal_bindings; optional extra_inputs, gate_inputs, build, rocq, timeout.
    Paths are repository-relative except the explicit root and Rocq executable.
    mappings maps logical namespace to source directory. modules overrides exact
    logical module names (e.g. Spec/Proof in different problem/attempt folders).
    For recorded builds, receipts are written only after successful checking.
    """
    root = Path(config.get('root', Path.cwd())).resolve()
    attempt = _check_configuration(config, root)
    sys.path.insert(0, str(root / 'scripts'))
    from example_proof_gate import certificate_source, input_index
    from five_telemetry import Run
    run = Run(record_run) if record_run else None
    if run and run.read('run.json').get('status') not in ('running', 'pending'):
        raise ValueError('Recorded checker requires an open phase run')
    if (attempt / 'provenance.json').exists() or (attempt / 'inputs.json').exists():
        _, historical = input_index(root, attempt)
        for source, old_hash in historical.items():
            if source.suffix in ('.v', '.c') and digest(source) != old_hash:
                raise ValueError('Retained attempt input changed; create a new attempt: ' + str(source))
    roots = list(config['imports'])
    roots += [row['theorem'].rsplit('.', 1)[0] for row in config['goal_bindings']]
    order = dependency_order(root, config['mappings'], config['modules'], roots)
    for row in config['goal_bindings']:
        if row['theorem'].rsplit('.', 1)[0] not in {name for name, _ in order}:
            raise ValueError('Goal theorem module is outside compiled closure')
    if run:
        fingerprint = hashlib.sha256(json.dumps([(name, digest(path)) for name, path in order], sort_keys=True).encode()).hexdigest()[:16]
        build = _resolve_path(root, config['build']) if config.get('build') else run.folder / 'evidence' / (config['namespace'] + '-' + fingerprint)
        result = _compile(config, root, attempt, run, build, order, certificate_source)
        return result
    with tempfile.TemporaryDirectory(prefix='five-quat-receipts-') as temporary:
        return _compile(config, root, attempt, None, Path(temporary), order, certificate_source)


def _compile(config, root, attempt, run, build, order, certificate_source):
    namespace = config['namespace']
    namespaces = list(config['mappings'])
    for name, _ in order:
        if not any(name.startswith(prefix + '.') for prefix in namespaces):
            namespaces.append(name.rsplit('.', 1)[0])
    if namespace not in namespaces:
        namespaces.append(namespace)
    nsmap = {prefix: build / prefix for prefix in namespaces}
    flags = []
    for prefix, directory in nsmap.items():
        directory.mkdir(parents=True, exist_ok=True)
        flags += ['-Q', str(directory), prefix]
    sources, bindings = [], []
    for name, original in order:
        prefix = max((prefix for prefix in nsmap if name.startswith(prefix + '.')), key=len)
        snapshot = nsmap[prefix].joinpath(*name[len(prefix) + 1:].split('.')).with_suffix('.v')
        snapshot.parent.mkdir(parents=True, exist_ok=True)
        if snapshot.exists() and digest(snapshot) != digest(original):
            raise ValueError('Immutable compiled-source snapshot differs: ' + str(snapshot))
        if not snapshot.exists():
            shutil.copyfile(original, snapshot)
        sources.append(snapshot)
        if run:
            bindings.append({'path': str(original.relative_to(root)), 'sha256': digest(original), 'snapshot': str(snapshot.relative_to(root))})
            _safe_capture(run, snapshot, 'compiled-' + namespace + '-' + name)
    extra = [attempt / 'check.py', Path(__file__).resolve()]
    extra += [_resolve_path(root, path) for path in config.get('extra_inputs', [])]
    gate_inputs = [_resolve_path(root, path) for path in config.get('gate_inputs', [])]
    for path in [*extra, *gate_inputs]:
        if not path.is_file():
            raise FileNotFoundError(str(path))
        if run:
            _safe_capture(run, path, 'context-' + namespace + '-' + hashlib.sha256(str(path).encode()).hexdigest()[:14])
    executable = config.get('rocq', '/home/yangfp/.opam/five/bin/rocq')
    def command(argv, label):
        if run:
            return run.command(argv, label, timeout=config.get('timeout', 600), cwd=str(root))
        subprocess.run(argv, cwd=root, check=True)
        return None
    for i, source in enumerate(sources):
        argv = [executable, 'compile', *flags, str(source)]
        earlier = run.read('commands.json') if run else []
        if not (source.with_suffix('.vo').exists() and any(row.get('argv') == argv and row.get('status') == 'passed' and row.get('exit_code') == 0 for row in earlier)):
            command(argv, namespace + '-dependency-' + str(i))
    certificate = nsmap[namespace] / 'GoalBinding.v'
    expected = certificate_source(config['imports'], config['goal_bindings'])
    if certificate.exists() and certificate.read_text() != expected:
        raise ValueError('Immutable certificate snapshot differs')
    certificate.write_text(expected)
    if run:
        _safe_capture(run, certificate, 'certificate-' + namespace)
    compile_record = command([executable, 'compile', *flags, str(certificate)], namespace + '-goal-certificate')
    theorem_modules = list(dict.fromkeys(row['theorem'].rsplit('.', 1)[0] for row in config['goal_bindings']))
    certificate_module = namespace + '.GoalBinding'
    kernel_record = command([executable, 'check', '-silent', *flags, *theorem_modules, certificate_module], namespace + '-independent-kernel')
    if not run:
        return {'status': 'passed', 'compiled_modules': len(sources), 'theorems': [row['theorem'] for row in config['goal_bindings']]}
    evidence = attempt / 'evidence'
    runpath = str(run.folder.relative_to(root))
    dependencies = {str(path.relative_to(root)): digest(path) for path in sources}
    statements = [str(snapshot.relative_to(root)) for (name, _), snapshot in zip(order, sources) if name in config['imports'] or name in theorem_modules]
    receipt = {'kind': 'rocq-kernel-check', 'run': runpath, 'command_id': kernel_record['id'], 'theorems': [row['theorem'] for row in config['goal_bindings']], 'statement_artifacts': statements, 'dependency_sha256': dependencies}
    dump(evidence / 'kernel-evidence.json', receipt)
    gate_receipt = {**receipt, 'dependency_sha256': {**dependencies, **{str(path.relative_to(root)): digest(path) for path in gate_inputs}}}
    dump(evidence / 'gate-kernel-evidence.json', gate_receipt)
    certpath = str(certificate.relative_to(root))
    cert_receipt = {**receipt, 'theorems': [certificate_module + '.goal_' + str(i) for i in range(len(config['goal_bindings']))], 'statement_artifacts': [certpath], 'dependency_sha256': {**dependencies, certpath: digest(certificate)}}
    dump(evidence / 'certificate-kernel-evidence.json', cert_receipt)
    indexed = {row['path']: row['sha256'] for row in bindings}
    indexed.update({str(path.relative_to(root)): digest(path) for path in [*extra, *gate_inputs]})
    provenance = attempt / 'provenance.json'
    if not provenance.exists():
        dump(provenance, {'schema': 'five-proof-attempt-provenance/1', 'files': [{'path': path, 'sha256': value} for path, value in sorted(indexed.items())]})
    else:
        from example_proof_gate import input_index
        _, historical = input_index(root, attempt)
        if {str(path.relative_to(root)): value for path, value in historical.items()} != indexed:
            raise ValueError('Existing attempt provenance differs; create a new attempt')
    bound = {row['path']: row for row in bindings}
    for path, value in indexed.items():
        bound.setdefault(path, {'path': path, 'sha256': value})
    validation = {'schema': 'five-proof-validation/1', 'index': {'path': str(provenance.relative_to(root)), 'sha256': digest(provenance)}, 'inputs': list(bound.values()), 'kernel_evidence': str((evidence / 'kernel-evidence.json').relative_to(root)), 'goal_bindings': config['goal_bindings'], 'certificate': {'path': certpath, 'sha256': digest(certificate), 'module': certificate_module, 'imports': config['imports'], 'run': runpath, 'compile_command_id': compile_record['id'], 'kernel_command_id': kernel_record['id'], 'kernel_evidence': str((evidence / 'certificate-kernel-evidence.json').relative_to(root))}}
    dump(evidence / 'goal-validation.json', validation)
    return {'status': 'passed', 'compiled_modules': len(sources), 'run': runpath, 'kernel_evidence': str((evidence / 'kernel-evidence.json').relative_to(root)), 'gate_kernel_evidence': str((evidence / 'gate-kernel-evidence.json').relative_to(root)), 'goal_validation': str((evidence / 'goal-validation.json').relative_to(root)), 'print_assumptions_stdout': str((run.folder / compile_record['stdout']).relative_to(root))}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--config', required=True)
    parser.add_argument('--record-run')
    arguments = parser.parse_args()
    print(json.dumps(check(json.loads(Path(arguments.config).read_text()), arguments.record_run), indent=2))


if __name__ == '__main__':
    main()
