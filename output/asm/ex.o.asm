	.file	"ex.c"
	.section	.rodata
	.p2align 2
.LC0:
	.string	"[BOB] warning: did reset\n"
	.text
	.core
	.p2align 1
	.globl c_RESET
	.type	c_RESET, @function
c_RESET:
	# frame: 24   24 regs
	add	$sp, -24
	sw	$5, 12($sp)
	sw	$6, 8($sp)
	sw	$tp, 20($sp)
	sw	$gp, 16($sp)
	ldc	$11, $lp
	sw	$11, 4($sp)
	mov	$5, $tp
	mov	$6, $gp
	mov	$tp, $5
	mov	$gp, $6
	bsr	debug_s_regdump
	mov	$3, 0
	stc	$3, $exc
	mov	$3, 0
	stc	$3, $tmp
	movh	$3, %hi(g_uart_bus)
	add3	$3, $3, %lo(g_uart_bus)
	lw	$3, ($3)
	movu	$2, .LC0
	mov	$1, $3
	mov	$tp, $5
	mov	$gp, $6
	bsr	uart_print
	ei
.L2:
	mov	$1, 1
	mov	$tp, $5
	mov	$gp, $6
	bsr	ce_framework
	bra	.L2
	.size	c_RESET, .-c_RESET
	.section	.rodata
	.p2align 2
.LC1:
	.string	"[BOB] entering SWI %X %X %X %X\n"
	.p2align 2
.LC2:
	.string	"[BOB] exiting SWI\n"
	.text
	.core
	.p2align 1
	.globl c_SWI
	.type	c_SWI, @function
c_SWI:
	# frame: 48   24 regs   16 locals   4 args
	add3	$sp, $sp, -48 # 0xffd0
	sw	$5, 36($sp)
	sw	$6, 32($sp)
	sw	$tp, 44($sp)
	sw	$gp, 40($sp)
	ldc	$11, $lp
	sw	$11, 28($sp)
	mov	$5, $tp
	mov	$6, $gp
	sw	$1, 20($sp)
	sw	$2, 16($sp)
	sw	$3, 12($sp)
	sw	$4, 8($sp)
	lw	$3, 8($sp)
	sw	$3, ($sp)
	lw	$4, 12($sp)
	lw	$3, 16($sp)
	lw	$2, 20($sp)
	movu	$1, .LC1
	mov	$tp, $5
	mov	$gp, $6
	bsr	debug_printFormat
	mov	$1, 24576 # 0x6000
	mov	$tp, $5
	mov	$gp, $6
	bsr	delay
	movh	$3, %hi(g_uart_bus)
	add3	$3, $3, %lo(g_uart_bus)
	lw	$3, ($3)
	movu	$2, .LC2
	mov	$1, $3
	mov	$tp, $5
	mov	$gp, $6
	bsr	uart_print
	nop
	lw	$gp, 40($sp)
	lw	$tp, 44($sp)
	lw	$6, 32($sp)
	lw	$5, 36($sp)
	lw	$11, 28($sp)
	add3	$sp, $sp, 48
	jmp	$11
	.size	c_SWI, .-c_SWI
	.section	.rodata
	.p2align 2
.LC3:
	.string	"[BOB] entering IRQ\n"
	.p2align 2
.LC4:
	.string	"[BOB] exiting IRQ\n"
	.text
	.core
	.p2align 1
	.globl c_IRQ
	.type	c_IRQ, @function
c_IRQ:
	# frame: 24   24 regs
	add	$sp, -24
	sw	$5, 12($sp)
	sw	$6, 8($sp)
	sw	$tp, 20($sp)
	sw	$gp, 16($sp)
	ldc	$11, $lp
	sw	$11, 4($sp)
	mov	$5, $tp
	mov	$6, $gp
	movh	$3, %hi(g_uart_bus)
	add3	$3, $3, %lo(g_uart_bus)
	lw	$3, ($3)
	movu	$2, .LC3
	mov	$1, $3
	mov	$tp, $5
	mov	$gp, $6
	bsr	uart_print
	mov	$1, 24576 # 0x6000
	mov	$tp, $5
	mov	$gp, $6
	bsr	delay
	movh	$3, %hi(g_uart_bus)
	add3	$3, $3, %lo(g_uart_bus)
	lw	$3, ($3)
	movu	$2, .LC4
	mov	$1, $3
	mov	$tp, $5
	mov	$gp, $6
	bsr	uart_print
	nop
	lw	$gp, 16($sp)
	lw	$tp, 20($sp)
	lw	$6, 8($sp)
	lw	$5, 12($sp)
	lw	$11, 4($sp)
	add	$sp, 24
	jmp	$11
	.size	c_IRQ, .-c_IRQ
	.section	.rodata
	.p2align 2
