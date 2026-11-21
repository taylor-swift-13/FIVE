
From Stdlib Require Import List String ZArith Lia Bool.
From Flocq Require Import Binary.
From compcert Require Import Coqlib Errors Maps AST Integers Floats Values Memory Memdata Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem.
From StateSpeedMemory Require Import Protocol SourceComparison Refutations InitialMemory ObserverCopy.
From StateSpeedSetterSupport Require Import DefinedBytes.
Require StateSpeedSetNedISupport.Harness StateSpeedSetEcefISupport.Harness.
Import ListNotations Csyntaxdefs.CsyntaxNotations.
Local Open Scope string_scope.
Local Open Scope csyntax_scope.
Open Scope Z_scope.
Definition obs_ident:ident := $"Observation".
Definition obs_ned:ident := $"ned_status".
Definition obs_ecef:ident := $"ecef_status".
Definition obs_returned:ident := $"returned_status".
Definition obs_copied:ident := $"copied_ecef".
Definition obs_stale:ident := $"stale_ned".
Definition obs_pointer:ident := $"pointer_is_state".
Definition obs_bits:ident := $"bits".
Definition obs_before:ident := $"before_get".
Definition obs_after:ident := $"after_get".
Definition observation_composite:composite_definition:=
 Composite obs_ident Struct
 [Member_plain obs_ned tushort;Member_plain obs_ecef tushort;Member_plain obs_returned tushort;
 Member_plain obs_copied(tarray tint 3);Member_plain obs_stale(tarray tint 3);Member_plain obs_pointer tbool;
 Member_plain obs_bits(tarray tuint 3);Member_plain obs_before(tarray tuchar 656);Member_plain obs_after(tarray tuchar 656)]noattr.
Definition observation_ce:composite_env:=
 match build_composite_env [observation_composite]with OK ce=>ce|Error _=>PTree.empty _ end.
Definition observation_type:=Tstruct obs_ident noattr.
Definition observation_field_offset(id:ident):res(Z*bitfield):=
 match PTree.get obs_ident observation_ce with Some co=>field_offset observation_ce id(co_members co)|None=>Error[]end.
Theorem actual_observer_layout:
 sizeof observation_ce observation_type=1360 /\ alignof observation_ce observation_type=4 /\
 observation_field_offset obs_ned=OK(0,Full) /\observation_field_offset obs_ecef=OK(2,Full) /\
 observation_field_offset obs_returned=OK(4,Full) /\observation_field_offset obs_copied=OK(8,Full) /\
 observation_field_offset obs_stale=OK(20,Full) /\observation_field_offset obs_pointer=OK(32,Full) /\
 observation_field_offset obs_bits=OK(36,Full) /\observation_field_offset obs_before=OK(48,Full) /\
 observation_field_offset obs_after=OK(704,Full).
Proof. vm_compute;repeat split;reflexivity. Qed.

Definition three_int_bytes(v:int*int*int):list memval:=
 let '(x,y,z):=v in encode_val Mint32(Vint x)++encode_val Mint32(Vint y)++encode_val Mint32(Vint z).
Lemma single_bit_encoding:forall f,
 encode_val Mfloat32(Vsingle f)=encode_val Mint32(Vint(Float32.to_bits f)).
Proof. reflexivity. Qed.
Lemma complete_float_bit_bytes:forall x y z,
 G.float_bytes x y z=three_int_bytes(bits_of x y z).
Proof. intros;unfold G.float_bytes,three_int_bytes,bits_of;rewrite!single_bit_encoding;reflexivity. Qed.
Lemma three_int_bytes_length:forall v,length(three_int_bytes v)=12%nat.
Proof. intros[[x y]z];unfold three_int_bytes;rewrite!app_length,!encode_val_length;reflexivity. Qed.
Definition pointer_is_state(p:val)(sb:block):bool:=
 match p with Vptr b ofs=>Pos.eqb b sb&&Ptrofs.eq ofs(Ptrofs.repr 328)|_=>false end.
