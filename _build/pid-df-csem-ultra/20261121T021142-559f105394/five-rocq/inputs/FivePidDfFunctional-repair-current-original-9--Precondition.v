From Stdlib Require Import List.
From compcert Require Import Values Memory.

(* PENDING: the LLM must supply the actual precondition later.
   This type is an interface, not an assumed or inferred input restriction.
   Retain this declaration and add a Definition precondition of this type.
   List calling-convention, memory, numeric and environment requirements here;
   justify their scope and satisfiability. Do not fill with a dummy True/False. *)
Definition precondition_type : Type := list val -> mem -> Prop.

(* No concrete precondition has been supplied. *)
