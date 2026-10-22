	.file	"lib.41187a8fd52682eb-cgu.0"
	.section	.text._RINvNtNtNtCs4NRVxsYgnAr_4core5slice4sort8unstable7ipnsortNtNtCs5Av9rWzHob7_3lib14identity_index3RunNCINvMB6_SBT_20sort_unstable_by_keyyNCINvMs0_BV_NtBV_13IdentityIndex8from_idsINtNtNtNtB8_4iter8adapters6copied6CopiedINtNtB6_4iter4IteryEEEs_0E0EBX_,"ax",@progbits
	.globl	_RINvNtNtNtCs4NRVxsYgnAr_4core5slice4sort8unstable7ipnsortNtNtCs5Av9rWzHob7_3lib14identity_index3RunNCINvMB6_SBT_20sort_unstable_by_keyyNCINvMs0_BV_NtBV_13IdentityIndex8from_idsINtNtNtNtB8_4iter8adapters6copied6CopiedINtNtB6_4iter4IteryEEEs_0E0EBX_
	.p2align	4
	.type	_RINvNtNtNtCs4NRVxsYgnAr_4core5slice4sort8unstable7ipnsortNtNtCs5Av9rWzHob7_3lib14identity_index3RunNCINvMB6_SBT_20sort_unstable_by_keyyNCINvMs0_BV_NtBV_13IdentityIndex8from_idsINtNtNtNtB8_4iter8adapters6copied6CopiedINtNtB6_4iter4IteryEEEs_0E0EBX_,@function
_RINvNtNtNtCs4NRVxsYgnAr_4core5slice4sort8unstable7ipnsortNtNtCs5Av9rWzHob7_3lib14identity_index3RunNCINvMB6_SBT_20sort_unstable_by_keyyNCINvMs0_BV_NtBV_13IdentityIndex8from_idsINtNtNtNtB8_4iter8adapters6copied6CopiedINtNtB6_4iter4IteryEEEs_0E0EBX_:
	.cfi_startproc
	cmpq	$2, %rsi
	jb	.LBB0_17
	movq	%rdx, %r8
	movq	(%rdi), %rax
	movq	16(%rdi), %rcx
	movl	$2, %edx
	cmpq	%rax, %rcx
	jae	.LBB0_2
	cmpq	$2, %rsi
	je	.LBB0_10
	leaq	32(%rdi), %r9
	movq	%rcx, %r10
	.p2align	4
.LBB0_8:
	movq	%r10, %r11
	movq	(%r9), %r10
	cmpq	%r11, %r10
	jae	.LBB0_10
	incq	%rdx
	addq	$16, %r9
	cmpq	%rdx, %rsi
	jne	.LBB0_8
	jmp	.LBB0_11
.LBB0_2:
	cmpq	$2, %rsi
	jne	.LBB0_3
.LBB0_10:
	cmpq	%rsi, %rdx
	je	.LBB0_11
	movq	%rsi, %rax
	orq	$1, %rax
	bsrq	%rax, %rcx
	xorl	$63, %ecx
	addl	%ecx, %ecx
	xorl	$126, %ecx
	xorl	%edx, %edx
	jmp	_RINvNtNtNtNtCs4NRVxsYgnAr_4core5slice4sort8unstable9quicksort9quicksortNtNtCs5Av9rWzHob7_3lib14identity_index3RunNCINvMB8_SB17_20sort_unstable_by_keyyNCINvMs0_B19_NtB19_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs_0E0EB1b_
.LBB0_3:
	leaq	32(%rdi), %r9
	movq	%rcx, %r10
	.p2align	4
.LBB0_4:
	movq	%r10, %r11
	movq	(%r9), %r10
	cmpq	%r11, %r10
	jb	.LBB0_10
	incq	%rdx
	addq	$16, %r9
	cmpq	%rdx, %rsi
	jne	.LBB0_4
.LBB0_11:
	cmpq	%rax, %rcx
	jae	.LBB0_17
	movq	%rsi, %rdx
	shrq	%rdx
	shlq	$4, %rsi
	leaq	(%rdi,%rsi), %rax
	cmpq	$1, %rdx
	jne	.LBB0_18
	xorl	%ecx, %ecx
	jmp	.LBB0_16
.LBB0_18:
	movabsq	$288230376151711742, %r8
	andq	%rdx, %r8
	leaq	16(%rdi), %r9
	addq	%rdi, %rsi
	addq	$-16, %rsi
	xorl	%ecx, %ecx
	movabsq	$1152921504606846974, %r10
	.p2align	4
.LBB0_19:
	movups	-16(%r9), %xmm0
	movups	(%rsi), %xmm1
	movups	%xmm1, -16(%r9)
	movups	%xmm0, (%rsi)
	movq	%rcx, %r11
	xorq	%r10, %r11
	shlq	$4, %r11
	movups	(%r9), %xmm0
	movups	(%rax,%r11), %xmm1
	movups	%xmm1, (%r9)
	movups	%xmm0, (%rax,%r11)
	addq	$2, %rcx
	addq	$32, %r9
	addq	$-32, %rsi
	cmpq	%rcx, %r8
	jne	.LBB0_19
	testb	$1, %dl
	je	.LBB0_17
.LBB0_16:
	movq	%rcx, %rdx
	notq	%rdx
	shlq	$4, %rcx
	shlq	$4, %rdx
	movups	(%rdi,%rcx), %xmm0
	movups	(%rax,%rdx), %xmm1
	movups	%xmm1, (%rdi,%rcx)
	movups	%xmm0, (%rax,%rdx)
.LBB0_17:
	retq
.Lfunc_end0:
	.size	_RINvNtNtNtCs4NRVxsYgnAr_4core5slice4sort8unstable7ipnsortNtNtCs5Av9rWzHob7_3lib14identity_index3RunNCINvMB6_SBT_20sort_unstable_by_keyyNCINvMs0_BV_NtBV_13IdentityIndex8from_idsINtNtNtNtB8_4iter8adapters6copied6CopiedINtNtB6_4iter4IteryEEEs_0E0EBX_, .Lfunc_end0-_RINvNtNtNtCs4NRVxsYgnAr_4core5slice4sort8unstable7ipnsortNtNtCs5Av9rWzHob7_3lib14identity_index3RunNCINvMB6_SBT_20sort_unstable_by_keyyNCINvMs0_BV_NtBV_13IdentityIndex8from_idsINtNtNtNtB8_4iter8adapters6copied6CopiedINtNtB6_4iter4IteryEEEs_0E0EBX_
	.cfi_endproc

	.section	.text._RINvNtNtNtCs4NRVxsYgnAr_4core5slice4sort8unstable7ipnsortNtNtCs5Av9rWzHob7_3lib14identity_index5EntryNCINvMB6_SBT_20sort_unstable_by_keyyNCINvMs0_BV_NtBV_13IdentityIndex8from_idsINtNtNtNtB8_4iter8adapters6copied6CopiedINtNtB6_4iter4IteryEEEs1_0E0EBX_,"ax",@progbits
	.globl	_RINvNtNtNtCs4NRVxsYgnAr_4core5slice4sort8unstable7ipnsortNtNtCs5Av9rWzHob7_3lib14identity_index5EntryNCINvMB6_SBT_20sort_unstable_by_keyyNCINvMs0_BV_NtBV_13IdentityIndex8from_idsINtNtNtNtB8_4iter8adapters6copied6CopiedINtNtB6_4iter4IteryEEEs1_0E0EBX_
	.p2align	4
	.type	_RINvNtNtNtCs4NRVxsYgnAr_4core5slice4sort8unstable7ipnsortNtNtCs5Av9rWzHob7_3lib14identity_index5EntryNCINvMB6_SBT_20sort_unstable_by_keyyNCINvMs0_BV_NtBV_13IdentityIndex8from_idsINtNtNtNtB8_4iter8adapters6copied6CopiedINtNtB6_4iter4IteryEEEs1_0E0EBX_,@function
_RINvNtNtNtCs4NRVxsYgnAr_4core5slice4sort8unstable7ipnsortNtNtCs5Av9rWzHob7_3lib14identity_index5EntryNCINvMB6_SBT_20sort_unstable_by_keyyNCINvMs0_BV_NtBV_13IdentityIndex8from_idsINtNtNtNtB8_4iter8adapters6copied6CopiedINtNtB6_4iter4IteryEEEs1_0E0EBX_:
	.cfi_startproc
	cmpq	$2, %rsi
	jb	.LBB1_14
	movq	%rdx, %r8
	movq	(%rdi), %rax
	movq	12(%rdi), %rcx
	movl	$2, %edx
	cmpq	%rax, %rcx
	jae	.LBB1_2
	cmpq	$2, %rsi
	je	.LBB1_10
	leaq	24(%rdi), %r9
	movq	%rcx, %r10
	.p2align	4
.LBB1_8:
	movq	%r10, %r11
	movq	(%r9), %r10
	cmpq	%r11, %r10
	jae	.LBB1_10
	incq	%rdx
	addq	$12, %r9
	cmpq	%rdx, %rsi
	jne	.LBB1_8
	jmp	.LBB1_11
.LBB1_2:
	cmpq	$2, %rsi
	jne	.LBB1_3
.LBB1_10:
	cmpq	%rsi, %rdx
	je	.LBB1_11
	movq	%rsi, %rax
	orq	$1, %rax
	bsrq	%rax, %rcx
	xorl	$63, %ecx
	addl	%ecx, %ecx
	xorl	$126, %ecx
	xorl	%edx, %edx
	jmp	_RINvNtNtNtNtCs4NRVxsYgnAr_4core5slice4sort8unstable9quicksort9quicksortNtNtCs5Av9rWzHob7_3lib14identity_index5EntryNCINvMB8_SB17_20sort_unstable_by_keyyNCINvMs0_B19_NtB19_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs1_0E0EB1b_
.LBB1_3:
	leaq	24(%rdi), %r9
	movq	%rcx, %r10
	.p2align	4
.LBB1_4:
	movq	%r10, %r11
	movq	(%r9), %r10
	cmpq	%r11, %r10
	jb	.LBB1_10
	incq	%rdx
	addq	$12, %r9
	cmpq	%rdx, %rsi
	jne	.LBB1_4
.LBB1_11:
	cmpq	%rax, %rcx
	jae	.LBB1_14
	leaq	(%rsi,%rsi), %rax
	andq	$-4, %rax
	leaq	(%rax,%rax,2), %rax
	leaq	(%rsi,%rsi,2), %rcx
	leaq	-12(,%rcx,4), %rcx
	xorl	%edx, %edx
	.p2align	4
.LBB1_13:
	movq	(%rdi,%rdx), %rsi
	movq	(%rdi,%rcx), %r8
	movq	%r8, (%rdi,%rdx)
	movq	%rsi, (%rdi,%rcx)
	movl	8(%rdi,%rdx), %esi
	movl	8(%rdi,%rcx), %r8d
	movl	%r8d, 8(%rdi,%rdx)
	movl	%esi, 8(%rdi,%rcx)
	addq	$12, %rdx
	addq	$-12, %rcx
	cmpq	%rdx, %rax
	jne	.LBB1_13
.LBB1_14:
	retq
.Lfunc_end1:
	.size	_RINvNtNtNtCs4NRVxsYgnAr_4core5slice4sort8unstable7ipnsortNtNtCs5Av9rWzHob7_3lib14identity_index5EntryNCINvMB6_SBT_20sort_unstable_by_keyyNCINvMs0_BV_NtBV_13IdentityIndex8from_idsINtNtNtNtB8_4iter8adapters6copied6CopiedINtNtB6_4iter4IteryEEEs1_0E0EBX_, .Lfunc_end1-_RINvNtNtNtCs4NRVxsYgnAr_4core5slice4sort8unstable7ipnsortNtNtCs5Av9rWzHob7_3lib14identity_index5EntryNCINvMB6_SBT_20sort_unstable_by_keyyNCINvMs0_BV_NtBV_13IdentityIndex8from_idsINtNtNtNtB8_4iter8adapters6copied6CopiedINtNtB6_4iter4IteryEEEs1_0E0EBX_
	.cfi_endproc

	.section	.text._RINvNtNtNtNtCs4NRVxsYgnAr_4core5slice4sort6shared5pivot11median3_recNtNtCs5Av9rWzHob7_3lib14identity_index3RunNCINvMB8_SB14_20sort_unstable_by_keyyNCINvMs0_B16_NtB16_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs_0E0EB18_,"ax",@progbits
	.p2align	4
	.type	_RINvNtNtNtNtCs4NRVxsYgnAr_4core5slice4sort6shared5pivot11median3_recNtNtCs5Av9rWzHob7_3lib14identity_index3RunNCINvMB8_SB14_20sort_unstable_by_keyyNCINvMs0_B16_NtB16_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs_0E0EB18_,@function
_RINvNtNtNtNtCs4NRVxsYgnAr_4core5slice4sort6shared5pivot11median3_recNtNtCs5Av9rWzHob7_3lib14identity_index3RunNCINvMB8_SB14_20sort_unstable_by_keyyNCINvMs0_B16_NtB16_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs_0E0EB18_:
	.cfi_startproc
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
	movq	%rdx, %r14
	movq	%rsi, %rbx
	cmpq	$8, %rcx
	jb	.LBB2_2
	shrq	$3, %rcx
	movq	%rcx, %r15
	shlq	$6, %r15
	leaq	(%rdi,%r15), %rsi
	imulq	$112, %rcx, %r12
	leaq	(%rdi,%r12), %rdx
	movq	%rcx, %r13
	callq	_RINvNtNtNtNtCs4NRVxsYgnAr_4core5slice4sort6shared5pivot11median3_recNtNtCs5Av9rWzHob7_3lib14identity_index3RunNCINvMB8_SB14_20sort_unstable_by_keyyNCINvMs0_B16_NtB16_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs_0E0EB18_
	movq	%rax, %rbp
	leaq	(%rbx,%r15), %rsi
	leaq	(%rbx,%r12), %rdx
	movq	%rbx, %rdi
	movq	%r13, %rcx
	callq	_RINvNtNtNtNtCs4NRVxsYgnAr_4core5slice4sort6shared5pivot11median3_recNtNtCs5Av9rWzHob7_3lib14identity_index3RunNCINvMB8_SB14_20sort_unstable_by_keyyNCINvMs0_B16_NtB16_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs_0E0EB18_
	movq	%rax, %rbx
	addq	%r14, %r15
	addq	%r14, %r12
	movq	%r14, %rdi
	movq	%r15, %rsi
	movq	%r12, %rdx
	movq	%r13, %rcx
	callq	_RINvNtNtNtNtCs4NRVxsYgnAr_4core5slice4sort6shared5pivot11median3_recNtNtCs5Av9rWzHob7_3lib14identity_index3RunNCINvMB8_SB14_20sort_unstable_by_keyyNCINvMs0_B16_NtB16_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs_0E0EB18_
	movq	%rbp, %rdi
	movq	%rax, %r14
.LBB2_2:
	movq	(%rdi), %rax
	movq	(%rbx), %rcx
	cmpq	%rcx, %rax
	setb	%dl
	movq	(%r14), %rsi
	cmpq	%rsi, %rax
	setb	%al
	xorb	%dl, %al
	cmpq	%rsi, %rcx
	setb	%cl
	xorb	%dl, %cl
	cmovneq	%r14, %rbx
	testb	%al, %al
	cmovneq	%rdi, %rbx
	movq	%rbx, %rax
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
.Lfunc_end2:
	.size	_RINvNtNtNtNtCs4NRVxsYgnAr_4core5slice4sort6shared5pivot11median3_recNtNtCs5Av9rWzHob7_3lib14identity_index3RunNCINvMB8_SB14_20sort_unstable_by_keyyNCINvMs0_B16_NtB16_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs_0E0EB18_, .Lfunc_end2-_RINvNtNtNtNtCs4NRVxsYgnAr_4core5slice4sort6shared5pivot11median3_recNtNtCs5Av9rWzHob7_3lib14identity_index3RunNCINvMB8_SB14_20sort_unstable_by_keyyNCINvMs0_B16_NtB16_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs_0E0EB18_
	.cfi_endproc

	.section	.text._RINvNtNtNtNtCs4NRVxsYgnAr_4core5slice4sort6shared5pivot11median3_recNtNtCs5Av9rWzHob7_3lib14identity_index5EntryNCINvMB8_SB14_20sort_unstable_by_keyyNCINvMs0_B16_NtB16_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs1_0E0EB18_,"ax",@progbits
	.p2align	4
	.type	_RINvNtNtNtNtCs4NRVxsYgnAr_4core5slice4sort6shared5pivot11median3_recNtNtCs5Av9rWzHob7_3lib14identity_index5EntryNCINvMB8_SB14_20sort_unstable_by_keyyNCINvMs0_B16_NtB16_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs1_0E0EB18_,@function
_RINvNtNtNtNtCs4NRVxsYgnAr_4core5slice4sort6shared5pivot11median3_recNtNtCs5Av9rWzHob7_3lib14identity_index5EntryNCINvMB8_SB14_20sort_unstable_by_keyyNCINvMs0_B16_NtB16_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs1_0E0EB18_:
	.cfi_startproc
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
	movq	%rdx, %r14
	movq	%rsi, %rbx
	cmpq	$8, %rcx
	jb	.LBB3_2
	shrq	$3, %rcx
	movq	%rcx, %rax
	shlq	$4, %rax
	leaq	(%rax,%rax,2), %r15
	leaq	(%rdi,%r15), %rsi
	imulq	$84, %rcx, %r12
	leaq	(%rdi,%r12), %rdx
	movq	%rcx, %r13
	callq	_RINvNtNtNtNtCs4NRVxsYgnAr_4core5slice4sort6shared5pivot11median3_recNtNtCs5Av9rWzHob7_3lib14identity_index5EntryNCINvMB8_SB14_20sort_unstable_by_keyyNCINvMs0_B16_NtB16_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs1_0E0EB18_
	movq	%rax, %rbp
	leaq	(%rbx,%r15), %rsi
	leaq	(%rbx,%r12), %rdx
	movq	%rbx, %rdi
	movq	%r13, %rcx
	callq	_RINvNtNtNtNtCs4NRVxsYgnAr_4core5slice4sort6shared5pivot11median3_recNtNtCs5Av9rWzHob7_3lib14identity_index5EntryNCINvMB8_SB14_20sort_unstable_by_keyyNCINvMs0_B16_NtB16_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs1_0E0EB18_
	movq	%rax, %rbx
	addq	%r14, %r15
	addq	%r14, %r12
	movq	%r14, %rdi
	movq	%r15, %rsi
	movq	%r12, %rdx
	movq	%r13, %rcx
	callq	_RINvNtNtNtNtCs4NRVxsYgnAr_4core5slice4sort6shared5pivot11median3_recNtNtCs5Av9rWzHob7_3lib14identity_index5EntryNCINvMB8_SB14_20sort_unstable_by_keyyNCINvMs0_B16_NtB16_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs1_0E0EB18_
	movq	%rbp, %rdi
	movq	%rax, %r14
