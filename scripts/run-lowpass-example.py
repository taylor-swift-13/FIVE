#!/usr/bin/env python3
"""Replay the concrete lowpass Cexec example using standard Rocq extraction."""
from pathlib import Path
import sys,shutil,subprocess,json,tempfile
from five_telemetry import Run
R=Path(__file__).resolve().parents[1]
def main():
 with tempfile.TemporaryDirectory(prefix='five-lowpass-run-')as tmp:
  B=Path(tmp)
  r=Run.start(R/'reports/example-runs','five-rocq',[],{'task':'Replay concrete lowpass Cexec; one first-successor trace','scope':'Script replay tool costs; no model-authoring token allocation'})
  def command(args,label,timeout=180):
   c=r.command(args,label,timeout=timeout,cwd=B)
   out=(r.folder/c['stdout']).read_text();err=(r.folder/c['stderr']).read_text()
   if c['status']!='passed':raise RuntimeError(out[-2000:]+err[-2000:])
   return out
  try:
   paths=['shared/pure_semantics/SemanticsSupport.v','cases/lowpass/model/Source.v','cases/lowpass/model/SourceInvariant.v','cases/lowpass/model/ExecutionModel.v','cases/lowpass/model/ConcreteRun.v']
   for name in paths:
    p=B/name;p.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(R/name,p)
   flags=['-Q',str(B/'cases'),'FiveCases','-Q',str(B/'shared'),'FiveShared']
   for name in paths:command(['rocq','c',*flags,str(B/name)],Path(name).stem+'-compile')
   p=B/'Extract.v';p.write_text('From Stdlib Require Import Extraction ExtrOcamlBasic ExtrOcamlZBigInt.\nFrom FiveCases.lowpass.model Require Import ConcreteRun.\nExtraction Language OCaml.\nExtraction "lowpass.ml" observe.\n')
   print(command(['rocq','c',*flags,str(p)],'standard-extraction')[-1000:])
   (B/'main.ml').write_text('''open Lowpass
   let z = Big_int_Z.string_of_big_int
   let opt = function None -> "null" | Some n -> z n
   let arr xs = "[" ^ String.concat "," (List.map opt xs) ^ "]"
   let () = let o = observe () in
   Printf.printf "{\\\"status\\\":%s,\\\"steps\\\":%s,\\\"returned_bits\\\":%s,\\\"before_bytes\\\":%s,\\\"after_bytes\\\":%s}\\n" (z o.status) (z o.steps) (opt o.returned_bits) (arr o.before_bytes) (arr o.after_bytes)
   ''')
   command(['ocamlfind','ocamlopt','-w','-a','-package','zarith','-linkpkg','lowpass.mli','lowpass.ml','main.ml','-o','run-lowpass'],'ocaml-build')
   out=command([str(B/'run-lowpass')],'execute-extracted-cexec');print(out)
   result=json.loads(out);assert result['status']==0 and len(result['before_bytes'])==len(result['after_bytes'])==32
   result['changed_offsets']=[i for i,(a,b) in enumerate(zip(result['before_bytes'],result['after_bytes']))if a!=b]
   result['engine']='Standard Rocq OCaml extraction of existing Cexec; no custom native float mapping'
   (R/'cases/lowpass/report/execution.json').write_text(json.dumps(result,indent=2))
   command(['rocq','check',*flags,'FiveCases.lowpass.model.ConcreteRun'],'kernel-check',timeout=180)
  except Exception as exc:
   r.finish('failed',str(exc),{});raise
  else:
   r.finish('passed','Concrete Cexec execution and independent kernel check passed',{'execution':R/'cases/lowpass/report/execution.json','driver':R/'cases/lowpass/model/ConcreteRun.v'})
if __name__=='__main__':main()
