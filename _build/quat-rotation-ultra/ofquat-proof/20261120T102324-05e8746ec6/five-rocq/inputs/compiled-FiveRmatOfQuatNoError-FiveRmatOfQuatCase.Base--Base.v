From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Errors Maps Integers Floats AST Values Memory Memdata Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cexec Smallstep.
From FiveGuidanceAllOrder Require Import PureDenotation AtomicDenotation CallfreeExecution.
From FiveRmatOfQuat Require Import Source Execution.
From FiveLowpassSupport Require Import Expressions.
Import ListNotations.
Local Open Scope Z_scope.

Fixpoint statements(s:statement):list expr:=match s with Sdo a=>[a]|Ssequence a b=>statements a++statements b|_=>[]end.
Definition acts:=Eval cbv [statements Source.f_float_rmat_of_quat fn_body app] in statements(fn_body Source.f_float_rmat_of_quat).
Definition act0:=Eval cbv [acts nth] in nth 0 acts (Eval Vundef tvoid).
Definition act1:=Eval cbv [acts nth] in nth 1 acts (Eval Vundef tvoid).
Definition act2:=Eval cbv [acts nth] in nth 2 acts (Eval Vundef tvoid).
Definition act3:=Eval cbv [acts nth] in nth 3 acts (Eval Vundef tvoid).
Definition act4:=Eval cbv [acts nth] in nth 4 acts (Eval Vundef tvoid).
Definition act5:=Eval cbv [acts nth] in nth 5 acts (Eval Vundef tvoid).
Definition act6:=Eval cbv [acts nth] in nth 6 acts (Eval Vundef tvoid).
Definition act7:=Eval cbv [acts nth] in nth 7 acts (Eval Vundef tvoid).
Definition act8:=Eval cbv [acts nth] in nth 8 acts (Eval Vundef tvoid).
Definition act9:=Eval cbv [acts nth] in nth 9 acts (Eval Vundef tvoid).
Definition act10:=Eval cbv [acts nth] in nth 10 acts (Eval Vundef tvoid).
Definition act11:=Eval cbv [acts nth] in nth 11 acts (Eval Vundef tvoid).
Definition act12:=Eval cbv [acts nth] in nth 12 acts (Eval Vundef tvoid).
Definition act13:=Eval cbv [acts nth] in nth 13 acts (Eval Vundef tvoid).
Definition act14:=Eval cbv [acts nth] in nth 14 acts (Eval Vundef tvoid).
Definition act15:=Eval cbv [acts nth] in nth 15 acts (Eval Vundef tvoid).
Definition act16:=Eval cbv [acts nth] in nth 16 acts (Eval Vundef tvoid).
Definition act17:=Eval cbv [acts nth] in nth 17 acts (Eval Vundef tvoid).
Definition act18:=Eval cbv [acts nth] in nth 18 acts (Eval Vundef tvoid).
Definition act19:=Eval cbv [acts nth] in nth 19 acts (Eval Vundef tvoid).
Lemma assign_float_any:forall ge e m l r b p rv x mf,
 typeof l=tfloat->pure_lval ge e m l=Some(b,p,Full)->pure_rval ge e m r=Some rv->
 sem_cast rv(typeof r)tfloat m=Some(Vsingle x)->Ptrofs.unsigned p+4<=Ptrofs.modulus->
 Mem.store Mfloat32 m b(Ptrofs.unsigned p)(Vsingle x)=Some mf->
 atomic_eval ge e m(Eassign l r tfloat)=Some(Vsingle x,mf).
Proof. intros;cbn[atomic_eval];rewrite H,dec_eq_true,H0,H1;unfold commit;rewrite H2.
 cbv[Cexec.do_assign_loc tfloat noattr access_mode type_is_volatile attr_of_type attr_volatile Mem.storev].
 rewrite zle_true by exact H3;rewrite H4;reflexivity. Qed.
