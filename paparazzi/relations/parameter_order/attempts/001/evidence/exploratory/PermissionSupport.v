From Stdlib Require Import Bool List ZArith.
From compcert Require Import Coqlib Errors Maps Integers Floats AST Values Memory Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cexec.
From FiveGhSetOmegaProof Require Import NormalCorrespondence.
Definition preserves_access (m mf : mem) : Prop := forall chunk b ofs p,
 Mem.valid_access m chunk b ofs p -> Mem.valid_access mf chunk b ofs p.
Lemma float_assignment_access : forall ge e m l r ty v mf,
 typeof l=tfloat -> flat_eval ge e m(Eassign l r ty)=Some(v,mf) -> preserves_access m mf.
Proof.
 intros ge e m l r ty v mf TL E.
 unfold flat_eval in E; rewrite TL in E.
 destruct (type_eq tfloat ty) as [TY|TY]; try discriminate; subst ty.
 destruct (pure_lval ge e m l) as [[[b ofs]bf]|] eqn:L; try discriminate.
 destruct (pure_rval ge e m r) as [rv|] eqn:R; try discriminate.
 destruct (sem_cast rv (typeof r) tfloat m) as [cv|] eqn:C; try discriminate.
 destruct (Cexec.do_assign_loc ge quiet_world tfloat m b ofs bf cv) as [[[[w t]mx]vx]|] eqn:D; try discriminate.
 inversion E; subst vx mx.
 unfold Cexec.do_assign_loc in D; destruct bf; cbv [tfloat access_mode type_is_volatile] in D; try discriminate.
 unfold Mem.storev in D; destruct (zle (Ptrofs.unsigned ofs + size_chunk Mfloat32) Ptrofs.modulus); try discriminate.
 destruct (Mem.store Mfloat32 m b (Ptrofs.unsigned ofs) cv) as [ms|] eqn:S; try discriminate.
 inversion D; subst ms.
 intros chunk bx ox p H; eapply Mem.store_valid_access_1; eauto.
Qed.
Fixpoint float_stmts (s:statement) : bool :=
 match s with
 | Sskip | Sreturn _ => true
 | Sdo(Eassign l _ _) => if type_eq (typeof l) tfloat then true else false
 | Ssequence a b => float_stmts a && float_stmts b
 | Sifthenelse _ a b => float_stmts a && float_stmts b
 | _ => false
 end.
Lemma stmt_eval_preserves_access : forall ge e ret s m out mf,
 float_stmts s=true -> stmt_eval ge e ret s m=Some(out,mf) -> preserves_access m mf.
Proof.
 intros ge e ret s; induction s; intros m out mf F E; cbn [float_stmts] in F; try discriminate.
 - cbn [stmt_eval] in E; inversion E; subst; intros ch b ofs p H; exact H.
 - destruct e0; try discriminate.
   destruct (type_eq (typeof e0_1) tfloat) as [TY|TY]; try discriminate.
   cbn [stmt_eval] in E.
   destruct(flat_eval ge e m(Eassign e0_1 e0_2 t))as[[v mx]|]eqn:A;try discriminate.
   inversion E;subst. eapply float_assignment_access;eauto.
 - apply andb_true_iff in F;destruct F as [FA FB].
   cbn [stmt_eval] in E.
   destruct(stmt_eval ge e ret s1 m)as[[o mx]|]eqn:A;try discriminate.
   destruct o.
   + intros ch b ofs p H. eapply IHs2; eauto. eapply IHs1;eauto.
   + inversion E;subst. eapply IHs1;eauto.
 - apply andb_true_iff in F;destruct F as [FA FB].
   cbn [stmt_eval] in E.
   destruct(pure_rval ge e m e0)as[v|]eqn:R;try discriminate.
   destruct(bool_val v(typeof e0)m)as[b|]eqn:B;try discriminate.
   destruct b;[eapply IHs1|eapply IHs2];eauto.
 - destruct o; cbn [stmt_eval] in E.
   + destruct(pure_rval ge e m e0)as[v|]eqn:R;try discriminate.
     destruct(sem_cast v(typeof e0)ret m)as[vr|]eqn:C;try discriminate.
     inversion E;subst;intros ch b ofs p H;exact H.
   + inversion E;subst;intros ch b ofs p H;exact H.
Qed.
Print Assumptions stmt_eval_preserves_access.
