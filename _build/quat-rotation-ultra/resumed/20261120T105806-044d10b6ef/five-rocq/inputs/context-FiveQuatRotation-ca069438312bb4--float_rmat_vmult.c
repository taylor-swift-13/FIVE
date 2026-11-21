/* Exact pinned original Paparazzi entry; extraction.json records provenance. */
#include "quat_types.h"

void float_rmat_vmult(struct FloatVect3 *vb, const struct FloatRMat *m_a2b, const struct FloatVect3 *va)
{
  vb->x = m_a2b->m[0] * va->x + m_a2b->m[1] * va->y + m_a2b->m[2] * va->z;
  vb->y = m_a2b->m[3] * va->x + m_a2b->m[4] * va->y + m_a2b->m[5] * va->z;
  vb->z = m_a2b->m[6] * va->x + m_a2b->m[7] * va->y + m_a2b->m[8] * va->z;
}
