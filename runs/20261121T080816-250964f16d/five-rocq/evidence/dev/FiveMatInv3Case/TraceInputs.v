From Stdlib Require Import List ZArith.
From compcert Require Import Integers Floats AST Values.
From FiveMatInv3Case Require Import Scalar.
Import ListNotations.
Local Open Scope Z_scope.
Definition arbitrary_words_0:list Z:=[3528688771;1493278778;2151094387;2151377975;2129459503;3901882368;4153000531;4286840832;7025870].
Definition arbitrary_0(i:Z):float32:=Float32.of_bits(Int.repr(nth(Z.to_nat i)arbitrary_words_0 0)).
Lemma arbitrary_rejects_0:Accept arbitrary_0=false.
Proof. vm_compute;reflexivity. Qed.
Definition arbitrary_words_1:list Z:=[3528688771;1493278778;2151094387;2151377975;2129459503;3901882368;4153000531;4286840832;7025870].
Definition arbitrary_1(i:Z):float32:=Float32.of_bits(Int.repr(nth(Z.to_nat i)arbitrary_words_1 0)).
Lemma arbitrary_rejects_1:Accept arbitrary_1=false.
Proof. vm_compute;reflexivity. Qed.
