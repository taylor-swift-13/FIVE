# 0 "/home/yangfp/five/_build/paparazzi/expansion-models/double_geodetic/Program.c"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "/usr/include/stdc-predef.h" 1 3 4
# 0 "<command-line>" 2
# 1 "/home/yangfp/five/_build/paparazzi/expansion-models/double_geodetic/Program.c"
# 28 "/home/yangfp/five/_build/paparazzi/expansion-models/double_geodetic/Program.c"
# 1 "/home/yangfp/five/_build/paparazzi/overlay/math/pprz_geodetic_double.h" 1
# 39 "/home/yangfp/five/_build/paparazzi/overlay/math/pprz_geodetic_double.h"
# 1 "/home/yangfp/five/_build/paparazzi/overlay/math/pprz_geodetic.h" 1
# 40 "/home/yangfp/five/_build/paparazzi/overlay/math/pprz_geodetic_double.h" 2
# 1 "/home/yangfp/five/_build/paparazzi/overlay/math/pprz_algebra_double.h" 1
# 38 "/home/yangfp/five/_build/paparazzi/overlay/math/pprz_algebra_double.h"
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
# 39 "/home/yangfp/five/_build/paparazzi/overlay/math/pprz_algebra_double.h" 2
# 1 "/home/yangfp/five/_build/paparazzi/overlay/math/pprz_algebra_float.h" 1
# 39 "/home/yangfp/five/_build/paparazzi/overlay/math/pprz_algebra_float.h"
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
# 40 "/home/yangfp/five/_build/paparazzi/overlay/math/pprz_algebra_double.h" 2

struct DoubleVect2 {
  double x;
  double y;
};

struct DoubleVect3 {
  double x;
  double y;
  double z;
};




struct DoubleQuat {
  double qi;
  double qx;
  double qy;
  double qz;
};

struct DoubleMat33 {
  double m[3 * 3];
};




struct DoubleRMat {
  double m[3 * 3];
};




struct DoubleEulers {
  double phi;
  double theta;
  double psi;
};




struct DoubleRates {
  double p;
  double q;
  double r;
};
# 100 "/home/yangfp/five/_build/paparazzi/overlay/math/pprz_algebra_double.h"
static inline double double_vect3_norm(struct DoubleVect3 *v)
{
  return sqrt(((*v).x*(*v).x + (*v).y*(*v).y + (*v).z*(*v).z));
}


static inline void double_vect3_normalize(struct DoubleVect3 *v)
{
  const double n = double_vect3_norm(v);
  if (n > 0) {
    v->x /= n;
    v->y /= n;
    v->z /= n;
  }
}



static inline void double_quat_identity(struct DoubleQuat *q)
{
  q->qi = 1.0;
  q->qx = 0;
  q->qy = 0;
  q->qz = 0;
}

static inline double double_quat_norm(struct DoubleQuat *q)
{
  return sqrt(((q->qi)*(q->qi)) + ((q->qx)*(q->qx)) + ((q->qy)*(q->qy)) + ((q->qz)*(q->qz)));
}


static inline void double_quat_normalize(struct DoubleQuat *q)
{
  double qnorm = double_quat_norm(q);
  if (qnorm > 0x1p-126F) {
    q->qi = q->qi / qnorm;
    q->qx = q->qx / qnorm;
    q->qy = q->qy / qnorm;
    q->qz = q->qz / qnorm;
  }
}
# 155 "/home/yangfp/five/_build/paparazzi/overlay/math/pprz_algebra_double.h"
extern void double_rmat_of_eulers_321(struct DoubleRMat *rm, struct DoubleEulers *e);
extern void double_quat_of_eulers(struct DoubleQuat *q, struct DoubleEulers *e);
extern void double_eulers_of_quat(struct DoubleEulers *e, struct DoubleQuat *q);
extern void double_quat_vmult(struct DoubleVect3 *v_out, struct DoubleQuat *q, struct DoubleVect3 *v_in);




extern void double_quat_comp(struct DoubleQuat *a2c, struct DoubleQuat *a2b, struct DoubleQuat *b2c);


