From Stdlib Require Import List ZArith.
From compcert Require Import Integers Floats Values Memory Events Csem Smallstep.
From FiveMatInv3Case Require Import MatrixMemory.
From FivePprzFloatMatInv2d Require Import Execution.
From FiveInv2Case Require Import Contract Call RecheckSupport TraceInputs.
From FiveMatrixInverseSupport Require Import Kernels.
Import ListNotations.
Local Open Scope Z_scope.
Definition NormalCall(m:mem)(bo bi:block)(po pi:ptrofs)(f:Z->float32)(mf:mem):Prop:=exists t,star Csem.step Execution.ge(Execution.entry(Args bo bi po pi)m)t(Returnstate(Result f)Kstop mf).
Record Separate(og ig ob ib os is0 ol il:block):Prop:={
 sep_bg:ob<>og;sep_big:ib<>og;sep_sg:os<>og;sep_sig:is0<>og;sep_lg:ol<>og;sep_lig:il<>og;
 sep_sb:os<>ob;sep_sib:is0<>ob;sep_lb:ol<>ob;sep_lib:il<>ob;sep_ls:ol<>os;sep_lis:il<>os
}.
Definition OriginalReplay:Prop:=forall m og ig ob ib os is0 ol il,
 Inputs m og ig(Ptrofs.repr 4)Ptrofs.zero trace_input->
 Inputs m ob ib Ptrofs.zero Ptrofs.zero base2->
 Inputs m os is0 Ptrofs.zero Ptrofs.zero small2->
 Inputs m ol il Ptrofs.zero Ptrofs.zero large2->Separate og ig ob ib os is0 ol il->
 exists ma mb mc md,
 NormalCall m og ig(Ptrofs.repr 4)Ptrofs.zero trace_input ma/\Post m ma og ig(Ptrofs.repr 4)Ptrofs.zero trace_input/\
 NormalCall ma ob ib Ptrofs.zero Ptrofs.zero base2 mb/\Post ma mb ob ib Ptrofs.zero Ptrofs.zero base2/\
 NormalCall mb os is0 Ptrofs.zero Ptrofs.zero small2 mc/\Post mb mc os is0 Ptrofs.zero Ptrofs.zero small2/\
 NormalCall mc ol il Ptrofs.zero Ptrofs.zero large2 md/\Post mc md ol il Ptrofs.zero Ptrofs.zero large2.
Theorem original_trace_four_calls:OriginalReplay.
Proof. intros m og ig ob ib os is0 ol il IG IB IS IL SEP;destruct SEP.
 destruct(call_summary m og ig(Ptrofs.repr 4)Ptrofs.zero trace_input IG)as[ma[PG[QG OTHERG]]].
 assert(IBA:Inputs ma ob ib Ptrofs.zero Ptrofs.zero base2)by(eapply post_preserves_other_inputs;eauto).
 assert(ISA:Inputs ma os is0 Ptrofs.zero Ptrofs.zero small2)by(eapply post_preserves_other_inputs;eauto).
 assert(ILA:Inputs ma ol il Ptrofs.zero Ptrofs.zero large2)by(eapply post_preserves_other_inputs;eauto).
 destruct(call_summary ma ob ib Ptrofs.zero Ptrofs.zero base2 IBA)as[mb[PB[QB OTHERB]]].
 assert(ISB:Inputs mb os is0 Ptrofs.zero Ptrofs.zero small2)by(eapply post_preserves_other_inputs;eauto).
 assert(ILB:Inputs mb ol il Ptrofs.zero Ptrofs.zero large2)by(eapply post_preserves_other_inputs;eauto).
 destruct(call_summary mb os is0 Ptrofs.zero Ptrofs.zero small2 ISB)as[mc[PS[QS OTHERS]]].
 assert(ILC:Inputs mc ol il Ptrofs.zero Ptrofs.zero large2)by(eapply post_preserves_other_inputs;eauto).
 destruct(call_summary mc ol il Ptrofs.zero Ptrofs.zero large2 ILC)as[md[PL[QL OTHERL]]].
 exists ma,mb,mc,md;unfold NormalCall;split;[exact PG|];split;[exact QG|];split;[exact PB|];split;[exact QB|];split;[exact PS|];split;[exact QS|];split;[exact PL|exact QL].
Qed.
Theorem original_trace_statuses:Result trace_input=Vint Int.zero/\Result base2=Vint Int.zero/\Result small2=Vint Int.one/\Result large2=Vint Int.zero.
Proof. split;[exact(proj1 original_arbitrary_trace_kernel)|];split;[exact(proj1 base2_kernel)|];split;[exact(proj1 small2_kernel)|exact(proj1 large2_kernel)]. Qed.
Theorem original_trace_scale_failure:OriginalReplay /\ Result base2<>Result small2.
Proof. split;[exact original_trace_four_calls|exact RefuteScaleStatus2]. Qed.
Theorem original_trace_residual_failure:OriginalReplay /\ Result large2=Vint Int.zero /\ SmallResidual(residual2 large2)=false /\ Float32.to_bits(residual2 large2)=Int.repr 3212836864.
Proof. split;[exact original_trace_four_calls|];destruct RefuteLargeResidual2 as[RET BAD];split;[exact RET|];split;[exact BAD|exact large2_residual]. Qed.
Print Assumptions original_trace_four_calls.
Print Assumptions original_trace_scale_failure.
Print Assumptions original_trace_residual_failure.
