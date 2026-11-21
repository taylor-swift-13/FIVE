from pathlib import Path
import sys, json, hashlib
repo=Path('/home/yangfp/five')
sys.path.insert(0,str(repo/'scripts'))
from five_telemetry import Run
run=Run((repo/'_build/state-speed-ecef-provenance/root-run.txt').read_text().strip())
def extract():
    ledger=json.loads((repo/'paparazzi/models/stateSetSpeedNed_i/cbmc/properties.json').read_text())
    measured=json.loads((repo/ledger['run']/'run.json').read_text())
    executable=Path('/home/yangfp/five/.tools/cbmc/usr/bin/cbmc')
    data=executable.read_bytes()
    sha=hashlib.sha256(data).hexdigest()
    actual=measured['environment']['tools']['cbmc']
    assert actual['binary_sha256']==sha, (actual,sha)
    needle=b'memcpy src/dst overlap'
    pos=data.index(needle)
    start=data.rfind(b'\0',0,pos)+1
    end=data.index(b'\0',pos)
    source=data[start:end]
    assert b'__CPROVER_POINTER_OBJECT(dst) != __CPROVER_POINTER_OBJECT(src) ||' in source
    assert b'void *memcpy(' in source and source.rstrip().endswith(b'}')
    dest=run.folder/'evidence/cbmc-embedded-memcpy.c'
    dest.write_bytes(source)
    result={'kind':'literal embedded library source extracted from the actual CBMC executable, not a new C model or CBMC rerun',
      'cbmc_run':ledger['run'],'cbmc_command_id':ledger['command_id'],
      'executable':str(executable),'binary_sha256':sha,
      'source_path':str(dest.relative_to(repo)), 'source_sha256':hashlib.sha256(source).hexdigest(),
      'binary_byte_start':start,'binary_byte_end_exclusive':end,
      'guard': 'Distinct POINTER_OBJECT short-circuits both pointer ordering expressions; no cross-block C pointer ordering is claimed in the Rocq adapter.'}
    run.evidence('cbmc-embedded-memcpy-source.json', result)
    print(json.dumps(result,indent=2))
if __name__=='__main__':
    if '--inner' in sys.argv:
        extract()
    else:
        run.capture(Path(__file__), 'cbmc-builtin-source-inspection', area='inputs')
        cmd=run.command(['python3',str(Path(__file__)), '--inner'], 'audit-actual-embedded-CBMC-memcpy-guard',timeout=30,cwd=repo)
        print((run.folder/cmd['stdout']).read_text())
        print((run.folder/cmd['stderr']).read_text())
        raise SystemExit(cmd['exit_code'])
