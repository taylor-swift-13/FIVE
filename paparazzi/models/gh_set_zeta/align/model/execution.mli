
type __ = Obj.t

val xorb : bool -> bool -> bool

val negb : bool -> bool

type nat =
| O
| S of nat

val fst : ('a1 * 'a2) -> 'a1

val snd : ('a1 * 'a2) -> 'a2

val length : 'a1 list -> nat

val app : 'a1 list -> 'a1 list -> 'a1 list

type comparison =
| Eq
| Lt
| Gt

val compOpp : comparison -> comparison

type 'a sig0 = 'a
  (* singleton inductive, whose constructor was exist *)



val add : nat -> nat -> nat

val max : nat -> nat -> nat

type decidable =
  bool
  (* singleton inductive, whose constructor was Build_Decidable *)

val decide : decidable -> bool

val bool_dec : bool -> bool -> bool

val eqb : bool -> bool -> bool

type positive =
| XI of positive
| XO of positive
| XH

type n =
| N0
| Npos of positive

type z =
| Z0
| Zpos of positive
| Zneg of positive

module Nat :
 sig
  val eqb : nat -> nat -> bool
 end

module Pos :
 sig
  val succ : positive -> positive

  val add : positive -> positive -> positive

  val add_carry : positive -> positive -> positive

  val pred_double : positive -> positive

  val pred_N : positive -> n

  type mask =
  | IsNul
  | IsPos of positive
  | IsNeg

  val succ_double_mask : mask -> mask

  val double_mask : mask -> mask

  val double_pred_mask : positive -> mask

  val sub_mask : positive -> positive -> mask

  val sub_mask_carry : positive -> positive -> mask

  val mul : positive -> positive -> positive

  val iter : ('a1 -> 'a1) -> 'a1 -> positive -> 'a1

  val div2 : positive -> positive

  val div2_up : positive -> positive

  val compare_cont : comparison -> positive -> positive -> comparison

  val compare : positive -> positive -> comparison

  val eqb : positive -> positive -> bool

  val leb : positive -> positive -> bool

  val sqrtrem_step :
    (positive -> positive) -> (positive -> positive) -> (positive * mask) ->
    positive * mask

  val sqrtrem : positive -> positive * mask

  val coq_Nsucc_double : n -> n

  val coq_Ndouble : n -> n

  val coq_lor : positive -> positive -> positive

  val coq_land : positive -> positive -> n

  val ldiff : positive -> positive -> n

  val coq_lxor : positive -> positive -> n

  val iter_op : ('a1 -> 'a1 -> 'a1) -> positive -> 'a1 -> 'a1

  val to_nat : positive -> nat

  val of_succ_nat : nat -> positive
 end

module Coq_Pos :
 sig
  val succ : positive -> positive

  val add : positive -> positive -> positive

  val add_carry : positive -> positive -> positive

  val pred_double : positive -> positive

  val pred_N : positive -> n

  val mul : positive -> positive -> positive

  val iter : ('a1 -> 'a1) -> 'a1 -> positive -> 'a1

  val div2 : positive -> positive

  val eqb : positive -> positive -> bool

  val coq_lor : positive -> positive -> positive

  val size : positive -> positive

  val shiftl_nat : positive -> nat -> positive

  val shiftr_nat : positive -> nat -> positive

  val testbit : positive -> n -> bool

  val eq_dec : positive -> positive -> bool
 end

module N :
 sig
  val succ_double : n -> n

  val double : n -> n

  val succ_pos : n -> positive

  val sub : n -> n -> n

  val compare : n -> n -> comparison

  val leb : n -> n -> bool

  val pos_div_eucl : positive -> n -> n * n

  val coq_lor : n -> n -> n

  val coq_land : n -> n -> n

  val ldiff : n -> n -> n

  val coq_lxor : n -> n -> n
 end

module Coq_N :
 sig
  val testbit : n -> n -> bool

  val eq_dec : n -> n -> bool
 end

val map : ('a1 -> 'a2) -> 'a1 list -> 'a2 list

val repeat : 'a1 -> nat -> 'a1 list

val in_dec : ('a1 -> 'a1 -> bool) -> 'a1 -> 'a1 list -> bool

val rev : 'a1 list -> 'a1 list

val list_eq_dec : ('a1 -> 'a1 -> bool) -> 'a1 list -> 'a1 list -> bool

val fold_left : ('a1 -> 'a2 -> 'a1) -> 'a2 list -> 'a1 -> 'a1

val string_dec : char list -> char list -> bool

module Z :
 sig
  val double : z -> z

  val succ_double : z -> z

  val pred_double : z -> z

  val pos_sub : positive -> positive -> z

  val add : z -> z -> z

  val opp : z -> z

  val sub : z -> z -> z

  val mul : z -> z -> z

  val compare : z -> z -> comparison

  val leb : z -> z -> bool

  val ltb : z -> z -> bool

  val eqb : z -> z -> bool

  val max : z -> z -> z

  val min : z -> z -> z

  val pos_div_eucl : positive -> z -> z * z

  val div_eucl : z -> z -> z * z

  val even : z -> bool

  val div2 : z -> z

  val sqrtrem : z -> z * z

  val shiftl : z -> z -> z
 end

module Coq_Z :
 sig
  val double : z -> z

  val succ_double : z -> z

  val pred_double : z -> z

  val pos_sub : positive -> positive -> z

  val add : z -> z -> z

  val opp : z -> z

  val sub : z -> z -> z

  val mul : z -> z -> z

  val pow_pos : z -> positive -> z

  val pow : z -> z -> z

  val compare : z -> z -> comparison

  val leb : z -> z -> bool

  val ltb : z -> z -> bool

  val eqb : z -> z -> bool

  val max : z -> z -> z

  val min : z -> z -> z

  val to_nat : z -> nat

  val of_nat : nat -> z

  val of_N : n -> z

  val to_pos : z -> positive

  val pos_div_eucl : positive -> z -> z * z

  val div_eucl : z -> z -> z * z

  val div : z -> z -> z

  val modulo : z -> z -> z

  val quotrem : z -> z -> z * z

  val quot : z -> z -> z

  val rem : z -> z -> z

  val even : z -> bool

  val div2 : z -> z

  val shiftl : z -> z -> z

  val shiftr : z -> z -> z

  val coq_lor : z -> z -> z

  val coq_land : z -> z -> z

  val coq_lxor : z -> z -> z

  val pred : z -> z

  val geb : z -> z -> bool

  val gtb : z -> z -> bool

  val iter : z -> ('a1 -> 'a1) -> 'a1 -> 'a1

  val odd : z -> bool

  val log2 : z -> z

  val testbit : z -> z -> bool

  val eq_dec : z -> z -> bool
 end

val z_lt_dec : z -> z -> bool

val z_le_dec : z -> z -> bool

val z_le_gt_dec : z -> z -> bool

val shift_nat : nat -> positive -> positive

val shift_pos : positive -> positive -> positive

val two_power_nat : nat -> z

val two_power_pos : positive -> z

val two_p : z -> z

val zdivide_dec : z -> z -> bool

val peq : positive -> positive -> bool

val zeq : z -> z -> bool

val zlt : z -> z -> bool

val zle : z -> z -> bool

val align : z -> z -> z

val floor : z -> z -> z

val option_map : ('a1 -> 'a2) -> 'a1 option -> 'a2 option

val list_norepet_dec : ('a1 -> 'a1 -> bool) -> 'a1 list -> bool

val proj_sumbool : bool -> bool

module PTree :
 sig
  type 'a tree' =
  | Node001 of 'a tree'
  | Node010 of 'a
  | Node011 of 'a * 'a tree'
  | Node100 of 'a tree'
  | Node101 of 'a tree' * 'a tree'
  | Node110 of 'a tree' * 'a
  | Node111 of 'a tree' * 'a * 'a tree'

  type 'a tree =
  | Empty
  | Nodes of 'a tree'

  type 'a t = 'a tree

  val empty : 'a1 t

  val get' : positive -> 'a1 tree' -> 'a1 option

  val get : positive -> 'a1 tree -> 'a1 option

  val set0 : positive -> 'a1 -> 'a1 tree'

  val set' : positive -> 'a1 -> 'a1 tree' -> 'a1 tree'

  val set : positive -> 'a1 -> 'a1 tree -> 'a1 tree

  val prev_append : positive -> positive -> positive

  val prev : positive -> positive

  val map1' : ('a1 -> 'a2) -> 'a1 tree' -> 'a2 tree'

  val map1 : ('a1 -> 'a2) -> 'a1 t -> 'a2 t

  val xelements' :
    'a1 tree' -> positive -> (positive * 'a1) list -> (positive * 'a1) list

  val elements : 'a1 t -> (positive * 'a1) list

  val fold' :
    ('a2 -> positive -> 'a1 -> 'a2) -> positive -> 'a1 tree' -> 'a2 -> 'a2

  val fold : ('a2 -> positive -> 'a1 -> 'a2) -> 'a1 t -> 'a2 -> 'a2
 end

module PMap :
 sig
  type 'a t = 'a * 'a PTree.t

  val init : 'a1 -> 'a1 * 'a1 PTree.t

  val get : positive -> 'a1 t -> 'a1

  val set : positive -> 'a1 -> 'a1 t -> 'a1 * 'a1 PTree.tree

  val map : ('a1 -> 'a2) -> 'a1 t -> 'a2 t
 end

module type INDEXED_TYPE =
 sig
  type t

  val index : t -> positive

  val eq : t -> t -> bool
 end

module IMap :
 functor (X:INDEXED_TYPE) ->
 sig
  type elt = X.t

  val elt_eq : X.t -> X.t -> bool

  type 'x t = 'x PMap.t

  val init : 'a1 -> 'a1 * 'a1 PTree.t

  val get : X.t -> 'a1 t -> 'a1

  val set : X.t -> 'a1 -> 'a1 t -> 'a1 * 'a1 PTree.tree

  val map : ('a1 -> 'a2) -> 'a1 t -> 'a2 t
 end

module ZIndexed :
 sig
  type t = z

  val index : z -> positive

  val eq : z -> z -> bool
 end

module ZMap :
 sig
  type elt = ZIndexed.t

  val elt_eq : ZIndexed.t -> ZIndexed.t -> bool

  type 'x t = 'x PMap.t

  val init : 'a1 -> 'a1 * 'a1 PTree.t

  val get : ZIndexed.t -> 'a1 t -> 'a1

  val set : ZIndexed.t -> 'a1 -> 'a1 t -> 'a1 * 'a1 PTree.tree

  val map : ('a1 -> 'a2) -> 'a1 t -> 'a2 t
 end

type errcode =
| MSG of char list
| CTX of positive
| POS of positive

type errmsg = errcode list

val msg : char list -> errmsg

type 'a res =
| OK of 'a
| Error of errmsg

val bind : 'a1 res -> ('a1 -> 'a2 res) -> 'a2 res

val p_mod_two_p : positive -> nat -> z

val zshiftin : bool -> z -> z

val zzero_ext : z -> z -> z

val zsign_ext : z -> z -> z

val z_one_bits : nat -> z -> z -> z list

val p_is_power2 : positive -> bool

val z_is_power2 : z -> z option

val zsize : z -> z

type spec_float =
| S754_zero of bool
| S754_infinity of bool
| S754_nan
| S754_finite of bool * positive * z

val emin : z -> z -> z

val fexp : z -> z -> z -> z

val digits2_pos : positive -> positive

val zdigits2 : z -> z

val iter_pos : ('a1 -> 'a1) -> positive -> 'a1 -> 'a1

type location =
| Loc_Exact
| Loc_Inexact of comparison

type shr_record = { shr_m : z; shr_r : bool; shr_s : bool }

val shr_1 : shr_record -> shr_record

val loc_of_shr_record : shr_record -> location

val shr_record_of_loc : z -> location -> shr_record

val shr : shr_record -> z -> z -> shr_record * z

val shr_fexp : z -> z -> z -> z -> location -> shr_record * z

val shl_align : positive -> z -> z -> positive * z

val sFcompare : spec_float -> spec_float -> comparison option

val cond_Zopp : bool -> z -> z

val new_location_even : z -> z -> location

val new_location_odd : z -> z -> location

val new_location : z -> z -> location

val sFdiv_core_binary : z -> z -> z -> z -> z -> z -> (z * z) * location

val sFsqrt_core_binary : z -> z -> z -> z -> (z * z) * location

type radix = z
  (* singleton inductive, whose constructor was Build_radix *)

val radix2 : radix

val iter_nat : ('a1 -> 'a1) -> nat -> 'a1 -> 'a1

val cond_incr : bool -> z -> z

val round_sign_DN : bool -> location -> bool

val round_sign_UP : bool -> location -> bool

val round_N : bool -> location -> bool

type binary_float =
| B754_zero of bool
| B754_infinity of bool
| B754_nan
| B754_finite of bool * positive * z

val sF2B : z -> z -> spec_float -> binary_float

val b2SF : z -> z -> binary_float -> spec_float

val bcompare : z -> z -> binary_float -> binary_float -> comparison option

type mode =
| Mode_NE
| Mode_ZR
| Mode_DN
| Mode_UP
| Mode_NA

val choice_mode : mode -> bool -> z -> location -> z

val overflow_to_inf : mode -> bool -> bool

val binary_overflow : z -> z -> mode -> bool -> spec_float

val binary_fit_aux : z -> z -> mode -> bool -> positive -> z -> spec_float

val binary_round_aux :
  z -> z -> mode -> bool -> z -> z -> location -> spec_float

val bmult : z -> z -> mode -> binary_float -> binary_float -> binary_float

val shl_align_fexp : z -> z -> positive -> z -> positive * z

val binary_round : z -> z -> mode -> bool -> positive -> z -> spec_float

val binary_normalize : z -> z -> mode -> z -> z -> bool -> binary_float

val fplus_naive : bool -> positive -> z -> bool -> positive -> z -> z -> z

val bplus : z -> z -> mode -> binary_float -> binary_float -> binary_float

val bminus : z -> z -> mode -> binary_float -> binary_float -> binary_float

val bdiv : z -> z -> mode -> binary_float -> binary_float -> binary_float

val bsqrt : z -> z -> mode -> binary_float -> binary_float

type full_float =
| F754_zero of bool
| F754_infinity of bool
| F754_nan of bool * positive
| F754_finite of bool * positive * z

type binary_float0 =
| B754_zero0 of bool
| B754_infinity0 of bool
| B754_nan0 of bool * positive
| B754_finite0 of bool * positive * z

val b2BSN : z -> z -> binary_float0 -> binary_float

val fF2B : z -> z -> full_float -> binary_float0

val bsign : z -> z -> binary_float0 -> bool

val get_nan_pl : z -> z -> binary_float0 -> positive

val build_nan : z -> z -> binary_float0 -> binary_float0

val bSN2B : z -> z -> binary_float0 -> binary_float -> binary_float0

val bSN2B' : z -> z -> binary_float -> binary_float0

val bopp :
  z -> z -> (binary_float0 -> binary_float0) -> binary_float0 -> binary_float0

val babs :
  z -> z -> (binary_float0 -> binary_float0) -> binary_float0 -> binary_float0

val bcompare0 : z -> z -> binary_float0 -> binary_float0 -> comparison option

val bmult0 :
  z -> z -> (binary_float0 -> binary_float0 -> binary_float0) -> mode ->
  binary_float0 -> binary_float0 -> binary_float0

val binary_normalize0 : z -> z -> mode -> z -> z -> bool -> binary_float0

val bplus0 :
  z -> z -> (binary_float0 -> binary_float0 -> binary_float0) -> mode ->
  binary_float0 -> binary_float0 -> binary_float0

val bminus0 :
  z -> z -> (binary_float0 -> binary_float0 -> binary_float0) -> mode ->
  binary_float0 -> binary_float0 -> binary_float0

val bdiv0 :
  z -> z -> (binary_float0 -> binary_float0 -> binary_float0) -> mode ->
  binary_float0 -> binary_float0 -> binary_float0

val bsqrt0 :
  z -> z -> (binary_float0 -> binary_float0) -> mode -> binary_float0 ->
  binary_float0

val join_bits : z -> z -> bool -> z -> z -> z

val split_bits : z -> z -> z -> (bool * z) * z

val bits_of_binary_float : z -> z -> binary_float0 -> z

val binary_float_of_bits_aux : z -> z -> z -> full_float

val binary_float_of_bits : z -> z -> z -> binary_float0

type binary32 = binary_float0

val b32_of_bits : z -> binary32

val bits_of_b32 : binary32 -> z

type binary64 = binary_float0

val b64_of_bits : z -> binary64

val bits_of_b64 : binary64 -> z

val ptr64 : bool

val big_endian : bool

val align_int64 : z

val align_float64 : z

val default_nan_64 : bool * positive

val default_nan_32 : bool * positive

val choose_nan_64 : (bool * positive) list -> bool * positive

val choose_nan_32 : (bool * positive) list -> bool * positive

val float_of_single_preserves_sNaN : bool

val float_conversion_default_nan : bool

type comparison0 =
| Ceq
| Cne
| Clt
| Cle
| Cgt
| Cge

module type WORDSIZE =
 sig
  val wordsize : nat
 end

module Make :
 functor (WS:WORDSIZE) ->
 sig
  val wordsize : nat

  val zwordsize : z

  val modulus : z

  val half_modulus : z

  val max_unsigned : z

  val max_signed : z

  val min_signed : z

  type int = z
    (* singleton inductive, whose constructor was mkint *)

  val intval : int -> z

  val coq_Z_mod_modulus : z -> z

  val unsigned : int -> z

  val signed : int -> z

  val repr : z -> int

  val zero : int

  val one : int

  val mone : int

  val iwordsize : int

  val eq_dec : int -> int -> bool

  val eq : int -> int -> bool

  val lt : int -> int -> bool

  val ltu : int -> int -> bool

  val neg : int -> int

  val add : int -> int -> int

  val sub : int -> int -> int

  val mul : int -> int -> int

  val divs : int -> int -> int

  val mods : int -> int -> int

  val divu : int -> int -> int

  val modu : int -> int -> int

  val coq_and : int -> int -> int

  val coq_or : int -> int -> int

  val xor : int -> int -> int

  val not : int -> int

  val shl : int -> int -> int

  val shru : int -> int -> int

  val shr : int -> int -> int

  val rol : int -> int -> int

  val ror : int -> int -> int

  val rolm : int -> int -> int -> int

  val shrx : int -> int -> int

  val mulhu : int -> int -> int

  val mulhs : int -> int -> int

  val negative : int -> int

  val add_carry : int -> int -> int -> int

  val add_overflow : int -> int -> int -> int

  val sub_borrow : int -> int -> int -> int

  val sub_overflow : int -> int -> int -> int

  val shr_carry : int -> int -> int

  val zero_ext : z -> int -> int

  val sign_ext : z -> int -> int

  val one_bits : int -> int list

  val is_power2 : int -> int option

  val cmp : comparison0 -> int -> int -> bool

  val cmpu : comparison0 -> int -> int -> bool

  val notbool : int -> int

  val divmodu2 : int -> int -> int -> (int * int) option

  val divmods2 : int -> int -> int -> (int * int) option

  val testbit : int -> z -> bool

  val int_of_one_bits : int list -> int

  val no_overlap : int -> z -> int -> z -> bool

  val size : int -> z

  val unsigned_bitfield_extract : z -> z -> int -> int

  val signed_bitfield_extract : z -> z -> int -> int

  val bitfield_insert : z -> z -> int -> int -> int
 end

module Wordsize_32 :
 sig
  val wordsize : nat
 end

module Int :
 sig
  val wordsize : nat

  val zwordsize : z

  val modulus : z

  val half_modulus : z

  val max_unsigned : z

  val max_signed : z

  val min_signed : z

  type int = z
    (* singleton inductive, whose constructor was mkint *)

  val intval : int -> z

  val coq_Z_mod_modulus : z -> z

  val unsigned : int -> z

  val signed : int -> z

  val repr : z -> int

  val zero : int

  val one : int

  val mone : int

  val iwordsize : int

  val eq_dec : int -> int -> bool

  val eq : int -> int -> bool

  val lt : int -> int -> bool

  val ltu : int -> int -> bool

  val neg : int -> int

  val add : int -> int -> int

  val sub : int -> int -> int

  val mul : int -> int -> int

  val divs : int -> int -> int

  val mods : int -> int -> int

  val divu : int -> int -> int

  val modu : int -> int -> int

  val coq_and : int -> int -> int

  val coq_or : int -> int -> int

  val xor : int -> int -> int

  val not : int -> int

  val shl : int -> int -> int

  val shru : int -> int -> int

  val shr : int -> int -> int

  val rol : int -> int -> int

  val ror : int -> int -> int

  val rolm : int -> int -> int -> int

  val shrx : int -> int -> int

  val mulhu : int -> int -> int

  val mulhs : int -> int -> int

  val negative : int -> int

  val add_carry : int -> int -> int -> int

  val add_overflow : int -> int -> int -> int

  val sub_borrow : int -> int -> int -> int

  val sub_overflow : int -> int -> int -> int

  val shr_carry : int -> int -> int

  val zero_ext : z -> int -> int

  val sign_ext : z -> int -> int

  val one_bits : int -> int list

  val is_power2 : int -> int option

  val cmp : comparison0 -> int -> int -> bool

  val cmpu : comparison0 -> int -> int -> bool

  val notbool : int -> int

  val divmodu2 : int -> int -> int -> (int * int) option

  val divmods2 : int -> int -> int -> (int * int) option

  val testbit : int -> z -> bool

  val int_of_one_bits : int list -> int

  val no_overlap : int -> z -> int -> z -> bool

  val size : int -> z

  val unsigned_bitfield_extract : z -> z -> int -> int

  val signed_bitfield_extract : z -> z -> int -> int

  val bitfield_insert : z -> z -> int -> int -> int
 end

module Wordsize_8 :
 sig
  val wordsize : nat
 end

module Byte :
 sig
  val wordsize : nat

  val zwordsize : z

  val modulus : z

  val half_modulus : z

  val max_unsigned : z

  val max_signed : z

  val min_signed : z

  type int = z
    (* singleton inductive, whose constructor was mkint *)

  val intval : int -> z

  val coq_Z_mod_modulus : z -> z

  val unsigned : int -> z

  val signed : int -> z

  val repr : z -> int

  val zero : int

  val one : int

  val mone : int

  val iwordsize : int

  val eq_dec : int -> int -> bool

  val eq : int -> int -> bool

  val lt : int -> int -> bool

  val ltu : int -> int -> bool

  val neg : int -> int

  val add : int -> int -> int

  val sub : int -> int -> int

  val mul : int -> int -> int

  val divs : int -> int -> int

  val mods : int -> int -> int

  val divu : int -> int -> int

  val modu : int -> int -> int

  val coq_and : int -> int -> int

  val coq_or : int -> int -> int

  val xor : int -> int -> int

  val not : int -> int

  val shl : int -> int -> int

  val shru : int -> int -> int

  val shr : int -> int -> int

  val rol : int -> int -> int

  val ror : int -> int -> int

  val rolm : int -> int -> int -> int

  val shrx : int -> int -> int

  val mulhu : int -> int -> int

  val mulhs : int -> int -> int

  val negative : int -> int

  val add_carry : int -> int -> int -> int

  val add_overflow : int -> int -> int -> int

  val sub_borrow : int -> int -> int -> int

  val sub_overflow : int -> int -> int -> int

  val shr_carry : int -> int -> int

  val zero_ext : z -> int -> int

  val sign_ext : z -> int -> int

  val one_bits : int -> int list

  val is_power2 : int -> int option

  val cmp : comparison0 -> int -> int -> bool

  val cmpu : comparison0 -> int -> int -> bool

  val notbool : int -> int

  val divmodu2 : int -> int -> int -> (int * int) option

  val divmods2 : int -> int -> int -> (int * int) option

  val testbit : int -> z -> bool

  val int_of_one_bits : int list -> int

  val no_overlap : int -> z -> int -> z -> bool

  val size : int -> z

  val unsigned_bitfield_extract : z -> z -> int -> int

  val signed_bitfield_extract : z -> z -> int -> int

  val bitfield_insert : z -> z -> int -> int -> int
 end

module Wordsize_64 :
 sig
  val wordsize : nat
 end

module Int64 :
 sig
  val wordsize : nat

  val zwordsize : z

  val modulus : z

  val half_modulus : z

  val max_unsigned : z

  val max_signed : z

  val min_signed : z

  type int = z
    (* singleton inductive, whose constructor was mkint *)

  val intval : int -> z

  val coq_Z_mod_modulus : z -> z

  val unsigned : int -> z

  val signed : int -> z

  val repr : z -> int

  val zero : int

  val mone : int

  val iwordsize : int

  val eq_dec : int -> int -> bool

  val eq : int -> int -> bool

  val lt : int -> int -> bool

  val ltu : int -> int -> bool

  val neg : int -> int

  val add : int -> int -> int

  val sub : int -> int -> int

  val mul : int -> int -> int

  val divs : int -> int -> int

  val mods : int -> int -> int

  val divu : int -> int -> int

  val modu : int -> int -> int

  val coq_and : int -> int -> int

  val coq_or : int -> int -> int

  val xor : int -> int -> int

  val not : int -> int

  val shl : int -> int -> int

  val shru : int -> int -> int

  val shr : int -> int -> int

  val mulhu : int -> int -> int

  val mulhs : int -> int -> int

  val cmp : comparison0 -> int -> int -> bool

  val cmpu : comparison0 -> int -> int -> bool

  val iwordsize' : Int.int

  val shl' : int -> Int.int -> int

  val shru' : int -> Int.int -> int

  val shr' : int -> Int.int -> int

  val loword : int -> Int.int

  val mul' : Int.int -> Int.int -> int
 end

module Wordsize_Ptrofs :
 sig
  val wordsize : nat
 end

module Ptrofs :
 sig
  val wordsize : nat

  val modulus : z

  val half_modulus : z

  val max_signed : z

  type int = z
    (* singleton inductive, whose constructor was mkint *)

  val intval : int -> z

  val coq_Z_mod_modulus : z -> z

  val unsigned : int -> z

  val signed : int -> z

  val repr : z -> int

  val zero : int

  val eq_dec : int -> int -> bool

  val eq : int -> int -> bool

  val ltu : int -> int -> bool

  val add : int -> int -> int

  val sub : int -> int -> int

  val mul : int -> int -> int

  val divs : int -> int -> int

  val cmpu : comparison0 -> int -> int -> bool

  val to_int : int -> Int.int

  val to_int64 : int -> Int64.int

  val of_int : Int.int -> int

  val of_intu : Int.int -> int

  val of_ints : Int.int -> int

  val of_int64 : Int64.int -> int
 end

val beq_dec : z -> z -> binary_float0 -> binary_float0 -> bool

val bofZ : z -> z -> z -> binary_float0

val zofB : z -> z -> binary_float0 -> z option

val zofB_range : z -> z -> binary_float0 -> z -> z -> z option

val bconv :
  z -> z -> z -> z -> (binary_float0 -> binary_float0) -> mode ->
  binary_float0 -> binary_float0

type float = binary64

type float32 = binary32

val cmp_of_comparison : comparison0 -> comparison option -> bool

val quiet_nan_64_payload : positive -> positive

val quiet_nan_64 : (bool * positive) -> float

val default_nan_0 : float

val quiet_nan_32_payload : positive -> positive

val quiet_nan_32 : (bool * positive) -> float32

val default_nan_1 : float32

module Float :
 sig
  val expand_nan_payload : positive -> positive

  val expand_nan : bool -> positive -> binary_float0

  val of_single_nan : float32 -> float

  val reduce_nan_payload : positive -> positive

  val to_single_nan : float -> float32

  val neg_nan : float -> float

  val abs_nan : float -> float

  val cons_pl : float -> (bool * positive) list -> (bool * positive) list

  val unop_nan : float -> float

  val binop_nan : float -> float -> float

  val zero : float

  val eq_dec : float -> float -> bool

  val neg : float -> float

  val abs : float -> float

  val sqrt : float -> float

  val add : float -> float -> float

  val sub : float -> float -> float

  val mul : float -> float -> float

  val div : float -> float -> float

  val compare : float -> float -> comparison option

  val cmp : comparison0 -> float -> float -> bool

  val of_single : float32 -> float

  val to_single : float -> float32

  val to_int : float -> Int.int option

  val to_intu : float -> Int.int option

  val to_long : float -> Int64.int option

  val to_longu : float -> Int64.int option

  val of_int : Int.int -> float

  val of_intu : Int.int -> float

  val of_long : Int64.int -> float

  val of_longu : Int64.int -> float

  val to_bits : float -> Int64.int

  val of_bits : Int64.int -> float
 end

module Float32 :
 sig
  val neg_nan : float32 -> float32

  val abs_nan : float32 -> float32

  val cons_pl : float32 -> (bool * positive) list -> (bool * positive) list

  val binop_nan : float32 -> float32 -> float32

  val zero : float32

  val eq_dec : float32 -> float32 -> bool

  val neg : float32 -> float32

  val abs : float32 -> float32

  val add : float32 -> float32 -> float32

  val sub : float32 -> float32 -> float32

  val mul : float32 -> float32 -> float32

  val div : float32 -> float32 -> float32

  val compare : float32 -> float32 -> comparison option

  val cmp : comparison0 -> float32 -> float32 -> bool

  val to_int : float32 -> Int.int option

  val to_intu : float32 -> Int.int option

  val to_long : float32 -> Int64.int option

  val to_longu : float32 -> Int64.int option

  val of_int : Int.int -> float32

  val of_intu : Int.int -> float32

  val of_long : Int64.int -> float32

  val of_longu : Int64.int -> float32

  val to_bits : float32 -> Int.int

  val of_bits : Int.int -> float32
 end

type ident = positive

val ident_eq : positive -> positive -> bool

type typ =
| Tint
| Tfloat
| Tlong
| Tsingle
| Tany32
| Tany64

val typ_eq : typ -> typ -> bool

val tptr : typ

type xtype =
| Xbool
| Xint8signed
| Xint8unsigned
| Xint16signed
| Xint16unsigned
| Xint
| Xfloat
| Xlong
| Xsingle
| Xptr
| Xany32
| Xany64
| Xvoid

val xtype_eq : xtype -> xtype -> bool

val inj_type : typ -> xtype

type calling_convention = { cc_vararg : z option; cc_unproto : bool;
                            cc_structret : bool }

val cc_default : calling_convention

val calling_convention_eq : calling_convention -> calling_convention -> bool

type signature = { sig_args : xtype list; sig_res : xtype;
                   sig_cc : calling_convention }

val signature_eq : signature -> signature -> bool

type memory_chunk =
| Mbool
| Mint8signed
| Mint8unsigned
| Mint16signed
| Mint16unsigned
| Mint32
| Mint64
| Mfloat32
| Mfloat64
| Many32
| Many64

val mptr : memory_chunk

val type_of_chunk : memory_chunk -> typ

type init_data =
| Init_int8 of Int.int
| Init_int16 of Int.int
| Init_int32 of Int.int
| Init_int64 of Int64.int
| Init_float32 of float32
| Init_float64 of float
| Init_space of z
| Init_addrof of ident * Ptrofs.int

type 'v globvar = { gvar_info : 'v; gvar_init : init_data list;
                    gvar_readonly : bool; gvar_volatile : bool }

type ('f, 'v) globdef =
| Gfun of 'f
| Gvar of 'v globvar

type ('f, 'v) program = { prog_defs : (ident * ('f, 'v) globdef) list;
                          prog_public : ident list; prog_main : ident }

type external_function =
| EF_external of char list * signature
| EF_builtin of char list * signature
| EF_runtime of char list * signature
| EF_vload of memory_chunk
| EF_vstore of memory_chunk
| EF_malloc
| EF_free
| EF_memcpy of z * z
| EF_annot of positive * char list * typ list
| EF_annot_val of positive * char list * typ
| EF_inline_asm of char list * signature * char list list
| EF_debug of positive * ident * typ list

type block = positive

val eq_block : positive -> positive -> bool

type val0 =
| Vundef
| Vint of Int.int
| Vlong of Int64.int
| Vfloat of float
| Vsingle of float32
| Vptr of block * Ptrofs.int

val vone : val0

val vtrue : val0

val vfalse : val0

val vptrofs : Ptrofs.int -> val0

module Val :
 sig
  val eq : val0 -> val0 -> bool

  val of_bool : bool -> val0

  val is_bool : val0 -> bool

  val norm_bool : val0 -> val0

  val addl : val0 -> val0 -> val0

  val subl : val0 -> val0 -> val0

  val mull' : val0 -> val0 -> val0

  val divls : val0 -> val0 -> val0 option

  val modls : val0 -> val0 -> val0 option

  val divlu : val0 -> val0 -> val0 option

  val modlu : val0 -> val0 -> val0 option

  val shll : val0 -> val0 -> val0

  val shrl : val0 -> val0 -> val0

  val shrlu : val0 -> val0 -> val0

  val cmp_different_blocks : comparison0 -> bool option

  val cmpu_bool :
    (block -> z -> bool) -> comparison0 -> val0 -> val0 -> bool option

  val cmplu_bool :
    (block -> z -> bool) -> comparison0 -> val0 -> val0 -> bool option

  val normalize : val0 -> typ -> val0

  val load_result : memory_chunk -> val0 -> val0
 end

val size_chunk : memory_chunk -> z

val size_chunk_nat : memory_chunk -> nat

val align_chunk : memory_chunk -> z

type quantity =
| Q32
| Q64

val quantity_eq : quantity -> quantity -> bool

val size_quantity_nat : quantity -> nat

type memval =
| Undef
| Byte of Byte.int
| Fragment of val0 * quantity * nat

val bytes_of_int : nat -> z -> Byte.int list

val int_of_bytes : Byte.int list -> z

val rev_if_be : Byte.int list -> Byte.int list

val encode_int : nat -> z -> Byte.int list

val decode_int : Byte.int list -> z

val inj_bytes : Byte.int list -> memval list

val proj_bytes : memval list -> Byte.int list option

val inj_value_rec : nat -> val0 -> quantity -> memval list

val inj_value : quantity -> val0 -> memval list

val check_value : nat -> val0 -> quantity -> memval list -> bool

val proj_value : quantity -> memval list -> val0

val encode_val : memory_chunk -> val0 -> memval list

val decode_val : memory_chunk -> memval list -> val0

type permission =
| Freeable
| Writable
| Readable
| Nonempty

type perm_kind =
| Max
| Cur

module Mem :
 sig
  type mem' = { mem_contents : memval ZMap.t PMap.t;
                mem_access : (z -> perm_kind -> permission option) PMap.t;
                nextblock : block }

  val mem_contents : mem' -> memval ZMap.t PMap.t

  val mem_access : mem' -> (z -> perm_kind -> permission option) PMap.t

  val nextblock : mem' -> block

  type mem = mem'

  val perm_order_dec : permission -> permission -> bool

  val perm_order'_dec : permission option -> permission -> bool

  val perm_dec : mem -> block -> z -> perm_kind -> permission -> bool

  val range_perm_dec :
    mem -> block -> z -> z -> perm_kind -> permission -> bool

  val valid_access_dec :
    mem -> memory_chunk -> block -> z -> permission -> bool

  val valid_pointer : mem -> block -> z -> bool

  val weak_valid_pointer : mem -> block -> z -> bool

  val alloc : mem -> z -> z -> mem' * block

  val unchecked_free : mem -> block -> z -> z -> mem

  val free : mem -> block -> z -> z -> mem option

  val free_list : mem -> ((block * z) * z) list -> mem option

  val getN : nat -> z -> memval ZMap.t -> memval list

  val load : memory_chunk -> mem -> block -> z -> val0 option

  val loadv : memory_chunk -> mem -> val0 -> val0 option

  val loadbytes : mem -> block -> z -> z -> memval list option

  val setN : memval list -> z -> memval ZMap.t -> memval ZMap.t

  val store : memory_chunk -> mem -> block -> z -> val0 -> mem option

  val storev : memory_chunk -> mem -> val0 -> val0 -> mem option

  val storebytes : mem -> block -> z -> memval list -> mem option
 end

module Senv :
 sig
  type t = { find_symbol : (ident -> block option);
             public_symbol : (ident -> bool);
             invert_symbol : (block -> ident option);
             block_is_volatile : (block -> bool); nextblock : block }
 end

module Genv :
 sig
  type ('f, 'v) t = { genv_public : ident list; genv_symb : block PTree.t;
                      genv_defs : ('f, 'v) globdef PTree.t; genv_next : 
                      block }

  val genv_public : ('a1, 'a2) t -> ident list

  val genv_symb : ('a1, 'a2) t -> block PTree.t

  val genv_defs : ('a1, 'a2) t -> ('a1, 'a2) globdef PTree.t

  val genv_next : ('a1, 'a2) t -> block

  val find_symbol : ('a1, 'a2) t -> ident -> block option

  val public_symbol : ('a1, 'a2) t -> ident -> bool

  val find_def : ('a1, 'a2) t -> block -> ('a1, 'a2) globdef option

  val find_funct_ptr : ('a1, 'a2) t -> block -> 'a1 option

  val find_funct : ('a1, 'a2) t -> val0 -> 'a1 option

  val invert_symbol : ('a1, 'a2) t -> block -> ident option

  val find_var_info : ('a1, 'a2) t -> block -> 'a2 globvar option

  val block_is_volatile : ('a1, 'a2) t -> block -> bool

  val add_global :
    ('a1, 'a2) t -> (ident * ('a1, 'a2) globdef) -> ('a1, 'a2) t

  val add_globals :
    ('a1, 'a2) t -> (ident * ('a1, 'a2) globdef) list -> ('a1, 'a2) t

  val empty_genv : ident list -> ('a1, 'a2) t

  val globalenv : ('a1, 'a2) program -> ('a1, 'a2) t

  val to_senv : ('a1, 'a2) t -> Senv.t
 end

type builtin_sem =
  val0 list -> val0 option
  (* singleton inductive, whose constructor was mkbuiltin *)

val mkbuiltin_v1t : xtype -> (val0 -> val0) -> builtin_sem

val mkbuiltin_v2t : xtype -> (val0 -> val0 -> val0) -> builtin_sem

val mkbuiltin_v1p : xtype -> (val0 -> val0 option) -> builtin_sem

val mkbuiltin_v2p : xtype -> (val0 -> val0 -> val0 option) -> builtin_sem

type valty = __

type valxty = __

val inj_num : xtype -> valxty -> val0

val proj_num : typ -> 'a1 -> val0 -> (valty -> 'a1) -> 'a1

