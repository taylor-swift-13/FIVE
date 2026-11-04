# 0 "/home/yangfp/five/_build/paparazzi/expansion-models/float_algebra_more/Program.c"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "/usr/include/stdc-predef.h" 1 3 4
# 0 "<command-line>" 2
# 1 "/home/yangfp/five/_build/paparazzi/expansion-models/float_algebra_more/Program.c"
# 27 "/home/yangfp/five/_build/paparazzi/expansion-models/float_algebra_more/Program.c"
# 1 "/home/yangfp/five/_build/paparazzi/overlay/math/pprz_algebra_float.h" 1
# 38 "/home/yangfp/five/_build/paparazzi/overlay/math/pprz_algebra_float.h"
# 1 "/home/yangfp/five/_build/paparazzi/overlay/math/pprz_algebra.h" 1
# 43 "/home/yangfp/five/_build/paparazzi/overlay/math/pprz_algebra.h"
# 1 "/home/yangfp/.opam/five/bin/../share/../lib/compcert/include/float.h" 1
# 44 "/home/yangfp/five/_build/paparazzi/overlay/math/pprz_algebra.h" 2
# 1 "/usr/include/string.h" 1 3 4
# 26 "/usr/include/string.h" 3 4
# 1 "/usr/include/x86_64-linux-gnu/bits/libc-header-start.h" 1 3 4
# 33 "/usr/include/x86_64-linux-gnu/bits/libc-header-start.h" 3 4
# 1 "/usr/include/features.h" 1 3 4
# 392 "/usr/include/features.h" 3 4
# 1 "/usr/include/features-time64.h" 1 3 4
# 20 "/usr/include/features-time64.h" 3 4
# 1 "/usr/include/x86_64-linux-gnu/bits/wordsize.h" 1 3 4
# 21 "/usr/include/features-time64.h" 2 3 4
# 1 "/usr/include/x86_64-linux-gnu/bits/timesize.h" 1 3 4
# 19 "/usr/include/x86_64-linux-gnu/bits/timesize.h" 3 4
# 1 "/usr/include/x86_64-linux-gnu/bits/wordsize.h" 1 3 4
# 20 "/usr/include/x86_64-linux-gnu/bits/timesize.h" 2 3 4
# 22 "/usr/include/features-time64.h" 2 3 4
# 393 "/usr/include/features.h" 2 3 4
# 486 "/usr/include/features.h" 3 4
# 1 "/usr/include/x86_64-linux-gnu/sys/cdefs.h" 1 3 4
# 559 "/usr/include/x86_64-linux-gnu/sys/cdefs.h" 3 4
# 1 "/usr/include/x86_64-linux-gnu/bits/wordsize.h" 1 3 4
# 560 "/usr/include/x86_64-linux-gnu/sys/cdefs.h" 2 3 4
# 1 "/usr/include/x86_64-linux-gnu/bits/long-double.h" 1 3 4
# 561 "/usr/include/x86_64-linux-gnu/sys/cdefs.h" 2 3 4
# 487 "/usr/include/features.h" 2 3 4
# 510 "/usr/include/features.h" 3 4
# 1 "/usr/include/x86_64-linux-gnu/gnu/stubs.h" 1 3 4
# 10 "/usr/include/x86_64-linux-gnu/gnu/stubs.h" 3 4
# 1 "/usr/include/x86_64-linux-gnu/gnu/stubs-64.h" 1 3 4
# 11 "/usr/include/x86_64-linux-gnu/gnu/stubs.h" 2 3 4
# 511 "/usr/include/features.h" 2 3 4
# 34 "/usr/include/x86_64-linux-gnu/bits/libc-header-start.h" 2 3 4
# 27 "/usr/include/string.h" 2 3 4






# 1 "/home/yangfp/.opam/five/bin/../share/../lib/compcert/include/stddef.h" 1 3 4
# 67 "/home/yangfp/.opam/five/bin/../share/../lib/compcert/include/stddef.h" 3 4

# 67 "/home/yangfp/.opam/five/bin/../share/../lib/compcert/include/stddef.h" 3 4
typedef unsigned long size_t;
# 34 "/usr/include/string.h" 2 3 4
# 43 "/usr/include/string.h" 3 4
extern void *memcpy (void *restrict __dest, const void *restrict __src,
       size_t __n) ;


extern void *memmove (void *__dest, const void *__src, size_t __n)
     ;
# 61 "/usr/include/string.h" 3 4
extern void *memset (void *__s, int __c, size_t __n) ;


extern int memcmp (const void *__s1, const void *__s2, size_t __n)
     ;
# 80 "/usr/include/string.h" 3 4
extern int __memcmpeq (const void *__s1, const void *__s2, size_t __n)
     ;
# 107 "/usr/include/string.h" 3 4
extern void *memchr (const void *__s, int __c, size_t __n)
      ;
# 141 "/usr/include/string.h" 3 4
extern char *strcpy (char *restrict __dest, const char *restrict __src)
     ;

extern char *strncpy (char *restrict __dest,
        const char *restrict __src, size_t __n)
     ;


extern char *strcat (char *restrict __dest, const char *restrict __src)
     ;

extern char *strncat (char *restrict __dest, const char *restrict __src,
        size_t __n) ;


extern int strcmp (const char *__s1, const char *__s2)
     ;

extern int strncmp (const char *__s1, const char *__s2, size_t __n)
     ;


extern int strcoll (const char *__s1, const char *__s2)
     ;

extern size_t strxfrm (char *restrict __dest,
         const char *restrict __src, size_t __n)
    ;
# 246 "/usr/include/string.h" 3 4
extern char *strchr (const char *__s, int __c)
     ;
# 273 "/usr/include/string.h" 3 4
extern char *strrchr (const char *__s, int __c)
     ;
# 293 "/usr/include/string.h" 3 4
extern size_t strcspn (const char *__s, const char *__reject)
     ;


extern size_t strspn (const char *__s, const char *__accept)
     ;
# 323 "/usr/include/string.h" 3 4
extern char *strpbrk (const char *__s, const char *__accept)
     ;
# 350 "/usr/include/string.h" 3 4
extern char *strstr (const char *__haystack, const char *__needle)
     ;




extern char *strtok (char *restrict __s, const char *restrict __delim)
     ;



extern char *__strtok_r (char *restrict __s,
    const char *restrict __delim,
    char **restrict __save_ptr)
     ;
# 407 "/usr/include/string.h" 3 4
extern size_t strlen (const char *__s)
     ;
# 419 "/usr/include/string.h" 3 4
extern char *strerror (int __errnum) ;
# 539 "/usr/include/string.h" 3 4

# 45 "/home/yangfp/five/_build/paparazzi/overlay/math/pprz_algebra.h" 2
# 1 "/home/yangfp/five/_build/paparazzi/upstream/sw/include/std.h" 1
# 29 "/home/yangfp/five/_build/paparazzi/upstream/sw/include/std.h"
# 1 "/usr/include/inttypes.h" 1 3 4
# 27 "/usr/include/inttypes.h" 3 4
# 1 "/usr/lib/gcc/x86_64-linux-gnu/11/include/stdint.h" 1 3 4
# 9 "/usr/lib/gcc/x86_64-linux-gnu/11/include/stdint.h" 3 4
# 1 "/usr/include/stdint.h" 1 3 4
# 26 "/usr/include/stdint.h" 3 4
# 1 "/usr/include/x86_64-linux-gnu/bits/libc-header-start.h" 1 3 4
# 27 "/usr/include/stdint.h" 2 3 4
# 1 "/usr/include/x86_64-linux-gnu/bits/types.h" 1 3 4
# 27 "/usr/include/x86_64-linux-gnu/bits/types.h" 3 4
# 1 "/usr/include/x86_64-linux-gnu/bits/wordsize.h" 1 3 4
# 28 "/usr/include/x86_64-linux-gnu/bits/types.h" 2 3 4
# 1 "/usr/include/x86_64-linux-gnu/bits/timesize.h" 1 3 4
# 19 "/usr/include/x86_64-linux-gnu/bits/timesize.h" 3 4
# 1 "/usr/include/x86_64-linux-gnu/bits/wordsize.h" 1 3 4
# 20 "/usr/include/x86_64-linux-gnu/bits/timesize.h" 2 3 4
# 29 "/usr/include/x86_64-linux-gnu/bits/types.h" 2 3 4


typedef unsigned char __u_char;
typedef unsigned short int __u_short;
typedef unsigned int __u_int;
typedef unsigned long int __u_long;


typedef signed char __int8_t;
typedef unsigned char __uint8_t;
typedef signed short int __int16_t;
typedef unsigned short int __uint16_t;
typedef signed int __int32_t;
typedef unsigned int __uint32_t;

typedef signed long int __int64_t;
typedef unsigned long int __uint64_t;






typedef __int8_t __int_least8_t;
typedef __uint8_t __uint_least8_t;
typedef __int16_t __int_least16_t;
typedef __uint16_t __uint_least16_t;
typedef __int32_t __int_least32_t;
typedef __uint32_t __uint_least32_t;
typedef __int64_t __int_least64_t;
typedef __uint64_t __uint_least64_t;



typedef long int __quad_t;
typedef unsigned long int __u_quad_t;







typedef long int __intmax_t;
typedef unsigned long int __uintmax_t;
# 141 "/usr/include/x86_64-linux-gnu/bits/types.h" 3 4
# 1 "/usr/include/x86_64-linux-gnu/bits/typesizes.h" 1 3 4
# 142 "/usr/include/x86_64-linux-gnu/bits/types.h" 2 3 4
# 1 "/usr/include/x86_64-linux-gnu/bits/time64.h" 1 3 4
# 143 "/usr/include/x86_64-linux-gnu/bits/types.h" 2 3 4


typedef unsigned long int __dev_t;
typedef unsigned int __uid_t;
typedef unsigned int __gid_t;
typedef unsigned long int __ino_t;
typedef unsigned long int __ino64_t;
typedef unsigned int __mode_t;
typedef unsigned long int __nlink_t;
typedef long int __off_t;
typedef long int __off64_t;
typedef int __pid_t;
typedef struct { int __val[2]; } __fsid_t;
typedef long int __clock_t;
typedef unsigned long int __rlim_t;
typedef unsigned long int __rlim64_t;
typedef unsigned int __id_t;
typedef long int __time_t;
typedef unsigned int __useconds_t;
typedef long int __suseconds_t;
typedef long int __suseconds64_t;

typedef int __daddr_t;
typedef int __key_t;


typedef int __clockid_t;


typedef void * __timer_t;


typedef long int __blksize_t;




typedef long int __blkcnt_t;
typedef long int __blkcnt64_t;


typedef unsigned long int __fsblkcnt_t;
typedef unsigned long int __fsblkcnt64_t;


typedef unsigned long int __fsfilcnt_t;
typedef unsigned long int __fsfilcnt64_t;


typedef long int __fsword_t;

typedef long int __ssize_t;


typedef long int __syscall_slong_t;

typedef unsigned long int __syscall_ulong_t;



typedef __off64_t __loff_t;
typedef char *__caddr_t;


typedef long int __intptr_t;


typedef unsigned int __socklen_t;




typedef int __sig_atomic_t;
# 28 "/usr/include/stdint.h" 2 3 4
# 1 "/usr/include/x86_64-linux-gnu/bits/wchar.h" 1 3 4
# 29 "/usr/include/stdint.h" 2 3 4
# 1 "/usr/include/x86_64-linux-gnu/bits/wordsize.h" 1 3 4
# 30 "/usr/include/stdint.h" 2 3 4




# 1 "/usr/include/x86_64-linux-gnu/bits/stdint-intn.h" 1 3 4
# 24 "/usr/include/x86_64-linux-gnu/bits/stdint-intn.h" 3 4
typedef __int8_t int8_t;
typedef __int16_t int16_t;
typedef __int32_t int32_t;
typedef __int64_t int64_t;
# 35 "/usr/include/stdint.h" 2 3 4


# 1 "/usr/include/x86_64-linux-gnu/bits/stdint-uintn.h" 1 3 4
# 24 "/usr/include/x86_64-linux-gnu/bits/stdint-uintn.h" 3 4
typedef __uint8_t uint8_t;
typedef __uint16_t uint16_t;
typedef __uint32_t uint32_t;
typedef __uint64_t uint64_t;
# 38 "/usr/include/stdint.h" 2 3 4





typedef __int_least8_t int_least8_t;
typedef __int_least16_t int_least16_t;
typedef __int_least32_t int_least32_t;
typedef __int_least64_t int_least64_t;


typedef __uint_least8_t uint_least8_t;
typedef __uint_least16_t uint_least16_t;
typedef __uint_least32_t uint_least32_t;
typedef __uint_least64_t uint_least64_t;





typedef signed char int_fast8_t;

