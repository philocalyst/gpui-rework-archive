	.def	@feat.00;
	.scl	3;
	.type	0;
	.endef
	.globl	@feat.00
@feat.00 = 0
	.file	"lib.41187a8fd52682eb-cgu.0"
	.def	_RINvNtNtNtCs998Ihx2sztz_4core5slice4sort8unstable7ipnsortNtNtCs5Av9rWzHob7_3lib14identity_index3RunNCINvMB6_SBT_20sort_unstable_by_keyyNCINvMs0_BV_NtBV_13IdentityIndex8from_idsINtNtNtNtB8_4iter8adapters6copied6CopiedINtNtB6_4iter4IteryEEEs_0E0EBX_;
	.scl	2;
	.type	32;
	.endef
	.section	.text,"xr",one_only,_RINvNtNtNtCs998Ihx2sztz_4core5slice4sort8unstable7ipnsortNtNtCs5Av9rWzHob7_3lib14identity_index3RunNCINvMB6_SBT_20sort_unstable_by_keyyNCINvMs0_BV_NtBV_13IdentityIndex8from_idsINtNtNtNtB8_4iter8adapters6copied6CopiedINtNtB6_4iter4IteryEEEs_0E0EBX_,unique,0
	.globl	_RINvNtNtNtCs998Ihx2sztz_4core5slice4sort8unstable7ipnsortNtNtCs5Av9rWzHob7_3lib14identity_index3RunNCINvMB6_SBT_20sort_unstable_by_keyyNCINvMs0_BV_NtBV_13IdentityIndex8from_idsINtNtNtNtB8_4iter8adapters6copied6CopiedINtNtB6_4iter4IteryEEEs_0E0EBX_
	.p2align	4
_RINvNtNtNtCs998Ihx2sztz_4core5slice4sort8unstable7ipnsortNtNtCs5Av9rWzHob7_3lib14identity_index3RunNCINvMB6_SBT_20sort_unstable_by_keyyNCINvMs0_BV_NtBV_13IdentityIndex8from_idsINtNtNtNtB8_4iter8adapters6copied6CopiedINtNtB6_4iter4IteryEEEs_0E0EBX_:
.seh_proc _RINvNtNtNtCs998Ihx2sztz_4core5slice4sort8unstable7ipnsortNtNtCs5Av9rWzHob7_3lib14identity_index3RunNCINvMB6_SBT_20sort_unstable_by_keyyNCINvMs0_BV_NtBV_13IdentityIndex8from_idsINtNtNtNtB8_4iter8adapters6copied6CopiedINtNtB6_4iter4IteryEEEs_0E0EBX_
	pushq	%rsi
	.seh_pushreg %rsi
	pushq	%rdi
	.seh_pushreg %rdi
	subq	$40, %rsp
	.seh_stackalloc 40
	.seh_endprologue
	cmpq	$2, %rdx
	jb	.LBB0_9
	movq	(%rcx), %rax
	movq	16(%rcx), %r9
	movl	$2, %r10d
	cmpq	%rax, %r9
	jae	.LBB0_6
	cmpq	$2, %rdx
	je	.LBB0_7
	leaq	32(%rcx), %r11
	movq	%r9, %rsi
	.p2align	4
.LBB0_4:
	movq	%rsi, %rdi
	movq	(%r11), %rsi
	cmpq	%rdi, %rsi
	jae	.LBB0_7
	incq	%r10
	addq	$16, %r11
	cmpq	%r10, %rdx
	jne	.LBB0_4
	jmp	.LBB0_13
.LBB0_6:
	cmpq	$2, %rdx
	jne	.LBB0_10
.LBB0_7:
	cmpq	%rdx, %r10
	je	.LBB0_13
	movq	%rdx, %rax
	orq	$1, %rax
	bsrq	%rax, %r9
	xorl	$63, %r9d
	addl	%r9d, %r9d
	xorl	$126, %r9d
	movq	%r8, 32(%rsp)
	xorl	%r8d, %r8d
	callq	_RINvNtNtNtNtCs998Ihx2sztz_4core5slice4sort8unstable9quicksort9quicksortNtNtCs5Av9rWzHob7_3lib14identity_index3RunNCINvMB8_SB17_20sort_unstable_by_keyyNCINvMs0_B19_NtB19_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs_0E0EB1b_
	nop
.LBB0_9:
	.seh_startepilogue
	addq	$40, %rsp
	popq	%rdi
	popq	%rsi
	.seh_endepilogue
	retq
.LBB0_10:
	leaq	32(%rcx), %r11
	movq	%r9, %rsi
	.p2align	4
.LBB0_11:
	movq	%rsi, %rdi
	movq	(%r11), %rsi
	cmpq	%rdi, %rsi
	jb	.LBB0_7
	incq	%r10
	addq	$16, %r11
	cmpq	%r10, %rdx
	jne	.LBB0_11
.LBB0_13:
	cmpq	%rax, %r9
	jae	.LBB0_9
	movq	%rdx, %r8
	shrq	%r8
	shlq	$4, %rdx
	leaq	(%rcx,%rdx), %rax
	cmpq	$1, %r8
	jne	.LBB0_16
	xorl	%edx, %edx
	jmp	.LBB0_19
.LBB0_16:
	movabsq	$288230376151711742, %r9
	andq	%r8, %r9
	leaq	16(%rcx), %r10
	leaq	(%rdx,%rcx), %r11
	addq	$-16, %r11
	xorl	%edx, %edx
	movabsq	$1152921504606846974, %rsi
	.p2align	4
.LBB0_17:
	movups	-16(%r10), %xmm0
	movups	(%r11), %xmm1
	movups	%xmm1, -16(%r10)
	movups	%xmm0, (%r11)
	movq	%rdx, %rdi
	xorq	%rsi, %rdi
	shlq	$4, %rdi
	movups	(%r10), %xmm0
	movups	(%rax,%rdi), %xmm1
	movups	%xmm1, (%r10)
	movups	%xmm0, (%rax,%rdi)
	addq	$2, %rdx
	addq	$32, %r10
	addq	$-32, %r11
	cmpq	%rdx, %r9
	jne	.LBB0_17
	testb	$1, %r8b
	je	.LBB0_9
.LBB0_19:
	movq	%rdx, %r8
	notq	%r8
	shlq	$4, %rdx
	shlq	$4, %r8
	movups	(%rcx,%rdx), %xmm0
	movups	(%rax,%r8), %xmm1
	movups	%xmm1, (%rcx,%rdx)
	movups	%xmm0, (%rax,%r8)
	.seh_startepilogue
	addq	$40, %rsp
	popq	%rdi
	popq	%rsi
	.seh_endepilogue
	retq
	.seh_endproc

	.def	_RINvNtNtNtCs998Ihx2sztz_4core5slice4sort8unstable7ipnsortNtNtCs5Av9rWzHob7_3lib14identity_index5EntryNCINvMB6_SBT_20sort_unstable_by_keyyNCINvMs0_BV_NtBV_13IdentityIndex8from_idsINtNtNtNtB8_4iter8adapters6copied6CopiedINtNtB6_4iter4IteryEEEs1_0E0EBX_;
	.scl	2;
	.type	32;
	.endef
	.section	.text,"xr",one_only,_RINvNtNtNtCs998Ihx2sztz_4core5slice4sort8unstable7ipnsortNtNtCs5Av9rWzHob7_3lib14identity_index5EntryNCINvMB6_SBT_20sort_unstable_by_keyyNCINvMs0_BV_NtBV_13IdentityIndex8from_idsINtNtNtNtB8_4iter8adapters6copied6CopiedINtNtB6_4iter4IteryEEEs1_0E0EBX_,unique,1
	.globl	_RINvNtNtNtCs998Ihx2sztz_4core5slice4sort8unstable7ipnsortNtNtCs5Av9rWzHob7_3lib14identity_index5EntryNCINvMB6_SBT_20sort_unstable_by_keyyNCINvMs0_BV_NtBV_13IdentityIndex8from_idsINtNtNtNtB8_4iter8adapters6copied6CopiedINtNtB6_4iter4IteryEEEs1_0E0EBX_
	.p2align	4
_RINvNtNtNtCs998Ihx2sztz_4core5slice4sort8unstable7ipnsortNtNtCs5Av9rWzHob7_3lib14identity_index5EntryNCINvMB6_SBT_20sort_unstable_by_keyyNCINvMs0_BV_NtBV_13IdentityIndex8from_idsINtNtNtNtB8_4iter8adapters6copied6CopiedINtNtB6_4iter4IteryEEEs1_0E0EBX_:
.seh_proc _RINvNtNtNtCs998Ihx2sztz_4core5slice4sort8unstable7ipnsortNtNtCs5Av9rWzHob7_3lib14identity_index5EntryNCINvMB6_SBT_20sort_unstable_by_keyyNCINvMs0_BV_NtBV_13IdentityIndex8from_idsINtNtNtNtB8_4iter8adapters6copied6CopiedINtNtB6_4iter4IteryEEEs1_0E0EBX_
	pushq	%rsi
	.seh_pushreg %rsi
	pushq	%rdi
	.seh_pushreg %rdi
	subq	$40, %rsp
	.seh_stackalloc 40
	.seh_endprologue
	cmpq	$2, %rdx
	jb	.LBB1_15
	movq	(%rcx), %rax
	movq	12(%rcx), %r9
	movl	$2, %r10d
	cmpq	%rax, %r9
	jae	.LBB1_6
	cmpq	$2, %rdx
	je	.LBB1_7
	leaq	24(%rcx), %r11
	movq	%r9, %rsi
	.p2align	4
.LBB1_4:
	movq	%rsi, %rdi
	movq	(%r11), %rsi
	cmpq	%rdi, %rsi
	jae	.LBB1_7
	incq	%r10
	addq	$12, %r11
	cmpq	%r10, %rdx
	jne	.LBB1_4
	jmp	.LBB1_12
.LBB1_6:
	cmpq	$2, %rdx
	jne	.LBB1_9
.LBB1_7:
	cmpq	%rdx, %r10
	je	.LBB1_12
	movq	%rdx, %rax
	orq	$1, %rax
	bsrq	%rax, %r9
	xorl	$63, %r9d
	addl	%r9d, %r9d
	xorl	$126, %r9d
	movq	%r8, 32(%rsp)
	xorl	%r8d, %r8d
	callq	_RINvNtNtNtNtCs998Ihx2sztz_4core5slice4sort8unstable9quicksort9quicksortNtNtCs5Av9rWzHob7_3lib14identity_index5EntryNCINvMB8_SB17_20sort_unstable_by_keyyNCINvMs0_B19_NtB19_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs1_0E0EB1b_
	nop
	.seh_startepilogue
	addq	$40, %rsp
	popq	%rdi
	popq	%rsi
	.seh_endepilogue
	retq
.LBB1_9:
	leaq	24(%rcx), %r11
	movq	%r9, %rsi
	.p2align	4
.LBB1_10:
	movq	%rsi, %rdi
	movq	(%r11), %rsi
	cmpq	%rdi, %rsi
	jb	.LBB1_7
	incq	%r10
	addq	$12, %r11
	cmpq	%r10, %rdx
	jne	.LBB1_10
.LBB1_12:
	cmpq	%rax, %r9
	jae	.LBB1_15
	leaq	(%rdx,%rdx), %rax
	andq	$-4, %rax
	leaq	(%rax,%rax,2), %rax
	leaq	(%rdx,%rdx,2), %rdx
	leaq	-12(,%rdx,4), %rdx
	xorl	%r8d, %r8d
	.p2align	4
.LBB1_14:
	movq	(%rcx,%r8), %r9
	movq	(%rcx,%rdx), %r10
	movq	%r10, (%rcx,%r8)
	movq	%r9, (%rcx,%rdx)
	movl	8(%rcx,%r8), %r9d
	movl	8(%rcx,%rdx), %r10d
	movl	%r10d, 8(%rcx,%r8)
	movl	%r9d, 8(%rcx,%rdx)
	addq	$12, %r8
	addq	$-12, %rdx
	cmpq	%r8, %rax
	jne	.LBB1_14
.LBB1_15:
	.seh_startepilogue
	addq	$40, %rsp
	popq	%rdi
	popq	%rsi
	.seh_endepilogue
	retq
	.seh_endproc

	.def	_RINvNtNtNtNtCs998Ihx2sztz_4core5slice4sort6shared5pivot11median3_recNtNtCs5Av9rWzHob7_3lib14identity_index3RunNCINvMB8_SB14_20sort_unstable_by_keyyNCINvMs0_B16_NtB16_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs_0E0EB18_;
	.scl	3;
	.type	32;
	.endef
	.section	.text,"xr",one_only,_RINvNtNtNtNtCs998Ihx2sztz_4core5slice4sort6shared5pivot11median3_recNtNtCs5Av9rWzHob7_3lib14identity_index3RunNCINvMB8_SB14_20sort_unstable_by_keyyNCINvMs0_B16_NtB16_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs_0E0EB18_,unique,2
	.p2align	4
_RINvNtNtNtNtCs998Ihx2sztz_4core5slice4sort6shared5pivot11median3_recNtNtCs5Av9rWzHob7_3lib14identity_index3RunNCINvMB8_SB14_20sort_unstable_by_keyyNCINvMs0_B16_NtB16_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs_0E0EB18_:
.seh_proc _RINvNtNtNtNtCs998Ihx2sztz_4core5slice4sort6shared5pivot11median3_recNtNtCs5Av9rWzHob7_3lib14identity_index3RunNCINvMB8_SB14_20sort_unstable_by_keyyNCINvMs0_B16_NtB16_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs_0E0EB18_
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
	subq	$40, %rsp
	.seh_stackalloc 40
	.seh_endprologue
	movq	%r8, %rdi
	movq	%rdx, %rsi
	cmpq	$7, %r9
	jbe	.LBB2_2
	shrq	$3, %r9
	movq	%r9, %rbx
	shlq	$6, %rbx
	leaq	(%rcx,%rbx), %rdx
	imulq	$112, %r9, %r14
	leaq	(%rcx,%r14), %r8
	movq	%r9, %r15
	callq	_RINvNtNtNtNtCs998Ihx2sztz_4core5slice4sort6shared5pivot11median3_recNtNtCs5Av9rWzHob7_3lib14identity_index3RunNCINvMB8_SB14_20sort_unstable_by_keyyNCINvMs0_B16_NtB16_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs_0E0EB18_
	movq	%rax, %r12
	leaq	(%rsi,%rbx), %rdx
	leaq	(%rsi,%r14), %r8
	movq	%rsi, %rcx
	movq	%r15, %r9
	callq	_RINvNtNtNtNtCs998Ihx2sztz_4core5slice4sort6shared5pivot11median3_recNtNtCs5Av9rWzHob7_3lib14identity_index3RunNCINvMB8_SB14_20sort_unstable_by_keyyNCINvMs0_B16_NtB16_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs_0E0EB18_
	movq	%rax, %rsi
	addq	%rdi, %rbx
	addq	%rdi, %r14
	movq	%rdi, %rcx
	movq	%rbx, %rdx
	movq	%r14, %r8
	movq	%r15, %r9
	callq	_RINvNtNtNtNtCs998Ihx2sztz_4core5slice4sort6shared5pivot11median3_recNtNtCs5Av9rWzHob7_3lib14identity_index3RunNCINvMB8_SB14_20sort_unstable_by_keyyNCINvMs0_B16_NtB16_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs_0E0EB18_
	movq	%r12, %rcx
	movq	%rax, %rdi
.LBB2_2:
	movq	(%rcx), %rax
	movq	(%rsi), %rdx
	cmpq	%rdx, %rax
	setb	%r8b
	movq	(%rdi), %r9
	cmpq	%r9, %rax
	setb	%al
	xorb	%r8b, %al
	cmpq	%r9, %rdx
	setb	%dl
	xorb	%r8b, %dl
	cmovneq	%rdi, %rsi
	testb	%al, %al
	cmovneq	%rcx, %rsi
	movq	%rsi, %rax
	.seh_startepilogue
	addq	$40, %rsp
	popq	%rbx
	popq	%rdi
	popq	%rsi
	popq	%r12
	popq	%r14
	popq	%r15
	.seh_endepilogue
	retq
	.seh_endproc

	.def	_RINvNtNtNtNtCs998Ihx2sztz_4core5slice4sort6shared5pivot11median3_recNtNtCs5Av9rWzHob7_3lib14identity_index5EntryNCINvMB8_SB14_20sort_unstable_by_keyyNCINvMs0_B16_NtB16_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs1_0E0EB18_;
	.scl	3;
	.type	32;
	.endef
	.section	.text,"xr",one_only,_RINvNtNtNtNtCs998Ihx2sztz_4core5slice4sort6shared5pivot11median3_recNtNtCs5Av9rWzHob7_3lib14identity_index5EntryNCINvMB8_SB14_20sort_unstable_by_keyyNCINvMs0_B16_NtB16_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs1_0E0EB18_,unique,3
	.p2align	4
_RINvNtNtNtNtCs998Ihx2sztz_4core5slice4sort6shared5pivot11median3_recNtNtCs5Av9rWzHob7_3lib14identity_index5EntryNCINvMB8_SB14_20sort_unstable_by_keyyNCINvMs0_B16_NtB16_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs1_0E0EB18_:
.seh_proc _RINvNtNtNtNtCs998Ihx2sztz_4core5slice4sort6shared5pivot11median3_recNtNtCs5Av9rWzHob7_3lib14identity_index5EntryNCINvMB8_SB14_20sort_unstable_by_keyyNCINvMs0_B16_NtB16_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs1_0E0EB18_
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
	subq	$40, %rsp
	.seh_stackalloc 40
	.seh_endprologue
	movq	%r8, %rdi
	movq	%rdx, %rsi
	cmpq	$7, %r9
	jbe	.LBB3_2
	shrq	$3, %r9
	movq	%r9, %rax
	shlq	$4, %rax
	leaq	(%rax,%rax,2), %rbx
	leaq	(%rcx,%rbx), %rdx
	imulq	$84, %r9, %r14
	leaq	(%rcx,%r14), %r8
	movq	%r9, %r15
	callq	_RINvNtNtNtNtCs998Ihx2sztz_4core5slice4sort6shared5pivot11median3_recNtNtCs5Av9rWzHob7_3lib14identity_index5EntryNCINvMB8_SB14_20sort_unstable_by_keyyNCINvMs0_B16_NtB16_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs1_0E0EB18_
	movq	%rax, %r12
	leaq	(%rsi,%rbx), %rdx
	leaq	(%rsi,%r14), %r8
	movq	%rsi, %rcx
	movq	%r15, %r9
	callq	_RINvNtNtNtNtCs998Ihx2sztz_4core5slice4sort6shared5pivot11median3_recNtNtCs5Av9rWzHob7_3lib14identity_index5EntryNCINvMB8_SB14_20sort_unstable_by_keyyNCINvMs0_B16_NtB16_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs1_0E0EB18_
	movq	%rax, %rsi
	addq	%rdi, %rbx
	addq	%rdi, %r14
	movq	%rdi, %rcx
	movq	%rbx, %rdx
	movq	%r14, %r8
	movq	%r15, %r9
	callq	_RINvNtNtNtNtCs998Ihx2sztz_4core5slice4sort6shared5pivot11median3_recNtNtCs5Av9rWzHob7_3lib14identity_index5EntryNCINvMB8_SB14_20sort_unstable_by_keyyNCINvMs0_B16_NtB16_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs1_0E0EB18_
	movq	%r12, %rcx
	movq	%rax, %rdi
