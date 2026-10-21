	.section	.text._RNvCs9Yg1K7nzAV4_24rounded_property_codegen10read_style,"ax",@progbits
	.p2align	4
	.type	_RNvCs9Yg1K7nzAV4_24rounded_property_codegen10read_style,@function
_RNvCs9Yg1K7nzAV4_24rounded_property_codegen10read_style:
	.file	112 "/root/gpui-rounded-rectangles/reactivity" "crates/gpui/examples/rounded_property_codegen.rs"
	pushq	%r14
	pushq	%rbx
	subq	$56, %rsp
	testq	%rsi, %rsi
	je	.LBB211_1
	cmpb	$1, 2382(%rsi)
	jne	.LBB211_4
	movq	$14, (%rdi)
	addq	$56, %rsp
	popq	%rbx
	popq	%r14
	retq
.LBB211_1:
	movq	$13, (%rdi)
	movq	$0, 8(%rdi)
	addq	$56, %rsp
	popq	%rbx
	popq	%r14
	retq
.LBB211_4:
	movq	%rdi, %rbx
	movq	%rsp, %rdi
	movq	%rsi, %r14
	callq	_RNvMsp_NtCsere7gZGiCG7_4gpui7runtimeINtB5_7RuntimeNtCs9Yg1K7nzAV4_24rounded_property_codegen4CardE7resolveBO_
	movq	(%rsp), %rax
	movq	8(%rsp), %rcx
	cmpq	$-2, %rax
	jne	.LBB211_5
	movq	1952(%r14), %rdx
	testq	%rdx, %rdx
	je	.LBB211_15
	movq	%r14, %rax
	movq	1960(%r14), %rsi
.LBB211_8:
	movzwl	186(%rdx), %r8d
	movl	%r8d, %r9d
	shll	$3, %r9d
	movq	$-1, %rdi
	.p2align	4
.LBB211_9:
	testq	%r9, %r9
	je	.LBB211_10
	cmpq	16(%rdx,%rdi,8), %rcx
	seta	%r10b
	sbbb	$0, %r10b
	incq	%rdi
	addq	$-8, %r9
	cmpb	$1, %r10b
	je	.LBB211_9
	movzbl	%r10b, %r8d
	testl	%r8d, %r8d
	je	.LBB211_16
	jmp	.LBB211_13
.LBB211_10:
	movq	%r8, %rdi
.LBB211_13:
	subq	$1, %rsi
	jb	.LBB211_15
	movq	192(%rdx,%rdi,8), %rdx
	jmp	.LBB211_8
.LBB211_5:
	movq	48(%rsp), %rdx
	movq	%rdx, 48(%rbx)
	movups	16(%rsp), %xmm0
	movups	32(%rsp), %xmm1
	movups	%xmm1, 32(%rbx)
	movups	%xmm0, 16(%rbx)
	movq	%rax, (%rbx)
	movq	%rcx, 8(%rbx)
	addq	$56, %rsp
	popq	%rbx
	popq	%r14
	retq
.LBB211_16:
	movq	552(%rax), %rcx
	testq	%rcx, %rcx
	je	.LBB211_17
	movq	96(%rdx,%rdi,8), %rdi
	cmpl	$1, %ecx
	jne	.LBB211_21
	movq	576(%rax), %rsi
	movl	$568, %ecx
	cmpq	%rsi, %rdi
	jb	.LBB211_23
	leaq	.Lanon.bf080e38aafd3eacf4eb7123520eb4e9.94(%rip), %rdx
	callq	*_RNvNtCs4NRVxsYgnAr_4core9panicking18panic_bounds_check@GOTPCREL(%rip)
.LBB211_17:
	leaq	.Lanon.bf080e38aafd3eacf4eb7123520eb4e9.92(%rip), %rdi
	jmp	.LBB211_24
.LBB211_21:
	movq	584(%rax), %rsi
	cmpq	%rsi, %rdi
	jae	.LBB211_26
	movq	568(%rax), %rsi
	movq	576(%rax), %rcx
	movzbl	(%rcx,%rdi), %edi
	movl	$560, %ecx
	cmpq	%rdi, %rsi
	jbe	.LBB211_27
.LBB211_23:
	imulq	$88, %rdi, %rdi
	addq	(%rax,%rcx), %rdi
.LBB211_24:
	movq	_RNvNtCsere7gZGiCG7_4gpui8property8GAP_DECL@GOTPCREL(%rip), %rax
	callq	*(%rax)
	movss	%xmm0, 8(%rbx)
	movq	$-2, (%rbx)
	addq	$56, %rsp
	popq	%rbx
	popq	%r14
	retq
.LBB211_15:
	leaq	.Lanon.bf080e38aafd3eacf4eb7123520eb4e9.219(%rip), %rdi
	leaq	.Lanon.bf080e38aafd3eacf4eb7123520eb4e9.18(%rip), %rdx
	movl	$22, %esi
	callq	*_RNvNtCs4NRVxsYgnAr_4core6option13expect_failed@GOTPCREL(%rip)
.LBB211_26:
	leaq	.Lanon.bf080e38aafd3eacf4eb7123520eb4e9.95(%rip), %rdx
	callq	*_RNvNtCs4NRVxsYgnAr_4core9panicking18panic_bounds_check@GOTPCREL(%rip)
.LBB211_27:
	leaq	.Lanon.bf080e38aafd3eacf4eb7123520eb4e9.96(%rip), %rdx
	callq	*_RNvNtCs4NRVxsYgnAr_4core9panicking18panic_bounds_check@GOTPCREL(%rip)
	.size	_RNvCs9Yg1K7nzAV4_24rounded_property_codegen10read_style, .Lfunc_end211-_RNvCs9Yg1K7nzAV4_24rounded_property_codegen10read_style
	.section	.text._RNvCs9Yg1K7nzAV4_24rounded_property_codegen13edit_geometry,"ax",@progbits
	.p2align	4
	.type	_RNvCs9Yg1K7nzAV4_24rounded_property_codegen13edit_geometry,@function
_RNvCs9Yg1K7nzAV4_24rounded_property_codegen13edit_geometry:
	pushq	%rbp
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$552, %rsp
	movl	$1, 452(%rsp)
	movss	%xmm0, 456(%rsp)
	testq	%rsi, %rsi
	je	.LBB212_3
	cmpb	$0, 2382(%rsi)
	je	.LBB212_4
	movq	$14, (%rdi)
	jmp	.LBB212_24
.LBB212_3:
	movq	$13, (%rdi)
	movq	$0, 8(%rdi)
	jmp	.LBB212_24
.LBB212_4:
	movss	%xmm0, 16(%rsp)
	movq	%rdi, 120(%rsp)
	leaq	496(%rsp), %rdi
	movq	%rsi, 88(%rsp)
	callq	_RNvMsp_NtCsere7gZGiCG7_4gpui7runtimeINtB5_7RuntimeNtCs9Yg1K7nzAV4_24rounded_property_codegen4CardE7resolveBO_
	movq	496(%rsp), %rax
	movq	504(%rsp), %r14
	cmpq	$-2, %rax
	jne	.LBB212_7
	movq	88(%rsp), %rax
	movq	2128(%rax), %r13
	incq	%r13
	jne	.LBB212_8
	movq	120(%rsp), %rbx
	movq	$30, (%rbx)
	movq	%r13, 8(%rbx)
	jmp	.LBB212_24
.LBB212_7:
	movq	544(%rsp), %rcx
	movq	120(%rsp), %rbx
	movq	%rcx, 48(%rbx)
	movups	512(%rsp), %xmm0
	movups	528(%rsp), %xmm1
	movups	%xmm1, 32(%rbx)
	movups	%xmm0, 16(%rbx)
	movq	%rax, (%rbx)
	movq	%r14, 8(%rbx)
	jmp	.LBB212_24
.LBB212_8:
	leaq	456(%rsp), %rdi
	movq	_RNvNtCsere7gZGiCG7_4gpui8property11RADIUS_DECL@GOTPCREL(%rip), %r12
	callq	*16(%r12)
	cmpb	$-1, %al
	je	.LBB212_10
	movzwl	48(%r12), %ecx
	andl	$16777215, %eax
	shlq	$16, %rax
	orq	%rcx, %rax
	movq	120(%rsp), %rdi
	movq	%rax, %rsi
	jmp	.LBB212_23
.LBB212_10:
	movq	88(%rsp), %rax
	movq	2048(%rax), %r15
	testq	%r15, %r15
	je	.LBB212_13
	movq	240(%r15), %rdi
	testq	%rdi, %rdi
	je	.LBB212_16
	movq	%rax, %r15
	movq	%r14, %rsi
	callq	*_RNvMNtNtCsere7gZGiCG7_4gpui7runtime8geometryNtB2_8Geometry3get@GOTPCREL(%rip)
	movq	2048(%r15), %r15
	movss	%xmm0, 128(%rsp)
	testq	%r15, %r15
	jne	.LBB212_17
	jmp	.LBB212_14
.LBB212_13:
	movl	$0, 128(%rsp)
	xorps	%xmm0, %xmm0
.LBB212_14:
	movss	%xmm0, 8(%rsp)
	callq	*_RNvCs9wFQrvczXsK_7___rustc35___rust_no_alloc_shim_is_unstable_v2@GOTPCREL(%rip)
	movl	$248, %edi
	movl	$8, %esi
	callq	*_RNvCs9wFQrvczXsK_7___rustc12___rust_alloc@GOTPCREL(%rip)
	testq	%rax, %rax
	je	.LBB212_183
	movq	%rax, %r15
	xorps	%xmm0, %xmm0
	movups	%xmm0, 40(%rax)
	movups	%xmm0, 64(%rax)
	movups	%xmm0, 88(%rax)
	movups	%xmm0, 16(%rax)
	movq	$0, (%rax)
	movq	$8, 8(%rax)
	movq	$8, 32(%rax)
	movq	$8, 56(%rax)
	movq	$8, 80(%rax)
	movq	$8, 104(%rax)
	movq	$0, 112(%rax)
	movq	$-1, 120(%rax)
	movq	$0, 216(%rax)
	movups	%xmm0, 232(%rax)
	movq	88(%rsp), %rax
	movq	%r15, 2048(%rax)
	movss	8(%rsp), %xmm0
	jmp	.LBB212_17
.LBB212_16:
	movl	$0, 128(%rsp)
	xorps	%xmm0, %xmm0
.LBB212_17:
	movq	240(%r15), %rbx
	testq	%rbx, %rbx
	movss	%xmm0, 8(%rsp)
	jne	.LBB212_20
	callq	*_RNvCs9wFQrvczXsK_7___rustc35___rust_no_alloc_shim_is_unstable_v2@GOTPCREL(%rip)
	movl	$96, %edi
	movl	$8, %esi
	callq	*_RNvCs9wFQrvczXsK_7___rustc12___rust_alloc@GOTPCREL(%rip)
	testq	%rax, %rax
	je	.LBB212_201
	movq	%rax, %rbx
	xorps	%xmm0, %xmm0
	movups	%xmm0, 16(%rax)
	movq	$0, (%rax)
	movq	$8, 8(%rax)
	movq	$8, 32(%rax)
	movq	$0, 40(%rax)
	movq	$-1, 48(%rax)
	movq	$0, 72(%rax)
	movq	$0, 88(%rax)
	movq	%rax, 240(%r15)
	movss	8(%rsp), %xmm0
