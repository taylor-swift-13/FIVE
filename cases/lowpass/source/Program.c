/*
 * Copyright (C) 2013 Gautier Hattenberger
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
 * along with paparazzi; see the file COPYING.  If not, write to
 * the Free Software Foundation, 59 Temple Place - Suite 330,
 * Boston, MA 02111-1307, USA.
 */


/* Exact struct and function extracted from pinned upstream header. */
struct SecondOrderLowPass {
  float a[2]; ///< denominator gains
  float b[2]; ///< numerator gains
  float i[2]; ///< input history
  float o[2]; ///< output history
};

static inline float update_second_order_low_pass(struct SecondOrderLowPass *filter, const float value)
{
  float out = filter->b[0] * value
              + filter->b[1] * filter->i[0]
              + filter->b[0] * filter->i[1]
              - filter->a[0] * filter->o[0]
              - filter->a[1] * filter->o[1];
  filter->i[1] = filter->i[0];
  filter->i[0] = value;
  filter->o[1] = filter->o[0];
  filter->o[0] = out;
  return out;
}

/* Verification linkage only; original function above is unchanged. */
float five_lowpass_entry(struct SecondOrderLowPass *filter, const float value) {
  return update_second_order_low_pass(filter, value);
}