.LBB3_2:
	movq	(%rcx), %rax
	movq	(%rsi), %rdx
	cmpq	%rdx, %rax
	setb	%r8b
	movq	(%rdi), %r9
	cmpq	%r9, %rax
	setb	%al
	xorb	%r8b, %al
	cmpq	%r9, %rdx
	setb	%dl
	xorb	%r8b, %dl
	cmovneq	%rdi, %rsi
	testb	%al, %al
	cmovneq	%rcx, %rsi
	movq	%rsi, %rax
	.seh_startepilogue
	addq	$40, %rsp
	popq	%rbx
	popq	%rdi
	popq	%rsi
	popq	%r12
	popq	%r14
	popq	%r15
	.seh_endepilogue
	retq
	.seh_endproc

	.def	_RINvNtNtNtNtCs998Ihx2sztz_4core5slice4sort6shared9smallsort12sort8_stableNtNtCs5Av9rWzHob7_3lib14identity_index3RunNCINvMB8_SB19_20sort_unstable_by_keyyNCINvMs0_B1b_NtB1b_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs_0E0EB1d_;
	.scl	3;
	.type	32;
	.endef
	.section	.text,"xr",one_only,_RINvNtNtNtNtCs998Ihx2sztz_4core5slice4sort6shared9smallsort12sort8_stableNtNtCs5Av9rWzHob7_3lib14identity_index3RunNCINvMB8_SB19_20sort_unstable_by_keyyNCINvMs0_B1b_NtB1b_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs_0E0EB1d_,unique,4
	.p2align	4
_RINvNtNtNtNtCs998Ihx2sztz_4core5slice4sort6shared9smallsort12sort8_stableNtNtCs5Av9rWzHob7_3lib14identity_index3RunNCINvMB8_SB19_20sort_unstable_by_keyyNCINvMs0_B1b_NtB1b_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs_0E0EB1d_:
.seh_proc _RINvNtNtNtNtCs998Ihx2sztz_4core5slice4sort6shared9smallsort12sort8_stableNtNtCs5Av9rWzHob7_3lib14identity_index3RunNCINvMB8_SB19_20sort_unstable_by_keyyNCINvMs0_B1b_NtB1b_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs_0E0EB1d_
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
	subq	$32, %rsp
	.seh_stackalloc 32
	.seh_endprologue
	movq	16(%rcx), %rax
	movq	48(%rcx), %r9
	xorl	%edi, %edi
	xorl	%r11d, %r11d
	cmpq	(%rcx), %rax
	setae	%dil
	setb	%r11b
	xorl	%r10d, %r10d
	cmpq	32(%rcx), %r9
	setb	%r10b
	shll	$4, %r11d
	leaq	(%rcx,%r11), %rax
	shll	$4, %edi
	leaq	(%rcx,%rdi), %r9
	movl	%r10d, %ebx
	shll	$4, %ebx
	leaq	(%rcx,%rbx), %rsi
	addq	$32, %rsi
	xorl	$3, %r10d
	shll	$4, %r10d
	movq	32(%rcx,%rbx), %rbx
	movq	(%rcx,%r10), %r14
	movq	(%rcx,%rdi), %rdi
	cmpq	%rdi, %r14
	movq	%r9, %r15
	cmovbq	%rsi, %r15
	cmpq	(%rcx,%r11), %rbx
	cmovbq	%rax, %r15
	cmovbq	%rsi, %rax
	leaq	(%rcx,%r10), %r10
	cmovbq	%r9, %rsi
	cmpq	%rdi, %r14
	cmovaeq	%r10, %r9
	cmovbq	%r10, %rsi
	movq	(%rsi), %r10
	cmpq	(%r15), %r10
	movq	%r15, %r10
	cmovbq	%rsi, %r10
	cmovbq	%r15, %rsi
	movups	(%rax), %xmm0
	movups	%xmm0, (%r8)
	movups	(%r10), %xmm0
	movups	%xmm0, 16(%r8)
	movups	(%rsi), %xmm0
	movups	%xmm0, 32(%r8)
	movups	(%r9), %xmm0
	movups	%xmm0, 48(%r8)
	movq	80(%rcx), %rax
	movq	112(%rcx), %r9
	xorl	%edi, %edi
	xorl	%r11d, %r11d
	cmpq	64(%rcx), %rax
	setae	%dil
	setb	%r11b
	xorl	%r10d, %r10d
	cmpq	96(%rcx), %r9
	setb	%r10b
	shll	$4, %r11d
	leaq	(%rcx,%r11), %rax
	addq	$64, %rax
	shll	$4, %edi
	leaq	(%rcx,%rdi), %r9
	addq	$64, %r9
	movl	%r10d, %ebx
	shll	$4, %ebx
	leaq	(%rcx,%rbx), %rsi
	addq	$96, %rsi
	xorl	$3, %r10d
	shll	$4, %r10d
	movq	96(%rcx,%rbx), %rbx
	movq	64(%rcx,%r10), %r14
	movq	64(%rcx,%rdi), %rdi
	cmpq	%rdi, %r14
	movq	%r9, %r15
	cmovbq	%rsi, %r15
	cmpq	64(%rcx,%r11), %rbx
	cmovbq	%rax, %r15
	cmovbq	%rsi, %rax
	cmovbq	%r9, %rsi
	cmpq	%rdi, %r14
	leaq	64(%rcx,%r10), %rcx
	cmovaeq	%rcx, %r9
	cmovbq	%rcx, %rsi
	movq	(%rsi), %rcx
	cmpq	(%r15), %rcx
	movq	%r15, %rcx
	cmovbq	%rsi, %rcx
	cmovbq	%r15, %rsi
	leaq	64(%r8), %r10
	movups	(%rax), %xmm0
	movups	%xmm0, 64(%r8)
	movups	(%rcx), %xmm0
	movups	%xmm0, 80(%r8)
	movups	(%rsi), %xmm0
	movups	%xmm0, 96(%r8)
	movups	(%r9), %xmm0
	movups	%xmm0, 112(%r8)
	movq	64(%r8), %rax
	xorl	%ecx, %ecx
	xorl	%esi, %esi
	cmpq	(%r8), %rax
	setae	%cl
	setb	%sil
	cmovaeq	%r8, %r10
	movups	(%r10), %xmm0
	movups	%xmm0, (%rdx)
	movq	112(%r8), %r9
	movq	48(%r8), %rdi
	xorl	%eax, %eax
	cmpq	%rdi, %r9
	movl	$0, %r10d
	adcq	$-1, %r10
	cmpq	%rdi, %r9
	movl	$0, %r11d
	sbbq	%r11, %r11
	leaq	48(%r8), %rbx
	leaq	112(%r8), %r14
	cmpq	%rdi, %r9
	cmovbq	%rbx, %r14
	shll	$4, %esi
	leaq	(%r8,%rsi), %r9
	addq	$64, %r9
	shll	$4, %ecx
	movups	(%r14), %xmm0
	movups	%xmm0, 112(%rdx)
	shlq	$4, %r10
	shlq	$4, %r11
	movq	64(%r8,%rsi), %rsi
	xorl	%r14d, %r14d
	xorl	%edi, %edi
	cmpq	(%r8,%rcx), %rsi
	leaq	(%r8,%rcx), %r12
	setae	%r14b
	setb	%dil
	movq	%r12, %rcx
	cmovbq	%r9, %rcx
	movups	(%rcx), %xmm0
	movups	%xmm0, 16(%rdx)
	movq	112(%r8,%r10), %rsi
	movq	48(%r8,%r11), %rbx
	cmpq	%rbx, %rsi
	movl	$0, %ecx
	adcq	$-1, %rcx
	cmpq	%rbx, %rsi
	leaq	112(%r8,%r10), %rbx
	leaq	48(%r8,%r11), %r11
	movq	%rbx, %r10
	cmovbq	%r11, %r10
	movl	$0, %r8d
	sbbq	%r8, %r8
	shll	$4, %edi
	leaq	(%r9,%rdi), %rsi
	shll	$4, %r14d
	movups	(%r10), %xmm0
	movups	%xmm0, 96(%rdx)
	shlq	$4, %rcx
	shlq	$4, %r8
	movq	(%rdi,%r9), %r9
	xorl	%edi, %edi
	xorl	%r15d, %r15d
	cmpq	(%r14,%r12), %r9
	leaq	(%r12,%r14), %r14
	setae	%dil
	setb	%r15b
	movq	%r14, %r9
	cmovbq	%rsi, %r9
	movups	(%r9), %xmm0
	movups	%xmm0, 32(%rdx)
	movq	(%rcx,%rbx), %r12
	movq	(%r8,%r11), %r13
	cmpq	%r13, %r12
	movl	$0, %r10d
	adcq	$-1, %r10
	cmpq	%r13, %r12
	movl	$0, %r9d
	sbbq	%r9, %r9
	addq	%rbx, %rcx
	addq	%r11, %r8
	cmpq	%r13, %r12
	movq	%rcx, %r11
	cmovbq	%r8, %r11
	shll	$4, %r15d
	leaq	(%rsi,%r15), %rbx
	shll	$4, %edi
	movups	(%r11), %xmm0
	movups	%xmm0, 80(%rdx)
	leaq	(%r14,%rdi), %r11
	shlq	$4, %r10
	shlq	$4, %r9
	movq	(%r15,%rsi), %r12
	xorl	%esi, %esi
	xorl	%r15d, %r15d
	cmpq	(%rdi,%r14), %r12
	setae	%dil
	setb	%r15b
	movq	%r11, %r14
	cmovbq	%rbx, %r14
	movups	(%r14), %xmm0
	movups	%xmm0, 48(%rdx)
	movq	(%r10,%rcx), %r14
	movq	(%r9,%r8), %r12
	cmpq	%r12, %r14
	movl	$0, %r13d
	adcq	$-1, %r13
	cmpq	%r12, %r14
	sbbq	%rax, %rax
	addq	%rcx, %r10
	addq	%r8, %r9
	cmpq	%r12, %r14
	movq	%r10, %rcx
	cmovbq	%r9, %rcx
	shll	$4, %r15d
	addq	%rbx, %r15
	movups	(%rcx), %xmm0
	movups	%xmm0, 64(%rdx)
	shlq	$4, %r13
	leaq	(%r10,%r13), %rcx
	addq	$16, %rcx
	cmpq	%rcx, %r15
	jne	.LBB4_2
	movb	%dil, %sil
	shll	$4, %esi
	addq	%rsi, %r11
	shlq	$4, %rax
	addq	%r9, %rax
	addq	$16, %rax
	cmpq	%rax, %r11
	jne	.LBB4_2
	.seh_startepilogue
	addq	$32, %rsp
	popq	%rbx
	popq	%rdi
	popq	%rsi
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	.seh_endepilogue
	retq
.LBB4_2:
	callq	_RNvNtNtNtNtCs998Ihx2sztz_4core5slice4sort6shared9smallsort22panic_on_ord_violation
	ud2
	.seh_endproc

	.def	_RINvNtNtNtNtCs998Ihx2sztz_4core5slice4sort6shared9smallsort12sort8_stableNtNtCs5Av9rWzHob7_3lib14identity_index5EntryNCINvMB8_SB19_20sort_unstable_by_keyyNCINvMs0_B1b_NtB1b_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs1_0E0EB1d_;
	.scl	3;
	.type	32;
	.endef
	.section	.text,"xr",one_only,_RINvNtNtNtNtCs998Ihx2sztz_4core5slice4sort6shared9smallsort12sort8_stableNtNtCs5Av9rWzHob7_3lib14identity_index5EntryNCINvMB8_SB19_20sort_unstable_by_keyyNCINvMs0_B1b_NtB1b_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs1_0E0EB1d_,unique,5
	.p2align	4
_RINvNtNtNtNtCs998Ihx2sztz_4core5slice4sort6shared9smallsort12sort8_stableNtNtCs5Av9rWzHob7_3lib14identity_index5EntryNCINvMB8_SB19_20sort_unstable_by_keyyNCINvMs0_B1b_NtB1b_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs1_0E0EB1d_:
.seh_proc _RINvNtNtNtNtCs998Ihx2sztz_4core5slice4sort6shared9smallsort12sort8_stableNtNtCs5Av9rWzHob7_3lib14identity_index5EntryNCINvMB8_SB19_20sort_unstable_by_keyyNCINvMs0_B1b_NtB1b_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs1_0E0EB1d_
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
	pushq	%rbp
	.seh_pushreg %rbp
	pushq	%rbx
	.seh_pushreg %rbx
	subq	$40, %rsp
	.seh_stackalloc 40
	.seh_endprologue
	movq	12(%rcx), %rax
	movq	36(%rcx), %r9
	xorl	%esi, %esi
	xorl	%r10d, %r10d
	cmpq	(%rcx), %rax
	setae	%sil
	setb	%r10b
	leaq	36(%rcx), %r11
	leaq	24(%rcx), %rdi
	cmpq	24(%rcx), %r9
	leaq	(%r10,%r10,2), %rbx
	leaq	(%rcx,%rbx,4), %r10
	leaq	(%rsi,%rsi,2), %rsi
	movq	%rdi, %r9
	cmovbq	%r11, %r9
	leaq	(%rcx,%rsi,4), %rax
	cmovbq	%rdi, %r11
	movq	(%r9), %rdi
	movq	(%r11), %r14
	movq	(%rcx,%rsi,4), %rsi
	cmpq	%rsi, %r14
	movq	%rax, %r15
	cmovbq	%r9, %r15
	cmpq	(%rcx,%rbx,4), %rdi
	cmovbq	%r10, %r15
	cmovbq	%r9, %r10
	cmovbq	%rax, %r9
	cmpq	%rsi, %r14
	cmovaeq	%r11, %rax
	cmovbq	%r11, %r9
	movq	(%r9), %r11
	cmpq	(%r15), %r11
	movq	%r15, %r11
	cmovbq	%r9, %r11
	cmovbq	%r15, %r9
	movl	8(%r10), %esi
	movl	%esi, 8(%r8)
	movq	(%r10), %r10
	movq	%r10, (%r8)
	movl	8(%r11), %r10d
	movl	%r10d, 20(%r8)
	movq	(%r11), %r10
	movq	%r10, 12(%r8)
	movl	8(%r9), %r10d
	movl	%r10d, 32(%r8)
	movq	(%r9), %r9
	movq	%r9, 24(%r8)
	movl	8(%rax), %r9d
	movl	%r9d, 44(%r8)
	movq	(%rax), %rax
	movq	%rax, 36(%r8)
	movq	60(%rcx), %rax
	movq	84(%rcx), %r9
	xorl	%esi, %esi
	xorl	%r10d, %r10d
	cmpq	48(%rcx), %rax
	setae	%sil
	setb	%r10b
	leaq	84(%rcx), %r11
	leaq	72(%rcx), %rdi
	cmpq	72(%rcx), %r9
	leaq	(%r10,%r10,2), %rbx
	leaq	48(%rcx,%rbx,4), %r10
	leaq	(%rsi,%rsi,2), %rsi
	movq	%rdi, %r9
	cmovbq	%r11, %r9
	leaq	48(%rcx,%rsi,4), %rax
	cmovbq	%rdi, %r11
	movq	(%r9), %rdi
	movq	(%r11), %r14
	movq	48(%rcx,%rsi,4), %rsi
	cmpq	%rsi, %r14
	movq	%rax, %r15
	cmovbq	%r9, %r15
	cmpq	48(%rcx,%rbx,4), %rdi
	cmovbq	%r10, %r15
	cmovbq	%r9, %r10
	cmovbq	%rax, %r9
	cmpq	%rsi, %r14
	cmovaeq	%r11, %rax
	cmovbq	%r11, %r9
	movq	(%r9), %rcx
	cmpq	(%r15), %rcx
	movq	%r15, %rcx
	cmovbq	%r9, %rcx
	cmovbq	%r15, %r9
	movl	8(%r10), %r11d
	movl	%r11d, 56(%r8)
	movq	(%r10), %r10
	movq	%r10, 48(%r8)
	movq	(%rcx), %r10
	movq	%r10, 60(%r8)
	movl	8(%rcx), %ecx
	movl	%ecx, 68(%r8)
	movq	(%r9), %rcx
	movq	%rcx, 72(%r8)
	movl	8(%r9), %ecx
	movl	%ecx, 80(%r8)
	movq	(%rax), %rcx
	movq	%rcx, 84(%r8)
	movl	8(%rax), %eax
	movl	%eax, 92(%r8)
	movq	48(%r8), %rax
	xorl	%r9d, %r9d
	xorl	%ecx, %ecx
	cmpq	(%r8), %rax
	leaq	48(%r8), %rax
	setae	%r9b
	cmovaeq	%r8, %rax
	setb	%cl
	movl	8(%rax), %r10d
	movl	%r10d, 8(%rdx)
	movq	(%rax), %rax
	movq	%rax, (%rdx)
	movq	84(%r8), %r10
	movq	36(%r8), %r11
	xorl	%eax, %eax
	cmpq	%r11, %r10
	movl	$0, %esi
	adcq	$-1, %rsi
	cmpq	%r11, %r10
	movl	$0, %edi
	sbbq	%rdi, %rdi
	leaq	36(%r8), %rbx
	leaq	84(%r8), %r14
	cmpq	%r11, %r10
	leaq	(%rcx,%rcx,2), %r11
	leaq	48(%r8,%r11,4), %rcx
	leaq	(%r9,%r9,2), %r9
	leaq	(%r8,%r9,4), %r10
	cmovbq	%rbx, %r14
	movl	8(%r14), %ebx
	movl	%ebx, 92(%rdx)
	movq	(%r14), %rbx
	movq	%rbx, 84(%rdx)
	leaq	(%rsi,%rsi,2), %rsi
	movq	48(%r8,%r11,4), %r11
	xorl	%ebx, %ebx
	xorl	%r14d, %r14d
	cmpq	(%r8,%r9,4), %r11
	leaq	(%rdi,%rdi,2), %r9
	setae	%bl
	setb	%r14b
	movq	%r10, %r11
	cmovbq	%rcx, %r11
	movl	8(%r11), %edi
	movl	%edi, 20(%rdx)
	movq	(%r11), %r11
	movq	%r11, 12(%rdx)
	movq	84(%r8,%rsi,4), %r11
	movq	36(%r8,%r9,4), %rdi
	cmpq	%rdi, %r11
	movl	$0, %r15d
	adcq	$-1, %r15
	cmpq	%rdi, %r11
	leaq	84(%r8,%rsi,4), %r11
	leaq	36(%r8,%r9,4), %rsi
	leaq	(%r14,%r14,2), %rdi
	leaq	(%rcx,%rdi,4), %r8
	leaq	(%rbx,%rbx,2), %rbx
	leaq	(%r10,%rbx,4), %r9
	movq	%r11, %r14
	cmovbq	%rsi, %r14
	movl	8(%r14), %ebp
	movl	%ebp, 80(%rdx)
	movq	(%r14), %r14
	movq	%r14, 72(%rdx)
	leaq	(%r15,%r15,2), %r14
	movl	$0, %r15d
	sbbq	%r15, %r15
	movq	(%rcx,%rdi,4), %rcx
	xorl	%edi, %edi
	xorl	%r12d, %r12d
	cmpq	(%r10,%rbx,4), %rcx
	leaq	(%r15,%r15,2), %rcx
	setae	%dil
	setb	%r12b
	movq	%r9, %r10
	cmovbq	%r8, %r10
	movl	8(%r10), %ebx
	movl	%ebx, 32(%rdx)
	movq	(%r10), %r10
	movq	%r10, 24(%rdx)
	movq	(%r11,%r14,4), %r10
	movq	(%rsi,%rcx,4), %rbx
	cmpq	%rbx, %r10
	movl	$0, %r15d
	adcq	$-1, %r15
	cmpq	%rbx, %r10
	leaq	(%r11,%r14,4), %r11
	leaq	(%rsi,%rcx,4), %rsi
	leaq	(%r12,%r12,2), %rbx
	leaq	(%r8,%rbx,4), %r10
	leaq	(%rdi,%rdi,2), %rdi
	leaq	(%r9,%rdi,4), %rcx
	movq	%r11, %r14
	cmovbq	%rsi, %r14
	movl	8(%r14), %ebp
	movl	%ebp, 68(%rdx)
	movq	(%r14), %r14
	movq	%r14, 60(%rdx)
	leaq	(%r15,%r15,2), %r14
	movl	$0, %r15d
	sbbq	%r15, %r15
	leaq	(%r15,%r15,2), %r15
	movq	(%r8,%rbx,4), %rbx
	xorl	%r8d, %r8d
	xorl	%r12d, %r12d
	cmpq	(%r9,%rdi,4), %rbx
	setae	%r9b
	movq	%rcx, %rdi
	cmovbq	%r10, %rdi
	setb	%r12b
	movl	8(%rdi), %ebx
	movl	%ebx, 44(%rdx)
	movq	(%rdi), %rdi
	movq	%rdi, 36(%rdx)
	movq	(%r11,%r14,4), %rdi
	movq	(%rsi,%r15,4), %rbx
	cmpq	%rbx, %rdi
	movl	$0, %r13d
	adcq	$-1, %r13
	cmpq	%rbx, %rdi
	leaq	(%r11,%r14,4), %rdi
	leaq	(%rsi,%r15,4), %r11
	leaq	(%r12,%r12,2), %rsi
	leaq	(%r13,%r13,2), %rbx
	leaq	12(%rdi,%rbx,4), %rbx
	cmovbq	%r11, %rdi
	leaq	(%r10,%rsi,4), %r10
	movl	8(%rdi), %esi
	movl	%esi, 56(%rdx)
	movq	(%rdi), %rsi
	movq	%rsi, 48(%rdx)
	sbbq	%rax, %rax
	cmpq	%rbx, %r10
	jne	.LBB5_2
	movb	%r9b, %r8b
	leaq	(%r8,%r8,2), %rdx
	leaq	(%rcx,%rdx,4), %rcx
	leaq	(%rax,%rax,2), %rax
	leaq	(%r11,%rax,4), %rax
	addq	$12, %rax
	cmpq	%rax, %rcx
	jne	.LBB5_2
	.seh_startepilogue
	addq	$40, %rsp
	popq	%rbx
	popq	%rbp
	popq	%rdi
	popq	%rsi
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	.seh_endepilogue
	retq
