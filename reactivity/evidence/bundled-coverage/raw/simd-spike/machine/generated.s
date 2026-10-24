	.file	"coverage_events.ae45028cbb2df358-cgu.0"
	.section	.text._RINvCsh3jZH8iL7E3_26gpui_coverage_events_spike4emitNtNtCs4NRVxsYgnAr_4core7convert10InfallibleNCNvCseXDeBKE4kK2_15coverage_events8checksum0EB1y_,"ax",@progbits
	.p2align	4
	.type	_RINvCsh3jZH8iL7E3_26gpui_coverage_events_spike4emitNtNtCs4NRVxsYgnAr_4core7convert10InfallibleNCNvCseXDeBKE4kK2_15coverage_events8checksum0EB1y_,@function
_RINvCsh3jZH8iL7E3_26gpui_coverage_events_spike4emitNtNtCs4NRVxsYgnAr_4core7convert10InfallibleNCNvCseXDeBKE4kK2_15coverage_events8checksum0EB1y_:
	.cfi_startproc
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset %rbx, -16
	testw	%cx, %cx
	je	.LBB0_15
	movq	(%r8), %r8
	jmp	.LBB0_2
.LBB0_8:
	shll	$6, %ecx
	orl	%ebx, %ecx
	movl	%ecx, %r10d
	.p2align	4
.LBB0_14:
	leal	-1(%r9), %ecx
	andl	%r9d, %ecx
	movl	%r10d, %r9d
	addq	%r9, %rax
	addq	%rax, (%r8)
	testw	%cx, %cx
	je	.LBB0_15
.LBB0_2:
	movl	%ecx, %r9d
	rep		bsfl	%r9d, %eax
	addq	%rdx, %rax
	je	.LBB0_5
	cmpq	%rsi, %rax
	jae	.LBB0_4
	cmpb	$-65, (%rdi,%rax)
	jg	.LBB0_5
	jmp	.LBB0_12
	.p2align	4
.LBB0_4:
	jne	.LBB0_12
.LBB0_5:
	cmpq	%rsi, %rax
	je	.LBB0_16
	movzbl	(%rdi,%rax), %r10d
	testb	%r10b, %r10b
	jns	.LBB0_14
	movl	%r10d, %ecx
	andl	$31, %ecx
	movzbl	1(%rdi,%rax), %ebx
	andl	$63, %ebx
	cmpb	$-33, %r10b
	jbe	.LBB0_8
	movzbl	2(%rdi,%rax), %r11d
	shll	$6, %ebx
	andl	$63, %r11d
	orl	%ebx, %r11d
	cmpb	$-16, %r10b
	jb	.LBB0_10
	movzbl	3(%rdi,%rax), %r10d
	andl	$7, %ecx
	shll	$18, %ecx
	shll	$6, %r11d
	andl	$63, %r10d
	orl	%r11d, %r10d
	orl	%ecx, %r10d
	jmp	.LBB0_14
.LBB0_10:
	shll	$12, %ecx
	orl	%ecx, %r11d
	movl	%r11d, %r10d
	jmp	.LBB0_14
.LBB0_15:
	popq	%rbx
	.cfi_def_cfa_offset 8
	retq
.LBB0_16:
	.cfi_def_cfa_offset 16
	leaq	.Lanon.c559f973accb09ee9d4e95a4ca8552cc.2(%rip), %rdi
	leaq	.Lanon.c559f973accb09ee9d4e95a4ca8552cc.3(%rip), %rdx
	movl	$23, %esi
	callq	*_RNvNtCs4NRVxsYgnAr_4core6option13expect_failed@GOTPCREL(%rip)
.LBB0_12:
	leaq	.Lanon.c559f973accb09ee9d4e95a4ca8552cc.1(%rip), %r8
	movq	%rax, %rdx
	movq	%rsi, %rcx
	callq	*_RNvNtCs4NRVxsYgnAr_4core3str16slice_error_fail@GOTPCREL(%rip)
