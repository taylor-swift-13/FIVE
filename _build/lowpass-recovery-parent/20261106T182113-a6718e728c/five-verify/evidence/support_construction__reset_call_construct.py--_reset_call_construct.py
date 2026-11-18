from pathlib import Path
import json
R=Path('/home/yangfp/five'); S=R/'paparazzi/relations/lowpass_recovery/support'
(R/'_build/lowpass-recovery-parent/reset-extension-scope.json').write_text(json.dumps({
 'scope':'Extend the same measured five-rocq support-authoring session to reset without overlapping token windows',
 'model':'gpt-6.1-sol','reasoning_effort':'medium',
 'behavior':'Original reset Csyntax plus complete allocation/binding/free, arbitrary offset under writable12, all binary32 patterns, exact bytes/frame'},indent=2)+'\n')
old=(S/'ResetCall.v').read_text()
(R/'_build/lowpass-recovery-parent/ResetCall-zero-template.v').write_text(old)
start=old.index('Theorem reset_call_eval_zero:');end=old.index('Proof.',start)
old=old[:start]+r'''Theorem reset_call_summary:forall m b p value,
 writable12 m b p ->
 exists mf,
 state_eval Execution.ge(Execution.entry[Vptr b p;Vsingle value]m)=Some(Vsingle value,mf) /\
 writable12 mf b p /\
 Mem.loadbytes mf b(Ptrofs.unsigned p+4)8=Some(encode_val Mfloat32(Vsingle value)++encode_val Mfloat32(Vsingle value)) /\
 (forall q z n,Mem.valid_block m q ->
 q<>b \/ z+n<=Ptrofs.unsigned p+4 \/ Ptrofs.unsigned p+12<=z ->
 Mem.loadbytes mf q z n=Mem.loadbytes m q z n).
'''+old[end:]
old=old.replace('Memory Events','Memory Memdata Events').replace('ResetBody Straightline.','ResetBody Straightline LowpassMemory.')
old=old.replace(' intros m b value W4 W8.',r''' intros m b p value P.
 pose proof(field_access m b p 4 P ltac:(simpl;auto))as W4.
 pose proof(field_access m b p 8 P ltac:(simpl;auto))as W8.
 assert(OBJ:Mem.valid_block m b).
 { eapply Mem.valid_access_valid_block;eapply Mem.valid_access_implies;[exact W4|constructor]. }''')
old=old.replace('Vptr b Ptrofs.zero','Vptr b p')
old=old.replace('Mfloat32 b 4 Writable','Mfloat32 b(Ptrofs.unsigned p+4)Writable').replace('Mfloat32 b 8 Writable','Mfloat32 b(Ptrofs.unsigned p+8)Writable')
old=old.replace('Mfloat32 b 4(Vsingle value)','Mfloat32 b(Ptrofs.unsigned p+4)(Vsingle value)').replace('Mfloat32 b 8(Vsingle value)','Mfloat32 b(Ptrofs.unsigned p+8)(Vsingle value)')
old=old.replace(' assert(BODY:',r''' assert(PMA:writable12 ma b p).
 { destruct P as[AL[NW R]];repeat split;auto.
   intros z Q;pose proof(allocation_perm Execution.ge reset_declarations empty_env m b z Cur Writable(R z Q))as H;rewrite ALLOC in H;exact H. }
 assert(PMC:writable12 mc b p).
 { eapply store_preserves_writable12;[|exact SV];eapply store_preserves_writable12;[exact PMA|exact SP]. }
 assert(OUTENV:forall q,Mem.valid_block m q->forall id ty,e!id=Some(q,ty)->False).
 { intros q V id ty LOOK;destruct(ALL id ty(allocated_environment_origin Execution.ge reset_declarations m e ma AV id q ty LOOK))as(bx&LOOK'&F&Q);rewrite LOOK in LOOK';injection LOOK' as EQ;subst bx;exact(F V). }
 assert(BODY:''')
old=old.replace('as[mf[FREE REST]].','as[mf[FREE[KEEP ACCESS]]].').replace(' exists mf.',' exists mf;split.\n -')
old=old.replace('Print Assumptions reset_call_eval_zero.','Print Assumptions reset_call_summary.')
needle='rewrite BODY;cbn[cont_eval];rewrite FREE;reflexivity.';assert needle in old
old=old.replace(needle,needle+r'''
 - split.
   + pose proof(store_preserves_writable12 _ _ _ _ _ _ _ _ PMC S4)as PMD.
     pose proof(store_preserves_writable12 _ _ _ _ _ _ _ _ PMD S8)as PME.
     destruct PME as[AL[NW Q]];split;[exact AL|];split;[exact NW|].
     eapply range_perm_access_preserved_block;[|exact Q].
     intros ch ofs perm VA;apply(ACCESS ch b ofs perm(OUTENV b OBJ));exact VA.
   + split.
     * erewrite free_environment_bytes_frame by(exact FREE||exact(OUTENV b OBJ)).
       assert(L4:Mem.loadbytes me b(Ptrofs.unsigned p+4)4=Some(encode_val Mfloat32(Vsingle value))).
       { erewrite Mem.loadbytes_store_other by(exact S8||(cbn[size_chunk];lia));exact(Mem.loadbytes_store_same _ _ _ _ _ _ S4). }
       assert(L8:Mem.loadbytes me b(Ptrofs.unsigned p+8)4=Some(encode_val Mfloat32(Vsingle value)))by exact(Mem.loadbytes_store_same _ _ _ _ _ _ S8).
       replace 8 with(4+4)by lia;eapply Mem.loadbytes_concat;try exact L4;try lia.
       replace(Ptrofs.unsigned p+4+4)with(Ptrofs.unsigned p+8)by lia;exact L8.
     * intros q z n VB0 OUT.
       erewrite free_environment_bytes_frame by(exact FREE||exact(OUTENV q VB0)).
       erewrite Mem.loadbytes_store_other by(exact S8||(cbn[size_chunk];intuition lia)).
       erewrite Mem.loadbytes_store_other by(exact S4||(cbn[size_chunk];intuition lia)).
       erewrite Mem.loadbytes_store_other by(exact SV||(left;intro EQ;subst q;exact(FV VB0))).
       erewrite Mem.loadbytes_store_other by(exact SP||(left;intro EQ;subst q;exact(FP VB0))).
       pose proof(allocation_bytes_frame Execution.ge reset_declarations empty_env m q z n VB0)as H;rewrite ALLOC in H;exact H.''')
(S/'ResetCall.v').write_text(old)
print('Reset arbitrary-offset strong call summary constructed')
