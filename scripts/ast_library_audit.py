"""Audit direct call closure of clightgen Csyntax; unknown forms remain pending.

This is an AST dependency audit, not a replacement for Cexec/Csem proofs.
Indirect calls and unsupported syntax are reported, never guessed away.
"""
from pathlib import Path
import argparse,hashlib,json,re,subprocess,tempfile,shutil

ROOT=Path(__file__).resolve().parents[1]
OFFICIAL_FORMS={'EF_malloc','EF_free','EF_memcpy','EF_annot','EF_annot_val','EF_debug'}
WORLD_FORMS={'EF_vload','EF_vstore'}
# System-interface names require concrete official semantics and an appropriate
# world. Unknown external names still require explicit classification/review.
SYSTEM_NAMES=set('read write pread pwrite readv writev open openat close lseek stat fstat mmap munmap mprotect brk ioctl fcntl poll ppoll select pselect socket connect bind listen accept send recv sendto recvfrom shutdown fork vfork clone execve waitpid gettimeofday clock_gettime nanosleep getrandom syscall raise kill sigaction sigprocmask futex'.split())

def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()

def balanced(text,start):
 """Return one parenthesized clightgen term; respect Coq string quoting."""
 if text[start]!='(':raise ValueError('expected parenthesized AST term')
 depth=0;quoted=False;i=start
 while i<len(text):
  c=text[i]
  if c=='"':
   if quoted and i+1<len(text)and text[i+1]=='"':i+=2;continue
   quoted=not quoted
  elif not quoted:
   if c=='(':depth+=1
   elif c==')':
    depth-=1
    if depth==0:return text[start:i+1],i+1
  i+=1
 raise ValueError('unbalanced generated AST')

def parse(text):
 functions=dict(re.findall(r'Definition (f_\w+) := \{\|(.*?)\|\}\.',text,re.S))
 if not functions:raise ValueError('no generated Csyntax functions found')
 internals=dict(re.findall(r'\((_[\w]+),\s*Gfun\s*\(\s*Internal\s+(f_\w+)\s*\)',text))
 externals={}
 for m in re.finditer(r'\((_[\w]+),\s*Gfun\s*\(\s*External\s*',text):
  start=m.end()
  while start<len(text)and text[start].isspace():start+=1
  if text[start]=='(':term,_=balanced(text,start)
  else:
   bare=re.match(r'EF_(?:malloc|free)\b',text[start:])
   if not bare:raise ValueError('unrecognized external AST constructor')
   term=bare[0]
  tag=re.search(r'\b(EF_\w+)\b',term)
  if not tag:raise ValueError('external function missing EF tag')
  name=re.search(r'EF_(?:external|builtin|runtime)\s+"([^"]+)"',term)
  externals[m[1]]={'tag':tag[1],'name':name[1]if name else None,'term':term}
 return functions,internals,externals

def known_builtin(term):
 """Ask installed CompCert's exact lookup, including the AST signature."""
 rocq=shutil.which('rocq')
 if not rocq:return False,'Rocq unavailable for official builtin lookup'
 source='''From Stdlib Require Import List String ZArith.
From compcert Require Import AST Integers Floats Values Ctypes Csyntax Builtins.
Import ListNotations.
Local Open Scope Z_scope.
Local Open Scope string_scope.
Definition inspected_ef:external_function := TERM.
Goal True.
 let supported:=eval vm_compute in
 (match inspected_ef with
 |EF_builtin name sg|EF_runtime name sg=>match lookup_builtin_function name sg with Some _=>true|None=>false end
 |_=>false end)in
 lazymatch supported with true=>idtac "OFFICIAL_SUPPORTED"|_=>idtac "OFFICIAL_UNSUPPORTED"end.
 exact I.
Qed.
'''.replace('TERM',term)
 with tempfile.TemporaryDirectory(prefix='five-builtin-lookup-')as tmp:
  p=Path(tmp)/'Lookup.v';p.write_text(source)
  try:c=subprocess.run([rocq,'c',str(p)],capture_output=True,text=True,timeout=30,cwd=tmp)
  except subprocess.TimeoutExpired:return False,'Official builtin lookup timed out'
  return c.returncode==0 and 'OFFICIAL_SUPPORTED' in c.stdout,'Official lookup_builtin_function(name,signature)'

