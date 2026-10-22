
/tmp/gpui-paint-literal-cow-target/release/examples/canvas_literal_cow_storage:     file format elf64-x86-64


Disassembly of section .text:

0000000000025920 <<gpui_canvas::canvas::columns::Columns>::find_scope>:
   25920:	push   %rbp
   25921:	push   %r15
   25923:	push   %r14
   25925:	push   %r13
   25927:	push   %r12
   25929:	push   %rbx
   2592a:	mov    %rdx,%rax
   2592d:	mov    %rsi,%rdx
   25930:	mov    (%rcx),%ebx
   25932:	mov    0x4(%rcx),%r11d
   25936:	mov    0x8(%rcx),%r10
   2593a:	movabs $0x3ff0000000000000,%rcx
   25944:	mov    %rcx,-0x28(%rsp)
   25949:	movabs $0x8000000000000000,%rsi
   25953:	mov    %rsi,-0x20(%rsp)
   25958:	mov    %rsi,-0x18(%rsp)
   2595d:	mov    %rcx,-0x10(%rsp)
   25962:	mov    (%rax),%rcx
   25965:	mov    0x8(%rax),%rsi
   25969:	mov    0x10(%rax),%r8
   2596d:	mov    0x18(%rax),%r9
   25971:	mov    %rcx,-0x48(%rsp)
   25976:	mov    %rsi,-0x40(%rsp)
   2597b:	mov    %r8,-0x38(%rsp)
   25980:	mov    %r9,-0x30(%rsp)
   25985:	movdqu -0x48(%rsp),%xmm0
   2598b:	movdqu -0x18(%rsp),%xmm1
   25991:	movdqu -0x38(%rsp),%xmm2
   25997:	pcmpeqb -0x28(%rsp),%xmm0
   2599d:	pcmpeqb %xmm1,%xmm2
   259a1:	pand   %xmm2,%xmm0
   259a5:	pmovmskb %xmm0,%ebp
   259a9:	cmp    $0xffff,%ebp
   259af:	jne    259d3 <<gpui_canvas::canvas::columns::Columns>::find_scope+0xb3>
   259b1:	shl    $0x20,%r11
   259b5:	mov    %ebx,%ebx
   259b7:	xor    0x28(%rax),%r10
   259bb:	or     %r11,%rbx
   259be:	xor    0x20(%rax),%rbx
   259c2:	or     %r10,%rbx
   259c5:	jne    259d3 <<gpui_canvas::canvas::columns::Columns>::find_scope+0xb3>
   259c7:	mov    $0x1,%eax
   259cc:	xor    %edx,%edx
   259ce:	jmp    25b43 <<gpui_canvas::canvas::columns::Columns>::find_scope+0x223>
   259d3:	test   %rdx,%rdx
   259d6:	je     25a61 <<gpui_canvas::canvas::columns::Columns>::find_scope+0x141>
   259dc:	lea    (%rdx,%rdx,2),%r10
   259e0:	shl    $0x4,%r10
   259e4:	movups -0x30(%rdi,%r10,1),%xmm0
   259ea:	movaps %xmm0,-0x28(%rsp)
   259ef:	movups -0x20(%rdi,%r10,1),%xmm0
   259f5:	movaps %xmm0,-0x18(%rsp)
   259fa:	mov    %rcx,-0x48(%rsp)
   259ff:	mov    %rsi,-0x40(%rsp)
   25a04:	mov    %r8,-0x38(%rsp)
   25a09:	mov    %r9,-0x30(%rsp)
   25a0e:	movdqu -0x48(%rsp),%xmm0
   25a14:	movdqu -0x38(%rsp),%xmm1
   25a1a:	pcmpeqb -0x18(%rsp),%xmm1
   25a20:	pcmpeqb -0x28(%rsp),%xmm0
   25a26:	pand   %xmm1,%xmm0
   25a2a:	pmovmskb %xmm0,%ebx
   25a2e:	mov    0x20(%rax),%r11d
   25a32:	cmp    $0xffff,%ebx
   25a38:	jne    25a65 <<gpui_canvas::canvas::columns::Columns>::find_scope+0x145>
   25a3a:	add    %rdi,%r10
   25a3d:	mov    -0x8(%r10),%rbx
   25a41:	mov    0x24(%rax),%r14d
   25a45:	shl    $0x20,%r14
   25a49:	mov    %r11d,%r15d
   25a4c:	xor    0x28(%rax),%rbx
   25a50:	or     %r14,%r15
   25a53:	xor    -0x10(%r10),%r15
   25a57:	or     %rbx,%r15
   25a5a:	jne    25a65 <<gpui_canvas::canvas::columns::Columns>::find_scope+0x145>
   25a5c:	jmp    25b3a <<gpui_canvas::canvas::columns::Columns>::find_scope+0x21a>
   25a61:	mov    0x20(%rax),%r11d
   25a65:	mov    0x24(%rax),%ebx
   25a68:	mov    0x28(%rax),%rax
   25a6c:	shl    $0x20,%rbx
   25a70:	mov    %r11d,%r11d
   25a73:	or     %rbx,%r11
   25a76:	shl    $0x4,%rdx
   25a7a:	lea    (%rdx,%rdx,2),%rbx
   25a7e:	mov    $0xffffffffffffffe1,%r14
   25a85:	xor    %r15d,%r15d
   25a88:	xor    %edx,%edx
   25a8a:	mov    %rdi,%r12
   25a8d:	nopl   (%rax)
   25a90:	cmp    %r15,%rbx
   25a93:	je     25b41 <<gpui_canvas::canvas::columns::Columns>::find_scope+0x221>
   25a99:	movups (%r12),%xmm0
   25a9e:	movaps %xmm0,-0x28(%rsp)
   25aa3:	movups 0x10(%r12),%xmm0
   25aa9:	movaps %xmm0,-0x18(%rsp)
   25aae:	mov    %rcx,-0x48(%rsp)
   25ab3:	mov    %rsi,-0x40(%rsp)
   25ab8:	mov    %r8,-0x38(%rsp)
   25abd:	mov    %r9,-0x30(%rsp)
   25ac2:	movdqu -0x48(%rsp),%xmm0
   25ac8:	movdqu -0x38(%rsp),%xmm1
   25ace:	pcmpeqb -0x18(%rsp),%xmm1
   25ad4:	pcmpeqb -0x28(%rsp),%xmm0
   25ada:	pand   %xmm1,%xmm0
   25ade:	pmovmskb %xmm0,%ebp
   25ae2:	cmp    $0xffff,%ebp
   25ae8:	jne    25b05 <<gpui_canvas::canvas::columns::Columns>::find_scope+0x1e5>
   25aea:	mov    0x20(%rdi,%r15,1),%rbp
   25aef:	xor    %r11,%rbp
   25af2:	mov    0x28(%rdi,%r15,1),%r10
   25af7:	xor    %rax,%r10
   25afa:	mov    $0x1,%r13d
   25b00:	or     %rbp,%r10
   25b03:	je     25b0a <<gpui_canvas::canvas::columns::Columns>::find_scope+0x1ea>
   25b05:	inc    %edx
   25b07:	xor    %r13d,%r13d
   25b0a:	add    $0x30,%r12
   25b0e:	mov    $0x2,%ebp
   25b13:	sub    %r13,%rbp
   25b16:	test   %r14,%r14
   25b19:	cmove  %r13,%rbp
   25b1d:	inc    %r14
   25b20:	add    $0x30,%r15
   25b24:	cmp    $0x2,%rbp
   25b28:	je     25a90 <<gpui_canvas::canvas::columns::Columns>::find_scope+0x170>
   25b2e:	test   %rbp,%rbp
   25b31:	mov    $0x0,%eax
   25b36:	je     25b43 <<gpui_canvas::canvas::columns::Columns>::find_scope+0x223>
   25b38:	inc    %edx
   25b3a:	mov    $0x1,%eax
   25b3f:	jmp    25b43 <<gpui_canvas::canvas::columns::Columns>::find_scope+0x223>
   25b41:	xor    %eax,%eax
   25b43:	pop    %rbx
   25b44:	pop    %r12
   25b46:	pop    %r13
   25b48:	pop    %r14
   25b4a:	pop    %r15
   25b4c:	pop    %rbp
   25b4d:	ret


