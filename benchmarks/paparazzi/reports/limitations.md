# CompCert import limitations observed in Paparazzi

Pinned upstream: `abfee3dd56eeab12c528635504a429db3daf409a`. Tested frontend: CompCert 3.17, x86-64 Linux little endian. This file records actual rejected translation units in this configuration. A failed unit does not establish that every selected function in it is individually unsupported. Rejected entries are excluded from the completed count.

## decomposition

Source: `sw/airborne/math/pprz_matrix_decomp_float.c`

Selected entries: `pprz_cholesky_float`, `pprz_qr_float`, `pprz_svd_float`, `pprz_svd_solve_float`

Generation record: `runs/20261103T141724-5d72d65ba8/five-align`

Command: `['/home/yangfp/.opam/five/bin/clightgen', '-csyntax', '-o', '/home/yangfp/five/_build/paparazzi/models/decomposition/model/Source.v', '/home/yangfp/five/_build/paparazzi/models/decomposition/model/preprocessed.i']`

```text
/home/yangfp/five/_build/paparazzi/overlay/math/pprz_matrix_decomp_float.h:117: error: size of array is not a compile-time constant
/home/yangfp/five/_build/paparazzi/overlay/math/pprz_matrix_decomp_float.h:135: error: size of array is not a compile-time constant
/home/yangfp/five/_build/paparazzi/models/decomposition/Program.c:53: error: size of array is not a compile-time constant
/home/yangfp/five/_build/paparazzi/models/decomposition/Program.c:53: error: size of array is not a compile-time constant
/home/yangfp/five/_build/paparazzi/models/decomposition/Program.c:54: error: size of array is not a compile-time constant
/home/yangfp/five/_build/paparazzi/models/decomposition/Program.c:92: error: size of array is not a compile-time constant
/home/yangfp/five/_build/paparazzi/models/decomposition/Program.c:92: error: size of array is not a compile-time constant
/home/yangfp/five/_build/paparazzi/models/decomposition/Program.c:92: error: size of array is not a compile-time constant
/home/yangfp/five/_build/paparazzi/models/decomposition/Program.c:93: error: size of array is not a compile-time constant
/home/yangfp/five/_build/paparazzi/models/decomposition/Program.c:93: error: size of array is not a compile-time constant
/home/yangfp/five/_build/paparazzi/models/decomposition/Program.c:94: error: size of array is not a compile-time constant
/home/yangfp/five/_build/paparazzi/models/decomposition/Program.c:94: error: size of array is not a compile-time constant
/home/yangfp/five/_build/paparazzi/models/decomposition/Program.c:94: error: size of array is not a compile-time constant
/home/yangfp/five/_build/paparazzi/models/decomposition/Program.c:94: error: size of array is not a compile-time constant
/home/yangfp/five/_build/paparazzi/models/decomposition/Program.c:94: error: size of array is not a compile-time constant
/home/yangfp/five/_build/paparazzi/models/decomposition/Program.c:94: error: size of array is not a compile-time constant
/home/yangfp/five/_build/paparazzi/models/decomposition/Program.c:95: error: size of array is not a compile-time constant
/home/yangfp/five/_build/paparazzi/models/decomposition/Program.c:96: error: size of array is not a compile-time constant
/home/yangfp/five/_build/paparazzi/models/decomposition/Program.c:97: error: size of array is not a compile-time constant
/home/yangfp/five/_build/paparazzi/models/decomposition/Program.c:101: error: size of array is not a compile-time constant
/home/yangfp/five/_build/paparazzi/models/decomposition/Program.c:101: error: size of array is not a compile-time constant
/home/yangfp/five/_build/paparazzi/models/decomposition/Program.c:175: error: size of array is not a compile-time constant
/home/yangfp/five/_build/paparazzi/models/decomposition/Program.c:498: error: size of array is not a compile-time constant
23 errors detected.

```

## linear_kalman

Source: `sw/airborne/filters/linear_kalman_filter.c`

Selected entries: `linear_kalman_filter_init`, `linear_kalman_filter_predict`, `linear_kalman_filter_update`

Generation record: `runs/20261103T141805-d212665da4/five-align`

Command: `['/home/yangfp/.opam/five/bin/clightgen', '-csyntax', '-o', '/home/yangfp/five/_build/paparazzi/models/linear_kalman/model/Source.v', '/home/yangfp/five/_build/paparazzi/models/linear_kalman/model/preprocessed.i']`

