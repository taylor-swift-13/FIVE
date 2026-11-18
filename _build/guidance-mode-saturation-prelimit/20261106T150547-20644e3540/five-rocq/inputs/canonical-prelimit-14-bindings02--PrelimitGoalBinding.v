From Stdlib Require Import List ZArith.
From compcert Require Import Coqlib Maps Integers Floats AST Values Memory Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Smallstep.
From FiveGuidanceEntry Require Import Entry BigstepSupport.
From FiveGuidanceAllOrder Require Import PhaseComposition.
From FiveGuidanceCbmcAdapters Require Import CallScope SaturationPrelimit SaturationCallScope.
Import ListNotations.
Local Open Scope Z_scope.
Module Speed.
Module S:=FiveGhSpeed.Source.
Module P:=FiveGuidanceEntry.SymbolicPrefix.
Module B:=FiveGuidanceEntry.SaturationBody.
Import P B.
Import SaturationPrelimit.Speed.
Definition saturation_to_factor_target:forall m ba bc a maximum k,
 Genv.find_symbol ge S._gh_max_accel=Some bc->
 Mem.load Mfloat32 m bc 0=Some(Vsingle maximum)->
 Mem.load Mfloat32 m ba 0=Some(Vsingle(vx a))->Mem.load Mfloat32 m ba 4=Some(Vsingle(vy a))->
 Mem.valid_access m Mfloat32 ba 0 Writable->Mem.valid_access m Mfloat32 ba 4 Writable->
 saturation_branch maximum a=true->
 exists e mnorm bp bn bf,
 local_point e mnorm bp bn bf ba bc a maximum /\
 star Csem.step ge(Callstate(Internal S.f_gh_saturate_accel)[Vptr ba Ptrofs.zero]k m)E0(factor_state e mnorm k)
 :=SaturationPrelimit.Speed.saturation_to_factor.
Print Assumptions saturation_to_factor_target.
Definition saturation_to_sqrt_target:forall m ba bc a maximum k,
 Genv.find_symbol ge S._gh_max_accel=Some bc->
 Mem.load Mfloat32 m bc 0=Some(Vsingle maximum)->
 Mem.load Mfloat32 m ba 0=Some(Vsingle(vx a))->Mem.load Mfloat32 m ba 4=Some(Vsingle(vy a))->
 Mem.valid_access m Mfloat32 ba 0 Writable->Mem.valid_access m Mfloat32 ba 4 Writable->
 saturation_branch maximum a=true->
 exists e mnorm bp bn bf kc,
 local_point e mnorm bp bn bf ba bc a maximum /\
 star Csem.step ge(Callstate(Internal S.f_gh_saturate_accel)[Vptr ba Ptrofs.zero]k m)E0
 (Callstate(Internal S.f_five_sqrtf)[Vsingle(norm2 a)]kc mnorm)
 :=SaturationPrelimit.Speed.saturation_to_sqrt.
Print Assumptions saturation_to_sqrt_target.
Definition unsaturated_to_skip_target:forall m ba bc a maximum k,
 Genv.find_symbol ge S._gh_max_accel=Some bc->
 Mem.load Mfloat32 m bc 0=Some(Vsingle maximum)->
 Mem.load Mfloat32 m ba 0=Some(Vsingle(vx a))->Mem.load Mfloat32 m ba 4=Some(Vsingle(vy a))->
 Mem.valid_access m Mfloat32 ba 0 Writable->Mem.valid_access m Mfloat32 ba 4 Writable->
 saturation_branch maximum a=false->
 exists e mnorm bp bn bf,
 local_point e mnorm bp bn bf ba bc a maximum /\
 star Csem.step ge(Callstate(Internal S.f_gh_saturate_accel)[Vptr ba Ptrofs.zero]k m)E0
 (State S.f_gh_saturate_accel Sskip k e mnorm)
 :=SaturationPrelimit.Speed.unsaturated_to_skip.