Lemma actual_pointer_comparison:forall sb,pointer_is_state(Vptr sb(Ptrofs.repr 328))sb=true.
Proof. intros;unfold pointer_is_state;rewrite Pos.eqb_refl,Ptrofs.eq_true;reflexivity. Qed.

Record Observation:Type:={
 ned_status:int;ecef_status:int;returned_status:int;
 copied_ecef:int*int*int;stale_ned:int*int*int;
 pointer_flag:bool;returned_bits:int*int*int;
 before_get:list memval;after_get:list memval
}.
Definition concrete_observation(nx ny nz ex ey ez:int)(before after:list memval):Observation:=
 {|ned_status:=Int.repr 2;ecef_status:=Int.one;returned_status:=Int.repr 33;
 copied_ecef:=(ex,ey,ez);stale_ned:=(nx,ny,nz);pointer_flag:=true;
 returned_bits:=bits_of nx ny nz;before_get:=before;after_get:=after|}.
Definition reads_three(m:mem)(sb:block)(base:Z)(words:int*int*int):Prop:=
 let '(x,y,z):=words in
 Mem.load Mint32 m sb base=Some(Vint x) /\
 Mem.load Mint32 m sb(base+4)=Some(Vint y) /\
 Mem.load Mint32 m sb(base+8)=Some(Vint z).
Record Observes(mn me mf:mem)(sb:block)(o:Observation):Prop:={
 observed_ned:Mem.load Mint16unsigned mn sb 280=Some(Vint(ned_status o));
 observed_ecef:Mem.load Mint16unsigned me sb 280=Some(Vint(ecef_status o));
 observed_returned_status:Mem.load Mint16unsigned mf sb 280=Some(Vint(returned_status o));
 observed_copied:reads_three me sb 284(copied_ecef o);
 observed_stale:reads_three me sb 296(stale_ned o);
 observed_actual_return:G.NormalCall me mf sb;
 observed_pointer:pointer_flag o=pointer_is_state(Vptr sb(Ptrofs.repr 328))sb;
 observed_bits:observe_bits mf sb=Some(returned_bits o);
 observed_immediate_complete_copy:Mem.loadbytes mf sb 328 12=Some(three_int_bytes(returned_bits o));
 observed_before:Mem.loadbytes me sb 0 656=Some(before_get o);
 observed_after:Mem.loadbytes mf sb 0 656=Some(after_get o)
}.
Lemma state_readable:forall m sb,Mem.range_perm m sb 0 656 Cur Writable->
 Mem.range_perm m sb 0 656 Cur Readable.
Proof. intros;eapply Mem.range_perm_implies;[eassumption|constructor]. Qed.
Theorem actual_protocol_observer:forall m mn me mf sb ns es nx ny nz ex ey ez,
 ProtocolInput m sb ns es nx ny nz ex ey ez->
 ProtocolRun m mn me mf sb ns es nx ny nz ex ey ez->
 exists before after,Observes mn me mf sb(concrete_observation nx ny nz ex ey ez before after).
