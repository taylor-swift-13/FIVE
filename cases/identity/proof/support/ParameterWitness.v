From Coq Require Import ZArith List Lia.
From compcert Require Import Coqlib Integers Floats Values AST Memory Memdata.
Import ListNotations.
Local Open Scope Z_scope.

(** No logical precondition is required to execute this model. The parameter
    is a machine word, so every binary32 encoding is included. *)
Inductive result : Type :=
| Done (output : float32) (memory : Mem.mem)
| Fault (operation : nat).

Definition execute (input : int) (memory : Mem.mem) : result :=
  let '(allocated, parameter) := Mem.alloc memory 0 4 in
  match Mem.store Mfloat32 allocated parameter 0 (Vsingle (Float32.of_bits input)) with
  | None => Fault 1
  | Some initialized =>
      match Mem.load Mfloat32 initialized parameter 0 with
      | Some (Vsingle output) =>
          match Mem.free initialized parameter 0 4 with
          | Some released => Done output released
          | None => Fault 3
          end
      | _ => Fault 2
      end
  end.

Theorem execution_operations : forall input memory,
  exists allocated parameter initialized released,
    Mem.alloc memory 0 4 = (allocated, parameter) /\
    Mem.store Mfloat32 allocated parameter 0 (Vsingle (Float32.of_bits input)) = Some initialized /\
    Mem.load Mfloat32 initialized parameter 0 = Some (Vsingle (Float32.of_bits input)) /\
    Mem.free initialized parameter 0 4 = Some released /\
    execute input memory = Done (Float32.of_bits input) released.
Proof.
  intros input memory.
  destruct (Mem.alloc memory 0 4) as [allocated parameter] eqn:ALLOC.
  assert (ACCESS : Mem.valid_access allocated Mfloat32 parameter 0 Freeable).
  { eapply Mem.valid_access_alloc_same; eauto; simpl; try lia.
    exists 0; reflexivity. }
  destruct (Mem.valid_access_store allocated Mfloat32 parameter 0
              (Vsingle (Float32.of_bits input))
              (Mem.valid_access_freeable_any _ _ _ _ _ ACCESS))
    as [initialized STORE].
  assert (LOAD : Mem.load Mfloat32 initialized parameter 0 =
                 Some (Vsingle (Float32.of_bits input))).
  { exact (Mem.load_store_same _ _ _ _ _ _ STORE). }
  assert (PERMS : Mem.range_perm initialized parameter 0 4 Cur Freeable).
  { red; intros ofs BOUNDS.
    eapply (Mem.perm_store_1 _ _ _ _ _ _ STORE).
    eapply (Mem.perm_alloc_2 _ _ _ _ _ ALLOC); exact BOUNDS. }
  destruct (Mem.range_perm_free initialized parameter 0 4 PERMS) as [released FREE].
  exists allocated, parameter, initialized, released.
  repeat split; auto.
  unfold execute. rewrite ALLOC, STORE, LOAD, FREE. reflexivity.
Qed.

Theorem local_parameter_bytes : forall input memory,
  exists allocated parameter initialized,
    Mem.alloc memory 0 4 = (allocated, parameter) /\
    Mem.store Mfloat32 allocated parameter 0 (Vsingle (Float32.of_bits input)) = Some initialized /\
    Mem.loadbytes initialized parameter 0 4 =
      Some (encode_val Mfloat32 (Vsingle (Float32.of_bits input))).
Proof.
  intros input memory.
  destruct (execution_operations input memory)
    as [allocated [parameter [initialized [released [A [S [L [F E]]]]]]]].
  exists allocated, parameter, initialized. repeat split; auto.
  change (Mem.loadbytes initialized parameter 0 (size_chunk Mfloat32) =
          Some (encode_val Mfloat32 (Vsingle (Float32.of_bits input)))).
  eapply Mem.loadbytes_store_same; eauto.
Qed.

Lemma allocation_store_free_frame : forall memory allocated parameter initialized released input,
  Mem.alloc memory 0 4 = (allocated, parameter) ->
  Mem.store Mfloat32 allocated parameter 0 (Vsingle input) = Some initialized ->
  Mem.free initialized parameter 0 4 = Some released ->
  Mem.unchanged_on (fun block _ => Mem.valid_block memory block) memory released.
Proof.
  intros memory allocated parameter initialized released input ALLOC STORE FREE.
  assert (FRESH : ~ Mem.valid_block memory parameter).
  { eapply Mem.fresh_block_alloc; eauto. }
  eapply Mem.unchanged_on_trans.
  - eapply Mem.alloc_unchanged_on; eauto.
  - eapply Mem.unchanged_on_trans.
    + eapply Mem.store_unchanged_on; [exact STORE |].
      intros i BOUNDS VALID. exact (FRESH VALID).
    + eapply Mem.free_unchanged_on; [exact FREE |].
      intros i BOUNDS VALID. exact (FRESH VALID).
Qed.

Theorem execution_frame : forall input memory output released,
  execute input memory = Done output released ->
  Mem.unchanged_on (fun block _ => Mem.valid_block memory block) memory released.
Proof.
  intros input memory output released EXEC.
  destruct (execution_operations input memory)
    as [allocated [parameter [initialized [released' [A [S [L [F E]]]]]]]].
  rewrite E in EXEC. inversion EXEC; subst.
  eapply allocation_store_free_frame; eauto.
Qed.

Theorem execution_caller_bytes : forall input memory output released block offset count,
  execute input memory = Done output released ->
  Mem.valid_block memory block ->
  Mem.loadbytes released block offset count = Mem.loadbytes memory block offset count.
Proof.
  intros. eapply Mem.loadbytes_unchanged_on_1.
  - eapply execution_frame; eauto.
  - assumption.
  - auto.
Qed.
