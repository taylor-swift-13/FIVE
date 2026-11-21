/*
 * Copyright (C) 2008-2009 Antoine Drouin <poinix@gmail.com>
 *
 * This file is part of paparazzi.
 *
 * paparazzi is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2, or (at your option)
 * any later version.
 *
 * paparazzi is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with paparazzi; see the file COPYING.  If not, see
 * <http://www.gnu.org/licenses/>.
 */

#include <stdint.h>
#define PPRZ_TRIG_CONST const
#define TRIG_INT_SIZE           6434
#define TRIG_INT_VAL_MAX        14
#define TREE_SIZE_4             (TRIG_INT_VAL_MAX - 4)
#define TREE_SIZE_8             (TRIG_INT_VAL_MAX - 8)
#define TREE_SIZE_12            (TRIG_INT_VAL_MAX - 12)

/* resulting compressed size */
#define TRIG_INT_RLE_LEN        3379
#define TRIG_INT_COMPR_LEN      ((TRIG_INT_RLE_LEN + 1) / 2)

/* minimum size to use multi */
#define ONE_MIN   ((3 * 3) + 1)

#define TREE_BUF_12_1 1035
#define TREE_BUF_12_2 2145
#define TREE_BUF_12_3 3474


#define INT32_ANGLE_FRAC 12
#define INT32_RATE_FRAC 12
#define INT32_ANGLE_PI_4   (int32_t)ANGLE_BFP_OF_REAL(   0.7853981633974483096156608458198757)
#define INT32_ANGLE_PI_2   (int32_t)ANGLE_BFP_OF_REAL(   1.5707963267948966192313216916397514)
#define INT32_ANGLE_PI     (int32_t)ANGLE_BFP_OF_REAL(   3.1415926535897932384626433832795029)
#define INT32_ANGLE_2_PI   (int32_t)ANGLE_BFP_OF_REAL(2.*3.1415926535897932384626433832795029)

#define INT32_RAD_OF_DEG(_deg) (int32_t)(((int64_t)(_deg) * 14964008)/857374503)
#define INT32_DEG_OF_RAD(_rad) (int32_t)(((int64_t)(_rad) * 857374503)/14964008)

#define INT32_ANGLE_NORMALIZE(_a) {             \
    while ((_a) > INT32_ANGLE_PI)  (_a) -= INT32_ANGLE_2_PI;    \
    while ((_a) < -INT32_ANGLE_PI) (_a) += INT32_ANGLE_2_PI;    \
  }


#define BFP_OF_REAL(_vr, _frac)    ((_vr)*(1<<(_frac)))
#define ANGLE_BFP_OF_REAL(_af)  BFP_OF_REAL((_af), INT32_ANGLE_FRAC)
