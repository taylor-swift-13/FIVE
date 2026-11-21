# 0 "/home/yangfp/five/paparazzi/models/float_rmat_vmult/prepare/source/float_rmat_vmult.c"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "/usr/include/stdc-predef.h" 1 3 4
# 0 "<command-line>" 2
# 1 "/home/yangfp/five/paparazzi/models/float_rmat_vmult/prepare/source/float_rmat_vmult.c"

# 1 "/home/yangfp/five/paparazzi/models/float_rmat_vmult/prepare/source/quat_types.h" 1


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
# 3 "/home/yangfp/five/paparazzi/models/float_rmat_vmult/prepare/source/float_rmat_vmult.c" 2

void float_rmat_vmult(struct FloatVect3 *vb, const struct FloatRMat *m_a2b, const struct FloatVect3 *va)
{
  vb->x = m_a2b->m[0] * va->x + m_a2b->m[1] * va->y + m_a2b->m[2] * va->z;
  vb->y = m_a2b->m[3] * va->x + m_a2b->m[4] * va->y + m_a2b->m[5] * va->z;
  vb->z = m_a2b->m[6] * va->x + m_a2b->m[7] * va->y + m_a2b->m[8] * va->z;
}
