From Stdlib Require Import List ZArith Lia.
From compcert Require Import AST Integers Floats Values Memory Globalenvs.
From FiveQuatRotationSupport Require Import Fixture.
Require FiveQuatVmultCase.Contract.
Import ListNotations.
Local Open Scope Z_scope.
Definition fb(z:Z):float32:=Float32.of_bits(Int.repr z).
Definition init_tag(o:option fixture):bool:=match o with Some _=>true|None=>false end.
Lemma force_fixture_spec:forall q v,init_tag(make_fixture q v)=true->make_fixture q v=Some(force_fixture(make_fixture q v)).
Proof. intros q v H;destruct(make_fixture q v);[reflexivity|discriminate]. Qed.
Lemma unit_fixture_defined:make_fixture q_unit v_unit=Some unit_fixture.
Proof. apply force_fixture_spec;vm_compute;reflexivity. Qed.
Lemma trace_fixture_defined:make_fixture q_trace v_trace=Some trace_fixture.
Proof. apply force_fixture_spec;vm_compute;reflexivity. Qed.
Lemma globals_defined:global_initial=Some base_memory.
Proof. vm_compute;reflexivity. Qed.
Ltac valid_compute:=
 match goal with |-Mem.valid_access ?m ?ch ?b ?ofs ?p=>
 let A:=fresh"ACCESS"in let B:=fresh"BOOL"in
 assert(B:(if Mem.valid_access_dec m ch b ofs p then true else false)=true)by(vm_compute;reflexivity);
 destruct(Mem.valid_access_dec m ch b ofs p)as[A|A];[exact A|discriminate B]
 end.
Lemma unit_inputs:FiveQuatVmultCase.Contract.Inputs(initial unit_fixture)(qb unit_fixture)(vb unit_fixture)(ab unit_fixture)(fb 1065353216)(fb 0)(fb 0)(fb 0)(fb 1065353216)(fb 0)(fb 0).
Proof. constructor;try(vm_compute;discriminate);try(vm_compute;reflexivity).
 intros ofs H;destruct H as[<-|[<-|[<-|H]]];try contradiction;valid_compute. Qed.
Lemma trace_inputs:FiveQuatVmultCase.Contract.Inputs(initial trace_fixture)(qb trace_fixture)(vb trace_fixture)(ab trace_fixture)(fb 3208096458)(fb 3191717350)(fb 2687829235)(fb 268909329)(fb 1124089879)(fb 1149239296)(fb 2382364672).
Proof. constructor;try(vm_compute;discriminate);try(vm_compute;reflexivity).
 intros ofs H;destruct H as[<-|[<-|[<-|H]]];try contradiction;valid_compute. Qed.
