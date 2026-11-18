#include "five_sqrtf.c"
void main(void) { __CPROVER_assert(five_sqrtf(4.0f)==2.0f,"sqrt4"); __CPROVER_assert(five_sqrtf(40000.0f)==200.0f,"sqrt40000"); }
