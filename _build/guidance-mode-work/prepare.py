from pathlib import Path
import json,hashlib,shutil
R=Path.cwd(); U=R/"_build/paparazzi/upstream"; OUT=R/"paparazzi/models"
def h(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def sl(path,a,b):return "\n".join((U/path).read_text().splitlines()[a-1:b])
C="sw/airborne/firmwares/rotorcraft/guidance/guidance_h_ref.c"
H="sw/airborne/firmwares/rotorcraft/guidance/guidance_h_ref.h"
A="sw/airborne/math/pprz_algebra.h"
common=[("sw/airborne/math/pprz_algebra_float.h",49,52),("sw/airborne/math/pprz_algebra_int.h",192,195),(H,50,52),(H,58,97),(A,68,72),(A,74,78),(A,92,96),(A,98,102),(A,118,118),("sw/airborne/math/pprz_algebra_int.h",205,205),(C,30,32),(C,49,49),(C,203,214)]
for entry,start,end in [("gh_update_ref_from_speed_sp",143,168),("gh_update_ref_from_accel_sp",170,188)]:
 d=OUT/entry; src=d/"prepare/source"; src.mkdir(parents=True,exist_ok=True)
 slices=common[:-1]+[(C,start,end),common[-1]]
 text="/* Pinned unchanged Paparazzi slices; explicit fixed sqrt binding below. */\n#include <stdint.h>\n/* Fixed executable binding: binary64 sqrt, then binary32 cast. */\n#define sqrtf(x) ((float)__builtin_sqrt((double)(x)))\n\n"+"\n\n".join(sl(*x) for x in slices)+"\n"
 (src/(entry+".c")).write_text(text)
 rows=[dict(upstream_path=p,start_line=a,end_line=b,source_sha256=h(U/p),slice_sha256=hashlib.sha256(sl(p,a,b).encode()).hexdigest()) for p,a,b in slices]
 (d/"prepare/extraction.json").write_text(json.dumps(dict(upstream_commit="abfee3dd56eeab12c528635504a429db3daf409a",method="Exact unchanged textual slices plus explicit executable sqrtf binding macro",slices=rows),indent=2)+"\n")
 for p,_,_ in slices:
  dest=d/"prepare/original"/p;dest.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(U/p,dest)
 shutil.copyfile(U/"COPYING",d/"prepare/COPYING")
 target=json.loads((OUT/"gh_set_omega/align/request.json").read_text())["target"]
 bindings=dict(entry=entry,signature="void (struct FloatVect2)",target=target,upstream_commit="abfee3dd56eeab12c528635504a429db3daf409a",prepared_source={"path":entry+".c","sha256":h(src/(entry+".c"))},external_calls=[dict(original="sqrtf",actual="(float)__builtin_sqrt((double)x)",scope="CompCert builtin binary64 square root followed by cast to binary32; native libm equivalence not claimed")],compilation_options=["-fstruct-passing"],limitations=["Scope uses explicitly fixed sqrtf binding; original system libm correspondence is not proved."])
 (src/"bindings.json").write_text(json.dumps(bindings,indent=2)+"\n")
 print(entry,h(src/(entry+".c")))
