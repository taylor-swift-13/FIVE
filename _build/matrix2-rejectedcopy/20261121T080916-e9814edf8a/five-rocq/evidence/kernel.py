import pathlib,sys,shlex,shutil,json
root=pathlib.Path("/home/yangfp/five");sys.path.insert(0,str(root/"scripts"))
from five_telemetry import Run
r=Run(root/"_build/matrix2-rejectedcopy/20261121T080916-e9814edf8a/five-rocq")
build=root/"_build/matrix-inv2-csem/development/current"
source=root/"paparazzi/models/float_mat_inv_2d/rocq/support/RejectedCopyComposition.v"
shutil.copyfile(source,r.folder/"evidence/RejectedCopyComposition.v")
session=pathlib.Path("/mnt/c/Users/50635/.codex/sessions/2026/11/21/rollout-2026-11-21T16-07-48-01a1fd25-b0dd-7bd3-bd3e-064b5956fd61.jsonl")
contexts=[]
for line in session.read_text().splitlines():
 event=json.loads(line)
 if event.get("type")=="turn_context":
  p=event.get("payload",{})
  contexts.append({k:p.get(k) for k in ["model","effort","reasoning_effort","turn_id"] if k in p})
(r.folder/"evidence/runtime-model.json").write_text(json.dumps({"session":str(session),"contexts":contexts},indent=2))
flags=[]
for d in sorted(build.iterdir()):
 if d.is_dir():flags.extend(["-Q",str(d),d.name])
c=r.command(["bash","-lc","source scripts/env.sh && rocq check "+shlex.join(flags+["FiveInv2Case.RejectedCopyComposition"])],"kernel-rejected-composition",600,cwd=root)
print((r.folder/c["stdout"]).read_text()[-1500:])
print((r.folder/c["stderr"]).read_text()[-1500:])
print("Runtime contexts:",contexts)
