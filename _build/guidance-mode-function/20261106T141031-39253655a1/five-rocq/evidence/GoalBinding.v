From Stdlib Require Import List.
From compcert Require Import Maps Values Memory Events Ctypes Csyntax Csyntaxdefs Cstrategy.
From FiveGuidanceEntry Require Import BigstepSupport.
From FiveGuidanceSoftwareProof Require Import FunctionEntry SourceCertificate ValueEvaluator.
Require FiveGhSpeed.Source FiveGhSpeed.Execution FiveGhAccel.Source FiveGhAccel.Execution.
Import ListNotations.
Definition speed_target:forall m x,exists mf,
 Cstrategy.eval_funcall FiveGhSpeed.Execution.ge m(Internal FiveGhSpeed.Source.f_five_sqrtf)[Vsingle x]E0 mf(Vsingle(source_derived_sqrt x)) /\
 access_preserved m mf /\
 (forall ch b ofs,Mem.valid_block m b->Mem.load ch mf b ofs=Mem.load ch m b ofs) /\
 (forall b ofs n,Mem.valid_block m b->Mem.loadbytes mf b ofs n=Mem.loadbytes m b ofs n)
 :=speed_helper_funcall.
Definition accel_target:forall m x,exists mf,
 Cstrategy.eval_funcall FiveGhAccel.Execution.ge m(Internal FiveGhAccel.Source.f_five_sqrtf)[Vsingle x]E0 mf(Vsingle(source_derived_sqrt x)) /\
 access_preserved m mf /\
 (forall ch b ofs,Mem.valid_block m b->Mem.load ch mf b ofs=Mem.load ch m b ofs) /\
 (forall b ofs n,Mem.valid_block m b->Mem.loadbytes mf b ofs n=Mem.loadbytes m b ofs n)
 :=accel_helper_funcall.
Definition total_target:forall x,exists rho,
 value_statement FiveGhSpeed.Source._FiveSqrtBits FiveGhSpeed.Source._f FiveGhSpeed.Source._u helper_types
 (PTree.set FiveGhSpeed.Source._x(Vsingle x)(PTree.empty val))(fn_body FiveGhSpeed.Source.f_five_sqrtf)=
 Some(ValueReturn(Vsingle(source_derived_sqrt x))tfloat rho)
 :=source_derived_sqrt_total.
Print speed_target.
Print accel_target.
Print total_target.
Print Assumptions speed_target.
Print Assumptions accel_target.
Print Assumptions total_target.
