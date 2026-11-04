#include "filters/high_pass_filter.h"
void (*five_keep_get_first_order_high_pass)(void) = (void (*)(void))get_first_order_high_pass;
void (*five_keep_init_fourth_order_high_pass)(void) = (void (*)(void))init_fourth_order_high_pass;
void (*five_keep_get_fourth_order_high_pass)(void) = (void (*)(void))get_fourth_order_high_pass;