Definition rhs(a:expr):expr:=match a with Eassign _ r _=>r|_=>Eval Vundef tvoid end.
Definition lhs(a:expr):expr:=match a with Eassign l _ _=>l|_=>Eval Vundef tvoid end.
Definition qtype:=tptr(Tstruct Source._FloatQuat noattr).
Definition rmtype:=tptr(Tstruct Source._FloatRMat noattr).
Definition qvar:=Evalof(Evar Source._q qtype)qtype.
Definition qfield(id:ident):expr:=Efield(Evalof(Ederef qvar(Tstruct Source._FloatQuat noattr))(Tstruct Source._FloatQuat noattr))id tfloat.
Lemma q_location:forall e m bp bq id delta,
 e!Source._q=Some(bp,qtype)->Mem.load Mptr m bp 0=Some(Vptr bq Ptrofs.zero)->
 (id=Source._qi /\ delta=0)\/(id=Source._qx /\ delta=4)\/(id=Source._qy /\ delta=8)\/(id=Source._qz /\ delta=12)->
 pure_lval Execution.ge e m(qfield id)=Some(bq,Ptrofs.repr delta,Full).
Proof. intros e m bp bq id delta LQ PQ ID;unfold qfield.
 replace(Ptrofs.repr delta)with(Ptrofs.add Ptrofs.zero(Ptrofs.repr delta))by(apply Ptrofs.add_zero_l).
 eapply struct_field;[unfold qvar,qtype;eapply pointer_variable;eauto|reflexivity|].
 destruct ID as[[-> ->]|[[-> ->]|[[-> ->]|[-> ->]]]];reflexivity. Qed.
Lemma q_value:forall e m bp bq id delta q,
 e!Source._q=Some(bp,qtype)->Mem.load Mptr m bp 0=Some(Vptr bq Ptrofs.zero)->
 (id=Source._qi /\ delta=0)\/(id=Source._qx /\ delta=4)\/(id=Source._qy /\ delta=8)\/(id=Source._qz /\ delta=12)->
 Mem.load Mfloat32 m bq delta=Some(Vsingle q)->
 pure_rval Execution.ge e m(Evalof(qfield id)tfloat)=Some(Vsingle q).
Proof. intros e m bp bq id delta q LQ PQ ID Q.
 change(match pure_lval Execution.ge e m(qfield id)with Some(b,ofs,bf)=>match Cexec.do_deref_loc Execution.ge PureDenotation.quiet_world tfloat m b ofs bf with Some(_,_,v)=>Some v|None=>None end|None=>None end=Some(Vsingle q)).
 rewrite(q_location e m bp bq id delta LQ PQ ID).
 assert(D:0<=delta<=12)by(destruct ID as[[-> ->]|[[-> ->]|[[-> ->]|[-> ->]]]];lia).
 cbv[Cexec.do_deref_loc tfloat noattr access_mode type_is_volatile attr_of_type attr_volatile Mem.loadv].
 rewrite(Ptrofs.unsigned_repr delta ltac:(change(0<=delta<=18446744073709551615);lia));rewrite zle_true by(change(delta+4<=18446744073709551616);lia);rewrite Q;reflexivity.
Qed.
Lemma rv0:forall e m bp bq qi,
 e!Source._q=Some(bp,qtype)->Mem.load Mptr m bp 0=Some(Vptr bq Ptrofs.zero)->
 Mem.load Mfloat32 m bq 0=Some(Vsingle qi)->
 pure_rval Execution.ge e m(rhs act0)=Some(Vfloat(Float.mul(Float.of_bits(Int64.repr 4609047870845172685))(Float.of_single qi))).
Proof. intros e m bp bq qi LQ PQ QI.
 change(match pure_rval Execution.ge e m(Evalof(qfield Source._qi)tfloat)with Some w=>sem_binary_operation Execution.ge Omul(Vfloat(Float.of_bits(Int64.repr 4609047870845172685)))tdouble w tfloat m|None=>None end=Some(Vfloat(Float.mul(Float.of_bits(Int64.repr 4609047870845172685))(Float.of_single qi)))).
 rewrite(q_value e m bp bq Source._qi 0 qi LQ PQ ltac:(left;auto) QI);reflexivity. Qed.