.LBB212_20:
	movzwl	48(%r12), %ebp
	movss	%xmm0, 132(%rsp)
	movss	16(%rsp), %xmm1
	movss	%xmm1, 160(%rsp)
	leaq	160(%rsp), %rdi
	callq	*16(%r12)
	cmpb	$-1, %al
	je	.LBB212_25
	movzwl	48(%r12), %ecx
	movl	%eax, %edx
	andl	$16776960, %edx
	shrl	$8, %edx
	shlq	$24, %rdx
	movzbl	%al, %esi
	shll	$16, %esi
	orq	%rdx, %rsi
	orq	%rsi, %rcx
.LBB212_22:
	movq	120(%rsp), %rdi
	movzwl	%cx, %eax
	andq	$-65536, %rsi
	orq	%rax, %rsi
.LBB212_23:
	callq	*_RNvXs6_NtCsere7gZGiCG7_4gpui7runtimeNtB5_5ErrorINtNtCs4NRVxsYgnAr_4core7convert4FromNtNtB7_8property13PropertyErrorE4from@GOTPCREL(%rip)
.LBB212_24:
	addq	$552, %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	retq
.LBB212_25:
	leaq	132(%rsp), %rdi
	callq	*(%r12)
	movss	%xmm0, 272(%rsp)
	leaq	272(%rsp), %rdi
	leaq	160(%rsp), %rsi
	callq	*24(%r12)
	testb	%al, %al
	jne	.LBB212_27
	leaq	132(%rsp), %rdi
	movss	16(%rsp), %xmm0
	callq	*8(%r12)
.LBB212_27:
	leaq	460(%rsp), %rdi
	leaq	132(%rsp), %rdx
	movl	%ebp, %esi
	callq	*_RNvXs1_NtCsere7gZGiCG7_4gpui8propertyNtB5_13GeometryStyleNtNtB5_6sealed6Domain10get_erased@GOTPCREL(%rip)
	movzbl	460(%rsp), %ecx
	cmpb	$-1, %cl
	je	.LBB212_37
	movq	%r15, 96(%rsp)
	movzbl	461(%rsp), %edx
	movl	462(%rsp), %eax
	movq	%rbx, %rsi
	movzwl	466(%rsp), %ebx
	shlq	$32, %rbx
	orq	%rax, %rbx
	leaq	468(%rsp), %r15
	movl	484(%rsp), %eax
	movl	%eax, 224(%rsp)
	movups	468(%rsp), %xmm0
	movaps	%xmm0, 208(%rsp)
	movq	72(%rsi), %rdi
	movq	%rsi, 48(%rsp)
	movq	80(%rsi), %r12
	movss	8(%rsp), %xmm1
	movaps	%xmm1, %xmm0
	testq	%rdi, %rdi
	movq	%rdi, 72(%rsp)
	movb	%cl, 16(%rsp)
	movb	%dl, 56(%rsp)
	je	.LBB212_40
	movq	%r12, %rax
	movq	%rdi, %rcx
.LBB212_30:
	movzwl	450(%rcx), %esi
	leaq	-32(%rcx), %rdi
	movl	%esi, %r8d
	shll	$3, %r8d
	movq	$-1, %rdx
.LBB212_31:
	testq	%r8, %r8
	je	.LBB212_34
	cmpq	368(%rcx,%rdx,8), %r14
	seta	%r9b
	sbbb	$0, %r9b
	addq	$32, %rdi
	incq	%rdx
	addq	$-8, %r8
	cmpb	$1, %r9b
	je	.LBB212_31
	movzbl	%r9b, %esi
	testl	%esi, %esi
	jne	.LBB212_35
	jmp	.LBB212_38
.LBB212_34:
	movq	%rsi, %rdx
.LBB212_35:
	subq	$1, %rax
	jb	.LBB212_76
	movq	456(%rcx,%rdx,8), %rcx
	jmp	.LBB212_30
.LBB212_37:
	movl	462(%rsp), %eax
	movzwl	466(%rsp), %esi
	shlq	$32, %rsi
	orq	%rax, %rsi
	movq	%rsi, %rcx
	jmp	.LBB212_22
.LBB212_38:
	movss	24(%rdi), %xmm0
	movl	%ebp, %esi
	callq	_RINvNtCsere7gZGiCG7_4gpui8property12apply_exceptNtB2_13GeometryStyleECs9Yg1K7nzAV4_24rounded_property_codegen
.LBB212_39:
	movzbl	16(%rsp), %ecx
	movzbl	56(%rsp), %edx
.LBB212_40:
	movq	%r12, 32(%rsp)
	movq	%r13, 440(%rsp)
	movss	%xmm0, 204(%rsp)
	movb	%cl, 272(%rsp)
	movb	%dl, 273(%rsp)
	movq	%rbx, %r12
	shrq	$32, %r12
	movw	%r12w, 278(%rsp)
	movl	%ebx, 274(%rsp)
	movups	(%r15), %xmm0
	movups	%xmm0, 280(%rsp)
	movl	16(%r15), %eax
	movl	%eax, 296(%rsp)
	leaq	204(%rsp), %rsi
	leaq	272(%rsp), %rdx
	movl	%ebp, %edi
	callq	*_RNvXs1_NtCsere7gZGiCG7_4gpui8propertyNtB5_13GeometryStyleNtNtB5_6sealed6Domain10set_erased@GOTPCREL(%rip)
	movq	%rax, %rsi
	testw	%si, %si
	je	.LBB212_42
	movabsq	$281474976710655, %rax
	andq	%rax, %rsi
	movq	%rsi, %rcx
	jmp	.LBB212_22
.LBB212_42:
	movq	%r12, 80(%rsp)
	movl	%ebp, 28(%rsp)
	movq	72(%rsp), %rcx
	testq	%rcx, %rcx
	movq	%rbx, 152(%rsp)
	je	.LBB212_52
	movq	32(%rsp), %rax
	movq	%rcx, %rbx
	movl	28(%rsp), %r13d
	movq	80(%rsp), %rdi
.LBB212_44:
	leaq	360(%rbx), %r8
	movzwl	450(%rbx), %r15d
	movl	%r15d, %edx
	shll	$5, %edx
	movl	$32, %ecx
	movq	$-1, %r12
.LBB212_45:
	leaq	(%rdx,%rcx), %rsi
	cmpq	$32, %rsi
	je	.LBB212_48
	cmpq	368(%rbx,%r12,8), %r14
	seta	%sil
	sbbb	$0, %sil
	addq	$-32, %rcx
	incq	%r12
	cmpb	$1, %sil
	je	.LBB212_45
	movzbl	%sil, %edx
	testl	%edx, %edx
	jne	.LBB212_49
	jmp	.LBB212_51
.LBB212_48:
	movq	%r15, %r12
.LBB212_49:
	subq	$1, %rax
	jb	.LBB212_77
	movq	456(%rbx,%r12,8), %rbx
	jmp	.LBB212_44
.LBB212_51:
	subq	%rcx, %rbx
	movq	%rbx, %r12
	movq	96(%rsp), %r15
	jmp	.LBB212_55
.LBB212_52:
	movss	8(%rsp), %xmm0
	movss	%xmm0, 384(%rsp)
	movq	$0, 360(%rsp)
	movq	$0, 376(%rsp)
	callq	*_RNvCs9wFQrvczXsK_7___rustc35___rust_no_alloc_shim_is_unstable_v2@GOTPCREL(%rip)
	movl	$456, %edi
	movl	$8, %esi
	callq	*_RNvCs9wFQrvczXsK_7___rustc12___rust_alloc@GOTPCREL(%rip)
	testq	%rax, %rax
	movq	96(%rsp), %r15
	movl	28(%rsp), %r13d
	je	.LBB212_203
	movq	$0, 352(%rax)
	movq	48(%rsp), %rcx
	movq	%rax, 72(%rcx)
	movq	$0, 80(%rcx)
	movw	$1, 450(%rax)
	movq	%r14, 360(%rax)
	movups	360(%rsp), %xmm0
	movups	376(%rsp), %xmm1
	movups	%xmm0, (%rax)
	movups	%xmm1, 16(%rax)
	xorl	%r12d, %r12d
	movq	80(%rsp), %rdi
.LBB212_54:
	incq	88(%rcx)
	shlq	$5, %r12
	addq	%rax, %r12
.LBB212_55:
	movl	224(%rsp), %eax
	movl	%eax, 256(%rsp)
	movaps	208(%rsp), %xmm0
	movaps	%xmm0, 240(%rsp)
	movq	(%r12), %r8
	testq	%r8, %r8
	je	.LBB212_65
	movq	8(%r12), %r9
	movq	%r9, %rax
	movq	%r8, %rbx
.LBB212_57:
	leaq	320(%rbx), %rbp
	movzwl	318(%rbx), %r10d
	leaq	(%r10,%r10,8), %rcx
	leaq	(%rcx,%rcx,2), %rdx
	addq	%r10, %rdx
	movq	$-1, %r15
	xorl	%ecx, %ecx
.LBB212_58:
	cmpq	%rcx, %rdx
	je	.LBB212_61
	cmpw	322(%rbx,%r15,2), %r13w
	seta	%sil
	sbbb	$0, %sil
	addq	$28, %rcx
	incq	%r15
	cmpb	$1, %sil
	je	.LBB212_58
	movzbl	%sil, %edx
	testl	%edx, %edx
	jne	.LBB212_62
	jmp	.LBB212_64
.LBB212_61:
	movq	%r10, %r15
.LBB212_62:
	subq	$1, %rax
	jb	.LBB212_80
	movq	344(%rbx,%r15,8), %rbx
	jmp	.LBB212_57
.LBB212_64:
	movzbl	16(%rsp), %eax
	movb	%al, -20(%rbx,%rcx)
	movzbl	56(%rsp), %eax
	movb	%al, -19(%rbx,%rcx)
	movq	152(%rsp), %rax
	movl	%eax, -18(%rbx,%rcx)
	movw	%di, -14(%rbx,%rcx)
	movaps	208(%rsp), %xmm0
	movups	%xmm0, -12(%rbx,%rcx)
	movl	224(%rsp), %eax
	movl	%eax, 4(%rbx,%rcx)
	movq	96(%rsp), %r15
	jmp	.LBB212_68
