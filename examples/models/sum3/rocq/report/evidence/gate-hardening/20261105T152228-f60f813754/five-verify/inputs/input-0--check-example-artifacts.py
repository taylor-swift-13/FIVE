#!/usr/bin/env python3
"""Validate FIVE reference artifact links/receipts, without proving propositions.

Run from any directory. Default checks retained metadata and active attempts;
--compile additionally invokes active checkers (and can take several minutes).
"""
import argparse
import hashlib
import json
from pathlib import Path
import re
import subprocess
import sys


class Validator:
    def __init__(self, root):
        self.root = Path(root).resolve()
        self.errors = []
        self.active = []

    def require(self, ok, message):
        if not ok:
            self.errors.append(message)
        return bool(ok)

    def read(self, path):
        path = Path(path)
        try:
            return json.loads(path.read_text())
        except (OSError, ValueError) as exc:
            self.errors.append(f'{path}: {exc}')
            return {}

    def file(self, path):
        return self.require(Path(path).is_file(), f'missing file: {path}')

    def bound(self, base, rows):
        for row in rows:
            path = Path(base) / row.get('path', '')
            if self.file(path):
                digest = hashlib.sha256(path.read_bytes()).hexdigest()
                self.require(digest == row.get('sha256'), f'stale hash: {path}')

    def links(self, report):
        if not self.file(report):
            return
        for ref in re.findall(r'\[[^\]]*\]\(([^)]+)\)', report.read_text()):
            if re.match(r'^[a-z]+:', ref) or ref.startswith('#'):
                continue
            dest = ref.split('#', 1)[0].strip('<>')
            if dest:
                self.require((report.parent / dest).exists(), f'broken report link: {report}: {ref}')

    def costs(self, path, proof=False):
        costs = self.read(path)
        self.require(costs.get('schema') == 'five-stage-costs/1', f'cost schema: {path}')
        rows = costs.get('records', [])
        self.require(bool(rows), f'empty cost records: {path}')
        for row in rows:
            for group, keys in [('time', ['wall_seconds', 'tool_cpu_seconds']),
                                ('token', ['input', 'output', 'total', 'cached_input', 'reasoning_output']),
                                ('memory', ['tool_peak_rss_bytes'])]:
                for key in keys:
                    self.require(key in row.get(group, {}), f'missing cost {group}.{key}: {path}')
                    value = row.get(group, {}).get(key)
                    self.require(value is None or (isinstance(value, (int, float)) and value >= 0),
                                 f'invalid cost {group}.{key}: {path}')
            token = row.get('token', {})
            if all(isinstance(token.get(k), int) for k in ('input', 'output', 'total')):
                self.require(token['total'] == token['input'] + token['output'], f'token sum: {path}')
            refs = list(row.get('evidence', []))
            case_base = path.parents[2] if path.parent.name == 'report' else None
            def reference(ref):
                # Stage evidence is case-relative in the reference handoff;
                # proof-attempt evidence is relative to its costs.json.
                if case_base and ref.split('/', 1)[0] in ('prepare', 'cbmc', 'align', 'rocq'):
                    return case_base / ref
                return path.parent / ref
            if row.get('shared_costs'):
                refs.append(row['shared_costs'])
            if proof:
                agent = row.get('agent', {})
                self.require(agent.get('model') == 'gpt-6.1-sol' and
                             agent.get('requested_reasoning_effort') == 'medium' and
                             agent.get('actual_reasoning_effort') == 'medium', f'proof runtime model/effort: {path}')
                runtime_ref = agent.get('evidence') or agent.get('runtime_evidence') or next(
                    (ref for ref in refs if Path(ref).name in ('runtime-metadata.json', 'runtime-config.json')), None)
                self.require(bool(runtime_ref), f'missing runtime receipt: {path}')
                if runtime_ref:
                    runtime = self.read(reference(runtime_ref))
                    events = runtime if isinstance(runtime, list) else runtime.get('selected_runtime_metadata')
                    if isinstance(events, list):
                        actual = next((r for r in events if r.get('type') == 'turn_context'), {})
                    else:
                        actual = runtime.get('actual', runtime)
                    self.require(actual.get('model') == 'gpt-6.1-sol' and
                                 (actual.get('effort') or actual.get('actual_reasoning_effort')) == 'medium',
                                 f'actual runtime receipt mismatch: {reference(runtime_ref)}')
            if row.get('status') == 'not_measured':
                self.require(all(value is None for group in ('time', 'token', 'memory')
                                 for value in row.get(group, {}).values()) and
                             bool(row.get('measurement_scope') or row.get('missing_reason')),
                             f'unexplained historical measurement absence: {path}')
            elif row.get('status') not in ('not_run', 'not_applicable'):
                self.require(bool(refs), f'missing cost evidence: {path}')
            for ref in refs:
                self.file(reference(ref))

    @staticmethod
    def independent(command):
        argv = command.get('argv', [])
        if not argv or command.get('exit_code') != 0:
            return False
        tool = Path(argv[0]).name
        return ((tool == 'rocq' and argv[1:2] == ['check']) or tool == 'coqchk') and not any(
            word in ('-admit', '-norec', '--help', '-help') for word in argv)

    def proof_problem(self, problem):
        problem = Path(problem)
        self.links(problem / 'report.md')
        status = self.read(problem / 'status.json')
        self.require(status.get('schema') == 'five-proof-problem/1', f'problem status schema: {problem}')
        self.require(bool(status.get('requested_goals')), f'missing requested goals: {problem}')
        self.require(status.get('specification') == 'Spec.v', f'canonical problem specification must be Spec.v: {problem}')
        self.file(problem / status.get('specification', 'Spec.v'))
        active = (problem / status.get('active_attempt', 'MISSING')).resolve()
        attempts = sorted((problem.parent / 'attempts').glob('[0-9]*'))
        self.require(active in [p.resolve() for p in attempts], f'active attempt not retained: {problem}')
        for attempt in attempts:
            self.file(attempt / 'Proof.v')
            self.file(attempt / 'check.py')
            self.links(attempt / 'report.md')
            self.costs(attempt / 'costs.json', proof=True)
        if not active.is_dir():
            return
        self.active.append(active)
        closed = status.get('status') in ('proved', 'refuted')
        report = (active / 'report.md').read_text() if (active / 'report.md').is_file() else ''
        self.require(closed or not re.search(r'\bCOMPLETE\b', report), f'false COMPLETE for open problem: {problem}')
        if closed:
            receipts = []
            for receipt in (active / 'evidence').rglob('*.json'):
                try:
                    data = json.loads(receipt.read_text())
                except (OSError, ValueError):
                    continue
                if isinstance(data, dict) and any(self.independent(c) for c in data.get('commands', [])):
                    receipts.append(receipt)
            self.require(bool(receipts), f'missing successful independent kernel receipt: {active}')
            proof = (active / 'Proof.v').read_text() if (active / 'Proof.v').is_file() else ''
            proof = re.sub(r'\(\*.*?\*\)', '', proof, flags=re.S)
            self.require(not re.search(r'\b(?:Admitted|admit|Axiom|Axioms)\b', proof), f'unproved active proof: {active}')
        # All active input indexes with repository-relative bindings are fresh.
        for name in ('inputs.json',):
            if (active / name).is_file():
                self.bound(self.root, self.read(active / name).get('inputs', []))

    def case(self, case):
        for stage in ('prepare', 'cbmc', 'align', 'rocq'):
            directory = case / stage
            self.links(directory / 'report/report.md')
            self.costs(directory / 'report/costs.json')
            handoff = self.read(directory / 'handoff.json')
            self.require(handoff.get('schema') == 'five-stage-handoff/1', f'handoff schema: {directory}')
            self.bound(case, handoff.get('outputs', []))
        manifest = self.read(case / 'align/model/compcert-manifest.json')
        self.require(manifest.get('backend') == 'compcert-csyntax-cexec', f'execution backend: {case}')
        self.require(bool(manifest.get('target')) and bool(manifest.get('semantic_dependencies')),
                     f'missing target/semantic dependencies: {case}')
        self.bound(self.root, [manifest.get('source', {}), manifest.get('tool', {})])
        self.bound(self.root, list(manifest.get('files', {}).values()))
        self.bound(self.root, [{'path': name, 'sha256': digest}
                              for name, digest in manifest.get('semantic_dependencies', {}).items()])
        for name in ('no_error', 'termination', 'cbmc_recheck'):
            self.proof_problem(case / 'rocq' / name / 'problem')
        ledger_path = case / 'rocq/spec-recheck.json'
        ledger = self.read(ledger_path)
        self.bound(case, ledger.get('bindings', []))
        # Reuse the real gate: set equality with raw CBMC IDs, scopes, theorem
        # receipts, actual command snapshots and replay requirements.
        try:
            from compcert_gate import check_spec_recheck
            original = str((case / 'prepare/source' / (case.name + '.c')).relative_to(self.root))
            execution = {str((case / 'align/model' / name).relative_to(self.root)):
                         hashlib.sha256((case / 'align/model' / name).read_bytes()).hexdigest()
                         for name in ('Source.v', 'Execution.v')}
            check_spec_recheck(self.root, str(ledger_path.relative_to(self.root)),
                               ledger.get('request_sha256'), ledger.get('backend_manifest_sha256'),
                               original, execution)
        except Exception as exc:
            self.errors.append(f'canonical CBMC recheck failed: {case}: {exc}')

    def run(self, compile_checks=False):
        self.file(self.root / 'examples/README.md')
        for name in ('sum2', 'sum3'):
            self.case(self.root / 'examples/models' / name)
        for problem in sorted((self.root / 'examples/relations').glob('*/problem')):
            self.proof_problem(problem)
        if compile_checks and not self.errors:
            for attempt in self.active:
                result = subprocess.run([sys.executable, str(attempt / 'check.py')], cwd=self.root)
                self.require(result.returncode == 0, f'active checker failed: {attempt}')
        return {'status': 'failed' if self.errors else 'passed',
                'scope': 'artifact metadata and retained receipts; proposition adequacy requires semantic review',
                'active_attempts': [str(p.relative_to(self.root)) for p in self.active],
                'compile_checkers': compile_checks, 'errors': self.errors}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--root', type=Path, default=Path(__file__).resolve().parents[1])
    parser.add_argument('--compile', action='store_true', help='rerun active checkers after metadata passes')
    args = parser.parse_args()
    result = Validator(args.root).run(args.compile)
    print(json.dumps(result, indent=2))
    return int(bool(result['errors']))


if __name__ == '__main__':
    sys.exit(main())
