/* Exact pinned original slices; open external bindings are explicit. */
#include <stdint.h>
#include <stdbool.h>
#include <math.h>
#define COMMANDS_NB 4
#define COMMAND_THRUST 3
#define BFP_OF_REAL(_vr, _frac)    ((_vr)*(1<<(_frac)))

#define INT32_ANGLE_FRAC 12

#define ANGLE_BFP_OF_REAL(_af)  BFP_OF_REAL((_af), INT32_ANGLE_FRAC)

#define GH_GAIN_SCALE 2

  #define M_PI 3.14159265358979323846

#define RadOfDeg(x) ((x) * (M_PI/180.))

#define GUIDANCE_H_MAX_BANK RadOfDeg(20)

#define GUIDANCE_H_THRUST_CMD_FILTER 10

  #define TRUE true

#define GUIDANCE_H_USE_SPEED_REF TRUE

#define INT32_ACCEL_FRAC 10

#define INT32_ANGLE_PI_2   (int32_t)ANGLE_BFP_OF_REAL(   1.5707963267948966192313216916397514)

#define INT32_POS_FRAC 8

#define INT32_QUAT_FRAC 15

#define INT32_RATE_FRAC 12

#define INT32_SPEED_FRAC 19

#define INT32_TRIG_FRAC 14

#define VECT2_ASSIGN(_a, _x, _y) {    \
    (_a).x = (_x);        \
    (_a).y = (_y);        \
  }

#define INT_VECT2_ZERO(_v) VECT2_ASSIGN(_v, 0, 0)

#define POS_BFP_OF_REAL(_af)    BFP_OF_REAL((_af), INT32_POS_FRAC)

#define MAX_POS_ERR   POS_BFP_OF_REAL(16.)

#define MAX_PPRZ 9600

#define SPEED_BFP_OF_REAL(_af)  BFP_OF_REAL((_af), INT32_SPEED_FRAC)

#define MAX_SPEED_ERR SPEED_BFP_OF_REAL(16.)

#define Min(x,y) (x < y ? x : y)

#define POS_NED_I  1

#define SPEED_NED_I   1

#define VECT2_DIFF(_c, _a, _b) {                \
    (_c).x = (_a).x - (_b).x;     \
    (_c).y = (_a).y - (_b).y;     \
  }

#define VECT2_STRIM(_v, _min, _max) {         \
    (_v).x = (_v).x < _min ? _min : (_v).x > _max ? _max : (_v).x;  \
    (_v).y = (_v).y < _min ? _min : (_v).y > _max ? _max : (_v).y;  \
  }

  #define bit_is_set(x, b) ((x >> b) & 0x1)

struct Int32Vect2 {
  int32_t x;
  int32_t y;
};

struct GuidancePID {
  // horizontal gains
  int32_t kp;
  int32_t kd;
  int32_t ki;
  int32_t kv;
  int32_t ka;
  // vertical gains
  int32_t v_kp;
  int32_t v_kd;
  int32_t v_ki;
  // outputs
  struct Int32Vect2 cmd_earth;  // Horizontal guidance command (north/east with #INT32_ANGLE_FRAC)
  int32_t cmd_thrust;           // Vertical guidance command (in pprz_t)
  // options
  bool approx_force_by_thrust;  // Correction of force commands from thrust
  bool adapt_throttle_enabled;  // Use adaptive throttle command estimation
};

struct HorizontalGuidanceSetpoint {
  /** horizontal position setpoint in NED.
   *  fixed point representation: Q23.8
   *  accuracy 0.0039, range 8388km
   */
  struct Int32Vect2 pos;
  struct Int32Vect2 speed;  ///< only used in HOVER mode if GUIDANCE_H_USE_SPEED_REF or in GUIDED mode
  struct Int32Vect2 accel;  ///< For direct control of acceleration, if the guidance scheme is able to provide it

  float heading;
  float heading_rate;

  enum {
    GUIDANCE_H_SP_POS   = 0,
    GUIDANCE_H_SP_SPEED = 1,
    GUIDANCE_H_SP_ACCEL = 2,
    GUIDANCE_H_SP_ALL   = 3
  } h_mask;
  enum {
    GUIDANCE_H_SP_YAW       = 0,
    GUIDANCE_H_SP_YAW_RATE  = 1
  } yaw_mask;
};

struct HorizontalGuidanceReference {
  struct Int32Vect2 pos;     ///< with #INT32_POS_FRAC
  struct Int32Vect2 speed;   ///< with #INT32_SPEED_FRAC
  struct Int32Vect2 accel;   ///< with #INT32_ACCEL_FRAC
};

struct HorizontalGuidanceRCInput {
  struct Int32Vect2 vect;
  float heading;
  float last_ts;
};

