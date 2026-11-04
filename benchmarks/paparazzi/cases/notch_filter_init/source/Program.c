#include "filters/notch_filter_float.h"
void (*five_keep_notch_filter_init)(void) = (void (*)(void))notch_filter_init;
void (*five_keep_notch_filter_update)(void) = (void (*)(void))notch_filter_update;
void (*five_keep_notch_filter_set_filter_frequency)(void) = (void (*)(void))notch_filter_set_filter_frequency;
