__RNvCs5Av9rWzHob7_3lib11runs_lookup:
Lfunc_begin6:
	.cfi_startproc
	.cfi_personality 155, _rust_eh_personality
	.cfi_lsda 16, Lexception6
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
	b.hs	LBB22_141
	mov	x19, x3
	mov	x20, x2
	mov	x21, x1
	cbz	x1, LBB22_22
	mov	x23, x0
	ldr	x22, [x0]
	cmp	x21, #1
	b.eq	LBB22_12
	lsl	x13, x21, #3
	ldr	x26, [x23, #8]
	adds	x28, x22, #1
	cset	w8, hs
	cmp	x28, x26
	csinc	w8, w8, wzr, eq
	cmp	w8, #0
	mov	w8, #1
	cinc	x27, x8, ne
	cmp	x21, #2
	b.eq	LBB22_11
	add	x8, x23, #16
	sub	x10, x13, #24
	mov	x9, x26
	cmp	x10, #56
	b.lo	LBB22_9
	lsr	x9, x10, #3
	add	x9, x9, #1
	and	x10, x9, #0x3ffffffffffffff8
	add	x8, x8, x10, lsl #3
	movi.2d	v0, #0000000000000000
	movi.2d	v1, #0000000000000000
	mov.d	v1[0], x27
	dup.2d	v2, x26
	add	x11, x23, #64
	movi.2d	v3, #0xffffffffffffffff
	mov	w12, #1
	dup.2d	v4, x12
	and	x12, x9, #0x3ffffffffffffff8
	movi.2d	v5, #0000000000000000
	movi.2d	v6, #0000000000000000
LBB22_6:
	ldp	q7, q16, [x11, #-48]
	ext.16b	v17, v2, v7, #8
	ldp	q18, q2, [x11, #-16]
	ext.16b	v19, v7, v16, #8
	ext.16b	v20, v16, v18, #8
	ext.16b	v21, v18, v2, #8
	cmeq.2d	v22, v17, v3
	cmeq.2d	v23, v19, v3
	cmeq.2d	v24, v20, v3
	cmeq.2d	v25, v21, v3
	add.2d	v17, v17, v4
	add.2d	v19, v19, v4
	add.2d	v20, v20, v4
	add.2d	v21, v21, v4
	cmeq.2d	v7, v17, v7
	cmeq.2d	v16, v19, v16
	cmeq.2d	v17, v20, v18
	cmeq.2d	v18, v21, v2
	orn.16b	v7, v22, v7
	orn.16b	v16, v23, v16
	orn.16b	v17, v24, v17
	orn.16b	v18, v25, v18
	sub.2d	v1, v1, v7
	sub.2d	v0, v0, v16
	sub.2d	v5, v5, v17
	sub.2d	v6, v6, v18
	add	x11, x11, #64
	subs	x12, x12, #8
	b.ne	LBB22_6
	add.2d	v0, v0, v1
	add.2d	v1, v6, v5
	add.2d	v0, v1, v0
	addp.2d	d0, v0
	fmov	x27, d0
	cmp	x9, x10
	b.eq	LBB22_11
	mov.d	x9, v2[1]
LBB22_9:
	add	x10, x23, x13
LBB22_10:
	mov	x11, x9
	ldr	x9, [x8], #8
	adds	x11, x11, #1
	cset	w12, hs
	cmp	x11, x9
	csinc	w11, w12, wzr, eq
	add	x27, x27, x11
	cmp	x8, x10
	b.ne	LBB22_10
LBB22_11:
	cmp	x27, #1
	b.ne	LBB22_39
LBB22_12:
	mov	x8, #0
	cbz	x19, LBB22_23
LBB22_13:
	cmp	x8, #2
	b.eq	LBB22_31
	cmp	x8, #1
	b.ne	LBB22_37
	cbz	x21, LBB22_67
	cmp	x21, #1
	b.ne	LBB22_71
	mov	x0, #0
	ldr	x9, [x22]
	b	LBB22_19
LBB22_18:
	mov	x10, #-1
	eor	x0, x10, x0
	subs	x19, x19, #1
	b.eq	LBB22_24
LBB22_19:
	ldr	x10, [x20], #8
	subs	x10, x10, x9
	b.lo	LBB22_18
	ldr	w11, [x22, #12]
	cmp	x10, x11
	b.hs	LBB22_18
	ldr	w11, [x22, #8]
	add	x10, x10, x11
	eor	x0, x10, x0
	subs	x19, x19, #1
	b.ne	LBB22_19
	b	LBB22_24
LBB22_22:
	mov	x8, #0
	mov	x22, #0
	cbnz	x19, LBB22_13
LBB22_23:
	mov	x0, #0
LBB22_24:
	cbz	x8, LBB22_100
	cmp	x8, #1
	b.ne	LBB22_28
	cbz	x21, LBB22_100
	lsl	x1, x21, #4
	mov	x19, x0
	mov	x0, x22
	mov	w2, #8
	b	LBB22_30
LBB22_28:
	cbz	x21, LBB22_100
	add	x8, x21, x21, lsl #1
	lsl	x1, x8, #2
	mov	x19, x0
	mov	x0, x22
	mov	w2, #4
LBB22_30:
	bl	__RNvCs9wFQrvczXsK_7___rustc14___rust_dealloc
	mov	x0, x19
	b	LBB22_100
LBB22_31:
	cbz	x21, LBB22_69
	cmp	x21, #1
	b.ne	LBB22_78
	mov	x0, #0
	ldr	x9, [x22]
	b	LBB22_35
LBB22_34:
	ldr	w10, [x22, #8]
	eor	x0, x10, x0
	subs	x19, x19, #1
	b.eq	LBB22_24
LBB22_35:
	ldr	x10, [x20], #8
	cmp	x9, x10
	b.eq	LBB22_34
	mov	x10, #-1
	eor	x0, x10, x0
	subs	x19, x19, #1
	b.ne	LBB22_35
	b	LBB22_24
LBB22_37:
	cmp	x19, #8
	b.hs	LBB22_46
	mov	x8, #0
	mov	x0, #0
	b	LBB22_49
LBB22_39:
	lsl	x25, x27, #4
	add	x8, x21, x21, lsl #1
	lsl	x24, x8, #2
	cmp	x25, x24
	b.hs	LBB22_51
	str	x13, [sp, #8]
	lsr	x8, x27, #60
	cbnz	x8, LBB22_142
	mov	x0, x25
	mov	w1, #8
	bl	__RNvMNtNtCs94JkloGYSv0_4core5alloc6layoutNtB2_6Layout23is_size_alignment_valid
	cbz	w0, LBB22_145
	cbz	x27, LBB22_101
	bl	__RNvCs9wFQrvczXsK_7___rustc35___rust_no_alloc_shim_is_unstable_v2
	mov	w24, #8
	mov	x0, x25
	mov	w1, #8
	bl	__RNvCs9wFQrvczXsK_7___rustc12___rust_alloc
	cbz	x0, LBB22_146
	stp	x27, x0, [sp, #16]
	str	xzr, [sp, #32]
	cmn	x22, #1
	b.eq	LBB22_106
	cmp	x28, x26
	b.eq	LBB22_103
	b	LBB22_106
LBB22_46:
	and	x8, x19, #0xffffffffffffff8
	dup.2d	v0, x22
	dup.2d	v1, x21
	add	x9, x20, #32
	movi.2d	v2, #0000000000000000
	and	x10, x19, #0xffffffffffffff8
	movi.2d	v3, #0000000000000000
	movi.2d	v4, #0000000000000000
	movi.2d	v5, #0000000000000000
LBB22_47:
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
	b.ne	LBB22_47
	eor.16b	v0, v3, v2
	eor3.16b	v0, v4, v0, v5
	ext.16b	v1, v0, v0, #8
	eor.8b	v0, v0, v1
	fmov	x0, d0
	cmp	x19, x8
	b.eq	LBB22_100
LBB22_49:
	sub	x9, x19, x8
	add	x8, x20, x8, lsl #3
LBB22_50:
	ldr	x10, [x8], #8
	subs	x11, x10, x22
	cmp	x11, x21
	csinv	x11, x11, xzr, lo
	cmp	x10, x22
	csinv	x10, x11, xzr, hs
	eor	x0, x10, x0
	subs	x9, x9, #1
	b.ne	LBB22_50
	b	LBB22_100
LBB22_51:
	mov	x0, x24
	mov	w1, #4
	bl	__RNvMNtNtCs94JkloGYSv0_4core5alloc6layoutNtB2_6Layout23is_size_alignment_valid
	cbz	w0, LBB22_143
	bl	__RNvCs9wFQrvczXsK_7___rustc35___rust_no_alloc_shim_is_unstable_v2
	mov	w25, #4
	mov	x0, x24
	mov	w1, #4
	bl	__RNvCs9wFQrvczXsK_7___rustc12___rust_alloc
	cbz	x0, LBB22_144
	mov	x22, x0
	mov	x8, #0
	and	x10, x21, #0x1fffe
	mov	x9, x0
LBB22_54:
	ldp	x11, x12, [x23], #16
	str	x11, [x9]
	str	w8, [x9, #8]
	orr	w11, w8, #0x1
	stur	x12, [x9, #12]
	str	w11, [x9, #20]
	add	x8, x8, #2
	add	x9, x9, #24
	cmp	x8, x10
	b.ne	LBB22_54
	tbz	w21, #0, LBB22_57
	ldr	x10, [x23]
	str	x10, [x9]
	str	w8, [x9, #8]
LBB22_57:
	cmp	x21, #21
	b.hs	LBB22_84
	mov	x8, #0
	add	x9, x22, x24
	add	x11, x22, #12
	mov	x12, x22
	b	LBB22_62
LBB22_59:
	mov	x13, x22
LBB22_60:
	str	x11, [x13]
	str	w12, [x13, #8]
LBB22_61:
	add	x11, x10, #12
	add	x8, x8, #12
	mov	x12, x10
	cmp	x11, x9
	b.eq	LBB22_85
LBB22_62:
	mov	x10, x11
	ldur	x11, [x12, #12]
	ldr	x13, [x12]
	cmp	x11, x13
	b.hs	LBB22_61
	ldr	w12, [x12, #20]
	mov	x13, x8
LBB22_64:
	add	x14, x22, x13
	ldr	x15, [x14]
	stur	x15, [x14, #12]
	ldr	w15, [x14, #8]
	str	w15, [x14, #20]
	cbz	x13, LBB22_59
	ldur	x14, [x14, #-12]
	sub	x13, x13, #12
	cmp	x11, x14
	b.lo	LBB22_64
	add	x13, x22, x13
	add	x13, x13, #12
	b	LBB22_60
LBB22_67:
	cmp	x19, #8
	b.hs	LBB22_90
	mov	x8, #0
	mov	x0, #0
	b	LBB22_93
LBB22_69:
	cmp	x19, #8
	b.hs	LBB22_95
	mov	x8, #0
	mov	x0, #0
	b	LBB22_98
LBB22_71:
	mov	x9, #0
	mov	x0, #0
	b	LBB22_73
LBB22_72:
	mov	x10, #-1
	eor	x0, x10, x0
	add	x9, x9, #1
	cmp	x9, x19
	b.eq	LBB22_24
LBB22_73:
	mov	x11, #0
	ldr	x10, [x20, x9, lsl #3]
	mov	x12, x21
LBB22_74:
	lsr	x13, x12, #1
	add	x14, x13, x11
	lsl	x15, x14, #4
	ldr	x15, [x22, x15]
	cmp	x15, x10
	csel	x11, x11, x14, hi
	sub	x12, x12, x13
	cmp	x12, #1
	b.hi	LBB22_74
	lsl	x12, x11, #4
	ldr	x12, [x22, x12]
	cmp	x12, x10
	cinc	x11, x11, ls
	cbz	x11, LBB22_72
	add	x11, x22, x11, lsl #4
	ldur	x12, [x11, #-16]
	ldur	w13, [x11, #-4]
	sub	x10, x10, x12
	cmp	x10, x13
	b.hs	LBB22_72
	ldur	w11, [x11, #-8]
	add	x10, x10, x11
	eor	x0, x10, x0
	add	x9, x9, #1
	cmp	x9, x19
	b.ne	LBB22_73
	b	LBB22_24
LBB22_78:
	mov	x9, #0
	mov	x0, #0
	mov	w10, #12
	b	LBB22_80
LBB22_79:
	ldr	w11, [x11, #8]
	eor	x0, x11, x0
	add	x9, x9, #1
	cmp	x9, x19
	b.eq	LBB22_24
LBB22_80:
	mov	x11, #0
	ldr	x12, [x20, x9, lsl #3]
	mov	x13, x21
LBB22_81:
	lsr	x14, x13, #1
	add	x15, x14, x11
	mul	x16, x15, x10
	ldr	x16, [x22, x16]
	cmp	x16, x12
	csel	x11, x11, x15, hi
	sub	x13, x13, x14
	cmp	x13, #1
	b.hi	LBB22_81
	madd	x11, x11, x10, x22
	ldr	x13, [x11]
	cmp	x13, x12
	b.eq	LBB22_79
	mov	x11, #-1
	eor	x0, x11, x0
	add	x9, x9, #1
	cmp	x9, x19
	b.ne	LBB22_80
	b	LBB22_24
LBB22_84:
Ltmp24:
	add	x2, sp, #16
	mov	x0, x22
	mov	x1, x21
	bl	__RINvNtNtNtCs94JkloGYSv0_4core5slice4sort8unstable7ipnsortNtNtCs5Av9rWzHob7_3lib10runs_index5EntryNCINvMB6_SBT_20sort_unstable_by_keyyNCINvMs_BV_NtBV_13IdentityIndex8from_idsINtNtNtNtB8_4iter8adapters6copied6CopiedINtNtB6_4iter4IteryEEEs0_0E0EBX_
Ltmp25:
LBB22_85:
	add	x8, x21, #1
	mov	x9, x22
LBB22_86:
	sub	x8, x8, #1
	cmp	x8, #2
	b.lo	LBB22_89
	ldr	x10, [x9]
	ldr	x11, [x9, #12]!
	cmp	x10, x11
	b.ne	LBB22_86
Ltmp26:
Lloh14:
	adrp	x0, l_anon.4f085434029274ba718f685435041e60.5@PAGE
Lloh15:
	add	x0, x0, l_anon.4f085434029274ba718f685435041e60.5@PAGEOFF
Lloh16:
	adrp	x2, l_anon.4f085434029274ba718f685435041e60.6@PAGE
Lloh17:
	add	x2, x2, l_anon.4f085434029274ba718f685435041e60.6@PAGEOFF
	mov	w1, #73
	bl	__RNvNtCs94JkloGYSv0_4core9panicking9panic_fmt
Ltmp27:
	b	LBB22_149
LBB22_89:
	mov	w8, #2
	cbnz	x19, LBB22_13
	b	LBB22_23
LBB22_90:
	and	x8, x19, #0xffffffffffffff8
	movi.2d	v0, #0000000000000000
	and	x9, x19, #0xffffffffffffff8
	movi.2d	v3, #0000000000000000
	movi.2d	v1, #0000000000000000
	movi.2d	v2, #0000000000000000
LBB22_91:
	mov.16b	v4, v3
	mov.16b	v5, v0
	mvn.16b	v0, v0
	mvn.16b	v3, v3
	mvn.16b	v1, v1
	mvn.16b	v2, v2
	subs	x9, x9, #8
	b.ne	LBB22_91
	eor.16b	v0, v4, v5
	eor3.16b	v0, v0, v1, v2
	ext.16b	v1, v0, v0, #8
	eor.8b	v0, v0, v1
	fmov	x0, d0
	cmp	x19, x8
	b.eq	LBB22_100
LBB22_93:
	sub	x8, x19, x8
LBB22_94:
	mvn	x0, x0
	subs	x8, x8, #1
	b.ne	LBB22_94
	b	LBB22_100
LBB22_95:
	and	x8, x19, #0xffffffffffffff8
	movi.2d	v0, #0000000000000000
	and	x9, x19, #0xffffffffffffff8
	movi.2d	v3, #0000000000000000
	movi.2d	v1, #0000000000000000
	movi.2d	v2, #0000000000000000
LBB22_96:
	mov.16b	v4, v3
	mov.16b	v5, v0
	mvn.16b	v0, v0
	mvn.16b	v3, v3
	mvn.16b	v1, v1
	mvn.16b	v2, v2
	subs	x9, x9, #8
	b.ne	LBB22_96
	eor.16b	v0, v4, v5
	eor3.16b	v0, v0, v1, v2
	ext.16b	v1, v0, v0, #8
	eor.8b	v0, v0, v1
	fmov	x0, d0
	cmp	x19, x8
	b.eq	LBB22_100
LBB22_98:
	sub	x8, x19, x8
LBB22_99:
	mvn	x0, x0
	subs	x8, x8, #1
	b.ne	LBB22_99
LBB22_100:
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
LBB22_101:
	.cfi_restore_state
	mov	w0, #8
	stp	xzr, x0, [sp, #16]
	str	xzr, [sp, #32]
	cmn	x22, #1
	b.eq	LBB22_104
	cmp	x28, x26
	b.ne	LBB22_104
LBB22_103:
	mov	x24, #0
	mov	w28, #0
	mov	w25, #2
	mov	x26, x22
	cmp	x21, #2
	b.ne	LBB22_107
	b	LBB22_114
LBB22_104:
Ltmp29:
	add	x0, sp, #16
	bl	__RNvMs3_NtCsdIxNTDZNnoR_5alloc7raw_vecINtB5_6RawVecNtNtCs5Av9rWzHob7_3lib10runs_index3RunE8grow_oneBQ_
Ltmp30:
	ldr	x0, [sp, #24]
LBB22_106:
	str	x22, [x0]
Lloh18:
	adrp	x8, lCPI22_0@PAGE
Lloh19:
	ldr	d0, [x8, lCPI22_0@PAGEOFF]
	str	d0, [x0, #8]
	mov	w24, #1
	str	x24, [sp, #32]
	mov	w28, #1
	mov	w25, #1
	cmp	x21, #2
	b.eq	LBB22_114
LBB22_107:
	ldr	x8, [sp, #8]
	sub	x21, x8, #16
	mov	w22, #2
	b	LBB22_109
LBB22_108:
	add	w25, w25, #1
	add	x22, x22, #1
	subs	x21, x21, #8
	b.eq	LBB22_114
LBB22_109:
	ldr	x27, [x23, x22, lsl #3]
	add	x8, x26, w25, uxtw
	cmp	x8, x26
	ccmp	x8, x27, #0, hs
	b.eq	LBB22_108
	ldr	x8, [sp, #16]
	cmp	x24, x8
	b.ne	LBB22_113
Ltmp32:
	add	x0, sp, #16
	bl	__RNvMs3_NtCsdIxNTDZNnoR_5alloc7raw_vecINtB5_6RawVecNtNtCs5Av9rWzHob7_3lib10runs_index3RunE8grow_oneBQ_
Ltmp33:
	ldr	x0, [sp, #24]
LBB22_113:
	add	x8, x0, x24, lsl #4
	str	x26, [x8]
	stp	w28, w25, [x8, #8]
	add	x24, x24, #1
	str	x24, [sp, #32]
	mov	w25, #1
	mov	x26, x27
	mov	x28, x22
	add	x22, x22, #1
	subs	x21, x21, #8
	b.ne	LBB22_109
LBB22_114:
	ldr	x8, [sp, #16]
	cmp	x24, x8
	b.ne	LBB22_116
Ltmp35:
	add	x0, sp, #16
	bl	__RNvMs3_NtCsdIxNTDZNnoR_5alloc7raw_vecINtB5_6RawVecNtNtCs5Av9rWzHob7_3lib10runs_index3RunE8grow_oneBQ_
Ltmp36:
LBB22_116:
	ldr	x23, [sp, #24]
	add	x8, x23, x24, lsl #4
	str	x26, [x8]
	stp	w28, w25, [x8, #8]
	add	x21, x24, #1
	str	x21, [sp, #32]
	cmp	x21, #2
	b.lo	LBB22_129
	cmp	x21, #21
	b.hs	LBB22_127
	mov	x8, #0
	add	x11, x23, #16
	mov	x12, x23
	add	x9, x23, x21, lsl #4
	b	LBB22_122
LBB22_119:
	mov	x13, x23
LBB22_120:
	stp	x11, x12, [x13]
LBB22_121:
	add	x11, x10, #16
	add	x8, x8, #16
	mov	x12, x10
	cmp	x11, x9
	b.eq	LBB22_128
LBB22_122:
	mov	x10, x11
	ldr	x11, [x12, #16]
	ldr	x13, [x12]
	cmp	x11, x13
	b.hs	LBB22_121
	ldr	x12, [x12, #24]
	mov	x13, x8
LBB22_124:
	add	x14, x23, x13
	ldr	q0, [x14]
	str	q0, [x14, #16]
	cbz	x13, LBB22_119
	ldur	x14, [x14, #-16]
	sub	x13, x13, #16
	cmp	x11, x14
	b.lo	LBB22_124
	add	x13, x23, x13
	add	x13, x13, #16
	b	LBB22_120
LBB22_127:
Ltmp37:
	add	x2, sp, #40
	mov	x0, x23
	mov	x1, x21
	bl	__RINvNtNtNtCs94JkloGYSv0_4core5slice4sort8unstable7ipnsortNtNtCs5Av9rWzHob7_3lib10runs_index3RunNCINvMB6_SBT_20sort_unstable_by_keyyNCINvMs_BV_NtBV_13IdentityIndex8from_idsINtNtNtNtB8_4iter8adapters6copied6CopiedINtNtB6_4iter4IteryEEE0E0EBX_
Ltmp38:
	b	LBB22_129
LBB22_128:
	ldp	x23, x21, [sp, #24]
LBB22_129:
	add	x9, x23, #16
	add	x8, x21, #1
LBB22_130:
	sub	x8, x8, #1
	cmp	x8, #2
	b.lo	LBB22_134
	ldr	x10, [x9]
	ldur	x11, [x9, #-16]
	subs	x10, x10, x11
	b.lo	LBB22_133
	ldur	w11, [x9, #-4]
	add	x9, x9, #16
	cmp	x10, x11
	b.hs	LBB22_130
LBB22_133:
Ltmp39:
Lloh20:
	adrp	x0, l_anon.4f085434029274ba718f685435041e60.5@PAGE
Lloh21:
	add	x0, x0, l_anon.4f085434029274ba718f685435041e60.5@PAGEOFF
Lloh22:
	adrp	x2, l_anon.4f085434029274ba718f685435041e60.7@PAGE
Lloh23:
	add	x2, x2, l_anon.4f085434029274ba718f685435041e60.7@PAGEOFF
	mov	w1, #73
	bl	__RNvNtCs94JkloGYSv0_4core9panicking9panic_fmt
Ltmp40:
	b	LBB22_149
LBB22_134:
	ldr	x22, [sp, #16]
	cmp	x22, x21
	b.ls	LBB22_138
	lsl	x24, x22, #4
	cbz	x21, LBB22_140
	lsl	x25, x21, #4
	mov	x0, x23
	mov	x1, x24
	mov	w2, #8
	mov	x3, x25
	bl	__RNvCs9wFQrvczXsK_7___rustc14___rust_realloc
	mov	x22, x0
	cbz	x0, LBB22_148
	mov	w8, #1
	cbnz	x19, LBB22_13
	b	LBB22_23
LBB22_138:
	cmp	x21, x22
	b.hi	LBB22_147
	mov	x22, x23
	mov	w8, #1
	cbnz	x19, LBB22_13
	b	LBB22_23
LBB22_140:
	mov	w22, #8
	mov	x0, x23
	mov	x1, x24
	mov	w2, #8
	bl	__RNvCs9wFQrvczXsK_7___rustc14___rust_dealloc
	mov	w8, #1
	cbnz	x19, LBB22_13
	b	LBB22_23
LBB22_141:
Lloh24:
	adrp	x0, l_anon.4f085434029274ba718f685435041e60.2@PAGE
Lloh25:
	add	x0, x0, l_anon.4f085434029274ba718f685435041e60.2@PAGEOFF
Lloh26:
	adrp	x2, l_anon.4f085434029274ba718f685435041e60.4@PAGE
Lloh27:
	add	x2, x2, l_anon.4f085434029274ba718f685435041e60.4@PAGEOFF
	mov	w1, #63
	bl	__RNvNtCs94JkloGYSv0_4core9panicking9panic_fmt
LBB22_142:
	mov	x24, #0
	mov	x0, x24
	mov	x1, x25
	bl	__RNvNtCsdIxNTDZNnoR_5alloc7raw_vec12handle_error
LBB22_143:
	mov	x25, #0
LBB22_144:
	mov	x0, x25
	mov	x1, x24
	bl	__RNvNtCsdIxNTDZNnoR_5alloc7raw_vec12handle_error
LBB22_145:
	mov	x24, #0
LBB22_146:
	mov	x0, x24
	mov	x1, x25
	bl	__RNvNtCsdIxNTDZNnoR_5alloc7raw_vec12handle_error
LBB22_147:
Ltmp42:
Lloh28:
	adrp	x0, l_anon.4f085434029274ba718f685435041e60.25@PAGE
Lloh29:
	add	x0, x0, l_anon.4f085434029274ba718f685435041e60.25@PAGEOFF
Lloh30:
	adrp	x2, l_anon.4f085434029274ba718f685435041e60.26@PAGE
Lloh31:
	add	x2, x2, l_anon.4f085434029274ba718f685435041e60.26@PAGEOFF
	mov	w1, #113
	bl	__RNvNtCs94JkloGYSv0_4core9panicking9panic_fmt
Ltmp43:
	b	LBB22_149
LBB22_148:
Ltmp45:
	mov	w0, #8
	mov	x1, x25
	bl	__RNvNtCsdIxNTDZNnoR_5alloc7raw_vec12handle_error
Ltmp46:
LBB22_149:
	brk	#0x1
LBB22_150:
Ltmp31:
	b	LBB22_157
LBB22_151:
Ltmp47:
	mov	x19, x0
	mov	x0, x23
	mov	x1, x24
	b	LBB22_159
LBB22_152:
Ltmp44:
	mov	x19, x0
	cbz	x22, LBB22_161
	lsl	x1, x22, #4
	mov	x0, x23
	b	LBB22_159
LBB22_154:
Ltmp34:
	b	LBB22_157
LBB22_155:
Ltmp28:
	mov	x19, x0
	mov	x0, x22
	mov	x1, x24
	mov	w2, #4
	b	LBB22_160
LBB22_156:
Ltmp41:
LBB22_157:
	mov	x19, x0
	ldr	x8, [sp, #16]
	cbz	x8, LBB22_161
	ldr	x0, [sp, #24]
	lsl	x1, x8, #4
LBB22_159:
	mov	w2, #8
LBB22_160:
	bl	__RNvCs9wFQrvczXsK_7___rustc14___rust_dealloc
LBB22_161:
	mov	x0, x19
	bl	__Unwind_Resume
	.loh AdrpAdd	Lloh16, Lloh17
	.loh AdrpAdd	Lloh14, Lloh15
	.loh AdrpLdr	Lloh18, Lloh19
	.loh AdrpAdd	Lloh22, Lloh23
	.loh AdrpAdd	Lloh20, Lloh21
	.loh AdrpAdd	Lloh26, Lloh27
	.loh AdrpAdd	Lloh24, Lloh25
	.loh AdrpAdd	Lloh30, Lloh31
	.loh AdrpAdd	Lloh28, Lloh29
Lfunc_end6:
	.cfi_endproc

__RNvCs5Av9rWzHob7_3lib11tree_lookup:
Lfunc_begin7:
	.cfi_startproc
	.cfi_personality 155, _rust_eh_personality
	.cfi_lsda 16, Lexception7
	sub	sp, sp, #304
	.cfi_def_cfa_offset 304
	stp	x28, x27, [sp, #208]
	stp	x26, x25, [sp, #224]
	stp	x24, x23, [sp, #240]
	stp	x22, x21, [sp, #256]
	stp	x20, x19, [sp, #272]
	stp	x29, x30, [sp, #288]
	add	x29, sp, #288
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
	mov	x19, x3
	mov	x20, x2
	mov	x24, x1
	mov	x23, x0
	lsl	x21, x1, #4
	mov	x0, x21
	mov	w1, #8
	bl	__RNvMNtNtCs94JkloGYSv0_4core5alloc6layoutNtB2_6Layout23is_size_alignment_valid
	cbz	w0, LBB23_123
	cbz	x24, LBB23_5
	bl	__RNvCs9wFQrvczXsK_7___rustc35___rust_no_alloc_shim_is_unstable_v2
	mov	w25, #8
	mov	x0, x21
	mov	w1, #8
	bl	__RNvCs9wFQrvczXsK_7___rustc12___rust_alloc
	cbz	x0, LBB23_124
	mov	x22, x0
	cmp	x24, #8
	b.hs	LBB23_7
	mov	x8, #0
	b	LBB23_10
LBB23_5:
	cbnz	x19, LBB23_91
	mov	x21, #0
	b	LBB23_101
LBB23_7:
	and	x8, x24, #0xffffffffffffff8
	add	x9, x23, #32
Lloh32:
	adrp	x10, lCPI23_0@PAGE
Lloh33:
	ldr	q1, [x10, lCPI23_0@PAGEOFF]
	add	x10, x22, #64
	mov	w11, #2
	dup.2d	v2, x11
	mov	w11, #4
	dup.2d	v3, x11
	mov	w11, #6
	dup.2d	v4, x11
	mov	w11, #8
	dup.2d	v5, x11
	and	x11, x24, #0xffffffffffffff8
LBB23_8:
	add.2d	v7, v1, v2
	add.2d	v17, v1, v3
	add.2d	v19, v1, v4
	ldp	q0, q6, [x9, #-32]
	sub	x12, x10, #64
	st2.2d	{ v0, v1 }, [x12]
	ldp	q16, q18, [x9], #64
	sub	x12, x10, #32
	st2.2d	{ v6, v7 }, [x12]
	add	x12, x10, #128
	st2.2d	{ v16, v17 }, [x10], #32
	st2.2d	{ v18, v19 }, [x10]
	add.2d	v1, v1, v5
	mov	x10, x12
	subs	x11, x11, #8
	b.ne	LBB23_8
	cmp	x24, x8
	b.eq	LBB23_12
LBB23_10:
	add	x9, x22, x8, lsl #4
	add	x9, x9, #8
LBB23_11:
	ldr	x10, [x23, x8, lsl #3]
	stp	x10, x8, [x9, #-8]
	add	x8, x8, #1
	add	x9, x9, #16
	cmp	x24, x8
	b.ne	LBB23_11
LBB23_12:
	cmp	x24, #1
	b.eq	LBB23_24
	cmp	x24, #21
	b.hs	LBB23_23
	mov	x8, #0
	add	x9, x22, x21
	add	x11, x22, #16
	mov	x12, x22
	b	LBB23_18
LBB23_15:
	mov	x13, x22
LBB23_16:
	stp	x11, x12, [x13]
LBB23_17:
	add	x11, x10, #16
	add	x8, x8, #16
	mov	x12, x10
	cmp	x11, x9
	b.eq	LBB23_24
LBB23_18:
	mov	x10, x11
	ldr	x11, [x12, #16]
	ldr	x13, [x12]
	cmp	x11, x13
	b.hs	LBB23_17
	ldr	x12, [x12, #24]
	mov	x13, x8
LBB23_20:
	add	x14, x22, x13
	ldr	q0, [x14]
	str	q0, [x14, #16]
	cbz	x13, LBB23_15
	ldur	x14, [x14, #-16]
	sub	x13, x13, #16
	cmp	x11, x14
	b.lo	LBB23_20
	add	x13, x22, x13
	add	x13, x13, #16
	b	LBB23_16
LBB23_23:
Ltmp48:
	add	x2, sp, #96
	mov	x0, x22
	mov	x1, x24
	bl	__RINvNtNtNtCs94JkloGYSv0_4core5slice4sort6stable14driftsort_mainTyjENCINvMNtCsdIxNTDZNnoR_5alloc5sliceSBZ_7sort_byNCINvXs1o_NtNtNtB1b_11collections5btree3mapINtB1X_8BTreeMapyjEINtNtNtNtB8_4iter6traits7collect12FromIteratorBZ_E9from_iterINtNtNtB2U_8adapters3map3MapINtNtB3Q_9enumerate9EnumerateINtNtB3Q_6copied6CopiedINtNtB6_4iter4IteryEEENCNvCs5Av9rWzHob7_3lib11tree_lookup0EE0E0INtNtB1b_3vec3VecBZ_EEB5t_
Ltmp49:
LBB23_24:
	bl	__RNvCs9wFQrvczXsK_7___rustc35___rust_no_alloc_shim_is_unstable_v2
	mov	w0, #192
	mov	w1, #8
	bl	__RNvCs9wFQrvczXsK_7___rustc12___rust_alloc
	cbz	x0, LBB23_121
	mov	x23, x0
	stp	x20, x19, [sp]
	mov	x28, #0
	mov	x20, #0
	str	xzr, [x0]
	strh	wzr, [x0, #186]
	add	x10, x22, x24, lsl #4
	mov	w11, #2
	mov	x24, x22
	stp	x24, x21, [sp, #24]
	mov	x27, x0
	str	x10, [sp, #40]
	b	LBB23_28
LBB23_26:
	add	w9, w8, #1
	strh	w9, [x27, #186]
	add	x9, x27, x8, lsl #3
	str	x25, [x9, #8]
	str	x21, [x9, #96]
	ldrh	w9, [x27, #186]
	cmp	w8, w9
	b.hs	LBB23_110
LBB23_27:
	add	x28, x28, #1
	mov	x25, x19
LBB23_28:
	cmp	x11, #2
	b.eq	LBB23_37
	cbz	x11, LBB23_61
	cmp	x24, x10
	b.eq	LBB23_39
LBB23_31:
	add	x9, x24, #16
	ldp	x19, x8, [x24]
	cmp	x25, x19
	b.ne	LBB23_40
	cmp	x9, x10
	b.eq	LBB23_41
	add	x9, x24, #32
	ldp	x19, x22, [x24, #16]
	cmp	x25, x19
	b.ne	LBB23_42
LBB23_34:
	mov	x21, x22
	cmp	x9, x10
	b.eq	LBB23_43
	add	x24, x9, #16
	ldp	x19, x22, [x9]
	mov	x9, x24
	cmp	x25, x19
	b.eq	LBB23_34
	mov	w11, #1
	ldrh	w8, [x27, #186]
	cmp	w8, #11
	b.lo	LBB23_26
	b	LBB23_44
LBB23_37:
	cmp	x24, x10
	b.eq	LBB23_61
	ldp	x25, x22, [x24], #16
	cmp	x24, x10
	b.ne	LBB23_31
LBB23_39:
	mov	x11, #0
	mov	x19, #0
	mov	x21, x22
	mov	x24, x10
	mov	x22, #0
	ldrh	w8, [x27, #186]
	cmp	w8, #11
	b.lo	LBB23_26
	b	LBB23_44
LBB23_40:
	mov	x21, x22
	mov	w11, #1
	mov	x22, x8
	mov	x24, x9
	ldrh	w8, [x27, #186]
	cmp	w8, #11
	b.lo	LBB23_26
	b	LBB23_44
LBB23_41:
	mov	x11, #0
	mov	x19, #0
	mov	x22, #0
	mov	x21, x8
	mov	x24, x10
	ldrh	w8, [x27, #186]
	cmp	w8, #11
	b.lo	LBB23_26
	b	LBB23_44
LBB23_42:
	mov	x21, x8
	mov	w11, #1
	mov	x24, x9
	ldrh	w8, [x27, #186]
	cmp	w8, #11
	b.lo	LBB23_26
	b	LBB23_44
LBB23_43:
	mov	x11, #0
	mov	x19, #0
	mov	x22, #0
	mov	x24, x10
	ldrh	w8, [x27, #186]
	cmp	w8, #11
	b.lo	LBB23_26
LBB23_44:
	mov	x8, #0
	str	x11, [sp, #48]
LBB23_45:
	ldr	x27, [x27]
	cbz	x27, LBB23_49
	subs	x8, x8, #1
	b.eq	LBB23_108
	ldrh	w9, [x27, #186]
	cmp	w9, #11
	b.hs	LBB23_45
	str	x20, [sp, #64]
	neg	x20, x8
	mov	x26, x23
	b	LBB23_52
LBB23_49:
	bl	__RNvCs9wFQrvczXsK_7___rustc35___rust_no_alloc_shim_is_unstable_v2
	mov	w0, #288
	mov	w1, #8
	bl	__RNvCs9wFQrvczXsK_7___rustc12___rust_alloc
	cbz	x0, LBB23_118
	mov	x26, x0
	str	xzr, [x0]
	strh	wzr, [x0, #186]
	str	x23, [x0, #192]
	adds	x20, x20, #1
	b.hs	LBB23_119
	str	x26, [x23]
	strh	wzr, [x23, #184]
	mov	x27, x26
	str	x20, [sp, #64]
LBB23_52:
	bl	__RNvCs9wFQrvczXsK_7___rustc35___rust_no_alloc_shim_is_unstable_v2
	mov	w0, #192
	mov	w1, #8
	bl	__RNvCs9wFQrvczXsK_7___rustc12___rust_alloc
	cbz	x0, LBB23_111
	mov	x23, x0
	str	x28, [sp, #56]
	str	xzr, [x0]
	strh	wzr, [x0, #186]
	sub	x28, x20, #1
	cbz	x28, LBB23_56
LBB23_54:
	bl	__RNvCs9wFQrvczXsK_7___rustc35___rust_no_alloc_shim_is_unstable_v2
	mov	w0, #288
	mov	w1, #8
	bl	__RNvCs9wFQrvczXsK_7___rustc12___rust_alloc
	cbz	x0, LBB23_107
	str	xzr, [x0]
	strh	wzr, [x0, #186]
	str	x23, [x0, #192]
	str	x0, [x23]
	strh	wzr, [x23, #184]
	mov	x23, x0
	subs	x28, x28, #1
	b.ne	LBB23_54
LBB23_56:
	ldrh	w8, [x27, #186]
	cmp	w8, #10
	b.hi	LBB23_112
	add	w9, w8, #1
	strh	w9, [x27, #186]
	add	x9, x27, x8, lsl #3
	str	x25, [x9, #8]
	str	x21, [x9, #96]
	add	x9, x8, #1
	add	x10, x27, x9, lsl #3
	str	x23, [x10, #192]
	ldrh	w10, [x27, #186]
	cmp	w8, w10
	b.hs	LBB23_113
	str	x27, [x23]
	strh	w9, [x23, #184]
LBB23_59:
	ldrh	w8, [x27, #186]
	add	x8, x27, x8, lsl #3
	ldr	x27, [x8, #192]
	subs	x20, x20, #1
	b.ne	LBB23_59
	mov	x23, x26
	ldp	x28, x20, [sp, #56]
	ldp	x10, x11, [sp, #40]
	b	LBB23_27
LBB23_61:
	str	x23, [sp, #16]
	str	x28, [sp, #56]
	ldp	x0, x1, [sp, #24]
	mov	w2, #8
	bl	__RNvCs9wFQrvczXsK_7___rustc14___rust_dealloc
	str	x20, [sp, #64]
	cbz	x20, LBB23_76
	mov	w19, #5
	ldr	x28, [sp, #64]
	ldr	x23, [sp, #16]
	b	LBB23_65
LBB23_63:
	ldr	x8, [x20, #232]
	str	x20, [x8]
	strh	w19, [x8, #184]
LBB23_64:
	mov	x23, x20
	sub	x28, x28, #1
	cbz	x28, LBB23_76
LBB23_65:
	ldrh	w26, [x23, #186]
	cbz	w26, LBB23_114
	sub	x8, x26, #1
	add	x27, x23, x8, lsl #3
	ldr	x25, [x27, #192]
	ldrh	w24, [x25, #186]
	cmp	x24, #9
	b.ls	LBB23_115
	ldr	x20, [x27, #200]
	ldrh	w8, [x20, #186]
	cmp	x8, #5
	b.hs	LBB23_64
	sub	x10, x19, x8
	sub	x22, x24, x10
	strh	w22, [x25, #186]
	strh	w19, [x20, #186]
	add	x9, x20, #8
	str	x10, [sp, #48]
	lsl	x19, x10, #3
	lsl	x21, x8, #3
	add	x0, x9, x19
	add	x1, x20, #8
	mov	x2, x21
	bl	_memmove
	add	x8, x20, #96
	stp	x21, x19, [sp, #32]
	add	x0, x8, x19
	add	x1, x20, #96
	mov	x2, x21
	bl	_memmove
	add	x9, x22, #1
	sub	x21, x24, x9
	add	x10, x25, #8
	add	x8, x22, #1
	str	x8, [sp, #24]
	lsl	x19, x9, #3
	lsl	x24, x21, #3
	add	x0, x20, #8
	add	x1, x10, x19
	mov	x2, x24
	bl	_memcpy
	add	x8, x25, #96
	add	x0, x20, #96
	add	x1, x8, x19
	add	x19, x25, #96
	mov	x2, x24
	bl	_memcpy
	ldrh	w8, [x23, #186]
	sub	x9, x26, #1
	cmp	x9, x8
	b.hs	LBB23_120
	ldr	x8, [x19, x22, lsl #3]
	add	x9, x25, #8
	ldr	x9, [x9, x22, lsl #3]
	ldr	x10, [x23, x26, lsl #3]
	str	x9, [x23, x26, lsl #3]
	ldr	x9, [x27, #96]
	str	x8, [x27, #96]
	ldr	x8, [sp, #48]
	str	x10, [x20, x8, lsl #3]
	add	x8, x20, #96
	str	x9, [x8, x21, lsl #3]
	cmp	x28, #1
	mov	w19, #5
	b.eq	LBB23_76
	add	x8, x20, #192
	ldr	x21, [sp, #40]
	add	x0, x8, x21
	add	x1, x20, #192
	ldr	x8, [sp, #32]
	add	x2, x8, #8
	bl	_memmove
	ldr	x8, [sp, #24]
	add	x8, x25, x8, lsl #3
	add	x0, x20, #192
	add	x1, x8, #192
	mov	x2, x21
	bl	_memcpy
	ldr	x8, [x20, #192]
	str	x20, [x8]
	strh	wzr, [x8, #184]
	ldrh	w8, [x20, #186]
	cbz	w8, LBB23_75
	ldr	x8, [x20, #200]
	str	x20, [x8]
	mov	w9, #1
	strh	w9, [x8, #184]
	ldrh	w8, [x20, #186]
	cmp	w8, #2
	b.lo	LBB23_75
	ldr	x8, [x20, #208]
	str	x20, [x8]
	mov	w9, #2
	strh	w9, [x8, #184]
	ldrh	w8, [x20, #186]
	cmp	w8, #3
	b.lo	LBB23_75
	ldr	x8, [x20, #216]
	str	x20, [x8]
	mov	w9, #3
	strh	w9, [x8, #184]
	ldrh	w8, [x20, #186]
	cmp	w8, #4
	b.lo	LBB23_75
	ldr	x8, [x20, #224]
	str	x20, [x8]
	mov	w9, #4
	strh	w9, [x8, #184]
	ldrh	w8, [x20, #186]
	cmp	w8, #5
	b.hs	LBB23_63
LBB23_75:
Lloh34:
	adrp	x0, l_anon.4f085434029274ba718f685435041e60.14@PAGE
Lloh35:
	add	x0, x0, l_anon.4f085434029274ba718f685435041e60.14@PAGEOFF
Lloh36:
	adrp	x2, l_anon.4f085434029274ba718f685435041e60.15@PAGE
Lloh37:
	add	x2, x2, l_anon.4f085434029274ba718f685435041e60.15@PAGEOFF
	mov	w1, #33
	bl	__RNvNtCs94JkloGYSv0_4core9panicking5panic
LBB23_76:
	ldp	x19, x7, [sp, #8]
	ldp	x5, x6, [sp, #56]
	stp	x7, x6, [sp, #72]
	str	x5, [sp, #88]
	cbz	x19, LBB23_93
	cbz	x7, LBB23_91
	mov	x9, #0
	mov	x21, #0
Lloh38:
	adrp	x8, l_anon.4f085434029274ba718f685435041e60.31@PAGE
Lloh39:
	add	x8, x8, l_anon.4f085434029274ba718f685435041e60.31@PAGEOFF
Lloh40:
	adrp	x10, l_anon.4f085434029274ba718f685435041e60.30@PAGE
Lloh41:
	add	x10, x10, l_anon.4f085434029274ba718f685435041e60.30@PAGEOFF
Lloh42:
	adrp	x2, l_anon.4f085434029274ba718f685435041e60.33@PAGE
Lloh43:
	add	x2, x2, l_anon.4f085434029274ba718f685435041e60.33@PAGEOFF
	mov	w1, #35
Lloh44:
	adrp	x0, l_anon.4f085434029274ba718f685435041e60.32@PAGE
Lloh45:
	add	x0, x0, l_anon.4f085434029274ba718f685435041e60.32@PAGEOFF
	ldr	x4, [sp]
LBB23_79:
	ldr	x11, [x4, x9, lsl #3]
	mov	x13, x7
	mov	x12, x6
LBB23_80:
	ldrh	w15, [x13, #186]
	add	x16, x13, #88
	lsl	x17, x15, #3
	mov	x14, #-1
LBB23_81:
	cbz	x17, LBB23_86
	ldur	x3, [x16, #-80]
	cmp	x11, x3
	cset	w3, hi
	csinv	w3, w3, wzr, hs
	add	x16, x16, #8
	sub	x17, x17, #8
	add	x14, x14, #1
	and	w3, w3, #0xff
	cmp	w3, #1
	b.eq	LBB23_81
	cbz	w3, LBB23_88
	cmp	x14, x15
	b.hi	LBB23_117
	cbnz	x12, LBB23_87
	b	LBB23_90
LBB23_86:
	mov	x14, x15
	cbz	x12, LBB23_90
LBB23_87:
	add	x13, x13, x14, lsl #3
	sub	x12, x12, #1
	ldr	x13, [x13, #192]
	b	LBB23_80
LBB23_88:
	cmp	x14, x15
	b.hs	LBB23_116
	ldr	x11, [x16]
	eor	x21, x11, x21
	add	x9, x9, #1
	cmp	x9, x19
	b.ne	LBB23_79
	b	LBB23_94
LBB23_90:
	mov	x11, #-1
	eor	x21, x11, x21
	add	x9, x9, #1
	cmp	x9, x19
	b.ne	LBB23_79
	b	LBB23_94
LBB23_91:
	cmp	x19, #8
	b.hs	LBB23_96
	mov	x8, #0
	mov	x21, #0
	b	LBB23_99
LBB23_93:
	mov	x21, #0
LBB23_94:
	cbz	x7, LBB23_101
	stp	xzr, x7, [sp, #104]
	str	x6, [sp, #120]
	stp	xzr, x7, [sp, #136]
	mov	w8, #1
	str	x6, [sp, #152]
	b	LBB23_102
LBB23_96:
	and	x8, x19, #0xffffffffffffff8
	movi.2d	v0, #0000000000000000
	and	x9, x19, #0xffffffffffffff8
	movi.2d	v3, #0000000000000000
	movi.2d	v1, #0000000000000000
	movi.2d	v2, #0000000000000000
LBB23_97:
	mov.16b	v4, v3
	mov.16b	v5, v0
	mvn.16b	v0, v0
	mvn.16b	v3, v3
	mvn.16b	v1, v1
	mvn.16b	v2, v2
	subs	x9, x9, #8
	b.ne	LBB23_97
	eor.16b	v0, v4, v5
	eor3.16b	v0, v0, v1, v2
	ext.16b	v1, v0, v0, #8
	eor.8b	v0, v0, v1
	fmov	x21, d0
	cmp	x19, x8
	b.eq	LBB23_101
LBB23_99:
	sub	x8, x19, x8
LBB23_100:
	mvn	x21, x21
	subs	x8, x8, #1
	b.ne	LBB23_100
LBB23_101:
	mov	x8, #0
	mov	x5, #0
LBB23_102:
	str	x8, [sp, #96]
	str	x8, [sp, #128]
	str	x5, [sp, #160]
LBB23_103:
	sub	x0, x29, #120
	add	x1, sp, #96
	bl	__RNvMsz_NtNtNtCsdIxNTDZNnoR_5alloc11collections5btree3mapINtB5_8IntoIteryjE10dying_nextCs5Av9rWzHob7_3lib
	ldur	x8, [x29, #-120]
	cbz	x8, LBB23_106
	ldur	x9, [x29, #-104]
	ldrh	w8, [x8, #186]
	cmp	x9, x8
	b.lo	LBB23_103
Ltmp80:
Lloh46:
	adrp	x0, l_anon.4f085434029274ba718f685435041e60.34@PAGE
Lloh47:
	add	x0, x0, l_anon.4f085434029274ba718f685435041e60.34@PAGEOFF
Lloh48:
	adrp	x2, l_anon.4f085434029274ba718f685435041e60.36@PAGE
Lloh49:
	add	x2, x2, l_anon.4f085434029274ba718f685435041e60.36@PAGEOFF
	mov	w1, #44
	bl	__RNvNtCs94JkloGYSv0_4core9panicking5panic
Ltmp81:
	b	LBB23_122
LBB23_106:
	mov	x0, x21
	.cfi_def_cfa wsp, 304
	ldp	x29, x30, [sp, #288]
	ldp	x20, x19, [sp, #272]
	ldp	x22, x21, [sp, #256]
	ldp	x24, x23, [sp, #240]
	ldp	x26, x25, [sp, #224]
	ldp	x28, x27, [sp, #208]
	add	sp, sp, #304
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
LBB23_107:
	.cfi_restore_state
Ltmp57:
	mov	w0, #8
	mov	w1, #288
	bl	__RNvNtCsdIxNTDZNnoR_5alloc5alloc18handle_alloc_error
Ltmp58:
	b	LBB23_122
LBB23_108:
Lloh50:
	adrp	x0, l_anon.4f085434029274ba718f685435041e60.37@PAGE
Lloh51:
	add	x0, x0, l_anon.4f085434029274ba718f685435041e60.37@PAGEOFF
	mov	w1, #28
Lloh52:
	adrp	x2, l_anon.4f085434029274ba718f685435041e60.38@PAGE
Lloh53:
	add	x2, x2, l_anon.4f085434029274ba718f685435041e60.38@PAGEOFF
LBB23_109:
Ltmp74:
	ldp	x21, x20, [sp, #24]
	bl	__RNvNtCs94JkloGYSv0_4core9panicking5panic
Ltmp75:
	b	LBB23_122
LBB23_110:
Lloh54:
	adrp	x0, l_anon.4f085434029274ba718f685435041e60.30@PAGE
Lloh55:
	add	x0, x0, l_anon.4f085434029274ba718f685435041e60.30@PAGEOFF
Lloh56:
	adrp	x2, l_anon.4f085434029274ba718f685435041e60.31@PAGE
Lloh57:
	add	x2, x2, l_anon.4f085434029274ba718f685435041e60.31@PAGEOFF
	mov	w1, #34
	b	LBB23_109
LBB23_111:
Ltmp63:
	mov	w0, #8
	mov	w1, #192
	ldp	x21, x20, [sp, #24]
	bl	__RNvNtCsdIxNTDZNnoR_5alloc5alloc18handle_alloc_error
Ltmp64:
	b	LBB23_122
LBB23_112:
Lloh58:
	adrp	x0, l_anon.4f085434029274ba718f685435041e60.41@PAGE
Lloh59:
	add	x0, x0, l_anon.4f085434029274ba718f685435041e60.41@PAGEOFF
	mov	w1, #32
Lloh60:
	adrp	x2, l_anon.4f085434029274ba718f685435041e60.42@PAGE
Lloh61:
	add	x2, x2, l_anon.4f085434029274ba718f685435041e60.42@PAGEOFF
	b	LBB23_109
LBB23_113:
Lloh62:
	adrp	x0, l_anon.4f085434029274ba718f685435041e60.32@PAGE
Lloh63:
	add	x0, x0, l_anon.4f085434029274ba718f685435041e60.32@PAGEOFF
	mov	w1, #35
Lloh64:
	adrp	x2, l_anon.4f085434029274ba718f685435041e60.33@PAGE
Lloh65:
	add	x2, x2, l_anon.4f085434029274ba718f685435041e60.33@PAGEOFF
	b	LBB23_109
LBB23_114:
Lloh66:
	adrp	x0, l_anon.4f085434029274ba718f685435041e60.39@PAGE
Lloh67:
	add	x0, x0, l_anon.4f085434029274ba718f685435041e60.39@PAGEOFF
Lloh68:
	adrp	x2, l_anon.4f085434029274ba718f685435041e60.40@PAGE
Lloh69:
	add	x2, x2, l_anon.4f085434029274ba718f685435041e60.40@PAGEOFF
	mov	w1, #25
	bl	__RNvNtCs94JkloGYSv0_4core9panicking5panic
LBB23_115:
Lloh70:
	adrp	x0, l_anon.4f085434029274ba718f685435041e60.27@PAGE
Lloh71:
	add	x0, x0, l_anon.4f085434029274ba718f685435041e60.27@PAGEOFF
Lloh72:
	adrp	x2, l_anon.4f085434029274ba718f685435041e60.29@PAGE
Lloh73:
	add	x2, x2, l_anon.4f085434029274ba718f685435041e60.29@PAGEOFF
	mov	w1, #57
	bl	__RNvNtCs94JkloGYSv0_4core9panicking5panic
LBB23_116:
	mov	x0, x10
	mov	w1, #34
	mov	x2, x8
LBB23_117:
Ltmp51:
	bl	__RNvNtCs94JkloGYSv0_4core9panicking5panic
Ltmp52:
	b	LBB23_122
LBB23_118:
Ltmp68:
	mov	w0, #8
	mov	w1, #288
	bl	__RNvNtCsdIxNTDZNnoR_5alloc5alloc18handle_alloc_error
Ltmp69:
	b	LBB23_122
LBB23_119:
Ltmp65:
Lloh74:
	adrp	x0, l_anon.4f085434029274ba718f685435041e60.1@PAGE
Lloh75:
	add	x0, x0, l_anon.4f085434029274ba718f685435041e60.1@PAGEOFF
	bl	__RNvNtCs94JkloGYSv0_4core6option13unwrap_failed
Ltmp66:
	b	LBB23_122
LBB23_120:
Lloh76:
	adrp	x0, l_anon.4f085434029274ba718f685435041e60.34@PAGE
Lloh77:
	add	x0, x0, l_anon.4f085434029274ba718f685435041e60.34@PAGEOFF
Lloh78:
	adrp	x2, l_anon.4f085434029274ba718f685435041e60.35@PAGE
Lloh79:
	add	x2, x2, l_anon.4f085434029274ba718f685435041e60.35@PAGEOFF
	mov	w1, #44
	bl	__RNvNtCs94JkloGYSv0_4core9panicking5panic
LBB23_121:
Ltmp77:
	mov	w0, #8
	mov	w1, #192
	bl	__RNvNtCsdIxNTDZNnoR_5alloc5alloc18handle_alloc_error
Ltmp78:
LBB23_122:
	brk	#0x1
LBB23_123:
	mov	x25, #0
LBB23_124:
	mov	x0, x25
	mov	x1, x21
	bl	__RNvNtCsdIxNTDZNnoR_5alloc7raw_vec12handle_error
LBB23_125:
Ltmp50:
	b	LBB23_127
LBB23_126:
Ltmp79:
LBB23_127:
	mov	x19, x0
	mov	x0, x22
	mov	x1, x21
	b	LBB23_140
LBB23_128:
Ltmp67:
	mov	x19, x0
	mov	x0, x26
	mov	w1, #288
	mov	w2, #8
	bl	__RNvCs9wFQrvczXsK_7___rustc14___rust_dealloc
	b	LBB23_130
LBB23_129:
Ltmp70:
	mov	x19, x0
LBB23_130:
	ldp	x21, x20, [sp, #24]
Ltmp71:
	sub	x0, x29, #89
	bl	__RNvXNvNtNtNtCsdIxNTDZNnoR_5alloc11collections5btree3mem7replaceNtB2_10PanicGuardNtNtNtCs94JkloGYSv0_4core3ops4drop4Drop4drop
Ltmp72:
	b	LBB23_139
LBB23_131:
Ltmp73:
	bl	__RNvNtCs94JkloGYSv0_4core9panicking16panic_in_cleanup
LBB23_132:
Ltmp53:
	mov	x19, x0
Ltmp54:
	add	x0, sp, #72
	bl	__RINvNtCs94JkloGYSv0_4core3ptr9drop_glueINtNtNtNtCsdIxNTDZNnoR_5alloc11collections5btree3map8BTreeMapyjEECs5Av9rWzHob7_3lib
Ltmp55:
	b	LBB23_141
LBB23_133:
Ltmp56:
	bl	__RNvNtCs94JkloGYSv0_4core9panicking16panic_in_cleanup
LBB23_134:
Ltmp82:
	mov	x19, x0
Ltmp83:
	add	x0, sp, #96
	bl	__RINvNtCs94JkloGYSv0_4core3ptr9drop_glueINtNvXsy_NtNtNtCsdIxNTDZNnoR_5alloc11collections5btree3mapINtBK_8IntoIterpppENtNtNtB4_3ops4drop4Drop4drop9DropGuardyjNtNtBQ_5alloc6GlobalEECs5Av9rWzHob7_3lib
Ltmp84:
	b	LBB23_141
LBB23_135:
Ltmp85:
	bl	__RNvNtCs94JkloGYSv0_4core9panicking16panic_in_cleanup
LBB23_136:
Ltmp59:
	mov	x19, x0
Ltmp60:
	sub	x0, x29, #89
	bl	__RNvXNvNtNtNtCsdIxNTDZNnoR_5alloc11collections5btree3mem7replaceNtB2_10PanicGuardNtNtNtCs94JkloGYSv0_4core3ops4drop4Drop4drop
Ltmp61:
	ldp	x21, x20, [sp, #24]
	b	LBB23_139
LBB23_137:
Ltmp62:
	bl	__RNvNtCs94JkloGYSv0_4core9panicking16panic_in_cleanup
LBB23_138:
Ltmp76:
	mov	x19, x0
LBB23_139:
	mov	x0, x21
	mov	x1, x20
LBB23_140:
	mov	w2, #8
	bl	__RNvCs9wFQrvczXsK_7___rustc14___rust_dealloc
LBB23_141:
	mov	x0, x19
	bl	__Unwind_Resume
	.loh AdrpLdr	Lloh32, Lloh33
	.loh AdrpAdd	Lloh36, Lloh37
	.loh AdrpAdd	Lloh34, Lloh35
	.loh AdrpAdd	Lloh44, Lloh45
	.loh AdrpAdd	Lloh42, Lloh43
	.loh AdrpAdd	Lloh40, Lloh41
	.loh AdrpAdd	Lloh38, Lloh39
	.loh AdrpAdd	Lloh48, Lloh49
	.loh AdrpAdd	Lloh46, Lloh47
	.loh AdrpAdd	Lloh52, Lloh53
	.loh AdrpAdd	Lloh50, Lloh51
	.loh AdrpAdd	Lloh56, Lloh57
	.loh AdrpAdd	Lloh54, Lloh55
	.loh AdrpAdd	Lloh60, Lloh61
	.loh AdrpAdd	Lloh58, Lloh59
	.loh AdrpAdd	Lloh64, Lloh65
	.loh AdrpAdd	Lloh62, Lloh63
	.loh AdrpAdd	Lloh68, Lloh69
	.loh AdrpAdd	Lloh66, Lloh67
	.loh AdrpAdd	Lloh72, Lloh73
	.loh AdrpAdd	Lloh70, Lloh71
	.loh AdrpAdd	Lloh74, Lloh75
	.loh AdrpAdd	Lloh78, Lloh79
	.loh AdrpAdd	Lloh76, Lloh77
Lfunc_end7:
	.cfi_endproc

__RNvCs5Av9rWzHob7_3lib13packed_lookup:
Lfunc_begin8:
	.cfi_startproc
	.cfi_personality 155, _rust_eh_personality
	.cfi_lsda 16, Lexception8
	sub	sp, sp, #96
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
	.cfi_remember_state
	mov	w8, #34465
	movk	w8, #1, lsl #16
	cmp	x1, x8
	b.hs	LBB24_62
	mov	x19, x3
	mov	x20, x2
	mov	x21, x1
	cbz	x1, LBB24_23
	mov	x10, #0
	lsl	x9, x21, #3
	ldr	x8, [x0]
LBB24_3:
	cbz	x9, LBB24_24
	ldr	x11, [x0, x10, lsl #3]
	subs	x11, x11, x8
	ccmp	x10, x11, #0, hs
	add	x10, x10, #1
	sub	x9, x9, #8
	b.eq	LBB24_3
	mov	x25, x0
	add	x8, x21, x21, lsl #1
	lsl	x22, x8, #2
	mov	x0, x22
	mov	w1, #4
	bl	__RNvMNtNtCs94JkloGYSv0_4core5alloc6layoutNtB2_6Layout23is_size_alignment_valid
	cbz	w0, LBB24_63
	bl	__RNvCs9wFQrvczXsK_7___rustc35___rust_no_alloc_shim_is_unstable_v2
	mov	w24, #4
	mov	x0, x22
	mov	w1, #4
	bl	__RNvCs9wFQrvczXsK_7___rustc12___rust_alloc
	cbz	x0, LBB24_64
	mov	x23, x0
	cmp	x21, #1
	mov	x9, x25
	mov	x8, #0
	b.eq	LBB24_11
	and	x10, x21, #0x1fffe
	add	x11, x23, #12
	add	x12, x9, #8
LBB24_9:
	ldp	x13, x14, [x12, #-8]
	stur	x13, [x11, #-12]
	stur	w8, [x11, #-4]
	str	x14, [x11]
	add	w13, w8, #1
	str	w13, [x11, #8]
	add	x8, x8, #2
	add	x11, x11, #24
	add	x12, x12, #16
	cmp	x8, x10
	b.ne	LBB24_9
	tbz	w21, #0, LBB24_12
LBB24_11:
	ldr	x9, [x9, x8, lsl #3]
	mov	w10, #12
	madd	x10, x8, x10, x23
	str	x9, [x10]
	str	w8, [x10, #8]
LBB24_12:
	cmp	x21, #1
	b.eq	LBB24_34
	cmp	x21, #21
	b.hs	LBB24_33
	mov	x8, #0
	add	x9, x23, x22
	add	x11, x23, #12
	mov	x12, x23
	b	LBB24_18
LBB24_15:
	mov	x13, x23
LBB24_16:
	str	x11, [x13]
	str	w12, [x13, #8]
LBB24_17:
	add	x11, x10, #12
	add	x8, x8, #12
	mov	x12, x10
	cmp	x11, x9
	b.eq	LBB24_34
LBB24_18:
	mov	x10, x11
	ldur	x11, [x12, #12]
	ldr	x13, [x12]
	cmp	x11, x13
	b.hs	LBB24_17
	ldr	w12, [x12, #20]
	mov	x13, x8
LBB24_20:
	add	x14, x23, x13
	ldr	x15, [x14]
	stur	x15, [x14, #12]
	ldr	w15, [x14, #8]
	str	w15, [x14, #20]
	cbz	x13, LBB24_15
	ldur	x14, [x14, #-12]
	sub	x13, x13, #12
	cmp	x11, x14
	b.lo	LBB24_20
	add	x13, x23, x13
	add	x13, x13, #12
	b	LBB24_16
LBB24_23:
	mov	x8, #0
LBB24_24:
	cbz	x19, LBB24_27
	cmp	x19, #8
	b.hs	LBB24_28
	mov	x9, #0
	mov	x0, #0
	b	LBB24_31
LBB24_27:
	mov	x0, #0
	b	LBB24_56
LBB24_28:
	and	x9, x19, #0xffffffffffffff8
	dup.2d	v0, x8
	dup.2d	v1, x21
	add	x10, x20, #32
	movi.2d	v2, #0000000000000000
	and	x11, x19, #0xffffffffffffff8
	movi.2d	v3, #0000000000000000
	movi.2d	v4, #0000000000000000
	movi.2d	v5, #0000000000000000
LBB24_29:
	ldp	q6, q7, [x10, #-32]
	ldp	q16, q17, [x10], #64
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
	subs	x11, x11, #8
	b.ne	LBB24_29
	eor.16b	v0, v3, v2
	eor3.16b	v0, v4, v0, v5
	ext.16b	v1, v0, v0, #8
	eor.8b	v0, v0, v1
	fmov	x0, d0
	cmp	x19, x9
	b.eq	LBB24_56
LBB24_31:
	sub	x10, x19, x9
	add	x9, x20, x9, lsl #3
LBB24_32:
	ldr	x11, [x9], #8
	subs	x12, x11, x8
	cmp	x12, x21
	csinv	x12, x12, xzr, lo
	cmp	x11, x8
	csinv	x11, x12, xzr, hs
	eor	x0, x11, x0
	subs	x10, x10, #1
	b.ne	LBB24_32
	b	LBB24_56
LBB24_33:
Ltmp86:
	add	x2, sp, #8
	mov	x0, x23
	mov	x1, x21
	bl	__RINvNtNtNtCs94JkloGYSv0_4core5slice4sort8unstable7ipnsortNtNtCs5Av9rWzHob7_3lib10runs_index5EntryNCINvMB6_SBT_20sort_unstable_by_keyyNCINvMs_BV_NtBV_13IdentityIndex8from_idsINtNtNtNtB8_4iter8adapters6copied6CopiedINtNtB6_4iter4IteryEEEs0_0E0EBX_
Ltmp87:
LBB24_34:
	add	x8, x21, #1
	mov	x9, x23
LBB24_35:
	sub	x8, x8, #1
	cmp	x8, #2
	b.lo	LBB24_39
	ldr	x10, [x9]
	ldr	x11, [x9, #12]!
	cmp	x10, x11
	b.ne	LBB24_35
Ltmp88:
Lloh80:
	adrp	x0, l_anon.4f085434029274ba718f685435041e60.5@PAGE
Lloh81:
	add	x0, x0, l_anon.4f085434029274ba718f685435041e60.5@PAGEOFF
Lloh82:
	adrp	x2, l_anon.4f085434029274ba718f685435041e60.10@PAGE
Lloh83:
	add	x2, x2, l_anon.4f085434029274ba718f685435041e60.10@PAGEOFF
	mov	w1, #73
	bl	__RNvNtCs94JkloGYSv0_4core9panicking9panic_fmt
Ltmp89:
	brk	#0x1
LBB24_39:
	cbz	x19, LBB24_46
	cbz	x21, LBB24_47
	cmp	x21, #1
	b.ne	LBB24_49
	mov	x8, #0
	ldr	x9, [x23]
	b	LBB24_44
LBB24_43:
	ldr	w10, [x23, #8]
	eor	x8, x10, x8
	subs	x19, x19, #1
	b.eq	LBB24_55
LBB24_44:
	ldr	x10, [x20], #8
	cmp	x9, x10
	b.eq	LBB24_43
	mov	x10, #-1
	eor	x8, x10, x8
	subs	x19, x19, #1
	b.ne	LBB24_44
	b	LBB24_55
LBB24_46:
	mov	x8, #0
	b	LBB24_55
LBB24_47:
	cmp	x19, #8
	b.hs	LBB24_57
	mov	x8, #0
	mov	x0, #0
	b	LBB24_60
LBB24_49:
	mov	x9, #0
	mov	x8, #0
	mov	w10, #12
	b	LBB24_51
LBB24_50:
	ldr	w11, [x11, #8]
	eor	x8, x11, x8
	add	x9, x9, #1
	cmp	x9, x19
	b.eq	LBB24_55
LBB24_51:
	mov	x11, #0
	ldr	x12, [x20, x9, lsl #3]
	mov	x13, x21
LBB24_52:
	lsr	x14, x13, #1
	add	x15, x14, x11
	mul	x16, x15, x10
	ldr	x16, [x23, x16]
	cmp	x16, x12
	csel	x11, x11, x15, hi
	sub	x13, x13, x14
	cmp	x13, #1
	b.hi	LBB24_52
	madd	x11, x11, x10, x23
	ldr	x13, [x11]
	cmp	x13, x12
	b.eq	LBB24_50
	mov	x11, #-1
	eor	x8, x11, x8
	add	x9, x9, #1
	cmp	x9, x19
	b.ne	LBB24_51
LBB24_55:
	mov	x19, x8
	mov	x0, x23
	mov	x1, x22
	mov	w2, #4
	bl	__RNvCs9wFQrvczXsK_7___rustc14___rust_dealloc
	mov	x0, x19
LBB24_56:
	.cfi_def_cfa wsp, 96
	ldp	x29, x30, [sp, #80]
	ldp	x20, x19, [sp, #64]
	ldp	x22, x21, [sp, #48]
	ldp	x24, x23, [sp, #32]
	ldp	x26, x25, [sp, #16]
	add	sp, sp, #96
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
	ret
LBB24_57:
	.cfi_restore_state
	and	x8, x19, #0xffffffffffffff8
	movi.2d	v0, #0000000000000000
	and	x9, x19, #0xffffffffffffff8
	movi.2d	v3, #0000000000000000
	movi.2d	v1, #0000000000000000
	movi.2d	v2, #0000000000000000
LBB24_58:
	mov.16b	v4, v3
	mov.16b	v5, v0
	mvn.16b	v0, v0
	mvn.16b	v3, v3
	mvn.16b	v1, v1
	mvn.16b	v2, v2
	subs	x9, x9, #8
	b.ne	LBB24_58
	eor.16b	v0, v4, v5
	eor3.16b	v0, v0, v1, v2
	ext.16b	v1, v0, v0, #8
	eor.8b	v0, v0, v1
	fmov	x0, d0
	cmp	x19, x8
	b.eq	LBB24_56
LBB24_60:
	sub	x8, x19, x8
LBB24_61:
	mvn	x0, x0
	subs	x8, x8, #1
	b.ne	LBB24_61
	b	LBB24_56
LBB24_62:
Lloh84:
	adrp	x0, l_anon.4f085434029274ba718f685435041e60.2@PAGE
Lloh85:
	add	x0, x0, l_anon.4f085434029274ba718f685435041e60.2@PAGEOFF
Lloh86:
	adrp	x2, l_anon.4f085434029274ba718f685435041e60.9@PAGE
Lloh87:
	add	x2, x2, l_anon.4f085434029274ba718f685435041e60.9@PAGEOFF
	mov	w1, #63
	bl	__RNvNtCs94JkloGYSv0_4core9panicking9panic_fmt
LBB24_63:
	mov	x24, #0
LBB24_64:
	mov	x0, x24
	mov	x1, x22
	bl	__RNvNtCsdIxNTDZNnoR_5alloc7raw_vec12handle_error
LBB24_65:
Ltmp90:
	mov	x19, x0
	mov	x0, x23
	mov	x1, x22
	mov	w2, #4
	bl	__RNvCs9wFQrvczXsK_7___rustc14___rust_dealloc
	mov	x0, x19
	bl	__Unwind_Resume
	.loh AdrpAdd	Lloh82, Lloh83
	.loh AdrpAdd	Lloh80, Lloh81
	.loh AdrpAdd	Lloh86, Lloh87
	.loh AdrpAdd	Lloh84, Lloh85
Lfunc_end8:
	.cfi_endproc

__RNvCs5Av9rWzHob7_3lib14aligned_lookup:
Lfunc_begin9:
	.cfi_startproc
	.cfi_personality 155, _rust_eh_personality
	.cfi_lsda 16, Lexception9
	sub	sp, sp, #80
	.cfi_def_cfa_offset 80
	stp	x24, x23, [sp, #16]
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
	.cfi_offset w23, -56
	.cfi_offset w24, -64
	.cfi_remember_state
	mov	x21, x3
	mov	x22, x2
	mov	x20, x1
	mov	x23, x0
	lsl	x19, x1, #4
	mov	x0, x19
	mov	w1, #8
	bl	__RNvMNtNtCs94JkloGYSv0_4core5alloc6layoutNtB2_6Layout23is_size_alignment_valid
	cbz	w0, LBB25_48
	cbz	x20, LBB25_5
	bl	__RNvCs9wFQrvczXsK_7___rustc35___rust_no_alloc_shim_is_unstable_v2
	mov	w24, #8
	mov	x0, x19
	mov	w1, #8
	bl	__RNvCs9wFQrvczXsK_7___rustc12___rust_alloc
	cbz	x0, LBB25_49
	and	x8, x20, #0x7
	cmp	x20, #8
	b.hs	LBB25_6
	mov	x9, #0
	b	LBB25_9
LBB25_5:
	mov	w0, #8
	b	LBB25_24
LBB25_6:
	mov	x9, #0
	and	x10, x20, #0xffffffffffffff8
	add	x11, x0, #64
	add	x12, x23, #32
LBB25_7:
	ldp	x13, x14, [x12, #-32]
	stur	x13, [x11, #-64]
	stur	x14, [x11, #-48]
	add	w13, w9, #1
	stur	w13, [x11, #-40]
	ldp	x13, x14, [x12, #-16]
	stur	x13, [x11, #-32]
	add	w13, w9, #2
	stur	w13, [x11, #-24]
	stur	x14, [x11, #-16]
	add	w13, w9, #3
	stur	w13, [x11, #-8]
	ldp	x13, x14, [x12]
	str	x13, [x11]
	add	w13, w9, #4
	str	w13, [x11, #8]
	str	x14, [x11, #16]
	add	w13, w9, #5
	str	w13, [x11, #24]
	ldp	x13, x14, [x12, #16]
	str	x13, [x11, #32]
	add	w13, w9, #6
	str	w13, [x11, #40]
	str	x14, [x11, #48]
	add	w13, w9, #7
	stur	w9, [x11, #-56]
	add	x9, x9, #8
	str	w13, [x11, #56]
	add	x11, x11, #128
	add	x12, x12, #64
	cmp	x9, x10
	b.ne	LBB25_7
	cbz	x8, LBB25_11
LBB25_9:
	add	x10, x0, x9, lsl #4
	add	x10, x10, #8
LBB25_10:
	ldr	x11, [x23, x9, lsl #3]
	stur	x11, [x10, #-8]
	str	w9, [x10], #16
	add	x9, x9, #1
	subs	x8, x8, #1
	b.ne	LBB25_10
LBB25_11:
	cmp	x20, #1
	b.eq	LBB25_24
	cmp	x20, #21
	b.hs	LBB25_22
	mov	x8, #0
	add	x9, x0, x19
	add	x11, x0, #16
	mov	x12, x0
	b	LBB25_17
LBB25_14:
	mov	x13, x0
LBB25_15:
	str	x11, [x13]
	str	w12, [x13, #8]
LBB25_16:
	add	x11, x10, #16
	add	x8, x8, #16
	mov	x12, x10
	cmp	x11, x9
	b.eq	LBB25_24
LBB25_17:
	mov	x10, x11
	ldr	x11, [x12, #16]
	ldr	x13, [x12]
	cmp	x11, x13
	b.hs	LBB25_16
	ldr	w12, [x12, #24]
	mov	x13, x8
LBB25_19:
	add	x14, x0, x13
	ldr	q0, [x14]
	str	q0, [x14, #16]
	cbz	x13, LBB25_14
	ldur	x14, [x14, #-16]
	sub	x13, x13, #16
	cmp	x11, x14
	b.lo	LBB25_19
	add	x13, x0, x13
	add	x13, x13, #16
	b	LBB25_15
LBB25_22:
Ltmp91:
	add	x2, sp, #8
	mov	x23, x0
	mov	x1, x20
	bl	__RINvNtNtNtCs94JkloGYSv0_4core5slice4sort8unstable7ipnsortNtCs5Av9rWzHob7_3lib12AlignedEntryNCINvMB6_SBT_20sort_unstable_by_keyyNCNvBV_14aligned_lookups_0E0EBV_
Ltmp92:
	mov	x0, x23
LBB25_24:
	cbz	x21, LBB25_31
	cbz	x20, LBB25_32
	cmp	x20, #1
	b.ne	LBB25_34
	mov	x23, #0
	ldr	x8, [x0]
	b	LBB25_29
LBB25_28:
	ldr	w9, [x0, #8]
	eor	x23, x9, x23
	subs	x21, x21, #1
	b.eq	LBB25_45
LBB25_29:
	ldr	x9, [x22], #8
	cmp	x8, x9
	b.eq	LBB25_28
	mov	x9, #-1
	eor	x23, x9, x23
	subs	x21, x21, #1
	b.ne	LBB25_29
	b	LBB25_45
LBB25_31:
	mov	x23, #0
	b	LBB25_45
LBB25_32:
	cmp	x21, #8
	b.hs	LBB25_40
	mov	x8, #0
	mov	x23, #0
	b	LBB25_43
LBB25_34:
	mov	x8, #0
	mov	x23, #0
	b	LBB25_36
LBB25_35:
	ldr	w9, [x9, #8]
	eor	x23, x9, x23
	add	x8, x8, #1
	cmp	x8, x21
	b.eq	LBB25_45
LBB25_36:
	mov	x9, #0
	ldr	x10, [x22, x8, lsl #3]
	mov	x11, x20
LBB25_37:
	lsr	x12, x11, #1
	add	x13, x12, x9
	lsl	x14, x13, #4
	ldr	x14, [x0, x14]
	cmp	x14, x10
	csel	x9, x9, x13, hi
	sub	x11, x11, x12
	cmp	x11, #1
	b.hi	LBB25_37
	add	x9, x0, x9, lsl #4
	ldr	x11, [x9]
	cmp	x11, x10
	b.eq	LBB25_35
	mov	x9, #-1
	eor	x23, x9, x23
	add	x8, x8, #1
	cmp	x8, x21
	b.ne	LBB25_36
	b	LBB25_45
LBB25_40:
	and	x8, x21, #0xffffffffffffff8
	movi.2d	v0, #0000000000000000
	and	x9, x21, #0xffffffffffffff8
	movi.2d	v3, #0000000000000000
	movi.2d	v1, #0000000000000000
	movi.2d	v2, #0000000000000000
LBB25_41:
	mov.16b	v4, v3
	mov.16b	v5, v0
	mvn.16b	v0, v0
	mvn.16b	v3, v3
	mvn.16b	v1, v1
	mvn.16b	v2, v2
	subs	x9, x9, #8
	b.ne	LBB25_41
	eor.16b	v0, v4, v5
	eor3.16b	v0, v0, v1, v2
	ext.16b	v1, v0, v0, #8
	eor.8b	v0, v0, v1
	fmov	x23, d0
	cmp	x21, x8
	b.eq	LBB25_45
LBB25_43:
	sub	x8, x21, x8
LBB25_44:
	mvn	x23, x23
	subs	x8, x8, #1
	b.ne	LBB25_44
LBB25_45:
	cbz	x20, LBB25_47
	mov	x1, x19
	mov	w2, #8
	bl	__RNvCs9wFQrvczXsK_7___rustc14___rust_dealloc
LBB25_47:
	mov	x0, x23
	.cfi_def_cfa wsp, 80
	ldp	x29, x30, [sp, #64]
	ldp	x20, x19, [sp, #48]
	ldp	x22, x21, [sp, #32]
	ldp	x24, x23, [sp, #16]
	add	sp, sp, #80
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
LBB25_48:
	.cfi_restore_state
	mov	x24, #0
LBB25_49:
	mov	x0, x24
	mov	x1, x19
	bl	__RNvNtCsdIxNTDZNnoR_5alloc7raw_vec12handle_error
LBB25_50:
Ltmp93:
	mov	x20, x0
	mov	x0, x23
	mov	x1, x19
	mov	w2, #8
	bl	__RNvCs9wFQrvczXsK_7___rustc14___rust_dealloc
	mov	x0, x20
	bl	__Unwind_Resume
Lfunc_end9:
	.cfi_endproc
