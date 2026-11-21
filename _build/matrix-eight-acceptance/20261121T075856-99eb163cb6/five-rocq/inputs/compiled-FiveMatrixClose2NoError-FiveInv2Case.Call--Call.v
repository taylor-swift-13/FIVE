From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Errors Maps Integers Floats AST Values Memory Memdata Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cexec Smallstep.
From FiveShared.verification Require Import Obligations.
From FiveGuidanceAllOrder Require Import PureDenotation CallfreeExecution PhaseComposition.
From FiveGuidanceAllocation Require Import StackAllocation.
From FiveGuidanceEntry Require Import StackCleanup FunctionAllocation.
From FiveMatInv3Case Require Import MatrixMemory.
From FivePprzFloatMatInv2d Require Import Source Execution.
From FiveInv2Case Require Import Contract Expressions Body MemoryEffects Certificates Closure.
Import ListNotations.
Local Open Scope Z_scope.
Definition declares:=fn_params Source.f_float_mat_inv_2d++fn_vars Source.f_float_mat_inv_2d.
Lemma declares_nodup:NoDup(map fst declares).
Proof. vm_compute;repeat constructor;simpl;intuition discriminate. Qed.
Theorem call_certificate:forall m bo bi po pi f,Inputs m bo bi po pi f->
 exists mf P,certificate Execution.ge P(Returnstate(Result f)Kstop mf)/\P(Execution.entry(Args bo bi po pi)m)/\Post m mf bo bi po pi f.
