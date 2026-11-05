
type __ = Obj.t
let __ = let rec f _ = Obj.repr f in Obj.repr f

(** val xorb : bool -> bool -> bool **)

let xorb b1 b2 =
  if b1 then if b2 then false else true else b2

(** val negb : bool -> bool **)

let negb = function
| true -> false
| false -> true

type nat =
| O
| S of nat

(** val fst : ('a1 * 'a2) -> 'a1 **)

let fst = function
| (x, _) -> x

(** val snd : ('a1 * 'a2) -> 'a2 **)

let snd = function
| (_, y) -> y

(** val length : 'a1 list -> nat **)

let rec length = function
| [] -> O
| _ :: l' -> S (length l')

(** val app : 'a1 list -> 'a1 list -> 'a1 list **)

let rec app l m =
  match l with
  | [] -> m
  | a :: l1 -> a :: (app l1 m)

type comparison =
| Eq
| Lt
| Gt

(** val compOpp : comparison -> comparison **)

let compOpp = function
| Eq -> Eq
| Lt -> Gt
| Gt -> Lt

type 'a sig0 = 'a
  (* singleton inductive, whose constructor was exist *)



module Coq__1 = struct
 (** val add : nat -> nat -> nat **)

 let rec add n0 m =
   match n0 with
   | O -> m
   | S p -> S (add p m)
end
include Coq__1

(** val max : nat -> nat -> nat **)

let rec max n0 m =
  match n0 with
  | O -> m
  | S n' -> (match m with
             | O -> n0
             | S m' -> S (max n' m'))

type decidable =
  bool
  (* singleton inductive, whose constructor was Build_Decidable *)

(** val decide : decidable -> bool **)

let decide h =
  h

(** val bool_dec : bool -> bool -> bool **)

let bool_dec b1 b2 =
  if b1 then if b2 then true else false else if b2 then false else true

(** val eqb : bool -> bool -> bool **)

let eqb b1 b2 =
  if b1 then b2 else if b2 then false else true

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

module Nat =
 struct
  (** val eqb : nat -> nat -> bool **)

  let rec eqb n0 m =
    match n0 with
    | O -> (match m with
            | O -> true
            | S _ -> false)
    | S n' -> (match m with
               | O -> false
               | S m' -> eqb n' m')
 end

module Pos =
 struct
  (** val succ : positive -> positive **)

  let rec succ = function
  | XI p -> XO (succ p)
  | XO p -> XI p
  | XH -> XO XH

  (** val add : positive -> positive -> positive **)

  let rec add x y =
    match x with
    | XI p ->
      (match y with
       | XI q -> XO (add_carry p q)
       | XO q -> XI (add p q)
       | XH -> XO (succ p))
    | XO p ->
      (match y with
       | XI q -> XI (add p q)
       | XO q -> XO (add p q)
       | XH -> XI p)
    | XH -> (match y with
             | XI q -> XO (succ q)
             | XO q -> XI q
             | XH -> XO XH)

  (** val add_carry : positive -> positive -> positive **)

  and add_carry x y =
    match x with
    | XI p ->
      (match y with
       | XI q -> XI (add_carry p q)
       | XO q -> XO (add_carry p q)
       | XH -> XI (succ p))
    | XO p ->
      (match y with
       | XI q -> XO (add_carry p q)
       | XO q -> XI (add p q)
       | XH -> XO (succ p))
    | XH ->
      (match y with
       | XI q -> XI (succ q)
       | XO q -> XO (succ q)
       | XH -> XI XH)

  (** val pred_double : positive -> positive **)

  let rec pred_double = function
  | XI p -> XI (XO p)
  | XO p -> XI (pred_double p)
  | XH -> XH

  (** val pred_N : positive -> n **)

  let pred_N = function
  | XI p -> Npos (XO p)
  | XO p -> Npos (pred_double p)
  | XH -> N0

  type mask =
  | IsNul
  | IsPos of positive
  | IsNeg

  (** val succ_double_mask : mask -> mask **)

  let succ_double_mask = function
  | IsNul -> IsPos XH
  | IsPos p -> IsPos (XI p)
  | IsNeg -> IsNeg

  (** val double_mask : mask -> mask **)

  let double_mask = function
  | IsPos p -> IsPos (XO p)
  | x0 -> x0

  (** val double_pred_mask : positive -> mask **)

  let double_pred_mask = function
  | XI p -> IsPos (XO (XO p))
  | XO p -> IsPos (XO (pred_double p))
  | XH -> IsNul

  (** val sub_mask : positive -> positive -> mask **)

  let rec sub_mask x y =
    match x with
    | XI p ->
      (match y with
       | XI q -> double_mask (sub_mask p q)
       | XO q -> succ_double_mask (sub_mask p q)
       | XH -> IsPos (XO p))
    | XO p ->
      (match y with
       | XI q -> succ_double_mask (sub_mask_carry p q)
       | XO q -> double_mask (sub_mask p q)
       | XH -> IsPos (pred_double p))
    | XH -> (match y with
             | XH -> IsNul
             | _ -> IsNeg)

  (** val sub_mask_carry : positive -> positive -> mask **)

  and sub_mask_carry x y =
    match x with
    | XI p ->
      (match y with
       | XI q -> succ_double_mask (sub_mask_carry p q)
       | XO q -> double_mask (sub_mask p q)
       | XH -> IsPos (pred_double p))
    | XO p ->
      (match y with
       | XI q -> double_mask (sub_mask_carry p q)
       | XO q -> succ_double_mask (sub_mask_carry p q)
       | XH -> double_pred_mask p)
    | XH -> IsNeg

  (** val mul : positive -> positive -> positive **)

  let rec mul x y =
    match x with
    | XI p -> add y (XO (mul p y))
    | XO p -> XO (mul p y)
    | XH -> y

  (** val iter : ('a1 -> 'a1) -> 'a1 -> positive -> 'a1 **)

  let rec iter f x = function
  | XI n' -> f (iter f (iter f x n') n')
  | XO n' -> iter f (iter f x n') n'
  | XH -> f x

  (** val div2 : positive -> positive **)

  let div2 = function
  | XI p0 -> p0
  | XO p0 -> p0
  | XH -> XH

  (** val div2_up : positive -> positive **)

  let div2_up = function
  | XI p0 -> succ p0
  | XO p0 -> p0
  | XH -> XH

  (** val compare_cont : comparison -> positive -> positive -> comparison **)

  let rec compare_cont r x y =
    match x with
    | XI p ->
      (match y with
       | XI q -> compare_cont r p q
       | XO q -> compare_cont Gt p q
       | XH -> Gt)
    | XO p ->
      (match y with
       | XI q -> compare_cont Lt p q
       | XO q -> compare_cont r p q
       | XH -> Gt)
    | XH -> (match y with
             | XH -> r
             | _ -> Lt)

  (** val compare : positive -> positive -> comparison **)

  let compare =
    compare_cont Eq

  (** val eqb : positive -> positive -> bool **)

  let rec eqb p q =
    match p with
    | XI p0 -> (match q with
                | XI q0 -> eqb p0 q0
                | _ -> false)
    | XO p0 -> (match q with
                | XO q0 -> eqb p0 q0
                | _ -> false)
    | XH -> (match q with
             | XH -> true
             | _ -> false)

  (** val leb : positive -> positive -> bool **)

  let leb x y =
    match compare x y with
    | Gt -> false
    | _ -> true

  (** val sqrtrem_step :
      (positive -> positive) -> (positive -> positive) -> (positive * mask)
      -> positive * mask **)

  let sqrtrem_step f g = function
  | (s, y) ->
    (match y with
     | IsPos r ->
       let s' = XI (XO s) in
       let r' = g (f r) in
       if leb s' r' then ((XI s), (sub_mask r' s')) else ((XO s), (IsPos r'))
     | _ -> ((XO s), (sub_mask (g (f XH)) (XO (XO XH)))))

  (** val sqrtrem : positive -> positive * mask **)

  let rec sqrtrem = function
  | XI p0 ->
    (match p0 with
     | XI p1 -> sqrtrem_step (fun x -> XI x) (fun x -> XI x) (sqrtrem p1)
     | XO p1 -> sqrtrem_step (fun x -> XO x) (fun x -> XI x) (sqrtrem p1)
     | XH -> (XH, (IsPos (XO XH))))
  | XO p0 ->
    (match p0 with
     | XI p1 -> sqrtrem_step (fun x -> XI x) (fun x -> XO x) (sqrtrem p1)
     | XO p1 -> sqrtrem_step (fun x -> XO x) (fun x -> XO x) (sqrtrem p1)
     | XH -> (XH, (IsPos XH)))
  | XH -> (XH, IsNul)

  (** val coq_Nsucc_double : n -> n **)

  let coq_Nsucc_double = function
  | N0 -> Npos XH
  | Npos p -> Npos (XI p)

  (** val coq_Ndouble : n -> n **)

  let coq_Ndouble = function
  | N0 -> N0
  | Npos p -> Npos (XO p)

  (** val coq_lor : positive -> positive -> positive **)

  let rec coq_lor p q =
    match p with
    | XI p0 ->
      (match q with
       | XI q0 -> XI (coq_lor p0 q0)
       | XO q0 -> XI (coq_lor p0 q0)
       | XH -> p)
    | XO p0 ->
      (match q with
       | XI q0 -> XI (coq_lor p0 q0)
       | XO q0 -> XO (coq_lor p0 q0)
       | XH -> XI p0)
    | XH -> (match q with
             | XO q0 -> XI q0
             | _ -> q)

  (** val coq_land : positive -> positive -> n **)

  let rec coq_land p q =
    match p with
    | XI p0 ->
      (match q with
       | XI q0 -> coq_Nsucc_double (coq_land p0 q0)
       | XO q0 -> coq_Ndouble (coq_land p0 q0)
       | XH -> Npos XH)
    | XO p0 ->
      (match q with
       | XI q0 -> coq_Ndouble (coq_land p0 q0)
       | XO q0 -> coq_Ndouble (coq_land p0 q0)
       | XH -> N0)
    | XH -> (match q with
             | XO _ -> N0
             | _ -> Npos XH)

  (** val ldiff : positive -> positive -> n **)

  let rec ldiff p q =
    match p with
    | XI p0 ->
      (match q with
       | XI q0 -> coq_Ndouble (ldiff p0 q0)
       | XO q0 -> coq_Nsucc_double (ldiff p0 q0)
       | XH -> Npos (XO p0))
    | XO p0 ->
      (match q with
       | XI q0 -> coq_Ndouble (ldiff p0 q0)
       | XO q0 -> coq_Ndouble (ldiff p0 q0)
       | XH -> Npos p)
    | XH -> (match q with
             | XO _ -> Npos XH
             | _ -> N0)

  (** val coq_lxor : positive -> positive -> n **)

  let rec coq_lxor p q =
    match p with
    | XI p0 ->
      (match q with
       | XI q0 -> coq_Ndouble (coq_lxor p0 q0)
       | XO q0 -> coq_Nsucc_double (coq_lxor p0 q0)
       | XH -> Npos (XO p0))
    | XO p0 ->
      (match q with
       | XI q0 -> coq_Nsucc_double (coq_lxor p0 q0)
       | XO q0 -> coq_Ndouble (coq_lxor p0 q0)
       | XH -> Npos (XI p0))
    | XH ->
      (match q with
       | XI q0 -> Npos (XO q0)
       | XO q0 -> Npos (XI q0)
       | XH -> N0)

  (** val iter_op : ('a1 -> 'a1 -> 'a1) -> positive -> 'a1 -> 'a1 **)

  let rec iter_op op p a =
    match p with
    | XI p0 -> op a (iter_op op p0 (op a a))
    | XO p0 -> iter_op op p0 (op a a)
    | XH -> a

  (** val to_nat : positive -> nat **)

  let to_nat x =
    iter_op Coq__1.add x (S O)

  (** val of_succ_nat : nat -> positive **)

  let rec of_succ_nat = function
  | O -> XH
  | S x -> succ (of_succ_nat x)
 end

module Coq_Pos =
 struct
  (** val succ : positive -> positive **)

  let rec succ = function
  | XI p -> XO (succ p)
  | XO p -> XI p
  | XH -> XO XH

  (** val add : positive -> positive -> positive **)

  let rec add x y =
    match x with
    | XI p ->
      (match y with
       | XI q -> XO (add_carry p q)
       | XO q -> XI (add p q)
       | XH -> XO (succ p))
    | XO p ->
      (match y with
       | XI q -> XI (add p q)
       | XO q -> XO (add p q)
       | XH -> XI p)
    | XH -> (match y with
             | XI q -> XO (succ q)
             | XO q -> XI q
             | XH -> XO XH)

  (** val add_carry : positive -> positive -> positive **)

  and add_carry x y =
    match x with
    | XI p ->
      (match y with
       | XI q -> XI (add_carry p q)
       | XO q -> XO (add_carry p q)
       | XH -> XI (succ p))
    | XO p ->
      (match y with
       | XI q -> XO (add_carry p q)
       | XO q -> XI (add p q)
       | XH -> XO (succ p))
    | XH ->
      (match y with
       | XI q -> XI (succ q)
       | XO q -> XO (succ q)
       | XH -> XI XH)

  (** val pred_double : positive -> positive **)

  let rec pred_double = function
  | XI p -> XI (XO p)
  | XO p -> XI (pred_double p)
  | XH -> XH

  (** val pred_N : positive -> n **)

  let pred_N = function
  | XI p -> Npos (XO p)
  | XO p -> Npos (pred_double p)
  | XH -> N0

  (** val mul : positive -> positive -> positive **)

  let rec mul x y =
    match x with
    | XI p -> add y (XO (mul p y))
    | XO p -> XO (mul p y)
    | XH -> y

  (** val iter : ('a1 -> 'a1) -> 'a1 -> positive -> 'a1 **)

  let rec iter f x = function
  | XI n' -> f (iter f (iter f x n') n')
  | XO n' -> iter f (iter f x n') n'
  | XH -> f x

  (** val div2 : positive -> positive **)

  let div2 = function
  | XI p0 -> p0
  | XO p0 -> p0
  | XH -> XH

  (** val eqb : positive -> positive -> bool **)

  let rec eqb p q =
    match p with
    | XI p0 -> (match q with
                | XI q0 -> eqb p0 q0
                | _ -> false)
    | XO p0 -> (match q with
                | XO q0 -> eqb p0 q0
                | _ -> false)
    | XH -> (match q with
             | XH -> true
             | _ -> false)

  (** val coq_lor : positive -> positive -> positive **)

  let rec coq_lor p q =
    match p with
    | XI p0 ->
      (match q with
       | XI q0 -> XI (coq_lor p0 q0)
       | XO q0 -> XI (coq_lor p0 q0)
       | XH -> p)
    | XO p0 ->
      (match q with
       | XI q0 -> XI (coq_lor p0 q0)
       | XO q0 -> XO (coq_lor p0 q0)
       | XH -> XI p0)
    | XH -> (match q with
             | XO q0 -> XI q0
             | _ -> q)

  (** val size : positive -> positive **)

  let rec size = function
  | XI p0 -> succ (size p0)
  | XO p0 -> succ (size p0)
  | XH -> XH

  (** val shiftl_nat : positive -> nat -> positive **)

  let rec shiftl_nat p = function
  | O -> p
  | S n1 -> XO (shiftl_nat p n1)

  (** val shiftr_nat : positive -> nat -> positive **)

  let rec shiftr_nat p = function
  | O -> p
  | S n1 -> div2 (shiftr_nat p n1)

  (** val testbit : positive -> n -> bool **)

  let rec testbit p n0 =
    match p with
    | XI p0 -> (match n0 with
                | N0 -> true
                | Npos n1 -> testbit p0 (pred_N n1))
    | XO p0 -> (match n0 with
                | N0 -> false
                | Npos n1 -> testbit p0 (pred_N n1))
    | XH -> (match n0 with
             | N0 -> true
             | Npos _ -> false)

  (** val eq_dec : positive -> positive -> bool **)

  let rec eq_dec p x0 =
    match p with
    | XI p0 -> (match x0 with
                | XI p1 -> eq_dec p0 p1
                | _ -> false)
    | XO p0 -> (match x0 with
                | XO p1 -> eq_dec p0 p1
                | _ -> false)
    | XH -> (match x0 with
             | XH -> true
             | _ -> false)
 end

module N =
 struct
  (** val succ_double : n -> n **)

  let succ_double = function
  | N0 -> Npos XH
  | Npos p -> Npos (XI p)

  (** val double : n -> n **)

  let double = function
  | N0 -> N0
  | Npos p -> Npos (XO p)

  (** val succ_pos : n -> positive **)

  let succ_pos = function
  | N0 -> XH
  | Npos p -> Pos.succ p

  (** val sub : n -> n -> n **)

  let sub n0 m =
    match n0 with
    | N0 -> N0
    | Npos n' ->
      (match m with
       | N0 -> n0
       | Npos m' ->
         (match Pos.sub_mask n' m' with
          | Pos.IsPos p -> Npos p
          | _ -> N0))

  (** val compare : n -> n -> comparison **)

  let compare n0 m =
    match n0 with
    | N0 -> (match m with
             | N0 -> Eq
             | Npos _ -> Lt)
    | Npos n' -> (match m with
                  | N0 -> Gt
                  | Npos m' -> Pos.compare n' m')

  (** val leb : n -> n -> bool **)

  let leb x y =
    match compare x y with
    | Gt -> false
    | _ -> true

  (** val pos_div_eucl : positive -> n -> n * n **)

  let rec pos_div_eucl a b =
    match a with
    | XI a' ->
      let (q, r) = pos_div_eucl a' b in
      let r' = succ_double r in
      if leb b r' then ((succ_double q), (sub r' b)) else ((double q), r')
    | XO a' ->
      let (q, r) = pos_div_eucl a' b in
      let r' = double r in
      if leb b r' then ((succ_double q), (sub r' b)) else ((double q), r')
    | XH ->
      (match b with
       | N0 -> (N0, (Npos XH))
       | Npos p -> (match p with
                    | XH -> ((Npos XH), N0)
                    | _ -> (N0, (Npos XH))))

  (** val coq_lor : n -> n -> n **)

  let coq_lor n0 m =
    match n0 with
    | N0 -> m
    | Npos p -> (match m with
                 | N0 -> n0
                 | Npos q -> Npos (Pos.coq_lor p q))

  (** val coq_land : n -> n -> n **)

  let coq_land n0 m =
    match n0 with
    | N0 -> N0
    | Npos p -> (match m with
                 | N0 -> N0
                 | Npos q -> Pos.coq_land p q)

  (** val ldiff : n -> n -> n **)

  let ldiff n0 m =
    match n0 with
    | N0 -> N0
    | Npos p -> (match m with
                 | N0 -> n0
                 | Npos q -> Pos.ldiff p q)

  (** val coq_lxor : n -> n -> n **)

  let coq_lxor n0 m =
    match n0 with
    | N0 -> m
    | Npos p -> (match m with
                 | N0 -> n0
                 | Npos q -> Pos.coq_lxor p q)
 end

module Coq_N =
 struct
  (** val testbit : n -> n -> bool **)

  let testbit a n0 =
    match a with
    | N0 -> false
    | Npos p -> Coq_Pos.testbit p n0

  (** val eq_dec : n -> n -> bool **)

  let eq_dec n0 m =
    match n0 with
    | N0 -> (match m with
             | N0 -> true
             | Npos _ -> false)
    | Npos p -> (match m with
                 | N0 -> false
                 | Npos p0 -> Coq_Pos.eq_dec p p0)
 end

(** val map : ('a1 -> 'a2) -> 'a1 list -> 'a2 list **)

let rec map f = function
| [] -> []
| a :: l0 -> (f a) :: (map f l0)

(** val repeat : 'a1 -> nat -> 'a1 list **)

let rec repeat x = function
| O -> []
| S k -> x :: (repeat x k)

(** val in_dec : ('a1 -> 'a1 -> bool) -> 'a1 -> 'a1 list -> bool **)

let rec in_dec h a = function
| [] -> false
| a0 :: l0 -> let s = h a0 a in if s then true else in_dec h a l0

(** val rev : 'a1 list -> 'a1 list **)

let rec rev = function
| [] -> []
| x :: l' -> app (rev l') (x :: [])

(** val list_eq_dec : ('a1 -> 'a1 -> bool) -> 'a1 list -> 'a1 list -> bool **)

let rec list_eq_dec eq_dec0 l l' =
  match l with
  | [] -> (match l' with
           | [] -> true
           | _ :: _ -> false)
  | a :: l0 ->
    (match l' with
     | [] -> false
     | a0 :: l1 -> if eq_dec0 a a0 then list_eq_dec eq_dec0 l0 l1 else false)

(** val fold_left : ('a1 -> 'a2 -> 'a1) -> 'a2 list -> 'a1 -> 'a1 **)

let rec fold_left f l a0 =
  match l with
  | [] -> a0
  | b :: l0 -> fold_left f l0 (f a0 b)

(** val string_dec : char list -> char list -> bool **)

let rec string_dec s x =
  match s with
  | [] -> (match x with
           | [] -> true
           | _::_ -> false)
  | a::s0 ->
    (match x with
     | [] -> false
     | a0::s1 -> if (=) a a0 then string_dec s0 s1 else false)

module Z =
 struct
  (** val double : z -> z **)

  let double = function
  | Z0 -> Z0
  | Zpos p -> Zpos (XO p)
  | Zneg p -> Zneg (XO p)

  (** val succ_double : z -> z **)

  let succ_double = function
  | Z0 -> Zpos XH
  | Zpos p -> Zpos (XI p)
  | Zneg p -> Zneg (Pos.pred_double p)

  (** val pred_double : z -> z **)

  let pred_double = function
  | Z0 -> Zneg XH
  | Zpos p -> Zpos (Pos.pred_double p)
  | Zneg p -> Zneg (XI p)

  (** val pos_sub : positive -> positive -> z **)

  let rec pos_sub x y =
    match x with
    | XI p ->
      (match y with
       | XI q -> double (pos_sub p q)
       | XO q -> succ_double (pos_sub p q)
       | XH -> Zpos (XO p))
    | XO p ->
      (match y with
       | XI q -> pred_double (pos_sub p q)
       | XO q -> double (pos_sub p q)
       | XH -> Zpos (Pos.pred_double p))
    | XH ->
      (match y with
       | XI q -> Zneg (XO q)
       | XO q -> Zneg (Pos.pred_double q)
       | XH -> Z0)

  (** val add : z -> z -> z **)

  let add x y =
    match x with
    | Z0 -> y
    | Zpos x' ->
      (match y with
       | Z0 -> x
       | Zpos y' -> Zpos (Pos.add x' y')
       | Zneg y' -> pos_sub x' y')
    | Zneg x' ->
      (match y with
       | Z0 -> x
       | Zpos y' -> pos_sub y' x'
       | Zneg y' -> Zneg (Pos.add x' y'))

  (** val opp : z -> z **)

  let opp = function
  | Z0 -> Z0
  | Zpos x0 -> Zneg x0
  | Zneg x0 -> Zpos x0

  (** val sub : z -> z -> z **)

  let sub m n0 =
    add m (opp n0)

  (** val mul : z -> z -> z **)

  let mul x y =
    match x with
    | Z0 -> Z0
    | Zpos x' ->
      (match y with
       | Z0 -> Z0
       | Zpos y' -> Zpos (Pos.mul x' y')
       | Zneg y' -> Zneg (Pos.mul x' y'))
    | Zneg x' ->
      (match y with
       | Z0 -> Z0
       | Zpos y' -> Zneg (Pos.mul x' y')
       | Zneg y' -> Zpos (Pos.mul x' y'))

  (** val compare : z -> z -> comparison **)

  let compare x y =
    match x with
    | Z0 -> (match y with
             | Z0 -> Eq
             | Zpos _ -> Lt
             | Zneg _ -> Gt)
    | Zpos x' -> (match y with
                  | Zpos y' -> Pos.compare x' y'
                  | _ -> Gt)
    | Zneg x' ->
      (match y with
       | Zneg y' -> compOpp (Pos.compare x' y')
       | _ -> Lt)

  (** val leb : z -> z -> bool **)

  let leb x y =
    match compare x y with
    | Gt -> false
    | _ -> true

  (** val ltb : z -> z -> bool **)

  let ltb x y =
    match compare x y with
    | Lt -> true
    | _ -> false

  (** val eqb : z -> z -> bool **)

  let eqb x y =
    match x with
    | Z0 -> (match y with
             | Z0 -> true
             | _ -> false)
    | Zpos p -> (match y with
                 | Zpos q -> Pos.eqb p q
                 | _ -> false)
    | Zneg p -> (match y with
                 | Zneg q -> Pos.eqb p q
                 | _ -> false)

  (** val max : z -> z -> z **)

  let max n0 m =
    match compare n0 m with
    | Lt -> m
    | _ -> n0

  (** val min : z -> z -> z **)

  let min n0 m =
    match compare n0 m with
    | Gt -> m
    | _ -> n0

  (** val pos_div_eucl : positive -> z -> z * z **)

  let rec pos_div_eucl a b =
    match a with
    | XI a' ->
      let (q, r) = pos_div_eucl a' b in
      let r' = add (mul (Zpos (XO XH)) r) (Zpos XH) in
      if ltb r' b
      then ((mul (Zpos (XO XH)) q), r')
      else ((add (mul (Zpos (XO XH)) q) (Zpos XH)), (sub r' b))
    | XO a' ->
      let (q, r) = pos_div_eucl a' b in
      let r' = mul (Zpos (XO XH)) r in
      if ltb r' b
      then ((mul (Zpos (XO XH)) q), r')
      else ((add (mul (Zpos (XO XH)) q) (Zpos XH)), (sub r' b))
    | XH -> if leb (Zpos (XO XH)) b then (Z0, (Zpos XH)) else ((Zpos XH), Z0)

  (** val div_eucl : z -> z -> z * z **)

  let div_eucl a b =
    match a with
    | Z0 -> (Z0, Z0)
    | Zpos a' ->
      (match b with
       | Z0 -> (Z0, a)
       | Zpos _ -> pos_div_eucl a' b
       | Zneg b' ->
         let (q, r) = pos_div_eucl a' (Zpos b') in
         (match r with
          | Z0 -> ((opp q), Z0)
          | _ -> ((opp (add q (Zpos XH))), (add b r))))
    | Zneg a' ->
      (match b with
       | Z0 -> (Z0, a)
       | Zpos _ ->
         let (q, r) = pos_div_eucl a' b in
         (match r with
          | Z0 -> ((opp q), Z0)
          | _ -> ((opp (add q (Zpos XH))), (sub b r)))
       | Zneg b' -> let (q, r) = pos_div_eucl a' (Zpos b') in (q, (opp r)))

  (** val even : z -> bool **)

  let even = function
  | Z0 -> true
  | Zpos p -> (match p with
               | XO _ -> true
               | _ -> false)
  | Zneg p -> (match p with
               | XO _ -> true
               | _ -> false)

  (** val div2 : z -> z **)

  let div2 = function
  | Z0 -> Z0
  | Zpos p -> (match p with
               | XH -> Z0
               | _ -> Zpos (Pos.div2 p))
  | Zneg p -> Zneg (Pos.div2_up p)

  (** val sqrtrem : z -> z * z **)

  let sqrtrem = function
  | Zpos p ->
    let (s, m) = Pos.sqrtrem p in
    (match m with
     | Pos.IsPos r -> ((Zpos s), (Zpos r))
     | _ -> ((Zpos s), Z0))
  | _ -> (Z0, Z0)

  (** val shiftl : z -> z -> z **)

  let shiftl a = function
  | Z0 -> a
  | Zpos p -> Pos.iter (mul (Zpos (XO XH))) a p
  | Zneg p -> Pos.iter div2 a p
 end

module Coq_Z =
 struct
  (** val double : z -> z **)

  let double = function
  | Z0 -> Z0
  | Zpos p -> Zpos (XO p)
  | Zneg p -> Zneg (XO p)

  (** val succ_double : z -> z **)

  let succ_double = function
  | Z0 -> Zpos XH
  | Zpos p -> Zpos (XI p)
  | Zneg p -> Zneg (Pos.pred_double p)

  (** val pred_double : z -> z **)

  let pred_double = function
  | Z0 -> Zneg XH
  | Zpos p -> Zpos (Pos.pred_double p)
  | Zneg p -> Zneg (XI p)

  (** val pos_sub : positive -> positive -> z **)

  let rec pos_sub x y =
    match x with
    | XI p ->
      (match y with
       | XI q -> double (pos_sub p q)
       | XO q -> succ_double (pos_sub p q)
       | XH -> Zpos (XO p))
    | XO p ->
      (match y with
       | XI q -> pred_double (pos_sub p q)
       | XO q -> double (pos_sub p q)
       | XH -> Zpos (Pos.pred_double p))
    | XH ->
      (match y with
       | XI q -> Zneg (XO q)
       | XO q -> Zneg (Pos.pred_double q)
       | XH -> Z0)

  (** val add : z -> z -> z **)

  let add x y =
    match x with
    | Z0 -> y
    | Zpos x' ->
      (match y with
       | Z0 -> x
       | Zpos y' -> Zpos (Pos.add x' y')
       | Zneg y' -> pos_sub x' y')
    | Zneg x' ->
      (match y with
       | Z0 -> x
       | Zpos y' -> pos_sub y' x'
       | Zneg y' -> Zneg (Pos.add x' y'))

  (** val opp : z -> z **)

  let opp = function
  | Z0 -> Z0
  | Zpos x0 -> Zneg x0
  | Zneg x0 -> Zpos x0

  (** val sub : z -> z -> z **)

  let sub m n0 =
    add m (opp n0)

  (** val mul : z -> z -> z **)

  let mul x y =
    match x with
    | Z0 -> Z0
    | Zpos x' ->
      (match y with
       | Z0 -> Z0
       | Zpos y' -> Zpos (Pos.mul x' y')
       | Zneg y' -> Zneg (Pos.mul x' y'))
    | Zneg x' ->
      (match y with
       | Z0 -> Z0
       | Zpos y' -> Zneg (Pos.mul x' y')
       | Zneg y' -> Zpos (Pos.mul x' y'))

  (** val pow_pos : z -> positive -> z **)

  let pow_pos z0 =
    Pos.iter (mul z0) (Zpos XH)

  (** val pow : z -> z -> z **)

  let pow x = function
  | Z0 -> Zpos XH
  | Zpos p -> pow_pos x p
  | Zneg _ -> Z0

  (** val compare : z -> z -> comparison **)

  let compare x y =
    match x with
    | Z0 -> (match y with
             | Z0 -> Eq
             | Zpos _ -> Lt
             | Zneg _ -> Gt)
    | Zpos x' -> (match y with
                  | Zpos y' -> Pos.compare x' y'
                  | _ -> Gt)
    | Zneg x' ->
      (match y with
       | Zneg y' -> compOpp (Pos.compare x' y')
       | _ -> Lt)

  (** val leb : z -> z -> bool **)

  let leb x y =
    match compare x y with
    | Gt -> false
    | _ -> true

  (** val ltb : z -> z -> bool **)

  let ltb x y =
    match compare x y with
    | Lt -> true
    | _ -> false

  (** val eqb : z -> z -> bool **)

  let eqb x y =
    match x with
    | Z0 -> (match y with
             | Z0 -> true
             | _ -> false)
    | Zpos p -> (match y with
                 | Zpos q -> Pos.eqb p q
                 | _ -> false)
    | Zneg p -> (match y with
                 | Zneg q -> Pos.eqb p q
                 | _ -> false)

  (** val max : z -> z -> z **)

  let max n0 m =
    match compare n0 m with
    | Lt -> m
    | _ -> n0

  (** val min : z -> z -> z **)

  let min n0 m =
    match compare n0 m with
    | Gt -> m
    | _ -> n0

  (** val to_nat : z -> nat **)

  let to_nat = function
  | Zpos p -> Pos.to_nat p
  | _ -> O

  (** val of_nat : nat -> z **)

  let of_nat = function
  | O -> Z0
  | S n1 -> Zpos (Pos.of_succ_nat n1)

  (** val of_N : n -> z **)

  let of_N = function
  | N0 -> Z0
  | Npos p -> Zpos p

  (** val to_pos : z -> positive **)

  let to_pos = function
  | Zpos p -> p
  | _ -> XH

  (** val pos_div_eucl : positive -> z -> z * z **)

  let rec pos_div_eucl a b =
    match a with
    | XI a' ->
      let (q, r) = pos_div_eucl a' b in
      let r' = add (mul (Zpos (XO XH)) r) (Zpos XH) in
      if ltb r' b
      then ((mul (Zpos (XO XH)) q), r')
      else ((add (mul (Zpos (XO XH)) q) (Zpos XH)), (sub r' b))
    | XO a' ->
      let (q, r) = pos_div_eucl a' b in
      let r' = mul (Zpos (XO XH)) r in
      if ltb r' b
      then ((mul (Zpos (XO XH)) q), r')
      else ((add (mul (Zpos (XO XH)) q) (Zpos XH)), (sub r' b))
    | XH -> if leb (Zpos (XO XH)) b then (Z0, (Zpos XH)) else ((Zpos XH), Z0)

  (** val div_eucl : z -> z -> z * z **)

  let div_eucl a b =
    match a with
    | Z0 -> (Z0, Z0)
    | Zpos a' ->
      (match b with
       | Z0 -> (Z0, a)
       | Zpos _ -> pos_div_eucl a' b
       | Zneg b' ->
         let (q, r) = pos_div_eucl a' (Zpos b') in
         (match r with
          | Z0 -> ((opp q), Z0)
          | _ -> ((opp (add q (Zpos XH))), (add b r))))
    | Zneg a' ->
      (match b with
       | Z0 -> (Z0, a)
       | Zpos _ ->
         let (q, r) = pos_div_eucl a' b in
         (match r with
          | Z0 -> ((opp q), Z0)
          | _ -> ((opp (add q (Zpos XH))), (sub b r)))
       | Zneg b' -> let (q, r) = pos_div_eucl a' (Zpos b') in (q, (opp r)))

  (** val div : z -> z -> z **)

  let div a b =
    let (q, _) = div_eucl a b in q

  (** val modulo : z -> z -> z **)

  let modulo a b =
    let (_, r) = div_eucl a b in r

  (** val quotrem : z -> z -> z * z **)

  let quotrem a b =
    match a with
    | Z0 -> (Z0, Z0)
    | Zpos a0 ->
      (match b with
       | Z0 -> (Z0, a)
       | Zpos b0 ->
         let (q, r) = N.pos_div_eucl a0 (Npos b0) in ((of_N q), (of_N r))
       | Zneg b0 ->
         let (q, r) = N.pos_div_eucl a0 (Npos b0) in
         ((opp (of_N q)), (of_N r)))
    | Zneg a0 ->
      (match b with
       | Z0 -> (Z0, a)
       | Zpos b0 ->
         let (q, r) = N.pos_div_eucl a0 (Npos b0) in
         ((opp (of_N q)), (opp (of_N r)))
       | Zneg b0 ->
         let (q, r) = N.pos_div_eucl a0 (Npos b0) in
         ((of_N q), (opp (of_N r))))

  (** val quot : z -> z -> z **)

  let quot a b =
    fst (quotrem a b)

  (** val rem : z -> z -> z **)

  let rem a b =
    snd (quotrem a b)

  (** val even : z -> bool **)

  let even = function
  | Z0 -> true
  | Zpos p -> (match p with
               | XO _ -> true
               | _ -> false)
  | Zneg p -> (match p with
               | XO _ -> true
               | _ -> false)

  (** val div2 : z -> z **)

  let div2 = function
  | Z0 -> Z0
  | Zpos p -> (match p with
               | XH -> Z0
               | _ -> Zpos (Pos.div2 p))
  | Zneg p -> Zneg (Pos.div2_up p)

  (** val shiftl : z -> z -> z **)

  let shiftl a = function
  | Z0 -> a
  | Zpos p -> Pos.iter (mul (Zpos (XO XH))) a p
  | Zneg p -> Pos.iter div2 a p

  (** val shiftr : z -> z -> z **)

  let shiftr a n0 =
    shiftl a (opp n0)

  (** val coq_lor : z -> z -> z **)

  let coq_lor a b =
    match a with
    | Z0 -> b
    | Zpos a0 ->
      (match b with
       | Z0 -> a
       | Zpos b0 -> Zpos (Pos.coq_lor a0 b0)
       | Zneg b0 -> Zneg (N.succ_pos (N.ldiff (Pos.pred_N b0) (Npos a0))))
    | Zneg a0 ->
      (match b with
       | Z0 -> a
       | Zpos b0 -> Zneg (N.succ_pos (N.ldiff (Pos.pred_N a0) (Npos b0)))
       | Zneg b0 ->
         Zneg (N.succ_pos (N.coq_land (Pos.pred_N a0) (Pos.pred_N b0))))

  (** val coq_land : z -> z -> z **)

  let coq_land a b =
    match a with
    | Z0 -> Z0
    | Zpos a0 ->
      (match b with
       | Z0 -> Z0
       | Zpos b0 -> of_N (Pos.coq_land a0 b0)
       | Zneg b0 -> of_N (N.ldiff (Npos a0) (Pos.pred_N b0)))
    | Zneg a0 ->
      (match b with
       | Z0 -> Z0
       | Zpos b0 -> of_N (N.ldiff (Npos b0) (Pos.pred_N a0))
       | Zneg b0 ->
         Zneg (N.succ_pos (N.coq_lor (Pos.pred_N a0) (Pos.pred_N b0))))

  (** val coq_lxor : z -> z -> z **)

  let coq_lxor a b =
    match a with
    | Z0 -> b
    | Zpos a0 ->
      (match b with
       | Z0 -> a
       | Zpos b0 -> of_N (Pos.coq_lxor a0 b0)
       | Zneg b0 -> Zneg (N.succ_pos (N.coq_lxor (Npos a0) (Pos.pred_N b0))))
    | Zneg a0 ->
      (match b with
       | Z0 -> a
       | Zpos b0 -> Zneg (N.succ_pos (N.coq_lxor (Pos.pred_N a0) (Npos b0)))
       | Zneg b0 -> of_N (N.coq_lxor (Pos.pred_N a0) (Pos.pred_N b0)))

  (** val pred : z -> z **)

  let pred x =
    add x (Zneg XH)

  (** val geb : z -> z -> bool **)

  let geb x y =
    match compare x y with
    | Lt -> false
    | _ -> true

  (** val gtb : z -> z -> bool **)

  let gtb x y =
    match compare x y with
    | Gt -> true
    | _ -> false

  (** val iter : z -> ('a1 -> 'a1) -> 'a1 -> 'a1 **)

  let iter n0 f x =
    match n0 with
    | Zpos p -> Coq_Pos.iter f x p
    | _ -> x

  (** val odd : z -> bool **)

  let odd = function
  | Z0 -> false
  | Zpos p -> (match p with
               | XO _ -> false
               | _ -> true)
  | Zneg p -> (match p with
               | XO _ -> false
               | _ -> true)

  (** val log2 : z -> z **)

  let log2 = function
  | Zpos p0 ->
    (match p0 with
     | XI p -> Zpos (Coq_Pos.size p)
     | XO p -> Zpos (Coq_Pos.size p)
     | XH -> Z0)
  | _ -> Z0

  (** val testbit : z -> z -> bool **)

  let testbit a = function
  | Z0 -> odd a
  | Zpos p ->
    (match a with
     | Z0 -> false
     | Zpos a0 -> Coq_Pos.testbit a0 (Npos p)
     | Zneg a0 -> negb (Coq_N.testbit (Coq_Pos.pred_N a0) (Npos p)))
  | Zneg _ -> false

  (** val eq_dec : z -> z -> bool **)

  let eq_dec x y =
    match x with
    | Z0 -> (match y with
             | Z0 -> true
             | _ -> false)
    | Zpos p -> (match y with
                 | Zpos p0 -> Coq_Pos.eq_dec p p0
                 | _ -> false)
    | Zneg p -> (match y with
                 | Zneg p0 -> Coq_Pos.eq_dec p p0
                 | _ -> false)
 end

(** val z_lt_dec : z -> z -> bool **)

let z_lt_dec x y =
  match Coq_Z.compare x y with
  | Lt -> true
  | _ -> false

(** val z_le_dec : z -> z -> bool **)

let z_le_dec x y =
  match Coq_Z.compare x y with
  | Gt -> false
  | _ -> true

(** val z_le_gt_dec : z -> z -> bool **)

let z_le_gt_dec =
  z_le_dec

(** val shift_nat : nat -> positive -> positive **)

let rec shift_nat n0 z0 =
  match n0 with
  | O -> z0
  | S n1 -> XO (shift_nat n1 z0)

(** val shift_pos : positive -> positive -> positive **)

let shift_pos n0 z0 =
  Coq_Pos.iter (fun x -> XO x) z0 n0

(** val two_power_nat : nat -> z **)

let two_power_nat n0 =
  Zpos (shift_nat n0 XH)

(** val two_power_pos : positive -> z **)

let two_power_pos x =
  Zpos (shift_pos x XH)

(** val two_p : z -> z **)

let two_p = function
| Z0 -> Zpos XH
| Zpos y -> two_power_pos y
| Zneg _ -> Z0

(** val zdivide_dec : z -> z -> bool **)

let zdivide_dec a b =
  let s = Coq_Z.eq_dec a Z0 in
  if s then Coq_Z.eq_dec b Z0 else Coq_Z.eq_dec (Coq_Z.modulo b a) Z0

(** val peq : positive -> positive -> bool **)

let peq =
  Coq_Pos.eq_dec

(** val zeq : z -> z -> bool **)

let zeq =
  Coq_Z.eq_dec

(** val zlt : z -> z -> bool **)

let zlt =
  z_lt_dec

(** val zle : z -> z -> bool **)

let zle =
  z_le_gt_dec

(** val align : z -> z -> z **)

let align n0 amount =
  Coq_Z.mul (Coq_Z.div (Coq_Z.sub (Coq_Z.add n0 amount) (Zpos XH)) amount)
    amount

(** val floor : z -> z -> z **)

let floor n0 amount =
  Coq_Z.mul (Coq_Z.div n0 amount) amount

(** val option_map : ('a1 -> 'a2) -> 'a1 option -> 'a2 option **)

let option_map f = function
| Some y -> Some (f y)
| None -> None

(** val list_norepet_dec : ('a1 -> 'a1 -> bool) -> 'a1 list -> bool **)

let rec list_norepet_dec eqA_dec = function
| [] -> true
| a :: l0 ->
  if list_norepet_dec eqA_dec l0
  then if in_dec eqA_dec a l0 then false else true
  else false

(** val proj_sumbool : bool -> bool **)

let proj_sumbool = function
| true -> true
| false -> false

module PTree =
 struct
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

  (** val empty : 'a1 t **)

  let empty =
    Empty

  (** val get' : positive -> 'a1 tree' -> 'a1 option **)

  let rec get' p m =
    match p with
    | XI q ->
      (match m with
       | Node001 m' -> get' q m'
       | Node011 (_, m') -> get' q m'
       | Node101 (_, m') -> get' q m'
       | Node111 (_, _, m') -> get' q m'
       | _ -> None)
    | XO q ->
      (match m with
       | Node100 m' -> get' q m'
       | Node101 (m', _) -> get' q m'
       | Node110 (m', _) -> get' q m'
       | Node111 (m', _, _) -> get' q m'
       | _ -> None)
    | XH ->
      (match m with
       | Node010 x -> Some x
       | Node011 (x, _) -> Some x
       | Node110 (_, x) -> Some x
       | Node111 (_, x, _) -> Some x
       | _ -> None)

  (** val get : positive -> 'a1 tree -> 'a1 option **)

  let get p = function
  | Empty -> None
  | Nodes m' -> get' p m'

  (** val set0 : positive -> 'a1 -> 'a1 tree' **)

  let rec set0 p x =
    match p with
    | XI q -> Node001 (set0 q x)
    | XO q -> Node100 (set0 q x)
    | XH -> Node010 x

  (** val set' : positive -> 'a1 -> 'a1 tree' -> 'a1 tree' **)

  let rec set' p x m =
    match p with
    | XI q ->
      (match m with
       | Node001 r -> Node001 (set' q x r)
       | Node010 y -> Node011 (y, (set0 q x))
       | Node011 (y, r) -> Node011 (y, (set' q x r))
       | Node100 l -> Node101 (l, (set0 q x))
       | Node101 (l, r) -> Node101 (l, (set' q x r))
       | Node110 (l, y) -> Node111 (l, y, (set0 q x))
       | Node111 (l, y, r) -> Node111 (l, y, (set' q x r)))
    | XO q ->
      (match m with
       | Node001 r -> Node101 ((set0 q x), r)
       | Node010 y -> Node110 ((set0 q x), y)
       | Node011 (y, r) -> Node111 ((set0 q x), y, r)
       | Node100 l -> Node100 (set' q x l)
       | Node101 (l, r) -> Node101 ((set' q x l), r)
       | Node110 (l, y) -> Node110 ((set' q x l), y)
       | Node111 (l, y, r) -> Node111 ((set' q x l), y, r))
    | XH ->
      (match m with
       | Node001 r -> Node011 (x, r)
       | Node010 _ -> Node010 x
       | Node011 (_, r) -> Node011 (x, r)
       | Node100 l -> Node110 (l, x)
       | Node101 (l, r) -> Node111 (l, x, r)
       | Node110 (l, _) -> Node110 (l, x)
       | Node111 (l, _, r) -> Node111 (l, x, r))

  (** val set : positive -> 'a1 -> 'a1 tree -> 'a1 tree **)

  let set p x = function
  | Empty -> Nodes (set0 p x)
  | Nodes m' -> Nodes (set' p x m')

  (** val prev_append : positive -> positive -> positive **)

  let rec prev_append i j =
    match i with
    | XI i' -> prev_append i' (XI j)
    | XO i' -> prev_append i' (XO j)
    | XH -> j

  (** val prev : positive -> positive **)

  let prev i =
    prev_append i XH

  (** val map1' : ('a1 -> 'a2) -> 'a1 tree' -> 'a2 tree' **)

  let rec map1' f = function
  | Node001 r -> Node001 (map1' f r)
  | Node010 x -> Node010 (f x)
  | Node011 (x, r) -> Node011 ((f x), (map1' f r))
  | Node100 l -> Node100 (map1' f l)
  | Node101 (l, r) -> Node101 ((map1' f l), (map1' f r))
  | Node110 (l, x) -> Node110 ((map1' f l), (f x))
  | Node111 (l, x, r) -> Node111 ((map1' f l), (f x), (map1' f r))

  (** val map1 : ('a1 -> 'a2) -> 'a1 t -> 'a2 t **)

  let map1 f = function
  | Empty -> Empty
  | Nodes m0 -> Nodes (map1' f m0)

  (** val xelements' :
      'a1 tree' -> positive -> (positive * 'a1) list -> (positive * 'a1) list **)

  let rec xelements' m i k =
    match m with
    | Node001 r -> xelements' r (XI i) k
    | Node010 x -> ((prev i), x) :: k
    | Node011 (x, r) -> ((prev i), x) :: (xelements' r (XI i) k)
    | Node100 l -> xelements' l (XO i) k
    | Node101 (l, r) -> xelements' l (XO i) (xelements' r (XI i) k)
    | Node110 (l, x) -> xelements' l (XO i) (((prev i), x) :: k)
    | Node111 (l, x, r) ->
      xelements' l (XO i) (((prev i), x) :: (xelements' r (XI i) k))

  (** val elements : 'a1 t -> (positive * 'a1) list **)

  let elements = function
  | Empty -> []
  | Nodes m' -> xelements' m' XH []

  (** val fold' :
      ('a2 -> positive -> 'a1 -> 'a2) -> positive -> 'a1 tree' -> 'a2 -> 'a2 **)

  let rec fold' f i m v =
    match m with
    | Node001 r -> fold' f (XI i) r v
    | Node010 x -> f v (prev i) x
    | Node011 (x, r) -> fold' f (XI i) r (f v (prev i) x)
    | Node100 l -> fold' f (XO i) l v
    | Node101 (l, r) -> fold' f (XI i) r (fold' f (XO i) l v)
    | Node110 (l, x) -> f (fold' f (XO i) l v) (prev i) x
    | Node111 (l, x, r) ->
      fold' f (XI i) r (f (fold' f (XO i) l v) (prev i) x)

  (** val fold : ('a2 -> positive -> 'a1 -> 'a2) -> 'a1 t -> 'a2 -> 'a2 **)

  let fold f m v =
    match m with
    | Empty -> v
    | Nodes m' -> fold' f XH m' v
 end

module PMap =
 struct
  type 'a t = 'a * 'a PTree.t

  (** val init : 'a1 -> 'a1 * 'a1 PTree.t **)

  let init x =
    (x, PTree.empty)

  (** val get : positive -> 'a1 t -> 'a1 **)

  let get i m =
    match PTree.get i (snd m) with
    | Some x -> x
    | None -> fst m

  (** val set : positive -> 'a1 -> 'a1 t -> 'a1 * 'a1 PTree.tree **)

  let set i x m =
    ((fst m), (PTree.set i x (snd m)))

  (** val map : ('a1 -> 'a2) -> 'a1 t -> 'a2 t **)

  let map f m =
    ((f (fst m)), (PTree.map1 f (snd m)))
 end

module type INDEXED_TYPE =
 sig
  type t

  val index : t -> positive

  val eq : t -> t -> bool
 end

module IMap =
 functor (X:INDEXED_TYPE) ->
 struct
  type elt = X.t

  (** val elt_eq : X.t -> X.t -> bool **)

  let elt_eq =
    X.eq

  type 'x t = 'x PMap.t

  (** val init : 'a1 -> 'a1 * 'a1 PTree.t **)

  let init =
    PMap.init

  (** val get : X.t -> 'a1 t -> 'a1 **)

  let get i m =
    PMap.get (X.index i) m

  (** val set : X.t -> 'a1 -> 'a1 t -> 'a1 * 'a1 PTree.tree **)

  let set i v m =
    PMap.set (X.index i) v m

  (** val map : ('a1 -> 'a2) -> 'a1 t -> 'a2 t **)

  let map =
    PMap.map
 end

module ZIndexed =
 struct
  type t = z

  (** val index : z -> positive **)

  let index = function
  | Z0 -> XH
  | Zpos p -> XO p
  | Zneg p -> XI p

  (** val eq : z -> z -> bool **)

  let eq =
    zeq
 end

module ZMap = IMap(ZIndexed)

type errcode =
| MSG of char list
| CTX of positive
| POS of positive

type errmsg = errcode list

(** val msg : char list -> errmsg **)

let msg s =
  (MSG s) :: []

type 'a res =
| OK of 'a
| Error of errmsg

(** val bind : 'a1 res -> ('a1 -> 'a2 res) -> 'a2 res **)

let bind f g =
  match f with
  | OK x -> g x
  | Error msg0 -> Error msg0

(** val p_mod_two_p : positive -> nat -> z **)

let rec p_mod_two_p p = function
| O -> Z0
| S m ->
  (match p with
   | XI q -> Coq_Z.succ_double (p_mod_two_p q m)
   | XO q -> Coq_Z.double (p_mod_two_p q m)
   | XH -> Zpos XH)

(** val zshiftin : bool -> z -> z **)

let zshiftin b x =
  if b then Coq_Z.succ_double x else Coq_Z.double x

(** val zzero_ext : z -> z -> z **)

let zzero_ext n0 x =
  Coq_Z.iter n0 (fun rec0 x0 ->
    zshiftin (Coq_Z.odd x0) (rec0 (Coq_Z.div2 x0))) (fun _ -> Z0) x

(** val zsign_ext : z -> z -> z **)

let zsign_ext n0 x =
  Coq_Z.iter (Coq_Z.pred n0) (fun rec0 x0 ->
    zshiftin (Coq_Z.odd x0) (rec0 (Coq_Z.div2 x0))) (fun x0 ->
    if (&&) (Coq_Z.odd x0) (proj_sumbool (zlt Z0 n0)) then Zneg XH else Z0) x

(** val z_one_bits : nat -> z -> z -> z list **)

let rec z_one_bits n0 x i =
  match n0 with
  | O -> []
  | S m ->
    if Coq_Z.odd x
    then i :: (z_one_bits m (Coq_Z.div2 x) (Coq_Z.add i (Zpos XH)))
    else z_one_bits m (Coq_Z.div2 x) (Coq_Z.add i (Zpos XH))

(** val p_is_power2 : positive -> bool **)

let rec p_is_power2 = function
| XI _ -> false
| XO q -> p_is_power2 q
| XH -> true

(** val z_is_power2 : z -> z option **)

let z_is_power2 x = match x with
| Zpos p -> if p_is_power2 p then Some (Coq_Z.log2 x) else None
| _ -> None

(** val zsize : z -> z **)

let zsize = function
| Zpos p -> Zpos (Coq_Pos.size p)
| _ -> Z0

type spec_float =
| S754_zero of bool
| S754_infinity of bool
| S754_nan
| S754_finite of bool * positive * z

(** val emin : z -> z -> z **)

let emin prec emax =
  Z.sub (Z.sub (Zpos (XI XH)) emax) prec

(** val fexp : z -> z -> z -> z **)

let fexp prec emax e =
  Z.max (Z.sub e prec) (emin prec emax)

(** val digits2_pos : positive -> positive **)

let rec digits2_pos = function
| XI p -> Pos.succ (digits2_pos p)
| XO p -> Pos.succ (digits2_pos p)
| XH -> XH

(** val zdigits2 : z -> z **)

let zdigits2 n0 = match n0 with
| Z0 -> n0
| Zpos p -> Zpos (digits2_pos p)
| Zneg p -> Zpos (digits2_pos p)

(** val iter_pos : ('a1 -> 'a1) -> positive -> 'a1 -> 'a1 **)

let rec iter_pos f n0 x =
  match n0 with
  | XI n' -> iter_pos f n' (iter_pos f n' (f x))
  | XO n' -> iter_pos f n' (iter_pos f n' x)
  | XH -> f x

type location =
| Loc_Exact
| Loc_Inexact of comparison

type shr_record = { shr_m : z; shr_r : bool; shr_s : bool }

(** val shr_1 : shr_record -> shr_record **)

let shr_1 mrs =
  let { shr_m = m; shr_r = r; shr_s = s } = mrs in
  let s0 = (||) r s in
  (match m with
   | Z0 -> { shr_m = Z0; shr_r = false; shr_s = s0 }
   | Zpos p0 ->
     (match p0 with
      | XI p -> { shr_m = (Zpos p); shr_r = true; shr_s = s0 }
      | XO p -> { shr_m = (Zpos p); shr_r = false; shr_s = s0 }
      | XH -> { shr_m = Z0; shr_r = true; shr_s = s0 })
   | Zneg p0 ->
     (match p0 with
      | XI p -> { shr_m = (Zneg p); shr_r = true; shr_s = s0 }
      | XO p -> { shr_m = (Zneg p); shr_r = false; shr_s = s0 }
      | XH -> { shr_m = Z0; shr_r = true; shr_s = s0 }))

(** val loc_of_shr_record : shr_record -> location **)

let loc_of_shr_record mrs =
  let { shr_m = _; shr_r = shr_r0; shr_s = shr_s0 } = mrs in
  if shr_r0
  then if shr_s0 then Loc_Inexact Gt else Loc_Inexact Eq
  else if shr_s0 then Loc_Inexact Lt else Loc_Exact

(** val shr_record_of_loc : z -> location -> shr_record **)

let shr_record_of_loc m = function
| Loc_Exact -> { shr_m = m; shr_r = false; shr_s = false }
| Loc_Inexact c ->
  (match c with
   | Eq -> { shr_m = m; shr_r = true; shr_s = false }
   | Lt -> { shr_m = m; shr_r = false; shr_s = true }
   | Gt -> { shr_m = m; shr_r = true; shr_s = true })

(** val shr : shr_record -> z -> z -> shr_record * z **)

let shr mrs e n0 = match n0 with
| Zpos p -> ((iter_pos shr_1 p mrs), (Z.add e n0))
| _ -> (mrs, e)

(** val shr_fexp : z -> z -> z -> z -> location -> shr_record * z **)

let shr_fexp prec emax m e l =
  shr (shr_record_of_loc m l) e
    (Z.sub (fexp prec emax (Z.add (zdigits2 m) e)) e)

(** val shl_align : positive -> z -> z -> positive * z **)

let shl_align mx ex ex' =
  match Z.sub ex' ex with
  | Zneg d -> ((Pos.iter (fun x -> XO x) mx d), ex')
  | _ -> (mx, ex)

(** val sFcompare : spec_float -> spec_float -> comparison option **)

let sFcompare f1 f2 =
  match f1 with
  | S754_zero _ ->
    (match f2 with
     | S754_zero _ -> Some Eq
     | S754_infinity s -> Some (if s then Gt else Lt)
     | S754_nan -> None
     | S754_finite (s, _, _) -> Some (if s then Gt else Lt))
  | S754_infinity s ->
    (match f2 with
     | S754_infinity s0 ->
       Some (if s then if s0 then Eq else Lt else if s0 then Gt else Eq)
     | S754_nan -> None
     | _ -> Some (if s then Lt else Gt))
  | S754_nan -> None
  | S754_finite (s1, m1, e1) ->
    (match f2 with
     | S754_zero _ -> Some (if s1 then Lt else Gt)
     | S754_infinity s -> Some (if s then Gt else Lt)
     | S754_nan -> None
     | S754_finite (s2, m2, e2) ->
       Some
         (if s1
          then if s2
               then (match Z.compare e1 e2 with
                     | Eq -> compOpp (Pos.compare_cont Eq m1 m2)
                     | Lt -> Gt
                     | Gt -> Lt)
               else Lt
          else if s2
               then Gt
               else (match Z.compare e1 e2 with
                     | Eq -> Pos.compare_cont Eq m1 m2
                     | x -> x)))

(** val cond_Zopp : bool -> z -> z **)

let cond_Zopp b m =
  if b then Z.opp m else m

(** val new_location_even : z -> z -> location **)

let new_location_even nb_steps k =
  if Z.eqb k Z0
  then Loc_Exact
  else Loc_Inexact (Z.compare (Z.mul (Zpos (XO XH)) k) nb_steps)

(** val new_location_odd : z -> z -> location **)

let new_location_odd nb_steps k =
  if Z.eqb k Z0
  then Loc_Exact
  else Loc_Inexact
         (match Z.compare (Z.add (Z.mul (Zpos (XO XH)) k) (Zpos XH)) nb_steps with
          | Eq -> Lt
          | x -> x)

(** val new_location : z -> z -> location **)

let new_location nb_steps =
  if Z.even nb_steps
  then new_location_even nb_steps
  else new_location_odd nb_steps

(** val sFdiv_core_binary :
    z -> z -> z -> z -> z -> z -> (z * z) * location **)

let sFdiv_core_binary prec emax m1 e1 m2 e2 =
  let d1 = zdigits2 m1 in
  let d2 = zdigits2 m2 in
  let e' =
    Z.min (fexp prec emax (Z.sub (Z.add d1 e1) (Z.add d2 e2))) (Z.sub e1 e2)
  in
  let s = Z.sub (Z.sub e1 e2) e' in
  let m' = match s with
           | Z0 -> m1
           | Zpos _ -> Z.shiftl m1 s
           | Zneg _ -> Z0 in
  let (q, r) = Z.div_eucl m' m2 in ((q, e'), (new_location m2 r))

(** val sFsqrt_core_binary : z -> z -> z -> z -> (z * z) * location **)

let sFsqrt_core_binary prec emax m e =
  let d = zdigits2 m in
  let e' =
    Z.min (fexp prec emax (Z.div2 (Z.add (Z.add d e) (Zpos XH)))) (Z.div2 e)
  in
  let s = Z.sub e (Z.mul (Zpos (XO XH)) e') in
  let m' = match s with
           | Z0 -> m
           | Zpos _ -> Z.shiftl m s
           | Zneg _ -> Z0 in
  let (q, r) = Z.sqrtrem m' in
  let l =
    if Z.eqb r Z0
    then Loc_Exact
    else Loc_Inexact (if Z.leb r q then Lt else Gt)
  in
  ((q, e'), l)

type radix = z
  (* singleton inductive, whose constructor was Build_radix *)

(** val radix2 : radix **)

let radix2 =
  Zpos (XO XH)

(** val iter_nat : ('a1 -> 'a1) -> nat -> 'a1 -> 'a1 **)

let rec iter_nat f n0 x =
  match n0 with
  | O -> x
  | S n' -> iter_nat f n' (f x)

(** val cond_incr : bool -> z -> z **)

let cond_incr b m =
  if b then Coq_Z.add m (Zpos XH) else m

(** val round_sign_DN : bool -> location -> bool **)

let round_sign_DN s = function
| Loc_Exact -> false
| Loc_Inexact _ -> s

(** val round_sign_UP : bool -> location -> bool **)

let round_sign_UP s = function
| Loc_Exact -> false
| Loc_Inexact _ -> negb s

(** val round_N : bool -> location -> bool **)

let round_N p = function
| Loc_Exact -> false
| Loc_Inexact c -> (match c with
                    | Eq -> p
                    | Lt -> false
                    | Gt -> true)

type binary_float =
| B754_zero of bool
| B754_infinity of bool
| B754_nan
| B754_finite of bool * positive * z

(** val sF2B : z -> z -> spec_float -> binary_float **)

let sF2B _ _ = function
| S754_zero s -> B754_zero s
| S754_infinity s -> B754_infinity s
| S754_nan -> B754_nan
| S754_finite (s, m, e) -> B754_finite (s, m, e)

(** val b2SF : z -> z -> binary_float -> spec_float **)

let b2SF _ _ = function
| B754_zero s -> S754_zero s
| B754_infinity s -> S754_infinity s
| B754_nan -> S754_nan
| B754_finite (s, m, e) -> S754_finite (s, m, e)

(** val bcompare :
    z -> z -> binary_float -> binary_float -> comparison option **)

let bcompare prec emax f1 f2 =
  sFcompare (b2SF prec emax f1) (b2SF prec emax f2)

type mode =
| Mode_NE
| Mode_ZR
| Mode_DN
| Mode_UP
| Mode_NA

(** val choice_mode : mode -> bool -> z -> location -> z **)

let choice_mode m sx mx lx =
  match m with
  | Mode_NE -> cond_incr (round_N (negb (Coq_Z.even mx)) lx) mx
  | Mode_ZR -> mx
  | Mode_DN -> cond_incr (round_sign_DN sx lx) mx
  | Mode_UP -> cond_incr (round_sign_UP sx lx) mx
  | Mode_NA -> cond_incr (round_N true lx) mx

(** val overflow_to_inf : mode -> bool -> bool **)

let overflow_to_inf m s =
  match m with
  | Mode_ZR -> false
  | Mode_DN -> s
  | Mode_UP -> negb s
  | _ -> true

(** val binary_overflow : z -> z -> mode -> bool -> spec_float **)

let binary_overflow prec emax m s =
  if overflow_to_inf m s
  then S754_infinity s
  else S754_finite (s,
         (Coq_Z.to_pos (Coq_Z.sub (Coq_Z.pow (Zpos (XO XH)) prec) (Zpos XH))),
         (Coq_Z.sub emax prec))

(** val binary_fit_aux :
    z -> z -> mode -> bool -> positive -> z -> spec_float **)

let binary_fit_aux prec emax mode1 sx mx ex =
  if Coq_Z.leb ex (Coq_Z.sub emax prec)
  then S754_finite (sx, mx, ex)
  else binary_overflow prec emax mode1 sx

(** val binary_round_aux :
    z -> z -> mode -> bool -> z -> z -> location -> spec_float **)

let binary_round_aux prec emax mode1 sx mx ex lx =
  let (mrs', e') = shr_fexp prec emax mx ex lx in
  let (mrs'', e'') =
    shr_fexp prec emax
      (choice_mode mode1 sx mrs'.shr_m (loc_of_shr_record mrs')) e' Loc_Exact
  in
  (match mrs''.shr_m with
   | Z0 -> S754_zero sx
   | Zpos m -> binary_fit_aux prec emax mode1 sx m e''
   | Zneg _ -> S754_nan)

(** val bmult :
    z -> z -> mode -> binary_float -> binary_float -> binary_float **)

let bmult prec emax m x y =
  match x with
  | B754_zero sx ->
    (match y with
     | B754_zero sy -> B754_zero (xorb sx sy)
     | B754_finite (sy, _, _) -> B754_zero (xorb sx sy)
     | _ -> B754_nan)
  | B754_infinity sx ->
    (match y with
     | B754_infinity sy -> B754_infinity (xorb sx sy)
     | B754_finite (sy, _, _) -> B754_infinity (xorb sx sy)
     | _ -> B754_nan)
  | B754_nan -> B754_nan
  | B754_finite (sx, mx, ex) ->
    (match y with
     | B754_zero sy -> B754_zero (xorb sx sy)
     | B754_infinity sy -> B754_infinity (xorb sx sy)
     | B754_nan -> B754_nan
     | B754_finite (sy, my, ey) ->
       sF2B prec emax
         (binary_round_aux prec emax m (xorb sx sy) (Zpos
           (Coq_Pos.mul mx my)) (Coq_Z.add ex ey) Loc_Exact))

(** val shl_align_fexp : z -> z -> positive -> z -> positive * z **)

let shl_align_fexp prec emax mx ex =
  shl_align mx ex (fexp prec emax (Coq_Z.add (Zpos (digits2_pos mx)) ex))

(** val binary_round :
    z -> z -> mode -> bool -> positive -> z -> spec_float **)

let binary_round prec emax m sx mx ex =
  let (mz, ez) = shl_align_fexp prec emax mx ex in
  binary_round_aux prec emax m sx (Zpos mz) ez Loc_Exact

(** val binary_normalize :
    z -> z -> mode -> z -> z -> bool -> binary_float **)

let binary_normalize prec emax mode1 m e szero =
  match m with
  | Z0 -> B754_zero szero
  | Zpos m0 -> sF2B prec emax (binary_round prec emax mode1 false m0 e)
  | Zneg m0 -> sF2B prec emax (binary_round prec emax mode1 true m0 e)

(** val fplus_naive :
    bool -> positive -> z -> bool -> positive -> z -> z -> z **)

let fplus_naive sx mx ex sy my ey ez =
  Coq_Z.add (cond_Zopp sx (Zpos (fst (shl_align mx ex ez))))
    (cond_Zopp sy (Zpos (fst (shl_align my ey ez))))

(** val bplus :
    z -> z -> mode -> binary_float -> binary_float -> binary_float **)

let bplus prec emax m x y =
  match x with
  | B754_zero sx ->
    (match y with
     | B754_zero sy ->
       if eqb sx sy
       then x
       else (match m with
             | Mode_DN -> B754_zero true
             | _ -> B754_zero false)
     | B754_nan -> B754_nan
     | _ -> y)
  | B754_infinity sx ->
    (match y with
     | B754_infinity sy -> if eqb sx sy then x else B754_nan
     | B754_nan -> B754_nan
     | _ -> x)
  | B754_nan -> B754_nan
  | B754_finite (sx, mx, ex) ->
    (match y with
     | B754_zero _ -> x
     | B754_infinity _ -> y
     | B754_nan -> B754_nan
     | B754_finite (sy, my, ey) ->
       let ez = Coq_Z.min ex ey in
       binary_normalize prec emax m (fplus_naive sx mx ex sy my ey ez) ez
         (match m with
          | Mode_DN -> true
          | _ -> false))

(** val bminus :
    z -> z -> mode -> binary_float -> binary_float -> binary_float **)

let bminus prec emax m x y =
  match x with
  | B754_zero sx ->
    (match y with
     | B754_zero sy ->
       if eqb sx (negb sy)
       then x
       else (match m with
             | Mode_DN -> B754_zero true
             | _ -> B754_zero false)
     | B754_infinity sy -> B754_infinity (negb sy)
     | B754_nan -> B754_nan
     | B754_finite (sy, my, ey) -> B754_finite ((negb sy), my, ey))
  | B754_infinity sx ->
    (match y with
     | B754_infinity sy -> if eqb sx (negb sy) then x else B754_nan
     | B754_nan -> B754_nan
     | _ -> x)
  | B754_nan -> B754_nan
  | B754_finite (sx, mx, ex) ->
    (match y with
     | B754_zero _ -> x
     | B754_infinity sy -> B754_infinity (negb sy)
     | B754_nan -> B754_nan
     | B754_finite (sy, my, ey) ->
       let ez = Coq_Z.min ex ey in
       binary_normalize prec emax m (fplus_naive sx mx ex (negb sy) my ey ez)
         ez (match m with
             | Mode_DN -> true
             | _ -> false))

(** val bdiv :
    z -> z -> mode -> binary_float -> binary_float -> binary_float **)

let bdiv prec emax m x y =
  match x with
  | B754_zero sx ->
    (match y with
     | B754_infinity sy -> B754_zero (xorb sx sy)
     | B754_finite (sy, _, _) -> B754_zero (xorb sx sy)
     | _ -> B754_nan)
  | B754_infinity sx ->
    (match y with
     | B754_zero sy -> B754_infinity (xorb sx sy)
     | B754_finite (sy, _, _) -> B754_infinity (xorb sx sy)
     | _ -> B754_nan)
  | B754_nan -> B754_nan
  | B754_finite (sx, mx, ex) ->
    (match y with
     | B754_zero sy -> B754_infinity (xorb sx sy)
     | B754_infinity sy -> B754_zero (xorb sx sy)
     | B754_nan -> B754_nan
     | B754_finite (sy, my, ey) ->
       sF2B prec emax
         (let (p, lz) = sFdiv_core_binary prec emax (Zpos mx) ex (Zpos my) ey
          in
          let (mz, ez) = p in
          binary_round_aux prec emax m (xorb sx sy) mz ez lz))

(** val bsqrt : z -> z -> mode -> binary_float -> binary_float **)

let bsqrt prec emax m x = match x with
| B754_zero _ -> x
| B754_infinity s -> if s then B754_nan else x
| B754_nan -> B754_nan
| B754_finite (sx, mx, ex) ->
  if sx
  then B754_nan
  else sF2B prec emax
         (let (p, lz) = sFsqrt_core_binary prec emax (Zpos mx) ex in
          let (mz, ez) = p in binary_round_aux prec emax m false mz ez lz)

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

(** val b2BSN : z -> z -> binary_float0 -> binary_float **)

let b2BSN _ _ = function
| B754_zero0 s -> B754_zero s
| B754_infinity0 s -> B754_infinity s
| B754_nan0 (_, _) -> B754_nan
| B754_finite0 (s, m, e) -> B754_finite (s, m, e)

(** val fF2B : z -> z -> full_float -> binary_float0 **)

let fF2B _ _ = function
| F754_zero s -> B754_zero0 s
| F754_infinity s -> B754_infinity0 s
| F754_nan (b, pl) -> B754_nan0 (b, pl)
| F754_finite (s, m, e) -> B754_finite0 (s, m, e)

(** val bsign : z -> z -> binary_float0 -> bool **)

let bsign _ _ = function
| B754_zero0 s -> s
| B754_infinity0 s -> s
| B754_nan0 (s, _) -> s
| B754_finite0 (s, _, _) -> s

(** val get_nan_pl : z -> z -> binary_float0 -> positive **)

let get_nan_pl _ _ = function
| B754_nan0 (_, pl) -> pl
| _ -> XH

(** val build_nan : z -> z -> binary_float0 -> binary_float0 **)

let build_nan prec emax x =
  B754_nan0 ((bsign prec emax x), (get_nan_pl prec emax x))

(** val bSN2B : z -> z -> binary_float0 -> binary_float -> binary_float0 **)

let bSN2B prec emax nan = function
| B754_zero s -> B754_zero0 s
| B754_infinity s -> B754_infinity0 s
| B754_nan -> build_nan prec emax nan
| B754_finite (s, m, e) -> B754_finite0 (s, m, e)

(** val bSN2B' : z -> z -> binary_float -> binary_float0 **)

let bSN2B' _ _ = function
| B754_zero s -> B754_zero0 s
| B754_infinity s -> B754_infinity0 s
| B754_nan -> assert false (* absurd case *)
| B754_finite (s, m, e) -> B754_finite0 (s, m, e)

(** val bopp :
    z -> z -> (binary_float0 -> binary_float0) -> binary_float0 ->
    binary_float0 **)

let bopp prec emax opp_nan x = match x with
| B754_zero0 sx -> B754_zero0 (negb sx)
| B754_infinity0 sx -> B754_infinity0 (negb sx)
| B754_nan0 (_, _) -> build_nan prec emax (opp_nan x)
| B754_finite0 (sx, mx, ex) -> B754_finite0 ((negb sx), mx, ex)

(** val babs :
    z -> z -> (binary_float0 -> binary_float0) -> binary_float0 ->
    binary_float0 **)

let babs prec emax abs_nan0 x = match x with
| B754_zero0 _ -> B754_zero0 false
| B754_infinity0 _ -> B754_infinity0 false
| B754_nan0 (_, _) -> build_nan prec emax (abs_nan0 x)
| B754_finite0 (_, mx, ex) -> B754_finite0 (false, mx, ex)

(** val bcompare0 :
    z -> z -> binary_float0 -> binary_float0 -> comparison option **)

let bcompare0 prec emax f1 f2 =
  bcompare prec emax (b2BSN prec emax f1) (b2BSN prec emax f2)

(** val bmult0 :
    z -> z -> (binary_float0 -> binary_float0 -> binary_float0) -> mode ->
    binary_float0 -> binary_float0 -> binary_float0 **)

let bmult0 prec emax mult_nan m x y =
  bSN2B prec emax (mult_nan x y)
    (bmult prec emax m (b2BSN prec emax x) (b2BSN prec emax y))

(** val binary_normalize0 :
    z -> z -> mode -> z -> z -> bool -> binary_float0 **)

let binary_normalize0 prec emax mode1 m e szero =
  bSN2B' prec emax (binary_normalize prec emax mode1 m e szero)

(** val bplus0 :
    z -> z -> (binary_float0 -> binary_float0 -> binary_float0) -> mode ->
    binary_float0 -> binary_float0 -> binary_float0 **)

let bplus0 prec emax plus_nan m x y =
  bSN2B prec emax (plus_nan x y)
    (bplus prec emax m (b2BSN prec emax x) (b2BSN prec emax y))

(** val bminus0 :
    z -> z -> (binary_float0 -> binary_float0 -> binary_float0) -> mode ->
    binary_float0 -> binary_float0 -> binary_float0 **)

let bminus0 prec emax minus_nan m x y =
  bSN2B prec emax (minus_nan x y)
    (bminus prec emax m (b2BSN prec emax x) (b2BSN prec emax y))

(** val bdiv0 :
    z -> z -> (binary_float0 -> binary_float0 -> binary_float0) -> mode ->
    binary_float0 -> binary_float0 -> binary_float0 **)

let bdiv0 prec emax div_nan m x y =
  bSN2B prec emax (div_nan x y)
    (bdiv prec emax m (b2BSN prec emax x) (b2BSN prec emax y))

(** val bsqrt0 :
    z -> z -> (binary_float0 -> binary_float0) -> mode -> binary_float0 ->
    binary_float0 **)

let bsqrt0 prec emax sqrt_nan m x =
  bSN2B prec emax (sqrt_nan x) (bsqrt prec emax m (b2BSN prec emax x))

(** val join_bits : z -> z -> bool -> z -> z -> z **)

let join_bits mw ew s m e =
  Coq_Z.add
    (Coq_Z.shiftl
      (Coq_Z.add (if s then Coq_Z.pow (Zpos (XO XH)) ew else Z0) e) mw)
    m

(** val split_bits : z -> z -> z -> (bool * z) * z **)

let split_bits mw ew x =
  let mm = Coq_Z.pow (Zpos (XO XH)) mw in
  let em = Coq_Z.pow (Zpos (XO XH)) ew in
  (((Coq_Z.leb (Coq_Z.mul mm em) x), (Coq_Z.modulo x mm)),
  (Coq_Z.modulo (Coq_Z.div x mm) em))

(** val bits_of_binary_float : z -> z -> binary_float0 -> z **)

let bits_of_binary_float mw ew =
  let prec = Coq_Z.add mw (Zpos XH) in
  let emax = Coq_Z.pow (Zpos (XO XH)) (Coq_Z.sub ew (Zpos XH)) in
  (fun x ->
  match x with
  | B754_zero0 sx -> join_bits mw ew sx Z0 Z0
  | B754_infinity0 sx ->
    join_bits mw ew sx Z0 (Coq_Z.sub (Coq_Z.pow (Zpos (XO XH)) ew) (Zpos XH))
  | B754_nan0 (sx, plx) ->
    join_bits mw ew sx (Zpos plx)
      (Coq_Z.sub (Coq_Z.pow (Zpos (XO XH)) ew) (Zpos XH))
  | B754_finite0 (sx, mx, ex) ->
    let m = Coq_Z.sub (Zpos mx) (Coq_Z.pow (Zpos (XO XH)) mw) in
    if Coq_Z.leb Z0 m
    then join_bits mw ew sx m
           (Coq_Z.add (Coq_Z.sub ex (emin prec emax)) (Zpos XH))
    else join_bits mw ew sx (Zpos mx) Z0)

(** val binary_float_of_bits_aux : z -> z -> z -> full_float **)

let binary_float_of_bits_aux mw ew =
  let prec = Coq_Z.add mw (Zpos XH) in
  let emax = Coq_Z.pow (Zpos (XO XH)) (Coq_Z.sub ew (Zpos XH)) in
  (fun x ->
  let (p, ex) = split_bits mw ew x in
  let (sx, mx) = p in
  if Coq_Z.eqb ex Z0
  then (match mx with
        | Z0 -> F754_zero sx
        | Zpos px -> F754_finite (sx, px, (emin prec emax))
        | Zneg _ -> F754_nan (false, XH))
  else if Coq_Z.eqb ex (Coq_Z.sub (Coq_Z.pow (Zpos (XO XH)) ew) (Zpos XH))
       then (match mx with
             | Z0 -> F754_infinity sx
             | Zpos plx -> F754_nan (sx, plx)
             | Zneg _ -> F754_nan (false, XH))
       else (match Coq_Z.add mx (Coq_Z.pow (Zpos (XO XH)) mw) with
             | Zpos px ->
               F754_finite (sx, px,
                 (Coq_Z.sub (Coq_Z.add ex (emin prec emax)) (Zpos XH)))
             | _ -> F754_nan (false, XH)))

(** val binary_float_of_bits : z -> z -> z -> binary_float0 **)

let binary_float_of_bits mw ew x =
  let prec = Coq_Z.add mw (Zpos XH) in
  let emax = Coq_Z.pow (Zpos (XO XH)) (Coq_Z.sub ew (Zpos XH)) in
  fF2B prec emax (binary_float_of_bits_aux mw ew x)

type binary32 = binary_float0

(** val b32_of_bits : z -> binary32 **)

let b32_of_bits =
  binary_float_of_bits (Zpos (XI (XI (XI (XO XH))))) (Zpos (XO (XO (XO XH))))

(** val bits_of_b32 : binary32 -> z **)

let bits_of_b32 =
  bits_of_binary_float (Zpos (XI (XI (XI (XO XH))))) (Zpos (XO (XO (XO XH))))

type binary64 = binary_float0

(** val b64_of_bits : z -> binary64 **)

let b64_of_bits =
  binary_float_of_bits (Zpos (XO (XO (XI (XO (XI XH)))))) (Zpos (XI (XI (XO
    XH))))

(** val bits_of_b64 : binary64 -> z **)

let bits_of_b64 =
  bits_of_binary_float (Zpos (XO (XO (XI (XO (XI XH)))))) (Zpos (XI (XI (XO
    XH))))

(** val ptr64 : bool **)

let ptr64 =
  true

(** val big_endian : bool **)

let big_endian =
  false

(** val align_int64 : z **)

let align_int64 =
  Zpos (XO (XO (XO XH)))

(** val align_float64 : z **)

let align_float64 =
  Zpos (XO (XO (XO XH)))

(** val default_nan_64 : bool * positive **)

let default_nan_64 =
  (true,
    (let rec f = function
     | O -> XH
     | S n1 -> XO (f n1)
     in f (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
          (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
          (S (S (S (S (S (S (S
          O)))))))))))))))))))))))))))))))))))))))))))))))))))))

(** val default_nan_32 : bool * positive **)

let default_nan_32 =
  (true,
    (let rec f = function
     | O -> XH
     | S n1 -> XO (f n1)
     in f (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
          O))))))))))))))))))))))))

(** val choose_nan_64 : (bool * positive) list -> bool * positive **)

let choose_nan_64 = function
| [] -> default_nan_64
| n0 :: _ -> n0

(** val choose_nan_32 : (bool * positive) list -> bool * positive **)

let choose_nan_32 = function
| [] -> default_nan_32
| n0 :: _ -> n0

(** val float_of_single_preserves_sNaN : bool **)

let float_of_single_preserves_sNaN =
  false

(** val float_conversion_default_nan : bool **)

let float_conversion_default_nan =
  false

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

module Make =
 functor (WS:WORDSIZE) ->
 struct
  (** val wordsize : nat **)

  let wordsize =
    WS.wordsize

  (** val zwordsize : z **)

  let zwordsize =
    Coq_Z.of_nat wordsize

  (** val modulus : z **)

  let modulus =
    two_power_nat wordsize

  (** val half_modulus : z **)

  let half_modulus =
    Coq_Z.div modulus (Zpos (XO XH))

  (** val max_unsigned : z **)

  let max_unsigned =
    Coq_Z.sub modulus (Zpos XH)

  (** val max_signed : z **)

  let max_signed =
    Coq_Z.sub half_modulus (Zpos XH)

  (** val min_signed : z **)

  let min_signed =
    Coq_Z.opp half_modulus

  type int = z
    (* singleton inductive, whose constructor was mkint *)

  (** val intval : int -> z **)

  let intval i =
    i

  (** val coq_Z_mod_modulus : z -> z **)

  let coq_Z_mod_modulus = function
  | Z0 -> Z0
  | Zpos p -> p_mod_two_p p wordsize
  | Zneg p ->
    let r = p_mod_two_p p wordsize in
    if zeq r Z0 then Z0 else Coq_Z.sub modulus r

  (** val unsigned : int -> z **)

  let unsigned n0 =
    n0

  (** val signed : int -> z **)

  let signed n0 =
    let x = unsigned n0 in
    if zlt x half_modulus then x else Coq_Z.sub x modulus

  (** val repr : z -> int **)

  let repr =
    coq_Z_mod_modulus

  (** val zero : int **)

  let zero =
    repr Z0

  (** val one : int **)

  let one =
    repr (Zpos XH)

  (** val mone : int **)

  let mone =
    repr (Zneg XH)

  (** val iwordsize : int **)

  let iwordsize =
    repr zwordsize

  (** val eq_dec : int -> int -> bool **)

  let eq_dec =
    zeq

  (** val eq : int -> int -> bool **)

  let eq x y =
    if zeq (unsigned x) (unsigned y) then true else false

  (** val lt : int -> int -> bool **)

  let lt x y =
    if zlt (signed x) (signed y) then true else false

  (** val ltu : int -> int -> bool **)

  let ltu x y =
    if zlt (unsigned x) (unsigned y) then true else false

  (** val neg : int -> int **)

  let neg x =
    repr (Coq_Z.opp (unsigned x))

  (** val add : int -> int -> int **)

  let add x y =
    repr (Coq_Z.add (unsigned x) (unsigned y))

  (** val sub : int -> int -> int **)

  let sub x y =
    repr (Coq_Z.sub (unsigned x) (unsigned y))

  (** val mul : int -> int -> int **)

  let mul x y =
    repr (Coq_Z.mul (unsigned x) (unsigned y))

  (** val divs : int -> int -> int **)

  let divs x y =
    repr (Coq_Z.quot (signed x) (signed y))

  (** val mods : int -> int -> int **)

  let mods x y =
    repr (Coq_Z.rem (signed x) (signed y))

  (** val divu : int -> int -> int **)

  let divu x y =
    repr (Coq_Z.div (unsigned x) (unsigned y))

  (** val modu : int -> int -> int **)

  let modu x y =
    repr (Coq_Z.modulo (unsigned x) (unsigned y))

  (** val coq_and : int -> int -> int **)

  let coq_and x y =
    repr (Coq_Z.coq_land (unsigned x) (unsigned y))

  (** val coq_or : int -> int -> int **)

  let coq_or x y =
    repr (Coq_Z.coq_lor (unsigned x) (unsigned y))

  (** val xor : int -> int -> int **)

  let xor x y =
    repr (Coq_Z.coq_lxor (unsigned x) (unsigned y))

  (** val not : int -> int **)

  let not x =
    xor x mone

  (** val shl : int -> int -> int **)

  let shl x y =
    repr (Coq_Z.shiftl (unsigned x) (unsigned y))

  (** val shru : int -> int -> int **)

  let shru x y =
    repr (Coq_Z.shiftr (unsigned x) (unsigned y))

  (** val shr : int -> int -> int **)

  let shr x y =
    repr (Coq_Z.shiftr (signed x) (unsigned y))

  (** val rol : int -> int -> int **)

  let rol x y =
    let n0 = Coq_Z.modulo (unsigned y) zwordsize in
    repr
      (Coq_Z.coq_lor (Coq_Z.shiftl (unsigned x) n0)
        (Coq_Z.shiftr (unsigned x) (Coq_Z.sub zwordsize n0)))

  (** val ror : int -> int -> int **)

  let ror x y =
    let n0 = Coq_Z.modulo (unsigned y) zwordsize in
    repr
      (Coq_Z.coq_lor (Coq_Z.shiftr (unsigned x) n0)
        (Coq_Z.shiftl (unsigned x) (Coq_Z.sub zwordsize n0)))

  (** val rolm : int -> int -> int -> int **)

  let rolm x a m =
    coq_and (rol x a) m

  (** val shrx : int -> int -> int **)

  let shrx x y =
    divs x (shl one y)

  (** val mulhu : int -> int -> int **)

  let mulhu x y =
    repr (Coq_Z.div (Coq_Z.mul (unsigned x) (unsigned y)) modulus)

  (** val mulhs : int -> int -> int **)

  let mulhs x y =
    repr (Coq_Z.div (Coq_Z.mul (signed x) (signed y)) modulus)

  (** val negative : int -> int **)

  let negative x =
    if lt x zero then one else zero

  (** val add_carry : int -> int -> int -> int **)

  let add_carry x y cin =
    if zlt (Coq_Z.add (Coq_Z.add (unsigned x) (unsigned y)) (unsigned cin))
         modulus
    then zero
    else one

  (** val add_overflow : int -> int -> int -> int **)

  let add_overflow x y cin =
    let s = Coq_Z.add (Coq_Z.add (signed x) (signed y)) (signed cin) in
    if (&&) (proj_sumbool (zle min_signed s))
         (proj_sumbool (zle s max_signed))
    then zero
    else one

  (** val sub_borrow : int -> int -> int -> int **)

  let sub_borrow x y bin =
    if zlt (Coq_Z.sub (Coq_Z.sub (unsigned x) (unsigned y)) (unsigned bin)) Z0
    then one
    else zero

  (** val sub_overflow : int -> int -> int -> int **)

  let sub_overflow x y bin =
    let s = Coq_Z.sub (Coq_Z.sub (signed x) (signed y)) (signed bin) in
    if (&&) (proj_sumbool (zle min_signed s))
         (proj_sumbool (zle s max_signed))
    then zero
    else one

  (** val shr_carry : int -> int -> int **)

  let shr_carry x y =
    if (&&) (lt x zero) (negb (eq (coq_and x (sub (shl one y) one)) zero))
    then one
    else zero

  (** val zero_ext : z -> int -> int **)

  let zero_ext n0 x =
    repr (zzero_ext n0 (unsigned x))

  (** val sign_ext : z -> int -> int **)

  let sign_ext n0 x =
    repr (zsign_ext n0 (unsigned x))

  (** val one_bits : int -> int list **)

  let one_bits x =
    map repr (z_one_bits wordsize (unsigned x) Z0)

  (** val is_power2 : int -> int option **)

  let is_power2 x =
    match z_is_power2 (unsigned x) with
    | Some i -> Some (repr i)
    | None -> None

  (** val cmp : comparison0 -> int -> int -> bool **)

  let cmp c x y =
    match c with
    | Ceq -> eq x y
    | Cne -> negb (eq x y)
    | Clt -> lt x y
    | Cle -> negb (lt y x)
    | Cgt -> lt y x
    | Cge -> negb (lt x y)

  (** val cmpu : comparison0 -> int -> int -> bool **)

  let cmpu c x y =
    match c with
    | Ceq -> eq x y
    | Cne -> negb (eq x y)
    | Clt -> ltu x y
    | Cle -> negb (ltu y x)
    | Cgt -> ltu y x
    | Cge -> negb (ltu x y)

  (** val notbool : int -> int **)

  let notbool x =
    if eq x zero then one else zero

  (** val divmodu2 : int -> int -> int -> (int * int) option **)

  let divmodu2 nhi nlo d =
    if eq_dec d zero
    then None
    else let (q, r) =
           Coq_Z.div_eucl
             (Coq_Z.add (Coq_Z.mul (unsigned nhi) modulus) (unsigned nlo))
             (unsigned d)
         in
         if zle q max_unsigned then Some ((repr q), (repr r)) else None

  (** val divmods2 : int -> int -> int -> (int * int) option **)

  let divmods2 nhi nlo d =
    if eq_dec d zero
    then None
    else let (q, r) =
           Coq_Z.quotrem
             (Coq_Z.add (Coq_Z.mul (signed nhi) modulus) (unsigned nlo))
             (signed d)
         in
         if (&&) (proj_sumbool (zle min_signed q))
              (proj_sumbool (zle q max_signed))
         then Some ((repr q), (repr r))
         else None

  (** val testbit : int -> z -> bool **)

  let testbit x i =
    Coq_Z.testbit (unsigned x) i

  (** val int_of_one_bits : int list -> int **)

  let rec int_of_one_bits = function
  | [] -> zero
  | a :: b -> add (shl one a) (int_of_one_bits b)

  (** val no_overlap : int -> z -> int -> z -> bool **)

  let no_overlap ofs1 sz1 ofs2 sz2 =
    let x1 = unsigned ofs1 in
    let x2 = unsigned ofs2 in
    (&&)
      ((&&) (proj_sumbool (zlt (Coq_Z.add x1 sz1) modulus))
        (proj_sumbool (zlt (Coq_Z.add x2 sz2) modulus)))
      ((||) (proj_sumbool (zle (Coq_Z.add x1 sz1) x2))
        (proj_sumbool (zle (Coq_Z.add x2 sz2) x1)))

  (** val size : int -> z **)

  let size x =
    zsize (unsigned x)

  (** val unsigned_bitfield_extract : z -> z -> int -> int **)

  let unsigned_bitfield_extract pos width n0 =
    zero_ext width (shru n0 (repr pos))

  (** val signed_bitfield_extract : z -> z -> int -> int **)

  let signed_bitfield_extract pos width n0 =
    sign_ext width (shru n0 (repr pos))

  (** val bitfield_insert : z -> z -> int -> int -> int **)

  let bitfield_insert pos width n0 p =
    let mask0 = shl (repr (Coq_Z.sub (two_p width) (Zpos XH))) (repr pos) in
    coq_or (shl (zero_ext width p) (repr pos)) (coq_and n0 (not mask0))
 end

module Wordsize_32 =
 struct
  (** val wordsize : nat **)

  let wordsize =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      (S (S (S (S (S (S (S O)))))))))))))))))))))))))))))))
 end

module Int = Make(Wordsize_32)

module Wordsize_8 =
 struct
  (** val wordsize : nat **)

  let wordsize =
    S (S (S (S (S (S (S (S O)))))))
 end

module Byte = Make(Wordsize_8)

module Wordsize_64 =
 struct
  (** val wordsize : nat **)

  let wordsize =
    S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      O)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))
 end

module Int64 =
 struct
  (** val wordsize : nat **)

  let wordsize =
    Wordsize_64.wordsize

  (** val zwordsize : z **)

  let zwordsize =
    Coq_Z.of_nat wordsize

  (** val modulus : z **)

  let modulus =
    two_power_nat wordsize

  (** val half_modulus : z **)

  let half_modulus =
    Coq_Z.div modulus (Zpos (XO XH))

  (** val max_unsigned : z **)

  let max_unsigned =
    Coq_Z.sub modulus (Zpos XH)

  (** val max_signed : z **)

  let max_signed =
    Coq_Z.sub half_modulus (Zpos XH)

  (** val min_signed : z **)

  let min_signed =
    Coq_Z.opp half_modulus

  type int = z
    (* singleton inductive, whose constructor was mkint *)

  (** val intval : int -> z **)

  let intval i =
    i

  (** val coq_Z_mod_modulus : z -> z **)

  let coq_Z_mod_modulus = function
  | Z0 -> Z0
  | Zpos p -> p_mod_two_p p wordsize
  | Zneg p ->
    let r = p_mod_two_p p wordsize in
    if zeq r Z0 then Z0 else Coq_Z.sub modulus r

  (** val unsigned : int -> z **)

  let unsigned n0 =
    n0

  (** val signed : int -> z **)

  let signed n0 =
    let x = unsigned n0 in
    if zlt x half_modulus then x else Coq_Z.sub x modulus

  (** val repr : z -> int **)

  let repr =
    coq_Z_mod_modulus

  (** val zero : int **)

  let zero =
    repr Z0

  (** val mone : int **)

  let mone =
    repr (Zneg XH)

  (** val iwordsize : int **)

  let iwordsize =
    repr zwordsize

  (** val eq_dec : int -> int -> bool **)

  let eq_dec =
    zeq

  (** val eq : int -> int -> bool **)

  let eq x y =
    if zeq (unsigned x) (unsigned y) then true else false

  (** val lt : int -> int -> bool **)

  let lt x y =
    if zlt (signed x) (signed y) then true else false

  (** val ltu : int -> int -> bool **)

  let ltu x y =
    if zlt (unsigned x) (unsigned y) then true else false

  (** val neg : int -> int **)

  let neg x =
    repr (Coq_Z.opp (unsigned x))

  (** val add : int -> int -> int **)

  let add x y =
    repr (Coq_Z.add (unsigned x) (unsigned y))

  (** val sub : int -> int -> int **)

  let sub x y =
    repr (Coq_Z.sub (unsigned x) (unsigned y))

  (** val mul : int -> int -> int **)

  let mul x y =
    repr (Coq_Z.mul (unsigned x) (unsigned y))

  (** val divs : int -> int -> int **)

  let divs x y =
    repr (Coq_Z.quot (signed x) (signed y))

  (** val mods : int -> int -> int **)

  let mods x y =
    repr (Coq_Z.rem (signed x) (signed y))

  (** val divu : int -> int -> int **)

  let divu x y =
    repr (Coq_Z.div (unsigned x) (unsigned y))

  (** val modu : int -> int -> int **)

  let modu x y =
    repr (Coq_Z.modulo (unsigned x) (unsigned y))

  (** val coq_and : int -> int -> int **)

  let coq_and x y =
    repr (Coq_Z.coq_land (unsigned x) (unsigned y))

  (** val coq_or : int -> int -> int **)

  let coq_or x y =
    repr (Coq_Z.coq_lor (unsigned x) (unsigned y))

  (** val xor : int -> int -> int **)

  let xor x y =
    repr (Coq_Z.coq_lxor (unsigned x) (unsigned y))

  (** val not : int -> int **)

  let not x =
    xor x mone

  (** val shl : int -> int -> int **)

  let shl x y =
    repr (Coq_Z.shiftl (unsigned x) (unsigned y))

  (** val shru : int -> int -> int **)

  let shru x y =
    repr (Coq_Z.shiftr (unsigned x) (unsigned y))

  (** val shr : int -> int -> int **)

  let shr x y =
    repr (Coq_Z.shiftr (signed x) (unsigned y))

  (** val mulhu : int -> int -> int **)

  let mulhu x y =
    repr (Coq_Z.div (Coq_Z.mul (unsigned x) (unsigned y)) modulus)

  (** val mulhs : int -> int -> int **)

  let mulhs x y =
    repr (Coq_Z.div (Coq_Z.mul (signed x) (signed y)) modulus)

  (** val cmp : comparison0 -> int -> int -> bool **)

  let cmp c x y =
    match c with
    | Ceq -> eq x y
    | Cne -> negb (eq x y)
    | Clt -> lt x y
    | Cle -> negb (lt y x)
    | Cgt -> lt y x
    | Cge -> negb (lt x y)

  (** val cmpu : comparison0 -> int -> int -> bool **)

  let cmpu c x y =
    match c with
    | Ceq -> eq x y
    | Cne -> negb (eq x y)
    | Clt -> ltu x y
    | Cle -> negb (ltu y x)
    | Cgt -> ltu y x
    | Cge -> negb (ltu x y)

  (** val iwordsize' : Int.int **)

  let iwordsize' =
    Int.repr zwordsize

  (** val shl' : int -> Int.int -> int **)

  let shl' x y =
    repr (Coq_Z.shiftl (unsigned x) (Int.unsigned y))

  (** val shru' : int -> Int.int -> int **)

  let shru' x y =
    repr (Coq_Z.shiftr (unsigned x) (Int.unsigned y))

  (** val shr' : int -> Int.int -> int **)

  let shr' x y =
    repr (Coq_Z.shiftr (signed x) (Int.unsigned y))

  (** val loword : int -> Int.int **)

  let loword n0 =
    Int.repr (unsigned n0)

  (** val mul' : Int.int -> Int.int -> int **)

  let mul' x y =
    repr (Coq_Z.mul (Int.unsigned x) (Int.unsigned y))
 end

module Wordsize_Ptrofs =
 struct
  (** val wordsize : nat **)

  let wordsize =
    if ptr64
    then S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
           (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
           (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
           O)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))
    else S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
           (S (S (S (S (S (S (S (S (S O)))))))))))))))))))))))))))))))
 end

module Ptrofs =
 struct
  (** val wordsize : nat **)

  let wordsize =
    Wordsize_Ptrofs.wordsize

  (** val modulus : z **)

  let modulus =
    two_power_nat wordsize

  (** val half_modulus : z **)

  let half_modulus =
    Coq_Z.div modulus (Zpos (XO XH))

  (** val max_signed : z **)

  let max_signed =
    Coq_Z.sub half_modulus (Zpos XH)

  type int = z
    (* singleton inductive, whose constructor was mkint *)

  (** val intval : int -> z **)

  let intval i =
    i

  (** val coq_Z_mod_modulus : z -> z **)

  let coq_Z_mod_modulus = function
  | Z0 -> Z0
  | Zpos p -> p_mod_two_p p wordsize
  | Zneg p ->
    let r = p_mod_two_p p wordsize in
    if zeq r Z0 then Z0 else Coq_Z.sub modulus r

  (** val unsigned : int -> z **)

  let unsigned n0 =
    n0

  (** val signed : int -> z **)

  let signed n0 =
    let x = unsigned n0 in
    if zlt x half_modulus then x else Coq_Z.sub x modulus

  (** val repr : z -> int **)

  let repr =
    coq_Z_mod_modulus

  (** val zero : int **)

  let zero =
    repr Z0

  (** val eq_dec : int -> int -> bool **)

  let eq_dec =
    zeq

  (** val eq : int -> int -> bool **)

  let eq x y =
    if zeq (unsigned x) (unsigned y) then true else false

  (** val ltu : int -> int -> bool **)

  let ltu x y =
    if zlt (unsigned x) (unsigned y) then true else false

  (** val add : int -> int -> int **)

  let add x y =
    repr (Coq_Z.add (unsigned x) (unsigned y))

  (** val sub : int -> int -> int **)

  let sub x y =
    repr (Coq_Z.sub (unsigned x) (unsigned y))

  (** val mul : int -> int -> int **)

  let mul x y =
    repr (Coq_Z.mul (unsigned x) (unsigned y))

  (** val divs : int -> int -> int **)

  let divs x y =
    repr (Coq_Z.quot (signed x) (signed y))

  (** val cmpu : comparison0 -> int -> int -> bool **)

  let cmpu c x y =
    match c with
    | Ceq -> eq x y
    | Cne -> negb (eq x y)
    | Clt -> ltu x y
    | Cle -> negb (ltu y x)
    | Cgt -> ltu y x
    | Cge -> negb (ltu x y)

  (** val to_int : int -> Int.int **)

  let to_int x =
    Int.repr (unsigned x)

  (** val to_int64 : int -> Int64.int **)

  let to_int64 x =
    Int64.repr (unsigned x)

  (** val of_int : Int.int -> int **)

  let of_int x =
    repr (Int.unsigned x)

  (** val of_intu : Int.int -> int **)

  let of_intu =
    of_int

  (** val of_ints : Int.int -> int **)

  let of_ints x =
    repr (Int.signed x)

  (** val of_int64 : Int64.int -> int **)

  let of_int64 x =
    repr (Int64.unsigned x)
 end

(** val beq_dec : z -> z -> binary_float0 -> binary_float0 -> bool **)

let beq_dec _ _ f1 f2 =
  match f1 with
  | B754_zero0 s ->
    (match f2 with
     | B754_zero0 s0 ->
       if s then if s0 then true else false else if s0 then false else true
     | _ -> false)
  | B754_infinity0 s ->
    (match f2 with
     | B754_infinity0 s0 ->
       if s then if s0 then true else false else if s0 then false else true
     | _ -> false)
  | B754_nan0 (s, pl) ->
    (match f2 with
     | B754_nan0 (s0, pl0) ->
       if s
       then if s0 then Coq_Pos.eq_dec pl pl0 else false
       else if s0 then false else Coq_Pos.eq_dec pl pl0
     | _ -> false)
  | B754_finite0 (s, m, e) ->
    (match f2 with
     | B754_finite0 (s0, m0, e1) ->
       if s
       then if s0
            then let s1 = Coq_Pos.eq_dec m m0 in
                 if s1 then Coq_Z.eq_dec e e1 else false
            else false
       else if s0
            then false
            else let s1 = Coq_Pos.eq_dec m m0 in
                 if s1 then Coq_Z.eq_dec e e1 else false
     | _ -> false)

(** val bofZ : z -> z -> z -> binary_float0 **)

let bofZ prec emax n0 =
  binary_normalize0 prec emax Mode_NE n0 Z0 false

(** val zofB : z -> z -> binary_float0 -> z option **)

let zofB _ _ = function
| B754_zero0 _ -> Some Z0
| B754_finite0 (s, m, e1) ->
  (match e1 with
   | Z0 -> Some (cond_Zopp s (Zpos m))
   | Zpos e ->
     Some (Coq_Z.mul (cond_Zopp s (Zpos m)) (Coq_Z.pow_pos radix2 e))
   | Zneg e ->
     Some (cond_Zopp s (Coq_Z.div (Zpos m) (Coq_Z.pow_pos radix2 e))))
| _ -> None

(** val zofB_range : z -> z -> binary_float0 -> z -> z -> z option **)

let zofB_range prec emax f zmin zmax =
  match zofB prec emax f with
  | Some z0 ->
    if (&&) (Coq_Z.leb zmin z0) (Coq_Z.leb z0 zmax) then Some z0 else None
  | None -> None

(** val bconv :
    z -> z -> z -> z -> (binary_float0 -> binary_float0) -> mode ->
    binary_float0 -> binary_float0 **)

let bconv _ _ prec2 emax2 conv_nan md f = match f with
| B754_nan0 (_, _) -> build_nan prec2 emax2 (conv_nan f)
| B754_finite0 (s, m, e) ->
  binary_normalize0 prec2 emax2 md (cond_Zopp s (Zpos m)) e s
| x -> x

type float = binary64

type float32 = binary32

(** val cmp_of_comparison : comparison0 -> comparison option -> bool **)

let cmp_of_comparison c x =
  match c with
  | Ceq ->
    (match x with
     | Some c0 -> (match c0 with
                   | Eq -> true
                   | _ -> false)
     | None -> false)
  | Cne ->
    (match x with
     | Some c0 -> (match c0 with
                   | Eq -> false
                   | _ -> true)
     | None -> true)
  | Clt ->
    (match x with
     | Some c0 -> (match c0 with
                   | Lt -> true
                   | _ -> false)
     | None -> false)
  | Cle ->
    (match x with
     | Some c0 -> (match c0 with
                   | Gt -> false
                   | _ -> true)
     | None -> false)
  | Cgt ->
    (match x with
     | Some c0 -> (match c0 with
                   | Gt -> true
                   | _ -> false)
     | None -> false)
  | Cge ->
    (match x with
     | Some c0 -> (match c0 with
                   | Lt -> false
                   | _ -> true)
     | None -> false)

(** val quiet_nan_64_payload : positive -> positive **)

let quiet_nan_64_payload p =
  Coq_Z.to_pos
    (p_mod_two_p
      (Coq_Pos.coq_lor p
        (iter_nat (fun x -> XO x) (S (S (S (S (S (S (S (S (S (S (S (S (S (S
          (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
          (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
          O))))))))))))))))))))))))))))))))))))))))))))))))))) XH))
      (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      (S (S (S (S O)))))))))))))))))))))))))))))))))))))))))))))))))))))

(** val quiet_nan_64 : (bool * positive) -> float **)

let quiet_nan_64 = function
| (s, p) -> B754_nan0 (s, (quiet_nan_64_payload p))

(** val default_nan_0 : float **)

let default_nan_0 =
  quiet_nan_64 default_nan_64

(** val quiet_nan_32_payload : positive -> positive **)

let quiet_nan_32_payload p =
  Coq_Z.to_pos
    (p_mod_two_p
      (Coq_Pos.coq_lor p
        (iter_nat (fun x -> XO x) (S (S (S (S (S (S (S (S (S (S (S (S (S (S
          (S (S (S (S (S (S (S (S O)))))))))))))))))))))) XH))
      (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      O))))))))))))))))))))))))

(** val quiet_nan_32 : (bool * positive) -> float32 **)

let quiet_nan_32 = function
| (s, p) -> B754_nan0 (s, (quiet_nan_32_payload p))

(** val default_nan_1 : float32 **)

let default_nan_1 =
  quiet_nan_32 default_nan_32

module Float =
 struct
  (** val expand_nan_payload : positive -> positive **)

  let expand_nan_payload p =
    Coq_Pos.shiftl_nat p (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      (S (S (S (S (S (S (S (S (S (S (S (S O)))))))))))))))))))))))))))))

  (** val expand_nan : bool -> positive -> binary_float0 **)

  let expand_nan s p =
    B754_nan0 (s, (expand_nan_payload p))

  (** val of_single_nan : float32 -> float **)

  let of_single_nan = function
  | B754_nan0 (s, p) ->
    if float_conversion_default_nan
    then default_nan_0
    else if float_of_single_preserves_sNaN
         then expand_nan s p
         else quiet_nan_64 (s, (expand_nan_payload p))
  | _ -> default_nan_0

  (** val reduce_nan_payload : positive -> positive **)

  let reduce_nan_payload p =
    Coq_Pos.shiftr_nat (quiet_nan_64_payload p) (S (S (S (S (S (S (S (S (S (S
      (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S
      O)))))))))))))))))))))))))))))

  (** val to_single_nan : float -> float32 **)

  let to_single_nan = function
  | B754_nan0 (s, p) ->
    if float_conversion_default_nan
    then default_nan_1
    else quiet_nan_32 (s, (reduce_nan_payload p))
  | _ -> default_nan_1

  (** val neg_nan : float -> float **)

  let neg_nan = function
  | B754_nan0 (s, p) -> B754_nan0 ((negb s), p)
  | _ -> default_nan_0

  (** val abs_nan : float -> float **)

  let abs_nan = function
  | B754_nan0 (_, p) -> B754_nan0 (false, p)
  | _ -> default_nan_0

  (** val cons_pl :
      float -> (bool * positive) list -> (bool * positive) list **)

  let cons_pl x l =
    match x with
    | B754_nan0 (s, p) -> (s, p) :: l
    | _ -> l

  (** val unop_nan : float -> float **)

  let unop_nan x =
    quiet_nan_64 (choose_nan_64 (cons_pl x []))

  (** val binop_nan : float -> float -> float **)

  let binop_nan x y =
    quiet_nan_64 (choose_nan_64 (cons_pl x (cons_pl y [])))

  (** val zero : float **)

  let zero =
    B754_zero0 false

  (** val eq_dec : float -> float -> bool **)

  let eq_dec =
    beq_dec (Zpos (XI (XO (XI (XO (XI XH)))))) (Zpos (XO (XO (XO (XO (XO (XO
      (XO (XO (XO (XO XH)))))))))))

  (** val neg : float -> float **)

  let neg =
    bopp (Zpos (XI (XO (XI (XO (XI XH)))))) (Zpos (XO (XO (XO (XO (XO (XO (XO
      (XO (XO (XO XH))))))))))) neg_nan

  (** val abs : float -> float **)

  let abs =
    babs (Zpos (XI (XO (XI (XO (XI XH)))))) (Zpos (XO (XO (XO (XO (XO (XO (XO
      (XO (XO (XO XH))))))))))) abs_nan

  (** val sqrt : float -> float **)

  let sqrt =
    bsqrt0 (Zpos (XI (XO (XI (XO (XI XH)))))) (Zpos (XO (XO (XO (XO (XO (XO
      (XO (XO (XO (XO XH))))))))))) unop_nan Mode_NE

  (** val add : float -> float -> float **)

  let add =
    bplus0 (Zpos (XI (XO (XI (XO (XI XH)))))) (Zpos (XO (XO (XO (XO (XO (XO
      (XO (XO (XO (XO XH))))))))))) binop_nan Mode_NE

  (** val sub : float -> float -> float **)

  let sub =
    bminus0 (Zpos (XI (XO (XI (XO (XI XH)))))) (Zpos (XO (XO (XO (XO (XO (XO
      (XO (XO (XO (XO XH))))))))))) binop_nan Mode_NE

  (** val mul : float -> float -> float **)

  let mul =
    bmult0 (Zpos (XI (XO (XI (XO (XI XH)))))) (Zpos (XO (XO (XO (XO (XO (XO
      (XO (XO (XO (XO XH))))))))))) binop_nan Mode_NE

  (** val div : float -> float -> float **)

  let div =
    bdiv0 (Zpos (XI (XO (XI (XO (XI XH)))))) (Zpos (XO (XO (XO (XO (XO (XO
      (XO (XO (XO (XO XH))))))))))) binop_nan Mode_NE

  (** val compare : float -> float -> comparison option **)

  let compare f1 f2 =
    bcompare0 (Zpos (XI (XO (XI (XO (XI XH)))))) (Zpos (XO (XO (XO (XO (XO
      (XO (XO (XO (XO (XO XH))))))))))) f1 f2

  (** val cmp : comparison0 -> float -> float -> bool **)

  let cmp c f1 f2 =
    cmp_of_comparison c (compare f1 f2)

  (** val of_single : float32 -> float **)

  let of_single =
    bconv (Zpos (XO (XO (XO (XI XH))))) (Zpos (XO (XO (XO (XO (XO (XO (XO
      XH)))))))) (Zpos (XI (XO (XI (XO (XI XH)))))) (Zpos (XO (XO (XO (XO (XO
      (XO (XO (XO (XO (XO XH))))))))))) of_single_nan Mode_NE

  (** val to_single : float -> float32 **)

  let to_single =
    bconv (Zpos (XI (XO (XI (XO (XI XH)))))) (Zpos (XO (XO (XO (XO (XO (XO
      (XO (XO (XO (XO XH))))))))))) (Zpos (XO (XO (XO (XI XH))))) (Zpos (XO
      (XO (XO (XO (XO (XO (XO XH)))))))) to_single_nan Mode_NE

  (** val to_int : float -> Int.int option **)

  let to_int f =
    option_map Int.repr
      (zofB_range (Zpos (XI (XO (XI (XO (XI XH)))))) (Zpos (XO (XO (XO (XO
        (XO (XO (XO (XO (XO (XO XH))))))))))) f Int.min_signed Int.max_signed)

  (** val to_intu : float -> Int.int option **)

  let to_intu f =
    option_map Int.repr
      (zofB_range (Zpos (XI (XO (XI (XO (XI XH)))))) (Zpos (XO (XO (XO (XO
        (XO (XO (XO (XO (XO (XO XH))))))))))) f Z0 Int.max_unsigned)

  (** val to_long : float -> Int64.int option **)

  let to_long f =
    option_map Int64.repr
      (zofB_range (Zpos (XI (XO (XI (XO (XI XH)))))) (Zpos (XO (XO (XO (XO
        (XO (XO (XO (XO (XO (XO XH))))))))))) f Int64.min_signed
        Int64.max_signed)

  (** val to_longu : float -> Int64.int option **)

  let to_longu f =
    option_map Int64.repr
      (zofB_range (Zpos (XI (XO (XI (XO (XI XH)))))) (Zpos (XO (XO (XO (XO
        (XO (XO (XO (XO (XO (XO XH))))))))))) f Z0 Int64.max_unsigned)

  (** val of_int : Int.int -> float **)

  let of_int n0 =
    bofZ (Zpos (XI (XO (XI (XO (XI XH)))))) (Zpos (XO (XO (XO (XO (XO (XO (XO
      (XO (XO (XO XH))))))))))) (Int.signed n0)

  (** val of_intu : Int.int -> float **)

  let of_intu n0 =
    bofZ (Zpos (XI (XO (XI (XO (XI XH)))))) (Zpos (XO (XO (XO (XO (XO (XO (XO
      (XO (XO (XO XH))))))))))) (Int.unsigned n0)

  (** val of_long : Int64.int -> float **)

  let of_long n0 =
    bofZ (Zpos (XI (XO (XI (XO (XI XH)))))) (Zpos (XO (XO (XO (XO (XO (XO (XO
      (XO (XO (XO XH))))))))))) (Int64.signed n0)

  (** val of_longu : Int64.int -> float **)

  let of_longu n0 =
    bofZ (Zpos (XI (XO (XI (XO (XI XH)))))) (Zpos (XO (XO (XO (XO (XO (XO (XO
      (XO (XO (XO XH))))))))))) (Int64.unsigned n0)

  (** val to_bits : float -> Int64.int **)

  let to_bits f =
    Int64.repr (bits_of_b64 f)

  (** val of_bits : Int64.int -> float **)

  let of_bits b =
    b64_of_bits (Int64.unsigned b)
 end

module Float32 =
 struct
  (** val neg_nan : float32 -> float32 **)

  let neg_nan = function
  | B754_nan0 (s, p) -> B754_nan0 ((negb s), p)
  | _ -> default_nan_1

  (** val abs_nan : float32 -> float32 **)

  let abs_nan = function
  | B754_nan0 (_, p) -> B754_nan0 (false, p)
  | _ -> default_nan_1

  (** val cons_pl :
      float32 -> (bool * positive) list -> (bool * positive) list **)

  let cons_pl x l =
    match x with
    | B754_nan0 (s, p) -> (s, p) :: l
    | _ -> l

  (** val binop_nan : float32 -> float32 -> float32 **)

  let binop_nan x y =
    quiet_nan_32 (choose_nan_32 (cons_pl x (cons_pl y [])))

  (** val zero : float32 **)

  let zero =
    B754_zero0 false

  (** val eq_dec : float32 -> float32 -> bool **)

  let eq_dec =
    beq_dec (Zpos (XO (XO (XO (XI XH))))) (Zpos (XO (XO (XO (XO (XO (XO (XO
      XH))))))))

  (** val neg : float32 -> float32 **)

  let neg =
    bopp (Zpos (XO (XO (XO (XI XH))))) (Zpos (XO (XO (XO (XO (XO (XO (XO
      XH)))))))) neg_nan

  (** val abs : float32 -> float32 **)

  let abs =
    babs (Zpos (XO (XO (XO (XI XH))))) (Zpos (XO (XO (XO (XO (XO (XO (XO
      XH)))))))) abs_nan

  (** val add : float32 -> float32 -> float32 **)

  let add =
    bplus0 (Zpos (XO (XO (XO (XI XH))))) (Zpos (XO (XO (XO (XO (XO (XO (XO
      XH)))))))) binop_nan Mode_NE

  (** val sub : float32 -> float32 -> float32 **)

  let sub =
    bminus0 (Zpos (XO (XO (XO (XI XH))))) (Zpos (XO (XO (XO (XO (XO (XO (XO
      XH)))))))) binop_nan Mode_NE

  (** val mul : float32 -> float32 -> float32 **)

  let mul =
    bmult0 (Zpos (XO (XO (XO (XI XH))))) (Zpos (XO (XO (XO (XO (XO (XO (XO
      XH)))))))) binop_nan Mode_NE

  (** val div : float32 -> float32 -> float32 **)

  let div =
    bdiv0 (Zpos (XO (XO (XO (XI XH))))) (Zpos (XO (XO (XO (XO (XO (XO (XO
      XH)))))))) binop_nan Mode_NE

  (** val compare : float32 -> float32 -> comparison option **)

  let compare f1 f2 =
    bcompare0 (Zpos (XO (XO (XO (XI XH))))) (Zpos (XO (XO (XO (XO (XO (XO (XO
      XH)))))))) f1 f2

  (** val cmp : comparison0 -> float32 -> float32 -> bool **)

  let cmp c f1 f2 =
    cmp_of_comparison c (compare f1 f2)

  (** val to_int : float32 -> Int.int option **)

  let to_int f =
    option_map Int.repr
      (zofB_range (Zpos (XO (XO (XO (XI XH))))) (Zpos (XO (XO (XO (XO (XO (XO
        (XO XH)))))))) f Int.min_signed Int.max_signed)

  (** val to_intu : float32 -> Int.int option **)

  let to_intu f =
    option_map Int.repr
      (zofB_range (Zpos (XO (XO (XO (XI XH))))) (Zpos (XO (XO (XO (XO (XO (XO
        (XO XH)))))))) f Z0 Int.max_unsigned)

  (** val to_long : float32 -> Int64.int option **)

  let to_long f =
    option_map Int64.repr
      (zofB_range (Zpos (XO (XO (XO (XI XH))))) (Zpos (XO (XO (XO (XO (XO (XO
        (XO XH)))))))) f Int64.min_signed Int64.max_signed)

  (** val to_longu : float32 -> Int64.int option **)

  let to_longu f =
    option_map Int64.repr
      (zofB_range (Zpos (XO (XO (XO (XI XH))))) (Zpos (XO (XO (XO (XO (XO (XO
        (XO XH)))))))) f Z0 Int64.max_unsigned)

  (** val of_int : Int.int -> float32 **)

  let of_int n0 =
    bofZ (Zpos (XO (XO (XO (XI XH))))) (Zpos (XO (XO (XO (XO (XO (XO (XO
      XH)))))))) (Int.signed n0)

  (** val of_intu : Int.int -> float32 **)

  let of_intu n0 =
    bofZ (Zpos (XO (XO (XO (XI XH))))) (Zpos (XO (XO (XO (XO (XO (XO (XO
      XH)))))))) (Int.unsigned n0)

  (** val of_long : Int64.int -> float32 **)

  let of_long n0 =
    bofZ (Zpos (XO (XO (XO (XI XH))))) (Zpos (XO (XO (XO (XO (XO (XO (XO
      XH)))))))) (Int64.signed n0)

  (** val of_longu : Int64.int -> float32 **)

  let of_longu n0 =
    bofZ (Zpos (XO (XO (XO (XI XH))))) (Zpos (XO (XO (XO (XO (XO (XO (XO
      XH)))))))) (Int64.unsigned n0)

  (** val to_bits : float32 -> Int.int **)

  let to_bits f =
    Int.repr (bits_of_b32 f)

  (** val of_bits : Int.int -> float32 **)

  let of_bits b =
    b32_of_bits (Int.unsigned b)
 end

type ident = positive

(** val ident_eq : positive -> positive -> bool **)

let ident_eq =
  peq

type typ =
| Tint
| Tfloat
| Tlong
| Tsingle
| Tany32
| Tany64

(** val typ_eq : typ -> typ -> bool **)

let typ_eq t1 t2 =
  match t1 with
  | Tint -> (match t2 with
             | Tint -> true
             | _ -> false)
  | Tfloat -> (match t2 with
               | Tfloat -> true
               | _ -> false)
  | Tlong -> (match t2 with
              | Tlong -> true
              | _ -> false)
  | Tsingle -> (match t2 with
                | Tsingle -> true
                | _ -> false)
  | Tany32 -> (match t2 with
               | Tany32 -> true
               | _ -> false)
  | Tany64 -> (match t2 with
               | Tany64 -> true
               | _ -> false)

(** val tptr : typ **)

let tptr =
  if ptr64 then Tlong else Tint

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

(** val xtype_eq : xtype -> xtype -> bool **)

let xtype_eq t1 t2 =
  match t1 with
  | Xbool -> (match t2 with
              | Xbool -> true
              | _ -> false)
  | Xint8signed -> (match t2 with
                    | Xint8signed -> true
                    | _ -> false)
  | Xint8unsigned -> (match t2 with
                      | Xint8unsigned -> true
                      | _ -> false)
  | Xint16signed -> (match t2 with
                     | Xint16signed -> true
                     | _ -> false)
  | Xint16unsigned -> (match t2 with
                       | Xint16unsigned -> true
                       | _ -> false)
  | Xint -> (match t2 with
             | Xint -> true
             | _ -> false)
  | Xfloat -> (match t2 with
               | Xfloat -> true
               | _ -> false)
  | Xlong -> (match t2 with
              | Xlong -> true
              | _ -> false)
  | Xsingle -> (match t2 with
                | Xsingle -> true
                | _ -> false)
  | Xptr -> (match t2 with
             | Xptr -> true
             | _ -> false)
  | Xany32 -> (match t2 with
               | Xany32 -> true
               | _ -> false)
  | Xany64 -> (match t2 with
               | Xany64 -> true
               | _ -> false)
  | Xvoid -> (match t2 with
              | Xvoid -> true
              | _ -> false)

(** val inj_type : typ -> xtype **)

let inj_type = function
| Tint -> Xint
| Tfloat -> Xfloat
| Tlong -> Xlong
| Tsingle -> Xsingle
| Tany32 -> Xany32
| Tany64 -> Xany64

type calling_convention = { cc_vararg : z option; cc_unproto : bool;
                            cc_structret : bool }

(** val cc_default : calling_convention **)

let cc_default =
  { cc_vararg = None; cc_unproto = false; cc_structret = false }

(** val calling_convention_eq :
    calling_convention -> calling_convention -> bool **)

let calling_convention_eq x y =
  let { cc_vararg = cc_vararg0; cc_unproto = cc_unproto0; cc_structret =
    cc_structret0 } = x
  in
  let { cc_vararg = cc_vararg1; cc_unproto = cc_unproto1; cc_structret =
    cc_structret1 } = y
  in
  if match cc_vararg0 with
     | Some a ->
       (match cc_vararg1 with
        | Some z0 -> Coq_Z.eq_dec a z0
        | None -> false)
     | None -> (match cc_vararg1 with
                | Some _ -> false
                | None -> true)
  then if bool_dec cc_unproto0 cc_unproto1
       then bool_dec cc_structret0 cc_structret1
       else false
  else false

type signature = { sig_args : xtype list; sig_res : xtype;
                   sig_cc : calling_convention }

(** val signature_eq : signature -> signature -> bool **)

let signature_eq =
  let x = fun _ -> list_eq_dec in
  (fun s1 s2 ->
  let { sig_args = sig_args0; sig_res = sig_res0; sig_cc = sig_cc0 } = s1 in
  let { sig_args = sig_args1; sig_res = sig_res1; sig_cc = sig_cc1 } = s2 in
  if x __ xtype_eq sig_args0 sig_args1
  then if xtype_eq sig_res0 sig_res1
       then calling_convention_eq sig_cc0 sig_cc1
       else false
  else false)

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

(** val mptr : memory_chunk **)

let mptr =
  if ptr64 then Mint64 else Mint32

(** val type_of_chunk : memory_chunk -> typ **)

let type_of_chunk = function
| Mint64 -> Tlong
| Mfloat32 -> Tsingle
| Mfloat64 -> Tfloat
| Many32 -> Tany32
| Many64 -> Tany64
| _ -> Tint

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

(** val eq_block : positive -> positive -> bool **)

let eq_block =
  peq

type val0 =
| Vundef
| Vint of Int.int
| Vlong of Int64.int
| Vfloat of float
| Vsingle of float32
| Vptr of block * Ptrofs.int

(** val vone : val0 **)

let vone =
  Vint Int.one

(** val vtrue : val0 **)

let vtrue =
  Vint Int.one

(** val vfalse : val0 **)

let vfalse =
  Vint Int.zero

(** val vptrofs : Ptrofs.int -> val0 **)

let vptrofs n0 =
  if ptr64 then Vlong (Ptrofs.to_int64 n0) else Vint (Ptrofs.to_int n0)

module Val =
 struct
  (** val eq : val0 -> val0 -> bool **)

  let eq x y =
    match x with
    | Vundef -> (match y with
                 | Vundef -> true
                 | _ -> false)
    | Vint i -> (match y with
                 | Vint i0 -> Int.eq_dec i i0
                 | _ -> false)
    | Vlong i -> (match y with
                  | Vlong i0 -> Int64.eq_dec i i0
                  | _ -> false)
    | Vfloat f -> (match y with
                   | Vfloat f0 -> Float.eq_dec f f0
                   | _ -> false)
    | Vsingle f ->
      (match y with
       | Vsingle f0 -> Float32.eq_dec f f0
       | _ -> false)
    | Vptr (b, i) ->
      (match y with
       | Vptr (b0, i0) -> if eq_block b b0 then Ptrofs.eq_dec i i0 else false
       | _ -> false)

  (** val of_bool : bool -> val0 **)

  let of_bool = function
  | true -> vtrue
  | false -> vfalse

  (** val is_bool : val0 -> bool **)

  let is_bool v =
    (||) (proj_sumbool (eq v vtrue)) (proj_sumbool (eq v vfalse))

  (** val norm_bool : val0 -> val0 **)

  let norm_bool v =
    if is_bool v then v else Vundef

  (** val addl : val0 -> val0 -> val0 **)

  let addl v1 v2 =
    match v1 with
    | Vlong n1 ->
      (match v2 with
       | Vlong n2 -> Vlong (Int64.add n1 n2)
       | Vptr (b2, ofs2) ->
         if ptr64
         then Vptr (b2, (Ptrofs.add ofs2 (Ptrofs.of_int64 n1)))
         else Vundef
       | _ -> Vundef)
    | Vptr (b1, ofs1) ->
      (match v2 with
       | Vlong n2 ->
         if ptr64
         then Vptr (b1, (Ptrofs.add ofs1 (Ptrofs.of_int64 n2)))
         else Vundef
       | _ -> Vundef)
    | _ -> Vundef

  (** val subl : val0 -> val0 -> val0 **)

  let subl v1 v2 =
    match v1 with
    | Vlong n1 ->
      (match v2 with
       | Vlong n2 -> Vlong (Int64.sub n1 n2)
       | _ -> Vundef)
    | Vptr (b1, ofs1) ->
      (match v2 with
       | Vlong n2 ->
         if ptr64
         then Vptr (b1, (Ptrofs.sub ofs1 (Ptrofs.of_int64 n2)))
         else Vundef
       | Vptr (b2, ofs2) ->
         if negb ptr64
         then Vundef
         else if eq_block b1 b2
              then Vlong (Ptrofs.to_int64 (Ptrofs.sub ofs1 ofs2))
              else Vundef
       | _ -> Vundef)
    | _ -> Vundef

  (** val mull' : val0 -> val0 -> val0 **)

  let mull' v1 v2 =
    match v1 with
    | Vint n1 ->
      (match v2 with
       | Vint n2 -> Vlong (Int64.mul' n1 n2)
       | _ -> Vundef)
    | _ -> Vundef

  (** val divls : val0 -> val0 -> val0 option **)

  let divls v1 v2 =
    match v1 with
    | Vlong n1 ->
      (match v2 with
       | Vlong n2 ->
         if (||) (Int64.eq n2 Int64.zero)
              ((&&) (Int64.eq n1 (Int64.repr Int64.min_signed))
                (Int64.eq n2 Int64.mone))
         then None
         else Some (Vlong (Int64.divs n1 n2))
       | _ -> None)
    | _ -> None

  (** val modls : val0 -> val0 -> val0 option **)

  let modls v1 v2 =
    match v1 with
    | Vlong n1 ->
      (match v2 with
       | Vlong n2 ->
         if (||) (Int64.eq n2 Int64.zero)
              ((&&) (Int64.eq n1 (Int64.repr Int64.min_signed))
                (Int64.eq n2 Int64.mone))
         then None
         else Some (Vlong (Int64.mods n1 n2))
       | _ -> None)
    | _ -> None

  (** val divlu : val0 -> val0 -> val0 option **)

  let divlu v1 v2 =
    match v1 with
    | Vlong n1 ->
      (match v2 with
       | Vlong n2 ->
         if Int64.eq n2 Int64.zero
         then None
         else Some (Vlong (Int64.divu n1 n2))
       | _ -> None)
    | _ -> None

  (** val modlu : val0 -> val0 -> val0 option **)

  let modlu v1 v2 =
    match v1 with
    | Vlong n1 ->
      (match v2 with
       | Vlong n2 ->
         if Int64.eq n2 Int64.zero
         then None
         else Some (Vlong (Int64.modu n1 n2))
       | _ -> None)
    | _ -> None

  (** val shll : val0 -> val0 -> val0 **)

  let shll v1 v2 =
    match v1 with
    | Vlong n1 ->
      (match v2 with
       | Vint n2 ->
         if Int.ltu n2 Int64.iwordsize'
         then Vlong (Int64.shl' n1 n2)
         else Vundef
       | _ -> Vundef)
    | _ -> Vundef

  (** val shrl : val0 -> val0 -> val0 **)

  let shrl v1 v2 =
    match v1 with
    | Vlong n1 ->
      (match v2 with
       | Vint n2 ->
         if Int.ltu n2 Int64.iwordsize'
         then Vlong (Int64.shr' n1 n2)
         else Vundef
       | _ -> Vundef)
    | _ -> Vundef

  (** val shrlu : val0 -> val0 -> val0 **)

  let shrlu v1 v2 =
    match v1 with
    | Vlong n1 ->
      (match v2 with
       | Vint n2 ->
         if Int.ltu n2 Int64.iwordsize'
         then Vlong (Int64.shru' n1 n2)
         else Vundef
       | _ -> Vundef)
    | _ -> Vundef

  (** val cmp_different_blocks : comparison0 -> bool option **)

  let cmp_different_blocks = function
  | Ceq -> Some false
  | Cne -> Some true
  | _ -> None

  (** val cmpu_bool :
      (block -> z -> bool) -> comparison0 -> val0 -> val0 -> bool option **)

  let cmpu_bool valid_ptr =
    let weak_valid_ptr = fun b ofs ->
      (||) (valid_ptr b ofs) (valid_ptr b (Coq_Z.sub ofs (Zpos XH)))
    in
    (fun c v1 v2 ->
    match v1 with
    | Vint n1 ->
      (match v2 with
       | Vint n2 -> Some (Int.cmpu c n1 n2)
       | Vptr (b2, ofs2) ->
         if ptr64
         then None
         else if (&&) (Int.eq n1 Int.zero)
                   (weak_valid_ptr b2 (Ptrofs.unsigned ofs2))
              then cmp_different_blocks c
              else None
       | _ -> None)
    | Vptr (b1, ofs1) ->
      (match v2 with
       | Vint n2 ->
         if ptr64
         then None
         else if (&&) (Int.eq n2 Int.zero)
                   (weak_valid_ptr b1 (Ptrofs.unsigned ofs1))
              then cmp_different_blocks c
              else None
       | Vptr (b2, ofs2) ->
         if ptr64
         then None
         else if eq_block b1 b2
              then if (&&) (weak_valid_ptr b1 (Ptrofs.unsigned ofs1))
                        (weak_valid_ptr b2 (Ptrofs.unsigned ofs2))
                   then Some (Ptrofs.cmpu c ofs1 ofs2)
                   else None
              else if (&&) (valid_ptr b1 (Ptrofs.unsigned ofs1))
                        (valid_ptr b2 (Ptrofs.unsigned ofs2))
                   then cmp_different_blocks c
                   else None
       | _ -> None)
    | _ -> None)

  (** val cmplu_bool :
      (block -> z -> bool) -> comparison0 -> val0 -> val0 -> bool option **)

  let cmplu_bool valid_ptr =
    let weak_valid_ptr = fun b ofs ->
      (||) (valid_ptr b ofs) (valid_ptr b (Coq_Z.sub ofs (Zpos XH)))
    in
    (fun c v1 v2 ->
    match v1 with
    | Vlong n1 ->
      (match v2 with
       | Vlong n2 -> Some (Int64.cmpu c n1 n2)
       | Vptr (b2, ofs2) ->
         if negb ptr64
         then None
         else if (&&) (Int64.eq n1 Int64.zero)
                   (weak_valid_ptr b2 (Ptrofs.unsigned ofs2))
              then cmp_different_blocks c
              else None
       | _ -> None)
    | Vptr (b1, ofs1) ->
      (match v2 with
       | Vlong n2 ->
         if negb ptr64
         then None
         else if (&&) (Int64.eq n2 Int64.zero)
                   (weak_valid_ptr b1 (Ptrofs.unsigned ofs1))
              then cmp_different_blocks c
              else None
       | Vptr (b2, ofs2) ->
         if negb ptr64
         then None
         else if eq_block b1 b2
              then if (&&) (weak_valid_ptr b1 (Ptrofs.unsigned ofs1))
                        (weak_valid_ptr b2 (Ptrofs.unsigned ofs2))
                   then Some (Ptrofs.cmpu c ofs1 ofs2)
                   else None
              else if (&&) (valid_ptr b1 (Ptrofs.unsigned ofs1))
                        (valid_ptr b2 (Ptrofs.unsigned ofs2))
                   then cmp_different_blocks c
                   else None
       | _ -> None)
    | _ -> None)

  (** val normalize : val0 -> typ -> val0 **)

  let normalize v ty =
    match v with
    | Vundef -> Vundef
    | Vint _ ->
      (match ty with
       | Tint -> v
       | Tany32 -> v
       | Tany64 -> v
       | _ -> Vundef)
    | Vlong _ -> (match ty with
                  | Tlong -> v
                  | Tany64 -> v
                  | _ -> Vundef)
    | Vfloat _ -> (match ty with
                   | Tfloat -> v
                   | Tany64 -> v
                   | _ -> Vundef)
    | Vsingle _ ->
      (match ty with
       | Tint -> Vundef
       | Tfloat -> Vundef
       | Tlong -> Vundef
       | _ -> v)
    | Vptr (_, _) ->
      (match ty with
       | Tint -> if ptr64 then Vundef else v
       | Tlong -> if ptr64 then v else Vundef
       | Tany32 -> if ptr64 then Vundef else v
       | Tany64 -> v
       | _ -> Vundef)

  (** val load_result : memory_chunk -> val0 -> val0 **)

  let load_result chunk v =
    match chunk with
    | Mbool ->
      (match v with
       | Vint n0 ->
         norm_bool (Vint (Int.zero_ext (Zpos (XO (XO (XO XH)))) n0))
       | _ -> Vundef)
    | Mint8signed ->
      (match v with
       | Vint n0 -> Vint (Int.sign_ext (Zpos (XO (XO (XO XH)))) n0)
       | _ -> Vundef)
    | Mint8unsigned ->
      (match v with
       | Vint n0 -> Vint (Int.zero_ext (Zpos (XO (XO (XO XH)))) n0)
       | _ -> Vundef)
    | Mint16signed ->
      (match v with
       | Vint n0 -> Vint (Int.sign_ext (Zpos (XO (XO (XO (XO XH))))) n0)
       | _ -> Vundef)
    | Mint16unsigned ->
      (match v with
       | Vint n0 -> Vint (Int.zero_ext (Zpos (XO (XO (XO (XO XH))))) n0)
       | _ -> Vundef)
    | Mint32 ->
      (match v with
       | Vint n0 -> Vint n0
       | Vptr (b, ofs) -> if ptr64 then Vundef else Vptr (b, ofs)
       | _ -> Vundef)
    | Mint64 ->
      (match v with
       | Vlong n0 -> Vlong n0
       | Vptr (b, ofs) -> if ptr64 then Vptr (b, ofs) else Vundef
       | _ -> Vundef)
    | Mfloat32 -> (match v with
                   | Vsingle f -> Vsingle f
                   | _ -> Vundef)
    | Mfloat64 -> (match v with
                   | Vfloat f -> Vfloat f
                   | _ -> Vundef)
    | Many32 ->
      (match v with
       | Vint _ -> v
       | Vsingle _ -> v
       | Vptr (_, _) -> if ptr64 then Vundef else v
       | _ -> Vundef)
    | Many64 -> v
 end

(** val size_chunk : memory_chunk -> z **)

let size_chunk = function
| Mbool -> Zpos XH
| Mint8signed -> Zpos XH
| Mint8unsigned -> Zpos XH
| Mint16signed -> Zpos (XO XH)
| Mint16unsigned -> Zpos (XO XH)
| Mint32 -> Zpos (XO (XO XH))
| Mfloat32 -> Zpos (XO (XO XH))
| Many32 -> Zpos (XO (XO XH))
| _ -> Zpos (XO (XO (XO XH)))

(** val size_chunk_nat : memory_chunk -> nat **)

let size_chunk_nat chunk =
  Coq_Z.to_nat (size_chunk chunk)

(** val align_chunk : memory_chunk -> z **)

let align_chunk = function
| Mbool -> Zpos XH
| Mint8signed -> Zpos XH
| Mint8unsigned -> Zpos XH
| Mint16signed -> Zpos (XO XH)
| Mint16unsigned -> Zpos (XO XH)
| Mint64 -> align_int64
| Mfloat64 -> align_float64
| Many64 -> Coq_Z.max align_int64 align_float64
| _ -> Zpos (XO (XO XH))

type quantity =
| Q32
| Q64

(** val quantity_eq : quantity -> quantity -> bool **)

let quantity_eq q1 q2 =
  match q1 with
  | Q32 -> (match q2 with
            | Q32 -> true
            | Q64 -> false)
  | Q64 -> (match q2 with
            | Q32 -> false
            | Q64 -> true)

(** val size_quantity_nat : quantity -> nat **)

let size_quantity_nat = function
| Q32 -> S (S (S (S O)))
| Q64 -> S (S (S (S (S (S (S (S O)))))))

type memval =
| Undef
| Byte of Byte.int
| Fragment of val0 * quantity * nat

(** val bytes_of_int : nat -> z -> Byte.int list **)

let rec bytes_of_int n0 x =
  match n0 with
  | O -> []
  | S m ->
    (Byte.repr x) :: (bytes_of_int m
                       (Coq_Z.div x (Zpos (XO (XO (XO (XO (XO (XO (XO (XO
                         XH)))))))))))

(** val int_of_bytes : Byte.int list -> z **)

let rec int_of_bytes = function
| [] -> Z0
| b :: l' ->
  Coq_Z.add (Byte.unsigned b)
    (Coq_Z.mul (int_of_bytes l') (Zpos (XO (XO (XO (XO (XO (XO (XO (XO
      XH))))))))))

(** val rev_if_be : Byte.int list -> Byte.int list **)

let rev_if_be l =
  if big_endian then rev l else l

(** val encode_int : nat -> z -> Byte.int list **)

let encode_int sz x =
  rev_if_be (bytes_of_int sz x)

(** val decode_int : Byte.int list -> z **)

let decode_int b =
  int_of_bytes (rev_if_be b)

(** val inj_bytes : Byte.int list -> memval list **)

let inj_bytes bl =
  map (fun x -> Byte x) bl

(** val proj_bytes : memval list -> Byte.int list option **)

let rec proj_bytes = function
| [] -> Some []
| m :: vl' ->
  (match m with
   | Byte b ->
     (match proj_bytes vl' with
      | Some bl -> Some (b :: bl)
      | None -> None)
   | _ -> None)

(** val inj_value_rec : nat -> val0 -> quantity -> memval list **)

let rec inj_value_rec n0 v q =
  match n0 with
  | O -> []
  | S m -> (Fragment (v, q, m)) :: (inj_value_rec m v q)

(** val inj_value : quantity -> val0 -> memval list **)

let inj_value q v =
  inj_value_rec (size_quantity_nat q) v q

(** val check_value : nat -> val0 -> quantity -> memval list -> bool **)

let rec check_value n0 v q vl =
  match n0 with
  | O -> (match vl with
          | [] -> true
          | _ :: _ -> false)
  | S m ->
    (match vl with
     | [] -> false
     | m0 :: vl' ->
       (match m0 with
        | Fragment (v', q', m') ->
          (&&)
            ((&&)
              ((&&) (proj_sumbool (Val.eq v v'))
                (proj_sumbool (quantity_eq q q')))
              (Nat.eqb m m'))
            (check_value m v q vl')
        | _ -> false))

(** val proj_value : quantity -> memval list -> val0 **)

let proj_value q vl = match vl with
| [] -> Vundef
| m :: _ ->
  (match m with
   | Fragment (v, _, _) ->
     if check_value (size_quantity_nat q) v q vl then v else Vundef
   | _ -> Vundef)

(** val encode_val : memory_chunk -> val0 -> memval list **)

let encode_val chunk v = match v with
| Vundef ->
  (match chunk with
   | Many32 -> inj_value Q32 v
   | Many64 -> inj_value Q64 v
   | _ -> repeat Undef (size_chunk_nat chunk))
| Vint n0 ->
  (match chunk with
   | Mbool -> inj_bytes (encode_int (S O) (Int.unsigned n0))
   | Mint8signed -> inj_bytes (encode_int (S O) (Int.unsigned n0))
   | Mint8unsigned -> inj_bytes (encode_int (S O) (Int.unsigned n0))
   | Mint16signed -> inj_bytes (encode_int (S (S O)) (Int.unsigned n0))
   | Mint16unsigned -> inj_bytes (encode_int (S (S O)) (Int.unsigned n0))
   | Mint32 -> inj_bytes (encode_int (S (S (S (S O)))) (Int.unsigned n0))
   | Many32 -> inj_value Q32 v
   | Many64 -> inj_value Q64 v
   | _ -> repeat Undef (size_chunk_nat chunk))
| Vlong n0 ->
  (match chunk with
   | Mint64 ->
     inj_bytes
       (encode_int (S (S (S (S (S (S (S (S O)))))))) (Int64.unsigned n0))
   | Many32 -> inj_value Q32 v
   | Many64 -> inj_value Q64 v
   | _ -> repeat Undef (size_chunk_nat chunk))
| Vfloat n0 ->
  (match chunk with
   | Mfloat64 ->
     inj_bytes
       (encode_int (S (S (S (S (S (S (S (S O))))))))
         (Int64.unsigned (Float.to_bits n0)))
   | Many32 -> inj_value Q32 v
   | Many64 -> inj_value Q64 v
   | _ -> repeat Undef (size_chunk_nat chunk))
| Vsingle n0 ->
  (match chunk with
   | Mfloat32 ->
     inj_bytes
       (encode_int (S (S (S (S O)))) (Int.unsigned (Float32.to_bits n0)))
   | Many32 -> inj_value Q32 v
   | Many64 -> inj_value Q64 v
   | _ -> repeat Undef (size_chunk_nat chunk))
| Vptr (_, _) ->
  (match chunk with
   | Mint32 ->
     if ptr64 then repeat Undef (S (S (S (S O)))) else inj_value Q32 v
   | Mint64 ->
     if ptr64
     then inj_value Q64 v
     else repeat Undef (S (S (S (S (S (S (S (S O))))))))
   | Many32 -> inj_value Q32 v
   | Many64 -> inj_value Q64 v
   | _ -> repeat Undef (size_chunk_nat chunk))

(** val decode_val : memory_chunk -> memval list -> val0 **)

let decode_val chunk vl =
  match proj_bytes vl with
  | Some bl ->
    (match chunk with
     | Mbool ->
       Val.norm_bool (Vint
         (Int.zero_ext (Zpos (XO (XO (XO XH)))) (Int.repr (decode_int bl))))
     | Mint8signed ->
       Vint (Int.sign_ext (Zpos (XO (XO (XO XH)))) (Int.repr (decode_int bl)))
     | Mint8unsigned ->
       Vint (Int.zero_ext (Zpos (XO (XO (XO XH)))) (Int.repr (decode_int bl)))
     | Mint16signed ->
       Vint
         (Int.sign_ext (Zpos (XO (XO (XO (XO XH)))))
           (Int.repr (decode_int bl)))
     | Mint16unsigned ->
       Vint
         (Int.zero_ext (Zpos (XO (XO (XO (XO XH)))))
           (Int.repr (decode_int bl)))
     | Mint32 -> Vint (Int.repr (decode_int bl))
     | Mint64 -> Vlong (Int64.repr (decode_int bl))
     | Mfloat32 -> Vsingle (Float32.of_bits (Int.repr (decode_int bl)))
     | Mfloat64 -> Vfloat (Float.of_bits (Int64.repr (decode_int bl)))
     | _ -> Vundef)
  | None ->
    (match chunk with
     | Mint32 ->
       if ptr64 then Vundef else Val.load_result chunk (proj_value Q32 vl)
     | Mint64 ->
       if ptr64 then Val.load_result chunk (proj_value Q64 vl) else Vundef
     | Many32 -> Val.load_result chunk (proj_value Q32 vl)
     | Many64 -> Val.load_result chunk (proj_value Q64 vl)
     | _ -> Vundef)

type permission =
| Freeable
| Writable
| Readable
| Nonempty

type perm_kind =
| Max
| Cur

module Mem =
 struct
  type mem' = { mem_contents : memval ZMap.t PMap.t;
                mem_access : (z -> perm_kind -> permission option) PMap.t;
                nextblock : block }

  (** val mem_contents : mem' -> memval ZMap.t PMap.t **)

  let mem_contents m =
    m.mem_contents

  (** val mem_access :
      mem' -> (z -> perm_kind -> permission option) PMap.t **)

  let mem_access m =
    m.mem_access

  (** val nextblock : mem' -> block **)

  let nextblock m =
    m.nextblock

  type mem = mem'

  (** val perm_order_dec : permission -> permission -> bool **)

  let perm_order_dec p1 p2 =
    match p1 with
    | Freeable -> true
    | Writable -> (match p2 with
                   | Freeable -> false
                   | _ -> true)
    | Readable ->
      (match p2 with
       | Freeable -> false
       | Writable -> false
       | _ -> true)
    | Nonempty -> (match p2 with
                   | Nonempty -> true
                   | _ -> false)

  (** val perm_order'_dec : permission option -> permission -> bool **)

  let perm_order'_dec op p =
    match op with
    | Some p0 -> perm_order_dec p0 p
    | None -> false

  (** val perm_dec : mem -> block -> z -> perm_kind -> permission -> bool **)

  let perm_dec m b ofs k p =
    perm_order'_dec (PMap.get b m.mem_access ofs k) p

  (** val range_perm_dec :
      mem -> block -> z -> z -> perm_kind -> permission -> bool **)

  let rec range_perm_dec m b lo hi k p =
    let s = zlt lo hi in
    if s
    then let s0 = perm_dec m b lo k p in
         if s0
         then let y = Coq_Z.add lo (Zpos XH) in range_perm_dec m b y hi k p
         else false
    else true

  (** val valid_access_dec :
      mem -> memory_chunk -> block -> z -> permission -> bool **)

  let valid_access_dec m chunk b ofs p =
    let s = range_perm_dec m b ofs (Coq_Z.add ofs (size_chunk chunk)) Cur p in
    if s then zdivide_dec (align_chunk chunk) ofs else false

  (** val valid_pointer : mem -> block -> z -> bool **)

  let valid_pointer m b ofs =
    proj_sumbool (perm_dec m b ofs Cur Nonempty)

  (** val weak_valid_pointer : mem -> block -> z -> bool **)

  let weak_valid_pointer m b ofs =
    (||) (valid_pointer m b ofs) (valid_pointer m b (Coq_Z.sub ofs (Zpos XH)))

  (** val alloc : mem -> z -> z -> mem' * block **)

  let alloc m lo hi =
    ({ mem_contents =
      (PMap.set m.nextblock (ZMap.init Undef) m.mem_contents); mem_access =
      (PMap.set m.nextblock (fun ofs _ ->
        if (&&) (proj_sumbool (zle lo ofs)) (proj_sumbool (zlt ofs hi))
        then Some Freeable
        else None) m.mem_access);
      nextblock = (Coq_Pos.succ m.nextblock) }, m.nextblock)

  (** val unchecked_free : mem -> block -> z -> z -> mem **)

  let unchecked_free m b lo hi =
    { mem_contents = m.mem_contents; mem_access =
      (PMap.set b (fun ofs k ->
        if (&&) (proj_sumbool (zle lo ofs)) (proj_sumbool (zlt ofs hi))
        then None
        else PMap.get b m.mem_access ofs k) m.mem_access);
      nextblock = m.nextblock }

  (** val free : mem -> block -> z -> z -> mem option **)

  let free m b lo hi =
    if range_perm_dec m b lo hi Cur Freeable
    then Some (unchecked_free m b lo hi)
    else None

  (** val free_list : mem -> ((block * z) * z) list -> mem option **)

  let rec free_list m = function
  | [] -> Some m
  | p :: l' ->
    let (p0, hi) = p in
    let (b, lo) = p0 in
    (match free m b lo hi with
     | Some m' -> free_list m' l'
     | None -> None)

  (** val getN : nat -> z -> memval ZMap.t -> memval list **)

  let rec getN n0 p c =
    match n0 with
    | O -> []
    | S n' -> (ZMap.get p c) :: (getN n' (Coq_Z.add p (Zpos XH)) c)

  (** val load : memory_chunk -> mem -> block -> z -> val0 option **)

  let load chunk m b ofs =
    if valid_access_dec m chunk b ofs Readable
    then Some
           (decode_val chunk
             (getN (size_chunk_nat chunk) ofs (PMap.get b m.mem_contents)))
    else None

  (** val loadv : memory_chunk -> mem -> val0 -> val0 option **)

  let loadv chunk m = function
  | Vptr (b, ofs) ->
    if zle (Coq_Z.add (Ptrofs.unsigned ofs) (size_chunk chunk)) Ptrofs.modulus
    then load chunk m b (Ptrofs.unsigned ofs)
    else None
  | _ -> None

  (** val loadbytes : mem -> block -> z -> z -> memval list option **)

  let loadbytes m b ofs n0 =
    if range_perm_dec m b ofs (Coq_Z.add ofs n0) Cur Readable
    then Some (getN (Coq_Z.to_nat n0) ofs (PMap.get b m.mem_contents))
    else None

  (** val setN : memval list -> z -> memval ZMap.t -> memval ZMap.t **)

  let rec setN vl p c =
    match vl with
    | [] -> c
    | v :: vl' -> setN vl' (Coq_Z.add p (Zpos XH)) (ZMap.set p v c)

  (** val store : memory_chunk -> mem -> block -> z -> val0 -> mem option **)

  let store chunk m b ofs v =
    if valid_access_dec m chunk b ofs Writable
    then Some { mem_contents =
           (PMap.set b
             (setN (encode_val chunk v) ofs (PMap.get b m.mem_contents))
             m.mem_contents);
           mem_access = m.mem_access; nextblock = m.nextblock }
    else None

  (** val storev : memory_chunk -> mem -> val0 -> val0 -> mem option **)

  let storev chunk m addr v =
    match addr with
    | Vptr (b, ofs) ->
      if zle (Coq_Z.add (Ptrofs.unsigned ofs) (size_chunk chunk))
           Ptrofs.modulus
      then store chunk m b (Ptrofs.unsigned ofs) v
      else None
    | _ -> None

  (** val storebytes : mem -> block -> z -> memval list -> mem option **)

  let storebytes m b ofs bytes =
    if range_perm_dec m b ofs (Coq_Z.add ofs (Coq_Z.of_nat (length bytes)))
         Cur Writable
    then Some { mem_contents =
           (PMap.set b (setN bytes ofs (PMap.get b m.mem_contents))
             m.mem_contents);
           mem_access = m.mem_access; nextblock = m.nextblock }
    else None
 end

module Senv =
 struct
  type t = { find_symbol : (ident -> block option);
             public_symbol : (ident -> bool);
             invert_symbol : (block -> ident option);
             block_is_volatile : (block -> bool); nextblock : block }
 end

module Genv =
 struct
  type ('f, 'v) t = { genv_public : ident list; genv_symb : block PTree.t;
                      genv_defs : ('f, 'v) globdef PTree.t; genv_next : 
                      block }

  (** val genv_public : ('a1, 'a2) t -> ident list **)

  let genv_public t0 =
    t0.genv_public

  (** val genv_symb : ('a1, 'a2) t -> block PTree.t **)

  let genv_symb t0 =
    t0.genv_symb

  (** val genv_defs : ('a1, 'a2) t -> ('a1, 'a2) globdef PTree.t **)

  let genv_defs t0 =
    t0.genv_defs

  (** val genv_next : ('a1, 'a2) t -> block **)

  let genv_next t0 =
    t0.genv_next

  (** val find_symbol : ('a1, 'a2) t -> ident -> block option **)

  let find_symbol ge0 id =
    PTree.get id ge0.genv_symb

  (** val public_symbol : ('a1, 'a2) t -> ident -> bool **)

  let public_symbol ge0 id =
    match find_symbol ge0 id with
    | Some _ -> proj_sumbool (in_dec ident_eq id ge0.genv_public)
    | None -> false

  (** val find_def : ('a1, 'a2) t -> block -> ('a1, 'a2) globdef option **)

  let find_def ge0 b =
    PTree.get b ge0.genv_defs

  (** val find_funct_ptr : ('a1, 'a2) t -> block -> 'a1 option **)

  let find_funct_ptr ge0 b =
    match find_def ge0 b with
    | Some g -> (match g with
                 | Gfun f -> Some f
                 | Gvar _ -> None)
    | None -> None

  (** val find_funct : ('a1, 'a2) t -> val0 -> 'a1 option **)

  let find_funct ge0 = function
  | Vptr (b, ofs) ->
    if Ptrofs.eq_dec ofs Ptrofs.zero then find_funct_ptr ge0 b else None
  | _ -> None

  (** val invert_symbol : ('a1, 'a2) t -> block -> ident option **)

  let invert_symbol ge0 b =
    PTree.fold (fun res0 id b' -> if eq_block b b' then Some id else res0)
      ge0.genv_symb None

  (** val find_var_info : ('a1, 'a2) t -> block -> 'a2 globvar option **)

  let find_var_info ge0 b =
    match find_def ge0 b with
    | Some g -> (match g with
                 | Gfun _ -> None
                 | Gvar v -> Some v)
    | None -> None

  (** val block_is_volatile : ('a1, 'a2) t -> block -> bool **)

  let block_is_volatile ge0 b =
    match find_var_info ge0 b with
    | Some gv -> gv.gvar_volatile
    | None -> false

  (** val add_global :
      ('a1, 'a2) t -> (ident * ('a1, 'a2) globdef) -> ('a1, 'a2) t **)

  let add_global ge0 idg =
    { genv_public = ge0.genv_public; genv_symb =
      (PTree.set (fst idg) ge0.genv_next ge0.genv_symb); genv_defs =
      (PTree.set ge0.genv_next (snd idg) ge0.genv_defs); genv_next =
      (Coq_Pos.succ ge0.genv_next) }

  (** val add_globals :
      ('a1, 'a2) t -> (ident * ('a1, 'a2) globdef) list -> ('a1, 'a2) t **)

  let add_globals ge0 gl =
    fold_left add_global gl ge0

  (** val empty_genv : ident list -> ('a1, 'a2) t **)

  let empty_genv pub =
    { genv_public = pub; genv_symb = PTree.empty; genv_defs = PTree.empty;
      genv_next = XH }

  (** val globalenv : ('a1, 'a2) program -> ('a1, 'a2) t **)

  let globalenv p =
    add_globals (empty_genv p.prog_public) p.prog_defs

  (** val to_senv : ('a1, 'a2) t -> Senv.t **)

  let to_senv ge0 =
    { Senv.find_symbol = (find_symbol ge0); Senv.public_symbol =
      (public_symbol ge0); Senv.invert_symbol = (invert_symbol ge0);
      Senv.block_is_volatile = (block_is_volatile ge0); Senv.nextblock =
      ge0.genv_next }
 end

type builtin_sem =
  val0 list -> val0 option
  (* singleton inductive, whose constructor was mkbuiltin *)

(** val mkbuiltin_v1t : xtype -> (val0 -> val0) -> builtin_sem **)

let mkbuiltin_v1t _ f = function
| [] -> None
| v1 :: l -> (match l with
              | [] -> Some (f v1)
              | _ :: _ -> None)

(** val mkbuiltin_v2t : xtype -> (val0 -> val0 -> val0) -> builtin_sem **)

let mkbuiltin_v2t _ f = function
| [] -> None
| v1 :: l ->
  (match l with
   | [] -> None
   | v2 :: l0 -> (match l0 with
                  | [] -> Some (f v1 v2)
                  | _ :: _ -> None))

(** val mkbuiltin_v1p : xtype -> (val0 -> val0 option) -> builtin_sem **)

let mkbuiltin_v1p _ f = function
| [] -> None
| v1 :: l -> (match l with
              | [] -> f v1
              | _ :: _ -> None)

(** val mkbuiltin_v2p :
    xtype -> (val0 -> val0 -> val0 option) -> builtin_sem **)

let mkbuiltin_v2p _ f = function
| [] -> None
| v1 :: l ->
  (match l with
   | [] -> None
   | v2 :: l0 -> (match l0 with
                  | [] -> f v1 v2
                  | _ :: _ -> None))

type valty = __

type valxty = __

(** val inj_num : xtype -> valxty -> val0 **)

let inj_num = function
| Xint -> Obj.magic (fun x -> Vint x)
| Xfloat -> Obj.magic (fun x -> Vfloat x)
| Xlong -> Obj.magic (fun x -> Vlong x)
| Xsingle -> Obj.magic (fun x -> Vsingle x)
| Xptr -> (fun _ -> Vundef)
| Xany32 -> (fun _ -> Vundef)
| Xany64 -> (fun _ -> Vundef)
| Xvoid -> (fun _ -> Vundef)
| _ -> (fun n0 -> Vint (Obj.magic n0))

(** val proj_num : typ -> 'a1 -> val0 -> (valty -> 'a1) -> 'a1 **)

let proj_num t0 k0 v k1 =
  match t0 with
  | Tint -> (match v with
             | Vint n0 -> Obj.magic k1 n0
             | _ -> k0)
  | Tfloat -> (match v with
               | Vfloat n0 -> Obj.magic k1 n0
               | _ -> k0)
  | Tlong -> (match v with
              | Vlong n0 -> Obj.magic k1 n0
              | _ -> k0)
  | Tsingle -> (match v with
                | Vsingle n0 -> Obj.magic k1 n0
                | _ -> k0)
  | _ -> k0

(** val mkbuiltin_n1t : typ -> xtype -> (valty -> valxty) -> builtin_sem **)

let mkbuiltin_n1t targ1 tres f =
  mkbuiltin_v1t tres (fun v1 ->
    proj_num targ1 Vundef v1 (fun x -> inj_num tres (f x)))

(** val mkbuiltin_n2t :
    typ -> typ -> xtype -> (valty -> valty -> valxty) -> builtin_sem **)

let mkbuiltin_n2t targ1 targ2 tres f =
  mkbuiltin_v2t tres (fun v1 v2 ->
    proj_num targ1 Vundef v1 (fun x1 ->
      proj_num targ2 Vundef v2 (fun x2 -> inj_num tres (f x1 x2))))

(** val mkbuiltin_n1p :
    typ -> xtype -> (valty -> valxty option) -> builtin_sem **)

let mkbuiltin_n1p targ1 tres f =
  mkbuiltin_v1p tres (fun v1 ->
    proj_num targ1 None v1 (fun x -> option_map (inj_num tres) (f x)))

(** val lookup_builtin :
    ('a1 -> signature) -> char list -> signature -> (char list * 'a1) list ->
    'a1 option **)

let rec lookup_builtin sig_of name sg = function
| [] -> None
| p :: l0 ->
  let (n0, b) = p in
  if (&&) (proj_sumbool (string_dec name n0))
       (proj_sumbool (signature_eq sg (sig_of b)))
  then Some b
  else lookup_builtin sig_of name sg l0

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

(** val standard_builtin_table : (char list * standard_builtin) list **)

let standard_builtin_table =
  (('_'::('_'::('b'::('u'::('i'::('l'::('t'::('i'::('n'::('_'::('s'::('e'::('l'::[]))))))))))))),
    (BI_select
    Tint)) :: ((('_'::('_'::('b'::('u'::('i'::('l'::('t'::('i'::('n'::('_'::('s'::('e'::('l'::[]))))))))))))),
    (BI_select
    Tlong)) :: ((('_'::('_'::('b'::('u'::('i'::('l'::('t'::('i'::('n'::('_'::('s'::('e'::('l'::[]))))))))))))),
    (BI_select
    Tfloat)) :: ((('_'::('_'::('b'::('u'::('i'::('l'::('t'::('i'::('n'::('_'::('s'::('e'::('l'::[]))))))))))))),
    (BI_select
    Tsingle)) :: ((('_'::('_'::('b'::('u'::('i'::('l'::('t'::('i'::('n'::('_'::('f'::('a'::('b'::('s'::[])))))))))))))),
    BI_fabs) :: ((('_'::('_'::('b'::('u'::('i'::('l'::('t'::('i'::('n'::('_'::('f'::('a'::('b'::('s'::('f'::[]))))))))))))))),
    BI_fabsf) :: ((('_'::('_'::('b'::('u'::('i'::('l'::('t'::('i'::('n'::('_'::('f'::('s'::('q'::('r'::('t'::[]))))))))))))))),
    BI_fsqrt) :: ((('_'::('_'::('b'::('u'::('i'::('l'::('t'::('i'::('n'::('_'::('s'::('q'::('r'::('t'::[])))))))))))))),
    BI_fsqrt) :: ((('_'::('_'::('b'::('u'::('i'::('l'::('t'::('i'::('n'::('_'::('n'::('e'::('g'::('l'::[])))))))))))))),
    BI_negl) :: ((('_'::('_'::('b'::('u'::('i'::('l'::('t'::('i'::('n'::('_'::('a'::('d'::('d'::('l'::[])))))))))))))),
    BI_addl) :: ((('_'::('_'::('b'::('u'::('i'::('l'::('t'::('i'::('n'::('_'::('s'::('u'::('b'::('l'::[])))))))))))))),
    BI_subl) :: ((('_'::('_'::('b'::('u'::('i'::('l'::('t'::('i'::('n'::('_'::('m'::('u'::('l'::('l'::[])))))))))))))),
    BI_mull) :: ((('_'::('_'::('b'::('u'::('i'::('l'::('t'::('i'::('n'::('_'::('b'::('s'::('w'::('a'::('p'::('1'::('6'::[]))))))))))))))))),
    BI_i16_bswap) :: ((('_'::('_'::('b'::('u'::('i'::('l'::('t'::('i'::('n'::('_'::('b'::('s'::('w'::('a'::('p'::[]))))))))))))))),
    BI_i32_bswap) :: ((('_'::('_'::('b'::('u'::('i'::('l'::('t'::('i'::('n'::('_'::('b'::('s'::('w'::('a'::('p'::('3'::('2'::[]))))))))))))))))),
    BI_i32_bswap) :: ((('_'::('_'::('b'::('u'::('i'::('l'::('t'::('i'::('n'::('_'::('b'::('s'::('w'::('a'::('p'::('6'::('4'::[]))))))))))))))))),
    BI_i64_bswap) :: ((('_'::('_'::('b'::('u'::('i'::('l'::('t'::('i'::('n'::('_'::('u'::('n'::('r'::('e'::('a'::('c'::('h'::('a'::('b'::('l'::('e'::[]))))))))))))))))))))),
    BI_unreachable) :: ((('_'::('_'::('c'::('o'::('m'::('p'::('c'::('e'::('r'::('t'::('_'::('i'::('6'::('4'::('_'::('u'::('m'::('u'::('l'::('h'::[])))))))))))))))))))),
    BI_i64_umulh) :: ((('_'::('_'::('c'::('o'::('m'::('p'::('c'::('e'::('r'::('t'::('_'::('i'::('6'::('4'::('_'::('s'::('m'::('u'::('l'::('h'::[])))))))))))))))))))),
    BI_i64_smulh) :: ((('_'::('_'::('c'::('o'::('m'::('p'::('c'::('e'::('r'::('t'::('_'::('i'::('6'::('4'::('_'::('s'::('d'::('i'::('v'::[]))))))))))))))))))),
    BI_i64_sdiv) :: ((('_'::('_'::('c'::('o'::('m'::('p'::('c'::('e'::('r'::('t'::('_'::('i'::('6'::('4'::('_'::('u'::('d'::('i'::('v'::[]))))))))))))))))))),
    BI_i64_udiv) :: ((('_'::('_'::('c'::('o'::('m'::('p'::('c'::('e'::('r'::('t'::('_'::('i'::('6'::('4'::('_'::('s'::('m'::('o'::('d'::[]))))))))))))))))))),
    BI_i64_smod) :: ((('_'::('_'::('c'::('o'::('m'::('p'::('c'::('e'::('r'::('t'::('_'::('i'::('6'::('4'::('_'::('u'::('m'::('o'::('d'::[]))))))))))))))))))),
    BI_i64_umod) :: ((('_'::('_'::('c'::('o'::('m'::('p'::('c'::('e'::('r'::('t'::('_'::('i'::('6'::('4'::('_'::('s'::('h'::('l'::[])))))))))))))))))),
    BI_i64_shl) :: ((('_'::('_'::('c'::('o'::('m'::('p'::('c'::('e'::('r'::('t'::('_'::('i'::('6'::('4'::('_'::('s'::('h'::('r'::[])))))))))))))))))),
    BI_i64_shr) :: ((('_'::('_'::('c'::('o'::('m'::('p'::('c'::('e'::('r'::('t'::('_'::('i'::('6'::('4'::('_'::('s'::('a'::('r'::[])))))))))))))))))),
    BI_i64_sar) :: ((('_'::('_'::('c'::('o'::('m'::('p'::('c'::('e'::('r'::('t'::('_'::('i'::('6'::('4'::('_'::('d'::('t'::('o'::('s'::[]))))))))))))))))))),
    BI_i64_dtos) :: ((('_'::('_'::('c'::('o'::('m'::('p'::('c'::('e'::('r'::('t'::('_'::('i'::('6'::('4'::('_'::('d'::('t'::('o'::('u'::[]))))))))))))))))))),
    BI_i64_dtou) :: ((('_'::('_'::('c'::('o'::('m'::('p'::('c'::('e'::('r'::('t'::('_'::('i'::('6'::('4'::('_'::('s'::('t'::('o'::('d'::[]))))))))))))))))))),
    BI_i64_stod) :: ((('_'::('_'::('c'::('o'::('m'::('p'::('c'::('e'::('r'::('t'::('_'::('i'::('6'::('4'::('_'::('u'::('t'::('o'::('d'::[]))))))))))))))))))),
    BI_i64_utod) :: ((('_'::('_'::('c'::('o'::('m'::('p'::('c'::('e'::('r'::('t'::('_'::('i'::('6'::('4'::('_'::('s'::('t'::('o'::('f'::[]))))))))))))))))))),
    BI_i64_stof) :: ((('_'::('_'::('c'::('o'::('m'::('p'::('c'::('e'::('r'::('t'::('_'::('i'::('6'::('4'::('_'::('u'::('t'::('o'::('f'::[]))))))))))))))))))),
    BI_i64_utof) :: [])))))))))))))))))))))))))))))))

(** val standard_builtin_sig : standard_builtin -> signature **)

let standard_builtin_sig = function
| BI_select t0 ->
  let t1 = inj_type t0 in
  { sig_args = (Xint :: (t1 :: (t1 :: []))); sig_res = t1; sig_cc =
  cc_default }
| BI_fabs ->
  { sig_args = (Xfloat :: []); sig_res = Xfloat; sig_cc = cc_default }
| BI_fabsf ->
  { sig_args = (Xsingle :: []); sig_res = Xsingle; sig_cc = cc_default }
| BI_fsqrt ->
  { sig_args = (Xfloat :: []); sig_res = Xfloat; sig_cc = cc_default }
| BI_negl ->
  { sig_args = (Xlong :: []); sig_res = Xlong; sig_cc = cc_default }
| BI_mull ->
  { sig_args = (Xint :: (Xint :: [])); sig_res = Xlong; sig_cc = cc_default }
| BI_i16_bswap ->
  { sig_args = (Xint16unsigned :: []); sig_res = Xint16unsigned; sig_cc =
    cc_default }
| BI_i32_bswap ->
  { sig_args = (Xint :: []); sig_res = Xint; sig_cc = cc_default }
| BI_i64_bswap ->
  { sig_args = (Xlong :: []); sig_res = Xlong; sig_cc = cc_default }
| BI_unreachable -> { sig_args = []; sig_res = Xvoid; sig_cc = cc_default }
| BI_i64_shl ->
  { sig_args = (Xlong :: (Xint :: [])); sig_res = Xlong; sig_cc = cc_default }
| BI_i64_shr ->
  { sig_args = (Xlong :: (Xint :: [])); sig_res = Xlong; sig_cc = cc_default }
| BI_i64_sar ->
  { sig_args = (Xlong :: (Xint :: [])); sig_res = Xlong; sig_cc = cc_default }
| BI_i64_dtos ->
  { sig_args = (Xfloat :: []); sig_res = Xlong; sig_cc = cc_default }
| BI_i64_dtou ->
  { sig_args = (Xfloat :: []); sig_res = Xlong; sig_cc = cc_default }
| BI_i64_stod ->
  { sig_args = (Xlong :: []); sig_res = Xfloat; sig_cc = cc_default }
| BI_i64_utod ->
  { sig_args = (Xlong :: []); sig_res = Xfloat; sig_cc = cc_default }
| BI_i64_stof ->
  { sig_args = (Xlong :: []); sig_res = Xsingle; sig_cc = cc_default }
| BI_i64_utof ->
  { sig_args = (Xlong :: []); sig_res = Xsingle; sig_cc = cc_default }
| _ ->
  { sig_args = (Xlong :: (Xlong :: [])); sig_res = Xlong; sig_cc =
    cc_default }

(** val standard_builtin_sem : standard_builtin -> builtin_sem **)

let standard_builtin_sem = function
| BI_select t0 ->
  (fun vargs ->
    match vargs with
    | [] -> None
    | v :: l ->
      (match v with
       | Vint n0 ->
         (match l with
          | [] -> None
          | v1 :: l0 ->
            (match l0 with
             | [] -> None
             | v2 :: l1 ->
               (match l1 with
                | [] ->
                  Some
                    (Val.normalize (if Int.eq n0 Int.zero then v2 else v1) t0)
                | _ :: _ -> None)))
       | _ -> None))
| BI_fabs -> mkbuiltin_n1t Tfloat Xfloat (Obj.magic Float.abs)
| BI_fabsf -> mkbuiltin_n1t Tsingle Xsingle (Obj.magic Float32.abs)
| BI_fsqrt -> mkbuiltin_n1t Tfloat Xfloat (Obj.magic Float.sqrt)
| BI_negl -> mkbuiltin_n1t Tlong Xlong (Obj.magic Int64.neg)
| BI_addl -> mkbuiltin_v2t Xlong Val.addl
| BI_subl -> mkbuiltin_v2t Xlong Val.subl
| BI_mull -> mkbuiltin_v2t Xlong Val.mull'
| BI_i16_bswap ->
  mkbuiltin_n1t Tint Xint16unsigned (fun n0 ->
    Obj.magic Int.repr
      (decode_int (rev (encode_int (S (S O)) (Int.unsigned (Obj.magic n0))))))
| BI_i32_bswap ->
  mkbuiltin_n1t Tint Xint (fun n0 ->
    Obj.magic Int.repr
      (decode_int
        (rev (encode_int (S (S (S (S O)))) (Int.unsigned (Obj.magic n0))))))
| BI_i64_bswap ->
  mkbuiltin_n1t Tlong Xlong (fun n0 ->
    Obj.magic Int64.repr
      (decode_int
        (rev
          (encode_int (S (S (S (S (S (S (S (S O))))))))
            (Int64.unsigned (Obj.magic n0))))))
| BI_unreachable -> (fun _ -> None)
| BI_i64_umulh -> mkbuiltin_n2t Tlong Tlong Xlong (Obj.magic Int64.mulhu)
| BI_i64_smulh -> mkbuiltin_n2t Tlong Tlong Xlong (Obj.magic Int64.mulhs)
| BI_i64_sdiv -> mkbuiltin_v2p Xlong Val.divls
| BI_i64_udiv -> mkbuiltin_v2p Xlong Val.divlu
| BI_i64_smod -> mkbuiltin_v2p Xlong Val.modls
| BI_i64_umod -> mkbuiltin_v2p Xlong Val.modlu
| BI_i64_shl -> mkbuiltin_v2t Xlong Val.shll
| BI_i64_shr -> mkbuiltin_v2t Xlong Val.shrlu
| BI_i64_sar -> mkbuiltin_v2t Xlong Val.shrl
| BI_i64_dtos -> mkbuiltin_n1p Tfloat Xlong (Obj.magic Float.to_long)
| BI_i64_dtou -> mkbuiltin_n1p Tfloat Xlong (Obj.magic Float.to_longu)
| BI_i64_stod -> mkbuiltin_n1t Tlong Xfloat (Obj.magic Float.of_long)
| BI_i64_utod -> mkbuiltin_n1t Tlong Xfloat (Obj.magic Float.of_longu)
| BI_i64_stof -> mkbuiltin_n1t Tlong Xsingle (Obj.magic Float32.of_long)
| BI_i64_utof -> mkbuiltin_n1t Tlong Xsingle (Obj.magic Float32.of_longu)

type platform_builtin =
| BI_fmin
| BI_fmax

(** val platform_builtin_table : (char list * platform_builtin) list **)

let platform_builtin_table =
  (('_'::('_'::('b'::('u'::('i'::('l'::('t'::('i'::('n'::('_'::('f'::('m'::('i'::('n'::[])))))))))))))),
    BI_fmin) :: ((('_'::('_'::('b'::('u'::('i'::('l'::('t'::('i'::('n'::('_'::('f'::('m'::('a'::('x'::[])))))))))))))),
    BI_fmax) :: [])

(** val platform_builtin_sig : platform_builtin -> signature **)

let platform_builtin_sig _ =
  { sig_args = (Xfloat :: (Xfloat :: [])); sig_res = Xfloat; sig_cc =
    cc_default }

(** val platform_builtin_sem : platform_builtin -> builtin_sem **)

let platform_builtin_sem = function
| BI_fmin ->
  mkbuiltin_n2t Tfloat Tfloat Xfloat (fun f1 f2 ->
    match Float.compare (Obj.magic f1) (Obj.magic f2) with
    | Some c -> (match c with
                 | Lt -> f1
                 | _ -> f2)
    | None -> f2)
| BI_fmax ->
  mkbuiltin_n2t Tfloat Tfloat Xfloat (fun f1 f2 ->
    match Float.compare (Obj.magic f1) (Obj.magic f2) with
    | Some c -> (match c with
                 | Gt -> f1
                 | _ -> f2)
    | None -> f2)

type builtin_function =
| BI_standard of standard_builtin
| BI_platform of platform_builtin

(** val builtin_function_sem : builtin_function -> builtin_sem **)

let builtin_function_sem = function
| BI_standard b0 -> standard_builtin_sem b0
| BI_platform b0 -> platform_builtin_sem b0

(** val lookup_builtin_function :
    char list -> signature -> builtin_function option **)

let lookup_builtin_function name sg =
  match lookup_builtin standard_builtin_sig name sg standard_builtin_table with
  | Some b -> Some (BI_standard b)
  | None ->
    (match lookup_builtin platform_builtin_sig name sg platform_builtin_table with
     | Some b -> Some (BI_platform b)
     | None -> None)

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

(** val e0 : trace **)

let e0 =
  []

type world = __world Lazy.t
and __world =
| World of (char list -> eventval list -> (eventval * world) option)
   * (memory_chunk -> ident -> Ptrofs.int -> (eventval * world) option)
   * (memory_chunk -> ident -> Ptrofs.int -> eventval -> world option)

(** val nextworld_vload :
    world -> memory_chunk -> ident -> Ptrofs.int -> (eventval * world) option **)

let nextworld_vload w chunk id ofs =
  let World (_, vl, _) = Lazy.force w in vl chunk id ofs

(** val nextworld_vstore :
    world -> memory_chunk -> ident -> Ptrofs.int -> eventval -> world option **)

let nextworld_vstore w chunk id ofs v =
  let World (_, _, vs) = Lazy.force w in vs chunk id ofs v

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

(** val noattr : attr **)

let noattr =
  { attr_volatile = false; attr_alignas = None }

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

(** val intsize_eq : intsize -> intsize -> bool **)

let intsize_eq s1 s2 =
  match s1 with
  | I8 -> (match s2 with
           | I8 -> true
           | _ -> false)
  | I16 -> (match s2 with
            | I16 -> true
            | _ -> false)
  | I32 -> (match s2 with
            | I32 -> true
            | _ -> false)
  | IBool -> (match s2 with
              | IBool -> true
              | _ -> false)

(** val signedness_eq : signedness -> signedness -> bool **)

let signedness_eq s1 s2 =
  match s1 with
  | Signed -> (match s2 with
               | Signed -> true
               | Unsigned -> false)
  | Unsigned -> (match s2 with
                 | Signed -> false
                 | Unsigned -> true)

(** val floatsize_eq : floatsize -> floatsize -> bool **)

let floatsize_eq s1 s2 =
  match s1 with
  | F32 -> (match s2 with
            | F32 -> true
            | F64 -> false)
  | F64 -> (match s2 with
            | F32 -> false
            | F64 -> true)

(** val attr_eq : attr -> attr -> bool **)

let attr_eq a1 a2 =
  let { attr_volatile = attr_volatile0; attr_alignas = attr_alignas0 } = a1 in
  let { attr_volatile = attr_volatile1; attr_alignas = attr_alignas1 } = a2 in
  if bool_dec attr_volatile0 attr_volatile1
  then (match attr_alignas0 with
        | Some a ->
          (match attr_alignas1 with
           | Some n0 -> Coq_N.eq_dec a n0
           | None -> false)
        | None -> (match attr_alignas1 with
                   | Some _ -> false
                   | None -> true))
  else false

(** val type_eq : type0 -> type0 -> bool **)

let rec type_eq ty1 ty2 =
  match ty1 with
  | Tvoid -> (match ty2 with
              | Tvoid -> true
              | _ -> false)
  | Tint0 (i, s, a) ->
    (match ty2 with
     | Tint0 (i0, s0, a0) ->
       if intsize_eq i i0
       then if signedness_eq s s0 then attr_eq a a0 else false
       else false
     | _ -> false)
  | Tlong0 (s, a) ->
    (match ty2 with
     | Tlong0 (s0, a0) -> if signedness_eq s s0 then attr_eq a a0 else false
     | _ -> false)
  | Tfloat0 (f, a) ->
    (match ty2 with
     | Tfloat0 (f0, a0) -> if floatsize_eq f f0 then attr_eq a a0 else false
     | _ -> false)
  | Tpointer (t0, a) ->
    (match ty2 with
     | Tpointer (t1, a0) -> if type_eq t0 t1 then attr_eq a a0 else false
     | _ -> false)
  | Tarray (t0, z0, a) ->
    (match ty2 with
     | Tarray (t1, z1, a0) ->
       if type_eq t0 t1
       then if zeq z0 z1 then attr_eq a a0 else false
       else false
     | _ -> false)
  | Tfunction (l, t0, c) ->
    (match ty2 with
     | Tfunction (l0, t1, c0) ->
       if list_eq_dec type_eq l l0
       then if type_eq t0 t1 then calling_convention_eq c c0 else false
       else false
     | _ -> false)
  | Tstruct (i, a) ->
    (match ty2 with
     | Tstruct (i0, a0) -> if ident_eq i i0 then attr_eq a a0 else false
     | _ -> false)
  | Tunion (i, a) ->
    (match ty2 with
     | Tunion (i0, a0) -> if ident_eq i i0 then attr_eq a a0 else false
     | _ -> false)

(** val attr_of_type : type0 -> attr **)

let attr_of_type = function
| Tint0 (_, _, a) -> a
| Tlong0 (_, a) -> a
| Tfloat0 (_, a) -> a
| Tpointer (_, a) -> a
| Tarray (_, _, a) -> a
| Tstruct (_, a) -> a
| Tunion (_, a) -> a
| _ -> noattr

(** val change_attributes : (attr -> attr) -> type0 -> type0 **)

let change_attributes f ty = match ty with
| Tint0 (sz, si, a) -> Tint0 (sz, si, (f a))
| Tlong0 (si, a) -> Tlong0 (si, (f a))
| Tfloat0 (sz, a) -> Tfloat0 (sz, (f a))
| Tpointer (elt0, a) -> Tpointer (elt0, (f a))
| Tarray (elt0, sz, a) -> Tarray (elt0, sz, (f a))
| Tstruct (id, a) -> Tstruct (id, (f a))
| Tunion (id, a) -> Tunion (id, (f a))
| _ -> ty

(** val remove_attributes : type0 -> type0 **)

let remove_attributes ty =
  change_attributes (fun _ -> noattr) ty

(** val bitsize_intsize : intsize -> z **)

let bitsize_intsize = function
| I8 -> Zpos (XO (XO (XO XH)))
| I16 -> Zpos (XO (XO (XO (XO XH))))
| I32 -> Zpos (XO (XO (XO (XO (XO XH)))))
| IBool -> Zpos XH

type struct_or_union =
| Struct
| Union

type member =
| Member_plain of ident * type0
| Member_bitfield of ident * intsize * signedness * attr * z * bool

type members = member list

type composite_definition =
| Composite of ident * struct_or_union * members * attr

(** val name_member : member -> ident **)

let name_member = function
| Member_plain (id, _) -> id
| Member_bitfield (id, _, _, _, _, _) -> id

(** val type_member : member -> type0 **)

let type_member = function
| Member_plain (_, t0) -> t0
| Member_bitfield (_, sz, sg, a, w, _) ->
  let sg' = if zlt w (bitsize_intsize sz) then Signed else sg in
  Tint0 (sz, sg', a)

(** val member_is_padding : member -> bool **)

let member_is_padding = function
| Member_plain (_, _) -> false
| Member_bitfield (_, _, _, _, _, p) -> p

type composite = { co_su : struct_or_union; co_members : members;
                   co_attr : attr; co_sizeof : z; co_alignof : z;
                   co_rank : nat }

type composite_env = composite PTree.t

type bitfield =
| Full
| Bits of intsize * signedness * z * z

(** val type_int32s : type0 **)

let type_int32s =
  Tint0 (I32, Signed, noattr)

(** val type_bool : type0 **)

let type_bool =
  Tint0 (IBool, Signed, noattr)

(** val typeconv : type0 -> type0 **)

let typeconv ty = match ty with
| Tint0 (i, _, _) ->
  (match i with
   | I32 -> remove_attributes ty
   | _ -> Tint0 (I32, Signed, noattr))
| Tarray (t0, _, _) -> Tpointer (t0, noattr)
| Tfunction (_, _, _) -> Tpointer (ty, noattr)
| _ -> remove_attributes ty

(** val complete_type : composite_env -> type0 -> bool **)

let rec complete_type env0 = function
| Tvoid -> false
| Tarray (t', _, _) -> complete_type env0 t'
| Tfunction (_, _, _) -> false
| Tstruct (id, _) ->
  (match PTree.get id env0 with
   | Some _ -> true
   | None -> false)
| Tunion (id, _) ->
  (match PTree.get id env0 with
   | Some _ -> true
   | None -> false)
| _ -> true

(** val align_attr : attr -> z -> z **)

let align_attr a al =
  match a.attr_alignas with
  | Some l -> two_p (Coq_Z.of_N l)
  | None -> al

(** val alignof : composite_env -> type0 -> z **)

let rec alignof env0 t0 =
  align_attr (attr_of_type t0)
    (match t0 with
     | Tint0 (i, _, _) ->
       (match i with
        | I16 -> Zpos (XO XH)
        | I32 -> Zpos (XO (XO XH))
        | _ -> Zpos XH)
     | Tlong0 (_, _) -> align_int64
     | Tfloat0 (f, _) ->
       (match f with
        | F32 -> Zpos (XO (XO XH))
        | F64 -> align_float64)
     | Tpointer (_, _) ->
       if ptr64 then Zpos (XO (XO (XO XH))) else Zpos (XO (XO XH))
     | Tarray (t', _, _) -> alignof env0 t'
     | Tstruct (id, _) ->
       (match PTree.get id env0 with
        | Some co -> co.co_alignof
        | None -> Zpos XH)
     | Tunion (id, _) ->
       (match PTree.get id env0 with
        | Some co -> co.co_alignof
        | None -> Zpos XH)
     | _ -> Zpos XH)

(** val sizeof : composite_env -> type0 -> z **)

let rec sizeof env0 = function
| Tint0 (i, _, _) ->
  (match i with
   | I16 -> Zpos (XO XH)
   | I32 -> Zpos (XO (XO XH))
   | _ -> Zpos XH)
| Tlong0 (_, _) -> Zpos (XO (XO (XO XH)))
| Tfloat0 (f, _) ->
  (match f with
   | F32 -> Zpos (XO (XO XH))
   | F64 -> Zpos (XO (XO (XO XH))))
| Tpointer (_, _) ->
  if ptr64 then Zpos (XO (XO (XO XH))) else Zpos (XO (XO XH))
| Tarray (t', n0, _) -> Coq_Z.mul (sizeof env0 t') (Coq_Z.max Z0 n0)
| Tstruct (id, _) ->
  (match PTree.get id env0 with
   | Some co -> co.co_sizeof
   | None -> Z0)
| Tunion (id, _) ->
  (match PTree.get id env0 with
   | Some co -> co.co_sizeof
   | None -> Z0)
| _ -> Zpos XH

(** val bitalignof : composite_env -> type0 -> z **)

let bitalignof env0 t0 =
  Coq_Z.mul (alignof env0 t0) (Zpos (XO (XO (XO XH))))

(** val bitsizeof : composite_env -> type0 -> z **)

let bitsizeof env0 t0 =
  Coq_Z.mul (sizeof env0 t0) (Zpos (XO (XO (XO XH))))

(** val bitalignof_intsize : intsize -> z **)

let bitalignof_intsize = function
| I16 -> Zpos (XO (XO (XO (XO XH))))
| I32 -> Zpos (XO (XO (XO (XO (XO XH)))))
| _ -> Zpos (XO (XO (XO XH)))

(** val next_field : composite_env -> z -> member -> z **)

let next_field env0 pos = function
| Member_plain (_, t0) ->
  Coq_Z.add (align pos (bitalignof env0 t0)) (bitsizeof env0 t0)
| Member_bitfield (_, sz, _, _, w, _) ->
  let s = bitalignof_intsize sz in
  if zle w Z0
  then align pos s
  else let curr = floor pos s in
       let next = Coq_Z.add curr s in
       if zle (Coq_Z.add pos w) next
       then Coq_Z.add pos w
       else Coq_Z.add next w

(** val layout_field : composite_env -> z -> member -> (z * bitfield) res **)

let layout_field env0 pos = function
| Member_plain (_, t0) ->
  OK ((Coq_Z.div (align pos (bitalignof env0 t0)) (Zpos (XO (XO (XO XH))))),
    Full)
| Member_bitfield (_, sz, sg, _, w, _) ->
  if zle w Z0
  then Error
         (msg
           ('a'::('c'::('c'::('e'::('s'::('s'::('i'::('n'::('g'::(' '::('z'::('e'::('r'::('o'::('-'::('w'::('i'::('d'::('t'::('h'::(' '::('b'::('i'::('t'::('f'::('i'::('e'::('l'::('d'::[]))))))))))))))))))))))))))))))
  else if zlt (bitsize_intsize sz) w
       then Error
              (msg
                ('b'::('i'::('t'::('f'::('i'::('e'::('l'::('d'::(' '::('t'::('o'::('o'::(' '::('w'::('i'::('d'::('e'::[]))))))))))))))))))
       else let s = bitalignof_intsize sz in
            let start = floor pos s in
            let next = Coq_Z.add start s in
            if zle (Coq_Z.add pos w) next
            then OK ((Coq_Z.div start (Zpos (XO (XO (XO XH))))), (Bits (sz,
                   sg, (Coq_Z.sub pos start), w)))
            else OK ((Coq_Z.div next (Zpos (XO (XO (XO XH))))), (Bits (sz,
                   sg, Z0, w)))

(** val alignof_composite : composite_env -> members -> z **)

let rec alignof_composite env0 = function
| [] -> Zpos XH
| m :: ms0 ->
  if member_is_padding m
  then alignof_composite env0 ms0
  else Coq_Z.max (alignof env0 (type_member m)) (alignof_composite env0 ms0)

(** val bitsizeof_struct : composite_env -> z -> members -> z **)

let rec bitsizeof_struct env0 cur = function
| [] -> cur
| m :: ms0 -> bitsizeof_struct env0 (next_field env0 cur m) ms0

(** val bytes_of_bits : z -> z **)

let bytes_of_bits n0 =
  Coq_Z.div (Coq_Z.add n0 (Zpos (XI (XI XH)))) (Zpos (XO (XO (XO XH))))

(** val sizeof_struct : composite_env -> members -> z **)

let sizeof_struct env0 m =
  bytes_of_bits (bitsizeof_struct env0 Z0 m)

(** val sizeof_union : composite_env -> members -> z **)

let rec sizeof_union env0 = function
| [] -> Z0
| m :: ms0 -> Coq_Z.max (sizeof env0 (type_member m)) (sizeof_union env0 ms0)

(** val field_offset_rec :
    composite_env -> ident -> members -> z -> (z * bitfield) res **)

let rec field_offset_rec env0 id ms pos =
  match ms with
  | [] ->
    Error ((MSG
      ('U'::('n'::('k'::('n'::('o'::('w'::('n'::(' '::('f'::('i'::('e'::('l'::('d'::(' '::[]))))))))))))))) :: ((CTX
      id) :: []))
  | m :: ms0 ->
    if ident_eq id (name_member m)
    then layout_field env0 pos m
    else field_offset_rec env0 id ms0 (next_field env0 pos m)

(** val field_offset :
    composite_env -> ident -> members -> (z * bitfield) res **)

let field_offset env0 id ms =
  field_offset_rec env0 id ms Z0

(** val union_field_offset :
    composite_env -> ident -> members -> (z * bitfield) res **)

let rec union_field_offset env0 id = function
| [] ->
  Error ((MSG
    ('U'::('n'::('k'::('n'::('o'::('w'::('n'::(' '::('f'::('i'::('e'::('l'::('d'::(' '::[]))))))))))))))) :: ((CTX
    id) :: []))
| m :: ms0 ->
  if ident_eq id (name_member m)
  then layout_field env0 Z0 m
  else union_field_offset env0 id ms0

type mode0 =
| By_value of memory_chunk
| By_reference
| By_copy
| By_nothing

(** val access_mode : type0 -> mode0 **)

let access_mode = function
| Tvoid -> By_nothing
| Tint0 (i, s, _) ->
  (match i with
   | I8 ->
     (match s with
      | Signed -> By_value Mint8signed
      | Unsigned -> By_value Mint8unsigned)
   | I16 ->
     (match s with
      | Signed -> By_value Mint16signed
      | Unsigned -> By_value Mint16unsigned)
   | I32 -> By_value Mint32
   | IBool -> By_value Mbool)
| Tlong0 (_, _) -> By_value Mint64
| Tfloat0 (f, _) ->
  (match f with
   | F32 -> By_value Mfloat32
   | F64 -> By_value Mfloat64)
| Tpointer (_, _) -> By_value mptr
| Tarray (_, _, _) -> By_reference
| Tfunction (_, _, _) -> By_reference
| _ -> By_copy

(** val type_is_volatile : type0 -> bool **)

let type_is_volatile ty =
  match access_mode ty with
  | By_value _ -> (attr_of_type ty).attr_volatile
  | _ -> false

(** val alignof_blockcopy : composite_env -> type0 -> z **)

let rec alignof_blockcopy env0 = function
| Tint0 (i, _, _) ->
  (match i with
   | I16 -> Zpos (XO XH)
   | I32 -> Zpos (XO (XO XH))
   | _ -> Zpos XH)
| Tlong0 (_, _) -> align_int64
| Tfloat0 (f, _) ->
  (match f with
   | F32 -> Zpos (XO (XO XH))
   | F64 -> align_float64)
| Tpointer (_, _) ->
  if ptr64 then Zpos (XO (XO (XO XH))) else Zpos (XO (XO XH))
| Tarray (t', _, _) -> alignof_blockcopy env0 t'
| Tstruct (id, _) ->
  (match PTree.get id env0 with
   | Some co -> Coq_Z.min (Zpos (XO (XO (XO XH)))) co.co_alignof
   | None -> Zpos XH)
| Tunion (id, _) ->
  (match PTree.get id env0 with
   | Some co -> Coq_Z.min (Zpos (XO (XO (XO XH)))) co.co_alignof
   | None -> Zpos XH)
| _ -> Zpos XH

(** val rank_type : composite_env -> type0 -> nat **)

let rec rank_type ce = function
| Tarray (t', _, _) -> S (rank_type ce t')
| Tstruct (id, _) ->
  (match PTree.get id ce with
   | Some co -> S co.co_rank
   | None -> O)
| Tunion (id, _) ->
  (match PTree.get id ce with
   | Some co -> S co.co_rank
   | None -> O)
| _ -> O

(** val rank_members : composite_env -> members -> nat **)

let rec rank_members ce = function
| [] -> O
| m0 :: m1 ->
  (match m0 with
   | Member_plain (_, t0) -> max (rank_type ce t0) (rank_members ce m1)
   | Member_bitfield (_, _, _, _, _, _) -> rank_members ce m1)

(** val type_of_params : (ident * type0) list -> type0 list **)

let type_of_params params =
  map snd params

(** val sizeof_composite :
    composite_env -> struct_or_union -> members -> z **)

let sizeof_composite env0 su m =
  match su with
  | Struct -> sizeof_struct env0 m
  | Union -> sizeof_union env0 m

(** val complete_members : composite_env -> members -> bool **)

let rec complete_members env0 = function
| [] -> true
| m :: ms0 ->
  (&&) (complete_type env0 (type_member m)) (complete_members env0 ms0)

(** val composite_of_def :
    composite_env -> ident -> struct_or_union -> members -> attr -> composite
    res **)

let composite_of_def env0 id su m a =
  match PTree.get id env0 with
  | Some _ ->
    Error ((MSG
      ('M'::('u'::('l'::('t'::('i'::('p'::('l'::('e'::(' '::('d'::('e'::('f'::('i'::('n'::('i'::('t'::('i'::('o'::('n'::('s'::(' '::('o'::('f'::(' '::('s'::('t'::('r'::('u'::('c'::('t'::(' '::('o'::('r'::(' '::('u'::('n'::('i'::('o'::('n'::(' '::[]))))))))))))))))))))))))))))))))))))))))) :: ((CTX
      id) :: []))
  | None ->
    if complete_members env0 m
    then let al = align_attr a (alignof_composite env0 m) in
         OK { co_su = su; co_members = m; co_attr = a; co_sizeof =
         (align (sizeof_composite env0 su m) al); co_alignof = al; co_rank =
         (rank_members env0 m) }
    else Error ((MSG
           ('I'::('n'::('c'::('o'::('m'::('p'::('l'::('e'::('t'::('e'::(' '::('s'::('t'::('r'::('u'::('c'::('t'::(' '::('o'::('r'::(' '::('u'::('n'::('i'::('o'::('n'::(' '::[])))))))))))))))))))))))))))) :: ((CTX
           id) :: []))

(** val add_composite_definitions :
    composite_env -> composite_definition list -> composite_env res **)

let rec add_composite_definitions env0 = function
| [] -> OK env0
| c :: defs0 ->
  let Composite (id, su, m, a) = c in
  bind (composite_of_def env0 id su m a) (fun co ->
    add_composite_definitions (PTree.set id co env0) defs0)

(** val build_composite_env :
    composite_definition list -> composite_env res **)

let build_composite_env defs =
  add_composite_definitions PTree.empty defs

type 'f fundef =
| Internal of 'f
| External of external_function * type0 list * type0 * calling_convention

type 'f program0 = { prog_defs0 : (ident * ('f fundef, type0) globdef) list;
                     prog_public0 : ident list; prog_main0 : ident;
                     prog_types : composite_definition list;
                     prog_comp_env : composite_env }

(** val program_of_program : 'a1 program0 -> ('a1 fundef, type0) program **)

let program_of_program p =
  { prog_defs = p.prog_defs0; prog_public = p.prog_public0; prog_main =
    p.prog_main0 }

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

(** val classify_cast : type0 -> type0 -> classify_cast_cases **)

let classify_cast tfrom = function
| Tvoid -> Cast_case_void
| Tint0 (sz2, si2, _) ->
  (match tfrom with
   | Tvoid -> Cast_case_default
   | Tint0 (_, _, _) ->
     (match sz2 with
      | I32 -> if ptr64 then Cast_case_i2i (sz2, si2) else Cast_case_pointer
      | IBool -> Cast_case_i2bool
      | _ -> Cast_case_i2i (sz2, si2))
   | Tlong0 (_, _) ->
     if intsize_eq sz2 IBool
     then Cast_case_l2bool
     else Cast_case_l2i (sz2, si2)
   | Tfloat0 (f, _) ->
     (match f with
      | F32 ->
        if intsize_eq sz2 IBool
        then Cast_case_s2bool
        else Cast_case_s2i (sz2, si2)
      | F64 ->
        if intsize_eq sz2 IBool
        then Cast_case_f2bool
        else Cast_case_f2i (sz2, si2))
   | Tstruct (_, _) -> Cast_case_default
   | Tunion (_, _) -> Cast_case_default
   | _ ->
     if ptr64
     then if intsize_eq sz2 IBool
          then Cast_case_l2bool
          else Cast_case_l2i (sz2, si2)
     else (match sz2 with
           | I32 -> Cast_case_pointer
           | IBool -> Cast_case_i2bool
           | _ -> Cast_case_i2i (sz2, si2)))
| Tlong0 (si2, _) ->
  (match tfrom with
   | Tvoid -> Cast_case_default
   | Tint0 (_, si1, _) -> Cast_case_i2l si1
   | Tlong0 (_, _) -> if ptr64 then Cast_case_pointer else Cast_case_l2l
   | Tfloat0 (f, _) ->
     (match f with
      | F32 -> Cast_case_s2l si2
      | F64 -> Cast_case_f2l si2)
   | Tstruct (_, _) -> Cast_case_default
   | Tunion (_, _) -> Cast_case_default
   | _ -> if ptr64 then Cast_case_pointer else Cast_case_i2l si2)
| Tfloat0 (f, _) ->
  (match f with
   | F32 ->
     (match tfrom with
      | Tint0 (_, si1, _) -> Cast_case_i2s si1
      | Tlong0 (si1, _) -> Cast_case_l2s si1
      | Tfloat0 (f0, _) ->
        (match f0 with
         | F32 -> Cast_case_s2s
         | F64 -> Cast_case_f2s)
      | _ -> Cast_case_default)
   | F64 ->
     (match tfrom with
      | Tint0 (_, si1, _) -> Cast_case_i2f si1
      | Tlong0 (si1, _) -> Cast_case_l2f si1
      | Tfloat0 (f0, _) ->
        (match f0 with
         | F32 -> Cast_case_s2f
         | F64 -> Cast_case_f2f)
      | _ -> Cast_case_default))
| Tpointer (_, _) ->
  (match tfrom with
   | Tint0 (_, si, _) -> if ptr64 then Cast_case_i2l si else Cast_case_pointer
   | Tlong0 (_, _) ->
     if ptr64 then Cast_case_pointer else Cast_case_l2i (I32, Unsigned)
   | Tpointer (_, _) -> Cast_case_pointer
   | Tarray (_, _, _) -> Cast_case_pointer
   | Tfunction (_, _, _) -> Cast_case_pointer
   | _ -> Cast_case_default)
| Tstruct (id2, _) ->
  (match tfrom with
   | Tstruct (id1, _) -> Cast_case_struct (id1, id2)
   | _ -> Cast_case_default)
| Tunion (id2, _) ->
  (match tfrom with
   | Tunion (id1, _) -> Cast_case_union (id1, id2)
   | _ -> Cast_case_default)
| _ -> Cast_case_default

(** val cast_int_int : intsize -> signedness -> Int.int -> Int.int **)

let cast_int_int sz sg i =
  match sz with
  | I8 ->
    (match sg with
     | Signed -> Int.sign_ext (Zpos (XO (XO (XO XH)))) i
     | Unsigned -> Int.zero_ext (Zpos (XO (XO (XO XH)))) i)
  | I16 ->
    (match sg with
     | Signed -> Int.sign_ext (Zpos (XO (XO (XO (XO XH))))) i
     | Unsigned -> Int.zero_ext (Zpos (XO (XO (XO (XO XH))))) i)
  | I32 -> i
  | IBool -> if Int.eq i Int.zero then Int.zero else Int.one

(** val cast_int_float : signedness -> Int.int -> float **)

let cast_int_float si i =
  match si with
  | Signed -> Float.of_int i
  | Unsigned -> Float.of_intu i

(** val cast_float_int : signedness -> float -> Int.int option **)

let cast_float_int si f =
  match si with
  | Signed -> Float.to_int f
  | Unsigned -> Float.to_intu f

(** val cast_int_single : signedness -> Int.int -> float32 **)

let cast_int_single si i =
  match si with
  | Signed -> Float32.of_int i
  | Unsigned -> Float32.of_intu i

(** val cast_single_int : signedness -> float32 -> Int.int option **)

let cast_single_int si f =
  match si with
  | Signed -> Float32.to_int f
  | Unsigned -> Float32.to_intu f

(** val cast_int_long : signedness -> Int.int -> Int64.int **)

let cast_int_long si i =
  match si with
  | Signed -> Int64.repr (Int.signed i)
  | Unsigned -> Int64.repr (Int.unsigned i)

(** val cast_long_float : signedness -> Int64.int -> float **)

let cast_long_float si i =
  match si with
  | Signed -> Float.of_long i
  | Unsigned -> Float.of_longu i

(** val cast_long_single : signedness -> Int64.int -> float32 **)

let cast_long_single si i =
  match si with
  | Signed -> Float32.of_long i
  | Unsigned -> Float32.of_longu i

(** val cast_float_long : signedness -> float -> Int64.int option **)

let cast_float_long si f =
  match si with
  | Signed -> Float.to_long f
  | Unsigned -> Float.to_longu f

(** val cast_single_long : signedness -> float32 -> Int64.int option **)

let cast_single_long si f =
  match si with
  | Signed -> Float32.to_long f
  | Unsigned -> Float32.to_longu f

(** val sem_cast : val0 -> type0 -> type0 -> Mem.mem -> val0 option **)

let sem_cast v t1 t2 m =
  match classify_cast t1 t2 with
  | Cast_case_pointer ->
    (match v with
     | Vint _ -> if ptr64 then None else Some v
     | Vlong _ -> if ptr64 then Some v else None
     | Vptr (_, _) -> Some v
     | _ -> None)
  | Cast_case_i2i (sz2, si2) ->
    (match v with
     | Vint i -> Some (Vint (cast_int_int sz2 si2 i))
     | _ -> None)
  | Cast_case_f2f -> (match v with
                      | Vfloat f -> Some (Vfloat f)
                      | _ -> None)
  | Cast_case_s2s -> (match v with
                      | Vsingle f -> Some (Vsingle f)
                      | _ -> None)
  | Cast_case_f2s ->
    (match v with
     | Vfloat f -> Some (Vsingle (Float.to_single f))
     | _ -> None)
  | Cast_case_s2f ->
    (match v with
     | Vsingle f -> Some (Vfloat (Float.of_single f))
     | _ -> None)
  | Cast_case_i2f si1 ->
    (match v with
     | Vint i -> Some (Vfloat (cast_int_float si1 i))
     | _ -> None)
  | Cast_case_i2s si1 ->
    (match v with
     | Vint i -> Some (Vsingle (cast_int_single si1 i))
     | _ -> None)
  | Cast_case_f2i (sz2, si2) ->
    (match v with
     | Vfloat f ->
       (match cast_float_int si2 f with
        | Some i -> Some (Vint (cast_int_int sz2 si2 i))
        | None -> None)
     | _ -> None)
  | Cast_case_s2i (sz2, si2) ->
    (match v with
     | Vsingle f ->
       (match cast_single_int si2 f with
        | Some i -> Some (Vint (cast_int_int sz2 si2 i))
        | None -> None)
     | _ -> None)
  | Cast_case_l2l -> (match v with
                      | Vlong n0 -> Some (Vlong n0)
                      | _ -> None)
  | Cast_case_i2l si ->
    (match v with
     | Vint n0 -> Some (Vlong (cast_int_long si n0))
     | _ -> None)
  | Cast_case_l2i (sz, si) ->
    (match v with
     | Vlong n0 ->
       Some (Vint (cast_int_int sz si (Int.repr (Int64.unsigned n0))))
     | _ -> None)
  | Cast_case_l2f si1 ->
    (match v with
     | Vlong i -> Some (Vfloat (cast_long_float si1 i))
     | _ -> None)
  | Cast_case_l2s si1 ->
    (match v with
     | Vlong i -> Some (Vsingle (cast_long_single si1 i))
     | _ -> None)
  | Cast_case_f2l si2 ->
    (match v with
     | Vfloat f ->
       (match cast_float_long si2 f with
        | Some i -> Some (Vlong i)
        | None -> None)
     | _ -> None)
  | Cast_case_s2l si2 ->
    (match v with
     | Vsingle f ->
       (match cast_single_long si2 f with
        | Some i -> Some (Vlong i)
        | None -> None)
     | _ -> None)
  | Cast_case_i2bool ->
    (match v with
     | Vint n0 ->
       Some (Vint (if Int.eq n0 Int.zero then Int.zero else Int.one))
     | Vptr (b, ofs) ->
       if ptr64
       then None
       else if Mem.weak_valid_pointer m b (Ptrofs.unsigned ofs)
            then Some vone
            else None
     | _ -> None)
  | Cast_case_l2bool ->
    (match v with
     | Vlong n0 ->
       Some (Vint (if Int64.eq n0 Int64.zero then Int.zero else Int.one))
     | Vptr (b, ofs) ->
       if negb ptr64
       then None
       else if Mem.weak_valid_pointer m b (Ptrofs.unsigned ofs)
            then Some vone
            else None
     | _ -> None)
  | Cast_case_f2bool ->
    (match v with
     | Vfloat f ->
       Some (Vint (if Float.cmp Ceq f Float.zero then Int.zero else Int.one))
     | _ -> None)
  | Cast_case_s2bool ->
    (match v with
     | Vsingle f ->
       Some (Vint
         (if Float32.cmp Ceq f Float32.zero then Int.zero else Int.one))
     | _ -> None)
  | Cast_case_struct (id1, id2) ->
    (match v with
     | Vptr (_, _) -> if ident_eq id1 id2 then Some v else None
     | _ -> None)
  | Cast_case_union (id1, id2) ->
    (match v with
     | Vptr (_, _) -> if ident_eq id1 id2 then Some v else None
     | _ -> None)
  | Cast_case_void -> Some v
  | Cast_case_default -> None

type classify_bool_cases =
| Bool_case_i
| Bool_case_l
| Bool_case_f
| Bool_case_s
| Bool_default

(** val classify_bool : type0 -> classify_bool_cases **)

let classify_bool ty =
  match typeconv ty with
  | Tint0 (_, _, _) -> Bool_case_i
  | Tlong0 (_, _) -> Bool_case_l
  | Tfloat0 (f, _) -> (match f with
                       | F32 -> Bool_case_s
                       | F64 -> Bool_case_f)
  | Tpointer (_, _) -> if ptr64 then Bool_case_l else Bool_case_i
  | _ -> Bool_default

(** val bool_val : val0 -> type0 -> Mem.mem -> bool option **)

let bool_val v t0 m =
  match classify_bool t0 with
  | Bool_case_i ->
    (match v with
     | Vint n0 -> Some (negb (Int.eq n0 Int.zero))
     | Vptr (b, ofs) ->
       if ptr64
       then None
       else if Mem.weak_valid_pointer m b (Ptrofs.unsigned ofs)
            then Some true
            else None
     | _ -> None)
  | Bool_case_l ->
    (match v with
     | Vlong n0 -> Some (negb (Int64.eq n0 Int64.zero))
     | Vptr (b, ofs) ->
       if negb ptr64
       then None
       else if Mem.weak_valid_pointer m b (Ptrofs.unsigned ofs)
            then Some true
            else None
     | _ -> None)
  | Bool_case_f ->
    (match v with
     | Vfloat f -> Some (negb (Float.cmp Ceq f Float.zero))
     | _ -> None)
  | Bool_case_s ->
    (match v with
     | Vsingle f -> Some (negb (Float32.cmp Ceq f Float32.zero))
     | _ -> None)
  | Bool_default -> None

(** val sem_notbool : val0 -> type0 -> Mem.mem -> val0 option **)

let sem_notbool v ty m =
  option_map (fun b -> Val.of_bool (negb b)) (bool_val v ty m)

type classify_neg_cases =
| Neg_case_i of signedness
| Neg_case_f
| Neg_case_s
| Neg_case_l of signedness
| Neg_default

(** val classify_neg : type0 -> classify_neg_cases **)

let classify_neg = function
| Tint0 (i, s, _) ->
  (match i with
   | I32 -> Neg_case_i s
   | _ -> Neg_case_i Signed)
| Tlong0 (si, _) -> Neg_case_l si
| Tfloat0 (f, _) -> (match f with
                     | F32 -> Neg_case_s
                     | F64 -> Neg_case_f)
| _ -> Neg_default

(** val sem_neg : val0 -> type0 -> val0 option **)

let sem_neg v ty =
  match classify_neg ty with
  | Neg_case_i _ ->
    (match v with
     | Vint n0 -> Some (Vint (Int.neg n0))
     | _ -> None)
  | Neg_case_f ->
    (match v with
     | Vfloat f -> Some (Vfloat (Float.neg f))
     | _ -> None)
  | Neg_case_s ->
    (match v with
     | Vsingle f -> Some (Vsingle (Float32.neg f))
     | _ -> None)
  | Neg_case_l _ ->
    (match v with
     | Vlong n0 -> Some (Vlong (Int64.neg n0))
     | _ -> None)
  | Neg_default -> None

(** val sem_absfloat : val0 -> type0 -> val0 option **)

let sem_absfloat v ty =
  match classify_neg ty with
  | Neg_case_i sg ->
    (match v with
     | Vint n0 -> Some (Vfloat (Float.abs (cast_int_float sg n0)))
     | _ -> None)
  | Neg_case_f ->
    (match v with
     | Vfloat f -> Some (Vfloat (Float.abs f))
     | _ -> None)
  | Neg_case_s ->
    (match v with
     | Vsingle f -> Some (Vfloat (Float.abs (Float.of_single f)))
     | _ -> None)
  | Neg_case_l sg ->
    (match v with
     | Vlong n0 -> Some (Vfloat (Float.abs (cast_long_float sg n0)))
     | _ -> None)
  | Neg_default -> None

type classify_notint_cases =
| Notint_case_i of signedness
| Notint_case_l of signedness
| Notint_default

(** val classify_notint : type0 -> classify_notint_cases **)

let classify_notint = function
| Tint0 (i, s, _) ->
  (match i with
   | I32 -> Notint_case_i s
   | _ -> Notint_case_i Signed)
| Tlong0 (si, _) -> Notint_case_l si
| _ -> Notint_default

(** val sem_notint : val0 -> type0 -> val0 option **)

let sem_notint v ty =
  match classify_notint ty with
  | Notint_case_i _ ->
    (match v with
     | Vint n0 -> Some (Vint (Int.not n0))
     | _ -> None)
  | Notint_case_l _ ->
    (match v with
     | Vlong n0 -> Some (Vlong (Int64.not n0))
     | _ -> None)
  | Notint_default -> None

type binarith_cases =
| Bin_case_i of signedness
| Bin_case_l of signedness
| Bin_case_f
| Bin_case_s
| Bin_default

(** val classify_binarith : type0 -> type0 -> binarith_cases **)

let classify_binarith ty1 ty2 =
  match ty1 with
  | Tint0 (i, s, _) ->
    (match i with
     | I32 ->
       (match s with
        | Signed ->
          (match ty2 with
           | Tint0 (i0, s0, _) ->
             (match i0 with
              | I32 -> Bin_case_i s0
              | _ -> Bin_case_i Signed)
           | Tlong0 (sg, _) -> Bin_case_l sg
           | Tfloat0 (f, _) ->
             (match f with
              | F32 -> Bin_case_s
              | F64 -> Bin_case_f)
           | _ -> Bin_default)
        | Unsigned ->
          (match ty2 with
           | Tint0 (_, _, _) -> Bin_case_i Unsigned
           | Tlong0 (sg, _) -> Bin_case_l sg
           | Tfloat0 (f, _) ->
             (match f with
              | F32 -> Bin_case_s
              | F64 -> Bin_case_f)
           | _ -> Bin_default))
     | _ ->
       (match ty2 with
        | Tint0 (i0, s0, _) ->
          (match i0 with
           | I32 -> Bin_case_i s0
           | _ -> Bin_case_i Signed)
        | Tlong0 (sg, _) -> Bin_case_l sg
        | Tfloat0 (f, _) ->
          (match f with
           | F32 -> Bin_case_s
           | F64 -> Bin_case_f)
        | _ -> Bin_default))
  | Tlong0 (sg, _) ->
    (match sg with
     | Signed ->
       (match ty2 with
        | Tint0 (_, _, _) -> Bin_case_l sg
        | Tlong0 (s, _) -> Bin_case_l s
        | Tfloat0 (f, _) ->
          (match f with
           | F32 -> Bin_case_s
           | F64 -> Bin_case_f)
        | _ -> Bin_default)
     | Unsigned ->
       (match ty2 with
        | Tint0 (_, _, _) -> Bin_case_l sg
        | Tlong0 (_, _) -> Bin_case_l Unsigned
        | Tfloat0 (f, _) ->
          (match f with
           | F32 -> Bin_case_s
           | F64 -> Bin_case_f)
        | _ -> Bin_default))
  | Tfloat0 (f, _) ->
    (match f with
     | F32 ->
       (match ty2 with
        | Tint0 (_, _, _) -> Bin_case_s
        | Tlong0 (_, _) -> Bin_case_s
        | Tfloat0 (f0, _) ->
          (match f0 with
           | F32 -> Bin_case_s
           | F64 -> Bin_case_f)
        | _ -> Bin_default)
     | F64 ->
       (match ty2 with
        | Tint0 (_, _, _) -> Bin_case_f
        | Tlong0 (_, _) -> Bin_case_f
        | Tfloat0 (_, _) -> Bin_case_f
        | _ -> Bin_default))
  | _ -> Bin_default

(** val binarith_type : binarith_cases -> type0 **)

let binarith_type = function
| Bin_case_i sg -> Tint0 (I32, sg, noattr)
| Bin_case_l sg -> Tlong0 (sg, noattr)
| Bin_case_f -> Tfloat0 (F64, noattr)
| Bin_case_s -> Tfloat0 (F32, noattr)
| Bin_default -> Tvoid

(** val sem_binarith :
    (signedness -> Int.int -> Int.int -> val0 option) -> (signedness ->
    Int64.int -> Int64.int -> val0 option) -> (float -> float -> val0 option)
    -> (float32 -> float32 -> val0 option) -> val0 -> type0 -> val0 -> type0
    -> Mem.mem -> val0 option **)

let sem_binarith sem_int sem_long sem_float sem_single v1 t1 v2 t2 m =
  let c = classify_binarith t1 t2 in
  let t0 = binarith_type c in
  (match sem_cast v1 t1 t0 m with
   | Some v1' ->
     (match sem_cast v2 t2 t0 m with
      | Some v2' ->
        (match c with
         | Bin_case_i sg ->
           (match v1' with
            | Vint n1 ->
              (match v2' with
               | Vint n2 -> sem_int sg n1 n2
               | _ -> None)
            | _ -> None)
         | Bin_case_l sg ->
           (match v1' with
            | Vlong n1 ->
              (match v2' with
               | Vlong n2 -> sem_long sg n1 n2
               | _ -> None)
            | _ -> None)
         | Bin_case_f ->
           (match v1' with
            | Vfloat n1 ->
              (match v2' with
               | Vfloat n2 -> sem_float n1 n2
               | _ -> None)
            | _ -> None)
         | Bin_case_s ->
           (match v1' with
            | Vsingle n1 ->
              (match v2' with
               | Vsingle n2 -> sem_single n1 n2
               | _ -> None)
            | _ -> None)
         | Bin_default -> None)
      | None -> None)
   | None -> None)

type classify_add_cases =
| Add_case_pi of type0 * signedness
| Add_case_pl of type0
| Add_case_ip of signedness * type0
| Add_case_lp of type0
| Add_default

(** val classify_add : type0 -> type0 -> classify_add_cases **)

let classify_add ty1 ty2 =
  match typeconv ty1 with
  | Tint0 (_, si, _) ->
    (match typeconv ty2 with
     | Tpointer (ty, _) -> Add_case_ip (si, ty)
     | _ -> Add_default)
  | Tlong0 (_, _) ->
    (match typeconv ty2 with
     | Tpointer (ty, _) -> Add_case_lp ty
     | _ -> Add_default)
  | Tpointer (ty, _) ->
    (match typeconv ty2 with
     | Tint0 (_, si, _) -> Add_case_pi (ty, si)
     | Tlong0 (_, _) -> Add_case_pl ty
     | _ -> Add_default)
  | _ -> Add_default

(** val ptrofs_of_int : signedness -> Int.int -> Ptrofs.int **)

let ptrofs_of_int si n0 =
  match si with
  | Signed -> Ptrofs.of_ints n0
  | Unsigned -> Ptrofs.of_intu n0

(** val sem_add_ptr_int :
    composite_env -> type0 -> signedness -> val0 -> val0 -> val0 option **)

let sem_add_ptr_int cenv ty si v1 v2 =
  match v1 with
  | Vint n1 ->
    (match v2 with
     | Vint n2 ->
       if ptr64
       then None
       else Some (Vint (Int.add n1 (Int.mul (Int.repr (sizeof cenv ty)) n2)))
     | _ -> None)
  | Vlong n1 ->
    (match v2 with
     | Vint n2 ->
       let n3 = cast_int_long si n2 in
       if ptr64
       then Some (Vlong
              (Int64.add n1 (Int64.mul (Int64.repr (sizeof cenv ty)) n3)))
       else None
     | _ -> None)
  | Vptr (b1, ofs1) ->
    (match v2 with
     | Vint n2 ->
       let n3 = ptrofs_of_int si n2 in
       Some (Vptr (b1,
       (Ptrofs.add ofs1 (Ptrofs.mul (Ptrofs.repr (sizeof cenv ty)) n3))))
     | _ -> None)
  | _ -> None

(** val sem_add_ptr_long :
    composite_env -> type0 -> val0 -> val0 -> val0 option **)

let sem_add_ptr_long cenv ty v1 v2 =
  match v1 with
  | Vint n1 ->
    (match v2 with
     | Vlong n2 ->
       let n3 = Int.repr (Int64.unsigned n2) in
       if ptr64
       then None
       else Some (Vint (Int.add n1 (Int.mul (Int.repr (sizeof cenv ty)) n3)))
     | _ -> None)
  | Vlong n1 ->
    (match v2 with
     | Vlong n2 ->
       if ptr64
       then Some (Vlong
              (Int64.add n1 (Int64.mul (Int64.repr (sizeof cenv ty)) n2)))
       else None
     | _ -> None)
  | Vptr (b1, ofs1) ->
    (match v2 with
     | Vlong n2 ->
       let n3 = Ptrofs.of_int64 n2 in
       Some (Vptr (b1,
       (Ptrofs.add ofs1 (Ptrofs.mul (Ptrofs.repr (sizeof cenv ty)) n3))))
     | _ -> None)
  | _ -> None

(** val sem_add :
    composite_env -> val0 -> type0 -> val0 -> type0 -> Mem.mem -> val0 option **)

let sem_add cenv v1 t1 v2 t2 m =
  match classify_add t1 t2 with
  | Add_case_pi (ty, si) -> sem_add_ptr_int cenv ty si v1 v2
  | Add_case_pl ty -> sem_add_ptr_long cenv ty v1 v2
  | Add_case_ip (si, ty) -> sem_add_ptr_int cenv ty si v2 v1
  | Add_case_lp ty -> sem_add_ptr_long cenv ty v2 v1
  | Add_default ->
    sem_binarith (fun _ n1 n2 -> Some (Vint (Int.add n1 n2))) (fun _ n1 n2 ->
      Some (Vlong (Int64.add n1 n2))) (fun n1 n2 -> Some (Vfloat
      (Float.add n1 n2))) (fun n1 n2 -> Some (Vsingle (Float32.add n1 n2)))
      v1 t1 v2 t2 m

type classify_sub_cases =
| Sub_case_pi of type0 * signedness
| Sub_case_pp of type0
| Sub_case_pl of type0
| Sub_default

(** val classify_sub : type0 -> type0 -> classify_sub_cases **)

let classify_sub ty1 ty2 =
  match typeconv ty1 with
  | Tpointer (ty, _) ->
    (match typeconv ty2 with
     | Tint0 (_, si, _) -> Sub_case_pi (ty, si)
     | Tlong0 (_, _) -> Sub_case_pl ty
     | Tpointer (_, _) -> Sub_case_pp ty
     | _ -> Sub_default)
  | _ -> Sub_default

(** val sem_sub :
    composite_env -> val0 -> type0 -> val0 -> type0 -> Mem.mem -> val0 option **)

let sem_sub cenv v1 t1 v2 t2 m =
  match classify_sub t1 t2 with
  | Sub_case_pi (ty, si) ->
    (match v1 with
     | Vint n1 ->
       (match v2 with
        | Vint n2 ->
          if ptr64
          then None
          else Some (Vint
                 (Int.sub n1 (Int.mul (Int.repr (sizeof cenv ty)) n2)))
        | _ -> None)
     | Vlong n1 ->
       (match v2 with
        | Vint n2 ->
          let n3 = cast_int_long si n2 in
          if ptr64
          then Some (Vlong
                 (Int64.sub n1 (Int64.mul (Int64.repr (sizeof cenv ty)) n3)))
          else None
        | _ -> None)
     | Vptr (b1, ofs1) ->
       (match v2 with
        | Vint n2 ->
          let n3 = ptrofs_of_int si n2 in
          Some (Vptr (b1,
          (Ptrofs.sub ofs1 (Ptrofs.mul (Ptrofs.repr (sizeof cenv ty)) n3))))
        | _ -> None)
     | _ -> None)
  | Sub_case_pp ty ->
    (match v1 with
     | Vptr (b1, ofs1) ->
       (match v2 with
        | Vptr (b2, ofs2) ->
          if eq_block b1 b2
          then let sz = sizeof cenv ty in
               if (&&) (proj_sumbool (zlt Z0 sz))
                    (proj_sumbool (zle sz Ptrofs.max_signed))
               then Some
                      (vptrofs
                        (Ptrofs.divs (Ptrofs.sub ofs1 ofs2) (Ptrofs.repr sz)))
               else None
          else None
        | _ -> None)
     | _ -> None)
  | Sub_case_pl ty ->
    (match v1 with
     | Vint n1 ->
       (match v2 with
        | Vlong n2 ->
          let n3 = Int.repr (Int64.unsigned n2) in
          if ptr64
          then None
          else Some (Vint
                 (Int.sub n1 (Int.mul (Int.repr (sizeof cenv ty)) n3)))
        | _ -> None)
     | Vlong n1 ->
       (match v2 with
        | Vlong n2 ->
          if ptr64
          then Some (Vlong
                 (Int64.sub n1 (Int64.mul (Int64.repr (sizeof cenv ty)) n2)))
          else None
        | _ -> None)
     | Vptr (b1, ofs1) ->
       (match v2 with
        | Vlong n2 ->
          let n3 = Ptrofs.of_int64 n2 in
          Some (Vptr (b1,
          (Ptrofs.sub ofs1 (Ptrofs.mul (Ptrofs.repr (sizeof cenv ty)) n3))))
        | _ -> None)
     | _ -> None)
  | Sub_default ->
    sem_binarith (fun _ n1 n2 -> Some (Vint (Int.sub n1 n2))) (fun _ n1 n2 ->
      Some (Vlong (Int64.sub n1 n2))) (fun n1 n2 -> Some (Vfloat
      (Float.sub n1 n2))) (fun n1 n2 -> Some (Vsingle (Float32.sub n1 n2)))
      v1 t1 v2 t2 m

(** val sem_mul : val0 -> type0 -> val0 -> type0 -> Mem.mem -> val0 option **)

let sem_mul v1 t1 v2 t2 m =
  sem_binarith (fun _ n1 n2 -> Some (Vint (Int.mul n1 n2))) (fun _ n1 n2 ->
    Some (Vlong (Int64.mul n1 n2))) (fun n1 n2 -> Some (Vfloat
    (Float.mul n1 n2))) (fun n1 n2 -> Some (Vsingle (Float32.mul n1 n2))) v1
    t1 v2 t2 m

(** val sem_div : val0 -> type0 -> val0 -> type0 -> Mem.mem -> val0 option **)

let sem_div v1 t1 v2 t2 m =
  sem_binarith (fun sg n1 n2 ->
    match sg with
    | Signed ->
      if (||) (Int.eq n2 Int.zero)
           ((&&) (Int.eq n1 (Int.repr Int.min_signed)) (Int.eq n2 Int.mone))
      then None
      else Some (Vint (Int.divs n1 n2))
    | Unsigned ->
      if Int.eq n2 Int.zero then None else Some (Vint (Int.divu n1 n2)))
    (fun sg n1 n2 ->
    match sg with
    | Signed ->
      if (||) (Int64.eq n2 Int64.zero)
           ((&&) (Int64.eq n1 (Int64.repr Int64.min_signed))
             (Int64.eq n2 Int64.mone))
      then None
      else Some (Vlong (Int64.divs n1 n2))
    | Unsigned ->
      if Int64.eq n2 Int64.zero then None else Some (Vlong (Int64.divu n1 n2)))
    (fun n1 n2 -> Some (Vfloat (Float.div n1 n2))) (fun n1 n2 -> Some
    (Vsingle (Float32.div n1 n2))) v1 t1 v2 t2 m

(** val sem_mod : val0 -> type0 -> val0 -> type0 -> Mem.mem -> val0 option **)

let sem_mod v1 t1 v2 t2 m =
  sem_binarith (fun sg n1 n2 ->
    match sg with
    | Signed ->
      if (||) (Int.eq n2 Int.zero)
           ((&&) (Int.eq n1 (Int.repr Int.min_signed)) (Int.eq n2 Int.mone))
      then None
      else Some (Vint (Int.mods n1 n2))
    | Unsigned ->
      if Int.eq n2 Int.zero then None else Some (Vint (Int.modu n1 n2)))
    (fun sg n1 n2 ->
    match sg with
    | Signed ->
      if (||) (Int64.eq n2 Int64.zero)
           ((&&) (Int64.eq n1 (Int64.repr Int64.min_signed))
             (Int64.eq n2 Int64.mone))
      then None
      else Some (Vlong (Int64.mods n1 n2))
    | Unsigned ->
      if Int64.eq n2 Int64.zero then None else Some (Vlong (Int64.modu n1 n2)))
    (fun _ _ -> None) (fun _ _ -> None) v1 t1 v2 t2 m

(** val sem_and : val0 -> type0 -> val0 -> type0 -> Mem.mem -> val0 option **)

let sem_and v1 t1 v2 t2 m =
  sem_binarith (fun _ n1 n2 -> Some (Vint (Int.coq_and n1 n2)))
    (fun _ n1 n2 -> Some (Vlong (Int64.coq_and n1 n2))) (fun _ _ -> None)
    (fun _ _ -> None) v1 t1 v2 t2 m

(** val sem_or : val0 -> type0 -> val0 -> type0 -> Mem.mem -> val0 option **)

let sem_or v1 t1 v2 t2 m =
  sem_binarith (fun _ n1 n2 -> Some (Vint (Int.coq_or n1 n2)))
    (fun _ n1 n2 -> Some (Vlong (Int64.coq_or n1 n2))) (fun _ _ -> None)
    (fun _ _ -> None) v1 t1 v2 t2 m

(** val sem_xor : val0 -> type0 -> val0 -> type0 -> Mem.mem -> val0 option **)

let sem_xor v1 t1 v2 t2 m =
  sem_binarith (fun _ n1 n2 -> Some (Vint (Int.xor n1 n2))) (fun _ n1 n2 ->
    Some (Vlong (Int64.xor n1 n2))) (fun _ _ -> None) (fun _ _ -> None) v1 t1
    v2 t2 m

type classify_shift_cases =
| Shift_case_ii of signedness
| Shift_case_ll of signedness
| Shift_case_il of signedness
| Shift_case_li of signedness
| Shift_default

(** val classify_shift : type0 -> type0 -> classify_shift_cases **)

let classify_shift ty1 ty2 =
  match typeconv ty1 with
  | Tint0 (i, s, _) ->
    (match i with
     | I32 ->
       (match typeconv ty2 with
        | Tint0 (_, _, _) -> Shift_case_ii s
        | Tlong0 (_, _) -> Shift_case_il s
        | _ -> Shift_default)
     | _ ->
       (match typeconv ty2 with
        | Tint0 (_, _, _) -> Shift_case_ii Signed
        | Tlong0 (_, _) -> Shift_case_il Signed
        | _ -> Shift_default))
  | Tlong0 (s, _) ->
    (match typeconv ty2 with
     | Tint0 (_, _, _) -> Shift_case_li s
     | Tlong0 (_, _) -> Shift_case_ll s
     | _ -> Shift_default)
  | _ -> Shift_default

(** val sem_shift :
    (signedness -> Int.int -> Int.int -> Int.int) -> (signedness -> Int64.int
    -> Int64.int -> Int64.int) -> val0 -> type0 -> val0 -> type0 -> val0
    option **)

let sem_shift sem_int sem_long v1 t1 v2 t2 =
  match classify_shift t1 t2 with
  | Shift_case_ii sg ->
    (match v1 with
     | Vint n1 ->
       (match v2 with
        | Vint n2 ->
          if Int.ltu n2 Int.iwordsize
          then Some (Vint (sem_int sg n1 n2))
          else None
        | _ -> None)
     | _ -> None)
  | Shift_case_ll sg ->
    (match v1 with
     | Vlong n1 ->
       (match v2 with
        | Vlong n2 ->
          if Int64.ltu n2 Int64.iwordsize
          then Some (Vlong (sem_long sg n1 n2))
          else None
        | _ -> None)
     | _ -> None)
  | Shift_case_il sg ->
    (match v1 with
     | Vint n1 ->
       (match v2 with
        | Vlong n2 ->
          if Int64.ltu n2 (Int64.repr (Zpos (XO (XO (XO (XO (XO XH)))))))
          then Some (Vint (sem_int sg n1 (Int64.loword n2)))
          else None
        | _ -> None)
     | _ -> None)
  | Shift_case_li sg ->
    (match v1 with
     | Vlong n1 ->
       (match v2 with
        | Vint n2 ->
          if Int.ltu n2 Int64.iwordsize'
          then Some (Vlong (sem_long sg n1 (Int64.repr (Int.unsigned n2))))
          else None
        | _ -> None)
     | _ -> None)
  | Shift_default -> None

(** val sem_shl : val0 -> type0 -> val0 -> type0 -> val0 option **)

let sem_shl v1 t1 v2 t2 =
  sem_shift (fun _ -> Int.shl) (fun _ -> Int64.shl) v1 t1 v2 t2

(** val sem_shr : val0 -> type0 -> val0 -> type0 -> val0 option **)

let sem_shr v1 t1 v2 t2 =
  sem_shift (fun sg n1 n2 ->
    match sg with
    | Signed -> Int.shr n1 n2
    | Unsigned -> Int.shru n1 n2) (fun sg n1 n2 ->
    match sg with
    | Signed -> Int64.shr n1 n2
    | Unsigned -> Int64.shru n1 n2) v1 t1 v2 t2

type classify_cmp_cases =
| Cmp_case_pp
| Cmp_case_pi of signedness
| Cmp_case_ip of signedness
| Cmp_case_pl
| Cmp_case_lp
| Cmp_default

(** val classify_cmp : type0 -> type0 -> classify_cmp_cases **)

let classify_cmp ty1 ty2 =
  match typeconv ty1 with
  | Tint0 (_, si, _) ->
    (match typeconv ty2 with
     | Tpointer (_, _) -> Cmp_case_ip si
     | _ -> Cmp_default)
  | Tlong0 (_, _) ->
    (match typeconv ty2 with
     | Tpointer (_, _) -> Cmp_case_lp
     | _ -> Cmp_default)
  | Tpointer (_, _) ->
    (match typeconv ty2 with
     | Tint0 (_, si, _) -> Cmp_case_pi si
     | Tlong0 (_, _) -> Cmp_case_pl
     | Tpointer (_, _) -> Cmp_case_pp
     | _ -> Cmp_default)
  | _ -> Cmp_default

(** val cmp_ptr : Mem.mem -> comparison0 -> val0 -> val0 -> val0 option **)

let cmp_ptr m c v1 v2 =
  option_map Val.of_bool
    (if ptr64
     then Val.cmplu_bool (Mem.valid_pointer m) c v1 v2
     else Val.cmpu_bool (Mem.valid_pointer m) c v1 v2)

(** val sem_cmp :
    comparison0 -> val0 -> type0 -> val0 -> type0 -> Mem.mem -> val0 option **)

let sem_cmp c v1 t1 v2 t2 m =
  match classify_cmp t1 t2 with
  | Cmp_case_pp -> cmp_ptr m c v1 v2
  | Cmp_case_pi si ->
    (match v2 with
     | Vint n2 ->
       let v2' = vptrofs (ptrofs_of_int si n2) in cmp_ptr m c v1 v2'
     | Vptr (_, _) -> if ptr64 then None else cmp_ptr m c v1 v2
     | _ -> None)
  | Cmp_case_ip si ->
    (match v1 with
     | Vint n1 ->
       let v1' = vptrofs (ptrofs_of_int si n1) in cmp_ptr m c v1' v2
     | Vptr (_, _) -> if ptr64 then None else cmp_ptr m c v1 v2
     | _ -> None)
  | Cmp_case_pl ->
    (match v2 with
     | Vlong n2 ->
       let v2' = vptrofs (Ptrofs.of_int64 n2) in cmp_ptr m c v1 v2'
     | Vptr (_, _) -> if ptr64 then cmp_ptr m c v1 v2 else None
     | _ -> None)
  | Cmp_case_lp ->
    (match v1 with
     | Vlong n1 ->
       let v1' = vptrofs (Ptrofs.of_int64 n1) in cmp_ptr m c v1' v2
     | Vptr (_, _) -> if ptr64 then cmp_ptr m c v1 v2 else None
     | _ -> None)
  | Cmp_default ->
    sem_binarith (fun sg n1 n2 -> Some
      (Val.of_bool
        (match sg with
         | Signed -> Int.cmp c n1 n2
         | Unsigned -> Int.cmpu c n1 n2)))
      (fun sg n1 n2 -> Some
      (Val.of_bool
        (match sg with
         | Signed -> Int64.cmp c n1 n2
         | Unsigned -> Int64.cmpu c n1 n2)))
      (fun n1 n2 -> Some (Val.of_bool (Float.cmp c n1 n2))) (fun n1 n2 ->
      Some (Val.of_bool (Float32.cmp c n1 n2))) v1 t1 v2 t2 m

type classify_fun_cases =
| Fun_case_f of type0 list * type0 * calling_convention
| Fun_default

(** val classify_fun : type0 -> classify_fun_cases **)

let classify_fun = function
| Tpointer (t0, _) ->
  (match t0 with
   | Tfunction (args, res0, cc) -> Fun_case_f (args, res0, cc)
   | _ -> Fun_default)
| Tfunction (args, res0, cc) -> Fun_case_f (args, res0, cc)
| _ -> Fun_default

type classify_switch_cases =
| Switch_case_i
| Switch_case_l
| Switch_default

(** val classify_switch : type0 -> classify_switch_cases **)

let classify_switch = function
| Tint0 (_, _, _) -> Switch_case_i
| Tlong0 (_, _) -> Switch_case_l
| _ -> Switch_default

(** val sem_switch_arg : val0 -> type0 -> z option **)

let sem_switch_arg v ty =
  match classify_switch ty with
  | Switch_case_i ->
    (match v with
     | Vint n0 -> Some (Int.unsigned n0)
     | _ -> None)
  | Switch_case_l ->
    (match v with
     | Vlong n0 -> Some (Int64.unsigned n0)
     | _ -> None)
  | Switch_default -> None

(** val sem_unary_operation :
    unary_operation -> val0 -> type0 -> Mem.mem -> val0 option **)

let sem_unary_operation op v ty m =
  match op with
  | Onotbool -> sem_notbool v ty m
  | Onotint -> sem_notint v ty
  | Oneg -> sem_neg v ty
  | Oabsfloat -> sem_absfloat v ty

(** val sem_binary_operation :
    composite_env -> binary_operation -> val0 -> type0 -> val0 -> type0 ->
    Mem.mem -> val0 option **)

let sem_binary_operation cenv op v1 t1 v2 t2 m =
  match op with
  | Oadd -> sem_add cenv v1 t1 v2 t2 m
  | Osub -> sem_sub cenv v1 t1 v2 t2 m
  | Omul -> sem_mul v1 t1 v2 t2 m
  | Odiv -> sem_div v1 t1 v2 t2 m
  | Omod -> sem_mod v1 t1 v2 t2 m
  | Oand -> sem_and v1 t1 v2 t2 m
  | Oor -> sem_or v1 t1 v2 t2 m
  | Oxor -> sem_xor v1 t1 v2 t2 m
  | Oshl -> sem_shl v1 t1 v2 t2
  | Oshr -> sem_shr v1 t1 v2 t2
  | Oeq -> sem_cmp Ceq v1 t1 v2 t2 m
  | One -> sem_cmp Cne v1 t1 v2 t2 m
  | Olt -> sem_cmp Clt v1 t1 v2 t2 m
  | Ogt -> sem_cmp Cgt v1 t1 v2 t2 m
  | Ole -> sem_cmp Cle v1 t1 v2 t2 m
  | Oge -> sem_cmp Cge v1 t1 v2 t2 m

(** val incrdecr_type : type0 -> type0 **)

let incrdecr_type ty =
  match typeconv ty with
  | Tint0 (sz, sg, _) -> Tint0 (sz, sg, noattr)
  | Tlong0 (sg, _) -> Tlong0 (sg, noattr)
  | Tfloat0 (sz, _) -> Tfloat0 (sz, noattr)
  | Tpointer (ty0, a) -> Tpointer (ty0, a)
  | _ -> Tvoid

(** val chunk_for_carrier : intsize -> memory_chunk **)

let chunk_for_carrier = function
| I16 -> Mint16unsigned
| I32 -> Mint32
| _ -> Mint8unsigned

(** val bitsize_carrier : intsize -> z **)

let bitsize_carrier = function
| I16 -> Zpos (XO (XO (XO (XO XH))))
| I32 -> Zpos (XO (XO (XO (XO (XO XH)))))
| _ -> Zpos (XO (XO (XO XH)))

(** val first_bit : intsize -> z -> z -> z **)

let first_bit sz pos width =
  if big_endian
  then Coq_Z.sub (Coq_Z.sub (bitsize_carrier sz) pos) width
  else pos

(** val bitfield_extract :
    intsize -> signedness -> z -> z -> Int.int -> Int.int **)

let bitfield_extract sz sg pos width c =
  if (||) (proj_sumbool (intsize_eq sz IBool))
       (proj_sumbool (signedness_eq sg Unsigned))
  then Int.unsigned_bitfield_extract (first_bit sz pos width) width c
  else Int.signed_bitfield_extract (first_bit sz pos width) width c

(** val bitfield_normalize :
    intsize -> signedness -> z -> Int.int -> Int.int **)

let bitfield_normalize sz sg width n0 =
  if (||) (proj_sumbool (intsize_eq sz IBool))
       (proj_sumbool (signedness_eq sg Unsigned))
  then Int.zero_ext width n0
  else Int.sign_ext width n0

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

(** val typeof : expr -> type0 **)

let typeof = function
| Eval (_, ty) -> ty
| Evar (_, ty) -> ty
| Efield (_, _, ty) -> ty
| Evalof (_, ty) -> ty
| Ederef (_, ty) -> ty
| Eaddrof (_, ty) -> ty
| Eunop (_, _, ty) -> ty
| Ebinop (_, _, _, ty) -> ty
| Ecast (_, ty) -> ty
| Eseqand (_, _, ty) -> ty
| Eseqor (_, _, ty) -> ty
| Econdition (_, _, _, ty) -> ty
| Esizeof (_, ty) -> ty
| Ealignof (_, ty) -> ty
| Eassign (_, _, ty) -> ty
| Eassignop (_, _, _, _, ty) -> ty
| Epostincr (_, _, ty) -> ty
| Ecomma (_, _, ty) -> ty
| Ecall (_, _, ty) -> ty
| Ebuiltin (_, _, _, ty) -> ty
| Eloc (_, _, _, ty) -> ty
| Eparen (_, _, ty) -> ty

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

(** val var_names : (ident * type0) list -> ident list **)

let var_names vars =
  map fst vars

type fundef0 = function0 fundef

(** val type_of_function : function0 -> type0 **)

let type_of_function f =
  Tfunction ((type_of_params f.fn_params), f.fn_return, f.fn_callconv)

(** val type_of_fundef : fundef0 -> type0 **)

let type_of_fundef = function
| Internal fd -> type_of_function fd
| External (_, args, res0, cc) -> Tfunction (args, res0, cc)

type program1 = function0 program0

type genv = { genv_genv : (fundef0, type0) Genv.t; genv_cenv : composite_env }

(** val globalenv0 : program1 -> genv **)

let globalenv0 p =
  { genv_genv = (Genv.globalenv (program_of_program p)); genv_cenv =
    p.prog_comp_env }

type env = (block * type0) PTree.t

(** val empty_env : env **)

let empty_env =
  PTree.empty

(** val block_of_binding :
    genv -> (ident * (block * type0)) -> (block * z) * z **)

let block_of_binding ge0 = function
| (_, p) -> let (b, ty) = p in ((b, Z0), (sizeof ge0.genv_cenv ty))

(** val blocks_of_env : genv -> env -> ((block * z) * z) list **)

let blocks_of_env ge0 e =
  map (block_of_binding ge0) (PTree.elements e)

(** val select_switch_default : labeled_statements -> labeled_statements **)

let rec select_switch_default sl = match sl with
| LSnil -> sl
| LScons (o, _, sl') ->
  (match o with
   | Some _ -> select_switch_default sl'
   | None -> sl)

(** val select_switch_case :
    z -> labeled_statements -> labeled_statements option **)

let rec select_switch_case n0 sl = match sl with
| LSnil -> None
| LScons (o, _, sl') ->
  (match o with
   | Some c -> if zeq c n0 then Some sl else select_switch_case n0 sl'
   | None -> select_switch_case n0 sl')

(** val select_switch : z -> labeled_statements -> labeled_statements **)

let select_switch n0 sl =
  match select_switch_case n0 sl with
  | Some sl' -> sl'
  | None -> select_switch_default sl

(** val seq_of_labeled_statement : labeled_statements -> statement **)

let rec seq_of_labeled_statement = function
| LSnil -> Sskip
| LScons (_, s, sl') -> Ssequence (s, (seq_of_labeled_statement sl'))

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

(** val call_cont : cont -> cont **)

let rec call_cont k = match k with
| Kdo k0 -> k0
| Kseq (_, k0) -> call_cont k0
| Kifthenelse (_, _, k0) -> call_cont k0
| Kwhile1 (_, _, k0) -> call_cont k0
| Kwhile2 (_, _, k0) -> call_cont k0
| Kdowhile1 (_, _, k0) -> call_cont k0
| Kdowhile2 (_, _, k0) -> call_cont k0
| Kfor2 (_, _, _, k0) -> call_cont k0
| Kfor3 (_, _, _, k0) -> call_cont k0
| Kfor4 (_, _, _, k0) -> call_cont k0
| Kswitch1 (_, k0) -> call_cont k0
| Kswitch2 k0 -> call_cont k0
| Kreturn k0 -> call_cont k0
| _ -> k

type state =
| State of function0 * statement * cont * env * Mem.mem
| ExprState of function0 * expr * cont * env * Mem.mem
| Callstate of fundef0 * val0 list * cont * Mem.mem
| Returnstate of val0 * cont * Mem.mem
| Stuckstate

(** val find_label :
    label -> statement -> cont -> (statement * cont) option **)

let rec find_label lbl s k =
  match s with
  | Ssequence (s1, s2) ->
    (match find_label lbl s1 (Kseq (s2, k)) with
     | Some sk -> Some sk
     | None -> find_label lbl s2 k)
  | Sifthenelse (_, s1, s2) ->
    (match find_label lbl s1 k with
     | Some sk -> Some sk
     | None -> find_label lbl s2 k)
  | Swhile (a, s1) -> find_label lbl s1 (Kwhile2 (a, s1, k))
  | Sdowhile (a, s1) -> find_label lbl s1 (Kdowhile1 (a, s1, k))
  | Sfor (a1, a2, a3, s1) ->
    (match find_label lbl a1 (Kseq ((Sfor (Sskip, a2, a3, s1)), k)) with
     | Some sk -> Some sk
     | None ->
       (match find_label lbl s1 (Kfor3 (a2, a3, s1, k)) with
        | Some sk -> Some sk
        | None -> find_label lbl a3 (Kfor4 (a2, a3, s1, k))))
  | Sswitch (_, sl) -> find_label_ls lbl sl (Kswitch2 k)
  | Slabel (lbl', s') ->
    if ident_eq lbl lbl' then Some (s', k) else find_label lbl s' k
  | _ -> None

(** val find_label_ls :
    label -> labeled_statements -> cont -> (statement * cont) option **)

and find_label_ls lbl sl k =
  match sl with
  | LSnil -> None
  | LScons (_, s, sl') ->
    (match find_label lbl s (Kseq ((seq_of_labeled_statement sl'), k)) with
     | Some sk -> Some sk
     | None -> find_label_ls lbl sl' k)

(** val decidable_not : decidable -> decidable **)

let decidable_not =
  negb

(** val decidable_and : decidable -> decidable -> decidable **)

let decidable_and =
  (&&)

(** val decidable_or : decidable -> decidable -> decidable **)

let decidable_or =
  (||)

(** val decidable_implies : decidable -> decidable -> decidable **)

let decidable_implies dP dQ =
  if dP then dQ else true

(** val decidable_eq_positive : positive -> positive -> decidable **)

let decidable_eq_positive =
  Coq_Pos.eqb

(** val decidable_eq_Z : z -> z -> decidable **)

let decidable_eq_Z =
  Coq_Z.eqb

(** val decidable_le_Z : z -> z -> decidable **)

let decidable_le_Z =
  Coq_Z.leb

(** val decidable_ge_Z : z -> z -> decidable **)

let decidable_ge_Z =
  Coq_Z.geb

(** val decidable_gt_Z : z -> z -> decidable **)

let decidable_gt_Z =
  Coq_Z.gtb

(** val decidable_divides : z -> z -> decidable **)

let decidable_divides x y =
  Coq_Z.eqb y (Coq_Z.mul (Coq_Z.div y x) x)

(** val is_val : expr -> (val0 * type0) option **)

let is_val = function
| Eval (v, ty) -> Some (v, ty)
| _ -> None

(** val is_loc :
    expr -> (((block * Ptrofs.int) * bitfield) * type0) option **)

let is_loc = function
| Eloc (b, ofs, bf, ty) -> Some (((b, ofs), bf), ty)
| _ -> None

(** val is_val_list : exprlist -> (val0 * type0) list option **)

let rec is_val_list = function
| Enil -> Some []
| Econs (a1, al0) ->
  (match is_val a1 with
   | Some vt1 ->
     (match is_val_list al0 with
      | Some vtl -> Some (vt1 :: vtl)
      | None -> None)
   | None -> None)

(** val is_skip : statement -> bool **)

let is_skip = function
| Sskip -> true
| _ -> false

(** val eventval_of_val : genv -> val0 -> typ -> eventval option **)

let eventval_of_val ge0 v t0 =
  match v with
  | Vundef -> None
  | Vint i -> if typ_eq t0 Tint then Some (EVint i) else None
  | Vlong n0 -> if typ_eq t0 Tlong then Some (EVlong n0) else None
  | Vfloat f -> if typ_eq t0 Tfloat then Some (EVfloat f) else None
  | Vsingle f -> if typ_eq t0 Tsingle then Some (EVsingle f) else None
  | Vptr (b, ofs) ->
    (match Genv.invert_symbol ge0.genv_genv b with
     | Some id ->
       if Genv.public_symbol ge0.genv_genv id
       then if typ_eq t0 tptr then Some (EVptr_global (id, ofs)) else None
       else None
     | None -> None)

(** val list_eventval_of_val :
    genv -> val0 list -> typ list -> eventval list option **)

let rec list_eventval_of_val ge0 vl tl =
  match vl with
  | [] -> (match tl with
           | [] -> Some []
           | _ :: _ -> None)
  | v1 :: vl0 ->
    (match tl with
     | [] -> None
     | t1 :: tl0 ->
       (match eventval_of_val ge0 v1 t1 with
        | Some ev1 ->
          (match list_eventval_of_val ge0 vl0 tl0 with
           | Some evl -> Some (ev1 :: evl)
           | None -> None)
        | None -> None))

(** val val_of_eventval : genv -> eventval -> typ -> val0 option **)

let val_of_eventval ge0 ev t0 =
  match ev with
  | EVint i -> if typ_eq t0 Tint then Some (Vint i) else None
  | EVlong n0 -> if typ_eq t0 Tlong then Some (Vlong n0) else None
  | EVfloat f -> if typ_eq t0 Tfloat then Some (Vfloat f) else None
  | EVsingle f -> if typ_eq t0 Tsingle then Some (Vsingle f) else None
  | EVptr_global (id, ofs) ->
    if Genv.public_symbol ge0.genv_genv id
    then if typ_eq t0 tptr
         then (match Genv.find_symbol ge0.genv_genv id with
               | Some b -> Some (Vptr (b, ofs))
               | None -> None)
         else None
    else None

(** val do_volatile_load :
    genv -> world -> memory_chunk -> Mem.mem -> block -> Ptrofs.int ->
    ((world * trace) * val0) option **)

let do_volatile_load ge0 w chunk m b ofs =
  if Genv.block_is_volatile ge0.genv_genv b
  then (match Genv.invert_symbol ge0.genv_genv b with
        | Some id ->
          (match nextworld_vload w chunk id ofs with
           | Some p ->
             let (res0, w') = p in
             (match val_of_eventval ge0 res0 (type_of_chunk chunk) with
              | Some vres ->
                Some ((w', ((Event_vload (chunk, id, ofs, res0)) :: [])),
                  (Val.load_result chunk vres))
              | None -> None)
           | None -> None)
        | None -> None)
  else (match Mem.loadv chunk m (Vptr (b, ofs)) with
        | Some v -> Some ((w, e0), v)
        | None -> None)

(** val do_volatile_store :
    genv -> world -> memory_chunk -> Mem.mem -> block -> Ptrofs.int -> val0
    -> (((world * trace) * Mem.mem) * val0) option **)

let do_volatile_store ge0 w chunk m b ofs v =
  if Genv.block_is_volatile ge0.genv_genv b
  then (match Genv.invert_symbol ge0.genv_genv b with
        | Some id ->
          (match eventval_of_val ge0 (Val.load_result chunk v)
                   (type_of_chunk chunk) with
           | Some ev ->
             (match nextworld_vstore w chunk id ofs ev with
              | Some w' ->
                Some (((w', ((Event_vstore (chunk, id, ofs, ev)) :: [])), m),
                  v)
              | None -> None)
           | None -> None)
        | None -> None)
  else (match Mem.storev chunk m (Vptr (b, ofs)) v with
        | Some m' -> Some (((w, e0), m'), v)
        | None -> None)

(** val do_deref_loc :
    genv -> world -> type0 -> Mem.mem -> block -> Ptrofs.int -> bitfield ->
    ((world * trace) * val0) option **)

let do_deref_loc ge0 w ty m b ofs = function
| Full ->
  (match access_mode ty with
   | By_value chunk ->
     if type_is_volatile ty
     then do_volatile_load ge0 w chunk m b ofs
     else (match Mem.loadv chunk m (Vptr (b, ofs)) with
           | Some v -> Some ((w, e0), v)
           | None -> None)
   | By_nothing -> None
   | _ -> Some ((w, e0), (Vptr (b, ofs))))
| Bits (sz, sg, pos, width) ->
  (match ty with
   | Tint0 (sz1, sg1, _) ->
     if (&&)
          ((&&)
            ((&&)
              ((&&)
                ((&&) (proj_sumbool (intsize_eq sz1 sz))
                  (proj_sumbool
                    (signedness_eq sg1
                      (if zlt width (bitsize_intsize sz) then Signed else sg))))
                (proj_sumbool (zle Z0 pos)))
              (proj_sumbool (zlt Z0 width)))
            (proj_sumbool (zle width (bitsize_intsize sz))))
          (proj_sumbool (zle (Coq_Z.add pos width) (bitsize_carrier sz)))
     then (match Mem.loadv (chunk_for_carrier sz) m (Vptr (b, ofs)) with
           | Some v ->
             (match v with
              | Vint c ->
                Some ((w, e0), (Vint (bitfield_extract sz sg pos width c)))
              | _ -> None)
           | None -> None)
     else None
   | _ -> None)

(** val check_assign_copy :
    genv -> type0 -> block -> Ptrofs.int -> block -> Ptrofs.int -> bool **)

let check_assign_copy ge0 ty b ofs b' ofs' =
  let s =
    zdivide_dec (alignof_blockcopy ge0.genv_cenv ty) (Ptrofs.unsigned ofs')
  in
  if s
  then let s0 =
         zdivide_dec (alignof_blockcopy ge0.genv_cenv ty)
           (Ptrofs.unsigned ofs)
       in
       if s0
       then let s1 = eq_block b' b in
            if s1
            then let s2 = zeq (Ptrofs.unsigned ofs') (Ptrofs.unsigned ofs) in
                 if s2
                 then true
                 else let s3 =
                        zle
                          (Coq_Z.add (Ptrofs.unsigned ofs')
                            (sizeof ge0.genv_cenv ty))
                          (Ptrofs.unsigned ofs)
                      in
                      if s3
                      then true
                      else zle
                             (Coq_Z.add (Ptrofs.unsigned ofs)
                               (sizeof ge0.genv_cenv ty))
                             (Ptrofs.unsigned ofs')
            else true
       else false
  else false

(** val do_assign_loc :
    genv -> world -> type0 -> Mem.mem -> block -> Ptrofs.int -> bitfield ->
    val0 -> (((world * trace) * Mem.mem) * val0) option **)

let do_assign_loc ge0 w ty m b ofs bf v =
  match bf with
  | Full ->
    (match access_mode ty with
     | By_value chunk ->
       if type_is_volatile ty
       then do_volatile_store ge0 w chunk m b ofs v
       else (match Mem.storev chunk m (Vptr (b, ofs)) v with
             | Some m' -> Some (((w, e0), m'), v)
             | None -> None)
     | By_copy ->
       (match v with
        | Vptr (b', ofs') ->
          if check_assign_copy ge0 ty b ofs b' ofs'
          then (match Mem.loadbytes m b' (Ptrofs.unsigned ofs')
                        (sizeof ge0.genv_cenv ty) with
                | Some bytes ->
                  (match Mem.storebytes m b (Ptrofs.unsigned ofs) bytes with
                   | Some m' -> Some (((w, e0), m'), v)
                   | None -> None)
                | None -> None)
          else None
        | _ -> None)
     | _ -> None)
  | Bits (sz, sg, pos, width) ->
    if (&&)
         ((&&)
           ((&&) (proj_sumbool (zle Z0 pos)) (proj_sumbool (zlt Z0 width)))
           (proj_sumbool (zle width (bitsize_intsize sz))))
         (proj_sumbool (zle (Coq_Z.add pos width) (bitsize_carrier sz)))
    then (match ty with
          | Tint0 (sz1, sg1, _) ->
            (match v with
             | Vint n0 ->
               (match Mem.loadv (chunk_for_carrier sz) m (Vptr (b, ofs)) with
                | Some v0 ->
                  (match v0 with
                   | Vint c ->
                     if (&&) (proj_sumbool (intsize_eq sz1 sz))
                          (proj_sumbool
                            (signedness_eq sg1
                              (if zlt width (bitsize_intsize sz)
                               then Signed
                               else sg)))
                     then (match Mem.storev (chunk_for_carrier sz) m (Vptr
                                   (b, ofs)) (Vint
                                   (Int.bitfield_insert
                                     (first_bit sz pos width) width c n0)) with
                           | Some m' ->
                             Some (((w, e0), m'), (Vint
                               (bitfield_normalize sz sg width n0)))
                           | None -> None)
                     else None
                   | _ -> None)
                | None -> None)
             | _ -> None)
          | _ -> None)
    else None

(** val do_ef_volatile_load :
    genv -> memory_chunk -> world -> val0 list -> Mem.mem ->
    (((world * trace) * val0) * Mem.mem) option **)

let do_ef_volatile_load ge0 chunk w vargs m =
  match vargs with
  | [] -> None
  | v :: l ->
    (match v with
     | Vptr (b, ofs) ->
       (match l with
        | [] ->
          (match do_volatile_load ge0 w chunk m b ofs with
           | Some p -> Some (p, m)
           | None -> None)
        | _ :: _ -> None)
     | _ -> None)

(** val do_ef_volatile_store :
    genv -> memory_chunk -> world -> val0 list -> Mem.mem ->
    (((world * trace) * val0) * Mem.mem) option **)

let do_ef_volatile_store ge0 chunk w vargs m =
  match vargs with
  | [] -> None
  | v0 :: l ->
    (match v0 with
     | Vptr (b, ofs) ->
       (match l with
        | [] -> None
        | v :: l0 ->
          (match l0 with
           | [] ->
             (match do_volatile_store ge0 w chunk m b ofs v with
              | Some p ->
                let (p0, _) = p in
                let (p1, m') = p0 in Some ((p1, Vundef), m')
              | None -> None)
           | _ :: _ -> None))
     | _ -> None)

(** val do_alloc_size : val0 -> Ptrofs.int option **)

let do_alloc_size = function
| Vint n0 -> if ptr64 then None else Some (Ptrofs.of_int n0)
| Vlong n0 -> if ptr64 then Some (Ptrofs.of_int64 n0) else None
| _ -> None

(** val do_ef_malloc :
    world -> val0 list -> Mem.mem -> (((world * trace) * val0) * Mem.mem)
    option **)

let do_ef_malloc w vargs m =
  match vargs with
  | [] -> None
  | v :: l ->
    (match l with
     | [] ->
       (match do_alloc_size v with
        | Some sz ->
          let (m', b) =
            Mem.alloc m (Coq_Z.opp (size_chunk mptr)) (Ptrofs.unsigned sz)
          in
          (match Mem.store mptr m' b (Coq_Z.opp (size_chunk mptr)) v with
           | Some m'' -> Some (((w, e0), (Vptr (b, Ptrofs.zero))), m'')
           | None -> None)
        | None -> None)
     | _ :: _ -> None)

(** val do_ef_free :
    world -> val0 list -> Mem.mem -> (((world * trace) * val0) * Mem.mem)
    option **)

let do_ef_free w vargs m =
  match vargs with
  | [] -> None
  | v :: l ->
    (match v with
     | Vint n0 ->
       (match l with
        | [] ->
          if (&&) (proj_sumbool (Int.eq_dec n0 Int.zero)) (negb ptr64)
          then Some (((w, e0), Vundef), m)
          else None
        | _ :: _ -> None)
     | Vlong n0 ->
       (match l with
        | [] ->
          if (&&) (proj_sumbool (Int64.eq_dec n0 Int64.zero)) ptr64
          then Some (((w, e0), Vundef), m)
          else None
        | _ :: _ -> None)
     | Vptr (b, lo) ->
       (match l with
        | [] ->
          if Ptrofs.eq_dec lo Ptrofs.zero
          then (match Mem.load mptr m b (Coq_Z.opp (size_chunk mptr)) with
                | Some vsz ->
                  (match do_alloc_size vsz with
                   | Some sz ->
                     (match Mem.free m b (Coq_Z.opp (size_chunk mptr))
                              (Ptrofs.unsigned sz) with
                      | Some m' -> Some (((w, e0), Vundef), m')
                      | None -> None)
                   | None -> None)
                | None -> None)
          else None
        | _ :: _ -> None)
     | _ -> None)

(** val do_ef_memcpy :
    z -> z -> world -> val0 list -> Mem.mem ->
    (((world * trace) * val0) * Mem.mem) option **)

let do_ef_memcpy sz al w vargs m =
  match vargs with
  | [] -> None
  | v :: l ->
    (match v with
     | Vptr (bdst, odst) ->
       (match l with
        | [] -> None
        | v0 :: l0 ->
          (match v0 with
           | Vptr (bsrc, osrc) ->
             (match l0 with
              | [] ->
                if decide
                     (decidable_and
                       (decidable_or (decidable_eq_Z al (Zpos XH))
                         (decidable_or (decidable_eq_Z al (Zpos (XO XH)))
                           (decidable_or
                             (decidable_eq_Z al (Zpos (XO (XO XH))))
                             (decidable_eq_Z al (Zpos (XO (XO (XO XH))))))))
                       (decidable_and (decidable_ge_Z sz Z0)
                         (decidable_and (decidable_divides al sz)
                           (decidable_and
                             (decidable_implies (decidable_gt_Z sz Z0)
                               (decidable_divides al (Ptrofs.unsigned osrc)))
                             (decidable_and
                               (decidable_implies (decidable_gt_Z sz Z0)
                                 (decidable_divides al (Ptrofs.unsigned odst)))
                               (decidable_or
                                 (decidable_not
                                   (decidable_eq_positive bsrc bdst))
                                 (decidable_or
                                   (decidable_eq_Z (Ptrofs.unsigned osrc)
                                     (Ptrofs.unsigned odst))
                                   (decidable_or
                                     (decidable_le_Z
                                       (Coq_Z.add (Ptrofs.unsigned osrc) sz)
                                       (Ptrofs.unsigned odst))
                                     (decidable_le_Z
                                       (Coq_Z.add (Ptrofs.unsigned odst) sz)
                                       (Ptrofs.unsigned osrc))))))))))
                then (match Mem.loadbytes m bsrc (Ptrofs.unsigned osrc) sz with
                      | Some bytes ->
                        (match Mem.storebytes m bdst (Ptrofs.unsigned odst)
                                 bytes with
                         | Some m' -> Some (((w, e0), Vundef), m')
                         | None -> None)
                      | None -> None)
                else None
              | _ :: _ -> None)
           | _ -> None))
     | _ -> None)

(** val do_ef_annot :
    genv -> char list -> typ list -> world -> val0 list -> Mem.mem ->
    (((world * trace) * val0) * Mem.mem) option **)

let do_ef_annot ge0 text targs w vargs m =
  match list_eventval_of_val ge0 vargs targs with
  | Some args -> Some (((w, ((Event_annot (text, args)) :: e0)), Vundef), m)
  | None -> None

(** val do_ef_annot_val :
    genv -> char list -> typ -> world -> val0 list -> Mem.mem ->
    (((world * trace) * val0) * Mem.mem) option **)

let do_ef_annot_val ge0 text targ w vargs m =
  match vargs with
  | [] -> None
  | varg :: l ->
    (match l with
     | [] ->
       (match eventval_of_val ge0 varg targ with
        | Some arg ->
          Some (((w, ((Event_annot (text, (arg :: []))) :: e0)), varg), m)
        | None -> None)
     | _ :: _ -> None)

(** val do_ef_debug :
    positive -> ident -> typ list -> world -> val0 list -> Mem.mem ->
    (((world * trace) * val0) * Mem.mem) option **)

let do_ef_debug _ _ _ w _ m =
  Some (((w, e0), Vundef), m)

(** val do_builtin_or_external :
    genv -> (char list -> signature -> Senv.t -> world -> val0 list ->
    Mem.mem -> (((world * trace) * val0) * Mem.mem) option) -> char list ->
    signature -> world -> val0 list -> Mem.mem ->
    (((world * trace) * val0) * Mem.mem) option **)

let do_builtin_or_external ge0 do_external_function name sg w vargs m =
  match lookup_builtin_function name sg with
  | Some bf ->
    (match builtin_function_sem bf vargs with
     | Some v -> Some (((w, e0), v), m)
     | None -> None)
  | None ->
    do_external_function name sg (Genv.to_senv ge0.genv_genv) w vargs m

(** val do_external :
    genv -> (char list -> signature -> Senv.t -> world -> val0 list ->
    Mem.mem -> (((world * trace) * val0) * Mem.mem) option) -> (char list ->
    signature -> Senv.t -> world -> val0 list -> Mem.mem ->
    (((world * trace) * val0) * Mem.mem) option) -> external_function ->
    world -> val0 list -> Mem.mem -> (((world * trace) * val0) * Mem.mem)
    option **)

let do_external ge0 do_external_function do_inline_assembly = function
| EF_external (name, sg) ->
  do_external_function name sg (Genv.to_senv ge0.genv_genv)
| EF_builtin (name, sg) ->
  do_builtin_or_external ge0 do_external_function name sg
| EF_runtime (name, sg) ->
  do_builtin_or_external ge0 do_external_function name sg
| EF_vload chunk -> do_ef_volatile_load ge0 chunk
| EF_vstore chunk -> do_ef_volatile_store ge0 chunk
| EF_malloc -> do_ef_malloc
| EF_free -> do_ef_free
| EF_memcpy (sz, al) -> do_ef_memcpy sz al
| EF_annot (_, text, targs) -> do_ef_annot ge0 text targs
| EF_annot_val (_, text, targ) -> do_ef_annot_val ge0 text targ
| EF_inline_asm (text, sg, _) ->
  do_inline_assembly text sg (Genv.to_senv ge0.genv_genv)
| EF_debug (kind0, text, targs) -> do_ef_debug kind0 text targs

type reduction =
| Lred of char list * expr * Mem.mem
| Rred of char list * expr * Mem.mem * trace
| Callred of char list * fundef0 * val0 list * type0 * Mem.mem
| Stuckred

(** val sem_cast_arguments :
    (val0 * type0) list -> type0 list -> Mem.mem -> val0 list option **)

let rec sem_cast_arguments vtl tl m =
  match vtl with
  | [] -> (match tl with
           | [] -> Some []
           | _ :: _ -> None)
  | p :: vtl0 ->
    let (v1, t1) = p in
    (match tl with
     | [] -> None
     | t1' :: tl0 ->
       (match sem_cast v1 t1 t1' m with
        | Some v ->
          (match sem_cast_arguments vtl0 tl0 m with
           | Some vl -> Some (v :: vl)
           | None -> None)
        | None -> None))

type 'a reducts = ((expr -> 'a) * reduction) list

(** val topred : reduction -> expr reducts **)

let topred r =
  ((fun x -> x), r) :: []

(** val stuck : expr reducts **)

let stuck =
  ((fun x -> x), Stuckred) :: []

(** val incontext : ('a1 -> 'a2) -> 'a1 reducts -> 'a2 reducts **)

let incontext ctx ll =
  map (fun z0 -> ((fun x -> ctx (fst z0 x)), (snd z0))) ll

(** val incontext2 :
    ('a1 -> 'a3) -> 'a1 reducts -> ('a2 -> 'a3) -> 'a2 reducts -> 'a3 reducts **)

let incontext2 ctx1 ll1 ctx2 ll2 =
  app (incontext ctx1 ll1) (incontext ctx2 ll2)

(** val step_expr :
    genv -> (char list -> signature -> Senv.t -> world -> val0 list ->
    Mem.mem -> (((world * trace) * val0) * Mem.mem) option) -> (char list ->
    signature -> Senv.t -> world -> val0 list -> Mem.mem ->
    (((world * trace) * val0) * Mem.mem) option) -> env -> world -> kind ->
    expr -> Mem.mem -> expr reducts **)

let step_expr ge0 do_external_function do_inline_assembly e w =
  let rec step_expr0 k a m =
    match k with
    | LV ->
      (match a with
       | Evar (x, ty) ->
         (match PTree.get x e with
          | Some p ->
            let (b, ty') = p in
            if type_eq ty ty'
            then topred (Lred
                   (('r'::('e'::('d'::('_'::('v'::('a'::('r'::('_'::('l'::('o'::('c'::('a'::('l'::[]))))))))))))),
                   (Eloc (b, Ptrofs.zero, Full, ty)), m))
            else stuck
          | None ->
            (match Genv.find_symbol ge0.genv_genv x with
             | Some b ->
               topred (Lred
                 (('r'::('e'::('d'::('_'::('v'::('a'::('r'::('_'::('g'::('l'::('o'::('b'::('a'::('l'::[])))))))))))))),
                 (Eloc (b, Ptrofs.zero, Full, ty)), m))
             | None -> stuck))
       | Efield (r, f, ty) ->
         (match is_val r with
          | Some p ->
            let (v, ty') = p in
            (match v with
             | Vptr (b, ofs) ->
               (match ty' with
                | Tstruct (id, _) ->
                  (match PTree.get id ge0.genv_cenv with
                   | Some co ->
                     (match field_offset ge0.genv_cenv f co.co_members with
                      | OK p0 ->
                        let (delta, bf) = p0 in
                        topred (Lred
                          (('r'::('e'::('d'::('_'::('f'::('i'::('e'::('l'::('d'::('_'::('s'::('t'::('r'::('u'::('c'::('t'::[])))))))))))))))),
                          (Eloc (b, (Ptrofs.add ofs (Ptrofs.repr delta)), bf,
                          ty)), m))
                      | Error _ -> stuck)
                   | None -> stuck)
                | Tunion (id, _) ->
                  (match PTree.get id ge0.genv_cenv with
                   | Some co ->
                     (match union_field_offset ge0.genv_cenv f co.co_members with
                      | OK p0 ->
                        let (delta, bf) = p0 in
                        topred (Lred
                          (('r'::('e'::('d'::('_'::('f'::('i'::('e'::('l'::('d'::('_'::('u'::('n'::('i'::('o'::('n'::[]))))))))))))))),
                          (Eloc (b, (Ptrofs.add ofs (Ptrofs.repr delta)), bf,
                          ty)), m))
                      | Error _ -> stuck)
                   | None -> stuck)
                | _ -> stuck)
             | _ -> stuck)
          | None -> incontext (fun x -> Efield (x, f, ty)) (step_expr0 RV r m))
       | Ederef (r, ty) ->
         (match is_val r with
          | Some p ->
            let (v, _) = p in
            (match v with
             | Vptr (b, ofs) ->
               topred (Lred
                 (('r'::('e'::('d'::('_'::('d'::('e'::('r'::('e'::('f'::[]))))))))),
                 (Eloc (b, ofs, Full, ty)), m))
             | _ -> stuck)
          | None -> incontext (fun x -> Ederef (x, ty)) (step_expr0 RV r m))
       | Eloc (_, _, _, _) -> []
       | _ -> stuck)
    | RV ->
      (match a with
       | Eval (_, _) -> []
       | Evalof (l, ty) ->
         (match is_loc l with
          | Some p ->
            let (p0, ty') = p in
            let (p1, bf) = p0 in
            let (b, ofs) = p1 in
            if type_eq ty ty'
            then (match do_deref_loc ge0 w ty m b ofs bf with
                  | Some p2 ->
                    let (p3, v) = p2 in
                    let (_, t0) = p3 in
                    topred (Rred
                      (('r'::('e'::('d'::('_'::('r'::('v'::('a'::('l'::('o'::('f'::[])))))))))),
                      (Eval (v, ty)), m, t0))
                  | None -> stuck)
            else stuck
          | None -> incontext (fun x -> Evalof (x, ty)) (step_expr0 LV l m))
       | Eaddrof (l, ty) ->
         (match is_loc l with
          | Some p ->
            let (p0, _) = p in
            let (p1, bf) = p0 in
            let (b, ofs) = p1 in
            (match bf with
             | Full ->
               topred (Rred
                 (('r'::('e'::('d'::('_'::('a'::('d'::('d'::('r'::('o'::('f'::[])))))))))),
                 (Eval ((Vptr (b, ofs)), ty)), m, e0))
             | Bits (_, _, _, _) -> stuck)
          | None -> incontext (fun x -> Eaddrof (x, ty)) (step_expr0 LV l m))
       | Eunop (op, r1, ty) ->
         (match is_val r1 with
          | Some p ->
            let (v1, ty1) = p in
            (match sem_unary_operation op v1 ty1 m with
             | Some v ->
               topred (Rred
                 (('r'::('e'::('d'::('_'::('u'::('n'::('o'::('p'::[])))))))),
                 (Eval (v, ty)), m, e0))
             | None -> stuck)
          | None ->
            incontext (fun x -> Eunop (op, x, ty)) (step_expr0 RV r1 m))
       | Ebinop (op, r1, r2, ty) ->
         (match is_val r1 with
          | Some p ->
            let (v1, ty1) = p in
            (match is_val r2 with
             | Some p0 ->
               let (v2, ty2) = p0 in
               (match sem_binary_operation ge0.genv_cenv op v1 ty1 v2 ty2 m with
                | Some v ->
                  topred (Rred
                    (('r'::('e'::('d'::('_'::('b'::('i'::('n'::('o'::('p'::[]))))))))),
                    (Eval (v, ty)), m, e0))
                | None -> stuck)
             | None ->
               incontext2 (fun x -> Ebinop (op, x, r2, ty))
                 (step_expr0 RV r1 m) (fun x -> Ebinop (op, r1, x, ty))
                 (step_expr0 RV r2 m))
          | None ->
            incontext2 (fun x -> Ebinop (op, x, r2, ty)) (step_expr0 RV r1 m)
              (fun x -> Ebinop (op, r1, x, ty)) (step_expr0 RV r2 m))
       | Ecast (r1, ty) ->
         (match is_val r1 with
          | Some p ->
            let (v1, ty1) = p in
            (match sem_cast v1 ty1 ty m with
             | Some v ->
               topred (Rred
                 (('r'::('e'::('d'::('_'::('c'::('a'::('s'::('t'::[])))))))),
                 (Eval (v, ty)), m, e0))
             | None -> stuck)
          | None -> incontext (fun x -> Ecast (x, ty)) (step_expr0 RV r1 m))
       | Eseqand (r1, r2, ty) ->
         (match is_val r1 with
          | Some p ->
            let (v1, ty1) = p in
            (match bool_val v1 ty1 m with
             | Some b ->
               if b
               then topred (Rred
                      (('r'::('e'::('d'::('_'::('s'::('e'::('q'::('a'::('n'::('d'::('_'::('t'::('r'::('u'::('e'::[]))))))))))))))),
                      (Eparen (r2, type_bool, ty)), m, e0))
               else topred (Rred
                      (('r'::('e'::('d'::('_'::('s'::('e'::('q'::('a'::('n'::('d'::('_'::('f'::('a'::('l'::('s'::('e'::[])))))))))))))))),
                      (Eval ((Vint Int.zero), ty)), m, e0))
             | None -> stuck)
          | None ->
            incontext (fun x -> Eseqand (x, r2, ty)) (step_expr0 RV r1 m))
       | Eseqor (r1, r2, ty) ->
         (match is_val r1 with
          | Some p ->
            let (v1, ty1) = p in
            (match bool_val v1 ty1 m with
             | Some b ->
               if b
               then topred (Rred
                      (('r'::('e'::('d'::('_'::('s'::('e'::('q'::('o'::('r'::('_'::('t'::('r'::('u'::('e'::[])))))))))))))),
                      (Eval ((Vint Int.one), ty)), m, e0))
               else topred (Rred
                      (('r'::('e'::('d'::('_'::('s'::('e'::('q'::('o'::('r'::('_'::('f'::('a'::('l'::('s'::('e'::[]))))))))))))))),
                      (Eparen (r2, type_bool, ty)), m, e0))
             | None -> stuck)
          | None ->
            incontext (fun x -> Eseqor (x, r2, ty)) (step_expr0 RV r1 m))
       | Econdition (r1, r2, r3, ty) ->
         (match is_val r1 with
          | Some p ->
            let (v1, ty1) = p in
            (match bool_val v1 ty1 m with
             | Some b ->
               topred (Rred
                 (('r'::('e'::('d'::('_'::('c'::('o'::('n'::('d'::('i'::('t'::('i'::('o'::('n'::[]))))))))))))),
                 (Eparen ((if b then r2 else r3), ty, ty)), m, e0))
             | None -> stuck)
          | None ->
            incontext (fun x -> Econdition (x, r2, r3, ty))
              (step_expr0 RV r1 m))
       | Esizeof (ty', ty) ->
         topred (Rred
           (('r'::('e'::('d'::('_'::('s'::('i'::('z'::('e'::('o'::('f'::[])))))))))),
           (Eval ((vptrofs (Ptrofs.repr (sizeof ge0.genv_cenv ty'))), ty)),
           m, e0))
       | Ealignof (ty', ty) ->
         topred (Rred
           (('r'::('e'::('d'::('_'::('a'::('l'::('i'::('g'::('n'::('o'::('f'::[]))))))))))),
           (Eval ((vptrofs (Ptrofs.repr (alignof ge0.genv_cenv ty'))), ty)),
           m, e0))
       | Eassign (l1, r2, ty) ->
         (match is_loc l1 with
          | Some p ->
            let (p0, ty1) = p in
            let (p1, bf) = p0 in
            let (b, ofs) = p1 in
            (match is_val r2 with
             | Some p2 ->
               let (v2, ty2) = p2 in
               if type_eq ty1 ty
               then (match sem_cast v2 ty2 ty1 m with
                     | Some v ->
                       (match do_assign_loc ge0 w ty1 m b ofs bf v with
                        | Some p3 ->
                          let (p4, v') = p3 in
                          let (p5, m') = p4 in
                          let (_, t0) = p5 in
                          topred (Rred
                            (('r'::('e'::('d'::('_'::('a'::('s'::('s'::('i'::('g'::('n'::[])))))))))),
                            (Eval (v', ty)), m', t0))
                        | None -> stuck)
                     | None -> stuck)
               else stuck
             | None ->
               incontext2 (fun x -> Eassign (x, r2, ty)) (step_expr0 LV l1 m)
                 (fun x -> Eassign (l1, x, ty)) (step_expr0 RV r2 m))
          | None ->
            incontext2 (fun x -> Eassign (x, r2, ty)) (step_expr0 LV l1 m)
              (fun x -> Eassign (l1, x, ty)) (step_expr0 RV r2 m))
       | Eassignop (op, l1, r2, tyres, ty) ->
         (match is_loc l1 with
          | Some p ->
            let (p0, ty1) = p in
            let (p1, bf) = p0 in
            let (b, ofs) = p1 in
            (match is_val r2 with
             | Some p2 ->
               let (v2, ty2) = p2 in
               if type_eq ty1 ty
               then (match do_deref_loc ge0 w ty1 m b ofs bf with
                     | Some p3 ->
                       let (p4, v1) = p3 in
                       let (_, t0) = p4 in
                       let r' = Eassign ((Eloc (b, ofs, bf, ty1)), (Ebinop
                         (op, (Eval (v1, ty1)), (Eval (v2, ty2)), tyres)),
                         ty1)
                       in
                       topred (Rred
                         (('r'::('e'::('d'::('_'::('a'::('s'::('s'::('i'::('g'::('n'::('o'::('p'::[])))))))))))),
                         r', m, t0))
                     | None -> stuck)
               else stuck
             | None ->
               incontext2 (fun x -> Eassignop (op, x, r2, tyres, ty))
                 (step_expr0 LV l1 m) (fun x -> Eassignop (op, l1, x, tyres,
                 ty)) (step_expr0 RV r2 m))
          | None ->
            incontext2 (fun x -> Eassignop (op, x, r2, tyres, ty))
              (step_expr0 LV l1 m) (fun x -> Eassignop (op, l1, x, tyres,
              ty)) (step_expr0 RV r2 m))
       | Epostincr (id, l, ty) ->
         (match is_loc l with
          | Some p ->
            let (p0, ty1) = p in
            let (p1, bf) = p0 in
            let (b, ofs) = p1 in
            if type_eq ty1 ty
            then (match do_deref_loc ge0 w ty m b ofs bf with
                  | Some p2 ->
                    let (p3, v1) = p2 in
                    let (_, t0) = p3 in
                    let op = match id with
                             | Incr -> Oadd
                             | Decr -> Osub in
                    let r' = Ecomma ((Eassign ((Eloc (b, ofs, bf, ty)),
                      (Ebinop (op, (Eval (v1, ty)), (Eval ((Vint Int.one),
                      type_int32s)), (incrdecr_type ty))), ty)), (Eval (v1,
                      ty)), ty)
                    in
                    topred (Rred
                      (('r'::('e'::('d'::('_'::('p'::('o'::('s'::('t'::('i'::('n'::('c'::('r'::[])))))))))))),
                      r', m, t0))
                  | None -> stuck)
            else stuck
          | None ->
            incontext (fun x -> Epostincr (id, x, ty)) (step_expr0 LV l m))
       | Ecomma (r1, r2, ty) ->
         (match is_val r1 with
          | Some _ ->
            if type_eq (typeof r2) ty
            then topred (Rred
                   (('r'::('e'::('d'::('_'::('c'::('o'::('m'::('m'::('a'::[]))))))))),
                   r2, m, e0))
            else stuck
          | None ->
            incontext (fun x -> Ecomma (x, r2, ty)) (step_expr0 RV r1 m))
       | Ecall (r1, rargs, ty) ->
         (match is_val r1 with
          | Some p ->
            let (vf, tyf) = p in
            (match is_val_list rargs with
             | Some vtl ->
               (match classify_fun tyf with
                | Fun_case_f (tyargs, tyres, cconv) ->
                  (match Genv.find_funct ge0.genv_genv vf with
                   | Some fd ->
                     (match sem_cast_arguments vtl tyargs m with
                      | Some vargs ->
                        if type_eq (type_of_fundef fd) (Tfunction (tyargs,
                             tyres, cconv))
                        then topred (Callred
                               (('r'::('e'::('d'::('_'::('c'::('a'::('l'::('l'::[])))))))),
                               fd, vargs, ty, m))
                        else stuck
                      | None -> stuck)
                   | None -> stuck)
                | Fun_default -> stuck)
             | None ->
               incontext2 (fun x -> Ecall (x, rargs, ty))
                 (step_expr0 RV r1 m) (fun x -> Ecall (r1, x, ty))
                 (step_exprlist rargs m))
          | None ->
            incontext2 (fun x -> Ecall (x, rargs, ty)) (step_expr0 RV r1 m)
              (fun x -> Ecall (r1, x, ty)) (step_exprlist rargs m))
       | Ebuiltin (ef, tyargs, rargs, ty) ->
         (match is_val_list rargs with
          | Some vtl ->
            (match sem_cast_arguments vtl tyargs m with
             | Some vargs ->
               (match do_external ge0 do_external_function do_inline_assembly
                        ef w vargs m with
                | Some p ->
                  let (p0, m') = p in
                  let (p1, v) = p0 in
                  let (_, t0) = p1 in
                  topred (Rred
                    (('r'::('e'::('d'::('_'::('b'::('u'::('i'::('l'::('t'::('i'::('n'::[]))))))))))),
                    (Eval (v, ty)), m', t0))
                | None -> stuck)
             | None -> stuck)
          | None ->
            incontext (fun x -> Ebuiltin (ef, tyargs, x, ty))
              (step_exprlist rargs m))
       | Eparen (r1, tycast, ty) ->
         (match is_val r1 with
          | Some p ->
            let (v1, ty1) = p in
            (match sem_cast v1 ty1 tycast m with
             | Some v ->
               topred (Rred
                 (('r'::('e'::('d'::('_'::('p'::('a'::('r'::('e'::('n'::[]))))))))),
                 (Eval (v, ty)), m, e0))
             | None -> stuck)
          | None ->
            incontext (fun x -> Eparen (x, tycast, ty)) (step_expr0 RV r1 m))
       | _ -> stuck)
  and step_exprlist rl m =
    match rl with
    | Enil -> []
    | Econs (r1, rs) ->
      incontext2 (fun x -> Econs (x, rs)) (step_expr0 RV r1 m) (fun x ->
        Econs (r1, x)) (step_exprlist rs m)
  in step_expr0

(** val do_alloc_variables :
    genv -> env -> Mem.mem -> (ident * type0) list -> env * Mem.mem **)

let rec do_alloc_variables ge0 e m = function
| [] -> (e, m)
| p :: l' ->
  let (id, ty) = p in
  let (m1, b1) = Mem.alloc m Z0 (sizeof ge0.genv_cenv ty) in
  do_alloc_variables ge0 (PTree.set id (b1, ty) e) m1 l'

(** val sem_bind_parameters :
    genv -> world -> env -> Mem.mem -> (ident * type0) list -> val0 list ->
    Mem.mem option **)

let rec sem_bind_parameters ge0 w e m l lv =
  match l with
  | [] -> (match lv with
           | [] -> Some m
           | _ :: _ -> None)
  | p :: params ->
    let (id, ty) = p in
    (match lv with
     | [] -> None
     | v1 :: lv0 ->
       (match PTree.get id e with
        | Some p0 ->
          let (b, ty') = p0 in
          if type_eq ty ty'
          then (match do_assign_loc ge0 w ty m b Ptrofs.zero Full v1 with
                | Some p1 ->
                  let (p2, _) = p1 in
                  let (p3, m1) = p2 in
                  let (_, t0) = p3 in
                  (match t0 with
                   | [] -> sem_bind_parameters ge0 w e m1 params lv0
                   | _ :: _ -> None)
                | None -> None)
          else None
        | None -> None))

type transition =
| TR of char list * trace * state

(** val expr_final_state :
    function0 -> cont -> env -> ((expr -> expr) * reduction) -> transition **)

let expr_final_state f k e c_rd =
  match snd c_rd with
  | Lred (rule, a, m) -> TR (rule, e0, (ExprState (f, (fst c_rd a), k, e, m)))
  | Rred (rule, a, m, t0) ->
    TR (rule, t0, (ExprState (f, (fst c_rd a), k, e, m)))
  | Callred (rule, fd, vargs, ty, m) ->
    TR (rule, e0, (Callstate (fd, vargs, (Kcall (f, e, (fst c_rd), ty, k)),
      m)))
  | Stuckred ->
    TR
      (('s'::('t'::('e'::('p'::('_'::('s'::('t'::('u'::('c'::('k'::[])))))))))),
      e0, Stuckstate)

(** val ret : char list -> state -> transition list **)

let ret rule s =
  (TR (rule, e0, s)) :: []

(** val do_step :
    genv -> (char list -> signature -> Senv.t -> world -> val0 list ->
    Mem.mem -> (((world * trace) * val0) * Mem.mem) option) -> (char list ->
    signature -> Senv.t -> world -> val0 list -> Mem.mem ->
    (((world * trace) * val0) * Mem.mem) option) -> world -> state ->
    transition list **)

let do_step ge0 do_external_function do_inline_assembly w = function
| State (f, s0, k, e, m) ->
  (match s0 with
   | Sskip ->
     (match k with
      | Kstop ->
        (match Mem.free_list m (blocks_of_env ge0 e) with
         | Some m' ->
           ret
             ('s'::('t'::('e'::('p'::('_'::('s'::('k'::('i'::('p'::('_'::('c'::('a'::('l'::('l'::[]))))))))))))))
             (Returnstate (Vundef, k, m'))
         | None -> [])
      | Kseq (s1, k0) ->
        ret
          ('s'::('t'::('e'::('p'::('_'::('s'::('k'::('i'::('p'::('_'::('s'::('e'::('q'::[])))))))))))))
          (State (f, s1, k0, e, m))
      | Kwhile2 (x, s1, k0) ->
        ret
          ('s'::('t'::('e'::('p'::('_'::('s'::('k'::('i'::('p'::('_'::('o'::('r'::('_'::('c'::('o'::('n'::('t'::('i'::('n'::('u'::('e'::('_'::('w'::('h'::('i'::('l'::('e'::[])))))))))))))))))))))))))))
          (State (f, (Swhile (x, s1)), k0, e, m))
      | Kdowhile1 (x, s1, k0) ->
        ret
          ('s'::('t'::('e'::('p'::('_'::('s'::('k'::('i'::('p'::('_'::('o'::('r'::('_'::('c'::('o'::('n'::('t'::('i'::('n'::('u'::('e'::('_'::('d'::('o'::('w'::('h'::('i'::('l'::('e'::[])))))))))))))))))))))))))))))
          (ExprState (f, x, (Kdowhile2 (x, s1, k0)), e, m))
      | Kfor3 (a2, a3, s1, k0) ->
        ret
          ('s'::('t'::('e'::('p'::('_'::('s'::('k'::('i'::('p'::('_'::('o'::('r'::('_'::('c'::('o'::('n'::('t'::('i'::('n'::('u'::('e'::('_'::('f'::('o'::('r'::('3'::[]))))))))))))))))))))))))))
          (State (f, a3, (Kfor4 (a2, a3, s1, k0)), e, m))
      | Kfor4 (a2, a3, s1, k0) ->
        ret
          ('s'::('t'::('e'::('p'::('_'::('s'::('k'::('i'::('p'::('_'::('f'::('o'::('r'::('4'::[]))))))))))))))
          (State (f, (Sfor (Sskip, a2, a3, s1)), k0, e, m))
      | Kswitch2 k0 ->
        ret
          ('s'::('t'::('e'::('p'::('_'::('s'::('k'::('i'::('p'::('_'::('b'::('r'::('e'::('a'::('k'::('_'::('s'::('w'::('i'::('t'::('c'::('h'::[]))))))))))))))))))))))
          (State (f, Sskip, k0, e, m))
      | Kcall (_, _, _, _, _) ->
        (match Mem.free_list m (blocks_of_env ge0 e) with
         | Some m' ->
           ret
             ('s'::('t'::('e'::('p'::('_'::('s'::('k'::('i'::('p'::('_'::('c'::('a'::('l'::('l'::[]))))))))))))))
             (Returnstate (Vundef, k, m'))
         | None -> [])
      | _ -> [])
   | Sdo x ->
     ret ('s'::('t'::('e'::('p'::('_'::('d'::('o'::('_'::('1'::[])))))))))
       (ExprState (f, x, (Kdo k), e, m))
   | Ssequence (s1, s2) ->
     ret ('s'::('t'::('e'::('p'::('_'::('s'::('e'::('q'::[])))))))) (State
       (f, s1, (Kseq (s2, k)), e, m))
   | Sifthenelse (a, s1, s2) ->
     ret
       ('s'::('t'::('e'::('p'::('_'::('i'::('f'::('t'::('h'::('e'::('n'::('e'::('l'::('s'::('e'::('_'::('1'::[])))))))))))))))))
       (ExprState (f, a, (Kifthenelse (s1, s2, k)), e, m))
   | Swhile (x, s1) ->
     ret
       ('s'::('t'::('e'::('p'::('_'::('w'::('h'::('i'::('l'::('e'::[]))))))))))
       (ExprState (f, x, (Kwhile1 (x, s1, k)), e, m))
   | Sdowhile (a, s1) ->
     ret
       ('s'::('t'::('e'::('p'::('_'::('d'::('o'::('w'::('h'::('i'::('l'::('e'::[]))))))))))))
       (State (f, s1, (Kdowhile1 (a, s1, k)), e, m))
   | Sfor (a1, a2, a3, s1) ->
     if is_skip a1
     then ret ('s'::('t'::('e'::('p'::('_'::('f'::('o'::('r'::[]))))))))
            (ExprState (f, a2, (Kfor2 (a2, a3, s1, k)), e, m))
     else ret
            ('s'::('t'::('e'::('p'::('_'::('f'::('o'::('r'::('_'::('s'::('t'::('a'::('r'::('t'::[]))))))))))))))
            (State (f, a1, (Kseq ((Sfor (Sskip, a2, a3, s1)), k)), e, m))
   | Sbreak ->
     (match k with
      | Kseq (_, k0) ->
        ret
          ('s'::('t'::('e'::('p'::('_'::('b'::('r'::('e'::('a'::('k'::('_'::('s'::('e'::('q'::[]))))))))))))))
          (State (f, Sbreak, k0, e, m))
      | Kwhile2 (_, _, k0) ->
        ret
          ('s'::('t'::('e'::('p'::('_'::('b'::('r'::('e'::('a'::('k'::('_'::('w'::('h'::('i'::('l'::('e'::[]))))))))))))))))
          (State (f, Sskip, k0, e, m))
      | Kdowhile1 (_, _, k0) ->
        ret
          ('s'::('t'::('e'::('p'::('_'::('b'::('r'::('e'::('a'::('k'::('_'::('d'::('o'::('w'::('h'::('i'::('l'::('e'::[]))))))))))))))))))
          (State (f, Sskip, k0, e, m))
      | Kfor3 (_, _, _, k0) ->
        ret
          ('s'::('t'::('e'::('p'::('_'::('b'::('r'::('e'::('a'::('k'::('_'::('f'::('o'::('r'::('3'::[])))))))))))))))
          (State (f, Sskip, k0, e, m))
      | Kswitch2 k0 ->
        ret
          ('s'::('t'::('e'::('p'::('_'::('s'::('k'::('i'::('p'::('_'::('b'::('r'::('e'::('a'::('k'::('_'::('s'::('w'::('i'::('t'::('c'::('h'::[]))))))))))))))))))))))
          (State (f, Sskip, k0, e, m))
      | _ -> [])
   | Scontinue ->
     (match k with
      | Kseq (_, k0) ->
        ret
          ('s'::('t'::('e'::('p'::('_'::('c'::('o'::('n'::('t'::('i'::('n'::('u'::('e'::('_'::('s'::('e'::('q'::[])))))))))))))))))
          (State (f, Scontinue, k0, e, m))
      | Kwhile2 (x, s1, k0) ->
        ret
          ('s'::('t'::('e'::('p'::('_'::('s'::('k'::('i'::('p'::('_'::('o'::('r'::('_'::('c'::('o'::('n'::('t'::('i'::('n'::('u'::('e'::('_'::('w'::('h'::('i'::('l'::('e'::[])))))))))))))))))))))))))))
          (State (f, (Swhile (x, s1)), k0, e, m))
      | Kdowhile1 (x, s1, k0) ->
        ret
          ('s'::('t'::('e'::('p'::('_'::('s'::('k'::('i'::('p'::('_'::('o'::('r'::('_'::('c'::('o'::('n'::('t'::('i'::('n'::('u'::('e'::('_'::('d'::('o'::('w'::('h'::('i'::('l'::('e'::[])))))))))))))))))))))))))))))
          (ExprState (f, x, (Kdowhile2 (x, s1, k0)), e, m))
      | Kfor3 (a2, a3, s1, k0) ->
        ret
          ('s'::('t'::('e'::('p'::('_'::('s'::('k'::('i'::('p'::('_'::('o'::('r'::('_'::('c'::('o'::('n'::('t'::('i'::('n'::('u'::('e'::('_'::('f'::('o'::('r'::('3'::[]))))))))))))))))))))))))))
          (State (f, a3, (Kfor4 (a2, a3, s1, k0)), e, m))
      | Kswitch2 k0 ->
        ret
          ('s'::('t'::('e'::('p'::('_'::('c'::('o'::('n'::('t'::('i'::('n'::('u'::('e'::('_'::('s'::('w'::('i'::('t'::('c'::('h'::[]))))))))))))))))))))
          (State (f, Scontinue, k0, e, m))
      | _ -> [])
   | Sreturn o ->
     (match o with
      | Some x ->
        ret
          ('s'::('t'::('e'::('p'::('_'::('r'::('e'::('t'::('u'::('r'::('n'::('_'::('1'::[])))))))))))))
          (ExprState (f, x, (Kreturn k), e, m))
      | None ->
        (match Mem.free_list m (blocks_of_env ge0 e) with
         | Some m' ->
           ret
             ('s'::('t'::('e'::('p'::('_'::('r'::('e'::('t'::('u'::('r'::('n'::('_'::('0'::[])))))))))))))
             (Returnstate (Vundef, (call_cont k), m'))
         | None -> []))
   | Sswitch (x, sl) ->
     ret
       ('s'::('t'::('e'::('p'::('_'::('s'::('w'::('i'::('t'::('c'::('h'::[])))))))))))
       (ExprState (f, x, (Kswitch1 (sl, k)), e, m))
   | Slabel (_, s1) ->
     ret
       ('s'::('t'::('e'::('p'::('_'::('l'::('a'::('b'::('e'::('l'::[]))))))))))
       (State (f, s1, k, e, m))
   | Sgoto lbl ->
     (match find_label lbl f.fn_body (call_cont k) with
      | Some p ->
        let (s', k') = p in
        ret ('s'::('t'::('e'::('p'::('_'::('g'::('o'::('t'::('o'::[])))))))))
          (State (f, s', k', e, m))
      | None -> []))
| ExprState (f, a, k, e, m) ->
  (match is_val a with
   | Some p ->
     let (v, ty) = p in
     (match k with
      | Kdo k0 ->
        ret ('s'::('t'::('e'::('p'::('_'::('d'::('o'::('_'::('2'::[])))))))))
          (State (f, Sskip, k0, e, m))
      | Kifthenelse (s1, s2, k0) ->
        (match bool_val v ty m with
         | Some b ->
           ret
             ('s'::('t'::('e'::('p'::('_'::('i'::('f'::('t'::('h'::('e'::('n'::('e'::('l'::('s'::('e'::('_'::('2'::[])))))))))))))))))
             (State (f, (if b then s1 else s2), k0, e, m))
         | None -> [])
      | Kwhile1 (x, s0, k0) ->
        (match bool_val v ty m with
         | Some b ->
           if b
           then ret
                  ('s'::('t'::('e'::('p'::('_'::('w'::('h'::('i'::('l'::('e'::('_'::('t'::('r'::('u'::('e'::[])))))))))))))))
                  (State (f, s0, (Kwhile2 (x, s0, k0)), e, m))
           else ret
                  ('s'::('t'::('e'::('p'::('_'::('w'::('h'::('i'::('l'::('e'::('_'::('f'::('a'::('l'::('s'::('e'::[]))))))))))))))))
                  (State (f, Sskip, k0, e, m))
         | None -> [])
      | Kdowhile2 (x, s0, k0) ->
        (match bool_val v ty m with
         | Some b ->
           if b
           then ret
                  ('s'::('t'::('e'::('p'::('_'::('d'::('o'::('w'::('h'::('i'::('l'::('e'::('_'::('t'::('r'::('u'::('e'::[])))))))))))))))))
                  (State (f, (Sdowhile (x, s0)), k0, e, m))
           else ret
                  ('s'::('t'::('e'::('p'::('_'::('d'::('o'::('w'::('h'::('i'::('l'::('e'::('_'::('f'::('a'::('l'::('s'::('e'::[]))))))))))))))))))
                  (State (f, Sskip, k0, e, m))
         | None -> [])
      | Kfor2 (a2, a3, s0, k0) ->
        (match bool_val v ty m with
         | Some b ->
           if b
           then ret
                  ('s'::('t'::('e'::('p'::('_'::('f'::('o'::('r'::('_'::('t'::('r'::('u'::('e'::[])))))))))))))
                  (State (f, s0, (Kfor3 (a2, a3, s0, k0)), e, m))
           else ret
                  ('s'::('t'::('e'::('p'::('_'::('f'::('o'::('r'::('_'::('f'::('a'::('l'::('s'::('e'::[]))))))))))))))
                  (State (f, Sskip, k0, e, m))
         | None -> [])
      | Kswitch1 (sl, k0) ->
        (match sem_switch_arg v ty with
         | Some n0 ->
           ret
             ('s'::('t'::('e'::('p'::('_'::('e'::('x'::('p'::('r'::('_'::('s'::('w'::('i'::('t'::('c'::('h'::[]))))))))))))))))
             (State (f, (seq_of_labeled_statement (select_switch n0 sl)),
             (Kswitch2 k0), e, m))
         | None -> [])
      | Kreturn k0 ->
        (match sem_cast v ty f.fn_return m with
         | Some v' ->
           (match Mem.free_list m (blocks_of_env ge0 e) with
            | Some m' ->
              ret
                ('s'::('t'::('e'::('p'::('_'::('r'::('e'::('t'::('u'::('r'::('n'::('_'::('2'::[])))))))))))))
                (Returnstate (v', (call_cont k0), m'))
            | None -> [])
         | None -> [])
      | _ -> [])
   | None ->
     map (expr_final_state f k e)
       (step_expr ge0 do_external_function do_inline_assembly e w RV a m))
| Callstate (fd, vargs, k, m) ->
  (match fd with
   | Internal f ->
     if list_norepet_dec ident_eq
          (app (var_names f.fn_params) (var_names f.fn_vars))
     then let (e, m1) =
            do_alloc_variables ge0 empty_env m (app f.fn_params f.fn_vars)
          in
          (match sem_bind_parameters ge0 w e m1 f.fn_params vargs with
           | Some m2 ->
             ret
               ('s'::('t'::('e'::('p'::('_'::('i'::('n'::('t'::('e'::('r'::('n'::('a'::('l'::('_'::('f'::('u'::('n'::('c'::('t'::('i'::('o'::('n'::[]))))))))))))))))))))))
               (State (f, f.fn_body, k, e, m2))
           | None -> [])
     else []
   | External (ef, _, _, _) ->
     (match do_external ge0 do_external_function do_inline_assembly ef w
              vargs m with
      | Some p ->
        let (p0, m') = p in
        let (p1, v) = p0 in
        let (_, t0) = p1 in
        (TR
        (('s'::('t'::('e'::('p'::('_'::('e'::('x'::('t'::('e'::('r'::('n'::('a'::('l'::('_'::('f'::('u'::('n'::('c'::('t'::('i'::('o'::('n'::[])))))))))))))))))))))),
        t0, (Returnstate (v, k, m')))) :: []
      | None -> []))
| Returnstate (v, k0, m) ->
  (match k0 with
   | Kcall (f, e, c, ty, k) ->
     ret
       ('s'::('t'::('e'::('p'::('_'::('r'::('e'::('t'::('u'::('r'::('n'::('s'::('t'::('a'::('t'::('e'::[]))))))))))))))))
       (ExprState (f, (c (Eval (v, ty))), k, e, m))
   | _ -> [])
| Stuckstate -> []

(** val tvoid : type0 **)

let tvoid =
  Tvoid

(** val tschar : type0 **)

let tschar =
  Tint0 (I8, Signed, noattr)

(** val tushort : type0 **)

let tushort =
  Tint0 (I16, Unsigned, noattr)

(** val tint : type0 **)

let tint =
  Tint0 (I32, Signed, noattr)

(** val tuint : type0 **)

let tuint =
  Tint0 (I32, Unsigned, noattr)

(** val tbool : type0 **)

let tbool =
  Tint0 (IBool, Unsigned, noattr)

(** val tlong : type0 **)

let tlong =
  Tlong0 (Signed, noattr)

(** val tulong : type0 **)

let tulong =
  Tlong0 (Unsigned, noattr)

(** val tfloat : type0 **)

let tfloat =
  Tfloat0 (F32, noattr)

(** val tdouble : type0 **)

let tdouble =
  Tfloat0 (F64, noattr)

(** val tptr0 : type0 -> type0 **)

let tptr0 t0 =
  Tpointer (t0, noattr)

(** val build_composite_env' : composite_definition list -> composite_env **)

let build_composite_env' types =
  match build_composite_env types with
  | OK c -> c
  | Error _ -> assert false (* absurd case *)

(** val mkprogram :
    composite_definition list -> (ident * (fundef0, type0) globdef) list ->
    ident list -> ident -> program1 **)

let mkprogram types defs public main =
  { prog_defs0 = defs; prog_public0 = public; prog_main0 = main; prog_types =
    types; prog_comp_env = (build_composite_env' types) }

(** val ___builtin_ais_annot : ident **)

let ___builtin_ais_annot =
  XO (XI (XI (XI (XI (XI (XO (XI (XI (XI (XI (XI (XI (XI (XO (XI (XO (XO (XO
    (XI (XI (XI (XI (XO (XO (XI (XO (XO (XI (XO (XI (XO (XI (XO (XI (XO (XI
    (XO (XI (XI (XI (XO (XO (XI (XO (XO (XI (XO (XI (XI (XI (XO (XI (XO (XO
    (XI (XI (XI (XI (XI (XO (XI (XO (XI (XO (XO (XO (XI (XO (XO (XI (XO (XO
    (XO (XI (XI (XI (XO (XO (XI (XI (XI (XI (XI (XO (XI (XO (XI (XO (XO (XI
    (XI (XI (XO (XI (XO (XI (XI (XI (XO (XI (XO (XO (XO (XO (XI (XI (XO (XI
    (XO (XI (XI (XI (XO
    XH)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))

(** val ___builtin_annot : ident **)

let ___builtin_annot =
  XO (XI (XI (XI (XI (XI (XO (XI (XI (XI (XI (XI (XI (XI (XO (XI (XO (XO (XO
    (XI (XI (XI (XI (XO (XO (XI (XO (XO (XI (XO (XI (XO (XI (XO (XI (XO (XI
    (XO (XI (XI (XI (XO (XO (XI (XO (XO (XI (XO (XI (XI (XI (XO (XI (XO (XO
    (XI (XI (XI (XI (XI (XO (XI (XO (XI (XO (XO (XI (XI (XI (XO (XI (XO (XI
    (XI (XI (XO (XI (XO (XO (XO (XO (XI (XI (XO (XI (XO (XI (XI (XI (XO
    XH)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))

(** val ___builtin_annot_intval : ident **)

let ___builtin_annot_intval =
  XO (XI (XI (XI (XI (XI (XO (XI (XI (XI (XI (XI (XI (XI (XO (XI (XO (XO (XO
    (XI (XI (XI (XI (XO (XO (XI (XO (XO (XI (XO (XI (XO (XI (XO (XI (XO (XI
    (XO (XI (XI (XI (XO (XO (XI (XO (XO (XI (XO (XI (XI (XI (XO (XI (XO (XO
    (XI (XI (XI (XI (XI (XO (XI (XO (XI (XO (XO (XI (XI (XI (XO (XI (XO (XI
    (XI (XI (XO (XI (XO (XO (XO (XO (XI (XI (XO (XI (XO (XI (XI (XI (XO (XO
    (XI (XI (XI (XI (XI (XO (XI (XO (XO (XI (XO (XI (XI (XI (XO (XI (XO (XI
    (XO (XI (XI (XI (XO (XI (XI (XI (XI (XI (XO (XO (XI (XO (XI (XO (XO (XI
    (XO (XI (XO (XI (XO
    XH)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))

(** val ___builtin_bswap : ident **)

let ___builtin_bswap =
  XO (XI (XI (XI (XI (XI (XO (XI (XI (XI (XI (XI (XI (XI (XO (XI (XO (XO (XO
    (XI (XI (XI (XI (XO (XO (XI (XO (XO (XI (XO (XI (XO (XI (XO (XI (XO (XI
    (XO (XI (XI (XI (XO (XO (XI (XO (XO (XI (XO (XI (XI (XI (XO (XI (XO (XO
    (XI (XI (XI (XI (XI (XI (XI (XO (XI (XO (XO (XO (XO (XI (XI (XI (XO (XO
    (XO (XO (XO (XO (XI (XO (XI (XO (XI (XO (XO (XI (XO (XO (XI (XI (XO
    XH)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))

(** val ___builtin_bswap16 : ident **)

let ___builtin_bswap16 =
  XO (XI (XI (XI (XI (XI (XO (XI (XI (XI (XI (XI (XI (XI (XO (XI (XO (XO (XO
    (XI (XI (XI (XI (XO (XO (XI (XO (XO (XI (XO (XI (XO (XI (XO (XI (XO (XI
    (XO (XI (XI (XI (XO (XO (XI (XO (XO (XI (XO (XI (XI (XI (XO (XI (XO (XO
    (XI (XI (XI (XI (XI (XI (XI (XO (XI (XO (XO (XO (XO (XI (XI (XI (XO (XO
    (XO (XO (XO (XO (XI (XO (XI (XO (XI (XO (XO (XI (XO (XO (XI (XI (XO (XI
    (XO (XO (XO (XO (XO (XO (XI (XI (XO (XO (XO
    XH)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))

(** val ___builtin_bswap32 : ident **)

let ___builtin_bswap32 =
  XO (XI (XI (XI (XI (XI (XO (XI (XI (XI (XI (XI (XI (XI (XO (XI (XO (XO (XO
    (XI (XI (XI (XI (XO (XO (XI (XO (XO (XI (XO (XI (XO (XI (XO (XI (XO (XI
    (XO (XI (XI (XI (XO (XO (XI (XO (XO (XI (XO (XI (XI (XI (XO (XI (XO (XO
    (XI (XI (XI (XI (XI (XI (XI (XO (XI (XO (XO (XO (XO (XI (XI (XI (XO (XO
    (XO (XO (XO (XO (XI (XO (XI (XO (XI (XO (XO (XI (XO (XO (XI (XI (XO (XI
    (XI (XO (XO (XO (XO (XO (XI (XO (XO (XO (XO
    XH)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))

(** val ___builtin_bswap64 : ident **)

let ___builtin_bswap64 =
  XO (XI (XI (XI (XI (XI (XO (XI (XI (XI (XI (XI (XI (XI (XO (XI (XO (XO (XO
    (XI (XI (XI (XI (XO (XO (XI (XO (XO (XI (XO (XI (XO (XI (XO (XI (XO (XI
    (XO (XI (XI (XI (XO (XO (XI (XO (XO (XI (XO (XI (XI (XI (XO (XI (XO (XO
    (XI (XI (XI (XI (XI (XI (XI (XO (XI (XO (XO (XO (XO (XI (XI (XI (XO (XO
    (XO (XO (XO (XO (XI (XO (XI (XO (XI (XO (XO (XI (XO (XO (XI (XI (XO (XO
    (XI (XI (XO (XO (XO (XO (XO (XI (XO (XO (XO
    XH)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))

(** val ___builtin_clz : ident **)

let ___builtin_clz =
  XO (XI (XI (XI (XI (XI (XO (XI (XI (XI (XI (XI (XI (XI (XO (XI (XO (XO (XO
    (XI (XI (XI (XI (XO (XO (XI (XO (XO (XI (XO (XI (XO (XI (XO (XI (XO (XI
    (XO (XI (XI (XI (XO (XO (XI (XO (XO (XI (XO (XI (XI (XI (XO (XI (XO (XO
    (XI (XI (XI (XI (XI (XO (XO (XI (XI (XO (XO (XI (XO (XI (XO (XI (XO (XI
    (XI (XO (XO (XO (XI
    XH)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))

(** val ___builtin_clzl : ident **)

let ___builtin_clzl =
  XO (XI (XI (XI (XI (XI (XO (XI (XI (XI (XI (XI (XI (XI (XO (XI (XO (XO (XO
    (XI (XI (XI (XI (XO (XO (XI (XO (XO (XI (XO (XI (XO (XI (XO (XI (XO (XI
    (XO (XI (XI (XI (XO (XO (XI (XO (XO (XI (XO (XI (XI (XI (XO (XI (XO (XO
    (XI (XI (XI (XI (XI (XO (XO (XI (XI (XO (XO (XI (XO (XI (XO (XI (XO (XI
    (XI (XO (XO (XO (XI (XI (XO (XI (XO (XI (XO
    XH)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))

(** val ___builtin_clzll : ident **)

let ___builtin_clzll =
  XO (XI (XI (XI (XI (XI (XO (XI (XI (XI (XI (XI (XI (XI (XO (XI (XO (XO (XO
    (XI (XI (XI (XI (XO (XO (XI (XO (XO (XI (XO (XI (XO (XI (XO (XI (XO (XI
    (XO (XI (XI (XI (XO (XO (XI (XO (XO (XI (XO (XI (XI (XI (XO (XI (XO (XO
    (XI (XI (XI (XI (XI (XO (XO (XI (XI (XO (XO (XI (XO (XI (XO (XI (XO (XI
    (XI (XO (XO (XO (XI (XI (XO (XI (XO (XI (XO (XI (XO (XI (XO (XI (XO
    XH)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))

(** val ___builtin_ctz : ident **)

let ___builtin_ctz =
  XO (XI (XI (XI (XI (XI (XO (XI (XI (XI (XI (XI (XI (XI (XO (XI (XO (XO (XO
    (XI (XI (XI (XI (XO (XO (XI (XO (XO (XI (XO (XI (XO (XI (XO (XI (XO (XI
    (XO (XI (XI (XI (XO (XO (XI (XO (XO (XI (XO (XI (XI (XI (XO (XI (XO (XO
    (XI (XI (XI (XI (XI (XO (XO (XI (XI (XO (XO (XI (XO (XI (XI (XI (XO (XI
    (XI (XO (XO (XO (XI
    XH)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))

(** val ___builtin_ctzl : ident **)

let ___builtin_ctzl =
  XO (XI (XI (XI (XI (XI (XO (XI (XI (XI (XI (XI (XI (XI (XO (XI (XO (XO (XO
    (XI (XI (XI (XI (XO (XO (XI (XO (XO (XI (XO (XI (XO (XI (XO (XI (XO (XI
    (XO (XI (XI (XI (XO (XO (XI (XO (XO (XI (XO (XI (XI (XI (XO (XI (XO (XO
    (XI (XI (XI (XI (XI (XO (XO (XI (XI (XO (XO (XI (XO (XI (XI (XI (XO (XI
    (XI (XO (XO (XO (XI (XI (XO (XI (XO (XI (XO
    XH)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))

(** val ___builtin_ctzll : ident **)

let ___builtin_ctzll =
  XO (XI (XI (XI (XI (XI (XO (XI (XI (XI (XI (XI (XI (XI (XO (XI (XO (XO (XO
    (XI (XI (XI (XI (XO (XO (XI (XO (XO (XI (XO (XI (XO (XI (XO (XI (XO (XI
    (XO (XI (XI (XI (XO (XO (XI (XO (XO (XI (XO (XI (XI (XI (XO (XI (XO (XO
    (XI (XI (XI (XI (XI (XO (XO (XI (XI (XO (XO (XI (XO (XI (XI (XI (XO (XI
    (XI (XO (XO (XO (XI (XI (XO (XI (XO (XI (XO (XI (XO (XI (XO (XI (XO
    XH)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))

(** val ___builtin_debug : ident **)

let ___builtin_debug =
  XO (XI (XI (XI (XI (XI (XO (XI (XI (XI (XI (XI (XI (XI (XO (XI (XO (XO (XO
    (XI (XI (XI (XI (XO (XO (XI (XO (XO (XI (XO (XI (XO (XI (XO (XI (XO (XI
    (XO (XI (XI (XI (XO (XO (XI (XO (XO (XI (XO (XI (XI (XI (XO (XI (XO (XO
    (XI (XI (XI (XI (XI (XI (XO (XI (XI (XO (XO (XO (XI (XI (XI (XO (XO (XI
    (XI (XO (XI (XO (XO (XO (XI (XI (XI (XI (XO (XO (XO (XO (XO (XI (XO
    XH)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))

(** val ___builtin_expect : ident **)

let ___builtin_expect =
  XO (XI (XI (XI (XI (XI (XO (XI (XI (XI (XI (XI (XI (XI (XO (XI (XO (XO (XO
    (XI (XI (XI (XI (XO (XO (XI (XO (XO (XI (XO (XI (XO (XI (XO (XI (XO (XI
    (XO (XI (XI (XI (XO (XO (XI (XO (XO (XI (XO (XI (XI (XI (XO (XI (XO (XO
    (XI (XI (XI (XI (XI (XO (XI (XI (XI (XO (XO (XI (XO (XO (XO (XO (XI (XI
    (XO (XO (XI (XI (XO (XO (XI (XI (XI (XO (XO (XO (XO (XI (XI (XO (XO (XI
    (XO (XI (XI (XI (XO
    XH)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))

(** val ___builtin_fabs : ident **)

let ___builtin_fabs =
  XO (XI (XI (XI (XI (XI (XO (XI (XI (XI (XI (XI (XI (XI (XO (XI (XO (XO (XO
    (XI (XI (XI (XI (XO (XO (XI (XO (XO (XI (XO (XI (XO (XI (XO (XI (XO (XI
    (XO (XI (XI (XI (XO (XO (XI (XO (XO (XI (XO (XI (XI (XI (XO (XI (XO (XO
    (XI (XI (XI (XI (XI (XI (XI (XI (XI (XO (XO (XO (XI (XO (XI (XO (XO (XI
    (XI (XO (XI (XO (XO (XO (XO (XI (XI (XI (XO
    XH)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))

(** val ___builtin_fabsf : ident **)

let ___builtin_fabsf =
  XO (XI (XI (XI (XI (XI (XO (XI (XI (XI (XI (XI (XI (XI (XO (XI (XO (XO (XO
    (XI (XI (XI (XI (XO (XO (XI (XO (XO (XI (XO (XI (XO (XI (XO (XI (XO (XI
    (XO (XI (XI (XI (XO (XO (XI (XO (XO (XI (XO (XI (XI (XI (XO (XI (XO (XO
    (XI (XI (XI (XI (XI (XI (XI (XI (XI (XO (XO (XO (XI (XO (XI (XO (XO (XI
    (XI (XO (XI (XO (XO (XO (XO (XI (XI (XI (XO (XI (XI (XI (XI (XO (XO
    XH)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))

(** val ___builtin_fmadd : ident **)

let ___builtin_fmadd =
  XO (XI (XI (XI (XI (XI (XO (XI (XI (XI (XI (XI (XI (XI (XO (XI (XO (XO (XO
    (XI (XI (XI (XI (XO (XO (XI (XO (XO (XI (XO (XI (XO (XI (XO (XI (XO (XI
    (XO (XI (XI (XI (XO (XO (XI (XO (XO (XI (XO (XI (XI (XI (XO (XI (XO (XO
    (XI (XI (XI (XI (XI (XI (XI (XI (XI (XO (XO (XO (XI (XI (XO (XI (XO (XO
    (XI (XO (XI (XO (XO (XI (XO (XI (XI (XO (XO (XI (XO (XI (XI (XO (XO
    XH)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))

(** val ___builtin_fmax : ident **)

let ___builtin_fmax =
  XO (XI (XI (XI (XI (XI (XO (XI (XI (XI (XI (XI (XI (XI (XO (XI (XO (XO (XO
    (XI (XI (XI (XI (XO (XO (XI (XO (XO (XI (XO (XI (XO (XI (XO (XI (XO (XI
    (XO (XI (XI (XI (XO (XO (XI (XO (XO (XI (XO (XI (XI (XI (XO (XI (XO (XO
    (XI (XI (XI (XI (XI (XI (XI (XI (XI (XO (XO (XO (XI (XI (XO (XI (XO (XO
    (XI (XO (XI (XO (XO (XI (XO (XO (XO (XO (XI
    XH)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))

(** val ___builtin_fmin : ident **)

let ___builtin_fmin =
  XO (XI (XI (XI (XI (XI (XO (XI (XI (XI (XI (XI (XI (XI (XO (XI (XO (XO (XO
    (XI (XI (XI (XI (XO (XO (XI (XO (XO (XI (XO (XI (XO (XI (XO (XI (XO (XI
    (XO (XI (XI (XI (XO (XO (XI (XO (XO (XI (XO (XI (XI (XI (XO (XI (XO (XO
    (XI (XI (XI (XI (XI (XI (XI (XI (XI (XO (XO (XO (XI (XI (XO (XI (XO (XO
    (XI (XO (XO (XI (XO (XI (XI (XI (XO (XI (XO
    XH)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))

(** val ___builtin_fmsub : ident **)

let ___builtin_fmsub =
  XO (XI (XI (XI (XI (XI (XO (XI (XI (XI (XI (XI (XI (XI (XO (XI (XO (XO (XO
    (XI (XI (XI (XI (XO (XO (XI (XO (XO (XI (XO (XI (XO (XI (XO (XI (XO (XI
    (XO (XI (XI (XI (XO (XO (XI (XO (XO (XI (XO (XI (XI (XI (XO (XI (XO (XO
    (XI (XI (XI (XI (XI (XI (XI (XI (XI (XO (XO (XO (XI (XI (XO (XI (XO (XO
    (XO (XI (XI (XI (XO (XO (XI (XI (XI (XI (XO (XI (XI (XO (XI (XO (XO
    XH)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))

(** val ___builtin_fnmadd : ident **)

let ___builtin_fnmadd =
  XO (XI (XI (XI (XI (XI (XO (XI (XI (XI (XI (XI (XI (XI (XO (XI (XO (XO (XO
    (XI (XI (XI (XI (XO (XO (XI (XO (XO (XI (XO (XI (XO (XI (XO (XI (XO (XI
    (XO (XI (XI (XI (XO (XO (XI (XO (XO (XI (XO (XI (XI (XI (XO (XI (XO (XO
    (XI (XI (XI (XI (XI (XI (XI (XI (XI (XO (XO (XI (XI (XI (XO (XI (XO (XO
    (XI (XI (XO (XI (XO (XO (XI (XO (XI (XO (XO (XI (XO (XI (XI (XO (XO (XI
    (XO (XI (XI (XO (XO
    XH)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))

(** val ___builtin_fnmsub : ident **)

let ___builtin_fnmsub =
  XO (XI (XI (XI (XI (XI (XO (XI (XI (XI (XI (XI (XI (XI (XO (XI (XO (XO (XO
    (XI (XI (XI (XI (XO (XO (XI (XO (XO (XI (XO (XI (XO (XI (XO (XI (XO (XI
    (XO (XI (XI (XI (XO (XO (XI (XO (XO (XI (XO (XI (XI (XI (XO (XI (XO (XO
    (XI (XI (XI (XI (XI (XI (XI (XI (XI (XO (XO (XI (XI (XI (XO (XI (XO (XO
    (XI (XI (XO (XI (XO (XO (XO (XI (XI (XI (XO (XO (XI (XI (XI (XI (XO (XI
    (XI (XO (XI (XO (XO
    XH)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))

(** val ___builtin_fsqrt : ident **)

let ___builtin_fsqrt =
  XO (XI (XI (XI (XI (XI (XO (XI (XI (XI (XI (XI (XI (XI (XO (XI (XO (XO (XO
    (XI (XI (XI (XI (XO (XO (XI (XO (XO (XI (XO (XI (XO (XI (XO (XI (XO (XI
    (XO (XI (XI (XI (XO (XO (XI (XO (XO (XI (XO (XI (XI (XI (XO (XI (XO (XO
    (XI (XI (XI (XI (XI (XI (XI (XI (XI (XO (XO (XO (XO (XI (XI (XI (XO (XO
    (XI (XO (XI (XI (XO (XI (XI (XO (XI (XI (XO (XI (XO (XI (XI (XI (XO
    XH)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))

(** val ___builtin_membar : ident **)

let ___builtin_membar =
  XO (XI (XI (XI (XI (XI (XO (XI (XI (XI (XI (XI (XI (XI (XO (XI (XO (XO (XO
    (XI (XI (XI (XI (XO (XO (XI (XO (XO (XI (XO (XI (XO (XI (XO (XI (XO (XI
    (XO (XI (XI (XI (XO (XO (XI (XO (XO (XI (XO (XI (XI (XI (XO (XI (XO (XO
    (XI (XI (XI (XI (XI (XO (XI (XI (XO (XI (XO (XO (XI (XI (XI (XO (XO (XO
    (XI (XI (XO (XI (XO (XI (XI (XO (XI (XO (XO (XO (XI (XO (XI (XO (XO (XI
    (XI (XO (XI (XI (XO
    XH)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))

(** val ___builtin_memcpy_aligned : ident **)

let ___builtin_memcpy_aligned =
  XO (XI (XI (XI (XI (XI (XO (XI (XI (XI (XI (XI (XI (XI (XO (XI (XO (XO (XO
    (XI (XI (XI (XI (XO (XO (XI (XO (XO (XI (XO (XI (XO (XI (XO (XI (XO (XI
    (XO (XI (XI (XI (XO (XO (XI (XO (XO (XI (XO (XI (XI (XI (XO (XI (XO (XO
    (XI (XI (XI (XI (XI (XO (XI (XI (XO (XI (XO (XO (XI (XI (XI (XO (XO (XO
    (XI (XI (XO (XI (XO (XO (XO (XI (XI (XO (XO (XI (XO (XO (XI (XI (XO (XO
    (XI (XO (XO (XO (XI (XO (XI (XI (XI (XI (XI (XO (XI (XO (XI (XO (XO (XI
    (XO (XI (XO (XI (XO (XO (XI (XO (XO (XI (XO (XO (XO (XO (XO (XI (XO (XI
    (XI (XI (XO (XI (XO (XO (XI (XI (XI (XO (XO (XI (XO (XI (XI (XO (XO
    XH)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))

(** val ___builtin_read16_reversed : ident **)

let ___builtin_read16_reversed =
  XO (XI (XI (XI (XI (XI (XO (XI (XI (XI (XI (XI (XI (XI (XO (XI (XO (XO (XO
    (XI (XI (XI (XI (XO (XO (XI (XO (XO (XI (XO (XI (XO (XI (XO (XI (XO (XI
    (XO (XI (XI (XI (XO (XO (XI (XO (XO (XI (XO (XI (XI (XI (XO (XI (XO (XO
    (XI (XI (XI (XI (XI (XI (XI (XO (XI (XI (XO (XO (XI (XI (XI (XO (XO (XO
    (XI (XO (XI (XO (XO (XI (XO (XI (XI (XO (XO (XI (XO (XO (XO (XO (XO (XO
    (XI (XI (XO (XO (XO (XO (XI (XI (XI (XI (XI (XI (XI (XO (XI (XI (XO (XO
    (XI (XI (XI (XO (XO (XI (XI (XI (XI (XI (XO (XO (XI (XI (XI (XO (XO (XI
    (XI (XO (XI (XI (XO (XO (XO (XI (XI (XI (XO (XO (XI (XI (XI (XO (XO (XI
    (XO (XI (XI (XO (XO
    XH)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))

(** val ___builtin_read32_reversed : ident **)

let ___builtin_read32_reversed =
  XO (XI (XI (XI (XI (XI (XO (XI (XI (XI (XI (XI (XI (XI (XO (XI (XO (XO (XO
    (XI (XI (XI (XI (XO (XO (XI (XO (XO (XI (XO (XI (XO (XI (XO (XI (XO (XI
    (XO (XI (XI (XI (XO (XO (XI (XO (XO (XI (XO (XI (XI (XI (XO (XI (XO (XO
    (XI (XI (XI (XI (XI (XI (XI (XO (XI (XI (XO (XO (XI (XI (XI (XO (XO (XO
    (XI (XO (XI (XO (XO (XI (XO (XI (XI (XO (XO (XI (XI (XO (XO (XO (XO (XO
    (XI (XO (XO (XO (XO (XO (XI (XI (XI (XI (XI (XI (XI (XO (XI (XI (XO (XO
    (XI (XI (XI (XO (XO (XI (XI (XI (XI (XI (XO (XO (XI (XI (XI (XO (XO (XI
    (XI (XO (XI (XI (XO (XO (XO (XI (XI (XI (XO (XO (XI (XI (XI (XO (XO (XI
    (XO (XI (XI (XO (XO
    XH)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))

(** val ___builtin_sel : ident **)

let ___builtin_sel =
  XO (XI (XI (XI (XI (XI (XO (XI (XI (XI (XI (XI (XI (XI (XO (XI (XO (XO (XO
    (XI (XI (XI (XI (XO (XO (XI (XO (XO (XI (XO (XI (XO (XI (XO (XI (XO (XI
    (XO (XI (XI (XI (XO (XO (XI (XO (XO (XI (XO (XI (XI (XI (XO (XI (XO (XO
    (XI (XI (XI (XI (XI (XO (XO (XI (XI (XI (XO (XO (XI (XI (XI (XO (XO (XI
    (XO (XI (XO (XI (XO
    XH)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))

(** val ___builtin_sqrt : ident **)

let ___builtin_sqrt =
  XO (XI (XI (XI (XI (XI (XO (XI (XI (XI (XI (XI (XI (XI (XO (XI (XO (XO (XO
    (XI (XI (XI (XI (XO (XO (XI (XO (XO (XI (XO (XI (XO (XI (XO (XI (XO (XI
    (XO (XI (XI (XI (XO (XO (XI (XO (XO (XI (XO (XI (XI (XI (XO (XI (XO (XO
    (XI (XI (XI (XI (XI (XO (XO (XI (XI (XI (XO (XO (XI (XO (XI (XI (XO (XI
    (XI (XO (XI (XI (XO (XI (XO (XI (XI (XI (XO
    XH)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))

(** val ___builtin_unreachable : ident **)

let ___builtin_unreachable =
  XO (XI (XI (XI (XI (XI (XO (XI (XI (XI (XI (XI (XI (XI (XO (XI (XO (XO (XO
    (XI (XI (XI (XI (XO (XO (XI (XO (XO (XI (XO (XI (XO (XI (XO (XI (XO (XI
    (XO (XI (XI (XI (XO (XO (XI (XO (XO (XI (XO (XI (XI (XI (XO (XI (XO (XO
    (XI (XI (XI (XI (XI (XO (XI (XI (XI (XI (XO (XI (XI (XI (XO (XI (XO (XI
    (XI (XO (XI (XI (XO (XO (XI (XI (XI (XO (XO (XO (XI (XO (XI (XO (XO (XO
    (XO (XI (XI (XO (XO (XI (XO (XO (XO (XI (XO (XO (XI (XO (XI (XO (XO (XI
    (XI (XO (XI (XO (XO (XI (XO (XI (XO (XI (XO (XO (XI (XI (XI (XO (XO
    XH)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))

(** val ___builtin_va_arg : ident **)

let ___builtin_va_arg =
  XO (XI (XI (XI (XI (XI (XO (XI (XI (XI (XI (XI (XI (XI (XO (XI (XO (XO (XO
    (XI (XI (XI (XI (XO (XO (XI (XO (XO (XI (XO (XI (XO (XI (XO (XI (XO (XI
    (XO (XI (XI (XI (XO (XO (XI (XO (XO (XI (XO (XI (XI (XI (XO (XI (XO (XO
    (XI (XI (XI (XI (XI (XI (XI (XI (XI (XI (XO (XO (XI (XO (XI (XO (XO (XO
    (XI (XI (XI (XI (XI (XO (XI (XO (XI (XO (XO (XI (XI (XO (XI (XI (XO (XO
    (XO (XO (XO (XI (XO
    XH)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))

(** val ___builtin_va_copy : ident **)

let ___builtin_va_copy =
  XO (XI (XI (XI (XI (XI (XO (XI (XI (XI (XI (XI (XI (XI (XO (XI (XO (XO (XO
    (XI (XI (XI (XI (XO (XO (XI (XO (XO (XI (XO (XI (XO (XI (XO (XI (XO (XI
    (XO (XI (XI (XI (XO (XO (XI (XO (XO (XI (XO (XI (XI (XI (XO (XI (XO (XO
    (XI (XI (XI (XI (XI (XI (XI (XI (XI (XI (XO (XO (XI (XO (XI (XO (XO (XO
    (XI (XI (XI (XI (XI (XO (XO (XI (XI (XO (XO (XO (XO (XO (XI (XI (XO (XI
    (XO (XO (XI (XI (XO (XO (XI (XO (XO (XO (XI
    XH)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))

(** val ___builtin_va_end : ident **)

let ___builtin_va_end =
  XO (XI (XI (XI (XI (XI (XO (XI (XI (XI (XI (XI (XI (XI (XO (XI (XO (XO (XO
    (XI (XI (XI (XI (XO (XO (XI (XO (XO (XI (XO (XI (XO (XI (XO (XI (XO (XI
    (XO (XI (XI (XI (XO (XO (XI (XO (XO (XI (XO (XI (XI (XI (XO (XI (XO (XO
    (XI (XI (XI (XI (XI (XI (XI (XI (XI (XI (XO (XO (XI (XO (XI (XO (XO (XO
    (XI (XI (XI (XI (XI (XO (XI (XI (XI (XO (XO (XI (XI (XI (XO (XI (XO (XI
    (XO (XI (XI (XO (XO
    XH)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))

(** val ___builtin_va_start : ident **)

let ___builtin_va_start =
  XO (XI (XI (XI (XI (XI (XO (XI (XI (XI (XI (XI (XI (XI (XO (XI (XO (XO (XO
    (XI (XI (XI (XI (XO (XO (XI (XO (XO (XI (XO (XI (XO (XI (XO (XI (XO (XI
    (XO (XI (XI (XI (XO (XO (XI (XO (XO (XI (XO (XI (XI (XI (XO (XI (XO (XO
    (XI (XI (XI (XI (XI (XI (XI (XI (XI (XI (XO (XO (XI (XO (XI (XO (XO (XO
    (XI (XI (XI (XI (XI (XO (XO (XI (XI (XI (XO (XI (XO (XI (XI (XI (XO (XO
    (XI (XO (XI (XO (XO (XI (XI (XO (XI (XI (XO (XI (XO (XI (XI (XI (XO
    XH)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))

(** val ___builtin_write16_reversed : ident **)

let ___builtin_write16_reversed =
  XO (XI (XI (XI (XI (XI (XO (XI (XI (XI (XI (XI (XI (XI (XO (XI (XO (XO (XO
    (XI (XI (XI (XI (XO (XO (XI (XO (XO (XI (XO (XI (XO (XI (XO (XI (XO (XI
    (XO (XI (XI (XI (XO (XO (XI (XO (XO (XI (XO (XI (XI (XI (XO (XI (XO (XO
    (XI (XI (XI (XI (XI (XO (XO (XO (XO (XO (XI (XI (XI (XO (XI (XI (XO (XO
    (XI (XO (XO (XI (XO (XI (XO (XI (XI (XI (XO (XO (XI (XI (XI (XO (XO (XI
    (XO (XO (XO (XO (XO (XO (XI (XI (XO (XO (XO (XO (XI (XI (XI (XI (XI (XI
    (XI (XO (XI (XI (XO (XO (XI (XI (XI (XO (XO (XI (XI (XI (XI (XI (XO (XO
    (XI (XI (XI (XO (XO (XI (XI (XO (XI (XI (XO (XO (XO (XI (XI (XI (XO (XO
    (XI (XI (XI (XO (XO (XI (XO (XI (XI (XO (XO
    XH)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))

(** val ___builtin_write32_reversed : ident **)

let ___builtin_write32_reversed =
  XO (XI (XI (XI (XI (XI (XO (XI (XI (XI (XI (XI (XI (XI (XO (XI (XO (XO (XO
    (XI (XI (XI (XI (XO (XO (XI (XO (XO (XI (XO (XI (XO (XI (XO (XI (XO (XI
    (XO (XI (XI (XI (XO (XO (XI (XO (XO (XI (XO (XI (XI (XI (XO (XI (XO (XO
    (XI (XI (XI (XI (XI (XO (XO (XO (XO (XO (XI (XI (XI (XO (XI (XI (XO (XO
    (XI (XO (XO (XI (XO (XI (XO (XI (XI (XI (XO (XO (XI (XI (XI (XO (XO (XI
    (XI (XO (XO (XO (XO (XO (XI (XO (XO (XO (XO (XO (XI (XI (XI (XI (XI (XI
    (XI (XO (XI (XI (XO (XO (XI (XI (XI (XO (XO (XI (XI (XI (XI (XI (XO (XO
    (XI (XI (XI (XO (XO (XI (XI (XO (XI (XI (XO (XO (XO (XI (XI (XI (XO (XO
    (XI (XI (XI (XO (XO (XI (XO (XI (XI (XO (XO
    XH)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))

(** val ___compcert_i64_dtos : ident **)

let ___compcert_i64_dtos =
  XO (XI (XI (XI (XI (XI (XO (XI (XI (XI (XI (XI (XO (XO (XI (XI (XO (XO (XO
    (XO (XO (XI (XI (XO (XO (XI (XI (XO (XI (XO (XI (XO (XO (XI (XI (XO (XO
    (XO (XI (XI (XO (XO (XO (XI (XI (XI (XO (XO (XI (XI (XO (XI (XI (XO (XI
    (XO (XI (XI (XI (XO (XO (XI (XI (XI (XI (XI (XO (XI (XO (XO (XI (XO (XO
    (XI (XI (XO (XO (XO (XO (XO (XI (XO (XO (XO (XO (XI (XI (XI (XI (XI (XI
    (XO (XI (XI (XO (XO (XI (XO (XI (XI (XI (XO (XO (XO (XO (XI (XI (XO (XO
    (XO (XI (XI (XI (XO
    XH)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))

(** val ___compcert_i64_dtou : ident **)

let ___compcert_i64_dtou =
  XO (XI (XI (XI (XI (XI (XO (XI (XI (XI (XI (XI (XO (XO (XI (XI (XO (XO (XO
    (XO (XO (XI (XI (XO (XO (XI (XI (XO (XI (XO (XI (XO (XO (XI (XI (XO (XO
    (XO (XI (XI (XO (XO (XO (XI (XI (XI (XO (XO (XI (XI (XO (XI (XI (XO (XI
    (XO (XI (XI (XI (XO (XO (XI (XI (XI (XI (XI (XO (XI (XO (XO (XI (XO (XO
    (XI (XI (XO (XO (XO (XO (XO (XI (XO (XO (XO (XO (XI (XI (XI (XI (XI (XI
    (XO (XI (XI (XO (XO (XI (XO (XI (XI (XI (XO (XO (XO (XO (XI (XI (XO (XO
    (XI (XI (XI (XI (XO
    XH)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))

(** val ___compcert_i64_sar : ident **)

let ___compcert_i64_sar =
  XO (XI (XI (XI (XI (XI (XO (XI (XI (XI (XI (XI (XO (XO (XI (XI (XO (XO (XO
    (XO (XO (XI (XI (XO (XO (XI (XI (XO (XI (XO (XI (XO (XO (XI (XI (XO (XO
    (XO (XI (XI (XO (XO (XO (XI (XI (XI (XO (XO (XI (XI (XO (XI (XI (XO (XI
    (XO (XI (XI (XI (XO (XO (XI (XI (XI (XI (XI (XO (XI (XO (XO (XI (XO (XO
    (XI (XI (XO (XO (XO (XO (XO (XI (XO (XO (XO (XO (XI (XI (XI (XI (XI (XO
    (XO (XI (XI (XI (XO (XO (XI (XO (XI (XO (XO (XI (XI (XO (XI (XI (XO
    XH)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))

(** val ___compcert_i64_sdiv : ident **)

let ___compcert_i64_sdiv =
  XO (XI (XI (XI (XI (XI (XO (XI (XI (XI (XI (XI (XO (XO (XI (XI (XO (XO (XO
    (XO (XO (XI (XI (XO (XO (XI (XI (XO (XI (XO (XI (XO (XO (XI (XI (XO (XO
    (XO (XI (XI (XO (XO (XO (XI (XI (XI (XO (XO (XI (XI (XO (XI (XI (XO (XI
    (XO (XI (XI (XI (XO (XO (XI (XI (XI (XI (XI (XO (XI (XO (XO (XI (XO (XO
    (XI (XI (XO (XO (XO (XO (XO (XI (XO (XO (XO (XO (XI (XI (XI (XI (XI (XO
    (XO (XI (XI (XI (XO (XI (XO (XI (XI (XO (XO (XO (XI (XO (XO (XI (XO (XI
    (XI (XI (XI (XI (XO
    XH)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))

(** val ___compcert_i64_shl : ident **)

let ___compcert_i64_shl =
  XO (XI (XI (XI (XI (XI (XO (XI (XI (XI (XI (XI (XO (XO (XI (XI (XO (XO (XO
    (XO (XO (XI (XI (XO (XO (XI (XI (XO (XI (XO (XI (XO (XO (XI (XI (XO (XO
    (XO (XI (XI (XO (XO (XO (XI (XI (XI (XO (XO (XI (XI (XO (XI (XI (XO (XI
    (XO (XI (XI (XI (XO (XO (XI (XI (XI (XI (XI (XO (XI (XO (XO (XI (XO (XO
    (XI (XI (XO (XO (XO (XO (XO (XI (XO (XO (XO (XO (XI (XI (XI (XI (XI (XO
    (XO (XI (XI (XI (XO (XI (XO (XO (XO (XI (XO (XI (XO (XI (XO (XI (XO
    XH)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))

(** val ___compcert_i64_shr : ident **)

let ___compcert_i64_shr =
  XO (XI (XI (XI (XI (XI (XO (XI (XI (XI (XI (XI (XO (XO (XI (XI (XO (XO (XO
    (XO (XO (XI (XI (XO (XO (XI (XI (XO (XI (XO (XI (XO (XO (XI (XI (XO (XO
    (XO (XI (XI (XO (XO (XO (XI (XI (XI (XO (XO (XI (XI (XO (XI (XI (XO (XI
    (XO (XI (XI (XI (XO (XO (XI (XI (XI (XI (XI (XO (XI (XO (XO (XI (XO (XO
    (XI (XI (XO (XO (XO (XO (XO (XI (XO (XO (XO (XO (XI (XI (XI (XI (XI (XO
    (XO (XI (XI (XI (XO (XI (XO (XO (XO (XI (XO (XI (XI (XO (XI (XI (XO
    XH)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))

(** val ___compcert_i64_smod : ident **)

let ___compcert_i64_smod =
  XO (XI (XI (XI (XI (XI (XO (XI (XI (XI (XI (XI (XO (XO (XI (XI (XO (XO (XO
    (XO (XO (XI (XI (XO (XO (XI (XI (XO (XI (XO (XI (XO (XO (XI (XI (XO (XO
    (XO (XI (XI (XO (XO (XO (XI (XI (XI (XO (XO (XI (XI (XO (XI (XI (XO (XI
    (XO (XI (XI (XI (XO (XO (XI (XI (XI (XI (XI (XO (XI (XO (XO (XI (XO (XO
    (XI (XI (XO (XO (XO (XO (XO (XI (XO (XO (XO (XO (XI (XI (XI (XI (XI (XO
    (XO (XI (XI (XI (XO (XO (XI (XI (XO (XI (XO (XO (XO (XO (XI (XI (XO (XI
    (XO (XI (XI (XO (XO
    XH)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))

(** val ___compcert_i64_smulh : ident **)

let ___compcert_i64_smulh =
  XO (XI (XI (XI (XI (XI (XO (XI (XI (XI (XI (XI (XO (XO (XI (XI (XO (XO (XO
    (XO (XO (XI (XI (XO (XO (XI (XI (XO (XI (XO (XI (XO (XO (XI (XI (XO (XO
    (XO (XI (XI (XO (XO (XO (XI (XI (XI (XO (XO (XI (XI (XO (XI (XI (XO (XI
    (XO (XI (XI (XI (XO (XO (XI (XI (XI (XI (XI (XO (XI (XO (XO (XI (XO (XO
    (XI (XI (XO (XO (XO (XO (XO (XI (XO (XO (XO (XO (XI (XI (XI (XI (XI (XO
    (XO (XI (XI (XI (XO (XO (XI (XI (XO (XI (XO (XO (XI (XI (XI (XI (XO (XI
    (XO (XI (XO (XI (XO (XI (XO (XO (XO (XI (XO
    XH)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))

(** val ___compcert_i64_stod : ident **)

let ___compcert_i64_stod =
  XO (XI (XI (XI (XI (XI (XO (XI (XI (XI (XI (XI (XO (XO (XI (XI (XO (XO (XO
    (XO (XO (XI (XI (XO (XO (XI (XI (XO (XI (XO (XI (XO (XO (XI (XI (XO (XO
    (XO (XI (XI (XO (XO (XO (XI (XI (XI (XO (XO (XI (XI (XO (XI (XI (XO (XI
    (XO (XI (XI (XI (XO (XO (XI (XI (XI (XI (XI (XO (XI (XO (XO (XI (XO (XO
    (XI (XI (XO (XO (XO (XO (XO (XI (XO (XO (XO (XO (XI (XI (XI (XI (XI (XO
    (XO (XI (XI (XI (XO (XI (XO (XI (XI (XI (XO (XO (XO (XO (XI (XI (XO (XI
    (XO (XI (XI (XO (XO
    XH)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))

(** val ___compcert_i64_stof : ident **)

let ___compcert_i64_stof =
  XO (XI (XI (XI (XI (XI (XO (XI (XI (XI (XI (XI (XO (XO (XI (XI (XO (XO (XO
    (XO (XO (XI (XI (XO (XO (XI (XI (XO (XI (XO (XI (XO (XO (XI (XI (XO (XO
    (XO (XI (XI (XO (XO (XO (XI (XI (XI (XO (XO (XI (XI (XO (XI (XI (XO (XI
    (XO (XI (XI (XI (XO (XO (XI (XI (XI (XI (XI (XO (XI (XO (XO (XI (XO (XO
    (XI (XI (XO (XO (XO (XO (XO (XI (XO (XO (XO (XO (XI (XI (XI (XI (XI (XO
    (XO (XI (XI (XI (XO (XI (XO (XI (XI (XI (XO (XO (XO (XO (XI (XI (XO (XI
    (XI (XI (XI (XO (XO
    XH)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))

(** val ___compcert_i64_udiv : ident **)

let ___compcert_i64_udiv =
  XO (XI (XI (XI (XI (XI (XO (XI (XI (XI (XI (XI (XO (XO (XI (XI (XO (XO (XO
    (XO (XO (XI (XI (XO (XO (XI (XI (XO (XI (XO (XI (XO (XO (XI (XI (XO (XO
    (XO (XI (XI (XO (XO (XO (XI (XI (XI (XO (XO (XI (XI (XO (XI (XI (XO (XI
    (XO (XI (XI (XI (XO (XO (XI (XI (XI (XI (XI (XO (XI (XO (XO (XI (XO (XO
    (XI (XI (XO (XO (XO (XO (XO (XI (XO (XO (XO (XO (XI (XI (XI (XI (XI (XO
    (XI (XI (XI (XI (XO (XI (XO (XI (XI (XO (XO (XO (XI (XO (XO (XI (XO (XI
    (XI (XI (XI (XI (XO
    XH)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))

(** val ___compcert_i64_umod : ident **)

let ___compcert_i64_umod =
  XO (XI (XI (XI (XI (XI (XO (XI (XI (XI (XI (XI (XO (XO (XI (XI (XO (XO (XO
    (XO (XO (XI (XI (XO (XO (XI (XI (XO (XI (XO (XI (XO (XO (XI (XI (XO (XO
    (XO (XI (XI (XO (XO (XO (XI (XI (XI (XO (XO (XI (XI (XO (XI (XI (XO (XI
    (XO (XI (XI (XI (XO (XO (XI (XI (XI (XI (XI (XO (XI (XO (XO (XI (XO (XO
    (XI (XI (XO (XO (XO (XO (XO (XI (XO (XO (XO (XO (XI (XI (XI (XI (XI (XO
    (XI (XI (XI (XI (XO (XO (XI (XI (XO (XI (XO (XO (XO (XO (XI (XI (XO (XI
    (XO (XI (XI (XO (XO
    XH)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))

(** val ___compcert_i64_umulh : ident **)

let ___compcert_i64_umulh =
  XO (XI (XI (XI (XI (XI (XO (XI (XI (XI (XI (XI (XO (XO (XI (XI (XO (XO (XO
    (XO (XO (XI (XI (XO (XO (XI (XI (XO (XI (XO (XI (XO (XO (XI (XI (XO (XO
    (XO (XI (XI (XO (XO (XO (XI (XI (XI (XO (XO (XI (XI (XO (XI (XI (XO (XI
    (XO (XI (XI (XI (XO (XO (XI (XI (XI (XI (XI (XO (XI (XO (XO (XI (XO (XO
    (XI (XI (XO (XO (XO (XO (XO (XI (XO (XO (XO (XO (XI (XI (XI (XI (XI (XO
    (XI (XI (XI (XI (XO (XO (XI (XI (XO (XI (XO (XO (XI (XI (XI (XI (XO (XI
    (XO (XI (XO (XI (XO (XI (XO (XO (XO (XI (XO
    XH)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))

(** val ___compcert_i64_utod : ident **)

let ___compcert_i64_utod =
  XO (XI (XI (XI (XI (XI (XO (XI (XI (XI (XI (XI (XO (XO (XI (XI (XO (XO (XO
    (XO (XO (XI (XI (XO (XO (XI (XI (XO (XI (XO (XI (XO (XO (XI (XI (XO (XO
    (XO (XI (XI (XO (XO (XO (XI (XI (XI (XO (XO (XI (XI (XO (XI (XI (XO (XI
    (XO (XI (XI (XI (XO (XO (XI (XI (XI (XI (XI (XO (XI (XO (XO (XI (XO (XO
    (XI (XI (XO (XO (XO (XO (XO (XI (XO (XO (XO (XO (XI (XI (XI (XI (XI (XO
    (XI (XI (XI (XI (XO (XI (XO (XI (XI (XI (XO (XO (XO (XO (XI (XI (XO (XI
    (XO (XI (XI (XO (XO
    XH)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))

(** val ___compcert_i64_utof : ident **)

let ___compcert_i64_utof =
  XO (XI (XI (XI (XI (XI (XO (XI (XI (XI (XI (XI (XO (XO (XI (XI (XO (XO (XO
    (XO (XO (XI (XI (XO (XO (XI (XI (XO (XI (XO (XI (XO (XO (XI (XI (XO (XO
    (XO (XI (XI (XO (XO (XO (XI (XI (XI (XO (XO (XI (XI (XO (XI (XI (XO (XI
    (XO (XI (XI (XI (XO (XO (XI (XI (XI (XI (XI (XO (XI (XO (XO (XI (XO (XO
    (XI (XI (XO (XO (XO (XO (XO (XI (XO (XO (XO (XO (XI (XI (XI (XI (XI (XO
    (XI (XI (XI (XI (XO (XI (XO (XI (XI (XI (XO (XO (XO (XO (XI (XI (XO (XI
    (XI (XI (XI (XO (XO
    XH)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))

(** val ___compcert_va_composite : ident **)

let ___compcert_va_composite =
  XO (XI (XI (XI (XI (XI (XO (XI (XI (XI (XI (XI (XO (XO (XI (XI (XO (XO (XO
    (XO (XO (XI (XI (XO (XO (XI (XI (XO (XI (XO (XI (XO (XO (XI (XI (XO (XO
    (XO (XI (XI (XO (XO (XO (XI (XI (XI (XO (XO (XI (XI (XO (XI (XI (XO (XI
    (XO (XI (XI (XI (XO (XO (XI (XI (XI (XI (XI (XI (XI (XI (XI (XI (XO (XO
    (XI (XO (XI (XO (XO (XO (XI (XI (XI (XI (XI (XO (XO (XI (XI (XO (XO (XO
    (XO (XO (XI (XI (XO (XO (XI (XI (XO (XI (XO (XI (XO (XO (XI (XI (XO (XO
    (XO (XO (XI (XI (XO (XO (XO (XI (XI (XI (XO (XO (XI (XO (XO (XI (XO (XI
    (XO (XI (XI (XI (XO (XO (XI (XI (XI (XO (XO
    XH)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))

(** val ___compcert_va_float64 : ident **)

let ___compcert_va_float64 =
  XO (XI (XI (XI (XI (XI (XO (XI (XI (XI (XI (XI (XO (XO (XI (XI (XO (XO (XO
    (XO (XO (XI (XI (XO (XO (XI (XI (XO (XI (XO (XI (XO (XO (XI (XI (XO (XO
    (XO (XI (XI (XO (XO (XO (XI (XI (XI (XO (XO (XI (XI (XO (XI (XI (XO (XI
    (XO (XI (XI (XI (XO (XO (XI (XI (XI (XI (XI (XI (XI (XI (XI (XI (XO (XO
    (XI (XO (XI (XO (XO (XO (XI (XI (XI (XI (XI (XI (XI (XI (XI (XO (XO (XI
    (XO (XI (XO (XI (XO (XO (XO (XO (XI (XI (XO (XO (XI (XO (XI (XO (XO (XI
    (XO (XI (XI (XI (XO (XO (XI (XI (XO (XO (XO (XO (XO (XI (XO (XO (XO
    XH)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))

(** val ___compcert_va_int32 : ident **)

let ___compcert_va_int32 =
  XO (XI (XI (XI (XI (XI (XO (XI (XI (XI (XI (XI (XO (XO (XI (XI (XO (XO (XO
    (XO (XO (XI (XI (XO (XO (XI (XI (XO (XI (XO (XI (XO (XO (XI (XI (XO (XO
    (XO (XI (XI (XO (XO (XO (XI (XI (XI (XO (XO (XI (XI (XO (XI (XI (XO (XI
    (XO (XI (XI (XI (XO (XO (XI (XI (XI (XI (XI (XI (XI (XI (XI (XI (XO (XO
    (XI (XO (XI (XO (XO (XO (XI (XI (XI (XI (XI (XO (XI (XO (XO (XI (XO (XI
    (XI (XI (XO (XI (XO (XI (XO (XI (XI (XI (XO (XI (XI (XO (XO (XO (XO (XO
    (XI (XO (XO (XO (XO
    XH)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))

(** val ___compcert_va_int64 : ident **)

let ___compcert_va_int64 =
  XO (XI (XI (XI (XI (XI (XO (XI (XI (XI (XI (XI (XO (XO (XI (XI (XO (XO (XO
    (XO (XO (XI (XI (XO (XO (XI (XI (XO (XI (XO (XI (XO (XO (XI (XI (XO (XO
    (XO (XI (XI (XO (XO (XO (XI (XI (XI (XO (XO (XI (XI (XO (XI (XI (XO (XI
    (XO (XI (XI (XI (XO (XO (XI (XI (XI (XI (XI (XI (XI (XI (XI (XI (XO (XO
    (XI (XO (XI (XO (XO (XO (XI (XI (XI (XI (XI (XO (XI (XO (XO (XI (XO (XI
    (XI (XI (XO (XI (XO (XI (XO (XI (XI (XI (XO (XO (XI (XI (XO (XO (XO (XO
    (XO (XI (XO (XO (XO
    XH)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))

(** val _a : ident **)

let _a =
  XO (XI (XO (XI (XO (XO XH)))))

(** val _b : ident **)

let _b =
  XI (XI (XO (XI (XO (XO XH)))))

(** val _c : ident **)

let _c =
  XO (XO (XI (XI (XO (XO XH)))))

(** val _main : ident **)

let _main =
  XO (XI (XI (XO (XI (XO (XO (XI (XO (XI (XO (XO (XO (XI (XO (XO (XI (XO (XI
    (XI (XI (XO (XI (XO XH)))))))))))))))))))))))

(** val _sum3 : ident **)

let _sum3 =
  XO (XO (XI (XI (XI (XO (XO (XI (XI (XI (XI (XO (XO (XI (XI (XO (XI (XO (XI
    (XI (XO (XO (XO (XO XH)))))))))))))))))))))))

(** val f_sum3 : function0 **)

let f_sum3 =
  { fn_return = tfloat; fn_callconv = cc_default; fn_params = ((_a,
    tfloat) :: ((_b, tfloat) :: ((_c, tfloat) :: []))); fn_vars = [];
    fn_body = (Sreturn (Some (Ebinop (Oadd, (Ebinop (Oadd, (Evalof ((Evar
    (_a, tfloat)), tfloat)), (Evalof ((Evar (_b, tfloat)), tfloat)),
    tfloat)), (Evalof ((Evar (_c, tfloat)), tfloat)), tfloat)))) }

(** val composites : composite_definition list **)

let composites =
  []

(** val global_definitions : (ident * (fundef0, type0) globdef) list **)

let global_definitions =
  (___compcert_va_int32, (Gfun (External ((EF_runtime
    (('_'::('_'::('c'::('o'::('m'::('p'::('c'::('e'::('r'::('t'::('_'::('v'::('a'::('_'::('i'::('n'::('t'::('3'::('2'::[]))))))))))))))))))),
    { sig_args = (Xptr :: []); sig_res = Xint; sig_cc = cc_default })),
    ((tptr0 tvoid) :: []), tuint, cc_default)))) :: ((___compcert_va_int64,
    (Gfun (External ((EF_runtime
    (('_'::('_'::('c'::('o'::('m'::('p'::('c'::('e'::('r'::('t'::('_'::('v'::('a'::('_'::('i'::('n'::('t'::('6'::('4'::[]))))))))))))))))))),
    { sig_args = (Xptr :: []); sig_res = Xlong; sig_cc = cc_default })),
    ((tptr0 tvoid) :: []), tulong,
    cc_default)))) :: ((___compcert_va_float64, (Gfun (External ((EF_runtime
    (('_'::('_'::('c'::('o'::('m'::('p'::('c'::('e'::('r'::('t'::('_'::('v'::('a'::('_'::('f'::('l'::('o'::('a'::('t'::('6'::('4'::[]))))))))))))))))))))),
    { sig_args = (Xptr :: []); sig_res = Xfloat; sig_cc = cc_default })),
    ((tptr0 tvoid) :: []), tdouble,
    cc_default)))) :: ((___compcert_va_composite, (Gfun (External
    ((EF_runtime
    (('_'::('_'::('c'::('o'::('m'::('p'::('c'::('e'::('r'::('t'::('_'::('v'::('a'::('_'::('c'::('o'::('m'::('p'::('o'::('s'::('i'::('t'::('e'::[]))))))))))))))))))))))),
    { sig_args = (Xptr :: (Xlong :: [])); sig_res = Xptr; sig_cc =
    cc_default })), ((tptr0 tvoid) :: (tulong :: [])), (tptr0 tvoid),
    cc_default)))) :: ((___compcert_i64_dtos, (Gfun (External ((EF_runtime
    (('_'::('_'::('c'::('o'::('m'::('p'::('c'::('e'::('r'::('t'::('_'::('i'::('6'::('4'::('_'::('d'::('t'::('o'::('s'::[]))))))))))))))))))),
    { sig_args = (Xfloat :: []); sig_res = Xlong; sig_cc = cc_default })),
    (tdouble :: []), tlong, cc_default)))) :: ((___compcert_i64_dtou, (Gfun
    (External ((EF_runtime
    (('_'::('_'::('c'::('o'::('m'::('p'::('c'::('e'::('r'::('t'::('_'::('i'::('6'::('4'::('_'::('d'::('t'::('o'::('u'::[]))))))))))))))))))),
    { sig_args = (Xfloat :: []); sig_res = Xlong; sig_cc = cc_default })),
    (tdouble :: []), tulong, cc_default)))) :: ((___compcert_i64_stod, (Gfun
    (External ((EF_runtime
    (('_'::('_'::('c'::('o'::('m'::('p'::('c'::('e'::('r'::('t'::('_'::('i'::('6'::('4'::('_'::('s'::('t'::('o'::('d'::[]))))))))))))))))))),
    { sig_args = (Xlong :: []); sig_res = Xfloat; sig_cc = cc_default })),
    (tlong :: []), tdouble, cc_default)))) :: ((___compcert_i64_utod, (Gfun
    (External ((EF_runtime
    (('_'::('_'::('c'::('o'::('m'::('p'::('c'::('e'::('r'::('t'::('_'::('i'::('6'::('4'::('_'::('u'::('t'::('o'::('d'::[]))))))))))))))))))),
    { sig_args = (Xlong :: []); sig_res = Xfloat; sig_cc = cc_default })),
    (tulong :: []), tdouble, cc_default)))) :: ((___compcert_i64_stof, (Gfun
    (External ((EF_runtime
    (('_'::('_'::('c'::('o'::('m'::('p'::('c'::('e'::('r'::('t'::('_'::('i'::('6'::('4'::('_'::('s'::('t'::('o'::('f'::[]))))))))))))))))))),
    { sig_args = (Xlong :: []); sig_res = Xsingle; sig_cc = cc_default })),
    (tlong :: []), tfloat, cc_default)))) :: ((___compcert_i64_utof, (Gfun
    (External ((EF_runtime
    (('_'::('_'::('c'::('o'::('m'::('p'::('c'::('e'::('r'::('t'::('_'::('i'::('6'::('4'::('_'::('u'::('t'::('o'::('f'::[]))))))))))))))))))),
    { sig_args = (Xlong :: []); sig_res = Xsingle; sig_cc = cc_default })),
    (tulong :: []), tfloat, cc_default)))) :: ((___compcert_i64_sdiv, (Gfun
    (External ((EF_runtime
    (('_'::('_'::('c'::('o'::('m'::('p'::('c'::('e'::('r'::('t'::('_'::('i'::('6'::('4'::('_'::('s'::('d'::('i'::('v'::[]))))))))))))))))))),
    { sig_args = (Xlong :: (Xlong :: [])); sig_res = Xlong; sig_cc =
    cc_default })), (tlong :: (tlong :: [])), tlong,
    cc_default)))) :: ((___compcert_i64_udiv, (Gfun (External ((EF_runtime
    (('_'::('_'::('c'::('o'::('m'::('p'::('c'::('e'::('r'::('t'::('_'::('i'::('6'::('4'::('_'::('u'::('d'::('i'::('v'::[]))))))))))))))))))),
    { sig_args = (Xlong :: (Xlong :: [])); sig_res = Xlong; sig_cc =
    cc_default })), (tulong :: (tulong :: [])), tulong,
    cc_default)))) :: ((___compcert_i64_smod, (Gfun (External ((EF_runtime
    (('_'::('_'::('c'::('o'::('m'::('p'::('c'::('e'::('r'::('t'::('_'::('i'::('6'::('4'::('_'::('s'::('m'::('o'::('d'::[]))))))))))))))))))),
    { sig_args = (Xlong :: (Xlong :: [])); sig_res = Xlong; sig_cc =
    cc_default })), (tlong :: (tlong :: [])), tlong,
    cc_default)))) :: ((___compcert_i64_umod, (Gfun (External ((EF_runtime
    (('_'::('_'::('c'::('o'::('m'::('p'::('c'::('e'::('r'::('t'::('_'::('i'::('6'::('4'::('_'::('u'::('m'::('o'::('d'::[]))))))))))))))))))),
    { sig_args = (Xlong :: (Xlong :: [])); sig_res = Xlong; sig_cc =
    cc_default })), (tulong :: (tulong :: [])), tulong,
    cc_default)))) :: ((___compcert_i64_shl, (Gfun (External ((EF_runtime
    (('_'::('_'::('c'::('o'::('m'::('p'::('c'::('e'::('r'::('t'::('_'::('i'::('6'::('4'::('_'::('s'::('h'::('l'::[])))))))))))))))))),
    { sig_args = (Xlong :: (Xint :: [])); sig_res = Xlong; sig_cc =
    cc_default })), (tlong :: (tint :: [])), tlong,
    cc_default)))) :: ((___compcert_i64_shr, (Gfun (External ((EF_runtime
    (('_'::('_'::('c'::('o'::('m'::('p'::('c'::('e'::('r'::('t'::('_'::('i'::('6'::('4'::('_'::('s'::('h'::('r'::[])))))))))))))))))),
    { sig_args = (Xlong :: (Xint :: [])); sig_res = Xlong; sig_cc =
    cc_default })), (tulong :: (tint :: [])), tulong,
    cc_default)))) :: ((___compcert_i64_sar, (Gfun (External ((EF_runtime
    (('_'::('_'::('c'::('o'::('m'::('p'::('c'::('e'::('r'::('t'::('_'::('i'::('6'::('4'::('_'::('s'::('a'::('r'::[])))))))))))))))))),
    { sig_args = (Xlong :: (Xint :: [])); sig_res = Xlong; sig_cc =
    cc_default })), (tlong :: (tint :: [])), tlong,
    cc_default)))) :: ((___compcert_i64_smulh, (Gfun (External ((EF_runtime
    (('_'::('_'::('c'::('o'::('m'::('p'::('c'::('e'::('r'::('t'::('_'::('i'::('6'::('4'::('_'::('s'::('m'::('u'::('l'::('h'::[])))))))))))))))))))),
    { sig_args = (Xlong :: (Xlong :: [])); sig_res = Xlong; sig_cc =
    cc_default })), (tlong :: (tlong :: [])), tlong,
    cc_default)))) :: ((___compcert_i64_umulh, (Gfun (External ((EF_runtime
    (('_'::('_'::('c'::('o'::('m'::('p'::('c'::('e'::('r'::('t'::('_'::('i'::('6'::('4'::('_'::('u'::('m'::('u'::('l'::('h'::[])))))))))))))))))))),
    { sig_args = (Xlong :: (Xlong :: [])); sig_res = Xlong; sig_cc =
    cc_default })), (tulong :: (tulong :: [])), tulong,
    cc_default)))) :: ((___builtin_ais_annot, (Gfun (External ((EF_builtin
    (('_'::('_'::('b'::('u'::('i'::('l'::('t'::('i'::('n'::('_'::('a'::('i'::('s'::('_'::('a'::('n'::('n'::('o'::('t'::[]))))))))))))))))))),
    { sig_args = (Xptr :: []); sig_res = Xvoid; sig_cc = { cc_vararg = (Some
    (Zpos XH)); cc_unproto = false; cc_structret = false } })),
    ((tptr0 tschar) :: []), tvoid, { cc_vararg = (Some (Zpos XH));
    cc_unproto = false; cc_structret = false })))) :: ((___builtin_bswap64,
    (Gfun (External ((EF_builtin
    (('_'::('_'::('b'::('u'::('i'::('l'::('t'::('i'::('n'::('_'::('b'::('s'::('w'::('a'::('p'::('6'::('4'::[]))))))))))))))))),
    { sig_args = (Xlong :: []); sig_res = Xlong; sig_cc = cc_default })),
    (tulong :: []), tulong, cc_default)))) :: ((___builtin_bswap, (Gfun
    (External ((EF_builtin
    (('_'::('_'::('b'::('u'::('i'::('l'::('t'::('i'::('n'::('_'::('b'::('s'::('w'::('a'::('p'::[]))))))))))))))),
    { sig_args = (Xint :: []); sig_res = Xint; sig_cc = cc_default })),
    (tuint :: []), tuint, cc_default)))) :: ((___builtin_bswap32, (Gfun
    (External ((EF_builtin
    (('_'::('_'::('b'::('u'::('i'::('l'::('t'::('i'::('n'::('_'::('b'::('s'::('w'::('a'::('p'::('3'::('2'::[]))))))))))))))))),
    { sig_args = (Xint :: []); sig_res = Xint; sig_cc = cc_default })),
    (tuint :: []), tuint, cc_default)))) :: ((___builtin_bswap16, (Gfun
    (External ((EF_builtin
    (('_'::('_'::('b'::('u'::('i'::('l'::('t'::('i'::('n'::('_'::('b'::('s'::('w'::('a'::('p'::('1'::('6'::[]))))))))))))))))),
    { sig_args = (Xint16unsigned :: []); sig_res = Xint16unsigned; sig_cc =
    cc_default })), (tushort :: []), tushort,
    cc_default)))) :: ((___builtin_clz, (Gfun (External ((EF_builtin
    (('_'::('_'::('b'::('u'::('i'::('l'::('t'::('i'::('n'::('_'::('c'::('l'::('z'::[]))))))))))))),
    { sig_args = (Xint :: []); sig_res = Xint; sig_cc = cc_default })),
    (tuint :: []), tint, cc_default)))) :: ((___builtin_clzl, (Gfun (External
    ((EF_builtin
    (('_'::('_'::('b'::('u'::('i'::('l'::('t'::('i'::('n'::('_'::('c'::('l'::('z'::('l'::[])))))))))))))),
    { sig_args = (Xlong :: []); sig_res = Xint; sig_cc = cc_default })),
    (tulong :: []), tint, cc_default)))) :: ((___builtin_clzll, (Gfun
    (External ((EF_builtin
    (('_'::('_'::('b'::('u'::('i'::('l'::('t'::('i'::('n'::('_'::('c'::('l'::('z'::('l'::('l'::[]))))))))))))))),
    { sig_args = (Xlong :: []); sig_res = Xint; sig_cc = cc_default })),
    (tulong :: []), tint, cc_default)))) :: ((___builtin_ctz, (Gfun (External
    ((EF_builtin
    (('_'::('_'::('b'::('u'::('i'::('l'::('t'::('i'::('n'::('_'::('c'::('t'::('z'::[]))))))))))))),
    { sig_args = (Xint :: []); sig_res = Xint; sig_cc = cc_default })),
    (tuint :: []), tint, cc_default)))) :: ((___builtin_ctzl, (Gfun (External
    ((EF_builtin
    (('_'::('_'::('b'::('u'::('i'::('l'::('t'::('i'::('n'::('_'::('c'::('t'::('z'::('l'::[])))))))))))))),
    { sig_args = (Xlong :: []); sig_res = Xint; sig_cc = cc_default })),
    (tulong :: []), tint, cc_default)))) :: ((___builtin_ctzll, (Gfun
    (External ((EF_builtin
    (('_'::('_'::('b'::('u'::('i'::('l'::('t'::('i'::('n'::('_'::('c'::('t'::('z'::('l'::('l'::[]))))))))))))))),
    { sig_args = (Xlong :: []); sig_res = Xint; sig_cc = cc_default })),
    (tulong :: []), tint, cc_default)))) :: ((___builtin_fabs, (Gfun
    (External ((EF_builtin
    (('_'::('_'::('b'::('u'::('i'::('l'::('t'::('i'::('n'::('_'::('f'::('a'::('b'::('s'::[])))))))))))))),
    { sig_args = (Xfloat :: []); sig_res = Xfloat; sig_cc = cc_default })),
    (tdouble :: []), tdouble, cc_default)))) :: ((___builtin_fabsf, (Gfun
    (External ((EF_builtin
    (('_'::('_'::('b'::('u'::('i'::('l'::('t'::('i'::('n'::('_'::('f'::('a'::('b'::('s'::('f'::[]))))))))))))))),
    { sig_args = (Xsingle :: []); sig_res = Xsingle; sig_cc = cc_default })),
    (tfloat :: []), tfloat, cc_default)))) :: ((___builtin_fsqrt, (Gfun
    (External ((EF_builtin
    (('_'::('_'::('b'::('u'::('i'::('l'::('t'::('i'::('n'::('_'::('f'::('s'::('q'::('r'::('t'::[]))))))))))))))),
    { sig_args = (Xfloat :: []); sig_res = Xfloat; sig_cc = cc_default })),
    (tdouble :: []), tdouble, cc_default)))) :: ((___builtin_sqrt, (Gfun
    (External ((EF_builtin
    (('_'::('_'::('b'::('u'::('i'::('l'::('t'::('i'::('n'::('_'::('s'::('q'::('r'::('t'::[])))))))))))))),
    { sig_args = (Xfloat :: []); sig_res = Xfloat; sig_cc = cc_default })),
    (tdouble :: []), tdouble, cc_default)))) :: ((___builtin_memcpy_aligned,
    (Gfun (External ((EF_builtin
    (('_'::('_'::('b'::('u'::('i'::('l'::('t'::('i'::('n'::('_'::('m'::('e'::('m'::('c'::('p'::('y'::('_'::('a'::('l'::('i'::('g'::('n'::('e'::('d'::[])))))))))))))))))))))))),
    { sig_args = (Xptr :: (Xptr :: (Xlong :: (Xlong :: [])))); sig_res =
    Xvoid; sig_cc = cc_default })),
    ((tptr0 tvoid) :: ((tptr0 tvoid) :: (tulong :: (tulong :: [])))), tvoid,
    cc_default)))) :: ((___builtin_sel, (Gfun (External ((EF_builtin
    (('_'::('_'::('b'::('u'::('i'::('l'::('t'::('i'::('n'::('_'::('s'::('e'::('l'::[]))))))))))))),
    { sig_args = (Xbool :: []); sig_res = Xvoid; sig_cc = { cc_vararg = (Some
    (Zpos XH)); cc_unproto = false; cc_structret = false } })),
    (tbool :: []), tvoid, { cc_vararg = (Some (Zpos XH)); cc_unproto = false;
    cc_structret = false })))) :: ((___builtin_annot, (Gfun (External
    ((EF_builtin
    (('_'::('_'::('b'::('u'::('i'::('l'::('t'::('i'::('n'::('_'::('a'::('n'::('n'::('o'::('t'::[]))))))))))))))),
    { sig_args = (Xptr :: []); sig_res = Xvoid; sig_cc = { cc_vararg = (Some
    (Zpos XH)); cc_unproto = false; cc_structret = false } })),
    ((tptr0 tschar) :: []), tvoid, { cc_vararg = (Some (Zpos XH));
    cc_unproto = false; cc_structret =
    false })))) :: ((___builtin_annot_intval, (Gfun (External ((EF_builtin
    (('_'::('_'::('b'::('u'::('i'::('l'::('t'::('i'::('n'::('_'::('a'::('n'::('n'::('o'::('t'::('_'::('i'::('n'::('t'::('v'::('a'::('l'::[])))))))))))))))))))))),
    { sig_args = (Xptr :: (Xint :: [])); sig_res = Xint; sig_cc =
    cc_default })), ((tptr0 tschar) :: (tint :: [])), tint,
    cc_default)))) :: ((___builtin_membar, (Gfun (External ((EF_builtin
    (('_'::('_'::('b'::('u'::('i'::('l'::('t'::('i'::('n'::('_'::('m'::('e'::('m'::('b'::('a'::('r'::[])))))))))))))))),
    { sig_args = []; sig_res = Xvoid; sig_cc = cc_default })), [], tvoid,
    cc_default)))) :: ((___builtin_va_start, (Gfun (External ((EF_builtin
    (('_'::('_'::('b'::('u'::('i'::('l'::('t'::('i'::('n'::('_'::('v'::('a'::('_'::('s'::('t'::('a'::('r'::('t'::[])))))))))))))))))),
    { sig_args = (Xptr :: []); sig_res = Xvoid; sig_cc = cc_default })),
    ((tptr0 tvoid) :: []), tvoid, cc_default)))) :: ((___builtin_va_arg,
    (Gfun (External ((EF_builtin
    (('_'::('_'::('b'::('u'::('i'::('l'::('t'::('i'::('n'::('_'::('v'::('a'::('_'::('a'::('r'::('g'::[])))))))))))))))),
    { sig_args = (Xptr :: (Xint :: [])); sig_res = Xvoid; sig_cc =
    cc_default })), ((tptr0 tvoid) :: (tuint :: [])), tvoid,
    cc_default)))) :: ((___builtin_va_copy, (Gfun (External ((EF_builtin
    (('_'::('_'::('b'::('u'::('i'::('l'::('t'::('i'::('n'::('_'::('v'::('a'::('_'::('c'::('o'::('p'::('y'::[]))))))))))))))))),
    { sig_args = (Xptr :: (Xptr :: [])); sig_res = Xvoid; sig_cc =
    cc_default })), ((tptr0 tvoid) :: ((tptr0 tvoid) :: [])), tvoid,
    cc_default)))) :: ((___builtin_va_end, (Gfun (External ((EF_builtin
    (('_'::('_'::('b'::('u'::('i'::('l'::('t'::('i'::('n'::('_'::('v'::('a'::('_'::('e'::('n'::('d'::[])))))))))))))))),
    { sig_args = (Xptr :: []); sig_res = Xvoid; sig_cc = cc_default })),
    ((tptr0 tvoid) :: []), tvoid, cc_default)))) :: ((___builtin_unreachable,
    (Gfun (External ((EF_builtin
    (('_'::('_'::('b'::('u'::('i'::('l'::('t'::('i'::('n'::('_'::('u'::('n'::('r'::('e'::('a'::('c'::('h'::('a'::('b'::('l'::('e'::[]))))))))))))))))))))),
    { sig_args = []; sig_res = Xvoid; sig_cc = cc_default })), [], tvoid,
    cc_default)))) :: ((___builtin_expect, (Gfun (External ((EF_builtin
    (('_'::('_'::('b'::('u'::('i'::('l'::('t'::('i'::('n'::('_'::('e'::('x'::('p'::('e'::('c'::('t'::[])))))))))))))))),
    { sig_args = (Xlong :: (Xlong :: [])); sig_res = Xlong; sig_cc =
    cc_default })), (tlong :: (tlong :: [])), tlong,
    cc_default)))) :: ((___builtin_fmax, (Gfun (External ((EF_builtin
    (('_'::('_'::('b'::('u'::('i'::('l'::('t'::('i'::('n'::('_'::('f'::('m'::('a'::('x'::[])))))))))))))),
    { sig_args = (Xfloat :: (Xfloat :: [])); sig_res = Xfloat; sig_cc =
    cc_default })), (tdouble :: (tdouble :: [])), tdouble,
    cc_default)))) :: ((___builtin_fmin, (Gfun (External ((EF_builtin
    (('_'::('_'::('b'::('u'::('i'::('l'::('t'::('i'::('n'::('_'::('f'::('m'::('i'::('n'::[])))))))))))))),
    { sig_args = (Xfloat :: (Xfloat :: [])); sig_res = Xfloat; sig_cc =
    cc_default })), (tdouble :: (tdouble :: [])), tdouble,
    cc_default)))) :: ((___builtin_fmadd, (Gfun (External ((EF_builtin
    (('_'::('_'::('b'::('u'::('i'::('l'::('t'::('i'::('n'::('_'::('f'::('m'::('a'::('d'::('d'::[]))))))))))))))),
    { sig_args = (Xfloat :: (Xfloat :: (Xfloat :: []))); sig_res = Xfloat;
    sig_cc = cc_default })), (tdouble :: (tdouble :: (tdouble :: []))),
    tdouble, cc_default)))) :: ((___builtin_fmsub, (Gfun (External
    ((EF_builtin
    (('_'::('_'::('b'::('u'::('i'::('l'::('t'::('i'::('n'::('_'::('f'::('m'::('s'::('u'::('b'::[]))))))))))))))),
    { sig_args = (Xfloat :: (Xfloat :: (Xfloat :: []))); sig_res = Xfloat;
    sig_cc = cc_default })), (tdouble :: (tdouble :: (tdouble :: []))),
    tdouble, cc_default)))) :: ((___builtin_fnmadd, (Gfun (External
    ((EF_builtin
    (('_'::('_'::('b'::('u'::('i'::('l'::('t'::('i'::('n'::('_'::('f'::('n'::('m'::('a'::('d'::('d'::[])))))))))))))))),
    { sig_args = (Xfloat :: (Xfloat :: (Xfloat :: []))); sig_res = Xfloat;
    sig_cc = cc_default })), (tdouble :: (tdouble :: (tdouble :: []))),
    tdouble, cc_default)))) :: ((___builtin_fnmsub, (Gfun (External
    ((EF_builtin
    (('_'::('_'::('b'::('u'::('i'::('l'::('t'::('i'::('n'::('_'::('f'::('n'::('m'::('s'::('u'::('b'::[])))))))))))))))),
    { sig_args = (Xfloat :: (Xfloat :: (Xfloat :: []))); sig_res = Xfloat;
    sig_cc = cc_default })), (tdouble :: (tdouble :: (tdouble :: []))),
    tdouble, cc_default)))) :: ((___builtin_read16_reversed, (Gfun (External
    ((EF_builtin
    (('_'::('_'::('b'::('u'::('i'::('l'::('t'::('i'::('n'::('_'::('r'::('e'::('a'::('d'::('1'::('6'::('_'::('r'::('e'::('v'::('e'::('r'::('s'::('e'::('d'::[]))))))))))))))))))))))))),
    { sig_args = (Xptr :: []); sig_res = Xint16unsigned; sig_cc =
    cc_default })), ((tptr0 tushort) :: []), tushort,
    cc_default)))) :: ((___builtin_read32_reversed, (Gfun (External
    ((EF_builtin
    (('_'::('_'::('b'::('u'::('i'::('l'::('t'::('i'::('n'::('_'::('r'::('e'::('a'::('d'::('3'::('2'::('_'::('r'::('e'::('v'::('e'::('r'::('s'::('e'::('d'::[]))))))))))))))))))))))))),
    { sig_args = (Xptr :: []); sig_res = Xint; sig_cc = cc_default })),
    ((tptr0 tuint) :: []), tuint,
    cc_default)))) :: ((___builtin_write16_reversed, (Gfun (External
    ((EF_builtin
    (('_'::('_'::('b'::('u'::('i'::('l'::('t'::('i'::('n'::('_'::('w'::('r'::('i'::('t'::('e'::('1'::('6'::('_'::('r'::('e'::('v'::('e'::('r'::('s'::('e'::('d'::[])))))))))))))))))))))))))),
    { sig_args = (Xptr :: (Xint16unsigned :: [])); sig_res = Xvoid; sig_cc =
    cc_default })), ((tptr0 tushort) :: (tushort :: [])), tvoid,
    cc_default)))) :: ((___builtin_write32_reversed, (Gfun (External
    ((EF_builtin
    (('_'::('_'::('b'::('u'::('i'::('l'::('t'::('i'::('n'::('_'::('w'::('r'::('i'::('t'::('e'::('3'::('2'::('_'::('r'::('e'::('v'::('e'::('r'::('s'::('e'::('d'::[])))))))))))))))))))))))))),
    { sig_args = (Xptr :: (Xint :: [])); sig_res = Xvoid; sig_cc =
    cc_default })), ((tptr0 tuint) :: (tuint :: [])), tvoid,
    cc_default)))) :: ((___builtin_debug, (Gfun (External ((EF_external
    (('_'::('_'::('b'::('u'::('i'::('l'::('t'::('i'::('n'::('_'::('d'::('e'::('b'::('u'::('g'::[]))))))))))))))),
    { sig_args = (Xint :: []); sig_res = Xvoid; sig_cc = { cc_vararg = (Some
    (Zpos XH)); cc_unproto = false; cc_structret = false } })), (tint :: []),
    tvoid, { cc_vararg = (Some (Zpos XH)); cc_unproto = false; cc_structret =
    false })))) :: ((_sum3, (Gfun (Internal
    f_sum3))) :: []))))))))))))))))))))))))))))))))))))))))))))))))))))))))

(** val public_idents : ident list **)

let public_idents =
  _sum3 :: (___builtin_debug :: (___builtin_write32_reversed :: (___builtin_write16_reversed :: (___builtin_read32_reversed :: (___builtin_read16_reversed :: (___builtin_fnmsub :: (___builtin_fnmadd :: (___builtin_fmsub :: (___builtin_fmadd :: (___builtin_fmin :: (___builtin_fmax :: (___builtin_expect :: (___builtin_unreachable :: (___builtin_va_end :: (___builtin_va_copy :: (___builtin_va_arg :: (___builtin_va_start :: (___builtin_membar :: (___builtin_annot_intval :: (___builtin_annot :: (___builtin_sel :: (___builtin_memcpy_aligned :: (___builtin_sqrt :: (___builtin_fsqrt :: (___builtin_fabsf :: (___builtin_fabs :: (___builtin_ctzll :: (___builtin_ctzl :: (___builtin_ctz :: (___builtin_clzll :: (___builtin_clzl :: (___builtin_clz :: (___builtin_bswap16 :: (___builtin_bswap32 :: (___builtin_bswap :: (___builtin_bswap64 :: (___builtin_ais_annot :: (___compcert_i64_umulh :: (___compcert_i64_smulh :: (___compcert_i64_sar :: (___compcert_i64_shr :: (___compcert_i64_shl :: (___compcert_i64_umod :: (___compcert_i64_smod :: (___compcert_i64_udiv :: (___compcert_i64_sdiv :: (___compcert_i64_utof :: (___compcert_i64_stof :: (___compcert_i64_utod :: (___compcert_i64_stod :: (___compcert_i64_dtou :: (___compcert_i64_dtos :: (___compcert_va_composite :: (___compcert_va_float64 :: (___compcert_va_int64 :: (___compcert_va_int32 :: []))))))))))))))))))))))))))))))))))))))))))))))))))))))))

(** val prog : program1 **)

let prog =
  mkprogram composites global_definitions public_idents _main

(** val ge : genv **)

let ge =
  globalenv0 prog

(** val entry : val0 list -> Mem.mem -> state **)

let entry args m =
  Callstate ((Internal f_sum3), args, Kstop, m)

type callback =
  char list -> signature -> Senv.t -> world -> val0 list -> Mem.mem ->
  (((world * trace) * val0) * Mem.mem) option

(** val transitions :
    callback -> callback -> world -> state -> transition list **)

let transitions cb asm w s =
  do_step ge cb asm w s

(** val no_external : callback **)

let no_external _ _ _ _ _ _ =
  None

(** val quiet_world : world **)

let quiet_world =
  lazy (World ((fun _ _ -> None), (fun _ _ _ -> None), (fun _ _ _ _ -> None)))

(** val closed_transitions : state -> transition list **)

let closed_transitions =
  transitions no_external no_external quiet_world
