From Coq Require Import String List ZArith.
From compcert Require Import Coqlib Integers Floats Values AST Ctypes Cop Csyntax Csyntaxdefs.
Import Csyntaxdefs.CsyntaxNotations.
Local Open Scope Z_scope.
Local Open Scope string_scope.
Local Open Scope csyntax_scope.

Module Info.
  Definition version := "3.17".
  Definition build_number := "".
  Definition build_tag := "".
  Definition build_branch := "".
  Definition arch := "x86".
  Definition model := "64".
  Definition abi := "standard".
  Definition bitsize := 64.
  Definition big_endian := false.
  Definition source_file := "/home/yangfp/five/_build/paparazzi/navigation-vision-models/magnetic_field/model/preprocessed.i".
End Info.

Definition ___builtin_ais_annot : ident := $"__builtin_ais_annot".
Definition ___builtin_annot : ident := $"__builtin_annot".
Definition ___builtin_annot_intval : ident := $"__builtin_annot_intval".
Definition ___builtin_bswap : ident := $"__builtin_bswap".
Definition ___builtin_bswap16 : ident := $"__builtin_bswap16".
Definition ___builtin_bswap32 : ident := $"__builtin_bswap32".
Definition ___builtin_bswap64 : ident := $"__builtin_bswap64".
Definition ___builtin_clz : ident := $"__builtin_clz".
Definition ___builtin_clzl : ident := $"__builtin_clzl".
Definition ___builtin_clzll : ident := $"__builtin_clzll".
Definition ___builtin_ctz : ident := $"__builtin_ctz".
Definition ___builtin_ctzl : ident := $"__builtin_ctzl".
Definition ___builtin_ctzll : ident := $"__builtin_ctzll".
Definition ___builtin_debug : ident := $"__builtin_debug".
Definition ___builtin_expect : ident := $"__builtin_expect".
Definition ___builtin_fabs : ident := $"__builtin_fabs".
Definition ___builtin_fabsf : ident := $"__builtin_fabsf".
Definition ___builtin_fmadd : ident := $"__builtin_fmadd".
Definition ___builtin_fmax : ident := $"__builtin_fmax".
Definition ___builtin_fmin : ident := $"__builtin_fmin".
Definition ___builtin_fmsub : ident := $"__builtin_fmsub".
Definition ___builtin_fnmadd : ident := $"__builtin_fnmadd".
Definition ___builtin_fnmsub : ident := $"__builtin_fnmsub".
Definition ___builtin_fsqrt : ident := $"__builtin_fsqrt".
Definition ___builtin_membar : ident := $"__builtin_membar".
Definition ___builtin_memcpy_aligned : ident := $"__builtin_memcpy_aligned".
Definition ___builtin_read16_reversed : ident := $"__builtin_read16_reversed".
Definition ___builtin_read32_reversed : ident := $"__builtin_read32_reversed".
Definition ___builtin_sel : ident := $"__builtin_sel".
Definition ___builtin_sqrt : ident := $"__builtin_sqrt".
Definition ___builtin_unreachable : ident := $"__builtin_unreachable".
Definition ___builtin_va_arg : ident := $"__builtin_va_arg".
Definition ___builtin_va_copy : ident := $"__builtin_va_copy".
Definition ___builtin_va_end : ident := $"__builtin_va_end".
Definition ___builtin_va_start : ident := $"__builtin_va_start".
Definition ___builtin_write16_reversed : ident := $"__builtin_write16_reversed".
Definition ___builtin_write32_reversed : ident := $"__builtin_write32_reversed".
Definition ___compcert_i64_dtos : ident := $"__compcert_i64_dtos".
Definition ___compcert_i64_dtou : ident := $"__compcert_i64_dtou".
Definition ___compcert_i64_sar : ident := $"__compcert_i64_sar".
Definition ___compcert_i64_sdiv : ident := $"__compcert_i64_sdiv".
Definition ___compcert_i64_shl : ident := $"__compcert_i64_shl".
Definition ___compcert_i64_shr : ident := $"__compcert_i64_shr".
Definition ___compcert_i64_smod : ident := $"__compcert_i64_smod".
Definition ___compcert_i64_smulh : ident := $"__compcert_i64_smulh".
Definition ___compcert_i64_stod : ident := $"__compcert_i64_stod".
Definition ___compcert_i64_stof : ident := $"__compcert_i64_stof".
Definition ___compcert_i64_udiv : ident := $"__compcert_i64_udiv".
Definition ___compcert_i64_umod : ident := $"__compcert_i64_umod".
Definition ___compcert_i64_umulh : ident := $"__compcert_i64_umulh".
Definition ___compcert_i64_utod : ident := $"__compcert_i64_utod".
Definition ___compcert_i64_utof : ident := $"__compcert_i64_utof".
Definition ___compcert_va_composite : ident := $"__compcert_va_composite".
Definition ___compcert_va_float64 : ident := $"__compcert_va_float64".
Definition ___compcert_va_int32 : ident := $"__compcert_va_int32".
Definition ___compcert_va_int64 : ident := $"__compcert_va_int64".
Definition _a2 : ident := $"a2".
Definition _aa : ident := $"aa".
Definition _argument : ident := $"argument".
Definition _b2 : ident := $"b2".
Definition _bb : ident := $"bb".
Definition _cc : ident := $"cc".
Definition _cd : ident := $"cd".
Definition _cl : ident := $"cl".
Definition _clat : ident := $"clat".
Definition _cosf : ident := $"cosf".
Definition _date : ident := $"date".
Definition _dd : ident := $"dd".
Definition _dte1 : ident := $"dte1".
Definition _dtr : ident := $"dtr".
Definition _earths_radius : ident := $"earths_radius".
Definition _elev : ident := $"elev".
Definition _ext1 : ident := $"ext1".
Definition _ext2 : ident := $"ext2".
Definition _ext3 : ident := $"ext3".
Definition _extrapsh : ident := $"extrapsh".
Definition _factor : ident := $"factor".
Definition _five_keep_extrapsh : ident := $"five_keep_extrapsh".
Definition _five_keep_mag_calc : ident := $"five_keep_mag_calc".
Definition _flat : ident := $"flat".
Definition _flon : ident := $"flon".
Definition _fm : ident := $"fm".
Definition _fn : ident := $"fn".
Definition _geo_mag_x : ident := $"geo_mag_x".
Definition _geo_mag_y : ident := $"geo_mag_y".
Definition _geo_mag_z : ident := $"geo_mag_z".
Definition _gh : ident := $"gh".
Definition _gh1 : ident := $"gh1".
Definition _gh2 : ident := $"gh2".
Definition _iext : ident := $"iext".
Definition _igdgc : ident := $"igdgc".
Definition _ii : ident := $"ii".
Definition _ios : ident := $"ios".
Definition _j : ident := $"j".
Definition _k : ident := $"k".
Definition _l : ident := $"l".
Definition _m : ident := $"m".
Definition _mag_calc : ident := $"mag_calc".
Definition _main : ident := $"main".
Definition _n : ident := $"n".
Definition _nmax : ident := $"nmax".
Definition _nmax1 : ident := $"nmax1".
Definition _nmax2 : ident := $"nmax2".
Definition _npq : ident := $"npq".
Definition _p : ident := $"p".
Definition _pow : ident := $"pow".
Definition _power : ident := $"power".
Definition _q : ident := $"q".
Definition _r : ident := $"r".
Definition _ratio : ident := $"ratio".
Definition _rr : ident := $"rr".
Definition _sd : ident := $"sd".
Definition _sinf : ident := $"sinf".
Definition _sl : ident := $"sl".
Definition _slat : ident := $"slat".
Definition _sqrt : ident := $"sqrt".

Definition v_gh1 := {|
  gvar_info := (tarray tdouble 196);
  gvar_init := (Init_float64 (Float.of_bits (Int64.repr 0)) ::
                Init_float64 (Float.of_bits (Int64.repr (-4549574661549903053))) ::
                Init_float64 (Float.of_bits (Int64.repr (-4569452457390558413))) ::
                Init_float64 (Float.of_bits (Int64.repr 4661719734853985894)) ::
                Init_float64 (Float.of_bits (Int64.repr (-4565531598925909197))) ::
                Init_float64 (Float.of_bits (Int64.repr 4658707952603181875)) ::
                Init_float64 (Float.of_bits (Int64.repr (-4564262762507455693))) ::
                Init_float64 (Float.of_bits (Int64.repr 4654968513557115699)) ::
                Init_float64 (Float.of_bits (Int64.repr (-4572991125613392691))) ::
                Init_float64 (Float.of_bits (Int64.repr 4653700556747964416)) ::
                Init_float64 (Float.of_bits (Int64.repr (-4565866949972380877))) ::
                Init_float64 (Float.of_bits (Int64.repr (-4590209477704364851))) ::
                Init_float64 (Float.of_bits (Int64.repr 4653185105696863027)) ::
                Init_float64 (Float.of_bits (Int64.repr 4642560304935337984)) ::
                Init_float64 (Float.of_bits (Int64.repr 4646687431781357978)) ::
                Init_float64 (Float.of_bits (Int64.repr (-4575327367920091136))) ::
                Init_float64 (Float.of_bits (Int64.repr 4651083719073857536)) ::
                Init_float64 (Float.of_bits (Int64.repr 4650243692190236672)) ::
                Init_float64 (Float.of_bits (Int64.repr 4643608799223585178)) ::
                Init_float64 (Float.of_bits (Int64.repr 4633035895410891162)) ::
                Init_float64 (Float.of_bits (Int64.repr (-4584456832867840819))) ::
                Init_float64 (Float.of_bits (Int64.repr (-4579719257166079590))) ::
                Init_float64 (Float.of_bits (Int64.repr 4641663103447072768)) ::
                Init_float64 (Float.of_bits (Int64.repr 4623001312491156275)) ::
                Init_float64 (Float.of_bits (Int64.repr (-4578056795584882278))) ::
                Init_float64 (Float.of_bits (Int64.repr (-4580963024719419802))) ::
                Init_float64 (Float.of_bits (Int64.repr 4645197373623395942)) ::
                Init_float64 (Float.of_bits (Int64.repr 4631586299280831283)) ::
                Init_float64 (Float.of_bits (Int64.repr 4640790531019269734)) ::
                Init_float64 (Float.of_bits (Int64.repr 4641951615298201190)) ::
                Init_float64 (Float.of_bits (Int64.repr (-4584287947881814426))) ::
                Init_float64 (Float.of_bits (Int64.repr (-4585023301258471014))) ::
                Init_float64 (Float.of_bits (Int64.repr (-4584171839453921280))) ::
                Init_float64 (Float.of_bits (Int64.repr 4631248529308778496)) ::
                Init_float64 (Float.of_bits (Int64.repr 4626576044695381606)) ::
                Init_float64 (Float.of_bits (Int64.repr 4637166540694120038)) ::
                Init_float64 (Float.of_bits (Int64.repr 4634232164061911450)) ::
                Init_float64 (Float.of_bits (Int64.repr 4634175869066569318)) ::
                Init_float64 (Float.of_bits (Int64.repr (-4597499679601170842))) ::
                Init_float64 (Float.of_bits (Int64.repr 4635111773364132250)) ::
                Init_float64 (Float.of_bits (Int64.repr 4625421997290867917)) ::
                Init_float64 (Float.of_bits (Int64.repr (-4585529956216550195))) ::
                Init_float64 (Float.of_bits (Int64.repr 4632064806741239398)) ::
                Init_float64 (Float.of_bits (Int64.repr (-4592419056271543501))) ::
                Init_float64 (Float.of_bits (Int64.repr (-4589759117741627802))) ::
                Init_float64 (Float.of_bits (Int64.repr 4624577572360735949)) ::
                Init_float64 (Float.of_bits (Int64.repr 4622325772547050701)) ::
                Init_float64 (Float.of_bits (Int64.repr (-4589632454002108006))) ::
                Init_float64 (Float.of_bits (Int64.repr 4634816224638586061)) ::
                Init_float64 (Float.of_bits (Int64.repr 4635294732098994176)) ::
                Init_float64 (Float.of_bits (Int64.repr (-4588253226616225792))) ::
                Init_float64 (Float.of_bits (Int64.repr (-4591293156364700877))) ::
                Init_float64 (Float.of_bits (Int64.repr (-4602228459209909862))) ::
                Init_float64 (Float.of_bits (Int64.repr (-4599075939470750515))) ::
                Init_float64 (Float.of_bits (Int64.repr 4633542550368970342)) ::
                Init_float64 (Float.of_bits (Int64.repr (-4616189618054758400))) ::
                Init_float64 (Float.of_bits (Int64.repr 4625084227318815130)) ::
                Init_float64 (Float.of_bits (Int64.repr 4627279732137158246)) ::
                Init_float64 (Float.of_bits (Int64.repr 4612811918334230528)) ::
                Init_float64 (Float.of_bits (Int64.repr (-4603354359116752486))) ::
                Init_float64 (Float.of_bits (Int64.repr (-4600933674317040845))) ::
                Init_float64 (Float.of_bits (Int64.repr (-4595613797257209446))) ::
                Init_float64 (Float.of_bits (Int64.repr 4624183507393341030)) ::
                Init_float64 (Float.of_bits (Int64.repr (-4611010478483282330))) ::
                Init_float64 (Float.of_bits (Int64.repr 4627223437141816115)) ::
                Init_float64 (Float.of_bits (Int64.repr 4622269477551708570)) ::
                Init_float64 (Float.of_bits (Int64.repr 4619679907765970534)) ::
                Init_float64 (Float.of_bits (Int64.repr (-4597753007080210432))) ::
                Init_float64 (Float.of_bits (Int64.repr (-4600089249386908877))) ::
                Init_float64 (Float.of_bits (Int64.repr 4611686018427387904)) ::
                Init_float64 (Float.of_bits (Int64.repr 4622607247523761357)) ::
                Init_float64 (Float.of_bits (Int64.repr (-4596570812178025677))) ::
                Init_float64 (Float.of_bits (Int64.repr (-4601721804251830682))) ::
                Init_float64 (Float.of_bits (Int64.repr 4625450144788538982)) ::
                Init_float64 (Float.of_bits (Int64.repr 4623339082463209062)) ::
                Init_float64 (Float.of_bits (Int64.repr 4624633867356078080)) ::
                Init_float64 (Float.of_bits (Int64.repr 4604480259023595110)) ::
                Init_float64 (Float.of_bits (Int64.repr (-4597950039563907891))) ::
                Init_float64 (Float.of_bits (Int64.repr (-4605831338911806259))) ::
                Init_float64 (Float.of_bits (Int64.repr 4606281698874543309)) ::
                Init_float64 (Float.of_bits (Int64.repr 4615964438073389875)) ::
                Init_float64 (Float.of_bits (Int64.repr 4616865157998863974)) ::
                Init_float64 (Float.of_bits (Int64.repr 4620468037700760371)) ::
                Init_float64 (Float.of_bits (Int64.repr (-4595698239750222643))) ::
                Init_float64 (Float.of_bits (Int64.repr 4613937818241073152)) ::
                Init_float64 (Float.of_bits (Int64.repr 4623057607486498406)) ::
                Init_float64 (Float.of_bits (Int64.repr (-4626998257160447590))) ::
                Init_float64 (Float.of_bits (Int64.repr 4620862102668155290)) ::
                Init_float64 (Float.of_bits (Int64.repr (-4610560118520545280))) ::
                Init_float64 (Float.of_bits (Int64.repr (-4608758678669597082))) ::
                Init_float64 (Float.of_bits (Int64.repr (-4599807774410198221))) ::
                Init_float64 (Float.of_bits (Int64.repr (-4605831338911806259))) ::
                Init_float64 (Float.of_bits (Int64.repr 4612586738352862003)) ::
                Init_float64 (Float.of_bits (Int64.repr 4619792497756654797)) ::
                Init_float64 (Float.of_bits (Int64.repr 4621030987654181683)) ::
                Init_float64 (Float.of_bits (Int64.repr (-4619792497756654797))) ::
                Init_float64 (Float.of_bits (Int64.repr (-4602284754205251994))) ::
                Init_float64 (Float.of_bits (Int64.repr 4605380978949069210)) ::
                Init_float64 (Float.of_bits (Int64.repr (-4599920364400882483))) ::
                Init_float64 (Float.of_bits (Int64.repr 4621819117588971520)) ::
                Init_float64 (Float.of_bits (Int64.repr (-4614838538166547251))) ::
                Init_float64 (Float.of_bits (Int64.repr (-4604480259023595110))) ::
                Init_float64 (Float.of_bits (Int64.repr 4614613358185178726)) ::
                Init_float64 (Float.of_bits (Int64.repr 4596373779694328218)) ::
                Init_float64 (Float.of_bits (Int64.repr 0)) ::
                Init_float64 (Float.of_bits (Int64.repr 4611686018427387904)) ::
                Init_float64 (Float.of_bits (Int64.repr 4612586738352862003)) ::
                Init_float64 (Float.of_bits (Int64.repr (-4616189618054758400))) ::
                Init_float64 (Float.of_bits (Int64.repr 4617653287933653811)) ::
                Init_float64 (Float.of_bits (Int64.repr (-4619792497756654797))) ::
                Init_float64 (Float.of_bits (Int64.repr (-4602059574223883469))) ::
                Init_float64 (Float.of_bits (Int64.repr (-4617090337980232499))) ::
                Init_float64 (Float.of_bits (Int64.repr 4600877379321698714)) ::
                Init_float64 (Float.of_bits (Int64.repr 4609434218613702656)) ::
                Init_float64 (Float.of_bits (Int64.repr (-4606957238818648883))) ::
                Init_float64 (Float.of_bits (Int64.repr 4606281698874543309)) ::
                Init_float64 (Float.of_bits (Int64.repr (-4607632778762754458))) ::
                Init_float64 (Float.of_bits (Int64.repr (-4610109758557808230))) ::
                Init_float64 (Float.of_bits (Int64.repr 4606281698874543309)) ::
                Init_float64 (Float.of_bits (Int64.repr (-4607407598781385933))) ::
                Init_float64 (Float.of_bits (Int64.repr (-4602059574223883469))) ::
                Init_float64 (Float.of_bits (Int64.repr 4613712638259704627)) ::
                Init_float64 (Float.of_bits (Int64.repr (-4613937818241073152))) ::
                Init_float64 (Float.of_bits (Int64.repr 0)) ::
                Init_float64 (Float.of_bits (Int64.repr (-4610560118520545280))) ::
                Init_float64 (Float.of_bits (Int64.repr 4613712638259704627)) ::
                Init_float64 (Float.of_bits (Int64.repr 4612586738352862003)) ::
                Init_float64 (Float.of_bits (Int64.repr (-4619792497756654797))) ::
                Init_float64 (Float.of_bits (Int64.repr (-4619792497756654797))) ::
                Init_float64 (Float.of_bits (Int64.repr 4596373779694328218)) ::
                Init_float64 (Float.of_bits (Int64.repr (-4631501856787818086))) ::
                Init_float64 (Float.of_bits (Int64.repr 4602678819172646912)) ::
                Init_float64 (Float.of_bits (Int64.repr (-4619792497756654797))) ::
                Init_float64 (Float.of_bits (Int64.repr (-4624296097384025293))) ::
                Init_float64 (Float.of_bits (Int64.repr (-4631501856787818086))) ::
                Init_float64 (Float.of_bits (Int64.repr (-4615288898129284301))) ::
                Init_float64 (Float.of_bits (Int64.repr 4607632778762754458)) ::
                Init_float64 (Float.of_bits (Int64.repr (-4613037098315599053))) ::
                Init_float64 (Float.of_bits (Int64.repr (-4616189618054758400))) ::
                Init_float64 (Float.of_bits (Int64.repr (-4609659398595071181))) ::
                Init_float64 (Float.of_bits (Int64.repr (-4626998257160447590))) ::
                Init_float64 (Float.of_bits (Int64.repr (-4612586738352862003))) ::
                Init_float64 (Float.of_bits (Int64.repr 4613037098315599053)) ::
                Init_float64 (Float.of_bits (Int64.repr (-4611010478483282330))) ::
                Init_float64 (Float.of_bits (Int64.repr (-4611686018427387904))) ::
                Init_float64 (Float.of_bits (Int64.repr (-4626998257160447590))) ::
                Init_float64 (Float.of_bits (Int64.repr (-4614838538166547251))) ::
                Init_float64 (Float.of_bits (Int64.repr 4599075939470750515)) ::
                Init_float64 (Float.of_bits (Int64.repr 4604480259023595110)) ::
                Init_float64 (Float.of_bits (Int64.repr 4608083138725491507)) ::
                Init_float64 (Float.of_bits (Int64.repr 4607182418800017408)) ::
                Init_float64 (Float.of_bits (Int64.repr (-4614838538166547251))) ::
                Init_float64 (Float.of_bits (Int64.repr (-4614388178203810202))) ::
                Init_float64 (Float.of_bits (Int64.repr 4603579539098121011)) ::
                Init_float64 (Float.of_bits (Int64.repr 0)) ::
                Init_float64 (Float.of_bits (Int64.repr 4603579539098121011)) ::
                Init_float64 (Float.of_bits (Int64.repr 4603579539098121011)) ::
                Init_float64 (Float.of_bits (Int64.repr 4602678819172646912)) ::
                Init_float64 (Float.of_bits (Int64.repr (-4631501856787818086))) ::
                Init_float64 (Float.of_bits (Int64.repr (-4631501856787818086))) ::
                Init_float64 (Float.of_bits (Int64.repr 4605380978949069210)) ::
                Init_float64 (Float.of_bits (Int64.repr (-4622494657533077094))) ::
                Init_float64 (Float.of_bits (Int64.repr 4591870180066957722)) ::
                Init_float64 (Float.of_bits (Int64.repr (-4626998257160447590))) ::
                Init_float64 (Float.of_bits (Int64.repr (-4616189618054758400))) ::
                Init_float64 (Float.of_bits (Int64.repr (-4614838538166547251))) ::
                Init_float64 (Float.of_bits (Int64.repr 4591870180066957722)) ::
                Init_float64 (Float.of_bits (Int64.repr (-4618891777831180698))) ::
                Init_float64 (Float.of_bits (Int64.repr 4596373779694328218)) ::
                Init_space 216 :: nil);
  gvar_readonly := true;
  gvar_volatile := false
|}.

