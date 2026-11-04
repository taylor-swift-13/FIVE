#include "filters/low_pass_zoh_filter.h"
void (*five_keep_init_first_order_zoh_low_pass)(void) = (void (*)(void))init_first_order_zoh_low_pass;
void (*five_keep_update_first_order_zoh_low_pass)(void) = (void (*)(void))update_first_order_zoh_low_pass;
void (*five_keep_reset_first_order_zoh_low_pass)(void) = (void (*)(void))reset_first_order_zoh_low_pass;
void (*five_keep_get_first_order_zoh_low_pass)(void) = (void (*)(void))get_first_order_zoh_low_pass;
void (*five_keep_update_first_order_zoh_low_pass_tau)(void) = (void (*)(void))update_first_order_zoh_low_pass_tau;
