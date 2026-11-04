#include "filters/notch_filter_float.h"
void (*five_keep_notch_filter_set_sampling_frequency)(void) = (void (*)(void))notch_filter_set_sampling_frequency;
void (*five_keep_notch_filter_set_bandwidth)(void) = (void (*)(void))notch_filter_set_bandwidth;
void (*five_keep_notch_filter_get_output)(void) = (void (*)(void))notch_filter_get_output;