.LBB5_2:
	callq	_RNvNtNtNtNtCs998Ihx2sztz_4core5slice4sort6shared9smallsort22panic_on_ord_violation
	ud2
	.seh_endproc

	.def	_RINvNtNtNtNtCs998Ihx2sztz_4core5slice4sort8unstable8heapsort8heapsortNtNtCs5Av9rWzHob7_3lib14identity_index3RunNCINvMB8_SB15_20sort_unstable_by_keyyNCINvMs0_B17_NtB17_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs_0E0EB19_;
	.scl	2;
	.type	32;
	.endef
	.section	.text,"xr",one_only,_RINvNtNtNtNtCs998Ihx2sztz_4core5slice4sort8unstable8heapsort8heapsortNtNtCs5Av9rWzHob7_3lib14identity_index3RunNCINvMB8_SB15_20sort_unstable_by_keyyNCINvMs0_B17_NtB17_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs_0E0EB19_,unique,6
	.globl	_RINvNtNtNtNtCs998Ihx2sztz_4core5slice4sort8unstable8heapsort8heapsortNtNtCs5Av9rWzHob7_3lib14identity_index3RunNCINvMB8_SB15_20sort_unstable_by_keyyNCINvMs0_B17_NtB17_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs_0E0EB19_
	.p2align	4
_RINvNtNtNtNtCs998Ihx2sztz_4core5slice4sort8unstable8heapsort8heapsortNtNtCs5Av9rWzHob7_3lib14identity_index3RunNCINvMB8_SB15_20sort_unstable_by_keyyNCINvMs0_B17_NtB17_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs_0E0EB19_:
.seh_proc _RINvNtNtNtNtCs998Ihx2sztz_4core5slice4sort8unstable8heapsort8heapsortNtNtCs5Av9rWzHob7_3lib14identity_index3RunNCINvMB8_SB15_20sort_unstable_by_keyyNCINvMs0_B17_NtB17_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs_0E0EB19_
	pushq	%rsi
	.seh_pushreg %rsi
	pushq	%rdi
	.seh_pushreg %rdi
	subq	$24, %rsp
	.seh_stackalloc 24
	.seh_endprologue
	movq	%rdx, %rax
	shrq	%rax
	addq	%rdx, %rax
	jne	.LBB6_1
.LBB6_9:
	.seh_startepilogue
	addq	$24, %rsp
	popq	%rdi
	popq	%rsi
	.seh_endepilogue
	retq
	.p2align	4
.LBB6_8:
	testq	%rax, %rax
	je	.LBB6_9
.LBB6_1:
	decq	%rax
	movq	%rax, %r8
	subq	%rdx, %r8
	jae	.LBB6_3
	movq	%rax, %r8
	shlq	$4, %r8
	movups	(%rcx), %xmm0
	movaps	%xmm0, (%rsp)
	movups	(%rcx,%r8), %xmm0
	movups	%xmm0, (%rcx)
	movaps	(%rsp), %xmm0
	movups	%xmm0, (%rcx,%r8)
	xorl	%r8d, %r8d
.LBB6_3:
	cmpq	%rax, %rdx
	movq	%rax, %r9
	cmovbq	%rdx, %r9
	leaq	1(,%r8,2), %r10
	cmpq	%r9, %r10
	jae	.LBB6_8
	leaq	(%r8,%r8), %rsi
	.p2align	4
.LBB6_5:
	addq	$2, %rsi
	cmpq	%r9, %rsi
	jae	.LBB6_6
	movq	%r10, %r11
	shlq	$4, %r11
	shlq	$4, %rsi
	movq	(%rcx,%r11), %r11
	cmpq	(%rcx,%rsi), %r11
	adcq	$0, %r10
.LBB6_6:
	movq	%r10, %r11
	shlq	$4, %r8
	shlq	$4, %r10
	movq	(%rcx,%r8), %rsi
	movq	(%rcx,%r10), %rdi
	cmpq	%rdi, %rsi
	jae	.LBB6_8
	addq	%rcx, %r8
	addq	%rcx, %r10
	movq	%rdi, (%r8)
	movq	%rsi, (%r10)
	movq	8(%r8), %rsi
	movq	8(%r10), %rdi
	movq	%rdi, 8(%r8)
	movq	%rsi, 8(%r10)
	leaq	(%r11,%r11), %rsi
	leaq	1(,%r11,2), %r10
	movq	%r11, %r8
	cmpq	%r9, %r10
	jb	.LBB6_5
	jmp	.LBB6_8
	.seh_endproc

	.def	_RINvNtNtNtNtCs998Ihx2sztz_4core5slice4sort8unstable8heapsort8heapsortNtNtCs5Av9rWzHob7_3lib14identity_index5EntryNCINvMB8_SB15_20sort_unstable_by_keyyNCINvMs0_B17_NtB17_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs1_0E0EB19_;
	.scl	2;
	.type	32;
	.endef
	.section	.text,"xr",one_only,_RINvNtNtNtNtCs998Ihx2sztz_4core5slice4sort8unstable8heapsort8heapsortNtNtCs5Av9rWzHob7_3lib14identity_index5EntryNCINvMB8_SB15_20sort_unstable_by_keyyNCINvMs0_B17_NtB17_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs1_0E0EB19_,unique,7
	.globl	_RINvNtNtNtNtCs998Ihx2sztz_4core5slice4sort8unstable8heapsort8heapsortNtNtCs5Av9rWzHob7_3lib14identity_index5EntryNCINvMB8_SB15_20sort_unstable_by_keyyNCINvMs0_B17_NtB17_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs1_0E0EB19_
	.p2align	4
_RINvNtNtNtNtCs998Ihx2sztz_4core5slice4sort8unstable8heapsort8heapsortNtNtCs5Av9rWzHob7_3lib14identity_index5EntryNCINvMB8_SB15_20sort_unstable_by_keyyNCINvMs0_B17_NtB17_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs1_0E0EB19_:
.seh_proc _RINvNtNtNtNtCs998Ihx2sztz_4core5slice4sort8unstable8heapsort8heapsortNtNtCs5Av9rWzHob7_3lib14identity_index5EntryNCINvMB8_SB15_20sort_unstable_by_keyyNCINvMs0_B17_NtB17_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs1_0E0EB19_
	pushq	%rsi
	.seh_pushreg %rsi
	pushq	%rdi
	.seh_pushreg %rdi
	subq	$16, %rsp
	.seh_stackalloc 16
	.seh_endprologue
	movq	%rdx, %rax
	shrq	%rax
	addq	%rdx, %rax
	jne	.LBB7_1
.LBB7_9:
	.seh_startepilogue
	addq	$16, %rsp
	popq	%rdi
	popq	%rsi
	.seh_endepilogue
	retq
	.p2align	4
.LBB7_8:
	testq	%rax, %rax
	je	.LBB7_9
.LBB7_1:
	decq	%rax
	movq	%rax, %r9
	subq	%rdx, %r9
	jae	.LBB7_3
	leaq	(%rax,%rax,2), %r8
	movl	8(%rcx), %r9d
	movl	%r9d, 8(%rsp)
	movq	(%rcx), %r9
	movq	%r9, (%rsp)
	movl	8(%rcx,%r8,4), %r9d
	movq	(%rcx,%r8,4), %r10
	movq	%r10, (%rcx)
	movl	%r9d, 8(%rcx)
	movl	8(%rsp), %r9d
	movl	%r9d, 8(%rcx,%r8,4)
	movq	(%rsp), %r9
	movq	%r9, (%rcx,%r8,4)
	xorl	%r9d, %r9d
.LBB7_3:
	cmpq	%rax, %rdx
	movq	%rax, %r8
	cmovbq	%rdx, %r8
	leaq	1(,%r9,2), %r10
	cmpq	%r8, %r10
	jae	.LBB7_8
	leaq	(%r9,%r9), %rsi
	.p2align	4
.LBB7_5:
	addq	$2, %rsi
	cmpq	%r8, %rsi
	jae	.LBB7_6
	leaq	(%r10,%r10,2), %r11
	leaq	(%rsi,%rsi,2), %rsi
	movq	(%rcx,%r11,4), %r11
	cmpq	(%rcx,%rsi,4), %r11
	adcq	$0, %r10
.LBB7_6:
	movq	%r10, %r11
	leaq	(%r9,%r9,2), %r10
	leaq	(%r11,%r11,2), %rsi
	movq	(%rcx,%r10,4), %r9
	movq	(%rcx,%rsi,4), %rdi
	cmpq	%rdi, %r9
	jae	.LBB7_8
	leaq	(%rcx,%r10,4), %r10
	leaq	(%rcx,%rsi,4), %rsi
	movq	%rdi, (%r10)
	movq	%r9, (%rsi)
	movl	8(%r10), %r9d
	movl	8(%rsi), %edi
	movl	%edi, 8(%r10)
	movl	%r9d, 8(%rsi)
	leaq	(%r11,%r11), %rsi
	leaq	1(,%r11,2), %r10
	movq	%r11, %r9
	cmpq	%r8, %r10
	jb	.LBB7_5
	jmp	.LBB7_8
	.seh_endproc

	.def	_RINvNtNtNtNtCs998Ihx2sztz_4core5slice4sort8unstable9quicksort9quicksortNtNtCs5Av9rWzHob7_3lib14identity_index3RunNCINvMB8_SB17_20sort_unstable_by_keyyNCINvMs0_B19_NtB19_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs_0E0EB1b_;
	.scl	3;
	.type	32;
	.endef
	.section	.text,"xr",one_only,_RINvNtNtNtNtCs998Ihx2sztz_4core5slice4sort8unstable9quicksort9quicksortNtNtCs5Av9rWzHob7_3lib14identity_index3RunNCINvMB8_SB17_20sort_unstable_by_keyyNCINvMs0_B19_NtB19_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs_0E0EB1b_,unique,8
	.p2align	4
_RINvNtNtNtNtCs998Ihx2sztz_4core5slice4sort8unstable9quicksort9quicksortNtNtCs5Av9rWzHob7_3lib14identity_index3RunNCINvMB8_SB17_20sort_unstable_by_keyyNCINvMs0_B19_NtB19_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs_0E0EB1b_:
.Lfunc_begin0:
.seh_proc _RINvNtNtNtNtCs998Ihx2sztz_4core5slice4sort8unstable9quicksort9quicksortNtNtCs5Av9rWzHob7_3lib14identity_index3RunNCINvMB8_SB17_20sort_unstable_by_keyyNCINvMs0_B19_NtB19_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs_0E0EB1b_
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
	subq	$856, %rsp
	.seh_stackalloc 856
	leaq	128(%rsp), %rbp
	.seh_setframe %rbp, 128
	.seh_endprologue
	movq	$-2, 720(%rbp)
	movq	%rdx, %r12
	movq	%rcx, %r13
	cmpq	$33, %rdx
	jae	.LBB8_1
.LBB8_5:
	cmpq	$2, %r12
	jb	.LBB8_43
	movq	%r12, %rdi
	shrq	%rdi
	cmpq	$15, %r12
	jbe	.LBB8_7
	movq	%r12, %rbx
	shlq	$4, %rbx
	leaq	(%rbx,%rbp), %r8
	addq	$-80, %r8
	leaq	-80(%rbp), %rdx
	movq	%r13, %rcx
	callq	_RINvNtNtNtNtCs998Ihx2sztz_4core5slice4sort6shared9smallsort12sort8_stableNtNtCs5Av9rWzHob7_3lib14identity_index3RunNCINvMB8_SB19_20sort_unstable_by_keyyNCINvMs0_B1b_NtB1b_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs_0E0EB1d_
	movq	%rdi, %rax
	shlq	$4, %rax
	leaq	(%rax,%r13), %rcx
	leaq	(%rax,%rbp), %rdx
	addq	$-80, %rdx
	leaq	(%rbx,%rbp), %r8
	addq	$48, %r8
	callq	_RINvNtNtNtNtCs998Ihx2sztz_4core5slice4sort6shared9smallsort12sort8_stableNtNtCs5Av9rWzHob7_3lib14identity_index3RunNCINvMB8_SB19_20sort_unstable_by_keyyNCINvMs0_B1b_NtB1b_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs_0E0EB1d_
	movl	$8, %ecx
	movq	%r12, %rdx
	subq	%rdi, %rdx
	cmpq	%rdi, %rcx
	jb	.LBB8_11
	jmp	.LBB8_16
.LBB8_1:
	movl	%r9d, %edi
	movq	%r8, %rbx
	movq	832(%rbp), %rax
	movq	%rax, 712(%rbp)
	leaq	-80(%rbp), %r15
	jmp	.LBB8_2
	.p2align	4
.LBB8_62:
	movq	%rax, %rcx
	shlq	$4, %rcx
	movups	(%r13), %xmm0
	movaps	%xmm0, -80(%rbp)
	movups	(%r13,%rcx), %xmm0
	movups	%xmm0, (%r13)
	movaps	-80(%rbp), %xmm0
	movups	%xmm0, (%r13,%rcx)
	incq	%rax
	subq	%rax, %r12
	shlq	$4, %rax
	addq	%rax, %r13
	xorl	%ebx, %ebx
	cmpq	$33, %r12
	jb	.LBB8_5
.LBB8_2:
	testl	%edi, %edi
	je	.LBB8_67
	movq	%r12, %r9
	shrq	$3, %r9
	movq	%r9, %rax
	shlq	$6, %rax
	addq	%r13, %rax
	imulq	$112, %r9, %r8
	addq	%r13, %r8
	cmpq	$64, %r12
	jae	.LBB8_4
	movq	(%r13), %rcx
	movq	(%rax), %rdx
	cmpq	%rdx, %rcx
	setb	%r9b
	movq	(%r8), %r10
	cmpq	%r10, %rcx
	setb	%cl
	xorb	%r9b, %cl
	cmpq	%r10, %rdx
	setb	%dl
	xorb	%r9b, %dl
	cmovneq	%r8, %rax
	testb	%cl, %cl
	cmovneq	%r13, %rax
	decl	%edi
	subq	%r13, %rax
	testq	%rbx, %rbx
	jne	.LBB8_55
	jmp	.LBB8_46
	.p2align	4
.LBB8_4:
	movq	%r13, %rcx
	movq	%rax, %rdx
	callq	_RINvNtNtNtNtCs998Ihx2sztz_4core5slice4sort6shared5pivot11median3_recNtNtCs5Av9rWzHob7_3lib14identity_index3RunNCINvMB8_SB14_20sort_unstable_by_keyyNCINvMs0_B16_NtB16_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs_0E0EB18_
	decl	%edi
	subq	%r13, %rax
	testq	%rbx, %rbx
	je	.LBB8_46
.LBB8_55:
	movq	(%rbx), %rcx
	cmpq	(%r13,%rax), %rcx
	jae	.LBB8_56
.LBB8_46:
	movups	(%r13), %xmm0
	movaps	%xmm0, -80(%rbp)
	movups	(%r13,%rax), %xmm0
	movups	%xmm0, (%r13)
	movaps	-80(%rbp), %xmm0
	movups	%xmm0, (%r13,%rax)
	leaq	16(%r13), %rax
	movups	16(%r13), %xmm0
	movaps	%xmm0, -80(%rbp)
	movq	%r12, %rcx
	shlq	$4, %rcx
	leaq	(%rcx,%r13), %r10
	addq	$-16, %r10
	leaq	32(%r13), %r8
	movq	(%r13), %r9
	cmpq	%r10, %r8
	jae	.LBB8_47
	xorl	%edx, %edx
	.p2align	4
.LBB8_54:
	xorl	%r11d, %r11d
	cmpq	%r9, (%r8)
	setb	%r11b
	movq	%rdx, %rsi
	shlq	$4, %rsi
	movups	(%rax,%rsi), %xmm0
	movups	%xmm0, -16(%r8)
	movups	(%r8), %xmm0
	movups	%xmm0, (%rax,%rsi)
	leaq	(%rdx,%r11), %rsi
	shlq	$4, %rsi
	cmpq	%r9, 16(%r8)
	movups	(%rax,%rsi), %xmm0
	movups	%xmm0, (%r8)
	movups	16(%r8), %xmm0
	movups	%xmm0, (%rax,%rsi)
	adcq	%r11, %rdx
	addq	$32, %r8
	cmpq	%r10, %r8
	jb	.LBB8_54
	leaq	-16(%r8), %r10
	jmp	.LBB8_49
	.p2align	4
.LBB8_47:
	movq	%rax, %r10
	xorl	%edx, %edx
.LBB8_49:
	addq	%r13, %rcx
	.p2align	4
.LBB8_50:
	cmpq	%rcx, %r8
	movq	%r8, %r11
	cmoveq	%r15, %r11
	movq	%rdx, %rsi
	shlq	$4, %rsi
	cmpq	%r9, (%r11)
	adcq	$0, %rdx
	movups	(%rax,%rsi), %xmm0
	movups	%xmm0, (%r10)
	movups	(%r11), %xmm0
	movups	%xmm0, (%rax,%rsi)
	cmpq	%rcx, %r8
	movq	%r8, %r10
	leaq	16(%r8), %r8
	jne	.LBB8_50
	cmpq	%r12, %rdx
	jae	.LBB8_37
	movq	%rdx, %rax
	shlq	$4, %rax
	leaq	(%rax,%r13), %rsi
	movups	(%r13), %xmm0
	movaps	%xmm0, -80(%rbp)
	movups	(%r13,%rax), %xmm0
	movups	%xmm0, (%r13)
	movaps	-80(%rbp), %xmm0
	movups	%xmm0, (%r13,%rax)
	leaq	(%rax,%r13), %r14
	addq	$16, %r14
	movq	%rdx, %rax
	notq	%rax
	addq	%rax, %r12
	movq	712(%rbp), %rax
	movq	%rax, 32(%rsp)
	movq	%r13, %rcx
	movq	%rbx, %r8
	movl	%edi, %r9d
	callq	_RINvNtNtNtNtCs998Ihx2sztz_4core5slice4sort8unstable9quicksort9quicksortNtNtCs5Av9rWzHob7_3lib14identity_index3RunNCINvMB8_SB17_20sort_unstable_by_keyyNCINvMs0_B19_NtB19_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs_0E0EB1b_
	movq	%rsi, %rbx
	movq	%r14, %r13
	cmpq	$33, %r12
	jae	.LBB8_2
	jmp	.LBB8_5
	.p2align	4
.LBB8_56:
	addq	%r13, %rax
	movups	(%r13), %xmm0
	movaps	%xmm0, -80(%rbp)
	movups	(%rax), %xmm0
	movups	%xmm0, (%r13)
	movaps	-80(%rbp), %xmm0
	movups	%xmm0, (%rax)
	leaq	16(%r13), %rcx
	movups	16(%r13), %xmm0
	movaps	%xmm0, -80(%rbp)
	movq	%r12, %rdx
	shlq	$4, %rdx
	leaq	(%rdx,%r13), %r10
	addq	$-16, %r10
	leaq	32(%r13), %r8
	movq	(%r13), %r9
	cmpq	%r10, %r8
	jae	.LBB8_57
	xorl	%eax, %eax
	.p2align	4
