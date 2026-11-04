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
  Definition source_file := "/home/yangfp/five/_build/paparazzi/navigation-vision-models/integer_trigonometry/model/preprocessed.i".
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
Definition _a : ident := $"a".
Definition _abs : ident := $"abs".
Definition _abs_y : ident := $"abs_y".
Definition _angle : ident := $"angle".
Definition _c1 : ident := $"c1".
Definition _c2 : ident := $"c2".
Definition _five_keep_int32_atan2 : ident := $"five_keep_int32_atan2".
Definition _five_keep_int32_atan2_2 : ident := $"five_keep_int32_atan2_2".
Definition _five_keep_pprz_itrig_cos : ident := $"five_keep_pprz_itrig_cos".
Definition _five_keep_pprz_trig_int_init : ident := $"five_keep_pprz_trig_int_init".
Definition _int32_atan2 : ident := $"int32_atan2".
Definition _int32_atan2_2 : ident := $"int32_atan2_2".
Definition _main : ident := $"main".
Definition _pprz_itrig_cos : ident := $"pprz_itrig_cos".
Definition _pprz_itrig_sin : ident := $"pprz_itrig_sin".
Definition _pprz_trig_int : ident := $"pprz_trig_int".
Definition _pprz_trig_int_init : ident := $"pprz_trig_int_init".
Definition _r : ident := $"r".
Definition _r2 : ident := $"r2".
Definition _tmp1 : ident := $"tmp1".
Definition _x : ident := $"x".
Definition _y : ident := $"y".

