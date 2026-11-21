#include <assert.h>
#include <fenv.h>
#include <inttypes.h>
#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include "state.h"

static uint32_t bits(float x) { uint32_t u; memcpy(&u, &x, sizeof u); return u; }

static void protocol(int32_t old_ned, uint32_t out[3])
{
  memset(&state, 0, sizeof state);
  stateInit();
  assert(state.speed_input_filter == STATE_INPUT_ANY);
  struct NedCoor_i n = { old_ned, 0, 0 };
  struct EcefCoor_i e = { 2 * (1 << INT32_SPEED_FRAC), 0, 0 };
  stateSetSpeedNed_i(17, &n);
  assert(state.speed_status == (1U << SPEED_NED_I));
  assert(state.ned_speed_i.x == old_ned);
  stateSetSpeedEcef_i(17, &e);
  assert(state.speed_status == (1U << SPEED_ECEF_I));
  assert(state.ecef_speed_i.x == e.x);
  assert(state.ned_speed_i.x == old_ned);
  struct EcefCoor_f snapshot = *stateGetSpeedEcef_f();
  assert(state.speed_status == ((1U << SPEED_ECEF_I) | (1U << SPEED_ECEF_F)));
  out[0] = bits(snapshot.x); out[1] = bits(snapshot.y); out[2] = bits(snapshot.z);
}

int main(void)
{
  assert(fesetround(FE_TONEAREST) == 0);
  uint32_t a[3], b[3];
  protocol(0, a);
  protocol(1 << INT32_SPEED_FRAC, b);
  printf("{\"setters_accepted\":true,\"new_ecef_stored\":true,"
    "\"speed_frac\":%d,\"expected_x_bits\":\"0x40000000\","
    "\"old0_output_bits\":[\"0x%08" PRIx32 "\",\"0x%08" PRIx32 "\",\"0x%08" PRIx32 "\"],"
    "\"old1_output_bits\":[\"0x%08" PRIx32 "\",\"0x%08" PRIx32 "\",\"0x%08" PRIx32 "\"],"
    "\"layout\":{\"state_size\":%zu,\"state_align\":%zu,\"status\":%zu,"
    "\"filter\":%zu,\"ecef_i\":%zu,\"ned_i\":%zu,\"ecef_f\":%zu,\"ned_f\":%zu,\"origin_f\":%zu}}\n",
    INT32_SPEED_FRAC,a[0],a[1],a[2],b[0],b[1],b[2],
    sizeof(struct State),_Alignof(struct State),offsetof(struct State,speed_status),
    offsetof(struct State,speed_input_filter),offsetof(struct State,ecef_speed_i),
    offsetof(struct State,ned_speed_i),offsetof(struct State,ecef_speed_f),
    offsetof(struct State,ned_speed_f),offsetof(struct State,ned_origin_f));
  return !(a[0] == 0 && b[0] == UINT32_C(0x3f800000) &&
    a[1] == 0 && a[2] == 0 && b[1] == 0 && b[2] == 0);
}

