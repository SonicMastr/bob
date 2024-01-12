	.file	"ernie.c"
	.section .farbss,"aw"
	.globl	g_ernie_comms
	.p2align 0
	.type	g_ernie_comms,@object
	.size	g_ernie_comms,64
g_ernie_comms:
	.zero	64
	.section .frodata,"a"
	.p2align 2
	.type	ernie_3auth_B_key1, @object
	.size	ernie_3auth_B_key1, 16
ernie_3auth_B_key1:
	.zero	16
	.p2align 2
	.type	ernie_3auth_B_data1, @object
	.size	ernie_3auth_B_data1, 16
ernie_3auth_B_data1:
	.zero	16
	.text
	.core
	.p2align 1
	.globl ernie_write
	.type	ernie_write, @function
ernie_write:
	# frame: 24   24 regs
	add	$sp, -24
	ldc	$11, $lp
	sw	$5, 12($sp)
	sw	$6, 8($sp)
	mov	$5, $1
	and3	$6, $2, 255
	mov	$1, 0
	mov	$2, 3
	sw	$7, 4($sp)
	sw	$11, ($sp)
	bsr	gpio_port_clear
	mov	$1, 0
	bsr	spi_write_start
	mov	$7, $5
.L2:
	mov	$0, $7
	sub	$0, $5
	slt3	$0, $0, $6
	bnez	$0, .L3
	mov	$1, 0
	bsr	spi_write_end
	mov	$2, 3
	mov	$1, 0
	bsr	gpio_port_set
	lw	$7, 4($sp)
	lw	$6, 8($sp)
	lw	$5, 12($sp)
	lw	$11, ($sp)
	add	$sp, 24
	jmp	$11
.L3:
	lbu	$3, 1($7)
	lbu	$2, ($7)
	mov	$1, 0
	add	$7, 2
	sll	$3, 8
	or	$2, $3
	bsr	spi_write
	bra	.L2
	.size	ernie_write, .-ernie_write
	.p2align 1
	.globl ernie_read
	.type	ernie_read, @function
ernie_read:
	# frame: 32   32 regs
	add	$sp, -32
	sw	$6, 16($sp)
	sw	$7, 12($sp)
	ldc	$11, $lp
	mov	$7, $1
	and3	$6, $2, 255
	sw	$5, 20($sp)
	sw	$8, 8($sp)
	sw	$11, 4($sp)
.L5:
	mov	$2, 4
	mov	$1, 0
	bsr	gpio_query_intr
	beqz	$0, .L5
	mov	$2, 4
	mov	$1, 0
	bsr	gpio_acquire_intr
	mov	$5, 0
.L6:
	mov	$1, 0
	bsr	spi_read_available
	mov	$8, $0
	bnez	$0, .L9
.L7:
	mov	$1, 0
	bsr	spi_read_end
	mov	$2, 3
	mov	$1, 0
	bsr	gpio_port_clear
	mov	$0, $8
	lw	$7, 12($sp)
	lw	$8, 8($sp)
	lw	$6, 16($sp)
	lw	$5, 20($sp)
	lw	$11, 4($sp)
	add3	$sp, $sp, 32
	jmp	$11
.L9:
	sltu3	$0, $5, $6
	beqz	$0, .L10
	mov	$1, 0
	bsr	spi_read
	add3	$2, $7, $5
	add3	$3, $5, 1
	mov	$1, $0
	sb	$0, ($2)
	slt3	$0, $3, $6
	beqz	$0, .L8
	mov	$0, $1
	srl	$0, 8
	sb	$0, 1($2)
.L8:
	add	$5, 2
	extub	$5
	bra	.L6
.L10:
	mov	$8, 1
	bra	.L7
	.size	ernie_read, .-ernie_read
	.p2align 1
	.globl ernie_exec
	.type	ernie_exec, @function
ernie_exec:
	# frame: 32   32 regs
	add	$sp, -32
	ldc	$11, $lp
	sw	$6, 16($sp)
	sw	$7, 12($sp)
	sw	$8, 8($sp)
	sw	$5, 20($sp)
	sw	$11, 4($sp)
	mov	$7, $1
	extub	$2
	mov	$8, $3
	and3	$6, $4, 255
	beqz	$1, .L19
	beqz	$3, .L19
	sltu3	$3, $2, 4
	bnez	$3, .L21
	sltu3	$3, $6, 5
	bnez	$3, .L21
	lbu	$5, 2($1)
	add	$2, -3
	slt3	$0, $5, $2
	beqz	$0, .L22
	add3	$3, $5, 1
	sb	$3, 2($1)
	mov	$2, 0
	mov	$3, 0
	add3	$1, $5, 2
.L15:
	slt3	$0, $1, $2
	beqz	$0, .L16
	add3	$2, $7, $5
	nor	$3, $3
	add	$5, 4
	sb	$3, 3($2)
