From Stdlib Require Import List ZArith Lia.
From compcert Require Import Integers Floats AST Values Memory Memdata Events Csem Smallstep.
From FiveInv2Recheck Require Import Spec.
From FiveMatInv3Case Require Import MatrixMemory.
From FiveInv2Case Require Import Contract Call RecheckSupport Memcpy16 Replay TraceInputs ExactReplay ObserverComposition WordObserver RejectedCopyComposition.
From FiveMatrixInverseSupport Require Import Kernels.
Import ListNotations.
Local Open Scope Z_scope.
Lemma call_post:forall m bo bi po pi f,Inputs m bo bi po pi f->forall t result mf,star Csem.step Execution.ge(Execution.entry(Args bo bi po pi)m)t(Returnstate result Kstop mf)->result=Result f/\Post m mf bo bi po pi f.
Proof. intros m bo bi po pi f IN t result mf PATH;destruct(call_summary m bo bi po pi f IN)as[after[EX[POST[SAFE ALL]]]];destruct(ALL t result mf PATH)as[R M];subst result mf;auto. Qed.
Lemma copy_guard_proved:forall k,CopyGuard k.
Proof. intros k m src dst PRE;pose proof(copy_pre_safety m src dst PRE)as[NE A B EN C D SEP RD WR].
 destruct k as[|[|[|[|[|[|[|[|k]]]]]]]];simpl;auto;intros order[EQ Q];congruence. Qed.
Lemma case_status:forall f expected,Result f=expected->CaseStatus f expected.
Proof. intros f expected EQ m bo bi po pi IN t result mf PATH;rewrite(proj1(call_post m bo bi po pi f IN t result mf PATH));exact EQ. Qed.
Lemma case_words:forall f words,Reject f=false->map(fun i=>Float32.to_bits(Output f i))[0;1;2;3]=map Int.repr words->CaseWords f words.
Proof. intros f words REJ WORD m bo bi pi IN t result mf PATH dst bytes obs READ STORE.
 pose proof(proj2(call_post m bo bi Ptrofs.zero pi f IN t result mf PATH))as POST.
 transitivity(map(fun i=>Some(Vint(Float32.to_bits(Output f i))))[0;1;2;3]).
 - apply map_ext_in;intros i INDEX;eapply successful_copy_words;[exact POST|exact REJ|exact READ|exact STORE|];simpl in INDEX;repeat destruct INDEX as[EQ|INDEX];try contradiction;subst i;lia.
 - change(map(fun w=>Some(Vint w))(map(fun i=>Float32.to_bits(Output f i))[0;1;2;3])=map(fun w=>Some(Vint(Int.repr w)))words);rewrite WORD,map_map;reflexivity. Qed.
Lemma case_preserves:forall f,Reject f=true->CasePreserves f.
Proof. intros f REJ m bo bi po pi IN t result mf PATH;destruct(proj2(call_post m bo bi po pi f IN t result mf PATH))as[W[RD[FR[VB[BY AC]]]]];rewrite REJ in BY;exact BY. Qed.
Lemma assertion_1:Assertion1.
Proof. intros m bo bi po pi f IN t result mf PATH;rewrite(proj1(call_post m bo bi po pi f IN t result mf PATH));unfold Result;destruct(Reject f);auto. Qed.
Lemma assertion_2:Assertion2.
Proof. intros m bo bi pi f before after IN BEFORE AFTER t result mf PATH.
 destruct(proj2(call_post m bo bi(Ptrofs.repr 4)pi f IN t result mf PATH))as[W[RD[FR REST]]].
 assert(VO:Mem.valid_block m bo)by(destruct IN as[NE[WO RI]];exact(writable_valid m bo(Ptrofs.repr 4)4 ltac:(lia)WO)).
 split;[exact FR|];split.
 - eapply(frame_load_kept m mf bo(Ptrofs.repr 4)bo 0 Mint32(Vint before));[exact FR|exact VO|right;left;change(0+4<=4);lia|exact BEFORE].
 - eapply(frame_load_kept m mf bo(Ptrofs.repr 4)bo 20 Mint32(Vint after));[exact FR|exact VO|right;right;change(4+16<=20);lia|exact AFTER]. Qed.
