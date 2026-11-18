# 0 "/home/yangfp/five/paparazzi/models/update_first_order_low_pass_tau/prepare/source/update_first_order_low_pass_tau.c"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "/usr/include/stdc-predef.h" 1 3 4
# 0 "<command-line>" 2
# 1 "/home/yangfp/five/paparazzi/models/update_first_order_low_pass_tau/prepare/source/update_first_order_low_pass_tau.c"

struct FirstOrderLowPass {
  float time_const;
  float last_in;
  float last_out;
};

void update_first_order_low_pass_tau(struct FirstOrderLowPass *filter, const float tau,
    const float sample_time)
{
  filter->time_const = 2.0f * tau / sample_time;
}
