From Stdlib Require Import Reals Lra Psatz.
From compcert Require Import Integers Floats.
From Flocq Require Import Core.Core IEEE754.Binary.
From FiveLowpassRoundoffSupport Require Import FloatBounds.
Local Open Scope R_scope.

Definition r32 (f:float32) : R := B2R 24 128 f.
Definition finite (f:float32) : Prop := is_finite 24 128 f = true.
Definition one : float32 := Float32.of_bits (Int.repr 1065353216).
Definition step (c li lo x:float32) : float32 :=
 Float32.div
  (Float32.add (Float32.add x li) (Float32.mul (Float32.sub c one) lo))
  (Float32.add one c).
Definition u : R := 1/16777216.
Definition eta : R := 1/1427247692705959881058285969449495136382746624.

Lemma abs_error (a b e:R) :
 Rabs (a-b)<=e -> Rabs a<=Rabs b+e.
Proof.
 intro H; replace a with (b+(a-b)) by ring.
 eapply Rle_trans; [apply Rabs_triang|lra].
Qed.
Lemma abs_pair (a b ea eb:R) :
 Rabs a<=ea -> Rabs b<=eb -> Rabs(a+b)<=ea+eb.
Proof. intros; eapply Rle_trans; [apply Rabs_triang|lra]. Qed.
Lemma absdiff_pair (a b c ea eb:R) :
 Rabs (a-b)<=ea -> Rabs (b-c)<=eb -> Rabs(a-c)<=ea+eb.
Proof.
 intros; replace (a-c) with ((a-b)+(b-c)) by ring.
 now apply abs_pair.
Qed.
Lemma abs_product (a b ea eb:R) :
 Rabs a<=ea -> Rabs b<=eb -> 0<=ea -> 0<=eb -> Rabs(a*b)<=ea*eb.
Proof.
 intros; rewrite Rabs_mult; apply Rmult_le_compat; try apply Rabs_pos; assumption.
Qed.

Lemma Rabs_div (a b:R) : b<>0 -> Rabs(a/b)=Rabs a/Rabs b.
Proof. intro H; unfold Rdiv; rewrite Rabs_mult, Rabs_inv by exact H; reflexivity. Qed.

Section RealRound.
Variable rn:R->R.
Hypothesis rnd_error:forall z, Rabs(rn z-z)<=u*Rabs z+eta.
Hypothesis rnd_two:forall z, Rabs z<=2 ->Rabs(rn z)<=2.

Lemma real_step_bounds : forall C L O X,
 1<=C<=2 -> Rabs L<=1 ->Rabs O<=2 ->Rabs X<=1 ->
 let a:=rn(C-1) in let s:=rn(X+L) in
 let p:=rn(a*O) in let n:=rn(s+p) in let d:=rn(1+C) in
 Rabs(n/d)<=2 /\ Rabs(rn(n/d))<=2 /\
 Rabs(rn(n/d)-(X+L+(C-1)*O)/(1+C))<=1/1048576.
