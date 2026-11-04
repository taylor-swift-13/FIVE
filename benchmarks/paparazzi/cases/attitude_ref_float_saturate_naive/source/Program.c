#include "std.h"
#include "firmwares/rotorcraft/stabilization/attitude_ref_saturate_naive.h"
void (*five_keep_attitude_ref_float_saturate_naive)(void) = (void (*)(void))attitude_ref_float_saturate_naive;
void (*five_keep_attitude_ref_int_saturate_naive)(void) = (void (*)(void))attitude_ref_int_saturate_naive;