val mkbuiltin_n1t : typ -> xtype -> (valty -> valxty) -> builtin_sem

val mkbuiltin_n2t :
  typ -> typ -> xtype -> (valty -> valty -> valxty) -> builtin_sem

val mkbuiltin_n1p : typ -> xtype -> (valty -> valxty option) -> builtin_sem

val lookup_builtin :
  ('a1 -> signature) -> char list -> signature -> (char list * 'a1) list ->
  'a1 option

type standard_builtin =
| BI_select of typ
| BI_fabs
| BI_fabsf
| BI_fsqrt
| BI_negl
| BI_addl
| BI_subl
| BI_mull
| BI_i16_bswap
| BI_i32_bswap
| BI_i64_bswap
| BI_unreachable
| BI_i64_umulh
| BI_i64_smulh
| BI_i64_sdiv
| BI_i64_udiv
| BI_i64_smod
| BI_i64_umod
| BI_i64_shl
| BI_i64_shr
| BI_i64_sar
| BI_i64_dtos
| BI_i64_dtou
| BI_i64_stod
| BI_i64_utod
| BI_i64_stof
| BI_i64_utof

val standard_builtin_table : (char list * standard_builtin) list

val standard_builtin_sig : standard_builtin -> signature

val standard_builtin_sem : standard_builtin -> builtin_sem

