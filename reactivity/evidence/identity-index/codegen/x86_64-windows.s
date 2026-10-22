_RNvCs5Av9rWzHob7_3lib11runs_lookup:
.Lfunc_begin6:
.seh_proc _RNvCs5Av9rWzHob7_3lib11runs_lookup
	.seh_handler __CxxFrameHandler3, @unwind, @except
	pushq	%rbp
	.seh_pushreg %rbp
	pushq	%r15
	.seh_pushreg %r15
	pushq	%r14
	.seh_pushreg %r14
	pushq	%r13
	.seh_pushreg %r13
	pushq	%r12
	.seh_pushreg %r12
	pushq	%rsi
	.seh_pushreg %rsi
	pushq	%rdi
	.seh_pushreg %rdi
	pushq	%rbx
	.seh_pushreg %rbx
	subq	$104, %rsp
	.seh_stackalloc 104
	leaq	96(%rsp), %rbp
	.seh_setframe %rbp, 96
	.seh_endprologue
	movq	$-2, (%rbp)
	cmpq	$100001, %rdx
	jae	.LBB22_184
	movq	%r9, %rsi
	movq	%r8, %rdi
	movq	%rdx, %r15
	testq	%rdx, %rdx
	je	.LBB22_2
	movq	(%rcx), %r13
	cmpq	$1, %r15
	jne	.LBB22_5
	movl	$1, %r15d
	xorl	%ecx, %ecx
	testq	%rsi, %rsi
	jne	.LBB22_110
	jmp	.LBB22_109
.LBB22_2:
	xorl	%ecx, %ecx
	xorl	%r13d, %r13d
	xorl	%r15d, %r15d
	testq	%rsi, %rsi
	jne	.LBB22_110
	jmp	.LBB22_109
.LBB22_5:
	leaq	(%rcx,%r15,8), %r12
	movq	8(%rcx), %rdx
	movq	%r13, %rbx
	incq	%r13
	sete	%r8b
	cmpq	%rdx, %r13
	setne	%al
	orb	%r8b, %al
	movzbl	%al, %r13d
	incq	%r13
	cmpq	$2, %r15
	je	.LBB22_11
	leaq	(,%r15,8), %r8
	addq	$-24, %r8
	testb	$8, %r8b
	jne	.LBB22_7
	movq	16(%rcx), %r9
	leaq	24(%rcx), %rax
	incq	%rdx
	sete	%r10b
	cmpq	%r9, %rdx
	setne	%dl
	orb	%r10b, %dl
	movzbl	%dl, %edx
	addq	%rdx, %r13
	movq	%r9, %rdx
	testq	%r8, %r8
	jne	.LBB22_10
	jmp	.LBB22_11
.LBB22_7:
	leaq	16(%rcx), %rax
	testq	%r8, %r8
	je	.LBB22_11
	.p2align	4
.LBB22_10:
	incq	%rdx
	sete	%r8b
	movq	(%rax), %r9
	cmpq	%r9, %rdx
	movq	8(%rax), %rdx
	setne	%r10b
	orb	%r8b, %r10b
	movzbl	%r10b, %r8d
	addq	%r13, %r8
	incq	%r9
	sete	%r10b
	cmpq	%rdx, %r9
	setne	%r9b
	orb	%r10b, %r9b
	movzbl	%r9b, %r13d
	addq	%r8, %r13
	addq	$16, %rax
	cmpq	%r12, %rax
	jne	.LBB22_10
.LBB22_11:
	cmpq	$1, %r13
	jne	.LBB22_13
	xorl	%ecx, %ecx
	movq	%rbx, %r13
	testq	%rsi, %rsi
	jne	.LBB22_110
	jmp	.LBB22_109
.LBB22_13:
	movq	%r13, %r14
	shlq	$4, %r14
	leaq	(,%r15,4), %rax
	leaq	(%rax,%rax,2), %rax
	cmpq	%rax, %r14
	jae	.LBB22_14
	movq	%rcx, -16(%rbp)
	movq	%r13, %rax
	shrq	$60, %rax
	jne	.LBB22_42
	movl	$8, %edx
	movq	%r14, %rcx
	callq	_RNvMNtNtCs998Ihx2sztz_4core5alloc6layoutNtB2_6Layout23is_size_alignment_valid
	testb	%al, %al
	je	.LBB22_44
	testq	%r13, %r13
	movl	$8, %eax
	je	.LBB22_49
	callq	_RNvCs9wFQrvczXsK_7___rustc35___rust_no_alloc_shim_is_unstable_v2
	movl	$8, %r15d
	movl	$8, %edx
	movq	%r14, %rcx
	callq	_RNvCs9wFQrvczXsK_7___rustc12___rust_alloc
	testq	%rax, %rax
	je	.LBB22_47
.LBB22_49:
	movq	%r13, -56(%rbp)
	movq	%rax, -48(%rbp)
	xorl	%r8d, %r8d
	movl	$1, %ecx
	xorl	%edx, %edx
	xorl	%r10d, %r10d
	movq	-16(%rbp), %r9
	jmp	.LBB22_50
.LBB22_68:
	movq	-48(%rbp), %rax
	movq	%rbx, %r9
	movl	-32(%rbp), %r11d
.LBB22_69:
	movq	-16(%rbp), %r8
	movq	%r8, %rcx
	shlq	$4, %rcx
	movq	%r15, (%rax,%rcx)
	movl	%r10d, 8(%rax,%rcx)
	movl	%r13d, 12(%rax,%rcx)
	incq	%r8
	movb	$1, %dl
	xorl	%ecx, %ecx
	movl	%r11d, %r10d
	movq	%r14, %rbx
.LBB22_50:
	movq	%r8, -40(%rbp)
	testb	$1, %dl
	movq	%rbx, %r15
	je	.LBB22_51
	cmpq	%r12, %r9
	jne	.LBB22_53
	jmp	.LBB22_56
.LBB22_51:
	movq	%r12, %rdx
	subq	%r9, %rdx
	shrq	$3, %rdx
	cmpq	%rdx, %rcx
	jae	.LBB22_56
	leaq	(%r9,%rcx,8), %r9
.LBB22_53:
	movq	(%r9), %r14
	addq	$8, %r9
	movq	%rbx, %rcx
	incq	%rcx
	sete	%dl
	cmpq	%r14, %rcx
	setne	%cl
	orb	%dl, %cl
	jne	.LBB22_54
	movl	$2, %r13d
	cmpq	%r12, %r9
	je	.LBB22_57
	.p2align	4
.LBB22_63:
	movq	(%r9), %r14
	movl	%r13d, %ecx
	addq	%r15, %rcx
	cmpq	%r15, %rcx
	jb	.LBB22_65
	cmpq	%r14, %rcx
	jne	.LBB22_65
	addq	$8, %r9
	incl	%r13d
	cmpq	%r12, %r9
	jne	.LBB22_63
	jmp	.LBB22_57
.LBB22_54:
	movq	%r8, -16(%rbp)
	leal	1(%r10), %r11d
	movl	$1, %r13d
	movq	-16(%rbp), %rcx
	cmpq	-56(%rbp), %rcx
	jne	.LBB22_69
	jmp	.LBB22_67
.LBB22_65:
	movq	%r8, -16(%rbp)
	addq	$8, %r9
	leal	(%r10,%r13), %r11d
	movq	-16(%rbp), %rcx
	cmpq	-56(%rbp), %rcx
	jne	.LBB22_69
.LBB22_67:
	movl	%r11d, -32(%rbp)
	movq	%r9, %rbx
	movb	$1, -1(%rbp)
.Ltmp20:
	leaq	-56(%rbp), %rcx
	movq	%r10, -24(%rbp)
	callq	_RNvMs3_NtCsk3xoiB9w6DV_5alloc7raw_vecINtB5_6RawVecNtNtCs5Av9rWzHob7_3lib10runs_index3RunE8grow_oneBQ_
	movq	-24(%rbp), %r10
.Ltmp21:
	jmp	.LBB22_68
.LBB22_14:
	movq	%rcx, %r14
	movl	$4, %ebx
	movl	$4, %edx
	movq	%rax, %rcx
	movq	%rax, %r12
	callq	_RNvMNtNtCs998Ihx2sztz_4core5alloc6layoutNtB2_6Layout23is_size_alignment_valid
	testb	%al, %al
	movq	%r12, -24(%rbp)
	je	.LBB22_15
	callq	_RNvCs9wFQrvczXsK_7___rustc35___rust_no_alloc_shim_is_unstable_v2
	movl	$4, %edx
	movq	%r12, %rcx
	callq	_RNvCs9wFQrvczXsK_7___rustc12___rust_alloc
	testq	%rax, %rax
	je	.LBB22_16
	movl	%r15d, %edx
	andl	$3, %edx
	cmpq	$4, %r15
	jae	.LBB22_20
	xorl	%ecx, %ecx
	jmp	.LBB22_23
.LBB22_20:
	movl	%r15d, %r8d
	andl	$131068, %r8d
	leaq	44(%rax), %r9
	xorl	%ecx, %ecx
	.p2align	4
.LBB22_21:
	movq	(%r14,%rcx,8), %r10
	movq	%r10, -44(%r9)
	movl	%ecx, -36(%r9)
	movq	8(%r14,%rcx,8), %r10
	movq	%r10, -32(%r9)
	leal	1(%rcx), %r10d
	movl	%r10d, -24(%r9)
	movq	16(%r14,%rcx,8), %r10
	movq	%r10, -20(%r9)
	leal	2(%rcx), %r10d
	movl	%r10d, -12(%r9)
	movq	24(%r14,%rcx,8), %r10
	movq	%r10, -8(%r9)
	leal	3(%rcx), %r10d
	movl	%r10d, (%r9)
	addq	$4, %rcx
	addq	$48, %r9
	cmpq	%r8, %rcx
	jne	.LBB22_21
	testq	%rdx, %rdx
	je	.LBB22_25
.LBB22_23:
	leaq	(%rcx,%rcx,2), %r8
	leaq	(%rax,%r8,4), %r8
	addq	$8, %r8
	shll	$2, %edx
	leaq	(%rdx,%rdx,2), %rdx
	xorl	%r9d, %r9d
	.p2align	4
.LBB22_24:
	movq	(%r14,%rcx,8), %r10
	movq	%r10, -8(%r8,%r9)
	movl	%ecx, (%r8,%r9)
	incq	%rcx
	addq	$12, %r9
	cmpq	%r9, %rdx
	jne	.LBB22_24
.LBB22_25:
	cmpq	$21, %r15
	movq	%rax, -16(%rbp)
	jae	.LBB22_26
	movq	%r15, %rbx
	movq	-24(%rbp), %rcx
	leaq	(%rax,%rcx), %r14
	leaq	12(%rax), %r8
	movl	$12, %ecx
	movq	%rax, %r9
	movq	-16(%rbp), %rax
	jmp	.LBB22_33
	.p2align	4
.LBB22_36:
	movq	%rax, %r11