.L17:
	mov	$3, $6
	mov	$2, -1
	mov	$1, $8
	bsr	memset
	mov	$2, $5
	mov	$1, $7
	bsr	ernie_write
	mov	$2, $6
	mov	$1, $8
	bsr	ernie_read
	lbu	$0, 3($8)
	xor3	$3, $0, 0x80
	sltu3	$3, $3, 2
	bnez	$3, .L17
.L13:
	lw	$8, 8($sp)
	lw	$7, 12($sp)
	lw	$6, 16($sp)
	lw	$5, 20($sp)
	lw	$11, 4($sp)
	add3	$sp, $sp, 32
	jmp	$11
.L16:
	add3	$0, $7, $2
	add	$2, 1
	lb	$0, ($0)
	extub	$2
	add3	$3, $3, $0
	extub	$3
	bra	.L15
.L19:
	mov	$0, -1 # 0xffff
	bra	.L13
.L21:
	mov	$0, -2 # 0xfffe
	bra	.L13
.L22:
	mov	$0, -3 # 0xfffd
	bra	.L13
	.size	ernie_exec, .-ernie_exec
	.p2align 1
	.globl ernie_exec_cmd
	.type	ernie_exec_cmd, @function
ernie_exec_cmd:
	# frame: 24   24 regs
	add	$sp, -24
	sw	$6, 8($sp)
	and3	$6, $3, 255
	ldc	$11, $lp
	slt3	$3, $6, 29
	sw	$5, 12($sp)
	sw	$7, 4($sp)
	sw	$11, ($sp)
	and3	$5, $1, 65535
	mov	$7, $2
	beqz	$3, .L27
	movh	$1, %hi(g_ernie_comms)
	add3	$1, $1, %lo(g_ernie_comms)
	mov	$3, 64
	mov	$2, 0
	bsr	memset
	movh	$1, %hi(g_ernie_comms)
	add3	$1, $1, %lo(g_ernie_comms)
	sb	$5, ($1)
	srl	$5, 8
	sb	$5, 1($1)
	sb	$6, 2($1)
	beqz	$7, .L26
	mov	$3, $6
	mov	$2, $7
	add	$1, 3
	bsr	memcpy
.L26:
	movh	$3, %hi(g_ernie_comms+32)
	add3	$3, $3, %lo(g_ernie_comms+32)
	add3	$1, $3, -32 # 0xffe0
	mov	$2, 32
	mov	$4, 32
	bsr	ernie_exec
	movh	$3, %hi(g_ernie_comms)
	add3	$3, $3, %lo(g_ernie_comms)
	lbu	$2, 33($3)
	lbu	$0, 32($3)
	lbu	$1, 34($3)
	sll	$2, 8
	or	$2, $0
	lbu	$0, 35($3)
	sll	$1, 16
	or	$2, $1
	sll	$0, 24
	or	$0, $2
.L24:
	lw	$7, 4($sp)
	lw	$6, 8($sp)
	lw	$5, 12($sp)
	lw	$11, ($sp)
	add	$sp, 24
	jmp	$11
.L27:
	mov	$0, -1 # 0xffff
	bra	.L24
	.size	ernie_exec_cmd, .-ernie_exec_cmd
	.p2align 1
	.globl ernie_exec_cmd_short
	.type	ernie_exec_cmd_short, @function
ernie_exec_cmd_short:
	# frame: 24   16 regs   4 locals
	add	$sp, -24
	ldc	$11, $lp
	extub	$3
	sw	$11, 12($sp)
	extuh	$1
	sw	$2, 4($sp)
	bnez	$3, .L33
	mov	$2, 0
.L32:
	bsr	ernie_exec_cmd
	lw	$11, 12($sp)
	add	$sp, 24
	jmp	$11
.L33:
	add3	$2, $sp, 4
	bra	.L32
	.size	ernie_exec_cmd_short, .-ernie_exec_cmd_short
	.p2align 1
	.globl ernie_3auth_single
	.type	ernie_3auth_single, @function
