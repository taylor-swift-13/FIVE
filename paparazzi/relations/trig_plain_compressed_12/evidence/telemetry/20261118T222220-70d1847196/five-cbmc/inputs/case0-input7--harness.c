#include "../prepare/source/pprz_itrig_sin.c"
extern int32_t nondet_int32_t(void);
int main(void) { int32_t a=nondet_int32_t(); __CPROVER_assume(a >= -12867 && a <= 12867); int32_t r=pprz_itrig_sin(a); __CPROVER_assert(r >= -16383 && r <= 16383, "sine literal table range"); return 0; }
