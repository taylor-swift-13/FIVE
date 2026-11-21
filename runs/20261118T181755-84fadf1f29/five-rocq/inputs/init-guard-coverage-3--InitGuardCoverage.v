From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Maps Integers AST Values Memory Events Globalenvs Determinism Ctypes Ctypesdefs Cop Csyntax Csem Cexec Cstrategy.
Require PprzTrigInit.Source.
From PprzTrigRelationSupport Require Import InitState InitLoop InitProtocol PackedPrefix PlainCore PureEval Total.
From PprzTrigInitSupport Require Import PostIncrement Control.
From PprzTrigCBMC Require Import TypedGuards SourceOccurrence.
Import ListNotations.
Local Open Scope Z_scope.
Local Opaque PprzTrigInit.Source.prog.

Lemma csem_short_read_unique : forall ge m b z t v,
 Mem.load Mint16signed m b 0=Some(Vint(Int.repr z)) ->
 Csem.deref_loc ge tshort m b Ptrofs.zero Full t v ->t=E0 /\v=Vint(Int.repr z).
Proof.
 intros ge m b z t v LOAD READ.
 pose proof(@deref_loc_silent ge tshort m b Ptrofs.zero Full t v eq_refl READ)as TRACE;subst t.
 pose proof(@Cexec.do_deref_loc_complete ge PureEval.quiet_world tshort m b Ptrofs.zero Full
   PureEval.quiet_world E0 v READ(possible_trace_nil _))as ACTUAL.
 pose proof(@PostIncrement.short_deref ge PureEval.quiet_world m b z LOAD)as EXPECTED.
 change(Cexec.do_deref_loc ge PureEval.quiet_world tshort m b Ptrofs.zero Full=
   Some(PureEval.quiet_world,E0,Vint(Int.repr z)))in EXPECTED.
 rewrite EXPECTED in ACTUAL;inversion ACTUAL;split;reflexivity.
Qed.

Definition expanded_short_increment(b:block)(old:Int.int):expr:=
 Ecomma(Eassign(Eloc b Ptrofs.zero Full tshort)
   (Ebinop Oadd(Eval(Vint old)tshort)(Eval(Vint Int.one)type_int32s)(incrdecr_type tshort))tshort)
   (Eval(Vint old)tshort)tshort.

Lemma actual_postincrement_head_observations : forall ge m b z,
 Mem.load Mint16signed m b 0=Some(Vint(Int.repr z)) ->
 signed32(Int.signed(Int.repr z)+1) /\
 Csem.rred ge(Epostincr Incr(Eloc b Ptrofs.zero Full tshort)tshort)m E0
   (expanded_short_increment b(Int.repr z))m /\
 (forall t next mf,Csem.rred ge(Epostincr Incr(Eloc b Ptrofs.zero Full tshort)tshort)m t next mf ->
   t=E0 /\next=expanded_short_increment b(Int.repr z) /\mf=m).
Proof.
 intros ge m b z LOAD;split.
 - apply short_increment_guard;exact(@load_signed16_range m b 0(Int.repr z)LOAD).
 - split.
   + unfold expanded_short_increment;eapply Csem.red_postincr;[|reflexivity].
     eapply Csem.deref_loc_value with(chunk:=Mint16signed);try reflexivity.
     cbn[Mem.loadv size_chunk];rewrite Ptrofs.unsigned_zero,LOAD,zle_true by(change(2<=18446744073709551616);lia);reflexivity.
   + intros t next mf RED;inversion RED;subst.
     match goal with D:Csem.deref_loc ?GE tshort ?MM ?BB Ptrofs.zero Full ?T ?V|-_=>
       destruct(@csem_short_read_unique GE MM BB z T V LOAD D)as[TRACE VALUE];subst T V end.
     repeat split;reflexivity.
Qed.

Theorem initializer_postincrement_guard_coverage : forall e m id z,
 In(source_short_increment id)actual_init_increment_nodes ->
 short_cell e m id z ->0<=z<16383 ->
 exists b mf,
 e!id=Some(b,tshort) /\
 Cexec.do_deref_loc(Csem.globalenv PprzTrigInit.Source.prog)PureEval.quiet_world tshort m b Ptrofs.zero Full=
   Some(PureEval.quiet_world,E0,Vint(Int.repr z)) /\
 signed32(Int.signed(Int.repr z)+1) /\
 (forall t next mx,Csem.rred(Csem.globalenv PprzTrigInit.Source.prog)
   (Epostincr Incr(Eloc b Ptrofs.zero Full tshort)tshort)m t next mx ->
   t=E0 /\next=expanded_short_increment b(Int.repr z) /\mx=m) /\
 short_cell e mf id(z+1) /\
 (forall Q f k,Total.total(Csem.globalenv PprzTrigInit.Source.prog)Q(State f Sskip k e mf)->
 Total.total(Csem.globalenv PprzTrigInit.Source.prog)Q(State f(Sdo(source_short_increment id))k e m)).
Proof.
 intros e m id z ORIGIN CELL RANGE.
 destruct(@PostIncrement.postincrement_short_cell e m id z CELL RANGE)as[b[mf[ENV[STORE[NEW ALL]]]]].
 destruct CELL as[bc[ENV0[LOAD PERM]]]. assert(bc=b)by congruence;subst bc.
 destruct(@actual_postincrement_head_observations(Csem.globalenv PprzTrigInit.Source.prog)m b z LOAD)
   as[GUARD[EXISTS COVERAGE]].
 exists b,mf;split;[exact ENV|];split.
 - exact(@PostIncrement.short_deref(Csem.globalenv PprzTrigInit.Source.prog)PureEval.quiet_world m b z LOAD).
 - split;[exact GUARD|];split;[exact COVERAGE|];split;[exact NEW|].
   intros Q f k END;exact(ALL(Csem.globalenv PprzTrigInit.Source.prog)Q f k END).
Qed.

Theorem protocol_short_operand_exists : forall e base input buffer m id z,
 protocol_core e base input buffer m ->short_cell e m id z ->
 exists value,
 value=Int.repr z /\
 pure_rval(Csem.globalenv PprzTrigInit.Source.prog)e m(Evalof(Evar id tshort)tshort)=Some(Vint value) /\
 signed16(Int.signed value).
Proof.
 intros e base input buffer m id z CORE CELL;exists(Int.repr z);split;[reflexivity|];split.
 - exact(@short_read_value(Csem.globalenv PprzTrigInit.Source.prog)e m id z CELL).
 - destruct CELL as[b[LOOK[LOAD PERM]]];exact(@load_signed16_range m b 0(Int.repr z)LOAD).
Qed.
