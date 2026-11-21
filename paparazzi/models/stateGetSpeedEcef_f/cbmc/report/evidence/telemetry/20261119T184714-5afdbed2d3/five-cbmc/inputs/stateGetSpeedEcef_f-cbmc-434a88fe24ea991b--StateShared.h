/* Original pinned State/type/macro slices; no function bodies. */
#ifndef FIVE_STATE_SPEED_SHARED_H
#define FIVE_STATE_SPEED_SHARED_H
#include <stdint.h>
#include <stdbool.h>

#define ENU_OF_TO_NED(_po, _pi) {   \
    (_po).x =  (_pi).y;       \
    (_po).y =  (_pi).x;       \
    (_po).z = -(_pi).z;       \
  }

#define FLOAT_OF_BFP(_vbfp, _frac) ((float)(_vbfp)/(1<<(_frac)))

#define INT32_ACCEL_FRAC 10

#define INT32_ANGLE_FRAC 12

#define INT32_POS_FRAC 8

#define INT32_QUAT_FRAC 15

#define INT32_RATE_FRAC 12

#define INT32_SPEED_FRAC 19

#define INT32_TRIG_FRAC 14

#define MAT33_ELMT(_m, _row, _col) ((_m).m[(_row)*3+(_col)])

#define MAT33_VECT3_TRANSP_MUL(_vout, _mat, _vin) {     \
    (_vout).x = MAT33_ELMT((_mat), 0, 0) * (_vin).x + \
                MAT33_ELMT((_mat), 1, 0) * (_vin).y + \
                MAT33_ELMT((_mat), 2, 0) * (_vin).z;  \
    (_vout).y = MAT33_ELMT((_mat), 0, 1) * (_vin).x +   \
                MAT33_ELMT((_mat), 1, 1) * (_vin).y +   \
                MAT33_ELMT((_mat), 2, 1) * (_vin).z;  \
    (_vout).z = MAT33_ELMT((_mat), 0, 2) * (_vin).x +   \
                MAT33_ELMT((_mat), 1, 2) * (_vin).y + \
                MAT33_ELMT((_mat), 2, 2) * (_vin).z;  \
  }

#define SPEEDS_FLOAT_OF_BFP(_ef, _ei) {     \
    (_ef).x = SPEED_FLOAT_OF_BFP((_ei).x);    \
    (_ef).y = SPEED_FLOAT_OF_BFP((_ei).y);    \
    (_ef).z = SPEED_FLOAT_OF_BFP((_ei).z);    \
  }

#define SPEED_ECEF_F  5

#define SPEED_ECEF_I  0

#define SPEED_FLOAT_OF_BFP(_ai) FLOAT_OF_BFP((_ai), INT32_SPEED_FRAC)

#define SPEED_NED_F   6

#define SPEED_NED_I   1

#define STATE_CHECK_INPUT_AND_RETURN(flag, id) if (flag==STATE_INPUT_DISABLE || !(flag==STATE_INPUT_ANY || flag==id)) { return; }

#define STATE_INPUT_ANY       0xFFFF  ///< default

#define STATE_INPUT_DISABLE   0       ///< use with care

#define SetBit(a, n) a |= (1 << n)

#define VECT3_COPY(_a, _b) {        \
    (_a).x = (_b).x;        \
    (_a).y = (_b).y;        \
    (_a).z = (_b).z;        \
  }

  #define bit_is_set(x, b) ((x >> b) & 0x1)

struct DoubleRMat {
  double m[3 * 3];
};

struct EcefCoor_d {
  double x; ///< in meters
  double y; ///< in meters
  double z; ///< in meters
};

struct EcefCoor_f {
  float x; ///< in meters
  float y; ///< in meters
  float z; ///< in meters
};

struct EcefCoor_i {
  int32_t x; ///< in centimeters
  int32_t y; ///< in centimeters
  int32_t z; ///< in centimeters
};

struct EnuCoor_f {
  float x; ///< in meters
  float y; ///< in meters
  float z; ///< in meters
};

struct FloatRMat {
  float m[3 * 3];
};

struct LlaCoor_f {
  float lat; ///< in radians
  float lon; ///< in radians
  float alt; ///< in meters (normally above WGS84 reference ellipsoid)
};