.LBB3_2:
	movq	(%rdi), %rax
	movq	(%rbx), %rcx
	cmpq	%rcx, %rax
	setb	%dl
	movq	(%r14), %rsi
	cmpq	%rsi, %rax
	setb	%al
	xorb	%dl, %al
	cmpq	%rsi, %rcx
	setb	%cl
	xorb	%dl, %cl
	cmovneq	%r14, %rbx
	testb	%al, %al
	cmovneq	%rdi, %rbx
	movq	%rbx, %rax
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
.Lfunc_end3:
	.size	_RINvNtNtNtNtCs4NRVxsYgnAr_4core5slice4sort6shared5pivot11median3_recNtNtCs5Av9rWzHob7_3lib14identity_index5EntryNCINvMB8_SB14_20sort_unstable_by_keyyNCINvMs0_B16_NtB16_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs1_0E0EB18_, .Lfunc_end3-_RINvNtNtNtNtCs4NRVxsYgnAr_4core5slice4sort6shared5pivot11median3_recNtNtCs5Av9rWzHob7_3lib14identity_index5EntryNCINvMB8_SB14_20sort_unstable_by_keyyNCINvMs0_B16_NtB16_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs1_0E0EB18_
	.cfi_endproc

	.section	.text._RINvNtNtNtNtCs4NRVxsYgnAr_4core5slice4sort6shared9smallsort12sort8_stableNtNtCs5Av9rWzHob7_3lib14identity_index3RunNCINvMB8_SB19_20sort_unstable_by_keyyNCINvMs0_B1b_NtB1b_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs_0E0EB1d_,"ax",@progbits
	.p2align	4
	.type	_RINvNtNtNtNtCs4NRVxsYgnAr_4core5slice4sort6shared9smallsort12sort8_stableNtNtCs5Av9rWzHob7_3lib14identity_index3RunNCINvMB8_SB19_20sort_unstable_by_keyyNCINvMs0_B1b_NtB1b_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs_0E0EB1d_,@function
_RINvNtNtNtNtCs4NRVxsYgnAr_4core5slice4sort6shared9smallsort12sort8_stableNtNtCs5Av9rWzHob7_3lib14identity_index3RunNCINvMB8_SB19_20sort_unstable_by_keyyNCINvMs0_B1b_NtB1b_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs_0E0EB1d_:
	.cfi_startproc
	pushq	%r15
	.cfi_def_cfa_offset 16
	pushq	%r14
	.cfi_def_cfa_offset 24
	pushq	%r13
	.cfi_def_cfa_offset 32
	pushq	%r12
	.cfi_def_cfa_offset 40
	pushq	%rbx
	.cfi_def_cfa_offset 48
	.cfi_offset %rbx, -48
	.cfi_offset %r12, -40
	.cfi_offset %r13, -32
	.cfi_offset %r14, -24
	.cfi_offset %r15, -16
	movq	16(%rdi), %rax
	movq	48(%rdi), %rcx
	xorl	%r11d, %r11d
	xorl	%r9d, %r9d
	cmpq	(%rdi), %rax
	setae	%r11b
	setb	%r9b
	xorl	%r8d, %r8d
	cmpq	32(%rdi), %rcx
	setb	%r8b
	shll	$4, %r9d
	leaq	(%rdi,%r9), %rax
	shll	$4, %r11d
	leaq	(%rdi,%r11), %rcx
	movl	%r8d, %ebx
	shll	$4, %ebx
	leaq	(%rdi,%rbx), %r10
	addq	$32, %r10
	xorl	$3, %r8d
	shll	$4, %r8d
	movq	32(%rdi,%rbx), %rbx
	movq	(%rdi,%r8), %r14
	movq	(%rdi,%r11), %r11
	cmpq	%r11, %r14
	movq	%rcx, %r15
	cmovbq	%r10, %r15
	cmpq	(%rdi,%r9), %rbx
	cmovbq	%rax, %r15
	cmovbq	%r10, %rax
	leaq	(%rdi,%r8), %r8
	cmovbq	%rcx, %r10
	cmpq	%r11, %r14
	cmovaeq	%r8, %rcx
	cmovbq	%r8, %r10
	movq	(%r10), %r8
	cmpq	(%r15), %r8
	movq	%r15, %r8
	cmovbq	%r10, %r8
	cmovbq	%r15, %r10
	movups	(%rax), %xmm0
	movups	%xmm0, (%rdx)
	movups	(%r8), %xmm0
	movups	%xmm0, 16(%rdx)
	movups	(%r10), %xmm0
	movups	%xmm0, 32(%rdx)
	movups	(%rcx), %xmm0
	movups	%xmm0, 48(%rdx)
	movq	80(%rdi), %rax
	movq	112(%rdi), %rcx
	xorl	%r11d, %r11d
	xorl	%r10d, %r10d
	cmpq	64(%rdi), %rax
	setae	%r11b
	setb	%r10b
	xorl	%r8d, %r8d
	cmpq	96(%rdi), %rcx
	setb	%r8b
	shll	$4, %r10d
	leaq	(%rdi,%r10), %rax
	addq	$64, %rax
	shll	$4, %r11d
	leaq	(%rdi,%r11), %rcx
	addq	$64, %rcx
	movl	%r8d, %ebx
	shll	$4, %ebx
	leaq	(%rdi,%rbx), %r9
	addq	$96, %r9
	xorl	$3, %r8d
	shll	$4, %r8d
	movq	96(%rdi,%rbx), %rbx
	movq	64(%rdi,%r8), %r14
	movq	64(%rdi,%r11), %r11
	cmpq	%r11, %r14
	movq	%rcx, %r15
	cmovbq	%r9, %r15
	cmpq	64(%rdi,%r10), %rbx
	cmovbq	%rax, %r15
	cmovbq	%r9, %rax
	cmovbq	%rcx, %r9
	cmpq	%r11, %r14
	leaq	64(%rdi,%r8), %rdi
	cmovaeq	%rdi, %rcx
	cmovbq	%rdi, %r9
	movq	(%r9), %rdi
	cmpq	(%r15), %rdi
	leaq	64(%rdx), %rdi
	movq	%r15, %r8
	cmovbq	%r9, %r8
	cmovbq	%r15, %r9
	movups	(%rax), %xmm0
	movups	%xmm0, 64(%rdx)
	movups	(%r8), %xmm0
	movups	%xmm0, 80(%rdx)
	movups	(%r9), %xmm0
	movups	%xmm0, 96(%rdx)
	movups	(%rcx), %xmm0
	movups	%xmm0, 112(%rdx)
	movq	64(%rdx), %rax
	xorl	%ecx, %ecx
	xorl	%r11d, %r11d
	cmpq	(%rdx), %rax
	setae	%cl
	setb	%r11b
	cmovaeq	%rdx, %rdi
	movups	(%rdi), %xmm0
	movups	%xmm0, (%rsi)
	movq	112(%rdx), %rdi
	movq	48(%rdx), %r8
	xorl	%eax, %eax
	cmpq	%r8, %rdi
	movl	$0, %r9d
	adcq	$-1, %r9
	cmpq	%r8, %rdi
	movl	$0, %r10d
	sbbq	%r10, %r10
	leaq	48(%rdx), %rbx
	leaq	112(%rdx), %r14
	cmpq	%r8, %rdi
	cmovbq	%rbx, %r14
	shll	$4, %r11d
	leaq	(%rdx,%r11), %rdi
	addq	$64, %rdi
	shll	$4, %ecx
	movups	(%r14), %xmm0
	movups	%xmm0, 112(%rsi)
	leaq	(%rdx,%rcx), %r8
	shlq	$4, %r9
	shlq	$4, %r10
	movq	64(%rdx,%r11), %rbx
	xorl	%r15d, %r15d
	xorl	%r11d, %r11d
	cmpq	(%rdx,%rcx), %rbx
	setae	%r15b
	setb	%r11b
	movq	%r8, %rcx
	cmovbq	%rdi, %rcx
	movups	(%rcx), %xmm0
	movups	%xmm0, 16(%rsi)
	movq	112(%rdx,%r9), %rbx
	movq	48(%rdx,%r10), %r14
	cmpq	%r14, %rbx
	movl	$0, %ecx
	adcq	$-1, %rcx
	cmpq	%r14, %rbx
	leaq	112(%rdx,%r9), %r14
	leaq	48(%rdx,%r10), %rbx
	movq	%r14, %r10
	cmovbq	%rbx, %r10
	movl	$0, %edx
	sbbq	%rdx, %rdx
	shll	$4, %r11d
	leaq	(%rdi,%r11), %r9
	shll	$4, %r15d
	movups	(%r10), %xmm0
	movups	%xmm0, 96(%rsi)
	leaq	(%r8,%r15), %r10
	shlq	$4, %rcx
	shlq	$4, %rdx
	movq	(%r11,%rdi), %rdi
	xorl	%r11d, %r11d
	xorl	%r12d, %r12d
	cmpq	(%r15,%r8), %rdi
	setae	%r11b
	setb	%r12b
	movq	%r10, %rdi
	cmovbq	%r9, %rdi
	movups	(%rdi), %xmm0
	movups	%xmm0, 32(%rsi)
	movq	(%rcx,%r14), %r15
	movq	(%rdx,%rbx), %r13
	cmpq	%r13, %r15
	movl	$0, %edi
	adcq	$-1, %rdi
	cmpq	%r13, %r15
	movl	$0, %r8d
	sbbq	%r8, %r8
	addq	%r14, %rcx
	addq	%rbx, %rdx
	cmpq	%r13, %r15
	movq	%rcx, %rbx
	cmovbq	%rdx, %rbx
	shll	$4, %r12d
	leaq	(%r9,%r12), %r15
	shll	$4, %r11d
	movups	(%rbx), %xmm0
	movups	%xmm0, 80(%rsi)
	leaq	(%r10,%r11), %rbx
	shlq	$4, %rdi
	shlq	$4, %r8
	movq	(%r12,%r9), %r12
	xorl	%r9d, %r9d
	xorl	%r14d, %r14d
	cmpq	(%r11,%r10), %r12
	setae	%r9b
	setb	%r14b
	movq	%rbx, %r10
	cmovbq	%r15, %r10
	movups	(%r10), %xmm0
	movups	%xmm0, 48(%rsi)
	movq	(%rdi,%rcx), %r11
	movq	(%r8,%rdx), %r12
	cmpq	%r12, %r11
	movl	$0, %r10d
	adcq	$-1, %r10
	cmpq	%r12, %r11
	sbbq	%rax, %rax
	addq	%rcx, %rdi
	addq	%rdx, %r8
	cmpq	%r12, %r11
	movq	%rdi, %rcx
	cmovbq	%r8, %rcx
	shll	$4, %r14d
	addq	%r15, %r14
	shll	$4, %r9d
	movups	(%rcx), %xmm0
	movups	%xmm0, 64(%rsi)
	addq	%rbx, %r9
	shlq	$4, %r10
	shlq	$4, %rax
	leaq	(%rax,%r8), %rcx
	addq	$16, %rcx
	leaq	(%r10,%rdi), %rax
	addq	$16, %rax
	cmpq	%rax, %r14
	setne	%al
	cmpq	%rcx, %r9
	jne	.LBB4_1
	testb	%al, %al
	jne	.LBB4_4
.LBB4_3:
	popq	%rbx
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	retq
.LBB4_1:
	.cfi_def_cfa_offset 48
	movb	$1, %al
	testb	%al, %al
	je	.LBB4_3
.LBB4_4:
	callq	*_RNvNtNtNtNtCs4NRVxsYgnAr_4core5slice4sort6shared9smallsort22panic_on_ord_violation@GOTPCREL(%rip)
.Lfunc_end4:
	.size	_RINvNtNtNtNtCs4NRVxsYgnAr_4core5slice4sort6shared9smallsort12sort8_stableNtNtCs5Av9rWzHob7_3lib14identity_index3RunNCINvMB8_SB19_20sort_unstable_by_keyyNCINvMs0_B1b_NtB1b_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs_0E0EB1d_, .Lfunc_end4-_RINvNtNtNtNtCs4NRVxsYgnAr_4core5slice4sort6shared9smallsort12sort8_stableNtNtCs5Av9rWzHob7_3lib14identity_index3RunNCINvMB8_SB19_20sort_unstable_by_keyyNCINvMs0_B1b_NtB1b_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs_0E0EB1d_
	.cfi_endproc

	.section	.text._RINvNtNtNtNtCs4NRVxsYgnAr_4core5slice4sort6shared9smallsort12sort8_stableNtNtCs5Av9rWzHob7_3lib14identity_index5EntryNCINvMB8_SB19_20sort_unstable_by_keyyNCINvMs0_B1b_NtB1b_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs1_0E0EB1d_,"ax",@progbits
	.p2align	4
	.type	_RINvNtNtNtNtCs4NRVxsYgnAr_4core5slice4sort6shared9smallsort12sort8_stableNtNtCs5Av9rWzHob7_3lib14identity_index5EntryNCINvMB8_SB19_20sort_unstable_by_keyyNCINvMs0_B1b_NtB1b_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs1_0E0EB1d_,@function
