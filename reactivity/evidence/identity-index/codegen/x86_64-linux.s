_RNvCs5Av9rWzHob7_3lib11runs_lookup:
.Lfunc_begin5:
	.cfi_startproc
	.cfi_personality 155, DW.ref.rust_eh_personality
	.cfi_lsda 27, .Lexception5
	pushq	%rbp
	.cfi_def_cfa_offset 16
	pushq	%r15
	.cfi_def_cfa_offset 24
	pushq	%r14
	.cfi_def_cfa_offset 32
	pushq	%r13
	.cfi_def_cfa_offset 40
	pushq	%r12
	.cfi_def_cfa_offset 48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	subq	$88, %rsp
	.cfi_def_cfa_offset 144
	.cfi_offset %rbx, -56
	.cfi_offset %r12, -48
	.cfi_offset %r13, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	.cfi_offset %rbp, -16
	cmpq	$100001, %rsi
	jae	.LBB20_177
	movq	%rcx, %rbx
	movq	%rdx, %r15
	movq	%rsi, %r14
	testq	%rsi, %rsi
	je	.LBB20_2
	movq	%rdi, %r13
	movq	(%rdi), %r12
	cmpq	$1, %r14
	jne	.LBB20_5
	movl	$1, %r14d
	xorl	%ecx, %ecx
	jmp	.LBB20_101
.LBB20_2:
	xorl	%ecx, %ecx
	xorl	%r12d, %r12d
	xorl	%r14d, %r14d
	jmp	.LBB20_101
.LBB20_5:
	leaq	(,%r14,8), %rdx
	movq	8(%r13), %rcx
	movq	%r12, %r9
	incq	%r9
	sete	%al
	movq	%rcx, 8(%rsp)
	cmpq	%rcx, %r9
	setne	%cl
	orb	%al, %cl
	movzbl	%cl, %ebp
	incq	%rbp
	cmpq	$2, %r14
	movq	%rdx, 48(%rsp)
	je	.LBB20_12
	addq	$-24, %rdx
	testb	$8, %dl
	jne	.LBB20_7
	leaq	24(%r13), %rax
	movq	16(%r13), %rcx
	movq	8(%rsp), %rsi
	incq	%rsi
	sete	%dil
	cmpq	%rcx, %rsi
	setne	%sil
	orb	%dil, %sil
	movzbl	%sil, %esi
	addq	%rsi, %rbp
	testq	%rdx, %rdx
	jne	.LBB20_10
	jmp	.LBB20_12
.LBB20_7:
	leaq	16(%r13), %rax
	movq	8(%rsp), %rcx
	testq	%rdx, %rdx
	je	.LBB20_12
.LBB20_10:
	leaq	(,%r14,8), %rdx
	addq	%r13, %rdx
	.p2align	4
.LBB20_11:
	incq	%rcx
	sete	%sil
	movq	(%rax), %rdi
	cmpq	%rdi, %rcx
	movq	8(%rax), %rcx
	setne	%r8b
	orb	%sil, %r8b
	movzbl	%r8b, %esi
	addq	%rbp, %rsi
	incq	%rdi
	sete	%r8b
	cmpq	%rcx, %rdi
	setne	%dil
	orb	%r8b, %dil
	movzbl	%dil, %ebp
	addq	%rsi, %rbp
	addq	$16, %rax
	cmpq	%rdx, %rax
	jne	.LBB20_11
.LBB20_12:
	cmpq	$1, %rbp
	jne	.LBB20_14
	xorl	%ecx, %ecx
	jmp	.LBB20_101
.LBB20_14:
	movq	%rbp, %rsi
	shlq	$4, %rsi
	leaq	(,%r14,4), %rax
	leaq	(%rax,%rax,2), %rax
	cmpq	%rax, %rsi
	jae	.LBB20_15
	movabsq	$1152921504606846972, %rax
	orq	$3, %rax
	cmpq	%rax, %rbp
	jbe	.LBB20_43
	xorl	%edi, %edi
.LBB20_42:
	callq	*_RNvNtCscdodAO9FK5_5alloc7raw_vec12handle_error@GOTPCREL(%rip)
.LBB20_15:
	movq	%rax, %rbp
	callq	*_RNvCs9wFQrvczXsK_7___rustc35___rust_no_alloc_shim_is_unstable_v2@GOTPCREL(%rip)
	movl	$4, %esi
	movq	%rbp, %rdi
	callq	*_RNvCs9wFQrvczXsK_7___rustc12___rust_alloc@GOTPCREL(%rip)
	testq	%rax, %rax
	je	.LBB20_18
	movq	%rax, %r12
	movl	%r14d, %ecx
	andl	$3, %ecx
	cmpq	$4, %r14
	jae	.LBB20_19
	xorl	%eax, %eax
	jmp	.LBB20_22
.LBB20_19:
	movl	%r14d, %edx
	andl	$131068, %edx
	leaq	44(%r12), %rsi
	xorl	%eax, %eax
	.p2align	4
.LBB20_20:
	movq	(%r13,%rax,8), %rdi
	movq	%rdi, -44(%rsi)
	movl	%eax, -36(%rsi)
	movq	8(%r13,%rax,8), %rdi
	movq	%rdi, -32(%rsi)
	leal	1(%rax), %edi
	movl	%edi, -24(%rsi)
	movq	16(%r13,%rax,8), %rdi
	movq	%rdi, -20(%rsi)
	leal	2(%rax), %edi
	movl	%edi, -12(%rsi)
	movq	24(%r13,%rax,8), %rdi
	movq	%rdi, -8(%rsi)
	leal	3(%rax), %edi
	movl	%edi, (%rsi)
	addq	$4, %rax
	addq	$48, %rsi
	cmpq	%rdx, %rax
	jne	.LBB20_20
	testq	%rcx, %rcx
	je	.LBB20_24
.LBB20_22:
	leaq	(%rax,%rax,2), %rdx
	leaq	(%r12,%rdx,4), %rdx
	addq	$8, %rdx
	shll	$2, %ecx
	leaq	(%rcx,%rcx,2), %rcx
	xorl	%esi, %esi
	.p2align	4
.LBB20_23:
	movq	(%r13,%rax,8), %rdi
	movq	%rdi, -8(%rdx,%rsi)
	movl	%eax, (%rdx,%rsi)
	incq	%rax
	addq	$12, %rsi
	cmpq	%rsi, %rcx
	jne	.LBB20_23
.LBB20_24:
	cmpq	$21, %r14
	jae	.LBB20_25
	leaq	(%r12,%rbp), %rax
	leaq	12(%r12), %rsi
	movl	$12, %ecx
	movq	%r12, %rdi
	jmp	.LBB20_32
	.p2align	4
.LBB20_35:
	movq	%r12, %r9
.LBB20_38:
	movq	%rsi, (%r9)
	movl	%edi, 8(%r9)
.LBB20_39:
	leaq	12(%rdx), %rsi
	addq	$12, %rcx
	movq	%rdx, %rdi
	cmpq	%rax, %rsi
	je	.LBB20_26
.LBB20_32:
	movq	%rsi, %rdx
	movq	12(%rdi), %rsi
	cmpq	(%rdi), %rsi
	jae	.LBB20_39
	movl	20(%rdi), %edi
	movq	%rcx, %r8
	.p2align	4
.LBB20_34:
	movl	-4(%r12,%r8), %r9d
	movl	%r9d, 8(%r12,%r8)
	movq	-12(%r12,%r8), %r9
	movq	%r9, (%r12,%r8)
	cmpq	$12, %r8
	je	.LBB20_35
	leaq	-12(%r8), %r9
	cmpq	-24(%r12,%r8), %rsi
	movq	%r9, %r8
	jb	.LBB20_34
	addq	%r12, %r9
	jmp	.LBB20_38
.LBB20_43:
	movq	$0, 40(%rsp)
	testq	%rsi, %rsi
	je	.LBB20_44
	movq	%r9, 64(%rsp)
	movq	%rsi, 56(%rsp)
	callq	*_RNvCs9wFQrvczXsK_7___rustc35___rust_no_alloc_shim_is_unstable_v2@GOTPCREL(%rip)
	movl	$8, %esi
	movq	56(%rsp), %rdi
	callq	*_RNvCs9wFQrvczXsK_7___rustc12___rust_alloc@GOTPCREL(%rip)
	movl	$8, %edi
	movq	56(%rsp), %rsi
	testq	%rax, %rax
	je	.LBB20_42
	movq	64(%rsp), %r9
	jmp	.LBB20_47
.LBB20_44:
	movl	$8, %eax
	xorl	%ebp, %ebp
.LBB20_47:
	movq	%rbp, 16(%rsp)
	movq	%rax, 24(%rsp)
	movq	$0, 32(%rsp)
	cmpq	$-1, %r12
	setne	%cl
	cmpq	8(%rsp), %r9
	sete	%dl
	testb	%dl, %cl
	movq	%r15, 72(%rsp)
	jne	.LBB20_48
	testq	%rbp, %rbp
	jne	.LBB20_55
.Ltmp20:
	leaq	16(%rsp), %rdi
	callq	*_RNvMs3_NtCscdodAO9FK5_5alloc7raw_vecINtB5_6RawVecNtNtCs5Av9rWzHob7_3lib10runs_index3RunE8grow_oneBP_@GOTPCREL(%rip)
.Ltmp21:
	movq	24(%rsp), %rax
.LBB20_55:
	movq	%r12, (%rax)
	movabsq	$4294967296, %rcx
	movq	%rcx, 8(%rax)
	movq	$1, 32(%rsp)
	movl	$1, %ecx
	movq	%rcx, 40(%rsp)
	movl	$1, %ecx
	movl	$1, %edx
	movq	8(%rsp), %r12
	jmp	.LBB20_56
.LBB20_48:
	movl	$2, %edx
	xorl	%ecx, %ecx
.LBB20_56:
	cmpq	$2, %r14
	movq	48(%rsp), %r15
	jne	.LBB20_65
	movq	%rcx, %r14
	movl	%edx, %ecx
	jmp	.LBB20_58
.LBB20_65:
	movq	%r12, 8(%rsp)
	addq	$-16, %r15
	movl	$2, %ebp
	movq	%rcx, %r14
	movl	%edx, %ecx
	jmp	.LBB20_66
.LBB20_69:
	movq	24(%rsp), %rax
.LBB20_70:
	movq	%r14, %rcx
	shlq	$4, %rcx
	movq	8(%rsp), %rdx
	movq	%rdx, (%rax,%rcx)
	movq	40(%rsp), %rdx
	movl	%edx, 8(%rax,%rcx)
	movl	48(%rsp), %edx
	movl	%edx, 12(%rax,%rcx)
	incq	%r14
	movq	%r14, 32(%rsp)
	movl	%ebp, %ecx
	movq	%rcx, 40(%rsp)
	movl	$1, %ecx
	movq	%r12, 8(%rsp)
	incq	%rbp
	addq	$-8, %r15
	je	.LBB20_58
