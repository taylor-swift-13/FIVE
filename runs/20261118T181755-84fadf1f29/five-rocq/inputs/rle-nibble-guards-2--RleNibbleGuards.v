From Stdlib Require Import List ZArith Lia Bool.
From compcert Require Import Coqlib Maps AST Integers Values Memory Events Globalenvs Ctypes Ctypesdefs Cop Csyntax Csem Cexec Smallstep.
Require PprzTrigInit.Source PprzTrigInit.Execution.
From PprzTrigRelationSupport Require Import TrigData TrigTrace TrigEmission InitState InitProtocol InitAssign InitNibble.
From PprzTrigInitSupport Require Import Control PostIncrement IntegerFacts NibbleMachine NibblePrefix.
From PprzTrigCBMC Require Import TypedGuards SourceOccurrence FirstCall NibbleCaller NibbleEntry NibbleGuards.
Import ListNotations.
Local Open Scope Z_scope.
Local Opaque PprzTrigInit.Source.prog source_byte source_nibble.

Definition is_nibble_assignment(a:expr):bool:=match a with
 Eassign _(Ecall(Evalof(Evar id _)_)_ _)_=>Pos.eqb id PprzTrigInit.Source._get_nibble|_=>false end.
Definition source_nibble_assignment(target:ident):expr:=match nibble_statement target with Sdo a=>a|_=>Eval Vundef tint end.
Lemma all_three_original_nibble_calls :
 filter is_nibble_assignment(statement_nodes(fn_body PprzTrigInit.Source.f_pprz_trig_int_init))=
 [source_nibble_assignment PprzTrigInit.Source._temp;source_nibble_assignment PprzTrigInit.Source._k;
  source_nibble_assignment PprzTrigInit.Source._temp].
Proof. reflexivity. Qed.
Definition rle_nibble_site(c:chunk)(offset:Z)(target:ident):Prop:=
 (offset=0 /\target=PprzTrigInit.Source._temp) \/
 (multi c=true /\offset=1 /\target=PprzTrigInit.Source._k) \/
 (multi c=true /\offset=2 /\target=PprzTrigInit.Source._temp).
Lemma all_rle_nibble_site_bounds : forall c offset target,
 In c literal_chunks ->rle_nibble_site c offset target ->
 0<=pos c+offset<3379 /\In target init_local_ids /\target<>PprzTrigInit.Source._i.
Proof.
 intros c offset target IN SITE;pose proof(@literal_chunk_bounds c IN)as BOUNDS.
 repeat match goal with H:_/\_|-_=>destruct H end.
 destruct SITE as[[OFF TARGET]|[[M[OFF TARGET]]|[M[OFF TARGET]]]];subst offset target.
 all:split.
 all:try(unfold consumed in *;try rewrite M in *;try destruct(multi c);lia).
 all:split;[vm_compute;tauto|discriminate].
Qed.

Theorem actual_rle_nibble_caller_guard_coverage : forall e base input buffer m c offset target,
 In c literal_chunks ->rle_nibble_site c offset target ->
 protocol_core e base input buffer m ->short_cell e m PprzTrigInit.Source._i(pos c+offset) ->
 Genv.find_symbol PprzTrigInit.Execution.ge PprzTrigInit.Source._pprz_trig_int_compr=Some input ->
 exists mi bi bt,
 Mem.store Mint16signed m bi 0(Vint(Int.repr(pos c+offset+1)))=Some mi /\
 protocol_core e base input buffer mi /\
 signed32(Int.signed(Int.repr(pos c+offset))+1) /\
 sem_cast(Vint(Int.repr(pos c+offset)))tshort nibble_arg_type mi=Some(Vint(Int.repr(pos c+offset))) /\
 (forall kont,first_call_certificate PprzTrigInit.Execution.ge
   (expected_nibble_call PprzTrigInit.Source.f_pprz_trig_int_init kont e mi target bt(pos c+offset))
   (ExprState PprzTrigInit.Source.f_pprz_trig_int_init(source_nibble_assignment target)kont e m)) /\
 (forall kont,exists trace ce cm bp k,nibble_operand_pc ce cm bp input(pos c+offset) /\
   star Csem.step PprzTrigInit.Execution.ge
    (ExprState PprzTrigInit.Source.f_pprz_trig_int_init(source_nibble_assignment target)kont e m)trace
    (State PprzTrigInit.Source.f_get_nibble(fn_body PprzTrigInit.Source.f_get_nibble)k ce cm)) /\
 (forall kont trace fd args k mc,first_call_prefix PprzTrigInit.Execution.ge
   (ExprState PprzTrigInit.Source.f_pprz_trig_int_init(source_nibble_assignment target)kont e m)trace(Callstate fd args k mc) ->
   exists ce cm bp,nibble_operand_pc ce cm bp input(pos c+offset) /\
   Csem.step PprzTrigInit.Execution.ge(Callstate fd args k mc)E0
    (State PprzTrigInit.Source.f_get_nibble(fn_body PprzTrigInit.Source.f_get_nibble)k ce cm)).
