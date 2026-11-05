"""Disposable receipt fixtures exercise metadata binding, without forging real runs."""
import json
from pathlib import Path
import sys
import tempfile
import unittest

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from example_proof_gate import certificate_source, digest, input_index, validate_current


class CurrentProofGateTests(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.addCleanup(self.tmp.cleanup)
        self.root = Path(self.tmp.name)
        self.problem = self.root / 'case/problem'
        self.active = self.root / 'case/attempts/001'
        self.problem.mkdir(parents=True)
        self.active.mkdir(parents=True)
        self.status = {'requested_goals': ['Goal']}
        self.write('case/problem/Spec.v', 'Definition Goal := True.\n')
        self.write('case/attempts/001/Proof.v', 'Theorem target : Spec.Goal. Proof. exact I. Qed.\n')
        self.write('case/attempts/001/check.py', '# fixture checker\n')
        sources = ['case/problem/Spec.v', 'case/attempts/001/Proof.v', 'case/attempts/001/check.py']
        self.index = {'inputs': [{'path': p, 'sha256': digest(self.root / p)} for p in sources]}
        self.save('case/attempts/001/inputs.json', self.index)
        self.deps = {}
        inputs = []
        for source, snapshot in zip(sources[:2], ['checked/Spec.v', 'checked/Proof.v']):
            self.write(snapshot, (self.root / source).read_text())
            self.deps[snapshot] = digest(self.root / snapshot)
            inputs.append({'path': source, 'sha256': digest(self.root / source), 'snapshot': snapshot})
        inputs.append({'path': sources[2], 'sha256': digest(self.root / sources[2])})
        flags = ['-Q', str(self.root / 'checked'), 'Fixture']
        def command(cid, argv):
            return {'id': cid, 'argv': argv, 'cwd': str(self.root), 'status': 'passed', 'exit_code': 0}
        self.commands = [command('spec-compile', ['rocq', 'compile', *flags, str(self.root / 'checked/Spec.v')]), command('proof-compile', ['rocq', 'compile', *flags, str(self.root / 'checked/Proof.v')]), command('proof-check', ['rocq', 'check', *flags, 'Fixture.Proof'])]
        self.save('proof-run/run.json', {'status': 'passed', 'inputs': [{'source': str(self.root / p), 'sha256': h} for p, h in self.deps.items()], 'commands': self.commands})
        receipt = {'kind': 'rocq-kernel-check', 'run': 'proof-run', 'command_id': 'proof-check', 'theorems': ['Fixture.Proof.target'], 'statement_artifacts': ['checked/Proof.v'], 'dependency_sha256': self.deps}
        self.save('proof-kernel.json', receipt)
        bindings = [{'requested_goal': 'Goal', 'theorem': 'Fixture.Proof.target', 'type': 'Fixture.Spec.Goal'}]
        imports = ['Fixture.Spec', 'Fixture.Proof']
        certpath = 'checked/GoalBinding.v'
        self.write(certpath, certificate_source(imports, bindings))
        certhash = digest(self.root / certpath)
        certdeps = {**self.deps, certpath: certhash}
        certcommands = [command('cert-compile', ['rocq', 'compile', *flags, str(self.root / certpath)]), command('cert-check', ['rocq', 'check', *flags, 'Fixture.GoalBinding'])]
        certcommands[0]['stdout'] = 'compile.stdout.log'
        self.write('cert-run/compile.stdout.log', 'Closed under the global context\n')
        self.save('cert-run/run.json', {'status': 'passed', 'inputs': [{'source': str(self.root / p), 'sha256': h} for p, h in certdeps.items()], 'commands': [self.commands[0], *certcommands]})
        self.save('cert-kernel.json', {'kind': 'rocq-kernel-check', 'run': 'cert-run', 'command_id': 'cert-check', 'theorems': ['Fixture.GoalBinding.goal_0'], 'statement_artifacts': [certpath], 'dependency_sha256': certdeps})
        self.ledger = {'schema': 'five-proof-validation/1', 'index': {'path': 'case/attempts/001/inputs.json', 'sha256': digest(self.active / 'inputs.json')}, 'inputs': inputs, 'kernel_evidence': 'proof-kernel.json', 'goal_bindings': bindings, 'certificate': {'path': certpath, 'sha256': certhash, 'module': 'Fixture.GoalBinding', 'imports': imports, 'run': 'cert-run', 'compile_command_id': 'cert-compile', 'kernel_command_id': 'cert-check', 'kernel_evidence': 'cert-kernel.json'}}
        self.persist()

    def write(self, name, value):
        p = self.root / name
        p.parent.mkdir(parents=True, exist_ok=True)
        p.write_text(value)

    def save(self, name, value):
        self.write(name, json.dumps(value))

    def persist(self):
        self.save('case/attempts/001/evidence/goal-validation.json', self.ledger)

    def check(self):
        validate_current(self.root, self.problem, self.active, self.status)

    def reject(self):
        self.persist()
        with self.assertRaises((ValueError, RuntimeError, KeyError, OSError)):
            self.check()

    def test_bound_fixture_passes(self):
        self.check()

    def substitute(self, source, text):
        self.write(source, text)
        h = digest(self.root / source)
        for row in self.ledger['inputs']:
            if row['path'] == source:
                row['sha256'] = h
        for row in self.index['inputs']:
            if row['path'] == source:
                row['sha256'] = h
        self.save('case/attempts/001/inputs.json', self.index)
        self.ledger['index']['sha256'] = digest(self.active / 'inputs.json')
        # Simulates attacker refreshing outer public handoff and descriptor
        # hashes; the actual retained compiled snapshot still must match.
        self.save('handoff.json', {'outputs': [{'path': source, 'sha256': h}]})

    def test_unrelated_proof_after_descriptor_refresh_rejected(self):
        self.substitute('case/attempts/001/Proof.v', 'Theorem unrelated : True. Proof. exact I. Qed.\n')
        self.reject()

    def test_spec_substitution_after_descriptor_refresh_rejected(self):
        self.substitute('case/problem/Spec.v', 'Definition Goal := False.\n')
        self.reject()

    def test_changed_goal_rejected(self):
        self.status['requested_goals'] = ['UnrelatedGoal']
        self.reject()

    def test_same_module_nonexistent_theorem_rejected(self):
        self.ledger['goal_bindings'][0]['theorem'] = 'Fixture.Proof.nonexistent'
        self.reject()

    def test_goal_type_substitution_rejected(self):
        self.ledger['goal_bindings'][0]['type'] = 'True'
        cert = self.ledger['certificate']
        self.write(cert['path'], certificate_source(cert['imports'], self.ledger['goal_bindings']))
        cert['sha256'] = digest(self.root / cert['path'])
        receipt = json.loads((self.root / cert['kernel_evidence']).read_text())
        receipt['dependency_sha256'][cert['path']] = cert['sha256']
        self.save(cert['kernel_evidence'], receipt)
        self.save('handoff.json', {'outputs': [{'path': cert['path'], 'sha256': cert['sha256']}]})
        # Refreshing certificate/descriptor hashes cannot refresh the actual
        # successful compiler's measured input snapshot retroactively.
        self.reject()

    def test_unrelated_successful_kernel_receipt_rejected(self):
        receipt = json.loads((self.root / 'proof-kernel.json').read_text())
        receipt['theorems'] = ['Fixture.Proof.unrelated']
        self.save('unrelated-kernel.json', receipt)
        self.ledger['kernel_evidence'] = 'unrelated-kernel.json'
        self.reject()

    def test_missing_index_rejected(self):
        (self.active / 'inputs.json').unlink()
        self.reject()

    def test_malformed_index_even_with_fresh_hash_rejected(self):
        self.save('case/attempts/001/inputs.json', {'artifacts': 'malformed'})
        self.ledger['index']['sha256'] = digest(self.active / 'inputs.json')
        self.reject()

    def test_unversioned_artifacts_adapter(self):
        data = {'artifacts': [{'path': '../../problem/Spec.v', 'sha256': digest(self.problem / 'Spec.v')}]}
        self.save('case/attempts/001/inputs.json', data)
        _, rows = input_index(self.root, self.active)
        self.assertEqual(set(rows), {self.problem / 'Spec.v'})

    def test_relation_provenance_adapter(self):
        (self.active / 'inputs.json').unlink()
        self.save('case/attempts/001/provenance.json', {'schema': 'five-proof-attempt-provenance/1', 'files': self.index['inputs']})
        _, rows = input_index(self.root, self.active)
        self.assertEqual(len(rows), 3)

    def test_certificate_run_missing_dependency_rejected(self):
        run = json.loads((self.root / 'cert-run/run.json').read_text())
        run['inputs'] = run['inputs'][1:]
        self.save('cert-run/run.json', run)
        self.reject()

    def test_case_relative_provenance_adapter(self):
        active = self.root / 'case/rocq/cbmc_recheck/attempts/001'
        active.mkdir(parents=True)
        self.write('shared/Support.v', 'Definition support := True.\n')
        self.save(str((active / 'provenance.json').relative_to(self.root)), {'schema': 'five-proof-provenance/1', 'model_configuration': {'entry': 'fixture'}, 'inputs': [{'path': 'problem/Spec.v', 'sha256': digest(self.problem / 'Spec.v')}], 'shared_inputs': [{'path': 'shared/Support.v', 'sha256': digest(self.root / 'shared/Support.v')}]})
        _, rows = input_index(self.root, active)
        self.assertEqual(set(rows), {self.problem / 'Spec.v', self.root / 'shared/Support.v'})

    def test_versioned_dependency_map_adapter(self):
        self.write('library/Semantics.v', 'Definition semantic := True.\n')
        library = self.root / 'library/Semantics.v'
        self.save('case/attempts/001/inputs.json', {'schema': 'five-proof-inputs/1', 'dependency_sha256': {r['path']: r['sha256'] for r in self.index['inputs']}, 'semantic_dependencies': {str(library): digest(library)}})
        _, rows = input_index(self.root, self.active)
        self.assertEqual(len(rows), 3)
        library.write_text('Definition semantic := False.\n')
        with self.assertRaises(ValueError):
            input_index(self.root, self.active)

    def test_missing_dependency_compilation_rejected(self):
        run = json.loads((self.root / 'proof-run/run.json').read_text())
        run['commands'] = run['commands'][1:]
        self.save('proof-run/run.json', run)
        self.reject()

    def test_wrong_certificate_load_path_rejected(self):
        run = json.loads((self.root / 'cert-run/run.json').read_text())
        run['commands'][-1]['argv'][3] = str(self.root / 'unrelated')
        self.save('cert-run/run.json', run)
        self.reject()

    def test_missing_print_assumptions_output_rejected(self):
        (self.root / 'cert-run/compile.stdout.log').unlink()
        self.reject()

    def test_empty_index_rejected(self):
        self.save('case/attempts/001/inputs.json', {'inputs': []})
        self.ledger['index']['sha256'] = digest(self.active / 'inputs.json')
        self.reject()

    def test_duplicate_shadowing_namespace_rejected(self):
        run = json.loads((self.root / 'cert-run/run.json').read_text())
        run['commands'][-1]['argv'][2:2] = ['-Q', str(self.root / 'unrelated'), 'Fixture']
        self.save('cert-run/run.json', run)
        self.reject()

    def test_compile_help_success_rejected(self):
        run = json.loads((self.root / 'proof-run/run.json').read_text())
        run['commands'][1]['argv'].insert(2, '--help')
        self.save('proof-run/run.json', run)
        self.reject()

    def test_compile_output_override_rejected(self):
        run = json.loads((self.root / 'proof-run/run.json').read_text())
        run['commands'][1]['argv'][2:2] = ['-o', 'Unrelated.vo']
        self.save('proof-run/run.json', run)
        self.reject()

    def test_kernel_unchecked_flag_rejected(self):
        run = json.loads((self.root / 'cert-run/run.json').read_text())
        run['commands'][-1]['argv'].insert(2, '-admit')
        self.save('cert-run/run.json', run)
        self.reject()


if __name__ == '__main__':
    unittest.main()
