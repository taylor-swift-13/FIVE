From Stdlib Require Import List ZArith.
From compcert Require Import AST Integers Floats Values Memory Memdata.
From FiveQuatRotationSupport Require Import Protocol.
Import ListNotations.
Local Open Scope Z_scope.
Definition fb(z:Z):float32:=Float32.of_bits(Int.repr z).
Definition words(a b c:Z):list memval:=encode_val Mint32(Vint(Int.repr a))++encode_val Mint32(Vint(Int.repr b))++encode_val Mint32(Vint(Int.repr c)).
Definition unit_q:list float32:=[fb 1065353216;fb 0;fb 0;fb 0].
Definition unit_v:list float32:=[fb 1065353216;fb 0;fb 0].
Definition trace_q:list float32:=[fb 3208096458;fb 3191717350;fb 2687829235;fb 268909329].
Definition trace_v:list float32:=[fb 1124089879;fb 1149239296;fb 2382364672].
Definition direct(q v:list float32):list memval:=DirectBytes(nth 0 q Float32.zero)(nth 1 q Float32.zero)(nth 2 q Float32.zero)(nth 3 q Float32.zero)(nth 0 v Float32.zero)(nth 1 v Float32.zero)(nth 2 v Float32.zero).
Definition matrix(q v:list float32):list memval:=MatrixPathBytes(nth 0 q Float32.zero)(nth 1 q Float32.zero)(nth 2 q Float32.zero)(nth 3 q Float32.zero)(nth 0 v Float32.zero)(nth 1 v Float32.zero)(nth 2 v Float32.zero).
Theorem unit_numerics:direct unit_q unit_v=words 1065353216 0 0 /\matrix unit_q unit_v=words 1065353214 0 0.
Proof. vm_compute;split;reflexivity. Qed.
Theorem trace_numerics:direct trace_q trace_v=words 1095327876 1106339776 3280478549 /\matrix trace_q trace_v=words 1095327877 1106339776 3280478549.
Proof. vm_compute;split;reflexivity. Qed.
Theorem unit_distinct:words 1065353216 0 0<>words 1065353214 0 0.
Proof. vm_compute;discriminate. Qed.
Theorem trace_distinct:words 1095327876 1106339776 3280478549<>words 1095327877 1106339776 3280478549.
Proof. vm_compute;discriminate. Qed.
Print Assumptions unit_numerics.
Print Assumptions trace_numerics.
