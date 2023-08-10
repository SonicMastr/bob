#include "include/types.h"
#include "include/defs.h"
#include "include/utils.h"
#include "include/debug.h"
#include "include/paddr.h"
#include "include/maika.h"
#include "include/perv.h"
#include "include/rpc.h"
#include "include/clib.h"

#include "include/alice.h"

void alice_armReBoot(int armClk, bool hasCS, bool hasUnk) {
    vp PERV_GET_REG(PERV_CTRL_GATE, PERV_CTRL_GATE_DEV_ARM) = 0;
    while (vp PERV_GET_REG(PERV_CTRL_GATE, PERV_CTRL_GATE_DEV_ARM))
        ;
    if (hasCS) {
        vp PERV_GET_REG(PERV_CTRL_GATE, PERV_CTRL_GATE_DEV_ARM_CS) = 0;
        while (vp PERV_GET_REG(PERV_CTRL_GATE, PERV_CTRL_GATE_DEV_ARM_CS))
            ;
    }
    vp PERV_GET_REG(PERV_CTRL_RESET, PERV_CTRL_RESET_DEV_ARM) = 0x1000f;
    while (vp PERV_GET_REG(PERV_CTRL_RESET, PERV_CTRL_RESET_DEV_ARM) != 0x1000f)
        ;
    if (hasCS) {
        vp PERV_GET_REG(PERV_CTRL_RESET, PERV_CTRL_RESET_DEV_ARM_CS) = 1;
        while (vp PERV_GET_REG(PERV_CTRL_RESET, PERV_CTRL_RESET_DEV_ARM_CS) != 1)
            ;
    }
    uint32_t dev_96_clk = vp PERV_GET_REG(PERV_CTRL_GATE, 96);
    vp PERV_GET_REG(PERV_CTRL_GATE, 96) = (dev_96_clk & 0xffffff7f);
    while (vp PERV_GET_REG(PERV_CTRL_GATE, 96) != (dev_96_clk & 0xffffff7f))
        ;
    vp PERV_GET_REG(PERV_CTRL_RESET, 97) = 0;
    while (vp PERV_GET_REG(PERV_CTRL_RESET, 97))
        ;
    vp PERV_GET_REG(PERV_CTRL_GATE, 96) = (dev_96_clk | 0x80);
    while (vp PERV_GET_REG(PERV_CTRL_GATE, 96) != (dev_96_clk | 0x80))
        ;
    vp PERV_GET_REG(PERV_CTRL_BASECLK, 0) = 1;
    while (vp PERV_GET_REG(PERV_CTRL_BASECLK, 0) != 1)
        ;
    vp PERV_GET_REG(PERV_CTRL_MISC, 0xC) = 0;
    while (vp PERV_GET_REG(PERV_CTRL_MISC, 0xC))
        ;
    vp PERV_GET_REG(PERV_CTRL_MISC, 0x14) = 1;
    while (vp PERV_GET_REG(PERV_CTRL_MISC, 0x14) != 1)
        ;
    while (vp PERV_GET_REG(PERV_CTRL_MISC, 0x30) != 1)
        ;
    vp PERV_GET_REG(PERV_CTRL_MISC, 0x30) = 1;
    while (vp PERV_GET_REG(PERV_CTRL_MISC, 0x30) == 1)
        ;
    vp PERV_GET_REG(PERV_CTRL_GATE, PERV_CTRL_GATE_DEV_ARM) = 0xc00000;
    while (vp PERV_GET_REG(PERV_CTRL_GATE, PERV_CTRL_GATE_DEV_ARM) != 0xc00000)
        ;
    vp PERV_GET_REG(PERV_CTRL_GATE, PERV_CTRL_GATE_DEV_ARM) = 0;
    while (vp PERV_GET_REG(PERV_CTRL_GATE, PERV_CTRL_GATE_DEV_ARM))
        ;
    vp PERV_GET_REG(PERV_CTRL_BASECLK, 0) = armClk & 0xf;
    while (vp PERV_GET_REG(PERV_CTRL_BASECLK, 0) != (armClk & 0xf))
        ;
    vp 0xe3110c00 = hasUnk & 1;
    while (vp 0xe3110c00 != (hasUnk & 1))
        ;
    vp PERV_GET_REG(PERV_CTRL_GATE, PERV_CTRL_GATE_DEV_ARM) = hasCS ? 0xc10000 : 0x10000;
    while (!(vp PERV_GET_REG(PERV_CTRL_GATE, PERV_CTRL_GATE_DEV_ARM)))
        ;
    if (hasCS) {
        vp PERV_GET_REG(PERV_CTRL_GATE, PERV_CTRL_GATE_DEV_ARM_CS) = 1;
        while (vp PERV_GET_REG(PERV_CTRL_GATE, PERV_CTRL_GATE_DEV_ARM_CS) != 1)
            ;
        vp PERV_GET_REG(PERV_CTRL_RESET, PERV_CTRL_RESET_DEV_ARM_CS) = 0;
        while (vp PERV_GET_REG(PERV_CTRL_RESET, PERV_CTRL_RESET_DEV_ARM_CS))
            ;
    }
    vp PERV_GET_REG(PERV_CTRL_RESET, PERV_CTRL_RESET_DEV_ARM) = 0;
    while (vp PERV_GET_REG(PERV_CTRL_RESET, PERV_CTRL_RESET_DEV_ARM))
        ;
}

