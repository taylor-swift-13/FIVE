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

/* Explicit standard-library binding to the CompCert/CBMC intrinsic. */
#define fabsf __builtin_fabsf

bool float_mat_inv_2d(float inv_out[4], const float mat_in[4])
{
  float det = mat_in[0] * mat_in[3] - mat_in[1] * mat_in[2];

  if (fabsf(det) < 1e-4) { return 1; } //not invertible

  inv_out[0] =  mat_in[3] / det;
  inv_out[1] = -mat_in[1] / det;
  inv_out[2] = -mat_in[2] / det;
  inv_out[3] =  mat_in[0] / det;

  return 0; //return success
}