_RINvNtNtNtNtCs4NRVxsYgnAr_4core5slice4sort6shared9smallsort12sort8_stableNtNtCs5Av9rWzHob7_3lib14identity_index5EntryNCINvMB8_SB19_20sort_unstable_by_keyyNCINvMs0_B1b_NtB1b_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs1_0E0EB1d_:
	.cfi_startproc
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
	movq	12(%rdi), %rax
	movq	36(%rdi), %rcx
	xorl	%r10d, %r10d
	xorl	%r8d, %r8d
	cmpq	(%rdi), %rax
	setae	%r10b
	setb	%r8b
	leaq	36(%rdi), %r9
	leaq	24(%rdi), %r11
	cmpq	24(%rdi), %rcx
	leaq	(%r8,%r8,2), %rbx
	leaq	(%rdi,%rbx,4), %r8
	leaq	(%r10,%r10,2), %r10
	movq	%r11, %rcx
	cmovbq	%r9, %rcx
	leaq	(%rdi,%r10,4), %rax
	cmovbq	%r11, %r9
	movq	(%rcx), %r11
	movq	(%r9), %r14
	movq	(%rdi,%r10,4), %r10
	cmpq	%r10, %r14
	movq	%rax, %r15
	cmovbq	%rcx, %r15
	cmpq	(%rdi,%rbx,4), %r11
	cmovbq	%r8, %r15
	cmovbq	%rcx, %r8
	cmovbq	%rax, %rcx
	cmpq	%r10, %r14
	cmovaeq	%r9, %rax
	cmovbq	%r9, %rcx
	movq	(%rcx), %r9
	cmpq	(%r15), %r9
	movq	%r15, %r9
	cmovbq	%rcx, %r9
	cmovbq	%r15, %rcx
	movl	8(%r8), %r10d
	movl	%r10d, 8(%rdx)
	movq	(%r8), %r8
	movq	%r8, (%rdx)
	movl	8(%r9), %r8d
	movl	%r8d, 20(%rdx)
	movq	(%r9), %r8
	movq	%r8, 12(%rdx)
	movl	8(%rcx), %r8d
	movl	%r8d, 32(%rdx)
	movq	(%rcx), %rcx
	movq	%rcx, 24(%rdx)
	movl	8(%rax), %ecx
	movl	%ecx, 44(%rdx)
	movq	(%rax), %rax
	movq	%rax, 36(%rdx)
	movq	60(%rdi), %rax
	movq	84(%rdi), %rcx
	xorl	%r10d, %r10d
	xorl	%r8d, %r8d
	cmpq	48(%rdi), %rax
	setae	%r10b
	setb	%r8b
	leaq	84(%rdi), %r9
	leaq	72(%rdi), %r11
	cmpq	72(%rdi), %rcx
	leaq	(%r8,%r8,2), %rbx
	leaq	48(%rdi,%rbx,4), %r8
	leaq	(%r10,%r10,2), %r10
	movq	%r11, %rcx
	cmovbq	%r9, %rcx
	leaq	48(%rdi,%r10,4), %rax
	cmovbq	%r11, %r9
	movq	(%rcx), %r11
	movq	(%r9), %r14
	movq	48(%rdi,%r10,4), %r10
	cmpq	%r10, %r14
	movq	%rax, %r15
	cmovbq	%rcx, %r15
	cmpq	48(%rdi,%rbx,4), %r11
	cmovbq	%r8, %r15
	cmovbq	%rcx, %r8
	cmovbq	%rax, %rcx
	cmpq	%r10, %r14
	cmovaeq	%r9, %rax
	cmovbq	%r9, %rcx
	movq	(%rcx), %rdi
	cmpq	(%r15), %rdi
	movq	%r15, %rdi
	cmovbq	%rcx, %rdi
	cmovbq	%r15, %rcx
	movl	8(%r8), %r9d
	movl	%r9d, 56(%rdx)
	movq	(%r8), %r8
	movq	%r8, 48(%rdx)
	movq	(%rdi), %r8
	movq	%r8, 60(%rdx)
	movl	8(%rdi), %edi
	movl	%edi, 68(%rdx)
	movq	(%rcx), %rdi
	movq	%rdi, 72(%rdx)
	movl	8(%rcx), %ecx
	movl	%ecx, 80(%rdx)
	movq	(%rax), %rcx
	movq	%rcx, 84(%rdx)
	movl	8(%rax), %eax
	movl	%eax, 92(%rdx)
	movq	48(%rdx), %rax
	xorl	%edi, %edi
	xorl	%ecx, %ecx
	cmpq	(%rdx), %rax
	leaq	48(%rdx), %rax
	setae	%dil
	cmovaeq	%rdx, %rax
	setb	%cl
	movl	8(%rax), %r8d
	movl	%r8d, 8(%rsi)
	movq	(%rax), %rax
	movq	%rax, (%rsi)
	movq	84(%rdx), %r8
	movq	36(%rdx), %r9
	xorl	%eax, %eax
	cmpq	%r9, %r8
	movl	$0, %r10d
	adcq	$-1, %r10
	cmpq	%r9, %r8
	movl	$0, %r11d
	sbbq	%r11, %r11
	leaq	36(%rdx), %rbx
	leaq	84(%rdx), %r14
	cmpq	%r9, %r8
	leaq	(%rcx,%rcx,2), %r8
	leaq	48(%rdx,%r8,4), %rcx
	leaq	(%rdi,%rdi,2), %r9
	cmovbq	%rbx, %r14
	leaq	(%rdx,%r9,4), %rdi
	movl	8(%r14), %ebx
	movl	%ebx, 92(%rsi)
	movq	(%r14), %rbx
	movq	%rbx, 84(%rsi)
	leaq	(%r10,%r10,2), %r10
	leaq	(%r11,%r11,2), %r11
	movq	48(%rdx,%r8,4), %r8
	xorl	%ebx, %ebx
	xorl	%r14d, %r14d
	cmpq	(%rdx,%r9,4), %r8
	setae	%bl
	movq	%rdi, %r8
	cmovbq	%rcx, %r8
	setb	%r14b
	movl	8(%r8), %r9d
	movl	%r9d, 20(%rsi)
	movq	(%r8), %r8
	movq	%r8, 12(%rsi)
	movq	84(%rdx,%r10,4), %r8
	movq	36(%rdx,%r11,4), %r9
	cmpq	%r9, %r8
	movl	$0, %r15d
	adcq	$-1, %r15
	cmpq	%r9, %r8
	leaq	84(%rdx,%r10,4), %r10
	leaq	36(%rdx,%r11,4), %r11
	leaq	(%r14,%r14,2), %rdx
	leaq	(%rcx,%rdx,4), %r8
	leaq	(%rbx,%rbx,2), %rbx
	movq	%r10, %r14
	cmovbq	%r11, %r14
	leaq	(%rdi,%rbx,4), %r9
	movl	8(%r14), %ebp
	movl	%ebp, 80(%rsi)
	movq	(%r14), %r14
	movq	%r14, 72(%rsi)
	movl	$0, %r14d
	sbbq	%r14, %r14
	leaq	(%r15,%r15,2), %r15
	leaq	(%r14,%r14,2), %r14
	movq	(%rcx,%rdx,4), %rcx
	xorl	%r12d, %r12d
	xorl	%r13d, %r13d
	cmpq	(%rdi,%rbx,4), %rcx
	setae	%r12b
	setb	%r13b
	movq	%r9, %rcx
	cmovbq	%r8, %rcx
	movl	8(%rcx), %edx
	movl	%edx, 32(%rsi)
	movq	(%rcx), %rcx
	movq	%rcx, 24(%rsi)
	movq	(%r10,%r15,4), %rcx
	movq	(%r11,%r14,4), %rdx
	cmpq	%rdx, %rcx
	movl	$0, %ebp
	adcq	$-1, %rbp
	cmpq	%rdx, %rcx
	leaq	(%r10,%r15,4), %rdx
	leaq	(%r11,%r14,4), %rdi
	leaq	(%r13,%r13,2), %r14
	leaq	(%r8,%r14,4), %rcx
	leaq	(%r12,%r12,2), %r15
	leaq	(%r9,%r15,4), %rbx
	movq	%rdx, %r10
	cmovbq	%rdi, %r10
	movl	8(%r10), %r11d
	movl	%r11d, 68(%rsi)
	movq	(%r10), %r10
	movq	%r10, 60(%rsi)
	leaq	(%rbp,%rbp,2), %r10
	movl	$0, %r11d
	sbbq	%r11, %r11
	leaq	(%r11,%r11,2), %r11
	movq	(%r8,%r14,4), %r14
	xorl	%r12d, %r12d
	xorl	%r8d, %r8d
	cmpq	(%r9,%r15,4), %r14
	setae	%r12b
	leaq	(%r12,%r12,2), %r9
	leaq	(%rbx,%r9,4), %r9
	cmovbq	%rcx, %rbx
	setb	%r8b
	movl	8(%rbx), %ebp
	movl	%ebp, 44(%rsi)
	movq	(%rbx), %rbx
	movq	%rbx, 36(%rsi)
	movq	(%rdx,%r10,4), %rbx
	movq	(%rdi,%r11,4), %r14
	cmpq	%r14, %rbx
	movl	$0, %r15d
	adcq	$-1, %r15
	cmpq	%r14, %rbx
	leaq	(%rdx,%r10,4), %rdx
	leaq	(%rdi,%r11,4), %rdi
	leaq	(%r8,%r8,2), %r8
	leaq	(%r15,%r15,2), %r10
	leaq	12(%rdx,%r10,4), %r10
	cmovbq	%rdi, %rdx
	leaq	(%rcx,%r8,4), %rcx
	movl	8(%rdx), %r8d
	movl	%r8d, 56(%rsi)
	movq	(%rdx), %rdx
	movq	%rdx, 48(%rsi)
	sbbq	%rax, %rax
	leaq	(%rax,%rax,2), %rax
	leaq	(%rdi,%rax,4), %rdx
	addq	$12, %rdx
	cmpq	%r10, %rcx
	setne	%al
	cmpq	%rdx, %r9
	jne	.LBB5_1
	testb	%al, %al
	jne	.LBB5_4
.LBB5_3:
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
.LBB5_1:
	.cfi_def_cfa_offset 64
	movb	$1, %al
	testb	%al, %al
	je	.LBB5_3
.LBB5_4:
	callq	*_RNvNtNtNtNtCs4NRVxsYgnAr_4core5slice4sort6shared9smallsort22panic_on_ord_violation@GOTPCREL(%rip)
.Lfunc_end5:
	.size	_RINvNtNtNtNtCs4NRVxsYgnAr_4core5slice4sort6shared9smallsort12sort8_stableNtNtCs5Av9rWzHob7_3lib14identity_index5EntryNCINvMB8_SB19_20sort_unstable_by_keyyNCINvMs0_B1b_NtB1b_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs1_0E0EB1d_, .Lfunc_end5-_RINvNtNtNtNtCs4NRVxsYgnAr_4core5slice4sort6shared9smallsort12sort8_stableNtNtCs5Av9rWzHob7_3lib14identity_index5EntryNCINvMB8_SB19_20sort_unstable_by_keyyNCINvMs0_B1b_NtB1b_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs1_0E0EB1d_
	.cfi_endproc

	.section	.text._RINvNtNtNtNtCs4NRVxsYgnAr_4core5slice4sort8unstable8heapsort8heapsortNtNtCs5Av9rWzHob7_3lib14identity_index3RunNCINvMB8_SB15_20sort_unstable_by_keyyNCINvMs0_B17_NtB17_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs_0E0EB19_,"ax",@progbits
	.globl	_RINvNtNtNtNtCs4NRVxsYgnAr_4core5slice4sort8unstable8heapsort8heapsortNtNtCs5Av9rWzHob7_3lib14identity_index3RunNCINvMB8_SB15_20sort_unstable_by_keyyNCINvMs0_B17_NtB17_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs_0E0EB19_
	.p2align	4
	.type	_RINvNtNtNtNtCs4NRVxsYgnAr_4core5slice4sort8unstable8heapsort8heapsortNtNtCs5Av9rWzHob7_3lib14identity_index3RunNCINvMB8_SB15_20sort_unstable_by_keyyNCINvMs0_B17_NtB17_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs_0E0EB19_,@function
_RINvNtNtNtNtCs4NRVxsYgnAr_4core5slice4sort8unstable8heapsort8heapsortNtNtCs5Av9rWzHob7_3lib14identity_index3RunNCINvMB8_SB15_20sort_unstable_by_keyyNCINvMs0_B17_NtB17_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs_0E0EB19_:
	.cfi_startproc
	movq	%rsi, %rax
	shrq	%rax
	addq	%rsi, %rax
	jne	.LBB6_1
.LBB6_10:
	retq
	.p2align	4
.LBB6_9:
	testq	%rax, %rax
	je	.LBB6_10
.LBB6_1:
	decq	%rax
	movq	%rax, %rcx
	subq	%rsi, %rcx
	jae	.LBB6_3
	movq	%rax, %rcx
	shlq	$4, %rcx
	movups	(%rdi), %xmm0
	movaps	%xmm0, -24(%rsp)
	movups	(%rdi,%rcx), %xmm0
	movups	%xmm0, (%rdi)
	movaps	-24(%rsp), %xmm0
	movups	%xmm0, (%rdi,%rcx)
	xorl	%ecx, %ecx
.LBB6_3:
	cmpq	%rax, %rsi
	movq	%rax, %rdx
	cmovbq	%rsi, %rdx
	leaq	1(,%rcx,2), %r8
	cmpq	%rdx, %r8
	jae	.LBB6_9
	leaq	(%rcx,%rcx), %r10
	.p2align	4
.LBB6_5:
	addq	$2, %r10
	cmpq	%rdx, %r10
	jae	.LBB6_7
	movq	%r8, %r9
	shlq	$4, %r9
	shlq	$4, %r10
	movq	(%rdi,%r9), %r9
	cmpq	(%rdi,%r10), %r9
	adcq	$0, %r8
.LBB6_7:
	movq	%r8, %r9
	shlq	$4, %rcx
	shlq	$4, %r8
	movq	(%rdi,%rcx), %r10
	movq	(%rdi,%r8), %r11
	cmpq	%r11, %r10
	jae	.LBB6_9
	addq	%rdi, %rcx
	addq	%rdi, %r8
	movq	%r11, (%rcx)
	movq	%r10, (%r8)
	movq	8(%rcx), %r10
	movq	8(%r8), %r11
	movq	%r11, 8(%rcx)
	movq	%r10, 8(%r8)
	leaq	(%r9,%r9), %r10
	leaq	1(,%r9,2), %r8
	movq	%r9, %rcx
	cmpq	%rdx, %r8
	jb	.LBB6_5
	jmp	.LBB6_9
.Lfunc_end6:
	.size	_RINvNtNtNtNtCs4NRVxsYgnAr_4core5slice4sort8unstable8heapsort8heapsortNtNtCs5Av9rWzHob7_3lib14identity_index3RunNCINvMB8_SB15_20sort_unstable_by_keyyNCINvMs0_B17_NtB17_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs_0E0EB19_, .Lfunc_end6-_RINvNtNtNtNtCs4NRVxsYgnAr_4core5slice4sort8unstable8heapsort8heapsortNtNtCs5Av9rWzHob7_3lib14identity_index3RunNCINvMB8_SB15_20sort_unstable_by_keyyNCINvMs0_B17_NtB17_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs_0E0EB19_
	.cfi_endproc

	.section	.text._RINvNtNtNtNtCs4NRVxsYgnAr_4core5slice4sort8unstable8heapsort8heapsortNtNtCs5Av9rWzHob7_3lib14identity_index5EntryNCINvMB8_SB15_20sort_unstable_by_keyyNCINvMs0_B17_NtB17_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs1_0E0EB19_,"ax",@progbits
	.globl	_RINvNtNtNtNtCs4NRVxsYgnAr_4core5slice4sort8unstable8heapsort8heapsortNtNtCs5Av9rWzHob7_3lib14identity_index5EntryNCINvMB8_SB15_20sort_unstable_by_keyyNCINvMs0_B17_NtB17_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs1_0E0EB19_
	.p2align	4
	.type	_RINvNtNtNtNtCs4NRVxsYgnAr_4core5slice4sort8unstable8heapsort8heapsortNtNtCs5Av9rWzHob7_3lib14identity_index5EntryNCINvMB8_SB15_20sort_unstable_by_keyyNCINvMs0_B17_NtB17_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs1_0E0EB19_,@function
_RINvNtNtNtNtCs4NRVxsYgnAr_4core5slice4sort8unstable8heapsort8heapsortNtNtCs5Av9rWzHob7_3lib14identity_index5EntryNCINvMB8_SB15_20sort_unstable_by_keyyNCINvMs0_B17_NtB17_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs1_0E0EB19_:
	.cfi_startproc
	movq	%rsi, %rax
	shrq	%rax
	addq	%rsi, %rax
	jne	.LBB7_1
.LBB7_10:
	retq
	.p2align	4
.LBB7_9:
	testq	%rax, %rax
	je	.LBB7_10
.LBB7_1:
	decq	%rax
	movq	%rax, %rdx
	subq	%rsi, %rdx
	jae	.LBB7_3
	leaq	(%rax,%rax,2), %rcx
	movl	8(%rdi), %edx
	movl	%edx, -8(%rsp)
	movq	(%rdi), %rdx
	movq	%rdx, -16(%rsp)
	movl	8(%rdi,%rcx,4), %edx
	movq	(%rdi,%rcx,4), %r8
	movq	%r8, (%rdi)
	movl	%edx, 8(%rdi)
	movl	-8(%rsp), %edx
	movl	%edx, 8(%rdi,%rcx,4)
	movq	-16(%rsp), %rdx
	movq	%rdx, (%rdi,%rcx,4)
	xorl	%edx, %edx
.LBB7_3:
	cmpq	%rax, %rsi
	movq	%rax, %rcx
	cmovbq	%rsi, %rcx
	leaq	1(,%rdx,2), %r8
	cmpq	%rcx, %r8
	jae	.LBB7_9
	leaq	(%rdx,%rdx), %r10
	.p2align	4
.LBB7_5:
	addq	$2, %r10
	cmpq	%rcx, %r10
	jae	.LBB7_7
	leaq	(%r8,%r8,2), %r9
	leaq	(%r10,%r10,2), %r10
	movq	(%rdi,%r9,4), %r9
	cmpq	(%rdi,%r10,4), %r9
	adcq	$0, %r8
.LBB7_7:
	movq	%r8, %r9
	leaq	(%rdx,%rdx,2), %r8
	leaq	(%r9,%r9,2), %r10
	movq	(%rdi,%r8,4), %rdx
	movq	(%rdi,%r10,4), %r11
	cmpq	%r11, %rdx
	jae	.LBB7_9
	leaq	(%rdi,%r8,4), %r8
	leaq	(%rdi,%r10,4), %r10
	movq	%r11, (%r8)
	movq	%rdx, (%r10)
	movl	8(%r8), %edx
	movl	8(%r10), %r11d
	movl	%r11d, 8(%r8)
	movl	%edx, 8(%r10)
	leaq	(%r9,%r9), %r10
	leaq	1(,%r9,2), %r8
	movq	%r9, %rdx
	cmpq	%rcx, %r8
	jb	.LBB7_5
	jmp	.LBB7_9
.Lfunc_end7:
	.size	_RINvNtNtNtNtCs4NRVxsYgnAr_4core5slice4sort8unstable8heapsort8heapsortNtNtCs5Av9rWzHob7_3lib14identity_index5EntryNCINvMB8_SB15_20sort_unstable_by_keyyNCINvMs0_B17_NtB17_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs1_0E0EB19_, .Lfunc_end7-_RINvNtNtNtNtCs4NRVxsYgnAr_4core5slice4sort8unstable8heapsort8heapsortNtNtCs5Av9rWzHob7_3lib14identity_index5EntryNCINvMB8_SB15_20sort_unstable_by_keyyNCINvMs0_B17_NtB17_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs1_0E0EB19_
	.cfi_endproc

	.section	.text._RINvNtNtNtNtCs4NRVxsYgnAr_4core5slice4sort8unstable9quicksort9quicksortNtNtCs5Av9rWzHob7_3lib14identity_index3RunNCINvMB8_SB17_20sort_unstable_by_keyyNCINvMs0_B19_NtB19_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs_0E0EB1b_,"ax",@progbits
	.p2align	4
	.type	_RINvNtNtNtNtCs4NRVxsYgnAr_4core5slice4sort8unstable9quicksort9quicksortNtNtCs5Av9rWzHob7_3lib14identity_index3RunNCINvMB8_SB17_20sort_unstable_by_keyyNCINvMs0_B19_NtB19_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs_0E0EB1b_,@function
_RINvNtNtNtNtCs4NRVxsYgnAr_4core5slice4sort8unstable9quicksort9quicksortNtNtCs5Av9rWzHob7_3lib14identity_index3RunNCINvMB8_SB17_20sort_unstable_by_keyyNCINvMs0_B19_NtB19_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs_0E0EB1b_:
.Lfunc_begin0:
	.cfi_startproc
	.cfi_personality 155, DW.ref.rust_eh_personality
	.cfi_lsda 27, .Lexception0
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
	subq	$808, %rsp
	.cfi_def_cfa_offset 864
	.cfi_offset %rbx, -56
	.cfi_offset %r12, -48
	.cfi_offset %r13, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	.cfi_offset %rbp, -16
	movq	%r8, 16(%rsp)
	movq	%rsi, %r14
	movq	%rdi, 8(%rsp)
	cmpq	$33, %rsi
	jae	.LBB8_1
.LBB8_4:
	cmpq	$2, %r14
	jb	.LBB8_43
	movq	%r14, %r12
	shrq	%r12
	cmpq	$15, %r14
	jbe	.LBB8_6
	movq	%r14, %r15
	shlq	$4, %r15
	leaq	(%rsp,%r15), %rdx
	addq	$32, %rdx
	leaq	32(%rsp), %rsi
	movq	8(%rsp), %rbx
	movq	%rbx, %rdi
	callq	_RINvNtNtNtNtCs4NRVxsYgnAr_4core5slice4sort6shared9smallsort12sort8_stableNtNtCs5Av9rWzHob7_3lib14identity_index3RunNCINvMB8_SB19_20sort_unstable_by_keyyNCINvMs0_B1b_NtB1b_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs_0E0EB1d_
	movq	%r12, %rax
	shlq	$4, %rax
	leaq	(%rbx,%rax), %rdi
	leaq	(%rsp,%rax), %rsi
	addq	$32, %rsi
	leaq	(%rsp,%r15), %rdx
	addq	$160, %rdx
	callq	_RINvNtNtNtNtCs4NRVxsYgnAr_4core5slice4sort6shared9smallsort12sort8_stableNtNtCs5Av9rWzHob7_3lib14identity_index3RunNCINvMB8_SB19_20sort_unstable_by_keyyNCINvMs0_B1b_NtB1b_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs_0E0EB1d_
	movl	$8, %ecx
	movq	%r14, %rdx
	subq	%r12, %rdx
	cmpq	%r12, %rcx
	jb	.LBB8_10
	jmp	.LBB8_15
.LBB8_1:
	movl	%ecx, %ebp
	movq	%rdx, %r15
	leaq	32(%rsp), %r13
	jmp	.LBB8_2
	.p2align	4
