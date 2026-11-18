from pathlib import Path
import sys,json
root=Path(__file__).resolve().parents[4];sys.path.insert(0,str(root/'scripts'))
from five_telemetry import Run
r=Run(root/'_build/lowpass-readback/20261107T030051-ab4ee8aef9/five-rocq')
maps=json.loads((Path(__file__).with_name('dev-mappings.json')).read_text());flags=[]
for ns,d in maps.items():flags+=['-Q',d,ns]
for p in sys.argv[1:]:
 r.command(['/home/yangfp/.opam/five/bin/rocq','compile',*flags,str(root/p)],'dev-'+Path(p).stem,timeout=600,cwd=str(root))