static inline void double_rmat_identity(struct DoubleRMat *rm)
{
  { ((*rm).m[(0)*3+(0)]) = 1.; ((*rm).m[(0)*3+(1)]) = 0.; ((*rm).m[(0)*3+(2)]) = 0.; ((*rm).m[(1)*3+(0)]) = 0.; ((*rm).m[(1)*3+(1)]) = 1.; ((*rm).m[(1)*3+(2)]) = 0.; ((*rm).m[(2)*3+(0)]) = 0.; ((*rm).m[(2)*3+(1)]) = 0.; ((*rm).m[(2)*3+(2)]) = 1.; };
}




extern void double_rmat_inv(struct DoubleRMat *m_b2a, struct DoubleRMat *m_a2b);




extern void double_rmat_comp(struct DoubleRMat *m_a2c, struct DoubleRMat *m_a2b,
                             struct DoubleRMat *m_b2c);




extern void double_rmat_vmult(struct DoubleVect3 *vb, struct DoubleRMat *m_a2b,
                              struct DoubleVect3 *va);




extern void double_rmat_transp_vmult(struct DoubleVect3 *vb, struct DoubleRMat *m_b2a,
                                     struct DoubleVect3 *va);

extern void double_rmat_of_quat(struct DoubleRMat *rm, struct DoubleQuat *q);
static inline void double_rmat_of_eulers(struct DoubleRMat *rm, struct DoubleEulers *e)
{
  double_rmat_of_eulers_321(rm, e);
}
# 41 "/home/yangfp/five/_build/paparazzi/overlay/math/pprz_geodetic_double.h" 2
# 49 "/home/yangfp/five/_build/paparazzi/overlay/math/pprz_geodetic_double.h"
struct EcefCoor_d {
  double x;
  double y;
  double z;
};




struct LlaCoor_d {
  double lat;
  double lon;
  double alt;
};




struct NedCoor_d {
  double x;
  double y;
  double z;
};




struct EnuCoor_d {
  double x;
  double y;
  double z;
};




struct UtmCoor_d {
  double north;
  double east;
  double alt;
  uint8_t zone;
};






struct LtpDef_d {
  struct EcefCoor_d ecef;
  struct LlaCoor_d lla;
  struct DoubleRMat ltp_of_ecef;
  double hmsl;
};

extern void lla_of_utm_d(struct LlaCoor_d *lla, struct UtmCoor_d *utm);
extern void utm_of_lla_d(struct UtmCoor_d *utm, struct LlaCoor_d *lla);
extern void ltp_def_from_ecef_d(struct LtpDef_d *def, struct EcefCoor_d *ecef);
extern void ltp_def_from_lla_d(struct LtpDef_d *def, struct LlaCoor_d *lla);
extern void lla_of_ecef_d(struct LlaCoor_d *out, struct EcefCoor_d *in);
extern void ecef_of_lla_d(struct EcefCoor_d *out, struct LlaCoor_d *in);

extern void enu_of_ecef_point_d(struct EnuCoor_d *ned, struct LtpDef_d *def, struct EcefCoor_d *ecef);
extern void ned_of_ecef_point_d(struct NedCoor_d *ned, struct LtpDef_d *def, struct EcefCoor_d *ecef);

extern void enu_of_ecef_vect_d(struct EnuCoor_d *ned, struct LtpDef_d *def, struct EcefCoor_d *ecef);
extern void ned_of_ecef_vect_d(struct NedCoor_d *ned, struct LtpDef_d *def, struct EcefCoor_d *ecef);

extern void ecef_of_enu_point_d(struct EcefCoor_d *ecef, struct LtpDef_d *def, struct EnuCoor_d *enu);
extern void ecef_of_ned_point_d(struct EcefCoor_d *ecef, struct LtpDef_d *def, struct NedCoor_d *ned);

extern void ecef_of_enu_vect_d(struct EcefCoor_d *ecef, struct LtpDef_d *def, struct EnuCoor_d *enu);
extern void ecef_of_ned_vect_d(struct EcefCoor_d *ecef, struct LtpDef_d *def, struct NedCoor_d *ned);

