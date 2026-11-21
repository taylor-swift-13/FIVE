From Stdlib Require Import Bool List ZArith Lia.
From compcert Require Import Coqlib Errors Maps Integers Floats AST Values Memory Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cexec Cstrategy Smallstep.
From PprzTrigPlain Require Import Source.
From PprzTrigRelationSupport Require Import Normalizer PlainCore PureEval PureProgress Total.
From PprzTrigInitSupport Require Import Control.
Import ListNotations Csyntaxdefs.CsyntaxNotations.
Local Open Scope Z_scope.
Definition fun_sin := Source.f_pprz_itrig_sin.
Definition body := fn_body fun_sin.
Definition norm := match body with Ssequence a _=>a|_=>Sskip end.
Definition rest := match body with Ssequence _ b=>b|_=>Sskip end.
Definition upper_loop := match norm with Ssequence a _=>a|_=>Sskip end.
Definition lower_loop := match norm with Ssequence _ b=>b|_=>Sskip end.
Definition fold_stmt := match rest with Ssequence a _=>a|_=>Sskip end.
Definition return_stmt := match rest with Ssequence _ b=>b|_=>Sskip end.
Definition upper_guard := match upper_loop with Swhile g _=>g|_=>Eval Vundef tint end.
Definition lower_guard := match lower_loop with Swhile g _=>g|_=>Eval Vundef tint end.
Definition upper_body := match upper_loop with Swhile _ s=>s|_=>Sskip end.
Definition lower_body := match lower_loop with Swhile _ s=>s|_=>Sskip end.
Definition pi_expr := match upper_guard with Ebinop _ _ c _=>c|_=>Eval Vundef tint end.
Definition halfpi_expr := match fold_stmt with Sifthenelse(Ebinop _ _ c _) _ _=>c|_=>Eval Vundef tint end.
Definition read_angle := Evalof (Evar Source._angle tint) tint.
Definition angle_env (b:block) : env := PTree.set Source._angle (b,tint) empty_env.

Lemma body_shape : body=Ssequence (Ssequence upper_loop lower_loop) (Ssequence fold_stmt return_stmt).
Proof. reflexivity. Qed.
Lemma pi_expr_value : forall ge e m,pure_rval ge e m pi_expr=Some(Vint(Int.repr 12867)).
Proof. intros;vm_compute;reflexivity. Qed.
Lemma halfpi_expr_value : forall ge e m,pure_rval ge e m halfpi_expr=Some(Vint(Int.repr 6433)).
Proof. intros;vm_compute;reflexivity. Qed.
Lemma angle_read : forall ge b m a,
 Mem.load Mint32 m b 0=Some(Vint a) ->
 pure_rval ge (angle_env b) m read_angle=Some(Vint a).
Proof.
 intros ge b m a LOAD. cbn[pure_rval pure_lval read_angle].
 rewrite dec_eq_true. unfold angle_env;rewrite PTree.gss,dec_eq_true.
 cbn[Cexec.do_deref_loc tint access_mode type_is_volatile noattr Mem.loadv size_chunk].
 rewrite Ptrofs.unsigned_zero. destruct(zle (0+4) Ptrofs.modulus);[rewrite LOAD;reflexivity|].
 assert(BOUND:4<=Ptrofs.modulus) by (change(4<=18446744073709551616);lia). lia.
Qed.
Lemma upper_guard_simple : simple upper_guard=true.
Proof. reflexivity. Qed.
Lemma lower_guard_simple : simple lower_guard=true.
Proof. reflexivity. Qed.
Lemma upper_guard_false : forall ge b m a,
 -12867<=Int.signed a<=12867 -> Mem.load Mint32 m b 0=Some(Vint a) ->
 pure_rval ge (angle_env b) m upper_guard=Some(Vint Int.zero).
Proof.
 intros ge b m a RANGE LOAD.
 change (match pure_rval ge (angle_env b) m read_angle,
               pure_rval ge (angle_env b) m pi_expr with
 |Some v,Some w=>sem_binary_operation ge Ogt v tint w tint m|_,_=>None end = Some(Vint Int.zero)).
 rewrite(angle_read _ _ _ _ LOAD),pi_expr_value.
 change(Some(Val.of_bool(Int.cmp Cgt a (Int.repr 12867)))=Some(Vint Int.zero)).
 unfold Int.cmp,Int.lt. rewrite Int.signed_repr by (change(-2147483648<=12867<=2147483647);lia).
 rewrite zlt_false by lia. reflexivity.