struct HorizontalGuidance {
  uint8_t mode;
  /* configuration options */
  bool use_ref;

  struct HorizontalGuidanceSetpoint sp;   ///< setpoints
  struct HorizontalGuidanceReference ref; ///< reference calculated from setpoints
  struct HorizontalGuidanceRCInput rc_sp; ///< remote control setpoint
};

struct EcefCoor_i {
  int32_t x; ///< in centimeters
  int32_t y; ///< in centimeters
  int32_t z; ///< in centimeters
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

struct UtmCoor_f {
  float north; ///< in meters
  float east; ///< in meters
  float alt; ///< in meters (above WGS84 reference ellipsoid or above MSL)
  uint8_t zone; ///< UTM zone number
};

struct LlaCoor_f {
  float lat; ///< in radians
  float lon; ///< in radians
  float alt; ///< in meters (normally above WGS84 reference ellipsoid)
};

struct EcefCoor_f {
  float x; ///< in meters
  float y; ///< in meters
  float z; ///< in meters
};

struct FloatRMat {
  float m[3 * 3];
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

struct EnuCoor_f {
  float x; ///< in meters
  float y; ///< in meters
  float z; ///< in meters
};

struct Int32Vect3 {
  int32_t x;
  int32_t y;
  int32_t z;
};

struct Int32Quat {
  int32_t qi;
  int32_t qx;
  int32_t qy;
  int32_t qz;
};

struct Int32Eulers {
  int32_t phi;   ///< in rad with #INT32_ANGLE_FRAC
  int32_t theta; ///< in rad with #INT32_ANGLE_FRAC
  int32_t psi;   ///< in rad with #INT32_ANGLE_FRAC
};

struct FloatQuat {
  float qi;
  float qx;
  float qy;
  float qz;
};

struct FloatEulers {
  float phi; ///< in radians
  float theta; ///< in radians
  float psi; ///< in radians
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

struct Int32Rates {
  int32_t p; ///< in rad/s with #INT32_RATE_FRAC
  int32_t q; ///< in rad/s with #INT32_RATE_FRAC
  int32_t r; ///< in rad/s with #INT32_RATE_FRAC
};

struct FloatRates {
  float p; ///< in rad/s
  float q; ///< in rad/s
  float r; ///< in rad/s
};

struct FloatVect3 {
  float x;
  float y;
  float z;
};

struct FloatVect2 {
  float x;
  float y;
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

struct AttitudeRCInput {
  struct FloatQuat    rc_quat;    ///< RC input in quaternion
  struct FloatEulers  rc_eulers;  ///< RC input in eulers (needed even for quat for yaw integration)
  float care_free_heading;        ///< care_free heading
  float transition_theta_offset;  ///< pitch offset for hybrids, add when in forward mode
  float last_ts;                  //< last timestamp (in seconds)
};

struct StabilizationSetpoint {
  enum {
    STAB_SP_QUAT,     ///< LTP to Body orientation in unit quaternion
    STAB_SP_EULERS,   ///< LTP to Body orientation in euler angles
    STAB_SP_LTP,      ///< banking and heading in LTP (NED) frame
    STAB_SP_RATES,     ///< body rates
    STAB_SP_QUAT_FF_RATE  ///< LTP to Body orientation in unit quaternion with precomputed feedforward rates
  } type;
  enum {
    STAB_SP_INT,
    STAB_SP_FLOAT
  } format;
  union {
    struct Int32Quat quat_i;
    struct FloatQuat quat_f;
    struct Int32Eulers eulers_i;
    struct FloatEulers eulers_f;
    struct { struct Int32Vect2 vect; int32_t heading; } ltp_i;
    struct { struct FloatVect2 vect; float heading; } ltp_f;
  } sp;
  union {
    struct Int32Rates rates_i;
    struct FloatRates rates_f;
  } r_sp;
};

struct Stabilization {
  uint8_t mode;                       ///< current mode
  uint8_t att_submode;                ///< current attitude sub-mode
  struct AttitudeRCInput rc_in;       ///< RC input
  struct StabilizationSetpoint rc_sp; ///< Keep it ? FIXME
  struct StabilizationSetpoint sp;    ///< current attitude setpoint (store for messages)
  int32_t cmd[COMMANDS_NB];           ///< output command vector, range from [-MAX_PPRZ:MAX_PPRZ] (store for messages)
  float transition_ratio;             ///< transition percentage for hybrids (0.: hover; 1.: forward)
};

struct ThrustSetpoint {
  enum {
    THRUST_SP,        ///< absolute thrust setpoint
    THRUST_INCR_SP    ///< thrust increment
  } type;
  enum {
    THRUST_SP_INT,    ///< int is assumed to be normalized in [0:MAX_PPRZ]
    THRUST_SP_FLOAT   ///< float is assumed to be normalized in [0.:1.]
  } format;
  union {
    int32_t thrust_i[3];
    float thrust_f[3];
    int32_t th_incr_i[3];
    float th_incr_f[3];
  } sp;
};

struct VerticalGuidance {
  uint8_t mode;

