
/tmp/gpui-paint-literal-cow-control-target/release/examples/canvas_literal_cow_storage:     file format elf64-x86-64


Disassembly of section .text:

00000000000237e0 <<gpui_canvas::canvas::columns::Columns>::find_scope>:
   237e0:	push   %rbp
   237e1:	push   %r15
   237e3:	push   %r14
   237e5:	push   %r13
   237e7:	push   %r12
   237e9:	push   %rbx
   237ea:	mov    %rdx,%rax
   237ed:	mov    %rsi,%rdx
   237f0:	mov    (%rcx),%ebx
   237f2:	mov    0x4(%rcx),%r11d
   237f6:	mov    0x8(%rcx),%r10
   237fa:	movabs $0x3ff0000000000000,%rcx
   23804:	mov    %rcx,-0x28(%rsp)
   23809:	movabs $0x8000000000000000,%rsi
   23813:	mov    %rsi,-0x20(%rsp)
   23818:	mov    %rsi,-0x18(%rsp)
   2381d:	mov    %rcx,-0x10(%rsp)
   23822:	mov    (%rax),%rcx
   23825:	mov    0x8(%rax),%rsi
   23829:	mov    0x10(%rax),%r8
   2382d:	mov    0x18(%rax),%r9
   23831:	mov    %rcx,-0x48(%rsp)
   23836:	mov    %rsi,-0x40(%rsp)
   2383b:	mov    %r8,-0x38(%rsp)
   23840:	mov    %r9,-0x30(%rsp)
   23845:	movdqu -0x48(%rsp),%xmm0
   2384b:	movdqu -0x18(%rsp),%xmm1
   23851:	movdqu -0x38(%rsp),%xmm2
   23857:	pcmpeqb -0x28(%rsp),%xmm0
   2385d:	pcmpeqb %xmm1,%xmm2
   23861:	pand   %xmm2,%xmm0
   23865:	pmovmskb %xmm0,%ebp
   23869:	cmp    $0xffff,%ebp
   2386f:	jne    23893 <<gpui_canvas::canvas::columns::Columns>::find_scope+0xb3>
   23871:	shl    $0x20,%r11
   23875:	mov    %ebx,%ebx
   23877:	xor    0x28(%rax),%r10
   2387b:	or     %r11,%rbx
   2387e:	xor    0x20(%rax),%rbx
   23882:	or     %r10,%rbx
   23885:	jne    23893 <<gpui_canvas::canvas::columns::Columns>::find_scope+0xb3>
   23887:	mov    $0x1,%eax
   2388c:	xor    %edx,%edx
   2388e:	jmp    23a03 <<gpui_canvas::canvas::columns::Columns>::find_scope+0x223>
   23893:	test   %rdx,%rdx
   23896:	je     23921 <<gpui_canvas::canvas::columns::Columns>::find_scope+0x141>
   2389c:	lea    (%rdx,%rdx,2),%r10
   238a0:	shl    $0x4,%r10
   238a4:	movups -0x30(%rdi,%r10,1),%xmm0
   238aa:	movaps %xmm0,-0x28(%rsp)
   238af:	movups -0x20(%rdi,%r10,1),%xmm0
   238b5:	movaps %xmm0,-0x18(%rsp)
   238ba:	mov    %rcx,-0x48(%rsp)
   238bf:	mov    %rsi,-0x40(%rsp)
   238c4:	mov    %r8,-0x38(%rsp)
   238c9:	mov    %r9,-0x30(%rsp)
   238ce:	movdqu -0x48(%rsp),%xmm0
   238d4:	movdqu -0x38(%rsp),%xmm1
   238da:	pcmpeqb -0x18(%rsp),%xmm1
   238e0:	pcmpeqb -0x28(%rsp),%xmm0
   238e6:	pand   %xmm1,%xmm0
   238ea:	pmovmskb %xmm0,%ebx
   238ee:	mov    0x20(%rax),%r11d
   238f2:	cmp    $0xffff,%ebx
   238f8:	jne    23925 <<gpui_canvas::canvas::columns::Columns>::find_scope+0x145>
   238fa:	add    %rdi,%r10
   238fd:	mov    -0x8(%r10),%rbx
   23901:	mov    0x24(%rax),%r14d
   23905:	shl    $0x20,%r14
   23909:	mov    %r11d,%r15d
   2390c:	xor    0x28(%rax),%rbx
   23910:	or     %r14,%r15
   23913:	xor    -0x10(%r10),%r15
   23917:	or     %rbx,%r15
   2391a:	jne    23925 <<gpui_canvas::canvas::columns::Columns>::find_scope+0x145>
   2391c:	jmp    239fa <<gpui_canvas::canvas::columns::Columns>::find_scope+0x21a>
   23921:	mov    0x20(%rax),%r11d
   23925:	mov    0x24(%rax),%ebx
   23928:	mov    0x28(%rax),%rax
   2392c:	shl    $0x20,%rbx
   23930:	mov    %r11d,%r11d
   23933:	or     %rbx,%r11
   23936:	shl    $0x4,%rdx
   2393a:	lea    (%rdx,%rdx,2),%rbx
   2393e:	mov    $0xffffffffffffffe1,%r14
   23945:	xor    %r15d,%r15d
   23948:	xor    %edx,%edx
   2394a:	mov    %rdi,%r12
   2394d:	nopl   (%rax)
   23950:	cmp    %r15,%rbx
   23953:	je     23a01 <<gpui_canvas::canvas::columns::Columns>::find_scope+0x221>
   23959:	movups (%r12),%xmm0
   2395e:	movaps %xmm0,-0x28(%rsp)
   23963:	movups 0x10(%r12),%xmm0
   23969:	movaps %xmm0,-0x18(%rsp)
   2396e:	mov    %rcx,-0x48(%rsp)
   23973:	mov    %rsi,-0x40(%rsp)
   23978:	mov    %r8,-0x38(%rsp)
   2397d:	mov    %r9,-0x30(%rsp)
   23982:	movdqu -0x48(%rsp),%xmm0
   23988:	movdqu -0x38(%rsp),%xmm1
   2398e:	pcmpeqb -0x18(%rsp),%xmm1
   23994:	pcmpeqb -0x28(%rsp),%xmm0
   2399a:	pand   %xmm1,%xmm0
   2399e:	pmovmskb %xmm0,%ebp
   239a2:	cmp    $0xffff,%ebp
   239a8:	jne    239c5 <<gpui_canvas::canvas::columns::Columns>::find_scope+0x1e5>
   239aa:	mov    0x20(%rdi,%r15,1),%rbp
   239af:	xor    %r11,%rbp
   239b2:	mov    0x28(%rdi,%r15,1),%r10
   239b7:	xor    %rax,%r10
   239ba:	mov    $0x1,%r13d
   239c0:	or     %rbp,%r10
   239c3:	je     239ca <<gpui_canvas::canvas::columns::Columns>::find_scope+0x1ea>
   239c5:	inc    %edx
   239c7:	xor    %r13d,%r13d
   239ca:	add    $0x30,%r12
   239ce:	mov    $0x2,%ebp
   239d3:	sub    %r13,%rbp
   239d6:	test   %r14,%r14
   239d9:	cmove  %r13,%rbp
   239dd:	inc    %r14
   239e0:	add    $0x30,%r15
   239e4:	cmp    $0x2,%rbp
   239e8:	je     23950 <<gpui_canvas::canvas::columns::Columns>::find_scope+0x170>
   239ee:	test   %rbp,%rbp
   239f1:	mov    $0x0,%eax
   239f6:	je     23a03 <<gpui_canvas::canvas::columns::Columns>::find_scope+0x223>
   239f8:	inc    %edx
   239fa:	mov    $0x1,%eax
   239ff:	jmp    23a03 <<gpui_canvas::canvas::columns::Columns>::find_scope+0x223>
   23a01:	xor    %eax,%eax
   23a03:	pop    %rbx
   23a04:	pop    %r12
   23a06:	pop    %r13
   23a08:	pop    %r14
   23a0a:	pop    %r15
   23a0c:	pop    %rbp
   23a0d:	ret


