From Stdlib Require Import List String ZArith Bool Lia.
From compcert Require Import Coqlib Integers Values AST Memory Events Globalenvs Builtins Determinism.
Import ListNotations.
Local Open Scope Z_scope.

(** Concrete environment for the libc memcpy called by the ORIGINAL source.
    It copies memory cells, including undefined cells and pointer fragments,
    without decoding floats. No alignment requirement beyond byte access.
    Nonempty overlapping regions are undefined; failure has no library step.
    Other named external functions and inline assembly are absent from this
    environment. This is a target definition, not an oracle correctness axiom. *)
Definition disjoint (bdst:block) (od:Z) (bsrc:block) (os sz:Z) : Prop :=
  bdst <> bsrc \/ os + sz <= od \/ od + sz <= os.
Definition disjointb (bdst:block) (od:Z) (bsrc:block) (os sz:Z) : bool :=
  negb (Pos.eqb bdst bsrc) || Z.leb (os+sz) od || Z.leb (od+sz) os.
Lemma disjointb_spec : forall bd od bs os sz,
  disjointb bd od bs os sz = true <-> disjoint bd od bs os sz.
Proof.
 intros; unfold disjointb, disjoint.
 rewrite !orb_true_iff, negb_true_iff, Pos.eqb_neq, !Z.leb_le; tauto.
Qed.

Inductive memcpy_sem : list val -> mem -> trace -> val -> mem -> Prop :=
| memcpy_intro : forall bd od bs os n m bytes m',
    disjoint bd (Ptrofs.unsigned od) bs (Ptrofs.unsigned os) (Int64.unsigned n) ->
    Mem.loadbytes m bs (Ptrofs.unsigned os) (Int64.unsigned n) = Some bytes ->
    Mem.storebytes m bd (Ptrofs.unsigned od) bytes = Some m' ->
    memcpy_sem [Vptr bd od; Vptr bs os; Vlong n] m E0 (Vptr bd od) m'.

Definition legacy_do_external_function (id:string) (_:signature) (_:Senv.t)
  (w:world) (args:list val) (m:mem) : option (world * trace * val * mem) :=
  if String.eqb id "memcpy" then
    match args with
    | [Vptr bd od; Vptr bs os; Vlong n] =>
      if disjointb bd (Ptrofs.unsigned od) bs (Ptrofs.unsigned os) (Int64.unsigned n) then
        match Mem.loadbytes m bs (Ptrofs.unsigned os) (Int64.unsigned n) with
        | Some bytes =>
          match Mem.storebytes m bd (Ptrofs.unsigned od) bytes with
          | Some m' => Some (w,E0,Vptr bd od,m')
          | None => None
          end
        | None => None
        end
      else None
    | _ => None
    end
  else None.
From compcert Require Import Cexec Decidableplus.

Definition memcpy_signature := mksignature [Xptr;Xptr;Xlong] Xptr cc_default.