struct LtpDef_f {
  struct EcefCoor_f ecef; ///< origin of local frame in ECEF
  struct LlaCoor_f  lla; ///< origin of local frame in LLA
  struct FloatRMat ltp_of_ecef; ///< rotation from ECEF to local frame
  float hmsl; ///< Height above mean sea level in meters
};

struct NedCoor_f {
  float x; ///< in meters
  float y; ///< in meters
  float z; ///< in meters
};

struct NedCoor_i {
  int32_t x;  ///< North
  int32_t y;  ///< East
  int32_t z;  ///< Down
};

struct EnuCoor_i {
  int32_t x;  ///< East
  int32_t y;  ///< North
  int32_t z;  ///< Up
};

struct FloatRates {
  float p; ///< in rad/s
  float q; ///< in rad/s
  float r; ///< in rad/s
};

struct FloatVect2 {
  float x;
  float y;
};

struct FloatVect3 {
  float x;
  float y;
  float z;
};

struct Int32Rates {
  int32_t p; ///< in rad/s with #INT32_RATE_FRAC
  int32_t q; ///< in rad/s with #INT32_RATE_FRAC
  int32_t r; ///< in rad/s with #INT32_RATE_FRAC
};

struct Int32Vect2 {
  int32_t x;
  int32_t y;
};

struct Int32Vect3 {
  int32_t x;
  int32_t y;
  int32_t z;
};

struct LlaCoor_i {
  int32_t lat; ///< in degrees*1e7
  int32_t lon; ///< in degrees*1e7
  int32_t alt; ///< in millimeters above WGS84 reference ellipsoid
};

struct Int32RMat {
  int32_t m[3 * 3];
};

struct LtpDef_i {
  struct EcefCoor_i ecef;        ///< Reference point in ecef
  struct LlaCoor_i  lla;         ///< Reference point in lla
  struct Int32RMat ltp_of_ecef; ///< Rotation matrix
  int32_t hmsl;                  ///< Height above mean sea level in mm
};

struct FloatEulers {
  float phi; ///< in radians
  float theta; ///< in radians
  float psi; ///< in radians
};

struct FloatQuat {
  float qi;
  float qx;
  float qy;
  float qz;
};

struct Int32Eulers {
  int32_t phi;   ///< in rad with #INT32_ANGLE_FRAC
  int32_t theta; ///< in rad with #INT32_ANGLE_FRAC
  int32_t psi;   ///< in rad with #INT32_ANGLE_FRAC
};

struct Int32Quat {
  int32_t qi;
  int32_t qx;
  int32_t qy;
  int32_t qz;
};

struct OrientationReps {
  /**
   * Holds the status bits for all orientation representations.
   * When the corresponding bit is set, the representation
   * is already computed.
   */
  uint8_t status;

  /**
   * Orientation quaternion.
   * Units: #INT32_QUAT_FRAC
   */
  struct Int32Quat quat_i;

  /**
   * Orientation in zyx euler angles.
   * Units: rad in BFP with #INT32_ANGLE_FRAC
   */
  struct Int32Eulers eulers_i;

  /**
   * Orientation rotation matrix.
   * Units: rad in BFP with #INT32_TRIG_FRAC
   */
  struct Int32RMat rmat_i;

  /**
   * Orientation as quaternion.
   * Units: unit length quaternion
   */
  struct FloatQuat quat_f;

  /**
   * Orienation in zyx euler angles.
   * Units: rad
   */
  struct FloatEulers eulers_f;

  /**
   * Orientation in zxy euler angles.
   * Units: rad
   */
  struct FloatEulers eulers_zxy_f;

  /**
   * Orientation rotation matrix.
   * Units: rad
   */
  struct FloatRMat   rmat_f;
};

struct UtmCoor_f {
  float north; ///< in meters
  float east; ///< in meters
  float alt; ///< in meters (above WGS84 reference ellipsoid or above MSL)
  uint8_t zone; ///< UTM zone number
};

struct State {

  /** @addtogroup state_position
   *  @{ */

  /**
   * Holds the input filter id for state origin.
   */
  uint16_t origin_input_filter;

  /**
   * Holds the status bits for all position representations.
   * When the corresponding bit is set the representation
   * is already computed.
   */
  uint16_t pos_status;