Print Assumptions unsaturated_to_skip_target.
Definition unsaturated_returns_target:forall m ba bc a maximum k,
 Genv.find_symbol ge S._gh_max_accel=Some bc->
 Mem.load Mfloat32 m bc 0=Some(Vsingle maximum)->
 Mem.load Mfloat32 m ba 0=Some(Vsingle(vx a))->Mem.load Mfloat32 m ba 4=Some(Vsingle(vy a))->
 Mem.valid_access m Mfloat32 ba 0 Writable->Mem.valid_access m Mfloat32 ba 4 Writable->
 saturation_branch maximum a=false->is_call_cont k->
 exists mf,star Csem.step ge(Callstate(Internal S.f_gh_saturate_accel)[Vptr ba Ptrofs.zero]k m)E0(Returnstate Vundef k mf)
 :=SaturationPrelimit.Speed.unsaturated_returns.
Print Assumptions unsaturated_returns_target.
Definition saturation_funcall_guard_certificate_target:forall m ba bc a maximum k,
 is_call_cont k ->
 sqrt_call_contract ->Genv.find_symbol ge S._gh_max_accel=Some bc ->
 Mem.load Mfloat32 m bc 0=Some(Vsingle maximum) ->
 Mem.load Mfloat32 m ba 0=Some(Vsingle(vx a)) ->Mem.load Mfloat32 m ba 4=Some(Vsingle(vy a)) ->
 Mem.valid_access m Mfloat32 ba 0 Writable ->Mem.valid_access m Mfloat32 ba 4 Writable ->
 exists mf P,certificate ge P(Returnstate Vundef k mf) /\
 P(Callstate(Internal S.f_gh_saturate_accel)[Vptr ba Ptrofs.zero]k m) /\
 (forall s,P s->helper_call_ok S.f_five_sqrtf(norm2 a)(saturation_branch maximum a)s) /\
 Mem.load Mfloat32 mf ba 0=Some(Vsingle(vx(saturate maximum a))) /\
 Mem.load Mfloat32 mf ba 4=Some(Vsingle(vy(saturate maximum a))) /\
 access_preserved m mf /\
 (forall ch b ofs,Mem.valid_block m b ->b<>ba ->Mem.load ch mf b ofs=Mem.load ch m b ofs) /\
 (forall b ofs nbytes,Mem.valid_block m b ->b<>ba ->Mem.loadbytes mf b ofs nbytes=Mem.loadbytes m b ofs nbytes)
 :=SaturationCallScope.Speed.saturation_funcall_guard_certificate.
Print Assumptions saturation_funcall_guard_certificate_target.
Definition helper_argument_scope_target:forall m ba bc a maximum k,
 is_call_cont k->Genv.find_symbol ge S._gh_max_accel=Some bc->
 Mem.load Mfloat32 m bc 0=Some(Vsingle maximum)->
 Mem.load Mfloat32 m ba 0=Some(Vsingle(vx a))->Mem.load Mfloat32 m ba 4=Some(Vsingle(vy a))->
 Mem.valid_access m Mfloat32 ba 0 Writable->Mem.valid_access m Mfloat32 ba 4 Writable->
 forall t args kc mc,
 bounded_star ge k(Callstate(Internal S.f_gh_saturate_accel)[Vptr ba Ptrofs.zero]k m)t
 (Callstate(Internal S.f_five_sqrtf)args kc mc)->
 saturation_branch maximum a=true /\args=[Vsingle(norm2 a)]
 :=SaturationCallScope.Speed.helper_argument_scope.
Print Assumptions helper_argument_scope_target.
Definition unsaturated_no_helper_call_target:forall m ba bc a maximum k,
 is_call_cont k->Genv.find_symbol ge S._gh_max_accel=Some bc->
 Mem.load Mfloat32 m bc 0=Some(Vsingle maximum)->
 Mem.load Mfloat32 m ba 0=Some(Vsingle(vx a))->Mem.load Mfloat32 m ba 4=Some(Vsingle(vy a))->
 Mem.valid_access m Mfloat32 ba 0 Writable->Mem.valid_access m Mfloat32 ba 4 Writable->
 saturation_branch maximum a=false->forall t args kc mc,
 ~bounded_star ge k(Callstate(Internal S.f_gh_saturate_accel)[Vptr ba Ptrofs.zero]k m)t
 (Callstate(Internal S.f_five_sqrtf)args kc mc)
 :=SaturationCallScope.Speed.unsaturated_no_helper_call.