Qed.
Lemma lower_guard_false : forall ge b m a,
 -12867<=Int.signed a<=12867 -> Mem.load Mint32 m b 0=Some(Vint a) ->
 pure_rval ge (angle_env b) m lower_guard=Some(Vint Int.zero).
Proof.
 intros ge b m a RANGE LOAD.
 change(match pure_rval ge (angle_env b) m read_angle,
   (match pure_rval ge (angle_env b) m pi_expr with
    |Some v=>sem_unary_operation Oneg v tint m|None=>None end) with
 |Some v,Some w=>sem_binary_operation ge Olt v tint w tint m|_,_=>None end = Some(Vint Int.zero)).
 rewrite(angle_read _ _ _ _ LOAD),pi_expr_value.
 change(Some(Val.of_bool(Int.cmp Clt a (Int.repr(-12867))))=Some(Vint Int.zero)).
 unfold Int.cmp,Int.lt. rewrite Int.signed_repr by (change(-2147483648<= -12867<=2147483647);lia).
 rewrite zlt_false by lia. reflexivity.
Qed.

Definition fold_guard := match fold_stmt with Sifthenelse g _ _=>g|_=>Eval Vundef tint end.
Definition fold_yes := match fold_stmt with Sifthenelse _ s _=>s|_=>Sskip end.
Definition fold_no := match fold_stmt with Sifthenelse _ _ s=>s|_=>Sskip end.
Definition fold_negative_guard := match fold_no with Sifthenelse g _ _=>g|_=>Eval Vundef tint end.
Definition fold_negative_yes := match fold_no with Sifthenelse _ s _=>s|_=>Sskip end.
Definition rhs_positive := match fold_yes with Sdo(Eassign _ r _)=>r|_=>Eval Vundef tint end.
Definition rhs_negative := match fold_negative_yes with Sdo(Eassign _ r _)=>r|_=>Eval Vundef tint end.
Definition folded (a:int) :=
 if Int.cmp Cgt a (Int.repr 6433) then Int.sub (Int.repr 12867) a
 else if Int.cmp Clt a (Int.repr(-6433)) then Int.sub (Int.repr(-12867)) a else a.
Definition fold_memory (b:block)(a:int)(m mf:mem) : Prop :=
 if Int.cmp Cgt a (Int.repr 6433) then Mem.store Mint32 m b 0 (Vint(folded a))=Some mf
 else if Int.cmp Clt a (Int.repr(-6433)) then Mem.store Mint32 m b 0 (Vint(folded a))=Some mf
 else mf=m.
Lemma fold_guard_value : forall ge b m a,Mem.load Mint32 m b 0=Some(Vint a) ->
 pure_rval ge (angle_env b) m fold_guard=Some(Val.of_bool(Int.cmp Cgt a (Int.repr 6433))).
Proof.
 intros ge b m a LOAD.
 change(match pure_rval ge (angle_env b) m read_angle,pure_rval ge (angle_env b) m halfpi_expr with
 |Some v,Some w=>sem_binary_operation ge Ogt v tint w tint m|_,_=>None end = Some(Val.of_bool(Int.cmp Cgt a (Int.repr 6433)))).
 rewrite(angle_read _ _ _ _ LOAD),halfpi_expr_value;reflexivity.
Qed.
Lemma fold_negative_guard_value : forall ge b m a,Mem.load Mint32 m b 0=Some(Vint a) ->
 pure_rval ge (angle_env b) m fold_negative_guard=Some(Val.of_bool(Int.cmp Clt a (Int.repr(-6433)))).
Proof.
 intros ge b m a LOAD.
 change(match pure_rval ge (angle_env b) m read_angle,
   (match pure_rval ge (angle_env b) m halfpi_expr with
     |Some v=>sem_unary_operation Oneg v tint m|None=>None end) with
 |Some v,Some w=>sem_binary_operation ge Olt v tint w tint m|_,_=>None end = Some(Val.of_bool(Int.cmp Clt a (Int.repr(-6433))))).
 rewrite(angle_read _ _ _ _ LOAD),halfpi_expr_value;reflexivity.
Qed.
Lemma rhs_positive_value : forall ge b m a,Mem.load Mint32 m b 0=Some(Vint a) ->
 pure_rval ge (angle_env b) m rhs_positive=Some(Vint(Int.sub(Int.repr 12867)a)).
