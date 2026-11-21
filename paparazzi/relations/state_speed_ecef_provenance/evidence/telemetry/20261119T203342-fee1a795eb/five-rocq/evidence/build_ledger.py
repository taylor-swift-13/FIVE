import json,collections,hashlib
from pathlib import Path
root=Path.cwd();run=Path(__file__).resolve().parents[1]
base=Path("paparazzi/models/stateGetSpeedEcef_f")
p=json.loads((base/"cbmc/properties.json").read_text());ps=p["properties"]
mp=json.loads((base/"align/spec-map.json").read_text())
mapped={x["property_id"]:x for x in mp["properties"]}
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
input_checks=[{"path":k,"expected":v,"actual":sha(k),"match":sha(k)==v}for k,v in mp["cbmc_input_sha256"].items()]
assert all(x["match"]for x in input_checks)
assert len(ps)==276==len(mapped) and len({x["id"]for x in ps})==276
assert all(mapped[x["id"]]["cbmc_status"]==x["status"]for x in ps)
ptrreasons=["nonnull","valid_object","not_deallocated","live_object","in_bounds","not_integer_address"]
observations={19:("ned_status",0,2),21:("ecef_status",2,2),22:("copied_ecef[0]",8,4),23:("copied_ecef[1]",12,4),24:("copied_ecef[2]",16,4),25:("stale_ned[0]",20,4),26:("stale_ned[1]",24,4),27:("stale_ned[2]",28,4),30:("pointer_is_state",32,1),32:("returned_status",4,2)}
assertions={
1:("both observation ned_status words =2","setters accepted via input_filter=65535; observed directly after NED setter"),
2:("both observation ecef_status words =1","observed directly after ECEF setter"),
3:("both copied_ecef vectors =(1048576,0,0)","actual State ECEF_i fields copied after second setter"),
4:("a stale_ned=(0,0,0) and b stale_ned=(524288,0,0)","ECEF setter byte frame preserves NED_i fields"),
5:("both pointer_is_state booleans=true","returned pointer equals State block+328"),
6:("both returned_status words=33","getter selected original ECEF_I branch and sets ECEF_F only"),
7:("forall i,0<=i<656 and not(280<=i<282 or328<=i<340) -> a.before_get[i]=a.after_get[i] and b.before_get[i]=b.after_get[i]","actual 656-byte copies and getter frame; loop guard, sizeof and byte range retained"),
8:("a.bits=(1073741824,0,0)","FALSE; actual a.bits=(0,0,0)"),
9:("b.bits=(1073741824,0,0)","FALSE; actual b.bits=(1065353216,0,0)"),
10:("a.bits=b.bits componentwise","FALSE; actual x bits 0 versus1065353216")
}
items=[]
for index,x in enumerate(ps):
 id=x["id"];loc=x["source_location"];f=loc["function"];cl=loc["propertyClass"];line=int(loc["line"]);num=int(id.rsplit(".",1)[1])
 d={"index":index,"id":id,"status":x["status"],"description":x["description"],"source":loc,"mapped_goal":mapped[id]["rocq_goal"],"formula_status":"audit specification; no Rocq proof claimed","scope":"two fresh original protocol executions N1=(0,0,0),N2=(524288,0,0),E=(1048576,0,0),State memset0,filter65535,immediate complete3word copy; nonblocking assertions"}
 if f in ["ecef_of_enu_vect_f","ecef_of_ned_vect_f"]:
  d.update(category="fallback_unreachable_"+cl.replace(" ","_"),evaluation_guard="original protocol Csem control reaches "+f+" source line"+str(line),guard_formula="evaluation_guard -> "+("notNaN(source operation)"if cl=="NaN"else"finite(source operation)"if cl=="overflow"else"indexed offset within source array[0..8]"if cl=="array bounds"else ptrreasons[(num-1)%6]+"(source pointer access)"),source_operation=x["description"],discharge_route="Prove original ECEF setter yields speed_status=1 and original getter/calc Csem certificate takes ECEF_I conversion; derive no entry into these original callees, not an inactivity input premise.")
 elif f=="stateCalcSpeedEcef_f":
  d.update(category="active_division_finite"if num<=3 else"fallback_division_unreachable",evaluation_guard="selected ECEF_I branch"if num<=3 else"selected NED_I fallback branch",guard_formula="evaluation_guard -> Float32.div(Float32.of_int(ned_speed_i.axis),Float32.of_int524288) is finite",axis="xyz"[(num-1)%3],discharge_route="Active input words are0 or524288, denominator finite nonzero524288. IDs4..6 need original PC exclusion from status1.")
 elif f in ["stateSetSpeedNed_i","stateSetSpeedEcef_i"]:
  axis=(num-1)//6;d.update(category="setter_input_"+ptrreasons[(num-1)%6],evaluation_guard=f+" accepted branch",guard_formula=ptrreasons[(num-1)%6]+"(Vptr source_block "+str(4*axis)+",4byte read)",input_region=[4*axis,4*axis+4],discharge_route="Actual fresh twelve-byte source allocations and word loads; source block lifetime and no integer-address pointer. Per-check meanings retained, not safety aliases.")
 elif f=="protocol"and cl=="pointer dereference":
  field,offset,size=observations[line]
  d.update(category="observer_write_"+ptrreasons[(num-1)%6],evaluation_guard="protocol line"+str(line),guard_formula=ptrreasons[(num-1)%6]+"(out."+field+","+str(size)+"byte write)",observer_field=field,observer_offset=offset,access_bytes=size,discharge_route="Fresh live Observation block, writable full extent1360 with field-offset compatibility; adapter explicitly stores observed typed value.")
 elif f=="protocol"and cl=="array bounds":
  field="copied_ecef"if num<=3 else"stale_ned";ix=(num-1)%3
  d.update(category="observer_array_bound",evaluation_guard="protocol writes out."+field+"["+str(ix)+"]",guard_formula="0 <= "+str(ix)+" <3",discharge_route="Literal subscript plus actual three-element field extent.")
 elif f=="protocol"and cl=="precondition_instance":
  if num==1:d.update(category="memset_writeable",evaluation_guard="protocol memset(&state,0,656)",guard_formula="Writable(State_block,0,656)",discharge_route="Actual initialized State permission, plus explicit zero-byte write/matching initialized bytes adapter.")
  else:
   call=(num-2)//3;kind=(num-2)%3;name,dstoff,srcoff,size=[("before_get",48,0,656),("bits",36,328,12),("after_get",704,0,656)][call]
   formula=["Obj(out."+name+") != Obj(State+"+str(srcoff)+") or src>=dst+n or dst>=src+n","Readable(State_block,"+str(srcoff)+","+str(size)+")","Writable(out_block,"+str(dstoff)+","+str(size)+")"][kind]
   d.update(category=["memcpy_nonoverlap","memcpy_readable","memcpy_writeable"][kind],evaluation_guard="protocol memcpy out."+name,guard_formula=formula,source_region=[srcoff,srcoff+size],destination_region=[dstoff,dstoff+size],discharge_route="Fresh distinct observer and State blocks establish first nonoverlap disjunct; no cross-object ordering. Exact Mem.loadbytes + Mem.storebytes copy needed.")
 elif f=="memcpy":
  if cl=="pointer":
   call=(num-1)//2;branch="second"if num%2 else"third"
  else:
   call=0 if num<=9 else 1 if num<=30 else 2
   branch="second"if(num<=5 or 10<=num<=20 or 31<=num<=35)else"third"
  name,dstoff,srcoff,size=[("before_get",48,0,656),("bits",36,328,12),("after_get",704,0,656)][call]
  evalguard="Obj(dst)=Obj(src)"+(" and not(src>=dst+n)"if branch=="third"else"")
  d.update(category="guarded_memcpy_"+("same_object_comparison"if cl=="pointer"else"pointer_validity"),evaluation_guard=evalguard,guard_formula=evalguard+" -> "+x["description"],literal_guard_source="ROOTRUN/evidence/cbmc-embedded-memcpy.c lines32..34",copy=name,source_region=[srcoff,srcoff+size],destination_region=[dstoff,dstoff+size],discharge_route="Actual Observer destination block is fresh and distinct from State source block. Therefore first || branch succeeds and this guard is not evaluated. Do not prove cross-object pointer relations or replace literal formula by unconditionalTrue.")
 elif f=="main"and cl=="array bounds":
  obj=["a.before_get","a.after_get","b.before_get","b.after_get"][num-1]
  d.update(category="frame_loop_array_bound",evaluation_guard="0<=i<656 and not(280<=i<282 or328<=i<340)",guard_formula="0<=i<656 for "+obj+"[i]",discharge_route="Exact656-element arrays and source for-loop guard; no unwindassertion property ID exists.")
 elif f=="main"and cl=="assertion":
  formula,route=assertions[num];d.update(category="explicit_assertion_"+("refuted"if num>=8 else"proved_candidate"),evaluation_guard="nonblocking CBMC assertion observer; independent of earlier assertion truth",guard_formula=formula,discharge_route=route)
 else:raise ValueError(x)
 items.append(d)
