#!/usr/bin/env python3
"""Check multiple Rocq modules and retain minimal proof/resource evidence."""
import argparse
import json
from pathlib import Path
import re
import shutil
import sys
from five_telemetry import Run


def main():
    parser=argparse.ArgumentParser()
    parser.add_argument('--namespace',default='FIVEProof')
    parser.add_argument('files',nargs='+',type=Path)
    args=parser.parse_args()
    root=Path(__file__).resolve().parents[1]
    sources=[p.resolve() for p in args.files]
    record=Run.start(root/'runs','five-rocq',[(f'rocq-input-{i}',p) for i,p in enumerate(sources)],
        {'namespace':args.namespace,'domain':'The supplied Rocq definitions and theorem quantifiers',
         'inputs':'One or many Rocq modules; no C/CBMC prerequisite',
         'remaining_obligations':['Kernel checking is relative to imported assumptions; inspect the assumptions audit.']})
    failure=None
    roles={}
    try:
        if not re.fullmatch(r'[A-Za-z][A-Za-z0-9_]*(\.[A-Za-z][A-Za-z0-9_]*)*',args.namespace):
            raise ValueError('Invalid logical namespace')
        if any(not p.is_file() or p.suffix!='.v' for p in sources) or len({p.name for p in sources})!=len(sources):
            raise ValueError('Require existing .v inputs with unique basenames')
        build=root/'_build/pure-rocq'/args.namespace
        build.mkdir(parents=True,exist_ok=True)
        if any(p.parent==build.resolve() for p in sources):
            raise ValueError('Inputs must be outside the generated build directory')
        for p in build.iterdir():
            if p.is_file() and p.suffix in {'.vo','.vos','.vok','.glob','.v'}:
                p.unlink()
        record.command(['rocq','--version'],'rocq-version',cwd=root)
        theorem_index=[]
        for p in sources:
            shutil.copyfile(p,build/p.name)
            text=p.read_text()
            for match in re.finditer(r'^\s*(?:Theorem|Lemma|Corollary|Proposition|Fact|Remark|Example)\s+(\w+)',text,re.M):
                theorem_index.append({'name':match[1],'source':p.name,'line':text[:match.start()].count('\n')+1})
            record.command(['rocq','compile','-Q',str(build),args.namespace,str(build/p.name)],p.stem+'-compile',cwd=root)
            roles[p.stem+'-proof-source']=build/p.name
            roles[p.stem+'-proof-object']=build/(p.stem+'.vo')
        record.command(['rocq','check','-silent','-Q',str(build),args.namespace,*[f'{args.namespace}.{p.stem}' for p in sources]],'kernel-check',cwd=root)
        index=build/'theorems.json'
        index.write_text(json.dumps({'theorems':theorem_index,'source_statements':'See input snapshots at the indexed lines',
            'assumptions':'Print Assumptions results are retained in compile logs; absence of an audit is not evidence of no axioms'},indent=2)+'\n')
        roles['theorem-index']=index
    except Exception as exc:
        failure=str(exc)
    record.finish('failed' if failure else 'passed',failure or f'Pure Rocq compile and independent check passed for {len(sources)} input modules',roles)
    if failure:
        raise RuntimeError(failure)
    print('Pure Rocq modules checked: '+str(record.folder))


if __name__=='__main__':
    try:
        main()
    except Exception as exc:
        print('FAIL: '+str(exc),file=sys.stderr)
        sys.exit(1)