Definition v_gh2 := {|
  gvar_info := (tarray tdouble 196);
  gvar_init := (Init_float64 (Float.of_bits (Int64.repr 0)) ::
                Init_float64 (Float.of_bits (Int64.repr 4622945017495814144)) ::
                Init_float64 (Float.of_bits (Int64.repr 4621650232602945126)) ::
                Init_float64 (Float.of_bits (Int64.repr (-4596627107173367808))) ::
                Init_float64 (Float.of_bits (Int64.repr (-4600652199340330189))) ::
                Init_float64 (Float.of_bits (Int64.repr (-4605831338911806259))) ::
                Init_float64 (Float.of_bits (Int64.repr (-4594881962317761741))) ::
                Init_float64 (Float.of_bits (Int64.repr (-4602678819172646912))) ::
                Init_float64 (Float.of_bits (Int64.repr (-4600370724363619533))) ::
                Init_float64 (Float.of_bits (Int64.repr (-4614838538166547251))) ::
                Init_float64 (Float.of_bits (Int64.repr (-4606957238818648883))) ::
                Init_float64 (Float.of_bits (Int64.repr 4616189618054758400)) ::
                Init_float64 (Float.of_bits (Int64.repr 4600877379321698714)) ::
                Init_float64 (Float.of_bits (Int64.repr (-4624296097384025293))) ::
                Init_float64 (Float.of_bits (Int64.repr (-4598400399526644941))) ::
                Init_float64 (Float.of_bits (Int64.repr (-4607069828809333146))) ::
                Init_float64 (Float.of_bits (Int64.repr (-4613487458278336102))) ::
                Init_float64 (Float.of_bits (Int64.repr (-4610785298501913805))) ::
                Init_float64 (Float.of_bits (Int64.repr (-4615739258092021350))) ::
                Init_float64 (Float.of_bits (Int64.repr (-4604930618986332160))) ::
                Init_float64 (Float.of_bits (Int64.repr 4616302208045442662)) ::
                Init_float64 (Float.of_bits (Int64.repr 4617991057905706598)) ::
                Init_float64 (Float.of_bits (Int64.repr 4609884578576439706)) ::
                Init_float64 (Float.of_bits (Int64.repr (-4603804719079489536))) ::
                Init_float64 (Float.of_bits (Int64.repr (-4606732058837280358))) ::
                Init_float64 (Float.of_bits (Int64.repr 4603579539098121011)) ::
                Init_float64 (Float.of_bits (Int64.repr 4608983858650965606)) ::
                Init_float64 (Float.of_bits (Int64.repr (-4620693217682128896))) ::
                Init_float64 (Float.of_bits (Int64.repr 0)) ::
                Init_float64 (Float.of_bits (Int64.repr 4612136378390124954)) ::
                Init_float64 (Float.of_bits (Int64.repr 4603579539098121011)) ::
                Init_float64 (Float.of_bits (Int64.repr 4600877379321698714)) ::
                Init_float64 (Float.of_bits (Int64.repr 4612136378390124954)) ::
                Init_float64 (Float.of_bits (Int64.repr 4610334938539176755)) ::
                Init_float64 (Float.of_bits (Int64.repr 4606281698874543309)) ::
                Init_float64 (Float.of_bits (Int64.repr 4611235658464650854)) ::
                Init_float64 (Float.of_bits (Int64.repr (-4626998257160447590))) ::
                Init_float64 (Float.of_bits (Int64.repr (-4622494657533077094))) ::
                Init_float64 (Float.of_bits (Int64.repr 4599075939470750515)) ::
                Init_float64 (Float.of_bits (Int64.repr 4606281698874543309)) ::
                Init_float64 (Float.of_bits (Int64.repr (-4613487458278336102))) ::
                Init_float64 (Float.of_bits (Int64.repr 4608083138725491507)) ::
                Init_float64 (Float.of_bits (Int64.repr (-4622494657533077094))) ::
                Init_float64 (Float.of_bits (Int64.repr (-4617090337980232499))) ::
                Init_float64 (Float.of_bits (Int64.repr 4606281698874543309)) ::
                Init_float64 (Float.of_bits (Int64.repr 4599075939470750515)) ::
                Init_float64 (Float.of_bits (Int64.repr 4604480259023595110)) ::
                Init_float64 (Float.of_bits (Int64.repr 4606281698874543309)) ::
                Init_float64 (Float.of_bits (Int64.repr 4606281698874543309)) ::
                Init_float64 (Float.of_bits (Int64.repr 0)) ::
                Init_float64 (Float.of_bits (Int64.repr (-4631501856787818086))) ::
                Init_float64 (Float.of_bits (Int64.repr 4603579539098121011)) ::
                Init_float64 (Float.of_bits (Int64.repr (-4631501856787818086))) ::
                Init_float64 (Float.of_bits (Int64.repr 4602678819172646912)) ::
                Init_float64 (Float.of_bits (Int64.repr 4602678819172646912)) ::
                Init_float64 (Float.of_bits (Int64.repr (-4617991057905706598))) ::
                Init_float64 (Float.of_bits (Int64.repr (-4631501856787818086))) ::
                Init_float64 (Float.of_bits (Int64.repr 0)) ::
                Init_float64 (Float.of_bits (Int64.repr (-4617991057905706598))) ::
                Init_float64 (Float.of_bits (Int64.repr (-4616189618054758400))) ::
                Init_float64 (Float.of_bits (Int64.repr (-4617991057905706598))) ::
                Init_float64 (Float.of_bits (Int64.repr 4603579539098121011)) ::
                Init_float64 (Float.of_bits (Int64.repr 4605380978949069210)) ::
                Init_float64 (Float.of_bits (Int64.repr (-4626998257160447590))) ::
                Init_float64 (Float.of_bits (Int64.repr (-4631501856787818086))) ::
                Init_float64 (Float.of_bits (Int64.repr 4596373779694328218)) ::
                Init_float64 (Float.of_bits (Int64.repr (-4626998257160447590))) ::
                Init_float64 (Float.of_bits (Int64.repr 0)) ::
                Init_float64 (Float.of_bits (Int64.repr 4602678819172646912)) ::
                Init_float64 (Float.of_bits (Int64.repr 4602678819172646912)) ::
                Init_float64 (Float.of_bits (Int64.repr (-4622494657533077094))) ::
                Init_float64 (Float.of_bits (Int64.repr (-4631501856787818086))) ::
                Init_float64 (Float.of_bits (Int64.repr 4600877379321698714)) ::
                Init_float64 (Float.of_bits (Int64.repr 4599075939470750515)) ::
                Init_float64 (Float.of_bits (Int64.repr (-4620693217682128896))) ::
                Init_float64 (Float.of_bits (Int64.repr 4596373779694328218)) ::
                Init_float64 (Float.of_bits (Int64.repr (-4619792497756654797))) ::
                Init_float64 (Float.of_bits (Int64.repr 0)) ::
                Init_float64 (Float.of_bits (Int64.repr 4599075939470750515)) ::
                Init_float64 (Float.of_bits (Int64.repr 4596373779694328218)) ::
                Init_float64 (Float.of_bits (Int64.repr 4596373779694328218)) ::
                Init_float64 (Float.of_bits (Int64.repr 0)) ::
                Init_float64 (Float.of_bits (Int64.repr (-4631501856787818086))) ::
                Init_float64 (Float.of_bits (Int64.repr (-4624296097384025293))) ::
                Init_float64 (Float.of_bits (Int64.repr 4591870180066957722)) ::
                Init_float64 (Float.of_bits (Int64.repr 4599075939470750515)) ::
                Init_float64 (Float.of_bits (Int64.repr 4599075939470750515)) ::
                Init_float64 (Float.of_bits (Int64.repr (-4624296097384025293))) ::
                Init_float64 (Float.of_bits (Int64.repr (-4624296097384025293))) ::
                Init_float64 (Float.of_bits (Int64.repr 4599075939470750515)) ::
                Init_float64 (Float.of_bits (Int64.repr 0)) ::
                Init_float64 (Float.of_bits (Int64.repr 4596373779694328218)) ::
                Init_float64 (Float.of_bits (Int64.repr 4599075939470750515)) ::
                Init_float64 (Float.of_bits (Int64.repr (-4631501856787818086))) ::
                Init_float64 (Float.of_bits (Int64.repr (-4631501856787818086))) ::
                Init_float64 (Float.of_bits (Int64.repr (-4626998257160447590))) ::
                Init_float64 (Float.of_bits (Int64.repr 4591870180066957722)) ::
                Init_float64 (Float.of_bits (Int64.repr 4600877379321698714)) ::
                Init_float64 (Float.of_bits (Int64.repr (-4631501856787818086))) ::
                Init_float64 (Float.of_bits (Int64.repr 4591870180066957722)) ::
                Init_float64 (Float.of_bits (Int64.repr 4591870180066957722)) ::
                Init_float64 (Float.of_bits (Int64.repr 0)) ::
                Init_float64 (Float.of_bits (Int64.repr 0)) ::
                Init_float64 (Float.of_bits (Int64.repr 4591870180066957722)) ::
                Init_float64 (Float.of_bits (Int64.repr 0)) ::
                Init_float64 (Float.of_bits (Int64.repr 4591870180066957722)) ::
                Init_float64 (Float.of_bits (Int64.repr (-4626998257160447590))) ::
                Init_float64 (Float.of_bits (Int64.repr 0)) ::
                Init_float64 (Float.of_bits (Int64.repr 4591870180066957722)) ::
                Init_float64 (Float.of_bits (Int64.repr (-4624296097384025293))) ::
                Init_float64 (Float.of_bits (Int64.repr (-4631501856787818086))) ::
                Init_float64 (Float.of_bits (Int64.repr 0)) ::
                Init_float64 (Float.of_bits (Int64.repr 4591870180066957722)) ::
                Init_float64 (Float.of_bits (Int64.repr (-4631501856787818086))) ::
                Init_float64 (Float.of_bits (Int64.repr 0)) ::
                Init_float64 (Float.of_bits (Int64.repr (-4631501856787818086))) ::
                Init_float64 (Float.of_bits (Int64.repr (-4631501856787818086))) ::
                Init_float64 (Float.of_bits (Int64.repr 0)) ::
                Init_float64 (Float.of_bits (Int64.repr 4596373779694328218)) ::
                Init_float64 (Float.of_bits (Int64.repr 0)) ::
                Init_float64 (Float.of_bits (Int64.repr (-9223372036854775808))) ::
                Init_float64 (Float.of_bits (Int64.repr 0)) ::
                Init_float64 (Float.of_bits (Int64.repr 0)) ::
                Init_float64 (Float.of_bits (Int64.repr 0)) ::
                Init_float64 (Float.of_bits (Int64.repr 0)) ::
                Init_float64 (Float.of_bits (Int64.repr 4591870180066957722)) ::
                Init_float64 (Float.of_bits (Int64.repr 0)) ::
                Init_float64 (Float.of_bits (Int64.repr 0)) ::
                Init_float64 (Float.of_bits (Int64.repr 0)) ::
                Init_float64 (Float.of_bits (Int64.repr 4591870180066957722)) ::
                Init_float64 (Float.of_bits (Int64.repr (-4631501856787818086))) ::
                Init_float64 (Float.of_bits (Int64.repr 0)) ::
                Init_float64 (Float.of_bits (Int64.repr 0)) ::
                Init_float64 (Float.of_bits (Int64.repr 0)) ::
                Init_float64 (Float.of_bits (Int64.repr 0)) ::
                Init_float64 (Float.of_bits (Int64.repr 4591870180066957722)) ::
                Init_float64 (Float.of_bits (Int64.repr (-4631501856787818086))) ::
                Init_float64 (Float.of_bits (Int64.repr 0)) ::
                Init_float64 (Float.of_bits (Int64.repr (-4631501856787818086))) ::
                Init_float64 (Float.of_bits (Int64.repr 0)) ::
                Init_float64 (Float.of_bits (Int64.repr (-4631501856787818086))) ::
                Init_float64 (Float.of_bits (Int64.repr 0)) ::
                Init_float64 (Float.of_bits (Int64.repr (-4631501856787818086))) ::
                Init_float64 (Float.of_bits (Int64.repr 0)) ::
                Init_float64 (Float.of_bits (Int64.repr 0)) ::
                Init_float64 (Float.of_bits (Int64.repr 0)) ::
                Init_float64 (Float.of_bits (Int64.repr 0)) ::
                Init_float64 (Float.of_bits (Int64.repr 0)) ::
                Init_float64 (Float.of_bits (Int64.repr 0)) ::
                Init_float64 (Float.of_bits (Int64.repr 0)) ::
                Init_float64 (Float.of_bits (Int64.repr (-4631501856787818086))) ::
                Init_float64 (Float.of_bits (Int64.repr 0)) ::
                Init_float64 (Float.of_bits (Int64.repr 4591870180066957722)) ::
                Init_float64 (Float.of_bits (Int64.repr 0)) ::
                Init_float64 (Float.of_bits (Int64.repr 0)) ::
                Init_float64 (Float.of_bits (Int64.repr 4591870180066957722)) ::
                Init_float64 (Float.of_bits (Int64.repr 0)) ::
                Init_float64 (Float.of_bits (Int64.repr 0)) ::
                Init_float64 (Float.of_bits (Int64.repr 0)) ::
                Init_float64 (Float.of_bits (Int64.repr 0)) ::
                Init_float64 (Float.of_bits (Int64.repr 0)) ::
                Init_float64 (Float.of_bits (Int64.repr 0)) ::
                Init_float64 (Float.of_bits (Int64.repr 0)) ::
                Init_float64 (Float.of_bits (Int64.repr (-4631501856787818086))) ::
                Init_float64 (Float.of_bits (Int64.repr 0)) ::
                Init_float64 (Float.of_bits (Int64.repr 0)) ::
                Init_float64 (Float.of_bits (Int64.repr 0)) ::
                Init_float64 (Float.of_bits (Int64.repr (-4631501856787818086))) ::
                Init_float64 (Float.of_bits (Int64.repr (-4631501856787818086))) ::
                Init_space 216 :: nil);
  gvar_readonly := true;
  gvar_volatile := false
|}.

