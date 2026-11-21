From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Errors Maps AST Integers Floats Values Memory Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cexec Cstrategy Smallstep.
From FiveGuidanceAllocation Require Import StackAllocation.
From FiveGuidanceEntry Require Import BigstepSupport StackCleanup FunctionAllocation.
From PidPositionRunPos Require Import Source Execution.
From PidPositionTranslationSupport Require Import MemoryLayout.
From PidPositionTranslationCore Require Import FactoryMemory FactorySemantics CoreMemory CoreSemantics ClampSemantics CoreClamp FlightSemantics CoreTail ControllerPrefix ReturnSemantics CoreBody.
From PidPositionTranslationCore Require Import CoreCall.
From PidPositionSafety Require Import FactoryCall CoreCallAllOrder.
From FiveGuidanceAllOrder Require Import PhaseComposition.
Import ListNotations.
Open Scope Z_scope.
Lemma nodup_app_separated:forall(A:Type)(xs ys:list A),NoDup xs ->NoDup ys ->
 (forall x,In x xs ->~In x ys) ->NoDup(xs++ys).
Proof.
 intros A xs ys ND;induction ND;intros NY SEP;cbn;[exact NY|constructor].
 - intro IN;apply in_app_iff in IN as[IN|IN];[contradiction|exact(SEP x ltac:(left;reflexivity)IN)].
 - apply IHND;[exact NY|intros x0 IN;apply SEP;right;exact IN].
Qed.
Theorem original_h_run_joint_funcall:forall m bp be bs gh bi bt bu bh bfun ret(flight:bool)
 kp kd ki kv ka pex pey sex sey rsx rsy rax ray ix iy traj total(h:float32)(heading:int),
 Genv.find_symbol ge S._guidance_pid=Some bp ->
 Genv.find_symbol ge S._guidance_pid_pos_err=Some be ->
 Genv.find_symbol ge S._guidance_pid_speed_err=Some bs ->
 Genv.find_symbol ge S._guidance_pid_trim_att_integrator=Some bi ->
 Genv.find_symbol ge S._traj_max_bank=Some bt ->Genv.find_symbol ge S._total_max_bank=Some bu ->
 Genv.find_symbol ge S._guidance_h=Some bh ->Genv.find_symbol ge S._stab_sp_from_ltp_i=Some bfun ->
 Genv.find_funct ge(Vptr bfun Ptrofs.zero)=Some(Internal S.f_stab_sp_from_ltp_i) ->
 NoDup[bp;be;bs;gh;bi;bt;bu] ->ret<>bp ->ret<>bi ->bh<>bp ->bh<>bi ->
 Mem.load Mint8unsigned m bp 44=Some(Vint Int.zero) ->
 Mem.load Mint32 m bp 0=Some(Vint kp) ->
 Mem.load Mint32 m bp 4=Some(Vint kd) ->
 Mem.load Mint32 m bp 8=Some(Vint ki) ->
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
 Mem.load Mint32 m bi 0=Some(Vint ix) ->
 Mem.load Mint32 m bi 4=Some(Vint iy) ->
 Mem.load Mint32 m bt 0=Some(Vint traj) ->
 Mem.load Mint32 m bu 0=Some(Vint total) ->
 Mem.load Mfloat32 m bh 28=Some(Vsingle h) ->
 sem_cast(Vsingle(Float32.mul h(Float32.of_int(Int.repr 4096))))tfloat tint m=Some(Vint heading) ->
 Mem.range_perm m bp 32 40 Cur Readable ->Mem.range_perm m ret 0 36 Cur Writable ->
 Mem.valid_access m Mint32 bi 0 Writable ->Mem.valid_access m Mint32 bi 4 Writable ->
 Mem.valid_access m Mint32 bp 32 Writable ->Mem.valid_access m Mint32 bp 36 Writable ->
 exists mf,
 eval_funcall ge m(Internal S.f_guidance_pid_h_run)
 [Vptr ret Ptrofs.zero;Vint(if flight then Int.one else Int.zero);Vptr gh Ptrofs.zero]E0 mf Vundef /\
 (forall base,is_call_cont base ->exists P,certificate ge P(Returnstate Vundef base mf)/\
 P(Callstate(Internal S.f_guidance_pid_h_run)
 [Vptr ret Ptrofs.zero;Vint(if flight then Int.one else Int.zero);Vptr gh Ptrofs.zero]base m)) /\
 active_fields mf ret
 (controller_command flight kp kd ki kv ka pex sex rsx rax ix traj total)
 (controller_command flight kp kd ki kv ka pey sey rsy ray iy traj total)heading /\
 Mem.load Mint32 mf bi 0=Some(Vint(next_integral flight ix ki(pd_bits kp kd pex sex)traj)) /\
 Mem.load Mint32 mf bi 4=Some(Vint(next_integral flight iy ki(pd_bits kp kd pey sey)traj)) /\
 Mem.load Mint32 mf bp 32=Some(Vint(controller_command flight kp kd ki kv ka pex sex rsx rax ix traj total)) /\
 Mem.load Mint32 mf bp 36=Some(Vint(controller_command flight kp kd ki kv ka pey sey rsy ray iy traj total)) /\
 access_preserved m mf /\
 (forall ch b ofs,Mem.valid_block m b ->b<>bp ->b<>bi ->b<>ret ->Mem.load ch mf b ofs=Mem.load ch m b ofs) /\
 (forall b ofs n,Mem.valid_block m b ->b<>bp ->b<>bi ->b<>ret ->0<=n ->Mem.loadbytes mf b ofs n=Mem.loadbytes m b ofs n).
Proof.
 intros m bp be bs gh bi bt bu bh bfun ret flight kp kd ki kv ka pex pey sex sey rsx rsy rax ray ix iy traj total h heading
 SP SE SS SI ST SU SH SF FF NDGLOBAL RETP RETI HP HI APPROX
 LKP LKD LKI LKV LKA LPEX LPEY LSEX LSEY LRSX LRSY LRAX LRAY LIX LIY LT LU HEAD CAST RVS WR AIX AIY ACX ACY.

 pose proof(CoreCall.original_h_run_funcall m bp be bs gh bi bt bu bh bfun ret flight kp kd ki kv ka pex pey sex sey rsx rsy rax ray ix iy traj total h heading)as NN.
 repeat specialize(NN ltac:(eassumption)).
 destruct NN as[nf[CALL REST]].
 pose proof(CoreCallAllOrder.original_h_run_funcall_certificate m bp be bs gh bi bt bu bh bfun ret flight kp kd ki kv ka pex pey sex sey rsx rsy rax ray ix iy traj total h heading)as AA.
 repeat specialize(AA ltac:(eassumption)).
 destruct AA as[mf[CAL RESTA]].
 destruct(CAL Kstop I)as[P[CERT INIT]].
 assert(PATH:star Csem.step ge(Callstate(Internal S.f_guidance_pid_h_run)
 [Vptr ret Ptrofs.zero;Vint(if flight then Int.one else Int.zero);Vptr gh Ptrofs.zero]Kstop m)
 E0(Returnstate Vundef Kstop nf)).
 { apply funcall_original_normal;exact CALL. }
 destruct(certificate_normal_unique ge P Vundef mf _ CERT INIT E0 Vundef nf PATH)as[_ EQ].
 subst nf;exists mf;exact(conj CALL(conj CAL REST)).
Qed.
Print Assumptions original_h_run_joint_funcall.
