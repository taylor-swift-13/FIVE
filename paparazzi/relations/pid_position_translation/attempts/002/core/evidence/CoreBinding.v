From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Errors Maps AST Integers Floats Values Memory Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cexec Cstrategy Smallstep.
From FiveGuidanceAllocation Require Import StackAllocation.
From FiveGuidanceEntry Require Import BigstepSupport StackCleanup FunctionAllocation.
From PidPositionRunPos Require Import Source Execution.
From PidPositionTranslationSupport Require Import MemoryLayout.
From PidPositionTranslationCore Require Import FactoryMemory FactorySemantics CoreMemory CoreSemantics ClampSemantics CoreClamp FlightSemantics CoreTail ControllerPrefix ReturnSemantics CoreBody.
From PidPositionSafety Require Import FactoryCall.
Import ListNotations.
Open Scope Z_scope.

From PidPositionTranslationCore Require Import CoreCall.
Definition ExpectedOriginalCoreCsem:Prop:=
forall m bp be bs gh bi bt bu bh bfun ret(flight:bool)
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
 star Csem.step ge
 (Callstate(Internal S.f_guidance_pid_h_run)[Vptr ret Ptrofs.zero;Vint(if flight then Int.one else Int.zero);Vptr gh Ptrofs.zero]Kstop m)
 E0(Returnstate Vundef Kstop mf) /\
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
Theorem bound_original_core_csem:ExpectedOriginalCoreCsem.
Proof. exact original_h_run_csem_normal. Qed.
Print Assumptions bound_original_core_csem.
Check bound_original_core_csem.
Print bound_original_core_csem.
