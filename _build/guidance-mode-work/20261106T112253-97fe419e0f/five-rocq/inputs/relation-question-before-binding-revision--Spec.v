From Stdlib Require Import List ZArith.
From compcert Require Import Integers Floats AST Values Memory Globalenvs Ctypes Csyntax Csem Smallstep.
From FivePaparazziState Require Import State.
From FiveGuidanceEntry Require Import Entry.
Require FiveGhSpeed.Source FiveGhSpeed.Execution.
Require FiveGhAccel.Source FiveGhAccel.Execution.
Import ListNotations.
Local Open Scope Z_scope.

Definition vector_bits (v : vector) : list int := [Float32.to_bits (vx v);Float32.to_bits (vy v)].
Definition argument_repr (v : vector) (m : mem) (b : block) (o : ptrofs) : Prop :=
 Mem.load Mfloat32 m b (Ptrofs.unsigned o)=Some(Vsingle(vx v)) /\
 Mem.load Mfloat32 m b (Ptrofs.unsigned o+4)=Some(Vsingle(vy v)) /\
 0 <= Ptrofs.unsigned o /\ Ptrofs.unsigned o+8 <= Ptrofs.max_unsigned /\
 exists bytes, Mem.loadbytes m b (Ptrofs.unsigned o) 8=Some bytes.
Definition Returns (ge : Csem.genv) (entry : list val -> mem -> Csem.state)
 (args : list val) (before : mem) (after : mem) : Prop :=
 exists t v, star Csem.step ge (entry args before) t (Returnstate v Kstop after).
Definition speed_call (m : mem) (b : block) (o : ptrofs) (mf : mem) : Prop :=
 Returns FiveGhSpeed.Execution.ge FiveGhSpeed.Execution.entry [Vptr b o] m mf.
Definition accel_call (m : mem) (b : block) (o : ptrofs) (mf : mem) : Prop :=
 Returns FiveGhAccel.Execution.ge FiveGhAccel.Execution.entry [Vptr b o] m mf.
Definition speed_initial (s : state) (sp : vector) (m : mem) (b bp : block) (o : ptrofs) : Prop :=
 repr s m b /\ writable m b /\ argument_repr sp m bp o /\ integration_safe s /\
 Genv.find_symbol FiveGhSpeed.Execution.ge FiveGhSpeed.Source._gh_ref=Some b /\
 exists bc, Genv.find_symbol FiveGhSpeed.Execution.ge FiveGhSpeed.Source._gh_max_accel=Some bc /\
 Mem.load Mfloat32 m bc 0=Some(Vsingle fixed_maximum).
Definition accel_initial (s : state) (a : vector) (m : mem) (b bp : block) (o : ptrofs) : Prop :=
 repr s m b /\ writable m b /\ argument_repr a m bp o /\ integration_safe s /\
 Genv.find_symbol FiveGhAccel.Execution.ge FiveGhAccel.Source._gh_ref=Some b /\
 exists bc, Genv.find_symbol FiveGhAccel.Execution.ge FiveGhAccel.Source._gh_max_accel=Some bc /\
 Mem.load Mfloat32 m bc 0=Some(Vsingle fixed_maximum).
Definition MatchingCommand (s : state) (sp a : vector) : Prop :=
 exists si, integrate s=Some si /\ vector_bits a=vector_bits(raw_speed_accel si sp).

Definition NormalCompletion : Prop := forall s sp a ma mb ba bb pa pb oa ob,
 speed_initial s sp ma ba pa oa -> accel_initial s a mb bb pb ob -> MatchingCommand s sp a ->
 exists fa fb sf, speed_call ma pa oa fa /\ accel_call mb pb ob fb /\
 speed_update fixed_maximum s sp=Some sf /\ repr sf fa ba /\ repr sf fb bb.
Definition AllFinalStateFormula : Prop := forall s sp a ma mb ba bb pa pb oa ob fa fb,
 speed_initial s sp ma ba pa oa -> accel_initial s a mb bb pb ob -> MatchingCommand s sp a ->
 speed_call ma pa oa fa -> accel_call mb pb ob fb ->
 exists sf, speed_update fixed_maximum s sp=Some sf /\ repr sf fa ba /\ repr sf fb bb.
Definition AllFinalNamedBits : Prop := forall s sp a ma mb ba bb pa pb oa ob fa fb sa sb,
 speed_initial s sp ma ba pa oa -> accel_initial s a mb bb pb ob -> MatchingCommand s sp a ->
 speed_call ma pa oa fa -> accel_call mb pb ob fb -> repr sa fa ba -> repr sb fb bb ->
 named_bits sa=named_bits sb.

(** Actual original-Csem prefix reaches the real saturation call with exactly
    the source-ordered command after both integration updates. *)
Definition SpeedPrelimit (s : state) (sp : vector) (m : mem) (bp : block) (o : ptrofs) : Prop :=
 exists si t k reached local ofs,
 integrate s=Some si /\
 star Csem.step FiveGhSpeed.Execution.ge (FiveGhSpeed.Execution.entry [Vptr bp o]m)t
  (Callstate (Internal FiveGhSpeed.Source.f_gh_saturate_accel) [Vptr local ofs] k reached) /\
 argument_repr (raw_speed_accel si sp) reached local ofs.
Definition ActualPrelimitExists : Prop := forall s sp ma ba pa oa,
 speed_initial s sp ma ba pa oa -> SpeedPrelimit s sp ma pa oa.
Definition BranchWitness (taken : bool) : Prop :=
 exists s sp a ma mb ba bb pa pb oa ob,
 speed_initial s sp ma ba pa oa /\ accel_initial s a mb bb pb ob /\
 MatchingCommand s sp a /\ saturation_branch fixed_maximum a=taken /\
 pos_increment (speed_x s)(dt s)<>Some Int64.zero /\
 Float32.to_bits(Float32.add(speed_x s)(Float32.mul(accel_x s)(dt s)))<>Float32.to_bits(speed_x s).
Definition NontrivialWitnesses : Prop := BranchWitness false /\ BranchWitness true.