typedef long int int_fast16_t;
typedef long int int_fast32_t;
typedef long int int_fast64_t;
# 71 "/usr/include/stdint.h" 3 4
typedef unsigned char uint_fast8_t;

typedef unsigned long int uint_fast16_t;
typedef unsigned long int uint_fast32_t;
typedef unsigned long int uint_fast64_t;
# 87 "/usr/include/stdint.h" 3 4
typedef long int intptr_t;


typedef unsigned long int uintptr_t;
# 101 "/usr/include/stdint.h" 3 4
typedef __intmax_t intmax_t;
typedef __uintmax_t uintmax_t;
# 10 "/usr/lib/gcc/x86_64-linux-gnu/11/include/stdint.h" 2 3 4
# 28 "/usr/include/inttypes.h" 2 3 4






typedef int __gwchar_t;
# 266 "/usr/include/inttypes.h" 3 4





typedef struct
  {
    long int quot;
    long int rem;
  } imaxdiv_t;
# 290 "/usr/include/inttypes.h" 3 4
extern intmax_t imaxabs (intmax_t __n) ;


extern imaxdiv_t imaxdiv (intmax_t __numer, intmax_t __denom)
      ;


extern intmax_t strtoimax (const char *restrict __nptr,
      char **restrict __endptr, int __base) ;


extern uintmax_t strtoumax (const char *restrict __nptr,
       char ** restrict __endptr, int __base) ;


extern intmax_t wcstoimax (const __gwchar_t *restrict __nptr,
      __gwchar_t **restrict __endptr, int __base)
     ;


extern uintmax_t wcstoumax (const __gwchar_t *restrict __nptr,
       __gwchar_t ** restrict __endptr, int __base)
     ;


# 30 "/home/yangfp/five/_build/paparazzi/upstream/sw/include/std.h" 2
# 1 "/home/yangfp/.opam/five/bin/../share/../lib/compcert/include/stdbool.h" 1
# 31 "/home/yangfp/five/_build/paparazzi/upstream/sw/include/std.h" 2
# 1 "/usr/include/math.h" 1 3 4
# 27 "/usr/include/math.h" 3 4
# 1 "/usr/include/x86_64-linux-gnu/bits/libc-header-start.h" 1 3 4
# 28 "/usr/include/math.h" 2 3 4












# 1 "/usr/include/x86_64-linux-gnu/bits/math-vector.h" 1 3 4
# 25 "/usr/include/x86_64-linux-gnu/bits/math-vector.h" 3 4
# 1 "/usr/include/x86_64-linux-gnu/bits/libm-simd-decl-stubs.h" 1 3 4
# 26 "/usr/include/x86_64-linux-gnu/bits/math-vector.h" 2 3 4
# 41 "/usr/include/math.h" 2 3 4


# 1 "/usr/include/x86_64-linux-gnu/bits/floatn.h" 1 3 4
# 119 "/usr/include/x86_64-linux-gnu/bits/floatn.h" 3 4
# 1 "/usr/include/x86_64-linux-gnu/bits/floatn-common.h" 1 3 4
# 24 "/usr/include/x86_64-linux-gnu/bits/floatn-common.h" 3 4
# 1 "/usr/include/x86_64-linux-gnu/bits/long-double.h" 1 3 4
# 25 "/usr/include/x86_64-linux-gnu/bits/floatn-common.h" 2 3 4
# 214 "/usr/include/x86_64-linux-gnu/bits/floatn-common.h" 3 4
typedef float _Float32;
# 251 "/usr/include/x86_64-linux-gnu/bits/floatn-common.h" 3 4
typedef double _Float64;
# 268 "/usr/include/x86_64-linux-gnu/bits/floatn-common.h" 3 4
typedef double _Float32x;
# 285 "/usr/include/x86_64-linux-gnu/bits/floatn-common.h" 3 4
typedef long double _Float64x;
# 120 "/usr/include/x86_64-linux-gnu/bits/floatn.h" 2 3 4
# 44 "/usr/include/math.h" 2 3 4
# 152 "/usr/include/math.h" 3 4
# 1 "/usr/include/x86_64-linux-gnu/bits/flt-eval-method.h" 1 3 4
# 153 "/usr/include/math.h" 2 3 4
# 163 "/usr/include/math.h" 3 4
typedef float float_t;
typedef double double_t;
# 204 "/usr/include/math.h" 3 4
# 1 "/usr/include/x86_64-linux-gnu/bits/fp-logb.h" 1 3 4
# 205 "/usr/include/math.h" 2 3 4
# 247 "/usr/include/math.h" 3 4
# 1 "/usr/include/x86_64-linux-gnu/bits/fp-fast.h" 1 3 4
# 248 "/usr/include/math.h" 2 3 4
# 312 "/usr/include/math.h" 3 4
# 1 "/usr/include/x86_64-linux-gnu/bits/mathcalls-helper-functions.h" 1 3 4
# 20 "/usr/include/x86_64-linux-gnu/bits/mathcalls-helper-functions.h" 3 4
extern int __fpclassify (double __value)
     ;


extern int __signbit (double __value)
     ;



extern int __isinf (double __value)
  ;


extern int __finite (double __value)
  ;


extern int __isnan (double __value)
  ;


extern int __iseqsig (double __x, double __y) ;


extern int __issignaling (double __value)
     ;
# 313 "/usr/include/math.h" 2 3 4
# 1 "/usr/include/x86_64-linux-gnu/bits/mathcalls.h" 1 3 4
# 53 "/usr/include/x86_64-linux-gnu/bits/mathcalls.h" 3 4
 extern double acos (double __x) ; extern double __acos (double __x) ;

 extern double asin (double __x) ; extern double __asin (double __x) ;

 extern double atan (double __x) ; extern double __atan (double __x) ;

 extern double atan2 (double __y, double __x) ; extern double __atan2 (double __y, double __x) ;


 extern double cos (double __x) ; extern double __cos (double __x) ;

 extern double sin (double __x) ; extern double __sin (double __x) ;

 extern double tan (double __x) ; extern double __tan (double __x) ;




 extern double cosh (double __x) ; extern double __cosh (double __x) ;

 extern double sinh (double __x) ; extern double __sinh (double __x) ;

 extern double tanh (double __x) ; extern double __tanh (double __x) ;
# 85 "/usr/include/x86_64-linux-gnu/bits/mathcalls.h" 3 4
 extern double acosh (double __x) ; extern double __acosh (double __x) ;

 extern double asinh (double __x) ; extern double __asinh (double __x) ;

 extern double atanh (double __x) ; extern double __atanh (double __x) ;





 extern double exp (double __x) ; extern double __exp (double __x) ;


extern double frexp (double __x, int *__exponent) ; extern double __frexp (double __x, int *__exponent) ;


extern double ldexp (double __x, int __exponent) ; extern double __ldexp (double __x, int __exponent) ;


 extern double log (double __x) ; extern double __log (double __x) ;


 extern double log10 (double __x) ; extern double __log10 (double __x) ;


extern double modf (double __x, double *__iptr) ; extern double __modf (double __x, double *__iptr) ;
# 119 "/usr/include/x86_64-linux-gnu/bits/mathcalls.h" 3 4
 extern double expm1 (double __x) ; extern double __expm1 (double __x) ;


 extern double log1p (double __x) ; extern double __log1p (double __x) ;


extern double logb (double __x) ; extern double __logb (double __x) ;




 extern double exp2 (double __x) ; extern double __exp2 (double __x) ;


 extern double log2 (double __x) ; extern double __log2 (double __x) ;






 extern double pow (double __x, double __y) ; extern double __pow (double __x, double __y) ;


extern double sqrt (double __x) ; extern double __sqrt (double __x) ;



 extern double hypot (double __x, double __y) ; extern double __hypot (double __x, double __y) ;




 extern double cbrt (double __x) ; extern double __cbrt (double __x) ;






extern double ceil (double __x) ; extern double __ceil (double __x) ;


extern double fabs (double __x) ; extern double __fabs (double __x) ;


extern double floor (double __x) ; extern double __floor (double __x) ;


extern double fmod (double __x, double __y) ; extern double __fmod (double __x, double __y) ;
# 198 "/usr/include/x86_64-linux-gnu/bits/mathcalls.h" 3 4
extern double copysign (double __x, double __y) ; extern double __copysign (double __x, double __y) ;




extern double nan (const char *__tagb) ; extern double __nan (const char *__tagb) ;
# 231 "/usr/include/x86_64-linux-gnu/bits/mathcalls.h" 3 4
 extern double erf (double) ; extern double __erf (double) ;
 extern double erfc (double) ; extern double __erfc (double) ;
extern double lgamma (double) ; extern double __lgamma (double) ;




extern double tgamma (double) ; extern double __tgamma (double) ;
# 259 "/usr/include/x86_64-linux-gnu/bits/mathcalls.h" 3 4
extern double rint (double __x) ; extern double __rint (double __x) ;


extern double nextafter (double __x, double __y) ; extern double __nextafter (double __x, double __y) ;

extern double nexttoward (double __x, long double __y) ; extern double __nexttoward (double __x, long double __y) ;
# 275 "/usr/include/x86_64-linux-gnu/bits/mathcalls.h" 3 4
extern double remainder (double __x, double __y) ; extern double __remainder (double __x, double __y) ;



extern double scalbn (double __x, int __n) ; extern double __scalbn (double __x, int __n) ;



extern int ilogb (double __x) ; extern int __ilogb (double __x) ;
# 293 "/usr/include/x86_64-linux-gnu/bits/mathcalls.h" 3 4
extern double scalbln (double __x, long int __n) ; extern double __scalbln (double __x, long int __n) ;



extern double nearbyint (double __x) ; extern double __nearbyint (double __x) ;



extern double round (double __x) ; extern double __round (double __x) ;



extern double trunc (double __x) ; extern double __trunc (double __x) ;




extern double remquo (double __x, double __y, int *__quo) ; extern double __remquo (double __x, double __y, int *__quo) ;






extern long int lrint (double __x) ; extern long int __lrint (double __x) ;

extern long long int llrint (double __x) ; extern long long int __llrint (double __x) ;



extern long int lround (double __x) ; extern long int __lround (double __x) ;

extern long long int llround (double __x) ; extern long long int __llround (double __x) ;



extern double fdim (double __x, double __y) ; extern double __fdim (double __x, double __y) ;



extern double fmax (double __x, double __y) ; extern double __fmax (double __x, double __y) ;


extern double fmin (double __x, double __y) ; extern double __fmin (double __x, double __y) ;



extern double fma (double __x, double __y, double __z) ; extern double __fma (double __x, double __y, double __z) ;
# 314 "/usr/include/math.h" 2 3 4
# 329 "/usr/include/math.h" 3 4
# 1 "/usr/include/x86_64-linux-gnu/bits/mathcalls-helper-functions.h" 1 3 4
# 20 "/usr/include/x86_64-linux-gnu/bits/mathcalls-helper-functions.h" 3 4
extern int __fpclassifyf (float __value)
     ;


extern int __signbitf (float __value)
     ;



extern int __isinff (float __value)
  ;


extern int __finitef (float __value)
  ;


extern int __isnanf (float __value)
  ;


extern int __iseqsigf (float __x, float __y) ;


extern int __issignalingf (float __value)
     ;
# 330 "/usr/include/math.h" 2 3 4
# 1 "/usr/include/x86_64-linux-gnu/bits/mathcalls.h" 1 3 4
# 53 "/usr/include/x86_64-linux-gnu/bits/mathcalls.h" 3 4
 extern float acosf (float __x) ; extern float __acosf (float __x) ;

 extern float asinf (float __x) ; extern float __asinf (float __x) ;

 extern float atanf (float __x) ; extern float __atanf (float __x) ;

 extern float atan2f (float __y, float __x) ; extern float __atan2f (float __y, float __x) ;


 extern float cosf (float __x) ; extern float __cosf (float __x) ;

 extern float sinf (float __x) ; extern float __sinf (float __x) ;

 extern float tanf (float __x) ; extern float __tanf (float __x) ;




 extern float coshf (float __x) ; extern float __coshf (float __x) ;

 extern float sinhf (float __x) ; extern float __sinhf (float __x) ;

 extern float tanhf (float __x) ; extern float __tanhf (float __x) ;
# 85 "/usr/include/x86_64-linux-gnu/bits/mathcalls.h" 3 4
 extern float acoshf (float __x) ; extern float __acoshf (float __x) ;

 extern float asinhf (float __x) ; extern float __asinhf (float __x) ;

 extern float atanhf (float __x) ; extern float __atanhf (float __x) ;





 extern float expf (float __x) ; extern float __expf (float __x) ;


extern float frexpf (float __x, int *__exponent) ; extern float __frexpf (float __x, int *__exponent) ;


