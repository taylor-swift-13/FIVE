#include "std.h"
#include "filters/pid.h"
void (*five_keep_init_pid_f)(void) = (void (*)(void))init_pid_f;
void (*five_keep_get_pid_f)(void) = (void (*)(void))get_pid_f;
void (*five_keep_reset_pid_f)(void) = (void (*)(void))reset_pid_f;
void (*five_keep_set_gains_pid_f)(void) = (void (*)(void))set_gains_pid_f;
void (*five_keep_set_integral_pid_f)(void) = (void (*)(void))set_integral_pid_f;
void (*five_keep_init_pid_df)(void) = (void (*)(void))init_pid_df;
void (*five_keep_update_pid_df)(void) = (void (*)(void))update_pid_df;
void (*five_keep_get_pid_df)(void) = (void (*)(void))get_pid_df;
void (*five_keep_reset_pid_df)(void) = (void (*)(void))reset_pid_df;
void (*five_keep_set_gains_pid_df)(void) = (void (*)(void))set_gains_pid_df;
void (*five_keep_init_pi_d_df)(void) = (void (*)(void))init_pi_d_df;
void (*five_keep_update_pi_d_df)(void) = (void (*)(void))update_pi_d_df;
void (*five_keep_get_pi_d_df)(void) = (void (*)(void))get_pi_d_df;
void (*five_keep_reset_pi_d_df)(void) = (void (*)(void))reset_pi_d_df;
void (*five_keep_set_gains_pi_d_df)(void) = (void (*)(void))set_gains_pi_d_df;
void (*five_keep_update_pid_f)(void) = (void (*)(void))update_pid_f;
