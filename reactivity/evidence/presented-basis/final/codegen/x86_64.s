	.file	"presented_basis_asm_audit.4fff0c95626cad09-cgu.0"
	.section	.text._RNvCs6ROJKbSVzdt_25presented_basis_asm_audit19decode_retained_map,"ax",@progbits
	.globl	_RNvCs6ROJKbSVzdt_25presented_basis_asm_audit19decode_retained_map
	.p2align	4
	.type	_RNvCs6ROJKbSVzdt_25presented_basis_asm_audit19decode_retained_map,@function
_RNvCs6ROJKbSVzdt_25presented_basis_asm_audit19decode_retained_map:
	.cfi_startproc
	movsd	(%rdx), %xmm0
	movq	%rsi, %rax
	shrq	$32, %rax
	cmpl	$2143289345, %esi
	je	.LBB0_3
	xorl	%ecx, %ecx
	cmpl	$2143289346, %esi
	je	.LBB0_6
	xorps	%xmm1, %xmm1
	jmp	.LBB0_5
.LBB0_3:
	cmpq	%r8, %rax
	jae	.LBB0_7
	shlq	$4, %rax
	movl	(%rcx,%rax), %esi
	movsd	4(%rcx,%rax), %xmm1
	movl	12(%rcx,%rax), %eax
.LBB0_5:
	movl	%esi, 4(%rdi)
	movlps	%xmm1, 8(%rdi)
	movl	%eax, 16(%rdi)
	movlps	%xmm0, 20(%rdi)
	movl	$1, %ecx
.LBB0_6:
	movl	%ecx, (%rdi)
	movq	%rdi, %rax
	retq
.LBB0_7:
	pushq	%rax
	.cfi_def_cfa_offset 16
	leaq	.Lanon.3149c549f859ff8a0ff00502c2fe8def.1(%rip), %rdx
	movq	%rax, %rdi
	movq	%r8, %rsi
	callq	*_RNvNtCs4NRVxsYgnAr_4core9panicking18panic_bounds_check@GOTPCREL(%rip)
.Lfunc_end0:
	.size	_RNvCs6ROJKbSVzdt_25presented_basis_asm_audit19decode_retained_map, .Lfunc_end0-_RNvCs6ROJKbSVzdt_25presented_basis_asm_audit19decode_retained_map
	.cfi_endproc

	.section	.text._RNvCs6ROJKbSVzdt_25presented_basis_asm_audit19encode_admitted_map,"ax",@progbits
	.globl	_RNvCs6ROJKbSVzdt_25presented_basis_asm_audit19encode_admitted_map
	.p2align	4
	.type	_RNvCs6ROJKbSVzdt_25presented_basis_asm_audit19encode_admitted_map,@function
_RNvCs6ROJKbSVzdt_25presented_basis_asm_audit19encode_admitted_map:
	.cfi_startproc
	pushq	%r14
	.cfi_def_cfa_offset 16
	pushq	%rbx
	.cfi_def_cfa_offset 24
	subq	$24, %rsp
	.cfi_def_cfa_offset 48
	.cfi_offset %rbx, -24
	.cfi_offset %r14, -16
	movl	$2143289346, %eax
	cmpl	$1, (%rdi)
	jne	.LBB1_18
	movl	(%rsi), %ecx
	movq	4(%rsi), %rax
	movups	4(%rdi), %xmm2
	movaps	%xmm2, %xmm0
	shufps	$85, %xmm2, %xmm0
	movd	%xmm0, %esi
	testl	%esi, %esi
	jne	.LBB1_4
	movaps	%xmm2, %xmm1
	unpckhpd	%xmm2, %xmm1
	movd	%xmm1, %esi
	testl	%esi, %esi
	jne	.LBB1_4
	movd	%xmm2, %eax
	shufps	$255, %xmm2, %xmm2
	movd	%xmm2, %ecx
	shlq	$32, %rcx
	orq	%rcx, %rax
.LBB1_18:
	addq	$24, %rsp
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%r14
	.cfi_def_cfa_offset 8
	retq
.LBB1_4:
	.cfi_def_cfa_offset 48
	testb	$1, %cl
	je	.LBB1_5
	movq	16(%rdx), %rbx
	movq	%rax, %rdi
	shrq	$32, %rdi
	cmpl	$2143289345, %eax
	je	.LBB1_10
	cmpl	$2143289346, %eax
	je	.LBB1_8
	shlq	$32, %rdi
	movl	%eax, %ecx
	jmp	.LBB1_14