extern float ldexpf (float __x, int __exponent) ; extern float __ldexpf (float __x, int __exponent) ;


 extern float logf (float __x) ; extern float __logf (float __x) ;


 extern float log10f (float __x) ; extern float __log10f (float __x) ;


extern float modff (float __x, float *__iptr) ; extern float __modff (float __x, float *__iptr) ;
# 119 "/usr/include/x86_64-linux-gnu/bits/mathcalls.h" 3 4
 extern float expm1f (float __x) ; extern float __expm1f (float __x) ;


 extern float log1pf (float __x) ; extern float __log1pf (float __x) ;


extern float logbf (float __x) ; extern float __logbf (float __x) ;




 extern float exp2f (float __x) ; extern float __exp2f (float __x) ;


 extern float log2f (float __x) ; extern float __log2f (float __x) ;






 extern float powf (float __x, float __y) ; extern float __powf (float __x, float __y) ;


extern float sqrtf (float __x) ; extern float __sqrtf (float __x) ;



 extern float hypotf (float __x, float __y) ; extern float __hypotf (float __x, float __y) ;




 extern float cbrtf (float __x) ; extern float __cbrtf (float __x) ;






extern float ceilf (float __x) ; extern float __ceilf (float __x) ;


extern float fabsf (float __x) ; extern float __fabsf (float __x) ;


extern float floorf (float __x) ; extern float __floorf (float __x) ;


extern float fmodf (float __x, float __y) ; extern float __fmodf (float __x, float __y) ;
# 198 "/usr/include/x86_64-linux-gnu/bits/mathcalls.h" 3 4
extern float copysignf (float __x, float __y) ; extern float __copysignf (float __x, float __y) ;




extern float nanf (const char *__tagb) ; extern float __nanf (const char *__tagb) ;
# 231 "/usr/include/x86_64-linux-gnu/bits/mathcalls.h" 3 4
 extern float erff (float) ; extern float __erff (float) ;
 extern float erfcf (float) ; extern float __erfcf (float) ;
extern float lgammaf (float) ; extern float __lgammaf (float) ;




extern float tgammaf (float) ; extern float __tgammaf (float) ;
# 259 "/usr/include/x86_64-linux-gnu/bits/mathcalls.h" 3 4
extern float rintf (float __x) ; extern float __rintf (float __x) ;


extern float nextafterf (float __x, float __y) ; extern float __nextafterf (float __x, float __y) ;

extern float nexttowardf (float __x, long double __y) ; extern float __nexttowardf (float __x, long double __y) ;
# 275 "/usr/include/x86_64-linux-gnu/bits/mathcalls.h" 3 4
extern float remainderf (float __x, float __y) ; extern float __remainderf (float __x, float __y) ;



extern float scalbnf (float __x, int __n) ; extern float __scalbnf (float __x, int __n) ;



extern int ilogbf (float __x) ; extern int __ilogbf (float __x) ;
# 293 "/usr/include/x86_64-linux-gnu/bits/mathcalls.h" 3 4
extern float scalblnf (float __x, long int __n) ; extern float __scalblnf (float __x, long int __n) ;



extern float nearbyintf (float __x) ; extern float __nearbyintf (float __x) ;



extern float roundf (float __x) ; extern float __roundf (float __x) ;



extern float truncf (float __x) ; extern float __truncf (float __x) ;




extern float remquof (float __x, float __y, int *__quo) ; extern float __remquof (float __x, float __y, int *__quo) ;






extern long int lrintf (float __x) ; extern long int __lrintf (float __x) ;

extern long long int llrintf (float __x) ; extern long long int __llrintf (float __x) ;



extern long int lroundf (float __x) ; extern long int __lroundf (float __x) ;

extern long long int llroundf (float __x) ; extern long long int __llroundf (float __x) ;



extern float fdimf (float __x, float __y) ; extern float __fdimf (float __x, float __y) ;



extern float fmaxf (float __x, float __y) ; extern float __fmaxf (float __x, float __y) ;


extern float fminf (float __x, float __y) ; extern float __fminf (float __x, float __y) ;



extern float fmaf (float __x, float __y, float __z) ; extern float __fmaf (float __x, float __y, float __z) ;
# 331 "/usr/include/math.h" 2 3 4
# 398 "/usr/include/math.h" 3 4
# 1 "/usr/include/x86_64-linux-gnu/bits/mathcalls-helper-functions.h" 1 3 4
# 20 "/usr/include/x86_64-linux-gnu/bits/mathcalls-helper-functions.h" 3 4
extern int __fpclassifyl (long double __value)
     ;


extern int __signbitl (long double __value)
     ;



extern int __isinfl (long double __value)
  ;


extern int __finitel (long double __value)
  ;


extern int __isnanl (long double __value)
  ;


extern int __iseqsigl (long double __x, long double __y) ;


extern int __issignalingl (long double __value)
     ;
# 399 "/usr/include/math.h" 2 3 4
# 1 "/usr/include/x86_64-linux-gnu/bits/mathcalls.h" 1 3 4
# 53 "/usr/include/x86_64-linux-gnu/bits/mathcalls.h" 3 4
 extern long double acosl (long double __x) ; extern long double __acosl (long double __x) ;

 extern long double asinl (long double __x) ; extern long double __asinl (long double __x) ;

 extern long double atanl (long double __x) ; extern long double __atanl (long double __x) ;

 extern long double atan2l (long double __y, long double __x) ; extern long double __atan2l (long double __y, long double __x) ;


 extern long double cosl (long double __x) ; extern long double __cosl (long double __x) ;

 extern long double sinl (long double __x) ; extern long double __sinl (long double __x) ;

 extern long double tanl (long double __x) ; extern long double __tanl (long double __x) ;




 extern long double coshl (long double __x) ; extern long double __coshl (long double __x) ;

 extern long double sinhl (long double __x) ; extern long double __sinhl (long double __x) ;

 extern long double tanhl (long double __x) ; extern long double __tanhl (long double __x) ;
# 85 "/usr/include/x86_64-linux-gnu/bits/mathcalls.h" 3 4
 extern long double acoshl (long double __x) ; extern long double __acoshl (long double __x) ;

 extern long double asinhl (long double __x) ; extern long double __asinhl (long double __x) ;

 extern long double atanhl (long double __x) ; extern long double __atanhl (long double __x) ;





 extern long double expl (long double __x) ; extern long double __expl (long double __x) ;


extern long double frexpl (long double __x, int *__exponent) ; extern long double __frexpl (long double __x, int *__exponent) ;


extern long double ldexpl (long double __x, int __exponent) ; extern long double __ldexpl (long double __x, int __exponent) ;


 extern long double logl (long double __x) ; extern long double __logl (long double __x) ;


 extern long double log10l (long double __x) ; extern long double __log10l (long double __x) ;


extern long double modfl (long double __x, long double *__iptr) ; extern long double __modfl (long double __x, long double *__iptr) ;
# 119 "/usr/include/x86_64-linux-gnu/bits/mathcalls.h" 3 4
 extern long double expm1l (long double __x) ; extern long double __expm1l (long double __x) ;


 extern long double log1pl (long double __x) ; extern long double __log1pl (long double __x) ;


extern long double logbl (long double __x) ; extern long double __logbl (long double __x) ;




 extern long double exp2l (long double __x) ; extern long double __exp2l (long double __x) ;


 extern long double log2l (long double __x) ; extern long double __log2l (long double __x) ;






 extern long double powl (long double __x, long double __y) ; extern long double __powl (long double __x, long double __y) ;


extern long double sqrtl (long double __x) ; extern long double __sqrtl (long double __x) ;



 extern long double hypotl (long double __x, long double __y) ; extern long double __hypotl (long double __x, long double __y) ;




 extern long double cbrtl (long double __x) ; extern long double __cbrtl (long double __x) ;






extern long double ceill (long double __x) ; extern long double __ceill (long double __x) ;


extern long double fabsl (long double __x) ; extern long double __fabsl (long double __x) ;


extern long double floorl (long double __x) ; extern long double __floorl (long double __x) ;


extern long double fmodl (long double __x, long double __y) ; extern long double __fmodl (long double __x, long double __y) ;
# 198 "/usr/include/x86_64-linux-gnu/bits/mathcalls.h" 3 4
extern long double copysignl (long double __x, long double __y) ; extern long double __copysignl (long double __x, long double __y) ;




extern long double nanl (const char *__tagb) ; extern long double __nanl (const char *__tagb) ;
# 231 "/usr/include/x86_64-linux-gnu/bits/mathcalls.h" 3 4
 extern long double erfl (long double) ; extern long double __erfl (long double) ;
 extern long double erfcl (long double) ; extern long double __erfcl (long double) ;
extern long double lgammal (long double) ; extern long double __lgammal (long double) ;




extern long double tgammal (long double) ; extern long double __tgammal (long double) ;
# 259 "/usr/include/x86_64-linux-gnu/bits/mathcalls.h" 3 4
extern long double rintl (long double __x) ; extern long double __rintl (long double __x) ;


extern long double nextafterl (long double __x, long double __y) ; extern long double __nextafterl (long double __x, long double __y) ;

extern long double nexttowardl (long double __x, long double __y) ; extern long double __nexttowardl (long double __x, long double __y) ;
# 275 "/usr/include/x86_64-linux-gnu/bits/mathcalls.h" 3 4
extern long double remainderl (long double __x, long double __y) ; extern long double __remainderl (long double __x, long double __y) ;



extern long double scalbnl (long double __x, int __n) ; extern long double __scalbnl (long double __x, int __n) ;



extern int ilogbl (long double __x) ; extern int __ilogbl (long double __x) ;
# 293 "/usr/include/x86_64-linux-gnu/bits/mathcalls.h" 3 4
extern long double scalblnl (long double __x, long int __n) ; extern long double __scalblnl (long double __x, long int __n) ;



extern long double nearbyintl (long double __x) ; extern long double __nearbyintl (long double __x) ;



extern long double roundl (long double __x) ; extern long double __roundl (long double __x) ;



extern long double truncl (long double __x) ; extern long double __truncl (long double __x) ;




extern long double remquol (long double __x, long double __y, int *__quo) ; extern long double __remquol (long double __x, long double __y, int *__quo) ;






extern long int lrintl (long double __x) ; extern long int __lrintl (long double __x) ;

extern long long int llrintl (long double __x) ; extern long long int __llrintl (long double __x) ;



extern long int lroundl (long double __x) ; extern long int __lroundl (long double __x) ;

extern long long int llroundl (long double __x) ; extern long long int __llroundl (long double __x) ;



extern long double fdiml (long double __x, long double __y) ; extern long double __fdiml (long double __x, long double __y) ;



extern long double fmaxl (long double __x, long double __y) ; extern long double __fmaxl (long double __x, long double __y) ;


extern long double fminl (long double __x, long double __y) ; extern long double __fminl (long double __x, long double __y) ;



extern long double fmal (long double __x, long double __y, long double __z) ; extern long double __fmal (long double __x, long double __y, long double __z) ;
# 400 "/usr/include/math.h" 2 3 4
# 934 "/usr/include/math.h" 3 4
enum
  {
    FP_NAN =

      0,
    FP_INFINITE =

      1,
    FP_ZERO =

      2,
    FP_SUBNORMAL =

      3,
    FP_NORMAL =

      4
  };
# 1423 "/usr/include/math.h" 3 4

# 32 "/home/yangfp/five/_build/paparazzi/upstream/sw/include/std.h" 2






# 1 "/home/yangfp/five/_build/paparazzi/upstream/sw/include/message_pragmas.h" 1
# 39 "/home/yangfp/five/_build/paparazzi/upstream/sw/include/std.h" 2
# 62 "/home/yangfp/five/_build/paparazzi/upstream/sw/include/std.h"

# 62 "/home/yangfp/five/_build/paparazzi/upstream/sw/include/std.h"
typedef uint8_t unit_t;
# 263 "/home/yangfp/five/_build/paparazzi/upstream/sw/include/std.h"
static inline _Bool str_equal(const char *a, const char *b)
{
  int i = 0;
  while (!(a[i] == 0 && b[i] == 0)) {
    if (a[i] != b[i]) { return 0; }
    i++;
  }
  return 1;
}
# 46 "/home/yangfp/five/_build/paparazzi/overlay/math/pprz_algebra.h" 2
# 39 "/home/yangfp/five/_build/paparazzi/overlay/math/pprz_algebra_float.h" 2
# 1 "/home/yangfp/five/_build/paparazzi/upstream/sw/include/message_pragmas.h" 1
# 40 "/home/yangfp/five/_build/paparazzi/overlay/math/pprz_algebra_float.h" 2
# 49 "/home/yangfp/five/_build/paparazzi/overlay/math/pprz_algebra_float.h"
struct FloatVect2 {
  float x;
  float y;
};