  /** altitude setpoint in meters (input).
   *  fixed point representation: Q23.8
   *  accuracy 0.0039, range 8388km
   */
  int32_t z_sp;

  /** vertical speed setpoint in meter/s (input).
   *  fixed point representation: Q12.19
   *  accuracy 0.0000019, range +/-4096
   */
  int32_t zd_sp;

  /** vertical acceleration setpoint in meter/s^2.
   *  fixed point representation: Q21.10
   *  accuracy 0.0009766, range 2097152
   */
  int32_t zdd_sp;

  /** altitude reference in meters.
   *  fixed point representation: Q23.8
   *  accuracy 0.0039, range 8388km
   */
  int32_t z_ref;

  /** vertical speed reference in meter/s.
   *  fixed point representation: Q12.19
   *  accuracy 0.0000038, range 4096
   */
  int32_t zd_ref;

  /** vertical acceleration reference in meter/s^2.
   *  fixed point representation: Q21.10
   *  accuracy 0.0009766, range 2097152
   */
  int32_t zdd_ref;

  /** Direct throttle from radio control.
   *  range 0:#MAX_PPRZ
   */
  int32_t rc_delta_t;

  /** Vertical speed setpoint from radio control.
   *  fixed point representation: Q12.19
   *  accuracy 0.0000019, range +/-4096
   */
  int32_t rc_zd_sp;

  /** input thrust setpoint.
   *  valid range 0 : #MAX_PPRZ
   */
  int32_t th_sp;

  /** Final thrust setpoint
   *  summation of feed-forward and feed-back commands,
   *  can be a total thrust or increment, float or int
   */
  struct ThrustSetpoint thrust; // FIXME maybe not needed to store the value ?

  /** nominal throttle for hover.
   * This is only used if #GUIDANCE_V_NOMINAL_HOVER_THROTTLE is defined!
   * Unit: factor of #MAX_PPRZ with range 0.1 : 0.9
   */
  float nominal_throttle;

  int32_t thrust_coeff;
};

struct GuidancePID guidance_pid;
struct Int32Vect2 guidance_pid_pos_err, guidance_pid_speed_err, guidance_pid_trim_att_integrator;
struct HorizontalGuidance guidance_h;
struct VerticalGuidance guidance_v;
struct Stabilization stabilization;
struct State state;
extern void stateCalcPositionNed_i(void);
extern void stateCalcSpeedNed_i(void);

static inline struct NedCoor_i *stateGetPositionNed_i(void)
{
  if (!bit_is_set(state.pos_status, POS_NED_I)) {
    stateCalcPositionNed_i();
  }
  return &state.ned_pos_i;
}

static inline struct NedCoor_i *stateGetSpeedNed_i(void)
{
  if (!bit_is_set(state.speed_status, SPEED_NED_I)) {
    stateCalcSpeedNed_i();
  }
  return &state.ned_speed_i;
}

struct StabilizationSetpoint stab_sp_from_ltp_i(struct Int32Vect2 *vect, int32_t heading)
{
  struct StabilizationSetpoint sp = {
    .type = STAB_SP_LTP,
    .format = STAB_SP_INT,
    .sp.ltp_i.vect = *vect,
    .sp.ltp_i.heading = heading
  };
  return sp;
}

static struct StabilizationSetpoint guidance_pid_h_run(bool in_flight, struct HorizontalGuidance *gh)
{
  /* maximum bank angle: default 20 deg, max 40 deg*/
  static const int32_t traj_max_bank = Min(BFP_OF_REAL(GUIDANCE_H_MAX_BANK, INT32_ANGLE_FRAC),
                                       BFP_OF_REAL(RadOfDeg(40), INT32_ANGLE_FRAC));
  static const int32_t total_max_bank = BFP_OF_REAL(RadOfDeg(45), INT32_ANGLE_FRAC);

