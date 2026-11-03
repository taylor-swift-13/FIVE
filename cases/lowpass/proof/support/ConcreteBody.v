From Stdlib Require Import List ZArith.
From compcert Require Import Coqlib Errors Maps AST Integers Floats Values Memory Ctypes Cop Csyntax Csyntaxdefs Csem Cexec.
From FiveCases.lowpass.model Require Import Source.
From FiveCases.lowpass.model Require Import SourceInvariant.
From FiveCases.lowpass.proof.support Require Import FunctionalModel.
From FiveCases.lowpass.proof.support Require Import NormalCorrespondence.

(** All expressions below are selected from the original generated Csyntax;
    the theorem does not compare two separately handwritten formulas. *)
Definition source_rhs : expr :=
  match fn_body lowpass_function with
  | Ssequence (Sdo (Eassign _ rhs _)) _ => rhs
  | _ => Eval Vundef tfloat
  end.
Definition left (a:expr) : expr :=
  match a with Ebinop _ x _ _ => x | _ => Eval Vundef tfloat end.
Definition right (a:expr) : expr :=
  match a with Ebinop _ _ y _ => y | _ => Eval Vundef tfloat end.
Definition term0 := left (left (left (left source_rhs))).
Definition term1 := right (left (left (left source_rhs))).
Definition term2 := right (left (left source_rhs)).
Definition term3 := right (left source_rhs).
Definition term4 := right source_rhs.
Definition read_b0 := left term0.
Definition read_value := right term0.
Definition read_b1 := left term1.
Definition read_i0 := right term1.
Definition read_i1 := right term2.
Definition read_a0 := left term3.
Definition read_o0 := right term3.
Definition read_a1 := left term4.
Definition read_o1 := right term4.

Lemma original_association : source_rhs =
  Ebinop Osub
    (Ebinop Osub
      (Ebinop Oadd
        (Ebinop Oadd
          (Ebinop Omul read_b0 read_value tfloat)
          (Ebinop Omul read_b1 read_i0 tfloat) tfloat)
        (Ebinop Omul read_b0 read_i1 tfloat) tfloat)
      (Ebinop Omul read_a0 read_o0 tfloat) tfloat)
    (Ebinop Omul read_a1 read_o1 tfloat) tfloat.
Proof. reflexivity. Qed.

Lemma pure_float_mul : forall ge e m x y a b,
  typeof x = tfloat -> typeof y = tfloat ->
  pure_rval ge e m x = Some (Vsingle a) ->
  pure_rval ge e m y = Some (Vsingle b) ->
  pure_rval ge e m (Ebinop Omul x y tfloat) = Some (Vsingle (Float32.mul a b)).
Proof. intros; simpl; rewrite H,H0,H1,H2; reflexivity. Qed.
Lemma pure_float_add : forall ge e m x y a b,
  typeof x = tfloat -> typeof y = tfloat ->
  pure_rval ge e m x = Some (Vsingle a) ->
  pure_rval ge e m y = Some (Vsingle b) ->
  pure_rval ge e m (Ebinop Oadd x y tfloat) = Some (Vsingle (Float32.add a b)).
Proof. intros; simpl; rewrite H,H0,H1,H2; reflexivity. Qed.
Lemma pure_float_sub : forall ge e m x y a b,
  typeof x = tfloat -> typeof y = tfloat ->
  pure_rval ge e m x = Some (Vsingle a) ->
  pure_rval ge e m y = Some (Vsingle b) ->
  pure_rval ge e m (Ebinop Osub x y tfloat) = Some (Vsingle (Float32.sub a b)).
Proof. intros; simpl; rewrite H,H0,H1,H2; reflexivity. Qed.

(** This is a verification representation condition on successful reads, not
    an execution entry restriction.  The complete operational entry still
    accepts every memory, pointer value and float encoding. *)
