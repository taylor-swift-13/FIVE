From Stdlib Require Import List ZArith Lia.
From compcert Require Import Coqlib Errors Maps Integers Floats AST Values Memory Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cexec.
From FiveGuidanceAllOrder Require Import PureDenotation AtomicDenotation.
From FiveLowpassSupport Require Import Expressions.
From FivePidDf Require Import Source Execution.
From FivePidDfCase Require Import Contract PidMemory.
Local Open Scope Z_scope.
Definition pid_type:=tptr(Tstruct Source._PID_df noattr).
Definition pid_var:=Evalof(Evar Source._pid pid_type)pid_type.
Definition input_var:=Evalof(Evar Source._value tfloat)tfloat.
Definition array_field(id:ident)(n:Z):expr:=
 Efield(Evalof(Ederef pid_var(Tstruct Source._PID_df noattr))(Tstruct Source._PID_df noattr))id(tarray tfloat n).
Definition slot(id:ident)(n k:Z):expr:=
 Ederef(Ebinop Oadd(Evalof(array_field id n)(tarray tfloat n))(Eval(Vint(Int.repr k))tint)(tptr tfloat))tfloat.
Definition slotval(id:ident)(n k:Z):expr:=Evalof(slot id n k)tfloat.
Definition Slot(id:ident)(n k delta:Z):Prop:=
 (id=Source._u /\n=2 /\((k=0 /\delta=0)\/(k=1 /\delta=4))) \/
 (id=Source._e /\n=3 /\((k=0 /\delta=8)\/(k=1 /\delta=12)\/(k=2 /\delta=16))) \/
 (id=Source._g /\n=3 /\((k=0 /\delta=20)\/(k=1 /\delta=24)\/(k=2 /\delta=28))).
Lemma array_field_location:forall e m bp b p id n delta,
 e!Source._pid=Some(bp,pid_type)->Mem.load Mptr m bp 0=Some(Vptr b p)->
 (id=Source._u /\n=2 /\delta=0)\/(id=Source._e /\n=3 /\delta=8)\/(id=Source._g /\n=3 /\delta=20)->
 pure_lval Execution.ge e m(array_field id n)=Some(b,Ptrofs.add p(Ptrofs.repr delta),Full).
Proof.
 intros e m bp b p id n delta LP PF ID;unfold array_field.
 eapply struct_field.
 - unfold pid_var,pid_type;eapply pointer_variable;eauto.
 - reflexivity.
 - destruct ID as[[-> [-> ->]]|[[-> [-> ->]]|[-> [-> ->]]]];reflexivity.
Qed.
Lemma slot_location:forall e m bp b p id n k delta,
 e!Source._pid=Some(bp,pid_type)->Mem.load Mptr m bp 0=Some(Vptr b p)->Slot id n k delta->
 pure_lval Execution.ge e m(slot id n k)=Some(b,Ptrofs.add p(Ptrofs.repr delta),Full).
Proof.
 intros e m bp b p id n k delta LP PF ID.
 unfold slot;cbn[pure_lval pure_rval];rewrite ?dec_eq_true;fold(pure_lval Execution.ge e m(array_field id n)).
 unfold Slot in ID;destruct ID as[[-> [-> K]]|[[-> [-> K]]|[-> [-> K]]]].
 all: erewrite array_field_location by(eauto;unfold Source._u,Source._e,Source._g;auto 8).
 all: cbv[Cexec.do_deref_loc access_mode];cbn.
 all: repeat destruct K as[[-> ->]|K];try destruct K as[-> ->].
 all: try reflexivity.
 all: rewrite Ptrofs.add_assoc;reflexivity.
Qed.
Lemma slot_value:forall e m bp b p id n k delta x,
 writable32 m b p->e!Source._pid=Some(bp,pid_type)->Mem.load Mptr m bp 0=Some(Vptr b p)->Slot id n k delta->
 Mem.load Mfloat32 m b(Ptrofs.unsigned p+delta)=Some(Vsingle x)->
 pure_rval Execution.ge e m(slotval id n k)=Some(Vsingle x).
Proof.
 intros e m bp b p id n k delta x W LP PF ID LD.
 assert(D:In delta field_offsets).
 { unfold Slot in ID;unfold field_offsets;destruct ID as[[_[_ K]]|[[_[_ K]]|[_[_ K]]]];
 repeat destruct K as[[_ ->]|K];try destruct K as[_ ->];simpl;tauto. }
 change(match pure_lval Execution.ge e m(slot id n k)with Some(bx,ofs,bf)=>match Cexec.do_deref_loc Execution.ge PureDenotation.quiet_world tfloat m bx ofs bf with Some(_,_,v)=>Some v|None=>None end|None=>None end=Some(Vsingle x)).
 rewrite(slot_location e m bp b p id n k delta LP PF ID).
 cbv[Cexec.do_deref_loc tfloat noattr access_mode type_is_volatile attr_of_type attr_volatile Mem.loadv].
 rewrite(field_pointer m b p delta W D);rewrite zle_true by(destruct W as[_[NW _]];change(Ptrofs.unsigned p+32<=18446744073709551616)in NW;change(Ptrofs.unsigned p+delta+4<=18446744073709551616);unfold field_offsets in D;repeat destruct D as[<-|D];try contradiction;lia).
 rewrite LD;reflexivity.
Qed.
Print Assumptions slot_location.
Print Assumptions slot_value.