Proof.
 intros C L O X HC HL HO HX a s p n d.
 assert (Hu:0<u) by (unfold u; lra).
 assert (Heta:0<eta /\ eta<=u/2) by (unfold eta,u; split; lra).
 assert (HA0:Rabs(C-1)=C-1) by (apply Rabs_pos_eq; lra).
 assert (Hea:Rabs(a-(C-1))<=2*u).
 { unfold a. specialize (rnd_error (C-1)); rewrite HA0 in rnd_error.
   unfold u,eta in *; nra. }
 assert (Ha:Rabs a<=C-1+2*u) by (pose proof(abs_error _ _ _ Hea); rewrite HA0 in H; lra).
 assert (HS0:Rabs(X+L)<=2) by (pose proof(abs_pair _ _ _ _ HX HL); lra).
 assert (Hes:Rabs(s-(X+L))<=3*u).
 { unfold s; specialize(rnd_error (X+L)); unfold u,eta in *; nra. }
 assert (Hs:Rabs s<=2+3*u) by (pose proof(abs_error _ _ _ Hes); lra).
 assert (HAP:Rabs(a*O)<=2*(C-1)+4*u).
 { pose proof(abs_product a O (C-1+2*u) 2 Ha HO ltac:(lra) ltac:(lra)); nra. }
 assert (HAP2:Rabs(a*O)<=2+4*u) by lra.
 assert (Hep:Rabs(p-a*O)<=3*u).
 { unfold p; specialize(rnd_error(a*O)); unfold u,eta in *; nra. }
 assert (Hpa:Rabs(p-(C-1)*O)<=7*u).
 { replace (p-(C-1)*O) with ((p-a*O)+(a-(C-1))*O) by ring.
   pose proof(abs_product (a-(C-1)) O (2*u) 2 Hea HO ltac:(lra) ltac:(lra)).
   pose proof(abs_pair _ _ _ _ Hep H); nra. }
 assert (HPI:Rabs((C-1)*O)<=2*(C-1)).
 { pose proof(abs_product (C-1) O (C-1) 2 ltac:(rewrite HA0; lra) HO ltac:(lra) ltac:(lra)); nra. }
 assert (Hp:Rabs p<=2*(C-1)+7*u) by (pose proof(abs_error _ _ _ Hpa); lra).
 assert (HSP:Rabs(s+p)<=2*C+10*u) by (pose proof(abs_pair _ _ _ _ Hs Hp); lra).
 assert (HSP2:Rabs(s+p)<=4+10*u) by lra.
 assert (Hen:Rabs(n-(s+p))<=5*u).
 { unfold n; specialize(rnd_error(s+p)); unfold u,eta in *; nra. }
 assert (HSPe:Rabs((s+p)-(X+L+(C-1)*O))<=10*u).
 { replace ((s+p)-(X+L+(C-1)*O))
    with ((s-(X+L))+(p-(C-1)*O)) by ring.
   pose proof(abs_pair _ _ _ _ Hes Hpa); nra. }
 assert (Hne:Rabs(n-(X+L+(C-1)*O))<=15*u).
 { pose proof(absdiff_pair _ _ _ _ _ Hen HSPe); nra. }
 assert (HNI:Rabs(X+L+(C-1)*O)<=2*C).
 { pose proof(abs_pair _ _ _ _ HS0 HPI); nra. }
 assert (Hn:Rabs n<=2*C+15*u) by (pose proof(abs_error _ _ _ Hne); lra).
 assert (HD0:Rabs(1+C)=1+C) by (apply Rabs_pos_eq; lra).
 assert (Hde:Rabs(d-(1+C))<=4*u).
 { unfold d; specialize(rnd_error(1+C)); rewrite HD0 in rnd_error.
   unfold u,eta in *; nra. }
 apply Rabs_le_inv in Hde.
 assert (Hd:0<d) by (unfold u in *; lra).
 assert (Hd0:d<>0) by lra.
 assert (HC0:1+C<>0) by lra.
 assert (Hq:Rabs(n/d)<=2).
 { rewrite Rabs_div, (Rabs_pos_eq d) by lra.
   apply (Rmult_le_reg_r d); [lra|].
   replace (Rabs n / d * d) with (Rabs n) by (field; assumption).
   unfold u in *; nra. }
 assert (HI:Rabs((X+L+(C-1)*O)/(1+C))<=2).
 { rewrite Rabs_div, (Rabs_pos_eq (1+C)) by lra.
   apply (Rmult_le_reg_r (1+C)); [lra|].
   replace (Rabs(X+L+(C-1)*O)/(1+C)*(1+C))
      with (Rabs(X+L+(C-1)*O)) by (field; assumption).
   nra. }
 assert (Heq:Rabs(n/d-(X+L+(C-1)*O)/(1+C))<=12*u).
 { set (I:=(X+L+(C-1)*O)/(1+C)).
   assert (HId:I*(1+C)=X+L+(C-1)*O) by (unfold I; field; assumption).
   assert (He:Rabs(n-I*d)<=23*u).
   { replace (n-I*d) with
       ((n-(X+L+(C-1)*O))+I*((1+C)-d)) by (rewrite <- HId; ring).
     assert (HaI:Rabs I<=2) by exact HI.
     assert (Had:Rabs((1+C)-d)<=4*u).
     { rewrite Rabs_minus_sym; apply Rabs_le; exact Hde. }
     pose proof(abs_product I ((1+C)-d) 2 (4*u) HaI Had ltac:(lra) ltac:(lra)).
     pose proof(abs_pair _ _ _ _ Hne H); nra. }
   replace (n/d-I) with ((n-I*d)/d) by (field; assumption).
   rewrite Rabs_div, (Rabs_pos_eq d) by lra.
   apply (Rmult_le_reg_r d); [lra|].
   replace (Rabs(n-I*d)/d*d) with (Rabs(n-I*d)) by (field; assumption).
   unfold u in *; nra. }
 assert (Her:Rabs(rn(n/d)-n/d)<=3*u).
 { specialize(rnd_error(n/d)); unfold u,eta in *; nra. }
 split; [exact Hq|]. split; [now apply rnd_two|].
 pose proof(absdiff_pair _ _ _ _ _ Her Heq).
 unfold u in *; nra.
Qed.
End RealRound.

Lemma one_finite : finite one.
Proof. vm_compute; reflexivity. Qed.
Lemma one_real : r32 one=1.
Proof.
  unfold r32,one. change (8388608 * /8388608 = 1).
  field.
Qed.

Lemma RN_error_real : forall z, Rabs(FloatBounds.RN z-z)<=u*Rabs z+eta.
Proof.
 intro z. pose proof(FloatBounds.RN_error z) as H.
 rewrite FloatBounds.u_value,FloatBounds.eta_value in H.
 unfold u,eta. nra.
