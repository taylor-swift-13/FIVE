From Stdlib Require Import List ZArith Lia Bool.
From compcert Require Import Coqlib AST Integers Values Memory Globalenvs Ctypes Csyntax Csem Maps.
Require PprzTrigPlain.Source PprzTrigInit.Source.
From PprzTrigRelationSupport Require Import TrigData.
Import ListNotations.
Open Scope Z_scope.

Definition data16 (xs:list Z) := map (fun z=>Init_int16(Int.repr z)) xs.
Definition data8 (xs:list Z) := map (fun z=>Init_int8(Int.repr z)) xs.
Lemma plain_data_reified : gvar_init PprzTrigPlain.Source.v_pprz_trig_int=data16 ordinary_values.
Proof. vm_compute;reflexivity. Qed.
Lemma compressed_data_reified : gvar_init PprzTrigInit.Source.v_pprz_trig_int_compr=data8 compressed_bytes.
Proof. vm_compute;reflexivity. Qed.
Lemma data16_aligned : forall xs p, (2|p) -> Genv.init_data_list_aligned p (data16 xs).
Proof.
 induction xs as [|x xs IH];intros p D;cbn [data16 map Genv.init_data_list_aligned];auto.
 split;[exact D|]. apply IH. cbn [init_data_size]. destruct D as [k E]. exists(k+1);lia.
Qed.
Lemma data8_aligned : forall xs p, Genv.init_data_list_aligned p (data8 xs).
Proof. induction xs as [|x xs IH];intros p;cbn [data8 map Genv.init_data_list_aligned Genv.init_data_alignment init_data_size];auto. split;[exists p;lia|apply IH]. Qed.
Lemma data16_no_addrof : forall xs i o, ~In (Init_addrof i o) (data16 xs).
Proof. intros xs i o H. apply in_map_iff in H as [x [E _]]. discriminate. Qed.
Lemma data8_no_addrof : forall xs i o, ~In (Init_addrof i o) (data8 xs).
Proof. intros xs i o H. apply in_map_iff in H as [x [E _]]. discriminate. Qed.
Definition initializable {V:Type} (v:globvar V) : Prop :=
 Genv.init_data_list_aligned 0 (gvar_init v) /\ forall i o, ~In (Init_addrof i o) (gvar_init v).
Definition global_initializable {F V:Type} (g:ident*globdef F V):Prop :=
 match snd g with Gfun _=>True | Gvar v=>initializable v end.
Lemma plain_var_initializable : initializable PprzTrigPlain.Source.v_pprz_trig_int.
Proof. unfold initializable;rewrite plain_data_reified. split;[apply data16_aligned;exists 0;lia|apply data16_no_addrof]. Qed.
Lemma compressed_var_initializable : initializable PprzTrigInit.Source.v_pprz_trig_int_compr.
Proof. unfold initializable;rewrite compressed_data_reified. split;[apply data8_aligned|apply data8_no_addrof]. Qed.
Lemma buffer_var_initializable : initializable PprzTrigInit.Source.v_data_buf_12.
Proof.
 split;cbn [PprzTrigInit.Source.v_data_buf_12 gvar_init Genv.init_data_list_aligned Genv.init_data_alignment init_data_size].
 - split;[exists 0;lia|exact I].
 - intros i o [E|[]];discriminate.
Qed.
Lemma initializable_program_exists : forall (F V:Type) (p:AST.program F V),
 Forall global_initializable (AST.prog_defs p) -> exists m,Genv.init_mem p=Some m.
Proof.
 intros F V p ALL. apply Genv.init_mem_exists. intros id v IN.
 apply (proj1(Forall_forall _ _)) with (x:=(id,Gvar v)) in ALL;auto.
 destruct ALL as [A N]. split;[exact A|]. intros i o BAD;exfalso;exact(N i o BAD).
Qed.
Lemma plain_init_mem_exists : exists m,Genv.init_mem PprzTrigPlain.Source.prog=Some m.
Proof.
 apply initializable_program_exists.
 change (Forall global_initializable PprzTrigPlain.Source.global_definitions).
 unfold PprzTrigPlain.Source.global_definitions.
 repeat(apply Forall_cons;[first[exact I|exact plain_var_initializable]|]). constructor.
Qed.
Lemma compressed_init_mem_exists : exists m,Genv.init_mem PprzTrigInit.Source.prog=Some m.
Proof.
 apply initializable_program_exists.
 change (Forall global_initializable PprzTrigInit.Source.global_definitions).
 unfold PprzTrigInit.Source.global_definitions.
 repeat(apply Forall_cons;[first[exact I|exact compressed_var_initializable|exact buffer_var_initializable]|]). constructor.
Qed.
Lemma plain_symbol_info_exists : exists b,
 Genv.find_symbol (Csem.globalenv PprzTrigPlain.Source.prog) PprzTrigPlain.Source._pprz_trig_int=Some b /\
 Genv.find_var_info (Csem.globalenv PprzTrigPlain.Source.prog) b=Some PprzTrigPlain.Source.v_pprz_trig_int.