.LBB22_39:
	movq	%r8, (%r11)
	movl	%r9d, 8(%r11)
.LBB22_40:
	leaq	12(%rdx), %r8
	addq	$12, %rcx
	movq	%rdx, %r9
	cmpq	%r14, %r8
	je	.LBB22_27
.LBB22_33:
	movq	%r8, %rdx
	movq	12(%r9), %r8
	cmpq	(%r9), %r8
	jae	.LBB22_40
	movl	20(%r9), %r9d
	movq	%rcx, %r10
	.p2align	4
.LBB22_35:
	movl	-4(%rax,%r10), %r11d
	movl	%r11d, 8(%rax,%r10)
	movq	-12(%rax,%r10), %r11
	movq	%r11, (%rax,%r10)
	cmpq	$12, %r10
	je	.LBB22_36
	leaq	-12(%r10), %r11
	cmpq	-24(%rax,%r10), %r8
	movq	%r11, %r10
	jb	.LBB22_35
	addq	%rax, %r11
	jmp	.LBB22_39
.LBB22_26:
.Ltmp16:
	leaq	-56(%rbp), %r8
	movq	%rax, %rcx
	movq	%r15, %rbx
	movq	%r15, %rdx
	callq	_RINvNtNtNtCs998Ihx2sztz_4core5slice4sort8unstable7ipnsortNtNtCs5Av9rWzHob7_3lib10runs_index5EntryNCINvMB6_SBT_20sort_unstable_by_keyyNCINvMs_BV_NtBV_13IdentityIndex8from_idsINtNtNtNtB8_4iter8adapters6copied6CopiedINtNtB6_4iter4IteryEEEs0_0E0EBX_
	nop
.Ltmp17:
.LBB22_27:
	movq	%rbx, %r15
	leaq	1(%rbx), %rax
	movq	-16(%rbp), %r13
	movq	%r13, %rcx
	.p2align	4
.LBB22_28:
	decq	%rax
	cmpq	$2, %rax
	jb	.LBB22_107
	movq	(%rcx), %rdx
	cmpq	12(%rcx), %rdx
	leaq	12(%rcx), %rcx
	jne	.LBB22_28
.Ltmp18:
	leaq	anon.e304f8fa8dec0a10ab5ae879c02fc903.5(%rip), %rcx
	leaq	anon.e304f8fa8dec0a10ab5ae879c02fc903.6(%rip), %r8
	movl	$73, %edx
	callq	_RNvNtCs998Ihx2sztz_4core9panicking9panic_fmt
	nop
.Ltmp19:
	jmp	.LBB22_31
.LBB22_107:
	movl	$2, %ecx
	testq	%rsi, %rsi
	jne	.LBB22_110
	jmp	.LBB22_109
.LBB22_56:
	movl	$1, %r13d
.LBB22_57:
	movq	%r8, %rbx
	cmpq	-56(%rbp), %r8
	jne	.LBB22_59
	movb	$1, -1(%rbp)
.Ltmp22:
	leaq	-56(%rbp), %rcx
	movq	%r10, %r14
	callq	_RNvMs3_NtCsk3xoiB9w6DV_5alloc7raw_vecINtB5_6RawVecNtNtCs5Av9rWzHob7_3lib10runs_index3RunE8grow_oneBQ_
	movq	%r14, %r10
.Ltmp23:
.LBB22_59:
	movq	-48(%rbp), %r14
	movq	%rbx, %rdx
	movq	%rbx, %rax
	shlq	$4, %rax
	movq	%r15, (%r14,%rax)
	movl	%r10d, 8(%r14,%rax)
	movl	%r13d, 12(%r14,%rax)
	incq	%rdx
	movq	%rdx, -40(%rbp)
	cmpq	$2, %rdx
	jae	.LBB22_70
	movq	%rdx, -16(%rbp)
	jmp	.LBB22_82
.LBB22_70:
	cmpq	$21, %rdx
	jae	.LBB22_71
	shlq	$4, %rdx
	addq	%r14, %rdx
	leaq	16(%r14), %r9
	movl	$16, %eax
	movq	%r14, %r8
	jmp	.LBB22_73
.LBB22_76:
	movq	%r14, %r9
.LBB22_79:
	movq	%r11, (%r9)
	movq	%r8, 8(%r9)
.LBB22_80:
	leaq	16(%rcx), %r9
	addq	$16, %rax
	movq	%rcx, %r8
	cmpq	%rdx, %r9
	je	.LBB22_81
.LBB22_73:
	movq	%r9, %rcx
	movq	16(%r8), %r11
	cmpq	(%r8), %r11
	jae	.LBB22_80
	movq	24(%r8), %r8
	movq	%rax, %r10
	.p2align	4
.LBB22_75:
	movdqu	-16(%r14,%r10), %xmm0
	movdqu	%xmm0, (%r14,%r10)
	cmpq	$16, %r10
	je	.LBB22_76
	leaq	-16(%r10), %r9
	cmpq	-32(%r14,%r10), %r11
	movq	%r9, %r10
	jb	.LBB22_75
	addq	%r14, %r9
	jmp	.LBB22_79
.LBB22_71:
	movb	$1, -1(%rbp)
.Ltmp24:
	leaq	-64(%rbp), %r8
	movq	%r14, %rcx
	movq	%rdx, -16(%rbp)
	callq	_RINvNtNtNtCs998Ihx2sztz_4core5slice4sort8unstable7ipnsortNtNtCs5Av9rWzHob7_3lib10runs_index3RunNCINvMB6_SBT_20sort_unstable_by_keyyNCINvMs_BV_NtBV_13IdentityIndex8from_idsINtNtNtNtB8_4iter8adapters6copied6CopiedINtNtB6_4iter4IteryEEE0E0EBX_
	nop
.Ltmp25:
	jmp	.LBB22_82
.LBB22_81:
	movq	-48(%rbp), %r14
	movq	-40(%rbp), %rax
	movq	%rax, -16(%rbp)
.LBB22_82:
	leaq	16(%r14), %rax
	movq	-16(%rbp), %r15
	leaq	1(%r15), %rcx
	.p2align	4
.LBB22_83:
	decq	%rcx
	cmpq	$2, %rcx
	jb	.LBB22_87
	movq	(%rax), %rdx
	subq	-16(%rax), %rdx
	jb	.LBB22_86
	movl	-4(%rax), %r8d
	addq	$16, %rax
	cmpq	%r8, %rdx
	jae	.LBB22_83
.LBB22_86:
	movb	$1, -1(%rbp)
.Ltmp26:
	leaq	anon.e304f8fa8dec0a10ab5ae879c02fc903.5(%rip), %rcx
	leaq	anon.e304f8fa8dec0a10ab5ae879c02fc903.7(%rip), %r8
	movl	$73, %edx
	callq	_RNvNtCs998Ihx2sztz_4core9panicking9panic_fmt
	nop
.Ltmp27:
	jmp	.LBB22_31
.LBB22_87:
	movq	-56(%rbp), %r12
	cmpq	%r15, %r12
	jbe	.LBB22_91
	movq	%r12, %rdx
	shlq	$4, %rdx
	testq	%r15, %r15
	je	.LBB22_100
	movq	%r15, %rbx
	shlq	$4, %rbx
	movl	$8, %r8d
	movq	%r14, %rcx
	movq	%rbx, %r9
	callq	_RNvCs9wFQrvczXsK_7___rustc14___rust_realloc
	movq	%rax, %r13
	testq	%rax, %rax
	jne	.LBB22_101
.Ltmp30:
	movq	%r12, -24(%rbp)
	movq	%r14, -32(%rbp)
	movl	$8, %ecx
	movq	%rbx, %rdx
	callq	_RNvNtCsk3xoiB9w6DV_5alloc7raw_vec12handle_error
	nop
.Ltmp31:
	jmp	.LBB22_31
.LBB22_91:
	jb	.LBB22_93
	movq	%r14, %r13
	movl	$1, %ecx
	testq	%rsi, %rsi
	jne	.LBB22_110
.LBB22_109:
	xorl	%eax, %eax
.LBB22_176:
	testq	%rcx, %rcx
	je	.LBB22_183
	cmpl	$1, %ecx
	jne	.LBB22_178
	testq	%r15, %r15
	je	.LBB22_183
	shlq	$4, %r15
	movl	$8, %r8d
	movq	%r13, %rcx
	movq	%r15, %rdx
	jmp	.LBB22_182
.LBB22_178:
	testq	%r15, %r15
	je	.LBB22_183
	shlq	$2, %r15
	leaq	(%r15,%r15,2), %rdx
	movl	$4, %r8d
	movq	%r13, %rcx
.LBB22_182:
	movq	%rax, %rsi
	callq	_RNvCs9wFQrvczXsK_7___rustc14___rust_dealloc
	movq	%rsi, %rax
	jmp	.LBB22_183
.LBB22_100:
	movl	$8, %r13d
	movl	$8, %r8d
	movq	%r14, %rcx
	callq	_RNvCs9wFQrvczXsK_7___rustc14___rust_dealloc
.LBB22_101:
	movl	$1, %ecx
	testq	%rsi, %rsi
	je	.LBB22_109
.LBB22_110:
	cmpl	$2, %ecx
	je	.LBB22_149
	cmpl	$1, %ecx
	jne	.LBB22_112
	testq	%r15, %r15
	je	.LBB22_127
	cmpq	$1, %r15
	jne	.LBB22_120
	movq	(%r13), %rdx
	cmpq	$1, %rsi
	jne	.LBB22_136
	xorl	%r8d, %r8d
	xorl	%eax, %eax
	jmp	.LBB22_145
.LBB22_149:
	testq	%r15, %r15
	je	.LBB22_157
	cmpq	$1, %r15
	jne	.LBB22_151
	movq	(%r13), %rdx
	cmpq	$1, %rsi
	jne	.LBB22_166
	xorl	%r8d, %r8d
	xorl	%eax, %eax
	jmp	.LBB22_173
.LBB22_112:
	movl	%esi, %eax
	subl	%ecx, %eax
	leaq	1(%rcx), %r8
	testb	$1, %al
	jne	.LBB22_114
	movq	%rcx, %rdx
	cmpq	%r8, %rsi
	jne	.LBB22_116
	jmp	.LBB22_183
.LBB22_114:
	movq	(%rdi,%rcx,8), %rdx
	movq	%rdx, %rax
	subq	%r13, %rax
	cmpq	%r15, %rax
	movq	$-1, %r9
	cmovaeq	%r9, %rax
	cmpq	%r13, %rdx
	cmovbq	%r9, %rax
	xorq	%rcx, %rax
	movq	%r8, %rcx
	movq	%rax, %rdx
	cmpq	%r8, %rsi
	je	.LBB22_183
.LBB22_116:
	movq	$-1, %r8
	.p2align	4
