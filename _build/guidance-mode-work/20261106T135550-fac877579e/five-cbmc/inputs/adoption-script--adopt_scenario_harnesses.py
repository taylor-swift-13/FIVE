from pathlib import Path
import json,hashlib,shutil
R=Path.cwd();sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
for e in ["gh_update_ref_from_speed_sp","gh_update_ref_from_accel_sp"]:
 c=R/"paparazzi/models"/e;cb=c/"cbmc";hist=cb/"history/full-symbolic-001"
 if hist.exists():raise RuntimeError("Historical full-domain harness already preserved")
 hist.mkdir(parents=True)
 shutil.copyfile(cb/"harness.c",hist/"harness.c")
 if(cb/"report/scope.json").exists():shutil.copyfile(cb/"report/scope.json",hist/"scope.json")
 (hist/"report.md").write_text("# Historical broad-control CBMC harness\n\nPreserved unchanged. Full and sliced symbolic control runs timed out without a complete property ledger. These are not counterexamples and not successful verification. The last buffered JSON message does not establish which solver phase consumed all time. Raw attempts and costs remain referenced in the aggregate report.\n")
 probe=R/"_build/guidance-mode-work/scenario-probe"/e
 text=(probe/"harness.c").read_text();rows=text.splitlines();rows[0]="#include \"../prepare/source/"+e+".c\"";(cb/"harness.c").write_text("\n".join(rows)+"\n")
 scope=json.loads((probe/"scope.json").read_text());scope["status"]="canonical harness prepared; direct canonical CBMC replay pending"
 scope["verification_method"]="traditional-bounded-model-checking";scope["observation"]="Exact source-ordered integration/saturation scalar bits and named frame; little endian x86-64; seven logical properties in each of two branches"
 scope["implementation"]={"path":"../prepare/source/"+e+".c","sha256":sha(c/"prepare/source"/(e+".c")),"binding_sha256":sha(c/"prepare/source/five_sqrtf.c")}
 scope["harness"]={"path":"harness.c","sha256":sha(cb/"harness.c")};scope["historical_harness"]={"path":"history/full-symbolic-001/harness.c","sha256":sha(hist/"harness.c")};scope["loops"]="none";scope["recursion"]="none";scope["unwind"]=1
 (cb/"report/scope.json").write_text(json.dumps(scope,indent=2)+"\n")
 (cb/"report/report.md").write_text("# CBMC: two nonzero control scenarios\n\nCanonical harness is ready for direct replay. Matching diagnostic runs reported 122/122 SUCCESS per entry, including all fourteen assertion occurrences (the original seven properties in each branch) and all 108 automatic guards. This report does not yet claim a gate-ready canonical receipt.\n\nControls are v=(1,0), a=(2,0), dt=1/512 and inv_tau=2. Speed commands (1,+0) and (6,+0) produce unsaturated and saturated raw acceleration; accel commands (-0.0078125,-0) and (9.9921875,-0) match those raw bits. Position inputs remain arbitrary signed64 patterns subject the original safe-add guards; six unused float configuration fields remain arbitrary bit patterns, including NaNs. Every original postcondition and automatic guard is retained.\n\nThis is scenario-scoped BMC, not arbitrary-control BMC. The broad-control experiments are retained as timeouts. The execution models remain unrestricted, and full natural-domain Rocq safety, functional correctness and relation proofs remain mandatory. Source and the fixed integer-restoring binding are unchanged.\n")
 print(e,sha(cb/"harness.c"))