.LBB20_66:
	movq	(%r13,%rbp,8), %r12
	movl	%ecx, %edi
	movl	%ecx, %ecx
	movq	8(%rsp), %rsi
	addq	%rsi, %rcx
	cmpq	%rsi, %rcx
	setae	%dl
	cmpq	%r12, %rcx
	sete	%cl
	testb	%cl, %dl
	jne	.LBB20_93
	movl	%edi, 48(%rsp)
	cmpq	16(%rsp), %r14
	jne	.LBB20_70
.Ltmp23:
	leaq	16(%rsp), %rdi
	callq	*_RNvMs3_NtCscdodAO9FK5_5alloc7raw_vecINtB5_6RawVecNtNtCs5Av9rWzHob7_3lib10runs_index3RunE8grow_oneBP_@GOTPCREL(%rip)
.Ltmp24:
	jmp	.LBB20_69
	.p2align	4
.LBB20_93:
	incl	%edi
	movq	%rsi, %r12
	movl	%edi, %ecx
	incq	%rbp
	addq	$-8, %r15
	jne	.LBB20_66
.LBB20_58:
	movl	%ecx, %ebp
	cmpq	16(%rsp), %r14
	movq	72(%rsp), %r15
	jne	.LBB20_60
.Ltmp26:
	leaq	16(%rsp), %rdi
	callq	*_RNvMs3_NtCscdodAO9FK5_5alloc7raw_vecINtB5_6RawVecNtNtCs5Av9rWzHob7_3lib10runs_index3RunE8grow_oneBP_@GOTPCREL(%rip)
.Ltmp27:
.LBB20_60:
	movq	24(%rsp), %r13
	movq	%r14, %rax
	shlq	$4, %rax
	movq	%r12, (%r13,%rax)
	movq	40(%rsp), %rcx
	movl	%ecx, 8(%r13,%rax)
	movl	%ebp, 12(%r13,%rax)
	incq	%r14
	movq	%r14, 32(%rsp)
	cmpq	$2, %r14
	jae	.LBB20_61
.LBB20_81:
	leaq	16(%r13), %rax
	leaq	1(%r14), %rcx
	.p2align	4
.LBB20_82:
	decq	%rcx
	cmpq	$2, %rcx
	jb	.LBB20_86
	movq	(%rax), %rdx
	subq	-16(%rax), %rdx
	jb	.LBB20_85
	movl	-4(%rax), %esi
	addq	$16, %rax
	cmpq	%rsi, %rdx
	jae	.LBB20_82
.LBB20_85:
.Ltmp30:
	leaq	.Lanon.843556a994c423e327e8a0cd8c96d9c8.5(%rip), %rdi
	leaq	.Lanon.843556a994c423e327e8a0cd8c96d9c8.7(%rip), %rdx
	movl	$73, %esi
	callq	*_RNvNtCs4NRVxsYgnAr_4core9panicking9panic_fmt@GOTPCREL(%rip)
.Ltmp31:
	jmp	.LBB20_30
.LBB20_86:
	movq	16(%rsp), %rbp
	cmpq	%r14, %rbp
	jbe	.LBB20_87
	shlq	$4, %rbp
	testq	%r14, %r14
	je	.LBB20_89
	movq	%r14, %rcx
	shlq	$4, %rcx
	movl	$8, %edx
	movq	%r13, %rdi
	movq	%rbp, %rsi
	movq	%rcx, 8(%rsp)
	callq	*_RNvCs9wFQrvczXsK_7___rustc14___rust_realloc@GOTPCREL(%rip)
	movq	%rax, %r12
	testq	%rax, %rax
	jne	.LBB20_90
.Ltmp33:
	movl	$8, %edi
	movq	8(%rsp), %rsi
	callq	*_RNvNtCscdodAO9FK5_5alloc7raw_vec12handle_error@GOTPCREL(%rip)
.Ltmp34:
	jmp	.LBB20_30
.LBB20_87:
	movq	%r13, %r12
	movl	$1, %ecx
	jmp	.LBB20_101
.LBB20_89:
	movl	$8, %r12d
	movl	$8, %edx
	movq	%r13, %rdi
	movq	%rbp, %rsi
	callq	*_RNvCs9wFQrvczXsK_7___rustc14___rust_dealloc@GOTPCREL(%rip)
.LBB20_90:
	movl	$1, %ecx
	jmp	.LBB20_101
.LBB20_177:
	leaq	.Lanon.843556a994c423e327e8a0cd8c96d9c8.2(%rip), %rdi
	leaq	.Lanon.843556a994c423e327e8a0cd8c96d9c8.4(%rip), %rdx
	movl	$63, %esi
	callq	*_RNvNtCs4NRVxsYgnAr_4core9panicking9panic_fmt@GOTPCREL(%rip)
.LBB20_25:
.Ltmp15:
	leaq	16(%rsp), %rdx
	movq	%r12, %rdi
	movq	%r14, %rsi
	callq	*_RINvNtNtNtCs4NRVxsYgnAr_4core5slice4sort8unstable7ipnsortNtNtCs5Av9rWzHob7_3lib10runs_index5EntryNCINvMB6_SBT_20sort_unstable_by_keyyNCINvMs_BV_NtBV_13IdentityIndex8from_idsINtNtNtNtB8_4iter8adapters6copied6CopiedINtNtB6_4iter4IteryEEEs0_0E0EBX_@GOTPCREL(%rip)
.Ltmp16:
.LBB20_26:
	leaq	1(%r14), %rax
	movq	%r12, %rcx
	.p2align	4
.LBB20_27:
	decq	%rax
	cmpq	$2, %rax
	jb	.LBB20_100
	movq	(%rcx), %rdx
	cmpq	12(%rcx), %rdx
	leaq	12(%rcx), %rcx
	jne	.LBB20_27
.Ltmp17:
	leaq	.Lanon.843556a994c423e327e8a0cd8c96d9c8.5(%rip), %rdi
	leaq	.Lanon.843556a994c423e327e8a0cd8c96d9c8.6(%rip), %rdx
	movl	$73, %esi
	callq	*_RNvNtCs4NRVxsYgnAr_4core9panicking9panic_fmt@GOTPCREL(%rip)
.Ltmp18:
.LBB20_30:
	ud2
.LBB20_100:
	movl	$2, %ecx
.LBB20_101:
	testq	%rbx, %rbx
	je	.LBB20_102
	cmpl	$2, %ecx
	je	.LBB20_142
	cmpl	$1, %ecx
	jne	.LBB20_105
	testq	%r14, %r14
	je	.LBB20_120
	cmpq	$1, %r14
	jne	.LBB20_113
	movq	(%r12), %rdx
	cmpq	$1, %rbx
	jne	.LBB20_129
	xorl	%esi, %esi
	xorl	%eax, %eax
	jmp	.LBB20_138
.LBB20_102:
	xorl	%eax, %eax
.LBB20_169:
	testq	%rcx, %rcx
	je	.LBB20_176
	cmpl	$1, %ecx
	jne	.LBB20_171
	testq	%r14, %r14
	je	.LBB20_176
	shlq	$4, %r14
	movl	$8, %edx
	movq	%r12, %rdi
	movq	%r14, %rsi
	jmp	.LBB20_175
.LBB20_171:
	testq	%r14, %r14
	je	.LBB20_176
	shlq	$2, %r14
	leaq	(%r14,%r14,2), %rsi
	movl	$4, %edx
	movq	%r12, %rdi
.LBB20_175:
	movq	%rax, %rbx
	callq	*_RNvCs9wFQrvczXsK_7___rustc14___rust_dealloc@GOTPCREL(%rip)
	movq	%rbx, %rax
	jmp	.LBB20_176
.LBB20_142:
	testq	%r14, %r14
	je	.LBB20_150
	cmpq	$1, %r14
	jne	.LBB20_144
	movq	(%r12), %rdx
	cmpq	$1, %rbx
	jne	.LBB20_159
	xorl	%esi, %esi
	xorl	%eax, %eax
	jmp	.LBB20_166
.LBB20_105:
	movl	%ebx, %eax
	subl	%ecx, %eax
	leaq	1(%rcx), %rsi
	testb	$1, %al
	jne	.LBB20_107
	movq	%rcx, %rdx
	cmpq	%rsi, %rbx
	jne	.LBB20_109
	jmp	.LBB20_176
.LBB20_107:
	movq	(%r15,%rcx,8), %rdx
	movq	%rdx, %rax
	subq	%r12, %rax
	cmpq	%r14, %rax
	movq	$-1, %rdi
	cmovaeq	%rdi, %rax
	cmpq	%r12, %rdx
	cmovbq	%rdi, %rax
	xorq	%rcx, %rax
	movq	%rsi, %rcx
	movq	%rax, %rdx
	cmpq	%rsi, %rbx
	je	.LBB20_176
.LBB20_109:
	movq	$-1, %rsi
	.p2align	4
.LBB20_110:
	movq	(%r15,%rcx,8), %rdi
	movq	8(%r15,%rcx,8), %rax
	movq	%rax, %r8
	subq	%r12, %r8
	cmpq	%r14, %r8
	cmovaeq	%rsi, %r8
	cmpq	%r12, %rax
	cmovbq	%rsi, %r8
	movq	%rdi, %rax
	subq	%r12, %rax
	cmpq	%r14, %rax
	cmovaeq	%rsi, %rax
	cmpq	%r12, %rdi
	cmovbq	%rsi, %rax
	xorq	%rdx, %rax
	xorq	%r8, %rax
	addq	$2, %rcx
	movq	%rax, %rdx
	cmpq	%rcx, %rbx
	jne	.LBB20_110
	jmp	.LBB20_176
.LBB20_120:
	cmpq	$4, %rbx
	jae	.LBB20_122
	xorl	%ecx, %ecx
	xorl	%eax, %eax
	jmp	.LBB20_125
.LBB20_150:
	cmpq	$4, %rbx
	jae	.LBB20_152
	xorl	%ecx, %ecx
	xorl	%eax, %eax
	jmp	.LBB20_155
.LBB20_113:
	xorl	%eax, %eax
	xorl	%edx, %edx
	jmp	.LBB20_114
	.p2align	4
.LBB20_119:
	xorq	%r9, %rax
	incq	%rdx
	cmpq	%rbx, %rdx
	je	.LBB20_169
.LBB20_114:
	movq	(%r15,%rdx,8), %rsi
	movq	%r14, %r8
	xorl	%edi, %edi
	.p2align	4
