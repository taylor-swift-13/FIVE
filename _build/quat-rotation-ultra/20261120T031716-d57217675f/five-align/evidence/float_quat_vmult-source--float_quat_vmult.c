/* Exact pinned original Paparazzi entry; extraction.json records provenance. */
#include "quat_types.h"

void float_quat_vmult(struct FloatVect3 *v_out, const struct FloatQuat *q, const struct FloatVect3 *v_in)
{
  const float qi2_M1_2  = q->qi * q->qi - 0.5;
  const float qiqx = q->qi * q->qx;
  const float qiqy = q->qi * q->qy;
  const float qiqz = q->qi * q->qz;
  float m01  = q->qx * q->qy; /* aka qxqy */
  float m02  = q->qx * q->qz; /* aka qxqz */
  float m12  = q->qy * q->qz; /* aka qyqz */

  const float m00  = qi2_M1_2 + q->qx * q->qx;
  const float m10  = m01 - qiqz;
  const float m20  = m02 + qiqy;
  const float m21  = m12 - qiqx;
  m01 += qiqz;
  m02 -= qiqy;
  m12 += qiqx;
  const float m11  = qi2_M1_2 + q->qy * q->qy;
  const float m22  = qi2_M1_2 + q->qz * q->qz;
  v_out->x = 2 * (m00 * v_in->x + m01 * v_in->y + m02 * v_in->z);
  v_out->y = 2 * (m10 * v_in->x + m11 * v_in->y + m12 * v_in->z);
  v_out->z = 2 * (m20 * v_in->x + m21 * v_in->y + m22 * v_in->z);
}
