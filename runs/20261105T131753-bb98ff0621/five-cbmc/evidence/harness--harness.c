#include "../prepare/source/sum2.c"
extern float nondet_float(void);
void main(void) {
 float a = nondet_float();
 float b = nondet_float();
 (void)sum2(a,b);
 float r = sum2(16777216.0f, 1.0f);
 __CPROVER_assert(r == 16777216.0f, "binary32 ties-to-even: 2^24 + 1 rounds to 2^24 (bits 0x4b800000)");
}
