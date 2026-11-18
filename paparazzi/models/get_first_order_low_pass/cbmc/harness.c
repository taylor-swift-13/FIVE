#include "../prepare/source/get_first_order_low_pass.c"
#include <stdint.h>
#include <string.h>
extern float nondet_float(void);
static uint32_t bits(float x) { uint32_t u; memcpy(&u,&x,4); return u; }
void main(void) {
 struct FirstOrderLowPass f={nondet_float(),nondet_float(),nondet_float()};
 struct FirstOrderLowPass old=f;
 float result=get_first_order_low_pass(&f);
 __CPROVER_assert(bits(result)==bits(old.last_out),"getter returns last_out exact bits");
 __CPROVER_assert(bits(f.time_const)==bits(old.time_const),"time_const readonly");
 __CPROVER_assert(bits(f.last_in)==bits(old.last_in),"last_in readonly");
 __CPROVER_assert(bits(f.last_out)==bits(old.last_out),"last_out readonly");
}
