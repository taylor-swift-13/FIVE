From Stdlib Require Import ZArith Lia.
From compcert Require Import Coqlib AST Integers Values Memory Events Ctypes Cop Csyntax Csyntaxdefs Csem.
From StateSpeedMemory Require Import Protocol SourceComparison.
Open Scope Z_scope.
Lemma same_valid_pointer_c_eq:forall ge m b ofs target,
 Mem.valid_pointer m b(Ptrofs.unsigned ofs)=true->
 sem_binary_operation ge Oeq(Vptr b ofs)(tptr target)(Vptr b ofs)(tptr target)m=Some(Vint Int.one).
Proof.
 intros ge m b ofs target VALID.
 cbn[sem_binary_operation sem_cmp classify_cmp cmp_ptr Val.cmplu_bool Val.cmpu_bool].
 rewrite dec_eq_true.
 change((option_map Val.of_bool(if Mem.weak_valid_pointer m b(Ptrofs.unsigned ofs)&&Mem.weak_valid_pointer m b(Ptrofs.unsigned ofs)then Some(Ptrofs.cmpu Ceq ofs ofs)else None))=Some(Vint Int.one)).
 rewrite(Mem.valid_pointer_implies _ _ _ VALID);cbn[option_map Ptrofs.cmpu];rewrite Ptrofs.eq_true;reflexivity.
Qed.
Lemma state_pointer_valid:forall m sb,
 Mem.range_perm m sb 0 656 Cur Writable->Mem.valid_pointer m sb(Ptrofs.unsigned(Ptrofs.repr 328))=true.
Proof.
 intros m sb WR;rewrite Ptrofs.unsigned_repr by(change(0<=328<=18446744073709551615);lia).
 apply Mem.valid_pointer_nonempty_perm;eapply Mem.perm_implies;[apply WR;lia|constructor].
Qed.
Theorem protocol_pointer_c_comparison:forall m mn me mf sb ns es nx ny nz ex ey ez,
 ProtocolInput m sb ns es nx ny nz ex ey ez->ProtocolRun m mn me mf sb ns es nx ny nz ex ey ez->
 sem_binary_operation G.ge Oeq(Vptr sb(Ptrofs.repr 328))(tptr(Tstruct G.S._EcefCoor_f noattr))
 (Vptr sb(Ptrofs.repr 328))(tptr(Tstruct G.S._EcefCoor_f noattr))mf=Some(Vint Int.one).
Proof.
 intros m mn me mf sb ns es nx ny nz ex ey ez INPUT RUN.
 pose proof(ned_effects _ _ _ _ _ _ _ _ _ _ _ _ _ RUN)as RN.
 pose proof(ecef_effects _ _ _ _ _ _ _ _ _ _ _ _ _ RUN)as RE.
 pose proof(getter_effects _ _ _ _ _ _ _ _ _ _ _ _ _ RUN)as RG.
 pose proof(ecef_input_after_ned _ _ _ _ _ _ _ _ _ _ _ INPUT RN)as EIIN.
 pose proof(getter_input_after_ecef _ _ _ _ _ _ _ _ _ _ _ _ EIIN RN RE(input_symbol _ _ _ _ _ _ _ _ _ _ INPUT))as GIN.
 destruct GIN as[SYM[WR REST]].
 apply same_valid_pointer_c_eq;apply state_pointer_valid;intros i RANGE.
 apply(proj1(G.result_permissions _ _ _ _ _ _ RG sb i Cur Writable));apply WR;exact RANGE.
Qed.
Lemma integer_c_eq:forall ge m a,
 sem_binary_operation ge Oeq(Vint a)tuint(Vint a)tuint m=Some(Vint Int.one).
Proof. intros;change(Some(Val.of_bool(Int.eq a a))=Some(Vint Int.one));rewrite Int.eq_true;reflexivity. Qed.
Print Assumptions protocol_pointer_c_comparison.
Print Assumptions integer_c_eq.