.LBB8_65:
	movq	%rax, %r11
	shlq	$4, %r11
	cmpq	(%r8), %r9
	movups	(%rcx,%r11), %xmm0
	movups	%xmm0, -16(%r8)
	movups	(%r8), %xmm0
	movups	%xmm0, (%rcx,%r11)
	sbbq	$-1, %rax
	movq	%rax, %r11
	shlq	$4, %r11
	cmpq	16(%r8), %r9
	movups	(%rcx,%r11), %xmm0
	movups	%xmm0, (%r8)
	movups	16(%r8), %xmm0
	movups	%xmm0, (%rcx,%r11)
	sbbq	$-1, %rax
	addq	$32, %r8
	cmpq	%r10, %r8
	jb	.LBB8_65
	leaq	-16(%r8), %r10
	jmp	.LBB8_59
.LBB8_57:
	movq	%rcx, %r10
	xorl	%eax, %eax
.LBB8_59:
	addq	%r13, %rdx
	.p2align	4
.LBB8_60:
	cmpq	%rdx, %r8
	movq	%r8, %r11
	cmoveq	%r15, %r11
	movq	%rax, %rsi
	shlq	$4, %rsi
	cmpq	(%r11), %r9
	sbbq	$-1, %rax
	movups	(%rcx,%rsi), %xmm0
	movups	%xmm0, (%r10)
	movups	(%r11), %xmm0
	movups	%xmm0, (%rcx,%rsi)
	cmpq	%rdx, %r8
	movq	%r8, %r10
	leaq	16(%r8), %r8
	jne	.LBB8_60
	cmpq	%r12, %rax
	jb	.LBB8_62
.LBB8_37:
	ud2
.LBB8_67:
	movq	%r13, %rcx
	movq	%r12, %rdx
	.seh_startepilogue
	addq	$856, %rsp
	popq	%rbx
	popq	%rdi
	popq	%rsi
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.seh_endepilogue
	jmp	_RINvNtNtNtNtCs998Ihx2sztz_4core5slice4sort8unstable8heapsort8heapsortNtNtCs5Av9rWzHob7_3lib14identity_index3RunNCINvMB8_SB15_20sort_unstable_by_keyyNCINvMs0_B17_NtB17_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs_0E0EB19_
.LBB8_7:
	cmpq	$7, %r12
	jbe	.LBB8_8
	movq	16(%r13), %rax
	movq	48(%r13), %rcx
	xorl	%r10d, %r10d
	xorl	%r8d, %r8d
	cmpq	(%r13), %rax
	setae	%r10b
	setb	%r8b
	xorl	%edx, %edx
	cmpq	32(%r13), %rcx
	setb	%dl
	shll	$4, %r8d
	leaq	(%r8,%r13), %rcx
	shll	$4, %r10d
	leaq	(%r10,%r13), %rax
	movl	%edx, %r11d
	shll	$4, %r11d
	leaq	(%r11,%r13), %r9
	addq	$32, %r9
	xorl	$3, %edx
	shll	$4, %edx
	movq	32(%r13,%r11), %r11
	movq	(%r13,%rdx), %rbx
	movq	(%r13,%r10), %r10
	cmpq	%r10, %rbx
	movq	%rax, %r14
	cmovbq	%r9, %r14
	cmpq	(%r13,%r8), %r11
	cmovbq	%rcx, %r14
	cmovbq	%r9, %rcx
	leaq	(%r13,%rdx), %rdx
	cmovbq	%rax, %r9
	cmpq	%r10, %rbx
	cmovaeq	%rdx, %rax
	cmovbq	%rdx, %r9
	movq	(%r9), %rdx
	cmpq	(%r14), %rdx
	movq	%r14, %rdx
	cmovbq	%r9, %rdx
	cmovbq	%r14, %r9
	movups	(%rcx), %xmm0
	movaps	%xmm0, -80(%rbp)
	movups	(%rdx), %xmm0
	movaps	%xmm0, -64(%rbp)
	movups	(%r9), %xmm0
	movq	%rdi, %rcx
	shlq	$4, %rcx
	movq	16(%r13,%rcx), %rdx
	movq	48(%r13,%rcx), %r9
	xorl	%ebx, %ebx
	xorl	%r10d, %r10d
	cmpq	(%r13,%rcx), %rdx
	setae	%bl
	setb	%r10b
	xorl	%r8d, %r8d
	cmpq	32(%r13,%rcx), %r9
	leaq	(%r13,%rcx), %r11
	setb	%r8b
	shll	$4, %r10d
	shll	$4, %ebx
	leaq	(%r11,%rbx), %rdx
	movl	%r8d, %r14d
	shll	$4, %r14d
	leaq	(%r14,%r11), %r9
	addq	$32, %r9
	xorl	$3, %r8d
	shll	$4, %r8d
	movq	(%r8,%r11), %r15
	movq	(%rbx,%r11), %rbx
	cmpq	%rbx, %r15
	movq	%r12, %rsi
	movq	%rdx, %r12
	cmovbq	%r9, %r12
	movq	32(%r11,%r14), %r14
	cmpq	(%r10,%r11), %r14
	leaq	(%r11,%r10), %r10
	cmovbq	%r10, %r12
	cmovbq	%r9, %r10
	leaq	(%r11,%r8), %r8
	cmovbq	%rdx, %r9
	cmpq	%rbx, %r15
	cmovaeq	%r8, %rdx
	cmovbq	%r8, %r9
	movaps	%xmm0, -48(%rbp)
	movq	(%r9), %r8
	cmpq	(%r12), %r8
	movups	(%rax), %xmm0
	movq	%r12, %rax
	cmovbq	%r9, %rax
	movaps	%xmm0, -32(%rbp)
	cmovbq	%r12, %r9
	movq	%rsi, %r12
	movups	(%r10), %xmm0
	movups	%xmm0, -80(%rbp,%rcx)
	movups	(%rax), %xmm0
	movups	%xmm0, -64(%rbp,%rcx)
	movups	(%r9), %xmm0
	movups	%xmm0, -48(%rbp,%rcx)
	movups	(%rdx), %xmm0
	movups	%xmm0, -32(%rbp,%rcx)
	movl	$4, %ecx
	movq	%r12, %rdx
	subq	%rdi, %rdx
	cmpq	%rdi, %rcx
	jb	.LBB8_11
	jmp	.LBB8_16
.LBB8_8:
	movups	(%r13), %xmm0
	movaps	%xmm0, -80(%rbp)
	movq	%rdi, %rax
	shlq	$4, %rax
	movups	(%r13,%rax), %xmm0
	movups	%xmm0, -80(%rbp,%rax)
	movl	$1, %ecx
	movq	%r12, %rdx
	subq	%rdi, %rdx
	cmpq	%rdi, %rcx
	jae	.LBB8_16
.LBB8_11:
	movl	%ecx, %eax
	shll	$4, %eax
	leaq	-80(%rbp), %r8
	movq	%rcx, %r9
	jmp	.LBB8_12
	.p2align	4
.LBB8_15:
	movq	%r8, %rbx
.LBB8_41:
	movq	%r10, (%rbx)
	movq	%r11, 8(%rbx)
.LBB8_42:
	incq	%r9
	addq	$16, %rax
	cmpq	%rdi, %r9
	je	.LBB8_16
.LBB8_12:
	movq	%r9, %r11
	shlq	$4, %r11
	movups	(%r13,%r11), %xmm0
	movups	%xmm0, -80(%rbp,%r11)
	movq	-80(%rbp,%r11), %r10
	cmpq	-96(%rbp,%r11), %r10
	jae	.LBB8_42
	addq	%rbp, %r11
	addq	$-80, %r11
	movq	8(%r11), %r11
	movq	%rax, %rbx
	.p2align	4
.LBB8_14:
	movups	-96(%rbp,%rbx), %xmm0
	movups	%xmm0, -80(%rbp,%rbx)
	cmpq	$16, %rbx
	je	.LBB8_15
	leaq	-16(%rbx), %r14
	cmpq	-112(%rbp,%rbx), %r10
	movq	%r14, %rbx
	jb	.LBB8_14
	leaq	(%r14,%rbp), %rbx
	addq	$-80, %rbx
	jmp	.LBB8_41
.LBB8_16:
	movq	%rdi, %r8
	shlq	$4, %r8
	leaq	(%r8,%rbp), %rax
	addq	$-80, %rax
	cmpq	%rdx, %rcx
	jae	.LBB8_26
	addq	%r13, %r8
	movl	%ecx, %r9d
	shll	$4, %r9d
	jmp	.LBB8_18
	.p2align	4
.LBB8_21:
	movq	%rax, %rbx
.LBB8_24:
	movq	%r10, (%rbx)
	movq	%r11, 8(%rbx)
.LBB8_25:
	incq	%rcx
	addq	$16, %r9
	cmpq	%rdx, %rcx
	je	.LBB8_26
.LBB8_18:
	movq	%rcx, %r11
	shlq	$4, %r11
	movups	(%r8,%r11), %xmm0
	movups	%xmm0, (%rax,%r11)
	movq	(%rax,%r11), %r10
	cmpq	-16(%rax,%r11), %r10
	jae	.LBB8_25
	addq	%rax, %r11
	movq	8(%r11), %r11
	movq	%r9, %r14
	.p2align	4
.LBB8_20:
	movups	-16(%rax,%r14), %xmm0
	movups	%xmm0, (%rax,%r14)
	cmpq	$16, %r14
	je	.LBB8_21
	leaq	-16(%r14), %rbx
	cmpq	-32(%rax,%r14), %r10
	movq	%rbx, %r14
	jb	.LBB8_20
	addq	%rax, %rbx
	jmp	.LBB8_24
.LBB8_26:
	movq	%r12, 688(%rbp)
	shlq	$4, %r12
	leaq	(%r12,%r13), %r10
	addq	$-16, %r10
	movq	%r12, 704(%rbp)
	leaq	-96(%rbp,%r12), %r8
	leaq	-16(%rax), %rcx
	leaq	-80(%rbp), %rdx
	movq	%r13, 696(%rbp)
	movq	%r13, %r9
	jmp	.LBB8_27
	.p2align	4
.LBB8_31:
	movb	%r13b, %bl
	movl	$0, %esi
	sbbq	%rsi, %rsi
	shll	$4, %ebx
	addq	%rbx, %rax
	movb	%r15b, %r11b
	shll	$4, %r11d
	addq	%r11, %rdx
	addq	$16, %r9
	movups	(%r12), %xmm0
	movups	%xmm0, (%r10)
	shlq	$4, %r14
	addq	%r14, %r8
	shlq	$4, %rsi
	addq	%rsi, %rcx
	addq	$-16, %r10
	movq	712(%rbp), %rdi
	decq	%rdi
	je	.LBB8_32
.LBB8_27:
	movq	%rdi, 712(%rbp)
	movq	(%rax), %r15
	xorl	%r11d, %r11d
	xorl	%ebx, %ebx
	movq	%rax, %r14
	cmpq	(%rdx), %r15
	setae	%r15b
	setb	%r13b
	jb	.LBB8_29
	movq	%rdx, %r14
.LBB8_29:
	movups	(%r14), %xmm0
	movups	%xmm0, (%r9)
	movq	(%r8), %rsi
	movq	(%rcx), %rdi
	cmpq	%rdi, %rsi
	movl	$0, %r14d
	adcq	$-1, %r14
	movq	%rcx, %r12
	cmpq	%rdi, %rsi
	jb	.LBB8_31
	movq	%r8, %r12
	jmp	.LBB8_31
.LBB8_32:
	addq	$16, %rcx
	addq	$16, %r8
	testb	$1, 688(%rbp)
	je	.LBB8_34
	xorl	%r10d, %r10d
	xorl	%r11d, %r11d
	cmpq	%rcx, %rdx
	setae	%r10b
	setb	%r11b
	movq	%rax, %rsi
	cmovbq	%rdx, %rsi
	movups	(%rsi), %xmm0
	movups	%xmm0, (%r9)
	shll	$4, %r11d
	addq	%r11, %rdx
	shll	$4, %r10d
	addq	%r10, %rax
.LBB8_34:
	cmpq	%r8, %rax
	jne	.LBB8_36
	cmpq	%rcx, %rdx
	jne	.LBB8_36
.LBB8_43:
	.seh_startepilogue
	addq	$856, %rsp
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
.LBB8_36:
.Ltmp0:
	callq	_RNvNtNtNtNtCs998Ihx2sztz_4core5slice4sort6shared9smallsort22panic_on_ord_violation
	nop
.Ltmp1:
	jmp	.LBB8_37
	.seh_handlerdata
	.long	$cppxdata$_RINvNtNtNtNtCs998Ihx2sztz_4core5slice4sort8unstable9quicksort9quicksortNtNtCs5Av9rWzHob7_3lib14identity_index3RunNCINvMB8_SB17_20sort_unstable_by_keyyNCINvMs0_B19_NtB19_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs_0E0EB1b_@IMGREL
	.section	.text,"xr",one_only,_RINvNtNtNtNtCs998Ihx2sztz_4core5slice4sort8unstable9quicksort9quicksortNtNtCs5Av9rWzHob7_3lib14identity_index3RunNCINvMB8_SB17_20sort_unstable_by_keyyNCINvMs0_B19_NtB19_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs_0E0EB1b_,unique,8
	.seh_endproc
	.def	"?dtor$38@?0?_RINvNtNtNtNtCs998Ihx2sztz_4core5slice4sort8unstable9quicksort9quicksortNtNtCs5Av9rWzHob7_3lib14identity_index3RunNCINvMB8_SB17_20sort_unstable_by_keyyNCINvMs0_B19_NtB19_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs_0E0EB1b_@4HA";
	.scl	3;
	.type	32;
	.endef
	.p2align	4
"?dtor$38@?0?_RINvNtNtNtNtCs998Ihx2sztz_4core5slice4sort8unstable9quicksort9quicksortNtNtCs5Av9rWzHob7_3lib14identity_index3RunNCINvMB8_SB17_20sort_unstable_by_keyyNCINvMs0_B19_NtB19_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs_0E0EB1b_@4HA":
.seh_proc "?dtor$38@?0?_RINvNtNtNtNtCs998Ihx2sztz_4core5slice4sort8unstable9quicksort9quicksortNtNtCs5Av9rWzHob7_3lib14identity_index3RunNCINvMB8_SB17_20sort_unstable_by_keyyNCINvMs0_B19_NtB19_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs_0E0EB1b_@4HA"
.LBB8_38:
	movq	%rdx, 16(%rsp)
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
	subq	$40, %rsp
	.seh_stackalloc 40
	leaq	128(%rdx), %rbp
	.seh_endprologue
	leaq	-80(%rbp), %rdx
	movq	696(%rbp), %rcx
	movq	704(%rbp), %r8
	callq	memcpy
	nop
	.seh_startepilogue
	addq	$40, %rsp
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
.Lfunc_end0:
	.seh_handlerdata
	.section	.text,"xr",one_only,_RINvNtNtNtNtCs998Ihx2sztz_4core5slice4sort8unstable9quicksort9quicksortNtNtCs5Av9rWzHob7_3lib14identity_index3RunNCINvMB8_SB17_20sort_unstable_by_keyyNCINvMs0_B19_NtB19_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs_0E0EB1b_,unique,8
	.seh_endproc
	.section	.xdata,"dr",associative,_RINvNtNtNtNtCs998Ihx2sztz_4core5slice4sort8unstable9quicksort9quicksortNtNtCs5Av9rWzHob7_3lib14identity_index3RunNCINvMB8_SB17_20sort_unstable_by_keyyNCINvMs0_B19_NtB19_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs_0E0EB1b_,unique,0
	.p2align	2, 0x0
$cppxdata$_RINvNtNtNtNtCs998Ihx2sztz_4core5slice4sort8unstable9quicksort9quicksortNtNtCs5Av9rWzHob7_3lib14identity_index3RunNCINvMB8_SB17_20sort_unstable_by_keyyNCINvMs0_B19_NtB19_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs_0E0EB1b_:
	.long	429065506
	.long	1
	.long	$stateUnwindMap$_RINvNtNtNtNtCs998Ihx2sztz_4core5slice4sort8unstable9quicksort9quicksortNtNtCs5Av9rWzHob7_3lib14identity_index3RunNCINvMB8_SB17_20sort_unstable_by_keyyNCINvMs0_B19_NtB19_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs_0E0EB1b_@IMGREL
	.long	0
	.long	0
	.long	3
	.long	$ip2state$_RINvNtNtNtNtCs998Ihx2sztz_4core5slice4sort8unstable9quicksort9quicksortNtNtCs5Av9rWzHob7_3lib14identity_index3RunNCINvMB8_SB17_20sort_unstable_by_keyyNCINvMs0_B19_NtB19_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs_0E0EB1b_@IMGREL
	.long	848
	.long	0
	.long	1
$stateUnwindMap$_RINvNtNtNtNtCs998Ihx2sztz_4core5slice4sort8unstable9quicksort9quicksortNtNtCs5Av9rWzHob7_3lib14identity_index3RunNCINvMB8_SB17_20sort_unstable_by_keyyNCINvMs0_B19_NtB19_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs_0E0EB1b_:
	.long	-1
	.long	"?dtor$38@?0?_RINvNtNtNtNtCs998Ihx2sztz_4core5slice4sort8unstable9quicksort9quicksortNtNtCs5Av9rWzHob7_3lib14identity_index3RunNCINvMB8_SB17_20sort_unstable_by_keyyNCINvMs0_B19_NtB19_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs_0E0EB1b_@4HA"@IMGREL
$ip2state$_RINvNtNtNtNtCs998Ihx2sztz_4core5slice4sort8unstable9quicksort9quicksortNtNtCs5Av9rWzHob7_3lib14identity_index3RunNCINvMB8_SB17_20sort_unstable_by_keyyNCINvMs0_B19_NtB19_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs_0E0EB1b_:
	.long	.Lfunc_begin0@IMGREL
	.long	-1
	.long	.Ltmp0@IMGREL
	.long	0
	.long	.Ltmp1@IMGREL
	.long	-1
	.section	.text,"xr",one_only,_RINvNtNtNtNtCs998Ihx2sztz_4core5slice4sort8unstable9quicksort9quicksortNtNtCs5Av9rWzHob7_3lib14identity_index3RunNCINvMB8_SB17_20sort_unstable_by_keyyNCINvMs0_B19_NtB19_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs_0E0EB1b_,unique,8

	.def	_RINvNtNtNtNtCs998Ihx2sztz_4core5slice4sort8unstable9quicksort9quicksortNtNtCs5Av9rWzHob7_3lib14identity_index5EntryNCINvMB8_SB17_20sort_unstable_by_keyyNCINvMs0_B19_NtB19_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs1_0E0EB1b_;
	.scl	3;
	.type	32;
	.endef
	.section	.text,"xr",one_only,_RINvNtNtNtNtCs998Ihx2sztz_4core5slice4sort8unstable9quicksort9quicksortNtNtCs5Av9rWzHob7_3lib14identity_index5EntryNCINvMB8_SB17_20sort_unstable_by_keyyNCINvMs0_B19_NtB19_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs1_0E0EB1b_,unique,9
	.p2align	4
_RINvNtNtNtNtCs998Ihx2sztz_4core5slice4sort8unstable9quicksort9quicksortNtNtCs5Av9rWzHob7_3lib14identity_index5EntryNCINvMB8_SB17_20sort_unstable_by_keyyNCINvMs0_B19_NtB19_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs1_0E0EB1b_:
.Lfunc_begin1:
.seh_proc _RINvNtNtNtNtCs998Ihx2sztz_4core5slice4sort8unstable9quicksort9quicksortNtNtCs5Av9rWzHob7_3lib14identity_index5EntryNCINvMB8_SB17_20sort_unstable_by_keyyNCINvMs0_B19_NtB19_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs1_0E0EB1b_
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
	subq	$648, %rsp
	.seh_stackalloc 648
	leaq	128(%rsp), %rbp
	.seh_setframe %rbp, 128
	.seh_endprologue
	movq	$-2, 512(%rbp)
	movq	%rdx, %r13
	movq	%rcx, %r12
	cmpq	$33, %rdx
	jae	.LBB9_1
