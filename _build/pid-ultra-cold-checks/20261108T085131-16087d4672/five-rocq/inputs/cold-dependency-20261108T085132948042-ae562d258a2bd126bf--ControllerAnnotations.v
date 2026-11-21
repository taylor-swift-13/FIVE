From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Maps AST Integers Values Memory Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cstrategy.
From PidPositionRunPos Require Import Source Execution.
From PidPositionTranslationSupport Require Import MemoryLayout.
From PidPositionTranslationCore Require Import FactoryMemory FactorySemantics CoreSemantics CoreClamp.
From PidPositionSafety Require Import PureSound.
From FiveGuidanceEntry Require Import BigstepSupport.
From FiveGuidanceAllOrder Require Import PureDenotation.
From CoreCBMC Require Import NumericBounds ArithmeticTree.
Import ListNotations.
Open Scope Z_scope.
Local Transparent Int.signed Int.unsigned NumericBounds.signed32.
Definition controller_expression(n:nat):expr:=
 match top_statement n(fn_body S.f_guidance_pid_h_run)with Sdo a=>a|_=>Eval Vundef tvoid end.

Record controller_leaf_context(e:env)(m:mem)(bp be bs gh bg bx bpy:block)
 (kp kd kv ka pex pey sex sey rsx rsy rax ray:int):Prop:={
 alc_ex:e!S._pd_x=Some(bx,tint);alc_ey:e!S._pd_y=Some(bpy,tint);
 alc_eg:e!S._gh=Some(bg,tptr gh_type);
 alc_np:e!S._guidance_pid=None;alc_ne:e!S._guidance_pid_pos_err=None;alc_ns:e!S._guidance_pid_speed_err=None;
 alc_sp:Genv.find_symbol ge S._guidance_pid=Some bp;
 alc_se:Genv.find_symbol ge S._guidance_pid_pos_err=Some be;
 alc_ss:Genv.find_symbol ge S._guidance_pid_speed_err=Some bs;
 alc_gp:Mem.load Mint64 m bg 0=Some(Vptr gh Ptrofs.zero);
 alc_kp:Mem.load Mint32 m bp 0=Some(Vint kp);alc_kd:Mem.load Mint32 m bp 4=Some(Vint kd);
 alc_kv:Mem.load Mint32 m bp 12=Some(Vint kv);alc_ka:Mem.load Mint32 m bp 16=Some(Vint ka);
 alc_pex:Mem.load Mint32 m be 0=Some(Vint pex);alc_pey:Mem.load Mint32 m be 4=Some(Vint pey);
 alc_sex:Mem.load Mint32 m bs 0=Some(Vint sex);alc_sey:Mem.load Mint32 m bs 4=Some(Vint sey);
 alc_rsx:Mem.load Mint32 m gh 52=Some(Vint rsx);alc_rsy:Mem.load Mint32 m gh 56=Some(Vint rsy);
 alc_rax:Mem.load Mint32 m gh 60=Some(Vint rax);alc_ray:Mem.load Mint32 m gh 64=Some(Vint ray)
}.
Ltac annotation_binary EX EY EG NP NE NS SP SE SS :=
 lazymatch goal with
 | |-binary_condition ?ge ?e ?m ?op ?a ?b=>
   let av:=fresh "av" in evar(av:val);
   let AR:=fresh "AR" in assert(AR:eval_simple_rvalue ge e m a av)by(unfold av;first[core_rv EX EY EG NP NE NS SP SE SS I I I I|match goal with|-?G=>idtac "ANNOTATION READ" G;fail 2 end]);
   let aval:=eval cbv beta iota zeta delta[av]in av in
   let AP:=fresh "AP" in assert(AP:pure_rval ge e m a=Some aval)by(
     apply(proj1(simple_big_denotation ge e m));[exact AR|reflexivity]);
   clear AR av;
   let bv:=fresh "bv" in evar(bv:val);
   let BR:=fresh "BR" in assert(BR:eval_simple_rvalue ge e m b bv)by(unfold bv;first[core_rv EX EY EG NP NE NS SP SE SS I I I I|match goal with|-?G=>idtac "ANNOTATION READ" G;fail 2 end]);
   let bval:=eval cbv beta iota zeta delta[bv]in bv in
   let BP:=fresh "BP" in assert(BP:pure_rval ge e m b=Some bval)by(
     apply(proj1(simple_big_denotation ge e m));[exact BR|reflexivity]);
   clear BR bv;
   unfold binary_condition;rewrite AP,BP;cbn[binary_safe typeof];
   repeat match goal with|-context[Ctypes.type_eq tint tint]=>
    destruct(Ctypes.type_eq tint tint)as[TE|TE];[|exfalso;apply TE;reflexivity]end;
   first[assumption|
    solve[repeat rewrite Int.signed_repr by(change(-2147483648<=_<=2147483647);lia);unfold NumericBounds.signed32;lia]|
    solve[vm_compute;repeat split;congruence]|match goal with|-?G=>idtac "ANNOTATION SAFE" G;fail 2 end]
 end.