/tmp/gpui-paint-literal-cow-control-target/release/examples/canvas_literal_cow_storage:     file format elf64-x86-64


Disassembly of section .text:

0000000000023a10 <<gpui_canvas::canvas::columns::Columns>::admit>:
   23a10:	push   %rbp
   23a11:	push   %r15
   23a13:	push   %r14
   23a15:	push   %r13
   23a17:	push   %r12
   23a19:	push   %rbx
   23a1a:	sub    $0x58,%rsp
   23a1e:	mov    %r9d,%ebp
   23a21:	mov    %r8d,%r14d
   23a24:	mov    %ecx,%r12d
   23a27:	mov    %rdx,%rcx
   23a2a:	mov    %rsi,%r13
   23a2d:	mov    %rdi,%rbx
   23a30:	movups 0x10(%rsi),%xmm0
   23a34:	movaps %xmm0,0x20(%rsp)
   23a39:	movups 0x20(%rsi),%xmm0
   23a3d:	movaps %xmm0,0x30(%rsp)
   23a42:	movups (%rsi),%xmm0
   23a45:	movaps %xmm0,0x40(%rsp)
   23a4a:	mov    0x8(%rdi),%rdi
   23a4e:	mov    0x10(%rbx),%r15
   23a52:	lea    0x20(%rsp),%rdx
   23a57:	mov    %rdi,(%rsp)
   23a5b:	mov    %r15,%rsi
   23a5e:	call   237e0 <<gpui_canvas::canvas::columns::Columns>::find_scope>
   23a63:	or     %ebp,%r14d
   23a66:	je     23a96 <<gpui_canvas::canvas::columns::Columns>::admit+0x86>
   23a68:	cmp    $0x1,%eax
   23a6b:	jne    23ae3 <<gpui_canvas::canvas::columns::Columns>::admit+0xd3>
   23a6d:	mov    $0xffffffff,%eax
   23a72:	test   %bpl,%bpl
   23a75:	je     23bf0 <<gpui_canvas::canvas::columns::Columns>::admit+0x1e0>
   23a7b:	mov    0x28(%rbx),%rsi
   23a7f:	mov    $0x7,%eax
   23a84:	cmp    $0x1ffff,%rsi
   23a8b:	jbe    23b18 <<gpui_canvas::canvas::columns::Columns>::admit+0x108>
   23a91:	jmp    23bf0 <<gpui_canvas::canvas::columns::Columns>::admit+0x1e0>
   23a96:	test   %r12d,%r12d
   23a99:	je     23b73 <<gpui_canvas::canvas::columns::Columns>::admit+0x163>
   23a9f:	mov    %eax,%ecx
   23aa1:	add    $0xfffffffd,%r12d
   23aa5:	mov    $0x1,%eax
   23aaa:	cmp    %r12,0x28(%rbx)
   23aae:	jbe    23bf0 <<gpui_canvas::canvas::columns::Columns>::admit+0x1e0>
   23ab4:	cmp    $0x1,%ecx
   23ab7:	sete   %dl
   23aba:	mov    0x20(%rbx),%rcx
   23abe:	lea    (%r12,%r12,2),%rsi
   23ac2:	xor    %eax,%eax
   23ac4:	cmpw   $0x0,0x10(%rcx,%rsi,8)
   23aca:	setns  %cl
   23acd:	or     %cl,%dl
   23acf:	je     23bd8 <<gpui_canvas::canvas::columns::Columns>::admit+0x1c8>
   23ad5:	mov    %cl,%al
   23ad7:	lea    -0x1(,%rax,2),%eax
   23ade:	jmp    23bf0 <<gpui_canvas::canvas::columns::Columns>::admit+0x1e0>
   23ae3:	mov    $0x7,%eax
   23ae8:	cmp    $0x1ffff,%r15
   23aef:	ja     23bf0 <<gpui_canvas::canvas::columns::Columns>::admit+0x1e0>
   23af5:	test   %bpl,%bpl
   23af8:	je     23be6 <<gpui_canvas::canvas::columns::Columns>::admit+0x1d6>
   23afe:	mov    0x28(%rbx),%rsi
   23b02:	cmp    $0x1ffff,%rsi
   23b09:	ja     23bf0 <<gpui_canvas::canvas::columns::Columns>::admit+0x1e0>
   23b0f:	cmp    %r15,(%rbx)
   23b12:	je     23c4b <<gpui_canvas::canvas::columns::Columns>::admit+0x23b>
   23b18:	mov    $0xffffffff,%eax
   23b1d:	cmp    %rsi,0x18(%rbx)
   23b21:	jne    23bf0 <<gpui_canvas::canvas::columns::Columns>::admit+0x1e0>
   23b27:	lea    (%rsi,%rsi,1),%rax
   23b2b:	cmp    $0x5,%rax
   23b2f:	mov    $0x4,%r14d
   23b35:	cmovae %rax,%r14
   23b39:	mov    0x20(%rbx),%rdx
   23b3d:	lea    0x8(%rsp),%rdi
   23b42:	mov    $0x4,%r8d
   23b48:	mov    $0x18,%r9d
   23b4e:	mov    %r14,%rcx
   23b51:	call   265b0 <<alloc::raw_vec::RawVecInner>::finish_grow>
   23b56:	cmpl   $0x1,0x8(%rsp)
   23b5b:	je     23c87 <<gpui_canvas::canvas::columns::Columns>::admit+0x277>
   23b61:	mov    0x10(%rsp),%rax
   23b66:	mov    %rax,0x20(%rbx)
   23b6a:	mov    %r14,0x18(%rbx)
   23b6e:	jmp    23c44 <<gpui_canvas::canvas::columns::Columns>::admit+0x234>
   23b73:	mov    0x40(%r13),%rcx
   23b77:	mov    0x48(%r13),%rdx
   23b7b:	xor    %ebp,%ebp
   23b7d:	mov    %rcx,%rsi
   23b80:	or     %rdx,%rsi
   23b83:	je     23a68 <<gpui_canvas::canvas::columns::Columns>::admit+0x58>
   23b89:	movabs $0x3f8000003f800000,%rsi
   23b93:	mov    %rcx,%rdi
   23b96:	xor    %rsi,%rdi
   23b99:	xor    %rdx,%rsi
   23b9c:	or     %rdi,%rsi
   23b9f:	je     23a68 <<gpui_canvas::canvas::columns::Columns>::admit+0x58>
   23ba5:	movabs $0x3f80000000000000,%rsi
   23baf:	xor    %rsi,%rdx
   23bb2:	or     %rdx,%rcx
   23bb5:	je     23a68 <<gpui_canvas::canvas::columns::Columns>::admit+0x58>
   23bbb:	cmp    $0x1,%eax
   23bbe:	je     23a7b <<gpui_canvas::canvas::columns::Columns>::admit+0x6b>
   23bc4:	mov    $0x7,%eax
   23bc9:	cmp    $0x1ffff,%r15
   23bd0:	jbe    23afe <<gpui_canvas::canvas::columns::Columns>::admit+0xee>
   23bd6:	jmp    23bf0 <<gpui_canvas::canvas::columns::Columns>::admit+0x1e0>
   23bd8:	mov    $0x7,%eax
   23bdd:	cmp    $0x1ffff,%r15
   23be4:	ja     23bf0 <<gpui_canvas::canvas::columns::Columns>::admit+0x1e0>
   23be6:	mov    $0xffffffff,%eax
   23beb:	cmp    %r15,(%rbx)
   23bee:	je     23bff <<gpui_canvas::canvas::columns::Columns>::admit+0x1ef>
   23bf0:	add    $0x58,%rsp
   23bf4:	pop    %rbx
   23bf5:	pop    %r12
   23bf7:	pop    %r13
   23bf9:	pop    %r14
   23bfb:	pop    %r15
   23bfd:	pop    %rbp
   23bfe:	ret
   23bff:	lea    (%r15,%r15,1),%rax
   23c03:	cmp    $0x5,%rax
   23c07:	mov    $0x4,%r12d
   23c0d:	cmovae %rax,%r12
   23c11:	lea    0x8(%rsp),%rdi
   23c16:	mov    $0x8,%r8d
   23c1c:	mov    $0x30,%r9d
   23c22:	mov    %r15,%rsi
   23c25:	mov    (%rsp),%rdx
   23c29:	mov    %r12,%rcx
   23c2c:	call   265b0 <<alloc::raw_vec::RawVecInner>::finish_grow>
   23c31:	cmpl   $0x1,0x8(%rsp)
   23c36:	je     23c87 <<gpui_canvas::canvas::columns::Columns>::admit+0x277>
   23c38:	mov    0x10(%rsp),%rax
   23c3d:	mov    %rax,0x8(%rbx)
   23c41:	mov    %r12,(%rbx)
   23c44:	mov    $0xffffffff,%eax
   23c49:	jmp    23bf0 <<gpui_canvas::canvas::columns::Columns>::admit+0x1e0>
   23c4b:	mov    %rsi,%r14
   23c4e:	lea    (%r15,%r15,1),%rax
   23c52:	cmp    $0x5,%rax
   23c56:	mov    $0x4,%r12d
   23c5c:	cmovae %rax,%r12
   23c60:	lea    0x8(%rsp),%rdi
   23c65:	mov    $0x8,%r8d
   23c6b:	mov    $0x30,%r9d
   23c71:	mov    %r15,%rsi
   23c74:	mov    (%rsp),%rdx
   23c78:	mov    %r12,%rcx
   23c7b:	call   265b0 <<alloc::raw_vec::RawVecInner>::finish_grow>
   23c80:	cmpl   $0x1,0x8(%rsp)
   23c85:	jne    23c91 <<gpui_canvas::canvas::columns::Columns>::admit+0x281>
   23c87:	mov    $0x7,%eax
   23c8c:	jmp    23bf0 <<gpui_canvas::canvas::columns::Columns>::admit+0x1e0>
   23c91:	mov    0x10(%rsp),%rax
   23c96:	mov    %rax,0x8(%rbx)
   23c9a:	mov    %r12,(%rbx)
   23c9d:	mov    %r14,%rsi
   23ca0:	mov    $0xffffffff,%eax
   23ca5:	cmp    %rsi,0x18(%rbx)
   23ca9:	jne    23bf0 <<gpui_canvas::canvas::columns::Columns>::admit+0x1e0>
   23caf:	jmp    23b27 <<gpui_canvas::canvas::columns::Columns>::admit+0x117>


