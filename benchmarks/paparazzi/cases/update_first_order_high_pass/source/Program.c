#include "filters/high_pass_filter.h"
void (*five_keep_init_first_order_high_pass)(void) = (void (*)(void))init_first_order_high_pass;
void (*five_keep_update_first_order_high_pass)(void) = (void (*)(void))update_first_order_high_pass;
void (*five_keep_update_fourth_order_high_pass)(void) = (void (*)(void))update_fourth_order_high_pass;