struct FloatVect3 {
  float x;
  float y;
  float z;
};




struct FloatQuat {
  float qi;
  float qx;
  float qy;
  float qz;
};

struct FloatMat33 {
  float m[3 * 3];
};




struct FloatRMat {
  float m[3 * 3];
};




struct FloatEulers {
  float phi;
  float theta;
  float psi;
};




struct FloatRates {
  float p;
  float q;
  float r;
};
# 107 "/home/yangfp/five/_build/paparazzi/overlay/math/pprz_algebra_float.h"
static inline float float_log_n(const float v, const float n)
{
  if (fabsf(v) < 1e-4) {
    return - 1.0E+30;
  }
  if (fabsf(n) < 1e-4) {
    return 0;
  }
  return logf(fabsf(v)) / logf(n);
}
# 134 "/home/yangfp/five/_build/paparazzi/overlay/math/pprz_algebra_float.h"
static inline float float_vect2_norm2(const struct FloatVect2 *v)
{
  return v->x * v->x + v->y * v->y;
}

static inline float float_vect2_norm(const struct FloatVect2 *v)
{
  return sqrtf(float_vect2_norm2(v));
}


static inline void float_vect2_normalize(struct FloatVect2 *v)
{
  const float n = float_vect2_norm(v);
  if (n > 1e-4f) {
    v->x /= n;
    v->y /= n;
  }
}
# 166 "/home/yangfp/five/_build/paparazzi/overlay/math/pprz_algebra_float.h"
static inline float float_vect3_norm2(const struct FloatVect3 *v)
{
  return v->x * v->x + v->y * v->y + v->z * v->z;
}

static inline float float_vect3_norm(const struct FloatVect3 *v)
{
  return sqrtf(float_vect3_norm2(v));
}


static inline void float_vect3_normalize(struct FloatVect3 *v)
{
  const float n = float_vect3_norm(v);
  if (n > 1e-4f) {
    v->x /= n;
    v->y /= n;
    v->z /= n;
  }
}
# 204 "/home/yangfp/five/_build/paparazzi/overlay/math/pprz_algebra_float.h"
extern void float_vect3_integrate_fi(struct FloatVect3 *vec, const struct FloatVect3 *dv,
                                     const float dt);

extern void float_rates_integrate_fi(struct FloatRates *r, const struct FloatRates *dr,
                                     const float dt);

extern void float_rates_vect3_integrate_fi(struct FloatRates *r, const struct FloatVect3 *dr,
    const float dt);

extern void float_rates_of_euler_dot(struct FloatRates *r, const struct FloatEulers *e,
                                     const struct FloatEulers *edot);
# 258 "/home/yangfp/five/_build/paparazzi/overlay/math/pprz_algebra_float.h"
static inline void float_rmat_identity(struct FloatRMat *rm)
{
  { ((*rm).m[(0)*3+(0)]) = 1.; ((*rm).m[(0)*3+(1)]) = 0.; ((*rm).m[(0)*3+(2)]) = 0.; ((*rm).m[(1)*3+(0)]) = 0.; ((*rm).m[(1)*3+(1)]) = 1.; ((*rm).m[(1)*3+(2)]) = 0.; ((*rm).m[(2)*3+(0)]) = 0.; ((*rm).m[(2)*3+(1)]) = 0.; ((*rm).m[(2)*3+(2)]) = 1.; };
}




extern void float_rmat_inv(struct FloatRMat *m_b2a, const struct FloatRMat *m_a2b);




extern void float_rmat_comp(struct FloatRMat *m_a2c, const struct FloatRMat *m_a2b,
                            const struct FloatRMat *m_b2c);




extern void float_rmat_comp_inv(struct FloatRMat *m_a2b, const struct FloatRMat *m_a2c,
                                const struct FloatRMat *m_b2c);


extern float float_rmat_norm(const struct FloatRMat *rm);




extern void float_rmat_vmult(struct FloatVect3 *vb, const struct FloatRMat *m_a2b,
                             const struct FloatVect3 *va);




extern void float_rmat_transp_vmult(struct FloatVect3 *vb, const struct FloatRMat *m_b2a,
                                    const struct FloatVect3 *va);




extern void float_rmat_mult(struct FloatEulers *rb, const struct FloatRMat *m_a2b,
                            const struct FloatEulers *ra);




extern void float_rmat_transp_mult(struct FloatEulers *rb, const struct FloatRMat *m_b2a,
                                   const struct FloatEulers *ra);




extern void float_rmat_ratemult(struct FloatRates *rb, const struct FloatRMat *m_a2b,
                                const struct FloatRates *ra);




extern void float_rmat_transp_ratemult(struct FloatRates *rb, const struct FloatRMat *m_b2a,
                                       const struct FloatRates *ra);


extern void float_rmat_of_axis_angle(struct FloatRMat *rm, const struct FloatVect3 *uv, const float angle);
# 334 "/home/yangfp/five/_build/paparazzi/overlay/math/pprz_algebra_float.h"
extern void float_rmat_of_eulers_321(struct FloatRMat *rm, const struct FloatEulers *e);
extern void float_rmat_of_eulers_312(struct FloatRMat *rm, const struct FloatEulers *e);


extern void float_rmat_of_quat(struct FloatRMat *rm, const struct FloatQuat *q);

extern void float_rmat_integrate_fi(struct FloatRMat *rm, const struct FloatRates *omega, const float dt);
extern float float_rmat_reorthogonalize(struct FloatRMat *rm);
# 368 "/home/yangfp/five/_build/paparazzi/overlay/math/pprz_algebra_float.h"
static inline void float_quat_identity(struct FloatQuat *q)
{
  q->qi = 1.0;
  q->qx = 0;
  q->qy = 0;
  q->qz = 0;
}



static inline float float_quat_norm(const struct FloatQuat *q)
{
  return sqrtf(((q->qi)*(q->qi)) + ((q->qx)*(q->qx)) + ((q->qy)*(q->qy)) + ((q->qz)*(q->qz)));
}

static inline void float_quat_normalize(struct FloatQuat *q)
{
  float qnorm = float_quat_norm(q);
  if (qnorm > 0x1p-126F) {
    q->qi = q->qi / qnorm;
    q->qx = q->qx / qnorm;
    q->qy = q->qy / qnorm;
    q->qz = q->qz / qnorm;
  }
}

static inline void float_quat_invert(struct FloatQuat *qo, const struct FloatQuat *qi)
{
  { (*qo).qi = (*qi).qi; (*qo).qx = -(*qi).qx; (*qo).qy = -(*qi).qy; (*qo).qz = -(*qi).qz; };
}

static inline void float_quat_wrap_shortest(struct FloatQuat *q)
{
  if (q->qi < 0.) {
    { (*q).qi = -(*q).qi; (*q).qx = -(*q).qx; (*q).qy = -(*q).qy; (*q).qz = -(*q).qz; };
  }
}







extern void float_quat_comp(struct FloatQuat *a2c, const struct FloatQuat *a2b, const struct FloatQuat *b2c);




extern void float_quat_comp_inv(struct FloatQuat *a2b, const struct FloatQuat *a2c, const struct FloatQuat *b2c);




extern void float_quat_inv_comp(struct FloatQuat *b2c, const struct FloatQuat *a2b, const struct FloatQuat *a2c);




extern void float_quat_comp_norm_shortest(struct FloatQuat *a2c, const struct FloatQuat *a2b,
    const struct FloatQuat *b2c);




extern void float_quat_comp_inv_norm_shortest(struct FloatQuat *a2b, const struct FloatQuat *a2c,
    const struct FloatQuat *b2c);




extern void float_quat_inv_comp_norm_shortest(struct FloatQuat *b2c, const struct FloatQuat *a2b,
    const struct FloatQuat *a2c);






extern void float_quat_derivative(struct FloatQuat *qd, const struct FloatRates *r, const struct FloatQuat *q);






extern void float_quat_derivative_lagrange(struct FloatQuat *qd, const struct FloatRates *r, const struct FloatQuat *q);



extern void float_quat_differential(struct FloatQuat *q_out, const struct FloatRates *w, const float dt);


extern void float_quat_integrate_fi(struct FloatQuat *q, const struct FloatRates *omega, const float dt);


extern void float_quat_integrate(struct FloatQuat *q, const struct FloatRates *omega, const float dt);




extern void float_quat_vmult(struct FloatVect3 *v_out, const struct FloatQuat *q, const struct FloatVect3 *v_in);


extern void float_quat_of_eulers(struct FloatQuat *q, const struct FloatEulers *e);
extern void float_quat_of_eulers_zxy(struct FloatQuat *q, const struct FloatEulers *e);
extern void float_quat_of_eulers_yxz(struct FloatQuat *q, const struct FloatEulers *e);





extern void float_quat_of_axis_angle(struct FloatQuat *q, const struct FloatVect3 *uv, const float angle);




extern void float_quat_of_orientation_vect(struct FloatQuat *q, const struct FloatVect3 *ov);


extern void float_quat_of_rmat(struct FloatQuat *q, const struct FloatRMat *rm);


extern void float_quat_tilt_twist(struct FloatQuat *tilt, struct FloatQuat *twist, const struct FloatQuat *quat);
# 527 "/home/yangfp/five/_build/paparazzi/overlay/math/pprz_algebra_float.h"
static inline float float_eulers_norm(const struct FloatEulers *e)
{
  return sqrtf(((e->phi)*(e->phi)) + ((e->theta)*(e->theta)) + ((e->psi)*(e->psi)));
}
extern void float_eulers_of_rmat(struct FloatEulers *e, const struct FloatRMat *rm);
extern void float_eulers_of_quat(struct FloatEulers *e, const struct FloatQuat *q);
extern void float_eulers_of_quat_zxy(struct FloatEulers *e, const struct FloatQuat *q);
extern void float_eulers_of_quat_yxz(struct FloatEulers *e, const struct FloatQuat *q);
# 548 "/home/yangfp/five/_build/paparazzi/overlay/math/pprz_algebra_float.h"
static inline void float_vect_zero(float *a, const int n)
{
  int i;
  for (i = 0; i < n; i++) { a[i] = 0.; }
}


static inline void float_vect_copy(float *a, const float *b, const int n)
{
  int i;
  for (i = 0; i < n; i++) { a[i] = b[i]; }
}


static inline void float_vect_sum(float *o, const float *a, const float *b, const int n)
{
  int i;
  for (i = 0; i < n; i++) { o[i] = a[i] + b[i]; }
}


static inline void float_vect_diff(float *o, const float *a, const float *b, const int n)
{
  int i;
  for (i = 0; i < n; i++) { o[i] = a[i] - b[i]; }
}


static inline void float_vect_mul(float *o, const float *a, const float *b, const int n)
{
  int i;
  for (i = 0; i < n; i++) { o[i] = a[i] * b[i]; }
}


static inline void float_vect_add(float *a, const float *b, const int n)
{
  int i;
  for (i = 0; i < n; i++) { a[i] += b[i]; }
}


static inline void float_vect_sub(float *a, const float *b, const int n)
{
  int i;
  for (i = 0; i < n; i++) { a[i] -= b[i]; }
}


static inline void float_vect_smul(float *o, const float *a, const float s, const int n)
{
  int i;
  for (i = 0; i < n; i++) { o[i] = a[i] * s; }
}


static inline void float_vect_sdiv(float *o, const float *a, const float s, const int n)
{
  int i;
  if (fabs(s) > 1e-5) {
    for (i = 0; i < n; i++) { o[i] = a[i] / s; }
  }
}


static inline float float_vect_norm(const float *a, const int n)
{
  int i;
  float sum = 0;
  for (i = 0; i < n; i++) { sum += a[i] * a[i]; }
  return sqrtf(sum);
}


static inline void float_vect_scale(float *a, const float s, const int n)
{
  int i;
  for (i = 0; i < n; i++) { a[i] *= s; }
}


static inline float float_vect_dot_product(const float *a, const float *b, const int n)
{
  int i;
  float dot = 0.f;
  for (i = 0; i < n; i++) { dot += a[i] * b[i]; }
  return dot;
}
# 651 "/home/yangfp/five/_build/paparazzi/overlay/math/pprz_algebra_float.h"
extern void float_mat_invert(float **o, float **mat, const int n);
extern void float_mat_exp(float **a, float **o, const int n);
extern float float_mat_norm_li(float **o, const int m, const int n);


static inline void float_mat_zero(float **a, const int m, const int n)
{
  int i, j;
  for (i = 0; i < m; i++) {
    for (j = 0; j < n; j++) { a[i][j] = 0.; }
  }
}


static inline void float_mat_copy(float **a, float **b, const int m, const int n)
{
  int i, j;
  for (i = 0; i < m; i++) {
    for (j = 0; j < n; j++) { a[i][j] = b[i][j]; }
  }
}




