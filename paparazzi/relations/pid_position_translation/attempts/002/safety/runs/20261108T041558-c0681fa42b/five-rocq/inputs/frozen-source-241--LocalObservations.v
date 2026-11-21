From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Maps AST Integers Values Memory Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cstrategy Smallstep.
From PidPositionRunPos Require Import Source Execution.
From PidPositionTranslationSupport Require Import MemoryLayout.
From PidPositionTranslationProblem Require Import Spec.
From PidPositionSafety Require Import SnapshotInts AssertionSyntax AssertionEval MappedMain.
Import ListNotations.
Open Scope Z_scope.
Module E:=PidPositionRunPos.Execution.
Definition typed_snapshot(ty:type)(m:mem)(cells:list int_cell)(b:block)(mf:mem):Prop:=
 fresh_snapshot E.ge ty m cells b mf /\
 (forall o v,In(o,v)cells ->Mem.load Mint32 mf b o=Some(Vint v)) /\
 (forall o v,In(o,v)cells ->sem_cast(Vint v)tint tint mf=Some(Vint v)).
Theorem typed_snapshot_exists:forall ty m cells,
 Forall(cell_bounds(sizeof E.ge ty))cells ->cell_separated cells ->
 exists b mf,typed_snapshot ty m cells b mf /\
 (forall ch old ofs value,Mem.load ch m old ofs=Some value ->Mem.load ch mf old ofs=Some value).
Proof.
 intros ty m cells BOUNDS SEP.
 destruct(fresh_snapshot_exists E.ge ty m cells BOUNDS SEP)as[b[mf[FRESH[LOADS FRAME]]]].
 exists b,mf;split;[split;[exact FRESH|split;[exact LOADS|intros;reflexivity]]|exact FRAME].
Qed.
Definition local_one(id:ident)(ty:type)(b:block):env:=PTree.set id(b,ty)empty_env.
Definition local_two(i j:ident)(ty:type)(a b:block):env:=
 PTree.set j(b,ty)(local_one i ty a).
Definition local_four(ba bb bx byy:block):env:=
 PTree.set local_dy(byy,tint)
 (PTree.set local_dx(bx,tint)
 (PTree.set local_b(bb,gh_type)(local_one local_a gh_type ba))).
Definition evaluates_true(e:env)(m:mem)(a:expr):Prop:=
 assertion_true E.ge e m a /\
 star Csem.step E.ge(ExprState S.f_guidance_pid_h_run_pos a Kstop e m)E0
 (ExprState S.f_guidance_pid_h_run_pos(Eval(Vint Int.one)tint)Kstop e m).
Lemma evaluates_true_intro:forall e m a,assertion_true E.ge e m a ->evaluates_true e m a.
Proof.
 intros;split;[assumption|].
 exact(assertion_true_steps E.ge e m a H S.f_guidance_pid_h_run_pos Kstop(fun x=>x)(ctx_top RV)).
Qed.
Definition Observation1(af bf:mem):Prop:=
 exists x y snapshot observed,
 load_global Mint32 af S._guidance_pid_pos_err vec_type[S._x]=Some(Vint x) /\
 load_global Mint32 af S._guidance_pid_pos_err vec_type[S._y]=Some(Vint y) /\
 typed_snapshot vec_type bf[(0,x);(4,y)]snapshot observed /\
 evaluates_true(local_one local_err_a vec_type snapshot)observed assertion_1.
Definition Observation2(af bf:mem):Prop:=
 exists x y snapshot observed,
 load_global Mint32 af S._guidance_pid pid_type[S._cmd_earth;S._x]=Some(Vint x) /\
 load_global Mint32 af S._guidance_pid pid_type[S._cmd_earth;S._y]=Some(Vint y) /\
 typed_snapshot pid_type bf[(32,x);(36,y)]snapshot observed /\
 evaluates_true(local_one local_final_a pid_type snapshot)observed assertion_2.
Definition Observation3(af bf:mem):Prop:=
 exists x y snapshot observed,
 load_global Mint32 af S._guidance_pid_trim_att_integrator vec_type[S._x]=Some(Vint x) /\
 load_global Mint32 af S._guidance_pid_trim_att_integrator vec_type[S._y]=Some(Vint y) /\
 typed_snapshot vec_type bf[(0,x);(4,y)]snapshot observed /\
 evaluates_true(local_one local_integral_a vec_type snapshot)observed assertion_3.
Definition Observation4(ret:block)(af bf:mem):Prop:=
 exists tag fmt ba bb intermediate observed,
 load_path Mint32 af ret sp_type[S._type]=Some(Vint tag) /\
 load_path Mint32 af ret sp_type[S._format]=Some(Vint fmt) /\
 load_path Mint32 bf ret sp_type[S._type]=Some(Vint tag) /\
 load_path Mint32 bf ret sp_type[S._format]=Some(Vint fmt) /\
 typed_snapshot sp_type bf[(0,tag);(4,fmt)]ba intermediate /\
 typed_snapshot sp_type intermediate[(0,tag);(4,fmt)]bb observed /\
 evaluates_true(local_two local_ra local_rb sp_type ba bb)observed assertion_4.
