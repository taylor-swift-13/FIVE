# Navigation, estimation and vision proof families

81 new entry interfaces across 8 source groups. The inventory contains 432 completed entries.

Each group shares a CompCert global environment. The protocols describe proposed proof sequences. The call graph separately records the calls in preprocessed source. All program properties below are pending.

## Fixed-point navigation coordinates

Define the local frame, transform ECEF coordinates, then convert ENU to NED.

The state consists of Local origin, rotation matrix, ECEF/ENU/NED points and vectors.

Prove point conversion agrees with vector conversion of the displacement from the stored origin. Prove NED output is the ENU component permutation with the vertical sign reversed. Preserve the actual fixed-point shifts and casts.

State representability and memory separation conditions. Geodetic and trigonometric calls crossing translation units need corresponding contracts. A round trip needs a quantization bound.

[Source.v](../_shared/groups/integer_navigation/model/Source.v)

## Fixed-point trigonometry

Normalize and fold the angle, read the sine table, and derive cosine via a phase shift.

The state consists of Default table and angle normalization.

Prove normalization terminates on the selected range, lookup indices remain within the actual table, and the cosine entry agrees with the source phase shift followed by sine.

Bind the result to the default table configuration and actual integer operations. A real-valued accuracy theorem is a separate obligation.

[Source.v](../_shared/groups/integer_trigonometry/model/Source.v)

## Relative localization EKF

Initialize, predict the next state and measurement, and correct with the observed measurement.

The state consists of X, Xp, Zp, covariance matrices, Jacobians and workspaces.

First show the prediction agrees with the source-order rounded state and covariance recurrence and initializes the fields used by correction. Then compose prediction and correction over a finite observation history.

The correction calls float_mat_invert. Its execution or contract correspondence must be supplied. Keep the range measurement and powf/sqrtf behavior explicit.

[Source.v](../_shared/groups/relative_ekf/model/Source.v)

## Camera coordinate conversion

Convert pixels to normalized coordinates, apply the distortion operation, and project back into pixels.

The state consists of Intrinsics, distortion parameter and normalized/pixel coordinates.

Prove the two wrapper functions agree with the actual helper composition, including each rounded multiplication, subtraction, division and cast. State an error bound separately for round trips.

Specify nonzero focal lengths, valid square-root arguments when required and defined conversion ranges.

[Source.v](../_shared/groups/vision_undistortion/model/Source.v)

## Magnetic field coefficient and evaluation pipeline

Extrapolate coefficients for the requested date and pass that array to the field evaluator.

The state consists of Coefficient arrays and magnetic field vector.

Prove the coefficient array is initialized over the harmonic index range used by evaluation. Compose the coefficient recurrence and field-evaluation recurrence with the mixed precision in the C implementation.

Bind supported harmonic degrees to the actual arrays. Supply target libm contracts and account for conversions between float and double.

[Source.v](../_shared/groups/magnetic_field/model/Source.v)

## No-north EKF initialization, measurement and correction

Initialize the state, evaluate the motion and measurement functions and their Jacobians, and apply correction to an initialized prediction state.

The state consists of Relative state, heading, measurements and Jacobians.

Prove the measurement projection preserves the bits of copied state components and computes range in source evaluation order. Specify correction against an explicit prediction-state relation.

The original predictor calls the VLA-based c2d helper. Its separate import limitation still applies. Matrix inversion and target libm remain proof boundaries.

[Source.v](../_shared/groups/relative_ekf_no_north_core/model/Source.v)

## Image memory and pyramid construction

Create or receive an image, convert it to grayscale, pad the border, and construct successive levels.

The state consists of Image descriptors, YUV422 bytes, grayscale buffers and allocated pyramid levels.

Prove grayscale extraction reads the luminance bytes and preserves the specified metadata. Prove border padding and each pyramid level agree with the implemented index and shift recurrences, then compose across levels.

Specify allocation, memory copying, image layout and nonaliasing. The uint8 level counter needs a representable exit value. Prove the in-place vertical pass in execution order.

[Source.v](../_shared/groups/vision_images/model/Source.v)

## Lucas-Kanade optical flow

Build image pyramids, extract windows, compute gradients, and update feature displacement.

The state consists of Image levels, feature coordinates and per-feature displacement.

Relate accepted features and returned displacements to the bounded, rounded update recurrence and the actual out-of-range rejection paths.

When image.c is included by the align driver, the pyramid and window helpers execute inside the shared model. Transfer to the production build requires linkage and configuration correspondence.

[Source.v](../_shared/groups/vision_optical_flow/model/Source.v)

The first composition targets are ENU-to-NED conversion, grayscale-to-pyramid shape and byte properties, and EKF prediction followed by the measurement projection. Each uses step lemmas with a state or memory relation before induction over operation sequences.
