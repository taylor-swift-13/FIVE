From Stdlib Require Import List Bool.
From compcert Require Import AST Ctypes Cop Csyntax Csem.
From PidPositionRunPos Require Import Source.
From PidPositionTranslationCore Require Import CoreClamp.
Import ListNotations.
Inductive arithmetic_kind:=Binary:binary_operation->arithmetic_kind
|Unary:unary_operation->arithmetic_kind|Compound:binary_operation->arithmetic_kind.
Fixpoint expr_nodes(p:list nat)(a:expr):list(list nat*arithmetic_kind):=
 match a with
 | Eunop op a _=>(p,Unary op)::expr_nodes(p++[0])a
 | Ebinop op a b _=>(p,Binary op)::(expr_nodes(p++[0])a++expr_nodes(p++[1])b)
 | Eassignop op a b _ _=>(p,Compound op)::(expr_nodes(p++[0])a++expr_nodes(p++[1])b)
 | Evalof a _|Ederef a _|Eaddrof a _|Efield a _ _|Ecast a _|Eparen a _ _|Epostincr _ a _=>expr_nodes(p++[0])a
 | Econdition c a b _=>expr_nodes(p++[0])c++expr_nodes(p++[1])a++expr_nodes(p++[2])b
 | Eassign a b _|Ecomma a b _|Eseqand a b _|Eseqor a b _=>expr_nodes(p++[0])a++expr_nodes(p++[1])b
 | Ecall a al _=>expr_nodes(p++[0])a++exprlist_nodes(p++[1])al
 | Ebuiltin _ _ al _=>exprlist_nodes(p++[0])al
 | _=>[]
 end
with exprlist_nodes(p:list nat)(al:exprlist):list(list nat*arithmetic_kind):=
 match al with Enil=>[]|Econs a al=>expr_nodes(p++[0])a++exprlist_nodes(p++[1])al end.
Fixpoint stmt_nodes(p:list nat)(s:statement):list(list nat*list nat*arithmetic_kind):=
 match s with
 | Sdo a=>map(fun x=>(p,fst x,snd x))(expr_nodes[]a)
 | Ssequence a b=>stmt_nodes(p++[0])a++stmt_nodes(p++[1])b
 | Sifthenelse c a b=>map(fun x=>(p,fst x,snd x))(expr_nodes[]c)++stmt_nodes(p++[0])a++stmt_nodes(p++[1])b
 | _=>[] end.
Definition original_top_nodes(n:nat):list(list nat*list nat*arithmetic_kind):=
 stmt_nodes[](top_statement n(fn_body Source.f_guidance_pid_h_run)).
Eval cbv beta iota zeta delta[original_top_nodes stmt_nodes expr_nodes exprlist_nodes top_statement Source.f_guidance_pid_h_run fn_body app map fst snd] in
 (original_top_nodes 0,original_top_nodes 1,original_top_nodes 2,original_top_nodes 3,original_top_nodes 4,original_top_nodes 5,original_top_nodes 6,original_top_nodes 7).
