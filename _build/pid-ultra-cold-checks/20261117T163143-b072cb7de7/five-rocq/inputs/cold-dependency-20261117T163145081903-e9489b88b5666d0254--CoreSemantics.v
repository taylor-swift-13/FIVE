From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Errors Maps AST Integers Values Memory Memdata Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cstrategy Smallstep.
From PidPositionRunPos Require Import Source Execution.
From FiveGuidanceEntry Require Import BigstepSupport.
From PidPositionTranslationSupport Require Import MemoryLayout.
From PidPositionTranslationCore Require Import FactoryMemory FactorySemantics CoreMemory.
Import ListNotations.
Open Scope Z_scope.
Eval vm_compute in (path_info gh_type [S._ref;S._speed;S._x],path_info gh_type [S._ref;S._accel;S._x],path_info pid_type [S._cmd_earth;S._x]).
Ltac core_rv EX EY EG NP NE NS SP SE SS NI SI NM SM :=
 lazymatch goal with
 | |- eval_simple_rvalue _ _ _ (Eval _ _) _=>constructor
 | |- eval_simple_rvalue _ _ _ (Ebinop ?op _ _ _) _=>eapply esr_binop;[core_rv EX EY EG NP NE NS SP SE SS NI SI NM SM|core_rv EX EY EG NP NE NS SP SE SS NI SI NM SM|reflexivity]
 | |- eval_simple_rvalue _ _ _ (Eunop _ _ _) _=>eapply esr_unop;[core_rv EX EY EG NP NE NS SP SE SS NI SI NM SM|reflexivity]
 | |- eval_simple_rvalue _ _ _ (Ecast _ _) _=>eapply esr_cast;[core_rv EX EY EG NP NE NS SP SE SS NI SI NM SM|reflexivity]
 | |- eval_simple_rvalue _ _ _ (Evalof ?l ?ty) _=>
   let mode:=eval hnf in(access_mode ty)in
   lazymatch mode with
   | By_copy=>eapply esr_rvalof;[core_lv EX EY EG NP NE NS SP SE SS NI SI NM SM|reflexivity|reflexivity|apply deref_loc_copy;reflexivity]
   | By_value ?ch=>eapply read_scalar with(chunk:=ch);
      [core_lv EX EY EG NP NE NS SP SE SS NI SI NM SM|reflexivity|reflexivity|reflexivity|
       lazymatch goal with|-Mem.loadv ?c ?mm(Vptr ?bb ?oo)=Some ?vv=>
       let ox:=eval vm_compute in(Ptrofs.unsigned oo)in change(Mem.load c mm bb ox=Some vv);scalar_frame;first[eassumption|reflexivity] end]
   end
 | |- eval_simple_rvalue _ _ _ (Eaddrof _ _) _=>apply esr_addrof;core_lv EX EY EG NP NE NS SP SE SS NI SI NM SM
 end
with core_lv EX EY EG NP NE NS SP SE SS NI SI NM SM :=
 lazymatch goal with
 | |- eval_simple_lvalue _ _ _ (Evar ?id _) _ _ _=>
   lazymatch id with
   | S._pd_x=>eapply esl_var_local;exact EX
   | S._pd_y=>eapply esl_var_local;exact EY
   | S._gh=>eapply esl_var_local;exact EG
   | S._guidance_pid=>eapply esl_var_global;[exact NP|exact SP]
   | S._guidance_pid_pos_err=>eapply esl_var_global;[exact NE|exact SE]
   | S._guidance_pid_trim_att_integrator=>eapply esl_var_global;[exact NI|exact SI]
   | S._traj_max_bank=>eapply esl_var_global;[exact NM|exact SM]
   | S._total_max_bank=>eapply esl_var_global;[exact NM|exact SM]
   | S._guidance_pid_speed_err=>eapply esl_var_global;[exact NS|exact SS]
   end
 | |- eval_simple_lvalue _ _ _ (Ederef _ _) _ _ _=>eapply esl_deref;core_rv EX EY EG NP NE NS SP SE SS NI SI NM SM
 | |- eval_simple_lvalue _ _ _ (Efield ?r _ _) _ _ _=>
   let rt:=eval cbv beta iota zeta delta[typeof]in(typeof r)in
   lazymatch rt with
   | Tstruct _ _=>eapply esl_field_struct;[core_rv EX EY EG NP NE NS SP SE SS NI SI NM SM|reflexivity|cenv_lookup|cfield_lookup]
   | Tunion _ _=>eapply esl_field_union;[core_rv EX EY EG NP NE NS SP SE SS NI SI NM SM|reflexivity|idtac|cenv_lookup];cfield_lookup
   end
 end.
