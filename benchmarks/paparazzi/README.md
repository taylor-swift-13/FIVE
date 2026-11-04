# Paparazzi CompCert model library

This library contains 432 entry interfaces in 42 source groups, derived from Paparazzi commit `abfee3dd56eeab12c528635504a429db3daf409a`.

Each group contains its prepared C input, frozen preprocessed input, generated CompCert Csyntax, Cexec execution wrappers, precondition interfaces, and unproved safety and termination goals.

```text
groups/<group>/
  source/Program.c
  source/preprocessed.i
  model/Source.v
  model/Execution.v
  model/proof/{Precondition,Obligations,Proofs}.v
  entries/<function>/Execution.v
  entries/<function>/proof/{Precondition,Obligations,Proofs}.v
  manifest.json
  historical-manifest.json
source-snapshot/{upstream,overlay,navigation-vision-overlay}/
reports/
```

The source snapshot contains referenced project headers and source files; the `.i` files preserve the complete preprocessed translation units, including system-header content. Each historical manifest retains the paths of the machine where it was produced. The portable manifest records the archived source hashes, target, namespace, options and entry names. Re-auditing the original preprocessing environment requires reconstructing its paths and dependencies.

Inputs are unrestricted in the generated execution wrappers. Concrete preconditions and program-property proofs are pending. External calls and any source slicing or combined compilation units have the boundaries documented in the reports.

The cost archive preserves the four stage records, usage receipts and referenced tool logs. The records describe the historical runs. The archived C syntax and Rocq source files have not been newly rechecked as part of packaging.

To compile an entry from the repository root with the configured Rocq and CompCert installations, for example `statistics/sum_f`, run:

```sh
GROUP=benchmarks/paparazzi/groups/statistics
rocq compile -Q shared FiveShared shared/verification/Obligations.v
rocq compile -Q "$GROUP/model" Paparazzi.statistics "$GROUP/model/Source.v"
rocq compile -Q "$GROUP/model" Paparazzi.statistics -Q "$GROUP/entries" Paparazzi.statistics.entries -Q shared FiveShared "$GROUP/entries/sum_f/Execution.v"
rocq compile -Q "$GROUP/model" Paparazzi.statistics -Q "$GROUP/entries" Paparazzi.statistics.entries -Q shared FiveShared "$GROUP/entries/sum_f/proof/Precondition.v"
rocq compile -Q "$GROUP/model" Paparazzi.statistics -Q "$GROUP/entries" Paparazzi.statistics.entries -Q shared FiveShared "$GROUP/entries/sum_f/proof/Obligations.v"
rocq compile -Q "$GROUP/model" Paparazzi.statistics -Q "$GROUP/entries" Paparazzi.statistics.entries -Q shared FiveShared "$GROUP/entries/sum_f/proof/Proofs.v"
```

The namespace is recorded in each group manifest. These commands check declarations and do not prove the pending program properties.

[Proof families](reports/proof-bundles.json) · [Call graph](reports/callgraph.json) · [Functional proof plans](reports/connected-families.md) · [Navigation and vision plans](reports/navigation-vision-families.md) · [Import limitations](reports/limitations.md) · [Complete inventory](reports/all-results.json)