summary={"count":len(items),"status_counts":dict(collections.Counter(x["status"]for x in items)),"function_class_counts":[{"function":k[0],"class":k[1],"count":v}for k,v in sorted(collections.Counter((x["source"]["function"],x["source"]["propertyClass"])for x in items).items())],"category_counts":dict(collections.Counter(x["category"]for x in items)),"unreachable_fallback_ids":99,"guarded_memcpy_ids":45,"no_unwind_property_ids":True,"all_input_hashes_match":True,"property_specmap_id_status_bijection":True,"input_checks":input_checks,"limitations":["This ledger is a read-only semantic audit, not a Rocq proof or closed recheck result.","Observer field offsets1360total/offsets0,2,4,8,20,32,36,48,704 follow declared fixed target C layout; the formal mapper must prove that layout explicitly.","Fallback exclusion must be derived from actual original Csem protocol control. PC exclusions are not assumed input restrictions.","No cross-object C pointer ordering claim. Literal memcpy|| evaluation guards retained.","All276propertyIDs included,273SUCCESS3FAILURE. No synthetic unwindproperty invented.","Original assertions are independent nonblocking observers. A Csem main that aborts at assertion8 would not preserve assertion9/10scope."]}
(run/"evidence/property-ledger.json").write_text(json.dumps({"schema":"five-getter-property-audit/1","properties":items,"summary":summary},indent=2)+chr(10))
(run/"evidence/property-summary.json").write_text(json.dumps(summary,indent=2)+chr(10))
print(json.dumps({k:summary[k]for k in["count","status_counts","function_class_counts","unreachable_fallback_ids","guarded_memcpy_ids","all_input_hashes_match","property_specmap_id_status_bijection"]},indent=2))
