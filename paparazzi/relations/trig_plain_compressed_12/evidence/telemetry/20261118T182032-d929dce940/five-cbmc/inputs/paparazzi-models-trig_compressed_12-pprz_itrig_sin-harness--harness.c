#include "../prepare/source/pprz_itrig_sin.c"
#include "reference_table.h"
extern int32_t nondet_int32_t(void);
int main(void) { int init=pprz_trig_int_init(); __CPROVER_assert(init == 0, "genuine init success"); int32_t a=nondet_int32_t(); __CPROVER_assume(a >= -12867 && a <= 12867); int32_t r=pprz_itrig_sin(a); int32_t folded=a; if(folded>6433) folded=12867-folded; else if(folded < -6433) folded=-12867-folded; int32_t expected=folded>=0 ? reference_table[folded] : -reference_table[-folded]; __CPROVER_assert(r == expected, "initialized compressed sine equals literal ordinary table"); return 0; }
