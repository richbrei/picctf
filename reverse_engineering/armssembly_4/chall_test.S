	.arch armv8-a
	.file	"chall_4.c"
	.text
	.align	2
	.global	func8
	.type	func8, %function
func8:
.LFB6:
	.cfi_startproc
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	str	w0, [sp, 12]
	ldr	w0, [sp, 12]
	add	w0, w0, 2
	str	w0, [sp, 12]
	ldr	w0, [sp, 12]
	add	sp, sp, 16
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE6:
	.size	func8, .-func8
	.align	2
	.global	func7
	.type	func7, %function
func7:
.LFB7:
	.cfi_startproc
	sub	sp, sp, #32
	.cfi_def_cfa_offset 32
	str	w0, [sp, 12]
	ldr	w0, [sp, 12]
	cmp	w0, 99
	bgt	.L4
	mov	w0, 7
	str	w0, [sp, 28]
	b	.L5
.L4:
	ldr	w0, [sp, 12]
	str	w0, [sp, 28]
.L5:
	ldr	w0, [sp, 28]
	add	sp, sp, 32
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE7:
	.size	func7, .-func7
	.align	2
	.global	func6
	.type	func6, %function
func6:
.LFB8:
	.cfi_startproc
	sub	sp, sp, #48
	.cfi_def_cfa_offset 48
	str	w0, [sp, 12]
	mov	w0, 314
	str	w0, [sp, 28]
	mov	w0, 1932
	str	w0, [sp, 32]
	str	wzr, [sp, 36]
	b	.L8
.L9:
	mov	w0, 800
	str	w0, [sp, 40]
	ldr	w1, [sp, 40]
	ldr	w0, [sp, 32]
	mul	w0, w1, w0
	str	w0, [sp, 40]
	ldr	w1, [sp, 40]
	ldr	w0, [sp, 28]
	sdiv	w0, w1, w0
	str	w0, [sp, 44]
.L8:
	ldr	w0, [sp, 36]
	cmp	w0, 898
	ble	.L9
	ldr	w0, [sp, 36]
	add	sp, sp, 48
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE8:
	.size	func6, .-func6
	.align	2
	.global	func5
	.type	func5, %function
func5:
.LFB9:
	.cfi_startproc
	stp	x29, x30, [sp, -32]!
	.cfi_def_cfa_offset 32
	.cfi_offset 29, -32
	.cfi_offset 30, -24
	mov	x29, sp
	str	w0, [sp, 28]
	ldr	w0, [sp, 28]
	bl	func8
	str	w0, [sp, 28]
	ldr	w0, [sp, 28]
	ldp	x29, x30, [sp], 32
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE9:
	.size	func5, .-func5
	.align	2
	.global	func4
	.type	func4, %function
func4:
.LFB10:
	.cfi_startproc
	stp	x29, x30, [sp, -48]!
	.cfi_def_cfa_offset 48
	.cfi_offset 29, -48
	.cfi_offset 30, -40
	mov	x29, sp
	str	w0, [sp, 28]
	mov	w0, 17
	str	w0, [sp, 40]
	ldr	w0, [sp, 40]
	bl	func1
	str	w0, [sp, 44]
	ldr	w0, [sp, 28]
	ldp	x29, x30, [sp], 48
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE10:
	.size	func4, .-func4
	.align	2
	.global	func3
	.type	func3, %function
func3:
.LFB11:
	.cfi_startproc
	stp	x29, x30, [sp, -32]!
	.cfi_def_cfa_offset 32
	.cfi_offset 29, -32
	.cfi_offset 30, -24
	mov	x29, sp
	str	w0, [sp, 28]
	ldr	w0, [sp, 28]
	bl	func7
	ldp	x29, x30, [sp], 32
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE11:
	.size	func3, .-func3
	.align	2
	.global	func2
	.type	func2, %function
func2:
.LFB12:
	.cfi_startproc
	stp	x29, x30, [sp, -48]!
	.cfi_def_cfa_offset 48
	.cfi_offset 29, -48
	.cfi_offset 30, -40
	mov	x29, sp
	str	w0, [sp, 28]
	ldr	w0, [sp, 28]
	cmp	w0, 499
	ble	.L18
	ldr	w0, [sp, 28]
	add	w0, w0, 13
	bl	func5
	str	w0, [sp, 44]
	b	.L19
.L18:
	ldr	w0, [sp, 28]
	sub	w0, w0, #86
	bl	func4
	str	w0, [sp, 44]
.L19:
	ldr	w0, [sp, 44]
	ldp	x29, x30, [sp], 48
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE12:
	.size	func2, .-func2
	.align	2
	.global	func1
	.type	func1, %function
func1:
.LFB13:
	.cfi_startproc
	stp	x29, x30, [sp, -48]!
	.cfi_def_cfa_offset 48
	.cfi_offset 29, -48
	.cfi_offset 30, -40
	mov	x29, sp
	str	w0, [sp, 28]
	ldr	w0, [sp, 28]
	cmp	w0, 99
	bgt	.L22
	ldr	w0, [sp, 28]
	bl	func3
	str	w0, [sp, 44]
	b	.L23
.L22:
	ldr	w0, [sp, 28]
	add	w0, w0, 100
	bl	func2
	str	w0, [sp, 44]
.L23:
	ldr	w0, [sp, 44]
	ldp	x29, x30, [sp], 48
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE13:
	.size	func1, .-func1
	.section	.rodata
	.align	3
.LC0:
	.string	"Result %d\n"
	.text
	.align	2
	.global	main
	.type	main, %function
main:
.LFB14:
	.cfi_startproc
	stp	x29, x30, [sp, -48]!
	.cfi_def_cfa_offset 48
	.cfi_offset 29, -48
	.cfi_offset 30, -40
	mov	x29, sp
	str	w0, [sp, 28]
	str	x1, [sp, 16]
	ldr	x0, [sp, 16]
	add	x0, x0, 8
	ldr	x0, [x0]
	bl	atoi
	str	w0, [sp, 40]
	ldr	w0, [sp, 40]
	bl	func1
	str	w0, [sp, 44]
	ldr	w1, [sp, 44]
	adrp	x0, .LC0
	add	x0, x0, :lo12:.LC0
	bl	printf
	mov	w0, 0
	ldp	x29, x30, [sp], 48
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE14:
	.size	main, .-main
	.ident	"GCC: (Ubuntu 11.3.0-1ubuntu1~22.04) 11.3.0"
	.section	.note.GNU-stack,"",@progbits
