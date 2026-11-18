#include "/home/yangfp/five/paparazzi/models/gh_update_ref_from_accel_sp/prepare/source/gh_update_ref_from_accel_sp.c"
#include <string.h>
#include <limits.h>
extern float nondet_float(void);
extern int64_t nondet_i64(void);
static uint32_t bits(float x) { uint32_t u; memcpy(&u,&x,4); return u; }
void main(void) {
 gh_ref.accel.x=nondet_float();
 __CPROVER_assume(gh_ref.accel.x>=-16.0f && gh_ref.accel.x<=16.0f);
 gh_ref.accel.y=nondet_float();
 __CPROVER_assume(gh_ref.accel.y>=-16.0f && gh_ref.accel.y<=16.0f);
 gh_ref.speed.x=nondet_float();
 __CPROVER_assume(gh_ref.speed.x>=-16.0f && gh_ref.speed.x<=16.0f);
 gh_ref.speed.y=nondet_float();
 __CPROVER_assume(gh_ref.speed.y>=-16.0f && gh_ref.speed.y<=16.0f);
 gh_ref.tau=nondet_float();
 __CPROVER_assume(gh_ref.tau>=-16.0f && gh_ref.tau<=16.0f);
 gh_ref.omega=nondet_float();
 __CPROVER_assume(gh_ref.omega>=-16.0f && gh_ref.omega<=16.0f);
 gh_ref.zeta=nondet_float();
 __CPROVER_assume(gh_ref.zeta>=-16.0f && gh_ref.zeta<=16.0f);
 gh_ref.max_speed=nondet_float();
 __CPROVER_assume(gh_ref.max_speed>=-16.0f && gh_ref.max_speed<=16.0f);
 gh_ref.zeta_omega=nondet_float();
 __CPROVER_assume(gh_ref.zeta_omega>=-16.0f && gh_ref.zeta_omega<=16.0f);
 gh_ref.omega_2=nondet_float();
 __CPROVER_assume(gh_ref.omega_2>=-16.0f && gh_ref.omega_2<=16.0f);
 gh_ref.inv_tau=nondet_float();
 __CPROVER_assume(gh_ref.inv_tau>=-16.0f && gh_ref.inv_tau<=16.0f);
 gh_ref.dt=nondet_float();
 __CPROVER_assume(gh_ref.dt>=-16.0f && gh_ref.dt<=16.0f);
 gh_ref.pos.x=nondet_i64(); gh_ref.pos.y=nondet_i64();
 struct GuidanceHRef old=gh_ref;
 struct FloatVect2 input={nondet_float(),nondet_float()};
 __CPROVER_assume(input.x>=-16.0f && input.x<=16.0f);
 __CPROVER_assume(input.y>=-16.0f && input.y<=16.0f);
 float scaled_x=(old.speed.x*old.dt)*(1LL<<GH_POS_REF_FRAC);
 __CPROVER_assume(scaled_x>-0x1p63f && scaled_x<0x1p63f);
 int64_t delta_x=scaled_x;
 __CPROVER_assume(delta_x>=0 ? old.pos.x<=INT64_MAX-delta_x : old.pos.x>=INT64_MIN-delta_x);
 float speed_x=old.speed.x+old.accel.x*old.dt;
 float scaled_y=(old.speed.y*old.dt)*(1LL<<GH_POS_REF_FRAC);
 __CPROVER_assume(scaled_y>-0x1p63f && scaled_y<0x1p63f);
 int64_t delta_y=scaled_y;
 __CPROVER_assume(delta_y>=0 ? old.pos.y<=INT64_MAX-delta_y : old.pos.y>=INT64_MIN-delta_y);
 float speed_y=old.speed.y+old.accel.y*old.dt;
 struct FloatVect2 expected;
 expected.x=input.x;
 expected.y=input.y;
 float norm2=expected.x*expected.x+expected.y*expected.y;
 if(norm2>gh_max_accel*gh_max_accel){ float factor=gh_max_accel/sqrtf(norm2); expected.x=expected.x*factor; expected.y=expected.y*factor; }
 gh_update_ref_from_accel_sp(input);
 __CPROVER_assert(gh_ref.pos.x==old.pos.x+delta_x,"position x integration");
 __CPROVER_assert(bits(gh_ref.speed.x)==bits(speed_x),"speed x source order bits");
 __CPROVER_assert(bits(gh_ref.accel.x)==bits(expected.x),"acceleration x saturation bits");
 __CPROVER_assert(gh_ref.pos.y==old.pos.y+delta_y,"position y integration");
 __CPROVER_assert(bits(gh_ref.speed.y)==bits(speed_y),"speed y source order bits");
 __CPROVER_assert(bits(gh_ref.accel.y)==bits(expected.y),"acceleration y saturation bits");
 __CPROVER_assert(bits(gh_ref.tau)==bits(old.tau) && bits(gh_ref.omega)==bits(old.omega) && bits(gh_ref.zeta)==bits(old.zeta) && bits(gh_ref.max_speed)==bits(old.max_speed) && bits(gh_ref.zeta_omega)==bits(old.zeta_omega) && bits(gh_ref.omega_2)==bits(old.omega_2) && bits(gh_ref.inv_tau)==bits(old.inv_tau) && bits(gh_ref.dt)==bits(old.dt),"all eight parameter fields bit frame");
}
