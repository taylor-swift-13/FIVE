#include "../prepare/source/update_first_order_low_pass_tau.c"
#include <stdint.h>
#include <string.h>
extern float nondet_float(void);
static uint32_t bits(float x) { uint32_t u; memcpy(&u,&x,4); return u; }
void main(void) {
 struct FirstOrderLowPass f={nondet_float(),nondet_float(),nondet_float()};
 struct FirstOrderLowPass old=f;
 float tau=nondet_float(), h=nondet_float(), value=nondet_float();
 float expected=2.0f*tau/h;
 update_first_order_low_pass_tau(&f,tau,h);
 __CPROVER_assert(bits(f.time_const)==bits(expected),"time_const exact source expression bits");
 __CPROVER_assert(bits(f.last_in)==bits(old.last_in),"last_in frame bits");
 __CPROVER_assert(bits(f.last_out)==bits(old.last_out),"last_out frame bits");
}
