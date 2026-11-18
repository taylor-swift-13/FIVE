#include "../prepare/source/init_first_order_low_pass.c"
#include <stdint.h>
#include <string.h>
extern float nondet_float(void);
static uint32_t bits(float x) { uint32_t u; memcpy(&u,&x,4); return u; }
void main(void) {
 struct FirstOrderLowPass f={nondet_float(),nondet_float(),nondet_float()};
 struct FirstOrderLowPass old=f;
 float tau=nondet_float(), h=nondet_float(), value=nondet_float();
 init_first_order_low_pass(&f,tau,h,value);
 __CPROVER_assert(bits(f.last_in)==bits(value),"last_in exact value bits");
 __CPROVER_assert(bits(f.last_out)==bits(value),"last_out exact value bits");
}
