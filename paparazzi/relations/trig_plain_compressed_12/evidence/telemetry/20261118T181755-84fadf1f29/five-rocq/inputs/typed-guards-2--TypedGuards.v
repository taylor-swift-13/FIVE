From Stdlib Require Import ZArith Lia.
From compcert Require Import Coqlib Integers AST Values Memory Events Ctypes Ctypesdefs Csem Cexec Cop.
Local Open Scope Z_scope.

Definition signed32(z:Z):Prop:= -2147483648<=z<=2147483647.
Definition signed16(z:Z):Prop:= -32768<=z<=32767.

Lemma load_signed16_range : forall m b ofs x,
 Mem.load Mint16signed m b ofs=Some(Vint x)->signed16(Int.signed x).
Proof.
 intros m b ofs x LOAD;pose proof(@Mem.load_cast m Mint16signed b ofs(Vint x)LOAD)as CAST.
 change(Vint x=Vint(Int.sign_ext 16 x))in CAST;injection CAST as EQ.
 rewrite EQ;pose proof(Int.sign_ext_range 16 x ltac:(change(0<16<32);lia))as B.
 change(-32768<=Int.signed(Int.sign_ext 16 x)<32768)in B;unfold signed16;lia.
Qed.
Lemma load_unsigned16_range : forall m b ofs x,
 Mem.load Mint16unsigned m b ofs=Some(Vint x)->0<=Int.signed x<=65535.
Proof.
 intros m b ofs x LOAD;pose proof(@Mem.load_cast m Mint16unsigned b ofs(Vint x)LOAD)as CAST.
 change(Vint x=Vint(Int.zero_ext 16 x))in CAST;injection CAST as EQ.
 assert(U:0<=Int.unsigned x<65536).
 { rewrite EQ;exact(Int.zero_ext_range 16 x ltac:(change(0<=16<32);lia)). }
 rewrite Int.signed_eq_unsigned by(change(Int.unsigned x<=2147483647);lia);lia.
Qed.
Lemma load_unsigned8_range : forall m b ofs x,
 Mem.load Mint8unsigned m b ofs=Some(Vint x)->0<=Int.signed x<=255.
Proof.
 intros m b ofs x LOAD;pose proof(@Mem.load_cast m Mint8unsigned b ofs(Vint x)LOAD)as CAST.
 change(Vint x=Vint(Int.zero_ext 8 x))in CAST;injection CAST as EQ.
 assert(U:0<=Int.unsigned x<256).
 { rewrite EQ;exact(Int.zero_ext_range 8 x ltac:(change(0<=8<32);lia)). }
 rewrite Int.signed_eq_unsigned by(change(Int.unsigned x<=2147483647);lia);lia.
Qed.

Lemma typed_dereference_load : forall ge w ty ch m b ofs x,
 access_mode ty=By_value ch ->type_is_volatile ty=false ->
 Cexec.do_deref_loc ge w ty m b ofs Full=Some(w,E0,Vint x) ->
 Mem.load ch m b(Ptrofs.unsigned ofs)=Some(Vint x).
Proof.
 intros ge w ty ch m b ofs x MODE VOL READ.
 unfold Cexec.do_deref_loc in READ;rewrite MODE,VOL in READ;unfold Mem.loadv in READ.
 destruct(zle(Ptrofs.unsigned ofs+size_chunk ch)Ptrofs.modulus);try discriminate.
 destruct(Mem.load ch m b(Ptrofs.unsigned ofs))as[v|]eqn:LOAD;try discriminate.
 inversion READ;subst v;reflexivity.
Qed.

Theorem source_short_dereference_range : forall ge w m b ofs x,
 Cexec.do_deref_loc ge w tshort m b ofs Full=Some(w,E0,Vint x)->signed16(Int.signed x).
Proof. intros;eapply load_signed16_range;eapply typed_dereference_load;[reflexivity|reflexivity|exact H]. Qed.
Theorem source_ushort_dereference_range : forall ge w m b ofs x,
 Cexec.do_deref_loc ge w tushort m b ofs Full=Some(w,E0,Vint x)->0<=Int.signed x<=65535.
Proof. intros;eapply load_unsigned16_range;eapply typed_dereference_load;[reflexivity|reflexivity|exact H]. Qed.
Theorem source_uchar_dereference_range : forall ge w m b ofs x,
 Cexec.do_deref_loc ge w tuchar m b ofs Full=Some(w,E0,Vint x)->0<=Int.signed x<=255.