```text
/home/yangfp/five/_build/paparazzi/models/linear_kalman/Program.c:51: error: size of array is not a compile-time constant
/home/yangfp/five/_build/paparazzi/models/linear_kalman/Program.c:53: error: size of array is not a compile-time constant
/home/yangfp/five/_build/paparazzi/models/linear_kalman/Program.c:55: error: size of array is not a compile-time constant
/home/yangfp/five/_build/paparazzi/models/linear_kalman/Program.c:57: error: size of array is not a compile-time constant
/home/yangfp/five/_build/paparazzi/models/linear_kalman/Program.c:59: error: size of array is not a compile-time constant
/home/yangfp/five/_build/paparazzi/models/linear_kalman/Program.c:61: error: size of array is not a compile-time constant
/home/yangfp/five/_build/paparazzi/models/linear_kalman/Program.c:80: error: size of array is not a compile-time constant
/home/yangfp/five/_build/paparazzi/models/linear_kalman/Program.c:81: error: size of array is not a compile-time constant
/home/yangfp/five/_build/paparazzi/models/linear_kalman/Program.c:82: error: size of array is not a compile-time constant
/home/yangfp/five/_build/paparazzi/models/linear_kalman/Program.c:82: error: size of array is not a compile-time constant
/home/yangfp/five/_build/paparazzi/models/linear_kalman/Program.c:84: error: size of array is not a compile-time constant
/home/yangfp/five/_build/paparazzi/models/linear_kalman/Program.c:85: error: size of array is not a compile-time constant
/home/yangfp/five/_build/paparazzi/models/linear_kalman/Program.c:86: error: size of array is not a compile-time constant
/home/yangfp/five/_build/paparazzi/models/linear_kalman/Program.c:87: error: size of array is not a compile-time constant
/home/yangfp/five/_build/paparazzi/models/linear_kalman/Program.c:88: error: size of array is not a compile-time constant
/home/yangfp/five/_build/paparazzi/models/linear_kalman/Program.c:113: error: size of array is not a compile-time constant
/home/yangfp/five/_build/paparazzi/models/linear_kalman/Program.c:113: error: size of array is not a compile-time constant
/home/yangfp/five/_build/paparazzi/models/linear_kalman/Program.c:114: error: size of array is not a compile-time constant
/home/yangfp/five/_build/paparazzi/models/linear_kalman/Program.c:114: error: size of array is not a compile-time constant
/home/yangfp/five/_build/paparazzi/models/linear_kalman/Program.c:115: error: size of array is not a compile-time constant
/home/yangfp/five/_build/paparazzi/models/linear_kalman/Program.c:115: error: size of array is not a compile-time constant
/home/yangfp/five/_build/paparazzi/models/linear_kalman/Program.c:116: error: size of array is not a compile-time constant
/home/yangfp/five/_build/paparazzi/models/linear_kalman/Program.c:116: error: size of array is not a compile-time constant
/home/yangfp/five/_build/paparazzi/models/linear_kalman/Program.c:118: error: size of array is not a compile-time constant
/home/yangfp/five/_build/paparazzi/models/linear_kalman/Program.c:119: error: size of array is not a compile-time constant
/home/yangfp/five/_build/paparazzi/models/linear_kalman/Program.c:120: error: size of array is not a compile-time constant
/home/yangfp/five/_build/paparazzi/models/linear_kalman/Program.c:121: error: size of array is not a compile-time constant
/home/yangfp/five/_build/paparazzi/models/linear_kalman/Program.c:122: error: size of array is not a compile-time constant
/home/yangfp/five/_build/paparazzi/models/linear_kalman/Program.c:123: error: size of array is not a compile-time constant
/home/yangfp/five/_build/paparazzi/models/linear_kalman/Program.c:124: error: size of array is not a compile-time constant
/home/yangfp/five/_build/paparazzi/models/linear_kalman/Program.c:137: warning: implicit declaration of function 'float_mat_mul_copy' is invalid in C99 [-Wimplicit-function-declaration]
/home/yangfp/five/_build/paparazzi/models/linear_kalman/Program.c:141: error: size of array is not a compile-time constant
/home/yangfp/five/_build/paparazzi/models/linear_kalman/Program.c:142: error: size of array is not a compile-time constant
32 errors detected.

```

