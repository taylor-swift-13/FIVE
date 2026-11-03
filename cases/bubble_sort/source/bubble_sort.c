#include <stddef.h>
#include <string.h>

/* a is readable and writable for n floats, unless n==0. Inputs are non-NaN binary32.
   Strict comparisons retain the input order of equal keys, including +/-0. */
void five_bubble_sort(float *a, size_t n)
{
    for (size_t end=n; end>1; --end) {
        for (size_t j=0; j+1<end; ++j) {
            if (a[j] > a[j+1]) {
                unsigned char tmp[sizeof(float)];
                memcpy(tmp, a+j, sizeof(float));
                memcpy(a+j, a+j+1, sizeof(float));
                memcpy(a+j+1, tmp, sizeof(float));
            }
        }
    }
}
