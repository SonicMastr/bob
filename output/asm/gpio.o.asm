	.file	"gpio.c"
	.text
	.core
	.p2align 1
	.globl gpio_set_port_mode
	.type	gpio_set_port_mode, @function
gpio_set_port_mode:
	movh	$0, 0xe010
	bnez	$1, .L2
	movh	$0, 0xe20a
.L2:
	mov	$1, 1
	lw	$9, ($0)
	sll	$1, $2
	nor	$1, $1
	and	$1, $9
	sll	$3, $2
	or	$3, $1
	sw	$3, ($0)
	syncm
	ret
	.size	gpio_set_port_mode, .-gpio_set_port_mode
	.p2align 1
	.globl gpio_port_read
	.type	gpio_port_read, @function
gpio_port_read:
	movh	$3, 0xe010
	bnez	$1, .L5
	movh	$3, 0xe20a
.L5:
	lw	$0, 4($3)
	srl	$0, $2
	and3	$0, $0, 0x1
	ret
	.size	gpio_port_read, .-gpio_port_read
	.p2align 1
	.globl gpio_port_set
	.type	gpio_port_set, @function
gpio_port_set:
	movh	$0, 0xe010
	bnez	$1, .L8
	movh	$0, 0xe20a
.L8:
	lw	$1, 8($0)
	mov	$3, 1
	sll	$3, $2
	or	$3, $1
	sw	$3, 8($0)
	lw	$3, 52($0)
	syncm
	ret
	.size	gpio_port_set, .-gpio_port_set
	.p2align 1
	.globl gpio_port_clear
	.type	gpio_port_clear, @function
gpio_port_clear:
	movh	$0, 0xe010
	bnez	$1, .L11
	movh	$0, 0xe20a
.L11:
	lw	$1, 12($0)
	mov	$3, 1
	sll	$3, $2
	or	$3, $1
	sw	$3, 12($0)
	lw	$3, 52($0)
	syncm
	ret
	.size	gpio_port_clear, .-gpio_port_clear
	.p2align 1
	.globl gpio_set_intr_mode
	.type	gpio_set_intr_mode, @function
gpio_set_intr_mode:
	movh	$0, 0xe010
	bnez	$1, .L14
	movh	$0, 0xe20a
.L14:
	movh	$1, 0x8000
	or3	$1, $1, 0xf
	and	$1, $2
	bgei	$1, 0, .L15
	add	$1, -1
	mov	$9, -16 # 0xfff0
	or	$1, $9
	add	$1, 1
.L15:
	sll	$1, 1
	bgei	$2, 0, .L16
	add	$2, 15
.L16:
	sra	$2, 4
	add	$2, 5
	sll	$2, 2
	add3	$2, $0, $2
	mov	$0, 3
	lw	$10, ($2)
	lw	$9, ($2)
	sll	$0, $1
	sll	$3, $1
	nor	$0, $0
	and	$0, $10
	or	$3, $9
	or	$3, $0
	sw	$3, ($2)
	syncm
	ret
	.size	gpio_set_intr_mode, .-gpio_set_intr_mode
	.p2align 1
	.globl gpio_query_intr
	.type	gpio_query_intr, @function
gpio_query_intr:
	# frame: 16   16 regs
	add	$sp, -16
	sw	$5, 12($sp)
	sw	$6, 8($sp)
	sw	$7, 4($sp)
	movh	$9, 0xe010
	bnez	$1, .L19
	movh	$9, 0xe20a
