#include <math.h>
#include <stdio.h>
#include <stdint.h>
#include "five_sqrtf.c"

static unsigned long tested;
static int check(uint32_t bits)
{
  union FiveSqrtBits input, got, expected;
  input.u = bits;
  got.f = five_sqrtf(input.f);
  uint32_t magnitude = bits & 0x7fffffffU;
  if (magnitude > 0x7f800000U) {
    expected.u = bits | 0x00400000U;
  } else if (magnitude == 0U) {
    expected.u = bits;
  } else if ((bits & 0x80000000U) != 0U) {
    expected.u = 0x7fc00000U;
  } else {
    expected.f = sqrtf(input.f);
  }
  ++tested;
  if (got.u != expected.u) {
    printf("FAIL input=%08x got=%08x expected=%08x\n", bits, got.u, expected.u);
    return 1;
  }
  return 0;
}

int main(void)
{
  static const uint32_t mantissas[] = {0U,1U,2U,0x3fffffU,0x400000U,0x7ffffdU,0x7ffffeU,0x7fffffU};
  for (unsigned e=0; e<256; ++e) {
    for (unsigned k=0; k<sizeof(mantissas)/sizeof(mantissas[0]); ++k) {
      uint32_t u=(e<<23)|mantissas[k];
      if (check(u) || check(u|0x80000000U)) return 1;
    }
  }
  for (unsigned i=0; i<65536; ++i) {
    union FiveSqrtBits value;
    value.f=(float)i;
    if (check(value.u)) return 1;
  }
  uint32_t rng=0x31415926U;
  for (unsigned i=0; i<1000000; ++i) {
    rng=rng*1664525U+1013904223U;
    if (check(rng)) return 1;
  }
  printf("{\"tested\":%lu,\"mismatches\":0,\"finite_positive_reference\":\"native_libm_sqrtf\",\"other_patterns\":\"explicit_fixed_policy\"}\n",tested);
  return 0;
}