.LBB9_5:
	cmpq	$2, %r13
	jb	.LBB9_39
	movq	%r13, %rsi
	shrq	%rsi
	leaq	(,%r13,2), %rdi
	addq	%r13, %rdi
	cmpq	$15, %r13
	jbe	.LBB9_7
	leaq	-88(,%rdi,4), %r8
	addq	%rbp, %r8
	leaq	-88(%rbp), %rdx
	movq	%r12, %rcx
	callq	_RINvNtNtNtNtCs998Ihx2sztz_4core5slice4sort6shared9smallsort12sort8_stableNtNtCs5Av9rWzHob7_3lib14identity_index5EntryNCINvMB8_SB19_20sort_unstable_by_keyyNCINvMs0_B1b_NtB1b_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs1_0E0EB1d_
	leaq	(,%rsi,4), %rax
	leaq	(%rax,%rax,2), %rax
	leaq	(%r12,%rax), %rcx
	leaq	(%rax,%rbp), %rdx
	addq	$-88, %rdx
	leaq	8(,%rdi,4), %r8
	addq	%rbp, %r8
	callq	_RINvNtNtNtNtCs998Ihx2sztz_4core5slice4sort6shared9smallsort12sort8_stableNtNtCs5Av9rWzHob7_3lib14identity_index5EntryNCINvMB8_SB19_20sort_unstable_by_keyyNCINvMs0_B1b_NtB1b_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs1_0E0EB1d_
	movl	$8, %ecx
	movq	%r13, %rdx
	subq	%rsi, %rdx
	cmpq	%rsi, %rcx
	jb	.LBB9_11
	jmp	.LBB9_16
.LBB9_1:
	movl	%r9d, %esi
	movq	%r8, %rdi
	movq	624(%rbp), %rax
	movq	%rax, 488(%rbp)
	leaq	-88(%rbp), %r14
	jmp	.LBB9_2
	.p2align	4
.LBB9_58:
	leaq	(%rax,%rax,2), %rcx
	movl	8(%r12), %edx
	movl	%edx, -80(%rbp)
	movq	(%r12), %rdx
	movq	%rdx, -88(%rbp)
	movl	8(%r12,%rcx,4), %edx
	movq	(%r12,%rcx,4), %r8
	movq	%r8, (%r12)
	movl	%edx, 8(%r12)
	movl	-80(%rbp), %edx
	movl	%edx, 8(%r12,%rcx,4)
	movq	-88(%rbp), %rdx
	movq	%rdx, (%r12,%rcx,4)
	notq	%rax
	addq	%rax, %r13
	leaq	(%r12,%rcx,4), %r12
	addq	$12, %r12
	xorl	%edi, %edi
	cmpq	$33, %r13
	jb	.LBB9_5
.LBB9_2:
	testl	%esi, %esi
	je	.LBB9_63
	movq	%r13, %r9
	shrq	$3, %r9
	leaq	(%r9,%r9,2), %rax
	shlq	$4, %rax
	addq	%r12, %rax
	imulq	$84, %r9, %r8
	addq	%r12, %r8
	cmpq	$64, %r13
	jae	.LBB9_4
	movq	(%r12), %rcx
	movq	(%rax), %rdx
	cmpq	%rdx, %rcx
	setb	%r9b
	movq	(%r8), %r10
	cmpq	%r10, %rcx
	setb	%cl
	xorb	%r9b, %cl
	cmpq	%r10, %rdx
	setb	%dl
	xorb	%r9b, %dl
	cmovneq	%r8, %rax
	testb	%cl, %cl
	cmovneq	%r12, %rax
	decl	%esi
	subq	%r12, %rax
	testq	%rdi, %rdi
	jne	.LBB9_51
	jmp	.LBB9_42
	.p2align	4
.LBB9_4:
	movq	%r12, %rcx
	movq	%rax, %rdx
	callq	_RINvNtNtNtNtCs998Ihx2sztz_4core5slice4sort6shared5pivot11median3_recNtNtCs5Av9rWzHob7_3lib14identity_index5EntryNCINvMB8_SB14_20sort_unstable_by_keyyNCINvMs0_B16_NtB16_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs1_0E0EB18_
	decl	%esi
	subq	%r12, %rax
	testq	%rdi, %rdi
	je	.LBB9_42
.LBB9_51:
	movq	(%rdi), %rcx
	cmpq	(%r12,%rax), %rcx
	jae	.LBB9_52
.LBB9_42:
	movl	%esi, 496(%rbp)
	movl	8(%r12), %ecx
	movl	%ecx, -80(%rbp)
	movq	(%r12), %rcx
	movq	%rcx, -88(%rbp)
	movl	8(%r12,%rax), %ecx
	movq	(%r12,%rax), %rdx
	movq	%rdx, (%r12)
	movl	%ecx, 8(%r12)
	movl	-80(%rbp), %ecx
	movl	%ecx, 8(%r12,%rax)
	movq	-88(%rbp), %rcx
	movq	%rcx, (%r12,%rax)
	leaq	12(%r12), %rax
	movl	20(%r12), %ecx
	movl	%ecx, -80(%rbp)
	movq	12(%r12), %rcx
	movq	%rcx, -88(%rbp)
	movq	%r13, %rsi
	leaq	(%r13,%r13,2), %r9
	leaq	(%r12,%r9,4), %r10
	addq	$-12, %r10
	leaq	24(%r12), %rcx
	movq	(%r12), %r8
	cmpq	%r10, %rcx
	jae	.LBB9_43
	movq	%r12, 504(%rbp)
	xorl	%edx, %edx
	.p2align	4
.LBB9_50:
	movq	(%rcx), %r11
	xorl	%r15d, %r15d
	cmpq	%r8, %r11
	setb	%r15b
	leaq	(%rdx,%rdx,2), %r12
	movl	8(%rax,%r12,4), %r13d
	movq	(%rax,%r12,4), %rbx
	movq	%rbx, -12(%rcx)
	movl	%r13d, -4(%rcx)
	movl	8(%rcx), %ebx
	movl	%ebx, 8(%rax,%r12,4)
	movq	%r11, (%rax,%r12,4)
	leaq	(%rdx,%r15), %r11
	movq	12(%rcx), %rbx
	cmpq	%r8, %rbx
	leaq	(%r11,%r11,2), %r11
	movl	8(%rax,%r11,4), %r12d
	movq	(%rax,%r11,4), %r13
	movq	%r13, (%rcx)
	movl	%r12d, 8(%rcx)
	movl	20(%rcx), %r12d
	movl	%r12d, 8(%rax,%r11,4)
	movq	%rbx, (%rax,%r11,4)
	adcq	%r15, %rdx
	addq	$24, %rcx
	cmpq	%r10, %rcx
	jb	.LBB9_50
	leaq	-12(%rcx), %r10
	movq	504(%rbp), %r12
	jmp	.LBB9_45
	.p2align	4
.LBB9_43:
	movq	%rax, %r10
	xorl	%edx, %edx
.LBB9_45:
	movq	%r12, %rbx
	leaq	(%r12,%r9,4), %r9
	.p2align	4
.LBB9_46:
	cmpq	%r9, %rcx
	movq	%rcx, %r11
	cmoveq	%r14, %r11
	cmpq	%r8, (%r11)
	leaq	(%rdx,%rdx,2), %r15
	adcq	$0, %rdx
	movq	(%rax,%r15,4), %r12
	movl	8(%rax,%r15,4), %r13d
	movl	%r13d, 8(%r10)
	movq	%r12, (%r10)
	movl	8(%r11), %r10d
	movl	%r10d, 8(%rax,%r15,4)
	movq	(%r11), %r10
	movq	%r10, (%rax,%r15,4)
	cmpq	%r9, %rcx
	movq	%rcx, %r10
	leaq	12(%rcx), %rcx
	jne	.LBB9_46
	cmpq	%rsi, %rdx
	jae	.LBB9_33
	movq	%rsi, %r13
	leaq	(%rdx,%rdx,2), %rax
	movq	%rbx, %rcx
	leaq	(%rbx,%rax,4), %rbx
	movl	8(%rcx), %r8d
	movl	%r8d, -80(%rbp)
	movq	(%rcx), %r8
	movq	%r8, -88(%rbp)
	movl	8(%rcx,%rax,4), %r9d
	movq	(%rcx,%rax,4), %r8
	movq	%r8, (%rcx)
	movl	%r9d, 8(%rcx)
	movl	-80(%rbp), %r8d
	movl	%r8d, 8(%rcx,%rax,4)
	movq	-88(%rbp), %r8
	movq	%r8, (%rcx,%rax,4)
	leaq	(%rcx,%rax,4), %r12
	addq	$12, %r12
	movq	%rdx, %rax
	notq	%rax
	addq	%rax, %r13
	movq	488(%rbp), %rax
	movq	%rax, 32(%rsp)
	movq	%rdi, %r8
	movl	496(%rbp), %esi
	movl	%esi, %r9d
	callq	_RINvNtNtNtNtCs998Ihx2sztz_4core5slice4sort8unstable9quicksort9quicksortNtNtCs5Av9rWzHob7_3lib14identity_index5EntryNCINvMB8_SB17_20sort_unstable_by_keyyNCINvMs0_B19_NtB19_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs1_0E0EB1b_
	movq	%rbx, %rdi
	cmpq	$33, %r13
	jae	.LBB9_2
	jmp	.LBB9_5
	.p2align	4
.LBB9_52:
	addq	%r12, %rax
	movl	8(%r12), %ecx
	movl	%ecx, -80(%rbp)
	movq	(%r12), %rcx
	movq	%rcx, -88(%rbp)
	movl	8(%rax), %ecx
	movq	(%rax), %rdx
	movq	%rdx, (%r12)
	movl	%ecx, 8(%r12)
	movl	-80(%rbp), %ecx
	movl	%ecx, 8(%rax)
	movq	-88(%rbp), %rcx
	movq	%rcx, (%rax)
	leaq	12(%r12), %rcx
	movl	20(%r12), %eax
	movl	%eax, -80(%rbp)
	movq	12(%r12), %rax
	movq	%rax, -88(%rbp)
	leaq	(%r13,%r13,2), %r9
	leaq	(%r12,%r9,4), %r10
	addq	$-12, %r10
	leaq	24(%r12), %rdx
	movq	(%r12), %r8
	cmpq	%r10, %rdx
	jae	.LBB9_53
	xorl	%eax, %eax
	.p2align	4
.LBB9_61:
	movq	(%rdx), %r11
	cmpq	%r11, %r8
	leaq	(%rax,%rax,2), %rdi
	movl	8(%rcx,%rdi,4), %ebx
	movq	(%rcx,%rdi,4), %r15
	movq	%r15, -12(%rdx)
	movl	%ebx, -4(%rdx)
	movl	8(%rdx), %ebx
	movl	%ebx, 8(%rcx,%rdi,4)
	movq	%r11, (%rcx,%rdi,4)
	sbbq	$-1, %rax
	movq	12(%rdx), %r11
	cmpq	%r11, %r8
	leaq	(%rax,%rax,2), %rdi
	movl	8(%rcx,%rdi,4), %ebx
	movq	(%rcx,%rdi,4), %r15
	movq	%r15, (%rdx)
	movl	%ebx, 8(%rdx)
	movl	20(%rdx), %ebx
	movl	%ebx, 8(%rcx,%rdi,4)
	movq	%r11, (%rcx,%rdi,4)
	sbbq	$-1, %rax
	addq	$24, %rdx
	cmpq	%r10, %rdx
	jb	.LBB9_61
	leaq	-12(%rdx), %r10
	jmp	.LBB9_55
.LBB9_53:
	movq	%rcx, %r10
	xorl	%eax, %eax
.LBB9_55:
	leaq	(%r12,%r9,4), %r9
	.p2align	4
.LBB9_56:
	cmpq	%r9, %rdx
	movq	%rdx, %r11
	cmoveq	%r14, %r11
	cmpq	(%r11), %r8
	leaq	(%rax,%rax,2), %rdi
	sbbq	$-1, %rax
	movq	(%rcx,%rdi,4), %rbx
	movl	8(%rcx,%rdi,4), %r15d
	movl	%r15d, 8(%r10)
	movq	%rbx, (%r10)
	movl	8(%r11), %r10d
	movl	%r10d, 8(%rcx,%rdi,4)
	movq	(%r11), %r10
	movq	%r10, (%rcx,%rdi,4)
	cmpq	%r9, %rdx
	movq	%rdx, %r10
	leaq	12(%rdx), %rdx
	jne	.LBB9_56
	cmpq	%r13, %rax
	jb	.LBB9_58
.LBB9_33:
	ud2
.LBB9_63:
	movq	%r12, %rcx
	movq	%r13, %rdx
	.seh_startepilogue
	addq	$648, %rsp
	popq	%rbx
	popq	%rdi
	popq	%rsi
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.seh_endepilogue
	jmp	_RINvNtNtNtNtCs998Ihx2sztz_4core5slice4sort8unstable8heapsort8heapsortNtNtCs5Av9rWzHob7_3lib14identity_index5EntryNCINvMB8_SB15_20sort_unstable_by_keyyNCINvMs0_B17_NtB17_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs1_0E0EB19_
.LBB9_7:
	cmpq	$7, %r13
	jbe	.LBB9_8
	movq	12(%r12), %rax
	movq	36(%r12), %rcx
	xorl	%r9d, %r9d
	xorl	%edx, %edx
	cmpq	(%r12), %rax
	setae	%r9b
	setb	%dl
	leaq	36(%r12), %r8
	leaq	24(%r12), %r10
	cmpq	24(%r12), %rcx
	leaq	(%rdx,%rdx,2), %r11
	leaq	(%r12,%r11,4), %rdx
	leaq	(%r9,%r9,2), %r9
	movq	%r10, %rcx
	cmovbq	%r8, %rcx
	leaq	(%r12,%r9,4), %rax
	cmovbq	%r10, %r8
	movq	(%rcx), %r10
	movq	(%r8), %rbx
	movq	(%r12,%r9,4), %r9
	cmpq	%r9, %rbx
	movq	%rax, %r14
	cmovbq	%rcx, %r14
	cmpq	(%r12,%r11,4), %r10
	cmovbq	%rdx, %r14
	cmovbq	%rcx, %rdx
	cmovbq	%rax, %rcx
	cmpq	%r9, %rbx
	cmovaeq	%r8, %rax
	cmovbq	%r8, %rcx
	movq	(%rcx), %r8
	cmpq	(%r14), %r8
	movq	%r14, %r8
	cmovbq	%rcx, %r8
	cmovbq	%r14, %rcx
	movl	8(%rdx), %r9d
	movl	%r9d, -80(%rbp)
	movq	(%rdx), %rdx
	movq	%rdx, -88(%rbp)
	movl	8(%r8), %edx
	movl	%edx, -68(%rbp)
	movq	(%r8), %rdx
	movq	%rdx, -76(%rbp)
	movl	8(%rcx), %edx
	movl	%edx, -56(%rbp)
	movq	(%rcx), %rcx
	movq	%rcx, -64(%rbp)
	leaq	(,%rsi,4), %rcx
	leaq	(%rcx,%rcx,2), %rcx
	leaq	(%r12,%rcx), %r10
	movq	12(%r12,%rcx), %rdx
	movq	36(%r12,%rcx), %r8
	xorl	%r11d, %r11d
	xorl	%ebx, %ebx
	cmpq	(%r12,%rcx), %rdx
	setae	%r11b
	setb	%bl
	leaq	(%r12,%rcx), %r9
	addq	$36, %r9
	leaq	(%r12,%rcx), %r14
	addq	$24, %r14
	cmpq	24(%r12,%rcx), %r8
	leaq	(%rbx,%rbx,2), %rbx
	leaq	(%r11,%r11,2), %r11
	leaq	(%r10,%r11,4), %rdx
	movq	%r14, %r8
	cmovbq	%r9, %r8
	cmovbq	%r14, %r9
	movq	(%r9), %r14
	movq	(%r10,%r11,4), %r11
	cmpq	%r11, %r14
	movq	%rdx, %r15
	cmovbq	%r8, %r15
	movq	%r12, %rdi
	movq	(%r8), %r12
	cmpq	(%r10,%rbx,4), %r12
	movq	%rdi, %r12
	leaq	(%r13,%r13,2), %rdi
	leaq	(%r10,%rbx,4), %r10
	cmovbq	%r10, %r15
	cmovbq	%r8, %r10
	movl	8(%rax), %ebx
	cmovbq	%rdx, %r8
	cmpq	%r11, %r14
	cmovaeq	%r9, %rdx
	cmovbq	%r9, %r8
	movl	%ebx, -44(%rbp)
	movq	(%r8), %r9
	cmpq	(%r15), %r9
	movq	(%rax), %rax
	movq	%r15, %r9
	cmovbq	%r8, %r9
	movq	%rax, -52(%rbp)
	cmovbq	%r15, %r8
	movl	8(%r10), %eax
	movl	%eax, -80(%rbp,%rcx)
	movq	(%r10), %rax
	movq	%rax, -88(%rbp,%rcx)
	movq	(%r9), %rax
	movq	%rax, -76(%rbp,%rcx)
	movl	8(%r9), %eax
	movl	%eax, -68(%rbp,%rcx)
	movq	(%r8), %rax
	movq	%rax, -64(%rbp,%rcx)
	movl	8(%r8), %eax
	movl	%eax, -56(%rbp,%rcx)
	movq	(%rdx), %rax
	movq	%rax, -52(%rbp,%rcx)
	movl	8(%rdx), %eax
	movl	%eax, -44(%rbp,%rcx)
	movl	$4, %ecx
	movq	%r13, %rdx
	subq	%rsi, %rdx
	cmpq	%rsi, %rcx
	jb	.LBB9_11
	jmp	.LBB9_16
.LBB9_8:
	movl	8(%r12), %eax
	movl	%eax, -80(%rbp)
	movq	(%r12), %rax
	movq	%rax, -88(%rbp)
	leaq	(,%rsi,4), %rax
	leaq	(%rax,%rax,2), %rax
	movl	8(%r12,%rax), %ecx
	movl	%ecx, -80(%rbp,%rax)
	movq	(%r12,%rax), %rcx
	movq	%rcx, -88(%rbp,%rax)
	movl	$1, %ecx
	movq	%r13, %rdx
	subq	%rsi, %rdx
	cmpq	%rsi, %rcx
	jae	.LBB9_16
.LBB9_11:
	leal	(,%rcx,4), %eax
	leaq	(%rax,%rax,2), %rax
	leaq	-88(%rbp), %r8
	movq	%rcx, %r9
	jmp	.LBB9_12
	.p2align	4
.LBB9_15:
	movq	%r8, %rbx
.LBB9_37:
	movq	%r10, (%rbx)
	movl	%r11d, 8(%rbx)
.LBB9_38:
	incq	%r9
	addq	$12, %rax
	cmpq	%rsi, %r9
	je	.LBB9_16
.LBB9_12:
	leaq	(,%r9,4), %r10
	leaq	(%r10,%r10,2), %r11
	movl	8(%r12,%r11), %r10d
	movl	%r10d, -80(%rbp,%r11)
	movq	(%r12,%r11), %r10
	movq	%r10, -88(%rbp,%r11)
	cmpq	-100(%rbp,%r11), %r10
	jae	.LBB9_38
	addq	%rbp, %r11
	addq	$-88, %r11
	movl	8(%r11), %r11d
	movq	%rax, %rbx
	.p2align	4
.LBB9_14:
	movl	-92(%rbp,%rbx), %r14d
	movl	%r14d, -80(%rbp,%rbx)
	movq	-100(%rbp,%rbx), %r14
	movq	%r14, -88(%rbp,%rbx)
	cmpq	$12, %rbx
	je	.LBB9_15
	leaq	-12(%rbx), %r14
	cmpq	-112(%rbp,%rbx), %r10
	movq	%r14, %rbx
	jb	.LBB9_14
	leaq	(%r14,%rbp), %rbx
	addq	$-88, %rbx
	jmp	.LBB9_37
