From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib AST Integers Values Memory.
From PidPositionTranslationCore Require Import CoreMemory CoreSemantics CoreClamp FlightSemantics ControllerPrefix.
Import ListNotations.
Open Scope Z_scope.
Definition misses_bytes(b:block)(ofs n:Z)(u:scalar_update):Prop:=
 let '(cu,bu,ou,v):=u in b<>bu \/ofs+n<=ou \/ou+size_chunk cu<=ofs.
Lemma replay_stores_bytes_frame:forall updates m mf b ofs n,
 replay_stores m updates=Some mf ->Forall(misses_bytes b ofs n)updates ->
 0<=n ->Mem.loadbytes mf b ofs n=Mem.loadbytes m b ofs n.
Proof.
 induction updates as[|[[[cu bu]ou]v]us IH];intros m mf b ofs n RUN MISS N;cbn[replay_stores]in RUN.
 - injection RUN as<-;reflexivity.
 - destruct(Mem.store cu m bu ou v)as[ma|]eqn:ST;[|discriminate].
   inversion MISS as[|u tail HEAD TAIL];subst;rewrite(IH ma mf b ofs n RUN TAIL N).
   eapply Mem.loadbytes_store_other;[exact ST|].
   destruct HEAD as[D|[LO|HI]];[left;exact D|right;right;left;exact LO|right;right;right;exact HI].
Qed.
Definition controller_region(bx bpy bp bi:block)(u:scalar_update):Prop:=
 let '(cu,bu,ou,v):=u in
 bu=bx \/bu=bpy \/(bu=bp /\32<=ou /\ou+size_chunk cu<=40) \/
 (bu=bi /\0<=ou /\ou+size_chunk cu<=8).
Ltac update_in_controller_region:=
 cbn[controller_region];first[
 left;reflexivity|right;left;reflexivity|
 right;right;left;repeat split;try reflexivity;cbn;lia|
 right;right;right;repeat split;try reflexivity;cbn;lia].
Ltac every_controller_region:=
 lazymatch goal with
 | |-Forall _ []=>constructor
 | |-Forall _ (_::_)=>constructor;[update_in_controller_region|every_controller_region]end.
Lemma controller_updates_regions:forall bx bpy bp bi flight kp kd ki kv ka pex pey sex sey rsx rsy rax ray ix iy traj total,
 Forall(controller_region bx bpy bp bi)
 (controller_updates flight bx bpy bp bi kp kd ki kv ka pex pey sex sey rsx rsy rax ray ix iy traj total).
Proof.
 intros;cbv beta iota zeta delta[controller_updates first_four_updates clamp_updates flight_updates app];
 destruct flight;every_controller_region.
Qed.
Lemma controller_region_misses:forall bx bpy bp bi b ofs n,
 b<>bx ->b<>bpy ->
 (b<>bp \/ofs+n<=32 \/40<=ofs) ->
 (b<>bi \/ofs+n<=0 \/8<=ofs) ->
 forall u,controller_region bx bpy bp bi u ->misses_bytes b ofs n u.
Proof.
 intros bx bpy bp bi b ofs n BX BY BP BI[[[cu bu]ou]v]AL;cbn[controller_region]in AL;cbn[misses_bytes].
 destruct AL as[EQ|[EQ|[[EQ[LO HI]]|[EQ[LO HI]]]]];subst bu.
 - left;exact BX.
 - left;exact BY.
 - destruct BP as[NE|[LOW|HIGH]];[left;exact NE|right;left;lia|right;right;lia].
 - destruct BI as[NE|[LOW|HIGH]];[left;exact NE|right;left;lia|right;right;lia].
Qed.
Print Assumptions controller_updates_regions.
