from pathlib import Path
import json,hashlib,re,shutil,sys
root=Path('/home/yangfp/five');sys.path.insert(0,str(root/'scripts'))
from five_telemetry import Run
run=Run(root/'runs/20261106T131406-37a522857a/five-rocq')
base=root/'paparazzi/relations/guidance_mode/support/software';build=base/'evidence/numeric-check-002'
if build.exists():raise RuntimeError('Immutable snapshot exists')
build.mkdir(parents=True);src=base/'NumericOps.v';snap=build/'NumericOps.v';shutil.copyfile(src,snap)
flags=['-Q',str(build),'FiveGuidanceSoftwareProof']
comp=run.command(['rocq','compile',*flags,str(snap)],'numeric-frozen-full-compile',timeout=90,cwd=str(root))
names=['safe_binop_total','safe_unop_total','safe_cast_total','bool_val_total','numeric_binop_independent','numeric_unop_independent','numeric_kind_cases']
cert=build/'GoalBinding.v';text='From Stdlib Require Import Bool List ZArith.\nFrom compcert Require Import Coqlib Maps Integers Floats AST Values Memory Ctypes Cop Csyntax Csyntaxdefs.\nFrom FiveGuidanceSoftwareProof Require Import NumericOps.\n'
goals=[]
for i,name in enumerate(names):
 pattern=r'Lemma '+name+r'\s*:(.*?)\.\s*Proof\.'
 typ=re.search(pattern,src.read_text(),re.S).group(1)
 text+='Definition goal_'+str(i)+' : '+typ+' := FiveGuidanceSoftwareProof.NumericOps.'+name+'.\nPrint Assumptions goal_'+str(i)+'.\n'
 goals.append({'requested_goal':name,'theorem':'FiveGuidanceSoftwareProof.NumericOps.'+name,'type':typ.strip()})
cert.write_text(text)
cc=run.command(['rocq','compile',*flags,str(cert)],'numeric-goalbinding-full-compile',timeout=90,cwd=str(root))
ck=run.command(['rocq','check','-silent',*flags,'FiveGuidanceSoftwareProof.GoalBinding'],'numeric-goalbinding-independent-kernel',timeout=90,cwd=str(root))
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
index={'schema':'five-proof-inputs/1','dependency_sha256':{str(src.relative_to(root)):sha(src)}}
(build/'inputs.json').write_text(json.dumps(index,indent=2)+'\n')
rec={'schema':'five-proof-support-validation/1','scope':'Strict numeric scalar checker totality, type preservation, literal guards and all-env/memory independence; no global C goal assumed','inputs':[{'path':str(src.relative_to(root)),'sha256':sha(src),'snapshot':str(snap.relative_to(root))}],'goal_bindings':goals,'certificate':{'path':str(cert.relative_to(root)),'sha256':sha(cert),'compile_command_id':cc['id'],'kernel_command_id':ck['id']},'run':str(run.folder.relative_to(root))}
(build/'numeric-validation.json').write_text(json.dumps(rec,indent=2)+'\n')
report='''# Numeric operator support

All seven exact support goals are compiled and independently kernel checked; see `evidence/numeric-check-002/numeric-validation.json`. The theorem types are bound by a compiled GoalBinding certificate.

`numeric_kind` accepts precisely `tint`, `tuint`, `tulong`, and `tfloat` without attributes. Values are respectively Vint, Vint, Vlong and Vsingle. `safe_binop` enforces the actual usual arithmetic result type, rejects floating binary arithmetic, allows integer arithmetic/bitwise/comparison operators, accepts shifts only for a literal Vint below the left word width, and accepts division/modulo only for literal 2 of the actual RHS type. `safe_unop` admits typed negation, integer bit-not and numeric boolean-not with the exact result type. `safe_cast` admits 32/64 numeric word casts and binary32 identity.

`safe_binop_total` supplies one typed result for every composite environment and memory; `numeric_binop_independent` additionally proves equality of even partial operator results for arbitrary environments and memories. The unary, cast, and truth-value theorems have matching memory-independent results. These are the original CompCert Cop operations, with no axioms or admitted obligations added. The recorded target ABI is CompCert x86-64; signed word arithmetic is interpreted exactly as CompCert defines it.

Actual worker: gpt-6.1-sol medium, actor `/root/guidance_mode_complete_medium/guidance_entry`. Telemetry: `runs/20261106T131406-37a522857a/five-rocq`, including all failures/repairs. Operator support does not by itself prove the full C function or all-order safety; the parent owns the actual AST definite-assignment checker and heap/functional bridge.
'''
(base/'numeric-report.md').write_text(report)
(run.folder/'outputs.json').write_text(json.dumps({'numeric_ops':str(src),'proof_certificate':str(cert),'validation':str(build/'numeric-validation.json'),'report':str(base/'numeric-report.md')},indent=2)+'\n')
print('All exact numeric operator goals frozen, bound and independently kernel checked.')

