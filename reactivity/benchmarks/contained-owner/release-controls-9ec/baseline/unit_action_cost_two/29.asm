
/tmp/gpui-contained-owner-unit-baseline-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

00000000007088c0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action>:
  7088c0:	55                   	push   %rbp
  7088c1:	41 57                	push   %r15
  7088c3:	41 56                	push   %r14
  7088c5:	41 55                	push   %r13
  7088c7:	41 54                	push   %r12
  7088c9:	53                   	push   %rbx
  7088ca:	48 81 ec 28 01 00 00 	sub    $0x128,%rsp
  7088d1:	48 89 fb             	mov    %rdi,%rbx
  7088d4:	80 be 22 07 00 00 00 	cmpb   $0x0,0x722(%rsi)
  7088db:	74 09                	je     7088e6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x26>
  7088dd:	48 c7 03 0e 00 00 00 	movq   $0xe,(%rbx)
  7088e4:	eb 6f                	jmp    708955 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x95>
  7088e6:	49 89 f6             	mov    %rsi,%r14
  7088e9:	48 8b 86 10 06 00 00 	mov    0x610(%rsi),%rax
  7088f0:	48 85 c0             	test   %rax,%rax
  7088f3:	74 59                	je     70894e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x8e>
  7088f5:	48 83 b8 d8 00 00 00 	cmpq   $0x0,0xd8(%rax)
  7088fc:	00 
  7088fd:	74 4f                	je     70894e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x8e>
  7088ff:	49 c7 86 08 07 00 00 	movq   $0x0,0x708(%r14)
  708906:	00 00 00 00 
  70890a:	48 8b a8 d8 00 00 00 	mov    0xd8(%rax),%rbp
  708911:	48 85 ed             	test   %rbp,%rbp
  708914:	0f 84 b0 08 00 00    	je     7091ca <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x90a>
  70891a:	44 0f b7 65 10       	movzwl 0x10(%rbp),%r12d
  70891f:	0f b6 7d 16          	movzbl 0x16(%rbp),%edi
  708923:	44 0f b6 45 12       	movzbl 0x12(%rbp),%r8d
  708928:	89 c8                	mov    %ecx,%eax
  70892a:	66 83 e8 0e          	sub    $0xe,%ax
  70892e:	41 bf 03 00 00 00    	mov    $0x3,%r15d
  708934:	44 0f 43 f8          	cmovae %eax,%r15d
  708938:	66 41 83 ff 03       	cmp    $0x3,%r15w
  70893d:	75 28                	jne    708967 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0xa7>
  70893f:	66 41 39 cc          	cmp    %cx,%r12w
  708943:	74 22                	je     708967 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0xa7>
  708945:	48 c7 03 11 00 00 00 	movq   $0x11,(%rbx)
  70894c:	eb 07                	jmp    708955 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x95>
  70894e:	48 c7 03 1a 00 00 00 	movq   $0x1a,(%rbx)
  708955:	48 81 c4 28 01 00 00 	add    $0x128,%rsp
  70895c:	5b                   	pop    %rbx
  70895d:	41 5c                	pop    %r12
  70895f:	41 5d                	pop    %r13
  708961:	41 5e                	pop    %r14
  708963:	41 5f                	pop    %r15
  708965:	5d                   	pop    %rbp
  708966:	c3                   	ret
  708967:	41 89 cd             	mov    %ecx,%r13d
  70896a:	41 c1 ed 10          	shr    $0x10,%r13d
  70896e:	45 0f b7 cf          	movzwl %r15w,%r9d
  708972:	48 8d 05 2b 2d 95 ff 	lea    -0x6ad2d5(%rip),%rax        # 5b6a4 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x34>
  708979:	4a 63 34 88          	movslq (%rax,%r9,4),%rsi
  70897d:	48 01 c6             	add    %rax,%rsi
  708980:	ff e6                	jmp    *%rsi
  708982:	44 0f b7 ff          	movzwl %di,%r15d
  708986:	41 81 cf 00 01 00 00 	or     $0x100,%r15d
  70898d:	eb 12                	jmp    7089a1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0xe1>
  70898f:	45 0f b7 f8          	movzwl %r8w,%r15d
  708993:	41 c1 e7 08          	shl    $0x8,%r15d
  708997:	66 45 39 e5          	cmp    %r12w,%r13w
  70899b:	0f 85 f3 02 00 00    	jne    708c94 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x3d4>
  7089a1:	b0 01                	mov    $0x1,%al
  7089a3:	44 38 ff             	cmp    %r15b,%dil
  7089a6:	0f 85 ed 02 00 00    	jne    708c99 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x3d9>
  7089ac:	41 0f b7 cf          	movzwl %r15w,%ecx
  7089b0:	c1 e9 08             	shr    $0x8,%ecx
  7089b3:	41 38 c8             	cmp    %cl,%r8b
  7089b6:	0f 85 dd 02 00 00    	jne    708c99 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x3d9>
  7089bc:	80 7d 13 ff          	cmpb   $0xff,0x13(%rbp)
  7089c0:	0f 85 d3 02 00 00    	jne    708c99 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x3d9>
  7089c6:	e9 c4 01 00 00       	jmp    708b8f <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x2cf>
  7089cb:	f7 c1 00 00 ff 00    	test   $0xff0000,%ecx
  7089d1:	0f 84 5d 02 00 00    	je     708c34 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x374>
  7089d7:	48 8b 45 00          	mov    0x0(%rbp),%rax
  7089db:	48 85 c0             	test   %rax,%rax
  7089de:	0f 84 ab 01 00 00    	je     708b8f <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x2cf>
  7089e4:	49 3b 86 b0 05 00 00 	cmp    0x5b0(%r14),%rax
  7089eb:	0f 85 d4 01 00 00    	jne    708bc5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x305>
  7089f1:	4c 89 4c 24 18       	mov    %r9,0x18(%rsp)
  7089f6:	48 89 7c 24 10       	mov    %rdi,0x10(%rsp)
  7089fb:	48 89 54 24 60       	mov    %rdx,0x60(%rsp)
  708a00:	89 4c 24 08          	mov    %ecx,0x8(%rsp)
  708a04:	4c 8b 65 08          	mov    0x8(%rbp),%r12
  708a08:	48 c7 44 24 28 11 00 	movq   $0x11,0x28(%rsp)
  708a0f:	00 00 
  708a11:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  708a16:	e8 65 f0 fe ff       	call   6f7a80 <core::ptr::drop_glue::<gpui::runtime::Error>>
  708a1b:	48 8d bc 24 c0 00 00 	lea    0xc0(%rsp),%rdi
  708a22:	00 
  708a23:	4c 89 f6             	mov    %r14,%rsi
  708a26:	4c 89 e2             	mov    %r12,%rdx
  708a29:	e8 22 ef 01 00       	call   727950 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::resolve_identity>
  708a2e:	48 8b 84 24 c0 00 00 	mov    0xc0(%rsp),%rax
  708a35:	00 
  708a36:	4c 8b a4 24 c8 00 00 	mov    0xc8(%rsp),%r12
  708a3d:	00 
  708a3e:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  708a42:	0f 85 fc 05 00 00    	jne    709044 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x784>
  708a48:	49 8b 86 10 06 00 00 	mov    0x610(%r14),%rax
  708a4f:	48 85 c0             	test   %rax,%rax
  708a52:	0f 84 2f 06 00 00    	je     709087 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x7c7>
  708a58:	48 83 b8 d8 00 00 00 	cmpq   $0x0,0xd8(%rax)
  708a5f:	00 
  708a60:	0f 84 21 06 00 00    	je     709087 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x7c7>
  708a66:	49 8b ae a0 02 00 00 	mov    0x2a0(%r14),%rbp
  708a6d:	48 c7 44 24 28 1a 00 	movq   $0x1a,0x28(%rsp)
  708a74:	00 00 
  708a76:	48 83 fd 1c          	cmp    $0x1c,%rbp
  708a7a:	0f 82 07 06 00 00    	jb     709087 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x7c7>
  708a80:	48 83 c5 e4          	add    $0xffffffffffffffe4,%rbp
  708a84:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  708a89:	e8 f2 ef fe ff       	call   6f7a80 <core::ptr::drop_glue::<gpui::runtime::Error>>
  708a8e:	49 83 fc 02          	cmp    $0x2,%r12
  708a92:	0f 93 c0             	setae  %al
  708a95:	49 39 ec             	cmp    %rbp,%r12
  708a98:	0f 92 c1             	setb   %cl
  708a9b:	84 c8                	test   %cl,%al
  708a9d:	0f 84 22 01 00 00    	je     708bc5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x305>
  708aa3:	66 41 83 ff 01       	cmp    $0x1,%r15w
  708aa8:	0f 84 3d 06 00 00    	je     7090eb <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x82b>
  708aae:	83 7c 24 18 03       	cmpl   $0x3,0x18(%rsp)
  708ab3:	0f 85 c3 08 00 00    	jne    70937c <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0xabc>
  708ab9:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  708abe:	4c 89 f6             	mov    %r14,%rsi
  708ac1:	4c 89 e2             	mov    %r12,%rdx
  708ac4:	8b 4c 24 08          	mov    0x8(%rsp),%ecx
  708ac8:	e8 63 fd 01 00       	call   728830 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::property_value_at>
  708acd:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  708ad2:	0f 10 44 24 30       	movups 0x30(%rsp),%xmm0
  708ad7:	0f 29 84 24 c0 00 00 	movaps %xmm0,0xc0(%rsp)
  708ade:	00 
  708adf:	0f 10 44 24 3c       	movups 0x3c(%rsp),%xmm0
  708ae4:	0f 11 84 24 cc 00 00 	movups %xmm0,0xcc(%rsp)
  708aeb:	00 
  708aec:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  708af0:	0f 85 a4 06 00 00    	jne    70919a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x8da>
  708af6:	0f 28 84 24 c0 00 00 	movaps 0xc0(%rsp),%xmm0
  708afd:	00 
  708afe:	0f 29 84 24 00 01 00 	movaps %xmm0,0x100(%rsp)
  708b05:	00 
  708b06:	0f 10 84 24 cc 00 00 	movups 0xcc(%rsp),%xmm0
  708b0d:	00 
  708b0e:	0f 11 84 24 0c 01 00 	movups %xmm0,0x10c(%rsp)
  708b15:	00 
  708b16:	41 0f b6 c5          	movzbl %r13b,%eax
  708b1a:	48 8d 0d 93 2b 95 ff 	lea    -0x6ad46d(%rip),%rcx        # 5b6b4 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x44>
  708b21:	48 63 04 81          	movslq (%rcx,%rax,4),%rax
  708b25:	48 01 c8             	add    %rcx,%rax
  708b28:	ff e0                	jmp    *%rax
  708b2a:	8b 44 24 08          	mov    0x8(%rsp),%eax
  708b2e:	25 00 00 ff 00       	and    $0xff0000,%eax
  708b33:	31 c9                	xor    %ecx,%ecx
  708b35:	3d 00 00 02 00       	cmp    $0x20000,%eax
  708b3a:	0f 94 c1             	sete   %cl
  708b3d:	48 8d 05 e4 28 95 ff 	lea    -0x6ad71c(%rip),%rax        # 5b428 <anon.079f5e587c394fcac2765eb4d0cf0bc2.21.llvm.6319143315422321905+0x48>
  708b44:	f3 0f 10 04 88       	movss  (%rax,%rcx,4),%xmm0
  708b49:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  708b4e:	48 8d b4 24 00 01 00 	lea    0x100(%rsp),%rsi
  708b55:	00 
  708b56:	48 8b 54 24 10       	mov    0x10(%rsp),%rdx
  708b5b:	ff 15 37 f6 41 00    	call   *0x41f637(%rip)        # b28198 <_DYNAMIC+0x4e0>
  708b61:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  708b66:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  708b6a:	0f 85 c5 06 00 00    	jne    709235 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x975>
  708b70:	0f 10 44 24 30       	movups 0x30(%rsp),%xmm0
  708b75:	0f 10 4c 24 3c       	movups 0x3c(%rsp),%xmm1
  708b7a:	0f 11 8c 24 ac 00 00 	movups %xmm1,0xac(%rsp)
  708b81:	00 
  708b82:	0f 29 84 24 a0 00 00 	movaps %xmm0,0xa0(%rsp)
  708b89:	00 
  708b8a:	e9 e2 06 00 00       	jmp    709271 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x9b1>
  708b8f:	41 0f 10 86 60 06 00 	movups 0x660(%r14),%xmm0
  708b96:	00 
  708b97:	41 0f b6 86 20 07 00 	movzbl 0x720(%r14),%eax
  708b9e:	00 
  708b9f:	49 83 be 80 06 00 00 	cmpq   $0x0,0x680(%r14)
  708ba6:	00 
  708ba7:	74 66                	je     708c0f <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x34f>
  708ba9:	84 c0                	test   %al,%al
  708bab:	74 0a                	je     708bb7 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x2f7>
  708bad:	49 83 be 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%r14)
  708bb4:	ff 
  708bb5:	74 58                	je     708c0f <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x34f>
  708bb7:	49 8b 96 90 06 00 00 	mov    0x690(%r14),%rdx
  708bbe:	b9 01 00 00 00       	mov    $0x1,%ecx
  708bc3:	eb 4c                	jmp    708c11 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x351>
  708bc5:	48 c7 44 24 68 11 00 	movq   $0x11,0x68(%rsp)
  708bcc:	00 00 
  708bce:	41 0f 10 86 60 06 00 	movups 0x660(%r14),%xmm0
  708bd5:	00 
  708bd6:	41 0f b6 86 20 07 00 	movzbl 0x720(%r14),%eax
  708bdd:	00 
  708bde:	49 83 be 80 06 00 00 	cmpq   $0x0,0x680(%r14)
  708be5:	00 
  708be6:	0f 84 26 04 00 00    	je     709012 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x752>
  708bec:	84 c0                	test   %al,%al
  708bee:	74 0e                	je     708bfe <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x33e>
  708bf0:	49 83 be 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%r14)
  708bf7:	ff 
  708bf8:	0f 84 14 04 00 00    	je     709012 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x752>
  708bfe:	49 8b 96 90 06 00 00 	mov    0x690(%r14),%rdx
  708c05:	b9 01 00 00 00       	mov    $0x1,%ecx
  708c0a:	e9 05 04 00 00       	jmp    709014 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x754>
  708c0f:	31 c9                	xor    %ecx,%ecx
  708c11:	48 89 4b 08          	mov    %rcx,0x8(%rbx)
  708c15:	48 89 53 10          	mov    %rdx,0x10(%rbx)
  708c19:	0f 11 43 18          	movups %xmm0,0x18(%rbx)
  708c1d:	48 c7 43 28 00 00 00 	movq   $0x0,0x28(%rbx)
  708c24:	00 
  708c25:	88 43 30             	mov    %al,0x30(%rbx)
  708c28:	48 c7 03 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rbx)
  708c2f:	e9 21 fd ff ff       	jmp    708955 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x95>
  708c34:	45 0f b7 f8          	movzwl %r8w,%r15d
  708c38:	8d 47 01             	lea    0x1(%rdi),%eax
  708c3b:	89 44 24 18          	mov    %eax,0x18(%rsp)
  708c3f:	48 89 7c 24 10       	mov    %rdi,0x10(%rsp)
  708c44:	89 cf                	mov    %ecx,%edi
  708c46:	89 4c 24 08          	mov    %ecx,0x8(%rsp)
  708c4a:	45 89 c5             	mov    %r8d,%r13d
  708c4d:	e8 ae ab ff ff       	call   703800 <<gpui::property::PropertyId>::info>
  708c52:	45 89 e8             	mov    %r13d,%r8d
  708c55:	48 8b 7c 24 10       	mov    0x10(%rsp),%rdi
  708c5a:	44 8b 6c 24 08       	mov    0x8(%rsp),%r13d
  708c5f:	0f b6 40 14          	movzbl 0x14(%rax),%eax
  708c63:	31 c9                	xor    %ecx,%ecx
  708c65:	3c 04                	cmp    $0x4,%al
  708c67:	0f 94 c1             	sete   %cl
  708c6a:	8d 0c 89             	lea    (%rcx,%rcx,4),%ecx
  708c6d:	ff c1                	inc    %ecx
  708c6f:	3c 02                	cmp    $0x2,%al
  708c71:	ba 04 00 00 00       	mov    $0x4,%edx
  708c76:	0f 45 d1             	cmovne %ecx,%edx
  708c79:	0f b6 44 24 18       	movzbl 0x18(%rsp),%eax
  708c7e:	f6 f2                	div    %dl
  708c80:	0f b6 c4             	movzbl %ah,%eax
  708c83:	41 c1 e7 08          	shl    $0x8,%r15d
  708c87:	41 09 c7             	or     %eax,%r15d
  708c8a:	66 45 39 e5          	cmp    %r12w,%r13w
  708c8e:	0f 84 0d fd ff ff    	je     7089a1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0xe1>
  708c94:	31 c0                	xor    %eax,%eax
  708c96:	45 89 ec             	mov    %r13d,%r12d
  708c99:	49 8b 96 60 06 00 00 	mov    0x660(%r14),%rdx
  708ca0:	48 ff c2             	inc    %rdx
  708ca3:	0f 84 a8 06 00 00    	je     709351 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0xa91>
  708ca9:	41 0f b7 cf          	movzwl %r15w,%ecx
  708cad:	66 44 89 65 10       	mov    %r12w,0x10(%rbp)
  708cb2:	88 4d 16             	mov    %cl,0x16(%rbp)
  708cb5:	88 6d 12             	mov    %ch,0x12(%rbp)
  708cb8:	c6 45 13 ff          	movb   $0xff,0x13(%rbp)
  708cbc:	84 c0                	test   %al,%al
  708cbe:	0f 85 11 03 00 00    	jne    708fd5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x715>
  708cc4:	49 8b 86 10 06 00 00 	mov    0x610(%r14),%rax
  708ccb:	48 85 c0             	test   %rax,%rax
  708cce:	0f 84 da 06 00 00    	je     7093ae <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0xaee>
  708cd4:	48 83 b8 d8 00 00 00 	cmpq   $0x0,0xd8(%rax)
  708cdb:	00 
  708cdc:	0f 84 cc 06 00 00    	je     7093ae <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0xaee>
  708ce2:	4d 8b be a0 02 00 00 	mov    0x2a0(%r14),%r15
  708ce9:	49 83 ff 1c          	cmp    $0x1c,%r15
  708ced:	0f 82 bb 06 00 00    	jb     7093ae <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0xaee>
  708cf3:	48 89 54 24 60       	mov    %rdx,0x60(%rsp)
  708cf8:	41 0f b7 fc          	movzwl %r12w,%edi
  708cfc:	48 89 7c 24 18       	mov    %rdi,0x18(%rsp)
  708d01:	ff 15 99 f4 41 00    	call   *0x41f499(%rip)        # b281a0 <_DYNAMIC+0x4e8>
  708d07:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  708d0c:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
  708d11:	49 8d 7f f7          	lea    -0x9(%r15),%rdi
  708d15:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  708d1c:	48 39 f7             	cmp    %rsi,%rdi
  708d1f:	0f 83 99 06 00 00    	jae    7093be <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0xafe>
  708d25:	49 8b 8e 98 02 00 00 	mov    0x298(%r14),%rcx
  708d2c:	48 8d 14 bf          	lea    (%rdi,%rdi,4),%rdx
  708d30:	4c 8d 24 d1          	lea    (%rcx,%rdx,8),%r12
  708d34:	48 8b 6c d1 08       	mov    0x8(%rcx,%rdx,8),%rbp
  708d39:	48 85 ed             	test   %rbp,%rbp
  708d3c:	74 36                	je     708d74 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x4b4>
  708d3e:	4c 8b 6c d1 10       	mov    0x10(%rcx,%rdx,8),%r13
  708d43:	49 8b 45 00          	mov    0x0(%r13),%rax
  708d47:	48 85 c0             	test   %rax,%rax
  708d4a:	74 12                	je     708d5e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x49e>
  708d4c:	48 8d 0c d1          	lea    (%rcx,%rdx,8),%rcx
  708d50:	48 83 c1 08          	add    $0x8,%rcx
  708d54:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  708d59:	48 89 ef             	mov    %rbp,%rdi
  708d5c:	ff d0                	call   *%rax
  708d5e:	49 8b 75 08          	mov    0x8(%r13),%rsi
  708d62:	48 85 f6             	test   %rsi,%rsi
  708d65:	74 0d                	je     708d74 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x4b4>
  708d67:	49 8b 55 10          	mov    0x10(%r13),%rdx
  708d6b:	48 89 ef             	mov    %rbp,%rdi
  708d6e:	ff 15 8c f1 41 00    	call   *0x41f18c(%rip)        # b27f00 <_DYNAMIC+0x248>
  708d74:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  708d79:	49 89 44 24 08       	mov    %rax,0x8(%r12)
  708d7e:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  708d83:	49 89 44 24 10       	mov    %rax,0x10(%r12)
  708d88:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  708d8d:	8d b8 00 00 01 00    	lea    0x10000(%rax),%edi
  708d93:	ff 15 07 f4 41 00    	call   *0x41f407(%rip)        # b281a0 <_DYNAMIC+0x4e8>
  708d99:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  708d9e:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
  708da3:	49 8d 7f f9          	lea    -0x7(%r15),%rdi
  708da7:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  708dae:	48 39 f7             	cmp    %rsi,%rdi
  708db1:	0f 83 07 06 00 00    	jae    7093be <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0xafe>
  708db7:	49 8b 8e 98 02 00 00 	mov    0x298(%r14),%rcx
  708dbe:	48 8d 14 bf          	lea    (%rdi,%rdi,4),%rdx
  708dc2:	4c 8d 24 d1          	lea    (%rcx,%rdx,8),%r12
  708dc6:	48 8b 6c d1 08       	mov    0x8(%rcx,%rdx,8),%rbp
  708dcb:	48 85 ed             	test   %rbp,%rbp
  708dce:	74 36                	je     708e06 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x546>
  708dd0:	4c 8b 6c d1 10       	mov    0x10(%rcx,%rdx,8),%r13
  708dd5:	49 8b 45 00          	mov    0x0(%r13),%rax
  708dd9:	48 85 c0             	test   %rax,%rax
  708ddc:	74 12                	je     708df0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x530>
  708dde:	48 8d 0c d1          	lea    (%rcx,%rdx,8),%rcx
  708de2:	48 83 c1 08          	add    $0x8,%rcx
  708de6:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  708deb:	48 89 ef             	mov    %rbp,%rdi
  708dee:	ff d0                	call   *%rax
  708df0:	49 8b 75 08          	mov    0x8(%r13),%rsi
  708df4:	48 85 f6             	test   %rsi,%rsi
  708df7:	74 0d                	je     708e06 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x546>
  708df9:	49 8b 55 10          	mov    0x10(%r13),%rdx
  708dfd:	48 89 ef             	mov    %rbp,%rdi
  708e00:	ff 15 fa f0 41 00    	call   *0x41f0fa(%rip)        # b27f00 <_DYNAMIC+0x248>
  708e06:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  708e0b:	49 89 44 24 08       	mov    %rax,0x8(%r12)
  708e10:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  708e15:	49 89 44 24 10       	mov    %rax,0x10(%r12)
  708e1a:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  708e1f:	8d b8 00 00 02 00    	lea    0x20000(%rax),%edi
  708e25:	ff 15 75 f3 41 00    	call   *0x41f375(%rip)        # b281a0 <_DYNAMIC+0x4e8>
  708e2b:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  708e30:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
  708e35:	49 8d 7f fa          	lea    -0x6(%r15),%rdi
  708e39:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  708e40:	48 39 f7             	cmp    %rsi,%rdi
  708e43:	0f 83 75 05 00 00    	jae    7093be <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0xafe>
  708e49:	49 8b 8e 98 02 00 00 	mov    0x298(%r14),%rcx
  708e50:	48 8d 14 bf          	lea    (%rdi,%rdi,4),%rdx
  708e54:	4c 8d 24 d1          	lea    (%rcx,%rdx,8),%r12
  708e58:	48 8b 6c d1 08       	mov    0x8(%rcx,%rdx,8),%rbp
  708e5d:	48 85 ed             	test   %rbp,%rbp
  708e60:	74 36                	je     708e98 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x5d8>
  708e62:	4c 8b 6c d1 10       	mov    0x10(%rcx,%rdx,8),%r13
  708e67:	49 8b 45 00          	mov    0x0(%r13),%rax
  708e6b:	48 85 c0             	test   %rax,%rax
  708e6e:	74 12                	je     708e82 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x5c2>
  708e70:	48 8d 0c d1          	lea    (%rcx,%rdx,8),%rcx
  708e74:	48 83 c1 08          	add    $0x8,%rcx
  708e78:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  708e7d:	48 89 ef             	mov    %rbp,%rdi
  708e80:	ff d0                	call   *%rax
  708e82:	49 8b 75 08          	mov    0x8(%r13),%rsi
  708e86:	48 85 f6             	test   %rsi,%rsi
  708e89:	74 0d                	je     708e98 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x5d8>
  708e8b:	49 8b 55 10          	mov    0x10(%r13),%rdx
  708e8f:	48 89 ef             	mov    %rbp,%rdi
  708e92:	ff 15 68 f0 41 00    	call   *0x41f068(%rip)        # b27f00 <_DYNAMIC+0x248>
  708e98:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  708e9d:	49 89 44 24 08       	mov    %rax,0x8(%r12)
  708ea2:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  708ea7:	49 89 44 24 10       	mov    %rax,0x10(%r12)
  708eac:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  708eb1:	8d b8 00 00 03 00    	lea    0x30000(%rax),%edi
  708eb7:	ff 15 e3 f2 41 00    	call   *0x41f2e3(%rip)        # b281a0 <_DYNAMIC+0x4e8>
  708ebd:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  708ec2:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
  708ec7:	49 8d 7f fb          	lea    -0x5(%r15),%rdi
  708ecb:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  708ed2:	48 39 f7             	cmp    %rsi,%rdi
  708ed5:	0f 83 e3 04 00 00    	jae    7093be <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0xafe>
  708edb:	49 8b 8e 98 02 00 00 	mov    0x298(%r14),%rcx
  708ee2:	48 8d 14 bf          	lea    (%rdi,%rdi,4),%rdx
  708ee6:	4c 8d 24 d1          	lea    (%rcx,%rdx,8),%r12
  708eea:	48 8b 6c d1 08       	mov    0x8(%rcx,%rdx,8),%rbp
  708eef:	48 85 ed             	test   %rbp,%rbp
  708ef2:	74 36                	je     708f2a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x66a>
  708ef4:	4c 8b 6c d1 10       	mov    0x10(%rcx,%rdx,8),%r13
  708ef9:	49 8b 45 00          	mov    0x0(%r13),%rax
  708efd:	48 85 c0             	test   %rax,%rax
  708f00:	74 12                	je     708f14 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x654>
  708f02:	48 8d 0c d1          	lea    (%rcx,%rdx,8),%rcx
  708f06:	48 83 c1 08          	add    $0x8,%rcx
  708f0a:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  708f0f:	48 89 ef             	mov    %rbp,%rdi
  708f12:	ff d0                	call   *%rax
  708f14:	49 8b 75 08          	mov    0x8(%r13),%rsi
  708f18:	48 85 f6             	test   %rsi,%rsi
  708f1b:	74 0d                	je     708f2a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x66a>
  708f1d:	49 8b 55 10          	mov    0x10(%r13),%rdx
  708f21:	48 89 ef             	mov    %rbp,%rdi
  708f24:	ff 15 d6 ef 41 00    	call   *0x41efd6(%rip)        # b27f00 <_DYNAMIC+0x248>
  708f2a:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  708f2f:	49 89 44 24 08       	mov    %rax,0x8(%r12)
  708f34:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  708f39:	49 89 44 24 10       	mov    %rax,0x10(%r12)
  708f3e:	48 8b 7c 24 18       	mov    0x18(%rsp),%rdi
  708f43:	81 cf 00 00 04 00    	or     $0x40000,%edi
  708f49:	ff 15 51 f2 41 00    	call   *0x41f251(%rip)        # b281a0 <_DYNAMIC+0x4e8>
  708f4f:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  708f54:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
  708f59:	49 83 c7 fc          	add    $0xfffffffffffffffc,%r15
  708f5d:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  708f64:	49 39 f7             	cmp    %rsi,%r15
  708f67:	0f 83 4e 04 00 00    	jae    7093bb <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0xafb>
  708f6d:	49 8b 8e 98 02 00 00 	mov    0x298(%r14),%rcx
  708f74:	4b 8d 14 bf          	lea    (%r15,%r15,4),%rdx
  708f78:	4c 8d 24 d1          	lea    (%rcx,%rdx,8),%r12
  708f7c:	48 8b 6c d1 08       	mov    0x8(%rcx,%rdx,8),%rbp
  708f81:	48 85 ed             	test   %rbp,%rbp
  708f84:	74 36                	je     708fbc <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x6fc>
  708f86:	4c 8b 6c d1 10       	mov    0x10(%rcx,%rdx,8),%r13
  708f8b:	49 8b 45 00          	mov    0x0(%r13),%rax
  708f8f:	48 85 c0             	test   %rax,%rax
  708f92:	74 12                	je     708fa6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x6e6>
  708f94:	48 8d 0c d1          	lea    (%rcx,%rdx,8),%rcx
  708f98:	48 83 c1 08          	add    $0x8,%rcx
  708f9c:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  708fa1:	48 89 ef             	mov    %rbp,%rdi
  708fa4:	ff d0                	call   *%rax
  708fa6:	49 8b 75 08          	mov    0x8(%r13),%rsi
  708faa:	48 85 f6             	test   %rsi,%rsi
  708fad:	74 0d                	je     708fbc <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x6fc>
  708faf:	49 8b 55 10          	mov    0x10(%r13),%rdx
  708fb3:	48 89 ef             	mov    %rbp,%rdi
  708fb6:	ff 15 44 ef 41 00    	call   *0x41ef44(%rip)        # b27f00 <_DYNAMIC+0x248>
  708fbc:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  708fc1:	49 89 44 24 08       	mov    %rax,0x8(%r12)
  708fc6:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  708fcb:	49 89 44 24 10       	mov    %rax,0x10(%r12)
  708fd0:	48 8b 54 24 60       	mov    0x60(%rsp),%rdx
  708fd5:	49 89 96 60 06 00 00 	mov    %rdx,0x660(%r14)
  708fdc:	49 ff 86 b0 06 00 00 	incq   0x6b0(%r14)
  708fe3:	49 c7 86 08 07 00 00 	movq   $0x0,0x708(%r14)
  708fea:	00 00 00 00 
  708fee:	41 c6 86 1f 07 00 00 	movb   $0x1,0x71f(%r14)
  708ff5:	01 
  708ff6:	48 89 df             	mov    %rbx,%rdi
  708ff9:	4c 89 f6             	mov    %r14,%rsi
  708ffc:	48 81 c4 28 01 00 00 	add    $0x128,%rsp
  709003:	5b                   	pop    %rbx
  709004:	41 5c                	pop    %r12
  709006:	41 5d                	pop    %r13
  709008:	41 5e                	pop    %r14
  70900a:	41 5f                	pop    %r15
  70900c:	5d                   	pop    %rbp
  70900d:	e9 ae f1 01 00       	jmp    7281c0 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::present>
  709012:	31 c9                	xor    %ecx,%ecx
  709014:	49 8b b6 08 07 00 00 	mov    0x708(%r14),%rsi
  70901b:	48 89 4b 08          	mov    %rcx,0x8(%rbx)
  70901f:	48 89 53 10          	mov    %rdx,0x10(%rbx)
  709023:	0f 11 43 18          	movups %xmm0,0x18(%rbx)
  709027:	48 89 73 28          	mov    %rsi,0x28(%rbx)
  70902b:	88 43 30             	mov    %al,0x30(%rbx)
  70902e:	48 c7 03 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rbx)
  709035:	48 8d 7c 24 68       	lea    0x68(%rsp),%rdi
  70903a:	e8 41 ea fe ff       	call   6f7a80 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70903f:	e9 11 f9 ff ff       	jmp    708955 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x95>
  709044:	48 8b 8c 24 f0 00 00 	mov    0xf0(%rsp),%rcx
  70904b:	00 
  70904c:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  709053:	00 
  709054:	0f 10 84 24 d0 00 00 	movups 0xd0(%rsp),%xmm0
  70905b:	00 
  70905c:	0f 10 8c 24 e0 00 00 	movups 0xe0(%rsp),%xmm1
  709063:	00 
  709064:	0f 11 8c 24 88 00 00 	movups %xmm1,0x88(%rsp)
  70906b:	00 
  70906c:	0f 11 44 24 78       	movups %xmm0,0x78(%rsp)
  709071:	48 89 44 24 68       	mov    %rax,0x68(%rsp)
  709076:	4c 89 64 24 70       	mov    %r12,0x70(%rsp)
  70907b:	48 83 f8 11          	cmp    $0x11,%rax
  70907f:	0f 84 49 fb ff ff    	je     708bce <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x30e>
  709085:	eb 2d                	jmp    7090b4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x7f4>
  709087:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  70908c:	48 89 84 24 98 00 00 	mov    %rax,0x98(%rsp)
  709093:	00 
  709094:	0f 10 44 24 38       	movups 0x38(%rsp),%xmm0
  709099:	0f 10 4c 24 48       	movups 0x48(%rsp),%xmm1
  70909e:	0f 11 8c 24 88 00 00 	movups %xmm1,0x88(%rsp)
  7090a5:	00 
  7090a6:	0f 11 44 24 78       	movups %xmm0,0x78(%rsp)
  7090ab:	48 c7 44 24 68 1a 00 	movq   $0x1a,0x68(%rsp)
  7090b2:	00 00 
  7090b4:	48 8b 84 24 98 00 00 	mov    0x98(%rsp),%rax
  7090bb:	00 
  7090bc:	48 89 43 30          	mov    %rax,0x30(%rbx)
  7090c0:	48 8b 44 24 68       	mov    0x68(%rsp),%rax
  7090c5:	48 8b 4c 24 70       	mov    0x70(%rsp),%rcx
  7090ca:	0f 10 44 24 78       	movups 0x78(%rsp),%xmm0
  7090cf:	0f 10 8c 24 88 00 00 	movups 0x88(%rsp),%xmm1
  7090d6:	00 
  7090d7:	0f 11 4b 20          	movups %xmm1,0x20(%rbx)
  7090db:	0f 11 43 10          	movups %xmm0,0x10(%rbx)
  7090df:	48 89 03             	mov    %rax,(%rbx)
  7090e2:	48 89 4b 08          	mov    %rcx,0x8(%rbx)
  7090e6:	e9 6a f8 ff ff       	jmp    708955 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x95>
  7090eb:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  7090f2:	49 39 f4             	cmp    %rsi,%r12
  7090f5:	0f 83 eb 02 00 00    	jae    7093e6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0xb26>
  7090fb:	49 8b 86 98 02 00 00 	mov    0x298(%r14),%rax
  709102:	4b 8d 0c a4          	lea    (%r12,%r12,4),%rcx
  709106:	44 8b 7c c8 18       	mov    0x18(%rax,%rcx,8),%r15d
  70910b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  709110:	49 39 c7             	cmp    %rax,%r15
  709113:	0f 84 2c f8 ff ff    	je     708945 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x85>
  709119:	48 c7 44 24 28 11 00 	movq   $0x11,0x28(%rsp)
  709120:	00 00 
  709122:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  709127:	e8 54 e9 fe ff       	call   6f7a80 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70912c:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  709133:	4c 39 fe             	cmp    %r15,%rsi
  709136:	0f 86 ba 02 00 00    	jbe    7093f6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0xb36>
  70913c:	49 8d be b0 05 00 00 	lea    0x5b0(%r14),%rdi
  709143:	49 8b 86 98 02 00 00 	mov    0x298(%r14),%rax
  70914a:	4b 8d 0c bf          	lea    (%r15,%r15,4),%rcx
  70914e:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
  709152:	ff 15 50 f0 41 00    	call   *0x41f050(%rip)        # b281a8 <_DYNAMIC+0x4f0>
  709158:	49 89 c7             	mov    %rax,%r15
  70915b:	49 89 d4             	mov    %rdx,%r12
  70915e:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  709163:	4c 89 f6             	mov    %r14,%rsi
  709166:	48 89 c2             	mov    %rax,%rdx
  709169:	4c 89 e1             	mov    %r12,%rcx
  70916c:	e8 af e6 ff ff       	call   707820 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::inspector_app_index>
  709171:	83 7c 24 28 fe       	cmpl   $0xfffffffe,0x28(%rsp)
  709176:	75 5f                	jne    7091d7 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x917>
  709178:	48 89 df             	mov    %rbx,%rdi
  70917b:	4c 89 f6             	mov    %r14,%rsi
  70917e:	4c 89 fa             	mov    %r15,%rdx
  709181:	4c 89 e1             	mov    %r12,%rcx
  709184:	48 81 c4 28 01 00 00 	add    $0x128,%rsp
  70918b:	5b                   	pop    %rbx
  70918c:	41 5c                	pop    %r12
  70918e:	41 5d                	pop    %r13
  709190:	41 5e                	pop    %r14
  709192:	41 5f                	pop    %r15
  709194:	5d                   	pop    %rbp
  709195:	e9 e6 02 00 00       	jmp    709480 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::inspector_select>
  70919a:	8b 4c 24 5c          	mov    0x5c(%rsp),%ecx
  70919e:	89 4b 34             	mov    %ecx,0x34(%rbx)
  7091a1:	0f 10 44 24 4c       	movups 0x4c(%rsp),%xmm0
  7091a6:	0f 11 43 24          	movups %xmm0,0x24(%rbx)
  7091aa:	0f 10 84 24 cc 00 00 	movups 0xcc(%rsp),%xmm0
  7091b1:	00 
  7091b2:	0f 11 43 14          	movups %xmm0,0x14(%rbx)
  7091b6:	0f 28 84 24 c0 00 00 	movaps 0xc0(%rsp),%xmm0
  7091bd:	00 
  7091be:	0f 11 43 08          	movups %xmm0,0x8(%rbx)
  7091c2:	48 89 03             	mov    %rax,(%rbx)
  7091c5:	e9 8b f7 ff ff       	jmp    708955 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x95>
  7091ca:	48 8d 3d 37 0b 3f 00 	lea    0x3f0b37(%rip),%rdi        # af9d08 <__frame_dummy_init_array_entry+0x7e0>
  7091d1:	ff 15 e9 ed 41 00    	call   *0x41ede9(%rip)        # b27fc0 <_DYNAMIC+0x308>
  7091d7:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  7091dc:	e8 9f e8 fe ff       	call   6f7a80 <core::ptr::drop_glue::<gpui::runtime::Error>>
  7091e1:	41 0f 10 86 60 06 00 	movups 0x660(%r14),%xmm0
  7091e8:	00 
  7091e9:	41 0f b6 86 20 07 00 	movzbl 0x720(%r14),%eax
  7091f0:	00 
  7091f1:	49 83 be 80 06 00 00 	cmpq   $0x0,0x680(%r14)
  7091f8:	00 
  7091f9:	74 1c                	je     709217 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x957>
  7091fb:	84 c0                	test   %al,%al
  7091fd:	74 0a                	je     709209 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x949>
  7091ff:	49 83 be 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%r14)
  709206:	ff 
  709207:	74 0e                	je     709217 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x957>
  709209:	49 8b 96 90 06 00 00 	mov    0x690(%r14),%rdx
  709210:	b9 01 00 00 00       	mov    $0x1,%ecx
  709215:	eb 02                	jmp    709219 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x959>
  709217:	31 c9                	xor    %ecx,%ecx
  709219:	49 8b b6 08 07 00 00 	mov    0x708(%r14),%rsi
  709220:	48 89 4b 08          	mov    %rcx,0x8(%rbx)
  709224:	48 89 53 10          	mov    %rdx,0x10(%rbx)
  709228:	0f 11 43 18          	movups %xmm0,0x18(%rbx)
  70922c:	48 89 73 28          	mov    %rsi,0x28(%rbx)
  709230:	e9 f0 f9 ff ff       	jmp    708c25 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x365>
  709235:	83 f8 23             	cmp    $0x23,%eax
  709238:	0f 85 eb 00 00 00    	jne    709329 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0xa69>
  70923e:	8b 44 24 30          	mov    0x30(%rsp),%eax
  709242:	83 f8 0d             	cmp    $0xd,%eax
  709245:	0f 84 12 01 00 00    	je     70935d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0xa9d>
  70924b:	83 f8 0e             	cmp    $0xe,%eax
  70924e:	0f 85 d5 00 00 00    	jne    709329 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0xa69>
  709254:	ba 07 00 00 00       	mov    $0x7,%edx
  709259:	e9 04 01 00 00       	jmp    709362 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0xaa2>
  70925e:	c6 84 24 a0 00 00 00 	movb   $0x0,0xa0(%rsp)
  709265:	00 
  709266:	c7 84 24 a4 00 00 00 	movl   $0x0,0xa4(%rsp)
  70926d:	00 00 00 00 
  709271:	48 8d b4 24 a0 00 00 	lea    0xa0(%rsp),%rsi
  709278:	00 
  709279:	8b 7c 24 08          	mov    0x8(%rsp),%edi
  70927d:	ff 15 2d ef 41 00    	call   *0x41ef2d(%rip)        # b281b0 <_DYNAMIC+0x4f8>
  709283:	66 85 c0             	test   %ax,%ax
  709286:	74 2a                	je     7092b2 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x9f2>
  709288:	48 c1 e8 10          	shr    $0x10,%rax
  70928c:	48 89 df             	mov    %rbx,%rdi
  70928f:	4c 89 f6             	mov    %r14,%rsi
  709292:	89 c2                	mov    %eax,%edx
  709294:	48 81 c4 28 01 00 00 	add    $0x128,%rsp
  70929b:	5b                   	pop    %rbx
  70929c:	41 5c                	pop    %r12
  70929e:	41 5d                	pop    %r13
  7092a0:	41 5e                	pop    %r14
  7092a2:	41 5f                	pop    %r15
  7092a4:	5d                   	pop    %rbp
  7092a5:	e9 f6 f4 ff ff       	jmp    7087a0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::reject_editor>
  7092aa:	c6 84 24 a0 00 00 00 	movb   $0xff,0xa0(%rsp)
  7092b1:	ff 
  7092b2:	4d 8b be 60 06 00 00 	mov    0x660(%r14),%r15
  7092b9:	49 83 ff ff          	cmp    $0xffffffffffffffff,%r15
  7092bd:	0f 84 8e 00 00 00    	je     709351 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0xa91>
  7092c3:	48 c7 44 24 28 1f 00 	movq   $0x1f,0x28(%rsp)
  7092ca:	00 00 
  7092cc:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  7092d1:	e8 aa e7 fe ff       	call   6f7a80 <core::ptr::drop_glue::<gpui::runtime::Error>>
  7092d6:	49 8b 86 10 06 00 00 	mov    0x610(%r14),%rax
  7092dd:	48 85 c0             	test   %rax,%rax
  7092e0:	0f 84 af 00 00 00    	je     709395 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0xad5>
  7092e6:	48 8b 80 d8 00 00 00 	mov    0xd8(%rax),%rax
  7092ed:	48 85 c0             	test   %rax,%rax
  7092f0:	0f 84 9f 00 00 00    	je     709395 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0xad5>
  7092f6:	49 ff c7             	inc    %r15
  7092f9:	c6 40 13 ff          	movb   $0xff,0x13(%rax)
  7092fd:	48 8d 84 24 a0 00 00 	lea    0xa0(%rsp),%rax
  709304:	00 
  709305:	48 89 04 24          	mov    %rax,(%rsp)
  709309:	48 89 df             	mov    %rbx,%rdi
  70930c:	4c 89 f6             	mov    %r14,%rsi
  70930f:	48 8b 54 24 60       	mov    0x60(%rsp),%rdx
  709314:	4c 89 e1             	mov    %r12,%rcx
  709317:	4d 89 f8             	mov    %r15,%r8
  70931a:	44 8b 4c 24 08       	mov    0x8(%rsp),%r9d
  70931f:	e8 dc 05 02 00       	call   729900 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::set_property_value_at>
  709324:	e9 2c f6 ff ff       	jmp    708955 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x95>
  709329:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  70932e:	48 89 43 30          	mov    %rax,0x30(%rbx)
  709332:	0f 10 44 24 28       	movups 0x28(%rsp),%xmm0
  709337:	0f 10 4c 24 38       	movups 0x38(%rsp),%xmm1
  70933c:	0f 10 54 24 48       	movups 0x48(%rsp),%xmm2
  709341:	0f 11 53 20          	movups %xmm2,0x20(%rbx)
  709345:	0f 11 4b 10          	movups %xmm1,0x10(%rbx)
  709349:	0f 11 03             	movups %xmm0,(%rbx)
  70934c:	e9 04 f6 ff ff       	jmp    708955 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x95>
  709351:	48 c7 03 1f 00 00 00 	movq   $0x1f,(%rbx)
  709358:	e9 f8 f5 ff ff       	jmp    708955 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x95>
  70935d:	ba 06 00 00 00       	mov    $0x6,%edx
  709362:	48 89 df             	mov    %rbx,%rdi
  709365:	4c 89 f6             	mov    %r14,%rsi
  709368:	e8 33 f4 ff ff       	call   7087a0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::reject_editor>
  70936d:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  709372:	e8 09 e7 fe ff       	call   6f7a80 <core::ptr::drop_glue::<gpui::runtime::Error>>
  709377:	e9 d9 f5 ff ff       	jmp    708955 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x95>
  70937c:	48 8d 3d 01 10 96 ff 	lea    -0x69efff(%rip),%rdi        # 6a384 <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x3297>
  709383:	48 8d 15 f6 09 3f 00 	lea    0x3f09f6(%rip),%rdx        # af9d80 <__frame_dummy_init_array_entry+0x858>
  70938a:	be 28 00 00 00       	mov    $0x28,%esi
  70938f:	ff 15 23 ee 41 00    	call   *0x41ee23(%rip)        # b281b8 <_DYNAMIC+0x500>
  709395:	48 8d 3d 29 10 96 ff 	lea    -0x69efd7(%rip),%rdi        # 6a3c5 <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x32d8>
  70939c:	48 8d 15 ed 08 3f 00 	lea    0x3f08ed(%rip),%rdx        # af9c90 <__frame_dummy_init_array_entry+0x768>
  7093a3:	be 11 00 00 00       	mov    $0x11,%esi
  7093a8:	ff 15 52 ec 41 00    	call   *0x41ec52(%rip)        # b28000 <_DYNAMIC+0x348>
  7093ae:	48 8d 3d 6b 09 3f 00 	lea    0x3f096b(%rip),%rdi        # af9d20 <__frame_dummy_init_array_entry+0x7f8>
  7093b5:	ff 15 05 ec 41 00    	call   *0x41ec05(%rip)        # b27fc0 <_DYNAMIC+0x308>
  7093bb:	4c 89 ff             	mov    %r15,%rdi
  7093be:	48 8d 15 73 09 3f 00 	lea    0x3f0973(%rip),%rdx        # af9d38 <__frame_dummy_init_array_entry+0x810>
  7093c5:	ff 15 45 ec 41 00    	call   *0x41ec45(%rip)        # b28010 <_DYNAMIC+0x358>
  7093cb:	0f 0b                	ud2
  7093cd:	48 8d 3d b0 0f 96 ff 	lea    -0x69f050(%rip),%rdi        # 6a384 <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x3297>
  7093d4:	48 8d 15 bd 09 3f 00 	lea    0x3f09bd(%rip),%rdx        # af9d98 <__frame_dummy_init_array_entry+0x870>
  7093db:	be 28 00 00 00       	mov    $0x28,%esi
  7093e0:	ff 15 d2 ed 41 00    	call   *0x41edd2(%rip)        # b281b8 <_DYNAMIC+0x500>
  7093e6:	48 8d 15 63 09 3f 00 	lea    0x3f0963(%rip),%rdx        # af9d50 <__frame_dummy_init_array_entry+0x828>
  7093ed:	4c 89 e7             	mov    %r12,%rdi
  7093f0:	ff 15 1a ec 41 00    	call   *0x41ec1a(%rip)        # b28010 <_DYNAMIC+0x358>
  7093f6:	48 8d 15 6b 09 3f 00 	lea    0x3f096b(%rip),%rdx        # af9d68 <__frame_dummy_init_array_entry+0x840>
  7093fd:	4c 89 ff             	mov    %r15,%rdi
  709400:	ff 15 0a ec 41 00    	call   *0x41ec0a(%rip)        # b28010 <_DYNAMIC+0x358>
  709406:	48 89 c3             	mov    %rax,%rbx
  709409:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  70940e:	e8 6d e6 fe ff       	call   6f7a80 <core::ptr::drop_glue::<gpui::runtime::Error>>
  709413:	48 89 df             	mov    %rbx,%rdi
  709416:	e8 55 ed 3e 00       	call   af8170 <_Unwind_Resume@plt>
  70941b:	4c 8b 74 24 20       	mov    0x20(%rsp),%r14
  709420:	48 89 c3             	mov    %rax,%rbx
  709423:	49 8b 75 08          	mov    0x8(%r13),%rsi
  709427:	48 85 f6             	test   %rsi,%rsi
  70942a:	74 0d                	je     709439 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0xb79>
  70942c:	49 8b 55 10          	mov    0x10(%r13),%rdx
  709430:	48 89 ef             	mov    %rbp,%rdi
  709433:	ff 15 c7 ea 41 00    	call   *0x41eac7(%rip)        # b27f00 <_DYNAMIC+0x248>
  709439:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  70943e:	49 89 06             	mov    %rax,(%r14)
  709441:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  709446:	49 89 44 24 10       	mov    %rax,0x10(%r12)
  70944b:	48 89 df             	mov    %rbx,%rdi
  70944e:	e8 1d ed 3e 00       	call   af8170 <_Unwind_Resume@plt>
  709453:	48 89 c3             	mov    %rax,%rbx
  709456:	48 8b 7c 24 10       	mov    0x10(%rsp),%rdi
  70945b:	48 8b 74 24 08       	mov    0x8(%rsp),%rsi
  709460:	e8 9b af fe ff       	call   6f4400 <core::ptr::drop_glue::<core::option::Option<gpui::element::Handler>>>
  709465:	48 89 df             	mov    %rbx,%rdi
  709468:	e8 03 ed 3e 00       	call   af8170 <_Unwind_Resume@plt>
  70946d:	ff 15 bd ea 41 00    	call   *0x41eabd(%rip)        # b27f30 <_DYNAMIC+0x278>
