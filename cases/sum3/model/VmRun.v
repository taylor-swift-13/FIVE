From Stdlib Require Import List ZArith.
From compcert Require Import AST Integers Floats Values Memory Csem Cexec.
From FiveCases.sum3.model Require Import Execution.
Import ListNotations.
Local Open Scope Z_scope.
Definition args:list val := [Vsingle(Float32.of_bits(Int.repr 1266679808));
 Vsingle(Float32.of_bits(Int.repr 1065353216));
 Vsingle(Float32.of_bits(Int.repr 3414163456))].
Fixpoint drive(fuel:nat)(s:Csem.state):option Z :=
 match s with
 |Returnstate(Vsingle f)Kstop _=>Some(Int.unsigned(Float32.to_bits f))
 |_=>match fuel with
     |O=>None
     |S n=>match closed_transitions s with
       |TR _ _ next::_=>drive n next
       |[]=>None end
     end
 end.
Definition result := drive 100(entry args Mem.empty).
