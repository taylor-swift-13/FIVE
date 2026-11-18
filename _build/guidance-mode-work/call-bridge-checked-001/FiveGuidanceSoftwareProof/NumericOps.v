From Stdlib Require Import Bool List ZArith Lia.
From compcert Require Import Coqlib Maps Integers Floats AST Values Memory Ctypes Cop Csyntax Csyntaxdefs.
Local Open Scope Z_scope.
Inductive numeric_kind_t:=K32|K64|KF32.
Inductive numeric_tag_t:=NInt|NUInt|NULong|NFloat.
Definition tag_type(t:numeric_tag_t):type:=match t with NInt=>tint|NUInt=>tuint|NULong=>tulong|NFloat=>tfloat end.
Definition kind_of_tag(t:numeric_tag_t):numeric_kind_t:=match t with NInt|NUInt=>K32|NULong=>K64|NFloat=>KF32 end.
Definition numeric_tag(ty:type):option numeric_tag_t:=
 if type_eq ty tint then Some NInt else if type_eq ty tuint then Some NUInt else
 if type_eq ty tulong then Some NULong else if type_eq ty tfloat then Some NFloat else None.
Definition numeric_kind(ty:type):option numeric_kind_t:=option_map kind_of_tag(numeric_tag ty).
Definition has_kind(k:numeric_kind_t)(v:val):Prop:=
 match k,v with K32,Vint _|K64,Vlong _|KF32,Vsingle _=>True|_,_=>False end.
Definition typed_value(ty:type)(v:val):Prop:=match numeric_kind ty with Some k=>has_kind k v|None=>False end.
Definition integer_tag(t:numeric_tag_t):bool:=match t with NFloat=>false|_=>true end.
Definition integer_type(ty:type):bool:=match numeric_tag ty with Some t=>integer_tag t|None=>false end.
Definition literal_constraint(lit:option val)(v:val):Prop:=match lit with None=>True|Some w=>v=w end.
Definition two_literal(t:numeric_tag_t)(lit:option val):bool:=
 match t,lit with
 |NInt,Some(Vint n)|NUInt,Some(Vint n)=>Int.eq n(Int.repr 2)
 |NULong,Some(Vlong n)=>Int64.eq n(Int64.repr 2)
 |_,_=>false end.
Definition shift_width(t:numeric_tag_t):int:=match t with NULong=>Int64.iwordsize'|_=>Int.iwordsize end.
Definition shift_literal(left right:numeric_tag_t)(lit:option val):bool:=
 match right,lit with NInt,Some(Vint n)|NUInt,Some(Vint n)=>Int.ltu n(shift_width left)|_,_=>false end.
Definition binop_result_type(op:binary_operation)(ty1 ty2:type):type:=
 match op with Oeq|One|Olt|Ogt|Ole|Oge=>tint|Oshl|Oshr=>ty1|_=>binarith_type(classify_binarith ty1 ty2)end.
Definition safe_binop(op:binary_operation)(ty1 ty2 resultty:type)(rhs_literal:option val):bool:=
 match numeric_tag ty1,numeric_tag ty2 with
 |Some t1,Some t2=>integer_tag t1 && integer_tag t2 &&
 (if type_eq resultty(binop_result_type op ty1 ty2)then
 match op with Odiv|Omod=>two_literal t2 rhs_literal|Oshl|Oshr=>shift_literal t1 t2 rhs_literal|_=>true end else false)
 |_,_=>false end.
Definition unop_result_type(op:unary_operation)(ty:type):type:=match op with Onotbool=>tint|_=>ty end.
Definition safe_unop(op:unary_operation)(ty resultty:type):bool:=
 match numeric_tag ty with Some t=>
 (if type_eq resultty(unop_result_type op ty)then
 match op with Oneg|Onotbool=>true|Onotint=>integer_tag t|_=>false end else false)
 |None=>false end.
Definition safe_cast(fromty toty:type):bool:=
 match numeric_tag fromty,numeric_tag toty with
 |Some NFloat,Some NFloat=>true
 |Some a,Some b=>integer_tag a && integer_tag b
 |_,_=>false end.
Lemma numeric_tag_sound:forall ty t,numeric_tag ty=Some t->ty=tag_type t.
Proof.
 intros ty t;unfold numeric_tag;
 destruct(type_eq ty tint), (type_eq ty tuint), (type_eq ty tulong),(type_eq ty tfloat);
 intros H;try discriminate;injection H as<-;assumption.
Qed.
Lemma typed_value_cases:forall ty v,typed_value ty v->
 (exists n,ty=tint /\v=Vint n) \/(exists n,ty=tuint /\v=Vint n) \/
 (exists n,ty=tulong /\v=Vlong n) \/(exists f,ty=tfloat /\v=Vsingle f).
