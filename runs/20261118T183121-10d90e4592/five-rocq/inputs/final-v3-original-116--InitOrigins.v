From Stdlib Require Import List ZArith.
From compcert Require Import AST Integers Values Ctypes Ctypesdefs Cop Csyntax.
Require PprzTrigInit.Source.
From PprzTrigCBMC Require Import ProducerSteps SourceOccurrence NibbleGuards EncoderGuards.
Import ListNotations.
Local Open Scope Z_scope.
Definition scalar_add_node(a:expr):bool:=match a with Ebinop Oadd _ _(Tint I32 Signed _)=>true|_=>false end.
Definition mul_node(a:expr):bool:=match a with Ebinop Omul _ _ _=>true|_=>false end.
Definition shl_node(a:expr):bool:=match a with Ebinop Oshl _ _ _=>true|_=>false end.
Definition shr_node(a:expr):bool:=match a with Ebinop Oshr _ _ _=>true|_=>false end.
Definition init_read(id:ident):expr:=Evalof(Evar id tshort)tshort.
Definition init_single_limit:=Ebinop Oadd(Ebinop Odiv(init_read PprzTrigInit.Source._temp)(lit 5)tint)(lit 1)tint.
Definition init_nine:=Ebinop Omul(lit 3)(lit 3)tint.
Definition init_ten:=Ebinop Oadd init_nine(lit 1)tint.
Definition init_multi_limit:=Ebinop Oadd(init_read PprzTrigInit.Source._k)init_ten tint.
Definition init_shift:=Ebinop Oshl(Ebinop Oand(init_read PprzTrigInit.Source._temp)(lit 8)tint)(lit 1)tint.
Definition init_nodes:=statement_nodes(fn_body PprzTrigInit.Source.f_pprz_trig_int_init).
Lemma initializer_explicit_add_origins:filter scalar_add_node init_nodes=[init_single_limit;init_multi_limit;init_ten].
Proof. reflexivity. Qed.
Lemma initializer_shift_origins:filter shl_node init_nodes=[init_shift].
Proof. reflexivity. Qed.
Lemma initializer_multiply_origins:filter mul_node init_nodes=[init_nine].
Proof. reflexivity. Qed.
Lemma nibble_multiply_origins:filter mul_node(statement_nodes(fn_body PprzTrigInit.Source.f_get_nibble))=[nibble_shift_expression].
Proof. reflexivity. Qed.
Lemma nibble_right_shift_origins:filter shr_node(statement_nodes(fn_body PprzTrigInit.Source.f_get_nibble))=
 [Ebinop Oshr nibble_byte_expression nibble_shift_expression tint].
Proof. reflexivity. Qed.
Lemma encoder_add_origins:filter scalar_add_node(statement_nodes(fn_body PprzTrigInit.Source.f_table_encode_12))=
 [encoder_high_expression;encoder_high_expression].
Proof. reflexivity. Qed.
