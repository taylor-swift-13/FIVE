/*
 * Copyright (C) 2008-2014 The Paparazzi Team
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


#include <stdbool.h>
#include <math.h>
#include <float.h>

bool float_mat_inv_3d(float inv_out[3][3], const float mat_in[3][3])
{
  const float m00 = mat_in[1][1] * mat_in[2][2] - mat_in[1][2] * mat_in[2][1];
  const float m10 = mat_in[0][1] * mat_in[2][2] - mat_in[0][2] * mat_in[2][1];
  const float m20 = mat_in[0][1] * mat_in[1][2] - mat_in[0][2] * mat_in[1][1];
  const float m01 = mat_in[1][0] * mat_in[2][2] - mat_in[1][2] * mat_in[2][0];
  const float m11 = mat_in[0][0] * mat_in[2][2] - mat_in[0][2] * mat_in[2][0];
  const float m21 = mat_in[0][0] * mat_in[1][2] - mat_in[0][2] * mat_in[1][0];
  const float m02 = mat_in[1][0] * mat_in[2][1] - mat_in[1][1] * mat_in[2][0];
  const float m12 = mat_in[0][0] * mat_in[2][1] - mat_in[0][1] * mat_in[2][0];
  const float m22 = mat_in[0][0] * mat_in[1][1] - mat_in[0][1] * mat_in[1][0];
  const float det = mat_in[0][0] * m00 - mat_in[1][0] * m10 + mat_in[2][0] * m20;
  if (fabs(det) > FLT_EPSILON) {
    inv_out[0][0] =  m00 / det;
    inv_out[1][0] = -m01 / det;
    inv_out[2][0] =  m02 / det;
    inv_out[0][1] = -m10 / det;
    inv_out[1][1] =  m11 / det;
    inv_out[2][1] = -m12 / det;
    inv_out[0][2] =  m20 / det;
    inv_out[1][2] = -m21 / det;
    inv_out[2][2] =  m22 / det;
    return 0;
  }
  return 1;
}
