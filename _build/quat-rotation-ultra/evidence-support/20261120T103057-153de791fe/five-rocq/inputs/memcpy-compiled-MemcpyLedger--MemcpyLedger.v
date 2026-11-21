From Stdlib Require Import List String ZArith.
From compcert Require Import Integers Values Memory Events.
From FiveRmatVmultCase Require Import Memcpy.
Import ListNotations.
Local Open Scope Z_scope.
Local Open Scope string_scope.
Inductive Guard18 := SameForward|SourceLive|DestinationEndLive|SameReverse|DestinationLive|SourceEndLive|NoOverlap|ReadableSource|WritableDestination.
Definition GuardPredicate(m:mem)(src dst:block)(k:Guard18):Prop :=forall(order1 order2:Prop),match k with
 |SameForward=>(True /\~(dst<>src))->False
 |SourceLive=>(True /\~(dst<>src))->Mem.valid_pointer m src 0=true
 |DestinationEndLive=>(True /\~(dst<>src))->Mem.weak_valid_pointer m dst 12=true
 |SameReverse=>~(dst<>src \/order1)->False
 |DestinationLive=>~(dst<>src \/order1)->Mem.valid_pointer m dst 0=true
 |SourceEndLive=>~(dst<>src \/order1)->Mem.weak_valid_pointer m src 12=true
 |NoOverlap=>(dst<>src \/order1)\/order2
 |ReadableSource=>Mem.range_perm m src 0 12 Cur Readable
 |WritableDestination=>Mem.range_perm m dst 0 12 Cur Writable
 end.
Definition Original18:list(string*(bool*Guard18)):=
[("memcpy.pointer.1",(false,SameForward));
("memcpy.pointer_arithmetic.1",(false,SourceLive));
("memcpy.pointer_arithmetic.2",(false,DestinationEndLive));
("memcpy.pointer.2",(false,SameReverse));
("memcpy.pointer_arithmetic.3",(false,DestinationLive));
("memcpy.pointer_arithmetic.4",(false,SourceEndLive));
("main.precondition_instance.1",(false,NoOverlap));
("main.precondition_instance.2",(false,ReadableSource));
("main.precondition_instance.3",(false,WritableDestination));
("memcpy.pointer.3",(true,SameForward));
("memcpy.pointer_arithmetic.5",(true,SourceLive));
("memcpy.pointer_arithmetic.6",(true,DestinationEndLive));
("memcpy.pointer.4",(true,SameReverse));
("memcpy.pointer_arithmetic.7",(true,DestinationLive));
("memcpy.pointer_arithmetic.8",(true,SourceEndLive));
("main.precondition_instance.4",(true,NoOverlap));
("main.precondition_instance.5",(true,ReadableSource));
("main.precondition_instance.6",(true,WritableDestination))].
Lemma safety_guard:forall m src dst k,MemcpySafety m src dst->GuardPredicate m src dst k.
Proof. intros m src dst k S order1 order2;destruct S as[D A B E C F G R W];destruct k;simpl;tauto. Qed.
Definition AllOriginal18:Prop :=forall se m sa da sb db,
 CopyPre m sa da->CopyPre m sb db->sb<>da->db<>da->
 exists ma mb ba bb,
 Mem.loadbytes m sa 0 12=Some ba /\Mem.loadbytes ma sb 0 12=Some bb /\
 Mem.storebytes m da 0 ba=Some ma /\Mem.storebytes ma db 0 bb=Some mb /\
 extcall_memcpy_sem 12 1 se[Vptr da Ptrofs.zero;Vptr sa Ptrofs.zero]m E0 Vundef ma /\
 extcall_memcpy_sem 12 1 se[Vptr db Ptrofs.zero;Vptr sb Ptrofs.zero]ma E0 Vundef mb /\
 Mem.loadbytes mb da 0 12=Some ba /\Mem.loadbytes mb db 0 12=Some bb /\
 CopyFrame m ma da /\CopyFrame ma mb db /\
 (forall id second kind,In(id,(second,kind))Original18->
 GuardPredicate(if second then ma else m)(if second then sb else sa)(if second then db else da)kind).
Theorem all_original_18_proved:AllOriginal18.
Proof.
 intros se m sa da sb db PA PB SD DD.
 destruct(two_copy12_exact se m sa da sb db PA PB SD DD)as[ma[mb[ba[bb[SA[SB[RA[RB[STA[STB[CA[CB[BA[BB[FA FB]]]]]]]]]]]]]]].
 exists ma,mb,ba,bb;split;[exact RA|];split;[exact RB|];split;[exact STA|];split;[exact STB|];split;[exact CA|];split;[exact CB|];split;[exact BA|];split;[exact BB|];split;[exact FA|];split;[exact FB|].
 intros id second kind IN;destruct second;apply safety_guard;assumption.
Qed.
Print Assumptions all_original_18_proved.
