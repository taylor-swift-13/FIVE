#include <stdio.h>
extern unsigned int bits_one(void);
int main(void) { printf("%08x\n", bits_one()); return 0; }