Definition v_pprz_trig_int := {|
  gvar_info := (tarray tshort 6434);
  gvar_init := (Init_int16 (Int.repr 0) :: Init_int16 (Int.repr 3) ::
                Init_int16 (Int.repr 7) :: Init_int16 (Int.repr 11) ::
                Init_int16 (Int.repr 15) :: Init_int16 (Int.repr 19) ::
                Init_int16 (Int.repr 23) :: Init_int16 (Int.repr 27) ::
                Init_int16 (Int.repr 31) :: Init_int16 (Int.repr 35) ::
                Init_int16 (Int.repr 39) :: Init_int16 (Int.repr 43) ::
                Init_int16 (Int.repr 47) :: Init_int16 (Int.repr 51) ::
                Init_int16 (Int.repr 55) :: Init_int16 (Int.repr 59) ::
                Init_int16 (Int.repr 63) :: Init_int16 (Int.repr 67) ::
                Init_int16 (Int.repr 71) :: Init_int16 (Int.repr 75) ::
                Init_int16 (Int.repr 79) :: Init_int16 (Int.repr 83) ::
                Init_int16 (Int.repr 87) :: Init_int16 (Int.repr 91) ::
                Init_int16 (Int.repr 95) :: Init_int16 (Int.repr 99) ::
                Init_int16 (Int.repr 103) :: Init_int16 (Int.repr 107) ::
                Init_int16 (Int.repr 111) :: Init_int16 (Int.repr 115) ::
                Init_int16 (Int.repr 119) :: Init_int16 (Int.repr 123) ::
                Init_int16 (Int.repr 127) :: Init_int16 (Int.repr 131) ::
                Init_int16 (Int.repr 135) :: Init_int16 (Int.repr 139) ::
                Init_int16 (Int.repr 143) :: Init_int16 (Int.repr 147) ::
                Init_int16 (Int.repr 151) :: Init_int16 (Int.repr 155) ::
                Init_int16 (Int.repr 159) :: Init_int16 (Int.repr 163) ::
                Init_int16 (Int.repr 167) :: Init_int16 (Int.repr 171) ::
                Init_int16 (Int.repr 175) :: Init_int16 (Int.repr 179) ::
                Init_int16 (Int.repr 183) :: Init_int16 (Int.repr 187) ::
                Init_int16 (Int.repr 191) :: Init_int16 (Int.repr 195) ::
                Init_int16 (Int.repr 199) :: Init_int16 (Int.repr 203) ::
                Init_int16 (Int.repr 207) :: Init_int16 (Int.repr 211) ::
                Init_int16 (Int.repr 215) :: Init_int16 (Int.repr 219) ::
                Init_int16 (Int.repr 223) :: Init_int16 (Int.repr 227) ::
                Init_int16 (Int.repr 231) :: Init_int16 (Int.repr 235) ::
                Init_int16 (Int.repr 239) :: Init_int16 (Int.repr 243) ::
                Init_int16 (Int.repr 247) :: Init_int16 (Int.repr 251) ::
                Init_int16 (Int.repr 255) :: Init_int16 (Int.repr 259) ::
                Init_int16 (Int.repr 263) :: Init_int16 (Int.repr 267) ::
                Init_int16 (Int.repr 271) :: Init_int16 (Int.repr 275) ::
                Init_int16 (Int.repr 279) :: Init_int16 (Int.repr 283) ::
                Init_int16 (Int.repr 287) :: Init_int16 (Int.repr 291) ::
                Init_int16 (Int.repr 295) :: Init_int16 (Int.repr 299) ::
                Init_int16 (Int.repr 303) :: Init_int16 (Int.repr 307) ::
                Init_int16 (Int.repr 311) :: Init_int16 (Int.repr 315) ::
                Init_int16 (Int.repr 319) :: Init_int16 (Int.repr 323) ::
                Init_int16 (Int.repr 327) :: Init_int16 (Int.repr 331) ::
                Init_int16 (Int.repr 335) :: Init_int16 (Int.repr 339) ::
                Init_int16 (Int.repr 343) :: Init_int16 (Int.repr 347) ::
                Init_int16 (Int.repr 351) :: Init_int16 (Int.repr 355) ::
                Init_int16 (Int.repr 359) :: Init_int16 (Int.repr 363) ::
                Init_int16 (Int.repr 367) :: Init_int16 (Int.repr 371) ::
                Init_int16 (Int.repr 375) :: Init_int16 (Int.repr 379) ::
                Init_int16 (Int.repr 383) :: Init_int16 (Int.repr 387) ::
                Init_int16 (Int.repr 391) :: Init_int16 (Int.repr 395) ::
                Init_int16 (Int.repr 399) :: Init_int16 (Int.repr 403) ::
                Init_int16 (Int.repr 407) :: Init_int16 (Int.repr 411) ::
                Init_int16 (Int.repr 415) :: Init_int16 (Int.repr 419) ::
                Init_int16 (Int.repr 423) :: Init_int16 (Int.repr 427) ::
                Init_int16 (Int.repr 431) :: Init_int16 (Int.repr 435) ::
                Init_int16 (Int.repr 439) :: Init_int16 (Int.repr 443) ::
                Init_int16 (Int.repr 447) :: Init_int16 (Int.repr 451) ::
                Init_int16 (Int.repr 455) :: Init_int16 (Int.repr 459) ::
                Init_int16 (Int.repr 463) :: Init_int16 (Int.repr 467) ::
                Init_int16 (Int.repr 471) :: Init_int16 (Int.repr 475) ::
                Init_int16 (Int.repr 479) :: Init_int16 (Int.repr 483) ::
                Init_int16 (Int.repr 487) :: Init_int16 (Int.repr 491) ::
                Init_int16 (Int.repr 495) :: Init_int16 (Int.repr 499) ::
                Init_int16 (Int.repr 503) :: Init_int16 (Int.repr 507) ::
                Init_int16 (Int.repr 511) :: Init_int16 (Int.repr 515) ::
                Init_int16 (Int.repr 519) :: Init_int16 (Int.repr 523) ::
                Init_int16 (Int.repr 527) :: Init_int16 (Int.repr 531) ::
                Init_int16 (Int.repr 535) :: Init_int16 (Int.repr 539) ::
                Init_int16 (Int.repr 543) :: Init_int16 (Int.repr 547) ::
                Init_int16 (Int.repr 551) :: Init_int16 (Int.repr 555) ::
                Init_int16 (Int.repr 559) :: Init_int16 (Int.repr 563) ::
                Init_int16 (Int.repr 567) :: Init_int16 (Int.repr 571) ::
                Init_int16 (Int.repr 575) :: Init_int16 (Int.repr 579) ::
                Init_int16 (Int.repr 583) :: Init_int16 (Int.repr 587) ::
                Init_int16 (Int.repr 591) :: Init_int16 (Int.repr 595) ::
                Init_int16 (Int.repr 599) :: Init_int16 (Int.repr 603) ::
                Init_int16 (Int.repr 607) :: Init_int16 (Int.repr 611) ::
                Init_int16 (Int.repr 615) :: Init_int16 (Int.repr 619) ::
                Init_int16 (Int.repr 623) :: Init_int16 (Int.repr 627) ::
                Init_int16 (Int.repr 631) :: Init_int16 (Int.repr 635) ::
                Init_int16 (Int.repr 639) :: Init_int16 (Int.repr 643) ::
                Init_int16 (Int.repr 647) :: Init_int16 (Int.repr 651) ::
                Init_int16 (Int.repr 655) :: Init_int16 (Int.repr 659) ::
                Init_int16 (Int.repr 663) :: Init_int16 (Int.repr 667) ::
                Init_int16 (Int.repr 671) :: Init_int16 (Int.repr 675) ::
                Init_int16 (Int.repr 679) :: Init_int16 (Int.repr 683) ::
                Init_int16 (Int.repr 687) :: Init_int16 (Int.repr 691) ::
                Init_int16 (Int.repr 695) :: Init_int16 (Int.repr 699) ::
                Init_int16 (Int.repr 703) :: Init_int16 (Int.repr 707) ::
                Init_int16 (Int.repr 711) :: Init_int16 (Int.repr 715) ::
                Init_int16 (Int.repr 719) :: Init_int16 (Int.repr 723) ::
                Init_int16 (Int.repr 727) :: Init_int16 (Int.repr 731) ::
                Init_int16 (Int.repr 735) :: Init_int16 (Int.repr 739) ::
                Init_int16 (Int.repr 743) :: Init_int16 (Int.repr 747) ::
                Init_int16 (Int.repr 751) :: Init_int16 (Int.repr 755) ::
                Init_int16 (Int.repr 759) :: Init_int16 (Int.repr 763) ::
                Init_int16 (Int.repr 767) :: Init_int16 (Int.repr 771) ::
                Init_int16 (Int.repr 775) :: Init_int16 (Int.repr 779) ::
                Init_int16 (Int.repr 783) :: Init_int16 (Int.repr 787) ::
                Init_int16 (Int.repr 791) :: Init_int16 (Int.repr 795) ::
                Init_int16 (Int.repr 799) :: Init_int16 (Int.repr 803) ::
                Init_int16 (Int.repr 807) :: Init_int16 (Int.repr 811) ::
                Init_int16 (Int.repr 815) :: Init_int16 (Int.repr 819) ::
                Init_int16 (Int.repr 823) :: Init_int16 (Int.repr 827) ::
                Init_int16 (Int.repr 831) :: Init_int16 (Int.repr 835) ::
                Init_int16 (Int.repr 839) :: Init_int16 (Int.repr 843) ::
                Init_int16 (Int.repr 847) :: Init_int16 (Int.repr 851) ::
                Init_int16 (Int.repr 855) :: Init_int16 (Int.repr 859) ::
                Init_int16 (Int.repr 863) :: Init_int16 (Int.repr 867) ::
                Init_int16 (Int.repr 871) :: Init_int16 (Int.repr 875) ::
                Init_int16 (Int.repr 879) :: Init_int16 (Int.repr 883) ::
                Init_int16 (Int.repr 887) :: Init_int16 (Int.repr 891) ::
                Init_int16 (Int.repr 895) :: Init_int16 (Int.repr 899) ::
                Init_int16 (Int.repr 903) :: Init_int16 (Int.repr 907) ::
                Init_int16 (Int.repr 911) :: Init_int16 (Int.repr 915) ::
                Init_int16 (Int.repr 919) :: Init_int16 (Int.repr 923) ::
                Init_int16 (Int.repr 927) :: Init_int16 (Int.repr 931) ::
                Init_int16 (Int.repr 935) :: Init_int16 (Int.repr 939) ::
                Init_int16 (Int.repr 943) :: Init_int16 (Int.repr 947) ::
                Init_int16 (Int.repr 951) :: Init_int16 (Int.repr 955) ::
                Init_int16 (Int.repr 959) :: Init_int16 (Int.repr 963) ::
                Init_int16 (Int.repr 967) :: Init_int16 (Int.repr 971) ::
                Init_int16 (Int.repr 975) :: Init_int16 (Int.repr 979) ::
                Init_int16 (Int.repr 983) :: Init_int16 (Int.repr 987) ::
                Init_int16 (Int.repr 991) :: Init_int16 (Int.repr 995) ::
                Init_int16 (Int.repr 999) :: Init_int16 (Int.repr 1003) ::
                Init_int16 (Int.repr 1007) :: Init_int16 (Int.repr 1011) ::
                Init_int16 (Int.repr 1015) :: Init_int16 (Int.repr 1019) ::
                Init_int16 (Int.repr 1023) :: Init_int16 (Int.repr 1027) ::
                Init_int16 (Int.repr 1031) :: Init_int16 (Int.repr 1035) ::
                Init_int16 (Int.repr 1039) :: Init_int16 (Int.repr 1043) ::
                Init_int16 (Int.repr 1047) :: Init_int16 (Int.repr 1051) ::
                Init_int16 (Int.repr 1055) :: Init_int16 (Int.repr 1059) ::
                Init_int16 (Int.repr 1063) :: Init_int16 (Int.repr 1067) ::
                Init_int16 (Int.repr 1071) :: Init_int16 (Int.repr 1075) ::
                Init_int16 (Int.repr 1079) :: Init_int16 (Int.repr 1083) ::
                Init_int16 (Int.repr 1087) :: Init_int16 (Int.repr 1091) ::
                Init_int16 (Int.repr 1095) :: Init_int16 (Int.repr 1099) ::
                Init_int16 (Int.repr 1103) :: Init_int16 (Int.repr 1107) ::
                Init_int16 (Int.repr 1111) :: Init_int16 (Int.repr 1115) ::
                Init_int16 (Int.repr 1119) :: Init_int16 (Int.repr 1123) ::
                Init_int16 (Int.repr 1127) :: Init_int16 (Int.repr 1131) ::
                Init_int16 (Int.repr 1135) :: Init_int16 (Int.repr 1139) ::
                Init_int16 (Int.repr 1143) :: Init_int16 (Int.repr 1147) ::
                Init_int16 (Int.repr 1151) :: Init_int16 (Int.repr 1155) ::
                Init_int16 (Int.repr 1159) :: Init_int16 (Int.repr 1163) ::
                Init_int16 (Int.repr 1167) :: Init_int16 (Int.repr 1171) ::
                Init_int16 (Int.repr 1174) :: Init_int16 (Int.repr 1178) ::
                Init_int16 (Int.repr 1182) :: Init_int16 (Int.repr 1186) ::
                Init_int16 (Int.repr 1190) :: Init_int16 (Int.repr 1194) ::
                Init_int16 (Int.repr 1198) :: Init_int16 (Int.repr 1202) ::
                Init_int16 (Int.repr 1206) :: Init_int16 (Int.repr 1210) ::
                Init_int16 (Int.repr 1214) :: Init_int16 (Int.repr 1218) ::
                Init_int16 (Int.repr 1222) :: Init_int16 (Int.repr 1226) ::
                Init_int16 (Int.repr 1230) :: Init_int16 (Int.repr 1234) ::
                Init_int16 (Int.repr 1238) :: Init_int16 (Int.repr 1242) ::
                Init_int16 (Int.repr 1246) :: Init_int16 (Int.repr 1250) ::
                Init_int16 (Int.repr 1254) :: Init_int16 (Int.repr 1258) ::
                Init_int16 (Int.repr 1262) :: Init_int16 (Int.repr 1266) ::
                Init_int16 (Int.repr 1270) :: Init_int16 (Int.repr 1274) ::
                Init_int16 (Int.repr 1278) :: Init_int16 (Int.repr 1282) ::
                Init_int16 (Int.repr 1286) :: Init_int16 (Int.repr 1290) ::
                Init_int16 (Int.repr 1294) :: Init_int16 (Int.repr 1298) ::
                Init_int16 (Int.repr 1302) :: Init_int16 (Int.repr 1306) ::
                Init_int16 (Int.repr 1310) :: Init_int16 (Int.repr 1314) ::
                Init_int16 (Int.repr 1318) :: Init_int16 (Int.repr 1322) ::
                Init_int16 (Int.repr 1326) :: Init_int16 (Int.repr 1330) ::
                Init_int16 (Int.repr 1334) :: Init_int16 (Int.repr 1338) ::
                Init_int16 (Int.repr 1342) :: Init_int16 (Int.repr 1346) ::
                Init_int16 (Int.repr 1350) :: Init_int16 (Int.repr 1354) ::
                Init_int16 (Int.repr 1358) :: Init_int16 (Int.repr 1362) ::
                Init_int16 (Int.repr 1366) :: Init_int16 (Int.repr 1370) ::
                Init_int16 (Int.repr 1374) :: Init_int16 (Int.repr 1378) ::
                Init_int16 (Int.repr 1382) :: Init_int16 (Int.repr 1386) ::
                Init_int16 (Int.repr 1390) :: Init_int16 (Int.repr 1394) ::
                Init_int16 (Int.repr 1398) :: Init_int16 (Int.repr 1402) ::
                Init_int16 (Int.repr 1406) :: Init_int16 (Int.repr 1410) ::
                Init_int16 (Int.repr 1414) :: Init_int16 (Int.repr 1418) ::
                Init_int16 (Int.repr 1422) :: Init_int16 (Int.repr 1426) ::
                Init_int16 (Int.repr 1430) :: Init_int16 (Int.repr 1434) ::
                Init_int16 (Int.repr 1438) :: Init_int16 (Int.repr 1442) ::
                Init_int16 (Int.repr 1446) :: Init_int16 (Int.repr 1450) ::
                Init_int16 (Int.repr 1454) :: Init_int16 (Int.repr 1458) ::
                Init_int16 (Int.repr 1462) :: Init_int16 (Int.repr 1466) ::
                Init_int16 (Int.repr 1470) :: Init_int16 (Int.repr 1474) ::
                Init_int16 (Int.repr 1477) :: Init_int16 (Int.repr 1481) ::
                Init_int16 (Int.repr 1485) :: Init_int16 (Int.repr 1489) ::
                Init_int16 (Int.repr 1493) :: Init_int16 (Int.repr 1497) ::
                Init_int16 (Int.repr 1501) :: Init_int16 (Int.repr 1505) ::
                Init_int16 (Int.repr 1509) :: Init_int16 (Int.repr 1513) ::
                Init_int16 (Int.repr 1517) :: Init_int16 (Int.repr 1521) ::
                Init_int16 (Int.repr 1525) :: Init_int16 (Int.repr 1529) ::
                Init_int16 (Int.repr 1533) :: Init_int16 (Int.repr 1537) ::
                Init_int16 (Int.repr 1541) :: Init_int16 (Int.repr 1545) ::
                Init_int16 (Int.repr 1549) :: Init_int16 (Int.repr 1553) ::
                Init_int16 (Int.repr 1557) :: Init_int16 (Int.repr 1561) ::
                Init_int16 (Int.repr 1565) :: Init_int16 (Int.repr 1569) ::
                Init_int16 (Int.repr 1573) :: Init_int16 (Int.repr 1577) ::
                Init_int16 (Int.repr 1581) :: Init_int16 (Int.repr 1585) ::
                Init_int16 (Int.repr 1589) :: Init_int16 (Int.repr 1593) ::
                Init_int16 (Int.repr 1597) :: Init_int16 (Int.repr 1601) ::
                Init_int16 (Int.repr 1605) :: Init_int16 (Int.repr 1609) ::
                Init_int16 (Int.repr 1613) :: Init_int16 (Int.repr 1617) ::
                Init_int16 (Int.repr 1621) :: Init_int16 (Int.repr 1625) ::
                Init_int16 (Int.repr 1629) :: Init_int16 (Int.repr 1633) ::
                Init_int16 (Int.repr 1637) :: Init_int16 (Int.repr 1641) ::
                Init_int16 (Int.repr 1645) :: Init_int16 (Int.repr 1649) ::
                Init_int16 (Int.repr 1653) :: Init_int16 (Int.repr 1657) ::
                Init_int16 (Int.repr 1661) :: Init_int16 (Int.repr 1665) ::
                Init_int16 (Int.repr 1669) :: Init_int16 (Int.repr 1673) ::
                Init_int16 (Int.repr 1677) :: Init_int16 (Int.repr 1681) ::
                Init_int16 (Int.repr 1685) :: Init_int16 (Int.repr 1688) ::
                Init_int16 (Int.repr 1692) :: Init_int16 (Int.repr 1696) ::
                Init_int16 (Int.repr 1700) :: Init_int16 (Int.repr 1704) ::
                Init_int16 (Int.repr 1708) :: Init_int16 (Int.repr 1712) ::
                Init_int16 (Int.repr 1716) :: Init_int16 (Int.repr 1720) ::
                Init_int16 (Int.repr 1724) :: Init_int16 (Int.repr 1728) ::
                Init_int16 (Int.repr 1732) :: Init_int16 (Int.repr 1736) ::
                Init_int16 (Int.repr 1740) :: Init_int16 (Int.repr 1744) ::
                Init_int16 (Int.repr 1748) :: Init_int16 (Int.repr 1752) ::
                Init_int16 (Int.repr 1756) :: Init_int16 (Int.repr 1760) ::
                Init_int16 (Int.repr 1764) :: Init_int16 (Int.repr 1768) ::
                Init_int16 (Int.repr 1772) :: Init_int16 (Int.repr 1776) ::
                Init_int16 (Int.repr 1780) :: Init_int16 (Int.repr 1784) ::
                Init_int16 (Int.repr 1788) :: Init_int16 (Int.repr 1792) ::
                Init_int16 (Int.repr 1796) :: Init_int16 (Int.repr 1800) ::
                Init_int16 (Int.repr 1804) :: Init_int16 (Int.repr 1808) ::
                Init_int16 (Int.repr 1812) :: Init_int16 (Int.repr 1816) ::
                Init_int16 (Int.repr 1820) :: Init_int16 (Int.repr 1824) ::
                Init_int16 (Int.repr 1828) :: Init_int16 (Int.repr 1832) ::
                Init_int16 (Int.repr 1836) :: Init_int16 (Int.repr 1840) ::
                Init_int16 (Int.repr 1844) :: Init_int16 (Int.repr 1848) ::
                Init_int16 (Int.repr 1852) :: Init_int16 (Int.repr 1856) ::
                Init_int16 (Int.repr 1859) :: Init_int16 (Int.repr 1863) ::
                Init_int16 (Int.repr 1867) :: Init_int16 (Int.repr 1871) ::
                Init_int16 (Int.repr 1875) :: Init_int16 (Int.repr 1879) ::
                Init_int16 (Int.repr 1883) :: Init_int16 (Int.repr 1887) ::
                Init_int16 (Int.repr 1891) :: Init_int16 (Int.repr 1895) ::
                Init_int16 (Int.repr 1899) :: Init_int16 (Int.repr 1903) ::
                Init_int16 (Int.repr 1907) :: Init_int16 (Int.repr 1911) ::
                Init_int16 (Int.repr 1915) :: Init_int16 (Int.repr 1919) ::
                Init_int16 (Int.repr 1923) :: Init_int16 (Int.repr 1927) ::
                Init_int16 (Int.repr 1931) :: Init_int16 (Int.repr 1935) ::
                Init_int16 (Int.repr 1939) :: Init_int16 (Int.repr 1943) ::
                Init_int16 (Int.repr 1947) :: Init_int16 (Int.repr 1951) ::
                Init_int16 (Int.repr 1955) :: Init_int16 (Int.repr 1959) ::
                Init_int16 (Int.repr 1963) :: Init_int16 (Int.repr 1967) ::
                Init_int16 (Int.repr 1971) :: Init_int16 (Int.repr 1975) ::
                Init_int16 (Int.repr 1979) :: Init_int16 (Int.repr 1983) ::
                Init_int16 (Int.repr 1987) :: Init_int16 (Int.repr 1991) ::
                Init_int16 (Int.repr 1995) :: Init_int16 (Int.repr 1999) ::
                Init_int16 (Int.repr 2002) :: Init_int16 (Int.repr 2006) ::
                Init_int16 (Int.repr 2010) :: Init_int16 (Int.repr 2014) ::
                Init_int16 (Int.repr 2018) :: Init_int16 (Int.repr 2022) ::
                Init_int16 (Int.repr 2026) :: Init_int16 (Int.repr 2030) ::
                Init_int16 (Int.repr 2034) :: Init_int16 (Int.repr 2038) ::
                Init_int16 (Int.repr 2042) :: Init_int16 (Int.repr 2046) ::
                Init_int16 (Int.repr 2050) :: Init_int16 (Int.repr 2054) ::
                Init_int16 (Int.repr 2058) :: Init_int16 (Int.repr 2062) ::
                Init_int16 (Int.repr 2066) :: Init_int16 (Int.repr 2070) ::
                Init_int16 (Int.repr 2074) :: Init_int16 (Int.repr 2078) ::
                Init_int16 (Int.repr 2082) :: Init_int16 (Int.repr 2086) ::
                Init_int16 (Int.repr 2090) :: Init_int16 (Int.repr 2094) ::
                Init_int16 (Int.repr 2098) :: Init_int16 (Int.repr 2102) ::
                Init_int16 (Int.repr 2106) :: Init_int16 (Int.repr 2110) ::
                Init_int16 (Int.repr 2114) :: Init_int16 (Int.repr 2118) ::
                Init_int16 (Int.repr 2122) :: Init_int16 (Int.repr 2125) ::
                Init_int16 (Int.repr 2129) :: Init_int16 (Int.repr 2133) ::
                Init_int16 (Int.repr 2137) :: Init_int16 (Int.repr 2141) ::
                Init_int16 (Int.repr 2145) :: Init_int16 (Int.repr 2149) ::
                Init_int16 (Int.repr 2153) :: Init_int16 (Int.repr 2157) ::
                Init_int16 (Int.repr 2161) :: Init_int16 (Int.repr 2165) ::
                Init_int16 (Int.repr 2169) :: Init_int16 (Int.repr 2173) ::
                Init_int16 (Int.repr 2177) :: Init_int16 (Int.repr 2181) ::
                Init_int16 (Int.repr 2185) :: Init_int16 (Int.repr 2189) ::
                Init_int16 (Int.repr 2193) :: Init_int16 (Int.repr 2197) ::
                Init_int16 (Int.repr 2201) :: Init_int16 (Int.repr 2205) ::
                Init_int16 (Int.repr 2209) :: Init_int16 (Int.repr 2213) ::
                Init_int16 (Int.repr 2217) :: Init_int16 (Int.repr 2221) ::
                Init_int16 (Int.repr 2225) :: Init_int16 (Int.repr 2229) ::
                Init_int16 (Int.repr 2233) :: Init_int16 (Int.repr 2236) ::
                Init_int16 (Int.repr 2240) :: Init_int16 (Int.repr 2244) ::
                Init_int16 (Int.repr 2248) :: Init_int16 (Int.repr 2252) ::
                Init_int16 (Int.repr 2256) :: Init_int16 (Int.repr 2260) ::
                Init_int16 (Int.repr 2264) :: Init_int16 (Int.repr 2268) ::
                Init_int16 (Int.repr 2272) :: Init_int16 (Int.repr 2276) ::
                Init_int16 (Int.repr 2280) :: Init_int16 (Int.repr 2284) ::
                Init_int16 (Int.repr 2288) :: Init_int16 (Int.repr 2292) ::
                Init_int16 (Int.repr 2296) :: Init_int16 (Int.repr 2300) ::
                Init_int16 (Int.repr 2304) :: Init_int16 (Int.repr 2308) ::
                Init_int16 (Int.repr 2312) :: Init_int16 (Int.repr 2316) ::
                Init_int16 (Int.repr 2320) :: Init_int16 (Int.repr 2324) ::
                Init_int16 (Int.repr 2328) :: Init_int16 (Int.repr 2332) ::
                Init_int16 (Int.repr 2336) :: Init_int16 (Int.repr 2339) ::
                Init_int16 (Int.repr 2343) :: Init_int16 (Int.repr 2347) ::
                Init_int16 (Int.repr 2351) :: Init_int16 (Int.repr 2355) ::
                Init_int16 (Int.repr 2359) :: Init_int16 (Int.repr 2363) ::
                Init_int16 (Int.repr 2367) :: Init_int16 (Int.repr 2371) ::
                Init_int16 (Int.repr 2375) :: Init_int16 (Int.repr 2379) ::
                Init_int16 (Int.repr 2383) :: Init_int16 (Int.repr 2387) ::
                Init_int16 (Int.repr 2391) :: Init_int16 (Int.repr 2395) ::
                Init_int16 (Int.repr 2399) :: Init_int16 (Int.repr 2403) ::
                Init_int16 (Int.repr 2407) :: Init_int16 (Int.repr 2411) ::
                Init_int16 (Int.repr 2415) :: Init_int16 (Int.repr 2419) ::
                Init_int16 (Int.repr 2423) :: Init_int16 (Int.repr 2427) ::
                Init_int16 (Int.repr 2430) :: Init_int16 (Int.repr 2434) ::
                Init_int16 (Int.repr 2438) :: Init_int16 (Int.repr 2442) ::
                Init_int16 (Int.repr 2446) :: Init_int16 (Int.repr 2450) ::
                Init_int16 (Int.repr 2454) :: Init_int16 (Int.repr 2458) ::
                Init_int16 (Int.repr 2462) :: Init_int16 (Int.repr 2466) ::
                Init_int16 (Int.repr 2470) :: Init_int16 (Int.repr 2474) ::
                Init_int16 (Int.repr 2478) :: Init_int16 (Int.repr 2482) ::
                Init_int16 (Int.repr 2486) :: Init_int16 (Int.repr 2490) ::
                Init_int16 (Int.repr 2494) :: Init_int16 (Int.repr 2498) ::
                Init_int16 (Int.repr 2502) :: Init_int16 (Int.repr 2506) ::
                Init_int16 (Int.repr 2510) :: Init_int16 (Int.repr 2514) ::
                Init_int16 (Int.repr 2517) :: Init_int16 (Int.repr 2521) ::
                Init_int16 (Int.repr 2525) :: Init_int16 (Int.repr 2529) ::
                Init_int16 (Int.repr 2533) :: Init_int16 (Int.repr 2537) ::
                Init_int16 (Int.repr 2541) :: Init_int16 (Int.repr 2545) ::
                Init_int16 (Int.repr 2549) :: Init_int16 (Int.repr 2553) ::
                Init_int16 (Int.repr 2557) :: Init_int16 (Int.repr 2561) ::
                Init_int16 (Int.repr 2565) :: Init_int16 (Int.repr 2569) ::
                Init_int16 (Int.repr 2573) :: Init_int16 (Int.repr 2577) ::
                Init_int16 (Int.repr 2581) :: Init_int16 (Int.repr 2585) ::
                Init_int16 (Int.repr 2589) :: Init_int16 (Int.repr 2593) ::
                Init_int16 (Int.repr 2597) :: Init_int16 (Int.repr 2600) ::
                Init_int16 (Int.repr 2604) :: Init_int16 (Int.repr 2608) ::
                Init_int16 (Int.repr 2612) :: Init_int16 (Int.repr 2616) ::
                Init_int16 (Int.repr 2620) :: Init_int16 (Int.repr 2624) ::
                Init_int16 (Int.repr 2628) :: Init_int16 (Int.repr 2632) ::
                Init_int16 (Int.repr 2636) :: Init_int16 (Int.repr 2640) ::
                Init_int16 (Int.repr 2644) :: Init_int16 (Int.repr 2648) ::
                Init_int16 (Int.repr 2652) :: Init_int16 (Int.repr 2656) ::
                Init_int16 (Int.repr 2660) :: Init_int16 (Int.repr 2664) ::
                Init_int16 (Int.repr 2668) :: Init_int16 (Int.repr 2672) ::
                Init_int16 (Int.repr 2675) :: Init_int16 (Int.repr 2679) ::
                Init_int16 (Int.repr 2683) :: Init_int16 (Int.repr 2687) ::
                Init_int16 (Int.repr 2691) :: Init_int16 (Int.repr 2695) ::
                Init_int16 (Int.repr 2699) :: Init_int16 (Int.repr 2703) ::
                Init_int16 (Int.repr 2707) :: Init_int16 (Int.repr 2711) ::
                Init_int16 (Int.repr 2715) :: Init_int16 (Int.repr 2719) ::
                Init_int16 (Int.repr 2723) :: Init_int16 (Int.repr 2727) ::
                Init_int16 (Int.repr 2731) :: Init_int16 (Int.repr 2735) ::
                Init_int16 (Int.repr 2739) :: Init_int16 (Int.repr 2743) ::
                Init_int16 (Int.repr 2746) :: Init_int16 (Int.repr 2750) ::
                Init_int16 (Int.repr 2754) :: Init_int16 (Int.repr 2758) ::
                Init_int16 (Int.repr 2762) :: Init_int16 (Int.repr 2766) ::
                Init_int16 (Int.repr 2770) :: Init_int16 (Int.repr 2774) ::
                Init_int16 (Int.repr 2778) :: Init_int16 (Int.repr 2782) ::
                Init_int16 (Int.repr 2786) :: Init_int16 (Int.repr 2790) ::
                Init_int16 (Int.repr 2794) :: Init_int16 (Int.repr 2798) ::
                Init_int16 (Int.repr 2802) :: Init_int16 (Int.repr 2806) ::
                Init_int16 (Int.repr 2810) :: Init_int16 (Int.repr 2813) ::
                Init_int16 (Int.repr 2817) :: Init_int16 (Int.repr 2821) ::
                Init_int16 (Int.repr 2825) :: Init_int16 (Int.repr 2829) ::
                Init_int16 (Int.repr 2833) :: Init_int16 (Int.repr 2837) ::
                Init_int16 (Int.repr 2841) :: Init_int16 (Int.repr 2845) ::
                Init_int16 (Int.repr 2849) :: Init_int16 (Int.repr 2853) ::
                Init_int16 (Int.repr 2857) :: Init_int16 (Int.repr 2861) ::
                Init_int16 (Int.repr 2865) :: Init_int16 (Int.repr 2869) ::
                Init_int16 (Int.repr 2873) :: Init_int16 (Int.repr 2877) ::
                Init_int16 (Int.repr 2880) :: Init_int16 (Int.repr 2884) ::
                Init_int16 (Int.repr 2888) :: Init_int16 (Int.repr 2892) ::
                Init_int16 (Int.repr 2896) :: Init_int16 (Int.repr 2900) ::
                Init_int16 (Int.repr 2904) :: Init_int16 (Int.repr 2908) ::
                Init_int16 (Int.repr 2912) :: Init_int16 (Int.repr 2916) ::
                Init_int16 (Int.repr 2920) :: Init_int16 (Int.repr 2924) ::
                Init_int16 (Int.repr 2928) :: Init_int16 (Int.repr 2932) ::
                Init_int16 (Int.repr 2936) :: Init_int16 (Int.repr 2939) ::
                Init_int16 (Int.repr 2943) :: Init_int16 (Int.repr 2947) ::
                Init_int16 (Int.repr 2951) :: Init_int16 (Int.repr 2955) ::
                Init_int16 (Int.repr 2959) :: Init_int16 (Int.repr 2963) ::
                Init_int16 (Int.repr 2967) :: Init_int16 (Int.repr 2971) ::
                Init_int16 (Int.repr 2975) :: Init_int16 (Int.repr 2979) ::
                Init_int16 (Int.repr 2983) :: Init_int16 (Int.repr 2987) ::
                Init_int16 (Int.repr 2991) :: Init_int16 (Int.repr 2995) ::
                Init_int16 (Int.repr 2998) :: Init_int16 (Int.repr 3002) ::
                Init_int16 (Int.repr 3006) :: Init_int16 (Int.repr 3010) ::
                Init_int16 (Int.repr 3014) :: Init_int16 (Int.repr 3018) ::
                Init_int16 (Int.repr 3022) :: Init_int16 (Int.repr 3026) ::
                Init_int16 (Int.repr 3030) :: Init_int16 (Int.repr 3034) ::
                Init_int16 (Int.repr 3038) :: Init_int16 (Int.repr 3042) ::
                Init_int16 (Int.repr 3046) :: Init_int16 (Int.repr 3050) ::
                Init_int16 (Int.repr 3054) :: Init_int16 (Int.repr 3057) ::
                Init_int16 (Int.repr 3061) :: Init_int16 (Int.repr 3065) ::
                Init_int16 (Int.repr 3069) :: Init_int16 (Int.repr 3073) ::
                Init_int16 (Int.repr 3077) :: Init_int16 (Int.repr 3081) ::
                Init_int16 (Int.repr 3085) :: Init_int16 (Int.repr 3089) ::
                Init_int16 (Int.repr 3093) :: Init_int16 (Int.repr 3097) ::
                Init_int16 (Int.repr 3101) :: Init_int16 (Int.repr 3105) ::
                Init_int16 (Int.repr 3109) :: Init_int16 (Int.repr 3112) ::
                Init_int16 (Int.repr 3116) :: Init_int16 (Int.repr 3120) ::
                Init_int16 (Int.repr 3124) :: Init_int16 (Int.repr 3128) ::
                Init_int16 (Int.repr 3132) :: Init_int16 (Int.repr 3136) ::
                Init_int16 (Int.repr 3140) :: Init_int16 (Int.repr 3144) ::
                Init_int16 (Int.repr 3148) :: Init_int16 (Int.repr 3152) ::
                Init_int16 (Int.repr 3156) :: Init_int16 (Int.repr 3160) ::
                Init_int16 (Int.repr 3163) :: Init_int16 (Int.repr 3167) ::
                Init_int16 (Int.repr 3171) :: Init_int16 (Int.repr 3175) ::
                Init_int16 (Int.repr 3179) :: Init_int16 (Int.repr 3183) ::
                Init_int16 (Int.repr 3187) :: Init_int16 (Int.repr 3191) ::
                Init_int16 (Int.repr 3195) :: Init_int16 (Int.repr 3199) ::
                Init_int16 (Int.repr 3203) :: Init_int16 (Int.repr 3207) ::
                Init_int16 (Int.repr 3211) :: Init_int16 (Int.repr 3215) ::
                Init_int16 (Int.repr 3218) :: Init_int16 (Int.repr 3222) ::
                Init_int16 (Int.repr 3226) :: Init_int16 (Int.repr 3230) ::
                Init_int16 (Int.repr 3234) :: Init_int16 (Int.repr 3238) ::
                Init_int16 (Int.repr 3242) :: Init_int16 (Int.repr 3246) ::
                Init_int16 (Int.repr 3250) :: Init_int16 (Int.repr 3254) ::
                Init_int16 (Int.repr 3258) :: Init_int16 (Int.repr 3262) ::
                Init_int16 (Int.repr 3265) :: Init_int16 (Int.repr 3269) ::
                Init_int16 (Int.repr 3273) :: Init_int16 (Int.repr 3277) ::
                Init_int16 (Int.repr 3281) :: Init_int16 (Int.repr 3285) ::
                Init_int16 (Int.repr 3289) :: Init_int16 (Int.repr 3293) ::
                Init_int16 (Int.repr 3297) :: Init_int16 (Int.repr 3301) ::
                Init_int16 (Int.repr 3305) :: Init_int16 (Int.repr 3309) ::
                Init_int16 (Int.repr 3312) :: Init_int16 (Int.repr 3316) ::
                Init_int16 (Int.repr 3320) :: Init_int16 (Int.repr 3324) ::
                Init_int16 (Int.repr 3328) :: Init_int16 (Int.repr 3332) ::
                Init_int16 (Int.repr 3336) :: Init_int16 (Int.repr 3340) ::
                Init_int16 (Int.repr 3344) :: Init_int16 (Int.repr 3348) ::
                Init_int16 (Int.repr 3352) :: Init_int16 (Int.repr 3356) ::
                Init_int16 (Int.repr 3359) :: Init_int16 (Int.repr 3363) ::
                Init_int16 (Int.repr 3367) :: Init_int16 (Int.repr 3371) ::
                Init_int16 (Int.repr 3375) :: Init_int16 (Int.repr 3379) ::
                Init_int16 (Int.repr 3383) :: Init_int16 (Int.repr 3387) ::
                Init_int16 (Int.repr 3391) :: Init_int16 (Int.repr 3395) ::
                Init_int16 (Int.repr 3399) :: Init_int16 (Int.repr 3403) ::
                Init_int16 (Int.repr 3406) :: Init_int16 (Int.repr 3410) ::
                Init_int16 (Int.repr 3414) :: Init_int16 (Int.repr 3418) ::
                Init_int16 (Int.repr 3422) :: Init_int16 (Int.repr 3426) ::
                Init_int16 (Int.repr 3430) :: Init_int16 (Int.repr 3434) ::
                Init_int16 (Int.repr 3438) :: Init_int16 (Int.repr 3442) ::
                Init_int16 (Int.repr 3446) :: Init_int16 (Int.repr 3449) ::
                Init_int16 (Int.repr 3453) :: Init_int16 (Int.repr 3457) ::
                Init_int16 (Int.repr 3461) :: Init_int16 (Int.repr 3465) ::
                Init_int16 (Int.repr 3469) :: Init_int16 (Int.repr 3473) ::
                Init_int16 (Int.repr 3477) :: Init_int16 (Int.repr 3481) ::
                Init_int16 (Int.repr 3485) :: Init_int16 (Int.repr 3489) ::
                Init_int16 (Int.repr 3492) :: Init_int16 (Int.repr 3496) ::
                Init_int16 (Int.repr 3500) :: Init_int16 (Int.repr 3504) ::
                Init_int16 (Int.repr 3508) :: Init_int16 (Int.repr 3512) ::
                Init_int16 (Int.repr 3516) :: Init_int16 (Int.repr 3520) ::
                Init_int16 (Int.repr 3524) :: Init_int16 (Int.repr 3528) ::
                Init_int16 (Int.repr 3532) :: Init_int16 (Int.repr 3535) ::
                Init_int16 (Int.repr 3539) :: Init_int16 (Int.repr 3543) ::
                Init_int16 (Int.repr 3547) :: Init_int16 (Int.repr 3551) ::
                Init_int16 (Int.repr 3555) :: Init_int16 (Int.repr 3559) ::
                Init_int16 (Int.repr 3563) :: Init_int16 (Int.repr 3567) ::
                Init_int16 (Int.repr 3571) :: Init_int16 (Int.repr 3575) ::
                Init_int16 (Int.repr 3578) :: Init_int16 (Int.repr 3582) ::
                Init_int16 (Int.repr 3586) :: Init_int16 (Int.repr 3590) ::
                Init_int16 (Int.repr 3594) :: Init_int16 (Int.repr 3598) ::
                Init_int16 (Int.repr 3602) :: Init_int16 (Int.repr 3606) ::
                Init_int16 (Int.repr 3610) :: Init_int16 (Int.repr 3614) ::
                Init_int16 (Int.repr 3617) :: Init_int16 (Int.repr 3621) ::
                Init_int16 (Int.repr 3625) :: Init_int16 (Int.repr 3629) ::
                Init_int16 (Int.repr 3633) :: Init_int16 (Int.repr 3637) ::
                Init_int16 (Int.repr 3641) :: Init_int16 (Int.repr 3645) ::
                Init_int16 (Int.repr 3649) :: Init_int16 (Int.repr 3653) ::
                Init_int16 (Int.repr 3656) :: Init_int16 (Int.repr 3660) ::
                Init_int16 (Int.repr 3664) :: Init_int16 (Int.repr 3668) ::
                Init_int16 (Int.repr 3672) :: Init_int16 (Int.repr 3676) ::
                Init_int16 (Int.repr 3680) :: Init_int16 (Int.repr 3684) ::
                Init_int16 (Int.repr 3688) :: Init_int16 (Int.repr 3692) ::
                Init_int16 (Int.repr 3695) :: Init_int16 (Int.repr 3699) ::
                Init_int16 (Int.repr 3703) :: Init_int16 (Int.repr 3707) ::
                Init_int16 (Int.repr 3711) :: Init_int16 (Int.repr 3715) ::
                Init_int16 (Int.repr 3719) :: Init_int16 (Int.repr 3723) ::
                Init_int16 (Int.repr 3727) :: Init_int16 (Int.repr 3730) ::
                Init_int16 (Int.repr 3734) :: Init_int16 (Int.repr 3738) ::
                Init_int16 (Int.repr 3742) :: Init_int16 (Int.repr 3746) ::
                Init_int16 (Int.repr 3750) :: Init_int16 (Int.repr 3754) ::
                Init_int16 (Int.repr 3758) :: Init_int16 (Int.repr 3762) ::
                Init_int16 (Int.repr 3766) :: Init_int16 (Int.repr 3769) ::
                Init_int16 (Int.repr 3773) :: Init_int16 (Int.repr 3777) ::
                Init_int16 (Int.repr 3781) :: Init_int16 (Int.repr 3785) ::
                Init_int16 (Int.repr 3789) :: Init_int16 (Int.repr 3793) ::
                Init_int16 (Int.repr 3797) :: Init_int16 (Int.repr 3801) ::
                Init_int16 (Int.repr 3804) :: Init_int16 (Int.repr 3808) ::
                Init_int16 (Int.repr 3812) :: Init_int16 (Int.repr 3816) ::
                Init_int16 (Int.repr 3820) :: Init_int16 (Int.repr 3824) ::
                Init_int16 (Int.repr 3828) :: Init_int16 (Int.repr 3832) ::
                Init_int16 (Int.repr 3836) :: Init_int16 (Int.repr 3839) ::
                Init_int16 (Int.repr 3843) :: Init_int16 (Int.repr 3847) ::
                Init_int16 (Int.repr 3851) :: Init_int16 (Int.repr 3855) ::
                Init_int16 (Int.repr 3859) :: Init_int16 (Int.repr 3863) ::
                Init_int16 (Int.repr 3867) :: Init_int16 (Int.repr 3871) ::
                Init_int16 (Int.repr 3874) :: Init_int16 (Int.repr 3878) ::
                Init_int16 (Int.repr 3882) :: Init_int16 (Int.repr 3886) ::
                Init_int16 (Int.repr 3890) :: Init_int16 (Int.repr 3894) ::
                Init_int16 (Int.repr 3898) :: Init_int16 (Int.repr 3902) ::
                Init_int16 (Int.repr 3906) :: Init_int16 (Int.repr 3909) ::
                Init_int16 (Int.repr 3913) :: Init_int16 (Int.repr 3917) ::
                Init_int16 (Int.repr 3921) :: Init_int16 (Int.repr 3925) ::
                Init_int16 (Int.repr 3929) :: Init_int16 (Int.repr 3933) ::
                Init_int16 (Int.repr 3937) :: Init_int16 (Int.repr 3940) ::
                Init_int16 (Int.repr 3944) :: Init_int16 (Int.repr 3948) ::
                Init_int16 (Int.repr 3952) :: Init_int16 (Int.repr 3956) ::
                Init_int16 (Int.repr 3960) :: Init_int16 (Int.repr 3964) ::
                Init_int16 (Int.repr 3968) :: Init_int16 (Int.repr 3972) ::
                Init_int16 (Int.repr 3975) :: Init_int16 (Int.repr 3979) ::
                Init_int16 (Int.repr 3983) :: Init_int16 (Int.repr 3987) ::
                Init_int16 (Int.repr 3991) :: Init_int16 (Int.repr 3995) ::
                Init_int16 (Int.repr 3999) :: Init_int16 (Int.repr 4003) ::
                Init_int16 (Int.repr 4006) :: Init_int16 (Int.repr 4010) ::
                Init_int16 (Int.repr 4014) :: Init_int16 (Int.repr 4018) ::
                Init_int16 (Int.repr 4022) :: Init_int16 (Int.repr 4026) ::
                Init_int16 (Int.repr 4030) :: Init_int16 (Int.repr 4034) ::
                Init_int16 (Int.repr 4037) :: Init_int16 (Int.repr 4041) ::
                Init_int16 (Int.repr 4045) :: Init_int16 (Int.repr 4049) ::
                Init_int16 (Int.repr 4053) :: Init_int16 (Int.repr 4057) ::
                Init_int16 (Int.repr 4061) :: Init_int16 (Int.repr 4065) ::
                Init_int16 (Int.repr 4068) :: Init_int16 (Int.repr 4072) ::
                Init_int16 (Int.repr 4076) :: Init_int16 (Int.repr 4080) ::
                Init_int16 (Int.repr 4084) :: Init_int16 (Int.repr 4088) ::
                Init_int16 (Int.repr 4092) :: Init_int16 (Int.repr 4096) ::
                Init_int16 (Int.repr 4099) :: Init_int16 (Int.repr 4103) ::
                Init_int16 (Int.repr 4107) :: Init_int16 (Int.repr 4111) ::
                Init_int16 (Int.repr 4115) :: Init_int16 (Int.repr 4119) ::
                Init_int16 (Int.repr 4123) :: Init_int16 (Int.repr 4127) ::
                Init_int16 (Int.repr 4130) :: Init_int16 (Int.repr 4134) ::
                Init_int16 (Int.repr 4138) :: Init_int16 (Int.repr 4142) ::
                Init_int16 (Int.repr 4146) :: Init_int16 (Int.repr 4150) ::
                Init_int16 (Int.repr 4154) :: Init_int16 (Int.repr 4158) ::
                Init_int16 (Int.repr 4161) :: Init_int16 (Int.repr 4165) ::
                Init_int16 (Int.repr 4169) :: Init_int16 (Int.repr 4173) ::
                Init_int16 (Int.repr 4177) :: Init_int16 (Int.repr 4181) ::
                Init_int16 (Int.repr 4185) :: Init_int16 (Int.repr 4188) ::
                Init_int16 (Int.repr 4192) :: Init_int16 (Int.repr 4196) ::
                Init_int16 (Int.repr 4200) :: Init_int16 (Int.repr 4204) ::
                Init_int16 (Int.repr 4208) :: Init_int16 (Int.repr 4212) ::
                Init_int16 (Int.repr 4216) :: Init_int16 (Int.repr 4219) ::
                Init_int16 (Int.repr 4223) :: Init_int16 (Int.repr 4227) ::
                Init_int16 (Int.repr 4231) :: Init_int16 (Int.repr 4235) ::
                Init_int16 (Int.repr 4239) :: Init_int16 (Int.repr 4243) ::
                Init_int16 (Int.repr 4246) :: Init_int16 (Int.repr 4250) ::
                Init_int16 (Int.repr 4254) :: Init_int16 (Int.repr 4258) ::
                Init_int16 (Int.repr 4262) :: Init_int16 (Int.repr 4266) ::
                Init_int16 (Int.repr 4270) :: Init_int16 (Int.repr 4273) ::
                Init_int16 (Int.repr 4277) :: Init_int16 (Int.repr 4281) ::
                Init_int16 (Int.repr 4285) :: Init_int16 (Int.repr 4289) ::
                Init_int16 (Int.repr 4293) :: Init_int16 (Int.repr 4297) ::
                Init_int16 (Int.repr 4301) :: Init_int16 (Int.repr 4304) ::
                Init_int16 (Int.repr 4308) :: Init_int16 (Int.repr 4312) ::
                Init_int16 (Int.repr 4316) :: Init_int16 (Int.repr 4320) ::
                Init_int16 (Int.repr 4324) :: Init_int16 (Int.repr 4328) ::
                Init_int16 (Int.repr 4331) :: Init_int16 (Int.repr 4335) ::
                Init_int16 (Int.repr 4339) :: Init_int16 (Int.repr 4343) ::
                Init_int16 (Int.repr 4347) :: Init_int16 (Int.repr 4351) ::
                Init_int16 (Int.repr 4355) :: Init_int16 (Int.repr 4358) ::
                Init_int16 (Int.repr 4362) :: Init_int16 (Int.repr 4366) ::
                Init_int16 (Int.repr 4370) :: Init_int16 (Int.repr 4374) ::
                Init_int16 (Int.repr 4378) :: Init_int16 (Int.repr 4382) ::
                Init_int16 (Int.repr 4385) :: Init_int16 (Int.repr 4389) ::
                Init_int16 (Int.repr 4393) :: Init_int16 (Int.repr 4397) ::
                Init_int16 (Int.repr 4401) :: Init_int16 (Int.repr 4405) ::
                Init_int16 (Int.repr 4408) :: Init_int16 (Int.repr 4412) ::
                Init_int16 (Int.repr 4416) :: Init_int16 (Int.repr 4420) ::
                Init_int16 (Int.repr 4424) :: Init_int16 (Int.repr 4428) ::
                Init_int16 (Int.repr 4432) :: Init_int16 (Int.repr 4435) ::
                Init_int16 (Int.repr 4439) :: Init_int16 (Int.repr 4443) ::
                Init_int16 (Int.repr 4447) :: Init_int16 (Int.repr 4451) ::
                Init_int16 (Int.repr 4455) :: Init_int16 (Int.repr 4459) ::
                Init_int16 (Int.repr 4462) :: Init_int16 (Int.repr 4466) ::
                Init_int16 (Int.repr 4470) :: Init_int16 (Int.repr 4474) ::
                Init_int16 (Int.repr 4478) :: Init_int16 (Int.repr 4482) ::
                Init_int16 (Int.repr 4485) :: Init_int16 (Int.repr 4489) ::
                Init_int16 (Int.repr 4493) :: Init_int16 (Int.repr 4497) ::
                Init_int16 (Int.repr 4501) :: Init_int16 (Int.repr 4505) ::
                Init_int16 (Int.repr 4509) :: Init_int16 (Int.repr 4512) ::
                Init_int16 (Int.repr 4516) :: Init_int16 (Int.repr 4520) ::
                Init_int16 (Int.repr 4524) :: Init_int16 (Int.repr 4528) ::
                Init_int16 (Int.repr 4532) :: Init_int16 (Int.repr 4535) ::
                Init_int16 (Int.repr 4539) :: Init_int16 (Int.repr 4543) ::
                Init_int16 (Int.repr 4547) :: Init_int16 (Int.repr 4551) ::
                Init_int16 (Int.repr 4555) :: Init_int16 (Int.repr 4559) ::
                Init_int16 (Int.repr 4562) :: Init_int16 (Int.repr 4566) ::
                Init_int16 (Int.repr 4570) :: Init_int16 (Int.repr 4574) ::
                Init_int16 (Int.repr 4578) :: Init_int16 (Int.repr 4582) ::
                Init_int16 (Int.repr 4585) :: Init_int16 (Int.repr 4589) ::
                Init_int16 (Int.repr 4593) :: Init_int16 (Int.repr 4597) ::
                Init_int16 (Int.repr 4601) :: Init_int16 (Int.repr 4605) ::
                Init_int16 (Int.repr 4608) :: Init_int16 (Int.repr 4612) ::
                Init_int16 (Int.repr 4616) :: Init_int16 (Int.repr 4620) ::
                Init_int16 (Int.repr 4624) :: Init_int16 (Int.repr 4628) ::
                Init_int16 (Int.repr 4631) :: Init_int16 (Int.repr 4635) ::
                Init_int16 (Int.repr 4639) :: Init_int16 (Int.repr 4643) ::
                Init_int16 (Int.repr 4647) :: Init_int16 (Int.repr 4651) ::
                Init_int16 (Int.repr 4654) :: Init_int16 (Int.repr 4658) ::
                Init_int16 (Int.repr 4662) :: Init_int16 (Int.repr 4666) ::
                Init_int16 (Int.repr 4670) :: Init_int16 (Int.repr 4674) ::
                Init_int16 (Int.repr 4677) :: Init_int16 (Int.repr 4681) ::
                Init_int16 (Int.repr 4685) :: Init_int16 (Int.repr 4689) ::
                Init_int16 (Int.repr 4693) :: Init_int16 (Int.repr 4697) ::
                Init_int16 (Int.repr 4700) :: Init_int16 (Int.repr 4704) ::
                Init_int16 (Int.repr 4708) :: Init_int16 (Int.repr 4712) ::
                Init_int16 (Int.repr 4716) :: Init_int16 (Int.repr 4720) ::
                Init_int16 (Int.repr 4723) :: Init_int16 (Int.repr 4727) ::
                Init_int16 (Int.repr 4731) :: Init_int16 (Int.repr 4735) ::
                Init_int16 (Int.repr 4739) :: Init_int16 (Int.repr 4743) ::
                Init_int16 (Int.repr 4746) :: Init_int16 (Int.repr 4750) ::
                Init_int16 (Int.repr 4754) :: Init_int16 (Int.repr 4758) ::
                Init_int16 (Int.repr 4762) :: Init_int16 (Int.repr 4766) ::
                Init_int16 (Int.repr 4769) :: Init_int16 (Int.repr 4773) ::
                Init_int16 (Int.repr 4777) :: Init_int16 (Int.repr 4781) ::
                Init_int16 (Int.repr 4785) :: Init_int16 (Int.repr 4789) ::
                Init_int16 (Int.repr 4792) :: Init_int16 (Int.repr 4796) ::
                Init_int16 (Int.repr 4800) :: Init_int16 (Int.repr 4804) ::
                Init_int16 (Int.repr 4808) :: Init_int16 (Int.repr 4811) ::
                Init_int16 (Int.repr 4815) :: Init_int16 (Int.repr 4819) ::
                Init_int16 (Int.repr 4823) :: Init_int16 (Int.repr 4827) ::
                Init_int16 (Int.repr 4831) :: Init_int16 (Int.repr 4834) ::
                Init_int16 (Int.repr 4838) :: Init_int16 (Int.repr 4842) ::
                Init_int16 (Int.repr 4846) :: Init_int16 (Int.repr 4850) ::
                Init_int16 (Int.repr 4854) :: Init_int16 (Int.repr 4857) ::
                Init_int16 (Int.repr 4861) :: Init_int16 (Int.repr 4865) ::
                Init_int16 (Int.repr 4869) :: Init_int16 (Int.repr 4873) ::
                Init_int16 (Int.repr 4876) :: Init_int16 (Int.repr 4880) ::
                Init_int16 (Int.repr 4884) :: Init_int16 (Int.repr 4888) ::
                Init_int16 (Int.repr 4892) :: Init_int16 (Int.repr 4896) ::
                Init_int16 (Int.repr 4899) :: Init_int16 (Int.repr 4903) ::
                Init_int16 (Int.repr 4907) :: Init_int16 (Int.repr 4911) ::
                Init_int16 (Int.repr 4915) :: Init_int16 (Int.repr 4918) ::
                Init_int16 (Int.repr 4922) :: Init_int16 (Int.repr 4926) ::
                Init_int16 (Int.repr 4930) :: Init_int16 (Int.repr 4934) ::
                Init_int16 (Int.repr 4938) :: Init_int16 (Int.repr 4941) ::
                Init_int16 (Int.repr 4945) :: Init_int16 (Int.repr 4949) ::
                Init_int16 (Int.repr 4953) :: Init_int16 (Int.repr 4957) ::
                Init_int16 (Int.repr 4960) :: Init_int16 (Int.repr 4964) ::
                Init_int16 (Int.repr 4968) :: Init_int16 (Int.repr 4972) ::
                Init_int16 (Int.repr 4976) :: Init_int16 (Int.repr 4979) ::
                Init_int16 (Int.repr 4983) :: Init_int16 (Int.repr 4987) ::
                Init_int16 (Int.repr 4991) :: Init_int16 (Int.repr 4995) ::
                Init_int16 (Int.repr 4998) :: Init_int16 (Int.repr 5002) ::
                Init_int16 (Int.repr 5006) :: Init_int16 (Int.repr 5010) ::
                Init_int16 (Int.repr 5014) :: Init_int16 (Int.repr 5018) ::
                Init_int16 (Int.repr 5021) :: Init_int16 (Int.repr 5025) ::
                Init_int16 (Int.repr 5029) :: Init_int16 (Int.repr 5033) ::
                Init_int16 (Int.repr 5037) :: Init_int16 (Int.repr 5040) ::
                Init_int16 (Int.repr 5044) :: Init_int16 (Int.repr 5048) ::
                Init_int16 (Int.repr 5052) :: Init_int16 (Int.repr 5056) ::
                Init_int16 (Int.repr 5059) :: Init_int16 (Int.repr 5063) ::
                Init_int16 (Int.repr 5067) :: Init_int16 (Int.repr 5071) ::
                Init_int16 (Int.repr 5075) :: Init_int16 (Int.repr 5078) ::
                Init_int16 (Int.repr 5082) :: Init_int16 (Int.repr 5086) ::
                Init_int16 (Int.repr 5090) :: Init_int16 (Int.repr 5094) ::
                Init_int16 (Int.repr 5097) :: Init_int16 (Int.repr 5101) ::
                Init_int16 (Int.repr 5105) :: Init_int16 (Int.repr 5109) ::
                Init_int16 (Int.repr 5113) :: Init_int16 (Int.repr 5116) ::
                Init_int16 (Int.repr 5120) :: Init_int16 (Int.repr 5124) ::
                Init_int16 (Int.repr 5128) :: Init_int16 (Int.repr 5132) ::
                Init_int16 (Int.repr 5135) :: Init_int16 (Int.repr 5139) ::
                Init_int16 (Int.repr 5143) :: Init_int16 (Int.repr 5147) ::
                Init_int16 (Int.repr 5151) :: Init_int16 (Int.repr 5154) ::
                Init_int16 (Int.repr 5158) :: Init_int16 (Int.repr 5162) ::
                Init_int16 (Int.repr 5166) :: Init_int16 (Int.repr 5170) ::
                Init_int16 (Int.repr 5173) :: Init_int16 (Int.repr 5177) ::
                Init_int16 (Int.repr 5181) :: Init_int16 (Int.repr 5185) ::
                Init_int16 (Int.repr 5189) :: Init_int16 (Int.repr 5192) ::
                Init_int16 (Int.repr 5196) :: Init_int16 (Int.repr 5200) ::
                Init_int16 (Int.repr 5204) :: Init_int16 (Int.repr 5208) ::
                Init_int16 (Int.repr 5211) :: Init_int16 (Int.repr 5215) ::
                Init_int16 (Int.repr 5219) :: Init_int16 (Int.repr 5223) ::
                Init_int16 (Int.repr 5227) :: Init_int16 (Int.repr 5230) ::
                Init_int16 (Int.repr 5234) :: Init_int16 (Int.repr 5238) ::
                Init_int16 (Int.repr 5242) :: Init_int16 (Int.repr 5245) ::
                Init_int16 (Int.repr 5249) :: Init_int16 (Int.repr 5253) ::
                Init_int16 (Int.repr 5257) :: Init_int16 (Int.repr 5261) ::
                Init_int16 (Int.repr 5264) :: Init_int16 (Int.repr 5268) ::
                Init_int16 (Int.repr 5272) :: Init_int16 (Int.repr 5276) ::
                Init_int16 (Int.repr 5280) :: Init_int16 (Int.repr 5283) ::
                Init_int16 (Int.repr 5287) :: Init_int16 (Int.repr 5291) ::
                Init_int16 (Int.repr 5295) :: Init_int16 (Int.repr 5298) ::
                Init_int16 (Int.repr 5302) :: Init_int16 (Int.repr 5306) ::
                Init_int16 (Int.repr 5310) :: Init_int16 (Int.repr 5314) ::
                Init_int16 (Int.repr 5317) :: Init_int16 (Int.repr 5321) ::
                Init_int16 (Int.repr 5325) :: Init_int16 (Int.repr 5329) ::
                Init_int16 (Int.repr 5333) :: Init_int16 (Int.repr 5336) ::
                Init_int16 (Int.repr 5340) :: Init_int16 (Int.repr 5344) ::
                Init_int16 (Int.repr 5348) :: Init_int16 (Int.repr 5351) ::
                Init_int16 (Int.repr 5355) :: Init_int16 (Int.repr 5359) ::
                Init_int16 (Int.repr 5363) :: Init_int16 (Int.repr 5367) ::
                Init_int16 (Int.repr 5370) :: Init_int16 (Int.repr 5374) ::
                Init_int16 (Int.repr 5378) :: Init_int16 (Int.repr 5382) ::
                Init_int16 (Int.repr 5385) :: Init_int16 (Int.repr 5389) ::
                Init_int16 (Int.repr 5393) :: Init_int16 (Int.repr 5397) ::
                Init_int16 (Int.repr 5401) :: Init_int16 (Int.repr 5404) ::
                Init_int16 (Int.repr 5408) :: Init_int16 (Int.repr 5412) ::
                Init_int16 (Int.repr 5416) :: Init_int16 (Int.repr 5419) ::
                Init_int16 (Int.repr 5423) :: Init_int16 (Int.repr 5427) ::
                Init_int16 (Int.repr 5431) :: Init_int16 (Int.repr 5435) ::
                Init_int16 (Int.repr 5438) :: Init_int16 (Int.repr 5442) ::
                Init_int16 (Int.repr 5446) :: Init_int16 (Int.repr 5450) ::
                Init_int16 (Int.repr 5453) :: Init_int16 (Int.repr 5457) ::
                Init_int16 (Int.repr 5461) :: Init_int16 (Int.repr 5465) ::
                Init_int16 (Int.repr 5468) :: Init_int16 (Int.repr 5472) ::
                Init_int16 (Int.repr 5476) :: Init_int16 (Int.repr 5480) ::
                Init_int16 (Int.repr 5484) :: Init_int16 (Int.repr 5487) ::
                Init_int16 (Int.repr 5491) :: Init_int16 (Int.repr 5495) ::
                Init_int16 (Int.repr 5499) :: Init_int16 (Int.repr 5502) ::
                Init_int16 (Int.repr 5506) :: Init_int16 (Int.repr 5510) ::
                Init_int16 (Int.repr 5514) :: Init_int16 (Int.repr 5517) ::
                Init_int16 (Int.repr 5521) :: Init_int16 (Int.repr 5525) ::
                Init_int16 (Int.repr 5529) :: Init_int16 (Int.repr 5533) ::
                Init_int16 (Int.repr 5536) :: Init_int16 (Int.repr 5540) ::
                Init_int16 (Int.repr 5544) :: Init_int16 (Int.repr 5548) ::
                Init_int16 (Int.repr 5551) :: Init_int16 (Int.repr 5555) ::
                Init_int16 (Int.repr 5559) :: Init_int16 (Int.repr 5563) ::
                Init_int16 (Int.repr 5566) :: Init_int16 (Int.repr 5570) ::
                Init_int16 (Int.repr 5574) :: Init_int16 (Int.repr 5578) ::
                Init_int16 (Int.repr 5581) :: Init_int16 (Int.repr 5585) ::
                Init_int16 (Int.repr 5589) :: Init_int16 (Int.repr 5593) ::
                Init_int16 (Int.repr 5596) :: Init_int16 (Int.repr 5600) ::
                Init_int16 (Int.repr 5604) :: Init_int16 (Int.repr 5608) ::
                Init_int16 (Int.repr 5612) :: Init_int16 (Int.repr 5615) ::
                Init_int16 (Int.repr 5619) :: Init_int16 (Int.repr 5623) ::
                Init_int16 (Int.repr 5627) :: Init_int16 (Int.repr 5630) ::
                Init_int16 (Int.repr 5634) :: Init_int16 (Int.repr 5638) ::
                Init_int16 (Int.repr 5642) :: Init_int16 (Int.repr 5645) ::
                Init_int16 (Int.repr 5649) :: Init_int16 (Int.repr 5653) ::
                Init_int16 (Int.repr 5657) :: Init_int16 (Int.repr 5660) ::
                Init_int16 (Int.repr 5664) :: Init_int16 (Int.repr 5668) ::
                Init_int16 (Int.repr 5672) :: Init_int16 (Int.repr 5675) ::
                Init_int16 (Int.repr 5679) :: Init_int16 (Int.repr 5683) ::
                Init_int16 (Int.repr 5687) :: Init_int16 (Int.repr 5690) ::
                Init_int16 (Int.repr 5694) :: Init_int16 (Int.repr 5698) ::
                Init_int16 (Int.repr 5702) :: Init_int16 (Int.repr 5705) ::
                Init_int16 (Int.repr 5709) :: Init_int16 (Int.repr 5713) ::
                Init_int16 (Int.repr 5717) :: Init_int16 (Int.repr 5720) ::
                Init_int16 (Int.repr 5724) :: Init_int16 (Int.repr 5728) ::
                Init_int16 (Int.repr 5732) :: Init_int16 (Int.repr 5735) ::
                Init_int16 (Int.repr 5739) :: Init_int16 (Int.repr 5743) ::
                Init_int16 (Int.repr 5747) :: Init_int16 (Int.repr 5750) ::
                Init_int16 (Int.repr 5754) :: Init_int16 (Int.repr 5758) ::
                Init_int16 (Int.repr 5762) :: Init_int16 (Int.repr 5765) ::
                Init_int16 (Int.repr 5769) :: Init_int16 (Int.repr 5773) ::
                Init_int16 (Int.repr 5777) :: Init_int16 (Int.repr 5780) ::
                Init_int16 (Int.repr 5784) :: Init_int16 (Int.repr 5788) ::
                Init_int16 (Int.repr 5792) :: Init_int16 (Int.repr 5795) ::
                Init_int16 (Int.repr 5799) :: Init_int16 (Int.repr 5803) ::
                Init_int16 (Int.repr 5806) :: Init_int16 (Int.repr 5810) ::
                Init_int16 (Int.repr 5814) :: Init_int16 (Int.repr 5818) ::
                Init_int16 (Int.repr 5821) :: Init_int16 (Int.repr 5825) ::
                Init_int16 (Int.repr 5829) :: Init_int16 (Int.repr 5833) ::
                Init_int16 (Int.repr 5836) :: Init_int16 (Int.repr 5840) ::
                Init_int16 (Int.repr 5844) :: Init_int16 (Int.repr 5848) ::
                Init_int16 (Int.repr 5851) :: Init_int16 (Int.repr 5855) ::
                Init_int16 (Int.repr 5859) :: Init_int16 (Int.repr 5863) ::
                Init_int16 (Int.repr 5866) :: Init_int16 (Int.repr 5870) ::
                Init_int16 (Int.repr 5874) :: Init_int16 (Int.repr 5877) ::
                Init_int16 (Int.repr 5881) :: Init_int16 (Int.repr 5885) ::
                Init_int16 (Int.repr 5889) :: Init_int16 (Int.repr 5892) ::
                Init_int16 (Int.repr 5896) :: Init_int16 (Int.repr 5900) ::
                Init_int16 (Int.repr 5904) :: Init_int16 (Int.repr 5907) ::
                Init_int16 (Int.repr 5911) :: Init_int16 (Int.repr 5915) ::
                Init_int16 (Int.repr 5919) :: Init_int16 (Int.repr 5922) ::
                Init_int16 (Int.repr 5926) :: Init_int16 (Int.repr 5930) ::
                Init_int16 (Int.repr 5933) :: Init_int16 (Int.repr 5937) ::
                Init_int16 (Int.repr 5941) :: Init_int16 (Int.repr 5945) ::
                Init_int16 (Int.repr 5948) :: Init_int16 (Int.repr 5952) ::
                Init_int16 (Int.repr 5956) :: Init_int16 (Int.repr 5960) ::
                Init_int16 (Int.repr 5963) :: Init_int16 (Int.repr 5967) ::
                Init_int16 (Int.repr 5971) :: Init_int16 (Int.repr 5974) ::
                Init_int16 (Int.repr 5978) :: Init_int16 (Int.repr 5982) ::
                Init_int16 (Int.repr 5986) :: Init_int16 (Int.repr 5989) ::
                Init_int16 (Int.repr 5993) :: Init_int16 (Int.repr 5997) ::
                Init_int16 (Int.repr 6001) :: Init_int16 (Int.repr 6004) ::
                Init_int16 (Int.repr 6008) :: Init_int16 (Int.repr 6012) ::
                Init_int16 (Int.repr 6015) :: Init_int16 (Int.repr 6019) ::
                Init_int16 (Int.repr 6023) :: Init_int16 (Int.repr 6027) ::
                Init_int16 (Int.repr 6030) :: Init_int16 (Int.repr 6034) ::
                Init_int16 (Int.repr 6038) :: Init_int16 (Int.repr 6041) ::
                Init_int16 (Int.repr 6045) :: Init_int16 (Int.repr 6049) ::
                Init_int16 (Int.repr 6053) :: Init_int16 (Int.repr 6056) ::
                Init_int16 (Int.repr 6060) :: Init_int16 (Int.repr 6064) ::
                Init_int16 (Int.repr 6067) :: Init_int16 (Int.repr 6071) ::
                Init_int16 (Int.repr 6075) :: Init_int16 (Int.repr 6079) ::
                Init_int16 (Int.repr 6082) :: Init_int16 (Int.repr 6086) ::
                Init_int16 (Int.repr 6090) :: Init_int16 (Int.repr 6093) ::
                Init_int16 (Int.repr 6097) :: Init_int16 (Int.repr 6101) ::
                Init_int16 (Int.repr 6105) :: Init_int16 (Int.repr 6108) ::
                Init_int16 (Int.repr 6112) :: Init_int16 (Int.repr 6116) ::
                Init_int16 (Int.repr 6119) :: Init_int16 (Int.repr 6123) ::
                Init_int16 (Int.repr 6127) :: Init_int16 (Int.repr 6131) ::
                Init_int16 (Int.repr 6134) :: Init_int16 (Int.repr 6138) ::
                Init_int16 (Int.repr 6142) :: Init_int16 (Int.repr 6145) ::
                Init_int16 (Int.repr 6149) :: Init_int16 (Int.repr 6153) ::
                Init_int16 (Int.repr 6157) :: Init_int16 (Int.repr 6160) ::
                Init_int16 (Int.repr 6164) :: Init_int16 (Int.repr 6168) ::
                Init_int16 (Int.repr 6171) :: Init_int16 (Int.repr 6175) ::
                Init_int16 (Int.repr 6179) :: Init_int16 (Int.repr 6182) ::
                Init_int16 (Int.repr 6186) :: Init_int16 (Int.repr 6190) ::
                Init_int16 (Int.repr 6194) :: Init_int16 (Int.repr 6197) ::
                Init_int16 (Int.repr 6201) :: Init_int16 (Int.repr 6205) ::
                Init_int16 (Int.repr 6208) :: Init_int16 (Int.repr 6212) ::
                Init_int16 (Int.repr 6216) :: Init_int16 (Int.repr 6219) ::
                Init_int16 (Int.repr 6223) :: Init_int16 (Int.repr 6227) ::
                Init_int16 (Int.repr 6231) :: Init_int16 (Int.repr 6234) ::
                Init_int16 (Int.repr 6238) :: Init_int16 (Int.repr 6242) ::
                Init_int16 (Int.repr 6245) :: Init_int16 (Int.repr 6249) ::
                Init_int16 (Int.repr 6253) :: Init_int16 (Int.repr 6256) ::
                Init_int16 (Int.repr 6260) :: Init_int16 (Int.repr 6264) ::
                Init_int16 (Int.repr 6268) :: Init_int16 (Int.repr 6271) ::
                Init_int16 (Int.repr 6275) :: Init_int16 (Int.repr 6279) ::
                Init_int16 (Int.repr 6282) :: Init_int16 (Int.repr 6286) ::
                Init_int16 (Int.repr 6290) :: Init_int16 (Int.repr 6293) ::
                Init_int16 (Int.repr 6297) :: Init_int16 (Int.repr 6301) ::
                Init_int16 (Int.repr 6304) :: Init_int16 (Int.repr 6308) ::
                Init_int16 (Int.repr 6312) :: Init_int16 (Int.repr 6316) ::
                Init_int16 (Int.repr 6319) :: Init_int16 (Int.repr 6323) ::
                Init_int16 (Int.repr 6327) :: Init_int16 (Int.repr 6330) ::
                Init_int16 (Int.repr 6334) :: Init_int16 (Int.repr 6338) ::
                Init_int16 (Int.repr 6341) :: Init_int16 (Int.repr 6345) ::
                Init_int16 (Int.repr 6349) :: Init_int16 (Int.repr 6352) ::
                Init_int16 (Int.repr 6356) :: Init_int16 (Int.repr 6360) ::
                Init_int16 (Int.repr 6364) :: Init_int16 (Int.repr 6367) ::
                Init_int16 (Int.repr 6371) :: Init_int16 (Int.repr 6375) ::
                Init_int16 (Int.repr 6378) :: Init_int16 (Int.repr 6382) ::
                Init_int16 (Int.repr 6386) :: Init_int16 (Int.repr 6389) ::
                Init_int16 (Int.repr 6393) :: Init_int16 (Int.repr 6397) ::
                Init_int16 (Int.repr 6400) :: Init_int16 (Int.repr 6404) ::
                Init_int16 (Int.repr 6408) :: Init_int16 (Int.repr 6411) ::
                Init_int16 (Int.repr 6415) :: Init_int16 (Int.repr 6419) ::
                Init_int16 (Int.repr 6422) :: Init_int16 (Int.repr 6426) ::
                Init_int16 (Int.repr 6430) :: Init_int16 (Int.repr 6433) ::
                Init_int16 (Int.repr 6437) :: Init_int16 (Int.repr 6441) ::
                Init_int16 (Int.repr 6445) :: Init_int16 (Int.repr 6448) ::
                Init_int16 (Int.repr 6452) :: Init_int16 (Int.repr 6456) ::
                Init_int16 (Int.repr 6459) :: Init_int16 (Int.repr 6463) ::
                Init_int16 (Int.repr 6467) :: Init_int16 (Int.repr 6470) ::
                Init_int16 (Int.repr 6474) :: Init_int16 (Int.repr 6478) ::
                Init_int16 (Int.repr 6481) :: Init_int16 (Int.repr 6485) ::
                Init_int16 (Int.repr 6489) :: Init_int16 (Int.repr 6492) ::
                Init_int16 (Int.repr 6496) :: Init_int16 (Int.repr 6500) ::
                Init_int16 (Int.repr 6503) :: Init_int16 (Int.repr 6507) ::
                Init_int16 (Int.repr 6511) :: Init_int16 (Int.repr 6514) ::
                Init_int16 (Int.repr 6518) :: Init_int16 (Int.repr 6522) ::
                Init_int16 (Int.repr 6525) :: Init_int16 (Int.repr 6529) ::
                Init_int16 (Int.repr 6533) :: Init_int16 (Int.repr 6536) ::
                Init_int16 (Int.repr 6540) :: Init_int16 (Int.repr 6544) ::
                Init_int16 (Int.repr 6547) :: Init_int16 (Int.repr 6551) ::
                Init_int16 (Int.repr 6555) :: Init_int16 (Int.repr 6558) ::
                Init_int16 (Int.repr 6562) :: Init_int16 (Int.repr 6566) ::
                Init_int16 (Int.repr 6569) :: Init_int16 (Int.repr 6573) ::
                Init_int16 (Int.repr 6577) :: Init_int16 (Int.repr 6580) ::
                Init_int16 (Int.repr 6584) :: Init_int16 (Int.repr 6588) ::
                Init_int16 (Int.repr 6591) :: Init_int16 (Int.repr 6595) ::
                Init_int16 (Int.repr 6599) :: Init_int16 (Int.repr 6602) ::
                Init_int16 (Int.repr 6606) :: Init_int16 (Int.repr 6610) ::
                Init_int16 (Int.repr 6613) :: Init_int16 (Int.repr 6617) ::
                Init_int16 (Int.repr 6621) :: Init_int16 (Int.repr 6624) ::
                Init_int16 (Int.repr 6628) :: Init_int16 (Int.repr 6632) ::
                Init_int16 (Int.repr 6635) :: Init_int16 (Int.repr 6639) ::
                Init_int16 (Int.repr 6643) :: Init_int16 (Int.repr 6646) ::
                Init_int16 (Int.repr 6650) :: Init_int16 (Int.repr 6654) ::
                Init_int16 (Int.repr 6657) :: Init_int16 (Int.repr 6661) ::
                Init_int16 (Int.repr 6664) :: Init_int16 (Int.repr 6668) ::
                Init_int16 (Int.repr 6672) :: Init_int16 (Int.repr 6675) ::
                Init_int16 (Int.repr 6679) :: Init_int16 (Int.repr 6683) ::
                Init_int16 (Int.repr 6686) :: Init_int16 (Int.repr 6690) ::
                Init_int16 (Int.repr 6694) :: Init_int16 (Int.repr 6697) ::
                Init_int16 (Int.repr 6701) :: Init_int16 (Int.repr 6705) ::
                Init_int16 (Int.repr 6708) :: Init_int16 (Int.repr 6712) ::
                Init_int16 (Int.repr 6716) :: Init_int16 (Int.repr 6719) ::
                Init_int16 (Int.repr 6723) :: Init_int16 (Int.repr 6727) ::
                Init_int16 (Int.repr 6730) :: Init_int16 (Int.repr 6734) ::
                Init_int16 (Int.repr 6737) :: Init_int16 (Int.repr 6741) ::
                Init_int16 (Int.repr 6745) :: Init_int16 (Int.repr 6748) ::
                Init_int16 (Int.repr 6752) :: Init_int16 (Int.repr 6756) ::
                Init_int16 (Int.repr 6759) :: Init_int16 (Int.repr 6763) ::
                Init_int16 (Int.repr 6767) :: Init_int16 (Int.repr 6770) ::
                Init_int16 (Int.repr 6774) :: Init_int16 (Int.repr 6778) ::
                Init_int16 (Int.repr 6781) :: Init_int16 (Int.repr 6785) ::
                Init_int16 (Int.repr 6788) :: Init_int16 (Int.repr 6792) ::
                Init_int16 (Int.repr 6796) :: Init_int16 (Int.repr 6799) ::
                Init_int16 (Int.repr 6803) :: Init_int16 (Int.repr 6807) ::
                Init_int16 (Int.repr 6810) :: Init_int16 (Int.repr 6814) ::
                Init_int16 (Int.repr 6818) :: Init_int16 (Int.repr 6821) ::
                Init_int16 (Int.repr 6825) :: Init_int16 (Int.repr 6828) ::
                Init_int16 (Int.repr 6832) :: Init_int16 (Int.repr 6836) ::
                Init_int16 (Int.repr 6839) :: Init_int16 (Int.repr 6843) ::
                Init_int16 (Int.repr 6847) :: Init_int16 (Int.repr 6850) ::
                Init_int16 (Int.repr 6854) :: Init_int16 (Int.repr 6858) ::
                Init_int16 (Int.repr 6861) :: Init_int16 (Int.repr 6865) ::
                Init_int16 (Int.repr 6868) :: Init_int16 (Int.repr 6872) ::
                Init_int16 (Int.repr 6876) :: Init_int16 (Int.repr 6879) ::
                Init_int16 (Int.repr 6883) :: Init_int16 (Int.repr 6887) ::
                Init_int16 (Int.repr 6890) :: Init_int16 (Int.repr 6894) ::
                Init_int16 (Int.repr 6898) :: Init_int16 (Int.repr 6901) ::
                Init_int16 (Int.repr 6905) :: Init_int16 (Int.repr 6908) ::
                Init_int16 (Int.repr 6912) :: Init_int16 (Int.repr 6916) ::
                Init_int16 (Int.repr 6919) :: Init_int16 (Int.repr 6923) ::
                Init_int16 (Int.repr 6927) :: Init_int16 (Int.repr 6930) ::
                Init_int16 (Int.repr 6934) :: Init_int16 (Int.repr 6937) ::
                Init_int16 (Int.repr 6941) :: Init_int16 (Int.repr 6945) ::
                Init_int16 (Int.repr 6948) :: Init_int16 (Int.repr 6952) ::
                Init_int16 (Int.repr 6956) :: Init_int16 (Int.repr 6959) ::
                Init_int16 (Int.repr 6963) :: Init_int16 (Int.repr 6966) ::
                Init_int16 (Int.repr 6970) :: Init_int16 (Int.repr 6974) ::
                Init_int16 (Int.repr 6977) :: Init_int16 (Int.repr 6981) ::
                Init_int16 (Int.repr 6984) :: Init_int16 (Int.repr 6988) ::
                Init_int16 (Int.repr 6992) :: Init_int16 (Int.repr 6995) ::
                Init_int16 (Int.repr 6999) :: Init_int16 (Int.repr 7003) ::
                Init_int16 (Int.repr 7006) :: Init_int16 (Int.repr 7010) ::
                Init_int16 (Int.repr 7013) :: Init_int16 (Int.repr 7017) ::
                Init_int16 (Int.repr 7021) :: Init_int16 (Int.repr 7024) ::
                Init_int16 (Int.repr 7028) :: Init_int16 (Int.repr 7031) ::
                Init_int16 (Int.repr 7035) :: Init_int16 (Int.repr 7039) ::
                Init_int16 (Int.repr 7042) :: Init_int16 (Int.repr 7046) ::
                Init_int16 (Int.repr 7050) :: Init_int16 (Int.repr 7053) ::
                Init_int16 (Int.repr 7057) :: Init_int16 (Int.repr 7060) ::
                Init_int16 (Int.repr 7064) :: Init_int16 (Int.repr 7068) ::
                Init_int16 (Int.repr 7071) :: Init_int16 (Int.repr 7075) ::
                Init_int16 (Int.repr 7078) :: Init_int16 (Int.repr 7082) ::
                Init_int16 (Int.repr 7086) :: Init_int16 (Int.repr 7089) ::
                Init_int16 (Int.repr 7093) :: Init_int16 (Int.repr 7096) ::
                Init_int16 (Int.repr 7100) :: Init_int16 (Int.repr 7104) ::
                Init_int16 (Int.repr 7107) :: Init_int16 (Int.repr 7111) ::
                Init_int16 (Int.repr 7114) :: Init_int16 (Int.repr 7118) ::
                Init_int16 (Int.repr 7122) :: Init_int16 (Int.repr 7125) ::
                Init_int16 (Int.repr 7129) :: Init_int16 (Int.repr 7132) ::
                Init_int16 (Int.repr 7136) :: Init_int16 (Int.repr 7140) ::
                Init_int16 (Int.repr 7143) :: Init_int16 (Int.repr 7147) ::
                Init_int16 (Int.repr 7150) :: Init_int16 (Int.repr 7154) ::
                Init_int16 (Int.repr 7158) :: Init_int16 (Int.repr 7161) ::
                Init_int16 (Int.repr 7165) :: Init_int16 (Int.repr 7168) ::
                Init_int16 (Int.repr 7172) :: Init_int16 (Int.repr 7176) ::
                Init_int16 (Int.repr 7179) :: Init_int16 (Int.repr 7183) ::
                Init_int16 (Int.repr 7186) :: Init_int16 (Int.repr 7190) ::
                Init_int16 (Int.repr 7194) :: Init_int16 (Int.repr 7197) ::
                Init_int16 (Int.repr 7201) :: Init_int16 (Int.repr 7204) ::
                Init_int16 (Int.repr 7208) :: Init_int16 (Int.repr 7212) ::
                Init_int16 (Int.repr 7215) :: Init_int16 (Int.repr 7219) ::
                Init_int16 (Int.repr 7222) :: Init_int16 (Int.repr 7226) ::
                Init_int16 (Int.repr 7230) :: Init_int16 (Int.repr 7233) ::
                Init_int16 (Int.repr 7237) :: Init_int16 (Int.repr 7240) ::
                Init_int16 (Int.repr 7244) :: Init_int16 (Int.repr 7247) ::
                Init_int16 (Int.repr 7251) :: Init_int16 (Int.repr 7255) ::
                Init_int16 (Int.repr 7258) :: Init_int16 (Int.repr 7262) ::
                Init_int16 (Int.repr 7265) :: Init_int16 (Int.repr 7269) ::
                Init_int16 (Int.repr 7273) :: Init_int16 (Int.repr 7276) ::
                Init_int16 (Int.repr 7280) :: Init_int16 (Int.repr 7283) ::
                Init_int16 (Int.repr 7287) :: Init_int16 (Int.repr 7290) ::
                Init_int16 (Int.repr 7294) :: Init_int16 (Int.repr 7298) ::
                Init_int16 (Int.repr 7301) :: Init_int16 (Int.repr 7305) ::
                Init_int16 (Int.repr 7308) :: Init_int16 (Int.repr 7312) ::
                Init_int16 (Int.repr 7316) :: Init_int16 (Int.repr 7319) ::
                Init_int16 (Int.repr 7323) :: Init_int16 (Int.repr 7326) ::
                Init_int16 (Int.repr 7330) :: Init_int16 (Int.repr 7333) ::
                Init_int16 (Int.repr 7337) :: Init_int16 (Int.repr 7341) ::
                Init_int16 (Int.repr 7344) :: Init_int16 (Int.repr 7348) ::
                Init_int16 (Int.repr 7351) :: Init_int16 (Int.repr 7355) ::
                Init_int16 (Int.repr 7358) :: Init_int16 (Int.repr 7362) ::
                Init_int16 (Int.repr 7366) :: Init_int16 (Int.repr 7369) ::
                Init_int16 (Int.repr 7373) :: Init_int16 (Int.repr 7376) ::
                Init_int16 (Int.repr 7380) :: Init_int16 (Int.repr 7383) ::
                Init_int16 (Int.repr 7387) :: Init_int16 (Int.repr 7391) ::
                Init_int16 (Int.repr 7394) :: Init_int16 (Int.repr 7398) ::
                Init_int16 (Int.repr 7401) :: Init_int16 (Int.repr 7405) ::
                Init_int16 (Int.repr 7408) :: Init_int16 (Int.repr 7412) ::
                Init_int16 (Int.repr 7416) :: Init_int16 (Int.repr 7419) ::
                Init_int16 (Int.repr 7423) :: Init_int16 (Int.repr 7426) ::
                Init_int16 (Int.repr 7430) :: Init_int16 (Int.repr 7433) ::
                Init_int16 (Int.repr 7437) :: Init_int16 (Int.repr 7441) ::
                Init_int16 (Int.repr 7444) :: Init_int16 (Int.repr 7448) ::
                Init_int16 (Int.repr 7451) :: Init_int16 (Int.repr 7455) ::
                Init_int16 (Int.repr 7458) :: Init_int16 (Int.repr 7462) ::
                Init_int16 (Int.repr 7465) :: Init_int16 (Int.repr 7469) ::
                Init_int16 (Int.repr 7473) :: Init_int16 (Int.repr 7476) ::
                Init_int16 (Int.repr 7480) :: Init_int16 (Int.repr 7483) ::
                Init_int16 (Int.repr 7487) :: Init_int16 (Int.repr 7490) ::
                Init_int16 (Int.repr 7494) :: Init_int16 (Int.repr 7498) ::
                Init_int16 (Int.repr 7501) :: Init_int16 (Int.repr 7505) ::
                Init_int16 (Int.repr 7508) :: Init_int16 (Int.repr 7512) ::
                Init_int16 (Int.repr 7515) :: Init_int16 (Int.repr 7519) ::
                Init_int16 (Int.repr 7522) :: Init_int16 (Int.repr 7526) ::
                Init_int16 (Int.repr 7530) :: Init_int16 (Int.repr 7533) ::
                Init_int16 (Int.repr 7537) :: Init_int16 (Int.repr 7540) ::
                Init_int16 (Int.repr 7544) :: Init_int16 (Int.repr 7547) ::
                Init_int16 (Int.repr 7551) :: Init_int16 (Int.repr 7554) ::
                Init_int16 (Int.repr 7558) :: Init_int16 (Int.repr 7561) ::
                Init_int16 (Int.repr 7565) :: Init_int16 (Int.repr 7569) ::
                Init_int16 (Int.repr 7572) :: Init_int16 (Int.repr 7576) ::
                Init_int16 (Int.repr 7579) :: Init_int16 (Int.repr 7583) ::
                Init_int16 (Int.repr 7586) :: Init_int16 (Int.repr 7590) ::
                Init_int16 (Int.repr 7593) :: Init_int16 (Int.repr 7597) ::
                Init_int16 (Int.repr 7600) :: Init_int16 (Int.repr 7604) ::
                Init_int16 (Int.repr 7608) :: Init_int16 (Int.repr 7611) ::
                Init_int16 (Int.repr 7615) :: Init_int16 (Int.repr 7618) ::
                Init_int16 (Int.repr 7622) :: Init_int16 (Int.repr 7625) ::
                Init_int16 (Int.repr 7629) :: Init_int16 (Int.repr 7632) ::
                Init_int16 (Int.repr 7636) :: Init_int16 (Int.repr 7639) ::
                Init_int16 (Int.repr 7643) :: Init_int16 (Int.repr 7646) ::
                Init_int16 (Int.repr 7650) :: Init_int16 (Int.repr 7654) ::
                Init_int16 (Int.repr 7657) :: Init_int16 (Int.repr 7661) ::
                Init_int16 (Int.repr 7664) :: Init_int16 (Int.repr 7668) ::
                Init_int16 (Int.repr 7671) :: Init_int16 (Int.repr 7675) ::
                Init_int16 (Int.repr 7678) :: Init_int16 (Int.repr 7682) ::
                Init_int16 (Int.repr 7685) :: Init_int16 (Int.repr 7689) ::
                Init_int16 (Int.repr 7692) :: Init_int16 (Int.repr 7696) ::
                Init_int16 (Int.repr 7700) :: Init_int16 (Int.repr 7703) ::
                Init_int16 (Int.repr 7707) :: Init_int16 (Int.repr 7710) ::
                Init_int16 (Int.repr 7714) :: Init_int16 (Int.repr 7717) ::
                Init_int16 (Int.repr 7721) :: Init_int16 (Int.repr 7724) ::
                Init_int16 (Int.repr 7728) :: Init_int16 (Int.repr 7731) ::
                Init_int16 (Int.repr 7735) :: Init_int16 (Int.repr 7738) ::
                Init_int16 (Int.repr 7742) :: Init_int16 (Int.repr 7745) ::
                Init_int16 (Int.repr 7749) :: Init_int16 (Int.repr 7752) ::
                Init_int16 (Int.repr 7756) :: Init_int16 (Int.repr 7759) ::
                Init_int16 (Int.repr 7763) :: Init_int16 (Int.repr 7767) ::
                Init_int16 (Int.repr 7770) :: Init_int16 (Int.repr 7774) ::
                Init_int16 (Int.repr 7777) :: Init_int16 (Int.repr 7781) ::
                Init_int16 (Int.repr 7784) :: Init_int16 (Int.repr 7788) ::
                Init_int16 (Int.repr 7791) :: Init_int16 (Int.repr 7795) ::
                Init_int16 (Int.repr 7798) :: Init_int16 (Int.repr 7802) ::
                Init_int16 (Int.repr 7805) :: Init_int16 (Int.repr 7809) ::
                Init_int16 (Int.repr 7812) :: Init_int16 (Int.repr 7816) ::
                Init_int16 (Int.repr 7819) :: Init_int16 (Int.repr 7823) ::
                Init_int16 (Int.repr 7826) :: Init_int16 (Int.repr 7830) ::
                Init_int16 (Int.repr 7833) :: Init_int16 (Int.repr 7837) ::
                Init_int16 (Int.repr 7840) :: Init_int16 (Int.repr 7844) ::
                Init_int16 (Int.repr 7847) :: Init_int16 (Int.repr 7851) ::
                Init_int16 (Int.repr 7854) :: Init_int16 (Int.repr 7858) ::
                Init_int16 (Int.repr 7861) :: Init_int16 (Int.repr 7865) ::
                Init_int16 (Int.repr 7868) :: Init_int16 (Int.repr 7872) ::
                Init_int16 (Int.repr 7875) :: Init_int16 (Int.repr 7879) ::
                Init_int16 (Int.repr 7882) :: Init_int16 (Int.repr 7886) ::
                Init_int16 (Int.repr 7889) :: Init_int16 (Int.repr 7893) ::
                Init_int16 (Int.repr 7896) :: Init_int16 (Int.repr 7900) ::
                Init_int16 (Int.repr 7904) :: Init_int16 (Int.repr 7907) ::
                Init_int16 (Int.repr 7911) :: Init_int16 (Int.repr 7914) ::
                Init_int16 (Int.repr 7918) :: Init_int16 (Int.repr 7921) ::
                Init_int16 (Int.repr 7925) :: Init_int16 (Int.repr 7928) ::
                Init_int16 (Int.repr 7932) :: Init_int16 (Int.repr 7935) ::
                Init_int16 (Int.repr 7939) :: Init_int16 (Int.repr 7942) ::
                Init_int16 (Int.repr 7946) :: Init_int16 (Int.repr 7949) ::
                Init_int16 (Int.repr 7953) :: Init_int16 (Int.repr 7956) ::
                Init_int16 (Int.repr 7960) :: Init_int16 (Int.repr 7963) ::
                Init_int16 (Int.repr 7966) :: Init_int16 (Int.repr 7970) ::
                Init_int16 (Int.repr 7973) :: Init_int16 (Int.repr 7977) ::
                Init_int16 (Int.repr 7980) :: Init_int16 (Int.repr 7984) ::
                Init_int16 (Int.repr 7987) :: Init_int16 (Int.repr 7991) ::
                Init_int16 (Int.repr 7994) :: Init_int16 (Int.repr 7998) ::
                Init_int16 (Int.repr 8001) :: Init_int16 (Int.repr 8005) ::
                Init_int16 (Int.repr 8008) :: Init_int16 (Int.repr 8012) ::
                Init_int16 (Int.repr 8015) :: Init_int16 (Int.repr 8019) ::
                Init_int16 (Int.repr 8022) :: Init_int16 (Int.repr 8026) ::
                Init_int16 (Int.repr 8029) :: Init_int16 (Int.repr 8033) ::
                Init_int16 (Int.repr 8036) :: Init_int16 (Int.repr 8040) ::
                Init_int16 (Int.repr 8043) :: Init_int16 (Int.repr 8047) ::
                Init_int16 (Int.repr 8050) :: Init_int16 (Int.repr 8054) ::
                Init_int16 (Int.repr 8057) :: Init_int16 (Int.repr 8061) ::
                Init_int16 (Int.repr 8064) :: Init_int16 (Int.repr 8068) ::
                Init_int16 (Int.repr 8071) :: Init_int16 (Int.repr 8075) ::
                Init_int16 (Int.repr 8078) :: Init_int16 (Int.repr 8082) ::
                Init_int16 (Int.repr 8085) :: Init_int16 (Int.repr 8089) ::
                Init_int16 (Int.repr 8092) :: Init_int16 (Int.repr 8095) ::
                Init_int16 (Int.repr 8099) :: Init_int16 (Int.repr 8102) ::
                Init_int16 (Int.repr 8106) :: Init_int16 (Int.repr 8109) ::
                Init_int16 (Int.repr 8113) :: Init_int16 (Int.repr 8116) ::
                Init_int16 (Int.repr 8120) :: Init_int16 (Int.repr 8123) ::
                Init_int16 (Int.repr 8127) :: Init_int16 (Int.repr 8130) ::
                Init_int16 (Int.repr 8134) :: Init_int16 (Int.repr 8137) ::
                Init_int16 (Int.repr 8141) :: Init_int16 (Int.repr 8144) ::
                Init_int16 (Int.repr 8148) :: Init_int16 (Int.repr 8151) ::
                Init_int16 (Int.repr 8155) :: Init_int16 (Int.repr 8158) ::
                Init_int16 (Int.repr 8161) :: Init_int16 (Int.repr 8165) ::
                Init_int16 (Int.repr 8168) :: Init_int16 (Int.repr 8172) ::
                Init_int16 (Int.repr 8175) :: Init_int16 (Int.repr 8179) ::
                Init_int16 (Int.repr 8182) :: Init_int16 (Int.repr 8186) ::
                Init_int16 (Int.repr 8189) :: Init_int16 (Int.repr 8193) ::
                Init_int16 (Int.repr 8196) :: Init_int16 (Int.repr 8200) ::
                Init_int16 (Int.repr 8203) :: Init_int16 (Int.repr 8207) ::
                Init_int16 (Int.repr 8210) :: Init_int16 (Int.repr 8213) ::
                Init_int16 (Int.repr 8217) :: Init_int16 (Int.repr 8220) ::
                Init_int16 (Int.repr 8224) :: Init_int16 (Int.repr 8227) ::
                Init_int16 (Int.repr 8231) :: Init_int16 (Int.repr 8234) ::
                Init_int16 (Int.repr 8238) :: Init_int16 (Int.repr 8241) ::
                Init_int16 (Int.repr 8245) :: Init_int16 (Int.repr 8248) ::
                Init_int16 (Int.repr 8251) :: Init_int16 (Int.repr 8255) ::
                Init_int16 (Int.repr 8258) :: Init_int16 (Int.repr 8262) ::
                Init_int16 (Int.repr 8265) :: Init_int16 (Int.repr 8269) ::
                Init_int16 (Int.repr 8272) :: Init_int16 (Int.repr 8276) ::
                Init_int16 (Int.repr 8279) :: Init_int16 (Int.repr 8283) ::
                Init_int16 (Int.repr 8286) :: Init_int16 (Int.repr 8289) ::
                Init_int16 (Int.repr 8293) :: Init_int16 (Int.repr 8296) ::
                Init_int16 (Int.repr 8300) :: Init_int16 (Int.repr 8303) ::
                Init_int16 (Int.repr 8307) :: Init_int16 (Int.repr 8310) ::
                Init_int16 (Int.repr 8314) :: Init_int16 (Int.repr 8317) ::
                Init_int16 (Int.repr 8321) :: Init_int16 (Int.repr 8324) ::
                Init_int16 (Int.repr 8327) :: Init_int16 (Int.repr 8331) ::
                Init_int16 (Int.repr 8334) :: Init_int16 (Int.repr 8338) ::
                Init_int16 (Int.repr 8341) :: Init_int16 (Int.repr 8345) ::
                Init_int16 (Int.repr 8348) :: Init_int16 (Int.repr 8351) ::
                Init_int16 (Int.repr 8355) :: Init_int16 (Int.repr 8358) ::
                Init_int16 (Int.repr 8362) :: Init_int16 (Int.repr 8365) ::
                Init_int16 (Int.repr 8369) :: Init_int16 (Int.repr 8372) ::
                Init_int16 (Int.repr 8376) :: Init_int16 (Int.repr 8379) ::
                Init_int16 (Int.repr 8382) :: Init_int16 (Int.repr 8386) ::
                Init_int16 (Int.repr 8389) :: Init_int16 (Int.repr 8393) ::
                Init_int16 (Int.repr 8396) :: Init_int16 (Int.repr 8400) ::
                Init_int16 (Int.repr 8403) :: Init_int16 (Int.repr 8406) ::
                Init_int16 (Int.repr 8410) :: Init_int16 (Int.repr 8413) ::
                Init_int16 (Int.repr 8417) :: Init_int16 (Int.repr 8420) ::
                Init_int16 (Int.repr 8424) :: Init_int16 (Int.repr 8427) ::
                Init_int16 (Int.repr 8431) :: Init_int16 (Int.repr 8434) ::
                Init_int16 (Int.repr 8437) :: Init_int16 (Int.repr 8441) ::
                Init_int16 (Int.repr 8444) :: Init_int16 (Int.repr 8448) ::
                Init_int16 (Int.repr 8451) :: Init_int16 (Int.repr 8455) ::
                Init_int16 (Int.repr 8458) :: Init_int16 (Int.repr 8461) ::
                Init_int16 (Int.repr 8465) :: Init_int16 (Int.repr 8468) ::
                Init_int16 (Int.repr 8472) :: Init_int16 (Int.repr 8475) ::
                Init_int16 (Int.repr 8478) :: Init_int16 (Int.repr 8482) ::
                Init_int16 (Int.repr 8485) :: Init_int16 (Int.repr 8489) ::
                Init_int16 (Int.repr 8492) :: Init_int16 (Int.repr 8496) ::
                Init_int16 (Int.repr 8499) :: Init_int16 (Int.repr 8502) ::
                Init_int16 (Int.repr 8506) :: Init_int16 (Int.repr 8509) ::
                Init_int16 (Int.repr 8513) :: Init_int16 (Int.repr 8516) ::
                Init_int16 (Int.repr 8520) :: Init_int16 (Int.repr 8523) ::
                Init_int16 (Int.repr 8526) :: Init_int16 (Int.repr 8530) ::
                Init_int16 (Int.repr 8533) :: Init_int16 (Int.repr 8537) ::
                Init_int16 (Int.repr 8540) :: Init_int16 (Int.repr 8543) ::
                Init_int16 (Int.repr 8547) :: Init_int16 (Int.repr 8550) ::
                Init_int16 (Int.repr 8554) :: Init_int16 (Int.repr 8557) ::
                Init_int16 (Int.repr 8560) :: Init_int16 (Int.repr 8564) ::
                Init_int16 (Int.repr 8567) :: Init_int16 (Int.repr 8571) ::
                Init_int16 (Int.repr 8574) :: Init_int16 (Int.repr 8578) ::
                Init_int16 (Int.repr 8581) :: Init_int16 (Int.repr 8584) ::
                Init_int16 (Int.repr 8588) :: Init_int16 (Int.repr 8591) ::
                Init_int16 (Int.repr 8595) :: Init_int16 (Int.repr 8598) ::
                Init_int16 (Int.repr 8601) :: Init_int16 (Int.repr 8605) ::
                Init_int16 (Int.repr 8608) :: Init_int16 (Int.repr 8612) ::
                Init_int16 (Int.repr 8615) :: Init_int16 (Int.repr 8618) ::
                Init_int16 (Int.repr 8622) :: Init_int16 (Int.repr 8625) ::
                Init_int16 (Int.repr 8629) :: Init_int16 (Int.repr 8632) ::
                Init_int16 (Int.repr 8635) :: Init_int16 (Int.repr 8639) ::
                Init_int16 (Int.repr 8642) :: Init_int16 (Int.repr 8646) ::
                Init_int16 (Int.repr 8649) :: Init_int16 (Int.repr 8652) ::
                Init_int16 (Int.repr 8656) :: Init_int16 (Int.repr 8659) ::
                Init_int16 (Int.repr 8663) :: Init_int16 (Int.repr 8666) ::
                Init_int16 (Int.repr 8669) :: Init_int16 (Int.repr 8673) ::
                Init_int16 (Int.repr 8676) :: Init_int16 (Int.repr 8680) ::
                Init_int16 (Int.repr 8683) :: Init_int16 (Int.repr 8686) ::
                Init_int16 (Int.repr 8690) :: Init_int16 (Int.repr 8693) ::
                Init_int16 (Int.repr 8696) :: Init_int16 (Int.repr 8700) ::
                Init_int16 (Int.repr 8703) :: Init_int16 (Int.repr 8707) ::
                Init_int16 (Int.repr 8710) :: Init_int16 (Int.repr 8713) ::
                Init_int16 (Int.repr 8717) :: Init_int16 (Int.repr 8720) ::
                Init_int16 (Int.repr 8724) :: Init_int16 (Int.repr 8727) ::
                Init_int16 (Int.repr 8730) :: Init_int16 (Int.repr 8734) ::
                Init_int16 (Int.repr 8737) :: Init_int16 (Int.repr 8741) ::
                Init_int16 (Int.repr 8744) :: Init_int16 (Int.repr 8747) ::
                Init_int16 (Int.repr 8751) :: Init_int16 (Int.repr 8754) ::
                Init_int16 (Int.repr 8757) :: Init_int16 (Int.repr 8761) ::
                Init_int16 (Int.repr 8764) :: Init_int16 (Int.repr 8768) ::
                Init_int16 (Int.repr 8771) :: Init_int16 (Int.repr 8774) ::
                Init_int16 (Int.repr 8778) :: Init_int16 (Int.repr 8781) ::
                Init_int16 (Int.repr 8784) :: Init_int16 (Int.repr 8788) ::
                Init_int16 (Int.repr 8791) :: Init_int16 (Int.repr 8795) ::
                Init_int16 (Int.repr 8798) :: Init_int16 (Int.repr 8801) ::
                Init_int16 (Int.repr 8805) :: Init_int16 (Int.repr 8808) ::
                Init_int16 (Int.repr 8811) :: Init_int16 (Int.repr 8815) ::
                Init_int16 (Int.repr 8818) :: Init_int16 (Int.repr 8822) ::
                Init_int16 (Int.repr 8825) :: Init_int16 (Int.repr 8828) ::
                Init_int16 (Int.repr 8832) :: Init_int16 (Int.repr 8835) ::
                Init_int16 (Int.repr 8838) :: Init_int16 (Int.repr 8842) ::
                Init_int16 (Int.repr 8845) :: Init_int16 (Int.repr 8849) ::
                Init_int16 (Int.repr 8852) :: Init_int16 (Int.repr 8855) ::
                Init_int16 (Int.repr 8859) :: Init_int16 (Int.repr 8862) ::
                Init_int16 (Int.repr 8865) :: Init_int16 (Int.repr 8869) ::
                Init_int16 (Int.repr 8872) :: Init_int16 (Int.repr 8875) ::
                Init_int16 (Int.repr 8879) :: Init_int16 (Int.repr 8882) ::
                Init_int16 (Int.repr 8886) :: Init_int16 (Int.repr 8889) ::
                Init_int16 (Int.repr 8892) :: Init_int16 (Int.repr 8896) ::
                Init_int16 (Int.repr 8899) :: Init_int16 (Int.repr 8902) ::
                Init_int16 (Int.repr 8906) :: Init_int16 (Int.repr 8909) ::
                Init_int16 (Int.repr 8912) :: Init_int16 (Int.repr 8916) ::
                Init_int16 (Int.repr 8919) :: Init_int16 (Int.repr 8922) ::
                Init_int16 (Int.repr 8926) :: Init_int16 (Int.repr 8929) ::
                Init_int16 (Int.repr 8933) :: Init_int16 (Int.repr 8936) ::
                Init_int16 (Int.repr 8939) :: Init_int16 (Int.repr 8943) ::
                Init_int16 (Int.repr 8946) :: Init_int16 (Int.repr 8949) ::
                Init_int16 (Int.repr 8953) :: Init_int16 (Int.repr 8956) ::
                Init_int16 (Int.repr 8959) :: Init_int16 (Int.repr 8963) ::
                Init_int16 (Int.repr 8966) :: Init_int16 (Int.repr 8969) ::
                Init_int16 (Int.repr 8973) :: Init_int16 (Int.repr 8976) ::
                Init_int16 (Int.repr 8979) :: Init_int16 (Int.repr 8983) ::
                Init_int16 (Int.repr 8986) :: Init_int16 (Int.repr 8989) ::
                Init_int16 (Int.repr 8993) :: Init_int16 (Int.repr 8996) ::
                Init_int16 (Int.repr 8999) :: Init_int16 (Int.repr 9003) ::
                Init_int16 (Int.repr 9006) :: Init_int16 (Int.repr 9009) ::
                Init_int16 (Int.repr 9013) :: Init_int16 (Int.repr 9016) ::
                Init_int16 (Int.repr 9020) :: Init_int16 (Int.repr 9023) ::
                Init_int16 (Int.repr 9026) :: Init_int16 (Int.repr 9030) ::
                Init_int16 (Int.repr 9033) :: Init_int16 (Int.repr 9036) ::
                Init_int16 (Int.repr 9040) :: Init_int16 (Int.repr 9043) ::
                Init_int16 (Int.repr 9046) :: Init_int16 (Int.repr 9050) ::
                Init_int16 (Int.repr 9053) :: Init_int16 (Int.repr 9056) ::
                Init_int16 (Int.repr 9060) :: Init_int16 (Int.repr 9063) ::
                Init_int16 (Int.repr 9066) :: Init_int16 (Int.repr 9070) ::
                Init_int16 (Int.repr 9073) :: Init_int16 (Int.repr 9076) ::
                Init_int16 (Int.repr 9080) :: Init_int16 (Int.repr 9083) ::
                Init_int16 (Int.repr 9086) :: Init_int16 (Int.repr 9090) ::
                Init_int16 (Int.repr 9093) :: Init_int16 (Int.repr 9096) ::
                Init_int16 (Int.repr 9099) :: Init_int16 (Int.repr 9103) ::
                Init_int16 (Int.repr 9106) :: Init_int16 (Int.repr 9109) ::
                Init_int16 (Int.repr 9113) :: Init_int16 (Int.repr 9116) ::
                Init_int16 (Int.repr 9119) :: Init_int16 (Int.repr 9123) ::
                Init_int16 (Int.repr 9126) :: Init_int16 (Int.repr 9129) ::
                Init_int16 (Int.repr 9133) :: Init_int16 (Int.repr 9136) ::
                Init_int16 (Int.repr 9139) :: Init_int16 (Int.repr 9143) ::
                Init_int16 (Int.repr 9146) :: Init_int16 (Int.repr 9149) ::
                Init_int16 (Int.repr 9153) :: Init_int16 (Int.repr 9156) ::
                Init_int16 (Int.repr 9159) :: Init_int16 (Int.repr 9163) ::
                Init_int16 (Int.repr 9166) :: Init_int16 (Int.repr 9169) ::
                Init_int16 (Int.repr 9173) :: Init_int16 (Int.repr 9176) ::
                Init_int16 (Int.repr 9179) :: Init_int16 (Int.repr 9182) ::
                Init_int16 (Int.repr 9186) :: Init_int16 (Int.repr 9189) ::
                Init_int16 (Int.repr 9192) :: Init_int16 (Int.repr 9196) ::
                Init_int16 (Int.repr 9199) :: Init_int16 (Int.repr 9202) ::
                Init_int16 (Int.repr 9206) :: Init_int16 (Int.repr 9209) ::
                Init_int16 (Int.repr 9212) :: Init_int16 (Int.repr 9216) ::
                Init_int16 (Int.repr 9219) :: Init_int16 (Int.repr 9222) ::
                Init_int16 (Int.repr 9225) :: Init_int16 (Int.repr 9229) ::
                Init_int16 (Int.repr 9232) :: Init_int16 (Int.repr 9235) ::
                Init_int16 (Int.repr 9239) :: Init_int16 (Int.repr 9242) ::
                Init_int16 (Int.repr 9245) :: Init_int16 (Int.repr 9249) ::
                Init_int16 (Int.repr 9252) :: Init_int16 (Int.repr 9255) ::
                Init_int16 (Int.repr 9259) :: Init_int16 (Int.repr 9262) ::
                Init_int16 (Int.repr 9265) :: Init_int16 (Int.repr 9268) ::
                Init_int16 (Int.repr 9272) :: Init_int16 (Int.repr 9275) ::
                Init_int16 (Int.repr 9278) :: Init_int16 (Int.repr 9282) ::
                Init_int16 (Int.repr 9285) :: Init_int16 (Int.repr 9288) ::
                Init_int16 (Int.repr 9291) :: Init_int16 (Int.repr 9295) ::
                Init_int16 (Int.repr 9298) :: Init_int16 (Int.repr 9301) ::
                Init_int16 (Int.repr 9305) :: Init_int16 (Int.repr 9308) ::
                Init_int16 (Int.repr 9311) :: Init_int16 (Int.repr 9315) ::
                Init_int16 (Int.repr 9318) :: Init_int16 (Int.repr 9321) ::
                Init_int16 (Int.repr 9324) :: Init_int16 (Int.repr 9328) ::
                Init_int16 (Int.repr 9331) :: Init_int16 (Int.repr 9334) ::
                Init_int16 (Int.repr 9338) :: Init_int16 (Int.repr 9341) ::
                Init_int16 (Int.repr 9344) :: Init_int16 (Int.repr 9347) ::
                Init_int16 (Int.repr 9351) :: Init_int16 (Int.repr 9354) ::
                Init_int16 (Int.repr 9357) :: Init_int16 (Int.repr 9361) ::
                Init_int16 (Int.repr 9364) :: Init_int16 (Int.repr 9367) ::
                Init_int16 (Int.repr 9370) :: Init_int16 (Int.repr 9374) ::
                Init_int16 (Int.repr 9377) :: Init_int16 (Int.repr 9380) ::
                Init_int16 (Int.repr 9384) :: Init_int16 (Int.repr 9387) ::
                Init_int16 (Int.repr 9390) :: Init_int16 (Int.repr 9393) ::
                Init_int16 (Int.repr 9397) :: Init_int16 (Int.repr 9400) ::
                Init_int16 (Int.repr 9403) :: Init_int16 (Int.repr 9406) ::
                Init_int16 (Int.repr 9410) :: Init_int16 (Int.repr 9413) ::
                Init_int16 (Int.repr 9416) :: Init_int16 (Int.repr 9420) ::
                Init_int16 (Int.repr 9423) :: Init_int16 (Int.repr 9426) ::
                Init_int16 (Int.repr 9429) :: Init_int16 (Int.repr 9433) ::
                Init_int16 (Int.repr 9436) :: Init_int16 (Int.repr 9439) ::
                Init_int16 (Int.repr 9442) :: Init_int16 (Int.repr 9446) ::
                Init_int16 (Int.repr 9449) :: Init_int16 (Int.repr 9452) ::
                Init_int16 (Int.repr 9456) :: Init_int16 (Int.repr 9459) ::
                Init_int16 (Int.repr 9462) :: Init_int16 (Int.repr 9465) ::
                Init_int16 (Int.repr 9469) :: Init_int16 (Int.repr 9472) ::
                Init_int16 (Int.repr 9475) :: Init_int16 (Int.repr 9478) ::
                Init_int16 (Int.repr 9482) :: Init_int16 (Int.repr 9485) ::
                Init_int16 (Int.repr 9488) :: Init_int16 (Int.repr 9491) ::
                Init_int16 (Int.repr 9495) :: Init_int16 (Int.repr 9498) ::
                Init_int16 (Int.repr 9501) :: Init_int16 (Int.repr 9504) ::
                Init_int16 (Int.repr 9508) :: Init_int16 (Int.repr 9511) ::
                Init_int16 (Int.repr 9514) :: Init_int16 (Int.repr 9517) ::
                Init_int16 (Int.repr 9521) :: Init_int16 (Int.repr 9524) ::
                Init_int16 (Int.repr 9527) :: Init_int16 (Int.repr 9531) ::
                Init_int16 (Int.repr 9534) :: Init_int16 (Int.repr 9537) ::
                Init_int16 (Int.repr 9540) :: Init_int16 (Int.repr 9544) ::
                Init_int16 (Int.repr 9547) :: Init_int16 (Int.repr 9550) ::
                Init_int16 (Int.repr 9553) :: Init_int16 (Int.repr 9557) ::
                Init_int16 (Int.repr 9560) :: Init_int16 (Int.repr 9563) ::
                Init_int16 (Int.repr 9566) :: Init_int16 (Int.repr 9570) ::
                Init_int16 (Int.repr 9573) :: Init_int16 (Int.repr 9576) ::
                Init_int16 (Int.repr 9579) :: Init_int16 (Int.repr 9582) ::
                Init_int16 (Int.repr 9586) :: Init_int16 (Int.repr 9589) ::
                Init_int16 (Int.repr 9592) :: Init_int16 (Int.repr 9595) ::
                Init_int16 (Int.repr 9599) :: Init_int16 (Int.repr 9602) ::
                Init_int16 (Int.repr 9605) :: Init_int16 (Int.repr 9608) ::
                Init_int16 (Int.repr 9612) :: Init_int16 (Int.repr 9615) ::
                Init_int16 (Int.repr 9618) :: Init_int16 (Int.repr 9621) ::
                Init_int16 (Int.repr 9625) :: Init_int16 (Int.repr 9628) ::
                Init_int16 (Int.repr 9631) :: Init_int16 (Int.repr 9634) ::
                Init_int16 (Int.repr 9638) :: Init_int16 (Int.repr 9641) ::
                Init_int16 (Int.repr 9644) :: Init_int16 (Int.repr 9647) ::
                Init_int16 (Int.repr 9650) :: Init_int16 (Int.repr 9654) ::
                Init_int16 (Int.repr 9657) :: Init_int16 (Int.repr 9660) ::
                Init_int16 (Int.repr 9663) :: Init_int16 (Int.repr 9667) ::
                Init_int16 (Int.repr 9670) :: Init_int16 (Int.repr 9673) ::
                Init_int16 (Int.repr 9676) :: Init_int16 (Int.repr 9680) ::
                Init_int16 (Int.repr 9683) :: Init_int16 (Int.repr 9686) ::
                Init_int16 (Int.repr 9689) :: Init_int16 (Int.repr 9692) ::
                Init_int16 (Int.repr 9696) :: Init_int16 (Int.repr 9699) ::
                Init_int16 (Int.repr 9702) :: Init_int16 (Int.repr 9705) ::
                Init_int16 (Int.repr 9709) :: Init_int16 (Int.repr 9712) ::
                Init_int16 (Int.repr 9715) :: Init_int16 (Int.repr 9718) ::
                Init_int16 (Int.repr 9721) :: Init_int16 (Int.repr 9725) ::
                Init_int16 (Int.repr 9728) :: Init_int16 (Int.repr 9731) ::
                Init_int16 (Int.repr 9734) :: Init_int16 (Int.repr 9738) ::
                Init_int16 (Int.repr 9741) :: Init_int16 (Int.repr 9744) ::
                Init_int16 (Int.repr 9747) :: Init_int16 (Int.repr 9750) ::
                Init_int16 (Int.repr 9754) :: Init_int16 (Int.repr 9757) ::
                Init_int16 (Int.repr 9760) :: Init_int16 (Int.repr 9763) ::
                Init_int16 (Int.repr 9766) :: Init_int16 (Int.repr 9770) ::
                Init_int16 (Int.repr 9773) :: Init_int16 (Int.repr 9776) ::
                Init_int16 (Int.repr 9779) :: Init_int16 (Int.repr 9783) ::
                Init_int16 (Int.repr 9786) :: Init_int16 (Int.repr 9789) ::
                Init_int16 (Int.repr 9792) :: Init_int16 (Int.repr 9795) ::
                Init_int16 (Int.repr 9799) :: Init_int16 (Int.repr 9802) ::
                Init_int16 (Int.repr 9805) :: Init_int16 (Int.repr 9808) ::
                Init_int16 (Int.repr 9811) :: Init_int16 (Int.repr 9815) ::
                Init_int16 (Int.repr 9818) :: Init_int16 (Int.repr 9821) ::
                Init_int16 (Int.repr 9824) :: Init_int16 (Int.repr 9827) ::
                Init_int16 (Int.repr 9831) :: Init_int16 (Int.repr 9834) ::
                Init_int16 (Int.repr 9837) :: Init_int16 (Int.repr 9840) ::
                Init_int16 (Int.repr 9843) :: Init_int16 (Int.repr 9847) ::
                Init_int16 (Int.repr 9850) :: Init_int16 (Int.repr 9853) ::
                Init_int16 (Int.repr 9856) :: Init_int16 (Int.repr 9859) ::
                Init_int16 (Int.repr 9863) :: Init_int16 (Int.repr 9866) ::
                Init_int16 (Int.repr 9869) :: Init_int16 (Int.repr 9872) ::
                Init_int16 (Int.repr 9875) :: Init_int16 (Int.repr 9879) ::
                Init_int16 (Int.repr 9882) :: Init_int16 (Int.repr 9885) ::
                Init_int16 (Int.repr 9888) :: Init_int16 (Int.repr 9891) ::
                Init_int16 (Int.repr 9894) :: Init_int16 (Int.repr 9898) ::
                Init_int16 (Int.repr 9901) :: Init_int16 (Int.repr 9904) ::
                Init_int16 (Int.repr 9907) :: Init_int16 (Int.repr 9910) ::
                Init_int16 (Int.repr 9914) :: Init_int16 (Int.repr 9917) ::
                Init_int16 (Int.repr 9920) :: Init_int16 (Int.repr 9923) ::
                Init_int16 (Int.repr 9926) :: Init_int16 (Int.repr 9930) ::
                Init_int16 (Int.repr 9933) :: Init_int16 (Int.repr 9936) ::
                Init_int16 (Int.repr 9939) :: Init_int16 (Int.repr 9942) ::
                Init_int16 (Int.repr 9945) :: Init_int16 (Int.repr 9949) ::
                Init_int16 (Int.repr 9952) :: Init_int16 (Int.repr 9955) ::
                Init_int16 (Int.repr 9958) :: Init_int16 (Int.repr 9961) ::
                Init_int16 (Int.repr 9964) :: Init_int16 (Int.repr 9968) ::
                Init_int16 (Int.repr 9971) :: Init_int16 (Int.repr 9974) ::
                Init_int16 (Int.repr 9977) :: Init_int16 (Int.repr 9980) ::
                Init_int16 (Int.repr 9984) :: Init_int16 (Int.repr 9987) ::
                Init_int16 (Int.repr 9990) :: Init_int16 (Int.repr 9993) ::
                Init_int16 (Int.repr 9996) :: Init_int16 (Int.repr 9999) ::
                Init_int16 (Int.repr 10003) :: Init_int16 (Int.repr 10006) ::
                Init_int16 (Int.repr 10009) :: Init_int16 (Int.repr 10012) ::
                Init_int16 (Int.repr 10015) :: Init_int16 (Int.repr 10018) ::
                Init_int16 (Int.repr 10022) :: Init_int16 (Int.repr 10025) ::
                Init_int16 (Int.repr 10028) :: Init_int16 (Int.repr 10031) ::
                Init_int16 (Int.repr 10034) :: Init_int16 (Int.repr 10037) ::
                Init_int16 (Int.repr 10041) :: Init_int16 (Int.repr 10044) ::
                Init_int16 (Int.repr 10047) :: Init_int16 (Int.repr 10050) ::
                Init_int16 (Int.repr 10053) :: Init_int16 (Int.repr 10056) ::
                Init_int16 (Int.repr 10059) :: Init_int16 (Int.repr 10063) ::
                Init_int16 (Int.repr 10066) :: Init_int16 (Int.repr 10069) ::
                Init_int16 (Int.repr 10072) :: Init_int16 (Int.repr 10075) ::
                Init_int16 (Int.repr 10078) :: Init_int16 (Int.repr 10082) ::
                Init_int16 (Int.repr 10085) :: Init_int16 (Int.repr 10088) ::
                Init_int16 (Int.repr 10091) :: Init_int16 (Int.repr 10094) ::
                Init_int16 (Int.repr 10097) :: Init_int16 (Int.repr 10100) ::
                Init_int16 (Int.repr 10104) :: Init_int16 (Int.repr 10107) ::
                Init_int16 (Int.repr 10110) :: Init_int16 (Int.repr 10113) ::
                Init_int16 (Int.repr 10116) :: Init_int16 (Int.repr 10119) ::
                Init_int16 (Int.repr 10122) :: Init_int16 (Int.repr 10126) ::
                Init_int16 (Int.repr 10129) :: Init_int16 (Int.repr 10132) ::
                Init_int16 (Int.repr 10135) :: Init_int16 (Int.repr 10138) ::
                Init_int16 (Int.repr 10141) :: Init_int16 (Int.repr 10144) ::
                Init_int16 (Int.repr 10148) :: Init_int16 (Int.repr 10151) ::
                Init_int16 (Int.repr 10154) :: Init_int16 (Int.repr 10157) ::
                Init_int16 (Int.repr 10160) :: Init_int16 (Int.repr 10163) ::
                Init_int16 (Int.repr 10166) :: Init_int16 (Int.repr 10170) ::
                Init_int16 (Int.repr 10173) :: Init_int16 (Int.repr 10176) ::
                Init_int16 (Int.repr 10179) :: Init_int16 (Int.repr 10182) ::
                Init_int16 (Int.repr 10185) :: Init_int16 (Int.repr 10188) ::
                Init_int16 (Int.repr 10192) :: Init_int16 (Int.repr 10195) ::
                Init_int16 (Int.repr 10198) :: Init_int16 (Int.repr 10201) ::
                Init_int16 (Int.repr 10204) :: Init_int16 (Int.repr 10207) ::
                Init_int16 (Int.repr 10210) :: Init_int16 (Int.repr 10213) ::
                Init_int16 (Int.repr 10217) :: Init_int16 (Int.repr 10220) ::
                Init_int16 (Int.repr 10223) :: Init_int16 (Int.repr 10226) ::
                Init_int16 (Int.repr 10229) :: Init_int16 (Int.repr 10232) ::
                Init_int16 (Int.repr 10235) :: Init_int16 (Int.repr 10238) ::
                Init_int16 (Int.repr 10242) :: Init_int16 (Int.repr 10245) ::
                Init_int16 (Int.repr 10248) :: Init_int16 (Int.repr 10251) ::
                Init_int16 (Int.repr 10254) :: Init_int16 (Int.repr 10257) ::
                Init_int16 (Int.repr 10260) :: Init_int16 (Int.repr 10263) ::
                Init_int16 (Int.repr 10267) :: Init_int16 (Int.repr 10270) ::
                Init_int16 (Int.repr 10273) :: Init_int16 (Int.repr 10276) ::
                Init_int16 (Int.repr 10279) :: Init_int16 (Int.repr 10282) ::
                Init_int16 (Int.repr 10285) :: Init_int16 (Int.repr 10288) ::
                Init_int16 (Int.repr 10291) :: Init_int16 (Int.repr 10295) ::
                Init_int16 (Int.repr 10298) :: Init_int16 (Int.repr 10301) ::
                Init_int16 (Int.repr 10304) :: Init_int16 (Int.repr 10307) ::
                Init_int16 (Int.repr 10310) :: Init_int16 (Int.repr 10313) ::
                Init_int16 (Int.repr 10316) :: Init_int16 (Int.repr 10319) ::
                Init_int16 (Int.repr 10323) :: Init_int16 (Int.repr 10326) ::
                Init_int16 (Int.repr 10329) :: Init_int16 (Int.repr 10332) ::
                Init_int16 (Int.repr 10335) :: Init_int16 (Int.repr 10338) ::
                Init_int16 (Int.repr 10341) :: Init_int16 (Int.repr 10344) ::
                Init_int16 (Int.repr 10347) :: Init_int16 (Int.repr 10350) ::
                Init_int16 (Int.repr 10354) :: Init_int16 (Int.repr 10357) ::
                Init_int16 (Int.repr 10360) :: Init_int16 (Int.repr 10363) ::
                Init_int16 (Int.repr 10366) :: Init_int16 (Int.repr 10369) ::
                Init_int16 (Int.repr 10372) :: Init_int16 (Int.repr 10375) ::
                Init_int16 (Int.repr 10378) :: Init_int16 (Int.repr 10381) ::
                Init_int16 (Int.repr 10385) :: Init_int16 (Int.repr 10388) ::
                Init_int16 (Int.repr 10391) :: Init_int16 (Int.repr 10394) ::
                Init_int16 (Int.repr 10397) :: Init_int16 (Int.repr 10400) ::
                Init_int16 (Int.repr 10403) :: Init_int16 (Int.repr 10406) ::
                Init_int16 (Int.repr 10409) :: Init_int16 (Int.repr 10412) ::
                Init_int16 (Int.repr 10415) :: Init_int16 (Int.repr 10419) ::
                Init_int16 (Int.repr 10422) :: Init_int16 (Int.repr 10425) ::
                Init_int16 (Int.repr 10428) :: Init_int16 (Int.repr 10431) ::
                Init_int16 (Int.repr 10434) :: Init_int16 (Int.repr 10437) ::
                Init_int16 (Int.repr 10440) :: Init_int16 (Int.repr 10443) ::
                Init_int16 (Int.repr 10446) :: Init_int16 (Int.repr 10449) ::
                Init_int16 (Int.repr 10452) :: Init_int16 (Int.repr 10456) ::
                Init_int16 (Int.repr 10459) :: Init_int16 (Int.repr 10462) ::
                Init_int16 (Int.repr 10465) :: Init_int16 (Int.repr 10468) ::
                Init_int16 (Int.repr 10471) :: Init_int16 (Int.repr 10474) ::
                Init_int16 (Int.repr 10477) :: Init_int16 (Int.repr 10480) ::
                Init_int16 (Int.repr 10483) :: Init_int16 (Int.repr 10486) ::
                Init_int16 (Int.repr 10489) :: Init_int16 (Int.repr 10492) ::
                Init_int16 (Int.repr 10496) :: Init_int16 (Int.repr 10499) ::
                Init_int16 (Int.repr 10502) :: Init_int16 (Int.repr 10505) ::
                Init_int16 (Int.repr 10508) :: Init_int16 (Int.repr 10511) ::
                Init_int16 (Int.repr 10514) :: Init_int16 (Int.repr 10517) ::
                Init_int16 (Int.repr 10520) :: Init_int16 (Int.repr 10523) ::
                Init_int16 (Int.repr 10526) :: Init_int16 (Int.repr 10529) ::
                Init_int16 (Int.repr 10532) :: Init_int16 (Int.repr 10535) ::
                Init_int16 (Int.repr 10538) :: Init_int16 (Int.repr 10542) ::
                Init_int16 (Int.repr 10545) :: Init_int16 (Int.repr 10548) ::
                Init_int16 (Int.repr 10551) :: Init_int16 (Int.repr 10554) ::
                Init_int16 (Int.repr 10557) :: Init_int16 (Int.repr 10560) ::
                Init_int16 (Int.repr 10563) :: Init_int16 (Int.repr 10566) ::
                Init_int16 (Int.repr 10569) :: Init_int16 (Int.repr 10572) ::
                Init_int16 (Int.repr 10575) :: Init_int16 (Int.repr 10578) ::
                Init_int16 (Int.repr 10581) :: Init_int16 (Int.repr 10584) ::
                Init_int16 (Int.repr 10587) :: Init_int16 (Int.repr 10590) ::
                Init_int16 (Int.repr 10593) :: Init_int16 (Int.repr 10597) ::
                Init_int16 (Int.repr 10600) :: Init_int16 (Int.repr 10603) ::
                Init_int16 (Int.repr 10606) :: Init_int16 (Int.repr 10609) ::
                Init_int16 (Int.repr 10612) :: Init_int16 (Int.repr 10615) ::
                Init_int16 (Int.repr 10618) :: Init_int16 (Int.repr 10621) ::
                Init_int16 (Int.repr 10624) :: Init_int16 (Int.repr 10627) ::
                Init_int16 (Int.repr 10630) :: Init_int16 (Int.repr 10633) ::
                Init_int16 (Int.repr 10636) :: Init_int16 (Int.repr 10639) ::
                Init_int16 (Int.repr 10642) :: Init_int16 (Int.repr 10645) ::
                Init_int16 (Int.repr 10648) :: Init_int16 (Int.repr 10651) ::
                Init_int16 (Int.repr 10654) :: Init_int16 (Int.repr 10657) ::
                Init_int16 (Int.repr 10660) :: Init_int16 (Int.repr 10663) ::
                Init_int16 (Int.repr 10667) :: Init_int16 (Int.repr 10670) ::
                Init_int16 (Int.repr 10673) :: Init_int16 (Int.repr 10676) ::
                Init_int16 (Int.repr 10679) :: Init_int16 (Int.repr 10682) ::
                Init_int16 (Int.repr 10685) :: Init_int16 (Int.repr 10688) ::
                Init_int16 (Int.repr 10691) :: Init_int16 (Int.repr 10694) ::
                Init_int16 (Int.repr 10697) :: Init_int16 (Int.repr 10700) ::
                Init_int16 (Int.repr 10703) :: Init_int16 (Int.repr 10706) ::
                Init_int16 (Int.repr 10709) :: Init_int16 (Int.repr 10712) ::
                Init_int16 (Int.repr 10715) :: Init_int16 (Int.repr 10718) ::
                Init_int16 (Int.repr 10721) :: Init_int16 (Int.repr 10724) ::
                Init_int16 (Int.repr 10727) :: Init_int16 (Int.repr 10730) ::
                Init_int16 (Int.repr 10733) :: Init_int16 (Int.repr 10736) ::
                Init_int16 (Int.repr 10739) :: Init_int16 (Int.repr 10742) ::
                Init_int16 (Int.repr 10745) :: Init_int16 (Int.repr 10748) ::
                Init_int16 (Int.repr 10751) :: Init_int16 (Int.repr 10754) ::
                Init_int16 (Int.repr 10757) :: Init_int16 (Int.repr 10760) ::
                Init_int16 (Int.repr 10763) :: Init_int16 (Int.repr 10766) ::
                Init_int16 (Int.repr 10769) :: Init_int16 (Int.repr 10772) ::
                Init_int16 (Int.repr 10775) :: Init_int16 (Int.repr 10778) ::
                Init_int16 (Int.repr 10781) :: Init_int16 (Int.repr 10784) ::
                Init_int16 (Int.repr 10787) :: Init_int16 (Int.repr 10790) ::
                Init_int16 (Int.repr 10793) :: Init_int16 (Int.repr 10796) ::
                Init_int16 (Int.repr 10799) :: Init_int16 (Int.repr 10802) ::
                Init_int16 (Int.repr 10806) :: Init_int16 (Int.repr 10809) ::
                Init_int16 (Int.repr 10812) :: Init_int16 (Int.repr 10815) ::
                Init_int16 (Int.repr 10818) :: Init_int16 (Int.repr 10821) ::
                Init_int16 (Int.repr 10824) :: Init_int16 (Int.repr 10827) ::
                Init_int16 (Int.repr 10830) :: Init_int16 (Int.repr 10833) ::
                Init_int16 (Int.repr 10836) :: Init_int16 (Int.repr 10839) ::
                Init_int16 (Int.repr 10842) :: Init_int16 (Int.repr 10845) ::
                Init_int16 (Int.repr 10848) :: Init_int16 (Int.repr 10851) ::
                Init_int16 (Int.repr 10854) :: Init_int16 (Int.repr 10857) ::
                Init_int16 (Int.repr 10860) :: Init_int16 (Int.repr 10863) ::
                Init_int16 (Int.repr 10866) :: Init_int16 (Int.repr 10869) ::
                Init_int16 (Int.repr 10871) :: Init_int16 (Int.repr 10874) ::
                Init_int16 (Int.repr 10877) :: Init_int16 (Int.repr 10880) ::
                Init_int16 (Int.repr 10883) :: Init_int16 (Int.repr 10886) ::
                Init_int16 (Int.repr 10889) :: Init_int16 (Int.repr 10892) ::
                Init_int16 (Int.repr 10895) :: Init_int16 (Int.repr 10898) ::
                Init_int16 (Int.repr 10901) :: Init_int16 (Int.repr 10904) ::
                Init_int16 (Int.repr 10907) :: Init_int16 (Int.repr 10910) ::
                Init_int16 (Int.repr 10913) :: Init_int16 (Int.repr 10916) ::
                Init_int16 (Int.repr 10919) :: Init_int16 (Int.repr 10922) ::
                Init_int16 (Int.repr 10925) :: Init_int16 (Int.repr 10928) ::
                Init_int16 (Int.repr 10931) :: Init_int16 (Int.repr 10934) ::
                Init_int16 (Int.repr 10937) :: Init_int16 (Int.repr 10940) ::
                Init_int16 (Int.repr 10943) :: Init_int16 (Int.repr 10946) ::
                Init_int16 (Int.repr 10949) :: Init_int16 (Int.repr 10952) ::
                Init_int16 (Int.repr 10955) :: Init_int16 (Int.repr 10958) ::
                Init_int16 (Int.repr 10961) :: Init_int16 (Int.repr 10964) ::
                Init_int16 (Int.repr 10967) :: Init_int16 (Int.repr 10970) ::
                Init_int16 (Int.repr 10973) :: Init_int16 (Int.repr 10976) ::
                Init_int16 (Int.repr 10979) :: Init_int16 (Int.repr 10982) ::
                Init_int16 (Int.repr 10985) :: Init_int16 (Int.repr 10988) ::
                Init_int16 (Int.repr 10991) :: Init_int16 (Int.repr 10994) ::
                Init_int16 (Int.repr 10997) :: Init_int16 (Int.repr 11000) ::
                Init_int16 (Int.repr 11003) :: Init_int16 (Int.repr 11005) ::
                Init_int16 (Int.repr 11008) :: Init_int16 (Int.repr 11011) ::
                Init_int16 (Int.repr 11014) :: Init_int16 (Int.repr 11017) ::
                Init_int16 (Int.repr 11020) :: Init_int16 (Int.repr 11023) ::
                Init_int16 (Int.repr 11026) :: Init_int16 (Int.repr 11029) ::
                Init_int16 (Int.repr 11032) :: Init_int16 (Int.repr 11035) ::
                Init_int16 (Int.repr 11038) :: Init_int16 (Int.repr 11041) ::
                Init_int16 (Int.repr 11044) :: Init_int16 (Int.repr 11047) ::
                Init_int16 (Int.repr 11050) :: Init_int16 (Int.repr 11053) ::
                Init_int16 (Int.repr 11056) :: Init_int16 (Int.repr 11059) ::
                Init_int16 (Int.repr 11062) :: Init_int16 (Int.repr 11065) ::
                Init_int16 (Int.repr 11068) :: Init_int16 (Int.repr 11071) ::
                Init_int16 (Int.repr 11073) :: Init_int16 (Int.repr 11076) ::
                Init_int16 (Int.repr 11079) :: Init_int16 (Int.repr 11082) ::
                Init_int16 (Int.repr 11085) :: Init_int16 (Int.repr 11088) ::
                Init_int16 (Int.repr 11091) :: Init_int16 (Int.repr 11094) ::
                Init_int16 (Int.repr 11097) :: Init_int16 (Int.repr 11100) ::
                Init_int16 (Int.repr 11103) :: Init_int16 (Int.repr 11106) ::
                Init_int16 (Int.repr 11109) :: Init_int16 (Int.repr 11112) ::
                Init_int16 (Int.repr 11115) :: Init_int16 (Int.repr 11118) ::
                Init_int16 (Int.repr 11121) :: Init_int16 (Int.repr 11123) ::
                Init_int16 (Int.repr 11126) :: Init_int16 (Int.repr 11129) ::
                Init_int16 (Int.repr 11132) :: Init_int16 (Int.repr 11135) ::
                Init_int16 (Int.repr 11138) :: Init_int16 (Int.repr 11141) ::
                Init_int16 (Int.repr 11144) :: Init_int16 (Int.repr 11147) ::
                Init_int16 (Int.repr 11150) :: Init_int16 (Int.repr 11153) ::
                Init_int16 (Int.repr 11156) :: Init_int16 (Int.repr 11159) ::
                Init_int16 (Int.repr 11162) :: Init_int16 (Int.repr 11165) ::
                Init_int16 (Int.repr 11167) :: Init_int16 (Int.repr 11170) ::
                Init_int16 (Int.repr 11173) :: Init_int16 (Int.repr 11176) ::
                Init_int16 (Int.repr 11179) :: Init_int16 (Int.repr 11182) ::
                Init_int16 (Int.repr 11185) :: Init_int16 (Int.repr 11188) ::
                Init_int16 (Int.repr 11191) :: Init_int16 (Int.repr 11194) ::
                Init_int16 (Int.repr 11197) :: Init_int16 (Int.repr 11200) ::
                Init_int16 (Int.repr 11203) :: Init_int16 (Int.repr 11205) ::
                Init_int16 (Int.repr 11208) :: Init_int16 (Int.repr 11211) ::
                Init_int16 (Int.repr 11214) :: Init_int16 (Int.repr 11217) ::
                Init_int16 (Int.repr 11220) :: Init_int16 (Int.repr 11223) ::
                Init_int16 (Int.repr 11226) :: Init_int16 (Int.repr 11229) ::
                Init_int16 (Int.repr 11232) :: Init_int16 (Int.repr 11235) ::
                Init_int16 (Int.repr 11238) :: Init_int16 (Int.repr 11240) ::
                Init_int16 (Int.repr 11243) :: Init_int16 (Int.repr 11246) ::
                Init_int16 (Int.repr 11249) :: Init_int16 (Int.repr 11252) ::
                Init_int16 (Int.repr 11255) :: Init_int16 (Int.repr 11258) ::
                Init_int16 (Int.repr 11261) :: Init_int16 (Int.repr 11264) ::
                Init_int16 (Int.repr 11267) :: Init_int16 (Int.repr 11269) ::
                Init_int16 (Int.repr 11272) :: Init_int16 (Int.repr 11275) ::
                Init_int16 (Int.repr 11278) :: Init_int16 (Int.repr 11281) ::
                Init_int16 (Int.repr 11284) :: Init_int16 (Int.repr 11287) ::
                Init_int16 (Int.repr 11290) :: Init_int16 (Int.repr 11293) ::
                Init_int16 (Int.repr 11296) :: Init_int16 (Int.repr 11298) ::
                Init_int16 (Int.repr 11301) :: Init_int16 (Int.repr 11304) ::
                Init_int16 (Int.repr 11307) :: Init_int16 (Int.repr 11310) ::
                Init_int16 (Int.repr 11313) :: Init_int16 (Int.repr 11316) ::
                Init_int16 (Int.repr 11319) :: Init_int16 (Int.repr 11322) ::
                Init_int16 (Int.repr 11325) :: Init_int16 (Int.repr 11327) ::
                Init_int16 (Int.repr 11330) :: Init_int16 (Int.repr 11333) ::
                Init_int16 (Int.repr 11336) :: Init_int16 (Int.repr 11339) ::
                Init_int16 (Int.repr 11342) :: Init_int16 (Int.repr 11345) ::
                Init_int16 (Int.repr 11348) :: Init_int16 (Int.repr 11351) ::
                Init_int16 (Int.repr 11353) :: Init_int16 (Int.repr 11356) ::
                Init_int16 (Int.repr 11359) :: Init_int16 (Int.repr 11362) ::
                Init_int16 (Int.repr 11365) :: Init_int16 (Int.repr 11368) ::
                Init_int16 (Int.repr 11371) :: Init_int16 (Int.repr 11374) ::
                Init_int16 (Int.repr 11376) :: Init_int16 (Int.repr 11379) ::
                Init_int16 (Int.repr 11382) :: Init_int16 (Int.repr 11385) ::
                Init_int16 (Int.repr 11388) :: Init_int16 (Int.repr 11391) ::
                Init_int16 (Int.repr 11394) :: Init_int16 (Int.repr 11397) ::
                Init_int16 (Int.repr 11399) :: Init_int16 (Int.repr 11402) ::
                Init_int16 (Int.repr 11405) :: Init_int16 (Int.repr 11408) ::
                Init_int16 (Int.repr 11411) :: Init_int16 (Int.repr 11414) ::
                Init_int16 (Int.repr 11417) :: Init_int16 (Int.repr 11420) ::
                Init_int16 (Int.repr 11422) :: Init_int16 (Int.repr 11425) ::
                Init_int16 (Int.repr 11428) :: Init_int16 (Int.repr 11431) ::
                Init_int16 (Int.repr 11434) :: Init_int16 (Int.repr 11437) ::
                Init_int16 (Int.repr 11440) :: Init_int16 (Int.repr 11442) ::
                Init_int16 (Int.repr 11445) :: Init_int16 (Int.repr 11448) ::
                Init_int16 (Int.repr 11451) :: Init_int16 (Int.repr 11454) ::
                Init_int16 (Int.repr 11457) :: Init_int16 (Int.repr 11460) ::
                Init_int16 (Int.repr 11463) :: Init_int16 (Int.repr 11465) ::
                Init_int16 (Int.repr 11468) :: Init_int16 (Int.repr 11471) ::
                Init_int16 (Int.repr 11474) :: Init_int16 (Int.repr 11477) ::
                Init_int16 (Int.repr 11480) :: Init_int16 (Int.repr 11482) ::
                Init_int16 (Int.repr 11485) :: Init_int16 (Int.repr 11488) ::
                Init_int16 (Int.repr 11491) :: Init_int16 (Int.repr 11494) ::
                Init_int16 (Int.repr 11497) :: Init_int16 (Int.repr 11500) ::
                Init_int16 (Int.repr 11502) :: Init_int16 (Int.repr 11505) ::
                Init_int16 (Int.repr 11508) :: Init_int16 (Int.repr 11511) ::
                Init_int16 (Int.repr 11514) :: Init_int16 (Int.repr 11517) ::
                Init_int16 (Int.repr 11520) :: Init_int16 (Int.repr 11522) ::
                Init_int16 (Int.repr 11525) :: Init_int16 (Int.repr 11528) ::
                Init_int16 (Int.repr 11531) :: Init_int16 (Int.repr 11534) ::
                Init_int16 (Int.repr 11537) :: Init_int16 (Int.repr 11539) ::
                Init_int16 (Int.repr 11542) :: Init_int16 (Int.repr 11545) ::
                Init_int16 (Int.repr 11548) :: Init_int16 (Int.repr 11551) ::
                Init_int16 (Int.repr 11554) :: Init_int16 (Int.repr 11556) ::
                Init_int16 (Int.repr 11559) :: Init_int16 (Int.repr 11562) ::
                Init_int16 (Int.repr 11565) :: Init_int16 (Int.repr 11568) ::
                Init_int16 (Int.repr 11571) :: Init_int16 (Int.repr 11573) ::
                Init_int16 (Int.repr 11576) :: Init_int16 (Int.repr 11579) ::
                Init_int16 (Int.repr 11582) :: Init_int16 (Int.repr 11585) ::
                Init_int16 (Int.repr 11588) :: Init_int16 (Int.repr 11590) ::
                Init_int16 (Int.repr 11593) :: Init_int16 (Int.repr 11596) ::
                Init_int16 (Int.repr 11599) :: Init_int16 (Int.repr 11602) ::
                Init_int16 (Int.repr 11605) :: Init_int16 (Int.repr 11607) ::
                Init_int16 (Int.repr 11610) :: Init_int16 (Int.repr 11613) ::
                Init_int16 (Int.repr 11616) :: Init_int16 (Int.repr 11619) ::
                Init_int16 (Int.repr 11621) :: Init_int16 (Int.repr 11624) ::
                Init_int16 (Int.repr 11627) :: Init_int16 (Int.repr 11630) ::
                Init_int16 (Int.repr 11633) :: Init_int16 (Int.repr 11636) ::
                Init_int16 (Int.repr 11638) :: Init_int16 (Int.repr 11641) ::
                Init_int16 (Int.repr 11644) :: Init_int16 (Int.repr 11647) ::
                Init_int16 (Int.repr 11650) :: Init_int16 (Int.repr 11652) ::
                Init_int16 (Int.repr 11655) :: Init_int16 (Int.repr 11658) ::
                Init_int16 (Int.repr 11661) :: Init_int16 (Int.repr 11664) ::
                Init_int16 (Int.repr 11666) :: Init_int16 (Int.repr 11669) ::
                Init_int16 (Int.repr 11672) :: Init_int16 (Int.repr 11675) ::
                Init_int16 (Int.repr 11678) :: Init_int16 (Int.repr 11681) ::
                Init_int16 (Int.repr 11683) :: Init_int16 (Int.repr 11686) ::
                Init_int16 (Int.repr 11689) :: Init_int16 (Int.repr 11692) ::
                Init_int16 (Int.repr 11695) :: Init_int16 (Int.repr 11697) ::
                Init_int16 (Int.repr 11700) :: Init_int16 (Int.repr 11703) ::
                Init_int16 (Int.repr 11706) :: Init_int16 (Int.repr 11709) ::
                Init_int16 (Int.repr 11711) :: Init_int16 (Int.repr 11714) ::
                Init_int16 (Int.repr 11717) :: Init_int16 (Int.repr 11720) ::
                Init_int16 (Int.repr 11723) :: Init_int16 (Int.repr 11725) ::
                Init_int16 (Int.repr 11728) :: Init_int16 (Int.repr 11731) ::
                Init_int16 (Int.repr 11734) :: Init_int16 (Int.repr 11736) ::
                Init_int16 (Int.repr 11739) :: Init_int16 (Int.repr 11742) ::
                Init_int16 (Int.repr 11745) :: Init_int16 (Int.repr 11748) ::
                Init_int16 (Int.repr 11750) :: Init_int16 (Int.repr 11753) ::
                Init_int16 (Int.repr 11756) :: Init_int16 (Int.repr 11759) ::
                Init_int16 (Int.repr 11762) :: Init_int16 (Int.repr 11764) ::
                Init_int16 (Int.repr 11767) :: Init_int16 (Int.repr 11770) ::
                Init_int16 (Int.repr 11773) :: Init_int16 (Int.repr 11775) ::
                Init_int16 (Int.repr 11778) :: Init_int16 (Int.repr 11781) ::
                Init_int16 (Int.repr 11784) :: Init_int16 (Int.repr 11787) ::
                Init_int16 (Int.repr 11789) :: Init_int16 (Int.repr 11792) ::
                Init_int16 (Int.repr 11795) :: Init_int16 (Int.repr 11798) ::
                Init_int16 (Int.repr 11800) :: Init_int16 (Int.repr 11803) ::
                Init_int16 (Int.repr 11806) :: Init_int16 (Int.repr 11809) ::
                Init_int16 (Int.repr 11812) :: Init_int16 (Int.repr 11814) ::
                Init_int16 (Int.repr 11817) :: Init_int16 (Int.repr 11820) ::
                Init_int16 (Int.repr 11823) :: Init_int16 (Int.repr 11825) ::
                Init_int16 (Int.repr 11828) :: Init_int16 (Int.repr 11831) ::
                Init_int16 (Int.repr 11834) :: Init_int16 (Int.repr 11837) ::
                Init_int16 (Int.repr 11839) :: Init_int16 (Int.repr 11842) ::
                Init_int16 (Int.repr 11845) :: Init_int16 (Int.repr 11848) ::
                Init_int16 (Int.repr 11850) :: Init_int16 (Int.repr 11853) ::
                Init_int16 (Int.repr 11856) :: Init_int16 (Int.repr 11859) ::
                Init_int16 (Int.repr 11861) :: Init_int16 (Int.repr 11864) ::
                Init_int16 (Int.repr 11867) :: Init_int16 (Int.repr 11870) ::
                Init_int16 (Int.repr 11872) :: Init_int16 (Int.repr 11875) ::
                Init_int16 (Int.repr 11878) :: Init_int16 (Int.repr 11881) ::
                Init_int16 (Int.repr 11883) :: Init_int16 (Int.repr 11886) ::
                Init_int16 (Int.repr 11889) :: Init_int16 (Int.repr 11892) ::
                Init_int16 (Int.repr 11894) :: Init_int16 (Int.repr 11897) ::
                Init_int16 (Int.repr 11900) :: Init_int16 (Int.repr 11903) ::
                Init_int16 (Int.repr 11905) :: Init_int16 (Int.repr 11908) ::
                Init_int16 (Int.repr 11911) :: Init_int16 (Int.repr 11914) ::
                Init_int16 (Int.repr 11916) :: Init_int16 (Int.repr 11919) ::
                Init_int16 (Int.repr 11922) :: Init_int16 (Int.repr 11925) ::
                Init_int16 (Int.repr 11927) :: Init_int16 (Int.repr 11930) ::
                Init_int16 (Int.repr 11933) :: Init_int16 (Int.repr 11936) ::
                Init_int16 (Int.repr 11938) :: Init_int16 (Int.repr 11941) ::
                Init_int16 (Int.repr 11944) :: Init_int16 (Int.repr 11947) ::
                Init_int16 (Int.repr 11949) :: Init_int16 (Int.repr 11952) ::
                Init_int16 (Int.repr 11955) :: Init_int16 (Int.repr 11958) ::
                Init_int16 (Int.repr 11960) :: Init_int16 (Int.repr 11963) ::
                Init_int16 (Int.repr 11966) :: Init_int16 (Int.repr 11968) ::
                Init_int16 (Int.repr 11971) :: Init_int16 (Int.repr 11974) ::
                Init_int16 (Int.repr 11977) :: Init_int16 (Int.repr 11979) ::
                Init_int16 (Int.repr 11982) :: Init_int16 (Int.repr 11985) ::
                Init_int16 (Int.repr 11988) :: Init_int16 (Int.repr 11990) ::
                Init_int16 (Int.repr 11993) :: Init_int16 (Int.repr 11996) ::
                Init_int16 (Int.repr 11998) :: Init_int16 (Int.repr 12001) ::
                Init_int16 (Int.repr 12004) :: Init_int16 (Int.repr 12007) ::
                Init_int16 (Int.repr 12009) :: Init_int16 (Int.repr 12012) ::
                Init_int16 (Int.repr 12015) :: Init_int16 (Int.repr 12017) ::
                Init_int16 (Int.repr 12020) :: Init_int16 (Int.repr 12023) ::
                Init_int16 (Int.repr 12026) :: Init_int16 (Int.repr 12028) ::
                Init_int16 (Int.repr 12031) :: Init_int16 (Int.repr 12034) ::
                Init_int16 (Int.repr 12037) :: Init_int16 (Int.repr 12039) ::
                Init_int16 (Int.repr 12042) :: Init_int16 (Int.repr 12045) ::
                Init_int16 (Int.repr 12047) :: Init_int16 (Int.repr 12050) ::
                Init_int16 (Int.repr 12053) :: Init_int16 (Int.repr 12055) ::
                Init_int16 (Int.repr 12058) :: Init_int16 (Int.repr 12061) ::
                Init_int16 (Int.repr 12064) :: Init_int16 (Int.repr 12066) ::
                Init_int16 (Int.repr 12069) :: Init_int16 (Int.repr 12072) ::
                Init_int16 (Int.repr 12074) :: Init_int16 (Int.repr 12077) ::
                Init_int16 (Int.repr 12080) :: Init_int16 (Int.repr 12083) ::
                Init_int16 (Int.repr 12085) :: Init_int16 (Int.repr 12088) ::
                Init_int16 (Int.repr 12091) :: Init_int16 (Int.repr 12093) ::
                Init_int16 (Int.repr 12096) :: Init_int16 (Int.repr 12099) ::
                Init_int16 (Int.repr 12101) :: Init_int16 (Int.repr 12104) ::
                Init_int16 (Int.repr 12107) :: Init_int16 (Int.repr 12110) ::
                Init_int16 (Int.repr 12112) :: Init_int16 (Int.repr 12115) ::
                Init_int16 (Int.repr 12118) :: Init_int16 (Int.repr 12120) ::
                Init_int16 (Int.repr 12123) :: Init_int16 (Int.repr 12126) ::
                Init_int16 (Int.repr 12128) :: Init_int16 (Int.repr 12131) ::
                Init_int16 (Int.repr 12134) :: Init_int16 (Int.repr 12136) ::
                Init_int16 (Int.repr 12139) :: Init_int16 (Int.repr 12142) ::
                Init_int16 (Int.repr 12144) :: Init_int16 (Int.repr 12147) ::
                Init_int16 (Int.repr 12150) :: Init_int16 (Int.repr 12153) ::
                Init_int16 (Int.repr 12155) :: Init_int16 (Int.repr 12158) ::
                Init_int16 (Int.repr 12161) :: Init_int16 (Int.repr 12163) ::
                Init_int16 (Int.repr 12166) :: Init_int16 (Int.repr 12169) ::
                Init_int16 (Int.repr 12171) :: Init_int16 (Int.repr 12174) ::
                Init_int16 (Int.repr 12177) :: Init_int16 (Int.repr 12179) ::
                Init_int16 (Int.repr 12182) :: Init_int16 (Int.repr 12185) ::
                Init_int16 (Int.repr 12187) :: Init_int16 (Int.repr 12190) ::
                Init_int16 (Int.repr 12193) :: Init_int16 (Int.repr 12195) ::
                Init_int16 (Int.repr 12198) :: Init_int16 (Int.repr 12201) ::
                Init_int16 (Int.repr 12203) :: Init_int16 (Int.repr 12206) ::
                Init_int16 (Int.repr 12209) :: Init_int16 (Int.repr 12211) ::
                Init_int16 (Int.repr 12214) :: Init_int16 (Int.repr 12217) ::
                Init_int16 (Int.repr 12219) :: Init_int16 (Int.repr 12222) ::
                Init_int16 (Int.repr 12225) :: Init_int16 (Int.repr 12227) ::
                Init_int16 (Int.repr 12230) :: Init_int16 (Int.repr 12233) ::
                Init_int16 (Int.repr 12235) :: Init_int16 (Int.repr 12238) ::
                Init_int16 (Int.repr 12241) :: Init_int16 (Int.repr 12243) ::
                Init_int16 (Int.repr 12246) :: Init_int16 (Int.repr 12249) ::
                Init_int16 (Int.repr 12251) :: Init_int16 (Int.repr 12254) ::
                Init_int16 (Int.repr 12257) :: Init_int16 (Int.repr 12259) ::
                Init_int16 (Int.repr 12262) :: Init_int16 (Int.repr 12265) ::
                Init_int16 (Int.repr 12267) :: Init_int16 (Int.repr 12270) ::
                Init_int16 (Int.repr 12273) :: Init_int16 (Int.repr 12275) ::
                Init_int16 (Int.repr 12278) :: Init_int16 (Int.repr 12280) ::
                Init_int16 (Int.repr 12283) :: Init_int16 (Int.repr 12286) ::
                Init_int16 (Int.repr 12288) :: Init_int16 (Int.repr 12291) ::
                Init_int16 (Int.repr 12294) :: Init_int16 (Int.repr 12296) ::
                Init_int16 (Int.repr 12299) :: Init_int16 (Int.repr 12302) ::
                Init_int16 (Int.repr 12304) :: Init_int16 (Int.repr 12307) ::
                Init_int16 (Int.repr 12310) :: Init_int16 (Int.repr 12312) ::
                Init_int16 (Int.repr 12315) :: Init_int16 (Int.repr 12317) ::
                Init_int16 (Int.repr 12320) :: Init_int16 (Int.repr 12323) ::
                Init_int16 (Int.repr 12325) :: Init_int16 (Int.repr 12328) ::
                Init_int16 (Int.repr 12331) :: Init_int16 (Int.repr 12333) ::
                Init_int16 (Int.repr 12336) :: Init_int16 (Int.repr 12339) ::
                Init_int16 (Int.repr 12341) :: Init_int16 (Int.repr 12344) ::
                Init_int16 (Int.repr 12346) :: Init_int16 (Int.repr 12349) ::
                Init_int16 (Int.repr 12352) :: Init_int16 (Int.repr 12354) ::
                Init_int16 (Int.repr 12357) :: Init_int16 (Int.repr 12360) ::
                Init_int16 (Int.repr 12362) :: Init_int16 (Int.repr 12365) ::
                Init_int16 (Int.repr 12367) :: Init_int16 (Int.repr 12370) ::
                Init_int16 (Int.repr 12373) :: Init_int16 (Int.repr 12375) ::
                Init_int16 (Int.repr 12378) :: Init_int16 (Int.repr 12381) ::
                Init_int16 (Int.repr 12383) :: Init_int16 (Int.repr 12386) ::
                Init_int16 (Int.repr 12388) :: Init_int16 (Int.repr 12391) ::
                Init_int16 (Int.repr 12394) :: Init_int16 (Int.repr 12396) ::
                Init_int16 (Int.repr 12399) :: Init_int16 (Int.repr 12401) ::
                Init_int16 (Int.repr 12404) :: Init_int16 (Int.repr 12407) ::
                Init_int16 (Int.repr 12409) :: Init_int16 (Int.repr 12412) ::
                Init_int16 (Int.repr 12415) :: Init_int16 (Int.repr 12417) ::
                Init_int16 (Int.repr 12420) :: Init_int16 (Int.repr 12422) ::
                Init_int16 (Int.repr 12425) :: Init_int16 (Int.repr 12428) ::
                Init_int16 (Int.repr 12430) :: Init_int16 (Int.repr 12433) ::
                Init_int16 (Int.repr 12435) :: Init_int16 (Int.repr 12438) ::
                Init_int16 (Int.repr 12441) :: Init_int16 (Int.repr 12443) ::
                Init_int16 (Int.repr 12446) :: Init_int16 (Int.repr 12448) ::
                Init_int16 (Int.repr 12451) :: Init_int16 (Int.repr 12454) ::
                Init_int16 (Int.repr 12456) :: Init_int16 (Int.repr 12459) ::
                Init_int16 (Int.repr 12461) :: Init_int16 (Int.repr 12464) ::
                Init_int16 (Int.repr 12467) :: Init_int16 (Int.repr 12469) ::
                Init_int16 (Int.repr 12472) :: Init_int16 (Int.repr 12474) ::
                Init_int16 (Int.repr 12477) :: Init_int16 (Int.repr 12480) ::
                Init_int16 (Int.repr 12482) :: Init_int16 (Int.repr 12485) ::
                Init_int16 (Int.repr 12487) :: Init_int16 (Int.repr 12490) ::
                Init_int16 (Int.repr 12493) :: Init_int16 (Int.repr 12495) ::
                Init_int16 (Int.repr 12498) :: Init_int16 (Int.repr 12500) ::
                Init_int16 (Int.repr 12503) :: Init_int16 (Int.repr 12505) ::
                Init_int16 (Int.repr 12508) :: Init_int16 (Int.repr 12511) ::
                Init_int16 (Int.repr 12513) :: Init_int16 (Int.repr 12516) ::
                Init_int16 (Int.repr 12518) :: Init_int16 (Int.repr 12521) ::
                Init_int16 (Int.repr 12524) :: Init_int16 (Int.repr 12526) ::
                Init_int16 (Int.repr 12529) :: Init_int16 (Int.repr 12531) ::
                Init_int16 (Int.repr 12534) :: Init_int16 (Int.repr 12536) ::
                Init_int16 (Int.repr 12539) :: Init_int16 (Int.repr 12542) ::
                Init_int16 (Int.repr 12544) :: Init_int16 (Int.repr 12547) ::
                Init_int16 (Int.repr 12549) :: Init_int16 (Int.repr 12552) ::
                Init_int16 (Int.repr 12554) :: Init_int16 (Int.repr 12557) ::
                Init_int16 (Int.repr 12560) :: Init_int16 (Int.repr 12562) ::
                Init_int16 (Int.repr 12565) :: Init_int16 (Int.repr 12567) ::
                Init_int16 (Int.repr 12570) :: Init_int16 (Int.repr 12572) ::
                Init_int16 (Int.repr 12575) :: Init_int16 (Int.repr 12577) ::
                Init_int16 (Int.repr 12580) :: Init_int16 (Int.repr 12583) ::
                Init_int16 (Int.repr 12585) :: Init_int16 (Int.repr 12588) ::
                Init_int16 (Int.repr 12590) :: Init_int16 (Int.repr 12593) ::
                Init_int16 (Int.repr 12595) :: Init_int16 (Int.repr 12598) ::
                Init_int16 (Int.repr 12601) :: Init_int16 (Int.repr 12603) ::
                Init_int16 (Int.repr 12606) :: Init_int16 (Int.repr 12608) ::
                Init_int16 (Int.repr 12611) :: Init_int16 (Int.repr 12613) ::
                Init_int16 (Int.repr 12616) :: Init_int16 (Int.repr 12618) ::
                Init_int16 (Int.repr 12621) :: Init_int16 (Int.repr 12624) ::
                Init_int16 (Int.repr 12626) :: Init_int16 (Int.repr 12629) ::
                Init_int16 (Int.repr 12631) :: Init_int16 (Int.repr 12634) ::
                Init_int16 (Int.repr 12636) :: Init_int16 (Int.repr 12639) ::
                Init_int16 (Int.repr 12641) :: Init_int16 (Int.repr 12644) ::
                Init_int16 (Int.repr 12646) :: Init_int16 (Int.repr 12649) ::
                Init_int16 (Int.repr 12652) :: Init_int16 (Int.repr 12654) ::
                Init_int16 (Int.repr 12657) :: Init_int16 (Int.repr 12659) ::
                Init_int16 (Int.repr 12662) :: Init_int16 (Int.repr 12664) ::
                Init_int16 (Int.repr 12667) :: Init_int16 (Int.repr 12669) ::
                Init_int16 (Int.repr 12672) :: Init_int16 (Int.repr 12674) ::
                Init_int16 (Int.repr 12677) :: Init_int16 (Int.repr 12679) ::
                Init_int16 (Int.repr 12682) :: Init_int16 (Int.repr 12684) ::
                Init_int16 (Int.repr 12687) :: Init_int16 (Int.repr 12690) ::
                Init_int16 (Int.repr 12692) :: Init_int16 (Int.repr 12695) ::
                Init_int16 (Int.repr 12697) :: Init_int16 (Int.repr 12700) ::
                Init_int16 (Int.repr 12702) :: Init_int16 (Int.repr 12705) ::
                Init_int16 (Int.repr 12707) :: Init_int16 (Int.repr 12710) ::
                Init_int16 (Int.repr 12712) :: Init_int16 (Int.repr 12715) ::
                Init_int16 (Int.repr 12717) :: Init_int16 (Int.repr 12720) ::
                Init_int16 (Int.repr 12722) :: Init_int16 (Int.repr 12725) ::
                Init_int16 (Int.repr 12727) :: Init_int16 (Int.repr 12730) ::
                Init_int16 (Int.repr 12732) :: Init_int16 (Int.repr 12735) ::
                Init_int16 (Int.repr 12737) :: Init_int16 (Int.repr 12740) ::
                Init_int16 (Int.repr 12743) :: Init_int16 (Int.repr 12745) ::
                Init_int16 (Int.repr 12748) :: Init_int16 (Int.repr 12750) ::
                Init_int16 (Int.repr 12753) :: Init_int16 (Int.repr 12755) ::
                Init_int16 (Int.repr 12758) :: Init_int16 (Int.repr 12760) ::
                Init_int16 (Int.repr 12763) :: Init_int16 (Int.repr 12765) ::
                Init_int16 (Int.repr 12768) :: Init_int16 (Int.repr 12770) ::
                Init_int16 (Int.repr 12773) :: Init_int16 (Int.repr 12775) ::
                Init_int16 (Int.repr 12778) :: Init_int16 (Int.repr 12780) ::
                Init_int16 (Int.repr 12783) :: Init_int16 (Int.repr 12785) ::
                Init_int16 (Int.repr 12788) :: Init_int16 (Int.repr 12790) ::
                Init_int16 (Int.repr 12793) :: Init_int16 (Int.repr 12795) ::
                Init_int16 (Int.repr 12798) :: Init_int16 (Int.repr 12800) ::
                Init_int16 (Int.repr 12803) :: Init_int16 (Int.repr 12805) ::
                Init_int16 (Int.repr 12808) :: Init_int16 (Int.repr 12810) ::
                Init_int16 (Int.repr 12813) :: Init_int16 (Int.repr 12815) ::
                Init_int16 (Int.repr 12818) :: Init_int16 (Int.repr 12820) ::
                Init_int16 (Int.repr 12823) :: Init_int16 (Int.repr 12825) ::
                Init_int16 (Int.repr 12828) :: Init_int16 (Int.repr 12830) ::
                Init_int16 (Int.repr 12833) :: Init_int16 (Int.repr 12835) ::
                Init_int16 (Int.repr 12838) :: Init_int16 (Int.repr 12840) ::
                Init_int16 (Int.repr 12842) :: Init_int16 (Int.repr 12845) ::
                Init_int16 (Int.repr 12847) :: Init_int16 (Int.repr 12850) ::
                Init_int16 (Int.repr 12852) :: Init_int16 (Int.repr 12855) ::
                Init_int16 (Int.repr 12857) :: Init_int16 (Int.repr 12860) ::
                Init_int16 (Int.repr 12862) :: Init_int16 (Int.repr 12865) ::
                Init_int16 (Int.repr 12867) :: Init_int16 (Int.repr 12870) ::
                Init_int16 (Int.repr 12872) :: Init_int16 (Int.repr 12875) ::
                Init_int16 (Int.repr 12877) :: Init_int16 (Int.repr 12880) ::
                Init_int16 (Int.repr 12882) :: Init_int16 (Int.repr 12885) ::
                Init_int16 (Int.repr 12887) :: Init_int16 (Int.repr 12890) ::
                Init_int16 (Int.repr 12892) :: Init_int16 (Int.repr 12894) ::
                Init_int16 (Int.repr 12897) :: Init_int16 (Int.repr 12899) ::
                Init_int16 (Int.repr 12902) :: Init_int16 (Int.repr 12904) ::
                Init_int16 (Int.repr 12907) :: Init_int16 (Int.repr 12909) ::
                Init_int16 (Int.repr 12912) :: Init_int16 (Int.repr 12914) ::
                Init_int16 (Int.repr 12917) :: Init_int16 (Int.repr 12919) ::
                Init_int16 (Int.repr 12922) :: Init_int16 (Int.repr 12924) ::
                Init_int16 (Int.repr 12926) :: Init_int16 (Int.repr 12929) ::
                Init_int16 (Int.repr 12931) :: Init_int16 (Int.repr 12934) ::
                Init_int16 (Int.repr 12936) :: Init_int16 (Int.repr 12939) ::
                Init_int16 (Int.repr 12941) :: Init_int16 (Int.repr 12944) ::
                Init_int16 (Int.repr 12946) :: Init_int16 (Int.repr 12949) ::
                Init_int16 (Int.repr 12951) :: Init_int16 (Int.repr 12953) ::
                Init_int16 (Int.repr 12956) :: Init_int16 (Int.repr 12958) ::
                Init_int16 (Int.repr 12961) :: Init_int16 (Int.repr 12963) ::
                Init_int16 (Int.repr 12966) :: Init_int16 (Int.repr 12968) ::
                Init_int16 (Int.repr 12971) :: Init_int16 (Int.repr 12973) ::
                Init_int16 (Int.repr 12975) :: Init_int16 (Int.repr 12978) ::
                Init_int16 (Int.repr 12980) :: Init_int16 (Int.repr 12983) ::
                Init_int16 (Int.repr 12985) :: Init_int16 (Int.repr 12988) ::
                Init_int16 (Int.repr 12990) :: Init_int16 (Int.repr 12993) ::
                Init_int16 (Int.repr 12995) :: Init_int16 (Int.repr 12997) ::
                Init_int16 (Int.repr 13000) :: Init_int16 (Int.repr 13002) ::
                Init_int16 (Int.repr 13005) :: Init_int16 (Int.repr 13007) ::
                Init_int16 (Int.repr 13010) :: Init_int16 (Int.repr 13012) ::
                Init_int16 (Int.repr 13014) :: Init_int16 (Int.repr 13017) ::
                Init_int16 (Int.repr 13019) :: Init_int16 (Int.repr 13022) ::
                Init_int16 (Int.repr 13024) :: Init_int16 (Int.repr 13027) ::
                Init_int16 (Int.repr 13029) :: Init_int16 (Int.repr 13031) ::
                Init_int16 (Int.repr 13034) :: Init_int16 (Int.repr 13036) ::
                Init_int16 (Int.repr 13039) :: Init_int16 (Int.repr 13041) ::
                Init_int16 (Int.repr 13044) :: Init_int16 (Int.repr 13046) ::
                Init_int16 (Int.repr 13048) :: Init_int16 (Int.repr 13051) ::
                Init_int16 (Int.repr 13053) :: Init_int16 (Int.repr 13056) ::
                Init_int16 (Int.repr 13058) :: Init_int16 (Int.repr 13060) ::
                Init_int16 (Int.repr 13063) :: Init_int16 (Int.repr 13065) ::
                Init_int16 (Int.repr 13068) :: Init_int16 (Int.repr 13070) ::
                Init_int16 (Int.repr 13073) :: Init_int16 (Int.repr 13075) ::
                Init_int16 (Int.repr 13077) :: Init_int16 (Int.repr 13080) ::
                Init_int16 (Int.repr 13082) :: Init_int16 (Int.repr 13085) ::
                Init_int16 (Int.repr 13087) :: Init_int16 (Int.repr 13089) ::
                Init_int16 (Int.repr 13092) :: Init_int16 (Int.repr 13094) ::
                Init_int16 (Int.repr 13097) :: Init_int16 (Int.repr 13099) ::
                Init_int16 (Int.repr 13101) :: Init_int16 (Int.repr 13104) ::
                Init_int16 (Int.repr 13106) :: Init_int16 (Int.repr 13109) ::
                Init_int16 (Int.repr 13111) :: Init_int16 (Int.repr 13113) ::
                Init_int16 (Int.repr 13116) :: Init_int16 (Int.repr 13118) ::
                Init_int16 (Int.repr 13121) :: Init_int16 (Int.repr 13123) ::
                Init_int16 (Int.repr 13125) :: Init_int16 (Int.repr 13128) ::
                Init_int16 (Int.repr 13130) :: Init_int16 (Int.repr 13133) ::
                Init_int16 (Int.repr 13135) :: Init_int16 (Int.repr 13137) ::
                Init_int16 (Int.repr 13140) :: Init_int16 (Int.repr 13142) ::
                Init_int16 (Int.repr 13145) :: Init_int16 (Int.repr 13147) ::
                Init_int16 (Int.repr 13149) :: Init_int16 (Int.repr 13152) ::
                Init_int16 (Int.repr 13154) :: Init_int16 (Int.repr 13156) ::
                Init_int16 (Int.repr 13159) :: Init_int16 (Int.repr 13161) ::
                Init_int16 (Int.repr 13164) :: Init_int16 (Int.repr 13166) ::
                Init_int16 (Int.repr 13168) :: Init_int16 (Int.repr 13171) ::
                Init_int16 (Int.repr 13173) :: Init_int16 (Int.repr 13175) ::
                Init_int16 (Int.repr 13178) :: Init_int16 (Int.repr 13180) ::
                Init_int16 (Int.repr 13183) :: Init_int16 (Int.repr 13185) ::
                Init_int16 (Int.repr 13187) :: Init_int16 (Int.repr 13190) ::
                Init_int16 (Int.repr 13192) :: Init_int16 (Int.repr 13194) ::
                Init_int16 (Int.repr 13197) :: Init_int16 (Int.repr 13199) ::
                Init_int16 (Int.repr 13202) :: Init_int16 (Int.repr 13204) ::
                Init_int16 (Int.repr 13206) :: Init_int16 (Int.repr 13209) ::
                Init_int16 (Int.repr 13211) :: Init_int16 (Int.repr 13213) ::
                Init_int16 (Int.repr 13216) :: Init_int16 (Int.repr 13218) ::
                Init_int16 (Int.repr 13221) :: Init_int16 (Int.repr 13223) ::
                Init_int16 (Int.repr 13225) :: Init_int16 (Int.repr 13228) ::
                Init_int16 (Int.repr 13230) :: Init_int16 (Int.repr 13232) ::
                Init_int16 (Int.repr 13235) :: Init_int16 (Int.repr 13237) ::
                Init_int16 (Int.repr 13239) :: Init_int16 (Int.repr 13242) ::
                Init_int16 (Int.repr 13244) :: Init_int16 (Int.repr 13246) ::
                Init_int16 (Int.repr 13249) :: Init_int16 (Int.repr 13251) ::
                Init_int16 (Int.repr 13254) :: Init_int16 (Int.repr 13256) ::
                Init_int16 (Int.repr 13258) :: Init_int16 (Int.repr 13261) ::
                Init_int16 (Int.repr 13263) :: Init_int16 (Int.repr 13265) ::
                Init_int16 (Int.repr 13268) :: Init_int16 (Int.repr 13270) ::
                Init_int16 (Int.repr 13272) :: Init_int16 (Int.repr 13275) ::
                Init_int16 (Int.repr 13277) :: Init_int16 (Int.repr 13279) ::
                Init_int16 (Int.repr 13282) :: Init_int16 (Int.repr 13284) ::
                Init_int16 (Int.repr 13286) :: Init_int16 (Int.repr 13289) ::
                Init_int16 (Int.repr 13291) :: Init_int16 (Int.repr 13293) ::
                Init_int16 (Int.repr 13296) :: Init_int16 (Int.repr 13298) ::
                Init_int16 (Int.repr 13300) :: Init_int16 (Int.repr 13303) ::
                Init_int16 (Int.repr 13305) :: Init_int16 (Int.repr 13307) ::
                Init_int16 (Int.repr 13310) :: Init_int16 (Int.repr 13312) ::
                Init_int16 (Int.repr 13314) :: Init_int16 (Int.repr 13317) ::
                Init_int16 (Int.repr 13319) :: Init_int16 (Int.repr 13321) ::
                Init_int16 (Int.repr 13324) :: Init_int16 (Int.repr 13326) ::
                Init_int16 (Int.repr 13328) :: Init_int16 (Int.repr 13331) ::
                Init_int16 (Int.repr 13333) :: Init_int16 (Int.repr 13335) ::
                Init_int16 (Int.repr 13338) :: Init_int16 (Int.repr 13340) ::
                Init_int16 (Int.repr 13342) :: Init_int16 (Int.repr 13345) ::
                Init_int16 (Int.repr 13347) :: Init_int16 (Int.repr 13349) ::
                Init_int16 (Int.repr 13352) :: Init_int16 (Int.repr 13354) ::
                Init_int16 (Int.repr 13356) :: Init_int16 (Int.repr 13359) ::
                Init_int16 (Int.repr 13361) :: Init_int16 (Int.repr 13363) ::
                Init_int16 (Int.repr 13365) :: Init_int16 (Int.repr 13368) ::
                Init_int16 (Int.repr 13370) :: Init_int16 (Int.repr 13372) ::
                Init_int16 (Int.repr 13375) :: Init_int16 (Int.repr 13377) ::
                Init_int16 (Int.repr 13379) :: Init_int16 (Int.repr 13382) ::
                Init_int16 (Int.repr 13384) :: Init_int16 (Int.repr 13386) ::
                Init_int16 (Int.repr 13389) :: Init_int16 (Int.repr 13391) ::
                Init_int16 (Int.repr 13393) :: Init_int16 (Int.repr 13395) ::
                Init_int16 (Int.repr 13398) :: Init_int16 (Int.repr 13400) ::
                Init_int16 (Int.repr 13402) :: Init_int16 (Int.repr 13405) ::
                Init_int16 (Int.repr 13407) :: Init_int16 (Int.repr 13409) ::
                Init_int16 (Int.repr 13412) :: Init_int16 (Int.repr 13414) ::
                Init_int16 (Int.repr 13416) :: Init_int16 (Int.repr 13418) ::
                Init_int16 (Int.repr 13421) :: Init_int16 (Int.repr 13423) ::
                Init_int16 (Int.repr 13425) :: Init_int16 (Int.repr 13428) ::
                Init_int16 (Int.repr 13430) :: Init_int16 (Int.repr 13432) ::
                Init_int16 (Int.repr 13435) :: Init_int16 (Int.repr 13437) ::
                Init_int16 (Int.repr 13439) :: Init_int16 (Int.repr 13441) ::
                Init_int16 (Int.repr 13444) :: Init_int16 (Int.repr 13446) ::
                Init_int16 (Int.repr 13448) :: Init_int16 (Int.repr 13451) ::
                Init_int16 (Int.repr 13453) :: Init_int16 (Int.repr 13455) ::
                Init_int16 (Int.repr 13457) :: Init_int16 (Int.repr 13460) ::
                Init_int16 (Int.repr 13462) :: Init_int16 (Int.repr 13464) ::
                Init_int16 (Int.repr 13466) :: Init_int16 (Int.repr 13469) ::
                Init_int16 (Int.repr 13471) :: Init_int16 (Int.repr 13473) ::
                Init_int16 (Int.repr 13476) :: Init_int16 (Int.repr 13478) ::
                Init_int16 (Int.repr 13480) :: Init_int16 (Int.repr 13482) ::
                Init_int16 (Int.repr 13485) :: Init_int16 (Int.repr 13487) ::
                Init_int16 (Int.repr 13489) :: Init_int16 (Int.repr 13492) ::
                Init_int16 (Int.repr 13494) :: Init_int16 (Int.repr 13496) ::
                Init_int16 (Int.repr 13498) :: Init_int16 (Int.repr 13501) ::
                Init_int16 (Int.repr 13503) :: Init_int16 (Int.repr 13505) ::
                Init_int16 (Int.repr 13507) :: Init_int16 (Int.repr 13510) ::
                Init_int16 (Int.repr 13512) :: Init_int16 (Int.repr 13514) ::
                Init_int16 (Int.repr 13516) :: Init_int16 (Int.repr 13519) ::
                Init_int16 (Int.repr 13521) :: Init_int16 (Int.repr 13523) ::
                Init_int16 (Int.repr 13525) :: Init_int16 (Int.repr 13528) ::
                Init_int16 (Int.repr 13530) :: Init_int16 (Int.repr 13532) ::
                Init_int16 (Int.repr 13534) :: Init_int16 (Int.repr 13537) ::
                Init_int16 (Int.repr 13539) :: Init_int16 (Int.repr 13541) ::
                Init_int16 (Int.repr 13543) :: Init_int16 (Int.repr 13546) ::
                Init_int16 (Int.repr 13548) :: Init_int16 (Int.repr 13550) ::
                Init_int16 (Int.repr 13552) :: Init_int16 (Int.repr 13555) ::
                Init_int16 (Int.repr 13557) :: Init_int16 (Int.repr 13559) ::
                Init_int16 (Int.repr 13561) :: Init_int16 (Int.repr 13564) ::
                Init_int16 (Int.repr 13566) :: Init_int16 (Int.repr 13568) ::
                Init_int16 (Int.repr 13570) :: Init_int16 (Int.repr 13573) ::
                Init_int16 (Int.repr 13575) :: Init_int16 (Int.repr 13577) ::
                Init_int16 (Int.repr 13579) :: Init_int16 (Int.repr 13582) ::
                Init_int16 (Int.repr 13584) :: Init_int16 (Int.repr 13586) ::
                Init_int16 (Int.repr 13588) :: Init_int16 (Int.repr 13591) ::
                Init_int16 (Int.repr 13593) :: Init_int16 (Int.repr 13595) ::
                Init_int16 (Int.repr 13597) :: Init_int16 (Int.repr 13600) ::
                Init_int16 (Int.repr 13602) :: Init_int16 (Int.repr 13604) ::
                Init_int16 (Int.repr 13606) :: Init_int16 (Int.repr 13608) ::
                Init_int16 (Int.repr 13611) :: Init_int16 (Int.repr 13613) ::
                Init_int16 (Int.repr 13615) :: Init_int16 (Int.repr 13617) ::
                Init_int16 (Int.repr 13620) :: Init_int16 (Int.repr 13622) ::
                Init_int16 (Int.repr 13624) :: Init_int16 (Int.repr 13626) ::
                Init_int16 (Int.repr 13628) :: Init_int16 (Int.repr 13631) ::
                Init_int16 (Int.repr 13633) :: Init_int16 (Int.repr 13635) ::
                Init_int16 (Int.repr 13637) :: Init_int16 (Int.repr 13640) ::
                Init_int16 (Int.repr 13642) :: Init_int16 (Int.repr 13644) ::
                Init_int16 (Int.repr 13646) :: Init_int16 (Int.repr 13648) ::
                Init_int16 (Int.repr 13651) :: Init_int16 (Int.repr 13653) ::
                Init_int16 (Int.repr 13655) :: Init_int16 (Int.repr 13657) ::
                Init_int16 (Int.repr 13659) :: Init_int16 (Int.repr 13662) ::
                Init_int16 (Int.repr 13664) :: Init_int16 (Int.repr 13666) ::
                Init_int16 (Int.repr 13668) :: Init_int16 (Int.repr 13670) ::
                Init_int16 (Int.repr 13673) :: Init_int16 (Int.repr 13675) ::
                Init_int16 (Int.repr 13677) :: Init_int16 (Int.repr 13679) ::
                Init_int16 (Int.repr 13681) :: Init_int16 (Int.repr 13684) ::
                Init_int16 (Int.repr 13686) :: Init_int16 (Int.repr 13688) ::
                Init_int16 (Int.repr 13690) :: Init_int16 (Int.repr 13692) ::
                Init_int16 (Int.repr 13695) :: Init_int16 (Int.repr 13697) ::
                Init_int16 (Int.repr 13699) :: Init_int16 (Int.repr 13701) ::
                Init_int16 (Int.repr 13703) :: Init_int16 (Int.repr 13706) ::
                Init_int16 (Int.repr 13708) :: Init_int16 (Int.repr 13710) ::
                Init_int16 (Int.repr 13712) :: Init_int16 (Int.repr 13714) ::
                Init_int16 (Int.repr 13717) :: Init_int16 (Int.repr 13719) ::
                Init_int16 (Int.repr 13721) :: Init_int16 (Int.repr 13723) ::
                Init_int16 (Int.repr 13725) :: Init_int16 (Int.repr 13728) ::
                Init_int16 (Int.repr 13730) :: Init_int16 (Int.repr 13732) ::
                Init_int16 (Int.repr 13734) :: Init_int16 (Int.repr 13736) ::
                Init_int16 (Int.repr 13738) :: Init_int16 (Int.repr 13741) ::
                Init_int16 (Int.repr 13743) :: Init_int16 (Int.repr 13745) ::
                Init_int16 (Int.repr 13747) :: Init_int16 (Int.repr 13749) ::
                Init_int16 (Int.repr 13751) :: Init_int16 (Int.repr 13754) ::
                Init_int16 (Int.repr 13756) :: Init_int16 (Int.repr 13758) ::
                Init_int16 (Int.repr 13760) :: Init_int16 (Int.repr 13762) ::
                Init_int16 (Int.repr 13765) :: Init_int16 (Int.repr 13767) ::
                Init_int16 (Int.repr 13769) :: Init_int16 (Int.repr 13771) ::
                Init_int16 (Int.repr 13773) :: Init_int16 (Int.repr 13775) ::
                Init_int16 (Int.repr 13778) :: Init_int16 (Int.repr 13780) ::
                Init_int16 (Int.repr 13782) :: Init_int16 (Int.repr 13784) ::
                Init_int16 (Int.repr 13786) :: Init_int16 (Int.repr 13788) ::
                Init_int16 (Int.repr 13790) :: Init_int16 (Int.repr 13793) ::
                Init_int16 (Int.repr 13795) :: Init_int16 (Int.repr 13797) ::
                Init_int16 (Int.repr 13799) :: Init_int16 (Int.repr 13801) ::
                Init_int16 (Int.repr 13803) :: Init_int16 (Int.repr 13806) ::
                Init_int16 (Int.repr 13808) :: Init_int16 (Int.repr 13810) ::
                Init_int16 (Int.repr 13812) :: Init_int16 (Int.repr 13814) ::
                Init_int16 (Int.repr 13816) :: Init_int16 (Int.repr 13818) ::
                Init_int16 (Int.repr 13821) :: Init_int16 (Int.repr 13823) ::
                Init_int16 (Int.repr 13825) :: Init_int16 (Int.repr 13827) ::
                Init_int16 (Int.repr 13829) :: Init_int16 (Int.repr 13831) ::
                Init_int16 (Int.repr 13834) :: Init_int16 (Int.repr 13836) ::
                Init_int16 (Int.repr 13838) :: Init_int16 (Int.repr 13840) ::
                Init_int16 (Int.repr 13842) :: Init_int16 (Int.repr 13844) ::
                Init_int16 (Int.repr 13846) :: Init_int16 (Int.repr 13848) ::
                Init_int16 (Int.repr 13851) :: Init_int16 (Int.repr 13853) ::
                Init_int16 (Int.repr 13855) :: Init_int16 (Int.repr 13857) ::
                Init_int16 (Int.repr 13859) :: Init_int16 (Int.repr 13861) ::
                Init_int16 (Int.repr 13863) :: Init_int16 (Int.repr 13866) ::
                Init_int16 (Int.repr 13868) :: Init_int16 (Int.repr 13870) ::
                Init_int16 (Int.repr 13872) :: Init_int16 (Int.repr 13874) ::
                Init_int16 (Int.repr 13876) :: Init_int16 (Int.repr 13878) ::
                Init_int16 (Int.repr 13880) :: Init_int16 (Int.repr 13883) ::
                Init_int16 (Int.repr 13885) :: Init_int16 (Int.repr 13887) ::
                Init_int16 (Int.repr 13889) :: Init_int16 (Int.repr 13891) ::
                Init_int16 (Int.repr 13893) :: Init_int16 (Int.repr 13895) ::
                Init_int16 (Int.repr 13897) :: Init_int16 (Int.repr 13900) ::
                Init_int16 (Int.repr 13902) :: Init_int16 (Int.repr 13904) ::
                Init_int16 (Int.repr 13906) :: Init_int16 (Int.repr 13908) ::
                Init_int16 (Int.repr 13910) :: Init_int16 (Int.repr 13912) ::
                Init_int16 (Int.repr 13914) :: Init_int16 (Int.repr 13916) ::
                Init_int16 (Int.repr 13919) :: Init_int16 (Int.repr 13921) ::
                Init_int16 (Int.repr 13923) :: Init_int16 (Int.repr 13925) ::
                Init_int16 (Int.repr 13927) :: Init_int16 (Int.repr 13929) ::
                Init_int16 (Int.repr 13931) :: Init_int16 (Int.repr 13933) ::
                Init_int16 (Int.repr 13935) :: Init_int16 (Int.repr 13938) ::
                Init_int16 (Int.repr 13940) :: Init_int16 (Int.repr 13942) ::
                Init_int16 (Int.repr 13944) :: Init_int16 (Int.repr 13946) ::
                Init_int16 (Int.repr 13948) :: Init_int16 (Int.repr 13950) ::
                Init_int16 (Int.repr 13952) :: Init_int16 (Int.repr 13954) ::
                Init_int16 (Int.repr 13956) :: Init_int16 (Int.repr 13959) ::
                Init_int16 (Int.repr 13961) :: Init_int16 (Int.repr 13963) ::
                Init_int16 (Int.repr 13965) :: Init_int16 (Int.repr 13967) ::
                Init_int16 (Int.repr 13969) :: Init_int16 (Int.repr 13971) ::
                Init_int16 (Int.repr 13973) :: Init_int16 (Int.repr 13975) ::
                Init_int16 (Int.repr 13977) :: Init_int16 (Int.repr 13979) ::
                Init_int16 (Int.repr 13981) :: Init_int16 (Int.repr 13984) ::
                Init_int16 (Int.repr 13986) :: Init_int16 (Int.repr 13988) ::
                Init_int16 (Int.repr 13990) :: Init_int16 (Int.repr 13992) ::
                Init_int16 (Int.repr 13994) :: Init_int16 (Int.repr 13996) ::
                Init_int16 (Int.repr 13998) :: Init_int16 (Int.repr 14000) ::
                Init_int16 (Int.repr 14002) :: Init_int16 (Int.repr 14004) ::
                Init_int16 (Int.repr 14006) :: Init_int16 (Int.repr 14009) ::
                Init_int16 (Int.repr 14011) :: Init_int16 (Int.repr 14013) ::
                Init_int16 (Int.repr 14015) :: Init_int16 (Int.repr 14017) ::
                Init_int16 (Int.repr 14019) :: Init_int16 (Int.repr 14021) ::
                Init_int16 (Int.repr 14023) :: Init_int16 (Int.repr 14025) ::
                Init_int16 (Int.repr 14027) :: Init_int16 (Int.repr 14029) ::
                Init_int16 (Int.repr 14031) :: Init_int16 (Int.repr 14033) ::
                Init_int16 (Int.repr 14035) :: Init_int16 (Int.repr 14037) ::
                Init_int16 (Int.repr 14040) :: Init_int16 (Int.repr 14042) ::
                Init_int16 (Int.repr 14044) :: Init_int16 (Int.repr 14046) ::
                Init_int16 (Int.repr 14048) :: Init_int16 (Int.repr 14050) ::
                Init_int16 (Int.repr 14052) :: Init_int16 (Int.repr 14054) ::
                Init_int16 (Int.repr 14056) :: Init_int16 (Int.repr 14058) ::
                Init_int16 (Int.repr 14060) :: Init_int16 (Int.repr 14062) ::
                Init_int16 (Int.repr 14064) :: Init_int16 (Int.repr 14066) ::
                Init_int16 (Int.repr 14068) :: Init_int16 (Int.repr 14070) ::
                Init_int16 (Int.repr 14072) :: Init_int16 (Int.repr 14074) ::
                Init_int16 (Int.repr 14077) :: Init_int16 (Int.repr 14079) ::
                Init_int16 (Int.repr 14081) :: Init_int16 (Int.repr 14083) ::
                Init_int16 (Int.repr 14085) :: Init_int16 (Int.repr 14087) ::
                Init_int16 (Int.repr 14089) :: Init_int16 (Int.repr 14091) ::
                Init_int16 (Int.repr 14093) :: Init_int16 (Int.repr 14095) ::
                Init_int16 (Int.repr 14097) :: Init_int16 (Int.repr 14099) ::
                Init_int16 (Int.repr 14101) :: Init_int16 (Int.repr 14103) ::
                Init_int16 (Int.repr 14105) :: Init_int16 (Int.repr 14107) ::
                Init_int16 (Int.repr 14109) :: Init_int16 (Int.repr 14111) ::
                Init_int16 (Int.repr 14113) :: Init_int16 (Int.repr 14115) ::
                Init_int16 (Int.repr 14117) :: Init_int16 (Int.repr 14119) ::
                Init_int16 (Int.repr 14121) :: Init_int16 (Int.repr 14123) ::
                Init_int16 (Int.repr 14125) :: Init_int16 (Int.repr 14127) ::
                Init_int16 (Int.repr 14129) :: Init_int16 (Int.repr 14131) ::
                Init_int16 (Int.repr 14134) :: Init_int16 (Int.repr 14136) ::
                Init_int16 (Int.repr 14138) :: Init_int16 (Int.repr 14140) ::
                Init_int16 (Int.repr 14142) :: Init_int16 (Int.repr 14144) ::
                Init_int16 (Int.repr 14146) :: Init_int16 (Int.repr 14148) ::
                Init_int16 (Int.repr 14150) :: Init_int16 (Int.repr 14152) ::
                Init_int16 (Int.repr 14154) :: Init_int16 (Int.repr 14156) ::
                Init_int16 (Int.repr 14158) :: Init_int16 (Int.repr 14160) ::
                Init_int16 (Int.repr 14162) :: Init_int16 (Int.repr 14164) ::
                Init_int16 (Int.repr 14166) :: Init_int16 (Int.repr 14168) ::
                Init_int16 (Int.repr 14170) :: Init_int16 (Int.repr 14172) ::
                Init_int16 (Int.repr 14174) :: Init_int16 (Int.repr 14176) ::
                Init_int16 (Int.repr 14178) :: Init_int16 (Int.repr 14180) ::
                Init_int16 (Int.repr 14182) :: Init_int16 (Int.repr 14184) ::
                Init_int16 (Int.repr 14186) :: Init_int16 (Int.repr 14188) ::
                Init_int16 (Int.repr 14190) :: Init_int16 (Int.repr 14192) ::
                Init_int16 (Int.repr 14194) :: Init_int16 (Int.repr 14196) ::
                Init_int16 (Int.repr 14198) :: Init_int16 (Int.repr 14200) ::
                Init_int16 (Int.repr 14202) :: Init_int16 (Int.repr 14204) ::
                Init_int16 (Int.repr 14206) :: Init_int16 (Int.repr 14208) ::
                Init_int16 (Int.repr 14210) :: Init_int16 (Int.repr 14212) ::
                Init_int16 (Int.repr 14214) :: Init_int16 (Int.repr 14216) ::
                Init_int16 (Int.repr 14218) :: Init_int16 (Int.repr 14220) ::
                Init_int16 (Int.repr 14222) :: Init_int16 (Int.repr 14224) ::
                Init_int16 (Int.repr 14226) :: Init_int16 (Int.repr 14228) ::
                Init_int16 (Int.repr 14230) :: Init_int16 (Int.repr 14232) ::
                Init_int16 (Int.repr 14234) :: Init_int16 (Int.repr 14236) ::
                Init_int16 (Int.repr 14238) :: Init_int16 (Int.repr 14240) ::
                Init_int16 (Int.repr 14242) :: Init_int16 (Int.repr 14243) ::
                Init_int16 (Int.repr 14245) :: Init_int16 (Int.repr 14247) ::
                Init_int16 (Int.repr 14249) :: Init_int16 (Int.repr 14251) ::
                Init_int16 (Int.repr 14253) :: Init_int16 (Int.repr 14255) ::
                Init_int16 (Int.repr 14257) :: Init_int16 (Int.repr 14259) ::
                Init_int16 (Int.repr 14261) :: Init_int16 (Int.repr 14263) ::
                Init_int16 (Int.repr 14265) :: Init_int16 (Int.repr 14267) ::
                Init_int16 (Int.repr 14269) :: Init_int16 (Int.repr 14271) ::
                Init_int16 (Int.repr 14273) :: Init_int16 (Int.repr 14275) ::
                Init_int16 (Int.repr 14277) :: Init_int16 (Int.repr 14279) ::
                Init_int16 (Int.repr 14281) :: Init_int16 (Int.repr 14283) ::
                Init_int16 (Int.repr 14285) :: Init_int16 (Int.repr 14287) ::
                Init_int16 (Int.repr 14289) :: Init_int16 (Int.repr 14291) ::
                Init_int16 (Int.repr 14293) :: Init_int16 (Int.repr 14295) ::
                Init_int16 (Int.repr 14297) :: Init_int16 (Int.repr 14299) ::
                Init_int16 (Int.repr 14300) :: Init_int16 (Int.repr 14302) ::
                Init_int16 (Int.repr 14304) :: Init_int16 (Int.repr 14306) ::
                Init_int16 (Int.repr 14308) :: Init_int16 (Int.repr 14310) ::
                Init_int16 (Int.repr 14312) :: Init_int16 (Int.repr 14314) ::
                Init_int16 (Int.repr 14316) :: Init_int16 (Int.repr 14318) ::
                Init_int16 (Int.repr 14320) :: Init_int16 (Int.repr 14322) ::
                Init_int16 (Int.repr 14324) :: Init_int16 (Int.repr 14326) ::
                Init_int16 (Int.repr 14328) :: Init_int16 (Int.repr 14330) ::
                Init_int16 (Int.repr 14332) :: Init_int16 (Int.repr 14334) ::
                Init_int16 (Int.repr 14335) :: Init_int16 (Int.repr 14337) ::
                Init_int16 (Int.repr 14339) :: Init_int16 (Int.repr 14341) ::
                Init_int16 (Int.repr 14343) :: Init_int16 (Int.repr 14345) ::
                Init_int16 (Int.repr 14347) :: Init_int16 (Int.repr 14349) ::
                Init_int16 (Int.repr 14351) :: Init_int16 (Int.repr 14353) ::
                Init_int16 (Int.repr 14355) :: Init_int16 (Int.repr 14357) ::
                Init_int16 (Int.repr 14359) :: Init_int16 (Int.repr 14361) ::
                Init_int16 (Int.repr 14362) :: Init_int16 (Int.repr 14364) ::
                Init_int16 (Int.repr 14366) :: Init_int16 (Int.repr 14368) ::
                Init_int16 (Int.repr 14370) :: Init_int16 (Int.repr 14372) ::
                Init_int16 (Int.repr 14374) :: Init_int16 (Int.repr 14376) ::
                Init_int16 (Int.repr 14378) :: Init_int16 (Int.repr 14380) ::
                Init_int16 (Int.repr 14382) :: Init_int16 (Int.repr 14384) ::
                Init_int16 (Int.repr 14386) :: Init_int16 (Int.repr 14387) ::
                Init_int16 (Int.repr 14389) :: Init_int16 (Int.repr 14391) ::
                Init_int16 (Int.repr 14393) :: Init_int16 (Int.repr 14395) ::
                Init_int16 (Int.repr 14397) :: Init_int16 (Int.repr 14399) ::
                Init_int16 (Int.repr 14401) :: Init_int16 (Int.repr 14403) ::
                Init_int16 (Int.repr 14405) :: Init_int16 (Int.repr 14407) ::
                Init_int16 (Int.repr 14408) :: Init_int16 (Int.repr 14410) ::
                Init_int16 (Int.repr 14412) :: Init_int16 (Int.repr 14414) ::
                Init_int16 (Int.repr 14416) :: Init_int16 (Int.repr 14418) ::
                Init_int16 (Int.repr 14420) :: Init_int16 (Int.repr 14422) ::
                Init_int16 (Int.repr 14424) :: Init_int16 (Int.repr 14426) ::
                Init_int16 (Int.repr 14427) :: Init_int16 (Int.repr 14429) ::
                Init_int16 (Int.repr 14431) :: Init_int16 (Int.repr 14433) ::
                Init_int16 (Int.repr 14435) :: Init_int16 (Int.repr 14437) ::
                Init_int16 (Int.repr 14439) :: Init_int16 (Int.repr 14441) ::
                Init_int16 (Int.repr 14443) :: Init_int16 (Int.repr 14444) ::
                Init_int16 (Int.repr 14446) :: Init_int16 (Int.repr 14448) ::
                Init_int16 (Int.repr 14450) :: Init_int16 (Int.repr 14452) ::
                Init_int16 (Int.repr 14454) :: Init_int16 (Int.repr 14456) ::
                Init_int16 (Int.repr 14458) :: Init_int16 (Int.repr 14460) ::
                Init_int16 (Int.repr 14461) :: Init_int16 (Int.repr 14463) ::
                Init_int16 (Int.repr 14465) :: Init_int16 (Int.repr 14467) ::
                Init_int16 (Int.repr 14469) :: Init_int16 (Int.repr 14471) ::
                Init_int16 (Int.repr 14473) :: Init_int16 (Int.repr 14475) ::
                Init_int16 (Int.repr 14476) :: Init_int16 (Int.repr 14478) ::
                Init_int16 (Int.repr 14480) :: Init_int16 (Int.repr 14482) ::
                Init_int16 (Int.repr 14484) :: Init_int16 (Int.repr 14486) ::
                Init_int16 (Int.repr 14488) :: Init_int16 (Int.repr 14489) ::
                Init_int16 (Int.repr 14491) :: Init_int16 (Int.repr 14493) ::
                Init_int16 (Int.repr 14495) :: Init_int16 (Int.repr 14497) ::
                Init_int16 (Int.repr 14499) :: Init_int16 (Int.repr 14501) ::
                Init_int16 (Int.repr 14503) :: Init_int16 (Int.repr 14504) ::
                Init_int16 (Int.repr 14506) :: Init_int16 (Int.repr 14508) ::
                Init_int16 (Int.repr 14510) :: Init_int16 (Int.repr 14512) ::
                Init_int16 (Int.repr 14514) :: Init_int16 (Int.repr 14516) ::
                Init_int16 (Int.repr 14517) :: Init_int16 (Int.repr 14519) ::
                Init_int16 (Int.repr 14521) :: Init_int16 (Int.repr 14523) ::
                Init_int16 (Int.repr 14525) :: Init_int16 (Int.repr 14527) ::
                Init_int16 (Int.repr 14529) :: Init_int16 (Int.repr 14530) ::
                Init_int16 (Int.repr 14532) :: Init_int16 (Int.repr 14534) ::
                Init_int16 (Int.repr 14536) :: Init_int16 (Int.repr 14538) ::
                Init_int16 (Int.repr 14540) :: Init_int16 (Int.repr 14541) ::
                Init_int16 (Int.repr 14543) :: Init_int16 (Int.repr 14545) ::
                Init_int16 (Int.repr 14547) :: Init_int16 (Int.repr 14549) ::
                Init_int16 (Int.repr 14551) :: Init_int16 (Int.repr 14552) ::
                Init_int16 (Int.repr 14554) :: Init_int16 (Int.repr 14556) ::
                Init_int16 (Int.repr 14558) :: Init_int16 (Int.repr 14560) ::
                Init_int16 (Int.repr 14562) :: Init_int16 (Int.repr 14563) ::
                Init_int16 (Int.repr 14565) :: Init_int16 (Int.repr 14567) ::
                Init_int16 (Int.repr 14569) :: Init_int16 (Int.repr 14571) ::
                Init_int16 (Int.repr 14573) :: Init_int16 (Int.repr 14574) ::
                Init_int16 (Int.repr 14576) :: Init_int16 (Int.repr 14578) ::
                Init_int16 (Int.repr 14580) :: Init_int16 (Int.repr 14582) ::
                Init_int16 (Int.repr 14584) :: Init_int16 (Int.repr 14585) ::
                Init_int16 (Int.repr 14587) :: Init_int16 (Int.repr 14589) ::
                Init_int16 (Int.repr 14591) :: Init_int16 (Int.repr 14593) ::
                Init_int16 (Int.repr 14595) :: Init_int16 (Int.repr 14596) ::
                Init_int16 (Int.repr 14598) :: Init_int16 (Int.repr 14600) ::
                Init_int16 (Int.repr 14602) :: Init_int16 (Int.repr 14604) ::
                Init_int16 (Int.repr 14605) :: Init_int16 (Int.repr 14607) ::
                Init_int16 (Int.repr 14609) :: Init_int16 (Int.repr 14611) ::
                Init_int16 (Int.repr 14613) :: Init_int16 (Int.repr 14614) ::
                Init_int16 (Int.repr 14616) :: Init_int16 (Int.repr 14618) ::
                Init_int16 (Int.repr 14620) :: Init_int16 (Int.repr 14622) ::
                Init_int16 (Int.repr 14623) :: Init_int16 (Int.repr 14625) ::
                Init_int16 (Int.repr 14627) :: Init_int16 (Int.repr 14629) ::
                Init_int16 (Int.repr 14631) :: Init_int16 (Int.repr 14632) ::
                Init_int16 (Int.repr 14634) :: Init_int16 (Int.repr 14636) ::
                Init_int16 (Int.repr 14638) :: Init_int16 (Int.repr 14640) ::
                Init_int16 (Int.repr 14641) :: Init_int16 (Int.repr 14643) ::
                Init_int16 (Int.repr 14645) :: Init_int16 (Int.repr 14647) ::
                Init_int16 (Int.repr 14649) :: Init_int16 (Int.repr 14650) ::
                Init_int16 (Int.repr 14652) :: Init_int16 (Int.repr 14654) ::
                Init_int16 (Int.repr 14656) :: Init_int16 (Int.repr 14658) ::
                Init_int16 (Int.repr 14659) :: Init_int16 (Int.repr 14661) ::
                Init_int16 (Int.repr 14663) :: Init_int16 (Int.repr 14665) ::
                Init_int16 (Int.repr 14667) :: Init_int16 (Int.repr 14668) ::
                Init_int16 (Int.repr 14670) :: Init_int16 (Int.repr 14672) ::
                Init_int16 (Int.repr 14674) :: Init_int16 (Int.repr 14675) ::
                Init_int16 (Int.repr 14677) :: Init_int16 (Int.repr 14679) ::
                Init_int16 (Int.repr 14681) :: Init_int16 (Int.repr 14683) ::
                Init_int16 (Int.repr 14684) :: Init_int16 (Int.repr 14686) ::
                Init_int16 (Int.repr 14688) :: Init_int16 (Int.repr 14690) ::
                Init_int16 (Int.repr 14691) :: Init_int16 (Int.repr 14693) ::
                Init_int16 (Int.repr 14695) :: Init_int16 (Int.repr 14697) ::
                Init_int16 (Int.repr 14698) :: Init_int16 (Int.repr 14700) ::
                Init_int16 (Int.repr 14702) :: Init_int16 (Int.repr 14704) ::
                Init_int16 (Int.repr 14706) :: Init_int16 (Int.repr 14707) ::
                Init_int16 (Int.repr 14709) :: Init_int16 (Int.repr 14711) ::
                Init_int16 (Int.repr 14713) :: Init_int16 (Int.repr 14714) ::
                Init_int16 (Int.repr 14716) :: Init_int16 (Int.repr 14718) ::
                Init_int16 (Int.repr 14720) :: Init_int16 (Int.repr 14721) ::
                Init_int16 (Int.repr 14723) :: Init_int16 (Int.repr 14725) ::
                Init_int16 (Int.repr 14727) :: Init_int16 (Int.repr 14728) ::
                Init_int16 (Int.repr 14730) :: Init_int16 (Int.repr 14732) ::
                Init_int16 (Int.repr 14734) :: Init_int16 (Int.repr 14735) ::
                Init_int16 (Int.repr 14737) :: Init_int16 (Int.repr 14739) ::
                Init_int16 (Int.repr 14741) :: Init_int16 (Int.repr 14742) ::
                Init_int16 (Int.repr 14744) :: Init_int16 (Int.repr 14746) ::
                Init_int16 (Int.repr 14748) :: Init_int16 (Int.repr 14749) ::
                Init_int16 (Int.repr 14751) :: Init_int16 (Int.repr 14753) ::
                Init_int16 (Int.repr 14755) :: Init_int16 (Int.repr 14756) ::
                Init_int16 (Int.repr 14758) :: Init_int16 (Int.repr 14760) ::
                Init_int16 (Int.repr 14761) :: Init_int16 (Int.repr 14763) ::
                Init_int16 (Int.repr 14765) :: Init_int16 (Int.repr 14767) ::
                Init_int16 (Int.repr 14768) :: Init_int16 (Int.repr 14770) ::
                Init_int16 (Int.repr 14772) :: Init_int16 (Int.repr 14774) ::
                Init_int16 (Int.repr 14775) :: Init_int16 (Int.repr 14777) ::
                Init_int16 (Int.repr 14779) :: Init_int16 (Int.repr 14781) ::
                Init_int16 (Int.repr 14782) :: Init_int16 (Int.repr 14784) ::
                Init_int16 (Int.repr 14786) :: Init_int16 (Int.repr 14787) ::
                Init_int16 (Int.repr 14789) :: Init_int16 (Int.repr 14791) ::
                Init_int16 (Int.repr 14793) :: Init_int16 (Int.repr 14794) ::
                Init_int16 (Int.repr 14796) :: Init_int16 (Int.repr 14798) ::
                Init_int16 (Int.repr 14799) :: Init_int16 (Int.repr 14801) ::
                Init_int16 (Int.repr 14803) :: Init_int16 (Int.repr 14805) ::
                Init_int16 (Int.repr 14806) :: Init_int16 (Int.repr 14808) ::
                Init_int16 (Int.repr 14810) :: Init_int16 (Int.repr 14811) ::
                Init_int16 (Int.repr 14813) :: Init_int16 (Int.repr 14815) ::
                Init_int16 (Int.repr 14817) :: Init_int16 (Int.repr 14818) ::
                Init_int16 (Int.repr 14820) :: Init_int16 (Int.repr 14822) ::
                Init_int16 (Int.repr 14823) :: Init_int16 (Int.repr 14825) ::
                Init_int16 (Int.repr 14827) :: Init_int16 (Int.repr 14828) ::
                Init_int16 (Int.repr 14830) :: Init_int16 (Int.repr 14832) ::
                Init_int16 (Int.repr 14834) :: Init_int16 (Int.repr 14835) ::
                Init_int16 (Int.repr 14837) :: Init_int16 (Int.repr 14839) ::
                Init_int16 (Int.repr 14840) :: Init_int16 (Int.repr 14842) ::
                Init_int16 (Int.repr 14844) :: Init_int16 (Int.repr 14845) ::
                Init_int16 (Int.repr 14847) :: Init_int16 (Int.repr 14849) ::
                Init_int16 (Int.repr 14851) :: Init_int16 (Int.repr 14852) ::
                Init_int16 (Int.repr 14854) :: Init_int16 (Int.repr 14856) ::
                Init_int16 (Int.repr 14857) :: Init_int16 (Int.repr 14859) ::
                Init_int16 (Int.repr 14861) :: Init_int16 (Int.repr 14862) ::
                Init_int16 (Int.repr 14864) :: Init_int16 (Int.repr 14866) ::
                Init_int16 (Int.repr 14867) :: Init_int16 (Int.repr 14869) ::
                Init_int16 (Int.repr 14871) :: Init_int16 (Int.repr 14872) ::
                Init_int16 (Int.repr 14874) :: Init_int16 (Int.repr 14876) ::
                Init_int16 (Int.repr 14877) :: Init_int16 (Int.repr 14879) ::
                Init_int16 (Int.repr 14881) :: Init_int16 (Int.repr 14882) ::
                Init_int16 (Int.repr 14884) :: Init_int16 (Int.repr 14886) ::
                Init_int16 (Int.repr 14887) :: Init_int16 (Int.repr 14889) ::
                Init_int16 (Int.repr 14891) :: Init_int16 (Int.repr 14892) ::
                Init_int16 (Int.repr 14894) :: Init_int16 (Int.repr 14896) ::
                Init_int16 (Int.repr 14897) :: Init_int16 (Int.repr 14899) ::
                Init_int16 (Int.repr 14901) :: Init_int16 (Int.repr 14902) ::
                Init_int16 (Int.repr 14904) :: Init_int16 (Int.repr 14906) ::
                Init_int16 (Int.repr 14907) :: Init_int16 (Int.repr 14909) ::
                Init_int16 (Int.repr 14911) :: Init_int16 (Int.repr 14912) ::
                Init_int16 (Int.repr 14914) :: Init_int16 (Int.repr 14916) ::
                Init_int16 (Int.repr 14917) :: Init_int16 (Int.repr 14919) ::
                Init_int16 (Int.repr 14921) :: Init_int16 (Int.repr 14922) ::
                Init_int16 (Int.repr 14924) :: Init_int16 (Int.repr 14926) ::
                Init_int16 (Int.repr 14927) :: Init_int16 (Int.repr 14929) ::
                Init_int16 (Int.repr 14931) :: Init_int16 (Int.repr 14932) ::
                Init_int16 (Int.repr 14934) :: Init_int16 (Int.repr 14936) ::
                Init_int16 (Int.repr 14937) :: Init_int16 (Int.repr 14939) ::
                Init_int16 (Int.repr 14940) :: Init_int16 (Int.repr 14942) ::
                Init_int16 (Int.repr 14944) :: Init_int16 (Int.repr 14945) ::
                Init_int16 (Int.repr 14947) :: Init_int16 (Int.repr 14949) ::
                Init_int16 (Int.repr 14950) :: Init_int16 (Int.repr 14952) ::
                Init_int16 (Int.repr 14954) :: Init_int16 (Int.repr 14955) ::
                Init_int16 (Int.repr 14957) :: Init_int16 (Int.repr 14958) ::
                Init_int16 (Int.repr 14960) :: Init_int16 (Int.repr 14962) ::
                Init_int16 (Int.repr 14963) :: Init_int16 (Int.repr 14965) ::
                Init_int16 (Int.repr 14967) :: Init_int16 (Int.repr 14968) ::
                Init_int16 (Int.repr 14970) :: Init_int16 (Int.repr 14971) ::
                Init_int16 (Int.repr 14973) :: Init_int16 (Int.repr 14975) ::
                Init_int16 (Int.repr 14976) :: Init_int16 (Int.repr 14978) ::
                Init_int16 (Int.repr 14980) :: Init_int16 (Int.repr 14981) ::
                Init_int16 (Int.repr 14983) :: Init_int16 (Int.repr 14984) ::
                Init_int16 (Int.repr 14986) :: Init_int16 (Int.repr 14988) ::
                Init_int16 (Int.repr 14989) :: Init_int16 (Int.repr 14991) ::
                Init_int16 (Int.repr 14993) :: Init_int16 (Int.repr 14994) ::
                Init_int16 (Int.repr 14996) :: Init_int16 (Int.repr 14997) ::
                Init_int16 (Int.repr 14999) :: Init_int16 (Int.repr 15001) ::
                Init_int16 (Int.repr 15002) :: Init_int16 (Int.repr 15004) ::
                Init_int16 (Int.repr 15005) :: Init_int16 (Int.repr 15007) ::
                Init_int16 (Int.repr 15009) :: Init_int16 (Int.repr 15010) ::
                Init_int16 (Int.repr 15012) :: Init_int16 (Int.repr 15013) ::
                Init_int16 (Int.repr 15015) :: Init_int16 (Int.repr 15017) ::
                Init_int16 (Int.repr 15018) :: Init_int16 (Int.repr 15020) ::
                Init_int16 (Int.repr 15021) :: Init_int16 (Int.repr 15023) ::
                Init_int16 (Int.repr 15025) :: Init_int16 (Int.repr 15026) ::
                Init_int16 (Int.repr 15028) :: Init_int16 (Int.repr 15029) ::
                Init_int16 (Int.repr 15031) :: Init_int16 (Int.repr 15033) ::
                Init_int16 (Int.repr 15034) :: Init_int16 (Int.repr 15036) ::
                Init_int16 (Int.repr 15037) :: Init_int16 (Int.repr 15039) ::
                Init_int16 (Int.repr 15041) :: Init_int16 (Int.repr 15042) ::
                Init_int16 (Int.repr 15044) :: Init_int16 (Int.repr 15045) ::
                Init_int16 (Int.repr 15047) :: Init_int16 (Int.repr 15048) ::
                Init_int16 (Int.repr 15050) :: Init_int16 (Int.repr 15052) ::
                Init_int16 (Int.repr 15053) :: Init_int16 (Int.repr 15055) ::
                Init_int16 (Int.repr 15056) :: Init_int16 (Int.repr 15058) ::
                Init_int16 (Int.repr 15059) :: Init_int16 (Int.repr 15061) ::
                Init_int16 (Int.repr 15063) :: Init_int16 (Int.repr 15064) ::
                Init_int16 (Int.repr 15066) :: Init_int16 (Int.repr 15067) ::
                Init_int16 (Int.repr 15069) :: Init_int16 (Int.repr 15070) ::
                Init_int16 (Int.repr 15072) :: Init_int16 (Int.repr 15074) ::
                Init_int16 (Int.repr 15075) :: Init_int16 (Int.repr 15077) ::
                Init_int16 (Int.repr 15078) :: Init_int16 (Int.repr 15080) ::
                Init_int16 (Int.repr 15081) :: Init_int16 (Int.repr 15083) ::
                Init_int16 (Int.repr 15085) :: Init_int16 (Int.repr 15086) ::
                Init_int16 (Int.repr 15088) :: Init_int16 (Int.repr 15089) ::
                Init_int16 (Int.repr 15091) :: Init_int16 (Int.repr 15092) ::
                Init_int16 (Int.repr 15094) :: Init_int16 (Int.repr 15095) ::
                Init_int16 (Int.repr 15097) :: Init_int16 (Int.repr 15099) ::
                Init_int16 (Int.repr 15100) :: Init_int16 (Int.repr 15102) ::
                Init_int16 (Int.repr 15103) :: Init_int16 (Int.repr 15105) ::
                Init_int16 (Int.repr 15106) :: Init_int16 (Int.repr 15108) ::
                Init_int16 (Int.repr 15109) :: Init_int16 (Int.repr 15111) ::
                Init_int16 (Int.repr 15113) :: Init_int16 (Int.repr 15114) ::
                Init_int16 (Int.repr 15116) :: Init_int16 (Int.repr 15117) ::
                Init_int16 (Int.repr 15119) :: Init_int16 (Int.repr 15120) ::
                Init_int16 (Int.repr 15122) :: Init_int16 (Int.repr 15123) ::
                Init_int16 (Int.repr 15125) :: Init_int16 (Int.repr 15126) ::
                Init_int16 (Int.repr 15128) :: Init_int16 (Int.repr 15129) ::
                Init_int16 (Int.repr 15131) :: Init_int16 (Int.repr 15133) ::
                Init_int16 (Int.repr 15134) :: Init_int16 (Int.repr 15136) ::
                Init_int16 (Int.repr 15137) :: Init_int16 (Int.repr 15139) ::
                Init_int16 (Int.repr 15140) :: Init_int16 (Int.repr 15142) ::
                Init_int16 (Int.repr 15143) :: Init_int16 (Int.repr 15145) ::
                Init_int16 (Int.repr 15146) :: Init_int16 (Int.repr 15148) ::
                Init_int16 (Int.repr 15149) :: Init_int16 (Int.repr 15151) ::
                Init_int16 (Int.repr 15152) :: Init_int16 (Int.repr 15154) ::
                Init_int16 (Int.repr 15155) :: Init_int16 (Int.repr 15157) ::
                Init_int16 (Int.repr 15158) :: Init_int16 (Int.repr 15160) ::
                Init_int16 (Int.repr 15161) :: Init_int16 (Int.repr 15163) ::
                Init_int16 (Int.repr 15165) :: Init_int16 (Int.repr 15166) ::
                Init_int16 (Int.repr 15168) :: Init_int16 (Int.repr 15169) ::
                Init_int16 (Int.repr 15171) :: Init_int16 (Int.repr 15172) ::
                Init_int16 (Int.repr 15174) :: Init_int16 (Int.repr 15175) ::
                Init_int16 (Int.repr 15177) :: Init_int16 (Int.repr 15178) ::
                Init_int16 (Int.repr 15180) :: Init_int16 (Int.repr 15181) ::
                Init_int16 (Int.repr 15183) :: Init_int16 (Int.repr 15184) ::
                Init_int16 (Int.repr 15186) :: Init_int16 (Int.repr 15187) ::
                Init_int16 (Int.repr 15189) :: Init_int16 (Int.repr 15190) ::
                Init_int16 (Int.repr 15192) :: Init_int16 (Int.repr 15193) ::
                Init_int16 (Int.repr 15195) :: Init_int16 (Int.repr 15196) ::
                Init_int16 (Int.repr 15198) :: Init_int16 (Int.repr 15199) ::
                Init_int16 (Int.repr 15201) :: Init_int16 (Int.repr 15202) ::
                Init_int16 (Int.repr 15204) :: Init_int16 (Int.repr 15205) ::
                Init_int16 (Int.repr 15207) :: Init_int16 (Int.repr 15208) ::
                Init_int16 (Int.repr 15210) :: Init_int16 (Int.repr 15211) ::
                Init_int16 (Int.repr 15213) :: Init_int16 (Int.repr 15214) ::
                Init_int16 (Int.repr 15215) :: Init_int16 (Int.repr 15217) ::
                Init_int16 (Int.repr 15218) :: Init_int16 (Int.repr 15220) ::
                Init_int16 (Int.repr 15221) :: Init_int16 (Int.repr 15223) ::
                Init_int16 (Int.repr 15224) :: Init_int16 (Int.repr 15226) ::
                Init_int16 (Int.repr 15227) :: Init_int16 (Int.repr 15229) ::
                Init_int16 (Int.repr 15230) :: Init_int16 (Int.repr 15232) ::
                Init_int16 (Int.repr 15233) :: Init_int16 (Int.repr 15235) ::
                Init_int16 (Int.repr 15236) :: Init_int16 (Int.repr 15238) ::
                Init_int16 (Int.repr 15239) :: Init_int16 (Int.repr 15241) ::
                Init_int16 (Int.repr 15242) :: Init_int16 (Int.repr 15243) ::
                Init_int16 (Int.repr 15245) :: Init_int16 (Int.repr 15246) ::
                Init_int16 (Int.repr 15248) :: Init_int16 (Int.repr 15249) ::
                Init_int16 (Int.repr 15251) :: Init_int16 (Int.repr 15252) ::
                Init_int16 (Int.repr 15254) :: Init_int16 (Int.repr 15255) ::
                Init_int16 (Int.repr 15257) :: Init_int16 (Int.repr 15258) ::
                Init_int16 (Int.repr 15260) :: Init_int16 (Int.repr 15261) ::
                Init_int16 (Int.repr 15262) :: Init_int16 (Int.repr 15264) ::
                Init_int16 (Int.repr 15265) :: Init_int16 (Int.repr 15267) ::
                Init_int16 (Int.repr 15268) :: Init_int16 (Int.repr 15270) ::
                Init_int16 (Int.repr 15271) :: Init_int16 (Int.repr 15273) ::
                Init_int16 (Int.repr 15274) :: Init_int16 (Int.repr 15276) ::
                Init_int16 (Int.repr 15277) :: Init_int16 (Int.repr 15278) ::
                Init_int16 (Int.repr 15280) :: Init_int16 (Int.repr 15281) ::
                Init_int16 (Int.repr 15283) :: Init_int16 (Int.repr 15284) ::
                Init_int16 (Int.repr 15286) :: Init_int16 (Int.repr 15287) ::
                Init_int16 (Int.repr 15289) :: Init_int16 (Int.repr 15290) ::
                Init_int16 (Int.repr 15291) :: Init_int16 (Int.repr 15293) ::
                Init_int16 (Int.repr 15294) :: Init_int16 (Int.repr 15296) ::
                Init_int16 (Int.repr 15297) :: Init_int16 (Int.repr 15299) ::
                Init_int16 (Int.repr 15300) :: Init_int16 (Int.repr 15301) ::
                Init_int16 (Int.repr 15303) :: Init_int16 (Int.repr 15304) ::
                Init_int16 (Int.repr 15306) :: Init_int16 (Int.repr 15307) ::
                Init_int16 (Int.repr 15309) :: Init_int16 (Int.repr 15310) ::
                Init_int16 (Int.repr 15311) :: Init_int16 (Int.repr 15313) ::
                Init_int16 (Int.repr 15314) :: Init_int16 (Int.repr 15316) ::
                Init_int16 (Int.repr 15317) :: Init_int16 (Int.repr 15318) ::
                Init_int16 (Int.repr 15320) :: Init_int16 (Int.repr 15321) ::
                Init_int16 (Int.repr 15323) :: Init_int16 (Int.repr 15324) ::
                Init_int16 (Int.repr 15326) :: Init_int16 (Int.repr 15327) ::
                Init_int16 (Int.repr 15328) :: Init_int16 (Int.repr 15330) ::
                Init_int16 (Int.repr 15331) :: Init_int16 (Int.repr 15333) ::
                Init_int16 (Int.repr 15334) :: Init_int16 (Int.repr 15335) ::
                Init_int16 (Int.repr 15337) :: Init_int16 (Int.repr 15338) ::
                Init_int16 (Int.repr 15340) :: Init_int16 (Int.repr 15341) ::
                Init_int16 (Int.repr 15342) :: Init_int16 (Int.repr 15344) ::
                Init_int16 (Int.repr 15345) :: Init_int16 (Int.repr 15347) ::
                Init_int16 (Int.repr 15348) :: Init_int16 (Int.repr 15349) ::
                Init_int16 (Int.repr 15351) :: Init_int16 (Int.repr 15352) ::
                Init_int16 (Int.repr 15354) :: Init_int16 (Int.repr 15355) ::
                Init_int16 (Int.repr 15356) :: Init_int16 (Int.repr 15358) ::
                Init_int16 (Int.repr 15359) :: Init_int16 (Int.repr 15361) ::
                Init_int16 (Int.repr 15362) :: Init_int16 (Int.repr 15363) ::
                Init_int16 (Int.repr 15365) :: Init_int16 (Int.repr 15366) ::
                Init_int16 (Int.repr 15368) :: Init_int16 (Int.repr 15369) ::
                Init_int16 (Int.repr 15370) :: Init_int16 (Int.repr 15372) ::
                Init_int16 (Int.repr 15373) :: Init_int16 (Int.repr 15375) ::
                Init_int16 (Int.repr 15376) :: Init_int16 (Int.repr 15377) ::
                Init_int16 (Int.repr 15379) :: Init_int16 (Int.repr 15380) ::
                Init_int16 (Int.repr 15381) :: Init_int16 (Int.repr 15383) ::
                Init_int16 (Int.repr 15384) :: Init_int16 (Int.repr 15386) ::
                Init_int16 (Int.repr 15387) :: Init_int16 (Int.repr 15388) ::
                Init_int16 (Int.repr 15390) :: Init_int16 (Int.repr 15391) ::
                Init_int16 (Int.repr 15392) :: Init_int16 (Int.repr 15394) ::
                Init_int16 (Int.repr 15395) :: Init_int16 (Int.repr 15397) ::
                Init_int16 (Int.repr 15398) :: Init_int16 (Int.repr 15399) ::
                Init_int16 (Int.repr 15401) :: Init_int16 (Int.repr 15402) ::
                Init_int16 (Int.repr 15403) :: Init_int16 (Int.repr 15405) ::
                Init_int16 (Int.repr 15406) :: Init_int16 (Int.repr 15407) ::
                Init_int16 (Int.repr 15409) :: Init_int16 (Int.repr 15410) ::
                Init_int16 (Int.repr 15411) :: Init_int16 (Int.repr 15413) ::
                Init_int16 (Int.repr 15414) :: Init_int16 (Int.repr 15416) ::
                Init_int16 (Int.repr 15417) :: Init_int16 (Int.repr 15418) ::
                Init_int16 (Int.repr 15420) :: Init_int16 (Int.repr 15421) ::
                Init_int16 (Int.repr 15422) :: Init_int16 (Int.repr 15424) ::
                Init_int16 (Int.repr 15425) :: Init_int16 (Int.repr 15426) ::
                Init_int16 (Int.repr 15428) :: Init_int16 (Int.repr 15429) ::
                Init_int16 (Int.repr 15430) :: Init_int16 (Int.repr 15432) ::
                Init_int16 (Int.repr 15433) :: Init_int16 (Int.repr 15434) ::
                Init_int16 (Int.repr 15436) :: Init_int16 (Int.repr 15437) ::
                Init_int16 (Int.repr 15438) :: Init_int16 (Int.repr 15440) ::
                Init_int16 (Int.repr 15441) :: Init_int16 (Int.repr 15442) ::
                Init_int16 (Int.repr 15444) :: Init_int16 (Int.repr 15445) ::
                Init_int16 (Int.repr 15446) :: Init_int16 (Int.repr 15448) ::
                Init_int16 (Int.repr 15449) :: Init_int16 (Int.repr 15450) ::
                Init_int16 (Int.repr 15452) :: Init_int16 (Int.repr 15453) ::
                Init_int16 (Int.repr 15454) :: Init_int16 (Int.repr 15456) ::
                Init_int16 (Int.repr 15457) :: Init_int16 (Int.repr 15458) ::
                Init_int16 (Int.repr 15460) :: Init_int16 (Int.repr 15461) ::
                Init_int16 (Int.repr 15462) :: Init_int16 (Int.repr 15464) ::
                Init_int16 (Int.repr 15465) :: Init_int16 (Int.repr 15466) ::
                Init_int16 (Int.repr 15468) :: Init_int16 (Int.repr 15469) ::
                Init_int16 (Int.repr 15470) :: Init_int16 (Int.repr 15472) ::
                Init_int16 (Int.repr 15473) :: Init_int16 (Int.repr 15474) ::
                Init_int16 (Int.repr 15476) :: Init_int16 (Int.repr 15477) ::
                Init_int16 (Int.repr 15478) :: Init_int16 (Int.repr 15480) ::
                Init_int16 (Int.repr 15481) :: Init_int16 (Int.repr 15482) ::
                Init_int16 (Int.repr 15483) :: Init_int16 (Int.repr 15485) ::
                Init_int16 (Int.repr 15486) :: Init_int16 (Int.repr 15487) ::
                Init_int16 (Int.repr 15489) :: Init_int16 (Int.repr 15490) ::
                Init_int16 (Int.repr 15491) :: Init_int16 (Int.repr 15493) ::
                Init_int16 (Int.repr 15494) :: Init_int16 (Int.repr 15495) ::
                Init_int16 (Int.repr 15496) :: Init_int16 (Int.repr 15498) ::
                Init_int16 (Int.repr 15499) :: Init_int16 (Int.repr 15500) ::
                Init_int16 (Int.repr 15502) :: Init_int16 (Int.repr 15503) ::
                Init_int16 (Int.repr 15504) :: Init_int16 (Int.repr 15506) ::
                Init_int16 (Int.repr 15507) :: Init_int16 (Int.repr 15508) ::
                Init_int16 (Int.repr 15509) :: Init_int16 (Int.repr 15511) ::
                Init_int16 (Int.repr 15512) :: Init_int16 (Int.repr 15513) ::
                Init_int16 (Int.repr 15515) :: Init_int16 (Int.repr 15516) ::
                Init_int16 (Int.repr 15517) :: Init_int16 (Int.repr 15518) ::
                Init_int16 (Int.repr 15520) :: Init_int16 (Int.repr 15521) ::
                Init_int16 (Int.repr 15522) :: Init_int16 (Int.repr 15524) ::
                Init_int16 (Int.repr 15525) :: Init_int16 (Int.repr 15526) ::
                Init_int16 (Int.repr 15527) :: Init_int16 (Int.repr 15529) ::
                Init_int16 (Int.repr 15530) :: Init_int16 (Int.repr 15531) ::
                Init_int16 (Int.repr 15532) :: Init_int16 (Int.repr 15534) ::
                Init_int16 (Int.repr 15535) :: Init_int16 (Int.repr 15536) ::
                Init_int16 (Int.repr 15538) :: Init_int16 (Int.repr 15539) ::
                Init_int16 (Int.repr 15540) :: Init_int16 (Int.repr 15541) ::
                Init_int16 (Int.repr 15543) :: Init_int16 (Int.repr 15544) ::
                Init_int16 (Int.repr 15545) :: Init_int16 (Int.repr 15546) ::
                Init_int16 (Int.repr 15548) :: Init_int16 (Int.repr 15549) ::
                Init_int16 (Int.repr 15550) :: Init_int16 (Int.repr 15551) ::
                Init_int16 (Int.repr 15553) :: Init_int16 (Int.repr 15554) ::
                Init_int16 (Int.repr 15555) :: Init_int16 (Int.repr 15556) ::
                Init_int16 (Int.repr 15558) :: Init_int16 (Int.repr 15559) ::
                Init_int16 (Int.repr 15560) :: Init_int16 (Int.repr 15561) ::
                Init_int16 (Int.repr 15563) :: Init_int16 (Int.repr 15564) ::
                Init_int16 (Int.repr 15565) :: Init_int16 (Int.repr 15566) ::
                Init_int16 (Int.repr 15568) :: Init_int16 (Int.repr 15569) ::
                Init_int16 (Int.repr 15570) :: Init_int16 (Int.repr 15571) ::
                Init_int16 (Int.repr 15573) :: Init_int16 (Int.repr 15574) ::
                Init_int16 (Int.repr 15575) :: Init_int16 (Int.repr 15576) ::
                Init_int16 (Int.repr 15578) :: Init_int16 (Int.repr 15579) ::
                Init_int16 (Int.repr 15580) :: Init_int16 (Int.repr 15581) ::
                Init_int16 (Int.repr 15583) :: Init_int16 (Int.repr 15584) ::
                Init_int16 (Int.repr 15585) :: Init_int16 (Int.repr 15586) ::
                Init_int16 (Int.repr 15588) :: Init_int16 (Int.repr 15589) ::
                Init_int16 (Int.repr 15590) :: Init_int16 (Int.repr 15591) ::
                Init_int16 (Int.repr 15592) :: Init_int16 (Int.repr 15594) ::
                Init_int16 (Int.repr 15595) :: Init_int16 (Int.repr 15596) ::
                Init_int16 (Int.repr 15597) :: Init_int16 (Int.repr 15599) ::
                Init_int16 (Int.repr 15600) :: Init_int16 (Int.repr 15601) ::
                Init_int16 (Int.repr 15602) :: Init_int16 (Int.repr 15603) ::
                Init_int16 (Int.repr 15605) :: Init_int16 (Int.repr 15606) ::
                Init_int16 (Int.repr 15607) :: Init_int16 (Int.repr 15608) ::
                Init_int16 (Int.repr 15610) :: Init_int16 (Int.repr 15611) ::
                Init_int16 (Int.repr 15612) :: Init_int16 (Int.repr 15613) ::
                Init_int16 (Int.repr 15614) :: Init_int16 (Int.repr 15616) ::
                Init_int16 (Int.repr 15617) :: Init_int16 (Int.repr 15618) ::
                Init_int16 (Int.repr 15619) :: Init_int16 (Int.repr 15620) ::
                Init_int16 (Int.repr 15622) :: Init_int16 (Int.repr 15623) ::
                Init_int16 (Int.repr 15624) :: Init_int16 (Int.repr 15625) ::
                Init_int16 (Int.repr 15626) :: Init_int16 (Int.repr 15628) ::
                Init_int16 (Int.repr 15629) :: Init_int16 (Int.repr 15630) ::
                Init_int16 (Int.repr 15631) :: Init_int16 (Int.repr 15632) ::
                Init_int16 (Int.repr 15634) :: Init_int16 (Int.repr 15635) ::
                Init_int16 (Int.repr 15636) :: Init_int16 (Int.repr 15637) ::
                Init_int16 (Int.repr 15638) :: Init_int16 (Int.repr 15640) ::
                Init_int16 (Int.repr 15641) :: Init_int16 (Int.repr 15642) ::
                Init_int16 (Int.repr 15643) :: Init_int16 (Int.repr 15644) ::
                Init_int16 (Int.repr 15646) :: Init_int16 (Int.repr 15647) ::
                Init_int16 (Int.repr 15648) :: Init_int16 (Int.repr 15649) ::
                Init_int16 (Int.repr 15650) :: Init_int16 (Int.repr 15652) ::
                Init_int16 (Int.repr 15653) :: Init_int16 (Int.repr 15654) ::
                Init_int16 (Int.repr 15655) :: Init_int16 (Int.repr 15656) ::
                Init_int16 (Int.repr 15657) :: Init_int16 (Int.repr 15659) ::
                Init_int16 (Int.repr 15660) :: Init_int16 (Int.repr 15661) ::
                Init_int16 (Int.repr 15662) :: Init_int16 (Int.repr 15663) ::
                Init_int16 (Int.repr 15664) :: Init_int16 (Int.repr 15666) ::
                Init_int16 (Int.repr 15667) :: Init_int16 (Int.repr 15668) ::
                Init_int16 (Int.repr 15669) :: Init_int16 (Int.repr 15670) ::
                Init_int16 (Int.repr 15671) :: Init_int16 (Int.repr 15673) ::
                Init_int16 (Int.repr 15674) :: Init_int16 (Int.repr 15675) ::
                Init_int16 (Int.repr 15676) :: Init_int16 (Int.repr 15677) ::
                Init_int16 (Int.repr 15678) :: Init_int16 (Int.repr 15680) ::
                Init_int16 (Int.repr 15681) :: Init_int16 (Int.repr 15682) ::
                Init_int16 (Int.repr 15683) :: Init_int16 (Int.repr 15684) ::
                Init_int16 (Int.repr 15685) :: Init_int16 (Int.repr 15687) ::
                Init_int16 (Int.repr 15688) :: Init_int16 (Int.repr 15689) ::
                Init_int16 (Int.repr 15690) :: Init_int16 (Int.repr 15691) ::
                Init_int16 (Int.repr 15692) :: Init_int16 (Int.repr 15693) ::
                Init_int16 (Int.repr 15695) :: Init_int16 (Int.repr 15696) ::
                Init_int16 (Int.repr 15697) :: Init_int16 (Int.repr 15698) ::
                Init_int16 (Int.repr 15699) :: Init_int16 (Int.repr 15700) ::
                Init_int16 (Int.repr 15701) :: Init_int16 (Int.repr 15703) ::
                Init_int16 (Int.repr 15704) :: Init_int16 (Int.repr 15705) ::
                Init_int16 (Int.repr 15706) :: Init_int16 (Int.repr 15707) ::
                Init_int16 (Int.repr 15708) :: Init_int16 (Int.repr 15709) ::
                Init_int16 (Int.repr 15711) :: Init_int16 (Int.repr 15712) ::
                Init_int16 (Int.repr 15713) :: Init_int16 (Int.repr 15714) ::
                Init_int16 (Int.repr 15715) :: Init_int16 (Int.repr 15716) ::
                Init_int16 (Int.repr 15717) :: Init_int16 (Int.repr 15719) ::
                Init_int16 (Int.repr 15720) :: Init_int16 (Int.repr 15721) ::
                Init_int16 (Int.repr 15722) :: Init_int16 (Int.repr 15723) ::
                Init_int16 (Int.repr 15724) :: Init_int16 (Int.repr 15725) ::
                Init_int16 (Int.repr 15726) :: Init_int16 (Int.repr 15728) ::
                Init_int16 (Int.repr 15729) :: Init_int16 (Int.repr 15730) ::
                Init_int16 (Int.repr 15731) :: Init_int16 (Int.repr 15732) ::
                Init_int16 (Int.repr 15733) :: Init_int16 (Int.repr 15734) ::
                Init_int16 (Int.repr 15735) :: Init_int16 (Int.repr 15736) ::
                Init_int16 (Int.repr 15738) :: Init_int16 (Int.repr 15739) ::
                Init_int16 (Int.repr 15740) :: Init_int16 (Int.repr 15741) ::
                Init_int16 (Int.repr 15742) :: Init_int16 (Int.repr 15743) ::
                Init_int16 (Int.repr 15744) :: Init_int16 (Int.repr 15745) ::
                Init_int16 (Int.repr 15746) :: Init_int16 (Int.repr 15748) ::
                Init_int16 (Int.repr 15749) :: Init_int16 (Int.repr 15750) ::
                Init_int16 (Int.repr 15751) :: Init_int16 (Int.repr 15752) ::
                Init_int16 (Int.repr 15753) :: Init_int16 (Int.repr 15754) ::
                Init_int16 (Int.repr 15755) :: Init_int16 (Int.repr 15756) ::
                Init_int16 (Int.repr 15757) :: Init_int16 (Int.repr 15759) ::
                Init_int16 (Int.repr 15760) :: Init_int16 (Int.repr 15761) ::
                Init_int16 (Int.repr 15762) :: Init_int16 (Int.repr 15763) ::
                Init_int16 (Int.repr 15764) :: Init_int16 (Int.repr 15765) ::
                Init_int16 (Int.repr 15766) :: Init_int16 (Int.repr 15767) ::
                Init_int16 (Int.repr 15768) :: Init_int16 (Int.repr 15769) ::
                Init_int16 (Int.repr 15770) :: Init_int16 (Int.repr 15772) ::
                Init_int16 (Int.repr 15773) :: Init_int16 (Int.repr 15774) ::
                Init_int16 (Int.repr 15775) :: Init_int16 (Int.repr 15776) ::
                Init_int16 (Int.repr 15777) :: Init_int16 (Int.repr 15778) ::
                Init_int16 (Int.repr 15779) :: Init_int16 (Int.repr 15780) ::
                Init_int16 (Int.repr 15781) :: Init_int16 (Int.repr 15782) ::
                Init_int16 (Int.repr 15783) :: Init_int16 (Int.repr 15785) ::
                Init_int16 (Int.repr 15786) :: Init_int16 (Int.repr 15787) ::
                Init_int16 (Int.repr 15788) :: Init_int16 (Int.repr 15789) ::
                Init_int16 (Int.repr 15790) :: Init_int16 (Int.repr 15791) ::
                Init_int16 (Int.repr 15792) :: Init_int16 (Int.repr 15793) ::
                Init_int16 (Int.repr 15794) :: Init_int16 (Int.repr 15795) ::
                Init_int16 (Int.repr 15796) :: Init_int16 (Int.repr 15797) ::
                Init_int16 (Int.repr 15798) :: Init_int16 (Int.repr 15799) ::
                Init_int16 (Int.repr 15800) :: Init_int16 (Int.repr 15802) ::
                Init_int16 (Int.repr 15803) :: Init_int16 (Int.repr 15804) ::
                Init_int16 (Int.repr 15805) :: Init_int16 (Int.repr 15806) ::
                Init_int16 (Int.repr 15807) :: Init_int16 (Int.repr 15808) ::
                Init_int16 (Int.repr 15809) :: Init_int16 (Int.repr 15810) ::
                Init_int16 (Int.repr 15811) :: Init_int16 (Int.repr 15812) ::
                Init_int16 (Int.repr 15813) :: Init_int16 (Int.repr 15814) ::
                Init_int16 (Int.repr 15815) :: Init_int16 (Int.repr 15816) ::
                Init_int16 (Int.repr 15817) :: Init_int16 (Int.repr 15818) ::
                Init_int16 (Int.repr 15819) :: Init_int16 (Int.repr 15820) ::
                Init_int16 (Int.repr 15821) :: Init_int16 (Int.repr 15822) ::
                Init_int16 (Int.repr 15824) :: Init_int16 (Int.repr 15825) ::
                Init_int16 (Int.repr 15826) :: Init_int16 (Int.repr 15827) ::
                Init_int16 (Int.repr 15828) :: Init_int16 (Int.repr 15829) ::
                Init_int16 (Int.repr 15830) :: Init_int16 (Int.repr 15831) ::
                Init_int16 (Int.repr 15832) :: Init_int16 (Int.repr 15833) ::
                Init_int16 (Int.repr 15834) :: Init_int16 (Int.repr 15835) ::
                Init_int16 (Int.repr 15836) :: Init_int16 (Int.repr 15837) ::
                Init_int16 (Int.repr 15838) :: Init_int16 (Int.repr 15839) ::
                Init_int16 (Int.repr 15840) :: Init_int16 (Int.repr 15841) ::
                Init_int16 (Int.repr 15842) :: Init_int16 (Int.repr 15843) ::
                Init_int16 (Int.repr 15844) :: Init_int16 (Int.repr 15845) ::
                Init_int16 (Int.repr 15846) :: Init_int16 (Int.repr 15847) ::
                Init_int16 (Int.repr 15848) :: Init_int16 (Int.repr 15849) ::
                Init_int16 (Int.repr 15850) :: Init_int16 (Int.repr 15851) ::
                Init_int16 (Int.repr 15852) :: Init_int16 (Int.repr 15853) ::
                Init_int16 (Int.repr 15854) :: Init_int16 (Int.repr 15855) ::
                Init_int16 (Int.repr 15856) :: Init_int16 (Int.repr 15857) ::
                Init_int16 (Int.repr 15858) :: Init_int16 (Int.repr 15859) ::
                Init_int16 (Int.repr 15860) :: Init_int16 (Int.repr 15861) ::
                Init_int16 (Int.repr 15862) :: Init_int16 (Int.repr 15863) ::
                Init_int16 (Int.repr 15864) :: Init_int16 (Int.repr 15865) ::
                Init_int16 (Int.repr 15866) :: Init_int16 (Int.repr 15867) ::
                Init_int16 (Int.repr 15868) :: Init_int16 (Int.repr 15869) ::
                Init_int16 (Int.repr 15870) :: Init_int16 (Int.repr 15871) ::
                Init_int16 (Int.repr 15872) :: Init_int16 (Int.repr 15873) ::
                Init_int16 (Int.repr 15874) :: Init_int16 (Int.repr 15875) ::
                Init_int16 (Int.repr 15876) :: Init_int16 (Int.repr 15877) ::
                Init_int16 (Int.repr 15878) :: Init_int16 (Int.repr 15879) ::
                Init_int16 (Int.repr 15880) :: Init_int16 (Int.repr 15881) ::
                Init_int16 (Int.repr 15882) :: Init_int16 (Int.repr 15883) ::
                Init_int16 (Int.repr 15884) :: Init_int16 (Int.repr 15885) ::
                Init_int16 (Int.repr 15886) :: Init_int16 (Int.repr 15887) ::
                Init_int16 (Int.repr 15888) :: Init_int16 (Int.repr 15889) ::
                Init_int16 (Int.repr 15890) :: Init_int16 (Int.repr 15891) ::
                Init_int16 (Int.repr 15892) :: Init_int16 (Int.repr 15893) ::
                Init_int16 (Int.repr 15894) :: Init_int16 (Int.repr 15895) ::
                Init_int16 (Int.repr 15896) :: Init_int16 (Int.repr 15897) ::
                Init_int16 (Int.repr 15898) :: Init_int16 (Int.repr 15899) ::
                Init_int16 (Int.repr 15900) :: Init_int16 (Int.repr 15901) ::
                Init_int16 (Int.repr 15902) :: Init_int16 (Int.repr 15902) ::
                Init_int16 (Int.repr 15903) :: Init_int16 (Int.repr 15904) ::
                Init_int16 (Int.repr 15905) :: Init_int16 (Int.repr 15906) ::
                Init_int16 (Int.repr 15907) :: Init_int16 (Int.repr 15908) ::
                Init_int16 (Int.repr 15909) :: Init_int16 (Int.repr 15910) ::
                Init_int16 (Int.repr 15911) :: Init_int16 (Int.repr 15912) ::
                Init_int16 (Int.repr 15913) :: Init_int16 (Int.repr 15914) ::
                Init_int16 (Int.repr 15915) :: Init_int16 (Int.repr 15916) ::
                Init_int16 (Int.repr 15917) :: Init_int16 (Int.repr 15918) ::
                Init_int16 (Int.repr 15919) :: Init_int16 (Int.repr 15920) ::
                Init_int16 (Int.repr 15921) :: Init_int16 (Int.repr 15922) ::
                Init_int16 (Int.repr 15922) :: Init_int16 (Int.repr 15923) ::
                Init_int16 (Int.repr 15924) :: Init_int16 (Int.repr 15925) ::
                Init_int16 (Int.repr 15926) :: Init_int16 (Int.repr 15927) ::
                Init_int16 (Int.repr 15928) :: Init_int16 (Int.repr 15929) ::
                Init_int16 (Int.repr 15930) :: Init_int16 (Int.repr 15931) ::
                Init_int16 (Int.repr 15932) :: Init_int16 (Int.repr 15933) ::
                Init_int16 (Int.repr 15934) :: Init_int16 (Int.repr 15935) ::
                Init_int16 (Int.repr 15936) :: Init_int16 (Int.repr 15937) ::
                Init_int16 (Int.repr 15937) :: Init_int16 (Int.repr 15938) ::
                Init_int16 (Int.repr 15939) :: Init_int16 (Int.repr 15940) ::
                Init_int16 (Int.repr 15941) :: Init_int16 (Int.repr 15942) ::
                Init_int16 (Int.repr 15943) :: Init_int16 (Int.repr 15944) ::
                Init_int16 (Int.repr 15945) :: Init_int16 (Int.repr 15946) ::
                Init_int16 (Int.repr 15947) :: Init_int16 (Int.repr 15948) ::
                Init_int16 (Int.repr 15948) :: Init_int16 (Int.repr 15949) ::
                Init_int16 (Int.repr 15950) :: Init_int16 (Int.repr 15951) ::
                Init_int16 (Int.repr 15952) :: Init_int16 (Int.repr 15953) ::
                Init_int16 (Int.repr 15954) :: Init_int16 (Int.repr 15955) ::
                Init_int16 (Int.repr 15956) :: Init_int16 (Int.repr 15957) ::
                Init_int16 (Int.repr 15958) :: Init_int16 (Int.repr 15958) ::
                Init_int16 (Int.repr 15959) :: Init_int16 (Int.repr 15960) ::
                Init_int16 (Int.repr 15961) :: Init_int16 (Int.repr 15962) ::
                Init_int16 (Int.repr 15963) :: Init_int16 (Int.repr 15964) ::
                Init_int16 (Int.repr 15965) :: Init_int16 (Int.repr 15966) ::
                Init_int16 (Int.repr 15967) :: Init_int16 (Int.repr 15968) ::
                Init_int16 (Int.repr 15968) :: Init_int16 (Int.repr 15969) ::
                Init_int16 (Int.repr 15970) :: Init_int16 (Int.repr 15971) ::
                Init_int16 (Int.repr 15972) :: Init_int16 (Int.repr 15973) ::
                Init_int16 (Int.repr 15974) :: Init_int16 (Int.repr 15975) ::
                Init_int16 (Int.repr 15976) :: Init_int16 (Int.repr 15976) ::
                Init_int16 (Int.repr 15977) :: Init_int16 (Int.repr 15978) ::
                Init_int16 (Int.repr 15979) :: Init_int16 (Int.repr 15980) ::
                Init_int16 (Int.repr 15981) :: Init_int16 (Int.repr 15982) ::
                Init_int16 (Int.repr 15983) :: Init_int16 (Int.repr 15983) ::
                Init_int16 (Int.repr 15984) :: Init_int16 (Int.repr 15985) ::
                Init_int16 (Int.repr 15986) :: Init_int16 (Int.repr 15987) ::
                Init_int16 (Int.repr 15988) :: Init_int16 (Int.repr 15989) ::
                Init_int16 (Int.repr 15990) :: Init_int16 (Int.repr 15990) ::
                Init_int16 (Int.repr 15991) :: Init_int16 (Int.repr 15992) ::
                Init_int16 (Int.repr 15993) :: Init_int16 (Int.repr 15994) ::
                Init_int16 (Int.repr 15995) :: Init_int16 (Int.repr 15996) ::
                Init_int16 (Int.repr 15997) :: Init_int16 (Int.repr 15997) ::
                Init_int16 (Int.repr 15998) :: Init_int16 (Int.repr 15999) ::
                Init_int16 (Int.repr 16000) :: Init_int16 (Int.repr 16001) ::
                Init_int16 (Int.repr 16002) :: Init_int16 (Int.repr 16003) ::
                Init_int16 (Int.repr 16003) :: Init_int16 (Int.repr 16004) ::
                Init_int16 (Int.repr 16005) :: Init_int16 (Int.repr 16006) ::
                Init_int16 (Int.repr 16007) :: Init_int16 (Int.repr 16008) ::
                Init_int16 (Int.repr 16009) :: Init_int16 (Int.repr 16009) ::
                Init_int16 (Int.repr 16010) :: Init_int16 (Int.repr 16011) ::
                Init_int16 (Int.repr 16012) :: Init_int16 (Int.repr 16013) ::
                Init_int16 (Int.repr 16014) :: Init_int16 (Int.repr 16014) ::
                Init_int16 (Int.repr 16015) :: Init_int16 (Int.repr 16016) ::
                Init_int16 (Int.repr 16017) :: Init_int16 (Int.repr 16018) ::
                Init_int16 (Int.repr 16019) :: Init_int16 (Int.repr 16020) ::
                Init_int16 (Int.repr 16020) :: Init_int16 (Int.repr 16021) ::
                Init_int16 (Int.repr 16022) :: Init_int16 (Int.repr 16023) ::
                Init_int16 (Int.repr 16024) :: Init_int16 (Int.repr 16025) ::
                Init_int16 (Int.repr 16025) :: Init_int16 (Int.repr 16026) ::
                Init_int16 (Int.repr 16027) :: Init_int16 (Int.repr 16028) ::
                Init_int16 (Int.repr 16029) :: Init_int16 (Int.repr 16030) ::
                Init_int16 (Int.repr 16030) :: Init_int16 (Int.repr 16031) ::
                Init_int16 (Int.repr 16032) :: Init_int16 (Int.repr 16033) ::
                Init_int16 (Int.repr 16034) :: Init_int16 (Int.repr 16034) ::
                Init_int16 (Int.repr 16035) :: Init_int16 (Int.repr 16036) ::
                Init_int16 (Int.repr 16037) :: Init_int16 (Int.repr 16038) ::
                Init_int16 (Int.repr 16039) :: Init_int16 (Int.repr 16039) ::
                Init_int16 (Int.repr 16040) :: Init_int16 (Int.repr 16041) ::
                Init_int16 (Int.repr 16042) :: Init_int16 (Int.repr 16043) ::
                Init_int16 (Int.repr 16043) :: Init_int16 (Int.repr 16044) ::
                Init_int16 (Int.repr 16045) :: Init_int16 (Int.repr 16046) ::
                Init_int16 (Int.repr 16047) :: Init_int16 (Int.repr 16047) ::
                Init_int16 (Int.repr 16048) :: Init_int16 (Int.repr 16049) ::
                Init_int16 (Int.repr 16050) :: Init_int16 (Int.repr 16051) ::
                Init_int16 (Int.repr 16051) :: Init_int16 (Int.repr 16052) ::
                Init_int16 (Int.repr 16053) :: Init_int16 (Int.repr 16054) ::
                Init_int16 (Int.repr 16055) :: Init_int16 (Int.repr 16055) ::
                Init_int16 (Int.repr 16056) :: Init_int16 (Int.repr 16057) ::
                Init_int16 (Int.repr 16058) :: Init_int16 (Int.repr 16059) ::
                Init_int16 (Int.repr 16059) :: Init_int16 (Int.repr 16060) ::
                Init_int16 (Int.repr 16061) :: Init_int16 (Int.repr 16062) ::
                Init_int16 (Int.repr 16063) :: Init_int16 (Int.repr 16063) ::
                Init_int16 (Int.repr 16064) :: Init_int16 (Int.repr 16065) ::
                Init_int16 (Int.repr 16066) :: Init_int16 (Int.repr 16067) ::
                Init_int16 (Int.repr 16067) :: Init_int16 (Int.repr 16068) ::
                Init_int16 (Int.repr 16069) :: Init_int16 (Int.repr 16070) ::
                Init_int16 (Int.repr 16070) :: Init_int16 (Int.repr 16071) ::
                Init_int16 (Int.repr 16072) :: Init_int16 (Int.repr 16073) ::
                Init_int16 (Int.repr 16074) :: Init_int16 (Int.repr 16074) ::
                Init_int16 (Int.repr 16075) :: Init_int16 (Int.repr 16076) ::
                Init_int16 (Int.repr 16077) :: Init_int16 (Int.repr 16077) ::
                Init_int16 (Int.repr 16078) :: Init_int16 (Int.repr 16079) ::
                Init_int16 (Int.repr 16080) :: Init_int16 (Int.repr 16080) ::
                Init_int16 (Int.repr 16081) :: Init_int16 (Int.repr 16082) ::
                Init_int16 (Int.repr 16083) :: Init_int16 (Int.repr 16084) ::
                Init_int16 (Int.repr 16084) :: Init_int16 (Int.repr 16085) ::
                Init_int16 (Int.repr 16086) :: Init_int16 (Int.repr 16087) ::
                Init_int16 (Int.repr 16087) :: Init_int16 (Int.repr 16088) ::
                Init_int16 (Int.repr 16089) :: Init_int16 (Int.repr 16090) ::
                Init_int16 (Int.repr 16090) :: Init_int16 (Int.repr 16091) ::
                Init_int16 (Int.repr 16092) :: Init_int16 (Int.repr 16093) ::
                Init_int16 (Int.repr 16093) :: Init_int16 (Int.repr 16094) ::
                Init_int16 (Int.repr 16095) :: Init_int16 (Int.repr 16096) ::
                Init_int16 (Int.repr 16096) :: Init_int16 (Int.repr 16097) ::
                Init_int16 (Int.repr 16098) :: Init_int16 (Int.repr 16099) ::
                Init_int16 (Int.repr 16099) :: Init_int16 (Int.repr 16100) ::
                Init_int16 (Int.repr 16101) :: Init_int16 (Int.repr 16102) ::
                Init_int16 (Int.repr 16102) :: Init_int16 (Int.repr 16103) ::
                Init_int16 (Int.repr 16104) :: Init_int16 (Int.repr 16104) ::
                Init_int16 (Int.repr 16105) :: Init_int16 (Int.repr 16106) ::
                Init_int16 (Int.repr 16107) :: Init_int16 (Int.repr 16107) ::
                Init_int16 (Int.repr 16108) :: Init_int16 (Int.repr 16109) ::
                Init_int16 (Int.repr 16110) :: Init_int16 (Int.repr 16110) ::
                Init_int16 (Int.repr 16111) :: Init_int16 (Int.repr 16112) ::
                Init_int16 (Int.repr 16113) :: Init_int16 (Int.repr 16113) ::
                Init_int16 (Int.repr 16114) :: Init_int16 (Int.repr 16115) ::
                Init_int16 (Int.repr 16115) :: Init_int16 (Int.repr 16116) ::
                Init_int16 (Int.repr 16117) :: Init_int16 (Int.repr 16118) ::
                Init_int16 (Int.repr 16118) :: Init_int16 (Int.repr 16119) ::
                Init_int16 (Int.repr 16120) :: Init_int16 (Int.repr 16120) ::
                Init_int16 (Int.repr 16121) :: Init_int16 (Int.repr 16122) ::
                Init_int16 (Int.repr 16123) :: Init_int16 (Int.repr 16123) ::
                Init_int16 (Int.repr 16124) :: Init_int16 (Int.repr 16125) ::
                Init_int16 (Int.repr 16125) :: Init_int16 (Int.repr 16126) ::
                Init_int16 (Int.repr 16127) :: Init_int16 (Int.repr 16128) ::
                Init_int16 (Int.repr 16128) :: Init_int16 (Int.repr 16129) ::
                Init_int16 (Int.repr 16130) :: Init_int16 (Int.repr 16130) ::
                Init_int16 (Int.repr 16131) :: Init_int16 (Int.repr 16132) ::
                Init_int16 (Int.repr 16132) :: Init_int16 (Int.repr 16133) ::
                Init_int16 (Int.repr 16134) :: Init_int16 (Int.repr 16135) ::
                Init_int16 (Int.repr 16135) :: Init_int16 (Int.repr 16136) ::
                Init_int16 (Int.repr 16137) :: Init_int16 (Int.repr 16137) ::
                Init_int16 (Int.repr 16138) :: Init_int16 (Int.repr 16139) ::
                Init_int16 (Int.repr 16139) :: Init_int16 (Int.repr 16140) ::
                Init_int16 (Int.repr 16141) :: Init_int16 (Int.repr 16141) ::
                Init_int16 (Int.repr 16142) :: Init_int16 (Int.repr 16143) ::
                Init_int16 (Int.repr 16143) :: Init_int16 (Int.repr 16144) ::
                Init_int16 (Int.repr 16145) :: Init_int16 (Int.repr 16146) ::
                Init_int16 (Int.repr 16146) :: Init_int16 (Int.repr 16147) ::
                Init_int16 (Int.repr 16148) :: Init_int16 (Int.repr 16148) ::
                Init_int16 (Int.repr 16149) :: Init_int16 (Int.repr 16150) ::
                Init_int16 (Int.repr 16150) :: Init_int16 (Int.repr 16151) ::
                Init_int16 (Int.repr 16152) :: Init_int16 (Int.repr 16152) ::
                Init_int16 (Int.repr 16153) :: Init_int16 (Int.repr 16154) ::
                Init_int16 (Int.repr 16154) :: Init_int16 (Int.repr 16155) ::
                Init_int16 (Int.repr 16156) :: Init_int16 (Int.repr 16156) ::
                Init_int16 (Int.repr 16157) :: Init_int16 (Int.repr 16158) ::
                Init_int16 (Int.repr 16158) :: Init_int16 (Int.repr 16159) ::
                Init_int16 (Int.repr 16160) :: Init_int16 (Int.repr 16160) ::
                Init_int16 (Int.repr 16161) :: Init_int16 (Int.repr 16162) ::
                Init_int16 (Int.repr 16162) :: Init_int16 (Int.repr 16163) ::
                Init_int16 (Int.repr 16164) :: Init_int16 (Int.repr 16164) ::
                Init_int16 (Int.repr 16165) :: Init_int16 (Int.repr 16165) ::
                Init_int16 (Int.repr 16166) :: Init_int16 (Int.repr 16167) ::
                Init_int16 (Int.repr 16167) :: Init_int16 (Int.repr 16168) ::
                Init_int16 (Int.repr 16169) :: Init_int16 (Int.repr 16169) ::
                Init_int16 (Int.repr 16170) :: Init_int16 (Int.repr 16171) ::
                Init_int16 (Int.repr 16171) :: Init_int16 (Int.repr 16172) ::
                Init_int16 (Int.repr 16173) :: Init_int16 (Int.repr 16173) ::
                Init_int16 (Int.repr 16174) :: Init_int16 (Int.repr 16174) ::
                Init_int16 (Int.repr 16175) :: Init_int16 (Int.repr 16176) ::
                Init_int16 (Int.repr 16176) :: Init_int16 (Int.repr 16177) ::
                Init_int16 (Int.repr 16178) :: Init_int16 (Int.repr 16178) ::
                Init_int16 (Int.repr 16179) :: Init_int16 (Int.repr 16180) ::
                Init_int16 (Int.repr 16180) :: Init_int16 (Int.repr 16181) ::
                Init_int16 (Int.repr 16181) :: Init_int16 (Int.repr 16182) ::
                Init_int16 (Int.repr 16183) :: Init_int16 (Int.repr 16183) ::
                Init_int16 (Int.repr 16184) :: Init_int16 (Int.repr 16185) ::
                Init_int16 (Int.repr 16185) :: Init_int16 (Int.repr 16186) ::
                Init_int16 (Int.repr 16186) :: Init_int16 (Int.repr 16187) ::
                Init_int16 (Int.repr 16188) :: Init_int16 (Int.repr 16188) ::
                Init_int16 (Int.repr 16189) :: Init_int16 (Int.repr 16189) ::
                Init_int16 (Int.repr 16190) :: Init_int16 (Int.repr 16191) ::
                Init_int16 (Int.repr 16191) :: Init_int16 (Int.repr 16192) ::
                Init_int16 (Int.repr 16193) :: Init_int16 (Int.repr 16193) ::
                Init_int16 (Int.repr 16194) :: Init_int16 (Int.repr 16194) ::
                Init_int16 (Int.repr 16195) :: Init_int16 (Int.repr 16196) ::
                Init_int16 (Int.repr 16196) :: Init_int16 (Int.repr 16197) ::
                Init_int16 (Int.repr 16197) :: Init_int16 (Int.repr 16198) ::
                Init_int16 (Int.repr 16199) :: Init_int16 (Int.repr 16199) ::
                Init_int16 (Int.repr 16200) :: Init_int16 (Int.repr 16200) ::
                Init_int16 (Int.repr 16201) :: Init_int16 (Int.repr 16202) ::
                Init_int16 (Int.repr 16202) :: Init_int16 (Int.repr 16203) ::
                Init_int16 (Int.repr 16203) :: Init_int16 (Int.repr 16204) ::
                Init_int16 (Int.repr 16205) :: Init_int16 (Int.repr 16205) ::
                Init_int16 (Int.repr 16206) :: Init_int16 (Int.repr 16206) ::
                Init_int16 (Int.repr 16207) :: Init_int16 (Int.repr 16207) ::
                Init_int16 (Int.repr 16208) :: Init_int16 (Int.repr 16209) ::
                Init_int16 (Int.repr 16209) :: Init_int16 (Int.repr 16210) ::
                Init_int16 (Int.repr 16210) :: Init_int16 (Int.repr 16211) ::
                Init_int16 (Int.repr 16212) :: Init_int16 (Int.repr 16212) ::
                Init_int16 (Int.repr 16213) :: Init_int16 (Int.repr 16213) ::
                Init_int16 (Int.repr 16214) :: Init_int16 (Int.repr 16214) ::
                Init_int16 (Int.repr 16215) :: Init_int16 (Int.repr 16216) ::
                Init_int16 (Int.repr 16216) :: Init_int16 (Int.repr 16217) ::
                Init_int16 (Int.repr 16217) :: Init_int16 (Int.repr 16218) ::
                Init_int16 (Int.repr 16218) :: Init_int16 (Int.repr 16219) ::
                Init_int16 (Int.repr 16220) :: Init_int16 (Int.repr 16220) ::
                Init_int16 (Int.repr 16221) :: Init_int16 (Int.repr 16221) ::
                Init_int16 (Int.repr 16222) :: Init_int16 (Int.repr 16222) ::
                Init_int16 (Int.repr 16223) :: Init_int16 (Int.repr 16223) ::
                Init_int16 (Int.repr 16224) :: Init_int16 (Int.repr 16225) ::
                Init_int16 (Int.repr 16225) :: Init_int16 (Int.repr 16226) ::
                Init_int16 (Int.repr 16226) :: Init_int16 (Int.repr 16227) ::
                Init_int16 (Int.repr 16227) :: Init_int16 (Int.repr 16228) ::
                Init_int16 (Int.repr 16228) :: Init_int16 (Int.repr 16229) ::
                Init_int16 (Int.repr 16230) :: Init_int16 (Int.repr 16230) ::
                Init_int16 (Int.repr 16231) :: Init_int16 (Int.repr 16231) ::
                Init_int16 (Int.repr 16232) :: Init_int16 (Int.repr 16232) ::
                Init_int16 (Int.repr 16233) :: Init_int16 (Int.repr 16233) ::
                Init_int16 (Int.repr 16234) :: Init_int16 (Int.repr 16234) ::
                Init_int16 (Int.repr 16235) :: Init_int16 (Int.repr 16235) ::
                Init_int16 (Int.repr 16236) :: Init_int16 (Int.repr 16237) ::
                Init_int16 (Int.repr 16237) :: Init_int16 (Int.repr 16238) ::
                Init_int16 (Int.repr 16238) :: Init_int16 (Int.repr 16239) ::
                Init_int16 (Int.repr 16239) :: Init_int16 (Int.repr 16240) ::
                Init_int16 (Int.repr 16240) :: Init_int16 (Int.repr 16241) ::
                Init_int16 (Int.repr 16241) :: Init_int16 (Int.repr 16242) ::
                Init_int16 (Int.repr 16242) :: Init_int16 (Int.repr 16243) ::
                Init_int16 (Int.repr 16243) :: Init_int16 (Int.repr 16244) ::
                Init_int16 (Int.repr 16244) :: Init_int16 (Int.repr 16245) ::
                Init_int16 (Int.repr 16246) :: Init_int16 (Int.repr 16246) ::
                Init_int16 (Int.repr 16247) :: Init_int16 (Int.repr 16247) ::
                Init_int16 (Int.repr 16248) :: Init_int16 (Int.repr 16248) ::
                Init_int16 (Int.repr 16249) :: Init_int16 (Int.repr 16249) ::
                Init_int16 (Int.repr 16250) :: Init_int16 (Int.repr 16250) ::
                Init_int16 (Int.repr 16251) :: Init_int16 (Int.repr 16251) ::
                Init_int16 (Int.repr 16252) :: Init_int16 (Int.repr 16252) ::
                Init_int16 (Int.repr 16253) :: Init_int16 (Int.repr 16253) ::
                Init_int16 (Int.repr 16254) :: Init_int16 (Int.repr 16254) ::
                Init_int16 (Int.repr 16255) :: Init_int16 (Int.repr 16255) ::
                Init_int16 (Int.repr 16256) :: Init_int16 (Int.repr 16256) ::
                Init_int16 (Int.repr 16257) :: Init_int16 (Int.repr 16257) ::
                Init_int16 (Int.repr 16258) :: Init_int16 (Int.repr 16258) ::
                Init_int16 (Int.repr 16259) :: Init_int16 (Int.repr 16259) ::
                Init_int16 (Int.repr 16260) :: Init_int16 (Int.repr 16260) ::
                Init_int16 (Int.repr 16261) :: Init_int16 (Int.repr 16261) ::
                Init_int16 (Int.repr 16262) :: Init_int16 (Int.repr 16262) ::
                Init_int16 (Int.repr 16263) :: Init_int16 (Int.repr 16263) ::
                Init_int16 (Int.repr 16264) :: Init_int16 (Int.repr 16264) ::
                Init_int16 (Int.repr 16264) :: Init_int16 (Int.repr 16265) ::
                Init_int16 (Int.repr 16265) :: Init_int16 (Int.repr 16266) ::
                Init_int16 (Int.repr 16266) :: Init_int16 (Int.repr 16267) ::
                Init_int16 (Int.repr 16267) :: Init_int16 (Int.repr 16268) ::
                Init_int16 (Int.repr 16268) :: Init_int16 (Int.repr 16269) ::
                Init_int16 (Int.repr 16269) :: Init_int16 (Int.repr 16270) ::
                Init_int16 (Int.repr 16270) :: Init_int16 (Int.repr 16271) ::
                Init_int16 (Int.repr 16271) :: Init_int16 (Int.repr 16272) ::
                Init_int16 (Int.repr 16272) :: Init_int16 (Int.repr 16273) ::
                Init_int16 (Int.repr 16273) :: Init_int16 (Int.repr 16273) ::
                Init_int16 (Int.repr 16274) :: Init_int16 (Int.repr 16274) ::
                Init_int16 (Int.repr 16275) :: Init_int16 (Int.repr 16275) ::
                Init_int16 (Int.repr 16276) :: Init_int16 (Int.repr 16276) ::
                Init_int16 (Int.repr 16277) :: Init_int16 (Int.repr 16277) ::
                Init_int16 (Int.repr 16278) :: Init_int16 (Int.repr 16278) ::
                Init_int16 (Int.repr 16278) :: Init_int16 (Int.repr 16279) ::
                Init_int16 (Int.repr 16279) :: Init_int16 (Int.repr 16280) ::
                Init_int16 (Int.repr 16280) :: Init_int16 (Int.repr 16281) ::
                Init_int16 (Int.repr 16281) :: Init_int16 (Int.repr 16282) ::
                Init_int16 (Int.repr 16282) :: Init_int16 (Int.repr 16283) ::
                Init_int16 (Int.repr 16283) :: Init_int16 (Int.repr 16283) ::
                Init_int16 (Int.repr 16284) :: Init_int16 (Int.repr 16284) ::
                Init_int16 (Int.repr 16285) :: Init_int16 (Int.repr 16285) ::
                Init_int16 (Int.repr 16286) :: Init_int16 (Int.repr 16286) ::
                Init_int16 (Int.repr 16286) :: Init_int16 (Int.repr 16287) ::
                Init_int16 (Int.repr 16287) :: Init_int16 (Int.repr 16288) ::
                Init_int16 (Int.repr 16288) :: Init_int16 (Int.repr 16289) ::
                Init_int16 (Int.repr 16289) :: Init_int16 (Int.repr 16289) ::
                Init_int16 (Int.repr 16290) :: Init_int16 (Int.repr 16290) ::
                Init_int16 (Int.repr 16291) :: Init_int16 (Int.repr 16291) ::
                Init_int16 (Int.repr 16292) :: Init_int16 (Int.repr 16292) ::
                Init_int16 (Int.repr 16292) :: Init_int16 (Int.repr 16293) ::
                Init_int16 (Int.repr 16293) :: Init_int16 (Int.repr 16294) ::
                Init_int16 (Int.repr 16294) :: Init_int16 (Int.repr 16295) ::
                Init_int16 (Int.repr 16295) :: Init_int16 (Int.repr 16295) ::
                Init_int16 (Int.repr 16296) :: Init_int16 (Int.repr 16296) ::
                Init_int16 (Int.repr 16297) :: Init_int16 (Int.repr 16297) ::
                Init_int16 (Int.repr 16297) :: Init_int16 (Int.repr 16298) ::
                Init_int16 (Int.repr 16298) :: Init_int16 (Int.repr 16299) ::
                Init_int16 (Int.repr 16299) :: Init_int16 (Int.repr 16299) ::
                Init_int16 (Int.repr 16300) :: Init_int16 (Int.repr 16300) ::
                Init_int16 (Int.repr 16301) :: Init_int16 (Int.repr 16301) ::
                Init_int16 (Int.repr 16301) :: Init_int16 (Int.repr 16302) ::
                Init_int16 (Int.repr 16302) :: Init_int16 (Int.repr 16303) ::
                Init_int16 (Int.repr 16303) :: Init_int16 (Int.repr 16303) ::
                Init_int16 (Int.repr 16304) :: Init_int16 (Int.repr 16304) ::
                Init_int16 (Int.repr 16305) :: Init_int16 (Int.repr 16305) ::
                Init_int16 (Int.repr 16305) :: Init_int16 (Int.repr 16306) ::
                Init_int16 (Int.repr 16306) :: Init_int16 (Int.repr 16307) ::
                Init_int16 (Int.repr 16307) :: Init_int16 (Int.repr 16307) ::
                Init_int16 (Int.repr 16308) :: Init_int16 (Int.repr 16308) ::
                Init_int16 (Int.repr 16309) :: Init_int16 (Int.repr 16309) ::
                Init_int16 (Int.repr 16309) :: Init_int16 (Int.repr 16310) ::
                Init_int16 (Int.repr 16310) :: Init_int16 (Int.repr 16310) ::
                Init_int16 (Int.repr 16311) :: Init_int16 (Int.repr 16311) ::
                Init_int16 (Int.repr 16312) :: Init_int16 (Int.repr 16312) ::
                Init_int16 (Int.repr 16312) :: Init_int16 (Int.repr 16313) ::
                Init_int16 (Int.repr 16313) :: Init_int16 (Int.repr 16313) ::
                Init_int16 (Int.repr 16314) :: Init_int16 (Int.repr 16314) ::
                Init_int16 (Int.repr 16315) :: Init_int16 (Int.repr 16315) ::
                Init_int16 (Int.repr 16315) :: Init_int16 (Int.repr 16316) ::
                Init_int16 (Int.repr 16316) :: Init_int16 (Int.repr 16316) ::
                Init_int16 (Int.repr 16317) :: Init_int16 (Int.repr 16317) ::
                Init_int16 (Int.repr 16317) :: Init_int16 (Int.repr 16318) ::
                Init_int16 (Int.repr 16318) :: Init_int16 (Int.repr 16318) ::
                Init_int16 (Int.repr 16319) :: Init_int16 (Int.repr 16319) ::
                Init_int16 (Int.repr 16320) :: Init_int16 (Int.repr 16320) ::
                Init_int16 (Int.repr 16320) :: Init_int16 (Int.repr 16321) ::
                Init_int16 (Int.repr 16321) :: Init_int16 (Int.repr 16321) ::
                Init_int16 (Int.repr 16322) :: Init_int16 (Int.repr 16322) ::
                Init_int16 (Int.repr 16322) :: Init_int16 (Int.repr 16323) ::
                Init_int16 (Int.repr 16323) :: Init_int16 (Int.repr 16323) ::
                Init_int16 (Int.repr 16324) :: Init_int16 (Int.repr 16324) ::
                Init_int16 (Int.repr 16324) :: Init_int16 (Int.repr 16325) ::
                Init_int16 (Int.repr 16325) :: Init_int16 (Int.repr 16325) ::
                Init_int16 (Int.repr 16326) :: Init_int16 (Int.repr 16326) ::
                Init_int16 (Int.repr 16326) :: Init_int16 (Int.repr 16327) ::
                Init_int16 (Int.repr 16327) :: Init_int16 (Int.repr 16327) ::
                Init_int16 (Int.repr 16328) :: Init_int16 (Int.repr 16328) ::
                Init_int16 (Int.repr 16328) :: Init_int16 (Int.repr 16329) ::
                Init_int16 (Int.repr 16329) :: Init_int16 (Int.repr 16329) ::
                Init_int16 (Int.repr 16330) :: Init_int16 (Int.repr 16330) ::
                Init_int16 (Int.repr 16330) :: Init_int16 (Int.repr 16331) ::
                Init_int16 (Int.repr 16331) :: Init_int16 (Int.repr 16331) ::
                Init_int16 (Int.repr 16332) :: Init_int16 (Int.repr 16332) ::
                Init_int16 (Int.repr 16332) :: Init_int16 (Int.repr 16333) ::
                Init_int16 (Int.repr 16333) :: Init_int16 (Int.repr 16333) ::
                Init_int16 (Int.repr 16334) :: Init_int16 (Int.repr 16334) ::
                Init_int16 (Int.repr 16334) :: Init_int16 (Int.repr 16334) ::
                Init_int16 (Int.repr 16335) :: Init_int16 (Int.repr 16335) ::
                Init_int16 (Int.repr 16335) :: Init_int16 (Int.repr 16336) ::
                Init_int16 (Int.repr 16336) :: Init_int16 (Int.repr 16336) ::
                Init_int16 (Int.repr 16337) :: Init_int16 (Int.repr 16337) ::
                Init_int16 (Int.repr 16337) :: Init_int16 (Int.repr 16338) ::
                Init_int16 (Int.repr 16338) :: Init_int16 (Int.repr 16338) ::
                Init_int16 (Int.repr 16338) :: Init_int16 (Int.repr 16339) ::
                Init_int16 (Int.repr 16339) :: Init_int16 (Int.repr 16339) ::
                Init_int16 (Int.repr 16340) :: Init_int16 (Int.repr 16340) ::
                Init_int16 (Int.repr 16340) :: Init_int16 (Int.repr 16340) ::
                Init_int16 (Int.repr 16341) :: Init_int16 (Int.repr 16341) ::
                Init_int16 (Int.repr 16341) :: Init_int16 (Int.repr 16342) ::
                Init_int16 (Int.repr 16342) :: Init_int16 (Int.repr 16342) ::
                Init_int16 (Int.repr 16342) :: Init_int16 (Int.repr 16343) ::
                Init_int16 (Int.repr 16343) :: Init_int16 (Int.repr 16343) ::
                Init_int16 (Int.repr 16344) :: Init_int16 (Int.repr 16344) ::
                Init_int16 (Int.repr 16344) :: Init_int16 (Int.repr 16344) ::
                Init_int16 (Int.repr 16345) :: Init_int16 (Int.repr 16345) ::
                Init_int16 (Int.repr 16345) :: Init_int16 (Int.repr 16346) ::
                Init_int16 (Int.repr 16346) :: Init_int16 (Int.repr 16346) ::
                Init_int16 (Int.repr 16346) :: Init_int16 (Int.repr 16347) ::
                Init_int16 (Int.repr 16347) :: Init_int16 (Int.repr 16347) ::
                Init_int16 (Int.repr 16347) :: Init_int16 (Int.repr 16348) ::
                Init_int16 (Int.repr 16348) :: Init_int16 (Int.repr 16348) ::
                Init_int16 (Int.repr 16348) :: Init_int16 (Int.repr 16349) ::
                Init_int16 (Int.repr 16349) :: Init_int16 (Int.repr 16349) ::
                Init_int16 (Int.repr 16349) :: Init_int16 (Int.repr 16350) ::
                Init_int16 (Int.repr 16350) :: Init_int16 (Int.repr 16350) ::
                Init_int16 (Int.repr 16351) :: Init_int16 (Int.repr 16351) ::
                Init_int16 (Int.repr 16351) :: Init_int16 (Int.repr 16351) ::
                Init_int16 (Int.repr 16352) :: Init_int16 (Int.repr 16352) ::
                Init_int16 (Int.repr 16352) :: Init_int16 (Int.repr 16352) ::
                Init_int16 (Int.repr 16353) :: Init_int16 (Int.repr 16353) ::
                Init_int16 (Int.repr 16353) :: Init_int16 (Int.repr 16353) ::
                Init_int16 (Int.repr 16353) :: Init_int16 (Int.repr 16354) ::
                Init_int16 (Int.repr 16354) :: Init_int16 (Int.repr 16354) ::
                Init_int16 (Int.repr 16354) :: Init_int16 (Int.repr 16355) ::
                Init_int16 (Int.repr 16355) :: Init_int16 (Int.repr 16355) ::
                Init_int16 (Int.repr 16355) :: Init_int16 (Int.repr 16356) ::
                Init_int16 (Int.repr 16356) :: Init_int16 (Int.repr 16356) ::
                Init_int16 (Int.repr 16356) :: Init_int16 (Int.repr 16357) ::
                Init_int16 (Int.repr 16357) :: Init_int16 (Int.repr 16357) ::
                Init_int16 (Int.repr 16357) :: Init_int16 (Int.repr 16357) ::
                Init_int16 (Int.repr 16358) :: Init_int16 (Int.repr 16358) ::
                Init_int16 (Int.repr 16358) :: Init_int16 (Int.repr 16358) ::
                Init_int16 (Int.repr 16359) :: Init_int16 (Int.repr 16359) ::
                Init_int16 (Int.repr 16359) :: Init_int16 (Int.repr 16359) ::
                Init_int16 (Int.repr 16359) :: Init_int16 (Int.repr 16360) ::
                Init_int16 (Int.repr 16360) :: Init_int16 (Int.repr 16360) ::
                Init_int16 (Int.repr 16360) :: Init_int16 (Int.repr 16361) ::
                Init_int16 (Int.repr 16361) :: Init_int16 (Int.repr 16361) ::
                Init_int16 (Int.repr 16361) :: Init_int16 (Int.repr 16361) ::
                Init_int16 (Int.repr 16362) :: Init_int16 (Int.repr 16362) ::
                Init_int16 (Int.repr 16362) :: Init_int16 (Int.repr 16362) ::
                Init_int16 (Int.repr 16362) :: Init_int16 (Int.repr 16363) ::
                Init_int16 (Int.repr 16363) :: Init_int16 (Int.repr 16363) ::
                Init_int16 (Int.repr 16363) :: Init_int16 (Int.repr 16363) ::
                Init_int16 (Int.repr 16364) :: Init_int16 (Int.repr 16364) ::
                Init_int16 (Int.repr 16364) :: Init_int16 (Int.repr 16364) ::
                Init_int16 (Int.repr 16364) :: Init_int16 (Int.repr 16365) ::
                Init_int16 (Int.repr 16365) :: Init_int16 (Int.repr 16365) ::
                Init_int16 (Int.repr 16365) :: Init_int16 (Int.repr 16365) ::
                Init_int16 (Int.repr 16366) :: Init_int16 (Int.repr 16366) ::
                Init_int16 (Int.repr 16366) :: Init_int16 (Int.repr 16366) ::
                Init_int16 (Int.repr 16366) :: Init_int16 (Int.repr 16366) ::
                Init_int16 (Int.repr 16367) :: Init_int16 (Int.repr 16367) ::
                Init_int16 (Int.repr 16367) :: Init_int16 (Int.repr 16367) ::
                Init_int16 (Int.repr 16367) :: Init_int16 (Int.repr 16368) ::
                Init_int16 (Int.repr 16368) :: Init_int16 (Int.repr 16368) ::
                Init_int16 (Int.repr 16368) :: Init_int16 (Int.repr 16368) ::
                Init_int16 (Int.repr 16368) :: Init_int16 (Int.repr 16369) ::
                Init_int16 (Int.repr 16369) :: Init_int16 (Int.repr 16369) ::
                Init_int16 (Int.repr 16369) :: Init_int16 (Int.repr 16369) ::
                Init_int16 (Int.repr 16369) :: Init_int16 (Int.repr 16370) ::
                Init_int16 (Int.repr 16370) :: Init_int16 (Int.repr 16370) ::
                Init_int16 (Int.repr 16370) :: Init_int16 (Int.repr 16370) ::
                Init_int16 (Int.repr 16370) :: Init_int16 (Int.repr 16371) ::
                Init_int16 (Int.repr 16371) :: Init_int16 (Int.repr 16371) ::
                Init_int16 (Int.repr 16371) :: Init_int16 (Int.repr 16371) ::
                Init_int16 (Int.repr 16371) :: Init_int16 (Int.repr 16371) ::
                Init_int16 (Int.repr 16372) :: Init_int16 (Int.repr 16372) ::
                Init_int16 (Int.repr 16372) :: Init_int16 (Int.repr 16372) ::
                Init_int16 (Int.repr 16372) :: Init_int16 (Int.repr 16372) ::
                Init_int16 (Int.repr 16373) :: Init_int16 (Int.repr 16373) ::
                Init_int16 (Int.repr 16373) :: Init_int16 (Int.repr 16373) ::
                Init_int16 (Int.repr 16373) :: Init_int16 (Int.repr 16373) ::
                Init_int16 (Int.repr 16373) :: Init_int16 (Int.repr 16374) ::
                Init_int16 (Int.repr 16374) :: Init_int16 (Int.repr 16374) ::
                Init_int16 (Int.repr 16374) :: Init_int16 (Int.repr 16374) ::
                Init_int16 (Int.repr 16374) :: Init_int16 (Int.repr 16374) ::
                Init_int16 (Int.repr 16374) :: Init_int16 (Int.repr 16375) ::
                Init_int16 (Int.repr 16375) :: Init_int16 (Int.repr 16375) ::
                Init_int16 (Int.repr 16375) :: Init_int16 (Int.repr 16375) ::
                Init_int16 (Int.repr 16375) :: Init_int16 (Int.repr 16375) ::
                Init_int16 (Int.repr 16376) :: Init_int16 (Int.repr 16376) ::
                Init_int16 (Int.repr 16376) :: Init_int16 (Int.repr 16376) ::
                Init_int16 (Int.repr 16376) :: Init_int16 (Int.repr 16376) ::
                Init_int16 (Int.repr 16376) :: Init_int16 (Int.repr 16376) ::
                Init_int16 (Int.repr 16376) :: Init_int16 (Int.repr 16377) ::
                Init_int16 (Int.repr 16377) :: Init_int16 (Int.repr 16377) ::
                Init_int16 (Int.repr 16377) :: Init_int16 (Int.repr 16377) ::
                Init_int16 (Int.repr 16377) :: Init_int16 (Int.repr 16377) ::
                Init_int16 (Int.repr 16377) :: Init_int16 (Int.repr 16377) ::
                Init_int16 (Int.repr 16378) :: Init_int16 (Int.repr 16378) ::
                Init_int16 (Int.repr 16378) :: Init_int16 (Int.repr 16378) ::
                Init_int16 (Int.repr 16378) :: Init_int16 (Int.repr 16378) ::
                Init_int16 (Int.repr 16378) :: Init_int16 (Int.repr 16378) ::
                Init_int16 (Int.repr 16378) :: Init_int16 (Int.repr 16379) ::
                Init_int16 (Int.repr 16379) :: Init_int16 (Int.repr 16379) ::
                Init_int16 (Int.repr 16379) :: Init_int16 (Int.repr 16379) ::
                Init_int16 (Int.repr 16379) :: Init_int16 (Int.repr 16379) ::
                Init_int16 (Int.repr 16379) :: Init_int16 (Int.repr 16379) ::
                Init_int16 (Int.repr 16379) :: Init_int16 (Int.repr 16379) ::
                Init_int16 (Int.repr 16380) :: Init_int16 (Int.repr 16380) ::
                Init_int16 (Int.repr 16380) :: Init_int16 (Int.repr 16380) ::
                Init_int16 (Int.repr 16380) :: Init_int16 (Int.repr 16380) ::
                Init_int16 (Int.repr 16380) :: Init_int16 (Int.repr 16380) ::
                Init_int16 (Int.repr 16380) :: Init_int16 (Int.repr 16380) ::
                Init_int16 (Int.repr 16380) :: Init_int16 (Int.repr 16380) ::
                Init_int16 (Int.repr 16381) :: Init_int16 (Int.repr 16381) ::
                Init_int16 (Int.repr 16381) :: Init_int16 (Int.repr 16381) ::
                Init_int16 (Int.repr 16381) :: Init_int16 (Int.repr 16381) ::
                Init_int16 (Int.repr 16381) :: Init_int16 (Int.repr 16381) ::
                Init_int16 (Int.repr 16381) :: Init_int16 (Int.repr 16381) ::
                Init_int16 (Int.repr 16381) :: Init_int16 (Int.repr 16381) ::
                Init_int16 (Int.repr 16381) :: Init_int16 (Int.repr 16381) ::
                Init_int16 (Int.repr 16382) :: Init_int16 (Int.repr 16382) ::
                Init_int16 (Int.repr 16382) :: Init_int16 (Int.repr 16382) ::
                Init_int16 (Int.repr 16382) :: Init_int16 (Int.repr 16382) ::
                Init_int16 (Int.repr 16382) :: Init_int16 (Int.repr 16382) ::
                Init_int16 (Int.repr 16382) :: Init_int16 (Int.repr 16382) ::
                Init_int16 (Int.repr 16382) :: Init_int16 (Int.repr 16382) ::
                Init_int16 (Int.repr 16382) :: Init_int16 (Int.repr 16382) ::
                Init_int16 (Int.repr 16382) :: Init_int16 (Int.repr 16382) ::
                Init_int16 (Int.repr 16382) :: Init_int16 (Int.repr 16382) ::
                Init_int16 (Int.repr 16382) :: Init_int16 (Int.repr 16383) ::
                Init_int16 (Int.repr 16383) :: Init_int16 (Int.repr 16383) ::
                Init_int16 (Int.repr 16383) :: Init_int16 (Int.repr 16383) ::
                Init_int16 (Int.repr 16383) :: Init_int16 (Int.repr 16383) ::
                Init_int16 (Int.repr 16383) :: Init_int16 (Int.repr 16383) ::
                Init_int16 (Int.repr 16383) :: Init_int16 (Int.repr 16383) ::
                Init_int16 (Int.repr 16383) :: Init_int16 (Int.repr 16383) ::
                Init_int16 (Int.repr 16383) :: Init_int16 (Int.repr 16383) ::
                Init_int16 (Int.repr 16383) :: Init_int16 (Int.repr 16383) ::
                Init_int16 (Int.repr 16383) :: Init_int16 (Int.repr 16383) ::
                Init_int16 (Int.repr 16383) :: Init_int16 (Int.repr 16383) ::
                Init_int16 (Int.repr 16383) :: Init_int16 (Int.repr 16383) ::
                Init_int16 (Int.repr 16383) :: Init_int16 (Int.repr 16383) ::
                Init_int16 (Int.repr 16383) :: Init_int16 (Int.repr 16383) ::
                Init_int16 (Int.repr 16383) :: Init_int16 (Int.repr 16383) ::
                Init_int16 (Int.repr 16383) :: Init_int16 (Int.repr 16383) ::
                Init_int16 (Int.repr 16383) :: Init_int16 (Int.repr 16383) ::
                Init_int16 (Int.repr 16383) :: Init_int16 (Int.repr 16383) ::
                Init_int16 (Int.repr 16383) :: Init_int16 (Int.repr 16383) ::
                Init_int16 (Int.repr 16383) :: Init_int16 (Int.repr 16383) ::
                Init_int16 (Int.repr 16383) :: Init_int16 (Int.repr 16383) ::
                Init_int16 (Int.repr 16383) :: Init_int16 (Int.repr 16383) ::
                Init_int16 (Int.repr 16383) :: Init_int16 (Int.repr 16383) ::
                nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition f_pprz_trig_int_init := {|
  fn_return := tint;
  fn_callconv := cc_default;
  fn_params := nil;
  fn_vars := nil;
  fn_body :=
(Sreturn (Some (Eval (Vint (Int.repr 0)) tint)))
|}.

Definition f_pprz_itrig_sin := {|
  fn_return := tint;
  fn_callconv := cc_default;
  fn_params := ((_angle, tint) :: nil);
  fn_vars := nil;
  fn_body :=
(Ssequence
  (Ssequence
    (Swhile
      (Ebinop Ogt (Evalof (Evar _angle tint) tint)
        (Ecast
          (Ebinop Omul
            (Eval (Vfloat (Float.of_bits (Int64.repr 4614256656552045848))) tdouble)
            (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
              (Eval (Vint (Int.repr 12)) tint) tint) tdouble) tint) tint)
      (Sdo (Eassignop Osub (Evar _angle tint)
             (Ecast
               (Ebinop Omul
                 (Ebinop Omul
                   (Eval (Vfloat (Float.of_bits (Int64.repr 4611686018427387904))) tdouble)
                   (Eval (Vfloat (Float.of_bits (Int64.repr 4614256656552045848))) tdouble)
                   tdouble)
                 (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                   (Eval (Vint (Int.repr 12)) tint) tint) tdouble) tint)
             tint tint)))
    (Swhile
      (Ebinop Olt (Evalof (Evar _angle tint) tint)
        (Eunop Oneg
          (Ecast
            (Ebinop Omul
              (Eval (Vfloat (Float.of_bits (Int64.repr 4614256656552045848))) tdouble)
              (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                (Eval (Vint (Int.repr 12)) tint) tint) tdouble) tint) tint)
        tint)
      (Sdo (Eassignop Oadd (Evar _angle tint)
             (Ecast
               (Ebinop Omul
                 (Ebinop Omul
                   (Eval (Vfloat (Float.of_bits (Int64.repr 4611686018427387904))) tdouble)
                   (Eval (Vfloat (Float.of_bits (Int64.repr 4614256656552045848))) tdouble)
                   tdouble)
                 (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                   (Eval (Vint (Int.repr 12)) tint) tint) tdouble) tint)
             tint tint))))
  (Ssequence
    (Sifthenelse (Ebinop Ogt (Evalof (Evar _angle tint) tint)
                   (Ecast
                     (Ebinop Omul
                       (Eval (Vfloat (Float.of_bits (Int64.repr 4609753056924675352))) tdouble)
                       (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                         (Eval (Vint (Int.repr 12)) tint) tint) tdouble)
                     tint) tint)
      (Sdo (Eassign (Evar _angle tint)
             (Ebinop Osub
               (Ecast
                 (Ebinop Omul
                   (Eval (Vfloat (Float.of_bits (Int64.repr 4614256656552045848))) tdouble)
                   (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                     (Eval (Vint (Int.repr 12)) tint) tint) tdouble) tint)
               (Evalof (Evar _angle tint) tint) tint) tint))
      (Sifthenelse (Ebinop Olt (Evalof (Evar _angle tint) tint)
                     (Eunop Oneg
                       (Ecast
                         (Ebinop Omul
                           (Eval (Vfloat (Float.of_bits (Int64.repr 4609753056924675352))) tdouble)
                           (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                             (Eval (Vint (Int.repr 12)) tint) tint) tdouble)
                         tint) tint) tint)
        (Sdo (Eassign (Evar _angle tint)
               (Ebinop Osub
                 (Eunop Oneg
                   (Ecast
                     (Ebinop Omul
                       (Eval (Vfloat (Float.of_bits (Int64.repr 4614256656552045848))) tdouble)
                       (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                         (Eval (Vint (Int.repr 12)) tint) tint) tdouble)
                     tint) tint) (Evalof (Evar _angle tint) tint) tint) tint))
        Sskip))
    (Sifthenelse (Ebinop Oge (Evalof (Evar _angle tint) tint)
                   (Eval (Vint (Int.repr 0)) tint) tint)
      (Sreturn (Some (Evalof
                       (Ederef
                         (Ebinop Oadd
                           (Evalof (Evar _pprz_trig_int (tarray tshort 6434))
                             (tarray tshort 6434))
                           (Evalof (Evar _angle tint) tint) (tptr tshort))
                         tshort) tshort)))
      (Sreturn (Some (Eunop Oneg
                       (Evalof
                         (Ederef
                           (Ebinop Oadd
                             (Evalof
                               (Evar _pprz_trig_int (tarray tshort 6434))
                               (tarray tshort 6434))
                             (Eunop Oneg (Evalof (Evar _angle tint) tint)
                               tint) (tptr tshort)) tshort) tshort) tint))))))
|}.

Definition f_pprz_itrig_cos := {|
  fn_return := tint;
  fn_callconv := cc_default;
  fn_params := ((_angle, tint) :: nil);
  fn_vars := nil;
  fn_body :=
(Sreturn (Some (Ecall
                 (Evalof
                   (Evar _pprz_itrig_sin (Tfunction (tint :: nil) tint
                                           cc_default))
                   (Tfunction (tint :: nil) tint cc_default))
                 (Econs
                   (Ebinop Oadd (Evalof (Evar _angle tint) tint)
                     (Ecast
                       (Ebinop Omul
                         (Eval (Vfloat (Float.of_bits (Int64.repr 4609753056924675352))) tdouble)
                         (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                           (Eval (Vint (Int.repr 12)) tint) tint) tdouble)
                       tint) tint) Enil) tint)))
|}.

Definition f_int32_atan2 := {|
  fn_return := tint;
  fn_callconv := cc_default;
  fn_params := ((_y, tint) :: (_x, tint) :: nil);
  fn_vars := ((_c1, tint) :: (_c2, tint) :: (_abs_y, tint) :: (_r, tint) ::
              (_a, tint) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Eassign (Evar _c1 tint)
         (Ecast
           (Ebinop Omul
             (Eval (Vfloat (Float.of_bits (Int64.repr 4605249457297304856))) tdouble)
             (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
               (Eval (Vint (Int.repr 12)) tint) tint) tdouble) tint) tint))
  (Ssequence
    (Sdo (Eassign (Evar _c2 tint)
           (Ebinop Omul (Eval (Vint (Int.repr 3)) tint)
             (Ecast
               (Ebinop Omul
                 (Eval (Vfloat (Float.of_bits (Int64.repr 4605249457297304856))) tdouble)
                 (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                   (Eval (Vint (Int.repr 12)) tint) tint) tdouble) tint)
             tint) tint))
    (Ssequence
      (Sdo (Eassign (Evar _abs_y tint)
             (Ebinop Oadd
               (Ecall
                 (Evalof
                   (Evar _abs (Tfunction (tint :: nil) tint cc_default))
                   (Tfunction (tint :: nil) tint cc_default))
                 (Econs (Evalof (Evar _y tint) tint) Enil) tint)
               (Eval (Vint (Int.repr 1)) tint) tint) tint))
      (Ssequence
        (Sifthenelse (Ebinop Oge (Evalof (Evar _x tint) tint)
                       (Eval (Vint (Int.repr 0)) tint) tint)
          (Ssequence
            (Sdo (Eassign (Evar _r tint)
                   (Ebinop Odiv
                     (Ebinop Oshl
                       (Ebinop Osub (Evalof (Evar _x tint) tint)
                         (Evalof (Evar _abs_y tint) tint) tint)
                       (Eval (Vint (Int.repr 14)) tint) tint)
                     (Ebinop Oadd (Evalof (Evar _x tint) tint)
                       (Evalof (Evar _abs_y tint) tint) tint) tint) tint))
            (Sdo (Eassign (Evar _a tint)
                   (Ebinop Osub (Evalof (Evar _c1 tint) tint)
                     (Ebinop Oshr
                       (Ebinop Omul (Evalof (Evar _c1 tint) tint)
                         (Evalof (Evar _r tint) tint) tint)
                       (Eval (Vint (Int.repr 14)) tint) tint) tint) tint)))
          (Ssequence
            (Sdo (Eassign (Evar _r tint)
                   (Ebinop Odiv
                     (Ebinop Oshl
                       (Ebinop Oadd (Evalof (Evar _x tint) tint)
                         (Evalof (Evar _abs_y tint) tint) tint)
                       (Eval (Vint (Int.repr 14)) tint) tint)
                     (Ebinop Osub (Evalof (Evar _abs_y tint) tint)
                       (Evalof (Evar _x tint) tint) tint) tint) tint))
            (Sdo (Eassign (Evar _a tint)
                   (Ebinop Osub (Evalof (Evar _c2 tint) tint)
                     (Ebinop Oshr
                       (Ebinop Omul (Evalof (Evar _c1 tint) tint)
                         (Evalof (Evar _r tint) tint) tint)
                       (Eval (Vint (Int.repr 14)) tint) tint) tint) tint))))
        (Sifthenelse (Ebinop Olt (Evalof (Evar _y tint) tint)
                       (Eval (Vint (Int.repr 0)) tint) tint)
          (Sreturn (Some (Eunop Oneg (Evalof (Evar _a tint) tint) tint)))
          (Sreturn (Some (Evalof (Evar _a tint) tint))))))))
|}.

