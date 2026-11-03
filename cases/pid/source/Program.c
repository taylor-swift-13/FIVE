/*
 * Copyright (C) 2018 Gautier Hattenberger
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


/* Exact struct and update_pid_f extracted from pinned upstream pid.h. */
struct PID_f {
  float u;        ///< output
  float e[2];     ///< input
  float sum;      ///< integral of input
  float g[3];     ///< controller gains (Kp, Kd, Ki)
  float max_sum;  ///< windup protection, max of Ki * sum(e_k * dt)
};

static inline float update_pid_f(struct PID_f *pid, float value, float dt)
{
  pid->e[1] = pid->e[0];
  pid->e[0] = value;
  float integral = pid->g[2] * (pid->sum + value);
  if (integral > pid->max_sum) {
    integral = pid->max_sum;
  } else if (integral < -pid->max_sum) {
    integral = -pid->max_sum;
  } else {
    pid->sum += value;
  }
  pid->u = pid->g[0] * pid->e[0] + pid->g[1] * (pid->e[0] - pid->e[1]) / dt + integral;
  return pid->u;
}

float five_pid_step(struct PID_f *pid, float value, float dt)
{
  return update_pid_f(pid, value, dt);
}
