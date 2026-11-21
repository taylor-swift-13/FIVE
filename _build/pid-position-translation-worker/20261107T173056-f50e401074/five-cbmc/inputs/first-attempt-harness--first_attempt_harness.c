#include <assert.h>
#include <guidance_pid_h_run_pos.c>
extern int32_t nondet_i32(void);
extern _Bool nondet_bool(void);
extern float nondet_float(void);
static int32_t bounded(int32_t lo, int32_t hi) {
 int32_t x=nondet_i32(); __CPROVER_assume(lo<=x && x<=hi); return x;
}
int main(void) {
 struct HorizontalGuidance a={0},b;
 int32_t dx=bounded(-1000000,1000000),dy=bounded(-1000000,1000000);
 a.ref.pos.x=bounded(-1000000,1000000);a.ref.pos.y=bounded(-1000000,1000000);
 state.ned_pos_i.x=bounded(-1000000,1000000);state.ned_pos_i.y=bounded(-1000000,1000000);
 state.pos_status=1u<<POS_NED_I;state.speed_status=1u<<SPEED_NED_I;
 a.ref.speed.x=bounded(-10000,10000);a.ref.speed.y=bounded(-10000,10000);
 a.ref.accel.x=bounded(-10000,10000);a.ref.accel.y=bounded(-10000,10000);
 state.ned_speed_i.x=bounded(-10000,10000);state.ned_speed_i.y=bounded(-10000,10000);
 guidance_pid.kp=bounded(0,100);guidance_pid.kd=bounded(0,100);guidance_pid.ki=bounded(0,100);
 guidance_pid.kv=bounded(0,100);guidance_pid.ka=bounded(0,100);guidance_pid.approx_force_by_thrust=false;
 guidance_pid_trim_att_integrator.x=bounded(-1000000,1000000);guidance_pid_trim_att_integrator.y=bounded(-1000000,1000000);
 guidance_h.sp.heading=nondet_float();__CPROVER_assume(guidance_h.sp.heading>=-3.0f && guidance_h.sp.heading<=3.0f);
 struct GuidancePID initial_pid=guidance_pid;
 struct Int32Vect2 initial_i=guidance_pid_trim_att_integrator;
 struct State initial_state=state;
 _Bool flight=nondet_bool();
 b=a;b.ref.pos.x=a.ref.pos.x+dx;b.ref.pos.y=a.ref.pos.y+dy;
 struct StabilizationSetpoint ra=guidance_pid_h_run_pos(flight,&a);
 struct GuidancePID final_a=guidance_pid;
 struct Int32Vect2 integral_a=guidance_pid_trim_att_integrator,err_a=guidance_pid_pos_err;
 guidance_pid=initial_pid;guidance_pid_trim_att_integrator=initial_i;state=initial_state;
 state.ned_pos_i.x=initial_state.ned_pos_i.x+dx;state.ned_pos_i.y=initial_state.ned_pos_i.y+dy;
 struct StabilizationSetpoint rb=guidance_pid_h_run_pos(flight,&b);
 assert(guidance_pid_pos_err.x==err_a.x && guidance_pid_pos_err.y==err_a.y);
 assert(guidance_pid.cmd_earth.x==final_a.cmd_earth.x && guidance_pid.cmd_earth.y==final_a.cmd_earth.y);
 assert(guidance_pid_trim_att_integrator.x==integral_a.x && guidance_pid_trim_att_integrator.y==integral_a.y);
 assert(ra.type==rb.type && ra.format==rb.format);
 assert(ra.sp.ltp_i.vect.x==rb.sp.ltp_i.vect.x && ra.sp.ltp_i.vect.y==rb.sp.ltp_i.vect.y && ra.sp.ltp_i.heading==rb.sp.ltp_i.heading);
 assert(a.ref.pos.x+dx==b.ref.pos.x && a.ref.pos.y+dy==b.ref.pos.y);
 __CPROVER_cover(dx!=0 && a.ref.pos.x!=initial_state.ned_pos_i.x && flight && final_a.cmd_earth.x!=0 && integral_a.x!=initial_i.x);
 __CPROVER_cover(dx!=0 && a.ref.pos.x!=initial_state.ned_pos_i.x && !flight && final_a.cmd_earth.x!=0);
}