.LBB212_65:
	callq	*_RNvCs9wFQrvczXsK_7___rustc35___rust_no_alloc_shim_is_unstable_v2@GOTPCREL(%rip)
	movl	$344, %edi
	movl	$8, %esi
	callq	*_RNvCs9wFQrvczXsK_7___rustc12___rust_alloc@GOTPCREL(%rip)
	testq	%rax, %rax
	je	.LBB212_202
	movq	$0, (%rax)
	movq	%rax, (%r12)
	movq	$0, 8(%r12)
	movw	$1, 318(%rax)
	movw	%r13w, 320(%rax)
	movzbl	16(%rsp), %ecx
	movb	%cl, 8(%rax)
	movzbl	56(%rsp), %ecx
	movb	%cl, 9(%rax)
	movq	80(%rsp), %rcx
	movw	%cx, 14(%rax)
	movq	152(%rsp), %rcx
	movl	%ecx, 10(%rax)
	movaps	240(%rsp), %xmm0
	movups	%xmm0, 16(%rax)
	movl	256(%rsp), %ecx
	movl	%ecx, 32(%rax)
.LBB212_67:
	incq	16(%r12)
.LBB212_68:
	movq	440(%rsp), %r12
	movss	204(%rsp), %xmm0
	movss	%xmm0, 272(%rsp)
	movq	240(%r15), %rdi
	movq	%r14, %rsi
	callq	*_RNvMNtNtCsere7gZGiCG7_4gpui7runtime8geometryNtB2_8Geometry5store@GOTPCREL(%rip)
	movq	240(%r15), %rdi
	callq	*_RNvMNtNtCsere7gZGiCG7_4gpui7runtime8geometryNtB2_8Geometry6unused@GOTPCREL(%rip)
	testb	%al, %al
	movq	88(%rsp), %rax
	movq	_RNvNtCsere7gZGiCG7_4gpui8property11RADIUS_DECL@GOTPCREL(%rip), %r14
	je	.LBB212_71
	movq	2048(%rax), %rax
	movq	240(%rax), %rdi
	callq	_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtB4_6option6OptionINtNtCscdodAO9FK5_5alloc5boxed3BoxNtNtNtCsere7gZGiCG7_4gpui7runtime8geometry8GeometryEEECs9Yg1K7nzAV4_24rounded_property_codegen
	movq	88(%rsp), %rax
	movq	2048(%rax), %rcx
	movq	$0, 240(%rcx)
.LBB212_71:
	movq	%r12, 2128(%rax)
	incq	2272(%rax)
	leaq	128(%rsp), %rdi
	leaq	272(%rsp), %rsi
	callq	*24(%r14)
	movq	88(%rsp), %rsi
	xorb	$1, %al
	movzbl	%al, %eax
	movq	%rax, 2360(%rsi)
	orb	%al, 2379(%rsi)
	movq	2048(%rsi), %rdi
	testq	%rdi, %rdi
	je	.LBB212_75
	callq	*_RNvMs0_NtNtCsere7gZGiCG7_4gpui7runtime8metadataNtB5_8Metadata6unused@GOTPCREL(%rip)
	movq	88(%rsp), %rsi
	testb	%al, %al
	je	.LBB212_75
	movq	2048(%rsi), %rdi
	callq	_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtB4_6option6OptionINtNtCscdodAO9FK5_5alloc5boxed3BoxNtNtNtCsere7gZGiCG7_4gpui7runtime8metadata8MetadataEEECs9Yg1K7nzAV4_24rounded_property_codegen
	movq	88(%rsp), %rsi
	movq	$0, 2048(%rsi)
.LBB212_75:
	movq	120(%rsp), %rdi
	callq	_RNvMsp_NtCsere7gZGiCG7_4gpui7runtimeINtB5_7RuntimeNtCs9Yg1K7nzAV4_24rounded_property_codegen4CardE7presentBO_
	jmp	.LBB212_24
.LBB212_76:
	movaps	%xmm1, %xmm0
	jmp	.LBB212_39
.LBB212_77:
	movss	8(%rsp), %xmm0
	movss	%xmm0, 384(%rsp)
	movq	$0, 360(%rsp)
	movq	$0, 376(%rsp)
	cmpw	$10, %r15w
	jbe	.LBB212_83
	cmpq	$5, %r12
	jae	.LBB212_87
	movl	$4, %ebp
	movl	$0, 8(%rsp)
	jmp	.LBB212_99
.LBB212_80:
	movq	%r9, 64(%rsp)
	movq	%r8, 104(%rsp)
	cmpw	$11, %r10w
	jae	.LBB212_85
	movq	%r10, %r13
	leaq	(,%r15,2), %rsi
	addq	%rbp, %rsi
	subq	%r15, %r10
	jbe	.LBB212_92
	leaq	2(,%r15,2), %rdi
	addq	%rbp, %rdi
	movq	%r10, %rbp
	leal	(%r10,%r10), %edx
	callq	*memmove@GOTPCREL(%rip)
	movl	28(%rsp), %eax
	movw	%ax, 320(%rbx,%r15,2)
	movl	224(%rsp), %eax
	movl	%eax, 176(%rsp)
	movaps	208(%rsp), %xmm0
	movaps	%xmm0, 160(%rsp)
	leaq	(%r15,%r15,8), %rax
	leaq	(%rax,%rax,2), %rax
	addq	%r15, %rax
	leaq	(%rbx,%rax), %rsi
	addq	$8, %rsi
	leaq	(%rbx,%rax), %rdi
	addq	$36, %rdi
	leaq	(,%rbp,8), %rax
	addq	%rbp, %rax
	leaq	(%rax,%rax,2), %rdx
	addq	%rbp, %rdx
	callq	*memmove@GOTPCREL(%rip)
	jmp	.LBB212_93
.LBB212_83:
	leaq	(%r8,%r12,8), %rsi
	cmpq	%r12, %r15
	jbe	.LBB212_90
	leaq	1(%r12), %r13
	leaq	(%r8,%r12,8), %rdi
	addq	$8, %rdi
	movl	%r15d, %ebp
	subl	%r12d, %ebp
	leal	(,%rbp,8), %edx
	callq	*memmove@GOTPCREL(%rip)
	movq	%r14, 360(%rbx,%r12,8)
	movups	360(%rsp), %xmm0
	movups	376(%rsp), %xmm1
	movaps	%xmm1, 288(%rsp)
	movaps	%xmm0, 272(%rsp)
	movq	%r12, %rsi
	shlq	$5, %rsi
	addq	%rbx, %rsi
	shlq	$5, %r13
	addq	%rbx, %r13
	shll	$5, %ebp
	movq	%r13, %rdi
	movq	%rbp, %rdx
	callq	*memmove@GOTPCREL(%rip)
	jmp	.LBB212_91
.LBB212_85:
	cmpq	$5, %r15
	jae	.LBB212_94
	movl	$4, %r13d
	movl	$0, 48(%rsp)
	jmp	.LBB212_143
.LBB212_87:
	je	.LBB212_97
	cmpq	$6, %r12
	jne	.LBB212_98
	movl	$5, %ebp
	movb	$1, %al
	movl	%eax, 8(%rsp)
	xorl	%r12d, %r12d
	jmp	.LBB212_99
.LBB212_90:
	movq	%r14, (%rsi)
	movups	360(%rsp), %xmm0
	movups	376(%rsp), %xmm1
	movaps	%xmm1, 288(%rsp)
	movaps	%xmm0, 272(%rsp)
.LBB212_91:
	leal	1(%r15), %eax
	movq	%r12, %rcx
	shlq	$5, %rcx
	movaps	272(%rsp), %xmm0
	movaps	288(%rsp), %xmm1
	movups	%xmm1, 16(%rbx,%rcx)
	movups	%xmm0, (%rbx,%rcx)
	movw	%ax, 450(%rbx)
	movq	%rbx, %rax
	jmp	.LBB212_138
.LBB212_92:
	movl	28(%rsp), %eax
	movw	%ax, (%rsi)
	movl	224(%rsp), %eax
	movl	%eax, 176(%rsp)
	movaps	208(%rsp), %xmm0
	movaps	%xmm0, 160(%rsp)
.LBB212_93:
	incl	%r13d
	leaq	(%r15,%r15,8), %rax
	leaq	(%rax,%rax,2), %rax
	addq	%r15, %rax
	movzbl	16(%rsp), %ecx
	movb	%cl, 8(%rbx,%rax)
	movzbl	56(%rsp), %ecx
	movb	%cl, 9(%rbx,%rax)
	movq	80(%rsp), %rcx
	movw	%cx, 14(%rbx,%rax)
	movq	152(%rsp), %rcx
	movl	%ecx, 10(%rbx,%rax)
	movaps	160(%rsp), %xmm0
	movups	%xmm0, 16(%rbx,%rax)
	movl	176(%rsp), %ecx
	movl	%ecx, 32(%rbx,%rax)
	movw	%r13w, 318(%rbx)
	movq	96(%rsp), %r15
	jmp	.LBB212_67
.LBB212_94:
	je	.LBB212_141
	cmpq	$6, %r15
	jne	.LBB212_142
	movl	$5, %r13d
	movb	$1, %al
	movl	%eax, 48(%rsp)
	xorl	%r15d, %r15d
	jmp	.LBB212_143
.LBB212_97:
	movl	$0, 8(%rsp)
	movq	%r12, %rbp
	jmp	.LBB212_99
.LBB212_98:
	addq	$-7, %r12
	movl	$6, %ebp
	movb	$1, %al
	movl	%eax, 8(%rsp)
.LBB212_99:
	callq	*_RNvCs9wFQrvczXsK_7___rustc35___rust_no_alloc_shim_is_unstable_v2@GOTPCREL(%rip)
	movl	$456, %edi
	movl	$8, %esi
	callq	*_RNvCs9wFQrvczXsK_7___rustc12___rust_alloc@GOTPCREL(%rip)
	testq	%rax, %rax
	je	.LBB212_214
	movq	%rax, %r13
	movq	$0, 352(%rax)
	movzwl	450(%rbx), %eax
	movq	%rbp, %r15
	movq	%rbp, %rcx
	notq	%rcx
	addq	%rax, %rcx
	movw	%cx, 450(%r13)
	movq	360(%rbx,%rbp,8), %rax
	movq	%rax, 104(%rsp)
	shlq	$5, %r15
	movups	(%rbx,%r15), %xmm0
	movups	16(%rbx,%r15), %xmm1
	movaps	%xmm1, 288(%rsp)
	movaps	%xmm0, 272(%rsp)
	movq	%rcx, %r8
	cmpq	$12, %rcx
	jae	.LBB212_212
	addq	%rbx, %r15
	movq	%rbp, 40(%rsp)
	leaq	1(%rbp), %rax
	movq	%rax, 64(%rsp)
	leaq	360(%rbx), %rax
	leaq	8(%rax,%rbp,8), %rsi
	leaq	360(%r13), %rdi
	movq	%r8, %rbp
	leaq	(,%r8,8), %rdx
	callq	*memcpy@GOTPCREL(%rip)
	movq	64(%rsp), %rsi
	shlq	$5, %rsi
	addq	%rbx, %rsi
	shlq	$5, %rbp
	movq	%r13, %rdi
	movq	%rbp, %rdx
	callq	*memcpy@GOTPCREL(%rip)
	movq	40(%rsp), %rax
	movw	%ax, 450(%rbx)
	movups	(%r15), %xmm0
	movups	16(%r15), %xmm1
	movaps	%xmm0, 160(%rsp)
	cmpb	$0, 8(%rsp)
	movq	%r13, %rax
	cmoveq	%rbx, %rax
	movaps	%xmm1, 176(%rsp)
	movzwl	450(%rax), %r15d
	movq	%rax, 192(%rsp)
	leaq	(%rax,%r12,8), %rsi
	addq	$360, %rsi
	cmpq	%r12, %r15
	jbe	.LBB212_103
	movq	192(%rsp), %rax
	addq	$360, %rax
	leaq	1(%r12), %rbp
	leaq	(%rax,%r12,8), %rdi
	addq	$8, %rdi
	movl	%r15d, %eax
	subl	%r12d, %eax
	movq	%rax, 8(%rsp)
	leal	(,%rax,8), %edx
	callq	*memmove@GOTPCREL(%rip)
	movq	192(%rsp), %rax
	movq	%r14, 360(%rax,%r12,8)
	movups	360(%rsp), %xmm0
	movups	376(%rsp), %xmm1
	movaps	%xmm1, 288(%rsp)
	movaps	%xmm0, 272(%rsp)
	movq	%r12, %rsi
	shlq	$5, %rsi
	addq	%rax, %rsi
	shlq	$5, %rbp
	addq	%rax, %rbp
	movq	8(%rsp), %rdx
	shll	$5, %edx
	movq	%rbp, %rdi
	callq	*memmove@GOTPCREL(%rip)
	jmp	.LBB212_104
