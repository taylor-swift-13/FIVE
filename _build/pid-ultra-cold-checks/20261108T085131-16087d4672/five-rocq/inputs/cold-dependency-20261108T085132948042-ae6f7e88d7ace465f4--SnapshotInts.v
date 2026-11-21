From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib AST Integers Values Memory Ctypes Csyntaxdefs Cop Csem.
From PidPositionTranslationCore Require Import FactoryMemory.
Import ListNotations.
Open Scope Z_scope.
Definition int_cell:Type:=Z*int.
Definition cell_bounds(n:Z)(c:int_cell):Prop:=
 0<=fst c /\fst c+4<=n /\(4|fst c).
Fixpoint cell_separated(cs:list int_cell):Prop:=match cs with
| []=>True|c::rest=>(forall d,In d rest ->fst c+4<=fst d \/fst d+4<=fst c)/\cell_separated rest end.
Inductive initialize_ints(b:block):mem->list int_cell->mem->Prop:=
| ii_nil:forall m,initialize_ints b m[]m
| ii_cons:forall m tailm mf o v rest,
 initialize_ints b m rest tailm ->
 Mem.store Mint32 tailm b o(Vint v)=Some mf ->
 initialize_ints b m((o,v)::rest)mf.
Lemma initialize_ints_writes:forall b m cs mf,initialize_ints b m cs mf ->
 raw_writes(fun bb=>bb=b)m mf.
Proof.
 intros b m cs mf INIT;induction INIT.
 - constructor.
 - eapply raw_writes_trans;[exact IHINIT|eapply raw_writes_store;[reflexivity|exact H|constructor]].
Qed.
Theorem initialize_ints_exists:forall m b n cs,
 Mem.range_perm m b 0 n Cur Writable ->
 Forall(cell_bounds n)cs ->cell_separated cs ->
 exists mf,initialize_ints b m cs mf /\
 forall o v,In(o,v)cs ->Mem.load Mint32 mf b o=Some(Vint v).
Proof.
 intros m b n cs;revert m;induction cs as[|[o v]rest IH];intros m WRITE BOUNDS SEP.
 - exists m;split;[constructor|intros;contradiction].
 - inversion BOUNDS as[|c cs0 HB HREST];subst.
   destruct SEP as[SEPARATED RESTSEP].
   destruct(IH m WRITE HREST RESTSEP)as[tailm[TAIL LOADS]].
   pose proof(initialize_ints_writes b m rest tailm TAIL)as WR.
   destruct HB as[LOW[HIGH ALIGN]];cbn in LOW,HIGH,ALIGN.
   assert(ACC:Mem.valid_access tailm Mint32 b o Writable).
   { eapply scalar_access_inside with(n:=n);
     [eapply raw_writes_range;[exact WR|exact WRITE]|exact LOW|exact HIGH|exact ALIGN]. }
   destruct(Mem.valid_access_store tailm Mint32 b o(Vint v)ACC)as[mf STORE].
   exists mf;split;[econstructor;[exact TAIL|exact STORE]|].
   intros p w[EQ|IN].
   + injection EQ as OP VW;subst p w;erewrite Mem.load_store_same by exact STORE;reflexivity.
   + rewrite(Mem.load_store_other _ _ _ _ _ _ STORE).
     * apply LOADS;exact IN.
     * right;pose proof(SEPARATED(p,w)IN)as D;cbn in D;cbn[size_chunk];tauto.
Qed.
Definition fresh_snapshot(ge:genv)(ty:type)(m:mem)(cs:list int_cell)(b:block)(mf:mem):Prop:=
 exists allocated,Mem.alloc m 0(sizeof ge ty)=(allocated,b) /\
 initialize_ints b allocated cs mf.
Theorem fresh_snapshot_exists:forall(ge:genv)(ty:type)(m:mem)(cs:list int_cell),
 Forall(cell_bounds(sizeof ge ty))cs ->cell_separated cs ->
 exists b mf,fresh_snapshot ge ty m cs b mf /\
 (forall o v,In(o,v)cs ->Mem.load Mint32 mf b o=Some(Vint v)) /\
 (forall ch old ofs value,Mem.load ch m old ofs=Some value ->
   Mem.load ch mf old ofs=Some value).
Proof.
 intros ge ty m cs BOUNDS SEP.
 destruct(Mem.alloc m 0(sizeof ge ty))as[allocated b]eqn:ALLOC.
 assert(WRITE:Mem.range_perm allocated b 0(sizeof ge ty)Cur Writable).
 { intros z R;eapply Mem.perm_implies;[eapply Mem.perm_alloc_2;[exact ALLOC|exact R]|constructor]. }
 destruct(initialize_ints_exists allocated b(sizeof ge ty)cs WRITE BOUNDS SEP)as[mf[INIT LOADS]].
 exists b,mf;split;[exists allocated;auto|];split;[exact LOADS|].
 intros ch old ofs value LOAD.
 pose proof(Mem.load_valid_access _ _ _ _ _ LOAD)as ACCESS.
 assert(LIVE:Mem.valid_block m old).
 { eapply Mem.valid_access_valid_block;eapply Mem.valid_access_implies;[exact ACCESS|constructor]. }
 assert(NE:old<>b).
 { intro EQ;subst old;exact(Mem.fresh_block_alloc _ _ _ _ _ ALLOC LIVE). }
 rewrite(raw_writes_load_frame _ _ _ (initialize_ints_writes b allocated cs mf INIT)ch old ofs).
 - eapply Mem.load_alloc_other;[exact ALLOC|exact LOAD].
 - intro EQ;apply NE;exact EQ.
Qed.
Lemma int_snapshot_cast:forall m v,sem_cast(Vint v)tint tint m=Some(Vint v).
Proof. intros;reflexivity. Qed.
Print Assumptions fresh_snapshot_exists.
