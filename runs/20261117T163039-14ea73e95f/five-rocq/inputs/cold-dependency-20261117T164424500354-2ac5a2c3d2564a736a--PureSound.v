From Stdlib Require Import Bool List ZArith.
From compcert Require Import Coqlib Errors Maps Integers Values Memory Events Globalenvs Determinism Ctypes Cop Csyntax Csem Cexec Cstrategy Smallstep.
From FiveGuidanceAllOrder Require Import PureSyntax PureDenotation PureProgress.
Lemma simple_big_denotation:forall ge e m,
 (forall a v,eval_simple_rvalue ge e m a v -> simple a=true ->
 pure_rval ge e m a=Some v) /\
 (forall a b ofs bf,eval_simple_lvalue ge e m a b ofs bf ->simple a=true ->
 pure_lval ge e m a=Some(b,ofs,bf)).
Proof.
 intros ge e m;apply eval_simple_rvalue_lvalue_ind;intros;
 cbn[simple]in *;core_unpack;cbn[pure_rval pure_lval];
 try discriminate;fold(pure_rval ge e m)(pure_lval ge e m);
 repeat match goal with IH:simple ?A=true -> _=Some _ |- _ =>
 specialize(IH ltac:(assumption)) end;
 repeat match goal with H:?A=Some _ |- _=>progress rewrite H end;
 repeat match goal with H:?A=None |- _=>progress rewrite H end;
 repeat match goal with H:?A=OK _ |- _=>progress rewrite H end;
 repeat match goal with H:typeof _=_ |- _=>progress rewrite H end;
 repeat match goal with H:_=typeof _ |- _=>progress rewrite <-H end;
 try rewrite dec_eq_true;try reflexivity.
 all: try match goal with D:deref_loc _ _ _ _ _ _ E0 _ |- _=>
 rewrite(Cexec.do_deref_loc_complete ge PureDenotation.quiet_world _ _ _ _ _ PureDenotation.quiet_world E0 _ D(possible_trace_nil _));reflexivity end.
 all: cbn beta iota zeta.
 all: repeat match goal with H:?A=Some _ |- _=>progress rewrite H end.
 all: repeat match goal with H:?A=OK _ |- _=>progress rewrite H end.
 all: try reflexivity.
 all: try match goal with D:deref_loc _ _ _ _ _ _ E0 _ |- _=>
 rewrite(Cexec.do_deref_loc_complete ge PureDenotation.quiet_world _ _ _ _ _ PureDenotation.quiet_world E0 _ D(possible_trace_nil _));reflexivity end.

Qed.
Print Assumptions simple_big_denotation.