Definition rmvar:=Evalof(Evar Source._rm rmtype)rmtype.
Definition rmfield:=Efield(Evalof(Ederef rmvar(Tstruct Source._FloatRMat noattr))(Tstruct Source._FloatRMat noattr))Source._m(tarray tfloat 9).
Definition rmarray:=Evalof rmfield(tarray tfloat 9).
Lemma rm_field_location:forall e m bp br,
 e!Source._rm=Some(bp,rmtype)->Mem.load Mptr m bp 0=Some(Vptr br Ptrofs.zero)->
 pure_lval Execution.ge e m rmfield=Some(br,Ptrofs.zero,Full).
Proof. intros e m bp br LOOK LOAD;unfold rmfield.
 change(pure_lval Execution.ge e m(Efield(Evalof(Ederef rmvar(Tstruct Source._FloatRMat noattr))(Tstruct Source._FloatRMat noattr))Source._m(tarray tfloat 9))=Some(br,Ptrofs.zero,Full)).
 cbn[pure_lval pure_rval typeof];fold(pure_rval Execution.ge e m rmvar).
 assert(P:pure_rval Execution.ge e m rmvar=Some(Vptr br Ptrofs.zero))by(unfold rmvar,rmtype;eapply pointer_variable;eauto).
 rewrite P.
 change(Some(br,Ptrofs.add Ptrofs.zero(Ptrofs.repr 0),Full)=Some(br,Ptrofs.zero,Full));reflexivity.
Qed.
Lemma rm_array_value:forall e m bp br,
 e!Source._rm=Some(bp,rmtype)->Mem.load Mptr m bp 0=Some(Vptr br Ptrofs.zero)->
 pure_rval Execution.ge e m rmarray=Some(Vptr br Ptrofs.zero).
Proof. intros e m bp br LOOK LOAD;unfold rmarray.
 change(match pure_lval Execution.ge e m rmfield with Some(b,ofs,bf)=>match Cexec.do_deref_loc Execution.ge PureDenotation.quiet_world(tarray tfloat 9)m b ofs bf with Some(_,_,v)=>Some v|None=>None end|None=>None end=Some(Vptr br Ptrofs.zero)).
 rewrite(rm_field_location e m bp br LOOK LOAD);reflexivity.
Qed.
Definition index0:=Ebinop Oadd(Ebinop Omul(Eval(Vint(Int.repr 0))tint)(Eval(Vint(Int.repr 3))tint)tint)(Eval(Vint(Int.repr 0))tint)tint.
Lemma index_value0:forall e m,pure_rval Execution.ge e m index0=Some(Vint(Int.repr 0)).
Proof. intros;reflexivity. Qed.
Lemma rm_location0:forall e m bp br,
 e!Source._rm=Some(bp,rmtype)->Mem.load Mptr m bp 0=Some(Vptr br Ptrofs.zero)->
 pure_lval Execution.ge e m(lhs act11)=Some(br,Ptrofs.repr 0,Full).
Proof. intros e m bp br LOOK LOAD.
 change(match (match pure_rval Execution.ge e m rmarray,pure_rval Execution.ge e m index0 with
 |Some v,Some w=>sem_binary_operation Execution.ge Oadd v(tarray tfloat 9)w tint m|_,_=>None end) with
 |Some(Vptr b ofs)=>Some(b,ofs,Full)|_=>None end=Some(br,Ptrofs.repr 0,Full)).
 rewrite(rm_array_value e m bp br LOOK LOAD),(index_value0 e m);reflexivity. Qed.