Proof.
 intros ge b m a LOAD.
 change(match pure_rval ge (angle_env b) m pi_expr,pure_rval ge (angle_env b) m read_angle with
 |Some v,Some w=>sem_binary_operation ge Osub v tint w tint m|_,_=>None end = Some(Vint(Int.sub(Int.repr 12867)a))).
 rewrite(angle_read _ _ _ _ LOAD),pi_expr_value;reflexivity.
Qed.
Lemma rhs_negative_value : forall ge b m a,Mem.load Mint32 m b 0=Some(Vint a) ->
 pure_rval ge (angle_env b) m rhs_negative=Some(Vint(Int.sub(Int.repr(-12867))a)).
Proof.
 intros ge b m a LOAD.
 change(match
   (match pure_rval ge (angle_env b) m pi_expr with
     |Some v=>sem_unary_operation Oneg v tint m|None=>None end),
   pure_rval ge (angle_env b) m read_angle with
 |Some v,Some w=>sem_binary_operation ge Osub v tint w tint m|_,_=>None end = Some(Vint(Int.sub(Int.repr(-12867))a))).
 rewrite(angle_read _ _ _ _ LOAD),pi_expr_value;reflexivity.
Qed.
Lemma assign_angle_value : forall ge b m rhs v mf,
 typeof rhs=tint -> pure_rval ge(angle_env b)m rhs=Some(Vint v) ->
 Mem.store Mint32 m b 0 (Vint v)=Some mf ->
 flat_eval ge(angle_env b)m(Eassign(Evar Source._angle tint)rhs tint)=Some(Vint v,mf).
Proof.
 intros ge b m rhs v mf TY EV STORE.
 cbn[flat_eval pure_lval]. rewrite dec_eq_true.
 unfold angle_env;rewrite PTree.gss,dec_eq_true.
 fold(angle_env b). rewrite EV,TY.
 cbn[typeof].
 change(match Cexec.do_assign_loc ge quiet_world tint m b Ptrofs.zero Full(Vint v) with
 |Some(_,_,mm,vv)=>Some(vv,mm)|None=>None end=Some(Vint v,mf)).
 cbn[Cexec.do_assign_loc tint type_is_volatile noattr access_mode Mem.storev size_chunk].
 rewrite Ptrofs.unsigned_zero.
 destruct(zle (0+4) Ptrofs.modulus);[rewrite STORE;reflexivity|].
 assert(BOUND:4<=Ptrofs.modulus) by (change(4<=18446744073709551616);lia). lia.
Qed.

Lemma bool_of_bool : forall m choice,bool_val(Val.of_bool choice)tint m=Some choice.
Proof. intros m [];reflexivity. Qed.
Lemma fold_total : forall ge Q f k b m a,
 Mem.load Mint32 m b 0=Some(Vint a) -> Mem.valid_access m Mint32 b 0 Writable ->
 (forall mf,fold_memory b a m mf -> total ge Q(State f Sskip k(angle_env b)mf)) ->
 total ge Q(State f fold_stmt k(angle_env b)m).
Proof.
 intros ge Q f k b m a LOAD VA END.
 change(total ge Q(State f(Sifthenelse fold_guard fold_yes fold_no)k(angle_env b)m)).
 eapply if_pure_total with(v:=Val.of_bool(Int.cmp Cgt a(Int.repr 6433)))(choice:=Int.cmp Cgt a(Int.repr 6433)).
 - reflexivity.
 - apply fold_guard_value;exact LOAD.
 - apply bool_of_bool.
 - destruct(Int.cmp Cgt a(Int.repr 6433))eqn:C1;simpl.
   + destruct(Mem.valid_access_store _ _ _ _ (Vint(Int.sub(Int.repr 12867)a)) VA)as[mf STORE].
     apply do_total. eapply flat_prefix_total with(v:=Vint(Int.sub(Int.repr 12867)a))(mf:=mf).
     * reflexivity.
     * reflexivity.
     * apply assign_angle_value;[reflexivity|apply rhs_positive_value;exact LOAD|exact STORE].
     * apply do_value_total. apply END. unfold fold_memory,folded;rewrite C1;exact STORE.
   + change(total ge Q(State f(Sifthenelse fold_negative_guard fold_negative_yes Sskip)k(angle_env b)m)).
     eapply if_pure_total with(v:=Val.of_bool(Int.cmp Clt a(Int.repr(-6433))))(choice:=Int.cmp Clt a(Int.repr(-6433))).
     * reflexivity.
     * apply fold_negative_guard_value;exact LOAD.
     * apply bool_of_bool.
     * destruct(Int.cmp Clt a(Int.repr(-6433)))eqn:C2;simpl.
       -- destruct(Mem.valid_access_store _ _ _ _ (Vint(Int.sub(Int.repr(-12867))a)) VA)as[mf STORE].
          apply do_total. eapply flat_prefix_total with(v:=Vint(Int.sub(Int.repr(-12867))a))(mf:=mf).
          ++ reflexivity.
          ++ reflexivity.
          ++ apply assign_angle_value;[reflexivity|apply rhs_negative_value;exact LOAD|exact STORE].
          ++ apply do_value_total. apply END. unfold fold_memory,folded;rewrite C1,C2;exact STORE.
       -- apply END. unfold fold_memory;rewrite C1,C2;reflexivity.
