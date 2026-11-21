From Stdlib Require Import List Bool ZArith.
From compcert Require Import Coqlib Errors Maps Integers Values Memory Events Globalenvs Determinism Ctypes Cop Csyntax Csyntaxdefs Csem Cexec Cstrategy Smallstep.
From FiveGuidanceAllOrder Require Import PureDenotation PureProgress AtomicDenotation BlockExecution PhaseComposition FactorShell.
From PidPositionSafety Require Import HiddenResultLhs HiddenResultContext ObservedReadonly.
From CoreCBMC Require Import ArithmeticHiddenPre ArithmeticObservation ArithmeticTree.
From PidPositionTranslationAttempt002 Require Import ArithmeticHiddenPost.
Import ListNotations.
Module A:=ArithmeticHiddenPre.
Module B:=ArithmeticHiddenPost.
Module L:=HiddenResultLhs.
Section COMPLETE.
Variable ge:genv.
Variable caller leaf owner:function.
Variable e:env.
Variable k:cont.
Variable m mc mf:mem.
Variable sid ires:AST.ident.
Variable br ret:block.
Variable params:list type.
Variable cc:AST.calling_convention.
Variable vf:val.
Variable values:list val.
Variable fn:expr.
Variable args:exprlist.
Variable post:expr.
Variable v vc copied:val.
Local Notation sty:=(L.sty sid).
Hypothesis local_res:e!ires=Some(br,tptr sty).
Hypothesis res_before:Cexec.do_deref_loc ge quiet_world(tptr sty)m br Ptrofs.zero Full=
 Some(quiet_world,E0,Vptr ret Ptrofs.zero).
Hypothesis res_after:Cexec.do_deref_loc ge quiet_world(tptr sty)mc br Ptrofs.zero Full=
 Some(quiet_world,E0,Vptr ret Ptrofs.zero).
Hypothesis find_leaf:Genv.find_funct ge vf=Some(Internal leaf).
Hypothesis leaf_type:type_of_fundef(Internal leaf)=Tfunction params tvoid cc.
Hypothesis prepared_initial:A.prepared ge e m params cc vf values fn args.
Hypothesis post_type:typeof post=sty.
Hypothesis post_simple:simple post=true.
Hypothesis post_tree:arithmetic_tree ge e mc post.
Hypothesis post_value:pure_rval ge e mc post=Some v.
Hypothesis cast_value:sem_cast v sty sty mc=Some vc.
Hypothesis store_copy:Cexec.do_assign_loc ge quiet_world sty mc ret Ptrofs.zero Full vc=
 Some(quiet_world,E0,mf,copied).
Local Notation observe:=(arithmetic_observation ge owner).
Hypothesis callee_certificate:forall base,is_call_cont base ->
 exists P,certificate ge P(Returnstate Vundef base mc)/\
 P(Callstate(Internal leaf)values base m)/\(forall s,P s->observe s).
Definition prepared_pair:Type:={p:expr*exprlist|A.prepared ge e m params cc vf values(fst p)(snd p)}.
Definition start_pair:prepared_pair:=exist _ (fn,args)prepared_initial.
Definition Pre(st:L.lhs_stage)(r:prepared_pair)(_:unit):Csem.state:=
 A.pre_state caller e k m sid ires br ret post st(fst(proj1_sig r))(snd(proj1_sig r)).
Definition Frame(st:L.lhs_stage)(_:prepared_pair):cont:=
 A.frame caller e k sid ires br ret post st.
Definition Call(st:L.lhs_stage)(r:prepared_pair):Csem.state:=
 Callstate(Internal leaf)values(Frame st r)m.
Definition Post(st:L.lhs_stage)(_:prepared_pair):Csem.state:=
 B.post_state caller e k mc sid ires br ret post st.
Definition Initial:Csem.state:=State caller
 (Sdo(hidden_expr(L.lhs sid ires br ret L.H0)fn args post sty))k e m.
Definition target:=State caller Sskip k e mf.
Lemma convert_class:forall next,
 A.pre_or_call ge caller leaf e k m sid ires br ret params cc vf values post next ->
 ObservedReadonly.pre_or_call L.lhs_stage prepared_pair unit Pre Call next.
Proof.
 intros next[[st[fn'[al'[P EQ]]]]|[st EQ]].
 - left;exists st,(exist _ (fn',al')P),tt;exact EQ.
 - right;exists st,start_pair;exact EQ.
Qed.
Theorem hidden_result_arithmetic_certificate:
 exists P,certificate ge P target/\P Initial/\(forall s,P s->observe s).
Proof.
 assert(PP:forall st r u,exists t next,Csem.step ge(Pre st r u)t next/\
 ObservedReadonly.pre_or_call L.lhs_stage prepared_pair unit Pre Call next).
 { intros st[[f al]P]u.
   destruct(A.pre_progress ge caller leaf e k m sid ires br ret params cc vf values post
   local_res res_before find_leaf leaf_type st f al P)as[t[next[STEP CL]]].
   exists t,next;split;[exact STEP|apply convert_class;exact CL]. }
 assert(PC:forall st r u t next,Csem.step ge(Pre st r u)t next ->
 ObservedReadonly.pre_or_call L.lhs_stage prepared_pair unit Pre Call next).
 { intros st[[f al]P]u t next STEP;apply convert_class.
   exact(proj2(A.pre_all_successors ge caller leaf e k m sid ires br ret params cc vf values post
   local_res res_before find_leaf leaf_type st f al t next P STEP)). }
 assert(CAL:forall st r,exists P,certificate ge P(Returnstate Vundef(Frame st r)mc)/\P(Call st r)/\(forall s,P s->observe s)).
 { intros;apply callee_certificate;exact I. }
 assert(RET:forall st r,unique_transition ge(Returnstate Vundef(Frame st r)mc)(Post st r)).
 { intros;unfold Frame,A.frame,Post,B.post_state,B.comma_expr;split;[right;apply Csem.step_returnstate|].
   intros t next STEP;exact(FactorShell.return_call_step_unique ge Vundef caller e
   (fun hole=>Eassign(L.lhs sid ires br ret st)(Ecomma hole post sty)sty)tvoid(Kdo k)mc t next STEP). }
 assert(POST:forall st r,exists Q,certificate ge Q target/\Q(Post st r)/\(forall s,Q s->observe s)).
 { intros;eexists;split.
   - exact(B.post_certificate ge caller e k mc mf sid ires br ret post v vc copied
     local_res res_after post_type post_simple post_tree post_value cast_value store_copy).
   - split;[apply B.post_initial|].
     intros s INV;apply tree_state_observation;destruct s;try exact I.
     eapply B.post_observation;[exact post_tree|exact INV]. }
 eexists;split.
 - eapply ObservedReadonly.readonly_assignment_certificate
   with(pre:=Pre)(call:=Call)(frame:=Frame)(post:=Post)(initial:=Initial)
   (observe:=observe)(result:=Vundef)(m:=mc)(l0:=L.H0)(r0:=start_pair)(f0:=tt).
   + exact PP.
   + exact PC.
   + split;[right;apply Csem.step_do_1|].
     intros t next STEP;eapply FactorShell.do_step_unique;exact STEP.
   + exact CAL.
   + exact RET.
   + exact POST.
 - split;[left;reflexivity|].
   intros s IN;eapply ObservedReadonly.observations with(initial:=Initial)(pre:=Pre);
   [exact I| |exact IN].
   intros st[[f al]PRE]u;unfold Pre;eapply A.pre_observation;exact PRE.
Qed.
End COMPLETE.
Print Assumptions hidden_result_arithmetic_certificate.
