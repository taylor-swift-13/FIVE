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
  Definition source_file := "/home/yangfp/five/_build/paparazzi/navigation-vision-models/vision_images/model/preprocessed.i".
End Info.

Definition _FloatEulers : ident := $"FloatEulers".
Definition _Sobel : ident := $"Sobel".
Definition _U : ident := $"U".
Definition _V : ident := $"V".
Definition _Y : ident := $"Y".
Definition _YUV : ident := $"YUV".
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
Definition _add_ind : ident := $"add_ind".
Definition _aligned_alloc : ident := $"aligned_alloc".
Definition _alpha_x : ident := $"alpha_x".
Definition _alpha_y : ident := $"alpha_y".
Definition _b : ident := $"b".
Definition _bad_color : ident := $"bad_color".
Definition _bad_color__1 : ident := $"bad_color__1".
Definition _blend : ident := $"blend".
Definition _border_size : ident := $"border_size".
Definition _buf : ident := $"buf".
Definition _buf_idx : ident := $"buf_idx".
Definition _buf_loc : ident := $"buf_loc".
Definition _buf_size : ident := $"buf_size".
Definition _center : ident := $"center".
Definition _check_color_yuv422 : ident := $"check_color_yuv422".
Definition _cnt : ident := $"cnt".
Definition _col : ident := $"col".
Definition _color : ident := $"color".
Definition _color__1 : ident := $"color__1".
Definition _color__2 : ident := $"color__2".
Definition _count : ident := $"count".
Definition _cross_hair : ident := $"cross_hair".
Definition _delta_x : ident := $"delta_x".
Definition _delta_y : ident := $"delta_y".
Definition _dest : ident := $"dest".
Definition _diff : ident := $"diff".
Definition _diff_buf : ident := $"diff_buf".
Definition _diff_c : ident := $"diff_c".
Definition _distance : ident := $"distance".
Definition _downsample : ident := $"downsample".
Definition _dx : ident := $"dx".
Definition _dx_buf : ident := $"dx_buf".
Definition _dy : ident := $"dy".
Definition _dy_buf : ident := $"dy_buf".
Definition _error : ident := $"error".
Definition _eulers : ident := $"eulers".
Definition _filt_ind_x : ident := $"filt_ind_x".
Definition _filt_ind_y : ident := $"filt_ind_y".
Definition _five_keep_check_color_yuv422 : ident := $"five_keep_check_color_yuv422".
Definition _five_keep_image_add_border : ident := $"five_keep_image_add_border".
Definition _five_keep_image_calculate_g : ident := $"five_keep_image_calculate_g".
Definition _five_keep_image_convolution_3x3 : ident := $"five_keep_image_convolution_3x3".
Definition _five_keep_image_copy : ident := $"five_keep_image_copy".
Definition _five_keep_image_create : ident := $"five_keep_image_create".
Definition _five_keep_image_difference : ident := $"five_keep_image_difference".
Definition _five_keep_image_draw_crosshair : ident := $"five_keep_image_draw_crosshair".
Definition _five_keep_image_draw_line : ident := $"five_keep_image_draw_line".
Definition _five_keep_image_draw_line_color : ident := $"five_keep_image_draw_line_color".
Definition _five_keep_image_draw_rectangle : ident := $"five_keep_image_draw_rectangle".
Definition _five_keep_image_free : ident := $"five_keep_image_free".
Definition _five_keep_image_gradient_pixel : ident := $"five_keep_image_gradient_pixel".
Definition _five_keep_image_gradients : ident := $"five_keep_image_gradients".
Definition _five_keep_image_multiply : ident := $"five_keep_image_multiply".
Definition _five_keep_image_show_flow : ident := $"five_keep_image_show_flow".
Definition _five_keep_image_show_flow_color : ident := $"five_keep_image_show_flow_color".
Definition _five_keep_image_show_points : ident := $"five_keep_image_show_points".
Definition _five_keep_image_show_points_color : ident := $"five_keep_image_show_points_color".
Definition _five_keep_image_subpixel_window : ident := $"five_keep_image_subpixel_window".
Definition _five_keep_image_switch : ident := $"five_keep_image_switch".
Definition _five_keep_image_to_grayscale : ident := $"five_keep_image_to_grayscale".
Definition _five_keep_image_yuv422_colorfilt : ident := $"five_keep_image_yuv422_colorfilt".
Definition _five_keep_image_yuv422_downsample : ident := $"five_keep_image_yuv422_downsample".
Definition _five_keep_ker_mul_3x3 : ident := $"five_keep_ker_mul_3x3".
Definition _five_keep_pyramid_build : ident := $"five_keep_pyramid_build".
Definition _five_keep_pyramid_next_level : ident := $"five_keep_pyramid_next_level".
Definition _five_keep_set_color_yuv422 : ident := $"five_keep_set_color_yuv422".
Definition _flow_t : ident := $"flow_t".
Definition _flow_x : ident := $"flow_x".
Definition _flow_y : ident := $"flow_y".
Definition _free : ident := $"free".
Definition _from : ident := $"from".
Definition _g : ident := $"g".
Definition _gradient_x : ident := $"gradient_x".
Definition _gradient_y : ident := $"gradient_y".
Definition _h : ident := $"h".
Definition _half_window : ident := $"half_window".
Definition _height : ident := $"height".
Definition _i : ident := $"i".
Definition _i__1 : ident := $"i__1".
Definition _idx : ident := $"idx".
Definition _im : ident := $"im".
Definition _image_add_border : ident := $"image_add_border".
Definition _image_calculate_g : ident := $"image_calculate_g".
Definition _image_convolution_3x3 : ident := $"image_convolution_3x3".
Definition _image_copy : ident := $"image_copy".
Definition _image_create : ident := $"image_create".
Definition _image_difference : ident := $"image_difference".
Definition _image_draw_crosshair : ident := $"image_draw_crosshair".
Definition _image_draw_line : ident := $"image_draw_line".
Definition _image_draw_line_color : ident := $"image_draw_line_color".
Definition _image_draw_rectangle : ident := $"image_draw_rectangle".
Definition _image_free : ident := $"image_free".
Definition _image_gradient_pixel : ident := $"image_gradient_pixel".
Definition _image_gradients : ident := $"image_gradients".
Definition _image_multiply : ident := $"image_multiply".
Definition _image_show_flow : ident := $"image_show_flow".
Definition _image_show_flow_color : ident := $"image_show_flow_color".
Definition _image_show_points : ident := $"image_show_points".
Definition _image_show_points_color : ident := $"image_show_points_color".
Definition _image_subpixel_window : ident := $"image_subpixel_window".
Definition _image_switch : ident := $"image_switch".
Definition _image_t : ident := $"image_t".
Definition _image_to_grayscale : ident := $"image_to_grayscale".
Definition _image_yuv422_colorfilt : ident := $"image_yuv422_colorfilt".
Definition _image_yuv422_downsample : ident := $"image_yuv422_downsample".
Definition _img : ident := $"img".
Definition _img_a : ident := $"img_a".
Definition _img_a_buf : ident := $"img_a_buf".
Definition _img_b : ident := $"img_b".
Definition _img_b_buf : ident := $"img_b_buf".
Definition _img_buf : ident := $"img_buf".
Definition _incx : ident := $"incx".
Definition _incy : ident := $"incy".
Definition _index : ident := $"index".
Definition _input : ident := $"input".
Definition _input_buf : ident := $"input_buf".
Definition _j : ident := $"j".
Definition _j__1 : ident := $"j__1".
Definition _ker_mul_3x3 : ident := $"ker_mul_3x3".
Definition _kernel : ident := $"kernel".
Definition _kernel_total : ident := $"kernel_total".
Definition _loc : ident := $"loc".
Definition _main : ident := $"main".
Definition _memcpy : ident := $"memcpy".
Definition _method : ident := $"method".
Definition _mult : ident := $"mult".
Definition _mult_buf : ident := $"mult_buf".
Definition _mult_c : ident := $"mult_c".
Definition _offset : ident := $"offset".
Definition _old_a : ident := $"old_a".
Definition _orig_x : ident := $"orig_x".
Definition _orig_y : ident := $"orig_y".
Definition _output : ident := $"output".
Definition _output_array : ident := $"output_array".
Definition _output_buf : ident := $"output_buf".
Definition _phi : ident := $"phi".
Definition _pixel_width : ident := $"pixel_width".
Definition _pixelskip : ident := $"pixelskip".
Definition _point_t : ident := $"point_t".
Definition _points : ident := $"points".
Definition _points_cnt : ident := $"points_cnt".
Definition _pos : ident := $"pos".
Definition _pprz_ts : ident := $"pprz_ts".
Definition _psi : ident := $"psi".
Definition _pyr_level : ident := $"pyr_level".
Definition _pyramid_build : ident := $"pyramid_build".
Definition _pyramid_next_level : ident := $"pyramid_next_level".
Definition _roundf : ident := $"roundf".
Definition _row : ident := $"row".
Definition _set_color_yuv422 : ident := $"set_color_yuv422".
Definition _setting : ident := $"setting".
Definition _size_crosshair : ident := $"size_crosshair".
Definition _size_crosshair__1 : ident := $"size_crosshair__1".
Definition _source : ident := $"source".
Definition _startx : ident := $"startx".
Definition _starty : ident := $"starty".
Definition _subpixel_factor : ident := $"subpixel_factor".
Definition _subpixel_h : ident := $"subpixel_h".
Definition _subpixel_w : ident := $"subpixel_w".
Definition _sum : ident := $"sum".
Definition _sum_diff2 : ident := $"sum_diff2".
Definition _sum_dxx : ident := $"sum_dxx".
Definition _sum_dxy : ident := $"sum_dxy".
Definition _sum_dyy : ident := $"sum_dyy".
Definition _t : ident := $"t".
Definition _temp : ident := $"temp".
Definition _temp_color : ident := $"temp_color".
Definition _theta : ident := $"theta".
Definition _timeval : ident := $"timeval".
Definition _tl_x : ident := $"tl_x".
Definition _tl_y : ident := $"tl_y".
Definition _to : ident := $"to".
Definition _total : ident := $"total".
Definition _total_sobel : ident := $"total_sobel".
Definition _ts : ident := $"ts".
Definition _tv_sec : ident := $"tv_sec".
Definition _tv_usec : ident := $"tv_usec".
Definition _type : ident := $"type".
Definition _u : ident := $"u".
Definition _u_M : ident := $"u_M".
Definition _u_m : ident := $"u_m".
Definition _v_M : ident := $"v_M".
Definition _v_m : ident := $"v_m".
Definition _value : ident := $"value".
Definition _vectors : ident := $"vectors".
Definition _w : ident := $"w".
Definition _width : ident := $"width".
Definition _x : ident := $"x".
Definition _x__1 : ident := $"x__1".
Definition _x__2 : ident := $"x__2".
Definition _x__3 : ident := $"x__3".
Definition _x__4 : ident := $"x__4".
Definition _x__5 : ident := $"x__5".
Definition _x_max : ident := $"x_max".
Definition _x_min : ident := $"x_min".
Definition _x_sub : ident := $"x_sub".
Definition _xerr : ident := $"xerr".
Definition _y : ident := $"y".
Definition _y_M : ident := $"y_M".
Definition _y__1 : ident := $"y__1".
Definition _y_m : ident := $"y_m".
Definition _y_max : ident := $"y_max".
Definition _y_min : ident := $"y_min".
Definition _y_sub : ident := $"y_sub".
Definition _yerr : ident := $"yerr".

Definition f_image_create := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_img, (tptr (Tstruct _image_t noattr))) ::
                (_width, tushort) :: (_height, tushort) :: (_type, tint) ::
                nil);
  fn_vars := nil;
  fn_body :=
(Ssequence
  (Sdo (Eassign
         (Efield
           (Evalof
             (Ederef
               (Evalof (Evar _img (tptr (Tstruct _image_t noattr)))
                 (tptr (Tstruct _image_t noattr))) (Tstruct _image_t noattr))
             (Tstruct _image_t noattr)) _type tint)
         (Evalof (Evar _type tint) tint) tint))
  (Ssequence
    (Sdo (Eassign
           (Efield
             (Evalof
               (Ederef
                 (Evalof (Evar _img (tptr (Tstruct _image_t noattr)))
                   (tptr (Tstruct _image_t noattr)))
                 (Tstruct _image_t noattr)) (Tstruct _image_t noattr)) _w
             tushort) (Evalof (Evar _width tushort) tushort) tushort))
    (Ssequence
      (Sdo (Eassign
             (Efield
               (Evalof
                 (Ederef
                   (Evalof (Evar _img (tptr (Tstruct _image_t noattr)))
                     (tptr (Tstruct _image_t noattr)))
                   (Tstruct _image_t noattr)) (Tstruct _image_t noattr)) _h
               tushort) (Evalof (Evar _height tushort) tushort) tushort))
      (Ssequence
        (Sifthenelse (Ebinop Oeq (Evalof (Evar _type tint) tint)
                       (Eval (Vint (Int.repr 0)) tint) tint)
          (Sdo (Eassign
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _img (tptr (Tstruct _image_t noattr)))
                         (tptr (Tstruct _image_t noattr)))
                       (Tstruct _image_t noattr)) (Tstruct _image_t noattr))
                   _buf_size tuint)
                 (Ebinop Omul
                   (Ebinop Omul
                     (Ebinop Omul (Esizeof tuchar tulong)
                       (Eval (Vint (Int.repr 2)) tint) tulong)
                     (Evalof (Evar _width tushort) tushort) tulong)
                   (Evalof (Evar _height tushort) tushort) tulong) tuint))
          (Sifthenelse (Ebinop Oeq (Evalof (Evar _type tint) tint)
                         (Eval (Vint (Int.repr 2)) tint) tint)
            (Sdo (Eassign
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof (Evar _img (tptr (Tstruct _image_t noattr)))
                           (tptr (Tstruct _image_t noattr)))
                         (Tstruct _image_t noattr))
                       (Tstruct _image_t noattr)) _buf_size tuint)
                   (Ebinop Omul
                     (Ebinop Omul
                       (Ebinop Omul (Esizeof tuchar tulong)
                         (Eval (Vint (Int.repr 2)) tint) tulong)
                       (Evalof (Evar _width tushort) tushort) tulong)
                     (Evalof (Evar _height tushort) tushort) tulong) tuint))
            (Sifthenelse (Ebinop Oeq (Evalof (Evar _type tint) tint)
                           (Eval (Vint (Int.repr 3)) tint) tint)
              (Sdo (Eassign
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _img (tptr (Tstruct _image_t noattr)))
                             (tptr (Tstruct _image_t noattr)))
                           (Tstruct _image_t noattr))
                         (Tstruct _image_t noattr)) _buf_size tuint)
                     (Ebinop Omul
                       (Ebinop Omul (Esizeof tshort tulong)
                         (Evalof (Evar _width tushort) tushort) tulong)
                       (Evalof (Evar _height tushort) tushort) tulong) tuint))
              (Sifthenelse (Ebinop Oeq (Evalof (Evar _type tint) tint)
                             (Eval (Vint (Int.repr 4)) tint) tint)
                (Sdo (Eassign
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _img (tptr (Tstruct _image_t noattr)))
                               (tptr (Tstruct _image_t noattr)))
                             (Tstruct _image_t noattr))
                           (Tstruct _image_t noattr)) _buf_size tuint)
                       (Ebinop Omul
                         (Ebinop Omul (Esizeof tshort tulong)
                           (Evalof (Evar _width tushort) tushort) tulong)
                         (Evalof (Evar _height tushort) tushort) tulong)
                       tuint))
                (Sdo (Eassign
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _img (tptr (Tstruct _image_t noattr)))
                               (tptr (Tstruct _image_t noattr)))
                             (Tstruct _image_t noattr))
                           (Tstruct _image_t noattr)) _buf_size tuint)
                       (Ebinop Omul
                         (Ebinop Omul (Esizeof tuchar tulong)
                           (Evalof (Evar _width tushort) tushort) tulong)
                         (Evalof (Evar _height tushort) tushort) tulong)
                       tuint))))))
        (Sdo (Eassign
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _img (tptr (Tstruct _image_t noattr)))
                       (tptr (Tstruct _image_t noattr)))
                     (Tstruct _image_t noattr)) (Tstruct _image_t noattr))
                 _buf (tptr tvoid))
               (Ecall
                 (Evalof
                   (Evar _aligned_alloc (Tfunction (tulong :: tulong :: nil)
                                          (tptr tvoid) cc_default))
                   (Tfunction (tulong :: tulong :: nil) (tptr tvoid)
                     cc_default))
                 (Econs (Eval (Vint (Int.repr 64)) tint)
                   (Econs
                     (Ebinop Oadd
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _img (tptr (Tstruct _image_t noattr)))
                                 (tptr (Tstruct _image_t noattr)))
                               (Tstruct _image_t noattr))
                             (Tstruct _image_t noattr)) _buf_size tuint)
                         tuint)
                       (Ebinop Omod
                         (Ebinop Osub (Eval (Vint (Int.repr 64)) tint)
                           (Ebinop Omod
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _img (tptr (Tstruct _image_t noattr)))
                                       (tptr (Tstruct _image_t noattr)))
                                     (Tstruct _image_t noattr))
                                   (Tstruct _image_t noattr)) _buf_size
                                 tuint) tuint)
                             (Eval (Vint (Int.repr 64)) tint) tuint) tuint)
                         (Eval (Vint (Int.repr 64)) tint) tuint) tuint) Enil))
                 (tptr tvoid)) (tptr tvoid)))))))
|}.

Definition f_image_free := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_img, (tptr (Tstruct _image_t noattr))) :: nil);
  fn_vars := nil;
  fn_body :=
(Sifthenelse (Ebinop One
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _img (tptr (Tstruct _image_t noattr)))
                         (tptr (Tstruct _image_t noattr)))
                       (Tstruct _image_t noattr)) (Tstruct _image_t noattr))
                   _buf (tptr tvoid)) (tptr tvoid))
               (Ecast (Eval (Vint (Int.repr 0)) tint) (tptr tvoid)) tint)
  (Ssequence
    (Sdo (Ecall
           (Evalof
             (Evar _free (Tfunction ((tptr tvoid) :: nil) tvoid cc_default))
             (Tfunction ((tptr tvoid) :: nil) tvoid cc_default))
           (Econs
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _img (tptr (Tstruct _image_t noattr)))
                       (tptr (Tstruct _image_t noattr)))
                     (Tstruct _image_t noattr)) (Tstruct _image_t noattr))
                 _buf (tptr tvoid)) (tptr tvoid)) Enil) tvoid))
    (Sdo (Eassign
           (Efield
             (Evalof
               (Ederef
                 (Evalof (Evar _img (tptr (Tstruct _image_t noattr)))
                   (tptr (Tstruct _image_t noattr)))
                 (Tstruct _image_t noattr)) (Tstruct _image_t noattr)) _buf
             (tptr tvoid))
           (Ecast (Eval (Vint (Int.repr 0)) tint) (tptr tvoid)) (tptr tvoid))))
  Sskip)
|}.

Definition f_image_copy := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_input, (tptr (Tstruct _image_t noattr))) ::
                (_output, (tptr (Tstruct _image_t noattr))) :: nil);
  fn_vars := nil;
  fn_body :=
(Ssequence
  (Sifthenelse (Ebinop One
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _input (tptr (Tstruct _image_t noattr)))
                           (tptr (Tstruct _image_t noattr)))
                         (Tstruct _image_t noattr))
                       (Tstruct _image_t noattr)) _type tint) tint)
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _output (tptr (Tstruct _image_t noattr)))
                           (tptr (Tstruct _image_t noattr)))
                         (Tstruct _image_t noattr))
                       (Tstruct _image_t noattr)) _type tint) tint) tint)
    (Sreturn None)
    Sskip)
  (Ssequence
    (Sdo (Eassign
           (Efield
             (Evalof
               (Ederef
                 (Evalof (Evar _output (tptr (Tstruct _image_t noattr)))
                   (tptr (Tstruct _image_t noattr)))
                 (Tstruct _image_t noattr)) (Tstruct _image_t noattr)) _w
             tushort)
           (Evalof
             (Efield
               (Evalof
                 (Ederef
                   (Evalof (Evar _input (tptr (Tstruct _image_t noattr)))
                     (tptr (Tstruct _image_t noattr)))
                   (Tstruct _image_t noattr)) (Tstruct _image_t noattr)) _w
               tushort) tushort) tushort))
    (Ssequence
      (Sdo (Eassign
             (Efield
               (Evalof
                 (Ederef
                   (Evalof (Evar _output (tptr (Tstruct _image_t noattr)))
                     (tptr (Tstruct _image_t noattr)))
                   (Tstruct _image_t noattr)) (Tstruct _image_t noattr)) _h
               tushort)
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _input (tptr (Tstruct _image_t noattr)))
                       (tptr (Tstruct _image_t noattr)))
                     (Tstruct _image_t noattr)) (Tstruct _image_t noattr)) _h
                 tushort) tushort) tushort))
      (Ssequence
        (Sdo (Eassign
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _output (tptr (Tstruct _image_t noattr)))
                       (tptr (Tstruct _image_t noattr)))
                     (Tstruct _image_t noattr)) (Tstruct _image_t noattr))
                 _buf_size tuint)
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _input (tptr (Tstruct _image_t noattr)))
                         (tptr (Tstruct _image_t noattr)))
                       (Tstruct _image_t noattr)) (Tstruct _image_t noattr))
                   _buf_size tuint) tuint) tuint))
        (Ssequence
          (Sdo (Eassign
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof
                         (Evar _output (tptr (Tstruct _image_t noattr)))
                         (tptr (Tstruct _image_t noattr)))
                       (Tstruct _image_t noattr)) (Tstruct _image_t noattr))
                   _ts (Tstruct _timeval noattr))
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _input (tptr (Tstruct _image_t noattr)))
                           (tptr (Tstruct _image_t noattr)))
                         (Tstruct _image_t noattr))
                       (Tstruct _image_t noattr)) _ts
                     (Tstruct _timeval noattr)) (Tstruct _timeval noattr))
                 (Tstruct _timeval noattr)))
          (Ssequence
            (Sdo (Eassign
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _output (tptr (Tstruct _image_t noattr)))
                           (tptr (Tstruct _image_t noattr)))
                         (Tstruct _image_t noattr))
                       (Tstruct _image_t noattr)) _eulers
                     (Tstruct _FloatEulers noattr))
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _input (tptr (Tstruct _image_t noattr)))
                             (tptr (Tstruct _image_t noattr)))
                           (Tstruct _image_t noattr))
                         (Tstruct _image_t noattr)) _eulers
                       (Tstruct _FloatEulers noattr))
                     (Tstruct _FloatEulers noattr))
                   (Tstruct _FloatEulers noattr)))
            (Ssequence
              (Sdo (Eassign
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _output (tptr (Tstruct _image_t noattr)))
                             (tptr (Tstruct _image_t noattr)))
                           (Tstruct _image_t noattr))
                         (Tstruct _image_t noattr)) _pprz_ts tuint)
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _input (tptr (Tstruct _image_t noattr)))
                               (tptr (Tstruct _image_t noattr)))
                             (Tstruct _image_t noattr))
                           (Tstruct _image_t noattr)) _pprz_ts tuint) tuint)
                     tuint))
              (Sdo (Ecall
                     (Evalof
                       (Evar _memcpy (Tfunction
                                       ((tptr tvoid) :: (tptr tvoid) ::
                                        tulong :: nil) (tptr tvoid)
                                       cc_default))
                       (Tfunction
                         ((tptr tvoid) :: (tptr tvoid) :: tulong :: nil)
                         (tptr tvoid) cc_default))
                     (Econs
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _output (tptr (Tstruct _image_t noattr)))
                                 (tptr (Tstruct _image_t noattr)))
                               (Tstruct _image_t noattr))
                             (Tstruct _image_t noattr)) _buf (tptr tvoid))
                         (tptr tvoid))
                       (Econs
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _input (tptr (Tstruct _image_t noattr)))
                                   (tptr (Tstruct _image_t noattr)))
                                 (Tstruct _image_t noattr))
                               (Tstruct _image_t noattr)) _buf (tptr tvoid))
                           (tptr tvoid))
                         (Econs
                           (Evalof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _input (tptr (Tstruct _image_t noattr)))
                                     (tptr (Tstruct _image_t noattr)))
                                   (Tstruct _image_t noattr))
                                 (Tstruct _image_t noattr)) _buf_size tuint)
                             tuint) Enil))) (tptr tvoid))))))))))
|}.

Definition f_image_switch := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_a, (tptr (Tstruct _image_t noattr))) ::
                (_b, (tptr (Tstruct _image_t noattr))) :: nil);
  fn_vars := ((_old_a, (Tstruct _image_t noattr)) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Ecall
         (Evalof
           (Evar _memcpy (Tfunction
                           ((tptr tvoid) :: (tptr tvoid) :: tulong :: nil)
                           (tptr tvoid) cc_default))
           (Tfunction ((tptr tvoid) :: (tptr tvoid) :: tulong :: nil)
             (tptr tvoid) cc_default))
         (Econs
           (Eaddrof (Evar _old_a (Tstruct _image_t noattr))
             (tptr (Tstruct _image_t noattr)))
           (Econs
             (Evalof (Evar _a (tptr (Tstruct _image_t noattr)))
               (tptr (Tstruct _image_t noattr)))
             (Econs (Esizeof (Tstruct _image_t noattr) tulong) Enil)))
         (tptr tvoid)))
  (Ssequence
    (Sdo (Ecall
           (Evalof
             (Evar _memcpy (Tfunction
                             ((tptr tvoid) :: (tptr tvoid) :: tulong :: nil)
                             (tptr tvoid) cc_default))
             (Tfunction ((tptr tvoid) :: (tptr tvoid) :: tulong :: nil)
               (tptr tvoid) cc_default))
           (Econs
             (Evalof (Evar _a (tptr (Tstruct _image_t noattr)))
               (tptr (Tstruct _image_t noattr)))
             (Econs
               (Evalof (Evar _b (tptr (Tstruct _image_t noattr)))
                 (tptr (Tstruct _image_t noattr)))
               (Econs (Esizeof (Tstruct _image_t noattr) tulong) Enil)))
           (tptr tvoid)))
    (Sdo (Ecall
           (Evalof
             (Evar _memcpy (Tfunction
                             ((tptr tvoid) :: (tptr tvoid) :: tulong :: nil)
                             (tptr tvoid) cc_default))
             (Tfunction ((tptr tvoid) :: (tptr tvoid) :: tulong :: nil)
               (tptr tvoid) cc_default))
           (Econs
             (Evalof (Evar _b (tptr (Tstruct _image_t noattr)))
               (tptr (Tstruct _image_t noattr)))
             (Econs
               (Eaddrof (Evar _old_a (Tstruct _image_t noattr))
                 (tptr (Tstruct _image_t noattr)))
               (Econs (Esizeof (Tstruct _image_t noattr) tulong) Enil)))
           (tptr tvoid)))))
|}.

Definition f_image_to_grayscale := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_input, (tptr (Tstruct _image_t noattr))) ::
                (_output, (tptr (Tstruct _image_t noattr))) :: nil);
  fn_vars := ((_source, (tptr tuchar)) :: (_dest, (tptr tuchar)) ::
              (_height, tint) :: (_width, tint) :: (_y, tint) ::
              (_x, tint) :: (_y__1, tint) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Eassign (Evar _source (tptr tuchar))
         (Evalof
           (Efield
             (Evalof
               (Ederef
                 (Evalof (Evar _input (tptr (Tstruct _image_t noattr)))
                   (tptr (Tstruct _image_t noattr)))
                 (Tstruct _image_t noattr)) (Tstruct _image_t noattr)) _buf
             (tptr tvoid)) (tptr tvoid)) (tptr tuchar)))
  (Ssequence
    (Sdo (Eassign (Evar _dest (tptr tuchar))
           (Evalof
             (Efield
               (Evalof
                 (Ederef
                   (Evalof (Evar _output (tptr (Tstruct _image_t noattr)))
                     (tptr (Tstruct _image_t noattr)))
                   (Tstruct _image_t noattr)) (Tstruct _image_t noattr)) _buf
               (tptr tvoid)) (tptr tvoid)) (tptr tuchar)))
    (Ssequence
      (Sdo (Epostincr Incr (Evar _source (tptr tuchar)) (tptr tuchar)))
      (Ssequence
        (Sdo (Eassign
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _output (tptr (Tstruct _image_t noattr)))
                       (tptr (Tstruct _image_t noattr)))
                     (Tstruct _image_t noattr)) (Tstruct _image_t noattr))
                 _ts (Tstruct _timeval noattr))
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _input (tptr (Tstruct _image_t noattr)))
                         (tptr (Tstruct _image_t noattr)))
                       (Tstruct _image_t noattr)) (Tstruct _image_t noattr))
                   _ts (Tstruct _timeval noattr)) (Tstruct _timeval noattr))
               (Tstruct _timeval noattr)))
        (Ssequence
          (Sdo (Eassign
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof
                         (Evar _output (tptr (Tstruct _image_t noattr)))
                         (tptr (Tstruct _image_t noattr)))
                       (Tstruct _image_t noattr)) (Tstruct _image_t noattr))
                   _eulers (Tstruct _FloatEulers noattr))
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _input (tptr (Tstruct _image_t noattr)))
                           (tptr (Tstruct _image_t noattr)))
                         (Tstruct _image_t noattr))
                       (Tstruct _image_t noattr)) _eulers
                     (Tstruct _FloatEulers noattr))
                   (Tstruct _FloatEulers noattr))
                 (Tstruct _FloatEulers noattr)))
          (Ssequence
            (Sdo (Eassign
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _output (tptr (Tstruct _image_t noattr)))
                           (tptr (Tstruct _image_t noattr)))
                         (Tstruct _image_t noattr))
                       (Tstruct _image_t noattr)) _pprz_ts tuint)
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _input (tptr (Tstruct _image_t noattr)))
                             (tptr (Tstruct _image_t noattr)))
                           (Tstruct _image_t noattr))
                         (Tstruct _image_t noattr)) _pprz_ts tuint) tuint)
                   tuint))
            (Ssequence
              (Sdo (Eassign (Evar _height tint)
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _output (tptr (Tstruct _image_t noattr)))
                               (tptr (Tstruct _image_t noattr)))
                             (Tstruct _image_t noattr))
                           (Tstruct _image_t noattr)) _h tushort) tushort)
                     tint))
              (Ssequence
                (Sdo (Eassign (Evar _width tint)
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _output (tptr (Tstruct _image_t noattr)))
                                 (tptr (Tstruct _image_t noattr)))
                               (Tstruct _image_t noattr))
                             (Tstruct _image_t noattr)) _w tushort) tushort)
                       tint))
                (Sifthenelse (Ebinop Oeq
                               (Evalof
                                 (Efield
                                   (Evalof
                                     (Ederef
                                       (Evalof
                                         (Evar _output (tptr (Tstruct _image_t noattr)))
                                         (tptr (Tstruct _image_t noattr)))
                                       (Tstruct _image_t noattr))
                                     (Tstruct _image_t noattr)) _type tint)
                                 tint) (Eval (Vint (Int.repr 0)) tint) tint)
                  (Ssequence
                    (Sdo (Eassign (Evar _y tint)
                           (Eval (Vint (Int.repr 0)) tint) tint))
                    (Sfor
                      Sskip
                      (Ebinop Olt (Evalof (Evar _y tint) tint)
                        (Evalof (Evar _height tint) tint) tint)
                      (Sdo (Epostincr Incr (Evar _y tint) tint))
                      (Ssequence
                        (Sdo (Eassign (Evar _x tint)
                               (Eval (Vint (Int.repr 0)) tint) tint))
                        (Sfor
                          Sskip
                          (Ebinop Olt (Evalof (Evar _x tint) tint)
                            (Evalof (Evar _width tint) tint) tint)
                          (Sdo (Epostincr Incr (Evar _x tint) tint))
                          (Ssequence
                            (Sdo (Eassign
                                   (Ederef
                                     (Epostincr Incr
                                       (Evar _dest (tptr tuchar))
                                       (tptr tuchar)) tuchar)
                                   (Eval (Vint (Int.repr 127)) tint) tuchar))
                            (Ssequence
                              (Sdo (Eassign
                                     (Ederef
                                       (Epostincr Incr
                                         (Evar _dest (tptr tuchar))
                                         (tptr tuchar)) tuchar)
                                     (Evalof
                                       (Ederef
                                         (Evalof (Evar _source (tptr tuchar))
                                           (tptr tuchar)) tuchar) tuchar)
                                     tuchar))
                              (Sdo (Eassignop Oadd
                                     (Evar _source (tptr tuchar))
                                     (Eval (Vint (Int.repr 2)) tint)
                                     (tptr tuchar) (tptr tuchar)))))))))
                  (Ssequence
                    (Sdo (Eassign (Evar _y__1 tint)
                           (Eval (Vint (Int.repr 0)) tint) tint))
                    (Sfor
                      Sskip
                      (Ebinop Olt (Evalof (Evar _y__1 tint) tint)
                        (Ebinop Omul (Evalof (Evar _height tint) tint)
                          (Evalof (Evar _width tint) tint) tint) tint)
                      (Sdo (Epostincr Incr (Evar _y__1 tint) tint))
                      (Ssequence
                        (Sdo (Eassign
                               (Ederef
                                 (Epostincr Incr (Evar _dest (tptr tuchar))
                                   (tptr tuchar)) tuchar)
                               (Evalof
                                 (Ederef
                                   (Epostincr Incr
                                     (Evar _source (tptr tuchar))
                                     (tptr tuchar)) tuchar) tuchar) tuchar))
                        (Sdo (Epostincr Incr (Evar _source (tptr tuchar))
                               (tptr tuchar)))))))))))))))
|}.

Definition f_image_yuv422_colorfilt := {|
  fn_return := tushort;
  fn_callconv := cc_default;
  fn_params := ((_input, (tptr (Tstruct _image_t noattr))) ::
                (_output, (tptr (Tstruct _image_t noattr))) ::
                (_y_m, tuchar) :: (_y_M, tuchar) :: (_u_m, tuchar) ::
                (_u_M, tuchar) :: (_v_m, tuchar) :: (_v_M, tuchar) :: nil);
  fn_vars := ((_cnt, tushort) :: (_source, (tptr tuchar)) ::
              (_dest, (tptr tuchar)) :: (_y, tushort) :: (_x, tushort) ::
              (_u, tschar) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Eassign (Evar _cnt tushort) (Eval (Vint (Int.repr 0)) tint) tushort))
  (Ssequence
    (Sdo (Eassign (Evar _source (tptr tuchar))
           (Ecast
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _input (tptr (Tstruct _image_t noattr)))
                       (tptr (Tstruct _image_t noattr)))
                     (Tstruct _image_t noattr)) (Tstruct _image_t noattr))
                 _buf (tptr tvoid)) (tptr tvoid)) (tptr tuchar))
           (tptr tuchar)))
    (Ssequence
      (Sdo (Eassign (Evar _dest (tptr tuchar))
             (Ecast
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof
                         (Evar _output (tptr (Tstruct _image_t noattr)))
                         (tptr (Tstruct _image_t noattr)))
                       (Tstruct _image_t noattr)) (Tstruct _image_t noattr))
                   _buf (tptr tvoid)) (tptr tvoid)) (tptr tuchar))
             (tptr tuchar)))
      (Ssequence
        (Sdo (Eassign
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _output (tptr (Tstruct _image_t noattr)))
                       (tptr (Tstruct _image_t noattr)))
                     (Tstruct _image_t noattr)) (Tstruct _image_t noattr))
                 _ts (Tstruct _timeval noattr))
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _input (tptr (Tstruct _image_t noattr)))
                         (tptr (Tstruct _image_t noattr)))
                       (Tstruct _image_t noattr)) (Tstruct _image_t noattr))
                   _ts (Tstruct _timeval noattr)) (Tstruct _timeval noattr))
               (Tstruct _timeval noattr)))
        (Ssequence
          (Ssequence
            (Sdo (Eassign (Evar _y tushort) (Eval (Vint (Int.repr 0)) tint)
                   tushort))
            (Sfor
              Sskip
              (Ebinop Olt (Evalof (Evar _y tushort) tushort)
                (Evalof
                  (Efield
                    (Evalof
                      (Ederef
                        (Evalof
                          (Evar _output (tptr (Tstruct _image_t noattr)))
                          (tptr (Tstruct _image_t noattr)))
                        (Tstruct _image_t noattr)) (Tstruct _image_t noattr))
                    _h tushort) tushort) tint)
              (Sdo (Epostincr Incr (Evar _y tushort) tushort))
              (Ssequence
                (Sdo (Eassign (Evar _x tushort)
                       (Eval (Vint (Int.repr 0)) tint) tushort))
                (Sfor
                  Sskip
                  (Ebinop Olt (Evalof (Evar _x tushort) tushort)
                    (Evalof
                      (Efield
                        (Evalof
                          (Ederef
                            (Evalof
                              (Evar _output (tptr (Tstruct _image_t noattr)))
                              (tptr (Tstruct _image_t noattr)))
                            (Tstruct _image_t noattr))
                          (Tstruct _image_t noattr)) _w tushort) tushort)
                    tint)
                  (Sdo (Eassignop Oadd (Evar _x tushort)
                         (Eval (Vint (Int.repr 2)) tint) tint tushort))
                  (Ssequence
                    (Sifthenelse (Eseqand
                                   (Eseqand
                                     (Eseqand
                                       (Eseqand
                                         (Eseqand
                                           (Ebinop Oge
                                             (Evalof
                                               (Ederef
                                                 (Ebinop Oadd
                                                   (Evalof
                                                     (Evar _dest (tptr tuchar))
                                                     (tptr tuchar))
                                                   (Eval (Vint (Int.repr 1)) tint)
                                                   (tptr tuchar)) tuchar)
                                               tuchar)
                                             (Evalof (Evar _y_m tuchar)
                                               tuchar) tint)
                                           (Ebinop Ole
                                             (Evalof
                                               (Ederef
                                                 (Ebinop Oadd
                                                   (Evalof
                                                     (Evar _dest (tptr tuchar))
                                                     (tptr tuchar))
                                                   (Eval (Vint (Int.repr 1)) tint)
                                                   (tptr tuchar)) tuchar)
                                               tuchar)
                                             (Evalof (Evar _y_M tuchar)
                                               tuchar) tint) tint)
                                         (Ebinop Oge
                                           (Evalof
                                             (Ederef
                                               (Ebinop Oadd
                                                 (Evalof
                                                   (Evar _dest (tptr tuchar))
                                                   (tptr tuchar))
                                                 (Eval (Vint (Int.repr 0)) tint)
                                                 (tptr tuchar)) tuchar)
                                             tuchar)
                                           (Evalof (Evar _u_m tuchar) tuchar)
                                           tint) tint)
                                       (Ebinop Ole
                                         (Evalof
                                           (Ederef
                                             (Ebinop Oadd
                                               (Evalof
                                                 (Evar _dest (tptr tuchar))
                                                 (tptr tuchar))
                                               (Eval (Vint (Int.repr 0)) tint)
                                               (tptr tuchar)) tuchar) tuchar)
                                         (Evalof (Evar _u_M tuchar) tuchar)
                                         tint) tint)
                                     (Ebinop Oge
                                       (Evalof
                                         (Ederef
                                           (Ebinop Oadd
                                             (Evalof
                                               (Evar _dest (tptr tuchar))
                                               (tptr tuchar))
                                             (Eval (Vint (Int.repr 2)) tint)
                                             (tptr tuchar)) tuchar) tuchar)
                                       (Evalof (Evar _v_m tuchar) tuchar)
                                       tint) tint)
                                   (Ebinop Ole
                                     (Evalof
                                       (Ederef
                                         (Ebinop Oadd
                                           (Evalof (Evar _dest (tptr tuchar))
                                             (tptr tuchar))
                                           (Eval (Vint (Int.repr 2)) tint)
                                           (tptr tuchar)) tuchar) tuchar)
                                     (Evalof (Evar _v_M tuchar) tuchar) tint)
                                   tint)
                      (Ssequence
                        (Sdo (Epostincr Incr (Evar _cnt tushort) tushort))
                        (Ssequence
                          (Sdo (Eassign
                                 (Ederef
                                   (Ebinop Oadd
                                     (Evalof (Evar _dest (tptr tuchar))
                                       (tptr tuchar))
                                     (Eval (Vint (Int.repr 0)) tint)
                                     (tptr tuchar)) tuchar)
                                 (Eval (Vint (Int.repr 64)) tint) tuchar))
                          (Ssequence
                            (Sdo (Eassign
                                   (Ederef
                                     (Ebinop Oadd
                                       (Evalof (Evar _dest (tptr tuchar))
                                         (tptr tuchar))
                                       (Eval (Vint (Int.repr 1)) tint)
                                       (tptr tuchar)) tuchar)
                                   (Evalof
                                     (Ederef
                                       (Ebinop Oadd
                                         (Evalof (Evar _source (tptr tuchar))
                                           (tptr tuchar))
                                         (Eval (Vint (Int.repr 1)) tint)
                                         (tptr tuchar)) tuchar) tuchar)
                                   tuchar))
                            (Ssequence
                              (Sdo (Eassign
                                     (Ederef
                                       (Ebinop Oadd
                                         (Evalof (Evar _dest (tptr tuchar))
                                           (tptr tuchar))
                                         (Eval (Vint (Int.repr 2)) tint)
                                         (tptr tuchar)) tuchar)
                                     (Eval (Vint (Int.repr 255)) tint)
                                     tuchar))
                              (Sdo (Eassign
                                     (Ederef
                                       (Ebinop Oadd
                                         (Evalof (Evar _dest (tptr tuchar))
                                           (tptr tuchar))
                                         (Eval (Vint (Int.repr 3)) tint)
                                         (tptr tuchar)) tuchar)
                                     (Evalof
                                       (Ederef
                                         (Ebinop Oadd
                                           (Evalof
                                             (Evar _source (tptr tuchar))
                                             (tptr tuchar))
                                           (Eval (Vint (Int.repr 3)) tint)
                                           (tptr tuchar)) tuchar) tuchar)
                                     tuchar))))))
                      (Ssequence
                        (Sdo (Eassign (Evar _u tschar)
                               (Ebinop Osub
                                 (Evalof
                                   (Ederef
                                     (Ebinop Oadd
                                       (Evalof (Evar _source (tptr tuchar))
                                         (tptr tuchar))
                                       (Eval (Vint (Int.repr 0)) tint)
                                       (tptr tuchar)) tuchar) tuchar)
                                 (Eval (Vint (Int.repr 127)) tint) tint)
                               tschar))
                        (Ssequence
                          (Sdo (Eassignop Odiv (Evar _u tschar)
                                 (Eval (Vint (Int.repr 4)) tint) tint tschar))
                          (Ssequence
                            (Sdo (Eassign
                                   (Ederef
                                     (Ebinop Oadd
                                       (Evalof (Evar _dest (tptr tuchar))
                                         (tptr tuchar))
                                       (Eval (Vint (Int.repr 0)) tint)
                                       (tptr tuchar)) tuchar)
                                   (Eval (Vint (Int.repr 127)) tint) tuchar))
                            (Ssequence
                              (Sdo (Eassign
                                     (Ederef
                                       (Ebinop Oadd
                                         (Evalof (Evar _dest (tptr tuchar))
                                           (tptr tuchar))
                                         (Eval (Vint (Int.repr 1)) tint)
                                         (tptr tuchar)) tuchar)
                                     (Evalof
                                       (Ederef
                                         (Ebinop Oadd
                                           (Evalof
                                             (Evar _source (tptr tuchar))
                                             (tptr tuchar))
                                           (Eval (Vint (Int.repr 1)) tint)
                                           (tptr tuchar)) tuchar) tuchar)
                                     tuchar))
                              (Ssequence
                                (Sdo (Eassign (Evar _u tschar)
                                       (Ebinop Osub
                                         (Evalof
                                           (Ederef
                                             (Ebinop Oadd
                                               (Evalof
                                                 (Evar _source (tptr tuchar))
                                                 (tptr tuchar))
                                               (Eval (Vint (Int.repr 2)) tint)
                                               (tptr tuchar)) tuchar) tuchar)
                                         (Eval (Vint (Int.repr 127)) tint)
                                         tint) tschar))
                                (Ssequence
                                  (Sdo (Eassignop Odiv (Evar _u tschar)
                                         (Eval (Vint (Int.repr 4)) tint)
                                         tint tschar))
                                  (Ssequence
                                    (Sdo (Eassign
                                           (Ederef
                                             (Ebinop Oadd
                                               (Evalof
                                                 (Evar _dest (tptr tuchar))
                                                 (tptr tuchar))
                                               (Eval (Vint (Int.repr 2)) tint)
                                               (tptr tuchar)) tuchar)
                                           (Eval (Vint (Int.repr 127)) tint)
                                           tuchar))
                                    (Sdo (Eassign
                                           (Ederef
                                             (Ebinop Oadd
                                               (Evalof
                                                 (Evar _dest (tptr tuchar))
                                                 (tptr tuchar))
                                               (Eval (Vint (Int.repr 3)) tint)
                                               (tptr tuchar)) tuchar)
                                           (Evalof
                                             (Ederef
                                               (Ebinop Oadd
                                                 (Evalof
                                                   (Evar _source (tptr tuchar))
                                                   (tptr tuchar))
                                                 (Eval (Vint (Int.repr 3)) tint)
                                                 (tptr tuchar)) tuchar)
                                             tuchar) tuchar))))))))))
                    (Ssequence
                      (Sdo (Eassignop Oadd (Evar _dest (tptr tuchar))
                             (Eval (Vint (Int.repr 4)) tint)
                             (tptr tuchar) (tptr tuchar)))
                      (Sdo (Eassignop Oadd (Evar _source (tptr tuchar))
                             (Eval (Vint (Int.repr 4)) tint)
                             (tptr tuchar) (tptr tuchar)))))))))
          (Sreturn (Some (Evalof (Evar _cnt tushort) tushort))))))))
|}.

Definition f_check_color_yuv422 := {|
  fn_return := tint;
  fn_callconv := cc_default;
  fn_params := ((_im, (tptr (Tstruct _image_t noattr))) :: (_x, tint) ::
                (_y, tint) :: (_y_m, tuchar) :: (_y_M, tuchar) ::
                (_u_m, tuchar) :: (_u_M, tuchar) :: (_v_m, tuchar) ::
                (_v_M, tuchar) :: nil);
  fn_vars := ((_buf, (tptr tuchar)) :: nil);
  fn_body :=
(Ssequence
  (Sifthenelse (Ebinop Oeq
                 (Ebinop Omod (Evalof (Evar _x tint) tint)
                   (Eval (Vint (Int.repr 2)) tint) tint)
                 (Eval (Vint (Int.repr 1)) tint) tint)
    (Sdo (Epostincr Decr (Evar _x tint) tint))
    Sskip)
  (Ssequence
    (Sifthenelse (Eseqor
                   (Eseqor
                     (Eseqor
                       (Ebinop Olt (Evalof (Evar _x tint) tint)
                         (Eval (Vint (Int.repr 0)) tint) tint)
                       (Ebinop Oge (Evalof (Evar _x tint) tint)
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _im (tptr (Tstruct _image_t noattr)))
                                   (tptr (Tstruct _image_t noattr)))
                                 (Tstruct _image_t noattr))
                               (Tstruct _image_t noattr)) _w tushort)
                           tushort) tint) tint)
                     (Ebinop Olt (Evalof (Evar _y tint) tint)
                       (Eval (Vint (Int.repr 0)) tint) tint) tint)
                   (Ebinop Oge (Evalof (Evar _y tint) tint)
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _im (tptr (Tstruct _image_t noattr)))
                               (tptr (Tstruct _image_t noattr)))
                             (Tstruct _image_t noattr))
                           (Tstruct _image_t noattr)) _h tushort) tushort)
                     tint) tint)
      (Sreturn (Some (Eval (Vint (Int.repr 0)) tint)))
      Sskip)
    (Ssequence
      (Sdo (Eassign (Evar _buf (tptr tuchar))
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _im (tptr (Tstruct _image_t noattr)))
                       (tptr (Tstruct _image_t noattr)))
                     (Tstruct _image_t noattr)) (Tstruct _image_t noattr))
                 _buf (tptr tvoid)) (tptr tvoid)) (tptr tuchar)))
      (Ssequence
        (Sdo (Eassignop Oadd (Evar _buf (tptr tuchar))
               (Ebinop Omul (Eval (Vint (Int.repr 2)) tint)
                 (Ebinop Oadd
                   (Ebinop Omul (Evalof (Evar _y tint) tint)
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _im (tptr (Tstruct _image_t noattr)))
                               (tptr (Tstruct _image_t noattr)))
                             (Tstruct _image_t noattr))
                           (Tstruct _image_t noattr)) _w tushort) tushort)
                     tint) (Evalof (Evar _x tint) tint) tint) tint)
               (tptr tuchar) (tptr tuchar)))
        (Sifthenelse (Eseqand
                       (Eseqand
                         (Eseqand
                           (Eseqand
                             (Eseqand
                               (Ebinop Oge
                                 (Evalof
                                   (Ederef
                                     (Ebinop Oadd
                                       (Evalof (Evar _buf (tptr tuchar))
                                         (tptr tuchar))
                                       (Eval (Vint (Int.repr 1)) tint)
                                       (tptr tuchar)) tuchar) tuchar)
                                 (Evalof (Evar _y_m tuchar) tuchar) tint)
                               (Ebinop Ole
                                 (Evalof
                                   (Ederef
                                     (Ebinop Oadd
                                       (Evalof (Evar _buf (tptr tuchar))
                                         (tptr tuchar))
                                       (Eval (Vint (Int.repr 1)) tint)
                                       (tptr tuchar)) tuchar) tuchar)
                                 (Evalof (Evar _y_M tuchar) tuchar) tint)
                               tint)
                             (Ebinop Oge
                               (Evalof
                                 (Ederef
                                   (Ebinop Oadd
                                     (Evalof (Evar _buf (tptr tuchar))
                                       (tptr tuchar))
                                     (Eval (Vint (Int.repr 0)) tint)
                                     (tptr tuchar)) tuchar) tuchar)
                               (Evalof (Evar _u_m tuchar) tuchar) tint) tint)
                           (Ebinop Ole
                             (Evalof
                               (Ederef
                                 (Ebinop Oadd
                                   (Evalof (Evar _buf (tptr tuchar))
                                     (tptr tuchar))
                                   (Eval (Vint (Int.repr 0)) tint)
                                   (tptr tuchar)) tuchar) tuchar)
                             (Evalof (Evar _u_M tuchar) tuchar) tint) tint)
                         (Ebinop Oge
                           (Evalof
                             (Ederef
                               (Ebinop Oadd
                                 (Evalof (Evar _buf (tptr tuchar))
                                   (tptr tuchar))
                                 (Eval (Vint (Int.repr 2)) tint)
                                 (tptr tuchar)) tuchar) tuchar)
                           (Evalof (Evar _v_m tuchar) tuchar) tint) tint)
                       (Ebinop Ole
                         (Evalof
                           (Ederef
                             (Ebinop Oadd
                               (Evalof (Evar _buf (tptr tuchar))
                                 (tptr tuchar))
                               (Eval (Vint (Int.repr 2)) tint) (tptr tuchar))
                             tuchar) tuchar)
                         (Evalof (Evar _v_M tuchar) tuchar) tint) tint)
          (Sreturn (Some (Eval (Vint (Int.repr 1)) tint)))
          (Sreturn (Some (Eval (Vint (Int.repr 0)) tint))))))))
|}.

Definition f_set_color_yuv422 := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_im, (tptr (Tstruct _image_t noattr))) :: (_x, tint) ::
                (_y, tint) :: (_Y, tuchar) :: (_U, tuchar) :: (_V, tuchar) ::
                nil);
  fn_vars := ((_buf, (tptr tuchar)) :: nil);
  fn_body :=
(Ssequence
  (Sifthenelse (Ebinop Oeq
                 (Ebinop Omod (Evalof (Evar _x tint) tint)
                   (Eval (Vint (Int.repr 2)) tint) tint)
                 (Eval (Vint (Int.repr 1)) tint) tint)
    (Sdo (Epostincr Decr (Evar _x tint) tint))
    Sskip)
  (Ssequence
    (Sifthenelse (Eseqor
                   (Eseqor
                     (Eseqor
                       (Ebinop Olt (Evalof (Evar _x tint) tint)
                         (Eval (Vint (Int.repr 0)) tint) tint)
                       (Ebinop Oge (Evalof (Evar _x tint) tint)
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _im (tptr (Tstruct _image_t noattr)))
                                   (tptr (Tstruct _image_t noattr)))
                                 (Tstruct _image_t noattr))
                               (Tstruct _image_t noattr)) _w tushort)
                           tushort) tint) tint)
                     (Ebinop Olt (Evalof (Evar _y tint) tint)
                       (Eval (Vint (Int.repr 0)) tint) tint) tint)
                   (Ebinop Oge (Evalof (Evar _y tint) tint)
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _im (tptr (Tstruct _image_t noattr)))
                               (tptr (Tstruct _image_t noattr)))
                             (Tstruct _image_t noattr))
                           (Tstruct _image_t noattr)) _h tushort) tushort)
                     tint) tint)
      (Sreturn None)
      Sskip)
    (Ssequence
      (Sdo (Eassign (Evar _buf (tptr tuchar))
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _im (tptr (Tstruct _image_t noattr)))
                       (tptr (Tstruct _image_t noattr)))
                     (Tstruct _image_t noattr)) (Tstruct _image_t noattr))
                 _buf (tptr tvoid)) (tptr tvoid)) (tptr tuchar)))
      (Ssequence
        (Sdo (Eassignop Oadd (Evar _buf (tptr tuchar))
               (Ebinop Omul (Eval (Vint (Int.repr 2)) tint)
                 (Ebinop Oadd
                   (Ebinop Omul (Evalof (Evar _y tint) tint)
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _im (tptr (Tstruct _image_t noattr)))
                               (tptr (Tstruct _image_t noattr)))
                             (Tstruct _image_t noattr))
                           (Tstruct _image_t noattr)) _w tushort) tushort)
                     tint) (Evalof (Evar _x tint) tint) tint) tint)
               (tptr tuchar) (tptr tuchar)))
        (Ssequence
          (Sdo (Eassign
                 (Ederef
                   (Ebinop Oadd
                     (Evalof (Evar _buf (tptr tuchar)) (tptr tuchar))
                     (Eval (Vint (Int.repr 0)) tint) (tptr tuchar)) tuchar)
                 (Evalof (Evar _U tuchar) tuchar) tuchar))
          (Ssequence
            (Sdo (Eassign
                   (Ederef
                     (Ebinop Oadd
                       (Evalof (Evar _buf (tptr tuchar)) (tptr tuchar))
                       (Eval (Vint (Int.repr 1)) tint) (tptr tuchar)) tuchar)
                   (Evalof (Evar _Y tuchar) tuchar) tuchar))
            (Ssequence
              (Sdo (Eassign
                     (Ederef
                       (Ebinop Oadd
                         (Evalof (Evar _buf (tptr tuchar)) (tptr tuchar))
                         (Eval (Vint (Int.repr 2)) tint) (tptr tuchar))
                       tuchar) (Evalof (Evar _V tuchar) tuchar) tuchar))
              (Sdo (Eassign
                     (Ederef
                       (Ebinop Oadd
                         (Evalof (Evar _buf (tptr tuchar)) (tptr tuchar))
                         (Eval (Vint (Int.repr 3)) tint) (tptr tuchar))
                       tuchar) (Evalof (Evar _Y tuchar) tuchar) tuchar)))))))))
|}.

Definition f_image_yuv422_downsample := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_input, (tptr (Tstruct _image_t noattr))) ::
                (_output, (tptr (Tstruct _image_t noattr))) ::
                (_downsample, tuchar) :: nil);
  fn_vars := ((_i, tschar) :: (_source, (tptr tuchar)) ::
              (_dest, (tptr tuchar)) :: (_pixelskip, tushort) ::
              (_y, tushort) :: (_x, tushort) :: nil);
  fn_body :=
(Ssequence
  (Sifthenelse (Ebinop Olt (Evalof (Evar _downsample tuchar) tuchar)
                 (Eval (Vint (Int.repr 1)) tint) tint)
    (Sdo (Eassign (Evar _downsample tuchar) (Eval (Vint (Int.repr 1)) tint)
           tuchar))
    Sskip)
  (Ssequence
    (Sifthenelse (Ebinop One
                   (Ebinop Oand (Evalof (Evar _downsample tuchar) tuchar)
                     (Ebinop Osub (Evalof (Evar _downsample tuchar) tuchar)
                       (Eval (Vint (Int.repr 1)) tint) tint) tint)
                   (Eval (Vint (Int.repr 0)) tint) tint)
      (Ssequence
        (Ssequence
          (Sdo (Eassign (Evar _i tschar) (Eval (Vint (Int.repr 7)) tint)
                 tschar))
          (Sfor
            Sskip
            (Ebinop Ogt (Evalof (Evar _i tschar) tschar)
              (Eval (Vint (Int.repr 0)) tint) tint)
            (Sdo (Epostincr Decr (Evar _i tschar) tschar))
            (Sifthenelse (Ebinop Oand
                           (Evalof (Evar _downsample tuchar) tuchar)
                           (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                             (Evalof (Evar _i tschar) tschar) tint) tint)
              (Ssequence
                (Sdo (Eassignop Oand (Evar _downsample tuchar)
                       (Ebinop Oshl (Eval (Vint (Int.repr 1)) tint)
                         (Evalof (Evar _i tschar) tschar) tint) tint tuchar))
                Sbreak)
              Sskip)))
        (Sdo (Eassignop Omul (Evar _downsample tuchar)
               (Eval (Vint (Int.repr 2)) tint) tint tuchar)))
      Sskip)
    (Ssequence
      (Sdo (Eassign (Evar _source (tptr tuchar))
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _input (tptr (Tstruct _image_t noattr)))
                       (tptr (Tstruct _image_t noattr)))
                     (Tstruct _image_t noattr)) (Tstruct _image_t noattr))
                 _buf (tptr tvoid)) (tptr tvoid)) (tptr tuchar)))
      (Ssequence
        (Sdo (Eassign (Evar _dest (tptr tuchar))
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof
                         (Evar _output (tptr (Tstruct _image_t noattr)))
                         (tptr (Tstruct _image_t noattr)))
                       (Tstruct _image_t noattr)) (Tstruct _image_t noattr))
                   _buf (tptr tvoid)) (tptr tvoid)) (tptr tuchar)))
        (Ssequence
          (Sdo (Eassign (Evar _pixelskip tushort)
                 (Ebinop Omul
                   (Ebinop Osub (Evalof (Evar _downsample tuchar) tuchar)
                     (Eval (Vint (Int.repr 1)) tint) tint)
                   (Eval (Vint (Int.repr 2)) tint) tint) tushort))
          (Ssequence
            (Sdo (Eassign
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _output (tptr (Tstruct _image_t noattr)))
                           (tptr (Tstruct _image_t noattr)))
                         (Tstruct _image_t noattr))
                       (Tstruct _image_t noattr)) _w tushort)
                   (Ebinop Odiv
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _input (tptr (Tstruct _image_t noattr)))
                               (tptr (Tstruct _image_t noattr)))
                             (Tstruct _image_t noattr))
                           (Tstruct _image_t noattr)) _w tushort) tushort)
                     (Evalof (Evar _downsample tuchar) tuchar) tint) tushort))
            (Ssequence
              (Sdo (Eassign
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _output (tptr (Tstruct _image_t noattr)))
                             (tptr (Tstruct _image_t noattr)))
                           (Tstruct _image_t noattr))
                         (Tstruct _image_t noattr)) _h tushort)
                     (Ebinop Odiv
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _input (tptr (Tstruct _image_t noattr)))
                                 (tptr (Tstruct _image_t noattr)))
                               (Tstruct _image_t noattr))
                             (Tstruct _image_t noattr)) _h tushort) tushort)
                       (Evalof (Evar _downsample tuchar) tuchar) tint)
                     tushort))
              (Ssequence
                (Sdo (Eassign
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _output (tptr (Tstruct _image_t noattr)))
                               (tptr (Tstruct _image_t noattr)))
                             (Tstruct _image_t noattr))
                           (Tstruct _image_t noattr)) _type tint)
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _input (tptr (Tstruct _image_t noattr)))
                                 (tptr (Tstruct _image_t noattr)))
                               (Tstruct _image_t noattr))
                             (Tstruct _image_t noattr)) _type tint) tint)
                       tint))
                (Ssequence
                  (Sdo (Eassign
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _output (tptr (Tstruct _image_t noattr)))
                                 (tptr (Tstruct _image_t noattr)))
                               (Tstruct _image_t noattr))
                             (Tstruct _image_t noattr)) _ts
                           (Tstruct _timeval noattr))
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _input (tptr (Tstruct _image_t noattr)))
                                   (tptr (Tstruct _image_t noattr)))
                                 (Tstruct _image_t noattr))
                               (Tstruct _image_t noattr)) _ts
                             (Tstruct _timeval noattr))
                           (Tstruct _timeval noattr))
                         (Tstruct _timeval noattr)))
                  (Ssequence
                    (Sdo (Eassign (Evar _y tushort)
                           (Eval (Vint (Int.repr 0)) tint) tushort))
                    (Sfor
                      Sskip
                      (Ebinop Olt (Evalof (Evar _y tushort) tushort)
                        (Evalof
                          (Efield
                            (Evalof
                              (Ederef
                                (Evalof
                                  (Evar _output (tptr (Tstruct _image_t noattr)))
                                  (tptr (Tstruct _image_t noattr)))
                                (Tstruct _image_t noattr))
                              (Tstruct _image_t noattr)) _h tushort) tushort)
                        tint)
                      (Sdo (Epostincr Incr (Evar _y tushort) tushort))
                      (Ssequence
                        (Ssequence
                          (Sdo (Eassign (Evar _x tushort)
                                 (Eval (Vint (Int.repr 0)) tint) tushort))
                          (Sfor
                            Sskip
                            (Ebinop Olt (Evalof (Evar _x tushort) tushort)
                              (Evalof
                                (Efield
                                  (Evalof
                                    (Ederef
                                      (Evalof
                                        (Evar _output (tptr (Tstruct _image_t noattr)))
                                        (tptr (Tstruct _image_t noattr)))
                                      (Tstruct _image_t noattr))
                                    (Tstruct _image_t noattr)) _w tushort)
                                tushort) tint)
                            (Sdo (Eassignop Oadd (Evar _x tushort)
                                   (Eval (Vint (Int.repr 2)) tint)
                                   tint tushort))
                            (Ssequence
                              (Sdo (Eassign
                                     (Ederef
                                       (Epostincr Incr
                                         (Evar _dest (tptr tuchar))
                                         (tptr tuchar)) tuchar)
                                     (Evalof
                                       (Ederef
                                         (Epostincr Incr
                                           (Evar _source (tptr tuchar))
                                           (tptr tuchar)) tuchar) tuchar)
                                     tuchar))
                              (Ssequence
                                (Sdo (Eassign
                                       (Ederef
                                         (Epostincr Incr
                                           (Evar _dest (tptr tuchar))
                                           (tptr tuchar)) tuchar)
                                       (Evalof
                                         (Ederef
                                           (Epostincr Incr
                                             (Evar _source (tptr tuchar))
                                             (tptr tuchar)) tuchar) tuchar)
                                       tuchar))
                                (Ssequence
                                  (Sdo (Eassign
                                         (Ederef
                                           (Epostincr Incr
                                             (Evar _dest (tptr tuchar))
                                             (tptr tuchar)) tuchar)
                                         (Evalof
                                           (Ederef
                                             (Epostincr Incr
                                               (Evar _source (tptr tuchar))
                                               (tptr tuchar)) tuchar) tuchar)
                                         tuchar))
                                  (Ssequence
                                    (Sdo (Eassignop Oadd
                                           (Evar _source (tptr tuchar))
                                           (Evalof (Evar _pixelskip tushort)
                                             tushort)
                                           (tptr tuchar) (tptr tuchar)))
                                    (Ssequence
                                      (Sdo (Eassign
                                             (Ederef
                                               (Epostincr Incr
                                                 (Evar _dest (tptr tuchar))
                                                 (tptr tuchar)) tuchar)
                                             (Evalof
                                               (Ederef
                                                 (Epostincr Incr
                                                   (Evar _source (tptr tuchar))
                                                   (tptr tuchar)) tuchar)
                                               tuchar) tuchar))
                                      (Sdo (Eassignop Oadd
                                             (Evar _source (tptr tuchar))
                                             (Evalof
                                               (Evar _pixelskip tushort)
                                               tushort)
                                             (tptr tuchar) (tptr tuchar))))))))))
                        (Sdo (Eassignop Oadd (Evar _source (tptr tuchar))
                               (Ebinop Omul
                                 (Evalof (Evar _pixelskip tushort) tushort)
                                 (Evalof
                                   (Efield
                                     (Evalof
                                       (Ederef
                                         (Evalof
                                           (Evar _input (tptr (Tstruct _image_t noattr)))
                                           (tptr (Tstruct _image_t noattr)))
                                         (Tstruct _image_t noattr))
                                       (Tstruct _image_t noattr)) _w tushort)
                                   tushort) tint)
                               (tptr tuchar) (tptr tuchar)))))))))))))))
|}.

Definition f_image_add_border := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_input, (tptr (Tstruct _image_t noattr))) ::
                (_output, (tptr (Tstruct _image_t noattr))) ::
                (_border_size, tuchar) :: nil);
  fn_vars := ((_input_buf, (tptr tuchar)) :: (_output_buf, (tptr tuchar)) ::
              (_i, tushort) :: (_j, tuchar) :: (_j__1, tuchar) ::
              (_i__1, tuchar) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Ecall
         (Evalof
           (Evar _image_create (Tfunction
                                 ((tptr (Tstruct _image_t noattr)) ::
                                  tushort :: tushort :: tint :: nil) tvoid
                                 cc_default))
           (Tfunction
             ((tptr (Tstruct _image_t noattr)) :: tushort :: tushort ::
              tint :: nil) tvoid cc_default))
         (Econs
           (Evalof (Evar _output (tptr (Tstruct _image_t noattr)))
             (tptr (Tstruct _image_t noattr)))
           (Econs
             (Ebinop Oadd
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _input (tptr (Tstruct _image_t noattr)))
                         (tptr (Tstruct _image_t noattr)))
                       (Tstruct _image_t noattr)) (Tstruct _image_t noattr))
                   _w tushort) tushort)
               (Ebinop Omul (Eval (Vint (Int.repr 2)) tint)
                 (Evalof (Evar _border_size tuchar) tuchar) tint) tint)
             (Econs
               (Ebinop Oadd
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _input (tptr (Tstruct _image_t noattr)))
                           (tptr (Tstruct _image_t noattr)))
                         (Tstruct _image_t noattr))
                       (Tstruct _image_t noattr)) _h tushort) tushort)
                 (Ebinop Omul (Eval (Vint (Int.repr 2)) tint)
                   (Evalof (Evar _border_size tuchar) tuchar) tint) tint)
               (Econs
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _input (tptr (Tstruct _image_t noattr)))
                           (tptr (Tstruct _image_t noattr)))
                         (Tstruct _image_t noattr))
                       (Tstruct _image_t noattr)) _type tint) tint) Enil))))
         tvoid))
  (Ssequence
    (Sdo (Eassign (Evar _input_buf (tptr tuchar))
           (Ecast
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _input (tptr (Tstruct _image_t noattr)))
                       (tptr (Tstruct _image_t noattr)))
                     (Tstruct _image_t noattr)) (Tstruct _image_t noattr))
                 _buf (tptr tvoid)) (tptr tvoid)) (tptr tuchar))
           (tptr tuchar)))
    (Ssequence
      (Sdo (Eassign (Evar _output_buf (tptr tuchar))
             (Ecast
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof
                         (Evar _output (tptr (Tstruct _image_t noattr)))
                         (tptr (Tstruct _image_t noattr)))
                       (Tstruct _image_t noattr)) (Tstruct _image_t noattr))
                   _buf (tptr tvoid)) (tptr tvoid)) (tptr tuchar))
             (tptr tuchar)))
      (Ssequence
        (Ssequence
          (Sdo (Eassign (Evar _i tushort)
                 (Evalof (Evar _border_size tuchar) tuchar) tushort))
          (Sfor
            Sskip
            (Ebinop One (Evalof (Evar _i tushort) tushort)
              (Ebinop Osub
                (Evalof
                  (Efield
                    (Evalof
                      (Ederef
                        (Evalof
                          (Evar _output (tptr (Tstruct _image_t noattr)))
                          (tptr (Tstruct _image_t noattr)))
                        (Tstruct _image_t noattr)) (Tstruct _image_t noattr))
                    _h tushort) tushort)
                (Evalof (Evar _border_size tuchar) tuchar) tint) tint)
            (Sdo (Epostincr Incr (Evar _i tushort) tushort))
            (Ssequence
              (Ssequence
                (Sdo (Eassign (Evar _j tuchar)
                       (Eval (Vint (Int.repr 0)) tint) tuchar))
                (Sfor
                  Sskip
                  (Ebinop One (Evalof (Evar _j tuchar) tuchar)
                    (Evalof (Evar _border_size tuchar) tuchar) tint)
                  (Sdo (Epostincr Incr (Evar _j tuchar) tuchar))
                  (Sdo (Eassign
                         (Ederef
                           (Ebinop Oadd
                             (Evalof (Evar _output_buf (tptr tuchar))
                               (tptr tuchar))
                             (Ebinop Oadd
                               (Ebinop Omul
                                 (Evalof (Evar _i tushort) tushort)
                                 (Evalof
                                   (Efield
                                     (Evalof
                                       (Ederef
                                         (Evalof
                                           (Evar _output (tptr (Tstruct _image_t noattr)))
                                           (tptr (Tstruct _image_t noattr)))
                                         (Tstruct _image_t noattr))
                                       (Tstruct _image_t noattr)) _w tushort)
                                   tushort) tint)
                               (Ebinop Osub
                                 (Ebinop Osub
                                   (Evalof (Evar _border_size tuchar) tuchar)
                                   (Eval (Vint (Int.repr 1)) tint) tint)
                                 (Evalof (Evar _j tuchar) tuchar) tint) tint)
                             (tptr tuchar)) tuchar)
                         (Evalof
                           (Ederef
                             (Ebinop Oadd
                               (Evalof (Evar _input_buf (tptr tuchar))
                                 (tptr tuchar))
                               (Ebinop Oadd
                                 (Ebinop Omul
                                   (Ebinop Osub
                                     (Evalof (Evar _i tushort) tushort)
                                     (Evalof (Evar _border_size tuchar)
                                       tuchar) tint)
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Ederef
                                           (Evalof
                                             (Evar _input (tptr (Tstruct _image_t noattr)))
                                             (tptr (Tstruct _image_t noattr)))
                                           (Tstruct _image_t noattr))
                                         (Tstruct _image_t noattr)) _w
                                       tushort) tushort) tint)
                                 (Evalof (Evar _j tuchar) tuchar) tint)
                               (tptr tuchar)) tuchar) tuchar) tuchar))))
              (Ssequence
                (Sdo (Ecall
                       (Evalof
                         (Evar _memcpy (Tfunction
                                         ((tptr tvoid) :: (tptr tvoid) ::
                                          tulong :: nil) (tptr tvoid)
                                         cc_default))
                         (Tfunction
                           ((tptr tvoid) :: (tptr tvoid) :: tulong :: nil)
                           (tptr tvoid) cc_default))
                       (Econs
                         (Eaddrof
                           (Ederef
                             (Ebinop Oadd
                               (Evalof (Evar _output_buf (tptr tuchar))
                                 (tptr tuchar))
                               (Ebinop Oadd
                                 (Ebinop Omul
                                   (Evalof (Evar _i tushort) tushort)
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Ederef
                                           (Evalof
                                             (Evar _output (tptr (Tstruct _image_t noattr)))
                                             (tptr (Tstruct _image_t noattr)))
                                           (Tstruct _image_t noattr))
                                         (Tstruct _image_t noattr)) _w
                                       tushort) tushort) tint)
                                 (Evalof (Evar _border_size tuchar) tuchar)
                                 tint) (tptr tuchar)) tuchar) (tptr tuchar))
                         (Econs
                           (Eaddrof
                             (Ederef
                               (Ebinop Oadd
                                 (Evalof (Evar _input_buf (tptr tuchar))
                                   (tptr tuchar))
                                 (Ebinop Omul
                                   (Ebinop Osub
                                     (Evalof (Evar _i tushort) tushort)
                                     (Evalof (Evar _border_size tuchar)
                                       tuchar) tint)
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Ederef
                                           (Evalof
                                             (Evar _input (tptr (Tstruct _image_t noattr)))
                                             (tptr (Tstruct _image_t noattr)))
                                           (Tstruct _image_t noattr))
                                         (Tstruct _image_t noattr)) _w
                                       tushort) tushort) tint) (tptr tuchar))
                               tuchar) (tptr tuchar))
                           (Econs
                             (Ebinop Omul (Esizeof tuchar tulong)
                               (Evalof
                                 (Efield
                                   (Evalof
                                     (Ederef
                                       (Evalof
                                         (Evar _input (tptr (Tstruct _image_t noattr)))
                                         (tptr (Tstruct _image_t noattr)))
                                       (Tstruct _image_t noattr))
                                     (Tstruct _image_t noattr)) _w tushort)
                                 tushort) tulong) Enil))) (tptr tvoid)))
                (Ssequence
                  (Sdo (Eassign (Evar _j__1 tuchar)
                         (Eval (Vint (Int.repr 0)) tint) tuchar))
                  (Sfor
                    Sskip
                    (Ebinop One (Evalof (Evar _j__1 tuchar) tuchar)
                      (Evalof (Evar _border_size tuchar) tuchar) tint)
                    (Sdo (Epostincr Incr (Evar _j__1 tuchar) tuchar))
                    (Sdo (Eassign
                           (Ederef
                             (Ebinop Oadd
                               (Evalof (Evar _output_buf (tptr tuchar))
                                 (tptr tuchar))
                               (Ebinop Oadd
                                 (Ebinop Osub
                                   (Ebinop Oadd
                                     (Ebinop Omul
                                       (Evalof (Evar _i tushort) tushort)
                                       (Evalof
                                         (Efield
                                           (Evalof
                                             (Ederef
                                               (Evalof
                                                 (Evar _output (tptr (Tstruct _image_t noattr)))
                                                 (tptr (Tstruct _image_t noattr)))
                                               (Tstruct _image_t noattr))
                                             (Tstruct _image_t noattr)) _w
                                           tushort) tushort) tint)
                                     (Evalof
                                       (Efield
                                         (Evalof
                                           (Ederef
                                             (Evalof
                                               (Evar _output (tptr (Tstruct _image_t noattr)))
                                               (tptr (Tstruct _image_t noattr)))
                                             (Tstruct _image_t noattr))
                                           (Tstruct _image_t noattr)) _w
                                         tushort) tushort) tint)
                                   (Evalof (Evar _border_size tuchar) tuchar)
                                   tint) (Evalof (Evar _j__1 tuchar) tuchar)
                                 tint) (tptr tuchar)) tuchar)
                           (Evalof
                             (Ederef
                               (Ebinop Oadd
                                 (Evalof (Evar _output_buf (tptr tuchar))
                                   (tptr tuchar))
                                 (Ebinop Osub
                                   (Ebinop Osub
                                     (Ebinop Osub
                                       (Ebinop Oadd
                                         (Ebinop Omul
                                           (Evalof (Evar _i tushort) tushort)
                                           (Evalof
                                             (Efield
                                               (Evalof
                                                 (Ederef
                                                   (Evalof
                                                     (Evar _output (tptr (Tstruct _image_t noattr)))
                                                     (tptr (Tstruct _image_t noattr)))
                                                   (Tstruct _image_t noattr))
                                                 (Tstruct _image_t noattr))
                                               _w tushort) tushort) tint)
                                         (Evalof
                                           (Efield
                                             (Evalof
                                               (Ederef
                                                 (Evalof
                                                   (Evar _output (tptr (Tstruct _image_t noattr)))
                                                   (tptr (Tstruct _image_t noattr)))
                                                 (Tstruct _image_t noattr))
                                               (Tstruct _image_t noattr)) _w
                                             tushort) tushort) tint)
                                       (Evalof (Evar _border_size tuchar)
                                         tuchar) tint)
                                     (Eval (Vint (Int.repr 1)) tint) tint)
                                   (Evalof (Evar _j__1 tuchar) tuchar) tint)
                                 (tptr tuchar)) tuchar) tuchar) tuchar))))))))
        (Ssequence
          (Sdo (Eassign (Evar _i__1 tuchar) (Eval (Vint (Int.repr 0)) tint)
                 tuchar))
          (Sfor
            Sskip
            (Ebinop One (Evalof (Evar _i__1 tuchar) tuchar)
              (Evalof (Evar _border_size tuchar) tuchar) tint)
            (Sdo (Epostincr Incr (Evar _i__1 tuchar) tuchar))
            (Ssequence
              (Sdo (Ecall
                     (Evalof
                       (Evar _memcpy (Tfunction
                                       ((tptr tvoid) :: (tptr tvoid) ::
                                        tulong :: nil) (tptr tvoid)
                                       cc_default))
                       (Tfunction
                         ((tptr tvoid) :: (tptr tvoid) :: tulong :: nil)
                         (tptr tvoid) cc_default))
                     (Econs
                       (Eaddrof
                         (Ederef
                           (Ebinop Oadd
                             (Evalof (Evar _output_buf (tptr tuchar))
                               (tptr tuchar))
                             (Ebinop Osub
                               (Ebinop Omul
                                 (Ebinop Osub
                                   (Evalof (Evar _border_size tuchar) tuchar)
                                   (Eval (Vint (Int.repr 1)) tint) tint)
                                 (Evalof
                                   (Efield
                                     (Evalof
                                       (Ederef
                                         (Evalof
                                           (Evar _output (tptr (Tstruct _image_t noattr)))
                                           (tptr (Tstruct _image_t noattr)))
                                         (Tstruct _image_t noattr))
                                       (Tstruct _image_t noattr)) _w tushort)
                                   tushort) tint)
                               (Ebinop Omul
                                 (Evalof (Evar _i__1 tuchar) tuchar)
                                 (Evalof
                                   (Efield
                                     (Evalof
                                       (Ederef
                                         (Evalof
                                           (Evar _output (tptr (Tstruct _image_t noattr)))
                                           (tptr (Tstruct _image_t noattr)))
                                         (Tstruct _image_t noattr))
                                       (Tstruct _image_t noattr)) _w tushort)
                                   tushort) tint) tint) (tptr tuchar))
                           tuchar) (tptr tuchar))
                       (Econs
                         (Eaddrof
                           (Ederef
                             (Ebinop Oadd
                               (Evalof (Evar _output_buf (tptr tuchar))
                                 (tptr tuchar))
                               (Ebinop Oadd
                                 (Ebinop Omul
                                   (Evalof (Evar _border_size tuchar) tuchar)
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Ederef
                                           (Evalof
                                             (Evar _output (tptr (Tstruct _image_t noattr)))
                                             (tptr (Tstruct _image_t noattr)))
                                           (Tstruct _image_t noattr))
                                         (Tstruct _image_t noattr)) _w
                                       tushort) tushort) tint)
                                 (Ebinop Omul
                                   (Evalof (Evar _i__1 tuchar) tuchar)
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Ederef
                                           (Evalof
                                             (Evar _output (tptr (Tstruct _image_t noattr)))
                                             (tptr (Tstruct _image_t noattr)))
                                           (Tstruct _image_t noattr))
                                         (Tstruct _image_t noattr)) _w
                                       tushort) tushort) tint) tint)
                               (tptr tuchar)) tuchar) (tptr tuchar))
                         (Econs
                           (Ebinop Omul (Esizeof tuchar tulong)
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _output (tptr (Tstruct _image_t noattr)))
                                       (tptr (Tstruct _image_t noattr)))
                                     (Tstruct _image_t noattr))
                                   (Tstruct _image_t noattr)) _w tushort)
                               tushort) tulong) Enil))) (tptr tvoid)))
              (Sdo (Ecall
                     (Evalof
                       (Evar _memcpy (Tfunction
                                       ((tptr tvoid) :: (tptr tvoid) ::
                                        tulong :: nil) (tptr tvoid)
                                       cc_default))
                       (Tfunction
                         ((tptr tvoid) :: (tptr tvoid) :: tulong :: nil)
                         (tptr tvoid) cc_default))
                     (Econs
                       (Eaddrof
                         (Ederef
                           (Ebinop Oadd
                             (Evalof (Evar _output_buf (tptr tuchar))
                               (tptr tuchar))
                             (Ebinop Oadd
                               (Ebinop Omul
                                 (Ebinop Osub
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Ederef
                                           (Evalof
                                             (Evar _output (tptr (Tstruct _image_t noattr)))
                                             (tptr (Tstruct _image_t noattr)))
                                           (Tstruct _image_t noattr))
                                         (Tstruct _image_t noattr)) _h
                                       tushort) tushort)
                                   (Evalof (Evar _border_size tuchar) tuchar)
                                   tint)
                                 (Evalof
                                   (Efield
                                     (Evalof
                                       (Ederef
                                         (Evalof
                                           (Evar _output (tptr (Tstruct _image_t noattr)))
                                           (tptr (Tstruct _image_t noattr)))
                                         (Tstruct _image_t noattr))
                                       (Tstruct _image_t noattr)) _w tushort)
                                   tushort) tint)
                               (Ebinop Omul
                                 (Evalof (Evar _i__1 tuchar) tuchar)
                                 (Evalof
                                   (Efield
                                     (Evalof
                                       (Ederef
                                         (Evalof
                                           (Evar _output (tptr (Tstruct _image_t noattr)))
                                           (tptr (Tstruct _image_t noattr)))
                                         (Tstruct _image_t noattr))
                                       (Tstruct _image_t noattr)) _w tushort)
                                   tushort) tint) tint) (tptr tuchar))
                           tuchar) (tptr tuchar))
                       (Econs
                         (Eaddrof
                           (Ederef
                             (Ebinop Oadd
                               (Evalof (Evar _output_buf (tptr tuchar))
                                 (tptr tuchar))
                               (Ebinop Osub
                                 (Ebinop Omul
                                   (Ebinop Osub
                                     (Ebinop Osub
                                       (Evalof
                                         (Efield
                                           (Evalof
                                             (Ederef
                                               (Evalof
                                                 (Evar _output (tptr (Tstruct _image_t noattr)))
                                                 (tptr (Tstruct _image_t noattr)))
                                               (Tstruct _image_t noattr))
                                             (Tstruct _image_t noattr)) _h
                                           tushort) tushort)
                                       (Evalof (Evar _border_size tuchar)
                                         tuchar) tint)
                                     (Eval (Vint (Int.repr 1)) tint) tint)
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Ederef
                                           (Evalof
                                             (Evar _output (tptr (Tstruct _image_t noattr)))
                                             (tptr (Tstruct _image_t noattr)))
                                           (Tstruct _image_t noattr))
                                         (Tstruct _image_t noattr)) _w
                                       tushort) tushort) tint)
                                 (Ebinop Omul
                                   (Evalof (Evar _i__1 tuchar) tuchar)
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Ederef
                                           (Evalof
                                             (Evar _output (tptr (Tstruct _image_t noattr)))
                                             (tptr (Tstruct _image_t noattr)))
                                           (Tstruct _image_t noattr))
                                         (Tstruct _image_t noattr)) _w
                                       tushort) tushort) tint) tint)
                               (tptr tuchar)) tuchar) (tptr tuchar))
                         (Econs
                           (Ebinop Omul (Esizeof tuchar tulong)
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _output (tptr (Tstruct _image_t noattr)))
                                       (tptr (Tstruct _image_t noattr)))
                                     (Tstruct _image_t noattr))
                                   (Tstruct _image_t noattr)) _w tushort)
                               tushort) tulong) Enil))) (tptr tvoid))))))))))
|}.

Definition f_pyramid_next_level := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_input, (tptr (Tstruct _image_t noattr))) ::
                (_output, (tptr (Tstruct _image_t noattr))) ::
                (_border_size, tuchar) :: nil);
  fn_vars := ((_input_buf, (tptr tuchar)) :: (_output_buf, (tptr tuchar)) ::
              (_row, tushort) :: (_col, tushort) :: (_w, tushort) ::
              (_sum, tint) :: (_i, tushort) :: (_j, tushort) ::
              (_i__1, tushort) :: (_j__1, tushort) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Ecall
         (Evalof
           (Evar _image_create (Tfunction
                                 ((tptr (Tstruct _image_t noattr)) ::
                                  tushort :: tushort :: tint :: nil) tvoid
                                 cc_default))
           (Tfunction
             ((tptr (Tstruct _image_t noattr)) :: tushort :: tushort ::
              tint :: nil) tvoid cc_default))
         (Econs
           (Evalof (Evar _output (tptr (Tstruct _image_t noattr)))
             (tptr (Tstruct _image_t noattr)))
           (Econs
             (Ebinop Odiv
               (Ebinop Osub
                 (Ebinop Oadd
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _input (tptr (Tstruct _image_t noattr)))
                             (tptr (Tstruct _image_t noattr)))
                           (Tstruct _image_t noattr))
                         (Tstruct _image_t noattr)) _w tushort) tushort)
                   (Eval (Vint (Int.repr 1)) tint) tint)
                 (Ebinop Omul (Eval (Vint (Int.repr 2)) tint)
                   (Evalof (Evar _border_size tuchar) tuchar) tint) tint)
               (Eval (Vint (Int.repr 2)) tint) tint)
             (Econs
               (Ebinop Odiv
                 (Ebinop Osub
                   (Ebinop Oadd
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _input (tptr (Tstruct _image_t noattr)))
                               (tptr (Tstruct _image_t noattr)))
                             (Tstruct _image_t noattr))
                           (Tstruct _image_t noattr)) _h tushort) tushort)
                     (Eval (Vint (Int.repr 1)) tint) tint)
                   (Ebinop Omul (Eval (Vint (Int.repr 2)) tint)
                     (Evalof (Evar _border_size tuchar) tuchar) tint) tint)
                 (Eval (Vint (Int.repr 2)) tint) tint)
               (Econs
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _input (tptr (Tstruct _image_t noattr)))
                           (tptr (Tstruct _image_t noattr)))
                         (Tstruct _image_t noattr))
                       (Tstruct _image_t noattr)) _type tint) tint) Enil))))
         tvoid))
  (Ssequence
    (Sdo (Eassign (Evar _input_buf (tptr tuchar))
           (Ecast
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _input (tptr (Tstruct _image_t noattr)))
                       (tptr (Tstruct _image_t noattr)))
                     (Tstruct _image_t noattr)) (Tstruct _image_t noattr))
                 _buf (tptr tvoid)) (tptr tvoid)) (tptr tuchar))
           (tptr tuchar)))
    (Ssequence
      (Sdo (Eassign (Evar _output_buf (tptr tuchar))
             (Ecast
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof
                         (Evar _output (tptr (Tstruct _image_t noattr)))
                         (tptr (Tstruct _image_t noattr)))
                       (Tstruct _image_t noattr)) (Tstruct _image_t noattr))
                   _buf (tptr tvoid)) (tptr tvoid)) (tptr tuchar))
             (tptr tuchar)))
      (Ssequence
        (Sdo (Eassign (Evar _w tushort)
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _input (tptr (Tstruct _image_t noattr)))
                         (tptr (Tstruct _image_t noattr)))
                       (Tstruct _image_t noattr)) (Tstruct _image_t noattr))
                   _w tushort) tushort) tushort))
        (Ssequence
          (Sdo (Eassign (Evar _sum tint) (Eval (Vint (Int.repr 0)) tint)
                 tint))
          (Ssequence
            (Ssequence
              (Sdo (Eassign (Evar _i tushort) (Eval (Vint (Int.repr 0)) tint)
                     tushort))
              (Sfor
                Sskip
                (Ebinop One (Evalof (Evar _i tushort) tushort)
                  (Evalof
                    (Efield
                      (Evalof
                        (Ederef
                          (Evalof
                            (Evar _output (tptr (Tstruct _image_t noattr)))
                            (tptr (Tstruct _image_t noattr)))
                          (Tstruct _image_t noattr))
                        (Tstruct _image_t noattr)) _h tushort) tushort) tint)
                (Sdo (Epostincr Incr (Evar _i tushort) tushort))
                (Ssequence
                  (Sdo (Eassign (Evar _j tushort)
                         (Eval (Vint (Int.repr 0)) tint) tushort))
                  (Sfor
                    Sskip
                    (Ebinop One (Evalof (Evar _j tushort) tushort)
                      (Evalof
                        (Efield
                          (Evalof
                            (Ederef
                              (Evalof
                                (Evar _output (tptr (Tstruct _image_t noattr)))
                                (tptr (Tstruct _image_t noattr)))
                              (Tstruct _image_t noattr))
                            (Tstruct _image_t noattr)) _w tushort) tushort)
                      tint)
                    (Sdo (Epostincr Incr (Evar _j tushort) tushort))
                    (Ssequence
                      (Sdo (Eassign (Evar _row tushort)
                             (Ebinop Oadd
                               (Evalof (Evar _border_size tuchar) tuchar)
                               (Ebinop Omul (Eval (Vint (Int.repr 2)) tint)
                                 (Evalof (Evar _i tushort) tushort) tint)
                               tint) tushort))
                      (Ssequence
                        (Sdo (Eassign (Evar _col tushort)
                               (Ebinop Oadd
                                 (Evalof (Evar _border_size tuchar) tuchar)
                                 (Ebinop Omul (Eval (Vint (Int.repr 2)) tint)
                                   (Evalof (Evar _j tushort) tushort) tint)
                                 tint) tushort))
                        (Ssequence
                          (Sdo (Eassign (Evar _sum tint)
                                 (Ebinop Oshr
                                   (Evalof
                                     (Ederef
                                       (Ebinop Oadd
                                         (Evalof
                                           (Evar _input_buf (tptr tuchar))
                                           (tptr tuchar))
                                         (Ebinop Oadd
                                           (Ebinop Omul
                                             (Evalof (Evar _row tushort)
                                               tushort)
                                             (Evalof (Evar _w tushort)
                                               tushort) tint)
                                           (Evalof (Evar _col tushort)
                                             tushort) tint) (tptr tuchar))
                                       tuchar) tuchar)
                                   (Eval (Vint (Int.repr 1)) tint) tint)
                                 tint))
                          (Ssequence
                            (Sdo (Eassignop Oadd (Evar _sum tint)
                                   (Ebinop Oshr
                                     (Ebinop Oadd
                                       (Evalof
                                         (Ederef
                                           (Ebinop Oadd
                                             (Evalof
                                               (Evar _input_buf (tptr tuchar))
                                               (tptr tuchar))
                                             (Ebinop Oadd
                                               (Ebinop Oadd
                                                 (Ebinop Omul
                                                   (Evalof
                                                     (Evar _row tushort)
                                                     tushort)
                                                   (Evalof (Evar _w tushort)
                                                     tushort) tint)
                                                 (Evalof (Evar _col tushort)
                                                   tushort) tint)
                                               (Eval (Vint (Int.repr 1)) tint)
                                               tint) (tptr tuchar)) tuchar)
                                         tuchar)
                                       (Evalof
                                         (Ederef
                                           (Ebinop Oadd
                                             (Evalof
                                               (Evar _input_buf (tptr tuchar))
                                               (tptr tuchar))
                                             (Ebinop Osub
                                               (Ebinop Oadd
                                                 (Ebinop Omul
                                                   (Evalof
                                                     (Evar _row tushort)
                                                     tushort)
                                                   (Evalof (Evar _w tushort)
                                                     tushort) tint)
                                                 (Evalof (Evar _col tushort)
                                                   tushort) tint)
                                               (Eval (Vint (Int.repr 1)) tint)
                                               tint) (tptr tuchar)) tuchar)
                                         tuchar) tint)
                                     (Eval (Vint (Int.repr 2)) tint) tint)
                                   tint tint))
                            (Sdo (Eassign
                                   (Ederef
                                     (Ebinop Oadd
                                       (Evalof
                                         (Evar _output_buf (tptr tuchar))
                                         (tptr tuchar))
                                       (Ebinop Oadd
                                         (Ebinop Omul
                                           (Evalof (Evar _i tushort) tushort)
                                           (Evalof
                                             (Efield
                                               (Evalof
                                                 (Ederef
                                                   (Evalof
                                                     (Evar _output (tptr (Tstruct _image_t noattr)))
                                                     (tptr (Tstruct _image_t noattr)))
                                                   (Tstruct _image_t noattr))
                                                 (Tstruct _image_t noattr))
                                               _w tushort) tushort) tint)
                                         (Evalof (Evar _j tushort) tushort)
                                         tint) (tptr tuchar)) tuchar)
                                   (Evalof (Evar _sum tint) tint) tuchar))))))))))
            (Ssequence
              (Sdo (Eassign (Evar _w tushort)
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _output (tptr (Tstruct _image_t noattr)))
                               (tptr (Tstruct _image_t noattr)))
                             (Tstruct _image_t noattr))
                           (Tstruct _image_t noattr)) _w tushort) tushort)
                     tushort))
              (Ssequence
                (Sdo (Eassign (Evar _i__1 tushort)
                       (Eval (Vint (Int.repr 0)) tint) tushort))
                (Sfor
                  Sskip
                  (Ebinop One (Evalof (Evar _i__1 tushort) tushort)
                    (Ebinop Osub
                      (Evalof
                        (Efield
                          (Evalof
                            (Ederef
                              (Evalof
                                (Evar _output (tptr (Tstruct _image_t noattr)))
                                (tptr (Tstruct _image_t noattr)))
                              (Tstruct _image_t noattr))
                            (Tstruct _image_t noattr)) _h tushort) tushort)
                      (Evalof (Evar _border_size tuchar) tuchar) tint) tint)
                  (Sdo (Epostincr Incr (Evar _i__1 tushort) tushort))
                  (Ssequence
                    (Sdo (Eassign (Evar _j__1 tushort)
                           (Eval (Vint (Int.repr 0)) tint) tushort))
                    (Sfor
                      Sskip
                      (Ebinop One (Evalof (Evar _j__1 tushort) tushort)
                        (Ebinop Osub
                          (Evalof
                            (Efield
                              (Evalof
                                (Ederef
                                  (Evalof
                                    (Evar _output (tptr (Tstruct _image_t noattr)))
                                    (tptr (Tstruct _image_t noattr)))
                                  (Tstruct _image_t noattr))
                                (Tstruct _image_t noattr)) _w tushort)
                            tushort)
                          (Evalof (Evar _border_size tuchar) tuchar) tint)
                        tint)
                      (Sdo (Epostincr Incr (Evar _j__1 tushort) tushort))
                      (Ssequence
                        (Sdo (Eassign (Evar _row tushort)
                               (Ebinop Oadd
                                 (Evalof (Evar _border_size tuchar) tuchar)
                                 (Evalof (Evar _i__1 tushort) tushort) tint)
                               tushort))
                        (Ssequence
                          (Sdo (Eassign (Evar _col tushort)
                                 (Ebinop Oadd
                                   (Evalof (Evar _border_size tuchar) tuchar)
                                   (Evalof (Evar _j__1 tushort) tushort)
                                   tint) tushort))
                          (Ssequence
                            (Sdo (Eassign (Evar _sum tint)
                                   (Ebinop Oshr
                                     (Evalof
                                       (Ederef
                                         (Ebinop Oadd
                                           (Evalof
                                             (Evar _output_buf (tptr tuchar))
                                             (tptr tuchar))
                                           (Ebinop Oadd
                                             (Ebinop Omul
                                               (Evalof (Evar _row tushort)
                                                 tushort)
                                               (Evalof (Evar _w tushort)
                                                 tushort) tint)
                                             (Evalof (Evar _col tushort)
                                               tushort) tint) (tptr tuchar))
                                         tuchar) tuchar)
                                     (Eval (Vint (Int.repr 1)) tint) tint)
                                   tint))
                            (Ssequence
                              (Sdo (Eassignop Oadd (Evar _sum tint)
                                     (Ebinop Oshr
                                       (Ebinop Oadd
                                         (Evalof
                                           (Ederef
                                             (Ebinop Oadd
                                               (Evalof
                                                 (Evar _output_buf (tptr tuchar))
                                                 (tptr tuchar))
                                               (Ebinop Oadd
                                                 (Ebinop Omul
                                                   (Ebinop Oadd
                                                     (Evalof
                                                       (Evar _row tushort)
                                                       tushort)
                                                     (Eval (Vint (Int.repr 1)) tint)
                                                     tint)
                                                   (Evalof (Evar _w tushort)
                                                     tushort) tint)
                                                 (Evalof (Evar _col tushort)
                                                   tushort) tint)
                                               (tptr tuchar)) tuchar) tuchar)
                                         (Evalof
                                           (Ederef
                                             (Ebinop Oadd
                                               (Evalof
                                                 (Evar _output_buf (tptr tuchar))
                                                 (tptr tuchar))
                                               (Ebinop Oadd
                                                 (Ebinop Omul
                                                   (Ebinop Osub
                                                     (Evalof
                                                       (Evar _row tushort)
                                                       tushort)
                                                     (Eval (Vint (Int.repr 1)) tint)
                                                     tint)
                                                   (Evalof (Evar _w tushort)
                                                     tushort) tint)
                                                 (Evalof (Evar _col tushort)
                                                   tushort) tint)
                                               (tptr tuchar)) tuchar) tuchar)
                                         tint)
                                       (Eval (Vint (Int.repr 2)) tint) tint)
                                     tint tint))
                              (Sdo (Eassign
                                     (Ederef
                                       (Ebinop Oadd
                                         (Evalof
                                           (Evar _output_buf (tptr tuchar))
                                           (tptr tuchar))
                                         (Ebinop Oadd
                                           (Ebinop Omul
                                             (Evalof (Evar _i__1 tushort)
                                               tushort)
                                             (Evalof
                                               (Efield
                                                 (Evalof
                                                   (Ederef
                                                     (Evalof
                                                       (Evar _output (tptr (Tstruct _image_t noattr)))
                                                       (tptr (Tstruct _image_t noattr)))
                                                     (Tstruct _image_t noattr))
                                                   (Tstruct _image_t noattr))
                                                 _w tushort) tushort) tint)
                                           (Evalof (Evar _j__1 tushort)
                                             tushort) tint) (tptr tuchar))
                                       tuchar) (Evalof (Evar _sum tint) tint)
                                     tuchar)))))))))))))))))
|}.

Definition f_pyramid_build := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_input, (tptr (Tstruct _image_t noattr))) ::
                (_output_array, (tptr (Tstruct _image_t noattr))) ::
                (_pyr_level, tuchar) :: (_border_size, tushort) :: nil);
  fn_vars := ((_temp, (Tstruct _image_t noattr)) :: (_i, tuchar) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Ecall
         (Evalof
           (Evar _image_add_border (Tfunction
                                     ((tptr (Tstruct _image_t noattr)) ::
                                      (tptr (Tstruct _image_t noattr)) ::
                                      tuchar :: nil) tvoid cc_default))
           (Tfunction
             ((tptr (Tstruct _image_t noattr)) ::
              (tptr (Tstruct _image_t noattr)) :: tuchar :: nil) tvoid
             cc_default))
         (Econs
           (Evalof (Evar _input (tptr (Tstruct _image_t noattr)))
             (tptr (Tstruct _image_t noattr)))
           (Econs
             (Eaddrof
               (Ederef
                 (Ebinop Oadd
                   (Evalof
                     (Evar _output_array (tptr (Tstruct _image_t noattr)))
                     (tptr (Tstruct _image_t noattr)))
                   (Eval (Vint (Int.repr 0)) tint)
                   (tptr (Tstruct _image_t noattr)))
                 (Tstruct _image_t noattr)) (tptr (Tstruct _image_t noattr)))
             (Econs (Evalof (Evar _border_size tushort) tushort) Enil)))
         tvoid))
  (Ssequence
    (Sdo (Eassign (Evar _i tuchar) (Eval (Vint (Int.repr 1)) tint) tuchar))
    (Sfor
      Sskip
      (Ebinop One (Evalof (Evar _i tuchar) tuchar)
        (Ebinop Oadd (Evalof (Evar _pyr_level tuchar) tuchar)
          (Eval (Vint (Int.repr 1)) tint) tint) tint)
      (Sdo (Epostincr Incr (Evar _i tuchar) tuchar))
      (Ssequence
        (Sdo (Ecall
               (Evalof
                 (Evar _pyramid_next_level (Tfunction
                                             ((tptr (Tstruct _image_t noattr)) ::
                                              (tptr (Tstruct _image_t noattr)) ::
                                              tuchar :: nil) tvoid
                                             cc_default))
                 (Tfunction
                   ((tptr (Tstruct _image_t noattr)) ::
                    (tptr (Tstruct _image_t noattr)) :: tuchar :: nil) tvoid
                   cc_default))
               (Econs
                 (Eaddrof
                   (Ederef
                     (Ebinop Oadd
                       (Evalof
                         (Evar _output_array (tptr (Tstruct _image_t noattr)))
                         (tptr (Tstruct _image_t noattr)))
                       (Ebinop Osub (Evalof (Evar _i tuchar) tuchar)
                         (Eval (Vint (Int.repr 1)) tint) tint)
                       (tptr (Tstruct _image_t noattr)))
                     (Tstruct _image_t noattr))
                   (tptr (Tstruct _image_t noattr)))
                 (Econs
                   (Eaddrof (Evar _temp (Tstruct _image_t noattr))
                     (tptr (Tstruct _image_t noattr)))
                   (Econs (Evalof (Evar _border_size tushort) tushort) Enil)))
               tvoid))
        (Ssequence
          (Sdo (Ecall
                 (Evalof
                   (Evar _image_add_border (Tfunction
                                             ((tptr (Tstruct _image_t noattr)) ::
                                              (tptr (Tstruct _image_t noattr)) ::
                                              tuchar :: nil) tvoid
                                             cc_default))
                   (Tfunction
                     ((tptr (Tstruct _image_t noattr)) ::
                      (tptr (Tstruct _image_t noattr)) :: tuchar :: nil)
                     tvoid cc_default))
                 (Econs
                   (Eaddrof (Evar _temp (Tstruct _image_t noattr))
                     (tptr (Tstruct _image_t noattr)))
                   (Econs
                     (Eaddrof
                       (Ederef
                         (Ebinop Oadd
                           (Evalof
                             (Evar _output_array (tptr (Tstruct _image_t noattr)))
                             (tptr (Tstruct _image_t noattr)))
                           (Evalof (Evar _i tuchar) tuchar)
                           (tptr (Tstruct _image_t noattr)))
                         (Tstruct _image_t noattr))
                       (tptr (Tstruct _image_t noattr)))
                     (Econs (Evalof (Evar _border_size tushort) tushort)
                       Enil))) tvoid))
          (Sdo (Ecall
                 (Evalof
                   (Evar _image_free (Tfunction
                                       ((tptr (Tstruct _image_t noattr)) ::
                                        nil) tvoid cc_default))
                   (Tfunction ((tptr (Tstruct _image_t noattr)) :: nil) tvoid
                     cc_default))
                 (Econs
                   (Eaddrof (Evar _temp (Tstruct _image_t noattr))
                     (tptr (Tstruct _image_t noattr))) Enil) tvoid)))))))
|}.

Definition f_image_subpixel_window := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_input, (tptr (Tstruct _image_t noattr))) ::
                (_output, (tptr (Tstruct _image_t noattr))) ::
                (_center, (tptr (Tstruct _point_t noattr))) ::
                (_subpixel_factor, tuint) :: (_border_size, tuchar) :: nil);
  fn_vars := ((_input_buf, (tptr tuchar)) :: (_output_buf, (tptr tuchar)) ::
              (_half_window, tushort) :: (_subpixel_w, tuint) ::
              (_subpixel_h, tuint) :: (_i, tushort) :: (_j, tushort) ::
              (_x, tuint) :: (_y, tuint) :: (_orig_x, tushort) ::
              (_orig_y, tushort) :: (_tl_x, tuint) :: (_tl_y, tuint) ::
              (_alpha_x, tuint) :: (_alpha_y, tuint) :: (_blend, tuint) ::
              nil);
  fn_body :=
(Ssequence
  (Sdo (Eassign (Evar _input_buf (tptr tuchar))
         (Ecast
           (Evalof
             (Efield
               (Evalof
                 (Ederef
                   (Evalof (Evar _input (tptr (Tstruct _image_t noattr)))
                     (tptr (Tstruct _image_t noattr)))
                   (Tstruct _image_t noattr)) (Tstruct _image_t noattr)) _buf
               (tptr tvoid)) (tptr tvoid)) (tptr tuchar)) (tptr tuchar)))
  (Ssequence
    (Sdo (Eassign (Evar _output_buf (tptr tuchar))
           (Ecast
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _output (tptr (Tstruct _image_t noattr)))
                       (tptr (Tstruct _image_t noattr)))
                     (Tstruct _image_t noattr)) (Tstruct _image_t noattr))
                 _buf (tptr tvoid)) (tptr tvoid)) (tptr tuchar))
           (tptr tuchar)))
    (Ssequence
      (Sdo (Eassign (Evar _half_window tushort)
             (Ebinop Odiv
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof
                         (Evar _output (tptr (Tstruct _image_t noattr)))
                         (tptr (Tstruct _image_t noattr)))
                       (Tstruct _image_t noattr)) (Tstruct _image_t noattr))
                   _w tushort) tushort) (Eval (Vint (Int.repr 2)) tint) tint)
             tushort))
      (Ssequence
        (Sdo (Eassign (Evar _subpixel_w tuint)
               (Ebinop Omul
                 (Ebinop Osub
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _input (tptr (Tstruct _image_t noattr)))
                             (tptr (Tstruct _image_t noattr)))
                           (Tstruct _image_t noattr))
                         (Tstruct _image_t noattr)) _w tushort) tushort)
                   (Eval (Vint (Int.repr 2)) tint) tint)
                 (Evalof (Evar _subpixel_factor tuint) tuint) tuint) tuint))
        (Ssequence
          (Sdo (Eassign (Evar _subpixel_h tuint)
                 (Ebinop Omul
                   (Ebinop Osub
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _input (tptr (Tstruct _image_t noattr)))
                               (tptr (Tstruct _image_t noattr)))
                             (Tstruct _image_t noattr))
                           (Tstruct _image_t noattr)) _h tushort) tushort)
                     (Eval (Vint (Int.repr 2)) tint) tint)
                   (Evalof (Evar _subpixel_factor tuint) tuint) tuint) tuint))
          (Ssequence
            (Sdo (Eassign (Evar _i tushort) (Eval (Vint (Int.repr 0)) tint)
                   tushort))
            (Sfor
              Sskip
              (Ebinop Olt (Evalof (Evar _i tushort) tushort)
                (Evalof
                  (Efield
                    (Evalof
                      (Ederef
                        (Evalof
                          (Evar _output (tptr (Tstruct _image_t noattr)))
                          (tptr (Tstruct _image_t noattr)))
                        (Tstruct _image_t noattr)) (Tstruct _image_t noattr))
                    _w tushort) tushort) tint)
              (Sdo (Epostincr Incr (Evar _i tushort) tushort))
              (Ssequence
                (Sdo (Eassign (Evar _j tushort)
                       (Eval (Vint (Int.repr 0)) tint) tushort))
                (Sfor
                  Sskip
                  (Ebinop Olt (Evalof (Evar _j tushort) tushort)
                    (Evalof
                      (Efield
                        (Evalof
                          (Ederef
                            (Evalof
                              (Evar _output (tptr (Tstruct _image_t noattr)))
                              (tptr (Tstruct _image_t noattr)))
                            (Tstruct _image_t noattr))
                          (Tstruct _image_t noattr)) _h tushort) tushort)
                    tint)
                  (Sdo (Epostincr Incr (Evar _j tushort) tushort))
                  (Ssequence
                    (Sdo (Eassign (Evar _x tuint)
                           (Ebinop Oadd
                             (Ebinop Oadd
                               (Evalof
                                 (Efield
                                   (Evalof
                                     (Ederef
                                       (Evalof
                                         (Evar _center (tptr (Tstruct _point_t noattr)))
                                         (tptr (Tstruct _point_t noattr)))
                                       (Tstruct _point_t noattr))
                                     (Tstruct _point_t noattr)) _x tuint)
                                 tuint)
                               (Ebinop Omul
                                 (Evalof (Evar _border_size tuchar) tuchar)
                                 (Evalof (Evar _subpixel_factor tuint) tuint)
                                 tuint) tuint)
                             (Ebinop Omul
                               (Ebinop Osub
                                 (Evalof (Evar _i tushort) tushort)
                                 (Evalof (Evar _half_window tushort) tushort)
                                 tint)
                               (Evalof (Evar _subpixel_factor tuint) tuint)
                               tuint) tuint) tuint))
                    (Ssequence
                      (Sdo (Eassign (Evar _y tuint)
                             (Ebinop Oadd
                               (Ebinop Oadd
                                 (Evalof
                                   (Efield
                                     (Evalof
                                       (Ederef
                                         (Evalof
                                           (Evar _center (tptr (Tstruct _point_t noattr)))
                                           (tptr (Tstruct _point_t noattr)))
                                         (Tstruct _point_t noattr))
                                       (Tstruct _point_t noattr)) _y tuint)
                                   tuint)
                                 (Ebinop Omul
                                   (Evalof (Evar _border_size tuchar) tuchar)
                                   (Evalof (Evar _subpixel_factor tuint)
                                     tuint) tuint) tuint)
                               (Ebinop Omul
                                 (Ebinop Osub
                                   (Evalof (Evar _j tushort) tushort)
                                   (Evalof (Evar _half_window tushort)
                                     tushort) tint)
                                 (Evalof (Evar _subpixel_factor tuint) tuint)
                                 tuint) tuint) tuint))
                      (Ssequence
                        (Sifthenelse (Ebinop Ogt
                                       (Evalof (Evar _x tuint) tuint)
                                       (Evalof (Evar _subpixel_w tuint)
                                         tuint) tint)
                          (Sdo (Eassign (Evar _x tuint)
                                 (Evalof (Evar _subpixel_w tuint) tuint)
                                 tuint))
                          Sskip)
                        (Ssequence
                          (Sifthenelse (Ebinop Ogt
                                         (Evalof (Evar _y tuint) tuint)
                                         (Evalof (Evar _subpixel_h tuint)
                                           tuint) tint)
                            (Sdo (Eassign (Evar _y tuint)
                                   (Evalof (Evar _subpixel_h tuint) tuint)
                                   tuint))
                            Sskip)
                          (Ssequence
                            (Sdo (Eassign (Evar _orig_x tushort)
                                   (Ebinop Odiv
                                     (Evalof (Evar _x tuint) tuint)
                                     (Evalof (Evar _subpixel_factor tuint)
                                       tuint) tuint) tushort))
                            (Ssequence
                              (Sdo (Eassign (Evar _orig_y tushort)
                                     (Ebinop Odiv
                                       (Evalof (Evar _y tuint) tuint)
                                       (Evalof (Evar _subpixel_factor tuint)
                                         tuint) tuint) tushort))
                              (Ssequence
                                (Sdo (Eassign (Evar _tl_x tuint)
                                       (Ebinop Omul
                                         (Evalof (Evar _orig_x tushort)
                                           tushort)
                                         (Evalof
                                           (Evar _subpixel_factor tuint)
                                           tuint) tuint) tuint))
                                (Ssequence
                                  (Sdo (Eassign (Evar _tl_y tuint)
                                         (Ebinop Omul
                                           (Evalof (Evar _orig_y tushort)
                                             tushort)
                                           (Evalof
                                             (Evar _subpixel_factor tuint)
                                             tuint) tuint) tuint))
                                  (Sifthenelse (Eseqand
                                                 (Ebinop Oeq
                                                   (Evalof (Evar _tl_x tuint)
                                                     tuint)
                                                   (Evalof (Evar _x tuint)
                                                     tuint) tint)
                                                 (Ebinop Oeq
                                                   (Evalof (Evar _tl_y tuint)
                                                     tuint)
                                                   (Evalof (Evar _y tuint)
                                                     tuint) tint) tint)
                                    (Sdo (Eassign
                                           (Ederef
                                             (Ebinop Oadd
                                               (Evalof
                                                 (Evar _output_buf (tptr tuchar))
                                                 (tptr tuchar))
                                               (Ebinop Oadd
                                                 (Ebinop Omul
                                                   (Evalof
                                                     (Efield
                                                       (Evalof
                                                         (Ederef
                                                           (Evalof
                                                             (Evar _output (tptr (Tstruct _image_t noattr)))
                                                             (tptr (Tstruct _image_t noattr)))
                                                           (Tstruct _image_t noattr))
                                                         (Tstruct _image_t noattr))
                                                       _w tushort) tushort)
                                                   (Evalof (Evar _j tushort)
                                                     tushort) tint)
                                                 (Evalof (Evar _i tushort)
                                                   tushort) tint)
                                               (tptr tuchar)) tuchar)
                                           (Evalof
                                             (Ederef
                                               (Ebinop Oadd
                                                 (Evalof
                                                   (Evar _input_buf (tptr tuchar))
                                                   (tptr tuchar))
                                                 (Ebinop Oadd
                                                   (Ebinop Omul
                                                     (Evalof
                                                       (Efield
                                                         (Evalof
                                                           (Ederef
                                                             (Evalof
                                                               (Evar _input (tptr (Tstruct _image_t noattr)))
                                                               (tptr (Tstruct _image_t noattr)))
                                                             (Tstruct _image_t noattr))
                                                           (Tstruct _image_t noattr))
                                                         _w tushort) tushort)
                                                     (Evalof
                                                       (Evar _orig_y tushort)
                                                       tushort) tint)
                                                   (Evalof
                                                     (Evar _orig_x tushort)
                                                     tushort) tint)
                                                 (tptr tuchar)) tuchar)
                                             tuchar) tuchar))
                                    (Ssequence
                                      (Sdo (Eassign (Evar _alpha_x tuint)
                                             (Ebinop Osub
                                               (Evalof (Evar _x tuint) tuint)
                                               (Evalof (Evar _tl_x tuint)
                                                 tuint) tuint) tuint))
                                      (Ssequence
                                        (Sdo (Eassign (Evar _alpha_y tuint)
                                               (Ebinop Osub
                                                 (Evalof (Evar _y tuint)
                                                   tuint)
                                                 (Evalof (Evar _tl_y tuint)
                                                   tuint) tuint) tuint))
                                        (Ssequence
                                          (Sdo (Eassign (Evar _blend tuint)
                                                 (Ebinop Omul
                                                   (Ebinop Omul
                                                     (Ebinop Osub
                                                       (Evalof
                                                         (Evar _subpixel_factor tuint)
                                                         tuint)
                                                       (Evalof
                                                         (Evar _alpha_x tuint)
                                                         tuint) tuint)
                                                     (Ebinop Osub
                                                       (Evalof
                                                         (Evar _subpixel_factor tuint)
                                                         tuint)
                                                       (Evalof
                                                         (Evar _alpha_y tuint)
                                                         tuint) tuint) tuint)
                                                   (Evalof
                                                     (Ederef
                                                       (Ebinop Oadd
                                                         (Evalof
                                                           (Evar _input_buf (tptr tuchar))
                                                           (tptr tuchar))
                                                         (Ebinop Oadd
                                                           (Ebinop Omul
                                                             (Evalof
                                                               (Efield
                                                                 (Evalof
                                                                   (Ederef
                                                                    (Evalof
                                                                    (Evar _input (tptr (Tstruct _image_t noattr)))
                                                                    (tptr (Tstruct _image_t noattr)))
                                                                    (Tstruct _image_t noattr))
                                                                   (Tstruct _image_t noattr))
                                                                 _w tushort)
                                                               tushort)
                                                             (Evalof
                                                               (Evar _orig_y tushort)
                                                               tushort) tint)
                                                           (Evalof
                                                             (Evar _orig_x tushort)
                                                             tushort) tint)
                                                         (tptr tuchar))
                                                       tuchar) tuchar) tuint)
                                                 tuint))
                                          (Ssequence
                                            (Sdo (Eassignop Oadd
                                                   (Evar _blend tuint)
                                                   (Ebinop Omul
                                                     (Ebinop Omul
                                                       (Evalof
                                                         (Evar _alpha_x tuint)
                                                         tuint)
                                                       (Ebinop Osub
                                                         (Evalof
                                                           (Evar _subpixel_factor tuint)
                                                           tuint)
                                                         (Evalof
                                                           (Evar _alpha_y tuint)
                                                           tuint) tuint)
                                                       tuint)
                                                     (Evalof
                                                       (Ederef
                                                         (Ebinop Oadd
                                                           (Evalof
                                                             (Evar _input_buf (tptr tuchar))
                                                             (tptr tuchar))
                                                           (Ebinop Oadd
                                                             (Ebinop Omul
                                                               (Evalof
                                                                 (Efield
                                                                   (Evalof
                                                                    (Ederef
                                                                    (Evalof
                                                                    (Evar _input (tptr (Tstruct _image_t noattr)))
                                                                    (tptr (Tstruct _image_t noattr)))
                                                                    (Tstruct _image_t noattr))
                                                                    (Tstruct _image_t noattr))
                                                                   _w
                                                                   tushort)
                                                                 tushort)
                                                               (Evalof
                                                                 (Evar _orig_y tushort)
                                                                 tushort)
                                                               tint)
                                                             (Ebinop Oadd
                                                               (Evalof
                                                                 (Evar _orig_x tushort)
                                                                 tushort)
                                                               (Eval (Vint (Int.repr 1)) tint)
                                                               tint) tint)
                                                           (tptr tuchar))
                                                         tuchar) tuchar)
                                                     tuint) tuint tuint))
                                            (Ssequence
                                              (Sdo (Eassignop Oadd
                                                     (Evar _blend tuint)
                                                     (Ebinop Omul
                                                       (Ebinop Omul
                                                         (Ebinop Osub
                                                           (Evalof
                                                             (Evar _subpixel_factor tuint)
                                                             tuint)
                                                           (Evalof
                                                             (Evar _alpha_x tuint)
                                                             tuint) tuint)
                                                         (Evalof
                                                           (Evar _alpha_y tuint)
                                                           tuint) tuint)
                                                       (Evalof
                                                         (Ederef
                                                           (Ebinop Oadd
                                                             (Evalof
                                                               (Evar _input_buf (tptr tuchar))
                                                               (tptr tuchar))
                                                             (Ebinop Oadd
                                                               (Ebinop Omul
                                                                 (Evalof
                                                                   (Efield
                                                                    (Evalof
                                                                    (Ederef
                                                                    (Evalof
                                                                    (Evar _input (tptr (Tstruct _image_t noattr)))
                                                                    (tptr (Tstruct _image_t noattr)))
                                                                    (Tstruct _image_t noattr))
                                                                    (Tstruct _image_t noattr))
                                                                    _w
                                                                    tushort)
                                                                   tushort)
                                                                 (Ebinop Oadd
                                                                   (Evalof
                                                                    (Evar _orig_y tushort)
                                                                    tushort)
                                                                   (Eval (Vint (Int.repr 1)) tint)
                                                                   tint)
                                                                 tint)
                                                               (Evalof
                                                                 (Evar _orig_x tushort)
                                                                 tushort)
                                                               tint)
                                                             (tptr tuchar))
                                                           tuchar) tuchar)
                                                       tuint) tuint tuint))
                                              (Ssequence
                                                (Sdo (Eassignop Oadd
                                                       (Evar _blend tuint)
                                                       (Ebinop Omul
                                                         (Ebinop Omul
                                                           (Evalof
                                                             (Evar _alpha_x tuint)
                                                             tuint)
                                                           (Evalof
                                                             (Evar _alpha_y tuint)
                                                             tuint) tuint)
                                                         (Evalof
                                                           (Ederef
                                                             (Ebinop Oadd
                                                               (Evalof
                                                                 (Evar _input_buf (tptr tuchar))
                                                                 (tptr tuchar))
                                                               (Ebinop Oadd
                                                                 (Ebinop Omul
                                                                   (Evalof
                                                                    (Efield
                                                                    (Evalof
                                                                    (Ederef
                                                                    (Evalof
                                                                    (Evar _input (tptr (Tstruct _image_t noattr)))
                                                                    (tptr (Tstruct _image_t noattr)))
                                                                    (Tstruct _image_t noattr))
                                                                    (Tstruct _image_t noattr))
                                                                    _w
                                                                    tushort)
                                                                    tushort)
                                                                   (Ebinop Oadd
                                                                    (Evalof
                                                                    (Evar _orig_y tushort)
                                                                    tushort)
                                                                    (Eval (Vint (Int.repr 1)) tint)
                                                                    tint)
                                                                   tint)
                                                                 (Ebinop Oadd
                                                                   (Evalof
                                                                    (Evar _orig_x tushort)
                                                                    tushort)
                                                                   (Eval (Vint (Int.repr 1)) tint)
                                                                   tint)
                                                                 tint)
                                                               (tptr tuchar))
                                                             tuchar) tuchar)
                                                         tuint) tuint tuint))
                                                (Sdo (Eassign
                                                       (Ederef
                                                         (Ebinop Oadd
                                                           (Evalof
                                                             (Evar _output_buf (tptr tuchar))
                                                             (tptr tuchar))
                                                           (Ebinop Oadd
                                                             (Ebinop Omul
                                                               (Evalof
                                                                 (Efield
                                                                   (Evalof
                                                                    (Ederef
                                                                    (Evalof
                                                                    (Evar _output (tptr (Tstruct _image_t noattr)))
                                                                    (tptr (Tstruct _image_t noattr)))
                                                                    (Tstruct _image_t noattr))
                                                                    (Tstruct _image_t noattr))
                                                                   _w
                                                                   tushort)
                                                                 tushort)
                                                               (Evalof
                                                                 (Evar _j tushort)
                                                                 tushort)
                                                               tint)
                                                             (Evalof
                                                               (Evar _i tushort)
                                                               tushort) tint)
                                                           (tptr tuchar))
                                                         tuchar)
                                                       (Ebinop Odiv
                                                         (Evalof
                                                           (Evar _blend tuint)
                                                           tuint)
                                                         (Ebinop Omul
                                                           (Evalof
                                                             (Evar _subpixel_factor tuint)
                                                             tuint)
                                                           (Evalof
                                                             (Evar _subpixel_factor tuint)
                                                             tuint) tuint)
                                                         tuint) tuchar))))))))))))))))))))))))))
|}.

Definition f_image_gradients := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_input, (tptr (Tstruct _image_t noattr))) ::
                (_dx, (tptr (Tstruct _image_t noattr))) ::
                (_dy, (tptr (Tstruct _image_t noattr))) :: nil);
  fn_vars := ((_input_buf, (tptr tuchar)) :: (_dx_buf, (tptr tshort)) ::
              (_dy_buf, (tptr tshort)) :: (_x, tushort) :: (_y, tushort) ::
              nil);
  fn_body :=
(Ssequence
  (Sdo (Eassign (Evar _input_buf (tptr tuchar))
         (Ecast
           (Evalof
             (Efield
               (Evalof
                 (Ederef
                   (Evalof (Evar _input (tptr (Tstruct _image_t noattr)))
                     (tptr (Tstruct _image_t noattr)))
                   (Tstruct _image_t noattr)) (Tstruct _image_t noattr)) _buf
               (tptr tvoid)) (tptr tvoid)) (tptr tuchar)) (tptr tuchar)))
  (Ssequence
    (Sdo (Eassign (Evar _dx_buf (tptr tshort))
           (Ecast
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _dx (tptr (Tstruct _image_t noattr)))
                       (tptr (Tstruct _image_t noattr)))
                     (Tstruct _image_t noattr)) (Tstruct _image_t noattr))
                 _buf (tptr tvoid)) (tptr tvoid)) (tptr tshort))
           (tptr tshort)))
    (Ssequence
      (Sdo (Eassign (Evar _dy_buf (tptr tshort))
             (Ecast
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _dy (tptr (Tstruct _image_t noattr)))
                         (tptr (Tstruct _image_t noattr)))
                       (Tstruct _image_t noattr)) (Tstruct _image_t noattr))
                   _buf (tptr tvoid)) (tptr tvoid)) (tptr tshort))
             (tptr tshort)))
      (Ssequence
        (Sdo (Eassign (Evar _x tushort) (Eval (Vint (Int.repr 1)) tint)
               tushort))
        (Sfor
          Sskip
          (Ebinop Olt (Evalof (Evar _x tushort) tushort)
            (Ebinop Osub
              (Evalof
                (Efield
                  (Evalof
                    (Ederef
                      (Evalof (Evar _input (tptr (Tstruct _image_t noattr)))
                        (tptr (Tstruct _image_t noattr)))
                      (Tstruct _image_t noattr)) (Tstruct _image_t noattr))
                  _w tushort) tushort) (Eval (Vint (Int.repr 1)) tint) tint)
            tint)
          (Sdo (Epostincr Incr (Evar _x tushort) tushort))
          (Ssequence
            (Sdo (Eassign (Evar _y tushort) (Eval (Vint (Int.repr 1)) tint)
                   tushort))
            (Sfor
              Sskip
              (Ebinop Olt (Evalof (Evar _y tushort) tushort)
                (Ebinop Osub
                  (Evalof
                    (Efield
                      (Evalof
                        (Ederef
                          (Evalof
                            (Evar _input (tptr (Tstruct _image_t noattr)))
                            (tptr (Tstruct _image_t noattr)))
                          (Tstruct _image_t noattr))
                        (Tstruct _image_t noattr)) _h tushort) tushort)
                  (Eval (Vint (Int.repr 1)) tint) tint) tint)
              (Sdo (Epostincr Incr (Evar _y tushort) tushort))
              (Ssequence
                (Sdo (Eassign
                       (Ederef
                         (Ebinop Oadd
                           (Evalof (Evar _dx_buf (tptr tshort))
                             (tptr tshort))
                           (Ebinop Oadd
                             (Ebinop Omul
                               (Ebinop Osub
                                 (Evalof (Evar _y tushort) tushort)
                                 (Eval (Vint (Int.repr 1)) tint) tint)
                               (Evalof
                                 (Efield
                                   (Evalof
                                     (Ederef
                                       (Evalof
                                         (Evar _dx (tptr (Tstruct _image_t noattr)))
                                         (tptr (Tstruct _image_t noattr)))
                                       (Tstruct _image_t noattr))
                                     (Tstruct _image_t noattr)) _w tushort)
                                 tushort) tint)
                             (Ebinop Osub (Evalof (Evar _x tushort) tushort)
                               (Eval (Vint (Int.repr 1)) tint) tint) tint)
                           (tptr tshort)) tshort)
                       (Ebinop Osub
                         (Ecast
                           (Evalof
                             (Ederef
                               (Ebinop Oadd
                                 (Evalof (Evar _input_buf (tptr tuchar))
                                   (tptr tuchar))
                                 (Ebinop Oadd
                                   (Ebinop Oadd
                                     (Ebinop Omul
                                       (Evalof (Evar _y tushort) tushort)
                                       (Evalof
                                         (Efield
                                           (Evalof
                                             (Ederef
                                               (Evalof
                                                 (Evar _input (tptr (Tstruct _image_t noattr)))
                                                 (tptr (Tstruct _image_t noattr)))
                                               (Tstruct _image_t noattr))
                                             (Tstruct _image_t noattr)) _w
                                           tushort) tushort) tint)
                                     (Evalof (Evar _x tushort) tushort) tint)
                                   (Eval (Vint (Int.repr 1)) tint) tint)
                                 (tptr tuchar)) tuchar) tuchar) tshort)
                         (Ecast
                           (Evalof
                             (Ederef
                               (Ebinop Oadd
                                 (Evalof (Evar _input_buf (tptr tuchar))
                                   (tptr tuchar))
                                 (Ebinop Osub
                                   (Ebinop Oadd
                                     (Ebinop Omul
                                       (Evalof (Evar _y tushort) tushort)
                                       (Evalof
                                         (Efield
                                           (Evalof
                                             (Ederef
                                               (Evalof
                                                 (Evar _input (tptr (Tstruct _image_t noattr)))
                                                 (tptr (Tstruct _image_t noattr)))
                                               (Tstruct _image_t noattr))
                                             (Tstruct _image_t noattr)) _w
                                           tushort) tushort) tint)
                                     (Evalof (Evar _x tushort) tushort) tint)
                                   (Eval (Vint (Int.repr 1)) tint) tint)
                                 (tptr tuchar)) tuchar) tuchar) tshort) tint)
                       tshort))
                (Sdo (Eassign
                       (Ederef
                         (Ebinop Oadd
                           (Evalof (Evar _dy_buf (tptr tshort))
                             (tptr tshort))
                           (Ebinop Oadd
                             (Ebinop Omul
                               (Ebinop Osub
                                 (Evalof (Evar _y tushort) tushort)
                                 (Eval (Vint (Int.repr 1)) tint) tint)
                               (Evalof
                                 (Efield
                                   (Evalof
                                     (Ederef
                                       (Evalof
                                         (Evar _dy (tptr (Tstruct _image_t noattr)))
                                         (tptr (Tstruct _image_t noattr)))
                                       (Tstruct _image_t noattr))
                                     (Tstruct _image_t noattr)) _w tushort)
                                 tushort) tint)
                             (Ebinop Osub (Evalof (Evar _x tushort) tushort)
                               (Eval (Vint (Int.repr 1)) tint) tint) tint)
                           (tptr tshort)) tshort)
                       (Ebinop Osub
                         (Ecast
                           (Evalof
                             (Ederef
                               (Ebinop Oadd
                                 (Evalof (Evar _input_buf (tptr tuchar))
                                   (tptr tuchar))
                                 (Ebinop Oadd
                                   (Ebinop Omul
                                     (Ebinop Oadd
                                       (Evalof (Evar _y tushort) tushort)
                                       (Eval (Vint (Int.repr 1)) tint) tint)
                                     (Evalof
                                       (Efield
                                         (Evalof
                                           (Ederef
                                             (Evalof
                                               (Evar _input (tptr (Tstruct _image_t noattr)))
                                               (tptr (Tstruct _image_t noattr)))
                                             (Tstruct _image_t noattr))
                                           (Tstruct _image_t noattr)) _w
                                         tushort) tushort) tint)
                                   (Evalof (Evar _x tushort) tushort) tint)
                                 (tptr tuchar)) tuchar) tuchar) tshort)
                         (Ecast
                           (Evalof
                             (Ederef
                               (Ebinop Oadd
                                 (Evalof (Evar _input_buf (tptr tuchar))
                                   (tptr tuchar))
                                 (Ebinop Oadd
                                   (Ebinop Omul
                                     (Ebinop Osub
                                       (Evalof (Evar _y tushort) tushort)
                                       (Eval (Vint (Int.repr 1)) tint) tint)
                                     (Evalof
                                       (Efield
                                         (Evalof
                                           (Ederef
                                             (Evalof
                                               (Evar _input (tptr (Tstruct _image_t noattr)))
                                               (tptr (Tstruct _image_t noattr)))
                                             (Tstruct _image_t noattr))
                                           (Tstruct _image_t noattr)) _w
                                         tushort) tushort) tint)
                                   (Evalof (Evar _x tushort) tushort) tint)
                                 (tptr tuchar)) tuchar) tuchar) tshort) tint)
                       tshort))))))))))
|}.

Definition f_image_calculate_g := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_dx, (tptr (Tstruct _image_t noattr))) ::
                (_dy, (tptr (Tstruct _image_t noattr))) ::
                (_g, (tptr tint)) :: nil);
  fn_vars := ((_sum_dxx, tint) :: (_sum_dxy, tint) :: (_sum_dyy, tint) ::
              (_dx_buf, (tptr tshort)) :: (_dy_buf, (tptr tshort)) ::
              (_x, tushort) :: (_y, tushort) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Eassign (Evar _sum_dxx tint) (Eval (Vint (Int.repr 0)) tint) tint))
  (Ssequence
    (Sdo (Eassign (Evar _sum_dxy tint) (Eval (Vint (Int.repr 0)) tint) tint))
    (Ssequence
      (Sdo (Eassign (Evar _sum_dyy tint) (Eval (Vint (Int.repr 0)) tint)
             tint))
      (Ssequence
        (Sdo (Eassign (Evar _dx_buf (tptr tshort))
               (Ecast
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof (Evar _dx (tptr (Tstruct _image_t noattr)))
                           (tptr (Tstruct _image_t noattr)))
                         (Tstruct _image_t noattr))
                       (Tstruct _image_t noattr)) _buf (tptr tvoid))
                   (tptr tvoid)) (tptr tshort)) (tptr tshort)))
        (Ssequence
          (Sdo (Eassign (Evar _dy_buf (tptr tshort))
                 (Ecast
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _dy (tptr (Tstruct _image_t noattr)))
                             (tptr (Tstruct _image_t noattr)))
                           (Tstruct _image_t noattr))
                         (Tstruct _image_t noattr)) _buf (tptr tvoid))
                     (tptr tvoid)) (tptr tshort)) (tptr tshort)))
          (Ssequence
            (Ssequence
              (Sdo (Eassign (Evar _x tushort) (Eval (Vint (Int.repr 0)) tint)
                     tushort))
              (Sfor
                Sskip
                (Ebinop Olt (Evalof (Evar _x tushort) tushort)
                  (Evalof
                    (Efield
                      (Evalof
                        (Ederef
                          (Evalof (Evar _dx (tptr (Tstruct _image_t noattr)))
                            (tptr (Tstruct _image_t noattr)))
                          (Tstruct _image_t noattr))
                        (Tstruct _image_t noattr)) _w tushort) tushort) tint)
                (Sdo (Epostincr Incr (Evar _x tushort) tushort))
                (Ssequence
                  (Sdo (Eassign (Evar _y tushort)
                         (Eval (Vint (Int.repr 0)) tint) tushort))
                  (Sfor
                    Sskip
                    (Ebinop Olt (Evalof (Evar _y tushort) tushort)
                      (Evalof
                        (Efield
                          (Evalof
                            (Ederef
                              (Evalof
                                (Evar _dy (tptr (Tstruct _image_t noattr)))
                                (tptr (Tstruct _image_t noattr)))
                              (Tstruct _image_t noattr))
                            (Tstruct _image_t noattr)) _h tushort) tushort)
                      tint)
                    (Sdo (Epostincr Incr (Evar _y tushort) tushort))
                    (Ssequence
                      (Sdo (Eassignop Oadd (Evar _sum_dxx tint)
                             (Ebinop Omul
                               (Ecast
                                 (Evalof
                                   (Ederef
                                     (Ebinop Oadd
                                       (Evalof (Evar _dx_buf (tptr tshort))
                                         (tptr tshort))
                                       (Ebinop Oadd
                                         (Ebinop Omul
                                           (Evalof (Evar _y tushort) tushort)
                                           (Evalof
                                             (Efield
                                               (Evalof
                                                 (Ederef
                                                   (Evalof
                                                     (Evar _dx (tptr (Tstruct _image_t noattr)))
                                                     (tptr (Tstruct _image_t noattr)))
                                                   (Tstruct _image_t noattr))
                                                 (Tstruct _image_t noattr))
                                               _w tushort) tushort) tint)
                                         (Evalof (Evar _x tushort) tushort)
                                         tint) (tptr tshort)) tshort) tshort)
                                 tint)
                               (Evalof
                                 (Ederef
                                   (Ebinop Oadd
                                     (Evalof (Evar _dx_buf (tptr tshort))
                                       (tptr tshort))
                                     (Ebinop Oadd
                                       (Ebinop Omul
                                         (Evalof (Evar _y tushort) tushort)
                                         (Evalof
                                           (Efield
                                             (Evalof
                                               (Ederef
                                                 (Evalof
                                                   (Evar _dx (tptr (Tstruct _image_t noattr)))
                                                   (tptr (Tstruct _image_t noattr)))
                                                 (Tstruct _image_t noattr))
                                               (Tstruct _image_t noattr)) _w
                                             tushort) tushort) tint)
                                       (Evalof (Evar _x tushort) tushort)
                                       tint) (tptr tshort)) tshort) tshort)
                               tint) tint tint))
                      (Ssequence
                        (Sdo (Eassignop Oadd (Evar _sum_dxy tint)
                               (Ebinop Omul
                                 (Ecast
                                   (Evalof
                                     (Ederef
                                       (Ebinop Oadd
                                         (Evalof (Evar _dx_buf (tptr tshort))
                                           (tptr tshort))
                                         (Ebinop Oadd
                                           (Ebinop Omul
                                             (Evalof (Evar _y tushort)
                                               tushort)
                                             (Evalof
                                               (Efield
                                                 (Evalof
                                                   (Ederef
                                                     (Evalof
                                                       (Evar _dx (tptr (Tstruct _image_t noattr)))
                                                       (tptr (Tstruct _image_t noattr)))
                                                     (Tstruct _image_t noattr))
                                                   (Tstruct _image_t noattr))
                                                 _w tushort) tushort) tint)
                                           (Evalof (Evar _x tushort) tushort)
                                           tint) (tptr tshort)) tshort)
                                     tshort) tint)
                                 (Evalof
                                   (Ederef
                                     (Ebinop Oadd
                                       (Evalof (Evar _dy_buf (tptr tshort))
                                         (tptr tshort))
                                       (Ebinop Oadd
                                         (Ebinop Omul
                                           (Evalof (Evar _y tushort) tushort)
                                           (Evalof
                                             (Efield
                                               (Evalof
                                                 (Ederef
                                                   (Evalof
                                                     (Evar _dy (tptr (Tstruct _image_t noattr)))
                                                     (tptr (Tstruct _image_t noattr)))
                                                   (Tstruct _image_t noattr))
                                                 (Tstruct _image_t noattr))
                                               _w tushort) tushort) tint)
                                         (Evalof (Evar _x tushort) tushort)
                                         tint) (tptr tshort)) tshort) tshort)
                                 tint) tint tint))
                        (Sdo (Eassignop Oadd (Evar _sum_dyy tint)
                               (Ebinop Omul
                                 (Ecast
                                   (Evalof
                                     (Ederef
                                       (Ebinop Oadd
                                         (Evalof (Evar _dy_buf (tptr tshort))
                                           (tptr tshort))
                                         (Ebinop Oadd
                                           (Ebinop Omul
                                             (Evalof (Evar _y tushort)
                                               tushort)
                                             (Evalof
                                               (Efield
                                                 (Evalof
                                                   (Ederef
                                                     (Evalof
                                                       (Evar _dy (tptr (Tstruct _image_t noattr)))
                                                       (tptr (Tstruct _image_t noattr)))
                                                     (Tstruct _image_t noattr))
                                                   (Tstruct _image_t noattr))
                                                 _w tushort) tushort) tint)
                                           (Evalof (Evar _x tushort) tushort)
                                           tint) (tptr tshort)) tshort)
                                     tshort) tint)
                                 (Evalof
                                   (Ederef
                                     (Ebinop Oadd
                                       (Evalof (Evar _dy_buf (tptr tshort))
                                         (tptr tshort))
                                       (Ebinop Oadd
                                         (Ebinop Omul
                                           (Evalof (Evar _y tushort) tushort)
                                           (Evalof
                                             (Efield
                                               (Evalof
                                                 (Ederef
                                                   (Evalof
                                                     (Evar _dy (tptr (Tstruct _image_t noattr)))
                                                     (tptr (Tstruct _image_t noattr)))
                                                   (Tstruct _image_t noattr))
                                                 (Tstruct _image_t noattr))
                                               _w tushort) tushort) tint)
                                         (Evalof (Evar _x tushort) tushort)
                                         tint) (tptr tshort)) tshort) tshort)
                                 tint) tint tint))))))))
            (Ssequence
              (Sdo (Eassign
                     (Ederef
                       (Ebinop Oadd
                         (Evalof (Evar _g (tptr tint)) (tptr tint))
                         (Eval (Vint (Int.repr 0)) tint) (tptr tint)) tint)
                     (Ebinop Odiv (Evalof (Evar _sum_dxx tint) tint)
                       (Eval (Vint (Int.repr 255)) tint) tint) tint))
              (Ssequence
                (Sdo (Eassign
                       (Ederef
                         (Ebinop Oadd
                           (Evalof (Evar _g (tptr tint)) (tptr tint))
                           (Eval (Vint (Int.repr 1)) tint) (tptr tint)) tint)
                       (Ebinop Odiv (Evalof (Evar _sum_dxy tint) tint)
                         (Eval (Vint (Int.repr 255)) tint) tint) tint))
                (Ssequence
                  (Sdo (Eassign
                         (Ederef
                           (Ebinop Oadd
                             (Evalof (Evar _g (tptr tint)) (tptr tint))
                             (Eval (Vint (Int.repr 2)) tint) (tptr tint))
                           tint)
                         (Evalof
                           (Ederef
                             (Ebinop Oadd
                               (Evalof (Evar _g (tptr tint)) (tptr tint))
                               (Eval (Vint (Int.repr 1)) tint) (tptr tint))
                             tint) tint) tint))
                  (Sdo (Eassign
                         (Ederef
                           (Ebinop Oadd
                             (Evalof (Evar _g (tptr tint)) (tptr tint))
                             (Eval (Vint (Int.repr 3)) tint) (tptr tint))
                           tint)
                         (Ebinop Odiv (Evalof (Evar _sum_dyy tint) tint)
                           (Eval (Vint (Int.repr 255)) tint) tint) tint)))))))))))
|}.

Definition f_image_difference := {|
  fn_return := tuint;
  fn_callconv := cc_default;
  fn_params := ((_img_a, (tptr (Tstruct _image_t noattr))) ::
                (_img_b, (tptr (Tstruct _image_t noattr))) ::
                (_diff, (tptr (Tstruct _image_t noattr))) :: nil);
  fn_vars := ((_sum_diff2, tuint) :: (_diff_buf, (tptr tshort)) ::
              (_img_a_buf, (tptr tuchar)) :: (_img_b_buf, (tptr tuchar)) ::
              (_x, tushort) :: (_y, tushort) :: (_diff_c, tshort) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Eassign (Evar _sum_diff2 tuint) (Eval (Vint (Int.repr 0)) tint)
         tuint))
  (Ssequence
    (Sdo (Eassign (Evar _diff_buf (tptr tshort))
           (Ecast (Eval (Vint (Int.repr 0)) tint) (tptr tvoid))
           (tptr tshort)))
    (Ssequence
      (Sdo (Eassign (Evar _img_a_buf (tptr tuchar))
             (Ecast
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _img_a (tptr (Tstruct _image_t noattr)))
                         (tptr (Tstruct _image_t noattr)))
                       (Tstruct _image_t noattr)) (Tstruct _image_t noattr))
                   _buf (tptr tvoid)) (tptr tvoid)) (tptr tuchar))
             (tptr tuchar)))
      (Ssequence
        (Sdo (Eassign (Evar _img_b_buf (tptr tuchar))
               (Ecast
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _img_b (tptr (Tstruct _image_t noattr)))
                           (tptr (Tstruct _image_t noattr)))
                         (Tstruct _image_t noattr))
                       (Tstruct _image_t noattr)) _buf (tptr tvoid))
                   (tptr tvoid)) (tptr tuchar)) (tptr tuchar)))
        (Ssequence
          (Sifthenelse (Ebinop One
                         (Evalof
                           (Evar _diff (tptr (Tstruct _image_t noattr)))
                           (tptr (Tstruct _image_t noattr)))
                         (Ecast (Eval (Vint (Int.repr 0)) tint) (tptr tvoid))
                         tint)
            (Sdo (Eassign (Evar _diff_buf (tptr tshort))
                   (Ecast
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _diff (tptr (Tstruct _image_t noattr)))
                               (tptr (Tstruct _image_t noattr)))
                             (Tstruct _image_t noattr))
                           (Tstruct _image_t noattr)) _buf (tptr tvoid))
                       (tptr tvoid)) (tptr tshort)) (tptr tshort)))
            Sskip)
          (Ssequence
            (Ssequence
              (Sdo (Eassign (Evar _x tushort) (Eval (Vint (Int.repr 0)) tint)
                     tushort))
              (Sfor
                Sskip
                (Ebinop Olt (Evalof (Evar _x tushort) tushort)
                  (Evalof
                    (Efield
                      (Evalof
                        (Ederef
                          (Evalof
                            (Evar _img_b (tptr (Tstruct _image_t noattr)))
                            (tptr (Tstruct _image_t noattr)))
                          (Tstruct _image_t noattr))
                        (Tstruct _image_t noattr)) _w tushort) tushort) tint)
                (Sdo (Epostincr Incr (Evar _x tushort) tushort))
                (Ssequence
                  (Sdo (Eassign (Evar _y tushort)
                         (Eval (Vint (Int.repr 0)) tint) tushort))
                  (Sfor
                    Sskip
                    (Ebinop Olt (Evalof (Evar _y tushort) tushort)
                      (Evalof
                        (Efield
                          (Evalof
                            (Ederef
                              (Evalof
                                (Evar _img_b (tptr (Tstruct _image_t noattr)))
                                (tptr (Tstruct _image_t noattr)))
                              (Tstruct _image_t noattr))
                            (Tstruct _image_t noattr)) _h tushort) tushort)
                      tint)
                    (Sdo (Epostincr Incr (Evar _y tushort) tushort))
                    (Ssequence
                      (Sdo (Eassign (Evar _diff_c tshort)
                             (Ebinop Osub
                               (Evalof
                                 (Ederef
                                   (Ebinop Oadd
                                     (Evalof (Evar _img_a_buf (tptr tuchar))
                                       (tptr tuchar))
                                     (Ebinop Oadd
                                       (Ebinop Omul
                                         (Ebinop Oadd
                                           (Evalof (Evar _y tushort) tushort)
                                           (Eval (Vint (Int.repr 1)) tint)
                                           tint)
                                         (Evalof
                                           (Efield
                                             (Evalof
                                               (Ederef
                                                 (Evalof
                                                   (Evar _img_a (tptr (Tstruct _image_t noattr)))
                                                   (tptr (Tstruct _image_t noattr)))
                                                 (Tstruct _image_t noattr))
                                               (Tstruct _image_t noattr)) _w
                                             tushort) tushort) tint)
                                       (Ebinop Oadd
                                         (Evalof (Evar _x tushort) tushort)
                                         (Eval (Vint (Int.repr 1)) tint)
                                         tint) tint) (tptr tuchar)) tuchar)
                                 tuchar)
                               (Evalof
                                 (Ederef
                                   (Ebinop Oadd
                                     (Evalof (Evar _img_b_buf (tptr tuchar))
                                       (tptr tuchar))
                                     (Ebinop Oadd
                                       (Ebinop Omul
                                         (Evalof (Evar _y tushort) tushort)
                                         (Evalof
                                           (Efield
                                             (Evalof
                                               (Ederef
                                                 (Evalof
                                                   (Evar _img_b (tptr (Tstruct _image_t noattr)))
                                                   (tptr (Tstruct _image_t noattr)))
                                                 (Tstruct _image_t noattr))
                                               (Tstruct _image_t noattr)) _w
                                             tushort) tushort) tint)
                                       (Evalof (Evar _x tushort) tushort)
                                       tint) (tptr tuchar)) tuchar) tuchar)
                               tint) tshort))
                      (Ssequence
                        (Sdo (Eassignop Oadd (Evar _sum_diff2 tuint)
                               (Ebinop Omul
                                 (Evalof (Evar _diff_c tshort) tshort)
                                 (Evalof (Evar _diff_c tshort) tshort) tint)
                               tuint tuint))
                        (Sifthenelse (Ebinop One
                                       (Evalof (Evar _diff_buf (tptr tshort))
                                         (tptr tshort))
                                       (Ecast (Eval (Vint (Int.repr 0)) tint)
                                         (tptr tvoid)) tint)
                          (Sdo (Eassign
                                 (Ederef
                                   (Ebinop Oadd
                                     (Evalof (Evar _diff_buf (tptr tshort))
                                       (tptr tshort))
                                     (Ebinop Oadd
                                       (Ebinop Omul
                                         (Evalof (Evar _y tushort) tushort)
                                         (Evalof
                                           (Efield
                                             (Evalof
                                               (Ederef
                                                 (Evalof
                                                   (Evar _diff (tptr (Tstruct _image_t noattr)))
                                                   (tptr (Tstruct _image_t noattr)))
                                                 (Tstruct _image_t noattr))
                                               (Tstruct _image_t noattr)) _w
                                             tushort) tushort) tint)
                                       (Evalof (Evar _x tushort) tushort)
                                       tint) (tptr tshort)) tshort)
                                 (Evalof (Evar _diff_c tshort) tshort)
                                 tshort))
                          Sskip)))))))
            (Sreturn (Some (Evalof (Evar _sum_diff2 tuint) tuint)))))))))
|}.

Definition f_image_multiply := {|
  fn_return := tint;
  fn_callconv := cc_default;
  fn_params := ((_img_a, (tptr (Tstruct _image_t noattr))) ::
                (_img_b, (tptr (Tstruct _image_t noattr))) ::
                (_mult, (tptr (Tstruct _image_t noattr))) :: nil);
  fn_vars := ((_sum, tint) :: (_img_a_buf, (tptr tshort)) ::
              (_img_b_buf, (tptr tshort)) :: (_mult_buf, (tptr tshort)) ::
              (_x, tushort) :: (_y, tushort) :: (_mult_c, tint) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Eassign (Evar _sum tint) (Eval (Vint (Int.repr 0)) tint) tint))
  (Ssequence
    (Sdo (Eassign (Evar _img_a_buf (tptr tshort))
           (Ecast
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _img_a (tptr (Tstruct _image_t noattr)))
                       (tptr (Tstruct _image_t noattr)))
                     (Tstruct _image_t noattr)) (Tstruct _image_t noattr))
                 _buf (tptr tvoid)) (tptr tvoid)) (tptr tshort))
           (tptr tshort)))
    (Ssequence
      (Sdo (Eassign (Evar _img_b_buf (tptr tshort))
             (Ecast
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _img_b (tptr (Tstruct _image_t noattr)))
                         (tptr (Tstruct _image_t noattr)))
                       (Tstruct _image_t noattr)) (Tstruct _image_t noattr))
                   _buf (tptr tvoid)) (tptr tvoid)) (tptr tshort))
             (tptr tshort)))
      (Ssequence
        (Sdo (Eassign (Evar _mult_buf (tptr tshort))
               (Ecast (Eval (Vint (Int.repr 0)) tint) (tptr tvoid))
               (tptr tshort)))
        (Ssequence
          (Sifthenelse (Ebinop One
                         (Evalof
                           (Evar _mult (tptr (Tstruct _image_t noattr)))
                           (tptr (Tstruct _image_t noattr)))
                         (Ecast (Eval (Vint (Int.repr 0)) tint) (tptr tvoid))
                         tint)
            (Sdo (Eassign (Evar _mult_buf (tptr tshort))
                   (Ecast
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _mult (tptr (Tstruct _image_t noattr)))
                               (tptr (Tstruct _image_t noattr)))
                             (Tstruct _image_t noattr))
                           (Tstruct _image_t noattr)) _buf (tptr tvoid))
                       (tptr tvoid)) (tptr tshort)) (tptr tshort)))
            Sskip)
          (Ssequence
            (Ssequence
              (Sdo (Eassign (Evar _x tushort) (Eval (Vint (Int.repr 0)) tint)
                     tushort))
              (Sfor
                Sskip
                (Ebinop Olt (Evalof (Evar _x tushort) tushort)
                  (Evalof
                    (Efield
                      (Evalof
                        (Ederef
                          (Evalof
                            (Evar _img_a (tptr (Tstruct _image_t noattr)))
                            (tptr (Tstruct _image_t noattr)))
                          (Tstruct _image_t noattr))
                        (Tstruct _image_t noattr)) _w tushort) tushort) tint)
                (Sdo (Epostincr Incr (Evar _x tushort) tushort))
                (Ssequence
                  (Sdo (Eassign (Evar _y tushort)
                         (Eval (Vint (Int.repr 0)) tint) tushort))
                  (Sfor
                    Sskip
                    (Ebinop Olt (Evalof (Evar _y tushort) tushort)
                      (Evalof
                        (Efield
                          (Evalof
                            (Ederef
                              (Evalof
                                (Evar _img_a (tptr (Tstruct _image_t noattr)))
                                (tptr (Tstruct _image_t noattr)))
                              (Tstruct _image_t noattr))
                            (Tstruct _image_t noattr)) _h tushort) tushort)
                      tint)
                    (Sdo (Epostincr Incr (Evar _y tushort) tushort))
                    (Ssequence
                      (Sdo (Eassign (Evar _mult_c tint)
                             (Ebinop Omul
                               (Evalof
                                 (Ederef
                                   (Ebinop Oadd
                                     (Evalof (Evar _img_a_buf (tptr tshort))
                                       (tptr tshort))
                                     (Ebinop Oadd
                                       (Ebinop Omul
                                         (Evalof (Evar _y tushort) tushort)
                                         (Evalof
                                           (Efield
                                             (Evalof
                                               (Ederef
                                                 (Evalof
                                                   (Evar _img_a (tptr (Tstruct _image_t noattr)))
                                                   (tptr (Tstruct _image_t noattr)))
                                                 (Tstruct _image_t noattr))
                                               (Tstruct _image_t noattr)) _w
                                             tushort) tushort) tint)
                                       (Evalof (Evar _x tushort) tushort)
                                       tint) (tptr tshort)) tshort) tshort)
                               (Evalof
                                 (Ederef
                                   (Ebinop Oadd
                                     (Evalof (Evar _img_b_buf (tptr tshort))
                                       (tptr tshort))
                                     (Ebinop Oadd
                                       (Ebinop Omul
                                         (Evalof (Evar _y tushort) tushort)
                                         (Evalof
                                           (Efield
                                             (Evalof
                                               (Ederef
                                                 (Evalof
                                                   (Evar _img_b (tptr (Tstruct _image_t noattr)))
                                                   (tptr (Tstruct _image_t noattr)))
                                                 (Tstruct _image_t noattr))
                                               (Tstruct _image_t noattr)) _w
                                             tushort) tushort) tint)
                                       (Evalof (Evar _x tushort) tushort)
                                       tint) (tptr tshort)) tshort) tshort)
                               tint) tint))
                      (Ssequence
                        (Sdo (Eassignop Oadd (Evar _sum tint)
                               (Evalof (Evar _mult_c tint) tint) tint tint))
                        (Sifthenelse (Ebinop One
                                       (Evalof (Evar _mult_buf (tptr tshort))
                                         (tptr tshort))
                                       (Ecast (Eval (Vint (Int.repr 0)) tint)
                                         (tptr tvoid)) tint)
                          (Sdo (Eassign
                                 (Ederef
                                   (Ebinop Oadd
                                     (Evalof (Evar _mult_buf (tptr tshort))
                                       (tptr tshort))
                                     (Ebinop Oadd
                                       (Ebinop Omul
                                         (Evalof (Evar _y tushort) tushort)
                                         (Evalof
                                           (Efield
                                             (Evalof
                                               (Ederef
                                                 (Evalof
                                                   (Evar _mult (tptr (Tstruct _image_t noattr)))
                                                   (tptr (Tstruct _image_t noattr)))
                                                 (Tstruct _image_t noattr))
                                               (Tstruct _image_t noattr)) _w
                                             tushort) tushort) tint)
                                       (Evalof (Evar _x tushort) tushort)
                                       tint) (tptr tshort)) tshort)
                                 (Evalof (Evar _mult_c tint) tint) tshort))
                          Sskip)))))))
            (Sreturn (Some (Evalof (Evar _sum tint) tint)))))))))
|}.

Definition f_image_show_points := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_img, (tptr (Tstruct _image_t noattr))) ::
                (_points, (tptr (Tstruct _point_t noattr))) ::
                (_points_cnt, tushort) :: nil);
  fn_vars := ((_color, (tarray tuchar 4)) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Eassign
         (Ederef
           (Ebinop Oadd
             (Evalof (Evar _color (tarray tuchar 4)) (tarray tuchar 4))
             (Eval (Vint (Int.repr 0)) tint) (tptr tuchar)) tuchar)
         (Eval (Vint (Int.repr 255)) tint) tuchar))
  (Ssequence
    (Sdo (Eassign
           (Ederef
             (Ebinop Oadd
               (Evalof (Evar _color (tarray tuchar 4)) (tarray tuchar 4))
               (Eval (Vint (Int.repr 1)) tint) (tptr tuchar)) tuchar)
           (Eval (Vint (Int.repr 255)) tint) tuchar))
    (Ssequence
      (Sdo (Eassign
             (Ederef
               (Ebinop Oadd
                 (Evalof (Evar _color (tarray tuchar 4)) (tarray tuchar 4))
                 (Eval (Vint (Int.repr 2)) tint) (tptr tuchar)) tuchar)
             (Eval (Vint (Int.repr 255)) tint) tuchar))
      (Ssequence
        (Sdo (Eassign
               (Ederef
                 (Ebinop Oadd
                   (Evalof (Evar _color (tarray tuchar 4)) (tarray tuchar 4))
                   (Eval (Vint (Int.repr 3)) tint) (tptr tuchar)) tuchar)
               (Eval (Vint (Int.repr 255)) tint) tuchar))
        (Sdo (Ecall
               (Evalof
                 (Evar _image_show_points_color (Tfunction
                                                  ((tptr (Tstruct _image_t noattr)) ::
                                                   (tptr (Tstruct _point_t noattr)) ::
                                                   tushort ::
                                                   (tptr tuchar) :: nil)
                                                  tvoid cc_default))
                 (Tfunction
                   ((tptr (Tstruct _image_t noattr)) ::
                    (tptr (Tstruct _point_t noattr)) :: tushort ::
                    (tptr tuchar) :: nil) tvoid cc_default))
               (Econs
                 (Evalof (Evar _img (tptr (Tstruct _image_t noattr)))
                   (tptr (Tstruct _image_t noattr)))
                 (Econs
                   (Evalof (Evar _points (tptr (Tstruct _point_t noattr)))
                     (tptr (Tstruct _point_t noattr)))
                   (Econs (Evalof (Evar _points_cnt tushort) tushort)
                     (Econs
                       (Evalof (Evar _color (tarray tuchar 4))
                         (tarray tuchar 4)) Enil)))) tvoid))))))
|}.

Definition f_image_show_points_color := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_img, (tptr (Tstruct _image_t noattr))) ::
                (_points, (tptr (Tstruct _point_t noattr))) ::
                (_points_cnt, tushort) :: (_color, (tptr tuchar)) :: nil);
  fn_vars := ((_img_buf, (tptr tuchar)) :: (_pixel_width, tuchar) ::
              (_cross_hair, tint) :: (_size_crosshair, tint) :: (_i, tint) ::
              (_idx, tuint) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Eassign (Evar _img_buf (tptr tuchar))
         (Ecast
           (Evalof
             (Efield
               (Evalof
                 (Ederef
                   (Evalof (Evar _img (tptr (Tstruct _image_t noattr)))
                     (tptr (Tstruct _image_t noattr)))
                   (Tstruct _image_t noattr)) (Tstruct _image_t noattr)) _buf
               (tptr tvoid)) (tptr tvoid)) (tptr tuchar)) (tptr tuchar)))
  (Ssequence
    (Sdo (Eassign (Evar _pixel_width tuchar)
           (Econdition
             (Ebinop Oeq
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _img (tptr (Tstruct _image_t noattr)))
                         (tptr (Tstruct _image_t noattr)))
                       (Tstruct _image_t noattr)) (Tstruct _image_t noattr))
                   _type tint) tint) (Eval (Vint (Int.repr 0)) tint) tint)
             (Eval (Vint (Int.repr 2)) tint) (Eval (Vint (Int.repr 1)) tint)
             tint) tuchar))
    (Ssequence
      (Sdo (Eassign (Evar _cross_hair tint) (Eval (Vint (Int.repr 1)) tint)
             tint))
      (Ssequence
        (Sdo (Eassign (Evar _size_crosshair tint)
               (Eval (Vint (Int.repr 5)) tint) tint))
        (Ssequence
          (Sdo (Eassign (Evar _i tint) (Eval (Vint (Int.repr 0)) tint) tint))
          (Sfor
            Sskip
            (Ebinop Olt (Evalof (Evar _i tint) tint)
              (Evalof (Evar _points_cnt tushort) tushort) tint)
            (Sdo (Epostincr Incr (Evar _i tint) tint))
            (Sifthenelse (Eunop Onotbool
                           (Evalof (Evar _cross_hair tint) tint) tint)
              (Ssequence
                (Sdo (Eassign (Evar _idx tuint)
                       (Ebinop Oadd
                         (Ebinop Omul
                           (Ebinop Omul
                             (Evalof (Evar _pixel_width tuchar) tuchar)
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Ebinop Oadd
                                       (Evalof
                                         (Evar _points (tptr (Tstruct _point_t noattr)))
                                         (tptr (Tstruct _point_t noattr)))
                                       (Evalof (Evar _i tint) tint)
                                       (tptr (Tstruct _point_t noattr)))
                                     (Tstruct _point_t noattr))
                                   (Tstruct _point_t noattr)) _y tuint)
                               tuint) tuint)
                           (Evalof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Evalof
                                     (Evar _img (tptr (Tstruct _image_t noattr)))
                                     (tptr (Tstruct _image_t noattr)))
                                   (Tstruct _image_t noattr))
                                 (Tstruct _image_t noattr)) _w tushort)
                             tushort) tuint)
                         (Ebinop Omul
                           (Evalof
                             (Efield
                               (Evalof
                                 (Ederef
                                   (Ebinop Oadd
                                     (Evalof
                                       (Evar _points (tptr (Tstruct _point_t noattr)))
                                       (tptr (Tstruct _point_t noattr)))
                                     (Evalof (Evar _i tint) tint)
                                     (tptr (Tstruct _point_t noattr)))
                                   (Tstruct _point_t noattr))
                                 (Tstruct _point_t noattr)) _x tuint) tuint)
                           (Evalof (Evar _pixel_width tuchar) tuchar) tuint)
                         tuint) tuint))
                (Ssequence
                  (Sdo (Eassign
                         (Ederef
                           (Ebinop Oadd
                             (Evalof (Evar _img_buf (tptr tuchar))
                               (tptr tuchar))
                             (Evalof (Evar _idx tuint) tuint) (tptr tuchar))
                           tuchar) (Eval (Vint (Int.repr 255)) tint) tuchar))
                  (Sifthenelse (Ebinop Oeq
                                 (Evalof
                                   (Efield
                                     (Evalof
                                       (Ederef
                                         (Evalof
                                           (Evar _img (tptr (Tstruct _image_t noattr)))
                                           (tptr (Tstruct _image_t noattr)))
                                         (Tstruct _image_t noattr))
                                       (Tstruct _image_t noattr)) _type tint)
                                   tint) (Eval (Vint (Int.repr 0)) tint)
                                 tint)
                    (Ssequence
                      (Sdo (Epostincr Incr (Evar _idx tuint) tuint))
                      (Sdo (Eassign
                             (Ederef
                               (Ebinop Oadd
                                 (Evalof (Evar _img_buf (tptr tuchar))
                                   (tptr tuchar))
                                 (Evalof (Evar _idx tuint) tuint)
                                 (tptr tuchar)) tuchar)
                             (Eval (Vint (Int.repr 255)) tint) tuchar)))
                    Sskip)))
              (Sdo (Ecall
                     (Evalof
                       (Evar _image_draw_crosshair (Tfunction
                                                     ((tptr (Tstruct _image_t noattr)) ::
                                                      (tptr (Tstruct _point_t noattr)) ::
                                                      (tptr tuchar) ::
                                                      tuint :: nil) tvoid
                                                     cc_default))
                       (Tfunction
                         ((tptr (Tstruct _image_t noattr)) ::
                          (tptr (Tstruct _point_t noattr)) ::
                          (tptr tuchar) :: tuint :: nil) tvoid cc_default))
                     (Econs
                       (Evalof (Evar _img (tptr (Tstruct _image_t noattr)))
                         (tptr (Tstruct _image_t noattr)))
                       (Econs
                         (Eaddrof
                           (Ederef
                             (Ebinop Oadd
                               (Evalof
                                 (Evar _points (tptr (Tstruct _point_t noattr)))
                                 (tptr (Tstruct _point_t noattr)))
                               (Evalof (Evar _i tint) tint)
                               (tptr (Tstruct _point_t noattr)))
                             (Tstruct _point_t noattr))
                           (tptr (Tstruct _point_t noattr)))
                         (Econs
                           (Evalof (Evar _color (tptr tuchar)) (tptr tuchar))
                           (Econs (Evalof (Evar _size_crosshair tint) tint)
                             Enil)))) tvoid)))))))))
|}.

Definition v_color := {|
  gvar_info := (tarray tuchar 4);
  gvar_init := (Init_int8 (Int.repr 255) :: Init_int8 (Int.repr 255) ::
                Init_int8 (Int.repr 255) :: Init_int8 (Int.repr 255) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_bad_color := {|
  gvar_info := (tarray tuchar 4);
  gvar_init := (Init_int8 (Int.repr 0) :: Init_int8 (Int.repr 0) ::
                Init_int8 (Int.repr 0) :: Init_int8 (Int.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition f_image_show_flow := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_img, (tptr (Tstruct _image_t noattr))) ::
                (_vectors, (tptr (Tstruct _flow_t noattr))) ::
                (_points_cnt, tushort) :: (_subpixel_factor, tuchar) :: nil);
  fn_vars := nil;
  fn_body :=
(Sdo (Ecall
       (Evalof
         (Evar _image_show_flow_color (Tfunction
                                        ((tptr (Tstruct _image_t noattr)) ::
                                         (tptr (Tstruct _flow_t noattr)) ::
                                         tushort :: tuchar ::
                                         (tptr tuchar) :: (tptr tuchar) ::
                                         nil) tvoid cc_default))
         (Tfunction
           ((tptr (Tstruct _image_t noattr)) ::
            (tptr (Tstruct _flow_t noattr)) :: tushort :: tuchar ::
            (tptr tuchar) :: (tptr tuchar) :: nil) tvoid cc_default))
       (Econs
         (Evalof (Evar _img (tptr (Tstruct _image_t noattr)))
           (tptr (Tstruct _image_t noattr)))
         (Econs
           (Evalof (Evar _vectors (tptr (Tstruct _flow_t noattr)))
             (tptr (Tstruct _flow_t noattr)))
           (Econs (Evalof (Evar _points_cnt tushort) tushort)
             (Econs (Evalof (Evar _subpixel_factor tuchar) tuchar)
               (Econs
                 (Evalof (Evar _color (tarray tuchar 4)) (tarray tuchar 4))
                 (Econs
                   (Evalof (Evar _bad_color (tarray tuchar 4))
                     (tarray tuchar 4)) Enil)))))) tvoid))
|}.

Definition v_size_crosshair := {|
  gvar_info := tint;
  gvar_init := (Init_int32 (Int.repr 5) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition f_image_show_flow_color := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_img, (tptr (Tstruct _image_t noattr))) ::
                (_vectors, (tptr (Tstruct _flow_t noattr))) ::
                (_points_cnt, tushort) :: (_subpixel_factor, tuchar) ::
                (_color__1, (tptr tuchar)) ::
                (_bad_color__1, (tptr tuchar)) :: nil);
  fn_vars := ((_i, tushort) :: (_from, (Tstruct _point_t noattr)) ::
              (_to, (Tstruct _point_t noattr)) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Eassign (Evar _i tushort) (Eval (Vint (Int.repr 0)) tint) tushort))
  (Sfor
    Sskip
    (Ebinop Olt (Evalof (Evar _i tushort) tushort)
      (Evalof (Evar _points_cnt tushort) tushort) tint)
    (Sdo (Epostincr Incr (Evar _i tushort) tushort))
    (Ssequence
      (Sdo (Eassign
             (Efield
               (Evalof (Evar _from (Tstruct _point_t noattr))
                 (Tstruct _point_t noattr)) _x tuint)
             (Ebinop Odiv
               (Evalof
                 (Efield
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Ebinop Oadd
                             (Evalof
                               (Evar _vectors (tptr (Tstruct _flow_t noattr)))
                               (tptr (Tstruct _flow_t noattr)))
                             (Evalof (Evar _i tushort) tushort)
                             (tptr (Tstruct _flow_t noattr)))
                           (Tstruct _flow_t noattr))
                         (Tstruct _flow_t noattr)) _pos
                       (Tstruct _point_t noattr)) (Tstruct _point_t noattr))
                   _x tuint) tuint)
               (Evalof (Evar _subpixel_factor tuchar) tuchar) tuint) tuint))
      (Ssequence
        (Sdo (Eassign
               (Efield
                 (Evalof (Evar _from (Tstruct _point_t noattr))
                   (Tstruct _point_t noattr)) _y tuint)
               (Ebinop Odiv
                 (Evalof
                   (Efield
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Ebinop Oadd
                               (Evalof
                                 (Evar _vectors (tptr (Tstruct _flow_t noattr)))
                                 (tptr (Tstruct _flow_t noattr)))
                               (Evalof (Evar _i tushort) tushort)
                               (tptr (Tstruct _flow_t noattr)))
                             (Tstruct _flow_t noattr))
                           (Tstruct _flow_t noattr)) _pos
                         (Tstruct _point_t noattr))
                       (Tstruct _point_t noattr)) _y tuint) tuint)
                 (Evalof (Evar _subpixel_factor tuchar) tuchar) tuint) tuint))
        (Ssequence
          (Sdo (Eassign
                 (Efield
                   (Evalof (Evar _from (Tstruct _point_t noattr))
                     (Tstruct _point_t noattr)) _count tushort)
                 (Eval (Vint (Int.repr 0)) tint) tushort))
          (Ssequence
            (Sdo (Eassign
                   (Efield
                     (Evalof (Evar _from (Tstruct _point_t noattr))
                       (Tstruct _point_t noattr)) _x_sub tushort)
                   (Eval (Vint (Int.repr 0)) tint) tushort))
            (Ssequence
              (Sdo (Eassign
                     (Efield
                       (Evalof (Evar _from (Tstruct _point_t noattr))
                         (Tstruct _point_t noattr)) _y_sub tushort)
                     (Eval (Vint (Int.repr 0)) tint) tushort))
              (Ssequence
                (Sdo (Eassign
                       (Efield
                         (Evalof (Evar _to (Tstruct _point_t noattr))
                           (Tstruct _point_t noattr)) _x tuint)
                       (Ecast
                         (Ecall
                           (Evalof
                             (Evar _roundf (Tfunction (tfloat :: nil) tfloat
                                             cc_default))
                             (Tfunction (tfloat :: nil) tfloat cc_default))
                           (Econs
                             (Ebinop Odiv
                               (Ebinop Oadd
                                 (Ecast
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Efield
                                           (Evalof
                                             (Ederef
                                               (Ebinop Oadd
                                                 (Evalof
                                                   (Evar _vectors (tptr (Tstruct _flow_t noattr)))
                                                   (tptr (Tstruct _flow_t noattr)))
                                                 (Evalof (Evar _i tushort)
                                                   tushort)
                                                 (tptr (Tstruct _flow_t noattr)))
                                               (Tstruct _flow_t noattr))
                                             (Tstruct _flow_t noattr)) _pos
                                           (Tstruct _point_t noattr))
                                         (Tstruct _point_t noattr)) _x tuint)
                                     tuint) tfloat)
                                 (Evalof
                                   (Efield
                                     (Evalof
                                       (Ederef
                                         (Ebinop Oadd
                                           (Evalof
                                             (Evar _vectors (tptr (Tstruct _flow_t noattr)))
                                             (tptr (Tstruct _flow_t noattr)))
                                           (Evalof (Evar _i tushort) tushort)
                                           (tptr (Tstruct _flow_t noattr)))
                                         (Tstruct _flow_t noattr))
                                       (Tstruct _flow_t noattr)) _flow_x
                                     tint) tint) tfloat)
                               (Evalof (Evar _subpixel_factor tuchar) tuchar)
                               tfloat) Enil) tfloat) tuint) tuint))
                (Ssequence
                  (Sdo (Eassign
                         (Efield
                           (Evalof (Evar _to (Tstruct _point_t noattr))
                             (Tstruct _point_t noattr)) _y tuint)
                         (Ecast
                           (Ecall
                             (Evalof
                               (Evar _roundf (Tfunction (tfloat :: nil)
                                               tfloat cc_default))
                               (Tfunction (tfloat :: nil) tfloat cc_default))
                             (Econs
                               (Ebinop Odiv
                                 (Ebinop Oadd
                                   (Ecast
                                     (Evalof
                                       (Efield
                                         (Evalof
                                           (Efield
                                             (Evalof
                                               (Ederef
                                                 (Ebinop Oadd
                                                   (Evalof
                                                     (Evar _vectors (tptr (Tstruct _flow_t noattr)))
                                                     (tptr (Tstruct _flow_t noattr)))
                                                   (Evalof (Evar _i tushort)
                                                     tushort)
                                                   (tptr (Tstruct _flow_t noattr)))
                                                 (Tstruct _flow_t noattr))
                                               (Tstruct _flow_t noattr)) _pos
                                             (Tstruct _point_t noattr))
                                           (Tstruct _point_t noattr)) _y
                                         tuint) tuint) tfloat)
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Ederef
                                           (Ebinop Oadd
                                             (Evalof
                                               (Evar _vectors (tptr (Tstruct _flow_t noattr)))
                                               (tptr (Tstruct _flow_t noattr)))
                                             (Evalof (Evar _i tushort)
                                               tushort)
                                             (tptr (Tstruct _flow_t noattr)))
                                           (Tstruct _flow_t noattr))
                                         (Tstruct _flow_t noattr)) _flow_y
                                       tint) tint) tfloat)
                                 (Evalof (Evar _subpixel_factor tuchar)
                                   tuchar) tfloat) Enil) tfloat) tuint)
                         tuint))
                  (Ssequence
                    (Sdo (Eassign
                           (Efield
                             (Evalof (Evar _to (Tstruct _point_t noattr))
                               (Tstruct _point_t noattr)) _count tushort)
                           (Eval (Vint (Int.repr 0)) tint) tushort))
                    (Ssequence
                      (Sdo (Eassign
                             (Efield
                               (Evalof (Evar _to (Tstruct _point_t noattr))
                                 (Tstruct _point_t noattr)) _x_sub tushort)
                             (Eval (Vint (Int.repr 0)) tint) tushort))
                      (Ssequence
                        (Sdo (Eassign
                               (Efield
                                 (Evalof (Evar _to (Tstruct _point_t noattr))
                                   (Tstruct _point_t noattr)) _y_sub tushort)
                               (Eval (Vint (Int.repr 0)) tint) tushort))
                        (Sifthenelse (Ebinop Oge
                                       (Evalof
                                         (Efield
                                           (Evalof
                                             (Ederef
                                               (Ebinop Oadd
                                                 (Evalof
                                                   (Evar _vectors (tptr (Tstruct _flow_t noattr)))
                                                   (tptr (Tstruct _flow_t noattr)))
                                                 (Evalof (Evar _i tushort)
                                                   tushort)
                                                 (tptr (Tstruct _flow_t noattr)))
                                               (Tstruct _flow_t noattr))
                                             (Tstruct _flow_t noattr)) _error
                                           tuint) tuint)
                                       (Eval (Vfloat (Float.of_bits (Int64.repr 4681608360884174848))) tdouble)
                                       tint)
                          (Ssequence
                            (Sdo (Ecall
                                   (Evalof
                                     (Evar _image_draw_crosshair (Tfunction
                                                                   ((tptr (Tstruct _image_t noattr)) ::
                                                                    (tptr (Tstruct _point_t noattr)) ::
                                                                    (tptr tuchar) ::
                                                                    tuint ::
                                                                    nil)
                                                                   tvoid
                                                                   cc_default))
                                     (Tfunction
                                       ((tptr (Tstruct _image_t noattr)) ::
                                        (tptr (Tstruct _point_t noattr)) ::
                                        (tptr tuchar) :: tuint :: nil) tvoid
                                       cc_default))
                                   (Econs
                                     (Evalof
                                       (Evar _img (tptr (Tstruct _image_t noattr)))
                                       (tptr (Tstruct _image_t noattr)))
                                     (Econs
                                       (Eaddrof
                                         (Evar _to (Tstruct _point_t noattr))
                                         (tptr (Tstruct _point_t noattr)))
                                       (Econs
                                         (Evalof
                                           (Evar _bad_color__1 (tptr tuchar))
                                           (tptr tuchar))
                                         (Econs
                                           (Evalof
                                             (Evar _size_crosshair tint)
                                             tint) Enil)))) tvoid))
                            (Sdo (Ecall
                                   (Evalof
                                     (Evar _image_draw_line_color (Tfunction
                                                                    ((tptr (Tstruct _image_t noattr)) ::
                                                                    (tptr (Tstruct _point_t noattr)) ::
                                                                    (tptr (Tstruct _point_t noattr)) ::
                                                                    (tptr tuchar) ::
                                                                    nil)
                                                                    tvoid
                                                                    cc_default))
                                     (Tfunction
                                       ((tptr (Tstruct _image_t noattr)) ::
                                        (tptr (Tstruct _point_t noattr)) ::
                                        (tptr (Tstruct _point_t noattr)) ::
                                        (tptr tuchar) :: nil) tvoid
                                       cc_default))
                                   (Econs
                                     (Evalof
                                       (Evar _img (tptr (Tstruct _image_t noattr)))
                                       (tptr (Tstruct _image_t noattr)))
                                     (Econs
                                       (Eaddrof
                                         (Evar _from (Tstruct _point_t noattr))
                                         (tptr (Tstruct _point_t noattr)))
                                       (Econs
                                         (Eaddrof
                                           (Evar _to (Tstruct _point_t noattr))
                                           (tptr (Tstruct _point_t noattr)))
                                         (Econs
                                           (Evalof
                                             (Evar _bad_color__1 (tptr tuchar))
                                             (tptr tuchar)) Enil)))) tvoid)))
                          (Ssequence
                            (Sdo (Ecall
                                   (Evalof
                                     (Evar _image_draw_crosshair (Tfunction
                                                                   ((tptr (Tstruct _image_t noattr)) ::
                                                                    (tptr (Tstruct _point_t noattr)) ::
                                                                    (tptr tuchar) ::
                                                                    tuint ::
                                                                    nil)
                                                                   tvoid
                                                                   cc_default))
                                     (Tfunction
                                       ((tptr (Tstruct _image_t noattr)) ::
                                        (tptr (Tstruct _point_t noattr)) ::
                                        (tptr tuchar) :: tuint :: nil) tvoid
                                       cc_default))
                                   (Econs
                                     (Evalof
                                       (Evar _img (tptr (Tstruct _image_t noattr)))
                                       (tptr (Tstruct _image_t noattr)))
                                     (Econs
                                       (Eaddrof
                                         (Evar _to (Tstruct _point_t noattr))
                                         (tptr (Tstruct _point_t noattr)))
                                       (Econs
                                         (Evalof
                                           (Evar _color__1 (tptr tuchar))
                                           (tptr tuchar))
                                         (Econs
                                           (Evalof
                                             (Evar _size_crosshair tint)
                                             tint) Enil)))) tvoid))
                            (Sdo (Ecall
                                   (Evalof
                                     (Evar _image_draw_line_color (Tfunction
                                                                    ((tptr (Tstruct _image_t noattr)) ::
                                                                    (tptr (Tstruct _point_t noattr)) ::
                                                                    (tptr (Tstruct _point_t noattr)) ::
                                                                    (tptr tuchar) ::
                                                                    nil)
                                                                    tvoid
                                                                    cc_default))
                                     (Tfunction
                                       ((tptr (Tstruct _image_t noattr)) ::
                                        (tptr (Tstruct _point_t noattr)) ::
                                        (tptr (Tstruct _point_t noattr)) ::
                                        (tptr tuchar) :: nil) tvoid
                                       cc_default))
                                   (Econs
                                     (Evalof
                                       (Evar _img (tptr (Tstruct _image_t noattr)))
                                       (tptr (Tstruct _image_t noattr)))
                                     (Econs
                                       (Eaddrof
                                         (Evar _from (Tstruct _point_t noattr))
                                         (tptr (Tstruct _point_t noattr)))
                                       (Econs
                                         (Eaddrof
                                           (Evar _to (Tstruct _point_t noattr))
                                           (tptr (Tstruct _point_t noattr)))
                                         (Econs
                                           (Evalof
                                             (Evar _color__1 (tptr tuchar))
                                             (tptr tuchar)) Enil)))) tvoid))))))))))))))))
|}.

Definition v_Sobel := {|
  gvar_info := (tarray tint 9);
  gvar_init := (Init_int32 (Int.repr (-1)) :: Init_int32 (Int.repr 0) ::
                Init_int32 (Int.repr 1) :: Init_int32 (Int.repr (-2)) ::
                Init_int32 (Int.repr 0) :: Init_int32 (Int.repr 2) ::
                Init_int32 (Int.repr (-1)) :: Init_int32 (Int.repr 0) ::
                Init_int32 (Int.repr 1) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_total_sobel := {|
  gvar_info := tint;
  gvar_init := (Init_int32 (Int.repr 8) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition f_image_gradient_pixel := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_img, (tptr (Tstruct _image_t noattr))) ::
                (_loc, (tptr (Tstruct _point_t noattr))) ::
                (_method, tint) :: (_dx, (tptr tint)) ::
                (_dy, (tptr tint)) :: nil);
  fn_vars := ((_gradient_x, tint) :: (_gradient_y, tint) :: (_index, tint) ::
              (_img_buf, (tptr tuchar)) :: (_pixel_width, tuchar) ::
              (_add_ind, tuchar) :: (_filt_ind_y, tint) ::
              (_filt_ind_x, tint) :: (_x, tint) :: (_y, tint) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Eassign (Evar _gradient_x tint) (Eval (Vint (Int.repr 0)) tint) tint))
  (Ssequence
    (Sdo (Eassign (Evar _gradient_y tint) (Eval (Vint (Int.repr 0)) tint)
           tint))
    (Ssequence
      (Sdo (Eassign (Evar _img_buf (tptr tuchar))
             (Ecast
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _img (tptr (Tstruct _image_t noattr)))
                         (tptr (Tstruct _image_t noattr)))
                       (Tstruct _image_t noattr)) (Tstruct _image_t noattr))
                   _buf (tptr tvoid)) (tptr tvoid)) (tptr tuchar))
             (tptr tuchar)))
      (Ssequence
        (Sdo (Eassign (Evar _pixel_width tuchar)
               (Econdition
                 (Ebinop Oeq
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _img (tptr (Tstruct _image_t noattr)))
                             (tptr (Tstruct _image_t noattr)))
                           (Tstruct _image_t noattr))
                         (Tstruct _image_t noattr)) _type tint) tint)
                   (Eval (Vint (Int.repr 0)) tint) tint)
                 (Eval (Vint (Int.repr 2)) tint)
                 (Eval (Vint (Int.repr 1)) tint) tint) tuchar))
        (Ssequence
          (Sdo (Eassign (Evar _add_ind tuchar)
                 (Ebinop Osub (Evalof (Evar _pixel_width tuchar) tuchar)
                   (Eval (Vint (Int.repr 1)) tint) tint) tuchar))
          (Ssequence
            (Sifthenelse (Eseqand
                           (Eseqand
                             (Eseqand
                               (Ebinop Oge
                                 (Evalof
                                   (Efield
                                     (Evalof
                                       (Ederef
                                         (Evalof
                                           (Evar _loc (tptr (Tstruct _point_t noattr)))
                                           (tptr (Tstruct _point_t noattr)))
                                         (Tstruct _point_t noattr))
                                       (Tstruct _point_t noattr)) _x tuint)
                                   tuint) (Eval (Vint (Int.repr 1)) tint)
                                 tint)
                               (Ebinop Olt
                                 (Ebinop Oadd
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Ederef
                                           (Evalof
                                             (Evar _loc (tptr (Tstruct _point_t noattr)))
                                             (tptr (Tstruct _point_t noattr)))
                                           (Tstruct _point_t noattr))
                                         (Tstruct _point_t noattr)) _x tuint)
                                     tuint) (Eval (Vint (Int.repr 1)) tint)
                                   tuint)
                                 (Evalof
                                   (Efield
                                     (Evalof
                                       (Ederef
                                         (Evalof
                                           (Evar _img (tptr (Tstruct _image_t noattr)))
                                           (tptr (Tstruct _image_t noattr)))
                                         (Tstruct _image_t noattr))
                                       (Tstruct _image_t noattr)) _w tushort)
                                   tushort) tint) tint)
                             (Ebinop Oge
                               (Evalof
                                 (Efield
                                   (Evalof
                                     (Ederef
                                       (Evalof
                                         (Evar _loc (tptr (Tstruct _point_t noattr)))
                                         (tptr (Tstruct _point_t noattr)))
                                       (Tstruct _point_t noattr))
                                     (Tstruct _point_t noattr)) _y tuint)
                                 tuint) (Eval (Vint (Int.repr 1)) tint) tint)
                             tint)
                           (Ebinop Olt
                             (Ebinop Oadd
                               (Evalof
                                 (Efield
                                   (Evalof
                                     (Ederef
                                       (Evalof
                                         (Evar _loc (tptr (Tstruct _point_t noattr)))
                                         (tptr (Tstruct _point_t noattr)))
                                       (Tstruct _point_t noattr))
                                     (Tstruct _point_t noattr)) _y tuint)
                                 tuint) (Eval (Vint (Int.repr 1)) tint)
                               tuint)
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _img (tptr (Tstruct _image_t noattr)))
                                       (tptr (Tstruct _image_t noattr)))
                                     (Tstruct _image_t noattr))
                                   (Tstruct _image_t noattr)) _h tushort)
                               tushort) tint) tint)
              (Sifthenelse (Ebinop Oeq (Evalof (Evar _method tint) tint)
                             (Eval (Vint (Int.repr 0)) tint) tint)
                (Ssequence
                  (Sdo (Eassign (Evar _index tint)
                         (Ebinop Oadd
                           (Ebinop Omul
                             (Ebinop Omul
                               (Evalof
                                 (Efield
                                   (Evalof
                                     (Ederef
                                       (Evalof
                                         (Evar _loc (tptr (Tstruct _point_t noattr)))
                                         (tptr (Tstruct _point_t noattr)))
                                       (Tstruct _point_t noattr))
                                     (Tstruct _point_t noattr)) _y tuint)
                                 tuint)
                               (Evalof
                                 (Efield
                                   (Evalof
                                     (Ederef
                                       (Evalof
                                         (Evar _img (tptr (Tstruct _image_t noattr)))
                                         (tptr (Tstruct _image_t noattr)))
                                       (Tstruct _image_t noattr))
                                     (Tstruct _image_t noattr)) _w tushort)
                                 tushort) tuint)
                             (Evalof (Evar _pixel_width tuchar) tuchar)
                             tuint)
                           (Ebinop Omul
                             (Ebinop Osub
                               (Evalof
                                 (Efield
                                   (Evalof
                                     (Ederef
                                       (Evalof
                                         (Evar _loc (tptr (Tstruct _point_t noattr)))
                                         (tptr (Tstruct _point_t noattr)))
                                       (Tstruct _point_t noattr))
                                     (Tstruct _point_t noattr)) _x tuint)
                                 tuint) (Eval (Vint (Int.repr 1)) tint)
                               tuint)
                             (Evalof (Evar _pixel_width tuchar) tuchar)
                             tuint) tuint) tint))
                  (Ssequence
                    (Sdo (Eassignop Osub (Evar _gradient_x tint)
                           (Ecast
                             (Evalof
                               (Ederef
                                 (Ebinop Oadd
                                   (Evalof (Evar _img_buf (tptr tuchar))
                                     (tptr tuchar))
                                   (Ebinop Oadd
                                     (Evalof (Evar _index tint) tint)
                                     (Evalof (Evar _add_ind tuchar) tuchar)
                                     tint) (tptr tuchar)) tuchar) tuchar)
                             tint) tint tint))
                    (Ssequence
                      (Sdo (Eassign (Evar _index tint)
                             (Ebinop Oadd
                               (Ebinop Omul
                                 (Ebinop Omul
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Ederef
                                           (Evalof
                                             (Evar _loc (tptr (Tstruct _point_t noattr)))
                                             (tptr (Tstruct _point_t noattr)))
                                           (Tstruct _point_t noattr))
                                         (Tstruct _point_t noattr)) _y tuint)
                                     tuint)
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Ederef
                                           (Evalof
                                             (Evar _img (tptr (Tstruct _image_t noattr)))
                                             (tptr (Tstruct _image_t noattr)))
                                           (Tstruct _image_t noattr))
                                         (Tstruct _image_t noattr)) _w
                                       tushort) tushort) tuint)
                                 (Evalof (Evar _pixel_width tuchar) tuchar)
                                 tuint)
                               (Ebinop Omul
                                 (Ebinop Oadd
                                   (Evalof
                                     (Efield
                                       (Evalof
                                         (Ederef
                                           (Evalof
                                             (Evar _loc (tptr (Tstruct _point_t noattr)))
                                             (tptr (Tstruct _point_t noattr)))
                                           (Tstruct _point_t noattr))
                                         (Tstruct _point_t noattr)) _x tuint)
                                     tuint) (Eval (Vint (Int.repr 1)) tint)
                                   tuint)
                                 (Evalof (Evar _pixel_width tuchar) tuchar)
                                 tuint) tuint) tint))
                      (Ssequence
                        (Sdo (Eassignop Oadd (Evar _gradient_x tint)
                               (Ecast
                                 (Evalof
                                   (Ederef
                                     (Ebinop Oadd
                                       (Evalof (Evar _img_buf (tptr tuchar))
                                         (tptr tuchar))
                                       (Ebinop Oadd
                                         (Evalof (Evar _index tint) tint)
                                         (Evalof (Evar _add_ind tuchar)
                                           tuchar) tint) (tptr tuchar))
                                     tuchar) tuchar) tint) tint tint))
                        (Ssequence
                          (Sdo (Eassign (Evar _index tint)
                                 (Ebinop Oadd
                                   (Ebinop Omul
                                     (Ebinop Omul
                                       (Ebinop Osub
                                         (Evalof
                                           (Efield
                                             (Evalof
                                               (Ederef
                                                 (Evalof
                                                   (Evar _loc (tptr (Tstruct _point_t noattr)))
                                                   (tptr (Tstruct _point_t noattr)))
                                                 (Tstruct _point_t noattr))
                                               (Tstruct _point_t noattr)) _y
                                             tuint) tuint)
                                         (Eval (Vint (Int.repr 1)) tint)
                                         tuint)
                                       (Evalof
                                         (Efield
                                           (Evalof
                                             (Ederef
                                               (Evalof
                                                 (Evar _img (tptr (Tstruct _image_t noattr)))
                                                 (tptr (Tstruct _image_t noattr)))
                                               (Tstruct _image_t noattr))
                                             (Tstruct _image_t noattr)) _w
                                           tushort) tushort) tuint)
                                     (Evalof (Evar _pixel_width tuchar)
                                       tuchar) tuint)
                                   (Ebinop Omul
                                     (Evalof
                                       (Efield
                                         (Evalof
                                           (Ederef
                                             (Evalof
                                               (Evar _loc (tptr (Tstruct _point_t noattr)))
                                               (tptr (Tstruct _point_t noattr)))
                                             (Tstruct _point_t noattr))
                                           (Tstruct _point_t noattr)) _x
                                         tuint) tuint)
                                     (Evalof (Evar _pixel_width tuchar)
                                       tuchar) tuint) tuint) tint))
                          (Ssequence
                            (Sdo (Eassignop Osub (Evar _gradient_y tint)
                                   (Ecast
                                     (Evalof
                                       (Ederef
                                         (Ebinop Oadd
                                           (Evalof
                                             (Evar _img_buf (tptr tuchar))
                                             (tptr tuchar))
                                           (Ebinop Oadd
                                             (Evalof (Evar _index tint) tint)
                                             (Evalof (Evar _add_ind tuchar)
                                               tuchar) tint) (tptr tuchar))
                                         tuchar) tuchar) tint) tint tint))
                            (Ssequence
                              (Sdo (Eassign (Evar _index tint)
                                     (Ebinop Oadd
                                       (Ebinop Omul
                                         (Ebinop Omul
                                           (Ebinop Oadd
                                             (Evalof
                                               (Efield
                                                 (Evalof
                                                   (Ederef
                                                     (Evalof
                                                       (Evar _loc (tptr (Tstruct _point_t noattr)))
                                                       (tptr (Tstruct _point_t noattr)))
                                                     (Tstruct _point_t noattr))
                                                   (Tstruct _point_t noattr))
                                                 _y tuint) tuint)
                                             (Eval (Vint (Int.repr 1)) tint)
                                             tuint)
                                           (Evalof
                                             (Efield
                                               (Evalof
                                                 (Ederef
                                                   (Evalof
                                                     (Evar _img (tptr (Tstruct _image_t noattr)))
                                                     (tptr (Tstruct _image_t noattr)))
                                                   (Tstruct _image_t noattr))
                                                 (Tstruct _image_t noattr))
                                               _w tushort) tushort) tuint)
                                         (Evalof (Evar _pixel_width tuchar)
                                           tuchar) tuint)
                                       (Ebinop Omul
                                         (Evalof
                                           (Efield
                                             (Evalof
                                               (Ederef
                                                 (Evalof
                                                   (Evar _loc (tptr (Tstruct _point_t noattr)))
                                                   (tptr (Tstruct _point_t noattr)))
                                                 (Tstruct _point_t noattr))
                                               (Tstruct _point_t noattr)) _x
                                             tuint) tuint)
                                         (Evalof (Evar _pixel_width tuchar)
                                           tuchar) tuint) tuint) tint))
                              (Sdo (Eassignop Oadd (Evar _gradient_y tint)
                                     (Ecast
                                       (Evalof
                                         (Ederef
                                           (Ebinop Oadd
                                             (Evalof
                                               (Evar _img_buf (tptr tuchar))
                                               (tptr tuchar))
                                             (Ebinop Oadd
                                               (Evalof (Evar _index tint)
                                                 tint)
                                               (Evalof (Evar _add_ind tuchar)
                                                 tuchar) tint) (tptr tuchar))
                                           tuchar) tuchar) tint) tint tint)))))))))
                (Ssequence
                  (Sdo (Eassign (Evar _filt_ind_y tint)
                         (Eval (Vint (Int.repr 0)) tint) tint))
                  (Ssequence
                    (Ssequence
                      (Sdo (Eassign (Evar _x tint)
                             (Eunop Oneg (Eval (Vint (Int.repr 1)) tint)
                               tint) tint))
                      (Sfor
                        Sskip
                        (Ebinop Ole (Evalof (Evar _x tint) tint)
                          (Eval (Vint (Int.repr 1)) tint) tint)
                        (Sdo (Epostincr Incr (Evar _x tint) tint))
                        (Ssequence
                          (Sdo (Eassign (Evar _y tint)
                                 (Eunop Oneg (Eval (Vint (Int.repr 1)) tint)
                                   tint) tint))
                          (Sfor
                            Sskip
                            (Ebinop Ole (Evalof (Evar _y tint) tint)
                              (Eval (Vint (Int.repr 1)) tint) tint)
                            (Sdo (Epostincr Incr (Evar _y tint) tint))
                            (Ssequence
                              (Sdo (Eassign (Evar _index tint)
                                     (Ebinop Oadd
                                       (Ebinop Omul
                                         (Ebinop Omul
                                           (Ebinop Oadd
                                             (Evalof
                                               (Efield
                                                 (Evalof
                                                   (Ederef
                                                     (Evalof
                                                       (Evar _loc (tptr (Tstruct _point_t noattr)))
                                                       (tptr (Tstruct _point_t noattr)))
                                                     (Tstruct _point_t noattr))
                                                   (Tstruct _point_t noattr))
                                                 _y tuint) tuint)
                                             (Evalof (Evar _y tint) tint)
                                             tuint)
                                           (Evalof
                                             (Efield
                                               (Evalof
                                                 (Ederef
                                                   (Evalof
                                                     (Evar _img (tptr (Tstruct _image_t noattr)))
                                                     (tptr (Tstruct _image_t noattr)))
                                                   (Tstruct _image_t noattr))
                                                 (Tstruct _image_t noattr))
                                               _w tushort) tushort) tuint)
                                         (Evalof (Evar _pixel_width tuchar)
                                           tuchar) tuint)
                                       (Ebinop Omul
                                         (Ebinop Oadd
                                           (Evalof
                                             (Efield
                                               (Evalof
                                                 (Ederef
                                                   (Evalof
                                                     (Evar _loc (tptr (Tstruct _point_t noattr)))
                                                     (tptr (Tstruct _point_t noattr)))
                                                   (Tstruct _point_t noattr))
                                                 (Tstruct _point_t noattr))
                                               _x tuint) tuint)
                                           (Evalof (Evar _x tint) tint)
                                           tuint)
                                         (Evalof (Evar _pixel_width tuchar)
                                           tuchar) tuint) tuint) tint))
                              (Ssequence
                                (Sifthenelse (Ebinop One
                                               (Evalof (Evar _x tint) tint)
                                               (Eval (Vint (Int.repr 0)) tint)
                                               tint)
                                  (Ssequence
                                    (Sdo (Eassign (Evar _filt_ind_x tint)
                                           (Ebinop Oadd
                                             (Ebinop Omod
                                               (Ebinop Oadd
                                                 (Evalof (Evar _x tint) tint)
                                                 (Eval (Vint (Int.repr 1)) tint)
                                                 tint)
                                               (Eval (Vint (Int.repr 3)) tint)
                                               tint)
                                             (Ebinop Omul
                                               (Ebinop Oadd
                                                 (Evalof (Evar _y tint) tint)
                                                 (Eval (Vint (Int.repr 1)) tint)
                                                 tint)
                                               (Eval (Vint (Int.repr 3)) tint)
                                               tint) tint) tint))
                                    (Sdo (Eassignop Oadd
                                           (Evar _gradient_x tint)
                                           (Ebinop Omul
                                             (Evalof
                                               (Ederef
                                                 (Ebinop Oadd
                                                   (Evalof
                                                     (Evar _Sobel (tarray tint 9))
                                                     (tarray tint 9))
                                                   (Evalof
                                                     (Evar _filt_ind_x tint)
                                                     tint) (tptr tint)) tint)
                                               tint)
                                             (Ecast
                                               (Evalof
                                                 (Ederef
                                                   (Ebinop Oadd
                                                     (Evalof
                                                       (Evar _img_buf (tptr tuchar))
                                                       (tptr tuchar))
                                                     (Ebinop Oadd
                                                       (Evalof
                                                         (Evar _index tint)
                                                         tint)
                                                       (Evalof
                                                         (Evar _add_ind tuchar)
                                                         tuchar) tint)
                                                     (tptr tuchar)) tuchar)
                                                 tuchar) tint) tint)
                                           tint tint)))
                                  Sskip)
                                (Ssequence
                                  (Sifthenelse (Ebinop One
                                                 (Evalof (Evar _y tint) tint)
                                                 (Eval (Vint (Int.repr 0)) tint)
                                                 tint)
                                    (Sdo (Eassignop Oadd
                                           (Evar _gradient_y tint)
                                           (Ebinop Omul
                                             (Evalof
                                               (Ederef
                                                 (Ebinop Oadd
                                                   (Evalof
                                                     (Evar _Sobel (tarray tint 9))
                                                     (tarray tint 9))
                                                   (Evalof
                                                     (Evar _filt_ind_y tint)
                                                     tint) (tptr tint)) tint)
                                               tint)
                                             (Ecast
                                               (Evalof
                                                 (Ederef
                                                   (Ebinop Oadd
                                                     (Evalof
                                                       (Evar _img_buf (tptr tuchar))
                                                       (tptr tuchar))
                                                     (Ebinop Oadd
                                                       (Evalof
                                                         (Evar _index tint)
                                                         tint)
                                                       (Evalof
                                                         (Evar _add_ind tuchar)
                                                         tuchar) tint)
                                                     (tptr tuchar)) tuchar)
                                                 tuchar) tint) tint)
                                           tint tint))
                                    Sskip)
                                  (Sdo (Epostincr Incr
                                         (Evar _filt_ind_y tint) tint)))))))))
                    (Sdo (Eassignop Odiv (Evar _gradient_x tint)
                           (Evalof (Evar _total_sobel tint) tint) tint tint)))))
              Sskip)
            (Ssequence
              (Sdo (Eassign
                     (Ederef (Evalof (Evar _dx (tptr tint)) (tptr tint))
                       tint) (Evalof (Evar _gradient_x tint) tint) tint))
              (Sdo (Eassign
                     (Ederef (Evalof (Evar _dy (tptr tint)) (tptr tint))
                       tint) (Evalof (Evar _gradient_y tint) tint) tint)))))))))
|}.

Definition f_image_draw_rectangle := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_img, (tptr (Tstruct _image_t noattr))) :: (_x_min, tint) ::
                (_x_max, tint) :: (_y_min, tint) :: (_y_max, tint) ::
                (_color__1, (tptr tuchar)) :: nil);
  fn_vars := ((_from, (Tstruct _point_t noattr)) ::
              (_to, (Tstruct _point_t noattr)) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Eassign
         (Efield
           (Evalof (Evar _from (Tstruct _point_t noattr))
             (Tstruct _point_t noattr)) _x tuint)
         (Evalof (Evar _x_min tint) tint) tuint))
  (Ssequence
    (Sdo (Eassign
           (Efield
             (Evalof (Evar _from (Tstruct _point_t noattr))
               (Tstruct _point_t noattr)) _y tuint)
           (Evalof (Evar _y_min tint) tint) tuint))
    (Ssequence
      (Sdo (Eassign
             (Efield
               (Evalof (Evar _to (Tstruct _point_t noattr))
                 (Tstruct _point_t noattr)) _x tuint)
             (Evalof (Evar _x_max tint) tint) tuint))
      (Ssequence
        (Sdo (Eassign
               (Efield
                 (Evalof (Evar _to (Tstruct _point_t noattr))
                   (Tstruct _point_t noattr)) _y tuint)
               (Evalof (Evar _y_min tint) tint) tuint))
        (Ssequence
          (Sdo (Ecall
                 (Evalof
                   (Evar _image_draw_line_color (Tfunction
                                                  ((tptr (Tstruct _image_t noattr)) ::
                                                   (tptr (Tstruct _point_t noattr)) ::
                                                   (tptr (Tstruct _point_t noattr)) ::
                                                   (tptr tuchar) :: nil)
                                                  tvoid cc_default))
                   (Tfunction
                     ((tptr (Tstruct _image_t noattr)) ::
                      (tptr (Tstruct _point_t noattr)) ::
                      (tptr (Tstruct _point_t noattr)) :: (tptr tuchar) ::
                      nil) tvoid cc_default))
                 (Econs
                   (Evalof (Evar _img (tptr (Tstruct _image_t noattr)))
                     (tptr (Tstruct _image_t noattr)))
                   (Econs
                     (Eaddrof (Evar _from (Tstruct _point_t noattr))
                       (tptr (Tstruct _point_t noattr)))
                     (Econs
                       (Eaddrof (Evar _to (Tstruct _point_t noattr))
                         (tptr (Tstruct _point_t noattr)))
                       (Econs
                         (Evalof (Evar _color__1 (tptr tuchar))
                           (tptr tuchar)) Enil)))) tvoid))
          (Ssequence
            (Sdo (Eassign
                   (Efield
                     (Evalof (Evar _from (Tstruct _point_t noattr))
                       (Tstruct _point_t noattr)) _x tuint)
                   (Evalof (Evar _x_max tint) tint) tuint))
            (Ssequence
              (Sdo (Eassign
                     (Efield
                       (Evalof (Evar _from (Tstruct _point_t noattr))
                         (Tstruct _point_t noattr)) _y tuint)
                     (Evalof (Evar _y_min tint) tint) tuint))
              (Ssequence
                (Sdo (Eassign
                       (Efield
                         (Evalof (Evar _to (Tstruct _point_t noattr))
                           (Tstruct _point_t noattr)) _x tuint)
                       (Evalof (Evar _x_max tint) tint) tuint))
                (Ssequence
                  (Sdo (Eassign
                         (Efield
                           (Evalof (Evar _to (Tstruct _point_t noattr))
                             (Tstruct _point_t noattr)) _y tuint)
                         (Evalof (Evar _y_max tint) tint) tuint))
                  (Ssequence
                    (Sdo (Ecall
                           (Evalof
                             (Evar _image_draw_line_color (Tfunction
                                                            ((tptr (Tstruct _image_t noattr)) ::
                                                             (tptr (Tstruct _point_t noattr)) ::
                                                             (tptr (Tstruct _point_t noattr)) ::
                                                             (tptr tuchar) ::
                                                             nil) tvoid
                                                            cc_default))
                             (Tfunction
                               ((tptr (Tstruct _image_t noattr)) ::
                                (tptr (Tstruct _point_t noattr)) ::
                                (tptr (Tstruct _point_t noattr)) ::
                                (tptr tuchar) :: nil) tvoid cc_default))
                           (Econs
                             (Evalof
                               (Evar _img (tptr (Tstruct _image_t noattr)))
                               (tptr (Tstruct _image_t noattr)))
                             (Econs
                               (Eaddrof
                                 (Evar _from (Tstruct _point_t noattr))
                                 (tptr (Tstruct _point_t noattr)))
                               (Econs
                                 (Eaddrof
                                   (Evar _to (Tstruct _point_t noattr))
                                   (tptr (Tstruct _point_t noattr)))
                                 (Econs
                                   (Evalof (Evar _color__1 (tptr tuchar))
                                     (tptr tuchar)) Enil)))) tvoid))
                    (Ssequence
                      (Sdo (Eassign
                             (Efield
                               (Evalof (Evar _from (Tstruct _point_t noattr))
                                 (Tstruct _point_t noattr)) _x tuint)
                             (Evalof (Evar _x_max tint) tint) tuint))
                      (Ssequence
                        (Sdo (Eassign
                               (Efield
                                 (Evalof
                                   (Evar _from (Tstruct _point_t noattr))
                                   (Tstruct _point_t noattr)) _y tuint)
                               (Evalof (Evar _y_max tint) tint) tuint))
                        (Ssequence
                          (Sdo (Eassign
                                 (Efield
                                   (Evalof
                                     (Evar _to (Tstruct _point_t noattr))
                                     (Tstruct _point_t noattr)) _x tuint)
                                 (Evalof (Evar _x_min tint) tint) tuint))
                          (Ssequence
                            (Sdo (Eassign
                                   (Efield
                                     (Evalof
                                       (Evar _to (Tstruct _point_t noattr))
                                       (Tstruct _point_t noattr)) _y tuint)
                                   (Evalof (Evar _y_max tint) tint) tuint))
                            (Ssequence
                              (Sdo (Ecall
                                     (Evalof
                                       (Evar _image_draw_line_color (Tfunction
                                                                    ((tptr (Tstruct _image_t noattr)) ::
                                                                    (tptr (Tstruct _point_t noattr)) ::
                                                                    (tptr (Tstruct _point_t noattr)) ::
                                                                    (tptr tuchar) ::
                                                                    nil)
                                                                    tvoid
                                                                    cc_default))
                                       (Tfunction
                                         ((tptr (Tstruct _image_t noattr)) ::
                                          (tptr (Tstruct _point_t noattr)) ::
                                          (tptr (Tstruct _point_t noattr)) ::
                                          (tptr tuchar) :: nil) tvoid
                                         cc_default))
                                     (Econs
                                       (Evalof
                                         (Evar _img (tptr (Tstruct _image_t noattr)))
                                         (tptr (Tstruct _image_t noattr)))
                                       (Econs
                                         (Eaddrof
                                           (Evar _from (Tstruct _point_t noattr))
                                           (tptr (Tstruct _point_t noattr)))
                                         (Econs
                                           (Eaddrof
                                             (Evar _to (Tstruct _point_t noattr))
                                             (tptr (Tstruct _point_t noattr)))
                                           (Econs
                                             (Evalof
                                               (Evar _color__1 (tptr tuchar))
                                               (tptr tuchar)) Enil)))) tvoid))
                              (Ssequence
                                (Sdo (Eassign
                                       (Efield
                                         (Evalof
                                           (Evar _from (Tstruct _point_t noattr))
                                           (Tstruct _point_t noattr)) _x
                                         tuint)
                                       (Evalof (Evar _x_min tint) tint)
                                       tuint))
                                (Ssequence
                                  (Sdo (Eassign
                                         (Efield
                                           (Evalof
                                             (Evar _from (Tstruct _point_t noattr))
                                             (Tstruct _point_t noattr)) _y
                                           tuint)
                                         (Evalof (Evar _y_max tint) tint)
                                         tuint))
                                  (Ssequence
                                    (Sdo (Eassign
                                           (Efield
                                             (Evalof
                                               (Evar _to (Tstruct _point_t noattr))
                                               (Tstruct _point_t noattr)) _x
                                             tuint)
                                           (Evalof (Evar _x_min tint) tint)
                                           tuint))
                                    (Ssequence
                                      (Sdo (Eassign
                                             (Efield
                                               (Evalof
                                                 (Evar _to (Tstruct _point_t noattr))
                                                 (Tstruct _point_t noattr))
                                               _y tuint)
                                             (Evalof (Evar _y_min tint) tint)
                                             tuint))
                                      (Sdo (Ecall
                                             (Evalof
                                               (Evar _image_draw_line_color 
                                               (Tfunction
                                                 ((tptr (Tstruct _image_t noattr)) ::
                                                  (tptr (Tstruct _point_t noattr)) ::
                                                  (tptr (Tstruct _point_t noattr)) ::
                                                  (tptr tuchar) :: nil) tvoid
                                                 cc_default))
                                               (Tfunction
                                                 ((tptr (Tstruct _image_t noattr)) ::
                                                  (tptr (Tstruct _point_t noattr)) ::
                                                  (tptr (Tstruct _point_t noattr)) ::
                                                  (tptr tuchar) :: nil) tvoid
                                                 cc_default))
                                             (Econs
                                               (Evalof
                                                 (Evar _img (tptr (Tstruct _image_t noattr)))
                                                 (tptr (Tstruct _image_t noattr)))
                                               (Econs
                                                 (Eaddrof
                                                   (Evar _from (Tstruct _point_t noattr))
                                                   (tptr (Tstruct _point_t noattr)))
                                                 (Econs
                                                   (Eaddrof
                                                     (Evar _to (Tstruct _point_t noattr))
                                                     (tptr (Tstruct _point_t noattr)))
                                                   (Econs
                                                     (Evalof
                                                       (Evar _color__1 (tptr tuchar))
                                                       (tptr tuchar)) Enil))))
                                             tvoid)))))))))))))))))))))
|}.

Definition f_image_draw_crosshair := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_img, (tptr (Tstruct _image_t noattr))) ::
                (_loc, (tptr (Tstruct _point_t noattr))) ::
                (_color__1, (tptr tuchar)) :: (_size_crosshair__1, tuint) ::
                nil);
  fn_vars := ((_from, (Tstruct _point_t noattr)) ::
              (_to, (Tstruct _point_t noattr)) :: nil);
  fn_body :=
(Sifthenelse (Eseqand
               (Eseqand
                 (Eseqand
                   (Ebinop Oge
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _loc (tptr (Tstruct _point_t noattr)))
                               (tptr (Tstruct _point_t noattr)))
                             (Tstruct _point_t noattr))
                           (Tstruct _point_t noattr)) _x tuint) tuint)
                     (Evalof (Evar _size_crosshair__1 tuint) tuint) tint)
                   (Ebinop Olt
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _loc (tptr (Tstruct _point_t noattr)))
                               (tptr (Tstruct _point_t noattr)))
                             (Tstruct _point_t noattr))
                           (Tstruct _point_t noattr)) _x tuint) tuint)
                     (Ebinop Osub
                       (Evalof
                         (Efield
                           (Evalof
                             (Ederef
                               (Evalof
                                 (Evar _img (tptr (Tstruct _image_t noattr)))
                                 (tptr (Tstruct _image_t noattr)))
                               (Tstruct _image_t noattr))
                             (Tstruct _image_t noattr)) _w tushort) tushort)
                       (Evalof (Evar _size_crosshair__1 tuint) tuint) tuint)
                     tint) tint)
                 (Ebinop Oge
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _loc (tptr (Tstruct _point_t noattr)))
                             (tptr (Tstruct _point_t noattr)))
                           (Tstruct _point_t noattr))
                         (Tstruct _point_t noattr)) _y tuint) tuint)
                   (Evalof (Evar _size_crosshair__1 tuint) tuint) tint) tint)
               (Ebinop Olt
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof (Evar _loc (tptr (Tstruct _point_t noattr)))
                           (tptr (Tstruct _point_t noattr)))
                         (Tstruct _point_t noattr))
                       (Tstruct _point_t noattr)) _y tuint) tuint)
                 (Ebinop Osub
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _img (tptr (Tstruct _image_t noattr)))
                             (tptr (Tstruct _image_t noattr)))
                           (Tstruct _image_t noattr))
                         (Tstruct _image_t noattr)) _h tushort) tushort)
                   (Evalof (Evar _size_crosshair__1 tuint) tuint) tuint)
                 tint) tint)
  (Ssequence
    (Sdo (Eassign
           (Efield
             (Evalof (Evar _from (Tstruct _point_t noattr))
               (Tstruct _point_t noattr)) _x tuint)
           (Ebinop Osub
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _loc (tptr (Tstruct _point_t noattr)))
                       (tptr (Tstruct _point_t noattr)))
                     (Tstruct _point_t noattr)) (Tstruct _point_t noattr)) _x
                 tuint) tuint) (Evalof (Evar _size_crosshair__1 tuint) tuint)
             tuint) tuint))
    (Ssequence
      (Sdo (Eassign
             (Efield
               (Evalof (Evar _from (Tstruct _point_t noattr))
                 (Tstruct _point_t noattr)) _y tuint)
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _loc (tptr (Tstruct _point_t noattr)))
                       (tptr (Tstruct _point_t noattr)))
                     (Tstruct _point_t noattr)) (Tstruct _point_t noattr)) _y
                 tuint) tuint) tuint))
      (Ssequence
        (Sdo (Eassign
               (Efield
                 (Evalof (Evar _to (Tstruct _point_t noattr))
                   (Tstruct _point_t noattr)) _x tuint)
               (Ebinop Oadd
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof (Evar _loc (tptr (Tstruct _point_t noattr)))
                           (tptr (Tstruct _point_t noattr)))
                         (Tstruct _point_t noattr))
                       (Tstruct _point_t noattr)) _x tuint) tuint)
                 (Evalof (Evar _size_crosshair__1 tuint) tuint) tuint) tuint))
        (Ssequence
          (Sdo (Eassign
                 (Efield
                   (Evalof (Evar _to (Tstruct _point_t noattr))
                     (Tstruct _point_t noattr)) _y tuint)
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof (Evar _loc (tptr (Tstruct _point_t noattr)))
                           (tptr (Tstruct _point_t noattr)))
                         (Tstruct _point_t noattr))
                       (Tstruct _point_t noattr)) _y tuint) tuint) tuint))
          (Ssequence
            (Sdo (Ecall
                   (Evalof
                     (Evar _image_draw_line_color (Tfunction
                                                    ((tptr (Tstruct _image_t noattr)) ::
                                                     (tptr (Tstruct _point_t noattr)) ::
                                                     (tptr (Tstruct _point_t noattr)) ::
                                                     (tptr tuchar) :: nil)
                                                    tvoid cc_default))
                     (Tfunction
                       ((tptr (Tstruct _image_t noattr)) ::
                        (tptr (Tstruct _point_t noattr)) ::
                        (tptr (Tstruct _point_t noattr)) :: (tptr tuchar) ::
                        nil) tvoid cc_default))
                   (Econs
                     (Evalof (Evar _img (tptr (Tstruct _image_t noattr)))
                       (tptr (Tstruct _image_t noattr)))
                     (Econs
                       (Eaddrof (Evar _from (Tstruct _point_t noattr))
                         (tptr (Tstruct _point_t noattr)))
                       (Econs
                         (Eaddrof (Evar _to (Tstruct _point_t noattr))
                           (tptr (Tstruct _point_t noattr)))
                         (Econs
                           (Evalof (Evar _color__1 (tptr tuchar))
                             (tptr tuchar)) Enil)))) tvoid))
            (Ssequence
              (Sdo (Eassign
                     (Efield
                       (Evalof (Evar _from (Tstruct _point_t noattr))
                         (Tstruct _point_t noattr)) _x tuint)
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _loc (tptr (Tstruct _point_t noattr)))
                               (tptr (Tstruct _point_t noattr)))
                             (Tstruct _point_t noattr))
                           (Tstruct _point_t noattr)) _x tuint) tuint) tuint))
              (Ssequence
                (Sdo (Eassign
                       (Efield
                         (Evalof (Evar _from (Tstruct _point_t noattr))
                           (Tstruct _point_t noattr)) _y tuint)
                       (Ebinop Osub
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _loc (tptr (Tstruct _point_t noattr)))
                                   (tptr (Tstruct _point_t noattr)))
                                 (Tstruct _point_t noattr))
                               (Tstruct _point_t noattr)) _y tuint) tuint)
                         (Evalof (Evar _size_crosshair__1 tuint) tuint)
                         tuint) tuint))
                (Ssequence
                  (Sdo (Eassign
                         (Efield
                           (Evalof (Evar _to (Tstruct _point_t noattr))
                             (Tstruct _point_t noattr)) _x tuint)
                         (Evalof
                           (Efield
                             (Evalof
                               (Ederef
                                 (Evalof
                                   (Evar _loc (tptr (Tstruct _point_t noattr)))
                                   (tptr (Tstruct _point_t noattr)))
                                 (Tstruct _point_t noattr))
                               (Tstruct _point_t noattr)) _x tuint) tuint)
                         tuint))
                  (Ssequence
                    (Sdo (Eassign
                           (Efield
                             (Evalof (Evar _to (Tstruct _point_t noattr))
                               (Tstruct _point_t noattr)) _y tuint)
                           (Ebinop Oadd
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _loc (tptr (Tstruct _point_t noattr)))
                                       (tptr (Tstruct _point_t noattr)))
                                     (Tstruct _point_t noattr))
                                   (Tstruct _point_t noattr)) _y tuint)
                               tuint)
                             (Evalof (Evar _size_crosshair__1 tuint) tuint)
                             tuint) tuint))
                    (Sdo (Ecall
                           (Evalof
                             (Evar _image_draw_line_color (Tfunction
                                                            ((tptr (Tstruct _image_t noattr)) ::
                                                             (tptr (Tstruct _point_t noattr)) ::
                                                             (tptr (Tstruct _point_t noattr)) ::
                                                             (tptr tuchar) ::
                                                             nil) tvoid
                                                            cc_default))
                             (Tfunction
                               ((tptr (Tstruct _image_t noattr)) ::
                                (tptr (Tstruct _point_t noattr)) ::
                                (tptr (Tstruct _point_t noattr)) ::
                                (tptr tuchar) :: nil) tvoid cc_default))
                           (Econs
                             (Evalof
                               (Evar _img (tptr (Tstruct _image_t noattr)))
                               (tptr (Tstruct _image_t noattr)))
                             (Econs
                               (Eaddrof
                                 (Evar _from (Tstruct _point_t noattr))
                                 (tptr (Tstruct _point_t noattr)))
                               (Econs
                                 (Eaddrof
                                   (Evar _to (Tstruct _point_t noattr))
                                   (tptr (Tstruct _point_t noattr)))
                                 (Econs
                                   (Evalof (Evar _color__1 (tptr tuchar))
                                     (tptr tuchar)) Enil)))) tvoid)))))))))))
  Sskip)
|}.

Definition v_color__1 := {|
  gvar_info := (tarray tuchar 4);
  gvar_init := (Init_int8 (Int.repr 255) :: Init_int8 (Int.repr 255) ::
                Init_int8 (Int.repr 255) :: Init_int8 (Int.repr 255) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition f_image_draw_line := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_img, (tptr (Tstruct _image_t noattr))) ::
                (_from, (tptr (Tstruct _point_t noattr))) ::
                (_to, (tptr (Tstruct _point_t noattr))) :: nil);
  fn_vars := nil;
  fn_body :=
(Sdo (Ecall
       (Evalof
         (Evar _image_draw_line_color (Tfunction
                                        ((tptr (Tstruct _image_t noattr)) ::
                                         (tptr (Tstruct _point_t noattr)) ::
                                         (tptr (Tstruct _point_t noattr)) ::
                                         (tptr tuchar) :: nil) tvoid
                                        cc_default))
         (Tfunction
           ((tptr (Tstruct _image_t noattr)) ::
            (tptr (Tstruct _point_t noattr)) ::
            (tptr (Tstruct _point_t noattr)) :: (tptr tuchar) :: nil) tvoid
           cc_default))
       (Econs
         (Evalof (Evar _img (tptr (Tstruct _image_t noattr)))
           (tptr (Tstruct _image_t noattr)))
         (Econs
           (Evalof (Evar _from (tptr (Tstruct _point_t noattr)))
             (tptr (Tstruct _point_t noattr)))
           (Econs
             (Evalof (Evar _to (tptr (Tstruct _point_t noattr)))
               (tptr (Tstruct _point_t noattr)))
             (Econs
               (Evalof (Evar _color__1 (tarray tuchar 4)) (tarray tuchar 4))
               Enil)))) tvoid))
|}.

Definition f_image_draw_line_color := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_img, (tptr (Tstruct _image_t noattr))) ::
                (_from, (tptr (Tstruct _point_t noattr))) ::
                (_to, (tptr (Tstruct _point_t noattr))) ::
                (_color__2, (tptr tuchar)) :: nil);
  fn_vars := ((_xerr, tint) :: (_yerr, tint) :: (_img_buf, (tptr tuchar)) ::
              (_pixel_width, tuchar) :: (_startx, tushort) ::
              (_starty, tushort) :: (_temp_color, (tarray tuchar 4)) ::
              (_delta_x, tint) :: (_delta_y, tint) :: (_incx, tschar) ::
              (_incy, tschar) :: (_distance, tushort) :: (_t, tushort) ::
              (_buf_loc, tuint) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Eassign (Evar _xerr tint) (Eval (Vint (Int.repr 0)) tint) tint))
  (Ssequence
    (Sdo (Eassign (Evar _yerr tint) (Eval (Vint (Int.repr 0)) tint) tint))
    (Ssequence
      (Sdo (Eassign (Evar _img_buf (tptr tuchar))
             (Ecast
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _img (tptr (Tstruct _image_t noattr)))
                         (tptr (Tstruct _image_t noattr)))
                       (Tstruct _image_t noattr)) (Tstruct _image_t noattr))
                   _buf (tptr tvoid)) (tptr tvoid)) (tptr tuchar))
             (tptr tuchar)))
      (Ssequence
        (Sdo (Eassign (Evar _pixel_width tuchar)
               (Econdition
                 (Ebinop Oeq
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _img (tptr (Tstruct _image_t noattr)))
                             (tptr (Tstruct _image_t noattr)))
                           (Tstruct _image_t noattr))
                         (Tstruct _image_t noattr)) _type tint) tint)
                   (Eval (Vint (Int.repr 0)) tint) tint)
                 (Eval (Vint (Int.repr 2)) tint)
                 (Eval (Vint (Int.repr 1)) tint) tint) tuchar))
        (Ssequence
          (Sdo (Eassign (Evar _startx tushort)
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _from (tptr (Tstruct _point_t noattr)))
                           (tptr (Tstruct _point_t noattr)))
                         (Tstruct _point_t noattr))
                       (Tstruct _point_t noattr)) _x tuint) tuint) tushort))
          (Ssequence
            (Sdo (Eassign (Evar _starty tushort)
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _from (tptr (Tstruct _point_t noattr)))
                             (tptr (Tstruct _point_t noattr)))
                           (Tstruct _point_t noattr))
                         (Tstruct _point_t noattr)) _y tuint) tuint) tushort))
            (Ssequence
              (Sdo (Eassign
                     (Ederef
                       (Ebinop Oadd
                         (Evalof (Evar _temp_color (tarray tuchar 4))
                           (tarray tuchar 4)) (Eval (Vint (Int.repr 0)) tint)
                         (tptr tuchar)) tuchar)
                     (Evalof
                       (Ederef
                         (Ebinop Oadd
                           (Evalof (Evar _color__2 (tptr tuchar))
                             (tptr tuchar)) (Eval (Vint (Int.repr 0)) tint)
                           (tptr tuchar)) tuchar) tuchar) tuchar))
              (Ssequence
                (Sdo (Eassign
                       (Ederef
                         (Ebinop Oadd
                           (Evalof (Evar _temp_color (tarray tuchar 4))
                             (tarray tuchar 4))
                           (Eval (Vint (Int.repr 1)) tint) (tptr tuchar))
                         tuchar)
                       (Evalof
                         (Ederef
                           (Ebinop Oadd
                             (Evalof (Evar _color__2 (tptr tuchar))
                               (tptr tuchar)) (Eval (Vint (Int.repr 1)) tint)
                             (tptr tuchar)) tuchar) tuchar) tuchar))
                (Ssequence
                  (Sdo (Eassign
                         (Ederef
                           (Ebinop Oadd
                             (Evalof (Evar _temp_color (tarray tuchar 4))
                               (tarray tuchar 4))
                             (Eval (Vint (Int.repr 2)) tint) (tptr tuchar))
                           tuchar)
                         (Evalof
                           (Ederef
                             (Ebinop Oadd
                               (Evalof (Evar _color__2 (tptr tuchar))
                                 (tptr tuchar))
                               (Eval (Vint (Int.repr 2)) tint) (tptr tuchar))
                             tuchar) tuchar) tuchar))
                  (Ssequence
                    (Sdo (Eassign
                           (Ederef
                             (Ebinop Oadd
                               (Evalof (Evar _temp_color (tarray tuchar 4))
                                 (tarray tuchar 4))
                               (Eval (Vint (Int.repr 3)) tint) (tptr tuchar))
                             tuchar)
                           (Evalof
                             (Ederef
                               (Ebinop Oadd
                                 (Evalof (Evar _color__2 (tptr tuchar))
                                   (tptr tuchar))
                                 (Eval (Vint (Int.repr 3)) tint)
                                 (tptr tuchar)) tuchar) tuchar) tuchar))
                    (Ssequence
                      (Sdo (Eassign (Evar _delta_x tint)
                             (Ebinop Osub
                               (Evalof
                                 (Efield
                                   (Evalof
                                     (Ederef
                                       (Evalof
                                         (Evar _to (tptr (Tstruct _point_t noattr)))
                                         (tptr (Tstruct _point_t noattr)))
                                       (Tstruct _point_t noattr))
                                     (Tstruct _point_t noattr)) _x tuint)
                                 tuint)
                               (Evalof
                                 (Efield
                                   (Evalof
                                     (Ederef
                                       (Evalof
                                         (Evar _from (tptr (Tstruct _point_t noattr)))
                                         (tptr (Tstruct _point_t noattr)))
                                       (Tstruct _point_t noattr))
                                     (Tstruct _point_t noattr)) _x tuint)
                                 tuint) tuint) tint))
                      (Ssequence
                        (Sdo (Eassign (Evar _delta_y tint)
                               (Ebinop Osub
                                 (Evalof
                                   (Efield
                                     (Evalof
                                       (Ederef
                                         (Evalof
                                           (Evar _to (tptr (Tstruct _point_t noattr)))
                                           (tptr (Tstruct _point_t noattr)))
                                         (Tstruct _point_t noattr))
                                       (Tstruct _point_t noattr)) _y tuint)
                                   tuint)
                                 (Evalof
                                   (Efield
                                     (Evalof
                                       (Ederef
                                         (Evalof
                                           (Evar _from (tptr (Tstruct _point_t noattr)))
                                           (tptr (Tstruct _point_t noattr)))
                                         (Tstruct _point_t noattr))
                                       (Tstruct _point_t noattr)) _y tuint)
                                   tuint) tuint) tint))
                        (Ssequence
                          (Sifthenelse (Ebinop Ogt
                                         (Evalof (Evar _delta_x tint) tint)
                                         (Eval (Vint (Int.repr 0)) tint)
                                         tint)
                            (Sdo (Eassign (Evar _incx tschar)
                                   (Eval (Vint (Int.repr 1)) tint) tschar))
                            (Sifthenelse (Ebinop Oeq
                                           (Evalof (Evar _delta_x tint) tint)
                                           (Eval (Vint (Int.repr 0)) tint)
                                           tint)
                              (Sdo (Eassign (Evar _incx tschar)
                                     (Eval (Vint (Int.repr 0)) tint) tschar))
                              (Sdo (Eassign (Evar _incx tschar)
                                     (Eunop Oneg
                                       (Eval (Vint (Int.repr 1)) tint) tint)
                                     tschar))))
                          (Ssequence
                            (Sifthenelse (Ebinop Ogt
                                           (Evalof (Evar _delta_y tint) tint)
                                           (Eval (Vint (Int.repr 0)) tint)
                                           tint)
                              (Sdo (Eassign (Evar _incy tschar)
                                     (Eval (Vint (Int.repr 1)) tint) tschar))
                              (Sifthenelse (Ebinop Oeq
                                             (Evalof (Evar _delta_y tint)
                                               tint)
                                             (Eval (Vint (Int.repr 0)) tint)
                                             tint)
                                (Sdo (Eassign (Evar _incy tschar)
                                       (Eval (Vint (Int.repr 0)) tint)
                                       tschar))
                                (Sdo (Eassign (Evar _incy tschar)
                                       (Eunop Oneg
                                         (Eval (Vint (Int.repr 1)) tint)
                                         tint) tschar))))
                            (Ssequence
                              (Sdo (Eassign (Evar _distance tushort)
                                     (Eval (Vint (Int.repr 0)) tint) tushort))
                              (Ssequence
                                (Sdo (Eassign (Evar _delta_x tint)
                                       (Ecall
                                         (Evalof
                                           (Evar _abs (Tfunction
                                                        (tint :: nil) tint
                                                        cc_default))
                                           (Tfunction (tint :: nil) tint
                                             cc_default))
                                         (Econs
                                           (Evalof (Evar _delta_x tint) tint)
                                           Enil) tint) tint))
                                (Ssequence
                                  (Sdo (Eassign (Evar _delta_y tint)
                                         (Ecall
                                           (Evalof
                                             (Evar _abs (Tfunction
                                                          (tint :: nil) tint
                                                          cc_default))
                                             (Tfunction (tint :: nil) tint
                                               cc_default))
                                           (Econs
                                             (Evalof (Evar _delta_y tint)
                                               tint) Enil) tint) tint))
                                  (Ssequence
                                    (Sifthenelse (Ebinop Ogt
                                                   (Evalof
                                                     (Evar _delta_x tint)
                                                     tint)
                                                   (Evalof
                                                     (Evar _delta_y tint)
                                                     tint) tint)
                                      (Sdo (Eassign (Evar _distance tushort)
                                             (Ebinop Omul
                                               (Evalof (Evar _delta_x tint)
                                                 tint)
                                               (Eval (Vint (Int.repr 20)) tint)
                                               tint) tushort))
                                      (Sdo (Eassign (Evar _distance tushort)
                                             (Ebinop Omul
                                               (Evalof (Evar _delta_y tint)
                                                 tint)
                                               (Eval (Vint (Int.repr 20)) tint)
                                               tint) tushort)))
                                    (Ssequence
                                      (Sdo (Eassign (Evar _t tushort)
                                             (Eval (Vint (Int.repr 0)) tint)
                                             tushort))
                                      (Sfor
                                        Sskip
                                        (Eseqand
                                          (Eseqand
                                            (Ebinop Olt
                                              (Evalof (Evar _starty tushort)
                                                tushort)
                                              (Evalof
                                                (Efield
                                                  (Evalof
                                                    (Ederef
                                                      (Evalof
                                                        (Evar _img (tptr (Tstruct _image_t noattr)))
                                                        (tptr (Tstruct _image_t noattr)))
                                                      (Tstruct _image_t noattr))
                                                    (Tstruct _image_t noattr))
                                                  _h tushort) tushort) tint)
                                            (Ebinop Olt
                                              (Evalof (Evar _startx tushort)
                                                tushort)
                                              (Evalof
                                                (Efield
                                                  (Evalof
                                                    (Ederef
                                                      (Evalof
                                                        (Evar _img (tptr (Tstruct _image_t noattr)))
                                                        (tptr (Tstruct _image_t noattr)))
                                                      (Tstruct _image_t noattr))
                                                    (Tstruct _image_t noattr))
                                                  _w tushort) tushort) tint)
                                            tint)
                                          (Ebinop Ole
                                            (Evalof (Evar _t tushort)
                                              tushort)
                                            (Ebinop Oadd
                                              (Evalof
                                                (Evar _distance tushort)
                                                tushort)
                                              (Eval (Vint (Int.repr 1)) tint)
                                              tint) tint) tint)
                                        (Sdo (Epostincr Incr
                                               (Evar _t tushort) tushort))
                                        (Ssequence
                                          (Sifthenelse (Ebinop Oeq
                                                         (Ebinop Omod
                                                           (Evalof
                                                             (Evar _startx tushort)
                                                             tushort)
                                                           (Eval (Vint (Int.repr 2)) tint)
                                                           tint)
                                                         (Eval (Vint (Int.repr 1)) tint)
                                                         tint)
                                            (Ssequence
                                              (Sdo (Eassign
                                                     (Ederef
                                                       (Ebinop Oadd
                                                         (Evalof
                                                           (Evar _temp_color (tarray tuchar 4))
                                                           (tarray tuchar 4))
                                                         (Eval (Vint (Int.repr 0)) tint)
                                                         (tptr tuchar))
                                                       tuchar)
                                                     (Evalof
                                                       (Ederef
                                                         (Ebinop Oadd
                                                           (Evalof
                                                             (Evar _color__2 (tptr tuchar))
                                                             (tptr tuchar))
                                                           (Eval (Vint (Int.repr 2)) tint)
                                                           (tptr tuchar))
                                                         tuchar) tuchar)
                                                     tuchar))
                                              (Sdo (Eassign
                                                     (Ederef
                                                       (Ebinop Oadd
                                                         (Evalof
                                                           (Evar _temp_color (tarray tuchar 4))
                                                           (tarray tuchar 4))
                                                         (Eval (Vint (Int.repr 2)) tint)
                                                         (tptr tuchar))
                                                       tuchar)
                                                     (Evalof
                                                       (Ederef
                                                         (Ebinop Oadd
                                                           (Evalof
                                                             (Evar _color__2 (tptr tuchar))
                                                             (tptr tuchar))
                                                           (Eval (Vint (Int.repr 0)) tint)
                                                           (tptr tuchar))
                                                         tuchar) tuchar)
                                                     tuchar)))
                                            (Ssequence
                                              (Sdo (Eassign
                                                     (Ederef
                                                       (Ebinop Oadd
                                                         (Evalof
                                                           (Evar _temp_color (tarray tuchar 4))
                                                           (tarray tuchar 4))
                                                         (Eval (Vint (Int.repr 0)) tint)
                                                         (tptr tuchar))
                                                       tuchar)
                                                     (Evalof
                                                       (Ederef
                                                         (Ebinop Oadd
                                                           (Evalof
                                                             (Evar _color__2 (tptr tuchar))
                                                             (tptr tuchar))
                                                           (Eval (Vint (Int.repr 0)) tint)
                                                           (tptr tuchar))
                                                         tuchar) tuchar)
                                                     tuchar))
                                              (Sdo (Eassign
                                                     (Ederef
                                                       (Ebinop Oadd
                                                         (Evalof
                                                           (Evar _temp_color (tarray tuchar 4))
                                                           (tarray tuchar 4))
                                                         (Eval (Vint (Int.repr 2)) tint)
                                                         (tptr tuchar))
                                                       tuchar)
                                                     (Evalof
                                                       (Ederef
                                                         (Ebinop Oadd
                                                           (Evalof
                                                             (Evar _color__2 (tptr tuchar))
                                                             (tptr tuchar))
                                                           (Eval (Vint (Int.repr 2)) tint)
                                                           (tptr tuchar))
                                                         tuchar) tuchar)
                                                     tuchar))))
                                          (Ssequence
                                            (Sdo (Eassign
                                                   (Evar _buf_loc tuint)
                                                   (Ebinop Oadd
                                                     (Ebinop Omul
                                                       (Ebinop Omul
                                                         (Evalof
                                                           (Efield
                                                             (Evalof
                                                               (Ederef
                                                                 (Evalof
                                                                   (Evar _img (tptr (Tstruct _image_t noattr)))
                                                                   (tptr (Tstruct _image_t noattr)))
                                                                 (Tstruct _image_t noattr))
                                                               (Tstruct _image_t noattr))
                                                             _w tushort)
                                                           tushort)
                                                         (Evalof
                                                           (Evar _pixel_width tuchar)
                                                           tuchar) tint)
                                                       (Evalof
                                                         (Evar _starty tushort)
                                                         tushort) tint)
                                                     (Ebinop Omul
                                                       (Evalof
                                                         (Evar _startx tushort)
                                                         tushort)
                                                       (Evalof
                                                         (Evar _pixel_width tuchar)
                                                         tuchar) tint) tint)
                                                   tuint))
                                            (Ssequence
                                              (Sdo (Eassign
                                                     (Ederef
                                                       (Ebinop Oadd
                                                         (Evalof
                                                           (Evar _img_buf (tptr tuchar))
                                                           (tptr tuchar))
                                                         (Evalof
                                                           (Evar _buf_loc tuint)
                                                           tuint)
                                                         (tptr tuchar))
                                                       tuchar)
                                                     (Evalof
                                                       (Ederef
                                                         (Ebinop Oadd
                                                           (Evalof
                                                             (Evar _temp_color (tarray tuchar 4))
                                                             (tarray tuchar 4))
                                                           (Eval (Vint (Int.repr 0)) tint)
                                                           (tptr tuchar))
                                                         tuchar) tuchar)
                                                     tuchar))
                                              (Ssequence
                                                (Sifthenelse (Ebinop Oeq
                                                               (Evalof
                                                                 (Efield
                                                                   (Evalof
                                                                    (Ederef
                                                                    (Evalof
                                                                    (Evar _img (tptr (Tstruct _image_t noattr)))
                                                                    (tptr (Tstruct _image_t noattr)))
                                                                    (Tstruct _image_t noattr))
                                                                    (Tstruct _image_t noattr))
                                                                   _type
                                                                   tint)
                                                                 tint)
                                                               (Eval (Vint (Int.repr 0)) tint)
                                                               tint)
                                                  (Ssequence
                                                    (Sdo (Eassign
                                                           (Ederef
                                                             (Ebinop Oadd
                                                               (Evalof
                                                                 (Evar _img_buf (tptr tuchar))
                                                                 (tptr tuchar))
                                                               (Ebinop Oadd
                                                                 (Evalof
                                                                   (Evar _buf_loc tuint)
                                                                   tuint)
                                                                 (Eval (Vint (Int.repr 1)) tint)
                                                                 tuint)
                                                               (tptr tuchar))
                                                             tuchar)
                                                           (Evalof
                                                             (Ederef
                                                               (Ebinop Oadd
                                                                 (Evalof
                                                                   (Evar _temp_color (tarray tuchar 4))
                                                                   (tarray tuchar 4))
                                                                 (Eval (Vint (Int.repr 1)) tint)
                                                                 (tptr tuchar))
                                                               tuchar)
                                                             tuchar) tuchar))
                                                    (Sifthenelse (Ebinop Olt
                                                                   (Ebinop Oadd
                                                                    (Evalof
                                                                    (Evar _startx tushort)
                                                                    tushort)
                                                                    (Eval (Vint (Int.repr 1)) tint)
                                                                    tint)
                                                                   (Evalof
                                                                    (Efield
                                                                    (Evalof
                                                                    (Ederef
                                                                    (Evalof
                                                                    (Evar _img (tptr (Tstruct _image_t noattr)))
                                                                    (tptr (Tstruct _image_t noattr)))
                                                                    (Tstruct _image_t noattr))
                                                                    (Tstruct _image_t noattr))
                                                                    _w
                                                                    tushort)
                                                                    tushort)
                                                                   tint)
                                                      (Ssequence
                                                        (Sdo (Eassign
                                                               (Ederef
                                                                 (Ebinop Oadd
                                                                   (Evalof
                                                                    (Evar _img_buf (tptr tuchar))
                                                                    (tptr tuchar))
                                                                   (Ebinop Oadd
                                                                    (Evalof
                                                                    (Evar _buf_loc tuint)
                                                                    tuint)
                                                                    (Eval (Vint (Int.repr 2)) tint)
                                                                    tuint)
                                                                   (tptr tuchar))
                                                                 tuchar)
                                                               (Evalof
                                                                 (Ederef
                                                                   (Ebinop Oadd
                                                                    (Evalof
                                                                    (Evar _temp_color (tarray tuchar 4))
                                                                    (tarray tuchar 4))
                                                                    (Eval (Vint (Int.repr 2)) tint)
                                                                    (tptr tuchar))
                                                                   tuchar)
                                                                 tuchar)
                                                               tuchar))
                                                        (Sdo (Eassign
                                                               (Ederef
                                                                 (Ebinop Oadd
                                                                   (Evalof
                                                                    (Evar _img_buf (tptr tuchar))
                                                                    (tptr tuchar))
                                                                   (Ebinop Oadd
                                                                    (Evalof
                                                                    (Evar _buf_loc tuint)
                                                                    tuint)
                                                                    (Eval (Vint (Int.repr 3)) tint)
                                                                    tuint)
                                                                   (tptr tuchar))
                                                                 tuchar)
                                                               (Evalof
                                                                 (Ederef
                                                                   (Ebinop Oadd
                                                                    (Evalof
                                                                    (Evar _temp_color (tarray tuchar 4))
                                                                    (tarray tuchar 4))
                                                                    (Eval (Vint (Int.repr 3)) tint)
                                                                    (tptr tuchar))
                                                                   tuchar)
                                                                 tuchar)
                                                               tuchar)))
                                                      Sskip))
                                                  Sskip)
                                                (Ssequence
                                                  (Sdo (Eassignop Oadd
                                                         (Evar _xerr tint)
                                                         (Evalof
                                                           (Evar _delta_x tint)
                                                           tint) tint tint))
                                                  (Ssequence
                                                    (Sdo (Eassignop Oadd
                                                           (Evar _yerr tint)
                                                           (Evalof
                                                             (Evar _delta_y tint)
                                                             tint) tint tint))
                                                    (Ssequence
                                                      (Sifthenelse (Ebinop Ogt
                                                                    (Evalof
                                                                    (Evar _xerr tint)
                                                                    tint)
                                                                    (Evalof
                                                                    (Evar _distance tushort)
                                                                    tushort)
                                                                    tint)
                                                        (Ssequence
                                                          (Sdo (Eassignop
                                                                 Osub
                                                                 (Evar _xerr tint)
                                                                 (Evalof
                                                                   (Evar _distance tushort)
                                                                   tushort)
                                                                 tint tint))
                                                          (Sdo (Eassignop
                                                                 Oadd
                                                                 (Evar _startx tushort)
                                                                 (Evalof
                                                                   (Evar _incx tschar)
                                                                   tschar)
                                                                 tint tushort)))
                                                        Sskip)
                                                      (Sifthenelse (Ebinop Ogt
                                                                    (Evalof
                                                                    (Evar _yerr tint)
                                                                    tint)
                                                                    (Evalof
                                                                    (Evar _distance tushort)
                                                                    tushort)
                                                                    tint)
                                                        (Ssequence
                                                          (Sdo (Eassignop
                                                                 Osub
                                                                 (Evar _yerr tint)
                                                                 (Evalof
                                                                   (Evar _distance tushort)
                                                                   tushort)
                                                                 tint tint))
                                                          (Sdo (Eassignop
                                                                 Oadd
                                                                 (Evar _starty tushort)
                                                                 (Evalof
                                                                   (Evar _incy tschar)
                                                                   tschar)
                                                                 tint tushort)))
                                                        Sskip))))))))))))))))))))))))))))
|}.

Definition f_ker_mul_3x3 := {|
  fn_return := tuchar;
  fn_callconv := cc_default;
  fn_params := ((_source, (tptr tuchar)) :: (_kernel, (tptr tschar)) ::
                (_total, tuchar) :: (_setting, tuchar) :: (_width, tint) ::
                (_YUV, tint) :: nil);
  fn_vars := ((_value, tint) :: (_offset, tint) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Eassign (Evar _offset tint)
         (Ebinop Oadd (Eval (Vint (Int.repr 1)) tint)
           (Evalof (Evar _YUV tint) tint) tint) tint))
  (Ssequence
    (Sswitch (Evalof (Evar _setting tuchar) tuchar)
      (LScons None
        (Ssequence
          (Sdo (Eassign (Evar _value tint)
                 (Ebinop Oadd
                   (Ebinop Oadd
                     (Ebinop Oadd
                       (Ebinop Oadd
                         (Ebinop Oadd
                           (Ebinop Oadd
                             (Ebinop Oadd
                               (Ebinop Oadd
                                 (Ebinop Omul
                                   (Evalof
                                     (Ederef
                                       (Ebinop Osub
                                         (Ebinop Osub
                                           (Evalof
                                             (Evar _source (tptr tuchar))
                                             (tptr tuchar))
                                           (Evalof (Evar _offset tint) tint)
                                           (tptr tuchar))
                                         (Evalof (Evar _width tint) tint)
                                         (tptr tuchar)) tuchar) tuchar)
                                   (Evalof
                                     (Ederef
                                       (Ebinop Oadd
                                         (Evalof (Evar _kernel (tptr tschar))
                                           (tptr tschar))
                                         (Eval (Vint (Int.repr 0)) tint)
                                         (tptr tschar)) tschar) tschar) tint)
                                 (Ebinop Omul
                                   (Evalof
                                     (Ederef
                                       (Ebinop Osub
                                         (Evalof (Evar _source (tptr tuchar))
                                           (tptr tuchar))
                                         (Evalof (Evar _width tint) tint)
                                         (tptr tuchar)) tuchar) tuchar)
                                   (Evalof
                                     (Ederef
                                       (Ebinop Oadd
                                         (Evalof (Evar _kernel (tptr tschar))
                                           (tptr tschar))
                                         (Eval (Vint (Int.repr 1)) tint)
                                         (tptr tschar)) tschar) tschar) tint)
                                 tint)
                               (Ebinop Omul
                                 (Evalof
                                   (Ederef
                                     (Ebinop Osub
                                       (Ebinop Oadd
                                         (Evalof (Evar _source (tptr tuchar))
                                           (tptr tuchar))
                                         (Evalof (Evar _offset tint) tint)
                                         (tptr tuchar))
                                       (Evalof (Evar _width tint) tint)
                                       (tptr tuchar)) tuchar) tuchar)
                                 (Evalof
                                   (Ederef
                                     (Ebinop Oadd
                                       (Evalof (Evar _kernel (tptr tschar))
                                         (tptr tschar))
                                       (Eval (Vint (Int.repr 2)) tint)
                                       (tptr tschar)) tschar) tschar) tint)
                               tint)
                             (Ebinop Omul
                               (Evalof
                                 (Ederef
                                   (Ebinop Osub
                                     (Evalof (Evar _source (tptr tuchar))
                                       (tptr tuchar))
                                     (Evalof (Evar _offset tint) tint)
                                     (tptr tuchar)) tuchar) tuchar)
                               (Evalof
                                 (Ederef
                                   (Ebinop Oadd
                                     (Evalof (Evar _kernel (tptr tschar))
                                       (tptr tschar))
                                     (Eval (Vint (Int.repr 3)) tint)
                                     (tptr tschar)) tschar) tschar) tint)
                             tint)
                           (Ebinop Omul
                             (Evalof
                               (Ederef
                                 (Evalof (Evar _source (tptr tuchar))
                                   (tptr tuchar)) tuchar) tuchar)
                             (Evalof
                               (Ederef
                                 (Ebinop Oadd
                                   (Evalof (Evar _kernel (tptr tschar))
                                     (tptr tschar))
                                   (Eval (Vint (Int.repr 4)) tint)
                                   (tptr tschar)) tschar) tschar) tint) tint)
                         (Ebinop Omul
                           (Evalof
                             (Ederef
                               (Ebinop Oadd
                                 (Evalof (Evar _source (tptr tuchar))
                                   (tptr tuchar))
                                 (Evalof (Evar _offset tint) tint)
                                 (tptr tuchar)) tuchar) tuchar)
                           (Evalof
                             (Ederef
                               (Ebinop Oadd
                                 (Evalof (Evar _kernel (tptr tschar))
                                   (tptr tschar))
                                 (Eval (Vint (Int.repr 5)) tint)
                                 (tptr tschar)) tschar) tschar) tint) tint)
                       (Ebinop Omul
                         (Evalof
                           (Ederef
                             (Ebinop Oadd
                               (Ebinop Osub
                                 (Evalof (Evar _source (tptr tuchar))
                                   (tptr tuchar))
                                 (Evalof (Evar _offset tint) tint)
                                 (tptr tuchar))
                               (Evalof (Evar _width tint) tint)
                               (tptr tuchar)) tuchar) tuchar)
                         (Evalof
                           (Ederef
                             (Ebinop Oadd
                               (Evalof (Evar _kernel (tptr tschar))
                                 (tptr tschar))
                               (Eval (Vint (Int.repr 6)) tint) (tptr tschar))
                             tschar) tschar) tint) tint)
                     (Ebinop Omul
                       (Evalof
                         (Ederef
                           (Ebinop Oadd
                             (Evalof (Evar _source (tptr tuchar))
                               (tptr tuchar))
                             (Evalof (Evar _width tint) tint) (tptr tuchar))
                           tuchar) tuchar)
                       (Evalof
                         (Ederef
                           (Ebinop Oadd
                             (Evalof (Evar _kernel (tptr tschar))
                               (tptr tschar)) (Eval (Vint (Int.repr 7)) tint)
                             (tptr tschar)) tschar) tschar) tint) tint)
                   (Ebinop Omul
                     (Evalof
                       (Ederef
                         (Ebinop Oadd
                           (Ebinop Oadd
                             (Evalof (Evar _source (tptr tuchar))
                               (tptr tuchar))
                             (Evalof (Evar _offset tint) tint) (tptr tuchar))
                           (Evalof (Evar _width tint) tint) (tptr tuchar))
                         tuchar) tuchar)
                     (Evalof
                       (Ederef
                         (Ebinop Oadd
                           (Evalof (Evar _kernel (tptr tschar))
                             (tptr tschar)) (Eval (Vint (Int.repr 8)) tint)
                           (tptr tschar)) tschar) tschar) tint) tint) tint))
          Sbreak)
        (LScons (Some 1)
          (Ssequence
            (Sdo (Eassign (Evar _value tint)
                   (Ebinop Oadd
                     (Ebinop Oadd
                       (Ebinop Oadd
                         (Ebinop Oadd
                           (Ebinop Oadd
                             (Ebinop Omul
                               (Evalof
                                 (Ederef
                                   (Ebinop Osub
                                     (Evalof (Evar _source (tptr tuchar))
                                       (tptr tuchar))
                                     (Evalof (Evar _offset tint) tint)
                                     (tptr tuchar)) tuchar) tuchar)
                               (Evalof
                                 (Ederef
                                   (Ebinop Oadd
                                     (Evalof (Evar _kernel (tptr tschar))
                                       (tptr tschar))
                                     (Eval (Vint (Int.repr 3)) tint)
                                     (tptr tschar)) tschar) tschar) tint)
                             (Ebinop Omul
                               (Evalof
                                 (Ederef
                                   (Evalof (Evar _source (tptr tuchar))
                                     (tptr tuchar)) tuchar) tuchar)
                               (Evalof
                                 (Ederef
                                   (Ebinop Oadd
                                     (Evalof (Evar _kernel (tptr tschar))
                                       (tptr tschar))
                                     (Eval (Vint (Int.repr 4)) tint)
                                     (tptr tschar)) tschar) tschar) tint)
                             tint)
                           (Ebinop Omul
                             (Evalof
                               (Ederef
                                 (Ebinop Oadd
                                   (Evalof (Evar _source (tptr tuchar))
                                     (tptr tuchar))
                                   (Evalof (Evar _offset tint) tint)
                                   (tptr tuchar)) tuchar) tuchar)
                             (Evalof
                               (Ederef
                                 (Ebinop Oadd
                                   (Evalof (Evar _kernel (tptr tschar))
                                     (tptr tschar))
                                   (Eval (Vint (Int.repr 5)) tint)
                                   (tptr tschar)) tschar) tschar) tint) tint)
                         (Ebinop Omul
                           (Evalof
                             (Ederef
                               (Ebinop Oadd
                                 (Ebinop Osub
                                   (Evalof (Evar _source (tptr tuchar))
                                     (tptr tuchar))
                                   (Evalof (Evar _offset tint) tint)
                                   (tptr tuchar))
                                 (Evalof (Evar _width tint) tint)
                                 (tptr tuchar)) tuchar) tuchar)
                           (Evalof
                             (Ederef
                               (Ebinop Oadd
                                 (Evalof (Evar _kernel (tptr tschar))
                                   (tptr tschar))
                                 (Eval (Vint (Int.repr 6)) tint)
                                 (tptr tschar)) tschar) tschar) tint) tint)
                       (Ebinop Omul
                         (Evalof
                           (Ederef
                             (Ebinop Oadd
                               (Evalof (Evar _source (tptr tuchar))
                                 (tptr tuchar))
                               (Evalof (Evar _width tint) tint)
                               (tptr tuchar)) tuchar) tuchar)
                         (Evalof
                           (Ederef
                             (Ebinop Oadd
                               (Evalof (Evar _kernel (tptr tschar))
                                 (tptr tschar))
                               (Eval (Vint (Int.repr 7)) tint) (tptr tschar))
                             tschar) tschar) tint) tint)
                     (Ebinop Omul
                       (Evalof
                         (Ederef
                           (Ebinop Oadd
                             (Ebinop Oadd
                               (Evalof (Evar _source (tptr tuchar))
                                 (tptr tuchar))
                               (Evalof (Evar _offset tint) tint)
                               (tptr tuchar))
                             (Evalof (Evar _width tint) tint) (tptr tuchar))
                           tuchar) tuchar)
                       (Evalof
                         (Ederef
                           (Ebinop Oadd
                             (Evalof (Evar _kernel (tptr tschar))
                               (tptr tschar)) (Eval (Vint (Int.repr 8)) tint)
                             (tptr tschar)) tschar) tschar) tint) tint) tint))
            Sbreak)
          (LScons (Some 2)
            (Ssequence
              (Sdo (Eassign (Evar _value tint)
                     (Ebinop Oadd
                       (Ebinop Oadd
                         (Ebinop Oadd
                           (Ebinop Oadd
                             (Ebinop Oadd
                               (Ebinop Omul
                                 (Evalof
                                   (Ederef
                                     (Ebinop Osub
                                       (Ebinop Osub
                                         (Evalof (Evar _source (tptr tuchar))
                                           (tptr tuchar))
                                         (Evalof (Evar _offset tint) tint)
                                         (tptr tuchar))
                                       (Evalof (Evar _width tint) tint)
                                       (tptr tuchar)) tuchar) tuchar)
                                 (Evalof
                                   (Ederef
                                     (Ebinop Oadd
                                       (Evalof (Evar _kernel (tptr tschar))
                                         (tptr tschar))
                                       (Eval (Vint (Int.repr 0)) tint)
                                       (tptr tschar)) tschar) tschar) tint)
                               (Ebinop Omul
                                 (Evalof
                                   (Ederef
                                     (Ebinop Osub
                                       (Evalof (Evar _source (tptr tuchar))
                                         (tptr tuchar))
                                       (Evalof (Evar _width tint) tint)
                                       (tptr tuchar)) tuchar) tuchar)
                                 (Evalof
                                   (Ederef
                                     (Ebinop Oadd
                                       (Evalof (Evar _kernel (tptr tschar))
                                         (tptr tschar))
                                       (Eval (Vint (Int.repr 1)) tint)
                                       (tptr tschar)) tschar) tschar) tint)
                               tint)
                             (Ebinop Omul
                               (Evalof
                                 (Ederef
                                   (Ebinop Osub
                                     (Ebinop Oadd
                                       (Evalof (Evar _source (tptr tuchar))
                                         (tptr tuchar))
                                       (Evalof (Evar _offset tint) tint)
                                       (tptr tuchar))
                                     (Evalof (Evar _width tint) tint)
                                     (tptr tuchar)) tuchar) tuchar)
                               (Evalof
                                 (Ederef
                                   (Ebinop Oadd
                                     (Evalof (Evar _kernel (tptr tschar))
                                       (tptr tschar))
                                     (Eval (Vint (Int.repr 2)) tint)
                                     (tptr tschar)) tschar) tschar) tint)
                             tint)
                           (Ebinop Omul
                             (Evalof
                               (Ederef
                                 (Ebinop Osub
                                   (Evalof (Evar _source (tptr tuchar))
                                     (tptr tuchar))
                                   (Evalof (Evar _offset tint) tint)
                                   (tptr tuchar)) tuchar) tuchar)
                             (Evalof
                               (Ederef
                                 (Ebinop Oadd
                                   (Evalof (Evar _kernel (tptr tschar))
                                     (tptr tschar))
                                   (Eval (Vint (Int.repr 3)) tint)
                                   (tptr tschar)) tschar) tschar) tint) tint)
                         (Ebinop Omul
                           (Evalof
                             (Ederef
                               (Evalof (Evar _source (tptr tuchar))
                                 (tptr tuchar)) tuchar) tuchar)
                           (Evalof
                             (Ederef
                               (Ebinop Oadd
                                 (Evalof (Evar _kernel (tptr tschar))
                                   (tptr tschar))
                                 (Eval (Vint (Int.repr 4)) tint)
                                 (tptr tschar)) tschar) tschar) tint) tint)
                       (Ebinop Omul
                         (Evalof
                           (Ederef
                             (Ebinop Oadd
                               (Evalof (Evar _source (tptr tuchar))
                                 (tptr tuchar))
                               (Evalof (Evar _offset tint) tint)
                               (tptr tuchar)) tuchar) tuchar)
                         (Evalof
                           (Ederef
                             (Ebinop Oadd
                               (Evalof (Evar _kernel (tptr tschar))
                                 (tptr tschar))
                               (Eval (Vint (Int.repr 5)) tint) (tptr tschar))
                             tschar) tschar) tint) tint) tint))
              Sbreak)
            (LScons (Some 3)
              (Ssequence
                (Sdo (Eassign (Evar _value tint)
                       (Ebinop Oadd
                         (Ebinop Oadd
                           (Ebinop Oadd
                             (Ebinop Oadd
                               (Ebinop Oadd
                                 (Ebinop Omul
                                   (Evalof
                                     (Ederef
                                       (Ebinop Osub
                                         (Evalof (Evar _source (tptr tuchar))
                                           (tptr tuchar))
                                         (Evalof (Evar _width tint) tint)
                                         (tptr tuchar)) tuchar) tuchar)
                                   (Evalof
                                     (Ederef
                                       (Ebinop Oadd
                                         (Evalof (Evar _kernel (tptr tschar))
                                           (tptr tschar))
                                         (Eval (Vint (Int.repr 1)) tint)
                                         (tptr tschar)) tschar) tschar) tint)
                                 (Ebinop Omul
                                   (Evalof
                                     (Ederef
                                       (Ebinop Osub
                                         (Ebinop Oadd
                                           (Evalof
                                             (Evar _source (tptr tuchar))
                                             (tptr tuchar))
                                           (Evalof (Evar _offset tint) tint)
                                           (tptr tuchar))
                                         (Evalof (Evar _width tint) tint)
                                         (tptr tuchar)) tuchar) tuchar)
                                   (Evalof
                                     (Ederef
                                       (Ebinop Oadd
                                         (Evalof (Evar _kernel (tptr tschar))
                                           (tptr tschar))
                                         (Eval (Vint (Int.repr 2)) tint)
                                         (tptr tschar)) tschar) tschar) tint)
                                 tint)
                               (Ebinop Omul
                                 (Evalof
                                   (Ederef
                                     (Evalof (Evar _source (tptr tuchar))
                                       (tptr tuchar)) tuchar) tuchar)
                                 (Evalof
                                   (Ederef
                                     (Ebinop Oadd
                                       (Evalof (Evar _kernel (tptr tschar))
                                         (tptr tschar))
                                       (Eval (Vint (Int.repr 4)) tint)
                                       (tptr tschar)) tschar) tschar) tint)
                               tint)
                             (Ebinop Omul
                               (Evalof
                                 (Ederef
                                   (Ebinop Oadd
                                     (Evalof (Evar _source (tptr tuchar))
                                       (tptr tuchar))
                                     (Evalof (Evar _offset tint) tint)
                                     (tptr tuchar)) tuchar) tuchar)
                               (Evalof
                                 (Ederef
                                   (Ebinop Oadd
                                     (Evalof (Evar _kernel (tptr tschar))
                                       (tptr tschar))
                                     (Eval (Vint (Int.repr 5)) tint)
                                     (tptr tschar)) tschar) tschar) tint)
                             tint)
                           (Ebinop Omul
                             (Evalof
                               (Ederef
                                 (Ebinop Oadd
                                   (Evalof (Evar _source (tptr tuchar))
                                     (tptr tuchar))
                                   (Evalof (Evar _width tint) tint)
                                   (tptr tuchar)) tuchar) tuchar)
                             (Evalof
                               (Ederef
                                 (Ebinop Oadd
                                   (Evalof (Evar _kernel (tptr tschar))
                                     (tptr tschar))
                                   (Eval (Vint (Int.repr 7)) tint)
                                   (tptr tschar)) tschar) tschar) tint) tint)
                         (Ebinop Omul
                           (Evalof
                             (Ederef
                               (Ebinop Oadd
                                 (Ebinop Oadd
                                   (Evalof (Evar _source (tptr tuchar))
                                     (tptr tuchar))
                                   (Evalof (Evar _offset tint) tint)
                                   (tptr tuchar))
                                 (Evalof (Evar _width tint) tint)
                                 (tptr tuchar)) tuchar) tuchar)
                           (Evalof
                             (Ederef
                               (Ebinop Oadd
                                 (Evalof (Evar _kernel (tptr tschar))
                                   (tptr tschar))
                                 (Eval (Vint (Int.repr 8)) tint)
                                 (tptr tschar)) tschar) tschar) tint) tint)
                       tint))
                Sbreak)
              (LScons (Some 4)
                (Ssequence
                  (Sdo (Eassign (Evar _value tint)
                         (Ebinop Oadd
                           (Ebinop Oadd
                             (Ebinop Oadd
                               (Ebinop Oadd
                                 (Ebinop Oadd
                                   (Ebinop Omul
                                     (Evalof
                                       (Ederef
                                         (Ebinop Osub
                                           (Ebinop Osub
                                             (Evalof
                                               (Evar _source (tptr tuchar))
                                               (tptr tuchar))
                                             (Evalof (Evar _offset tint)
                                               tint) (tptr tuchar))
                                           (Evalof (Evar _width tint) tint)
                                           (tptr tuchar)) tuchar) tuchar)
                                     (Evalof
                                       (Ederef
                                         (Ebinop Oadd
                                           (Evalof
                                             (Evar _kernel (tptr tschar))
                                             (tptr tschar))
                                           (Eval (Vint (Int.repr 0)) tint)
                                           (tptr tschar)) tschar) tschar)
                                     tint)
                                   (Ebinop Omul
                                     (Evalof
                                       (Ederef
                                         (Ebinop Osub
                                           (Evalof
                                             (Evar _source (tptr tuchar))
                                             (tptr tuchar))
                                           (Evalof (Evar _width tint) tint)
                                           (tptr tuchar)) tuchar) tuchar)
                                     (Evalof
                                       (Ederef
                                         (Ebinop Oadd
                                           (Evalof
                                             (Evar _kernel (tptr tschar))
                                             (tptr tschar))
                                           (Eval (Vint (Int.repr 1)) tint)
                                           (tptr tschar)) tschar) tschar)
                                     tint) tint)
                                 (Ebinop Omul
                                   (Evalof
                                     (Ederef
                                       (Ebinop Osub
                                         (Evalof (Evar _source (tptr tuchar))
                                           (tptr tuchar))
                                         (Evalof (Evar _offset tint) tint)
                                         (tptr tuchar)) tuchar) tuchar)
                                   (Evalof
                                     (Ederef
                                       (Ebinop Oadd
                                         (Evalof (Evar _kernel (tptr tschar))
                                           (tptr tschar))
                                         (Eval (Vint (Int.repr 3)) tint)
                                         (tptr tschar)) tschar) tschar) tint)
                                 tint)
                               (Ebinop Omul
                                 (Evalof
                                   (Ederef
                                     (Evalof (Evar _source (tptr tuchar))
                                       (tptr tuchar)) tuchar) tuchar)
                                 (Evalof
                                   (Ederef
                                     (Ebinop Oadd
                                       (Evalof (Evar _kernel (tptr tschar))
                                         (tptr tschar))
                                       (Eval (Vint (Int.repr 4)) tint)
                                       (tptr tschar)) tschar) tschar) tint)
                               tint)
                             (Ebinop Omul
                               (Evalof
                                 (Ederef
                                   (Ebinop Oadd
                                     (Ebinop Osub
                                       (Evalof (Evar _source (tptr tuchar))
                                         (tptr tuchar))
                                       (Evalof (Evar _offset tint) tint)
                                       (tptr tuchar))
                                     (Evalof (Evar _width tint) tint)
                                     (tptr tuchar)) tuchar) tuchar)
                               (Evalof
                                 (Ederef
                                   (Ebinop Oadd
                                     (Evalof (Evar _kernel (tptr tschar))
                                       (tptr tschar))
                                     (Eval (Vint (Int.repr 6)) tint)
                                     (tptr tschar)) tschar) tschar) tint)
                             tint)
                           (Ebinop Omul
                             (Evalof
                               (Ederef
                                 (Ebinop Oadd
                                   (Evalof (Evar _source (tptr tuchar))
                                     (tptr tuchar))
                                   (Evalof (Evar _width tint) tint)
                                   (tptr tuchar)) tuchar) tuchar)
                             (Evalof
                               (Ederef
                                 (Ebinop Oadd
                                   (Evalof (Evar _kernel (tptr tschar))
                                     (tptr tschar))
                                   (Eval (Vint (Int.repr 7)) tint)
                                   (tptr tschar)) tschar) tschar) tint) tint)
                         tint))
                  Sbreak)
                (LScons (Some 5)
                  (Ssequence
                    (Sdo (Eassign (Evar _value tint)
                           (Ebinop Oadd
                             (Ebinop Oadd
                               (Ebinop Oadd
                                 (Ebinop Omul
                                   (Evalof
                                     (Ederef
                                       (Evalof (Evar _source (tptr tuchar))
                                         (tptr tuchar)) tuchar) tuchar)
                                   (Evalof
                                     (Ederef
                                       (Ebinop Oadd
                                         (Evalof (Evar _kernel (tptr tschar))
                                           (tptr tschar))
                                         (Eval (Vint (Int.repr 4)) tint)
                                         (tptr tschar)) tschar) tschar) tint)
                                 (Ebinop Omul
                                   (Evalof
                                     (Ederef
                                       (Ebinop Oadd
                                         (Evalof (Evar _source (tptr tuchar))
                                           (tptr tuchar))
                                         (Evalof (Evar _offset tint) tint)
                                         (tptr tuchar)) tuchar) tuchar)
                                   (Evalof
                                     (Ederef
                                       (Ebinop Oadd
                                         (Evalof (Evar _kernel (tptr tschar))
                                           (tptr tschar))
                                         (Eval (Vint (Int.repr 5)) tint)
                                         (tptr tschar)) tschar) tschar) tint)
                                 tint)
                               (Ebinop Omul
                                 (Evalof
                                   (Ederef
                                     (Ebinop Oadd
                                       (Evalof (Evar _source (tptr tuchar))
                                         (tptr tuchar))
                                       (Evalof (Evar _width tint) tint)
                                       (tptr tuchar)) tuchar) tuchar)
                                 (Evalof
                                   (Ederef
                                     (Ebinop Oadd
                                       (Evalof (Evar _kernel (tptr tschar))
                                         (tptr tschar))
                                       (Eval (Vint (Int.repr 7)) tint)
                                       (tptr tschar)) tschar) tschar) tint)
                               tint)
                             (Ebinop Omul
                               (Evalof
                                 (Ederef
                                   (Ebinop Oadd
                                     (Ebinop Oadd
                                       (Evalof (Evar _source (tptr tuchar))
                                         (tptr tuchar))
                                       (Evalof (Evar _offset tint) tint)
                                       (tptr tuchar))
                                     (Evalof (Evar _width tint) tint)
                                     (tptr tuchar)) tuchar) tuchar)
                               (Evalof
                                 (Ederef
                                   (Ebinop Oadd
                                     (Evalof (Evar _kernel (tptr tschar))
                                       (tptr tschar))
                                     (Eval (Vint (Int.repr 8)) tint)
                                     (tptr tschar)) tschar) tschar) tint)
                             tint) tint))
                    Sbreak)
                  (LScons (Some 6)
                    (Ssequence
                      (Sdo (Eassign (Evar _value tint)
                             (Ebinop Oadd
                               (Ebinop Oadd
                                 (Ebinop Oadd
                                   (Ebinop Omul
                                     (Evalof
                                       (Ederef
                                         (Ebinop Osub
                                           (Evalof
                                             (Evar _source (tptr tuchar))
                                             (tptr tuchar))
                                           (Evalof (Evar _offset tint) tint)
                                           (tptr tuchar)) tuchar) tuchar)
                                     (Evalof
                                       (Ederef
                                         (Ebinop Oadd
                                           (Evalof
                                             (Evar _kernel (tptr tschar))
                                             (tptr tschar))
                                           (Eval (Vint (Int.repr 3)) tint)
                                           (tptr tschar)) tschar) tschar)
                                     tint)
                                   (Ebinop Omul
                                     (Evalof
                                       (Ederef
                                         (Evalof (Evar _source (tptr tuchar))
                                           (tptr tuchar)) tuchar) tuchar)
                                     (Evalof
                                       (Ederef
                                         (Ebinop Oadd
                                           (Evalof
                                             (Evar _kernel (tptr tschar))
                                             (tptr tschar))
                                           (Eval (Vint (Int.repr 4)) tint)
                                           (tptr tschar)) tschar) tschar)
                                     tint) tint)
                                 (Ebinop Omul
                                   (Evalof
                                     (Ederef
                                       (Ebinop Oadd
                                         (Ebinop Osub
                                           (Evalof
                                             (Evar _source (tptr tuchar))
                                             (tptr tuchar))
                                           (Evalof (Evar _offset tint) tint)
                                           (tptr tuchar))
                                         (Evalof (Evar _width tint) tint)
                                         (tptr tuchar)) tuchar) tuchar)
                                   (Evalof
                                     (Ederef
                                       (Ebinop Oadd
                                         (Evalof (Evar _kernel (tptr tschar))
                                           (tptr tschar))
                                         (Eval (Vint (Int.repr 6)) tint)
                                         (tptr tschar)) tschar) tschar) tint)
                                 tint)
                               (Ebinop Omul
                                 (Evalof
                                   (Ederef
                                     (Ebinop Oadd
                                       (Evalof (Evar _source (tptr tuchar))
                                         (tptr tuchar))
                                       (Evalof (Evar _width tint) tint)
                                       (tptr tuchar)) tuchar) tuchar)
                                 (Evalof
                                   (Ederef
                                     (Ebinop Oadd
                                       (Evalof (Evar _kernel (tptr tschar))
                                         (tptr tschar))
                                       (Eval (Vint (Int.repr 7)) tint)
                                       (tptr tschar)) tschar) tschar) tint)
                               tint) tint))
                      Sbreak)
                    (LScons (Some 7)
                      (Ssequence
                        (Sdo (Eassign (Evar _value tint)
                               (Ebinop Oadd
                                 (Ebinop Oadd
                                   (Ebinop Oadd
                                     (Ebinop Omul
                                       (Evalof
                                         (Ederef
                                           (Ebinop Osub
                                             (Evalof
                                               (Evar _source (tptr tuchar))
                                               (tptr tuchar))
                                             (Evalof (Evar _width tint) tint)
                                             (tptr tuchar)) tuchar) tuchar)
                                       (Evalof
                                         (Ederef
                                           (Ebinop Oadd
                                             (Evalof
                                               (Evar _kernel (tptr tschar))
                                               (tptr tschar))
                                             (Eval (Vint (Int.repr 1)) tint)
                                             (tptr tschar)) tschar) tschar)
                                       tint)
                                     (Ebinop Omul
                                       (Evalof
                                         (Ederef
                                           (Ebinop Osub
                                             (Ebinop Oadd
                                               (Evalof
                                                 (Evar _source (tptr tuchar))
                                                 (tptr tuchar))
                                               (Evalof (Evar _offset tint)
                                                 tint) (tptr tuchar))
                                             (Evalof (Evar _width tint) tint)
                                             (tptr tuchar)) tuchar) tuchar)
                                       (Evalof
                                         (Ederef
                                           (Ebinop Oadd
                                             (Evalof
                                               (Evar _kernel (tptr tschar))
                                               (tptr tschar))
                                             (Eval (Vint (Int.repr 2)) tint)
                                             (tptr tschar)) tschar) tschar)
                                       tint) tint)
                                   (Ebinop Omul
                                     (Evalof
                                       (Ederef
                                         (Evalof (Evar _source (tptr tuchar))
                                           (tptr tuchar)) tuchar) tuchar)
                                     (Evalof
                                       (Ederef
                                         (Ebinop Oadd
                                           (Evalof
                                             (Evar _kernel (tptr tschar))
                                             (tptr tschar))
                                           (Eval (Vint (Int.repr 4)) tint)
                                           (tptr tschar)) tschar) tschar)
                                     tint) tint)
                                 (Ebinop Omul
                                   (Evalof
                                     (Ederef
                                       (Ebinop Oadd
                                         (Evalof (Evar _source (tptr tuchar))
                                           (tptr tuchar))
                                         (Evalof (Evar _offset tint) tint)
                                         (tptr tuchar)) tuchar) tuchar)
                                   (Evalof
                                     (Ederef
                                       (Ebinop Oadd
                                         (Evalof (Evar _kernel (tptr tschar))
                                           (tptr tschar))
                                         (Eval (Vint (Int.repr 5)) tint)
                                         (tptr tschar)) tschar) tschar) tint)
                                 tint) tint))
                        Sbreak)
                      (LScons (Some 8)
                        (Ssequence
                          (Sdo (Eassign (Evar _value tint)
                                 (Ebinop Oadd
                                   (Ebinop Oadd
                                     (Ebinop Oadd
                                       (Ebinop Omul
                                         (Evalof
                                           (Ederef
                                             (Ebinop Osub
                                               (Ebinop Osub
                                                 (Evalof
                                                   (Evar _source (tptr tuchar))
                                                   (tptr tuchar))
                                                 (Evalof (Evar _offset tint)
                                                   tint) (tptr tuchar))
                                               (Evalof (Evar _width tint)
                                                 tint) (tptr tuchar)) tuchar)
                                           tuchar)
                                         (Evalof
                                           (Ederef
                                             (Ebinop Oadd
                                               (Evalof
                                                 (Evar _kernel (tptr tschar))
                                                 (tptr tschar))
                                               (Eval (Vint (Int.repr 0)) tint)
                                               (tptr tschar)) tschar) tschar)
                                         tint)
                                       (Ebinop Omul
                                         (Evalof
                                           (Ederef
                                             (Ebinop Osub
                                               (Evalof
                                                 (Evar _source (tptr tuchar))
                                                 (tptr tuchar))
                                               (Evalof (Evar _width tint)
                                                 tint) (tptr tuchar)) tuchar)
                                           tuchar)
                                         (Evalof
                                           (Ederef
                                             (Ebinop Oadd
                                               (Evalof
                                                 (Evar _kernel (tptr tschar))
                                                 (tptr tschar))
                                               (Eval (Vint (Int.repr 1)) tint)
                                               (tptr tschar)) tschar) tschar)
                                         tint) tint)
                                     (Ebinop Omul
                                       (Evalof
                                         (Ederef
                                           (Ebinop Osub
                                             (Evalof
                                               (Evar _source (tptr tuchar))
                                               (tptr tuchar))
                                             (Evalof (Evar _offset tint)
                                               tint) (tptr tuchar)) tuchar)
                                         tuchar)
                                       (Evalof
                                         (Ederef
                                           (Ebinop Oadd
                                             (Evalof
                                               (Evar _kernel (tptr tschar))
                                               (tptr tschar))
                                             (Eval (Vint (Int.repr 3)) tint)
                                             (tptr tschar)) tschar) tschar)
                                       tint) tint)
                                   (Ebinop Omul
                                     (Evalof
                                       (Ederef
                                         (Evalof (Evar _source (tptr tuchar))
                                           (tptr tuchar)) tuchar) tuchar)
                                     (Evalof
                                       (Ederef
                                         (Ebinop Oadd
                                           (Evalof
                                             (Evar _kernel (tptr tschar))
                                             (tptr tschar))
                                           (Eval (Vint (Int.repr 4)) tint)
                                           (tptr tschar)) tschar) tschar)
                                     tint) tint) tint))
                          Sbreak)
                        LSnil))))))))))
    (Sreturn (Some (Ecast
                     (Ebinop Odiv
                       (Ecast
                         (Ecall
                           (Evalof
                             (Evar _abs (Tfunction (tint :: nil) tint
                                          cc_default))
                             (Tfunction (tint :: nil) tint cc_default))
                           (Econs (Evalof (Evar _value tint) tint) Enil)
                           tint) tint) (Evalof (Evar _total tuchar) tuchar)
                       tint) tuchar)))))
|}.

Definition f_image_convolution_3x3 := {|
  fn_return := tvoid;
  fn_callconv := cc_default;
  fn_params := ((_input, (tptr (Tstruct _image_t noattr))) ::
                (_output, (tptr (Tstruct _image_t noattr))) ::
                (_kernel, (tptr tschar)) :: (_kernel_total, tuchar) :: nil);
  fn_vars := ((_source, (tptr tuchar)) :: (_dest, (tptr tuchar)) ::
              (_height, tint) :: (_width, tint) :: (_x, tint) ::
              (_y, tint) :: (_x__1, tint) :: (_x__2, tint) ::
              (_x__3, tint) :: (_y__1, tint) :: (_x__4, tint) ::
              (_x__5, tint) :: nil);
  fn_body :=
(Ssequence
  (Sdo (Eassign (Evar _source (tptr tuchar))
         (Evalof
           (Efield
             (Evalof
               (Ederef
                 (Evalof (Evar _input (tptr (Tstruct _image_t noattr)))
                   (tptr (Tstruct _image_t noattr)))
                 (Tstruct _image_t noattr)) (Tstruct _image_t noattr)) _buf
             (tptr tvoid)) (tptr tvoid)) (tptr tuchar)))
  (Ssequence
    (Sdo (Eassign (Evar _dest (tptr tuchar))
           (Evalof
             (Efield
               (Evalof
                 (Ederef
                   (Evalof (Evar _output (tptr (Tstruct _image_t noattr)))
                     (tptr (Tstruct _image_t noattr)))
                   (Tstruct _image_t noattr)) (Tstruct _image_t noattr)) _buf
               (tptr tvoid)) (tptr tvoid)) (tptr tuchar)))
    (Ssequence
      (Sdo (Eassign
             (Efield
               (Evalof
                 (Ederef
                   (Evalof (Evar _output (tptr (Tstruct _image_t noattr)))
                     (tptr (Tstruct _image_t noattr)))
                   (Tstruct _image_t noattr)) (Tstruct _image_t noattr)) _ts
               (Tstruct _timeval noattr))
             (Evalof
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _input (tptr (Tstruct _image_t noattr)))
                       (tptr (Tstruct _image_t noattr)))
                     (Tstruct _image_t noattr)) (Tstruct _image_t noattr))
                 _ts (Tstruct _timeval noattr)) (Tstruct _timeval noattr))
             (Tstruct _timeval noattr)))
      (Ssequence
        (Sdo (Eassign
               (Efield
                 (Evalof
                   (Ederef
                     (Evalof (Evar _output (tptr (Tstruct _image_t noattr)))
                       (tptr (Tstruct _image_t noattr)))
                     (Tstruct _image_t noattr)) (Tstruct _image_t noattr))
                 _eulers (Tstruct _FloatEulers noattr))
               (Evalof
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof (Evar _input (tptr (Tstruct _image_t noattr)))
                         (tptr (Tstruct _image_t noattr)))
                       (Tstruct _image_t noattr)) (Tstruct _image_t noattr))
                   _eulers (Tstruct _FloatEulers noattr))
                 (Tstruct _FloatEulers noattr))
               (Tstruct _FloatEulers noattr)))
        (Ssequence
          (Sdo (Eassign
                 (Efield
                   (Evalof
                     (Ederef
                       (Evalof
                         (Evar _output (tptr (Tstruct _image_t noattr)))
                         (tptr (Tstruct _image_t noattr)))
                       (Tstruct _image_t noattr)) (Tstruct _image_t noattr))
                   _pprz_ts tuint)
                 (Evalof
                   (Efield
                     (Evalof
                       (Ederef
                         (Evalof
                           (Evar _input (tptr (Tstruct _image_t noattr)))
                           (tptr (Tstruct _image_t noattr)))
                         (Tstruct _image_t noattr))
                       (Tstruct _image_t noattr)) _pprz_ts tuint) tuint)
                 tuint))
          (Ssequence
            (Sdo (Eassign (Evar _height tint)
                   (Evalof
                     (Efield
                       (Evalof
                         (Ederef
                           (Evalof
                             (Evar _output (tptr (Tstruct _image_t noattr)))
                             (tptr (Tstruct _image_t noattr)))
                           (Tstruct _image_t noattr))
                         (Tstruct _image_t noattr)) _h tushort) tushort)
                   tint))
            (Ssequence
              (Sdo (Eassign (Evar _width tint)
                     (Evalof
                       (Efield
                         (Evalof
                           (Ederef
                             (Evalof
                               (Evar _output (tptr (Tstruct _image_t noattr)))
                               (tptr (Tstruct _image_t noattr)))
                             (Tstruct _image_t noattr))
                           (Tstruct _image_t noattr)) _w tushort) tushort)
                     tint))
              (Sifthenelse (Ebinop Oeq
                             (Evalof
                               (Efield
                                 (Evalof
                                   (Ederef
                                     (Evalof
                                       (Evar _output (tptr (Tstruct _image_t noattr)))
                                       (tptr (Tstruct _image_t noattr)))
                                     (Tstruct _image_t noattr))
                                   (Tstruct _image_t noattr)) _type tint)
                               tint) (Eval (Vint (Int.repr 0)) tint) tint)
                (Ssequence
                  (Sdo (Eassign
                         (Ederef
                           (Epostincr Incr (Evar _dest (tptr tuchar))
                             (tptr tuchar)) tuchar)
                         (Eval (Vint (Int.repr 127)) tint) tuchar))
                  (Ssequence
                    (Sdo (Epostincr Incr (Evar _source (tptr tuchar))
                           (tptr tuchar)))
                    (Ssequence
                      (Sdo (Eassign
                             (Ederef
                               (Epostincr Incr (Evar _dest (tptr tuchar))
                                 (tptr tuchar)) tuchar)
                             (Ecall
                               (Evalof
                                 (Evar _ker_mul_3x3 (Tfunction
                                                      ((tptr tuchar) ::
                                                       (tptr tschar) ::
                                                       tuchar :: tuchar ::
                                                       tint :: tint :: nil)
                                                      tuchar cc_default))
                                 (Tfunction
                                   ((tptr tuchar) :: (tptr tschar) ::
                                    tuchar :: tuchar :: tint :: tint :: nil)
                                   tuchar cc_default))
                               (Econs
                                 (Evalof (Evar _source (tptr tuchar))
                                   (tptr tuchar))
                                 (Econs
                                   (Evalof (Evar _kernel (tptr tschar))
                                     (tptr tschar))
                                   (Econs
                                     (Evalof (Evar _kernel_total tuchar)
                                       tuchar)
                                     (Econs (Eval (Vint (Int.repr 5)) tint)
                                       (Econs
                                         (Ebinop Omul
                                           (Eval (Vint (Int.repr 2)) tint)
                                           (Evalof (Evar _width tint) tint)
                                           tint)
                                         (Econs
                                           (Eval (Vint (Int.repr 1)) tint)
                                           Enil)))))) tuchar) tuchar))
                      (Ssequence
                        (Sdo (Eassignop Oadd (Evar _source (tptr tuchar))
                               (Eval (Vint (Int.repr 2)) tint)
                               (tptr tuchar) (tptr tuchar)))
                        (Ssequence
                          (Sdo (Eassign
                                 (Ederef
                                   (Epostincr Incr (Evar _dest (tptr tuchar))
                                     (tptr tuchar)) tuchar)
                                 (Eval (Vint (Int.repr 127)) tint) tuchar))
                          (Ssequence
                            (Ssequence
                              (Sdo (Eassign (Evar _x tint)
                                     (Eval (Vint (Int.repr 1)) tint) tint))
                              (Sfor
                                Sskip
                                (Ebinop Olt (Evalof (Evar _x tint) tint)
                                  (Ebinop Osub
                                    (Evalof (Evar _width tint) tint)
                                    (Eval (Vint (Int.repr 1)) tint) tint)
                                  tint)
                                (Sdo (Epostincr Incr (Evar _x tint) tint))
                                (Ssequence
                                  (Sdo (Eassign
                                         (Ederef
                                           (Epostincr Incr
                                             (Evar _dest (tptr tuchar))
                                             (tptr tuchar)) tuchar)
                                         (Ecall
                                           (Evalof
                                             (Evar _ker_mul_3x3 (Tfunction
                                                                  ((tptr tuchar) ::
                                                                   (tptr tschar) ::
                                                                   tuchar ::
                                                                   tuchar ::
                                                                   tint ::
                                                                   tint ::
                                                                   nil)
                                                                  tuchar
                                                                  cc_default))
                                             (Tfunction
                                               ((tptr tuchar) ::
                                                (tptr tschar) :: tuchar ::
                                                tuchar :: tint :: tint ::
                                                nil) tuchar cc_default))
                                           (Econs
                                             (Evalof
                                               (Evar _source (tptr tuchar))
                                               (tptr tuchar))
                                             (Econs
                                               (Evalof
                                                 (Evar _kernel (tptr tschar))
                                                 (tptr tschar))
                                               (Econs
                                                 (Evalof
                                                   (Evar _kernel_total tuchar)
                                                   tuchar)
                                                 (Econs
                                                   (Eval (Vint (Int.repr 1)) tint)
                                                   (Econs
                                                     (Ebinop Omul
                                                       (Eval (Vint (Int.repr 2)) tint)
                                                       (Evalof
                                                         (Evar _width tint)
                                                         tint) tint)
                                                     (Econs
                                                       (Eval (Vint (Int.repr 1)) tint)
                                                       Enil)))))) tuchar)
                                         tuchar))
                                  (Ssequence
                                    (Sdo (Eassignop Oadd
                                           (Evar _source (tptr tuchar))
                                           (Eval (Vint (Int.repr 2)) tint)
                                           (tptr tuchar) (tptr tuchar)))
                                    (Sdo (Eassign
                                           (Ederef
                                             (Epostincr Incr
                                               (Evar _dest (tptr tuchar))
                                               (tptr tuchar)) tuchar)
                                           (Eval (Vint (Int.repr 127)) tint)
                                           tuchar))))))
                            (Ssequence
                              (Sdo (Eassign
                                     (Ederef
                                       (Epostincr Incr
                                         (Evar _dest (tptr tuchar))
                                         (tptr tuchar)) tuchar)
                                     (Ecall
                                       (Evalof
                                         (Evar _ker_mul_3x3 (Tfunction
                                                              ((tptr tuchar) ::
                                                               (tptr tschar) ::
                                                               tuchar ::
                                                               tuchar ::
                                                               tint ::
                                                               tint :: nil)
                                                              tuchar
                                                              cc_default))
                                         (Tfunction
                                           ((tptr tuchar) :: (tptr tschar) ::
                                            tuchar :: tuchar :: tint ::
                                            tint :: nil) tuchar cc_default))
                                       (Econs
                                         (Evalof (Evar _source (tptr tuchar))
                                           (tptr tuchar))
                                         (Econs
                                           (Evalof
                                             (Evar _kernel (tptr tschar))
                                             (tptr tschar))
                                           (Econs
                                             (Evalof
                                               (Evar _kernel_total tuchar)
                                               tuchar)
                                             (Econs
                                               (Eval (Vint (Int.repr 6)) tint)
                                               (Econs
                                                 (Ebinop Omul
                                                   (Eval (Vint (Int.repr 2)) tint)
                                                   (Evalof (Evar _width tint)
                                                     tint) tint)
                                                 (Econs
                                                   (Eval (Vint (Int.repr 1)) tint)
                                                   Enil)))))) tuchar) tuchar))
                              (Ssequence
                                (Sdo (Eassignop Oadd
                                       (Evar _source (tptr tuchar))
                                       (Eval (Vint (Int.repr 2)) tint)
                                       (tptr tuchar) (tptr tuchar)))
                                (Ssequence
                                  (Sdo (Eassign
                                         (Ederef
                                           (Epostincr Incr
                                             (Evar _dest (tptr tuchar))
                                             (tptr tuchar)) tuchar)
                                         (Eval (Vint (Int.repr 127)) tint)
                                         tuchar))
                                  (Ssequence
                                    (Ssequence
                                      (Sdo (Eassign (Evar _y tint)
                                             (Eval (Vint (Int.repr 1)) tint)
                                             tint))
                                      (Sfor
                                        Sskip
                                        (Ebinop Olt
                                          (Evalof (Evar _y tint) tint)
                                          (Ebinop Osub
                                            (Evalof (Evar _height tint) tint)
                                            (Eval (Vint (Int.repr 1)) tint)
                                            tint) tint)
                                        (Sdo (Epostincr Incr (Evar _y tint)
                                               tint))
                                        (Ssequence
                                          (Sdo (Eassign
                                                 (Ederef
                                                   (Epostincr Incr
                                                     (Evar _dest (tptr tuchar))
                                                     (tptr tuchar)) tuchar)
                                                 (Ecall
                                                   (Evalof
                                                     (Evar _ker_mul_3x3 
                                                     (Tfunction
                                                       ((tptr tuchar) ::
                                                        (tptr tschar) ::
                                                        tuchar :: tuchar ::
                                                        tint :: tint :: nil)
                                                       tuchar cc_default))
                                                     (Tfunction
                                                       ((tptr tuchar) ::
                                                        (tptr tschar) ::
                                                        tuchar :: tuchar ::
                                                        tint :: tint :: nil)
                                                       tuchar cc_default))
                                                   (Econs
                                                     (Evalof
                                                       (Evar _source (tptr tuchar))
                                                       (tptr tuchar))
                                                     (Econs
                                                       (Evalof
                                                         (Evar _kernel (tptr tschar))
                                                         (tptr tschar))
                                                       (Econs
                                                         (Evalof
                                                           (Evar _kernel_total tuchar)
                                                           tuchar)
                                                         (Econs
                                                           (Eval (Vint (Int.repr 3)) tint)
                                                           (Econs
                                                             (Ebinop Omul
                                                               (Eval (Vint (Int.repr 2)) tint)
                                                               (Evalof
                                                                 (Evar _width tint)
                                                                 tint) tint)
                                                             (Econs
                                                               (Eval (Vint (Int.repr 1)) tint)
                                                               Enil))))))
                                                   tuchar) tuchar))
                                          (Ssequence
                                            (Sdo (Eassignop Oadd
                                                   (Evar _source (tptr tuchar))
                                                   (Eval (Vint (Int.repr 2)) tint)
                                                   (tptr tuchar) (tptr tuchar)))
                                            (Ssequence
                                              (Sdo (Eassign
                                                     (Ederef
                                                       (Epostincr Incr
                                                         (Evar _dest (tptr tuchar))
                                                         (tptr tuchar))
                                                       tuchar)
                                                     (Eval (Vint (Int.repr 127)) tint)
                                                     tuchar))
                                              (Ssequence
                                                (Ssequence
                                                  (Sdo (Eassign
                                                         (Evar _x__1 tint)
                                                         (Eval (Vint (Int.repr 1)) tint)
                                                         tint))
                                                  (Sfor
                                                    Sskip
                                                    (Ebinop Olt
                                                      (Evalof
                                                        (Evar _x__1 tint)
                                                        tint)
                                                      (Ebinop Osub
                                                        (Evalof
                                                          (Evar _width tint)
                                                          tint)
                                                        (Eval (Vint (Int.repr 1)) tint)
                                                        tint) tint)
                                                    (Sdo (Epostincr Incr
                                                           (Evar _x__1 tint)
                                                           tint))
                                                    (Ssequence
                                                      (Sdo (Eassign
                                                             (Ederef
                                                               (Epostincr
                                                                 Incr
                                                                 (Evar _dest (tptr tuchar))
                                                                 (tptr tuchar))
                                                               tuchar)
                                                             (Ecall
                                                               (Evalof
                                                                 (Evar _ker_mul_3x3 
                                                                 (Tfunction
                                                                   ((tptr tuchar) ::
                                                                    (tptr tschar) ::
                                                                    tuchar ::
                                                                    tuchar ::
                                                                    tint ::
                                                                    tint ::
                                                                    nil)
                                                                   tuchar
                                                                   cc_default))
                                                                 (Tfunction
                                                                   ((tptr tuchar) ::
                                                                    (tptr tschar) ::
                                                                    tuchar ::
                                                                    tuchar ::
                                                                    tint ::
                                                                    tint ::
                                                                    nil)
                                                                   tuchar
                                                                   cc_default))
                                                               (Econs
                                                                 (Evalof
                                                                   (Evar _source (tptr tuchar))
                                                                   (tptr tuchar))
                                                                 (Econs
                                                                   (Evalof
                                                                    (Evar _kernel (tptr tschar))
                                                                    (tptr tschar))
                                                                   (Econs
                                                                    (Evalof
                                                                    (Evar _kernel_total tuchar)
                                                                    tuchar)
                                                                    (Econs
                                                                    (Eval (Vint (Int.repr 0)) tint)
                                                                    (Econs
                                                                    (Ebinop Omul
                                                                    (Eval (Vint (Int.repr 2)) tint)
                                                                    (Evalof
                                                                    (Evar _width tint)
                                                                    tint)
                                                                    tint)
                                                                    (Econs
                                                                    (Eval (Vint (Int.repr 1)) tint)
                                                                    Enil))))))
                                                               tuchar)
                                                             tuchar))
                                                      (Ssequence
                                                        (Sdo (Eassignop Oadd
                                                               (Evar _source (tptr tuchar))
                                                               (Eval (Vint (Int.repr 2)) tint)
                                                               (tptr tuchar) (tptr tuchar)))
                                                        (Sdo (Eassign
                                                               (Ederef
                                                                 (Epostincr
                                                                   Incr
                                                                   (Evar _dest (tptr tuchar))
                                                                   (tptr tuchar))
                                                                 tuchar)
                                                               (Eval (Vint (Int.repr 127)) tint)
                                                               tuchar))))))
                                                (Ssequence
                                                  (Sdo (Eassign
                                                         (Ederef
                                                           (Epostincr Incr
                                                             (Evar _dest (tptr tuchar))
                                                             (tptr tuchar))
                                                           tuchar)
                                                         (Ecall
                                                           (Evalof
                                                             (Evar _ker_mul_3x3 
                                                             (Tfunction
                                                               ((tptr tuchar) ::
                                                                (tptr tschar) ::
                                                                tuchar ::
                                                                tuchar ::
                                                                tint ::
                                                                tint :: nil)
                                                               tuchar
                                                               cc_default))
                                                             (Tfunction
                                                               ((tptr tuchar) ::
                                                                (tptr tschar) ::
                                                                tuchar ::
                                                                tuchar ::
                                                                tint ::
                                                                tint :: nil)
                                                               tuchar
                                                               cc_default))
                                                           (Econs
                                                             (Evalof
                                                               (Evar _source (tptr tuchar))
                                                               (tptr tuchar))
                                                             (Econs
                                                               (Evalof
                                                                 (Evar _kernel (tptr tschar))
                                                                 (tptr tschar))
                                                               (Econs
                                                                 (Evalof
                                                                   (Evar _kernel_total tuchar)
                                                                   tuchar)
                                                                 (Econs
                                                                   (Eval (Vint (Int.repr 4)) tint)
                                                                   (Econs
                                                                    (Ebinop Omul
                                                                    (Eval (Vint (Int.repr 2)) tint)
                                                                    (Evalof
                                                                    (Evar _width tint)
                                                                    tint)
                                                                    tint)
                                                                    (Econs
                                                                    (Eval (Vint (Int.repr 1)) tint)
                                                                    Enil))))))
                                                           tuchar) tuchar))
                                                  (Ssequence
                                                    (Sdo (Eassignop Oadd
                                                           (Evar _source (tptr tuchar))
                                                           (Eval (Vint (Int.repr 2)) tint)
                                                           (tptr tuchar) (tptr tuchar)))
                                                    (Sdo (Eassign
                                                           (Ederef
                                                             (Epostincr Incr
                                                               (Evar _dest (tptr tuchar))
                                                               (tptr tuchar))
                                                             tuchar)
                                                           (Eval (Vint (Int.repr 127)) tint)
                                                           tuchar))))))))))
                                    (Ssequence
                                      (Sdo (Eassign
                                             (Ederef
                                               (Epostincr Incr
                                                 (Evar _dest (tptr tuchar))
                                                 (tptr tuchar)) tuchar)
                                             (Ecall
                                               (Evalof
                                                 (Evar _ker_mul_3x3 (Tfunction
                                                                    ((tptr tuchar) ::
                                                                    (tptr tschar) ::
                                                                    tuchar ::
                                                                    tuchar ::
                                                                    tint ::
                                                                    tint ::
                                                                    nil)
                                                                    tuchar
                                                                    cc_default))
                                                 (Tfunction
                                                   ((tptr tuchar) ::
                                                    (tptr tschar) ::
                                                    tuchar :: tuchar ::
                                                    tint :: tint :: nil)
                                                   tuchar cc_default))
                                               (Econs
                                                 (Evalof
                                                   (Evar _source (tptr tuchar))
                                                   (tptr tuchar))
                                                 (Econs
                                                   (Evalof
                                                     (Evar _kernel (tptr tschar))
                                                     (tptr tschar))
                                                   (Econs
                                                     (Evalof
                                                       (Evar _kernel_total tuchar)
                                                       tuchar)
                                                     (Econs
                                                       (Eval (Vint (Int.repr 7)) tint)
                                                       (Econs
                                                         (Ebinop Omul
                                                           (Eval (Vint (Int.repr 2)) tint)
                                                           (Evalof
                                                             (Evar _width tint)
                                                             tint) tint)
                                                         (Econs
                                                           (Eval (Vint (Int.repr 1)) tint)
                                                           Enil)))))) tuchar)
                                             tuchar))
                                      (Ssequence
                                        (Sdo (Eassignop Oadd
                                               (Evar _source (tptr tuchar))
                                               (Eval (Vint (Int.repr 2)) tint)
                                               (tptr tuchar) (tptr tuchar)))
                                        (Ssequence
                                          (Sdo (Eassign
                                                 (Ederef
                                                   (Epostincr Incr
                                                     (Evar _dest (tptr tuchar))
                                                     (tptr tuchar)) tuchar)
                                                 (Eval (Vint (Int.repr 127)) tint)
                                                 tuchar))
                                          (Ssequence
                                            (Ssequence
                                              (Sdo (Eassign (Evar _x__2 tint)
                                                     (Eval (Vint (Int.repr 1)) tint)
                                                     tint))
                                              (Sfor
                                                Sskip
                                                (Ebinop Olt
                                                  (Evalof (Evar _x__2 tint)
                                                    tint)
                                                  (Ebinop Osub
                                                    (Evalof
                                                      (Evar _width tint)
                                                      tint)
                                                    (Eval (Vint (Int.repr 1)) tint)
                                                    tint) tint)
                                                (Sdo (Epostincr Incr
                                                       (Evar _x__2 tint)
                                                       tint))
                                                (Ssequence
                                                  (Sdo (Eassign
                                                         (Ederef
                                                           (Epostincr Incr
                                                             (Evar _dest (tptr tuchar))
                                                             (tptr tuchar))
                                                           tuchar)
                                                         (Ecall
                                                           (Evalof
                                                             (Evar _ker_mul_3x3 
                                                             (Tfunction
                                                               ((tptr tuchar) ::
                                                                (tptr tschar) ::
                                                                tuchar ::
                                                                tuchar ::
                                                                tint ::
                                                                tint :: nil)
                                                               tuchar
                                                               cc_default))
                                                             (Tfunction
                                                               ((tptr tuchar) ::
                                                                (tptr tschar) ::
                                                                tuchar ::
                                                                tuchar ::
                                                                tint ::
                                                                tint :: nil)
                                                               tuchar
                                                               cc_default))
                                                           (Econs
                                                             (Evalof
                                                               (Evar _source (tptr tuchar))
                                                               (tptr tuchar))
                                                             (Econs
                                                               (Evalof
                                                                 (Evar _kernel (tptr tschar))
                                                                 (tptr tschar))
                                                               (Econs
                                                                 (Evalof
                                                                   (Evar _kernel_total tuchar)
                                                                   tuchar)
                                                                 (Econs
                                                                   (Eval (Vint (Int.repr 2)) tint)
                                                                   (Econs
                                                                    (Ebinop Omul
                                                                    (Eval (Vint (Int.repr 2)) tint)
                                                                    (Evalof
                                                                    (Evar _width tint)
                                                                    tint)
                                                                    tint)
                                                                    (Econs
                                                                    (Eval (Vint (Int.repr 1)) tint)
                                                                    Enil))))))
                                                           tuchar) tuchar))
                                                  (Ssequence
                                                    (Sdo (Eassignop Oadd
                                                           (Evar _source (tptr tuchar))
                                                           (Eval (Vint (Int.repr 2)) tint)
                                                           (tptr tuchar) (tptr tuchar)))
                                                    (Sdo (Eassign
                                                           (Ederef
                                                             (Epostincr Incr
                                                               (Evar _dest (tptr tuchar))
                                                               (tptr tuchar))
                                                             tuchar)
                                                           (Eval (Vint (Int.repr 127)) tint)
                                                           tuchar))))))
                                            (Sdo (Eassign
                                                   (Ederef
                                                     (Evalof
                                                       (Evar _dest (tptr tuchar))
                                                       (tptr tuchar)) tuchar)
                                                   (Ecall
                                                     (Evalof
                                                       (Evar _ker_mul_3x3 
                                                       (Tfunction
                                                         ((tptr tuchar) ::
                                                          (tptr tschar) ::
                                                          tuchar :: tuchar ::
                                                          tint :: tint ::
                                                          nil) tuchar
                                                         cc_default))
                                                       (Tfunction
                                                         ((tptr tuchar) ::
                                                          (tptr tschar) ::
                                                          tuchar :: tuchar ::
                                                          tint :: tint ::
                                                          nil) tuchar
                                                         cc_default))
                                                     (Econs
                                                       (Evalof
                                                         (Evar _source (tptr tuchar))
                                                         (tptr tuchar))
                                                       (Econs
                                                         (Evalof
                                                           (Evar _kernel (tptr tschar))
                                                           (tptr tschar))
                                                         (Econs
                                                           (Evalof
                                                             (Evar _kernel_total tuchar)
                                                             tuchar)
                                                           (Econs
                                                             (Eval (Vint (Int.repr 8)) tint)
                                                             (Econs
                                                               (Ebinop Omul
                                                                 (Eval (Vint (Int.repr 2)) tint)
                                                                 (Evalof
                                                                   (Evar _width tint)
                                                                   tint)
                                                                 tint)
                                                               (Econs
                                                                 (Eval (Vint (Int.repr 1)) tint)
                                                                 Enil))))))
                                                     tuchar) tuchar))))))))))))))))
                (Sifthenelse (Ebinop Oeq
                               (Evalof
                                 (Efield
                                   (Evalof
                                     (Ederef
                                       (Evalof
                                         (Evar _output (tptr (Tstruct _image_t noattr)))
                                         (tptr (Tstruct _image_t noattr)))
                                       (Tstruct _image_t noattr))
                                     (Tstruct _image_t noattr)) _type tint)
                                 tint) (Eval (Vint (Int.repr 1)) tint) tint)
                  (Ssequence
                    (Sdo (Eassign
                           (Ederef
                             (Epostincr Incr (Evar _dest (tptr tuchar))
                               (tptr tuchar)) tuchar)
                           (Ecall
                             (Evalof
                               (Evar _ker_mul_3x3 (Tfunction
                                                    ((tptr tuchar) ::
                                                     (tptr tschar) ::
                                                     tuchar :: tuchar ::
                                                     tint :: tint :: nil)
                                                    tuchar cc_default))
                               (Tfunction
                                 ((tptr tuchar) :: (tptr tschar) :: tuchar ::
                                  tuchar :: tint :: tint :: nil) tuchar
                                 cc_default))
                             (Econs
                               (Evalof (Evar _source (tptr tuchar))
                                 (tptr tuchar))
                               (Econs
                                 (Evalof (Evar _kernel (tptr tschar))
                                   (tptr tschar))
                                 (Econs
                                   (Evalof (Evar _kernel_total tuchar)
                                     tuchar)
                                   (Econs (Eval (Vint (Int.repr 5)) tint)
                                     (Econs (Evalof (Evar _width tint) tint)
                                       (Econs (Eval (Vint (Int.repr 0)) tint)
                                         Enil)))))) tuchar) tuchar))
                    (Ssequence
                      (Sdo (Epostincr Incr (Evar _source (tptr tuchar))
                             (tptr tuchar)))
                      (Ssequence
                        (Ssequence
                          (Sdo (Eassign (Evar _x__3 tint)
                                 (Eval (Vint (Int.repr 1)) tint) tint))
                          (Sfor
                            Sskip
                            (Ebinop Olt (Evalof (Evar _x__3 tint) tint)
                              (Ebinop Osub (Evalof (Evar _width tint) tint)
                                (Eval (Vint (Int.repr 1)) tint) tint) tint)
                            (Sdo (Epostincr Incr (Evar _x__3 tint) tint))
                            (Ssequence
                              (Sdo (Eassign
                                     (Ederef
                                       (Epostincr Incr
                                         (Evar _dest (tptr tuchar))
                                         (tptr tuchar)) tuchar)
                                     (Ecall
                                       (Evalof
                                         (Evar _ker_mul_3x3 (Tfunction
                                                              ((tptr tuchar) ::
                                                               (tptr tschar) ::
                                                               tuchar ::
                                                               tuchar ::
                                                               tint ::
                                                               tint :: nil)
                                                              tuchar
                                                              cc_default))
                                         (Tfunction
                                           ((tptr tuchar) :: (tptr tschar) ::
                                            tuchar :: tuchar :: tint ::
                                            tint :: nil) tuchar cc_default))
                                       (Econs
                                         (Evalof (Evar _source (tptr tuchar))
                                           (tptr tuchar))
                                         (Econs
                                           (Evalof
                                             (Evar _kernel (tptr tschar))
                                             (tptr tschar))
                                           (Econs
                                             (Evalof
                                               (Evar _kernel_total tuchar)
                                               tuchar)
                                             (Econs
                                               (Eval (Vint (Int.repr 1)) tint)
                                               (Econs
                                                 (Evalof (Evar _width tint)
                                                   tint)
                                                 (Econs
                                                   (Eval (Vint (Int.repr 0)) tint)
                                                   Enil)))))) tuchar) tuchar))
                              (Sdo (Epostincr Incr
                                     (Evar _source (tptr tuchar))
                                     (tptr tuchar))))))
                        (Ssequence
                          (Sdo (Eassign
                                 (Ederef
                                   (Epostincr Incr (Evar _dest (tptr tuchar))
                                     (tptr tuchar)) tuchar)
                                 (Ecall
                                   (Evalof
                                     (Evar _ker_mul_3x3 (Tfunction
                                                          ((tptr tuchar) ::
                                                           (tptr tschar) ::
                                                           tuchar ::
                                                           tuchar :: tint ::
                                                           tint :: nil)
                                                          tuchar cc_default))
                                     (Tfunction
                                       ((tptr tuchar) :: (tptr tschar) ::
                                        tuchar :: tuchar :: tint :: tint ::
                                        nil) tuchar cc_default))
                                   (Econs
                                     (Evalof (Evar _source (tptr tuchar))
                                       (tptr tuchar))
                                     (Econs
                                       (Evalof (Evar _kernel (tptr tschar))
                                         (tptr tschar))
                                       (Econs
                                         (Evalof (Evar _kernel_total tuchar)
                                           tuchar)
                                         (Econs
                                           (Eval (Vint (Int.repr 6)) tint)
                                           (Econs
                                             (Evalof (Evar _width tint) tint)
                                             (Econs
                                               (Eval (Vint (Int.repr 0)) tint)
                                               Enil)))))) tuchar) tuchar))
                          (Ssequence
                            (Sdo (Epostincr Incr (Evar _source (tptr tuchar))
                                   (tptr tuchar)))
                            (Ssequence
                              (Ssequence
                                (Sdo (Eassign (Evar _y__1 tint)
                                       (Eval (Vint (Int.repr 1)) tint) tint))
                                (Sfor
                                  Sskip
                                  (Ebinop Olt (Evalof (Evar _y__1 tint) tint)
                                    (Ebinop Osub
                                      (Evalof (Evar _height tint) tint)
                                      (Eval (Vint (Int.repr 1)) tint) tint)
                                    tint)
                                  (Sdo (Epostincr Incr (Evar _y__1 tint)
                                         tint))
                                  (Ssequence
                                    (Sdo (Eassign
                                           (Ederef
                                             (Epostincr Incr
                                               (Evar _dest (tptr tuchar))
                                               (tptr tuchar)) tuchar)
                                           (Ecall
                                             (Evalof
                                               (Evar _ker_mul_3x3 (Tfunction
                                                                    ((tptr tuchar) ::
                                                                    (tptr tschar) ::
                                                                    tuchar ::
                                                                    tuchar ::
                                                                    tint ::
                                                                    tint ::
                                                                    nil)
                                                                    tuchar
                                                                    cc_default))
                                               (Tfunction
                                                 ((tptr tuchar) ::
                                                  (tptr tschar) :: tuchar ::
                                                  tuchar :: tint :: tint ::
                                                  nil) tuchar cc_default))
                                             (Econs
                                               (Evalof
                                                 (Evar _source (tptr tuchar))
                                                 (tptr tuchar))
                                               (Econs
                                                 (Evalof
                                                   (Evar _kernel (tptr tschar))
                                                   (tptr tschar))
                                                 (Econs
                                                   (Evalof
                                                     (Evar _kernel_total tuchar)
                                                     tuchar)
                                                   (Econs
                                                     (Eval (Vint (Int.repr 3)) tint)
                                                     (Econs
                                                       (Evalof
                                                         (Evar _width tint)
                                                         tint)
                                                       (Econs
                                                         (Eval (Vint (Int.repr 0)) tint)
                                                         Enil)))))) tuchar)
                                           tuchar))
                                    (Ssequence
                                      (Sdo (Epostincr Incr
                                             (Evar _source (tptr tuchar))
                                             (tptr tuchar)))
                                      (Ssequence
                                        (Ssequence
                                          (Sdo (Eassign (Evar _x__4 tint)
                                                 (Eval (Vint (Int.repr 1)) tint)
                                                 tint))
                                          (Sfor
                                            Sskip
                                            (Ebinop Olt
                                              (Evalof (Evar _x__4 tint) tint)
                                              (Ebinop Osub
                                                (Evalof (Evar _width tint)
                                                  tint)
                                                (Eval (Vint (Int.repr 1)) tint)
                                                tint) tint)
                                            (Sdo (Epostincr Incr
                                                   (Evar _x__4 tint) tint))
                                            (Ssequence
                                              (Sdo (Eassign
                                                     (Ederef
                                                       (Epostincr Incr
                                                         (Evar _dest (tptr tuchar))
                                                         (tptr tuchar))
                                                       tuchar)
                                                     (Ecall
                                                       (Evalof
                                                         (Evar _ker_mul_3x3 
                                                         (Tfunction
                                                           ((tptr tuchar) ::
                                                            (tptr tschar) ::
                                                            tuchar ::
                                                            tuchar :: tint ::
                                                            tint :: nil)
                                                           tuchar cc_default))
                                                         (Tfunction
                                                           ((tptr tuchar) ::
                                                            (tptr tschar) ::
                                                            tuchar ::
                                                            tuchar :: tint ::
                                                            tint :: nil)
                                                           tuchar cc_default))
                                                       (Econs
                                                         (Evalof
                                                           (Evar _source (tptr tuchar))
                                                           (tptr tuchar))
                                                         (Econs
                                                           (Evalof
                                                             (Evar _kernel (tptr tschar))
                                                             (tptr tschar))
                                                           (Econs
                                                             (Evalof
                                                               (Evar _kernel_total tuchar)
                                                               tuchar)
                                                             (Econs
                                                               (Eval (Vint (Int.repr 0)) tint)
                                                               (Econs
                                                                 (Evalof
                                                                   (Evar _width tint)
                                                                   tint)
                                                                 (Econs
                                                                   (Eval (Vint (Int.repr 0)) tint)
                                                                   Enil))))))
                                                       tuchar) tuchar))
                                              (Sdo (Epostincr Incr
                                                     (Evar _source (tptr tuchar))
                                                     (tptr tuchar))))))
                                        (Ssequence
                                          (Sdo (Eassign
                                                 (Ederef
                                                   (Epostincr Incr
                                                     (Evar _dest (tptr tuchar))
                                                     (tptr tuchar)) tuchar)
                                                 (Ecall
                                                   (Evalof
                                                     (Evar _ker_mul_3x3 
                                                     (Tfunction
                                                       ((tptr tuchar) ::
                                                        (tptr tschar) ::
                                                        tuchar :: tuchar ::
                                                        tint :: tint :: nil)
                                                       tuchar cc_default))
                                                     (Tfunction
                                                       ((tptr tuchar) ::
                                                        (tptr tschar) ::
                                                        tuchar :: tuchar ::
                                                        tint :: tint :: nil)
                                                       tuchar cc_default))
                                                   (Econs
                                                     (Evalof
                                                       (Evar _source (tptr tuchar))
                                                       (tptr tuchar))
                                                     (Econs
                                                       (Evalof
                                                         (Evar _kernel (tptr tschar))
                                                         (tptr tschar))
                                                       (Econs
                                                         (Evalof
                                                           (Evar _kernel_total tuchar)
                                                           tuchar)
                                                         (Econs
                                                           (Eval (Vint (Int.repr 4)) tint)
                                                           (Econs
                                                             (Evalof
                                                               (Evar _width tint)
                                                               tint)
                                                             (Econs
                                                               (Eval (Vint (Int.repr 0)) tint)
                                                               Enil))))))
                                                   tuchar) tuchar))
                                          (Sdo (Epostincr Incr
                                                 (Evar _source (tptr tuchar))
                                                 (tptr tuchar)))))))))
                              (Ssequence
                                (Sdo (Eassign
                                       (Ederef
                                         (Epostincr Incr
                                           (Evar _dest (tptr tuchar))
                                           (tptr tuchar)) tuchar)
                                       (Ecall
                                         (Evalof
                                           (Evar _ker_mul_3x3 (Tfunction
                                                                ((tptr tuchar) ::
                                                                 (tptr tschar) ::
                                                                 tuchar ::
                                                                 tuchar ::
                                                                 tint ::
                                                                 tint :: nil)
                                                                tuchar
                                                                cc_default))
                                           (Tfunction
                                             ((tptr tuchar) ::
                                              (tptr tschar) :: tuchar ::
                                              tuchar :: tint :: tint :: nil)
                                             tuchar cc_default))
                                         (Econs
                                           (Evalof
                                             (Evar _source (tptr tuchar))
                                             (tptr tuchar))
                                           (Econs
                                             (Evalof
                                               (Evar _kernel (tptr tschar))
                                               (tptr tschar))
                                             (Econs
                                               (Evalof
                                                 (Evar _kernel_total tuchar)
                                                 tuchar)
                                               (Econs
                                                 (Eval (Vint (Int.repr 7)) tint)
                                                 (Econs
                                                   (Evalof (Evar _width tint)
                                                     tint)
                                                   (Econs
                                                     (Eval (Vint (Int.repr 0)) tint)
                                                     Enil)))))) tuchar)
                                       tuchar))
                                (Ssequence
                                  (Sdo (Epostincr Incr
                                         (Evar _source (tptr tuchar))
                                         (tptr tuchar)))
                                  (Ssequence
                                    (Ssequence
                                      (Sdo (Eassign (Evar _x__5 tint)
                                             (Eval (Vint (Int.repr 1)) tint)
                                             tint))
                                      (Sfor
                                        Sskip
                                        (Ebinop Olt
                                          (Evalof (Evar _x__5 tint) tint)
                                          (Ebinop Osub
                                            (Evalof (Evar _width tint) tint)
                                            (Eval (Vint (Int.repr 1)) tint)
                                            tint) tint)
                                        (Sdo (Epostincr Incr
                                               (Evar _x__5 tint) tint))
                                        (Ssequence
                                          (Sdo (Eassign
                                                 (Ederef
                                                   (Epostincr Incr
                                                     (Evar _dest (tptr tuchar))
                                                     (tptr tuchar)) tuchar)
                                                 (Ecall
                                                   (Evalof
                                                     (Evar _ker_mul_3x3 
                                                     (Tfunction
                                                       ((tptr tuchar) ::
                                                        (tptr tschar) ::
                                                        tuchar :: tuchar ::
                                                        tint :: tint :: nil)
                                                       tuchar cc_default))
                                                     (Tfunction
                                                       ((tptr tuchar) ::
                                                        (tptr tschar) ::
                                                        tuchar :: tuchar ::
                                                        tint :: tint :: nil)
                                                       tuchar cc_default))
                                                   (Econs
                                                     (Evalof
                                                       (Evar _source (tptr tuchar))
                                                       (tptr tuchar))
                                                     (Econs
                                                       (Evalof
                                                         (Evar _kernel (tptr tschar))
                                                         (tptr tschar))
                                                       (Econs
                                                         (Evalof
                                                           (Evar _kernel_total tuchar)
                                                           tuchar)
                                                         (Econs
                                                           (Eval (Vint (Int.repr 2)) tint)
                                                           (Econs
                                                             (Evalof
                                                               (Evar _width tint)
                                                               tint)
                                                             (Econs
                                                               (Eval (Vint (Int.repr 0)) tint)
                                                               Enil))))))
                                                   tuchar) tuchar))
                                          (Sdo (Epostincr Incr
                                                 (Evar _source (tptr tuchar))
                                                 (tptr tuchar))))))
                                    (Sdo (Eassign
                                           (Ederef
                                             (Evalof
                                               (Evar _dest (tptr tuchar))
                                               (tptr tuchar)) tuchar)
                                           (Ecall
                                             (Evalof
                                               (Evar _ker_mul_3x3 (Tfunction
                                                                    ((tptr tuchar) ::
                                                                    (tptr tschar) ::
                                                                    tuchar ::
                                                                    tuchar ::
                                                                    tint ::
                                                                    tint ::
                                                                    nil)
                                                                    tuchar
                                                                    cc_default))
                                               (Tfunction
                                                 ((tptr tuchar) ::
                                                  (tptr tschar) :: tuchar ::
                                                  tuchar :: tint :: tint ::
                                                  nil) tuchar cc_default))
                                             (Econs
                                               (Evalof
                                                 (Evar _source (tptr tuchar))
                                                 (tptr tuchar))
                                               (Econs
                                                 (Evalof
                                                   (Evar _kernel (tptr tschar))
                                                   (tptr tschar))
                                                 (Econs
                                                   (Evalof
                                                     (Evar _kernel_total tuchar)
                                                     tuchar)
                                                   (Econs
                                                     (Eval (Vint (Int.repr 8)) tint)
                                                     (Econs
                                                       (Evalof
                                                         (Evar _width tint)
                                                         tint)
                                                       (Econs
                                                         (Eval (Vint (Int.repr 0)) tint)
                                                         Enil)))))) tuchar)
                                           tuchar)))))))))))
                  Sskip)))))))))
|}.

Definition v_five_keep_image_create := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _image_create (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_image_free := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _image_free (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_image_copy := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _image_copy (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_image_switch := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _image_switch (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_image_to_grayscale := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _image_to_grayscale (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_image_yuv422_colorfilt := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _image_yuv422_colorfilt (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_check_color_yuv422 := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _check_color_yuv422 (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_set_color_yuv422 := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _set_color_yuv422 (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_image_yuv422_downsample := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _image_yuv422_downsample (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_image_add_border := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _image_add_border (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_pyramid_next_level := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _pyramid_next_level (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_pyramid_build := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _pyramid_build (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_image_subpixel_window := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _image_subpixel_window (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_image_gradients := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _image_gradients (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_image_calculate_g := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _image_calculate_g (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_image_difference := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _image_difference (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_image_multiply := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _image_multiply (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_image_show_points := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _image_show_points (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_image_show_points_color := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _image_show_points_color (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_image_show_flow := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _image_show_flow (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_image_show_flow_color := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _image_show_flow_color (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_image_gradient_pixel := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _image_gradient_pixel (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_image_draw_rectangle := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _image_draw_rectangle (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_image_draw_crosshair := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _image_draw_crosshair (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_image_draw_line := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _image_draw_line (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_image_draw_line_color := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _image_draw_line_color (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_ker_mul_3x3 := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _ker_mul_3x3 (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition v_five_keep_image_convolution_3x3 := {|
  gvar_info := (tptr (Tfunction nil tvoid cc_default));
  gvar_init := (Init_addrof _image_convolution_3x3 (Ptrofs.repr 0) :: nil);
  gvar_readonly := false;
  gvar_volatile := false
|}.

Definition composites : list composite_definition :=
(Composite _timeval Struct
   (Member_plain _tv_sec tlong :: Member_plain _tv_usec tlong :: nil)
   noattr ::
 Composite _FloatEulers Struct
   (Member_plain _phi tfloat :: Member_plain _theta tfloat ::
    Member_plain _psi tfloat :: nil)
   noattr ::
 Composite _image_t Struct
   (Member_plain _type tint :: Member_plain _w tushort ::
    Member_plain _h tushort :: Member_plain _ts (Tstruct _timeval noattr) ::
    Member_plain _eulers (Tstruct _FloatEulers noattr) ::
    Member_plain _pprz_ts tuint :: Member_plain _buf_idx tuchar ::
    Member_plain _buf_size tuint :: Member_plain _buf (tptr tvoid) :: nil)
   noattr ::
 Composite _point_t Struct
   (Member_plain _x tuint :: Member_plain _y tuint ::
    Member_plain _count tushort :: Member_plain _x_sub tushort ::
    Member_plain _y_sub tushort :: nil)
   noattr ::
 Composite _flow_t Struct
   (Member_plain _pos (Tstruct _point_t noattr) ::
    Member_plain _flow_x tint :: Member_plain _flow_y tint ::
    Member_plain _error tuint :: nil)
   noattr :: nil).

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
 (_roundf,
   Gfun(External (EF_external "roundf"
                   (mksignature (AST.Xsingle :: nil) AST.Xsingle cc_default))
     (tfloat :: nil) tfloat cc_default)) ::
 (_memcpy,
   Gfun(External (EF_external "memcpy"
                   (mksignature (AST.Xptr :: AST.Xptr :: AST.Xlong :: nil)
                     AST.Xptr cc_default))
     ((tptr tvoid) :: (tptr tvoid) :: tulong :: nil) (tptr tvoid)
     cc_default)) ::
 (_free, Gfun(External EF_free ((tptr tvoid) :: nil) tvoid cc_default)) ::
 (_aligned_alloc,
   Gfun(External (EF_external "aligned_alloc"
                   (mksignature (AST.Xlong :: AST.Xlong :: nil) AST.Xptr
                     cc_default)) (tulong :: tulong :: nil) (tptr tvoid)
     cc_default)) ::
 (_abs,
   Gfun(External (EF_external "abs"
                   (mksignature (AST.Xint :: nil) AST.Xint cc_default))
     (tint :: nil) tint cc_default)) ::
 (_image_create, Gfun(Internal f_image_create)) ::
 (_image_free, Gfun(Internal f_image_free)) ::
 (_image_copy, Gfun(Internal f_image_copy)) ::
 (_image_switch, Gfun(Internal f_image_switch)) ::
 (_image_to_grayscale, Gfun(Internal f_image_to_grayscale)) ::
 (_image_yuv422_colorfilt, Gfun(Internal f_image_yuv422_colorfilt)) ::
 (_check_color_yuv422, Gfun(Internal f_check_color_yuv422)) ::
 (_set_color_yuv422, Gfun(Internal f_set_color_yuv422)) ::
 (_image_yuv422_downsample, Gfun(Internal f_image_yuv422_downsample)) ::
 (_image_add_border, Gfun(Internal f_image_add_border)) ::
 (_pyramid_next_level, Gfun(Internal f_pyramid_next_level)) ::
 (_pyramid_build, Gfun(Internal f_pyramid_build)) ::
 (_image_subpixel_window, Gfun(Internal f_image_subpixel_window)) ::
 (_image_gradients, Gfun(Internal f_image_gradients)) ::
 (_image_calculate_g, Gfun(Internal f_image_calculate_g)) ::
 (_image_difference, Gfun(Internal f_image_difference)) ::
 (_image_multiply, Gfun(Internal f_image_multiply)) ::
 (_image_show_points, Gfun(Internal f_image_show_points)) ::
 (_image_show_points_color, Gfun(Internal f_image_show_points_color)) ::
 (_color, Gvar v_color) :: (_bad_color, Gvar v_bad_color) ::
 (_image_show_flow, Gfun(Internal f_image_show_flow)) ::
 (_size_crosshair, Gvar v_size_crosshair) ::
 (_image_show_flow_color, Gfun(Internal f_image_show_flow_color)) ::
 (_Sobel, Gvar v_Sobel) :: (_total_sobel, Gvar v_total_sobel) ::
 (_image_gradient_pixel, Gfun(Internal f_image_gradient_pixel)) ::
 (_image_draw_rectangle, Gfun(Internal f_image_draw_rectangle)) ::
 (_image_draw_crosshair, Gfun(Internal f_image_draw_crosshair)) ::
 (_color__1, Gvar v_color__1) ::
 (_image_draw_line, Gfun(Internal f_image_draw_line)) ::
 (_image_draw_line_color, Gfun(Internal f_image_draw_line_color)) ::
 (_ker_mul_3x3, Gfun(Internal f_ker_mul_3x3)) ::
 (_image_convolution_3x3, Gfun(Internal f_image_convolution_3x3)) ::
 (_five_keep_image_create, Gvar v_five_keep_image_create) ::
 (_five_keep_image_free, Gvar v_five_keep_image_free) ::
 (_five_keep_image_copy, Gvar v_five_keep_image_copy) ::
 (_five_keep_image_switch, Gvar v_five_keep_image_switch) ::
 (_five_keep_image_to_grayscale, Gvar v_five_keep_image_to_grayscale) ::
 (_five_keep_image_yuv422_colorfilt, Gvar v_five_keep_image_yuv422_colorfilt) ::
 (_five_keep_check_color_yuv422, Gvar v_five_keep_check_color_yuv422) ::
 (_five_keep_set_color_yuv422, Gvar v_five_keep_set_color_yuv422) ::
 (_five_keep_image_yuv422_downsample, Gvar v_five_keep_image_yuv422_downsample) ::
 (_five_keep_image_add_border, Gvar v_five_keep_image_add_border) ::
 (_five_keep_pyramid_next_level, Gvar v_five_keep_pyramid_next_level) ::
 (_five_keep_pyramid_build, Gvar v_five_keep_pyramid_build) ::
 (_five_keep_image_subpixel_window, Gvar v_five_keep_image_subpixel_window) ::
 (_five_keep_image_gradients, Gvar v_five_keep_image_gradients) ::
 (_five_keep_image_calculate_g, Gvar v_five_keep_image_calculate_g) ::
 (_five_keep_image_difference, Gvar v_five_keep_image_difference) ::
 (_five_keep_image_multiply, Gvar v_five_keep_image_multiply) ::
 (_five_keep_image_show_points, Gvar v_five_keep_image_show_points) ::
 (_five_keep_image_show_points_color, Gvar v_five_keep_image_show_points_color) ::
 (_five_keep_image_show_flow, Gvar v_five_keep_image_show_flow) ::
 (_five_keep_image_show_flow_color, Gvar v_five_keep_image_show_flow_color) ::
 (_five_keep_image_gradient_pixel, Gvar v_five_keep_image_gradient_pixel) ::
 (_five_keep_image_draw_rectangle, Gvar v_five_keep_image_draw_rectangle) ::
 (_five_keep_image_draw_crosshair, Gvar v_five_keep_image_draw_crosshair) ::
 (_five_keep_image_draw_line, Gvar v_five_keep_image_draw_line) ::
 (_five_keep_image_draw_line_color, Gvar v_five_keep_image_draw_line_color) ::
 (_five_keep_ker_mul_3x3, Gvar v_five_keep_ker_mul_3x3) ::
 (_five_keep_image_convolution_3x3, Gvar v_five_keep_image_convolution_3x3) ::
 nil).

Definition public_idents : list ident :=
(_five_keep_image_convolution_3x3 :: _five_keep_ker_mul_3x3 ::
 _five_keep_image_draw_line_color :: _five_keep_image_draw_line ::
 _five_keep_image_draw_crosshair :: _five_keep_image_draw_rectangle ::
 _five_keep_image_gradient_pixel :: _five_keep_image_show_flow_color ::
 _five_keep_image_show_flow :: _five_keep_image_show_points_color ::
 _five_keep_image_show_points :: _five_keep_image_multiply ::
 _five_keep_image_difference :: _five_keep_image_calculate_g ::
 _five_keep_image_gradients :: _five_keep_image_subpixel_window ::
 _five_keep_pyramid_build :: _five_keep_pyramid_next_level ::
 _five_keep_image_add_border :: _five_keep_image_yuv422_downsample ::
 _five_keep_set_color_yuv422 :: _five_keep_check_color_yuv422 ::
 _five_keep_image_yuv422_colorfilt :: _five_keep_image_to_grayscale ::
 _five_keep_image_switch :: _five_keep_image_copy :: _five_keep_image_free ::
 _five_keep_image_create :: _image_convolution_3x3 :: _ker_mul_3x3 ::
 _image_draw_line_color :: _image_draw_line :: _image_draw_crosshair ::
 _image_draw_rectangle :: _image_gradient_pixel :: _image_show_flow_color ::
 _image_show_flow :: _image_show_points_color :: _image_show_points ::
 _image_multiply :: _image_difference :: _image_calculate_g ::
 _image_gradients :: _image_subpixel_window :: _pyramid_build ::
 _pyramid_next_level :: _image_add_border :: _image_yuv422_downsample ::
 _set_color_yuv422 :: _check_color_yuv422 :: _image_yuv422_colorfilt ::
 _image_to_grayscale :: _image_switch :: _image_copy :: _image_free ::
 _image_create :: _abs :: _aligned_alloc :: _free :: _memcpy :: _roundf ::
 ___builtin_debug :: ___builtin_write32_reversed ::
 ___builtin_write16_reversed :: ___builtin_read32_reversed ::
 ___builtin_read16_reversed :: ___builtin_fnmsub :: ___builtin_fnmadd ::
 ___builtin_fmsub :: ___builtin_fmadd :: ___builtin_fmin ::
 ___builtin_fmax :: ___builtin_expect :: ___builtin_unreachable ::
 ___builtin_va_end :: ___builtin_va_copy :: ___builtin_va_arg ::
 ___builtin_va_start :: ___builtin_membar :: ___builtin_annot_intval ::
 ___builtin_annot :: ___builtin_sel :: ___builtin_memcpy_aligned ::
 ___builtin_sqrt :: ___builtin_fsqrt :: ___builtin_fabsf ::
 ___builtin_fabs :: ___builtin_ctzll :: ___builtin_ctzl :: ___builtin_ctz ::
 ___builtin_clzll :: ___builtin_clzl :: ___builtin_clz ::
 ___builtin_bswap16 :: ___builtin_bswap32 :: ___builtin_bswap ::
 ___builtin_bswap64 :: ___builtin_ais_annot :: ___compcert_i64_umulh ::
 ___compcert_i64_smulh :: ___compcert_i64_sar :: ___compcert_i64_shr ::
 ___compcert_i64_shl :: ___compcert_i64_umod :: ___compcert_i64_smod ::
 ___compcert_i64_udiv :: ___compcert_i64_sdiv :: ___compcert_i64_utof ::
 ___compcert_i64_stof :: ___compcert_i64_utod :: ___compcert_i64_stod ::
 ___compcert_i64_dtou :: ___compcert_i64_dtos :: ___compcert_va_composite ::
 ___compcert_va_float64 :: ___compcert_va_int64 :: ___compcert_va_int32 ::
 nil).

Definition prog : Csyntax.program := 
  mkprogram composites global_definitions public_idents _main Logic.I.