.LBB22_117:
	movq	(%rdi,%rcx,8), %r9
	movq	8(%rdi,%rcx,8), %rax
	movq	%rax, %r10
	subq	%r13, %r10
	cmpq	%r15, %r10
	cmovaeq	%r8, %r10
	cmpq	%r13, %rax
	cmovbq	%r8, %r10
	movq	%r9, %rax
	subq	%r13, %rax
	cmpq	%r15, %rax
	cmovaeq	%r8, %rax
	cmpq	%r13, %r9
	cmovbq	%r8, %rax
	xorq	%rdx, %rax
	xorq	%r10, %rax
	addq	$2, %rcx
	movq	%rax, %rdx
	cmpq	%rcx, %rsi
	jne	.LBB22_117
	jmp	.LBB22_183
.LBB22_127:
	cmpq	$4, %rsi
	jae	.LBB22_129
	xorl	%ecx, %ecx
	xorl	%eax, %eax
	jmp	.LBB22_132
.LBB22_157:
	cmpq	$4, %rsi
	jae	.LBB22_159
	xorl	%ecx, %ecx
	xorl	%eax, %eax
	jmp	.LBB22_162
.LBB22_120:
	xorl	%eax, %eax
	xorl	%edx, %edx
	jmp	.LBB22_121
	.p2align	4
.LBB22_126:
	xorq	%r11, %rax
	incq	%rdx
	cmpq	%rsi, %rdx
	je	.LBB22_176
.LBB22_121:
	movq	(%rdi,%rdx,8), %r8
	movq	%r15, %r10
	xorl	%r9d, %r9d
	.p2align	4
.LBB22_122:
	movq	%r9, %r11
	movq	%r10, %rbx
	shrq	%rbx
	addq	%rbx, %r9
	movq	%r9, %r14
	shlq	$4, %r14
	cmpq	%r8, (%r13,%r14)
	cmovaq	%r11, %r9
	subq	%rbx, %r10
	cmpq	$1, %r10
	ja	.LBB22_122
	movq	%r9, %r11
	shlq	$4, %r11
	xorl	%r10d, %r10d
	cmpq	%r8, (%r13,%r11)
	setbe	%r10b
	movq	$-1, %r11
	addq	%r9, %r10
	je	.LBB22_126
	shlq	$4, %r10
	subq	-16(%r13,%r10), %r8
	movl	-4(%r13,%r10), %r9d
	cmpq	%r9, %r8
	jae	.LBB22_126
	addq	%r13, %r10
	movl	-8(%r10), %r9d
	addq	%r9, %r8
	movq	%r8, %r11
	jmp	.LBB22_126
.LBB22_151:
	xorl	%eax, %eax
	xorl	%edx, %edx
	jmp	.LBB22_152
	.p2align	4
.LBB22_156:
	xorq	%r9, %rax
	incq	%rdx
	cmpq	%rsi, %rdx
	je	.LBB22_176
.LBB22_152:
	movq	(%rdi,%rdx,8), %r8
	movq	%r15, %r9
	xorl	%r10d, %r10d
	.p2align	4
.LBB22_153:
	movq	%r10, %r11
	movq	%r9, %rbx
	shrq	%rbx
	addq	%rbx, %r10
	leaq	(%r10,%r10,2), %r14
	cmpq	%r8, (%r13,%r14,4)
	cmovaq	%r11, %r10
	subq	%rbx, %r9
	cmpq	$1, %r9
	ja	.LBB22_153
	leaq	(%r10,%r10,2), %r10
	movq	$-1, %r9
	cmpq	%r8, (%r13,%r10,4)
	jne	.LBB22_156
	leaq	(,%r10,4), %r8
	addq	%r13, %r8
	movl	8(%r8), %r9d
	jmp	.LBB22_156
.LBB22_136:
	movabsq	$1152921504606846974, %r9
	andq	%rsi, %r9
	xorl	%r8d, %r8d
	xorl	%eax, %eax
	jmp	.LBB22_137
	.p2align	4
.LBB22_143:
	xorq	%r11, %rax
	xorq	%r10, %rax
	addq	$2, %r8
	cmpq	%r8, %r9
	je	.LBB22_144
.LBB22_137:
	movq	(%rdi,%r8,8), %rbx
	movq	$-1, %r10
	movq	$-1, %r11
	subq	%rdx, %rbx
	jb	.LBB22_140
	movl	12(%r13), %r14d
	cmpq	%r14, %rbx
	jae	.LBB22_140
	movl	8(%r13), %r11d
	addq	%r11, %rbx
	movq	%rbx, %r11
.LBB22_140:
	movq	8(%rdi,%r8,8), %rbx
	subq	%rdx, %rbx
	jb	.LBB22_143
	movl	12(%r13), %r14d
	cmpq	%r14, %rbx
	jae	.LBB22_143
	movl	8(%r13), %r10d
	addq	%r10, %rbx
	movq	%rbx, %r10
	jmp	.LBB22_143
.LBB22_144:
	testb	$1, %sil
	je	.LBB22_176
.LBB22_145:
	movq	(%rdi,%r8,8), %r9
	movq	$-1, %r8
	subq	%rdx, %r9
	jb	.LBB22_148
	movl	12(%r13), %edx
	cmpq	%rdx, %r9
	jae	.LBB22_148
	movl	8(%r13), %edx
	addq	%rdx, %r9
	movq	%r9, %r8
.LBB22_148:
	xorq	%r8, %rax
	jmp	.LBB22_176
.LBB22_166:
	movabsq	$1152921504606846974, %r9
	andq	%rsi, %r9
	xorl	%r8d, %r8d
	xorl	%eax, %eax
	jmp	.LBB22_167
	.p2align	4
.LBB22_171:
	xorq	%r11, %rax
	xorq	%r10, %rax
	addq	$2, %r8
	cmpq	%r8, %r9
	je	.LBB22_172
.LBB22_167:
	movq	$-1, %r10
	movq	$-1, %r11
	cmpq	(%rdi,%r8,8), %rdx
	jne	.LBB22_169
	movl	8(%r13), %r11d
.LBB22_169:
	cmpq	8(%rdi,%r8,8), %rdx
	jne	.LBB22_171
	movl	8(%r13), %r10d
	jmp	.LBB22_171
.LBB22_129:
	movabsq	$1152921504606846972, %rcx
	andq	%rsi, %rcx
	pxor	%xmm0, %xmm0
	pcmpeqd	%xmm2, %xmm2
	movq	%rcx, %rax
	pxor	%xmm3, %xmm3
	.p2align	4
.LBB22_130:
	movdqa	%xmm3, %xmm1
	movdqa	%xmm0, %xmm4
	pxor	%xmm2, %xmm0
	pxor	%xmm2, %xmm3
	addq	$-4, %rax
	jne	.LBB22_130
	pxor	%xmm4, %xmm1
	pshufd	$238, %xmm1, %xmm0
	pxor	%xmm1, %xmm0
	movq	%xmm0, %rax
	cmpq	%rcx, %rsi
	je	.LBB22_183
.LBB22_132:
	subq	%rcx, %rsi
	.p2align	4
.LBB22_133:
	notq	%rax
	decq	%rsi
	jne	.LBB22_133
	jmp	.LBB22_183
.LBB22_172:
	testb	$1, %sil
	je	.LBB22_176
.LBB22_173:
	movq	$-1, %r9
	cmpq	(%rdi,%r8,8), %rdx
	jne	.LBB22_175
	movl	8(%r13), %r9d
.LBB22_175:
	xorq	%r9, %rax
	jmp	.LBB22_176
.LBB22_159:
	movabsq	$1152921504606846972, %rcx
	andq	%rsi, %rcx
	pxor	%xmm0, %xmm0
	pcmpeqd	%xmm2, %xmm2
	movq	%rcx, %rax
	pxor	%xmm3, %xmm3
	.p2align	4
.LBB22_160:
	movdqa	%xmm3, %xmm1
	movdqa	%xmm0, %xmm4
	pxor	%xmm2, %xmm0
	pxor	%xmm2, %xmm3
	addq	$-4, %rax
	jne	.LBB22_160
	pxor	%xmm4, %xmm1
	pshufd	$238, %xmm1, %xmm0
	pxor	%xmm1, %xmm0
	movq	%xmm0, %rax
	cmpq	%rcx, %rsi
	je	.LBB22_183
.LBB22_162:
	subq	%rcx, %rsi
	.p2align	4
.LBB22_163:
	notq	%rax
	decq	%rsi
	jne	.LBB22_163
.LBB22_183:
	.seh_startepilogue
	addq	$104, %rsp
	popq	%rbx
	popq	%rdi
	popq	%rsi
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.seh_endepilogue
	retq
.LBB22_184:
	leaq	anon.e304f8fa8dec0a10ab5ae879c02fc903.2(%rip), %rcx
	leaq	anon.e304f8fa8dec0a10ab5ae879c02fc903.4(%rip), %r8
	movl	$63, %edx
	callq	_RNvNtCs998Ihx2sztz_4core9panicking9panic_fmt
	ud2
.LBB22_42:
	xorl	%r15d, %r15d
	movq	%r15, %rcx
	movq	%r14, %rdx
	callq	_RNvNtCsk3xoiB9w6DV_5alloc7raw_vec12handle_error
	ud2
.LBB22_15:
	xorl	%ebx, %ebx
.LBB22_16:
	movq	%rbx, %rcx
	movq	-24(%rbp), %rdx
	callq	_RNvNtCsk3xoiB9w6DV_5alloc7raw_vec12handle_error
	ud2
.LBB22_44:
	xorl	%r15d, %r15d
.LBB22_47:
	movq	%r15, %rcx
	movq	%r14, %rdx
	callq	_RNvNtCsk3xoiB9w6DV_5alloc7raw_vec12handle_error
	ud2
.LBB22_93:
.Ltmp28:
	movq	%r12, -24(%rbp)
	movq	%r14, -32(%rbp)
	leaq	anon.e304f8fa8dec0a10ab5ae879c02fc903.25(%rip), %rcx
	leaq	anon.e304f8fa8dec0a10ab5ae879c02fc903.26(%rip), %r8
	movl	$113, %edx
	callq	_RNvNtCs998Ihx2sztz_4core9panicking9panic_fmt
	nop
.Ltmp29:
.LBB22_31:
	ud2
	.seh_handlerdata
	.long	$cppxdata$_RNvCs5Av9rWzHob7_3lib11runs_lookup@IMGREL
	.section	.text,"xr",one_only,_RNvCs5Av9rWzHob7_3lib11runs_lookup,unique,22
	.seh_endproc

