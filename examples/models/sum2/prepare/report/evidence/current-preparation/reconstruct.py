from pathlib import Path
import hashlib,json,re,shutil,subprocess
root=Path('/home/yangfp/five');case=root/'examples/models/sum2'
stage=root/'runs/examples-audit-medium/sum2-current-prepare';stage.mkdir(exist_ok=True)
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
source=case/'prepare/source/sum2.c';text=source.read_text()
assert re.fullmatch(r'float sum2\(float a, float b\) \{ return a \+ b; \}\n',text)
(stage/'source').mkdir(exist_ok=True)
(stage/'source/sum2.c').write_text('float sum2(float a, float b) { return a + b; }\n')
bindings={'entry':'sum2','source':'prepare/source/sum2.c','sha256':sha(stage/'source/sum2.c'),'callees':[],'external_bindings':[],'target':{'semantics':'CompCert Csem/Cexec','arch':'x86','bitsize':64,'system':'linux','endianness':'little','float32':'IEEE754 binary32','rounding':'round-to-nearest-ties-to-even'}}
(stage/'source/bindings.json').write_text(json.dumps(bindings,indent=2)+'\n')
shutil.copyfile(case/'prepare/verification-request.json',stage/'verification-request.json')
for src,dst in [(source,stage/'source/sum2.c'),(case/'prepare/source/bindings.json',stage/'source/bindings.json'),(case/'prepare/verification-request.json',stage/'verification-request.json')]:assert src.read_bytes()==dst.read_bytes(),(src,dst)
subprocess.run(['gcc','-std=c11','-Wall','-Wextra','-Werror','-fsyntax-only',str(stage/'source/sum2.c')],check=True)
subprocess.run(['gcc','-std=c11','-MM',str(stage/'source/sum2.c')],check=True)
receipt={'schema':'five-current-preparation/1','status':'passed','scope':'New measured preparation from the available frozen sum2 source and verification request; independently reconstructs exact C and bindings. Does not recover unknown historical construction cost or assert unavailable upstream provenance.','entry':'sum2','signature':'float sum2(float,float)','closure':{'callees':[],'headers':[],'globals':[],'retained':['sum2'],'removed':[],'external_bindings':[],'limitations':['No upstream original source beyond the existing frozen case seed is available.']},'inputs':[{'path':str(p.relative_to(root)),'sha256':sha(p)} for p in [source,case/'prepare/source/bindings.json',case/'prepare/verification-request.json']],'reconstructed':[{'path':str(p.relative_to(root)),'sha256':sha(p)} for p in [stage/'source/sum2.c',stage/'source/bindings.json',stage/'verification-request.json']],'byte_comparison':'All three reconstructed artifacts equal frozen case bytes','semantic_correspondence':'Same C bytes; no replacement/extraction transformation; syntax check is not a semantic proof'}
(stage/'receipt.json').write_text(json.dumps(receipt,indent=2)+'\n')
print(json.dumps(receipt,indent=2))