Proof.
 intros m mn me mf sb ns es nx ny nz ex ey ez INPUT RUN.
 pose proof(ned_effects _ _ _ _ _ _ _ _ _ _ _ _ _ RUN)as RN.
 pose proof(ecef_effects _ _ _ _ _ _ _ _ _ _ _ _ _ RUN)as RE.
 pose proof(getter_effects _ _ _ _ _ _ _ _ _ _ _ _ _ RUN)as RG.
 pose proof(ecef_input_after_ned _ _ _ _ _ _ _ _ _ _ _ INPUT RN)as EINPUT.
 pose proof(getter_input_after_ecef _ _ _ _ _ _ _ _ _ _ _ _ EINPUT RN RE(input_symbol _ _ _ _ _ _ _ _ _ _ INPUT))as GINPUT.
 destruct GINPUT as[SYM[WR[STATUS[GX[GY GZ]]]]].
 assert(WRF:Mem.range_perm mf sb 0 656 Cur Writable).
 { intros i RANGE;apply(proj1(G.result_permissions _ _ _ _ _ _ RG sb i Cur Writable));apply WR;exact RANGE. }
 destruct(Mem.range_perm_loadbytes me sb 0 656(state_readable _ _ WR))as[before BEFORE].
 destruct(Mem.range_perm_loadbytes mf sb 0 656(state_readable _ _ WRF))as[after AFTER].
 exists before,after;constructor;cbn[concrete_observation reads_three].
 - exact(N.result_status _ _ _ _ _ _ _ RN).
 - exact(EI.result_status _ _ _ _ _ _ _ RE).
 - exact(G.result_status _ _ _ _ _ _ RG).
 - repeat split;[exact(EI.result_x _ _ _ _ _ _ _ RE)|exact(EI.result_y _ _ _ _ _ _ _ RE)|exact(EI.result_z _ _ _ _ _ _ _ RE)].
 - repeat split;[exact(stale_ned_x _ _ _ _ _ _ _ _ _ _ _ _ _ RUN)|exact(stale_ned_y _ _ _ _ _ _ _ _ _ _ _ _ _ RUN)|exact(stale_ned_z _ _ _ _ _ _ _ _ _ _ _ _ _ RUN)].
 - exact(run_getter _ _ _ _ _ _ _ _ _ _ _ _ _ RUN).
 - symmetry;apply actual_pointer_comparison.
 - eapply observed_getter_result;exact RG.
 - change(Mem.loadbytes mf sb 328 12=Some(three_int_bytes(bits_of nx ny nz))).
   rewrite <-complete_float_bit_bytes;exact(G.result_bytes _ _ _ _ _ _ RG).
 - exact BEFORE.
 - exact AFTER.
Qed.

Lemma nth_getN:forall n i p c,(i<n)%nat->
 nth_error(Mem.getN n p c)i=Some(ZMap.get(p+Z.of_nat i)c).
Proof.
 induction n;intros i p c LT;[lia|];destruct i;cbn[Mem.getN nth_error].
 - f_equal;f_equal;lia.
 - rewrite IHn by lia;f_equal;f_equal;lia.
Qed.
Local Transparent Mem.loadbytes.
Lemma loadbytes_index:forall m b ofs len bytes i,
 Mem.loadbytes m b ofs len=Some bytes->0<=i<len->
 nth_error bytes(Z.to_nat i)=
 option_map(fun xs=>hd Undef xs)(Mem.loadbytes m b(ofs+i)1).
Proof.
 intros m b ofs len bytes i LOAD RANGE;unfold Mem.loadbytes in LOAD.
 destruct(Mem.range_perm_dec m b ofs(ofs+len)Cur Readable)as[RP|BAD];try discriminate.
 injection LOAD as EQ;subst bytes.
 unfold Mem.loadbytes;rewrite pred_dec_true by(intros j R;apply RP;lia).
 cbn[Mem.getN option_map hd].
 rewrite nth_getN by(apply Nat2Z.inj_lt;rewrite!Z2Nat.id by lia;lia).
 rewrite Z2Nat.id by lia;reflexivity.
Qed.
Lemma observer_frame_byte:forall m mf sb x y z before after i,
 G.GetterResult m mf sb x y z->
 Mem.loadbytes m sb 0 656=Some before->Mem.loadbytes mf sb 0 656=Some after->
 0<=i<656->~(280<=i<282 \/328<=i<340)->
 nth_error before(Z.to_nat i)=nth_error after(Z.to_nat i).
Proof.
 intros m mf sb x y z before after i RESULT BEFORE AFTER RANGE OUT.
 rewrite(loadbytes_index _ _ _ _ _ _ BEFORE RANGE),(loadbytes_index _ _ _ _ _ _ AFTER RANGE).
 replace(0+i)with i by lia.
 rewrite(G.result_frame _ _ _ _ _ _ RESULT sb i 1)by(intros;unfold G.write_byte in *;intuition lia).
 reflexivity.
