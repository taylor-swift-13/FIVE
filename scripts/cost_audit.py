"""Check recorded FIVE cost evidence without estimating missing usage."""
import json
import math
from datetime import datetime
from pathlib import Path


def read(path):
    return json.loads(Path(path).read_text())


def number(value):
    return type(value) in (int, float) and math.isfinite(value) and value >= 0


def audit_run(folder, seen=None):
    folder = Path(folder).resolve()
    seen = set() if seen is None else set(seen)
    issues = []
    if folder in seen:
        return {'status': 'incomplete', 'run': str(folder), 'issues': ['Run dependency cycle']}
    seen.add(folder)
    try:
        run, metrics = read(folder / 'run.json'), read(folder / 'metrics.json')
        def need(condition, message):
            if not condition:
                issues.append(message)

        need(run['status'] != 'running' and 'finish_epoch' in run, 'Stage has not finished')
        need(metrics['run_id'] == run['run_id'] and metrics['skill'] == run['skill'], 'Mismatched metrics identity')
        need(run.get('invocation_kind') == 'skill-session', 'Tool replay is not a measured model-authoring stage')
        boundary = run.get('codex_usage_boundary', {})
        own = run['tokens']
        need(own.get('status') == 'available' and own.get('complete') is True, 'Actual stage token receipt unavailable/incomplete')
        need(own.get('source', {}).get('kind') in {'codex-session-event', 'provider-usage'}, 'Unidentified token source')
        need(bool(own.get('source', {}).get('reference')), 'Token source has no receipt reference')

        def events(receipt):
            result = {}
            for event in receipt.get('events', []):
                ident = event.get('event_id')
                need(bool(ident) and ident not in result, 'Duplicate/missing usage event ID')
                for key in ['input_tokens', 'output_tokens']:
                    need(type(event.get(key)) is int and event[key] >= 0, 'Invalid ' + key)
                for key, total in [('cached_input_tokens', 'input_tokens'), ('reasoning_output_tokens', 'output_tokens')]:
                    value = event.get(key)
                    need(value is None or (type(value) is int and 0 <= value <= event[total]), 'Invalid subset ' + key)
                result[ident] = event
            return result

        own_events = events(own)
        if own.get('source', {}).get('kind') == 'codex-session-event':
            need(bool(boundary.get('before')) and bool(boundary.get('after')), 'Missing model-work token boundaries')
            if boundary.get('before') and boundary.get('after'):
                for key in ['input_tokens', 'output_tokens', 'cached_input_tokens', 'reasoning_output_tokens']:
                    start = boundary['before']['counters'].get(key)
                    end = boundary['after']['counters'].get(key)
                    if start is not None and end is not None:
                        need(end - start == sum(e.get(key) or 0 for e in own_events.values()), 'Token boundary delta mismatch: ' + key)
            need(bool(own_events) or (own.get('scope') == 'explicit event-boundary interval' and own.get('total_tokens') == 0),
                 'Zero tokens lack an explicitly measured empty interval')
        # The captured usage receipt must agree with the metadata being counted.
        receipts = list((folder / 'evidence').glob('model-usage-receipt--*'))
        need(len(receipts) == 1, 'Missing/ambiguous captured usage receipt')
        if len(receipts) == 1:
            receipt = read(receipts[0])
            need(receipt.get('events') == own.get('events') and receipt.get('source') == own.get('source'),
                 'Captured usage receipt differs from run metadata')

        union, descendant_ids = dict(own_events), set()
        child_cpu, child_peaks, child_process_peaks = [], [], []
        children = []
        for path in run.get('children', []):
            child_path = Path(path)
            if not child_path.is_absolute():
                child_path = folder / child_path
            child_audit = audit_run(child_path, seen)
            need(child_audit['status'] == 'complete', 'Incomplete child costs: ' + str(child_path))
            child, cm = read(child_path / 'run.json'), read(child_path / 'metrics.json')
            children.append(child)
            for ident, event in events(cm['tokens']).items():
                need(ident not in union or union[ident] == event, 'Conflicting usage event: ' + str(ident))
                union[ident] = event
                descendant_ids.add(ident)
            child_cpu.append(cm['time']['cpu_tool_seconds'])
            child_peaks.append(cm['memory']['peak_process_tree_rss_sampled_bytes'])
            child_process_peaks.append(cm['memory']['max_individual_process_rss_bytes'])

        mt = metrics['tokens']
        need(mt.get('status') == 'available', 'Aggregated token metrics incomplete')
        need(events(mt) == union, 'Token aggregation is not the unique event union')
        for key in ['input_tokens', 'output_tokens']:
            need(mt.get(key) == sum(e[key] for e in union.values()), 'Incorrect aggregate ' + key)
        for key in ['cached_input_tokens', 'reasoning_output_tokens']:
            expected = sum(e[key] for e in union.values()) if all(e.get(key) is not None for e in union.values()) else None
            need(mt.get(key) == expected, 'Incorrect aggregate subset ' + key)
        need(mt.get('total_tokens') == mt.get('input_tokens', 0) + mt.get('output_tokens', 0), 'Incorrect token total')

        commands = run['commands']
        need(metrics['command_count'] == len(commands), 'Command accounting mismatch')
        cpu, peaks, process_peaks = [], [], []
        for command in commands:
            usage = command.get('gnu_time')
            need(bool(usage), 'Missing CPU/RSS receipt: ' + command['id'])
            if usage:
                need(all(number(usage.get(k)) for k in ['user_seconds', 'system_seconds', 'max_process_rss_kib']), 'Invalid GNU time values')
                cpu.append(usage['user_seconds'] + usage['system_seconds'])
                process_peaks.append(usage['max_process_rss_kib'] * 1024)
                raw = []
                for line in (folder / command['time_log']).read_text().splitlines():
                    try:
                        raw.append(json.loads(line))
                    except json.JSONDecodeError:
                        pass
                need(bool(raw) and raw[-1] == usage, 'GNU time receipt mismatch: ' + command['id'])
            peak = command.get('peak_process_tree_rss_sampled_bytes')
            need(number(peak) and peak > 0 and command.get('rss_sample_count', 0) > 0, 'Missing sampled tool memory: ' + command['id'])
            need(not command.get('rss_sampling_errors'), 'RSS sampling errors: ' + command['id'])
            peaks.append(peak)
            for child in children:
                start = datetime.fromisoformat(command['started_at']).timestamp()
                end = datetime.fromisoformat(command['finished_at']).timestamp()
                need(not (start < child['finish_epoch'] and child['start_epoch'] < end),
                     'Parent command overlaps measured child; CPU/RSS may be counted twice')

        timing, memory = metrics['time'], metrics['memory']
        need(all(number(c.get('wall_seconds')) for c in commands) and
             math.isclose(timing.get('own_tool_wall_seconds', -1), sum(c['wall_seconds'] for c in commands), abs_tol=1e-6),
             'Mismatched recorded tool wall time')
        need(number(timing.get('wall_seconds')), 'Missing stage wall time')
        if 'finish_epoch' in run:
            need(math.isclose(timing['wall_seconds'], run['finish_epoch'] - run['start_epoch'], abs_tol=1e-6), 'Wall time is not the actual stage interval')
        amounts = cpu + child_cpu
        need(all(number(x) for x in amounts) and number(timing.get('cpu_tool_seconds')) and
             math.isclose(timing['cpu_tool_seconds'], sum(x for x in amounts if number(x)), abs_tol=1e-6), 'Missing/mismatched tool CPU total')
        need(not memory.get('parallel_children'), 'Combined peak unavailable for concurrent children')
        parallel = any(a['start_epoch'] < b['finish_epoch'] and b['start_epoch'] < a['finish_epoch']
                       for i, a in enumerate(children) for b in children[i + 1:])
        need(not parallel, 'Child intervals overlap; sequential peak aggregation is invalid')
        for field, values in [('peak_process_tree_rss_sampled_bytes', peaks + child_peaks),
                              ('max_individual_process_rss_bytes', process_peaks + child_process_peaks)]:
            need(bool(values) and all(number(x) for x in values) and
                 memory.get(field) == max((x for x in values if number(x)), default=None), 'Missing/mismatched ' + field)
        need(memory.get('tree_sampling_complete') is True and bool(memory.get('limitations')) and bool(memory.get('scope')), 'Memory scope/sampling limits incomplete')
        need(metrics.get('measurement_status') == 'complete', 'Measurements are marked partial')
        own_only = [event for ident, event in own_events.items() if ident not in descendant_ids]
        return {'status': 'complete' if not issues else 'incomplete', 'run': str(folder),
                'skill': run['skill'], 'issues': issues,
                'own_model_tokens_excluding_children': sum(e['input_tokens'] + e['output_tokens'] for e in own_only),
                'inclusive_unique_model_tokens': mt.get('total_tokens'),
                'memory_note': 'Observed tool-process RSS only; 10ms sampling may miss peaks and count shared pages twice. Excludes model-server/desktop memory.'}
    except (KeyError, TypeError, ValueError, OSError) as error:
        return {'status': 'incomplete', 'run': str(folder), 'issues': issues + ['Missing/invalid cost evidence: ' + str(error)]}