.LBB20_115:
	movq	%rdi, %r9
	movq	%r8, %r10
	shrq	%r10
	addq	%r10, %rdi
	movq	%rdi, %r11
	shlq	$4, %r11
	cmpq	%rsi, (%r12,%r11)
	cmovaq	%r9, %rdi
	subq	%r10, %r8
	cmpq	$1, %r8
	ja	.LBB20_115
	movq	%rdi, %r9
	shlq	$4, %r9
	xorl	%r8d, %r8d
	cmpq	%rsi, (%r12,%r9)
	setbe	%r8b
	movq	$-1, %r9
	addq	%rdi, %r8
	je	.LBB20_119
	shlq	$4, %r8
	subq	-16(%r12,%r8), %rsi
	movl	-4(%r12,%r8), %edi
	cmpq	%rdi, %rsi
	jae	.LBB20_119
	addq	%r12, %r8
	movl	-8(%r8), %edi
	addq	%rdi, %rsi
	movq	%rsi, %r9
	jmp	.LBB20_119
.LBB20_144:
	xorl	%eax, %eax
	xorl	%edx, %edx
	jmp	.LBB20_145
	.p2align	4
.LBB20_149:
	xorq	%rdi, %rax
	incq	%rdx
	cmpq	%rbx, %rdx
	je	.LBB20_169
.LBB20_145:
	movq	(%r15,%rdx,8), %rsi
	movq	%r14, %rdi
	xorl	%r8d, %r8d
	.p2align	4
.LBB20_146:
	movq	%r8, %r9
	movq	%rdi, %r10
	shrq	%r10
	addq	%r10, %r8
	leaq	(%r8,%r8,2), %r11
	cmpq	%rsi, (%r12,%r11,4)
	cmovaq	%r9, %r8
	subq	%r10, %rdi
	cmpq	$1, %rdi
	ja	.LBB20_146
	leaq	(%r8,%r8,2), %r8
	movq	$-1, %rdi
	cmpq	%rsi, (%r12,%r8,4)
	jne	.LBB20_149
	leaq	(%r12,%r8,4), %rsi
	movl	8(%rsi), %edi
	jmp	.LBB20_149
.LBB20_129:
	movabsq	$1152921504606846972, %rdi
	orq	$2, %rdi
	andq	%rbx, %rdi
	xorl	%esi, %esi
	xorl	%eax, %eax
	jmp	.LBB20_130
	.p2align	4
.LBB20_136:
	xorq	%r9, %rax
	xorq	%r8, %rax
	addq	$2, %rsi
	cmpq	%rsi, %rdi
	je	.LBB20_137
.LBB20_130:
	movq	(%r15,%rsi,8), %r10
	movq	$-1, %r8
	movq	$-1, %r9
	subq	%rdx, %r10
	jb	.LBB20_133
	movl	12(%r12), %r11d
	cmpq	%r11, %r10
	jae	.LBB20_133
	movl	8(%r12), %r9d
	addq	%r9, %r10
	movq	%r10, %r9
.LBB20_133:
	movq	8(%r15,%rsi,8), %r10
	subq	%rdx, %r10
	jb	.LBB20_136
	movl	12(%r12), %r11d
	cmpq	%r11, %r10
	jae	.LBB20_136
	movl	8(%r12), %r8d
	addq	%r8, %r10
	movq	%r10, %r8
	jmp	.LBB20_136
.LBB20_137:
	testb	$1, %bl
	je	.LBB20_169
.LBB20_138:
	movq	(%r15,%rsi,8), %rdi
	movq	$-1, %rsi
	subq	%rdx, %rdi
	jb	.LBB20_141
	movl	12(%r12), %edx
	cmpq	%rdx, %rdi
	jae	.LBB20_141
	movl	8(%r12), %edx
	addq	%rdx, %rdi
	movq	%rdi, %rsi
.LBB20_141:
	xorq	%rsi, %rax
	jmp	.LBB20_169
.LBB20_159:
	movabsq	$1152921504606846972, %rdi
	orq	$2, %rdi
	andq	%rbx, %rdi
	xorl	%esi, %esi
	xorl	%eax, %eax
	jmp	.LBB20_160
	.p2align	4
.LBB20_164:
	xorq	%r9, %rax
	xorq	%r8, %rax
	addq	$2, %rsi
	cmpq	%rsi, %rdi
	je	.LBB20_165
.LBB20_160:
	movq	$-1, %r8
	movq	$-1, %r9
	cmpq	(%r15,%rsi,8), %rdx
	jne	.LBB20_162
	movl	8(%r12), %r9d
.LBB20_162:
	cmpq	8(%r15,%rsi,8), %rdx
	jne	.LBB20_164
	movl	8(%r12), %r8d
	jmp	.LBB20_164
.LBB20_122:
	movabsq	$1152921504606846972, %rcx
	andq	%rbx, %rcx
	pxor	%xmm0, %xmm0
	pcmpeqd	%xmm2, %xmm2
	movq	%rcx, %rax
	pxor	%xmm3, %xmm3
	.p2align	4
.LBB20_123:
	movdqa	%xmm3, %xmm1
	movdqa	%xmm0, %xmm4
	pxor	%xmm2, %xmm0
	pxor	%xmm2, %xmm3
	addq	$-4, %rax
	jne	.LBB20_123
	pxor	%xmm4, %xmm1
	pshufd	$238, %xmm1, %xmm0
	pxor	%xmm1, %xmm0
	movq	%xmm0, %rax
	cmpq	%rcx, %rbx
	je	.LBB20_176
.LBB20_125:
	subq	%rcx, %rbx
	.p2align	4
.LBB20_126:
	notq	%rax
	decq	%rbx
	jne	.LBB20_126
	jmp	.LBB20_176
.LBB20_165:
	testb	$1, %bl
	je	.LBB20_169
.LBB20_166:
	movq	$-1, %rdi
	cmpq	(%r15,%rsi,8), %rdx
	jne	.LBB20_168
	movl	8(%r12), %edi
.LBB20_168:
	xorq	%rdi, %rax
	jmp	.LBB20_169
.LBB20_152:
	movabsq	$1152921504606846972, %rcx
	andq	%rbx, %rcx
	pxor	%xmm0, %xmm0
	pcmpeqd	%xmm2, %xmm2
	movq	%rcx, %rax
	pxor	%xmm3, %xmm3
	.p2align	4
.LBB20_153:
	movdqa	%xmm3, %xmm1
	movdqa	%xmm0, %xmm4
	pxor	%xmm2, %xmm0
	pxor	%xmm2, %xmm3
	addq	$-4, %rax
	jne	.LBB20_153
	pxor	%xmm4, %xmm1
	pshufd	$238, %xmm1, %xmm0
	pxor	%xmm1, %xmm0
	movq	%xmm0, %rax
	cmpq	%rcx, %rbx
	je	.LBB20_176
.LBB20_155:
	subq	%rcx, %rbx
	.p2align	4
.LBB20_156:
	notq	%rax
	decq	%rbx
	jne	.LBB20_156
.LBB20_176:
	addq	$88, %rsp
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%r12
	.cfi_def_cfa_offset 40
	popq	%r13
	.cfi_def_cfa_offset 32
	popq	%r14
	.cfi_def_cfa_offset 24
	popq	%r15
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	retq
.LBB20_61:
	.cfi_def_cfa_offset 144
	cmpq	$21, %r14
	jae	.LBB20_62
	shlq	$4, %r14
	addq	%r13, %r14
	leaq	16(%r13), %rdx
	movl	$16, %eax
	movq	%r13, %rsi
	jmp	.LBB20_72
.LBB20_75:
	movq	%r13, %rdi
.LBB20_78:
	movq	%rdx, (%rdi)
	movq	%rsi, 8(%rdi)
.LBB20_79:
	leaq	16(%rcx), %rdx
	addq	$16, %rax
	movq	%rcx, %rsi
	cmpq	%r14, %rdx
	je	.LBB20_80
.LBB20_72:
	movq	%rdx, %rcx
	movq	16(%rsi), %rdx
	cmpq	(%rsi), %rdx
	jae	.LBB20_79
	movq	24(%rsi), %rsi
	movq	%rax, %r8
.LBB20_74:
	movdqu	-16(%r13,%r8), %xmm0
	movdqu	%xmm0, (%r13,%r8)
	cmpq	$16, %r8
	je	.LBB20_75
	leaq	-16(%r8), %rdi
	cmpq	-32(%r13,%r8), %rdx
	movq	%rdi, %r8
	jb	.LBB20_74
	addq	%r13, %rdi
	jmp	.LBB20_78
.LBB20_80:
	movq	24(%rsp), %r13
	movq	32(%rsp), %r14
	jmp	.LBB20_81
.LBB20_18:
	movl	$4, %edi
	movq	%rbp, %rsi
	callq	*_RNvNtCscdodAO9FK5_5alloc7raw_vec12handle_error@GOTPCREL(%rip)
.LBB20_62:
.Ltmp28:
	leaq	80(%rsp), %rdx
	movq	%r13, %rdi
	movq	%r14, %rsi
	callq	*_RINvNtNtNtCs4NRVxsYgnAr_4core5slice4sort8unstable7ipnsortNtNtCs5Av9rWzHob7_3lib10runs_index3RunNCINvMB6_SBT_20sort_unstable_by_keyyNCINvMs_BV_NtBV_13IdentityIndex8from_idsINtNtNtNtB8_4iter8adapters6copied6CopiedINtNtB6_4iter4IteryEEE0E0EBX_@GOTPCREL(%rip)
.Ltmp29:
	jmp	.LBB20_81
.LBB20_64:
.Ltmp22:
	jmp	.LBB20_96
.LBB20_51:
.Ltmp35:
	movq	%rax, %rbx
	movl	$8, %edx
	movq	%r13, %rdi
	movq	%rbp, %rsi
	jmp	.LBB20_98
.LBB20_63:
.Ltmp25:
	jmp	.LBB20_96
.LBB20_49:
.Ltmp19:
	movq	%rax, %rbx
	movl	$4, %edx
	movq	%r12, %rdi
	movq	%rbp, %rsi
	jmp	.LBB20_98
.LBB20_95:
.Ltmp32:
.LBB20_96:
	movq	%rax, %rbx
	movq	16(%rsp), %rsi
	testq	%rsi, %rsi
	je	.LBB20_99
	movq	24(%rsp), %rdi
	shlq	$4, %rsi
	movl	$8, %edx
.LBB20_98:
	callq	*_RNvCs9wFQrvczXsK_7___rustc14___rust_dealloc@GOTPCREL(%rip)
.LBB20_99:
	movq	%rbx, %rdi
	callq	_Unwind_Resume@PLT
