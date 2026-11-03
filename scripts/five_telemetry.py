"""FIVE per-invocation evidence and resource accounting (Linux, Python stdlib)."""
import argparse
from datetime import datetime, timezone
import hashlib
import json
import os
from pathlib import Path
import platform
import re
import shutil
import signal
import subprocess
import threading
import time
import uuid

SCHEMA = 'five-run/1.0'
SECTIONS = {'environment.json':'environment','scope.json':'scope','tokens.json':'tokens',
            'commands.json':'commands','result.json':'result','completeness.json':'completeness'}


def utc():
    return datetime.now(timezone.utc).isoformat()


def dump(path, data):
    path = Path(path)
    # Store metadata once, rather than scattering the same run facts over files.
    metadata_path = path.parent/'run.json'
    key = SECTIONS.get(path.name)
    if path.name == 'manifest.json' and path.parent.name == 'inputs':
        metadata_path = path.parent.parent/'run.json'
        key = 'inputs'
    if key and metadata_path.exists():
        metadata = json.loads(metadata_path.read_text())
        metadata[key] = data
        return dump(metadata_path,metadata)
    path.parent.mkdir(parents=True, exist_ok=True)
    temporary = path.with_suffix(path.suffix+'.tmp')
    temporary.write_text(json.dumps(data, indent=2, ensure_ascii=False)+'\n')
    temporary.replace(path)


def sha(path):
    h = hashlib.sha256()
    with Path(path).open('rb') as stream:
        for block in iter(lambda: stream.read(1024*1024), b''):
            h.update(block)
    return h.hexdigest()


def tree_rss(root_pid):
    """Observed resident bytes, summed across a fresh-session command tree."""
    processes = {}
    for entry in Path('/proc').iterdir():
        if not entry.name.isdigit():
            continue
        try:
            fields = (entry/'stat').read_text().rsplit(')',1)[1].split()
            processes[int(entry.name)] = (int(fields[1]), int(fields[3]), int((entry/'statm').read_text().split()[1]))
        except (FileNotFoundError, ProcessLookupError, PermissionError, IndexError, ValueError):
            pass
    pids = {pid for pid,(_,session,_) in processes.items() if session == root_pid} | {root_pid}
    changed = True
    while changed:
        old = len(pids)
        pids.update(pid for pid,(parent,_,_) in processes.items() if parent in pids)
        changed = len(pids) != old
    return sum(processes[pid][2] for pid in pids if pid in processes)*os.sysconf('SC_PAGE_SIZE')