.Lfunc_end0:
	.size	_RINvCsh3jZH8iL7E3_26gpui_coverage_events_spike4emitNtNtCs4NRVxsYgnAr_4core7convert10InfallibleNCNvCseXDeBKE4kK2_15coverage_events8checksum0EB1y_, .Lfunc_end0-_RINvCsh3jZH8iL7E3_26gpui_coverage_events_spike4emitNtNtCs4NRVxsYgnAr_4core7convert10InfallibleNCNvCseXDeBKE4kK2_15coverage_events8checksum0EB1y_
	.cfi_endproc

	.section	.text._RINvNtCs2AWtUsOyxgP_3std2rt10lang_startuECseXDeBKE4kK2_15coverage_events,"ax",@progbits
	.hidden	_RINvNtCs2AWtUsOyxgP_3std2rt10lang_startuECseXDeBKE4kK2_15coverage_events
	.globl	_RINvNtCs2AWtUsOyxgP_3std2rt10lang_startuECseXDeBKE4kK2_15coverage_events
	.p2align	4
	.type	_RINvNtCs2AWtUsOyxgP_3std2rt10lang_startuECseXDeBKE4kK2_15coverage_events,@function
_RINvNtCs2AWtUsOyxgP_3std2rt10lang_startuECseXDeBKE4kK2_15coverage_events:
	.cfi_startproc
	pushq	%rax
	.cfi_def_cfa_offset 16
	movl	%ecx, %r8d
	movq	%rdx, %rcx
	movq	%rsi, %rdx
	movq	%rdi, (%rsp)
	leaq	.Lanon.c559f973accb09ee9d4e95a4ca8552cc.4(%rip), %rsi
	movq	%rsp, %rdi
	callq	*_RNvNtCs2AWtUsOyxgP_3std2rt19lang_start_internal@GOTPCREL(%rip)
	popq	%rcx
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end1:
	.size	_RINvNtCs2AWtUsOyxgP_3std2rt10lang_startuECseXDeBKE4kK2_15coverage_events, .Lfunc_end1-_RINvNtCs2AWtUsOyxgP_3std2rt10lang_startuECseXDeBKE4kK2_15coverage_events
	.cfi_endproc

	.section	.text._RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtCs2AWtUsOyxgP_3std3env4ArgsECseXDeBKE4kK2_15coverage_events,"ax",@progbits
	.p2align	4
	.type	_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtCs2AWtUsOyxgP_3std3env4ArgsECseXDeBKE4kK2_15coverage_events,@function
_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtCs2AWtUsOyxgP_3std3env4ArgsECseXDeBKE4kK2_15coverage_events:
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
	movq	%rdi, %rbx
	movq	8(%rdi), %r15
	movq	24(%rdi), %rcx
	movq	%rcx, %rax
	subq	%r15, %rax
	movabsq	$-6148914691236517205, %rdx
	mulq	%rdx
	cmpq	%r15, %rcx
	je	.LBB2_5
	movq	%rdx, %r14
	shrq	$4, %r14
	addq	$8, %r15
	movq	_RNvCs9wFQrvczXsK_7___rustc14___rust_dealloc@GOTPCREL(%rip), %r12
	jmp	.LBB2_2
	.p2align	4
.LBB2_4:
	addq	$24, %r15
	decq	%r14
	je	.LBB2_5
.LBB2_2:
	movq	-8(%r15), %rsi
	testq	%rsi, %rsi
	je	.LBB2_4
	movq	(%r15), %rdi
	movl	$1, %edx
	callq	*%r12
	jmp	.LBB2_4
.LBB2_5:
	movq	16(%rbx), %rax
	testq	%rax, %rax
	je	.LBB2_6
	movq	(%rbx), %rdi
	shlq	$3, %rax
	leaq	(%rax,%rax,2), %rsi
	movl	$8, %edx
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
	jmpq	*_RNvCs9wFQrvczXsK_7___rustc14___rust_dealloc@GOTPCREL(%rip)
.LBB2_6:
	.cfi_def_cfa_offset 48
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
.Lfunc_end2:
	.size	_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtCs2AWtUsOyxgP_3std3env4ArgsECseXDeBKE4kK2_15coverage_events, .Lfunc_end2-_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtCs2AWtUsOyxgP_3std3env4ArgsECseXDeBKE4kK2_15coverage_events
	.cfi_endproc

	.section	.text._RINvNtNtCs2AWtUsOyxgP_3std3sys9backtrace28___rust_begin_short_backtraceFEuuECseXDeBKE4kK2_15coverage_events,"ax",@progbits
	.p2align	4
	.type	_RINvNtNtCs2AWtUsOyxgP_3std3sys9backtrace28___rust_begin_short_backtraceFEuuECseXDeBKE4kK2_15coverage_events,@function
