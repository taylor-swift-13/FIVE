# 0 "/home/yangfp/five/paparazzi/models/float_quat_vmult/prepare/source/float_quat_vmult.c"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "/usr/include/stdc-predef.h" 1 3 4
# 0 "<command-line>" 2
# 1 "/home/yangfp/five/paparazzi/models/float_quat_vmult/prepare/source/float_quat_vmult.c"

# 1 "/home/yangfp/five/paparazzi/models/float_quat_vmult/prepare/source/quat_types.h" 1


struct FloatVect3 {
  float x;
  float y;
  float z;
};

struct FloatQuat {
  float qi;
  float qx;
  float qy;
  float qz;
};

struct FloatRMat {
  float m[3 * 3];
};
# 3 "/home/yangfp/five/paparazzi/models/float_quat_vmult/prepare/source/float_quat_vmult.c" 2

void float_quat_vmult(struct FloatVect3 *v_out, const struct FloatQuat *q, const struct FloatVect3 *v_in)
{
  const float qi2_M1_2 = q->qi * q->qi - 0.5;
  const float qiqx = q->qi * q->qx;
  const float qiqy = q->qi * q->qy;
  const float qiqz = q->qi * q->qz;
  float m01 = q->qx * q->qy;
  float m02 = q->qx * q->qz;
  float m12 = q->qy * q->qz;

  const float m00 = qi2_M1_2 + q->qx * q->qx;
  const float m10 = m01 - qiqz;
  const float m20 = m02 + qiqy;
  const float m21 = m12 - qiqx;
  m01 += qiqz;
  m02 -= qiqy;
  m12 += qiqx;
  const float m11 = qi2_M1_2 + q->qy * q->qy;
  const float m22 = qi2_M1_2 + q->qz * q->qz;
  v_out->x = 2 * (m00 * v_in->x + m01 * v_in->y + m02 * v_in->z);
  v_out->y = 2 * (m10 * v_in->x + m11 * v_in->y + m12 * v_in->z);
  v_out->z = 2 * (m20 * v_in->x + m21 * v_in->y + m22 * v_in->z);
}
