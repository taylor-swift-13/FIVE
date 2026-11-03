/* FIVE explicit binary32 sine/cosine implementation.
 * No libm call, intrinsic, floating-to-integer conversion or type-punned load.
 * 256-bit fixed-point 2/pi reduction, binary64 polynomial, binary32 result.
 * This is a project implementation, not a claim of correctly-rounded libm.
 */
typedef unsigned int five_u32;
typedef unsigned long long five_u64;

static const five_u32 five_two_over_pi[8] = {
  0xdebbc561U, 0xfe5163abU, 0x3c439041U, 0xdb629599U,
  0xf534ddc0U, 0xfc2757d1U, 0x4e441529U, 0xa2f9836eU
};

static void five_copy4(void *dst, const void *src)
{
  unsigned char *d = dst;
  const unsigned char *s = src;
  int i;
  for (i = 0; i < 4; i = i + 1) d[i] = s[i];
}

five_u32 five_float_bits(float x)
{
  five_u32 u;
  five_copy4(&u, &x);
  return u;
}

float five_float_from_bits(five_u32 u)
{
  float x;
  five_copy4(&x, &u);
  return x;
}

static unsigned five_product_bit(const five_u32 *p, int bit)
{
  if (bit < 0 || bit >= 288) return 0U;
  return (p[bit / 32] >> (bit % 32)) & 1U;
}

static float five_trig(float x, unsigned cosine)
{
  five_u32 ux = five_float_bits(x);
  five_u32 ax = ux & 0x7fffffffU;
  unsigned neg = ux >> 31;
  unsigned q = 0;
  double r;
  double z, sn, cs, y;
  if (ax >= 0x7f800000U) {
    /* Preserve NaN sign/payload, quiet sNaN; infinity has canonical qNaN. */
    if (ax > 0x7f800000U) return five_float_from_bits(ux | 0x00400000U);
    return five_float_from_bits(0x7fc00000U);
  }
  if (ax == 0U) {
    if (cosine) return 1.0f;
    return x;
  }
  if (ax <= 0x3f490fdaU) {
    r = (double)five_float_from_bits(ax);
  } else {
    five_u32 p[9];
    five_u32 m = (ax & 0x007fffffU) | 0x00800000U;
    int e = (int)(ax >> 23) - 150;
    int shift = 256 - e;
    five_u64 carry = 0;
    five_u64 t;
    double frac = 0.0;
    unsigned round;
    int i;
    for (i = 0; i < 8; i = i + 1) {
      t = (five_u64)five_two_over_pi[i] * (five_u64)m + carry;
      p[i] = (five_u32)t;
      carry = t >> 32;
    }
    p[8] = (five_u32)carry;
    q = five_product_bit(p, shift) + 2U * five_product_bit(p, shift + 1);
    round = five_product_bit(p, shift - 1);
    /* Build the leading 64 fractional bits, from least to most significant. */
    for (i = 0; i < 64; i = i + 1) {
      frac = 0.5 * frac + 0.5 * (double)five_product_bit(p, shift - 64 + i);
    }
    q = (q + round) & 3U;
    frac = frac - (double)round;
    r = frac * 1.57079632679489655800 + frac * 6.12323399573676603587e-17;
  }
  z = r * r;
  sn = r + (r * z) * (-1.66666666666666666667e-1 + z *
       (8.33333333333333333333e-3 + z * (-1.98412698412698412698e-4 + z *
       (2.75573192239858906526e-6 + z * (-2.50521083854417187751e-8 + z *
       (1.60590438368216145994e-10 + z * (-7.64716373181981647590e-13 + z *
       2.81145725434552076320e-15)))))));
  cs = 1.0 + z * (-0.5 + z * (4.16666666666666666667e-2 + z *
       (-1.38888888888888888889e-3 + z * (2.48015873015873015873e-5 + z *
       (-2.75573192239858906526e-7 + z * (2.08767569878680989792e-9 + z *
       (-1.14707455977297247139e-11 + z * 4.77947733238738529744e-14)))))));
  if (cosine) {
    if (q == 0U) y = cs;
    else if (q == 1U) y = -sn;
    else if (q == 2U) y = -cs;
    else y = sn;
  } else {
    if (q == 0U) y = sn;
    else if (q == 1U) y = cs;
    else if (q == 2U) y = -sn;
    else y = -cs;
    if (neg) y = -y;
  }
  return (float)y;
}

float five_sinf(float x) { return five_trig(x, 0U); }
float five_cosf(float x) { return five_trig(x, 1U); }
