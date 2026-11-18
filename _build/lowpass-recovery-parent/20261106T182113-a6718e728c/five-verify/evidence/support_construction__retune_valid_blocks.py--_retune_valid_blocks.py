from pathlib import Path
R=Path('/home/yangfp/five');p=R/'paparazzi/relations/lowpass_recovery/support/RetuneCall.v'
s=p.read_text()
header=s[s.index('Theorem retune_call_eval:'):s.index('Proof.',s.index('Theorem retune_call_eval:'))]
helper=r'''Lemma retune_free_list_valid_blocks:forall regions m mf,
 Mem.free_list m regions=Some mf->forall q,Mem.valid_block m q->Mem.valid_block mf q.
Proof.
 intros regions;induction regions as[|[[b lo]hi]regions IH];intros m mf F q V.
 - cbn[Mem.free_list]in F;injection F as<-;exact V.
 - cbn[Mem.free_list]in F;destruct(Mem.free m b lo hi)as[ma|]eqn:A;try discriminate.
   eapply IH;[exact F|];eapply Mem.valid_block_free_1;[exact A|exact V].
Qed.
'''
s=s.replace('Theorem retune_call_eval:',helper+'Theorem retune_call_summary:',1)
needle=' Mem.loadbytes mf q z n=Mem.loadbytes m q z n).'
assert needle in s
s=s.replace(needle,' Mem.loadbytes mf q z n=Mem.loadbytes m q z n) /\\\n (forall q,Mem.valid_block m q->Mem.valid_block mf q).',1)
s=s.replace('     * intros q z n VB OUT.','     * split.\n       { intros q z n VB OUT.',1)
needle='pose proof(allocation_bytes_frame Execution.ge retune_declarations empty_env m q z n VB)as H;rewrite ALLOC in H;exact H.'
assert needle in s
s=s.replace(needle,needle+r''' }
       { intros q VB.
         eapply retune_free_list_valid_blocks;[exact FREE|].
         eapply Mem.store_valid_block_1;[exact S0|].
         eapply Mem.store_valid_block_1;[exact SH|].
         eapply Mem.store_valid_block_1;[exact ST|].
         eapply Mem.store_valid_block_1;[exact SP|].
         pose proof(allocation_valid_block Execution.ge retune_declarations empty_env m q VB)as H;rewrite ALLOC in H;exact H. }''',1)
s=s.replace('Print Assumptions retune_call_eval.',r'''Print Assumptions retune_call_summary.
'''+header+r'''Proof.
 intros m b p tau h P.
 destruct(retune_call_summary m b p tau h P)as[mf[EV[W[BYTES[FRAME VALID]]]]].
 exists mf;split;[exact EV|];split;[exact W|];split;assumption.
Qed.
Print Assumptions retune_call_eval.''')
p.write_text(s)
print('retune_call_summary strengthened; retune_call_eval interface retained')
