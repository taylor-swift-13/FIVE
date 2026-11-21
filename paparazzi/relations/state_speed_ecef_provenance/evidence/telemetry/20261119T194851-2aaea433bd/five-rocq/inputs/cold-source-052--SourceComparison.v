From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib AST Integers Floats Values Memory Memdata Events Globalenvs Csem Smallstep.
From StateSpeedSetterSupport Require Import MemoryFacts.
From StateSpeedMemory Require Import MemoryLayout Protocol.
Require StateSpeedSetNedISupport.Original StateSpeedSetEcefISupport.Original StateSpeedGetterSupport.Original.
Import ListNotations.
Open Scope Z_scope.
Module NO:=StateSpeedSetNedISupport.Original.
Module EO:=StateSpeedSetEcefISupport.Original.
Module GO:=StateSpeedGetterSupport.Original.
Module ML:=StateSpeedMemory.MemoryLayout.
Lemma load_transfer:forall ch m mf b ofs v,
 Mem.load ch m b ofs=Some v->Mem.loadbytes mf b ofs(size_chunk ch)=Mem.loadbytes m b ofs(size_chunk ch)->Mem.load ch mf b ofs=Some v.
Proof.
 intros ch m mf b ofs v LOAD FRAME.
 destruct(Mem.load_loadbytes _ _ _ _ _ LOAD)as[bytes[READ VALUE]];rewrite VALUE;apply Mem.loadbytes_load.
 - rewrite FRAME;exact READ.
 - exact(proj2(Mem.load_valid_access _ _ _ _ _ LOAD)).
Qed.
Lemma ned_symbol:forall sb,Genv.find_symbol G.ge G.S._state=Some sb->Genv.find_symbol N.ge N.S._state=Some sb.
Proof. intros sb SYM;change(Genv.find_symbol ML.NE.ge ML.N._state=Some sb);rewrite(proj1 ML.common_state_symbols);exact SYM. Qed.
Lemma ecef_symbol:forall sb,Genv.find_symbol G.ge G.S._state=Some sb->Genv.find_symbol EI.ge EI.S._state=Some sb.
Proof. intros sb SYM;change(Genv.find_symbol ML.EE.ge ML.E._state=Some sb);rewrite(proj2 ML.common_state_symbols);exact SYM. Qed.
Lemma ned_frame_load:forall m mf sb src x y z ch b ofs v,
 N.SetterResult m mf sb src x y z->Mem.load ch m b ofs=Some v->
 (forall i,ofs<=i<ofs+size_chunk ch->~N.writes sb b i)->Mem.load ch mf b ofs=Some v.
Proof.
 intros m mf sb src x y z ch b ofs v RESULT LOAD MISS;eapply load_transfer;[exact LOAD|].
 eapply(N.result_frame _ _ _ _ _ _ _ RESULT);[eapply loaded_valid;exact LOAD|pose proof(size_chunk_pos ch);lia|exact MISS].
Qed.
Lemma ecef_frame_load:forall m mf sb src x y z ch b ofs v,
 EI.SetterResult m mf sb src x y z->Mem.load ch m b ofs=Some v->
 (forall i,ofs<=i<ofs+size_chunk ch->~EI.writes sb b i)->Mem.load ch mf b ofs=Some v.
Proof.
 intros m mf sb src x y z ch b ofs v RESULT LOAD MISS;eapply load_transfer;[exact LOAD|].
 eapply(EI.result_frame _ _ _ _ _ _ _ RESULT);[eapply loaded_valid;exact LOAD|pose proof(size_chunk_pos ch);lia|exact MISS].
Qed.
Lemma getter_frame_load:forall m mf sb x y z ch b ofs v,
 G.GetterResult m mf sb x y z->Mem.load ch m b ofs=Some v->
 (forall i,ofs<=i<ofs+size_chunk ch->~G.write_byte sb b i)->Mem.load ch mf b ofs=Some v.
Proof.
 intros m mf sb x y z ch b ofs v RESULT LOAD MISS;eapply load_transfer;[exact LOAD|].
 eapply(G.result_frame _ _ _ _ _ _ RESULT);[pose proof(size_chunk_pos ch);lia|exact MISS].
Qed.
Lemma initial_ned_input:forall m sb ns es nx ny nz ex ey ez,
 ProtocolInput m sb ns es nx ny nz ex ey ez->N.InputGood m sb ns accepted_id nx ny nz.
Proof.
 intros m sb ns es nx ny nz ex ey ez P;destruct P as[SYM WR FILTER NS ES NV EV].
 constructor;[apply ned_symbol;exact SYM|exact WR|exact FILTER|exact NS|exact NV].
Qed.
Lemma ecef_input_after_ned:forall m mn sb ns es nx ny nz ex ey ez,
 ProtocolInput m sb ns es nx ny nz ex ey ez->N.SetterResult m mn sb ns nx ny nz->EI.InputGood mn sb es accepted_id ex ey ez.
