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
 change(match pure_rval ge(angle_env local)m table_expr,pure_rval ge(angle_env local)m read_angle with
 |Some v1,Some v2=>match sem_binary_operation ge Oadd v1(tarray tshort 6434)v2 tint m with
 |Some(Vptr bb ofs)=>match Cexec.do_deref_loc ge quiet_world tshort m bb ofs Full with
  |Some(_,_,vv)=>Some vv|None=>None end|_=>None end|_,_=>None end=Some(Vint v)).
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
