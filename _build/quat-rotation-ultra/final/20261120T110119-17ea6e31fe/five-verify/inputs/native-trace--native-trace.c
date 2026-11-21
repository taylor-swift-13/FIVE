#include "paparazzi/models/float_quat_vmult/prepare/source/float_quat_vmult.c"
#include "paparazzi/models/float_rmat_of_quat/prepare/source/float_rmat_of_quat.c"
#include "paparazzi/models/float_rmat_vmult/prepare/source/float_rmat_vmult.c"
#include <stdint.h>
#include <stdio.h>
#include <string.h>
int main(void){uint32_t qbits[4]={0xbf37aaca,0xbe3dbde6,0xa03504f3,0x10073b11},vbits[3]={0x43004017,0x44800000,0x8e000000};struct FloatQuat q;struct FloatVect3 v,a,b;struct FloatRMat m;memcpy(&q,qbits,16);memcpy(&v,vbits,12);float_quat_vmult(&a,&q,&v);float_rmat_of_quat(&m,&q);float_rmat_vmult(&b,&m,&v);uint32_t aa[3],bb[3];memcpy(aa,&a,12);memcpy(bb,&b,12);printf("A=%08x,%08x,%08x\nB=%08x,%08x,%08x\n",aa[0],aa[1],aa[2],bb[0],bb[1],bb[2]);return 0;}
