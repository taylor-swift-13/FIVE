From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Errors Maps AST Integers Values Memory Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cstrategy Smallstep.
From PidPositionRunPos Require Import Source Execution.
From FiveGuidanceEntry Require Import BigstepSupport.
From PidPositionTranslationSupport Require Import MemoryLayout.
From PidPositionTranslationCore Require Import FactoryMemory FactorySemantics CoreMemory CoreSemantics ClampSemantics CoreClamp.
Import ListNotations.
Open Scope Z_scope.
From PidPositionSafety Require Import PureSound.
From FiveGuidanceAllOrder Require Import PureDenotation.
From PidPositionTranslationCore Require Import FlightSemantics.
From CoreCBMC Require Import ArithmeticTree BasicAnnotations ClampAnnotations FlightAnnotations NumericBounds ArithmeticExecution.
Theorem original_flight_integrator_annotated:forall e m bx bpy bp bi bm bf(flight:bool)pdx pdy ki ix iy cx cy maximum,
 e!S._pd_x=Some(bx,tint) ->e!S._pd_y=Some(bpy,tint) ->e!S._in_flight=Some(bf,tbool) ->
 e!S._guidance_pid=None ->Genv.find_symbol ge S._guidance_pid=Some bp ->
 e!S._guidance_pid_trim_att_integrator=None ->Genv.find_symbol ge S._guidance_pid_trim_att_integrator=Some bi ->
 e!S._traj_max_bank=None ->Genv.find_symbol ge S._traj_max_bank=Some bm ->
 NoDup[bx;bpy;bp;bi;bm;bf] ->
 Mem.load Mint8unsigned m bf 0=Some(Vint(if flight then Int.one else Int.zero)) ->
 Mem.load Mint32 m bx 0=Some(Vint pdx) ->Mem.load Mint32 m bpy 0=Some(Vint pdy) ->
 Mem.load Mint32 m bp 8=Some(Vint ki) ->
 Mem.load Mint32 m bi 0=Some(Vint ix) ->Mem.load Mint32 m bi 4=Some(Vint iy) ->
 Mem.load Mint32 m bp 32=Some(Vint cx) ->Mem.load Mint32 m bp 36=Some(Vint cy) ->
 Mem.load Mint32 m bm 0=Some(Vint maximum) ->
 maximum=Int.repr 1429 ->
 0<=Int.signed ki<=100 ->int_bound pdx 12800 ->int_bound pdy 12800 ->
 int_bound ix 100000000 ->int_bound iy 100000000 ->
 int_bound cx 1429 ->int_bound cy 1429 ->
 Mem.valid_access m Mint32 bi 0 Writable ->Mem.valid_access m Mint32 bi 4 Writable ->
 Mem.valid_access m Mint32 bp 32 Writable ->Mem.valid_access m Mint32 bp 36 Writable ->
 exists mf,annotated_execution ge e flight_statement m mf /\
 Mem.load Mint32 mf bi 0=Some(Vint(next_integral flight ix ki pdx (Int.repr 1429))) /\
 Mem.load Mint32 mf bi 4=Some(Vint(next_integral flight iy ki pdy (Int.repr 1429))) /\
 Mem.load Mint32 mf bp 32=Some(Vint(next_command flight cx(next_integral flight ix ki pdx (Int.repr 1429)))) /\
 Mem.load Mint32 mf bp 36=Some(Vint(next_command flight cy(next_integral flight iy ki pdy (Int.repr 1429)))) /\
 raw_writes(fun b=>b=bi\/b=bp)m mf /\replay_stores m(flight_updates flight bi bp pdx pdy ki ix iy cx cy (Int.repr 1429))=Some mf.