Lemma assertion_3:CaseStatus base2(Vint Int.zero).
Proof. apply case_status;exact(proj1 base2_kernel). Qed.
Lemma assertion_4:CaseWords base2[1065353216;2147483648;2147483648;1065353216].
Proof. apply case_words;[vm_compute;reflexivity|exact(proj2(proj2 base2_kernel))]. Qed.
Lemma assertion_5:CaseStatus small2(Vint Int.one).
Proof. apply case_status;exact(proj1 small2_kernel). Qed.
Lemma assertion_6:CasePreserves small2.
Proof. apply case_preserves;vm_compute;reflexivity. Qed.
Lemma assertion_7:CaseStatus large2(Vint Int.zero).
Proof. apply case_status;exact(proj1 large2_kernel). Qed.
Lemma assertion_8:CaseWords large2[0;2147483648;2147483648;0].
Proof. apply case_words;[vm_compute;reflexivity|exact(proj2(proj2 large2_kernel))]. Qed.
Lemma assertion_9:OriginalReplay /\ Result base2<>Result small2 /\ TraceNonempty.
Proof. split;[exact original_trace_four_calls|];split;[exact RefuteScaleStatus2|exact original_trace_nonempty]. Qed.
Lemma assertion_10:OriginalReplay /\ Result large2=Vint Int.zero /\ SmallResidual(residual2 large2)=false /\ Float32.to_bits(residual2 large2)=Int.repr 3212836864 /\ TraceNonempty.
Proof. destruct original_trace_residual_failure as[REPLAY[STATUS[BAD BITS]]];split;[exact REPLAY|];split;[exact STATUS|];split;[exact BAD|];split;[exact BITS|exact original_trace_nonempty]. Qed.
Theorem property_001:Spec.P001.
Proof. apply source_guards. Qed.
Print Assumptions property_001.
Theorem property_002:Spec.P002.
Proof. apply source_guards. Qed.
Print Assumptions property_002.
Theorem property_003:Spec.P003.
Proof. apply source_guards. Qed.
Print Assumptions property_003.
Theorem property_004:Spec.P004.
Proof. apply source_guards. Qed.
Print Assumptions property_004.
Theorem property_005:Spec.P005.
Proof. apply source_guards. Qed.
Print Assumptions property_005.
Theorem property_006:Spec.P006.
Proof. apply source_guards. Qed.
Print Assumptions property_006.
Theorem property_007:Spec.P007.
Proof. apply source_guards. Qed.
Print Assumptions property_007.
Theorem property_008:Spec.P008.
Proof. apply source_guards. Qed.
Print Assumptions property_008.
Theorem property_009:Spec.P009.
Proof. apply source_guards. Qed.
Print Assumptions property_009.
Theorem property_010:Spec.P010.
Proof. apply source_guards. Qed.
Print Assumptions property_010.
Theorem property_011:Spec.P011.
Proof. apply source_guards. Qed.
Print Assumptions property_011.
Theorem property_012:Spec.P012.
Proof. apply source_guards. Qed.
Print Assumptions property_012.
Theorem property_013:Spec.P013.
Proof. apply source_guards. Qed.
Print Assumptions property_013.
Theorem property_014:Spec.P014.
Proof. apply source_guards. Qed.
Print Assumptions property_014.
Theorem property_015:Spec.P015.
Proof. apply source_guards. Qed.
Print Assumptions property_015.
Theorem property_016:Spec.P016.
Proof. apply source_guards. Qed.
Print Assumptions property_016.
Theorem property_017:Spec.P017.
Proof. apply source_guards. Qed.
Print Assumptions property_017.
Theorem property_018:Spec.P018.
Proof. apply source_guards. Qed.
Print Assumptions property_018.
Theorem property_019:Spec.P019.
Proof. apply source_guards. Qed.
Print Assumptions property_019.
Theorem property_020:Spec.P020.
Proof. apply source_guards. Qed.
Print Assumptions property_020.
Theorem property_021:Spec.P021.
Proof. apply source_guards. Qed.
Print Assumptions property_021.
Theorem property_022:Spec.P022.
Proof. apply source_guards. Qed.
Print Assumptions property_022.
Theorem property_023:Spec.P023.
Proof. apply source_guards. Qed.
Print Assumptions property_023.
Theorem property_024:Spec.P024.
Proof. apply source_guards. Qed.
Print Assumptions property_024.
Theorem property_025:Spec.P025.
Proof. apply source_guards. Qed.
Print Assumptions property_025.
Theorem property_026:Spec.P026.
Proof. apply source_guards. Qed.
Print Assumptions property_026.
Theorem property_027:Spec.P027.
Proof. apply source_guards. Qed.
Print Assumptions property_027.
Theorem property_028:Spec.P028.
Proof. apply source_guards. Qed.
Print Assumptions property_028.
Theorem property_029:Spec.P029.
Proof. apply source_guards. Qed.
Print Assumptions property_029.
Theorem property_030:Spec.P030.
Proof. apply source_guards. Qed.
Print Assumptions property_030.
Theorem property_031:Spec.P031.
Proof. apply source_guards. Qed.
Print Assumptions property_031.
Theorem property_032:Spec.P032.
Proof. apply source_guards. Qed.
Print Assumptions property_032.
Theorem property_033:Spec.P033.
Proof. apply source_guards. Qed.
Print Assumptions property_033.
Theorem property_034:Spec.P034.
Proof. apply source_guards. Qed.
Print Assumptions property_034.
Theorem property_035:Spec.P035.
Proof. apply source_guards. Qed.
Print Assumptions property_035.
Theorem property_036:Spec.P036.
Proof. apply source_guards. Qed.
Print Assumptions property_036.
Theorem property_037:Spec.P037.
Proof. apply source_guards. Qed.
Print Assumptions property_037.
Theorem property_038:Spec.P038.
Proof. apply source_guards. Qed.
Print Assumptions property_038.
Theorem property_039:Spec.P039.
Proof. apply source_guards. Qed.
Print Assumptions property_039.
Theorem property_040:Spec.P040.
Proof. apply source_guards. Qed.
Print Assumptions property_040.
Theorem property_041:Spec.P041.
Proof. apply source_guards. Qed.
Print Assumptions property_041.
Theorem property_042:Spec.P042.
Proof. apply source_guards. Qed.
Print Assumptions property_042.
Theorem property_043:Spec.P043.
Proof. apply source_guards. Qed.
Print Assumptions property_043.
Theorem property_044:Spec.P044.
Proof. apply source_guards. Qed.
Print Assumptions property_044.
Theorem property_045:Spec.P045.
Proof. apply source_guards. Qed.
Print Assumptions property_045.
Theorem property_046:Spec.P046.
Proof. apply source_guards. Qed.
Print Assumptions property_046.
Theorem property_047:Spec.P047.
Proof. apply source_guards. Qed.
Print Assumptions property_047.
Theorem property_048:Spec.P048.
Proof. apply source_guards. Qed.
Print Assumptions property_048.
Theorem property_049:Spec.P049.
Proof. apply source_guards. Qed.
Print Assumptions property_049.
Theorem property_050:Spec.P050.
Proof. apply source_guards. Qed.
Print Assumptions property_050.
Theorem property_051:Spec.P051.
Proof. apply source_guards. Qed.
Print Assumptions property_051.
Theorem property_052:Spec.P052.
Proof. apply source_guards. Qed.
Print Assumptions property_052.
Theorem property_053:Spec.P053.
Proof. apply source_guards. Qed.
Print Assumptions property_053.
Theorem property_054:Spec.P054.
Proof. apply source_guards. Qed.
Print Assumptions property_054.
Theorem property_055:Spec.P055.
Proof. apply source_guards. Qed.
Print Assumptions property_055.
Theorem property_056:Spec.P056.
Proof. apply source_guards. Qed.
Print Assumptions property_056.
Theorem property_057:Spec.P057.
Proof. apply source_guards. Qed.
Print Assumptions property_057.
Theorem property_058:Spec.P058.
Proof. apply source_guards. Qed.
Print Assumptions property_058.
Theorem property_059:Spec.P059.
Proof. apply source_guards. Qed.
Print Assumptions property_059.
Theorem property_060:Spec.P060.
Proof. apply source_guards. Qed.
Print Assumptions property_060.
Theorem property_061:Spec.P061.
Proof. apply source_guards. Qed.
Print Assumptions property_061.
Theorem property_062:Spec.P062.
Proof. apply source_guards. Qed.
Print Assumptions property_062.
Theorem property_063:Spec.P063.
Proof. apply source_guards. Qed.
Print Assumptions property_063.
Theorem property_064:Spec.P064.
Proof. apply source_guards. Qed.
Print Assumptions property_064.
Theorem property_065:Spec.P065.
Proof. apply source_guards. Qed.
Print Assumptions property_065.
Theorem property_066:Spec.P066.
Proof. apply source_guards. Qed.
Print Assumptions property_066.
Theorem property_067:Spec.P067.
Proof. apply source_guards. Qed.
Print Assumptions property_067.
Theorem property_068:Spec.P068.
Proof. apply source_guards. Qed.
Print Assumptions property_068.
Theorem property_069:Spec.P069.
Proof. apply source_guards. Qed.
Print Assumptions property_069.
Theorem property_070:Spec.P070.
Proof. apply source_guards. Qed.
Print Assumptions property_070.
Theorem property_071:Spec.P071.
Proof. apply source_guards. Qed.
Print Assumptions property_071.
Theorem property_072:Spec.P072.
Proof. apply source_guards. Qed.
Print Assumptions property_072.
Theorem property_073:Spec.P073.
Proof. apply source_guards. Qed.
Print Assumptions property_073.
Theorem property_074:Spec.P074.
Proof. apply source_guards. Qed.
Print Assumptions property_074.
Theorem property_075:Spec.P075.
Proof. apply source_guards. Qed.
Print Assumptions property_075.
Theorem property_076:Spec.P076.
Proof. apply source_guards. Qed.
Print Assumptions property_076.
Theorem property_077:Spec.P077.
Proof. apply source_guards. Qed.
Print Assumptions property_077.
Theorem property_078:Spec.P078.
Proof. apply source_guards. Qed.
Print Assumptions property_078.
Theorem property_079:Spec.P079.
Proof. apply source_guards. Qed.
Print Assumptions property_079.
Theorem property_080:Spec.P080.
Proof. apply source_guards. Qed.
Print Assumptions property_080.
Theorem property_081:Spec.P081.
Proof. apply source_guards. Qed.
Print Assumptions property_081.
Theorem property_082:Spec.P082.
Proof. apply source_guards. Qed.
Print Assumptions property_082.
Theorem property_083:Spec.P083.
Proof. apply source_guards. Qed.
Print Assumptions property_083.
Theorem property_084:Spec.P084.
Proof. apply source_guards. Qed.
Print Assumptions property_084.
Theorem property_085:Spec.P085.
Proof. apply source_guards. Qed.
Print Assumptions property_085.
Theorem property_086:Spec.P086.
Proof. apply source_guards. Qed.
Print Assumptions property_086.
Theorem property_087:Spec.P087.
Proof. apply source_guards. Qed.
Print Assumptions property_087.
Theorem property_088:Spec.P088.
Proof. apply source_guards. Qed.
Print Assumptions property_088.
Theorem property_089:Spec.P089.
Proof. apply source_guards. Qed.
Print Assumptions property_089.
Theorem property_090:Spec.P090.
Proof. apply source_guards. Qed.
Print Assumptions property_090.
Theorem property_091:Spec.P091.
Proof. apply source_guards. Qed.
Print Assumptions property_091.
Theorem property_092:Spec.P092.
Proof. apply source_guards. Qed.
Print Assumptions property_092.
Theorem property_093:Spec.P093.
Proof. apply source_guards. Qed.
Print Assumptions property_093.
Theorem property_094:Spec.P094.
Proof. apply source_guards. Qed.
Print Assumptions property_094.
Theorem property_095:Spec.P095.
Proof. apply source_guards. Qed.
Print Assumptions property_095.
Theorem property_096:Spec.P096.
Proof. apply source_guards. Qed.
Print Assumptions property_096.
Theorem property_097:Spec.P097.
Proof. apply source_guards. Qed.
Print Assumptions property_097.
Theorem property_098:Spec.P098.
Proof. apply source_guards. Qed.
Print Assumptions property_098.
Theorem property_099:Spec.P099.
Proof. apply source_guards. Qed.
Print Assumptions property_099.
Theorem property_100:Spec.P100.
Proof. apply source_guards. Qed.
Print Assumptions property_100.
Theorem property_101:Spec.P101.
Proof. apply source_guards. Qed.
Print Assumptions property_101.
Theorem property_102:Spec.P102.
Proof. apply source_guards. Qed.
Print Assumptions property_102.
Theorem property_103:Spec.P103.
Proof. apply source_guards. Qed.
Print Assumptions property_103.
Theorem property_104:Spec.P104.
Proof. apply source_guards. Qed.
Print Assumptions property_104.
Theorem property_105:Spec.P105.
Proof. apply source_guards. Qed.
Print Assumptions property_105.
Theorem property_106:Spec.P106.
Proof. apply source_guards. Qed.
Print Assumptions property_106.
Theorem property_107:Spec.P107.
Proof. apply source_guards. Qed.
Print Assumptions property_107.
Theorem property_108:Spec.P108.
Proof. apply source_guards. Qed.
Print Assumptions property_108.
Theorem property_109:Spec.P109.
Proof. apply source_guards. Qed.
Print Assumptions property_109.
Theorem property_110:Spec.P110.
Proof. apply source_guards. Qed.
Print Assumptions property_110.
Theorem property_111:Spec.P111.
Proof. apply source_guards. Qed.
Print Assumptions property_111.
Theorem property_112:Spec.P112.
Proof. apply source_guards. Qed.
Print Assumptions property_112.
Theorem property_113:Spec.P113.
Proof. apply source_guards. Qed.
Print Assumptions property_113.
Theorem property_114:Spec.P114.
Proof. apply source_guards. Qed.
Print Assumptions property_114.
Theorem property_115:Spec.P115.
Proof. apply source_guards. Qed.
Print Assumptions property_115.
Theorem property_116:Spec.P116.
Proof. apply source_guards. Qed.
Print Assumptions property_116.
Theorem property_117:Spec.P117.
Proof. apply source_guards. Qed.
Print Assumptions property_117.
Theorem property_118:Spec.P118.
Proof. apply source_guards. Qed.
Print Assumptions property_118.
Theorem property_119:Spec.P119.
Proof. apply source_guards. Qed.
Print Assumptions property_119.
Theorem property_120:Spec.P120.
Proof. apply source_guards. Qed.
Print Assumptions property_120.
Theorem property_121:Spec.P121.
Proof. apply source_guards. Qed.
Print Assumptions property_121.
Theorem property_122:Spec.P122.
Proof. apply source_guards. Qed.
Print Assumptions property_122.
Theorem property_123:Spec.P123.
Proof. apply source_guards. Qed.
Print Assumptions property_123.
Theorem property_124:Spec.P124.
Proof. apply source_guards. Qed.
Print Assumptions property_124.
Theorem property_125:Spec.P125.
Proof. apply source_guards. Qed.
Print Assumptions property_125.
Theorem property_126:Spec.P126.
Proof. apply source_guards. Qed.
Print Assumptions property_126.
Theorem property_127:Spec.P127.
Proof. apply source_guards. Qed.
Print Assumptions property_127.
Theorem property_128:Spec.P128.
Proof. apply source_guards. Qed.
Print Assumptions property_128.
Theorem property_129:Spec.P129.
Proof. apply source_guards. Qed.
Print Assumptions property_129.
Theorem property_130:Spec.P130.
Proof. apply source_guards. Qed.
Print Assumptions property_130.
Theorem property_131:Spec.P131.
Proof. apply source_guards. Qed.
Print Assumptions property_131.
Theorem property_132:Spec.P132.
Proof. apply source_guards. Qed.
Print Assumptions property_132.
Theorem property_133:Spec.P133.
Proof. apply source_guards. Qed.
Print Assumptions property_133.
Theorem property_134:Spec.P134.
Proof. apply source_guards. Qed.
Print Assumptions property_134.
Theorem property_135:Spec.P135.
Proof. apply source_guards. Qed.
Print Assumptions property_135.
Theorem property_136:Spec.P136.
Proof. apply source_guards. Qed.
Print Assumptions property_136.
Theorem property_137:Spec.P137.
Proof. apply source_guards. Qed.
Print Assumptions property_137.
Theorem property_138:Spec.P138.
Proof. apply source_guards. Qed.
Print Assumptions property_138.
Theorem property_139:Spec.P139.
Proof. apply source_guards. Qed.
Print Assumptions property_139.
Theorem property_140:Spec.P140.
Proof. apply source_guards. Qed.
Print Assumptions property_140.
Theorem property_141:Spec.P141.
Proof. apply source_guards. Qed.
Print Assumptions property_141.
Theorem property_142:Spec.P142.
Proof. apply source_guards. Qed.
Print Assumptions property_142.
Theorem property_143:Spec.P143.
Proof. apply source_guards. Qed.
Print Assumptions property_143.
Theorem property_144:Spec.P144.
Proof. apply source_guards. Qed.
Print Assumptions property_144.
Theorem property_145:Spec.P145.
Proof. exact assertion_1. Qed.
Print Assumptions property_145.
Theorem property_146:Spec.P146.
Proof. exact assertion_2. Qed.
Print Assumptions property_146.
Theorem property_147:Spec.P147.
Proof. apply copy_guard_proved. Qed.
Print Assumptions property_147.
Theorem property_148:Spec.P148.
Proof. apply copy_guard_proved. Qed.
Print Assumptions property_148.
Theorem property_149:Spec.P149.
Proof. apply copy_guard_proved. Qed.
Print Assumptions property_149.
Theorem property_150:Spec.P150.
Proof. apply copy_guard_proved. Qed.
Print Assumptions property_150.
Theorem property_151:Spec.P151.
Proof. apply copy_guard_proved. Qed.
Print Assumptions property_151.
Theorem property_152:Spec.P152.
Proof. apply copy_guard_proved. Qed.
Print Assumptions property_152.
Theorem property_153:Spec.P153.
Proof. apply copy_guard_proved. Qed.
Print Assumptions property_153.
Theorem property_154:Spec.P154.
Proof. apply copy_guard_proved. Qed.
Print Assumptions property_154.
Theorem property_155:Spec.P155.
Proof. apply copy_guard_proved. Qed.
Print Assumptions property_155.
Theorem property_156:Spec.P156.
Proof. apply copy_guard_proved. Qed.
Print Assumptions property_156.
Theorem property_157:Spec.P157.
Proof. apply copy_guard_proved. Qed.
Print Assumptions property_157.
Theorem property_158:Spec.P158.
Proof. apply copy_guard_proved. Qed.
Print Assumptions property_158.
Theorem property_159:Spec.P159.
Proof. apply copy_guard_proved. Qed.
Print Assumptions property_159.
Theorem property_160:Spec.P160.
Proof. apply copy_guard_proved. Qed.
Print Assumptions property_160.
Theorem property_161:Spec.P161.
Proof. apply copy_guard_proved. Qed.
Print Assumptions property_161.
Theorem property_162:Spec.P162.
Proof. apply copy_guard_proved. Qed.
Print Assumptions property_162.
Theorem property_163:Spec.P163.
Proof. apply copy_guard_proved. Qed.
Print Assumptions property_163.
Theorem property_164:Spec.P164.
Proof. apply copy_guard_proved. Qed.
Print Assumptions property_164.
Theorem property_165:Spec.P165.
Proof. apply copy_guard_proved. Qed.
Print Assumptions property_165.
Theorem property_166:Spec.P166.
Proof. apply copy_guard_proved. Qed.
Print Assumptions property_166.
Theorem property_167:Spec.P167.
Proof. apply copy_guard_proved. Qed.
Print Assumptions property_167.
Theorem property_168:Spec.P168.
Proof. apply copy_guard_proved. Qed.
Print Assumptions property_168.
Theorem property_169:Spec.P169.
Proof. apply copy_guard_proved. Qed.
Print Assumptions property_169.
Theorem property_170:Spec.P170.
Proof. apply copy_guard_proved. Qed.
Print Assumptions property_170.
Theorem property_171:Spec.P171.
Proof. apply copy_guard_proved. Qed.
Print Assumptions property_171.
Theorem property_172:Spec.P172.
Proof. apply copy_guard_proved. Qed.
Print Assumptions property_172.
Theorem property_173:Spec.P173.
Proof. apply copy_guard_proved. Qed.
Print Assumptions property_173.
Theorem property_174:Spec.P174.
Proof. apply copy_guard_proved. Qed.
Print Assumptions property_174.
Theorem property_175:Spec.P175.
Proof. apply copy_guard_proved. Qed.
Print Assumptions property_175.
Theorem property_176:Spec.P176.
Proof. apply copy_guard_proved. Qed.
Print Assumptions property_176.
Theorem property_177:Spec.P177.
Proof. apply copy_guard_proved. Qed.
Print Assumptions property_177.
Theorem property_178:Spec.P178.
Proof. apply copy_guard_proved. Qed.
Print Assumptions property_178.
Theorem property_179:Spec.P179.
Proof. apply copy_guard_proved. Qed.
Print Assumptions property_179.
Theorem property_180:Spec.P180.
Proof. apply copy_guard_proved. Qed.
Print Assumptions property_180.
Theorem property_181:Spec.P181.
Proof. apply copy_guard_proved. Qed.
Print Assumptions property_181.
Theorem property_182:Spec.P182.
Proof. apply copy_guard_proved. Qed.
Print Assumptions property_182.
Theorem property_183:Spec.P183.
Proof. exact assertion_3. Qed.
Print Assumptions property_183.
Theorem property_184:Spec.P184.
Proof. split;[exact assertion_4|exact WordObserver.composed_assertion4]. Qed.
Print Assumptions property_184.
Theorem property_185:Spec.P185.
Proof. exact assertion_5. Qed.
Print Assumptions property_185.
Theorem property_186:Spec.P186.
Proof. split;[exact assertion_6|exact RejectedCopyComposition.composed_assertion6]. Qed.
Print Assumptions property_186.
Theorem property_187:Spec.P187.
Proof. exact assertion_7. Qed.
Print Assumptions property_187.
Theorem property_188:Spec.P188.
Proof. split;[exact assertion_8|exact WordObserver.composed_assertion8]. Qed.
Print Assumptions property_188.
Theorem property_189:Spec.P189.
Proof. split;[exact assertion_9|exact ObserverComposition.composed_refutation9]. Qed.
Print Assumptions property_189.
Theorem property_190:Spec.P190.
Proof. split;[exact assertion_10|exact ObserverComposition.composed_refutation10]. Qed.
Print Assumptions property_190.
