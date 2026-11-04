#include "std.h"
#include "filters/low_pass_filter.h"
void (*five_keep_init_first_order_low_pass)(void) = (void (*)(void))init_first_order_low_pass;
void (*five_keep_update_first_order_low_pass)(void) = (void (*)(void))update_first_order_low_pass;
void (*five_keep_reset_first_order_low_pass)(void) = (void (*)(void))reset_first_order_low_pass;
void (*five_keep_get_first_order_low_pass)(void) = (void (*)(void))get_first_order_low_pass;
void (*five_keep_update_first_order_low_pass_tau)(void) = (void (*)(void))update_first_order_low_pass_tau;
void (*five_keep_init_second_order_low_pass)(void) = (void (*)(void))init_second_order_low_pass;
void (*five_keep_reset_second_order_low_pass)(void) = (void (*)(void))reset_second_order_low_pass;
void (*five_keep_get_second_order_low_pass)(void) = (void (*)(void))get_second_order_low_pass;
void (*five_keep_init_second_order_low_pass_int)(void) = (void (*)(void))init_second_order_low_pass_int;
void (*five_keep_update_second_order_low_pass_int)(void) = (void (*)(void))update_second_order_low_pass_int;
void (*five_keep_get_second_order_low_pass_int)(void) = (void (*)(void))get_second_order_low_pass_int;
void (*five_keep_init_butterworth_2_low_pass)(void) = (void (*)(void))init_butterworth_2_low_pass;
void (*five_keep_update_butterworth_2_low_pass)(void) = (void (*)(void))update_butterworth_2_low_pass;
void (*five_keep_reset_butterworth_2_low_pass)(void) = (void (*)(void))reset_butterworth_2_low_pass;
void (*five_keep_get_butterworth_2_low_pass)(void) = (void (*)(void))get_butterworth_2_low_pass;
void (*five_keep_init_butterworth_2_low_pass_int)(void) = (void (*)(void))init_butterworth_2_low_pass_int;
void (*five_keep_update_butterworth_2_low_pass_int)(void) = (void (*)(void))update_butterworth_2_low_pass_int;
void (*five_keep_get_butterworth_2_low_pass_int)(void) = (void (*)(void))get_butterworth_2_low_pass_int;
void (*five_keep_init_butterworth_4_low_pass)(void) = (void (*)(void))init_butterworth_4_low_pass;
void (*five_keep_update_butterworth_4_low_pass)(void) = (void (*)(void))update_butterworth_4_low_pass;
void (*five_keep_get_butterworth_4_low_pass)(void) = (void (*)(void))get_butterworth_4_low_pass;
void (*five_keep_reset_butterworth_4_low_pass)(void) = (void (*)(void))reset_butterworth_4_low_pass;
void (*five_keep_init_butterworth_4_low_pass_int)(void) = (void (*)(void))init_butterworth_4_low_pass_int;
void (*five_keep_update_butterworth_4_low_pass_int)(void) = (void (*)(void))update_butterworth_4_low_pass_int;
void (*five_keep_get_butterworth_4_low_pass_int)(void) = (void (*)(void))get_butterworth_4_low_pass_int;