.LBB212_103:
	movq	%r14, (%rsi)
	movups	360(%rsp), %xmm0
	movups	376(%rsp), %xmm1
	movaps	%xmm1, 288(%rsp)
	movaps	%xmm0, 272(%rsp)
.LBB212_104:
	incl	%r15d
	movq	%r12, %rax
	shlq	$5, %rax
	movaps	272(%rsp), %xmm0
	movaps	288(%rsp), %xmm1
	movq	192(%rsp), %rcx
	movups	%xmm1, 16(%rcx,%rax)
	movups	%xmm0, (%rcx,%rax)
	movw	%r15w, 450(%rcx)
	movaps	160(%rsp), %xmm0
	movaps	176(%rsp), %xmm1
	movaps	%xmm1, 256(%rsp)
	movaps	%xmm0, 240(%rsp)
	movq	352(%rbx), %rax
	testq	%rax, %rax
	je	.LBB212_132
	movq	$0, 352(%rsp)
	movq	104(%rsp), %rbp
	jmp	.LBB212_107
.LBB212_106:
	movaps	400(%rsp), %xmm0
	movaps	416(%rsp), %xmm1
	movaps	%xmm1, 256(%rsp)
	movaps	%xmm0, 240(%rsp)
	movq	352(%rbx), %rax
	testq	%rax, %rax
	je	.LBB212_133
.LBB212_107:
	movzwl	448(%rbx), %ecx
	movq	%rax, %rbx
	movzwl	450(%rax), %eax
	movq	%rax, 112(%rsp)
	cmpq	$11, %rax
	movq	%r13, 392(%rsp)
	movq	%rbp, 144(%rsp)
	jb	.LBB212_139
	cmpw	$5, %cx
	jae	.LBB212_110
	movq	%rcx, 8(%rsp)
	movl	$4, %eax
	movq	%rax, 40(%rsp)
	movl	$0, 136(%rsp)
	jmp	.LBB212_115
.LBB212_110:
	cmpq	$5, %rcx
	je	.LBB212_113
	cmpl	$6, %ecx
	jne	.LBB212_114
	movb	$1, %al
	movl	%eax, 136(%rsp)
	movl	$5, %eax
	movq	%rax, 40(%rsp)
	movq	$0, 8(%rsp)
	jmp	.LBB212_115
.LBB212_113:
	movl	$0, 136(%rsp)
	movq	%rcx, 8(%rsp)
	movq	%rcx, 40(%rsp)
	jmp	.LBB212_115
.LBB212_114:
	addq	$-7, %rcx
	movq	%rcx, 8(%rsp)
	movb	$1, %al
	movl	%eax, 136(%rsp)
	movl	$6, %eax
	movq	%rax, 40(%rsp)
.LBB212_115:
	callq	*_RNvCs9wFQrvczXsK_7___rustc35___rust_no_alloc_shim_is_unstable_v2@GOTPCREL(%rip)
	movl	$552, %edi
	movl	$8, %esi
	callq	*_RNvCs9wFQrvczXsK_7___rustc12___rust_alloc@GOTPCREL(%rip)
	testq	%rax, %rax
	je	.LBB212_208
	movq	%rax, %r13
	movq	$0, 352(%rax)
	movzwl	450(%rbx), %ecx
	movq	40(%rsp), %rdx
	movq	%rdx, %rbp
	notq	%rbp
	addq	%rcx, %rbp
	movw	%bp, 450(%rax)
	movq	360(%rbx,%rdx,8), %rcx
	movq	%rcx, 104(%rsp)
	movl	%edx, %r15d
	shll	$5, %r15d
	movups	(%rbx,%r15), %xmm0
	movups	16(%rbx,%r15), %xmm1
	movaps	%xmm1, 176(%rsp)
	movaps	%xmm0, 160(%rsp)
	cmpq	$12, %rbp
	jae	.LBB212_204
	leaq	360(%rbx), %rcx
	addq	%rbx, %r15
	incl	%edx
	movq	%rdx, 488(%rsp)
	leaq	(%rcx,%rdx,8), %rsi
	movq	%rax, 64(%rsp)
	leaq	360(%rax), %rdi
	leaq	(,%rbp,8), %rdx
	callq	*memcpy@GOTPCREL(%rip)
	movq	488(%rsp), %rsi
	shll	$5, %esi
	addq	%rbx, %rsi
	shlq	$5, %rbp
	movq	%r13, %rdi
	movq	%rbp, %rdx
	callq	*memcpy@GOTPCREL(%rip)
	movq	40(%rsp), %rcx
	movw	%cx, 450(%rbx)
	movups	(%r15), %xmm0
	movups	16(%r15), %xmm1
	leaq	280(%rsp), %rax
	movups	%xmm0, (%rax)
	movups	%xmm1, 16(%rax)
	movq	104(%rsp), %rbp
	movq	%rbp, 272(%rsp)
	movzwl	450(%r13), %r15d
	leaq	1(%r15), %rdx
	cmpq	$11, %r15
	ja	.LBB212_206
	movq	112(%rsp), %rax
	subl	%ecx, %eax
	cmpl	%edx, %eax
	jne	.LBB212_210
	incq	352(%rsp)
	movq	64(%rsp), %rax
	leaq	456(%rax), %rdi
	leaq	(%rbx,%rcx,8), %rsi
	addq	$464, %rsi
	shll	$3, %edx
	callq	*memcpy@GOTPCREL(%rip)
	xorl	%eax, %eax
.LBB212_120:
	movq	%rax, %rcx
	cmpq	%r15, %rax
	adcq	$0, %rax
	movq	456(%r13,%rcx,8), %rdx
	movq	%r13, 352(%rdx)
	movw	%cx, 448(%rdx)
	cmpq	%r15, %rcx
	jae	.LBB212_122
	cmpq	%r15, %rax
	jbe	.LBB212_120
.LBB212_122:
	leaq	280(%rsp), %rax
	movups	(%rax), %xmm0
	movups	16(%rax), %xmm1
	movaps	%xmm1, 416(%rsp)
	movaps	%xmm0, 400(%rsp)
	cmpb	$0, 136(%rsp)
	movq	64(%rsp), %r8
	cmoveq	%rbx, %r8
	movzwl	450(%r8), %r10d
	movq	8(%rsp), %rdx
	leaq	1(%rdx), %r15
	movq	%r10, %r9
	subq	%rdx, %r9
	jbe	.LBB212_124
	leaq	360(%r8), %rax
	leaq	(%r8,%rdx,8), %rsi
	addq	$360, %rsi
	leaq	(%rax,%r15,8), %rdi
	movl	%r10d, %eax
	subl	8(%rsp), %eax
	movq	%rax, 136(%rsp)
	leal	(,%rax,8), %edx
	movq	%rdx, 112(%rsp)
	movq	%r8, %rbp
	movq	%r9, 40(%rsp)
	movq	%r10, 64(%rsp)
	callq	*memmove@GOTPCREL(%rip)
	movq	8(%rsp), %rax
	movq	144(%rsp), %rcx
	movq	%rcx, 360(%rbp,%rax,8)
	movq	8(%rsp), %rax
	shlq	$5, %rax
	movq	%rax, 144(%rsp)
	leaq	(%rax,%rbp), %rsi
	movq	%r15, %rdi
	shlq	$5, %rdi
	addq	%rbp, %rdi
	movq	136(%rsp), %rdx
	shll	$5, %edx
	callq	*memmove@GOTPCREL(%rip)
	movaps	240(%rsp), %xmm0
	movaps	256(%rsp), %xmm1
	movq	144(%rsp), %rax
	movups	%xmm0, (%rbp,%rax)
	movups	%xmm1, 16(%rbp,%rax)
	leaq	456(%rbp,%r15,8), %rsi
	movq	8(%rsp), %rax
	leaq	472(,%rax,8), %rdi
	addq	%rbp, %rdi
	movq	112(%rsp), %rdx
	callq	*memmove@GOTPCREL(%rip)
	movq	64(%rsp), %r10
	movq	40(%rsp), %r9
	movq	%rbp, %r8
	movq	104(%rsp), %rbp
	movq	8(%rsp), %rdx
	jmp	.LBB212_125
.LBB212_124:
	movq	144(%rsp), %rax
	movq	%rax, 360(%r8,%rdx,8)
	movq	%rdx, %rax
	shlq	$5, %rax
	movaps	240(%rsp), %xmm0
	movaps	256(%rsp), %xmm1
	movups	%xmm1, 16(%r8,%rax)
	movups	%xmm0, (%r8,%rax)
.LBB212_125:
	movq	392(%rsp), %rsi
	leal	1(%r10), %ecx
	leaq	2(%r10), %rax
	movq	%rsi, 464(%r8,%rdx,8)
	movw	%cx, 450(%r8)
	cmpl	%eax, %r15d
	jae	.LBB212_106
	subl	%edx, %r10d
	incl	%r10d
	andl	$3, %r10d
	je	.LBB212_130
	leaq	(%r8,%rdx,8), %rdx
	addq	$464, %rdx
	xorl	%ecx, %ecx
.LBB212_128:
	movq	(%rdx,%rcx,8), %rsi
	movq	%r8, 352(%rsi)
	leal	(%r15,%rcx), %edi
	movw	%di, 448(%rsi)
	incq	%rcx
	cmpq	%rcx, %r10
	jne	.LBB212_128
	addq	%rcx, %r15
.LBB212_130:
	cmpl	$3, %r9d
	jb	.LBB212_106