## complementary_arrays

Source: `sw/airborne/filters/complementary_filter_types.h`

Selected entries: `init_first_order_complementary_array`, `update_first_order_complementary_array`, `reset_first_order_complementary_array`, `get_first_order_complementary_array`, `init_butterworth_2_complementary_array`, `update_butterworth_2_complementary_array`, `reset_butterworth_2_complementary_array`, `get_butterworth_2_complementary_array`, `init_butterworth_4_complementary_array`, `update_butterworth_4_complementary_array`, `reset_butterworth_4_complementary_array`, `get_butterworth_4_complementary_array`

Generation record: `runs/20261103T143444-edc743f257/five-align`

Command: `['/home/yangfp/.opam/five/bin/clightgen', '-csyntax', '-o', '/home/yangfp/five/_build/paparazzi/expansion-models/complementary_arrays/model/Source.v', '/home/yangfp/five/_build/paparazzi/expansion-models/complementary_arrays/model/preprocessed.i']`

```text
/home/yangfp/five/_build/paparazzi/upstream/sw/airborne/filters/complementary_filter_types.h:165: error: size of array is not a compile-time constant
/home/yangfp/five/_build/paparazzi/upstream/sw/airborne/filters/complementary_filter_types.h:165: error: size of array is not a compile-time constant
/home/yangfp/five/_build/paparazzi/upstream/sw/airborne/filters/complementary_filter_types.h:181: error: size of array is not a compile-time constant
/home/yangfp/five/_build/paparazzi/upstream/sw/airborne/filters/complementary_filter_types.h:181: error: size of array is not a compile-time constant
/home/yangfp/five/_build/paparazzi/upstream/sw/airborne/filters/complementary_filter_types.h:182: error: size of array is not a compile-time constant
/home/yangfp/five/_build/paparazzi/upstream/sw/airborne/filters/complementary_filter_types.h:197: error: size of array is not a compile-time constant
/home/yangfp/five/_build/paparazzi/upstream/sw/airborne/filters/complementary_filter_types.h:197: error: size of array is not a compile-time constant
/home/yangfp/five/_build/paparazzi/upstream/sw/airborne/filters/complementary_filter_types.h:212: error: size of array is not a compile-time constant
/home/yangfp/five/_build/paparazzi/upstream/sw/airborne/filters/complementary_filter_types.h:212: error: size of array is not a compile-time constant
/home/yangfp/five/_build/paparazzi/upstream/sw/airborne/filters/complementary_filter_types.h:346: error: size of array is not a compile-time constant
/home/yangfp/five/_build/paparazzi/upstream/sw/airborne/filters/complementary_filter_types.h:347: error: size of array is not a compile-time constant
/home/yangfp/five/_build/paparazzi/upstream/sw/airborne/filters/complementary_filter_types.h:363: error: size of array is not a compile-time constant
/home/yangfp/five/_build/paparazzi/upstream/sw/airborne/filters/complementary_filter_types.h:363: error: size of array is not a compile-time constant
/home/yangfp/five/_build/paparazzi/upstream/sw/airborne/filters/complementary_filter_types.h:364: error: size of array is not a compile-time constant
/home/yangfp/five/_build/paparazzi/upstream/sw/airborne/filters/complementary_filter_types.h:379: error: size of array is not a compile-time constant
/home/yangfp/five/_build/paparazzi/upstream/sw/airborne/filters/complementary_filter_types.h:379: error: size of array is not a compile-time constant
/home/yangfp/five/_build/paparazzi/upstream/sw/airborne/filters/complementary_filter_types.h:393: error: size of array is not a compile-time constant
/home/yangfp/five/_build/paparazzi/upstream/sw/airborne/filters/complementary_filter_types.h:393: error: size of array is not a compile-time constant
/home/yangfp/five/_build/paparazzi/upstream/sw/airborne/filters/complementary_filter_types.h:527: error: size of array is not a compile-time constant
/home/yangfp/five/_build/paparazzi/upstream/sw/airborne/filters/complementary_filter_types.h:528: error: size of array is not a compile-time constant
/home/yangfp/five/_build/paparazzi/upstream/sw/airborne/filters/complementary_filter_types.h:544: error: size of array is not a compile-time constant
/home/yangfp/five/_build/paparazzi/upstream/sw/airborne/filters/complementary_filter_types.h:544: error: size of array is not a compile-time constant
/home/yangfp/five/_build/paparazzi/upstream/sw/airborne/filters/complementary_filter_types.h:545: error: size of array is not a compile-time constant
/home/yangfp/five/_build/paparazzi/upstream/sw/airborne/filters/complementary_filter_types.h:560: error: size of array is not a compile-time constant
/home/yangfp/five/_build/paparazzi/upstream/sw/airborne/filters/complementary_filter_types.h:560: error: size of array is not a compile-time constant
/home/yangfp/five/_build/paparazzi/upstream/sw/airborne/filters/complementary_filter_types.h:575: error: size of array is not a compile-time constant
/home/yangfp/five/_build/paparazzi/upstream/sw/airborne/filters/complementary_filter_types.h:575: error: size of array is not a compile-time constant
27 errors detected.

```

