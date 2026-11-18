extern double __builtin_sqrt(double) __asm__("sqrt");
float probe(float x) { return (float)__builtin_sqrt((double)x); }
