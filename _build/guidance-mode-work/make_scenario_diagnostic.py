from pathlib import Path
import json,hashlib
R=Path.cwd();out=R/"_build/guidance-mode-work/scenario-probe"
controls={"accel.x":"2.0f","accel.y":"0.0f","speed.x":"1.0f","speed.y":"0.0f","inv_tau":"2.0f","dt":"0x1p-9f"}
for kind in ["speed","accel"]:
 e="gh_update_ref_from_"+kind+"_sp";original=R/"paparazzi/models"/e/"cbmc/harness.c";prepared=R/"paparazzi/models"/e/"prepare/source"/(e+".c")
 lines=original.read_text().splitlines();head=lines[:next(i for i,x in enumerate(lines)if "struct FloatVect2 input=" in x)]
 head[0]="#include \""+str(prepared)+"\"";head.insert(5,"extern int nondet_int(void);")
 for i,line in enumerate(head):
  if "=nondet_float();" in line and "gh_ref."in line:
   fld=line.strip().split("=")[0].split("gh_ref.")[1]
   if fld in controls:head[i]=" gh_ref."+fld+"="+controls[fld]+";"
 body=[]
 for branch,command in [(True,"1.0f"if kind=="speed"else"-0.0078125f"),(False,"6.0f"if kind=="speed"else"9.9921875f")]:
  suffix="unsaturated"if branch else"saturated"
  body.append(" if(nondet_int()!=0){"if branch else" }else{")
  cy="0.0f"if kind=="speed"else"-0.0f"
  body.append(" struct FloatVect2 input={"+command+","+cy+"};")
  tail=lines[next(i for i,x in enumerate(lines)if "float scaled_x="in x):-1]
  for line in tail:
   if line.strip()==e+"(input);":line=" "+e+"((struct FloatVect2){"+command+","+cy+"});"
   if "__CPROVER_assert"in line:line=line.replace("\");"," ["+suffix+"]\");")
   body.append(line)
 body.extend([" }","}"])
 d=out/e;d.mkdir(parents=True,exist_ok=True);h=d/"harness.c";h.write_text("\n".join(head+body)+"\n")
 sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
 (d/"scope.json").write_text(json.dumps(dict(status="separate diagnostic; active harness/source untouched",domain="Two nonzero control scenarios and arbitrary full64bit positions subject original safe sums; six unused parameter float fields arbitrary bits including NaNs; one unsaturated and one saturated branch",controls=controls,commands=[{"x":command,"y":cy}for command in (["1.0f","6.0f"]if kind=="speed"else["-0.0078125f","9.9921875f"])],preserved="All7 original logical postconditions in each branch (14 actual assertion IDs), every automatic guard, all original cast/sum assumptions, complete original C bodies/fixed software binding",rocq_domain="Unchanged wide natural integration safety domain",original={"path":str(original.relative_to(R)),"sha256":sha(original)},prepared={"path":str(prepared.relative_to(R)),"sha256":sha(prepared)},diagnostic={"path":str(h.relative_to(R)),"sha256":sha(h)}),indent=2)+"\n")
 print(h)
