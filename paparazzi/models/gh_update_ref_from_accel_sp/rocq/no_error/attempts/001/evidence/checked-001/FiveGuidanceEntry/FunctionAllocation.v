From Stdlib Require Import List.
From compcert Require Import Coqlib Maps Values Memory Ctypes Csem Cexec.
From FiveGuidanceAllocation Require Import StackAllocation.
Import ListNotations.
Lemma allocation_binding_origin:forall ge vars e m id b ty,
 (fst(Cexec.do_alloc_variables ge e m vars))!id=Some(b,ty)->
 e!id=Some(b,ty) \/In(id,ty)vars.
Proof.
 intros ge vars;induction vars as[|[head ht]vars IH];intros e m id b ty LOOK.
 - left;exact LOOK.
 - cbn[Cexec.do_alloc_variables]in LOOK.
   destruct(Mem.alloc m 0(sizeof ge ht))as[ma fresh]eqn:A.
   destruct(IH _ _ _ _ _ LOOK)as[OLD|IN];[|right;right;exact IN].
   rewrite PTree.gsspec in OLD;destruct(peq id head).
   + subst id;injection OLD as EQ T;subst b ht;right;left;reflexivity.
   + left;exact OLD.
Qed.
Lemma allocated_environment_origin:forall ge vars m e ma,
 Csem.alloc_variables ge empty_env m vars e ma->
 forall id b ty,e!id=Some(b,ty)->In(id,ty)vars.
Proof.
 intros ge vars m e ma ALLOC id b ty LOOK.
 pose proof(Cexec.do_alloc_variables_complete _ _ _ _ _ _ ALLOC)as DONE.
 destruct(allocation_binding_origin ge vars empty_env m id b ty)as[OLD|IN].
 - rewrite DONE;exact LOOK.
 - discriminate OLD.
 - exact IN.
Qed.
Print Assumptions allocated_environment_origin.
Lemma allocation_access:forall ge vars e m ch b ofs p,
 Mem.valid_access m ch b ofs p ->
 Mem.valid_access(snd(Cexec.do_alloc_variables ge e m vars))ch b ofs p.
Proof.
 intros ge vars e m ch b ofs p[PERM ALIGN];split;[|exact ALIGN].
 intros x R;eapply StackAllocation.allocation_perm;apply PERM;exact R.
Qed.
Lemma allocation_load_frame:forall ge vars e m ch b ofs,
 Mem.valid_block m b ->Mem.load ch(snd(Cexec.do_alloc_variables ge e m vars))b ofs=Mem.load ch m b ofs.
Proof.
 intros ge vars;induction vars as[|[id ty]vars IH];intros e m ch b ofs VB;cbn[Cexec.do_alloc_variables];[reflexivity|].
 destruct(Mem.alloc m 0(sizeof ge ty))as[ma fresh]eqn:A.
 rewrite IH by(eapply Mem.valid_block_alloc;eauto).
 eapply Mem.load_alloc_unchanged;eauto.
Qed.
Lemma allocation_bytes_frame:forall ge vars e m b ofs n,
 Mem.valid_block m b ->Mem.loadbytes(snd(Cexec.do_alloc_variables ge e m vars))b ofs n=Mem.loadbytes m b ofs n.
Proof.
 intros ge vars;induction vars as[|[id ty]vars IH];intros e m b ofs n VB;cbn[Cexec.do_alloc_variables];[reflexivity|].
 destruct(Mem.alloc m 0(sizeof ge ty))as[ma fresh]eqn:A.
 rewrite IH by(eapply Mem.valid_block_alloc;eauto).
 eapply Mem.loadbytes_alloc_unchanged;eauto.
Qed.
