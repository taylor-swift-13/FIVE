#!/usr/bin/env python3
"""Publish shared301 gate metadata only after all current kernel receipts pass.

Default CLI action is a read-only preflight. --write requires an open telemetry
run; --run-gates additionally invokes all three standard gates through that run.
This script never edits prepared C, generated Source.v, Execution.v or manifests.
"""
from pathlib import Path
import argparse
import copy
import hashlib
import json
import math
import re
import struct
import sys
import tempfile

ROOT = Path(__file__).resolve().parents[3]
REPORT = ROOT / 'paparazzi/report/quat_rotation_paths'
FRESH_INPUTS = '_build/quat-rotation-ultra/evidence-support/20261120T105115-4d1225361c/five-cbmc/evidence/recheck-inputs.json'
JOINT_ATTEMPT = 'paparazzi/relations/quat_rotation_paths/attempts/001'
JOINT_RECEIPT = JOINT_ATTEMPT + '/evidence/gate-kernel-evidence.json'
JOINT_SUCCESS = 'FiveQuatRotation.Proof.all_original_300_proved'
JOINT_FAILURE = 'FiveQuatRotation.Proof.actual_assertion_replayed'
CASES = (
    ('float_quat_vmult', 'FiveQuatVmult', 96),
    ('float_rmat_of_quat', 'FiveRmatOfQuat', 87),
    ('float_rmat_vmult', 'FiveRmatVmult', 99),
)
OBLIGATIONS = (
    'domain_preservation', 'floating_point_correspondence',
    'machine_integer_correspondence', 'memory_access_correspondence',
    'control_and_exhaustion_correspondence', 'normal_result_and_memory_correspondence',
    'invalid_operation_correspondence', 'whole_execution_correspondence',
)
COVERAGE = {
    'domain_preservation': 'Every original list val argument list and every CompCert memory retains the unchanged Internal entry; no proof precondition clips the model.',
    'floating_point_correspondence': 'Every reachable original Csem successor is exactly an original Cexec successor, including mixed binary64/binary32 operations and exceptional values.',
    'machine_integer_correspondence': 'Every reachable original integer, cast and pointer operation keeps the fixed target semantics through exact one-step correspondence.',
    'memory_access_correspondence': 'Original block/offset, permissions, uninitialized values, lifetimes, writes and failed accesses are preserved by every corresponding step.',
    'control_and_exhaustion_correspondence': 'Whole finite execution traces and successors coincide without a fuel bound or selected evaluation order.',
    'normal_result_and_memory_correspondence': 'Normal returns and the actual Mem.loadbytes observations coincide, including all output and caller-memory bytes.',
    'invalid_operation_correspondence': 'Original non-returning states with no Csem successor coincide with the executable error observation; failed-write prefixes remain in the same memory.',
    'whole_execution_correspondence': 'The complete original reachable execution relation, trace order and memory state are preserved without a domain restriction.',
}
# Replaced mechanically once at authoring time; never recalculated to accept drift.
FROZEN_INPUTS = {
    "paparazzi/models/float_quat_vmult/prepare/source/float_quat_vmult.c": "64c3359619e2f8de1f8c0b16ace92ab01c969fb7d408981bd68ba0fb7b8d80ff",
    "paparazzi/models/float_quat_vmult/prepare/source/quat_types.h": "b8d33304e002cef484dfd48c5e2cb0eab8e4a7ac751587950386a0cc19d9c08f",
    "paparazzi/models/float_quat_vmult/prepare/source/bindings.json": "5008c2ce102edfcd6cc97811fa3d71172ce3292f305d606e2de9da37459189a0",
    "paparazzi/models/float_quat_vmult/prepare/verification-request.json": "3f19a534aed0ba5746eedfb4cc81b00000870b10efdc8897ef10f5597855f68f",
    "paparazzi/models/float_quat_vmult/align/request.json": "cae512a533acdd3818c82a5f6462c6e449532d0f9fc64f1c2ea9c20ca19106c9",
    "paparazzi/models/float_quat_vmult/align/model/Source.v": "7f5c226c3d94819451f6ccd2a5a0bb9e17360d8c026aeccefb814b3a269d5b04",
    "paparazzi/models/float_quat_vmult/align/model/Execution.v": "0b476992b2f98598571949b9b1bfa7674b07cdd9b6b09f897d250340db539ab9",
    "paparazzi/models/float_quat_vmult/align/model/compcert-manifest.json": "fc0971aec1a912de9ec126b79e6134ced5c33c387f50f7bc3dda41535c291ab5",
    "paparazzi/models/float_rmat_of_quat/prepare/source/float_rmat_of_quat.c": "5d5e765cf53bd21025c740ed40c0ef5d7f2650b85c30fd125911826efb03e44e",
    "paparazzi/models/float_rmat_of_quat/prepare/source/quat_types.h": "b8d33304e002cef484dfd48c5e2cb0eab8e4a7ac751587950386a0cc19d9c08f",
    "paparazzi/models/float_rmat_of_quat/prepare/source/bindings.json": "6a1e6fdf04b07b8c752cf2bb0cc4a39120676db2d34163fb80b07203fc1aeb74",
    "paparazzi/models/float_rmat_of_quat/prepare/verification-request.json": "fc3bc143c703c6713d8e04b6ce24167e82d3b2c9bcb3cd8f08a5ed9ad256782a",
    "paparazzi/models/float_rmat_of_quat/align/request.json": "cae512a533acdd3818c82a5f6462c6e449532d0f9fc64f1c2ea9c20ca19106c9",
    "paparazzi/models/float_rmat_of_quat/align/model/Source.v": "98aa27469ac90ded8c1f0720ae84e04b78f038d1281796696220d61f6e56689c",
    "paparazzi/models/float_rmat_of_quat/align/model/Execution.v": "92a529f71bfdf4ea1cc35a4b5afb9871416e915184e574efdff739710b9d9b37",
    "paparazzi/models/float_rmat_of_quat/align/model/compcert-manifest.json": "4ccf93b74e0a87bb3623ad0e90a9fa6a050233fc8cd546195735470663635579",
    "paparazzi/models/float_rmat_vmult/prepare/source/float_rmat_vmult.c": "468a207dd8dd04f0da2f5425a49e3a33db4c49eaeab003be650c883772284ab7",
    "paparazzi/models/float_rmat_vmult/prepare/source/quat_types.h": "b8d33304e002cef484dfd48c5e2cb0eab8e4a7ac751587950386a0cc19d9c08f",
    "paparazzi/models/float_rmat_vmult/prepare/source/bindings.json": "cb0b59bc67ea0a02bc51c9a820bd92f57026534388da31dc2fdde583b29feb23",
    "paparazzi/models/float_rmat_vmult/prepare/verification-request.json": "dfc28ffe6913f37092e1271cf295a3aa5a4f4e56feb369d5d0fafac3f086a7ec",
    "paparazzi/models/float_rmat_vmult/align/request.json": "cae512a533acdd3818c82a5f6462c6e449532d0f9fc64f1c2ea9c20ca19106c9",
    "paparazzi/models/float_rmat_vmult/align/model/Source.v": "99bc144d58c9748f268651fe9b855ce053cc0519e0e768decf0ce202b06a0a25",
    "paparazzi/models/float_rmat_vmult/align/model/Execution.v": "ee850b847b24eb489348fc2150a2afbe6af2e779dc5ef88760a091c1c309573a",
    "paparazzi/models/float_rmat_vmult/align/model/compcert-manifest.json": "55722b25015d6cb6620552a7bcfe6de5748227439107a6f6d2da1ca07342872b",
    "paparazzi/report/quat_rotation_paths/cbmc/harness.c": "a91cc67a3f67657841ab527fa62f456219acf9f7748cf52927215d7f22d83fdb"
}


