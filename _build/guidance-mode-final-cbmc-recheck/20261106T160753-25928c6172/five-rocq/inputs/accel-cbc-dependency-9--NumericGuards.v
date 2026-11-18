From Stdlib Require Import ZArith Lia.
From compcert Require Import Integers Floats Values Memory Ctypes Cop Csyntaxdefs.
From FivePaparazziState Require Import State.
From FiveGuidanceEntry Require Import Entry.
Local Open Scope Z_scope.

Definition cast_guard_x:Prop:=forall s,integration_safe s->exists d,
 sem_cast(Vsingle(Float32.mul(Float32.mul(speed_x s)(dt s))q37))tfloat tlong Mem.empty=Some(Vlong d).
Definition cast_guard_y:Prop:=forall s,integration_safe s->exists d,
 sem_cast(Vsingle(Float32.mul(Float32.mul(speed_y s)(dt s))q37))tfloat tlong Mem.empty=Some(Vlong d).
Definition add_guard_x:Prop:=forall s,integration_safe s->exists d,
 pos_increment(speed_x s)(dt s)=Some d /\
 Int64.min_signed<=Int64.signed(pos_x s)+Int64.signed d<=Int64.max_signed.
Definition add_guard_y:Prop:=forall s,integration_safe s->exists d,
 pos_increment(speed_y s)(dt s)=Some d /\
 Int64.min_signed<=Int64.signed(pos_y s)+Int64.signed d<=Int64.max_signed.
Lemma cast_x_safe:cast_guard_x.
Proof.
 intros s(dx&dy&X&Y&SX&SY);exists dx.
 change(option_map Vlong(pos_increment(speed_x s)(dt s))=Some(Vlong dx));rewrite X;reflexivity.
Qed.
Lemma cast_y_safe:cast_guard_y.
Proof.
 intros s(dx&dy&X&Y&SX&SY);exists dy.
 change(option_map Vlong(pos_increment(speed_y s)(dt s))=Some(Vlong dy));rewrite Y;reflexivity.
Qed.
Lemma add_x_safe:add_guard_x.
Proof. intros s(dx&dy&X&Y&SX&SY);exists dx;auto. Qed.
Lemma add_y_safe:add_guard_y.
Proof. intros s(dx&dy&X&Y&SX&SY);exists dy;auto. Qed.
Definition wide_entry_guard_id(n:nat):Prop:=match n with
 |1%nat=>cast_guard_x|2%nat=>cast_guard_y|3%nat=>add_guard_x|4%nat=>add_guard_y|_=>False end.
Theorem wide_entry_guards:forall n,(1<=n<=4)%nat->wide_entry_guard_id n.
Proof.
 intros n B;destruct n as[|n];[lia|].
 destruct n as[|n];[exact cast_x_safe|]. destruct n as[|n];[exact cast_y_safe|].
 destruct n as[|n];[exact add_x_safe|]. destruct n as[|n];[exact add_y_safe|]. lia.
Qed.
Definition canonical_dt:float32:=Float32.of_bits(Int.repr 989855744).
Definition canonical_one:float32:=Float32.of_bits(Int.repr 1065353216).
Definition canonical_scaled_x:=Float32.mul(Float32.mul canonical_one canonical_dt)q37.
Definition canonical_scaled_y:=Float32.mul(Float32.mul Float32.zero canonical_dt)q37.
Definition strict_cast_bounds(x:float32):Prop:=
 Float32.cmp Cgt x(Float32.of_bits(Int.repr 3741319168))=true /\
 Float32.cmp Clt x(Float32.of_bits(Int.repr 1593835520))=true.
Definition canonical_cast_controls(s:state):Prop:=
 speed_x s=canonical_one /\speed_y s=Float32.zero /\dt s=canonical_dt.
Definition source_scaled_x(s:state):=Float32.mul(Float32.mul(speed_x s)(dt s))q37.
Definition source_scaled_y(s:state):=Float32.mul(Float32.mul(speed_y s)(dt s))q37.
Definition canonical_source_guard_x:Prop:=forall s,canonical_cast_controls s->strict_cast_bounds(source_scaled_x s).
Definition canonical_source_guard_y:Prop:=forall s,canonical_cast_controls s->strict_cast_bounds(source_scaled_y s).
Lemma canonical_strict_x:strict_cast_bounds canonical_scaled_x.
Proof. vm_compute;split;reflexivity. Qed.
Lemma canonical_strict_y:strict_cast_bounds canonical_scaled_y.
Proof. vm_compute;split;reflexivity. Qed.
Lemma canonical_source_x:canonical_source_guard_x.
Proof. intros s[X[Y T]];unfold source_scaled_x;rewrite X,T;exact canonical_strict_x. Qed.
Lemma canonical_source_y:canonical_source_guard_y.
Proof. intros s[X[Y T]];unfold source_scaled_y;rewrite Y,T;exact canonical_strict_y. Qed.
Definition entry_guard_id(n:nat):Prop:=match n with
 |1%nat=>cast_guard_x /\canonical_source_guard_x
 |2%nat=>cast_guard_y /\canonical_source_guard_y
 |3%nat=>add_guard_x|4%nat=>add_guard_y|_=>False end.