Qed.

Theorem normalized_front_total : forall ge Q f k tail b m a,
 -12867<=Int.signed a<=12867 -> Mem.load Mint32 m b 0=Some(Vint a) ->
 Mem.valid_access m Mint32 b 0 Writable ->
 (forall mf,fold_memory b a m mf -> total ge Q(State f tail k(angle_env b)mf)) ->
 total ge Q(State f(Ssequence norm(Ssequence fold_stmt tail))k(angle_env b)m).
Proof.
 intros ge Q f k tail b m a RANGE LOAD VA END.
 apply sequence_total. change(total ge Q(State f(Ssequence upper_loop lower_loop)
   (Kseq(Ssequence fold_stmt tail)k)(angle_env b)m)).
 apply sequence_total.
 eapply while_false_pure_total with(v:=Vint Int.zero).
 - apply upper_guard_simple.
 - apply upper_guard_false with(a:=a);assumption.
 - reflexivity.
 - apply skip_sequence_total.
   eapply while_false_pure_total with(v:=Vint Int.zero).
   + apply lower_guard_simple.
   + apply lower_guard_false with(a:=a);assumption.
   + reflexivity.
   + apply skip_sequence_total. apply sequence_total.
     apply fold_total with(a:=a);auto. intros mf FM.
     apply skip_sequence_total;apply END;exact FM.
Qed.
Print Assumptions normalized_front_total.

Definition table_expr := Evalof(Evar Source._pprz_trig_int(tarray tshort 6434))(tarray tshort 6434).
Definition lookup_expr := match return_stmt with Sifthenelse _ (Sreturn(Some a)) _=>a|_=>Eval Vundef tint end.
Definition return_guard := match return_stmt with Sifthenelse a _ _=>a|_=>Eval Vundef tint end.
Definition return_positive := match return_stmt with Sifthenelse _ s _=>s|_=>Sskip end.
Definition return_negative := match return_stmt with Sifthenelse _ _ s=>s|_=>Sskip end.
Definition lookup_negative_expr := match return_negative with Sreturn(Some a)=>a|_=>Eval Vundef tint end.
Lemma table_address : forall (ge:Csem.genv) local m table,
 Genv.find_symbol ge Source._pprz_trig_int=Some table ->
 pure_rval ge(angle_env local)m table_expr=Some(Vptr table Ptrofs.zero).
Proof.
 intros ge local m table SYM. cbn[pure_rval pure_lval table_expr].
 rewrite dec_eq_true. unfold angle_env;rewrite PTree.gso by (vm_compute;discriminate).
 rewrite PTree.gempty,SYM. reflexivity.
Qed.
Lemma table_offset : forall (ge:Csem.genv) a,
 0<=Int.signed a<6434 ->
 Ptrofs.add Ptrofs.zero(Ptrofs.mul(Ptrofs.repr(sizeof ge tshort))(ptrofs_of_int Signed a))=
 Ptrofs.repr(2*Int.signed a).
Proof.
 intros ge a B. rewrite Ptrofs.add_zero_l.
 change(Ptrofs.mul(Ptrofs.repr 2)(Ptrofs.repr(Int.signed a))=Ptrofs.repr(2*Int.signed a)).
 unfold Ptrofs.mul. rewrite !Ptrofs.unsigned_repr;try reflexivity;
 change Ptrofs.max_unsigned with 18446744073709551615;lia.
