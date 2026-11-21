#include "paparazzi/models/float_quat_vmult/prepare/source/float_quat_vmult.c"
#include "paparazzi/models/float_rmat_of_quat/prepare/source/float_rmat_of_quat.c"
#include "paparazzi/models/float_rmat_vmult/prepare/source/float_rmat_vmult.c"
#include <stdint.h>
#include <string.h>
#include <stdio.h>
int main(void){struct FloatQuat q={1,0,0,0};struct FloatVect3 v={1,0,0},a,b;struct FloatRMat r;float_quat_vmult(&a,&q,&v);float_rmat_of_quat(&r,&q);float_rmat_vmult(&b,&r,&v);uint32_t ab[3],bb[3],rb[9];memcpy(ab,&a,12);memcpy(bb,&b,12);memcpy(rb,&r,36);printf("q=(1,0,0,0) v=(1,0,0)\nA=%08x,%08x,%08x\nB=%08x,%08x,%08x\nR=",ab[0],ab[1],ab[2],bb[0],bb[1],bb[2]);for(int i=0;i<9;i++)printf("%08x%s",rb[i],i==8?"\n":",");}