Record source_reads (e:env) (m:mem) (s:filter_state) (input:int) : Prop := {
  reads_b0 : pure_rval lowpass_ge e m read_b0 = Some (Vsingle (Float32.of_bits (b0 s)));
  reads_value : pure_rval lowpass_ge e m read_value = Some (Vsingle (Float32.of_bits input));
  reads_b1 : pure_rval lowpass_ge e m read_b1 = Some (Vsingle (Float32.of_bits (b1 s)));
  reads_i0 : pure_rval lowpass_ge e m read_i0 = Some (Vsingle (Float32.of_bits (i0 s)));
  reads_i1 : pure_rval lowpass_ge e m read_i1 = Some (Vsingle (Float32.of_bits (i1 s)));
  reads_a0 : pure_rval lowpass_ge e m read_a0 = Some (Vsingle (Float32.of_bits (a0 s)));
  reads_o0 : pure_rval lowpass_ge e m read_o0 = Some (Vsingle (Float32.of_bits (o0 s)));
  reads_a1 : pure_rval lowpass_ge e m read_a1 = Some (Vsingle (Float32.of_bits (a1 s)));
  reads_o1 : pure_rval lowpass_ge e m read_o1 = Some (Vsingle (Float32.of_bits (o1 s)))
}.

Theorem original_rhs_is_exact_filter_recurrence : forall e m s input,
  source_reads e m s input ->
  pure_rval lowpass_ge e m source_rhs =
    Some (Vsingle (Float32.of_bits (calc_out s input))).
Proof.
  intros e m s input R; destruct R.
  rewrite calc_out_exact, original_association. unfold primitive_formula.
  repeat first [apply pure_float_sub | apply pure_float_add | apply pure_float_mul
               | reflexivity | assumption].
Qed.

Print Assumptions original_rhs_is_exact_filter_recurrence.

Lemma read_local_value : forall e m bv input,
  PTree.get Source._value e = Some (bv,tfloat) ->
  Mem.loadv Mfloat32 m (Vptr bv Ptrofs.zero) = Some (Vsingle (Float32.of_bits input)) ->
  pure_rval lowpass_ge e m read_value = Some (Vsingle (Float32.of_bits input)).
Proof.
  intros e m bv input ENV LOAD.
  change (pure_rval lowpass_ge e m (Evalof (Evar Source._value tfloat) tfloat) =
    Some (Vsingle (Float32.of_bits input))).
  cbn [pure_rval pure_lval]. rewrite ENV. cbn [typeof].
  repeat rewrite dec_eq_true. cbn [do_deref_loc access_mode type_is_volatile tfloat].
  rewrite LOAD; reflexivity.
Qed.

Definition filter_members :=
  (Member_plain Source._a (tarray tfloat 2) :: Member_plain Source._b (tarray tfloat 2) ::
   Member_plain Source._i (tarray tfloat 2) :: Member_plain Source._o (tarray tfloat 2) :: nil).

Lemma actual_filter_members : forall (A:Type) (f:members -> A) (default:A),
  (match PTree.get Source._SecondOrderLowPass (genv_cenv lowpass_ge) with
   | Some co => f (co_members co) | None => default end) = f filter_members.
Proof. reflexivity. Qed.

Lemma read_object_b0 : forall e m bp b word,
  PTree.get Source._filter e =
    Some (bp,tptr (Tstruct Source._SecondOrderLowPass noattr)) ->
  Mem.loadv Mptr m (Vptr bp Ptrofs.zero) = Some (Vptr b Ptrofs.zero) ->
  Mem.loadv Mfloat32 m (Vptr b (Ptrofs.repr 8)) =
    Some (Vsingle (Float32.of_bits word)) ->
  pure_rval lowpass_ge e m read_b0 = Some (Vsingle (Float32.of_bits word)).
Proof.
  intros e m bp b word ENV PTR LOAD.
  cbv [read_b0 term0 left source_rhs lowpass_function fn_body Source.f_update_second_order_low_pass].
  cbn [pure_rval pure_lval].
  rewrite ENV. cbn [typeof]. repeat rewrite dec_eq_true.
  cbn [do_deref_loc access_mode type_is_volatile tptr].
  rewrite PTR.
  cbn [do_deref_loc access_mode type_is_volatile tfloat].
  cbn [attr_of_type attr_volatile noattr tptr tarray access_mode do_deref_loc type_is_volatile].
  rewrite (actual_filter_members _ (fun ms =>
    match field_offset lowpass_ge Source._b ms with
    | OK (delta,bf) => Some (b,Ptrofs.add Ptrofs.zero (Ptrofs.repr delta),bf)
    | Error _ => None end) None).
  assert (FO: field_offset lowpass_ge Source._b filter_members = OK (8,Full)) by reflexivity.
  rewrite FO.
  cbn [do_deref_loc access_mode type_is_volatile attr_of_type attr_volatile noattr tptr tarray tfloat
       sem_binary_operation sem_add classify_add typeconv sem_add_ptr_int ptrofs_of_int sizeof].
  assert (PADD: sem_add lowpass_ge (Vptr b (Ptrofs.add Ptrofs.zero (Ptrofs.repr 8)))
    (tarray tfloat 2) (Vint (Int.repr 0)) tint m = Some (Vptr b (Ptrofs.repr 8))) by reflexivity.
  rewrite PADD. cbn [do_deref_loc access_mode type_is_volatile tfloat attr_of_type attr_volatile noattr].
  rewrite LOAD; reflexivity.