Qed.
Lemma RN_abs_small : forall z m,
 0<=m ->Rabs z<=m ->Rabs(FloatBounds.RN z)<=m+u*m+eta.
Proof.
 intros z m HM Hz. pose proof(RN_error_real z) as H.
 pose proof(abs_error _ _ _ H). unfold u in *; nra.
Qed.

Theorem step_bound_local : forall c li lo x,
 finite c -> 1<=r32 c<=2 ->
 finite li -> Rabs(r32 li)<=1 ->
 finite lo -> Rabs(r32 lo)<=2 ->
 finite x -> Rabs(r32 x)<=1 ->
 finite(step c li lo x) /\ Rabs(r32(step c li lo x))<=2 /\
 Rabs(r32(step c li lo x)-
 (r32 x+r32 li+(r32 c-1)*r32 lo)/(1+r32 c))<=1/1048576.
Proof.
 intros c li lo x FC HC FL HL FO HO FX HX.
 set (a:=Float32.sub c one).
 set (s:=Float32.add x li).
 set (p:=Float32.mul a lo).
 set (n:=Float32.add s p).
 set (d:=Float32.add one c).
 assert (Hc1:Rabs(r32 c-r32 one)<=8).
 { rewrite one_real,Rabs_pos_eq by lra; lra. }
 destruct(FloatBounds.sub_finite_real c one FC one_finite Hc1) as [FA RA].
 change (r32 a=FloatBounds.RN(r32 c-r32 one)) in RA.
 change (finite a) in FA.
 rewrite one_real in RA.
 assert (Ha:Rabs(r32 a)<=2).
 { rewrite RA. pose proof(RN_abs_small (r32 c-1) 1 ltac:(lra) ltac:(rewrite Rabs_pos_eq; lra)).
   unfold u,eta in *; lra. }
 assert (Hxl:Rabs(r32 x+r32 li)<=2) by (pose proof(abs_pair _ _ _ _ HX HL); lra).
 destruct(FloatBounds.add_finite_real x li FX FL ltac:(change(Rabs(r32 x+r32 li)<=8); lra)) as [FS RS].
 change(finite s) in FS.
 change(r32 s=FloatBounds.RN(r32 x+r32 li)) in RS.
 assert (Hs:Rabs(r32 s)<=2) by (rewrite RS; now apply FloatBounds.RN_abs_le_2).
 assert (Hal:Rabs(r32 a*r32 lo)<=4).
 { pose proof(abs_product _ _ _ _ Ha HO ltac:(lra) ltac:(lra)); nra. }
 destruct(FloatBounds.mul_finite_real a lo FA FO ltac:(change(Rabs(r32 a*r32 lo)<=8); lra)) as [FP RP].
 change(finite p) in FP.
 change(r32 p=FloatBounds.RN(r32 a*r32 lo)) in RP.
 assert (Hp:Rabs(r32 p)<=5).
 { rewrite RP. pose proof(RN_abs_small (r32 a*r32 lo) 4 ltac:(lra) Hal).
   unfold u,eta in *; lra. }
 assert (Hsp:Rabs(r32 s+r32 p)<=8).
 { pose proof(abs_pair _ _ _ _ Hs Hp); lra. }
 destruct(FloatBounds.add_finite_real s p FS FP Hsp) as [FN RN].
 change(finite n) in FN.
 change(r32 n=FloatBounds.RN(r32 s+r32 p)) in RN.
 assert (H1c:Rabs(r32 one+r32 c)<=8).
 { rewrite one_real,Rabs_pos_eq by lra; lra. }
 destruct(FloatBounds.add_finite_real one c one_finite FC H1c) as [FD RD].
 change(finite d) in FD.
 change(r32 d=FloatBounds.RN(r32 one+r32 c)) in RD.
 rewrite one_real in RD.
 assert (Hd:r32 d<>0).
 { pose proof(RN_error_real (1+r32 c)) as H.
   rewrite <-RD, (Rabs_pos_eq (1+r32 c)) in H by lra.
   apply Rabs_le_inv in H. unfold u,eta in *; lra. }
 pose proof(real_step_bounds FloatBounds.RN RN_error_real FloatBounds.RN_abs_le_2
   (r32 c) (r32 li) (r32 lo) (r32 x) HC HL HO HX) as HB.
 cbn zeta in HB.
 rewrite <-RA,<-RS,<-RP,<-RN,<-RD in HB.
 destruct HB as [HQ [HQr HErr]].
 destruct(FloatBounds.div_finite_real n d FN FD Hd
   ltac:(change(Rabs(r32 n/r32 d)<=8); lra)) as [FQ RQ].
 change(finite(step c li lo x)) in FQ.
 change(r32(step c li lo x)=FloatBounds.RN(r32 n/r32 d)) in RQ.
 split; [exact FQ|]. rewrite RQ. split; assumption.
Qed.