_RNvCs5Av9rWzHob7_3lib11tree_lookup:
.Lfunc_begin7:
.seh_proc _RNvCs5Av9rWzHob7_3lib11tree_lookup
	.seh_handler __CxxFrameHandler3, @unwind, @except
	pushq	%rbp
	.seh_pushreg %rbp
	pushq	%r15
	.seh_pushreg %r15
	pushq	%r14
	.seh_pushreg %r14
	pushq	%r13
	.seh_pushreg %r13
	pushq	%r12
	.seh_pushreg %r12
	pushq	%rsi
	.seh_pushreg %rsi
	pushq	%rdi
	.seh_pushreg %rdi
	pushq	%rbx
	.seh_pushreg %rbx
	subq	$280, %rsp
	.seh_stackalloc 280
	leaq	128(%rsp), %rbp
	.seh_setframe %rbp, 128
	.seh_endprologue
	movq	$-2, 144(%rbp)
	movq	%r9, %rdi
	movq	%r8, %rsi
	movq	%rdx, %rbx
	movq	%rcx, %r14
	movq	%rdx, %rcx
	shlq	$4, %rcx
	movl	$8, %edx
	movq	%rcx, 128(%rbp)
	callq	_RNvMNtNtCs998Ihx2sztz_4core5alloc6layoutNtB2_6Layout23is_size_alignment_valid
	testb	%al, %al
	je	.LBB23_1
	testq	%rbx, %rbx
	je	.LBB23_108
	movq	%rsi, 48(%rbp)
	callq	_RNvCs9wFQrvczXsK_7___rustc35___rust_no_alloc_shim_is_unstable_v2
	movl	$8, %r15d
	movl	$8, %edx
	movq	128(%rbp), %rcx
	callq	_RNvCs9wFQrvczXsK_7___rustc12___rust_alloc
	testq	%rax, %rax
	je	.LBB23_2
	movl	%ebx, %r10d
	andl	$3, %r10d
	cmpq	$4, %rbx
	jae	.LBB23_7
	xorl	%ecx, %ecx
	jmp	.LBB23_10
.LBB23_108:
	testq	%rdi, %rdi
	jne	.LBB23_118
	xorl	%ebx, %ebx
	jmp	.LBB23_125
.LBB23_7:
	movabsq	$1152921504606846972, %rdx
	andq	%rbx, %rdx
	leaq	56(%rax), %r8
	xorl	%ecx, %ecx
	.p2align	4
.LBB23_8:
	movq	(%r14,%rcx,8), %r9
	movq	%r9, -56(%r8)
	movq	%rcx, -48(%r8)
	movq	8(%r14,%rcx,8), %r9
	movq	%r9, -40(%r8)
	leaq	1(%rcx), %r9
	movq	%r9, -32(%r8)
	movq	16(%r14,%rcx,8), %r9
	movq	%r9, -24(%r8)
	leaq	2(%rcx), %r9
	movq	%r9, -16(%r8)
	movq	24(%r14,%rcx,8), %r9
	movq	%r9, -8(%r8)
	leaq	3(%rcx), %r9
	movq	%r9, (%r8)
	addq	$4, %rcx
	addq	$64, %r8
	cmpq	%rdx, %rcx
	jne	.LBB23_8
	testq	%r10, %r10
	je	.LBB23_12
.LBB23_10:
	movq	%rcx, %rdx
	shlq	$4, %rdx
	addq	%rax, %rdx
	addq	$8, %rdx
	shll	$4, %r10d
	xorl	%r8d, %r8d
	.p2align	4
.LBB23_11:
	movq	(%r14,%rcx,8), %r9
	movq	%r9, -8(%rdx,%r8)
	movq	%rcx, (%rdx,%r8)
	incq	%rcx
	addq	$16, %r8
	cmpq	%r8, %r10
	jne	.LBB23_11
.LBB23_12:
	movq	%rax, 120(%rbp)
	cmpq	$1, %rbx
	je	.LBB23_24
	cmpq	$21, %rbx
	jae	.LBB23_14
	movq	128(%rbp), %rax
	movq	120(%rbp), %r9
	addq	%r9, %rax
	leaq	16(%r9), %r8
	movl	$16, %ecx
	movq	120(%rbp), %rsi
	jmp	.LBB23_16
	.p2align	4
.LBB23_19:
	movq	%rsi, %r10
.LBB23_22:
	movq	%r8, (%r10)
	movq	%r9, 8(%r10)
.LBB23_23:
	leaq	16(%rdx), %r8
	addq	$16, %rcx
	movq	%rdx, %r9
	cmpq	%rax, %r8
	je	.LBB23_24
.LBB23_16:
	movq	%r8, %rdx
	movq	16(%r9), %r8
	cmpq	(%r9), %r8
	jae	.LBB23_23
	movq	24(%r9), %r9
	movq	%rcx, %r11
	.p2align	4
.LBB23_18:
	movdqu	-16(%rsi,%r11), %xmm0
	movdqu	%xmm0, (%rsi,%r11)
	cmpq	$16, %r11
	je	.LBB23_19
	leaq	-16(%r11), %r10
	cmpq	-32(%rsi,%r11), %r8
	movq	%r10, %r11
	jb	.LBB23_18
	addq	%rsi, %r10
	jmp	.LBB23_22
.LBB23_14:
	movb	$1, 143(%rbp)
.Ltmp32:
	leaq	-64(%rbp), %r8
	movq	120(%rbp), %rcx
	movq	%rbx, %rdx
	callq	_RINvNtNtNtCs998Ihx2sztz_4core5slice4sort6stable14driftsort_mainTyjENCINvMNtCsk3xoiB9w6DV_5alloc5sliceSBZ_7sort_byNCINvXs1o_NtNtNtB1b_11collections5btree3mapINtB1X_8BTreeMapyjEINtNtNtNtB8_4iter6traits7collect12FromIteratorBZ_E9from_iterINtNtNtB2U_8adapters3map3MapINtNtB3Q_9enumerate9EnumerateINtNtB3Q_6copied6CopiedINtNtB6_4iter4IteryEEENCNvCs5Av9rWzHob7_3lib11tree_lookup0EE0E0INtNtB1b_3vec3VecBZ_EEB5t_
	nop
.Ltmp33:
.LBB23_24:
	callq	_RNvCs9wFQrvczXsK_7___rustc35___rust_no_alloc_shim_is_unstable_v2
	movl	$192, %ecx
	movl	$8, %edx
	callq	_RNvCs9wFQrvczXsK_7___rustc12___rust_alloc
	testq	%rax, %rax
	movq	%rax, 56(%rbp)
	je	.LBB23_25
	movq	%rdi, 40(%rbp)
	movq	$0, (%rax)
	movw	$0, 186(%rax)
	movq	120(%rbp), %r13
	movq	%r13, %rdx
	addq	128(%rbp), %rdx
	movl	$2, %r8d
	xorl	%r15d, %r15d
	movq	$0, 72(%rbp)
	movq	%rax, %rbx
	movq	%rax, %rdi
	movq	%rdx, 80(%rbp)
	jmp	.LBB23_28
	.p2align	4
.LBB23_66:
	leal	1(%rax), %ecx
	movw	%cx, 186(%rdi)
	movq	%r10, 8(%rdi,%rax,8)
	movq	%r12, 96(%rdi,%rax,8)
	cmpw	186(%rdi), %ax
	jae	.LBB23_67
.LBB23_93:
	incq	%r15
.LBB23_28:
	cmpq	$2, %r8
	je	.LBB23_34
	movq	%rsi, %r10
	testq	%r8, %r8
	je	.LBB23_30
	cmpq	%rdx, %r13
	je	.LBB23_37
.LBB23_38:
	leaq	16(%r13), %rax
	movq	(%r13), %rsi
	movq	8(%r13), %rcx
	movl	$1, %r8d
	cmpq	%rsi, %r10
	jne	.LBB23_39
	cmpq	%rdx, %rax
	je	.LBB23_41
	leaq	32(%r13), %rax
	movq	16(%r13), %rsi
	movq	24(%r13), %r9
	cmpq	%rsi, %r10
	jne	.LBB23_43
	.p2align	4
.LBB23_45:
	movq	%r9, %r12
	cmpq	%rdx, %rax
	je	.LBB23_46
	leaq	16(%rax), %r13
	movq	(%rax), %rsi
	movq	8(%rax), %r9
	movq	%r13, %rax
	cmpq	%rsi, %r10
	je	.LBB23_45
	jmp	.LBB23_47
	.p2align	4
.LBB23_34:
	cmpq	%rdx, %r13
	je	.LBB23_30
	movq	(%r13), %r10
	movq	8(%r13), %r9
	addq	$16, %r13
	cmpq	%rdx, %r13
	jne	.LBB23_38
.LBB23_37:
	movq	%r9, %r12
	jmp	.LBB23_46
	.p2align	4
.LBB23_39:
	movq	%r9, %r12
	movq	%rcx, %r9
	movq	%rax, %r13
	movzwl	186(%rdi), %eax
	cmpq	$11, %rax
	jb	.LBB23_66
	jmp	.LBB23_48
.LBB23_41:
	movq	%rcx, %r12
.LBB23_46:
	xorl	%r8d, %r8d
	xorl	%esi, %esi
	xorl	%r9d, %r9d
	movq	%rdx, %r13
.LBB23_47:
	movzwl	186(%rdi), %eax
	cmpq	$11, %rax
	jb	.LBB23_66
.LBB23_48:
	xorl	%r14d, %r14d
	movq	%r8, 96(%rbp)
	movq	%r9, 104(%rbp)
	movq	%r10, 88(%rbp)
	.p2align	4
.LBB23_49:
	movq	(%rdi), %rdi
	testq	%rdi, %rdi
	je	.LBB23_68
	cmpq	$1, %r14
	je	.LBB23_51
	decq	%r14
	cmpw	$11, 186(%rdi)
	jae	.LBB23_49
	negq	%r14
	movq	%rbx, 112(%rbp)
	jmp	.LBB23_77
	.p2align	4
.LBB23_68:
	callq	_RNvCs9wFQrvczXsK_7___rustc35___rust_no_alloc_shim_is_unstable_v2
	movl	$288, %ecx
	movl	$8, %edx
	callq	_RNvCs9wFQrvczXsK_7___rustc12___rust_alloc
	testq	%rax, %rax
	je	.LBB23_69
	movq	$0, (%rax)
	movw	$0, 186(%rax)
	movq	%rbx, 192(%rax)
	movq	72(%rbp), %r14
	incq	%r14
	movq	%rax, 112(%rbp)
	je	.LBB23_72
	movq	%rax, (%rbx)
	movw	$0, 184(%rbx)
	movq	%rax, %rdi
	movq	%r14, 72(%rbp)
.LBB23_77:
	callq	_RNvCs9wFQrvczXsK_7___rustc35___rust_no_alloc_shim_is_unstable_v2
	movl	$192, %ecx
	movl	$8, %edx
	callq	_RNvCs9wFQrvczXsK_7___rustc12___rust_alloc
	testq	%rax, %rax
	je	.LBB23_78
	movq	%rax, %rbx
	movq	%r15, 64(%rbp)
	movq	%r14, %r15
	movq	$0, (%rax)
	movw	$0, 186(%rax)
	decq	%r15
	je	.LBB23_81
	.p2align	4
.LBB23_94:
	callq	_RNvCs9wFQrvczXsK_7___rustc35___rust_no_alloc_shim_is_unstable_v2
	movl	$288, %ecx
	movl	$8, %edx
	callq	_RNvCs9wFQrvczXsK_7___rustc12___rust_alloc
	testq	%rax, %rax
	je	.LBB23_95
	movq	$0, (%rax)
	movw	$0, 186(%rax)
	movq	%rbx, 192(%rax)
	movq	%rax, (%rbx)
	movw	$0, 184(%rbx)
	movq	%rax, %rbx
	decq	%r15
	jne	.LBB23_94
