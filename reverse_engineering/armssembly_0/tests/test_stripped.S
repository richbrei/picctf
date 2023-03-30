	.arch armv8-a
	.file	"test.c"
	.text
	.align	2
	.global	func1
	.type	func1, %function
func1:
	sub	sp, sp, #32
	str	w0, [sp, 12]
	str	w1, [sp, 8]
	ldr	w1, [sp, 12]
	ldr	w0, [sp, 8]
	cmp	w1, w0
	ble	.L2
	ldr	w0, [sp, 12]
	str	w0, [sp, 28]
	b	.L3
.L2:
	ldr	w0, [sp, 8]
	str	w0, [sp, 28]
.L3:
	ldr	w0, [sp, 28]
	add	sp, sp, 32
	ret
	.size	func1, .-func1
	.section	.rodata
	.align	3
.LC0:
	.string	"Result: %d\n"
	.text
	.align	2
	.global	main
	.type	main, %function
main:
	stp	x29, x30, [sp, -48]!
	mov	x29, sp
	str	w0, [sp, 28]
	str	x1, [sp, 16]
	ldr	x0, [sp, 16]
	add	x0, x0, 8
	ldr	x0, [x0]
	bl	atoi
	str	w0, [sp, 36]
	ldr	x0, [sp, 16]
	add	x0, x0, 16
	ldr	x0, [x0]
	bl	atoi
	str	w0, [sp, 40]
	ldr	w1, [sp, 40]
	ldr	w0, [sp, 36]
	bl	func1
	str	w0, [sp, 44]
	ldr	w1, [sp, 44]
	adrp	x0, .LC0
	add	x0, x0, :lo12:.LC0
	bl	printf
	mov	w0, 0
	ldp	x29, x30, [sp], 48
	ret
	.size	main, .-main
	.ident	"GCC: (Ubuntu 11.3.0-1ubuntu1~22.04) 11.3.0"
	.section	.note.GNU-stack,"",@progbits
