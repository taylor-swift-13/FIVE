From Stdlib Require Import List ZArith.
From compcert Require Import Coqlib AST Integers Values Memory Memdata Events Globalenvs Maps Ctypes Cop Csyntax Csyntaxdefs Csem Smallstep.
From StateSpeedSetEcefI Require Import Source Execution.
Import ListNotations.
Open Scope Z_scope.
Module S:=StateSpeedSetEcefI.Source.
Module E:=StateSpeedSetEcefI.Execution.
Definition ge:=E.ge.
Definition stype:=Tstruct S._State noattr.
Definition vtype:=Tstruct S._EcefCoor_i noattr.
Definition f:=S.f_stateSetSpeedEcef_i.
Definition destination_offset:Z:=284.
Definition selected_status:Z:=1.
Definition Args(id:int)(src:block):list val:=[Vint id;Vptr src Ptrofs.zero].
Definition VecRead(m:mem)(b:block)(x y z:int):Prop:=
 Mem.load Mint32 m b 0=Some(Vint x) /\Mem.load Mint32 m b 4=Some(Vint y) /\Mem.load Mint32 m b 8=Some(Vint z).
Record InputGood(m:mem)(sb src:block)(id x y z:int):Prop:={
 state_symbol:Genv.find_symbol ge S._state=Some sb;
 state_writable:Mem.range_perm m sb 0 656 Cur Writable;
 accepted_filter:Mem.load Mint16unsigned m sb 282=Some(Vint(Int.repr 65535));
 input_separate:src<>sb;
 input_words:VecRead m src x y z
}.
Definition writes(sb b:block)(ofs:Z):Prop:=b=sb /\
 (280<=ofs<282 \/destination_offset<=ofs<destination_offset+12).
Definition typed_bytes(x y z:int):list memval:=encode_val Mint32(Vint x)++encode_val Mint32(Vint y)++encode_val Mint32(Vint z).
Record SetterResult(m mf:mem)(sb src:block)(x y z:int):Prop:={
 result_x:Mem.load Mint32 mf sb destination_offset=Some(Vint x);
 result_y:Mem.load Mint32 mf sb(destination_offset+4)=Some(Vint y);
 result_z:Mem.load Mint32 mf sb(destination_offset+8)=Some(Vint z);
 result_status:Mem.load Mint16unsigned mf sb 280=Some(Vint(Int.repr selected_status));
 result_bytes:Mem.loadbytes mf sb destination_offset 12=Some(typed_bytes x y z);
 result_input:VecRead mf src x y z;
 result_permissions:forall b ofs k p,Mem.valid_block m b ->(Mem.perm m b ofs k p<->Mem.perm mf b ofs k p);
 result_frame:forall b ofs n,Mem.valid_block m b ->0<=n ->
 (forall i,ofs<=i<ofs+n ->~writes sb b i) ->Mem.loadbytes mf b ofs n=Mem.loadbytes m b ofs n
}.
Definition NormalCall(id:int)(src:block)(m mf:mem):Prop:=
 star Csem.step ge(E.entry(Args id src)m)E0(Returnstate Vundef Kstop mf).

Definition state_address:expr:=Evalof(Evar S._state stype)stype.
Definition filter_read:expr:=Evalof(Efield state_address S._speed_input_filter tushort)tushort.
Definition id_read:expr:=Evalof(Evar S._id tushort)tushort.
Definition first_test:expr:=Ebinop Oeq filter_read(Eval(Vint(Int.repr 0))tint)tint.
Definition second_test:expr:=Ebinop Oeq filter_read(Eval(Vint(Int.repr 65535))tint)tint.
Definition third_test:expr:=Ebinop Oeq filter_read id_read tint.
Definition condition:expr:=Eseqor first_test(Eunop Onotbool(Eseqor second_test third_test tint)tint)tint.
Definition guard:statement:=Sifthenelse condition(Sreturn None)Sskip.
Definition dst_base:expr:=Evalof(Efield state_address S._ecef_speed_i vtype)vtype.
Definition input_base:expr:=Evalof(Ederef(Evalof(Evar S._ecef_speed(tptr vtype))(tptr vtype))vtype)vtype.
Definition copy_one(axis:ident):statement:=Sdo(Eassign(Efield dst_base axis tint)(Evalof(Efield input_base axis tint)tint)tint).
Definition status_write:statement:=Sdo(Eassign(Efield state_address S._speed_status tushort)
 (Ebinop Oshl(Eval(Vint(Int.repr 1))tint)(Eval(Vint(Int.repr 0))tint)tint)tushort).
Definition copy_body:statement:=Ssequence(Ssequence(copy_one S._x)(Ssequence(copy_one S._y)(copy_one S._z)))status_write.
Lemma source_body:fn_body f=Ssequence guard copy_body.
Proof. reflexivity. Qed.
Lemma source_params:fn_params f=[(S._id,tushort);(S._ecef_speed,tptr vtype)] /\fn_vars f=[] /\fn_return f=tvoid.
Proof. repeat split;reflexivity. Qed.