type platform_builtin =
| BI_fmin
| BI_fmax

val platform_builtin_table : (char list * platform_builtin) list

val platform_builtin_sig : platform_builtin -> signature

val platform_builtin_sem : platform_builtin -> builtin_sem

type builtin_function =
| BI_standard of standard_builtin
| BI_platform of platform_builtin

val builtin_function_sem : builtin_function -> builtin_sem

val lookup_builtin_function :
  char list -> signature -> builtin_function option

type eventval =
| EVint of Int.int
| EVlong of Int64.int
| EVfloat of float
| EVsingle of float32
| EVptr_global of ident * Ptrofs.int

type event =
| Event_syscall of char list * eventval list * eventval
| Event_vload of memory_chunk * ident * Ptrofs.int * eventval
| Event_vstore of memory_chunk * ident * Ptrofs.int * eventval
| Event_annot of char list * eventval list

type trace = event list

val e0 : trace

type world = __world Lazy.t
and __world =
| World of (char list -> eventval list -> (eventval * world) option)
   * (memory_chunk -> ident -> Ptrofs.int -> (eventval * world) option)
   * (memory_chunk -> ident -> Ptrofs.int -> eventval -> world option)

val nextworld_vload :
  world -> memory_chunk -> ident -> Ptrofs.int -> (eventval * world) option

