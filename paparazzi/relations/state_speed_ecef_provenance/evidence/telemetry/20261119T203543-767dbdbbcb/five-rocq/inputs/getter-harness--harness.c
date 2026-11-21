#include "../../stateSetSpeedNed_i/prepare/source/stateSetSpeedNed_i.c"
#include "../../stateSetSpeedEcef_i/prepare/source/stateSetSpeedEcef_i.c"
#include "../prepare/source/stateGetSpeedEcef_f.c"
#include <stdint.h>
#include <stddef.h>
#include <string.h>
struct Observation {
  uint16_t ned_status, ecef_status, returned_status;
  int32_t copied_ecef[3], stale_ned[3];
  _Bool pointer_is_state;
  uint32_t bits[3];
  unsigned char before_get[sizeof(struct State)], after_get[sizeof(struct State)];
};
static void protocol(struct NedCoor_i *old_ned,struct EcefCoor_i *new_ecef,struct Observation *out) {
  memset(&state,0,sizeof(state));
  state.speed_input_filter=STATE_INPUT_ANY;
  uint16_t accepted_id=state.speed_input_filter;
  stateSetSpeedNed_i(accepted_id,old_ned);
  out->ned_status=state.speed_status;
  stateSetSpeedEcef_i(accepted_id,new_ecef);
  out->ecef_status=state.speed_status;
  out->copied_ecef[0]=state.ecef_speed_i.x;
  out->copied_ecef[1]=state.ecef_speed_i.y;
  out->copied_ecef[2]=state.ecef_speed_i.z;
  out->stale_ned[0]=state.ned_speed_i.x;
  out->stale_ned[1]=state.ned_speed_i.y;
  out->stale_ned[2]=state.ned_speed_i.z;
  memcpy(out->before_get,&state,sizeof(state));
  struct EcefCoor_f *returned=stateGetSpeedEcef_f();
  out->pointer_is_state=(returned==&state.ecef_speed_f);
  memcpy(out->bits,returned,sizeof(out->bits)); /* immediate complete pointee copy */
  out->returned_status=state.speed_status;
  memcpy(out->after_get,&state,sizeof(state));
}
int main(void) {
  struct NedCoor_i N1={0,0,0},N2={1<<INT32_SPEED_FRAC,0,0};
  struct EcefCoor_i E={2*(1<<INT32_SPEED_FRAC),0,0};
  struct Observation a,b;
  protocol(&N1,&E,&a);
  protocol(&N2,&E,&b);
  __CPROVER_assert(a.ned_status==(1u<<SPEED_NED_I) && b.ned_status==(1u<<SPEED_NED_I),"both NED setters accepted and selected NED_I");
  __CPROVER_assert(a.ecef_status==(1u<<SPEED_ECEF_I) && b.ecef_status==(1u<<SPEED_ECEF_I),"both ECEF setters accepted and selected only ECEF_I");
  __CPROVER_assert(a.copied_ecef[0]==E.x && a.copied_ecef[1]==E.y && a.copied_ecef[2]==E.z && b.copied_ecef[0]==E.x && b.copied_ecef[1]==E.y && b.copied_ecef[2]==E.z,"both actual ECEF integer fields contain the new complete input");
  __CPROVER_assert(a.stale_ned[0]==N1.x && a.stale_ned[1]==N1.y && a.stale_ned[2]==N1.z && b.stale_ned[0]==N2.x && b.stale_ned[1]==N2.y && b.stale_ned[2]==N2.z,"ECEF setter preserves actual numeric NED history");
  __CPROVER_assert(a.pointer_is_state && b.pointer_is_state,"getter returns the actual ECEF float field pointer");
  __CPROVER_assert(a.returned_status==((1u<<SPEED_ECEF_I)|(1u<<SPEED_ECEF_F)) && b.returned_status==((1u<<SPEED_ECEF_I)|(1u<<SPEED_ECEF_F)),"getter sets ECEF_F without restoring the NED validity bit");
  for(size_t i=0;i<sizeof(state);++i) {
    if(!((280u<=i && i<282u)||(328u<=i && i<340u)))
      __CPROVER_assert(a.before_get[i]==a.after_get[i] && b.before_get[i]==b.after_get[i],"getter preserves every State byte outside actual ECEF float/status writes");
  }
  __CPROVER_assert(a.bits[0]==0x40000000u && a.bits[1]==0u && a.bits[2]==0u,"first actual read after ECEF write decodes new ECEF input");
  __CPROVER_assert(b.bits[0]==0x40000000u && b.bits[1]==0u && b.bits[2]==0u,"second actual read after ECEF write decodes new ECEF input");
  __CPROVER_assert(a.bits[0]==b.bits[0] && a.bits[1]==b.bits[1] && a.bits[2]==b.bits[2],"ECEF getter output is independent of overwritten NED history");
  return 0;
}
