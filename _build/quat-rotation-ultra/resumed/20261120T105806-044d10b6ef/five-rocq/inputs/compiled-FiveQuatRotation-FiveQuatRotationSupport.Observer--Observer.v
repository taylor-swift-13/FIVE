From Stdlib Require Import List ZArith.
From compcert Require Import Values Memory Events.
From FiveQuatRotation Require Import Spec.
From FiveQuatRotationSupport Require Import Protocol.
From FiveRmatVmultCase Require Import Memcpy MemcpyLedger.
Local Open Scope Z_scope.
Theorem observer:forall se m a ca b cb left right,
 a<>ca->b<>cb->b<>ca->cb<>ca->
 Mem.loadbytes m a 0 12=Some left->Mem.loadbytes m b 0 12=Some right->WCells m ca 3->WCells m cb 3->
 CopyObservation se m a ca b cb left right.
Proof.
 intros se m a ca b cb left right AC BC BCA CBCA LEFT RIGHT WA WB.
 assert(PA:CopyPre m a ca).
 { constructor;[exact AC|exact(Mem.loadbytes_range_perm m a 0 12 left LEFT)|exact(proj2(proj2(W_writable12 m ca WA)))]. }
 assert(PB:CopyPre m b cb).
 { constructor;[exact BC|exact(Mem.loadbytes_range_perm m b 0 12 right RIGHT)|exact(proj2(proj2(W_writable12 m cb WB)))]. }
 destruct(all_original_18_proved se m a ca b cb PA PB BCA CBCA)as(ma&mb&ba&bb&RA&RB&STA&STB&CA&CB&BA&BB&FA&FB&GUARDS).
 assert(BAEQ:ba=left)by(congruence);subst ba.
 assert(BBEQ:bb=right)by(rewrite(FA b 0 12 ltac:(left;exact BCA))in RB;congruence);subst bb.
 exists ma,mb;repeat split;assumption.
Qed.
Print Assumptions observer.