Qed.

Lemma read_object_a0 : forall e m bp b word,
  PTree.get Source._filter e = Some (bp,tptr (Tstruct Source._SecondOrderLowPass noattr)) ->
  Mem.loadv Mptr m (Vptr bp Ptrofs.zero) = Some (Vptr b Ptrofs.zero) ->
  Mem.loadv Mfloat32 m (Vptr b (Ptrofs.repr 0)) = Some (Vsingle (Float32.of_bits word)) ->
  pure_rval lowpass_ge e m read_a0 = Some (Vsingle (Float32.of_bits word)).
Proof.
  intros e m bp b word ENV PTR LOAD.
  cbv [read_a0 term0 term1 term2 term3 term4 left right source_rhs lowpass_function fn_body Source.f_update_second_order_low_pass].
  cbn [pure_rval pure_lval]. rewrite ENV. cbn [typeof]. repeat rewrite dec_eq_true.
  cbn [do_deref_loc access_mode type_is_volatile tptr]. rewrite PTR.
  cbn [attr_of_type attr_volatile noattr tptr tarray tfloat access_mode do_deref_loc type_is_volatile].
  rewrite (actual_filter_members _ (fun ms =>
    match field_offset lowpass_ge Source._a ms with
    | OK (delta,bf) => Some (b,Ptrofs.add Ptrofs.zero (Ptrofs.repr delta),bf)
    | Error _ => None end) None).
  assert (FO: field_offset lowpass_ge Source._a filter_members = OK (0,Full)) by reflexivity.
  rewrite FO.
  cbn [do_deref_loc access_mode type_is_volatile attr_of_type attr_volatile noattr tptr tarray tfloat
       sem_binary_operation sem_add classify_add typeconv sem_add_ptr_int ptrofs_of_int sizeof].
  assert (PADD: sem_add lowpass_ge (Vptr b (Ptrofs.add Ptrofs.zero (Ptrofs.repr 0)))
    (tarray tfloat 2) (Vint (Int.repr 0)) tint m = Some (Vptr b (Ptrofs.repr 0))) by reflexivity.
  rewrite PADD. cbn [do_deref_loc access_mode type_is_volatile tfloat attr_of_type attr_volatile noattr].
  rewrite LOAD; reflexivity.
Qed.


Lemma read_object_a1 : forall e m bp b word,
  PTree.get Source._filter e = Some (bp,tptr (Tstruct Source._SecondOrderLowPass noattr)) ->
  Mem.loadv Mptr m (Vptr bp Ptrofs.zero) = Some (Vptr b Ptrofs.zero) ->
  Mem.loadv Mfloat32 m (Vptr b (Ptrofs.repr 4)) = Some (Vsingle (Float32.of_bits word)) ->
  pure_rval lowpass_ge e m read_a1 = Some (Vsingle (Float32.of_bits word)).
