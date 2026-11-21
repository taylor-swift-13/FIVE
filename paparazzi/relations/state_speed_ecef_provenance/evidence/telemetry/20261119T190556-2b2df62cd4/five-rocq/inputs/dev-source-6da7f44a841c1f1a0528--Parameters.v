From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib AST Integers Values Memory Events Globalenvs Maps Ctypes Cop Csyntax Csyntaxdefs Csem Cexec Smallstep.
From FiveGuidanceAllOrder Require Import PhaseComposition.
From FiveGuidanceAllocation Require Import StackAllocation.
From FiveGuidanceEntry Require Import StackCleanup.
From StateSpeedSetterSupport Require Import MemoryFacts StoreEffects FreeFrame.
From StateSpeedSetNedISupport Require Import Setup.
Import ListNotations.
Open Scope Z_scope.
Local Opaque ge E.ge.

Definition parameter_env(bi bp:block):env:=
 PTree.set S._ned_speed(bp,tptr vtype)(PTree.set S._id(bi,tushort)empty_env).
Lemma parameter_lookups:forall bi bp,
 (parameter_env bi bp)!S._id=Some(bi,tushort) /\
 (parameter_env bi bp)!S._ned_speed=Some(bp,tptr vtype) /\
 (parameter_env bi bp)!S._state=None.
Proof. intros;repeat split;reflexivity. Qed.
Definition ParameterTrace(m:mem)(id:int)(src:block)(e:env)(m0:mem)(bi bp:block):Prop:=
 exists mA mB mid,
 Mem.alloc m 0 2=(mA,bi) /\Mem.alloc mA 0 8=(mB,bp) /\
 Mem.store Mint16unsigned mB bi 0(Vint id)=Some mid /\
 Mem.store Mptr mid bp 0(Vptr src Ptrofs.zero)=Some m0 /\e=parameter_env bi bp.
Lemma freeable_writable:forall m ch b ofs,
 Mem.valid_access m ch b ofs Freeable ->Mem.valid_access m ch b ofs Writable.
Proof.
 intros m ch b ofs[P A];split;[|exact A].
 intros i I;eapply Mem.perm_implies;[apply P;exact I|constructor].
Qed.
Theorem parameters_exist:forall m id src,
 exists e m0 bi bp,ParameterTrace m id src e m0 bi bp /\
 Mem.valid_access m0 Mint16unsigned bi 0 Freeable /\
 Mem.valid_access m0 Mptr bp 0 Freeable /\bi<>bp /\
 Mem.load Mptr m0 bp 0=Some(Vptr src Ptrofs.zero).
Proof.
 intros m id src.
 destruct(Mem.alloc m 0 2)as[mA bi]eqn:A.
 destruct(Mem.alloc mA 0 8)as[mB bp]eqn:B.
 assert(WI:Mem.valid_access mB Mint16unsigned bi 0 Freeable).
 { eapply Mem.valid_access_alloc_other;[exact B|].
   eapply Mem.valid_access_alloc_same;[exact A|lia|cbn;lia|exists 0;reflexivity]. }
 assert(WP:Mem.valid_access mB Mptr bp 0 Freeable).
 { eapply Mem.valid_access_alloc_same;[exact B|lia|change(0+8<=8);lia|exists 0;reflexivity]. }
 destruct(Mem.valid_access_store mB Mint16unsigned bi 0(Vint id)(freeable_writable _ _ _ _ WI))as[mid ID].
 assert(WPM:Mem.valid_access mid Mptr bp 0 Freeable)by(eapply Mem.store_valid_access_1;[exact ID|exact WP]).
 destruct(Mem.valid_access_store mid Mptr bp 0(Vptr src Ptrofs.zero)(freeable_writable _ _ _ _ WPM))as[m0 PTR].
 exists(parameter_env bi bp),m0,bi,bp;split.
 - exists mA,mB,mid;auto.
 - split.
   + eapply Mem.store_valid_access_1;[exact PTR|];eapply Mem.store_valid_access_1;[exact ID|exact WI].
   + split;[eapply Mem.store_valid_access_1;[exact PTR|exact WPM]|].
     split.
     * intro EQ;pose proof(Mem.valid_new_block _ _ _ _ _ A)as V;rewrite EQ in V.
       exact(Mem.fresh_block_alloc _ _ _ _ _ B V).
     * exact(Mem.load_store_same _ _ _ _ _ _ PTR).
Qed.

Section FRAME.
Variables m:mem.
Variables id:int.
Variables src:block.
Variables e:env.
Variables m0:mem.
Variables bi bp:block.
Variable TRACE:ParameterTrace m id src e m0 bi bp.
Lemma parameter_distinct:bi<>bp.
Proof.
 destruct TRACE as(mA&mB&mid&A&B&ID&PTR&ENV);intro EQ.
 pose proof(Mem.valid_new_block _ _ _ _ _ A)as V;rewrite EQ in V.
 exact(Mem.fresh_block_alloc _ _ _ _ _ B V).
