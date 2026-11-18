from pathlib import Path
import json,hashlib
R=Path('/home/yangfp/five')
NAMES={'init_first_order_low_pass':31,'update_first_order_low_pass_tau':19,'reset_first_order_low_pass':27}
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
for n,count in NAMES.items():
 c=R/'paparazzi/models'/n;m=json.loads((c/'align/model/compcert-manifest.json').read_text())
 mp=c/'align/model/spec-map.json';mapping=json.loads(mp.read_text())
 props=json.loads((c/'cbmc/properties.json').read_text())
 assert len(props)==count and all(x['status']=='SUCCESS'for x in props)
 assert {p['property']for p in props}=={p['property_id']for p in mapping['properties']}
 assert mapping['verification_method']=='traditional-bounded-model-checking'
 assert mapping['backend_manifest_sha256']==sha(c/'align/model/compcert-manifest.json')
 assert mapping['request_sha256']==sha(c/'align/request.json')
 assert all(p['mapping_status']=='mapped'for p in mapping['properties'])
 assert not mapping.get('gaps',[])
 assert all(p.get('proof_status')=='pending'for p in mapping['properties'])
 text='\n'.join(['# Align '+n,'',
 'Generation, fresh provenance auditing and mapping of all '+str(count)+' actual CBMC properties are complete. This stage generates models and proof obligations; accepted program proofs and CBMC rechecks are delivered separately under rocq/.','',
 'Input: the frozen prepare source/bindings and the preceding CBMC handoff. The unchanged prepared C body is exported by clightgen -csyntax into namespace '+m['namespace']+', entry '+m['function']+'. Source.v is generated; Execution.v embeds the original Cexec/Csem execution interfaces. Model entry accepts arbitrary machine argument lists and CompCert memories, including invalid accesses and uninitialized content. Safety preconditions are not used to clip this execution model.','',
 'Target: CompCert3.17 Csem/Cexec, x86-64 Linux standard ABI, little endian, binary32, nearest ties to even. The manifest binds the exact tool, target, NaN policy and semantic dependencies. The selected original body has no reachable callees, external calls, builtins, assembly, volatile access or I/O; unused frontend-generated builtin declarations do not add reachable calls.','',
 'The fresh audit independently preprocesses the prepared C and re-exports its AST, then compares the AST, original Cexec wrapper, tool/configuration, source and all semantic dependency hashes. See [provenance audit](evidence/provenance-audit.json). Generated proof/Precondition.v is a parameter interface; proof/Obligations.v generates no-error and all-successor termination goals; proof/Proofs.v is scaffolding, not a completed proof.','',
 'Two generation issues were discovered and resolved in the shared three-case batch: the initial exporter invocation required f_NAME rather than NAME; after that correction CompCert had eliminated the unreferenced static-inline entry. The prepared standalone entry removes only static/inline declaration qualifiers, preserving the original struct, parameters, body and expression order. Independent original-slice comparison and fresh AST auditing passed. Issue counts: found2, resolved2, unresolved0 (one shared batch, not six case issues).','',
 'All '+str(count)+' real emitted IDs, raw statuses, locations, harness/source hashes, memory regions, scopes and observations are mapped in model/spec-map.json. They stay pending proof at this generation boundary; the separate rocq/spec-recheck.json carries proof outcomes. Final CBMC scope is safety plus complete-bit copies/frames. Coefficient arithmetic and the complete12byte functional behavior are separate Rocq obligations for all binary32 values; arithmetic solver timeouts in CBMC history are retained without a numerical-success or counterexample claim.','',
 'The original-source scope is the selected Paparazzi function after documented declaration normalization. No separate GCC binary/hardware equivalence theorem is supplied. Every relevant file and upstream handoff is hash-bound by handoff.json. [Costs](costs.json) retain failed and successful actual export windows, fresh auditing and final packaging, without assigning invented exclusive per-case costs. Nested exporter runs are source-provenance receipts: their tool CPU is already inside the measured outer export commands. Global token totals use event-ID union across overlapping/shared windows.',''])
 (c/'align/report/report.md').write_text(text)
 print(n+': '+str(count)+' real IDs mapped; source/model provenance report written')
