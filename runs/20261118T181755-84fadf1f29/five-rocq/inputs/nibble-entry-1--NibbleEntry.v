From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Maps Integers AST Values Memory Events Globalenvs Ctypes Ctypesdefs Cop Csyntax Csem Cexec.
Require PprzTrigInit.Source.
From PprzTrigRelationSupport Require Import PureEval.
From PprzTrigInitSupport Require Import Control IntegerFacts NibbleMachine.
From PprzTrigCBMC Require Import NibbleGuards CallEntryCoverage.
Import ListNotations.
Local Open Scope Z_scope.
Local Opaque PprzTrigInit.Source.prog source_byte source_nibble.

Record nibble_operand_pc(e:env)(m:mem)(bp bc:block)(p:Z):Prop:={
 np_range:0<=p<3379;
 np_position:e!PprzTrigInit.Source._pos=Some(bp,tushort);
 np_unshadowed:e!PprzTrigInit.Source._pprz_trig_int_compr=None;
 np_symbol:Genv.find_symbol(Csem.globalenv PprzTrigInit.Source.prog)PprzTrigInit.Source._pprz_trig_int_compr=Some bc;
 np_parameter:Mem.load Mint16unsigned m bp 0=Some(Vint(Int.repr p));
 np_literal_byte:Mem.load Mint8unsigned m bc(p/2)=Some(Vint(Int.repr(source_byte p)))
}.

Theorem original_nibble_entry_reaches_operand_pc : forall m bc p,
 0<=p<3379 ->
 Genv.find_symbol(Csem.globalenv PprzTrigInit.Source.prog)PprzTrigInit.Source._pprz_trig_int_compr=Some bc ->
 Mem.load Mint8unsigned m bc(p/2)=Some(Vint(Int.repr(source_byte p))) ->
 exists e mp bp,nibble_operand_pc e mp bp bc p /\
 (forall k,Csem.step(Csem.globalenv PprzTrigInit.Source.prog)
   (Callstate(Internal PprzTrigInit.Source.f_get_nibble)[Vint(Int.repr p)]k m)E0
   (State PprzTrigInit.Source.f_get_nibble(fn_body PprzTrigInit.Source.f_get_nibble)k e mp)) /\
 (forall k t next,Csem.step(Csem.globalenv PprzTrigInit.Source.prog)
   (Callstate(Internal PprzTrigInit.Source.f_get_nibble)[Vint(Int.repr p)]k m)t next ->
   t=E0 /\next=State PprzTrigInit.Source.f_get_nibble(fn_body PprzTrigInit.Source.f_get_nibble)k e mp).
Proof.
 intros m bc p P SYMBOL BYTE.
 destruct(Mem.alloc m 0 2)as[ma bp]eqn:ALLOC.
 assert(FRESH:~Mem.valid_block m bp)by(eapply Mem.fresh_block_alloc;eauto).
 assert(VA:Mem.valid_access ma Mint16unsigned bp 0 Writable).
 { eapply Mem.valid_access_implies;[|constructor].
   eapply Mem.valid_access_alloc_same;[exact ALLOC|cbn;lia|cbn;lia|exists 0;reflexivity]. }
 destruct(Mem.valid_access_store ma Mint16unsigned bp 0(Vint(Int.repr p))VA)as[mp STORE].
 assert(PARAM:Mem.load Mint16unsigned mp bp 0=Some(Vint(Int.repr p))).
 { pose proof(@Mem.load_store_same Mint16unsigned ma bp 0(Vint(Int.repr p))mp STORE)as L.
   cbn[Val.load_result]in L;rewrite zero_ext16_repr in L by lia;exact L. }
 assert(OLD:Mem.valid_block m bc).
 { eapply Mem.valid_access_valid_block;eapply Mem.valid_access_implies;[eapply Mem.load_valid_access;exact BYTE|constructor]. }
 assert(DIFF:bc<>bp)by(intro SAME;subst bc;contradiction).
 assert(BYTEP:Mem.load Mint8unsigned mp bc(p/2)=Some(Vint(Int.repr(source_byte p)))).
 { erewrite(Mem.load_store_other _ _ _ _ _ _ STORE);[eapply Mem.load_alloc_other;eauto|left;exact DIFF]. }
 set(e:=PTree.set PprzTrigInit.Source._pos(bp,tushort)(PTree.empty(block*type))).
 assert(EPOS:e!PprzTrigInit.Source._pos=Some(bp,tushort))by(unfold e;apply PTree.gss).
 assert(ECOMPR:e!PprzTrigInit.Source._pprz_trig_int_compr=None)by(unfold e;vm_compute;reflexivity).
 assert(AV:do_alloc_variables(Csem.globalenv PprzTrigInit.Source.prog)empty_env m
   (fn_params PprzTrigInit.Source.f_get_nibble++fn_vars PprzTrigInit.Source.f_get_nibble)=(e,ma)).
 { change(do_alloc_variables(Csem.globalenv PprzTrigInit.Source.prog)empty_env m[(PprzTrigInit.Source._pos,tushort)]=(e,ma)).
   cbn[do_alloc_variables tushort sizeof];rewrite ALLOC;reflexivity. }
 assert(BIND:sem_bind_parameters(Csem.globalenv PprzTrigInit.Source.prog)Control.quiet e ma
   (fn_params PprzTrigInit.Source.f_get_nibble)[Vint(Int.repr p)]=Some mp).
 { change(sem_bind_parameters(Csem.globalenv PprzTrigInit.Source.prog)Control.quiet e ma
   [(PprzTrigInit.Source._pos,tushort)][Vint(Int.repr p)]=Some mp).
   rewrite sem_bind_parameters_equation,EPOS,dec_eq_true.
   cbv beta iota zeta delta[Cexec.do_assign_loc type_is_volatile attr_of_type attr_volatile noattr access_mode Mem.storev tushort size_chunk].
   rewrite Ptrofs.unsigned_zero,STORE,zle_true by(change(2<=18446744073709551616);lia).
   rewrite sem_bind_parameters_equation;reflexivity. }
 exists e,mp,bp;split;[constructor;assumption|];split.
 - intro k;apply(proj1(@original_internal_entry_observations(Csem.globalenv PprzTrigInit.Source.prog)
     PprzTrigInit.Source.f_get_nibble[Vint(Int.repr p)]k m e ma mp
     ltac:(vm_compute;repeat constructor;simpl;intuition discriminate)AV BIND)).
 - intros k;apply(proj2(@original_internal_entry_observations(Csem.globalenv PprzTrigInit.Source.prog)
     PprzTrigInit.Source.f_get_nibble[Vint(Int.repr p)]k m e ma mp
     ltac:(vm_compute;repeat constructor;simpl;intuition discriminate)AV BIND)).
Qed.