val nextworld_vstore :
  world -> memory_chunk -> ident -> Ptrofs.int -> eventval -> world option

type signedness =
| Signed
| Unsigned

type intsize =
| I8
| I16
| I32
| IBool

type floatsize =
| F32
| F64

type attr = { attr_volatile : bool; attr_alignas : n option }

val noattr : attr

type type0 =
| Tvoid
| Tint0 of intsize * signedness * attr
| Tlong0 of signedness * attr
| Tfloat0 of floatsize * attr
| Tpointer of type0 * attr
| Tarray of type0 * z * attr
| Tfunction of type0 list * type0 * calling_convention
| Tstruct of ident * attr
| Tunion of ident * attr

val intsize_eq : intsize -> intsize -> bool

val signedness_eq : signedness -> signedness -> bool

val floatsize_eq : floatsize -> floatsize -> bool

val attr_eq : attr -> attr -> bool

val type_eq : type0 -> type0 -> bool

val attr_of_type : type0 -> attr

val change_attributes : (attr -> attr) -> type0 -> type0

val remove_attributes : type0 -> type0

val bitsize_intsize : intsize -> z

type struct_or_union =
| Struct
| Union

type member =
| Member_plain of ident * type0
| Member_bitfield of ident * intsize * signedness * attr * z * bool