## delay_arrays

Source: `sw/airborne/filters/transport_delay_types.h`

Selected entries: `init_transport_delay_array`, `update_transport_delay_array`, `reset_transport_delay_array`, `get_transport_delay_array`

Generation record: `runs/20261103T143611-2822b541ff/five-align`

Command: `['/home/yangfp/.opam/five/bin/clightgen', '-csyntax', '-o', '/home/yangfp/five/_build/paparazzi/expansion-models/delay_arrays/model/Source.v', '/home/yangfp/five/_build/paparazzi/expansion-models/delay_arrays/model/preprocessed.i']`

```text
/home/yangfp/five/_build/paparazzi/upstream/sw/airborne/filters/transport_delay_types.h:38: error: size of array is not a compile-time constant
/home/yangfp/five/_build/paparazzi/upstream/sw/airborne/filters/transport_delay_types.h:39: error: size of array is not a compile-time constant
/home/yangfp/five/_build/paparazzi/upstream/sw/airborne/filters/transport_delay_types.h:39: error: size of array is not a compile-time constant
/home/yangfp/five/_build/paparazzi/upstream/sw/airborne/filters/transport_delay_types.h:52: error: size of array is not a compile-time constant
/home/yangfp/five/_build/paparazzi/upstream/sw/airborne/filters/transport_delay_types.h:53: error: size of array is not a compile-time constant
/home/yangfp/five/_build/paparazzi/upstream/sw/airborne/filters/transport_delay_types.h:66: error: size of array is not a compile-time constant
/home/yangfp/five/_build/paparazzi/upstream/sw/airborne/filters/transport_delay_types.h:67: error: size of array is not a compile-time constant
/home/yangfp/five/_build/paparazzi/upstream/sw/airborne/filters/transport_delay_types.h:80: error: size of array is not a compile-time constant
/home/yangfp/five/_build/paparazzi/upstream/sw/airborne/filters/transport_delay_types.h:81: error: size of array is not a compile-time constant
9 errors detected.

```

## zoh_arrays

Source: `sw/airborne/filters/low_pass_zoh_filter_types.h`

Selected entries: `init_first_order_zoh_low_pass_array`, `update_first_order_zoh_low_pass_array`, `reset_first_order_zoh_low_pass_array`, `get_first_order_zoh_low_pass_array`

Generation record: `runs/20261103T143656-5744ee3337/five-align`

Command: `['/home/yangfp/.opam/five/bin/clightgen', '-csyntax', '-o', '/home/yangfp/five/_build/paparazzi/expansion-models/zoh_arrays/model/Source.v', '/home/yangfp/five/_build/paparazzi/expansion-models/zoh_arrays/model/preprocessed.i']`

```text
/home/yangfp/five/_build/paparazzi/upstream/sw/airborne/filters/low_pass_zoh_filter_types.h:46: error: size of array is not a compile-time constant
/home/yangfp/five/_build/paparazzi/upstream/sw/airborne/filters/low_pass_zoh_filter_types.h:46: error: size of array is not a compile-time constant
/home/yangfp/five/_build/paparazzi/upstream/sw/airborne/filters/low_pass_zoh_filter_types.h:61: error: size of array is not a compile-time constant
/home/yangfp/five/_build/paparazzi/upstream/sw/airborne/filters/low_pass_zoh_filter_types.h:61: error: size of array is not a compile-time constant
/home/yangfp/five/_build/paparazzi/upstream/sw/airborne/filters/low_pass_zoh_filter_types.h:75: error: size of array is not a compile-time constant
/home/yangfp/five/_build/paparazzi/upstream/sw/airborne/filters/low_pass_zoh_filter_types.h:75: error: size of array is not a compile-time constant
/home/yangfp/five/_build/paparazzi/upstream/sw/airborne/filters/low_pass_zoh_filter_types.h:90: error: size of array is not a compile-time constant
/home/yangfp/five/_build/paparazzi/upstream/sw/airborne/filters/low_pass_zoh_filter_types.h:90: error: size of array is not a compile-time constant
8 errors detected.

```

