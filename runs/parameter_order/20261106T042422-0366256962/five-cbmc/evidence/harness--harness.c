#include "../prepare/source/gh_set_zeta.c"
/* Union observes the target scalar representation without copying memory. */
extern unsigned int nondet_uint(void);
extern long long nondet_longlong(void);
static float arbitrary_float(void) { union { unsigned int u; float f; } v; v.u=nondet_uint(); return v.f; }
static unsigned int bits(float f) { union { unsigned int u; float f; } v; v.f=f; return v.u; }
int main(void) {
  gh_ref.accel.x=arbitrary_float();
  gh_ref.accel.y=arbitrary_float();
  gh_ref.speed.x=arbitrary_float();
  gh_ref.speed.y=arbitrary_float();
  gh_ref.tau=arbitrary_float();
  gh_ref.omega=arbitrary_float();
  gh_ref.zeta=arbitrary_float();
  gh_ref.max_speed=arbitrary_float();
  gh_ref.zeta_omega=arbitrary_float();
  gh_ref.omega_2=arbitrary_float();
  gh_ref.inv_tau=arbitrary_float();
  gh_ref.dt=arbitrary_float();
  gh_ref.pos.x=nondet_longlong(); gh_ref.pos.y=nondet_longlong();
  struct GuidanceHRef before=gh_ref;
  float z=arbitrary_float();
  float clamped=z; Bound(clamped,0.7f,1.2f);
  float expected_product=clamped*before.omega;
  float returned=gh_set_zeta(z);
  __CPROVER_assert(bits(returned)==bits(clamped) && bits(gh_ref.zeta)==bits(clamped),"returned and stored Bound result bits");
  __CPROVER_assert(bits(gh_ref.zeta_omega)==bits(expected_product),"source-order coefficient product bits");
  __CPROVER_assert(
    bits(gh_ref.accel.x)==bits(before.accel.x) &&
    bits(gh_ref.accel.y)==bits(before.accel.y) &&
    bits(gh_ref.speed.x)==bits(before.speed.x) &&
    bits(gh_ref.speed.y)==bits(before.speed.y) &&
    bits(gh_ref.tau)==bits(before.tau) &&
    bits(gh_ref.omega)==bits(before.omega) &&
    bits(gh_ref.max_speed)==bits(before.max_speed) &&
    bits(gh_ref.omega_2)==bits(before.omega_2) &&
    bits(gh_ref.inv_tau)==bits(before.inv_tau) &&
    bits(gh_ref.dt)==bits(before.dt) &&
    gh_ref.pos.x==before.pos.x &&
    gh_ref.pos.y==before.pos.y,"all unrelated named fields retain initial bits");
  return 0;
}
