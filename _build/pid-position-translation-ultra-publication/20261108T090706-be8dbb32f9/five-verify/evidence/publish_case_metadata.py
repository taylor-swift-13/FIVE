#!/usr/bin/env python3
import hashlib,json,os,copy
from pathlib import Path
ROOT=Path('/home/yangfp/five')
CASE=ROOT/'paparazzi/models/guidance_pid_h_run_pos'
REL=ROOT/'paparazzi/relations/pid_position_translation'
PUB=Path(Path('/tmp/pid-publication-run').read_text())
def read(p):return json.loads(p.read_text())
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def rel(p,base=ROOT):return os.path.relpath(p,base)
def write(p,d):p.write_text(json.dumps(d,indent=2,ensure_ascii=False)+'\n')
def remap(record,oldbase,newbase):
 r=copy.deepcopy(record)
 r['evidence']=[rel((oldbase/x).resolve(),newbase)for x in r.get('evidence',[])]
 if r.get('agent',{}).get('evidence'):r['agent']['evidence']=rel((oldbase/r['agent']['evidence']).resolve(),newbase)
 if r.get('shared_costs'):r['shared_costs']=rel((oldbase/r['shared_costs']).resolve(),newbase)
 return r
def main():
 problems=[REL/'problem']+[CASE/'rocq'/x/'problem'for x in ['no_error','termination','cbmc_recheck']]
 for p in problems:
  s=read(p/'status.json')
  assert s['status']=='proved',(p,s['status'])
  assert all(s.get('goal_status',{}).get(x)=='proved'for x in s['requested_goals']),p
 shared=read(REL/'attempts/002/costs.json')
 common_runtime=REL/'attempts/002/evidence/runtime-config.json'
 common_model=REL/'attempts/002/evidence/model-config.json'
 proof_runs=[x for x in shared['records']if x['role']in ['lead-proof','core-proof','safety-proof']]
 assert len(proof_runs)==3
 canonical=REL/'problem/Spec.v'
 source=CASE/'align/model/Source.v';execution=CASE/'align/model/Execution.v'
 history=read(PUB/'inputs/previous-rocq-stage.json')
 old_costs=read(PUB/'inputs/previous-rocq-stage/costs.json')
 agbase=ROOT/'paparazzi/report/pid_position_translation/ultra-retry'
 aggregate=read(agbase/'costs.json')
 stage_records=[remap(x,agbase,CASE/'rocq/report')for x in aggregate['records']if x['stage']=='five-rocq']
 historical=[]
 for old in old_costs['records']:
  x=copy.deepcopy(old)
  x['evidence']=[rel((ROOT/ref).resolve(),CASE/'rocq/report')for ref in x.get('evidence',[])]
  if x.get('agent',{}).get('evidence'):x['agent']['evidence']=rel((ROOT/x['agent']['evidence']).resolve(),CASE/'rocq/report')
  historical.append(dict(x,historical=True,excluded_from_current_aggregate=True))
 stage_costs={'schema':'five-stage-costs/1','scope':'Historical medium record retained separately; current shared Ultra author/tool runs are measured once jointly across relation/model goals. Do not add copied per-problem references.','records':historical+stage_records,'current_shared_costs':rel(REL/'attempts/002/costs.json',CASE/'rocq/report'),'current_aggregate':rel(ROOT/'paparazzi/report/pid_position_translation/ultra-retry/costs.json'),'historical_snapshot':rel(PUB/'inputs/previous-rocq-stage/costs.json')}
 write(CASE/'rocq/report/costs.json',stage_costs)
 for name,title,theorem in [
 ('no_error','原 Csem 全可达无错误','PidPositionRunPosNoErrorAttempt002.Proof.no_error'),
 ('termination','原 Csem 全后继终止','PidPositionRunPosTerminationAttempt002.Proof.termination'),
 ('cbmc_recheck','全部124个原CBMC性质的Rocq重验','PidPositionRunPosCBMCAttempt002.Proof.checked_properties')]:
  folder=CASE/'rocq'/name/'attempts/002';spec=folder.parent.parent/'problem/Spec.v'
  per_records=[]
  for x in proof_runs:
   per_records.append({'stage':'five-rocq','run':x['run'],'status':'recorded','shared_costs':rel(REL/'attempts/002/costs.json',folder),'evidence':[rel((REL/'attempts/002'/v).resolve(),folder)for v in x['evidence']],'agent':dict(x['agent'],evidence=rel((REL/'attempts/002'/x['agent']['evidence']).resolve(),folder)),'measurement_scope':'Shared multi-goal PID authoring run, not an independently measured per-goal interval. The full run is recorded once in shared_costs; this per-goal allocation is unknown and not additive.','time':{'wall_seconds':None,'tool_cpu_seconds':None},'token':{'input':None,'output':None,'total':None,'cached_input':None,'reasoning_output':None},'memory':{'tool_peak_rss_bytes':None,'model_server_memory_bytes':None},'unobserved_reason':'No separate per-goal model/tool boundary; shared actual runs include failed compilations and timeouts. Complete CPU/RSS cannot be inferred from missing GNU/sampling receipts.'})
  write(folder/'costs.json',{'schema':'five-stage-costs/1','scope':'Per-problem allocation is unobserved; follow shared_costs for the actual current Ultra run records. Historical001 remains unchanged.','records':per_records,'runtime_config':rel(common_runtime),'model_config':rel(common_model)})
  if name=='no_error':
   body='当前 RequestedGoal 已由原 Csem 全可达状态证明闭合，覆盖所有允许的操作数求值顺序和两种 flight。InputGood 显式要求位置字段 Some(Vint) 与安全减法；它修正旧单次 NoError 问题中可读但可为 Vundef 的遗漏。没有假定正常返回。原 InputPair 关系域等价已单独证明。'
  elif name=='termination':
   body='当前 RequestedGoal 已由原入口的全部后继 Acc 证明闭合。底层 target-aware rank 对任意原始参数与内存成立，无需数值前条件或执行 fuel；它不是单条正常返回路径。外部调用按原 CompCert 原子 external-call 语义解释。'
  else:
   body='全部124个实际CBMC ID各有精确 Goal/定理别名及独立 kernel：51溢出、7移位、60指针、6断言。控制器与入口的算术/指针性质覆盖原入口实际可达 ready 操作及所有求值顺序；当前 readable_span 从语义安全性推出，不以成功访问为前提。harness 的六个加法按原逻辑 InputPair 域证明可表示性，六断言另有真实分配、cast、store/load 快照与原 alpha-renamed &&/== 表达式的 Csem.star 到真。Source没有 nondet/assume harness main，未声称该 main 的完整执行。'
  text=f"""# {title}

已证明：{theorem}，精确当前问题见 problem/Spec.v。{body}

本次实际数学作者为 gpt-6.1-sol / ultra，用户配置覆盖 skill 默认 medium。三位实际作者的 runtime/session 元数据与去重事件在共享成本记录和总报告中；common runtime receipt 为 {rel(common_runtime)}，model config 为 {rel(common_model)}。当前问题 SHA-256：{sha(spec)}；传递 canonical InputGood/关系 Spec：{sha(canonical)}。

原 C SHA-256 8ca491f87de8559d9f4a48eca3fc7a70e63ac8edd7326e18483f25f2b5868c04；Source.v {sha(source)}；Execution.v {sha(execution)}。目标为 CompCert3.17 / Rocq9.2 / OCaml4.14.2，x86-64 Linux standard，小端，binary32 RNE。实际入口参数含隐藏返回缓冲区，返回 void/Vundef；观察原 active LTP 字段、Mem.loadbytes/memval 与声明范围内的权限/字节。

原 Source/Execution 及全部分支保持不变。有效 NED_i cache 与 approx=false 排除 stateCalcPositionNed_i、stateCalcSpeedNed_i、atan2f；绑定仍 OPEN，域外完整环境对应没有被声称。Print Assumptions 保留实际继承的 CompCert 外部语义接口、标准库 classical、proof-irrelevance 和 extensionality；没有新增目标公理或 Admitted。

当前完整 cold compile、精确 CurrentGoalBinding、Print Assumptions 与独立内核回执见 evidence/goal-validation.json 和 provenance.json。check.py 委托共同冷构建，可复跑当前完整目标；历史001不会执行或重编。001报告/成本/原问题快照保持不变，前条件更正理由在关系002/evidence/precondition-change.json。

费用见本目录 costs.json 与共享 relation002/costs.json。没有逐目标时间/token的独立边界，因此本目标分摊为 null，并引用真实共享记录；所有失败/超时保留。完整 CPU 与并发联合 RSS 的未知项不会由已观测小计估算；模型服务器内存不可观测。
"""
  (folder/'report.md').write_text(text,encoding='utf-8')
 stage_report=f"""# 原PID位置控制器：Rocq当前结果

当前 NoError、全后继终止和全部124个实际CBMC性质已证明并完成冷构建、精确目标绑定及独立内核验收。关系 pid_position_translation 的六个主目标亦全部已证，包括两侧正常存在、任意正常结果关系、非空/非零域和精确字节/权限框架。

| 当前问题 | 活跃尝试 | 结果 |
|---|---|---|
| no_error | attempts/002 | 原 Csem 全部可达状态无 source_error |
| termination | attempts/002 | 所有后继 Acc，底层对任意raw args/mem成立 |
| cbmc_recheck | attempts/002 | 124/124原ID逐项证明，无refuted/pending |

数学作者实际 gpt-6.1-sol / ultra，runtime与model config在关系002/evidence，三位作者均由真实session元数据核对。Source/Execution仍是同一原程序、CompCert3.17 x86-64 Linux standard、小端、binary32 RNE，隐藏返回缓冲区 ABI。前条件明确修正位置初始化/安全减法，主 InputPair 域新旧等价。

旧001的 init_mem 求值方法在函数执行前遇到资源限制，不是程序反例；原已检 getter/算术辅助定理仍有效。历史001、旧总报告与成本不改签。此前阶段report/cost/handoff精确快照见 {rel(PUB/'inputs/previous-rocq-stage.json')}。

NoError不是signed-overflow检查的替代。124项包含51overflow、7shift、60pointer、6assertion；控制器/入口绑定真实可达redex，harness按逻辑InputPair与真实局部表达式观察限定，不声称未建模 nondet harness main。当前逐ID映射见 cbmc_recheck/attempts/002/evidence/property-map.json，原align生成gapmap保持历史生成状态。

stateCalcPositionNed_i、stateCalcSpeedNed_i、atan2f仍OPEN，在有效缓存/approx=false已证域内不调用。域外完整外部环境及GCC二进制/硬件等价没有自动获得。继承假设与完整来源/声明hash见各当前goal-validation/provenance。

复跑使用关系002/check.py --cbmc；模型各attempt002/check.py委托该冷构建。费用只按实际共享run/事件归一，不伪分摊：见 costs.json、关系002/costs.json和新总报告 paparazzi/report/pid_position_translation/ultra-retry/report.zh-CN.md。缺GNU回执的完整CPU、并发联合峰值及模型服务器内存保持null，并列已观测指标。
"""
 (CASE/'rocq/report/report.md').write_text(stage_report,encoding='utf-8')
 handoff=read(PUB/'inputs/previous-rocq-stage/handoff.json')
 outputs={}
 for item in handoff['outputs']:
  role=item['role'];path=item['path']
  if role=='relation-proof-attempt':path='../../relations/pid_position_translation/attempts/002/Proof.v'
  if role=='auxiliary-validation':role='historical-auxiliary-validation'
  outputs[role]=CASE/path
 extras={'no-error-proof':CASE/'rocq/no_error/attempts/002/Proof.v','termination-proof':CASE/'rocq/termination/attempts/002/Proof.v','cbmc-recheck-question':CASE/'rocq/cbmc_recheck/problem/Spec.v','cbmc-recheck-proof':CASE/'rocq/cbmc_recheck/attempts/002/Proof.v','spec-map':CASE/'rocq/cbmc_recheck/attempts/002/evidence/property-map.json','recheck-ledger':CASE/'rocq/cbmc_recheck/attempts/002/evidence/recheck-ledger.json','relation-goal-validation':REL/'attempts/002/evidence/goal-validation.json','runtime-config':common_runtime,'model-config':common_model,'legacy-relation-question':REL/'attempts/002/evidence/Spec-original-001.v','precondition-correction':REL/'attempts/002/evidence/precondition-change.json'}
 for name in ['no_error','termination']:
  extras[name+'-goal-validation']=CASE/'rocq'/name/'attempts/002/evidence/goal-validation.json'
 extras['cbmc-kernel-evidence']=CASE/'rocq/cbmc_recheck/attempts/002/evidence/kernel-124-original-model.json'
 extras['cbmc-expected-bindings']=CASE/'rocq/cbmc_recheck/attempts/002/evidence/expected-bindings.json'
 extras['cbmc-artifact-audit']=CASE/'rocq/cbmc_recheck/attempts/002/evidence/validation-status.json'
 outputs.update(extras)
 assert all(p.is_file()for p in outputs.values()),[str(p)for p in outputs.values()if not p.is_file()]
 handoff['status']='proved'
 handoff['outputs']=[{'role':role,'path':rel(path,CASE),'sha256':sha(path)}for role,path in outputs.items()]
 handoff['limitations']=['Conclusions use the explicit current canonical InputGood/InputPair domain; initialized positions and arithmetic conditions are documented and relation-domain equivalence is proved.','Original stateCalcPositionNed_i/stateCalcSpeedNed_i/atan2f bindings remain OPEN and are excluded on the proved cache-valid/approx-false domain; outside-domain full external-environment correspondence is not claimed.','CompCert source semantics and declared local harness observations are proved; this does not automatically establish nondeterministic harness main, GCC binary or hardware equivalence.','Complete tool CPU and concurrent joint memory are unobserved where receipts/sampling are missing; current costs preserve null plus measured subtotal.']
 handoff['artifact_audit']={'mathematical_status':'proved','extra_current_cbmc_certificate_replay':'timeout; not claimed passed','historical_cost_reference_errors':'recorded outside001; no historical bytes changed'}
 handoff['historical_stage_snapshot']=rel(PUB/'inputs/previous-rocq-stage.json')
 write(CASE/'rocq/handoff.json',handoff)
 print(json.dumps({'status':'published','stage_handoff':rel(CASE/'rocq/handoff.json'),'output_count':len(handoff['outputs']),'current_model_problems':['no_error','termination','cbmc_recheck']},indent=2))
if __name__=='__main__':main()