/tmp/gpui-paint-literal-cow-control-target/release/examples/canvas_literal_cow_storage:     file format elf64-x86-64


Disassembly of section .text:

0000000000023cc0 <<gpui_canvas::canvas::columns::Columns>::store>:
   23cc0:	push   %rbp
   23cc1:	push   %r15
   23cc3:	push   %r14
   23cc5:	push   %r13
   23cc7:	push   %r12
   23cc9:	push   %rbx
   23cca:	sub    $0x68,%rsp
   23cce:	mov    %r9d,0xc(%rsp)
   23cd3:	mov    %r8d,%r12d
   23cd6:	mov    %rdx,%r14
   23cd9:	mov    %rsi,%r13
   23cdc:	mov    %rdi,%rbx
   23cdf:	movups 0x10(%rdx),%xmm0
   23ce3:	movups 0x20(%rdx),%xmm1
   23ce7:	movaps %xmm0,0x20(%rsp)
   23cec:	movaps %xmm0,0x30(%rsp)
   23cf1:	movaps %xmm1,0x10(%rsp)
   23cf6:	movaps %xmm1,0x40(%rsp)
   23cfb:	movups (%rdx),%xmm0
   23cfe:	movaps %xmm0,0x50(%rsp)
   23d03:	mov    0x8(%rsi),%rbp
   23d07:	mov    0x10(%rsi),%r15
   23d0b:	lea    0x30(%rsp),%rdx
   23d10:	mov    %rbp,%rdi
   23d13:	mov    %r15,%rsi
   23d16:	call   237e0 <<gpui_canvas::canvas::columns::Columns>::find_scope>
   23d1b:	cmp    $0x1,%eax
   23d1e:	jne    23d6b <<gpui_canvas::canvas::columns::Columns>::store+0xab>
   23d20:	mov    %edx,%r15d
   23d23:	cmpb   $0x0,0xc(%rsp)
   23d28:	jne    23db9 <<gpui_canvas::canvas::columns::Columns>::store+0xf9>
   23d2e:	test   %r12d,%r12d
   23d31:	je     23ddf <<gpui_canvas::canvas::columns::Columns>::store+0x11f>
   23d37:	lea    -0x3(%r12),%eax
   23d3c:	cmp    %rax,0x28(%r13)
   23d40:	jbe    23d52 <<gpui_canvas::canvas::columns::Columns>::store+0x92>
   23d42:	mov    0x20(%r13),%rcx
   23d46:	lea    (%rax,%rax,2),%rax
   23d4a:	cmpw   $0x0,0x10(%rcx,%rax,8)
   23d50:	js     23dbd <<gpui_canvas::canvas::columns::Columns>::store+0xfd>
   23d52:	lea    -0x11e4c(%rip),%rdi        # 11f0d <anon.8afe5ad17d1aeb1ea26764d5e4edea02.23.llvm.9915238546238686500>
   23d59:	lea    0x42b58(%rip),%rdx        # 668b8 <anon.8afe5ad17d1aeb1ea26764d5e4edea02.24.llvm.9915238546238686500>
   23d60:	mov    $0x1d,%esi
   23d65:	call   *0x44d0d(%rip)        # 68a78 <_DYNAMIC+0x418>
   23d6b:	cmp    0x0(%r13),%r15
   23d6f:	jne    23d7e <<gpui_canvas::canvas::columns::Columns>::store+0xbe>
   23d71:	mov    %r13,%rdi
   23d74:	call   *0x44d06(%rip)        # 68a80 <_DYNAMIC+0x420>
   23d7a:	mov    0x8(%r13),%rbp
   23d7e:	lea    (%r15,%r15,2),%rax
   23d82:	shl    $0x4,%rax
   23d86:	movaps 0x20(%rsp),%xmm0
   23d8b:	movups %xmm0,0x0(%rbp,%rax,1)
   23d90:	movaps 0x10(%rsp),%xmm0
   23d95:	movups %xmm0,0x10(%rbp,%rax,1)
   23d9a:	movups (%r14),%xmm0
   23d9e:	movups %xmm0,0x20(%rbp,%rax,1)
   23da3:	lea    0x1(%r15),%rax
   23da7:	mov    %rax,0x10(%r13)
   23dab:	inc    %r15d
   23dae:	cmpb   $0x0,0xc(%rsp)
   23db3:	je     23d2e <<gpui_canvas::canvas::columns::Columns>::store+0x6e>
   23db9:	mov    0x40(%r14),%r12d
   23dbd:	movups 0x30(%r14),%xmm0
   23dc2:	movups %xmm0,(%rbx)
   23dc5:	mov    %r15d,0x10(%rbx)
   23dc9:	mov    %r12d,0x14(%rbx)
   23dcd:	mov    %rbx,%rax
   23dd0:	add    $0x68,%rsp
   23dd4:	pop    %rbx
   23dd5:	pop    %r12
   23dd7:	pop    %r13
   23dd9:	pop    %r14
   23ddb:	pop    %r15
   23ddd:	pop    %rbp
   23dde:	ret
   23ddf:	mov    0x40(%r14),%rax
   23de3:	mov    0x48(%r14),%rcx
   23de7:	mov    %rax,%rdx
   23dea:	or     %rcx,%rdx
   23ded:	je     23e23 <<gpui_canvas::canvas::columns::Columns>::store+0x163>
   23def:	movabs $0x3f80000000000000,%rdx
   23df9:	xor    %rcx,%rdx
   23dfc:	or     %rax,%rdx
   23dff:	je     23e1e <<gpui_canvas::canvas::columns::Columns>::store+0x15e>
   23e01:	movabs $0x3f8000003f800000,%rdx
   23e0b:	xor    %rdx,%rax
   23e0e:	xor    %rdx,%rcx
   23e11:	or     %rax,%rcx
   23e14:	jne    23e2b <<gpui_canvas::canvas::columns::Columns>::store+0x16b>
   23e16:	mov    $0x1,%r12d
   23e1c:	jmp    23dbd <<gpui_canvas::canvas::columns::Columns>::store+0xfd>
   23e1e:	xor    %r12d,%r12d
   23e21:	jmp    23dbd <<gpui_canvas::canvas::columns::Columns>::store+0xfd>
   23e23:	mov    $0x2,%r12d
   23e29:	jmp    23dbd <<gpui_canvas::canvas::columns::Columns>::store+0xfd>
   23e2b:	lea    0x40(%r14),%rbp
   23e2f:	mov    0x28(%r13),%r12
   23e33:	cmp    0x18(%r13),%r12
   23e37:	jne    23e43 <<gpui_canvas::canvas::columns::Columns>::store+0x183>
   23e39:	lea    0x18(%r13),%rdi
   23e3d:	call   *0x44c2d(%rip)        # 68a70 <_DYNAMIC+0x410>
   23e43:	mov    0x20(%r13),%rax
   23e47:	lea    (%r12,%r12,2),%rcx
   23e4b:	movups 0x0(%rbp),%xmm0
   23e4f:	movups %xmm0,(%rax,%rcx,8)
   23e53:	movq   $0x0,0x10(%rax,%rcx,8)
   23e5c:	lea    0x1(%r12),%rax
   23e61:	mov    %rax,0x28(%r13)
   23e65:	add    $0x3,%r12d
   23e69:	jmp    23dbd <<gpui_canvas::canvas::columns::Columns>::store+0xfd>


