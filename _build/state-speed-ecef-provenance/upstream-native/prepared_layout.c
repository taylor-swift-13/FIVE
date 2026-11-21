#include <stdio.h>
#include <stddef.h>
int main(void){printf("{\"state_size\":%zu,\"state_align\":%zu,\"status\":%zu,\"filter\":%zu,\"ecef_i\":%zu,\"ned_i\":%zu,\"ecef_f\":%zu,\"ned_f\":%zu,\"origin_f\":%zu}\n",sizeof(struct State),_Alignof(struct State),offsetof(struct State,speed_status),offsetof(struct State,speed_input_filter),offsetof(struct State,ecef_speed_i),offsetof(struct State,ned_speed_i),offsetof(struct State,ecef_speed_f),offsetof(struct State,ned_speed_f),offsetof(struct State,ned_origin_f));return 0;}