Definition f_extrapsh := {|
  fn_return := tshort;
  fn_callconv := cc_default;
  fn_params := ((_date, tdouble) :: (_dte1, tdouble) :: (_nmax1, tshort) ::
                (_nmax2, tshort) :: (_gh, (tptr tdouble)) :: nil);
  fn_vars := ((_nmax, tshort) :: (_k, tshort) :: (_l, tshort) ::
              (_ii, tshort) :: (_factor, tdouble) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Eassign (Evar _factor tdouble)
         (Ebinop Osub (Evalof (Evar _date tdouble) tdouble)
           (Evalof (Evar _dte1 tdouble) tdouble) tdouble) tdouble))
  (Ssequence
    (Sifthenelse (Ebinop Oeq (Evalof (Evar _nmax1 tshort) tshort)
                   (Evalof (Evar _nmax2 tshort) tshort) tint)
      (Ssequence
        (Sdo (Eassign (Evar _k tshort)
               (Ebinop Omul (Evalof (Evar _nmax1 tshort) tshort)
                 (Ebinop Oadd (Evalof (Evar _nmax1 tshort) tshort)
                   (Eval (Vint (Int.repr 2)) tint) tint) tint) tshort))
        (Sdo (Eassign (Evar _nmax tshort)
               (Evalof (Evar _nmax1 tshort) tshort) tshort)))
      (Sifthenelse (Ebinop Ogt (Evalof (Evar _nmax1 tshort) tshort)
                     (Evalof (Evar _nmax2 tshort) tshort) tint)
        (Ssequence
          (Sdo (Eassign (Evar _k tshort)
                 (Ebinop Omul (Evalof (Evar _nmax2 tshort) tshort)
                   (Ebinop Oadd (Evalof (Evar _nmax2 tshort) tshort)
                     (Eval (Vint (Int.repr 2)) tint) tint) tint) tshort))
          (Ssequence
            (Sdo (Eassign (Evar _l tshort)
                   (Ebinop Omul (Evalof (Evar _nmax1 tshort) tshort)
                     (Ebinop Oadd (Evalof (Evar _nmax1 tshort) tshort)
                       (Eval (Vint (Int.repr 2)) tint) tint) tint) tshort))
            (Ssequence
              (Sfor
                (Sdo (Eassign (Evar _ii tshort)
                       (Ebinop Oadd (Evalof (Evar _k tshort) tshort)
                         (Eval (Vint (Int.repr 1)) tint) tint) tshort))
                (Ebinop Ole (Evalof (Evar _ii tshort) tshort)
                  (Evalof (Evar _l tshort) tshort) tint)
                (Sdo (Eassignop Oadd (Evar _ii tshort)
                       (Eval (Vint (Int.repr 1)) tint) tint tshort))
                (Sdo (Eassign
                       (Ederef
                         (Ebinop Oadd
                           (Evalof (Evar _gh (tptr tdouble)) (tptr tdouble))
                           (Evalof (Evar _ii tshort) tshort) (tptr tdouble))
                         tdouble)
                       (Evalof
                         (Ederef
                           (Ebinop Oadd
                             (Evalof (Evar _gh1 (tarray tdouble 196))
                               (tarray tdouble 196))
                             (Evalof (Evar _ii tshort) tshort)
                             (tptr tdouble)) tdouble) tdouble) tdouble)))
              (Sdo (Eassign (Evar _nmax tshort)
                     (Evalof (Evar _nmax1 tshort) tshort) tshort)))))
        (Ssequence
          (Sdo (Eassign (Evar _k tshort)
                 (Ebinop Omul (Evalof (Evar _nmax1 tshort) tshort)
                   (Ebinop Oadd (Evalof (Evar _nmax1 tshort) tshort)
                     (Eval (Vint (Int.repr 2)) tint) tint) tint) tshort))
          (Ssequence
            (Sdo (Eassign (Evar _l tshort)
                   (Ebinop Omul (Evalof (Evar _nmax2 tshort) tshort)
                     (Ebinop Oadd (Evalof (Evar _nmax2 tshort) tshort)
                       (Eval (Vint (Int.repr 2)) tint) tint) tint) tshort))
            (Ssequence
              (Sfor
                (Sdo (Eassign (Evar _ii tshort)
                       (Ebinop Oadd (Evalof (Evar _k tshort) tshort)
                         (Eval (Vint (Int.repr 1)) tint) tint) tshort))
                (Ebinop Ole (Evalof (Evar _ii tshort) tshort)
                  (Evalof (Evar _l tshort) tshort) tint)
                (Sdo (Eassignop Oadd (Evar _ii tshort)
                       (Eval (Vint (Int.repr 1)) tint) tint tshort))
                (Sdo (Eassign
                       (Ederef
                         (Ebinop Oadd
                           (Evalof (Evar _gh (tptr tdouble)) (tptr tdouble))
                           (Evalof (Evar _ii tshort) tshort) (tptr tdouble))
                         tdouble)
                       (Ebinop Omul (Evalof (Evar _factor tdouble) tdouble)
                         (Evalof
                           (Ederef
                             (Ebinop Oadd
                               (Evalof (Evar _gh2 (tarray tdouble 196))
                                 (tarray tdouble 196))
                               (Evalof (Evar _ii tshort) tshort)
                               (tptr tdouble)) tdouble) tdouble) tdouble)
                       tdouble)))
              (Sdo (Eassign (Evar _nmax tshort)
                     (Evalof (Evar _nmax2 tshort) tshort) tshort)))))))
    (Ssequence
      (Sfor
        (Sdo (Eassign (Evar _ii tshort) (Eval (Vint (Int.repr 1)) tint)
               tshort))
        (Ebinop Ole (Evalof (Evar _ii tshort) tshort)
          (Evalof (Evar _k tshort) tshort) tint)
        (Sdo (Eassignop Oadd (Evar _ii tshort)
               (Eval (Vint (Int.repr 1)) tint) tint tshort))
        (Sdo (Eassign
               (Ederef
                 (Ebinop Oadd
                   (Evalof (Evar _gh (tptr tdouble)) (tptr tdouble))
                   (Evalof (Evar _ii tshort) tshort) (tptr tdouble)) tdouble)
               (Ebinop Oadd
                 (Evalof
                   (Ederef
                     (Ebinop Oadd
                       (Evalof (Evar _gh1 (tarray tdouble 196))
                         (tarray tdouble 196))
                       (Evalof (Evar _ii tshort) tshort) (tptr tdouble))
                     tdouble) tdouble)
                 (Ebinop Omul (Evalof (Evar _factor tdouble) tdouble)
                   (Evalof
                     (Ederef
                       (Ebinop Oadd
                         (Evalof (Evar _gh2 (tarray tdouble 196))
                           (tarray tdouble 196))
                         (Evalof (Evar _ii tshort) tshort) (tptr tdouble))
                       tdouble) tdouble) tdouble) tdouble) tdouble)))
      (Sreturn (Some (Evalof (Evar _nmax tshort) tshort))))))
|}.

