#ifndef FIVE_PAPARAZZI_QUAT_TYPES
#define FIVE_PAPARAZZI_QUAT_TYPES
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

#define M_SQRT2         1.41421356237309504880

#define MAT33_ELMT(_m, _row, _col) ((_m).m[(_row)*3+(_col)])

#define RMAT_ELMT(_rm, _row, _col) MAT33_ELMT(_rm, _row, _col)
#endif