Proof.
  intros e m bp b word ENV PTR LOAD.
  cbv [read_a1 term0 term1 term2 term3 term4 left right source_rhs lowpass_function fn_body Source.f_update_second_order_low_pass].
  cbn [pure_rval pure_lval]. rewrite ENV. cbn [typeof]. repeat rewrite dec_eq_true.
  cbn [do_deref_loc access_mode type_is_volatile tptr]. rewrite PTR.
  cbn [attr_of_type attr_volatile noattr tptr tarray tfloat access_mode do_deref_loc type_is_volatile].
  rewrite (actual_filter_members _ (fun ms =>
    match field_offset lowpass_ge Source._a ms with
    | OK (delta,bf) => Some (b,Ptrofs.add Ptrofs.zero (Ptrofs.repr delta),bf)
    | Error _ => None end) None).
  assert (FO: field_offset lowpass_ge Source._a filter_members = OK (0,Full)) by reflexivity.
  rewrite FO.
  cbn [do_deref_loc access_mode type_is_volatile attr_of_type attr_volatile noattr tptr tarray tfloat
       sem_binary_operation sem_add classify_add typeconv sem_add_ptr_int ptrofs_of_int sizeof].
  assert (PADD: sem_add lowpass_ge (Vptr b (Ptrofs.add Ptrofs.zero (Ptrofs.repr 0)))
    (tarray tfloat 2) (Vint (Int.repr 1)) tint m = Some (Vptr b (Ptrofs.repr 4))) by reflexivity.
  rewrite PADD. cbn [do_deref_loc access_mode type_is_volatile tfloat attr_of_type attr_volatile noattr].
  rewrite LOAD; reflexivity.
Qed.


Lemma read_object_b1 : forall e m bp b word,
  PTree.get Source._filter e = Some (bp,tptr (Tstruct Source._SecondOrderLowPass noattr)) ->
  Mem.loadv Mptr m (Vptr bp Ptrofs.zero) = Some (Vptr b Ptrofs.zero) ->
  Mem.loadv Mfloat32 m (Vptr b (Ptrofs.repr 12)) = Some (Vsingle (Float32.of_bits word)) ->
  pure_rval lowpass_ge e m read_b1 = Some (Vsingle (Float32.of_bits word)).
Proof.
  intros e m bp b word ENV PTR LOAD.
  cbv [read_b1 term0 term1 term2 term3 term4 left right source_rhs lowpass_function fn_body Source.f_update_second_order_low_pass].
  cbn [pure_rval pure_lval]. rewrite ENV. cbn [typeof]. repeat rewrite dec_eq_true.
  cbn [do_deref_loc access_mode type_is_volatile tptr]. rewrite PTR.
  cbn [attr_of_type attr_volatile noattr tptr tarray tfloat access_mode do_deref_loc type_is_volatile].
  rewrite (actual_filter_members _ (fun ms =>
    match field_offset lowpass_ge Source._b ms with
    | OK (delta,bf) => Some (b,Ptrofs.add Ptrofs.zero (Ptrofs.repr delta),bf)
    | Error _ => None end) None).
  assert (FO: field_offset lowpass_ge Source._b filter_members = OK (8,Full)) by reflexivity.
  rewrite FO.
  cbn [do_deref_loc access_mode type_is_volatile attr_of_type attr_volatile noattr tptr tarray tfloat
       sem_binary_operation sem_add classify_add typeconv sem_add_ptr_int ptrofs_of_int sizeof].
  assert (PADD: sem_add lowpass_ge (Vptr b (Ptrofs.add Ptrofs.zero (Ptrofs.repr 8)))
    (tarray tfloat 2) (Vint (Int.repr 1)) tint m = Some (Vptr b (Ptrofs.repr 12))) by reflexivity.
  rewrite PADD. cbn [do_deref_loc access_mode type_is_volatile tfloat attr_of_type attr_volatile noattr].
  rewrite LOAD; reflexivity.
Qed.


Lemma read_object_i0 : forall e m bp b word,
  PTree.get Source._filter e = Some (bp,tptr (Tstruct Source._SecondOrderLowPass noattr)) ->
  Mem.loadv Mptr m (Vptr bp Ptrofs.zero) = Some (Vptr b Ptrofs.zero) ->
  Mem.loadv Mfloat32 m (Vptr b (Ptrofs.repr 16)) = Some (Vsingle (Float32.of_bits word)) ->
  pure_rval lowpass_ge e m read_i0 = Some (Vsingle (Float32.of_bits word)).