  /* run PID */
  int32_t pd_x =
    ((guidance_pid.kp * guidance_pid_pos_err.x) >> (INT32_POS_FRAC - GH_GAIN_SCALE)) +
    ((guidance_pid.kd * (guidance_pid_speed_err.x >> 2)) >> (INT32_SPEED_FRAC - GH_GAIN_SCALE - 2));
  int32_t pd_y =
    ((guidance_pid.kp * guidance_pid_pos_err.y) >> (INT32_POS_FRAC - GH_GAIN_SCALE)) +
    ((guidance_pid.kd * (guidance_pid_speed_err.y >> 2)) >> (INT32_SPEED_FRAC - GH_GAIN_SCALE - 2));
  guidance_pid.cmd_earth.x = pd_x +
                           ((guidance_pid.kv * gh->ref.speed.x) >> (INT32_SPEED_FRAC - GH_GAIN_SCALE)) + /* speed feedforward gain */
                           ((guidance_pid.ka * gh->ref.accel.x) >> (INT32_ACCEL_FRAC - GH_GAIN_SCALE));  /* acceleration feedforward gain */
  guidance_pid.cmd_earth.y = pd_y +
                           ((guidance_pid.kv * gh->ref.speed.y) >> (INT32_SPEED_FRAC - GH_GAIN_SCALE)) + /* speed feedforward gain */
                           ((guidance_pid.ka * gh->ref.accel.y) >> (INT32_ACCEL_FRAC - GH_GAIN_SCALE));  /* acceleration feedforward gain */

  /* trim max bank angle from PD */
  VECT2_STRIM(guidance_pid.cmd_earth, -traj_max_bank, traj_max_bank);

  /* Update pos & speed error integral, zero it if not in_flight.
   * Integrate twice as fast when not only POS but also SPEED are wrong,
   * but do not integrate POS errors when the SPEED is already catching up.
   */
  if (in_flight) {
    /* ANGLE_FRAC (12) * GAIN (8) * LOOP_FREQ (9) -> INTEGRATOR HIGH RES ANGLE_FRAX (28) */
    guidance_pid_trim_att_integrator.x += (guidance_pid.ki * pd_x);
    guidance_pid_trim_att_integrator.y += (guidance_pid.ki * pd_y);
    /* saturate it  */
    VECT2_STRIM(guidance_pid_trim_att_integrator, -(traj_max_bank << (INT32_ANGLE_FRAC + GH_GAIN_SCALE * 2)),
                (traj_max_bank << (INT32_ANGLE_FRAC + GH_GAIN_SCALE * 2)));
    /* add it to the command */
    guidance_pid.cmd_earth.x += (guidance_pid_trim_att_integrator.x >> (INT32_ANGLE_FRAC + GH_GAIN_SCALE * 2));
    guidance_pid.cmd_earth.y += (guidance_pid_trim_att_integrator.y >> (INT32_ANGLE_FRAC + GH_GAIN_SCALE * 2));
  } else {
    INT_VECT2_ZERO(guidance_pid_trim_att_integrator);
  }

  /* compute a better approximation of force commands by taking thrust into account */
  if (guidance_pid.approx_force_by_thrust && in_flight) {
    static int32_t thrust_cmd_filt;
    // FIXME strong coupling with guidance_v here !!!
    int32_t vertical_thrust = (stabilization.cmd[COMMAND_THRUST] * guidance_v.thrust_coeff) >> INT32_TRIG_FRAC;
    thrust_cmd_filt = (thrust_cmd_filt * GUIDANCE_H_THRUST_CMD_FILTER + vertical_thrust) /
                      (GUIDANCE_H_THRUST_CMD_FILTER + 1);
    guidance_pid.cmd_earth.x = ANGLE_BFP_OF_REAL(atan2f((guidance_pid.cmd_earth.x * MAX_PPRZ / INT32_ANGLE_PI_2),
                             thrust_cmd_filt));
    guidance_pid.cmd_earth.y = ANGLE_BFP_OF_REAL(atan2f((guidance_pid.cmd_earth.y * MAX_PPRZ / INT32_ANGLE_PI_2),
                             thrust_cmd_filt));
  }

  VECT2_STRIM(guidance_pid.cmd_earth, -total_max_bank, total_max_bank);

  return stab_sp_from_ltp_i(&guidance_pid.cmd_earth, ANGLE_BFP_OF_REAL(guidance_h.sp.heading));
}

struct StabilizationSetpoint guidance_pid_h_run_pos(bool in_flight, struct HorizontalGuidance *gh)
{
  /* compute position error    */
  VECT2_DIFF(guidance_pid_pos_err, gh->ref.pos, *stateGetPositionNed_i());
  /* saturate it               */
  VECT2_STRIM(guidance_pid_pos_err, -MAX_POS_ERR, MAX_POS_ERR);

  /* compute speed error    */
  VECT2_DIFF(guidance_pid_speed_err, gh->ref.speed, *stateGetSpeedNed_i());
  /* saturate it               */
  VECT2_STRIM(guidance_pid_speed_err, -MAX_SPEED_ERR, MAX_SPEED_ERR);

  /* run PID */
  return guidance_pid_h_run(in_flight, gh);
}