type members = member list

type composite_definition =
| Composite of ident * struct_or_union * members * attr

val name_member : member -> ident

val type_member : member -> type0

val member_is_padding : member -> bool

type composite = { co_su : struct_or_union; co_members : members;
                   co_attr : attr; co_sizeof : z; co_alignof : z;
                   co_rank : nat }

type composite_env = composite PTree.t

type bitfield =
| Full
| Bits of intsize * signedness * z * z

val type_int32s : type0

val type_bool : type0

val typeconv : type0 -> type0

val complete_type : composite_env -> type0 -> bool

val align_attr : attr -> z -> z

val alignof : composite_env -> type0 -> z

val sizeof : composite_env -> type0 -> z

val bitalignof : composite_env -> type0 -> z

val bitsizeof : composite_env -> type0 -> z

val bitalignof_intsize : intsize -> z

val next_field : composite_env -> z -> member -> z

val layout_field : composite_env -> z -> member -> (z * bitfield) res

val alignof_composite : composite_env -> members -> z

val bitsizeof_struct : composite_env -> z -> members -> z

val bytes_of_bits : z -> z

val sizeof_struct : composite_env -> members -> z

val sizeof_union : composite_env -> members -> z

val field_offset_rec :
  composite_env -> ident -> members -> z -> (z * bitfield) res

