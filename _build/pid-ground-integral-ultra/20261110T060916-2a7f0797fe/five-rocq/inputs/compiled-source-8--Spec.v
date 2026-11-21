From Stdlib Require Import List ZArith Bool.
From compcert Require Import AST Integers Values Memory Events Globalenvs Ctypes Csem Smallstep.
From PidPositionRunPos Require Import Source Execution.
From PidPositionTranslationSupport Require Import MemoryLayout.
From PidPositionTranslationProblem Require Import Spec.
Import ListNotations.
Open Scope Z_scope.
Module S:=PidPositionRunPos.Source.
Module E:=PidPositionRunPos.Execution.
(** Exactly the two old int32 words, little-endian CompCert memval bytes. *)
Definition integral_byte (b:block)(ofs:Z):Prop :=
 Genv.find_symbol E.ge S._guidance_pid_trim_att_integrator=Some b /\ 0<=ofs<8.
Definition same_except_integrals_and_return (ret:block)(a b:mem):Prop :=
 Mem.nextblock a=Mem.nextblock b /\
 (forall blk ofs k p,Mem.perm a blk ofs k p <->Mem.perm b blk ofs k p) /\
 (forall blk ofs,~integral_byte blk ofs ->blk<>ret ->Mem.loadbytes a blk ofs 1=Mem.loadbytes b blk ofs 1).
Definition GroundBasePair (gh ret:block)(a b:mem):Prop :=
 InputGood a gh ret /\InputGood b gh ret /\same_except_integrals_and_return ret a b.
Definition old_integrals (m:mem)(ix iy:int):Prop :=
 load_global Mint32 m S._guidance_pid_trim_att_integrator vec_type[S._x]=Some(Vint ix) /\
 load_global Mint32 m S._guidance_pid_trim_att_integrator vec_type[S._y]=Some(Vint iy).
(** Four independently universally quantified symbolic initial words; no equality or zero premise. *)
Definition GroundInputPair (gh ret:block)(a b:mem)(iax iay ibx iby:int):Prop :=
 GroundBasePair gh ret a b /\old_integrals a iax iay /\old_integrals b ibx iby.
Definition IntegralZero(m:mem):Prop :=old_integrals m Int.zero Int.zero.
Definition same_outside_return(ret:block)(a b:mem):Prop :=
 Mem.nextblock a=Mem.nextblock b /\
 (forall blk ofs k p,Mem.perm a blk ofs k p <->Mem.perm b blk ofs k p) /\
 (forall blk ofs,blk<>ret ->Mem.loadbytes a blk ofs 1=Mem.loadbytes b blk ofs 1).
Definition GroundFinal(ret:block)(a b:mem):Prop :=
 ControllerEqual a b /\ActiveReturnEqual ret a b /\IntegralZero a /\IntegralZero b.
Definition GroundIndependenceGoal:Prop :=
 forall gh ret a b iax iay ibx iby,GroundInputPair gh ret a b iax iay ibx iby ->
 (exists af bf,NormalCall gh ret false a af /\NormalCall gh ret false b bf) /\
 (forall af bf,NormalCall gh ret false a af ->NormalCall gh ret false b bf ->GroundFinal ret af bf).
Definition GroundFrameGoal:Prop :=
 forall gh ret a b iax iay ibx iby af bf,GroundInputPair gh ret a b iax iay ibx iby ->
 NormalCall gh ret false a af ->NormalCall gh ret false b bf ->same_outside_return ret af bf.
Definition GroundNoErrorGoal:Prop :=
 forall gh ret m,InputGood m gh ret ->forall t s,
 star Csem.step E.ge(E.entry(call_args gh ret false)m)t s ->~E.source_error s.
Definition GroundTerminationGoal:Prop :=
 forall gh ret m,InputGood m gh ret ->
 Acc(fun dst src=>exists t,Csem.step E.ge src t dst)(E.entry(call_args gh ret false)m).
Definition GroundNonvacuityGoal:Prop :=
 exists gh ret a b iax iay ibx iby,GroundInputPair gh ret a b iax iay ibx iby /\iax<>ibx /\
 exists af bf,NormalCall gh ret false a af /\NormalCall gh ret false b bf /\GroundFinal ret af bf /\same_outside_return ret af bf.
