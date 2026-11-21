From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Maps Integers Floats AST Values Memory Memdata Events Ctypes Cop Csyntax Csyntaxdefs Csem Cexec.
From FiveGuidanceAllOrder Require Import PureDenotation AtomicDenotation CallfreeExecution.
From FiveGuidanceAllocation Require Import StackAllocation.
From FiveQuatVmult Require Import Source Execution.
From FiveQuatVmultCase Require Import Contract.
Import ListNotations.
Local Open Scope Z_scope.
Fixpoint statements(s:statement):list expr:=match s with Sdo a=>[a]|Ssequence a b=>statements a++statements b|_=>[]end.
Definition acts:=Eval cbv [statements Source.f_float_quat_vmult fn_body app] in statements(fn_body Source.f_float_quat_vmult).
Definition qparam(q v out:block):PTree.t val:=PTree.set Source._v_out(Vptr out Ptrofs.zero)(PTree.set Source._q(Vptr q Ptrofs.zero)(PTree.set Source._v_in(Vptr v Ptrofs.zero)(PTree.empty val))).
Definition declares:=fn_params Source.f_float_quat_vmult++fn_vars Source.f_float_quat_vmult.
Definition env_matches(e:env):Prop:=forall id ty,In(id,ty)declares->exists b,e!id=Some(b,ty).
Ltac local_look id ty := match goal with ENV:env_matches ?e|-_=>
 let b:=fresh "b"in let L:=fresh "L"in destruct(ENV id ty ltac:(vm_compute;auto 30))as[b L]end.
Definition act0:=Eval cbv [acts nth] in nth 0 acts(Eval Vundef tvoid).
Definition act1:=Eval cbv [acts nth] in nth 1 acts(Eval Vundef tvoid).
Definition act2:=Eval cbv [acts nth] in nth 2 acts(Eval Vundef tvoid).
Definition act3:=Eval cbv [acts nth] in nth 3 acts(Eval Vundef tvoid).
Definition act4:=Eval cbv [acts nth] in nth 4 acts(Eval Vundef tvoid).
Definition act5:=Eval cbv [acts nth] in nth 5 acts(Eval Vundef tvoid).
Definition act6:=Eval cbv [acts nth] in nth 6 acts(Eval Vundef tvoid).
Definition act7:=Eval cbv [acts nth] in nth 7 acts(Eval Vundef tvoid).
Definition act8:=Eval cbv [acts nth] in nth 8 acts(Eval Vundef tvoid).
Definition act9:=Eval cbv [acts nth] in nth 9 acts(Eval Vundef tvoid).
Definition act10:=Eval cbv [acts nth] in nth 10 acts(Eval Vundef tvoid).
Definition act11:=Eval cbv [acts nth] in nth 11 acts(Eval Vundef tvoid).
Definition act12:=Eval cbv [acts nth] in nth 12 acts(Eval Vundef tvoid).
Definition act13:=Eval cbv [acts nth] in nth 13 acts(Eval Vundef tvoid).
Definition act14:=Eval cbv [acts nth] in nth 14 acts(Eval Vundef tvoid).
Definition act15:=Eval cbv [acts nth] in nth 15 acts(Eval Vundef tvoid).
Definition act16:=Eval cbv [acts nth] in nth 16 acts(Eval Vundef tvoid).
Definition act17:=Eval cbv [acts nth] in nth 17 acts(Eval Vundef tvoid).
Definition act18:=Eval cbv [acts nth] in nth 18 acts(Eval Vundef tvoid).
Ltac ctx_repr rho e m:=match goal with
 | C:Context e _ _ _ _ _ _ _ _ _ _ rho m|-_=>let R:=fresh"REP"in assert(R:local_repr rho e m)by(destruct C;assumption);exact R
 end.