Qed.

Definition harness_assertion(k:nat)(a b:Observation):Prop:=
 match k with
 | 1%nat=>ned_status a=Int.repr 2 /\ ned_status b=Int.repr 2
 | 2%nat=>ecef_status a=Int.one /\ ecef_status b=Int.one
 | 3%nat=>copied_ecef a=(Protocol.E,Int.zero,Int.zero) /\copied_ecef b=(Protocol.E,Int.zero,Int.zero)
 | 4%nat=>stale_ned a=(Int.zero,Int.zero,Int.zero) /\stale_ned b=(Protocol.S,Int.zero,Int.zero)
 | 5%nat=>pointer_flag a=true /\pointer_flag b=true
 | 6%nat=>returned_status a=Int.repr 33 /\returned_status b=Int.repr 33
 | 7%nat=>forall i,0<=i<656->~(280<=i<282 \/328<=i<340)->
 nth_error(before_get a)(Z.to_nat i)=nth_error(after_get a)(Z.to_nat i) /\
 nth_error(before_get b)(Z.to_nat i)=nth_error(after_get b)(Z.to_nat i)
 | 8%nat=>returned_bits a=expected_bits
 | 9%nat=>returned_bits b=expected_bits
 | 10%nat=>returned_bits a=returned_bits b
 | _=>False end.
Definition WitnessObservations(w:WitnessPair)(a b:Observation):Prop:=
 Observes(witness_mna w)(witness_mea w)(witness_mfa w)(witness_sb w)a /\
 Observes(witness_mnb w)(witness_meb w)(witness_mfb w)(witness_sb w)b.
Theorem witness_observers:forall w:WitnessPair,exists a b,
 WitnessObservations w a b /\ (forall k,(1<=k<=7)%nat->harness_assertion k a b).
Proof.
 intros w.
 destruct(actual_protocol_observer _ _ _ _ _ _ _ _ _ _ _ _ _(witness_input_a w)(witness_run_a w))as[ba[aa OA]].
 destruct(actual_protocol_observer _ _ _ _ _ _ _ _ _ _ _ _ _(witness_input_b w)(witness_run_b w))as[bb[ab OB]].
 exists(concrete_observation Int.zero Int.zero Int.zero Protocol.E Int.zero Int.zero ba aa),
 (concrete_observation Protocol.S Int.zero Int.zero Protocol.E Int.zero Int.zero bb ab).
 split;[split;assumption|].
 intros k RANGE;do 8(destruct k;[try(lia);try(solve[cbn[harness_assertion concrete_observation];auto])|]);try lia.
 cbn[harness_assertion concrete_observation];intros i IR OUT;split.
 - eapply observer_frame_byte;[exact(getter_effects _ _ _ _ _ _ _ _ _ _ _ _ _(witness_run_a w))|exact(observed_before _ _ _ _ _ OA)|exact(observed_after _ _ _ _ _ OA)|exact IR|exact OUT].
 - eapply observer_frame_byte;[exact(getter_effects _ _ _ _ _ _ _ _ _ _ _ _ _(witness_run_b w))|exact(observed_before _ _ _ _ _ OB)|exact(observed_after _ _ _ _ _ OB)|exact IR|exact OUT].
Qed.
Print Assumptions actual_observer_layout.
Print Assumptions actual_protocol_observer.
Print Assumptions witness_observers.


Theorem actual_nonblocking_assertion_results:exists w a b,
 WitnessObservations w a b /\
 (forall k,(1<=k<=7)%nat->harness_assertion k a b) /\
 ~harness_assertion 8 a b /\~harness_assertion 9 a b /\~harness_assertion 10 a b.
