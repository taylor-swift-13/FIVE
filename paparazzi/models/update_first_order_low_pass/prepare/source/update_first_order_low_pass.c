struct FirstOrderLowPass {
  float time_const;
  float last_in;
  float last_out;
};

float update_first_order_low_pass(struct FirstOrderLowPass *filter, const float value)
{
  float out = (value + filter->last_in + (filter->time_const - 1.0f) * filter->last_out) / (1.0f + filter->time_const);
  filter->last_in = value;
  filter->last_out = out;
  return out;
}
