import json,hashlib
from pathlib import Path
paths=['paparazzi/models/trig_plain/pprz_itrig_sin/cbmc/properties.json', 'paparazzi/models/trig_compressed_12/pprz_itrig_sin/cbmc/properties.json', 'paparazzi/models/trig_compressed_12/pprz_trig_int_init/cbmc/properties.json']
rows=[]
for p in map(Path,paths):
 case=str(p.parent.parent)
 props=json.loads(p.read_text())
 print(case,len(props))
 for prop in props:
  loc=prop.get('sourceLocation',{})
  rows.append({'case':case,'property_id':prop['property'],'qualified_property_id':case+'::'+prop['property'],'description':prop['description'],'source_location':loc,'cbmc_status':prop.get('status'),'rocq_status':'pending','required_bridge':'Source-PC observation plus typed-load/range/index guard proof; original Csem no-error alone is insufficient.'})
  print(prop['property']+' | '+prop['description'])
out=Path('paparazzi/relations/trig_plain_compressed_12/cbmc_support/property-inventory.json')
out.parent.mkdir(parents=True,exist_ok=True)
out.write_text(json.dumps({'schema':'five.cbmc-source-guard-inventory.v1','status':'pending','property_count':len(rows),'properties':rows},indent=2)+'\n')
