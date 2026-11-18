From Stdlib Require Import List.
From compcert Require Import Integers Floats Values Memory.
From FivePaparazziState Require Import State.
From FiveGuidanceEntry Require Import Entry.
From FiveGuidanceMode Require Import Spec.
From FiveGuidanceRelationSupport Require Import Initialization Witnesses.
From FiveGuidanceCbmcAdapters Require Import CanonicalCalls.
Lemma nontrivial_canonical_controls:CanonicalControls nontrivial_state.
Proof. unfold CanonicalControls,nontrivial_state;repeat split;apply float32_bits_inj;vm_compute;reflexivity. Qed.
Definition CanonicalInputsExist:Prop:=forall taken,
 exists s ma mb ba bb pa pb,
 CanonicalControls s /\
 speed_initial s(speed_command taken)ma ba pa Ptrofs.zero /\
 accel_initial s(accel_command taken)mb bb pb Ptrofs.zero /\
 pos_increment(speed_x s)(dt s)<>Some Int64.zero /\
 saturation_branch fixed_maximum(accel_command taken)=taken.
Theorem canonical_inputs_exist:CanonicalInputsExist.
Proof.
 intros taken;destruct(initialized_matching_pair(speed_command taken))as(ma&mb&ba&bb&pa&pb&IA&IB).
 rewrite(canonical_raw_from_actual_integrate nontrivial_state nontrivial_integrated taken
 nontrivial_canonical_controls nontrivial_integration)in IB.
 exists nontrivial_state,ma,mb,ba,bb,pa,pb.
 split;[exact nontrivial_canonical_controls|]. split;[exact IA|]. split;[exact IB|]. split.
 - exact nontrivial_position_advance.
 - exact(proj1(canonical_norm_and_branch taken)).
Qed.
Print Assumptions canonical_inputs_exist.
