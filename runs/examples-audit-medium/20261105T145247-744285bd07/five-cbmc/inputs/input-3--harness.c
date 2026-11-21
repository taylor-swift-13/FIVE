#include <stdint.h>
#include <string.h>
extern float sum3(float, float, float);
extern float nondet_float(void);
int main(void) {
  float a=nondet_float(), b=nondet_float(), c=nondet_float();
  (void)sum3(a,b,c);
  float result=sum3(16777216.0f,1.0f,-16777216.0f);
  uint32_t bits;
  memcpy(&bits,&result,sizeof bits);
  __CPROVER_assert(bits==UINT32_C(0), "sum3 result bits");
  return 0;
}