_RINvNtNtCs2AWtUsOyxgP_3std3sys9backtrace28___rust_begin_short_backtraceFEuuECseXDeBKE4kK2_15coverage_events:
	.cfi_startproc
	pushq	%rax
	.cfi_def_cfa_offset 16
	callq	*%rdi
	#APP
	#NO_APP
	popq	%rax
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end3:
	.size	_RINvNtNtCs2AWtUsOyxgP_3std3sys9backtrace28___rust_begin_short_backtraceFEuuECseXDeBKE4kK2_15coverage_events, .Lfunc_end3-_RINvNtNtCs2AWtUsOyxgP_3std3sys9backtrace28___rust_begin_short_backtraceFEuuECseXDeBKE4kK2_15coverage_events
	.cfi_endproc

	.section	.text._RNCINvNtCs2AWtUsOyxgP_3std2rt10lang_startuE0CseXDeBKE4kK2_15coverage_events,"ax",@progbits
	.p2align	4
	.type	_RNCINvNtCs2AWtUsOyxgP_3std2rt10lang_startuE0CseXDeBKE4kK2_15coverage_events,@function
_RNCINvNtCs2AWtUsOyxgP_3std2rt10lang_startuE0CseXDeBKE4kK2_15coverage_events:
	.cfi_startproc
	pushq	%rax
	.cfi_def_cfa_offset 16
	movq	(%rdi), %rdi
	callq	_RINvNtNtCs2AWtUsOyxgP_3std3sys9backtrace28___rust_begin_short_backtraceFEuuECseXDeBKE4kK2_15coverage_events
	xorl	%eax, %eax
	popq	%rcx
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end4:
	.size	_RNCINvNtCs2AWtUsOyxgP_3std2rt10lang_startuE0CseXDeBKE4kK2_15coverage_events, .Lfunc_end4-_RNCINvNtCs2AWtUsOyxgP_3std2rt10lang_startuE0CseXDeBKE4kK2_15coverage_events
	.cfi_endproc

	.section	.text._RNSNvYNCINvNtCs2AWtUsOyxgP_3std2rt10lang_startuE0INtNtNtCs4NRVxsYgnAr_4core3ops8function6FnOnceuE9call_once6vtableCseXDeBKE4kK2_15coverage_events,"ax",@progbits
	.p2align	4
	.type	_RNSNvYNCINvNtCs2AWtUsOyxgP_3std2rt10lang_startuE0INtNtNtCs4NRVxsYgnAr_4core3ops8function6FnOnceuE9call_once6vtableCseXDeBKE4kK2_15coverage_events,@function
_RNSNvYNCINvNtCs2AWtUsOyxgP_3std2rt10lang_startuE0INtNtNtCs4NRVxsYgnAr_4core3ops8function6FnOnceuE9call_once6vtableCseXDeBKE4kK2_15coverage_events:
	.cfi_startproc
	pushq	%rax
	.cfi_def_cfa_offset 16
	movq	(%rdi), %rdi
	callq	_RINvNtNtCs2AWtUsOyxgP_3std3sys9backtrace28___rust_begin_short_backtraceFEuuECseXDeBKE4kK2_15coverage_events
	xorl	%eax, %eax
	popq	%rcx
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end5:
	.size	_RNSNvYNCINvNtCs2AWtUsOyxgP_3std2rt10lang_startuE0INtNtNtCs4NRVxsYgnAr_4core3ops8function6FnOnceuE9call_once6vtableCseXDeBKE4kK2_15coverage_events, .Lfunc_end5-_RNSNvYNCINvNtCs2AWtUsOyxgP_3std2rt10lang_startuE0INtNtNtCs4NRVxsYgnAr_4core3ops8function6FnOnceuE9call_once6vtableCseXDeBKE4kK2_15coverage_events
	.cfi_endproc

	.section	.text._RNvCseXDeBKE4kK2_15coverage_events4main,"ax",@progbits
	.hidden	_RNvCseXDeBKE4kK2_15coverage_events4main
	.globl	_RNvCseXDeBKE4kK2_15coverage_events4main
	.p2align	4
	.type	_RNvCseXDeBKE4kK2_15coverage_events4main,@function
_RNvCseXDeBKE4kK2_15coverage_events4main:
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
	subq	$56, %rsp
	.cfi_def_cfa_offset 112
	.cfi_offset %rbx, -56
	.cfi_offset %r12, -48
	.cfi_offset %r13, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	.cfi_offset %rbp, -16
	movq	%rsp, %r14
	movq	%r14, %rdi
	callq	*_RNvNtCs2AWtUsOyxgP_3std3env4args@GOTPCREL(%rip)
