#include "filters/median_filter.h"
void (*five_keep_init_median_filter_f)(void) = (void (*)(void))init_median_filter_f;
void (*five_keep_update_median_filter_f)(void) = (void (*)(void))update_median_filter_f;
void (*five_keep_get_median_filter_f)(void) = (void (*)(void))get_median_filter_f;
