#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <fenv.h>
#include <xmmintrin.h>
extern float sum3(float, float, float);
static float from_bits(uint32_t u) { float f; memcpy(&f,&u,4); return f; }
static uint32_t to_bits(float f) { uint32_t u; memcpy(&u,&f,4); return u; }
int main(void) {
  uint32_t inputs[][3]={{0x4b800000,0x3f800000,0xcb800000},
                       {0x7fc00042,0x00000000,0x00000000}};
  fesetround(FE_TONEAREST);
  _mm_setcsr(0x1f80); /* RNE, exceptions masked, gradual underflow. */
  for (int i=0;i<2;i++) {
    float r=sum3(from_bits(inputs[i][0]),from_bits(inputs[i][1]),from_bits(inputs[i][2]));
    printf("%s %08x\n",i==0?"finite":"nan",to_bits(r));
  }
  return 0;
}