.Lfunc_end20:
	.size	_RNvCs5Av9rWzHob7_3lib11runs_lookup, .Lfunc_end20-_RNvCs5Av9rWzHob7_3lib11runs_lookup
	.cfi_endproc

_RNvCs5Av9rWzHob7_3lib11tree_lookup:
.Lfunc_begin6:
	.cfi_startproc
	.cfi_personality 155, DW.ref.rust_eh_personality
	.cfi_lsda 27, .Lexception6
	pushq	%rbp
	.cfi_def_cfa_offset 16
	pushq	%r15
	.cfi_def_cfa_offset 24
	pushq	%r14
	.cfi_def_cfa_offset 32
	pushq	%r13
	.cfi_def_cfa_offset 40
	pushq	%r12
	.cfi_def_cfa_offset 48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	subq	$200, %rsp
	.cfi_def_cfa_offset 256
	.cfi_offset %rbx, -56
	.cfi_offset %r12, -48
	.cfi_offset %r13, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	.cfi_offset %rbp, -16
	movabsq	$576460752303423484, %rbx
	movq	%rsi, %r13
	shlq	$4, %r13
	leaq	3(%rbx), %rax
	cmpq	%rax, %rsi
	jbe	.LBB21_3
	xorl	%r14d, %r14d
.LBB21_2:
	movq	%r14, %rdi
	movq	%r13, %rsi
	callq	*_RNvNtCscdodAO9FK5_5alloc7raw_vec12handle_error@GOTPCREL(%rip)
.LBB21_3:
	testq	%rsi, %rsi
	je	.LBB21_93
	movq	%rdx, 88(%rsp)
	movq	%rcx, 96(%rsp)
	movq	%rdi, %r15
	movq	%rsi, %r12
	callq	*_RNvCs9wFQrvczXsK_7___rustc35___rust_no_alloc_shim_is_unstable_v2@GOTPCREL(%rip)
	movl	$8, %r14d
	movl	$8, %esi
	movq	%r13, %rdi
	callq	*_RNvCs9wFQrvczXsK_7___rustc12___rust_alloc@GOTPCREL(%rip)
	testq	%rax, %rax
	je	.LBB21_2
	movq	%rax, %rbp
	movq	%r12, %rsi
	movl	%esi, %eax
	andl	$3, %eax
	cmpq	$4, %r12
	movq	%r15, %rcx
	jae	.LBB21_7
	xorl	%edx, %edx
	jmp	.LBB21_10
.LBB21_93:
	testq	%rcx, %rcx
	jne	.LBB21_101
	xorl	%r15d, %r15d
	jmp	.LBB21_108
.LBB21_7:
	andq	%rsi, %rbx
	leaq	56(%rbp), %rdi
	xorl	%edx, %edx
	.p2align	4
.LBB21_8:
	movq	(%rcx,%rdx,8), %r8
	movq	%r8, -56(%rdi)
	movq	%rdx, -48(%rdi)
	movq	8(%rcx,%rdx,8), %r8
	movq	%r8, -40(%rdi)
	leaq	1(%rdx), %r8
	movq	%r8, -32(%rdi)
	movq	16(%rcx,%rdx,8), %r8
	movq	%r8, -24(%rdi)
	leaq	2(%rdx), %r8
	movq	%r8, -16(%rdi)
	movq	24(%rcx,%rdx,8), %r8
	movq	%r8, -8(%rdi)
	leaq	3(%rdx), %r8
	movq	%r8, (%rdi)
	addq	$4, %rdx
	addq	$64, %rdi
	cmpq	%rbx, %rdx
	jne	.LBB21_8
	testq	%rax, %rax
	je	.LBB21_12
.LBB21_10:
	movq	%rdx, %rdi
	shlq	$4, %rdi
	addq	%rbp, %rdi
	addq	$8, %rdi
	shll	$4, %eax
	xorl	%r8d, %r8d
	.p2align	4
.LBB21_11:
	movq	(%rcx,%rdx,8), %r9
	movq	%r9, -8(%rdi,%r8)
	movq	%rdx, (%rdi,%r8)
	incq	%rdx
	addq	$16, %r8
	cmpq	%r8, %rax
	jne	.LBB21_11
.LBB21_12:
	cmpq	$1, %rsi
	jne	.LBB21_13
.LBB21_24:
	callq	*_RNvCs9wFQrvczXsK_7___rustc35___rust_no_alloc_shim_is_unstable_v2@GOTPCREL(%rip)
	movl	$192, %edi
	movl	$8, %esi
	callq	*_RNvCs9wFQrvczXsK_7___rustc12___rust_alloc@GOTPCREL(%rip)
	testq	%rax, %rax
	je	.LBB21_25
	movq	$0, (%rax)
	movw	$0, 186(%rax)
	movq	%rbp, %rsi
	movq	%r13, 80(%rsp)
	addq	%r13, %rsi
	movl	$2, %edi
	xorl	%edx, %edx
	xorl	%r14d, %r14d
	movq	%rbp, 72(%rsp)
	movq	%rbp, %rbx
	movq	%rax, %rbp
	movq	%rax, %r13
	movq	%rsi, 48(%rsp)
	jmp	.LBB21_28
	.p2align	4
.LBB21_88:
	leal	1(%rax), %ecx
	movw	%cx, 186(%rbp)
	movq	%r10, 8(%rbp,%rax,8)
	movq	%r15, 96(%rbp,%rax,8)
	incq	%rdx
.LBB21_28:
	cmpq	$2, %rdi
	je	.LBB21_34
	movq	%r9, %r10
	testq	%rdi, %rdi
	je	.LBB21_30
	cmpq	%rsi, %rbx
	je	.LBB21_37
.LBB21_38:
	leaq	16(%rbx), %rax
	movq	(%rbx), %r9
	movq	8(%rbx), %rcx
	movl	$1, %edi
	cmpq	%r9, %r10
	jne	.LBB21_39
	cmpq	%rsi, %rax
	je	.LBB21_41
	leaq	32(%rbx), %rax
	movq	16(%rbx), %r9
	movq	24(%rbx), %r8
	cmpq	%r9, %r10
	jne	.LBB21_43
	.p2align	4
.LBB21_44:
	movq	%r8, %r15
	cmpq	%rsi, %rax
	je	.LBB21_45
	leaq	16(%rax), %rbx
	movq	(%rax), %r9
	movq	8(%rax), %r8
	movq	%rbx, %rax
	cmpq	%r9, %r10
	je	.LBB21_44
	jmp	.LBB21_47
	.p2align	4
.LBB21_34:
	cmpq	%rsi, %rbx
	je	.LBB21_30
	movq	(%rbx), %r10
	movq	8(%rbx), %r8
	addq	$16, %rbx
	cmpq	%rsi, %rbx
	jne	.LBB21_38
.LBB21_37:
	movq	%r8, %r15
	jmp	.LBB21_45
	.p2align	4
.LBB21_39:
	movq	%r8, %r15
	movq	%rcx, %r8
	movq	%rax, %rbx
	movzwl	186(%rbp), %eax
	cmpq	$11, %rax
	jb	.LBB21_88
	jmp	.LBB21_48
.LBB21_41:
	movq	%rcx, %r15
.LBB21_45:
	xorl	%edi, %edi
	xorl	%r9d, %r9d
	xorl	%r8d, %r8d
	movq	%rsi, %rbx
.LBB21_47:
	movzwl	186(%rbp), %eax
	cmpq	$11, %rax
	jb	.LBB21_88
.LBB21_48:
	xorl	%r12d, %r12d
	movq	%rdx, 40(%rsp)
	movq	%rdi, (%rsp)
	movq	%r8, 32(%rsp)
	movq	%r9, 24(%rsp)
	movq	%r10, 64(%rsp)
	.p2align	4
.LBB21_49:
	movq	(%rbp), %rbp
	testq	%rbp, %rbp
	je	.LBB21_60
	incq	%r12
	cmpw	$11, 186(%rbp)
	jae	.LBB21_49
	movq	%r13, 8(%rsp)
	jmp	.LBB21_67
	.p2align	4
.LBB21_60:
	callq	*_RNvCs9wFQrvczXsK_7___rustc35___rust_no_alloc_shim_is_unstable_v2@GOTPCREL(%rip)
	movl	$288, %edi
	movl	$8, %esi
	callq	*_RNvCs9wFQrvczXsK_7___rustc12___rust_alloc@GOTPCREL(%rip)
	testq	%rax, %rax
	je	.LBB21_61
	movq	%rax, %rbp
	movq	$0, (%rax)
	movw	$0, 186(%rax)
	movq	%r13, 192(%rax)
	incq	%r14
	je	.LBB21_63
	movq	%rbp, (%r13)
	movw	$0, 184(%r13)
	movq	%rbp, 8(%rsp)
	movq	%r14, %r12
.LBB21_67:
	callq	*_RNvCs9wFQrvczXsK_7___rustc35___rust_no_alloc_shim_is_unstable_v2@GOTPCREL(%rip)
	movl	$192, %edi
	movl	$8, %esi
	callq	*_RNvCs9wFQrvczXsK_7___rustc12___rust_alloc@GOTPCREL(%rip)
	testq	%rax, %rax
	je	.LBB21_68
	movq	%rax, %r13
	movq	%r14, 16(%rsp)
	movq	%r12, %r14
	movq	$0, (%rax)
	movw	$0, 186(%rax)
	decq	%r14
	je	.LBB21_71
	.p2align	4
.LBB21_84:
	callq	*_RNvCs9wFQrvczXsK_7___rustc35___rust_no_alloc_shim_is_unstable_v2@GOTPCREL(%rip)
	movl	$288, %edi
	movl	$8, %esi
	callq	*_RNvCs9wFQrvczXsK_7___rustc12___rust_alloc@GOTPCREL(%rip)
	testq	%rax, %rax
	je	.LBB21_85
	movq	$0, (%rax)
	movw	$0, 186(%rax)
	movq	%r13, 192(%rax)
	movq	%rax, (%r13)
	movw	$0, 184(%r13)
	movq	%rax, %r13
	decq	%r14
	jne	.LBB21_84
.LBB21_71:
	movzwl	186(%rbp), %eax
	cmpq	$11, %rax
	jae	.LBB21_72
	leal	1(%rax), %ecx
	movw	%cx, 186(%rbp)
	movq	64(%rsp), %rcx
	movq	%rcx, 8(%rbp,%rax,8)
	movq	%r15, 96(%rbp,%rax,8)
	movq	%r13, 200(%rbp,%rax,8)
	incq	%rax
	movq	%rbp, (%r13)
	movw	%ax, 184(%r13)
	testq	%r12, %r12
	je	.LBB21_74
	movq	%r12, %rax
	andq	$7, %rax
	movq	16(%rsp), %r14
	movq	48(%rsp), %rsi
	movq	(%rsp), %rdi
	movq	32(%rsp), %r8
	movq	24(%rsp), %r9
	je	.LBB21_76
	xorl	%ecx, %ecx
	.p2align	4
