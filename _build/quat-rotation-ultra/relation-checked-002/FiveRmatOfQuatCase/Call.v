From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Errors Maps Integers Floats AST Values Memory Memdata Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cexec Smallstep.
From FiveGuidanceAllOrder Require Import PureDenotation AtomicDenotation CallfreeExecution.
From FiveGuidanceAllocation Require Import StackAllocation.
From FiveGuidanceEntry Require Import StackCleanup FunctionAllocation.
From FiveRmatOfQuat Require Import Source Execution.
From FiveRmatOfQuatCase Require Import Base Contract Body Output.
Import ListNotations.
Local Open Scope Z_scope.
Lemma eval_actions_app:forall e xs ys m mm mf,
 stmt_eval Execution.ge e tvoid(fold_right(fun a s=>Ssequence(Sdo a)s)Sskip xs)m=Some(Nnormal,mm)->
 stmt_eval Execution.ge e tvoid(fold_right(fun a s=>Ssequence(Sdo a)s)Sskip ys)mm=Some(Nnormal,mf)->
 stmt_eval Execution.ge e tvoid(fold_right(fun a s=>Ssequence(Sdo a)s)Sskip(xs++ys))m=Some(Nnormal,mf).
Proof. intros e xs;induction xs as[|x xs IH];intros ys m mm mf HX HY.
 - cbn[fold_right stmt_eval]in HX;injection HX as<-;exact HY.
 - cbn[app fold_right stmt_eval]in HX|-*;destruct(atomic_eval Execution.ge e m x)as[[v m1]|]eqn:AX;try discriminate.
 eapply IH;[exact HX|exact HY]. Time Qed.
Fixpoint action_tree(xs:list expr):statement:=match xs with []=>Sskip|a::tail=>match tail with []=>Sdo a|_=>Ssequence(Sdo a)(action_tree tail)end end.
Lemma eval_tree_fold:forall e xs m,
 stmt_eval Execution.ge e tvoid(action_tree xs)m=stmt_eval Execution.ge e tvoid(fold_right(fun a s=>Ssequence(Sdo a)s)Sskip xs)m.
Proof. intros e xs;induction xs as[|a xs IH];intros m;[reflexivity|].
 destruct xs as[|b bs].
 - cbn[action_tree fold_right stmt_eval];destruct(atomic_eval Execution.ge e m a)as[[v mm]|];reflexivity.
 - cbn[action_tree fold_right stmt_eval];destruct(atomic_eval Execution.ge e m a)as[[v mm]|];[exact(IH mm)|reflexivity]. Qed.
Lemma source_tree:fn_body Source.f_float_rmat_of_quat=action_tree acts.
Proof. reflexivity. Qed.
Lemma stores_trans:forall e out m mm mf,stores e out m mm->stores e out mm mf->stores e out m mf.
Proof. intros e out m mm mf A B;induction B;[exact A|eapply stores_step;[exact(IHB A)|exact H|exact H0]]. Qed.
Lemma full_body:forall e q out qi qx qy qz bq br m,
 env_separated e->Nonlocal e q out->locals_defined e->e!Source._q=Some(bq,qtype)->e!Source._rm=Some(br,rmtype)->
 Context e q out qi qx qy qz(rho0 q out)m->
 exists mf,stmt_eval Execution.ge e tvoid(fn_body Source.f_float_rmat_of_quat)m=Some(Nnormal,mf) /\
 Context e q out qi qx qy qz(rho11 q out qi qx qy qz)mf /\stores e out m mf /\ (exists mm,nine_stores mm out(matrix_values qi qx qy qz)mf).
Proof.
 intros e q out qi qx qy qz bq br m SEP NL DEF Q R CT.
 Time destruct(locals_body e q out qi qx qy qz SEP NL DEF bq Q m CT)as[mm[EV[CTM ST]]].
 Time destruct(output_body e q out qi qx qy qz NL DEF br R mm CTM)as[mf[EVF[CTF[OUTPUT STF]]]].
 exists mf;split.
 - rewrite source_tree,eval_tree_fold.
 Time rewrite<-(firstn_skipn 11 acts).
   Time exact(eval_actions_app e(firstn 11 acts)(skipn 11 acts)m mm mf EV EVF).
 - split;[exact CTF|].
   split;[exact(stores_trans e out m mm mf ST STF)|exists mm;exact OUTPUT].
Time Qed.
Definition decls:=fn_params Source.f_float_rmat_of_quat++fn_vars Source.f_float_rmat_of_quat.
Lemma decls_nodup:NoDup(map fst decls).
Proof. vm_compute;repeat constructor;simpl;intuition discriminate. Time Qed.
