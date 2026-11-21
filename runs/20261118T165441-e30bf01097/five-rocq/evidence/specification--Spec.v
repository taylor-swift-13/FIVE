From Stdlib Require Import List ZArith Sorting.Permutation.
From compcert Require Import AST Integers Values Memory.
From PidPositionTranslationSupport Require Import MemoryLayout.
From PidPositionTranslationProblem Require Import Spec.
From PidAlternatingProblem Require Import Spec.
Import ListNotations.
Open Scope Z_scope.
Module P:=PidPositionRunPos.Source.
Definition limit:Z:=1429*65536.
Definition OrderInitial(m:mem)(gh ret:block):Prop:=
 AlternatingInput m gh ret 0 1 1(Int.repr limit).
Definition ReferenceStore(gh:block)(m:mem)(r:Z)(q:mem):Prop:=
 Mem.store Mint32 m gh 44(Vint(Int.repr r))=Some q.
(** Every sample is installed by a real CompCert store. Calls are the original
 Csem NormalCall and preserve the actual integral from the preceding call. *)
Inductive OrderRun(gh ret:block):list Z->mem->mem->Prop:=
 | order_nil:forall m,OrderRun gh ret [] m m
 | order_cons:forall r rs m q after final ix,
 -4096<=r<=4096 ->
 ReferenceStore gh m r q ->
 AlternatingInput q gh ret r 1 1 ix ->
 NormalCall gh ret true q after ->
 OrderRun gh ret rs after final ->
 OrderRun gh ret(r::rs)m final.
Definition ObservedX(ret:block)(m:mem)(cmd integral:Z):Prop:=
 load_path Mint32 m ret sp_type[P._type]=Some(Vint(Int.repr 2)) /\
 load_path Mint32 m ret sp_type[P._format]=Some(Vint Int.zero) /\
 load_path Mint32 m ret sp_type[P._sp;P._ltp_i;P._vect;P._x]=Some(Vint(Int.repr cmd)) /\
 load_global Mint32 m P._guidance_pid pid_type[P._cmd_earth;P._x]=Some(Vint(Int.repr cmd)) /\
 integral_load m(Int.repr integral).
Definition SameFinalX(ret:block)(a b:mem):Prop:=
 load_path Mint32 a ret sp_type[P._type]=load_path Mint32 b ret sp_type[P._type] /\
 load_path Mint32 a ret sp_type[P._format]=load_path Mint32 b ret sp_type[P._format] /\
 load_path Mint32 a ret sp_type[P._sp;P._ltp_i;P._vect;P._x]=
 load_path Mint32 b ret sp_type[P._sp;P._ltp_i;P._vect;P._x] /\
 load_global Mint32 a P._guidance_pid pid_type[P._cmd_earth;P._x]=
 load_global Mint32 b P._guidance_pid pid_type[P._cmd_earth;P._x] /\
 load_global Mint32 a P._guidance_pid_trim_att_integrator vec_type[P._x]=
 load_global Mint32 b P._guidance_pid_trim_att_integrator vec_type[P._x].
(** Same initial memory, same multiset of reference inputs and the same final
 sample. No reset or altered implementation is hidden in either sequence. *)
Definition OrderInvarianceGoal:Prop:=
 forall gh ret m xs ys af bf,
 OrderInitial m gh ret ->xs<>[] ->ys<>[] ->
 Permutation xs ys ->last xs 0=last ys 0 ->
 OrderRun gh ret xs m af ->OrderRun gh ret ys m bf ->
 SameFinalX ret af bf.
Definition ActualOrderCounterexampleGoal:Prop:=
 exists gh ret m af bf,
 OrderInitial m gh ret /\
 OrderRun gh ret[64;-64;0]m af /\
 OrderRun gh ret[-64;64;0]m bf /\
 ObservedX ret af 1428(limit-1) /\
 ObservedX ret bf 1429 limit /\
 ~SameFinalX ret af bf.
Definition OrderInvarianceRefutedGoal:Prop:=~OrderInvarianceGoal.
