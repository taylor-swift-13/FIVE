#!/usr/bin/env python3
"""Cold-check immutable copies of the actual PID proof dependency closure.

Default: six relation goals and the two model aliases.  --cbmc adds the
model recheck proof once it exists.  --publish writes fresh, hash-bound
reference receipts; normal replay leaves the published receipts untouched.
An open --run lets the Ultra proof author retain its real phase accounting.
"""
from pathlib import Path
import argparse, hashlib, importlib.util, json, re, shlex, shutil, sys
from datetime import datetime, timezone

ATTEMPT = Path(__file__).resolve().parent
ROOT = ATTEMPT.parents[4]
sys.path.insert(0, str(ROOT / 'scripts'))
from five_telemetry import Run
from example_proof_gate import certificate_source, input_index

def digest(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()

def dump(path, value):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(value, ensure_ascii=False, indent=2) + '\n')

def relative(path):
    return str(Path(path).resolve().relative_to(ROOT))

def config():
    p = ATTEMPT / 'core/BuildConfiguration.py'
    spec = importlib.util.spec_from_file_location('pid_build_configuration', p)
    obj = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(obj)
    pairs = list(obj.LOADPATHS)
    case = 'paparazzi/models/guidance_pid_h_run_pos/rocq'
    for name, prefix in [('no_error', 'PidPositionRunPosNoError'),
                         ('termination', 'PidPositionRunPosTermination'),
                         ('cbmc_recheck', 'PidPositionRunPosCBMC')]:
        pairs += [(f'{case}/{name}/problem', prefix + 'Problem'),
                  (f'{case}/{name}/attempts/002', prefix + 'Attempt002')]
    return pairs

def module(path, pairs):
    options = [(len(str(ROOT / d)), d, prefix) for d, prefix in pairs
               if Path(path).is_relative_to(ROOT / d)]
    if not options:
        raise ValueError('No explicit namespace for ' + str(path))
    _, directory, prefix = max(options)
    return prefix + '.' + '.'.join(Path(path).relative_to(ROOT / directory).with_suffix('').parts)

def problems(with_cbmc):
    aliases = ['position_translation', 'no_error', 'all_successor_termination',
               'input_nonvacuity', 'nonzero_nonvacuity', 'relational_frame']
    status = json.loads((ATTEMPT.parent.parent / 'problem/status.json').read_text())
    rel = {'attempt': ATTEMPT, 'problem': ATTEMPT.parent.parent / 'problem',
           'imports': ['PidPositionTranslationProblem.Spec', 'PidPositionTranslationAttempt002.Proof'],
           'bindings': [{'requested_goal': goal,
                         'theorem': 'PidPositionTranslationAttempt002.Proof.' + alias,
                         'type': 'PidPositionTranslationProblem.Spec.' + goal}
                        for goal, alias in zip(status['requested_goals'], aliases)]}
    assert len(rel['bindings']) == 6
    result = [rel]
    case = ROOT / 'paparazzi/models/guidance_pid_h_run_pos/rocq'
    kinds = [('no_error', 'PidPositionRunPosNoError'),
             ('termination', 'PidPositionRunPosTermination')]
    if with_cbmc:
        kinds.append(('cbmc_recheck', 'PidPositionRunPosCBMC'))
    for name, prefix in kinds:
        base = case / name
        proof = base / 'attempts/002/Proof.v'
        if not proof.is_file():
            raise FileNotFoundError(proof)
        goals = json.loads((base / 'problem/status.json').read_text())['requested_goals']
        explicit = proof.parent / 'evidence/expected-bindings.json'
        if explicit.is_file():
            declared = json.loads(explicit.read_text())
            if [b['requested_goal'] for b in declared['bindings']] != goals:
                raise ValueError('Explicit bindings differ from canonical requested goals')
            result.append({'attempt': proof.parent, 'problem': base / 'problem',
                           'imports': declared['imports'], 'bindings': declared['bindings']})
            continue
        declarations = re.findall(r'(?:Theorem|Lemma)\s+([A-Za-z_][A-Za-z_0-9]*)\s*:\s*'
                                  + re.escape(prefix + 'Problem.Spec.RequestedGoal'), proof.read_text())
        if len(goals) != 1 or len(declarations) != 1:
            raise ValueError('Model alias requires one exact RequestedGoal theorem: ' + str(proof))
        result.append({'attempt': proof.parent, 'problem': base / 'problem',
                       'imports': [prefix + 'Problem.Spec', prefix + 'Attempt002.Proof'],
                       'bindings': [{'requested_goal': goals[0],
                                     'theorem': prefix + 'Attempt002.Proof.' + declarations[0],
                                     'type': prefix + 'Problem.Spec.RequestedGoal'}]})
    return result

