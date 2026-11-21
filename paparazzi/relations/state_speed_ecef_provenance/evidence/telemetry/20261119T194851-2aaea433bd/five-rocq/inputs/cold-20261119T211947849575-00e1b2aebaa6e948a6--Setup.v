From Stdlib Require Import List ZArith.
From compcert Require Import Coqlib Errors Maps AST Integers Floats Values Memory Memdata Events Globalenvs Ctypes Cop Csyntax Csyntaxdefs Csem Smallstep.
From StateSpeedGetEcefF Require Import Source Execution.
Import ListNotations.
Open Scope Z_scope.
Module S:=StateSpeedGetEcefF.Source.
Module E:=StateSpeedGetEcefF.Execution.
Definition ge:=E.ge.
Definition state_address:=Evalof(Evar S._state(Tstruct S._State noattr))(Tstruct S._State noattr).
Definition status_lvalue:=Efield state_address S._speed_status tushort.
Definition status_read:=Evalof status_lvalue tushort.
Definition status_test(n:Z):=Ebinop Oand(Ebinop Oshr status_read(Eval(Vint(Int.repr n))tint)tint)(Eval(Vint Int.one)tint)tint.
Definition vector_address(sid field:ident):=Evalof(Efield state_address field(Tstruct sid noattr))(Tstruct sid noattr).
Definition ned_address:=vector_address S._NedCoor_i S._ned_speed_i.
Definition float_address:=vector_address S._EcefCoor_f S._ecef_speed_f.
Definition ned_word(axis:ident):=Evalof(Efield ned_address axis tint)tint.
Definition float_lvalue(axis:ident):=Efield float_address axis tfloat.
Definition denominator:=Ebinop Oshl(Eval(Vint Int.one)tint)(Eval(Vint(Int.repr 19))tint)tint.
Definition conversion(axis:ident):=Ebinop Odiv(Ecast(ned_word axis)tfloat)denominator tfloat.
Definition assignment(axis:ident):=Sdo(Eassign(float_lvalue axis)(conversion axis)tfloat).
Definition conversion_block:=Ssequence(assignment S._x)(Ssequence(assignment S._y)(assignment S._z)).
Definition marker:=Sdo(Eassignop Oor status_lvalue(Ebinop Oshl(Eval(Vint Int.one)tint)(Eval(Vint(Int.repr 5))tint)tint)tint tushort).
Definition fst_stmt(s:statement):=match s with Ssequence a _=>a|_=>Sskip end.
Definition snd_stmt(s:statement):=match s with Ssequence _ b=>b|_=>Sskip end.
Definition calc_first:=fst_stmt(fn_body S.f_stateCalcSpeedEcef_f).
Definition calc_rest:=snd_stmt(fn_body S.f_stateCalcSpeedEcef_f).
Definition calc_branch:=fst_stmt calc_rest.
Definition calc_fallback:=match calc_branch with Sifthenelse _ _ no=>no|_=>Sskip end.
Definition getter_first:=fst_stmt(fn_body S.f_stateGetSpeedEcef_f).
Definition getter_return:=snd_stmt(fn_body S.f_stateGetSpeedEcef_f).
Definition getter_condition:=Eunop Onotbool(status_test 5)tint.
Definition getter_call:=match getter_first with Sifthenelse _ yes _=>yes|_=>Sskip end.
Definition decode(i:int):float32:=Float32.div(Float32.of_int i)(Float32.of_int(Int.repr 524288)).
Definition InputGood(m:mem)(sb:block)(x y z:int):Prop:=
 Genv.find_symbol ge S._state=Some sb /\Mem.range_perm m sb 0 656 Cur Writable /\ Mem.load Mint16unsigned m sb 280=Some(Vint Int.one) /\ Mem.load Mint32 m sb 296=Some(Vint x) /\Mem.load Mint32 m sb 300=Some(Vint y) /\Mem.load Mint32 m sb 304=Some(Vint z).
Definition float_bytes(x y z:int):list memval:=
 encode_val Mfloat32(Vsingle(decode x))++encode_val Mfloat32(Vsingle(decode y))++encode_val Mfloat32(Vsingle(decode z)).
Definition write_byte(sb:block)(b:block)(ofs:Z):Prop:=b=sb /\(280<=ofs<282 \/328<=ofs<340).
Definition NormalCall(m mf:mem)(sb:block):Prop:=
 star Csem.step ge(E.entry[]m)E0(Returnstate(Vptr sb(Ptrofs.repr 328))Kstop mf).
Record GetterResult(m mf:mem)(sb:block)(x y z:int):Prop:={
 result_x:Mem.load Mfloat32 mf sb 328=Some(Vsingle(decode x));
 result_y:Mem.load Mfloat32 mf sb 332=Some(Vsingle(decode y));
 result_z:Mem.load Mfloat32 mf sb 336=Some(Vsingle(decode z));
 result_status:Mem.load Mint16unsigned mf sb 280=Some(Vint(Int.repr 33));
 result_bytes:Mem.loadbytes mf sb 328 12=Some(float_bytes x y z);
 result_permissions:forall b ofs k p,Mem.perm m b ofs k p<->Mem.perm mf b ofs k p;
 result_frame:forall b ofs n,0<=n->(forall i,ofs<=i<ofs+n->~write_byte sb b i)->Mem.loadbytes mf b ofs n=Mem.loadbytes m b ofs n
}.
Lemma calc_body_decomposition:fn_body S.f_stateCalcSpeedEcef_f=
 Ssequence(Sifthenelse(status_test 5)(Sreturn None)Sskip)
 (Ssequence(Sifthenelse(status_test 0)conversion_block calc_fallback)marker).
Proof. reflexivity. Qed.
Lemma getter_body_decomposition:fn_body S.f_stateGetSpeedEcef_f=
 Ssequence(Sifthenelse getter_condition getter_call Sskip)getter_return.
Proof. reflexivity. Qed.
Lemma getter_call_shape:getter_call=Sdo(Ecall(Evalof(Evar S._stateCalcSpeedEcef_f(Tfunction[]tvoid cc_default))(Tfunction[]tvoid cc_default))Enil tvoid).
Proof. reflexivity. Qed.