/tmp/gpui-paint-literal-cow-target/release/examples/canvas_literal_cow_storage:     file format elf64-x86-64


Disassembly of section .text:

0000000000025b50 <<gpui_canvas::canvas::columns::Columns>::find_literal>:
   25b50:	mov    %rdx,%rax
   25b53:	mov    %rsi,%rdx
   25b56:	mov    (%rax),%rcx
   25b59:	mov    0x8(%rax),%rsi
   25b5d:	mov    $0x1,%eax
   25b62:	movabs $0x3f80000000000000,%r8
   25b6c:	xor    %rsi,%r8
   25b6f:	or     %rcx,%r8
   25b72:	je     25b97 <<gpui_canvas::canvas::columns::Columns>::find_literal+0x47>
   25b74:	movabs $0x3f8000003f800000,%r8
   25b7e:	mov    %rcx,%r9
   25b81:	xor    %r8,%r9
   25b84:	xor    %rsi,%r8
   25b87:	or     %r9,%r8
   25b8a:	jne    25b9a <<gpui_canvas::canvas::columns::Columns>::find_literal+0x4a>
   25b8c:	mov    $0x1,%eax
   25b91:	mov    $0x1,%edx
   25b96:	ret
   25b97:	xor    %edx,%edx
   25b99:	ret
   25b9a:	xor    %r8d,%r8d
   25b9d:	mov    %rcx,%r9
   25ba0:	or     %rsi,%r9
   25ba3:	sete   %r9b
   25ba7:	je     25c54 <<gpui_canvas::canvas::columns::Columns>::find_literal+0x104>
   25bad:	test   %rdx,%rdx
   25bb0:	je     25be3 <<gpui_canvas::canvas::columns::Columns>::find_literal+0x93>
   25bb2:	lea    (%rdx,%rdx,2),%r8
   25bb6:	cmpw   $0x0,-0x8(%rdi,%r8,8)
   25bbd:	js     25be3 <<gpui_canvas::canvas::columns::Columns>::find_literal+0x93>
   25bbf:	cmpw   $0x0,-0x2(%rdi,%r8,8)
   25bc6:	js     25be3 <<gpui_canvas::canvas::columns::Columns>::find_literal+0x93>
   25bc8:	lea    (%rdi,%r8,8),%r8
   25bcc:	mov    -0x18(%r8),%r9
   25bd0:	xor    %rcx,%r9
   25bd3:	mov    -0x10(%r8),%r8
   25bd7:	xor    %rsi,%r8
   25bda:	or     %r9,%r8
   25bdd:	jne    25be3 <<gpui_canvas::canvas::columns::Columns>::find_literal+0x93>
   25bdf:	add    $0x2,%edx
   25be2:	ret
   25be3:	push   %r14
   25be5:	push   %rbx
   25be6:	shl    $0x3,%rdx
   25bea:	lea    (%rdx,%rdx,2),%r8
   25bee:	xor    %eax,%eax
   25bf0:	mov    $0xffffffffffffffe1,%r9
   25bf7:	xor    %r10d,%r10d
   25bfa:	xor    %edx,%edx
   25bfc:	jmp    25c21 <<gpui_canvas::canvas::columns::Columns>::find_literal+0xd1>
   25bfe:	xchg   %ax,%ax
   25c00:	inc    %edx
   25c02:	xor    %r11d,%r11d
   25c05:	mov    $0x2,%ebx
   25c0a:	sub    %r11,%rbx
   25c0d:	test   %r9,%r9
   25c10:	cmove  %r11,%rbx
   25c14:	inc    %r9
   25c17:	add    $0x18,%r10
   25c1b:	cmp    $0x2,%rbx
   25c1f:	jne    25c60 <<gpui_canvas::canvas::columns::Columns>::find_literal+0x110>
   25c21:	cmp    %r10,%r8
   25c24:	je     25c71 <<gpui_canvas::canvas::columns::Columns>::find_literal+0x121>
   25c26:	cmpw   $0x0,0x10(%rdi,%r10,1)
   25c2d:	js     25c00 <<gpui_canvas::canvas::columns::Columns>::find_literal+0xb0>
   25c2f:	cmpw   $0x0,0x16(%rdi,%r10,1)
   25c36:	js     25c00 <<gpui_canvas::canvas::columns::Columns>::find_literal+0xb0>
   25c38:	mov    (%rdi,%r10,1),%rbx
   25c3c:	xor    %rcx,%rbx
   25c3f:	mov    0x8(%rdi,%r10,1),%r14
   25c44:	xor    %rsi,%r14
   25c47:	mov    $0x1,%r11d
   25c4d:	or     %rbx,%r14
   25c50:	jne    25c00 <<gpui_canvas::canvas::columns::Columns>::find_literal+0xb0>
   25c52:	jmp    25c05 <<gpui_canvas::canvas::columns::Columns>::find_literal+0xb5>
   25c54:	mov    %r9b,%r8b
   25c57:	mov    $0x2,%edx
   25c5c:	mov    %r8d,%eax
   25c5f:	ret
   25c60:	test   %rbx,%rbx
   25c63:	je     25c6d <<gpui_canvas::canvas::columns::Columns>::find_literal+0x11d>
   25c65:	add    $0x3,%edx
   25c68:	mov    $0x1,%eax
   25c6d:	pop    %rbx
   25c6e:	pop    %r14
   25c70:	ret
   25c71:	pop    %rbx
   25c72:	pop    %r14
   25c74:	ret