.L19:
	lw	$7, 56($9)
	lw	$3, 28($9)
	lw	$6, 60($9)
	lw	$0, 32($9)
	lw	$5, 64($9)
	lw	$11, 36($9)
	nor	$3, $3
	nor	$0, $0
	lw	$4, 68($9)
	and	$0, $6
	lw	$10, 40($9)
	and	$3, $7
	lw	$12, 72($9)
	or	$3, $0
	lw	$1, 44($9)
	mov	$0, $11
	nor	$0, $0
	and	$0, $5
	mov	$9, $10
	or	$0, $3
	nor	$9, $9
	mov	$3, $1
	and	$9, $4
	nor	$3, $3
	and	$3, $12
	or	$0, $9
	or	$0, $3
	mov	$3, 1
	lw	$7, 4($sp)
	sll	$3, $2
	and	$0, $3
	lw	$6, 8($sp)
	lw	$5, 12($sp)
	add	$sp, 16
	ret
	.size	gpio_query_intr, .-gpio_query_intr
	.p2align 1
	.globl gpio_acquire_intr
	.type	gpio_acquire_intr, @function
gpio_acquire_intr:
	# frame: 16   16 regs
	mov	$9, 1
	add	$sp, -16
	sw	$5, 12($sp)
	sw	$6, 8($sp)
	sw	$7, 4($sp)
	sll	$9, $2
	movh	$3, 0xe010
	bnez	$1, .L22
	movh	$3, 0xe20a
.L22:
	lw	$7, 56($3)
	lw	$2, 28($3)
	lw	$6, 60($3)
	lw	$0, 32($3)
	lw	$5, 64($3)
	lw	$11, 36($3)
	lw	$4, 68($3)
	lw	$10, 40($3)
	lw	$12, 72($3)
	lw	$1, 44($3)
	sw	$9, 56($3)
	sw	$9, 60($3)
	sw	$9, 64($3)
	sw	$9, 68($3)
	sw	$9, 72($3)
	syncm
	mov	$3, $2
	nor	$3, $3
	nor	$0, $0
	and	$0, $6
	and	$3, $7
	or	$3, $0
	mov	$0, $11
	nor	$0, $0
	and	$0, $5
	mov	$2, $10
	or	$0, $3
	nor	$2, $2
	mov	$3, $1
	and	$2, $4
	nor	$3, $3
	or	$0, $2
	and	$3, $12
	or	$0, $3
	and	$0, $9
	lw	$7, 4($sp)
	lw	$6, 8($sp)
	lw	$5, 12($sp)
	add	$sp, 16
	ret
	.size	gpio_acquire_intr, .-gpio_acquire_intr
	.p2align 1
	.globl gpio_enable_port
	.type	gpio_enable_port, @function
gpio_enable_port:
	mov	$3, 1
	sll	$3, $2
	movh	$2, 0xe010
	bnez	$1, .L25
	movh	$2, 0xe20a
.L25:
	lw	$1, 28($2)
	nor	$3, $3
	and	$3, $1
	sw	$3, 28($2)
	ret
	.size	gpio_enable_port, .-gpio_enable_port
	.p2align 1
	.globl gpio_init
	.type	gpio_init, @function
gpio_init:
	# frame: 24   24 regs
	add	$sp, -24
	sw	$5, 12($sp)
	ldc	$11, $lp
	mov	$5, $1
	mov	$4, 0
	mov	$3, 1
	mov	$2, 1
	mov	$1, 64
	sw	$6, 8($sp)
	sw	$11, 4($sp)
	bsr	pervasive_control_gate
	mov	$4, 0
	mov	$3, 0
	mov	$2, 1
	mov	$1, 64
	bsr	pervasive_control_reset
	beqz	$5, .L27
	mov	$3, 1
	mov	$2, 7
	mov	$1, 0
	bsr	gpio_set_port_mode
	mov	$3, 1
	mov	$2, 6
	mov	$1, 0
	bsr	gpio_set_port_mode
	mov	$5, 16
	mov	$6, 24
.L29:
	mov	$2, $5
	mov	$3, 1
	mov	$1, 0
	add	$5, 1
	bsr	gpio_set_port_mode
	bne	$5, $6, .L29
.L27:
	lw	$6, 8($sp)
	lw	$5, 12($sp)
	lw	$11, 4($sp)
	add	$sp, 24
	jmp	$11
	.size	gpio_init, .-gpio_init
	.ident	"GCC: (WTF TEAM MOLECULE IS AT IT AGAIN?!) 6.3.0"