static inline void float_mat_sum(float **o, float **a, float **b, const int m, const int n)
{
  int i, j;
  for (i = 0; i < m; i++) {
    for (j = 0; j < n; j++) { o[i][j] = a[i][j] + b[i][j]; }
  }
}


static inline void float_mat_diff(float **o, float **a, float **b, const int m, const int n)
{
  int i, j;
  for (i = 0; i < m; i++) {
    for (j = 0; j < n; j++) { o[i][j] = a[i][j] - b[i][j]; }
  }
}


static inline void float_mat_transpose_square(float **a, const int n)
{
  int i, j;
  for (i = 0; i < n; i++) {
    for (j = 0; j < i; j++) {
      float t = a[i][j];
      a[i][j] = a[j][i];
      a[j][i] = t;
    }
  }
}



static inline void float_mat_transpose(float **o, float **a, const int n, const int m)
{
  int i, j;
  for (i = 0; i < n; i++) {
    for (j = 0; j < m; j++) {
      o[j][i] = a[i][j];
    }
  }
}







static inline void float_mat_mul(float **o, float **a, float **b, const int m, const int n, const int l)
{
  int i, j, k;
  for (i = 0; i < m; i++) {
    for (j = 0; j < l; j++) {
      o[i][j] = 0.;
      for (k = 0; k < n; k++) {
        o[i][j] += a[i][k] * b[k][j];
      }
    }
  }
}







static inline void float_mat_mul_transpose(float **o, float **a, float **b, const int m, const int n, const int l)
{
  int i, j, k;
  for (i = 0; i < m; i++) {
    for (j = 0; j < l; j++) {
      o[i][j] = 0.;
      for (k = 0; k < n; k++) {
        o[i][j] += a[i][k] * b[j][k];
      }
    }
  }
}
# 791 "/home/yangfp/five/_build/paparazzi/overlay/math/pprz_algebra_float.h"
static inline void float_mat_vect_mul(float *o, float **a, const float *b, const int m, const int n)
{
  int i, j;
  for (i = 0; i < m; i++) {
    o[i] = 0;
    for (j = 0; j < n; j++) {
      o[i] += a[i][j] * b[j];
    }
  }
}






static inline void float_mat_scale(float **a, float k, const int m, const int n)
{
  int i, j;
  for (i = 0; i < m; i++) {
    for (j = 0; j < n; j++) {
      a[i][j] *= k;
    }
  }
}







static inline void float_mat_sum_scaled(float **a, float **b, const float k, const int m, const int n)
{
  int i, j;
  for (i = 0; i < m; i++) {
    for (j = 0; j < n; j++) {
      a[i][j] += k * b[i][j];
    }
  }
}
# 840 "/home/yangfp/five/_build/paparazzi/overlay/math/pprz_algebra_float.h"
static inline void float_mat_minor(float **o, float **a, const int m, const int n, const int d)
{
  int i, j;
  float_mat_zero(o, m, n);
  for (i = 0; i < d; i++) { o[i][i] = 1.0; }
  for (i = d; i < m; i++) {
    for (j = d; j < n; j++) {
      o[i][j] = a[i][j];
    }
  }
}


static inline void float_mat_vmul(float **o, const float *v, const int n)
{
  int i, j;
  for (i = 0; i < n; i++) {
    for (j = 0; j < n; j++) {
      o[i][j] = -2. * v[i] * v[j];
    }
  }
  for (i = 0; i < n; i++) {
    o[i][i] += 1.;
  }
}


static inline void float_mat_col(float *o, float **a, const int m, const int c)
{
  int i;
  for (i = 0; i < m; i++) {
    o[i] = a[i][c];
  }
}


static inline void float_mat_diagonal_scal(float **o, float v, const int n)
{
  int i, j;
  for (i = 0 ; i < n; i++) {
    for (j = 0 ; j < n; j++) {
      if (i == j) {
        o[i][j] = v;
      } else {
        o[i][j] = 0.0;
      }
    }
  }
}



static inline void float_mat_div_scalar(float **o, float **a, const float scalar, const int m, const int n)
{
  int i, j;
  for (i = 0; i < m; i++) {
    for (j = 0; j < n; j++) {
      o[i][j] = a[i][j] / scalar;
    }
  }
}


static inline void float_mat_mul_scalar(float **o, float **a, const float scalar, const int m, const int n)
{
  int i, j;
  for (i = 0; i < m; i++) {
    for (j = 0; j < n; j++) {
      o[i][j] = a[i][j] * scalar;
    }
  }
}



extern _Bool float_mat_inv_2d(float inv_out[4], const float mat_in[4]);
extern void float_mat2_mult(struct FloatVect2 *vect_out, const float mat[4], const struct FloatVect2 vect_in);
extern _Bool float_mat_inv_3d(float inv_out[3][3], const float mat_in[3][3]);
extern void float_mat3_mult(struct FloatVect3 *vect_out, const float mat[3][3], const struct FloatVect3 vect_in);
extern _Bool float_mat_inv_4d(float invOut[4][4], const float mat_in[4][4]);

extern void float_vect3_bound_in_2d(struct FloatVect3 *vect3, const float bound);
extern void float_vect3_bound_in_3d(struct FloatVect3 *vect3, const float bound);
extern void float_vect3_scale_in_2d(struct FloatVect3 *vect3, const float norm_des);
extern void float_vect2_bound_in_2d(struct FloatVect2 *vect2, const float bound);
extern void float_vect2_scale_in_2d(struct FloatVect2 *vect2, const float norm_des);
# 28 "/home/yangfp/five/_build/paparazzi/expansion-models/float_algebra_more/Program.c" 2
# 38 "/home/yangfp/five/_build/paparazzi/expansion-models/float_algebra_more/Program.c"
void float_rates_integrate_fi(struct FloatRates *r, const struct FloatRates *dr, const float dt)
{
  r->p += dr->p * dt;
  r->q += dr->q * dt;
  r->r += dr->r * dt;
}


void float_rates_vect3_integrate_fi(struct FloatRates *r, const struct FloatVect3 *dr, const float dt)
{
  r->p += dr->x * dt;
  r->q += dr->y * dt;
  r->r += dr->z * dt;
}

void float_rates_of_euler_dot(struct FloatRates *r, const struct FloatEulers *e, const struct FloatEulers *edot)
{
  r->p = edot->phi - sinf(e->theta) * edot->psi;
  r->q = cosf(e->phi) * edot->theta + sinf(e->phi) * cosf(e->theta) * edot->psi;
  r->r = -sinf(e->phi) * edot->theta + cosf(e->phi) * cosf(e->theta) * edot->psi;
}




void float_rmat_inv(struct FloatRMat *m_b2a, const struct FloatRMat *m_a2b)
{
  ((*m_b2a).m[(0)*3+(0)]) = ((*m_a2b).m[(0)*3+(0)]);
  ((*m_b2a).m[(0)*3+(1)]) = ((*m_a2b).m[(1)*3+(0)]);
  ((*m_b2a).m[(0)*3+(2)]) = ((*m_a2b).m[(2)*3+(0)]);
  ((*m_b2a).m[(1)*3+(0)]) = ((*m_a2b).m[(0)*3+(1)]);
  ((*m_b2a).m[(1)*3+(1)]) = ((*m_a2b).m[(1)*3+(1)]);
  ((*m_b2a).m[(1)*3+(2)]) = ((*m_a2b).m[(2)*3+(1)]);
  ((*m_b2a).m[(2)*3+(0)]) = ((*m_a2b).m[(0)*3+(2)]);
  ((*m_b2a).m[(2)*3+(1)]) = ((*m_a2b).m[(1)*3+(2)]);
  ((*m_b2a).m[(2)*3+(2)]) = ((*m_a2b).m[(2)*3+(2)]);
}

float float_rmat_norm(const struct FloatRMat *rm)
{
  return sqrtf(((rm->m[0])*(rm->m[0])) + ((rm->m[1])*(rm->m[1])) + ((rm->m[2])*(rm->m[2])) +
               ((rm->m[3])*(rm->m[3])) + ((rm->m[4])*(rm->m[4])) + ((rm->m[5])*(rm->m[5])) +
               ((rm->m[6])*(rm->m[6])) + ((rm->m[7])*(rm->m[7])) + ((rm->m[8])*(rm->m[8])));
}




void float_rmat_comp(struct FloatRMat *m_a2c, const struct FloatRMat *m_a2b, const struct FloatRMat *m_b2c)
{
  m_a2c->m[0] = m_b2c->m[0] * m_a2b->m[0] + m_b2c->m[1] * m_a2b->m[3] + m_b2c->m[2] * m_a2b->m[6];
  m_a2c->m[1] = m_b2c->m[0] * m_a2b->m[1] + m_b2c->m[1] * m_a2b->m[4] + m_b2c->m[2] * m_a2b->m[7];
  m_a2c->m[2] = m_b2c->m[0] * m_a2b->m[2] + m_b2c->m[1] * m_a2b->m[5] + m_b2c->m[2] * m_a2b->m[8];
  m_a2c->m[3] = m_b2c->m[3] * m_a2b->m[0] + m_b2c->m[4] * m_a2b->m[3] + m_b2c->m[5] * m_a2b->m[6];
  m_a2c->m[4] = m_b2c->m[3] * m_a2b->m[1] + m_b2c->m[4] * m_a2b->m[4] + m_b2c->m[5] * m_a2b->m[7];
  m_a2c->m[5] = m_b2c->m[3] * m_a2b->m[2] + m_b2c->m[4] * m_a2b->m[5] + m_b2c->m[5] * m_a2b->m[8];
  m_a2c->m[6] = m_b2c->m[6] * m_a2b->m[0] + m_b2c->m[7] * m_a2b->m[3] + m_b2c->m[8] * m_a2b->m[6];
  m_a2c->m[7] = m_b2c->m[6] * m_a2b->m[1] + m_b2c->m[7] * m_a2b->m[4] + m_b2c->m[8] * m_a2b->m[7];
  m_a2c->m[8] = m_b2c->m[6] * m_a2b->m[2] + m_b2c->m[7] * m_a2b->m[5] + m_b2c->m[8] * m_a2b->m[8];
}




void float_rmat_comp_inv(struct FloatRMat *m_a2b, const struct FloatRMat *m_a2c, const struct FloatRMat *m_b2c)
{
  m_a2b->m[0] = m_b2c->m[0] * m_a2c->m[0] + m_b2c->m[3] * m_a2c->m[3] + m_b2c->m[6] * m_a2c->m[6];
  m_a2b->m[1] = m_b2c->m[0] * m_a2c->m[1] + m_b2c->m[3] * m_a2c->m[4] + m_b2c->m[6] * m_a2c->m[7];
  m_a2b->m[2] = m_b2c->m[0] * m_a2c->m[2] + m_b2c->m[3] * m_a2c->m[5] + m_b2c->m[6] * m_a2c->m[8];
  m_a2b->m[3] = m_b2c->m[1] * m_a2c->m[0] + m_b2c->m[4] * m_a2c->m[3] + m_b2c->m[7] * m_a2c->m[6];
  m_a2b->m[4] = m_b2c->m[1] * m_a2c->m[1] + m_b2c->m[4] * m_a2c->m[4] + m_b2c->m[7] * m_a2c->m[7];
  m_a2b->m[5] = m_b2c->m[1] * m_a2c->m[2] + m_b2c->m[4] * m_a2c->m[5] + m_b2c->m[7] * m_a2c->m[8];
  m_a2b->m[6] = m_b2c->m[2] * m_a2c->m[0] + m_b2c->m[5] * m_a2c->m[3] + m_b2c->m[8] * m_a2c->m[6];
  m_a2b->m[7] = m_b2c->m[2] * m_a2c->m[1] + m_b2c->m[5] * m_a2c->m[4] + m_b2c->m[8] * m_a2c->m[7];
  m_a2b->m[8] = m_b2c->m[2] * m_a2c->m[2] + m_b2c->m[5] * m_a2c->m[5] + m_b2c->m[8] * m_a2c->m[8];
}
# 128 "/home/yangfp/five/_build/paparazzi/expansion-models/float_algebra_more/Program.c"
void float_rmat_transp_vmult(struct FloatVect3 *vb, const struct FloatRMat *m_b2a, const struct FloatVect3 *va)
{
  vb->x = m_b2a->m[0] * va->x + m_b2a->m[3] * va->y + m_b2a->m[6] * va->z;
  vb->y = m_b2a->m[1] * va->x + m_b2a->m[4] * va->y + m_b2a->m[7] * va->z;
  vb->z = m_b2a->m[2] * va->x + m_b2a->m[5] * va->y + m_b2a->m[8] * va->z;
}




