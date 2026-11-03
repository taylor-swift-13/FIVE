From Stdlib Require Import List ZArith.
From compcert Require Import Integers Floats.
Import ListNotations.

(** Auxiliary functional state, separate from the full C execution model.
    Every field ranges over ALL binary32 encodings, including NaN payloads. *)
Record filter_state := mkState {
  a0 : int; a1 : int; b0 : int; b1 : int;
  i0 : int; i1 : int; o0 : int; o1 : int
}.

Definition fp_mul (x y : int) : int :=
  Float32.to_bits (Float32.mul (Float32.of_bits x) (Float32.of_bits y)).
Definition fp_add (x y : int) : int :=
  Float32.to_bits (Float32.add (Float32.of_bits x) (Float32.of_bits y)).
Definition fp_sub (x y : int) : int :=
  Float32.to_bits (Float32.sub (Float32.of_bits x) (Float32.of_bits y)).

(** Exact original association: ((((b0*x)+(b1*i0))+(b0*i1))-(a0*o0))-(a1*o1).
    Each primitive is an IEEE binary32 operation; never a real-number sum. *)
Definition calc_out (s : filter_state) (value : int) : int :=
  fp_sub
    (fp_sub
      (fp_add (fp_add (fp_mul (b0 s) value) (fp_mul (b1 s) (i0 s)))
              (fp_mul (b0 s) (i1 s)))
      (fp_mul (a0 s) (o0 s)))
    (fp_mul (a1 s) (o1 s)).

Definition next (s : filter_state) (value : int) : filter_state :=
  mkState (a0 s) (a1 s) (b0 s) (b1 s)
          value (i0 s) (calc_out s value) (o0 s).

Fixpoint run_values (values : list int) (s : filter_state) : filter_state :=
  match values with
  | [] => s
  | x :: xs => run_values xs (next s x)
  end.

Definition coefficients (s : filter_state) := (a0 s,a1 s,b0 s,b1 s).

Definition primitive_formula (s : filter_state) (value : int) : float32 :=
  Float32.sub
    (Float32.sub
      (Float32.add
        (Float32.add
          (Float32.mul (Float32.of_bits (b0 s)) (Float32.of_bits value))
          (Float32.mul (Float32.of_bits (b1 s)) (Float32.of_bits (i0 s))))
        (Float32.mul (Float32.of_bits (b0 s)) (Float32.of_bits (i1 s))))
      (Float32.mul (Float32.of_bits (a0 s)) (Float32.of_bits (o0 s))))
    (Float32.mul (Float32.of_bits (a1 s)) (Float32.of_bits (o1 s))).

Theorem calc_out_exact : forall s value,
  Float32.of_bits (calc_out s value) = primitive_formula s value.
Proof.
  intros. unfold calc_out,fp_mul,fp_add,fp_sub,primitive_formula.
  repeat rewrite Float32.of_to_bits. reflexivity.
Qed.

Theorem calc_out_bits : forall s value,
  calc_out s value = Float32.to_bits (primitive_formula s value).
Proof.
  intros. rewrite <- calc_out_exact. symmetry. apply Float32.to_of_bits.
Qed.
