#include "filters/transport_delay.h"
void (*five_keep_init_transport_delay)(void) = (void (*)(void))init_transport_delay;
void (*five_keep_update_transport_delay)(void) = (void (*)(void))update_transport_delay;
void (*five_keep_reset_transport_delay)(void) = (void (*)(void))reset_transport_delay;
void (*five_keep_get_transport_delay)(void) = (void (*)(void))get_transport_delay;