val field_offset : composite_env -> ident -> members -> (z * bitfield) res

val union_field_offset :
  composite_env -> ident -> members -> (z * bitfield) res

type mode0 =
| By_value of memory_chunk
| By_reference
| By_copy
| By_nothing

val access_mode : type0 -> mode0

val type_is_volatile : type0 -> bool

val alignof_blockcopy : composite_env -> type0 -> z

val rank_type : composite_env -> type0 -> nat

val rank_members : composite_env -> members -> nat

val type_of_params : (ident * type0) list -> type0 list

val sizeof_composite : composite_env -> struct_or_union -> members -> z

val complete_members : composite_env -> members -> bool

val composite_of_def :
  composite_env -> ident -> struct_or_union -> members -> attr -> composite
  res

val add_composite_definitions :
  composite_env -> composite_definition list -> composite_env res

val build_composite_env : composite_definition list -> composite_env res

type 'f fundef =
| Internal of 'f
| External of external_function * type0 list * type0 * calling_convention

type 'f program0 = { prog_defs0 : (ident * ('f fundef, type0) globdef) list;
                     prog_public0 : ident list; prog_main0 : ident;
                     prog_types : composite_definition list;
                     prog_comp_env : composite_env }

val program_of_program : 'a1 program0 -> ('a1 fundef, type0) program

type unary_operation =
| Onotbool
| Onotint
| Oneg
| Oabsfloat

type binary_operation =
| Oadd
| Osub
| Omul
| Odiv
| Omod
| Oand
| Oor
| Oxor
| Oshl
| Oshr
| Oeq
| One
| Olt
| Ogt
| Ole
| Oge

type incr_or_decr =
| Incr
| Decr

type classify_cast_cases =
| Cast_case_pointer
| Cast_case_i2i of intsize * signedness
| Cast_case_f2f
| Cast_case_s2s
| Cast_case_f2s
| Cast_case_s2f
| Cast_case_i2f of signedness
| Cast_case_i2s of signedness
| Cast_case_f2i of intsize * signedness
| Cast_case_s2i of intsize * signedness
| Cast_case_l2l
| Cast_case_i2l of signedness
| Cast_case_l2i of intsize * signedness
| Cast_case_l2f of signedness
| Cast_case_l2s of signedness
| Cast_case_f2l of signedness
| Cast_case_s2l of signedness
| Cast_case_i2bool
| Cast_case_l2bool
| Cast_case_f2bool
| Cast_case_s2bool
| Cast_case_struct of ident * ident
| Cast_case_union of ident * ident
| Cast_case_void
| Cast_case_default

val classify_cast : type0 -> type0 -> classify_cast_cases

val cast_int_int : intsize -> signedness -> Int.int -> Int.int

val cast_int_float : signedness -> Int.int -> float

val cast_float_int : signedness -> float -> Int.int option

val cast_int_single : signedness -> Int.int -> float32

val cast_single_int : signedness -> float32 -> Int.int option

val cast_int_long : signedness -> Int.int -> Int64.int

val cast_long_float : signedness -> Int64.int -> float

val cast_long_single : signedness -> Int64.int -> float32

val cast_float_long : signedness -> float -> Int64.int option

val cast_single_long : signedness -> float32 -> Int64.int option

val sem_cast : val0 -> type0 -> type0 -> Mem.mem -> val0 option

type classify_bool_cases =
| Bool_case_i
| Bool_case_l
| Bool_case_f
| Bool_case_s
| Bool_default

val classify_bool : type0 -> classify_bool_cases

val bool_val : val0 -> type0 -> Mem.mem -> bool option

val sem_notbool : val0 -> type0 -> Mem.mem -> val0 option

type classify_neg_cases =
| Neg_case_i of signedness
| Neg_case_f
| Neg_case_s
| Neg_case_l of signedness
| Neg_default

val classify_neg : type0 -> classify_neg_cases

val sem_neg : val0 -> type0 -> val0 option

val sem_absfloat : val0 -> type0 -> val0 option

type classify_notint_cases =
| Notint_case_i of signedness
| Notint_case_l of signedness
| Notint_default

val classify_notint : type0 -> classify_notint_cases

val sem_notint : val0 -> type0 -> val0 option

type binarith_cases =
| Bin_case_i of signedness
| Bin_case_l of signedness
| Bin_case_f
| Bin_case_s
| Bin_default

val classify_binarith : type0 -> type0 -> binarith_cases

val binarith_type : binarith_cases -> type0

val sem_binarith :
  (signedness -> Int.int -> Int.int -> val0 option) -> (signedness ->
  Int64.int -> Int64.int -> val0 option) -> (float -> float -> val0 option)
  -> (float32 -> float32 -> val0 option) -> val0 -> type0 -> val0 -> type0 ->
  Mem.mem -> val0 option

