From Stdlib Require Import List.
From compcert Require Import Integers Values Memory.
From PprzTrigRelation Require Import Spec.
Import ListNotations.
(** Chosen verification protocol; the exported execution model remains unrestricted. *)
Definition precondition(args:list val)(m:mem):Prop := exists a,args=[Vint a] /\ Spec.initial_plain m /\ Spec.normalized_angle a.