.LBB8_64:
	movq	%rax, %rcx
	shlq	$4, %rcx
	movq	8(%rsp), %rdx
	movups	(%rdx), %xmm0
	movaps	%xmm0, 32(%rsp)
	movups	(%rdx,%rcx), %xmm0
	movups	%xmm0, (%rdx)
	movaps	32(%rsp), %xmm0
	movups	%xmm0, (%rdx,%rcx)
	incq	%rax
	subq	%rax, %r14
	shlq	$4, %rax
	addq	%rax, %rdx
	movq	%rdx, 8(%rsp)
	xorl	%r15d, %r15d
	cmpq	$33, %r14
	jb	.LBB8_4
.LBB8_2:
	testl	%ebp, %ebp
	je	.LBB8_3
	movq	%r14, %rcx
	shrq	$3, %rcx
	movq	%rcx, %rax
	shlq	$6, %rax
	movq	8(%rsp), %rsi
	addq	%rsi, %rax
	imulq	$112, %rcx, %rdx
	addq	%rsi, %rdx
	cmpq	$64, %r14
	jae	.LBB8_45
	movq	8(%rsp), %r9
	movq	(%r9), %rcx
	movq	(%rax), %rsi
	cmpq	%rsi, %rcx
	setb	%dil
	movq	(%rdx), %r8
	cmpq	%r8, %rcx
	setb	%cl
	xorb	%dil, %cl
	cmpq	%r8, %rsi
	setb	%sil
	xorb	%dil, %sil
	cmovneq	%rdx, %rax
	testb	%cl, %cl
	cmovneq	%r9, %rax
	decl	%ebp
	subq	8(%rsp), %rax
	testq	%r15, %r15
	jne	.LBB8_57
	jmp	.LBB8_48
	.p2align	4
.LBB8_45:
	movq	8(%rsp), %rdi
	movq	%rax, %rsi
	callq	_RINvNtNtNtNtCs4NRVxsYgnAr_4core5slice4sort6shared5pivot11median3_recNtNtCs5Av9rWzHob7_3lib14identity_index3RunNCINvMB8_SB14_20sort_unstable_by_keyyNCINvMs0_B16_NtB16_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs_0E0EB18_
	decl	%ebp
	subq	8(%rsp), %rax
	testq	%r15, %r15
	je	.LBB8_48
.LBB8_57:
	movq	(%r15), %rcx
	movq	8(%rsp), %rdx
	cmpq	(%rdx,%rax), %rcx
	jae	.LBB8_58
.LBB8_48:
	movq	8(%rsp), %rsi
	movups	(%rsi), %xmm0
	movaps	%xmm0, 32(%rsp)
	movups	(%rsi,%rax), %xmm0
	movups	%xmm0, (%rsi)
	movaps	32(%rsp), %xmm0
	movups	%xmm0, (%rsi,%rax)
	leaq	16(%rsi), %rax
	movups	16(%rsi), %xmm0
	movaps	%xmm0, 32(%rsp)
	movq	%r14, %rcx
	shlq	$4, %rcx
	leaq	(%rsi,%rcx), %r8
	addq	$-16, %r8
	leaq	32(%rsi), %rdx
	movq	(%rsi), %rdi
	cmpq	%r8, %rdx
	jae	.LBB8_49
	xorl	%esi, %esi
	.p2align	4
.LBB8_56:
	xorl	%r9d, %r9d
	cmpq	%rdi, (%rdx)
	setb	%r9b
	movq	%rsi, %r10
	shlq	$4, %r10
	movups	(%rax,%r10), %xmm0
	movups	%xmm0, -16(%rdx)
	movups	(%rdx), %xmm0
	movups	%xmm0, (%rax,%r10)
	leaq	(%rsi,%r9), %r10
	shlq	$4, %r10
	cmpq	%rdi, 16(%rdx)
	movups	(%rax,%r10), %xmm0
	movups	%xmm0, (%rdx)
	movups	16(%rdx), %xmm0
	movups	%xmm0, (%rax,%r10)
	adcq	%r9, %rsi
	addq	$32, %rdx
	cmpq	%r8, %rdx
	jb	.LBB8_56
	leaq	-16(%rdx), %r8
	jmp	.LBB8_51
	.p2align	4
.LBB8_49:
	movq	%rax, %r8
	xorl	%esi, %esi
.LBB8_51:
	addq	8(%rsp), %rcx
	.p2align	4
.LBB8_52:
	cmpq	%rcx, %rdx
	movq	%rdx, %r9
	cmoveq	%r13, %r9
	movq	%rsi, %r10
	shlq	$4, %r10
	cmpq	%rdi, (%r9)
	adcq	$0, %rsi
	movups	(%rax,%r10), %xmm0
	movups	%xmm0, (%r8)
	movups	(%r9), %xmm0
	movups	%xmm0, (%rax,%r10)
	cmpq	%rcx, %rdx
	movq	%rdx, %r8
	leaq	16(%rdx), %rdx
	jne	.LBB8_52
	cmpq	%r14, %rsi
	jae	.LBB8_37
	movq	%rsi, %rax
	shlq	$4, %rax
	movq	8(%rsp), %rdi
	leaq	(%rdi,%rax), %r12
	movups	(%rdi), %xmm0
	movaps	%xmm0, 32(%rsp)
	movups	(%rdi,%rax), %xmm0
	movups	%xmm0, (%rdi)
	movaps	32(%rsp), %xmm0
	movups	%xmm0, (%rdi,%rax)
	leaq	(%rdi,%rax), %rbx
	addq	$16, %rbx
	movq	%rsi, %rax
	notq	%rax
	addq	%rax, %r14
	movq	%r15, %rdx
	movl	%ebp, %ecx
	movq	16(%rsp), %r8
	callq	_RINvNtNtNtNtCs4NRVxsYgnAr_4core5slice4sort8unstable9quicksort9quicksortNtNtCs5Av9rWzHob7_3lib14identity_index3RunNCINvMB8_SB17_20sort_unstable_by_keyyNCINvMs0_B19_NtB19_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs_0E0EB1b_
	movq	%r12, %r15
	movq	%rbx, 8(%rsp)
	cmpq	$33, %r14
	jae	.LBB8_2
	jmp	.LBB8_4
	.p2align	4
.LBB8_58:
	movq	8(%rsp), %rdi
	addq	%rdi, %rax
	movups	(%rdi), %xmm0
	movaps	%xmm0, 32(%rsp)
	movups	(%rax), %xmm0
	movups	%xmm0, (%rdi)
	movaps	32(%rsp), %xmm0
	movups	%xmm0, (%rax)
	leaq	16(%rdi), %rcx
	movups	16(%rdi), %xmm0
	movaps	%xmm0, 32(%rsp)
	movq	%r14, %rdx
	shlq	$4, %rdx
	leaq	(%rdi,%rdx), %r8
	addq	$-16, %r8
	leaq	32(%rdi), %rsi
	movq	(%rdi), %rdi
	cmpq	%r8, %rsi
	jae	.LBB8_59
	xorl	%eax, %eax
	.p2align	4
.LBB8_67:
	movq	%rax, %r9
	shlq	$4, %r9
	cmpq	(%rsi), %rdi
	movups	(%rcx,%r9), %xmm0
	movups	%xmm0, -16(%rsi)
	movups	(%rsi), %xmm0
	movups	%xmm0, (%rcx,%r9)
	sbbq	$-1, %rax
	movq	%rax, %r9
	shlq	$4, %r9
	cmpq	16(%rsi), %rdi
	movups	(%rcx,%r9), %xmm0
	movups	%xmm0, (%rsi)
	movups	16(%rsi), %xmm0
	movups	%xmm0, (%rcx,%r9)
	sbbq	$-1, %rax
	addq	$32, %rsi
	cmpq	%r8, %rsi
	jb	.LBB8_67
	leaq	-16(%rsi), %r8
	jmp	.LBB8_61
.LBB8_59:
	movq	%rcx, %r8
	xorl	%eax, %eax
.LBB8_61:
	addq	8(%rsp), %rdx
	.p2align	4
.LBB8_62:
	cmpq	%rdx, %rsi
	movq	%rsi, %r9
	cmoveq	%r13, %r9
	movq	%rax, %r10
	shlq	$4, %r10
	cmpq	(%r9), %rdi
	sbbq	$-1, %rax
	movups	(%rcx,%r10), %xmm0
	movups	%xmm0, (%r8)
	movups	(%r9), %xmm0
	movups	%xmm0, (%rcx,%r10)
	cmpq	%rdx, %rsi
	movq	%rsi, %r8
	leaq	16(%rsi), %rsi
	jne	.LBB8_62
	cmpq	%r14, %rax
	jb	.LBB8_64
.LBB8_37:
	ud2
.LBB8_3:
	movq	8(%rsp), %rdi
	movq	%r14, %rsi
	addq	$808, %rsp
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
	jmpq	*_RINvNtNtNtNtCs4NRVxsYgnAr_4core5slice4sort8unstable8heapsort8heapsortNtNtCs5Av9rWzHob7_3lib14identity_index3RunNCINvMB8_SB15_20sort_unstable_by_keyyNCINvMs0_B17_NtB17_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs_0E0EB19_@GOTPCREL(%rip)
.LBB8_6:
	.cfi_def_cfa_offset 864
	cmpq	$7, %r14
	jbe	.LBB8_8
	movq	8(%rsp), %rbx
	movq	16(%rbx), %rax
	movq	48(%rbx), %rcx
	xorl	%r8d, %r8d
	xorl	%esi, %esi
	cmpq	(%rbx), %rax
	setae	%r8b
	setb	%sil
	xorl	%edx, %edx
	cmpq	32(%rbx), %rcx
	setb	%dl
	shll	$4, %esi
	leaq	(%rbx,%rsi), %rcx
	shll	$4, %r8d
	leaq	(%rbx,%r8), %rax
	movl	%edx, %r9d
	shll	$4, %r9d
	leaq	(%rbx,%r9), %rdi
	addq	$32, %rdi
	xorl	$3, %edx
	shll	$4, %edx
	movq	32(%rbx,%r9), %r9
	movq	(%rbx,%rdx), %r10
	movq	(%rbx,%r8), %r8
	cmpq	%r8, %r10
	movq	%rax, %r11
	cmovbq	%rdi, %r11
	cmpq	(%rbx,%rsi), %r9
	cmovbq	%rcx, %r11
	cmovbq	%rdi, %rcx
	leaq	(%rbx,%rdx), %rdx
	cmovbq	%rax, %rdi
	cmpq	%r8, %r10
	cmovaeq	%rdx, %rax
	cmovbq	%rdx, %rdi
	movq	(%rdi), %rdx
	cmpq	(%r11), %rdx
	movq	%r11, %rdx
	cmovbq	%rdi, %rdx
	cmovbq	%r11, %rdi
	movups	(%rcx), %xmm0
	movaps	%xmm0, 32(%rsp)
	movups	(%rdx), %xmm0
	movaps	%xmm0, 48(%rsp)
	movups	(%rdi), %xmm0
	movq	%r12, %rcx
	shlq	$4, %rcx
	movq	16(%rbx,%rcx), %rdx
	movq	48(%rbx,%rcx), %rdi
	xorl	%r10d, %r10d
	xorl	%r8d, %r8d
	cmpq	(%rbx,%rcx), %rdx
	setae	%r10b
	setb	%r8b
	xorl	%esi, %esi
	cmpq	32(%rbx,%rcx), %rdi
	leaq	(%rbx,%rcx), %r9
	setb	%sil
	shll	$4, %r8d
	shll	$4, %r10d
	leaq	(%r9,%r10), %rdx
	movl	%esi, %r11d
	shll	$4, %r11d
	leaq	(%r11,%r9), %rdi
	addq	$32, %rdi
	xorl	$3, %esi
	shll	$4, %esi
	movq	(%rsi,%r9), %r15
	movq	(%r10,%r9), %r10
	cmpq	%r10, %r15
	movq	%rdx, %r13
	cmovbq	%rdi, %r13
	movq	32(%r9,%r11), %r11
	cmpq	(%r8,%r9), %r11
	leaq	(%r9,%r8), %r8
	cmovbq	%r8, %r13
	cmovbq	%rdi, %r8
	leaq	(%r9,%rsi), %rsi
	cmovbq	%rdx, %rdi
	cmpq	%r10, %r15
	cmovaeq	%rsi, %rdx
	cmovbq	%rsi, %rdi
	movaps	%xmm0, 64(%rsp)
	movq	(%rdi), %rsi
	cmpq	(%r13), %rsi
	movups	(%rax), %xmm0
	movq	%r13, %rax
	cmovbq	%rdi, %rax
	movaps	%xmm0, 80(%rsp)
	cmovbq	%r13, %rdi
	movups	(%r8), %xmm0
	movups	%xmm0, 32(%rsp,%rcx)
	movups	(%rax), %xmm0
	movups	%xmm0, 48(%rsp,%rcx)
	movups	(%rdi), %xmm0
	movups	%xmm0, 64(%rsp,%rcx)
	movups	(%rdx), %xmm0
	movups	%xmm0, 80(%rsp,%rcx)
	movl	$4, %ecx
	movq	%r14, %rdx
	subq	%r12, %rdx
	cmpq	%r12, %rcx
	jb	.LBB8_10
	jmp	.LBB8_15
.LBB8_8:
	movq	8(%rsp), %rcx
	movups	(%rcx), %xmm0
	movaps	%xmm0, 32(%rsp)
	movq	%r12, %rax
	shlq	$4, %rax
	movups	(%rcx,%rax), %xmm0
	movups	%xmm0, 32(%rsp,%rax)
	movl	$1, %ecx
	movq	%r14, %rdx
	subq	%r12, %rdx
	cmpq	%r12, %rcx
	jae	.LBB8_15
.LBB8_10:
	movl	%ecx, %eax
	shll	$4, %eax
	leaq	32(%rsp), %rsi
	movq	%rcx, %rdi
	jmp	.LBB8_11
	.p2align	4
.LBB8_14:
	movq	%rsi, %r10
.LBB8_41:
	movq	%r8, (%r10)
	movq	%r9, 8(%r10)
.LBB8_42:
	incq	%rdi
	addq	$16, %rax
	cmpq	%r12, %rdi
	je	.LBB8_15
.LBB8_11:
	movq	%rdi, %r9
	shlq	$4, %r9
	movq	8(%rsp), %r8
	movups	(%r8,%r9), %xmm0
	movups	%xmm0, 32(%rsp,%r9)
	movq	32(%rsp,%r9), %r8
	cmpq	16(%rsp,%r9), %r8
	jae	.LBB8_42
	addq	%rsp, %r9
	addq	$32, %r9
	movq	8(%r9), %r9
	movq	%rax, %r10
	.p2align	4
.LBB8_13:
	movups	16(%rsp,%r10), %xmm0
	movups	%xmm0, 32(%rsp,%r10)
	cmpq	$16, %r10
	je	.LBB8_14
	leaq	-16(%r10), %r11
	cmpq	(%rsp,%r10), %r8
	movq	%r11, %r10
	jb	.LBB8_13
	leaq	(%rsp,%r11), %r10
	addq	$32, %r10
	jmp	.LBB8_41
.LBB8_15:
	movq	%r12, %rsi
	shlq	$4, %rsi
	leaq	(%rsp,%rsi), %rax
	addq	$32, %rax
	cmpq	%rdx, %rcx
	jae	.LBB8_25
	addq	8(%rsp), %rsi
	movl	%ecx, %edi
	shll	$4, %edi
	jmp	.LBB8_17
	.p2align	4
.LBB8_20:
	movq	%rax, %r10
.LBB8_23:
	movq	%r8, (%r10)
	movq	%r9, 8(%r10)
.LBB8_24:
	incq	%rcx
	addq	$16, %rdi
	cmpq	%rdx, %rcx
	je	.LBB8_25
.LBB8_17:
	movq	%rcx, %r9
	shlq	$4, %r9
	movups	(%rsi,%r9), %xmm0
	movups	%xmm0, (%rax,%r9)
	movq	(%rax,%r9), %r8
	cmpq	-16(%rax,%r9), %r8
	jae	.LBB8_24
	addq	%rax, %r9
	movq	8(%r9), %r9
	movq	%rdi, %r11
	.p2align	4
.LBB8_19:
	movups	-16(%rax,%r11), %xmm0
	movups	%xmm0, (%rax,%r11)
	cmpq	$16, %r11
	je	.LBB8_20
	leaq	-16(%r11), %r10
	cmpq	-32(%rax,%r11), %r8
	movq	%r10, %r11
	jb	.LBB8_19
	addq	%rax, %r10
	jmp	.LBB8_23
.LBB8_25:
	movq	%r14, 16(%rsp)
	shlq	$4, %r14
	movq	8(%rsp), %rdi
	leaq	(%rdi,%r14), %r8
	addq	$-16, %r8
	movq	%r14, 24(%rsp)
	leaq	(%rsp,%r14), %rsi
	addq	$16, %rsi
	leaq	-16(%rax), %rcx
	leaq	32(%rsp), %rdx
	jmp	.LBB8_26
	.p2align	4
.LBB8_30:
	movb	%r15b, %r10b
	movl	$0, %r14d
	sbbq	%r14, %r14
	shll	$4, %r10d
	addq	%r10, %rax
	movb	%bpl, %r9b
	shll	$4, %r9d
	addq	%r9, %rdx
	addq	$16, %rdi
	movups	(%r13), %xmm0
	movups	%xmm0, (%r8)
	shlq	$4, %r11
	addq	%r11, %rsi
	shlq	$4, %r14
	addq	%r14, %rcx
	addq	$-16, %r8
	movq	%rbx, %r12
	decq	%r12
	je	.LBB8_31
.LBB8_26:
	movq	%r12, %rbx
	movq	(%rax), %r15
	xorl	%r9d, %r9d
	xorl	%r10d, %r10d
	movq	%rax, %r11
	cmpq	(%rdx), %r15
	setae	%bpl
	setb	%r15b
	jb	.LBB8_28
	movq	%rdx, %r11
.LBB8_28:
	movups	(%r11), %xmm0
	movups	%xmm0, (%rdi)
	movq	(%rsi), %r14
	movq	(%rcx), %r12
	cmpq	%r12, %r14
	movl	$0, %r11d
	adcq	$-1, %r11
	movq	%rcx, %r13
	cmpq	%r12, %r14
	jb	.LBB8_30
	movq	%rsi, %r13
	jmp	.LBB8_30
.LBB8_31:
	addq	$16, %rcx
	addq	$16, %rsi
	testb	$1, 16(%rsp)
	jne	.LBB8_32
	cmpq	%rsi, %rax
	setne	%al
	cmpq	%rcx, %rdx
	jne	.LBB8_34
