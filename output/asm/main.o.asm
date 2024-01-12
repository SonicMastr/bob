	.file	"main.c"
	.section .farbss,"aw"
	.p2align 2
	.type	options,@object
	.size	options,16
options:
	.zero	16
	.text
	.core
	.p2align 1
	.globl ce_framework
	.type	ce_framework, @function
ce_framework:
	# frame: 32   32 regs
	add	$sp, -32
	sw	$5, 20($sp)
	movh	$5, %hi(options)
	add3	$5, $5, %lo(options)
	sll3	$0, $1, 2
	ldc	$11, $lp
	add3	$5, $5, $0
	sw	$6, 16($sp)
	sw	$7, 12($sp)
	sw	$8, 8($sp)
	sw	$11, 4($sp)
	lw	$3, ($5)
	beqz	$3, .L2
	lhu	$1, ($3)
	mov	$2, 5375 # 0x14ff
	bne	$1, $2, .L6
	lb	$2, 3($3)
	mov	$1, 52
	extub	$2
	bne	$2, $1, .L6
	mov	$2, 105
	sb	$2, 3($3)
	lw	$8, 4($3)
	mov	$1, 0
	bsr	enable_icache
	lw	$6, ($5)
	mov	$7, $0
	add3	$2, $6, 3
	lw	$1, 8($6)
	jsr	$8
	sw	$0, 12($6)
	mov	$1, $7
	bsr	enable_icache
	lw	$3, ($5)
	mov	$0, 1
	lb	$2, 2($3)
	sb	$2, 3($3)
.L1:
	lw	$8, 8($sp)
	lw	$7, 12($sp)
	lw	$6, 16($sp)
	lw	$5, 20($sp)
	lw	$11, 4($sp)
	add3	$sp, $sp, 32
	jmp	$11
.L2:
	beqz	$1, .L6
	sleep
	mov	$0, 0
	bra	.L1
.L6:
	mov	$0, 0
	bra	.L1
	.size	ce_framework, .-ce_framework
	.section	.rodata
	.p2align 2
.LC0:
	.string	"[BOB] init bob [%X], me @ %X\n"
	.text
	.core
	.p2align 1
	.globl init
	.type	init, @function
init:
	# frame: 24   24 regs
	add	$sp, -24
	sw	$6, 8($sp)
	ldc	$11, $lp
	mov	$6, $1
	sw	$5, 12($sp)
	sw	$11, 4($sp)
	di
	movh	$2, %hi(options)
	lw	$3, ($1)
	mov	$5, $2
	sw	$3, %lo(options)($2)
	beqz	$3, .L8
	mov	$2, 0
	sw	$2, 12($3)
	lb	$2, 2($3)
	extub	$2
	beqz	$2, .L9
	lb	$2, 2($3)
	sb	$2, 3($3)
.L9:
	mov	$2, -1 # 0xffff
	movh	$3, 0xe000
	sw	$2, 16($3)
.L8:
	lw	$3, 4($6)
	mov	$2, $5
	add3	$2, $2, %lo(options)
	sw	$3, 4($2)
	beqz	$3, .L10
	mov	$2, 0
	sw	$2, 12($3)
	lb	$2, 2($3)
	sb	$2, 3($3)
.L10:
	lw	$2, 8($6)
	movh	$3, %hi(g_uart_bus)
	add3	$5, $5, %lo(options)
	mov	$1, $2
	sw	$2, 8($5)
	srl	$1, 24
	and3	$1, $1, 0xf
	sw	$1, %lo(g_uart_bus)($3)
	movu	$3, 1048575
	and	$2, $3
	bsr	uart_init
	bsr	get_build_timestamp
	mov	$2, $0
	movu	$3, init
	movu	$1, .LC0
	bsr	debug_printFormat
	lw	$3, 12($6)
	sw	$3, 12($5)
	beqz	$3, .L11
	bsr	test
.L11:
	mov	$1, 1
	bsr	enable_icache
	movh	$3, 0x1
	mov	$2, 0
	movh	$1, 0x30
	bsr	memset
#APP
;# 99 "source/main.c" 1
	jmp vectors_exceptions

;# 0 "" 2
#NO_APP
	lw	$6, 8($sp)
	lw	$5, 12($sp)
	lw	$11, 4($sp)
	add	$sp, 24
	jmp	$11
	.size	init, .-init
	.section	.rodata
	.p2align 2
.LC1:
	.string	"[BOB] test test test\n"
	.p2align 2
.LC2:
	.string	"[BOB] killing arm...\n"
	.p2align 2
.LC3:
	.string	"[BOB] arm is dead, disable the OLED screen...\n"
	.p2align 2
.LC4:
	.string	"[BOB] set max clock\n"
	.p2align 2
.LC5:
	.string	"[BOB] Launch Alice Linux Loader\n"
	.p2align 2
.LC6:
	.string	"[BOB] Done\n"
	.text
	.core
	.p2align 1
	.globl test
	.type	test, @function
test:
	# frame: 32   16 regs   12 args
	add	$sp, -32
	ldc	$11, $lp
	movu	$1, .LC1
	sw	$11, 16($sp)
	sw	$5, 20($sp)
	bsr	debug_printFormat
	mov	$1, 1
	bsr	set_dbg_mode
	syncm
	movh	$5, 0xec06
	or3	$5, $5, 0x448
	movu	$1, .LC2
	bsr	debug_printFormat
	lw	$3, ($5)
	mov	$2, -4 # 0xfffc
	mov	$1, 2048 # 0x800
	and	$3, $2
	sw	$3, ($5)
	bsr	delay
	mov	$4, 1
	movu	$2, 65551
	mov	$3, 1
	mov	$1, 0
	bsr	pervasive_control_reset
	mov	$1, 2048 # 0x800
	bsr	delay
	lw	$3, ($5)
	movu	$1, .LC3
	or3	$3, $3, 0x3
	sw	$3, ($5)
	bsr	debug_printFormat
	mov	$2, 0
	mov	$1, 0
	bsr	gpio_port_clear
	movu	$1, .LC4
	bsr	debug_printFormat
	movh	$3, 0xe310
	or3	$3, $3, 0x3040
	movu	$2, 65543
	sw	$2, ($3)
	movu	$1, .LC5
	bsr	debug_printFormat
	mov	$3, 1
	sw	$3, 8($sp)
	sw	$3, 4($sp)
	movh	$1, 0x1c10
	mov	$3, 0
	sw	$3, ($sp)
	mov	$4, 1
	mov	$3, 7
	mov	$2, 1
	or3	$1, $1, 0x4000
	bsr	alice_loadAlice
	movu	$1, .LC6
	bsr	debug_printFormat
	lw	$5, 20($sp)
	lw	$11, 16($sp)
	add3	$sp, $sp, 32
	jmp	$11
	.size	test, .-test
	.ident	"GCC: (WTF TEAM MOLECULE IS AT IT AGAIN?!) 6.3.0"
