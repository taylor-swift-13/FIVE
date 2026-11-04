#include <stdint.h>
#include <string.h>

extern float sum3(float a, float b, float c);

int main(void) {
    const float result = sum3(16777216.0f, 1.0f, -16777216.0f);
    uint32_t result_bits;
    memcpy(&result_bits, &result, sizeof result_bits);
    __CPROVER_assert(result_bits == UINT32_C(0x00000000), "sum3.left_example.bits");
    return 0;
}
