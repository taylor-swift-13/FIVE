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

/**
 * @file pprz_algebra_float.c
 * @brief Paparazzi floating point algebra.
 *
 */

#include "pprz_algebra_float.h"

/** in place first order integration of a 3D-vector */
void float_vect3_integrate_fi(struct FloatVect3 *vec, const struct FloatVect3 *dv, const float dt)
{
  vec->x += dv->x * dt;
  vec->y += dv->y * dt;
  vec->z += dv->z * dt;
}

/** in place first order integration of angular rates */







/** in place first order integration of angular rates */





































/** Composition (multiplication) of two rotation matrices.
 * m_a2c = m_a2b comp m_b2c , aka  m_a2c = m_b2c * m_a2b
 */
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

/** Composition (multiplication) of two rotation matrices.
 * m_a2b = m_a2c comp_inv m_b2c , aka  m_a2b = inv(_m_b2c) * m_a2c
 */













/** rotate 3D vector by rotation matrix.
 * vb = m_a2b * va
 */
void float_rmat_vmult(struct FloatVect3 *vb, const struct FloatRMat *m_a2b, const struct FloatVect3 *va)
{
  vb->x = m_a2b->m[0] * va->x + m_a2b->m[1] * va->y + m_a2b->m[2] * va->z;
  vb->y = m_a2b->m[3] * va->x + m_a2b->m[4] * va->y + m_a2b->m[5] * va->z;
  vb->z = m_a2b->m[6] * va->x + m_a2b->m[7] * va->y + m_a2b->m[8] * va->z;
}

/** rotate 3D vector by transposed rotation matrix.
 * vb = m_b2a^T * va
 */







/** rotate angle by rotation matrix.
 * rb = m_a2b * ra
 */







/** rotate angle by transposed rotation matrix.
 * rb = m_b2a^T * ra
 */







/** rotate anglular rates by rotation matrix.
 * rb = m_a2b * ra
 */







/** rotate anglular rates by transposed rotation matrix.
 * rb = m_b2a^T * ra
 */








/** initialises a rotation matrix from unit vector axis and angle */
























/* C n->b rotation matrix */









































/* C n->b rotation matrix */
























/** in place first order integration of a rotation matrix */














static inline float renorm_factor(float n)
{
  if (n < 1.5625f && n > 0.64f) {
    return .5 * (3 - n);
  } else if (n < 100.0f && n > 0.01f) {
    return  1. / sqrtf(n);
  } else {
    return 0.;
  }
}

float float_rmat_reorthogonalize(struct FloatRMat *rm)
{
  const struct FloatVect3 r0 = {RMAT_ELMT(*rm, 0, 0),
    RMAT_ELMT(*rm, 0, 1),
    RMAT_ELMT(*rm, 0, 2)
  };
  const struct FloatVect3 r1 = {RMAT_ELMT(*rm, 1, 0),
    RMAT_ELMT(*rm, 1, 1),
    RMAT_ELMT(*rm, 1, 2)
  };
  float _err = -0.5 * VECT3_DOT_PRODUCT(r0, r1);
  struct FloatVect3 r0_t;
  VECT3_SUM_SCALED(r0_t, r0, r1, _err);
  struct FloatVect3 r1_t;
  VECT3_SUM_SCALED(r1_t,  r1, r0, _err);
  struct FloatVect3 r2_t;
  VECT3_CROSS_PRODUCT(r2_t, r0_t, r1_t);
  float s = renorm_factor(VECT3_NORM2(r0_t));
  MAT33_ROW_VECT3_SMUL(*rm, 0, r0_t, s);
  s = renorm_factor(VECT3_NORM2(r1_t));
  MAT33_ROW_VECT3_SMUL(*rm, 1, r1_t, s);
  s = renorm_factor(VECT3_NORM2(r2_t));
  MAT33_ROW_VECT3_SMUL(*rm, 2, r2_t, s);

  return _err;
}


/*
 *
 * Quaternion functions.
 *
 */

void float_quat_comp(struct FloatQuat *a2c, const struct FloatQuat *a2b, const struct FloatQuat *b2c)
{
  a2c->qi = a2b->qi * b2c->qi - a2b->qx * b2c->qx - a2b->qy * b2c->qy - a2b->qz * b2c->qz;
  a2c->qx = a2b->qi * b2c->qx + a2b->qx * b2c->qi + a2b->qy * b2c->qz - a2b->qz * b2c->qy;
  a2c->qy = a2b->qi * b2c->qy - a2b->qx * b2c->qz + a2b->qy * b2c->qi + a2b->qz * b2c->qx;
  a2c->qz = a2b->qi * b2c->qz + a2b->qx * b2c->qy - a2b->qy * b2c->qx + a2b->qz * b2c->qi;
}
























































/** in place first order quaternion integration with constant rotational velocity */















/** in place quaternion integration with constant rotational velocity */





















