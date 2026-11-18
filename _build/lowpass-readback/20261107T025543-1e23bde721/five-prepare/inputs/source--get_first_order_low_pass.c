struct FirstOrderLowPass {
  float time_const;
  float last_in;
  float last_out;
};

float get_first_order_low_pass(const struct FirstOrderLowPass *filter)
{
  return filter->last_out;
}