Print Assumptions unsaturated_no_helper_call_target.
End Speed.
Module Accel.
Module S:=FiveGhAccel.Source.
Module P:=FiveGuidanceEntry.AccelPrefix.
Module B:=FiveGuidanceEntry.SaturationBodyAccel.
Import P B.
Import SaturationPrelimit.Accel.
Definition saturation_to_factor_target:forall m ba bc a maximum k,
 Genv.find_symbol ge S._gh_max_accel=Some bc->
 Mem.load Mfloat32 m bc 0=Some(Vsingle maximum)->
 Mem.load Mfloat32 m ba 0=Some(Vsingle(vx a))->Mem.load Mfloat32 m ba 4=Some(Vsingle(vy a))->
 Mem.valid_access m Mfloat32 ba 0 Writable->Mem.valid_access m Mfloat32 ba 4 Writable->
 saturation_branch maximum a=true->
 exists e mnorm bp bn bf,
 local_point e mnorm bp bn bf ba bc a maximum /\
 star Csem.step ge(Callstate(Internal S.f_gh_saturate_accel)[Vptr ba Ptrofs.zero]k m)E0(factor_state e mnorm k)
 :=SaturationPrelimit.Accel.saturation_to_factor.
Print Assumptions saturation_to_factor_target.
Definition saturation_to_sqrt_target:forall m ba bc a maximum k,
 Genv.find_symbol ge S._gh_max_accel=Some bc->
 Mem.load Mfloat32 m bc 0=Some(Vsingle maximum)->
 Mem.load Mfloat32 m ba 0=Some(Vsingle(vx a))->Mem.load Mfloat32 m ba 4=Some(Vsingle(vy a))->
 Mem.valid_access m Mfloat32 ba 0 Writable->Mem.valid_access m Mfloat32 ba 4 Writable->
 saturation_branch maximum a=true->
 exists e mnorm bp bn bf kc,
 local_point e mnorm bp bn bf ba bc a maximum /\
 star Csem.step ge(Callstate(Internal S.f_gh_saturate_accel)[Vptr ba Ptrofs.zero]k m)E0
 (Callstate(Internal S.f_five_sqrtf)[Vsingle(norm2 a)]kc mnorm)
 :=SaturationPrelimit.Accel.saturation_to_sqrt.
Print Assumptions saturation_to_sqrt_target.
Definition unsaturated_to_skip_target:forall m ba bc a maximum k,
 Genv.find_symbol ge S._gh_max_accel=Some bc->
 Mem.load Mfloat32 m bc 0=Some(Vsingle maximum)->
 Mem.load Mfloat32 m ba 0=Some(Vsingle(vx a))->Mem.load Mfloat32 m ba 4=Some(Vsingle(vy a))->
 Mem.valid_access m Mfloat32 ba 0 Writable->Mem.valid_access m Mfloat32 ba 4 Writable->
 saturation_branch maximum a=false->
 exists e mnorm bp bn bf,
 local_point e mnorm bp bn bf ba bc a maximum /\
 star Csem.step ge(Callstate(Internal S.f_gh_saturate_accel)[Vptr ba Ptrofs.zero]k m)E0
 (State S.f_gh_saturate_accel Sskip k e mnorm)
 :=SaturationPrelimit.Accel.unsaturated_to_skip.
Print Assumptions unsaturated_to_skip_target.
Definition unsaturated_returns_target:forall m ba bc a maximum k,
 Genv.find_symbol ge S._gh_max_accel=Some bc->
 Mem.load Mfloat32 m bc 0=Some(Vsingle maximum)->
 Mem.load Mfloat32 m ba 0=Some(Vsingle(vx a))->Mem.load Mfloat32 m ba 4=Some(Vsingle(vy a))->
 Mem.valid_access m Mfloat32 ba 0 Writable->Mem.valid_access m Mfloat32 ba 4 Writable->
 saturation_branch maximum a=false->is_call_cont k->
 exists mf,star Csem.step ge(Callstate(Internal S.f_gh_saturate_accel)[Vptr ba Ptrofs.zero]k m)E0(Returnstate Vundef k mf)
 :=SaturationPrelimit.Accel.unsaturated_returns.