Definition pd_bits(kp kd pe se:int):int:=
 Int.add(Int.shr(Int.mul kp pe)(Int.repr 6))
 (Int.shr(Int.mul kd(Int.shr se(Int.repr 2)))(Int.repr 15)).
Definition feedforward_bits(pd kv rs ka ra:int):int:=
 Int.add(Int.add pd(Int.shr(Int.mul kv rs)(Int.repr 17)))
 (Int.shr(Int.mul ka ra)(Int.repr 8)).
Fixpoint first_statements(n:nat)(s:statement):statement:=
 match n with O=>Sskip|Datatypes.S n=>match s with Ssequence a b=>Ssequence a(first_statements n b)|_=>s end end.
Definition core_first_four:=first_statements 4(fn_body S.f_guidance_pid_h_run).

Definition first_four_updates(bx bpy bp:block)(kp kd kv ka pex pey sex sey rsx rsy rax ray:int):list scalar_update:=
 [(Mint32,bx,0,Vint(pd_bits kp kd pex sex));(Mint32,bpy,0,Vint(pd_bits kp kd pey sey));
 (Mint32,bp,32,Vint(feedforward_bits(pd_bits kp kd pex sex)kv rsx ka rax));
 (Mint32,bp,36,Vint(feedforward_bits(pd_bits kp kd pey sey)kv rsy ka ray))].
Theorem original_core_first_four:forall e m bp be bs gh bg bx bpy kp kd kv ka pex pey sex sey rsx rsy rax ray,
 e!S._pd_x=Some(bx,tint) ->e!S._pd_y=Some(bpy,tint) ->
 e!S._gh=Some(bg,tptr gh_type) ->
 e!S._guidance_pid=None ->e!S._guidance_pid_pos_err=None ->e!S._guidance_pid_speed_err=None ->
 Genv.find_symbol ge S._guidance_pid=Some bp ->
 Genv.find_symbol ge S._guidance_pid_pos_err=Some be ->
 Genv.find_symbol ge S._guidance_pid_speed_err=Some bs ->
 NoDup[bx;bpy;bg;bp;be;bs;gh] ->
 Mem.load Mint64 m bg 0=Some(Vptr gh Ptrofs.zero) ->
 Mem.load Mint32 m bp 0=Some(Vint kp) ->
 Mem.load Mint32 m bp 4=Some(Vint kd) ->
 Mem.load Mint32 m bp 12=Some(Vint kv) ->
 Mem.load Mint32 m bp 16=Some(Vint ka) ->
 Mem.load Mint32 m be 0=Some(Vint pex) ->
 Mem.load Mint32 m be 4=Some(Vint pey) ->
 Mem.load Mint32 m bs 0=Some(Vint sex) ->
 Mem.load Mint32 m bs 4=Some(Vint sey) ->
 Mem.load Mint32 m gh 52=Some(Vint rsx) ->
 Mem.load Mint32 m gh 56=Some(Vint rsy) ->
 Mem.load Mint32 m gh 60=Some(Vint rax) ->
 Mem.load Mint32 m gh 64=Some(Vint ray) ->
 Mem.valid_access m Mint32 bx 0 Writable ->
 Mem.valid_access m Mint32 bpy 0 Writable ->
 Mem.valid_access m Mint32 bp 32 Writable ->
 Mem.valid_access m Mint32 bp 36 Writable ->
 exists mf,
 Cstrategy.exec_stmt ge e m core_first_four E0 mf Out_normal /\
 Mem.load Mint32 mf bx 0=Some(Vint(pd_bits kp kd pex sex)) /\
 Mem.load Mint32 mf bpy 0=Some(Vint(pd_bits kp kd pey sey)) /\
 Mem.load Mint32 mf bp 32=Some(Vint(feedforward_bits(pd_bits kp kd pex sex)kv rsx ka rax)) /\
 Mem.load Mint32 mf bp 36=Some(Vint(feedforward_bits(pd_bits kp kd pey sey)kv rsy ka ray)) /\
 raw_writes(fun b=>b=bx\/b=bpy\/b=bp)m mf /\ replay_stores m(first_four_updates bx bpy bp kp kd kv ka pex pey sex sey rsx rsy rax ray)=Some mf.