extern void enu_of_lla_point_d(struct EnuCoor_d *enu, struct LtpDef_d *def, struct LlaCoor_d *lla);
extern void ned_of_lla_point_d(struct NedCoor_d *ned, struct LtpDef_d *def, struct LlaCoor_d *lla);

extern double gc_of_gd_lat_d(double gd_lat, double hmsl);
# 29 "/home/yangfp/five/_build/paparazzi/expansion-models/double_geodetic/Program.c" 2





void ltp_def_from_ecef_d(struct LtpDef_d *def, struct EcefCoor_d *ecef)
{

  { (def->ecef).x = (*ecef).x; (def->ecef).y = (*ecef).y; (def->ecef).z = (*ecef).z; };

  lla_of_ecef_d(&def->lla, &def->ecef);

  const double sin_lat = sin(def->lla.lat);
  const double cos_lat = cos(def->lla.lat);
  const double sin_lon = sin(def->lla.lon);
  const double cos_lon = cos(def->lla.lon);
  def->ltp_of_ecef.m[0] = -sin_lon;
  def->ltp_of_ecef.m[1] = cos_lon;
  def->ltp_of_ecef.m[2] = 0.;
  def->ltp_of_ecef.m[3] = -sin_lat * cos_lon;
  def->ltp_of_ecef.m[4] = -sin_lat * sin_lon;
  def->ltp_of_ecef.m[5] = cos_lat;
  def->ltp_of_ecef.m[6] = cos_lat * cos_lon;
  def->ltp_of_ecef.m[7] = cos_lat * sin_lon;
  def->ltp_of_ecef.m[8] = sin_lat;

}

void ltp_def_from_lla_d(struct LtpDef_d *def, struct LlaCoor_d *lla)
{

  { (def->lla).lat = (*lla).lat; (def->lla).lon = (*lla).lon; (def->lla).alt = (*lla).alt; };

  ecef_of_lla_d(&def->ecef, &def->lla);


  const double sin_lat = sin(def->lla.lat);
  const double cos_lat = cos(def->lla.lat);
  const double sin_lon = sin(def->lla.lon);
  const double cos_lon = cos(def->lla.lon);

  def->ltp_of_ecef.m[0] = -sin_lon;
  def->ltp_of_ecef.m[1] = cos_lon;

  def->ltp_of_ecef.m[2] = 0.;
  def->ltp_of_ecef.m[3] = -sin_lat * cos_lon;
  def->ltp_of_ecef.m[4] = -sin_lat * sin_lon;
  def->ltp_of_ecef.m[5] = cos_lat;
  def->ltp_of_ecef.m[6] = cos_lat * cos_lon;
  def->ltp_of_ecef.m[7] = cos_lat * sin_lon;
  def->ltp_of_ecef.m[8] = sin_lat;
}


void lla_of_ecef_d(struct LlaCoor_d *lla, struct EcefCoor_d *ecef)
{


  static const double a = 6378137.0;
  static const double f = 1. / 298.257223563;
  const double b = a * (1. - f);
  const double b2 = b * b;

  const double e2 = 2.*f - (f * f);
  const double ep2 = f * (2. - f) / ((1. - f) * (1. - f));
  const double E2 = a * a - b2;


  const double z2 = ecef->z * ecef->z;
  const double r2 = ecef->x * ecef->x + ecef->y * ecef->y;
  const double r = sqrt(r2);
  const double F = 54.*b2 * z2;
  const double G = r2 + (1 - e2) * z2 - e2 * E2;
  const double c = (e2 * e2 * F * r2) / (G * G * G);
  const double s = pow((1 + c + sqrt(c * c + 2 * c)), 1. / 3.);
  const double s1 = 1 + s + 1 / s;
  const double P = F / (3 * s1 * s1 * G * G);
  const double Q = sqrt(1 + 2 * e2 * e2 * P);
  const double ro = -(e2 * P * r) / (1 + Q) + sqrt((a * a / 2) * (1 + 1 / Q) - ((1 - e2) * P * z2) / (Q *
                    (1 + Q)) - P * r2 / 2);
  const double tmp = (r - e2 * ro) * (r - e2 * ro);
  const double U = sqrt(tmp + z2);
  const double V = sqrt(tmp + (1 - e2) * z2);
  const double zo = (b2 * ecef->z) / (a * V);

  lla->alt = U * (1 - b2 / (a * V));
  lla->lat = atan((ecef->z + ep2 * zo) / r);
  lla->lon = atan2(ecef->y, ecef->x);

}

