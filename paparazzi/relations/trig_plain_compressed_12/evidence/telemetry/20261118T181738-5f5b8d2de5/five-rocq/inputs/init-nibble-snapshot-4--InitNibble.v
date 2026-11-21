From Stdlib Require Import List ZArith Lia Bool.
From compcert Require Import Coqlib Maps AST Integers Values Memory Ctypes Ctypesdefs Cop Csyntax Csem Globalenvs.
Require PprzTrigInit.Source PprzTrigInit.Execution.
From PprzTrigRelationSupport Require Import Total InitState InitProtocol InitAssign PackedPrefix LowDispatcher.
From PprzTrigInitSupport Require Import Frame PostIncrement NibbleMachine NibbleStatement NibblePrefix.
Import ListNotations.
Local Open Scope Z_scope.
Local Opaque PprzTrigInit.Source.prog source_nibble.
Lemma short_cell_old_frame : forall e m mf id z,
 short_cell e m id z ->Mem.unchanged_on(fun b _=>Mem.valid_block m b)m mf ->short_cell e mf id z.
Proof.
 intros e m mf id z[b[B[L R]]]F. exists b;split;[exact B|]. split.
 - eapply Mem.load_unchanged_on;[exact F| |exact L]. intros ofs IN.
   exact(Mem.perm_valid_block m b 0 Cur Writable(R 0 ltac:(lia))).
 - intros ofs IN;eapply Mem.perm_unchanged_on;[exact F| |apply R;exact IN].
   exact(Mem.perm_valid_block m b ofs Cur Writable(R ofs IN)).
Qed.
Lemma packed_prefix_old_frame : forall p m mf b,
 packed_prefix p m b ->Mem.unchanged_on(fun b _=>Mem.valid_block m b)m mf ->packed_prefix p mf b.
Proof.
 intros p m mf b[R L]F;split.
 - intros ofs IN;eapply Mem.perm_unchanged_on;[exact F| |apply R;exact IN].
   exact(Mem.perm_valid_block m b ofs Cur Writable(R ofs IN)).
 - intros i IN;eapply Mem.load_unchanged_on;[exact F| |apply L;exact IN]. intros ofs I.
   exact(Mem.perm_valid_block m b i Cur Writable(R i IN)).
Qed.
Lemma core_old_frame : forall e base input buffer m mf,
 protocol_core e base input buffer m ->Mem.unchanged_on(fun b _=>Mem.valid_block m b)m mf ->protocol_core e base input buffer mf.
Proof.
 intros e base input buffer m mf C F;eapply protocol_core_frame;[exact C|].
 eapply Mem.unchanged_on_implies;[exact F|]. intros b ofs[V N]OLD;exact V.
Qed.
Lemma nibble_source_link : exists b,
 Genv.find_symbol PprzTrigInit.Execution.ge PprzTrigInit.Source._get_nibble=Some b /\
 Genv.find_funct PprzTrigInit.Execution.ge(Vptr b Ptrofs.zero)=Some(Internal PprzTrigInit.Source.f_get_nibble).
Proof. apply(source_function_link PprzTrigInit.Source.prog PprzTrigInit.Source._get_nibble PprzTrigInit.Source.f_get_nibble);vm_compute;reflexivity. Qed.
Lemma shape_nibble_unshadowed : forall e base input buffer,
 init_shape e base input buffer ->e!PprzTrigInit.Source._get_nibble=None.
Proof.
 intros e base input buffer S. destruct(e!PprzTrigInit.Source._get_nibble)as[[b ty]|]eqn:B;[|reflexivity].
 destruct(sh_domain _ _ _ _ S _ _ _ B)as[IN TY]. vm_compute in IN;intuition discriminate.
Qed.
Definition nibble_statement(target:ident):statement :=Sdo
 (Eassign(Evar target tshort)
 (Ecall(Evalof(Evar PprzTrigInit.Source._get_nibble nibble_fun_type)nibble_fun_type)
 (Econs(Epostincr Incr(Evar PprzTrigInit.Source._i tshort)tshort)Enil)nibble_return_type)tshort).
Theorem nibble_protocol_action : forall Q f k e base input buffer prefix m target p,
 protocol_core e base input buffer m ->packed_prefix prefix m buffer ->
 short_cell e m PprzTrigInit.Source._i p ->0<=p<3379 ->In target init_local_ids ->target<>PprzTrigInit.Source._i ->
 Genv.find_symbol PprzTrigInit.Execution.ge PprzTrigInit.Source._pprz_trig_int_compr=Some input ->
 (forall mf,protocol_core e base input buffer mf /\packed_prefix prefix mf buffer /\
 short_cell e mf PprzTrigInit.Source._i(p+1) /\short_cell e mf target(source_nibble p) /\
 (forall id old,id<>PprzTrigInit.Source._i->id<>target->short_cell e m id old->short_cell e mf id old) ->
 Total.total PprzTrigInit.Execution.ge Q(State f Sskip k e mf)) ->
 Total.total PprzTrigInit.Execution.ge Q(State f(nibble_statement target)k e m).