.LBB21_78:
	movzwl	186(%rbp), %edx
	movq	192(%rbp,%rdx,8), %rbp
	incq	%rcx
	cmpq	%rcx, %rax
	jne	.LBB21_78
	movq	%r12, %rax
	subq	%rcx, %rax
	cmpq	$8, %r12
	jb	.LBB21_82
	.p2align	4
.LBB21_81:
	movzwl	186(%rbp), %ecx
	movq	192(%rbp,%rcx,8), %rcx
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
	movq	192(%rcx,%rdx,8), %rbp
	addq	$-8, %rax
	jne	.LBB21_81
.LBB21_82:
	movq	8(%rsp), %r13
	movq	40(%rsp), %rdx
	incq	%rdx
	jmp	.LBB21_28
.LBB21_74:
	movq	8(%rsp), %r13
	movq	40(%rsp), %rdx
	movq	16(%rsp), %r14
	movq	48(%rsp), %rsi
	movq	(%rsp), %rdi
	movq	32(%rsp), %r8
	movq	24(%rsp), %r9
	incq	%rdx
	jmp	.LBB21_28
.LBB21_76:
	movq	%r12, %rax
	cmpq	$8, %r12
	jae	.LBB21_81
	jmp	.LBB21_82
.LBB21_43:
	movq	%rcx, %r15
	movq	%rax, %rbx
	movzwl	186(%rbp), %eax
	cmpq	$11, %rax
	jb	.LBB21_88
	jmp	.LBB21_48
.LBB21_30:
	movq	%r13, 56(%rsp)
	movq	%rdx, 40(%rsp)
	movl	$8, %edx
	movq	72(%rsp), %rdi
	movq	80(%rsp), %rsi
	callq	*_RNvCs9wFQrvczXsK_7___rustc14___rust_dealloc@GOTPCREL(%rip)
	movq	%r14, 16(%rsp)
	testq	%r14, %r14
	je	.LBB21_54
	movq	56(%rsp), %rbx
	movq	16(%rsp), %rbp
	jmp	.LBB21_32
	.p2align	4
.LBB21_58:
	leaq	192(%r14), %rbx
	shll	$3, %r15d
	leaq	(%r14,%r15), %rdi
	addq	$192, %rdi
	movq	24(%rsp), %rdx
	addq	$8, %rdx
	movq	%rbx, %rsi
	callq	*memmove@GOTPCREL(%rip)
	movq	(%rsp), %rax
	movq	48(%rsp), %rcx
	leaq	(%rax,%rcx,8), %rsi
	addq	$192, %rsi
	movq	%rbx, %rdi
	movq	%r15, %rdx
	callq	*memcpy@GOTPCREL(%rip)
	movq	192(%r14), %rax
	movq	%r14, (%rax)
	movw	$0, 184(%rax)
	movq	200(%r14), %rax
	movq	%r14, (%rax)
	movw	$1, 184(%rax)
	movq	208(%r14), %rax
	movq	%r14, (%rax)
	movw	$2, 184(%rax)
	movq	216(%r14), %rax
	movq	%r14, (%rax)
	movw	$3, 184(%rax)
	movq	224(%r14), %rax
	movq	%r14, (%rax)
	movw	$4, 184(%rax)
	movq	232(%r14), %rax
	movq	%r14, (%rax)
	movw	$5, 184(%rax)
.LBB21_53:
	movq	%r14, %rbx
	decq	%rbp
	je	.LBB21_54
.LBB21_32:
	movzwl	186(%rbx), %r13d
	testq	%r13, %r13
	je	.LBB21_33
	movq	192(%rbx,%r13,8), %r14
	movzwl	186(%r14), %eax
	cmpq	$5, %rax
	jae	.LBB21_53
	movq	184(%rbx,%r13,8), %rcx
	movl	$5, %r15d
	subq	%rax, %r15
	movzwl	186(%rcx), %r12d
	cmpw	%r12w, %r15w
	ja	.LBB21_122
	movq	%rbp, 64(%rsp)
	movq	%r12, %rbp
	subq	%r15, %rbp
	movw	%bp, 186(%rcx)
	movw	$5, 186(%r14)
	leaq	8(%r14), %rsi
	leal	(,%r15,8), %edx
	movq	%rdx, 32(%rsp)
	leaq	(%r14,%rdx), %rdi
	addq	$8, %rdi
	shll	$3, %eax
	movzwl	%ax, %edx
	movq	%rdx, 24(%rsp)
	movq	%rcx, (%rsp)
	callq	*memmove@GOTPCREL(%rip)
	leaq	96(%r14), %rsi
	movq	32(%rsp), %rax
	leaq	(%r14,%rax), %rdi
	addq	$96, %rdi
	movq	24(%rsp), %rdx
	callq	*memmove@GOTPCREL(%rip)
	leaq	1(%rbp), %rax
	subl	%eax, %r12d
	movq	%rax, 48(%rsp)
	leal	(,%rax,8), %ecx
	movq	%rcx, 8(%rsp)
	movq	(%rsp), %rax
	leaq	(%rax,%rcx), %rsi
	addq	$8, %rsi
	shll	$3, %r12d
	leaq	8(%r14), %rdi
	movq	%r12, %rdx
	callq	*memcpy@GOTPCREL(%rip)
	movq	(%rsp), %rax
	movq	8(%rsp), %rcx
	leaq	(%rax,%rcx), %rsi
	addq	$96, %rsi
	leaq	96(%r14), %rdi
	movq	%r12, %rdx
	callq	*memcpy@GOTPCREL(%rip)
	shll	$3, %ebp
	movq	(%rsp), %rcx
	movq	8(%rcx,%rbp), %rax
	movq	96(%rcx,%rbp), %rcx
	movq	64(%rsp), %rbp
	movq	(%rbx,%r13,8), %rdx
	movq	88(%rbx,%r13,8), %rsi
	movq	%rax, (%rbx,%r13,8)
	movq	%rcx, 88(%rbx,%r13,8)
	movq	32(%rsp), %rax
	movq	%rdx, (%r14,%rax)
	movq	%rsi, 96(%r14,%r12)
	cmpq	$1, %rbp
	jne	.LBB21_58
.LBB21_54:
	movq	96(%rsp), %rcx
	testq	%rcx, %rcx
	je	.LBB21_55
	movq	56(%rsp), %r12
	testq	%r12, %r12
	je	.LBB21_101
	xorl	%r15d, %r15d
	xorl	%eax, %eax
	movq	88(%rsp), %rbx
	movq	16(%rsp), %r14
	.p2align	4
.LBB21_97:
	movq	(%rbx,%rax,8), %r11
	movq	%r14, %rsi
	movq	%r12, %rdx
.LBB21_98:
	movzwl	186(%rdx), %r8d
	movl	%r8d, %r9d
	shll	$3, %r9d
	movq	$-1, %rdi
	.p2align	4
.LBB21_99:
	testq	%r9, %r9
	je	.LBB21_100
	cmpq	16(%rdx,%rdi,8), %r11
	seta	%r10b
	sbbb	$0, %r10b
	incq	%rdi
	addq	$-8, %r9
	cmpb	$1, %r10b
	je	.LBB21_99
	movzbl	%r10b, %r8d
	testl	%r8d, %r8d
	je	.LBB21_114
	subq	$1, %rsi
	jae	.LBB21_113
	jmp	.LBB21_112
	.p2align	4
.LBB21_100:
	movq	%r8, %rdi
	subq	$1, %rsi
	jb	.LBB21_112
.LBB21_113:
	movq	192(%rdx,%rdi,8), %rdx
	jmp	.LBB21_98
	.p2align	4
.LBB21_114:
	movq	96(%rdx,%rdi,8), %rdx
	xorq	%rdx, %r15
	incq	%rax
	cmpq	%rcx, %rax
	jne	.LBB21_97
	jmp	.LBB21_116
.LBB21_112:
	movq	$-1, %rdx
	xorq	%rdx, %r15
	incq	%rax
	cmpq	%rcx, %rax
	jne	.LBB21_97
	jmp	.LBB21_116
.LBB21_101:
	cmpq	$4, %rcx
	jae	.LBB21_103
	xorl	%eax, %eax
	xorl	%r15d, %r15d
	jmp	.LBB21_106
.LBB21_55:
	xorl	%r15d, %r15d
	movq	16(%rsp), %r14
	movq	56(%rsp), %r12
.LBB21_116:
	testq	%r12, %r12
	je	.LBB21_108
	movq	$0, 112(%rsp)
	movq	%r12, 120(%rsp)
	movq	%r14, 128(%rsp)
	movq	$0, 144(%rsp)
	movq	%r12, 152(%rsp)
	movq	%r14, 160(%rsp)
	movl	$1, %eax
	movq	40(%rsp), %rcx
	jmp	.LBB21_118
.LBB21_103:
	movabsq	$1152921504606846972, %rax
	andq	%rcx, %rax
	pxor	%xmm0, %xmm0
	pcmpeqd	%xmm2, %xmm2
	movq	%rax, %rdx
	pxor	%xmm3, %xmm3
	.p2align	4
.LBB21_104:
	movdqa	%xmm3, %xmm1
	movdqa	%xmm0, %xmm4
	pxor	%xmm2, %xmm0
	pxor	%xmm2, %xmm3
	addq	$-4, %rdx
	jne	.LBB21_104
	pxor	%xmm4, %xmm1
	pshufd	$238, %xmm1, %xmm0
	pxor	%xmm1, %xmm0
	movq	%xmm0, %r15
	cmpq	%rax, %rcx
	je	.LBB21_108
.LBB21_106:
	subq	%rax, %rcx
	.p2align	4
.LBB21_107:
	notq	%r15
	decq	%rcx
	jne	.LBB21_107
.LBB21_108:
	xorl	%eax, %eax
	xorl	%ecx, %ecx
.LBB21_118:
	movq	%rax, 104(%rsp)
	movq	%rax, 136(%rsp)
	movq	%rcx, 168(%rsp)
	leaq	176(%rsp), %rdi
	leaq	104(%rsp), %rsi
	callq	_RNvMsz_NtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB5_8IntoIteryjE10dying_nextCs5Av9rWzHob7_3lib
	cmpq	$0, 176(%rsp)
	je	.LBB21_121
	leaq	176(%rsp), %rbx
	leaq	104(%rsp), %r14
	.p2align	4
.LBB21_120:
	movq	%rbx, %rdi
	movq	%r14, %rsi
	callq	_RNvMsz_NtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB5_8IntoIteryjE10dying_nextCs5Av9rWzHob7_3lib
	cmpq	$0, 176(%rsp)
	jne	.LBB21_120