void ecef_of_lla_d(struct EcefCoor_d *ecef, struct LlaCoor_d *lla)
{


  static const double a = 6378137.0;
  static const double f = 1. / 298.257223563;
  const double e2 = 2.*f - (f * f);

  const double sin_lat = sin(lla->lat);
  const double cos_lat = cos(lla->lat);
  const double sin_lon = sin(lla->lon);
  const double cos_lon = cos(lla->lon);
  const double chi = sqrt(1. - e2 * sin_lat * sin_lat);
  const double a_chi = a / chi;

  ecef->x = (a_chi + lla->alt) * cos_lat * cos_lon;
  ecef->y = (a_chi + lla->alt) * cos_lat * sin_lon;
  ecef->z = (a_chi * (1. - e2) + lla->alt) * sin_lat;
}

void enu_of_ecef_point_d(struct EnuCoor_d *enu, struct LtpDef_d *def, struct EcefCoor_d *ecef)
{
  struct EcefCoor_d delta;
  { (delta).x = (*ecef).x - (def->ecef).x; (delta).y = (*ecef).y - (def->ecef).y; (delta).z = (*ecef).z - (def->ecef).z; };
  { (*enu).x = (((def->ltp_of_ecef)).m[(0)*3+(0)]) * (delta).x + (((def->ltp_of_ecef)).m[(0)*3+(1)]) * (delta).y + (((def->ltp_of_ecef)).m[(0)*3+(2)]) * (delta).z; (*enu).y = (((def->ltp_of_ecef)).m[(1)*3+(0)]) * (delta).x + (((def->ltp_of_ecef)).m[(1)*3+(1)]) * (delta).y + (((def->ltp_of_ecef)).m[(1)*3+(2)]) * (delta).z; (*enu).z = (((def->ltp_of_ecef)).m[(2)*3+(0)]) * (delta).x + (((def->ltp_of_ecef)).m[(2)*3+(1)]) * (delta).y + (((def->ltp_of_ecef)).m[(2)*3+(2)]) * (delta).z; };
}

void ned_of_ecef_point_d(struct NedCoor_d *ned, struct LtpDef_d *def, struct EcefCoor_d *ecef)
{
  struct EnuCoor_d enu;
  enu_of_ecef_point_d(&enu, def, ecef);
  { (*ned).x = (enu).y; (*ned).y = (enu).x; (*ned).z = -(enu).z; };
}

void enu_of_ecef_vect_d(struct EnuCoor_d *enu, struct LtpDef_d *def, struct EcefCoor_d *ecef)
{
  { (*enu).x = (((def->ltp_of_ecef)).m[(0)*3+(0)]) * (*ecef).x + (((def->ltp_of_ecef)).m[(0)*3+(1)]) * (*ecef).y + (((def->ltp_of_ecef)).m[(0)*3+(2)]) * (*ecef).z; (*enu).y = (((def->ltp_of_ecef)).m[(1)*3+(0)]) * (*ecef).x + (((def->ltp_of_ecef)).m[(1)*3+(1)]) * (*ecef).y + (((def->ltp_of_ecef)).m[(1)*3+(2)]) * (*ecef).z; (*enu).z = (((def->ltp_of_ecef)).m[(2)*3+(0)]) * (*ecef).x + (((def->ltp_of_ecef)).m[(2)*3+(1)]) * (*ecef).y + (((def->ltp_of_ecef)).m[(2)*3+(2)]) * (*ecef).z; };
}

void ned_of_ecef_vect_d(struct NedCoor_d *ned, struct LtpDef_d *def, struct EcefCoor_d *ecef)
{
  struct EnuCoor_d enu;
  enu_of_ecef_vect_d(&enu, def, ecef);
  { (*ned).x = (enu).y; (*ned).y = (enu).x; (*ned).z = -(enu).z; };
}