.LBB212_131:
	movq	456(%r8,%r15,8), %rcx
	movq	%r8, 352(%rcx)
	movw	%r15w, 448(%rcx)
	movq	464(%r8,%r15,8), %rcx
	movq	%r8, 352(%rcx)
	leal	1(%r15), %edx
	movw	%dx, 448(%rcx)
	movq	472(%r8,%r15,8), %rcx
	movq	%r8, 352(%rcx)
	leal	2(%r15), %edx
	movw	%dx, 448(%rcx)
	movq	480(%r8,%r15,8), %rcx
	movq	%r8, 352(%rcx)
	leal	3(%r15), %edx
	movw	%dx, 448(%rcx)
	addq	$4, %r15
	cmpq	%rax, %r15
	jne	.LBB212_131
	jmp	.LBB212_106
.LBB212_132:
	movq	$0, 352(%rsp)
	movq	104(%rsp), %rbp
.LBB212_133:
	movaps	240(%rsp), %xmm0
	movaps	256(%rsp), %xmm1
	movups	%xmm1, 328(%rsp)
	movups	%xmm0, 312(%rsp)
	movq	%rbx, 272(%rsp)
	movq	352(%rsp), %rax
	movq	%rax, 280(%rsp)
	movq	%r13, 288(%rsp)
	movq	%rax, 296(%rsp)
	movq	%rbp, %rbx
	movq	%rbp, 304(%rsp)
	callq	*_RNvCs9wFQrvczXsK_7___rustc35___rust_no_alloc_shim_is_unstable_v2@GOTPCREL(%rip)
	movl	$552, %edi
	movl	$8, %esi
	callq	*_RNvCs9wFQrvczXsK_7___rustc12___rust_alloc@GOTPCREL(%rip)
	testq	%rax, %rax
	je	.LBB212_215
	movq	%rax, %r15
	movq	$0, 352(%rax)
	movw	$0, 450(%rax)
	movq	72(%rsp), %rax
	movq	%rax, 456(%r15)
	movq	32(%rsp), %rax
	incq	%rax
	je	.LBB212_216
	movq	72(%rsp), %rcx
	movq	%r15, 352(%rcx)
	movw	$0, 448(%rcx)
	movq	48(%rsp), %rcx
	movq	%r15, 72(%rcx)
	movq	%rax, 80(%rcx)
	movq	352(%rsp), %rax
	cmpq	32(%rsp), %rax
	jne	.LBB212_218
	movw	$1, 450(%r15)
	movq	%rbx, 360(%r15)
	movaps	240(%rsp), %xmm0
	movaps	256(%rsp), %xmm1
	movups	%xmm0, (%r15)
	movups	%xmm1, 16(%r15)
	movq	%r13, 464(%r15)
	movq	%r15, 352(%r13)
	movw	$1, 448(%r13)
.LBB212_137:
	movq	192(%rsp), %rax
.LBB212_138:
	movq	96(%rsp), %r15
	movl	28(%rsp), %r13d
	movq	80(%rsp), %rdi
	movq	48(%rsp), %rcx
	jmp	.LBB212_54
.LBB212_139:
	movq	112(%rsp), %rdx
	leal	1(%rdx), %eax
	movl	%eax, 72(%rsp)
	leaq	1(%rcx), %r15
	movq	%rcx, 8(%rsp)
	cmpw	%dx, %cx
	jae	.LBB212_184
	leaq	360(%rbx), %rdi
	movq	8(%rsp), %rbp
	leaq	(%rbx,%rbp,8), %rsi
	addq	$360, %rsi
	leal	(,%r15,8), %eax
	movq	%rax, 32(%rsp)
	addq	%rax, %rdi
	movq	112(%rsp), %rax
	subq	%rbp, %rax
	movq	%rax, 64(%rsp)
	leaq	(,%rax,8), %rdx
	movq	%rdx, 40(%rsp)
	movq	memmove@GOTPCREL(%rip), %r13
	callq	*%r13
	leal	(,%rbp,8), %r13d
	movq	144(%rsp), %rax
	movq	%rax, 360(%rbx,%r13)
	shll	$5, %ebp
	leaq	(%rbx,%rbp), %rsi
	movl	%r15d, %edi
	shll	$5, %edi
	addq	%rbx, %rdi
	movq	64(%rsp), %rdx
	shlq	$5, %rdx
	callq	*memmove@GOTPCREL(%rip)
	movaps	240(%rsp), %xmm0
	movaps	256(%rsp), %xmm1
	movups	%xmm0, (%rbx,%rbp)
	movups	%xmm1, 16(%rbx,%rbp)
	movq	32(%rsp), %rax
	leaq	(%rbx,%rax), %rsi
	addq	$456, %rsi
	leaq	(%rbx,%r13), %rdi
	addq	$472, %rdi
	movq	40(%rsp), %rdx
	callq	*memmove@GOTPCREL(%rip)
	jmp	.LBB212_185
.LBB212_141:
	movl	$0, 48(%rsp)
	movq	%r15, %r13
	jmp	.LBB212_143
.LBB212_142:
	addq	$-7, %r15
	movl	$6, %r13d
	movb	$1, %al
	movl	%eax, 48(%rsp)
.LBB212_143:
	callq	*_RNvCs9wFQrvczXsK_7___rustc35___rust_no_alloc_shim_is_unstable_v2@GOTPCREL(%rip)
	movl	$344, %edi
	movl	$8, %esi
	callq	*_RNvCs9wFQrvczXsK_7___rustc12___rust_alloc@GOTPCREL(%rip)
	movq	%rax, 8(%rsp)
	testq	%rax, %rax
	je	.LBB212_202
	movq	8(%rsp), %rcx
	movq	$0, (%rcx)
	movzwl	318(%rbx), %eax
	movq	%r13, %rdx
	notq	%rdx
	addq	%rax, %rdx
	movw	%dx, 318(%rcx)
	movq	%rdx, %r8
	cmpq	$12, %rdx
	jae	.LBB212_213
	movzwl	320(%rbx,%r13,2), %eax
	movw	%ax, 72(%rsp)
	leaq	(,%r13,8), %rax
	addq	%r13, %rax
	leaq	(%rax,%rax,2), %rax
	addq	%r13, %rax
	movq	%rax, 32(%rsp)
	leaq	2(,%r13,2), %rsi
	addq	%rbp, %rsi
	movq	8(%rsp), %rax
	leaq	320(%rax), %rdi
	movq	%r8, %rbp
	leaq	(%r8,%r8), %rdx
	callq	*memcpy@GOTPCREL(%rip)
	movq	32(%rsp), %rax
	leaq	(%rbx,%rax), %rsi
	addq	$36, %rsi
	movq	8(%rsp), %rax
	leaq	8(%rax), %rdi
	leaq	(,%rbp,8), %rax
	addq	%rbp, %rax
	leaq	(%rax,%rax,2), %rdx
	addq	%rbp, %rdx
	callq	*memcpy@GOTPCREL(%rip)
	movw	%r13w, 318(%rbx)
	movq	32(%rsp), %rax
	movups	8(%rbx,%rax), %xmm0
	movups	20(%rbx,%rax), %xmm1
	movups	%xmm1, 286(%rsp)
	movups	%xmm0, 274(%rsp)
	cmpb	$0, 48(%rsp)
	movq	8(%rsp), %r13
	cmoveq	%rbx, %r13
	movzwl	318(%r13), %ebp
	movq	%rbp, %rax
	leaq	320(,%r15,2), %rsi
	addq	%r13, %rsi
	subq	%r15, %rax
	jbe	.LBB212_147
	movq	%rax, %rcx
	leaq	320(%r13), %rax
	leaq	(%rax,%r15,2), %rdi
	addq	$2, %rdi
	movq	%rcx, 32(%rsp)
	leal	(%rcx,%rcx), %edx
	callq	*memmove@GOTPCREL(%rip)
	movl	28(%rsp), %eax
	movw	%ax, 320(%r13,%r15,2)
	movl	224(%rsp), %eax
	movl	%eax, 176(%rsp)
	movaps	208(%rsp), %xmm0
	movaps	%xmm0, 160(%rsp)
	leaq	(%r15,%r15,8), %rax
	leaq	(%rax,%rax,2), %rax
	addq	%r15, %rax
	leaq	(%rax,%r13), %rsi
	addq	$8, %rsi
	leaq	36(%r13,%rax), %rdi
	movq	32(%rsp), %rcx
	leaq	(%rcx,%rcx,8), %rax
	leaq	(%rax,%rax,2), %rdx
	addq	%rcx, %rdx
	callq	*memmove@GOTPCREL(%rip)
	jmp	.LBB212_148
.LBB212_147:
	movl	28(%rsp), %eax
	movw	%ax, (%rsi)
	movl	224(%rsp), %eax
	movl	%eax, 176(%rsp)
	movaps	208(%rsp), %xmm0
	movaps	%xmm0, 160(%rsp)
.LBB212_148:
	incl	%ebp
	leaq	(%r15,%r15,8), %rax
	leaq	(%rax,%rax,2), %rax
	addq	%r15, %rax
	movzbl	16(%rsp), %ecx
	movb	%cl, 8(%r13,%rax)
	movzbl	56(%rsp), %ecx
	movb	%cl, 9(%r13,%rax)
	movq	80(%rsp), %rcx
	movw	%cx, 14(%r13,%rax)
	movq	152(%rsp), %rcx
	movl	%ecx, 10(%r13,%rax)
	movaps	160(%rsp), %xmm0
	movups	%xmm0, 16(%r13,%rax)
	movl	176(%rsp), %ecx
	movl	%ecx, 32(%r13,%rax)
	movw	%bp, 318(%r13)
	movups	272(%rsp), %xmm0
	movups	286(%rsp), %xmm1
	movups	%xmm1, 414(%rsp)
	movaps	%xmm0, 400(%rsp)
	movq	(%rbx), %rax
	testq	%rax, %rax
	je	.LBB212_176
	movq	$0, 40(%rsp)
	movq	8(%rsp), %r13
	jmp	.LBB212_151
.LBB212_150:
	movups	174(%rsp), %xmm0
	movups	%xmm0, 414(%rsp)
	movaps	160(%rsp), %xmm0
	movaps	%xmm0, 400(%rsp)
	movq	(%rbx), %rax
	testq	%rax, %rax
	je	.LBB212_177
.LBB212_151:
	movzwl	72(%rsp), %ebp
	movzwl	316(%rbx), %ecx
	movq	%rax, %rbx
	movzwl	318(%rax), %eax
	movq	%rax, 32(%rsp)
	cmpq	$11, %rax
	movq	%r13, 48(%rsp)
	jb	.LBB212_181
	cmpw	$5, %cx
	jae	.LBB212_154
	movq	%rcx, 16(%rsp)
	movl	$4, %eax
	movq	%rax, 8(%rsp)
	xorl	%r15d, %r15d
	jmp	.LBB212_159
.LBB212_154:
	cmpq	$5, %rcx
	je	.LBB212_157
	cmpl	$6, %ecx
	jne	.LBB212_158
	movb	$1, %r15b
	movl	$5, %eax
	movq	%rax, 8(%rsp)
	movq	$0, 16(%rsp)
	jmp	.LBB212_159
