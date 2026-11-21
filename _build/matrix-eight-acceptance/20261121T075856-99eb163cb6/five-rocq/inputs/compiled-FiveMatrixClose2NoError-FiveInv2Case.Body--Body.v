From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Errors Maps Integers Floats AST Values Memory Memdata Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cexec Smallstep.
From FiveGuidanceAllOrder Require Import PureSyntax PureDenotation AtomicDenotation CallfreeExecution BlockExecution PhaseComposition FactorShell.
From FiveMatInv3Case Require Import MatrixMemory.
From FivePprzFloatMatInv2d Require Import Source Execution.
From FiveInv2Case Require Import Contract Expressions BuiltinFabs Certificates.
Import ListNotations.
Local Open Scope Z_scope.
Definition Branch(m:mem)(bo:block)(po:ptrofs)(f:Z->float32)(me:mem):Prop :=
 if Reject f then me=m else Writes m bo(Ptrofs.unsigned po)(Outputs f)me.
Definition fabs_block:block:=match Genv.find_symbol Execution.ge Source.___builtin_fabsf with Some b=>b|None=>1%positive end.
Lemma fabs_symbol:Genv.find_symbol Execution.ge Source.___builtin_fabsf=Some fabs_block.
Proof. vm_compute;reflexivity. Qed.
Lemma fabs_find:Genv.find_funct Execution.ge(Vptr fabs_block Ptrofs.zero)=Some fabs_fd.
Proof. vm_compute;reflexivity. Qed.
Lemma pure_target_eval:forall e m bpo bpi bd bo bi po pi f me mf,
 e!Source._inv_out=Some(bpo,tptr tfloat)->e!Source._mat_in=Some(bpi,tptr tfloat)->e!Source._det=Some(bd,tfloat)->
 Mem.load Mptr m bpo 0=Some(Vptr bo po)->Mem.load Mptr m bpi 0=Some(Vptr bi pi)->Mem.load Mfloat32 m bd 0=Some(Vsingle(Det f))->
 WriteRegion m bo po 4->Reads m bi pi 4 f->bo<>bi->bo<>bpo->bo<>bpi->bo<>bd->Branch m bo po f me->Mem.free_list me(blocks_of_env Execution.ge e)=Some mf->
 state_eval Execution.ge(ExprState Source.f_float_mat_inv_2d(PureGuard f)(Kifthenelse Return1 Sskip(Kseq Suffix Kstop))e m)=Some(Result f,mf).
Proof. intros e m bpo bpi bd bo bi po pi f me mf EO EI ED LO LI LD W RD OI OP OPI OD BR FREE.
 cbn[state_eval];rewrite guard_value,guard_bool;unfold Branch in BR;unfold Result;destruct(Reject f)eqn:RJ.
 - subst me;change((match Mem.free_list m(blocks_of_env Execution.ge e)with Some mm=>Some(Vint Int.one,mm)|None=>None end)=Some(Vint Int.one,mf));rewrite FREE;reflexivity.
 - change((match stmt_eval Execution.ge e tbool Suffix m with Some(out,mm)=>cont_eval Execution.ge e tbool Kstop out mm|None=>None end)=Some(Vint Int.zero,mf));rewrite(suffix_eval e m bpo bpi bd bo bi po pi f me EO EI ED LO LI LD W RD OI OP OPI OD BR);change((match Mem.free_list me(blocks_of_env Execution.ge e)with Some mm=>Some(Vint Int.zero,mm)|None=>None end)=Some(Vint Int.zero,mf));rewrite FREE;reflexivity.
Qed.
Theorem body_certificate:forall e m bpo bpi bd bo bi po pi f md me mf,
 e!Source._inv_out=Some(bpo,tptr tfloat)->e!Source._mat_in=Some(bpi,tptr tfloat)->e!Source._det=Some(bd,tfloat)->e!Source.___builtin_fabsf=None->
 Mem.load Mptr m bpo 0=Some(Vptr bo po)->Mem.load Mptr m bpi 0=Some(Vptr bi pi)->WriteRegion m bo po 4->Reads m bi pi 4 f->
 bo<>bi->bo<>bpo->bo<>bpi->bo<>bd->bi<>bd->bpo<>bd->bpi<>bd->
 Mem.store Mfloat32 m bd 0(Vsingle(Det f))=Some md->Branch md bo po f me->Mem.free_list me(blocks_of_env Execution.ge e)=Some mf->
 exists P,certificate Execution.ge P(Returnstate(Result f)Kstop mf) /\ P(State Source.f_float_mat_inv_2d(fn_body Source.f_float_mat_inv_2d)Kstop e m).