def classify(ef,registry,root,builtin_lookup=known_builtin):
 tag,name=ef['tag'],ef['name']
 row={'ast_form':tag,'name':name}
 if tag in OFFICIAL_FORMS:return {**row,'status':'official-concrete','action':'Reuse official Events/Cexec operation directly'}
 if tag in WORLD_FORMS:return {**row,'status':'needs-official-world','action':'Official volatile operation exists; require a compatible executable world and correspondence evidence'}
 if tag=='EF_inline_asm':return {**row,'status':'unsupported-system-interface','action':'No fabricated inline assembly implementation'}
 if tag in['EF_builtin','EF_runtime']:
  ok,why=builtin_lookup(ef['term'])
  return {**row,'status':'official-concrete'if ok else'unsupported-builtin','action':why}
 if tag!='EF_external':return {**row,'status':'unresolved-ast-form','action':'Manual review required'}
 if name in SYSTEM_NAMES:return {**row,'status':'unsupported-system-interface','action':'An abstract EF_external/Event_syscall is not a concrete official syscall implementation; no stub allowed'}
 entry=registry.get('ordinary_functions',{}).get(name)
 if not entry:return {**row,'status':'needs-library-spec','action':'Classify effects, then generate only the required ordinary-library spec/adapter; do not verify library internals'}
 if entry.get('effects')in['direct-system-call','inline-assembly']:return {**row,'status':'unsupported-system-interface','action':'Direct system effects require concrete official support; no generated syscall stub'}
 if entry.get('effects')not in['memory-only','library-io']:return {**row,'status':'needs-library-spec','action':'Review and classify library effects before implementing the minimal model'}
 if entry['effects']=='library-io'and not all(entry.get(k)for k in['world_adapter_source','world_conformance_theorem']):return {**row,'status':'needs-library-world','action':'Ordinary library I/O requires its specified observable trace/world; a constant-return stub is insufficient'}
 evidence={}
 for key in['adapter_source','spec_source','conformance_proof_source']:
  p=Path(root)/entry.get(key,'')
  if not p.is_file():return {**row,'status':'needs-library-spec','action':'Registered adapter/spec/proof source is missing'}
  evidence[str(p.relative_to(root))]=sha(p)
 if entry['effects']=='library-io':
  p=Path(root)/entry['world_adapter_source']
  if not p.is_file():return {**row,'status':'needs-library-world','action':'Missing library I/O world implementation'}
  evidence[str(p.relative_to(root))]=sha(p)
 for field in['callback','specification','conformance_theorem']:
  if not entry.get(field):return {**row,'status':'needs-library-spec','action':'Registered interface is incomplete'}
 return {**row,'status':'ordinary-adapter-available','action':'Bind this adapter and explicit library-contract assumption in the execution correspondence proof','adapter':entry,'dependency_sha256':evidence}