.LBB1_5:
	movq	16(%rdx), %rbx
	jmp	.LBB1_8
.LBB1_10:
	cmpq	%rbx, %rdi
	jae	.LBB1_12
	movq	8(%rdx), %rsi
	shlq	$4, %rdi
	movq	(%rsi,%rdi), %rcx
	movq	8(%rsi,%rdi), %rdi
.LBB1_14:
	movd	%xmm0, %esi
	movaps	%xmm2, %xmm0
	shufps	$255, %xmm2, %xmm0
	movd	%xmm0, %r8d
	movaps	%xmm2, %xmm0
	unpckhpd	%xmm2, %xmm0
	movd	%xmm0, %r9d
	movd	%xmm2, %r10d
	shlq	$32, %r8
	orq	%r9, %r8
	xorq	%rdi, %r8
	shlq	$32, %rsi
	orq	%r10, %rsi
	xorq	%rcx, %rsi
	orq	%r8, %rsi
	je	.LBB1_18
.LBB1_8:
	cmpq	$100000, %rbx
	jae	.LBB1_9
	cmpq	(%rdx), %rbx
	je	.LBB1_16
.LBB1_17:
	movq	8(%rdx), %rax
	movq	%rbx, %rcx
	shlq	$4, %rcx
	movups	%xmm2, (%rax,%rcx)
	leaq	1(%rbx), %rax
	movq	%rax, 16(%rdx)
	shlq	$32, %rbx
	orq	$2143289345, %rbx
	movq	%rbx, %rax
	addq	$24, %rsp
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%r14
	.cfi_def_cfa_offset 8
	retq
.LBB1_16:
	.cfi_def_cfa_offset 48
	movq	%rdx, %rdi
	movq	%rdx, %r14
	movaps	%xmm2, (%rsp)
	callq	*_RNvMs3_NtCscdodAO9FK5_5alloc7raw_vecINtB5_6RawVecNtNtCs6ROJKbSVzdt_25presented_basis_asm_audit5codec6RecordE8grow_oneBP_@GOTPCREL(%rip)
	movaps	(%rsp), %xmm2
	movq	%r14, %rdx
	jmp	.LBB1_17
.LBB1_9:
	leaq	.Lanon.3149c549f859ff8a0ff00502c2fe8def.2(%rip), %rdi
	leaq	.Lanon.3149c549f859ff8a0ff00502c2fe8def.3(%rip), %rdx
	movl	$71, %esi
	callq	*_RNvNtCs4NRVxsYgnAr_4core9panicking9panic_fmt@GOTPCREL(%rip)
.LBB1_12:
	leaq	.Lanon.3149c549f859ff8a0ff00502c2fe8def.1(%rip), %rdx
	movq	%rbx, %rsi
	callq	*_RNvNtCs4NRVxsYgnAr_4core9panicking18panic_bounds_check@GOTPCREL(%rip)
.Lfunc_end1:
	.size	_RNvCs6ROJKbSVzdt_25presented_basis_asm_audit19encode_admitted_map, .Lfunc_end1-_RNvCs6ROJKbSVzdt_25presented_basis_asm_audit19encode_admitted_map
	.cfi_endproc

	.section	.text.unlikely._RNvMs3_NtCscdodAO9FK5_5alloc7raw_vecINtB5_6RawVecNtNtCs6ROJKbSVzdt_25presented_basis_asm_audit5codec6RecordE8grow_oneBP_,"ax",@progbits
	.globl	_RNvMs3_NtCscdodAO9FK5_5alloc7raw_vecINtB5_6RawVecNtNtCs6ROJKbSVzdt_25presented_basis_asm_audit5codec6RecordE8grow_oneBP_
	.p2align	4
	.type	_RNvMs3_NtCscdodAO9FK5_5alloc7raw_vecINtB5_6RawVecNtNtCs6ROJKbSVzdt_25presented_basis_asm_audit5codec6RecordE8grow_oneBP_,@function
_RNvMs3_NtCscdodAO9FK5_5alloc7raw_vecINtB5_6RawVecNtNtCs6ROJKbSVzdt_25presented_basis_asm_audit5codec6RecordE8grow_oneBP_:
	.cfi_startproc
	pushq	%rax
	.cfi_def_cfa_offset 16
	movq	(%rdi), %rsi
	callq	_RNvMs4_NtCscdodAO9FK5_5alloc7raw_vecNtB5_11RawVecInner14grow_amortizedCs6ROJKbSVzdt_25presented_basis_asm_audit
	cmpq	$-1, %rax
	jne	.LBB2_2
	popq	%rax
	.cfi_def_cfa_offset 8
	retq