class Run:
    @classmethod
    def start(cls, base, skill, inputs, scope, parent=None, invocation_kind='tool-workflow', usage_session=None):
        if skill not in {'five-cbmc','five-align','five-rocq','five-verify'}:
            raise ValueError('Unknown FIVE skill')
        run_id = datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%S')+'-'+uuid.uuid4().hex[:10]
        folder = Path(base).resolve()/run_id/skill
        folder.mkdir(parents=True,exist_ok=False)
        for name in ['inputs','logs','evidence']:
            (folder/name).mkdir()
        dump(folder/'run.json', {'schema':SCHEMA,'run_id':run_id,'skill':skill,'parent':str(parent) if parent else None,
             'started_at':utc(),'start_epoch':time.time(),'invocation_kind':invocation_kind,'status':'running',
             'timing_scope':'From start to finish of this invocation; not retroactive authoring time',
             'children':[]})
        dump(folder/'environment.json', {'os':platform.platform(),'machine':platform.machine(),'python':platform.python_version(),
             'cwd':os.getcwd(),'measurement':'GNU time + /proc RSS sampling',
             'tools':{},'environment_policy':'No full environment dump; secrets excluded'})
        dump(folder/'scope.json', scope)
        dump(folder/'tokens.json', {'status':'unavailable','source':None,'events':[],
             'reason':'The invoking runtime has not supplied per-call model usage receipts. No token estimation is substituted.'})
        dump(folder/'commands.json', [])
        dump(folder/'inputs/manifest.json', [])
        run = cls(folder)
        for role,path in inputs:
            try:
                run.capture(path,role,area='inputs')
            except FileNotFoundError:
                manifest = run.read('inputs/manifest.json')
                manifest.append({'role':role,'source':str(path),'status':'missing','reason':'Input did not exist at invocation start'})
                dump(folder/'inputs/manifest.json',manifest)
        if usage_session is not None:
            from codex_usage import snapshot
            metadata=run.read('run.json')
            metadata['codex_usage_boundary']={'session_file':str(Path(usage_session).resolve()),'before':snapshot(usage_session)}
            dump(folder/'run.json',metadata)
        run.refresh_metrics()
        if parent:
            cls(parent).link_child(run)
        return run

    def __init__(self, folder):
        self.folder = Path(folder).resolve()
        if not (self.folder/'run.json').is_file():
            raise ValueError('Not a FIVE run directory')

    def read(self,name):
        key = SECTIONS.get(name,'inputs' if name == 'inputs/manifest.json' else None)
        if key:
            return json.loads((self.folder/'run.json').read_text())[key]
        return json.loads((self.folder/name).read_text())

    def capture(self, path, role, area='evidence'):
        original = Path(path).resolve()
        if not original.exists():
            raise FileNotFoundError(f'Required artifact missing: {original}')
        safe_role = re.sub(r'[^A-Za-z0-9_.-]+','-',role)
        target = self.folder/area/f'{safe_role}--{original.name}'
        if original.is_dir():
            shutil.copytree(original,target)
            files = sorted(p for p in target.rglob('*') if p.is_file())
            value = hashlib.sha256(''.join(str(p.relative_to(target))+':'+sha(p)+'\n' for p in files).encode()).hexdigest()
            return {'role':role,'source':str(original),'path':str(target.relative_to(self.folder)),
                    'sha256_tree':value,'bytes':sum(p.stat().st_size for p in files)}
        shutil.copyfile(original,target)
        record = {'role':role,'source':str(original),'path':str(target.relative_to(self.folder)),
                  'sha256':sha(target),'bytes':target.stat().st_size}
        if area == 'inputs':
            manifest = self.read('inputs/manifest.json')
            manifest.append(record)
            dump(self.folder/'inputs/manifest.json',manifest)
        return record

    def evidence(self, name, data):
        dump(self.folder/'evidence'/name,data)

    def command(self,args,label,timeout=180,cwd=None,combined_log=None):
        if not args or not all(isinstance(a,str) for a in args):
            raise ValueError('Command must be a nonempty argv string list')
        commands = self.read('commands.json')
        seq = len(commands)+1
        stem = f'{seq:03d}-'+re.sub(r'[^A-Za-z0-9_.-]+','-',label)
        stdout = self.folder/'logs'/f'{stem}.stdout.log'
        stderr = self.folder/'logs'/f'{stem}.stderr.log'
        resources = self.folder/'logs'/f'{stem}.time.log'
        binary = shutil.which(args[0])
        started_at, started = utc(), time.monotonic()
        stop = threading.Event()
        rss_samples = []
        sample_errors = []
        proc = None
        status = 'failed'
        exit_code = None
        error = None
        time_format = '{"max_process_rss_kib":%M,"user_seconds":%U,"system_seconds":%S,"elapsed_seconds":%e,"exit_code":%x}'
        try:
            with stdout.open('wb') as out, stderr.open('wb') as err:
                proc = subprocess.Popen(['/usr/bin/time','-f',time_format,'-o',str(resources),'--',*args],
                       cwd=cwd,stdout=out,stderr=err,start_new_session=True)
                def sample():
                    while not stop.is_set():
                        try:
                            rss_samples.append((time.monotonic(),tree_rss(proc.pid)))
                        except Exception as exc:
                            sample_errors.append(str(exc))
                        stop.wait(0.01)
                monitor = threading.Thread(target=sample,daemon=True)
                monitor.start()
                try:
                    exit_code = proc.wait(timeout=timeout)
                    status = 'passed' if exit_code == 0 else 'failed'
                except subprocess.TimeoutExpired:
                    status = 'timeout'
                    # The tool and its workers share this newly created session.
                    try:
                        os.killpg(proc.pid,signal.SIGTERM)
                    except ProcessLookupError:
                        pass
                    try:
                        exit_code = proc.wait(timeout=1)
                    except subprocess.TimeoutExpired:
                        try:
                            os.killpg(proc.pid,signal.SIGKILL)
                        except ProcessLookupError:
                            pass
                        exit_code = proc.wait()
                finally:
                    stop.set()
                    monitor.join(timeout=2)
        except Exception as exc:
            error = str(exc)
        wall = time.monotonic()-started
        usage = None
        if resources.exists():
            for line in reversed(resources.read_text(errors='replace').splitlines()):
                try:
                    usage = json.loads(line)
                    break
                except json.JSONDecodeError:
                    continue
        record = {'id':stem,'argv':args,'resolved_executable':binary,'cwd':str(Path(cwd or os.getcwd()).resolve()),
                  'started_at':started_at,'finished_at':utc(),'wall_seconds':wall,'timeout_seconds':timeout,
                  'status':status,'exit_code':exit_code,'error':error,'gnu_time':usage,
                  'peak_process_tree_rss_sampled_bytes':max((rss for _,rss in rss_samples),default=None),
                  'rss_sample_count':len(rss_samples),'rss_requested_interval_seconds':0.01,
                  'rss_max_observed_sample_gap_seconds':max((b[0]-a[0] for a,b in zip(rss_samples,rss_samples[1:])),default=None),
                  'rss_sampling_errors':sample_errors,'stdout':str(stdout.relative_to(self.folder)),
                  'stderr':str(stderr.relative_to(self.folder)),'time_log':str(resources.relative_to(self.folder))}
        commands.append(record)
        dump(self.folder/'commands.json',commands)
        env = self.read('environment.json')
        if binary and args[0] not in env['tools']:
            env['tools'][args[0]] = {'path':binary,'binary_sha256':sha(binary)}
            dump(self.folder/'environment.json',env)
        if combined_log:
            combined = Path(combined_log)
            combined.parent.mkdir(parents=True,exist_ok=True)
            combined.write_bytes(stdout.read_bytes()+stderr.read_bytes())
        self.refresh_metrics()
        if status != 'passed':
            message = (stderr.read_text(errors='replace')+stdout.read_text(errors='replace'))[-4000:]
            raise RuntimeError(f'{status}: {args[0]} exit={exit_code}; {error or message}; run={self.folder}')
        return record

    def link_child(self, child):
        data = self.read('run.json')
        path = str(child.folder)
        if path not in data['children']:
            data['children'].append(path)
            dump(self.folder/'run.json',data)

    def import_tokens(self, receipt):
        data = json.loads(Path(receipt).read_text())
        if data.get('source',{}).get('kind') not in {'provider-usage','codex-session-event'} or not data.get('source',{}).get('reference'):
            raise ValueError('Require an identified provider usage or Codex session-event source')
        if data.get('complete') not in [True,False] or not isinstance(data.get('events'),list):
            raise ValueError('Require usage event list and explicit complete=true/false')
        if not data['events'] and not (data['complete'] and data.get('scope')=='explicit event-boundary interval' and data.get('boundaries') and data.get('total_tokens')==0):
            raise ValueError('Zero usage requires a verified empty event-boundary interval, not missing data')
        seen = set()
        for event in data['events']:
            if not event.get('event_id') or event['event_id'] in seen:
                raise ValueError('Usage events must have unique event_id')
            seen.add(event['event_id'])
            for key in ['input_tokens','output_tokens']:
                if type(event.get(key)) is not int or event[key] < 0:
                    raise ValueError(f'Invalid {key}')
            for key,limit in [('cached_input_tokens','input_tokens'),('reasoning_output_tokens','output_tokens')]:
                value = event.get(key)
                if value is not None and (type(value) is not int or not 0 <= value <= event[limit]):
                    raise ValueError(f'Invalid {key}; it is a subset, not an extra total')
        self.capture(receipt,'model-usage-receipt')
        dump(self.folder/'tokens.json', {'status':'available' if data['complete'] else 'partial',**data})
        self.refresh_metrics()

    def refresh_metrics(self):
        meta = self.read('run.json')
        commands = self.read('commands.json')
        own = self.read('tokens.json')
        events = {}
        incomplete = []
        event_conflicts = []
        token_sources = []
        def merge_tokens(tokens, identity):
            if tokens.get('status') != 'available':
                incomplete.append(identity)
            if tokens.get('source'):
                token_sources.append(tokens['source'])
            token_sources.extend(tokens.get('sources',[]))
            for event in tokens.get('events',[]):
                ident = event['event_id']
                if ident in events and events[ident] != event:
                    event_conflicts.append(ident)
                events[ident] = event
        merge_tokens(own,meta['run_id'])
        child_metrics = []
        children = []
        for path in meta['children']:
            child = Run(path)
            cm = child.refresh_metrics()
            child_metrics.append(cm)
            children.append(child.read('run.json'))
            # Child metrics already contain a de-duplicated event union.
            merge_tokens(cm['tokens'],child.read('run.json')['run_id'])
        token_status = 'available' if not incomplete and not event_conflicts else ('partial' if events else 'unavailable')
        known_total = bool(events) or token_status=='available'
        token_metrics = {'status':token_status,'input_tokens':sum(e['input_tokens'] for e in events.values()) if known_total else None,
                        'output_tokens':sum(e['output_tokens'] for e in events.values()) if known_total else None,
                        'total_tokens':sum(e['input_tokens']+e['output_tokens'] for e in events.values()) if known_total else None,
                        'cached_input_tokens':sum(e.get('cached_input_tokens') or 0 for e in events.values()) if known_total and all(e.get('cached_input_tokens') is not None for e in events.values()) else None,
                        'reasoning_output_tokens':sum(e.get('reasoning_output_tokens') or 0 for e in events.values()) if known_total and all(e.get('reasoning_output_tokens') is not None for e in events.values()) else None,
                        'events':list(events.values()),'sources':token_sources,'unmeasured_invocations':incomplete,'conflicting_event_ids':event_conflicts,
                        'counting_rule':'total=input+output; cache/reasoning are subsets; event_id union across wrapper and children',
                        'scope':'Model invocations only. Tool log bytes and source-code size are not token usage.'}
        own_tree = max((c['peak_process_tree_rss_sampled_bytes'] or 0 for c in commands),default=None)
        missing_tree_peaks = [c['id'] for c in commands if c.get('peak_process_tree_rss_sampled_bytes') is None]
        tree_sampling_complete = not missing_tree_peaks and all(
            m['memory'].get('tree_sampling_complete',m['memory']['peak_process_tree_rss_sampled_bytes'] is not None)
            for m in child_metrics)
        own_process = max(((c.get('gnu_time') or {}).get('max_process_rss_kib',0)*1024 for c in commands),default=None)
        own_cpu = sum((c.get('gnu_time') or {}).get('user_seconds',0)+(c.get('gnu_time') or {}).get('system_seconds',0) for c in commands)
        cpu_complete = all(c.get('gnu_time') is not None for c in commands) and all(m['time']['cpu_tool_seconds'] is not None for m in child_metrics)
        parallel = any(a['start_epoch'] < b.get('finish_epoch',time.time()) and b['start_epoch'] < a.get('finish_epoch',time.time())
                       for i,a in enumerate(children) for b in children[i+1:])
        peaks = [p for p in [own_tree,*[m['memory']['peak_process_tree_rss_sampled_bytes'] for m in child_metrics]] if p is not None]
        processes = [p for p in [own_process,*[m['memory']['max_individual_process_rss_bytes'] for m in child_metrics]] if p is not None]
        metrics = {'schema':SCHEMA,'run_id':meta['run_id'],'skill':meta['skill'],
                   'time':{'wall_seconds':max(0,meta.get('finish_epoch',time.time())-meta['start_epoch']),
                           'cpu_tool_seconds':own_cpu+sum(m['time']['cpu_tool_seconds'] for m in child_metrics) if cpu_complete else None,
                           'cpu_recorded_tool_seconds':own_cpu+sum(m['time']['cpu_recorded_tool_seconds'] for m in child_metrics),
                           'own_tool_wall_seconds':sum(c['wall_seconds'] for c in commands),
                           'scope':meta['timing_scope'],'aggregation':'wrapper wall is direct elapsed time, not sum of children'},
                   'memory':{'peak_process_tree_rss_sampled_bytes':max(peaks) if peaks and not parallel and tree_sampling_complete else None,
                             'max_individual_process_rss_bytes':max(processes) if processes else None,
                             'max_child_tree_rss_sampled_bytes':max(peaks) if peaks else None,
                             'method':'10ms requested /proc process-tree RSS sampling; GNU time max RSS per command',
                             'scope':'Launched tool processes plus time launcher; excludes model-serving/desktop agent memory',
                             'limitations':'RSS sum may count shared pages more than once; sampling may miss brief peaks. GNU max RSS is an individual-process maximum, not summed concurrent memory.',
                             'aggregation':'max over sequential tools/children; overlapping child runs have no combined peak estimate',
                             'parallel_children':parallel},
                   'tokens':token_metrics,'command_count':len(commands),
                   'measurement_status':'complete' if token_status == 'available' and peaks and not parallel and cpu_complete and tree_sampling_complete else 'partial'}
        metrics['memory']['tree_sampling_complete'] = tree_sampling_complete
        metrics['memory']['commands_without_sampled_tree_peak'] = missing_tree_peaks
        dump(self.folder/'metrics.json',metrics)
        return metrics

    def finish(self, verdict, summary, required_roles, missing=None):
        if verdict not in {'passed','failed','timeout','blocked','interrupted'}:
            raise ValueError('Invalid verification verdict')
        metadata = self.read('run.json')
        boundary=metadata.get('codex_usage_boundary')
        if boundary and not boundary.get('after'):
            try:
                from codex_usage import snapshot, receipt
                import tempfile
                boundary['after']=snapshot(boundary['session_file'])
                metadata['codex_usage_boundary']=boundary
                dump(self.folder/'run.json',metadata)
                usage=receipt(boundary['session_file'],boundary['before'],boundary['after'])
                with tempfile.TemporaryDirectory(prefix='five-token-receipt-') as temporary:
                    usage_file=Path(temporary)/'usage.json'
                    dump(usage_file,usage)
                    self.import_tokens(usage_file)
                metadata=self.read('run.json')
            except Exception as usage_error:
                metadata=self.read('run.json')
                metadata['tokens']={'status':'unavailable','source':{'kind':'codex-session-event','reference':boundary['session_file']},'events':[],'reason':str(usage_error)}
                metadata['usage_capture_error']=str(usage_error)
                dump(self.folder/'run.json',metadata)
        metadata.update({'status':verdict,'finished_at':utc(),'finish_epoch':time.time()})
        dump(self.folder/'run.json',metadata)
        roles = {}
        for role, path in required_roles.items():
            try:
                roles[role] = {'status':'present',**self.capture(path,role)}
            except FileNotFoundError:
                roles[role] = {'status':'missing','reason':(missing or {}).get(role,'Not produced; inspect command failure logs')}
        dump(self.folder/'result.json', {'verdict':verdict,'summary':summary,'outputs':roles,
             'verification_scope':self.read('scope.json'),'remaining_obligations':self.read('scope.json').get('remaining_obligations',[])})
        # Child runs are linked (normally nested under stages/), never copied twice.
        metrics = self.refresh_metrics()
        required_ok = all(r['status']=='present' for r in roles.values()) and all(r.get('status')!='missing' for r in self.read('inputs/manifest.json'))
        dump(self.folder/'completeness.json', {'artifacts':'complete' if required_ok else 'incomplete',
             'measurements':metrics['measurement_status'],'missing_roles':[r for r,v in roles.items() if v['status']!='present'],
             'note':'A passed verifier result does not imply all requested measurements are available.'})
        from cost_audit import audit_run
        cost_audit = audit_run(self.folder)
        metadata = self.read('run.json')
        metadata['cost_audit'] = cost_audit
        if cost_audit['status'] != 'complete':
            metadata['completeness']['measurements'] = 'partial'
            metrics['measurement_status'] = 'partial'
            dump(self.folder/'metrics.json',metrics)
        dump(self.folder/'run.json',metadata)
        self.render()
        print(f'ARTIFACTS: {self.folder}',flush=True)

    def render(self):
        metrics = self.read('metrics.json')
        meta = self.read('run.json')
        result = meta.get('result',{'verdict':'running','summary':''})
        peak = metrics['memory']['peak_process_tree_rss_sampled_bytes']
        text = f"# {meta['skill']} / {meta['run_id']}\n\nVerification: {result['verdict']}\n\n{result['summary']}\n\n"
        text += f"Wall time: {metrics['time']['wall_seconds']:.6f} s\n\nCPU tool time: {metrics['time']['cpu_tool_seconds']} s\n\nObserved tool-tree RSS peak: {peak if peak is not None else 'unavailable'} bytes\n\nModel tokens: {metrics['tokens']['status']}; total={metrics['tokens']['total_tokens']}\n\nMeasurement completeness: {metrics['measurement_status']}\n\n"
        text += 'run.json contains scope, input/output hashes, commands, token evidence and remaining obligations. metrics.json contains resource measurements and their limits.\n'
        if meta.get('cost_audit'):
            text += '\nCost evidence audit: '+meta['cost_audit']['status']+'\n'
            for issue in meta['cost_audit'].get('issues',[]):
                text += '\n- '+issue+'\n'
        (self.folder/'report.md').write_text(text)
        inventory = []
        for path in sorted(self.folder.rglob('*')):
            if path.is_file() and path != self.folder/'run.json' and not path.name.endswith('.tmp'):
                inventory.append({'path':str(path.relative_to(self.folder)),'bytes':path.stat().st_size,'sha256':sha(path)})
        meta = self.read('run.json')
        meta['artifacts'] = inventory
        dump(self.folder/'run.json',meta)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    sub = parser.add_subparsers(dest='action',required=True)
    start = sub.add_parser('start')
    start.add_argument('--base',required=True)
    start.add_argument('--skill',required=True)
    start.add_argument('--scope',required=True)
    start.add_argument('--input',action='append',default=[])
    start.add_argument('--parent')
    start.add_argument('--session',help='Explicit current actor Codex session JSONL, to track model-token event boundaries')
    command = sub.add_parser('exec')
    command.add_argument('--run',required=True)
    command.add_argument('--label',required=True)
    command.add_argument('--timeout',type=float,default=180)
    command.add_argument('argv',nargs=argparse.REMAINDER)
    tokens = sub.add_parser('tokens')
    tokens.add_argument('--run',required=True)
    tokens.add_argument('--receipt',required=True)
    finish = sub.add_parser('finish')
    finish.add_argument('--run',required=True)
    finish.add_argument('--verdict',required=True)
    finish.add_argument('--summary',required=True)
    finish.add_argument('--outputs',required=True,help='JSON map of output role to path')
    args = parser.parse_args()
    if args.action == 'start':
        run = Run.start(args.base,args.skill,[(f'input-{i}',p) for i,p in enumerate(args.input)],json.loads(Path(args.scope).read_text()),args.parent,'skill-session',usage_session=args.session)
        print(run.folder)
    else:
        run = Run(args.run)
        if args.action == 'exec':
            argv = args.argv[1:] if args.argv[:1]==['--'] else args.argv
            run.command(argv,args.label,args.timeout)
        elif args.action == 'tokens':
            run.import_tokens(args.receipt)
            if run.read('run.json').get('result'):
                # Token updates invalidate ancestor bundles; refresh child first,
                # then refresh/finalize each parent explicitly.
                completeness = run.read('completeness.json')
                completeness['measurements'] = run.read('metrics.json')['measurement_status']
                dump(run.folder/'completeness.json',completeness)
                run.render()
        else:
            run.finish(args.verdict,args.summary,json.loads(Path(args.outputs).read_text()))


if __name__ == '__main__':
    main()