/tmp/gpui-paint-literal-cow-target/release/examples/canvas_literal_cow_storage:     file format elf64-x86-64


Disassembly of section .text:

0000000000025c80 <<gpui_canvas::canvas::columns::Columns>::admit>:
   25c80:	push   %rbp
   25c81:	push   %r15
   25c83:	push   %r14
   25c85:	push   %r13
   25c87:	push   %r12
   25c89:	push   %rbx
   25c8a:	sub    $0x68,%rsp
   25c8e:	mov    %r9d,%ebp
   25c91:	mov    %r8d,%r15d
   25c94:	mov    %ecx,%r12d
   25c97:	mov    %rdx,%rcx
   25c9a:	mov    %rsi,%r14
   25c9d:	mov    %rdi,%rax
   25ca0:	movups 0x10(%rsi),%xmm0
   25ca4:	movaps %xmm0,0x30(%rsp)
   25ca9:	movups 0x20(%rsi),%xmm0
   25cad:	movaps %xmm0,0x40(%rsp)
   25cb2:	movups (%rsi),%xmm0
   25cb5:	movaps %xmm0,0x50(%rsp)
   25cba:	mov    0x8(%rdi),%rdi
   25cbe:	mov    %rax,%rbx
   25cc1:	mov    0x10(%rax),%rsi
   25cc5:	lea    0x30(%rsp),%rdx
   25cca:	mov    %rdi,0x8(%rsp)
   25ccf:	mov    %rsi,0x10(%rsp)
   25cd4:	call   25920 <<gpui_canvas::canvas::columns::Columns>::find_scope>
   25cd9:	mov    %eax,%r13d
   25cdc:	or     %ebp,%r15d
   25cdf:	jne    25d49 <<gpui_canvas::canvas::columns::Columns>::admit+0xc9>
   25ce1:	test   %r12d,%r12d
   25ce4:	je     25d2e <<gpui_canvas::canvas::columns::Columns>::admit+0xae>
   25ce6:	add    $0xfffffffd,%r12d
   25cea:	mov    $0x1,%eax
   25cef:	cmp    %r12,0x28(%rbx)
   25cf3:	mov    0x10(%rsp),%r10
   25cf8:	jbe    25e12 <<gpui_canvas::canvas::columns::Columns>::admit+0x192>
   25cfe:	cmp    $0x1,%r13d
   25d02:	sete   %dl
   25d05:	mov    0x20(%rbx),%rcx
   25d09:	lea    (%r12,%r12,2),%rsi
   25d0d:	xor    %eax,%eax
   25d0f:	cmpw   $0x0,0x10(%rcx,%rsi,8)
   25d15:	setns  %cl
   25d18:	or     %cl,%dl
   25d1a:	je     25dfa <<gpui_canvas::canvas::columns::Columns>::admit+0x17a>
   25d20:	mov    %cl,%al
   25d22:	lea    -0x1(,%rax,2),%eax
   25d29:	jmp    25e12 <<gpui_canvas::canvas::columns::Columns>::admit+0x192>
   25d2e:	add    $0x40,%r14
   25d32:	mov    0x20(%rbx),%rdi
   25d36:	mov    0x28(%rbx),%rsi
   25d3a:	mov    %r14,%rdx
   25d3d:	call   25b50 <<gpui_canvas::canvas::columns::Columns>::find_literal>
   25d42:	cmp    $0x1,%eax
   25d45:	setne  %bpl
   25d49:	cmp    $0x1,%r13d
   25d4d:	jne    25d74 <<gpui_canvas::canvas::columns::Columns>::admit+0xf4>
   25d4f:	mov    $0xffffffff,%eax
   25d54:	test   %bpl,%bpl
   25d57:	je     25e12 <<gpui_canvas::canvas::columns::Columns>::admit+0x192>
   25d5d:	mov    0x28(%rbx),%rsi
   25d61:	mov    $0x7,%eax
   25d66:	cmp    $0x1ffff,%rsi
   25d6d:	jbe    25da6 <<gpui_canvas::canvas::columns::Columns>::admit+0x126>
   25d6f:	jmp    25e12 <<gpui_canvas::canvas::columns::Columns>::admit+0x192>
   25d74:	mov    $0x7,%eax
   25d79:	mov    0x10(%rsp),%r10
   25d7e:	cmp    $0x1ffff,%r10
   25d85:	ja     25e12 <<gpui_canvas::canvas::columns::Columns>::admit+0x192>
   25d8b:	test   %bpl,%bpl
   25d8e:	je     25e08 <<gpui_canvas::canvas::columns::Columns>::admit+0x188>
   25d90:	mov    0x28(%rbx),%rsi
   25d94:	cmp    $0x1ffff,%rsi
   25d9b:	ja     25e12 <<gpui_canvas::canvas::columns::Columns>::admit+0x192>
   25d9d:	cmp    %r10,(%rbx)
   25da0:	je     25e6e <<gpui_canvas::canvas::columns::Columns>::admit+0x1ee>
   25da6:	mov    $0xffffffff,%eax
   25dab:	cmp    %rsi,0x18(%rbx)
   25daf:	jne    25e12 <<gpui_canvas::canvas::columns::Columns>::admit+0x192>
   25db1:	lea    (%rsi,%rsi,1),%rax
   25db5:	cmp    $0x5,%rax
   25db9:	mov    $0x4,%r14d
   25dbf:	cmovae %rax,%r14
   25dc3:	mov    0x20(%rbx),%rdx
   25dc7:	lea    0x18(%rsp),%rdi
   25dcc:	mov    $0x4,%r8d
   25dd2:	mov    $0x18,%r9d
   25dd8:	mov    %r14,%rcx
   25ddb:	call   265f0 <<alloc::raw_vec::RawVecInner>::finish_grow>
   25de0:	cmpl   $0x1,0x18(%rsp)
   25de5:	je     25eab <<gpui_canvas::canvas::columns::Columns>::admit+0x22b>
   25deb:	mov    0x20(%rsp),%rax
   25df0:	mov    %rax,0x20(%rbx)
   25df4:	mov    %r14,0x18(%rbx)
   25df8:	jmp    25e67 <<gpui_canvas::canvas::columns::Columns>::admit+0x1e7>
   25dfa:	mov    $0x7,%eax
   25dff:	cmp    $0x1ffff,%r10
   25e06:	ja     25e12 <<gpui_canvas::canvas::columns::Columns>::admit+0x192>
   25e08:	mov    $0xffffffff,%eax
   25e0d:	cmp    %r10,(%rbx)
   25e10:	je     25e21 <<gpui_canvas::canvas::columns::Columns>::admit+0x1a1>
   25e12:	add    $0x68,%rsp
   25e16:	pop    %rbx
   25e17:	pop    %r12
   25e19:	pop    %r13
   25e1b:	pop    %r14
   25e1d:	pop    %r15
   25e1f:	pop    %rbp
   25e20:	ret
   25e21:	lea    (%r10,%r10,1),%rax
   25e25:	cmp    $0x5,%rax
   25e29:	mov    $0x4,%r14d
   25e2f:	cmovae %rax,%r14
   25e33:	lea    0x18(%rsp),%rdi
   25e38:	mov    $0x8,%r8d
   25e3e:	mov    $0x30,%r9d
   25e44:	mov    %r10,%rsi
   25e47:	mov    0x8(%rsp),%rdx
   25e4c:	mov    %r14,%rcx
   25e4f:	call   265f0 <<alloc::raw_vec::RawVecInner>::finish_grow>
   25e54:	cmpl   $0x1,0x18(%rsp)
   25e59:	je     25eab <<gpui_canvas::canvas::columns::Columns>::admit+0x22b>
   25e5b:	mov    0x20(%rsp),%rax
   25e60:	mov    %rax,0x8(%rbx)
   25e64:	mov    %r14,(%rbx)
   25e67:	mov    $0xffffffff,%eax
   25e6c:	jmp    25e12 <<gpui_canvas::canvas::columns::Columns>::admit+0x192>
   25e6e:	mov    %rsi,%r15
   25e71:	lea    (%r10,%r10,1),%rax
   25e75:	cmp    $0x5,%rax
   25e79:	mov    $0x4,%r14d
   25e7f:	cmovae %rax,%r14
   25e83:	lea    0x18(%rsp),%rdi
   25e88:	mov    $0x8,%r8d
   25e8e:	mov    $0x30,%r9d
   25e94:	mov    %r10,%rsi
   25e97:	mov    0x8(%rsp),%rdx
   25e9c:	mov    %r14,%rcx
   25e9f:	call   265f0 <<alloc::raw_vec::RawVecInner>::finish_grow>
   25ea4:	cmpl   $0x1,0x18(%rsp)
   25ea9:	jne    25eb5 <<gpui_canvas::canvas::columns::Columns>::admit+0x235>
   25eab:	mov    $0x7,%eax
   25eb0:	jmp    25e12 <<gpui_canvas::canvas::columns::Columns>::admit+0x192>
   25eb5:	mov    0x20(%rsp),%rax
   25eba:	mov    %rax,0x8(%rbx)
   25ebe:	mov    %r14,(%rbx)
   25ec1:	mov    %r15,%rsi
   25ec4:	mov    $0xffffffff,%eax
   25ec9:	cmp    %rsi,0x18(%rbx)
   25ecd:	jne    25e12 <<gpui_canvas::canvas::columns::Columns>::admit+0x192>
   25ed3:	jmp    25db1 <<gpui_canvas::canvas::columns::Columns>::admit+0x131>