Ltac eval_rhs := lazymatch goal with
 | |- pure_rval ?ge ?e ?m(Eval ?v ?ty)=Some _=>reflexivity
 | |- pure_rval ?ge ?e ?m(Evalof(Evar ?id tfloat)tfloat)=Some ?result=>
   local_look id tfloat;
   match goal with L:e!id=Some(?b,tfloat),C:Context e _ _ _ _ _ _ _ _ _ _ ?rho m|-_=>
    let got:=eval hnf in(PTree.get id rho)in lazymatch got with Some(Vsingle ?x)=>unify result(Vsingle x);eapply(Contract.local_float e m rho id b x);[destruct C;assumption|exact L|reflexivity]end end
 | |- pure_rval ?ge ?e ?m(Evalof(Efield(Evalof(Ederef(Evalof(Evar ?id(tptr(Tstruct ?sid noattr)))(tptr(Tstruct ?sid noattr)))(Tstruct ?sid noattr))(Tstruct ?sid noattr))?fid tfloat)tfloat)=Some ?result=>
   local_look id (tptr(Tstruct sid noattr));
   match goal with L:e!id=Some(?bx,tptr(Tstruct sid noattr)),C:Context e ?q ?v ?out ?qi ?qx ?qy ?qz ?vx ?vy ?vz ?rho m|-_=>
    let delta:=eval vm_compute in (if peq fid Source._qi then 0 else if peq fid Source._qx then 4 else if peq fid Source._qy then 8 else if peq fid Source._qz then 12 else if peq fid Source._x then 0 else if peq fid Source._y then 4 else 8) in
    let value:=eval vm_compute in (if Pos.eqb id Source._q then if Z.eqb delta 0 then qi else if Z.eqb delta 4 then qx else if Z.eqb delta 8 then qy else qz else if Z.eqb delta 0 then vx else if Z.eqb delta 4 then vy else vz)in
    unify result (Vsingle value);
    let caller:=eval vm_compute in(if Pos.eqb id Source._q then q else v)in eapply(Contract.float_field e m rho id bx caller sid fid delta _ value);
    [destruct C;assumption|exact L|first[assumption|reflexivity]|reflexivity|reflexivity|lia|destruct C as[IN R W F];destruct IN;assumption]end
 | |- pure_rval ?ge ?e ?m(Ebinop ?op ?a ?b ?ty)=Some ?v=>
   let av:=fresh"av"in let bv:=fresh"bv"in let A:=fresh"A"in let B:=fresh"B"in
   evar(av:val);assert(A:pure_rval ge e m a=Some av)by(unfold av;eval_rhs);
   evar(bv:val);assert(B:pure_rval ge e m b=Some bv)by(unfold bv;eval_rhs);
   change(match pure_rval ge e m a,pure_rval ge e m b with Some va,Some vb=>sem_binary_operation ge op va(typeof a)vb(typeof b)m|_,_=>None end=Some v);
   rewrite A;try rewrite B;subst av bv;reflexivity
 | |- pure_rval ?ge ?e ?m(Ecast ?a ?ty)=Some ?v=>
   let av:=fresh"av"in let A:=fresh"A"in evar(av:val);assert(A:pure_rval ge e m a=Some av)by(unfold av;eval_rhs);
   change(match pure_rval ge e m a with Some va=>sem_cast va(typeof a)ty m|None=>None end=Some v);
   rewrite A;subst av;reflexivity
 end.
Definition rhs(a:expr):expr:=match a with Eassign _ r _|Eassignop _ _ r _ _=>r|_=>Eval Vundef tvoid end.
Definition local_id(a:expr):ident:=match a with Eassign(Evar id _) _ _|Eassignop _(Evar id _) _ _ _=>id|_=>Source._q end.
Ltac do_local action memory rho CT mn rn cn ev :=
 let original:=eval unfold action in action in
 let a:=lazymatch original with Eassignop ?op(Evar ?id tfloat)?r tfloat tfloat=>constr:(Eassign(Evar id tfloat)(Ebinop op(Evalof(Evar id tfloat)tfloat)r tfloat)tfloat)|_=>original end in
 lazymatch a with Eassign(Evar ?id tfloat)?r tfloat=>
 local_look id tfloat;
 match goal with LOOK:(?e)!id=Some(?b,tfloat),SEP:env_separated ?e,NL:Nonlocal ?e ?q ?v ?out|-_=>
 let rv:=fresh"rv"in let value:=fresh"value"in let RV:=fresh"RV"in let CAST:=fresh"CAST"in
 evar(rv:val);assert(RV:pure_rval Execution.ge e memory r=Some rv)by(unfold rv;eval_rhs);
 evar(value:float32);assert(CAST:sem_cast rv(typeof r)tfloat memory=Some(Vsingle value))by(unfold value,rv;reflexivity);
 let ST:=fresh"ST"in
 destruct(write_local e q v out _ _ _ _ _ _ _ rho memory id b r rv value SEP NL CT LOOK RV CAST)as[mn[ev[cn ST]]];
 pose(rn:=PTree.set id(Vsingle value)rho);fold rn in cn;
 match goal with H:stores e out ?mstart memory|-_=>let HN:=fresh"HIST"in
 assert(HN:stores e out mstart mn)by(eapply stores_step;[exact H|right;exists id,tfloat;exact LOOK|exact ST])end;
 lazymatch original with Eassignop ?op(Evar _ _) ?rr _ _=>
 let old:=fresh"old"in let OLD:=fresh"OLD"in let LOAD:=fresh"LOAD"in
 evar(old:float32);assert(OLD:rho!id=Some(Vsingle old))by(unfold old;reflexivity);
 assert(LOAD:Mem.load Mfloat32 memory b 0=Some(Vsingle old))by(destruct CT as[IN REP W F];exact(REP id b tfloat(Vsingle old)LOOK OLD));
 let RV2:=fresh"RV"in let rv2:=fresh"rv"in evar(rv2:val);assert(RV2:pure_rval Execution.ge e memory rr=Some rv2)by(unfold rv2;eval_rhs);
 rewrite<-(assignop_as_assign Execution.ge e memory id b rr op old rv2 LOOK LOAD RV2 eq_refl)in ev;fold action in ev
 | _=>fold action in ev end
 end
 end.