Ltac annotate_controller EX EY EG NP NE NS SP SE SS :=
 lazymatch goal with
 | |-arithmetic_tree ?ge ?e ?m ?a=>
   lazymatch a with
   | Eval _ _=>exact I
   | Evar _ _=>exact I
   | Eloc _ _ _ _=>exact I
   | Evalof ?x _=>change(arithmetic_tree ge e m x);annotate_controller EX EY EG NP NE NS SP SE SS
   | Ederef ?x _=>change(arithmetic_tree ge e m x);annotate_controller EX EY EG NP NE NS SP SE SS
   | Eaddrof ?x _=>change(arithmetic_tree ge e m x);annotate_controller EX EY EG NP NE NS SP SE SS
   | Efield ?x _ _=>change(arithmetic_tree ge e m x);annotate_controller EX EY EG NP NE NS SP SE SS
   | Eassign ?l ?r _=>
     change(arithmetic_tree ge e m l /\arithmetic_tree ge e m r);split;
     annotate_controller EX EY EG NP NE NS SP SE SS
   | Ebinop ?op ?l ?r _=>
     change(arithmetic_tree ge e m l /\arithmetic_tree ge e m r /\binary_condition ge e m op l r);
     split;[annotate_controller EX EY EG NP NE NS SP SE SS|split;
     [annotate_controller EX EY EG NP NE NS SP SE SS|annotation_binary EX EY EG NP NE NS SP SE SS]]
   | _=>idtac "ANNOTATION TREE" a;fail 2
   end
 end.

Theorem original_pd_x_arithmetic_tree :
 forall e m bp be bs gh bg bx bpy kp kd ki kv ka pex pey sex sey rsx rsy rax ray ix,
 controller_leaf_context e m bp be bs gh bg bx bpy kp kd kv ka pex pey sex sey rsx rsy rax ray ->
 axis_bounds kp kd ki kv ka pex sex rsx rax ix ->
 arithmetic_tree ge e m(controller_expression 0).
Proof.
 intros e m bp be bs gh bg bx bpy kp kd ki kv ka pex pey sex sey rsx rsy rax ray ix LEAVES BOUNDS.
 destruct LEAVES as[EX EY EG NP NE NS SP SE SS GP LKP LKD LKV LKA LPEX LPEY LSEX LSEY LRSX LRSY LRAX LRAY].
 destruct(original_axis_arithmetic_safe _ _ _ _ _ _ _ _ _ _ BOUNDS)as[PM DM PD VM PV AM FF IM IS OUT].
 unfold pd_stage,velocity_stage in *.
 unfold controller_expression;cbn[top_statement S.f_guidance_pid_h_run fn_body].
 annotate_controller EX EY EG NP NE NS SP SE SS.