.LBB23_81:
	movzwl	186(%rdi), %eax
	cmpq	$11, %rax
	jae	.LBB23_82
	leal	1(%rax), %ecx
	movw	%cx, 186(%rdi)
	movq	88(%rbp), %rcx
	movq	%rcx, 8(%rdi,%rax,8)
	movq	%r12, 96(%rdi,%rax,8)
	movq	%rbx, 200(%rdi,%rax,8)
	cmpw	186(%rdi), %ax
	jae	.LBB23_84
	incq	%rax
	movq	%rdi, (%rbx)
	movw	%ax, 184(%rbx)
	movq	%r14, %rax
	andq	$7, %rax
	je	.LBB23_86
	xorl	%ecx, %ecx
	movq	64(%rbp), %r15
	movq	96(%rbp), %r8
	movq	104(%rbp), %r9
	.p2align	4
.LBB23_88:
	movzwl	186(%rdi), %edx
	movq	192(%rdi,%rdx,8), %rdi
	incq	%rcx
	cmpq	%rcx, %rax
	jne	.LBB23_88
	movq	%r14, %rax
	subq	%rcx, %rax
	cmpq	$8, %r14
	jb	.LBB23_92
	.p2align	4
.LBB23_91:
	movzwl	186(%rdi), %ecx
	movq	192(%rdi,%rcx,8), %rcx
	movzwl	186(%rcx), %edx
	movq	192(%rcx,%rdx,8), %rcx
	movzwl	186(%rcx), %edx
	movq	192(%rcx,%rdx,8), %rcx
	movzwl	186(%rcx), %edx
	movq	192(%rcx,%rdx,8), %rcx
	movzwl	186(%rcx), %edx
	movq	192(%rcx,%rdx,8), %rcx
	movzwl	186(%rcx), %edx
	movq	192(%rcx,%rdx,8), %rcx
	movzwl	186(%rcx), %edx
	movq	192(%rcx,%rdx,8), %rcx
	movzwl	186(%rcx), %edx
	movq	192(%rcx,%rdx,8), %rdi
	addq	$-8, %rax
	jne	.LBB23_91
.LBB23_92:
	movq	112(%rbp), %rbx
	movq	80(%rbp), %rdx
	jmp	.LBB23_93
.LBB23_86:
	movq	%r14, %rax
	movq	64(%rbp), %r15
	movq	96(%rbp), %r8
	movq	104(%rbp), %r9
	cmpq	$8, %r14
	jae	.LBB23_91
	jmp	.LBB23_92
.LBB23_43:
	movq	%rcx, %r12
	movq	%rax, %r13
	movzwl	186(%rdi), %eax
	cmpq	$11, %rax
	jb	.LBB23_66
	jmp	.LBB23_48
.LBB23_30:
	movq	%rbx, 104(%rbp)
	movq	%r15, 64(%rbp)
	movl	$8, %r8d
	movq	120(%rbp), %rcx
	movq	128(%rbp), %rdx
	callq	_RNvCs9wFQrvczXsK_7___rustc14___rust_dealloc
	movq	72(%rbp), %r13
	testq	%r13, %r13
	je	.LBB23_106
	movq	%r13, %rax
	movq	104(%rbp), %r15
	jmp	.LBB23_32
	.p2align	4
.LBB23_65:
	movq	232(%rdi), %rax
	movq	%rdi, (%rax)
	movw	$5, 184(%rax)
	movq	96(%rbp), %rax
.LBB23_56:
	movq	%rdi, %r15
	decq	%rax
	je	.LBB23_106
.LBB23_32:
	movzwl	186(%r15), %esi
	testq	%rsi, %rsi
	je	.LBB23_33
	movq	184(%r15,%rsi,8), %r9
	movzwl	186(%r9), %r12d
	cmpq	$9, %r12
	jbe	.LBB23_54
	movq	192(%r15,%rsi,8), %rdi
	movzwl	186(%rdi), %ebx
	cmpq	$5, %rbx
	jae	.LBB23_56
	movq	%rax, 96(%rbp)
	movl	$5, %r14d
	subq	%rbx, %r14
	movq	%r12, %r13
	subq	%r14, %r13
	movw	%r13w, 186(%r9)
	movw	$5, 186(%rdi)
	leaq	8(%rdi), %rdx
	leal	(,%r14,8), %eax
	movq	%rax, 112(%rbp)
	leaq	(%rdi,%rax), %rcx
	addq	$8, %rcx
	shll	$3, %ebx
	movq	%rbx, %r8
	movq	%r9, 88(%rbp)
	callq	memmove
	leaq	96(%rdi), %rdx
	movq	112(%rbp), %rax
	leaq	(%rdi,%rax), %rcx
	addq	$96, %rcx
	movq	%rbx, %r8
	callq	memmove
	leaq	1(%r13), %rax
	subq	%rax, %r12
	movq	%rax, 32(%rbp)
	leal	(,%rax,8), %ecx
	movq	%rcx, 112(%rbp)
	movq	88(%rbp), %rax
	leaq	8(%rax,%rcx), %rdx
	leal	(,%r12,8), %r8d
	movq	%r8, 80(%rbp)
	leaq	8(%rdi), %rcx
	callq	memcpy
	movq	88(%rbp), %rax
	movq	112(%rbp), %rcx
	leaq	(%rax,%rcx), %rdx
	addq	$96, %rdx
	leaq	96(%rdi), %rcx
	movq	80(%rbp), %r8
	callq	memcpy
	movzwl	186(%r15), %eax
	leaq	-1(%rsi), %rcx
	cmpl	%eax, %ecx
	jae	.LBB23_58
	movq	88(%rbp), %r9
	leaq	8(%r9), %rax
	leaq	96(%r9), %rcx
	shll	$3, %r13d
	movq	(%rcx,%r13), %rcx
	movq	(%rax,%r13), %rax
	movq	(%r15,%rsi,8), %rdx
	movq	88(%r15,%rsi,8), %r8
	movq	%rax, (%r15,%rsi,8)
	movq	%rcx, 88(%r15,%rsi,8)
	movq	%rdx, (%rdi,%r14,8)
	movq	%r8, 96(%rdi,%r12,8)
	cmpq	$1, 96(%rbp)
	movq	72(%rbp), %r13
	je	.LBB23_106
	leaq	192(%rdi), %r15
	shll	$3, %r14d
	leaq	(%rdi,%r14), %rcx
	addq	$192, %rcx
	addq	$8, %rbx
	movq	%r15, %rdx
	movq	%rbx, %r8
	movq	%r9, %rsi
	callq	memmove
	movq	32(%rbp), %rax
	leaq	(%rsi,%rax,8), %rdx
	addq	$192, %rdx
	movq	%r15, %rcx
	movq	%r14, %r8
	callq	memcpy
	movq	192(%rdi), %rax
	movq	%rdi, (%rax)
	movw	$0, 184(%rax)
	cmpw	$0, 186(%rdi)
	je	.LBB23_59
	movq	200(%rdi), %rax
	movq	%rdi, (%rax)
	movw	$1, 184(%rax)
	cmpw	$2, 186(%rdi)
	jb	.LBB23_59
	movq	208(%rdi), %rax
	movq	%rdi, (%rax)
	movw	$2, 184(%rax)
	cmpw	$3, 186(%rdi)
	jb	.LBB23_59
	movq	216(%rdi), %rax
	movq	%rdi, (%rax)
	movw	$3, 184(%rax)
	cmpw	$4, 186(%rdi)
	jb	.LBB23_59
	movq	224(%rdi), %rax
	movq	%rdi, (%rax)
	movw	$4, 184(%rax)
	cmpw	$5, 186(%rdi)
	jae	.LBB23_65
.LBB23_59:
.Ltmp38:
	leaq	anon.e304f8fa8dec0a10ab5ae879c02fc903.14(%rip), %rcx
	leaq	anon.e304f8fa8dec0a10ab5ae879c02fc903.15(%rip), %r8
	movl	$33, %edx
	callq	_RNvNtCs998Ihx2sztz_4core9panicking5panic
	nop
.Ltmp39:
	jmp	.LBB23_26
.LBB23_106:
	movq	104(%rbp), %rax
	movq	%rax, 8(%rbp)
	movq	%r13, 16(%rbp)
	movq	64(%rbp), %r15
	movq	%r15, 24(%rbp)
	movq	40(%rbp), %rdi
	testq	%rdi, %rdi
	je	.LBB23_107
	testq	%rax, %rax
	je	.LBB23_118
	xorl	%ebx, %ebx
	xorl	%eax, %eax
	movq	48(%rbp), %r14
	.p2align	4
.LBB23_112:
	movq	(%r14,%rax,8), %rdx
	movq	104(%rbp), %rcx
	movq	%r13, %r8
.LBB23_113:
	movzwl	186(%rcx), %r10d
	movl	%r10d, %r11d
	shll	$3, %r11d
	movq	$-1, %r9
	.p2align	4
.LBB23_114:
	testq	%r11, %r11
	je	.LBB23_115
	cmpq	16(%rcx,%r9,8), %rdx
	seta	%sil
	sbbb	$0, %sil
	incq	%r9
	addq	$-8, %r11
	cmpb	$1, %sil
	je	.LBB23_114
	movzbl	%sil, %r11d
	testl	%r11d, %r11d
	je	.LBB23_130
	cmpq	%r10, %r9
	ja	.LBB23_129
	subq	$1, %r8
	jae	.LBB23_132
	jmp	.LBB23_117
	.p2align	4
.LBB23_115:
	movq	%r10, %r9
	subq	$1, %r8
	jb	.LBB23_117
.LBB23_132:
	movq	192(%rcx,%r9,8), %rcx
	jmp	.LBB23_113
	.p2align	4
.LBB23_130:
	cmpq	%r10, %r9
	jae	.LBB23_131
	movq	96(%rcx,%r9,8), %rcx
	xorq	%rcx, %rbx
	incq	%rax
	cmpq	%rdi, %rax
	jne	.LBB23_112
	jmp	.LBB23_135
.LBB23_117:
	movq	$-1, %rcx
	xorq	%rcx, %rbx
	incq	%rax
	cmpq	%rdi, %rax
	jne	.LBB23_112
	jmp	.LBB23_135
.LBB23_118:
	cmpq	$4, %rdi
	jae	.LBB23_120
	xorl	%eax, %eax
	xorl	%ebx, %ebx
	jmp	.LBB23_123
.LBB23_107:
	xorl	%ebx, %ebx
.LBB23_135:
	movq	104(%rbp), %rax
	testq	%rax, %rax
	je	.LBB23_125
	movq	$0, -56(%rbp)
	movq	%rax, -48(%rbp)
	movq	%r13, -40(%rbp)
	movq	$0, -24(%rbp)
	movq	%rax, -16(%rbp)
	movq	%r13, -8(%rbp)
	movl	$1, %eax
	jmp	.LBB23_137
