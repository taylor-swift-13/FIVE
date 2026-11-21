# 0 "/home/yangfp/five/paparazzi/models/update_pid_df/prepare/source/update_pid_df.c"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "/usr/include/stdc-predef.h" 1 3 4
# 0 "<command-line>" 2
# 1 "/home/yangfp/five/paparazzi/models/update_pid_df/prepare/source/update_pid_df.c"
struct PID_df {
  float u[2];
  float e[3];
  float g[3];
};

float update_pid_df(struct PID_df *pid, float value)
{
  pid->e[2] = pid->e[1];
  pid->e[1] = pid->e[0];
  pid->e[0] = value;
  pid->u[1] = pid->u[0];
  pid->u[0] = pid->u[1] + pid->g[0] * pid->e[0] + pid->g[1] * pid->e[1] + pid->g[2] * pid->e[2];
  return pid->u[0];
}