Proof. intros;eapply load_unsigned8_range;eapply typed_dereference_load;[reflexivity|reflexivity|exact H]. Qed.

Lemma short_increment_guard : forall z,signed16 z->signed32(z+1).
Proof. unfold signed16,signed32;intros;lia. Qed.
Lemma short_add_small_guard : forall z d,signed16 z-> -4<=d<=7 ->signed32(z+d).
Proof. unfold signed16,signed32;intros;lia. Qed.
Lemma short_add_ten_guards : forall z,signed16 z->signed32(z+9)/\signed32(z+9+1).
Proof. unfold signed16,signed32;intros;lia. Qed.
Lemma short_div_five_add_one_guard : forall z,signed16 z->signed32(Z.quot z 5+1).
Proof.
 intros z Z;unfold signed16 in Z;unfold signed32.
 pose proof(Z.quot_le_mono(-32768)z 5 ltac:(lia)ltac:(lia))as L.
 pose proof(Z.quot_le_mono z 32767 5 ltac:(lia)ltac:(lia))as U.
 change(-6553<=Z.quot z 5)in L;change(Z.quot z 5<=6553)in U;lia.
Qed.
Lemma short_half_plus_size_guard : forall z,signed16 z->signed32(6434+Z.quot z 2).
Proof.
 intros z Z;unfold signed16 in Z;unfold signed32.
 pose proof(Z.quot_le_mono(-32768)z 2 ltac:(lia)ltac:(lia))as L.
 pose proof(Z.quot_le_mono z 32767 2 ltac:(lia)ltac:(lia))as U.
 change(-16384<=Z.quot z 2)in L;change(Z.quot z 2<=16383)in U;lia.
Qed.
Lemma signed_remainder_five_bound : forall z,-4<=Z.rem z 5<=4.
Proof. intro z;pose proof(Z.rem_bound_abs z 5 ltac:(lia))as B;cbn[Z.abs]in B;lia. Qed.
Lemma short_add_remainder_five_guard : forall z t,signed16 z->signed32(z+Z.rem t 5).
Proof. intros z t Z;eapply short_add_small_guard;[exact Z|pose proof(signed_remainder_five_bound t);lia]. Qed.
Lemma mask7_bound : forall z,0<=Z.land z 7<=7.
Proof.
 intro z;replace 7 with(Z.ones 3)by reflexivity;rewrite Z.land_ones by lia.
 pose proof(Z.mod_pos_bound z 8 ltac:(lia));change(0<=z mod 8<=7);lia.
Qed.
Lemma mask8_bound : forall z,0<=Z.land z 8<=8.
Proof.
 intro z;replace(Z.land z 8)with(Z.land(Z.land z 15)8)by(rewrite Z.land_assoc;reflexivity).
 replace 15 with(Z.ones 4)by reflexivity;rewrite Z.land_ones by lia.
 pose proof(Z.mod_pos_bound z 16 ltac:(lia))as B;remember(z mod 16)as n;clear Heqn z.
 assert(n=0\/n=1\/n=2\/n=3\/n=4\/n=5\/n=6\/n=7\/n=8\/n=9\/n=10\/n=11\/n=12\/n=13\/n=14\/n=15)by lia.
 repeat match goal with H:_\/_|-_=>destruct H end;subst n;vm_compute;lia.
Qed.
Lemma short_add_mask7_guard : forall z t,signed16 z->signed32(z+Z.land t 7).
Proof. intros z t Z;eapply short_add_small_guard;[exact Z|pose proof(mask7_bound t);lia]. Qed.
Lemma mask8_shift_one_guards : forall z,0<=Z.land z 8 /\signed32(Z.land z 8*2).
Proof. intro z;pose proof(mask8_bound z);unfold signed32;lia. Qed.
Lemma ushort_nibble_shift_guards : forall z,0<=z<=65535 ->
 signed32(4*Z.rem z 2) /\0<=4*Z.rem z 2<32.
Proof. intros z Z;pose proof(Z.rem_bound_pos z 2 ltac:(lia)ltac:(lia));unfold signed32;lia. Qed.
Lemma uchar_decoder_shift_guards : forall z s,0<=z<=255 ->(s=4\/s=8)->
 0<=z /\0<=s<32 /\signed32(z*2^s).
Proof. intros z s Z[->|->];unfold signed32;cbn;nlia. Qed.
