"""Read only token events from explicitly selected local Codex sessions."""
import argparse
import hashlib
import json
from pathlib import Path

KEYS=['input_tokens','output_tokens','cached_input_tokens','reasoning_output_tokens']


def load(path):
    path=Path(path).resolve()
    identity=None
    events=[]
    previous={k:0 for k in KEYS}
    notes=[]
    for line_number,line in enumerate(path.read_text(encoding='utf-8').splitlines(),1):
        try:
            record=json.loads(line)
        except json.JSONDecodeError:
            # A live JSONL writer may not have flushed the last line yet.
            notes.append(f'Unparsed line {line_number}; live-tail completeness not guaranteed')
            continue
        payload=record.get('payload',{})
        # Forked logs include an inherited parent header after their own header.
        # The first header owns the file; later historical headers cannot
        # change the actor associated with this log's usage counters.
        if record.get('type')=='session_meta' and identity is None:
            identity={'thread_id':payload.get('id'),'source':payload.get('source'),'started_at':payload.get('timestamp')}
        if record.get('type')!='event_msg' or payload.get('type')!='token_count':
            continue
        totals=(payload.get('info') or {}).get('total_token_usage')
        if not totals:
            continue
        if identity is None or not identity.get('thread_id'):
            raise ValueError('Token event without identified session')
        current={k:totals.get(k) for k in KEYS}
        if any(type(current[k]) is not int for k in KEYS):
            notes.append(f'Incomplete counters at line {line_number}')
            continue
        delta={k:current[k]-previous[k] for k in KEYS}
        if any(v<0 for v in delta.values()):
            raise ValueError(f'Counter reset/decrease at line {line_number}; do not guess attribution')
        previous=current
        if not any(delta.values()):
            continue
        if delta['cached_input_tokens']>delta['input_tokens'] or delta['reasoning_output_tokens']>delta['output_tokens']:
            raise ValueError('Subset counters are inconsistent')
        event_key=hashlib.sha256(json.dumps(current,sort_keys=True).encode()).hexdigest()[:24]
        events.append({'event_id':f"{identity['thread_id']}:{event_key}",'timestamp':record.get('timestamp'),
                       'source_line':line_number,**delta})
    if identity is None:
        raise ValueError('Session metadata missing')
    return identity,events,previous,notes


def snapshot(path):
    identity,events,totals,notes=load(path)
    return {'thread_id':identity['thread_id'],'session_file':str(Path(path).resolve()),
            'last_event_id':events[-1]['event_id'] if events else None,
            'last_event_timestamp':events[-1]['timestamp'] if events else None,
            'observed_event_count':len(events),'counters':totals,'notes':notes}


def receipt(path,after=None,before=None):
    identity,events,_,notes=load(path)
    start,end=0,len(events)
    for boundary,is_start in [(after,True),(before,False)]:
        if boundary is None:
            continue
        if boundary['thread_id']!=identity['thread_id']:
            raise ValueError('Boundary belongs to another thread')
        marker=boundary['last_event_id']
        if marker is None:
            index=0
        else:
            found=[i+1 for i,event in enumerate(events) if event['event_id']==marker]
            if len(found)!=1:
                raise ValueError('Boundary event is missing or ambiguous')
            index=found[0]
        if is_start:
            start=index
        else:
            end=index
    if start>end:
        raise ValueError('Reversed boundaries')
    selected=events[start:end]
    return {'source':{'kind':'codex-session-event','reference':str(Path(path).resolve()),'thread_id':identity['thread_id']},
            'complete':not notes,'scope':'explicit event-boundary interval' if after is not None and before is not None else 'whole session as observed; not a per-skill total',
            'boundaries':{'after_event_id':after['last_event_id'],'before_event_id':before['last_event_id']} if after is not None and before is not None else None,
            'events':selected,'notes':notes,
            'totals':{k:sum(event[k] for event in selected) for k in KEYS},
            'total_tokens':sum(event['input_tokens']+event['output_tokens'] for event in selected)}


def related_sessions(directory,root_thread):
    selected=[]
    metadata=[]
    # Only inspect session identity/source headers for discovery. Never export
    # conversation messages, tool content, or model reasoning.
    for path in Path(directory).rglob('*.jsonl'):
        try:
            with path.open(encoding='utf-8') as stream:
                first=json.loads(stream.readline())
            payload=first.get('payload',{})
            source=payload.get('source')
            spawn=source.get('subagent',{}).get('thread_spawn',{}) if isinstance(source,dict) else {}
            metadata.append((path,payload.get('id'),spawn.get('parent_thread_id'),spawn.get('agent_path')))
        except (OSError,json.JSONDecodeError,AttributeError):
            continue
    ids={root_thread}
    while True:
        expanded=ids | {ident for _,ident,parent,_ in metadata if parent in ids}
        if expanded==ids:
            break
        ids=expanded
    for path,ident,parent,actor in metadata:
        if ident in ids:
            selected.append({'file':str(path),'thread_id':ident,'parent':parent,'actor':actor or '/root'})
    if not any(s['thread_id']==root_thread for s in selected):
        raise ValueError('Root session not found')
    return selected


def write(path,value):
    path=Path(path)
    path.parent.mkdir(parents=True,exist_ok=True)
    path.write_text(json.dumps(value,ensure_ascii=False,indent=2)+'\n')


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    sub=parser.add_subparsers(dest='mode',required=True)
    for mode in ['snapshot','receipt']:
        p=sub.add_parser(mode)
        p.add_argument('--session',required=True)
        p.add_argument('--output',required=True)
        if mode=='receipt':
            p.add_argument('--after')
            p.add_argument('--before')
    p=sub.add_parser('sessions')
    p.add_argument('--directory',required=True)
    p.add_argument('--thread-id',required=True)
    p.add_argument('--output',required=True)
    args=parser.parse_args()
    if args.mode=='snapshot':
        write(args.output,snapshot(args.session))
    elif args.mode=='receipt':
        read=lambda name:json.loads(Path(name).read_text()) if name else None
        write(args.output,receipt(args.session,read(args.after),read(args.before)))
    else:
        output=Path(args.output)
        rows=[]
        for item in related_sessions(args.directory,args.thread_id):
            usage=receipt(item['file'])
            evidence=output.parent/(item['thread_id']+'.usage.json')
            write(evidence,usage)
            rows.append({**item,'source':usage['source'],'scope':usage['scope'],'complete':usage['complete'],
                         **usage['totals'],'total_tokens':usage['total_tokens'],'event_count':len(usage['events']),
                         'observed_until':usage['events'][-1]['timestamp'] if usage['events'] else None,
                         'receipt':str(evidence)})
        write(output,{'sessions':rows,'attribution':'Child agent sessions belong to their tasks. Historical root-session usage has no reliable per-skill partition; leave it unattributed.'})
        for row in rows:
            print(json.dumps({k:row[k] for k in ['actor','input_tokens','cached_input_tokens','output_tokens','total_tokens','observed_until']},ensure_ascii=False))


if __name__=='__main__':
    main()