  /**
   * Holds the input filter id for position.
   */
  uint16_t pos_input_filter;

  /**
   * Position in EarthCenteredEarthFixed coordinates.
   * Units: centimeters
   */
  struct EcefCoor_i ecef_pos_i;

  /**
   * Position in Latitude, Longitude and Altitude.
   * Units lat,lon: degrees*1e7
   * Units alt: milimeters above reference ellipsoid
   */
  struct LlaCoor_i lla_pos_i;

  /**
   * Definition of the local (flat earth) coordinate system.
   * Defines the origin of the local NorthEastDown coordinate system
   * in ECEF (EarthCenteredEarthFixed) and LLA (LatitudeLongitudeAlt)
   * coordinates and the roation matrix from ECEF to local frame.
   * (int version)
   */
  struct LtpDef_i ned_origin_i;

  /**
   * true if local int coordinate frame is initialsed
   */
  bool ned_initialized_i;

  /**
   * Position in North East Down coordinates.
   * with respect to ned_origin_i (flat earth)
   * Units: m in BFP with INT32_POS_FRAC
   */
  struct NedCoor_i ned_pos_i;

  /**
   * Position in East North Up coordinates.
   * with respect to ned_origin_i (flat earth)
   * Units: m in BFP with INT32_POS_FRAC
   */
  struct EnuCoor_i enu_pos_i;

  /**
   * Position in UTM coordinates.
   * Units x,y: meters.
   * Units z: meters above MSL
   */
  struct UtmCoor_f utm_pos_f;

  /**
   * Altitude above ground level.
   * Unit: meters
   */
  float alt_agl_f;

  /**
   * Position in Latitude, Longitude and Altitude.
   * Units lat,lon: radians
   * Units alt: meters above reference ellipsoid
   */
  struct LlaCoor_f lla_pos_f;

  /**
   * Position in EarthCenteredEarthFixed coordinates.
   * Units: meters
   */
  struct EcefCoor_f ecef_pos_f;

  /**
   * Definition of the local (flat earth) coordinate system.
   * Defines the origin of the local NorthEastDown coordinate system
   * in ECEF (EarthCenteredEarthFixed) and LLA (LatitudeLongitudeAlt)
   * coordinates and the roation matrix from ECEF to local frame.
   * (float version)
   */
  struct LtpDef_f ned_origin_f;

  /// True if local float coordinate frame is initialsed
  bool ned_initialized_f;

  /**
   * Definition of the origin of Utm coordinate system.
   * Defines the origin of the local NorthEastDown coordinate system
   * in UTM coordinates, used as a reference when ned_origin is not
   * initialized.
   * Altitude is height above MSL.
   * (float version)
   */
  struct UtmCoor_f utm_origin_f;

  /// True if utm origin (float) coordinate frame is initialsed
  bool utm_initialized_f;

  /**
   * Position in North East Down coordinates.
   * with respect to ned_origin_i (flat earth)
   * Units: meters
   */
  struct NedCoor_f ned_pos_f;

  /**
   * Position in East North Up coordinates.
   * with respect to ned_origin_i (flat earth)
   * Units: meters
   */
  struct EnuCoor_f enu_pos_f;
  /** @}*/


  /** @addtogroup state_velocity
   *  @{ */
  /**
   * Holds the status bits for all ground speed representations.
   * When the corresponding bit is one the representation
   * is already computed.
   */
  uint16_t speed_status;

  /**
   * Holds the input filter id for speed.
   */
  uint16_t speed_input_filter;

  /**
   * Velocity in EarthCenteredEarthFixed coordinates.
   * Units: m/s in BFP with #INT32_SPEED_FRAC
   */
  struct EcefCoor_i ecef_speed_i;

  /**
   * Velocity in North East Down coordinates.
   * Units: m/s in BFP with #INT32_SPEED_FRAC
   */
  struct NedCoor_i ned_speed_i;

  /**
   * Velocity in East North Up coordinates.
   * Units: m/s in BFP with #INT32_SPEED_FRAC
   */
  struct EnuCoor_i enu_speed_i;

  /**
   * Norm of horizontal ground speed.
   * Unit: m/s in BFP with #INT32_SPEED_FRAC
   */
  uint32_t h_speed_norm_i;

