From Stdlib Require Import List ZArith.
From compcert Require Import Floats Integers AST Values Ctypes Csyntax Csyntaxdefs Cop.
From FivePprzFloatMatInv3d Require Import Source.
From FiveMatInv3Case Require Import MatrixAccess.
Import ListNotations.
Local Open Scope Z_scope.
Definition M00(f:Z->float32):float32:=Float32.sub(Float32.mul(f 4)(f 8))(Float32.mul(f 5)(f 7)).
Definition M10(f:Z->float32):float32:=Float32.sub(Float32.mul(f 1)(f 8))(Float32.mul(f 2)(f 7)).
Definition M20(f:Z->float32):float32:=Float32.sub(Float32.mul(f 1)(f 5))(Float32.mul(f 2)(f 4)).
Definition M01(f:Z->float32):float32:=Float32.sub(Float32.mul(f 3)(f 8))(Float32.mul(f 5)(f 6)).
Definition M11(f:Z->float32):float32:=Float32.sub(Float32.mul(f 0)(f 8))(Float32.mul(f 2)(f 6)).
Definition M21(f:Z->float32):float32:=Float32.sub(Float32.mul(f 0)(f 5))(Float32.mul(f 2)(f 3)).
Definition M02(f:Z->float32):float32:=Float32.sub(Float32.mul(f 3)(f 7))(Float32.mul(f 4)(f 6)).
Definition M12(f:Z->float32):float32:=Float32.sub(Float32.mul(f 0)(f 7))(Float32.mul(f 1)(f 6)).
Definition M22(f:Z->float32):float32:=Float32.sub(Float32.mul(f 0)(f 4))(Float32.mul(f 1)(f 3)).
Definition Det(f:Z->float32):float32:=Float32.add(Float32.sub(Float32.mul(f 0)(M00 f))(Float32.mul(f 3)(M10 f)))(Float32.mul(f 6)(M20 f)).
Definition Accept(f:Z->float32):bool:=Float.cmp Cgt(Float.abs(Float.of_single(Det f)))(Float.of_single(Float32.of_bits(Int.repr 872415232))).
Definition Status(f:Z->float32):val:=Vint(if Accept f then Int.zero else Int.one).
Definition Output(f:Z->float32)(i:Z):float32:=
 match i with
 |0=>Float32.div(M00 f)(Det f)
 |1=>Float32.div(Float32.neg(M10 f))(Det f)
 |2=>Float32.div(M20 f)(Det f)
 |3=>Float32.div(Float32.neg(M01 f))(Det f)
 |4=>Float32.div(M11 f)(Det f)
 |5=>Float32.div(Float32.neg(M21 f))(Det f)
 |6=>Float32.div(M02 f)(Det f)
 |7=>Float32.div(Float32.neg(M12 f))(Det f)
 |_=>Float32.div(M22 f)(Det f)
 end.
Definition Outputs(f:Z->float32):list(Z*float32):=[(0,Output f 0);(3,Output f 3);(6,Output f 6);(1,Output f 1);(4,Output f 4);(7,Output f 7);(2,Output f 2);(5,Output f 5);(8,Output f 8)].
Definition Local(id:ident):expr:=Evalof(Evar id tfloat)tfloat.
Definition FBin(op:binary_operation)(a b:expr):expr:=Ebinop op a b tfloat.
Definition FNeg(a:expr):expr:=Eunop Oneg a tfloat.
Definition Inp(r c:Z):expr:=MatrixVal Source._mat_in 3 r c.
Definition MinExpr(a b c d:Z):expr:=FBin Osub(FBin Omul(Inp(a/3)(a mod 3))(Inp(b/3)(b mod 3)))(FBin Omul(Inp(c/3)(c mod 3))(Inp(d/3)(d mod 3))).
Definition Prefix:list(ident*expr):=[
 (Source._m00,MinExpr 4 8 5 7);(Source._m10,MinExpr 1 8 2 7);(Source._m20,MinExpr 1 5 2 4);
 (Source._m01,MinExpr 3 8 5 6);(Source._m11,MinExpr 0 8 2 6);(Source._m21,MinExpr 0 5 2 3);
 (Source._m02,MinExpr 3 7 4 6);(Source._m12,MinExpr 0 7 1 6);(Source._m22,MinExpr 0 4 1 3);
 (Source._det,FBin Oadd(FBin Osub(FBin Omul(Inp 0 0)(Local Source._m00))(FBin Omul(Inp 1 0)(Local Source._m10)))(FBin Omul(Inp 2 0)(Local Source._m20)))].
Definition LocalResults(f:Z->float32):list(ident*float32):=[(Source._m00,M00 f);(Source._m10,M10 f);(Source._m20,M20 f);(Source._m01,M01 f);(Source._m11,M11 f);(Source._m21,M21 f);(Source._m02,M02 f);(Source._m12,M12 f);(Source._m22,M22 f);(Source._det,Det f)].
Definition Guard:expr:=Ebinop Ogt(Eunop Oabsfloat(Local Source._det)tdouble)(Eval(Vsingle(Float32.of_bits(Int.repr 872415232)))tfloat)tint.
Definition OutExprs:list(Z*Z*expr):=[
 (0,0,FBin Odiv(Local Source._m00)(Local Source._det));(1,0,FBin Odiv(FNeg(Local Source._m01))(Local Source._det));(2,0,FBin Odiv(Local Source._m02)(Local Source._det));
 (0,1,FBin Odiv(FNeg(Local Source._m10))(Local Source._det));(1,1,FBin Odiv(Local Source._m11)(Local Source._det));(2,1,FBin Odiv(FNeg(Local Source._m12))(Local Source._det));
 (0,2,FBin Odiv(Local Source._m20)(Local Source._det));(1,2,FBin Odiv(FNeg(Local Source._m21))(Local Source._det));(2,2,FBin Odiv(Local Source._m22)(Local Source._det))].
Fixpoint PrefixStmt(xs:list(ident*expr))(tail:statement):statement:=match xs with []=>tail|(id,r)::xs=>Ssequence(Sdo(Eassign(Evar id tfloat)r tfloat))(PrefixStmt xs tail)end.
Fixpoint OutputStmt(xs:list(Z*Z*expr)):statement:=match xs with []=>Sreturn(Some(Eval(Vint Int.zero)tint))|(r,c,x)::xs=>Ssequence(Sdo(Eassign(MatrixLoc Source._inv_out 3 r c)x tfloat))(OutputStmt xs)end.
Definition Suffix:=Ssequence(Sifthenelse Guard(OutputStmt OutExprs)Sskip)(Sreturn(Some(Eval(Vint Int.one)tint))).
Lemma body_syntax:fn_body Source.f_float_mat_inv_3d=PrefixStmt Prefix Suffix.
Proof. reflexivity. Qed.