Proof. intros e m bpo bpi bd bo bi po pi f md me mf EO EI ED EG LO LI W RD OI OP OPI OD ID PD PID SD BR FREE.
 assert(LOD:Mem.load Mptr md bpo 0=Some(Vptr bo po))by(erewrite Mem.load_store_other by(exact SD||(left;exact PD));exact LO).
 assert(LID:Mem.load Mptr md bpi 0=Some(Vptr bi pi))by(erewrite Mem.load_store_other by(exact SD||(left;exact PID));exact LI).
 assert(LDD:Mem.load Mfloat32 md bd 0=Some(Vsingle(Det f)))by(erewrite Mem.load_store_same by exact SD;reflexivity).
 assert(WD:WriteRegion md bo po 4)by(eapply writable_store_preserved;eauto).
 assert(RDD:Reads md bi pi 4 f)by(eapply reads_store_preserved;[exact RD|exact ID|exact SD]).
 assert(DA:atomic_eval Execution.ge e m DetAssign=Some(Vsingle(Det f),md))by(eapply determinant_assign;eauto).
 let T:=constr:(ExprState Source.f_float_mat_inv_2d(PureGuard f)(Kifthenelse Return1 Sskip(Kseq Suffix Kstop))e md)in
 assert(QI:Defined Execution.ge(Result f)mf T).
 { unfold Defined;split.
 - vm_compute;reflexivity.
 - split;[exact I|eapply pure_target_eval;eauto]. }
 pose proof(defined_certificate Execution.ge(Result f)mf)as QC.
 pose proof(BuiltinFabs.phase_certificate Execution.ge e Source.f_float_mat_inv_2d(Kseq Suffix Kstop)Return1 Sskip Source.___builtin_fabsf Source._det fabs_block bd(Det f)md EG fabs_symbol fabs_find ED LDD)as FC.
 assert(FQ:Defined Execution.ge(Result f)mf(BuiltinFabs.target e Source.f_float_mat_inv_2d(Kseq Suffix Kstop)Return1 Sskip(Det f)md)).
 { exact QI. }
 pose proof(join_certificate _ _ _ _ _ FC QC FQ)as JC.
 assert(PRE:(fun s=>BuiltinFabs.phase e Source.f_float_mat_inv_2d(Kseq Suffix Kstop)Return1 Sskip Source.___builtin_fabsf Source._det fabs_block bd(Det f)md s\/Defined Execution.ge(Result f)mf s)
 (ExprState Source.f_float_mat_inv_2d(compare_abs CallAbs)(Kifthenelse Return1 Sskip(Kseq Suffix Kstop))e md)).
 { left;left;exists Rvar,Rvar;reflexivity. }
 pose proof(prepend_certificate _ _ _ _ _ (if_unique Execution.ge Source.f_float_mat_inv_2d(compare_abs CallAbs)Return1 Sskip(Kseq Suffix Kstop)e md)JC PRE)as IC.
 let INV:=lazymatch type of IC with certificate _ ?P _=>P end in assert(II:INV(State Source.f_float_mat_inv_2d(Sifthenelse(compare_abs CallAbs)Return1 Sskip)(Kseq Suffix Kstop)e md))by(left;reflexivity).
 pose proof(prepend_certificate _ _ _ _ _ (seq_unique Execution.ge Source.f_float_mat_inv_2d(Sifthenelse(compare_abs CallAbs)Return1 Sskip)Suffix Kstop e md)IC II)as RC.
 let INV:=lazymatch type of RC with certificate _ ?P _=>P end in assert(RI:INV(State Source.f_float_mat_inv_2d Rest Kstop e md))by(left;reflexivity).
 assert(BC:certificate Execution.ge(block_context_invariant Execution.ge(Kseq Rest Kstop)Source.f_float_mat_inv_2d e md)(State Source.f_float_mat_inv_2d Sskip(Kseq Rest Kstop)e md)).
 { split;[exact(block_context_progress Execution.ge(Kseq Rest Kstop)Source.f_float_mat_inv_2d e md)|exact(block_context_all_successors Execution.ge(Kseq Rest Kstop)Source.f_float_mat_inv_2d e md)]. }
 assert(BI:block_context_invariant Execution.ge(Kseq Rest Kstop)Source.f_float_mat_inv_2d e md(State Source.f_float_mat_inv_2d(Sdo DetAssign)(Kseq Rest Kstop)e m)).
 { exists(State Source.f_float_mat_inv_2d(Sdo DetAssign)Kstop e m);split;[reflexivity|];split;[split;[vm_compute;reflexivity|cbn[block_denotation block_eval block_tail];rewrite DA;reflexivity]|split;reflexivity]. }
 pose proof(chain_certificate _ _ _ _ _ _ BC RC(skipseq_unique Execution.ge Source.f_float_mat_inv_2d Rest Kstop e md)RI)as ALL.
 let INV:=lazymatch type of ALL with certificate _ ?P _=>P end in assert(AI:INV(State Source.f_float_mat_inv_2d(Sdo DetAssign)(Kseq Rest Kstop)e m))by(left;exact BI).
 pose proof(prepend_certificate _ _ _ _ _ (seq_unique Execution.ge Source.f_float_mat_inv_2d(Sdo DetAssign)Rest Kstop e m)ALL AI)as FINAL.
 eexists;split;[exact FINAL|rewrite body_syntax;left;reflexivity].
Qed.
Print Assumptions body_certificate.
