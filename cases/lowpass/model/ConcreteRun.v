From Stdlib Require Import List ZArith.
From compcert Require Import AST Integers Floats Values Memory Memdata Events Csem Cexec Smallstep.
From FiveCases.lowpass.model Require Import ExecutionModel.
Import ListNotations.
Local Open Scope Z_scope.

(* a0,a1,b0,b1,i0,i1,o0,o1, as exact binary32 bit patterns. *)
Definition initial_words : list Z :=
 [1056964608;1048576000;1048576000;1056964608;
  1073741824;3212836864;1065353216;3221225472].
Definition input_word : int := Int.repr 1082130432. (* 4.0f *)

Fixpoint store_words(m:mem)(b:block)(ofs:Z)(words:list Z):option mem :=
 match words with
 | []=>Some m
 | w::ws=>match Mem.store Mfloat32 m b ofs(Vsingle(Float32.of_bits(Int.repr w)))with
           |Some m'=>store_words m' b(ofs+4)ws|None=>None end
 end.
Definition initial_memory : option(block*mem) :=
 let '(m,b):=Mem.alloc Mem.empty 0 32 in
 match store_words m b 0 initial_words with Some m'=>Some(b,m')|None=>None end.

(* Follow one actual successor. Keep the full final Csem state and step count.
   The existing all-successor execution model itself is unchanged. *)
Fixpoint drive(fuel:nat)(s:Csem.state):nat*Csem.state :=
 match terminal_tree s with
 |Some _=>(O,s)
 |None=>match fuel with
   |O=>(O,s)
   |S n=>match transitions s with
     |[]=>(O,s)
     |TR rule t next::_=>let '(count,last):=drive n next in(S count,last)
     end
   end
 end.

Lemma chosen_successor_is_model_step : forall s rule t next rest,
 transitions s=TR rule t next::rest -> model_step tt s t next.
Proof. intros;unfold model_step;exists rule;rewrite H;simpl;auto. Qed.

Theorem drive_follows_actual_model : forall fuel s count last,
 drive fuel s=(count,last) -> exists t,star model_step tt s t last.
Proof.
 induction fuel as[|fuel IH];intros s count last RUN;cbn [drive] in RUN.
 - destruct(terminal_tree s);inversion RUN;subst;exists E0;constructor.
 - destruct(terminal_tree s)eqn:TERM.
   + inversion RUN;subst;exists E0;constructor.
   + destruct(transitions s)as[|[rule t next]rest]eqn:TS.
     * inversion RUN;subst;exists E0;constructor.
     * destruct(drive fuel next)as[n final]eqn:D;inversion RUN;subst.
       destruct(IH next n last D)as[u PATH].
       exists(t++u). eapply star_step.
       -- eapply chosen_successor_is_model_step;exact TS.
       -- exact PATH.
       -- reflexivity.
Qed.

Definition byte_number(c:memval):option Z :=
 match c with Byte b=>Some(Byte.unsigned b)|_=>None end.
Definition bytes32(m:mem)(b:block):list(option Z) :=
 match Mem.loadbytes m b 0 32 with Some bytes=>map byte_number bytes|None=>[]end.
Record observation := {
 status:Z; steps:Z; returned_bits:option Z;
 before_bytes:list(option Z); after_bytes:list(option Z)
}.
Definition observe(_:unit):observation :=
 match initial_memory with
 |None=>{|status:=4;steps:=0;returned_bits:=None;before_bytes:=[];after_bytes:=[]|}
 |Some(b,m)=>
   let '(count,last):=drive 1000(execution_entry_bits(Vptr b Ptrofs.zero)input_word m)in
   match last with
   |Returnstate(Vsingle f)Kstop mf=>
     {|status:=0;steps:=Z.of_nat count;returned_bits:=Some(Int.unsigned(Float32.to_bits f));
       before_bytes:=bytes32 m b;after_bytes:=bytes32 mf b|}
   |Stuckstate=>{|status:=1;steps:=Z.of_nat count;returned_bits:=None;before_bytes:=bytes32 m b;after_bytes:=[]|}
   |_=>{|status:=2;steps:=Z.of_nat count;returned_bits:=None;before_bytes:=bytes32 m b;after_bytes:=[]|}
   end
 end.
Print Assumptions chosen_successor_is_model_step.
Print Assumptions drive_follows_actual_model.
