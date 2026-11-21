Require PprzTrigCBMC.InitPropertyClaims PprzTrigCBMC.QueryFamilies PprzTrigCBMC.ArrayPropertyClaims.
(* Actual CBMC ID: main.assertion.1; sine literal table range *)
Definition Guard_main_assertion_1:Prop := PprzTrigCBMC.QueryFamilies.plain_harness_assertion.
(* Actual CBMC ID: pprz_itrig_sin.overflow.1; arithmetic overflow on signed - in angle - (int32_t)(2.0 * 3.141593 * (double)(1 << 12)) *)
Definition Guard_pprz_itrig_sin_overflow_1:Prop := PprzTrigCBMC.QueryFamilies.plain_binary.
(* Actual CBMC ID: pprz_itrig_sin.overflow.2; arithmetic overflow on signed + in angle + (int32_t)(2.0 * 3.141593 * (double)(1 << 12)) *)
Definition Guard_pprz_itrig_sin_overflow_2:Prop := PprzTrigCBMC.QueryFamilies.plain_binary.
(* Actual CBMC ID: pprz_itrig_sin.overflow.3; arithmetic overflow on signed - in (int32_t)(3.141593 * (double)(1 << 12)) - angle *)
Definition Guard_pprz_itrig_sin_overflow_3:Prop := PprzTrigCBMC.QueryFamilies.plain_binary.
(* Actual CBMC ID: pprz_itrig_sin.overflow.4; arithmetic overflow on signed - in -((int32_t)(3.141593 * (double)(1 << 12))) - angle *)
Definition Guard_pprz_itrig_sin_overflow_4:Prop := PprzTrigCBMC.QueryFamilies.plain_binary.
(* Actual CBMC ID: pprz_itrig_sin.array_bounds.1; array 'pprz_trig_int' lower bound in pprz_trig_int[(signed long int)angle] *)
Definition Guard_pprz_itrig_sin_array_bounds_1:Prop := PprzTrigCBMC.ArrayPropertyClaims.PlainArrayBounds.
(* Actual CBMC ID: pprz_itrig_sin.array_bounds.2; array 'pprz_trig_int' upper bound in pprz_trig_int[(signed long int)angle] *)
Definition Guard_pprz_itrig_sin_array_bounds_2:Prop := PprzTrigCBMC.ArrayPropertyClaims.PlainArrayBounds.
(* Actual CBMC ID: pprz_itrig_sin.overflow.5; arithmetic overflow on signed unary minus in -angle *)
Definition Guard_pprz_itrig_sin_overflow_5:Prop := PprzTrigCBMC.QueryFamilies.plain_unary.
(* Actual CBMC ID: pprz_itrig_sin.array_bounds.3; array 'pprz_trig_int' lower bound in pprz_trig_int[(signed long int)-angle] *)
Definition Guard_pprz_itrig_sin_array_bounds_3:Prop := PprzTrigCBMC.ArrayPropertyClaims.PlainArrayBounds.
(* Actual CBMC ID: pprz_itrig_sin.array_bounds.4; array 'pprz_trig_int' upper bound in pprz_trig_int[(signed long int)-angle] *)
Definition Guard_pprz_itrig_sin_array_bounds_4:Prop := PprzTrigCBMC.ArrayPropertyClaims.PlainArrayBounds.
(* Actual CBMC ID: pprz_itrig_sin.overflow.6; arithmetic overflow on signed unary minus in -((signed int)pprz_trig_int[(signed long int)-angle]) *)
Definition Guard_pprz_itrig_sin_overflow_6:Prop := PprzTrigCBMC.QueryFamilies.plain_unary.
(* Actual CBMC ID: pprz_itrig_sin.unwind.0; unwinding assertion loop 0 *)
Definition Guard_pprz_itrig_sin_unwind_0:Prop := PprzTrigCBMC.QueryFamilies.plain_zero_unwind.
(* Actual CBMC ID: pprz_itrig_sin.unwind.1; unwinding assertion loop 1 *)
Definition Guard_pprz_itrig_sin_unwind_1:Prop := PprzTrigCBMC.QueryFamilies.plain_zero_unwind.