ernie_3auth_single:
	# frame: 192   32 regs   140 locals   16 args
	ldc	$11, $lp
	add	$sp, -32
	sw	$11, 4($sp)
	sw	$5, 20($sp)
	sw	$6, 16($sp)
	sw	$7, 12($sp)
	sw	$8, 8($sp)
	add3	$sp, $sp, -160 # 0xff60
	mov	$8, $2
	add3	$5, $sp, 115
	mov	$9, $3
	and3	$6, $1, 255
	mov	$3, 44
	add3	$1, $sp, 71
	mov	$2, 0
	sw	$9, 28($sp)
	bsr	memset
	mov	$1, $5
	mov	$3, 45
	mov	$2, 0
	bsr	memset
	mov	$7, -96
	mov	$10, 40
	mov	$12, 48
	add3	$1, $sp, 71
	mov	$4, 45
	mov	$3, $5
	mov	$2, 44
	sb	$10, 73($sp)
	sb	$12, 74($sp)
	sw	$10, 24($sp)
	sw	$12, 20($sp)
	sb	$7, 71($sp)
	sb	$6, 77($sp)
	bsr	ernie_exec
	movh	$2, 0xe005
	or3	$2, $2, 0x3c
	lw	$3, ($2)
	mov	$1, $3
	sb	$3, 39($sp)
	srl	$1, 8
	sb	$1, 40($sp)
	mov	$1, $3
	srl	$3, 24
	srl	$1, 16
	sb	$1, 41($sp)
	sb	$3, 42($sp)
	lw	$3, ($2)
	add3	$1, $sp, 47
	mov	$2, $3
	sb	$3, 43($sp)
	srl	$2, 8
	sb	$2, 44($sp)
	mov	$2, $3
	srl	$3, 24
	srl	$2, 16
	sb	$2, 45($sp)
	sb	$3, 46($sp)
	add3	$2, $sp, 127
	mov	$3, 8
	bsr	memcpy
	lw	$9, 28($sp)
	add3	$1, $sp, 55
	mov	$3, 16
	mov	$2, $9
	bsr	memcpy
	add3	$1, $sp, 71
	mov	$3, 44
	mov	$2, 0
	bsr	memset
	mov	$1, $5
	mov	$3, 45
	mov	$2, 0
	bsr	memset
	mov	$3, 0
	sw	$3, 12($sp)
	mov	$3, 8585 # 0x2189
	sw	$3, ($sp)
	add3	$3, $sp, 39
	sw	$5, 8($sp)
	sw	$8, 4($sp)
	mov	$4, 32
	mov	$2, $3
	mov	$1, 0
	bsr	crypto_bigmacDefaultCmd
	lw	$10, 24($sp)
	lw	$12, 20($sp)
	mov	$3, 2
	sb	$3, 75($sp)
	mov	$3, 1
	sb	$3, 78($sp)
	add3	$2, $sp, 39
	add3	$1, $sp, 82
	mov	$3, 32
	sb	$10, 73($sp)
	sb	$12, 74($sp)
	sb	$7, 71($sp)
	sb	$6, 77($sp)
	bsr	memcpy
	add3	$1, $sp, 71
	mov	$3, $5
	mov	$4, 45
	mov	$2, 44
	bsr	ernie_exec
	add3	$sp, $sp, 160
	lw	$8, 8($sp)
	lw	$7, 12($sp)
	lw	$6, 16($sp)
	lw	$5, 20($sp)
	lw	$11, 4($sp)
	add3	$sp, $sp, 32
	jmp	$11
	.size	ernie_3auth_single, .-ernie_3auth_single
	.p2align 1
	.globl ernie_init
	.type	ernie_init, @function
ernie_init:
	# frame: 24   24 regs
	add	$sp, -24
	ldc	$11, $lp
	sw	$5, 12($sp)
	sw	$7, 4($sp)
	mov	$5, $2
	mov	$7, $1
	mov	$2, 3
	mov	$1, 0
	sw	$11, ($sp)
	sw	$6, 8($sp)
	bsr	gpio_port_clear
	mov	$3, 1
	mov	$2, 3
	mov	$1, 0
	bsr	gpio_set_port_mode
	mov	$3, 0
	mov	$2, 4
	mov	$1, 0
	bsr	gpio_set_port_mode
	mov	$3, 3
	mov	$2, 4
	mov	$1, 0
	bsr	gpio_set_intr_mode
	mov	$2, 4
	mov	$1, 0
	bsr	gpio_enable_port
	mov	$2, 4
	mov	$1, 0
	bsr	gpio_acquire_intr
	mov	$1, 0
	bsr	spi_init
	mov	$6, 128
	beqz	$7, .L37
.L41:
	mov	$3, 2
	mov	$2, 18
	mov	$1, $6
	bsr	ernie_exec_cmd_short
	blti	$0, 0, .L41
	beqz	$5, .L37
	movh	$3, %hi(ernie_3auth_B_data1)
	movh	$2, %hi(ernie_3auth_B_key1)
	add3	$3, $3, %lo(ernie_3auth_B_data1)
	add3	$2, $2, %lo(ernie_3auth_B_key1)
	mov	$1, 11
	bsr	ernie_3auth_single
.L37:
	mov	$0, 0
	lw	$7, 4($sp)
	lw	$6, 8($sp)
	lw	$5, 12($sp)
	lw	$11, ($sp)
	add	$sp, 24
	jmp	$11
	.size	ernie_init, .-ernie_init
	.ident	"GCC: (WTF TEAM MOLECULE IS AT IT AGAIN?!) 6.3.0"
