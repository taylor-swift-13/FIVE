From Stdlib Require Import List ZArith.
From compcert Require Import Integers Floats Values Memory Memdata Events Globalenvs Csem.
Require StateSpeedSetNedISupport.Setup StateSpeedSetEcefISupport.Setup StateSpeedGetterSupport.Setup.
Import ListNotations.
Open Scope Z_scope.
Module N:=StateSpeedSetNedISupport.Setup.
Module EI:=StateSpeedSetEcefISupport.Setup.
Module G:=StateSpeedGetterSupport.Setup.
Definition accepted_id:=Int.repr 65535.
Record ProtocolInput(m:mem)(sb ns es:block)(nx ny nz ex ey ez:int):Prop:={
 input_symbol:Genv.find_symbol G.ge G.S._state=Some sb;
 input_state_writable:Mem.range_perm m sb 0 656 Cur Writable;
 input_filter:Mem.load Mint16unsigned m sb 282=Some(Vint(Int.repr 65535));
 input_ned_separate:ns<>sb;
 input_ecef_separate:es<>sb;
 input_ned_words:N.VecRead m ns nx ny nz;
 input_ecef_words:EI.VecRead m es ex ey ez
}.
Record ProtocolRun(m mn me mf:mem)(sb ns es:block)(nx ny nz ex ey ez:int):Prop:={
 run_ned:N.NormalCall accepted_id ns m mn;
 run_ecef:EI.NormalCall accepted_id es mn me;
 run_getter:G.NormalCall me mf sb;
 ned_effects:N.SetterResult m mn sb ns nx ny nz;
 ecef_effects:EI.SetterResult mn me sb es ex ey ez;
 getter_effects:G.GetterResult me mf sb nx ny nz;
 stale_ned_x:Mem.load Mint32 me sb 296=Some(Vint nx);
 stale_ned_y:Mem.load Mint32 me sb 300=Some(Vint ny);
 stale_ned_z:Mem.load Mint32 me sb 304=Some(Vint nz);
 final_ecef_x:Mem.load Mint32 mf sb 284=Some(Vint ex);
 final_ecef_y:Mem.load Mint32 mf sb 288=Some(Vint ey);
 final_ecef_z:Mem.load Mint32 mf sb 292=Some(Vint ez)
}.
Definition observe_bits(m:mem)(sb:block):option(int*int*int):=
 match Mem.load Mfloat32 m sb 328,Mem.load Mfloat32 m sb 332,Mem.load Mfloat32 m sb 336 with
 |Some(Vsingle x),Some(Vsingle y),Some(Vsingle z)=>Some(Float32.to_bits x,Float32.to_bits y,Float32.to_bits z)
 |_,_,_=>None end.
Definition bits_of(x y z:int):int*int*int:=(Float32.to_bits(G.decode x),Float32.to_bits(G.decode y),Float32.to_bits(G.decode z)).
Definition S:int:=Int.repr 524288.
Definition E:int:=Int.repr 1048576.
Definition expected_bits:int*int*int:=(Int.repr 1073741824,Int.zero,Int.zero).
Record WitnessPair:Prop:={
 witness_ma:mem;witness_mb:mem;witness_sb:block;
 witness_na:block;witness_ea:block;witness_nb:block;witness_eb:block;
 witness_mna:mem;witness_mea:mem;witness_mfa:mem;
 witness_mnb:mem;witness_meb:mem;witness_mfb:mem;
 witness_initial_bytes:list memval;
 witness_input_a:ProtocolInput witness_ma witness_sb witness_na witness_ea Int.zero Int.zero Int.zero E Int.zero Int.zero;
 witness_input_b:ProtocolInput witness_mb witness_sb witness_nb witness_eb S Int.zero Int.zero E Int.zero Int.zero;
 witness_initial_a:Mem.loadbytes witness_ma witness_sb 0 656=Some witness_initial_bytes;
 witness_initial_b:Mem.loadbytes witness_mb witness_sb 0 656=Some witness_initial_bytes;
 witness_run_a:ProtocolRun witness_ma witness_mna witness_mea witness_mfa witness_sb witness_na witness_ea Int.zero Int.zero Int.zero E Int.zero Int.zero;
 witness_run_b:ProtocolRun witness_mb witness_mnb witness_meb witness_mfb witness_sb witness_nb witness_eb S Int.zero Int.zero E Int.zero Int.zero
}.
