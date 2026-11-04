#include "std.h"
#include "filters/delayed_first_order_lowpass_filter.h"
void (*five_keep_delayed_first_order_lowpass_propagate)(void) = (void (*)(void))delayed_first_order_lowpass_propagate;
void (*five_keep_delayed_first_order_lowpass_set_omega)(void) = (void (*)(void))delayed_first_order_lowpass_set_omega;
void (*five_keep_delayed_first_order_lowpass_set_delay)(void) = (void (*)(void))delayed_first_order_lowpass_set_delay;
void (*five_keep_delayed_first_order_lowpass_initialize)(void) = (void (*)(void))delayed_first_order_lowpass_initialize;