Qed.
Lemma lookup_value : forall (ge:Csem.genv) local m table a v,
 0<=Int.signed a<6434 -> Mem.load Mint32 m local 0=Some(Vint a) ->
 Genv.find_symbol ge Source._pprz_trig_int=Some table ->
 Mem.load Mint16signed m table(2*Int.signed a)=Some(Vint v) ->
 pure_rval ge(angle_env local)m lookup_expr=Some(Vint v).
Proof.
 intros ge local m table a v B LOAD SYM LOOKUP.
 change((if type_eq tshort tshort then
 match (match (match pure_rval ge(angle_env local)m table_expr,pure_rval ge(angle_env local)m read_angle with
 |Some v1,Some v2=>sem_binary_operation ge Oadd v1(tarray tshort 6434)v2 tint m|_,_=>None end) with
 |Some(Vptr bb ofs)=>Some(bb,ofs,Full)|_=>None end) with
 |Some(bb,ofs,bf)=>match Cexec.do_deref_loc ge quiet_world tshort m bb ofs bf with
  |Some(_,_,vv)=>Some vv|None=>None end|_=>None end
 else None)=Some(Vint v)).
 rewrite dec_eq_true.
 rewrite(table_address _ _ _ _ SYM),(angle_read _ _ _ _ LOAD).
 change(match Cexec.do_deref_loc ge quiet_world tshort m table
 (Ptrofs.add Ptrofs.zero(Ptrofs.mul(Ptrofs.repr(sizeof ge tshort))(ptrofs_of_int Signed a)))Full with
 |Some(_,_,vv)=>Some vv|None=>None end=Some(Vint v)).
 rewrite table_offset by exact B.
 cbn[Cexec.do_deref_loc tshort access_mode type_is_volatile noattr Mem.loadv size_chunk].
 rewrite Ptrofs.unsigned_repr by (change Ptrofs.max_unsigned with 18446744073709551615;lia).
 destruct(zle (2*Int.signed a+2) Ptrofs.modulus);[rewrite LOOKUP;reflexivity|].
 assert(PB:Ptrofs.modulus=18446744073709551616)by reflexivity;lia.
Qed.
Lemma return_guard_value : forall ge local m a,Mem.load Mint32 m local 0=Some(Vint a) ->
 pure_rval ge(angle_env local)m return_guard=Some(Val.of_bool(Int.cmp Cge a Int.zero)).
Proof.
 intros ge local m a LOAD.
 change(match pure_rval ge(angle_env local)m read_angle with Some v=>sem_binary_operation ge Oge v tint(Vint Int.zero)tint m|None=>None end=Some(Val.of_bool(Int.cmp Cge a Int.zero))).
 rewrite(angle_read _ _ _ _ LOAD);reflexivity.
Qed.

Definition array_read(idx:expr) := Evalof(Ederef(Ebinop Oadd table_expr idx(tptr tshort))tshort)tshort.
Lemma lookup_index_value : forall (ge:Csem.genv)local m table idx a v,
 typeof idx=tint -> 0<=Int.signed a<6434 -> pure_rval ge(angle_env local)m idx=Some(Vint a) ->
 Genv.find_symbol ge Source._pprz_trig_int=Some table ->
 Mem.load Mint16signed m table(2*Int.signed a)=Some(Vint v) ->
 pure_rval ge(angle_env local)m(array_read idx)=Some(Vint v).
Proof.
 intros ge local m table idx a v TY B EV SYM LOOKUP.
 change((if type_eq tshort tshort then
 match(match(match pure_rval ge(angle_env local)m table_expr,pure_rval ge(angle_env local)m idx with
 |Some v1,Some v2=>sem_binary_operation ge Oadd v1(tarray tshort 6434)v2(typeof idx)m|_,_=>None end)with
 |Some(Vptr bb ofs)=>Some(bb,ofs,Full)|_=>None end)with
 |Some(bb,ofs,bf)=>match Cexec.do_deref_loc ge quiet_world tshort m bb ofs bf with
 |Some(_,_,vv)=>Some vv|None=>None end|_=>None end else None)=Some(Vint v)).
 rewrite dec_eq_true,(table_address _ _ _ _ SYM),EV,TY.
 change(match Cexec.do_deref_loc ge quiet_world tshort m table
 (Ptrofs.add Ptrofs.zero(Ptrofs.mul(Ptrofs.repr(sizeof ge tshort))(ptrofs_of_int Signed a)))Full with
 |Some(_,_,vv)=>Some vv|None=>None end=Some(Vint v)).
 rewrite table_offset by exact B.
 cbn[Cexec.do_deref_loc tshort access_mode type_is_volatile noattr Mem.loadv size_chunk].
 rewrite Ptrofs.unsigned_repr by(change Ptrofs.max_unsigned with 18446744073709551615;lia).
 destruct(zle(2*Int.signed a+2)Ptrofs.modulus);[rewrite LOOKUP;reflexivity|].
 assert(PB:Ptrofs.modulus=18446744073709551616)by reflexivity;lia.