## Resolved frontend configuration issues

By-value struct arguments/returns initially failed in the default frontend configuration. The expansion retries affected source groups with CompCert `-fstruct-passing`. Successfully retried groups are not listed above as unresolved limitations; their effective options are bound in manifests, audit commands and all-results.json. No struct interface is rewritten by hand. The first batch separately attempted `simple_kinematic_kalman_update_pos` and `simple_kinematic_kalman_update_speed`; those two wrappers remain outside the delivered entry selection, with their original diagnostics retained.

## Coverage obligations after import

A successful import is not a safety, termination or equivalence proof. External libm, memory and environment interfaces remain explicit; missing callbacks are not classified as C errors. Concrete preconditions and all requested proofs remain pending. Runtime-length arrays were never replaced by guessed fixed dimensions. Source slicing and the omission of the unrelated header VLA function are documented in each batch report.

## Connected-family firmware integration limitations

### gvf_implicit

Source: `sw/airborne/modules/guidance/trajectories/gvf_traj.c`; entries: gvf_line_info, gvf_ellipse_info, gvf_sin_info.

Record: `/home/yangfp/five/runs/20261103T150016-66e65f3a09/five-align`.

```text
In file included from /home/yangfp/five/_build/paparazzi/upstream/sw/airborne/modules/guidance/trajectories/gvf_traj.h:24,
                 from /home/yangfp/five/_build/paparazzi/connected-models/gvf_implicit/Program.c:21:
/home/yangfp/five/_build/paparazzi/upstream/sw/airborne/modules/guidance/gvf_common.h:49:2: error: #error "GVF does not support your firmware yet!"
   49 | #error "GVF does not support your firmware yet!"
      |  ^~~~~
ccomp: error: preprocessor command failed with exit code 1 (use -v to see invocation)


```

The attempted driver lacks the required firmware configuration. This is an integration prerequisite, not evidence that CompCert rejects every trajectory function. No generated firmware headers or hardware state were fabricated.

### gvf_parametric

Source: `sw/airborne/modules/guidance/trajectories/gvf_param_traj.c`; entries: gvf_parametric_2d_trefoil_info, gvf_parametric_3d_ellipse_info, gvf_parametric_3d_lissajous_info, gvf_parametric_2d_bezier_splines_info.

Record: `/home/yangfp/five/runs/20261103T150016-0fcd65e159/five-align`.

```text
In file included from /home/yangfp/five/_build/paparazzi/upstream/sw/airborne/modules/guidance/trajectories/gvf_param_traj.h:33,
                 from /home/yangfp/five/_build/paparazzi/connected-models/gvf_parametric/Program.c:21:
/home/yangfp/five/_build/paparazzi/upstream/sw/airborne/modules/guidance/gvf_common.h:49:2: error: #error "GVF does not support your firmware yet!"
   49 | #error "GVF does not support your firmware yet!"
      |  ^~~~~
ccomp: error: preprocessor command failed with exit code 1 (use -v to see invocation)


```

The attempted driver lacks the required firmware configuration. This is an integration prerequisite, not evidence that CompCert rejects every trajectory function. No generated firmware headers or hardware state were fabricated.


## Navigation and vision import limitations

### relative_ekf_no_north

`sw/airborne/modules/relative_localization_filter/discrete_ekf_no_north.c`

`extractPhiGamma`, `float_mat_combine`, `c2d`, `discrete_ekf_no_north_fsym`, `discrete_ekf_no_north_hsym`, `discrete_ekf_no_north_Fx`, `discrete_ekf_no_north_G`, `discrete_ekf_no_north_Hx`, `discrete_ekf_no_north_new`, `discrete_ekf_no_north_predict`, `discrete_ekf_no_north_update`