void float_rmat_mult(struct FloatEulers *rb, const struct FloatRMat *m_a2b, const struct FloatEulers *ra)
{
  rb->phi = m_a2b->m[0] * ra->phi + m_a2b->m[1] * ra->theta + m_a2b->m[2] * ra->psi;
  rb->theta = m_a2b->m[3] * ra->phi + m_a2b->m[4] * ra->theta + m_a2b->m[5] * ra->psi;
  rb->psi = m_a2b->m[6] * ra->phi + m_a2b->m[7] * ra->theta + m_a2b->m[8] * ra->psi;
}




void float_rmat_transp_mult(struct FloatEulers *rb, const struct FloatRMat *m_b2a, const struct FloatEulers *ra)
{
  rb->phi = m_b2a->m[0] * ra->phi + m_b2a->m[3] * ra->theta + m_b2a->m[6] * ra->psi;
  rb->theta = m_b2a->m[1] * ra->phi + m_b2a->m[4] * ra->theta + m_b2a->m[7] * ra->psi;
  rb->psi = m_b2a->m[2] * ra->phi + m_b2a->m[5] * ra->theta + m_b2a->m[8] * ra->psi;
}




void float_rmat_ratemult(struct FloatRates *rb, const struct FloatRMat *m_a2b, const struct FloatRates *ra)
{
  rb->p = m_a2b->m[0] * ra->p + m_a2b->m[1] * ra->q + m_a2b->m[2] * ra->r;
  rb->q = m_a2b->m[3] * ra->p + m_a2b->m[4] * ra->q + m_a2b->m[5] * ra->r;
  rb->r = m_a2b->m[6] * ra->p + m_a2b->m[7] * ra->q + m_a2b->m[8] * ra->r;
}




void float_rmat_transp_ratemult(struct FloatRates *rb, const struct FloatRMat *m_b2a, const struct FloatRates *ra)
{
  rb->p = m_b2a->m[0] * ra->p + m_b2a->m[3] * ra->q + m_b2a->m[6] * ra->r;
  rb->q = m_b2a->m[1] * ra->p + m_b2a->m[4] * ra->q + m_b2a->m[7] * ra->r;
  rb->r = m_b2a->m[2] * ra->p + m_b2a->m[5] * ra->q + m_b2a->m[8] * ra->r;
}



void float_rmat_of_axis_angle(struct FloatRMat *rm, const struct FloatVect3 *uv, const float angle)
{
  const float ux2 = uv->x * uv->x;
  const float uy2 = uv->y * uv->y;
  const float uz2 = uv->z * uv->z;
  const float uxuy = uv->x * uv->y;
  const float uyuz = uv->y * uv->z;
  const float uxuz = uv->x * uv->z;
  const float can = cosf(angle);
  const float san = sinf(angle);
  const float one_m_can = (1. - can);

  ((*rm).m[(0)*3+(0)]) = ux2 + (1. - ux2) * can;
  ((*rm).m[(0)*3+(1)]) = uxuy * one_m_can + uv->z * san;
  ((*rm).m[(0)*3+(2)]) = uxuz * one_m_can - uv->y * san;
  ((*rm).m[(1)*3+(0)]) = ((*rm).m[(0)*3+(1)]);
  ((*rm).m[(1)*3+(1)]) = uy2 + (1. - uy2) * can;
  ((*rm).m[(1)*3+(2)]) = uyuz * one_m_can + uv->x * san;
  ((*rm).m[(2)*3+(0)]) = ((*rm).m[(0)*3+(2)]);
  ((*rm).m[(2)*3+(1)]) = ((*rm).m[(1)*3+(2)]);
  ((*rm).m[(2)*3+(2)]) = uz2 + (1. - uz2) * can;
}
# 222 "/home/yangfp/five/_build/paparazzi/expansion-models/float_algebra_more/Program.c"
void float_rmat_of_eulers_312(struct FloatRMat *rm, const struct FloatEulers *e)
{
  const float sphi = sinf(e->phi);
  const float cphi = cosf(e->phi);
  const float stheta = sinf(e->theta);
  const float ctheta = cosf(e->theta);
  const float spsi = sinf(e->psi);
  const float cpsi = cosf(e->psi);

  ((*rm).m[(0)*3+(0)]) = ctheta * cpsi - sphi * stheta * spsi;
  ((*rm).m[(0)*3+(1)]) = ctheta * spsi + sphi * stheta * cpsi;
  ((*rm).m[(0)*3+(2)]) = -cphi * stheta;
  ((*rm).m[(1)*3+(0)]) = -cphi * spsi;
  ((*rm).m[(1)*3+(1)]) = cphi * cpsi;
  ((*rm).m[(1)*3+(2)]) = sphi;
  ((*rm).m[(2)*3+(0)]) = stheta * cpsi + sphi * ctheta * spsi;
  ((*rm).m[(2)*3+(1)]) = stheta * spsi - sphi * ctheta * cpsi;
  ((*rm).m[(2)*3+(2)]) = cphi * ctheta;
}



void float_rmat_of_quat(struct FloatRMat *rm, const struct FloatQuat *q)
{
  const float _a = 1.41421356237309504880 * q->qi;
  const float _b = 1.41421356237309504880 * q->qx;
  const float _c = 1.41421356237309504880 * q->qy;
  const float _d = 1.41421356237309504880 * q->qz;
  const float a2_1 = _a * _a - 1;
  const float ab = _a * _b;
  const float ac = _a * _c;
  const float ad = _a * _d;
  const float bc = _b * _c;
  const float bd = _b * _d;
  const float cd = _c * _d;
  ((*rm).m[(0)*3+(0)]) = a2_1 + _b * _b;
  ((*rm).m[(0)*3+(1)]) = bc + ad;
  ((*rm).m[(0)*3+(2)]) = bd - ac;
  ((*rm).m[(1)*3+(0)]) = bc - ad;
  ((*rm).m[(1)*3+(1)]) = a2_1 + _c * _c;
  ((*rm).m[(1)*3+(2)]) = cd + ab;
  ((*rm).m[(2)*3+(0)]) = bd + ac;
  ((*rm).m[(2)*3+(1)]) = cd - ab;
  ((*rm).m[(2)*3+(2)]) = a2_1 + _d * _d;
}


void float_rmat_integrate_fi(struct FloatRMat *rm, const struct FloatRates *omega, float dt)
{
  struct FloatRMat exp_omega_dt = {
    {
      1., dt *omega->r, -dt *omega->q,
      -dt *omega->r, 1., dt *omega->p,
      dt *omega->q, -dt *omega->p, 1.
    }
  };
  struct FloatRMat R_tdt;
  float_rmat_comp(&R_tdt, rm, &exp_omega_dt);
  memcpy(rm, &R_tdt, sizeof(R_tdt));
}

static inline float renorm_factor(float n)
{
  if (n < 1.5625f && n > 0.64f) {
    return .5 * (3 - n);
  } else if (n < 100.0f && n > 0.01f) {
    return 1. / sqrtf(n);
  } else {
    return 0.;
  }
}
# 328 "/home/yangfp/five/_build/paparazzi/expansion-models/float_algebra_more/Program.c"
void float_quat_comp(struct FloatQuat *a2c, const struct FloatQuat *a2b, const struct FloatQuat *b2c)
{
  a2c->qi = a2b->qi * b2c->qi - a2b->qx * b2c->qx - a2b->qy * b2c->qy - a2b->qz * b2c->qz;
  a2c->qx = a2b->qi * b2c->qx + a2b->qx * b2c->qi + a2b->qy * b2c->qz - a2b->qz * b2c->qy;
  a2c->qy = a2b->qi * b2c->qy - a2b->qx * b2c->qz + a2b->qy * b2c->qi + a2b->qz * b2c->qx;
  a2c->qz = a2b->qi * b2c->qz + a2b->qx * b2c->qy - a2b->qy * b2c->qx + a2b->qz * b2c->qi;
}

void float_quat_comp_inv(struct FloatQuat *a2b, const struct FloatQuat *a2c, const struct FloatQuat *b2c)
{
  a2b->qi = a2c->qi * b2c->qi + a2c->qx * b2c->qx + a2c->qy * b2c->qy + a2c->qz * b2c->qz;
  a2b->qx = -a2c->qi * b2c->qx + a2c->qx * b2c->qi - a2c->qy * b2c->qz + a2c->qz * b2c->qy;
  a2b->qy = -a2c->qi * b2c->qy + a2c->qx * b2c->qz + a2c->qy * b2c->qi - a2c->qz * b2c->qx;
  a2b->qz = -a2c->qi * b2c->qz - a2c->qx * b2c->qy + a2c->qy * b2c->qx + a2c->qz * b2c->qi;
}

void float_quat_inv_comp(struct FloatQuat *b2c, const struct FloatQuat *a2b, const struct FloatQuat *a2c)
{
  b2c->qi = a2b->qi * a2c->qi + a2b->qx * a2c->qx + a2b->qy * a2c->qy + a2b->qz * a2c->qz;
  b2c->qx = a2b->qi * a2c->qx - a2b->qx * a2c->qi - a2b->qy * a2c->qz + a2b->qz * a2c->qy;
  b2c->qy = a2b->qi * a2c->qy + a2b->qx * a2c->qz - a2b->qy * a2c->qi - a2b->qz * a2c->qx;
  b2c->qz = a2b->qi * a2c->qz - a2b->qx * a2c->qy + a2b->qy * a2c->qx - a2b->qz * a2c->qi;
}

void float_quat_comp_norm_shortest(struct FloatQuat *a2c, const struct FloatQuat *a2b, const struct FloatQuat *b2c)
{
  float_quat_comp(a2c, a2b, b2c);
  float_quat_wrap_shortest(a2c);
  float_quat_normalize(a2c);
}

void float_quat_comp_inv_norm_shortest(struct FloatQuat *a2b, const struct FloatQuat *a2c, const struct FloatQuat *b2c)
{
  float_quat_comp_inv(a2b, a2c, b2c);
  float_quat_wrap_shortest(a2b);
  float_quat_normalize(a2b);
}

void float_quat_inv_comp_norm_shortest(struct FloatQuat *b2c, const struct FloatQuat *a2b, const struct FloatQuat *a2c)
{
  float_quat_inv_comp(b2c, a2b, a2c);
  float_quat_wrap_shortest(b2c);
  float_quat_normalize(b2c);
}

void float_quat_differential(struct FloatQuat *q_out, const struct FloatRates *w, const float dt)
{
  const float v_norm = sqrtf(w->p * w->p + w->q * w->q + w->r * w->r);
  const float c2 = cos(dt * v_norm / 2.0);
  const float s2 = sin(dt * v_norm / 2.0);
  if (v_norm < 1e-8) {
    q_out->qi = 1;
    q_out->qx = 0;
    q_out->qy = 0;
    q_out->qz = 0;
  } else {
    q_out->qi = c2;
    q_out->qx = w->p / v_norm * s2;
    q_out->qy = w->q / v_norm * s2;
    q_out->qz = w->r / v_norm * s2;
  }
}


void float_quat_integrate_fi(struct FloatQuat *q, const struct FloatRates *omega, const float dt)
{
  const float qi = q->qi;
  const float qx = q->qx;
  const float qy = q->qy;
  const float qz = q->qz;
  const float dp = 0.5 * dt * omega->p;
  const float dq = 0.5 * dt * omega->q;
  const float dr = 0.5 * dt * omega->r;
  q->qi = qi - dp * qx - dq * qy - dr * qz;
  q->qx = dp * qi + qx + dr * qy - dq * qz;
  q->qy = dq * qi - dr * qx + qy + dp * qz;
  q->qz = dr * qi + dq * qx - dp * qy + qz;
}


void float_quat_integrate(struct FloatQuat *q, const struct FloatRates *omega, const float dt)
{
  const float no = (sqrtf((*omega).p*(*omega).p + (*omega).q*(*omega).q + (*omega).r*(*omega).r));
  if (no > 0x1p-126F) {
    const float a = 0.5 * no * dt;
    const float ca = cosf(a);
    const float sa_ov_no = sinf(a) / no;
    const float dp = sa_ov_no * omega->p;
    const float dq = sa_ov_no * omega->q;
    const float dr = sa_ov_no * omega->r;
    const float qi = q->qi;
    const float qx = q->qx;
    const float qy = q->qy;
    const float qz = q->qz;
    q->qi = ca * qi - dp * qx - dq * qy - dr * qz;
    q->qx = dp * qi + ca * qx + dr * qy - dq * qz;
    q->qy = dq * qi - dr * qx + ca * qy + dp * qz;
    q->qz = dr * qi + dq * qx - dp * qy + ca * qz;
  }
}