Proof.
 intros ty v T;unfold typed_value,numeric_kind in T.
 destruct(numeric_tag ty)as[tag|]eqn:TAG;try contradiction.
 pose proof(numeric_tag_sound ty tag TAG)as EQ;subst ty.
 destruct tag;destruct v;cbn in T;try contradiction;eauto 8.
Qed.
Lemma typed_bool:forall b,typed_value tint(Val.of_bool b).
Proof. destruct b;exact I. Qed.
Lemma bool_val_total:forall ty v,typed_value ty v ->exists b,forall m,bool_val v ty m=Some b.
Proof.
 intros ty v TV;destruct(typed_value_cases ty v TV)as[(n&->&->)|[(n&->&->)|[(n&->&->)|(f&->&->)]]];eexists;intros;reflexivity.
Qed.
Lemma safe_cast_total:forall fromty toty v,
 safe_cast fromty toty=true ->typed_value fromty v ->
 exists result,typed_value toty result /\forall m,sem_cast v fromty toty m=Some result.
Proof.
 intros fromty toty v SAFE TV.
 destruct(typed_value_cases fromty v TV)as[(n&->&->)|[(n&->&->)|[(n&->&->)|(f&->&->)]]];
 unfold safe_cast in SAFE;cbn in SAFE;
 destruct(numeric_tag toty)as[tag|]eqn:TAG;try discriminate;
 pose proof(numeric_tag_sound toty tag TAG)as EQ;subst toty;
 destruct tag;cbn in SAFE;try discriminate.
 all: (eexists;split;[|intros;reflexivity];exact I).
Qed.
Print Assumptions bool_val_total.
Print Assumptions safe_cast_total.
Lemma numeric_binop_independent:forall ty1 ty2 v1 v2,
 typed_value ty1 v1 ->typed_value ty2 v2 ->forall op ce1 ce2 m1 m2,
 sem_binary_operation ce1 op v1 ty1 v2 ty2 m1=sem_binary_operation ce2 op v1 ty1 v2 ty2 m2.
Proof.
 intros ty1 ty2 v1 v2 T1 T2.
 destruct(typed_value_cases ty1 v1 T1)as[(x&->&->)|[(x&->&->)|[(x&->&->)|(x&->&->)]]];
 destruct(typed_value_cases ty2 v2 T2)as[(y&->&->)|[(y&->&->)|[(y&->&->)|(y&->&->)]]];
 intros op ce1 ce2 m1 m2;destruct op;reflexivity.
Qed.
Lemma numeric_unop_independent:forall ty v,typed_value ty v ->forall op m1 m2,
 sem_unary_operation op v ty m1=sem_unary_operation op v ty m2.
Proof.
 intros ty v T;destruct(typed_value_cases ty v T)as[(x&->&->)|[(x&->&->)|[(x&->&->)|(x&->&->)]]];intros op m1 m2;destruct op;reflexivity.
Qed.
Lemma safe_binop_result:forall op t1 t2 tr lit,safe_binop op t1 t2 tr lit=true ->tr=binop_result_type op t1 t2.
Proof.
 intros op t1 t2 tr lit;unfold safe_binop.
 destruct(numeric_tag t1), (numeric_tag t2);try discriminate.
 repeat match goal with |- ?x && ?y=true ->_=>rewrite andb_true_iff;intros[? ?]end.
 destruct(type_eq tr(binop_result_type op t1 t2));intros;try discriminate;assumption.
Qed.
Lemma two_literal_value:forall tag lit v,two_literal tag lit=true ->literal_constraint lit v ->
 v=match tag with NULong=>Vlong(Int64.repr 2)|_=>Vint(Int.repr 2)end.
Proof.
 intros tag lit v;destruct tag;destruct lit as[w|];try discriminate;destruct w as[|i|l|f|s|b ofs];cbn;intros H L;try discriminate;
 first[apply Int.same_if_eq in H;subst i;exact L|apply Int64.same_if_eq in H;subst l;exact L].
Qed.
Lemma shift_literal_value:forall left right lit v,
 shift_literal left right lit=true ->literal_constraint lit v ->
 exists n,v=Vint n /\Int.ltu n(shift_width left)=true.
Proof.
 intros left right lit v;destruct right;destruct lit as[w|];try discriminate;destruct w as[|i|l|f|s|b ofs];cbn;intros H L;try discriminate;exists i;auto.
Qed.
Lemma vint_injective:forall x y,Vint x=Vint y->x=y.
Proof. intros x y H;exact(f_equal(fun v=>match v with Vint i=>i|_=>Int.zero end)H). Qed.
Lemma vlong_injective:forall x y,Vlong x=Vlong y->x=y.
Proof. intros x y H;exact(f_equal(fun v=>match v with Vlong i=>i|_=>Int64.zero end)H). Qed.
Print Assumptions numeric_binop_independent.
Lemma safe_unop_result:forall op ty tr,safe_unop op ty tr=true ->tr=unop_result_type op ty.
Proof.
 intros op ty tr;unfold safe_unop;destruct(numeric_tag ty);try discriminate.
 destruct(type_eq tr(unop_result_type op ty));intros;try discriminate;assumption.
