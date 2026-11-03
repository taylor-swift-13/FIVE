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


struct FloatRMat {
  float m[3 * 3];
};

struct FloatEulers {
  float phi; ///< in radians
  float theta; ///< in radians
  float psi; ///< in radians
};
#define RMAT_ELMT(_rm, _r, _c) ((_rm).m[(_r)*3+(_c)])
float five_sinf(float);
float five_cosf(float);
#define sinf five_sinf
#define cosf five_cosf

void float_rmat_of_eulers_321(struct FloatRMat *rm, const struct FloatEulers *e)
{
  const float sphi   = sinf(e->phi);
  const float cphi   = cosf(e->phi);
  const float stheta = sinf(e->theta);
  const float ctheta = cosf(e->theta);
  const float spsi   = sinf(e->psi);
  const float cpsi   = cosf(e->psi);

  RMAT_ELMT(*rm, 0, 0) = ctheta * cpsi;
  RMAT_ELMT(*rm, 0, 1) = ctheta * spsi;
  RMAT_ELMT(*rm, 0, 2) = -stheta;
  RMAT_ELMT(*rm, 1, 0) = sphi * stheta * cpsi - cphi * spsi;
  RMAT_ELMT(*rm, 1, 1) = sphi * stheta * spsi + cphi * cpsi;
  RMAT_ELMT(*rm, 1, 2) = sphi * ctheta;
  RMAT_ELMT(*rm, 2, 0) = cphi * stheta * cpsi + sphi * spsi;
  RMAT_ELMT(*rm, 2, 1) = cphi * stheta * spsi - sphi * cpsi;
  RMAT_ELMT(*rm, 2, 2) = cphi * ctheta;
}