.Ltmp0:
	leaq	32(%rsp), %rdi
	movq	%r14, %rsi
	callq	*_RNvXsa_NtCs2AWtUsOyxgP_3std3envNtB5_4ArgsNtNtNtNtCs4NRVxsYgnAr_4core4iter6traits8iterator8Iterator4next@GOTPCREL(%rip)
.Ltmp1:
	movq	32(%rsp), %rsi
	cmpq	$-1, %rsi
	je	.LBB6_7
	testq	%rsi, %rsi
	je	.LBB6_4
	movq	40(%rsp), %rdi
	movl	$1, %edx
	callq	*_RNvCs9wFQrvczXsK_7___rustc14___rust_dealloc@GOTPCREL(%rip)
.LBB6_4:
.Ltmp2:
	leaq	32(%rsp), %rdi
	movq	%rsp, %rsi
	callq	*_RNvXsa_NtCs2AWtUsOyxgP_3std3envNtB5_4ArgsNtNtNtNtCs4NRVxsYgnAr_4core4iter6traits8iterator8Iterator4next@GOTPCREL(%rip)
.Ltmp3:
	movq	32(%rsp), %r15
	cmpq	$-1, %r15
	je	.LBB6_7
	movq	40(%rsp), %r14
	movq	48(%rsp), %r13
	jmp	.LBB6_11
.LBB6_7:
	callq	*_RNvCs9wFQrvczXsK_7___rustc35___rust_no_alloc_shim_is_unstable_v2@GOTPCREL(%rip)
	movl	$67, %r13d
	movl	$67, %edi
	movl	$1, %esi
	callq	*_RNvCs9wFQrvczXsK_7___rustc12___rust_alloc@GOTPCREL(%rip)
	testq	%rax, %rax
	je	.LBB6_8
	movq	%rax, %r14
	movups	.Lanon.c559f973accb09ee9d4e95a4ca8552cc.5+48(%rip), %xmm0
	movups	%xmm0, 48(%rax)
	movups	.Lanon.c559f973accb09ee9d4e95a4ca8552cc.5+32(%rip), %xmm0
	movups	%xmm0, 32(%rax)
	movups	.Lanon.c559f973accb09ee9d4e95a4ca8552cc.5+16(%rip), %xmm0
	movups	%xmm0, 16(%rax)
	movups	.Lanon.c559f973accb09ee9d4e95a4ca8552cc.5(%rip), %xmm0
	movups	%xmm0, (%rax)
	movl	$1818845556, 63(%rax)
	movl	$67, %r15d
.LBB6_11:
	movq	8(%rsp), %rbp
	movq	24(%rsp), %rcx
	movq	%rcx, %rax
	subq	%rbp, %rax
	movabsq	$-6148914691236517205, %rdx
	mulq	%rdx
	cmpq	%rbp, %rcx
	je	.LBB6_16
	movq	%rdx, %r12
	shrq	$4, %r12
	addq	$8, %rbp
	movq	_RNvCs9wFQrvczXsK_7___rustc14___rust_dealloc@GOTPCREL(%rip), %rbx
	jmp	.LBB6_13
	.p2align	4
.LBB6_15:
	addq	$24, %rbp
	decq	%r12
	je	.LBB6_16
.LBB6_13:
	movq	-8(%rbp), %rsi
	testq	%rsi, %rsi
	je	.LBB6_15
	movq	(%rbp), %rdi
	movl	$1, %edx
	callq	*%rbx
	jmp	.LBB6_15
.LBB6_16:
	movq	16(%rsp), %rax
	testq	%rax, %rax
	je	.LBB6_18
	movq	(%rsp), %rdi
	shlq	$3, %rax
	leaq	(%rax,%rax,2), %rsi
	movl	$8, %edx
	callq	*_RNvCs9wFQrvczXsK_7___rustc14___rust_dealloc@GOTPCREL(%rip)
.LBB6_18:
	movq	%r14, (%rsp)
	movq	%r13, 8(%rsp)
	movq	%rsp, %rax
	#APP
	#NO_APP
	movq	(%rsp), %rdi
	movq	8(%rsp), %rsi
.Ltmp4:
	callq	_RNvCseXDeBKE4kK2_15coverage_events8checksum