Proof. intros m bo bi po pi f[OI[W RD]].
 pose proof(writable_valid m bo po 4 ltac:(lia)W)as VO.
 pose proof(reads_valid m bi pi 4 f ltac:(lia)RD)as VI.
 destruct(Cexec.do_alloc_variables Execution.ge empty_env m declares)as[e ma]eqn:ALLOC.
 assert(AV:alloc_variables Execution.ge empty_env m declares e ma)by(pose proof(Cexec.do_alloc_variables_sound Execution.ge declares empty_env m)as H;rewrite ALLOC in H;exact H).
 assert(ALL:forall id ty,In(id,ty)declares->exists bx,e!id=Some(bx,ty)/\~Mem.valid_block m bx/\Mem.range_perm ma bx 0(sizeof Execution.ge ty)Cur Freeable).
 { intros id ty IX;pose proof(allocated_variable Execution.ge declares empty_env m id ty declares_nodup IX)as H;rewrite ALLOC in H;destruct H as(bx&L&F&V&P);exists bx;auto. }
 destruct(ALL Source._inv_out(tptr tfloat)ltac:(left;reflexivity))as[bpo[EO[FO PO]]].
 destruct(ALL Source._mat_in(tptr tfloat)ltac:(right;left;reflexivity))as[bpi[EI[FI PI]]].
 destruct(ALL Source._det tfloat ltac:(right;right;left;reflexivity))as[bd[ED[FD PD]]].
 assert(SEP:env_separated e)by(pose proof(allocation_env_separated Execution.ge declares empty_env m ltac:(intros id bx ty H;discriminate H)ltac:(intros id1 id2 bx t1 t2 H;discriminate H))as H;rewrite ALLOC in H;exact H).
 assert(OUTENV:forall q,Mem.valid_block m q->forall id ty,e!id=Some(q,ty)->False).
 { intros q V id ty LOOK;destruct(ALL id ty(allocated_environment_origin Execution.ge declares m e ma AV id q ty LOOK))as(bx&LOOK'&F&Q);rewrite LOOK in LOOK';injection LOOK' as EQ;subst bx;exact(F V). }
 assert(OP:bpo<>bpi)by(intro EQ;subst bpo;pose proof(SEP _ _ _ _ _ EO EI);discriminate).
 assert(OD:bpo<>bd)by(intro EQ;subst bpo;pose proof(SEP _ _ _ _ _ EO ED);discriminate).
 assert(ID:bpi<>bd)by(intro EQ;subst bpi;pose proof(SEP _ _ _ _ _ EI ED);discriminate).
 assert(EG:e!Source.___builtin_fabsf=None).
 { destruct(e!Source.___builtin_fabsf)as[[bx ty]|]eqn:LOOK;auto;exfalso.
 pose proof(allocated_environment_origin Execution.ge declares m e ma AV Source.___builtin_fabsf bx ty LOOK)as IN.
 cbn[declares fn_params fn_vars Source.f_float_mat_inv_2d]in IN;repeat destruct IN as[EQ|IN];try contradiction;inversion EQ. }
 assert(WO:Mem.valid_access ma Mptr bpo 0 Writable).
 { apply Mem.valid_access_freeable_any;split;[intros ofs Q;apply PO;change(0<=ofs<8);exact Q|exists 0;lia]. }
 destruct(Mem.valid_access_store ma Mptr bpo 0(Vptr bo po)WO)as[mb SO].
 assert(WI:Mem.valid_access mb Mptr bpi 0 Writable).
 { eapply Mem.store_valid_access_1;[exact SO|];apply Mem.valid_access_freeable_any;split;[intros ofs Q;apply PI;change(0<=ofs<8);exact Q|exists 0;lia]. }
 destruct(Mem.valid_access_store mb Mptr bpi 0(Vptr bi pi)WI)as[mc SI].
 assert(BIND:bind_parameters Execution.ge e ma(fn_params Source.f_float_mat_inv_2d)(Args bo bi po pi)mc).
 { eapply bind_parameters_cons;[exact EO| |].
 - eapply assign_loc_value;[reflexivity|reflexivity|];unfold Mem.storev;rewrite Ptrofs.unsigned_zero;rewrite zle_true by(change(8<=18446744073709551616);lia);exact SO.
 - eapply bind_parameters_cons;[exact EI| |constructor].
   eapply assign_loc_value;[reflexivity|reflexivity|];unfold Mem.storev;rewrite Ptrofs.unsigned_zero;rewrite zle_true by(change(8<=18446744073709551616);lia);exact SI. }
 assert(LO:Mem.load Mptr mc bpo 0=Some(Vptr bo po))by(erewrite Mem.load_store_other by(exact SI||(left;exact OP));erewrite Mem.load_store_same by exact SO;reflexivity).
 assert(LI:Mem.load Mptr mc bpi 0=Some(Vptr bi pi))by(erewrite Mem.load_store_same by exact SI;reflexivity).
 assert(WA:WriteRegion ma bo po 4).
 { destruct W as[AL[NW RP]];repeat split;auto;intros z B;pose proof(allocation_perm Execution.ge declares empty_env m bo z Cur Writable(RP z B))as H;rewrite ALLOC in H;exact H. }
 assert(WC:WriteRegion mc bo po 4)by(eapply writable_store_preserved;[|exact SI];eapply writable_store_preserved;[exact WA|exact SO]).
 assert(RA:Reads ma bi pi 4 f).
 { destruct RD as[AL[NW L]];repeat split;auto;intros i B;pose proof(allocation_load Execution.ge declares empty_env m Mfloat32 bi(Ptrofs.unsigned pi+4*i)(Vsingle(f i))(L i B))as H;rewrite ALLOC in H;exact H. }
 assert(RC:Reads mc bi pi 4 f).
 { eapply reads_store_preserved;[| |exact SI];[|intro EQ;subst bpi;exact(FI VI)].
 eapply reads_store_preserved;[exact RA| |exact SO];intro EQ;subst bpo;exact(FO VI). }
 assert(WD:Mem.valid_access mc Mfloat32 bd 0 Writable).
 { eapply Mem.store_valid_access_1;[exact SI|];eapply Mem.store_valid_access_1;[exact SO|];apply Mem.valid_access_freeable_any;split;[intros ofs Q;apply PD;change(0<=ofs<4);exact Q|exists 0;lia]. }
 destruct(Mem.valid_access_store mc Mfloat32 bd 0(Vsingle(Det f))WD)as[md SD].
 assert(WDD:WriteRegion md bo po 4)by(eapply writable_store_preserved;eauto).
 assert(EX:exists me,Branch md bo po f me).
 { unfold Branch;destruct(Reject f);[exists md;reflexivity|destruct(writes_exist(Outputs f)md bo po 4 WDD(output_bounds f))as[me ST];exists me;exact ST]. }
 destruct EX as[me BR].
 assert(FREER:forall id bx ty,e!id=Some(bx,ty)->Mem.range_perm me bx 0(sizeof Execution.ge ty)Cur Freeable).
 { intros id bx ty LOOK;destruct(ALL id ty(allocated_environment_origin Execution.ge declares m e ma AV id bx ty LOOK))as(bx'&LOOK'&F&Q);rewrite LOOK in LOOK';injection LOOK' as EQ;subst bx'.
 intros ofs RANGE;eapply branch_permissions;[exact BR|];eapply Mem.perm_store_1;[exact SD|];eapply Mem.perm_store_1;[exact SI|];eapply Mem.perm_store_1;[exact SO|];apply Q;exact RANGE. }
 destruct(free_environment Execution.ge e me SEP FREER)as[mf[FREE[KEEP ACCESS]]].
 destruct(body_certificate e mc bpo bpi bd bo bi po pi f md me mf EO EI ED EG LO LI WC RC OI ltac:(intro EQ;subst bpo;exact(FO VO))ltac:(intro EQ;subst bpi;exact(FI VO))ltac:(intro EQ;subst bd;exact(FD VO))ltac:(intro EQ;subst bd;exact(FD VI))OD ID SD BR FREE)as[P[PC PE]].
 assert(SB:Cexec.sem_bind_parameters Execution.ge quiet_world e ma(fn_params Source.f_float_mat_inv_2d)(Args bo bi po pi)=Some mc)by(apply Cexec.sem_bind_parameters_complete;exact BIND).
 assert(ND:list_norepet(var_names(fn_params Source.f_float_mat_inv_2d)++var_names(fn_vars Source.f_float_mat_inv_2d)))by(vm_compute;repeat constructor;simpl;intuition discriminate).
 pose proof(internal_unique Execution.ge Source.f_float_mat_inv_2d(Args bo bi po pi)m e ma mc ND ALLOC SB)as ENTRY.
 pose proof(prepend_certificate _ _ _ _ _ ENTRY PC PE)as CERT.
 assert(PREBYTES:forall q z n,Mem.valid_block m q->Mem.loadbytes md q z n=Mem.loadbytes m q z n).
 { intros q z n VQ;erewrite Mem.loadbytes_store_other by(exact SD||(left;intro EQ;subst q;exact(FD VQ))).
 erewrite Mem.loadbytes_store_other by(exact SI||(left;intro EQ;subst q;exact(FI VQ))).
 erewrite Mem.loadbytes_store_other by(exact SO||(left;intro EQ;subst q;exact(FO VQ))).
 pose proof(allocation_bytes_frame Execution.ge declares empty_env m q z n VQ)as H;rewrite ALLOC in H;exact H. }
 assert(RDD:Reads md bi pi 4 f)by(eapply reads_store_preserved;[exact RC| |exact SD];intro EQ;subst bd;exact(FD VI)).
 assert(RME:Reads me bi pi 4 f)by(eapply branch_reads;[exact BR|exact RDD|congruence]).
 exists mf; eexists;split;[exact CERT|];split;[left;reflexivity|].
 unfold Post;split.
 - pose proof(branch_writable md bo po f me BR WDD)as[AL[NW RP]];split;[exact AL|];split;[exact NW|].
 eapply range_perm_access_preserved_block;[|exact RP];intros ch ofs perm VA;apply(ACCESS ch bo ofs perm(OUTENV bo VO));exact VA.
 - split.
 + destruct RME as[AL[NW L]];repeat split;auto;intros i B;rewrite(KEEP Mfloat32 bi(Ptrofs.unsigned pi+4*i)(OUTENV bi VI));apply L;exact B.
 + split.
 * intros q z n VQ OUT;erewrite free_environment_bytes_frame by(exact FREE||exact(OUTENV q VQ));rewrite(branch_frame md bo po f me BR q z n OUT);apply PREBYTES;exact VQ.
 * split.
 -- intros q VQ;eapply free_list_valid;[exact FREE|];eapply branch_valid;[exact BR|];eapply Mem.store_valid_block_1;[exact SD|];eapply Mem.store_valid_block_1;[exact SI|];eapply Mem.store_valid_block_1;[exact SO|].
 pose proof(allocation_valid_block Execution.ge declares empty_env m q VQ)as H;rewrite ALLOC in H;exact H.
 -- split.
 ++ erewrite free_environment_bytes_frame by(exact FREE||exact(OUTENV bo VO));rewrite(branch_bytes md bo po f me BR);destruct(Reject f);[apply PREBYTES;exact VO|reflexivity].
 ++ intros ch q z perm VQ VA;apply(ACCESS ch q z perm(OUTENV q VQ));eapply branch_access;[exact BR|];eapply Mem.store_valid_access_1;[exact SD|];eapply Mem.store_valid_access_1;[exact SI|];eapply Mem.store_valid_access_1;[exact SO|].
 pose proof(allocation_access Execution.ge declares empty_env m ch q z perm VA)as H;rewrite ALLOC in H;exact H.
Qed.
Theorem call_summary:forall m bo bi po pi f,Inputs m bo bi po pi f->exists mf,
 (exists t,star Csem.step Execution.ge(Execution.entry(Args bo bi po pi)m)t(Returnstate(Result f)Kstop mf))/\Post m mf bo bi po pi f/\
 no_error Execution.ge(Execution.entry(Args bo bi po pi)m)/\
 (forall t result after,star Csem.step Execution.ge(Execution.entry(Args bo bi po pi)m)t(Returnstate result Kstop after)->result=Result f/\after=mf).
Proof. intros m bo bi po pi f IN;destruct(call_certificate m bo bi po pi f IN)as[mf[P[CERT[PI POST]]]].
 exists mf;split;[eapply accessible_certificate_reaches;[exact CERT|exact PI|apply Closure.all_successor_termination]|].
 split;[exact POST|];split;[eapply certificate_safety;eauto|eapply certificate_normal_unique;eauto]. Qed.
Print Assumptions call_certificate.
Print Assumptions call_summary.
