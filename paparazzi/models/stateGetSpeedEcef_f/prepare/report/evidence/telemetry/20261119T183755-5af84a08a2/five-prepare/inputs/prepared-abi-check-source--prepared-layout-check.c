#include "../../paparazzi/models/stateGetSpeedEcef_f/prepare/source/StateShared.h"
#include <stddef.h>
_Static_assert(sizeof(struct State)==656, "sizeof(struct State)==656");
_Static_assert(_Alignof(struct State)==4, "_Alignof(struct State)==4");
_Static_assert(offsetof(struct State,speed_status)==280, "offsetof(struct State,speed_status)==280");
_Static_assert(offsetof(struct State,speed_input_filter)==282, "offsetof(struct State,speed_input_filter)==282");
_Static_assert(offsetof(struct State,ecef_speed_i)==284, "offsetof(struct State,ecef_speed_i)==284");
_Static_assert(offsetof(struct State,ned_speed_i)==296, "offsetof(struct State,ned_speed_i)==296");
_Static_assert(offsetof(struct State,ecef_speed_f)==328, "offsetof(struct State,ecef_speed_f)==328");
_Static_assert(offsetof(struct State,ned_speed_f)==340, "offsetof(struct State,ned_speed_f)==340");
_Static_assert(offsetof(struct State,ned_origin_f)==168, "offsetof(struct State,ned_origin_f)==168");
_Static_assert(sizeof(struct EcefCoor_f)==12, "sizeof(struct EcefCoor_f)==12");
_Static_assert(sizeof(struct NedCoor_i)==12, "sizeof(struct NedCoor_i)==12");