Proof.
 intros e m bp be bs gh bg bx bpy kp kd kv ka pex pey sex sey rsx rsy rax ray
 EX EY EG NP NE NS SP SE SS SEP GP
 LKP LKD LKV LKA LPEX LPEY LSEX LSEY LRSX LRSY LRAX LRAY AX AY ACX ACY.
 assert(DIST:bx<>bpy /\ bx<>bg /\ bx<>bp /\ bx<>be /\ bx<>bs /\ bx<>gh /\ bpy<>bg /\ bpy<>bp /\ bpy<>be /\ bpy<>bs /\ bpy<>gh /\ bg<>bp /\ bg<>be /\ bg<>bs /\ bg<>gh /\ bp<>be /\ bp<>bs /\ bp<>gh /\ be<>bs /\ be<>gh /\ bs<>gh).
 { repeat rewrite NoDup_cons_iff in SEP;simpl in SEP;intuition congruence. }
 destruct DIST as(D0&D1&D2&D3&D4&D5&D6&D7&D8&D9&D10&D11&D12&D13&D14&D15&D16&D17&D18&D19&D20).
 destruct(Mem.valid_access_store m Mint32 bx 0(Vint(pd_bits kp kd pex sex))AX)as[m1 ST1].
 assert(A2:Mem.valid_access m1 Mint32 bpy 0 Writable).
 { eapply Mem.store_valid_access_1;[exact ST1|]. exact AY. }
 destruct(Mem.valid_access_store m1 Mint32 bpy 0(Vint(pd_bits kp kd pey sey))A2)as[m2 ST2].
 assert(A3:Mem.valid_access m2 Mint32 bp 32 Writable).
 { eapply Mem.store_valid_access_1;[exact ST2|]. eapply Mem.store_valid_access_1;[exact ST1|]. exact ACX. }
 destruct(Mem.valid_access_store m2 Mint32 bp 32(Vint(feedforward_bits(pd_bits kp kd pex sex)kv rsx ka rax))A3)as[m3 ST3].
 assert(A4:Mem.valid_access m3 Mint32 bp 36 Writable).
 { eapply Mem.store_valid_access_1;[exact ST3|]. eapply Mem.store_valid_access_1;[exact ST2|]. eapply Mem.store_valid_access_1;[exact ST1|]. exact ACY. }
 destruct(Mem.valid_access_store m3 Mint32 bp 36(Vint(feedforward_bits(pd_bits kp kd pey sey)kv rsy ka ray))A4)as[mf ST4].
 exists mf;split.
 - unfold core_first_four;cbn[first_statements S.f_guidance_pid_h_run fn_body].
   eapply sequence_normal;[eapply atomic_assign;
     [core_lv EX EY EG NP NE NS SP SE SS I I I I|reflexivity|core_rv EX EY EG NP NE NS SP SE SS I I I I|reflexivity|reflexivity|
      eapply assign_loc_value;[reflexivity|reflexivity|exact ST1]|reflexivity]|].
   eapply sequence_normal;[eapply atomic_assign;
     [core_lv EX EY EG NP NE NS SP SE SS I I I I|reflexivity|core_rv EX EY EG NP NE NS SP SE SS I I I I|reflexivity|reflexivity|
      eapply assign_loc_value;[reflexivity|reflexivity|exact ST2]|reflexivity]|].
   eapply sequence_normal;[eapply atomic_assign;
     [core_lv EX EY EG NP NE NS SP SE SS I I I I|reflexivity|core_rv EX EY EG NP NE NS SP SE SS I I I I|reflexivity|reflexivity|
      eapply assign_loc_value;[reflexivity|reflexivity|exact ST3]|reflexivity]|].
   eapply sequence_normal;[eapply atomic_assign;
     [core_lv EX EY EG NP NE NS SP SE SS I I I I|reflexivity|core_rv EX EY EG NP NE NS SP SE SS I I I I|reflexivity|reflexivity|
      eapply assign_loc_value;[reflexivity|reflexivity|exact ST4]|reflexivity]|].
   constructor.
 - repeat split;try(scalar_frame;reflexivity).
   eapply raw_writes_store;[left;reflexivity|exact ST1|].
   eapply raw_writes_store;[right;left;reflexivity|exact ST2|].
   eapply raw_writes_store;[right;right;reflexivity|exact ST3|].
   eapply raw_writes_store;[right;right;reflexivity|exact ST4|constructor].
   cbv beta iota zeta delta[first_four_updates replay_stores];rewrite ST1,ST2,ST3,ST4;reflexivity.
Qed.
Print Assumptions original_core_first_four.
