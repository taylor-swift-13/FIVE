from pathlib import Path
import json,hashlib
R=Path.cwd();out=R/"_build/guidance-mode-work/boxed-probe"
for e in ["gh_update_ref_from_speed_sp","gh_update_ref_from_accel_sp"]:
 original=R/"paparazzi/models"/e/"cbmc/harness.c";prepared=R/"paparazzi/models"/e/"prepare/source"/(e+".c")
 rows=[];guards=[]
 for line in original.read_text().splitlines():
  if line.startswith("#include \"../prepare/source/"):line="#include \""+str(prepared)+"\""
  rows.append(line)
  if "=nondet_float();" in line and "gh_ref." in line:
   fld=line.strip().split("=")[0]
   g=" __CPROVER_assume("+fld+">=-16.0f && "+fld+"<=16.0f);";rows.append(g);guards.append(g.strip())
  if "struct FloatVect2 input=" in line:
   for a in ["x","y"]:
    g=" __CPROVER_assume(input."+a+">=-16.0f && input."+a+"<=16.0f);";rows.append(g);guards.append(g.strip())
 d=out/e;d.mkdir(parents=True,exist_ok=True);p=d/"harness.c";p.write_text("\n".join(rows)+"\n")
 sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
 (d/"scope.json").write_text(json.dumps(dict(status="diagnostic only; no active harness mutation",purpose="Physical box ordinary BMC with exact same original seven assertions and prepared implementation",floating_input_assumptions=guards,position_domain="all64bit position inputs subject original nooverflow assumptions",preserved="all actual function bodies, struct ABI, fixed restoring C sqrt dependency, guards, seven exact postconditions, original cast/sum assumptions",rocq_scope="unchanged broad natural integration safety domain including nonfinite values where casts valid; physical box is only CBC experiment domain",original_harness={"path":str(original.relative_to(R)),"sha256":sha(original)},prepared={"path":str(prepared.relative_to(R)),"sha256":sha(prepared)},diagnostic={"path":str(p.relative_to(R)),"sha256":sha(p)}),indent=2)+"\n")
 print(p,len(guards))
