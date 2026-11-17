From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib AST Integers Values Memory Events Globalenvs Ctypes Csem.
From PidPositionRunPos Require Import Source Execution.
From PidPositionTranslationSupport Require Import MemoryLayout TranslationArithmetic.
From PidPositionTranslationProblem Require Import Spec.
From PidPositionTranslationAttempt002 Require Import InputSemantics.
Import ListNotations.
Open Scope Z_scope.
Module S:=PidPositionRunPos.Source.
Module E:=PidPositionRunPos.Execution.
(** Six CBMC pointer-object diagnostics map to the concrete readable span.
    CompCert has block/offset permissions rather than CBMC object metadata. *)
Record readable_span(m:mem)(b:block)(ofs bytes:Z):Prop:={
 span_positive:0<bytes;
 span_live:Mem.valid_block m b;
 span_readable:Mem.range_perm m b ofs(ofs+bytes)Cur Readable;
 span_first_valid:Mem.valid_pointer m b ofs=true;
 span_nonnull32:Vptr b(Ptrofs.repr ofs)<>Vint Int.zero;
 span_nonnull64:Vptr b(Ptrofs.repr ofs)<>Vlong Int64.zero
}.
Lemma range_readable_span:forall m b ofs n,
 0<n ->Mem.range_perm m b ofs(ofs+n)Cur Readable ->readable_span m b ofs n.
Proof.
 intros m b ofs n POS RP;constructor;auto.
 - eapply Mem.perm_valid_block with(ofs:=ofs)(k:=Cur)(p:=Readable);apply RP;lia.
 - apply Mem.valid_pointer_nonempty_perm.
   eapply Mem.perm_implies;[apply RP;lia|constructor].
 - discriminate.
 - discriminate.
Qed.
Lemma loaded_int_span:forall m b ofs i,
 Mem.load Mint32 m b ofs=Some(Vint i) ->readable_span m b ofs 4.
Proof.
 intros m b ofs i L;apply range_readable_span;[lia|].
 exact(proj1(Mem.load_valid_access _ _ _ _ _ L)).
Qed.
Definition entry_pointer_contract(m:mem)(gh:block):Prop:=
 readable_span m gh 44 24 /\
 exists sb rx ry px py sx sy vx vy,
 Genv.find_symbol E.ge S._state=Some sb /\
 Mem.load Mint32 m gh 44=Some(Vint rx) /\
 Mem.load Mint32 m gh 48=Some(Vint ry) /\
 Mem.load Mint32 m gh 52=Some(Vint sx) /\
 Mem.load Mint32 m gh 56=Some(Vint sy) /\
 Mem.load Mint32 m sb 100=Some(Vint px) /\
 Mem.load Mint32 m sb 104=Some(Vint py) /\
 Mem.load Mint32 m sb 296=Some(Vint vx) /\
 Mem.load Mint32 m sb 300=Some(Vint vy) /\
 readable_span m sb 100 4 /\readable_span m sb 104 4 /\
 readable_span m sb 296 4 /\readable_span m sb 300 4.
Theorem original_entry_pointer_contract:forall m gh ret,
 InputGood m gh ret ->entry_pointer_contract m gh.
Proof.
 intros m gh ret GOOD;destruct actual_state_symbol as[sb STATE].
 destruct(inputgood_position_values m gh ret sb GOOD STATE)as[rx[ry[px[py[RX[RY[PX PY]]]]]]].
 destruct(inputgood_speed_values m gh ret sb GOOD STATE)as[sx[sy[vx[vy[SX[SY[VX VY]]]]]]].
 assert(GH:Mem.range_perm m gh 0(sizeof ce gh_type)Cur Readable).
 { destruct GOOD as[G _];unfold InputGoodLegacy in G;tauto. }
 change(Mem.range_perm m gh 0 84 Cur Readable)in GH.
 split.
 - apply range_readable_span;[lia|intros z ZR;apply GH;lia].
 - exists sb,rx,ry,px,py,sx,sy,vx,vy.
   repeat split;try assumption.
   all:try solve[eapply loaded_int_span;eassumption].
Qed.
Definition entry_subtraction_goal(axis:ident)(kind:bool):Prop:=
 forall m gh ret,InputGood m gh ret ->In axis[S._x;S._y] ->
 exists r p,
 (if kind then load_path Mint32 m gh gh_type[S._ref;S._speed;axis]
  else load_path Mint32 m gh gh_type(ref_pos axis))=Some(Vint r) /\
 (if kind then load_global Mint32 m S._state state_type[S._ned_speed_i;axis]
  else load_global Mint32 m S._state state_type(measured_pos axis))=Some(Vint p) /\
 signed32(Int.signed r-Int.signed p).
Theorem original_position_subtraction_safe:forall axis,entry_subtraction_goal axis false.
Proof.
 intros axis m gh ret[_[_ GOOD]]AX;exact(GOOD axis AX).
Qed.
Theorem original_speed_subtraction_safe:forall axis,entry_subtraction_goal axis true.
Proof.
 intros axis m gh ret[G _]AX.
 assert(A:bounded_path m gh gh_type[S._ref;S._speed;axis](-10000)10000 /\
 bounded_global m S._state state_type[S._ned_speed_i;axis](-10000)10000).
 { unfold InputGoodLegacy in G;destruct G as(_&_&_&_&_&_&_&_&_&_&ALL).
   destruct ALL as[_ ALL];destruct(ALL axis AX)as[_[SPEED[_ CACHE]]];auto. }
 destruct A as[[r[LR RR]][p[LP PP]]];exists r,p;repeat split;auto;unfold signed32;lia.
Qed.
Definition entry_overflow_1:entry_subtraction_goal S._x false:=original_position_subtraction_safe S._x.
Definition entry_overflow_2:entry_subtraction_goal S._y false:=original_position_subtraction_safe S._y.
Definition entry_overflow_3:entry_subtraction_goal S._x true:=original_speed_subtraction_safe S._x.
Definition entry_overflow_4:entry_subtraction_goal S._y true:=original_speed_subtraction_safe S._y.
Definition factory_vector_pointer_goal:Prop:=
 forall m src ofs,Mem.range_perm m src(Ptrofs.unsigned ofs)(Ptrofs.unsigned ofs+8)Cur Readable ->
 readable_span m src(Ptrofs.unsigned ofs)8.
Theorem original_factory_vector_span:factory_vector_pointer_goal.
Proof. intros m src ofs RP;apply range_readable_span;[lia|exact RP]. Qed.
(** This is precisely the factory's two-word source copy; no padding is
    required to be initialized. *)
Theorem original_factory_vector_readbytes:forall m src ofs,
 Mem.range_perm m src(Ptrofs.unsigned ofs)(Ptrofs.unsigned ofs+8)Cur Readable ->
 exists bytes,Mem.loadbytes m src(Ptrofs.unsigned ofs)8=Some bytes.
Proof. intros;eapply Mem.range_perm_loadbytes;exact H. Qed.
Print Assumptions original_entry_pointer_contract.
Print Assumptions original_position_subtraction_safe.
Print Assumptions original_speed_subtraction_safe.
Print Assumptions original_factory_vector_span.
