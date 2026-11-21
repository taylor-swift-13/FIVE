From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib AST Values Memory Memdata.
Open Scope Z_scope.
Record CopiedBytes(m mf:mem)(sb ob:block)(srcOfs dstOfs n:Z)(bytes:list memval):Prop:={
 copy_store:Mem.storebytes m ob dstOfs bytes=Some mf;
 copy_destination:Mem.loadbytes mf ob dstOfs n=Some bytes;
 copy_source_loads:forall ch ofs,Mem.load ch mf sb ofs=Mem.load ch m sb ofs;
 copy_source_bytes:forall ofs len,0<=len ->Mem.loadbytes mf sb ofs len=Mem.loadbytes m sb ofs len;
 copy_permissions:forall b ofs k p,Mem.perm m b ofs k p<->Mem.perm mf b ofs k p;
 copy_other_loads:forall ch b ofs,b<>ob \/ofs+size_chunk ch<=dstOfs \/dstOfs+n<=ofs ->Mem.load ch mf b ofs=Mem.load ch m b ofs;
 copy_other_bytes:forall b ofs len,0<=len ->b<>ob \/ofs+len<=dstOfs \/dstOfs+n<=ofs ->Mem.loadbytes mf b ofs len=Mem.loadbytes m b ofs len
}.
Theorem observer_copy:forall m sb ob srcOfs dstOfs n bytes,
 0<=n ->sb<>ob ->
 Mem.range_perm m sb srcOfs(srcOfs+n)Cur Readable ->
 Mem.range_perm m ob dstOfs(dstOfs+n)Cur Writable ->
 Mem.loadbytes m sb srcOfs n=Some bytes ->exists mf,CopiedBytes m mf sb ob srcOfs dstOfs n bytes.
Proof.
 intros m sb ob srcOfs dstOfs n bytes N NE SRC DST READ.
 pose proof(Mem.loadbytes_length _ _ _ _ _ READ)as LN.
 assert(LEN:Z.of_nat(length bytes)=n)by(rewrite LN,Z2Nat.id;lia).
 destruct(Mem.range_perm_storebytes m ob dstOfs bytes)as[mf STORE];[rewrite LEN;exact DST|].
 exists mf;constructor.
 - exact STORE.
 - rewrite<-LEN;exact(Mem.loadbytes_storebytes_same _ _ _ _ _ STORE).
 - intros;apply(Mem.load_storebytes_other _ _ _ _ _ STORE);left;exact NE.
 - intros;apply(Mem.loadbytes_storebytes_other _ _ _ _ _ STORE);auto.
 - intros;split;[apply(Mem.perm_storebytes_1 _ _ _ _ _ STORE)|apply(Mem.perm_storebytes_2 _ _ _ _ _ STORE)].
 - intros;apply(Mem.load_storebytes_other _ _ _ _ _ STORE);rewrite LEN;assumption.
 - intros;apply(Mem.loadbytes_storebytes_other _ _ _ _ _ STORE);[assumption|rewrite LEN;assumption].
Qed.
Print Assumptions observer_copy.
