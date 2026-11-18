
import json,hashlib,subprocess
from pathlib import Path
names=["init_first_order_low_pass","reset_first_order_low_pass","update_first_order_low_pass_tau"]
up=Path("_build/paparazzi/upstream/sw/airborne/filters/low_pass_filter.h")
lines=up.read_text().splitlines()
rows=[]
for n in names:
 p=Path("paparazzi/models")/n/"prepare"
 s=p/"source"/(n+".c");src=s.read_text();b=json.loads((p/"source/bindings.json").read_text());ex=json.loads((p/"extraction.json").read_text())
 assert b["entry"]==n and b["signature"] in src and b["original_signature"].startswith("static inline ")
 assert b["prepared_source"]["sha256"]==hashlib.sha256(s.read_bytes()).hexdigest()
 assert not b["external_calls"] and not b["dependencies"]
 assert b["target"]["model"]=="64" and b["target"]["endianness"]=="little"
 assert ex["source_sha256"]==hashlib.sha256(up.read_bytes()).hexdigest()
 for i,sl in enumerate(ex["slices"]):
  text=chr(10).join(lines[sl["start_line"]-1:sl["end_line"]])
  assert hashlib.sha256(text.encode()).hexdigest()==sl["sha256"]
  assert (text if i==0 else text.replace("static inline ","",1)) in src
 subprocess.run(["gcc","-std=c11","-Wall","-Wextra","-fsyntax-only",str(s)],check=True)
 rows.append({"case":n,"entry":b["entry"],"body_exact":True,"signatures_distinguished":True,"source_hash":b["prepared_source"]["sha256"],"syntax":"passed","external_calls":[]})
print(json.dumps({"verdict":"passed","checks":rows},indent=2))