Qed.
Lemma parameter_bindings:forall key b ty,e!key=Some(b,ty) ->
 (key=S._id /\b=bi /\ty=tushort) \/(key=S._ned_speed /\b=bp /\ty=tptr vtype).
Proof.
 intros key b ty LOOK;destruct TRACE as(mA&mB&mid&A&B&ID&PTR&ENV);subst e.
 unfold parameter_env in LOOK;rewrite PTree.gsspec in LOOK.
 destruct(peq key S._ned_speed)as[EQ|NE].
 - subst key;injection LOOK as B0 T0;subst b ty;auto.
 - rewrite PTree.gsspec in LOOK;destruct(peq key S._id)as[EQ|NE2].
   + subst key;injection LOOK as B0 T0;subst b ty;auto.
   + rewrite PTree.gempty in LOOK;discriminate.
Qed.
Lemma parameter_fresh:forall b,Mem.valid_block m b ->b<>bi /\b<>bp.
Proof.
 intros b V;destruct TRACE as(mA&mB&mid&A&B&ID&PTR&ENV);split.
 - intro EQ;subst b;exact(Mem.fresh_block_alloc _ _ _ _ _ A V).
 - intro EQ;subst b;apply(Mem.fresh_block_alloc _ _ _ _ _ B).
   eapply Mem.valid_block_alloc;[exact A|exact V].
Qed.
Lemma parameter_load_frame:forall ch b ofs,Mem.valid_block m b ->Mem.load ch m0 b ofs=Mem.load ch m b ofs.
Proof.
 intros ch b ofs V;destruct(parameter_fresh b V)as[BI BP].
 destruct TRACE as(mA&mB&mid&A&B&ID&PTR&ENV).
 erewrite Mem.load_store_other;[|exact PTR|left;exact BP].
 erewrite Mem.load_store_other;[|exact ID|left;exact BI].
 erewrite Mem.load_alloc_unchanged;[|exact B|eapply Mem.valid_block_alloc;[exact A|exact V]].
 eapply Mem.load_alloc_unchanged;[exact A|exact V].
Qed.
Lemma parameter_bytes_frame:forall b ofs n,Mem.valid_block m b ->Mem.loadbytes m0 b ofs n=Mem.loadbytes m b ofs n.
Proof.
 intros b ofs n V;destruct(parameter_fresh b V)as[BI BP].
 destruct TRACE as(mA&mB&mid&A&B&ID&PTR&ENV).
 erewrite Mem.loadbytes_store_other;[|exact PTR|left;exact BP].
 erewrite Mem.loadbytes_store_other;[|exact ID|left;exact BI].
 erewrite Mem.loadbytes_alloc_unchanged;[|exact B|eapply Mem.valid_block_alloc;[exact A|exact V]].
 eapply Mem.loadbytes_alloc_unchanged;[exact A|exact V].
Qed.
Lemma parameter_permissions:forall b ofs k p,Mem.valid_block m b ->(Mem.perm m b ofs k p<->Mem.perm m0 b ofs k p).
Proof.
 intros b ofs k p V;destruct(parameter_fresh b V)as[BI BP].
 destruct TRACE as(mA&mB&mid&A&B&ID&PTR&ENV);split;intro PERM.
 - eapply Mem.perm_store_1;[exact PTR|];eapply Mem.perm_store_1;[exact ID|].
   eapply Mem.perm_alloc_1;[exact B|];eapply Mem.perm_alloc_1;[exact A|exact PERM].
 - eapply Mem.perm_alloc_4;[exact A| |exact BI].
   eapply Mem.perm_alloc_4;[exact B| |exact BP].
   eapply Mem.perm_store_2;[exact ID|].
   eapply Mem.perm_store_2;[exact PTR|exact PERM].
Qed.
Lemma parameter_semantics:
 exists ma,alloc_variables ge empty_env m(fn_params f++fn_vars f)e ma /\
 bind_parameters ge e ma(fn_params f)(Args id src)m0.
Proof.
 destruct TRACE as(mA&mB&mid&A&B&ID&PTR&ENV);subst e.
 destruct(parameter_lookups bi bp)as[LI[LP LG]].
 exists mB;split.
 - change(alloc_variables ge empty_env m[(S._id,tushort);(S._ned_speed,tptr vtype)](parameter_env bi bp)mB).
   eapply alloc_variables_cons;[exact A|];eapply alloc_variables_cons;[exact B|constructor].
 - change(bind_parameters ge(parameter_env bi bp)mB[(S._id,tushort);(S._ned_speed,tptr vtype)](Args id src)m0).
   eapply bind_parameters_cons with(m1:=mid);[exact LI| |].
   + eapply assign_loc_value;[reflexivity|reflexivity|].
     unfold Mem.storev;rewrite Ptrofs.unsigned_zero;rewrite zle_true by(change(2<=18446744073709551616);lia);exact ID.
   + eapply bind_parameters_cons with(m1:=m0);[exact LP| |constructor].
     eapply assign_loc_value;[reflexivity|reflexivity|].
     unfold Mem.storev;rewrite Ptrofs.unsigned_zero;rewrite zle_true by(change(8<=18446744073709551616);lia);exact PTR.
