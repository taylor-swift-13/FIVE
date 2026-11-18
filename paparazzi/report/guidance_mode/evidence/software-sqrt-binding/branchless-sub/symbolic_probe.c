#include "five_sqrtf.c"
extern float nondet_float(void);
static uint32_t bits(float x) { union FiveSqrtBits u; u.f=x; return u.u; }
void main(void) {
  float x=nondet_float();
  uint32_t a=bits(five_sqrtf(x));
  uint32_t b=bits(five_sqrtf(x));
  __CPROVER_assert(a==b,"deterministic output bits for arbitrary input");
}
