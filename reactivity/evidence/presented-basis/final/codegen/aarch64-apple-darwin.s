	.build_version macos, 11, 0
	.section	__TEXT,__text,regular,pure_instructions
	.globl	__RNvCs6ROJKbSVzdt_25presented_basis_asm_audit19decode_retained_map
	.p2align	2
__RNvCs6ROJKbSVzdt_25presented_basis_asm_audit19decode_retained_map:
	.cfi_startproc
	mov	x9, x0
	ldr	d0, [x1]
	lsr	x0, x0, #32
	mov	w10, #1
	movk	w10, #32704, lsl #16
	cmp	w9, w10
	b.eq	LBB0_3
	mov	w10, #2
	movk	w10, #32704, lsl #16
	cmp	w9, w10
	b.ne	LBB0_5
	str	wzr, [x8]
	ret
LBB0_3:
	cmp	x0, x3
	b.hs	LBB0_7
	add	x10, x2, x0, lsl #4
	ldr	w9, [x10]
	ldur	d1, [x10, #4]
	ldr	w0, [x10, #12]
	b	LBB0_6
LBB0_5:
	movi	d1, #0000000000000000
LBB0_6:
	str	w9, [x8, #4]
	str	d1, [x8, #8]
	str	w0, [x8, #16]
	mov	w9, #1
	stur	d0, [x8, #20]
	str	w9, [x8]
	ret
LBB0_7:
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
Lloh0:
	adrp	x2, l_anon.f2b3b7aed861ed782803442a0fdc9a56.4@PAGE
Lloh1:
	add	x2, x2, l_anon.f2b3b7aed861ed782803442a0fdc9a56.4@PAGEOFF
	mov	x1, x3
	bl	__RNvNtCs94JkloGYSv0_4core9panicking18panic_bounds_check
	.loh AdrpAdd	Lloh0, Lloh1
	.cfi_endproc

	.globl	__RNvCs6ROJKbSVzdt_25presented_basis_asm_audit19encode_admitted_map
	.p2align	2
__RNvCs6ROJKbSVzdt_25presented_basis_asm_audit19encode_admitted_map:
	.cfi_startproc
	sub	sp, sp, #80
	.cfi_def_cfa_offset 80
	stp	d9, d8, [sp, #16]
	stp	x22, x21, [sp, #32]
	stp	x20, x19, [sp, #48]
	stp	x29, x30, [sp, #64]
	add	x29, sp, #64
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	.cfi_offset w21, -40
	.cfi_offset w22, -48
	.cfi_offset b8, -56
	.cfi_offset b9, -64
	.cfi_remember_state
	mov	w20, #1
	movk	w20, #32704, lsl #16
	ldr	w8, [x0]
	cmp	w8, #1
	b.ne	LBB1_6
	ldp	s8, s9, [x0, #4]
	fmov	w8, s9
	ldur	d1, [x0, #12]
	cmp	w8, #0
	fmov	w8, s1
	ccmp	w8, #0, #0, eq
	b.eq	LBB1_8
	ldr	w8, [x1]
	tbz	w8, #0, LBB1_7
	ldur	x0, [x1, #4]
	ldr	x19, [x2, #16]
	lsr	x8, x0, #32
	mov	w9, #1
	movk	w9, #32704, lsl #16
	cmp	w0, w9
	b.eq	LBB1_9
	mov	w9, #2
	movk	w9, #32704, lsl #16
	cmp	w0, w9
	b.eq	LBB1_12
	lsl	x8, x8, #32
	mov	w9, w0
	b	LBB1_11
LBB1_6:
	add	x0, x20, #1
	b	LBB1_15
LBB1_7:
	ldr	x19, [x2, #16]
	b	LBB1_12
LBB1_8:
	fmov	w8, s8
	mov.s	w9, v1[1]
	orr	x0, x8, x9, lsl #32
	b	LBB1_15
LBB1_9:
	cmp	x8, x19
	b.hs	LBB1_18
	ldr	x9, [x2, #8]
	add	x9, x9, x8, lsl #4
	ldp	x9, x8, [x9]
LBB1_11:
	fmov	w10, s8
	ushll.2d	v0, v1, #0
	mov.d	x11, v0[1]
	fmov	w12, s9
	fmov	x13, d0
	orr	x11, x13, x11, lsl #32
	orr	x10, x10, x12, lsl #32
	cmp	x8, x11
	ccmp	x9, x10, #0, eq
	b.eq	LBB1_15
LBB1_12:
	lsr	x8, x19, #5
	cmp	x8, #3125
	b.hs	LBB1_17
	ldr	x8, [x2]
	cmp	x19, x8
	b.eq	LBB1_16
LBB1_14:
	ldr	x8, [x2, #8]
	add	x8, x8, x19, lsl #4
	stp	s8, s9, [x8]
	str	d1, [x8, #8]
	add	x8, x19, #1
	str	x8, [x2, #16]
	orr	x0, x20, x19, lsl #32
LBB1_15:
	.cfi_def_cfa wsp, 80
	ldp	x29, x30, [sp, #64]
	ldp	x20, x19, [sp, #48]
	ldp	x22, x21, [sp, #32]
	ldp	d9, d8, [sp, #16]
	add	sp, sp, #80
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	.cfi_restore w19
	.cfi_restore w20
	.cfi_restore w21
	.cfi_restore w22
	.cfi_restore b8
	.cfi_restore b9
	ret
LBB1_16:
	.cfi_restore_state
	mov	x0, x2
	mov	x21, x2
	str	q1, [sp]
	bl	__RNvMs3_NtCsdIxNTDZNnoR_5alloc7raw_vecINtB5_6RawVecNtNtCs6ROJKbSVzdt_25presented_basis_asm_audit5codec6RecordE8grow_oneBQ_
	ldr	q1, [sp]
	mov	x2, x21
	b	LBB1_14
LBB1_17:
Lloh2:
	adrp	x0, l_anon.f2b3b7aed861ed782803442a0fdc9a56.5@PAGE
Lloh3:
	add	x0, x0, l_anon.f2b3b7aed861ed782803442a0fdc9a56.5@PAGEOFF
Lloh4:
	adrp	x2, l_anon.f2b3b7aed861ed782803442a0fdc9a56.6@PAGE
Lloh5:
	add	x2, x2, l_anon.f2b3b7aed861ed782803442a0fdc9a56.6@PAGEOFF
	mov	w1, #71
	bl	__RNvNtCs94JkloGYSv0_4core9panicking9panic_fmt
LBB1_18:
Lloh6:
	adrp	x2, l_anon.f2b3b7aed861ed782803442a0fdc9a56.4@PAGE
Lloh7:
	add	x2, x2, l_anon.f2b3b7aed861ed782803442a0fdc9a56.4@PAGEOFF
	mov	x0, x8
	mov	x1, x19
	bl	__RNvNtCs94JkloGYSv0_4core9panicking18panic_bounds_check
	.loh AdrpAdd	Lloh4, Lloh5
	.loh AdrpAdd	Lloh2, Lloh3
	.loh AdrpAdd	Lloh6, Lloh7
	.cfi_endproc

	.globl	__RNvMs3_NtCsdIxNTDZNnoR_5alloc7raw_vecINtB5_6RawVecNtNtCs6ROJKbSVzdt_25presented_basis_asm_audit5codec6RecordE8grow_oneBQ_
	.p2align	2
__RNvMs3_NtCsdIxNTDZNnoR_5alloc7raw_vecINtB5_6RawVecNtNtCs6ROJKbSVzdt_25presented_basis_asm_audit5codec6RecordE8grow_oneBQ_:
	.cfi_startproc
	b	__RNvMs4_NtCsdIxNTDZNnoR_5alloc7raw_vecNtB5_11RawVecInner8grow_oneCs6ROJKbSVzdt_25presented_basis_asm_audit
	.cfi_endproc

	.p2align	2
__RNvMs4_NtCsdIxNTDZNnoR_5alloc7raw_vecNtB5_11RawVecInner11finish_growCs6ROJKbSVzdt_25presented_basis_asm_audit:
	.cfi_startproc
	stp	x24, x23, [sp, #-64]!
	.cfi_def_cfa_offset 64
	stp	x22, x21, [sp, #16]
	stp	x20, x19, [sp, #32]
	stp	x29, x30, [sp, #48]
	add	x29, sp, #48
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	.cfi_offset w21, -40
	.cfi_offset w22, -48
	.cfi_offset w23, -56
	.cfi_offset w24, -64
	.cfi_remember_state
	mov	x19, x0
	lsr	x8, x3, #60
	cbnz	x8, LBB3_5
	mov	x22, x1
	mov	x21, x2
	mov	x23, x3
	lsl	x20, x3, #4
	mov	x0, x20
	mov	w1, #4
	bl	__RNvMNtNtCs94JkloGYSv0_4core5alloc6layoutNtB2_6Layout23is_size_alignment_valid
	cbz	w0, LBB3_5
	cbz	x22, LBB3_6
	lsl	x1, x22, #4
	cmp	x20, x1
	b.lo	LBB3_13
	mov	x0, x21
	mov	w2, #4
	mov	x3, x20
	bl	__RNvCs9wFQrvczXsK_7___rustc14___rust_realloc
	cbnz	x0, LBB3_10
	b	LBB3_8
LBB3_5:
	mov	x20, #0
	mov	w8, #1
	mov	w9, #8
	b	LBB3_12
LBB3_6:
	cbz	x23, LBB3_9
	bl	__RNvCs9wFQrvczXsK_7___rustc35___rust_no_alloc_shim_is_unstable_v2
	mov	x0, x20
	mov	w1, #4
	bl	__RNvCs9wFQrvczXsK_7___rustc12___rust_alloc
	cbnz	x0, LBB3_10
LBB3_8:
	mov	w8, #4
	str	x8, [x19, #8]
	mov	w8, #1
	b	LBB3_11
LBB3_9:
	mov	w0, #4
LBB3_10:
	mov	x8, #0
	str	x0, [x19, #8]
LBB3_11:
	mov	w9, #16
LBB3_12:
	str	x20, [x19, x9]
	str	x8, [x19]
	.cfi_def_cfa wsp, 64
	ldp	x29, x30, [sp, #48]
	ldp	x20, x19, [sp, #32]
	ldp	x22, x21, [sp, #16]
	ldp	x24, x23, [sp], #64
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	.cfi_restore w19
	.cfi_restore w20
	.cfi_restore w21
	.cfi_restore w22
	.cfi_restore w23
	.cfi_restore w24
	ret
LBB3_13:
	.cfi_restore_state
Lloh8:
	adrp	x0, l_anon.f2b3b7aed861ed782803442a0fdc9a56.0@PAGE
Lloh9:
	add	x0, x0, l_anon.f2b3b7aed861ed782803442a0fdc9a56.0@PAGEOFF
Lloh10:
	adrp	x2, l_anon.f2b3b7aed861ed782803442a0fdc9a56.2@PAGE
Lloh11:
	add	x2, x2, l_anon.f2b3b7aed861ed782803442a0fdc9a56.2@PAGEOFF
	mov	w1, #145
	bl	__RNvNtCs94JkloGYSv0_4core9panicking9panic_fmt
	.loh AdrpAdd	Lloh10, Lloh11
	.loh AdrpAdd	Lloh8, Lloh9
	.cfi_endproc

	.p2align	2
__RNvMs4_NtCsdIxNTDZNnoR_5alloc7raw_vecNtB5_11RawVecInner14grow_amortizedCs6ROJKbSVzdt_25presented_basis_asm_audit:
	.cfi_startproc
	sub	sp, sp, #80
	.cfi_def_cfa_offset 80
	stp	x22, x21, [sp, #32]
	stp	x20, x19, [sp, #48]
	stp	x29, x30, [sp, #64]
	add	x29, sp, #64
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	.cfi_offset w21, -40
	.cfi_offset w22, -48
	mov	x19, x0
	add	x8, x1, #1
	ldr	x21, [x0]
	lsl	x9, x21, #1
	cmp	x8, x9
	csinc	x20, x9, x1, ls
	mov	w0, #16
	bl	__RNvNtCsdIxNTDZNnoR_5alloc7raw_vec16min_non_zero_cap
	cmp	x20, x0
	csel	x20, x20, x0, hi
	ldr	x2, [x19, #8]
	add	x0, sp, #8
	mov	x1, x21
	mov	x3, x20
	bl	__RNvMs4_NtCsdIxNTDZNnoR_5alloc7raw_vecNtB5_11RawVecInner11finish_growCs6ROJKbSVzdt_25presented_basis_asm_audit
	ldp	x8, x0, [sp, #8]
	cmp	x8, #1
	b.ne	LBB4_2
	ldr	x1, [sp, #24]
	b	LBB4_3
LBB4_2:
	stp	x20, x0, [x19]
	mov	x0, #-1
LBB4_3:
	.cfi_def_cfa wsp, 80
	ldp	x29, x30, [sp, #64]
	ldp	x20, x19, [sp, #48]
	ldp	x22, x21, [sp, #32]
	add	sp, sp, #80
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	.cfi_restore w19
	.cfi_restore w20
	.cfi_restore w21
	.cfi_restore w22
	ret
	.cfi_endproc

	.p2align	2
__RNvMs4_NtCsdIxNTDZNnoR_5alloc7raw_vecNtB5_11RawVecInner8grow_oneCs6ROJKbSVzdt_25presented_basis_asm_audit:
	.cfi_startproc
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_remember_state
	ldr	x1, [x0]
	bl	__RNvMs4_NtCsdIxNTDZNnoR_5alloc7raw_vecNtB5_11RawVecInner14grow_amortizedCs6ROJKbSVzdt_25presented_basis_asm_audit
	cmn	x0, #1
	b.ne	LBB5_2
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
LBB5_2:
	.cfi_restore_state
	bl	__RNvNtCsdIxNTDZNnoR_5alloc7raw_vec12handle_error
	.cfi_endproc

	.section	__TEXT,__const
l_anon.f2b3b7aed861ed782803442a0fdc9a56.0:
	.ascii	"`new_layout.size()` must be greater than or equal to `old_layout.size()`"

	.section	__TEXT,__cstring,cstring_literals
l_anon.f2b3b7aed861ed782803442a0fdc9a56.1:
	.asciz	"/nix/store/lynmg3kdpdz41r84nafwzi2n5nss50pq-rust-1.97.1-with-components-2026-07-16/lib/rustlib/src/rust/library/alloc/src/alloc.rs"

	.section	__DATA,__const
	.p2align	3, 0x0
l_anon.f2b3b7aed861ed782803442a0fdc9a56.2:
	.quad	l_anon.f2b3b7aed861ed782803442a0fdc9a56.1
	.asciz	"\202\000\000\000\000\000\000\000\363\000\000\000\t\000\000"

	.section	__TEXT,__cstring,cstring_literals
l_anon.f2b3b7aed861ed782803442a0fdc9a56.3:
	.asciz	"/tmp/gpui-presented-basis-asm/src/shipping_codec.rs"

	.section	__DATA,__const
	.p2align	3, 0x0
l_anon.f2b3b7aed861ed782803442a0fdc9a56.4:
	.quad	l_anon.f2b3b7aed861ed782803442a0fdc9a56.3
	.asciz	"3\000\000\000\000\000\000\000\212\000\000\000/\000\000"

	.section	__TEXT,__const
l_anon.f2b3b7aed861ed782803442a0fdc9a56.5:
	.ascii	"basis belongs to the admitted sheet"

	.section	__DATA,__const
	.p2align	3, 0x0
l_anon.f2b3b7aed861ed782803442a0fdc9a56.6:
	.quad	l_anon.f2b3b7aed861ed782803442a0fdc9a56.3
	.asciz	"3\000\000\000\000\000\000\000s\000\000\000\t\000\000"

.subsections_via_symbols