.LBB212_157:
	xorl	%r15d, %r15d
	movq	%rcx, 16(%rsp)
	movq	%rcx, 8(%rsp)
	jmp	.LBB212_159
.LBB212_158:
	addq	$-7, %rcx
	movq	%rcx, 16(%rsp)
	movb	$1, %r15b
	movl	$6, %eax
	movq	%rax, 8(%rsp)
.LBB212_159:
	callq	*_RNvCs9wFQrvczXsK_7___rustc35___rust_no_alloc_shim_is_unstable_v2@GOTPCREL(%rip)
	movl	$440, %edi
	movl	$8, %esi
	callq	*_RNvCs9wFQrvczXsK_7___rustc12___rust_alloc@GOTPCREL(%rip)
	testq	%rax, %rax
	je	.LBB212_209
	movl	%r15d, 152(%rsp)
	movw	%bp, 28(%rsp)
	movq	%rax, %r13
	movq	$0, (%rax)
	movzwl	318(%rbx), %ecx
	movq	8(%rsp), %rsi
	movq	%rsi, %r8
	notq	%r8
	addq	%rcx, %r8
	movw	%r8w, 318(%rax)
	cmpq	$12, %r8
	jae	.LBB212_205
	leaq	320(%rbx), %rdx
	movzwl	320(%rbx,%rsi,2), %ecx
	movw	%cx, 72(%rsp)
	leaq	(%rsi,%rsi,8), %rcx
	leaq	(%rcx,%rcx,2), %r15
	addq	%rsi, %r15
	movq	8(%rsp), %rcx
	leaq	(%rdx,%rcx,2), %rsi
	addq	$2, %rsi
	leaq	320(%rax), %rdi
	leaq	(%r8,%r8), %rdx
	movq	%rax, %rbp
	movq	%r8, 80(%rsp)
	callq	*memcpy@GOTPCREL(%rip)
	leaq	(%rbx,%r15), %rsi
	addq	$36, %rsi
	movq	%rbp, 56(%rsp)
	leaq	8(%rbp), %rdi
	movq	80(%rsp), %rcx
	leaq	(%rcx,%rcx,8), %rax
	leaq	(%rax,%rax,2), %rdx
	addq	%rcx, %rdx
	callq	*memcpy@GOTPCREL(%rip)
	movq	8(%rsp), %rcx
	movw	%cx, 318(%rbx)
	movups	8(%rbx,%r15), %xmm0
	movups	20(%rbx,%r15), %xmm1
	leaq	274(%rsp), %rax
	movups	%xmm1, 12(%rax)
	movups	%xmm0, (%rax)
	movzwl	318(%r13), %r15d
	leaq	1(%r15), %rdx
	cmpq	$11, %r15
	ja	.LBB212_207
	movq	32(%rsp), %rax
	subl	%ecx, %eax
	cmpl	%edx, %eax
	jne	.LBB212_211
	incq	40(%rsp)
	movq	56(%rsp), %rax
	leaq	344(%rax), %rdi
	leaq	(%rbx,%rcx,8), %rsi
	addq	$352, %rsi
	shll	$3, %edx
	callq	*memcpy@GOTPCREL(%rip)
	xorl	%eax, %eax
.LBB212_164:
	movq	%rax, %rcx
	cmpq	%r15, %rax
	adcq	$0, %rax
	movq	344(%r13,%rcx,8), %rdx
	movq	%r13, (%rdx)
	movw	%cx, 316(%rdx)
	cmpq	%r15, %rcx
	jae	.LBB212_166
	cmpq	%r15, %rax
	jbe	.LBB212_164
.LBB212_166:
	movups	272(%rsp), %xmm0
	movups	286(%rsp), %xmm1
	movups	%xmm1, 174(%rsp)
	movaps	%xmm0, 160(%rsp)
	cmpb	$0, 152(%rsp)
	movq	56(%rsp), %rbp
	cmoveq	%rbx, %rbp
	movzwl	318(%rbp), %r10d
	movq	16(%rsp), %rdx
	leaq	1(%rdx), %r15
	movq	%r10, %r9
	subq	%rdx, %r9
	jbe	.LBB212_168
	leaq	320(%rbp), %rax
	leaq	320(,%rdx,2), %rsi
	addq	%rbp, %rsi
	leaq	(%rax,%r15,2), %rdi
	leal	(%r9,%r9), %edx
	movq	%r9, 8(%rsp)
	movq	%r10, 56(%rsp)
	callq	*memmove@GOTPCREL(%rip)
	movq	16(%rsp), %rax
	movzwl	28(%rsp), %ecx
	movw	%cx, 320(%rbp,%rax,2)
	movq	16(%rsp), %rax
	leaq	(%rax,%rax,8), %rax
	leaq	(%rax,%rax,2), %rax
	addq	16(%rsp), %rax
	movq	%rax, 32(%rsp)
	leaq	(%rax,%rbp), %rsi
	addq	$8, %rsi
	leaq	(%r15,%r15,8), %rax
	leaq	(%rax,%rax,2), %rax
	addq	%r15, %rax
	leaq	(%rax,%rbp), %rdi
	addq	$8, %rdi
	movq	8(%rsp), %rax
	leaq	(%rax,%rax,8), %rax
	leaq	(%rax,%rax,2), %rdx
	addq	8(%rsp), %rdx
	callq	*memmove@GOTPCREL(%rip)
	leaq	402(%rsp), %rax
	movups	(%rax), %xmm0
	movups	12(%rax), %xmm1
	movq	32(%rsp), %rax
	movups	%xmm0, 8(%rbp,%rax)
	movups	%xmm1, 20(%rbp,%rax)
	leaq	344(%rbp,%r15,8), %rsi
	movq	16(%rsp), %rax
	leaq	360(,%rax,8), %rdi
	addq	%rbp, %rdi
	movq	8(%rsp), %rax
	leal	(,%rax,8), %edx
	callq	*memmove@GOTPCREL(%rip)
	movq	56(%rsp), %r10
	movq	8(%rsp), %r9
	movq	16(%rsp), %rdx
	jmp	.LBB212_169
.LBB212_168:
	movzwl	28(%rsp), %eax
	movw	%ax, 320(%rbp,%rdx,2)
	leaq	(%rdx,%rdx,8), %rax
	leaq	(%rax,%rax,2), %rax
	addq	%rdx, %rax
	leaq	402(%rsp), %rcx
	movups	(%rcx), %xmm0
	movups	12(%rcx), %xmm1
	movups	%xmm1, 20(%rbp,%rax)
	movups	%xmm0, 8(%rbp,%rax)
.LBB212_169:
	leal	1(%r10), %ecx
	leaq	2(%r10), %rax
	movq	48(%rsp), %rsi
	movq	%rsi, 352(%rbp,%rdx,8)
	movw	%cx, 318(%rbp)
	cmpl	%eax, %r15d
	jae	.LBB212_150
	subl	%edx, %r10d
	incl	%r10d
	andl	$3, %r10d
	je	.LBB212_174
	leaq	352(,%rdx,8), %rdx
	addq	%rbp, %rdx
	xorl	%ecx, %ecx
.LBB212_172:
	movq	(%rdx,%rcx,8), %rsi
	movq	%rbp, (%rsi)
	leal	(%r15,%rcx), %edi
	movw	%di, 316(%rsi)
	incq	%rcx
	cmpq	%rcx, %r10
	jne	.LBB212_172
	addq	%rcx, %r15
.LBB212_174:
	cmpl	$3, %r9d
	jb	.LBB212_150
.LBB212_175:
	movq	344(%rbp,%r15,8), %rcx
	movq	%rbp, (%rcx)
	movw	%r15w, 316(%rcx)
	movq	352(%rbp,%r15,8), %rcx
	movq	%rbp, (%rcx)
	leal	1(%r15), %edx
	movw	%dx, 316(%rcx)
	movq	360(%rbp,%r15,8), %rcx
	movq	%rbp, (%rcx)
	leal	2(%r15), %edx
	movw	%dx, 316(%rcx)
	movq	368(%rbp,%r15,8), %rcx
	movq	%rbp, (%rcx)
	leal	3(%r15), %edx
	movw	%dx, 316(%rcx)
	addq	$4, %r15
	cmpq	%rax, %r15
	jne	.LBB212_175
	jmp	.LBB212_150
.LBB212_176:
	movq	$0, 40(%rsp)
	movq	8(%rsp), %r13
.LBB212_177:
	movq	%r13, %rbx
	callq	*_RNvCs9wFQrvczXsK_7___rustc35___rust_no_alloc_shim_is_unstable_v2@GOTPCREL(%rip)
	movl	$440, %edi
	movl	$8, %esi
	callq	*_RNvCs9wFQrvczXsK_7___rustc12___rust_alloc@GOTPCREL(%rip)
	testq	%rax, %rax
	je	.LBB212_217
	movq	%rax, %r15
	movq	$0, (%rax)
	movw	$0, 318(%rax)
	movq	104(%rsp), %rax
	movq	%rax, 344(%r15)
	movq	64(%rsp), %rax
	incq	%rax
	je	.LBB212_219
	movq	104(%rsp), %r13
	movq	%r15, (%r13)
	movw	$0, 316(%r13)
	movq	%r15, (%r12)
	movq	%rax, 8(%r12)
	movq	40(%rsp), %rax
	cmpq	64(%rsp), %rax
	jne	.LBB212_221
	movw	$1, 318(%r15)
	movzwl	72(%rsp), %eax
	movw	%ax, 320(%r15)
	movups	402(%rsp), %xmm0
	movups	414(%rsp), %xmm1
	movups	%xmm0, 8(%r15)
	movups	%xmm1, 20(%r15)
	movq	%rbx, 352(%r15)
	movq	%r15, (%rbx)
	movw	$1, 316(%rbx)
	movq	96(%rsp), %r15
	jmp	.LBB212_67