.LBB9_16:
	leaq	(,%rsi,4), %rax
	leaq	(%rax,%rax,2), %r8
	leaq	(%r8,%rbp), %rax
	addq	$-88, %rax
	cmpq	%rdx, %rcx
	jae	.LBB9_26
	addq	%r12, %r8
	leal	(,%rcx,4), %r9d
	leaq	(%r9,%r9,2), %r9
	jmp	.LBB9_18
	.p2align	4
.LBB9_21:
	movq	%rax, %r14
.LBB9_24:
	movq	%r10, (%r14)
	movl	%r11d, 8(%r14)
.LBB9_25:
	incq	%rcx
	addq	$12, %r9
	cmpq	%rdx, %rcx
	je	.LBB9_26
.LBB9_18:
	leaq	(,%rcx,4), %r10
	leaq	(%r10,%r10,2), %r11
	movl	8(%r8,%r11), %r10d
	movl	%r10d, 8(%rax,%r11)
	movq	(%r8,%r11), %r10
	movq	%r10, (%rax,%r11)
	cmpq	-12(%rax,%r11), %r10
	jae	.LBB9_25
	addq	%rax, %r11
	movl	8(%r11), %r11d
	movq	%r9, %rbx
	.p2align	4
.LBB9_20:
	movl	-4(%rax,%rbx), %r14d
	movl	%r14d, 8(%rax,%rbx)
	movq	-12(%rax,%rbx), %r14
	movq	%r14, (%rax,%rbx)
	cmpq	$12, %rbx
	je	.LBB9_21
	leaq	-12(%rbx), %r14
	cmpq	-24(%rax,%rbx), %r10
	movq	%r14, %rbx
	jb	.LBB9_20
	addq	%rax, %r14
	jmp	.LBB9_24
.LBB9_26:
	leaq	(%r12,%rdi,4), %r10
	addq	$-12, %r10
	leaq	-100(,%rdi,4), %rdx
	addq	%rbp, %rdx
	leaq	-12(%rax), %rcx
	leaq	-88(%rbp), %r8
	movq	%r12, %r9
	.p2align	4
.LBB9_27:
	movq	%rax, %r11
	movq	%r8, %rdi
	movq	(%rax), %r8
	addq	$12, %rax
	cmpq	(%rdi), %r8
	leaq	12(%rdi), %r8
	cmovbq	%rdi, %r8
	cmovbq	%r11, %rdi
	movl	8(%rdi), %ebx
	movl	%ebx, 8(%r9)
	cmovaeq	%r11, %rax
	movq	(%rdx), %r11
	movq	(%rcx), %rbx
	cmpq	%rbx, %r11
	movl	$0, %r14d
	adcq	$-1, %r14
	cmpq	%rbx, %r11
	movq	%rdx, %r11
	cmovbq	%rcx, %r11
	movq	(%rdi), %rdi
	movl	$0, %ebx
	sbbq	%rbx, %rbx
	movq	%rdi, (%r9)
	addq	$12, %r9
	movl	8(%r11), %edi
	movl	%edi, 8(%r10)
	movq	(%r11), %r11
	movq	%r11, (%r10)
	leaq	(%r14,%r14,2), %r11
	leaq	(%rdx,%r11,4), %rdx
	leaq	(%rbx,%rbx,2), %r11
	leaq	(%rcx,%r11,4), %rcx
	addq	$-12, %r10
	decq	%rsi
	jne	.LBB9_27
	addq	$12, %rcx
	addq	$12, %rdx
	testb	$1, %r13b
	je	.LBB9_30
	leaq	12(%r8), %r10
	leaq	12(%rax), %r11
	cmpq	%rcx, %r8
	movq	%rax, %rsi
	cmovbq	%r8, %rsi
	movl	8(%rsi), %edi
	movl	%edi, 8(%r9)
	movq	(%rsi), %rsi
	movq	%rsi, (%r9)
	cmovbq	%r10, %r8
	cmovaeq	%r11, %rax
.LBB9_30:
	cmpq	%rdx, %rax
	jne	.LBB9_32
	cmpq	%rcx, %r8
	jne	.LBB9_32
.LBB9_39:
	.seh_startepilogue
	addq	$648, %rsp
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
.LBB9_32:
.Ltmp2:
	movq	%r12, 504(%rbp)
	movq	%r13, 496(%rbp)
	callq	_RNvNtNtNtNtCs998Ihx2sztz_4core5slice4sort6shared9smallsort22panic_on_ord_violation
	nop
.Ltmp3:
	jmp	.LBB9_33
	.seh_handlerdata
	.long	$cppxdata$_RINvNtNtNtNtCs998Ihx2sztz_4core5slice4sort8unstable9quicksort9quicksortNtNtCs5Av9rWzHob7_3lib14identity_index5EntryNCINvMB8_SB17_20sort_unstable_by_keyyNCINvMs0_B19_NtB19_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs1_0E0EB1b_@IMGREL
	.section	.text,"xr",one_only,_RINvNtNtNtNtCs998Ihx2sztz_4core5slice4sort8unstable9quicksort9quicksortNtNtCs5Av9rWzHob7_3lib14identity_index5EntryNCINvMB8_SB17_20sort_unstable_by_keyyNCINvMs0_B19_NtB19_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs1_0E0EB1b_,unique,9
	.seh_endproc
	.def	"?dtor$34@?0?_RINvNtNtNtNtCs998Ihx2sztz_4core5slice4sort8unstable9quicksort9quicksortNtNtCs5Av9rWzHob7_3lib14identity_index5EntryNCINvMB8_SB17_20sort_unstable_by_keyyNCINvMs0_B19_NtB19_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs1_0E0EB1b_@4HA";
	.scl	3;
	.type	32;
	.endef
	.p2align	4
"?dtor$34@?0?_RINvNtNtNtNtCs998Ihx2sztz_4core5slice4sort8unstable9quicksort9quicksortNtNtCs5Av9rWzHob7_3lib14identity_index5EntryNCINvMB8_SB17_20sort_unstable_by_keyyNCINvMs0_B19_NtB19_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs1_0E0EB1b_@4HA":
.seh_proc "?dtor$34@?0?_RINvNtNtNtNtCs998Ihx2sztz_4core5slice4sort8unstable9quicksort9quicksortNtNtCs5Av9rWzHob7_3lib14identity_index5EntryNCINvMB8_SB17_20sort_unstable_by_keyyNCINvMs0_B19_NtB19_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs1_0E0EB1b_@4HA"
.LBB9_34:
	movq	%rdx, 16(%rsp)
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
	subq	$40, %rsp
	.seh_stackalloc 40
	leaq	128(%rdx), %rbp
	.seh_endprologue
	movq	496(%rbp), %rax
	shlq	$2, %rax
	leaq	(%rax,%rax,2), %r8
	leaq	-88(%rbp), %rdx
	movq	504(%rbp), %rcx
	callq	memcpy
	nop
	.seh_startepilogue
	addq	$40, %rsp
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
.Lfunc_end1:
	.seh_handlerdata
	.section	.text,"xr",one_only,_RINvNtNtNtNtCs998Ihx2sztz_4core5slice4sort8unstable9quicksort9quicksortNtNtCs5Av9rWzHob7_3lib14identity_index5EntryNCINvMB8_SB17_20sort_unstable_by_keyyNCINvMs0_B19_NtB19_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs1_0E0EB1b_,unique,9
	.seh_endproc
	.section	.xdata,"dr",associative,_RINvNtNtNtNtCs998Ihx2sztz_4core5slice4sort8unstable9quicksort9quicksortNtNtCs5Av9rWzHob7_3lib14identity_index5EntryNCINvMB8_SB17_20sort_unstable_by_keyyNCINvMs0_B19_NtB19_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs1_0E0EB1b_,unique,1
	.p2align	2, 0x0
$cppxdata$_RINvNtNtNtNtCs998Ihx2sztz_4core5slice4sort8unstable9quicksort9quicksortNtNtCs5Av9rWzHob7_3lib14identity_index5EntryNCINvMB8_SB17_20sort_unstable_by_keyyNCINvMs0_B19_NtB19_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs1_0E0EB1b_:
	.long	429065506
	.long	1
	.long	$stateUnwindMap$_RINvNtNtNtNtCs998Ihx2sztz_4core5slice4sort8unstable9quicksort9quicksortNtNtCs5Av9rWzHob7_3lib14identity_index5EntryNCINvMB8_SB17_20sort_unstable_by_keyyNCINvMs0_B19_NtB19_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs1_0E0EB1b_@IMGREL
	.long	0
	.long	0
	.long	3
	.long	$ip2state$_RINvNtNtNtNtCs998Ihx2sztz_4core5slice4sort8unstable9quicksort9quicksortNtNtCs5Av9rWzHob7_3lib14identity_index5EntryNCINvMB8_SB17_20sort_unstable_by_keyyNCINvMs0_B19_NtB19_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs1_0E0EB1b_@IMGREL
	.long	640
	.long	0
	.long	1
$stateUnwindMap$_RINvNtNtNtNtCs998Ihx2sztz_4core5slice4sort8unstable9quicksort9quicksortNtNtCs5Av9rWzHob7_3lib14identity_index5EntryNCINvMB8_SB17_20sort_unstable_by_keyyNCINvMs0_B19_NtB19_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs1_0E0EB1b_:
	.long	-1
	.long	"?dtor$34@?0?_RINvNtNtNtNtCs998Ihx2sztz_4core5slice4sort8unstable9quicksort9quicksortNtNtCs5Av9rWzHob7_3lib14identity_index5EntryNCINvMB8_SB17_20sort_unstable_by_keyyNCINvMs0_B19_NtB19_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs1_0E0EB1b_@4HA"@IMGREL
$ip2state$_RINvNtNtNtNtCs998Ihx2sztz_4core5slice4sort8unstable9quicksort9quicksortNtNtCs5Av9rWzHob7_3lib14identity_index5EntryNCINvMB8_SB17_20sort_unstable_by_keyyNCINvMs0_B19_NtB19_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs1_0E0EB1b_:
	.long	.Lfunc_begin1@IMGREL
	.long	-1
	.long	.Ltmp2@IMGREL
	.long	0
	.long	.Ltmp3@IMGREL
	.long	-1
	.section	.text,"xr",one_only,_RINvNtNtNtNtCs998Ihx2sztz_4core5slice4sort8unstable9quicksort9quicksortNtNtCs5Av9rWzHob7_3lib14identity_index5EntryNCINvMB8_SB17_20sort_unstable_by_keyyNCINvMs0_B19_NtB19_13IdentityIndex8from_idsINtNtNtNtBa_4iter8adapters6copied6CopiedINtNtB8_4iter4IteryEEEs1_0E0EB1b_,unique,9

	.def	_RNvCs5Av9rWzHob7_3lib11hole_lookup;
	.scl	2;
	.type	32;
	.endef
	.section	.text,"xr",one_only,_RNvCs5Av9rWzHob7_3lib11hole_lookup,unique,10
	.globl	_RNvCs5Av9rWzHob7_3lib11hole_lookup
	.p2align	4
_RNvCs5Av9rWzHob7_3lib11hole_lookup:
.Lfunc_begin2:
.seh_proc _RNvCs5Av9rWzHob7_3lib11hole_lookup
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
	jae	.LBB10_177
	movq	%r9, %rsi
	movq	%r8, %rdi
	movq	%rdx, %r13
	testq	%rdx, %rdx
	je	.LBB10_2
	movq	(%rcx), %r12
	cmpq	$1, %r13
	jne	.LBB10_5
	movl	$1, %r13d
	xorl	%ecx, %ecx
	testq	%rsi, %rsi
	jne	.LBB10_118
	jmp	.LBB10_117
.LBB10_2:
	xorl	%ecx, %ecx
	xorl	%r12d, %r12d
	xorl	%r13d, %r13d
	testq	%rsi, %rsi
	jne	.LBB10_118
	jmp	.LBB10_117
.LBB10_5:
	movq	8(%rcx), %r8
	movq	%r12, -16(%rbp)
	incq	%r12
	sete	%dl
	cmpq	%r8, %r12
	setne	%al
	orb	%dl, %al
	movzbl	%al, %edx
	leaq	1(%rdx), %r12
	xorl	%eax, %eax
	testb	%dl, %dl
	cmovneq	%r8, %rax
	cmpq	$2, %r13
	je	.LBB10_14
	leaq	(,%r13,8), %r11
	leaq	16(%rcx), %r9
	addq	$-24, %r11
	je	.LBB10_7
	movq	%r13, -24(%rbp)
	shrq	$3, %r11
	incq	%r11
	movq	%r11, -32(%rbp)
	andq	$-2, %r11
	movl	$2, %ebx
	.p2align	4
.LBB10_9:
	movq	(%r9), %r15
	movq	8(%r9), %r14
	incq	%r8
	sete	%r13b
	cmpq	%r15, %r8
	setne	%r8b
	orb	%r13b, %r8b
	cmpq	$1, %r12
	sete	%r13b
	movzbl	%r8b, %r8d
	testb	%r13b, %r8b
	movq	%rdx, %r13
	cmovneq	%rbx, %r13
	cmovneq	%r15, %rax
	leaq	(%r8,%r12), %rdx
	addq	$16, %r9
	movq	%r14, %r8
	incq	%r15
	sete	%r12b
	cmpq	%r14, %r15
	setne	%r15b
	orb	%r12b, %r15b
	cmpq	$1, %rdx
	sete	%r10b
	movzbl	%r15b, %r15d
	leaq	(%r15,%rdx), %r12
	leaq	1(%rbx), %rdx
	testb	%r10b, %r15b
	cmoveq	%r13, %rdx
	cmovneq	%r14, %rax
	cmpq	%r11, %rbx
	leaq	2(%rbx), %rbx
	jne	.LBB10_9
	testb	$1, -32(%rbp)
	jne	.LBB10_12
	movq	-24(%rbp), %r13
	jmp	.LBB10_14
.LBB10_7:
	movl	$2, %ebx
	jmp	.LBB10_13
.LBB10_12:
	movq	-24(%rbp), %r13
.LBB10_13:
	movq	(%r9), %r9
	incq	%r8
	sete	%r10b
	cmpq	%r9, %r8
	setne	%r8b
	orb	%r10b, %r8b
	cmpq	$1, %r12
	sete	%r10b
	movzbl	%r8b, %r8d
	addq	%r8, %r12
	testb	%r10b, %r8b
	cmovneq	%rbx, %rdx
	cmovneq	%r9, %rax
.LBB10_14:
	cmpq	$2, %r12
	je	.LBB10_17
	cmpq	$1, %r12
	jne	.LBB10_21
	xorl	%ecx, %ecx
	movq	-16(%rbp), %r12
	testq	%rsi, %rsi
	jne	.LBB10_118
	jmp	.LBB10_117
.LBB10_17:
	subq	-16(%rbp), %rax
	jb	.LBB10_21
	subq	%rdx, %rax
	jb	.LBB10_21
	leaq	-1(%rax), %r8
	cmpq	$1073741822, %r8
	ja	.LBB10_21
	shlq	$34, %rax
	shlq	$17, %rdx
	orq	%r13, %rdx
	orq	%rax, %rdx
	movl	$1, %ecx
	movq	%rdx, %r13
	movq	-16(%rbp), %r12
	testq	%rsi, %rsi
	jne	.LBB10_118
	jmp	.LBB10_117
.LBB10_21:
	movq	%r12, %r14
	shlq	$4, %r14
	leaq	(,%r13,4), %rax
	leaq	(%rax,%rax,2), %r15
	cmpq	%r15, %r14
	jae	.LBB10_22
	movq	%r12, %rax
	shrq	$60, %rax
	jne	.LBB10_50
	movq	%r13, %rbx
	movq	%rcx, %r13
	movl	$8, %edx
	movq	%r14, %rcx
	callq	_RNvMNtNtCs998Ihx2sztz_4core5alloc6layoutNtB2_6Layout23is_size_alignment_valid
	testb	%al, %al
	je	.LBB10_52
	testq	%r12, %r12
	movl	$8, %eax
	je	.LBB10_57
	callq	_RNvCs9wFQrvczXsK_7___rustc35___rust_no_alloc_shim_is_unstable_v2
	movl	$8, %r15d
	movl	$8, %edx
	movq	%r14, %rcx
	callq	_RNvCs9wFQrvczXsK_7___rustc12___rust_alloc
	testq	%rax, %rax
	je	.LBB10_55
.LBB10_57:
	movq	%r13, %r10
	leaq	(%r13,%rbx,8), %r13
	movq	%r12, -56(%rbp)
	movq	%rax, -48(%rbp)
	xorl	%r8d, %r8d
	movl	$1, %ecx
	xorl	%edx, %edx
	xorl	%r11d, %r11d
	movq	-16(%rbp), %r9
	jmp	.LBB10_58
	.p2align	4
.LBB10_77:
	movq	-24(%rbp), %r8
	movq	%r8, %rcx
	shlq	$4, %rcx
	movq	%r15, (%rax,%rcx)
	movl	%r11d, 8(%rax,%rcx)
	movl	%r12d, 12(%rax,%rcx)
	incq	%r8
	movb	$1, %dl
	xorl	%ecx, %ecx
	movl	%r9d, %r11d
	movq	%r14, %r9
.LBB10_58:
	movq	%r8, -24(%rbp)
	movq	%r8, -40(%rbp)
	testb	$1, %dl
	movq	%r9, %r15
	je	.LBB10_59
	cmpq	%r13, %r10
	jne	.LBB10_61
	jmp	.LBB10_64
.LBB10_59:
	movq	%r13, %rdx
	subq	%r10, %rdx
	shrq	$3, %rdx
	cmpq	%rdx, %rcx
	jae	.LBB10_64
	leaq	(%r10,%rcx,8), %r10
.LBB10_61:
	movq	(%r10), %r14
	addq	$8, %r10
	movq	%r9, %rcx
	incq	%rcx
	sete	%dl
	cmpq	%r14, %rcx
	setne	%cl
	orb	%dl, %cl
	jne	.LBB10_62
	movl	$2, %r12d
	cmpq	%r13, %r10
	je	.LBB10_65
	.p2align	4
.LBB10_71:
	movq	(%r10), %r14
	movl	%r12d, %ecx
	addq	%r15, %rcx
	cmpq	%r15, %rcx
	jb	.LBB10_73
	cmpq	%r14, %rcx
	jne	.LBB10_73
	addq	$8, %r10
	incl	%r12d
	cmpq	%r13, %r10
	jne	.LBB10_71
	jmp	.LBB10_65
.LBB10_62:
	leal	1(%r11), %r9d
	movl	$1, %r12d
	movq	-24(%rbp), %rcx
	cmpq	-56(%rbp), %rcx
	jne	.LBB10_77
	jmp	.LBB10_75
.LBB10_73:
	addq	$8, %r10
	leal	(%r11,%r12), %r9d
	movq	-24(%rbp), %rcx
	cmpq	-56(%rbp), %rcx
	jne	.LBB10_77
.LBB10_75:
	movl	%r9d, -32(%rbp)
	movq	%r10, %rbx
	movb	$1, -1(%rbp)
.Ltmp8:
	leaq	-56(%rbp), %rcx
	movq	%r11, -16(%rbp)
	callq	_RNvMs3_NtCsk3xoiB9w6DV_5alloc7raw_vecINtB5_6RawVecNtNtCs5Av9rWzHob7_3lib14identity_index3RunE8grow_oneBQ_
	movq	-16(%rbp), %r11
.Ltmp9:
	movq	-48(%rbp), %rax
	movq	%rbx, %r10
	movl	-32(%rbp), %r9d
	jmp	.LBB10_77
.LBB10_22:
	movq	%rcx, %r14
	movl	$4, %ebx
	movl	$4, %edx
	movq	%r15, %rcx
	callq	_RNvMNtNtCs998Ihx2sztz_4core5alloc6layoutNtB2_6Layout23is_size_alignment_valid
	testb	%al, %al
	je	.LBB10_23
	callq	_RNvCs9wFQrvczXsK_7___rustc35___rust_no_alloc_shim_is_unstable_v2
	movl	$4, %edx
	movq	%r15, %rcx
	callq	_RNvCs9wFQrvczXsK_7___rustc12___rust_alloc
	testq	%rax, %rax
	je	.LBB10_24
	movl	%r13d, %edx
	andl	$3, %edx
	cmpq	$4, %r13
	jae	.LBB10_28
	xorl	%ecx, %ecx
	jmp	.LBB10_31