Qed.
Lemma neg_signed_small : forall a,-6433<=Int.signed a<=6433 -> Int.signed(Int.neg a)= -Int.signed a.
Proof.
 intros a B. assert(N:Int.neg a=Int.repr(-Int.signed a)).
 { rewrite <- (Int.repr_signed a) at 1;apply Int.neg_repr. }
 rewrite N,Int.signed_repr;[reflexivity|change(-2147483648<= -Int.signed a<=2147483647);lia].
Qed.
Lemma lookup_negative_value : forall (ge:Csem.genv)local m table a v,
 -6433<=Int.signed a<0 -> Mem.load Mint32 m local 0=Some(Vint a) ->
 Genv.find_symbol ge Source._pprz_trig_int=Some table ->
 Mem.load Mint16signed m table(2*(-Int.signed a))=Some(Vint v) ->
 pure_rval ge(angle_env local)m lookup_negative_expr=Some(Vint(Int.neg v)).
Proof.
 intros ge local m table a v B LOAD SYM LOOKUP.
 assert(IDX:pure_rval ge(angle_env local)m(Eunop Oneg read_angle tint)=Some(Vint(Int.neg a))).
 { change(match pure_rval ge(angle_env local)m read_angle with Some vv=>sem_unary_operation Oneg vv tint m|None=>None end=Some(Vint(Int.neg a))).
   rewrite(angle_read _ _ _ _ LOAD);reflexivity. }
 assert(NEG:Int.signed(Int.neg a)= -Int.signed a)by(apply neg_signed_small;lia).
 assert(ARR:pure_rval ge(angle_env local)m(array_read(Eunop Oneg read_angle tint))=Some(Vint v)).
 { apply lookup_index_value with(table:=table)(a:=Int.neg a);auto;try reflexivity;rewrite NEG;auto;lia. }
 change(match pure_rval ge(angle_env local)m(array_read(Eunop Oneg read_angle tint))with
 |Some vv=>sem_unary_operation Oneg vv tshort m|None=>None end=Some(Vint(Int.neg v))).
 rewrite ARR;reflexivity.
Qed.
Lemma cmp_nonneg : forall a,Int.cmp Cge a Int.zero=true <-> 0<=Int.signed a.
Proof.
 intro a;unfold Int.cmp,Int.lt;rewrite Int.signed_zero.
 destruct(zlt(Int.signed a)0);simpl;split;intros;try discriminate;lia.
Qed.
Definition table_result(lookup:Z->int)(a:int) :=
 if Int.cmp Cge a Int.zero then lookup(Int.signed a) else Int.neg(lookup(-Int.signed a)).
Theorem lookup_return_total : forall (ge:Csem.genv)Q f local m table a lookup mf,
 fn_return f=tint -> -6433<=Int.signed a<=6433 -> Mem.load Mint32 m local 0=Some(Vint a) ->
 Genv.find_symbol ge Source._pprz_trig_int=Some table ->
 (forall n,0<=n<6434 ->Mem.load Mint16signed m table(2*n)=Some(Vint(lookup n))) ->
 Mem.free_list m(blocks_of_env ge(angle_env local))=Some mf ->
 Q(Vint(table_result lookup a))mf ->
 total ge Q(State f return_stmt Kstop(angle_env local)m).
