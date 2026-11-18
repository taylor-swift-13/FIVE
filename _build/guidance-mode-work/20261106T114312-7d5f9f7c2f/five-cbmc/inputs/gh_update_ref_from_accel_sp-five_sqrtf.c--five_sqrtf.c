/* FIVE fixed executable binary32 square-root binding.
 * Original implementation for this project; no host sqrt/libm call.
 * Target: IEEE binary32 float, binary64 double, uint32_t, nearest/even.
 * NaNs retain sign/payload and are quieted; negative nonzero values produce
 * the fixed positive quiet NaN 0x7fc00000. Signed zero is preserved.
 *
 * For finite positive input, binary-search adjacent positive float encodings.
 * Each float significand has at most 24 bits, so its square is exact in
 * binary64. The midpoint of adjacent floats has at most 25 bits, and its
 * square is also exact in binary64. The final comparison therefore selects
 * the nearest result, with ties resolved by the low encoding bit.
 * This algorithm explanation is not a Rocq accuracy proof.
 */
#include <stdint.h>

union FiveSqrtBits {
  float f;
  uint32_t u;
};

/* A block, not a loop: the compiler sees a finite acyclic statement tree. */
#define FIVE_SQRT_STEP \
  { \
    mid = lo + ((hi - lo) >> 1); \
    view.u = mid; \
    candidate = (double)view.f; \
    if (candidate * candidate <= target) { lo = mid; } \
    else { hi = mid; } \
  }

static float five_sqrtf(float x)
{
  union FiveSqrtBits view;
  uint32_t magnitude;
  uint32_t lo;
  uint32_t hi;
  uint32_t mid;
  double candidate;
  double target;
  double lower;
  double upper;
  double midpoint;
  double midpoint_square;

  view.f = x;
  magnitude = view.u & 0x7fffffffU;
  if (magnitude > 0x7f800000U) {
    view.u = view.u | 0x00400000U;
    return view.f;
  }
  if (magnitude == 0U) {
    return x;
  }
  if ((view.u & 0x80000000U) != 0U) {
    view.u = 0x7fc00000U;
    return view.f;
  }
  if (magnitude == 0x7f800000U) {
    return x;
  }

  target = (double)x;
  lo = 0U;
  hi = 0x7f800000U;
  FIVE_SQRT_STEP /*  1 */
  FIVE_SQRT_STEP /*  2 */
  FIVE_SQRT_STEP /*  3 */
  FIVE_SQRT_STEP /*  4 */
  FIVE_SQRT_STEP /*  5 */
  FIVE_SQRT_STEP /*  6 */
  FIVE_SQRT_STEP /*  7 */
  FIVE_SQRT_STEP /*  8 */
  FIVE_SQRT_STEP /*  9 */
  FIVE_SQRT_STEP /* 10 */
  FIVE_SQRT_STEP /* 11 */
  FIVE_SQRT_STEP /* 12 */
  FIVE_SQRT_STEP /* 13 */
  FIVE_SQRT_STEP /* 14 */
  FIVE_SQRT_STEP /* 15 */
  FIVE_SQRT_STEP /* 16 */
  FIVE_SQRT_STEP /* 17 */
  FIVE_SQRT_STEP /* 18 */
  FIVE_SQRT_STEP /* 19 */
  FIVE_SQRT_STEP /* 20 */
  FIVE_SQRT_STEP /* 21 */
  FIVE_SQRT_STEP /* 22 */
  FIVE_SQRT_STEP /* 23 */
  FIVE_SQRT_STEP /* 24 */
  FIVE_SQRT_STEP /* 25 */
  FIVE_SQRT_STEP /* 26 */
  FIVE_SQRT_STEP /* 27 */
  FIVE_SQRT_STEP /* 28 */
  FIVE_SQRT_STEP /* 29 */
  FIVE_SQRT_STEP /* 30 */
  FIVE_SQRT_STEP /* 31 */

  view.u = lo;
  lower = (double)view.f;
  view.u = hi;
  upper = (double)view.f;
  midpoint = (lower + upper) * 0.5;
  midpoint_square = midpoint * midpoint;
  if (target < midpoint_square) {
    view.u = lo;
  } else if (target > midpoint_square) {
    view.u = hi;
  } else if ((lo & 1U) == 0U) {
    view.u = lo;
  } else {
    view.u = hi;
  }
  return view.f;
}

#undef FIVE_SQRT_STEP