void float_quat_vmult(struct FloatVect3 *v_out, const struct FloatQuat *q, const struct FloatVect3 *v_in)
{
  const float qi2_M1_2  = q->qi * q->qi - 0.5;
  const float qiqx = q->qi * q->qx;
  const float qiqy = q->qi * q->qy;
  const float qiqz = q->qi * q->qz;
  float m01  = q->qx * q->qy; /* aka qxqy */
  float m02  = q->qx * q->qz; /* aka qxqz */
  float m12  = q->qy * q->qz; /* aka qyqz */

  const float m00  = qi2_M1_2 + q->qx * q->qx;
  const float m10  = m01 - qiqz;
  const float m20  = m02 + qiqy;
  const float m21  = m12 - qiqx;
  m01 += qiqz;
  m02 -= qiqy;
  m12 += qiqx;
  const float m11  = qi2_M1_2 + q->qy * q->qy;
  const float m22  = qi2_M1_2 + q->qz * q->qz;
  v_out->x = 2 * (m00 * v_in->x + m01 * v_in->y + m02 * v_in->z);
  v_out->y = 2 * (m10 * v_in->x + m11 * v_in->y + m12 * v_in->z);
  v_out->z = 2 * (m20 * v_in->x + m21 * v_in->y + m22 * v_in->z);
}

/** Quaternion derivative from rotational velocity.
 * qd = -0.5*omega(r) * q
 * or equally:
 * qd = 0.5 * q * omega(r)
 */








/** Quaternion derivative from rotational velocity.
 * qd = -0.5*omega(r) * q
 */










/**
 * @brief quat of euler roation 'ZYX'
 *
 * @param q Quat output
 * @param e Euler input
 */




















/**
 * @brief quat from euler rotation 'ZXY'
 * This rotation order is useful if you need 90 deg pitch
 *
 * @param q Quat output
 * @param e Euler input
 */



















/**
 * @brief quat from euler rotation 'YXZ'
 * This function calculates a quaternion from Euler angles with the order YXZ,
 * so pitch, roll, yaw, instead of the conventional ZYX order.
 * See https://en.wikipedia.org/wiki/Euler_angles
 *
 * @param q Quat output
 * @param e Euler input
 */

























































































/**
 * @brief Tilt twist decomposition of a quaternion (z axis)
 *
 * Decomposes a quaternion rotation in two rotations:
 * 1. A rotation that aligns the z axis.
 * 2. A rotation around the z axis.
 *
 * Useful for control of vehicles that are slow in rotation around the z axis.
 *
 * @param tilt Tilt output
 * @param twist Twist output
 * @param quat Quaternion input
 */


























/*
 *
 * Euler angle functions.
 *
 */

















/**
 * @brief euler rotation 'ZYX'
 *
 * @param e Euler output
 * @param q Quat input
 */

























/**
 * @brief euler rotation 'YXZ'
 * This function calculates from a quaternion the Euler angles with the order YXZ,
 * so pitch, roll, yaw, instead of the conventional ZYX order.
 * See https://en.wikipedia.org/wiki/Euler_angles
 *
 * @param e Euler output
 * @param q Quat input
 */


























/**
 * @brief euler rotation 'ZXY'
 * This rotation order is useful if you need 90 deg pitch
 *
 * @param e Euler output
 * @param q Quat input
 */


























/**
 * @brief 2x2 matrix inverse
 *
 * @param inv_out[4] inverted matrix output
 * @param mat_in[4] matrix to be inverted
 *
 * @return success (0) or not invertible (1)
 */
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

/**
 * @brief Multiply 2D matrix with vector
 *
 * @param vect_out output vector
 * @param mat[4] Matrix input
 * @param vect_in Vector input
 */






/**
 * @brief 3x3 matrix inverse
 *
 * @param inv_out[3][3] inverted matrix output
 * @param mat_in[3][3] matrix to be inverted
 *
 * @return success (0) or not invertible (1)
 */
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

/**
 * @brief Multiply 3D matrix with vector
 *
 * @param vect_out output vector
 * @param mat[3][3] Matrix input
 * @param vect_in Vector input
 */







/*
 * 4x4 Matrix inverse.
 * obtained from: http://rodolphe-vaillant.fr/?e=7
 */





































/**
 * 4x4 Matrix inverse
 *
 * @param invOut output array, inverse of mat_in
 * @param mat_in input array
 */



















/** Calculate inverse of any n x n matrix (passed as C array) o = mat^-1
Algorithm verified with Matlab.
Thanks to: https://www.quora.com/How-do-I-make-a-C++-program-to-get-the-inverse-of-a-matrix-100-X-100
*/













































/*
 * o[n][n] = e^a[n][n]
 * Replicates expm(a) in Matlab
 *
 * Adapted from the following reference:
 * Cleve Moler, Charles VanLoan,
 * Nineteen Dubious Ways to Compute the Exponential of a Matrix,
 * Twenty-Five Years Later, SIAM Review, Volume 45, Number 1, March 2003, pages 3-49.
 * https://people.sc.fsu.edu/~jburkardt/c_src/matrix_exponential/matrix_exponential.c
 */


























































/* Returns L-oo of matrix a */
















/* Scale a 3D vector to within a 2D bound */










/* Scale a 3D vector to within a 3D bound */











/* Scale a 3D vector to a certain length in 2D */










/* Scale a 2D vector to within a 2D bound */










/* Scale a 2D vector to a certain length in 2D */









