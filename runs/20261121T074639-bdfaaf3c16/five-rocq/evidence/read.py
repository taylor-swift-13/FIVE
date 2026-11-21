import sys,json,hashlib
from pathlib import Path
ROOT=Path('/home/yangfp/five')
RUN=ROOT/'runs/20261121T074639-bdfaaf3c16/five-rocq'
sys.path.insert(0,str(ROOT/'scripts'))
from five_telemetry import Run

def main():
    action=sys.argv[1]
    if action!='worker':
        run=Run(RUN)
        record=run.command(['python3',__file__,'worker',*sys.argv[1:]],'review-'+action,timeout=180,cwd=ROOT)
        print((RUN/record['stdout']).read_text())
        return
    action=sys.argv[2]
    args=sys.argv[3:]
    if action=='inventory':
        for case in ('float_mat_inv_2d','float_mat_inv_3d'):
            c=ROOT/'paparazzi/models'/case
            print('\nCASE',case)
            for stage in ('prepare','cbmc','align'):
                p=c/stage/'handoff.json'
                print('\nFILE',p.relative_to(ROOT));print(p.read_text())
            for folder in ['rocq/cbmc_recheck/problem','rocq/cbmc_recheck/attempts/001','rocq/support']:
                print('\nFOLDER',folder)
                print('\n'.join(str(p.relative_to(c)) for p in (c/folder).rglob('*') if p.is_file() and (p.suffix in ['.v','.json','.md','.py'])))
    elif action=='read':
        for arg in args:
            name,_,span=arg.partition('@')
            p=ROOT/name
            print('\nFILE',name,'SHA256',hashlib.sha256(p.read_bytes()).hexdigest())
            lines=p.read_text().splitlines()
            if span:
                a,b=map(int,span.split(':'))
            else: a,b=1,len(lines)
            for i,line in enumerate(lines[a-1:b],a): print(f'{i}: {line}')
    elif action=='list':
        for arg in args:
            p=ROOT/arg
            print('\nFOLDER',arg)
            for f in p.rglob('*'):
                if f.is_file() and f.suffix in ['.v','.json','.md','.py','.c','.log']:
                    print(str(f.relative_to(ROOT)),f.stat().st_size)
    else: raise ValueError(action)
if __name__=='__main__': main()

