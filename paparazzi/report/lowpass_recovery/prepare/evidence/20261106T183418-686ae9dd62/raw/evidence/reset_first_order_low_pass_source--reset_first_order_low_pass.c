/* Exact pinned upstream struct and original function, no callee dependencies. */
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