Definition X0(qi qx qy qz:float32):float32:=Float.to_single(Float.sub(Float.of_single(Float32.mul qi qi))(Float.of_bits(Int64.repr 4602678819172646912))).
Definition X1(qi qx qy qz:float32):float32:=Float32.mul qi qx.
Definition X2(qi qx qy qz:float32):float32:=Float32.mul qi qy.
Definition X3(qi qx qy qz:float32):float32:=Float32.mul qi qz.
Definition X4(qi qx qy qz:float32):float32:=Float32.mul qx qy.
Definition X5(qi qx qy qz:float32):float32:=Float32.mul qx qz.
Definition X6(qi qx qy qz:float32):float32:=Float32.mul qy qz.
Definition X7(qi qx qy qz:float32):float32:=Float32.add (X0 qi qx qy qz)(Float32.mul qx qx).
Definition X8(qi qx qy qz:float32):float32:=Float32.sub(X4 qi qx qy qz)(X3 qi qx qy qz).
Definition X9(qi qx qy qz:float32):float32:=Float32.add(X5 qi qx qy qz)(X2 qi qx qy qz).
Definition X10(qi qx qy qz:float32):float32:=Float32.sub(X6 qi qx qy qz)(X1 qi qx qy qz).
Definition X11(qi qx qy qz:float32):float32:=Float32.add(X4 qi qx qy qz)(X3 qi qx qy qz).
Definition X12(qi qx qy qz:float32):float32:=Float32.sub(X5 qi qx qy qz)(X2 qi qx qy qz).
Definition X13(qi qx qy qz:float32):float32:=Float32.add(X6 qi qx qy qz)(X1 qi qx qy qz).
Definition X14(qi qx qy qz:float32):float32:=Float32.add(X0 qi qx qy qz)(Float32.mul qy qy).
Definition X15(qi qx qy qz:float32):float32:=Float32.add(X0 qi qx qy qz)(Float32.mul qz qz).
Definition final_rho(q v out:block)(qi qx qy qz:float32):PTree.t val:=PTree.set Source._m22(Vsingle(X15 qi qx qy qz))(PTree.set Source._m11(Vsingle(X14 qi qx qy qz))(PTree.set Source._m12(Vsingle(X13 qi qx qy qz))(PTree.set Source._m02(Vsingle(X12 qi qx qy qz))(PTree.set Source._m01(Vsingle(X11 qi qx qy qz))(PTree.set Source._m21(Vsingle(X10 qi qx qy qz))(PTree.set Source._m20(Vsingle(X9 qi qx qy qz))(PTree.set Source._m10(Vsingle(X8 qi qx qy qz))(PTree.set Source._m00(Vsingle(X7 qi qx qy qz))(PTree.set Source._m12(Vsingle(X6 qi qx qy qz))(PTree.set Source._m02(Vsingle(X5 qi qx qy qz))(PTree.set Source._m01(Vsingle(X4 qi qx qy qz))(PTree.set Source._qiqz(Vsingle(X3 qi qx qy qz))(PTree.set Source._qiqy(Vsingle(X2 qi qx qy qz))(PTree.set Source._qiqx(Vsingle(X1 qi qx qy qz))(PTree.set Source._qi2_M1_2(Vsingle(X0 qi qx qy qz))(qparam q v out)))))))))))))))).
Definition prefix:=Eval cbv [acts firstn] in firstn 16 acts.
Fixpoint straight(actions:list expr):statement:=match actions with []=>Sskip|a::rest=>Ssequence(Sdo a)(straight rest)end.
Theorem locals_body:forall e m q v out qi qx qy qz vx vy vz,
 env_matches e->env_separated e->Nonlocal e q v out->
 Context e q v out qi qx qy qz vx vy vz(qparam q v out)m->
 exists mf,stmt_eval Execution.ge e tvoid(straight prefix)m=Some(Nnormal,mf) /\
 Context e q v out qi qx qy qz vx vy vz(final_rho q v out qi qx qy qz)mf /\ stores e out m mf.
