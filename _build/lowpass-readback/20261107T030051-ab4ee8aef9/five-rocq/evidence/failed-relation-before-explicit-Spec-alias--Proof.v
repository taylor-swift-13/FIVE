From Stdlib Require Import List ZArith Lia.
From compcert Require Import Integers Floats AST Values Memory Memdata Csem Smallstep.
From FiveLowpassReadback Require Import Spec.
From FiveLowpassSupport Require Import LowpassMemory FieldBytes.
Require FiveLowpassResetFunctional.Proof FiveLowpassGetFunctional.Proof FiveLowpassGetCase.Contract.
Import ListNotations.
Local Open Scope Z_scope.
Lemma reset_establishes_readable:forall m b p value,
 writable12 m b p->
 Mem.loadbytes m b(Ptrofs.unsigned p+4)8=Some(encode_val Mfloat32(Vsingle value)++encode_val Mfloat32(Vsingle value))->
 FiveLowpassGetCase.Contract.ReadableOut m b p value.
Proof.
 intros m b p value P BYTES;destruct(encoded_two m b(Ptrofs.unsigned p+4)value value BYTES)as[L4 L8].
 replace(Ptrofs.unsigned p+4+4)with(Ptrofs.unsigned p+8)in L8 by lia.
 destruct P as[AL[NW RP]];repeat split;auto.
 apply encoded_load;[destruct AL as[k K];exists(k+2);lia|exact L8].
Qed.
Lemma observations:forall m mr mf b p,
 writable12 m b p->writable12 mr b p->
 (forall q z n,Mem.valid_block m q->q<>b \/z+n<=Ptrofs.unsigned p+4\/Ptrofs.unsigned p+12<=z->Mem.loadbytes mr q z n=Mem.loadbytes m q z n)->
 FiveLowpassGetCase.Contract.Frame mr mf->Spec.Observations m mr mf b p.
Proof.
 intros m mr mf b p P PR RESET GET.
 assert(VM:Mem.valid_block m b)by(eapply Mem.valid_access_valid_block;eapply Mem.valid_access_implies;[apply(field_access m b p 8 P ltac:(simpl;auto))|constructor]).
 assert(VR:Mem.valid_block mr b)by(eapply Mem.valid_access_valid_block;eapply Mem.valid_access_implies;[apply(field_access mr b p 8 PR ltac:(simpl;auto))|constructor]).
 assert(TC:Mem.loadbytes mr b(Ptrofs.unsigned p)4=Mem.loadbytes m b(Ptrofs.unsigned p)4)by(apply RESET;[exact VM|right;left;lia]).
 unfold Spec.Observations;split;[exact TC|]. split;[rewrite GET by exact VR;exact TC|]. split;assumption.
Qed.
Theorem normal_completion:Spec.NormalCompletion.
Proof.
 unfold Spec.NormalCompletion;intros m b p value P.
 destruct(FiveLowpassResetFunctional.Proof.normal_completion m b p value P)as[tr[mr[RESET[PR[BYTES FRAME]]]]].
 pose proof(reset_establishes_readable mr b p value PR BYTES)as R.
 destruct(FiveLowpassGetFunctional.Proof.normal_completion mr b p value R)as[tg[mf[GET[READ GF]]]].
 exists tr,mr,tg,mf;split;[exact RESET|]. split;[exact GET|].
 eapply observations;eauto.
Qed.
Theorem all_returns:Spec.AllReturns.
Proof.
 unfold Spec.AllReturns;intros m b p value P tr rr mr tg rg mf RESET GET.
 destruct(FiveLowpassResetFunctional.Proof.all_returns m b p value P tr rr mr RESET)as[RR[PR[BYTES FRAME]]].
 pose proof(reset_establishes_readable mr b p value PR BYTES)as R.
 destruct(FiveLowpassGetFunctional.Proof.all_returns mr b p value R tg rg mf GET)as[RG[READ GF]].
 subst rr rg;split;[reflexivity|]. split;[reflexivity|]. split;[reflexivity|]. split;[reflexivity|]. split;[reflexivity|].
 eapply observations;eauto.
Qed.
Print Assumptions normal_completion.
Print Assumptions all_returns.
