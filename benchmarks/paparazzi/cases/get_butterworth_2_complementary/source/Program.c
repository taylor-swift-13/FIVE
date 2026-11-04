#include "filters/complementary_filter.h"
void (*five_keep_init_first_order_complementary)(void) = (void (*)(void))init_first_order_complementary;
void (*five_keep_update_first_order_complementary)(void) = (void (*)(void))update_first_order_complementary;
void (*five_keep_reset_first_order_complementary)(void) = (void (*)(void))reset_first_order_complementary;
void (*five_keep_get_first_order_complementary)(void) = (void (*)(void))get_first_order_complementary;
void (*five_keep_init_second_order_complementary)(void) = (void (*)(void))init_second_order_complementary;
void (*five_keep_update_second_order_complementary)(void) = (void (*)(void))update_second_order_complementary;
void (*five_keep_reset_second_order_complementary)(void) = (void (*)(void))reset_second_order_complementary;
void (*five_keep_get_second_order_complementary)(void) = (void (*)(void))get_second_order_complementary;
void (*five_keep_init_butterworth_2_complementary)(void) = (void (*)(void))init_butterworth_2_complementary;
void (*five_keep_update_butterworth_2_complementary)(void) = (void (*)(void))update_butterworth_2_complementary;
void (*five_keep_reset_butterworth_2_complementary)(void) = (void (*)(void))reset_butterworth_2_complementary;
void (*five_keep_get_butterworth_2_complementary)(void) = (void (*)(void))get_butterworth_2_complementary;
void (*five_keep_init_butterworth_4_complementary)(void) = (void (*)(void))init_butterworth_4_complementary;
void (*five_keep_update_butterworth_4_complementary)(void) = (void (*)(void))update_butterworth_4_complementary;
void (*five_keep_reset_butterworth_4_complementary)(void) = (void (*)(void))reset_butterworth_4_complementary;
void (*five_keep_get_butterworth_4_complementary)(void) = (void (*)(void))get_butterworth_4_complementary;