/tmp/gpui-paint-literal-cow-target/release/examples/canvas_literal_cow_storage:     file format elf64-x86-64


Disassembly of section .text:

0000000000025ee0 <<gpui_canvas::canvas::columns::Columns>::store>:
   25ee0:	push   %rbp
   25ee1:	push   %r15
   25ee3:	push   %r14
   25ee5:	push   %r13
   25ee7:	push   %r12
   25ee9:	push   %rbx
   25eea:	sub    $0x68,%rsp
   25eee:	mov    %r9d,0x8(%rsp)
   25ef3:	mov    %r8d,%r12d
   25ef6:	mov    %rdx,%r14
   25ef9:	mov    %rsi,%r13
   25efc:	mov    %rdi,%rbx
   25eff:	movups 0x10(%rdx),%xmm0
   25f03:	movups 0x20(%rdx),%xmm1
   25f07:	movaps %xmm0,0x20(%rsp)
   25f0c:	movaps %xmm0,0x30(%rsp)
   25f11:	movaps %xmm1,0x10(%rsp)
   25f16:	movaps %xmm1,0x40(%rsp)
   25f1b:	movups (%rdx),%xmm0
   25f1e:	movaps %xmm0,0x50(%rsp)
   25f23:	mov    0x8(%rsi),%rbp
   25f27:	mov    0x10(%rsi),%r15
   25f2b:	lea    0x30(%rsp),%rdx
   25f30:	mov    %rbp,%rdi
   25f33:	mov    %r15,%rsi
   25f36:	call   25920 <<gpui_canvas::canvas::columns::Columns>::find_scope>
   25f3b:	cmp    $0x1,%eax
   25f3e:	jne    25f8b <<gpui_canvas::canvas::columns::Columns>::store+0xab>
   25f40:	mov    %edx,%r15d
   25f43:	cmpb   $0x0,0x8(%rsp)
   25f48:	jne    25fd9 <<gpui_canvas::canvas::columns::Columns>::store+0xf9>
   25f4e:	test   %r12d,%r12d
   25f51:	je     25fff <<gpui_canvas::canvas::columns::Columns>::store+0x11f>
   25f57:	lea    -0x3(%r12),%eax
   25f5c:	cmp    %rax,0x28(%r13)
   25f60:	jbe    25f72 <<gpui_canvas::canvas::columns::Columns>::store+0x92>
   25f62:	mov    0x20(%r13),%rcx
   25f66:	lea    (%rax,%rax,2),%rax
   25f6a:	cmpw   $0x0,0x10(%rcx,%rax,8)
   25f70:	js     25fdd <<gpui_canvas::canvas::columns::Columns>::store+0xfd>
   25f72:	lea    -0x14159(%rip),%rdi        # 11e20 <anon.4bc9a8aded1828b5aacef6067e9ce7e4.21.llvm.142944099067357268+0x28>
   25f79:	lea    0x40998(%rip),%rdx        # 66918 <anon.1b47f9689b13eef5e211c3e45b09cbe4.20.llvm.3702241586056294072+0x18>
   25f80:	mov    $0x1d,%esi
   25f85:	call   *0x42b85(%rip)        # 68b10 <_DYNAMIC+0x458>
   25f8b:	cmp    0x0(%r13),%r15
   25f8f:	jne    25f9e <<gpui_canvas::canvas::columns::Columns>::store+0xbe>
   25f91:	mov    %r13,%rdi
   25f94:	call   *0x42be6(%rip)        # 68b80 <_DYNAMIC+0x4c8>
   25f9a:	mov    0x8(%r13),%rbp
   25f9e:	lea    (%r15,%r15,2),%rax
   25fa2:	shl    $0x4,%rax
   25fa6:	movaps 0x20(%rsp),%xmm0
   25fab:	movups %xmm0,0x0(%rbp,%rax,1)
   25fb0:	movaps 0x10(%rsp),%xmm0
   25fb5:	movups %xmm0,0x10(%rbp,%rax,1)
   25fba:	movups (%r14),%xmm0
   25fbe:	movups %xmm0,0x20(%rbp,%rax,1)
   25fc3:	lea    0x1(%r15),%rax
   25fc7:	mov    %rax,0x10(%r13)
   25fcb:	inc    %r15d
   25fce:	cmpb   $0x0,0x8(%rsp)
   25fd3:	je     25f4e <<gpui_canvas::canvas::columns::Columns>::store+0x6e>
   25fd9:	mov    0x40(%r14),%r12d
   25fdd:	movups 0x30(%r14),%xmm0
   25fe2:	movups %xmm0,(%rbx)
   25fe5:	mov    %r15d,0x10(%rbx)
   25fe9:	mov    %r12d,0x14(%rbx)
   25fed:	mov    %rbx,%rax
   25ff0:	add    $0x68,%rsp
   25ff4:	pop    %rbx
   25ff5:	pop    %r12
   25ff7:	pop    %r13
   25ff9:	pop    %r14
   25ffb:	pop    %r15
   25ffd:	pop    %rbp
   25ffe:	ret
   25fff:	lea    0x40(%r14),%rdx
   26003:	mov    0x20(%r13),%rdi
   26007:	mov    0x28(%r13),%rbp
   2600b:	mov    %rdi,0x8(%rsp)
   26010:	mov    %rbp,%rsi
   26013:	call   25b50 <<gpui_canvas::canvas::columns::Columns>::find_literal>
   26018:	cmp    $0x1,%eax
   2601b:	jne    26040 <<gpui_canvas::canvas::columns::Columns>::store+0x160>
   2601d:	mov    %edx,%r12d
   26020:	cmp    $0x2,%edx
   26023:	jbe    25fdd <<gpui_canvas::canvas::columns::Columns>::store+0xfd>
   26025:	mov    %r12d,%edi
   26028:	add    $0xfffffffd,%edi
   2602b:	cmp    %rdi,%rbp
   2602e:	jbe    2608b <<gpui_canvas::canvas::columns::Columns>::store+0x1ab>
   26030:	lea    (%rdi,%rdi,2),%rax
   26034:	mov    0x8(%rsp),%rcx
   26039:	orb    $0x80,0x15(%rcx,%rax,8)
   2603e:	jmp    25fdd <<gpui_canvas::canvas::columns::Columns>::store+0xfd>
   26040:	cmp    0x18(%r13),%rbp
   26044:	mov    0x8(%rsp),%rcx
   26049:	jne    26059 <<gpui_canvas::canvas::columns::Columns>::store+0x179>
   2604b:	lea    0x18(%r13),%rdi
   2604f:	call   *0x42b23(%rip)        # 68b78 <_DYNAMIC+0x4c0>
   26055:	mov    0x20(%r13),%rcx
   26059:	lea    0x0(,%rbp,2),%rax
   26061:	add    %rbp,%rax
   26064:	lea    0x40(%r14),%rdx
   26068:	movups (%rdx),%xmm0
   2606b:	movups %xmm0,(%rcx,%rax,8)
   2606f:	movq   $0x0,0x10(%rcx,%rax,8)
   26078:	lea    0x1(%rbp),%rax
   2607c:	mov    %rax,0x28(%r13)
   26080:	add    $0x3,%ebp
   26083:	mov    %ebp,%r12d
   26086:	jmp    25fdd <<gpui_canvas::canvas::columns::Columns>::store+0xfd>
   2608b:	lea    0x4089e(%rip),%rdx        # 66930 <anon.1b47f9689b13eef5e211c3e45b09cbe4.20.llvm.3702241586056294072+0x30>
   26092:	mov    %rbp,%rsi
   26095:	call   *0x42945(%rip)        # 689e0 <_DYNAMIC+0x328>