Proof.
 intros e m q v out qi qx qy qz vx vy vz ENV SEP NL CT.
 assert(HIST:stores e out m m)by constructor.
 do_local act0 m (qparam q v out) CT m1 rho1 CT1 EV0.
 do_local act1 m1 rho1 CT1 m2 rho2 CT2 EV1.
 do_local act2 m2 rho2 CT2 m3 rho3 CT3 EV2.
 do_local act3 m3 rho3 CT3 m4 rho4 CT4 EV3.
 do_local act4 m4 rho4 CT4 m5 rho5 CT5 EV4.
 do_local act5 m5 rho5 CT5 m6 rho6 CT6 EV5.
 do_local act6 m6 rho6 CT6 m7 rho7 CT7 EV6.
 do_local act7 m7 rho7 CT7 m8 rho8 CT8 EV7.
 do_local act8 m8 rho8 CT8 m9 rho9 CT9 EV8.
 do_local act9 m9 rho9 CT9 m10 rho10 CT10 EV9.
 do_local act10 m10 rho10 CT10 m11 rho11 CT11 EV10.
 do_local act11 m11 rho11 CT11 m12 rho12 CT12 EV11.
 do_local act12 m12 rho12 CT12 m13 rho13 CT13 EV12.
 do_local act13 m13 rho13 CT13 m14 rho14 CT14 EV13.
 do_local act14 m14 rho14 CT14 m15 rho15 CT15 EV14.
 do_local act15 m15 rho15 CT15 m16 rho16 CT16 EV15.
 exists m16;split.
 - change(stmt_eval Execution.ge e tvoid(straight[act0;act1;act2;act3;act4;act5;act6;act7;act8;act9;act10;act11;act12;act13;act14;act15])m=Some(Nnormal,m16)).
   cbn[straight stmt_eval];rewrite EV0.
   cbn[straight stmt_eval];rewrite EV1.
   cbn[straight stmt_eval];rewrite EV2.
   cbn[straight stmt_eval];rewrite EV3.
   cbn[straight stmt_eval];rewrite EV4.
   cbn[straight stmt_eval];rewrite EV5.
   cbn[straight stmt_eval];rewrite EV6.
   cbn[straight stmt_eval];rewrite EV7.
   cbn[straight stmt_eval];rewrite EV8.
   cbn[straight stmt_eval];rewrite EV9.
   cbn[straight stmt_eval];rewrite EV10.
   cbn[straight stmt_eval];rewrite EV11.
   cbn[straight stmt_eval];rewrite EV12.
   cbn[straight stmt_eval];rewrite EV13.
   cbn[straight stmt_eval];rewrite EV14.
   cbn[straight stmt_eval];rewrite EV15.
   reflexivity.
 - split;[exact CT16|assumption].
Qed.
Ltac do_output action memory rho CT fid delta mn cn ev st :=
 let original:=eval unfold action in action in
 lazymatch original with Eassign ?l ?r tfloat=>
 local_look Source._v_out vtype;
 match goal with LOOK:?e!Source._v_out=Some(?bp,vtype),NL:Nonlocal ?e ?q ?v ?out|-_=>
 let value:=fresh"value"in let RV:=fresh"RV"in evar(value:float32);
 assert(RV:pure_rval Execution.ge e memory r=Some(Vsingle value))by(unfold value;eval_rhs);
 destruct(write_output e memory rho bp q v out _ _ _ _ _ _ _ fid delta r value NL CT LOOK ltac:(reflexivity) ltac:(simpl;auto) RV eq_refl)as[mn[ev[cn st]]];change(atomic_eval Execution.ge e memory action=Some(Vsingle value,mn))in ev
 end end.