.LBB21_121:
	movq	%r15, %rax
	addq	$200, %rsp
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%r12
	.cfi_def_cfa_offset 40
	popq	%r13
	.cfi_def_cfa_offset 32
	popq	%r14
	.cfi_def_cfa_offset 24
	popq	%r15
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	retq
.LBB21_85:
	.cfi_def_cfa_offset 256
.Ltmp39:
	movl	$8, %edi
	movl	$288, %esi
	callq	*_RNvNtCscdodAO9FK5_5alloc5alloc18handle_alloc_error@GOTPCREL(%rip)
.Ltmp40:
	jmp	.LBB21_26
.LBB21_68:
.Ltmp44:
	movl	$8, %edi
	movl	$192, %esi
	callq	*_RNvNtCscdodAO9FK5_5alloc5alloc18handle_alloc_error@GOTPCREL(%rip)
.Ltmp45:
	jmp	.LBB21_26
.LBB21_72:
.Ltmp42:
	leaq	.Lanon.843556a994c423e327e8a0cd8c96d9c8.22(%rip), %rdi
	leaq	.Lanon.843556a994c423e327e8a0cd8c96d9c8.23(%rip), %rdx
	movl	$32, %esi
	callq	*_RNvNtCs4NRVxsYgnAr_4core9panicking5panic@GOTPCREL(%rip)
.Ltmp43:
	jmp	.LBB21_26
.LBB21_33:
	leaq	.Lanon.843556a994c423e327e8a0cd8c96d9c8.18(%rip), %rdi
	leaq	.Lanon.843556a994c423e327e8a0cd8c96d9c8.19(%rip), %rdx
	movl	$25, %esi
	callq	*_RNvNtCs4NRVxsYgnAr_4core9panicking5panic@GOTPCREL(%rip)
.LBB21_61:
.Ltmp50:
	movl	$8, %edi
	movl	$288, %esi
	callq	*_RNvNtCscdodAO9FK5_5alloc5alloc18handle_alloc_error@GOTPCREL(%rip)
.Ltmp51:
	jmp	.LBB21_26
.LBB21_63:
.Ltmp47:
	leaq	.Lanon.843556a994c423e327e8a0cd8c96d9c8.1(%rip), %rdi
	callq	*_RNvNtCs4NRVxsYgnAr_4core6option13unwrap_failed@GOTPCREL(%rip)
.Ltmp48:
	jmp	.LBB21_26
.LBB21_122:
	leaq	.Lanon.843556a994c423e327e8a0cd8c96d9c8.20(%rip), %rdi
	leaq	.Lanon.843556a994c423e327e8a0cd8c96d9c8.21(%rip), %rdx
	movl	$39, %esi
	callq	*_RNvNtCs4NRVxsYgnAr_4core9panicking5panic@GOTPCREL(%rip)
.LBB21_13:
	cmpq	$21, %rsi
	jae	.LBB21_14
	movq	%rbp, %rax
	addq	%r13, %rax
	leaq	16(%rbp), %rsi
	movl	$16, %ecx
	movq	%rbp, %rdi
	jmp	.LBB21_16
.LBB21_19:
	movq	%rbp, %r8
.LBB21_22:
	movq	%rsi, (%r8)
	movq	%rdi, 8(%r8)
.LBB21_23:
	leaq	16(%rdx), %rsi
	addq	$16, %rcx
	movq	%rdx, %rdi
	cmpq	%rax, %rsi
	je	.LBB21_24
.LBB21_16:
	movq	%rsi, %rdx
	movq	16(%rdi), %rsi
	cmpq	(%rdi), %rsi
	jae	.LBB21_23
	movq	24(%rdi), %rdi
	movq	%rcx, %r9
.LBB21_18:
	movdqu	-16(%rbp,%r9), %xmm0
	movdqu	%xmm0, (%rbp,%r9)
	cmpq	$16, %r9
	je	.LBB21_19
	leaq	-16(%r9), %r8
	cmpq	-32(%rbp,%r9), %rsi
	movq	%r8, %r9
	jb	.LBB21_18
	addq	%rbp, %r8
	jmp	.LBB21_22
.LBB21_25:
.Ltmp53:
	movl	$8, %edi
	movl	$192, %esi
	callq	*_RNvNtCscdodAO9FK5_5alloc5alloc18handle_alloc_error@GOTPCREL(%rip)
.Ltmp54:
.LBB21_26:
	ud2
.LBB21_14:
.Ltmp36:
	leaq	104(%rsp), %rdx
	movq	%rbp, %rdi
	callq	*_RINvNtNtNtCs4NRVxsYgnAr_4core5slice4sort6stable14driftsort_mainTyjENCINvMNtCscdodAO9FK5_5alloc5sliceSBZ_7sort_byNCINvXs1o_NtNtNtB1b_11collections5btree3mapINtB1W_8BTreeMapyjEINtNtNtNtB8_4iter6traits7collect12FromIteratorBZ_E9from_iterINtNtNtB2T_8adapters3map3MapINtNtB3P_9enumerate9EnumerateINtNtB3P_6copied6CopiedINtNtB6_4iter4IteryEEENCNvCs5Av9rWzHob7_3lib11tree_lookup0EE0E0INtNtB1b_3vec3VecBZ_EEB5s_@GOTPCREL(%rip)
.Ltmp37:
	jmp	.LBB21_24
.LBB21_92:
.Ltmp38:
	jmp	.LBB21_90
.LBB21_89:
.Ltmp55:
.LBB21_90:
	movq	%rax, %rbx
	jmp	.LBB21_91
.LBB21_64:
.Ltmp49:
	movl	$288, %esi
	movl	$8, %edx
	movq	%rbp, %rdi
	callq	*_RNvCs9wFQrvczXsK_7___rustc14___rust_dealloc@GOTPCREL(%rip)
	ud2
.LBB21_65:
.Ltmp52:
	ud2
.LBB21_59:
.Ltmp46:
	movq	%rax, %rbx
	movq	80(%rsp), %r13
	movq	72(%rsp), %rbp
.LBB21_91:
	movl	$8, %edx
	movq	%rbp, %rdi
	movq	%r13, %rsi
	callq	*_RNvCs9wFQrvczXsK_7___rustc14___rust_dealloc@GOTPCREL(%rip)
	movq	%rbx, %rdi
	callq	_Unwind_Resume@PLT
.LBB21_86:
.Ltmp41:
	ud2
.Lfunc_end21:
	.size	_RNvCs5Av9rWzHob7_3lib11tree_lookup, .Lfunc_end21-_RNvCs5Av9rWzHob7_3lib11tree_lookup
	.cfi_endproc

_RNvCs5Av9rWzHob7_3lib13packed_lookup:
.Lfunc_begin7:
	.cfi_startproc
	.cfi_personality 155, DW.ref.rust_eh_personality
	.cfi_lsda 27, .Lexception7
	pushq	%rbp
	.cfi_def_cfa_offset 16
	pushq	%r15
	.cfi_def_cfa_offset 24
	pushq	%r14
	.cfi_def_cfa_offset 32
	pushq	%r13
	.cfi_def_cfa_offset 40
	pushq	%r12
	.cfi_def_cfa_offset 48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	pushq	%rax
	.cfi_def_cfa_offset 64
	.cfi_offset %rbx, -56
	.cfi_offset %r12, -48
	.cfi_offset %r13, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	.cfi_offset %rbp, -16
	cmpq	$100001, %rsi
	jae	.LBB22_73
	movq	%rcx, %rbx
	movq	%rdx, %r14
	testq	%rsi, %rsi
	je	.LBB22_2
	leaq	(,%rsi,8), %rax
	movq	(%rdi), %rcx
	xorl	%edx, %edx
	.p2align	4
.LBB22_6:
	testq	%rax, %rax
	je	.LBB22_3
	movq	(%rdi,%rdx,8), %r8
	subq	%rcx, %r8
	jb	.LBB22_9
	addq	$-8, %rax
	cmpq	%r8, %rdx
	leaq	1(%rdx), %rdx
	je	.LBB22_6
.LBB22_9:
	movq	%rdi, %rbp
	movq	%rsi, %r13
	leaq	(,%rsi,4), %rax
	leaq	(%rax,%rax,2), %r15
	callq	*_RNvCs9wFQrvczXsK_7___rustc35___rust_no_alloc_shim_is_unstable_v2@GOTPCREL(%rip)
	movl	$4, %esi
	movq	%r15, %rdi
	callq	*_RNvCs9wFQrvczXsK_7___rustc12___rust_alloc@GOTPCREL(%rip)
	testq	%rax, %rax
	je	.LBB22_12
	movq	%rax, %r12
	movq	%r13, %rax
	movl	%eax, %esi
	andl	$3, %esi
	cmpq	$4, %r13
	jae	.LBB22_13
	xorl	%ecx, %ecx
	movq	%rbp, %rdx
	jmp	.LBB22_16
.LBB22_2:
	xorl	%ecx, %ecx
.LBB22_3:
	testq	%rbx, %rbx
	je	.LBB22_4
	cmpq	$1, %rbx
	jne	.LBB22_68
	xorl	%edx, %edx
	xorl	%eax, %eax
	jmp	.LBB22_71
.LBB22_4:
	xorl	%eax, %eax
	jmp	.LBB22_72
.LBB22_68:
	movabsq	$1152921504606846974, %rdi
	andq	%rbx, %rdi
	xorl	%edx, %edx
	movq	$-1, %r8
	xorl	%eax, %eax
	.p2align	4
.LBB22_69:
	movq	(%r14,%rdx,8), %r9
	movq	8(%r14,%rdx,8), %r10
	movq	%r10, %r11
	subq	%rcx, %r11
	cmpq	%rsi, %r11
	cmovaeq	%r8, %r11
	cmpq	%rcx, %r10
	cmovbq	%r8, %r11
	movq	%r9, %r10
	subq	%rcx, %r10
	cmpq	%rsi, %r10
	cmovaeq	%r8, %r10
	cmpq	%rcx, %r9
	cmovbq	%r8, %r10
	xorq	%r10, %rax
	xorq	%r11, %rax
	addq	$2, %rdx
	cmpq	%rdx, %rdi
	jne	.LBB22_69
	testb	$1, %bl
	je	.LBB22_72
.LBB22_71:
	movq	%rax, %rdi
	movq	(%r14,%rdx,8), %rdx
	movq	%rdx, %rax
	subq	%rcx, %rax
	cmpq	%rsi, %rax
	movq	$-1, %rsi
	cmovaeq	%rsi, %rax
	cmpq	%rcx, %rdx
	cmovbq	%rsi, %rax
	xorq	%rdi, %rax
	jmp	.LBB22_72