Proof.
 intros e m bx bpy bp bi bm bf flight pdx pdy ki ix iy cx cy maximum EX EY EF NP SP NI SI NM SM SEP LF LPX LPY LKI LIX LIY LCX LCY LM MAXIMUM GAIN PDXB PDYB IXB IYB CXB CYB AIX AIY ACX ACY.
 subst maximum.
 assert(DIST:bx<>bpy /\ bx<>bp /\ bx<>bi /\ bx<>bm /\ bx<>bf /\ bpy<>bp /\ bpy<>bi /\ bpy<>bm /\ bpy<>bf /\ bp<>bi /\ bp<>bm /\ bp<>bf /\ bi<>bm /\ bi<>bf /\ bm<>bf).
 {repeat rewrite NoDup_cons_iff in SEP;simpl in SEP;intuition congruence. }
 destruct DIST as(D0&D1&D2&D3&D4&D5&D6&D7&D8&D9&D10&D11&D12&D13&D14).
 assert(FL:eval_simple_rvalue ge e m(Evalof(Evar S._in_flight tbool)tbool)(Vint(if flight then Int.one else Int.zero))).
 { eapply read_scalar with(chunk:=Mbool)(b:=bf)(ofs:=Ptrofs.zero);
   [apply esl_var_local;exact EF|reflexivity|reflexivity|reflexivity|change(Mem.load Mbool m bf 0=Some(Vint(if flight then Int.one else Int.zero)));rewrite Mem.load_bool_int8_unsigned,LF;destruct flight;reflexivity]. }


 assert(IXW:int_bound ix 101280000)by(unfold int_bound in*;lia).
 assert(IYW:int_bound iy 101280000)by(unfold int_bound in*;lia).
 assert(CXW:int_bound cx 2858)by(unfold int_bound in*;lia).
 assert(CYW:int_bound cy 2858)by(unfold int_bound in*;lia).
 assert(CLX:int_bound(clip_bits(Int.add ix(Int.mul ki pdx))(Int.shl(Int.repr 1429)(Int.repr 16)))101280000).
 { rewrite trajectory_high_resolution;pose proof(clamp_bound(Int.add ix(Int.mul ki pdx))93650944 ltac:(lia));unfold int_bound in*;lia. }
 assert(CLY:int_bound(clip_bits(Int.add iy(Int.mul ki pdy))(Int.shl(Int.repr 1429)(Int.repr 16)))101280000).
 { rewrite trajectory_high_resolution;pose proof(clamp_bound(Int.add iy(Int.mul ki pdy))93650944 ltac:(lia));unfold int_bound in*;lia. }

 destruct flight.
 - cbn[next_integral next_command]in*.
   destruct(Mem.valid_access_store m Mint32 bi 0(Vint(Int.add ix(Int.mul ki pdx)))AIX)as[m1 ST1].
   assert(A2:Mem.valid_access m1 Mint32 bi 4 Writable).
   {eapply Mem.store_valid_access_1;[exact ST1|]. exact AIY. }
   destruct(Mem.valid_access_store m1 Mint32 bi 4(Vint(Int.add iy(Int.mul ki pdy)))A2)as[m2 ST2].
   assert(A3:Mem.valid_access m2 Mint32 bi 0 Writable).
   {eapply Mem.store_valid_access_1;[exact ST2|]. eapply Mem.store_valid_access_1;[exact ST1|]. exact AIX. }
   destruct(Mem.valid_access_store m2 Mint32 bi 0(Vint(clip_bits(Int.add ix(Int.mul ki pdx))(Int.shl (Int.repr 1429)(Int.repr 16))))A3)as[m3 ST3].
   assert(A4:Mem.valid_access m3 Mint32 bi 4 Writable).
   {eapply Mem.store_valid_access_1;[exact ST3|]. eapply Mem.store_valid_access_1;[exact ST2|]. eapply Mem.store_valid_access_1;[exact ST1|]. exact AIY. }
   destruct(Mem.valid_access_store m3 Mint32 bi 4(Vint(clip_bits(Int.add iy(Int.mul ki pdy))(Int.shl (Int.repr 1429)(Int.repr 16))))A4)as[m4 ST4].
   assert(A5:Mem.valid_access m4 Mint32 bp 32 Writable).
   {eapply Mem.store_valid_access_1;[exact ST4|]. eapply Mem.store_valid_access_1;[exact ST3|]. eapply Mem.store_valid_access_1;[exact ST2|]. eapply Mem.store_valid_access_1;[exact ST1|]. exact ACX. }
   destruct(Mem.valid_access_store m4 Mint32 bp 32(Vint(Int.add cx(Int.shr(clip_bits(Int.add ix(Int.mul ki pdx))(Int.shl (Int.repr 1429)(Int.repr 16)))(Int.repr 16))))A5)as[m5 ST5].
   assert(A6:Mem.valid_access m5 Mint32 bp 36 Writable).
   {eapply Mem.store_valid_access_1;[exact ST5|]. eapply Mem.store_valid_access_1;[exact ST4|]. eapply Mem.store_valid_access_1;[exact ST3|]. eapply Mem.store_valid_access_1;[exact ST2|]. eapply Mem.store_valid_access_1;[exact ST1|]. exact ACY. }
   destruct(Mem.valid_access_store m5 Mint32 bp 36(Vint(Int.add cy(Int.shr(clip_bits(Int.add iy(Int.mul ki pdy))(Int.shl (Int.repr 1429)(Int.repr 16)))(Int.repr 16))))A6)as[mf ST6].

   assert(ANN1:arithmetic_tree ge e m(integral_add_expr S._x S._pd_x)).
   { eapply (proj1(original_flight_axis_annotations e m bx bp bi bm S._x S._pd_x 0 pdx ki ix cx
       EX NP SP NI SI NM SM (or_introl(conj eq_refl eq_refl)) LPX LKI LIX LCX LM GAIN PDXB IXW CXW)). }
   assert(ANN2:arithmetic_tree ge e m1(integral_add_expr S._y S._pd_y)).
   { eapply (proj1(original_flight_axis_annotations e m1 bpy bp bi bm S._y S._pd_y 4 pdy ki iy cy
       EY NP SP NI SI NM SM (or_intror(conj eq_refl eq_refl))
       ltac:(scalar_frame;exact LPY) ltac:(scalar_frame;exact LKI)
       ltac:(scalar_frame;exact LIY) ltac:(scalar_frame;exact LCY) ltac:(scalar_frame;exact LM)
       GAIN PDYB IYW CYW)). }
   assert(ANN5:arithmetic_tree ge e m4(command_add_expr S._x)).
   { eapply (proj2(proj2(original_flight_axis_annotations e m4 bx bp bi bm S._x S._pd_x 0 pdx ki
       (clip_bits(Int.add ix(Int.mul ki pdx))(Int.shl(Int.repr 1429)(Int.repr 16)))cx
       EX NP SP NI SI NM SM (or_introl(conj eq_refl eq_refl))
       ltac:(scalar_frame;exact LPX) ltac:(scalar_frame;exact LKI)
       ltac:(scalar_frame;reflexivity) ltac:(scalar_frame;exact LCX) ltac:(scalar_frame;exact LM)
       GAIN PDXB CLX CXW))). }
   assert(ANN6:arithmetic_tree ge e m5(command_add_expr S._y)).
   { eapply (proj2(proj2(original_flight_axis_annotations e m5 bpy bp bi bm S._y S._pd_y 4 pdy ki
       (clip_bits(Int.add iy(Int.mul ki pdy))(Int.shl(Int.repr 1429)(Int.repr 16)))cy
       EY NP SP NI SI NM SM (or_intror(conj eq_refl eq_refl))
       ltac:(scalar_frame;exact LPY) ltac:(scalar_frame;exact LKI)
       ltac:(scalar_frame;reflexivity) ltac:(scalar_frame;exact LCY) ltac:(scalar_frame;exact LM)
       GAIN PDYB CLY CYW))). }
   exists mf;split.
   + unfold flight_statement;cbn[top_statement S.f_guidance_pid_h_run fn_body].
     eapply ax_if with(value:=Vint Int.one)(taken:=true).
     * reflexivity.
     * apply(proj1(simple_big_denotation ge e m));[exact FL|reflexivity].
     * reflexivity.
     * apply data_expression_tree;reflexivity.
     * cbn.
       eapply ax_sequence.
       -- eapply ax_atomic;[reflexivity|flight_add EX EY NP SP NI SI NM SM ST1|exact ANN1].
       -- eapply ax_sequence.
          ++ eapply ax_atomic;[reflexivity|flight_add EX EY NP SP NI SI NM SM ST2|exact ANN2].
          ++ eapply ax_sequence.
             ** eapply ax_sequence.
                --- eapply ax_assignment;try reflexivity.
                    +++ flight_clamp EX EY NP SP NI SI NM SM ST3.
                    +++ eapply original_integrator_clamp_annotation;[exact NM|exact SM|scalar_frame;exact LM].
                --- eapply ax_assignment;try reflexivity.
                    +++ flight_clamp EX EY NP SP NI SI NM SM ST4.
                    +++ eapply original_integrator_clamp_annotation;[exact NM|exact SM|scalar_frame;exact LM].
             ** eapply ax_sequence.
                --- eapply ax_atomic;[reflexivity|flight_add EX EY NP SP NI SI NM SM ST5|exact ANN5].
                --- eapply ax_atomic;[reflexivity|flight_add EX EY NP SP NI SI NM SM ST6|exact ANN6].
   + repeat split;try(scalar_frame;reflexivity).
     eapply raw_writes_store;[left;reflexivity|exact ST1|].
     eapply raw_writes_store;[left;reflexivity|exact ST2|].
     eapply raw_writes_store;[left;reflexivity|exact ST3|].
     eapply raw_writes_store;[left;reflexivity|exact ST4|].
     eapply raw_writes_store;[right;reflexivity|exact ST5|].
     eapply raw_writes_store;[right;reflexivity|exact ST6|constructor].
     cbv beta iota zeta delta[flight_updates next_integral next_command replay_stores];rewrite ST1,ST2,ST3,ST4,ST5,ST6;reflexivity.
 - cbn[next_integral next_command]in*.
   destruct(Mem.valid_access_store m Mint32 bi 0(Vint Int.zero)AIX)as[m1 ST1].
   assert(A2:Mem.valid_access m1 Mint32 bi 4 Writable)by(eapply Mem.store_valid_access_1;eauto).
   destruct(Mem.valid_access_store m1 Mint32 bi 4(Vint Int.zero)A2)as[mf ST2].
   exists mf;split.
   + unfold flight_statement;cbn[top_statement S.f_guidance_pid_h_run fn_body].
     eapply ax_if with(value:=Vint Int.zero)(taken:=false).
     * reflexivity.
     * apply(proj1(simple_big_denotation ge e m));[exact FL|reflexivity].
     * reflexivity.
     * apply data_expression_tree;reflexivity.
     * cbn;eapply ax_sequence.
       -- eapply ax_atomic;[reflexivity|eapply atomic_assign;[core_lv EX EY I NP I I SP I I NI SI NM SM|reflexivity|constructor|reflexivity|reflexivity|eapply assign_loc_value;[reflexivity|reflexivity|exact ST1]|reflexivity]|].
          cbn[arithmetic_tree];repeat split;exact I.
       -- eapply ax_atomic;[reflexivity|eapply atomic_assign;[core_lv EX EY I NP I I SP I I NI SI NM SM|reflexivity|constructor|reflexivity|reflexivity|eapply assign_loc_value;[reflexivity|reflexivity|exact ST2]|reflexivity]|].
          cbn[arithmetic_tree];repeat split;exact I.
   + repeat split;try(scalar_frame;first[reflexivity|assumption]).
     eapply raw_writes_store;[left;reflexivity|exact ST1|].
     eapply raw_writes_store;[left;reflexivity|exact ST2|constructor].
     cbv beta iota zeta delta[flight_updates replay_stores];rewrite ST1,ST2;reflexivity.
Qed.

Print Assumptions original_flight_integrator_annotated.
