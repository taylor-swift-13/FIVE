/* Exact pinned Paparazzi dependency/entry slices; see extraction.json. */
#include <stdint.h>

struct FloatVect2 {
  float x;
  float y;
};

struct Int64Vect2 {
  int64_t x;
  int64_t y;
};

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

#define Bound(_x, _min, _max) { if (!(_x > (_min))) _x = (_min); else if (!(_x < (_max))) _x = (_max); }

struct GuidanceHRef gh_ref;

float gh_set_omega(float omega)
{
  gh_ref.omega = omega;
  Bound(gh_ref.omega, 0.1f, 5.0f);
  gh_ref.omega_2 = gh_ref.omega * gh_ref.omega;
  gh_ref.zeta_omega = gh_ref.zeta * gh_ref.omega;
  return gh_ref.omega;
}