.LBB23_120:
	movabsq	$1152921504606846972, %rax
	andq	%rdi, %rax
	pxor	%xmm0, %xmm0
	pcmpeqd	%xmm2, %xmm2
	movq	%rax, %rcx
	pxor	%xmm3, %xmm3
	.p2align	4
.LBB23_121:
	movdqa	%xmm3, %xmm1
	movdqa	%xmm0, %xmm4
	pxor	%xmm2, %xmm0
	pxor	%xmm2, %xmm3
	addq	$-4, %rcx
	jne	.LBB23_121
	pxor	%xmm4, %xmm1
	pshufd	$238, %xmm1, %xmm0
	pxor	%xmm1, %xmm0
	movq	%xmm0, %rbx
	cmpq	%rax, %rdi
	je	.LBB23_125
.LBB23_123:
	subq	%rax, %rdi
	.p2align	4
.LBB23_124:
	notq	%rbx
	decq	%rdi
	jne	.LBB23_124
.LBB23_125:
	xorl	%eax, %eax
	xorl	%r15d, %r15d
.LBB23_137:
	movq	%rax, -64(%rbp)
	movq	%rax, -32(%rbp)
	movq	%r15, (%rbp)
	leaq	-88(%rbp), %rsi
	leaq	-64(%rbp), %rdi
	.p2align	4
.LBB23_138:
	movq	%rsi, %rcx
	movq	%rdi, %rdx
	callq	_RNvMsz_NtNtNtCsk3xoiB9w6DV_5alloc11collections5btree3mapINtB5_8IntoIteryjE10dying_nextCs5Av9rWzHob7_3lib
	movq	-88(%rbp), %rax
	testq	%rax, %rax
	je	.LBB23_142
	movzwl	186(%rax), %eax
	cmpq	%rax, -72(%rbp)
	jb	.LBB23_138
.Ltmp64:
	leaq	anon.e304f8fa8dec0a10ab5ae879c02fc903.34(%rip), %rcx
	leaq	anon.e304f8fa8dec0a10ab5ae879c02fc903.36(%rip), %r8
	movl	$44, %edx
	callq	_RNvNtCs998Ihx2sztz_4core9panicking5panic
	nop
.Ltmp65:
	jmp	.LBB23_26
.LBB23_142:
	movq	%rbx, %rax
	.seh_startepilogue
	addq	$280, %rsp
	popq	%rbx
	popq	%rdi
	popq	%rsi
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.seh_endepilogue
	retq
.LBB23_95:
.Ltmp48:
	movl	$8, %ecx
	movl	$288, %edx
	callq	_RNvNtCsk3xoiB9w6DV_5alloc5alloc18handle_alloc_error
	nop
.Ltmp49:
	jmp	.LBB23_26
.LBB23_51:
.Ltmp46:
	leaq	anon.e304f8fa8dec0a10ab5ae879c02fc903.37(%rip), %rcx
	leaq	anon.e304f8fa8dec0a10ab5ae879c02fc903.38(%rip), %r8
	movl	$28, %edx
	callq	_RNvNtCs998Ihx2sztz_4core9panicking5panic
	nop
.Ltmp47:
	jmp	.LBB23_26
.LBB23_129:
.Ltmp44:
	leaq	anon.e304f8fa8dec0a10ab5ae879c02fc903.32(%rip), %rcx
	leaq	anon.e304f8fa8dec0a10ab5ae879c02fc903.33(%rip), %r8
	movl	$35, %edx
	callq	_RNvNtCs998Ihx2sztz_4core9panicking5panic
	nop
.Ltmp45:
	jmp	.LBB23_26
.LBB23_67:
.Ltmp60:
	leaq	anon.e304f8fa8dec0a10ab5ae879c02fc903.30(%rip), %rcx
	leaq	anon.e304f8fa8dec0a10ab5ae879c02fc903.31(%rip), %r8
	movl	$34, %edx
	callq	_RNvNtCs998Ihx2sztz_4core9panicking5panic
	nop
.Ltmp61:
	jmp	.LBB23_26
.LBB23_78:
.Ltmp54:
	movl	$8, %ecx
	movl	$192, %edx
	callq	_RNvNtCsk3xoiB9w6DV_5alloc5alloc18handle_alloc_error
	nop
.Ltmp55:
	jmp	.LBB23_26
.LBB23_82:
.Ltmp50:
	leaq	anon.e304f8fa8dec0a10ab5ae879c02fc903.41(%rip), %rcx
	leaq	anon.e304f8fa8dec0a10ab5ae879c02fc903.42(%rip), %r8
	movl	$32, %edx
	callq	_RNvNtCs998Ihx2sztz_4core9panicking5panic
	nop
.Ltmp51:
	jmp	.LBB23_26
.LBB23_84:
.Ltmp52:
	leaq	anon.e304f8fa8dec0a10ab5ae879c02fc903.32(%rip), %rcx
	leaq	anon.e304f8fa8dec0a10ab5ae879c02fc903.33(%rip), %r8
	movl	$35, %edx
	callq	_RNvNtCs998Ihx2sztz_4core9panicking5panic
	nop
.Ltmp53:
	jmp	.LBB23_26
.LBB23_33:
.Ltmp40:
	leaq	anon.e304f8fa8dec0a10ab5ae879c02fc903.39(%rip), %rcx
	leaq	anon.e304f8fa8dec0a10ab5ae879c02fc903.40(%rip), %r8
	movl	$25, %edx
	callq	_RNvNtCs998Ihx2sztz_4core9panicking5panic
	nop
.Ltmp41:
	jmp	.LBB23_26
.LBB23_54:
.Ltmp34:
	leaq	anon.e304f8fa8dec0a10ab5ae879c02fc903.27(%rip), %rcx
	leaq	anon.e304f8fa8dec0a10ab5ae879c02fc903.29(%rip), %r8
	movl	$57, %edx
	callq	_RNvNtCs998Ihx2sztz_4core9panicking5panic
	nop
.Ltmp35:
	jmp	.LBB23_26
.LBB23_131:
.Ltmp42:
	leaq	anon.e304f8fa8dec0a10ab5ae879c02fc903.30(%rip), %rcx
	leaq	anon.e304f8fa8dec0a10ab5ae879c02fc903.31(%rip), %r8
	movl	$34, %edx
	callq	_RNvNtCs998Ihx2sztz_4core9panicking5panic
	nop
.Ltmp43:
	jmp	.LBB23_26
.LBB23_69:
.Ltmp58:
	movl	$8, %ecx
	movl	$288, %edx
	callq	_RNvNtCsk3xoiB9w6DV_5alloc5alloc18handle_alloc_error
	nop
.Ltmp59:
	jmp	.LBB23_26
.LBB23_72:
.Ltmp56:
	leaq	anon.e304f8fa8dec0a10ab5ae879c02fc903.1(%rip), %rcx
	callq	_RNvNtCs998Ihx2sztz_4core6option13unwrap_failed
	nop
.Ltmp57:
	jmp	.LBB23_26
.LBB23_58:
.Ltmp36:
	leaq	anon.e304f8fa8dec0a10ab5ae879c02fc903.34(%rip), %rcx
	leaq	anon.e304f8fa8dec0a10ab5ae879c02fc903.35(%rip), %r8
	movl	$44, %edx
	callq	_RNvNtCs998Ihx2sztz_4core9panicking5panic
	nop
.Ltmp37:
	jmp	.LBB23_26
.LBB23_25:
.Ltmp62:
	movl	$8, %ecx
	movl	$192, %edx
	callq	_RNvNtCsk3xoiB9w6DV_5alloc5alloc18handle_alloc_error
	nop
.Ltmp63:
.LBB23_26:
	ud2
.LBB23_1:
	xorl	%r15d, %r15d
.LBB23_2:
	movq	%r15, %rcx
	movq	128(%rbp), %rdx
	callq	_RNvNtCsk3xoiB9w6DV_5alloc7raw_vec12handle_error
	ud2
	.seh_handlerdata
	.long	$cppxdata$_RNvCs5Av9rWzHob7_3lib11tree_lookup@IMGREL
	.section	.text,"xr",one_only,_RNvCs5Av9rWzHob7_3lib11tree_lookup,unique,23
	.seh_endproc

_RNvCs5Av9rWzHob7_3lib13packed_lookup:
.Lfunc_begin8:
.seh_proc _RNvCs5Av9rWzHob7_3lib13packed_lookup
	.seh_handler __CxxFrameHandler3, @unwind, @except
	pushq	%rbp
	.seh_pushreg %rbp
	pushq	%r15
	.seh_pushreg %r15
	pushq	%r14
	.seh_pushreg %r14
	pushq	%r12
	.seh_pushreg %r12
	pushq	%rsi
	.seh_pushreg %rsi
	pushq	%rdi
	.seh_pushreg %rdi
	pushq	%rbx
	.seh_pushreg %rbx
	subq	$64, %rsp
	.seh_stackalloc 64
	leaq	64(%rsp), %rbp
	.seh_setframe %rbp, 64
	.seh_endprologue
	movq	$-2, -8(%rbp)
	cmpq	$100001, %rdx
	jae	.LBB24_74
	movq	%r9, %rsi
	movq	%r8, %rdi
	movq	%rdx, %rbx
	testq	%rdx, %rdx
	je	.LBB24_2
	leaq	(,%rbx,8), %rax
	movq	(%rcx), %rdx
	xorl	%r8d, %r8d
	.p2align	4
.LBB24_6:
	testq	%rax, %rax
	je	.LBB24_3
	movq	(%rcx,%r8,8), %r9
	subq	%rdx, %r9
	jb	.LBB24_9
	addq	$-8, %rax
	cmpq	%r9, %r8
	leaq	1(%r8), %r8
	je	.LBB24_6
.LBB24_9:
	movq	%rcx, %r15
	leaq	(,%rbx,4), %rax
	leaq	(%rax,%rax,2), %r12
	movl	$4, %r14d
	movl	$4, %edx
	movq	%r12, %rcx
	callq	_RNvMNtNtCs998Ihx2sztz_4core5alloc6layoutNtB2_6Layout23is_size_alignment_valid
	testb	%al, %al
	je	.LBB24_10
	callq	_RNvCs9wFQrvczXsK_7___rustc35___rust_no_alloc_shim_is_unstable_v2
	movl	$4, %edx
	movq	%r12, %rcx
	callq	_RNvCs9wFQrvczXsK_7___rustc12___rust_alloc
	testq	%rax, %rax
	je	.LBB24_11
	movl	%ebx, %edx
	andl	$3, %edx
	cmpq	$4, %rbx
	movq	%r12, -24(%rbp)
	jae	.LBB24_15
	xorl	%ecx, %ecx
	jmp	.LBB24_18
.LBB24_2:
	xorl	%edx, %edx