Definition f_mag_calc := {|
  fn_return := tshort;
  fn_callconv := cc_default;
  fn_params := ((_igdgc, tshort) :: (_flat, tdouble) :: (_flon, tdouble) ::
                (_elev, tdouble) :: (_nmax, tshort) ::
                (_gh, (tptr tdouble)) :: (_geo_mag_x, (tptr tdouble)) ::
                (_geo_mag_y, (tptr tdouble)) ::
                (_geo_mag_z, (tptr tdouble)) :: (_iext, tshort) ::
                (_ext1, tdouble) :: (_ext2, tdouble) :: (_ext3, tdouble) ::
                nil);
  fn_vars := ((_earths_radius, tdouble) :: (_dtr, tdouble) ::
              (_slat, tdouble) :: (_clat, tdouble) :: (_ratio, tdouble) ::
              (_aa, tdouble) :: (_bb, tdouble) :: (_cc, tdouble) ::
              (_dd, tdouble) :: (_sd, tdouble) :: (_cd, tdouble) ::
              (_r, tdouble) :: (_a2, tdouble) :: (_b2, tdouble) ::
              (_rr, tdouble) :: (_fm, tdouble) :: (_fn, tdouble) ::
              (_sl, (tarray tdouble 14)) :: (_cl, (tarray tdouble 14)) ::
              (_p, (tarray tfloat 119)) :: (_q, (tarray tfloat 119)) ::
              (_ii, tint) :: (_j, tint) :: (_k, tint) :: (_l, tint) ::
              (_m, tint) :: (_n, tint) :: (_npq, tint) :: (_ios, tint) ::
              (_argument, tdouble) :: (_power, tdouble) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Eassign (Evar _earths_radius tdouble)
         (Eval (Vfloat (Float.of_bits (Int64.repr 4663727223183979315))) tdouble)
         tdouble))
  (Ssequence
    (Sdo (Eassign (Evar _dtr tdouble)
           (Eval (Vfloat (Float.of_bits (Int64.repr 4580687789750208845))) tdouble)
           tdouble))
    (Ssequence
      (Sdo (Eassign (Evar _rr tdouble) (Eval (Vint (Int.repr 0)) tint)
             tdouble))
      (Ssequence
        (Sdo (Eassign (Evar _fn tdouble) (Eval (Vint (Int.repr 0)) tint)
               tdouble))
        (Ssequence
          (Sdo (Eassign (Evar _a2 tdouble)
                 (Eval (Vfloat (Float.of_bits (Int64.repr 4720728871802524140))) tdouble)
                 tdouble))
          (Ssequence
            (Sdo (Eassign (Evar _b2 tdouble)
                   (Eval (Vfloat (Float.of_bits (Int64.repr 4720692320072567357))) tdouble)
                   tdouble))
            (Ssequence
              (Sdo (Eassign (Evar _ios tint) (Eval (Vint (Int.repr 0)) tint)
                     tint))
              (Ssequence
                (Sdo (Eassign (Evar _r tdouble)
                       (Evalof (Evar _elev tdouble) tdouble) tdouble))
                (Ssequence
                  (Sdo (Eassign (Evar _argument tdouble)
                         (Ebinop Omul (Evalof (Evar _flat tdouble) tdouble)
                           (Evalof (Evar _dtr tdouble) tdouble) tdouble)
                         tdouble))
                  (Ssequence
                    (Sdo (Eassign (Evar _slat tdouble)
                           (Ecall
                             (Evalof
                               (Evar _sinf (Tfunction (tfloat :: nil) tfloat
                                             cc_default))
                               (Tfunction (tfloat :: nil) tfloat cc_default))
                             (Econs (Evalof (Evar _argument tdouble) tdouble)
                               Enil) tfloat) tdouble))
                    (Ssequence
                      (Sifthenelse (Ebinop Olt
                                     (Ebinop Osub
                                       (Eval (Vfloat (Float.of_bits (Int64.repr 4636033603912859648))) tdouble)
                                       (Evalof (Evar _flat tdouble) tdouble)
                                       tdouble)
                                     (Eval (Vfloat (Float.of_bits (Int64.repr 4562254508917369340))) tdouble)
                                     tint)
                        (Sdo (Eassign (Evar _aa tdouble)
                               (Eval (Vfloat (Float.of_bits (Int64.repr 4636033533544115470))) tdouble)
                               tdouble))
                        (Sifthenelse (Ebinop Olt
                                       (Ebinop Oadd
                                         (Eval (Vfloat (Float.of_bits (Int64.repr 4636033603912859648))) tdouble)
                                         (Evalof (Evar _flat tdouble)
                                           tdouble) tdouble)
                                       (Eval (Vfloat (Float.of_bits (Int64.repr 4562254508917369340))) tdouble)
                                       tint)
                          (Sdo (Eassign (Evar _aa tdouble)
                                 (Eunop Oneg
                                   (Eval (Vfloat (Float.of_bits (Int64.repr 4636033533544115470))) tdouble)
                                   tdouble) tdouble))
                          (Sdo (Eassign (Evar _aa tdouble)
                                 (Evalof (Evar _flat tdouble) tdouble)
                                 tdouble))))
                      (Ssequence
                        (Sdo (Eassign (Evar _argument tdouble)
                               (Ebinop Omul
                                 (Evalof (Evar _aa tdouble) tdouble)
                                 (Evalof (Evar _dtr tdouble) tdouble)
                                 tdouble) tdouble))
                        (Ssequence
                          (Sdo (Eassign (Evar _clat tdouble)
                                 (Ecall
                                   (Evalof
                                     (Evar _cosf (Tfunction (tfloat :: nil)
                                                   tfloat cc_default))
                                     (Tfunction (tfloat :: nil) tfloat
                                       cc_default))
                                   (Econs
                                     (Evalof (Evar _argument tdouble)
                                       tdouble) Enil) tfloat) tdouble))
                          (Ssequence
                            (Sdo (Eassign (Evar _argument tdouble)
                                   (Ebinop Omul
                                     (Evalof (Evar _flon tdouble) tdouble)
                                     (Evalof (Evar _dtr tdouble) tdouble)
                                     tdouble) tdouble))
                            (Ssequence
                              (Sdo (Eassign
                                     (Ederef
                                       (Ebinop Oadd
                                         (Evalof
                                           (Evar _sl (tarray tdouble 14))
                                           (tarray tdouble 14))
                                         (Eval (Vint (Int.repr 1)) tint)
                                         (tptr tdouble)) tdouble)
                                     (Ecall
                                       (Evalof
                                         (Evar _sinf (Tfunction
                                                       (tfloat :: nil) tfloat
                                                       cc_default))
                                         (Tfunction (tfloat :: nil) tfloat
                                           cc_default))
                                       (Econs
                                         (Evalof (Evar _argument tdouble)
                                           tdouble) Enil) tfloat) tdouble))
                              (Ssequence
                                (Sdo (Eassign
                                       (Ederef
                                         (Ebinop Oadd
                                           (Evalof
                                             (Evar _cl (tarray tdouble 14))
                                             (tarray tdouble 14))
                                           (Eval (Vint (Int.repr 1)) tint)
                                           (tptr tdouble)) tdouble)
                                       (Ecall
                                         (Evalof
                                           (Evar _cosf (Tfunction
                                                         (tfloat :: nil)
                                                         tfloat cc_default))
                                           (Tfunction (tfloat :: nil) tfloat
                                             cc_default))
                                         (Econs
                                           (Evalof (Evar _argument tdouble)
                                             tdouble) Enil) tfloat) tdouble))
                                (Ssequence
                                  (Sdo (Eassign
                                         (Ederef
                                           (Evalof
                                             (Evar _geo_mag_x (tptr tdouble))
                                             (tptr tdouble)) tdouble)
                                         (Eval (Vint (Int.repr 0)) tint)
                                         tdouble))
                                  (Ssequence
                                    (Sdo (Eassign
                                           (Ederef
                                             (Evalof
                                               (Evar _geo_mag_y (tptr tdouble))
                                               (tptr tdouble)) tdouble)
                                           (Eval (Vint (Int.repr 0)) tint)
                                           tdouble))
                                    (Ssequence
                                      (Sdo (Eassign
                                             (Ederef
                                               (Evalof
                                                 (Evar _geo_mag_z (tptr tdouble))
                                                 (tptr tdouble)) tdouble)
                                             (Eval (Vint (Int.repr 0)) tint)
                                             tdouble))
                                      (Ssequence
                                        (Sdo (Eassign (Evar _sd tdouble)
                                               (Eval (Vfloat (Float.of_bits (Int64.repr 0))) tdouble)
                                               tdouble))
                                        (Ssequence
                                          (Sdo (Eassign (Evar _cd tdouble)
                                                 (Eval (Vfloat (Float.of_bits (Int64.repr 4607182418800017408))) tdouble)
                                                 tdouble))
                                          (Ssequence
                                            (Sdo (Eassign (Evar _l tint)
                                                   (Eval (Vint (Int.repr 1)) tint)
                                                   tint))
                                            (Ssequence
                                              (Sdo (Eassign (Evar _n tint)
                                                     (Eval (Vint (Int.repr 0)) tint)
                                                     tint))
                                              (Ssequence
                                                (Sdo (Eassign (Evar _m tint)
                                                       (Eval (Vint (Int.repr 1)) tint)
                                                       tint))
                                                (Ssequence
                                                  (Sdo (Eassign
                                                         (Evar _npq tint)
                                                         (Ebinop Odiv
                                                           (Ebinop Omul
                                                             (Evalof
                                                               (Evar _nmax tshort)
                                                               tshort)
                                                             (Ebinop Oadd
                                                               (Evalof
                                                                 (Evar _nmax tshort)
                                                                 tshort)
                                                               (Eval (Vint (Int.repr 3)) tint)
                                                               tint) tint)
                                                           (Eval (Vint (Int.repr 2)) tint)
                                                           tint) tint))
                                                  (Ssequence
                                                    (Sifthenelse (Ebinop Oeq
                                                                   (Evalof
                                                                    (Evar _igdgc tshort)
                                                                    tshort)
                                                                   (Eval (Vint (Int.repr 1)) tint)
                                                                   tint)
                                                      (Ssequence
                                                        (Sdo (Eassign
                                                               (Evar _aa tdouble)
                                                               (Ebinop Omul
                                                                 (Ebinop Omul
                                                                   (Evalof
                                                                    (Evar _a2 tdouble)
                                                                    tdouble)
                                                                   (Evalof
                                                                    (Evar _clat tdouble)
                                                                    tdouble)
                                                                   tdouble)
                                                                 (Evalof
                                                                   (Evar _clat tdouble)
                                                                   tdouble)
                                                                 tdouble)
                                                               tdouble))
                                                        (Ssequence
                                                          (Sdo (Eassign
                                                                 (Evar _bb tdouble)
                                                                 (Ebinop Omul
                                                                   (Ebinop Omul
                                                                    (Evalof
                                                                    (Evar _b2 tdouble)
                                                                    tdouble)
                                                                    (Evalof
                                                                    (Evar _slat tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                   (Evalof
                                                                    (Evar _slat tdouble)
                                                                    tdouble)
                                                                   tdouble)
                                                                 tdouble))
                                                          (Ssequence
                                                            (Sdo (Eassign
                                                                   (Evar _cc tdouble)
                                                                   (Ebinop Oadd
                                                                    (Evalof
                                                                    (Evar _aa tdouble)
                                                                    tdouble)
                                                                    (Evalof
                                                                    (Evar _bb tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                   tdouble))
                                                            (Ssequence
                                                              (Sdo (Eassign
                                                                    (Evar _argument tdouble)
                                                                    (Evalof
                                                                    (Evar _cc tdouble)
                                                                    tdouble)
                                                                    tdouble))
                                                              (Ssequence
                                                                (Sdo 
                                                                  (Eassign
                                                                    (Evar _dd tdouble)
                                                                    (Ecall
                                                                    (Evalof
                                                                    (Evar _sqrt 
                                                                    (Tfunction
                                                                    (tdouble ::
                                                                    nil)
                                                                    tdouble
                                                                    cc_default))
                                                                    (Tfunction
                                                                    (tdouble ::
                                                                    nil)
                                                                    tdouble
                                                                    cc_default))
                                                                    (Econs
                                                                    (Evalof
                                                                    (Evar _argument tdouble)
                                                                    tdouble)
                                                                    Enil)
                                                                    tdouble)
                                                                    tdouble))
                                                                (Ssequence
                                                                  (Sdo 
                                                                    (Eassign
                                                                    (Evar _argument tdouble)
                                                                    (Ebinop Oadd
                                                                    (Ebinop Omul
                                                                    (Evalof
                                                                    (Evar _elev tdouble)
                                                                    tdouble)
                                                                    (Ebinop Oadd
                                                                    (Evalof
                                                                    (Evar _elev tdouble)
                                                                    tdouble)
                                                                    (Ebinop Omul
                                                                    (Eval (Vfloat (Float.of_bits (Int64.repr 4611686018427387904))) tdouble)
                                                                    (Evalof
                                                                    (Evar _dd tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    (Ebinop Odiv
                                                                    (Ebinop Oadd
                                                                    (Ebinop Omul
                                                                    (Evalof
                                                                    (Evar _a2 tdouble)
                                                                    tdouble)
                                                                    (Evalof
                                                                    (Evar _aa tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    (Ebinop Omul
                                                                    (Evalof
                                                                    (Evar _b2 tdouble)
                                                                    tdouble)
                                                                    (Evalof
                                                                    (Evar _bb tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    (Evalof
                                                                    (Evar _cc tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    tdouble))
                                                                  (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _r tdouble)
                                                                    (Ecall
                                                                    (Evalof
                                                                    (Evar _sqrt 
                                                                    (Tfunction
                                                                    (tdouble ::
                                                                    nil)
                                                                    tdouble
                                                                    cc_default))
                                                                    (Tfunction
                                                                    (tdouble ::
                                                                    nil)
                                                                    tdouble
                                                                    cc_default))
                                                                    (Econs
                                                                    (Evalof
                                                                    (Evar _argument tdouble)
                                                                    tdouble)
                                                                    Enil)
                                                                    tdouble)
                                                                    tdouble))
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _cd tdouble)
                                                                    (Ebinop Odiv
                                                                    (Ebinop Oadd
                                                                    (Evalof
                                                                    (Evar _elev tdouble)
                                                                    tdouble)
                                                                    (Evalof
                                                                    (Evar _dd tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    (Evalof
                                                                    (Evar _r tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    tdouble))
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _sd tdouble)
                                                                    (Ebinop Odiv
                                                                    (Ebinop Omul
                                                                    (Ebinop Omul
                                                                    (Ebinop Odiv
                                                                    (Ebinop Osub
                                                                    (Evalof
                                                                    (Evar _a2 tdouble)
                                                                    tdouble)
                                                                    (Evalof
                                                                    (Evar _b2 tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    (Evalof
                                                                    (Evar _dd tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    (Evalof
                                                                    (Evar _slat tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    (Evalof
                                                                    (Evar _clat tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    (Evalof
                                                                    (Evar _r tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    tdouble))
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _aa tdouble)
                                                                    (Evalof
                                                                    (Evar _slat tdouble)
                                                                    tdouble)
                                                                    tdouble))
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _slat tdouble)
                                                                    (Ebinop Osub
                                                                    (Ebinop Omul
                                                                    (Evalof
                                                                    (Evar _slat tdouble)
                                                                    tdouble)
                                                                    (Evalof
                                                                    (Evar _cd tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    (Ebinop Omul
                                                                    (Evalof
                                                                    (Evar _clat tdouble)
                                                                    tdouble)
                                                                    (Evalof
                                                                    (Evar _sd tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    tdouble))
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _clat tdouble)
                                                                    (Ebinop Oadd
                                                                    (Ebinop Omul
                                                                    (Evalof
                                                                    (Evar _clat tdouble)
                                                                    tdouble)
                                                                    (Evalof
                                                                    (Evar _cd tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    (Ebinop Omul
                                                                    (Evalof
                                                                    (Evar _aa tdouble)
                                                                    tdouble)
                                                                    (Evalof
                                                                    (Evar _sd tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    tdouble)))))))))))))
                                                      Sskip)
                                                    (Ssequence
                                                      (Sdo (Eassign
                                                             (Evar _ratio tdouble)
                                                             (Ebinop Odiv
                                                               (Evalof
                                                                 (Evar _earths_radius tdouble)
                                                                 tdouble)
                                                               (Evalof
                                                                 (Evar _r tdouble)
                                                                 tdouble)
                                                               tdouble)
                                                             tdouble))
                                                      (Ssequence
                                                        (Sdo (Eassign
                                                               (Evar _argument tdouble)
                                                               (Eval (Vfloat (Float.of_bits (Int64.repr 4613937818241073152))) tdouble)
                                                               tdouble))
                                                        (Ssequence
                                                          (Sdo (Eassign
                                                                 (Evar _aa tdouble)
                                                                 (Ecall
                                                                   (Evalof
                                                                    (Evar _sqrt 
                                                                    (Tfunction
                                                                    (tdouble ::
                                                                    nil)
                                                                    tdouble
                                                                    cc_default))
                                                                    (Tfunction
                                                                    (tdouble ::
                                                                    nil)
                                                                    tdouble
                                                                    cc_default))
                                                                   (Econs
                                                                    (Evalof
                                                                    (Evar _argument tdouble)
                                                                    tdouble)
                                                                    Enil)
                                                                   tdouble)
                                                                 tdouble))
                                                          (Ssequence
                                                            (Sdo (Eassign
                                                                   (Ederef
                                                                    (Ebinop Oadd
                                                                    (Evalof
                                                                    (Evar _p (tarray tfloat 119))
                                                                    (tarray tfloat 119))
                                                                    (Eval (Vint (Int.repr 1)) tint)
                                                                    (tptr tfloat))
                                                                    tfloat)
                                                                   (Ebinop Omul
                                                                    (Eval (Vfloat (Float.of_bits (Int64.repr 4611686018427387904))) tdouble)
                                                                    (Evalof
                                                                    (Evar _slat tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                   tfloat))
                                                            (Ssequence
                                                              (Sdo (Eassign
                                                                    (Ederef
                                                                    (Ebinop Oadd
                                                                    (Evalof
                                                                    (Evar _p (tarray tfloat 119))
                                                                    (tarray tfloat 119))
                                                                    (Eval (Vint (Int.repr 2)) tint)
                                                                    (tptr tfloat))
                                                                    tfloat)
                                                                    (Ebinop Omul
                                                                    (Eval (Vfloat (Float.of_bits (Int64.repr 4611686018427387904))) tdouble)
                                                                    (Evalof
                                                                    (Evar _clat tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    tfloat))
                                                              (Ssequence
                                                                (Sdo 
                                                                  (Eassign
                                                                    (Ederef
                                                                    (Ebinop Oadd
                                                                    (Evalof
                                                                    (Evar _p (tarray tfloat 119))
                                                                    (tarray tfloat 119))
                                                                    (Eval (Vint (Int.repr 3)) tint)
                                                                    (tptr tfloat))
                                                                    tfloat)
                                                                    (Ebinop Osub
                                                                    (Ebinop Omul
                                                                    (Ebinop Omul
                                                                    (Eval (Vfloat (Float.of_bits (Int64.repr 4616752568008179712))) tdouble)
                                                                    (Evalof
                                                                    (Evar _slat tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    (Evalof
                                                                    (Evar _slat tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    (Eval (Vfloat (Float.of_bits (Int64.repr 4609434218613702656))) tdouble)
                                                                    tdouble)
                                                                    tfloat))
                                                                (Ssequence
                                                                  (Sdo 
                                                                    (Eassign
                                                                    (Ederef
                                                                    (Ebinop Oadd
                                                                    (Evalof
                                                                    (Evar _p (tarray tfloat 119))
                                                                    (tarray tfloat 119))
                                                                    (Eval (Vint (Int.repr 4)) tint)
                                                                    (tptr tfloat))
                                                                    tfloat)
                                                                    (Ebinop Omul
                                                                    (Ebinop Omul
                                                                    (Ebinop Omul
                                                                    (Eval (Vfloat (Float.of_bits (Int64.repr 4613937818241073152))) tdouble)
                                                                    (Evalof
                                                                    (Evar _aa tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    (Evalof
                                                                    (Evar _clat tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    (Evalof
                                                                    (Evar _slat tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    tfloat))
                                                                  (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Ederef
                                                                    (Ebinop Oadd
                                                                    (Evalof
                                                                    (Evar _q (tarray tfloat 119))
                                                                    (tarray tfloat 119))
                                                                    (Eval (Vint (Int.repr 1)) tint)
                                                                    (tptr tfloat))
                                                                    tfloat)
                                                                    (Eunop Oneg
                                                                    (Evalof
                                                                    (Evar _clat tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    tfloat))
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Ederef
                                                                    (Ebinop Oadd
                                                                    (Evalof
                                                                    (Evar _q (tarray tfloat 119))
                                                                    (tarray tfloat 119))
                                                                    (Eval (Vint (Int.repr 2)) tint)
                                                                    (tptr tfloat))
                                                                    tfloat)
                                                                    (Evalof
                                                                    (Evar _slat tdouble)
                                                                    tdouble)
                                                                    tfloat))
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Ederef
                                                                    (Ebinop Oadd
                                                                    (Evalof
                                                                    (Evar _q (tarray tfloat 119))
                                                                    (tarray tfloat 119))
                                                                    (Eval (Vint (Int.repr 3)) tint)
                                                                    (tptr tfloat))
                                                                    tfloat)
                                                                    (Ebinop Omul
                                                                    (Ebinop Omul
                                                                    (Eunop Oneg
                                                                    (Eval (Vfloat (Float.of_bits (Int64.repr 4613937818241073152))) tdouble)
                                                                    tdouble)
                                                                    (Evalof
                                                                    (Evar _clat tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    (Evalof
                                                                    (Evar _slat tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    tfloat))
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Ederef
                                                                    (Ebinop Oadd
                                                                    (Evalof
                                                                    (Evar _q (tarray tfloat 119))
                                                                    (tarray tfloat 119))
                                                                    (Eval (Vint (Int.repr 4)) tint)
                                                                    (tptr tfloat))
                                                                    tfloat)
                                                                    (Ebinop Omul
                                                                    (Evalof
                                                                    (Evar _aa tdouble)
                                                                    tdouble)
                                                                    (Ebinop Osub
                                                                    (Ebinop Omul
                                                                    (Evalof
                                                                    (Evar _slat tdouble)
                                                                    tdouble)
                                                                    (Evalof
                                                                    (Evar _slat tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    (Ebinop Omul
                                                                    (Evalof
                                                                    (Evar _clat tdouble)
                                                                    tdouble)
                                                                    (Evalof
                                                                    (Evar _clat tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    tfloat))
                                                                    (Ssequence
                                                                    (Sfor
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _k tint)
                                                                    (Eval (Vint (Int.repr 1)) tint)
                                                                    tint))
                                                                    (Ebinop Ole
                                                                    (Evalof
                                                                    (Evar _k tint)
                                                                    tint)
                                                                    (Evalof
                                                                    (Evar _npq tint)
                                                                    tint)
                                                                    tint)
                                                                    (Sdo 
                                                                    (Eassignop
                                                                    Oadd
                                                                    (Evar _k tint)
                                                                    (Eval (Vint (Int.repr 1)) tint)
                                                                    tint tint))
                                                                    (Ssequence
                                                                    (Sifthenelse 
                                                                    (Ebinop Olt
                                                                    (Evalof
                                                                    (Evar _n tint)
                                                                    tint)
                                                                    (Evalof
                                                                    (Evar _m tint)
                                                                    tint)
                                                                    tint)
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _m tint)
                                                                    (Eval (Vint (Int.repr 0)) tint)
                                                                    tint))
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _n tint)
                                                                    (Ebinop Oadd
                                                                    (Evalof
                                                                    (Evar _n tint)
                                                                    tint)
                                                                    (Eval (Vint (Int.repr 1)) tint)
                                                                    tint)
                                                                    tint))
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _argument tdouble)
                                                                    (Evalof
                                                                    (Evar _ratio tdouble)
                                                                    tdouble)
                                                                    tdouble))
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _power tdouble)
                                                                    (Ebinop Oadd
                                                                    (Evalof
                                                                    (Evar _n tint)
                                                                    tint)
                                                                    (Eval (Vint (Int.repr 2)) tint)
                                                                    tint)
                                                                    tdouble))
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _rr tdouble)
                                                                    (Ecall
                                                                    (Evalof
                                                                    (Evar _pow 
                                                                    (Tfunction
                                                                    (tdouble ::
                                                                    tdouble ::
                                                                    nil)
                                                                    tdouble
                                                                    cc_default))
                                                                    (Tfunction
                                                                    (tdouble ::
                                                                    tdouble ::
                                                                    nil)
                                                                    tdouble
                                                                    cc_default))
                                                                    (Econs
                                                                    (Evalof
                                                                    (Evar _argument tdouble)
                                                                    tdouble)
                                                                    (Econs
                                                                    (Evalof
                                                                    (Evar _power tdouble)
                                                                    tdouble)
                                                                    Enil))
                                                                    tdouble)
                                                                    tdouble))
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _fn tdouble)
                                                                    (Evalof
                                                                    (Evar _n tint)
                                                                    tint)
                                                                    tdouble)))))))
                                                                    Sskip)
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _fm tdouble)
                                                                    (Evalof
                                                                    (Evar _m tint)
                                                                    tint)
                                                                    tdouble))
                                                                    (Ssequence
                                                                    (Sifthenelse 
                                                                    (Ebinop Oge
                                                                    (Evalof
                                                                    (Evar _k tint)
                                                                    tint)
                                                                    (Eval (Vint (Int.repr 5)) tint)
                                                                    tint)
                                                                    (Sifthenelse 
                                                                    (Ebinop Oeq
                                                                    (Evalof
                                                                    (Evar _m tint)
                                                                    tint)
                                                                    (Evalof
                                                                    (Evar _n tint)
                                                                    tint)
                                                                    tint)
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _argument tdouble)
                                                                    (Ebinop Osub
                                                                    (Eval (Vfloat (Float.of_bits (Int64.repr 4607182418800017408))) tdouble)
                                                                    (Ebinop Odiv
                                                                    (Eval (Vfloat (Float.of_bits (Int64.repr 4602678819172646912))) tdouble)
                                                                    (Evalof
                                                                    (Evar _fm tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    tdouble))
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _aa tdouble)
                                                                    (Ecall
                                                                    (Evalof
                                                                    (Evar _sqrt 
                                                                    (Tfunction
                                                                    (tdouble ::
                                                                    nil)
                                                                    tdouble
                                                                    cc_default))
                                                                    (Tfunction
                                                                    (tdouble ::
                                                                    nil)
                                                                    tdouble
                                                                    cc_default))
                                                                    (Econs
                                                                    (Evalof
                                                                    (Evar _argument tdouble)
                                                                    tdouble)
                                                                    Enil)
                                                                    tdouble)
                                                                    tdouble))
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _j tint)
                                                                    (Ebinop Osub
                                                                    (Ebinop Osub
                                                                    (Evalof
                                                                    (Evar _k tint)
                                                                    tint)
                                                                    (Evalof
                                                                    (Evar _n tint)
                                                                    tint)
                                                                    tint)
                                                                    (Eval (Vint (Int.repr 1)) tint)
                                                                    tint)
                                                                    tint))
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Ederef
                                                                    (Ebinop Oadd
                                                                    (Evalof
                                                                    (Evar _p (tarray tfloat 119))
                                                                    (tarray tfloat 119))
                                                                    (Evalof
                                                                    (Evar _k tint)
                                                                    tint)
                                                                    (tptr tfloat))
                                                                    tfloat)
                                                                    (Ebinop Omul
                                                                    (Ebinop Omul
                                                                    (Ebinop Omul
                                                                    (Ebinop Oadd
                                                                    (Eval (Vfloat (Float.of_bits (Int64.repr 4607182418800017408))) tdouble)
                                                                    (Ebinop Odiv
                                                                    (Eval (Vfloat (Float.of_bits (Int64.repr 4607182418800017408))) tdouble)
                                                                    (Evalof
                                                                    (Evar _fm tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    (Evalof
                                                                    (Evar _aa tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    (Evalof
                                                                    (Evar _clat tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    (Evalof
                                                                    (Ederef
                                                                    (Ebinop Oadd
                                                                    (Evalof
                                                                    (Evar _p (tarray tfloat 119))
                                                                    (tarray tfloat 119))
                                                                    (Evalof
                                                                    (Evar _j tint)
                                                                    tint)
                                                                    (tptr tfloat))
                                                                    tfloat)
                                                                    tfloat)
                                                                    tdouble)
                                                                    tfloat))
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Ederef
                                                                    (Ebinop Oadd
                                                                    (Evalof
                                                                    (Evar _q (tarray tfloat 119))
                                                                    (tarray tfloat 119))
                                                                    (Evalof
                                                                    (Evar _k tint)
                                                                    tint)
                                                                    (tptr tfloat))
                                                                    tfloat)
                                                                    (Ebinop Omul
                                                                    (Evalof
                                                                    (Evar _aa tdouble)
                                                                    tdouble)
                                                                    (Ebinop Oadd
                                                                    (Ebinop Omul
                                                                    (Evalof
                                                                    (Evar _clat tdouble)
                                                                    tdouble)
                                                                    (Evalof
                                                                    (Ederef
                                                                    (Ebinop Oadd
                                                                    (Evalof
                                                                    (Evar _q (tarray tfloat 119))
                                                                    (tarray tfloat 119))
                                                                    (Evalof
                                                                    (Evar _j tint)
                                                                    tint)
                                                                    (tptr tfloat))
                                                                    tfloat)
                                                                    tfloat)
                                                                    tdouble)
                                                                    (Ebinop Omul
                                                                    (Ebinop Odiv
                                                                    (Evalof
                                                                    (Evar _slat tdouble)
                                                                    tdouble)
                                                                    (Evalof
                                                                    (Evar _fm tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    (Evalof
                                                                    (Ederef
                                                                    (Ebinop Oadd
                                                                    (Evalof
                                                                    (Evar _p (tarray tfloat 119))
                                                                    (tarray tfloat 119))
                                                                    (Evalof
                                                                    (Evar _j tint)
                                                                    tint)
                                                                    (tptr tfloat))
                                                                    tfloat)
                                                                    tfloat)
                                                                    tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    tfloat))
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Ederef
                                                                    (Ebinop Oadd
                                                                    (Evalof
                                                                    (Evar _sl (tarray tdouble 14))
                                                                    (tarray tdouble 14))
                                                                    (Evalof
                                                                    (Evar _m tint)
                                                                    tint)
                                                                    (tptr tdouble))
                                                                    tdouble)
                                                                    (Ebinop Oadd
                                                                    (Ebinop Omul
                                                                    (Evalof
                                                                    (Ederef
                                                                    (Ebinop Oadd
                                                                    (Evalof
                                                                    (Evar _sl (tarray tdouble 14))
                                                                    (tarray tdouble 14))
                                                                    (Ebinop Osub
                                                                    (Evalof
                                                                    (Evar _m tint)
                                                                    tint)
                                                                    (Eval (Vint (Int.repr 1)) tint)
                                                                    tint)
                                                                    (tptr tdouble))
                                                                    tdouble)
                                                                    tdouble)
                                                                    (Evalof
                                                                    (Ederef
                                                                    (Ebinop Oadd
                                                                    (Evalof
                                                                    (Evar _cl (tarray tdouble 14))
                                                                    (tarray tdouble 14))
                                                                    (Eval (Vint (Int.repr 1)) tint)
                                                                    (tptr tdouble))
                                                                    tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    (Ebinop Omul
                                                                    (Evalof
                                                                    (Ederef
                                                                    (Ebinop Oadd
                                                                    (Evalof
                                                                    (Evar _cl (tarray tdouble 14))
                                                                    (tarray tdouble 14))
                                                                    (Ebinop Osub
                                                                    (Evalof
                                                                    (Evar _m tint)
                                                                    tint)
                                                                    (Eval (Vint (Int.repr 1)) tint)
                                                                    tint)
                                                                    (tptr tdouble))
                                                                    tdouble)
                                                                    tdouble)
                                                                    (Evalof
                                                                    (Ederef
                                                                    (Ebinop Oadd
                                                                    (Evalof
                                                                    (Evar _sl (tarray tdouble 14))
                                                                    (tarray tdouble 14))
                                                                    (Eval (Vint (Int.repr 1)) tint)
                                                                    (tptr tdouble))
                                                                    tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    tdouble))
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Ederef
                                                                    (Ebinop Oadd
                                                                    (Evalof
                                                                    (Evar _cl (tarray tdouble 14))
                                                                    (tarray tdouble 14))
                                                                    (Evalof
                                                                    (Evar _m tint)
                                                                    tint)
                                                                    (tptr tdouble))
                                                                    tdouble)
                                                                    (Ebinop Osub
                                                                    (Ebinop Omul
                                                                    (Evalof
                                                                    (Ederef
                                                                    (Ebinop Oadd
                                                                    (Evalof
                                                                    (Evar _cl (tarray tdouble 14))
                                                                    (tarray tdouble 14))
                                                                    (Ebinop Osub
                                                                    (Evalof
                                                                    (Evar _m tint)
                                                                    tint)
                                                                    (Eval (Vint (Int.repr 1)) tint)
                                                                    tint)
                                                                    (tptr tdouble))
                                                                    tdouble)
                                                                    tdouble)
                                                                    (Evalof
                                                                    (Ederef
                                                                    (Ebinop Oadd
                                                                    (Evalof
                                                                    (Evar _cl (tarray tdouble 14))
                                                                    (tarray tdouble 14))
                                                                    (Eval (Vint (Int.repr 1)) tint)
                                                                    (tptr tdouble))
                                                                    tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    (Ebinop Omul
                                                                    (Evalof
                                                                    (Ederef
                                                                    (Ebinop Oadd
                                                                    (Evalof
                                                                    (Evar _sl (tarray tdouble 14))
                                                                    (tarray tdouble 14))
                                                                    (Ebinop Osub
                                                                    (Evalof
                                                                    (Evar _m tint)
                                                                    tint)
                                                                    (Eval (Vint (Int.repr 1)) tint)
                                                                    tint)
                                                                    (tptr tdouble))
                                                                    tdouble)
                                                                    tdouble)
                                                                    (Evalof
                                                                    (Ederef
                                                                    (Ebinop Oadd
                                                                    (Evalof
                                                                    (Evar _sl (tarray tdouble 14))
                                                                    (tarray tdouble 14))
                                                                    (Eval (Vint (Int.repr 1)) tint)
                                                                    (tptr tdouble))
                                                                    tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    tdouble))))))))
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _argument tdouble)
                                                                    (Ebinop Osub
                                                                    (Ebinop Omul
                                                                    (Evalof
                                                                    (Evar _fn tdouble)
                                                                    tdouble)
                                                                    (Evalof
                                                                    (Evar _fn tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    (Ebinop Omul
                                                                    (Evalof
                                                                    (Evar _fm tdouble)
                                                                    tdouble)
                                                                    (Evalof
                                                                    (Evar _fm tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    tdouble))
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _aa tdouble)
                                                                    (Ecall
                                                                    (Evalof
                                                                    (Evar _sqrt 
                                                                    (Tfunction
                                                                    (tdouble ::
                                                                    nil)
                                                                    tdouble
                                                                    cc_default))
                                                                    (Tfunction
                                                                    (tdouble ::
                                                                    nil)
                                                                    tdouble
                                                                    cc_default))
                                                                    (Econs
                                                                    (Evalof
                                                                    (Evar _argument tdouble)
                                                                    tdouble)
                                                                    Enil)
                                                                    tdouble)
                                                                    tdouble))
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _argument tdouble)
                                                                    (Ebinop Osub
                                                                    (Ebinop Omul
                                                                    (Ebinop Osub
                                                                    (Evalof
                                                                    (Evar _fn tdouble)
                                                                    tdouble)
                                                                    (Eval (Vfloat (Float.of_bits (Int64.repr 4607182418800017408))) tdouble)
                                                                    tdouble)
                                                                    (Ebinop Osub
                                                                    (Evalof
                                                                    (Evar _fn tdouble)
                                                                    tdouble)
                                                                    (Eval (Vfloat (Float.of_bits (Int64.repr 4607182418800017408))) tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    (Ebinop Omul
                                                                    (Evalof
                                                                    (Evar _fm tdouble)
                                                                    tdouble)
                                                                    (Evalof
                                                                    (Evar _fm tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    tdouble))
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _bb tdouble)
                                                                    (Ebinop Odiv
                                                                    (Ecall
                                                                    (Evalof
                                                                    (Evar _sqrt 
                                                                    (Tfunction
                                                                    (tdouble ::
                                                                    nil)
                                                                    tdouble
                                                                    cc_default))
                                                                    (Tfunction
                                                                    (tdouble ::
                                                                    nil)
                                                                    tdouble
                                                                    cc_default))
                                                                    (Econs
                                                                    (Evalof
                                                                    (Evar _argument tdouble)
                                                                    tdouble)
                                                                    Enil)
                                                                    tdouble)
                                                                    (Evalof
                                                                    (Evar _aa tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    tdouble))
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _cc tdouble)
                                                                    (Ebinop Odiv
                                                                    (Ebinop Osub
                                                                    (Ebinop Omul
                                                                    (Eval (Vfloat (Float.of_bits (Int64.repr 4611686018427387904))) tdouble)
                                                                    (Evalof
                                                                    (Evar _fn tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    (Eval (Vfloat (Float.of_bits (Int64.repr 4607182418800017408))) tdouble)
                                                                    tdouble)
                                                                    (Evalof
                                                                    (Evar _aa tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    tdouble))
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _ii tint)
                                                                    (Ebinop Osub
                                                                    (Evalof
                                                                    (Evar _k tint)
                                                                    tint)
                                                                    (Evalof
                                                                    (Evar _n tint)
                                                                    tint)
                                                                    tint)
                                                                    tint))
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _j tint)
                                                                    (Ebinop Oadd
                                                                    (Ebinop Osub
                                                                    (Evalof
                                                                    (Evar _k tint)
                                                                    tint)
                                                                    (Ebinop Omul
                                                                    (Eval (Vint (Int.repr 2)) tint)
                                                                    (Evalof
                                                                    (Evar _n tint)
                                                                    tint)
                                                                    tint)
                                                                    tint)
                                                                    (Eval (Vint (Int.repr 1)) tint)
                                                                    tint)
                                                                    tint))
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Ederef
                                                                    (Ebinop Oadd
                                                                    (Evalof
                                                                    (Evar _p (tarray tfloat 119))
                                                                    (tarray tfloat 119))
                                                                    (Evalof
                                                                    (Evar _k tint)
                                                                    tint)
                                                                    (tptr tfloat))
                                                                    tfloat)
                                                                    (Ebinop Omul
                                                                    (Ebinop Oadd
                                                                    (Evalof
                                                                    (Evar _fn tdouble)
                                                                    tdouble)
                                                                    (Eval (Vfloat (Float.of_bits (Int64.repr 4607182418800017408))) tdouble)
                                                                    tdouble)
                                                                    (Ebinop Osub
                                                                    (Ebinop Omul
                                                                    (Ebinop Odiv
                                                                    (Ebinop Omul
                                                                    (Evalof
                                                                    (Evar _cc tdouble)
                                                                    tdouble)
                                                                    (Evalof
                                                                    (Evar _slat tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    (Evalof
                                                                    (Evar _fn tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    (Evalof
                                                                    (Ederef
                                                                    (Ebinop Oadd
                                                                    (Evalof
                                                                    (Evar _p (tarray tfloat 119))
                                                                    (tarray tfloat 119))
                                                                    (Evalof
                                                                    (Evar _ii tint)
                                                                    tint)
                                                                    (tptr tfloat))
                                                                    tfloat)
                                                                    tfloat)
                                                                    tdouble)
                                                                    (Ebinop Omul
                                                                    (Ebinop Odiv
                                                                    (Evalof
                                                                    (Evar _bb tdouble)
                                                                    tdouble)
                                                                    (Ebinop Osub
                                                                    (Evalof
                                                                    (Evar _fn tdouble)
                                                                    tdouble)
                                                                    (Eval (Vfloat (Float.of_bits (Int64.repr 4607182418800017408))) tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    (Evalof
                                                                    (Ederef
                                                                    (Ebinop Oadd
                                                                    (Evalof
                                                                    (Evar _p (tarray tfloat 119))
                                                                    (tarray tfloat 119))
                                                                    (Evalof
                                                                    (Evar _j tint)
                                                                    tint)
                                                                    (tptr tfloat))
                                                                    tfloat)
                                                                    tfloat)
                                                                    tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    tfloat))
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Ederef
                                                                    (Ebinop Oadd
                                                                    (Evalof
                                                                    (Evar _q (tarray tfloat 119))
                                                                    (tarray tfloat 119))
                                                                    (Evalof
                                                                    (Evar _k tint)
                                                                    tint)
                                                                    (tptr tfloat))
                                                                    tfloat)
                                                                    (Ebinop Osub
                                                                    (Ebinop Omul
                                                                    (Evalof
                                                                    (Evar _cc tdouble)
                                                                    tdouble)
                                                                    (Ebinop Osub
                                                                    (Ebinop Omul
                                                                    (Evalof
                                                                    (Evar _slat tdouble)
                                                                    tdouble)
                                                                    (Evalof
                                                                    (Ederef
                                                                    (Ebinop Oadd
                                                                    (Evalof
                                                                    (Evar _q (tarray tfloat 119))
                                                                    (tarray tfloat 119))
                                                                    (Evalof
                                                                    (Evar _ii tint)
                                                                    tint)
                                                                    (tptr tfloat))
                                                                    tfloat)
                                                                    tfloat)
                                                                    tdouble)
                                                                    (Ebinop Omul
                                                                    (Ebinop Odiv
                                                                    (Evalof
                                                                    (Evar _clat tdouble)
                                                                    tdouble)
                                                                    (Evalof
                                                                    (Evar _fn tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    (Evalof
                                                                    (Ederef
                                                                    (Ebinop Oadd
                                                                    (Evalof
                                                                    (Evar _p (tarray tfloat 119))
                                                                    (tarray tfloat 119))
                                                                    (Evalof
                                                                    (Evar _ii tint)
                                                                    tint)
                                                                    (tptr tfloat))
                                                                    tfloat)
                                                                    tfloat)
                                                                    tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    (Ebinop Omul
                                                                    (Evalof
                                                                    (Evar _bb tdouble)
                                                                    tdouble)
                                                                    (Evalof
                                                                    (Ederef
                                                                    (Ebinop Oadd
                                                                    (Evalof
                                                                    (Evar _q (tarray tfloat 119))
                                                                    (tarray tfloat 119))
                                                                    (Evalof
                                                                    (Evar _j tint)
                                                                    tint)
                                                                    (tptr tfloat))
                                                                    tfloat)
                                                                    tfloat)
                                                                    tdouble)
                                                                    tdouble)
                                                                    tfloat)))))))))))
                                                                    Sskip)
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _aa tdouble)
                                                                    (Ebinop Omul
                                                                    (Evalof
                                                                    (Evar _rr tdouble)
                                                                    tdouble)
                                                                    (Evalof
                                                                    (Ederef
                                                                    (Ebinop Oadd
                                                                    (Evalof
                                                                    (Evar _gh (tptr tdouble))
                                                                    (tptr tdouble))
                                                                    (Evalof
                                                                    (Evar _l tint)
                                                                    tint)
                                                                    (tptr tdouble))
                                                                    tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    tdouble))
                                                                    (Ssequence
                                                                    (Sifthenelse 
                                                                    (Ebinop Oeq
                                                                    (Evalof
                                                                    (Evar _m tint)
                                                                    tint)
                                                                    (Eval (Vint (Int.repr 0)) tint)
                                                                    tint)
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Ederef
                                                                    (Evalof
                                                                    (Evar _geo_mag_x (tptr tdouble))
                                                                    (tptr tdouble))
                                                                    tdouble)
                                                                    (Ebinop Oadd
                                                                    (Evalof
                                                                    (Ederef
                                                                    (Evalof
                                                                    (Evar _geo_mag_x (tptr tdouble))
                                                                    (tptr tdouble))
                                                                    tdouble)
                                                                    tdouble)
                                                                    (Ebinop Omul
                                                                    (Evalof
                                                                    (Evar _aa tdouble)
                                                                    tdouble)
                                                                    (Evalof
                                                                    (Ederef
                                                                    (Ebinop Oadd
                                                                    (Evalof
                                                                    (Evar _q (tarray tfloat 119))
                                                                    (tarray tfloat 119))
                                                                    (Evalof
                                                                    (Evar _k tint)
                                                                    tint)
                                                                    (tptr tfloat))
                                                                    tfloat)
                                                                    tfloat)
                                                                    tdouble)
                                                                    tdouble)
                                                                    tdouble))
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Ederef
                                                                    (Evalof
                                                                    (Evar _geo_mag_z (tptr tdouble))
                                                                    (tptr tdouble))
                                                                    tdouble)
                                                                    (Ebinop Osub
                                                                    (Evalof
                                                                    (Ederef
                                                                    (Evalof
                                                                    (Evar _geo_mag_z (tptr tdouble))
                                                                    (tptr tdouble))
                                                                    tdouble)
                                                                    tdouble)
                                                                    (Ebinop Omul
                                                                    (Evalof
                                                                    (Evar _aa tdouble)
                                                                    tdouble)
                                                                    (Evalof
                                                                    (Ederef
                                                                    (Ebinop Oadd
                                                                    (Evalof
                                                                    (Evar _p (tarray tfloat 119))
                                                                    (tarray tfloat 119))
                                                                    (Evalof
                                                                    (Evar _k tint)
                                                                    tint)
                                                                    (tptr tfloat))
                                                                    tfloat)
                                                                    tfloat)
                                                                    tdouble)
                                                                    tdouble)
                                                                    tdouble))
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _l tint)
                                                                    (Ebinop Oadd
                                                                    (Evalof
                                                                    (Evar _l tint)
                                                                    tint)
                                                                    (Eval (Vint (Int.repr 1)) tint)
                                                                    tint)
                                                                    tint))))
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _bb tdouble)
                                                                    (Ebinop Omul
                                                                    (Evalof
                                                                    (Evar _rr tdouble)
                                                                    tdouble)
                                                                    (Evalof
                                                                    (Ederef
                                                                    (Ebinop Oadd
                                                                    (Evalof
                                                                    (Evar _gh (tptr tdouble))
                                                                    (tptr tdouble))
                                                                    (Ebinop Oadd
                                                                    (Evalof
                                                                    (Evar _l tint)
                                                                    tint)
                                                                    (Eval (Vint (Int.repr 1)) tint)
                                                                    tint)
                                                                    (tptr tdouble))
                                                                    tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    tdouble))
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _cc tdouble)
                                                                    (Ebinop Oadd
                                                                    (Ebinop Omul
                                                                    (Evalof
                                                                    (Evar _aa tdouble)
                                                                    tdouble)
                                                                    (Evalof
                                                                    (Ederef
                                                                    (Ebinop Oadd
                                                                    (Evalof
                                                                    (Evar _cl (tarray tdouble 14))
                                                                    (tarray tdouble 14))
                                                                    (Evalof
                                                                    (Evar _m tint)
                                                                    tint)
                                                                    (tptr tdouble))
                                                                    tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    (Ebinop Omul
                                                                    (Evalof
                                                                    (Evar _bb tdouble)
                                                                    tdouble)
                                                                    (Evalof
                                                                    (Ederef
                                                                    (Ebinop Oadd
                                                                    (Evalof
                                                                    (Evar _sl (tarray tdouble 14))
                                                                    (tarray tdouble 14))
                                                                    (Evalof
                                                                    (Evar _m tint)
                                                                    tint)
                                                                    (tptr tdouble))
                                                                    tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    tdouble))
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Ederef
                                                                    (Evalof
                                                                    (Evar _geo_mag_x (tptr tdouble))
                                                                    (tptr tdouble))
                                                                    tdouble)
                                                                    (Ebinop Oadd
                                                                    (Evalof
                                                                    (Ederef
                                                                    (Evalof
                                                                    (Evar _geo_mag_x (tptr tdouble))
                                                                    (tptr tdouble))
                                                                    tdouble)
                                                                    tdouble)
                                                                    (Ebinop Omul
                                                                    (Evalof
                                                                    (Evar _cc tdouble)
                                                                    tdouble)
                                                                    (Evalof
                                                                    (Ederef
                                                                    (Ebinop Oadd
                                                                    (Evalof
                                                                    (Evar _q (tarray tfloat 119))
                                                                    (tarray tfloat 119))
                                                                    (Evalof
                                                                    (Evar _k tint)
                                                                    tint)
                                                                    (tptr tfloat))
                                                                    tfloat)
                                                                    tfloat)
                                                                    tdouble)
                                                                    tdouble)
                                                                    tdouble))
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Ederef
                                                                    (Evalof
                                                                    (Evar _geo_mag_z (tptr tdouble))
                                                                    (tptr tdouble))
                                                                    tdouble)
                                                                    (Ebinop Osub
                                                                    (Evalof
                                                                    (Ederef
                                                                    (Evalof
                                                                    (Evar _geo_mag_z (tptr tdouble))
                                                                    (tptr tdouble))
                                                                    tdouble)
                                                                    tdouble)
                                                                    (Ebinop Omul
                                                                    (Evalof
                                                                    (Evar _cc tdouble)
                                                                    tdouble)
                                                                    (Evalof
                                                                    (Ederef
                                                                    (Ebinop Oadd
                                                                    (Evalof
                                                                    (Evar _p (tarray tfloat 119))
                                                                    (tarray tfloat 119))
                                                                    (Evalof
                                                                    (Evar _k tint)
                                                                    tint)
                                                                    (tptr tfloat))
                                                                    tfloat)
                                                                    tfloat)
                                                                    tdouble)
                                                                    tdouble)
                                                                    tdouble))
                                                                    (Ssequence
                                                                    (Sifthenelse 
                                                                    (Ebinop Ogt
                                                                    (Evalof
                                                                    (Evar _clat tdouble)
                                                                    tdouble)
                                                                    (Eval (Vint (Int.repr 0)) tint)
                                                                    tint)
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Ederef
                                                                    (Evalof
                                                                    (Evar _geo_mag_y (tptr tdouble))
                                                                    (tptr tdouble))
                                                                    tdouble)
                                                                    (Ebinop Oadd
                                                                    (Evalof
                                                                    (Ederef
                                                                    (Evalof
                                                                    (Evar _geo_mag_y (tptr tdouble))
                                                                    (tptr tdouble))
                                                                    tdouble)
                                                                    tdouble)
                                                                    (Ebinop Odiv
                                                                    (Ebinop Omul
                                                                    (Ebinop Omul
                                                                    (Ebinop Osub
                                                                    (Ebinop Omul
                                                                    (Evalof
                                                                    (Evar _aa tdouble)
                                                                    tdouble)
                                                                    (Evalof
                                                                    (Ederef
                                                                    (Ebinop Oadd
                                                                    (Evalof
                                                                    (Evar _sl (tarray tdouble 14))
                                                                    (tarray tdouble 14))
                                                                    (Evalof
                                                                    (Evar _m tint)
                                                                    tint)
                                                                    (tptr tdouble))
                                                                    tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    (Ebinop Omul
                                                                    (Evalof
                                                                    (Evar _bb tdouble)
                                                                    tdouble)
                                                                    (Evalof
                                                                    (Ederef
                                                                    (Ebinop Oadd
                                                                    (Evalof
                                                                    (Evar _cl (tarray tdouble 14))
                                                                    (tarray tdouble 14))
                                                                    (Evalof
                                                                    (Evar _m tint)
                                                                    tint)
                                                                    (tptr tdouble))
                                                                    tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    (Evalof
                                                                    (Evar _fm tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    (Evalof
                                                                    (Ederef
                                                                    (Ebinop Oadd
                                                                    (Evalof
                                                                    (Evar _p (tarray tfloat 119))
                                                                    (tarray tfloat 119))
                                                                    (Evalof
                                                                    (Evar _k tint)
                                                                    tint)
                                                                    (tptr tfloat))
                                                                    tfloat)
                                                                    tfloat)
                                                                    tdouble)
                                                                    (Ebinop Omul
                                                                    (Ebinop Oadd
                                                                    (Evalof
                                                                    (Evar _fn tdouble)
                                                                    tdouble)
                                                                    (Eval (Vfloat (Float.of_bits (Int64.repr 4607182418800017408))) tdouble)
                                                                    tdouble)
                                                                    (Evalof
                                                                    (Evar _clat tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    tdouble))
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Ederef
                                                                    (Evalof
                                                                    (Evar _geo_mag_y (tptr tdouble))
                                                                    (tptr tdouble))
                                                                    tdouble)
                                                                    (Ebinop Oadd
                                                                    (Evalof
                                                                    (Ederef
                                                                    (Evalof
                                                                    (Evar _geo_mag_y (tptr tdouble))
                                                                    (tptr tdouble))
                                                                    tdouble)
                                                                    tdouble)
                                                                    (Ebinop Omul
                                                                    (Ebinop Omul
                                                                    (Ebinop Osub
                                                                    (Ebinop Omul
                                                                    (Evalof
                                                                    (Evar _aa tdouble)
                                                                    tdouble)
                                                                    (Evalof
                                                                    (Ederef
                                                                    (Ebinop Oadd
                                                                    (Evalof
                                                                    (Evar _sl (tarray tdouble 14))
                                                                    (tarray tdouble 14))
                                                                    (Evalof
                                                                    (Evar _m tint)
                                                                    tint)
                                                                    (tptr tdouble))
                                                                    tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    (Ebinop Omul
                                                                    (Evalof
                                                                    (Evar _bb tdouble)
                                                                    tdouble)
                                                                    (Evalof
                                                                    (Ederef
                                                                    (Ebinop Oadd
                                                                    (Evalof
                                                                    (Evar _cl (tarray tdouble 14))
                                                                    (tarray tdouble 14))
                                                                    (Evalof
                                                                    (Evar _m tint)
                                                                    tint)
                                                                    (tptr tdouble))
                                                                    tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    (Evalof
                                                                    (Ederef
                                                                    (Ebinop Oadd
                                                                    (Evalof
                                                                    (Evar _q (tarray tfloat 119))
                                                                    (tarray tfloat 119))
                                                                    (Evalof
                                                                    (Evar _k tint)
                                                                    tint)
                                                                    (tptr tfloat))
                                                                    tfloat)
                                                                    tfloat)
                                                                    tdouble)
                                                                    (Evalof
                                                                    (Evar _slat tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    tdouble)))
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _l tint)
                                                                    (Ebinop Oadd
                                                                    (Evalof
                                                                    (Evar _l tint)
                                                                    tint)
                                                                    (Eval (Vint (Int.repr 2)) tint)
                                                                    tint)
                                                                    tint))))))))
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _m tint)
                                                                    (Ebinop Oadd
                                                                    (Evalof
                                                                    (Evar _m tint)
                                                                    tint)
                                                                    (Eval (Vint (Int.repr 1)) tint)
                                                                    tint)
                                                                    tint))))))))
                                                                    (Ssequence
                                                                    (Sifthenelse 
                                                                    (Ebinop One
                                                                    (Evalof
                                                                    (Evar _iext tshort)
                                                                    tshort)
                                                                    (Eval (Vint (Int.repr 0)) tint)
                                                                    tint)
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _aa tdouble)
                                                                    (Ebinop Oadd
                                                                    (Ebinop Omul
                                                                    (Evalof
                                                                    (Evar _ext2 tdouble)
                                                                    tdouble)
                                                                    (Evalof
                                                                    (Ederef
                                                                    (Ebinop Oadd
                                                                    (Evalof
                                                                    (Evar _cl (tarray tdouble 14))
                                                                    (tarray tdouble 14))
                                                                    (Eval (Vint (Int.repr 1)) tint)
                                                                    (tptr tdouble))
                                                                    tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    (Ebinop Omul
                                                                    (Evalof
                                                                    (Evar _ext3 tdouble)
                                                                    tdouble)
                                                                    (Evalof
                                                                    (Ederef
                                                                    (Ebinop Oadd
                                                                    (Evalof
                                                                    (Evar _sl (tarray tdouble 14))
                                                                    (tarray tdouble 14))
                                                                    (Eval (Vint (Int.repr 1)) tint)
                                                                    (tptr tdouble))
                                                                    tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    tdouble))
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Ederef
                                                                    (Evalof
                                                                    (Evar _geo_mag_x (tptr tdouble))
                                                                    (tptr tdouble))
                                                                    tdouble)
                                                                    (Ebinop Oadd
                                                                    (Ebinop Osub
                                                                    (Evalof
                                                                    (Ederef
                                                                    (Evalof
                                                                    (Evar _geo_mag_x (tptr tdouble))
                                                                    (tptr tdouble))
                                                                    tdouble)
                                                                    tdouble)
                                                                    (Ebinop Omul
                                                                    (Evalof
                                                                    (Evar _ext1 tdouble)
                                                                    tdouble)
                                                                    (Evalof
                                                                    (Evar _clat tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    (Ebinop Omul
                                                                    (Evalof
                                                                    (Evar _aa tdouble)
                                                                    tdouble)
                                                                    (Evalof
                                                                    (Evar _slat tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    tdouble))
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Ederef
                                                                    (Evalof
                                                                    (Evar _geo_mag_y (tptr tdouble))
                                                                    (tptr tdouble))
                                                                    tdouble)
                                                                    (Ebinop Osub
                                                                    (Ebinop Oadd
                                                                    (Evalof
                                                                    (Ederef
                                                                    (Evalof
                                                                    (Evar _geo_mag_y (tptr tdouble))
                                                                    (tptr tdouble))
                                                                    tdouble)
                                                                    tdouble)
                                                                    (Ebinop Omul
                                                                    (Evalof
                                                                    (Evar _ext2 tdouble)
                                                                    tdouble)
                                                                    (Evalof
                                                                    (Ederef
                                                                    (Ebinop Oadd
                                                                    (Evalof
                                                                    (Evar _sl (tarray tdouble 14))
                                                                    (tarray tdouble 14))
                                                                    (Eval (Vint (Int.repr 1)) tint)
                                                                    (tptr tdouble))
                                                                    tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    (Ebinop Omul
                                                                    (Evalof
                                                                    (Evar _ext3 tdouble)
                                                                    tdouble)
                                                                    (Evalof
                                                                    (Ederef
                                                                    (Ebinop Oadd
                                                                    (Evalof
                                                                    (Evar _cl (tarray tdouble 14))
                                                                    (tarray tdouble 14))
                                                                    (Eval (Vint (Int.repr 1)) tint)
                                                                    (tptr tdouble))
                                                                    tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    tdouble))
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Ederef
                                                                    (Evalof
                                                                    (Evar _geo_mag_z (tptr tdouble))
                                                                    (tptr tdouble))
                                                                    tdouble)
                                                                    (Ebinop Oadd
                                                                    (Ebinop Oadd
                                                                    (Evalof
                                                                    (Ederef
                                                                    (Evalof
                                                                    (Evar _geo_mag_z (tptr tdouble))
                                                                    (tptr tdouble))
                                                                    tdouble)
                                                                    tdouble)
                                                                    (Ebinop Omul
                                                                    (Evalof
                                                                    (Evar _ext1 tdouble)
                                                                    tdouble)
                                                                    (Evalof
                                                                    (Evar _slat tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    (Ebinop Omul
                                                                    (Evalof
                                                                    (Evar _aa tdouble)
                                                                    tdouble)
                                                                    (Evalof
                                                                    (Evar _clat tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    tdouble)))))
                                                                    Sskip)
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Evar _aa tdouble)
                                                                    (Evalof
                                                                    (Ederef
                                                                    (Evalof
                                                                    (Evar _geo_mag_x (tptr tdouble))
                                                                    (tptr tdouble))
                                                                    tdouble)
                                                                    tdouble)
                                                                    tdouble))
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Ederef
                                                                    (Evalof
                                                                    (Evar _geo_mag_x (tptr tdouble))
                                                                    (tptr tdouble))
                                                                    tdouble)
                                                                    (Ebinop Oadd
                                                                    (Ebinop Omul
                                                                    (Evalof
                                                                    (Ederef
                                                                    (Evalof
                                                                    (Evar _geo_mag_x (tptr tdouble))
                                                                    (tptr tdouble))
                                                                    tdouble)
                                                                    tdouble)
                                                                    (Evalof
                                                                    (Evar _cd tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    (Ebinop Omul
                                                                    (Evalof
                                                                    (Ederef
                                                                    (Evalof
                                                                    (Evar _geo_mag_z (tptr tdouble))
                                                                    (tptr tdouble))
                                                                    tdouble)
                                                                    tdouble)
                                                                    (Evalof
                                                                    (Evar _sd tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    tdouble))
                                                                    (Ssequence
                                                                    (Sdo 
                                                                    (Eassign
                                                                    (Ederef
                                                                    (Evalof
                                                                    (Evar _geo_mag_z (tptr tdouble))
                                                                    (tptr tdouble))
                                                                    tdouble)
                                                                    (Ebinop Osub
                                                                    (Ebinop Omul
                                                                    (Evalof
                                                                    (Ederef
                                                                    (Evalof
                                                                    (Evar _geo_mag_z (tptr tdouble))
                                                                    (tptr tdouble))
                                                                    tdouble)
                                                                    tdouble)
                                                                    (Evalof
                                                                    (Evar _cd tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    (Ebinop Omul
                                                                    (Evalof
                                                                    (Evar _aa tdouble)
                                                                    tdouble)
                                                                    (Evalof
                                                                    (Evar _sd tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    tdouble)
                                                                    tdouble))
                                                                    (Sreturn (Some 
                                                                    (Evalof
                                                                    (Evar _ios tint)
                                                                    tint)))))))))))))))))))))))))))))))))))))))))))))
|}.

Definition v_five_keep_extrapsh := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _extrapsh (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_mag_calc := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _mag_calc (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition composites : list composite_definition :=
nil.

Definition global_definitions : list (ident * globdef fundef type) :=
((___compcert_va_int32,
   Gfun(External (EF_runtime "__compcert_va_int32"
                   (mksignature (AST.Xptr :: nil) AST.Xint cc_default))
     ((tptr tvoid) :: nil) tuint cc_default)) ::
 (___compcert_va_int64,
   Gfun(External (EF_runtime "__compcert_va_int64"
                   (mksignature (AST.Xptr :: nil) AST.Xlong cc_default))
     ((tptr tvoid) :: nil) tulong cc_default)) ::
 (___compcert_va_float64,
   Gfun(External (EF_runtime "__compcert_va_float64"
                   (mksignature (AST.Xptr :: nil) AST.Xfloat cc_default))
     ((tptr tvoid) :: nil) tdouble cc_default)) ::
 (___compcert_va_composite,
   Gfun(External (EF_runtime "__compcert_va_composite"
                   (mksignature (AST.Xptr :: AST.Xlong :: nil) AST.Xptr
                     cc_default)) ((tptr tvoid) :: tulong :: nil)
     (tptr tvoid) cc_default)) ::
 (___compcert_i64_dtos,
   Gfun(External (EF_runtime "__compcert_i64_dtos"
                   (mksignature (AST.Xfloat :: nil) AST.Xlong cc_default))
     (tdouble :: nil) tlong cc_default)) ::
 (___compcert_i64_dtou,
   Gfun(External (EF_runtime "__compcert_i64_dtou"
                   (mksignature (AST.Xfloat :: nil) AST.Xlong cc_default))
     (tdouble :: nil) tulong cc_default)) ::
 (___compcert_i64_stod,
   Gfun(External (EF_runtime "__compcert_i64_stod"
                   (mksignature (AST.Xlong :: nil) AST.Xfloat cc_default))
     (tlong :: nil) tdouble cc_default)) ::
 (___compcert_i64_utod,
   Gfun(External (EF_runtime "__compcert_i64_utod"
                   (mksignature (AST.Xlong :: nil) AST.Xfloat cc_default))
     (tulong :: nil) tdouble cc_default)) ::
 (___compcert_i64_stof,
   Gfun(External (EF_runtime "__compcert_i64_stof"
                   (mksignature (AST.Xlong :: nil) AST.Xsingle cc_default))
     (tlong :: nil) tfloat cc_default)) ::
 (___compcert_i64_utof,
   Gfun(External (EF_runtime "__compcert_i64_utof"
                   (mksignature (AST.Xlong :: nil) AST.Xsingle cc_default))
     (tulong :: nil) tfloat cc_default)) ::
 (___compcert_i64_sdiv,
   Gfun(External (EF_runtime "__compcert_i64_sdiv"
                   (mksignature (AST.Xlong :: AST.Xlong :: nil) AST.Xlong
                     cc_default)) (tlong :: tlong :: nil) tlong cc_default)) ::
 (___compcert_i64_udiv,
   Gfun(External (EF_runtime "__compcert_i64_udiv"
                   (mksignature (AST.Xlong :: AST.Xlong :: nil) AST.Xlong
                     cc_default)) (tulong :: tulong :: nil) tulong
     cc_default)) ::
 (___compcert_i64_smod,
   Gfun(External (EF_runtime "__compcert_i64_smod"
                   (mksignature (AST.Xlong :: AST.Xlong :: nil) AST.Xlong
                     cc_default)) (tlong :: tlong :: nil) tlong cc_default)) ::
 (___compcert_i64_umod,
   Gfun(External (EF_runtime "__compcert_i64_umod"
                   (mksignature (AST.Xlong :: AST.Xlong :: nil) AST.Xlong
                     cc_default)) (tulong :: tulong :: nil) tulong
     cc_default)) ::
 (___compcert_i64_shl,
   Gfun(External (EF_runtime "__compcert_i64_shl"
                   (mksignature (AST.Xlong :: AST.Xint :: nil) AST.Xlong
                     cc_default)) (tlong :: tint :: nil) tlong cc_default)) ::
 (___compcert_i64_shr,
   Gfun(External (EF_runtime "__compcert_i64_shr"
                   (mksignature (AST.Xlong :: AST.Xint :: nil) AST.Xlong
                     cc_default)) (tulong :: tint :: nil) tulong cc_default)) ::
 (___compcert_i64_sar,
   Gfun(External (EF_runtime "__compcert_i64_sar"
                   (mksignature (AST.Xlong :: AST.Xint :: nil) AST.Xlong
                     cc_default)) (tlong :: tint :: nil) tlong cc_default)) ::
 (___compcert_i64_smulh,
   Gfun(External (EF_runtime "__compcert_i64_smulh"
                   (mksignature (AST.Xlong :: AST.Xlong :: nil) AST.Xlong
                     cc_default)) (tlong :: tlong :: nil) tlong cc_default)) ::
 (___compcert_i64_umulh,
   Gfun(External (EF_runtime "__compcert_i64_umulh"
                   (mksignature (AST.Xlong :: AST.Xlong :: nil) AST.Xlong
                     cc_default)) (tulong :: tulong :: nil) tulong
     cc_default)) ::
 (___builtin_ais_annot,
   Gfun(External (EF_builtin "__builtin_ais_annot"
                   (mksignature (AST.Xptr :: nil) AST.Xvoid
                     {|cc_vararg:=(Some 1); cc_unproto:=false; cc_structret:=false|}))
     ((tptr tschar) :: nil) tvoid
     {|cc_vararg:=(Some 1); cc_unproto:=false; cc_structret:=false|})) ::
 (___builtin_bswap64,
   Gfun(External (EF_builtin "__builtin_bswap64"
                   (mksignature (AST.Xlong :: nil) AST.Xlong cc_default))
     (tulong :: nil) tulong cc_default)) ::
 (___builtin_bswap,
   Gfun(External (EF_builtin "__builtin_bswap"
                   (mksignature (AST.Xint :: nil) AST.Xint cc_default))
     (tuint :: nil) tuint cc_default)) ::
 (___builtin_bswap32,
   Gfun(External (EF_builtin "__builtin_bswap32"
                   (mksignature (AST.Xint :: nil) AST.Xint cc_default))
     (tuint :: nil) tuint cc_default)) ::
 (___builtin_bswap16,
   Gfun(External (EF_builtin "__builtin_bswap16"
                   (mksignature (AST.Xint16unsigned :: nil)
                     AST.Xint16unsigned cc_default)) (tushort :: nil) tushort
     cc_default)) ::
 (___builtin_clz,
   Gfun(External (EF_builtin "__builtin_clz"
                   (mksignature (AST.Xint :: nil) AST.Xint cc_default))
     (tuint :: nil) tint cc_default)) ::
 (___builtin_clzl,
   Gfun(External (EF_builtin "__builtin_clzl"
                   (mksignature (AST.Xlong :: nil) AST.Xint cc_default))
     (tulong :: nil) tint cc_default)) ::
 (___builtin_clzll,
   Gfun(External (EF_builtin "__builtin_clzll"
                   (mksignature (AST.Xlong :: nil) AST.Xint cc_default))
     (tulong :: nil) tint cc_default)) ::
 (___builtin_ctz,
   Gfun(External (EF_builtin "__builtin_ctz"
                   (mksignature (AST.Xint :: nil) AST.Xint cc_default))
     (tuint :: nil) tint cc_default)) ::
 (___builtin_ctzl,
   Gfun(External (EF_builtin "__builtin_ctzl"
                   (mksignature (AST.Xlong :: nil) AST.Xint cc_default))
     (tulong :: nil) tint cc_default)) ::
 (___builtin_ctzll,
   Gfun(External (EF_builtin "__builtin_ctzll"
                   (mksignature (AST.Xlong :: nil) AST.Xint cc_default))
     (tulong :: nil) tint cc_default)) ::
 (___builtin_fabs,
   Gfun(External (EF_builtin "__builtin_fabs"
                   (mksignature (AST.Xfloat :: nil) AST.Xfloat cc_default))
     (tdouble :: nil) tdouble cc_default)) ::
 (___builtin_fabsf,
   Gfun(External (EF_builtin "__builtin_fabsf"
                   (mksignature (AST.Xsingle :: nil) AST.Xsingle cc_default))
     (tfloat :: nil) tfloat cc_default)) ::
 (___builtin_fsqrt,
   Gfun(External (EF_builtin "__builtin_fsqrt"
                   (mksignature (AST.Xfloat :: nil) AST.Xfloat cc_default))
     (tdouble :: nil) tdouble cc_default)) ::
 (___builtin_sqrt,
   Gfun(External (EF_builtin "__builtin_sqrt"
                   (mksignature (AST.Xfloat :: nil) AST.Xfloat cc_default))
     (tdouble :: nil) tdouble cc_default)) ::
 (___builtin_memcpy_aligned,
   Gfun(External (EF_builtin "__builtin_memcpy_aligned"
                   (mksignature
                     (AST.Xptr :: AST.Xptr :: AST.Xlong :: AST.Xlong :: nil)
                     AST.Xvoid cc_default))
     ((tptr tvoid) :: (tptr tvoid) :: tulong :: tulong :: nil) tvoid
     cc_default)) ::
 (___builtin_sel,
   Gfun(External (EF_builtin "__builtin_sel"
                   (mksignature (AST.Xbool :: nil) AST.Xvoid
                     {|cc_vararg:=(Some 1); cc_unproto:=false; cc_structret:=false|}))
     (tbool :: nil) tvoid
     {|cc_vararg:=(Some 1); cc_unproto:=false; cc_structret:=false|})) ::
 (___builtin_annot,
   Gfun(External (EF_builtin "__builtin_annot"
                   (mksignature (AST.Xptr :: nil) AST.Xvoid
                     {|cc_vararg:=(Some 1); cc_unproto:=false; cc_structret:=false|}))
     ((tptr tschar) :: nil) tvoid
     {|cc_vararg:=(Some 1); cc_unproto:=false; cc_structret:=false|})) ::
 (___builtin_annot_intval,
   Gfun(External (EF_builtin "__builtin_annot_intval"
                   (mksignature (AST.Xptr :: AST.Xint :: nil) AST.Xint
                     cc_default)) ((tptr tschar) :: tint :: nil) tint
     cc_default)) ::
 (___builtin_membar,
   Gfun(External (EF_builtin "__builtin_membar"
                   (mksignature nil AST.Xvoid cc_default)) nil tvoid
     cc_default)) ::
 (___builtin_va_start,
   Gfun(External (EF_builtin "__builtin_va_start"
                   (mksignature (AST.Xptr :: nil) AST.Xvoid cc_default))
     ((tptr tvoid) :: nil) tvoid cc_default)) ::
 (___builtin_va_arg,
   Gfun(External (EF_builtin "__builtin_va_arg"
                   (mksignature (AST.Xptr :: AST.Xint :: nil) AST.Xvoid
                     cc_default)) ((tptr tvoid) :: tuint :: nil) tvoid
     cc_default)) ::
 (___builtin_va_copy,
   Gfun(External (EF_builtin "__builtin_va_copy"
                   (mksignature (AST.Xptr :: AST.Xptr :: nil) AST.Xvoid
                     cc_default)) ((tptr tvoid) :: (tptr tvoid) :: nil) tvoid
     cc_default)) ::
 (___builtin_va_end,
   Gfun(External (EF_builtin "__builtin_va_end"
                   (mksignature (AST.Xptr :: nil) AST.Xvoid cc_default))
     ((tptr tvoid) :: nil) tvoid cc_default)) ::
 (___builtin_unreachable,
   Gfun(External (EF_builtin "__builtin_unreachable"
                   (mksignature nil AST.Xvoid cc_default)) nil tvoid
     cc_default)) ::
 (___builtin_expect,
   Gfun(External (EF_builtin "__builtin_expect"
                   (mksignature (AST.Xlong :: AST.Xlong :: nil) AST.Xlong
                     cc_default)) (tlong :: tlong :: nil) tlong cc_default)) ::
 (___builtin_fmax,
   Gfun(External (EF_builtin "__builtin_fmax"
                   (mksignature (AST.Xfloat :: AST.Xfloat :: nil) AST.Xfloat
                     cc_default)) (tdouble :: tdouble :: nil) tdouble
     cc_default)) ::
 (___builtin_fmin,
   Gfun(External (EF_builtin "__builtin_fmin"
                   (mksignature (AST.Xfloat :: AST.Xfloat :: nil) AST.Xfloat
                     cc_default)) (tdouble :: tdouble :: nil) tdouble
     cc_default)) ::
 (___builtin_fmadd,
   Gfun(External (EF_builtin "__builtin_fmadd"
                   (mksignature
                     (AST.Xfloat :: AST.Xfloat :: AST.Xfloat :: nil)
                     AST.Xfloat cc_default))
     (tdouble :: tdouble :: tdouble :: nil) tdouble cc_default)) ::
 (___builtin_fmsub,
   Gfun(External (EF_builtin "__builtin_fmsub"
                   (mksignature
                     (AST.Xfloat :: AST.Xfloat :: AST.Xfloat :: nil)
                     AST.Xfloat cc_default))
     (tdouble :: tdouble :: tdouble :: nil) tdouble cc_default)) ::
 (___builtin_fnmadd,
   Gfun(External (EF_builtin "__builtin_fnmadd"
                   (mksignature
                     (AST.Xfloat :: AST.Xfloat :: AST.Xfloat :: nil)
                     AST.Xfloat cc_default))
     (tdouble :: tdouble :: tdouble :: nil) tdouble cc_default)) ::
 (___builtin_fnmsub,
   Gfun(External (EF_builtin "__builtin_fnmsub"
                   (mksignature
                     (AST.Xfloat :: AST.Xfloat :: AST.Xfloat :: nil)
                     AST.Xfloat cc_default))
     (tdouble :: tdouble :: tdouble :: nil) tdouble cc_default)) ::
 (___builtin_read16_reversed,
   Gfun(External (EF_builtin "__builtin_read16_reversed"
                   (mksignature (AST.Xptr :: nil) AST.Xint16unsigned
                     cc_default)) ((tptr tushort) :: nil) tushort
     cc_default)) ::
 (___builtin_read32_reversed,
   Gfun(External (EF_builtin "__builtin_read32_reversed"
                   (mksignature (AST.Xptr :: nil) AST.Xint cc_default))
     ((tptr tuint) :: nil) tuint cc_default)) ::
 (___builtin_write16_reversed,
   Gfun(External (EF_builtin "__builtin_write16_reversed"
                   (mksignature (AST.Xptr :: AST.Xint16unsigned :: nil)
                     AST.Xvoid cc_default))
     ((tptr tushort) :: tushort :: nil) tvoid cc_default)) ::
 (___builtin_write32_reversed,
   Gfun(External (EF_builtin "__builtin_write32_reversed"
                   (mksignature (AST.Xptr :: AST.Xint :: nil) AST.Xvoid
                     cc_default)) ((tptr tuint) :: tuint :: nil) tvoid
     cc_default)) ::
 (___builtin_debug,
   Gfun(External (EF_external "__builtin_debug"
                   (mksignature (AST.Xint :: nil) AST.Xvoid
                     {|cc_vararg:=(Some 1); cc_unproto:=false; cc_structret:=false|}))
     (tint :: nil) tvoid
     {|cc_vararg:=(Some 1); cc_unproto:=false; cc_structret:=false|})) ::
 (_pow,
   Gfun(External (EF_external "pow"
                   (mksignature (AST.Xfloat :: AST.Xfloat :: nil) AST.Xfloat
                     cc_default)) (tdouble :: tdouble :: nil) tdouble
     cc_default)) ::
 (_sqrt,
   Gfun(External (EF_external "sqrt"
                   (mksignature (AST.Xfloat :: nil) AST.Xfloat cc_default))
     (tdouble :: nil) tdouble cc_default)) ::
 (_cosf,
   Gfun(External (EF_external "cosf"
                   (mksignature (AST.Xsingle :: nil) AST.Xsingle cc_default))
     (tfloat :: nil) tfloat cc_default)) ::
 (_sinf,
   Gfun(External (EF_external "sinf"
                   (mksignature (AST.Xsingle :: nil) AST.Xsingle cc_default))
     (tfloat :: nil) tfloat cc_default)) :: (_gh1, Gvar v_gh1) ::
 (_gh2, Gvar v_gh2) :: (_extrapsh, Gfun(Internal f_extrapsh)) ::
 (_mag_calc, Gfun(Internal f_mag_calc)) ::
 (_five_keep_extrapsh, Gvar v_five_keep_extrapsh) ::
 (_five_keep_mag_calc, Gvar v_five_keep_mag_calc) :: nil).

Definition public_idents : list ident :=
(_five_keep_mag_calc :: _five_keep_extrapsh :: _mag_calc :: _extrapsh ::
 _gh2 :: _gh1 :: _sinf :: _cosf :: _sqrt :: _pow :: ___builtin_debug ::
 ___builtin_write32_reversed :: ___builtin_write16_reversed ::
 ___builtin_read32_reversed :: ___builtin_read16_reversed ::
 ___builtin_fnmsub :: ___builtin_fnmadd :: ___builtin_fmsub ::
 ___builtin_fmadd :: ___builtin_fmin :: ___builtin_fmax ::
 ___builtin_expect :: ___builtin_unreachable :: ___builtin_va_end ::
 ___builtin_va_copy :: ___builtin_va_arg :: ___builtin_va_start ::
 ___builtin_membar :: ___builtin_annot_intval :: ___builtin_annot ::
 ___builtin_sel :: ___builtin_memcpy_aligned :: ___builtin_sqrt ::
 ___builtin_fsqrt :: ___builtin_fabsf :: ___builtin_fabs ::
 ___builtin_ctzll :: ___builtin_ctzl :: ___builtin_ctz :: ___builtin_clzll ::
 ___builtin_clzl :: ___builtin_clz :: ___builtin_bswap16 ::
 ___builtin_bswap32 :: ___builtin_bswap :: ___builtin_bswap64 ::
 ___builtin_ais_annot :: ___compcert_i64_umulh :: ___compcert_i64_smulh ::
 ___compcert_i64_sar :: ___compcert_i64_shr :: ___compcert_i64_shl ::
 ___compcert_i64_umod :: ___compcert_i64_smod :: ___compcert_i64_udiv ::
 ___compcert_i64_sdiv :: ___compcert_i64_utof :: ___compcert_i64_stof ::
 ___compcert_i64_utod :: ___compcert_i64_stod :: ___compcert_i64_dtou ::
 ___compcert_i64_dtos :: ___compcert_va_composite ::
 ___compcert_va_float64 :: ___compcert_va_int64 :: ___compcert_va_int32 ::
 nil).

Definition prog : Csyntax.program := 
  mkprogram composites global_definitions public_idents _main Logic.I.


