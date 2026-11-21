import json,collections
from pathlib import Path
base=Path("paparazzi/models/stateGetSpeedEcef_f")
p=json.loads((base/"cbmc/properties.json").read_text())["properties"]
print("BY_FUNCTION_CLASS")
for k,v in sorted(collections.Counter((x["source_location"].get("function"),x["source_location"].get("propertyClass"))for x in p).items()):print(k,v)
print("GROUPED_SOURCES")
groups=collections.defaultdict(list)
for i,x in enumerate(p):
 loc=x["source_location"];groups[(loc.get("file"),loc.get("function"),loc.get("line"),loc.get("propertyClass"))].append(x)
for group,props in groups.items():
 print(json.dumps({"source":group,"count":len(props),"properties":[{"id":x["id"],"status":x["status"],"description":x["description"]}for x in props]},ensure_ascii=False))
print("MEMCPY")
print(Path("runs/20261119T183203-57f7b29b98/five-verify/evidence/cbmc-embedded-memcpy.c").read_text())
print("SOURCE")
print((base/"prepare/source/stateGetSpeedEcef_f.c").read_text())