.Ltmp5:
	leaq	32(%rsp), %rcx
	movq	%rax, 32(%rsp)
	movq	%rcx, (%rsp)
	movq	_RNvXsi_NtNtNtCs4NRVxsYgnAr_4core3fmt3num3impjNtB9_7Display3fmt@GOTPCREL(%rip), %rax
	movq	%rax, 8(%rsp)
.Ltmp6:
	leaq	.Lanon.c559f973accb09ee9d4e95a4ca8552cc.6(%rip), %rdi
	movq	%rsp, %rsi
	callq	*_RNvNtNtCs2AWtUsOyxgP_3std2io5stdio6__print@GOTPCREL(%rip)
.Ltmp7:
	testq	%r15, %r15
	je	.LBB6_22
	movl	$1, %edx
	movq	%r14, %rdi
	movq	%r15, %rsi
	callq	*_RNvCs9wFQrvczXsK_7___rustc14___rust_dealloc@GOTPCREL(%rip)
.LBB6_22:
	addq	$56, %rsp
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
.LBB6_8:
	.cfi_def_cfa_offset 112
.Ltmp9:
	movl	$1, %edi
	movl	$67, %esi
	callq	*_RNvNtCscdodAO9FK5_5alloc7raw_vec12handle_error@GOTPCREL(%rip)
.Ltmp10:
	ud2
.LBB6_23:
.Ltmp8:
	movq	%rax, %rbx
	testq	%r15, %r15
	je	.LBB6_26
	movl	$1, %edx
	movq	%r14, %rdi
	movq	%r15, %rsi
	callq	*_RNvCs9wFQrvczXsK_7___rustc14___rust_dealloc@GOTPCREL(%rip)
	movq	%rbx, %rdi
	callq	_Unwind_Resume@PLT
.LBB6_25:
.Ltmp11:
	movq	%rax, %rbx
	movq	%rsp, %rdi
	callq	_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtCs2AWtUsOyxgP_3std3env4ArgsECseXDeBKE4kK2_15coverage_events
.LBB6_26:
	movq	%rbx, %rdi
	callq	_Unwind_Resume@PLT
.Lfunc_end6:
	.size	_RNvCseXDeBKE4kK2_15coverage_events4main, .Lfunc_end6-_RNvCseXDeBKE4kK2_15coverage_events4main
	.cfi_endproc
	.section	.gcc_except_table._RNvCseXDeBKE4kK2_15coverage_events4main,"a",@progbits
	.p2align	2, 0x0
GCC_except_table6:
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
	.uleb128 .Ltmp3-.Ltmp0
	.uleb128 .Ltmp11-.Lfunc_begin0
	.byte	0
	.uleb128 .Ltmp3-.Lfunc_begin0
	.uleb128 .Ltmp4-.Ltmp3
	.byte	0
	.byte	0
	.uleb128 .Ltmp4-.Lfunc_begin0
	.uleb128 .Ltmp7-.Ltmp4
	.uleb128 .Ltmp8-.Lfunc_begin0
	.byte	0
	.uleb128 .Ltmp9-.Lfunc_begin0
	.uleb128 .Ltmp10-.Ltmp9
	.uleb128 .Ltmp11-.Lfunc_begin0
	.byte	0
	.uleb128 .Ltmp10-.Lfunc_begin0
	.uleb128 .Lfunc_end6-.Ltmp10
	.byte	0
	.byte	0
.Lcst_end0:
	.p2align	2, 0x0

	.section	.rodata.cst16,"aM",@progbits,16
	.p2align	4, 0x0
.LCPI7_0:
	.zero	16,129
.LCPI7_1:
	.zero	16,160
.LCPI7_2:
	.zero	16,10
.LCPI7_3:
	.zero	16,13
.LCPI7_4:
	.zero	16,191
.LCPI7_5:
	.zero	16,32
	.section	.text._RNvCseXDeBKE4kK2_15coverage_events8checksum,"ax",@progbits
	.p2align	4
	.type	_RNvCseXDeBKE4kK2_15coverage_events8checksum,@function
