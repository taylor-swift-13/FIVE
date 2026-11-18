
from pathlib import Path
import json,re,hashlib
names=["init_first_order_low_pass","reset_first_order_low_pass","update_first_order_low_pass_tau"]
for name in names:
 p=Path("paparazzi/models")/name/"prepare"
 src=(p/"source"/(name+".c")).read_text()
 f=p/"source/bindings.json";d=json.loads(f.read_text())
 d["original_signature"]=d["signature"]
 d["signature"]=src[src.index(name):src.index(chr(10)+"{")].split(name,1)[1]
 d["signature"]=("float " if name=="reset_first_order_low_pass" else "void ")+name+d["signature"]
 d["source_correspondence"]="Original struct and function body are exact upstream textual slices. Only static inline declaration qualifiers are removed to retain the selected standalone entry in CompCert; no wrapper, body rewrite or numerical input restriction. Selected-function extraction, not a whole-firmware linking equivalence theorem."
 assert d["prepared_source"]["sha256"]==hashlib.sha256(src.encode()).hexdigest()
 f.write_text(json.dumps(d,indent=2)+chr(10))
 f=p/"extraction.json";d=json.loads(f.read_text());d["method"]="Exact upstream struct and original function body extracted by recorded line slices; unrelated includes and declarations removed; only static inline linkage/inline qualifiers removed so CompCert retains the standalone entry. No callees or external bindings."
 f.write_text(json.dumps(d,indent=2)+chr(10))
 out=p/"report";out.mkdir(exist_ok=True)
 text=chr(10).join(["# Prepare "+name,"","Preparation is complete. Entry "+name+" is defined in source/"+name+".c; the sole dependency is the original FirstOrderLowPass struct. No callees, required includes, globals or external bindings. The prepared source is shared by CBMC and CompCert.","","Source: Paparazzi commit abfee3dd56eeab12c528635504a429db3daf409a, sw/airborne/filters/low_pass_filter.h. Original header and license are retained; extraction.json gives exact upstream line ranges and hashes. Independent textual comparison confirms the struct and entire function body are unchanged.","","Extraction removes only static inline: CompCert drops an unreferenced standalone static-inline entry, including a tested used attribute variant. The selected external entry retains the original parameter types, qualifiers, body and expression order. Original and prepared signatures are distinguished in source/bindings.json. Failed exports remain in align costs/logs; a syntax check does not establish whole-program extraction equivalence.","","Target: CompCert 3.17 Csem/Cexec, x86-64 Linux standard ABI, little endian, IEEE binary32, nearest ties to even; exact target/NaN policy is hash-bound by align. No input-domain precondition is imposed on the execution model. Proof-specific writable-memory assumptions belong to Rocq problem specifications.","","The shared three-case prepare batch includes initial extraction, qualifier normalization and measured metadata/handoff finalization. costs.json retains each actual run including failures, without dividing shared model-token usage into invented per-case values. Time, token and tool-memory are separate; RSS excludes model-serving memory.",""])
 (out/"report.md").write_text(text)
 print(name+": metadata/source consistency passed")