Proof.
 intros ge Q f local m table a lookup mf RET B LOAD SYM TABLE FREE OBS.
 change(total ge Q(State f(Sifthenelse return_guard return_positive return_negative)Kstop(angle_env local)m)).
 eapply if_pure_total with(v:=Val.of_bool(Int.cmp Cge a Int.zero))(choice:=Int.cmp Cge a Int.zero).
 - reflexivity.
 - apply return_guard_value;exact LOAD.
 - apply bool_of_bool.
 - destruct(Int.cmp Cge a Int.zero)eqn:POS;simpl.
   + assert(P:0<=Int.signed a)by(apply cmp_nonneg;exact POS).
     eapply return_pure_total with(v:=Vint(lookup(Int.signed a)))(res:=Vint(lookup(Int.signed a)))(mf:=mf).
     * reflexivity.
     * apply lookup_value with(table:=table)(a:=a);auto;[lia|apply TABLE;lia].
     * rewrite RET;reflexivity.
     * exact FREE.
     * apply total_final. unfold table_result in OBS;rewrite POS in OBS;exact OBS.
   + assert(N:Int.signed a<0).
     { destruct(Z_le_gt_dec 0(Int.signed a))as[NN|NN];[|lia].
       assert(C:Int.cmp Cge a Int.zero=true)by(apply cmp_nonneg;lia);congruence. }
     eapply return_pure_total with(v:=Vint(Int.neg(lookup(-Int.signed a))))(res:=Vint(Int.neg(lookup(-Int.signed a))))(mf:=mf).
     * reflexivity.
     * apply lookup_negative_value with(table:=table)(a:=a);auto;[lia|apply TABLE;lia].
     * rewrite RET;reflexivity.
     * exact FREE.
     * apply total_final. unfold table_result in OBS;rewrite POS in OBS;exact OBS.
Qed.
Print Assumptions lookup_return_total.

Lemma cmp_gt_6433 : forall a,Int.cmp Cgt a(Int.repr 6433)=true <-> 6433<Int.signed a.
Proof.
 intro a;unfold Int.cmp,Int.lt;rewrite Int.signed_repr by(change(-2147483648<=6433<=2147483647);lia).
 destruct(zlt 6433(Int.signed a));simpl;split;intros;try discriminate;lia.
Qed.
Lemma cmp_lt_neg6433 : forall a,Int.cmp Clt a(Int.repr(-6433))=true <-> Int.signed a< -6433.
Proof.
 intro a;unfold Int.cmp,Int.lt;rewrite Int.signed_repr by(change(-2147483648<= -6433<=2147483647);lia).
 destruct(zlt(Int.signed a)(-6433));simpl;split;intros;try discriminate;lia.
Qed.
Lemma folded_repr : forall a,-12867<=Int.signed a<=12867 -> folded a=Int.repr(Normalizer.fold(Int.signed a)).
Proof.
 intros a B. unfold folded,Normalizer.fold,Normalizer.pi,Normalizer.half_pi.
 destruct(Int.cmp Cgt a(Int.repr 6433))eqn:P.
 - apply cmp_gt_6433 in P. assert(G:Z.gtb(Int.signed a)6433=true)by(apply Z.gtb_lt;lia).
   rewrite G,Int.sub_signed,Int.signed_repr;[reflexivity|change(-2147483648<=12867<=2147483647);lia].
 - assert(PB:Int.signed a<=6433).
   { destruct(Z_le_gt_dec(Int.signed a)6433);auto.
     assert(C:Int.cmp Cgt a(Int.repr 6433)=true)by(apply cmp_gt_6433;lia);congruence. }
   assert(G:Z.gtb(Int.signed a)6433=false).
   { destruct(Z.gtb(Int.signed a)6433)eqn:G;auto;apply Z.gtb_lt in G;lia. }
   rewrite G. destruct(Int.cmp Clt a(Int.repr(-6433)))eqn:N.
   + apply cmp_lt_neg6433 in N. assert(NB:(Int.signed a <? -6433)=true)by(apply Z.ltb_lt;exact N).
     Show. rewrite NB,Int.sub_signed,Int.signed_repr;[reflexivity|change(-2147483648<= -12867<=2147483647);lia].
   + assert(NB: -6433<=Int.signed a).
     { destruct(Z_le_gt_dec(-6433)(Int.signed a));auto.
       assert(C:Int.cmp Clt a(Int.repr(-6433))=true)by(apply cmp_lt_neg6433;lia);congruence. }
     assert(NF:(Int.signed a <? -6433)=false)by(apply Z.ltb_ge;lia).
     rewrite NF. symmetry;apply Int.repr_signed.
