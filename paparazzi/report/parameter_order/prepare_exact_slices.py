from pathlib import Path
import json,hashlib,re,subprocess
root=Path.cwd(); up=root/"_build/paparazzi/upstream"; pin="abfee3dd56eeab12c528635504a429db3daf409a"
assert subprocess.check_output(["git","-C",str(up),"rev-parse","HEAD"],text=True).strip()==pin
files={"entry":"sw/airborne/firmwares/rotorcraft/guidance/guidance_h_ref.c","struct":"sw/airborne/firmwares/rotorcraft/guidance/guidance_h_ref.h","float":"sw/airborne/math/pprz_algebra_float.h","int":"sw/airborne/math/pprz_algebra_int.h","bound":"sw/include/std.h"}
src={k:(up/v).read_text() for k,v in files.items()}
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def dump(p,o):p.parent.mkdir(parents=True,exist_ok=True);p.write_text(json.dumps(o,indent=2)+"\n")
def extract(k,pattern):
 m=re.search(pattern,src[k],re.S|re.M);assert m;return m.group()
parts=[("float",extract("float",r"^struct FloatVect2 \{.*?^};")),("int",extract("int",r"^struct Int64Vect2 \{.*?^};")),("struct",extract("struct",r"^struct GuidanceHRef \{.*?^};")),("bound",extract("bound",r"^#define Bound\(_x, _min, _max\).*?$"))]
target={"semantics":"CompCert Csem/Cexec","arch":"x86","bitsize":64,"system":"linux","endianness":"little","float32":"IEEE754 binary32","rounding":"round-to-nearest-ties-to-even","nan_policy":"CompCert x86_64 Archi and Floats pinned by generated manifest"}
for entry in ("gh_set_omega","gh_set_zeta"):
 case=root/"paparazzi/models"/entry; p=case/"prepare"; (p/"source").mkdir(parents=True,exist_ok=True);(p/"report").mkdir(exist_ok=True)
 body=extract("entry",r"^float "+entry+r"\(float \w+\)\n\{.*?^}")
 text="/* Exact pinned Paparazzi dependency/entry slices; see extraction.json. */\n#include <stdint.h>\n\n"+"\n\n".join(s for _,s in parts)+"\n\nstruct GuidanceHRef gh_ref;\n\n"+body+"\n"
 out=p/"source"/(entry+".c");out.write_text(text)
 index=[]
 for key,s in parts+[("entry",body)]:
  start=src[key].index(s); index.append({"upstream_path":files[key],"source_sha256":sha(up/files[key]),"start_line":src[key][:start].count("\n")+1,"end_line":src[key][:start+len(s)].count("\n")+1,"slice_sha256":hashlib.sha256(s.encode()).hexdigest()})
 for key,v in files.items():
  dest=p/"upstream"/v;dest.parent.mkdir(parents=True,exist_ok=True);dest.write_bytes((up/v).read_bytes())
 dump(p/"extraction.json",{"upstream_commit":pin,"method":"exact unchanged textual slices; original complete snapshots outside compilation input","slices":index,"added_scaffolding":["stdint.h target standard typedef int64_t","original tentative definition struct GuidanceHRef gh_ref;"],"excluded":"unreachable functions, includes and configuration macros not referenced by retained entry closure"})
 dump(p/"source/bindings.json",{"entry":entry,"source":"prepare/source/"+entry+".c","sha256":sha(out),"signature":"float "+entry+"(float)","upstream_commit":pin,"upstream_sources":{v:sha(up/v) for v in files.values()},"callees":[],"external_bindings":[],"global_objects":[{"name":"gh_ref","type":"complete original GuidanceHRef","initialization":"original C tentative zero initialization"}],"target":target,"dependency_closure":"original complete GuidanceHRef, FloatVect2, Int64Vect2, Bound; target int64_t","correspondence_scope":"exact entry body and dependency slices of pinned upstream; original full application build/configuration not executed"})
 dump(p/"verification-request.json",{"schema":"five-verification-request/1","authorization":"User requested complete no-error, all-successor termination, full actual CBMC recheck and cross-entry final named-state bit equality for parameter setter order","entry":entry,"implementation":"prepare/source/"+entry+".c","assumptions":[],"domain":"all binary32 parameter and initialized named state field bitpatterns including NaNs, infinities and signed zeros; valid writable global object, no concurrent writer","properties":["automatic CBMC bounds/pointer/overflow/shift checks","returned parameter bits equal actual Bound result","written coefficient bits equal source-ordered binary32 multiplication","all unrelated named fields retain initial bits"],"bounds":{"loops":"none","recursion":"none","unwind":1},"target":target,"harness":"cbmc/harness.c","memory_observation":"named scalar fields by binary32/int64 bits, little endian, padding excluded; exact write offsets and frame in Rocq"})
 (p/"report/report.md").write_text("# Preparation\n\nFrozen exact pinned entry body, Bound macro and complete original GuidanceHRef/type closure. No callee or external call. Original snapshots retained outside compilation input. Target x86-64 Linux little endian CompCert binary32; all parameter and initialized named-field bitpatterns remain in scope. No finite-only restriction. Extraction reproduces retained text mechanically; it does not establish whole-application compiler equivalence.\n")
 print(entry,sha(out))