.LBB22_13:
	movl	%eax, %edi
	andl	$131068, %edi
	leaq	44(%r12), %r8
	xorl	%ecx, %ecx
	movq	%rbp, %rdx
	.p2align	4
.LBB22_14:
	movq	(%rdx,%rcx,8), %r9
	movq	%r9, -44(%r8)
	movl	%ecx, -36(%r8)
	movq	8(%rdx,%rcx,8), %r9
	movq	%r9, -32(%r8)
	leal	1(%rcx), %r9d
	movl	%r9d, -24(%r8)
	movq	16(%rdx,%rcx,8), %r9
	movq	%r9, -20(%r8)
	leal	2(%rcx), %r9d
	movl	%r9d, -12(%r8)
	movq	24(%rdx,%rcx,8), %r9
	movq	%r9, -8(%r8)
	leal	3(%rcx), %r9d
	movl	%r9d, (%r8)
	addq	$4, %rcx
	addq	$48, %r8
	cmpq	%rdi, %rcx
	jne	.LBB22_14
	testq	%rsi, %rsi
	je	.LBB22_18
.LBB22_16:
	leaq	(%rcx,%rcx,2), %rdi
	leaq	(%r12,%rdi,4), %rdi
	addq	$8, %rdi
	shll	$2, %esi
	leaq	(%rsi,%rsi,2), %rsi
	xorl	%r8d, %r8d
	.p2align	4
.LBB22_17:
	movq	(%rdx,%rcx,8), %r9
	movq	%r9, -8(%rdi,%r8)
	movl	%ecx, (%rdi,%r8)
	incq	%rcx
	addq	$12, %r8
	cmpq	%r8, %rsi
	jne	.LBB22_17
.LBB22_18:
	cmpq	$1, %rax
	jne	.LBB22_19
.LBB22_30:
	leaq	1(%rax), %rcx
	movq	%r12, %rdx
	.p2align	4
.LBB22_31:
	decq	%rcx
	cmpq	$2, %rcx
	jb	.LBB22_38
	movq	(%rdx), %rsi
	cmpq	12(%rdx), %rsi
	leaq	12(%rdx), %rdx
	jne	.LBB22_31
.Ltmp58:
	leaq	.Lanon.843556a994c423e327e8a0cd8c96d9c8.5(%rip), %rdi
	leaq	.Lanon.843556a994c423e327e8a0cd8c96d9c8.10(%rip), %rdx
	movl	$73, %esi
	callq	*_RNvNtCs4NRVxsYgnAr_4core9panicking9panic_fmt@GOTPCREL(%rip)
.Ltmp59:
	ud2
.LBB22_38:
	testq	%rbx, %rbx
	je	.LBB22_39
	testq	%rax, %rax
	je	.LBB22_48
	cmpq	$1, %rax
	jne	.LBB22_42
	movq	(%r12), %rax
	cmpq	$1, %rbx
	jne	.LBB22_57
	xorl	%edx, %edx
	xorl	%ecx, %ecx
	jmp	.LBB22_64
.LBB22_39:
	xorl	%ecx, %ecx
	jmp	.LBB22_67
.LBB22_48:
	cmpq	$4, %rbx
	jae	.LBB22_50
	xorl	%ecx, %ecx
	xorl	%eax, %eax
	jmp	.LBB22_53
.LBB22_42:
	xorl	%ecx, %ecx
	xorl	%edx, %edx
	jmp	.LBB22_43
	.p2align	4
.LBB22_47:
	xorq	%rdi, %rcx
	incq	%rdx
	cmpq	%rbx, %rdx
	je	.LBB22_67
.LBB22_43:
	movq	(%r14,%rdx,8), %rsi
	movq	%rax, %rdi
	xorl	%r8d, %r8d
	.p2align	4
.LBB22_44:
	movq	%r8, %r9
	movq	%rdi, %r10
	shrq	%r10
	addq	%r10, %r8
	leaq	(%r8,%r8,2), %r11
	cmpq	%rsi, (%r12,%r11,4)
	cmovaq	%r9, %r8
	subq	%r10, %rdi
	cmpq	$1, %rdi
	ja	.LBB22_44
	leaq	(%r8,%r8,2), %r8
	movq	$-1, %rdi
	cmpq	%rsi, (%r12,%r8,4)
	jne	.LBB22_47
	leaq	(%r12,%r8,4), %rsi
	movl	8(%rsi), %edi
	jmp	.LBB22_47
.LBB22_57:
	movabsq	$1152921504606846974, %rsi
	andq	%rbx, %rsi
	xorl	%edx, %edx
	xorl	%ecx, %ecx
	jmp	.LBB22_58
	.p2align	4
.LBB22_62:
	xorq	%r8, %rcx
	xorq	%rdi, %rcx
	addq	$2, %rdx
	cmpq	%rdx, %rsi
	je	.LBB22_63
.LBB22_58:
	movq	$-1, %rdi
	movq	$-1, %r8
	cmpq	(%r14,%rdx,8), %rax
	jne	.LBB22_60
	movl	8(%r12), %r8d
.LBB22_60:
	cmpq	8(%r14,%rdx,8), %rax
	jne	.LBB22_62
	movl	8(%r12), %edi
	jmp	.LBB22_62
.LBB22_63:
	testb	$1, %bl
	je	.LBB22_67
.LBB22_64:
	movq	$-1, %rsi
	cmpq	(%r14,%rdx,8), %rax
	jne	.LBB22_66
	movl	8(%r12), %esi
.LBB22_66:
	xorq	%rsi, %rcx
.LBB22_67:
	movl	$4, %edx
	movq	%r12, %rdi
	movq	%r15, %rsi
	movq	%rcx, %rbx
	callq	*_RNvCs9wFQrvczXsK_7___rustc14___rust_dealloc@GOTPCREL(%rip)
	movq	%rbx, %rax
.LBB22_72:
	addq	$8, %rsp
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%r12
	.cfi_def_cfa_offset 40
	popq	%r13
	.cfi_def_cfa_offset 32
	popq	%r14
	.cfi_def_cfa_offset 24
	popq	%r15
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	retq
.LBB22_50:
	.cfi_def_cfa_offset 64
	movabsq	$1152921504606846974, %rcx
	addq	$-2, %rcx
	andq	%rbx, %rcx
	pxor	%xmm0, %xmm0
	pcmpeqd	%xmm2, %xmm2
	movq	%rcx, %rax
	pxor	%xmm3, %xmm3
	.p2align	4
.LBB22_51:
	movdqa	%xmm3, %xmm1
	movdqa	%xmm0, %xmm4
	pxor	%xmm2, %xmm0
	pxor	%xmm2, %xmm3
	addq	$-4, %rax
	jne	.LBB22_51
	pxor	%xmm4, %xmm1
	pshufd	$238, %xmm1, %xmm0
	pxor	%xmm1, %xmm0
	movq	%xmm0, %rax
	cmpq	%rcx, %rbx
	je	.LBB22_72
.LBB22_53:
	subq	%rcx, %rbx
	.p2align	4
.LBB22_54:
	notq	%rax
	decq	%rbx
	jne	.LBB22_54
	jmp	.LBB22_72
.LBB22_73:
	leaq	.Lanon.843556a994c423e327e8a0cd8c96d9c8.2(%rip), %rdi
	leaq	.Lanon.843556a994c423e327e8a0cd8c96d9c8.9(%rip), %rdx
	movl	$63, %esi
	callq	*_RNvNtCs4NRVxsYgnAr_4core9panicking9panic_fmt@GOTPCREL(%rip)
.LBB22_19:
	cmpq	$21, %rax
	jae	.LBB22_20
	leaq	(%r12,%r15), %rcx
	leaq	12(%r12), %rdi
	movl	$12, %edx
	movq	%r12, %r8
	jmp	.LBB22_22
.LBB22_25:
	movq	%r12, %r10
.LBB22_28:
	movq	%rdi, (%r10)
	movl	%r8d, 8(%r10)
.LBB22_29:
	leaq	12(%rsi), %rdi
	addq	$12, %rdx
	movq	%rsi, %r8
	cmpq	%rcx, %rdi
	je	.LBB22_30
.LBB22_22:
	movq	%rdi, %rsi
	movq	12(%r8), %rdi
	cmpq	(%r8), %rdi
	jae	.LBB22_29
	movl	20(%r8), %r8d
	movq	%rdx, %r9
.LBB22_24:
	movl	-4(%r12,%r9), %r10d
	movl	%r10d, 8(%r12,%r9)
	movq	-12(%r12,%r9), %r10
	movq	%r10, (%r12,%r9)
	cmpq	$12, %r9
	je	.LBB22_25
	leaq	-12(%r9), %r10
	cmpq	-24(%r12,%r9), %rdi
	movq	%r10, %r9
	jb	.LBB22_24
	addq	%r12, %r10
	jmp	.LBB22_28
.LBB22_12:
	movl	$4, %edi
	movq	%r15, %rsi
	callq	*_RNvNtCscdodAO9FK5_5alloc7raw_vec12handle_error@GOTPCREL(%rip)
.LBB22_20:
.Ltmp56:
	movq	%rsp, %rdx
	movq	%r12, %rdi
	movq	%r13, %rsi
	callq	*_RINvNtNtNtCs4NRVxsYgnAr_4core5slice4sort8unstable7ipnsortNtNtCs5Av9rWzHob7_3lib10runs_index5EntryNCINvMB6_SBT_20sort_unstable_by_keyyNCINvMs_BV_NtBV_13IdentityIndex8from_idsINtNtNtNtB8_4iter8adapters6copied6CopiedINtNtB6_4iter4IteryEEEs0_0E0EBX_@GOTPCREL(%rip)
	movq	%r13, %rax
.Ltmp57:
	jmp	.LBB22_30
.LBB22_35:
.Ltmp60:
	movq	%rax, %rbx
	movl	$4, %edx
	movq	%r12, %rdi
	movq	%r15, %rsi
	callq	*_RNvCs9wFQrvczXsK_7___rustc14___rust_dealloc@GOTPCREL(%rip)
	movq	%rbx, %rdi
	callq	_Unwind_Resume@PLT
.Lfunc_end22:
	.size	_RNvCs5Av9rWzHob7_3lib13packed_lookup, .Lfunc_end22-_RNvCs5Av9rWzHob7_3lib13packed_lookup
	.cfi_endproc