Qed.
Lemma folded_bounds : forall a,-12867<=Int.signed a<=12867 -> -6433<=Int.signed(folded a)<=6433.
Proof.
 intros a B. rewrite folded_repr by exact B.
 pose proof(Normalizer.fold_bounds(Int.signed a))as F.
 unfold Normalizer.pi,Normalizer.half_pi in F;specialize(F B).
 rewrite Int.signed_repr;[exact F|change(-2147483648<=Normalizer.fold(Int.signed a)<=2147483647);lia].
Qed.
Lemma angle_env_blocks : forall ge b,blocks_of_env ge(angle_env b)=[(b,0,4)].
Proof. intros;vm_compute;reflexivity. Qed.
Definition fold_finish (ge:Csem.genv)(b:block)(a:int)(m mf:mem) : Prop :=
 exists middle,fold_memory b a m middle /\ Mem.free_list middle(blocks_of_env ge(angle_env b))=Some mf.
Lemma fold_memory_local : forall b a m middle,
 Mem.load Mint32 m b 0=Some(Vint a) -> Mem.range_perm m b 0 4 Cur Freeable ->
 fold_memory b a m middle ->
 Mem.load Mint32 middle b 0=Some(Vint(folded a)) /\ Mem.range_perm middle b 0 4 Cur Freeable.
Proof.
 intros b a m middle LOAD PERM FM;unfold fold_memory in FM.
 destruct(Int.cmp Cgt a(Int.repr 6433))eqn:P.
 - split.
   + exact(Mem.load_store_same _ _ _ _ _ _ FM).
   + intros ofs B;eapply Mem.perm_store_1;[exact FM|apply PERM;exact B].
 - destruct(Int.cmp Clt a(Int.repr(-6433)))eqn:N.
   + split.
     * exact(Mem.load_store_same _ _ _ _ _ _ FM).
     * intros ofs B;eapply Mem.perm_store_1;[exact FM|apply PERM;exact B].
   + subst middle;unfold folded;rewrite P,N;auto.
Qed.
Lemma fold_memory_other : forall b a m middle table chunk ofs,
 table<>b -> fold_memory b a m middle -> Mem.load chunk middle table ofs=Mem.load chunk m table ofs.
Proof.
 intros b a m middle table chunk ofs NE FM;unfold fold_memory in FM.
 destruct(Int.cmp Cgt a(Int.repr 6433));[eapply Mem.load_store_other;[exact FM|auto]|].
 destruct(Int.cmp Clt a(Int.repr(-6433)));[eapply Mem.load_store_other;[exact FM|auto]|].
 subst;reflexivity.
Qed.
Theorem plain_body_total : forall (ge:Csem.genv)Q local m table a lookup,
 -12867<=Int.signed a<=12867 -> Mem.load Mint32 m local 0=Some(Vint a) ->
 Mem.valid_access m Mint32 local 0 Writable -> Mem.range_perm m local 0 4 Cur Freeable ->
 table<>local -> Genv.find_symbol ge Source._pprz_trig_int=Some table ->
 (forall n,0<=n<6434 ->Mem.load Mint16signed m table(2*n)=Some(Vint(lookup n))) ->
 (forall mf,fold_finish ge local a m mf -> Q(Vint(table_result lookup(folded a)))mf) ->
 total ge Q(State fun_sin body Kstop(angle_env local)m).
Proof.
 intros ge Q local m table a lookup RANGE LOAD VA PERM NE SYM TABLE OBS.
 rewrite body_shape. apply normalized_front_total with(a:=a);auto.
 intros middle FM.
 destruct(fold_memory_local _ _ _ _ LOAD PERM FM)as[MLOAD MPERM].
 destruct(Mem.range_perm_free _ _ _ _ MPERM)as[mf FREE].
 assert(FL:Mem.free_list middle(blocks_of_env ge(angle_env local))=Some mf).
 { rewrite angle_env_blocks;cbn[Mem.free_list];rewrite FREE;reflexivity. }
 apply lookup_return_total with(table:=table)(a:=folded a)(lookup:=lookup)(mf:=mf);auto;try reflexivity.
 - apply folded_bounds;exact RANGE.
 - intros n NB;rewrite(fold_memory_other _ _ _ _ _ _ _ NE FM);apply TABLE;exact NB.
 - apply OBS;exists middle;auto.
Qed.
Print Assumptions plain_body_total.