Definition f_int32_atan2_2 := {|
  fn_return := tint;
  fn_callconv := cc_default;
  fn_params := ((_y, tint) :: (_x, tint) :: nil);
  fn_vars := ((_c1, tint) :: (_c2, tint) :: (_abs_y, tint) :: (_r, tint) ::
              (_a, tint) :: (_r2, tint) :: (_tmp1, tint) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Eassign (Evar _c1 tint)
         (Ecast
           (Ebinop Omul
             (Eval (Vfloat (Float.of_bits (Int64.repr 4605249457297304856))) tdouble)
             (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
               (Eval (Vint (Int.repr 12)) tint) tint) tdouble) tint) tint))
  (Ssequence
    (Sdo (Eassign (Evar _c2 tint)
           (Ebinop Omul (Eval (Vint (Int.repr 3)) tint)
             (Ecast
               (Ebinop Omul
                 (Eval (Vfloat (Float.of_bits (Int64.repr 4605249457297304856))) tdouble)
                 (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                   (Eval (Vint (Int.repr 12)) tint) tint) tdouble) tint)
             tint) tint))
    (Ssequence
      (Sdo (Eassign (Evar _abs_y tint)
             (Ebinop Oadd
               (Ecall
                 (Evalof
                   (Evar _abs (Tfunction (tint :: nil) tint cc_default))
                   (Tfunction (tint :: nil) tint cc_default))
                 (Econs (Evalof (Evar _y tint) tint) Enil) tint)
               (Eval (Vint (Int.repr 1)) tint) tint) tint))
      (Ssequence
        (Sifthenelse (Ebinop Oge (Evalof (Evar _x tint) tint)
                       (Eval (Vint (Int.repr 0)) tint) tint)
          (Ssequence
            (Sdo (Eassign (Evar _r tint)
                   (Ebinop Odiv
                     (Ebinop Oshl
                       (Ebinop Osub (Evalof (Evar _x tint) tint)
                         (Evalof (Evar _abs_y tint) tint) tint)
                       (Eval (Vint (Int.repr 14)) tint) tint)
                     (Ebinop Oadd (Evalof (Evar _x tint) tint)
                       (Evalof (Evar _abs_y tint) tint) tint) tint) tint))
            (Ssequence
              (Sdo (Eassign (Evar _r2 tint)
                     (Ebinop Oshr
                       (Ebinop Omul (Evalof (Evar _r tint) tint)
                         (Evalof (Evar _r tint) tint) tint)
                       (Eval (Vint (Int.repr 14)) tint) tint) tint))
              (Ssequence
                (Sdo (Eassign (Evar _tmp1 tint)
                       (Ebinop Osub
                         (Ebinop Oshr
                           (Ebinop Omul (Evalof (Evar _r2 tint) tint)
                             (Ecast
                               (Ebinop Omul
                                 (Eval (Vfloat (Float.of_bits (Int64.repr 4596240473145358051))) tdouble)
                                 (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                                   (Eval (Vint (Int.repr 12)) tint) tint)
                                 tdouble) tint) tint)
                           (Eval (Vint (Int.repr 12)) tint) tint)
                         (Ebinop Omul
                           (Eval (Vfloat (Float.of_bits (Int64.repr 4607017587053655648))) tdouble)
                           (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                             (Eval (Vint (Int.repr 12)) tint) tint) tdouble)
                         tdouble) tint))
                (Sdo (Eassign (Evar _a tint)
                       (Ebinop Oadd
                         (Ebinop Oshr
                           (Ebinop Omul (Evalof (Evar _tmp1 tint) tint)
                             (Evalof (Evar _r tint) tint) tint)
                           (Eval (Vint (Int.repr 14)) tint) tint)
                         (Evalof (Evar _c1 tint) tint) tint) tint)))))
          (Ssequence
            (Sdo (Eassign (Evar _r tint)
                   (Ebinop Odiv
                     (Ebinop Oshl
                       (Ebinop Oadd (Evalof (Evar _x tint) tint)
                         (Evalof (Evar _abs_y tint) tint) tint)
                       (Eval (Vint (Int.repr 14)) tint) tint)
                     (Ebinop Osub (Evalof (Evar _abs_y tint) tint)
                       (Evalof (Evar _x tint) tint) tint) tint) tint))
            (Sdo (Eassign (Evar _a tint)
                   (Ebinop Osub (Evalof (Evar _c2 tint) tint)
                     (Ebinop Oshr
                       (Ebinop Omul (Evalof (Evar _c1 tint) tint)
                         (Evalof (Evar _r tint) tint) tint)
                       (Eval (Vint (Int.repr 14)) tint) tint) tint) tint))))
        (Sifthenelse (Ebinop Olt (Evalof (Evar _y tint) tint)
                       (Eval (Vint (Int.repr 0)) tint) tint)
          (Sreturn (Some (Eunop Oneg (Evalof (Evar _a tint) tint) tint)))
          (Sreturn (Some (Evalof (Evar _a tint) tint))))))))