(* The official builtin is a void two-pointer operation. The C library call
   has three arguments and returns dst. This adapter retains those differences
   and the original source's non-overlap requirement without changing its AST. *)
Inductive official_memcpy (ge:Senv.t):list val->mem->trace->val->mem->Prop :=
| official_memcpy_intro : forall bd od bs os n m t m',
 disjoint bd(Ptrofs.unsigned od)bs(Ptrofs.unsigned os)(Int64.unsigned n) ->
 Events.extcall_memcpy_sem(Int64.unsigned n)1 ge[Vptr bd od;Vptr bs os]m t Vundef m' ->
 official_memcpy ge[Vptr bd od;Vptr bs os;Vlong n]m t(Vptr bd od)m'.

Lemma official_args_ok : forall bd od bs os n,
 disjoint bd(Ptrofs.unsigned od)bs(Ptrofs.unsigned os)(Int64.unsigned n) ->
 Cexec.memcpy_args_ok(Int64.unsigned n)1 bd(Ptrofs.unsigned od)bs(Ptrofs.unsigned os).
Proof.
 intros bd od bs os n DIS;unfold Cexec.memcpy_args_ok.
 split;[left;reflexivity|]. split;[pose proof(Int64.unsigned_range n);lia|].
 repeat split;try apply Z.divide_1_l;try(intros;apply Z.divide_1_l).
 destruct DIS as[NE|[LE|LE]];[left;congruence|right;right;left;exact LE|right;right;right;exact LE].
Qed.

Theorem memcpy_spec_is_official : forall ge args m t v m',
 memcpy_sem args m t v m' <-> official_memcpy ge args m t v m'.
Proof.
 intros;split;intro C.
 - inversion C;subst;econstructor;[exact H|].
   econstructor;try exact H0;try exact H1;try apply Z.divide_1_l;
    try(intros;apply Z.divide_1_l);try(left;reflexivity).
   + pose proof(Int64.unsigned_range n);lia.
   + destruct H as[NE|[LE|LE]];[left;congruence|right;right;left;exact LE|right;right;right;exact LE].
 - inversion C;subst;match goal with H:Events.extcall_memcpy_sem _ _ _ _ _ _ _ _|-_=>inversion H;subst end.
   econstructor;eauto.
Qed.

(* Fixed concrete C-library specification. Invalid signatures have no call;
   this is an external-environment contract, not a replacement of Csem. *)
Definition external_functions_sem(id:string)(sg:signature)(ge:Senv.t)
 (args:list val)(m:mem)(t:trace)(v:val)(m':mem):Prop :=
 id="memcpy"%string /\ sg=memcpy_signature /\ official_memcpy ge args m t v m'.
Definition external_call := Events.external_call.
Definition builtin_or_external_sem := Events.builtin_or_external_sem.

Class environment : Prop := {
 external_model : forall id sg ge args m t v m',
  Events.external_functions_sem id sg ge args m t v m' <-> external_functions_sem id sg ge args m t v m';
 inline_model : forall txt sg ge args m t v m',
  ~Events.inline_assembly_sem txt sg ge args m t v m'
}.

Definition do_external_function(id:string)(sg:signature)(ge:Senv.t)
 (w:world)(args:list val)(m:mem):option(world*trace*val*mem) :=
 if String.eqb id "memcpy" then
 if signature_eq sg memcpy_signature then
 match args with
 |[Vptr bd od;Vptr bs os;Vlong n]=>
  if disjointb bd(Ptrofs.unsigned od)bs(Ptrofs.unsigned os)(Int64.unsigned n)then
   match Cexec.do_ef_memcpy(Int64.unsigned n)1 w[Vptr bd od;Vptr bs os]m with
   |Some(w',t,_,m')=>Some(w',t,Vptr bd od,m')|None=>None end
  else None
 |_=>None end
 else None else None.
Definition do_inline_assembly(_:string)(_:signature)(_:Senv.t)
 (_:world)(_:list val)(_:mem):option(world*trace*val*mem):=None.

Lemma official_copy_unfold : forall bd od bs os n w m,
 disjoint bd(Ptrofs.unsigned od)bs(Ptrofs.unsigned os)(Int64.unsigned n) ->
 Cexec.do_ef_memcpy(Int64.unsigned n)1 w[Vptr bd od;Vptr bs os]m=
 match Mem.loadbytes m bs(Ptrofs.unsigned os)(Int64.unsigned n)with
 |Some bytes=>match Mem.storebytes m bd(Ptrofs.unsigned od)bytes with
   |Some m'=>Some(w,E0,Vundef,m')|None=>None end
 |None=>None end.
Proof.
 intros;unfold Cexec.do_ef_memcpy.
 assert(D:decide(Cexec.memcpy_args_ok(Int64.unsigned n)1 bd(Ptrofs.unsigned od)bs(Ptrofs.unsigned os))=true).
 { apply Decidable_complete;apply official_args_ok;exact H. }
 rewrite D;reflexivity.
Qed.

Theorem callback_preserves_legacy : forall id sg ge w args m,
 sg=memcpy_signature ->
 do_external_function id sg ge w args m=legacy_do_external_function id sg ge w args m.
Proof.
 intros;subst sg;unfold do_external_function,legacy_do_external_function.
 destruct(String.eqb id "memcpy");[|reflexivity].
 destruct(signature_eq memcpy_signature memcpy_signature);[|contradiction].
 destruct args as[|a[|b[|n[|extra tl]]]];try reflexivity.
 destruct a;try reflexivity;destruct b;try reflexivity;destruct n;try reflexivity.
 destruct(disjointb _ _ _ _ _)eqn:D;[|reflexivity].
 rewrite official_copy_unfold by(apply disjointb_spec;exact D).
 destruct(Mem.loadbytes _ _ _ _);[destruct(Mem.storebytes _ _ _ _)|];reflexivity.
Qed.

Lemma do_external_spec_sound : forall id sg ge args m t v m' w w',
 do_external_function id sg ge w args m=Some(w',t,v,m') ->
 external_functions_sem id sg ge args m t v m' /\ possible_trace w t w'.
Proof.
 intros id sg ge args m t v m' w w' RUN.
 assert(SG:sg=memcpy_signature).
 { unfold do_external_function in RUN.
   destruct(String.eqb id "memcpy");try discriminate.
   destruct(signature_eq sg memcpy_signature);auto;discriminate. }
 rewrite(callback_preserves_legacy _ _ _ _ _ _ SG)in RUN.
 unfold legacy_do_external_function in RUN.
 destruct(String.eqb id "memcpy")eqn:NAME;try discriminate.
 apply String.eqb_eq in NAME;subst id sg.
 destruct args as[|a args];[discriminate|].
 destruct a;cbn in RUN;try discriminate.
 destruct args as[|srcval args];[discriminate|].
 destruct srcval;cbn in RUN;try discriminate.
 destruct args as[|sizeval args];[discriminate|].
 destruct sizeval;cbn in RUN;try discriminate.
 destruct args;cbn in RUN;try discriminate.
 destruct(disjointb _ _ _ _ _)eqn:D;try discriminate.
 destruct(Mem.loadbytes _ _ _ _)eqn:LOAD;try discriminate.
 destruct(Mem.storebytes _ _ _ _)eqn:STORE;try discriminate.
 inversion RUN;subst;split;[split;[reflexivity|split;[reflexivity|]]|constructor].
 apply(proj1(memcpy_spec_is_official _ _ _ _ _ _));econstructor;eauto.
 apply disjointb_spec;exact D.
Qed.
Lemma do_external_spec_complete : forall id sg ge args m t v m' w w',
 external_functions_sem id sg ge args m t v m' -> possible_trace w t w' ->
 do_external_function id sg ge w args m=Some(w',t,v,m').
Proof.
 intros id sg ge args m t v m' w w' [NAME[SG CALL]] PT;subst id sg.
 apply(proj2(memcpy_spec_is_official _ _ _ _ _ _))in CALL.
 inversion CALL;subst;inversion PT;subst.
 unfold do_external_function;rewrite String.eqb_refl.
 destruct(signature_eq memcpy_signature memcpy_signature);[|contradiction].
 match goal with DIS:disjoint _ _ _ _ _|-_=>rewrite(proj2(disjointb_spec _ _ _ _ _)DIS)end.
 rewrite official_copy_unfold by assumption.
 match goal with LOAD:Mem.loadbytes _ _ _ _=Some _,STORE:Mem.storebytes _ _ _ _=Some _|-_=>rewrite LOAD,STORE end.
 reflexivity.
Qed.

Section Environment.
Context {Henv:environment}.
Lemma named_external_silent : forall id sg ge args m t v m',
 Events.external_functions_sem id sg ge args m t v m' -> t=E0.
Proof.
 intros;apply external_model in H;destruct H as[_[_ C]].
 apply(proj2(memcpy_spec_is_official _ _ _ _ _ _))in C;inversion C;reflexivity.
Qed.
Lemma do_external_sound : forall id sg ge args m t v m' w w',
 do_external_function id sg ge w args m=Some(w',t,v,m') ->
 Events.external_functions_sem id sg ge args m t v m' /\ possible_trace w t w'.
Proof. intros;destruct(do_external_spec_sound _ _ _ _ _ _ _ _ _ _ H);split;[apply external_model|];assumption. Qed.
Lemma do_external_complete : forall id sg ge args m t v m' w w',
 Events.external_functions_sem id sg ge args m t v m' ->possible_trace w t w' ->
 do_external_function id sg ge w args m=Some(w',t,v,m').
Proof. intros;apply do_external_spec_complete;[apply external_model|];assumption. Qed.
Lemma do_inline_complete : forall id sg ge args m t v m' w w',
 Events.inline_assembly_sem id sg ge args m t v m' ->possible_trace w t w' ->
 do_inline_assembly id sg ge w args m=Some(w',t,v,m').
Proof. intros;exfalso;eapply inline_model;eauto. Qed.
End Environment.
Lemma do_inline_sound : forall id sg ge args m t v m' w w',
 do_inline_assembly id sg ge w args m=Some(w',t,v,m') ->
 Events.inline_assembly_sem id sg ge args m t v m' /\ possible_trace w t w'.
Proof. discriminate. Qed.
Lemma external_call_trace_length : forall ef ge args m t v m',
 external_call ef ge args m t v m' ->(List.length t<=1)%nat.
Proof. intros;eapply Events.external_call_trace_length;eauto. Qed.
Print Assumptions memcpy_spec_is_official.
Print Assumptions callback_preserves_legacy.