.LBB8_35:
	testb	%al, %al
	jne	.LBB8_36
.LBB8_43:
	addq	$808, %rsp
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
.LBB8_32:
	.cfi_def_cfa_offset 864
	xorl	%r8d, %r8d
	xorl	%r9d, %r9d
	cmpq	%rcx, %rdx
	setae	%r8b
	setb	%r9b
	movq	%rax, %r10
	cmovbq	%rdx, %r10
	movups	(%r10), %xmm0
	movups	%xmm0, (%rdi)
	shll	$4, %r9d
	addq	%r9, %rdx
	shll	$4, %r8d
	addq	%r8, %rax
	cmpq	%rsi, %rax
	setne	%al
	cmpq	%rcx, %rdx
	je	.LBB8_35
.LBB8_34:
	movb	$1, %al
	testb	%al, %al
	je	.LBB8_43
.LBB8_36:
.Ltmp0:
	callq	*_RNvNtNtNtNtCs4NRVxsYgnAr_4core5slice4sort6shared9smallsort22panic_on_ord_violation@GOTPCREL(%rip)
.Ltmp1:
	jmp	.LBB8_37
.LBB8_38:
.Ltmp2:
	movq	%rax, %r14
	leaq	32(%rsp), %rsi
	movq	8(%rsp), %rdi
	movq	24(%rsp), %rdx
	callq	*memcpy@GOTPCREL(%rip)
	movq	%r14, %rdi
	callq	_Unwind_Resume@PLT
.Lfunc_end8:
	.size	_RINvNtNtNtNtCs4NRVxsYgnAr_4core5slice4sort8unstable9quicksort9quicksortNtNtCs5Av9rWzHob7_3lib14identity_index3RunNCINvMB8_SB17_20sort_unstable_by_keyyNCINvMs0_B19_NtB19_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs_0E0EB1b_, .Lfunc_end8-_RINvNtNtNtNtCs4NRVxsYgnAr_4core5slice4sort8unstable9quicksort9quicksortNtNtCs5Av9rWzHob7_3lib14identity_index3RunNCINvMB8_SB17_20sort_unstable_by_keyyNCINvMs0_B19_NtB19_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs_0E0EB1b_
	.cfi_endproc
	.section	.gcc_except_table._RINvNtNtNtNtCs4NRVxsYgnAr_4core5slice4sort8unstable9quicksort9quicksortNtNtCs5Av9rWzHob7_3lib14identity_index3RunNCINvMB8_SB17_20sort_unstable_by_keyyNCINvMs0_B19_NtB19_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs_0E0EB1b_,"a",@progbits
	.p2align	2, 0x0
GCC_except_table8:
.Lexception0:
	.byte	255
	.byte	255
	.byte	1
	.uleb128 .Lcst_end0-.Lcst_begin0
.Lcst_begin0:
	.uleb128 .Lfunc_begin0-.Lfunc_begin0
	.uleb128 .Ltmp0-.Lfunc_begin0
	.byte	0
	.byte	0
	.uleb128 .Ltmp0-.Lfunc_begin0
	.uleb128 .Ltmp1-.Ltmp0
	.uleb128 .Ltmp2-.Lfunc_begin0
	.byte	0
	.uleb128 .Ltmp1-.Lfunc_begin0
	.uleb128 .Lfunc_end8-.Ltmp1
	.byte	0
	.byte	0
.Lcst_end0:
	.p2align	2, 0x0

	.section	.text._RINvNtNtNtNtCs4NRVxsYgnAr_4core5slice4sort8unstable9quicksort9quicksortNtNtCs5Av9rWzHob7_3lib14identity_index5EntryNCINvMB8_SB17_20sort_unstable_by_keyyNCINvMs0_B19_NtB19_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs1_0E0EB1b_,"ax",@progbits
	.p2align	4
	.type	_RINvNtNtNtNtCs4NRVxsYgnAr_4core5slice4sort8unstable9quicksort9quicksortNtNtCs5Av9rWzHob7_3lib14identity_index5EntryNCINvMB8_SB17_20sort_unstable_by_keyyNCINvMs0_B19_NtB19_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs1_0E0EB1b_,@function
_RINvNtNtNtNtCs4NRVxsYgnAr_4core5slice4sort8unstable9quicksort9quicksortNtNtCs5Av9rWzHob7_3lib14identity_index5EntryNCINvMB8_SB17_20sort_unstable_by_keyyNCINvMs0_B19_NtB19_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs1_0E0EB1b_:
.Lfunc_begin1:
	.cfi_startproc
	.cfi_personality 155, DW.ref.rust_eh_personality
	.cfi_lsda 27, .Lexception1
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
	subq	$600, %rsp
	.cfi_def_cfa_offset 656
	.cfi_offset %rbx, -56
	.cfi_offset %r12, -48
	.cfi_offset %r13, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	.cfi_offset %rbp, -16
	movq	%r8, 8(%rsp)
	movq	%rsi, %rbx
	movq	%rdi, %r14
	cmpq	$33, %rsi
	jae	.LBB9_1
.LBB9_4:
	cmpq	$2, %rbx
	jb	.LBB9_39
	movq	%rbx, %r15
	shrq	%r15
	leaq	(%rbx,%rbx,2), %r12
	cmpq	$15, %rbx
	jbe	.LBB9_6
	leaq	(%rsp,%r12,4), %rdx
	addq	$24, %rdx
	leaq	24(%rsp), %rsi
	movq	%r14, %rdi
	callq	_RINvNtNtNtNtCs4NRVxsYgnAr_4core5slice4sort6shared9smallsort12sort8_stableNtNtCs5Av9rWzHob7_3lib14identity_index5EntryNCINvMB8_SB19_20sort_unstable_by_keyyNCINvMs0_B1b_NtB1b_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs1_0E0EB1d_
	leaq	(,%r15,4), %rax
	leaq	(%rax,%rax,2), %rax
	leaq	(%r14,%rax), %rdi
	leaq	(%rsp,%rax), %rsi
	addq	$24, %rsi
	leaq	(%rsp,%r12,4), %rdx
	addq	$120, %rdx
	callq	_RINvNtNtNtNtCs4NRVxsYgnAr_4core5slice4sort6shared9smallsort12sort8_stableNtNtCs5Av9rWzHob7_3lib14identity_index5EntryNCINvMB8_SB19_20sort_unstable_by_keyyNCINvMs0_B1b_NtB1b_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs1_0E0EB1d_
	movl	$8, %ecx
	movq	%rbx, %rdx
	subq	%r15, %rdx
	cmpq	%r15, %rcx
	jb	.LBB9_10
	jmp	.LBB9_15
.LBB9_1:
	movl	%ecx, %r12d
	movq	%rdx, %r9
	leaq	24(%rsp), %r13
	jmp	.LBB9_2
	.p2align	4
.LBB9_60:
	movq	%r15, %rbx
	leaq	(%rax,%rax,2), %rcx
	movl	8(%r14), %edx
	movl	%edx, 32(%rsp)
	movq	(%r14), %rdx
	movq	%rdx, 24(%rsp)
	movl	8(%r14,%rcx,4), %edx
	movq	(%r14,%rcx,4), %rsi
	movq	%rsi, (%r14)
	movl	%edx, 8(%r14)
	movl	32(%rsp), %edx
	movl	%edx, 8(%r14,%rcx,4)
	movq	24(%rsp), %rdx
	movq	%rdx, (%r14,%rcx,4)
	notq	%rax
	addq	%rax, %rbx
	leaq	(%r14,%rcx,4), %r14
	addq	$12, %r14
	xorl	%r9d, %r9d
	cmpq	$33, %rbx
	jb	.LBB9_4
.LBB9_2:
	testl	%r12d, %r12d
	je	.LBB9_3
	movq	%rbx, %rcx
	shrq	$3, %rcx
	leaq	(%rcx,%rcx,2), %rax
	shlq	$4, %rax
	addq	%r14, %rax
	imulq	$84, %rcx, %rdx
	addq	%r14, %rdx
	cmpq	$64, %rbx
	jae	.LBB9_41
	movq	(%r14), %rcx
	movq	(%rax), %rsi
	cmpq	%rsi, %rcx
	setb	%dil
	movq	(%rdx), %r8
	cmpq	%r8, %rcx
	setb	%cl
	xorb	%dil, %cl
	cmpq	%r8, %rsi
	setb	%sil
	xorb	%dil, %sil
	cmovneq	%rdx, %rax
	testb	%cl, %cl
	cmovneq	%r14, %rax
	decl	%r12d
	subq	%r14, %rax
	testq	%r9, %r9
	jne	.LBB9_53
	jmp	.LBB9_44
	.p2align	4
.LBB9_41:
	movq	%r14, %rdi
	movq	%rax, %rsi
	movq	%r9, %r15
	callq	_RINvNtNtNtNtCs4NRVxsYgnAr_4core5slice4sort6shared5pivot11median3_recNtNtCs5Av9rWzHob7_3lib14identity_index5EntryNCINvMB8_SB14_20sort_unstable_by_keyyNCINvMs0_B16_NtB16_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs1_0E0EB18_
	movq	%r15, %r9
	decl	%r12d
	subq	%r14, %rax
	testq	%r9, %r9
	je	.LBB9_44
.LBB9_53:
	movq	(%r9), %rcx
	cmpq	(%r14,%rax), %rcx
	jae	.LBB9_54
.LBB9_44:
	movq	%r9, 16(%rsp)
	movl	8(%r14), %ecx
	movl	%ecx, 32(%rsp)
	movq	(%r14), %rcx
	movq	%rcx, 24(%rsp)
	movl	8(%r14,%rax), %ecx
	movq	(%r14,%rax), %rdx
	movq	%rdx, (%r14)
	movl	%ecx, 8(%r14)
	movl	32(%rsp), %ecx
	movl	%ecx, 8(%r14,%rax)
	movq	24(%rsp), %rcx
	movq	%rcx, (%r14,%rax)
	leaq	12(%r14), %rax
	movl	20(%r14), %ecx
	movl	%ecx, 32(%rsp)
	movq	12(%r14), %rcx
	movq	%rcx, 24(%rsp)
	leaq	(%rbx,%rbx,2), %rdi
	leaq	(%r14,%rdi,4), %r8
	addq	$-12, %r8
	leaq	24(%r14), %rcx
	movq	(%r14), %rdx
	cmpq	%r8, %rcx
	jae	.LBB9_45
	movq	%rbx, %rbp
	xorl	%esi, %esi
	.p2align	4
.LBB9_52:
	movq	(%rcx), %r9
	xorl	%r10d, %r10d
	cmpq	%rdx, %r9
	setb	%r10b
	leaq	(%rsi,%rsi,2), %r11
	movl	8(%rax,%r11,4), %r15d
	movq	(%rax,%r11,4), %rbx
	movq	%rbx, -12(%rcx)
	movl	%r15d, -4(%rcx)
	movl	8(%rcx), %ebx
	movl	%ebx, 8(%rax,%r11,4)
	movq	%r9, (%rax,%r11,4)
	leaq	(%rsi,%r10), %r9
	movq	12(%rcx), %r11
	cmpq	%rdx, %r11
	leaq	(%r9,%r9,2), %r9
	movl	8(%rax,%r9,4), %ebx
	movq	(%rax,%r9,4), %r15
	movq	%r15, (%rcx)
	movl	%ebx, 8(%rcx)
	movl	20(%rcx), %ebx
	movl	%ebx, 8(%rax,%r9,4)
	movq	%r11, (%rax,%r9,4)
	adcq	%r10, %rsi
	addq	$24, %rcx
	cmpq	%r8, %rcx
	jb	.LBB9_52
	leaq	-12(%rcx), %r8
	movq	%rbp, %rbx
	jmp	.LBB9_47
	.p2align	4
.LBB9_45:
	movq	%rax, %r8
	xorl	%esi, %esi
.LBB9_47:
	leaq	(%r14,%rdi,4), %rdi
	.p2align	4
.LBB9_48:
	cmpq	%rdi, %rcx
	movq	%rcx, %r9
	cmoveq	%r13, %r9
	cmpq	%rdx, (%r9)
	leaq	(%rsi,%rsi,2), %r10
	adcq	$0, %rsi
	movq	(%rax,%r10,4), %r11
	movl	8(%rax,%r10,4), %r15d
	movl	%r15d, 8(%r8)
	movq	%r11, (%r8)
	movl	8(%r9), %r8d
	movl	%r8d, 8(%rax,%r10,4)
	movq	(%r9), %r8
	movq	%r8, (%rax,%r10,4)
	cmpq	%rdi, %rcx
	movq	%rcx, %r8
	leaq	12(%rcx), %rcx
	jne	.LBB9_48
	cmpq	%rbx, %rsi
	jae	.LBB9_33
	movq	%rbx, %rbp
	leaq	(%rsi,%rsi,2), %rax
	leaq	(%r14,%rax,4), %rbx
	movl	8(%r14), %ecx
	movl	%ecx, 32(%rsp)
	movq	(%r14), %rcx
	movq	%rcx, 24(%rsp)
	movl	8(%r14,%rax,4), %ecx
	movq	(%r14,%rax,4), %rdx
	movq	%rdx, (%r14)
	movl	%ecx, 8(%r14)
	movl	32(%rsp), %ecx
	movl	%ecx, 8(%r14,%rax,4)
	movq	24(%rsp), %rcx
	movq	%rcx, (%r14,%rax,4)
	leaq	(%r14,%rax,4), %r15
	addq	$12, %r15
	movq	%rsi, %rax
	notq	%rax
	addq	%rax, %rbp
	movq	%r14, %rdi
	movq	16(%rsp), %rdx
	movl	%r12d, %ecx
	movq	8(%rsp), %r8
	callq	_RINvNtNtNtNtCs4NRVxsYgnAr_4core5slice4sort8unstable9quicksort9quicksortNtNtCs5Av9rWzHob7_3lib14identity_index5EntryNCINvMB8_SB17_20sort_unstable_by_keyyNCINvMs0_B19_NtB19_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs1_0E0EB1b_
	movq	%rbx, %r9
	movq	%r15, %r14
	movq	%rbp, %rbx
	cmpq	$33, %rbx
	jae	.LBB9_2
	jmp	.LBB9_4
	.p2align	4
.LBB9_54:
	addq	%r14, %rax
	movl	8(%r14), %ecx
	movl	%ecx, 32(%rsp)
	movq	(%r14), %rcx
	movq	%rcx, 24(%rsp)
	movl	8(%rax), %ecx
	movq	(%rax), %rdx
	movq	%rdx, (%r14)
	movl	%ecx, 8(%r14)
	movl	32(%rsp), %ecx
	movl	%ecx, 8(%rax)
	movq	24(%rsp), %rcx
	movq	%rcx, (%rax)
	leaq	12(%r14), %rcx
	movl	20(%r14), %eax
	movl	%eax, 32(%rsp)
	movq	12(%r14), %rax
	movq	%rax, 24(%rsp)
	movq	%rbx, %r15
	leaq	(%rbx,%rbx,2), %rdi
	leaq	(%r14,%rdi,4), %r8
	addq	$-12, %r8
	leaq	24(%r14), %rdx
	movq	(%r14), %rsi
	cmpq	%r8, %rdx
	jae	.LBB9_55
	xorl	%eax, %eax
	.p2align	4
.LBB9_63:
	movq	(%rdx), %r9
	cmpq	%r9, %rsi
	leaq	(%rax,%rax,2), %r10
	movl	8(%rcx,%r10,4), %r11d
	movq	(%rcx,%r10,4), %rbx
	movq	%rbx, -12(%rdx)
	movl	%r11d, -4(%rdx)
	movl	8(%rdx), %r11d
	movl	%r11d, 8(%rcx,%r10,4)
	movq	%r9, (%rcx,%r10,4)
	sbbq	$-1, %rax
	movq	12(%rdx), %r9
	cmpq	%r9, %rsi
	leaq	(%rax,%rax,2), %r10
	movl	8(%rcx,%r10,4), %r11d
	movq	(%rcx,%r10,4), %rbx
	movq	%rbx, (%rdx)
	movl	%r11d, 8(%rdx)
	movl	20(%rdx), %r11d
	movl	%r11d, 8(%rcx,%r10,4)
	movq	%r9, (%rcx,%r10,4)
	sbbq	$-1, %rax
	addq	$24, %rdx
	cmpq	%r8, %rdx
	jb	.LBB9_63
	leaq	-12(%rdx), %r8
	jmp	.LBB9_57
.LBB9_55:
	movq	%rcx, %r8
	xorl	%eax, %eax
.LBB9_57:
	leaq	(%r14,%rdi,4), %rdi
	.p2align	4
.LBB9_58:
	cmpq	%rdi, %rdx
	movq	%rdx, %r9
	cmoveq	%r13, %r9
	cmpq	(%r9), %rsi
	leaq	(%rax,%rax,2), %r10
	sbbq	$-1, %rax
	movq	(%rcx,%r10,4), %r11
	movl	8(%rcx,%r10,4), %ebx
	movl	%ebx, 8(%r8)
	movq	%r11, (%r8)
	movl	8(%r9), %r8d
	movl	%r8d, 8(%rcx,%r10,4)
	movq	(%r9), %r8
	movq	%r8, (%rcx,%r10,4)
	cmpq	%rdi, %rdx
	movq	%rdx, %r8
	leaq	12(%rdx), %rdx
	jne	.LBB9_58
	cmpq	%r15, %rax
	jb	.LBB9_60
.LBB9_33:
	ud2
.LBB9_3:
	movq	%r14, %rdi
	movq	%rbx, %rsi
	addq	$600, %rsp
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
	jmpq	*_RINvNtNtNtNtCs4NRVxsYgnAr_4core5slice4sort8unstable8heapsort8heapsortNtNtCs5Av9rWzHob7_3lib14identity_index5EntryNCINvMB8_SB15_20sort_unstable_by_keyyNCINvMs0_B17_NtB17_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs1_0E0EB19_@GOTPCREL(%rip)
