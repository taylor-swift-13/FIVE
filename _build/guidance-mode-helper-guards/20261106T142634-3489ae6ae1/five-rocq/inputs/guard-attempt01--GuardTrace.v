From Stdlib Require Import List Bool ZArith Lia.
From compcert Require Import Coqlib Maps Integers Floats Values Memory Ctypes Cop Csyntax Csyntaxdefs.
From FiveGuidanceSoftwareProof Require Import ValueEvaluator SourceCertificate.
Import ListNotations.
Local Open Scope Z_scope.
Inductive integer_guard:=
 |SignedAdd(a b:expr)|SignedSub(a b:expr)
 |Unsigned32ToSigned(a:expr)|Unsigned64ToUnsigned32(a:expr)|Signed32ToUnsigned(a:expr).
Definition guard_of(a:expr):option integer_guard:=
 match a with
 |Ebinop Oadd l r ty=>if type_eq ty tint then Some(SignedAdd l r)else None
 |Ebinop Osub l r ty=>if type_eq ty tint then Some(SignedSub l r)else None
 |Ecast a ty=>if type_eq ty tint then if type_eq(typeof a)tuint then Some(Unsigned32ToSigned a)else None
 else if type_eq ty tuint then if type_eq(typeof a)tulong then Some(Unsigned64ToUnsigned32 a)
 else if type_eq(typeof a)tint then Some(Signed32ToUnsigned a)else None else None
 |_=>None end.
Fixpoint expression_sites(a:expr):list integer_guard:=
 let own:=match guard_of a with Some g=>[g]|None=>[]end in
 (match a with
 |Eunop _ b _|Ecast b _=>expression_sites b
 |Ebinop _ b c _|Eassign b c _=>expression_sites b++expression_sites c
 |_=>[]end)++own.
Fixpoint statement_sites(s:statement):list integer_guard:=
 match s with
 |Sdo a|Sreturn(Some a)=>expression_sites a
 |Ssequence a b=>statement_sites a++statement_sites b
 |Sifthenelse c a b=>expression_sites c++statement_sites a++statement_sites b
 |_=>[]end.
Record guard_event:=GuardEvent {event_id:nat;event_guard:integer_guard;event_env:PTree.t val}.
Fixpoint expression_trace(offset:nat)(rho:PTree.t val)(a:expr):list guard_event:=
 let children:=match a with
 |Eunop _ b _|Ecast b _=>expression_trace offset rho b
 |Ebinop _ b c _|Eassign b c _=>expression_trace offset rho b++expression_trace(offset+length(expression_sites b))rho c
 |_=>[]end in
 children++match guard_of a with Some g=>[GuardEvent(offset+length(expression_sites a)-1)g rho]|None=>[]end.
