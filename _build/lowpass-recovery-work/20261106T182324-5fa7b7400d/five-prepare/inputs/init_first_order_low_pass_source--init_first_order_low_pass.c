/* Exact pinned upstream struct and original function, no callee dependencies. */
struct FirstOrderLowPass {
  float time_const;
  float last_in;
  float last_out;
};

static inline void init_first_order_low_pass(struct FirstOrderLowPass *filter, float tau, const float sample_time,
    float value)
{
  filter->last_in = value;
  filter->last_out = value;
  filter->time_const = 2.0f * tau / sample_time;
}