_RNvCseXDeBKE4kK2_15coverage_events8checksum:
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
	subq	$40, %rsp
	.cfi_def_cfa_offset 96
	.cfi_offset %rbx, -56
	.cfi_offset %r12, -48
	.cfi_offset %r13, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	.cfi_offset %rbp, -16
	movq	%rsi, %rbx
	movq	%rdi, %r14
	movq	$0, (%rsp)
	movq	%rsp, %rax
	movq	%rax, 8(%rsp)
	movl	%ebx, %r12d
	andl	$15, %r12d
	movq	%rsi, %r15
	andq	$-16, %r15
	je	.LBB7_3
	xorl	%r13d, %r13d
	leaq	8(%rsp), %rbp
	.p2align	4
.LBB7_2:
	movdqu	(%r14,%r13), %xmm0
	movdqa	%xmm0, %xmm1
	paddb	.LCPI7_0(%rip), %xmm1
	movdqa	%xmm1, %xmm2
	pminub	.LCPI7_1(%rip), %xmm2
	pcmpeqb	%xmm1, %xmm2
	movdqa	%xmm0, %xmm1
	pcmpeqb	.LCPI7_2(%rip), %xmm1
	movdqa	%xmm0, %xmm3
	pcmpeqb	.LCPI7_3(%rip), %xmm3
	por	%xmm1, %xmm3
	pandn	%xmm2, %xmm3
	pcmpgtb	.LCPI7_4(%rip), %xmm0
	pand	%xmm3, %xmm0
	pmovmskb	%xmm0, %ecx
	movq	%r14, %rdi
	movq	%rbx, %rsi
	movq	%r13, %rdx
	movq	%rbp, %r8
	callq	_RINvCsh3jZH8iL7E3_26gpui_coverage_events_spike4emitNtNtCs4NRVxsYgnAr_4core7convert10InfallibleNCNvCseXDeBKE4kK2_15coverage_events8checksum0EB1y_
	addq	$16, %r13
	cmpq	%r13, %r15
	jne	.LBB7_2
.LBB7_3:
	testq	%r12, %r12
	je	.LBB7_5
	movabsq	$9223372036854775792, %rsi
	andq	%rbx, %rsi
	addq	%r14, %rsi
	movaps	.LCPI7_5(%rip), %xmm0
	movaps	%xmm0, 16(%rsp)
	leaq	16(%rsp), %rdi
	movq	%r12, %rdx
	callq	*memcpy@GOTPCREL(%rip)
	movdqa	16(%rsp), %xmm0
	movdqa	.LCPI7_0(%rip), %xmm1
	paddb	%xmm0, %xmm1
	movdqa	.LCPI7_1(%rip), %xmm2
	pminub	%xmm1, %xmm2
	pcmpeqb	%xmm1, %xmm2
	movdqa	.LCPI7_2(%rip), %xmm1
	pcmpeqb	%xmm0, %xmm1
	movdqa	.LCPI7_3(%rip), %xmm3
	pcmpeqb	%xmm0, %xmm3
	por	%xmm1, %xmm3
	pandn	%xmm2, %xmm3
	pcmpgtb	.LCPI7_4(%rip), %xmm0
	pand	%xmm3, %xmm0
	pmovmskb	%xmm0, %ecx
	leaq	8(%rsp), %r8
	movq	%r14, %rdi
	movq	%rbx, %rsi
	movq	%r15, %rdx
	callq	_RINvCsh3jZH8iL7E3_26gpui_coverage_events_spike4emitNtNtCs4NRVxsYgnAr_4core7convert10InfallibleNCNvCseXDeBKE4kK2_15coverage_events8checksum0EB1y_
.LBB7_5:
	movq	(%rsp), %rax
	addq	$40, %rsp
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
.Lfunc_end7:
	.size	_RNvCseXDeBKE4kK2_15coverage_events8checksum, .Lfunc_end7-_RNvCseXDeBKE4kK2_15coverage_events8checksum
	.cfi_endproc

	.section	.text.main,"ax",@progbits
	.globl	main
	.p2align	4
	.type	main,@function
main:
	.cfi_startproc
	pushq	%rax
	.cfi_def_cfa_offset 16
	movq	%rsi, %rcx
	movslq	%edi, %rdx
	leaq	_RNvCseXDeBKE4kK2_15coverage_events4main(%rip), %rax
	movq	%rax, (%rsp)
	leaq	.Lanon.c559f973accb09ee9d4e95a4ca8552cc.4(%rip), %rsi
	movq	%rsp, %rdi
	xorl	%r8d, %r8d
	callq	*_RNvNtCs2AWtUsOyxgP_3std2rt19lang_start_internal@GOTPCREL(%rip)
	popq	%rcx
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end8:
	.size	main, .Lfunc_end8-main
	.cfi_endproc

	.type	.Lanon.c559f973accb09ee9d4e95a4ca8552cc.0,@object
	.section	.rodata.str1.1,"aMS",@progbits,1
