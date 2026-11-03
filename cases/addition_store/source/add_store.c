#include <string.h>
extern float five_add(float a, float b);
/* dst denotes four writable bytes; memcpy permits byte-aligned storage. */
void five_add_store(float a, float b, unsigned char *dst)
{
    float result = five_add(a, b);
    memcpy(dst, &result, sizeof result);
}
