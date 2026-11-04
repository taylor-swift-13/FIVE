float sum3(float a, float b, float c) {
    return a + b + c;
}

float sum3_right(float a, float b, float c) {
    return a + (b + c);
}

float left_example(void) {
    return (16777216.0f + 1.0f) + -16777216.0f;
}

float right_example(void) {
    return 16777216.0f + (1.0f + -16777216.0f);
}
