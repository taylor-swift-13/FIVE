# 0 "/home/yangfp/five/paparazzi/models/reset_first_order_low_pass/prepare/source/reset_first_order_low_pass.c"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "/usr/include/stdc-predef.h" 1 3 4
# 0 "<command-line>" 2
# 1 "/home/yangfp/five/paparazzi/models/reset_first_order_low_pass/prepare/source/reset_first_order_low_pass.c"

struct FirstOrderLowPass {
  float time_const;
  float last_in;
  float last_out;
};

float reset_first_order_low_pass(struct FirstOrderLowPass *filter, const float value)
{
  filter->last_in = value;
  filter->last_out = value;
  return value;
}
