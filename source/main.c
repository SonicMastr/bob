#include "include/types.h"

#include "include/alice.h"
#include "include/defs.h"
#include "include/uart.h"
#include "include/maika.h"
#include "include/debug.h"
#include "include/ex.h"
#include "include/crypto.h"
#include "include/ernie.h"
#include "include/xbar.h"
#include "include/utils.h"
#include "include/clib.h"
#include "include/jig.h"
#include "include/gpio.h"
#include "include/perv.h"
#include "include/rpc.h"
#include "include/paddr.h"

#include "include/main.h"

static bob_config options;

void test(void);

bool ce_framework(bool bg) {
    if (options.ce_framework_parms[bg]) {
        if ((options.ce_framework_parms[bg]->magic == 0x14FF) && (options.ce_framework_parms[bg]->status == 0x34)) {
            options.ce_framework_parms[bg]->status = 0x69;

            uint32_t(*ccode)(uint32_t arg, volatile uint8_t * status_addr) = (void*)(options.ce_framework_parms[bg]->codepaddr);

            statusled(STATUS_CEFW_OFF_ICACHE);
            bool icache_stat = enable_icache(false);

            statusled(STATUS_CEFW_CCODE);
            options.ce_framework_parms[bg]->resp = ccode(options.ce_framework_parms[bg]->arg, &options.ce_framework_parms[bg]->status);

            statusled(STATUS_CEFW_ON_ICACHE);
            enable_icache(icache_stat);

            options.ce_framework_parms[bg]->status = options.ce_framework_parms[bg]->exp_status;

            statusled(STATUS_CEFW_WAIT);
            return true;
        }
    } else if (bg)
        _MEP_SLEEP_

        return false;
}

void init(bob_config* arg_config) {

    _MEP_INTR_DISABLE_ // disable interrupts

    statusled(STATUS_INIT_CEFW);

    // foreground framework (only runs from arm request)
    options.ce_framework_parms[0] = arg_config->ce_framework_parms[0];
    if (options.ce_framework_parms[0]) {
        options.ce_framework_parms[0]->resp = 0;
        if (options.ce_framework_parms[0]->exp_status)
            options.ce_framework_parms[0]->status = options.ce_framework_parms[0]->exp_status;
        ((maika_s*)(MAIKA_OFFSET))->mailbox.arm2cry[0] = -1;
    }

    // background framework (runs when idle)
    options.ce_framework_parms[1] = arg_config->ce_framework_parms[1];
    if (options.ce_framework_parms[1]) {
        options.ce_framework_parms[1]->resp = 0;
        options.ce_framework_parms[1]->status = options.ce_framework_parms[1]->exp_status;
    }

#ifndef SILENT
    statusled(STATUS_INIT_UART);
    options.uart_params = arg_config->uart_params;
    g_uart_bus = (options.uart_params & 0x0F000000) >> 0x18;
    uart_init(g_uart_bus, options.uart_params & 0xfffff);
    printf("[BOB] init bob [%X], me @ %X\n", get_build_timestamp(), init);
#endif

    // test test stuff
    options.run_tests = arg_config->run_tests;
    if (options.run_tests) {
        statusled(STATUS_INIT_TEST);
        test();
    }

    statusled(STATUS_INIT_ICACHE);

    // enable and clean icache
    enable_icache(true);
    memset((void*)F00D_ICACHE_OFFSET, 0, F00D_ICACHE_SIZE);

    statusled(STATUS_INIT_RESET);

    // jump to reset
    asm("jmp vectors_exceptions\n");
}

void test(void) {
    printf("[BOB] test test test\n");

    set_dbg_mode(true);

    _MEP_SYNC_BUS_;

    printf("[BOB] killing arm...\n");
    vp XBAR_CONFIG_REG(MAIN_XBAR, XBAR_CFG_FAMILY_ACCESS_CONTROL, XBAR_TA_MXB_DEV_LPDDR0, XBAR_ACCESS_CONTROL_WHITELIST) &= ~0b11;
    delay(0x800); // increase delay if it hangs here
    pervasive_control_reset(PERV_CTRL_RESET_DEV_ARM, 0x1000f, true, true);
    delay(0x800);
    vp XBAR_CONFIG_REG(MAIN_XBAR, XBAR_CFG_FAMILY_ACCESS_CONTROL, XBAR_TA_MXB_DEV_LPDDR0, XBAR_ACCESS_CONTROL_WHITELIST) |= 0b11;

    printf("[BOB] arm is dead, disable the OLED screen...\n");
    gpio_port_clear(0, GPIO_PORT_OLED);

    printf("[BOB] set max clock\n");
    vp 0xe3103040 = 0x10007;

    printf("[BOB] Launch Alice Linux Loader\n");

    alice_loadAlice((void*)(0x1c000000 + 0x00104000), true, 0x7, true, false, true, true);

    //rpc_loop();

    printf("[BOB] Done\n");
}