.LBB212_181:
	movl	%ebp, %r15d
	movq	32(%rsp), %rdx
	leal	1(%rdx), %eax
	movl	%eax, 56(%rsp)
	leaq	1(%rcx), %rax
	movq	%rax, 8(%rsp)
	movq	%rcx, 16(%rsp)
	cmpw	%dx, %cx
	jae	.LBB212_192
	leaq	320(%rbx), %rax
	movq	16(%rsp), %rbp
	leaq	(%rbx,%rbp,2), %rsi
	addq	$320, %rsi
	movq	8(%rsp), %rcx
	leaq	(%rax,%rcx,2), %rdi
	movq	32(%rsp), %rax
	subq	%rbp, %rax
	movq	%rax, 72(%rsp)
	leaq	(%rax,%rax), %rdx
	movq	memmove@GOTPCREL(%rip), %r13
	callq	*%r13
	movw	%r15w, 320(%rbx,%rbp,2)
	leaq	(,%rbp,8), %rax
	addq	%rbp, %rax
	leaq	(%rax,%rax,2), %r15
	addq	%rbp, %r15
	leaq	(%rbx,%r15), %rsi
	addq	$8, %rsi
	movq	8(%rsp), %rcx
	leaq	(%rcx,%rcx,8), %rax
	leaq	(%rax,%rax,2), %rax
	addq	%rcx, %rax
	leaq	(%rbx,%rax), %rdi
	addq	$8, %rdi
	movq	72(%rsp), %r13
	leaq	(,%r13,8), %rax
	addq	%r13, %rax
	leaq	(%rax,%rax,2), %rdx
	addq	%r13, %rdx
	callq	*memmove@GOTPCREL(%rip)
	leaq	402(%rsp), %rax
	movups	(%rax), %xmm0
	movups	12(%rax), %xmm1
	movups	%xmm0, 8(%rbx,%r15)
	movups	%xmm1, 20(%rbx,%r15)
	movq	8(%rsp), %rax
	leaq	(%rbx,%rax,8), %rsi
	addq	$344, %rsi
	leaq	(%rbx,%rbp,8), %rdi
	addq	$360, %rdi
	shlq	$3, %r13
	movq	%r13, %rdx
	callq	*memmove@GOTPCREL(%rip)
	jmp	.LBB212_193
.LBB212_183:
	movl	$8, %edi
	movl	$248, %esi
	callq	*_RNvNtCscdodAO9FK5_5alloc5alloc18handle_alloc_error@GOTPCREL(%rip)
.LBB212_184:
	movq	8(%rsp), %rax
	movq	144(%rsp), %rcx
	movq	%rcx, 360(%rbx,%rax,8)
	shll	$5, %eax
	movaps	240(%rsp), %xmm0
	movaps	256(%rsp), %xmm1
	movups	%xmm1, 16(%rbx,%rax)
	movups	%xmm0, (%rbx,%rax)
.LBB212_185:
	movq	112(%rsp), %rax
	addq	$2, %rax
	movq	8(%rsp), %rcx
	movq	392(%rsp), %rdx
	movq	%rdx, 464(%rbx,%rcx,8)
	movl	72(%rsp), %ecx
	movw	%cx, 450(%rbx)
	cmpl	%eax, %r15d
	jae	.LBB212_137
	movq	112(%rsp), %rsi
	movl	%esi, %ecx
	movq	8(%rsp), %rdx
	subl	%edx, %ecx
	incl	%ecx
	subq	%rdx, %rsi
	movq	%rsi, %r9
	andl	$3, %ecx
	je	.LBB212_190
	movq	8(%rsp), %rdx
	leaq	(%rbx,%rdx,8), %rsi
	addq	$464, %rsi
	xorl	%edx, %edx
.LBB212_188:
	movq	(%rsi,%rdx,8), %rdi
	movq	%rbx, 352(%rdi)
	leal	(%r15,%rdx), %r8d
	movw	%r8w, 448(%rdi)
	incq	%rdx
	cmpq	%rdx, %rcx
	jne	.LBB212_188
	addq	%rdx, %r15
.LBB212_190:
	cmpl	$3, %r9d
	jb	.LBB212_137
.LBB212_191:
	movq	456(%rbx,%r15,8), %rcx
	movq	%rbx, 352(%rcx)
	movw	%r15w, 448(%rcx)
	movq	464(%rbx,%r15,8), %rcx
	movq	%rbx, 352(%rcx)
	leal	1(%r15), %edx
	movw	%dx, 448(%rcx)
	movq	472(%rbx,%r15,8), %rcx
	movq	%rbx, 352(%rcx)
	leal	2(%r15), %edx
	movw	%dx, 448(%rcx)
	movq	480(%rbx,%r15,8), %rcx
	movq	%rbx, 352(%rcx)
	leal	3(%r15), %edx
	movw	%dx, 448(%rcx)
	addq	$4, %r15
	cmpq	%rax, %r15
	jne	.LBB212_191
	jmp	.LBB212_137
.LBB212_192:
	movq	16(%rsp), %rcx
	movw	%r15w, 320(%rbx,%rcx,2)
	leaq	(%rcx,%rcx,8), %rax
	leaq	(%rax,%rax,2), %rax
	addq	%rcx, %rax
	leaq	402(%rsp), %rcx
	movups	(%rcx), %xmm0
	movups	12(%rcx), %xmm1
	movups	%xmm1, 20(%rbx,%rax)
	movups	%xmm0, 8(%rbx,%rax)
.LBB212_193:
	movq	32(%rsp), %rax
	addq	$2, %rax
	movq	16(%rsp), %rcx
	movq	48(%rsp), %rdx
	movq	%rdx, 352(%rbx,%rcx,8)
	movl	56(%rsp), %ecx
	movw	%cx, 318(%rbx)
	cmpl	%eax, 8(%rsp)
	jae	.LBB212_200
	movq	32(%rsp), %rsi
	movl	%esi, %ecx
	movq	16(%rsp), %rdx
	subl	%edx, %ecx
	incl	%ecx
	subq	%rdx, %rsi
	movq	%rsi, %r9
	andl	$3, %ecx
	je	.LBB212_198
	movq	16(%rsp), %rdx
	leaq	(%rbx,%rdx,8), %rsi
	addq	$352, %rsi
	xorl	%edx, %edx
	movq	8(%rsp), %r10
.LBB212_196:
	movq	(%rsi,%rdx,8), %rdi
	movq	%rbx, (%rdi)
	leal	(%r10,%rdx), %r8d
	movw	%r8w, 316(%rdi)
	incq	%rdx
	cmpq	%rdx, %rcx
	jne	.LBB212_196
	addq	%rdx, %r10
	movq	%r10, 8(%rsp)
.LBB212_198:
	cmpl	$3, %r9d
	movq	8(%rsp), %rsi
	jb	.LBB212_200
.LBB212_199:
	movq	344(%rbx,%rsi,8), %rcx
	movq	%rbx, (%rcx)
	movw	%si, 316(%rcx)
	movq	352(%rbx,%rsi,8), %rcx
	movq	%rbx, (%rcx)
	leal	1(%rsi), %edx
	movw	%dx, 316(%rcx)
	movq	360(%rbx,%rsi,8), %rcx
	movq	%rbx, (%rcx)
	leal	2(%rsi), %edx
	movw	%dx, 316(%rcx)
	movq	368(%rbx,%rsi,8), %rcx
	movq	%rbx, (%rcx)
	leal	3(%rsi), %edx
	movw	%dx, 316(%rcx)
	addq	$4, %rsi
	cmpq	%rax, %rsi
	jne	.LBB212_199
.LBB212_200:
	movq	96(%rsp), %r15
	jmp	.LBB212_67
.LBB212_201:
	movl	$8, %edi
	movl	$96, %esi
	callq	*_RNvNtCscdodAO9FK5_5alloc5alloc18handle_alloc_error@GOTPCREL(%rip)
.LBB212_202:
	movl	$8, %edi
	movl	$344, %esi
	callq	*_RNvNtCscdodAO9FK5_5alloc5alloc18handle_alloc_error@GOTPCREL(%rip)
.LBB212_203:
	movl	$8, %edi
	movl	$456, %esi
	callq	*_RNvNtCscdodAO9FK5_5alloc5alloc18handle_alloc_error@GOTPCREL(%rip)
	jmp	.LBB212_220
.LBB212_204:
	leaq	.Lanon.bf080e38aafd3eacf4eb7123520eb4e9.121(%rip), %rcx
	movl	$11, %edx
	xorl	%edi, %edi
	movq	%rbp, %rsi
	callq	*_RNvNtNtCs4NRVxsYgnAr_4core5slice5index16slice_index_fail@GOTPCREL(%rip)
	jmp	.LBB212_220
.LBB212_205:
	movq	%r13, %r14
	leaq	.Lanon.bf080e38aafd3eacf4eb7123520eb4e9.121(%rip), %rcx
	movl	$11, %edx
	xorl	%edi, %edi
	movq	%r8, %rsi
	callq	*_RNvNtNtCs4NRVxsYgnAr_4core5slice5index16slice_index_fail@GOTPCREL(%rip)
	jmp	.LBB212_220
.LBB212_206:
	leaq	.Lanon.bf080e38aafd3eacf4eb7123520eb4e9.12(%rip), %rcx
	movq	%rdx, %rsi
	movl	$12, %edx
	xorl	%edi, %edi
	callq	*_RNvNtNtCs4NRVxsYgnAr_4core5slice5index16slice_index_fail@GOTPCREL(%rip)
	jmp	.LBB212_220
.LBB212_207:
	movq	%r13, %r14
	leaq	.Lanon.bf080e38aafd3eacf4eb7123520eb4e9.12(%rip), %rcx
	movq	%rdx, %rsi
	movl	$12, %edx
	xorl	%edi, %edi
	callq	*_RNvNtNtCs4NRVxsYgnAr_4core5slice5index16slice_index_fail@GOTPCREL(%rip)
	jmp	.LBB212_220
.LBB212_208:
	movl	$8, %edi
	movl	$552, %esi
	callq	*_RNvNtCscdodAO9FK5_5alloc5alloc18handle_alloc_error@GOTPCREL(%rip)
	jmp	.LBB212_220
.LBB212_209:
	movl	$8, %edi
	movl	$440, %esi
	callq	*_RNvNtCscdodAO9FK5_5alloc5alloc18handle_alloc_error@GOTPCREL(%rip)
.LBB212_210:
	leaq	.Lanon.bf080e38aafd3eacf4eb7123520eb4e9.28(%rip), %rdi
	leaq	.Lanon.bf080e38aafd3eacf4eb7123520eb4e9.29(%rip), %rdx
	movl	$40, %esi
	callq	*_RNvNtCs4NRVxsYgnAr_4core9panicking5panic@GOTPCREL(%rip)
	jmp	.LBB212_220
.LBB212_211:
	movq	%r13, %r14
	leaq	.Lanon.bf080e38aafd3eacf4eb7123520eb4e9.28(%rip), %rdi
	leaq	.Lanon.bf080e38aafd3eacf4eb7123520eb4e9.29(%rip), %rdx
	movl	$40, %esi
	callq	*_RNvNtCs4NRVxsYgnAr_4core9panicking5panic@GOTPCREL(%rip)
	jmp	.LBB212_220
.LBB212_212:
	leaq	.Lanon.bf080e38aafd3eacf4eb7123520eb4e9.121(%rip), %rcx
	movl	$11, %edx
	xorl	%edi, %edi
	movq	%r8, %rsi
	callq	*_RNvNtNtCs4NRVxsYgnAr_4core5slice5index16slice_index_fail@GOTPCREL(%rip)
	jmp	.LBB212_220
.LBB212_213:
	leaq	.Lanon.bf080e38aafd3eacf4eb7123520eb4e9.121(%rip), %rcx
	movl	$11, %edx
	xorl	%edi, %edi
	movq	%r8, %rsi
	callq	*_RNvNtNtCs4NRVxsYgnAr_4core5slice5index16slice_index_fail@GOTPCREL(%rip)
	jmp	.LBB212_220