void float_quat_vmult(struct FloatVect3 *v_out, const struct FloatQuat *q, const struct FloatVect3 *v_in)
{
  const float qi2_M1_2 = q->qi * q->qi - 0.5;
  const float qiqx = q->qi * q->qx;
  const float qiqy = q->qi * q->qy;
  const float qiqz = q->qi * q->qz;
  float m01 = q->qx * q->qy;
  float m02 = q->qx * q->qz;
  float m12 = q->qy * q->qz;

  const float m00 = qi2_M1_2 + q->qx * q->qx;
  const float m10 = m01 - qiqz;
  const float m20 = m02 + qiqy;
  const float m21 = m12 - qiqx;
  m01 += qiqz;
  m02 -= qiqy;
  m12 += qiqx;
  const float m11 = qi2_M1_2 + q->qy * q->qy;
  const float m22 = qi2_M1_2 + q->qz * q->qz;
  v_out->x = 2 * (m00 * v_in->x + m01 * v_in->y + m02 * v_in->z);
  v_out->y = 2 * (m10 * v_in->x + m11 * v_in->y + m12 * v_in->z);
  v_out->z = 2 * (m20 * v_in->x + m21 * v_in->y + m22 * v_in->z);
}






void float_quat_derivative(struct FloatQuat *qd, const struct FloatRates *r, const struct FloatQuat *q)
{
  qd->qi = -0.5 * (r->p * q->qx + r->q * q->qy + r->r * q->qz);
  qd->qx = -0.5 * (-r->p * q->qi - r->r * q->qy + r->q * q->qz);
  qd->qy = -0.5 * (-r->q * q->qi + r->r * q->qx - r->p * q->qz);
  qd->qz = -0.5 * (-r->r * q->qi - r->q * q->qx + r->p * q->qy);
}




void float_quat_derivative_lagrange(struct FloatQuat *qd, const struct FloatRates *r, const struct FloatQuat *q)
{
  const float K_LAGRANGE = 1.;
  const float c = K_LAGRANGE * (1 - float_quat_norm(q)) / -0.5;
  qd->qi = -0.5 * (c * q->qi + r->p * q->qx + r->q * q->qy + r->r * q->qz);
  qd->qx = -0.5 * (-r->p * q->qi + c * q->qx - r->r * q->qy + r->q * q->qz);
  qd->qy = -0.5 * (-r->q * q->qi + r->r * q->qx + c * q->qy - r->p * q->qz);
  qd->qz = -0.5 * (-r->r * q->qi - r->q * q->qx + r->p * q->qy + c * q->qz);
}







void float_quat_of_eulers(struct FloatQuat *q, const struct FloatEulers *e)
{

  const float phi2 = e->phi / 2.f;
  const float theta2 = e->theta / 2.f;
  const float psi2 = e->psi / 2.f;

  const float s_phi2 = sinf(phi2);
  const float c_phi2 = cosf(phi2);
  const float s_theta2 = sinf(theta2);
  const float c_theta2 = cosf(theta2);
  const float s_psi2 = sinf(psi2);
  const float c_psi2 = cosf(psi2);

  q->qi = c_phi2 * c_theta2 * c_psi2 + s_phi2 * s_theta2 * s_psi2;
  q->qx = -c_phi2 * s_theta2 * s_psi2 + s_phi2 * c_theta2 * c_psi2;
  q->qy = c_phi2 * s_theta2 * c_psi2 + s_phi2 * c_theta2 * s_psi2;
  q->qz = c_phi2 * c_theta2 * s_psi2 - s_phi2 * s_theta2 * c_psi2;
}
# 512 "/home/yangfp/five/_build/paparazzi/expansion-models/float_algebra_more/Program.c"
void float_quat_of_eulers_zxy(struct FloatQuat *q, const struct FloatEulers *e)
{
  const float phi2 = e->phi / 2.f;
  const float theta2 = e->theta / 2.f;
  const float psi2 = e->psi / 2.f;

  const float s_phi2 = sinf(phi2);
  const float c_phi2 = cosf(phi2);
  const float s_theta2 = sinf(theta2);
  const float c_theta2 = cosf(theta2);
  const float s_psi2 = sinf(psi2);
  const float c_psi2 = cosf(psi2);

  q->qi = c_phi2 * c_theta2 * c_psi2 - s_phi2 * s_theta2 * s_psi2;
  q->qx = s_phi2 * c_theta2 * c_psi2 - c_phi2 * s_theta2 * s_psi2;
  q->qy = c_phi2 * s_theta2 * c_psi2 + s_phi2 * c_theta2 * s_psi2;
  q->qz = s_phi2 * s_theta2 * c_psi2 + c_phi2 * c_theta2 * s_psi2;
}
# 540 "/home/yangfp/five/_build/paparazzi/expansion-models/float_algebra_more/Program.c"
void float_quat_of_eulers_yxz(struct FloatQuat *q, const struct FloatEulers *e)
{
  const float phi2 = e->phi / 2.f;
  const float theta2 = e->theta / 2.f;
  const float psi2 = e->psi / 2.f;

  const float s_phi2 = sinf(phi2);
  const float c_phi2 = cosf(phi2);
  const float s_theta2 = sinf(theta2);
  const float c_theta2 = cosf(theta2);
  const float s_psi2 = sinf(psi2);
  const float c_psi2 = cosf(psi2);

  q->qi = c_theta2 * c_phi2 * c_psi2 + s_theta2 * s_phi2 * s_psi2;
  q->qx = c_theta2 * s_phi2 * c_psi2 + s_theta2 * c_phi2 * s_psi2;
  q->qy = s_theta2 * c_phi2 * c_psi2 - c_theta2 * s_phi2 * s_psi2;
  q->qz = c_theta2 * c_phi2 * s_psi2 - s_theta2 * s_phi2 * c_psi2;
}

void float_quat_of_axis_angle(struct FloatQuat *q, const struct FloatVect3 *uv, const float angle)
{
  const float san = sinf(angle / 2.f);
  q->qi = cosf(angle / 2.f);
  q->qx = san * uv->x;
  q->qy = san * uv->y;
  q->qz = san * uv->z;
}

void float_quat_of_orientation_vect(struct FloatQuat *q, const struct FloatVect3 *ov)
{
  const float ov_norm = sqrtf(ov->x * ov->x + ov->y * ov->y + ov->z * ov->z);
  if (ov_norm < 1e-8) {
    q->qi = 1;
    q->qx = 0;
    q->qy = 0;
    q->qz = 0;
  } else {
    const float s2_normalized = sinf(ov_norm / 2.0) / ov_norm;
    q->qi = cosf(ov_norm / 2.0);
    q->qx = ov->x * s2_normalized;
    q->qy = ov->y * s2_normalized;
    q->qz = ov->z * s2_normalized;
  }
}

void float_quat_of_rmat(struct FloatQuat *q, const struct FloatRMat *rm)
{
  const float tr = (((*rm).m[(0)*3+(0)])+((*rm).m[(1)*3+(1)])+((*rm).m[(2)*3+(2)]));
  if (tr > 0) {
    const float two_qi = sqrtf(1. + tr);
    const float four_qi = 2. * two_qi;
    q->qi = 0.5 * two_qi;
    q->qx = (((*rm).m[(1)*3+(2)]) - ((*rm).m[(2)*3+(1)])) / four_qi;
    q->qy = (((*rm).m[(2)*3+(0)]) - ((*rm).m[(0)*3+(2)])) / four_qi;
    q->qz = (((*rm).m[(0)*3+(1)]) - ((*rm).m[(1)*3+(0)])) / four_qi;

  } else {
    if (((*rm).m[(0)*3+(0)]) > ((*rm).m[(1)*3+(1)]) &&
        ((*rm).m[(0)*3+(0)]) > ((*rm).m[(2)*3+(2)])) {
      const float two_qx = sqrtf(((*rm).m[(0)*3+(0)]) - ((*rm).m[(1)*3+(1)])
                                 - ((*rm).m[(2)*3+(2)]) + 1);
      const float four_qx = 2. * two_qx;
      q->qi = (((*rm).m[(1)*3+(2)]) - ((*rm).m[(2)*3+(1)])) / four_qx;
      q->qx = 0.5 * two_qx;
      q->qy = (((*rm).m[(0)*3+(1)]) + ((*rm).m[(1)*3+(0)])) / four_qx;
      q->qz = (((*rm).m[(2)*3+(0)]) + ((*rm).m[(0)*3+(2)])) / four_qx;

    } else if (((*rm).m[(1)*3+(1)]) > ((*rm).m[(2)*3+(2)])) {
      const float two_qy =
        sqrtf(((*rm).m[(1)*3+(1)]) - ((*rm).m[(0)*3+(0)]) - ((*rm).m[(2)*3+(2)]) + 1);
      const float four_qy = 2. * two_qy;
      q->qi = (((*rm).m[(2)*3+(0)]) - ((*rm).m[(0)*3+(2)])) / four_qy;
      q->qx = (((*rm).m[(0)*3+(1)]) + ((*rm).m[(1)*3+(0)])) / four_qy;
      q->qy = 0.5 * two_qy;
      q->qz = (((*rm).m[(1)*3+(2)]) + ((*rm).m[(2)*3+(1)])) / four_qy;

    } else {
      const float two_qz =
        sqrtf(((*rm).m[(2)*3+(2)]) - ((*rm).m[(0)*3+(0)]) - ((*rm).m[(1)*3+(1)]) + 1);
      const float four_qz = 2. * two_qz;
      q->qi = (((*rm).m[(0)*3+(1)]) - ((*rm).m[(1)*3+(0)])) / four_qz;
      q->qx = (((*rm).m[(2)*3+(0)]) + ((*rm).m[(0)*3+(2)])) / four_qz;
      q->qy = (((*rm).m[(1)*3+(2)]) + ((*rm).m[(2)*3+(1)])) / four_qz;
      q->qz = 0.5 * two_qz;

    }
  }
}
# 642 "/home/yangfp/five/_build/paparazzi/expansion-models/float_algebra_more/Program.c"
void float_quat_tilt_twist(struct FloatQuat *tilt, struct FloatQuat *twist, const struct FloatQuat *quat)
{
  struct FloatVect3 z = {0., 0., 1.};
  struct FloatVect3 z_rot;


  struct FloatQuat qinv;
  float_quat_invert(&qinv, quat);
  float_quat_vmult(&z_rot, &qinv, &z);


  struct FloatVect3 axis;
  { (axis).x = (z).y*(z_rot).z - (z).z*(z_rot).y; (axis).y = (z).z*(z_rot).x - (z).x*(z_rot).z; (axis).z = (z).x*(z_rot).y - (z).y*(z_rot).x; };

  tilt->qi = 1 + z_rot.z;
  tilt->qx = axis.x;
  tilt->qy = axis.y;
  tilt->qz = axis.z;

  float_quat_normalize(tilt);


  float_quat_inv_comp_norm_shortest(twist, tilt, quat);
}
# 674 "/home/yangfp/five/_build/paparazzi/expansion-models/float_algebra_more/Program.c"
void float_eulers_of_rmat(struct FloatEulers *e, const struct FloatRMat *rm)
{
  const float dcm00 = rm->m[0];
  const float dcm01 = rm->m[1];
  float dcm02 = rm->m[2];
  const float dcm12 = rm->m[5];
  const float dcm22 = rm->m[8];


  { if (!(dcm02 > (-(1.0)))) dcm02 = (-(1.0)); else if (!(dcm02 < ((1.0)))) dcm02 = ((1.0)); };

  e->phi = atan2f(dcm12, dcm22);
  e->theta = -asinf(dcm02);
  e->psi = atan2f(dcm01, dcm00);
}
# 730 "/home/yangfp/five/_build/paparazzi/expansion-models/float_algebra_more/Program.c"
void float_eulers_of_quat_yxz(struct FloatEulers *e, const struct FloatQuat *q)
{
  const float qx2 = q->qx * q->qx;
  const float qy2 = q->qy * q->qy;
  const float qz2 = q->qz * q->qz;
  const float qi2 = q->qi * q->qi;
  const float qiqx = q->qi * q->qx;
  const float qiqy = q->qi * q->qy;
  const float qiqz = q->qi * q->qz;
  const float qxqy = q->qx * q->qy;
  const float qxqz = q->qx * q->qz;
  const float qyqz = q->qy * q->qz;
  const float r11 = 2.f * (qxqz + qiqy);
  const float r12 = qi2 - qx2 + qy2 + qz2;
  float r21 = -2.f * (qyqz - qiqx);
  const float r31 = 2.f * (qxqy + qiqz);
  const float r32 = qi2 - qx2 + qy2 - qz2;


  { if (!(r21 > (-(1.0)))) r21 = (-(1.0)); else if (!(r21 < ((1.0)))) r21 = ((1.0)); };

  e->theta = atan2f(r11, r12);
  e->phi = asinf(r21);
  e->psi = atan2f(r31, r32);
}
# 763 "/home/yangfp/five/_build/paparazzi/expansion-models/float_algebra_more/Program.c"
void float_eulers_of_quat_zxy(struct FloatEulers *e, const struct FloatQuat *q)
{
  const float qx2 = q->qx * q->qx;
  const float qy2 = q->qy * q->qy;
  const float qz2 = q->qz * q->qz;
  const float qi2 = q->qi * q->qi;
  const float qiqx = q->qi * q->qx;
  const float qiqy = q->qi * q->qy;
  const float qiqz = q->qi * q->qz;
  const float qxqy = q->qx * q->qy;
  const float qxqz = q->qx * q->qz;
  const float qyqz = q->qy * q->qz;
  const float r11 = -2 * (qxqy - qiqz);
  const float r12 = qi2 - qx2 + qy2 - qz2;
  float r21 = 2 * (qyqz + qiqx);
  const float r31 = -2 * (qxqz - qiqy);
  const float r32 = qi2 - qx2 - qy2 + qz2;


  { if (!(r21 > (-(1.0)))) r21 = (-(1.0)); else if (!(r21 < ((1.0)))) r21 = ((1.0)); };

  e->psi = atan2f(r11, r12);
  e->phi = asinf(r21);
  e->theta = atan2f(r31, r32);
}
# 818 "/home/yangfp/five/_build/paparazzi/expansion-models/float_algebra_more/Program.c"
void float_mat2_mult(struct FloatVect2 *vect_out, const float mat[4], const struct FloatVect2 vect_in)
{
  vect_out->x = mat[0] * vect_in.x + mat[1] * vect_in.y;
  vect_out->y = mat[2] * vect_in.x + mat[3] * vect_in.y;
}
# 866 "/home/yangfp/five/_build/paparazzi/expansion-models/float_algebra_more/Program.c"
void float_mat3_mult(struct FloatVect3 *vect_out, const float mat[3][3], const struct FloatVect3 vect_in)
{
  vect_out->x = mat[0][0] * vect_in.x + mat[0][1] * vect_in.y + mat[0][2] * vect_in.z;
  vect_out->y = mat[1][0] * vect_in.x + mat[1][1] * vect_in.y + mat[1][2] * vect_in.z;
  vect_out->z = mat[2][0] * vect_in.x + mat[2][1] * vect_in.y + mat[2][2] * vect_in.z;
}