Proof.
  intros e m bp b word ENV PTR LOAD.
  cbv [read_i0 term0 term1 term2 term3 term4 left right source_rhs lowpass_function fn_body Source.f_update_second_order_low_pass].
  cbn [pure_rval pure_lval]. rewrite ENV. cbn [typeof]. repeat rewrite dec_eq_true.
  cbn [do_deref_loc access_mode type_is_volatile tptr]. rewrite PTR.
  cbn [attr_of_type attr_volatile noattr tptr tarray tfloat access_mode do_deref_loc type_is_volatile].
  rewrite (actual_filter_members _ (fun ms =>
    match field_offset lowpass_ge Source._i ms with
    | OK (delta,bf) => Some (b,Ptrofs.add Ptrofs.zero (Ptrofs.repr delta),bf)
    | Error _ => None end) None).
  assert (FO: field_offset lowpass_ge Source._i filter_members = OK (16,Full)) by reflexivity.
  rewrite FO.
  cbn [do_deref_loc access_mode type_is_volatile attr_of_type attr_volatile noattr tptr tarray tfloat
       sem_binary_operation sem_add classify_add typeconv sem_add_ptr_int ptrofs_of_int sizeof].
  assert (PADD: sem_add lowpass_ge (Vptr b (Ptrofs.add Ptrofs.zero (Ptrofs.repr 16)))
    (tarray tfloat 2) (Vint (Int.repr 0)) tint m = Some (Vptr b (Ptrofs.repr 16))) by reflexivity.
  rewrite PADD. cbn [do_deref_loc access_mode type_is_volatile tfloat attr_of_type attr_volatile noattr].
  rewrite LOAD; reflexivity.
Qed.


Lemma read_object_i1 : forall e m bp b word,
  PTree.get Source._filter e = Some (bp,tptr (Tstruct Source._SecondOrderLowPass noattr)) ->
  Mem.loadv Mptr m (Vptr bp Ptrofs.zero) = Some (Vptr b Ptrofs.zero) ->
  Mem.loadv Mfloat32 m (Vptr b (Ptrofs.repr 20)) = Some (Vsingle (Float32.of_bits word)) ->
  pure_rval lowpass_ge e m read_i1 = Some (Vsingle (Float32.of_bits word)).
Proof.
  intros e m bp b word ENV PTR LOAD.
  cbv [read_i1 term0 term1 term2 term3 term4 left right source_rhs lowpass_function fn_body Source.f_update_second_order_low_pass].
  cbn [pure_rval pure_lval]. rewrite ENV. cbn [typeof]. repeat rewrite dec_eq_true.
  cbn [do_deref_loc access_mode type_is_volatile tptr]. rewrite PTR.
  cbn [attr_of_type attr_volatile noattr tptr tarray tfloat access_mode do_deref_loc type_is_volatile].
  rewrite (actual_filter_members _ (fun ms =>
    match field_offset lowpass_ge Source._i ms with
    | OK (delta,bf) => Some (b,Ptrofs.add Ptrofs.zero (Ptrofs.repr delta),bf)
    | Error _ => None end) None).
  assert (FO: field_offset lowpass_ge Source._i filter_members = OK (16,Full)) by reflexivity.
  rewrite FO.
  cbn [do_deref_loc access_mode type_is_volatile attr_of_type attr_volatile noattr tptr tarray tfloat
       sem_binary_operation sem_add classify_add typeconv sem_add_ptr_int ptrofs_of_int sizeof].
  assert (PADD: sem_add lowpass_ge (Vptr b (Ptrofs.add Ptrofs.zero (Ptrofs.repr 16)))
    (tarray tfloat 2) (Vint (Int.repr 1)) tint m = Some (Vptr b (Ptrofs.repr 20))) by reflexivity.
  rewrite PADD. cbn [do_deref_loc access_mode type_is_volatile tfloat attr_of_type attr_volatile noattr].
  rewrite LOAD; reflexivity.
Qed.


Lemma read_object_o0 : forall e m bp b word,
  PTree.get Source._filter e = Some (bp,tptr (Tstruct Source._SecondOrderLowPass noattr)) ->
  Mem.loadv Mptr m (Vptr bp Ptrofs.zero) = Some (Vptr b Ptrofs.zero) ->
  Mem.loadv Mfloat32 m (Vptr b (Ptrofs.repr 24)) = Some (Vsingle (Float32.of_bits word)) ->
  pure_rval lowpass_ge e m read_o0 = Some (Vsingle (Float32.of_bits word)).
