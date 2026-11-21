From Stdlib Require Import Bool List ZArith Lia.
From compcert Require Import Coqlib Maps Integers AST Values Memory Events Globalenvs Ctypes Cop Csyntax Csem Cexec.
Require PprzTrigInit.Source.
From PprzTrigRelationSupport Require Import PlainCore Total PureEval.
From PprzTrigInitSupport Require Import Control PostIncrement IntegerFacts NibbleMachine NibbleCall NibblePrefix.
Import ListNotations.
Local Open Scope Z_scope.
Local Opaque PprzTrigInit.Source.prog source_byte source_nibble.

Theorem nibble_assignment_statement : forall e m mi tempid funid iid bt bf bi bc p,
 0<=p<3379 ->
 e!tempid=Some(bt,short_type) ->e!iid=Some(bi,short_type) ->e!funid=None ->
 Genv.find_symbol (Csem.globalenv PprzTrigInit.Source.prog) funid=Some bf ->
 Genv.find_funct (Csem.globalenv PprzTrigInit.Source.prog)(Vptr bf Ptrofs.zero)=Some(Internal PprzTrigInit.Source.f_get_nibble) ->
 Genv.find_symbol (Csem.globalenv PprzTrigInit.Source.prog) PprzTrigInit.Source._pprz_trig_int_compr=Some bc ->
 Mem.load Mint16signed m bi 0=Some(Vint(Int.repr p)) ->
 Mem.store Mint16signed m bi 0(Vint(Int.repr(p+1)))=Some mi ->
 Mem.range_perm mi bt 0 2 Cur Writable ->
 Mem.load Mint8unsigned mi bc(p/2)=Some(Vint(Int.repr(source_byte p))) ->
 exists mc mf,
 Mem.unchanged_on(fun b _=>Mem.valid_block mi b)mi mc /\
 Mem.store Mint16signed mc bt 0(Vint(Int.repr(source_nibble p)))=Some mf /\
 (forall Q caller k,
 Total.total (Csem.globalenv PprzTrigInit.Source.prog)Q(State caller Sskip k e mf) ->
 Total.total (Csem.globalenv PprzTrigInit.Source.prog)Q
  (State caller(Sdo(nibble_stage_expr 0 0 0 tempid funid iid bt bf bi p))k e m)).
Proof.
 intros e m mi tempid funid iid bt bf bi bc p RANGE ET EI EF SYMBOL FUNCTION COMPR LOAD INCR PERM BYTE.
 destruct(get_nibble_source_call mi bc p RANGE COMPR BYTE)as[mc[FRAME CALL]].
 assert(OLD:Mem.valid_block mi bt).
 { eapply Mem.perm_valid_block;apply PERM;lia. }
 assert(WRITE:Mem.valid_access mc Mint16signed bt 0 Writable).
 { split.
   - intros ofs IN;eapply Mem.perm_unchanged_on;[exact FRAME|exact OLD|apply PERM;exact IN].
   - change(2|0);exists 0;reflexivity. }
 destruct(Mem.valid_access_store mc Mint16signed bt 0(Vint(Int.repr(source_nibble p)))WRITE)as[mf STORE].
 assert(CAST:sem_cast(Vint(Int.repr(source_nibble p)))nibble_return_type short_type mc=Some(Vint(Int.repr(source_nibble p)))).
 { change(Some(Vint(Int.sign_ext 16(Int.repr(source_nibble p))))=Some(Vint(Int.repr(source_nibble p)))).
   destruct(machine_nibble_literal p RANGE)as[_[BOUND _]].
   rewrite nonnegative_short_cast by lia;reflexivity. }
 pose proof(short_assign (Csem.globalenv PprzTrigInit.Source.prog)PureEval.quiet_world mc bt(source_nibble p)mf STORE)as ASSIGN.
 exists mc,mf;split;[exact FRAME|].split;[exact STORE|].
 intros Q caller k END.
 apply Control.do_total.
 eapply nibble_assignment_prefix_total;try eassumption.
 intros t;apply CALL.
 cbn[call_cont].
 apply Control.return_to_caller_total.
 eapply Total.flat_prefix_total with(v:=Vint(Int.repr(source_nibble p)))(mf:=mf).
 - destruct t;vm_compute;reflexivity.
 - destruct t;vm_compute;reflexivity.
 - destruct t;unfold nibble_lhs;cbn[flat_eval pure_lval pure_rval typeof];rewrite ?ET,dec_eq_true,CAST,ASSIGN;reflexivity.
 - apply Control.do_value_total;exact END.
Qed.
Print Assumptions nibble_assignment_statement.