/tmp/gpui-paint-literal-cow-target/release/examples/canvas_literal_cow_storage:     file format elf64-x86-64


Disassembly of section .text:

00000000000260a0 <<gpui_canvas::canvas::columns::Columns>::support>:
   260a0:	push   %r15
   260a2:	push   %r14
   260a4:	push   %r12
   260a6:	push   %rbx
   260a7:	sub    $0x28,%rsp
   260ab:	cmp    $0x3,%esi
   260ae:	jb     261cc <<gpui_canvas::canvas::columns::Columns>::support+0x12c>
   260b4:	add    $0xfffffffd,%esi
   260b7:	mov    0x28(%rdi),%rax
   260bb:	cmp    %rsi,%rax
   260be:	jbe    261d8 <<gpui_canvas::canvas::columns::Columns>::support+0x138>
   260c4:	mov    %ecx,%ebx
   260c6:	mov    %rdx,%r14
   260c9:	mov    0x20(%rdi),%rax
   260cd:	lea    (%rsi,%rsi,2),%rcx
   260d1:	lea    (%rax,%rcx,8),%r15
   260d5:	mov    0x10(%rax,%rcx,8),%rax
   260da:	movabs $0x8000800080008000,%r12
   260e4:	and    %rax,%r12
   260e7:	mov    %eax,%ecx
   260e9:	shr    $0x10,%ecx
   260ec:	mov    %rax,%rdx
   260ef:	shr    $0x20,%rdx
   260f3:	mov    %rax,%rsi
   260f6:	shr    $0x30,%rsi
   260fa:	and    $0x7fff,%eax
   260ff:	and    $0x7fff,%ecx
   26105:	and    $0x7fff,%edx
   2610b:	and    $0x7fff,%esi
   26111:	mov    %rax,0x8(%rsp)
   26116:	mov    %rcx,0x10(%rsp)
   2611b:	mov    %rdx,0x18(%rsp)
   26120:	mov    %rsi,0x20(%rsp)
   26125:	lea    0x8(%rsp),%rdi
   2612a:	call   23490 <<[usize; 4]>::try_map::<core::ops::try_trait::NeverShortCircuit<u16>, <core::ops::try_trait::NeverShortCircuit<u16>>::wrap_mut_1<usize, <gpui_canvas::damage::DamageRegion>::checked_canvas_bounds::{closure#0}>::{closure#0}>>
   2612f:	mov    %rax,%rdx
   26132:	shr    $0x20,%rdx
   26136:	cmp    %dx,%ax
   26139:	je     261a7 <<gpui_canvas::canvas::columns::Columns>::support+0x107>
   2613b:	mov    %eax,%ecx
   2613d:	shr    $0x10,%ecx
   26140:	mov    %rax,%rsi
   26143:	shr    $0x30,%rsi
   26147:	cmp    %si,%cx
   2614a:	je     261a7 <<gpui_canvas::canvas::columns::Columns>::support+0x107>
   2614c:	mov    %r14,%rdi
   2614f:	shr    $0x20,%rdi
   26153:	cmp    %di,%r14w
   26157:	je     261aa <<gpui_canvas::canvas::columns::Columns>::support+0x10a>
   26159:	mov    %r14d,%r9d
   2615c:	shr    $0x10,%r9d
   26160:	mov    %r14,%r8
   26163:	shr    $0x30,%r8
   26167:	cmp    %r8w,%r9w
   2616b:	je     261aa <<gpui_canvas::canvas::columns::Columns>::support+0x10a>
   2616d:	cmp    %ax,%r14w
   26171:	cmovb  %r14d,%eax
   26175:	cmp    %cx,%r9w
   26179:	cmovb  %r9d,%ecx
   2617d:	cmp    %dx,%di
   26180:	cmova  %edi,%edx
   26183:	cmp    %si,%r8w
   26187:	cmova  %r8d,%esi
   2618b:	shl    $0x30,%rsi
   2618f:	movzwl %dx,%edx
   26192:	shl    $0x20,%rdx
   26196:	or     %rsi,%rdx
   26199:	shl    $0x10,%ecx
   2619c:	or     %rdx,%rcx
   2619f:	movzwl %ax,%eax
   261a2:	or     %rcx,%rax
   261a5:	jmp    261aa <<gpui_canvas::canvas::columns::Columns>::support+0x10a>
   261a7:	mov    %r14,%rax
   261aa:	or     %r12,%rax
   261ad:	mov    %ax,0x10(%r15)
   261b2:	mov    %eax,%ecx
   261b4:	shr    $0x10,%ecx
   261b7:	shr    $0x20,%rax
   261bb:	mov    %eax,0x14(%r15)
   261bf:	movzbl %bl,%eax
   261c2:	shl    $0xf,%eax
   261c5:	or     %ecx,%eax
   261c7:	mov    %ax,0x12(%r15)
   261cc:	add    $0x28,%rsp
   261d0:	pop    %rbx
   261d1:	pop    %r12
   261d3:	pop    %r14
   261d5:	pop    %r15
   261d7:	ret
   261d8:	lea    0x40781(%rip),%rdx        # 66960 <anon.1b47f9689b13eef5e211c3e45b09cbe4.26.llvm.3702241586056294072>
   261df:	mov    %rsi,%rdi
   261e2:	mov    %rax,%rsi
   261e5:	call   *0x427f5(%rip)        # 689e0 <_DYNAMIC+0x328>


/tmp/gpui-paint-literal-cow-target/release/examples/canvas_literal_cow_storage:     file format elf64-x86-64


Disassembly of section .text:

0000000000021f40 <<gpui_canvas::canvas::Canvas>::fill_shape>:
   21f40:	push   %rbp
   21f41:	push   %r15
   21f43:	push   %r14
   21f45:	push   %r13
   21f47:	push   %r12
   21f49:	push   %rbx
   21f4a:	sub    $0xf8,%rsp
   21f51:	mov    %r9d,%ebp
   21f54:	mov    %r8,%r14
   21f57:	mov    %rcx,%r13
   21f5a:	mov    %rdx,%r15
   21f5d:	mov    %rsi,%r12
   21f60:	mov    %rdi,%rbx
   21f63:	mov    %rcx,%rdi
   21f66:	call   *0x46b34(%rip)        # 68aa0 <_DYNAMIC+0x3e8>
   21f6c:	mov    %eax,%ecx
   21f6e:	mov    $0x1,%eax
   21f73:	test   %cl,%cl
   21f75:	je     21f8d <<gpui_canvas::canvas::Canvas>::fill_shape+0x4d>
   21f77:	movss  0x0(%r13),%xmm0
   21f7d:	andps  -0x11fc4(%rip),%xmm0        # ffc0 <GCC_except_table0+0x328>
   21f84:	ucomiss -0x11e33(%rip),%xmm0        # 10158 <GCC_except_table0+0x4c0>
   21f8b:	jbe    21f9f <<gpui_canvas::canvas::Canvas>::fill_shape+0x5f>
   21f8d:	add    $0xf8,%rsp
   21f94:	pop    %rbx
   21f95:	pop    %r12
   21f97:	pop    %r13
   21f99:	pop    %r14
   21f9b:	pop    %r15
   21f9d:	pop    %rbp
   21f9e:	ret
   21f9f:	movsd  0x4(%r13),%xmm0
   21fa5:	movaps -0x11fec(%rip),%xmm1        # ffc0 <GCC_except_table0+0x328>
   21fac:	andps  %xmm1,%xmm0
   21faf:	movaps -0x11f86(%rip),%xmm2        # 10030 <GCC_except_table0+0x398>
   21fb6:	cmpltps %xmm0,%xmm2
   21fba:	unpcklps %xmm2,%xmm2
   21fbd:	movmskpd %xmm2,%ecx
   21fc1:	test   %ecx,%ecx
   21fc3:	setne  %cl
   21fc6:	movss  0xc(%r13),%xmm0
   21fcc:	andps  %xmm1,%xmm0
   21fcf:	ucomiss -0x11e7e(%rip),%xmm0        # 10158 <GCC_except_table0+0x4c0>
   21fd6:	ja     21f8d <<gpui_canvas::canvas::Canvas>::fill_shape+0x4d>
   21fd8:	test   %cl,%cl
   21fda:	jne    21f8d <<gpui_canvas::canvas::Canvas>::fill_shape+0x4d>
   21fdc:	lea    0x8(%rsp),%rdi
   21fe1:	mov    %r15,%rsi
   21fe4:	call   20e20 <<gpui_canvas::canvas::Mapping>::new>
   21fe9:	cmpl   $0x1,0x8(%rsp)
   21fee:	jne    21ffa <<gpui_canvas::canvas::Canvas>::fill_shape+0xba>
   21ff0:	mov    0xc(%rsp),%eax
   21ff4:	mov    0x10(%rsp),%edx
   21ff8:	jmp    21f8d <<gpui_canvas::canvas::Canvas>::fill_shape+0x4d>
   21ffa:	mov    0x10(%rsp),%eax
   21ffe:	movups 0x14(%rsp),%xmm0
   22003:	movups %xmm0,0xb4(%rsp)
   2200b:	movups 0x24(%rsp),%xmm0
   22010:	movups %xmm0,0xc4(%rsp)
   22018:	movups 0x30(%rsp),%xmm0
   2201d:	movups %xmm0,0xd0(%rsp)
   22025:	movups 0x0(%r13),%xmm0
   2202a:	movaps %xmm0,0xa0(%rsp)
   22032:	mov    %eax,0xb0(%rsp)
   22039:	movups (%r14),%xmm0
   2203d:	movaps %xmm0,0xe0(%rsp)
   22045:	mov    0x1a8(%rbx),%r13
   2204c:	mov    0x1b0(%rbx),%rax
   22053:	mov    %ebp,(%rsp)
   22056:	mov    %rax,%rbp
   22059:	lea    0x8(%rsp),%rdi
   2205e:	lea    0xa0(%rsp),%r9
   22066:	mov    %r13,%rsi
   22069:	mov    %rax,%rdx
   2206c:	mov    %r12,%rcx
   2206f:	mov    %r15,%r8
   22072:	call   22d50 <<gpui_canvas::canvas::Canvas>::prepare>
   22077:	mov    0x8(%rsp),%esi
   2207b:	mov    0xc(%rsp),%ecx
   2207f:	mov    0x10(%rsp),%edx
   22083:	cmp    $0x2,%esi
   22086:	jne    2208f <<gpui_canvas::canvas::Canvas>::fill_shape+0x14f>
   22088:	mov    %ecx,%eax
   2208a:	jmp    21f8d <<gpui_canvas::canvas::Canvas>::fill_shape+0x4d>
   2208f:	mov    0x24(%rsp),%eax
   22093:	mov    %eax,0x80(%rsp)
   2209a:	movups 0x14(%rsp),%xmm0
   2209f:	movaps %xmm0,0x70(%rsp)
   220a4:	mov    $0xffffffff,%eax
   220a9:	cmp    $0x1,%esi
   220ac:	jne    21f8d <<gpui_canvas::canvas::Canvas>::fill_shape+0x4d>
   220b2:	mov    %ecx,0x54(%rsp)
   220b6:	mov    %edx,0x58(%rsp)
   220ba:	movaps 0x70(%rsp),%xmm0
   220bf:	movups %xmm0,0x5c(%rsp)
   220c4:	mov    0x80(%rsp),%eax
   220cb:	mov    %eax,0x6c(%rsp)
   220cf:	test   %r13,%r13
   220d2:	js     220de <<gpui_canvas::canvas::Canvas>::fill_shape+0x19e>
   220d4:	xorps  %xmm0,%xmm0
   220d7:	cvtsi2ss %r13,%xmm0
   220dc:	jmp    220f7 <<gpui_canvas::canvas::Canvas>::fill_shape+0x1b7>
   220de:	mov    %r13,%rax
   220e1:	shr    $1,%rax
   220e4:	and    $0x1,%r13d
   220e8:	or     %rax,%r13
   220eb:	xorps  %xmm0,%xmm0
   220ee:	cvtsi2ss %r13,%xmm0
   220f3:	addss  %xmm0,%xmm0
   220f7:	mov    0x130(%rsp),%r15
   220ff:	test   %rbp,%rbp
   22102:	js     2210b <<gpui_canvas::canvas::Canvas>::fill_shape+0x1cb>
   22104:	cvtsi2ss %rbp,%xmm1
   22109:	jmp    22120 <<gpui_canvas::canvas::Canvas>::fill_shape+0x1e0>
   2210b:	mov    %rbp,%rax
   2210e:	shr    $1,%rax
   22111:	and    $0x1,%ebp
   22114:	or     %rax,%rbp
   22117:	cvtsi2ss %rbp,%xmm1
   2211c:	addss  %xmm1,%xmm1
   22120:	lea    0xb8(%rbx),%r12
   22127:	movq   $0x0,0x8(%rsp)
   22130:	movss  %xmm0,0x10(%rsp)
   22136:	movss  %xmm1,0x14(%rsp)
   2213c:	mov    (%r15),%ecx
   2213f:	test   %ecx,%ecx
   22141:	je     2214c <<gpui_canvas::canvas::Canvas>::fill_shape+0x20c>
   22143:	cmp    $0x1,%ecx
   22146:	jne    22150 <<gpui_canvas::canvas::Canvas>::fill_shape+0x210>
   22148:	mov    0x4(%r15),%ecx
   2214c:	xor    %eax,%eax
   2214e:	jmp    2215b <<gpui_canvas::canvas::Canvas>::fill_shape+0x21b>
   22150:	mov    0x8(%r15),%rax
   22154:	mov    (%rax),%ecx
   22156:	test   %ecx,%ecx
   22158:	sete   %al
   2215b:	movzbl %al,%r9d
   2215f:	lea    0xa0(%rsp),%rsi
   22167:	lea    0x8(%rsp),%rdx
   2216c:	mov    %r12,%rdi
   2216f:	xor    %r8d,%r8d
   22172:	call   25c80 <<gpui_canvas::canvas::columns::Columns>::admit>
   22177:	cmp    $0xffffffff,%eax
   2217a:	jne    21f8d <<gpui_canvas::canvas::Canvas>::fill_shape+0x4d>
   22180:	lea    0x54(%rsp),%rsi
   22185:	mov    $0x1,%edx
   2218a:	mov    $0x8,%ecx
   2218f:	mov    %rbx,%rdi
   22192:	xor    %r8d,%r8d
   22195:	xor    %r9d,%r9d
   22198:	call   222a0 <<gpui_canvas::canvas::Canvas>::admit>
   2219d:	cmp    $0xffffffff,%eax
   221a0:	jne    21f8d <<gpui_canvas::canvas::Canvas>::fill_shape+0x4d>
   221a6:	mov    %r15,%rdi
   221a9:	mov    %r12,%rsi
   221ac:	mov    %r14,%rdx
   221af:	call   26210 <<gpui_canvas::canvas::columns::PaintUse>::commit>
   221b4:	movups 0x54(%rsp),%xmm0
   221b9:	movups 0x60(%rsp),%xmm1
   221be:	movups %xmm1,0x18(%rsp)
   221c3:	movups %xmm0,0xc(%rsp)
   221c8:	movl   $0x1,0x8(%rsp)
   221d0:	movq   $0x0,0x88(%rsp)
   221dc:	movq   $0x8,0x90(%rsp)
   221e8:	movq   $0x0,0x98(%rsp)
   221f4:	mov    0x1a8(%rbx),%rdx
   221fb:	mov    0x1b0(%rbx),%rcx
   22202:	test   %rdx,%rdx
   22205:	js     22211 <<gpui_canvas::canvas::Canvas>::fill_shape+0x2d1>
   22207:	xorps  %xmm0,%xmm0
   2220a:	cvtsi2ss %rdx,%xmm0
   2220f:	jmp    22229 <<gpui_canvas::canvas::Canvas>::fill_shape+0x2e9>
   22211:	mov    %rdx,%rsi
   22214:	shr    $1,%rsi
   22217:	and    $0x1,%edx
   2221a:	or     %rsi,%rdx
   2221d:	xorps  %xmm0,%xmm0
   22220:	cvtsi2ss %rdx,%xmm0
   22225:	addss  %xmm0,%xmm0
   22229:	test   %rcx,%rcx
   2222c:	js     22238 <<gpui_canvas::canvas::Canvas>::fill_shape+0x2f8>
   2222e:	xorps  %xmm1,%xmm1
   22231:	cvtsi2ss %rcx,%xmm1
   22236:	jmp    22250 <<gpui_canvas::canvas::Canvas>::fill_shape+0x310>
   22238:	mov    %rcx,%rdx
   2223b:	shr    $1,%rdx
   2223e:	and    $0x1,%ecx
   22241:	or     %rdx,%rcx
   22244:	xorps  %xmm1,%xmm1
   22247:	cvtsi2ss %rcx,%xmm1
   2224c:	addss  %xmm1,%xmm1
   22250:	movq   $0x0,0x40(%rsp)
   22259:	movss  %xmm0,0x48(%rsp)
   2225f:	movss  %xmm1,0x4c(%rsp)
   22265:	lea    0xa0(%rsp),%rsi
   2226d:	lea    0x8(%rsp),%rdx
   22272:	lea    0x88(%rsp),%rcx
   2227a:	lea    0x40(%rsp),%r8
   2227f:	mov    %rbx,%rdi
   22282:	mov    %eax,%r9d
   22285:	call   20880 <<gpui_canvas::canvas::DisplayList>::append::<core::iter::sources::once::Once<gpui_canvas::canvas::PendingDraw>>>
   2228a:	movb   $0x1,0x1e0(%rbx)
   22291:	mov    $0xffffffff,%eax
   22296:	jmp    21f8d <<gpui_canvas::canvas::Canvas>::fill_shape+0x4d>
