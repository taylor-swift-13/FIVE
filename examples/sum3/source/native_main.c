#include <inttypes.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
extern float sum3(float a, float b, float c);
int main(void) {
    float result = sum3(16777216.0f, 1.0f, -16777216.0f);
    uint32_t bits;
    memcpy(&bits, &result, sizeof bits);
    printf("sum3 result: %g; binary32: 0x%08" PRIx32 "\n", (double)result, bits);
    return bits == UINT32_C(0x00000000) ? 0 : 1;
}
