/* Exact pinned upstream struct and original function, no callee dependencies. */
struct FirstOrderLowPass {
  float time_const;
  float last_in;
  float last_out;
};

static inline void update_first_order_low_pass_tau(struct FirstOrderLowPass *filter, const float tau,
    const float sample_time)
{
  filter->time_const = 2.0f * tau / sample_time;
}