.LBB24_3:
	testq	%rsi, %rsi
	je	.LBB24_4
	cmpq	$1, %rsi
	jne	.LBB24_69
	xorl	%ecx, %ecx
	xorl	%eax, %eax
	jmp	.LBB24_72
.LBB24_4:
	xorl	%eax, %eax
	jmp	.LBB24_73
.LBB24_69:
	movabsq	$1152921504606846974, %r8
	andq	%rsi, %r8
	xorl	%ecx, %ecx
	movq	$-1, %r9
	xorl	%eax, %eax
	.p2align	4
.LBB24_70:
	movq	(%rdi,%rcx,8), %r10
	movq	8(%rdi,%rcx,8), %r11
	movq	%r11, %r14
	subq	%rdx, %r14
	cmpq	%rbx, %r14
	cmovaeq	%r9, %r14
	cmpq	%rdx, %r11
	cmovbq	%r9, %r14
	movq	%r10, %r11
	subq	%rdx, %r11
	cmpq	%rbx, %r11
	cmovaeq	%r9, %r11
	cmpq	%rdx, %r10
	cmovbq	%r9, %r11
	xorq	%r11, %rax
	xorq	%r14, %rax
	addq	$2, %rcx
	cmpq	%rcx, %r8
	jne	.LBB24_70
	testb	$1, %sil
	je	.LBB24_73
.LBB24_72:
	movq	%rax, %r8
	movq	(%rdi,%rcx,8), %rcx
	movq	%rcx, %rax
	subq	%rdx, %rax
	cmpq	%rbx, %rax
	movq	$-1, %r9
	cmovaeq	%r9, %rax
	cmpq	%rdx, %rcx
	cmovbq	%r9, %rax
	xorq	%r8, %rax
	jmp	.LBB24_73
.LBB24_15:
	movl	%ebx, %r8d
	andl	$131068, %r8d
	leaq	44(%rax), %r9
	xorl	%ecx, %ecx
	.p2align	4
.LBB24_16:
	movq	(%r15,%rcx,8), %r10
	movq	%r10, -44(%r9)
	movl	%ecx, -36(%r9)
	movq	8(%r15,%rcx,8), %r10
	movq	%r10, -32(%r9)
	leal	1(%rcx), %r10d
	movl	%r10d, -24(%r9)
	movq	16(%r15,%rcx,8), %r10
	movq	%r10, -20(%r9)
	leal	2(%rcx), %r10d
	movl	%r10d, -12(%r9)
	movq	24(%r15,%rcx,8), %r10
	movq	%r10, -8(%r9)
	leal	3(%rcx), %r10d
	movl	%r10d, (%r9)
	addq	$4, %rcx
	addq	$48, %r9
	cmpq	%r8, %rcx
	jne	.LBB24_16
	testq	%rdx, %rdx
	je	.LBB24_20
.LBB24_18:
	leaq	(%rcx,%rcx,2), %r8
	leaq	(%rax,%r8,4), %r8
	addq	$8, %r8
	shll	$2, %edx
	leaq	(%rdx,%rdx,2), %rdx
	xorl	%r9d, %r9d
	.p2align	4
.LBB24_19:
	movq	(%r15,%rcx,8), %r10
	movq	%r10, -8(%r8,%r9)
	movl	%ecx, (%r8,%r9)
	incq	%rcx
	addq	$12, %r9
	cmpq	%r9, %rdx
	jne	.LBB24_19
.LBB24_20:
	movq	%rax, -16(%rbp)
	cmpq	$1, %rbx
	je	.LBB24_32
	cmpq	$21, %rbx
	jae	.LBB24_22
	movq	-24(%rbp), %rax
	movq	-16(%rbp), %r9
	addq	%r9, %rax
	leaq	12(%r9), %r8
	movl	$12, %ecx
	movq	-16(%rbp), %r14
	jmp	.LBB24_24
	.p2align	4
.LBB24_27:
	movq	%r14, %r11
.LBB24_30:
	movq	%r8, (%r11)
	movl	%r9d, 8(%r11)
.LBB24_31:
	leaq	12(%rdx), %r8
	addq	$12, %rcx
	movq	%rdx, %r9
	cmpq	%rax, %r8
	je	.LBB24_32
.LBB24_24:
	movq	%r8, %rdx
	movq	12(%r9), %r8
	cmpq	(%r9), %r8
	jae	.LBB24_31
	movl	20(%r9), %r9d
	movq	%rcx, %r10
	.p2align	4
.LBB24_26:
	movl	-4(%r14,%r10), %r11d
	movl	%r11d, 8(%r14,%r10)
	movq	-12(%r14,%r10), %r11
	movq	%r11, (%r14,%r10)
	cmpq	$12, %r10
	je	.LBB24_27
	leaq	-12(%r10), %r11
	cmpq	-24(%r14,%r10), %r8
	movq	%r11, %r10
	jb	.LBB24_26
	addq	%r14, %r11
	jmp	.LBB24_30
.LBB24_22:
.Ltmp66:
	leaq	-32(%rbp), %r8
	movq	-16(%rbp), %rcx
	movq	%rbx, %rdx
	callq	_RINvNtNtNtCs998Ihx2sztz_4core5slice4sort8unstable7ipnsortNtNtCs5Av9rWzHob7_3lib10runs_index5EntryNCINvMB6_SBT_20sort_unstable_by_keyyNCINvMs_BV_NtBV_13IdentityIndex8from_idsINtNtNtNtB8_4iter8adapters6copied6CopiedINtNtB6_4iter4IteryEEEs0_0E0EBX_
	nop
.Ltmp67:
.LBB24_32:
	leaq	1(%rbx), %rax
	movq	-16(%rbp), %r12
	movq	%r12, %rcx
	movq	-24(%rbp), %rdx
	.p2align	4
.LBB24_33:
	decq	%rax
	cmpq	$2, %rax
	jb	.LBB24_39
	movq	(%rcx), %r8
	cmpq	12(%rcx), %r8
	leaq	12(%rcx), %rcx
	jne	.LBB24_33
.Ltmp68:
	leaq	anon.e304f8fa8dec0a10ab5ae879c02fc903.5(%rip), %rcx
	leaq	anon.e304f8fa8dec0a10ab5ae879c02fc903.10(%rip), %r8
	movl	$73, %edx
	callq	_RNvNtCs998Ihx2sztz_4core9panicking9panic_fmt
	nop
.Ltmp69:
	ud2
.LBB24_39:
	testq	%rsi, %rsi
	je	.LBB24_40
	testq	%rbx, %rbx
	je	.LBB24_49
	cmpq	$1, %rbx
	jne	.LBB24_43
	movq	(%r12), %rcx
	cmpq	$1, %rsi
	jne	.LBB24_58
	xorl	%r11d, %r11d
	xorl	%eax, %eax
	jmp	.LBB24_65
.LBB24_40:
	xorl	%eax, %eax
	jmp	.LBB24_68
.LBB24_49:
	cmpq	$4, %rsi
	jae	.LBB24_51
	xorl	%ecx, %ecx
	xorl	%eax, %eax
	jmp	.LBB24_54
.LBB24_43:
	xorl	%eax, %eax
	xorl	%ecx, %ecx
	jmp	.LBB24_44
	.p2align	4
.LBB24_48:
	xorq	%r8, %rax
	incq	%rcx
	cmpq	%rsi, %rcx
	je	.LBB24_68
.LBB24_44:
	movq	(%rdi,%rcx,8), %r15
	movq	%rbx, %r8
	xorl	%r9d, %r9d
	.p2align	4
.LBB24_45:
	movq	%r9, %r10
	movq	%r8, %r11
	shrq	%r11
	addq	%r11, %r9
	leaq	(%r9,%r9,2), %r14
	cmpq	%r15, (%r12,%r14,4)
	cmovaq	%r10, %r9
	subq	%r11, %r8
	cmpq	$1, %r8
	ja	.LBB24_45
	leaq	(%r9,%r9,2), %r9
	movq	$-1, %r8
	cmpq	%r15, (%r12,%r9,4)
	jne	.LBB24_48
	leaq	(%r12,%r9,4), %r8
	movl	8(%r8), %r8d
	jmp	.LBB24_48
.LBB24_58:
	movabsq	$1152921504606846974, %r8
	andq	%rsi, %r8
	xorl	%r11d, %r11d
	xorl	%eax, %eax
	jmp	.LBB24_59
	.p2align	4
.LBB24_63:
	xorq	%r10, %rax
	xorq	%r9, %rax
	addq	$2, %r11
	cmpq	%r11, %r8
	je	.LBB24_64
.LBB24_59:
	movq	$-1, %r9
	movq	$-1, %r10
	cmpq	(%rdi,%r11,8), %rcx
	jne	.LBB24_61
	movl	8(%r12), %r10d
.LBB24_61:
	cmpq	8(%rdi,%r11,8), %rcx
	jne	.LBB24_63
	movl	8(%r12), %r9d
	jmp	.LBB24_63
.LBB24_64:
	testb	$1, %sil
	je	.LBB24_68
.LBB24_65:
	movq	$-1, %r8
	cmpq	(%rdi,%r11,8), %rcx
	jne	.LBB24_67
	movl	8(%r12), %r8d
.LBB24_67:
	xorq	%r8, %rax
.LBB24_68:
	movl	$4, %r8d
	movq	%r12, %rcx
	movq	%rax, %rsi
	callq	_RNvCs9wFQrvczXsK_7___rustc14___rust_dealloc
	movq	%rsi, %rax
.LBB24_73:
	.seh_startepilogue
	addq	$64, %rsp
	popq	%rbx
	popq	%rdi
	popq	%rsi
	popq	%r12
	popq	%r14
	popq	%r15
	popq	%rbp
	.seh_endepilogue
	retq
.LBB24_51:
	movabsq	$1152921504606846972, %rcx
	andq	%rsi, %rcx
	pxor	%xmm0, %xmm0
	pcmpeqd	%xmm2, %xmm2
	movq	%rcx, %rax
	pxor	%xmm3, %xmm3
	.p2align	4
.LBB24_52:
	movdqa	%xmm3, %xmm1
	movdqa	%xmm0, %xmm4
	pxor	%xmm2, %xmm0
	pxor	%xmm2, %xmm3
	addq	$-4, %rax
	jne	.LBB24_52
	pxor	%xmm4, %xmm1
	pshufd	$238, %xmm1, %xmm0
	pxor	%xmm1, %xmm0
	movq	%xmm0, %rax
	cmpq	%rcx, %rsi
	je	.LBB24_73
.LBB24_54:
	subq	%rcx, %rsi
	.p2align	4
.LBB24_55:
	notq	%rax
	decq	%rsi
	jne	.LBB24_55
	jmp	.LBB24_73
.LBB24_74:
	leaq	anon.e304f8fa8dec0a10ab5ae879c02fc903.2(%rip), %rcx
	leaq	anon.e304f8fa8dec0a10ab5ae879c02fc903.9(%rip), %r8
	movl	$63, %edx
	callq	_RNvNtCs998Ihx2sztz_4core9panicking9panic_fmt
	ud2
