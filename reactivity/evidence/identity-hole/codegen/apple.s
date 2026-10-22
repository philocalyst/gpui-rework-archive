	.build_version macos, 11, 0
	.section	__TEXT,__text,regular,pure_instructions
	.globl	__RINvNtNtNtCs94JkloGYSv0_4core5slice4sort8unstable7ipnsortNtNtCs5Av9rWzHob7_3lib14identity_index3RunNCINvMB6_SBT_20sort_unstable_by_keyyNCINvMs0_BV_NtBV_13IdentityIndex8from_idsINtNtNtNtB8_4iter8adapters6copied6CopiedINtNtB6_4iter4IteryEEEs_0E0EBX_
	.p2align	2
__RINvNtNtNtCs94JkloGYSv0_4core5slice4sort8unstable7ipnsortNtNtCs5Av9rWzHob7_3lib14identity_index3RunNCINvMB6_SBT_20sort_unstable_by_keyyNCINvMs0_BV_NtBV_13IdentityIndex8from_idsINtNtNtNtB8_4iter8adapters6copied6CopiedINtNtB6_4iter4IteryEEEs_0E0EBX_:
	.cfi_startproc
	cmp	x1, #2
	b.lo	LBB0_20
	mov	x4, x2
	ldr	x8, [x0, #16]
	ldr	x9, [x0]
	cmp	x8, x9
	b.hs	LBB0_6
	cmp	x1, #2
	b.eq	LBB0_7
	add	x11, x0, #32
	mov	w10, #2
	mov	x12, x8
LBB0_4:
	ldr	x13, [x11], #16
	cmp	x13, x12
	b.hs	LBB0_8
	add	x10, x10, #1
	mov	x12, x13
	cmp	x1, x10
	b.ne	LBB0_4
	b	LBB0_13
LBB0_6:
	cmp	x1, #2
	b.ne	LBB0_10
LBB0_7:
	mov	w10, #2
LBB0_8:
	cmp	x10, x1
	b.eq	LBB0_13
	orr	x8, x1, #0x1
	clz	x8, x8
	lsl	w8, w8, #1
	eor	w3, w8, #0x7e
	mov	x2, #0
	b	__RINvNtNtNtNtCs94JkloGYSv0_4core5slice4sort8unstable9quicksort9quicksortNtNtCs5Av9rWzHob7_3lib14identity_index3RunNCINvMB8_SB17_20sort_unstable_by_keyyNCINvMs0_B19_NtB19_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs_0E0EB1b_
LBB0_10:
	add	x11, x0, #32
	mov	w10, #2
	mov	x12, x8
LBB0_11:
	ldr	x13, [x11], #16
	cmp	x13, x12
	b.lo	LBB0_8
	add	x10, x10, #1
	mov	x12, x13
	cmp	x1, x10
	b.ne	LBB0_11
LBB0_13:
	cmp	x8, x9
	b.hs	LBB0_20
	mov	x9, #0
	lsr	x12, x1, #1
	sub	x11, x12, #1
	mov	x8, #-6148914691236517206
	movk	x8, #43691
	umulh	x8, x11, x8
	lsr	x8, x8, #2
	mov	w10, #6
	msub	x8, x8, x10, x11
	add	x10, x8, #1
	cmp	x10, #6
	csinc	x8, xzr, x8, eq
	cmp	x11, #5
	b.lo	LBB0_18
	mov	x9, #0
	add	x11, x0, x1, lsl #4
	sub	x12, x12, x8
	sub	x13, x11, #48
	add	x14, x0, #48
LBB0_16:
	ldr	q0, [x13, #32]
	ldp	q1, q2, [x14, #-48]
	str	q1, [x13, #32]
	eor	x15, x9, #0xffffffffffffffe
	lsl	x15, x15, #4
	ldr	q1, [x11, x15]
	stp	q0, q1, [x14, #-48]
	str	q2, [x11, x15]
	ldp	q0, q1, [x14, #-16]
	ldp	q3, q2, [x13, #-16]
	stp	q2, q3, [x14, #-16]
	stp	q1, q0, [x13, #-16]
	ldp	q0, q1, [x14, #16]
	ldp	q3, q2, [x13, #-48]
	stp	q1, q0, [x13, #-48]
	add	x9, x9, #6
	sub	x13, x13, #96
	stp	q2, q3, [x14, #16]
	add	x14, x14, #96
	cmp	x12, x9
	b.ne	LBB0_16
	cmp	x10, #6
	b.eq	LBB0_20
LBB0_18:
	lsl	x10, x9, #4
	add	x9, x0, x10
	sub	x10, x0, x10
	add	x10, x10, x1, lsl #4
	sub	x10, x10, #16
LBB0_19:
	ldr	q0, [x9]
	ldr	q1, [x10]
	str	q1, [x9], #16
	str	q0, [x10], #-16
	subs	x8, x8, #1
	b.ne	LBB0_19
LBB0_20:
	ret
	.cfi_endproc

	.globl	__RINvNtNtNtCs94JkloGYSv0_4core5slice4sort8unstable7ipnsortNtNtCs5Av9rWzHob7_3lib14identity_index5EntryNCINvMB6_SBT_20sort_unstable_by_keyyNCINvMs0_BV_NtBV_13IdentityIndex8from_idsINtNtNtNtB8_4iter8adapters6copied6CopiedINtNtB6_4iter4IteryEEEs1_0E0EBX_
	.p2align	2
__RINvNtNtNtCs94JkloGYSv0_4core5slice4sort8unstable7ipnsortNtNtCs5Av9rWzHob7_3lib14identity_index5EntryNCINvMB6_SBT_20sort_unstable_by_keyyNCINvMs0_BV_NtBV_13IdentityIndex8from_idsINtNtNtNtB8_4iter8adapters6copied6CopiedINtNtB6_4iter4IteryEEEs1_0E0EBX_:
	.cfi_startproc
	cmp	x1, #2
	b.lo	LBB1_16
	mov	x4, x2
	ldur	x8, [x0, #12]
	ldr	x9, [x0]
	cmp	x8, x9
	b.hs	LBB1_6
	cmp	x1, #2
	b.eq	LBB1_7
	add	x11, x0, #24
	mov	w10, #2
	mov	x12, x8
LBB1_4:
	ldr	x13, [x11], #12
	cmp	x13, x12
	b.hs	LBB1_8
	add	x10, x10, #1
	mov	x12, x13
	cmp	x1, x10
	b.ne	LBB1_4
	b	LBB1_13
LBB1_6:
	cmp	x1, #2
	b.ne	LBB1_10
LBB1_7:
	mov	w10, #2
LBB1_8:
	cmp	x10, x1
	b.eq	LBB1_13
	orr	x8, x1, #0x1
	clz	x8, x8
	lsl	w8, w8, #1
	eor	w3, w8, #0x7e
	mov	x2, #0
	b	__RINvNtNtNtNtCs94JkloGYSv0_4core5slice4sort8unstable9quicksort9quicksortNtNtCs5Av9rWzHob7_3lib14identity_index5EntryNCINvMB8_SB17_20sort_unstable_by_keyyNCINvMs0_B19_NtB19_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs1_0E0EB1b_
LBB1_10:
	add	x11, x0, #24
	mov	w10, #2
	mov	x12, x8
LBB1_11:
	ldr	x13, [x11], #12
	cmp	x13, x12
	b.lo	LBB1_8
	add	x10, x10, #1
	mov	x12, x13
	cmp	x1, x10
	b.ne	LBB1_11
LBB1_13:
	cmp	x8, x9
	b.hs	LBB1_16
	lsr	x8, x1, #1
	add	x9, x0, #8
	mov	w10, #12
	madd	x10, x1, x10, x0
	sub	x10, x10, #4
LBB1_15:
	ldur	x11, [x9, #-8]
	ldur	x12, [x10, #-8]
	stur	x12, [x9, #-8]
	stur	x11, [x10, #-8]
	ldr	w11, [x9]
	ldr	w12, [x10]
	str	w12, [x9], #12
	str	w11, [x10], #-12
	sub	x8, x8, #1
	cbnz	x8, LBB1_15
LBB1_16:
	ret
	.cfi_endproc

	.p2align	2
__RINvNtNtNtNtCs94JkloGYSv0_4core5slice4sort6shared5pivot11median3_recNtNtCs5Av9rWzHob7_3lib14identity_index3RunNCINvMB8_SB14_20sort_unstable_by_keyyNCINvMs0_B16_NtB16_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs_0E0EB18_:
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
	mov	x19, x2
	mov	x20, x1
	cmp	x3, #7
	b.ls	LBB2_2
	lsr	x21, x3, #3
	lsl	x23, x21, #6
	lsl	x8, x21, #7
	sub	x24, x8, x21, lsl #4
	add	x1, x0, x23
	add	x2, x0, x24
	mov	x3, x21
	bl	__RINvNtNtNtNtCs94JkloGYSv0_4core5slice4sort6shared5pivot11median3_recNtNtCs5Av9rWzHob7_3lib14identity_index3RunNCINvMB8_SB14_20sort_unstable_by_keyyNCINvMs0_B16_NtB16_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs_0E0EB18_
	mov	x22, x0
	add	x1, x20, x23
	add	x2, x20, x24
	mov	x0, x20
	mov	x3, x21
	bl	__RINvNtNtNtNtCs94JkloGYSv0_4core5slice4sort6shared5pivot11median3_recNtNtCs5Av9rWzHob7_3lib14identity_index3RunNCINvMB8_SB14_20sort_unstable_by_keyyNCINvMs0_B16_NtB16_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs_0E0EB18_
	mov	x20, x0
	add	x1, x19, x23
	add	x2, x19, x24
	mov	x0, x19
	mov	x3, x21
	bl	__RINvNtNtNtNtCs94JkloGYSv0_4core5slice4sort6shared5pivot11median3_recNtNtCs5Av9rWzHob7_3lib14identity_index3RunNCINvMB8_SB14_20sort_unstable_by_keyyNCINvMs0_B16_NtB16_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs_0E0EB18_
	mov	x19, x0
	mov	x0, x22
LBB2_2:
	ldr	x8, [x0]
	ldr	x9, [x20]
	cmp	x8, x9
	cset	w10, lo
	ldr	x11, [x19]
	cmp	x8, x11
	cset	w8, lo
	eor	w8, w10, w8
	cmp	x9, x11
	cset	w9, lo
	eor	w9, w10, w9
	cmp	w9, #0
	csel	x9, x19, x20, ne
	cmp	w8, #0
	csel	x0, x0, x9, ne
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
	.cfi_endproc

	.p2align	2
__RINvNtNtNtNtCs94JkloGYSv0_4core5slice4sort6shared5pivot11median3_recNtNtCs5Av9rWzHob7_3lib14identity_index5EntryNCINvMB8_SB14_20sort_unstable_by_keyyNCINvMs0_B16_NtB16_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs1_0E0EB18_:
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
	mov	x19, x2
	mov	x20, x1
	cmp	x3, #7
	b.ls	LBB3_2
	lsr	x21, x3, #3
	add	x8, x21, x21, lsl #1
	lsl	x23, x8, #4
	mov	w8, #84
	mul	x24, x21, x8
	add	x1, x0, x23
	add	x2, x0, x24
	mov	x3, x21
	bl	__RINvNtNtNtNtCs94JkloGYSv0_4core5slice4sort6shared5pivot11median3_recNtNtCs5Av9rWzHob7_3lib14identity_index5EntryNCINvMB8_SB14_20sort_unstable_by_keyyNCINvMs0_B16_NtB16_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs1_0E0EB18_
	mov	x22, x0
	add	x1, x20, x23
	add	x2, x20, x24
	mov	x0, x20
	mov	x3, x21
	bl	__RINvNtNtNtNtCs94JkloGYSv0_4core5slice4sort6shared5pivot11median3_recNtNtCs5Av9rWzHob7_3lib14identity_index5EntryNCINvMB8_SB14_20sort_unstable_by_keyyNCINvMs0_B16_NtB16_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs1_0E0EB18_
	mov	x20, x0
	add	x1, x19, x23
	add	x2, x19, x24
	mov	x0, x19
	mov	x3, x21
	bl	__RINvNtNtNtNtCs94JkloGYSv0_4core5slice4sort6shared5pivot11median3_recNtNtCs5Av9rWzHob7_3lib14identity_index5EntryNCINvMB8_SB14_20sort_unstable_by_keyyNCINvMs0_B16_NtB16_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs1_0E0EB18_
	mov	x19, x0
	mov	x0, x22
LBB3_2:
	ldr	x8, [x0]
	ldr	x9, [x20]
	cmp	x8, x9
	cset	w10, lo
	ldr	x11, [x19]
	cmp	x8, x11
	cset	w8, lo
	eor	w8, w10, w8
	cmp	x9, x11
	cset	w9, lo
	eor	w9, w10, w9
	cmp	w9, #0
	csel	x9, x19, x20, ne
	cmp	w8, #0
	csel	x0, x0, x9, ne
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
	.cfi_endproc

	.p2align	2
__RINvNtNtNtNtCs94JkloGYSv0_4core5slice4sort6shared9smallsort12sort8_stableNtNtCs5Av9rWzHob7_3lib14identity_index3RunNCINvMB8_SB19_20sort_unstable_by_keyyNCINvMs0_B1b_NtB1b_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs_0E0EB1d_:
	.cfi_startproc
	ldr	x8, [x0, #16]
	ldr	x9, [x0]
	cmp	x8, x9
	cset	w8, hs
	cset	w9, lo
	ldr	x10, [x0, #48]
	ldr	x11, [x0, #32]
	add	x9, x0, w9, uxtw #4
	add	x8, x0, w8, uxtw #4
	mov	w12, #32
	mov	w13, #48
	cmp	x10, x11
	csel	x10, x13, x12, lo
	add	x10, x0, x10
	csel	x11, x12, x13, lo
	add	x11, x0, x11
	ldr	x14, [x10]
	ldr	x15, [x9]
	ldr	x16, [x11]
	ldr	x17, [x8]
	cmp	x16, x17
	csel	x3, x10, x8, lo
	cmp	x14, x15
	csel	x14, x10, x9, lo
	csel	x9, x9, x3, lo
	csel	x10, x8, x10, lo
	cmp	x16, x17
	csel	x8, x8, x11, lo
	csel	x10, x11, x10, lo
	ldr	x11, [x10]
	ldr	x15, [x9]
	cmp	x11, x15
	csel	x11, x10, x9, lo
	csel	x9, x9, x10, lo
	ldr	q0, [x14]
	str	q0, [x2]
	ldr	q0, [x11]
	str	q0, [x2, #16]
	ldr	q0, [x9]
	str	q0, [x2, #32]
	ldr	q0, [x8]
	str	q0, [x2, #48]
	ldr	x8, [x0, #64]!
	ldr	x9, [x0, #16]
	cmp	x9, x8
	cset	w8, hs
	cset	w9, lo
	ldr	x10, [x0, #48]
	ldr	x11, [x0, #32]
	add	x9, x0, w9, uxtw #4
	add	x8, x0, w8, uxtw #4
	cmp	x10, x11
	csel	x10, x13, x12, lo
	add	x10, x0, x10
	csel	x11, x12, x13, lo
	add	x11, x0, x11
	ldr	x12, [x10]
	ldr	x13, [x9]
	ldr	x14, [x11]
	ldr	x15, [x8]
	cmp	x14, x15
	csel	x16, x10, x8, lo
	cmp	x12, x13
	csel	x12, x10, x9, lo
	csel	x9, x9, x16, lo
	csel	x10, x8, x10, lo
	add	x13, x2, #48
	add	x16, x2, #64
	cmp	x14, x15
	csel	x8, x8, x11, lo
	csel	x10, x11, x10, lo
	ldr	x11, [x10]
	ldr	x14, [x9]
	cmp	x11, x14
	csel	x11, x10, x9, lo
	csel	x9, x9, x10, lo
	ldr	q0, [x12]
	str	q0, [x2, #64]
	ldr	q0, [x11]
	str	q0, [x2, #80]
	ldr	q0, [x9]
	str	q0, [x2, #96]
	add	x9, x2, #112
	ldr	q0, [x8]
	str	q0, [x2, #112]
	ldr	x8, [x2, #64]
	ldr	x10, [x2]
	cmp	x8, x10
	csel	x8, x16, x2, lo
	cset	w10, hs
	cset	w11, lo
	ldr	q0, [x8]
	str	q0, [x1]
	add	x8, x16, w11, uxtw #4
	add	x10, x2, w10, uxtw #4
	ldr	x11, [x2, #112]
	ldr	x12, [x2, #48]
	cmp	x11, x12
	csel	x11, x13, x9, lo
	ldr	q0, [x11]
	str	q0, [x1, #112]
	csetm	x11, hs
	add	x9, x9, x11, lsl #4
	csetm	x11, lo
	add	x11, x13, x11, lsl #4
	ldr	x12, [x8]
	ldr	x13, [x10]
	cmp	x12, x13
	csel	x12, x8, x10, lo
	cset	w13, hs
	cset	w14, lo
	ldr	q0, [x12]
	str	q0, [x1, #16]
	add	x8, x8, w14, uxtw #4
	add	x10, x10, w13, uxtw #4
	ldr	x12, [x9]
	ldr	x13, [x11]
	cmp	x12, x13
	csel	x12, x11, x9, lo
	ldr	q0, [x12]
	str	q0, [x1, #96]
	csetm	x12, hs
	add	x9, x9, x12, lsl #4
	csetm	x12, lo
	add	x11, x11, x12, lsl #4
	ldr	x12, [x8]
	ldr	x13, [x10]
	cmp	x12, x13
	csel	x12, x8, x10, lo
	cset	w13, hs
	cset	w14, lo
	ldr	q0, [x12]
	str	q0, [x1, #32]
	add	x8, x8, w14, uxtw #4
	add	x10, x10, w13, uxtw #4
	ldr	x12, [x9]
	ldr	x13, [x11]
	cmp	x12, x13
	csel	x12, x11, x9, lo
	ldr	q0, [x12]
	str	q0, [x1, #80]
	csetm	x12, hs
	add	x9, x9, x12, lsl #4
	csetm	x12, lo
	add	x11, x11, x12, lsl #4
	ldr	x12, [x8]
	ldr	x13, [x10]
	cmp	x12, x13
	csel	x12, x8, x10, lo
	cset	w13, hs
	cset	w14, lo
	ldr	q0, [x12]
	str	q0, [x1, #48]
	add	x8, x8, w14, uxtw #4
	add	x10, x10, w13, uxtw #4
	ldr	x12, [x9]
	ldr	x13, [x11]
	cmp	x12, x13
	csel	x12, x11, x9, lo
	ldr	q0, [x12]
	str	q0, [x1, #64]
	csetm	x12, hs
	add	x9, x9, x12, lsl #4
	csetm	x12, lo
	add	x11, x11, x12, lsl #4
	add	x11, x11, #16
	add	x9, x9, #16
	cmp	x8, x9
	ccmp	x10, x11, #0, eq
	b.ne	LBB4_2
	ret
LBB4_2:
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	bl	__RNvNtNtNtNtCs94JkloGYSv0_4core5slice4sort6shared9smallsort22panic_on_ord_violation
	.cfi_endproc

	.p2align	2
__RINvNtNtNtNtCs94JkloGYSv0_4core5slice4sort6shared9smallsort12sort8_stableNtNtCs5Av9rWzHob7_3lib14identity_index5EntryNCINvMB8_SB19_20sort_unstable_by_keyyNCINvMs0_B1b_NtB1b_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs1_0E0EB1d_:
	.cfi_startproc
	ldur	x8, [x0, #12]
	ldr	x9, [x0]
	cmp	x8, x9
	cset	w9, hs
	cset	w10, lo
	ldur	x11, [x0, #36]
	ldr	x12, [x0, #24]
	mov	w8, #12
	umaddl	x10, w10, w8, x0
	umaddl	x9, w9, w8, x0
	mov	w13, #24
	mov	w14, #36
	cmp	x11, x12
	csel	x11, x14, x13, lo
	add	x11, x0, x11
	csel	x12, x13, x14, lo
	add	x12, x0, x12
	ldr	x15, [x11]
	ldr	x16, [x10]
	ldr	x17, [x12]
	ldr	x3, [x9]
	cmp	x17, x3
	csel	x4, x11, x9, lo
	cmp	x15, x16
	csel	x15, x11, x10, lo
	csel	x10, x10, x4, lo
	csel	x11, x9, x11, lo
	cmp	x17, x3
	csel	x9, x9, x12, lo
	csel	x11, x12, x11, lo
	ldr	x12, [x11]
	ldr	x16, [x10]
	cmp	x12, x16
	csel	x12, x11, x10, lo
	csel	x10, x10, x11, lo
	ldr	x11, [x15]
	ldr	w15, [x15, #8]
	str	w15, [x2, #8]
	str	x11, [x2]
	ldr	x11, [x12]
	ldr	w12, [x12, #8]
	str	w12, [x2, #20]
	stur	x11, [x2, #12]
	ldr	x11, [x10]
	ldr	w10, [x10, #8]
	str	w10, [x2, #32]
	str	x11, [x2, #24]
	ldr	x10, [x9]
	ldr	w9, [x9, #8]
	str	w9, [x2, #44]
	mov	x9, x2
	str	x10, [x9, #36]!
	ldr	x10, [x0, #48]!
	ldur	x11, [x0, #12]
	cmp	x11, x10
	cset	w10, hs
	cset	w11, lo
	ldur	x12, [x0, #36]
	ldr	x15, [x0, #24]
	umaddl	x11, w11, w8, x0
	umaddl	x10, w10, w8, x0
	cmp	x12, x15
	csel	x12, x14, x13, lo
	add	x12, x0, x12
	csel	x13, x13, x14, lo
	add	x13, x0, x13
	ldr	x14, [x12]
	ldr	x15, [x11]
	ldr	x16, [x13]
	ldr	x17, [x10]
	cmp	x16, x17
	csel	x0, x12, x10, lo
	cmp	x14, x15
	csel	x14, x12, x11, lo
	csel	x11, x11, x0, lo
	csel	x12, x10, x12, lo
	cmp	x16, x17
	csel	x10, x10, x13, lo
	csel	x12, x13, x12, lo
	ldr	x13, [x12]
	ldr	x15, [x11]
	cmp	x13, x15
	csel	x13, x12, x11, lo
	csel	x11, x11, x12, lo
	ldr	x12, [x14]
	ldr	w14, [x14, #8]
	str	w14, [x2, #56]
	mov	x14, x2
	str	x12, [x14, #48]!
	ldr	x12, [x13]
	ldr	w13, [x13, #8]
	str	w13, [x2, #68]
	stur	x12, [x2, #60]
	ldr	x12, [x11]
	ldr	w11, [x11, #8]
	str	w11, [x2, #80]
	str	x12, [x2, #72]
	ldr	x11, [x10]
	ldr	w10, [x10, #8]
	str	w10, [x2, #92]
	ldr	x10, [x14]
	ldr	x12, [x2]
	cmp	x10, x12
	csel	x10, x14, x2, lo
	cset	w12, hs
	umaddl	x12, w12, w8, x2
	str	x11, [x2, #84]!
	cset	w11, lo
	ldr	x13, [x10]
	ldr	w10, [x10, #8]
	str	w10, [x1, #8]
	str	x13, [x1]
	umaddl	x10, w11, w8, x14
	ldr	x11, [x2]
	ldr	x13, [x9]
	cmp	x11, x13
	csel	x11, x9, x2, lo
	ldr	x13, [x11]
	ldr	w11, [x11, #8]
	str	w11, [x1, #92]
	stur	x13, [x1, #84]
	csetm	x11, hs
	madd	x11, x11, x8, x2
	csetm	x13, lo
	madd	x9, x13, x8, x9
	ldr	x13, [x10]
	ldr	x14, [x12]
	cmp	x13, x14
	csel	x13, x10, x12, lo
	cset	w14, hs
	cset	w15, lo
	ldr	x16, [x13]
	ldr	w13, [x13, #8]
	str	w13, [x1, #20]
	stur	x16, [x1, #12]
	umaddl	x10, w15, w8, x10
	umaddl	x12, w14, w8, x12
	ldr	x13, [x11]
	ldr	x14, [x9]
	cmp	x13, x14
	csel	x13, x9, x11, lo
	ldr	x14, [x13]
	ldr	w13, [x13, #8]
	str	w13, [x1, #80]
	str	x14, [x1, #72]
	csetm	x13, hs
	madd	x11, x13, x8, x11
	csetm	x13, lo
	madd	x9, x13, x8, x9
	ldr	x13, [x10]
	ldr	x14, [x12]
	cmp	x13, x14
	csel	x13, x10, x12, lo
	cset	w14, hs
	cset	w15, lo
	ldr	x16, [x13]
	ldr	w13, [x13, #8]
	str	w13, [x1, #32]
	str	x16, [x1, #24]
	umaddl	x10, w15, w8, x10
	umaddl	x12, w14, w8, x12
	ldr	x13, [x11]
	ldr	x14, [x9]
	cmp	x13, x14
	csel	x13, x9, x11, lo
	ldr	x14, [x13]
	ldr	w13, [x13, #8]
	str	w13, [x1, #68]
	stur	x14, [x1, #60]
	csetm	x13, hs
	madd	x11, x13, x8, x11
	csetm	x13, lo
	madd	x9, x13, x8, x9
	ldr	x13, [x10]
	ldr	x14, [x12]
	cmp	x13, x14
	csel	x13, x10, x12, lo
	cset	w14, hs
	cset	w15, lo
	ldr	x16, [x13]
	ldr	w13, [x13, #8]
	str	w13, [x1, #44]
	stur	x16, [x1, #36]
	umaddl	x10, w15, w8, x10
	umaddl	x12, w14, w8, x12
	ldr	x13, [x11]
	ldr	x14, [x9]
	cmp	x13, x14
	csel	x13, x9, x11, lo
	ldr	x14, [x13]
	ldr	w13, [x13, #8]
	str	w13, [x1, #56]
	str	x14, [x1, #48]
	csetm	x13, hs
	madd	x11, x13, x8, x11
	csetm	x13, lo
	madd	x8, x13, x8, x9
	add	x8, x8, #12
	add	x9, x11, #12
	cmp	x10, x9
	ccmp	x12, x8, #0, eq
	b.ne	LBB5_2
	ret
LBB5_2:
	stp	x29, x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	bl	__RNvNtNtNtNtCs94JkloGYSv0_4core5slice4sort6shared9smallsort22panic_on_ord_violation
	.cfi_endproc

	.globl	__RINvNtNtNtNtCs94JkloGYSv0_4core5slice4sort8unstable8heapsort8heapsortNtNtCs5Av9rWzHob7_3lib14identity_index3RunNCINvMB8_SB15_20sort_unstable_by_keyyNCINvMs0_B17_NtB17_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs_0E0EB19_
	.p2align	2
__RINvNtNtNtNtCs94JkloGYSv0_4core5slice4sort8unstable8heapsort8heapsortNtNtCs5Av9rWzHob7_3lib14identity_index3RunNCINvMB8_SB15_20sort_unstable_by_keyyNCINvMs0_B17_NtB17_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs_0E0EB19_:
	.cfi_startproc
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	.cfi_remember_state
	adds	x8, x1, x1, lsr #1
	b.ne	LBB6_3
LBB6_1:
	add	sp, sp, #16
	.cfi_def_cfa_offset 0
	ret
LBB6_2:
	.cfi_restore_state
	cbz	x8, LBB6_1
LBB6_3:
	sub	x8, x8, #1
	subs	x10, x8, x1
	b.hs	LBB6_5
	mov	x10, #0
	lsl	x9, x8, #4
	ldr	q0, [x0]
	ldr	q1, [x0, x9]
	str	q1, [x0]
	str	q0, [x0, x9]
LBB6_5:
	cmp	x1, x8
	csel	x9, x1, x8, lo
	mov	w11, #1
	bfi	x11, x10, #1, #62
	cmp	x11, x9
	b.hs	LBB6_2
	lsl	x13, x10, #1
LBB6_7:
	add	x12, x13, #2
	cmp	x12, x9
	b.hs	LBB6_9
	lsl	x13, x11, #4
	lsl	x12, x12, #4
	ldr	x13, [x0, x13]
	ldr	x12, [x0, x12]
	cmp	x13, x12
	cinc	x12, x11, lo
	add	x11, x0, x10, lsl #4
	add	x10, x0, x12, lsl #4
	ldr	x13, [x11]
	ldr	x14, [x10]
	cmp	x13, x14
	b.lo	LBB6_10
	b	LBB6_2
LBB6_9:
	mov	x12, x11
	add	x11, x0, x10, lsl #4
	add	x10, x0, x12, lsl #4
	ldr	x13, [x11]
	ldr	x14, [x10]
	cmp	x13, x14
	b.hs	LBB6_2
LBB6_10:
	ldr	x15, [x11, #8]
	ldr	x16, [x10, #8]
	stp	x14, x16, [x11]
	stp	x13, x15, [x10]
	lsl	x13, x12, #1
	mov	w11, #1
	bfi	x11, x12, #1, #62
	mov	x10, x12
	cmp	x11, x9
	b.lo	LBB6_7
	b	LBB6_2
	.cfi_endproc

	.globl	__RINvNtNtNtNtCs94JkloGYSv0_4core5slice4sort8unstable8heapsort8heapsortNtNtCs5Av9rWzHob7_3lib14identity_index5EntryNCINvMB8_SB15_20sort_unstable_by_keyyNCINvMs0_B17_NtB17_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs1_0E0EB19_
	.p2align	2
__RINvNtNtNtNtCs94JkloGYSv0_4core5slice4sort8unstable8heapsort8heapsortNtNtCs5Av9rWzHob7_3lib14identity_index5EntryNCINvMB8_SB15_20sort_unstable_by_keyyNCINvMs0_B17_NtB17_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs1_0E0EB19_:
	.cfi_startproc
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	adds	x8, x1, x1, lsr #1
	b.eq	LBB7_11
	mov	w9, #12
	b	LBB7_3
LBB7_2:
	cbz	x8, LBB7_11
LBB7_3:
	sub	x8, x8, #1
	subs	x11, x8, x1
	b.hs	LBB7_5
	mov	x11, #0
	madd	x10, x8, x9, x0
	ldr	w12, [x0, #8]
	ldr	x13, [x0]
	ldr	w14, [x10, #8]
	ldr	x15, [x10]
	str	x15, [x0]
	str	w14, [x0, #8]
	str	x13, [x10]
	str	w12, [x10, #8]
LBB7_5:
	cmp	x1, x8
	csel	x10, x1, x8, lo
	mov	w12, #1
	bfi	x12, x11, #1, #62
	cmp	x12, x10
	b.hs	LBB7_2
	lsl	x14, x11, #1
LBB7_7:
	add	x13, x14, #2
	cmp	x13, x10
	b.hs	LBB7_9
	mul	x14, x12, x9
	mul	x13, x13, x9
	ldr	x14, [x0, x14]
	ldr	x13, [x0, x13]
	cmp	x14, x13
	cinc	x13, x12, lo
	madd	x11, x11, x9, x0
	madd	x12, x13, x9, x0
	ldr	x14, [x11]
	ldr	x15, [x12]
	cmp	x14, x15
	b.lo	LBB7_10
	b	LBB7_2
LBB7_9:
	mov	x13, x12
	madd	x11, x11, x9, x0
	madd	x12, x12, x9, x0
	ldr	x14, [x11]
	ldr	x15, [x12]
	cmp	x14, x15
	b.hs	LBB7_2
LBB7_10:
	str	x15, [x11]
	str	x14, [x12]
	ldr	w14, [x11, #8]
	ldr	w15, [x12, #8]
	str	w15, [x11, #8]
	str	w14, [x12, #8]
	lsl	x14, x13, #1
	mov	w12, #1
	bfi	x12, x13, #1, #62
	mov	x11, x13
	cmp	x12, x10
	b.lo	LBB7_7
	b	LBB7_2
LBB7_11:
	add	sp, sp, #16
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc

	.p2align	2
__RINvNtNtNtNtCs94JkloGYSv0_4core5slice4sort8unstable9quicksort9quicksortNtNtCs5Av9rWzHob7_3lib14identity_index3RunNCINvMB8_SB17_20sort_unstable_by_keyyNCINvMs0_B19_NtB19_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs_0E0EB1b_:
Lfunc_begin0:
	.cfi_startproc
	.cfi_personality 155, _rust_eh_personality
	.cfi_lsda 16, Lexception0
	stp	x28, x27, [sp, #-96]!
	.cfi_def_cfa_offset 96
	stp	x26, x25, [sp, #16]
	stp	x24, x23, [sp, #32]
	stp	x22, x21, [sp, #48]
	stp	x20, x19, [sp, #64]
	stp	x29, x30, [sp, #80]
	add	x29, sp, #80
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	.cfi_offset w21, -40
	.cfi_offset w22, -48
	.cfi_offset w23, -56
	.cfi_offset w24, -64
	.cfi_offset w25, -72
	.cfi_offset w26, -80
	.cfi_offset w27, -88
	.cfi_offset w28, -96
	.cfi_remember_state
	sub	sp, sp, #768
	mov	x20, x1
	mov	x19, x0
	cmp	x1, #33
	b.hs	LBB8_4
LBB8_1:
	cmp	x20, #2
	b.lo	LBB8_54
	lsr	x22, x20, #1
	lsl	x23, x22, #4
	cmp	x20, #15
	b.ls	LBB8_28
	mov	x24, sp
	add	x21, x24, x20, lsl #4
	mov	x1, sp
	mov	x0, x19
	mov	x2, x21
	bl	__RINvNtNtNtNtCs94JkloGYSv0_4core5slice4sort6shared9smallsort12sort8_stableNtNtCs5Av9rWzHob7_3lib14identity_index3RunNCINvMB8_SB19_20sort_unstable_by_keyyNCINvMs0_B1b_NtB1b_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs_0E0EB1d_
	add	x0, x19, x23
	add	x1, x24, x23
	add	x2, x21, #128
	bl	__RINvNtNtNtNtCs94JkloGYSv0_4core5slice4sort6shared9smallsort12sort8_stableNtNtCs5Av9rWzHob7_3lib14identity_index3RunNCINvMB8_SB19_20sort_unstable_by_keyyNCINvMs0_B1b_NtB1b_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs_0E0EB1d_
	mov	w10, #8
	sub	x11, x20, x22
	cmp	x10, x22
	b.lo	LBB8_31
	b	LBB8_39
LBB8_4:
	mov	x21, x4
	mov	x22, x3
	mov	x23, x2
	mov	w24, #112
	mov	x25, sp
	b	LBB8_6
LBB8_5:
	mov	x23, #0
	lsl	x8, x14, #4
	ldr	q0, [x19]
	str	q0, [sp]
	ldr	q0, [x19, x8]
	str	q0, [x19]
	ldr	q0, [sp]
	str	q0, [x19, x8]
	add	x8, x14, #1
	sub	x20, x20, x8
	add	x19, x19, x8, lsl #4
	cmp	x20, #33
	b.lo	LBB8_1
LBB8_6:
	cbz	w22, LBB8_27
	lsr	x3, x20, #3
	add	x1, x19, x3, lsl #6
	madd	x2, x3, x24, x19
	cmp	x20, #64
	b.hs	LBB8_9
	ldr	x8, [x19]
	ldr	x9, [x1]
	cmp	x8, x9
	cset	w10, lo
	ldr	x11, [x2]
	cmp	x8, x11
	cset	w8, lo
	eor	w8, w10, w8
	cmp	x9, x11
	cset	w9, lo
	eor	w9, w10, w9
	cmp	w9, #0
	csel	x9, x2, x1, ne
	cmp	w8, #0
	csel	x0, x19, x9, ne
	sub	w22, w22, #1
	sub	x9, x0, x19
	add	x8, x19, x20, lsl #4
	cbnz	x23, LBB8_10
	b	LBB8_11
LBB8_9:
	mov	x0, x19
	bl	__RINvNtNtNtNtCs94JkloGYSv0_4core5slice4sort6shared5pivot11median3_recNtNtCs5Av9rWzHob7_3lib14identity_index3RunNCINvMB8_SB14_20sort_unstable_by_keyyNCINvMs0_B16_NtB16_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs_0E0EB18_
	sub	w22, w22, #1
	sub	x9, x0, x19
	add	x8, x19, x20, lsl #4
	cbz	x23, LBB8_11
LBB8_10:
	ldr	x10, [x23]
	ldr	x11, [x19, x9]
	cmp	x10, x11
	b.hs	LBB8_19
LBB8_11:
	ldr	q0, [x19]
	ldr	q1, [x19, x9]
	str	q0, [sp]
	str	q1, [x19]
	ldr	q0, [sp]
	str	q0, [x19, x9]
	add	x9, x19, #16
	ldr	q0, [x19, #16]
	str	q0, [sp]
	sub	x12, x8, #16
	add	x10, x19, #32
	ldr	x11, [x19]
	cmp	x10, x12
	b.hs	LBB8_15
	mov	x1, #0
LBB8_13:
	ldr	x13, [x10]
	lsl	x14, x1, #4
	ldr	q0, [x9, x14]
	cmp	x13, x11
	stur	q0, [x10, #-16]
	ldr	q0, [x10]
	str	q0, [x9, x14]
	cinc	x13, x1, lo
	ldr	x14, [x10, #16]
	cmp	x14, x11
	lsl	x14, x13, #4
	ldr	q0, [x9, x14]
	str	q0, [x10]
	ldr	q0, [x10, #16]
	str	q0, [x9, x14]
	cinc	x1, x13, lo
	add	x10, x10, #32
	cmp	x10, x12
	b.lo	LBB8_13
	sub	x12, x10, #16
	b	LBB8_16
LBB8_15:
	mov	x1, #0
	add	x12, x19, #16
LBB8_16:
	cmp	x10, x8
	csel	x13, x25, x10, eq
	ldr	x14, [x13]
	cmp	x14, x11
	lsl	x14, x1, #4
	cinc	x1, x1, lo
	ldr	q0, [x9, x14]
	str	q0, [x12]
	ldr	q0, [x13]
	str	q0, [x9, x14]
	cmp	x10, x8
	mov	x12, x10
	add	x10, x10, #16
	b.ne	LBB8_16
	cmp	x1, x20
	b.hs	LBB8_26
	add	x26, x19, x1, lsl #4
	ldr	q0, [x19]
	str	q0, [sp]
	ldr	q0, [x26]
	str	q0, [x19]
	ldr	q0, [sp]
	str	q0, [x26]
	add	x27, x26, #16
	mvn	x8, x1
	add	x20, x20, x8
	mov	x0, x19
	mov	x2, x23
	mov	x3, x22
	mov	x4, x21
	bl	__RINvNtNtNtNtCs94JkloGYSv0_4core5slice4sort8unstable9quicksort9quicksortNtNtCs5Av9rWzHob7_3lib14identity_index3RunNCINvMB8_SB17_20sort_unstable_by_keyyNCINvMs0_B19_NtB19_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs_0E0EB1b_
	mov	x23, x26
	mov	x19, x27
	cmp	x20, #33
	b.hs	LBB8_6
	b	LBB8_1
LBB8_19:
	ldr	q0, [x19]
	ldr	q1, [x19, x9]
	str	q0, [sp]
	str	q1, [x19]
	ldr	q0, [sp]
	str	q0, [x19, x9]
	add	x9, x19, #16
	ldr	q0, [x19, #16]
	str	q0, [sp]
	sub	x13, x8, #16
	add	x10, x19, #32
	ldr	x11, [x19]
	cmp	x10, x13
	b.hs	LBB8_23
	mov	x12, #0
LBB8_21:
	ldr	x14, [x10]
	lsl	x15, x12, #4
	ldr	q0, [x9, x15]
	cmp	x11, x14
	stur	q0, [x10, #-16]
	ldr	q0, [x10]
	str	q0, [x9, x15]
	cinc	x12, x12, hs
	ldr	x14, [x10, #16]
	cmp	x11, x14
	lsl	x14, x12, #4
	ldr	q0, [x9, x14]
	str	q0, [x10]
	ldr	q0, [x10, #16]
	str	q0, [x9, x14]
	cinc	x12, x12, hs
	add	x10, x10, #32
	cmp	x10, x13
	b.lo	LBB8_21
	sub	x13, x10, #16
	b	LBB8_24
LBB8_23:
	mov	x12, #0
	add	x13, x19, #16
LBB8_24:
	cmp	x10, x8
	csel	x14, x25, x10, eq
	ldr	x15, [x14]
	cmp	x11, x15
	lsl	x15, x12, #4
	ldr	q0, [x9, x15]
	str	q0, [x13]
	ldr	q0, [x14]
	str	q0, [x9, x15]
	cinc	x14, x12, hs
	mov	x12, x14
	cmp	x10, x8
	mov	x13, x10
	add	x10, x10, #16
	b.ne	LBB8_24
	cmp	x14, x20
	b.lo	LBB8_5
LBB8_26:
	brk	#0x1
LBB8_27:
	mov	x0, x19
	mov	x1, x20
	add	sp, sp, #768
	.cfi_def_cfa wsp, 96
	ldp	x29, x30, [sp, #80]
	ldp	x20, x19, [sp, #64]
	ldp	x22, x21, [sp, #48]
	ldp	x24, x23, [sp, #32]
	ldp	x26, x25, [sp, #16]
	ldp	x28, x27, [sp], #96
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	.cfi_restore w19
	.cfi_restore w20
	.cfi_restore w21
	.cfi_restore w22
	.cfi_restore w23
	.cfi_restore w24
	.cfi_restore w25
	.cfi_restore w26
	.cfi_restore w27
	.cfi_restore w28
	b	__RINvNtNtNtNtCs94JkloGYSv0_4core5slice4sort8unstable8heapsort8heapsortNtNtCs5Av9rWzHob7_3lib14identity_index3RunNCINvMB8_SB15_20sort_unstable_by_keyyNCINvMs0_B17_NtB17_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs_0E0EB19_
LBB8_28:
	.cfi_restore_state
	.cfi_remember_state
	cmp	x20, #7
	b.ls	LBB8_30
	ldr	x8, [x19, #16]
	ldr	x9, [x19]
	cmp	x8, x9
	cset	w8, hs
	cset	w9, lo
	ldr	x10, [x19, #48]
	ldr	x11, [x19, #32]
	add	x9, x19, w9, uxtw #4
	add	x8, x19, w8, uxtw #4
	mov	w12, #32
	mov	w13, #48
	cmp	x10, x11
	csel	x10, x13, x12, lo
	add	x10, x19, x10
	csel	x11, x12, x13, lo
	add	x11, x19, x11
	ldr	x14, [x10]
	ldr	x15, [x9]
	ldr	x16, [x11]
	ldr	x17, [x8]
	cmp	x16, x17
	csel	x0, x10, x8, lo
	cmp	x14, x15
	csel	x14, x10, x9, lo
	csel	x9, x9, x0, lo
	csel	x10, x8, x10, lo
	cmp	x16, x17
	csel	x8, x8, x11, lo
	csel	x10, x11, x10, lo
	ldr	x11, [x10]
	ldr	x15, [x9]
	cmp	x11, x15
	csel	x11, x10, x9, lo
	csel	x9, x9, x10, lo
	ldr	q0, [x14]
	ldr	q1, [x11]
	stp	q0, q1, [sp]
	ldr	q0, [x9]
	ldr	q1, [x8]
	stp	q0, q1, [sp, #32]
	add	x8, x19, x23
	ldr	x9, [x8, #16]
	ldr	x10, [x8]
	cmp	x9, x10
	cset	w9, hs
	cset	w10, lo
	ldr	x11, [x8, #48]
	ldr	x14, [x8, #32]
	cmp	x11, x14
	csel	x11, x13, x12, lo
	add	x11, x8, x11
	add	x10, x8, w10, uxtw #4
	add	x9, x8, w9, uxtw #4
	csel	x12, x12, x13, lo
	add	x8, x8, x12
	ldr	x12, [x11]
	ldr	x13, [x10]
	ldr	x14, [x8]
	ldr	x15, [x9]
	cmp	x14, x15
	csel	x16, x11, x9, lo
	cmp	x12, x13
	csel	x12, x11, x10, lo
	csel	x10, x10, x16, lo
	csel	x11, x9, x11, lo
	mov	x13, sp
	add	x13, x13, x23
	cmp	x14, x15
	csel	x9, x9, x8, lo
	csel	x8, x8, x11, lo
	ldr	x11, [x8]
	ldr	x14, [x10]
	cmp	x11, x14
	csel	x11, x8, x10, lo
	csel	x8, x10, x8, lo
	ldr	q0, [x12]
	ldr	q1, [x11]
	stp	q0, q1, [x13]
	ldr	q0, [x8]
	ldr	q1, [x9]
	stp	q0, q1, [x13, #32]
	mov	w10, #4
	sub	x11, x20, x22
	cmp	x10, x22
	b.lo	LBB8_31
	b	LBB8_39
LBB8_30:
	ldr	q0, [x19]
	str	q0, [sp]
	ldr	q0, [x19, x23]
	mov	x8, sp
	str	q0, [x8, x23]
	mov	w10, #1
	sub	x11, x20, x22
	cmp	x10, x22
	b.hs	LBB8_39
LBB8_31:
	lsl	x8, x10, #4
	mov	x9, sp
	mov	x12, x10
	b	LBB8_35
LBB8_32:
	add	x15, x9, x17
LBB8_33:
	stp	x13, x14, [x15]
LBB8_34:
	add	x12, x12, #1
	add	x8, x8, #16
	cmp	x12, x22
	b.eq	LBB8_39
LBB8_35:
	lsl	x13, x12, #4
	add	x14, x9, x13
	ldr	q0, [x19, x13]
	str	q0, [x14]
	ldr	x13, [x14]
	ldur	x15, [x14, #-16]
	cmp	x13, x15
	b.hs	LBB8_34
	ldr	x14, [x14, #8]
	mov	x16, x8
LBB8_37:
	mov	x15, sp
	add	x17, x15, x16
	ldur	q0, [x17, #-16]
	str	q0, [x17]
	subs	x17, x16, #16
	b.eq	LBB8_33
	add	x15, x9, x16
	ldur	x15, [x15, #-32]
	mov	x16, x17
	cmp	x13, x15
	b.lo	LBB8_37
	b	LBB8_32
LBB8_39:
	mov	x8, sp
	add	x9, x8, x23
	cmp	x10, x11
	b.hs	LBB8_49
	add	x12, x19, x23
	lsl	x13, x10, #4
	mov	w14, #16
	mov	x15, x9
	b	LBB8_44
LBB8_41:
	mov	x0, x9
LBB8_42:
	stp	x16, x17, [x0]
LBB8_43:
	add	x10, x10, #1
	add	x15, x15, #16
	sub	x14, x14, #16
	cmp	x10, x11
	b.eq	LBB8_49
LBB8_44:
	lsl	x16, x10, #4
	add	x17, x9, x16
	ldr	q0, [x12, x16]
	str	q0, [x17]
	ldr	x16, [x17]
	ldur	x0, [x17, #-16]
	cmp	x16, x0
	b.hs	LBB8_43
	ldr	x17, [x17, #8]
	mov	x1, x14
	mov	x0, x15
LBB8_46:
	add	x2, x0, x13
	ldur	q0, [x2, #-16]
	str	q0, [x2]
	cmp	x13, x1
	b.eq	LBB8_41
	ldur	x2, [x2, #-32]
	sub	x0, x0, #16
	add	x1, x1, #16
	cmp	x16, x2
	b.lo	LBB8_46
	add	x0, x0, x13
	b	LBB8_42
LBB8_49:
	lsl	x21, x20, #4
	sub	x11, x21, #16
	add	x10, x8, x11
	sub	x13, x9, #16
	mov	w14, #16
	mov	x12, x19
LBB8_50:
	ldr	x15, [x9]
	ldr	x16, [x8]
	cmp	x15, x16
	csel	x15, x9, x8, lo
	ldr	q0, [x15]
	str	q0, [x12], #16
	csel	x15, x14, xzr, lo
	add	x9, x9, x15
	csel	x15, xzr, x14, lo
	add	x8, x8, x15
	ldr	x15, [x10]
	ldr	x16, [x13]
	cmp	x15, x16
	csel	x15, x13, x10, lo
	ldr	q0, [x15]
	str	q0, [x19, x11]
	csetm	x15, hs
	add	x10, x10, x15, lsl #4
	csetm	x15, lo
	add	x13, x13, x15, lsl #4
	sub	x11, x11, #16
	subs	x22, x22, #1
	b.ne	LBB8_50
	add	x11, x13, #16
	add	x10, x10, #16
	tbz	w20, #0, LBB8_53
	cmp	x8, x11
	csel	x13, x8, x9, lo
	ldr	q0, [x13]
	str	q0, [x12]
	mov	w12, #16
	csel	x13, x12, xzr, lo
	add	x8, x8, x13
	csel	x12, xzr, x12, lo
	add	x9, x9, x12
LBB8_53:
	cmp	x9, x10
	ccmp	x8, x11, #0, eq
	b.ne	LBB8_55
LBB8_54:
	add	sp, sp, #768
	.cfi_def_cfa wsp, 96
	ldp	x29, x30, [sp, #80]
	ldp	x20, x19, [sp, #64]
	ldp	x22, x21, [sp, #48]
	ldp	x24, x23, [sp, #32]
	ldp	x26, x25, [sp, #16]
	ldp	x28, x27, [sp], #96
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	.cfi_restore w19
	.cfi_restore w20
	.cfi_restore w21
	.cfi_restore w22
	.cfi_restore w23
	.cfi_restore w24
	.cfi_restore w25
	.cfi_restore w26
	.cfi_restore w27
	.cfi_restore w28
	ret
LBB8_55:
	.cfi_restore_state
Ltmp2:
	bl	__RNvNtNtNtNtCs94JkloGYSv0_4core5slice4sort6shared9smallsort22panic_on_ord_violation
Ltmp3:
	b	LBB8_26
LBB8_56:
Ltmp4:
	mov	x20, x0
	mov	x1, sp
	mov	x0, x19
	mov	x2, x21
	bl	_memcpy
	mov	x0, x20
	bl	__Unwind_Resume
Lfunc_end0:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table8:
Lexception0:
	.byte	255
	.byte	255
	.byte	1
	.uleb128 Lcst_end0-Lcst_begin0
Lcst_begin0:
	.uleb128 Lfunc_begin0-Lfunc_begin0
	.uleb128 Ltmp2-Lfunc_begin0
	.byte	0
	.byte	0
	.uleb128 Ltmp2-Lfunc_begin0
	.uleb128 Ltmp3-Ltmp2
	.uleb128 Ltmp4-Lfunc_begin0
	.byte	0
	.uleb128 Ltmp3-Lfunc_begin0
	.uleb128 Lfunc_end0-Ltmp3
	.byte	0
	.byte	0
Lcst_end0:
	.p2align	2, 0x0

	.section	__TEXT,__text,regular,pure_instructions
	.p2align	2
__RINvNtNtNtNtCs94JkloGYSv0_4core5slice4sort8unstable9quicksort9quicksortNtNtCs5Av9rWzHob7_3lib14identity_index5EntryNCINvMB8_SB17_20sort_unstable_by_keyyNCINvMs0_B19_NtB19_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs1_0E0EB1b_:
Lfunc_begin1:
	.cfi_startproc
	.cfi_personality 155, _rust_eh_personality
	.cfi_lsda 16, Lexception1
	stp	x28, x27, [sp, #-96]!
	.cfi_def_cfa_offset 96
	stp	x26, x25, [sp, #16]
	stp	x24, x23, [sp, #32]
	stp	x22, x21, [sp, #48]
	stp	x20, x19, [sp, #64]
	stp	x29, x30, [sp, #80]
	add	x29, sp, #80
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	.cfi_offset w21, -40
	.cfi_offset w22, -48
	.cfi_offset w23, -56
	.cfi_offset w24, -64
	.cfi_offset w25, -72
	.cfi_offset w26, -80
	.cfi_offset w27, -88
	.cfi_offset w28, -96
	.cfi_remember_state
	sub	sp, sp, #592
	mov	x19, x1
	mov	x24, x0
	cmp	x1, #33
	b.hs	LBB9_4
LBB9_1:
	cmp	x19, #2
	b.lo	LBB9_54
	lsr	x22, x19, #1
	add	x23, x22, x22, lsl #1
	cmp	x19, #15
	b.ls	LBB9_28
	mov	w8, #12
	add	x20, sp, #8
	madd	x21, x19, x8, x20
	add	x1, sp, #8
	mov	x0, x24
	mov	x2, x21
	bl	__RINvNtNtNtNtCs94JkloGYSv0_4core5slice4sort6shared9smallsort12sort8_stableNtNtCs5Av9rWzHob7_3lib14identity_index5EntryNCINvMB8_SB19_20sort_unstable_by_keyyNCINvMs0_B1b_NtB1b_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs1_0E0EB1d_
	lsl	x8, x23, #2
	add	x0, x24, x8
	add	x1, x20, x8
	add	x2, x21, #96
	bl	__RINvNtNtNtNtCs94JkloGYSv0_4core5slice4sort6shared9smallsort12sort8_stableNtNtCs5Av9rWzHob7_3lib14identity_index5EntryNCINvMB8_SB19_20sort_unstable_by_keyyNCINvMs0_B1b_NtB1b_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs1_0E0EB1d_
	mov	w10, #8
	sub	x11, x19, x22
	cmp	x10, x22
	b.lo	LBB9_31
	b	LBB9_39
LBB9_4:
	mov	x21, x4
	mov	x22, x3
	mov	x23, x2
	mov	w25, #84
	mov	w26, #12
	add	x27, sp, #8
	b	LBB9_6
LBB9_5:
	mov	x23, #0
	madd	x8, x13, x26, x24
	ldr	x9, [x24]
	ldr	w10, [x24, #8]
	str	w10, [sp, #16]
	str	x9, [sp, #8]
	ldr	x9, [x8]
	ldr	w10, [x8, #8]
	str	w10, [x24, #8]
	str	x9, [x24]
	ldr	x9, [sp, #8]
	ldr	w10, [sp, #16]
	str	w10, [x8, #8]
	str	x9, [x8]
	mvn	x9, x13
	add	x19, x9, x19
	add	x24, x8, #12
	cmp	x19, #33
	b.lo	LBB9_1
LBB9_6:
	cbz	w22, LBB9_27
	lsr	x3, x19, #3
	mov	w8, #48
	madd	x1, x3, x8, x24
	madd	x2, x3, x25, x24
	cmp	x19, #64
	b.hs	LBB9_9
	ldr	x8, [x24]
	ldr	x9, [x1]
	cmp	x8, x9
	cset	w10, lo
	ldr	x11, [x2]
	cmp	x8, x11
	cset	w8, lo
	eor	w8, w10, w8
	cmp	x9, x11
	cset	w9, lo
	eor	w9, w10, w9
	cmp	w9, #0
	csel	x9, x2, x1, ne
	cmp	w8, #0
	csel	x0, x24, x9, ne
	sub	w22, w22, #1
	sub	x9, x0, x24
	cbnz	x23, LBB9_10
	b	LBB9_11
LBB9_9:
	mov	x0, x24
	bl	__RINvNtNtNtNtCs94JkloGYSv0_4core5slice4sort6shared5pivot11median3_recNtNtCs5Av9rWzHob7_3lib14identity_index5EntryNCINvMB8_SB14_20sort_unstable_by_keyyNCINvMs0_B16_NtB16_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs1_0E0EB18_
	sub	w22, w22, #1
	sub	x9, x0, x24
	cbz	x23, LBB9_11
LBB9_10:
	add	x8, x24, x9
	ldr	x10, [x23]
	ldr	x11, [x8]
	cmp	x10, x11
	b.hs	LBB9_19
LBB9_11:
	add	x8, x24, x9
	ldr	x9, [x24]
	ldr	w10, [x24, #8]
	str	w10, [sp, #16]
	str	x9, [sp, #8]
	ldr	x9, [x8]
	ldr	w10, [x8, #8]
	str	w10, [x24, #8]
	str	x9, [x24]
	ldr	x9, [sp, #8]
	ldr	w10, [sp, #16]
	str	w10, [x8, #8]
	str	x9, [x8]
	mov	x8, x24
	ldr	x9, [x8, #12]!
	str	x9, [sp, #8]
	ldr	w9, [x24, #20]
	str	w9, [sp, #16]
	madd	x9, x19, x26, x24
	sub	x12, x9, #12
	add	x10, x24, #24
	ldr	x11, [x24]
	cmp	x10, x12
	b.hs	LBB9_15
	mov	x1, #0
LBB9_13:
	ldr	x13, [x10]
	cmp	x13, x11
	madd	x14, x1, x26, x8
	ldr	w15, [x14, #8]
	ldr	x16, [x14]
	stur	x16, [x10, #-12]
	stur	w15, [x10, #-4]
	ldr	w15, [x10, #8]
	str	w15, [x14, #8]
	str	x13, [x14]
	cinc	x13, x1, lo
	ldur	x14, [x10, #12]
	cmp	x14, x11
	madd	x15, x13, x26, x8
	ldr	w16, [x15, #8]
	ldr	x17, [x15]
	str	x17, [x10]
	str	w16, [x10, #8]
	ldr	w16, [x10, #20]
	str	x14, [x15]
	str	w16, [x15, #8]
	cinc	x1, x13, lo
	add	x10, x10, #24
	cmp	x10, x12
	b.lo	LBB9_13
	sub	x12, x10, #12
	b	LBB9_16
LBB9_15:
	mov	x1, #0
	mov	x12, x8
LBB9_16:
	cmp	x10, x9
	csel	x13, x27, x10, eq
	ldr	x14, [x13]
	cmp	x14, x11
	madd	x14, x1, x26, x8
	cinc	x1, x1, lo
	ldr	x15, [x14]
	ldr	w16, [x14, #8]
	str	w16, [x12, #8]
	str	x15, [x12]
	ldr	x12, [x13]
	ldr	w13, [x13, #8]
	str	w13, [x14, #8]
	str	x12, [x14]
	cmp	x10, x9
	mov	x12, x10
	add	x10, x10, #12
	b.ne	LBB9_16
	cmp	x1, x19
	b.hs	LBB9_26
	madd	x28, x1, x26, x24
	ldr	x8, [x24]
	ldr	w9, [x24, #8]
	str	w9, [sp, #16]
	str	x8, [sp, #8]
	ldr	x8, [x28]
	ldr	w9, [x28, #8]
	str	w9, [x24, #8]
	str	x8, [x24]
	ldr	x8, [sp, #8]
	ldr	w9, [sp, #16]
	str	w9, [x28, #8]
	str	x8, [x28]
	add	x20, x28, #12
	mvn	x8, x1
	add	x19, x19, x8
	mov	x0, x24
	mov	x2, x23
	mov	x3, x22
	mov	x4, x21
	bl	__RINvNtNtNtNtCs94JkloGYSv0_4core5slice4sort8unstable9quicksort9quicksortNtNtCs5Av9rWzHob7_3lib14identity_index5EntryNCINvMB8_SB17_20sort_unstable_by_keyyNCINvMs0_B19_NtB19_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs1_0E0EB1b_
	mov	x23, x28
	mov	x24, x20
	cmp	x19, #33
	b.hs	LBB9_6
	b	LBB9_1
LBB9_19:
	ldr	x9, [x24]
	ldr	w10, [x24, #8]
	str	w10, [sp, #16]
	str	x9, [sp, #8]
	ldr	x9, [x8]
	ldr	w10, [x8, #8]
	str	w10, [x24, #8]
	str	x9, [x24]
	ldr	x9, [sp, #8]
	ldr	w10, [sp, #16]
	str	w10, [x8, #8]
	str	x9, [x8]
	mov	x8, x24
	ldr	x9, [x8, #12]!
	str	x9, [sp, #8]
	ldr	w9, [x24, #20]
	str	w9, [sp, #16]
	madd	x9, x19, x26, x24
	sub	x13, x9, #12
	add	x10, x24, #24
	ldr	x11, [x24]
	cmp	x10, x13
	b.hs	LBB9_23
	mov	x12, #0
LBB9_21:
	ldr	x14, [x10]
	cmp	x11, x14
	madd	x15, x12, x26, x8
	ldr	w16, [x15, #8]
	ldr	x17, [x15]
	stur	x17, [x10, #-12]
	stur	w16, [x10, #-4]
	ldr	w16, [x10, #8]
	str	w16, [x15, #8]
	str	x14, [x15]
	cinc	x12, x12, hs
	ldur	x14, [x10, #12]
	cmp	x11, x14
	madd	x15, x12, x26, x8
	ldr	w16, [x15, #8]
	ldr	x17, [x15]
	str	x17, [x10]
	str	w16, [x10, #8]
	ldr	w16, [x10, #20]
	str	x14, [x15]
	str	w16, [x15, #8]
	cinc	x12, x12, hs
	add	x10, x10, #24
	cmp	x10, x13
	b.lo	LBB9_21
	sub	x14, x10, #12
	b	LBB9_24
LBB9_23:
	mov	x12, #0
	mov	x14, x8
LBB9_24:
	cmp	x10, x9
	csel	x15, x27, x10, eq
	ldr	x13, [x15]
	cmp	x11, x13
	cinc	x13, x12, hs
	madd	x12, x12, x26, x8
	ldr	x16, [x12]
	ldr	w17, [x12, #8]
	str	w17, [x14, #8]
	str	x16, [x14]
	ldr	x14, [x15]
	ldr	w15, [x15, #8]
	str	w15, [x12, #8]
	str	x14, [x12]
	mov	x12, x13
	cmp	x10, x9
	mov	x14, x10
	add	x10, x10, #12
	b.ne	LBB9_24
	cmp	x13, x19
	b.lo	LBB9_5
LBB9_26:
	brk	#0x1
LBB9_27:
	mov	x0, x24
	mov	x1, x19
	add	sp, sp, #592
	.cfi_def_cfa wsp, 96
	ldp	x29, x30, [sp, #80]
	ldp	x20, x19, [sp, #64]
	ldp	x22, x21, [sp, #48]
	ldp	x24, x23, [sp, #32]
	ldp	x26, x25, [sp, #16]
	ldp	x28, x27, [sp], #96
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	.cfi_restore w19
	.cfi_restore w20
	.cfi_restore w21
	.cfi_restore w22
	.cfi_restore w23
	.cfi_restore w24
	.cfi_restore w25
	.cfi_restore w26
	.cfi_restore w27
	.cfi_restore w28
	b	__RINvNtNtNtNtCs94JkloGYSv0_4core5slice4sort8unstable8heapsort8heapsortNtNtCs5Av9rWzHob7_3lib14identity_index5EntryNCINvMB8_SB15_20sort_unstable_by_keyyNCINvMs0_B17_NtB17_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs1_0E0EB19_
LBB9_28:
	.cfi_restore_state
	.cfi_remember_state
	cmp	x19, #7
	b.ls	LBB9_30
	ldur	x8, [x24, #12]
	ldr	x9, [x24]
	cmp	x8, x9
	cset	w9, hs
	cset	w10, lo
	ldur	x11, [x24, #36]
	ldr	x12, [x24, #24]
	mov	w8, #12
	umaddl	x10, w10, w8, x24
	umaddl	x13, w9, w8, x24
	mov	w9, #24
	mov	w14, #36
	cmp	x11, x12
	csel	x11, x14, x9, lo
	add	x11, x24, x11
	csel	x12, x9, x14, lo
	add	x12, x24, x12
	ldr	x15, [x11]
	ldr	x16, [x10]
	ldr	x17, [x12]
	ldr	x0, [x13]
	cmp	x17, x0
	csel	x1, x11, x13, lo
	cmp	x15, x16
	csel	x15, x11, x10, lo
	csel	x10, x10, x1, lo
	csel	x11, x13, x11, lo
	cmp	x17, x0
	csel	x13, x13, x12, lo
	csel	x11, x12, x11, lo
	ldr	x12, [x11]
	ldr	x16, [x10]
	cmp	x12, x16
	csel	x12, x11, x10, lo
	csel	x10, x10, x11, lo
	ldr	w11, [x15, #8]
	ldr	x15, [x15]
	str	x15, [sp, #8]
	str	w11, [sp, #16]
	ldr	w11, [x12, #8]
	ldr	x12, [x12]
	stur	x12, [sp, #20]
	str	w11, [sp, #28]
	ldr	w11, [x10, #8]
	ldr	x10, [x10]
	str	x10, [sp, #32]
	str	w11, [sp, #40]
	ldr	x10, [x13]
	ldr	w11, [x13, #8]
	str	w11, [sp, #52]
	stur	x10, [sp, #44]
	lsl	x10, x23, #2
	add	x11, x24, x10
	ldur	x12, [x11, #12]
	ldr	x13, [x11]
	cmp	x12, x13
	cset	w12, hs
	cset	w13, lo
	ldur	x15, [x11, #36]
	ldr	x16, [x11, #24]
	cmp	x15, x16
	csel	x15, x14, x9, lo
	add	x15, x11, x15
	umaddl	x13, w13, w8, x11
	umaddl	x8, w12, w8, x11
	csel	x9, x9, x14, lo
	add	x9, x11, x9
	ldr	x11, [x15]
	ldr	x12, [x13]
	ldr	x14, [x9]
	ldr	x16, [x8]
	cmp	x14, x16
	csel	x17, x15, x8, lo
	cmp	x11, x12
	csel	x11, x15, x13, lo
	csel	x12, x13, x17, lo
	csel	x13, x8, x15, lo
	add	x15, sp, #8
	add	x10, x15, x10
	cmp	x14, x16
	csel	x8, x8, x9, lo
	csel	x9, x9, x13, lo
	ldr	x13, [x9]
	ldr	x14, [x12]
	cmp	x13, x14
	csel	x13, x9, x12, lo
	csel	x9, x12, x9, lo
	ldr	w12, [x11, #8]
	ldr	x11, [x11]
	str	x11, [x10]
	str	w12, [x10, #8]
	ldr	w11, [x13, #8]
	ldr	x12, [x13]
	stur	x12, [x10, #12]
	str	w11, [x10, #20]
	ldr	w11, [x9, #8]
	ldr	x9, [x9]
	str	x9, [x10, #24]
	str	w11, [x10, #32]
	ldr	x9, [x8]
	ldr	w8, [x8, #8]
	str	w8, [x10, #44]
	stur	x9, [x10, #36]
	mov	w10, #4
	sub	x11, x19, x22
	cmp	x10, x22
	b.lo	LBB9_31
	b	LBB9_39
LBB9_30:
	ldr	x8, [x24]
	ldr	w9, [x24, #8]
	str	w9, [sp, #16]
	str	x8, [sp, #8]
	lsl	x8, x23, #2
	add	x9, x24, x8
	add	x10, sp, #8
	add	x8, x10, x8
	ldr	x10, [x9]
	ldr	w9, [x9, #8]
	str	w9, [x8, #8]
	str	x10, [x8]
	mov	w10, #1
	sub	x11, x19, x22
	cmp	x10, x22
	b.hs	LBB9_39
LBB9_31:
	add	x8, x10, x10, lsl #1
	lsl	x8, x8, #2
	add	x9, sp, #8
	mov	x12, x10
	b	LBB9_35
LBB9_32:
	add	x15, x9, x17
LBB9_33:
	str	x13, [x15]
	str	w14, [x15, #8]
LBB9_34:
	add	x12, x12, #1
	add	x8, x8, #12
	cmp	x12, x22
	b.eq	LBB9_39
LBB9_35:
	add	x13, x12, x12, lsl #1
	lsl	x13, x13, #2
	add	x15, x24, x13
	add	x14, x9, x13
	ldr	x13, [x15]
	ldr	w15, [x15, #8]
	str	w15, [x14, #8]
	str	x13, [x14]
	ldur	x15, [x14, #-12]
	cmp	x13, x15
	b.hs	LBB9_34
	ldr	w14, [x14, #8]
	mov	x16, x8
LBB9_37:
	add	x15, sp, #8
	add	x17, x15, x16
	ldur	x0, [x17, #-12]
	str	x0, [x17]
	ldur	w0, [x17, #-4]
	str	w0, [x17, #8]
	subs	x17, x16, #12
	b.eq	LBB9_33
	add	x15, x9, x16
	ldur	x15, [x15, #-24]
	mov	x16, x17
	cmp	x13, x15
	b.lo	LBB9_37
	b	LBB9_32
LBB9_39:
	lsl	x12, x23, #2
	add	x8, sp, #8
	add	x9, x8, x12
	cmp	x10, x11
	b.hs	LBB9_49
	add	x12, x24, x12
	add	x13, x10, x10, lsl #1
	lsl	x13, x13, #2
	mov	w14, #12
	mov	x15, x9
	b	LBB9_44
LBB9_41:
	mov	x0, x9
LBB9_42:
	str	x16, [x0]
	str	w17, [x0, #8]
LBB9_43:
	add	x10, x10, #1
	add	x15, x15, #12
	sub	x14, x14, #12
	cmp	x10, x11
	b.eq	LBB9_49
LBB9_44:
	add	x16, x10, x10, lsl #1
	lsl	x16, x16, #2
	add	x0, x12, x16
	add	x17, x9, x16
	ldr	x16, [x0]
	ldr	w0, [x0, #8]
	str	w0, [x17, #8]
	str	x16, [x17]
	ldur	x0, [x17, #-12]
	cmp	x16, x0
	b.hs	LBB9_43
	ldr	w17, [x17, #8]
	mov	x1, x14
	mov	x0, x15
LBB9_46:
	add	x2, x0, x13
	ldur	x3, [x2, #-12]
	str	x3, [x2]
	ldur	w3, [x2, #-4]
	str	w3, [x2, #8]
	cmp	x13, x1
	b.eq	LBB9_41
	ldur	x2, [x2, #-24]
	sub	x0, x0, #12
	add	x1, x1, #12
	cmp	x16, x2
	b.lo	LBB9_46
	add	x0, x0, x13
	b	LBB9_42
LBB9_49:
	mov	w10, #12
	mov	x11, #-12
	madd	x13, x19, x10, x11
	add	x12, x8, x13
	sub	x14, x9, #12
	mov	x11, x24
LBB9_50:
	add	x15, x24, x13
	ldr	x16, [x9]
	ldr	x17, [x8]
	cmp	x16, x17
	csel	x16, x9, x8, lo
	ldr	x17, [x16]
	ldr	w16, [x16, #8]
	str	w16, [x11, #8]
	str	x17, [x11], #12
	csel	x16, x10, xzr, lo
	add	x9, x9, x16
	csel	x16, xzr, x10, lo
	add	x8, x8, x16
	ldr	x16, [x12]
	ldr	x17, [x14]
	cmp	x16, x17
	csel	x16, x14, x12, lo
	ldr	x17, [x16]
	ldr	w16, [x16, #8]
	str	w16, [x15, #8]
	str	x17, [x15]
	csetm	x15, hs
	madd	x12, x15, x10, x12
	csetm	x15, lo
	madd	x14, x15, x10, x14
	sub	x13, x13, #12
	subs	x22, x22, #1
	b.ne	LBB9_50
	add	x10, x14, #12
	add	x12, x12, #12
	tbz	w19, #0, LBB9_53
	cmp	x8, x10
	csel	x13, x8, x9, lo
	ldr	x14, [x13]
	ldr	w13, [x13, #8]
	str	w13, [x11, #8]
	str	x14, [x11]
	mov	w11, #12
	csel	x13, x11, xzr, lo
	add	x8, x8, x13
	csel	x11, xzr, x11, lo
	add	x9, x9, x11
LBB9_53:
	cmp	x9, x12
	ccmp	x8, x10, #0, eq
	b.ne	LBB9_55
LBB9_54:
	add	sp, sp, #592
	.cfi_def_cfa wsp, 96
	ldp	x29, x30, [sp, #80]
	ldp	x20, x19, [sp, #64]
	ldp	x22, x21, [sp, #48]
	ldp	x24, x23, [sp, #32]
	ldp	x26, x25, [sp, #16]
	ldp	x28, x27, [sp], #96
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	.cfi_restore w19
	.cfi_restore w20
	.cfi_restore w21
	.cfi_restore w22
	.cfi_restore w23
	.cfi_restore w24
	.cfi_restore w25
	.cfi_restore w26
	.cfi_restore w27
	.cfi_restore w28
	ret
LBB9_55:
	.cfi_restore_state
Ltmp5:
	bl	__RNvNtNtNtNtCs94JkloGYSv0_4core5slice4sort6shared9smallsort22panic_on_ord_violation
Ltmp6:
	b	LBB9_26
LBB9_56:
Ltmp7:
	mov	x21, x0
	add	x8, x19, x19, lsl #1
	lsl	x2, x8, #2
	add	x1, sp, #8
	mov	x0, x24
	bl	_memcpy
	mov	x0, x21
	bl	__Unwind_Resume
Lfunc_end1:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table9:
Lexception1:
	.byte	255
	.byte	255
	.byte	1
	.uleb128 Lcst_end1-Lcst_begin1
Lcst_begin1:
	.uleb128 Lfunc_begin1-Lfunc_begin1
	.uleb128 Ltmp5-Lfunc_begin1
	.byte	0
	.byte	0
	.uleb128 Ltmp5-Lfunc_begin1
	.uleb128 Ltmp6-Ltmp5
	.uleb128 Ltmp7-Lfunc_begin1
	.byte	0
	.uleb128 Ltmp6-Lfunc_begin1
	.uleb128 Lfunc_end1-Ltmp6
	.byte	0
	.byte	0
Lcst_end1:
	.p2align	2, 0x0

	.section	__TEXT,__literal8,8byte_literals
	.p2align	3, 0x0
lCPI10_0:
	.long	0
	.long	1
	.section	__TEXT,__text,regular,pure_instructions
	.globl	__RNvCs5Av9rWzHob7_3lib11hole_lookup
	.p2align	2
__RNvCs5Av9rWzHob7_3lib11hole_lookup:
Lfunc_begin2:
	.cfi_startproc
	.cfi_personality 155, _rust_eh_personality
	.cfi_lsda 16, Lexception2
	sub	sp, sp, #144
	.cfi_def_cfa_offset 144
	stp	x28, x27, [sp, #48]
	stp	x26, x25, [sp, #64]
	stp	x24, x23, [sp, #80]
	stp	x22, x21, [sp, #96]
	stp	x20, x19, [sp, #112]
	stp	x29, x30, [sp, #128]
	add	x29, sp, #128
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	.cfi_offset w21, -40
	.cfi_offset w22, -48
	.cfi_offset w23, -56
	.cfi_offset w24, -64
	.cfi_offset w25, -72
	.cfi_offset w26, -80
	.cfi_offset w27, -88
	.cfi_offset w28, -96
	.cfi_remember_state
	mov	w8, #34465
	movk	w8, #1, lsl #16
	cmp	x1, x8
	b.hs	LBB10_167
	mov	x22, x3
	mov	x19, x2
	mov	x20, x1
	cbz	x1, LBB10_13
	mov	x23, x0
	ldr	x21, [x0]
	cmp	x20, #1
	b.eq	LBB10_8
	lsl	x15, x20, #3
	ldr	x26, [x23, #8]
	adds	x28, x21, #1
	cset	w8, hs
	cmp	x28, x26
	csinc	w8, w8, wzr, eq
	cmp	w8, #0
	csel	x9, x26, xzr, ne
	mov	w10, #1
	cinc	x27, x10, ne
	cmp	x20, #2
	b.eq	LBB10_6
	sub	x10, x15, #16
	mov	w12, #2
	mov	x11, x26
LBB10_5:
	mov	x13, x11
	ldr	x11, [x23, x12, lsl #3]
	adds	x13, x13, #1
	cset	w14, hs
	cmp	x13, x11
	csinc	w13, w14, wzr, eq
	cmp	x27, #1
	cset	w14, eq
	tst	w13, w14
	csel	x8, x12, x8, ne
	add	x12, x12, #1
	csel	x9, x11, x9, ne
	add	x27, x27, x13
	subs	x10, x10, #8
	b.ne	LBB10_5
LBB10_6:
	cmp	x27, #2
	b.eq	LBB10_41
	cmp	x27, #1
	b.ne	LBB10_45
LBB10_8:
	mov	x8, #0
	cbz	x22, LBB10_14
LBB10_9:
	cmp	x8, #1
	b.gt	LBB10_19
	cbnz	x8, LBB10_29
	cmp	x22, #8
	b.hs	LBB10_68
	mov	x8, #0
	mov	x0, #0
	b	LBB10_71
LBB10_13:
	mov	x8, #0
	mov	x21, #0
	cbnz	x22, LBB10_9
LBB10_14:
	mov	x0, #0
LBB10_15:
	cmp	x8, #2
	b.lo	LBB10_129
	b.ne	LBB10_26
	cbz	x20, LBB10_129
	lsl	x1, x20, #4
	mov	x19, x0
	mov	x0, x21
	mov	w2, #8
	b	LBB10_28
LBB10_19:
	cmp	x8, #3
	b.ne	LBB10_31
	cbz	x20, LBB10_107
	cmp	x20, #1
	b.ne	LBB10_109
	mov	x0, #0
	ldr	x9, [x21]
	b	LBB10_24
LBB10_23:
	ldr	w10, [x21, #8]
	eor	x0, x10, x0
	subs	x22, x22, #1
	b.eq	LBB10_15
LBB10_24:
	ldr	x10, [x19], #8
	cmp	x9, x10
	b.eq	LBB10_23
	mov	x10, #-1
	eor	x0, x10, x0
	subs	x22, x22, #1
	b.ne	LBB10_24
	b	LBB10_15
LBB10_26:
	cbz	x20, LBB10_129
	add	x8, x20, x20, lsl #1
	lsl	x1, x8, #2
	mov	x19, x0
	mov	x0, x21
	mov	w2, #4
LBB10_28:
	bl	__RNvCs9wFQrvczXsK_7___rustc14___rust_dealloc
	mov	x0, x19
	b	LBB10_129
LBB10_29:
	ubfx	x9, x20, #17, #17
	lsr	x10, x20, #34
	and	x11, x20, #0x1ffff
	and	x12, x22, #0x7
	cmp	x22, #8
	b.hs	LBB10_73
	mov	x13, #0
	mov	x0, #0
	b	LBB10_100
LBB10_31:
	mov	x9, #0
	mov	x0, #0
	b	LBB10_33
LBB10_32:
	mov	x10, #-1
	eor	x0, x10, x0
	add	x9, x9, #1
	cmp	x9, x22
	b.eq	LBB10_15
LBB10_33:
	cbz	x20, LBB10_32
	ldr	x10, [x19, x9, lsl #3]
	cmp	x20, #1
	b.ne	LBB10_36
	mov	x11, #0
	b	LBB10_38
LBB10_36:
	mov	x11, #0
	mov	x12, x20
LBB10_37:
	lsr	x13, x12, #1
	add	x14, x13, x11
	lsl	x15, x14, #4
	ldr	x15, [x21, x15]
	cmp	x15, x10
	csel	x11, x11, x14, hi
	sub	x12, x12, x13
	cmp	x12, #1
	b.hi	LBB10_37
LBB10_38:
	lsl	x12, x11, #4
	ldr	x12, [x21, x12]
	cmp	x12, x10
	cinc	x11, x11, ls
	cbz	x11, LBB10_32
	add	x11, x21, x11, lsl #4
	ldur	x12, [x11, #-16]
	ldur	w13, [x11, #-4]
	sub	x10, x10, x12
	cmp	x10, x13
	b.hs	LBB10_32
	ldur	w11, [x11, #-8]
	add	x10, x10, x11
	eor	x0, x10, x0
	add	x9, x9, #1
	cmp	x9, x22
	b.ne	LBB10_33
	b	LBB10_15
LBB10_41:
	subs	x9, x9, x21
	b.lo	LBB10_45
	subs	x9, x9, x8
	b.lo	LBB10_45
	sub	x10, x9, #1
	mov	w11, #1073741822
	cmp	x10, x11
	b.hi	LBB10_45
	lsl	x8, x8, #17
	orr	x8, x8, x9, lsl #34
	orr	x20, x8, x20
	mov	w8, #1
	cbnz	x22, LBB10_9
	b	LBB10_14
LBB10_45:
	lsl	x25, x27, #4
	add	x8, x20, x20, lsl #1
	lsl	x24, x8, #2
	cmp	x25, x24
	b.hs	LBB10_52
	str	x15, [sp, #8]
	lsr	x8, x27, #60
	cbnz	x8, LBB10_168
	mov	x0, x25
	mov	w1, #8
	bl	__RNvMNtNtCs94JkloGYSv0_4core5alloc6layoutNtB2_6Layout23is_size_alignment_valid
	cbz	w0, LBB10_171
	cbz	x27, LBB10_121
	bl	__RNvCs9wFQrvczXsK_7___rustc35___rust_no_alloc_shim_is_unstable_v2
	mov	w24, #8
	mov	x0, x25
	mov	w1, #8
	bl	__RNvCs9wFQrvczXsK_7___rustc12___rust_alloc
	cbz	x0, LBB10_172
	stp	x27, x0, [sp, #16]
	str	xzr, [sp, #32]
	cmn	x21, #1
	b.eq	LBB10_132
	cmp	x28, x26
	b.eq	LBB10_123
	b	LBB10_132
LBB10_52:
	mov	x0, x24
	mov	w1, #4
	bl	__RNvMNtNtCs94JkloGYSv0_4core5alloc6layoutNtB2_6Layout23is_size_alignment_valid
	cbz	w0, LBB10_169
	bl	__RNvCs9wFQrvczXsK_7___rustc35___rust_no_alloc_shim_is_unstable_v2
	mov	w25, #4
	mov	x0, x24
	mov	w1, #4
	bl	__RNvCs9wFQrvczXsK_7___rustc12___rust_alloc
	cbz	x0, LBB10_170
	mov	x21, x0
	mov	x8, #0
	and	x10, x20, #0x1fffe
	mov	x9, x0
LBB10_55:
	ldp	x11, x12, [x23], #16
	str	x11, [x9]
	str	w8, [x9, #8]
	orr	w11, w8, #0x1
	stur	x12, [x9, #12]
	str	w11, [x9, #20]
	add	x8, x8, #2
	add	x9, x9, #24
	cmp	x8, x10
	b.ne	LBB10_55
	tbz	w20, #0, LBB10_58
	ldr	x10, [x23]
	str	x10, [x9]
	str	w8, [x9, #8]
LBB10_58:
	cmp	x20, #21
	b.hs	LBB10_115
	mov	x8, #0
	add	x9, x21, x24
	add	x11, x21, #12
	mov	x12, x21
	b	LBB10_63
LBB10_60:
	mov	x13, x21
LBB10_61:
	str	x11, [x13]
	str	w12, [x13, #8]
LBB10_62:
	add	x11, x10, #12
	add	x8, x8, #12
	mov	x12, x10
	cmp	x11, x9
	b.eq	LBB10_116
LBB10_63:
	mov	x10, x11
	ldur	x11, [x12, #12]
	ldr	x13, [x12]
	cmp	x11, x13
	b.hs	LBB10_62
	ldr	w12, [x12, #20]
	mov	x13, x8
LBB10_65:
	add	x14, x21, x13
	ldr	x15, [x14]
	stur	x15, [x14, #12]
	ldr	w15, [x14, #8]
	str	w15, [x14, #20]
	cbz	x13, LBB10_60
	ldur	x14, [x14, #-12]
	sub	x13, x13, #12
	cmp	x11, x14
	b.lo	LBB10_65
	add	x13, x21, x13
	add	x13, x13, #12
	b	LBB10_61
LBB10_68:
	and	x8, x22, #0xffffffffffffff8
	dup.2d	v0, x21
	dup.2d	v1, x20
	add	x9, x19, #32
	movi.2d	v2, #0000000000000000
	and	x10, x22, #0xffffffffffffff8
	movi.2d	v3, #0000000000000000
	movi.2d	v4, #0000000000000000
	movi.2d	v5, #0000000000000000
LBB10_69:
	ldp	q6, q7, [x9, #-32]
	ldp	q16, q17, [x9], #64
	cmhi.2d	v18, v0, v6
	cmhi.2d	v19, v0, v7
	cmhi.2d	v20, v0, v16
	cmhi.2d	v21, v0, v17
	sub.2d	v6, v6, v0
	sub.2d	v7, v7, v0
	sub.2d	v16, v16, v0
	sub.2d	v17, v17, v0
	cmhs.2d	v22, v6, v1
	cmhs.2d	v23, v7, v1
	cmhs.2d	v24, v16, v1
	cmhs.2d	v25, v17, v1
	orr.16b	v6, v18, v6
	orr.16b	v6, v6, v22
	orr.16b	v7, v19, v7
	orr.16b	v7, v7, v23
	orr.16b	v16, v20, v16
	orr.16b	v16, v16, v24
	orr.16b	v17, v21, v17
	orr.16b	v17, v17, v25
	eor.16b	v2, v6, v2
	eor.16b	v3, v7, v3
	eor.16b	v4, v16, v4
	eor.16b	v5, v17, v5
	subs	x10, x10, #8
	b.ne	LBB10_69
	eor.16b	v0, v3, v2
	eor3.16b	v0, v4, v0, v5
	ext.16b	v1, v0, v0, #8
	eor.8b	v0, v0, v1
	fmov	x0, d0
	cmp	x22, x8
	b.eq	LBB10_129
LBB10_71:
	sub	x9, x22, x8
	add	x8, x19, x8, lsl #3
LBB10_72:
	ldr	x10, [x8], #8
	subs	x11, x10, x21
	cmp	x11, x20
	csinv	x11, x11, xzr, lo
	cmp	x10, x21
	csinv	x10, x11, xzr, hs
	eor	x0, x10, x0
	subs	x9, x9, #1
	b.ne	LBB10_72
	b	LBB10_129
LBB10_73:
	mov	x13, #0
	mov	x0, #0
	and	x14, x22, #0xfffffffffffffff8
	neg	x14, x14
	add	x16, x19, #32
	mov	x15, #-1
	b	LBB10_76
LBB10_74:
	mov	x2, #-1
LBB10_75:
	eor	x17, x17, x0
	eor	x17, x1, x17
	eor	x0, x3, x17
	ldp	x17, x1, [x16, #8]
	ldr	x3, [x16, #24]
	ldr	x4, [x16], #64
	eor	x0, x2, x0
	sub	x2, x4, x21
	sub	x5, x2, x10
	cmp	x5, x9
	ccmp	x5, x11, #2, hs
	cset	w6, lo
	tst	w6, #0x1
	csinv	x5, x5, xzr, ne
	cmp	x2, x10
	csel	x5, x15, x5, lo
	cmp	x2, x9
	csel	x2, x2, x5, lo
	cmp	x4, x21
	csel	x2, x15, x2, lo
	eor	x0, x2, x0
	sub	x2, x17, x21
	sub	x4, x2, x10
	cmp	x4, x9
	ccmp	x4, x11, #2, hs
	cset	w5, lo
	tst	w5, #0x1
	csinv	x4, x4, xzr, ne
	cmp	x2, x10
	csel	x4, x15, x4, lo
	cmp	x2, x9
	csel	x2, x2, x4, lo
	cmp	x17, x21
	csel	x17, x15, x2, lo
	eor	x17, x17, x0
	sub	x0, x1, x21
	sub	x2, x0, x10
	cmp	x2, x9
	ccmp	x2, x11, #2, hs
	cset	w4, lo
	tst	w4, #0x1
	csinv	x2, x2, xzr, ne
	cmp	x0, x10
	csel	x2, x15, x2, lo
	cmp	x0, x9
	csel	x0, x0, x2, lo
	cmp	x1, x21
	csel	x0, x15, x0, lo
	eor	x17, x0, x17
	sub	x0, x3, x21
	sub	x1, x0, x10
	cmp	x1, x9
	ccmp	x1, x11, #2, hs
	cset	w2, lo
	tst	w2, #0x1
	csinv	x1, x1, xzr, ne
	cmp	x0, x10
	csel	x1, x15, x1, lo
	cmp	x0, x9
	csel	x0, x0, x1, lo
	cmp	x3, x21
	csel	x0, x15, x0, lo
	eor	x0, x0, x17
	sub	x13, x13, #8
	cmp	x14, x13
	b.eq	LBB10_98
LBB10_76:
	ldur	x17, [x16, #-32]
	subs	x17, x17, x21
	b.hs	LBB10_83
	mov	x17, #-1
	ldur	x1, [x16, #-24]
	subs	x1, x1, x21
	b.lo	LBB10_87
LBB10_78:
	cmp	x1, x9
	b.lo	LBB10_81
	subs	x1, x1, x10
	b.hs	LBB10_95
	mov	x1, #-1
LBB10_81:
	ldur	x2, [x16, #-16]
	subs	x3, x2, x21
	b.hs	LBB10_88
LBB10_82:
	mov	x3, #-1
	ldur	x2, [x16, #-8]
	subs	x2, x2, x21
	b.lo	LBB10_74
	b	LBB10_92
LBB10_83:
	cmp	x17, x9
	b.lo	LBB10_86
	subs	x17, x17, x10
	b.hs	LBB10_96
	mov	x17, #-1
LBB10_86:
	ldur	x1, [x16, #-24]
	subs	x1, x1, x21
	b.hs	LBB10_78
LBB10_87:
	mov	x1, #-1
	ldur	x2, [x16, #-16]
	subs	x3, x2, x21
	b.lo	LBB10_82
LBB10_88:
	cmp	x3, x9
	b.lo	LBB10_91
	subs	x2, x3, x10
	b.hs	LBB10_97
	mov	x3, #-1
LBB10_91:
	ldur	x2, [x16, #-8]
	subs	x2, x2, x21
	b.lo	LBB10_74
LBB10_92:
	cmp	x2, x9
	b.lo	LBB10_75
	subs	x2, x2, x10
	b.lo	LBB10_74
	cmp	x2, x9
	ccmp	x2, x11, #2, hs
	cset	w4, lo
	tst	w4, #0x1
	csinv	x2, x2, xzr, ne
	b	LBB10_75
LBB10_95:
	cmp	x1, x9
	ccmp	x1, x11, #2, hs
	cset	w2, lo
	tst	w2, #0x1
	csinv	x1, x1, xzr, ne
	ldur	x2, [x16, #-16]
	subs	x3, x2, x21
	b.lo	LBB10_82
	b	LBB10_88
LBB10_96:
	cmp	x17, x9
	ccmp	x17, x11, #2, hs
	cset	w1, lo
	tst	w1, #0x1
	csinv	x17, x17, xzr, ne
	ldur	x1, [x16, #-24]
	subs	x1, x1, x21
	b.lo	LBB10_87
	b	LBB10_78
LBB10_97:
	cmp	x2, x9
	ccmp	x2, x11, #2, hs
	cset	w3, lo
	tst	w3, #0x1
	csinv	x3, x2, xzr, ne
	ldur	x2, [x16, #-8]
	subs	x2, x2, x21
	b.hs	LBB10_92
	b	LBB10_74
LBB10_98:
	cbz	x12, LBB10_15
	neg	x13, x13
LBB10_100:
	add	x13, x19, x13, lsl #3
	b	LBB10_103
LBB10_101:
	mov	x14, #-1
LBB10_102:
	eor	x0, x14, x0
	subs	x12, x12, #1
	b.eq	LBB10_15
LBB10_103:
	ldr	x14, [x13], #8
	subs	x14, x14, x21
	b.lo	LBB10_101
	cmp	x14, x9
	b.lo	LBB10_102
	subs	x14, x14, x10
	b.lo	LBB10_101
	cmp	x14, x9
	ccmp	x14, x11, #2, hs
	cset	w15, lo
	tst	w15, #0x1
	csinv	x14, x14, xzr, ne
	b	LBB10_102
LBB10_107:
	cmp	x22, #8
	b.hs	LBB10_124
	mov	x8, #0
	mov	x0, #0
	b	LBB10_127
LBB10_109:
	mov	x9, #0
	mov	x0, #0
	mov	w10, #12
	b	LBB10_111
LBB10_110:
	ldr	w11, [x11, #8]
	eor	x0, x11, x0
	add	x9, x9, #1
	cmp	x9, x22
	b.eq	LBB10_15
LBB10_111:
	mov	x11, #0
	ldr	x12, [x19, x9, lsl #3]
	mov	x13, x20
LBB10_112:
	lsr	x14, x13, #1
	add	x15, x14, x11
	mul	x16, x15, x10
	ldr	x16, [x21, x16]
	cmp	x16, x12
	csel	x11, x11, x15, hi
	sub	x13, x13, x14
	cmp	x13, #1
	b.hi	LBB10_112
	madd	x11, x11, x10, x21
	ldr	x13, [x11]
	cmp	x13, x12
	b.eq	LBB10_110
	mov	x11, #-1
	eor	x0, x11, x0
	add	x9, x9, #1
	cmp	x9, x22
	b.ne	LBB10_111
	b	LBB10_15
LBB10_115:
Ltmp8:
	add	x2, sp, #16
	mov	x0, x21
	mov	x1, x20
	bl	__RINvNtNtNtCs94JkloGYSv0_4core5slice4sort8unstable7ipnsortNtNtCs5Av9rWzHob7_3lib14identity_index5EntryNCINvMB6_SBT_20sort_unstable_by_keyyNCINvMs0_BV_NtBV_13IdentityIndex8from_idsINtNtNtNtB8_4iter8adapters6copied6CopiedINtNtB6_4iter4IteryEEEs1_0E0EBX_
Ltmp9:
LBB10_116:
	add	x8, x20, #1
	mov	x9, x21
LBB10_117:
	sub	x8, x8, #1
	cmp	x8, #2
	b.lo	LBB10_120
	ldr	x10, [x9]
	ldr	x11, [x9, #12]!
	cmp	x10, x11
	b.ne	LBB10_117
Ltmp10:
Lloh0:
	adrp	x0, l_anon.ee989c0cbccf7c15b531251ac222b9e1.3@PAGE
Lloh1:
	add	x0, x0, l_anon.ee989c0cbccf7c15b531251ac222b9e1.3@PAGEOFF
Lloh2:
	adrp	x2, l_anon.ee989c0cbccf7c15b531251ac222b9e1.4@PAGE
Lloh3:
	add	x2, x2, l_anon.ee989c0cbccf7c15b531251ac222b9e1.4@PAGEOFF
	mov	w1, #73
	bl	__RNvNtCs94JkloGYSv0_4core9panicking9panic_fmt
Ltmp11:
	b	LBB10_175
LBB10_120:
	mov	w8, #3
	cbnz	x22, LBB10_9
	b	LBB10_14
LBB10_121:
	mov	w0, #8
	stp	xzr, x0, [sp, #16]
	str	xzr, [sp, #32]
	cmn	x21, #1
	b.eq	LBB10_130
	cmp	x28, x26
	b.ne	LBB10_130
LBB10_123:
	mov	x24, #0
	mov	w28, #0
	mov	w25, #2
	mov	x26, x21
	cmp	x20, #2
	b.ne	LBB10_133
	b	LBB10_140
LBB10_124:
	and	x8, x22, #0xffffffffffffff8
	movi.2d	v0, #0000000000000000
	and	x9, x22, #0xffffffffffffff8
	movi.2d	v3, #0000000000000000
	movi.2d	v1, #0000000000000000
	movi.2d	v2, #0000000000000000
LBB10_125:
	mov.16b	v4, v3
	mov.16b	v5, v0
	mvn.16b	v0, v0
	mvn.16b	v3, v3
	mvn.16b	v1, v1
	mvn.16b	v2, v2
	subs	x9, x9, #8
	b.ne	LBB10_125
	eor.16b	v0, v4, v5
	eor3.16b	v0, v0, v1, v2
	ext.16b	v1, v0, v0, #8
	eor.8b	v0, v0, v1
	fmov	x0, d0
	cmp	x22, x8
	b.eq	LBB10_129
LBB10_127:
	sub	x8, x22, x8
LBB10_128:
	mvn	x0, x0
	subs	x8, x8, #1
	b.ne	LBB10_128
LBB10_129:
	.cfi_def_cfa wsp, 144
	ldp	x29, x30, [sp, #128]
	ldp	x20, x19, [sp, #112]
	ldp	x22, x21, [sp, #96]
	ldp	x24, x23, [sp, #80]
	ldp	x26, x25, [sp, #64]
	ldp	x28, x27, [sp, #48]
	add	sp, sp, #144
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	.cfi_restore w19
	.cfi_restore w20
	.cfi_restore w21
	.cfi_restore w22
	.cfi_restore w23
	.cfi_restore w24
	.cfi_restore w25
	.cfi_restore w26
	.cfi_restore w27
	.cfi_restore w28
	ret
LBB10_130:
	.cfi_restore_state
Ltmp13:
	add	x0, sp, #16
	bl	__RNvMs3_NtCsdIxNTDZNnoR_5alloc7raw_vecINtB5_6RawVecNtNtCs5Av9rWzHob7_3lib14identity_index3RunE8grow_oneBQ_
Ltmp14:
	ldr	x0, [sp, #24]
LBB10_132:
	str	x21, [x0]
Lloh4:
	adrp	x8, lCPI10_0@PAGE
Lloh5:
	ldr	d0, [x8, lCPI10_0@PAGEOFF]
	str	d0, [x0, #8]
	mov	w24, #1
	str	x24, [sp, #32]
	mov	w28, #1
	mov	w25, #1
	cmp	x20, #2
	b.eq	LBB10_140
LBB10_133:
	ldr	x8, [sp, #8]
	sub	x20, x8, #16
	mov	w21, #2
	b	LBB10_135
LBB10_134:
	add	w25, w25, #1
	add	x21, x21, #1
	subs	x20, x20, #8
	b.eq	LBB10_140
LBB10_135:
	ldr	x27, [x23, x21, lsl #3]
	add	x8, x26, w25, uxtw
	cmp	x8, x26
	ccmp	x8, x27, #0, hs
	b.eq	LBB10_134
	ldr	x8, [sp, #16]
	cmp	x24, x8
	b.ne	LBB10_139
Ltmp16:
	add	x0, sp, #16
	bl	__RNvMs3_NtCsdIxNTDZNnoR_5alloc7raw_vecINtB5_6RawVecNtNtCs5Av9rWzHob7_3lib14identity_index3RunE8grow_oneBQ_
Ltmp17:
	ldr	x0, [sp, #24]
LBB10_139:
	add	x8, x0, x24, lsl #4
	str	x26, [x8]
	stp	w28, w25, [x8, #8]
	add	x24, x24, #1
	str	x24, [sp, #32]
	mov	w25, #1
	mov	x26, x27
	mov	x28, x21
	add	x21, x21, #1
	subs	x20, x20, #8
	b.ne	LBB10_135
LBB10_140:
	ldr	x8, [sp, #16]
	cmp	x24, x8
	b.ne	LBB10_142
Ltmp19:
	add	x0, sp, #16
	bl	__RNvMs3_NtCsdIxNTDZNnoR_5alloc7raw_vecINtB5_6RawVecNtNtCs5Av9rWzHob7_3lib14identity_index3RunE8grow_oneBQ_
Ltmp20:
LBB10_142:
	ldr	x23, [sp, #24]
	add	x8, x23, x24, lsl #4
	str	x26, [x8]
	stp	w28, w25, [x8, #8]
	add	x20, x24, #1
	str	x20, [sp, #32]
	cmp	x20, #2
	b.lo	LBB10_155
	cmp	x20, #21
	b.hs	LBB10_153
	mov	x8, #0
	add	x11, x23, #16
	mov	x12, x23
	add	x9, x23, x20, lsl #4
	b	LBB10_148
LBB10_145:
	mov	x13, x23
LBB10_146:
	stp	x11, x12, [x13]
LBB10_147:
	add	x11, x10, #16
	add	x8, x8, #16
	mov	x12, x10
	cmp	x11, x9
	b.eq	LBB10_154
LBB10_148:
	mov	x10, x11
	ldr	x11, [x12, #16]
	ldr	x13, [x12]
	cmp	x11, x13
	b.hs	LBB10_147
	ldr	x12, [x12, #24]
	mov	x13, x8
LBB10_150:
	add	x14, x23, x13
	ldr	q0, [x14]
	str	q0, [x14, #16]
	cbz	x13, LBB10_145
	ldur	x14, [x14, #-16]
	sub	x13, x13, #16
	cmp	x11, x14
	b.lo	LBB10_150
	add	x13, x23, x13
	add	x13, x13, #16
	b	LBB10_146
LBB10_153:
Ltmp21:
	add	x2, sp, #40
	mov	x0, x23
	mov	x1, x20
	bl	__RINvNtNtNtCs94JkloGYSv0_4core5slice4sort8unstable7ipnsortNtNtCs5Av9rWzHob7_3lib14identity_index3RunNCINvMB6_SBT_20sort_unstable_by_keyyNCINvMs0_BV_NtBV_13IdentityIndex8from_idsINtNtNtNtB8_4iter8adapters6copied6CopiedINtNtB6_4iter4IteryEEEs_0E0EBX_
Ltmp22:
	b	LBB10_155
LBB10_154:
	ldp	x23, x20, [sp, #24]
LBB10_155:
	add	x9, x23, #16
	add	x8, x20, #1
LBB10_156:
	sub	x8, x8, #1
	cmp	x8, #2
	b.lo	LBB10_160
	ldr	x10, [x9]
	ldur	x11, [x9, #-16]
	subs	x10, x10, x11
	b.lo	LBB10_159
	ldur	w11, [x9, #-4]
	add	x9, x9, #16
	cmp	x10, x11
	b.hs	LBB10_156
LBB10_159:
Ltmp23:
Lloh6:
	adrp	x0, l_anon.ee989c0cbccf7c15b531251ac222b9e1.3@PAGE
Lloh7:
	add	x0, x0, l_anon.ee989c0cbccf7c15b531251ac222b9e1.3@PAGEOFF
Lloh8:
	adrp	x2, l_anon.ee989c0cbccf7c15b531251ac222b9e1.5@PAGE
Lloh9:
	add	x2, x2, l_anon.ee989c0cbccf7c15b531251ac222b9e1.5@PAGEOFF
	mov	w1, #73
	bl	__RNvNtCs94JkloGYSv0_4core9panicking9panic_fmt
Ltmp24:
	b	LBB10_175
LBB10_160:
	ldr	x21, [sp, #16]
	cmp	x21, x20
	b.ls	LBB10_164
	lsl	x24, x21, #4
	cbz	x20, LBB10_166
	lsl	x25, x20, #4
	mov	x0, x23
	mov	x1, x24
	mov	w2, #8
	mov	x3, x25
	bl	__RNvCs9wFQrvczXsK_7___rustc14___rust_realloc
	mov	x21, x0
	cbz	x0, LBB10_174
	mov	w8, #2
	cbnz	x22, LBB10_9
	b	LBB10_14
LBB10_164:
	cmp	x20, x21
	b.hi	LBB10_173
	mov	x21, x23
	mov	w8, #2
	cbnz	x22, LBB10_9
	b	LBB10_14
LBB10_166:
	mov	w21, #8
	mov	x0, x23
	mov	x1, x24
	mov	w2, #8
	bl	__RNvCs9wFQrvczXsK_7___rustc14___rust_dealloc
	mov	w8, #2
	cbnz	x22, LBB10_9
	b	LBB10_14
LBB10_167:
Lloh10:
	adrp	x0, l_anon.ee989c0cbccf7c15b531251ac222b9e1.0@PAGE
Lloh11:
	add	x0, x0, l_anon.ee989c0cbccf7c15b531251ac222b9e1.0@PAGEOFF
Lloh12:
	adrp	x2, l_anon.ee989c0cbccf7c15b531251ac222b9e1.2@PAGE
Lloh13:
	add	x2, x2, l_anon.ee989c0cbccf7c15b531251ac222b9e1.2@PAGEOFF
	mov	w1, #63
	bl	__RNvNtCs94JkloGYSv0_4core9panicking9panic_fmt
LBB10_168:
	mov	x24, #0
	mov	x0, x24
	mov	x1, x25
	bl	__RNvNtCsdIxNTDZNnoR_5alloc7raw_vec12handle_error
LBB10_169:
	mov	x25, #0
LBB10_170:
	mov	x0, x25
	mov	x1, x24
	bl	__RNvNtCsdIxNTDZNnoR_5alloc7raw_vec12handle_error
LBB10_171:
	mov	x24, #0
LBB10_172:
	mov	x0, x24
	mov	x1, x25
	bl	__RNvNtCsdIxNTDZNnoR_5alloc7raw_vec12handle_error
LBB10_173:
Ltmp26:
Lloh14:
	adrp	x0, l_anon.ee989c0cbccf7c15b531251ac222b9e1.10@PAGE
Lloh15:
	add	x0, x0, l_anon.ee989c0cbccf7c15b531251ac222b9e1.10@PAGEOFF
Lloh16:
	adrp	x2, l_anon.ee989c0cbccf7c15b531251ac222b9e1.11@PAGE
Lloh17:
	add	x2, x2, l_anon.ee989c0cbccf7c15b531251ac222b9e1.11@PAGEOFF
	mov	w1, #113
	bl	__RNvNtCs94JkloGYSv0_4core9panicking9panic_fmt
Ltmp27:
	b	LBB10_175
LBB10_174:
Ltmp29:
	mov	w0, #8
	mov	x1, x25
	bl	__RNvNtCsdIxNTDZNnoR_5alloc7raw_vec12handle_error
Ltmp30:
LBB10_175:
	brk	#0x1
LBB10_176:
Ltmp15:
	b	LBB10_183
LBB10_177:
Ltmp31:
	mov	x19, x0
	mov	x0, x23
	mov	x1, x24
	b	LBB10_185
LBB10_178:
Ltmp28:
	mov	x19, x0
	cbz	x21, LBB10_187
	lsl	x1, x21, #4
	mov	x0, x23
	b	LBB10_185
LBB10_180:
Ltmp18:
	b	LBB10_183
LBB10_181:
Ltmp12:
	mov	x19, x0
	mov	x0, x21
	mov	x1, x24
	mov	w2, #4
	b	LBB10_186
LBB10_182:
Ltmp25:
LBB10_183:
	mov	x19, x0
	ldr	x8, [sp, #16]
	cbz	x8, LBB10_187
	ldr	x0, [sp, #24]
	lsl	x1, x8, #4
LBB10_185:
	mov	w2, #8
LBB10_186:
	bl	__RNvCs9wFQrvczXsK_7___rustc14___rust_dealloc
LBB10_187:
	mov	x0, x19
	bl	__Unwind_Resume
	.loh AdrpAdd	Lloh2, Lloh3
	.loh AdrpAdd	Lloh0, Lloh1
	.loh AdrpLdr	Lloh4, Lloh5
	.loh AdrpAdd	Lloh8, Lloh9
	.loh AdrpAdd	Lloh6, Lloh7
	.loh AdrpAdd	Lloh12, Lloh13
	.loh AdrpAdd	Lloh10, Lloh11
	.loh AdrpAdd	Lloh16, Lloh17
	.loh AdrpAdd	Lloh14, Lloh15
Lfunc_end2:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2, 0x0
GCC_except_table10:
Lexception2:
	.byte	255
	.byte	255
	.byte	1
	.uleb128 Lcst_end2-Lcst_begin2
Lcst_begin2:
	.uleb128 Lfunc_begin2-Lfunc_begin2
	.uleb128 Ltmp8-Lfunc_begin2
	.byte	0
	.byte	0
	.uleb128 Ltmp8-Lfunc_begin2
	.uleb128 Ltmp11-Ltmp8
	.uleb128 Ltmp12-Lfunc_begin2
	.byte	0
	.uleb128 Ltmp13-Lfunc_begin2
	.uleb128 Ltmp14-Ltmp13
	.uleb128 Ltmp15-Lfunc_begin2
	.byte	0
	.uleb128 Ltmp16-Lfunc_begin2
	.uleb128 Ltmp17-Ltmp16
	.uleb128 Ltmp18-Lfunc_begin2
	.byte	0
	.uleb128 Ltmp19-Lfunc_begin2
	.uleb128 Ltmp24-Ltmp19
	.uleb128 Ltmp25-Lfunc_begin2
	.byte	0
	.uleb128 Ltmp24-Lfunc_begin2
	.uleb128 Ltmp26-Ltmp24
	.byte	0
	.byte	0
	.uleb128 Ltmp26-Lfunc_begin2
	.uleb128 Ltmp27-Ltmp26
	.uleb128 Ltmp28-Lfunc_begin2
	.byte	0
	.uleb128 Ltmp29-Lfunc_begin2
	.uleb128 Ltmp30-Ltmp29
	.uleb128 Ltmp31-Lfunc_begin2
	.byte	0
	.uleb128 Ltmp30-Lfunc_begin2
	.uleb128 Lfunc_end2-Ltmp30
	.byte	0
	.byte	0
Lcst_end2:
	.p2align	2, 0x0

	.section	__TEXT,__text,regular,pure_instructions
	.globl	__RNvMs3_NtCsdIxNTDZNnoR_5alloc7raw_vecINtB5_6RawVecNtNtCs5Av9rWzHob7_3lib14identity_index3RunE8grow_oneBQ_
	.p2align	2
__RNvMs3_NtCsdIxNTDZNnoR_5alloc7raw_vecINtB5_6RawVecNtNtCs5Av9rWzHob7_3lib14identity_index3RunE8grow_oneBQ_:
	.cfi_startproc
	b	__RNvMs4_NtCsdIxNTDZNnoR_5alloc7raw_vecNtB5_11RawVecInner8grow_oneCs5Av9rWzHob7_3lib
	.cfi_endproc

	.p2align	2
__RNvMs4_NtCsdIxNTDZNnoR_5alloc7raw_vecNtB5_11RawVecInner11finish_growCs5Av9rWzHob7_3lib:
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
	add	x8, x4, x5
	sub	x8, x8, #1
	neg	x9, x4
	and	x8, x8, x9
	cmp	x5, x8
	b.ne	LBB12_14
	mov	x19, x0
	umulh	x8, x5, x3
	cmp	xzr, x8
	b.ne	LBB12_6
	mov	x21, x4
	mov	x23, x1
	mov	x24, x2
	mov	x22, x5
	mul	x20, x5, x3
	mov	x0, x20
	mov	x1, x4
	bl	__RNvMNtNtCs94JkloGYSv0_4core5alloc6layoutNtB2_6Layout23is_size_alignment_valid
	cbz	w0, LBB12_6
	cbz	x23, LBB12_7
	mul	x1, x22, x23
	cmp	x20, x1
	b.lo	LBB12_15
	mov	x0, x24
	mov	x2, x21
	mov	x3, x20
	bl	__RNvCs9wFQrvczXsK_7___rustc14___rust_realloc
	cbnz	x0, LBB12_11
	b	LBB12_9
LBB12_6:
	mov	x20, #0
	mov	w8, #1
	mov	w9, #8
	b	LBB12_13
LBB12_7:
	cbz	x20, LBB12_10
	bl	__RNvCs9wFQrvczXsK_7___rustc35___rust_no_alloc_shim_is_unstable_v2
	mov	x0, x20
	mov	x1, x21
	bl	__RNvCs9wFQrvczXsK_7___rustc12___rust_alloc
	cbnz	x0, LBB12_11
LBB12_9:
	str	x21, [x19, #8]
	mov	w8, #1
	b	LBB12_12
LBB12_10:
	mov	x0, x21
LBB12_11:
	mov	x8, #0
	str	x0, [x19, #8]
LBB12_12:
	mov	w9, #16
LBB12_13:
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
LBB12_14:
	.cfi_restore_state
Lloh18:
	adrp	x0, l_anon.ee989c0cbccf7c15b531251ac222b9e1.12@PAGE
Lloh19:
	add	x0, x0, l_anon.ee989c0cbccf7c15b531251ac222b9e1.12@PAGEOFF
Lloh20:
	adrp	x2, l_anon.ee989c0cbccf7c15b531251ac222b9e1.13@PAGE
Lloh21:
	add	x2, x2, l_anon.ee989c0cbccf7c15b531251ac222b9e1.13@PAGEOFF
	mov	w1, #73
	bl	__RNvNtCs94JkloGYSv0_4core9panicking5panic
LBB12_15:
Lloh22:
	adrp	x0, l_anon.ee989c0cbccf7c15b531251ac222b9e1.7@PAGE
Lloh23:
	add	x0, x0, l_anon.ee989c0cbccf7c15b531251ac222b9e1.7@PAGEOFF
Lloh24:
	adrp	x2, l_anon.ee989c0cbccf7c15b531251ac222b9e1.9@PAGE
Lloh25:
	add	x2, x2, l_anon.ee989c0cbccf7c15b531251ac222b9e1.9@PAGEOFF
	mov	w1, #145
	bl	__RNvNtCs94JkloGYSv0_4core9panicking9panic_fmt
	.loh AdrpAdd	Lloh20, Lloh21
	.loh AdrpAdd	Lloh18, Lloh19
	.loh AdrpAdd	Lloh24, Lloh25
	.loh AdrpAdd	Lloh22, Lloh23
	.cfi_endproc

	.p2align	2
__RNvMs4_NtCsdIxNTDZNnoR_5alloc7raw_vecNtB5_11RawVecInner8grow_oneCs5Av9rWzHob7_3lib:
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
	ldr	x21, [x0]
	lsl	x8, x21, #1
	cmp	x21, #0
	csinc	x20, x8, xzr, ne
	mov	w0, #16
	bl	__RNvNtCsdIxNTDZNnoR_5alloc7raw_vec16min_non_zero_cap
	cmp	x20, x0
	csel	x20, x20, x0, hi
	ldr	x2, [x19, #8]
	add	x0, sp, #8
	mov	x1, x21
	mov	x3, x20
	mov	w4, #8
	mov	w5, #16
	bl	__RNvMs4_NtCsdIxNTDZNnoR_5alloc7raw_vecNtB5_11RawVecInner11finish_growCs5Av9rWzHob7_3lib
	ldr	w8, [sp, #8]
	ldr	x0, [sp, #16]
	tbz	w8, #0, LBB13_3
	cmn	x0, #1
	b.eq	LBB13_4
	ldr	x1, [sp, #24]
	bl	__RNvNtCsdIxNTDZNnoR_5alloc7raw_vec12handle_error
LBB13_3:
	stp	x20, x0, [x19]
LBB13_4:
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

	.section	__TEXT,__const
l_anon.ee989c0cbccf7c15b531251ac222b9e1.0:
	.ascii	"admitted logical identity count"

	.section	__TEXT,__cstring,cstring_literals
l_anon.ee989c0cbccf7c15b531251ac222b9e1.1:
	.asciz	"/root/gpui-identity-hole-hot/reactivity/crates/gpui/src/runtime/identity_index.rs"

	.section	__DATA,__const
	.p2align	3, 0x0
l_anon.ee989c0cbccf7c15b531251ac222b9e1.2:
	.quad	l_anon.ee989c0cbccf7c15b531251ac222b9e1.1
	.asciz	"Q\000\000\000\000\000\000\000P\000\000\000\t\000\000"

	.section	__TEXT,__const
l_anon.ee989c0cbccf7c15b531251ac222b9e1.3:
	.ascii	"distinct admitted logical identities"

	.section	__DATA,__const
	.p2align	3, 0x0
l_anon.ee989c0cbccf7c15b531251ac222b9e1.4:
	.quad	l_anon.ee989c0cbccf7c15b531251ac222b9e1.1
	.asciz	"Q\000\000\000\000\000\000\000\227\000\000\000\t\000\000"

	.p2align	3, 0x0
l_anon.ee989c0cbccf7c15b531251ac222b9e1.5:
	.quad	l_anon.ee989c0cbccf7c15b531251ac222b9e1.1
	.asciz	"Q\000\000\000\000\000\000\000\203\000\000\000\r\000\000"

	.section	__TEXT,__cstring,cstring_literals
l_anon.ee989c0cbccf7c15b531251ac222b9e1.6:
	.asciz	"/nix/store/lynmg3kdpdz41r84nafwzi2n5nss50pq-rust-1.97.1-with-components-2026-07-16/lib/rustlib/src/rust/library/alloc/src/raw_vec/mod.rs"

	.section	__TEXT,__const
l_anon.ee989c0cbccf7c15b531251ac222b9e1.7:
	.ascii	"`new_layout.size()` must be greater than or equal to `old_layout.size()`"

	.section	__TEXT,__cstring,cstring_literals
l_anon.ee989c0cbccf7c15b531251ac222b9e1.8:
	.asciz	"/nix/store/lynmg3kdpdz41r84nafwzi2n5nss50pq-rust-1.97.1-with-components-2026-07-16/lib/rustlib/src/rust/library/alloc/src/alloc.rs"

	.section	__DATA,__const
	.p2align	3, 0x0
l_anon.ee989c0cbccf7c15b531251ac222b9e1.9:
	.quad	l_anon.ee989c0cbccf7c15b531251ac222b9e1.8
	.asciz	"\202\000\000\000\000\000\000\000\363\000\000\000\t\000\000"

	.section	__TEXT,__const
l_anon.ee989c0cbccf7c15b531251ac222b9e1.10:
	.ascii	"`len` must be smaller than or equal to `self.capacity()`"

	.section	__DATA,__const
	.p2align	3, 0x0
l_anon.ee989c0cbccf7c15b531251ac222b9e1.11:
	.quad	l_anon.ee989c0cbccf7c15b531251ac222b9e1.6
	.asciz	"\210\000\000\000\000\000\000\000\360\000\000\000\t\000\000"

	.section	__TEXT,__const
l_anon.ee989c0cbccf7c15b531251ac222b9e1.12:
	.ascii	"assertion failed: elem_layout.size() == elem_layout.pad_to_align().size()"

	.section	__DATA,__const
	.p2align	3, 0x0
l_anon.ee989c0cbccf7c15b531251ac222b9e1.13:
	.quad	l_anon.ee989c0cbccf7c15b531251ac222b9e1.6
	.asciz	"\210\000\000\000\000\000\000\000\203\003\000\000\005\000\000"

.subsections_via_symbols
