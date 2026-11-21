#include "../prepare/source/stateSetSpeedNed_i.c"
#include <stdint.h>
#include <stddef.h>
#include <string.h>
extern int32_t nondet_int32_t(void);
int main(void) {
  struct NedCoor_i input = {nondet_int32_t(),nondet_int32_t(),nondet_int32_t()};
  unsigned char before[sizeof(state)];
  memset(&state,0,sizeof(state));
  state.speed_input_filter=STATE_INPUT_ANY;
  uint16_t accepted_id=state.speed_input_filter;
  memcpy(before,&state,sizeof(state));
  stateSetSpeedNed_i(accepted_id,&input);
  __CPROVER_assert(state.ned_speed_i.x==input.x && state.ned_speed_i.y==input.y && state.ned_speed_i.z==input.z,"accepted setter copies all three integer words");
  __CPROVER_assert(state.speed_status==(1u<<SPEED_NED_I),"setter clears stale status and sets only selected integer representation");
  for(size_t i=0;i<sizeof(state);++i) {
    if(!((280u<=i && i<282u)||(296u<=i && i<308u)))
      __CPROVER_assert(((unsigned char*)&state)[i]==before[i],"setter preserves every State byte outside actual vector/status write ranges");
  }
  return 0;
}