.LBB24_10:
	xorl	%r14d, %r14d
.LBB24_11:
	movq	%r14, %rcx
	movq	%r12, %rdx
	callq	_RNvNtCsk3xoiB9w6DV_5alloc7raw_vec12handle_error
	ud2
	.seh_handlerdata
	.long	$cppxdata$_RNvCs5Av9rWzHob7_3lib13packed_lookup@IMGREL
	.section	.text,"xr",one_only,_RNvCs5Av9rWzHob7_3lib13packed_lookup,unique,24
	.seh_endproc

_RNvCs5Av9rWzHob7_3lib14aligned_lookup:
.Lfunc_begin9:
.seh_proc _RNvCs5Av9rWzHob7_3lib14aligned_lookup
	.seh_handler __CxxFrameHandler3, @unwind, @except
	pushq	%rbp
	.seh_pushreg %rbp
	pushq	%r15
	.seh_pushreg %r15
	pushq	%r14
	.seh_pushreg %r14
	pushq	%r12
	.seh_pushreg %r12
	pushq	%rsi
	.seh_pushreg %rsi
	pushq	%rdi
	.seh_pushreg %rdi
	pushq	%rbx
	.seh_pushreg %rbx
	subq	$64, %rsp
	.seh_stackalloc 64
	leaq	64(%rsp), %rbp
	.seh_setframe %rbp, 64
	.seh_endprologue
	movq	$-2, -8(%rbp)
	movq	%r9, %rdi
	movq	%r8, %rbx
	movq	%rdx, %rsi
	movq	%rcx, %r14
	movq	%rdx, %r12
	shlq	$4, %r12
	movl	$8, %edx
	movq	%r12, %rcx
	callq	_RNvMNtNtCs998Ihx2sztz_4core5alloc6layoutNtB2_6Layout23is_size_alignment_valid
	testb	%al, %al
	je	.LBB25_1
	testq	%rsi, %rsi
	je	.LBB25_4
	callq	_RNvCs9wFQrvczXsK_7___rustc35___rust_no_alloc_shim_is_unstable_v2
	movl	$8, %r15d
	movl	$8, %edx
	movq	%r12, %rcx
	callq	_RNvCs9wFQrvczXsK_7___rustc12___rust_alloc
	testq	%rax, %rax
	je	.LBB25_2
	movq	%rax, %rcx
	movl	%esi, %eax
	andl	$3, %eax
	cmpq	$4, %rsi
	jae	.LBB25_8
	xorl	%r10d, %r10d
	jmp	.LBB25_11
.LBB25_4:
	movl	$8, %ecx
	jmp	.LBB25_26
.LBB25_8:
	movabsq	$1152921504606846972, %rdx
	andq	%rsi, %rdx
	leaq	56(%rcx), %r8
	xorl	%r10d, %r10d
	.p2align	4
.LBB25_9:
	movq	(%r14,%r10,8), %r9
	movq	%r9, -56(%r8)
	movl	%r10d, -48(%r8)
	movq	8(%r14,%r10,8), %r9
	movq	%r9, -40(%r8)
	leal	1(%r10), %r9d
	movl	%r9d, -32(%r8)
	movq	16(%r14,%r10,8), %r9
	movq	%r9, -24(%r8)
	leal	2(%r10), %r9d
	movl	%r9d, -16(%r8)
	movq	24(%r14,%r10,8), %r9
	movq	%r9, -8(%r8)
	leal	3(%r10), %r9d
	movl	%r9d, (%r8)
	addq	$4, %r10
	addq	$64, %r8
	cmpq	%rdx, %r10
	jne	.LBB25_9
	testq	%rax, %rax
	je	.LBB25_13
.LBB25_11:
	movq	%r10, %rdx
	shlq	$4, %rdx
	addq	%rcx, %rdx
	addq	$8, %rdx
	shll	$4, %eax
	xorl	%r8d, %r8d
	.p2align	4
.LBB25_12:
	movq	(%r14,%r10,8), %r9
	movq	%r9, -8(%rdx,%r8)
	movl	%r10d, (%rdx,%r8)
	incq	%r10
	addq	$16, %r8
	cmpq	%r8, %rax
	jne	.LBB25_12
.LBB25_13:
	cmpq	$1, %rsi
	je	.LBB25_26
	cmpq	$21, %rsi
	jae	.LBB25_15
	leaq	(%rcx,%r12), %rax
	leaq	16(%rcx), %r8
	movl	$16, %r14d
	movq	%rcx, %r9
	jmp	.LBB25_18
	.p2align	4
.LBB25_21:
	movq	%rcx, %r10
.LBB25_24:
	movq	%r8, (%r10)
	movl	%r9d, 8(%r10)
.LBB25_25:
	leaq	16(%rdx), %r8
	addq	$16, %r14
	movq	%rdx, %r9
	cmpq	%rax, %r8
	je	.LBB25_26
.LBB25_18:
	movq	%r8, %rdx
	movq	16(%r9), %r8
	cmpq	(%r9), %r8
	jae	.LBB25_25
	movl	24(%r9), %r9d
	movq	%r14, %r11
	.p2align	4
.LBB25_20:
	movdqu	-16(%rcx,%r11), %xmm0
	movdqu	%xmm0, (%rcx,%r11)
	cmpq	$16, %r11
	je	.LBB25_21
	leaq	-16(%r11), %r10
	cmpq	-32(%rcx,%r11), %r8
	movq	%r10, %r11
	jb	.LBB25_20
	addq	%rcx, %r10
	jmp	.LBB25_24
.LBB25_15:
.Ltmp70:
	movq	%r12, -24(%rbp)
	leaq	-32(%rbp), %r8
	movq	%rcx, -16(%rbp)
	movq	%rsi, %rdx
	callq	_RINvNtNtNtCs998Ihx2sztz_4core5slice4sort8unstable7ipnsortNtCs5Av9rWzHob7_3lib12AlignedEntryNCINvMB6_SBT_20sort_unstable_by_keyyNCNvBV_14aligned_lookups_0E0EBV_
	nop
.Ltmp71:
	movq	-24(%rbp), %r12
	movq	-16(%rbp), %rcx
.LBB25_26:
	testq	%rdi, %rdi
	je	.LBB25_27
	testq	%rsi, %rsi
	je	.LBB25_36
	cmpq	$1, %rsi
	jne	.LBB25_30
	movq	(%rcx), %rax
	cmpq	$1, %rdi
	jne	.LBB25_45
	xorl	%r10d, %r10d
	xorl	%r14d, %r14d
	jmp	.LBB25_52
.LBB25_27:
	xorl	%r14d, %r14d
	jmp	.LBB25_55
.LBB25_36:
	cmpq	$4, %rdi
	jae	.LBB25_38
	xorl	%eax, %eax
	xorl	%r14d, %r14d
	jmp	.LBB25_41
.LBB25_30:
	xorl	%r14d, %r14d
	xorl	%eax, %eax
	jmp	.LBB25_31
	.p2align	4
.LBB25_35:
	xorq	%r8, %r14
	incq	%rax
	cmpq	%rdi, %rax
	je	.LBB25_55
.LBB25_31:
	movq	(%rbx,%rax,8), %r15
	movq	%rsi, %r8
	xorl	%edx, %edx
	.p2align	4
.LBB25_32:
	movq	%rdx, %r9
	movq	%r8, %r10
	shrq	%r10
	addq	%r10, %rdx
	movq	%rdx, %r11
	shlq	$4, %r11
	cmpq	%r15, (%rcx,%r11)
	cmovaq	%r9, %rdx
	subq	%r10, %r8
	cmpq	$1, %r8
	ja	.LBB25_32
	shlq	$4, %rdx
	movq	$-1, %r8
	cmpq	%r15, (%rcx,%rdx)
	jne	.LBB25_35
	addq	%rcx, %rdx
	movl	8(%rdx), %r8d
	jmp	.LBB25_35
.LBB25_45:
	movabsq	$1152921504606846974, %rdx
	andq	%rdi, %rdx
	xorl	%r10d, %r10d
	xorl	%r14d, %r14d
	jmp	.LBB25_46
	.p2align	4
.LBB25_50:
	xorq	%r9, %r14
	xorq	%r8, %r14
	addq	$2, %r10
	cmpq	%r10, %rdx
	je	.LBB25_51
.LBB25_46:
	movq	$-1, %r8
	movq	$-1, %r9
	cmpq	(%rbx,%r10,8), %rax
	jne	.LBB25_48
	movl	8(%rcx), %r9d
.LBB25_48:
	cmpq	8(%rbx,%r10,8), %rax
	jne	.LBB25_50
	movl	8(%rcx), %r8d
	jmp	.LBB25_50
.LBB25_51:
	testb	$1, %dil
	je	.LBB25_55
.LBB25_52:
	movq	$-1, %rdx
	cmpq	(%rbx,%r10,8), %rax
	jne	.LBB25_54
	movl	8(%rcx), %edx
.LBB25_54:
	xorq	%rdx, %r14
	jmp	.LBB25_55
.LBB25_38:
	movabsq	$1152921504606846972, %rax
	andq	%rdi, %rax
	pxor	%xmm0, %xmm0
	pcmpeqd	%xmm2, %xmm2
	movq	%rax, %rdx
	pxor	%xmm3, %xmm3
	.p2align	4
.LBB25_39:
	movdqa	%xmm3, %xmm1
	movdqa	%xmm0, %xmm4
	pxor	%xmm2, %xmm0
	pxor	%xmm2, %xmm3
	addq	$-4, %rdx
	jne	.LBB25_39
	pxor	%xmm4, %xmm1
	pshufd	$238, %xmm1, %xmm0
	pxor	%xmm1, %xmm0
	movq	%xmm0, %r14
	cmpq	%rax, %rdi
	je	.LBB25_55
.LBB25_41:
	subq	%rax, %rdi
	.p2align	4
.LBB25_42:
	notq	%r14
	decq	%rdi
	jne	.LBB25_42
.LBB25_55:
	testq	%rsi, %rsi
	je	.LBB25_57
	movl	$8, %r8d
	movq	%r12, %rdx
	callq	_RNvCs9wFQrvczXsK_7___rustc14___rust_dealloc
.LBB25_57:
	movq	%r14, %rax
	.seh_startepilogue
	addq	$64, %rsp
	popq	%rbx
	popq	%rdi
	popq	%rsi
	popq	%r12
	popq	%r14
	popq	%r15
	popq	%rbp
	.seh_endepilogue
	retq
.LBB25_1:
	xorl	%r15d, %r15d
.LBB25_2:
	movq	%r15, %rcx
	movq	%r12, %rdx
	callq	_RNvNtCsk3xoiB9w6DV_5alloc7raw_vec12handle_error
	ud2
	.seh_handlerdata
	.long	$cppxdata$_RNvCs5Av9rWzHob7_3lib14aligned_lookup@IMGREL
	.section	.text,"xr",one_only,_RNvCs5Av9rWzHob7_3lib14aligned_lookup,unique,25
	.seh_endproc