Run evidence is in `runs/20261104T020519-7843740d3b/five-align`.

```text
/home/yangfp/five/_build/paparazzi/navigation-vision-models/relative_ekf_no_north/Program.c:78: error: size of array is not a compile-time constant
/home/yangfp/five/_build/paparazzi/navigation-vision-models/relative_ekf_no_north/Program.c:78: error: size of array is not a compile-time constant
/home/yangfp/five/_build/paparazzi/navigation-vision-models/relative_ekf_no_north/Program.c:79: error: size of array is not a compile-time constant
/home/yangfp/five/_build/paparazzi/navigation-vision-models/relative_ekf_no_north/Program.c:79: error: size of array is not a compile-time constant
/home/yangfp/five/_build/paparazzi/navigation-vision-models/relative_ekf_no_north/Program.c:83: error: size of array is not a compile-time constant
/home/yangfp/five/_build/paparazzi/navigation-vision-models/relative_ekf_no_north/Program.c:84: error: size of array is not a compile-time constant
/home/yangfp/five/_build/paparazzi/navigation-vision-models/relative_ekf_no_north/Program.c:85: error: size of array is not a compile-time constant
/home/yangfp/five/_build/paparazzi/navigation-vision-models/relative_ekf_no_north/Program.c:86: error: size of array is not a compile-time constant
8 errors detected.
```

### runge_kutta

`sw/airborne/math/pprz_rk_float.h`

`runge_kutta_1_float`, `runge_kutta_2_float`, `runge_kutta_4_float`

Run evidence is in `runs/20261104T020815-f40bc9f65d/five-align`.

```text
/home/yangfp/five/_build/paparazzi/overlay/math/pprz_rk_float.h:62: error: size of array is not a compile-time constant
/home/yangfp/five/_build/paparazzi/overlay/math/pprz_rk_float.h:96: error: size of array is not a compile-time constant
/home/yangfp/five/_build/paparazzi/overlay/math/pprz_rk_float.h:139: error: size of array is not a compile-time constant
/home/yangfp/five/_build/paparazzi/overlay/math/pprz_rk_float.h:139: error: size of array is not a compile-time constant
/home/yangfp/five/_build/paparazzi/overlay/math/pprz_rk_float.h:139: error: size of array is not a compile-time constant
/home/yangfp/five/_build/paparazzi/overlay/math/pprz_rk_float.h:139: error: size of array is not a compile-time constant
/home/yangfp/five/_build/paparazzi/overlay/math/pprz_rk_float.h:139: error: size of array is not a compile-time constant
7 errors detected.
```

### madgwick

`sw/airborne/modules/ahrs/ahrs_madgwick.c`

`init_state`, `ahrs_madgwick_init`, `ahrs_madgwick_align`, `ahrs_madgwick_propagate`, `ahrs_madgwick_update_accel`

Run evidence is in `runs/20261104T020815-e1d7725eb1/five-align`.

```text
/home/yangfp/five/_build/paparazzi/navigation-vision-models/madgwick/Program.c:30:10: fatal error: generated/airframe.h: No such file or directory
   30 | #include "generated/airframe.h"
      |          ^~~~~~~~~~~~~~~~~~~~~~
compilation terminated.
ccomp: error: preprocessor command failed with exit code 1 (use -v to see invocation)
```


## State and horizontal guidance reference

The 138 state entry interfaces were generated. The horizontal guidance reference has 11 candidate entries. The source requires `generated/airframe.h` for a concrete aircraft configuration. No real generated header was found. Building the pinned upstream generator was attempted with its pinned pprzlink submodule; the available environment lacks the `xml-light` and Ivy OCaml packages.

```text
In file included from /home/yangfp/five/_build/paparazzi/state-guidance-models/guidance_h_ref/Program.c:27:
/home/yangfp/five/_build/paparazzi/upstream/sw/airborne/firmwares/rotorcraft/guidance/guidance_h_ref.h:34:10: fatal error: generated/airframe.h: No such file or directory
   34 | #include "generated/airframe.h"
      |          ^~~~~~~~~~~~~~~~~~~~~~
compilation terminated.
ccomp: error: preprocessor command failed with exit code 1 (use -v to see invocation)


```

The upstream DUMMY test header is not a real aircraft configuration. The 11 guidance entries remain pending, with no fabricated configuration.