Definition Observation5(ret:block)(af bf:mem):Prop:=
 exists x y h ba bb intermediate observed,
 load_path Mint32 af ret sp_type[S._sp;S._ltp_i;S._vect;S._x]=Some(Vint x) /\
 load_path Mint32 af ret sp_type[S._sp;S._ltp_i;S._vect;S._y]=Some(Vint y) /\
 load_path Mint32 af ret sp_type[S._sp;S._ltp_i;S._heading]=Some(Vint h) /\
 load_path Mint32 bf ret sp_type[S._sp;S._ltp_i;S._vect;S._x]=Some(Vint x) /\
 load_path Mint32 bf ret sp_type[S._sp;S._ltp_i;S._vect;S._y]=Some(Vint y) /\
 load_path Mint32 bf ret sp_type[S._sp;S._ltp_i;S._heading]=Some(Vint h) /\
 typed_snapshot sp_type bf[(8,x);(12,y);(16,h)]ba intermediate /\
 typed_snapshot sp_type intermediate[(8,x);(12,y);(16,h)]bb observed /\
 evaluates_true(local_two local_ra local_rb sp_type ba bb)observed assertion_5.
Definition Observation6(gh:block)(dx dy:Z)(af bf:mem):Prop:=
 exists x y rbx rby ba bb bx byy m1 m2 m3 observed,
 load_path Mint32 af gh gh_type(ref_pos S._x)=Some(Vint x) /\
 load_path Mint32 af gh gh_type(ref_pos S._y)=Some(Vint y) /\
 load_path Mint32 bf gh gh_type(ref_pos S._x)=Some(Vint rbx) /\
 load_path Mint32 bf gh gh_type(ref_pos S._y)=Some(Vint rby) /\
 typed_snapshot gh_type bf[(44,x);(48,y)]ba m1 /\
 typed_snapshot gh_type m1[(44,rbx);(48,rby)]bb m2 /\
 typed_snapshot tint m2[(0,Int.repr dx)]bx m3 /\
 typed_snapshot tint m3[(0,Int.repr dy)]byy observed /\
 evaluates_true(local_four ba bb bx byy)observed assertion_6.
Definition MainAssertionObservation1Goal:Prop:=forall gh ret a b dx dy flight af bf,
 InputPair gh ret a b dx dy ->NormalCall gh ret flight a af ->NormalCall gh ret flight b bf ->Observation1 af bf.
Definition MainAssertionObservation2Goal:Prop:=forall gh ret a b dx dy flight af bf,
 InputPair gh ret a b dx dy ->NormalCall gh ret flight a af ->NormalCall gh ret flight b bf ->Observation2 af bf.
Definition MainAssertionObservation3Goal:Prop:=forall gh ret a b dx dy flight af bf,
 InputPair gh ret a b dx dy ->NormalCall gh ret flight a af ->NormalCall gh ret flight b bf ->Observation3 af bf.
Definition MainAssertionObservation4Goal:Prop:=forall gh ret a b dx dy flight af bf,
 InputPair gh ret a b dx dy ->NormalCall gh ret flight a af ->NormalCall gh ret flight b bf ->Observation4 ret af bf.
Definition MainAssertionObservation5Goal:Prop:=forall gh ret a b dx dy flight af bf,
 InputPair gh ret a b dx dy ->NormalCall gh ret flight a af ->NormalCall gh ret flight b bf ->Observation5 ret af bf.
Definition MainAssertionObservation6Goal:Prop:=forall gh ret a b dx dy flight af bf,
 InputPair gh ret a b dx dy ->NormalCall gh ret flight a af ->NormalCall gh ret flight b bf ->Observation6 gh dx dy af bf.
Ltac snapshot_bounds n :=
 lazymatch goal with|-Forall _ ?cells=>change(Forall(cell_bounds n)cells)end;
 let rec go :=
  lazymatch goal with
  | |-Forall _[]=>constructor
  | |-Forall _(_::_)=>apply Forall_cons;
    [unfold cell_bounds;cbn;split;[lia|split;[lia|]];
     lazymatch goal with|-(4|?z)=>
      let q:=eval vm_compute in(z/4)in exists q;reflexivity end
    |go]
  end in go.
Ltac snapshot_separated :=
 cbn[cell_separated];repeat split;intros d IN;cbn in IN;
 repeat match goal with H:_\/_|-_=>destruct H end;
 try contradiction;subst d;cbn;lia.
Print Assumptions typed_snapshot_exists.
