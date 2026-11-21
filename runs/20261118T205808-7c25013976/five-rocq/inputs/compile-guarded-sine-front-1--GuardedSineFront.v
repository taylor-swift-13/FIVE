From Stdlib Require Import Bool List ZArith Lia.
From compcert Require Import Coqlib Maps Integers AST Values Memory Events Globalenvs Ctypes Ctypesdefs Cop Csyntax Cexec Csem Cstrategy.
Require PprzTrigPlain.Source PprzTrigLow.Source.
From PprzTrigRelationSupport Require Import PlainBody PlainEntry LowSin Total PureEval BranchPure.
From PprzTrigInitSupport Require Import Control.
From PprzTrigCBMC Require Import SourceObservations SineGuards Cutpoint MathCoverage GuardedCover SineMath SineCutpoints.
Import ListNotations.
Local Open Scope Z_scope.
Lemma fold_math_covers : forall ge Q f k b m a,
 -12867<=Int.signed a<=12867 ->Mem.load Mint32 m b 0=Some(Vint a) -> Mem.valid_access m Mint32 b 0 Writable ->
 (forall mf,fold_memory b a m mf -> guarded_covers ge Q(State f Sskip k(angle_env b)mf)) ->
 guarded_covers ge Q(State f fold_stmt k(angle_env b)m).
Proof.
 intros ge Q f k b m a RANGE LOAD VA END.
 pose proof(sine_front_math_guards ge b m a RANGE LOAD)as[UP[LOW[FG[NG[PR NR]]]]].
 change(guarded_covers ge Q(State f(Sifthenelse fold_guard fold_yes fold_no)k(angle_env b)m)).
 eapply if_math_guarded with(v:=Val.of_bool(Int.cmp Cgt a(Int.repr 6433)))(choice:=Int.cmp Cgt a(Int.repr 6433)).
 - reflexivity.
 - apply fold_guard_value;exact LOAD.
 - exact FG.
 - apply bool_of_bool.
 - destruct(Int.cmp Cgt a(Int.repr 6433))eqn:C1;simpl.
   + destruct(Mem.valid_access_store _ _ _ _ (Vint(Int.sub(Int.repr 12867)a)) VA)as[mf STORE].
     eapply do_flat_math_guarded with(v:=Vint(Int.sub(Int.repr 12867)a))(mf:=mf).
     * reflexivity.
     * reflexivity.
     * reflexivity.
     * change(True /\math_guarded ge(angle_env b)m rhs_positive);split;[exact I|exact PR].
     * apply assign_angle_value;[reflexivity|apply rhs_positive_value;exact LOAD|exact STORE].
     * apply END. unfold fold_memory,folded;rewrite C1;exact STORE.
   + change(guarded_covers ge Q(State f(Sifthenelse fold_negative_guard fold_negative_yes Sskip)k(angle_env b)m)).
     eapply if_math_guarded with(v:=Val.of_bool(Int.cmp Clt a(Int.repr(-6433))))(choice:=Int.cmp Clt a(Int.repr(-6433))).
     * reflexivity.
     * apply fold_negative_guard_value;exact LOAD.
     * exact NG.
     * apply bool_of_bool.
     * destruct(Int.cmp Clt a(Int.repr(-6433)))eqn:C2;simpl.
       -- destruct(Mem.valid_access_store _ _ _ _ (Vint(Int.sub(Int.repr(-12867))a)) VA)as[mf STORE].
          eapply do_flat_math_guarded with(v:=Vint(Int.sub(Int.repr(-12867))a))(mf:=mf).
          ++ reflexivity.
          ++ reflexivity.
          ++ reflexivity.
          ++ change(True /\math_guarded ge(angle_env b)m rhs_negative);split;[exact I|exact NR].
          ++ apply assign_angle_value;[reflexivity|apply rhs_negative_value;exact LOAD|exact STORE].
          ++ apply END. unfold fold_memory,folded;rewrite C1,C2;exact STORE.
       -- apply END. unfold fold_memory;rewrite C1,C2;reflexivity.
Qed.
Theorem normalized_front_math_covers : forall ge Q f k tail b m a,
 -12867<=Int.signed a<=12867 -> Mem.load Mint32 m b 0=Some(Vint a) ->
 Mem.valid_access m Mint32 b 0 Writable ->
 (forall mf,fold_memory b a m mf -> guarded_covers ge Q(State f tail k(angle_env b)mf)) ->
 guarded_covers ge Q(State f(Ssequence norm(Ssequence fold_stmt tail))k(angle_env b)m).