Definition output_x(qi qx qy qz vx vy vz:float32):float32:=let '(x,y,z):=Direct qi qx qy qz vx vy vz in x.
Definition output_y(qi qx qy qz vx vy vz:float32):float32:=let '(x,y,z):=Direct qi qx qy qz vx vy vz in y.
Definition output_z(qi qx qy qz vx vy vz:float32):float32:=let '(x,y,z):=Direct qi qx qy qz vx vy vz in z.
Definition tail3:=Ssequence(Sdo act16)(Ssequence(Sdo act17)(Sdo act18)).
Lemma source_parts:fn_body Source.f_float_quat_vmult=
 fold_right(fun a tail=>Ssequence(Sdo a)tail)tail3 prefix.
Proof. reflexivity. Qed.
Lemma prefix_composition:forall ge e ret prefix tail m mm mf,
 stmt_eval ge e ret(straight prefix)m=Some(Nnormal,mm)->
 stmt_eval ge e ret tail mm=Some(Nnormal,mf)->
 stmt_eval ge e ret(fold_right(fun a rest=>Ssequence(Sdo a)rest)tail prefix)m=Some(Nnormal,mf).
Proof.
 intros ge e ret pref;induction pref as[|a pref IH];intros tail m mm mf P T;cbn[straight stmt_eval]in P;[inversion P;subst;exact T|].
 cbn[fold_right stmt_eval];destruct(atomic_eval ge e m a)as[[v ma]|]eqn:A;try discriminate.
 eapply IH;eauto.
Qed.
Theorem body_summary:forall e m q v out qi qx qy qz vx vy vz,
 env_matches e->env_separated e->Nonlocal e q v out->
 Context e q v out qi qx qy qz vx vy vz(qparam q v out)m->
 exists mf,
 stmt_eval Execution.ge e tvoid(fn_body Source.f_float_quat_vmult)m=Some(Nnormal,mf) /\
 Context e q v out qi qx qy qz vx vy vz(final_rho q v out qi qx qy qz)mf /\
 stores e out m mf /\
 exists m1 m2,
 Mem.store Mfloat32 m1 out 4(Vsingle(output_y qi qx qy qz vx vy vz))=Some m2 /\
 Mem.store Mfloat32 m2 out 8(Vsingle(output_z qi qx qy qz vx vy vz))=Some mf /\
 exists ml,Mem.store Mfloat32 ml out 0(Vsingle(output_x qi qx qy qz vx vy vz))=Some m1.
Proof.
 intros e m q v out qi qx qy qz vx vy vz ENV SEP NL CT.
 destruct(locals_body e m q v out qi qx qy qz vx vy vz ENV SEP NL CT)as[ml[EL[CL HL]]].
 do_output act16 ml(final_rho q v out qi qx qy qz)CL Source._x 0 m1 C1 EV16 ST16.
 do_output act17 m1(final_rho q v out qi qx qy qz)C1 Source._y 4 m2 C2 EV17 ST17.
 do_output act18 m2(final_rho q v out qi qx qy qz)C2 Source._z 8 m3 C3 EV18 ST18.
 exists m3;split.
 - rewrite source_parts;eapply prefix_composition;[exact EL|].
   unfold tail3;cbn[stmt_eval];rewrite EV16,EV17,EV18;reflexivity.
 - split;[exact C3|];split.
   + eapply stores_step with(ch:=Mfloat32)(b:=out)(ofs:=8);[|left;repeat split;cbn[size_chunk];lia|exact ST18].
     eapply stores_step with(ch:=Mfloat32)(b:=out)(ofs:=4);[|left;repeat split;cbn[size_chunk];lia|exact ST17].
     eapply stores_step with(ch:=Mfloat32)(b:=out)(ofs:=0);[exact HL|left;repeat split;cbn[size_chunk];lia|exact ST16].
   + exists m1,m2;split;[exact ST17|];split;[exact ST18|exists ml;exact ST16].
Qed.
