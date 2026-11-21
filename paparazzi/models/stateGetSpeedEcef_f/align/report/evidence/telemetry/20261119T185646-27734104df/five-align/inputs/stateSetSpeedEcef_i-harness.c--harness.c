#include "../prepare/source/stateSetSpeedEcef_i.c"
#include <stdint.h>
#include <stddef.h>
#include <string.h>
extern int32_t nondet_int32_t(void);
int main(void) {
  struct EcefCoor_i input = {nondet_int32_t(),nondet_int32_t(),nondet_int32_t()};
  unsigned char before[sizeof(state)];
  memset(&state,0,sizeof(state));
  state.speed_input_filter=STATE_INPUT_ANY;
  uint16_t accepted_id=state.speed_input_filter;
  memcpy(before,&state,sizeof(state));
  stateSetSpeedEcef_i(accepted_id,&input);
  __CPROVER_assert(state.ecef_speed_i.x==input.x && state.ecef_speed_i.y==input.y && state.ecef_speed_i.z==input.z,"accepted setter copies all three integer words");
  __CPROVER_assert(state.speed_status==(1u<<SPEED_ECEF_I),"setter clears stale status and sets only selected integer representation");
  for(size_t i=0;i<sizeof(state);++i) {
    if(!((280u<=i && i<282u)||(284u<=i && i<296u)))
      __CPROVER_assert(((unsigned char*)&state)[i]==before[i],"setter preserves every State byte outside actual vector/status write ranges");
  }
  return 0;
}
