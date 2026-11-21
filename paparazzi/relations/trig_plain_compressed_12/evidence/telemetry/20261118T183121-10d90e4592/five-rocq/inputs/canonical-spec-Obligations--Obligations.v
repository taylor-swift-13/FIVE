From compcert Require Import Values Memory Events Csem Smallstep.

(** Property definitions over the ORIGINAL CompCert C semantics.
    These are propositions to prove, not proofs or an executable replacement. *)
Definition normal_return (s : Csem.state) : Prop :=
  exists v m, s = Returnstate v Kstop m.

Definition source_error (ge : Csem.genv) (s : Csem.state) : Prop :=
  ~ normal_return s /\ nostep Csem.step ge s.

Definition no_error (ge : Csem.genv) (initial : Csem.state) : Prop :=
  forall t s,
    star Csem.step ge initial t s -> ~ source_error ge s.

(** Acc recurses on predecessors of its relation.  Hence the intentional
    argument order: a C successor is a predecessor of [successor].
    Every possible Csem step is covered, including every observable trace.
    There is no fuel bound and no selected evaluation strategy. *)
Definition successor (ge : Csem.genv) (next current : Csem.state) : Prop :=
  exists t, Csem.step ge current t next.

Definition terminates (ge : Csem.genv) (initial : Csem.state) : Prop :=
  Acc (successor ge) initial.

(** Termination alone allows a finite execution ending in an error.
    Safety alone allows divergence.  The conjunction is the requested pair:
    all maximal executions are finite and end in a normal function return.
    No equivalence or program-specific theorem is claimed here. *)
Definition safe_termination (ge : Csem.genv) (initial : Csem.state) : Prop :=
  no_error ge initial /\ terminates ge initial.
