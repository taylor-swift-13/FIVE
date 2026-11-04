#include "filters/adaptive_notch_filter.h"
void (*five_keep_adaptive_notch_filter_init)(void) = (void (*)(void))adaptive_notch_filter_init;
void (*five_keep_adaptive_notch_filter_update)(void) = (void (*)(void))adaptive_notch_filter_update;
void (*five_keep_adaptive_notch_filter_get_output)(void) = (void (*)(void))adaptive_notch_filter_get_output;