/tmp/gpui-paint-literal-cow-control-target/release/examples/canvas_literal_cow_storage:     file format elf64-x86-64


Disassembly of section .text:

0000000000023e70 <<gpui_canvas::canvas::columns::Columns>::support>:
   23e70:	push   %rbp
   23e71:	push   %r15
   23e73:	push   %r14
   23e75:	push   %rbx
   23e76:	sub    $0x28,%rsp
   23e7a:	cmp    $0x3,%esi
   23e7d:	jb     23f9f <<gpui_canvas::canvas::columns::Columns>::support+0x12f>
   23e83:	add    $0xfffffffd,%esi
   23e86:	mov    0x28(%rdi),%rax
   23e8a:	cmp    %rsi,%rax
   23e8d:	jbe    23faa <<gpui_canvas::canvas::columns::Columns>::support+0x13a>
   23e93:	mov    %rdx,%rbx
   23e96:	mov    0x20(%rdi),%rax
   23e9a:	lea    (%rsi,%rsi,2),%rdx
   23e9e:	movzwl 0x10(%rax,%rdx,8),%ebp
   23ea3:	and    $0x8000,%ebp
   23ea9:	movzwl 0x12(%rax,%rdx,8),%esi
   23eae:	and    $0xffff8000,%esi
   23eb4:	test   %cl,%cl
   23eb6:	mov    $0x8000,%r14d
   23ebc:	cmove  %esi,%r14d
   23ec0:	lea    (%rax,%rdx,8),%r15
   23ec4:	mov    0x10(%rax,%rdx,8),%rax
   23ec9:	mov    %eax,%ecx
   23ecb:	shr    $0x10,%ecx
   23ece:	mov    %rax,%rdx
   23ed1:	shr    $0x20,%rdx
   23ed5:	mov    %rax,%rsi
   23ed8:	shr    $0x30,%rsi
   23edc:	and    $0x7fff,%eax
   23ee1:	and    $0x7fff,%ecx
   23ee7:	and    $0x7fff,%edx
   23eed:	and    $0x7fff,%esi
   23ef3:	mov    %rax,0x8(%rsp)
   23ef8:	mov    %rcx,0x10(%rsp)
   23efd:	mov    %rdx,0x18(%rsp)
   23f02:	mov    %rsi,0x20(%rsp)
   23f07:	lea    0x8(%rsp),%rdi
   23f0c:	call   240d0 <<gpui_canvas::damage::DamageRegion>::checked_canvas_bounds>
   23f11:	mov    %rax,%rdx
   23f14:	shr    $0x20,%rdx
   23f18:	cmp    %dx,%ax
   23f1b:	je     23f86 <<gpui_canvas::canvas::columns::Columns>::support+0x116>
   23f1d:	mov    %eax,%ecx
   23f1f:	shr    $0x10,%ecx
   23f22:	mov    %rax,%rsi
   23f25:	shr    $0x30,%rsi
   23f29:	cmp    %si,%cx
   23f2c:	je     23f86 <<gpui_canvas::canvas::columns::Columns>::support+0x116>
   23f2e:	mov    %rbx,%rdi
   23f31:	shr    $0x20,%rdi
   23f35:	cmp    %di,%bx
   23f38:	je     23f89 <<gpui_canvas::canvas::columns::Columns>::support+0x119>
   23f3a:	mov    %ebx,%r9d
   23f3d:	shr    $0x10,%r9d
   23f41:	mov    %rbx,%r8
   23f44:	shr    $0x30,%r8
   23f48:	cmp    %r8w,%r9w
   23f4c:	je     23f89 <<gpui_canvas::canvas::columns::Columns>::support+0x119>
   23f4e:	cmp    %ax,%bx
   23f51:	cmovb  %ebx,%eax
   23f54:	cmp    %cx,%r9w
   23f58:	cmovb  %r9d,%ecx
   23f5c:	cmp    %dx,%di
   23f5f:	cmova  %edi,%edx
   23f62:	cmp    %si,%r8w
   23f66:	cmova  %r8d,%esi
   23f6a:	shl    $0x30,%rsi
   23f6e:	movzwl %dx,%edx
   23f71:	shl    $0x20,%rdx
   23f75:	or     %rsi,%rdx
   23f78:	shl    $0x10,%ecx
   23f7b:	or     %rdx,%rcx
   23f7e:	movzwl %ax,%eax
   23f81:	or     %rcx,%rax
   23f84:	jmp    23f89 <<gpui_canvas::canvas::columns::Columns>::support+0x119>
   23f86:	mov    %rbx,%rax
   23f89:	mov    %rax,0x10(%r15)
   23f8d:	or     %eax,%ebp
   23f8f:	mov    %bp,0x10(%r15)
   23f94:	shr    $0x10,%eax
   23f97:	or     %eax,%r14d
   23f9a:	mov    %r14w,0x12(%r15)
   23f9f:	add    $0x28,%rsp
   23fa3:	pop    %rbx
   23fa4:	pop    %r14
   23fa6:	pop    %r15
   23fa8:	pop    %rbp
   23fa9:	ret
   23faa:	lea    0x42937(%rip),%rdx        # 668e8 <anon.8afe5ad17d1aeb1ea26764d5e4edea02.27.llvm.9915238546238686500>
   23fb1:	mov    %rsi,%rdi
   23fb4:	mov    %rax,%rsi
   23fb7:	call   *0x449cb(%rip)        # 68988 <_DYNAMIC+0x328>