Proof.
  intros e m bp b word ENV PTR LOAD.
  cbv [read_o0 term0 term1 term2 term3 term4 left right source_rhs lowpass_function fn_body Source.f_update_second_order_low_pass].
  cbn [pure_rval pure_lval]. rewrite ENV. cbn [typeof]. repeat rewrite dec_eq_true.
  cbn [do_deref_loc access_mode type_is_volatile tptr]. rewrite PTR.
  cbn [attr_of_type attr_volatile noattr tptr tarray tfloat access_mode do_deref_loc type_is_volatile].
  rewrite (actual_filter_members _ (fun ms =>
    match field_offset lowpass_ge Source._o ms with
    | OK (delta,bf) => Some (b,Ptrofs.add Ptrofs.zero (Ptrofs.repr delta),bf)
    | Error _ => None end) None).
  assert (FO: field_offset lowpass_ge Source._o filter_members = OK (24,Full)) by reflexivity.
  rewrite FO.
  cbn [do_deref_loc access_mode type_is_volatile attr_of_type attr_volatile noattr tptr tarray tfloat
       sem_binary_operation sem_add classify_add typeconv sem_add_ptr_int ptrofs_of_int sizeof].
  assert (PADD: sem_add lowpass_ge (Vptr b (Ptrofs.add Ptrofs.zero (Ptrofs.repr 24)))
    (tarray tfloat 2) (Vint (Int.repr 0)) tint m = Some (Vptr b (Ptrofs.repr 24))) by reflexivity.
  rewrite PADD. cbn [do_deref_loc access_mode type_is_volatile tfloat attr_of_type attr_volatile noattr].
  rewrite LOAD; reflexivity.
Qed.


Lemma read_object_o1 : forall e m bp b word,
  PTree.get Source._filter e = Some (bp,tptr (Tstruct Source._SecondOrderLowPass noattr)) ->
  Mem.loadv Mptr m (Vptr bp Ptrofs.zero) = Some (Vptr b Ptrofs.zero) ->
  Mem.loadv Mfloat32 m (Vptr b (Ptrofs.repr 28)) = Some (Vsingle (Float32.of_bits word)) ->
  pure_rval lowpass_ge e m read_o1 = Some (Vsingle (Float32.of_bits word)).
Proof.
  intros e m bp b word ENV PTR LOAD.
  cbv [read_o1 term0 term1 term2 term3 term4 left right source_rhs lowpass_function fn_body Source.f_update_second_order_low_pass].
  cbn [pure_rval pure_lval]. rewrite ENV. cbn [typeof]. repeat rewrite dec_eq_true.
  cbn [do_deref_loc access_mode type_is_volatile tptr]. rewrite PTR.
  cbn [attr_of_type attr_volatile noattr tptr tarray tfloat access_mode do_deref_loc type_is_volatile].
  rewrite (actual_filter_members _ (fun ms =>
    match field_offset lowpass_ge Source._o ms with
    | OK (delta,bf) => Some (b,Ptrofs.add Ptrofs.zero (Ptrofs.repr delta),bf)
    | Error _ => None end) None).
  assert (FO: field_offset lowpass_ge Source._o filter_members = OK (24,Full)) by reflexivity.
  rewrite FO.
  cbn [do_deref_loc access_mode type_is_volatile attr_of_type attr_volatile noattr tptr tarray tfloat
       sem_binary_operation sem_add classify_add typeconv sem_add_ptr_int ptrofs_of_int sizeof].
  assert (PADD: sem_add lowpass_ge (Vptr b (Ptrofs.add Ptrofs.zero (Ptrofs.repr 24)))
    (tarray tfloat 2) (Vint (Int.repr 1)) tint m = Some (Vptr b (Ptrofs.repr 28))) by reflexivity.
  rewrite PADD. cbn [do_deref_loc access_mode type_is_volatile tfloat attr_of_type attr_volatile noattr].
  rewrite LOAD; reflexivity.
Qed.

Definition read_out := Evalof (Evar Source._out tfloat) tfloat.
Lemma read_local_out : forall e m bo word,
  PTree.get Source._out e = Some (bo,tfloat) ->
  Mem.loadv Mfloat32 m (Vptr bo Ptrofs.zero) = Some (Vsingle (Float32.of_bits word)) ->
  pure_rval lowpass_ge e m read_out = Some (Vsingle (Float32.of_bits word)).
Proof.
  intros e m bo word ENV LOAD.
  unfold read_out; cbn [pure_rval pure_lval]. rewrite ENV; cbn [typeof].
  repeat rewrite dec_eq_true.
  cbn [do_deref_loc access_mode type_is_volatile tfloat].
  rewrite LOAD; reflexivity.
