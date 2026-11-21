#line 1 "<builtin-library-memcpy>"

#ifndef __CPROVER_STRING_H_INCLUDED
#include <string.h>
#define __CPROVER_STRING_H_INCLUDED
#endif

#undef memcpy

void *memcpy(void *dst, const void *src, size_t n)
{
__CPROVER_HIDE:;

#ifdef __CPROVER_STRING_ABSTRACTION
  __CPROVER_precondition(
    __CPROVER_buffer_size(src) >= n, "memcpy buffer overflow");
  __CPROVER_precondition(
    __CPROVER_buffer_size(dst) >= n, "memcpy buffer overflow");
  //  for(size_t i=0; i<n ; i++) dst[i]=src[i];
  if(__CPROVER_is_zero_string(src) && n > __CPROVER_zero_string_length(src))
  {
    __CPROVER_is_zero_string(dst) = 1;
    __CPROVER_zero_string_length(dst) = __CPROVER_zero_string_length(src);
  }
  else if(!(__CPROVER_is_zero_string(dst) &&
            n <= __CPROVER_zero_string_length(dst)))
  {
    __CPROVER_is_zero_string(dst) = 0;
  }

#else
  __CPROVER_precondition(
    __CPROVER_POINTER_OBJECT(dst) != __CPROVER_POINTER_OBJECT(src) ||
      ((const unsigned char *)src >= (const unsigned char *)dst + n) ||
      ((const unsigned char *)dst >= (const unsigned char *)src + n),
    "memcpy src/dst overlap");
  __CPROVER_precondition(
    __CPROVER_r_ok(src, n), "memcpy source region readable");
  __CPROVER_precondition(
    __CPROVER_w_ok(dst, n), "memcpy destination region writeable");

  if(n > 0)
  {
    //for(__CPROVER_size_t i=0; i<n ; i++)
    //  ((unsigned char *)dst)[i]=((const unsigned char *)src)[i];
    unsigned char src_n[n];
    __CPROVER_array_copy(src_n, (unsigned char *)src);
    __CPROVER_array_replace((unsigned char *)dst, src_n);
  }
#endif

  return dst;
}