| Source group | Upstream source | Entries |
| --- | --- | ---: |
| [statistics](groups/statistics/manifest.json) | `sw/airborne/math/pprz_stat.c` | 7 |
| [algebra](groups/algebra/manifest.json) | `sw/airborne/math/pprz_algebra_float.c` | 8 |
| [geodetic](groups/geodetic/manifest.json) | `sw/airborne/math/pprz_geodetic_float.c` | 5 |
| [kalman](groups/kalman/manifest.json) | `sw/airborne/filters/simple_kinematic_kalman.c` | 3 |
| [median](groups/median/manifest.json) | `sw/airborne/filters/median_filter.h` | 3 |
| [highpass](groups/highpass/manifest.json) | `sw/airborne/filters/high_pass_filter.h` | 3 |
| [notch](groups/notch/manifest.json) | `sw/airborne/filters/notch_filter_float.h` | 3 |
| [delay](groups/delay/manifest.json) | `sw/airborne/filters/transport_delay.h` | 4 |
| [ring_buffer](groups/ring_buffer/manifest.json) | `sw/airborne/utils/ring_buffer.c` | 5 |
| [framed_buffer](groups/framed_buffer/manifest.json) | `sw/airborne/utils/framed_ring_buffer.c` | 4 |
| [float_vectors_matrices](groups/float_vectors_matrices/manifest.json) | `sw/airborne/math/pprz_algebra_float.h` | 43 |
| [double_algebra](groups/double_algebra/manifest.json) | `sw/airborne/math/pprz_algebra_double.c` | 10 |
| [double_geodetic](groups/double_geodetic/manifest.json) | `sw/airborne/math/pprz_geodetic_double.c` | 20 |
| [float_geodetic_more](groups/float_geodetic_more/manifest.json) | `sw/airborne/math/pprz_geodetic_float.c` | 14 |
| [float_algebra_more](groups/float_algebra_more/manifest.json) | `sw/airborne/math/pprz_algebra_float.c` | 47 |
| [integer_algebra](groups/integer_algebra/manifest.json) | `sw/airborne/math/pprz_algebra_int.c` | 27 |
| [atmosphere](groups/atmosphere/manifest.json) | `sw/airborne/math/pprz_isa.h` | 8 |
| [complementary](groups/complementary/manifest.json) | `sw/airborne/filters/complementary_filter.h` | 16 |
| [one_euro](groups/one_euro/manifest.json) | `sw/airborne/filters/1e_filter.h` | 6 |
| [adaptive_notch](groups/adaptive_notch/manifest.json) | `sw/airborne/filters/adaptive_notch_filter.h` | 3 |
| [quaternion_filter](groups/quaternion_filter/manifest.json) | `sw/airborne/filters/quaternion_filter.h` | 8 |
| [zoh_filter](groups/zoh_filter/manifest.json) | `sw/airborne/filters/low_pass_zoh_filter.h` | 5 |
| [key_value_store](groups/key_value_store/manifest.json) | `sw/airborne/utils/kv_store.c` | 6 |
| [median_integer](groups/median_integer/manifest.json) | `sw/airborne/filters/median_filter.h` | 3 |
| [highpass_more](groups/highpass_more/manifest.json) | `sw/airborne/filters/high_pass_filter.h` | 3 |
| [notch_more](groups/notch_more/manifest.json) | `sw/airborne/filters/notch_filter_float.h` | 3 |
| [double_vectors](groups/double_vectors/manifest.json) | `sw/airborne/math/pprz_algebra_double.h` | 7 |
| [pid_lifecycle](groups/pid_lifecycle/manifest.json) | `sw/airborne/filters/pid.h` | 15 |
| [lowpass_lifecycle](groups/lowpass_lifecycle/manifest.json) | `sw/airborne/filters/low_pass_filter.h` | 25 |
| [kalman_lifecycle](groups/kalman_lifecycle/manifest.json) | `sw/airborne/filters/simple_kinematic_kalman.c` | 7 |
| [orientation_cache](groups/orientation_cache/manifest.json) | `sw/airborne/math/pprz_orientation_conversion.c` | 22 |
| [delayed_filter_lifecycle](groups/delayed_filter_lifecycle/manifest.json) | `sw/airborne/filters/delayed_first_order_lowpass_filter.h` | 4 |
| [attitude_saturation](groups/attitude_saturation/manifest.json) | `sw/airborne/firmwares/rotorcraft/stabilization/attitude_ref_saturate_naive.h` | 2 |
| [framed_buffer_lifecycle](groups/framed_buffer_lifecycle/manifest.json) | `sw/airborne/utils/framed_ring_buffer.c` | 2 |
| [integer_navigation](groups/integer_navigation/manifest.json) | `sw/airborne/math/pprz_geodetic_int.c` | 25 |
| [integer_trigonometry](groups/integer_trigonometry/manifest.json) | `sw/airborne/math/pprz_trig_int.c` | 4 |
| [relative_ekf](groups/relative_ekf/manifest.json) | `sw/airborne/modules/relative_localization_filter/discrete_ekf.c` | 5 |
| [vision_undistortion](groups/vision_undistortion/manifest.json) | `sw/airborne/modules/computer_vision/lib/vision/undistortion.c` | 6 |
| [magnetic_field](groups/magnetic_field/manifest.json) | `sw/airborne/math/pprz_geodetic_wmm2025.c` | 2 |
| [relative_ekf_no_north_core](groups/relative_ekf_no_north_core/manifest.json) | `sw/airborne/modules/relative_localization_filter/discrete_ekf_no_north.c` | 9 |
| [vision_images](groups/vision_images/manifest.json) | `sw/airborne/modules/computer_vision/lib/vision/image.c` | 28 |
| [vision_optical_flow](groups/vision_optical_flow/manifest.json) | `sw/airborne/modules/computer_vision/lib/vision/lucas_kanade.c` | 2 |
