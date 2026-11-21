/* Original function bodies, selected exact callee closure. */
#include "StateShared.h"

struct State state;

void ecef_of_enu_vect_f(struct EcefCoor_f *ecef, struct LtpDef_f *def, struct EnuCoor_f *enu)
{
  /* convert used floats to double */
  struct DoubleRMat ltp_of_ecef_d;
  ltp_of_ecef_d.m[0] = (double) def->ltp_of_ecef.m[0];
  ltp_of_ecef_d.m[1] = (double) def->ltp_of_ecef.m[1];
  ltp_of_ecef_d.m[2] = (double) def->ltp_of_ecef.m[2];
  ltp_of_ecef_d.m[3] = (double) def->ltp_of_ecef.m[3];
  ltp_of_ecef_d.m[4] = (double) def->ltp_of_ecef.m[4];
  ltp_of_ecef_d.m[5] = (double) def->ltp_of_ecef.m[5];
  ltp_of_ecef_d.m[6] = (double) def->ltp_of_ecef.m[6];
  ltp_of_ecef_d.m[7] = (double) def->ltp_of_ecef.m[7];
  ltp_of_ecef_d.m[8] = (double) def->ltp_of_ecef.m[8];
  struct EnuCoor_f enu_d;
  enu_d.x = (double) enu->x;
  enu_d.y = (double) enu->y;
  enu_d.z = (double) enu->z;

  /* compute in double */
  struct EcefCoor_d ecef_d;
  MAT33_VECT3_TRANSP_MUL(ecef_d, ltp_of_ecef_d, enu_d);

  /* convert result back to float*/
  ecef->x = (float) ecef_d.x;
  ecef->y = (float) ecef_d.y;
  ecef->z = (float) ecef_d.z;
}

void ecef_of_ned_vect_f(struct EcefCoor_f *ecef, struct LtpDef_f *def, struct NedCoor_f *ned)
{
  struct EnuCoor_f enu;
  ENU_OF_TO_NED(enu, *ned);
  ecef_of_enu_vect_f(ecef, def, &enu);
}

void stateCalcSpeedEcef_f(void)
{
  if (bit_is_set(state.speed_status, SPEED_ECEF_F)) {
    return;
  }

  if (bit_is_set(state.speed_status, SPEED_ECEF_I)) {
    SPEEDS_FLOAT_OF_BFP(state.ecef_speed_f, state.ned_speed_i);
  } else if (bit_is_set(state.speed_status, SPEED_NED_F)) {
    ecef_of_ned_vect_f(&state.ecef_speed_f, &state.ned_origin_f, &state.ned_speed_f);
  } else if (bit_is_set(state.speed_status, SPEED_NED_I)) {
    /* transform ned_f -> ned_i -> ecef_i , set status bits */
    SPEEDS_FLOAT_OF_BFP(state.ned_speed_f, state.ned_speed_i);
    SetBit(state.speed_status, SPEED_NED_F);
    ecef_of_ned_vect_f(&state.ecef_speed_f, &state.ned_origin_f, &state.ned_speed_f);
  } else {
    /* could not get this representation,  set errno */
    //struct EcefCoor_f _ecef_zero = {0.0f};
    //return _ecef_zero;
    return;
  }
  /* set bit to indicate this representation is computed */
  SetBit(state.speed_status, SPEED_ECEF_F);
}

struct EcefCoor_f *stateGetSpeedEcef_f(void)
{
  if (!bit_is_set(state.speed_status, SPEED_ECEF_F)) {
    stateCalcSpeedEcef_f();
  }
  return &state.ecef_speed_f;
}