.LBB9_6:
	.cfi_def_cfa_offset 656
	cmpq	$7, %rbx
	jbe	.LBB9_8
	movq	12(%r14), %rax
	movq	36(%r14), %rcx
	xorl	%edi, %edi
	xorl	%edx, %edx
	cmpq	(%r14), %rax
	setae	%dil
	setb	%dl
	leaq	36(%r14), %rsi
	leaq	24(%r14), %r8
	cmpq	24(%r14), %rcx
	leaq	(%rdx,%rdx,2), %r9
	leaq	(%r14,%r9,4), %rdx
	leaq	(%rdi,%rdi,2), %rdi
	movq	%r8, %rcx
	cmovbq	%rsi, %rcx
	leaq	(%r14,%rdi,4), %rax
	cmovbq	%r8, %rsi
	movq	(%rcx), %r8
	movq	(%rsi), %r10
	movq	(%r14,%rdi,4), %rdi
	cmpq	%rdi, %r10
	movq	%rax, %r11
	cmovbq	%rcx, %r11
	cmpq	(%r14,%r9,4), %r8
	cmovbq	%rdx, %r11
	cmovbq	%rcx, %rdx
	cmovbq	%rax, %rcx
	cmpq	%rdi, %r10
	cmovaeq	%rsi, %rax
	cmovbq	%rsi, %rcx
	movq	(%rcx), %rsi
	cmpq	(%r11), %rsi
	movq	%r11, %rsi
	cmovbq	%rcx, %rsi
	cmovbq	%r11, %rcx
	movl	8(%rdx), %edi
	movl	%edi, 32(%rsp)
	movq	(%rdx), %rdx
	movq	%rdx, 24(%rsp)
	movl	8(%rsi), %edx
	movl	%edx, 44(%rsp)
	movq	(%rsi), %rdx
	movq	%rdx, 36(%rsp)
	movl	8(%rcx), %edx
	movl	%edx, 56(%rsp)
	movq	(%rcx), %rcx
	movq	%rcx, 48(%rsp)
	leaq	(,%r15,4), %rcx
	leaq	(%rcx,%rcx,2), %rcx
	leaq	(%r14,%rcx), %r8
	movq	12(%r14,%rcx), %rdx
	movq	36(%r14,%rcx), %rsi
	xorl	%r9d, %r9d
	xorl	%r10d, %r10d
	cmpq	(%r14,%rcx), %rdx
	setae	%r9b
	setb	%r10b
	leaq	(%r14,%rcx), %rdi
	addq	$36, %rdi
	leaq	(%r14,%rcx), %r11
	addq	$24, %r11
	cmpq	24(%r14,%rcx), %rsi
	leaq	(%r10,%r10,2), %r10
	leaq	(%r9,%r9,2), %r9
	leaq	(%r8,%r9,4), %rdx
	movq	%r11, %rsi
	cmovbq	%rdi, %rsi
	cmovbq	%r11, %rdi
	movq	(%rdi), %r11
	movq	(%r8,%r9,4), %r9
	cmpq	%r9, %r11
	movq	%rdx, %r13
	cmovbq	%rsi, %r13
	movq	(%rsi), %rbp
	cmpq	(%r8,%r10,4), %rbp
	leaq	(%r8,%r10,4), %r8
	cmovbq	%r8, %r13
	cmovbq	%rsi, %r8
	movl	8(%rax), %r10d
	cmovbq	%rdx, %rsi
	cmpq	%r9, %r11
	cmovaeq	%rdi, %rdx
	cmovbq	%rdi, %rsi
	movl	%r10d, 68(%rsp)
	movq	(%rsi), %rdi
	cmpq	(%r13), %rdi
	movq	(%rax), %rax
	movq	%r13, %rdi
	cmovbq	%rsi, %rdi
	movq	%rax, 60(%rsp)
	cmovbq	%r13, %rsi
	movl	8(%r8), %eax
	movl	%eax, 32(%rsp,%rcx)
	movq	(%r8), %rax
	movq	%rax, 24(%rsp,%rcx)
	movq	(%rdi), %rax
	movq	%rax, 36(%rsp,%rcx)
	movl	8(%rdi), %eax
	movl	%eax, 44(%rsp,%rcx)
	movq	(%rsi), %rax
	movq	%rax, 48(%rsp,%rcx)
	movl	8(%rsi), %eax
	movl	%eax, 56(%rsp,%rcx)
	movq	(%rdx), %rax
	movq	%rax, 60(%rsp,%rcx)
	movl	8(%rdx), %eax
	movl	%eax, 68(%rsp,%rcx)
	movl	$4, %ecx
	movq	%rbx, %rdx
	subq	%r15, %rdx
	cmpq	%r15, %rcx
	jb	.LBB9_10
	jmp	.LBB9_15
.LBB9_8:
	movl	8(%r14), %eax
	movl	%eax, 32(%rsp)
	movq	(%r14), %rax
	movq	%rax, 24(%rsp)
	leaq	(,%r15,4), %rax
	leaq	(%rax,%rax,2), %rax
	movl	8(%r14,%rax), %ecx
	movl	%ecx, 32(%rsp,%rax)
	movq	(%r14,%rax), %rcx
	movq	%rcx, 24(%rsp,%rax)
	movl	$1, %ecx
	movq	%rbx, %rdx
	subq	%r15, %rdx
	cmpq	%r15, %rcx
	jae	.LBB9_15
.LBB9_10:
	leal	(,%rcx,4), %eax
	leaq	(%rax,%rax,2), %rax
	leaq	24(%rsp), %rsi
	movq	%rcx, %rdi
	jmp	.LBB9_11
	.p2align	4
.LBB9_14:
	movq	%rsi, %r10
.LBB9_37:
	movq	%r8, (%r10)
	movl	%r9d, 8(%r10)
.LBB9_38:
	incq	%rdi
	addq	$12, %rax
	cmpq	%r15, %rdi
	je	.LBB9_15
.LBB9_11:
	leaq	(,%rdi,4), %r8
	leaq	(%r8,%r8,2), %r9
	movl	8(%r14,%r9), %r8d
	movl	%r8d, 32(%rsp,%r9)
	movq	(%r14,%r9), %r8
	movq	%r8, 24(%rsp,%r9)
	cmpq	12(%rsp,%r9), %r8
	jae	.LBB9_38
	addq	%rsp, %r9
	addq	$24, %r9
	movl	8(%r9), %r9d
	movq	%rax, %r10
	.p2align	4
.LBB9_13:
	movl	20(%rsp,%r10), %r11d
	movl	%r11d, 32(%rsp,%r10)
	movq	12(%rsp,%r10), %r11
	movq	%r11, 24(%rsp,%r10)
	cmpq	$12, %r10
	je	.LBB9_14
	leaq	-12(%r10), %r11
	cmpq	(%rsp,%r10), %r8
	movq	%r11, %r10
	jb	.LBB9_13
	leaq	(%rsp,%r11), %r10
	addq	$24, %r10
	jmp	.LBB9_37
.LBB9_15:
	leaq	(,%r15,4), %rax
	leaq	(%rax,%rax,2), %rsi
	leaq	(%rsp,%rsi), %rax
	addq	$24, %rax
	cmpq	%rdx, %rcx
	jae	.LBB9_25
	addq	%r14, %rsi
	leal	(,%rcx,4), %edi
	leaq	(%rdi,%rdi,2), %rdi
	jmp	.LBB9_17
	.p2align	4
.LBB9_20:
	movq	%rax, %r11
.LBB9_23:
	movq	%r8, (%r11)
	movl	%r9d, 8(%r11)
.LBB9_24:
	incq	%rcx
	addq	$12, %rdi
	cmpq	%rdx, %rcx
	je	.LBB9_25
.LBB9_17:
	leaq	(,%rcx,4), %r8
	leaq	(%r8,%r8,2), %r9
	movl	8(%rsi,%r9), %r8d
	movl	%r8d, 8(%rax,%r9)
	movq	(%rsi,%r9), %r8
	movq	%r8, (%rax,%r9)
	cmpq	-12(%rax,%r9), %r8
	jae	.LBB9_24
	addq	%rax, %r9
	movl	8(%r9), %r9d
	movq	%rdi, %r10
	.p2align	4
.LBB9_19:
	movl	-4(%rax,%r10), %r11d
	movl	%r11d, 8(%rax,%r10)
	movq	-12(%rax,%r10), %r11
	movq	%r11, (%rax,%r10)
	cmpq	$12, %r10
	je	.LBB9_20
	leaq	-12(%r10), %r11
	cmpq	-24(%rax,%r10), %r8
	movq	%r11, %r10
	jb	.LBB9_19
	addq	%rax, %r11
	jmp	.LBB9_23
.LBB9_25:
	leaq	(%r14,%r12,4), %r8
	addq	$-12, %r8
	leaq	(%rsp,%r12,4), %rdx
	addq	$12, %rdx
	leaq	-12(%rax), %rcx
	leaq	24(%rsp), %rsi
	movq	%r14, %rdi
	.p2align	4
.LBB9_26:
	movq	%rax, %r9
	movq	%rsi, %r10
	movq	(%rax), %rsi
	addq	$12, %rax
	cmpq	(%r10), %rsi
	leaq	12(%r10), %rsi
	cmovbq	%r10, %rsi
	cmovbq	%r9, %r10
	movl	8(%r10), %r11d
	movl	%r11d, 8(%rdi)
	cmovaeq	%r9, %rax
	movq	(%rdx), %r9
	movq	(%rcx), %r11
	cmpq	%r11, %r9
	movl	$0, %r12d
	adcq	$-1, %r12
	cmpq	%r11, %r9
	movq	%rdx, %r9
	cmovbq	%rcx, %r9
	movq	(%r10), %r10
	movl	$0, %r11d
	sbbq	%r11, %r11
	movq	%r10, (%rdi)
	addq	$12, %rdi
	movl	8(%r9), %r10d
	movl	%r10d, 8(%r8)
	movq	(%r9), %r9
	movq	%r9, (%r8)
	leaq	(%r12,%r12,2), %r9
	leaq	(%rdx,%r9,4), %rdx
	leaq	(%r11,%r11,2), %r9
	leaq	(%rcx,%r9,4), %rcx
	addq	$-12, %r8
	decq	%r15
	jne	.LBB9_26
	addq	$12, %rcx
	addq	$12, %rdx
	testb	$1, %bl
	jne	.LBB9_28
	cmpq	%rdx, %rax
	setne	%al
	cmpq	%rcx, %rsi
	jne	.LBB9_30
.LBB9_31:
	testb	%al, %al
	jne	.LBB9_32
.LBB9_39:
	addq	$600, %rsp
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
.LBB9_28:
	.cfi_def_cfa_offset 656
	leaq	12(%rsi), %r8
	leaq	12(%rax), %r9
	cmpq	%rcx, %rsi
	movq	%rax, %r10
	cmovbq	%rsi, %r10
	movl	8(%r10), %r11d
	movl	%r11d, 8(%rdi)
	movq	(%r10), %r10
	movq	%r10, (%rdi)
	cmovbq	%r8, %rsi
	cmovaeq	%r9, %rax
	cmpq	%rdx, %rax
	setne	%al
	cmpq	%rcx, %rsi
	je	.LBB9_31
.LBB9_30:
	movb	$1, %al
	testb	%al, %al
	je	.LBB9_39
.LBB9_32:
.Ltmp3:
	callq	*_RNvNtNtNtNtCs4NRVxsYgnAr_4core5slice4sort6shared9smallsort22panic_on_ord_violation@GOTPCREL(%rip)
.Ltmp4:
	jmp	.LBB9_33
.LBB9_34:
.Ltmp5:
	movq	%rax, %r15
	shlq	$2, %rbx
	leaq	(%rbx,%rbx,2), %rdx
	leaq	24(%rsp), %rsi
	movq	%r14, %rdi
	callq	*memcpy@GOTPCREL(%rip)
	movq	%r15, %rdi
	callq	_Unwind_Resume@PLT
.Lfunc_end9:
	.size	_RINvNtNtNtNtCs4NRVxsYgnAr_4core5slice4sort8unstable9quicksort9quicksortNtNtCs5Av9rWzHob7_3lib14identity_index5EntryNCINvMB8_SB17_20sort_unstable_by_keyyNCINvMs0_B19_NtB19_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs1_0E0EB1b_, .Lfunc_end9-_RINvNtNtNtNtCs4NRVxsYgnAr_4core5slice4sort8unstable9quicksort9quicksortNtNtCs5Av9rWzHob7_3lib14identity_index5EntryNCINvMB8_SB17_20sort_unstable_by_keyyNCINvMs0_B19_NtB19_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs1_0E0EB1b_
	.cfi_endproc
	.section	.gcc_except_table._RINvNtNtNtNtCs4NRVxsYgnAr_4core5slice4sort8unstable9quicksort9quicksortNtNtCs5Av9rWzHob7_3lib14identity_index5EntryNCINvMB8_SB17_20sort_unstable_by_keyyNCINvMs0_B19_NtB19_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs1_0E0EB1b_,"a",@progbits
	.p2align	2, 0x0
GCC_except_table9:
.Lexception1:
	.byte	255
	.byte	255
	.byte	1
	.uleb128 .Lcst_end1-.Lcst_begin1
.Lcst_begin1:
	.uleb128 .Lfunc_begin1-.Lfunc_begin1
	.uleb128 .Ltmp3-.Lfunc_begin1
	.byte	0
	.byte	0
	.uleb128 .Ltmp3-.Lfunc_begin1
	.uleb128 .Ltmp4-.Ltmp3
	.uleb128 .Ltmp5-.Lfunc_begin1
	.byte	0
	.uleb128 .Ltmp4-.Lfunc_begin1
	.uleb128 .Lfunc_end9-.Ltmp4
	.byte	0
	.byte	0
.Lcst_end1:
	.p2align	2, 0x0

	.section	.text._RNvCs5Av9rWzHob7_3lib11hole_lookup,"ax",@progbits
	.globl	_RNvCs5Av9rWzHob7_3lib11hole_lookup
	.p2align	4
	.type	_RNvCs5Av9rWzHob7_3lib11hole_lookup,@function
_RNvCs5Av9rWzHob7_3lib11hole_lookup:
.Lfunc_begin2:
	.cfi_startproc
	.cfi_personality 155, DW.ref.rust_eh_personality
	.cfi_lsda 27, .Lexception2
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
	subq	$72, %rsp
	.cfi_def_cfa_offset 128
	.cfi_offset %rbx, -56
	.cfi_offset %r12, -48
	.cfi_offset %r13, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	.cfi_offset %rbp, -16
	cmpq	$100001, %rsi
	jae	.LBB10_171
	movq	%rcx, %rbx
	movq	%rdx, %r15
	movq	%rsi, %r14
	testq	%rsi, %rsi
	je	.LBB10_2
	movq	%rdi, %r13
	movq	(%rdi), %r12
	cmpq	$1, %r14
	jne	.LBB10_5
	movl	$1, %r14d
	xorl	%ecx, %ecx
	jmp	.LBB10_109
.LBB10_2:
	xorl	%ecx, %ecx
	xorl	%r12d, %r12d
	xorl	%r14d, %r14d
	jmp	.LBB10_109
.LBB10_5:
	leaq	(,%r14,8), %rdi
	movq	8(%r13), %rsi
	movq	%r12, %r8
	incq	%r8
	sete	%al
	cmpq	%rsi, %r8
	setne	%cl
	orb	%al, %cl
	movzbl	%cl, %edx
	xorl	%eax, %eax
	testb	%dl, %dl
	movq	%rsi, (%rsp)
	cmovneq	%rsi, %rax
	leaq	1(%rdx), %rbp
	cmpq	$2, %r14
	movq	%r15, 8(%rsp)
	movq	%rdi, 56(%rsp)
	je	.LBB10_14
	leaq	16(%r13), %rcx
	addq	$-24, %rdi
	je	.LBB10_7
	movq	%r8, 48(%rsp)
	shrq	$3, %rdi
	incq	%rdi
	movq	%rdi, %r8
	andq	$-2, %r8
	movl	$2, %r9d
	movq	(%rsp), %rsi
	.p2align	4
.LBB10_9:
	movq	(%rcx), %r10
	incq	%rsi
	sete	%r11b
	cmpq	%r10, %rsi
	movq	8(%rcx), %rsi
	setne	%r15b
	orb	%r11b, %r15b
	cmpq	$1, %rbp
	sete	%r11b
	testb	%r11b, %r15b
	movq	%rdx, %r11
	cmovneq	%r9, %r11
	cmovneq	%r10, %rax
	movzbl	%r15b, %r15d
	addq	%rbp, %r15
	addq	$16, %rcx
	incq	%r10
	sete	%dl
	cmpq	%rsi, %r10
	setne	%r10b
	orb	%dl, %r10b
	cmpq	$1, %r15
	sete	%bpl
	leaq	1(%r9), %rdx
	testb	%bpl, %r10b
	cmoveq	%r11, %rdx
	cmovneq	%rsi, %rax
	movzbl	%r10b, %ebp
	addq	%r15, %rbp
	cmpq	%r8, %r9
	leaq	2(%r9), %r9
	jne	.LBB10_9
	testb	$1, %dil
	jne	.LBB10_12
	movq	48(%rsp), %r8
	jmp	.LBB10_14
.LBB10_7:
	movl	$2, %r9d
	movq	(%rsp), %rsi
	jmp	.LBB10_13
.LBB10_12:
	movq	48(%rsp), %r8
.LBB10_13:
	movq	(%rcx), %rcx
	incq	%rsi
	sete	%dil
	cmpq	%rcx, %rsi
	setne	%sil
	orb	%dil, %sil
	cmpq	$1, %rbp
	sete	%dil
	testb	%dil, %sil
	cmovneq	%r9, %rdx
	cmovneq	%rcx, %rax
	movzbl	%sil, %ecx
	addq	%rcx, %rbp
.LBB10_14:
	cmpq	$2, %rbp
	je	.LBB10_17
	cmpq	$1, %rbp
	jne	.LBB10_22
	xorl	%ecx, %ecx
	movq	8(%rsp), %r15
	jmp	.LBB10_109
.LBB10_17:
	subq	%r12, %rax
	jb	.LBB10_22
	subq	%rdx, %rax
	jae	.LBB10_19
.LBB10_22:
	movq	%rbp, %rsi
	shlq	$4, %rsi
	leaq	(,%r14,4), %rax
	leaq	(%rax,%rax,2), %r15
	cmpq	%r15, %rsi
	jae	.LBB10_23
	movabsq	$1152921504606846972, %rax
	orq	$3, %rax
	cmpq	%rax, %rbp
	jbe	.LBB10_51
	xorl	%edi, %edi
.LBB10_50:
	callq	*_RNvNtCscdodAO9FK5_5alloc7raw_vec12handle_error@GOTPCREL(%rip)