.LC5:
	.string	"[BOB] entering ARM req %X\n"
	.p2align 2
.LC6:
	.string	"[BOB] exiting ARM req %X\n"
	.text
	.core
	.p2align 1
	.globl c_ARM_REQ
	.type	c_ARM_REQ, @function
c_ARM_REQ:
	# frame: 32   24 regs   8 locals
	add	$sp, -32
	sw	$5, 20($sp)
	sw	$6, 16($sp)
	sw	$tp, 28($sp)
	sw	$gp, 24($sp)
	ldc	$11, $lp
	sw	$11, 12($sp)
	mov	$5, $tp
	mov	$6, $gp
	movh	$3, 0xe000
	sw	$3, 4($sp)
	lw	$3, 4($sp)
	lw	$3, 16($3)
	sw	$3, ($sp)
	lw	$2, ($sp)
	movu	$1, .LC5
	mov	$tp, $5
	mov	$gp, $6
	bsr	debug_printFormat
	mov	$1, 0
	mov	$tp, $5
	mov	$gp, $6
	bsr	ce_framework
	mov	$3, $0
	bnez	$3, .L6
	lw	$3, 4($sp)
	lw	$2, 20($3)
	lw	$3, 4($sp)
	lw	$1, 24($3)
	lw	$3, 4($sp)
	lw	$3, 28($3)
	mov	$4, $3
	mov	$3, $1
	lw	$1, ($sp)
	mov	$tp, $5
	mov	$gp, $6
	bsr	compat_IRQ7_handleCmd
.L6:
	lw	$2, ($sp)
	movu	$1, .LC6
	mov	$tp, $5
	mov	$gp, $6
	bsr	debug_printFormat
	movh	$3, 0xe000
	mov	$2, -1 # 0xffff
	sw	$2, 16($3)
	nop
	lw	$gp, 24($sp)
	lw	$tp, 28($sp)
	lw	$6, 16($sp)
	lw	$5, 20($sp)
	lw	$11, 12($sp)
	add3	$sp, $sp, 32
	jmp	$11
	.size	c_ARM_REQ, .-c_ARM_REQ
	.section	.rodata
	.p2align 2
.LC7:
	.string	"[BOB] UNK INTERRUPT: %X @ %X\n"
	.text
	.core
	.p2align 1
	.globl c_OTHER_INT
	.type	c_OTHER_INT, @function
c_OTHER_INT:
	# frame: 24   24 regs
	add	$sp, -24
	sw	$5, 12($sp)
	sw	$6, 8($sp)
	sw	$tp, 20($sp)
	sw	$gp, 16($sp)
	ldc	$11, $lp
	sw	$11, 4($sp)
	mov	$5, $tp
	mov	$6, $gp
	mov	$tp, $5
	mov	$gp, $6
	bsr	debug_s_regdump
	di
	ldc	$2, $exc
	ldc	$3, $epc
	movu	$1, .LC7
	mov	$tp, $5
	mov	$gp, $6
	bsr	debug_printFormat
	halt
.L8:
	bra	.L8
	.size	c_OTHER_INT, .-c_OTHER_INT
	.section	.rodata
	.p2align 2
.LC8:
	.string	"[BOB] UNK EXCEPTION: %X @ %X\n"
	.text
	.core
	.p2align 1
	.globl c_OTHER_EXC
	.type	c_OTHER_EXC, @function