Proof.
 intros m mn sb ns es nx ny nz ex ey ez P RN;destruct P as[SYM WR FILTER NS ES NV EV].
 assert(SVALID:Mem.valid_block m sb)by(eapply range_valid;[change(0<656);lia|exact WR]).
 constructor.
 - apply ecef_symbol;exact SYM.
 - intros ofs RANGE;apply(proj1(N.result_permissions _ _ _ _ _ _ _ RN sb ofs Cur Writable SVALID));apply WR;exact RANGE.
 - eapply ned_frame_load;[exact RN|exact FILTER|].
   intros i I[EQ W];unfold N.destination_offset in W;cbn[size_chunk]in I;lia.
 - exact ES.
 - destruct EV as[A[B C]];repeat split;eapply ned_frame_load;try exact RN;try eassumption.
   all:intros i I[EQ W];apply ES;exact EQ.
Qed.
Lemma getter_input_after_ecef:forall m mn me sb ns es nx ny nz ex ey ez,
 EI.InputGood mn sb es accepted_id ex ey ez->N.SetterResult m mn sb ns nx ny nz->EI.SetterResult mn me sb es ex ey ez->
 Genv.find_symbol G.ge G.S._state=Some sb->G.InputGood me sb nx ny nz.
Proof.
 intros m mn me sb ns es nx ny nz ex ey ez INPUT RN RE SYM.
 assert(WR:Mem.range_perm mn sb 0 656 Cur Writable)by exact(EI.state_writable _ _ _ _ _ _ _ INPUT).
 assert(SVALID:Mem.valid_block mn sb)by(eapply range_valid;[change(0<656);lia|exact WR]).
 split;[exact SYM|];split.
 - intros ofs RANGE;apply(proj1(EI.result_permissions _ _ _ _ _ _ _ RE sb ofs Cur Writable SVALID));apply WR;exact RANGE.
 - split;[exact(EI.result_status _ _ _ _ _ _ _ RE)|].
   split;[|split];eapply ecef_frame_load;[exact RE|exact(N.result_x _ _ _ _ _ _ _ RN)| |exact RE|exact(N.result_y _ _ _ _ _ _ _ RN)| |exact RE|exact(N.result_z _ _ _ _ _ _ _ RN)|].
   all:intros i I[EQ W];unfold EI.destination_offset in W;cbn[size_chunk]in I;lia.
Qed.
Lemma observed_getter_result:forall m mf sb nx ny nz,
 G.GetterResult m mf sb nx ny nz->observe_bits mf sb=Some(bits_of nx ny nz).
Proof.
 intros m mf sb nx ny nz RESULT;unfold observe_bits,bits_of.
 rewrite(G.result_x _ _ _ _ _ _ RESULT),(G.result_y _ _ _ _ _ _ RESULT),(G.result_z _ _ _ _ _ _ RESULT);reflexivity.
Qed.
Theorem actual_protocol:forall m sb ns es nx ny nz ex ey ez,
 ProtocolInput m sb ns es nx ny nz ex ey ez->exists mn me mf,ProtocolRun m mn me mf sb ns es nx ny nz ex ey ez /\observe_bits mf sb=Some(bits_of nx ny nz).
Proof.
 intros m sb ns es nx ny nz ex ey ez INPUT.
 pose proof(initial_ned_input m sb ns es nx ny nz ex ey ez INPUT)as NINPUT.
 destruct(NO.original_normal_result m sb ns accepted_id nx ny nz NINPUT)as[mn[NORMALN[RN UN]]].
 pose proof(ecef_input_after_ned m mn sb ns es nx ny nz ex ey ez INPUT RN)as EINPUT.
 destruct(EO.original_normal_result mn sb es accepted_id ex ey ez EINPUT)as[me[NORMALE[RE UE]]].
 pose proof(getter_input_after_ecef m mn me sb ns es nx ny nz ex ey ez EINPUT RN RE(input_symbol _ _ _ _ _ _ _ _ _ _ INPUT))as GINPUT.
 destruct(GO.original_normal_result me sb nx ny nz GINPUT)as[mf[NORMALG[RG UG]]].
 exists mn,me,mf;split;[|eapply observed_getter_result;exact RG].
 destruct GINPUT as[GSYM[GWR[GSTATUS[GX[GY GZ]]]]].
 constructor.
 - exact NORMALN.
 - exact NORMALE.
 - exact NORMALG.
 - exact RN.
 - exact RE.
 - exact RG.
 - exact GX.
 - exact GY.
 - exact GZ.
 - eapply getter_frame_load;[exact RG|exact(EI.result_x _ _ _ _ _ _ _ RE)|].
   intros i I[EQ W];cbn[size_chunk]in I;lia.
 - eapply getter_frame_load;[exact RG|exact(EI.result_y _ _ _ _ _ _ _ RE)|].
   intros i I[EQ W];cbn[size_chunk]in I;lia.
 - eapply getter_frame_load;[exact RG|exact(EI.result_z _ _ _ _ _ _ _ RE)|].
   intros i I[EQ W];cbn[size_chunk]in I;lia.
Qed.
Print Assumptions actual_protocol.