.LBB10_23:
	callq	*_RNvCs9wFQrvczXsK_7___rustc35___rust_no_alloc_shim_is_unstable_v2@GOTPCREL(%rip)
	movl	$4, %esi
	movq	%r15, %rdi
	callq	*_RNvCs9wFQrvczXsK_7___rustc12___rust_alloc@GOTPCREL(%rip)
	testq	%rax, %rax
	movq	%r15, %rbp
	je	.LBB10_26
	movq	%rax, %r12
	movl	%r14d, %ecx
	andl	$3, %ecx
	cmpq	$4, %r14
	movq	8(%rsp), %r15
	jae	.LBB10_27
	xorl	%eax, %eax
	jmp	.LBB10_30
.LBB10_27:
	movl	%r14d, %edx
	andl	$131068, %edx
	leaq	44(%r12), %rsi
	xorl	%eax, %eax
	.p2align	4
.LBB10_28:
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
	jne	.LBB10_28
	testq	%rcx, %rcx
	je	.LBB10_32
.LBB10_30:
	leaq	(%rax,%rax,2), %rdx
	leaq	(%r12,%rdx,4), %rdx
	addq	$8, %rdx
	shll	$2, %ecx
	leaq	(%rcx,%rcx,2), %rcx
	xorl	%esi, %esi
	.p2align	4
.LBB10_31:
	movq	(%r13,%rax,8), %rdi
	movq	%rdi, -8(%rdx,%rsi)
	movl	%eax, (%rdx,%rsi)
	incq	%rax
	addq	$12, %rsi
	cmpq	%rsi, %rcx
	jne	.LBB10_31
.LBB10_32:
	cmpq	$21, %r14
	jae	.LBB10_33
	leaq	(%r12,%rbp), %rax
	leaq	12(%r12), %rsi
	movl	$12, %ecx
	movq	%r12, %rdi
	jmp	.LBB10_40
	.p2align	4
.LBB10_43:
	movq	%r12, %r9
.LBB10_46:
	movq	%rsi, (%r9)
	movl	%edi, 8(%r9)
.LBB10_47:
	leaq	12(%rdx), %rsi
	addq	$12, %rcx
	movq	%rdx, %rdi
	cmpq	%rax, %rsi
	je	.LBB10_34
.LBB10_40:
	movq	%rsi, %rdx
	movq	12(%rdi), %rsi
	cmpq	(%rdi), %rsi
	jae	.LBB10_47
	movl	20(%rdi), %edi
	movq	%rcx, %r8
	.p2align	4
.LBB10_42:
	movl	-4(%r12,%r8), %r9d
	movl	%r9d, 8(%r12,%r8)
	movq	-12(%r12,%r8), %r9
	movq	%r9, (%r12,%r8)
	cmpq	$12, %r8
	je	.LBB10_43
	leaq	-12(%r8), %r9
	cmpq	-24(%r12,%r8), %rsi
	movq	%r9, %r8
	jb	.LBB10_42
	addq	%r12, %r9
	jmp	.LBB10_46
.LBB10_51:
	testq	%rsi, %rsi
	je	.LBB10_52
	movq	%r8, 48(%rsp)
	movq	%rsi, %r15
	callq	*_RNvCs9wFQrvczXsK_7___rustc35___rust_no_alloc_shim_is_unstable_v2@GOTPCREL(%rip)
	movl	$8, %esi
	movq	%r15, %rdi
	callq	*_RNvCs9wFQrvczXsK_7___rustc12___rust_alloc@GOTPCREL(%rip)
	movl	$8, %edi
	movq	%r15, %rsi
	testq	%rax, %rax
	je	.LBB10_50
	movq	$0, 40(%rsp)
	movq	48(%rsp), %r8
	jmp	.LBB10_55
.LBB10_19:
	je	.LBB10_22
	cmpq	$1073741823, %rax
	ja	.LBB10_22
	shlq	$17, %rdx
	shlq	$34, %rax
	orq	%r14, %rdx
	orq	%rax, %rdx
	movl	$1, %ecx
	movq	%rdx, %r14
	movq	8(%rsp), %r15
	jmp	.LBB10_109
.LBB10_52:
	movq	$0, 40(%rsp)
	movl	$8, %eax
	xorl	%ebp, %ebp
.LBB10_55:
	movq	%rbp, 16(%rsp)
	movq	%rax, 24(%rsp)
	movq	$0, 32(%rsp)
	cmpq	$-1, %r12
	setne	%cl
	movq	(%rsp), %r15
	cmpq	%r15, %r8
	sete	%dl
	testb	%dl, %cl
	jne	.LBB10_56
	testq	%rbp, %rbp
	jne	.LBB10_63
.Ltmp11:
	leaq	16(%rsp), %rdi
	callq	*_RNvMs3_NtCscdodAO9FK5_5alloc7raw_vecINtB5_6RawVecNtNtCs5Av9rWzHob7_3lib14identity_index3RunE8grow_oneBP_@GOTPCREL(%rip)
.Ltmp12:
	movq	24(%rsp), %rax
.LBB10_63:
	movq	%r12, (%rax)
	movabsq	$4294967296, %rcx
	movq	%rcx, 8(%rax)
	movq	$1, 32(%rsp)
	movl	$1, %ecx
	movq	%rcx, 40(%rsp)
	movl	$1, %ecx
	movl	$1, %edx
	cmpq	$2, %r14
	movq	56(%rsp), %rbp
	jne	.LBB10_73
.LBB10_65:
	movq	%rcx, %r14
	movq	%r15, %r12
	movl	%edx, %ecx
	jmp	.LBB10_66
.LBB10_56:
	movl	$2, %edx
	xorl	%ecx, %ecx
	movq	%r12, %r15
	cmpq	$2, %r14
	movq	56(%rsp), %rbp
	je	.LBB10_65
.LBB10_73:
	movq	%r15, (%rsp)
	addq	$-16, %rbp
	movl	$2, %r15d
	movq	%rcx, %r14
	movl	%edx, %ecx
	jmp	.LBB10_74
	.p2align	4
.LBB10_78:
	movq	%r14, %rcx
	shlq	$4, %rcx
	movq	(%rsp), %rdx
	movq	%rdx, (%rax,%rcx)
	movq	40(%rsp), %rdx
	movl	%edx, 8(%rax,%rcx)
	movl	56(%rsp), %edx
	movl	%edx, 12(%rax,%rcx)
	incq	%r14
	movq	%r14, 32(%rsp)
	movl	%r15d, %ecx
	movq	%rcx, 40(%rsp)
	movl	$1, %ecx
	movq	%r12, (%rsp)
	incq	%r15
	addq	$-8, %rbp
	je	.LBB10_66
.LBB10_74:
	movq	(%r13,%r15,8), %r12
	movl	%ecx, %edi
	movl	%ecx, %ecx
	movq	(%rsp), %rsi
	addq	%rsi, %rcx
	cmpq	%rsi, %rcx
	setae	%dl
	cmpq	%r12, %rcx
	sete	%cl
	testb	%cl, %dl
	jne	.LBB10_101
	movl	%edi, 56(%rsp)
	cmpq	16(%rsp), %r14
	jne	.LBB10_78
.Ltmp14:
	leaq	16(%rsp), %rdi
	callq	*_RNvMs3_NtCscdodAO9FK5_5alloc7raw_vecINtB5_6RawVecNtNtCs5Av9rWzHob7_3lib14identity_index3RunE8grow_oneBP_@GOTPCREL(%rip)
.Ltmp15:
	movq	24(%rsp), %rax
	jmp	.LBB10_78
	.p2align	4
.LBB10_101:
	incl	%edi
	movq	%rsi, %r12
	movl	%edi, %ecx
	incq	%r15
	addq	$-8, %rbp
	jne	.LBB10_74
.LBB10_66:
	movl	%ecx, %ebp
	cmpq	16(%rsp), %r14
	movq	8(%rsp), %r15
	jne	.LBB10_68
.Ltmp17:
	leaq	16(%rsp), %rdi
	callq	*_RNvMs3_NtCscdodAO9FK5_5alloc7raw_vecINtB5_6RawVecNtNtCs5Av9rWzHob7_3lib14identity_index3RunE8grow_oneBP_@GOTPCREL(%rip)
.Ltmp18:
.LBB10_68:
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
	jae	.LBB10_69
.LBB10_89:
	leaq	16(%r13), %rax
	leaq	1(%r14), %rcx
	.p2align	4
.LBB10_90:
	decq	%rcx
	cmpq	$2, %rcx
	jb	.LBB10_94
	movq	(%rax), %rdx
	subq	-16(%rax), %rdx
	jb	.LBB10_93
	movl	-4(%rax), %esi
	addq	$16, %rax
	cmpq	%rsi, %rdx
	jae	.LBB10_90
.LBB10_93:
.Ltmp21:
	leaq	.Lanon.2909fb0b1462d4ec6a0dd6e1464a844a.3(%rip), %rdi
	leaq	.Lanon.2909fb0b1462d4ec6a0dd6e1464a844a.5(%rip), %rdx
	movl	$73, %esi
	callq	*_RNvNtCs4NRVxsYgnAr_4core9panicking9panic_fmt@GOTPCREL(%rip)
.Ltmp22:
	jmp	.LBB10_38
.LBB10_94:
	movq	16(%rsp), %rbp
	cmpq	%r14, %rbp
	jbe	.LBB10_95
	shlq	$4, %rbp
	testq	%r14, %r14
	je	.LBB10_97
	movq	%r14, %rcx
	shlq	$4, %rcx
	movl	$8, %edx
	movq	%r13, %rdi
	movq	%rbp, %rsi
	movq	%rcx, (%rsp)
	callq	*_RNvCs9wFQrvczXsK_7___rustc14___rust_realloc@GOTPCREL(%rip)
	movq	%rax, %r12
	testq	%rax, %rax
	jne	.LBB10_98
.Ltmp24:
	movl	$8, %edi
	movq	(%rsp), %rsi
	callq	*_RNvNtCscdodAO9FK5_5alloc7raw_vec12handle_error@GOTPCREL(%rip)
.Ltmp25:
	jmp	.LBB10_38
.LBB10_95:
	movq	%r13, %r12
	movl	$2, %ecx
	jmp	.LBB10_109
.LBB10_97:
	movl	$8, %r12d
	movl	$8, %edx
	movq	%r13, %rdi
	movq	%rbp, %rsi
	callq	*_RNvCs9wFQrvczXsK_7___rustc14___rust_dealloc@GOTPCREL(%rip)
.LBB10_98:
	movl	$2, %ecx
	jmp	.LBB10_109
.LBB10_171:
	leaq	.Lanon.2909fb0b1462d4ec6a0dd6e1464a844a.0(%rip), %rdi
	leaq	.Lanon.2909fb0b1462d4ec6a0dd6e1464a844a.2(%rip), %rdx
	movl	$63, %esi
	callq	*_RNvNtCs4NRVxsYgnAr_4core9panicking9panic_fmt@GOTPCREL(%rip)
.LBB10_33:
.Ltmp6:
	leaq	16(%rsp), %rdx
	movq	%r12, %rdi
	movq	%r14, %rsi
	callq	*_RINvNtNtNtCs4NRVxsYgnAr_4core5slice4sort8unstable7ipnsortNtNtCs5Av9rWzHob7_3lib14identity_index5EntryNCINvMB6_SBT_20sort_unstable_by_keyyNCINvMs0_BV_NtBV_13IdentityIndex8from_idsINtNtNtNtB8_4iter8adapters6copied6CopiedINtNtB6_4iter4IteryEEEs1_0E0EBX_@GOTPCREL(%rip)
.Ltmp7:
.LBB10_34:
	leaq	1(%r14), %rax
	movq	%r12, %rcx
	.p2align	4
.LBB10_35:
	decq	%rax
	cmpq	$2, %rax
	jb	.LBB10_108
	movq	(%rcx), %rdx
	cmpq	12(%rcx), %rdx
	leaq	12(%rcx), %rcx
	jne	.LBB10_35
.Ltmp8:
	leaq	.Lanon.2909fb0b1462d4ec6a0dd6e1464a844a.3(%rip), %rdi
	leaq	.Lanon.2909fb0b1462d4ec6a0dd6e1464a844a.4(%rip), %rdx
	movl	$73, %esi
	callq	*_RNvNtCs4NRVxsYgnAr_4core9panicking9panic_fmt@GOTPCREL(%rip)
.Ltmp9:
.LBB10_38:
	ud2
.LBB10_108:
	movl	$3, %ecx
.LBB10_109:
	testq	%rbx, %rbx
	je	.LBB10_110
	leaq	.LJTI10_0(%rip), %rax
	movslq	(%rax,%rcx,4), %rdx
	addq	%rax, %rdx
	jmpq	*%rdx
.LBB10_112:
	movl	%ebx, %eax
	subl	%ecx, %eax
	leaq	1(%rcx), %rsi
	testb	$1, %al
	jne	.LBB10_114
	movq	%rcx, %rdx
	cmpq	%rsi, %rbx
	jne	.LBB10_116
	jmp	.LBB10_170
.LBB10_110:
	xorl	%eax, %eax
.LBB10_163:
	cmpl	$2, %ecx
	jb	.LBB10_170
	cmpl	$2, %ecx
	jne	.LBB10_165
	testq	%r14, %r14
	je	.LBB10_170
	shlq	$4, %r14
	movl	$8, %edx
	movq	%r12, %rdi
	movq	%r14, %rsi
	jmp	.LBB10_169
.LBB10_165:
	testq	%r14, %r14
	je	.LBB10_170
	shlq	$2, %r14
	leaq	(%r14,%r14,2), %rsi
	movl	$4, %edx
	movq	%r12, %rdi
.LBB10_169:
	movq	%rax, %rbx
	callq	*_RNvCs9wFQrvczXsK_7___rustc14___rust_dealloc@GOTPCREL(%rip)
	movq	%rbx, %rax
	jmp	.LBB10_170
.LBB10_125:
	xorl	%eax, %eax
	xorl	%edx, %edx
	jmp	.LBB10_126
	.p2align	4
.LBB10_132:
	movq	%r13, %r15
.LBB10_135:
	xorq	%rsi, %rax
	incq	%rdx
	cmpq	%rbx, %rdx
	je	.LBB10_163
.LBB10_126:
	movq	$-1, %rsi
	testq	%r14, %r14
	je	.LBB10_135
	movq	%r15, %r13
	movq	(%r15,%rdx,8), %rdi
	cmpq	$1, %r14
	jne	.LBB10_129
	xorl	%r8d, %r8d
	jmp	.LBB10_131
	.p2align	4
.LBB10_129:
	movq	%r14, %r9
	xorl	%r8d, %r8d
	.p2align	4
.LBB10_130:
	movq	%r8, %r10
	movq	%r9, %r11
	shrq	%r11
	addq	%r11, %r8
	movq	%r8, %r15
	shlq	$4, %r15
	cmpq	%rdi, (%r12,%r15)
	cmovaq	%r10, %r8
	subq	%r11, %r9
	cmpq	$1, %r9
	ja	.LBB10_130
.LBB10_131:
	movq	%r8, %r10
	shlq	$4, %r10
	xorl	%r9d, %r9d
	cmpq	%rdi, (%r12,%r10)
	setbe	%r9b
	addq	%r8, %r9
	je	.LBB10_132
	shlq	$4, %r9
	subq	-16(%r12,%r9), %rdi
	movl	-4(%r12,%r9), %r8d
	cmpq	%r8, %rdi
	movq	%r13, %r15
	jae	.LBB10_135
	addq	%r12, %r9
	movl	-8(%r9), %esi
	addq	%rsi, %rdi
	movq	%rdi, %rsi
	jmp	.LBB10_135
.LBB10_136:
	testq	%r14, %r14
	je	.LBB10_144
	cmpq	$1, %r14
	jne	.LBB10_138
	movq	(%r12), %rdx
	cmpq	$1, %rbx
	jne	.LBB10_153
	xorl	%esi, %esi
	xorl	%eax, %eax
	jmp	.LBB10_160
.LBB10_118:
	movq	%r14, %rdx
	shrq	$17, %rdx
	andl	$131071, %edx
	movq	%r14, %rsi
	shrq	$34, %rsi
	movl	%r14d, %edi
	andl	$131071, %edi
	xorl	%eax, %eax
	xorl	%r8d, %r8d
	jmp	.LBB10_119
	.p2align	4
.LBB10_121:
	movq	%r9, %r10
.LBB10_124:
	xorq	%r10, %rax
	incq	%r8
	cmpq	%r8, %rbx
	je	.LBB10_163
.LBB10_119:
	movq	(%r15,%r8,8), %r9
	movq	$-1, %r10
	subq	%r12, %r9
	jb	.LBB10_124
	cmpq	%rdx, %r9
	jb	.LBB10_121
	subq	%rsi, %r9
	jb	.LBB10_124
	cmpq	%rdx, %r9
	setae	%r10b
	cmpq	%rdi, %r9
	setb	%r11b
	andb	%r10b, %r11b
	andb	$1, %r11b
	cmpb	$1, %r11b
	movl	$0, %r10d
	sbbq	%r10, %r10
	orq	%r9, %r10
	jmp	.LBB10_124
.LBB10_114:
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
	je	.LBB10_170
.LBB10_116:
	movq	$-1, %rsi
	.p2align	4
.LBB10_117:
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
	jne	.LBB10_117
	jmp	.LBB10_170
.LBB10_144:
	cmpq	$4, %rbx
	jae	.LBB10_146
	xorl	%ecx, %ecx
	xorl	%eax, %eax
	jmp	.LBB10_149
.LBB10_138:
	xorl	%eax, %eax
	xorl	%edx, %edx
	jmp	.LBB10_139
	.p2align	4
.LBB10_143:
	xorq	%rdi, %rax
	incq	%rdx
	cmpq	%rbx, %rdx
	je	.LBB10_163
.LBB10_139:
	movq	(%r15,%rdx,8), %rsi
	movq	%r14, %rdi
	xorl	%r8d, %r8d
	.p2align	4
.LBB10_140:
	movq	%r8, %r9
	movq	%rdi, %r10
	shrq	%r10
	addq	%r10, %r8
	leaq	(%r8,%r8,2), %r11
	cmpq	%rsi, (%r12,%r11,4)
	cmovaq	%r9, %r8
	subq	%r10, %rdi
	cmpq	$1, %rdi
	ja	.LBB10_140
	leaq	(%r8,%r8,2), %r8
	movq	$-1, %rdi
	cmpq	%rsi, (%r12,%r8,4)
	jne	.LBB10_143
	leaq	(%r12,%r8,4), %rsi
	movl	8(%rsi), %edi
	jmp	.LBB10_143
