/* Original function bodies, selected exact callee closure. */
#include "StateShared.h"

struct State state;

void stateSetSpeedNed_i(uint16_t id, struct NedCoor_i *ned_speed)
{
  STATE_CHECK_INPUT_AND_RETURN(state.speed_input_filter, id);

  VECT3_COPY(state.ned_speed_i, *ned_speed);
  /* clear bits for all speed representations and only set the new one */
  state.speed_status = (1 << SPEED_NED_I);
}