Qed.
Definition object_lvalue (read:expr) := match read with
  | Evalof l _ => l | _ => Eloc 1%positive Ptrofs.zero Full tfloat end.



Lemma lvalue_object_i0 : forall e m bp b,
  PTree.get Source._filter e = Some (bp,tptr (Tstruct Source._SecondOrderLowPass noattr)) ->
  Mem.loadv Mptr m (Vptr bp Ptrofs.zero) = Some (Vptr b Ptrofs.zero) ->
  pure_lval lowpass_ge e m (object_lvalue read_i0) = Some (b,Ptrofs.repr 16,Full).
Proof.
  intros e m bp b ENV PTR.
  cbv [object_lvalue read_i0 term0 term1 term2 term3 term4 left right source_rhs lowpass_function fn_body Source.f_update_second_order_low_pass].
  cbn [pure_rval pure_lval]. rewrite ENV. cbn [typeof]. repeat rewrite dec_eq_true.
  cbn [do_deref_loc access_mode type_is_volatile tptr]. rewrite PTR.
  cbn [attr_of_type attr_volatile noattr tptr tarray tfloat access_mode do_deref_loc type_is_volatile].
  rewrite (actual_filter_members _ (fun ms =>
    match field_offset lowpass_ge Source._i ms with
    | OK (delta,bf) => Some (b,Ptrofs.add Ptrofs.zero (Ptrofs.repr delta),bf)
    | Error _ => None end) None).
  assert (FO: field_offset lowpass_ge Source._i filter_members = OK (16,Full)) by reflexivity.
  rewrite FO.
  cbn [do_deref_loc access_mode type_is_volatile attr_of_type attr_volatile noattr tptr tarray tfloat
       sem_binary_operation sem_add classify_add typeconv sem_add_ptr_int ptrofs_of_int sizeof].
  assert (PADD: sem_add lowpass_ge (Vptr b (Ptrofs.add Ptrofs.zero (Ptrofs.repr 16)))
    (tarray tfloat 2) (Vint (Int.repr 0)) tint m = Some (Vptr b (Ptrofs.repr 16))) by reflexivity.
  rewrite PADD; reflexivity.
Qed.


Lemma lvalue_object_i1 : forall e m bp b,
  PTree.get Source._filter e = Some (bp,tptr (Tstruct Source._SecondOrderLowPass noattr)) ->
  Mem.loadv Mptr m (Vptr bp Ptrofs.zero) = Some (Vptr b Ptrofs.zero) ->
  pure_lval lowpass_ge e m (object_lvalue read_i1) = Some (b,Ptrofs.repr 20,Full).
Proof.
  intros e m bp b ENV PTR.
  cbv [object_lvalue read_i1 term0 term1 term2 term3 term4 left right source_rhs lowpass_function fn_body Source.f_update_second_order_low_pass].
  cbn [pure_rval pure_lval]. rewrite ENV. cbn [typeof]. repeat rewrite dec_eq_true.
  cbn [do_deref_loc access_mode type_is_volatile tptr]. rewrite PTR.
  cbn [attr_of_type attr_volatile noattr tptr tarray tfloat access_mode do_deref_loc type_is_volatile].
  rewrite (actual_filter_members _ (fun ms =>
    match field_offset lowpass_ge Source._i ms with
    | OK (delta,bf) => Some (b,Ptrofs.add Ptrofs.zero (Ptrofs.repr delta),bf)
    | Error _ => None end) None).
  assert (FO: field_offset lowpass_ge Source._i filter_members = OK (16,Full)) by reflexivity.
  rewrite FO.
  cbn [do_deref_loc access_mode type_is_volatile attr_of_type attr_volatile noattr tptr tarray tfloat
       sem_binary_operation sem_add classify_add typeconv sem_add_ptr_int ptrofs_of_int sizeof].
  assert (PADD: sem_add lowpass_ge (Vptr b (Ptrofs.add Ptrofs.zero (Ptrofs.repr 16)))
    (tarray tfloat 2) (Vint (Int.repr 1)) tint m = Some (Vptr b (Ptrofs.repr 20))) by reflexivity.
  rewrite PADD; reflexivity.
Qed.


