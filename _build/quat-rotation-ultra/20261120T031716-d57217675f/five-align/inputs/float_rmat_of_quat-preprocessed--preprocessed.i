# 0 "/home/yangfp/five/paparazzi/models/float_rmat_of_quat/prepare/source/float_rmat_of_quat.c"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "/usr/include/stdc-predef.h" 1 3 4
# 0 "<command-line>" 2
# 1 "/home/yangfp/five/paparazzi/models/float_rmat_of_quat/prepare/source/float_rmat_of_quat.c"

# 1 "/home/yangfp/five/paparazzi/models/float_rmat_of_quat/prepare/source/quat_types.h" 1


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
# 3 "/home/yangfp/five/paparazzi/models/float_rmat_of_quat/prepare/source/float_rmat_of_quat.c" 2

void float_rmat_of_quat(struct FloatRMat *rm, const struct FloatQuat *q)
{
  const float _a = 1.41421356237309504880 * q->qi;
  const float _b = 1.41421356237309504880 * q->qx;
  const float _c = 1.41421356237309504880 * q->qy;
  const float _d = 1.41421356237309504880 * q->qz;
  const float a2_1 = _a * _a - 1;
  const float ab = _a * _b;
  const float ac = _a * _c;
  const float ad = _a * _d;
  const float bc = _b * _c;
  const float bd = _b * _d;
  const float cd = _c * _d;
  ((*rm).m[(0)*3+(0)]) = a2_1 + _b * _b;
  ((*rm).m[(0)*3+(1)]) = bc + ad;
  ((*rm).m[(0)*3+(2)]) = bd - ac;
  ((*rm).m[(1)*3+(0)]) = bc - ad;
  ((*rm).m[(1)*3+(1)]) = a2_1 + _c * _c;
  ((*rm).m[(1)*3+(2)]) = cd + ab;
  ((*rm).m[(2)*3+(0)]) = bd + ac;
  ((*rm).m[(2)*3+(1)]) = cd - ab;
  ((*rm).m[(2)*3+(2)]) = a2_1 + _d * _d;
}
