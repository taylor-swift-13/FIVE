#include <stdbool.h>
#include <stdint.h>
#include <string.h>
bool float_mat_inv_2d(float out[4], const float in[4]);
extern float nondet_float(void);
int main(void) {
  float arbitrary[4];
  arbitrary[0] = nondet_float();
  arbitrary[1] = nondet_float();
  arbitrary[2] = nondet_float();
  arbitrary[3] = nondet_float();
  struct { uint32_t before; float value[4]; uint32_t after; } guarded = {.before=0x12345678u, .after=0x9abcdef0u};
  bool arbitrary_status = float_mat_inv_2d(guarded.value, arbitrary);
  __CPROVER_assert(arbitrary_status == 0 || arbitrary_status == 1, "return status is boolean for arbitrary binary32 matrix");
  __CPROVER_assert(guarded.before == 0x12345678u && guarded.after == 0x9abcdef0u, "arbitrary matrix call preserves surrounding frame words");
  float base[4] = {1.0f, 0.0f, 0.0f, 1.0f};
  float small[4] = {0x1p-8f, 0.0f, 0.0f, 0x1p-8f};
  float large[4] = {0x1p100f, 0.0f, 0.0f, 0x1p100f};
  float base_out[4] = {17.0f, 0.0f, 0.0f, 17.0f};
  float small_out[4] = {17.0f, 0.0f, 0.0f, 17.0f};
  float large_out[4] = {17.0f, 0.0f, 0.0f, 17.0f};
  uint32_t base_words[4], small_before[4], small_after[4], large_words[4];
  memcpy(small_before, small_out, sizeof small_out);
  bool base_status = float_mat_inv_2d(base_out, base);
  bool small_status = float_mat_inv_2d(small_out, small);
  bool large_status = float_mat_inv_2d(large_out, large);
  memcpy(base_words, base_out, sizeof base_out);
  memcpy(small_after, small_out, sizeof small_out);
  memcpy(large_words, large_out, sizeof large_out);
  __CPROVER_assert(base_status == 0, "identity call succeeds");
  __CPROVER_assert(base_words[0] == 0x3f800000u && base_words[1] == 0x80000000u && base_words[2] == 0x80000000u && base_words[3] == 0x3f800000u, "identity exact signedzero output bits");
  __CPROVER_assert(small_status == 1, "small conditionone diagonal call rejects");
  __CPROVER_assert(small_before[0] == small_after[0] && small_before[1] == small_after[1] && small_before[2] == small_after[2] && small_before[3] == small_after[3], "rejected call preserves every output byte");
  __CPROVER_assert(large_status == 0, "finite large diagonal call reports success");
  __CPROVER_assert(large_words[0] == 0x00000000u && large_words[1] == 0x80000000u && large_words[2] == 0x80000000u && large_words[3] == 0x00000000u, "overflow determinant exact signedzero output bits");
  __CPROVER_assert(base_status == small_status, "positive scaling preserves inverse status");
  float residual = large[0] * large_out[0] - 1.0f;
  __CPROVER_assert(large_status != 0 || (residual > -0.5f && residual < 0.5f), "successful wellconditioned inverse has residual component below half");
  return 0;
}