c_OTHER_EXC:
	# frame: 24   24 regs
	add	$sp, -24
	sw	$5, 12($sp)
	sw	$6, 8($sp)
	sw	$tp, 20($sp)
	sw	$gp, 16($sp)
	ldc	$11, $lp
	sw	$11, 4($sp)
	mov	$5, $tp
	mov	$6, $gp
	mov	$tp, $5
	mov	$gp, $6
	bsr	debug_s_regdump
	di
	ldc	$2, $exc
	ldc	$3, $epc
	movu	$1, .LC8
	mov	$tp, $5
	mov	$gp, $6
	bsr	debug_printFormat
	halt
.L10:
	bra	.L10
	.size	c_OTHER_EXC, .-c_OTHER_EXC
	.section	.rodata
	.p2align 2
.LC9:
	.string	"[BOB] PANIC: %s | %X\n"
	.text
	.core
	.p2align 1
	.globl PANIC
	.type	PANIC, @function
PANIC:
	# frame: 32   24 regs   8 locals
	add	$sp, -32
	sw	$5, 20($sp)
	sw	$6, 16($sp)
	sw	$tp, 28($sp)
	sw	$gp, 24($sp)
	ldc	$11, $lp
	sw	$11, 12($sp)
	mov	$5, $tp
	mov	$6, $gp
	sw	$1, 4($sp)
	sw	$2, ($sp)
	mov	$tp, $5
	mov	$gp, $6
	bsr	debug_s_regdump
	di
	lw	$3, ($sp)
	lw	$2, 4($sp)
	movu	$1, .LC9
	mov	$tp, $5
	mov	$gp, $6
	bsr	debug_printFormat
	halt
.L12:
	bra	.L12
	.size	PANIC, .-PANIC
	.section	.rodata
	.p2align 2
.LC10:
	.string	"[BOB] GOT DBG INTERRUPT\n"
	.text
	.core
	.p2align 1
	.globl c_DBG
	.type	c_DBG, @function
c_DBG:
	# frame: 16   16 regs
	add	$sp, -16
	sw	$tp, 12($sp)
	sw	$gp, 8($sp)
	ldc	$11, $lp
	sw	$11, 4($sp)
	movh	$3, %hi(g_uart_bus)
	add3	$3, $3, %lo(g_uart_bus)
	lw	$3, ($3)
	movu	$2, .LC10
	mov	$1, $3
	bsr	uart_print
	nop
	lw	$gp, 8($sp)
	lw	$tp, 12($sp)
	lw	$11, 4($sp)
	add	$sp, 16
	jmp	$11
	.size	c_DBG, .-c_DBG
	.p2align 1
	.globl set_exception_table
	.type	set_exception_table, @function
set_exception_table:
	# frame: 16   16 regs
	add	$sp, -16
	ldc	$11, $lp
	sw	$11, 4($sp)
	mov	$3, 52
	beqz	$1, .L15
	movh	$2, %hi(jmp_s_glitch_xc)
	movh	$1, %hi(vectors_exceptions)
	lw	$2, %lo(jmp_s_glitch_xc)($2)
	add3	$1, $1, %lo(vectors_exceptions)
	bsr	memset32
.L14:
	lw	$11, 4($sp)
	add	$sp, 16
	jmp	$11
.L15:
	movh	$2, %hi(jmp_c_other_xc)
	movh	$1, %hi(vectors_exceptions)
	lw	$2, %lo(jmp_c_other_xc)($2)
	add3	$1, $1, %lo(vectors_exceptions)
	bsr	memset32
	movh	$2, %hi(jmp_s_reset_xc)
	movh	$3, %hi(vectors_exceptions)
	lw	$2, %lo(jmp_s_reset_xc)($2)
	add3	$3, $3, %lo(vectors_exceptions)
	sw	$2, ($3)
	movh	$2, %hi(jmp_s_swi_xc)
	lw	$2, %lo(jmp_s_swi_xc)($2)
	sw	$2, 20($3)
	movh	$2, %hi(jmp_s_dbg_xc)
	lw	$2, %lo(jmp_s_dbg_xc)($2)
	sw	$2, 24($3)
	bra	.L14
	.size	set_exception_table, .-set_exception_table
	.ident	"GCC: (WTF TEAM MOLECULE IS AT IT AGAIN?!) 6.3.0"