def audit_source(path,entries,registry,root=ROOT,builtin_lookup=known_builtin):
 path=Path(path);text=path.read_text();functions,internals,externals=parse(text)
 queue=list(entries);seen=set();calls=[];problems=[];used=set()
 while queue:
  f=queue.pop(0)
  if f in seen:continue
  seen.add(f)
  if f not in functions:problems.append({'function':f,'reason':'Missing selected/internal function definition'});continue
  body=functions[f];all_calls=list(re.finditer(r'\bEcall\b',body))
  direct=list(re.finditer(r'\bEcall\s*\(\s*Evalof\s*\(\s*Evar\s+(_\w+)\b',body))
  if len(all_calls)!=len(direct):problems.append({'function':f,'reason':'Indirect or unparsed call expression; dependency coverage not established'})
  frame=body[:body.index('fn_body :=')]
  for m in direct:
   symbol=m[1];item={'caller':f,'symbol':symbol,'line':text[:text.index(body)+m.start()].count('\n')+1}
   if re.search(r'\('+re.escape(symbol)+r'\s*,',frame):
    problems.append({'function':f,'reason':'Callee name is shadowed by a local/parameter; not a resolved global direct call'});continue
   if symbol in internals:item.update(kind='internal',callee=internals[symbol]);queue.append(internals[symbol])
   elif symbol in externals:
    used.add(symbol);item.update(kind='external',support=classify(externals[symbol],registry,Path(root),builtin_lookup))
   else:item.update(kind='unresolved');problems.append({'function':f,'reason':'Missing global callee '+symbol})
   calls.append(item)
  builtin_count=len(re.findall(r'\bEbuiltin\b',body));parsed=0
  for m in re.finditer(r'\bEbuiltin\s*',body):
   k=m.end()
   if k>=len(body)or body[k]!='(':continue
   term,_=balanced(body,k);tag=re.search(r'\b(EF_\w+)\b',term)
   if tag:
    name=re.search(r'EF_(?:external|builtin|runtime)\s+"([^"]+)"',term)
    calls.append({'caller':f,'kind':'builtin-expression','support':classify({'tag':tag[1],'name':name[1]if name else None,'term':term},registry,Path(root),builtin_lookup)});parsed+=1
  if parsed!=builtin_count:problems.append({'function':f,'reason':'Unparsed Ebuiltin operation'})
 unresolved=[row for row in calls if 'support'in row and row['support']['status']not in['official-concrete','ordinary-adapter-available']]
 return {'source':str(path),'source_sha256':sha(path),'entries':entries,'internal_functions':sorted(seen),'static_calls':calls,
  'unused_external_declarations':len(set(externals)-used),'unused_declarations_require_adapters':False,
  'problems':problems,'unresolved_calls':unresolved,'support_inventory_complete':not(problems or unresolved),
  'proof_scope':'Static direct-call closure audit; adapter availability does not prove runtime connection or actual libc/musl implementation correctness'}

CASES={'sum3':('examples/sum3/model/Source.v',['f_sum3'])}

def main():
 p=argparse.ArgumentParser(description=__doc__);p.add_argument('--source',type=Path);p.add_argument('--entry',action='append');p.add_argument('--output',type=Path);a=p.parse_args()
 registry_path=ROOT/'shared/compcert_libc/registry.json';registry=json.loads(registry_path.read_text())
 if a.source:
  if not a.entry:p.error('--source requires --entry')
  results={'requested':audit_source(a.source,a.entry,registry)}
 else:results={c:audit_source(ROOT/path,entries,registry)for c,(path,entries)in CASES.items()}
 for row in results.values():
  try:row['source']=str(Path(row['source']).relative_to(ROOT))
  except ValueError:pass
 units={}
 if not a.source:
  for path in sorted({path for path,_ in CASES.values()}):
   fs,_,_=parse((ROOT/path).read_text());unit=audit_source(ROOT/path,sorted(fs),registry);unit['source']=path;units[path]=unit
 report={'schema':'five-ast-library-audit/1','registry_sha256':sha(registry_path),'cases':results,'compilation_units':units,'all_call_dependencies_classified':all(x['support_inventory_complete']for x in results.values()),'all_compilation_unit_functions_classified':all(x['support_inventory_complete']for x in units.values()),'library_implementation_verification':False,'external_contracts':'Library specifications are explicit trusted interface assumptions; callback conformance is a separate proof obligation'}
 if a.output:a.output.parent.mkdir(parents=True,exist_ok=True);a.output.write_text(json.dumps(report,ensure_ascii=False,indent=2))
 for c,row in results.items():
  external=[x['support']['name']or x['support']['ast_form']for x in row['static_calls']if 'support'in x]
  print(c,'ordinary/external calls:',external,'classified:',row['support_inventory_complete'])
 if not report['all_call_dependencies_classified']:raise SystemExit(1)
if __name__=='__main__':main()
