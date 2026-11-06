From Stdlib Require Import Bool List ZArith Lia.
From compcert Require Import Coqlib Errors Maps Integers Floats AST Values Memory Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Cexec.
From FiveGhSetOmegaProof Require Import NormalCorrespondence.
Local Open Scope Z_scope.
Definition global_field (gid sid fid : ident) : expr :=
 Efield (Evalof (Evar gid (Tstruct sid noattr)) (Tstruct sid noattr)) fid tfloat.
Lemma global_field_location : forall (ge:genv) (e:env) (m:mem) gid sid fid b co offset,
 PTree.get gid e=None -> Genv.find_symbol ge gid=Some b ->
 PTree.get sid (genv_cenv ge)=Some co ->
 field_offset ge fid (co_members co)=OK(offset,Full) ->
 pure_lval ge e m (global_field gid sid fid)=Some(b,Ptrofs.repr offset,Full).
Proof.
 intros ge e m gid sid fid b co offset L G C F.
 unfold global_field; cbn [pure_lval pure_rval typeof].
 rewrite dec_eq_true,L,G.
 cbn [Cexec.do_deref_loc access_mode type_is_volatile].
 rewrite C,F. rewrite Ptrofs.add_zero_l; reflexivity.
Qed.
Lemma read_single_location : forall (ge:genv) (e:env) (m:mem) a b offset f,
 typeof a=tfloat -> pure_lval ge e m a=Some(b,Ptrofs.repr offset,Full) ->
 0<=offset -> offset+4<=Ptrofs.modulus ->
 Mem.load Mfloat32 m b offset=Some(Vsingle f) ->
 pure_rval ge e m (Evalof a tfloat)=Some(Vsingle f).
Proof.
 intros ge e m a b offset f TY LOC LO HI LD.
 change ((if type_eq tfloat (typeof a) then match pure_lval ge e m a with | Some (bl,ofs,bf) => match Cexec.do_deref_loc ge quiet_world tfloat m bl ofs bf with | Some (_,_,v) => Some v | None => None end | None => None end else None)=Some(Vsingle f)).
 rewrite TY,dec_eq_true,LOC.

 assert (D: Cexec.do_deref_loc ge quiet_world tfloat m b (Ptrofs.repr offset) Full=Some(quiet_world,E0,Vsingle f)).
 { apply Cexec.do_deref_loc_complete.
   - eapply deref_loc_value; [reflexivity|reflexivity|].
     unfold Mem.loadv. rewrite Ptrofs.unsigned_repr by (unfold Ptrofs.max_unsigned; lia).
     rewrite zle_true by exact HI. exact LD.
   - constructor. }
 rewrite D; reflexivity.
Qed.
Lemma assign_single_location : forall (ge:genv) (e:env) (m:mem) a r b offset f mf,
 typeof a=tfloat -> typeof r=tfloat ->
 pure_lval ge e m a=Some(b,Ptrofs.repr offset,Full) ->
 pure_rval ge e m r=Some(Vsingle f) ->
 0<=offset -> offset+4<=Ptrofs.modulus ->
 Mem.store Mfloat32 m b offset (Vsingle f)=Some mf ->
 stmt_eval ge e tfloat (Sdo(Eassign a r tfloat))m=Some(Nnormal,mf).
Proof.
 intros ge e m a r b offset f mf TA TR LOC RV LO HI ST.
 cbn [stmt_eval flat_eval]; rewrite TA,dec_eq_true,LOC,RV,TR.
 cbn [sem_cast classify_cast].

 assert (D: Cexec.do_assign_loc ge quiet_world tfloat m b (Ptrofs.repr offset) Full (Vsingle f)=Some(quiet_world,E0,mf,Vsingle f)).
 { apply Cexec.do_assign_loc_complete.
   - eapply assign_loc_value; [reflexivity|reflexivity|].
     unfold Mem.storev. rewrite Ptrofs.unsigned_repr by (unfold Ptrofs.max_unsigned; lia).
     rewrite zle_true by exact HI. exact ST.
   - constructor. }
 assert (CAST: sem_cast (Vsingle f) tfloat tfloat m=Some(Vsingle f)) by reflexivity.
 rewrite CAST,D; reflexivity.
Qed.
Lemma pure_single_mul : forall (ge:genv) (e:env) (m:mem) a b x y,
 typeof a=tfloat -> typeof b=tfloat ->
 pure_rval ge e m a=Some(Vsingle x) -> pure_rval ge e m b=Some(Vsingle y) ->
 pure_rval ge e m(Ebinop Omul a b tfloat)=Some(Vsingle(Float32.mul x y)).
Proof.
 intros ge e m a b x y TA TB A B.
 cbn [pure_rval]; rewrite A,B,TA,TB; reflexivity.
Qed.
Lemma pure_single_comparison : forall (ge:genv) (e:env) (m:mem) op cmp a b x y,
 op=Ogt /\ cmp=Cgt \/ op=Olt /\ cmp=Clt ->
 typeof a=tfloat -> typeof b=tfloat ->
 pure_rval ge e m a=Some(Vsingle x) -> pure_rval ge e m b=Some(Vsingle y) ->
 pure_rval ge e m(Ebinop op a b tint)=Some(Val.of_bool(Float32.cmp cmp x y)).
Proof.
 intros ge e m op cmp a b x y [[-> ->]|[-> ->]] TA TB A B;
 cbn [pure_rval]; rewrite A,B,TA,TB; reflexivity.
Qed.
Print Assumptions global_field_location.
Print Assumptions assign_single_location.