type classify_add_cases =
| Add_case_pi of type0 * signedness
| Add_case_pl of type0
| Add_case_ip of signedness * type0
| Add_case_lp of type0
| Add_default

val classify_add : type0 -> type0 -> classify_add_cases

val ptrofs_of_int : signedness -> Int.int -> Ptrofs.int

val sem_add_ptr_int :
  composite_env -> type0 -> signedness -> val0 -> val0 -> val0 option

val sem_add_ptr_long : composite_env -> type0 -> val0 -> val0 -> val0 option

val sem_add :
  composite_env -> val0 -> type0 -> val0 -> type0 -> Mem.mem -> val0 option

type classify_sub_cases =
| Sub_case_pi of type0 * signedness
| Sub_case_pp of type0
| Sub_case_pl of type0
| Sub_default

val classify_sub : type0 -> type0 -> classify_sub_cases

val sem_sub :
  composite_env -> val0 -> type0 -> val0 -> type0 -> Mem.mem -> val0 option

val sem_mul : val0 -> type0 -> val0 -> type0 -> Mem.mem -> val0 option

val sem_div : val0 -> type0 -> val0 -> type0 -> Mem.mem -> val0 option

val sem_mod : val0 -> type0 -> val0 -> type0 -> Mem.mem -> val0 option

val sem_and : val0 -> type0 -> val0 -> type0 -> Mem.mem -> val0 option

val sem_or : val0 -> type0 -> val0 -> type0 -> Mem.mem -> val0 option

val sem_xor : val0 -> type0 -> val0 -> type0 -> Mem.mem -> val0 option

type classify_shift_cases =
| Shift_case_ii of signedness
| Shift_case_ll of signedness
| Shift_case_il of signedness
| Shift_case_li of signedness
| Shift_default

val classify_shift : type0 -> type0 -> classify_shift_cases

val sem_shift :
  (signedness -> Int.int -> Int.int -> Int.int) -> (signedness -> Int64.int
  -> Int64.int -> Int64.int) -> val0 -> type0 -> val0 -> type0 -> val0 option

val sem_shl : val0 -> type0 -> val0 -> type0 -> val0 option

val sem_shr : val0 -> type0 -> val0 -> type0 -> val0 option

type classify_cmp_cases =
| Cmp_case_pp
| Cmp_case_pi of signedness
| Cmp_case_ip of signedness
| Cmp_case_pl
| Cmp_case_lp
| Cmp_default

val classify_cmp : type0 -> type0 -> classify_cmp_cases

val cmp_ptr : Mem.mem -> comparison0 -> val0 -> val0 -> val0 option

val sem_cmp :
  comparison0 -> val0 -> type0 -> val0 -> type0 -> Mem.mem -> val0 option

type classify_fun_cases =
| Fun_case_f of type0 list * type0 * calling_convention
| Fun_default

val classify_fun : type0 -> classify_fun_cases

type classify_switch_cases =
| Switch_case_i
| Switch_case_l
| Switch_default

val classify_switch : type0 -> classify_switch_cases

val sem_switch_arg : val0 -> type0 -> z option

val sem_unary_operation :
  unary_operation -> val0 -> type0 -> Mem.mem -> val0 option

val sem_binary_operation :
  composite_env -> binary_operation -> val0 -> type0 -> val0 -> type0 ->
  Mem.mem -> val0 option

val incrdecr_type : type0 -> type0

val chunk_for_carrier : intsize -> memory_chunk

val bitsize_carrier : intsize -> z

val first_bit : intsize -> z -> z -> z

val bitfield_extract : intsize -> signedness -> z -> z -> Int.int -> Int.int

val bitfield_normalize : intsize -> signedness -> z -> Int.int -> Int.int

type expr =
| Eval of val0 * type0
| Evar of ident * type0
| Efield of expr * ident * type0
| Evalof of expr * type0
| Ederef of expr * type0
| Eaddrof of expr * type0
| Eunop of unary_operation * expr * type0
| Ebinop of binary_operation * expr * expr * type0
| Ecast of expr * type0
| Eseqand of expr * expr * type0
| Eseqor of expr * expr * type0
| Econdition of expr * expr * expr * type0
| Esizeof of type0 * type0
| Ealignof of type0 * type0
| Eassign of expr * expr * type0
| Eassignop of binary_operation * expr * expr * type0 * type0
| Epostincr of incr_or_decr * expr * type0
| Ecomma of expr * expr * type0
| Ecall of expr * exprlist * type0
| Ebuiltin of external_function * type0 list * exprlist * type0
| Eloc of block * Ptrofs.int * bitfield * type0
| Eparen of expr * type0 * type0
and exprlist =
| Enil
| Econs of expr * exprlist

val typeof : expr -> type0

type label = ident

type statement =
| Sskip
| Sdo of expr
| Ssequence of statement * statement
| Sifthenelse of expr * statement * statement
| Swhile of expr * statement
| Sdowhile of expr * statement
| Sfor of statement * expr * statement * statement
| Sbreak
| Scontinue
| Sreturn of expr option
| Sswitch of expr * labeled_statements
| Slabel of label * statement
| Sgoto of label
and labeled_statements =
| LSnil
| LScons of z option * statement * labeled_statements

type function0 = { fn_return : type0; fn_callconv : calling_convention;
                   fn_params : (ident * type0) list;
                   fn_vars : (ident * type0) list; fn_body : statement }

val var_names : (ident * type0) list -> ident list

type fundef0 = function0 fundef

val type_of_function : function0 -> type0

val type_of_fundef : fundef0 -> type0

type program1 = function0 program0

type genv = { genv_genv : (fundef0, type0) Genv.t; genv_cenv : composite_env }

val globalenv0 : program1 -> genv

type env = (block * type0) PTree.t

val empty_env : env

val block_of_binding : genv -> (ident * (block * type0)) -> (block * z) * z

val blocks_of_env : genv -> env -> ((block * z) * z) list

val select_switch_default : labeled_statements -> labeled_statements

val select_switch_case : z -> labeled_statements -> labeled_statements option

val select_switch : z -> labeled_statements -> labeled_statements

val seq_of_labeled_statement : labeled_statements -> statement

type kind =
| LV
| RV

type cont =
| Kstop
| Kdo of cont
| Kseq of statement * cont
| Kifthenelse of statement * statement * cont
| Kwhile1 of expr * statement * cont
| Kwhile2 of expr * statement * cont
| Kdowhile1 of expr * statement * cont
| Kdowhile2 of expr * statement * cont
| Kfor2 of expr * statement * statement * cont
| Kfor3 of expr * statement * statement * cont
| Kfor4 of expr * statement * statement * cont
| Kswitch1 of labeled_statements * cont
| Kswitch2 of cont
| Kreturn of cont
| Kcall of function0 * env * (expr -> expr) * type0 * cont

val call_cont : cont -> cont

type state =
| State of function0 * statement * cont * env * Mem.mem
| ExprState of function0 * expr * cont * env * Mem.mem
| Callstate of fundef0 * val0 list * cont * Mem.mem
| Returnstate of val0 * cont * Mem.mem
| Stuckstate

val find_label : label -> statement -> cont -> (statement * cont) option

val find_label_ls :
  label -> labeled_statements -> cont -> (statement * cont) option

val decidable_not : decidable -> decidable

val decidable_and : decidable -> decidable -> decidable

val decidable_or : decidable -> decidable -> decidable

val decidable_implies : decidable -> decidable -> decidable

val decidable_eq_positive : positive -> positive -> decidable

val decidable_eq_Z : z -> z -> decidable

val decidable_le_Z : z -> z -> decidable

val decidable_ge_Z : z -> z -> decidable

val decidable_gt_Z : z -> z -> decidable

val decidable_divides : z -> z -> decidable

val is_val : expr -> (val0 * type0) option

val is_loc : expr -> (((block * Ptrofs.int) * bitfield) * type0) option

val is_val_list : exprlist -> (val0 * type0) list option

val is_skip : statement -> bool

val eventval_of_val : genv -> val0 -> typ -> eventval option

val list_eventval_of_val :
  genv -> val0 list -> typ list -> eventval list option

val val_of_eventval : genv -> eventval -> typ -> val0 option

val do_volatile_load :
  genv -> world -> memory_chunk -> Mem.mem -> block -> Ptrofs.int ->
  ((world * trace) * val0) option