Theorem entry_guards:forall n,(1<=n<=4)%nat->entry_guard_id n.
Proof.
 intros n B;destruct n as[|n];[lia|].
 destruct n as[|n];[split;[exact cast_x_safe|exact canonical_source_x]|].
 destruct n as[|n];[split;[exact cast_y_safe|exact canonical_source_y]|].
 destruct n as[|n];[exact add_x_safe|]. destruct n as[|n];[exact add_y_safe|]. lia.
Qed.
Definition main_cast_x:Prop:=Float32.to_long canonical_scaled_x=Some(Int64.repr 268435456) /\strict_cast_bounds canonical_scaled_x.
Definition main_cast_y:Prop:=Float32.to_long canonical_scaled_y=Some Int64.zero /\strict_cast_bounds canonical_scaled_y.
Lemma main_cast_x_safe:main_cast_x.
Proof. split;[vm_compute;reflexivity|exact canonical_strict_x]. Qed.
Lemma main_cast_y_safe:main_cast_y.
Proof. split;[vm_compute;reflexivity|exact canonical_strict_y]. Qed.
Definition upper_margin_guard:Prop:=forall d,
 0<=Int64.signed d->Int64.min_signed<=Int64.max_signed-Int64.signed d<=Int64.max_signed.
Definition lower_margin_guard:Prop:=forall d,
 Int64.signed d<0->Int64.min_signed<=Int64.min_signed-Int64.signed d<=Int64.max_signed.
Definition assumed_sum_guard:Prop:=forall p d,
 ((0<=Int64.signed d /\Int64.signed p<=Int64.max_signed-Int64.signed d) \/
  (Int64.signed d<0 /\Int64.min_signed-Int64.signed d<=Int64.signed p))->
 Int64.min_signed<=Int64.signed p+Int64.signed d<=Int64.max_signed.
Lemma upper_margin_safe:upper_margin_guard.
Proof. intros d P;pose proof(Int64.signed_range d);change(-9223372036854775808<=9223372036854775807-Int64.signed d<=9223372036854775807);change(-9223372036854775808<=Int64.signed d<=9223372036854775807)in H;lia. Qed.
Lemma lower_margin_safe:lower_margin_guard.
Proof. intros d P;pose proof(Int64.signed_range d);change(-9223372036854775808<= -9223372036854775808-Int64.signed d<=9223372036854775807);change(-9223372036854775808<=Int64.signed d<=9223372036854775807)in H;lia. Qed.
Lemma assumed_sum_safe:assumed_sum_guard.
Proof.
 intros p d M;pose proof(Int64.signed_range p).
 change(-9223372036854775808<=Int64.signed p<=9223372036854775807)in H.
 change(-9223372036854775808<=Int64.signed p+Int64.signed d<=9223372036854775807).
 change((0<=Int64.signed d /\Int64.signed p<=9223372036854775807-Int64.signed d)\/
 (Int64.signed d<0 /\ -9223372036854775808-Int64.signed d<=Int64.signed p))in M.
 destruct M as[[P M]|[P M]];lia.
Qed.
Definition main_guard_id(n:nat):Prop:=match n with
 |1%nat|9%nat=>main_cast_x
 |2%nat|5%nat|10%nat|13%nat=>upper_margin_guard
 |3%nat|6%nat|11%nat|14%nat=>lower_margin_guard
 |4%nat|12%nat=>main_cast_y
 |7%nat|8%nat|15%nat|16%nat=>assumed_sum_guard
 |_=>False end.
Theorem main_guards:forall n,(1<=n<=16)%nat->main_guard_id n.
Proof.
 intros n B;assert(C:n=1%nat\/n=2%nat\/n=3%nat\/n=4%nat\/n=5%nat\/n=6%nat\/n=7%nat\/n=8%nat\/n=9%nat\/n=10%nat\/n=11%nat\/n=12%nat\/n=13%nat\/n=14%nat\/n=15%nat\/n=16%nat)by lia.
 repeat destruct C as[E|C];try(rename C into E);subst n;cbn[main_guard_id];
 auto using main_cast_x_safe,main_cast_y_safe,upper_margin_safe,lower_margin_safe,assumed_sum_safe.
Qed.
Print Assumptions entry_guards.
Print Assumptions main_guards.
