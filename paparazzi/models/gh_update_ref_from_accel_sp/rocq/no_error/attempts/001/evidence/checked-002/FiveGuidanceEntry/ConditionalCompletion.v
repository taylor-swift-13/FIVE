From Stdlib Require Import List.
From compcert Require Import Integers Floats Values Events Csem.
From FivePaparazziState Require Import State.
From FiveGuidanceEntry Require Import Entry SpeedEntry AccelEntry.
From FiveGuidanceMode Require Import Spec.
Require FiveGuidanceEntry.SaturationBody FiveGuidanceEntry.SaturationBodyAccel.
Import ListNotations.
Lemma vector_bits_injective:forall a b,vector_bits a=vector_bits b ->a=b.
Proof.
 intros[x y][u v]H.
 assert(X:Float32.to_bits x=Float32.to_bits u)by exact(f_equal(fun xs=>hd Int.zero xs)H).
 assert(Y:Float32.to_bits y=Float32.to_bits v)by exact(f_equal(fun xs=>hd Int.zero(tl xs))H).
 apply float32_bits_inj in X;apply float32_bits_inj in Y;subst;reflexivity.
Qed.
Theorem normal_completion_given_software:
 FiveGuidanceEntry.SaturationBody.sqrt_call_contract ->
 FiveGuidanceEntry.SaturationBodyAccel.sqrt_call_contract ->NormalCompletion.
Proof.
 intros SPEEDSQ ACCELSQ;unfold NormalCompletion;intros s sp a ma mb ba bb pa pb oa ob IA IB MATCH.
 destruct MATCH as[si[INT BITS]].
 apply vector_bits_injective in BITS;subst a.
 destruct(speed_entry_normal SPEEDSQ s sp ma ba pa oa IA)
 as[sf[fa[UPDATESPEED[PATHS[RS RESTS]]]]].
 destruct(accel_entry_normal ACCELSQ s(raw_speed_accel si sp)mb bb pb ob IB)
 as[sg[fb[UPDATEACCEL[PATHA[RA RESTA]]]]].
 pose proof(matching_accel_after_integration fixed_maximum s si sp INT)as MATCHUPDATE.
 rewrite MATCHUPDATE,UPDATEACCEL in UPDATESPEED;injection UPDATESPEED as EQ;subst sg.
 exists fa,fb,sf;split.
 - unfold speed_call,Returns;exists E0,Vundef;exact PATHS.
 - split.
   + unfold accel_call,Returns;exists E0,Vundef;exact PATHA.
   + split;[rewrite MATCHUPDATE;exact UPDATEACCEL|auto].
Qed.
Print Assumptions normal_completion_given_software.
