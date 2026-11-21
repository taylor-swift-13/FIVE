From Stdlib Require Import List Bool Arith.
From compcert Require Import AST Values Memory Events Globalenvs Ctypes Cop Csyntax Csem.
From FiveGuidanceSemantics Require Import SourceClosure WeightedTermination SourceTermination SemanticsSupport.
Import ListNotations.
Definition allowed(defs:list(ident*globdef Csyntax.fundef type))(fd:Csyntax.fundef):Prop :=
 match fd with
 | Internal _=>exists id,In(id,Gfun fd)defs
 | External ef _ _ _=>executable_builtin ef=true end.
Definition check_fd(weight:type->nat)(signature:type)(result:type)(fd:Csyntax.fundef):bool :=
 if type_eq(type_of_fundef fd)signature then
 Nat.ltb(activation_rank weight fd + 2)(1+weight result) &&
 match fd with Internal _=>true | External ef _ _ _=>executable_builtin ef end
 else true.
Definition check_global(weight:type->nat)(signature:type)(result:type)(idgd:ident*globdef Csyntax.fundef type):bool :=
 match snd idgd with Gfun fd=>check_fd weight signature result fd | Gvar _=>true end.
Lemma checked_call_closed:forall (ge:genv) defs weight,
 (forall v fd,Genv.find_funct ge v=Some fd -> exists id,In(id,Gfun fd)defs) ->
 forall params result cc ty,
 forallb(check_global weight(Tfunction params result cc)ty)defs=true ->
 SourceClosure.valid_call ge (allowed defs)(SourceTermination.static_budget weight)(Tfunction params result cc)ty.
Proof.
 intros ge defs weight LOOK params result cc ty CHECK vf fd tyargs tyres cc1 FIND CL TY.
 simpl in CL;inversion CL;subst tyargs tyres cc1.
 destruct(LOOK _ _ FIND) as [id IN].
 apply forallb_forall with (x:=(id,Gfun fd)) in CHECK;[|exact IN].
 unfold check_global,check_fd in CHECK;cbn [snd] in CHECK.
 destruct(type_eq(type_of_fundef fd)(Tfunction params result cc));[|contradiction].
 apply andb_true_iff in CHECK;destruct CHECK as [R SUP].
 apply Nat.ltb_lt in R.
 split;[destruct fd;cbn [allowed] in *;[exists id;exact IN|exact SUP]|exact R].
Qed.
Fixpoint internal_functions(defs:list(ident*globdef Csyntax.fundef type)):list function :=
 match defs with
 | []=>[]
 | (_,Gfun(Internal f))::rest=>f::internal_functions rest
 | _::rest=>internal_functions rest end.
Lemma internal_functions_in:forall defs id f,
 In(id,Gfun(Internal f))defs -> In f(internal_functions defs).
Proof.
 induction defs as [|[id0 gd]rest IH];simpl;intros id f IN;[contradiction|].
 destruct IN as [EQ|IN].
 - inversion EQ;subst;simpl;auto.
 - destruct gd as [fd|gv];[destruct fd|];simpl;eauto.
Qed.

Lemma global_function_in:forall(p:Csyntax.program)v fd,
 Genv.find_funct(Csem.globalenv p)v=Some fd ->
 exists id,In(id,Gfun fd)(AST.prog_defs p).
Proof. intros;exact(Genv.find_funct_inversion _ _ H). Qed.