void ecef_of_enu_point_d(struct EcefCoor_d *ecef, struct LtpDef_d *def, struct EnuCoor_d *enu)
{
  { (*ecef).x = (((def->ltp_of_ecef)).m[(0)*3+(0)]) * (*enu).x + (((def->ltp_of_ecef)).m[(1)*3+(0)]) * (*enu).y + (((def->ltp_of_ecef)).m[(2)*3+(0)]) * (*enu).z; (*ecef).y = (((def->ltp_of_ecef)).m[(0)*3+(1)]) * (*enu).x + (((def->ltp_of_ecef)).m[(1)*3+(1)]) * (*enu).y + (((def->ltp_of_ecef)).m[(2)*3+(1)]) * (*enu).z; (*ecef).z = (((def->ltp_of_ecef)).m[(0)*3+(2)]) * (*enu).x + (((def->ltp_of_ecef)).m[(1)*3+(2)]) * (*enu).y + (((def->ltp_of_ecef)).m[(2)*3+(2)]) * (*enu).z; };
  { (*ecef).x += (def->ecef).x; (*ecef).y += (def->ecef).y; (*ecef).z += (def->ecef).z; };
}

void ecef_of_ned_point_d(struct EcefCoor_d *ecef, struct LtpDef_d *def, struct NedCoor_d *ned)
{
  struct EnuCoor_d enu;
  { (enu).x = (*ned).y; (enu).y = (*ned).x; (enu).z = -(*ned).z; };
  ecef_of_enu_point_d(ecef, def, &enu);
}

void ecef_of_enu_vect_d(struct EcefCoor_d *ecef, struct LtpDef_d *def, struct EnuCoor_d *enu)
{
  { (*ecef).x = (((def->ltp_of_ecef)).m[(0)*3+(0)]) * (*enu).x + (((def->ltp_of_ecef)).m[(1)*3+(0)]) * (*enu).y + (((def->ltp_of_ecef)).m[(2)*3+(0)]) * (*enu).z; (*ecef).y = (((def->ltp_of_ecef)).m[(0)*3+(1)]) * (*enu).x + (((def->ltp_of_ecef)).m[(1)*3+(1)]) * (*enu).y + (((def->ltp_of_ecef)).m[(2)*3+(1)]) * (*enu).z; (*ecef).z = (((def->ltp_of_ecef)).m[(0)*3+(2)]) * (*enu).x + (((def->ltp_of_ecef)).m[(1)*3+(2)]) * (*enu).y + (((def->ltp_of_ecef)).m[(2)*3+(2)]) * (*enu).z; };
}

void ecef_of_ned_vect_d(struct EcefCoor_d *ecef, struct LtpDef_d *def, struct NedCoor_d *ned)
{
  struct EnuCoor_d enu;
  { (enu).x = (*ned).y; (enu).y = (*ned).x; (enu).z = -(*ned).z; };
  ecef_of_enu_vect_d(ecef, def, &enu);
}


void enu_of_lla_point_d(struct EnuCoor_d *enu, struct LtpDef_d *def, struct LlaCoor_d *lla)
{
  struct EcefCoor_d ecef;
  ecef_of_lla_d(&ecef, lla);
  enu_of_ecef_point_d(enu, def, &ecef);
}

void ned_of_lla_point_d(struct NedCoor_d *ned, struct LtpDef_d *def, struct LlaCoor_d *lla)
{
  struct EcefCoor_d ecef;
  ecef_of_lla_d(&ecef, lla);
  ned_of_ecef_point_d(ned, def, &ecef);
}



double gc_of_gd_lat_d(double gd_lat, double hmsl)
{
  const double a = 6378137.0;
  const double f = 1. / 298.257223563;
  const double c2 = (1. - f) * (1. - f);

  double ls = atan(c2 * tan(gd_lat));
  return atan2(hmsl * sin(gd_lat) + a * sin(ls), hmsl * cos(gd_lat) + a * cos(ls));
}


