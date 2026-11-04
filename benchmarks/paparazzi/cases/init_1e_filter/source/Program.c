#include "filters/1e_filter.h"
void (*five_keep_init_1e_filter)(void) = (void (*)(void))init_1e_filter;
void (*five_keep_reset_1e_filter)(void) = (void (*)(void))reset_1e_filter;
void (*five_keep_compute_1e_filter_lp)(void) = (void (*)(void))compute_1e_filter_lp;
void (*five_keep_compute_1e_filter_alpha)(void) = (void (*)(void))compute_1e_filter_alpha;
void (*five_keep_update_1e_filter)(void) = (void (*)(void))update_1e_filter;
void (*five_keep_update_1e_filter_at_time)(void) = (void (*)(void))update_1e_filter_at_time;