Proof.
 destruct paired_counterexample as[w[A B]].
 destruct(witness_observers w)as[a[b[[OA OB]GOOD]]].
 pose proof(observed_bits _ _ _ _ _ OA)as BA.
 pose proof(observed_bits _ _ _ _ _ OB)as BB.
 rewrite A in BA;rewrite B in BB;injection BA as BA;injection BB as BB.
 exists w,a,b;split;[split;assumption|];split;[exact GOOD|].
 unfold harness_assertion;split;[rewrite <-BA;unfold expected_bits;intro EQ;vm_compute in EQ;discriminate|].
 split;[rewrite <-BB;unfold expected_bits;intro EQ;vm_compute in EQ;discriminate|].
 rewrite <-BA,<-BB;intro EQ;vm_compute in EQ;discriminate.
Qed.
Definition finite_division(i:int):Prop:=
 Binary.is_finite 24 128(G.decode i)=true /\Binary.is_nan 24 128(G.decode i)=false.
Theorem harness_division_values_finite:forall i,
 i=Int.zero \/i=Protocol.S->finite_division i.
Proof. intros i[EQ|EQ];subst i;vm_compute;split;reflexivity. Qed.
Theorem harness_denominator_valid:
 Binary.is_finite 24 128(Float32.of_int(Int.repr 524288))=true /\
 Binary.is_nan 24 128(Float32.of_int(Int.repr 524288))=false /\
 Float32.cmp Ceq(Float32.of_int(Int.repr 524288))Float32.zero=false.
Proof. vm_compute;repeat split;reflexivity. Qed.
Print Assumptions actual_nonblocking_assertion_results.
Print Assumptions harness_division_values_finite.


Lemma float_bytes_defined:forall x y z,Forall is_byte(G.float_bytes x y z).
Proof.
 intros;unfold G.float_bytes;repeat rewrite Forall_app;repeat split;unfold encode_val;apply inj_bytes_defined.
Qed.
Lemma getter_result_defined:forall m mf sb x y z,
 G.GetterResult m mf sb x y z->defined_range m sb 0 656->defined_range mf sb 0 656.
Proof.
 intros m mf sb x y z RESULT OLD i R.
 assert(STATUS:defined_range mf sb 280 282).
 { eapply defined_range_from_int16;exact(G.result_status _ _ _ _ _ _ RESULT). }
 assert(FLOATS:defined_range mf sb 328 340).
 { exact(loadbytes_defined mf sb 328 12(G.float_bytes x y z)(G.result_bytes _ _ _ _ _ _ RESULT)(float_bytes_defined x y z)). }
 assert(CASES:(280<=i<282) \/(328<=i<340) \/~(280<=i<282 \/328<=i<340))by lia.
 destruct CASES as[CASE|[CASE|OUT]];[apply STATUS;exact CASE|apply FLOATS;exact CASE|].
 destruct(OLD i R)as[octet BYTE];exists octet.
 rewrite(G.result_frame _ _ _ _ _ _ RESULT sb i 1)by(intros;unfold G.write_byte in *;intuition lia);exact BYTE.
Qed.
Lemma protocol_result_defined:forall m mn me mf sb ns es nx ny nz ex ey ez,
 ProtocolInput m sb ns es nx ny nz ex ey ez->
 ProtocolRun m mn me mf sb ns es nx ny nz ex ey ez->
 defined_range m sb 0 656->defined_range me sb 0 656 /\defined_range mf sb 0 656.