Section TRACE.
Variables uid ff uf:positive.
Variable gamma:PTree.t type.
Local Notation ve:=(value_expr uid ff uf gamma).
Local Notation va:=(value_assign uid ff uf gamma).
Local Notation vs:=(value_statement uid ff uf gamma).
Fixpoint statement_trace(offset:nat)(rho:PTree.t val)(s:statement):option(value_outcome*list guard_event):=
 match s with
 |Sskip=>Some(ValueNormal rho,[])
 |Sdo(Eassign l r ty)=>match va rho l r ty with
  |Some rho'=>Some(ValueNormal rho',expression_trace offset rho(Eassign l r ty))|None=>None end
 |Ssequence a b=>match statement_trace offset rho a with
  |Some(ValueNormal rho',ta)=>match statement_trace(offset+length(statement_sites a))rho' b with
   |Some(o,tb)=>Some(o,ta++tb)|None=>None end
  |Some(o,ta)=>Some(o,ta)|None=>None end
 |Sifthenelse c yes no=>match ve rho c with
  |Some v=>match bool_val v(typeof c)Mem.empty with
   |Some choose=>match statement_trace
    (offset+length(expression_sites c)+(if choose then 0 else length(statement_sites yes)))rho(if choose then yes else no)with
    |Some(o,t)=>Some(o,expression_trace offset rho c++t)|None=>None end
   |None=>None end|None=>None end
 |Sreturn(Some a)=>match ve rho a with Some v=>Some(ValueReturn v(typeof a)rho,expression_trace offset rho a)|None=>None end
 |_=>None end.
Lemma trace_erases:forall s offset rho o events,
 statement_trace offset rho s=Some(o,events)->vs rho s=Some o.
Proof.
 induction s;intros off rho out events H;cbn[statement_trace]in H;try discriminate.
 - inversion H;reflexivity.
 - destruct e;try discriminate;destruct(va rho e1 e2 ty)eqn:A;try discriminate;inversion H;cbn[value_statement];rewrite A;reflexivity.
 - destruct(statement_trace off rho s1)as[[o1 t1]|]eqn:T1;try discriminate.
   pose proof(IHs1 _ _ _ _ T1)as V1;destruct o1 as[rho1|v ty rho1].
   + destruct(statement_trace(off+length(statement_sites s1))rho1 s2)as[[o2 t2]|]eqn:T2;try discriminate.
     inversion H;subst;cbn[value_statement];rewrite V1;apply IHs2 in T2;exact T2.
   + inversion H;subst;cbn[value_statement];rewrite V1;reflexivity.
 - destruct(ve rho e)as[v|]eqn:V;try discriminate.
   destruct(bool_val v(typeof e)Mem.empty)as[b|]eqn:B;try discriminate;destruct b.
   + destruct(statement_trace(off+length(expression_sites e)+0)rho s1)as[[o t]|]eqn:T;try discriminate.
     inversion H;subst;cbn[value_statement];rewrite V,B;apply IHs1 in T;exact T.
   + destruct(statement_trace(off+length(expression_sites e)+length(statement_sites s1))rho s2)as[[o t]|]eqn:T;try discriminate.
     inversion H;subst;cbn[value_statement];rewrite V,B;apply IHs2 in T;exact T.
 - destruct o as[a|];try discriminate;destruct(ve rho a)as[v|]eqn:V;try discriminate;inversion H;subst;cbn[value_statement];rewrite V;reflexivity.
Qed.
Definition guard_safe(g:integer_guard)(rho:PTree.t val):Prop:=
 match g with
 |SignedAdd a b=>match ve rho a,ve rho b with Some(Vint x),Some(Vint y)=>Int.min_signed<=Int.signed x+Int.signed y<=Int.max_signed|_,_=>False end
 |SignedSub a b=>match ve rho a,ve rho b with Some(Vint x),Some(Vint y)=>Int.min_signed<=Int.signed x-Int.signed y<=Int.max_signed|_,_=>False end
 |Unsigned32ToSigned a=>match ve rho a with Some(Vint x)=>Int.unsigned x<=Int.max_signed|_=>False end
 |Unsigned64ToUnsigned32 a=>match ve rho a with Some(Vlong x)=>Int64.unsigned x<=Int.max_unsigned|_=>False end
 |Signed32ToUnsigned a=>match ve rho a with Some(Vint x)=>0<=Int.signed x|_=>False end
 end.
Definition guard_check(g:integer_guard)(rho:PTree.t val):bool:=
 match g with
 |SignedAdd a b=>match ve rho a,ve rho b with Some(Vint x),Some(Vint y)=>(Int.min_signed<=?Int.signed x+Int.signed y)&&(Int.signed x+Int.signed y<=?Int.max_signed)|_,_=>false end
 |SignedSub a b=>match ve rho a,ve rho b with Some(Vint x),Some(Vint y)=>(Int.min_signed<=?Int.signed x-Int.signed y)&&(Int.signed x-Int.signed y<=?Int.max_signed)|_,_=>false end
 |Unsigned32ToSigned a=>match ve rho a with Some(Vint x)=>Int.unsigned x<=?Int.max_signed|_=>false end
 |Unsigned64ToUnsigned32 a=>match ve rho a with Some(Vlong x)=>Int64.unsigned x<=?Int.max_unsigned|_=>false end
 |Signed32ToUnsigned a=>match ve rho a with Some(Vint x)=>0<=?Int.signed x|_=>false end
 end.
Lemma guard_check_sound:forall g rho,guard_check g rho=true->guard_safe g rho.
Proof.
 intros g rho;destruct g;cbn[guard_check guard_safe];
 repeat match goal with |-context[ve rho ?a]=>destruct(ve rho a)as[v|]eqn:?;[destruct v|]end;
 intros H;try discriminate;try(apply Z.leb_le;exact H);
 apply andb_true_iff in H as[A B];split;apply Z.leb_le;assumption.
Qed.
Definition event_safe(e:guard_event):Prop:=guard_safe(event_guard e)(event_env e).
Definition events_checked(events:list guard_event):bool:=forallb(fun e=>guard_check(event_guard e)(event_env e))events.
Lemma events_checked_sound:forall events,events_checked events=true->forall e,In e events->event_safe e.
Proof. intros events H e IN;apply guard_check_sound;apply forallb_forall with(x:=e)in H;assumption. Qed.
End TRACE.
Definition canonical_sat_x:float32:=Float32.of_bits(Int.repr 1092608000).
Definition canonical_negative_zero:float32:=Float32.of_bits(Int.repr 2147483648).
Definition canonical_sat_norm:float32:=Float32.add(Float32.mul canonical_sat_x canonical_sat_x)(Float32.mul canonical_negative_zero canonical_negative_zero).
Definition helper_trace(x:float32):option(value_outcome*list guard_event):=
 statement_trace S._FiveSqrtBits S._f S._u helper_types 0
 (PTree.set S._x(Vsingle x)(PTree.empty val))(fn_body S.f_five_sqrtf).
Lemma helper_sites_53:length(statement_sites(fn_body S.f_five_sqrtf))=53%nat.
Proof. vm_compute;reflexivity. Qed.
Definition canonical_guard_trace:list guard_event:=match helper_trace canonical_sat_norm with Some(_,t)=>t|None=>[]end.
Lemma canonical_guards_checked:events_checked S._FiveSqrtBits S._f S._u helper_types canonical_guard_trace=true.
Proof. vm_compute;reflexivity. Qed.
Theorem canonical_guards_safe:forall e,In e canonical_guard_trace->event_safe S._FiveSqrtBits S._f S._u helper_types e.
Proof. apply events_checked_sound;exact canonical_guards_checked. Qed.
Print Assumptions canonical_guards_safe.