Proof.
 assert (D:(AST.prog_defmap PprzTrigPlain.Source.prog)!PprzTrigPlain.Source._pprz_trig_int=Some(Gvar PprzTrigPlain.Source.v_pprz_trig_int)) by(vm_compute;reflexivity).
 apply Genv.find_def_symbol in D. destruct D as [b [S V]]. exists b;split;[exact S|apply Genv.find_var_info_iff;exact V].
Qed.
Lemma compressed_symbol_info_exists : exists b,
 Genv.find_symbol (Csem.globalenv PprzTrigInit.Source.prog) PprzTrigInit.Source._pprz_trig_int_compr=Some b /\
 Genv.find_var_info (Csem.globalenv PprzTrigInit.Source.prog) b=Some PprzTrigInit.Source.v_pprz_trig_int_compr.
Proof.
 assert (D:(AST.prog_defmap PprzTrigInit.Source.prog)!PprzTrigInit.Source._pprz_trig_int_compr=Some(Gvar PprzTrigInit.Source.v_pprz_trig_int_compr)) by(vm_compute;reflexivity).
 apply Genv.find_def_symbol in D. destruct D as [b [S V]]. exists b;split;[exact S|apply Genv.find_var_info_iff;exact V].
Qed.
Lemma buffer_symbol_info_exists : exists b,
 Genv.find_symbol (Csem.globalenv PprzTrigInit.Source.prog) PprzTrigInit.Source._data_buf_12=Some b /\
 Genv.find_var_info (Csem.globalenv PprzTrigInit.Source.prog) b=Some PprzTrigInit.Source.v_data_buf_12.
Proof.
 assert (D:(AST.prog_defmap PprzTrigInit.Source.prog)!PprzTrigInit.Source._data_buf_12=Some(Gvar PprzTrigInit.Source.v_data_buf_12)) by(vm_compute;reflexivity).
 apply Genv.find_def_symbol in D. destruct D as [b [S V]]. exists b;split;[exact S|apply Genv.find_var_info_iff;exact V].
Qed.
Definition extension_ok (v:Z):bool := Int.eq (Int.sign_ext 16 (Int.zero_ext 16 (Int.repr v))) (Int.repr v).
Lemma literal_extensions : forallb extension_ok ordinary_values=true.
Proof. vm_compute;reflexivity. Qed.
Lemma literal_extensions_Forall : Forall (fun v=>Int.sign_ext 16 (Int.zero_ext 16 (Int.repr v))=Int.repr v) ordinary_values.
Proof.
 apply Forall_forall;intros v IN. pose proof literal_extensions as E.
 apply forallb_forall with(x:=v) in E;auto. unfold extension_ok in E. apply Int.same_if_eq in E;exact E.
Qed.
Lemma data16_load_at : forall (F V:Type) (ge:Genv.t F V) xs m b p,
 Forall (fun v=>Int.sign_ext 16 (Int.zero_ext 16 (Int.repr v))=Int.repr v) xs ->
 Genv.load_store_init_data ge m b p (data16 xs) ->
 forall n,(n<length xs)%nat -> Mem.load Mint16signed m b (p+2*Z.of_nat n)=Some(Vint(Int.repr(nth n xs 0))).
Proof.
 intros F V ge xs;induction xs as[|x xs IH];intros m b p EXT LOAD n N;destruct n;try(simpl in N;lia).
 - inversion EXT as[|? ? EX ES];subst. cbn [data16 map Genv.load_store_init_data] in LOAD.
   destruct LOAD as[L _]. replace(p+2*Z.of_nat 0)with p by lia.
   rewrite Mem.load_int16_signed_unsigned,L. cbn [option_map Val.sign_ext]. rewrite EX;reflexivity.
 - inversion EXT as[|? ? EX ES];subst. cbn [data16 map Genv.load_store_init_data] in LOAD.
   destruct LOAD as[_L LS]. rewrite Nat2Z.inj_succ. replace(p+2*Z.succ(Z.of_nat n))with((p+2)+2*Z.of_nat n)by lia.
   apply IH;auto. simpl in N;lia.
Qed.
Lemma plain_literal_loads : forall m b,
 Genv.init_mem PprzTrigPlain.Source.prog=Some m ->
 Genv.find_var_info (Csem.globalenv PprzTrigPlain.Source.prog) b=Some PprzTrigPlain.Source.v_pprz_trig_int ->
 forall i,0<=i<6434 -> Mem.load Mint16signed m b (2*i)=Some(Vint(Int.repr(nth(Z.to_nat i)ordinary_values 0))).
Proof.
 intros m b INIT VAR i I. pose proof (Genv.init_mem_characterization (Ctypes.program_of_program PprzTrigPlain.Source.prog) b VAR INIT) as[_ [_ [LOAD _]]].
 specialize(LOAD eq_refl). rewrite plain_data_reified in LOAD.
 replace(2*i)with(0+2*Z.of_nat(Z.to_nat i))by(rewrite Z2Nat.id by lia;lia).
 eapply data16_load_at with (xs:=ordinary_values) (ge:=Genv.globalenv (Ctypes.program_of_program PprzTrigPlain.Source.prog)).
 - exact literal_extensions_Forall.
 - exact LOAD.
 -
 rewrite(proj1 original_data_lengths). apply Nat2Z.inj_lt;rewrite Z2Nat.id by lia;cbn;lia.
Qed.