.LBB10_153:
	movabsq	$1152921504606846972, %rdi
	orq	$2, %rdi
	andq	%rbx, %rdi
	xorl	%esi, %esi
	xorl	%eax, %eax
	jmp	.LBB10_154
	.p2align	4
.LBB10_158:
	xorq	%r9, %rax
	xorq	%r8, %rax
	addq	$2, %rsi
	cmpq	%rsi, %rdi
	je	.LBB10_159
.LBB10_154:
	movq	$-1, %r8
	movq	$-1, %r9
	cmpq	(%r15,%rsi,8), %rdx
	jne	.LBB10_156
	movl	8(%r12), %r9d
.LBB10_156:
	cmpq	8(%r15,%rsi,8), %rdx
	jne	.LBB10_158
	movl	8(%r12), %r8d
	jmp	.LBB10_158
.LBB10_159:
	testb	$1, %bl
	je	.LBB10_163
.LBB10_160:
	movq	$-1, %rdi
	cmpq	(%r15,%rsi,8), %rdx
	jne	.LBB10_162
	movl	8(%r12), %edi
.LBB10_162:
	xorq	%rdi, %rax
	jmp	.LBB10_163
.LBB10_146:
	movabsq	$1152921504606846972, %rcx
	andq	%rbx, %rcx
	pxor	%xmm0, %xmm0
	pcmpeqd	%xmm2, %xmm2
	movq	%rcx, %rax
	pxor	%xmm3, %xmm3
	.p2align	4
.LBB10_147:
	movdqa	%xmm3, %xmm1
	movdqa	%xmm0, %xmm4
	pxor	%xmm2, %xmm0
	pxor	%xmm2, %xmm3
	addq	$-4, %rax
	jne	.LBB10_147
	pxor	%xmm4, %xmm1
	pshufd	$238, %xmm1, %xmm0
	pxor	%xmm1, %xmm0
	movq	%xmm0, %rax
	cmpq	%rcx, %rbx
	je	.LBB10_170
.LBB10_149:
	subq	%rcx, %rbx
	.p2align	4
.LBB10_150:
	notq	%rax
	decq	%rbx
	jne	.LBB10_150
.LBB10_170:
	addq	$72, %rsp
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
.LBB10_69:
	.cfi_def_cfa_offset 128
	cmpq	$21, %r14
	jae	.LBB10_70
	shlq	$4, %r14
	addq	%r13, %r14
	leaq	16(%r13), %rdx
	movl	$16, %eax
	movq	%r13, %rsi
	jmp	.LBB10_80
.LBB10_83:
	movq	%r13, %rdi
.LBB10_86:
	movq	%rdx, (%rdi)
	movq	%rsi, 8(%rdi)
.LBB10_87:
	leaq	16(%rcx), %rdx
	addq	$16, %rax
	movq	%rcx, %rsi
	cmpq	%r14, %rdx
	je	.LBB10_88
.LBB10_80:
	movq	%rdx, %rcx
	movq	16(%rsi), %rdx
	cmpq	(%rsi), %rdx
	jae	.LBB10_87
	movq	24(%rsi), %rsi
	movq	%rax, %r8
.LBB10_82:
	movdqu	-16(%r13,%r8), %xmm0
	movdqu	%xmm0, (%r13,%r8)
	cmpq	$16, %r8
	je	.LBB10_83
	leaq	-16(%r8), %rdi
	cmpq	-32(%r13,%r8), %rdx
	movq	%rdi, %r8
	jb	.LBB10_82
	addq	%r13, %rdi
	jmp	.LBB10_86
.LBB10_88:
	movq	24(%rsp), %r13
	movq	32(%rsp), %r14
	movq	8(%rsp), %r15
	jmp	.LBB10_89
.LBB10_26:
	movl	$4, %edi
	movq	%rbp, %rsi
	callq	*_RNvNtCscdodAO9FK5_5alloc7raw_vec12handle_error@GOTPCREL(%rip)
.LBB10_70:
.Ltmp19:
	leaq	64(%rsp), %rdx
	movq	%r13, %rdi
	movq	%r14, %rsi
	callq	*_RINvNtNtNtCs4NRVxsYgnAr_4core5slice4sort8unstable7ipnsortNtNtCs5Av9rWzHob7_3lib14identity_index3RunNCINvMB6_SBT_20sort_unstable_by_keyyNCINvMs0_BV_NtBV_13IdentityIndex8from_idsINtNtNtNtB8_4iter8adapters6copied6CopiedINtNtB6_4iter4IteryEEEs_0E0EBX_@GOTPCREL(%rip)
.Ltmp20:
	movq	8(%rsp), %r15
	jmp	.LBB10_89
.LBB10_72:
.Ltmp13:
	jmp	.LBB10_104
.LBB10_59:
.Ltmp26:
	movq	%rax, %rbx
	movl	$8, %edx
	movq	%r13, %rdi
	movq	%rbp, %rsi
	jmp	.LBB10_106
.LBB10_71:
.Ltmp16:
	jmp	.LBB10_104
.LBB10_57:
.Ltmp10:
	movq	%rax, %rbx
	movl	$4, %edx
	movq	%r12, %rdi
	movq	%rbp, %rsi
	jmp	.LBB10_106
.LBB10_103:
.Ltmp23:
.LBB10_104:
	movq	%rax, %rbx
	movq	16(%rsp), %rsi
	testq	%rsi, %rsi
	je	.LBB10_107
	movq	24(%rsp), %rdi
	shlq	$4, %rsi
	movl	$8, %edx
.LBB10_106:
	callq	*_RNvCs9wFQrvczXsK_7___rustc14___rust_dealloc@GOTPCREL(%rip)
.LBB10_107:
	movq	%rbx, %rdi
	callq	_Unwind_Resume@PLT
.Lfunc_end10:
	.size	_RNvCs5Av9rWzHob7_3lib11hole_lookup, .Lfunc_end10-_RNvCs5Av9rWzHob7_3lib11hole_lookup
	.cfi_endproc
	.section	.rodata._RNvCs5Av9rWzHob7_3lib11hole_lookup,"a",@progbits
	.p2align	2, 0x0
.LJTI10_0:
	.long	.LBB10_112-.LJTI10_0
	.long	.LBB10_118-.LJTI10_0
	.long	.LBB10_125-.LJTI10_0
	.long	.LBB10_136-.LJTI10_0
	.section	.gcc_except_table._RNvCs5Av9rWzHob7_3lib11hole_lookup,"a",@progbits
	.p2align	2, 0x0
GCC_except_table10:
.Lexception2:
	.byte	255
	.byte	255
	.byte	1
	.uleb128 .Lcst_end2-.Lcst_begin2
.Lcst_begin2:
	.uleb128 .Lfunc_begin2-.Lfunc_begin2
	.uleb128 .Ltmp11-.Lfunc_begin2
	.byte	0
	.byte	0
	.uleb128 .Ltmp11-.Lfunc_begin2
	.uleb128 .Ltmp12-.Ltmp11
	.uleb128 .Ltmp13-.Lfunc_begin2
	.byte	0
	.uleb128 .Ltmp14-.Lfunc_begin2
	.uleb128 .Ltmp15-.Ltmp14
	.uleb128 .Ltmp16-.Lfunc_begin2
	.byte	0
	.uleb128 .Ltmp17-.Lfunc_begin2
	.uleb128 .Ltmp22-.Ltmp17
	.uleb128 .Ltmp23-.Lfunc_begin2
	.byte	0
	.uleb128 .Ltmp24-.Lfunc_begin2
	.uleb128 .Ltmp25-.Ltmp24
	.uleb128 .Ltmp26-.Lfunc_begin2
	.byte	0
	.uleb128 .Ltmp25-.Lfunc_begin2
	.uleb128 .Ltmp6-.Ltmp25
	.byte	0
	.byte	0
	.uleb128 .Ltmp6-.Lfunc_begin2
	.uleb128 .Ltmp9-.Ltmp6
	.uleb128 .Ltmp10-.Lfunc_begin2
	.byte	0
	.uleb128 .Ltmp9-.Lfunc_begin2
	.uleb128 .Ltmp19-.Ltmp9
	.byte	0
	.byte	0
	.uleb128 .Ltmp19-.Lfunc_begin2
	.uleb128 .Ltmp20-.Ltmp19
	.uleb128 .Ltmp23-.Lfunc_begin2
	.byte	0
	.uleb128 .Ltmp20-.Lfunc_begin2
	.uleb128 .Lfunc_end10-.Ltmp20
	.byte	0
	.byte	0
.Lcst_end2:
	.p2align	2, 0x0

	.section	.text.unlikely._RNvMs3_NtCscdodAO9FK5_5alloc7raw_vecINtB5_6RawVecNtNtCs5Av9rWzHob7_3lib14identity_index3RunE8grow_oneBP_,"ax",@progbits
	.globl	_RNvMs3_NtCscdodAO9FK5_5alloc7raw_vecINtB5_6RawVecNtNtCs5Av9rWzHob7_3lib14identity_index3RunE8grow_oneBP_
	.p2align	4
	.type	_RNvMs3_NtCscdodAO9FK5_5alloc7raw_vecINtB5_6RawVecNtNtCs5Av9rWzHob7_3lib14identity_index3RunE8grow_oneBP_,@function
_RNvMs3_NtCscdodAO9FK5_5alloc7raw_vecINtB5_6RawVecNtNtCs5Av9rWzHob7_3lib14identity_index3RunE8grow_oneBP_:
	.cfi_startproc
	pushq	%r14
	.cfi_def_cfa_offset 16
	pushq	%rbx
	.cfi_def_cfa_offset 24
	subq	$24, %rsp
	.cfi_def_cfa_offset 48
	.cfi_offset %rbx, -24
	.cfi_offset %r14, -16
	movq	%rdi, %rbx
	movq	(%rdi), %rsi
	leaq	(%rsi,%rsi), %rax
	cmpq	$5, %rax
	movl	$4, %r14d
	cmovaeq	%rax, %r14
	movq	8(%rdi), %rdx
	movq	%rsp, %rdi
	movl	$8, %r8d
	movl	$16, %r9d
	movq	%r14, %rcx
	callq	_RNvMs4_NtCscdodAO9FK5_5alloc7raw_vecNtB5_11RawVecInner11finish_growCs5Av9rWzHob7_3lib
	cmpl	$1, (%rsp)
	je	.LBB11_2
	movq	8(%rsp), %rax
	movq	%rax, 8(%rbx)
	movq	%r14, (%rbx)
	addq	$24, %rsp
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%r14
	.cfi_def_cfa_offset 8
	retq
.LBB11_2:
	.cfi_def_cfa_offset 48
	movq	8(%rsp), %rdi
	movq	16(%rsp), %rsi
	callq	*_RNvNtCscdodAO9FK5_5alloc7raw_vec12handle_error@GOTPCREL(%rip)
.Lfunc_end11:
	.size	_RNvMs3_NtCscdodAO9FK5_5alloc7raw_vecINtB5_6RawVecNtNtCs5Av9rWzHob7_3lib14identity_index3RunE8grow_oneBP_, .Lfunc_end11-_RNvMs3_NtCscdodAO9FK5_5alloc7raw_vecINtB5_6RawVecNtNtCs5Av9rWzHob7_3lib14identity_index3RunE8grow_oneBP_
	.cfi_endproc

	.section	.text.unlikely._RNvMs4_NtCscdodAO9FK5_5alloc7raw_vecNtB5_11RawVecInner11finish_growCs5Av9rWzHob7_3lib,"ax",@progbits
	.p2align	4
	.type	_RNvMs4_NtCscdodAO9FK5_5alloc7raw_vecNtB5_11RawVecInner11finish_growCs5Av9rWzHob7_3lib,@function
_RNvMs4_NtCscdodAO9FK5_5alloc7raw_vecNtB5_11RawVecInner11finish_growCs5Av9rWzHob7_3lib:
	.cfi_startproc
	pushq	%r15
	.cfi_def_cfa_offset 16
	pushq	%r14
	.cfi_def_cfa_offset 24
	pushq	%r12
	.cfi_def_cfa_offset 32
	pushq	%rbx
	.cfi_def_cfa_offset 40
	pushq	%rax
	.cfi_def_cfa_offset 48
	.cfi_offset %rbx, -40
	.cfi_offset %r12, -32
	.cfi_offset %r14, -24
	.cfi_offset %r15, -16
	movq	%r8, %r15
	movq	%rdx, %r8
	movq	%rdi, %rbx
	movq	%r9, %rax
	mulq	%rcx
	movq	%rax, %r14
	seto	%al
	movabsq	$-9223372036854775808, %rcx
	subq	%r15, %rcx
	cmpq	%rcx, %r14
	seta	%cl
	orb	%al, %cl
	movl	$1, %r12d
	je	.LBB12_2
	movl	$8, %eax
	xorl	%r14d, %r14d
	jmp	.LBB12_10
.LBB12_2:
	testq	%rsi, %rsi
	je	.LBB12_4
	imulq	%rsi, %r9
	movq	%r8, %rdi
	movq	%r9, %rsi
	movq	%r15, %rdx
	movq	%r14, %rcx
	callq	*_RNvCs9wFQrvczXsK_7___rustc14___rust_realloc@GOTPCREL(%rip)
	testq	%rax, %rax
	jne	.LBB12_6
	jmp	.LBB12_9
.LBB12_4:
	testq	%r14, %r14
	je	.LBB12_5
	callq	*_RNvCs9wFQrvczXsK_7___rustc35___rust_no_alloc_shim_is_unstable_v2@GOTPCREL(%rip)
	movq	%r14, %rdi
	movq	%r15, %rsi
	callq	*_RNvCs9wFQrvczXsK_7___rustc12___rust_alloc@GOTPCREL(%rip)
	testq	%rax, %rax
	jne	.LBB12_6
.LBB12_9:
	movq	%r15, 8(%rbx)
	movl	$16, %eax
	jmp	.LBB12_10
.LBB12_5:
	movq	%r15, %rax
.LBB12_6:
	movq	%rax, 8(%rbx)
	movl	$16, %eax
	xorl	%r12d, %r12d
.LBB12_10:
	movq	%r14, (%rbx,%rax)
	movq	%r12, (%rbx)
	addq	$8, %rsp
	.cfi_def_cfa_offset 40
	popq	%rbx
	.cfi_def_cfa_offset 32
	popq	%r12
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end12:
	.size	_RNvMs4_NtCscdodAO9FK5_5alloc7raw_vecNtB5_11RawVecInner11finish_growCs5Av9rWzHob7_3lib, .Lfunc_end12-_RNvMs4_NtCscdodAO9FK5_5alloc7raw_vecNtB5_11RawVecInner11finish_growCs5Av9rWzHob7_3lib
	.cfi_endproc

	.type	.Lanon.2909fb0b1462d4ec6a0dd6e1464a844a.0,@object
	.section	.rodata..Lanon.2909fb0b1462d4ec6a0dd6e1464a844a.0,"a",@progbits
.Lanon.2909fb0b1462d4ec6a0dd6e1464a844a.0:
	.ascii	"admitted logical identity count"
	.size	.Lanon.2909fb0b1462d4ec6a0dd6e1464a844a.0, 31

	.type	.Lanon.2909fb0b1462d4ec6a0dd6e1464a844a.1,@object
	.section	.rodata.str1.1,"aMS",@progbits,1
.Lanon.2909fb0b1462d4ec6a0dd6e1464a844a.1:
	.asciz	"/root/gpui-identity-hole-hot/reactivity/crates/gpui/src/runtime/identity_index.rs"
	.size	.Lanon.2909fb0b1462d4ec6a0dd6e1464a844a.1, 82

	.type	.Lanon.2909fb0b1462d4ec6a0dd6e1464a844a.2,@object
	.section	.data.rel.ro..Lanon.2909fb0b1462d4ec6a0dd6e1464a844a.2,"aw",@progbits
	.p2align	3, 0x0
.Lanon.2909fb0b1462d4ec6a0dd6e1464a844a.2:
	.quad	.Lanon.2909fb0b1462d4ec6a0dd6e1464a844a.1
	.asciz	"Q\000\000\000\000\000\000\000P\000\000\000\t\000\000"
	.size	.Lanon.2909fb0b1462d4ec6a0dd6e1464a844a.2, 24

	.type	.Lanon.2909fb0b1462d4ec6a0dd6e1464a844a.3,@object
	.section	.rodata..Lanon.2909fb0b1462d4ec6a0dd6e1464a844a.3,"a",@progbits
.Lanon.2909fb0b1462d4ec6a0dd6e1464a844a.3:
	.ascii	"distinct admitted logical identities"
	.size	.Lanon.2909fb0b1462d4ec6a0dd6e1464a844a.3, 36

	.type	.Lanon.2909fb0b1462d4ec6a0dd6e1464a844a.4,@object
	.section	.data.rel.ro..Lanon.2909fb0b1462d4ec6a0dd6e1464a844a.4,"aw",@progbits
	.p2align	3, 0x0
.Lanon.2909fb0b1462d4ec6a0dd6e1464a844a.4:
	.quad	.Lanon.2909fb0b1462d4ec6a0dd6e1464a844a.1
	.asciz	"Q\000\000\000\000\000\000\000\227\000\000\000\t\000\000"
	.size	.Lanon.2909fb0b1462d4ec6a0dd6e1464a844a.4, 24

	.type	.Lanon.2909fb0b1462d4ec6a0dd6e1464a844a.5,@object
	.section	.data.rel.ro..Lanon.2909fb0b1462d4ec6a0dd6e1464a844a.5,"aw",@progbits
	.p2align	3, 0x0
.Lanon.2909fb0b1462d4ec6a0dd6e1464a844a.5:
	.quad	.Lanon.2909fb0b1462d4ec6a0dd6e1464a844a.1
	.asciz	"Q\000\000\000\000\000\000\000\203\000\000\000\r\000\000"
	.size	.Lanon.2909fb0b1462d4ec6a0dd6e1464a844a.5, 24

	.hidden	DW.ref.rust_eh_personality
	.weak	DW.ref.rust_eh_personality
	.section	.data.DW.ref.rust_eh_personality,"awG",@progbits,DW.ref.rust_eh_personality,comdat
	.p2align	3, 0x0
	.type	DW.ref.rust_eh_personality,@object
	.size	DW.ref.rust_eh_personality, 8
DW.ref.rust_eh_personality:
	.quad	rust_eh_personality
	.ident	"rustc version 1.97.1 (8bab26f4f 2026-07-14)"
	.section	".note.GNU-stack","",@progbits