.LBB10_28:
	movl	%r13d, %r8d
	andl	$131068, %r8d
	leaq	44(%rax), %r9
	xorl	%ecx, %ecx
	.p2align	4
.LBB10_29:
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
	jne	.LBB10_29
	testq	%rdx, %rdx
	je	.LBB10_33
.LBB10_31:
	leaq	(%rcx,%rcx,2), %r8
	leaq	(%rax,%r8,4), %r8
	addq	$8, %r8
	shll	$2, %edx
	leaq	(%rdx,%rdx,2), %rdx
	xorl	%r9d, %r9d
	.p2align	4
.LBB10_32:
	movq	(%r14,%rcx,8), %r10
	movq	%r10, -8(%r8,%r9)
	movl	%ecx, (%r8,%r9)
	incq	%rcx
	addq	$12, %r9
	cmpq	%r9, %rdx
	jne	.LBB10_32
.LBB10_33:
	cmpq	$21, %r13
	movq	%rax, -16(%rbp)
	movq	%r15, -24(%rbp)
	jae	.LBB10_34
	movq	%r13, %rbx
	leaq	(%rax,%r15), %r14
	leaq	12(%rax), %r8
	movl	$12, %ecx
	movq	%rax, %r9
	movq	-16(%rbp), %rax
	jmp	.LBB10_41
	.p2align	4
.LBB10_44:
	movq	%rax, %r11
.LBB10_47:
	movq	%r8, (%r11)
	movl	%r9d, 8(%r11)
.LBB10_48:
	leaq	12(%rdx), %r8
	addq	$12, %rcx
	movq	%rdx, %r9
	cmpq	%r14, %r8
	je	.LBB10_35
.LBB10_41:
	movq	%r8, %rdx
	movq	12(%r9), %r8
	cmpq	(%r9), %r8
	jae	.LBB10_48
	movl	20(%r9), %r9d
	movq	%rcx, %r10
	.p2align	4
.LBB10_43:
	movl	-4(%rax,%r10), %r11d
	movl	%r11d, 8(%rax,%r10)
	movq	-12(%rax,%r10), %r11
	movq	%r11, (%rax,%r10)
	cmpq	$12, %r10
	je	.LBB10_44
	leaq	-12(%r10), %r11
	cmpq	-24(%rax,%r10), %r8
	movq	%r11, %r10
	jb	.LBB10_43
	addq	%rax, %r11
	jmp	.LBB10_47
.LBB10_34:
.Ltmp4:
	leaq	-56(%rbp), %r8
	movq	%rax, %rcx
	movq	%r13, %rbx
	movq	%r13, %rdx
	callq	_RINvNtNtNtCs998Ihx2sztz_4core5slice4sort8unstable7ipnsortNtNtCs5Av9rWzHob7_3lib14identity_index5EntryNCINvMB6_SBT_20sort_unstable_by_keyyNCINvMs0_BV_NtBV_13IdentityIndex8from_idsINtNtNtNtB8_4iter8adapters6copied6CopiedINtNtB6_4iter4IteryEEEs1_0E0EBX_
	nop
.Ltmp5:
.LBB10_35:
	movq	%rbx, %r13
	leaq	1(%rbx), %rax
	movq	-16(%rbp), %r12
	movq	%r12, %rcx
	.p2align	4
.LBB10_36:
	decq	%rax
	cmpq	$2, %rax
	jb	.LBB10_115
	movq	(%rcx), %rdx
	cmpq	12(%rcx), %rdx
	leaq	12(%rcx), %rcx
	jne	.LBB10_36
.Ltmp6:
	leaq	anon.a6f1c2709b41de3543ec316f8732e788.3(%rip), %rcx
	leaq	anon.a6f1c2709b41de3543ec316f8732e788.4(%rip), %r8
	movl	$73, %edx
	callq	_RNvNtCs998Ihx2sztz_4core9panicking9panic_fmt
	nop
.Ltmp7:
	jmp	.LBB10_39
.LBB10_115:
	movl	$3, %ecx
	testq	%rsi, %rsi
	jne	.LBB10_118
	jmp	.LBB10_117
.LBB10_64:
	movl	$1, %r12d
.LBB10_65:
	movq	-24(%rbp), %rax
	cmpq	-56(%rbp), %rax
	jne	.LBB10_67
	movb	$1, -1(%rbp)
.Ltmp10:
	leaq	-56(%rbp), %rcx
	movq	%r11, %rbx
	callq	_RNvMs3_NtCsk3xoiB9w6DV_5alloc7raw_vecINtB5_6RawVecNtNtCs5Av9rWzHob7_3lib14identity_index3RunE8grow_oneBQ_
	movq	%rbx, %r11
.Ltmp11:
.LBB10_67:
	movq	-48(%rbp), %r14
	movq	-24(%rbp), %rdx
	movq	%rdx, %rax
	shlq	$4, %rax
	movq	%r15, (%r14,%rax)
	movl	%r11d, 8(%r14,%rax)
	movl	%r12d, 12(%r14,%rax)
	incq	%rdx
	movq	%rdx, -40(%rbp)
	cmpq	$2, %rdx
	jae	.LBB10_78
	movq	%rdx, -24(%rbp)
	jmp	.LBB10_90
.LBB10_78:
	cmpq	$21, %rdx
	jae	.LBB10_79
	shlq	$4, %rdx
	addq	%r14, %rdx
	leaq	16(%r14), %r9
	movl	$16, %eax
	movq	%r14, %r8
	jmp	.LBB10_81
.LBB10_84:
	movq	%r14, %r9
.LBB10_87:
	movq	%r11, (%r9)
	movq	%r8, 8(%r9)
.LBB10_88:
	leaq	16(%rcx), %r9
	addq	$16, %rax
	movq	%rcx, %r8
	cmpq	%rdx, %r9
	je	.LBB10_89
.LBB10_81:
	movq	%r9, %rcx
	movq	16(%r8), %r11
	cmpq	(%r8), %r11
	jae	.LBB10_88
	movq	24(%r8), %r8
	movq	%rax, %r10
	.p2align	4
.LBB10_83:
	movdqu	-16(%r14,%r10), %xmm0
	movdqu	%xmm0, (%r14,%r10)
	cmpq	$16, %r10
	je	.LBB10_84
	leaq	-16(%r10), %r9
	cmpq	-32(%r14,%r10), %r11
	movq	%r9, %r10
	jb	.LBB10_83
	addq	%r14, %r9
	jmp	.LBB10_87
.LBB10_79:
	movb	$1, -1(%rbp)
.Ltmp12:
	leaq	-64(%rbp), %r8
	movq	%r14, %rcx
	movq	%rdx, -24(%rbp)
	callq	_RINvNtNtNtCs998Ihx2sztz_4core5slice4sort8unstable7ipnsortNtNtCs5Av9rWzHob7_3lib14identity_index3RunNCINvMB6_SBT_20sort_unstable_by_keyyNCINvMs0_BV_NtBV_13IdentityIndex8from_idsINtNtNtNtB8_4iter8adapters6copied6CopiedINtNtB6_4iter4IteryEEEs_0E0EBX_
	nop
.Ltmp13:
	jmp	.LBB10_90
.LBB10_89:
	movq	-48(%rbp), %r14
	movq	-40(%rbp), %rax
	movq	%rax, -24(%rbp)
.LBB10_90:
	leaq	16(%r14), %rax
	movq	-24(%rbp), %r13
	leaq	1(%r13), %rcx
	.p2align	4
.LBB10_91:
	decq	%rcx
	cmpq	$2, %rcx
	jb	.LBB10_95
	movq	(%rax), %rdx
	subq	-16(%rax), %rdx
	jb	.LBB10_94
	movl	-4(%rax), %r8d
	addq	$16, %rax
	cmpq	%r8, %rdx
	jae	.LBB10_91
.LBB10_94:
	movb	$1, -1(%rbp)
.Ltmp14:
	leaq	anon.a6f1c2709b41de3543ec316f8732e788.3(%rip), %rcx
	leaq	anon.a6f1c2709b41de3543ec316f8732e788.5(%rip), %r8
	movl	$73, %edx
	callq	_RNvNtCs998Ihx2sztz_4core9panicking9panic_fmt
	nop
.Ltmp15:
	jmp	.LBB10_39
.LBB10_95:
	movq	-56(%rbp), %r15
	cmpq	%r13, %r15
	jbe	.LBB10_99
	movq	%r15, %rdx
	shlq	$4, %rdx
	testq	%r13, %r13
	je	.LBB10_108
	movq	%r13, %rbx
	shlq	$4, %rbx
	movl	$8, %r8d
	movq	%r14, %rcx
	movq	%rbx, %r9
	callq	_RNvCs9wFQrvczXsK_7___rustc14___rust_realloc
	movq	%rax, %r12
	testq	%rax, %rax
	jne	.LBB10_109
.Ltmp18:
	movq	%r15, -16(%rbp)
	movq	%r14, -32(%rbp)
	movl	$8, %ecx
	movq	%rbx, %rdx
	callq	_RNvNtCsk3xoiB9w6DV_5alloc7raw_vec12handle_error
	nop
.Ltmp19:
	jmp	.LBB10_39
.LBB10_99:
	jb	.LBB10_101
	movq	%r14, %r12
	movl	$2, %ecx
	testq	%rsi, %rsi
	jne	.LBB10_118
.LBB10_117:
	xorl	%eax, %eax
.LBB10_169:
	cmpl	$2, %ecx
	jb	.LBB10_176
	cmpl	$2, %ecx
	jne	.LBB10_171
	testq	%r13, %r13
	je	.LBB10_176
	shlq	$4, %r13
	movl	$8, %r8d
	movq	%r12, %rcx
	movq	%r13, %rdx
	jmp	.LBB10_175
.LBB10_171:
	testq	%r13, %r13
	je	.LBB10_176
	shlq	$2, %r13
	leaq	(,%r13,2), %rdx
	addq	%r13, %rdx
	movl	$4, %r8d
	movq	%r12, %rcx
.LBB10_175:
	movq	%rax, %rsi
	callq	_RNvCs9wFQrvczXsK_7___rustc14___rust_dealloc
	movq	%rsi, %rax
	jmp	.LBB10_176
.LBB10_108:
	movl	$8, %r12d
	movl	$8, %r8d
	movq	%r14, %rcx
	callq	_RNvCs9wFQrvczXsK_7___rustc14___rust_dealloc
.LBB10_109:
	movl	$2, %ecx
	testq	%rsi, %rsi
	je	.LBB10_117
.LBB10_118:
	leaq	.LJTI10_0(%rip), %rax
	movslq	(%rax,%rcx,4), %rdx
	addq	%rax, %rdx
	jmpq	*%rdx
.LBB10_119:
	movl	%esi, %eax
	subl	%ecx, %eax
	leaq	1(%rcx), %r8
	testb	$1, %al
	jne	.LBB10_121
	movq	%rcx, %rdx
	cmpq	%r8, %rsi
	jne	.LBB10_123
	jmp	.LBB10_176
.LBB10_132:
	xorl	%eax, %eax
	xorl	%edx, %edx
	jmp	.LBB10_133
	.p2align	4
.LBB10_141:
	xorq	%r8, %rax
	incq	%rdx
	cmpq	%rsi, %rdx
	je	.LBB10_169
.LBB10_133:
	movq	$-1, %r8
	testq	%r13, %r13
	je	.LBB10_141
	movq	(%rdi,%rdx,8), %r9
	cmpq	$1, %r13
	jne	.LBB10_136
	xorl	%r10d, %r10d
	jmp	.LBB10_138
	.p2align	4
.LBB10_136:
	movq	%r13, %r11
	xorl	%r10d, %r10d
	.p2align	4
.LBB10_137:
	movq	%r10, %rbx
	movq	%r11, %r14
	shrq	%r14
	addq	%r14, %r10
	movq	%r10, %r15
	shlq	$4, %r15
	cmpq	%r9, (%r12,%r15)
	cmovaq	%rbx, %r10
	subq	%r14, %r11
	cmpq	$1, %r11
	ja	.LBB10_137
.LBB10_138:
	movq	%r10, %rbx
	shlq	$4, %rbx
	xorl	%r11d, %r11d
	cmpq	%r9, (%r12,%rbx)
	setbe	%r11b
	addq	%r10, %r11
	je	.LBB10_141
	shlq	$4, %r11
	subq	-16(%r12,%r11), %r9
	movl	-4(%r12,%r11), %r10d
	cmpq	%r10, %r9
	jae	.LBB10_141
	addq	%r12, %r11
	movl	-8(%r11), %r8d
	addq	%r8, %r9
	movq	%r9, %r8
	jmp	.LBB10_141
.LBB10_142:
	testq	%r13, %r13
	je	.LBB10_150
	cmpq	$1, %r13
	jne	.LBB10_144
	movq	(%r12), %rdx
	cmpq	$1, %rsi
	jne	.LBB10_159
	xorl	%r8d, %r8d
	xorl	%eax, %eax
	jmp	.LBB10_166
.LBB10_125:
	movq	%r13, %rdx
	shrq	$17, %rdx
	andl	$131071, %edx
	movq	%r13, %r8
	shrq	$34, %r8
	movl	%r13d, %r9d
	andl	$131071, %r9d
	xorl	%eax, %eax
	xorl	%r10d, %r10d
	jmp	.LBB10_126
	.p2align	4
.LBB10_128:
	movq	%r11, %rbx
.LBB10_131:
	xorq	%rbx, %rax
	incq	%r10
	cmpq	%r10, %rsi
	je	.LBB10_169
.LBB10_126:
	movq	(%rdi,%r10,8), %r11
	movq	$-1, %rbx
	subq	%r12, %r11
	jb	.LBB10_131
	cmpq	%rdx, %r11
	jb	.LBB10_128
	subq	%r8, %r11
	jb	.LBB10_131
	cmpq	%rdx, %r11
	setae	%bl
	cmpq	%r9, %r11
	setb	%r14b
	andb	%bl, %r14b
	andb	$1, %r14b
	cmpb	$1, %r14b
	movl	$0, %ebx
	sbbq	%rbx, %rbx
	orq	%r11, %rbx
	jmp	.LBB10_131
.LBB10_121:
	movq	(%rdi,%rcx,8), %rdx
	movq	%rdx, %rax
	subq	%r12, %rax
	cmpq	%r13, %rax
	movq	$-1, %r9
	cmovaeq	%r9, %rax
	cmpq	%r12, %rdx
	cmovbq	%r9, %rax
	xorq	%rcx, %rax
	movq	%r8, %rcx
	movq	%rax, %rdx
	cmpq	%r8, %rsi
	je	.LBB10_176
.LBB10_123:
	movq	$-1, %r8
	.p2align	4
.LBB10_124:
	movq	(%rdi,%rcx,8), %r9
	movq	8(%rdi,%rcx,8), %rax
	movq	%rax, %r10
	subq	%r12, %r10
	cmpq	%r13, %r10
	cmovaeq	%r8, %r10
	cmpq	%r12, %rax
	cmovbq	%r8, %r10
	movq	%r9, %rax
	subq	%r12, %rax
	cmpq	%r13, %rax
	cmovaeq	%r8, %rax
	cmpq	%r12, %r9
	cmovbq	%r8, %rax
	xorq	%rdx, %rax
	xorq	%r10, %rax
	addq	$2, %rcx
	movq	%rax, %rdx
	cmpq	%rcx, %rsi
	jne	.LBB10_124
	jmp	.LBB10_176
.LBB10_150:
	cmpq	$4, %rsi
	jae	.LBB10_152
	xorl	%ecx, %ecx
	xorl	%eax, %eax
	jmp	.LBB10_155
.LBB10_144:
	xorl	%eax, %eax
	xorl	%edx, %edx
	jmp	.LBB10_145
	.p2align	4
.LBB10_149:
	xorq	%r9, %rax
	incq	%rdx
	cmpq	%rsi, %rdx
	je	.LBB10_169
.LBB10_145:
	movq	(%rdi,%rdx,8), %r8
	movq	%r13, %r9
	xorl	%r10d, %r10d
	.p2align	4
.LBB10_146:
	movq	%r10, %r11
	movq	%r9, %rbx
	shrq	%rbx
	addq	%rbx, %r10
	leaq	(%r10,%r10,2), %r14
	cmpq	%r8, (%r12,%r14,4)
	cmovaq	%r11, %r10
	subq	%rbx, %r9
	cmpq	$1, %r9
	ja	.LBB10_146
	leaq	(%r10,%r10,2), %r10
	movq	$-1, %r9
	cmpq	%r8, (%r12,%r10,4)
	jne	.LBB10_149
	leaq	(%r12,%r10,4), %r8
	movl	8(%r8), %r9d
	jmp	.LBB10_149
.LBB10_159:
	movabsq	$1152921504606846974, %r9
	andq	%rsi, %r9
	xorl	%r8d, %r8d
	xorl	%eax, %eax
	jmp	.LBB10_160
	.p2align	4
.LBB10_164:
	xorq	%r11, %rax
	xorq	%r10, %rax
	addq	$2, %r8
	cmpq	%r8, %r9
	je	.LBB10_165
.LBB10_160:
	movq	$-1, %r10
	movq	$-1, %r11
	cmpq	(%rdi,%r8,8), %rdx
	jne	.LBB10_162
	movl	8(%r12), %r11d
.LBB10_162:
	cmpq	8(%rdi,%r8,8), %rdx
	jne	.LBB10_164
	movl	8(%r12), %r10d
	jmp	.LBB10_164
.LBB10_165:
	testb	$1, %sil
	je	.LBB10_169
.LBB10_166:
	movq	$-1, %r9
	cmpq	(%rdi,%r8,8), %rdx
	jne	.LBB10_168
	movl	8(%r12), %r9d
.LBB10_168:
	xorq	%r9, %rax
	jmp	.LBB10_169
.LBB10_152:
	movabsq	$1152921504606846972, %rcx
	andq	%rsi, %rcx
	pxor	%xmm0, %xmm0
	pcmpeqd	%xmm2, %xmm2
	movq	%rcx, %rax
	pxor	%xmm3, %xmm3
	.p2align	4
.LBB10_153:
	movdqa	%xmm3, %xmm1
	movdqa	%xmm0, %xmm4
	pxor	%xmm2, %xmm0
	pxor	%xmm2, %xmm3
	addq	$-4, %rax
	jne	.LBB10_153
	pxor	%xmm4, %xmm1
	pshufd	$238, %xmm1, %xmm0
	pxor	%xmm1, %xmm0
	movq	%xmm0, %rax
	cmpq	%rcx, %rsi
	je	.LBB10_176
.LBB10_155:
	subq	%rcx, %rsi
	.p2align	4
.LBB10_156:
	notq	%rax
	decq	%rsi
	jne	.LBB10_156
.LBB10_176:
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
.LBB10_177:
	leaq	anon.a6f1c2709b41de3543ec316f8732e788.0(%rip), %rcx
	leaq	anon.a6f1c2709b41de3543ec316f8732e788.2(%rip), %r8
	movl	$63, %edx
	callq	_RNvNtCs998Ihx2sztz_4core9panicking9panic_fmt
	ud2
.LBB10_50:
	xorl	%r15d, %r15d
	movq	%r15, %rcx
	movq	%r14, %rdx
	callq	_RNvNtCsk3xoiB9w6DV_5alloc7raw_vec12handle_error
	ud2
.LBB10_23:
	xorl	%ebx, %ebx
.LBB10_24:
	movq	%rbx, %rcx
	movq	%r15, %rdx
	callq	_RNvNtCsk3xoiB9w6DV_5alloc7raw_vec12handle_error
	ud2
.LBB10_52:
	xorl	%r15d, %r15d
.LBB10_55:
	movq	%r15, %rcx
	movq	%r14, %rdx
	callq	_RNvNtCsk3xoiB9w6DV_5alloc7raw_vec12handle_error
	ud2
.LBB10_101:
.Ltmp16:
	movq	%r15, -16(%rbp)
	movq	%r14, -32(%rbp)
	leaq	anon.a6f1c2709b41de3543ec316f8732e788.10(%rip), %rcx
	leaq	anon.a6f1c2709b41de3543ec316f8732e788.11(%rip), %r8
	movl	$113, %edx
	callq	_RNvNtCs998Ihx2sztz_4core9panicking9panic_fmt
	nop
