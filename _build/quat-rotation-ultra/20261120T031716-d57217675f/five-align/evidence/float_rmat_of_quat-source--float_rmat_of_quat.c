/* Exact pinned original Paparazzi entry; extraction.json records provenance. */
#include "quat_types.h"

void float_rmat_of_quat(struct FloatRMat *rm, const struct FloatQuat *q)
{
  const float _a = M_SQRT2 * q->qi;
  const float _b = M_SQRT2 * q->qx;
  const float _c = M_SQRT2 * q->qy;
  const float _d = M_SQRT2 * q->qz;
  const float a2_1 = _a * _a - 1;
  const float ab = _a * _b;
  const float ac = _a * _c;
  const float ad = _a * _d;
  const float bc = _b * _c;
  const float bd = _b * _d;
  const float cd = _c * _d;
  RMAT_ELMT(*rm, 0, 0) = a2_1 + _b * _b;
  RMAT_ELMT(*rm, 0, 1) = bc + ad;
  RMAT_ELMT(*rm, 0, 2) = bd - ac;
  RMAT_ELMT(*rm, 1, 0) = bc - ad;
  RMAT_ELMT(*rm, 1, 1) = a2_1 + _c * _c;
  RMAT_ELMT(*rm, 1, 2) = cd + ab;
  RMAT_ELMT(*rm, 2, 0) = bd + ac;
  RMAT_ELMT(*rm, 2, 1) = cd - ab;
  RMAT_ELMT(*rm, 2, 2) = a2_1 + _d * _d;
}