def digest(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def read(relative):
    return json.loads((ROOT / relative).read_text())


def relative(path):
    return str(Path(path).resolve().relative_to(ROOT))


def assert_hashes(hashes, label):
    if not hashes:
        raise RuntimeError('Empty frozen input map: ' + label)
    for name, expected in hashes.items():
        path = (ROOT / name).resolve()
        if not path.is_relative_to(ROOT) or not path.is_file() or digest(path) != expected:
            raise RuntimeError(label + ' changed/missing: ' + name)


def checked_attempt(attempt, required_bindings):
    """Require actual passed kernels plus exact current theorem/type certificates."""
    from compcert_gate import kernel_record
    from example_proof_gate import validate_current
    directory = ROOT / attempt
    receipt_path = attempt + '/evidence/gate-kernel-evidence.json'
    kernel_record(ROOT, receipt_path)
    gate_receipt = read(receipt_path)
    validation = read(attempt + '/evidence/goal-validation.json')
    rows = validation.get('goal_bindings', [])
    actual = {row.get('theorem'): row.get('type') for row in rows}
    for theorem, expected_type in required_bindings.items():
        if actual.get(theorem) != expected_type or theorem not in gate_receipt['theorems']:
            raise RuntimeError('Missing exact current theorem/type binding: ' + theorem)
    status_path = directory.parent.parent / 'problem/status.json'
    status = json.loads(status_path.read_text())
    validate_current(ROOT, status_path.parent, directory, status)
    return gate_receipt


def observed_bits(trace):
    wanted = ['q.qi', 'q.qx', 'q.qy', 'q.qz', 'v.x', 'v.y', 'v.z']
    out = {}
    for step in trace:
        name, value = step.get('lhs', ''), step.get('value', {})
        if (name in wanted or re.fullmatch(r'(?:ab|bb)\[[012]l?\]', name)) and value.get('width') == 32 and value.get('binary'):
            out[name] = value['binary']
    if len(out) != 13:
        raise RuntimeError('Actual trace omits one of the seven inputs or six uint32 observations')
    return out


def bit_record(binary):
    value = int(binary, 2)
    return {'binary32': binary, 'uint32': value, 'hex': f'{value:08x}',
            'little_endian_bytes': list(value.to_bytes(4, 'little'))}


def prefix_writes(trace, function, count):
    rows = []
    for index, step in enumerate(trace):
        name, value = step.get('lhs', ''), step.get('value', {})
        location = step.get('sourceLocation', {})
        if step.get('stepType') != 'assignment' or location.get('function') != function:
            continue
        if not (value.get('width') == 32 and value.get('binary')):
            continue
        if function == 'float_rmat_of_quat':
            match = re.fullmatch(r'r\.m\[([0-8])l?\]', name)
            if not match:
                continue
            offset = int(match[1]) * 4
        else:
            match = re.fullmatch(r'[ab]\.([xyz])', name)
            if not match:
                continue
            offset = 'xyz'.index(match[1]) * 4
        rows.append({'trace_step': index, 'lhs': name, 'offset': offset,
                     'source_location': location, **bit_record(value['binary'])})
    if len(rows) != count:
        raise RuntimeError('Original trace write-prefix extraction changed: ' + function)
    return rows


def preflight():
    """Read and validate everything before any publication mutation."""
    sys.path.insert(0, str(ROOT / 'scripts'))
    assert_hashes(FROZEN_INPUTS, 'Authoring-time frozen C/header/bindings/model input')
    fresh = read(FRESH_INPUTS)
    assert_hashes(fresh['cbmc_input_sha256'], 'Fresh CBMC input')
    run = read(fresh['run'] + '/run.json')
    commands = [row for row in run['commands'] if row['id'] == fresh['command_id']]
    if run.get('status') != 'passed' or len(commands) != 1:
        raise RuntimeError('Fresh source-complete CBMC acquisition is not finished')
    command = commands[0]
    if command.get('status') != 'failed' or command.get('exit_code') != 10:
        raise RuntimeError('Expected completed genuine CBMC refutation, not timeout/unknown')
    if relative(ROOT / fresh['run'] / command['stdout']) != fresh['raw_json']:
        raise RuntimeError('CBMC JSON is not the actual command stdout')
    source_receipts = {str(Path(row['source']).resolve()): row['sha256'] for row in run.get('inputs', [])}
    for name, value in fresh['cbmc_input_sha256'].items():
        if source_receipts.get(str((ROOT / name).resolve())) != value:
            raise RuntimeError('Fresh command did not capture original input: ' + name)
    validation = read(fresh['run'] + '/evidence/precommand-source-validation.json')
    comparison = read(fresh['comparison'])
    if not validation.get('verified_before_execution') or command['argv'] != validation['same_argv']:
        raise RuntimeError('Fresh command/source preflight changed')
    if not (comparison.get('same_argv') and comparison.get('same_301_property_status_pairs') and comparison.get('same_7_input_and_6_output_binary32_patterns')):
        raise RuntimeError('Fresh query differs from preserved general query/actual trace')
    raw = read(fresh['raw_json'])
    properties = [row for block in raw for row in block.get('result', [])]
    statuses = {row['property']: row['status'] for row in properties}
    if len(statuses) != len(properties) or len(statuses) != 301:
        raise RuntimeError('Original301 ledger missing or duplicated')
    if sum(value == 'SUCCESS' for value in statuses.values()) != 300 or statuses.get('main.assertion.1') != 'FAILURE' or any(value not in ('SUCCESS', 'FAILURE') for value in statuses.values()):
        raise RuntimeError('Unexpected property status set')
    trace = next(row['trace'] for row in properties if row['property'] == 'main.assertion.1')
    if trace != read(fresh['trace']):
        raise RuntimeError('Stored trace is not the actual new FAILURE trace')
    bits = observed_bits(trace)
    if bits != comparison['original_observations'] or bits != comparison['new_observations']:
        raise RuntimeError('Actual input/output bits differ from the proved original counterexample')
    for name, binary in bits.items():
        if name.startswith(('q.', 'v.')):
            value = struct.unpack('<f', int(binary, 2).to_bytes(4, 'little'))[0]
            if not math.isfinite(value) or abs(value) > (1 if name.startswith('q.') else 1024):
                raise RuntimeError('Actual counterexample is outside the original finite domain')
    joint = checked_attempt(JOINT_ATTEMPT, {
        JOINT_SUCCESS: 'FiveQuatRotation.Spec.Independent300',
        JOINT_FAILURE: 'FiveQuatRotation.Spec.ActualAssertionFalse',
    })
    structures = {}
    for entry, namespace, owned in CASES:
        case = ROOT / 'paparazzi/models' / entry
        manifest_path = case / 'align/model/compcert-manifest.json'
        manifest = json.loads(manifest_path.read_text())
        request_path = case / 'align/request.json'
        request = json.loads(request_path.read_text())
        if manifest['request']['sha256'] != digest(request_path) or manifest['target'] != request['target'] or manifest['namespace'] != namespace:
            raise RuntimeError('Frozen model/request mismatch: ' + entry)
        semantic_paths = [case / 'prepare/source' / (entry + '.c'), case / 'prepare/source/quat_types.h',
                          case / 'align/model/Source.v', case / 'align/model/Execution.v']
        semantics = {relative(path): digest(path) for path in semantic_paths}
        for path, value in semantics.items():
            if joint['dependency_sha256'].get(path) != value:
                raise RuntimeError('Joint proof gate_inputs omit exact participating source: ' + path)
        attempt = relative(case / 'rocq/execution_correspondence/attempts/001')
        required = {namespace + 'Correspondence.Proof.' + name:
                    namespace + 'Correspondence.Spec.' + name + '_goal' for name in OBLIGATIONS}
        structural = checked_attempt(attempt, required)
        for path, value in semantics.items():
            if path.endswith('/quat_types.h'):
                continue  # Header provenance is frozen, reaudited and joint-kernel-bound.
            if structural['dependency_sha256'].get(path) != value:
                raise RuntimeError('Structural proof gate_inputs omit exact participating source: ' + path)
        if sum(name.startswith(entry + '.') for name in statuses) != owned:
            raise RuntimeError('Owned source property count differs: ' + entry)
        structures[entry] = {'case': case, 'namespace': namespace, 'manifest': manifest,
                            'manifest_path': manifest_path, 'request': request, 'request_path': request_path,
                            'semantics': semantics, 'structural_attempt': attempt}
    return {'fresh': fresh, 'command': command, 'properties': properties, 'trace': trace,
            'bits': bits, 'structures': structures}


def replay_document(state, entry):
    fresh, trace, bits = state['fresh'], state['trace'], state['bits']
    case = state['structures'][entry]
    direct = prefix_writes(trace, 'float_quat_vmult', 3)
    matrix = prefix_writes(trace, 'float_rmat_of_quat', 9)
    composed = prefix_writes(trace, 'float_rmat_vmult', 3)
    copies = []
    for src, dst, prefix in [('a', 'ab', 'ab'), ('b', 'bb', 'bb')]:
        writes = []
        for i in range(3):
            key = next(name for name in bits if re.fullmatch(prefix + r'\[' + str(i) + r'l?\]', name))
            writes.append({'offset': 4 * i, 'trace_lhs': key, **bit_record(bits[key])})
        copies.append({'operation': 'memcpy', 'source': src, 'destination': dst, 'size_bytes': 12,
                       'semantics': 'CompCert extcall_memcpy_sem 12 1; actual loadbytes/storebytes and preserved outside-destination frame',
                       'writes': writes})
    return {
        'schema': 'five-cbmc-counterexample-replay/1', 'status': 'reproduced',
        'property_id': 'main.assertion.1', 'request_sha256': digest(case['request_path']),
        'backend_manifest_sha256': digest(case['manifest_path']),
        'cbmc_json_sha256': digest(ROOT / fresh['raw_json']),
        'source_actual_trace': {'path': fresh['trace'], 'sha256': digest(ROOT / fresh['trace']),
                                'comparison': fresh['comparison'], 'original_unit_witness_used': False},
        'input_state': {'representation': 'binary32 little endian; all caller objects at offset zero in distinct CompCert blocks',
                        'quaternion': {name: bit_record(bits[name]) for name in ('q.qi', 'q.qx', 'q.qy', 'q.qz')},
                        'vector': {name: bit_record(bits[name]) for name in ('v.x', 'v.y', 'v.z')},
                        'allocated_objects': {'q': 16, 'v': 12, 'a': 12, 'r': 36, 'b': 12, 'ab': 12, 'bb': 12},
                        'block_identity': 'Logical distinct blocks; no ordering between unrelated C pointers is assumed.'},
        'fault_operation': {'entry': 'main', 'source_location': next(row['sourceLocation'] for row in state['properties'] if row['property'] == 'main.assertion.1'),
                            'expression': 'ab[0]==bb[0] && ab[1]==bb[1] && ab[2]==bb[2]',
                            'Csem_observation': 'Actual Csyntax short-circuit assertion expression reduces to Vint Int.zero after the three original normal calls and two real memcpy observations.',
                            'theorem': JOINT_FAILURE, 'type': 'FiveQuatRotation.Spec.ActualAssertionFalse'},
        'memory_prefix': {'original_calls': [
            {'entry': 'float_quat_vmult', 'destination': 'a', 'written_range': [0, 12], 'trace_writes': direct},
            {'entry': 'float_rmat_of_quat', 'destination': 'r', 'written_range': [0, 36], 'trace_writes': matrix},
            {'entry': 'float_rmat_vmult', 'destination': 'b', 'written_range': [0, 12], 'trace_writes': composed}],
            'copies': copies,
            'formal_scope': 'ActualTraceWitness carries all three real Csem NormalCalls and their memory handoff, final full12 output bytes and caller frame, and the two real memcpy observations. Intermediate matrix bit listings above are preserved original CBMC trace observations; no extra standalone Rocq matrix-byte theorem is claimed.'},
        'bit_observations': {name: bit_record(binary) for name, binary in bits.items()},
        'evidence': [JOINT_RECEIPT], 'problem_preserved': 'Original general finite bounded equality query retained; the real failed assertion is refuted, not replaced by a singleton query.',
    }


def publication_plan():
    state = preflight()
    fresh, command = state['fresh'], state['command']
    writes = {}
    for entry, namespace, _ in CASES:
        item = state['structures'][entry]
        case = item['case']
        request_sha, manifest_sha = digest(item['request_path']), digest(item['manifest_path'])
        replay_path = case / 'rocq/report/evidence/actual-counterexample-replay.json'
        replay_ref = relative(replay_path)
        recheck = {'schema': 'five-cbmc-rocq-recheck/1', 'status': 'refuted',
                   'verification_method': 'traditional-bounded-model-checking',
                   'request_sha256': request_sha, 'backend_manifest_sha256': manifest_sha,
                   'cbmc_run': fresh['run'], 'cbmc_command_id': fresh['command_id'],
                   'cbmc_json': fresh['raw_json'], 'cbmc_input_sha256': fresh['cbmc_input_sha256'],
                   'shared_ledger': {'unique_source_run_properties': 301, 'aggregate_count_once': True,
                                     'decomposition': {'float_quat_vmult': 96, 'float_rmat_of_quat': 87, 'float_rmat_vmult': 99, 'memcpy': 18, 'failed_equality': 1}},
                   'properties': []}
        specmap_path = case / 'align/spec-map.json'
        old_map = json.loads(specmap_path.read_text())
        old_by_id = {row['property_id']: row for row in old_map['properties']}
        if set(old_by_id) != {row['property'] for row in state['properties']}:
            raise RuntimeError('Existing alignment map does not preserve all301 IDs: ' + entry)
        specmap = {key: value for key, value in recheck.items() if key not in ('status', 'properties')}
        specmap['schema'] = 'five-cbmc-rocq-map/1'
        specmap['properties'] = []
        for row in state['properties']:
            success = row['status'] == 'SUCCESS'
            theorem = JOINT_SUCCESS if success else JOINT_FAILURE
            goal_type = 'Independent300' if success else 'ActualAssertionFalse'
            scope = copy.deepcopy(old_by_id[row['property']]['scope'])
            scope.update({'original_property_id': row['property'], 'description': row['description'],
                          'source_location': row['sourceLocation'], 'source_harness_sha256': fresh['cbmc_input_sha256'],
                          'original_domain': 'The unchanged original harness: finite q components in [-1,1], finite v components in [-1024,1024]; valid disjoint local objects; one original call per entry; memcpy size12; no source loop/recursion.',
                          'proved_domain': 'Source96/87/99 guards use explicit typed initialized/readable/writable distinct-object preconditions with arbitrary binary32 values, stronger than the original finite input range. The shared18 are the real two-copy protocol observers under their explicit memory preconditions, established by the checked protocol witnesses.',
                          'cbmc_bounds': {'entry': 'main', 'unwind': 1, 'unwinding_assertions': True, 'source_loops': False, 'source_recursion': False},
                          'command_scope': {'run': fresh['run'], 'command_id': fresh['command_id'], 'argv': command['argv']},
                          'mapped_statement': 'FiveQuatRotation.Spec.' + goal_type,
                          'observation': 'All original source-site/runtime guards and complete output/copy bytes with actual memory frame; failure uses the actual solver trace and actual Csem short-circuit assertion false.'})
            result = {'property_id': row['property'], 'cbmc_status': row['status'],
                      'status': 'proved' if success else 'refuted', 'scope': scope,
                      'theorem': theorem, 'evidence': [JOINT_RECEIPT]}
            if not success:
                result['counterexample_replay'] = replay_ref
            recheck['properties'].append(result)
            mapped = copy.deepcopy(old_by_id[row['property']])
            mapped.update({'cbmc_status': row['status'], 'scope': scope,
                           'rocq_goal': {'module': 'FiveQuatRotation.Spec', 'symbol': goal_type,
                                         'declaration_file': '../../../relations/quat_rotation_paths/problem/Spec.v'},
                           'mapping_status': 'mapped', 'proof_status': 'proved' if success else 'refuted',
                           'theorem': theorem, 'evidence': [JOINT_RECEIPT],
                           'correspondence': 'Independent original Csem source/runtime guard proofs and original three-call memory protocol; actual FAILURE replay, no CBMC axiom or unit-input substitution.'})
            if not success:
                mapped['counterexample_replay'] = replay_ref
            specmap['properties'].append(mapped)
        structural_receipt = item['structural_attempt'] + '/evidence/gate-kernel-evidence.json'
        contract = {'purpose': 'execution-translation', 'status': 'proved',
                    'execution_backend': 'compcert-csyntax-cexec', 'request_sha256': request_sha,
                    'backend_manifest_sha256': manifest_sha, 'execution_domain': item['request']['domain'],
                    'domain_restrictions': [],
                    'execution_entry': {'module': namespace + '.Execution', 'symbol': 'entry',
                                        'source': relative(case / 'align/model/Execution.v'), 'sha256': digest(case / 'align/model/Execution.v')},
                    'source_semantics': {'id': 'CompCert Csem/Cexec', 'version': '3.17',
                                         'target': item['request']['target'], 'source_sha256': item['semantics']},
                    'obligations': [{'id': name.replace('_', '-'), 'status': 'proof-backed', 'proof_status': 'proved',
                                     'theorem': namespace + 'Correspondence.Proof.' + name,
                                     'coverage': COVERAGE[name], 'evidence': [structural_receipt]} for name in OBLIGATIONS],
                    'alignment_issues': [], 'external_library_bindings': {},
                    'external_environment': 'Reachable original entries are call-free, nonvolatile and silent. Full raw-input source invariants exclude external callbacks, inline assembly and I/O; quiet-world closure does not replace an external implementation.',
                    'trusted_boundary': 'Recorded CompCert3.17 frontend and inherited CompCert/Flocq assumptions. No GCC/native-hardware equivalence or universal cross-tool NaN-payload theorem is claimed.'}
        writes[relative(case / 'rocq/spec-recheck.json')] = recheck
        writes[relative(case / 'rocq/execution-contract.json')] = contract
        writes[relative(specmap_path)] = specmap
        writes[replay_ref] = replay_document(state, entry)
    return {'writes': writes, 'cbmc_run': fresh['run'], 'joint_receipt': JOINT_RECEIPT,
            'frozen_inputs': dict(FROZEN_INPUTS), 'case_count': 3, 'unique_property_count': 301}


def publish(record_run):
    sys.path.insert(0, str(ROOT / 'scripts'))
    from five_telemetry import Run
    plan = publication_plan()
    run = Run(record_run)
    if run.read('run.json').get('status') != 'running':
        raise RuntimeError('Publication needs an open actual verification telemetry boundary')
    for name in plan['writes']:
        path = ROOT / name
        if path.exists():
            run.capture(path, 'gate-before-' + hashlib.sha256(name.encode()).hexdigest()[:16], area='evidence')
    # Recheck the immutable inputs once more immediately before the first write.
    assert_hashes(plan['frozen_inputs'], 'Publication input')
    for name, value in plan['writes'].items():
        path = ROOT / name
        path.parent.mkdir(parents=True, exist_ok=True)
        text = json.dumps(value, indent=2) + '\n'
        with tempfile.NamedTemporaryFile('w', dir=path.parent, prefix='.' + path.name + '-', suffix='.tmp', delete=False) as handle:
            handle.write(text)
            temporary = Path(handle.name)
        temporary.replace(path)
    return {'written': list(plan['writes']), 'cbmc_run': plan['cbmc_run'], 'joint_receipt': JOINT_RECEIPT,
            'note': 'Parent owns final handoff/report/cost updates. No Source/Execution/manifest was edited.'}


def run_gates(record_run):
    """Call only after publish; all evidence readiness is checked again."""
    sys.path.insert(0, str(ROOT / 'scripts'))
    from five_telemetry import Run
    preflight()
    run = Run(record_run)
    if run.read('run.json').get('status') != 'running':
        raise RuntimeError('Gate execution needs an open actual verification telemetry boundary')
    results = []
    for entry, _, _ in CASES:
        case = ROOT / 'paparazzi/models' / entry
        request = case / 'align/request.json'
        results.append(run.command(['python3', 'scripts/compcert-verify.py', 'gate', '--request', relative(request),
                                   '--request-sha256', digest(request), '--contract', relative(case / 'rocq/execution-contract.json'),
                                   '--manifest', relative(case / 'align/model/compcert-manifest.json'),
                                   '--spec-recheck', relative(case / 'rocq/spec-recheck.json')],
                                  entry + '-full301-final-gate', timeout=600, cwd=str(ROOT)))
    return results


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--write', action='store_true')
    parser.add_argument('--run-gates', action='store_true')
    parser.add_argument('--record-run')
    args = parser.parse_args()
    sys.path.insert(0, str(ROOT / 'scripts'))
    if args.run_gates and not args.write:
        parser.error('--run-gates requires explicit --write')
    if args.write and not args.record_run:
        parser.error('--write requires --record-run OPEN_VERIFY_RUN')
    if args.write:
        result = publish(args.record_run)
        if args.run_gates:
            result['gate_command_ids'] = [row['id'] for row in run_gates(args.record_run)]
    else:
        plan = publication_plan()
        result = {'preflight': 'passed', 'planned_outputs': list(plan['writes']),
                  'unique_properties': plan['unique_property_count'], 'case_count': plan['case_count'], 'writes_performed': False}
    print(json.dumps(result, indent=2))


if __name__ == '__main__':
    main()
