import hashlib,json,shutil
from pathlib import Path
root=Path('/home/yangfp/five');c=root/'examples/sum3';stage=c/'prepare';old=stage/'source/Program.c'
original=old.read_bytes();original_hash=hashlib.sha256(original).hexdigest()
provenance=stage/'provenance/original.c';provenance.parent.mkdir(exist_ok=True);provenance.write_bytes(original)
prepared=stage/'source/sum3.c';prepared.write_text('float sum3(float a, float b, float c) {\n    return a + b + c;\n}\n')
assert original.count(prepared.read_bytes().rstrip(b'\n'))==1
old.unlink()
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def load(p):return json.loads(p.read_text())
def save(p,x):p.write_text(json.dumps(x,ensure_ascii=False,indent=2)+'\n')
b=stage/'source/bindings.json';v=load(b);v['original_source']={'path':'prepare/provenance/original.c','sha256':original_hash};v['prepared_source']={'path':'prepare/source/sum3.c','sha256':sha(prepared)};v['preparation']='Selected sum3 and retained its complete direct source-level dependency closure. Removed unrelated sum3_right, left_example and right_example; original source is retained separately for provenance.';v['entry']='sum3';v['entry_signature']='float sum3(float a, float b, float c)';v['call_closure']={'entry':'sum3','function_definitions':['sum3'],'direct_callees':[],'indirect_calls':[],'external_functions':[],'global_variables':[],'required_headers_or_macros':[],'analysis_scope':'Source-level inspection of the selected function; no numeric input preconditions are imposed.'};v['correspondence_obligations']=['Source extraction and its translation-unit context must be accounted for when transferring properties to a different original build.','Connect mapped CBMC properties to CompCert execution and observations.'];save(b,v)
m=stage/'report/manifest.json';v=load(m);v['stages']['five-prepare']['inputs']=[{'path':'prepare/provenance/original.c','sha256':sha(provenance)}];v['stages']['five-prepare']['outputs']=[{'path':'prepare/source/sum3.c','sha256':sha(prepared)},{'path':'prepare/source/bindings.json','sha256':sha(b)}];v['stages']['five-prepare']['limitations']=['Source-level closure inspected; transferring conclusions to an original build requires the relevant correspondence.','Prepare revision cost evidence is recorded separately.'];save(m,v)
h=stage/'handoff.json';v=load(h)
for o in v['outputs']:
 if o['role']=='prepared_c':o['path']='prepare/source/sum3.c'
 p=c/o['path']
 if p.exists():o['sha256']=sha(p)
v['entry']='sum3';v['limitations']=['Original translation unit is archived separately; transfer to a different build requires correspondence.','Revision cost report will be added when measurement finishes.'];save(h,v)
rp=stage/'report/report.md';rp.write_text('# sum3 preparation\n\nThe verified entry is `sum3`, defined in `source/sum3.c`. The entry has no callees or other C dependencies. The original four-function translation unit is kept only in `provenance/original.c`; the three unrelated functions are excluded from the prepared input. No CBMC, model generation, or proof has run.\n')
readme=c/'README.md';s=readme.read_text().replace('prepare/source/Program.c','prepare/source/sum3.c').replace('The prepared C, target and bindings are in `prepare/source/`;','The selected entry `sum3` is in `prepare/source/sum3.c`; its inspected call closure contains no additional functions. The original translation unit is retained under `prepare/provenance/`. The target and bindings are in `prepare/source/`;');readme.write_text(s)
readme=root/'README.md';s=readme.read_text().replace('examples/sum3/prepare/source/Program.c','examples/sum3/prepare/source/sum3.c').replace('The unchanged [C program]','The prepared [C program]');readme.write_text(s)
for name in ['five-prepare','five-cbmc','five-align','five-rocq','five-verify']:
 p=root/'.agents/skills'/name/'SKILL.md';s=p.read_text().replace('source/Program.c','source/<entry>.c')
 if name=='five-prepare':
  at='## 准备方法\n'
  block='''## 入口与依赖闭包

每个 C case 必须明确一个用户选定的验证入口函数 `entry`；准备后的入口源码文件命名为 `<entry>.c`，例如 `sum3` 对应 `sum3.c`。入口不要求是 C `main`；验证 harness 由后续 CBMC 阶段另建。`bindings.json` 和 handoff 必须记录入口名、入口文件、签名、源码哈希和依赖闭包。

从入口沿调用关系保留所有可达 callee 及其必需的声明、类型、宏、头文件、全局变量、初始化和编译条件；排除没有依赖关系的其他示例函数。保留原始源码快照及其 hash 以便追溯，快照不得混入实际编译输入。记录保留和移除的内容、依赖来源和实际绑定。函数指针、条件编译、外部链接或缺失头文件造成闭包不确定时明确记录未解决项，不能声称闭包完整；需保持原始构建行为时保留可影响入口行为的符号和初始化。抽取后的程序对应原程序的范围及待证关系须明确；不能把语法检查当作语义等价证明。

'''
  if '## 入口与依赖闭包' not in s:s=s.replace(at,block+at)
 p.write_text(s);host=Path('/mnt/c/Users/50635/.codex/skills')/name/'SKILL.md';shutil.copyfile(p,host)
contract=root/'.agents/skills/five-verify/references/case-contract.md';s=contract.read_text().replace('source/Program.c','source/<entry>.c').replace('prepare/source/Program.c','prepare/source/<entry>.c');contract.write_text(s);shutil.copyfile(contract,Path('/mnt/c/Users/50635/.codex/skills/five-verify/references/case-contract.md'))
print('Entry sum3 is in sum3.c; original source retained separately; closure and skills updated.')