void alice_setupInts(void) {
    cbus_write(3, 0);
    cbus_write(4, 0x07777777);
    cbus_write(5, 0x777f);
    cbus_write(6, 0);
    cbus_write(7, 0);
    cbus_write(0, 0x600);
    cbus_write(2, 0x100);
    asm(
        "ldc $0, $psw\n"
        "or3 $0, $0, 0x110\n"
        "stc $0, $psw\n"
    );
}

int alice_handleCmd(void) {
    void* exec_paddr = 0;
    maika_s* maika = (maika_s*)MAIKA_OFFSET;
    uint32_t cmd = maika->mailbox.arm2cry[0];

    printf("[BOB] got alice cmd %X (%X, %X, %X)\n", cmd, maika->mailbox.arm2cry[1], maika->mailbox.arm2cry[2], maika->mailbox.arm2cry[3]);

    if (cmd & 0x80000000 && cmd != ALICE_RELINQUISH_CMD) {
        if (cmd & 1)
            exec_paddr = (void*)(cmd & 0xFFFFFFFE);
        else
            exec_paddr = (void*)(cmd & 0x7FFFFFFE);
        uint32_t (*exec_func)(uint32_t a, uint32_t b, uint32_t c) = (void*)exec_paddr;
        maika->mailbox.cry2arm[1] = exec_func(maika->mailbox.arm2cry[1], maika->mailbox.arm2cry[2], maika->mailbox.arm2cry[3]);
        maika->mailbox.arm2cry[0] = -1;
        return -1;
    }

    switch (cmd) {
    case ALICE_RELINQUISH_CMD:
        printf("[BOB] alice service terminated\n");
        maika->mailbox.arm2cry[0] = -1;
        return 0;
        break;
    case ALICE_A2B_GET_RPC_STATUS:
        maika->mailbox.cry2arm[1] = g_rpc_status;
        break;
    case ALICE_A2B_SET_RPC_STATUS:
        g_rpc_status = maika->mailbox.arm2cry[1];
        break;
    case ALICE_A2B_MASK_RPC_STATUS:
        if (maika->mailbox.arm2cry[2])
            g_rpc_status |= (maika->mailbox.arm2cry[1]);
        else
            g_rpc_status &= ~(maika->mailbox.arm2cry[1]);
        maika->mailbox.cry2arm[1] = g_rpc_status;
        break;
    case ALICE_A2B_REBOOT:
        alice_armReBoot(maika->mailbox.arm2cry[1], maika->mailbox.arm2cry[2], maika->mailbox.arm2cry[3]);
        break;
    case ALICE_A2B_MEMCPY:
        memcpy((void*)maika->mailbox.arm2cry[1], (void*)maika->mailbox.arm2cry[2], maika->mailbox.arm2cry[3]);
        break;
    case ALICE_A2B_MEMSET:
        memset((void*)maika->mailbox.arm2cry[1], (maika->mailbox.arm2cry[2] & 0xFF), maika->mailbox.arm2cry[3]);
        break;
    case ALICE_A2B_MEMSET32:
        memset32((void*)maika->mailbox.arm2cry[1], maika->mailbox.arm2cry[2], maika->mailbox.arm2cry[3]);
        break;
    case ALICE_A2B_READ32:
        maika->mailbox.cry2arm[1] = vp maika->mailbox.arm2cry[1];
        break;
    case ALICE_A2B_WRITE32:
        vp maika->mailbox.arm2cry[1] = vp maika->mailbox.arm2cry[2];
        break;
    default:
        break;
    }

    maika->mailbox.arm2cry[3] = -1;
    maika->mailbox.arm2cry[2] = -1;
    maika->mailbox.arm2cry[1] = -1;
    maika->mailbox.arm2cry[0] = -1;

    return -1;
}