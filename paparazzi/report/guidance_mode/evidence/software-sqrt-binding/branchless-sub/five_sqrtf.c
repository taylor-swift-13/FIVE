/* FIVE deterministic software sqrtf: integer restoring square root (branchless steps).
 * Target: IEEE binary32 float and uint32_t/uint64_t; nearest-even result.
 * NaNs retain sign/payload and are quieted; negative nonzero values produce
 * 0x7fc00000; signed zero is preserved. No libm or floating arithmetic.
 *
 * Normalize x = mantissa * 2^(exponent-23) with even exponent. The radicand
 * mantissa*2^23 has fewer than 49 bits. Twenty-four restoring steps obtain
 * floor(sqrt(radicand)) and its remainder. Rounding upward iff remainder
 * exceeds the integer root selects the nearest significand: the squared
 * half-integer threshold is root^2 + root + 1/4, so an integer radicand
 * cannot be a tie. This explanation is not a Rocq accuracy theorem.
 */
/* Step decisions use 0/1 values and exact word masks, rather than control-flow joins. */
/* The mask uses defined uint32_t modular subtraction, not signed overflow. */
#include <stdint.h>

union FiveSqrtBits { float f; uint32_t u; };

#define FIVE_NORMALIZE_STEP \
  { \
    take = (uint32_t)(mantissa < 0x00800000U); \
    mantissa = mantissa << take; \
    exponent = exponent - (int)take; \
  }

#define FIVE_RESTORE_STEP(shift) \
  { \
    pair = (uint32_t)((radicand >> (shift)) & 3ULL); \
    remainder = (remainder << 2) | pair; \
    trial = (root << 2) | 1U; \
    take = (uint32_t)(remainder >= trial); \
    mask = 0U - take; \
    remainder = remainder - (trial & mask); \
    root = (root << 1) | take; \
  }

static float five_sqrtf(float x)
{
  union FiveSqrtBits view;
  uint32_t magnitude;
  uint32_t exponent_bits;
  uint32_t mantissa;
  int exponent;
  int result_exponent;
  uint64_t radicand;
  uint32_t pair;
  uint32_t remainder;
  uint32_t trial;
  uint32_t root;
  uint32_t take;
  uint32_t mask;

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

  exponent_bits = magnitude >> 23;
  mantissa = magnitude & 0x007fffffU;
  if (exponent_bits == 0U) {
    exponent = -126;
    FIVE_NORMALIZE_STEP /*  1 */
    FIVE_NORMALIZE_STEP /*  2 */
    FIVE_NORMALIZE_STEP /*  3 */
    FIVE_NORMALIZE_STEP /*  4 */
    FIVE_NORMALIZE_STEP /*  5 */
    FIVE_NORMALIZE_STEP /*  6 */
    FIVE_NORMALIZE_STEP /*  7 */
    FIVE_NORMALIZE_STEP /*  8 */
    FIVE_NORMALIZE_STEP /*  9 */
    FIVE_NORMALIZE_STEP /* 10 */
    FIVE_NORMALIZE_STEP /* 11 */
    FIVE_NORMALIZE_STEP /* 12 */
    FIVE_NORMALIZE_STEP /* 13 */
    FIVE_NORMALIZE_STEP /* 14 */
    FIVE_NORMALIZE_STEP /* 15 */
    FIVE_NORMALIZE_STEP /* 16 */
    FIVE_NORMALIZE_STEP /* 17 */
    FIVE_NORMALIZE_STEP /* 18 */
    FIVE_NORMALIZE_STEP /* 19 */
    FIVE_NORMALIZE_STEP /* 20 */
    FIVE_NORMALIZE_STEP /* 21 */
    FIVE_NORMALIZE_STEP /* 22 */
    FIVE_NORMALIZE_STEP /* 23 */
  } else {
    exponent = (int)exponent_bits - 127;
    mantissa = mantissa | 0x00800000U;
  }
  take = (uint32_t)(exponent % 2 != 0);
  mantissa = mantissa << take;
  exponent = exponent - (int)take;
  radicand = (uint64_t)mantissa << 23;
  remainder = 0U;
  root = 0U;
  FIVE_RESTORE_STEP(46)
  FIVE_RESTORE_STEP(44)
  FIVE_RESTORE_STEP(42)
  FIVE_RESTORE_STEP(40)
  FIVE_RESTORE_STEP(38)
  FIVE_RESTORE_STEP(36)
  FIVE_RESTORE_STEP(34)
  FIVE_RESTORE_STEP(32)
  FIVE_RESTORE_STEP(30)
  FIVE_RESTORE_STEP(28)
  FIVE_RESTORE_STEP(26)
  FIVE_RESTORE_STEP(24)
  FIVE_RESTORE_STEP(22)
  FIVE_RESTORE_STEP(20)
  FIVE_RESTORE_STEP(18)
  FIVE_RESTORE_STEP(16)
  FIVE_RESTORE_STEP(14)
  FIVE_RESTORE_STEP(12)
  FIVE_RESTORE_STEP(10)
  FIVE_RESTORE_STEP(8)
  FIVE_RESTORE_STEP(6)
  FIVE_RESTORE_STEP(4)
  FIVE_RESTORE_STEP(2)
  FIVE_RESTORE_STEP(0)
  take = (uint32_t)(remainder > root);
  root = root + take;
  result_exponent = exponent / 2 + 127;
  take = (uint32_t)(root == 0x01000000U);
  root = root >> take;
  result_exponent = result_exponent + (int)take;
  view.u = ((uint32_t)result_exponent << 23) | (root & 0x007fffffU);
  return view.f;
}

#undef FIVE_NORMALIZE_STEP
#undef FIVE_RESTORE_STEP