Definition index1:=Ebinop Oadd(Ebinop Omul(Eval(Vint(Int.repr 0))tint)(Eval(Vint(Int.repr 3))tint)tint)(Eval(Vint(Int.repr 1))tint)tint.
Lemma index_value1:forall e m,pure_rval Execution.ge e m index1=Some(Vint(Int.repr 1)).
Proof. intros;reflexivity. Qed.
Lemma rm_location1:forall e m bp br,
 e!Source._rm=Some(bp,rmtype)->Mem.load Mptr m bp 0=Some(Vptr br Ptrofs.zero)->
 pure_lval Execution.ge e m(lhs act12)=Some(br,Ptrofs.repr 4,Full).
Proof. intros e m bp br LOOK LOAD.
 change(match (match pure_rval Execution.ge e m rmarray,pure_rval Execution.ge e m index1 with
 |Some v,Some w=>sem_binary_operation Execution.ge Oadd v(tarray tfloat 9)w tint m|_,_=>None end) with
 |Some(Vptr b ofs)=>Some(b,ofs,Full)|_=>None end=Some(br,Ptrofs.repr 4,Full)).
 rewrite(rm_array_value e m bp br LOOK LOAD),(index_value1 e m);reflexivity. Qed.
Definition index2:=Ebinop Oadd(Ebinop Omul(Eval(Vint(Int.repr 0))tint)(Eval(Vint(Int.repr 3))tint)tint)(Eval(Vint(Int.repr 2))tint)tint.
Lemma index_value2:forall e m,pure_rval Execution.ge e m index2=Some(Vint(Int.repr 2)).
Proof. intros;reflexivity. Qed.
Lemma rm_location2:forall e m bp br,
 e!Source._rm=Some(bp,rmtype)->Mem.load Mptr m bp 0=Some(Vptr br Ptrofs.zero)->
 pure_lval Execution.ge e m(lhs act13)=Some(br,Ptrofs.repr 8,Full).
Proof. intros e m bp br LOOK LOAD.
 change(match (match pure_rval Execution.ge e m rmarray,pure_rval Execution.ge e m index2 with
 |Some v,Some w=>sem_binary_operation Execution.ge Oadd v(tarray tfloat 9)w tint m|_,_=>None end) with
 |Some(Vptr b ofs)=>Some(b,ofs,Full)|_=>None end=Some(br,Ptrofs.repr 8,Full)).
 rewrite(rm_array_value e m bp br LOOK LOAD),(index_value2 e m);reflexivity. Qed.
Definition index3:=Ebinop Oadd(Ebinop Omul(Eval(Vint(Int.repr 1))tint)(Eval(Vint(Int.repr 3))tint)tint)(Eval(Vint(Int.repr 0))tint)tint.
Lemma index_value3:forall e m,pure_rval Execution.ge e m index3=Some(Vint(Int.repr 3)).
Proof. intros;reflexivity. Qed.
Lemma rm_location3:forall e m bp br,
 e!Source._rm=Some(bp,rmtype)->Mem.load Mptr m bp 0=Some(Vptr br Ptrofs.zero)->
 pure_lval Execution.ge e m(lhs act14)=Some(br,Ptrofs.repr 12,Full).
Proof. intros e m bp br LOOK LOAD.
 change(match (match pure_rval Execution.ge e m rmarray,pure_rval Execution.ge e m index3 with
 |Some v,Some w=>sem_binary_operation Execution.ge Oadd v(tarray tfloat 9)w tint m|_,_=>None end) with
 |Some(Vptr b ofs)=>Some(b,ofs,Full)|_=>None end=Some(br,Ptrofs.repr 12,Full)).
 rewrite(rm_array_value e m bp br LOOK LOAD),(index_value3 e m);reflexivity. Qed.
Definition index4:=Ebinop Oadd(Ebinop Omul(Eval(Vint(Int.repr 1))tint)(Eval(Vint(Int.repr 3))tint)tint)(Eval(Vint(Int.repr 1))tint)tint.
Lemma index_value4:forall e m,pure_rval Execution.ge e m index4=Some(Vint(Int.repr 4)).
Proof. intros;reflexivity. Qed.
Lemma rm_location4:forall e m bp br,
 e!Source._rm=Some(bp,rmtype)->Mem.load Mptr m bp 0=Some(Vptr br Ptrofs.zero)->
 pure_lval Execution.ge e m(lhs act15)=Some(br,Ptrofs.repr 16,Full).
