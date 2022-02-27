#include "include/types.h"
#include "include/utils.h"
#include "include/gpio.h"

void gpio_set_port_mode(int bus, int port, int mode) {
    volatile unsigned int* gpio_regs = GPIO_REGS(bus);
    gpio_regs[0] = (gpio_regs[0] & ~(1 << port)) | (mode << port);
    _MEP_SYNC_BUS_
}

int gpio_port_read(int bus, int port) {
    volatile unsigned int* gpio_regs = GPIO_REGS(bus);
    return (gpio_regs[1] >> port) & 1;
}

void gpio_port_set(int bus, int port) {
    volatile unsigned int* gpio_regs = GPIO_REGS(bus);
    gpio_regs[2] |= 1 << port;
    gpio_regs[0xD];
    _MEP_SYNC_BUS_
}

void gpio_port_clear(int bus, int port) {
    volatile unsigned int* gpio_regs = GPIO_REGS(bus);
    gpio_regs[3] |= 1 << port;
    gpio_regs[0xD];
    _MEP_SYNC_BUS_
}

int gpio_query_intr(int bus, int port) {
    volatile unsigned int* gpio_regs = GPIO_REGS(bus);
    return (1 << port) & ((gpio_regs[0x0E] & ~gpio_regs[0x07]) |
        (gpio_regs[0x0F] & ~gpio_regs[0x08]) |
        (gpio_regs[0x10] & ~gpio_regs[0x09]) |
        (gpio_regs[0x11] & ~gpio_regs[0x0A]) |
        (gpio_regs[0x12] & ~gpio_regs[0x0B]));
}

int gpio_acquire_intr(int bus, int port) {
    unsigned int ret;
    unsigned int mask = 1 << port;
    volatile unsigned int* gpio_regs = GPIO_REGS(bus);
    ret = mask & ((gpio_regs[0x0E] & ~gpio_regs[0x07]) |
        (gpio_regs[0x0F] & ~gpio_regs[0x08]) |
        (gpio_regs[0x10] & ~gpio_regs[0x09]) |
        (gpio_regs[0x11] & ~gpio_regs[0x0A]) |
        (gpio_regs[0x12] & ~gpio_regs[0x0B]));
    gpio_regs[0x0E] = mask;
    gpio_regs[0x0F] = mask;
    gpio_regs[0x10] = mask;
    gpio_regs[0x11] = mask;
    gpio_regs[0x12] = mask;
    _MEP_SYNC_BUS_
    return ret;
}