.Lanon.c559f973accb09ee9d4e95a4ca8552cc.0:
	.asciz	"src/lib.rs"
	.size	.Lanon.c559f973accb09ee9d4e95a4ca8552cc.0, 11

	.type	.Lanon.c559f973accb09ee9d4e95a4ca8552cc.1,@object
	.section	.data.rel.ro..Lanon.c559f973accb09ee9d4e95a4ca8552cc.1,"aw",@progbits
	.p2align	3, 0x0
.Lanon.c559f973accb09ee9d4e95a4ca8552cc.1:
	.quad	.Lanon.c559f973accb09ee9d4e95a4ca8552cc.0
	.asciz	"\n\000\000\000\000\000\000\000E\000\000\000\035\000\000"
	.size	.Lanon.c559f973accb09ee9d4e95a4ca8552cc.1, 24

	.type	.Lanon.c559f973accb09ee9d4e95a4ca8552cc.2,@object
	.section	.rodata..Lanon.c559f973accb09ee9d4e95a4ca8552cc.2,"a",@progbits
.Lanon.c559f973accb09ee9d4e95a4ca8552cc.2:
	.ascii	"nonempty coverage event"
	.size	.Lanon.c559f973accb09ee9d4e95a4ca8552cc.2, 23

	.type	.Lanon.c559f973accb09ee9d4e95a4ca8552cc.3,@object
	.section	.data.rel.ro..Lanon.c559f973accb09ee9d4e95a4ca8552cc.3,"aw",@progbits
	.p2align	3, 0x0
.Lanon.c559f973accb09ee9d4e95a4ca8552cc.3:
	.quad	.Lanon.c559f973accb09ee9d4e95a4ca8552cc.0
	.asciz	"\n\000\000\000\000\000\000\000H\000\000\000\016\000\000"
	.size	.Lanon.c559f973accb09ee9d4e95a4ca8552cc.3, 24

	.type	.Lanon.c559f973accb09ee9d4e95a4ca8552cc.4,@object
	.section	.data.rel.ro..Lanon.c559f973accb09ee9d4e95a4ca8552cc.4,"aw",@progbits
	.p2align	3, 0x0
.Lanon.c559f973accb09ee9d4e95a4ca8552cc.4:
	.asciz	"\000\000\000\000\000\000\000\000\b\000\000\000\000\000\000\000\b\000\000\000\000\000\000"
	.quad	_RNSNvYNCINvNtCs2AWtUsOyxgP_3std2rt10lang_startuE0INtNtNtCs4NRVxsYgnAr_4core3ops8function6FnOnceuE9call_once6vtableCseXDeBKE4kK2_15coverage_events
	.quad	_RNCINvNtCs2AWtUsOyxgP_3std2rt10lang_startuE0CseXDeBKE4kK2_15coverage_events
	.quad	_RNCINvNtCs2AWtUsOyxgP_3std2rt10lang_startuE0CseXDeBKE4kK2_15coverage_events
	.size	.Lanon.c559f973accb09ee9d4e95a4ca8552cc.4, 48

	.type	.Lanon.c559f973accb09ee9d4e95a4ca8552cc.5,@object
	.section	.rodata..Lanon.c559f973accb09ee9d4e95a4ca8552cc.5,"a",@progbits
.Lanon.c559f973accb09ee9d4e95a4ca8552cc.5:
	.ascii	"ASCII \303\251 \327\220\327\221\327\222 \330\247\331\204\330\271\330\261\330\250\331\212\330\251 \340\244\271\340\244\277\340\244\250\340\245\215\340\244\246\340\245\200 \360\237\221\251\342\200\215\360\237\222\273\t tail"
	.size	.Lanon.c559f973accb09ee9d4e95a4ca8552cc.5, 67

	.type	.Lanon.c559f973accb09ee9d4e95a4ca8552cc.6,@object
	.section	.rodata.str1.1,"aMS",@progbits,1
.Lanon.c559f973accb09ee9d4e95a4ca8552cc.6:
	.asciz	"\300\001\n"
	.size	.Lanon.c559f973accb09ee9d4e95a4ca8552cc.6, 4

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
