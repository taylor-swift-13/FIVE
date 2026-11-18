from pathlib import Path
import json,hashlib,shutil
R=Path.cwd();hist=R/"paparazzi/report/guidance_mode/evidence/software-search-attempt-002"
helper=R/"paparazzi/report/guidance_mode/evidence/software-sqrt-binding/restoring/five_sqrtf.c"
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
for e in ["gh_update_ref_from_speed_sp","gh_update_ref_from_accel_sp"]:
 c=R/"paparazzi/models"/e;dest=hist/e
 if dest.exists():raise RuntimeError("Immutable v1 snapshot exists")
 for stage in ["prepare","cbmc","align"]:shutil.copytree(c/stage,dest/stage,ignore=shutil.ignore_patterns("*.vo","*.glob","*.ml","*.mli","*.aux"))
 source=c/"prepare/source"/(e+".c");shutil.copyfile(helper,source.parent/"five_sqrtf.c")
 bpath=source.parent/"bindings.json";b=json.loads(bpath.read_text());b["prepared_source"]["sha256"]=sha(source)
 b["external_calls"]=[dict(original="sqrtf",actual="five_sqrtf",kind="explicit fixed internal C implementation",source="five_sqrtf.c",sha256=sha(helper),scope="Exact execution of common finite integer restoring C algorithm. Native libm equivalence/IEEE accuracy transfer not claimed as proved.")]
 b["dependencies"]=[dict(path="five_sqrtf.c",sha256=sha(helper),origin=str(helper.relative_to(R)))];b["binding_revision"]="integer-restoring-v2"
 bpath.write_text(json.dumps(b,indent=2)+"\n")
 ep=c/"prepare/extraction.json";ex=json.loads(ep.read_text());ex["added_binding"]=b["dependencies"][0];ex["binding_revision"]=b["binding_revision"];ep.write_text(json.dumps(ex,indent=2)+"\n")
 req=c/"prepare/verification-request.json";q=json.loads(req.read_text());q["binding_revision"]=b["binding_revision"];q["binding_source_sha256"]=sha(helper);req.write_text(json.dumps(q,indent=2)+"\n")
 rp=c/"prepare/report/report.md";rp.write_text(rp.read_text()+"\nCurrent binding revision is integer-restoring-v2, with 23 explicit subnormal normalization blocks and 24 explicit restoring steps. The prior binary-search/double-square implementation is preserved as historical input after complete and sliced CBMC attempts timed out during SSA conversion; no property failure was claimed from those timeouts.\n")
 rows=[dict(path=str(f.relative_to(hist)),sha256=sha(f))for f in dest.rglob("*")if f.is_file()]
 (dest/"snapshot.json").write_text(json.dumps(dict(schema="five-historical-input-snapshot/1",reason="v1 full300s and sliced120s CBMC SSA timeouts; choose lower-cost same-input integer binding; retain previous inputs",files=rows),indent=2)+"\n")
 print(e,sha(source),sha(helper))