Proof. intros e m bp br LOOK LOAD.
 change(match (match pure_rval Execution.ge e m rmarray,pure_rval Execution.ge e m index4 with
 |Some v,Some w=>sem_binary_operation Execution.ge Oadd v(tarray tfloat 9)w tint m|_,_=>None end) with
 |Some(Vptr b ofs)=>Some(b,ofs,Full)|_=>None end=Some(br,Ptrofs.repr 16,Full)).
 rewrite(rm_array_value e m bp br LOOK LOAD),(index_value4 e m);reflexivity. Qed.
Definition index5:=Ebinop Oadd(Ebinop Omul(Eval(Vint(Int.repr 1))tint)(Eval(Vint(Int.repr 3))tint)tint)(Eval(Vint(Int.repr 2))tint)tint.
Lemma index_value5:forall e m,pure_rval Execution.ge e m index5=Some(Vint(Int.repr 5)).
Proof. intros;reflexivity. Qed.
Lemma rm_location5:forall e m bp br,
 e!Source._rm=Some(bp,rmtype)->Mem.load Mptr m bp 0=Some(Vptr br Ptrofs.zero)->
 pure_lval Execution.ge e m(lhs act16)=Some(br,Ptrofs.repr 20,Full).
Proof. intros e m bp br LOOK LOAD.
 change(match (match pure_rval Execution.ge e m rmarray,pure_rval Execution.ge e m index5 with
 |Some v,Some w=>sem_binary_operation Execution.ge Oadd v(tarray tfloat 9)w tint m|_,_=>None end) with
 |Some(Vptr b ofs)=>Some(b,ofs,Full)|_=>None end=Some(br,Ptrofs.repr 20,Full)).
 rewrite(rm_array_value e m bp br LOOK LOAD),(index_value5 e m);reflexivity. Qed.
Definition index6:=Ebinop Oadd(Ebinop Omul(Eval(Vint(Int.repr 2))tint)(Eval(Vint(Int.repr 3))tint)tint)(Eval(Vint(Int.repr 0))tint)tint.
Lemma index_value6:forall e m,pure_rval Execution.ge e m index6=Some(Vint(Int.repr 6)).
Proof. intros;reflexivity. Qed.
Lemma rm_location6:forall e m bp br,
 e!Source._rm=Some(bp,rmtype)->Mem.load Mptr m bp 0=Some(Vptr br Ptrofs.zero)->
 pure_lval Execution.ge e m(lhs act17)=Some(br,Ptrofs.repr 24,Full).
Proof. intros e m bp br LOOK LOAD.
 change(match (match pure_rval Execution.ge e m rmarray,pure_rval Execution.ge e m index6 with
 |Some v,Some w=>sem_binary_operation Execution.ge Oadd v(tarray tfloat 9)w tint m|_,_=>None end) with
 |Some(Vptr b ofs)=>Some(b,ofs,Full)|_=>None end=Some(br,Ptrofs.repr 24,Full)).
 rewrite(rm_array_value e m bp br LOOK LOAD),(index_value6 e m);reflexivity. Qed.
Definition index7:=Ebinop Oadd(Ebinop Omul(Eval(Vint(Int.repr 2))tint)(Eval(Vint(Int.repr 3))tint)tint)(Eval(Vint(Int.repr 1))tint)tint.
Lemma index_value7:forall e m,pure_rval Execution.ge e m index7=Some(Vint(Int.repr 7)).
Proof. intros;reflexivity. Qed.
Lemma rm_location7:forall e m bp br,
 e!Source._rm=Some(bp,rmtype)->Mem.load Mptr m bp 0=Some(Vptr br Ptrofs.zero)->
 pure_lval Execution.ge e m(lhs act18)=Some(br,Ptrofs.repr 28,Full).