Proof.
 intros ge Q f k tail b m a RANGE LOAD VA END.
 pose proof(sine_front_math_guards ge b m a RANGE LOAD)as[UP[LOW REST]].
 apply sequence_guarded. change(guarded_covers ge Q(State f(Ssequence upper_loop lower_loop)
   (Kseq(Ssequence fold_stmt tail)k)(angle_env b)m)).
 apply sequence_guarded.
 eapply while_false_math_guarded with(v:=Vint Int.zero).
 - apply upper_guard_simple.
 - apply upper_guard_false with(a:=a);assumption.
 - exact UP.
 - reflexivity.
 - apply skip_sequence_guarded.
   eapply while_false_math_guarded with(v:=Vint Int.zero).
   + apply lower_guard_simple.
   + apply lower_guard_false with(a:=a);assumption.
   + exact LOW.
   + reflexivity.
   + apply skip_sequence_guarded. apply sequence_guarded.
     apply fold_math_covers with(a:=a);auto. intros mf FM.
     apply skip_sequence_guarded;apply END;exact FM.
Qed.
Theorem sine_entry_front_math_cut : forall(ge:Csem.genv)f tail kont m a,
 fn_params f=[(PprzTrigPlain.Source._angle,tint)] ->fn_vars f=[] ->
 fn_body f=Ssequence norm(Ssequence fold_stmt tail) ->
 -12867<=Int.signed a<=12867 ->
 guarded_covers ge(SineFrontPC ge f tail kont a)(Callstate(Internal f)[Vint a]kont m).
Proof.
 intros ge f tail kont m a PARAMS VARS BODY RANGE.
 destruct(Mem.alloc m 0 4)as[m1 local]eqn:ALLOC.
 assert(VAF:Mem.valid_access m1 Mint32 local 0 Freeable).
 { eapply Mem.valid_access_alloc_same;[exact ALLOC|lia|cbn;lia|]. exists 0;reflexivity. }
 assert(VAW:Mem.valid_access m1 Mint32 local 0 Writable)by(eapply Mem.valid_access_freeable_any;eauto).
 destruct(Mem.valid_access_store _ _ _ _ (Vint a) VAW)as[m2 STORE].
 assert(LOAD:Mem.load Mint32 m2 local 0=Some(Vint a))by(exact(Mem.load_store_same _ _ _ _ _ _ STORE)).
 assert(VA:Mem.valid_access m2 Mint32 local 0 Writable)by(eapply Mem.store_valid_access_1;eauto).
 assert(FREE:Mem.range_perm m2 local 0 4 Cur Freeable).
 { intros ofs B;eapply Mem.perm_store_1;[exact STORE|exact((proj1 VAF)ofs B)]. }
 eapply internal_guarded with(e:=angle_env local)(m1:=m1)(m2:=m2).
 - rewrite PARAMS,VARS;cbn[var_names];repeat constructor;cbn;auto.
 - rewrite PARAMS,VARS;cbn[List.app].
   change(Cexec.do_alloc_variables ge empty_env m[(PprzTrigPlain.Source._angle,tint)]=(angle_env local,m1)).
   cbn[Cexec.do_alloc_variables];change(match Mem.alloc m 0 4 with|(mm,bb)=>(PTree.set PprzTrigPlain.Source._angle(bb,tint)empty_env,mm)end=(angle_env local,m1)).
   rewrite ALLOC;reflexivity.
 - rewrite PARAMS;apply bind_angle;exact STORE.
 - rewrite BODY;eapply normalized_front_math_covers;try eassumption.
   intros mf FM;apply guarded_here;[exact I|];exists local,m2,mf.
   pose proof(normalized_source_pc_guards ge local m2 a RANGE LOAD)as G.
   pose proof(folded_source_index_guards a RANGE)as F.
   split;[reflexivity|]. split;[exact LOAD|]. split;[exact FM|]. split;[exact(proj1(fold_memory_local local a m2 mf LOAD FREE FM))|].
   repeat match goal with H:_/\_|-_=>destruct H end.
   repeat first[assumption|split];try lia;try reflexivity.

Qed.
Theorem plain_entry_front_math_cut : forall(ge:Csem.genv)kont m a,
 -12867<=Int.signed a<=12867 ->
 guarded_covers ge(SineFrontPC ge PlainBody.fun_sin PlainBody.return_stmt kont a)
 (Callstate(Internal PprzTrigPlain.Source.f_pprz_itrig_sin)[Vint a]kont m).
Proof. intros;eapply sine_entry_front_math_cut;try eassumption;reflexivity. Qed.
Theorem low_entry_front_math_cut : forall(ge:Csem.genv)kont m a,
 -12867<=Int.signed a<=12867 ->
 guarded_covers ge(SineFrontPC ge LowSin.sin_low LowSin.low_return_stmt kont a)
 (Callstate(Internal PprzTrigLow.Source.f_pprz_itrig_sin)[Vint a]kont m).
Proof. intros;eapply sine_entry_front_math_cut;try eassumption;reflexivity. Qed.
Print Assumptions sine_entry_front_math_cut.
