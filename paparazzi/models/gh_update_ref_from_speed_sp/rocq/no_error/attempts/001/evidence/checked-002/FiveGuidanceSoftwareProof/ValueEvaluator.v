From Stdlib Require Import Bool List ZArith.
From compcert Require Import Coqlib Errors Maps Integers Floats AST Values Memory Memdata Ctypes Cop Csyntax Csyntaxdefs Csem.
Import ListNotations.
Record local_place := Place {place_id:ident;place_container:type;place_type:type;place_union:bool}.
Section QUOTE.
Variables union_id float_field uint_field:ident.
Variable gamma:PTree.t type.
Definition place_of(a:expr):option local_place :=
 match a with
 | Evar id ty=>match gamma!id with Some actual=>if type_eq actual ty then Some(Place id actual ty false)else None|None=>None end
 | Efield(Evalof(Evar id container)base)field ty=>
   if type_eq container(Tunion union_id noattr)then
   if type_eq base container then
   match gamma!id with Some actual=>if type_eq actual container then
     if peq field float_field then if type_eq ty tfloat then Some(Place id container tfloat true)else None
     else if peq field uint_field then if type_eq ty tuint then Some(Place id container tuint true)else None
     else None
   else None|None=>None end else None else None
 | _=>None end.
Definition read_place(rho:PTree.t val)(p:local_place):option val:=
 match rho!(place_id p)with
 |Some v=>if place_union p then
   if type_eq(place_type p)tfloat then match v with Vint bits=>Some(Vsingle(Float32.of_bits bits))|_=>None end
   else Some v else Some v
 |None=>None end.
Definition canonical_value(p:local_place)(v:val):option val:=
 if place_union p then
 if type_eq(place_type p)tfloat then match v with Vsingle x=>Some(Vint(Float32.to_bits x))|_=>None end
 else match v with Vint n=>Some(Vint n)|_=>None end else Some v.
Definition literal_value(a:expr):option val:=match a with Eval v _=>Some v|_=>None end.
Definition empty_cenv:composite_env:=PTree.empty composite.
Fixpoint value_expr(rho:PTree.t val)(a:expr):option val:=
 match a with
 | Eval v _=>Some v
 | Evalof l ty=>if type_eq ty(typeof l)then
   match place_of l with Some p=>read_place rho p|None=>None end else None
 | Eunop op a _=>match value_expr rho a with Some v=>sem_unary_operation op v(typeof a)Mem.empty|None=>None end
 | Ebinop op a b _=>match value_expr rho a,value_expr rho b with
   |Some v,Some w=>sem_binary_operation empty_cenv op v(typeof a)w(typeof b)Mem.empty|_,_=>None end
 | Ecast a ty=>match value_expr rho a with Some v=>sem_cast v(typeof a)ty Mem.empty|None=>None end
 | _=>None end.
Definition value_assign(rho:PTree.t val)(l r:expr)(ty:type):option(PTree.t val):=
 if type_eq ty(typeof l)then
 match place_of l,value_expr rho r with
 |Some p,Some vr=>match sem_cast vr(typeof r)(typeof l)Mem.empty with
   |Some vc=>match canonical_value p vc with
      |Some observed=>Some(PTree.set(place_id p)observed rho)|None=>None end
   |None=>None end
 |_,_=>None end else None.
Inductive value_outcome:=ValueNormal(rho:PTree.t val)|ValueReturn(v:val)(ty:type)(rho:PTree.t val).
Fixpoint value_statement(rho:PTree.t val)(s:statement):option value_outcome:=
 match s with
 |Sskip=>Some(ValueNormal rho)
 |Sdo(Eassign l r ty)=>match value_assign rho l r ty with Some r=>Some(ValueNormal r)|None=>None end
 |Ssequence a b=>match value_statement rho a with
   |Some(ValueNormal r)=>value_statement r b|other=>other end
 |Sifthenelse a yes no=>match value_expr rho a with
   |Some v=>match bool_val v(typeof a)Mem.empty with
      |Some b=>value_statement rho(if b then yes else no)|None=>None end
   |None=>None end
 |Sreturn(Some a)=>match value_expr rho a with Some v=>Some(ValueReturn v(typeof a)rho)|None=>None end
 |_=>None end.
End QUOTE.