def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--run', type=Path, help='existing open, metered proof-author run')
    parser.add_argument('--publish', action='store_true')
    parser.add_argument('--cbmc', action='store_true')
    parser.add_argument('--plan', action='store_true', help='dependency plan only; no proof acceptance')
    parser.add_argument('--timeout', type=int, default=360)
    args = parser.parse_args()
    pairs = config()
    flags = [x for d, n in pairs for x in ['-Q', d, n]]
    groups = problems(args.cbmc)
    owned = args.run is None
    if args.run:
        run = Run(args.run.resolve())
        if run.read('run.json')['status'] != 'running':
            raise ValueError('Cannot append to a closed historical run')
    else:
        run = Run.start(ROOT / '_build/pid-ultra-cold-checks', 'five-rocq', [],
                        {'scope': 'tool-only cold reproduction, no new mathematical authoring',
                         'requested_proof_model': 'gpt-6.1-sol', 'requested_proof_effort': 'ultra'},
                        invocation_kind='tool-only')
    final = {}
    try:
        if not args.publish and not args.plan:
            for group in groups:
                if (group['attempt'] / 'provenance.json').is_file():
                    _, indexed_sources = input_index(ROOT, group['attempt'])
                    for source, expected in indexed_sources.items():
                        if digest(source) != expected:
                            raise ValueError('Published proof input changed: ' + str(source))
        excluded = {'runs', 'inputs', 'checked', 'exploratory', '__pycache__', 'cold-checks'}
        files = set()
        for directory, _ in pairs:
            base = ROOT / directory
            if base.is_dir():
                for source in base.rglob('*.v'):
                    if set(source.relative_to(base).parts) & excluded:
                        continue
                    if not re.fullmatch('[A-Za-z_][A-Za-z_0-9]*', source.stem):
                        continue
                    files.add(source.resolve())
        roots = [g['attempt'] / 'Proof.v' for g in groups]
        dep = run.command(['rocq', 'dep', *flags, *[relative(p) for p in sorted(files)]],
                          'cold-proof-dependency-graph', timeout=120, cwd=ROOT)
        graph = {}
        text = (run.folder / dep['stdout']).read_text().replace('\\\n', '')
        for line in text.splitlines():
            if ':' not in line:
                continue
            lhs, rhs = line.split(':', 1)
            targets = shlex.split(lhs)
            if not targets or not targets[0].endswith('.vo'):
                continue
            src = (ROOT / targets[0]).with_suffix('.v').resolve()
            graph[src] = [(ROOT / item).with_suffix('.v').resolve()
                          for item in shlex.split(rhs) if item.endswith('.vo')
                          and (ROOT / item).with_suffix('.v').is_file()]
        order, visiting, done = [], set(), set()
        def visit(source):
            source = source.resolve()
            if source in done:
                return
            if source in visiting:
                raise ValueError('Cyclic source dependency ' + str(source))
            if not source.is_relative_to(ROOT) or '/attempts/001/' in str(source):
                raise ValueError('Forbidden compilation target ' + str(source))
            if source not in graph:
                raise ValueError('Missing local dependency declaration ' + str(source))
            visiting.add(source)
            for child in graph[source]:
                visit(child)
            visiting.remove(source)
            done.add(source)
            order.append(source)
        for source in roots:
            visit(source)
        if args.plan:
            print(json.dumps({'scope': 'dependency plan only, no new validation claim',
                              'sources': [relative(p) for p in order]}, indent=2))
            if owned:
                note = run.folder / 'evidence/dependency-plan.json'
                dump(note, {'sources': [relative(p) for p in order]})
                run.finish('passed', 'Dependency plan only.', {'plan': note})
            return
        stamp = datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%S%f')
        base = (ATTEMPT / 'evidence/cold-checks' if args.publish else ROOT / '_build/pid-ultra-cold-replays') / stamp
        checked = base / 'checked'
        current = {source: digest(source) for source in order}
        snapshots = {}
        for source, expected in current.items():
            target = checked / relative(source)
            target.parent.mkdir(parents=True, exist_ok=True)
            shutil.copyfile(source, target)
            assert digest(target) == expected
            snapshots[source] = target
            run.capture(target, 'cold-dependency-' + stamp + '-' + hashlib.sha256(relative(source).encode()).hexdigest()[:18], area='inputs')
        cold_flags = [x for directory, prefix in pairs
                      for x in ['-Q', relative(checked / directory), prefix]]
        for source in order:
            target = snapshots[source]
            run.command(['rocq', 'compile', '-q', *cold_flags, relative(target)],
                        'cold-compile-' + source.stem, timeout=args.timeout, cwd=ROOT)
        theorem_names = [b['theorem'] for g in groups for b in g['bindings']]
        kernel_modules = list(dict.fromkeys(name.rsplit('.', 1)[0] for name in theorem_names))
        kernel = run.command(['rocq', 'check', '-silent', *cold_flags, *kernel_modules],
                             'cold-independent-proof-kernel', timeout=args.timeout, cwd=ROOT)
        hashes = {relative(snapshots[s]): h for s, h in current.items()}
        proof_receipt = base / 'proof-kernel-evidence.json'
        dump(proof_receipt, {'kind': 'rocq-kernel-check', 'run': relative(run.folder),
                            'command_id': kernel['id'], 'theorems': theorem_names,
                            'statement_artifacts': [relative(snapshots[p.resolve()]) for p in roots],
                            'dependency_sha256': hashes})
        for group in groups:
            target = checked / relative(group['attempt']) / 'CurrentGoalBinding.v'
            target.parent.mkdir(parents=True, exist_ok=True)
            target.write_text(certificate_source(group['imports'], group['bindings']))
            run.capture(target, 'cold-certificate-' + hashlib.sha256(relative(target).encode()).hexdigest()[:18], area='inputs')
            compile_cmd = run.command(['rocq', 'compile', '-q', *cold_flags, relative(target)],
                                      'cold-exact-goalbinding', timeout=args.timeout, cwd=ROOT)
            cert_module = module(group['attempt'] / 'CurrentGoalBinding.v', pairs)
            cert_kernel = run.command(['rocq', 'check', '-silent', *cold_flags, cert_module],
                                      'cold-exact-goalbinding-kernel', timeout=args.timeout, cwd=ROOT)
            cert_receipt = target.parent / 'certificate-kernel-evidence.json'
            dump(cert_receipt, {'kind': 'rocq-kernel-check', 'run': relative(run.folder),
                               'command_id': cert_kernel['id'],
                               'theorems': [cert_module + '.goal_' + str(i) for i in range(len(group['bindings']))],
                               'statement_artifacts': [relative(target)],
                               'dependency_sha256': {**hashes, relative(target): digest(target)}})
            if args.publish:
                manifest = ROOT / 'paparazzi/models/guidance_pid_h_run_pos/align/model/compcert-manifest.json'
                semantic = json.loads(manifest.read_text())['semantic_dependencies']
                indexed = {relative(p): h for p, h in current.items()}
                for p in [Path(__file__).resolve(), manifest,
                          ATTEMPT / 'core/BuildConfiguration.py',
                          group['attempt'] / 'check.py',
                          ROOT / 'paparazzi/models/guidance_pid_h_run_pos/prepare/source/guidance_pid_h_run_pos.c',
                          ROOT / 'paparazzi/models/guidance_pid_h_run_pos/prepare/source/bindings.json']:
                    indexed[relative(p)] = digest(p)
                index = group['attempt'] / 'provenance.json'
                if (group['attempt'] / 'inputs.json').exists():
                    raise ValueError('Do not create competing input indexes')
                dump(index, {'schema': 'five-proof-inputs/1', 'dependency_sha256': indexed,
                             'semantic_dependencies': semantic})
                rows = [{'path': name, 'sha256': value,
                         **({'snapshot': relative(snapshots[ROOT / name])} if ROOT / name in snapshots else {})}
                        for name, value in sorted(indexed.items())]
                validation = group['attempt'] / 'evidence/goal-validation.json'
                dump(validation, {'schema': 'five-proof-validation/1',
                                  'index': {'path': relative(index), 'sha256': digest(index)},
                                  'inputs': rows, 'kernel_evidence': relative(proof_receipt),
                                  'goal_bindings': group['bindings'],
                                  'certificate': {'path': relative(target), 'sha256': digest(target),
                                                  'module': cert_module, 'imports': group['imports'],
                                                  'run': relative(run.folder),
                                                  'compile_command_id': compile_cmd['id'],
                                                  'kernel_command_id': cert_kernel['id'],
                                                  'kernel_evidence': relative(cert_receipt)}})
                status_path = group['problem'] / 'status.json'
                status = json.loads(status_path.read_text())
                status.update({'status': 'proved', 'active_attempt': '../attempts/002',
                               'goal_status': {b['requested_goal']: 'proved' for b in group['bindings']}})
                dump(status_path, status)
                final['validation-' + str(len(final))] = validation
        for source, expected in current.items():
            if digest(source) != expected:
                raise ValueError('Source changed during cold build: ' + str(source))
        print(json.dumps({'status': 'passed', 'source_count': len(order),
                          'goals': theorem_names, 'run': relative(run.folder),
                          'kernel_evidence': relative(proof_receipt)}, indent=2))
        if owned:
            run.finish('passed', 'Cold source snapshots, exact typed goals and independent kernel passed.',
                       {**final, 'kernel': proof_receipt})
    except BaseException:
        if owned and run.read('run.json')['status'] == 'running':
            note = run.folder / 'evidence/checker-failure.json'
            dump(note, {'scope': 'cold checker did not complete; failure retained in command logs'})
            run.finish('failed', 'Cold checker failed; no completion claim.', {'failure': note})
        raise

if __name__ == '__main__':
    main()