.Ltmp17:
.LBB10_39:
	ud2
	.seh_handlerdata
	.long	$cppxdata$_RNvCs5Av9rWzHob7_3lib11hole_lookup@IMGREL
	.section	.text,"xr",one_only,_RNvCs5Av9rWzHob7_3lib11hole_lookup,unique,10
	.seh_endproc
	.def	"?dtor$56@?0?_RNvCs5Av9rWzHob7_3lib11hole_lookup@4HA";
	.scl	3;
	.type	32;
	.endef
	.p2align	4
"?dtor$56@?0?_RNvCs5Av9rWzHob7_3lib11hole_lookup@4HA":
.seh_proc "?dtor$56@?0?_RNvCs5Av9rWzHob7_3lib11hole_lookup@4HA"
.LBB10_56:
	movq	%rdx, 16(%rsp)
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
	subq	$40, %rsp
	.seh_stackalloc 40
	leaq	96(%rdx), %rbp
	.seh_endprologue
	movl	$4, %r8d
	movq	-16(%rbp), %rcx
	movq	-24(%rbp), %rdx
	callq	_RNvCs9wFQrvczXsK_7___rustc14___rust_dealloc
	nop
	.seh_startepilogue
	addq	$40, %rsp
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
	.seh_handlerdata
	.section	.text,"xr",one_only,_RNvCs5Av9rWzHob7_3lib11hole_lookup,unique,10
	.seh_endproc
	.def	"?dtor$102@?0?_RNvCs5Av9rWzHob7_3lib11hole_lookup@4HA";
	.scl	3;
	.type	32;
	.endef
	.p2align	4
"?dtor$102@?0?_RNvCs5Av9rWzHob7_3lib11hole_lookup@4HA":
.seh_proc "?dtor$102@?0?_RNvCs5Av9rWzHob7_3lib11hole_lookup@4HA"
.LBB10_102:
	movq	%rdx, 16(%rsp)
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
	subq	$40, %rsp
	.seh_stackalloc 40
	leaq	96(%rdx), %rbp
	.seh_endprologue
	cmpq	$0, -16(%rbp)
	je	.LBB10_104
	movq	-16(%rbp), %rdx
	shlq	$4, %rdx
	movl	$8, %r8d
	movq	-32(%rbp), %rcx
	callq	_RNvCs9wFQrvczXsK_7___rustc14___rust_dealloc
	nop
.LBB10_104:
	.seh_startepilogue
	addq	$40, %rsp
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
	.seh_handlerdata
	.section	.text,"xr",one_only,_RNvCs5Av9rWzHob7_3lib11hole_lookup,unique,10
	.seh_endproc
	.def	"?dtor$105@?0?_RNvCs5Av9rWzHob7_3lib11hole_lookup@4HA";
	.scl	3;
	.type	32;
	.endef
	.p2align	4
"?dtor$105@?0?_RNvCs5Av9rWzHob7_3lib11hole_lookup@4HA":
.seh_proc "?dtor$105@?0?_RNvCs5Av9rWzHob7_3lib11hole_lookup@4HA"
.LBB10_105:
	movq	%rdx, 16(%rsp)
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
	subq	$40, %rsp
	.seh_stackalloc 40
	leaq	96(%rdx), %rbp
	.seh_endprologue
	movq	-16(%rbp), %rax
	cmpq	-24(%rbp), %rax
	jbe	.LBB10_106
	movq	-16(%rbp), %rdx
	shlq	$4, %rdx
	movl	$8, %r8d
	movq	-32(%rbp), %rcx
	callq	_RNvCs9wFQrvczXsK_7___rustc14___rust_dealloc
.LBB10_106:
	movb	$0, -1(%rbp)
	.seh_startepilogue
	addq	$40, %rsp
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
	.seh_handlerdata
	.section	.text,"xr",one_only,_RNvCs5Av9rWzHob7_3lib11hole_lookup,unique,10
	.seh_endproc
	.def	"?dtor$111@?0?_RNvCs5Av9rWzHob7_3lib11hole_lookup@4HA";
	.scl	3;
	.type	32;
	.endef
	.p2align	4
"?dtor$111@?0?_RNvCs5Av9rWzHob7_3lib11hole_lookup@4HA":
.seh_proc "?dtor$111@?0?_RNvCs5Av9rWzHob7_3lib11hole_lookup@4HA"
.LBB10_111:
	movq	%rdx, 16(%rsp)
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
	subq	$40, %rsp
	.seh_stackalloc 40
	leaq	96(%rdx), %rbp
	.seh_endprologue
	cmpb	$0, -1(%rbp)
	je	.LBB10_114
	movq	-56(%rbp), %rdx
	testq	%rdx, %rdx
	je	.LBB10_114
	movq	-48(%rbp), %rcx
	shlq	$4, %rdx
	movl	$8, %r8d
	callq	_RNvCs9wFQrvczXsK_7___rustc14___rust_dealloc
	nop
.LBB10_114:
	.seh_startepilogue
	addq	$40, %rsp
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
.Lfunc_end2:
	.section	.rdata,"dr",associative,_RNvCs5Av9rWzHob7_3lib11hole_lookup,unique,11
	.p2align	2, 0x0
.LJTI10_0:
	.long	.LBB10_119-.LJTI10_0
	.long	.LBB10_125-.LJTI10_0
	.long	.LBB10_132-.LJTI10_0
	.long	.LBB10_142-.LJTI10_0
	.seh_handlerdata
	.section	.text,"xr",one_only,_RNvCs5Av9rWzHob7_3lib11hole_lookup,unique,10
	.seh_endproc
	.section	.xdata,"dr",associative,_RNvCs5Av9rWzHob7_3lib11hole_lookup,unique,2
	.p2align	2, 0x0
$cppxdata$_RNvCs5Av9rWzHob7_3lib11hole_lookup:
	.long	429065506
	.long	4
	.long	$stateUnwindMap$_RNvCs5Av9rWzHob7_3lib11hole_lookup@IMGREL
	.long	0
	.long	0
	.long	9
	.long	$ip2state$_RNvCs5Av9rWzHob7_3lib11hole_lookup@IMGREL
	.long	96
	.long	0
	.long	1
$stateUnwindMap$_RNvCs5Av9rWzHob7_3lib11hole_lookup:
	.long	-1
	.long	"?dtor$56@?0?_RNvCs5Av9rWzHob7_3lib11hole_lookup@4HA"@IMGREL
	.long	-1
	.long	"?dtor$111@?0?_RNvCs5Av9rWzHob7_3lib11hole_lookup@4HA"@IMGREL
	.long	1
	.long	"?dtor$105@?0?_RNvCs5Av9rWzHob7_3lib11hole_lookup@4HA"@IMGREL
	.long	2
	.long	"?dtor$102@?0?_RNvCs5Av9rWzHob7_3lib11hole_lookup@4HA"@IMGREL
$ip2state$_RNvCs5Av9rWzHob7_3lib11hole_lookup:
	.long	.Lfunc_begin2@IMGREL
	.long	-1
	.long	.Ltmp8@IMGREL
	.long	1
	.long	.Ltmp9@IMGREL
	.long	-1
	.long	.Ltmp4@IMGREL
	.long	0
	.long	.Ltmp10@IMGREL
	.long	1
	.long	.Ltmp18@IMGREL
	.long	2
	.long	.Ltmp19@IMGREL
	.long	-1
	.long	.Ltmp16@IMGREL
	.long	3
	.long	.Ltmp17@IMGREL
	.long	-1
	.section	.text,"xr",one_only,_RNvCs5Av9rWzHob7_3lib11hole_lookup,unique,10

	.def	_RNvMs3_NtCsk3xoiB9w6DV_5alloc7raw_vecINtB5_6RawVecNtNtCs5Av9rWzHob7_3lib14identity_index3RunE8grow_oneBQ_;
	.scl	2;
	.type	32;
	.endef
	.section	.text$unlikely,"xr",one_only,_RNvMs3_NtCsk3xoiB9w6DV_5alloc7raw_vecINtB5_6RawVecNtNtCs5Av9rWzHob7_3lib14identity_index3RunE8grow_oneBQ_,unique,12
	.globl	_RNvMs3_NtCsk3xoiB9w6DV_5alloc7raw_vecINtB5_6RawVecNtNtCs5Av9rWzHob7_3lib14identity_index3RunE8grow_oneBQ_
	.p2align	4
_RNvMs3_NtCsk3xoiB9w6DV_5alloc7raw_vecINtB5_6RawVecNtNtCs5Av9rWzHob7_3lib14identity_index3RunE8grow_oneBQ_:
	jmp	_RNvMs4_NtCsk3xoiB9w6DV_5alloc7raw_vecNtB5_11RawVecInner8grow_oneCs5Av9rWzHob7_3lib

	.def	_RNvMs4_NtCsk3xoiB9w6DV_5alloc7raw_vecNtB5_11RawVecInner11finish_growCs5Av9rWzHob7_3lib;
	.scl	3;
	.type	32;
	.endef
	.section	.text$unlikely,"xr",one_only,_RNvMs4_NtCsk3xoiB9w6DV_5alloc7raw_vecNtB5_11RawVecInner11finish_growCs5Av9rWzHob7_3lib,unique,13
	.p2align	4
_RNvMs4_NtCsk3xoiB9w6DV_5alloc7raw_vecNtB5_11RawVecInner11finish_growCs5Av9rWzHob7_3lib:
.seh_proc _RNvMs4_NtCsk3xoiB9w6DV_5alloc7raw_vecNtB5_11RawVecInner11finish_growCs5Av9rWzHob7_3lib
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
	pushq	%rbp
	.seh_pushreg %rbp
	pushq	%rbx
	.seh_pushreg %rbx
	subq	$40, %rsp
	.seh_stackalloc 40
	.seh_endprologue
	movq	%rcx, %rsi
	movq	152(%rsp), %r14
	movq	144(%rsp), %rbx
	leaq	(%rbx,%r14), %rax
	decq	%rax
	movq	%rbx, %rcx
	negq	%rcx
	andq	%rax, %rcx
	cmpq	%rcx, %r14
	jne	.LBB12_14
	movq	%rdx, %r15
	movq	%r14, %rax
	mulq	%r9
	movl	$1, %r12d
	movl	$8, %r13d
	jo	.LBB12_2
	movq	%rax, %rdi
	movq	%r8, %rbp
	movq	%rax, %rcx
	movq	%rbx, %rdx
	callq	_RNvMNtNtCs998Ihx2sztz_4core5alloc6layoutNtB2_6Layout23is_size_alignment_valid
	testb	%al, %al
	je	.LBB12_2
	testq	%r15, %r15
	je	.LBB12_8
	imulq	%r15, %r14
	cmpq	%r14, %rdi
	jb	.LBB12_15
	movq	%rbp, %rcx
	movq	%r14, %rdx
	movq	%rbx, %r8
	movq	%rdi, %r9
	callq	_RNvCs9wFQrvczXsK_7___rustc14___rust_realloc
	testq	%rax, %rax
	jne	.LBB12_12
	jmp	.LBB12_10
.LBB12_2:
	xorl	%edi, %edi
.LBB12_13:
	movq	%rdi, (%rsi,%r13)
	movq	%r12, (%rsi)
	.seh_startepilogue
	addq	$40, %rsp
	popq	%rbx
	popq	%rbp
	popq	%rdi
	popq	%rsi
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	.seh_endepilogue
	retq
.LBB12_8:
	testq	%rdi, %rdi
	je	.LBB12_11
	callq	_RNvCs9wFQrvczXsK_7___rustc35___rust_no_alloc_shim_is_unstable_v2
	movq	%rdi, %rcx
	movq	%rbx, %rdx
	callq	_RNvCs9wFQrvczXsK_7___rustc12___rust_alloc
	testq	%rax, %rax
	jne	.LBB12_12
.LBB12_10:
	movq	%rbx, 8(%rsi)
	movl	$16, %r13d
	jmp	.LBB12_13
.LBB12_11:
	movq	%rbx, %rax
.LBB12_12:
	movq	%rax, 8(%rsi)
	movl	$16, %r13d
	xorl	%r12d, %r12d
	jmp	.LBB12_13
.LBB12_14:
	leaq	anon.a6f1c2709b41de3543ec316f8732e788.12(%rip), %rcx
	leaq	anon.a6f1c2709b41de3543ec316f8732e788.13(%rip), %r8
	movl	$73, %edx
	callq	_RNvNtCs998Ihx2sztz_4core9panicking5panic
	ud2
.LBB12_15:
	leaq	anon.a6f1c2709b41de3543ec316f8732e788.7(%rip), %rcx
	leaq	anon.a6f1c2709b41de3543ec316f8732e788.9(%rip), %r8
	movl	$145, %edx
	callq	_RNvNtCs998Ihx2sztz_4core9panicking9panic_fmt
	ud2
	.seh_endproc

	.def	_RNvMs4_NtCsk3xoiB9w6DV_5alloc7raw_vecNtB5_11RawVecInner8grow_oneCs5Av9rWzHob7_3lib;
	.scl	3;
	.type	32;
	.endef
	.section	.text$unlikely,"xr",one_only,_RNvMs4_NtCsk3xoiB9w6DV_5alloc7raw_vecNtB5_11RawVecInner8grow_oneCs5Av9rWzHob7_3lib,unique,14
	.p2align	4
_RNvMs4_NtCsk3xoiB9w6DV_5alloc7raw_vecNtB5_11RawVecInner8grow_oneCs5Av9rWzHob7_3lib:
.seh_proc _RNvMs4_NtCsk3xoiB9w6DV_5alloc7raw_vecNtB5_11RawVecInner8grow_oneCs5Av9rWzHob7_3lib
	pushq	%rsi
	.seh_pushreg %rsi
	pushq	%rdi
	.seh_pushreg %rdi
	pushq	%rbx
	.seh_pushreg %rbx
	subq	$80, %rsp
	.seh_stackalloc 80
	.seh_endprologue
	movq	%rcx, %rsi
	movq	(%rcx), %rbx
	leaq	(%rbx,%rbx), %rax
	testq	%rbx, %rbx
	movl	$1, %edi
	cmovneq	%rax, %rdi
	movl	$16, %ecx
	callq	_RNvNtCsk3xoiB9w6DV_5alloc7raw_vec16min_non_zero_cap
	cmpq	%rax, %rdi
	cmovbeq	%rax, %rdi
	movq	8(%rsi), %r8
	movq	$16, 40(%rsp)
	movq	$8, 32(%rsp)
	leaq	56(%rsp), %rcx
	movq	%rbx, %rdx
	movq	%rdi, %r9
	callq	_RNvMs4_NtCsk3xoiB9w6DV_5alloc7raw_vecNtB5_11RawVecInner11finish_growCs5Av9rWzHob7_3lib
	movq	64(%rsp), %rcx
	cmpb	$0, 56(%rsp)
	je	.LBB13_1
	cmpq	$-1, %rcx
	je	.LBB13_2
	movq	72(%rsp), %rdx
	callq	_RNvNtCsk3xoiB9w6DV_5alloc7raw_vec12handle_error
	ud2
.LBB13_1:
	movq	%rcx, 8(%rsi)
	movq	%rdi, (%rsi)
.LBB13_2:
	.seh_startepilogue
	addq	$80, %rsp
	popq	%rbx
	popq	%rdi
	popq	%rsi
	.seh_endepilogue
	retq
	.seh_endproc

	.section	.rdata,"dr",one_only,anon.a6f1c2709b41de3543ec316f8732e788.0,unique,15
anon.a6f1c2709b41de3543ec316f8732e788.0:
	.ascii	"admitted logical identity count"

	.section	.rdata,"dr",one_only,anon.a6f1c2709b41de3543ec316f8732e788.1,unique,16
anon.a6f1c2709b41de3543ec316f8732e788.1:
	.asciz	"/root/gpui-identity-hole-hot/reactivity/crates/gpui/src/runtime/identity_index.rs"

	.section	.rdata,"dr",one_only,anon.a6f1c2709b41de3543ec316f8732e788.2,unique,17
	.p2align	3, 0x0
anon.a6f1c2709b41de3543ec316f8732e788.2:
	.quad	anon.a6f1c2709b41de3543ec316f8732e788.1
	.asciz	"Q\000\000\000\000\000\000\000P\000\000\000\t\000\000"

	.section	.rdata,"dr",one_only,anon.a6f1c2709b41de3543ec316f8732e788.3,unique,18
anon.a6f1c2709b41de3543ec316f8732e788.3:
	.ascii	"distinct admitted logical identities"

	.section	.rdata,"dr",one_only,anon.a6f1c2709b41de3543ec316f8732e788.4,unique,19
	.p2align	3, 0x0
anon.a6f1c2709b41de3543ec316f8732e788.4:
	.quad	anon.a6f1c2709b41de3543ec316f8732e788.1
	.asciz	"Q\000\000\000\000\000\000\000\227\000\000\000\t\000\000"

	.section	.rdata,"dr",one_only,anon.a6f1c2709b41de3543ec316f8732e788.5,unique,20
	.p2align	3, 0x0
anon.a6f1c2709b41de3543ec316f8732e788.5:
	.quad	anon.a6f1c2709b41de3543ec316f8732e788.1
	.asciz	"Q\000\000\000\000\000\000\000\203\000\000\000\r\000\000"

	.section	.rdata,"dr",one_only,anon.a6f1c2709b41de3543ec316f8732e788.6,unique,21
anon.a6f1c2709b41de3543ec316f8732e788.6:
	.asciz	"/nix/store/lynmg3kdpdz41r84nafwzi2n5nss50pq-rust-1.97.1-with-components-2026-07-16/lib/rustlib/src/rust/library/alloc/src/raw_vec/mod.rs"

	.section	.rdata,"dr",one_only,anon.a6f1c2709b41de3543ec316f8732e788.7,unique,22
anon.a6f1c2709b41de3543ec316f8732e788.7:
	.ascii	"`new_layout.size()` must be greater than or equal to `old_layout.size()`"

	.section	.rdata,"dr",one_only,anon.a6f1c2709b41de3543ec316f8732e788.8,unique,23
anon.a6f1c2709b41de3543ec316f8732e788.8:
	.asciz	"/nix/store/lynmg3kdpdz41r84nafwzi2n5nss50pq-rust-1.97.1-with-components-2026-07-16/lib/rustlib/src/rust/library/alloc/src/alloc.rs"

	.section	.rdata,"dr",one_only,anon.a6f1c2709b41de3543ec316f8732e788.9,unique,24
	.p2align	3, 0x0
anon.a6f1c2709b41de3543ec316f8732e788.9:
	.quad	anon.a6f1c2709b41de3543ec316f8732e788.8
	.asciz	"\202\000\000\000\000\000\000\000\363\000\000\000\t\000\000"

	.section	.rdata,"dr",one_only,anon.a6f1c2709b41de3543ec316f8732e788.10,unique,25
anon.a6f1c2709b41de3543ec316f8732e788.10:
	.ascii	"`len` must be smaller than or equal to `self.capacity()`"

	.section	.rdata,"dr",one_only,anon.a6f1c2709b41de3543ec316f8732e788.11,unique,26
	.p2align	3, 0x0
anon.a6f1c2709b41de3543ec316f8732e788.11:
	.quad	anon.a6f1c2709b41de3543ec316f8732e788.6
	.asciz	"\210\000\000\000\000\000\000\000\360\000\000\000\t\000\000"

	.section	.rdata,"dr",one_only,anon.a6f1c2709b41de3543ec316f8732e788.12,unique,27
anon.a6f1c2709b41de3543ec316f8732e788.12:
	.ascii	"assertion failed: elem_layout.size() == elem_layout.pad_to_align().size()"

	.section	.rdata,"dr",one_only,anon.a6f1c2709b41de3543ec316f8732e788.13,unique,28
	.p2align	3, 0x0
anon.a6f1c2709b41de3543ec316f8732e788.13:
	.quad	anon.a6f1c2709b41de3543ec316f8732e788.6
	.asciz	"\210\000\000\000\000\000\000\000\203\003\000\000\005\000\000"
