#include <stdint.h>
#include <pic32mx.h>
#include "mipslab.h"

int getsw(void) {
    return (PORTD >> 8) & 0x0F;
}

int getbtns(void) {
    return (PORTD >> 5) & 0x07;
}