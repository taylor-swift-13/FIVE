/*@ assigns \nothing; ensures \result == 0x3f800000; */
unsigned int bits_one(void) {
  float x = 1.0f;
  const unsigned char *p = (const unsigned char *)&x;
  return (unsigned int)p[0] | ((unsigned int)p[1] << 8) |
         ((unsigned int)p[2] << 16) | ((unsigned int)p[3] << 24);
}
