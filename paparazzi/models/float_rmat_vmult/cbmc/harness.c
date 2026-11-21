#include "paparazzi/models/float_quat_vmult/prepare/source/float_quat_vmult.c"
#include "paparazzi/models/float_rmat_of_quat/prepare/source/float_rmat_of_quat.c"
#include "paparazzi/models/float_rmat_vmult/prepare/source/float_rmat_vmult.c"
#include <stdint.h>
#include <string.h>
extern float nondet_float(void);
int main(void) {
 struct FloatQuat q={nondet_float(),nondet_float(),nondet_float(),nondet_float()};
 struct FloatVect3 v={nondet_float(),nondet_float(),nondet_float()}, a,b;
 struct FloatRMat r;
 __CPROVER_assume(q.qi>=-1.0f && q.qi<=1.0f && q.qx>=-1.0f && q.qx<=1.0f && q.qy>=-1.0f && q.qy<=1.0f && q.qz>=-1.0f && q.qz<=1.0f);
 __CPROVER_assume(v.x>=-1024.0f && v.x<=1024.0f && v.y>=-1024.0f && v.y<=1024.0f && v.z>=-1024.0f && v.z<=1024.0f);
 float_quat_vmult(&a,&q,&v);
 float_rmat_of_quat(&r,&q);
 float_rmat_vmult(&b,&r,&v);
 uint32_t ab[3],bb[3];memcpy(ab,&a,12);memcpy(bb,&b,12);
 __CPROVER_assert(ab[0]==bb[0] && ab[1]==bb[1] && ab[2]==bb[2],"candidate1 all output binary32 bits equal");
 return 0;
}
