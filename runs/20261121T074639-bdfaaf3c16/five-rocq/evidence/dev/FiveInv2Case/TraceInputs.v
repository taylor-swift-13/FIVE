From Stdlib Require Import List ZArith.
From compcert Require Import Integers Floats Values.
From FiveInv2Case Require Import Contract.
Import ListNotations.
Local Open Scope Z_scope.
Definition trace_input_words:list Z := [4272023241;1066696119;15406124;1877109524].
Definition trace_input(i:Z):float32:=Float32.of_bits(Int.repr(nth(Z.to_nat i)trace_input_words 0)).
Definition trace_output_words:list Z := [2147483648;0;0;0].
Definition initial_fixture(i:Z):float32:=Float32.of_bits(Int.repr(if Z.eq_dec i 0 then 1099431936 else if Z.eq_dec i 3 then 1099431936 else 0)).
Definition initial_guarded(_:Z):float32:=Float32.of_bits Int.zero.
Theorem original_arbitrary_trace_kernel:Result trace_input=Vint Int.zero /\Float32.to_bits(Det trace_input)=Int.repr 4286578688 /\
 map(fun i=>Float32.to_bits(Output trace_input i))[0;1;2;3]=map Int.repr trace_output_words.
Proof. vm_compute;repeat split;reflexivity. Qed.
Theorem original_initial_fixture_words:map(fun i=>Float32.to_bits(initial_fixture i))[0;1;2;3]=map Int.repr[1099431936;0;0;1099431936].
Proof. vm_compute;reflexivity. Qed.
Print Assumptions original_arbitrary_trace_kernel.
