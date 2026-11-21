import json,pathlib,hashlib,sys
root=pathlib.Path("/home/yangfp/five")
run=root/"runs/20261120T180820-0c884251e0/five-rocq"
session=pathlib.Path("/mnt/c/Users/50635/.codex/sessions/2026/11/21/rollout-2026-11-21T02-07-33-01a1fa24-6de7-7b10-b77f-cf03fdad4074.jsonl")
receipt=[]
for line in session.open():
 try: e=json.loads(line)
 except Exception: continue
 if e.get("type")=="turn_context":
  p=e.get("payload",{})
  receipt.append({k:p.get(k) for k in ["model","effort","reasoning_effort","cwd","turn_id"] if k in p})
(run/"evidence/runtime.json").write_text(json.dumps({"session":str(session),"runtime":receipt},indent=2))
paths=["paparazzi/relations/lowpass_roundoff_bound/support/Numerical.v","paparazzi/relations/lowpass_roundoff_bound/support/FloatBounds.v","/home/yangfp/.opam/five/lib/coq/user-contrib/compcert/lib/Floats.v","/home/yangfp/.opam/five/lib/coq/user-contrib/Flocq/Prop/Relative.v","/home/yangfp/.opam/five/lib/coq/user-contrib/Flocq/IEEE754/Binary.v"]
hashes={p:hashlib.sha256((root/p).read_bytes()).hexdigest() for p in paths}
(run/"evidence/source-hashes.json").write_text(json.dumps(hashes,indent=2))
(run/"evidence/Numerical.v").write_bytes((root/paths[0]).read_bytes())
(run/"outputs.json").write_text(json.dumps({"numerical":str(root/paths[0]),"bounds":str(root/paths[1]),"runtime":str(run/"evidence/runtime.json"),"hashes":str(run/"evidence/source-hashes.json")},indent=2))
print(json.dumps(receipt))
