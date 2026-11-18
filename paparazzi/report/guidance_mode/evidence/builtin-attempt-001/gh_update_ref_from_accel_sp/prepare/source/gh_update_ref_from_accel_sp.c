/* Pinned unchanged Paparazzi slices; explicit fixed sqrt binding below. */
#include <stdint.h>
/* Fixed executable binding: binary64 sqrt, then binary32 cast. */
#define sqrtf(x) ((float)__builtin_sqrt((double)(x)))

struct FloatVect2 {
  float x;
  float y;
};

struct Int64Vect2 {
  int64_t x;
  int64_t y;
};

#ifndef GUIDANCE_H_REF_MAX_ACCEL
#define GUIDANCE_H_REF_MAX_ACCEL 5.66
#endif

#define GH_POS_REF_FRAC 37

struct GuidanceHRef {
  /** Reference model acceleration.
   * in meters/sec2 (output)
   */
  struct FloatVect2 accel;

  /** Reference model speed.
   * in meters/sec
   * accuracy 0.0000076 , range 16384m/s
   */
  struct FloatVect2 speed;

  /** Reference model position.
   * in meters
   * with fixedpoint representation: Q37.26
   */
  struct Int64Vect2 pos;

  float tau;    ///< first order time constant
  float omega;  ///< second order model natural frequency
  float zeta;   ///< second order model damping

  /** Current maximum speed for waypoint navigation.
   * Defaults to #GUIDANCE_H_REF_MAX_SPEED
   */
  float max_speed;

  /*
   * internal variables
   */
  float zeta_omega;
  float omega_2;
  float inv_tau;

  /** Integration timestep
   */
  float dt;
};

#define VECT2_COPY(_a, _b) {      \
    (_a).x = (_b).x;        \
    (_a).y = (_b).y;        \
  }


#define VECT2_ADD(_a, _b) {     \
    (_a).x += (_b).x;       \
    (_a).y += (_b).y;       \
  }


#define VECT2_DIFF(_c, _a, _b) {                \
    (_c).x = (_a).x - (_b).x;     \
    (_c).y = (_a).y - (_b).y;     \
  }


#define VECT2_SMUL(_vo, _vi, _s) {    \
    (_vo).x =  (_vi).x * (_s);      \
    (_vo).y =  (_vi).y * (_s);      \
  }


#define VECT2_NORM2(_v) ((_v).x*(_v).x + (_v).y*(_v).y)

#define LBFP_OF_REAL(_vr, _frac)   ((_vr)*(1LL<<(_frac)))

struct GuidanceHRef gh_ref;

static const float gh_max_accel = GUIDANCE_H_REF_MAX_ACCEL;

static void gh_saturate_accel(struct FloatVect2 *accel_sp);

void gh_update_ref_from_accel_sp(struct FloatVect2 accel_sp)
{
  struct FloatVect2 pos_step, speed_step;

  VECT2_SMUL(pos_step, gh_ref.speed, gh_ref.dt);
  VECT2_SMUL(speed_step, gh_ref.accel, gh_ref.dt);

  struct Int64Vect2 pos_update;
  pos_update.x = LBFP_OF_REAL(pos_step.x, GH_POS_REF_FRAC);
  pos_update.y = LBFP_OF_REAL(pos_step.y, GH_POS_REF_FRAC);

  VECT2_ADD(gh_ref.pos, pos_update);
  VECT2_ADD(gh_ref.speed, speed_step);

  gh_saturate_accel(&accel_sp);

  // copy accel
  VECT2_COPY(gh_ref.accel, accel_sp);
}

static void gh_saturate_accel(struct FloatVect2 *accel_sp)
{
  // Accel squared
  float a_norm2 = VECT2_NORM2(*accel_sp);

  // Apply saturation if above max speed
  if (a_norm2 > (gh_max_accel * gh_max_accel)) {
    // accel_sp/sqrt(a_norm2)*amax
    float factor = gh_max_accel / sqrtf(a_norm2);
    VECT2_SMUL(*accel_sp, *accel_sp, factor);
  }
}
