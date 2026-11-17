From Stdlib Require Import List ZArith.
From compcert Require Import AST Integers Values Memory Globalenvs Ctypes Csem.
From PidPositionRunPos Require Import Source Execution.
From PidPositionTranslationSupport Require Import MemoryLayout.
From PidPositionTranslationProblem Require Import Spec.
From PidPositionTranslationAttempt002 Require Import ClampSemantics CoreInputs ExtendedNormalReturn MainGoals ComputedRelation.
Import ListNotations.
Module S:=PidPositionRunPos.Source.
Module E:=PidPositionRunPos.Execution.

Theorem all_normal_error_and_reference_results : forall m gh ret flight mf,
 InputGood m gh ret ->NormalCall gh ret flight m mf ->
 exists rx ry px py sx sy vx vy sb,
 Genv.find_symbol E.ge S._state=Some sb /\
 load_path Mint32 m gh gh_type[S._ref;S._pos;S._x]=Some(Vint rx) /\
 load_path Mint32 m gh gh_type[S._ref;S._pos;S._y]=Some(Vint ry) /\
 Mem.load Mint32 m sb 100=Some(Vint px) /\Mem.load Mint32 m sb 104=Some(Vint py) /\
 load_path Mint32 m gh gh_type[S._ref;S._speed;S._x]=Some(Vint sx) /\
 load_path Mint32 m gh gh_type[S._ref;S._speed;S._y]=Some(Vint sy) /\
 Mem.load Mint32 m sb 296=Some(Vint vx) /\Mem.load Mint32 m sb 300=Some(Vint vy) /\
 load_global Mint32 mf S._guidance_pid_pos_err vec_type[S._x]=Some(Vint(clamp_bits(Int.sub rx px)(Int.repr 4096))) /\
 load_global Mint32 mf S._guidance_pid_pos_err vec_type[S._y]=Some(Vint(clamp_bits(Int.sub ry py)(Int.repr 4096))) /\
 load_global Mint32 mf S._guidance_pid_speed_err vec_type[S._x]=Some(Vint(clamp_bits(Int.sub sx vx)(Int.repr 8388608))) /\
 load_global Mint32 mf S._guidance_pid_speed_err vec_type[S._y]=Some(Vint(clamp_bits(Int.sub sy vy)(Int.repr 8388608))) /\
 load_path Mint32 mf gh gh_type[S._ref;S._pos;S._x]=Some(Vint rx) /\
 load_path Mint32 mf gh gh_type[S._ref;S._pos;S._y]=Some(Vint ry).
Proof.
 intros m gh ret flight mf GOOD CALL.
 destruct(inputgood_core_initial_data m gh ret GOOD)as[D _].
 destruct(original_entry_extended_normal_result m gh ret flight D GOOD)
 as(nf&rx&ry&px&py&sx&sy&vx&vy&sb&NC&STATE&RX&RY&PX&PY&SX&SY&VX&VY&ACTIVE&IX&IY&CX&CY&EX&EY&ESX&ESY&FRX&FRY).
 assert(EQ:nf=mf)by(eapply original_entry_all_normal_memories_unique;[exact GOOD|exact NC|exact CALL]).
 subst nf;exists rx,ry,px,py,sx,sy,vx,vy,sb;repeat split;assumption.
Qed.

Theorem all_normal_reference_positions_preserved :
 forall m gh ret flight mf,InputGood m gh ret ->NormalCall gh ret flight m mf ->
 forall axis,In axis[S._x;S._y] ->
 load_path Mint32 mf gh gh_type(ref_pos axis)=load_path Mint32 m gh gh_type(ref_pos axis).
Proof.
 intros m gh ret flight mf GOOD CALL.
 destruct(all_normal_error_and_reference_results m gh ret flight mf GOOD CALL)
 as(rx&ry&px&py&sx&sy&vx&vy&sb&STATE&RX&RY&PX&PY&SX&SY&VX&VY&EX&EY&ESX&ESY&FRX&FRY).
 intros axis IN;destruct IN as[<-|[<-|[]]];unfold ref_pos;[rewrite RX,FRX|rewrite RY,FRY];reflexivity.
Qed.

Theorem all_normal_position_errors_equal :
 forall gh ret a b dx dy flight af bf,
 InputPair gh ret a b dx dy ->NormalCall gh ret flight a af ->NormalCall gh ret flight b bf ->
 forall axis,In axis[S._x;S._y] ->
 same_loaded_int32
 (load_global Mint32 af S._guidance_pid_pos_err vec_type[axis])
 (load_global Mint32 bf S._guidance_pid_pos_err vec_type[axis]).
Proof.
 intros gh ret a b dx dy flight af bf PAIR CA CB.
 destruct PAIR as[GA[GB[FRAME[TX TY]]]].
 destruct(all_normal_error_and_reference_results a gh ret flight af GA CA)
 as(rax&ray&pax&pay&sax&say&vax&vay&sa&SA&RAX&RAY&PAX&PAY&SAX&SAY&VAX&VAY&EAX&EAY&ESAX&ESAY&FRAX&FRAY).
 destruct(all_normal_error_and_reference_results b gh ret flight bf GB CB)
 as(rbx&rby&pbx&pby&sbx&sby&vbx&vby&sb&SB&RBX&RBY&PBX&PBY&SBX&SBY&VBX&VBY&EBX&EBY&ESBX&ESBY&FRBX&FRBY).
 assert(X:Int.sub rax pax=Int.sub rbx pbx).
 { eapply axis_translation_sub_equal;[exact TX|exact RAX| |exact RBX|].
   - unfold load_global;rewrite SA;exact PAX.
   - unfold load_global;rewrite SB;exact PBX. }
 assert(Y:Int.sub ray pay=Int.sub rby pby).
 { eapply axis_translation_sub_equal;[exact TY|exact RAY| |exact RBY|].
   - unfold load_global;rewrite SA;exact PAY.
   - unfold load_global;rewrite SB;exact PBY. }
 intros axis IN;destruct IN as[<-|[<-|[]]];unfold same_loaded_int32.
 - exists(clamp_bits(Int.sub rax pax)(Int.repr 4096));split;[exact EAX|rewrite X;exact EBX].
 - exists(clamp_bits(Int.sub ray pay)(Int.repr 4096));split;[exact EAY|rewrite Y;exact EBY].
Qed.
Print Assumptions all_normal_position_errors_equal.
Print Assumptions all_normal_reference_positions_preserved.
