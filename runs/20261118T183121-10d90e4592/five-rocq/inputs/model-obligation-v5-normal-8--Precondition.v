From Stdlib Require Import List.
From compcert Require Import Integers Values Memory.
From PprzTrigRelation Require Import Spec.
Import ListNotations.
(** Chosen verification protocol; the exported execution model remains unrestricted. *)
Definition precondition(args:list val)(m:mem):Prop := args=[] /\ Spec.initial_low m.
