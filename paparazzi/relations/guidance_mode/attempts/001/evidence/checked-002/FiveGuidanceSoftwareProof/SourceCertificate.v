From Stdlib Require Import List.
From compcert Require Import Maps AST Values Ctypes Csyntax Csyntaxdefs.
Require FiveGhSpeed.Source.
From FiveGuidanceSoftwareProof Require Import ValueEvaluator ValueChecker.
Import ListNotations.
Module S:=FiveGhSpeed.Source.
Fixpoint declaration_types(decls:list(ident*type)):PTree.t type:=
 match decls with []=>PTree.empty type|(id,ty)::tail=>PTree.set id ty(declaration_types tail)end.
Definition helper_declarations:=fn_params S.f_five_sqrtf++fn_vars S.f_five_sqrtf.
Definition helper_types:=declaration_types helper_declarations.
Definition helper_certificate:=
 check_statement S._FiveSqrtBits S._f S._u helper_types tfloat[S._x](fn_body S.f_five_sqrtf).
Lemma actual_helper_certificate:helper_certificate=Some StaticReturn.
Proof. vm_compute;reflexivity. Qed.
Definition source_derived_sqrt(x:Floats.float32):Floats.float32:=
 match value_statement S._FiveSqrtBits S._f S._u helper_types
 (PTree.set S._x(Vsingle x)(PTree.empty val))(fn_body S.f_five_sqrtf)with
 |Some(ValueReturn(Vsingle y)_ _)=>y|_=>Floats.Float32.zero end.
Print Assumptions actual_helper_certificate.