Print Assumptions unsaturated_returns_target.
Definition saturation_funcall_guard_certificate_target:forall m ba bc a maximum k,
 is_call_cont k ->
 sqrt_call_contract ->Genv.find_symbol ge S._gh_max_accel=Some bc ->
 Mem.load Mfloat32 m bc 0=Some(Vsingle maximum) ->
 Mem.load Mfloat32 m ba 0=Some(Vsingle(vx a)) ->Mem.load Mfloat32 m ba 4=Some(Vsingle(vy a)) ->
 Mem.valid_access m Mfloat32 ba 0 Writable ->Mem.valid_access m Mfloat32 ba 4 Writable ->
 exists mf P,certificate ge P(Returnstate Vundef k mf) /\
 P(Callstate(Internal S.f_gh_saturate_accel)[Vptr ba Ptrofs.zero]k m) /\
 (forall s,P s->helper_call_ok S.f_five_sqrtf(norm2 a)(saturation_branch maximum a)s) /\
 Mem.load Mfloat32 mf ba 0=Some(Vsingle(vx(saturate maximum a))) /\
 Mem.load Mfloat32 mf ba 4=Some(Vsingle(vy(saturate maximum a))) /\
 access_preserved m mf /\
 (forall ch b ofs,Mem.valid_block m b ->b<>ba ->Mem.load ch mf b ofs=Mem.load ch m b ofs) /\
 (forall b ofs nbytes,Mem.valid_block m b ->b<>ba ->Mem.loadbytes mf b ofs nbytes=Mem.loadbytes m b ofs nbytes)
 :=SaturationCallScope.Accel.saturation_funcall_guard_certificate.
Print Assumptions saturation_funcall_guard_certificate_target.
Definition helper_argument_scope_target:forall m ba bc a maximum k,
 is_call_cont k->Genv.find_symbol ge S._gh_max_accel=Some bc->
 Mem.load Mfloat32 m bc 0=Some(Vsingle maximum)->
 Mem.load Mfloat32 m ba 0=Some(Vsingle(vx a))->Mem.load Mfloat32 m ba 4=Some(Vsingle(vy a))->
 Mem.valid_access m Mfloat32 ba 0 Writable->Mem.valid_access m Mfloat32 ba 4 Writable->
 forall t args kc mc,
 bounded_star ge k(Callstate(Internal S.f_gh_saturate_accel)[Vptr ba Ptrofs.zero]k m)t
 (Callstate(Internal S.f_five_sqrtf)args kc mc)->
 saturation_branch maximum a=true /\args=[Vsingle(norm2 a)]
 :=SaturationCallScope.Accel.helper_argument_scope.
Print Assumptions helper_argument_scope_target.
Definition unsaturated_no_helper_call_target:forall m ba bc a maximum k,
 is_call_cont k->Genv.find_symbol ge S._gh_max_accel=Some bc->
 Mem.load Mfloat32 m bc 0=Some(Vsingle maximum)->
 Mem.load Mfloat32 m ba 0=Some(Vsingle(vx a))->Mem.load Mfloat32 m ba 4=Some(Vsingle(vy a))->
 Mem.valid_access m Mfloat32 ba 0 Writable->Mem.valid_access m Mfloat32 ba 4 Writable->
 saturation_branch maximum a=false->forall t args kc mc,
 ~bounded_star ge k(Callstate(Internal S.f_gh_saturate_accel)[Vptr ba Ptrofs.zero]k m)t
 (Callstate(Internal S.f_five_sqrtf)args kc mc)
 :=SaturationCallScope.Accel.unsaturated_no_helper_call.
Print Assumptions unsaturated_no_helper_call_target.
End Accel.