Qed.
Lemma safe_unop_total:forall op ty tr v,safe_unop op ty tr=true ->typed_value ty v ->
 exists result,typed_value tr result /\forall m,sem_unary_operation op v ty m=Some result.
Proof.
 intros op ty tr v SAFE TV;pose proof(safe_unop_result _ _ _ SAFE)as->.
 destruct(typed_value_cases ty v TV)as[(x&->&->)|[(x&->&->)|[(x&->&->)|(x&->&->)]]];
 destruct op;cbn[safe_unop numeric_tag integer_tag unop_result_type]in SAFE;try discriminate.
 all:(eexists;split;[|intros;reflexivity];first[exact I|apply typed_bool]).
Qed.
Ltac force_two_rhs :=
 match goal with H:two_literal ?tag ?lit=true,L:literal_constraint ?lit ?rhs|-_=>
 let E:=fresh "RHS"in pose proof(two_literal_value tag lit rhs H L)as E;
 first[apply vint_injective in E;match type of E with ?w=_=>subst w end|apply vlong_injective in E;match type of E with ?w=_=>subst w end]
 end.
Ltac force_shift_rhs :=
 match goal with H:shift_literal ?lt ?rt ?lit=true,L:literal_constraint ?lit ?rhs|-_=>
 let n:=fresh "shift"in let E:=fresh "RHS"in let B:=fresh "BOUND"in
 destruct(shift_literal_value lt rt lit rhs H L)as[n[E B]];
 first[apply vint_injective in E;match type of E with ?w=_=>subst w end|discriminate E]
 end.
Ltac unfold_numeric_binary :=cbv beta iota zeta delta [sem_binary_operation sem_add sem_sub sem_mul sem_div sem_mod
 sem_and sem_or sem_xor sem_shl sem_shr sem_shift sem_cmp classify_add classify_sub classify_shift
 classify_cmp typeconv remove_attributes change_attributes sem_binarith classify_binarith binarith_type sem_cast classify_cast
 cast_int_long cast_int_int tint tuint tulong tfloat noattr Archi.ptr64].
Lemma safe_binop_total:forall op ty1 ty2 tr lit v1 v2,
 safe_binop op ty1 ty2 tr lit=true ->typed_value ty1 v1 ->typed_value ty2 v2 ->literal_constraint lit v2 ->
 exists result,typed_value tr result /\forall cenv m,sem_binary_operation cenv op v1 ty1 v2 ty2 m=Some result.
Proof.
 intros op ty1 ty2 tr lit v1 v2 SAFE T1 T2 LIT.
 pose proof(safe_binop_result _ _ _ _ _ SAFE)as->.
 destruct(typed_value_cases ty1 v1 T1)as[(x&->&->)|[(x&->&->)|[(x&->&->)|(x&->&->)]]];
 destruct(typed_value_cases ty2 v2 T2)as[(y&->&->)|[(y&->&->)|[(y&->&->)|(y&->&->)]]];
 destruct op;cbn[safe_binop numeric_tag integer_tag binop_result_type classify_binarith binarith_type]in SAFE;try discriminate.
 all:try(first[change(two_literal NInt lit=true)in SAFE|change(two_literal NULong lit=true)in SAFE|change(shift_literal NInt NInt lit=true)in SAFE|change(shift_literal NULong NInt lit=true)in SAFE]).
 all:try force_two_rhs.
 all:try force_shift_rhs.
 all:try match goal with B:Int.ltu _ _=true|-_=>cbn[shift_width]in B end.
 all:(eexists;split;[|intros;unfold_numeric_binary;repeat rewrite Bool.andb_false_r;
   repeat match goal with B:Int.ltu _ _=true|-_=>rewrite B end;reflexivity];first[exact I|apply typed_bool]).
Qed.
Print Assumptions safe_binop_total.
Print Assumptions safe_unop_total.
Lemma numeric_kind_cases:forall ty k,numeric_kind ty=Some k ->
 (k=K32 /\(ty=tint \/ty=tuint)) \/(k=K64 /\ty=tulong) \/(k=KF32 /\ty=tfloat).
Proof.
 intros ty k H;unfold numeric_kind in H;destruct(numeric_tag ty)as[tag|]eqn:T;try discriminate.
 pose proof(numeric_tag_sound ty tag T)as EQ;subst ty;destruct tag;injection H as<-;eauto 8.
Qed.
Print Assumptions numeric_kind_cases.