Proof.
 intros Q f k e base input buffer prefix m target p C P IC RANGE TARGET NE INPUT END.
 destruct(short_store_exists _ _ _ _ (p+1) IC ltac:(lia))as[bi[mi[EI[INCR NEWI]]]].
 assert(CI:protocol_core e base input buffer mi)by(eapply protocol_core_local_store;eauto).
 assert(PI:packed_prefix prefix mi buffer).
 { eapply packed_prefix_local_store;[exact P|eapply shape_local_not_buffer;[exact(pc_shape _ _ _ _ _ C)|exact EI]|exact INCR]. }
 destruct(core_short_slot _ _ _ _ _ target CI TARGET)as[bt[ET WT]].
 destruct(nibble_source_link)as[bf[SYMBOL FUNCTION]].
 assert(UNSHADOW:e!PprzTrigInit.Source._get_nibble=None)by(eapply shape_nibble_unshadowed;exact(pc_shape _ _ _ _ _ CI)).
 assert(BYTE:Mem.load Mint8unsigned mi input(p/2)=Some(Vint(Int.repr(source_byte p)))).
 { unfold source_byte;apply(pc_input _ _ _ _ _ CI);split;[apply Z.div_pos;lia|apply Z.div_lt_upper_bound;lia]. }
 destruct IC as[bi0[EI0[LOAD PERM]]]. assert(EQ:bi0=bi)by congruence;subst bi0.
 destruct(nibble_assignment_statement e m mi target PprzTrigInit.Source._get_nibble PprzTrigInit.Source._i bt bf bi input p
 RANGE ET EI UNSHADOW SYMBOL FUNCTION INPUT LOAD INCR WT BYTE)as[mc[mf[FRAME[STORE EXEC]]]].
 assert(CC:protocol_core e base input buffer mc)by(eapply core_old_frame;eauto).
 assert(PC:packed_prefix prefix mc buffer)by(eapply packed_prefix_old_frame;eauto).
 assert(ICI:short_cell e mc PprzTrigInit.Source._i(p+1))by(eapply short_cell_old_frame;eauto).
 assert(CF:protocol_core e base input buffer mf)by(eapply protocol_core_local_store;eauto).
 assert(PF:packed_prefix prefix mf buffer).
 { eapply packed_prefix_local_store;[exact PC|eapply shape_local_not_buffer;[exact(pc_shape _ _ _ _ _ CC)|exact ET]|exact STORE]. }
 assert(ICF:short_cell e mf PprzTrigInit.Source._i(p+1)).
 { eapply short_cell_store_other;[exact ICI|exact STORE|]. intros b B.
   eapply sh_injective;[exact(pc_shape _ _ _ _ _ CC)|exact B|exact ET|congruence]. }
 assert(TF:short_cell e mf target(source_nibble p)).
 { exists bt;split;[exact ET|]. split.
   - pose proof(Mem.load_store_same _ _ _ _ _ _ STORE)as L;cbn[Val.load_result]in L.
     destruct(machine_nibble_literal p RANGE)as[_[BOUND _]]. rewrite nonnegative_short_cast in L by lia;exact L.
   - intros ofs IN;eapply Mem.perm_store_1;[exact STORE|]. eapply Mem.perm_unchanged_on;[exact FRAME| |apply WT;exact IN].
     exact(Mem.perm_valid_block mi bt ofs Cur Writable(WT ofs IN)). }
 unfold nibble_statement;change(Total.total PprzTrigInit.Execution.ge Q
 (State f(Sdo(nibble_stage_expr 0 0 0 target PprzTrigInit.Source._get_nibble PprzTrigInit.Source._i bt bf bi p))k e m)).
 apply EXEC;apply END;split;[exact CF|]. split;[exact PF|]. split;[exact ICF|]. split;[exact TF|].
 intros id old NI NT CELL.
 eapply short_cell_store_other;[|exact STORE|].
 - eapply short_cell_old_frame;[|exact FRAME]. eapply short_cell_store_other;[exact CELL|exact INCR|].
   intros b B;eapply sh_injective;[exact(pc_shape _ _ _ _ _ C)|exact B|exact EI|exact NI].
 - intros b B;eapply sh_injective;[exact(pc_shape _ _ _ _ _ CC)|exact B|exact ET|exact NT].
Qed.
Print Assumptions nibble_protocol_action.
