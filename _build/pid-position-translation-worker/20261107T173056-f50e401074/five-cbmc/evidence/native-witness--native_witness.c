#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <guidance_pid_h_run_pos.c>
/* Native witness-only traps; unreachable because genuine NEDi caches are valid.
 * These are never used as the CompCert model or CBMC program bindings. */
void stateCalcPositionNed_i(void) { abort(); }
void stateCalcSpeedNed_i(void) { abort(); }
int main(void) {
 for(int sat=0;sat<=1;sat++) for(int flight=0;flight<=1;flight++) {
  struct HorizontalGuidance a={0},b={0};
  a.ref.pos.x=2560;b.ref.pos.x=28160;
  state.pos_status=1u<<POS_NED_I;state.speed_status=1u<<SPEED_NED_I;
  guidance_pid=(struct GuidancePID){.kp=100,.ki=1};
  guidance_pid_trim_att_integrator=(struct Int32Vect2){.x=sat ? 93650940 : 0};state.ned_pos_i.x=2048;
  struct StabilizationSetpoint ra=guidance_pid_h_run_pos(flight,&a);
  struct Int32Vect2 ia=guidance_pid_trim_att_integrator;
  guidance_pid=(struct GuidancePID){.kp=100,.ki=1};
  guidance_pid_trim_att_integrator=(struct Int32Vect2){.x=sat ? 93650940 : 0};state.ned_pos_i.x=27648;
  struct StabilizationSetpoint rb=guidance_pid_h_run_pos(flight,&b);
  assert(ra.sp.ltp_i.vect.x==800+1429*sat*flight && rb.sp.ltp_i.vect.x==800+1429*sat*flight);
  assert(ia.x==(sat ? 93650944 : 800)*flight && guidance_pid_trim_att_integrator.x==(sat ? 93650944 : 800)*flight);
  assert(ra.type==STAB_SP_LTP && rb.type==STAB_SP_LTP && ra.format==STAB_SP_INT && rb.format==STAB_SP_INT);
  assert(ra.sp.ltp_i.vect.y==rb.sp.ltp_i.vect.y && ra.sp.ltp_i.heading==rb.sp.ltp_i.heading);
 }
 return 0;
}
