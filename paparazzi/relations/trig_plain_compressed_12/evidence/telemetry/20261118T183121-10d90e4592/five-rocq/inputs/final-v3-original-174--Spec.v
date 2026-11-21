Require PprzTrigCBMC.InitPropertyClaims PprzTrigCBMC.QueryFamilies PprzTrigCBMC.ArrayPropertyClaims.
(* Actual CBMC ID: get_nibble.array_bounds.1; array 'pprz_trig_int_compr' lower bound in pprz_trig_int_compr[(signed long int)((signed int)pos / 2)] *)
Definition Guard_get_nibble_array_bounds_1:Prop := PprzTrigCBMC.ArrayPropertyClaims.InitRomBounds.
(* Actual CBMC ID: get_nibble.array_bounds.2; array 'pprz_trig_int_compr' upper bound in pprz_trig_int_compr[(signed long int)((signed int)pos / 2)] *)
Definition Guard_get_nibble_array_bounds_2:Prop := PprzTrigCBMC.ArrayPropertyClaims.InitRomBounds.
(* Actual CBMC ID: get_nibble.overflow.1; arithmetic overflow on signed * in 4 * ((signed int)pos % 2) *)
Definition Guard_get_nibble_overflow_1:Prop := PprzTrigCBMC.InitPropertyClaims.get_nibble_multiply_checks.
(* Actual CBMC ID: get_nibble.undefined-shift.1; shift distance is negative in (signed int)pprz_trig_int_compr[(signed long int)((signed int)pos / 2)] >> 4 * ((signed int)pos % 2) *)
Definition Guard_get_nibble_undefined_shift_1:Prop := PprzTrigCBMC.InitPropertyClaims.get_nibble_distance_checks.
(* Actual CBMC ID: get_nibble.undefined-shift.2; shift distance too large in (signed int)pprz_trig_int_compr[(signed long int)((signed int)pos / 2)] >> 4 * ((signed int)pos % 2) *)
Definition Guard_get_nibble_undefined_shift_2:Prop := PprzTrigCBMC.InitPropertyClaims.get_nibble_distance_checks.
(* Actual CBMC ID: main.assertion.1; genuine init success *)
Definition Guard_main_assertion_1:Prop := PprzTrigCBMC.InitPropertyClaims.genuine_initializer_assertion.
(* Actual CBMC ID: main.array_bounds.1; array 'reference_table' lower bound in reference_table[(signed long int)i] *)
Definition Guard_main_array_bounds_1:Prop := PprzTrigCBMC.InitPropertyClaims.init_harness_indices.
(* Actual CBMC ID: main.array_bounds.2; array 'reference_table' upper bound in reference_table[(signed long int)i] *)
Definition Guard_main_array_bounds_2:Prop := PprzTrigCBMC.InitPropertyClaims.init_harness_indices.
(* Actual CBMC ID: main.assertion.2; all initialized decoded lookups equal literal ordinary table *)
Definition Guard_main_assertion_2:Prop := PprzTrigCBMC.InitPropertyClaims.init_harness_lookup_assertion.
(* Actual CBMC ID: pprz_trig_int_12.overflow.1; arithmetic overflow on signed + in 6434 + ((signed int)val >> 1) *)
Definition Guard_pprz_trig_int_12_overflow_1:Prop := PprzTrigCBMC.QueryFamilies.initialized_decoder_binary.
(* Actual CBMC ID: pprz_trig_int_12.array_bounds.1; array 'data_buf_12' lower bound in data_buf_12[(signed long int)(6434 + ((signed int)val >> 1))] *)
Definition Guard_pprz_trig_int_12_array_bounds_1:Prop := PprzTrigCBMC.ArrayPropertyClaims.InitializedDecoderBounds.
(* Actual CBMC ID: pprz_trig_int_12.array_bounds.2; array 'data_buf_12' upper bound in data_buf_12[(signed long int)(6434 + ((signed int)val >> 1))] *)
Definition Guard_pprz_trig_int_12_array_bounds_2:Prop := PprzTrigCBMC.ArrayPropertyClaims.InitializedDecoderBounds.
(* Actual CBMC ID: pprz_trig_int_12.undefined-shift.1; shift operand is negative in (signed int)data_buf_12[(signed long int)(6434 + ((signed int)val >> 1))] << ((signed int)val % 2 != 0 ? 4 : 8) *)
Definition Guard_pprz_trig_int_12_undefined_shift_1:Prop := PprzTrigCBMC.QueryFamilies.initialized_decoder_binary.
(* Actual CBMC ID: pprz_trig_int_12.overflow.2; arithmetic overflow on signed shl in (signed int)data_buf_12[(signed long int)(6434 + ((signed int)val >> 1))] << ((signed int)val % 2 != 0 ? 4 : 8) *)
Definition Guard_pprz_trig_int_12_overflow_2:Prop := PprzTrigCBMC.QueryFamilies.initialized_decoder_binary.
(* Actual CBMC ID: pprz_trig_int_12.array_bounds.3; array 'data_buf_12' lower bound in data_buf_12[(signed long int)val] *)
Definition Guard_pprz_trig_int_12_array_bounds_3:Prop := PprzTrigCBMC.ArrayPropertyClaims.InitializedDecoderBounds.
(* Actual CBMC ID: pprz_trig_int_12.array_bounds.4; array 'data_buf_12' upper bound in data_buf_12[(signed long int)val] *)
Definition Guard_pprz_trig_int_12_array_bounds_4:Prop := PprzTrigCBMC.ArrayPropertyClaims.InitializedDecoderBounds.
(* Actual CBMC ID: pprz_trig_int_init.overflow.1; arithmetic overflow on signed + in i + 1 *)
Definition Guard_pprz_trig_int_init_overflow_1:Prop := PprzTrigCBMC.InitPropertyClaims.initializer_increment_checks.
(* Actual CBMC ID: pprz_trig_int_init.overflow.2; arithmetic overflow on signed + in (signed int)temp / 5 + 1 *)
Definition Guard_pprz_trig_int_init_overflow_2:Prop := PprzTrigCBMC.InitPropertyClaims.initializer_explicit_add_checks.
(* Actual CBMC ID: pprz_trig_int_init.overflow.3; arithmetic overflow on signed + in cnt + 1 *)
Definition Guard_pprz_trig_int_init_overflow_3:Prop := PprzTrigCBMC.InitPropertyClaims.initializer_increment_checks.
(* Actual CBMC ID: pprz_trig_int_init.overflow.4; arithmetic overflow on signed + in (signed int)val + (signed int)temp % 5 *)
Definition Guard_pprz_trig_int_init_overflow_4:Prop := PprzTrigCBMC.InitPropertyClaims.initializer_addassign_checks.
(* Actual CBMC ID: pprz_trig_int_init.overflow.5; arithmetic overflow on signed + in j + 1 *)
Definition Guard_pprz_trig_int_init_overflow_5:Prop := PprzTrigCBMC.InitPropertyClaims.initializer_increment_checks.
(* Actual CBMC ID: pprz_trig_int_init.overflow.6; arithmetic overflow on signed + in i + 1 *)
Definition Guard_pprz_trig_int_init_overflow_6:Prop := PprzTrigCBMC.InitPropertyClaims.initializer_increment_checks.
(* Actual CBMC ID: pprz_trig_int_init.overflow.7; arithmetic overflow on signed + in i + 1 *)
Definition Guard_pprz_trig_int_init_overflow_7:Prop := PprzTrigCBMC.InitPropertyClaims.initializer_increment_checks.
(* Actual CBMC ID: pprz_trig_int_init.undefined-shift.1; shift operand is negative in ((signed int)temp & 0x8) << 1 *)
Definition Guard_pprz_trig_int_init_undefined_shift_1:Prop := PprzTrigCBMC.InitPropertyClaims.initializer_shift_checks.
(* Actual CBMC ID: pprz_trig_int_init.overflow.8; arithmetic overflow on signed shl in ((signed int)temp & 0x8) << 1 *)
Definition Guard_pprz_trig_int_init_overflow_8:Prop := PprzTrigCBMC.InitPropertyClaims.initializer_shift_checks.
(* Actual CBMC ID: pprz_trig_int_init.overflow.9; arithmetic overflow on signed + in (signed int)k + 3 * 3 + 1 *)
Definition Guard_pprz_trig_int_init_overflow_9:Prop := PprzTrigCBMC.InitPropertyClaims.initializer_explicit_add_checks.
(* Actual CBMC ID: pprz_trig_int_init.overflow.10; arithmetic overflow on signed + in cnt + 1 *)
Definition Guard_pprz_trig_int_init_overflow_10:Prop := PprzTrigCBMC.InitPropertyClaims.initializer_increment_checks.
(* Actual CBMC ID: pprz_trig_int_init.overflow.11; arithmetic overflow on signed + in (signed int)val + ((signed int)temp & 7) *)
Definition Guard_pprz_trig_int_init_overflow_11:Prop := PprzTrigCBMC.InitPropertyClaims.initializer_addassign_checks.
(* Actual CBMC ID: pprz_trig_int_init.overflow.12; arithmetic overflow on signed + in j + 1 *)
Definition Guard_pprz_trig_int_init_overflow_12:Prop := PprzTrigCBMC.InitPropertyClaims.initializer_increment_checks.
(* Actual CBMC ID: table_encode_12.array_bounds.1; array 'data_buf_12' lower bound in data_buf_12[(signed long int)cnt] *)
Definition Guard_table_encode_12_array_bounds_1:Prop := PprzTrigCBMC.ArrayPropertyClaims.InitBufferBounds.
(* Actual CBMC ID: table_encode_12.array_bounds.2; array 'data_buf_12' upper bound in data_buf_12[(signed long int)cnt] *)
Definition Guard_table_encode_12_array_bounds_2:Prop := PprzTrigCBMC.ArrayPropertyClaims.InitBufferBounds.
(* Actual CBMC ID: table_encode_12.overflow.1; arithmetic overflow on signed + in 6434 + (signed int)cnt / 2 *)
Definition Guard_table_encode_12_overflow_1:Prop := PprzTrigCBMC.InitPropertyClaims.encoder_add_checks.
(* Actual CBMC ID: table_encode_12.array_bounds.3; array 'data_buf_12' lower bound in data_buf_12[(signed long int)(6434 + (signed int)cnt / 2)] *)
Definition Guard_table_encode_12_array_bounds_3:Prop := PprzTrigCBMC.ArrayPropertyClaims.InitBufferBounds.
(* Actual CBMC ID: table_encode_12.array_bounds.4; array 'data_buf_12' upper bound in data_buf_12[(signed long int)(6434 + (signed int)cnt / 2)] *)
Definition Guard_table_encode_12_array_bounds_4:Prop := PprzTrigCBMC.ArrayPropertyClaims.InitBufferBounds.
(* Actual CBMC ID: table_encode_12.overflow.2; arithmetic overflow on signed + in 6434 + (signed int)cnt / 2 *)
Definition Guard_table_encode_12_overflow_2:Prop := PprzTrigCBMC.InitPropertyClaims.encoder_add_checks.
(* Actual CBMC ID: table_encode_12.array_bounds.5; array 'data_buf_12' lower bound in data_buf_12[(signed long int)(6434 + (signed int)cnt / 2)] *)
Definition Guard_table_encode_12_array_bounds_5:Prop := PprzTrigCBMC.ArrayPropertyClaims.InitBufferBounds.
(* Actual CBMC ID: table_encode_12.array_bounds.6; array 'data_buf_12' upper bound in data_buf_12[(signed long int)(6434 + (signed int)cnt / 2)] *)
Definition Guard_table_encode_12_array_bounds_6:Prop := PprzTrigCBMC.ArrayPropertyClaims.InitBufferBounds.