Proof. intros e m bp br LOOK LOAD.
 change(match (match pure_rval Execution.ge e m rmarray,pure_rval Execution.ge e m index7 with
 |Some v,Some w=>sem_binary_operation Execution.ge Oadd v(tarray tfloat 9)w tint m|_,_=>None end) with
 |Some(Vptr b ofs)=>Some(b,ofs,Full)|_=>None end=Some(br,Ptrofs.repr 28,Full)).
 rewrite(rm_array_value e m bp br LOOK LOAD),(index_value7 e m);reflexivity. Qed.
Definition index8:=Ebinop Oadd(Ebinop Omul(Eval(Vint(Int.repr 2))tint)(Eval(Vint(Int.repr 3))tint)tint)(Eval(Vint(Int.repr 2))tint)tint.
Lemma index_value8:forall e m,pure_rval Execution.ge e m index8=Some(Vint(Int.repr 8)).
Proof. intros;reflexivity. Qed.
Lemma rm_location8:forall e m bp br,
 e!Source._rm=Some(bp,rmtype)->Mem.load Mptr m bp 0=Some(Vptr br Ptrofs.zero)->
 pure_lval Execution.ge e m(lhs act19)=Some(br,Ptrofs.repr 32,Full).
Proof. intros e m bp br LOOK LOAD.
 change(match (match pure_rval Execution.ge e m rmarray,pure_rval Execution.ge e m index8 with
 |Some v,Some w=>sem_binary_operation Execution.ge Oadd v(tarray tfloat 9)w tint m|_,_=>None end) with
 |Some(Vptr b ofs)=>Some(b,ofs,Full)|_=>None end=Some(br,Ptrofs.repr 32,Full)).
 rewrite(rm_array_value e m bp br LOOK LOAD),(index_value8 e m);reflexivity. Qed.
Definition scalar(id:ident):expr:=Evalof(Evar id tfloat)tfloat.
Lemma mul_value:forall e m a b x y,
 typeof a=tfloat->typeof b=tfloat->pure_rval Execution.ge e m a=Some(Vsingle x)->pure_rval Execution.ge e m b=Some(Vsingle y)->
 pure_rval Execution.ge e m(Ebinop Omul a b tfloat)=Some(Vsingle(Float32.mul x y)).
Proof. intros;cbn[pure_rval];rewrite H1,H2,H,H0;reflexivity. Qed.
Lemma add_value:forall e m a b x y,
 typeof a=tfloat->typeof b=tfloat->pure_rval Execution.ge e m a=Some(Vsingle x)->pure_rval Execution.ge e m b=Some(Vsingle y)->
 pure_rval Execution.ge e m(Ebinop Oadd a b tfloat)=Some(Vsingle(Float32.add x y)).
Proof. intros;cbn[pure_rval];rewrite H1,H2,H,H0;reflexivity. Qed.
Lemma sub_value:forall e m a b x y,
 typeof a=tfloat->typeof b=tfloat->pure_rval Execution.ge e m a=Some(Vsingle x)->pure_rval Execution.ge e m b=Some(Vsingle y)->
 pure_rval Execution.ge e m(Ebinop Osub a b tfloat)=Some(Vsingle(Float32.sub x y)).
Proof. intros;cbn[pure_rval];rewrite H1,H2,H,H0;reflexivity. Qed.
Lemma subtract_one:forall e m a x,
 typeof a=tfloat->pure_rval Execution.ge e m a=Some(Vsingle x)->
 pure_rval Execution.ge e m(Ebinop Osub a(Eval(Vint(Int.repr 1))tint)tfloat)=Some(Vsingle(Float32.sub x(Float32.of_int(Int.repr 1)))).
Proof. intros;cbn[pure_rval];rewrite H0,H;reflexivity. Qed.
