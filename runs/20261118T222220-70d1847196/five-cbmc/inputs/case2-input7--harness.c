#include "../prepare/source/pprz_trig_int_init.c"
#include "reference_table.h"
extern int32_t nondet_int32_t(void);
int main(void) { int init=pprz_trig_int_init(); __CPROVER_assert(init == 0, "genuine init success"); int32_t i=nondet_int32_t(); __CPROVER_assume(i>=0 && i<6434); __CPROVER_assert(pprz_trig_int_12(i)==reference_table[i], "all initialized decoded lookups equal literal ordinary table"); return 0; }
