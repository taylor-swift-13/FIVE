#include "filters/quaternion_filter.h"
void (*five_keep_init_quat_second_order_low_pass)(void) = (void (*)(void))init_quat_second_order_low_pass;
void (*five_keep_reset_quat_second_order_low_pass)(void) = (void (*)(void))reset_quat_second_order_low_pass;
void (*five_keep_update_quat_second_order_low_pass)(void) = (void (*)(void))update_quat_second_order_low_pass;
void (*five_keep_get_quat_second_order_low_pass)(void) = (void (*)(void))get_quat_second_order_low_pass;
void (*five_keep_init_quat_butterworth_low_pass)(void) = (void (*)(void))init_quat_butterworth_low_pass;
void (*five_keep_update_quat_butterworth_low_pass)(void) = (void (*)(void))update_quat_butterworth_low_pass;
void (*five_keep_reset_quat_butterworth_low_pass)(void) = (void (*)(void))reset_quat_butterworth_low_pass;
void (*five_keep_get_quat_butterworth_low_pass)(void) = (void (*)(void))get_quat_butterworth_low_pass;