.LBB2_2:
	.cfi_def_cfa_offset 16
	movq	%rax, %rdi
	movq	%rdx, %rsi
	callq	*_RNvNtCscdodAO9FK5_5alloc7raw_vec12handle_error@GOTPCREL(%rip)
.Lfunc_end2:
	.size	_RNvMs3_NtCscdodAO9FK5_5alloc7raw_vecINtB5_6RawVecNtNtCs6ROJKbSVzdt_25presented_basis_asm_audit5codec6RecordE8grow_oneBP_, .Lfunc_end2-_RNvMs3_NtCscdodAO9FK5_5alloc7raw_vecINtB5_6RawVecNtNtCs6ROJKbSVzdt_25presented_basis_asm_audit5codec6RecordE8grow_oneBP_
	.cfi_endproc

	.section	.text.unlikely._RNvMs4_NtCscdodAO9FK5_5alloc7raw_vecNtB5_11RawVecInner11finish_growCs6ROJKbSVzdt_25presented_basis_asm_audit,"ax",@progbits
	.p2align	4
	.type	_RNvMs4_NtCscdodAO9FK5_5alloc7raw_vecNtB5_11RawVecInner11finish_growCs6ROJKbSVzdt_25presented_basis_asm_audit,@function
_RNvMs4_NtCscdodAO9FK5_5alloc7raw_vecNtB5_11RawVecInner11finish_growCs6ROJKbSVzdt_25presented_basis_asm_audit:
	.cfi_startproc
	pushq	%r15
	.cfi_def_cfa_offset 16
	pushq	%r14
	.cfi_def_cfa_offset 24
	pushq	%rbx
	.cfi_def_cfa_offset 32
	.cfi_offset %rbx, -32
	.cfi_offset %r14, -24
	.cfi_offset %r15, -16
	movq	%rdi, %rbx
	movq	%rcx, %r14
	shlq	$4, %r14
	shrq	$60, %rcx
	setne	%al
	movabsq	$9223372036854775804, %rcx
	cmpq	%rcx, %r14
	seta	%cl
	movl	$1, %r15d
	orb	%al, %cl
	je	.LBB3_2
	movl	$8, %eax
	xorl	%r14d, %r14d
	jmp	.LBB3_10
.LBB3_2:
	testq	%rsi, %rsi
	je	.LBB3_4
	shlq	$4, %rsi
	movq	%rdx, %rdi
	movl	$4, %edx
	movq	%r14, %rcx
	callq	*_RNvCs9wFQrvczXsK_7___rustc14___rust_realloc@GOTPCREL(%rip)
	testq	%rax, %rax
	jne	.LBB3_6
	jmp	.LBB3_9
.LBB3_4:
	testq	%r14, %r14
	je	.LBB3_5
	callq	*_RNvCs9wFQrvczXsK_7___rustc35___rust_no_alloc_shim_is_unstable_v2@GOTPCREL(%rip)
	movl	$4, %esi
	movq	%r14, %rdi
	callq	*_RNvCs9wFQrvczXsK_7___rustc12___rust_alloc@GOTPCREL(%rip)
	testq	%rax, %rax
	jne	.LBB3_6
.LBB3_9:
	movq	$4, 8(%rbx)
	movl	$16, %eax
	jmp	.LBB3_10
.LBB3_5:
	movl	$4, %eax
.LBB3_6:
	movq	%rax, 8(%rbx)
	movl	$16, %eax
	xorl	%r15d, %r15d
.LBB3_10:
	movq	%r14, (%rbx,%rax)
	movq	%r15, (%rbx)
	popq	%rbx
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end3:
	.size	_RNvMs4_NtCscdodAO9FK5_5alloc7raw_vecNtB5_11RawVecInner11finish_growCs6ROJKbSVzdt_25presented_basis_asm_audit, .Lfunc_end3-_RNvMs4_NtCscdodAO9FK5_5alloc7raw_vecNtB5_11RawVecInner11finish_growCs6ROJKbSVzdt_25presented_basis_asm_audit
	.cfi_endproc

	.section	.text.unlikely._RNvMs4_NtCscdodAO9FK5_5alloc7raw_vecNtB5_11RawVecInner14grow_amortizedCs6ROJKbSVzdt_25presented_basis_asm_audit,"ax",@progbits
	.p2align	4
	.type	_RNvMs4_NtCscdodAO9FK5_5alloc7raw_vecNtB5_11RawVecInner14grow_amortizedCs6ROJKbSVzdt_25presented_basis_asm_audit,@function
