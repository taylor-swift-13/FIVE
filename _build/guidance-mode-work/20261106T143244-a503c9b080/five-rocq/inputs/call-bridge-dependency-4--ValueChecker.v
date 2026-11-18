From Stdlib Require Import Bool List ZArith Lia.
From compcert Require Import Coqlib Errors Maps Integers Floats AST Values Memory Ctypes Cop Csyntax Csyntaxdefs Csem.
From FiveGuidanceSoftwareProof Require Import ValueEvaluator NumericOps.
Import ListNotations.
Definition has_id(id:ident)(xs:list ident):bool:=existsb(Pos.eqb id)xs.
Lemma has_id_true:forall id xs,has_id id xs=true <-> In id xs.
Proof.
 intros id xs;unfold has_id;rewrite existsb_exists;split.
 - intros[x[IN EQ]];apply Pos.eqb_eq in EQ;subst;exact IN.
 - intros IN;exists id;split;[exact IN|apply Pos.eqb_refl].
Qed.
Definition scalar_type(ty:type):bool:=match numeric_kind ty with Some _=>true|None=>false end.
Definition literal_typed(ty:type)(v:val):bool:=
 match numeric_kind ty,v with Some K32,Vint _|Some K64,Vlong _|Some KF32,Vsingle _=>true|_,_=>false end.
Lemma literal_typed_sound:forall ty v,literal_typed ty v=true ->typed_value ty v.
Proof. intros ty v;unfold literal_typed,typed_value;destruct(numeric_kind ty)as[k|];[destruct k|];destruct v;simpl;intros;try discriminate;exact I. Qed.
Section CERTIFICATE.
Variables union_id float_field uint_field:ident.
Variable gamma:PTree.t type.
Local Notation place :=(place_of union_id float_field uint_field gamma).
Fixpoint check_expr(initialized:list ident)(a:expr):bool:=
 match a with
 |Eval v ty=>literal_typed ty v
 |Evalof l ty=>if type_eq ty(typeof l)then
   match place l with Some p=>has_id(place_id p)initialized && scalar_type ty|None=>false end else false
 |Eunop op a ty=>check_expr initialized a && safe_unop op(typeof a)ty
 |Ebinop op a b ty=>check_expr initialized a && check_expr initialized b && safe_binop op(typeof a)(typeof b)ty(literal_value b)
 |Ecast a ty=>check_expr initialized a && safe_cast(typeof a)ty
 |_=>false end.
Definition check_assign(initialized:list ident)(l r:expr)(ty:type):option(list ident):=
 if type_eq ty(typeof l)then
 match place l with
 |Some p=>if check_expr initialized r && safe_cast(typeof r)(typeof l)then Some(place_id p::initialized)else None
 |None=>None end else None.
Inductive static_outcome:=StaticNormal(initialized:list ident)|StaticReturn.
Definition initialized_intersection(xs ys:list ident):list ident:=filter(fun id=>has_id id ys)xs.
Definition join_outcome(a b:static_outcome):static_outcome:=
 match a,b with
 |StaticReturn,StaticReturn=>StaticReturn
 |StaticNormal xs,StaticReturn|StaticReturn,StaticNormal xs=>StaticNormal xs
 |StaticNormal xs,StaticNormal ys=>StaticNormal(initialized_intersection xs ys)end.
Fixpoint check_statement(ret:type)(initialized:list ident)(s:statement):option static_outcome:=
 match s with
 |Sskip=>Some(StaticNormal initialized)
 |Sdo(Eassign l r ty)=>match check_assign initialized l r ty with Some ids=>Some(StaticNormal ids)|None=>None end
 |Ssequence a b=>match check_statement ret initialized a with
   |Some(StaticNormal ids)=>check_statement ret ids b
   |Some StaticReturn=>Some StaticReturn|None=>None end
 |Sifthenelse a yes no=>if check_expr initialized a then
   match check_statement ret initialized yes,check_statement ret initialized no with
   |Some a,Some b=>Some(join_outcome a b)|_,_=>None end else None
 |Sreturn(Some a)=>if check_expr initialized a then if type_eq(typeof a)ret then Some StaticReturn else None else None
 |_=>None end.
Definition slot_typed(ty:type)(v:val):Prop:=
 if type_eq ty(Tunion union_id noattr)then has_kind K32 v else typed_value ty v.
Definition initialized_values(ids:list ident)(rho:PTree.t val):Prop:=
 forall id,In id ids->exists ty v,gamma!id=Some ty /\rho!id=Some v /\slot_typed ty v.
Definition good_value_outcome(ret:type)(expected:static_outcome)(actual:value_outcome):Prop:=
 match actual with
 |ValueReturn v ty _=>ty=ret /\typed_value ret v
 |ValueNormal rho=>match expected with StaticNormal ids=>initialized_values ids rho|StaticReturn=>False end end.
Lemma initialized_values_weaken:forall xs ys rho,
 (forall id,In id xs->In id ys)->initialized_values ys rho->initialized_values xs rho.
Proof. unfold initialized_values;intros xs ys rho SUB WELL id IN;apply WELL;apply SUB;exact IN. Qed.
Lemma intersection_left:forall xs ys id,In id(initialized_intersection xs ys)->In id xs.
Proof. intros;unfold initialized_intersection in H;apply filter_In in H;tauto. Qed.
Lemma intersection_right:forall xs ys id,In id(initialized_intersection xs ys)->In id ys.
Proof. intros;unfold initialized_intersection in H;apply filter_In in H as[_ H];apply has_id_true in H;exact H. Qed.
End CERTIFICATE.
