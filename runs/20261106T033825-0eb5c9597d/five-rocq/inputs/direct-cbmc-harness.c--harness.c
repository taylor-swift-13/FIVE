#include "../prepare/source/gh_set_omega.c"
#include <string.h>
extern float nondet_float(void);
extern int64_t nondet_i64(void);
static uint32_t bits(float x) { uint32_t u; memcpy(&u,&x,4); return u; }
void main(void) {
 gh_ref.accel.x = nondet_float();
 gh_ref.accel.y = nondet_float();
 gh_ref.speed.x = nondet_float();
 gh_ref.speed.y = nondet_float();
 gh_ref.tau = nondet_float();
 gh_ref.omega = nondet_float();
 gh_ref.zeta = nondet_float();
 gh_ref.max_speed = nondet_float();
 gh_ref.zeta_omega = nondet_float();
 gh_ref.omega_2 = nondet_float();
 gh_ref.inv_tau = nondet_float();
 gh_ref.dt = nondet_float();
 gh_ref.pos.x=nondet_i64(); gh_ref.pos.y=nondet_i64();
 struct GuidanceHRef old=gh_ref;
 float o=nondet_float(); float e=o; Bound(e,0.1f,5.0f);
 float e2=e*e; float ez=old.zeta*e;
 float ret=gh_set_omega(o);
 __CPROVER_assert(bits(ret)==bits(e) && bits(gh_ref.omega)==bits(e), "returned and stored Bound result bits");
 __CPROVER_assert(bits(gh_ref.omega_2)==bits(e2), "omega_2 source-order multiplication bits");
 __CPROVER_assert(bits(gh_ref.zeta_omega)==bits(ez), "zeta_omega source-order multiplication bits");
 __CPROVER_assert(bits(gh_ref.accel.x)==bits(old.accel.x) && bits(gh_ref.accel.y)==bits(old.accel.y) && bits(gh_ref.speed.x)==bits(old.speed.x) && bits(gh_ref.speed.y)==bits(old.speed.y) && bits(gh_ref.tau)==bits(old.tau) && bits(gh_ref.zeta)==bits(old.zeta) && bits(gh_ref.max_speed)==bits(old.max_speed) && bits(gh_ref.inv_tau)==bits(old.inv_tau) && bits(gh_ref.dt)==bits(old.dt) && gh_ref.pos.x==old.pos.x && gh_ref.pos.y==old.pos.y, "unaffected named fields bit frame");
}