_RNvCs5Av9rWzHob7_3lib14aligned_lookup:
.Lfunc_begin8:
	.cfi_startproc
	.cfi_personality 155, DW.ref.rust_eh_personality
	.cfi_lsda 27, .Lexception8
	pushq	%rbp
	.cfi_def_cfa_offset 16
	pushq	%r15
	.cfi_def_cfa_offset 24
	pushq	%r14
	.cfi_def_cfa_offset 32
	pushq	%r13
	.cfi_def_cfa_offset 40
	pushq	%r12
	.cfi_def_cfa_offset 48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	subq	$24, %rsp
	.cfi_def_cfa_offset 80
	.cfi_offset %rbx, -56
	.cfi_offset %r12, -48
	.cfi_offset %r13, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	.cfi_offset %rbp, -16
	movabsq	$576460752303423484, %rbp
	movq	%rsi, %r15
	shlq	$4, %r15
	leaq	3(%rbp), %rax
	cmpq	%rax, %rsi
	jbe	.LBB23_3
	xorl	%r12d, %r12d
.LBB23_2:
	movq	%r12, %rdi
	movq	%r15, %rsi
	callq	*_RNvNtCscdodAO9FK5_5alloc7raw_vec12handle_error@GOTPCREL(%rip)
.LBB23_3:
	movq	%rcx, %rbx
	movq	%rdx, %r14
	testq	%rsi, %rsi
	je	.LBB23_7
	movq	%rdi, %r13
	movq	%rsi, 8(%rsp)
	callq	*_RNvCs9wFQrvczXsK_7___rustc35___rust_no_alloc_shim_is_unstable_v2@GOTPCREL(%rip)
	movl	$8, %r12d
	movl	$8, %esi
	movq	%r15, %rdi
	callq	*_RNvCs9wFQrvczXsK_7___rustc12___rust_alloc@GOTPCREL(%rip)
	testq	%rax, %rax
	je	.LBB23_2
	movq	8(%rsp), %rsi
	movl	%esi, %ecx
	andl	$3, %ecx
	cmpq	$4, %rsi
	jae	.LBB23_8
	xorl	%edi, %edi
	jmp	.LBB23_11
.LBB23_7:
	movl	$8, %eax
	xorl	%ecx, %ecx
	testq	%rbx, %rbx
	jne	.LBB23_16
	jmp	.LBB23_20
.LBB23_8:
	andq	%rsi, %rbp
	leaq	56(%rax), %r8
	xorl	%edi, %edi
	.p2align	4
.LBB23_9:
	movq	(%r13,%rdi,8), %r9
	movq	%r9, -56(%r8)
	movl	%edi, -48(%r8)
	movq	8(%r13,%rdi,8), %r9
	movq	%r9, -40(%r8)
	leal	1(%rdi), %r9d
	movl	%r9d, -32(%r8)
	movq	16(%r13,%rdi,8), %r9
	movq	%r9, -24(%r8)
	leal	2(%rdi), %r9d
	movl	%r9d, -16(%r8)
	movq	24(%r13,%rdi,8), %r9
	movq	%r9, -8(%r8)
	leal	3(%rdi), %r9d
	movl	%r9d, (%r8)
	addq	$4, %rdi
	addq	$64, %r8
	cmpq	%rbp, %rdi
	jne	.LBB23_9
	testq	%rcx, %rcx
	je	.LBB23_13
.LBB23_11:
	movq	%rdi, %r8
	shlq	$4, %r8
	addq	%rax, %r8
	addq	$8, %r8
	shll	$4, %ecx
	xorl	%r9d, %r9d
	.p2align	4
.LBB23_12:
	movq	(%r13,%rdi,8), %r10
	movq	%r10, -8(%r8,%r9)
	movl	%edi, (%r8,%r9)
	incq	%rdi
	addq	$16, %r9
	cmpq	%r9, %rcx
	jne	.LBB23_12
.LBB23_13:
	cmpq	$1, %rsi
	jne	.LBB23_47
.LBB23_14:
	movq	%rsi, %rcx
	testq	%rbx, %rbx
	je	.LBB23_20
.LBB23_16:
	testq	%rsi, %rsi
	je	.LBB23_21
	cmpq	$1, %rsi
	jne	.LBB23_23
	movq	(%rax), %rdx
	cmpq	$1, %rbx
	jne	.LBB23_29
	xorl	%esi, %esi
	xorl	%r15d, %r15d
	jmp	.LBB23_36
.LBB23_21:
	cmpq	$4, %rbx
	jae	.LBB23_39
	xorl	%edx, %edx
	xorl	%r15d, %r15d
	jmp	.LBB23_42
.LBB23_23:
	xorl	%r15d, %r15d
	xorl	%edx, %edx
	jmp	.LBB23_25
	.p2align	4
.LBB23_24:
	xorq	%r9, %r15
	incq	%rdx
	cmpq	%rbx, %rdx
	je	.LBB23_44
.LBB23_25:
	movq	(%r14,%rdx,8), %rdi
	movq	%rsi, %r9
	xorl	%r8d, %r8d
	.p2align	4
.LBB23_26:
	movq	%r8, %r10
	movq	%r9, %r11
	shrq	%r11
	addq	%r11, %r8
	movq	%r8, %r12
	shlq	$4, %r12
	cmpq	%rdi, (%rax,%r12)
	cmovaq	%r10, %r8
	subq	%r11, %r9
	cmpq	$1, %r9
	ja	.LBB23_26
	shlq	$4, %r8
	movq	$-1, %r9
	cmpq	%rdi, (%rax,%r8)
	jne	.LBB23_24
	addq	%rax, %r8
	movl	8(%r8), %r9d
	jmp	.LBB23_24
.LBB23_29:
	movabsq	$1152921504606846972, %rdi
	orq	$2, %rdi
	andq	%rbx, %rdi
	xorl	%esi, %esi
	xorl	%r15d, %r15d
	jmp	.LBB23_31
	.p2align	4
.LBB23_30:
	xorq	%r9, %r15
	xorq	%r8, %r15
	addq	$2, %rsi
	cmpq	%rsi, %rdi
	je	.LBB23_35
.LBB23_31:
	movq	$-1, %r8
	movq	$-1, %r9
	cmpq	(%r14,%rsi,8), %rdx
	jne	.LBB23_33
	movl	8(%rax), %r9d
.LBB23_33:
	cmpq	8(%r14,%rsi,8), %rdx
	jne	.LBB23_30
	movl	8(%rax), %r8d
	jmp	.LBB23_30
.LBB23_35:
	testb	$1, %bl
	je	.LBB23_44
.LBB23_36:
	movq	$-1, %rdi
	cmpq	(%r14,%rsi,8), %rdx
	jne	.LBB23_38
	movl	8(%rax), %edi
.LBB23_38:
	xorq	%rdi, %r15
	jmp	.LBB23_44
.LBB23_39:
	movabsq	$1152921504606846972, %rdx
	andq	%rbx, %rdx
	pxor	%xmm0, %xmm0
	pcmpeqd	%xmm2, %xmm2
	movq	%rdx, %rsi
	pxor	%xmm3, %xmm3
	.p2align	4
.LBB23_40:
	movdqa	%xmm3, %xmm1
	movdqa	%xmm0, %xmm4
	pxor	%xmm2, %xmm0
	pxor	%xmm2, %xmm3
	addq	$-4, %rsi
	jne	.LBB23_40
	pxor	%xmm4, %xmm1
	pshufd	$238, %xmm1, %xmm0
	pxor	%xmm1, %xmm0
	movq	%xmm0, %r15
	cmpq	%rdx, %rbx
	je	.LBB23_44
.LBB23_42:
	subq	%rdx, %rbx
	.p2align	4
.LBB23_43:
	notq	%r15
	decq	%rbx
	jne	.LBB23_43
	jmp	.LBB23_44
.LBB23_47:
	cmpq	$21, %rsi
	jae	.LBB23_58
	addq	%rax, %r15
	leaq	16(%rax), %rdi
	movl	$16, %ecx
	movq	%rax, %r8
	jmp	.LBB23_52
.LBB23_49:
	movq	%rax, %r9
.LBB23_50:
	movq	%rdi, (%r9)
	movl	%r8d, 8(%r9)
.LBB23_51:
	leaq	16(%rdx), %rdi
	addq	$16, %rcx
	movq	%rdx, %r8
	cmpq	%r15, %rdi
	je	.LBB23_14
.LBB23_52:
	movq	%rdi, %rdx
	movq	16(%r8), %rdi
	cmpq	(%r8), %rdi
	jae	.LBB23_51
	movl	24(%r8), %r8d
	movq	%rcx, %r10
.LBB23_54:
	movdqu	-16(%rax,%r10), %xmm0
	movdqu	%xmm0, (%rax,%r10)
	cmpq	$16, %r10
	je	.LBB23_49
	leaq	-16(%r10), %r9
	cmpq	-32(%rax,%r10), %rdi
	movq	%r9, %r10
	jb	.LBB23_54
	addq	%rax, %r9
	jmp	.LBB23_50
.LBB23_58:
.Ltmp61:
	leaq	16(%rsp), %rdx
	movq	%rax, %r12
	movq	%rax, %rdi
	callq	*_RINvNtNtNtCs4NRVxsYgnAr_4core5slice4sort8unstable7ipnsortNtCs5Av9rWzHob7_3lib12AlignedEntryNCINvMB6_SBT_20sort_unstable_by_keyyNCNvBV_14aligned_lookups_0E0EBV_@GOTPCREL(%rip)
.Ltmp62:
	movq	8(%rsp), %rsi
	movq	%rsi, %rcx
	movq	%r12, %rax
	testq	%rbx, %rbx
	jne	.LBB23_16
.LBB23_20:
	xorl	%r15d, %r15d
.LBB23_44:
	testq	%rcx, %rcx
	je	.LBB23_46
	shlq	$4, %rcx
	movl	$8, %edx
	movq	%rax, %rdi
	movq	%rcx, %rsi
	callq	*_RNvCs9wFQrvczXsK_7___rustc14___rust_dealloc@GOTPCREL(%rip)
.LBB23_46:
	movq	%r15, %rax
	addq	$24, %rsp
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%r12
	.cfi_def_cfa_offset 40
	popq	%r13
	.cfi_def_cfa_offset 32
	popq	%r14
	.cfi_def_cfa_offset 24
	popq	%r15
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	retq
.LBB23_60:
	.cfi_def_cfa_offset 80
.Ltmp63:
	movq	%rax, %rbx
	movl	$8, %edx
	movq	%r12, %rdi
	movq	%r15, %rsi
	callq	*_RNvCs9wFQrvczXsK_7___rustc14___rust_dealloc@GOTPCREL(%rip)
	movq	%rbx, %rdi
	callq	_Unwind_Resume@PLT
.Lfunc_end23:
	.size	_RNvCs5Av9rWzHob7_3lib14aligned_lookup, .Lfunc_end23-_RNvCs5Av9rWzHob7_3lib14aligned_lookup
	.cfi_endproc