val do_volatile_store :
  genv -> world -> memory_chunk -> Mem.mem -> block -> Ptrofs.int -> val0 ->
  (((world * trace) * Mem.mem) * val0) option

val do_deref_loc :
  genv -> world -> type0 -> Mem.mem -> block -> Ptrofs.int -> bitfield ->
  ((world * trace) * val0) option

val check_assign_copy :
  genv -> type0 -> block -> Ptrofs.int -> block -> Ptrofs.int -> bool

val do_assign_loc :
  genv -> world -> type0 -> Mem.mem -> block -> Ptrofs.int -> bitfield ->
  val0 -> (((world * trace) * Mem.mem) * val0) option

val do_ef_volatile_load :
  genv -> memory_chunk -> world -> val0 list -> Mem.mem ->
  (((world * trace) * val0) * Mem.mem) option

val do_ef_volatile_store :
  genv -> memory_chunk -> world -> val0 list -> Mem.mem ->
  (((world * trace) * val0) * Mem.mem) option

val do_alloc_size : val0 -> Ptrofs.int option

val do_ef_malloc :
  world -> val0 list -> Mem.mem -> (((world * trace) * val0) * Mem.mem) option

val do_ef_free :
  world -> val0 list -> Mem.mem -> (((world * trace) * val0) * Mem.mem) option

val do_ef_memcpy :
  z -> z -> world -> val0 list -> Mem.mem ->
  (((world * trace) * val0) * Mem.mem) option

val do_ef_annot :
  genv -> char list -> typ list -> world -> val0 list -> Mem.mem ->
  (((world * trace) * val0) * Mem.mem) option

val do_ef_annot_val :
  genv -> char list -> typ -> world -> val0 list -> Mem.mem ->
  (((world * trace) * val0) * Mem.mem) option

val do_ef_debug :
  positive -> ident -> typ list -> world -> val0 list -> Mem.mem ->
  (((world * trace) * val0) * Mem.mem) option

val do_builtin_or_external :
  genv -> (char list -> signature -> Senv.t -> world -> val0 list -> Mem.mem
  -> (((world * trace) * val0) * Mem.mem) option) -> char list -> signature
  -> world -> val0 list -> Mem.mem -> (((world * trace) * val0) * Mem.mem)
  option

val do_external :
  genv -> (char list -> signature -> Senv.t -> world -> val0 list -> Mem.mem
  -> (((world * trace) * val0) * Mem.mem) option) -> (char list -> signature
  -> Senv.t -> world -> val0 list -> Mem.mem ->
  (((world * trace) * val0) * Mem.mem) option) -> external_function -> world
  -> val0 list -> Mem.mem -> (((world * trace) * val0) * Mem.mem) option

type reduction =
| Lred of char list * expr * Mem.mem
| Rred of char list * expr * Mem.mem * trace
| Callred of char list * fundef0 * val0 list * type0 * Mem.mem
| Stuckred

val sem_cast_arguments :
  (val0 * type0) list -> type0 list -> Mem.mem -> val0 list option

type 'a reducts = ((expr -> 'a) * reduction) list

val topred : reduction -> expr reducts

val stuck : expr reducts

val incontext : ('a1 -> 'a2) -> 'a1 reducts -> 'a2 reducts

val incontext2 :
  ('a1 -> 'a3) -> 'a1 reducts -> ('a2 -> 'a3) -> 'a2 reducts -> 'a3 reducts

val step_expr :
  genv -> (char list -> signature -> Senv.t -> world -> val0 list -> Mem.mem
  -> (((world * trace) * val0) * Mem.mem) option) -> (char list -> signature
  -> Senv.t -> world -> val0 list -> Mem.mem ->
  (((world * trace) * val0) * Mem.mem) option) -> env -> world -> kind ->
  expr -> Mem.mem -> expr reducts

val do_alloc_variables :
  genv -> env -> Mem.mem -> (ident * type0) list -> env * Mem.mem

val sem_bind_parameters :
  genv -> world -> env -> Mem.mem -> (ident * type0) list -> val0 list ->
  Mem.mem option

type transition =
| TR of char list * trace * state

val expr_final_state :
  function0 -> cont -> env -> ((expr -> expr) * reduction) -> transition

val ret : char list -> state -> transition list

val do_step :
  genv -> (char list -> signature -> Senv.t -> world -> val0 list -> Mem.mem
  -> (((world * trace) * val0) * Mem.mem) option) -> (char list -> signature
  -> Senv.t -> world -> val0 list -> Mem.mem ->
  (((world * trace) * val0) * Mem.mem) option) -> world -> state ->
  transition list

val tvoid : type0

val tschar : type0

val tushort : type0

val tint : type0

val tuint : type0

val tbool : type0

val tlong : type0

val tulong : type0

val tfloat : type0

val tdouble : type0

val tptr0 : type0 -> type0

val build_composite_env' : composite_definition list -> composite_env

val mkprogram :
  composite_definition list -> (ident * (fundef0, type0) globdef) list ->
  ident list -> ident -> program1

val _FloatVect2 : ident

val _GuidanceHRef : ident

val _Int64Vect2 : ident

val ___builtin_ais_annot : ident

val ___builtin_annot : ident

val ___builtin_annot_intval : ident

val ___builtin_bswap : ident

val ___builtin_bswap16 : ident

val ___builtin_bswap32 : ident

val ___builtin_bswap64 : ident

val ___builtin_clz : ident

val ___builtin_clzl : ident

val ___builtin_clzll : ident

val ___builtin_ctz : ident

val ___builtin_ctzl : ident

val ___builtin_ctzll : ident

val ___builtin_debug : ident

val ___builtin_expect : ident

val ___builtin_fabs : ident

val ___builtin_fabsf : ident

val ___builtin_fmadd : ident

val ___builtin_fmax : ident

val ___builtin_fmin : ident

val ___builtin_fmsub : ident

val ___builtin_fnmadd : ident

val ___builtin_fnmsub : ident

val ___builtin_fsqrt : ident

val ___builtin_membar : ident

val ___builtin_memcpy_aligned : ident

val ___builtin_read16_reversed : ident

val ___builtin_read32_reversed : ident

val ___builtin_sel : ident

val ___builtin_sqrt : ident

val ___builtin_unreachable : ident

val ___builtin_va_arg : ident

val ___builtin_va_copy : ident

val ___builtin_va_end : ident

val ___builtin_va_start : ident

val ___builtin_write16_reversed : ident

val ___builtin_write32_reversed : ident

val ___compcert_i64_dtos : ident

val ___compcert_i64_dtou : ident

val ___compcert_i64_sar : ident

val ___compcert_i64_sdiv : ident

val ___compcert_i64_shl : ident

val ___compcert_i64_shr : ident

val ___compcert_i64_smod : ident

val ___compcert_i64_smulh : ident

val ___compcert_i64_stod : ident

val ___compcert_i64_stof : ident

val ___compcert_i64_udiv : ident

val ___compcert_i64_umod : ident

val ___compcert_i64_umulh : ident

val ___compcert_i64_utod : ident

val ___compcert_i64_utof : ident

val ___compcert_va_composite : ident

val ___compcert_va_float64 : ident

val ___compcert_va_int32 : ident

val ___compcert_va_int64 : ident

val _accel : ident

val _dt : ident

val _gh_ref : ident

val _gh_set_zeta : ident

val _inv_tau : ident

val _main : ident

val _max_speed : ident

val _omega : ident

val _omega_2 : ident

val _pos : ident

val _speed : ident

val _tau : ident

val _x : ident

val _y : ident

val _zeta : ident

val _zeta_omega : ident

val v_gh_ref : type0 globvar

val f_gh_set_zeta : function0

val composites : composite_definition list

val global_definitions : (ident * (fundef0, type0) globdef) list

val public_idents : ident list

val prog : program1

val ge : genv

val entry : val0 list -> Mem.mem -> state

type callback =
  char list -> signature -> Senv.t -> world -> val0 list -> Mem.mem ->
  (((world * trace) * val0) * Mem.mem) option

val transitions : callback -> callback -> world -> state -> transition list

val no_external : callback

val quiet_world : world

val closed_transitions : state -> transition list