Lemma lvalue_object_o0 : forall e m bp b,
  PTree.get Source._filter e = Some (bp,tptr (Tstruct Source._SecondOrderLowPass noattr)) ->
  Mem.loadv Mptr m (Vptr bp Ptrofs.zero) = Some (Vptr b Ptrofs.zero) ->
  pure_lval lowpass_ge e m (object_lvalue read_o0) = Some (b,Ptrofs.repr 24,Full).
Proof.
  intros e m bp b ENV PTR.
  cbv [object_lvalue read_o0 term0 term1 term2 term3 term4 left right source_rhs lowpass_function fn_body Source.f_update_second_order_low_pass].
  cbn [pure_rval pure_lval]. rewrite ENV. cbn [typeof]. repeat rewrite dec_eq_true.
  cbn [do_deref_loc access_mode type_is_volatile tptr]. rewrite PTR.
  cbn [attr_of_type attr_volatile noattr tptr tarray tfloat access_mode do_deref_loc type_is_volatile].
  rewrite (actual_filter_members _ (fun ms =>
    match field_offset lowpass_ge Source._o ms with
    | OK (delta,bf) => Some (b,Ptrofs.add Ptrofs.zero (Ptrofs.repr delta),bf)
    | Error _ => None end) None).
  assert (FO: field_offset lowpass_ge Source._o filter_members = OK (24,Full)) by reflexivity.
  rewrite FO.
  cbn [do_deref_loc access_mode type_is_volatile attr_of_type attr_volatile noattr tptr tarray tfloat
       sem_binary_operation sem_add classify_add typeconv sem_add_ptr_int ptrofs_of_int sizeof].
  assert (PADD: sem_add lowpass_ge (Vptr b (Ptrofs.add Ptrofs.zero (Ptrofs.repr 24)))
    (tarray tfloat 2) (Vint (Int.repr 0)) tint m = Some (Vptr b (Ptrofs.repr 24))) by reflexivity.
  rewrite PADD; reflexivity.
Qed.


Lemma lvalue_object_o1 : forall e m bp b,
  PTree.get Source._filter e = Some (bp,tptr (Tstruct Source._SecondOrderLowPass noattr)) ->
  Mem.loadv Mptr m (Vptr bp Ptrofs.zero) = Some (Vptr b Ptrofs.zero) ->
  pure_lval lowpass_ge e m (object_lvalue read_o1) = Some (b,Ptrofs.repr 28,Full).
Proof.
  intros e m bp b ENV PTR.
  cbv [object_lvalue read_o1 term0 term1 term2 term3 term4 left right source_rhs lowpass_function fn_body Source.f_update_second_order_low_pass].
  cbn [pure_rval pure_lval]. rewrite ENV. cbn [typeof]. repeat rewrite dec_eq_true.
  cbn [do_deref_loc access_mode type_is_volatile tptr]. rewrite PTR.
  cbn [attr_of_type attr_volatile noattr tptr tarray tfloat access_mode do_deref_loc type_is_volatile].
  rewrite (actual_filter_members _ (fun ms =>
    match field_offset lowpass_ge Source._o ms with
    | OK (delta,bf) => Some (b,Ptrofs.add Ptrofs.zero (Ptrofs.repr delta),bf)
    | Error _ => None end) None).
  assert (FO: field_offset lowpass_ge Source._o filter_members = OK (24,Full)) by reflexivity.
  rewrite FO.
  cbn [do_deref_loc access_mode type_is_volatile attr_of_type attr_volatile noattr tptr tarray tfloat
       sem_binary_operation sem_add classify_add typeconv sem_add_ptr_int ptrofs_of_int sizeof].
  assert (PADD: sem_add lowpass_ge (Vptr b (Ptrofs.add Ptrofs.zero (Ptrofs.repr 24)))
    (tarray tfloat 2) (Vint (Int.repr 1)) tint m = Some (Vptr b (Ptrofs.repr 28))) by reflexivity.
  rewrite PADD; reflexivity.
Qed.


Lemma lvalue_local_out : forall e m bo,
  PTree.get Source._out e = Some (bo,tfloat) ->
  pure_lval lowpass_ge e m (Evar Source._out tfloat) = Some (bo,Ptrofs.zero,Full).
Proof. intros; cbn [pure_lval]; rewrite H,dec_eq_true; reflexivity. Qed.