static float float_mat_minor_4d(const float m[4][4], int r0, int r1, int r2, int c0, int c1, int c2)
{
  return m[r0][c0] * (m[r1][c1] * m[r2][c2] - m[r2][c1] * m[r1][c2]) -
         m[r0][c1] * (m[r1][c0] * m[r2][c2] - m[r2][c0] * m[r1][c2]) +
         m[r0][c2] * (m[r1][c0] * m[r2][c1] - m[r2][c0] * m[r1][c1]);
}


static void float_mat_adjoint_4d(float adjOut[4][4], const float m[4][4])
{
  adjOut[0][0] = float_mat_minor_4d(m, 1, 2, 3, 1, 2, 3);
  adjOut[0][1] = -float_mat_minor_4d(m, 0, 2, 3, 1, 2, 3);
  adjOut[0][2] = float_mat_minor_4d(m, 0, 1, 3, 1, 2, 3);
  adjOut[0][3] = -float_mat_minor_4d(m, 0, 1, 2, 1, 2, 3);
  adjOut[1][0] = -float_mat_minor_4d(m, 1, 2, 3, 0, 2, 3);
  adjOut[1][1] = float_mat_minor_4d(m, 0, 2, 3, 0, 2, 3);
  adjOut[1][2] = -float_mat_minor_4d(m, 0, 1, 3, 0, 2, 3);
  adjOut[1][3] = float_mat_minor_4d(m, 0, 1, 2, 0, 2, 3);
  adjOut[2][0] = float_mat_minor_4d(m, 1, 2, 3, 0, 1, 3);
  adjOut[2][1] = -float_mat_minor_4d(m, 0, 2, 3, 0, 1, 3);
  adjOut[2][2] = float_mat_minor_4d(m, 0, 1, 3, 0, 1, 3);
  adjOut[2][3] = -float_mat_minor_4d(m, 0, 1, 2, 0, 1, 3);
  adjOut[3][0] = -float_mat_minor_4d(m, 1, 2, 3, 0, 1, 2);
  adjOut[3][1] = float_mat_minor_4d(m, 0, 2, 3, 0, 1, 2);
  adjOut[3][2] = -float_mat_minor_4d(m, 0, 1, 3, 0, 1, 2);
  adjOut[3][3] = float_mat_minor_4d(m, 0, 1, 2, 0, 1, 2);
}

static float float_mat_det_4d(const float m[4][4])
{
  return m[0][0] * float_mat_minor_4d(m, 1, 2, 3, 1, 2, 3) -
         m[0][1] * float_mat_minor_4d(m, 1, 2, 3, 0, 2, 3) +
         m[0][2] * float_mat_minor_4d(m, 1, 2, 3, 0, 1, 3) -
         m[0][3] * float_mat_minor_4d(m, 1, 2, 3, 0, 1, 2);
}







_Bool float_mat_inv_4d(float invOut[4][4], const float mat_in[4][4])
{
  float_mat_adjoint_4d(invOut, mat_in);

  float det = float_mat_det_4d(mat_in);
  if (fabsf(det) < 1e-4) { return 1; }

  float inv_det = 1.0f / det;
  int i;
  for (i = 0; i < 4; ++i) {
    invOut[0][i] = invOut[0][i] * inv_det;
    invOut[1][i] = invOut[1][i] * inv_det;
    invOut[2][i] = invOut[2][i] * inv_det;
    invOut[3][i] = invOut[3][i] * inv_det;
  }

  return 0;
}
# 1074 "/home/yangfp/five/_build/paparazzi/expansion-models/float_algebra_more/Program.c"
void float_vect3_bound_in_2d(struct FloatVect3 *vect3, const float bound)
{
  float norm = sqrtf(((*vect3).x*(*vect3).x + (*vect3).y*(*vect3).y));
  if (norm > bound) {
    float scale = bound / norm;
    vect3->x *= scale;
    vect3->y *= scale;
  }
}


void float_vect3_bound_in_3d(struct FloatVect3 *vect3, const float bound)
{
  float norm = sqrtf(((*vect3).x*(*vect3).x + (*vect3).y*(*vect3).y + (*vect3).z*(*vect3).z));
  if (norm > bound) {
    float scale = bound / norm;
    vect3->x *= scale;
    vect3->y *= scale;
    vect3->z *= scale;
  }
}


void float_vect3_scale_in_2d(struct FloatVect3 *vect3, const float norm_des)
{
  float norm = sqrtf(((*vect3).x*(*vect3).x + (*vect3).y*(*vect3).y));
  if (norm > 0.01f) {
    float scale = norm_des / norm;
    vect3->x *= scale;
    vect3->y *= scale;
  }
}


void float_vect2_bound_in_2d(struct FloatVect2 *vect2, const float bound)
{
  float norm = sqrtf(((*vect2).x*(*vect2).x + (*vect2).y*(*vect2).y));
  if (norm > bound) {
    float scale = bound / norm;
    vect2->x *= scale;
    vect2->y *= scale;
  }
}


void float_vect2_scale_in_2d(struct FloatVect2 *vect2, const float norm_des)
{
  float norm = sqrtf(((*vect2).x*(*vect2).x + (*vect2).y*(*vect2).y));
  if (norm > 0.01f) {
    float scale = norm_des / norm;
    vect2->x *= scale;
    vect2->y *= scale;
  }
}

void (*five_keep_float_rates_integrate_fi)(void) = (void (*)(void))float_rates_integrate_fi;
void (*five_keep_float_rates_vect3_integrate_fi)(void) = (void (*)(void))float_rates_vect3_integrate_fi;
void (*five_keep_float_rates_of_euler_dot)(void) = (void (*)(void))float_rates_of_euler_dot;
void (*five_keep_float_rmat_inv)(void) = (void (*)(void))float_rmat_inv;
void (*five_keep_float_rmat_norm)(void) = (void (*)(void))float_rmat_norm;
void (*five_keep_float_rmat_comp_inv)(void) = (void (*)(void))float_rmat_comp_inv;
void (*five_keep_float_rmat_transp_vmult)(void) = (void (*)(void))float_rmat_transp_vmult;
void (*five_keep_float_rmat_mult)(void) = (void (*)(void))float_rmat_mult;
void (*five_keep_float_rmat_transp_mult)(void) = (void (*)(void))float_rmat_transp_mult;
void (*five_keep_float_rmat_ratemult)(void) = (void (*)(void))float_rmat_ratemult;
void (*five_keep_float_rmat_transp_ratemult)(void) = (void (*)(void))float_rmat_transp_ratemult;
void (*five_keep_float_rmat_of_axis_angle)(void) = (void (*)(void))float_rmat_of_axis_angle;
void (*five_keep_float_rmat_of_eulers_312)(void) = (void (*)(void))float_rmat_of_eulers_312;
void (*five_keep_float_rmat_of_quat)(void) = (void (*)(void))float_rmat_of_quat;
void (*five_keep_float_rmat_integrate_fi)(void) = (void (*)(void))float_rmat_integrate_fi;
void (*five_keep_renorm_factor)(void) = (void (*)(void))renorm_factor;
void (*five_keep_float_quat_comp_inv)(void) = (void (*)(void))float_quat_comp_inv;
void (*five_keep_float_quat_inv_comp)(void) = (void (*)(void))float_quat_inv_comp;
void (*five_keep_float_quat_comp_norm_shortest)(void) = (void (*)(void))float_quat_comp_norm_shortest;
void (*five_keep_float_quat_comp_inv_norm_shortest)(void) = (void (*)(void))float_quat_comp_inv_norm_shortest;
void (*five_keep_float_quat_inv_comp_norm_shortest)(void) = (void (*)(void))float_quat_inv_comp_norm_shortest;
void (*five_keep_float_quat_differential)(void) = (void (*)(void))float_quat_differential;
void (*five_keep_float_quat_integrate_fi)(void) = (void (*)(void))float_quat_integrate_fi;
void (*five_keep_float_quat_integrate)(void) = (void (*)(void))float_quat_integrate;
void (*five_keep_float_quat_derivative)(void) = (void (*)(void))float_quat_derivative;
void (*five_keep_float_quat_derivative_lagrange)(void) = (void (*)(void))float_quat_derivative_lagrange;
void (*five_keep_float_quat_of_eulers)(void) = (void (*)(void))float_quat_of_eulers;
void (*five_keep_float_quat_of_eulers_zxy)(void) = (void (*)(void))float_quat_of_eulers_zxy;
void (*five_keep_float_quat_of_eulers_yxz)(void) = (void (*)(void))float_quat_of_eulers_yxz;
void (*five_keep_float_quat_of_axis_angle)(void) = (void (*)(void))float_quat_of_axis_angle;
void (*five_keep_float_quat_of_orientation_vect)(void) = (void (*)(void))float_quat_of_orientation_vect;
void (*five_keep_float_quat_of_rmat)(void) = (void (*)(void))float_quat_of_rmat;
void (*five_keep_float_quat_tilt_twist)(void) = (void (*)(void))float_quat_tilt_twist;
void (*five_keep_float_eulers_of_rmat)(void) = (void (*)(void))float_eulers_of_rmat;
void (*five_keep_float_eulers_of_quat_yxz)(void) = (void (*)(void))float_eulers_of_quat_yxz;
void (*five_keep_float_eulers_of_quat_zxy)(void) = (void (*)(void))float_eulers_of_quat_zxy;
void (*five_keep_float_mat2_mult)(void) = (void (*)(void))float_mat2_mult;
void (*five_keep_float_mat3_mult)(void) = (void (*)(void))float_mat3_mult;
void (*five_keep_float_mat_minor_4d)(void) = (void (*)(void))float_mat_minor_4d;
void (*five_keep_float_mat_adjoint_4d)(void) = (void (*)(void))float_mat_adjoint_4d;
void (*five_keep_float_mat_det_4d)(void) = (void (*)(void))float_mat_det_4d;
void (*five_keep_float_mat_inv_4d)(void) = (void (*)(void))float_mat_inv_4d;
void (*five_keep_float_vect3_bound_in_2d)(void) = (void (*)(void))float_vect3_bound_in_2d;
void (*five_keep_float_vect3_bound_in_3d)(void) = (void (*)(void))float_vect3_bound_in_3d;
void (*five_keep_float_vect3_scale_in_2d)(void) = (void (*)(void))float_vect3_scale_in_2d;
void (*five_keep_float_vect2_bound_in_2d)(void) = (void (*)(void))float_vect2_bound_in_2d;
void (*five_keep_float_vect2_scale_in_2d)(void) = (void (*)(void))float_vect2_scale_in_2d;