_RNvMs4_NtCscdodAO9FK5_5alloc7raw_vecNtB5_11RawVecInner14grow_amortizedCs6ROJKbSVzdt_25presented_basis_asm_audit:
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
	incq	%rsi
	movq	(%rdi), %rax
	leaq	(%rax,%rax), %rcx
	cmpq	%rcx, %rsi
	cmovbeq	%rcx, %rsi
	cmpq	$5, %rsi
	movl	$4, %r14d
	cmovaeq	%rsi, %r14
	movq	8(%rdi), %rdx
	movq	%rsp, %rdi
	movq	%rax, %rsi
	movq	%r14, %rcx
	callq	_RNvMs4_NtCscdodAO9FK5_5alloc7raw_vecNtB5_11RawVecInner11finish_growCs6ROJKbSVzdt_25presented_basis_asm_audit
	cmpb	$0, (%rsp)
	je	.LBB4_2
	movq	8(%rsp), %rax
	movq	16(%rsp), %rdx
	addq	$24, %rsp
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%r14
	.cfi_def_cfa_offset 8
	retq
.LBB4_2:
	.cfi_def_cfa_offset 48
	movq	8(%rsp), %rax
	movq	%rax, 8(%rbx)
	movq	%r14, (%rbx)
	movq	$-1, %rax
	addq	$24, %rsp
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%r14
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end4:
	.size	_RNvMs4_NtCscdodAO9FK5_5alloc7raw_vecNtB5_11RawVecInner14grow_amortizedCs6ROJKbSVzdt_25presented_basis_asm_audit, .Lfunc_end4-_RNvMs4_NtCscdodAO9FK5_5alloc7raw_vecNtB5_11RawVecInner14grow_amortizedCs6ROJKbSVzdt_25presented_basis_asm_audit
	.cfi_endproc

	.type	.Lanon.3149c549f859ff8a0ff00502c2fe8def.0,@object
	.section	.rodata.str1.1,"aMS",@progbits,1
.Lanon.3149c549f859ff8a0ff00502c2fe8def.0:
	.asciz	"/tmp/gpui-presented-basis-asm/src/shipping_codec.rs"
	.size	.Lanon.3149c549f859ff8a0ff00502c2fe8def.0, 52

	.type	.Lanon.3149c549f859ff8a0ff00502c2fe8def.1,@object
	.section	.data.rel.ro..Lanon.3149c549f859ff8a0ff00502c2fe8def.1,"aw",@progbits
	.p2align	3, 0x0
.Lanon.3149c549f859ff8a0ff00502c2fe8def.1:
	.quad	.Lanon.3149c549f859ff8a0ff00502c2fe8def.0
	.asciz	"3\000\000\000\000\000\000\000\212\000\000\000/\000\000"
	.size	.Lanon.3149c549f859ff8a0ff00502c2fe8def.1, 24

	.type	.Lanon.3149c549f859ff8a0ff00502c2fe8def.2,@object
	.section	.rodata..Lanon.3149c549f859ff8a0ff00502c2fe8def.2,"a",@progbits
.Lanon.3149c549f859ff8a0ff00502c2fe8def.2:
	.ascii	"basis belongs to the admitted sheet"
	.size	.Lanon.3149c549f859ff8a0ff00502c2fe8def.2, 35

	.type	.Lanon.3149c549f859ff8a0ff00502c2fe8def.3,@object
	.section	.data.rel.ro..Lanon.3149c549f859ff8a0ff00502c2fe8def.3,"aw",@progbits
	.p2align	3, 0x0
.Lanon.3149c549f859ff8a0ff00502c2fe8def.3:
	.quad	.Lanon.3149c549f859ff8a0ff00502c2fe8def.0
	.asciz	"3\000\000\000\000\000\000\000s\000\000\000\t\000\000"
	.size	.Lanon.3149c549f859ff8a0ff00502c2fe8def.3, 24

	.ident	"rustc version 1.97.1 (8bab26f4f 2026-07-14)"
	.section	".note.GNU-stack","",@progbits