Qed.
Lemma parameter_step:unique_transition ge(E.entry(Args id src)m)(State f(fn_body f)Kstop e m0).
Proof.
 destruct parameter_semantics as[ma[ALLOC BIND]].
 pose proof(Cexec.do_alloc_variables_complete _ _ _ _ _ _ ALLOC)as AC.
 pose proof(Cexec.sem_bind_parameters_complete ge E.quiet_world _ _ _ _ _ BIND)as BC.
 split.
 - right;eapply step_internal_function;[|exact ALLOC|exact BIND].
   change(list_norepet[S._id;S._ned_speed]);repeat constructor;simpl;intuition discriminate.
 - clear ALLOC BIND;intros t next[ES|SS];[inversion ES|].
   inversion SS;subst. Show.
   match goal with A2:alloc_variables _ _ _ _ _ _|-_=>
    pose proof(Cexec.do_alloc_variables_complete _ _ _ _ _ _ A2)as A2C;
    rewrite AC in A2C;injection A2C as EE MM;subst end.
   match goal with B2:bind_parameters _ _ _ _ _ _|-_=>
    pose proof(Cexec.sem_bind_parameters_complete ge E.quiet_world _ _ _ _ _ B2)as B2C;
    rewrite BC in B2C;injection B2C as MF;subst end.
   split;reflexivity.
Qed.
Lemma parameter_input_good:forall sb x y z,InputGood m sb src id x y z ->InputGood m0 sb src id x y z.
Proof.
 intros sb x y z GOOD;destruct GOOD as[SYMBOL W FILTER SEP[RX[RY RZ]]].
 assert(VS:Mem.valid_block m sb)by(eapply range_valid;[lia|exact W]).
 assert(VI:Mem.valid_block m src)by(eapply loaded_valid;exact RX).
 constructor.
 - exact SYMBOL.
 - intros ofs R;apply(proj1(parameter_permissions sb ofs Cur Writable VS));apply W;exact R.
 - rewrite(parameter_load_frame Mint16unsigned sb 282 VS);exact FILTER.
 - exact SEP.
 - unfold VecRead;repeat split;rewrite parameter_load_frame by exact VI;assumption.
Qed.
Lemma parameter_old_outside:forall b,Mem.valid_block m b ->forall key ty,e!key=Some(b,ty)->False.
Proof.
 intros b V key ty LOOK;destruct(parameter_fresh b V)as[BI BP].
 destruct(parameter_bindings key b ty LOOK)as[_[EQ _]|_[EQ _]];contradiction.
Qed.
Lemma release_parameters:forall mb,
 Mem.valid_access mb Mint16unsigned bi 0 Freeable ->Mem.valid_access mb Mptr bp 0 Freeable ->
 exists mf,Mem.free_list mb(blocks_of_env ge e)=Some mf /\
 (forall ch b ofs,Mem.valid_block m b ->Mem.load ch mf b ofs=Mem.load ch mb b ofs) /\
 (forall b ofs n,Mem.valid_block m b ->Mem.loadbytes mf b ofs n=Mem.loadbytes mb b ofs n) /\
 (forall b ofs k p,Mem.valid_block m b ->(Mem.perm mb b ofs k p<->Mem.perm mf b ofs k p)).
Proof.
 intros mb WI WP.
 assert(SEP:env_separated e).
 { intros key1 key2 b ty1 ty2 L1 L2.
   destruct(parameter_bindings key1 b ty1 L1)as[A[B C]|[A[B C]]];
   destruct(parameter_bindings key2 b ty2 L2)as[D[E F]|[D[E F]]];
   subst;try reflexivity;exfalso;apply parameter_distinct;congruence. }
 destruct(free_environment ge e mb SEP)as[mf[FREE[LOAD ACCESS]]].
 - intros key b ty LOOK;destruct(parameter_bindings key b ty LOOK)as[A[B C]|[A[B C]]];subst b ty.
   + exact(proj1 WI).
   + exact(proj1 WP).
 - exists mf;split;[exact FREE|];split.
   + intros ch b ofs VB;apply LOAD;apply parameter_old_outside;exact VB.
   + split.
     * intros b ofs n VB;apply(free_environment_bytes_frame ge e mb mf FREE);apply parameter_old_outside;exact VB.
     * intros b ofs k p VB;apply(free_environment_permissions ge e mb mf FREE);apply parameter_old_outside;exact VB.
Qed.
End FRAME.
Print Assumptions parameters_exist.
Print Assumptions parameter_step.