Proof.
 intros e base input buffer m c offset target IN SITE CORE CELL SYMBOL.
 destruct(@all_rle_nibble_site_bounds c offset target IN SITE)as[RANGE[TARGET NE]].
 destruct(@short_store_exists e m PprzTrigInit.Source._i(pos c+offset)(pos c+offset+1)CELL ltac:(lia))
   as[bi[mi[EI[STORE NEW]]]].
 assert(COREI:protocol_core e base input buffer mi)by(eapply protocol_core_local_store;eauto).
 destruct(@core_short_slot e base input buffer mi target COREI TARGET)as[bt[ET WRITABLE]].
 destruct nibble_source_link as[bf[FSYM FFUN]].
 assert(FLOCAL:e!PprzTrigInit.Source._get_nibble=None)by(apply(shape_nibble_unshadowed e base input buffer);exact(pc_shape _ _ _ _ _ CORE)).
 destruct CELL as[bi0[EI0[LOAD PERM]]];assert(bi0=bi)by congruence;subst bi0.
 assert(BYTE:Mem.load Mint8unsigned mi input((pos c+offset)/2)=Some(Vint(Int.repr(source_byte(pos c+offset))))).
 { unfold source_byte;apply(pc_input _ _ _ _ _ COREI);split;[apply Z.div_pos|apply Z.div_lt_upper_bound];lia. }
 destruct(@original_nibble_entry_reaches_operand_pc mi input(pos c+offset)RANGE SYMBOL BYTE)
   as[ce[cm[bp[PC[ENTRY UNIQUE]]]]].
 assert(SHAPE:source_nibble_assignment target=
   nibble_stage_expr 0 0 0 target PprzTrigInit.Source._get_nibble PprzTrigInit.Source._i bt bf bi(pos c+offset))by reflexivity.
 assert(CERT:forall kont,first_call_certificate PprzTrigInit.Execution.ge
   (expected_nibble_call PprzTrigInit.Source.f_pprz_trig_int_init kont e mi target bt(pos c+offset))
   (ExprState PprzTrigInit.Source.f_pprz_trig_int_init(source_nibble_assignment target)kont e m)).
 { intro kont;rewrite SHAPE.
   exact(@nibble_caller_exact_first_call PprzTrigInit.Execution.ge PprzTrigInit.Source.f_pprz_trig_int_init kont e m mi target PprzTrigInit.Source._get_nibble
     PprzTrigInit.Source._i bt bf bi(pos c+offset)RANGE ET EI FLOCAL FSYM FFUN LOAD STORE). }
 exists mi,bi,bt;split;[exact STORE|];split;[exact COREI|];split.
 - apply short_increment_guard;exact(@load_signed16_range m bi 0(Int.repr(pos c+offset))LOAD).
 - split.
   + change(Some(Vint(Int.zero_ext 16(Int.repr(pos c+offset))))=Some(Vint(Int.repr(pos c+offset)))).
     rewrite zero_ext16_repr by lia;reflexivity.
   + split;[exact CERT|];split.
     * intro kont;destruct(@first_call_execution_exists _ _ _(CERT kont))as[trace[next[PATH[t EQ]]]].
       subst next;exists(trace**E0),ce,cm,bp,(Kcall PprzTrigInit.Source.f_pprz_trig_int_init e
       (fun x=>Eassign(nibble_lhs t target bt)x short_type)nibble_return_type kont);split;[exact PC|].
       eapply star_trans;[exact PATH|apply star_one;exact(ENTRY _) |reflexivity].
     * intros kont trace fd args k mc PREFIX.
       pose proof(@every_first_call_covered PprzTrigInit.Execution.ge
         (expected_nibble_call PprzTrigInit.Source.f_pprz_trig_int_init kont e mi target bt(pos c+offset))
         ltac:(intros s[t EQ];subst s;repeat eexists;reflexivity)
         _ trace fd args k mc(CERT kont)PREFIX)as[t EQ].
       inversion EQ;subst fd args mc;exists ce,cm,bp;split;[exact PC|apply ENTRY].
Qed.
