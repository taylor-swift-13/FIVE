From Stdlib Require Import ZArith Lia.
From compcert Require Import Integers.
Local Open Scope Z_scope.

(* Mathematical loop counters range over all lengths, not an unroll bound. *)
Definition outer_inv(n finish:Z):Prop := 0<=finish<=n.
Definition inner_inv(finish j:Z):Prop := 0<=j /\ j+1<finish.
Theorem compared_elements_in_bounds : forall n finish j,
 outer_inv n finish -> inner_inv finish j ->
 0<=j<n /\ 0<=j+1<n /\
 0<=4*j /\ 4*j+4<=4*n /\ 0<=4*(j+1) /\ 4*(j+1)+4<=4*n.
Proof. unfold outer_inv,inner_inv;intros;lia. Qed.
Theorem compared_regions_disjoint : forall j,
 4*j+4<=4*(j+1).
Proof. intros;lia. Qed.
Theorem outer_decrement_preserves : forall n finish,
 outer_inv n finish -> finish>1 -> outer_inv n(finish-1).
Proof. unfold outer_inv;intros;lia. Qed.
Theorem inner_increment_cannot_wrap : forall finish j,
 0<=finish<=Int64.max_unsigned -> inner_inv finish j ->
 0<=j+1<=Int64.max_unsigned.
Proof. unfold inner_inv;intros;lia. Qed.
Theorem next_comparison_cannot_wrap : forall finish j,
 0<=finish<=Int64.max_unsigned -> inner_inv finish j -> j+2<=Int64.max_unsigned.
Proof. unfold inner_inv;intros;lia. Qed.
Theorem element_offset_representable : forall n i,
 0<=4*n<=Ptrofs.max_unsigned -> 0<=i<n ->
 Ptrofs.unsigned(Ptrofs.repr(4*i))=4*i.
Proof. intros;apply Ptrofs.unsigned_repr;lia. Qed.
Print Assumptions compared_elements_in_bounds.
Print Assumptions next_comparison_cannot_wrap.