  /**
   * Direction of horizontal ground speed.
   * Unit: rad in BFP with #INT32_ANGLE_FRAC
   * (clockwise, zero=north)
   */
  int32_t h_speed_dir_i;

  /**
   * Velocity in EarthCenteredEarthFixed coordinates.
   * Units: m/s
   */
  struct EcefCoor_f ecef_speed_f;

  /**
   * @brief speed in North East Down coordinates
   * @details Units: m/s */
  struct NedCoor_f ned_speed_f;

  /**
   * Velocity in East North Up coordinates.
   * Units: m/s
   */
  struct EnuCoor_f enu_speed_f;

  /**
   * Norm of horizontal ground speed.
   * Unit: m/s
   */
  float h_speed_norm_f;

  /**
   * Direction of horizontal ground speed.
   * Unit: rad (clockwise, zero=north)
   */
  float h_speed_dir_f;
  /** @}*/


  /** @addtogroup state_acceleration
   *  @{ */
  /**
   * Holds the status bits for all acceleration representations.
   * When the corresponding bit is one the representation
   * is already computed.
   */
  uint8_t accel_status;

  /**
   * Holds the input filter id for acceleration.
   */
  uint16_t accel_input_filter;

  /**
   * Acceleration in Body coordinates.
   * Units: m/s^2 in BFP with #INT32_ACCEL_FRAC
   */
  struct Int32Vect3 body_accel_i;

  /**
   * Acceleration in North East Down coordinates.
   * Units: m/s^2 in BFP with #INT32_ACCEL_FRAC
   */
  struct NedCoor_i ned_accel_i;

  /**
   * Acceleration in EarthCenteredEarthFixed coordinates.
   * Units: m/s^2 in BFP with INT32_ACCEL_FRAC
   */
  struct EcefCoor_i ecef_accel_i;

  /**
   * Acceleration in North East Down coordinates.
   * Units: m/s^2
   */
  struct NedCoor_f ned_accel_f;

  /**
   * Acceleration in EarthCenteredEarthFixed coordinates.
   * Units: m/s^2
   */
  struct EcefCoor_f ecef_accel_f;
  /** @}*/


  /** @defgroup state_attitude Attitude representations
   */
  struct OrientationReps ned_to_body_orientation;

  /**
   * Holds the input filter id for attitude.
   */
  uint16_t attitude_input_filter;


  /** @addtogroup state_rate
   *  @{ */
  /**
   * Holds the status bits for all angular rate representations.
   * When the corresponding bit is one the representation
   * is already computed.
   */
  uint8_t rate_status;

  /**
   * Holds the input filter id for rates.
   */
  uint16_t rates_input_filter;

  /**
   * Angular rates in body frame.
   * Units: rad/s in BFP with #INT32_RATE_FRAC
   */
  struct Int32Rates  body_rates_i;

  /**
   * Angular rates in body frame.
   * Units: rad/s
   */
  struct FloatRates  body_rates_f;
  /** @}*/


  /** @addtogroup state_wind_airspeed
   *  @{ */
  /**
   * Holds the status bits for all wind- and airspeed representations.
   * When the corresponding bit is one the representation
   * is already computed.
   */
  uint8_t wind_air_status;

  /**
   * Holds the input filter id for air data.
   */
  uint16_t wind_air_input_filter;

  /**
   * Horizontal windspeed in north/east/down.
   * Units: m/s in BFP with #INT32_SPEED_FRAC
   */
  union {
    struct Int32Vect3 vect3;
    struct Int32Vect2 vect2;
  } windspeed_i;

  /**
   * Norm of relative wind speed.
   * Unit: m/s in BFP with #INT32_SPEED_FRAC
   */
  int32_t airspeed_i;

  /**
   * Horizontal windspeed.
   * Units: m/s with x=north, y=east, z=down
   */
  union {
    struct FloatVect3 vect3;
    struct FloatVect2 vect2;
  } windspeed_f;

  /**
   * Norm of relative air speed.
   * Unit: m/s
   */
  float airspeed_f;

  /**
   * Angle of attack
   * Unit: rad
   */
  float angle_of_attack_f;

  /**
   * Sideslip angle
   * Unit: rad
   */
  float sideslip_f;

  /** @}*/

};

#endif