.LBB212_214:
	movl	$8, %edi
	movl	$456, %esi
	callq	*_RNvNtCscdodAO9FK5_5alloc5alloc18handle_alloc_error@GOTPCREL(%rip)
	jmp	.LBB212_220
.LBB212_215:
	movl	$8, %edi
	movl	$552, %esi
	callq	*_RNvNtCscdodAO9FK5_5alloc5alloc18handle_alloc_error@GOTPCREL(%rip)
	jmp	.LBB212_220
.LBB212_216:
	leaq	.Lanon.bf080e38aafd3eacf4eb7123520eb4e9.9(%rip), %rdi
	callq	*_RNvNtCs4NRVxsYgnAr_4core6option13unwrap_failed@GOTPCREL(%rip)
	jmp	.LBB212_220
.LBB212_217:
	movl	$8, %edi
	movl	$440, %esi
	callq	*_RNvNtCscdodAO9FK5_5alloc5alloc18handle_alloc_error@GOTPCREL(%rip)
	jmp	.LBB212_220
.LBB212_218:
	leaq	312(%rsp), %r14
	leaq	.Lanon.bf080e38aafd3eacf4eb7123520eb4e9.177(%rip), %rdi
	leaq	.Lanon.bf080e38aafd3eacf4eb7123520eb4e9.178(%rip), %rdx
	movl	$48, %esi
	callq	*_RNvNtCs4NRVxsYgnAr_4core9panicking5panic@GOTPCREL(%rip)
	jmp	.LBB212_220
.LBB212_219:
	leaq	.Lanon.bf080e38aafd3eacf4eb7123520eb4e9.9(%rip), %rdi
	callq	*_RNvNtCs4NRVxsYgnAr_4core6option13unwrap_failed@GOTPCREL(%rip)
.LBB212_220:
	ud2
.LBB212_221:
	leaq	.Lanon.bf080e38aafd3eacf4eb7123520eb4e9.177(%rip), %rdi
	leaq	.Lanon.bf080e38aafd3eacf4eb7123520eb4e9.178(%rip), %rdx
	movl	$48, %esi
	callq	*_RNvNtCs4NRVxsYgnAr_4core9panicking5panic@GOTPCREL(%rip)
.LBB212_222:
	movq	%rax, %rbx
	movq	88(%rsp), %rax
	movq	$0, 2048(%rax)
	movq	%rbx, %rdi
	callq	_Unwind_Resume@PLT
.LBB212_223:
	movq	%rax, %rbx
	movq	88(%rsp), %rax
	movq	2048(%rax), %rax
	movq	$0, 240(%rax)
	movq	%rbx, %rdi
	callq	_Unwind_Resume@PLT
.LBB212_224:
	movl	$440, %esi
	movl	$8, %edx
	movq	%r15, %rdi
	callq	*_RNvCs9wFQrvczXsK_7___rustc14___rust_dealloc@GOTPCREL(%rip)
	ud2
.LBB212_225:
	movq	%rax, %rbx
	movq	%r14, %rdi
	callq	_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtCsere7gZGiCG7_4gpui8property7OverlayNtBE_13GeometryStyleEECs9Yg1K7nzAV4_24rounded_property_codegen
	jmp	.LBB212_249
.LBB212_226:
	callq	*_RNvNtCs4NRVxsYgnAr_4core9panicking16panic_in_cleanup@GOTPCREL(%rip)
.LBB212_227:
	ud2
.LBB212_228:
	movl	$552, %esi
	movl	$8, %edx
	movq	%r15, %rdi
	callq	*_RNvCs9wFQrvczXsK_7___rustc14___rust_dealloc@GOTPCREL(%rip)
	ud2
.LBB212_229:
	ud2
.LBB212_230:
	movq	%rax, %rbx
	jmp	.LBB212_234
.LBB212_231:
	movq	%rax, %rbx
	movl	$344, %esi
	movl	$8, %edx
	movq	8(%rsp), %rdi
	callq	*_RNvCs9wFQrvczXsK_7___rustc14___rust_dealloc@GOTPCREL(%rip)
	movq	%rbx, %rdi
	callq	_Unwind_Resume@PLT
.LBB212_232:
	movq	%rax, %rbx
	leaq	272(%rsp), %rdi
	callq	_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtCsere7gZGiCG7_4gpui8property7OverlayNtBE_13GeometryStyleEECs9Yg1K7nzAV4_24rounded_property_codegen
	movl	$456, %esi
	movl	$8, %edx
	movq	%r13, %rdi
	callq	*_RNvCs9wFQrvczXsK_7___rustc14___rust_dealloc@GOTPCREL(%rip)
.LBB212_234:
	leaq	360(%rsp), %rdi
	callq	_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtCsere7gZGiCG7_4gpui8property7OverlayNtBE_13GeometryStyleEECs9Yg1K7nzAV4_24rounded_property_codegen
	jmp	.LBB212_249
.LBB212_235:
	callq	*_RNvNtCs4NRVxsYgnAr_4core9panicking16panic_in_cleanup@GOTPCREL(%rip)
.LBB212_236:
	callq	*_RNvNtCs4NRVxsYgnAr_4core9panicking16panic_in_cleanup@GOTPCREL(%rip)
.LBB212_237:
	movq	%rax, %rbx
	jmp	.LBB212_248
.LBB212_238:
	jmp	.LBB212_244
.LBB212_239:
	movq	%rax, %rbx
	leaq	160(%rsp), %rdi
	callq	_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtCsere7gZGiCG7_4gpui8property7OverlayNtBE_13GeometryStyleEECs9Yg1K7nzAV4_24rounded_property_codegen
	jmp	.LBB212_247
.LBB212_240:
	callq	*_RNvNtCs4NRVxsYgnAr_4core9panicking16panic_in_cleanup@GOTPCREL(%rip)
.LBB212_241:
	movq	%rax, %rbx
	leaq	360(%rsp), %rdi
	callq	_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtCsere7gZGiCG7_4gpui8property7OverlayNtBE_13GeometryStyleEECs9Yg1K7nzAV4_24rounded_property_codegen
	jmp	.LBB212_249
.LBB212_242:
	callq	*_RNvNtCs4NRVxsYgnAr_4core9panicking16panic_in_cleanup@GOTPCREL(%rip)
.LBB212_243:
.LBB212_244:
	movq	%rax, %rbx
	movl	$440, %esi
	movl	$8, %edx
	movq	%r14, %rdi
	callq	*_RNvCs9wFQrvczXsK_7___rustc14___rust_dealloc@GOTPCREL(%rip)
	movq	%rbx, %rdi
	callq	_Unwind_Resume@PLT
.LBB212_246:
	movq	%rax, %rbx
	leaq	272(%rsp), %rdi
	callq	_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueTyINtNtCsere7gZGiCG7_4gpui8property7OverlayNtBG_13GeometryStyleEEECs9Yg1K7nzAV4_24rounded_property_codegen
.LBB212_247:
	movl	$552, %esi
	movl	$8, %edx
	movq	%r13, %rdi
	callq	*_RNvCs9wFQrvczXsK_7___rustc14___rust_dealloc@GOTPCREL(%rip)
.LBB212_248:
	leaq	240(%rsp), %rdi
	callq	_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtCsere7gZGiCG7_4gpui8property7OverlayNtBE_13GeometryStyleEECs9Yg1K7nzAV4_24rounded_property_codegen
.LBB212_249:
	movq	%rbx, %rdi
	callq	_Unwind_Resume@PLT
.LBB212_250:
	callq	*_RNvNtCs4NRVxsYgnAr_4core9panicking16panic_in_cleanup@GOTPCREL(%rip)
.LBB212_251:
	callq	*_RNvNtCs4NRVxsYgnAr_4core9panicking16panic_in_cleanup@GOTPCREL(%rip)
	.size	_RNvCs9Yg1K7nzAV4_24rounded_property_codegen13edit_geometry, .Lfunc_end212-_RNvCs9Yg1K7nzAV4_24rounded_property_codegen13edit_geometry
	.section	.text._RNvCs9Yg1K7nzAV4_24rounded_property_codegen13read_geometry,"ax",@progbits
	.p2align	4
	.type	_RNvCs9Yg1K7nzAV4_24rounded_property_codegen13read_geometry,@function
_RNvCs9Yg1K7nzAV4_24rounded_property_codegen13read_geometry:
	testq	%rsi, %rsi
	je	.LBB213_1
	cmpb	$1, 2382(%rsi)
	jne	.LBB213_5
	movq	$14, (%rdi)
	retq
.LBB213_1:
	movq	$13, (%rdi)
	movq	$0, 8(%rdi)
	retq
.LBB213_5:
	pushq	%r14
	pushq	%rbx
	subq	$72, %rsp
	movq	%rdi, %rbx
	leaq	16(%rsp), %rdi
	movq	%rsi, %r14
	callq	_RNvMsp_NtCsere7gZGiCG7_4gpui7runtimeINtB5_7RuntimeNtCs9Yg1K7nzAV4_24rounded_property_codegen4CardE7resolveBO_
	movq	16(%rsp), %rax
	movq	24(%rsp), %rsi
	cmpq	$-2, %rax
	jne	.LBB213_6
	movq	2048(%r14), %rax
	xorps	%xmm0, %xmm0
	testq	%rax, %rax
	je	.LBB213_10
	movq	240(%rax), %rdi
	testq	%rdi, %rdi
	je	.LBB213_10
	callq	*_RNvMNtNtCsere7gZGiCG7_4gpui7runtime8geometryNtB2_8Geometry3get@GOTPCREL(%rip)
.LBB213_10:
	movss	%xmm0, 12(%rsp)
	movq	_RNvNtCsere7gZGiCG7_4gpui8property11RADIUS_DECL@GOTPCREL(%rip), %rax
	leaq	12(%rsp), %rdi
	callq	*(%rax)
	movss	%xmm0, 8(%rbx)
	movq	$-2, (%rbx)
	addq	$72, %rsp
	popq	%rbx
	popq	%r14
	retq
.LBB213_6:
	movq	64(%rsp), %rcx
	movq	%rcx, 48(%rbx)
	movups	32(%rsp), %xmm0
	movups	48(%rsp), %xmm1
	movups	%xmm1, 32(%rbx)
	movups	%xmm0, 16(%rbx)
	movq	%rax, (%rbx)
	movq	%rsi, 8(%rbx)
	addq	$72, %rsp
	popq	%rbx
	popq	%r14
	retq
	.size	_RNvCs9Yg1K7nzAV4_24rounded_property_codegen13read_geometry, .Lfunc_end213-_RNvCs9Yg1K7nzAV4_24rounded_property_codegen13read_geometry
	.section	.text._RNvCs9Yg1K7nzAV4_24rounded_property_codegen10read_style,"ax",@progbits
.Lsec_end246:
	.section	.text._RNvCs9Yg1K7nzAV4_24rounded_property_codegen13edit_geometry,"ax",@progbits
.Lsec_end247:
	.section	.text._RNvCs9Yg1K7nzAV4_24rounded_property_codegen13read_geometry,"ax",@progbits
.Lsec_end248:
