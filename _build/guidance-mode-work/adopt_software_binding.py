from pathlib import Path
import json,hashlib,shutil
R=Path.cwd(); hist=R/"paparazzi/report/guidance_mode/evidence/builtin-attempt-001"
helper=R/"paparazzi/report/guidance_mode/evidence/software-sqrt-binding/five_sqrtf.c"
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
for e in ["gh_update_ref_from_speed_sp","gh_update_ref_from_accel_sp"]:
 c=R/"paparazzi/models"/e;dest=hist/e
 if dest.exists():raise RuntimeError("Immutable historical snapshot exists")
 shutil.copytree(c/"prepare",dest/"prepare")
 shutil.copytree(c/"cbmc",dest/"cbmc")
 shutil.copytree(c/"align",dest/"align",ignore=shutil.ignore_patterns("*.vo","*.glob","*.ml","*.mli","*.aux"))
 source=c/"prepare/source"/(e+".c")
 s=source.read_text().replace("/* Fixed executable binding: binary64 sqrt, then binary32 cast. */", "/* Fixed executable binding: common loop-free software binary32 sqrt. */").replace("#define sqrtf(x) ((float)__builtin_sqrt((double)(x)))", "#include \"five_sqrtf.c\"\n#define sqrtf(x) five_sqrtf(x)")
 source.write_text(s);shutil.copyfile(helper,source.parent/"five_sqrtf.c")
 bpath=source.parent/"bindings.json";b=json.loads(bpath.read_text());b["prepared_source"]["sha256"]=sha(source)
 b["external_calls"]=[dict(original="sqrtf",actual="five_sqrtf",kind="explicit fixed internal C implementation",source="five_sqrtf.c",sha256=sha(helper),scope="Exact execution of the included common integer-binary-search software C algorithm; native libm/IEEE accuracy transfer not claimed without a separate proof.")]
 b["dependencies"]=[dict(path="five_sqrtf.c",sha256=sha(helper),origin=str(helper.relative_to(R)))]
 b["limitations"]=["Native system libm equivalence and software IEEE accuracy theorem outside requested fixed-binding execution relation."]
 bpath.write_text(json.dumps(b,indent=2)+"\n")
 ep=c/"prepare/extraction.json";ex=json.loads(ep.read_text());ex["method"]="Exact unchanged upstream entry/type/macro/callee slices plus explicit common software sqrt binding";ex["added_binding"]=b["dependencies"][0];ep.write_text(json.dumps(ex,indent=2)+"\n")
 req=c/"prepare/verification-request.json";q=json.loads(req.read_text());q["binding"]="Common same-input source/source closure: internal five_sqrtf algorithm; no external sqrt callback or tool-specific macro divergence.";req.write_text(json.dumps(q,indent=2)+"\n")
 (c/"prepare/report/report.md").write_text("# Preparation: "+e+"\n\nExact pinned original entry/callee/types/macros retain the full64byte GuidanceHRef. This revision explicitly binds sqrtf to the included common loop-free C five_sqrtf implementation. Both CBMC and CompCert consume this identical prepared source and dependency, with no tool-dependent macro. The prior __builtin_sqrt attempt is preserved in the scoped history and failed because CBMC6.11.0 has no body for that callee. Software accuracy/native libm equivalence is not asserted as proved; the verification target is exact execution of this fixed C binding.\n")
 rows=[]
 for f in dest.rglob("*"):
  if f.is_file():rows.append(dict(path=str(f.relative_to(hist)),sha256=sha(f)))
 (dest/"snapshot.json").write_text(json.dumps(dict(schema="five-historical-input-snapshot/1",reason="CompCert-supported builtin binding unsupported by CBMC; retain failed attempts and old generated inputs",files=rows),indent=2)+"\n")
 print(e,sha(source),sha(helper))