|}.

Definition v_five_keep_pprz_trig_int_init := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _pprz_trig_int_init (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_pprz_itrig_cos := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _pprz_itrig_cos (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_int32_atan2 := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _int32_atan2 (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_int32_atan2_2 := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _int32_atan2_2 (Ptrofs.repr 0) :: nil);
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
 (_abs,
   Gfun(External (EF_external "abs"
                   (mksignature (AST.Xint :: nil) AST.Xint cc_default))
     (tint :: nil) tint cc_default)) ::
 (_pprz_trig_int, Gvar v_pprz_trig_int) ::
 (_pprz_trig_int_init, Gfun(Internal f_pprz_trig_int_init)) ::
 (_pprz_itrig_sin, Gfun(Internal f_pprz_itrig_sin)) ::
 (_pprz_itrig_cos, Gfun(Internal f_pprz_itrig_cos)) ::
 (_int32_atan2, Gfun(Internal f_int32_atan2)) ::
 (_int32_atan2_2, Gfun(Internal f_int32_atan2_2)) ::
 (_five_keep_pprz_trig_int_init, Gvar v_five_keep_pprz_trig_int_init) ::
 (_five_keep_pprz_itrig_cos, Gvar v_five_keep_pprz_itrig_cos) ::
 (_five_keep_int32_atan2, Gvar v_five_keep_int32_atan2) ::
 (_five_keep_int32_atan2_2, Gvar v_five_keep_int32_atan2_2) :: nil).

Definition public_idents : list ident :=
(_five_keep_int32_atan2_2 :: _five_keep_int32_atan2 ::
 _five_keep_pprz_itrig_cos :: _five_keep_pprz_trig_int_init ::
 _int32_atan2_2 :: _int32_atan2 :: _pprz_itrig_cos :: _pprz_itrig_sin ::
 _pprz_trig_int_init :: _pprz_trig_int :: _abs :: ___builtin_debug ::
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


