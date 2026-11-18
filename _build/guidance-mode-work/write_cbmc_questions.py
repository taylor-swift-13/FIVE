from pathlib import Path
import json,re
R=Path('/home/yangfp/five');template=(R/'paparazzi/models/gh_update_ref_from_speed_sp/rocq/functional/attempts/001/check.py').read_text()
for entry,ns,manual in [('gh_update_ref_from_speed_sp','FiveGhSpeedCBC','manual_speed'),('gh_update_ref_from_accel_sp','FiveGhAccelCBC','manual_accel')]:
 c=R/'paparazzi/models'/entry;d=c/'rocq/cbmc_recheck';p=d/'problem';a=d/'attempts/001';p.mkdir(parents=True,exist_ok=True);a.mkdir(parents=True,exist_ok=True);rows=json.loads((c/'cbmc/properties.json').read_text());goals=[];lemmas=[];spec=['From FiveGuidanceCbmcAdapters Require Import Adapters.','From FiveGuidanceSoftwareProof Require Import GuardTrace.',''];proof=[f'From {ns} Require Import Spec.','From FiveGuidanceCbmcAdapters Require Import Adapters.','From FiveGuidanceSoftwareProof Require Import GuardTrace.','From Stdlib Require Import Lia.',''];mapping=[];mem=0
 for i,x in enumerate(rows,1):
  pid=x['property'];func=x['sourceLocation']['function'];idx=int(pid.rsplit('.',1)[1]);goal='Goal'+str(i).zfill(3);lemma='goal'+str(i).zfill(3)
  if func=='five_sqrtf':prop=f'GuardTrace.HelperGuard {idx}';thm='GuardTrace.helper_guard_proved';bound=53
  elif func=='memcpy':
   mem+=1;idx=mem;prop=f'Adapters.memcpy_guard_id {idx}';thm='Adapters.memcpy_guards';bound=8
  elif func=='bits':prop=f'Adapters.bits_guard_id {idx}';thm='Adapters.bits_guards';bound=3
  elif func=='gh_saturate_accel':prop=f'Adapters.saturation_pointer_guard_id {idx}';thm='Adapters.saturation_pointer_guards';bound=24
  elif func==entry:prop=f'Adapters.entry_guard_id {idx}';thm='Adapters.entry_guards';bound=4
  elif pid.startswith('main.assertion.'):
   prop=f'Adapters.{manual}_id {idx}';thm=f'Adapters.{manual}_assertions';bound=14
  elif pid.startswith('main.overflow.'):prop=f'Adapters.main_guard_id {idx}';thm='Adapters.main_guards';bound=16
  else:raise RuntimeError(pid)
  goals.append(goal);lemmas.append(lemma);spec += [f'(* Actual CBMC property {pid}: {x["description"]} *)',f'Definition {goal} : Prop := {prop}.']
  proof += [f'Theorem {lemma} : Spec.{goal}.',f'Proof. unfold Spec.{goal}; apply {thm}; lia. Qed.',f'Print Assumptions {lemma}.']
  mapping.append({'property_id':pid,'goal':goal,'proposition':prop,'theorem':ns+'.Proof.'+lemma,'category_theorem':thm,'index':idx,'range':bound})
 (p/'Spec.v').write_text('\n'.join(spec)+'\n');(a/'Proof.v').write_text('\n'.join(proof)+'\n');(p/'status.json').write_text(json.dumps({'schema':'five-proof-problem/1','status':'pending','active_attempt':'../attempts/001','specification':'Spec.v','requested_goals':goals},indent=2)+'\n');(d/'property-map.json').write_text(json.dumps(mapping,indent=2)+'\n')
 (p/'report.md').write_text('# Independent recheck of every actual CBMC property\n\nThe canonical question contains122 individual goals in the exact original CBMC ledger order. Each goal binds one actual assertion or automatic guard to an explicit semantic adapter. Both source helpers and both entry models remain frozen.\n\nThe property input scope is exactly the two nonzero control scenarios in [the CBMC scope](../../../cbmc/report/scope.json), with arbitrary safe signed64 positions and arbitrary bits in six frame float fields. Every manual assertion observes source-ordered position/speed/acceleration bits or complete parameter frame in a real original Csem normal return. Memory/bit adapters formalize valid source/destination objects, actual four-byte representation and distinct-object short circuit. Numeric adapters prove actual conversion and signed arithmetic range conditions independently of Csem no-error. The53 software-helper guards require source-program-point and actual operand trace linkage.\n\n[property-map.json](../property-map.json) gives the exhaustive property ID to goal and category index correspondence. At this authoring checkpoint proofs remain pending until all adapters, exact typed certificates and independent kernels close. Broad natural-domain safety and functionality are separately specified and proved in their own problems.\n')
 s=template.replace('FiveGhSpeedFunctional',ns).replace("names=['NormalCompletion', 'AllReturns']",'names='+repr(goals)).replace("lemmas=['normal_completion', 'all_returns']",'lemmas='+repr(lemmas))
 s=s.replace("'FiveShared':root/'shared'", "'FiveShared':root/'shared','FiveGuidanceCbmcAdapters':root/'paparazzi/relations/guidance_mode/support/cbmc_adapters'")
 # Bind actual property question, harness, scope and full row ledger, in addition to every model input.
 s=s.replace('indexed[str((attempt/"check.py").relative_to(root))]=digest(attempt/"check.py")', 'for rel in ("cbmc/harness.c","cbmc/properties.json","cbmc/report/scope.json","rocq/cbmc_recheck/property-map.json"):\n  p=case/rel;indexed[str(p.relative_to(root))]=digest(p)\n indexed[str((attempt/"check.py").relative_to(root))]=digest(attempt/"check.py")')
 (a/'check.py').write_text(s)
 print(entry,'122 canonical goals and explicit wrappers authored; pending adapter closure')
