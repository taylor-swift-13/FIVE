/*@ requires a == 16777216.0 && b == 1.0 && c == -16777216.0;
    assigns \nothing;
    ensures zero_result: \result == 0.0;
*/
float sum3_zero(float a,float b,float c) { return a+b+c; }
/*@ requires a == 16777216.0 && b == 1.0 && c == -16777216.0;
    assigns \nothing;
    ensures one_result: \result == 1.0;
*/
float sum3_one(float a,float b,float c) { return a+b+c; }
