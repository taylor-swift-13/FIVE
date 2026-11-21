#include <stdio.h>
#define pprz_itrig_sin plain_sin
#include "/home/yangfp/five/paparazzi/models/trig_plain/pprz_itrig_sin/prepare/source/pprz_itrig_sin.c"
#undef pprz_itrig_sin
#include "/home/yangfp/five/paparazzi/models/trig_compressed_12/pprz_itrig_sin/prepare/source/pprz_itrig_sin.c"
int main(void){ if(pprz_trig_int_init()!=0)return 2; for(int i=0;i<6434;i++)if(pprz_trig_int_12(i)!=pprz_trig_int[i]) {printf("lookup mismatch %d %d %d\n",i,pprz_trig_int_12(i),pprz_trig_int[i]);return 3;}for(int a=-25734;a<=25734;a++)if(pprz_itrig_sin(a)!=plain_sin(a)){printf("sin mismatch %d\n",a);return 4;}puts("native diagnostic: genuine init=0; 6434 lookup values and 51469 sine inputs match");return 0;}