# 1 "/home/yangfp/five/_build/paparazzi/overlay/math/pprz_geodetic_utm.h" 1
# 51 "/home/yangfp/five/_build/paparazzi/overlay/math/pprz_geodetic_utm.h"
static const float serie_coeff_proj_mercator[5] = {
  0.99832429842242842444,
  0.00083632803657738403,
  0.00000075957783563707,
  0.00000000119563131778,
  0.00000000000241079916
};

static const float serie_coeff_proj_mercator_inverse[5] = {
  0.998324298422428424,
  0.000837732168742475825,
  5.90586914811817062e-08,
  1.6734091890305064e-10,
  2.13883575853313883e-13
};
# 222 "/home/yangfp/five/_build/paparazzi/expansion-models/double_geodetic/Program.c" 2

static inline double isometric_latitude_d(double phi, double e)
{
  return log(tan((3.14159265358979323846/4) + phi / 2.0)) - e / 2.0 * log((1.0 + e * sin(phi)) / (1.0 - e * sin(phi)));
}

static inline double isometric_latitude_fast_d(double phi)
{
  return log(tan((3.14159265358979323846/4) + phi / 2.0));
}

static inline double inverse_isometric_latitude_d(double lat, double e, double epsilon)
{
  double exp_l = exp(lat);
  double phi0 = 2 * atan(exp_l) - (3.14159265358979323846/2);
  double phi_;
  uint8_t max_iter = 3;

  do {
    phi_ = phi0;
    double sin_phi = e * sin(phi_);
    phi0 = 2 * atan(pow((1 + sin_phi) / (1. - sin_phi), e / 2.) * exp_l) - (3.14159265358979323846/2);
    max_iter--;
  } while (max_iter && fabs(phi_ - phi0) > epsilon);

  return phi0;
}
# 276 "/home/yangfp/five/_build/paparazzi/expansion-models/double_geodetic/Program.c"
void utm_of_lla_d(struct UtmCoor_d *utm, struct LlaCoor_d *lla)
{

  if (utm->zone == 0) {
    utm->zone = (floor(((lla->lon) * (180. / 3.14159265358979323846)) + 180) / 6) + 1;
  }

  double lambda_c = (((utm->zone-1)*6-180+3) * (3.14159265358979323846/180.));
  double ll = isometric_latitude_d(lla->lat , 0.08181919106);
  double dl = lla->lon - lambda_c;
  double phi_ = asin(sin(dl) / cosh(ll));
  double ll_ = isometric_latitude_fast_d(phi_);
  double lambda_ = atan(sinh(ll) / cos(dl));
  struct DoubleVect2 z_ = { lambda_, ll_ };
  { (z_).x = (z_).x * (serie_coeff_proj_mercator[0]); (z_).y = (z_).y * (serie_coeff_proj_mercator[0]); };
  int8_t k;
  for (k = 1; k < 3; k++) {
    struct DoubleVect2 z = { lambda_, ll_ };
    { (z).x = (z).x * (2.*k); (z).y = (z).y * (2.*k); };
    { { double tmp = z.x; z.x = -z.y; z.y = tmp; }; struct DoubleVect2 vstar = {-z.x, -z.y}; { double e = exp(z.x); z.x = e*cos(z.y); z.y = e*sin(z.y); }; { double e = exp(vstar.x); vstar.x = e*cos(vstar.y); vstar.y = e*sin(vstar.y); }; { (z).x -= (vstar).x; (z).y -= (vstar).y; }; { (z).x = (z).x * (-0.5); (z).y = (z).y * (-0.5); }; { double tmp = z.x; z.x = -z.y; z.y = tmp; }; };
    { (z).x = (z).x * (serie_coeff_proj_mercator[k]); (z).y = (z).y * (serie_coeff_proj_mercator[k]); };
    { (z_).x += (z).x; (z_).y += (z).y; };
  }
  { (z_).x = (z_).x * ((0.9996*6378137.0)); (z_).y = (z_).y * ((0.9996*6378137.0)); };
  utm->east = 500000. + z_.y;
  utm->north = 0. + z_.x;


  utm->alt = lla->alt;
}





