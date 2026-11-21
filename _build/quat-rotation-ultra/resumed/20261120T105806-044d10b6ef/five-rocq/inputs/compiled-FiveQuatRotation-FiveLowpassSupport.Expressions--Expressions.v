From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Errors Maps Integers Floats AST Values Memory Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cexec.
From FiveGuidanceAllOrder Require Import PureDenotation AtomicDenotation.
Local Open Scope Z_scope.
Lemma float_variable:forall ge e m id bx x,
 e!id=Some(bx,tfloat)->Mem.load Mfloat32 m bx 0=Some(Vsingle x)->
 pure_rval ge e m(Evalof(Evar id tfloat)tfloat)=Some(Vsingle x).
Proof.
 intros;cbn[pure_rval pure_lval];rewrite H;rewrite ?dec_eq_true.
 cbv[Cexec.do_deref_loc tfloat noattr access_mode type_is_volatile attr_of_type attr_volatile Mem.loadv];
 rewrite ?Ptrofs.unsigned_zero;try rewrite zle_true by(change(4<=18446744073709551616);lia);rewrite H0;reflexivity.
Qed.
Lemma pointer_variable:forall ge e m id bx b p ty,
 e!id=Some(bx,tptr ty)->Mem.load Mptr m bx 0=Some(Vptr b p)->
 pure_rval ge e m(Evalof(Evar id(tptr ty))(tptr ty))=Some(Vptr b p).
Proof.
 intros;cbn[pure_rval pure_lval];rewrite H;rewrite ?dec_eq_true.
 cbv[Cexec.do_deref_loc tptr noattr access_mode type_is_volatile attr_of_type attr_volatile Mem.loadv];
 rewrite ?Ptrofs.unsigned_zero;try rewrite zle_true by(change(8<=18446744073709551616);lia);rewrite H0;reflexivity.
Qed.
Lemma struct_field:forall ge e m ptr sid fid b p delta co,
 pure_rval ge e m ptr=Some(Vptr b p)->
 (genv_cenv ge)!sid=Some co->field_offset ge fid(co_members co)=OK(delta,Full)->
 pure_lval ge e m(Efield(Evalof(Ederef ptr(Tstruct sid noattr))(Tstruct sid noattr))fid tfloat)=Some(b,Ptrofs.add p(Ptrofs.repr delta),Full).
Proof.
 intros;cbn[pure_lval pure_rval];rewrite ?dec_eq_true;cbn;fold(pure_rval ge e m ptr);rewrite H.
 cbv[Cexec.do_deref_loc access_mode];cbn;rewrite H0,H1;reflexivity.
Qed.
Lemma assign_float:forall ge e m l r b p x mf,
 typeof l=tfloat->typeof r=tfloat->
 pure_lval ge e m l=Some(b,p,Full)->pure_rval ge e m r=Some(Vsingle x)->
 Ptrofs.unsigned p+4<=Ptrofs.modulus->
 Mem.store Mfloat32 m b(Ptrofs.unsigned p)(Vsingle x)=Some mf->
 atomic_eval ge e m(Eassign l r tfloat)=Some(Vsingle x,mf).
Proof.
 intros ge e m l r b p x mf TL TR LL RR B ST.
 cbn[atomic_eval];rewrite TL,dec_eq_true,LL,RR.
 unfold commit;rewrite TR;cbv[sem_cast classify_cast Cexec.do_assign_loc tfloat noattr access_mode type_is_volatile attr_of_type attr_volatile Mem.storev].
 rewrite zle_true by exact B;rewrite ST;reflexivity.
Qed.
Print Assumptions assign_float.
