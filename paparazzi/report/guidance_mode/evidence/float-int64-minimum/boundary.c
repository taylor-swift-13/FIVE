#include <stdint.h>
void main(void) {
  float x = -0x1p63f;
  int64_t y = (int64_t)x;
  __CPROVER_assert(y == INT64_MIN, "exact minimum returned");
}
