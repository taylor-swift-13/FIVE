From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib AST Integers Values Memory.
From PidPositionTranslationCore Require Import FactoryMemory.
Import ListNotations.
Open Scope Z_scope.
Definition scalar_update:Type:=(memory_chunk*block*Z*val)%type.
Fixpoint replay_stores(m:mem)(updates:list scalar_update):option mem:=
 match updates with []=>Some m|(ch,b,ofs,v)::tail=>
 match Mem.store ch m b ofs v with None=>None|Some ma=>replay_stores ma tail end end.
Lemma replay_stores_app:forall xs ys m mf,
 replay_stores m(xs++ys)=Some mf <->
 exists ma,replay_stores m xs=Some ma/\replay_stores ma ys=Some mf.
Proof.
 induction xs as[|[[[ch b]ofs]v]xs IH];intros;cbn[app replay_stores].
 - split;intros;[exists m;auto|destruct H as(ma&A&B);injection A as<-;exact B].
 - destruct(Mem.store ch m b ofs v)eqn:ST;[apply IH|split;[discriminate|intros(ma&A&B);discriminate]].
Qed.
Definition misses_chunk(ch:memory_chunk)(b:block)(ofs:Z)(u:scalar_update):Prop:=
 let '(cu,bu,ou,v):=u in b<>bu\/ofs+size_chunk ch<=ou\/ou+size_chunk cu<=ofs.
Lemma replay_stores_load_frame:forall updates m mf ch b ofs,
 replay_stores m updates=Some mf ->Forall(misses_chunk ch b ofs)updates ->
 Mem.load ch mf b ofs=Mem.load ch m b ofs.
Proof.
 induction updates as[|[[[cu bu]ou]v]us IH];intros m mf ch b ofs RUN MISS;cbn[replay_stores]in RUN.
 - injection RUN as<-;reflexivity.
 - destruct(Mem.store cu m bu ou v)as[ma|]eqn:ST;[|discriminate].
   inversion MISS as[|u tail HEAD TAIL];subst;rewrite(IH ma mf ch b ofs RUN TAIL).
   eapply Mem.load_store_other;[exact ST|exact HEAD].
Qed.
Lemma replay_stores_raw:forall updates m mf allowed,
 replay_stores m updates=Some mf ->Forall(fun u=>let '(_,b,_,_):=u in allowed b)updates ->
 raw_writes allowed m mf.
Proof.
 induction updates as[|[[[ch b]ofs]v]us IH];intros m mf allowed RUN AL;cbn[replay_stores]in RUN.
 - injection RUN as<-;constructor.
 - destruct(Mem.store ch m b ofs v)as[ma|]eqn:ST;[|discriminate].
   inversion AL as[|u tail HEAD TAIL];subst;eapply raw_writes_store;[exact HEAD|exact ST|eapply IH;eauto].
Qed.
Print Assumptions replay_stores_load_frame.

Lemma replay_stores_access:forall updates m mf ch b ofs p,
 replay_stores m updates=Some mf ->Mem.valid_access m ch b ofs p ->Mem.valid_access mf ch b ofs p.
Proof.
 induction updates as[|[[[cu bu]ou]v]us IH];intros m mf ch b ofs p RUN A;cbn[replay_stores]in RUN.
 - injection RUN as<-;exact A.
 - destruct(Mem.store cu m bu ou v)as[ma|]eqn:ST;[|discriminate].
   eapply IH;[exact RUN|eapply Mem.store_valid_access_1;eauto].
Qed.

Lemma replay_stores_nextblock:forall updates m mf,
 replay_stores m updates=Some mf ->Mem.nextblock mf=Mem.nextblock m.
Proof.
 induction updates as[|[[[cu bu]ou]v]us IH];intros m mf RUN;cbn[replay_stores]in RUN.
 - injection RUN as<-;reflexivity.
 - destruct(Mem.store cu m bu ou v)as[ma|]eqn:ST;[|discriminate].
   rewrite(IH ma mf RUN);eapply Mem.nextblock_store;exact ST.
Qed.
Lemma replay_stores_valid_block:forall updates m mf,
 replay_stores m updates=Some mf ->forall b,Mem.valid_block m b ->Mem.valid_block mf b.
Proof. intros updates m mf RUN b VB;unfold Mem.valid_block in*;rewrite(replay_stores_nextblock _ _ _ RUN);exact VB. Qed.

Lemma replay_stores_bytes_frame_block:forall updates m mf b ofs n,
 replay_stores m updates=Some mf ->Forall(fun u=>let '(_,bu,_,_):=u in b<>bu)updates ->
 0<=n ->Mem.loadbytes mf b ofs n=Mem.loadbytes m b ofs n.
Proof.
 induction updates as[|[[[cu bu]ou]v]us IH];intros m mf b ofs n RUN MISS N;cbn[replay_stores]in RUN.
 - injection RUN as<-;reflexivity.
 - destruct(Mem.store cu m bu ou v)as[ma|]eqn:ST;[|discriminate].
   inversion MISS as[|u tail HEAD TAIL];subst;rewrite(IH ma mf b ofs n RUN TAIL N).
   eapply Mem.loadbytes_store_other;[exact ST|left;exact HEAD].
Qed.