void lla_of_utm_d(struct LlaCoor_d *lla, struct UtmCoor_d *utm)
{
  struct DoubleVect2 z = {utm->north - 0., utm->east - 500000.};
  double scale = 1 / (0.9996*6378137.0) / serie_coeff_proj_mercator[0];
  { (z).x = (z).x * (scale); (z).y = (z).y * (scale); };

  int8_t k;
  for(k = 1; k<2; k++)
  {
    struct DoubleVect2 z_;
    { (z_).x = (z).x * (2.*k); (z_).y = (z).y * (2.*k); };
    { { double tmp = z_.x; z_.x = -z_.y; z_.y = tmp; }; struct DoubleVect2 vstar = {-z_.x, -z_.y}; { double e = exp(z_.x); z_.x = e*cos(z_.y); z_.y = e*sin(z_.y); }; { double e = exp(vstar.x); vstar.x = e*cos(vstar.y); vstar.y = e*sin(vstar.y); }; { (z_).x -= (vstar).x; (z_).y -= (vstar).y; }; { (z_).x = (z_).x * (-0.5); (z_).y = (z_).y * (-0.5); }; { double tmp = z_.x; z_.x = -z_.y; z_.y = tmp; }; };
    { (z_).x = (z_).x * (serie_coeff_proj_mercator_inverse[k]); (z_).y = (z_).y * (serie_coeff_proj_mercator_inverse[k]); };
    { (z).x -= (z_).x; (z).y -= (z_).y; };
  }

  double lambda_c = (((utm->zone-1)*6-180+3) * (3.14159265358979323846/180.));
  lla->lon = lambda_c + atan(sinh(z.y) / cos(z.x));
  double phi = asin(sin(z.x) / cosh(z.y));
  double il = isometric_latitude_fast_d(phi);
  lla->lat = inverse_isometric_latitude_d(il, 0.08181919106, 1e-8);


  lla->alt = utm->alt;
}

void (*five_keep_ltp_def_from_ecef_d)(void) = (void (*)(void))ltp_def_from_ecef_d;
void (*five_keep_ltp_def_from_lla_d)(void) = (void (*)(void))ltp_def_from_lla_d;
void (*five_keep_lla_of_ecef_d)(void) = (void (*)(void))lla_of_ecef_d;
void (*five_keep_ecef_of_lla_d)(void) = (void (*)(void))ecef_of_lla_d;
void (*five_keep_enu_of_ecef_point_d)(void) = (void (*)(void))enu_of_ecef_point_d;
void (*five_keep_ned_of_ecef_point_d)(void) = (void (*)(void))ned_of_ecef_point_d;
void (*five_keep_enu_of_ecef_vect_d)(void) = (void (*)(void))enu_of_ecef_vect_d;
void (*five_keep_ned_of_ecef_vect_d)(void) = (void (*)(void))ned_of_ecef_vect_d;
void (*five_keep_ecef_of_enu_point_d)(void) = (void (*)(void))ecef_of_enu_point_d;
void (*five_keep_ecef_of_ned_point_d)(void) = (void (*)(void))ecef_of_ned_point_d;
void (*five_keep_ecef_of_enu_vect_d)(void) = (void (*)(void))ecef_of_enu_vect_d;
void (*five_keep_ecef_of_ned_vect_d)(void) = (void (*)(void))ecef_of_ned_vect_d;
void (*five_keep_enu_of_lla_point_d)(void) = (void (*)(void))enu_of_lla_point_d;
void (*five_keep_ned_of_lla_point_d)(void) = (void (*)(void))ned_of_lla_point_d;
void (*five_keep_gc_of_gd_lat_d)(void) = (void (*)(void))gc_of_gd_lat_d;
void (*five_keep_isometric_latitude_d)(void) = (void (*)(void))isometric_latitude_d;
void (*five_keep_isometric_latitude_fast_d)(void) = (void (*)(void))isometric_latitude_fast_d;
void (*five_keep_inverse_isometric_latitude_d)(void) = (void (*)(void))inverse_isometric_latitude_d;
void (*five_keep_utm_of_lla_d)(void) = (void (*)(void))utm_of_lla_d;
void (*five_keep_lla_of_utm_d)(void) = (void (*)(void))lla_of_utm_d;
