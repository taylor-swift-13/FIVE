From FiveGhSpeedCBC Require Import Spec.
From FiveGuidanceCbmcAdapters Require Import Adapters CanonicalCallScope.
From FiveGuidanceSoftwareProof Require Import GuardTrace GuardExecution GuardSiteMap.
From Stdlib Require Import Lia.

Theorem goal001 : Spec.Goal001.
Proof. unfold Spec.Goal001; apply Adapters.memcpy_guards; lia. Qed.
Print Assumptions goal001.
Theorem goal002 : Spec.Goal002.
Proof. unfold Spec.Goal002; apply Adapters.memcpy_guards; lia. Qed.
Print Assumptions goal002.
Theorem goal003 : Spec.Goal003.
Proof. unfold Spec.Goal003; apply Adapters.memcpy_guards; lia. Qed.
Print Assumptions goal003.
Theorem goal004 : Spec.Goal004.
Proof. unfold Spec.Goal004; apply Adapters.memcpy_guards; lia. Qed.
Print Assumptions goal004.
Theorem goal005 : Spec.Goal005.
Proof. unfold Spec.Goal005; apply Adapters.memcpy_guards; lia. Qed.
Print Assumptions goal005.
Theorem goal006 : Spec.Goal006.
Proof. unfold Spec.Goal006; apply Adapters.memcpy_guards; lia. Qed.
Print Assumptions goal006.
Theorem goal007 : Spec.Goal007.
Proof. unfold Spec.Goal007; apply Adapters.bits_guards; lia. Qed.
Print Assumptions goal007.
Theorem goal008 : Spec.Goal008.
Proof. unfold Spec.Goal008; apply Adapters.bits_guards; lia. Qed.
Print Assumptions goal008.
Theorem goal009 : Spec.Goal009.
Proof. unfold Spec.Goal009; apply Adapters.bits_guards; lia. Qed.
Print Assumptions goal009.
Theorem goal010 : Spec.Goal010.
Proof. unfold Spec.Goal010; split; [exact CanonicalCallScope.speed_call_scope|]; split; [exact GuardSiteMap.actual_helper_guard_site_map|apply GuardExecution.speed_executed_helper_guard; lia]. Qed.
Print Assumptions goal010.
Theorem goal011 : Spec.Goal011.
Proof. unfold Spec.Goal011; split; [exact CanonicalCallScope.speed_call_scope|]; split; [exact GuardSiteMap.actual_helper_guard_site_map|apply GuardExecution.speed_executed_helper_guard; lia]. Qed.
Print Assumptions goal011.
Theorem goal012 : Spec.Goal012.
Proof. unfold Spec.Goal012; split; [exact CanonicalCallScope.speed_call_scope|]; split; [exact GuardSiteMap.actual_helper_guard_site_map|apply GuardExecution.speed_executed_helper_guard; lia]. Qed.
Print Assumptions goal012.
Theorem goal013 : Spec.Goal013.
Proof. unfold Spec.Goal013; split; [exact CanonicalCallScope.speed_call_scope|]; split; [exact GuardSiteMap.actual_helper_guard_site_map|apply GuardExecution.speed_executed_helper_guard; lia]. Qed.
Print Assumptions goal013.
Theorem goal014 : Spec.Goal014.
Proof. unfold Spec.Goal014; split; [exact CanonicalCallScope.speed_call_scope|]; split; [exact GuardSiteMap.actual_helper_guard_site_map|apply GuardExecution.speed_executed_helper_guard; lia]. Qed.
Print Assumptions goal014.
Theorem goal015 : Spec.Goal015.
Proof. unfold Spec.Goal015; split; [exact CanonicalCallScope.speed_call_scope|]; split; [exact GuardSiteMap.actual_helper_guard_site_map|apply GuardExecution.speed_executed_helper_guard; lia]. Qed.
Print Assumptions goal015.
Theorem goal016 : Spec.Goal016.
Proof. unfold Spec.Goal016; split; [exact CanonicalCallScope.speed_call_scope|]; split; [exact GuardSiteMap.actual_helper_guard_site_map|apply GuardExecution.speed_executed_helper_guard; lia]. Qed.
Print Assumptions goal016.
Theorem goal017 : Spec.Goal017.
Proof. unfold Spec.Goal017; split; [exact CanonicalCallScope.speed_call_scope|]; split; [exact GuardSiteMap.actual_helper_guard_site_map|apply GuardExecution.speed_executed_helper_guard; lia]. Qed.
Print Assumptions goal017.
Theorem goal018 : Spec.Goal018.
Proof. unfold Spec.Goal018; split; [exact CanonicalCallScope.speed_call_scope|]; split; [exact GuardSiteMap.actual_helper_guard_site_map|apply GuardExecution.speed_executed_helper_guard; lia]. Qed.
Print Assumptions goal018.
Theorem goal019 : Spec.Goal019.
Proof. unfold Spec.Goal019; split; [exact CanonicalCallScope.speed_call_scope|]; split; [exact GuardSiteMap.actual_helper_guard_site_map|apply GuardExecution.speed_executed_helper_guard; lia]. Qed.
Print Assumptions goal019.
Theorem goal020 : Spec.Goal020.
Proof. unfold Spec.Goal020; split; [exact CanonicalCallScope.speed_call_scope|]; split; [exact GuardSiteMap.actual_helper_guard_site_map|apply GuardExecution.speed_executed_helper_guard; lia]. Qed.
Print Assumptions goal020.
Theorem goal021 : Spec.Goal021.
Proof. unfold Spec.Goal021; split; [exact CanonicalCallScope.speed_call_scope|]; split; [exact GuardSiteMap.actual_helper_guard_site_map|apply GuardExecution.speed_executed_helper_guard; lia]. Qed.
Print Assumptions goal021.
Theorem goal022 : Spec.Goal022.
Proof. unfold Spec.Goal022; split; [exact CanonicalCallScope.speed_call_scope|]; split; [exact GuardSiteMap.actual_helper_guard_site_map|apply GuardExecution.speed_executed_helper_guard; lia]. Qed.
Print Assumptions goal022.
Theorem goal023 : Spec.Goal023.
Proof. unfold Spec.Goal023; split; [exact CanonicalCallScope.speed_call_scope|]; split; [exact GuardSiteMap.actual_helper_guard_site_map|apply GuardExecution.speed_executed_helper_guard; lia]. Qed.
Print Assumptions goal023.
Theorem goal024 : Spec.Goal024.
Proof. unfold Spec.Goal024; split; [exact CanonicalCallScope.speed_call_scope|]; split; [exact GuardSiteMap.actual_helper_guard_site_map|apply GuardExecution.speed_executed_helper_guard; lia]. Qed.
Print Assumptions goal024.
Theorem goal025 : Spec.Goal025.
Proof. unfold Spec.Goal025; split; [exact CanonicalCallScope.speed_call_scope|]; split; [exact GuardSiteMap.actual_helper_guard_site_map|apply GuardExecution.speed_executed_helper_guard; lia]. Qed.
Print Assumptions goal025.
Theorem goal026 : Spec.Goal026.
Proof. unfold Spec.Goal026; split; [exact CanonicalCallScope.speed_call_scope|]; split; [exact GuardSiteMap.actual_helper_guard_site_map|apply GuardExecution.speed_executed_helper_guard; lia]. Qed.
Print Assumptions goal026.
Theorem goal027 : Spec.Goal027.
Proof. unfold Spec.Goal027; split; [exact CanonicalCallScope.speed_call_scope|]; split; [exact GuardSiteMap.actual_helper_guard_site_map|apply GuardExecution.speed_executed_helper_guard; lia]. Qed.
Print Assumptions goal027.
Theorem goal028 : Spec.Goal028.
Proof. unfold Spec.Goal028; split; [exact CanonicalCallScope.speed_call_scope|]; split; [exact GuardSiteMap.actual_helper_guard_site_map|apply GuardExecution.speed_executed_helper_guard; lia]. Qed.
Print Assumptions goal028.
Theorem goal029 : Spec.Goal029.
Proof. unfold Spec.Goal029; split; [exact CanonicalCallScope.speed_call_scope|]; split; [exact GuardSiteMap.actual_helper_guard_site_map|apply GuardExecution.speed_executed_helper_guard; lia]. Qed.
Print Assumptions goal029.
Theorem goal030 : Spec.Goal030.
Proof. unfold Spec.Goal030; split; [exact CanonicalCallScope.speed_call_scope|]; split; [exact GuardSiteMap.actual_helper_guard_site_map|apply GuardExecution.speed_executed_helper_guard; lia]. Qed.
Print Assumptions goal030.
Theorem goal031 : Spec.Goal031.
Proof. unfold Spec.Goal031; split; [exact CanonicalCallScope.speed_call_scope|]; split; [exact GuardSiteMap.actual_helper_guard_site_map|apply GuardExecution.speed_executed_helper_guard; lia]. Qed.
Print Assumptions goal031.
Theorem goal032 : Spec.Goal032.
Proof. unfold Spec.Goal032; split; [exact CanonicalCallScope.speed_call_scope|]; split; [exact GuardSiteMap.actual_helper_guard_site_map|apply GuardExecution.speed_executed_helper_guard; lia]. Qed.
Print Assumptions goal032.
Theorem goal033 : Spec.Goal033.
Proof. unfold Spec.Goal033; split; [exact CanonicalCallScope.speed_call_scope|]; split; [exact GuardSiteMap.actual_helper_guard_site_map|apply GuardExecution.speed_executed_helper_guard; lia]. Qed.
Print Assumptions goal033.
Theorem goal034 : Spec.Goal034.
Proof. unfold Spec.Goal034; split; [exact CanonicalCallScope.speed_call_scope|]; split; [exact GuardSiteMap.actual_helper_guard_site_map|apply GuardExecution.speed_executed_helper_guard; lia]. Qed.
Print Assumptions goal034.
Theorem goal035 : Spec.Goal035.
Proof. unfold Spec.Goal035; split; [exact CanonicalCallScope.speed_call_scope|]; split; [exact GuardSiteMap.actual_helper_guard_site_map|apply GuardExecution.speed_executed_helper_guard; lia]. Qed.
Print Assumptions goal035.
Theorem goal036 : Spec.Goal036.
Proof. unfold Spec.Goal036; split; [exact CanonicalCallScope.speed_call_scope|]; split; [exact GuardSiteMap.actual_helper_guard_site_map|apply GuardExecution.speed_executed_helper_guard; lia]. Qed.
Print Assumptions goal036.
Theorem goal037 : Spec.Goal037.
Proof. unfold Spec.Goal037; split; [exact CanonicalCallScope.speed_call_scope|]; split; [exact GuardSiteMap.actual_helper_guard_site_map|apply GuardExecution.speed_executed_helper_guard; lia]. Qed.
Print Assumptions goal037.
Theorem goal038 : Spec.Goal038.
Proof. unfold Spec.Goal038; split; [exact CanonicalCallScope.speed_call_scope|]; split; [exact GuardSiteMap.actual_helper_guard_site_map|apply GuardExecution.speed_executed_helper_guard; lia]. Qed.
Print Assumptions goal038.
Theorem goal039 : Spec.Goal039.
Proof. unfold Spec.Goal039; split; [exact CanonicalCallScope.speed_call_scope|]; split; [exact GuardSiteMap.actual_helper_guard_site_map|apply GuardExecution.speed_executed_helper_guard; lia]. Qed.
Print Assumptions goal039.
Theorem goal040 : Spec.Goal040.
Proof. unfold Spec.Goal040; split; [exact CanonicalCallScope.speed_call_scope|]; split; [exact GuardSiteMap.actual_helper_guard_site_map|apply GuardExecution.speed_executed_helper_guard; lia]. Qed.
Print Assumptions goal040.
Theorem goal041 : Spec.Goal041.
Proof. unfold Spec.Goal041; split; [exact CanonicalCallScope.speed_call_scope|]; split; [exact GuardSiteMap.actual_helper_guard_site_map|apply GuardExecution.speed_executed_helper_guard; lia]. Qed.
Print Assumptions goal041.
Theorem goal042 : Spec.Goal042.
Proof. unfold Spec.Goal042; split; [exact CanonicalCallScope.speed_call_scope|]; split; [exact GuardSiteMap.actual_helper_guard_site_map|apply GuardExecution.speed_executed_helper_guard; lia]. Qed.
Print Assumptions goal042.
Theorem goal043 : Spec.Goal043.
Proof. unfold Spec.Goal043; split; [exact CanonicalCallScope.speed_call_scope|]; split; [exact GuardSiteMap.actual_helper_guard_site_map|apply GuardExecution.speed_executed_helper_guard; lia]. Qed.
Print Assumptions goal043.
Theorem goal044 : Spec.Goal044.
Proof. unfold Spec.Goal044; split; [exact CanonicalCallScope.speed_call_scope|]; split; [exact GuardSiteMap.actual_helper_guard_site_map|apply GuardExecution.speed_executed_helper_guard; lia]. Qed.
Print Assumptions goal044.
Theorem goal045 : Spec.Goal045.
Proof. unfold Spec.Goal045; split; [exact CanonicalCallScope.speed_call_scope|]; split; [exact GuardSiteMap.actual_helper_guard_site_map|apply GuardExecution.speed_executed_helper_guard; lia]. Qed.
Print Assumptions goal045.
Theorem goal046 : Spec.Goal046.
Proof. unfold Spec.Goal046; split; [exact CanonicalCallScope.speed_call_scope|]; split; [exact GuardSiteMap.actual_helper_guard_site_map|apply GuardExecution.speed_executed_helper_guard; lia]. Qed.
Print Assumptions goal046.
Theorem goal047 : Spec.Goal047.
Proof. unfold Spec.Goal047; split; [exact CanonicalCallScope.speed_call_scope|]; split; [exact GuardSiteMap.actual_helper_guard_site_map|apply GuardExecution.speed_executed_helper_guard; lia]. Qed.
Print Assumptions goal047.
Theorem goal048 : Spec.Goal048.
Proof. unfold Spec.Goal048; split; [exact CanonicalCallScope.speed_call_scope|]; split; [exact GuardSiteMap.actual_helper_guard_site_map|apply GuardExecution.speed_executed_helper_guard; lia]. Qed.
Print Assumptions goal048.
Theorem goal049 : Spec.Goal049.
Proof. unfold Spec.Goal049; split; [exact CanonicalCallScope.speed_call_scope|]; split; [exact GuardSiteMap.actual_helper_guard_site_map|apply GuardExecution.speed_executed_helper_guard; lia]. Qed.
Print Assumptions goal049.
Theorem goal050 : Spec.Goal050.
Proof. unfold Spec.Goal050; split; [exact CanonicalCallScope.speed_call_scope|]; split; [exact GuardSiteMap.actual_helper_guard_site_map|apply GuardExecution.speed_executed_helper_guard; lia]. Qed.
Print Assumptions goal050.
Theorem goal051 : Spec.Goal051.
Proof. unfold Spec.Goal051; split; [exact CanonicalCallScope.speed_call_scope|]; split; [exact GuardSiteMap.actual_helper_guard_site_map|apply GuardExecution.speed_executed_helper_guard; lia]. Qed.
Print Assumptions goal051.
Theorem goal052 : Spec.Goal052.
Proof. unfold Spec.Goal052; split; [exact CanonicalCallScope.speed_call_scope|]; split; [exact GuardSiteMap.actual_helper_guard_site_map|apply GuardExecution.speed_executed_helper_guard; lia]. Qed.
Print Assumptions goal052.
Theorem goal053 : Spec.Goal053.
Proof. unfold Spec.Goal053; split; [exact CanonicalCallScope.speed_call_scope|]; split; [exact GuardSiteMap.actual_helper_guard_site_map|apply GuardExecution.speed_executed_helper_guard; lia]. Qed.
Print Assumptions goal053.
Theorem goal054 : Spec.Goal054.
Proof. unfold Spec.Goal054; split; [exact CanonicalCallScope.speed_call_scope|]; split; [exact GuardSiteMap.actual_helper_guard_site_map|apply GuardExecution.speed_executed_helper_guard; lia]. Qed.
Print Assumptions goal054.
Theorem goal055 : Spec.Goal055.
Proof. unfold Spec.Goal055; split; [exact CanonicalCallScope.speed_call_scope|]; split; [exact GuardSiteMap.actual_helper_guard_site_map|apply GuardExecution.speed_executed_helper_guard; lia]. Qed.
Print Assumptions goal055.
Theorem goal056 : Spec.Goal056.
Proof. unfold Spec.Goal056; split; [exact CanonicalCallScope.speed_call_scope|]; split; [exact GuardSiteMap.actual_helper_guard_site_map|apply GuardExecution.speed_executed_helper_guard; lia]. Qed.
Print Assumptions goal056.
Theorem goal057 : Spec.Goal057.
Proof. unfold Spec.Goal057; split; [exact CanonicalCallScope.speed_call_scope|]; split; [exact GuardSiteMap.actual_helper_guard_site_map|apply GuardExecution.speed_executed_helper_guard; lia]. Qed.
Print Assumptions goal057.
Theorem goal058 : Spec.Goal058.
Proof. unfold Spec.Goal058; split; [exact CanonicalCallScope.speed_call_scope|]; split; [exact GuardSiteMap.actual_helper_guard_site_map|apply GuardExecution.speed_executed_helper_guard; lia]. Qed.
Print Assumptions goal058.
Theorem goal059 : Spec.Goal059.
Proof. unfold Spec.Goal059; split; [exact CanonicalCallScope.speed_call_scope|]; split; [exact GuardSiteMap.actual_helper_guard_site_map|apply GuardExecution.speed_executed_helper_guard; lia]. Qed.
Print Assumptions goal059.
Theorem goal060 : Spec.Goal060.
Proof. unfold Spec.Goal060; split; [exact CanonicalCallScope.speed_call_scope|]; split; [exact GuardSiteMap.actual_helper_guard_site_map|apply GuardExecution.speed_executed_helper_guard; lia]. Qed.
Print Assumptions goal060.
Theorem goal061 : Spec.Goal061.
Proof. unfold Spec.Goal061; split; [exact CanonicalCallScope.speed_call_scope|]; split; [exact GuardSiteMap.actual_helper_guard_site_map|apply GuardExecution.speed_executed_helper_guard; lia]. Qed.
Print Assumptions goal061.
Theorem goal062 : Spec.Goal062.
Proof. unfold Spec.Goal062; split; [exact CanonicalCallScope.speed_call_scope|]; split; [exact GuardSiteMap.actual_helper_guard_site_map|apply GuardExecution.speed_executed_helper_guard; lia]. Qed.
Print Assumptions goal062.
Theorem goal063 : Spec.Goal063.
Proof. unfold Spec.Goal063; apply Adapters.saturation_pointer_guards; lia. Qed.
Print Assumptions goal063.
Theorem goal064 : Spec.Goal064.
Proof. unfold Spec.Goal064; apply Adapters.saturation_pointer_guards; lia. Qed.
Print Assumptions goal064.
Theorem goal065 : Spec.Goal065.
Proof. unfold Spec.Goal065; apply Adapters.saturation_pointer_guards; lia. Qed.
Print Assumptions goal065.
Theorem goal066 : Spec.Goal066.
Proof. unfold Spec.Goal066; apply Adapters.saturation_pointer_guards; lia. Qed.
Print Assumptions goal066.
Theorem goal067 : Spec.Goal067.
Proof. unfold Spec.Goal067; apply Adapters.saturation_pointer_guards; lia. Qed.
Print Assumptions goal067.
Theorem goal068 : Spec.Goal068.
Proof. unfold Spec.Goal068; apply Adapters.saturation_pointer_guards; lia. Qed.
Print Assumptions goal068.
Theorem goal069 : Spec.Goal069.
Proof. unfold Spec.Goal069; apply Adapters.saturation_pointer_guards; lia. Qed.
Print Assumptions goal069.
Theorem goal070 : Spec.Goal070.
Proof. unfold Spec.Goal070; apply Adapters.saturation_pointer_guards; lia. Qed.
Print Assumptions goal070.
Theorem goal071 : Spec.Goal071.
Proof. unfold Spec.Goal071; apply Adapters.saturation_pointer_guards; lia. Qed.
Print Assumptions goal071.
Theorem goal072 : Spec.Goal072.
Proof. unfold Spec.Goal072; apply Adapters.saturation_pointer_guards; lia. Qed.
Print Assumptions goal072.
Theorem goal073 : Spec.Goal073.
Proof. unfold Spec.Goal073; apply Adapters.saturation_pointer_guards; lia. Qed.
Print Assumptions goal073.
Theorem goal074 : Spec.Goal074.
Proof. unfold Spec.Goal074; apply Adapters.saturation_pointer_guards; lia. Qed.
Print Assumptions goal074.
Theorem goal075 : Spec.Goal075.
Proof. unfold Spec.Goal075; apply Adapters.saturation_pointer_guards; lia. Qed.
Print Assumptions goal075.
Theorem goal076 : Spec.Goal076.
Proof. unfold Spec.Goal076; apply Adapters.saturation_pointer_guards; lia. Qed.
Print Assumptions goal076.
Theorem goal077 : Spec.Goal077.
Proof. unfold Spec.Goal077; apply Adapters.saturation_pointer_guards; lia. Qed.
Print Assumptions goal077.
Theorem goal078 : Spec.Goal078.
Proof. unfold Spec.Goal078; apply Adapters.saturation_pointer_guards; lia. Qed.
Print Assumptions goal078.
Theorem goal079 : Spec.Goal079.
Proof. unfold Spec.Goal079; apply Adapters.saturation_pointer_guards; lia. Qed.
Print Assumptions goal079.
Theorem goal080 : Spec.Goal080.
Proof. unfold Spec.Goal080; apply Adapters.saturation_pointer_guards; lia. Qed.
Print Assumptions goal080.
Theorem goal081 : Spec.Goal081.
Proof. unfold Spec.Goal081; apply Adapters.saturation_pointer_guards; lia. Qed.
Print Assumptions goal081.
Theorem goal082 : Spec.Goal082.
Proof. unfold Spec.Goal082; apply Adapters.saturation_pointer_guards; lia. Qed.
Print Assumptions goal082.
Theorem goal083 : Spec.Goal083.
Proof. unfold Spec.Goal083; apply Adapters.saturation_pointer_guards; lia. Qed.
Print Assumptions goal083.
Theorem goal084 : Spec.Goal084.
Proof. unfold Spec.Goal084; apply Adapters.saturation_pointer_guards; lia. Qed.
Print Assumptions goal084.
Theorem goal085 : Spec.Goal085.
Proof. unfold Spec.Goal085; apply Adapters.saturation_pointer_guards; lia. Qed.
Print Assumptions goal085.
Theorem goal086 : Spec.Goal086.
Proof. unfold Spec.Goal086; apply Adapters.saturation_pointer_guards; lia. Qed.
Print Assumptions goal086.
Theorem goal087 : Spec.Goal087.
Proof. unfold Spec.Goal087; apply Adapters.entry_guards; lia. Qed.
Print Assumptions goal087.
Theorem goal088 : Spec.Goal088.
Proof. unfold Spec.Goal088; apply Adapters.entry_guards; lia. Qed.
Print Assumptions goal088.
Theorem goal089 : Spec.Goal089.
Proof. unfold Spec.Goal089; apply Adapters.entry_guards; lia. Qed.
Print Assumptions goal089.
Theorem goal090 : Spec.Goal090.
Proof. unfold Spec.Goal090; apply Adapters.entry_guards; lia. Qed.
Print Assumptions goal090.
Theorem goal091 : Spec.Goal091.
Proof. unfold Spec.Goal091; apply Adapters.main_guards; lia. Qed.
Print Assumptions goal091.
Theorem goal092 : Spec.Goal092.
Proof. unfold Spec.Goal092; apply Adapters.main_guards; lia. Qed.
Print Assumptions goal092.
Theorem goal093 : Spec.Goal093.
Proof. unfold Spec.Goal093; apply Adapters.main_guards; lia. Qed.
Print Assumptions goal093.
Theorem goal094 : Spec.Goal094.
Proof. unfold Spec.Goal094; apply Adapters.main_guards; lia. Qed.
Print Assumptions goal094.
Theorem goal095 : Spec.Goal095.
Proof. unfold Spec.Goal095; apply Adapters.main_guards; lia. Qed.
Print Assumptions goal095.
Theorem goal096 : Spec.Goal096.
Proof. unfold Spec.Goal096; apply Adapters.main_guards; lia. Qed.
Print Assumptions goal096.
Theorem goal097 : Spec.Goal097.
Proof. unfold Spec.Goal097; apply Adapters.main_guards; lia. Qed.
Print Assumptions goal097.
Theorem goal098 : Spec.Goal098.
Proof. unfold Spec.Goal098; apply Adapters.manual_speed_assertions; lia. Qed.
Print Assumptions goal098.
Theorem goal099 : Spec.Goal099.
Proof. unfold Spec.Goal099; apply Adapters.manual_speed_assertions; lia. Qed.
Print Assumptions goal099.
Theorem goal100 : Spec.Goal100.
Proof. unfold Spec.Goal100; apply Adapters.manual_speed_assertions; lia. Qed.
Print Assumptions goal100.
Theorem goal101 : Spec.Goal101.
Proof. unfold Spec.Goal101; apply Adapters.main_guards; lia. Qed.
Print Assumptions goal101.
Theorem goal102 : Spec.Goal102.
Proof. unfold Spec.Goal102; apply Adapters.manual_speed_assertions; lia. Qed.
Print Assumptions goal102.
Theorem goal103 : Spec.Goal103.
Proof. unfold Spec.Goal103; apply Adapters.manual_speed_assertions; lia. Qed.
Print Assumptions goal103.
Theorem goal104 : Spec.Goal104.
Proof. unfold Spec.Goal104; apply Adapters.manual_speed_assertions; lia. Qed.
Print Assumptions goal104.
Theorem goal105 : Spec.Goal105.
Proof. unfold Spec.Goal105; apply Adapters.manual_speed_assertions; lia. Qed.
Print Assumptions goal105.
Theorem goal106 : Spec.Goal106.
Proof. unfold Spec.Goal106; apply Adapters.main_guards; lia. Qed.
Print Assumptions goal106.
Theorem goal107 : Spec.Goal107.
Proof. unfold Spec.Goal107; apply Adapters.main_guards; lia. Qed.
Print Assumptions goal107.
Theorem goal108 : Spec.Goal108.
Proof. unfold Spec.Goal108; apply Adapters.main_guards; lia. Qed.
Print Assumptions goal108.
Theorem goal109 : Spec.Goal109.
Proof. unfold Spec.Goal109; apply Adapters.main_guards; lia. Qed.
Print Assumptions goal109.
Theorem goal110 : Spec.Goal110.
Proof. unfold Spec.Goal110; apply Adapters.main_guards; lia. Qed.
Print Assumptions goal110.
Theorem goal111 : Spec.Goal111.
Proof. unfold Spec.Goal111; apply Adapters.main_guards; lia. Qed.
Print Assumptions goal111.
Theorem goal112 : Spec.Goal112.
Proof. unfold Spec.Goal112; apply Adapters.main_guards; lia. Qed.
Print Assumptions goal112.
Theorem goal113 : Spec.Goal113.
Proof. unfold Spec.Goal113; apply Adapters.manual_speed_assertions; lia. Qed.
Print Assumptions goal113.
Theorem goal114 : Spec.Goal114.
Proof. unfold Spec.Goal114; apply Adapters.manual_speed_assertions; lia. Qed.
Print Assumptions goal114.
Theorem goal115 : Spec.Goal115.
Proof. unfold Spec.Goal115; apply Adapters.manual_speed_assertions; lia. Qed.
Print Assumptions goal115.
Theorem goal116 : Spec.Goal116.
Proof. unfold Spec.Goal116; apply Adapters.main_guards; lia. Qed.
Print Assumptions goal116.
Theorem goal117 : Spec.Goal117.
Proof. unfold Spec.Goal117; apply Adapters.manual_speed_assertions; lia. Qed.
Print Assumptions goal117.
Theorem goal118 : Spec.Goal118.
Proof. unfold Spec.Goal118; apply Adapters.manual_speed_assertions; lia. Qed.
Print Assumptions goal118.
Theorem goal119 : Spec.Goal119.
Proof. unfold Spec.Goal119; apply Adapters.manual_speed_assertions; lia. Qed.
Print Assumptions goal119.
Theorem goal120 : Spec.Goal120.
Proof. unfold Spec.Goal120; apply Adapters.manual_speed_assertions; lia. Qed.
Print Assumptions goal120.
Theorem goal121 : Spec.Goal121.
Proof. unfold Spec.Goal121; apply Adapters.memcpy_guards; lia. Qed.
Print Assumptions goal121.
Theorem goal122 : Spec.Goal122.
Proof. unfold Spec.Goal122; apply Adapters.memcpy_guards; lia. Qed.
Print Assumptions goal122.