/tmp/gpui-paint-literal-cow-control-target/release/examples/canvas_literal_cow_storage:     file format elf64-x86-64


Disassembly of section .text:

0000000000022010 <<gpui_canvas::canvas::Canvas>::fill_shape>:
   22010:	push   %rbp
   22011:	push   %r15
   22013:	push   %r14
   22015:	push   %r13
   22017:	push   %r12
   22019:	push   %rbx
   2201a:	sub    $0xf8,%rsp
   22021:	mov    %r9d,%ebp
   22024:	mov    %r8,%r14
   22027:	mov    %rcx,%r13
   2202a:	mov    %rdx,%r15
   2202d:	mov    %rsi,%r12
   22030:	mov    %rdi,%rbx
   22033:	mov    %rcx,%rdi
   22036:	call   *0x46a0c(%rip)        # 68a48 <_DYNAMIC+0x3e8>
   2203c:	mov    %eax,%ecx
   2203e:	mov    $0x1,%eax
   22043:	test   %cl,%cl
   22045:	je     2205d <<gpui_canvas::canvas::Canvas>::fill_shape+0x4d>
   22047:	movss  0x0(%r13),%xmm0
   2204d:	andps  -0x11f74(%rip),%xmm0        # 100e0 <GCC_except_table0+0x324>
   22054:	ucomiss -0x11de3(%rip),%xmm0        # 10278 <GCC_except_table0+0x4bc>
   2205b:	jbe    2206f <<gpui_canvas::canvas::Canvas>::fill_shape+0x5f>
   2205d:	add    $0xf8,%rsp
   22064:	pop    %rbx
   22065:	pop    %r12
   22067:	pop    %r13
   22069:	pop    %r14
   2206b:	pop    %r15
   2206d:	pop    %rbp
   2206e:	ret
   2206f:	movsd  0x4(%r13),%xmm0
   22075:	movaps -0x11f9c(%rip),%xmm1        # 100e0 <GCC_except_table0+0x324>
   2207c:	andps  %xmm1,%xmm0
   2207f:	movaps -0x11f36(%rip),%xmm2        # 10150 <GCC_except_table0+0x394>
   22086:	cmpltps %xmm0,%xmm2
   2208a:	unpcklps %xmm2,%xmm2
   2208d:	movmskpd %xmm2,%ecx
   22091:	test   %ecx,%ecx
   22093:	setne  %cl
   22096:	movss  0xc(%r13),%xmm0
   2209c:	andps  %xmm1,%xmm0
   2209f:	ucomiss -0x11e2e(%rip),%xmm0        # 10278 <GCC_except_table0+0x4bc>
   220a6:	ja     2205d <<gpui_canvas::canvas::Canvas>::fill_shape+0x4d>
   220a8:	test   %cl,%cl
   220aa:	jne    2205d <<gpui_canvas::canvas::Canvas>::fill_shape+0x4d>
   220ac:	lea    0x8(%rsp),%rdi
   220b1:	mov    %r15,%rsi
   220b4:	call   20ef0 <<gpui_canvas::canvas::Mapping>::new>
   220b9:	cmpl   $0x1,0x8(%rsp)
   220be:	jne    220ca <<gpui_canvas::canvas::Canvas>::fill_shape+0xba>
   220c0:	mov    0xc(%rsp),%eax
   220c4:	mov    0x10(%rsp),%edx
   220c8:	jmp    2205d <<gpui_canvas::canvas::Canvas>::fill_shape+0x4d>
   220ca:	mov    0x10(%rsp),%eax
   220ce:	movups 0x14(%rsp),%xmm0
   220d3:	movups %xmm0,0xb4(%rsp)
   220db:	movups 0x24(%rsp),%xmm0
   220e0:	movups %xmm0,0xc4(%rsp)
   220e8:	movups 0x30(%rsp),%xmm0
   220ed:	movups %xmm0,0xd0(%rsp)
   220f5:	movups 0x0(%r13),%xmm0
   220fa:	movaps %xmm0,0xa0(%rsp)
   22102:	mov    %eax,0xb0(%rsp)
   22109:	movups (%r14),%xmm0
   2210d:	movaps %xmm0,0xe0(%rsp)
   22115:	mov    0x1a8(%rbx),%r13
   2211c:	mov    0x1b0(%rbx),%rax
   22123:	mov    %ebp,(%rsp)
   22126:	mov    %rax,%rbp
   22129:	lea    0x8(%rsp),%rdi
   2212e:	lea    0xa0(%rsp),%r9
   22136:	mov    %r13,%rsi
   22139:	mov    %rax,%rdx
   2213c:	mov    %r12,%rcx
   2213f:	mov    %r15,%r8
   22142:	call   22e20 <<gpui_canvas::canvas::Canvas>::prepare>
   22147:	mov    0x8(%rsp),%esi
   2214b:	mov    0xc(%rsp),%ecx
   2214f:	mov    0x10(%rsp),%edx
   22153:	cmp    $0x2,%esi
   22156:	jne    2215f <<gpui_canvas::canvas::Canvas>::fill_shape+0x14f>
   22158:	mov    %ecx,%eax
   2215a:	jmp    2205d <<gpui_canvas::canvas::Canvas>::fill_shape+0x4d>
   2215f:	mov    0x24(%rsp),%eax
   22163:	mov    %eax,0x80(%rsp)
   2216a:	movups 0x14(%rsp),%xmm0
   2216f:	movaps %xmm0,0x70(%rsp)
   22174:	mov    $0xffffffff,%eax
   22179:	cmp    $0x1,%esi
   2217c:	jne    2205d <<gpui_canvas::canvas::Canvas>::fill_shape+0x4d>
   22182:	mov    %ecx,0x54(%rsp)
   22186:	mov    %edx,0x58(%rsp)
   2218a:	movaps 0x70(%rsp),%xmm0
   2218f:	movups %xmm0,0x5c(%rsp)
   22194:	mov    0x80(%rsp),%eax
   2219b:	mov    %eax,0x6c(%rsp)
   2219f:	test   %r13,%r13
   221a2:	js     221ae <<gpui_canvas::canvas::Canvas>::fill_shape+0x19e>
   221a4:	xorps  %xmm0,%xmm0
   221a7:	cvtsi2ss %r13,%xmm0
   221ac:	jmp    221c7 <<gpui_canvas::canvas::Canvas>::fill_shape+0x1b7>
   221ae:	mov    %r13,%rax
   221b1:	shr    $1,%rax
   221b4:	and    $0x1,%r13d
   221b8:	or     %rax,%r13
   221bb:	xorps  %xmm0,%xmm0
   221be:	cvtsi2ss %r13,%xmm0
   221c3:	addss  %xmm0,%xmm0
   221c7:	mov    0x130(%rsp),%r15
   221cf:	test   %rbp,%rbp
   221d2:	js     221db <<gpui_canvas::canvas::Canvas>::fill_shape+0x1cb>
   221d4:	cvtsi2ss %rbp,%xmm1
   221d9:	jmp    221f0 <<gpui_canvas::canvas::Canvas>::fill_shape+0x1e0>
   221db:	mov    %rbp,%rax
   221de:	shr    $1,%rax
   221e1:	and    $0x1,%ebp
   221e4:	or     %rax,%rbp
   221e7:	cvtsi2ss %rbp,%xmm1
   221ec:	addss  %xmm1,%xmm1
   221f0:	lea    0xb8(%rbx),%r12
   221f7:	movq   $0x0,0x8(%rsp)
   22200:	movss  %xmm0,0x10(%rsp)
   22206:	movss  %xmm1,0x14(%rsp)
   2220c:	mov    (%r15),%ecx
   2220f:	test   %ecx,%ecx
   22211:	je     2221c <<gpui_canvas::canvas::Canvas>::fill_shape+0x20c>
   22213:	cmp    $0x1,%ecx
   22216:	jne    22220 <<gpui_canvas::canvas::Canvas>::fill_shape+0x210>
   22218:	mov    0x4(%r15),%ecx
   2221c:	xor    %eax,%eax
   2221e:	jmp    2222b <<gpui_canvas::canvas::Canvas>::fill_shape+0x21b>
   22220:	mov    0x8(%r15),%rax
   22224:	mov    (%rax),%ecx
   22226:	test   %ecx,%ecx
   22228:	sete   %al
   2222b:	movzbl %al,%r9d
   2222f:	lea    0xa0(%rsp),%rsi
   22237:	lea    0x8(%rsp),%rdx
   2223c:	mov    %r12,%rdi
   2223f:	xor    %r8d,%r8d
   22242:	call   23a10 <<gpui_canvas::canvas::columns::Columns>::admit>
   22247:	cmp    $0xffffffff,%eax
   2224a:	jne    2205d <<gpui_canvas::canvas::Canvas>::fill_shape+0x4d>
   22250:	lea    0x54(%rsp),%rsi
   22255:	mov    $0x1,%edx
   2225a:	mov    $0x8,%ecx
   2225f:	mov    %rbx,%rdi
   22262:	xor    %r8d,%r8d
   22265:	xor    %r9d,%r9d
   22268:	call   22370 <<gpui_canvas::canvas::Canvas>::admit>
   2226d:	cmp    $0xffffffff,%eax
   22270:	jne    2205d <<gpui_canvas::canvas::Canvas>::fill_shape+0x4d>
   22276:	mov    %r15,%rdi
   22279:	mov    %r12,%rsi
   2227c:	mov    %r14,%rdx
   2227f:	call   23fe0 <<gpui_canvas::canvas::columns::PaintUse>::commit>
   22284:	movups 0x54(%rsp),%xmm0
   22289:	movups 0x60(%rsp),%xmm1
   2228e:	movups %xmm1,0x18(%rsp)
   22293:	movups %xmm0,0xc(%rsp)
   22298:	movl   $0x1,0x8(%rsp)
   222a0:	movq   $0x0,0x88(%rsp)
   222ac:	movq   $0x8,0x90(%rsp)
   222b8:	movq   $0x0,0x98(%rsp)
   222c4:	mov    0x1a8(%rbx),%rdx
   222cb:	mov    0x1b0(%rbx),%rcx
   222d2:	test   %rdx,%rdx
   222d5:	js     222e1 <<gpui_canvas::canvas::Canvas>::fill_shape+0x2d1>
   222d7:	xorps  %xmm0,%xmm0
   222da:	cvtsi2ss %rdx,%xmm0
   222df:	jmp    222f9 <<gpui_canvas::canvas::Canvas>::fill_shape+0x2e9>
   222e1:	mov    %rdx,%rsi
   222e4:	shr    $1,%rsi
   222e7:	and    $0x1,%edx
   222ea:	or     %rsi,%rdx
   222ed:	xorps  %xmm0,%xmm0
   222f0:	cvtsi2ss %rdx,%xmm0
   222f5:	addss  %xmm0,%xmm0
   222f9:	test   %rcx,%rcx
   222fc:	js     22308 <<gpui_canvas::canvas::Canvas>::fill_shape+0x2f8>
   222fe:	xorps  %xmm1,%xmm1
   22301:	cvtsi2ss %rcx,%xmm1
   22306:	jmp    22320 <<gpui_canvas::canvas::Canvas>::fill_shape+0x310>
   22308:	mov    %rcx,%rdx
   2230b:	shr    $1,%rdx
   2230e:	and    $0x1,%ecx
   22311:	or     %rdx,%rcx
   22314:	xorps  %xmm1,%xmm1
   22317:	cvtsi2ss %rcx,%xmm1
   2231c:	addss  %xmm1,%xmm1
   22320:	movq   $0x0,0x40(%rsp)
   22329:	movss  %xmm0,0x48(%rsp)
   2232f:	movss  %xmm1,0x4c(%rsp)
   22335:	lea    0xa0(%rsp),%rsi
   2233d:	lea    0x8(%rsp),%rdx
   22342:	lea    0x88(%rsp),%rcx
   2234a:	lea    0x40(%rsp),%r8
   2234f:	mov    %rbx,%rdi
   22352:	mov    %eax,%r9d
   22355:	call   20950 <<gpui_canvas::canvas::DisplayList>::append::<core::iter::sources::once::Once<gpui_canvas::canvas::PendingDraw>>>
   2235a:	movb   $0x1,0x1e0(%rbx)
   22361:	mov    $0xffffffff,%eax
   22366:	jmp    2205d <<gpui_canvas::canvas::Canvas>::fill_shape+0x4d>