Proof.
 intros m mn me mf sb ns es nx ny nz ex ey ez INPUT RUN OLD.
 assert(VALID:Mem.valid_block m sb).
 { eapply Mem.perm_valid_block;apply(input_state_writable _ _ _ _ _ _ _ _ _ _ INPUT 0);lia. }
 assert(NDEF:defined_range mn sb 0 656).
 { eapply StateSpeedSetNedISupport.Harness.setter_result_defined;[exact(ned_effects _ _ _ _ _ _ _ _ _ _ _ _ _ RUN)|exact VALID|exact OLD]. }
 pose proof(ecef_input_after_ned _ _ _ _ _ _ _ _ _ _ _ INPUT(ned_effects _ _ _ _ _ _ _ _ _ _ _ _ _ RUN))as EIIN.
 assert(NVALID:Mem.valid_block mn sb).
 { eapply Mem.perm_valid_block;apply(EI.state_writable _ _ _ _ _ _ _ EIIN 0);lia. }
 assert(EDEF:defined_range me sb 0 656).
 { eapply StateSpeedSetEcefISupport.Harness.setter_result_defined;[exact(ecef_effects _ _ _ _ _ _ _ _ _ _ _ _ _ RUN)|exact NVALID|exact NDEF]. }
 split;[exact EDEF|eapply getter_result_defined;[exact(getter_effects _ _ _ _ _ _ _ _ _ _ _ _ _ RUN)|exact EDEF]].
Qed.
Definition frame_c_comparison(me mf:mem)(sb:block):Prop:=
 forall i,0<=i<656->~(280<=i<282 \/328<=i<340)->
 exists v,Mem.load Mint8unsigned me sb i=Some(Vint v) /\Mem.load Mint8unsigned mf sb i=Some(Vint v) /\
 Cop.sem_binary_operation G.ge Oeq(Vint v)tuchar(Vint v)tuchar mf=Some(Vint Int.one).
Lemma getter_frame_c_comparison:forall m mf sb x y z,
 G.GetterResult m mf sb x y z->defined_range m sb 0 656->frame_c_comparison m mf sb.
Proof.
 intros m mf sb x y z RESULT DEF i R OUT.
 destruct(defined_range_loadint _ _ _ _ _ DEF R)as[v LOAD].
 exists v;split;[exact LOAD|];split.
 - eapply SourceComparison.load_transfer;[exact LOAD|].
   rewrite(G.result_frame _ _ _ _ _ _ RESULT sb i(size_chunk Mint8unsigned))by(intros;unfold G.write_byte in *;cbn[size_chunk]in *;intuition lia).
   reflexivity.
 - change(Some(Val.of_bool(Int.eq v v))=Some(Vint Int.one));rewrite Int.eq_true;reflexivity.
Qed.
Definition TypedFrameComparisons(w:WitnessPair):Prop:=
 frame_c_comparison(witness_mea w)(witness_mfa w)(witness_sb w) /\
 frame_c_comparison(witness_meb w)(witness_mfb w)(witness_sb w).
Theorem initialized_witness_typed_frame:forall w:WitnessPair,
 Forall is_byte(witness_initial_bytes w)->TypedFrameComparisons w.
Proof.
 intros w DEFINED.
 assert(DA:defined_range(witness_ma w)(witness_sb w)0 656).
 { exact(loadbytes_defined _ _ 0 656 _ (witness_initial_a w)DEFINED). }
 assert(DB:defined_range(witness_mb w)(witness_sb w)0 656).
 { exact(loadbytes_defined _ _ 0 656 _ (witness_initial_b w)DEFINED). }
 destruct(protocol_result_defined _ _ _ _ _ _ _ _ _ _ _ _ _(witness_input_a w)(witness_run_a w)DA)as[EA FA].
 destruct(protocol_result_defined _ _ _ _ _ _ _ _ _ _ _ _ _(witness_input_b w)(witness_run_b w)DB)as[EB FB].
 split;[eapply getter_frame_c_comparison;[exact(getter_effects _ _ _ _ _ _ _ _ _ _ _ _ _(witness_run_a w))|exact EA]|
 eapply getter_frame_c_comparison;[exact(getter_effects _ _ _ _ _ _ _ _ _ _ _ _ _(witness_run_b w))|exact EB]].
Qed.
Lemma initial_contents_defined:Forall is_byte InitialMemory.initial_state_contents.
Proof.
 unfold InitialMemory.initial_state_contents;rewrite!Forall_app;repeat split;try(apply Forall_repeat;exists Byte.zero;reflexivity).
 repeat constructor;unfold is_byte;eauto.
Qed.
Print Assumptions initialized_witness_typed_frame.