Qed.
Print Assumptions original_pd_x_arithmetic_tree.
Theorem original_pd_y_arithmetic_tree :
 forall e m bp be bs gh bg bx bpy kp kd ki kv ka pex pey sex sey rsx rsy rax ray iy,
 controller_leaf_context e m bp be bs gh bg bx bpy kp kd kv ka pex pey sex sey rsx rsy rax ray ->
 axis_bounds kp kd ki kv ka pey sey rsy ray iy ->
 arithmetic_tree ge e m(controller_expression 1).
Proof.
 intros e m bp be bs gh bg bx bpy kp kd ki kv ka pex pey sex sey rsx rsy rax ray iy LEAVES BOUNDS.
 destruct LEAVES as[EX EY EG NP NE NS SP SE SS GP LKP LKD LKV LKA LPEX LPEY LSEX LSEY LRSX LRSY LRAX LRAY].
 destruct(original_axis_arithmetic_safe _ _ _ _ _ _ _ _ _ _ BOUNDS)as[PM DM PD VM PV AM FF IM IS OUT].
 unfold pd_stage,velocity_stage in *.
 unfold controller_expression;cbn[top_statement S.f_guidance_pid_h_run fn_body].
 annotate_controller EX EY EG NP NE NS SP SE SS.
Qed.
Theorem original_feedforward_x_arithmetic_tree :
 forall e m bp be bs gh bg bx bpy kp kd ki kv ka pex pey sex sey rsx rsy rax ray ix,
 controller_leaf_context e m bp be bs gh bg bx bpy kp kd kv ka pex pey sex sey rsx rsy rax ray ->
 axis_bounds kp kd ki kv ka pex sex rsx rax ix ->
 Mem.load Mint32 m bx 0=Some(Vint(pd_bits kp kd pex sex)) ->
 arithmetic_tree ge e m(controller_expression 2).
Proof.
 intros e m bp be bs gh bg bx bpy kp kd ki kv ka pex pey sex sey rsx rsy rax ray ix LEAVES BOUNDS PDX.
 destruct LEAVES as[EX EY EG NP NE NS SP SE SS GP LKP LKD LKV LKA LPEX LPEY LSEX LSEY LRSX LRSY LRAX LRAY].
 destruct(original_axis_arithmetic_safe _ _ _ _ _ _ _ _ _ _ BOUNDS)as[PM DM PD VM PV AM FF IM IS OUT].
 unfold pd_stage,velocity_stage in *.
 unfold controller_expression;cbn[top_statement S.f_guidance_pid_h_run fn_body].
 annotate_controller EX EY EG NP NE NS SP SE SS.
Qed.
Theorem original_feedforward_y_arithmetic_tree :
 forall e m bp be bs gh bg bx bpy kp kd ki kv ka pex pey sex sey rsx rsy rax ray iy,
 controller_leaf_context e m bp be bs gh bg bx bpy kp kd kv ka pex pey sex sey rsx rsy rax ray ->
 axis_bounds kp kd ki kv ka pey sey rsy ray iy ->
 Mem.load Mint32 m bpy 0=Some(Vint(pd_bits kp kd pey sey)) ->
 arithmetic_tree ge e m(controller_expression 3).
Proof.
 intros e m bp be bs gh bg bx bpy kp kd ki kv ka pex pey sex sey rsx rsy rax ray iy LEAVES BOUNDS PDY.
 destruct LEAVES as[EX EY EG NP NE NS SP SE SS GP LKP LKD LKV LKA LPEX LPEY LSEX LSEY LRSX LRSY LRAX LRAY].
 destruct(original_axis_arithmetic_safe _ _ _ _ _ _ _ _ _ _ BOUNDS)as[PM DM PD VM PV AM FF IM IS OUT].
 unfold pd_stage,velocity_stage in *.
 unfold controller_expression;cbn[top_statement S.f_guidance_pid_h_run fn_body].
 annotate_controller EX EY EG NP NE NS SP SE SS.
Qed.

Print Assumptions original_feedforward_x_arithmetic_tree.
Print Assumptions original_feedforward_y_arithmetic_tree.
