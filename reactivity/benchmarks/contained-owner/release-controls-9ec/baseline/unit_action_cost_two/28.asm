
/tmp/gpui-contained-owner-unit-baseline-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

0000000000707a10 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action>:
  707a10:	55                   	push   %rbp
  707a11:	41 57                	push   %r15
  707a13:	41 56                	push   %r14
  707a15:	41 55                	push   %r13
  707a17:	41 54                	push   %r12
  707a19:	53                   	push   %rbx
  707a1a:	48 81 ec 28 01 00 00 	sub    $0x128,%rsp
  707a21:	48 89 fb             	mov    %rdi,%rbx
  707a24:	80 be 22 08 00 00 00 	cmpb   $0x0,0x822(%rsi)
  707a2b:	74 09                	je     707a36 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x26>
  707a2d:	48 c7 03 0e 00 00 00 	movq   $0xe,(%rbx)
  707a34:	eb 6f                	jmp    707aa5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x95>
  707a36:	49 89 f6             	mov    %rsi,%r14
  707a39:	48 8b 86 10 06 00 00 	mov    0x610(%rsi),%rax
  707a40:	48 85 c0             	test   %rax,%rax
  707a43:	74 59                	je     707a9e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x8e>
  707a45:	48 83 b8 d8 00 00 00 	cmpq   $0x0,0xd8(%rax)
  707a4c:	00 
  707a4d:	74 4f                	je     707a9e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x8e>
  707a4f:	49 c7 86 08 07 00 00 	movq   $0x0,0x708(%r14)
  707a56:	00 00 00 00 
  707a5a:	48 8b a8 d8 00 00 00 	mov    0xd8(%rax),%rbp
  707a61:	48 85 ed             	test   %rbp,%rbp
  707a64:	0f 84 b0 08 00 00    	je     70831a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x90a>
  707a6a:	44 0f b7 65 10       	movzwl 0x10(%rbp),%r12d
  707a6f:	0f b6 7d 16          	movzbl 0x16(%rbp),%edi
  707a73:	44 0f b6 45 12       	movzbl 0x12(%rbp),%r8d
  707a78:	89 c8                	mov    %ecx,%eax
  707a7a:	66 83 e8 0e          	sub    $0xe,%ax
  707a7e:	41 bf 03 00 00 00    	mov    $0x3,%r15d
  707a84:	44 0f 43 f8          	cmovae %eax,%r15d
  707a88:	66 41 83 ff 03       	cmp    $0x3,%r15w
  707a8d:	75 28                	jne    707ab7 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0xa7>
  707a8f:	66 41 39 cc          	cmp    %cx,%r12w
  707a93:	74 22                	je     707ab7 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0xa7>
  707a95:	48 c7 03 11 00 00 00 	movq   $0x11,(%rbx)
  707a9c:	eb 07                	jmp    707aa5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x95>
  707a9e:	48 c7 03 1a 00 00 00 	movq   $0x1a,(%rbx)
  707aa5:	48 81 c4 28 01 00 00 	add    $0x128,%rsp
  707aac:	5b                   	pop    %rbx
  707aad:	41 5c                	pop    %r12
  707aaf:	41 5d                	pop    %r13
  707ab1:	41 5e                	pop    %r14
  707ab3:	41 5f                	pop    %r15
  707ab5:	5d                   	pop    %rbp
  707ab6:	c3                   	ret
  707ab7:	41 89 cd             	mov    %ecx,%r13d
  707aba:	41 c1 ed 10          	shr    $0x10,%r13d
  707abe:	45 0f b7 cf          	movzwl %r15w,%r9d
  707ac2:	48 8d 05 b7 3b 95 ff 	lea    -0x6ac449(%rip),%rax        # 5b680 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x10>
  707ac9:	4a 63 34 88          	movslq (%rax,%r9,4),%rsi
  707acd:	48 01 c6             	add    %rax,%rsi
  707ad0:	ff e6                	jmp    *%rsi
  707ad2:	44 0f b7 ff          	movzwl %di,%r15d
  707ad6:	41 81 cf 00 01 00 00 	or     $0x100,%r15d
  707add:	eb 12                	jmp    707af1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0xe1>
  707adf:	45 0f b7 f8          	movzwl %r8w,%r15d
  707ae3:	41 c1 e7 08          	shl    $0x8,%r15d
  707ae7:	66 45 39 e5          	cmp    %r12w,%r13w
  707aeb:	0f 85 f3 02 00 00    	jne    707de4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x3d4>
  707af1:	b0 01                	mov    $0x1,%al
  707af3:	44 38 ff             	cmp    %r15b,%dil
  707af6:	0f 85 ed 02 00 00    	jne    707de9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x3d9>
  707afc:	41 0f b7 cf          	movzwl %r15w,%ecx
  707b00:	c1 e9 08             	shr    $0x8,%ecx
  707b03:	41 38 c8             	cmp    %cl,%r8b
  707b06:	0f 85 dd 02 00 00    	jne    707de9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x3d9>
  707b0c:	80 7d 13 ff          	cmpb   $0xff,0x13(%rbp)
  707b10:	0f 85 d3 02 00 00    	jne    707de9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x3d9>
  707b16:	e9 c4 01 00 00       	jmp    707cdf <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x2cf>
  707b1b:	f7 c1 00 00 ff 00    	test   $0xff0000,%ecx
  707b21:	0f 84 5d 02 00 00    	je     707d84 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x374>
  707b27:	48 8b 45 00          	mov    0x0(%rbp),%rax
  707b2b:	48 85 c0             	test   %rax,%rax
  707b2e:	0f 84 ab 01 00 00    	je     707cdf <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x2cf>
  707b34:	49 3b 86 b0 05 00 00 	cmp    0x5b0(%r14),%rax
  707b3b:	0f 85 d4 01 00 00    	jne    707d15 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x305>
  707b41:	4c 89 4c 24 18       	mov    %r9,0x18(%rsp)
  707b46:	48 89 7c 24 10       	mov    %rdi,0x10(%rsp)
  707b4b:	48 89 54 24 60       	mov    %rdx,0x60(%rsp)
  707b50:	89 4c 24 08          	mov    %ecx,0x8(%rsp)
  707b54:	4c 8b 65 08          	mov    0x8(%rbp),%r12
  707b58:	48 c7 44 24 28 11 00 	movq   $0x11,0x28(%rsp)
  707b5f:	00 00 
  707b61:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  707b66:	e8 15 ff fe ff       	call   6f7a80 <core::ptr::drop_glue::<gpui::runtime::Error>>
  707b6b:	48 8d bc 24 c0 00 00 	lea    0xc0(%rsp),%rdi
  707b72:	00 
  707b73:	4c 89 f6             	mov    %r14,%rsi
  707b76:	4c 89 e2             	mov    %r12,%rdx
  707b79:	e8 32 15 01 00       	call   7190b0 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::resolve_identity>
  707b7e:	48 8b 84 24 c0 00 00 	mov    0xc0(%rsp),%rax
  707b85:	00 
  707b86:	4c 8b a4 24 c8 00 00 	mov    0xc8(%rsp),%r12
  707b8d:	00 
  707b8e:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  707b92:	0f 85 fc 05 00 00    	jne    708194 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x784>
  707b98:	49 8b 86 10 06 00 00 	mov    0x610(%r14),%rax
  707b9f:	48 85 c0             	test   %rax,%rax
  707ba2:	0f 84 2f 06 00 00    	je     7081d7 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x7c7>
  707ba8:	48 83 b8 d8 00 00 00 	cmpq   $0x0,0xd8(%rax)
  707baf:	00 
  707bb0:	0f 84 21 06 00 00    	je     7081d7 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x7c7>
  707bb6:	49 8b ae a0 02 00 00 	mov    0x2a0(%r14),%rbp
  707bbd:	48 c7 44 24 28 1a 00 	movq   $0x1a,0x28(%rsp)
  707bc4:	00 00 
  707bc6:	48 83 fd 1c          	cmp    $0x1c,%rbp
  707bca:	0f 82 07 06 00 00    	jb     7081d7 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x7c7>
  707bd0:	48 83 c5 e4          	add    $0xffffffffffffffe4,%rbp
  707bd4:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  707bd9:	e8 a2 fe fe ff       	call   6f7a80 <core::ptr::drop_glue::<gpui::runtime::Error>>
  707bde:	49 83 fc 02          	cmp    $0x2,%r12
  707be2:	0f 93 c0             	setae  %al
  707be5:	49 39 ec             	cmp    %rbp,%r12
  707be8:	0f 92 c1             	setb   %cl
  707beb:	84 c8                	test   %cl,%al
  707bed:	0f 84 22 01 00 00    	je     707d15 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x305>
  707bf3:	66 41 83 ff 01       	cmp    $0x1,%r15w
  707bf8:	0f 84 3d 06 00 00    	je     70823b <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x82b>
  707bfe:	83 7c 24 18 03       	cmpl   $0x3,0x18(%rsp)
  707c03:	0f 85 c3 08 00 00    	jne    7084cc <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0xabc>
  707c09:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  707c0e:	4c 89 f6             	mov    %r14,%rsi
  707c11:	4c 89 e2             	mov    %r12,%rdx
  707c14:	8b 4c 24 08          	mov    0x8(%rsp),%ecx
  707c18:	e8 a3 09 02 00       	call   7285c0 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::property_value_at>
  707c1d:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  707c22:	0f 10 44 24 30       	movups 0x30(%rsp),%xmm0
  707c27:	0f 29 84 24 c0 00 00 	movaps %xmm0,0xc0(%rsp)
  707c2e:	00 
  707c2f:	0f 10 44 24 3c       	movups 0x3c(%rsp),%xmm0
  707c34:	0f 11 84 24 cc 00 00 	movups %xmm0,0xcc(%rsp)
  707c3b:	00 
  707c3c:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  707c40:	0f 85 a4 06 00 00    	jne    7082ea <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x8da>
  707c46:	0f 28 84 24 c0 00 00 	movaps 0xc0(%rsp),%xmm0
  707c4d:	00 
  707c4e:	0f 29 84 24 00 01 00 	movaps %xmm0,0x100(%rsp)
  707c55:	00 
  707c56:	0f 10 84 24 cc 00 00 	movups 0xcc(%rsp),%xmm0
  707c5d:	00 
  707c5e:	0f 11 84 24 0c 01 00 	movups %xmm0,0x10c(%rsp)
  707c65:	00 
  707c66:	41 0f b6 c5          	movzbl %r13b,%eax
  707c6a:	48 8d 0d 1f 3a 95 ff 	lea    -0x6ac5e1(%rip),%rcx        # 5b690 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x20>
  707c71:	48 63 04 81          	movslq (%rcx,%rax,4),%rax
  707c75:	48 01 c8             	add    %rcx,%rax
  707c78:	ff e0                	jmp    *%rax
  707c7a:	8b 44 24 08          	mov    0x8(%rsp),%eax
  707c7e:	25 00 00 ff 00       	and    $0xff0000,%eax
  707c83:	31 c9                	xor    %ecx,%ecx
  707c85:	3d 00 00 02 00       	cmp    $0x20000,%eax
  707c8a:	0f 94 c1             	sete   %cl
  707c8d:	48 8d 05 94 37 95 ff 	lea    -0x6ac86c(%rip),%rax        # 5b428 <anon.079f5e587c394fcac2765eb4d0cf0bc2.21.llvm.6319143315422321905+0x48>
  707c94:	f3 0f 10 04 88       	movss  (%rax,%rcx,4),%xmm0
  707c99:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  707c9e:	48 8d b4 24 00 01 00 	lea    0x100(%rsp),%rsi
  707ca5:	00 
  707ca6:	48 8b 54 24 10       	mov    0x10(%rsp),%rdx
  707cab:	ff 15 e7 04 42 00    	call   *0x4204e7(%rip)        # b28198 <_DYNAMIC+0x4e0>
  707cb1:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  707cb6:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  707cba:	0f 85 c5 06 00 00    	jne    708385 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x975>
  707cc0:	0f 10 44 24 30       	movups 0x30(%rsp),%xmm0
  707cc5:	0f 10 4c 24 3c       	movups 0x3c(%rsp),%xmm1
  707cca:	0f 11 8c 24 ac 00 00 	movups %xmm1,0xac(%rsp)
  707cd1:	00 
  707cd2:	0f 29 84 24 a0 00 00 	movaps %xmm0,0xa0(%rsp)
  707cd9:	00 
  707cda:	e9 e2 06 00 00       	jmp    7083c1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x9b1>
  707cdf:	41 0f 10 86 60 06 00 	movups 0x660(%r14),%xmm0
  707ce6:	00 
  707ce7:	41 0f b6 86 20 08 00 	movzbl 0x820(%r14),%eax
  707cee:	00 
  707cef:	49 83 be 80 06 00 00 	cmpq   $0x0,0x680(%r14)
  707cf6:	00 
  707cf7:	74 66                	je     707d5f <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x34f>
  707cf9:	84 c0                	test   %al,%al
  707cfb:	74 0a                	je     707d07 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x2f7>
  707cfd:	49 83 be 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%r14)
  707d04:	ff 
  707d05:	74 58                	je     707d5f <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x34f>
  707d07:	49 8b 96 90 06 00 00 	mov    0x690(%r14),%rdx
  707d0e:	b9 01 00 00 00       	mov    $0x1,%ecx
  707d13:	eb 4c                	jmp    707d61 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x351>
  707d15:	48 c7 44 24 68 11 00 	movq   $0x11,0x68(%rsp)
  707d1c:	00 00 
  707d1e:	41 0f 10 86 60 06 00 	movups 0x660(%r14),%xmm0
  707d25:	00 
  707d26:	41 0f b6 86 20 08 00 	movzbl 0x820(%r14),%eax
  707d2d:	00 
  707d2e:	49 83 be 80 06 00 00 	cmpq   $0x0,0x680(%r14)
  707d35:	00 
  707d36:	0f 84 26 04 00 00    	je     708162 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x752>
  707d3c:	84 c0                	test   %al,%al
  707d3e:	74 0e                	je     707d4e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x33e>
  707d40:	49 83 be 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%r14)
  707d47:	ff 
  707d48:	0f 84 14 04 00 00    	je     708162 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x752>
  707d4e:	49 8b 96 90 06 00 00 	mov    0x690(%r14),%rdx
  707d55:	b9 01 00 00 00       	mov    $0x1,%ecx
  707d5a:	e9 05 04 00 00       	jmp    708164 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x754>
  707d5f:	31 c9                	xor    %ecx,%ecx
  707d61:	48 89 4b 08          	mov    %rcx,0x8(%rbx)
  707d65:	48 89 53 10          	mov    %rdx,0x10(%rbx)
  707d69:	0f 11 43 18          	movups %xmm0,0x18(%rbx)
  707d6d:	48 c7 43 28 00 00 00 	movq   $0x0,0x28(%rbx)
  707d74:	00 
  707d75:	88 43 30             	mov    %al,0x30(%rbx)
  707d78:	48 c7 03 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rbx)
  707d7f:	e9 21 fd ff ff       	jmp    707aa5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x95>
  707d84:	45 0f b7 f8          	movzwl %r8w,%r15d
  707d88:	8d 47 01             	lea    0x1(%rdi),%eax
  707d8b:	89 44 24 18          	mov    %eax,0x18(%rsp)
  707d8f:	48 89 7c 24 10       	mov    %rdi,0x10(%rsp)
  707d94:	89 cf                	mov    %ecx,%edi
  707d96:	89 4c 24 08          	mov    %ecx,0x8(%rsp)
  707d9a:	45 89 c5             	mov    %r8d,%r13d
  707d9d:	e8 5e ba ff ff       	call   703800 <<gpui::property::PropertyId>::info>
  707da2:	45 89 e8             	mov    %r13d,%r8d
  707da5:	48 8b 7c 24 10       	mov    0x10(%rsp),%rdi
  707daa:	44 8b 6c 24 08       	mov    0x8(%rsp),%r13d
  707daf:	0f b6 40 14          	movzbl 0x14(%rax),%eax
  707db3:	31 c9                	xor    %ecx,%ecx
  707db5:	3c 04                	cmp    $0x4,%al
  707db7:	0f 94 c1             	sete   %cl
  707dba:	8d 0c 89             	lea    (%rcx,%rcx,4),%ecx
  707dbd:	ff c1                	inc    %ecx
  707dbf:	3c 02                	cmp    $0x2,%al
  707dc1:	ba 04 00 00 00       	mov    $0x4,%edx
  707dc6:	0f 45 d1             	cmovne %ecx,%edx
  707dc9:	0f b6 44 24 18       	movzbl 0x18(%rsp),%eax
  707dce:	f6 f2                	div    %dl
  707dd0:	0f b6 c4             	movzbl %ah,%eax
  707dd3:	41 c1 e7 08          	shl    $0x8,%r15d
  707dd7:	41 09 c7             	or     %eax,%r15d
  707dda:	66 45 39 e5          	cmp    %r12w,%r13w
  707dde:	0f 84 0d fd ff ff    	je     707af1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0xe1>
  707de4:	31 c0                	xor    %eax,%eax
  707de6:	45 89 ec             	mov    %r13d,%r12d
  707de9:	49 8b 96 60 06 00 00 	mov    0x660(%r14),%rdx
  707df0:	48 ff c2             	inc    %rdx
  707df3:	0f 84 a8 06 00 00    	je     7084a1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0xa91>
  707df9:	41 0f b7 cf          	movzwl %r15w,%ecx
  707dfd:	66 44 89 65 10       	mov    %r12w,0x10(%rbp)
  707e02:	88 4d 16             	mov    %cl,0x16(%rbp)
  707e05:	88 6d 12             	mov    %ch,0x12(%rbp)
  707e08:	c6 45 13 ff          	movb   $0xff,0x13(%rbp)
  707e0c:	84 c0                	test   %al,%al
  707e0e:	0f 85 11 03 00 00    	jne    708125 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x715>
  707e14:	49 8b 86 10 06 00 00 	mov    0x610(%r14),%rax
  707e1b:	48 85 c0             	test   %rax,%rax
  707e1e:	0f 84 da 06 00 00    	je     7084fe <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0xaee>
  707e24:	48 83 b8 d8 00 00 00 	cmpq   $0x0,0xd8(%rax)
  707e2b:	00 
  707e2c:	0f 84 cc 06 00 00    	je     7084fe <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0xaee>
  707e32:	4d 8b be a0 02 00 00 	mov    0x2a0(%r14),%r15
  707e39:	49 83 ff 1c          	cmp    $0x1c,%r15
  707e3d:	0f 82 bb 06 00 00    	jb     7084fe <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0xaee>
  707e43:	48 89 54 24 60       	mov    %rdx,0x60(%rsp)
  707e48:	41 0f b7 fc          	movzwl %r12w,%edi
  707e4c:	48 89 7c 24 18       	mov    %rdi,0x18(%rsp)
  707e51:	ff 15 49 03 42 00    	call   *0x420349(%rip)        # b281a0 <_DYNAMIC+0x4e8>
  707e57:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  707e5c:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
  707e61:	49 8d 7f f7          	lea    -0x9(%r15),%rdi
  707e65:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  707e6c:	48 39 f7             	cmp    %rsi,%rdi
  707e6f:	0f 83 99 06 00 00    	jae    70850e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0xafe>
  707e75:	49 8b 8e 98 02 00 00 	mov    0x298(%r14),%rcx
  707e7c:	48 8d 14 bf          	lea    (%rdi,%rdi,4),%rdx
  707e80:	4c 8d 24 d1          	lea    (%rcx,%rdx,8),%r12
  707e84:	48 8b 6c d1 08       	mov    0x8(%rcx,%rdx,8),%rbp
  707e89:	48 85 ed             	test   %rbp,%rbp
  707e8c:	74 36                	je     707ec4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x4b4>
  707e8e:	4c 8b 6c d1 10       	mov    0x10(%rcx,%rdx,8),%r13
  707e93:	49 8b 45 00          	mov    0x0(%r13),%rax
  707e97:	48 85 c0             	test   %rax,%rax
  707e9a:	74 12                	je     707eae <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x49e>
  707e9c:	48 8d 0c d1          	lea    (%rcx,%rdx,8),%rcx
  707ea0:	48 83 c1 08          	add    $0x8,%rcx
  707ea4:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  707ea9:	48 89 ef             	mov    %rbp,%rdi
  707eac:	ff d0                	call   *%rax
  707eae:	49 8b 75 08          	mov    0x8(%r13),%rsi
  707eb2:	48 85 f6             	test   %rsi,%rsi
  707eb5:	74 0d                	je     707ec4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x4b4>
  707eb7:	49 8b 55 10          	mov    0x10(%r13),%rdx
  707ebb:	48 89 ef             	mov    %rbp,%rdi
  707ebe:	ff 15 3c 00 42 00    	call   *0x42003c(%rip)        # b27f00 <_DYNAMIC+0x248>
  707ec4:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  707ec9:	49 89 44 24 08       	mov    %rax,0x8(%r12)
  707ece:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  707ed3:	49 89 44 24 10       	mov    %rax,0x10(%r12)
  707ed8:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  707edd:	8d b8 00 00 01 00    	lea    0x10000(%rax),%edi
  707ee3:	ff 15 b7 02 42 00    	call   *0x4202b7(%rip)        # b281a0 <_DYNAMIC+0x4e8>
  707ee9:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  707eee:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
  707ef3:	49 8d 7f f9          	lea    -0x7(%r15),%rdi
  707ef7:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  707efe:	48 39 f7             	cmp    %rsi,%rdi
  707f01:	0f 83 07 06 00 00    	jae    70850e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0xafe>
  707f07:	49 8b 8e 98 02 00 00 	mov    0x298(%r14),%rcx
  707f0e:	48 8d 14 bf          	lea    (%rdi,%rdi,4),%rdx
  707f12:	4c 8d 24 d1          	lea    (%rcx,%rdx,8),%r12
  707f16:	48 8b 6c d1 08       	mov    0x8(%rcx,%rdx,8),%rbp
  707f1b:	48 85 ed             	test   %rbp,%rbp
  707f1e:	74 36                	je     707f56 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x546>
  707f20:	4c 8b 6c d1 10       	mov    0x10(%rcx,%rdx,8),%r13
  707f25:	49 8b 45 00          	mov    0x0(%r13),%rax
  707f29:	48 85 c0             	test   %rax,%rax
  707f2c:	74 12                	je     707f40 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x530>
  707f2e:	48 8d 0c d1          	lea    (%rcx,%rdx,8),%rcx
  707f32:	48 83 c1 08          	add    $0x8,%rcx
  707f36:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  707f3b:	48 89 ef             	mov    %rbp,%rdi
  707f3e:	ff d0                	call   *%rax
  707f40:	49 8b 75 08          	mov    0x8(%r13),%rsi
  707f44:	48 85 f6             	test   %rsi,%rsi
  707f47:	74 0d                	je     707f56 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x546>
  707f49:	49 8b 55 10          	mov    0x10(%r13),%rdx
  707f4d:	48 89 ef             	mov    %rbp,%rdi
  707f50:	ff 15 aa ff 41 00    	call   *0x41ffaa(%rip)        # b27f00 <_DYNAMIC+0x248>
  707f56:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  707f5b:	49 89 44 24 08       	mov    %rax,0x8(%r12)
  707f60:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  707f65:	49 89 44 24 10       	mov    %rax,0x10(%r12)
  707f6a:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  707f6f:	8d b8 00 00 02 00    	lea    0x20000(%rax),%edi
  707f75:	ff 15 25 02 42 00    	call   *0x420225(%rip)        # b281a0 <_DYNAMIC+0x4e8>
  707f7b:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  707f80:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
  707f85:	49 8d 7f fa          	lea    -0x6(%r15),%rdi
  707f89:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  707f90:	48 39 f7             	cmp    %rsi,%rdi
  707f93:	0f 83 75 05 00 00    	jae    70850e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0xafe>
  707f99:	49 8b 8e 98 02 00 00 	mov    0x298(%r14),%rcx
  707fa0:	48 8d 14 bf          	lea    (%rdi,%rdi,4),%rdx
  707fa4:	4c 8d 24 d1          	lea    (%rcx,%rdx,8),%r12
  707fa8:	48 8b 6c d1 08       	mov    0x8(%rcx,%rdx,8),%rbp
  707fad:	48 85 ed             	test   %rbp,%rbp
  707fb0:	74 36                	je     707fe8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x5d8>
  707fb2:	4c 8b 6c d1 10       	mov    0x10(%rcx,%rdx,8),%r13
  707fb7:	49 8b 45 00          	mov    0x0(%r13),%rax
  707fbb:	48 85 c0             	test   %rax,%rax
  707fbe:	74 12                	je     707fd2 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x5c2>
  707fc0:	48 8d 0c d1          	lea    (%rcx,%rdx,8),%rcx
  707fc4:	48 83 c1 08          	add    $0x8,%rcx
  707fc8:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  707fcd:	48 89 ef             	mov    %rbp,%rdi
  707fd0:	ff d0                	call   *%rax
  707fd2:	49 8b 75 08          	mov    0x8(%r13),%rsi
  707fd6:	48 85 f6             	test   %rsi,%rsi
  707fd9:	74 0d                	je     707fe8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x5d8>
  707fdb:	49 8b 55 10          	mov    0x10(%r13),%rdx
  707fdf:	48 89 ef             	mov    %rbp,%rdi
  707fe2:	ff 15 18 ff 41 00    	call   *0x41ff18(%rip)        # b27f00 <_DYNAMIC+0x248>
  707fe8:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  707fed:	49 89 44 24 08       	mov    %rax,0x8(%r12)
  707ff2:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  707ff7:	49 89 44 24 10       	mov    %rax,0x10(%r12)
  707ffc:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  708001:	8d b8 00 00 03 00    	lea    0x30000(%rax),%edi
  708007:	ff 15 93 01 42 00    	call   *0x420193(%rip)        # b281a0 <_DYNAMIC+0x4e8>
  70800d:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  708012:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
  708017:	49 8d 7f fb          	lea    -0x5(%r15),%rdi
  70801b:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  708022:	48 39 f7             	cmp    %rsi,%rdi
  708025:	0f 83 e3 04 00 00    	jae    70850e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0xafe>
  70802b:	49 8b 8e 98 02 00 00 	mov    0x298(%r14),%rcx
  708032:	48 8d 14 bf          	lea    (%rdi,%rdi,4),%rdx
  708036:	4c 8d 24 d1          	lea    (%rcx,%rdx,8),%r12
  70803a:	48 8b 6c d1 08       	mov    0x8(%rcx,%rdx,8),%rbp
  70803f:	48 85 ed             	test   %rbp,%rbp
  708042:	74 36                	je     70807a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x66a>
  708044:	4c 8b 6c d1 10       	mov    0x10(%rcx,%rdx,8),%r13
  708049:	49 8b 45 00          	mov    0x0(%r13),%rax
  70804d:	48 85 c0             	test   %rax,%rax
  708050:	74 12                	je     708064 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x654>
  708052:	48 8d 0c d1          	lea    (%rcx,%rdx,8),%rcx
  708056:	48 83 c1 08          	add    $0x8,%rcx
  70805a:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  70805f:	48 89 ef             	mov    %rbp,%rdi
  708062:	ff d0                	call   *%rax
  708064:	49 8b 75 08          	mov    0x8(%r13),%rsi
  708068:	48 85 f6             	test   %rsi,%rsi
  70806b:	74 0d                	je     70807a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x66a>
  70806d:	49 8b 55 10          	mov    0x10(%r13),%rdx
  708071:	48 89 ef             	mov    %rbp,%rdi
  708074:	ff 15 86 fe 41 00    	call   *0x41fe86(%rip)        # b27f00 <_DYNAMIC+0x248>
  70807a:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  70807f:	49 89 44 24 08       	mov    %rax,0x8(%r12)
  708084:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  708089:	49 89 44 24 10       	mov    %rax,0x10(%r12)
  70808e:	48 8b 7c 24 18       	mov    0x18(%rsp),%rdi
  708093:	81 cf 00 00 04 00    	or     $0x40000,%edi
  708099:	ff 15 01 01 42 00    	call   *0x420101(%rip)        # b281a0 <_DYNAMIC+0x4e8>
  70809f:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  7080a4:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
  7080a9:	49 83 c7 fc          	add    $0xfffffffffffffffc,%r15
  7080ad:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  7080b4:	49 39 f7             	cmp    %rsi,%r15
  7080b7:	0f 83 4e 04 00 00    	jae    70850b <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0xafb>
  7080bd:	49 8b 8e 98 02 00 00 	mov    0x298(%r14),%rcx
  7080c4:	4b 8d 14 bf          	lea    (%r15,%r15,4),%rdx
  7080c8:	4c 8d 24 d1          	lea    (%rcx,%rdx,8),%r12
  7080cc:	48 8b 6c d1 08       	mov    0x8(%rcx,%rdx,8),%rbp
  7080d1:	48 85 ed             	test   %rbp,%rbp
  7080d4:	74 36                	je     70810c <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x6fc>
  7080d6:	4c 8b 6c d1 10       	mov    0x10(%rcx,%rdx,8),%r13
  7080db:	49 8b 45 00          	mov    0x0(%r13),%rax
  7080df:	48 85 c0             	test   %rax,%rax
  7080e2:	74 12                	je     7080f6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x6e6>
  7080e4:	48 8d 0c d1          	lea    (%rcx,%rdx,8),%rcx
  7080e8:	48 83 c1 08          	add    $0x8,%rcx
  7080ec:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  7080f1:	48 89 ef             	mov    %rbp,%rdi
  7080f4:	ff d0                	call   *%rax
  7080f6:	49 8b 75 08          	mov    0x8(%r13),%rsi
  7080fa:	48 85 f6             	test   %rsi,%rsi
  7080fd:	74 0d                	je     70810c <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x6fc>
  7080ff:	49 8b 55 10          	mov    0x10(%r13),%rdx
  708103:	48 89 ef             	mov    %rbp,%rdi
  708106:	ff 15 f4 fd 41 00    	call   *0x41fdf4(%rip)        # b27f00 <_DYNAMIC+0x248>
  70810c:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  708111:	49 89 44 24 08       	mov    %rax,0x8(%r12)
  708116:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  70811b:	49 89 44 24 10       	mov    %rax,0x10(%r12)
  708120:	48 8b 54 24 60       	mov    0x60(%rsp),%rdx
  708125:	49 89 96 60 06 00 00 	mov    %rdx,0x660(%r14)
  70812c:	49 ff 86 b0 06 00 00 	incq   0x6b0(%r14)
  708133:	49 c7 86 08 07 00 00 	movq   $0x0,0x708(%r14)
  70813a:	00 00 00 00 
  70813e:	41 c6 86 1f 08 00 00 	movb   $0x1,0x81f(%r14)
  708145:	01 
  708146:	48 89 df             	mov    %rbx,%rdi
  708149:	4c 89 f6             	mov    %r14,%rsi
  70814c:	48 81 c4 28 01 00 00 	add    $0x128,%rsp
  708153:	5b                   	pop    %rbx
  708154:	41 5c                	pop    %r12
  708156:	41 5d                	pop    %r13
  708158:	41 5e                	pop    %r14
  70815a:	41 5f                	pop    %r15
  70815c:	5d                   	pop    %rbp
  70815d:	e9 be 17 01 00       	jmp    719920 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::present>
  708162:	31 c9                	xor    %ecx,%ecx
  708164:	49 8b b6 08 07 00 00 	mov    0x708(%r14),%rsi
  70816b:	48 89 4b 08          	mov    %rcx,0x8(%rbx)
  70816f:	48 89 53 10          	mov    %rdx,0x10(%rbx)
  708173:	0f 11 43 18          	movups %xmm0,0x18(%rbx)
  708177:	48 89 73 28          	mov    %rsi,0x28(%rbx)
  70817b:	88 43 30             	mov    %al,0x30(%rbx)
  70817e:	48 c7 03 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rbx)
  708185:	48 8d 7c 24 68       	lea    0x68(%rsp),%rdi
  70818a:	e8 f1 f8 fe ff       	call   6f7a80 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70818f:	e9 11 f9 ff ff       	jmp    707aa5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x95>
  708194:	48 8b 8c 24 f0 00 00 	mov    0xf0(%rsp),%rcx
  70819b:	00 
  70819c:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  7081a3:	00 
  7081a4:	0f 10 84 24 d0 00 00 	movups 0xd0(%rsp),%xmm0
  7081ab:	00 
  7081ac:	0f 10 8c 24 e0 00 00 	movups 0xe0(%rsp),%xmm1
  7081b3:	00 
  7081b4:	0f 11 8c 24 88 00 00 	movups %xmm1,0x88(%rsp)
  7081bb:	00 
  7081bc:	0f 11 44 24 78       	movups %xmm0,0x78(%rsp)
  7081c1:	48 89 44 24 68       	mov    %rax,0x68(%rsp)
  7081c6:	4c 89 64 24 70       	mov    %r12,0x70(%rsp)
  7081cb:	48 83 f8 11          	cmp    $0x11,%rax
  7081cf:	0f 84 49 fb ff ff    	je     707d1e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x30e>
  7081d5:	eb 2d                	jmp    708204 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x7f4>
  7081d7:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  7081dc:	48 89 84 24 98 00 00 	mov    %rax,0x98(%rsp)
  7081e3:	00 
  7081e4:	0f 10 44 24 38       	movups 0x38(%rsp),%xmm0
  7081e9:	0f 10 4c 24 48       	movups 0x48(%rsp),%xmm1
  7081ee:	0f 11 8c 24 88 00 00 	movups %xmm1,0x88(%rsp)
  7081f5:	00 
  7081f6:	0f 11 44 24 78       	movups %xmm0,0x78(%rsp)
  7081fb:	48 c7 44 24 68 1a 00 	movq   $0x1a,0x68(%rsp)
  708202:	00 00 
  708204:	48 8b 84 24 98 00 00 	mov    0x98(%rsp),%rax
  70820b:	00 
  70820c:	48 89 43 30          	mov    %rax,0x30(%rbx)
  708210:	48 8b 44 24 68       	mov    0x68(%rsp),%rax
  708215:	48 8b 4c 24 70       	mov    0x70(%rsp),%rcx
  70821a:	0f 10 44 24 78       	movups 0x78(%rsp),%xmm0
  70821f:	0f 10 8c 24 88 00 00 	movups 0x88(%rsp),%xmm1
  708226:	00 
  708227:	0f 11 4b 20          	movups %xmm1,0x20(%rbx)
  70822b:	0f 11 43 10          	movups %xmm0,0x10(%rbx)
  70822f:	48 89 03             	mov    %rax,(%rbx)
  708232:	48 89 4b 08          	mov    %rcx,0x8(%rbx)
  708236:	e9 6a f8 ff ff       	jmp    707aa5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x95>
  70823b:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  708242:	49 39 f4             	cmp    %rsi,%r12
  708245:	0f 83 eb 02 00 00    	jae    708536 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0xb26>
  70824b:	49 8b 86 98 02 00 00 	mov    0x298(%r14),%rax
  708252:	4b 8d 0c a4          	lea    (%r12,%r12,4),%rcx
  708256:	44 8b 7c c8 18       	mov    0x18(%rax,%rcx,8),%r15d
  70825b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  708260:	49 39 c7             	cmp    %rax,%r15
  708263:	0f 84 2c f8 ff ff    	je     707a95 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x85>
  708269:	48 c7 44 24 28 11 00 	movq   $0x11,0x28(%rsp)
  708270:	00 00 
  708272:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  708277:	e8 04 f8 fe ff       	call   6f7a80 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70827c:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  708283:	4c 39 fe             	cmp    %r15,%rsi
  708286:	0f 86 ba 02 00 00    	jbe    708546 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0xb36>
  70828c:	49 8d be b0 05 00 00 	lea    0x5b0(%r14),%rdi
  708293:	49 8b 86 98 02 00 00 	mov    0x298(%r14),%rax
  70829a:	4b 8d 0c bf          	lea    (%r15,%r15,4),%rcx
  70829e:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
  7082a2:	ff 15 00 ff 41 00    	call   *0x41ff00(%rip)        # b281a8 <_DYNAMIC+0x4f0>
  7082a8:	49 89 c7             	mov    %rax,%r15
  7082ab:	49 89 d4             	mov    %rdx,%r12
  7082ae:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  7082b3:	4c 89 f6             	mov    %r14,%rsi
  7082b6:	48 89 c2             	mov    %rax,%rdx
  7082b9:	4c 89 e1             	mov    %r12,%rcx
  7082bc:	e8 1f df ff ff       	call   7061e0 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::inspector_app_index>
  7082c1:	83 7c 24 28 fe       	cmpl   $0xfffffffe,0x28(%rsp)
  7082c6:	75 5f                	jne    708327 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x917>
  7082c8:	48 89 df             	mov    %rbx,%rdi
  7082cb:	4c 89 f6             	mov    %r14,%rsi
  7082ce:	4c 89 fa             	mov    %r15,%rdx
  7082d1:	4c 89 e1             	mov    %r12,%rcx
  7082d4:	48 81 c4 28 01 00 00 	add    $0x128,%rsp
  7082db:	5b                   	pop    %rbx
  7082dc:	41 5c                	pop    %r12
  7082de:	41 5d                	pop    %r13
  7082e0:	41 5e                	pop    %r14
  7082e2:	41 5f                	pop    %r15
  7082e4:	5d                   	pop    %rbp
  7082e5:	e9 e6 02 00 00       	jmp    7085d0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::inspector_select>
  7082ea:	8b 4c 24 5c          	mov    0x5c(%rsp),%ecx
  7082ee:	89 4b 34             	mov    %ecx,0x34(%rbx)
  7082f1:	0f 10 44 24 4c       	movups 0x4c(%rsp),%xmm0
  7082f6:	0f 11 43 24          	movups %xmm0,0x24(%rbx)
  7082fa:	0f 10 84 24 cc 00 00 	movups 0xcc(%rsp),%xmm0
  708301:	00 
  708302:	0f 11 43 14          	movups %xmm0,0x14(%rbx)
  708306:	0f 28 84 24 c0 00 00 	movaps 0xc0(%rsp),%xmm0
  70830d:	00 
  70830e:	0f 11 43 08          	movups %xmm0,0x8(%rbx)
  708312:	48 89 03             	mov    %rax,(%rbx)
  708315:	e9 8b f7 ff ff       	jmp    707aa5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x95>
  70831a:	48 8d 3d e7 19 3f 00 	lea    0x3f19e7(%rip),%rdi        # af9d08 <__frame_dummy_init_array_entry+0x7e0>
  708321:	ff 15 99 fc 41 00    	call   *0x41fc99(%rip)        # b27fc0 <_DYNAMIC+0x308>
  708327:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  70832c:	e8 4f f7 fe ff       	call   6f7a80 <core::ptr::drop_glue::<gpui::runtime::Error>>
  708331:	41 0f 10 86 60 06 00 	movups 0x660(%r14),%xmm0
  708338:	00 
  708339:	41 0f b6 86 20 08 00 	movzbl 0x820(%r14),%eax
  708340:	00 
  708341:	49 83 be 80 06 00 00 	cmpq   $0x0,0x680(%r14)
  708348:	00 
  708349:	74 1c                	je     708367 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x957>
  70834b:	84 c0                	test   %al,%al
  70834d:	74 0a                	je     708359 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x949>
  70834f:	49 83 be 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%r14)
  708356:	ff 
  708357:	74 0e                	je     708367 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x957>
  708359:	49 8b 96 90 06 00 00 	mov    0x690(%r14),%rdx
  708360:	b9 01 00 00 00       	mov    $0x1,%ecx
  708365:	eb 02                	jmp    708369 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x959>
  708367:	31 c9                	xor    %ecx,%ecx
  708369:	49 8b b6 08 07 00 00 	mov    0x708(%r14),%rsi
  708370:	48 89 4b 08          	mov    %rcx,0x8(%rbx)
  708374:	48 89 53 10          	mov    %rdx,0x10(%rbx)
  708378:	0f 11 43 18          	movups %xmm0,0x18(%rbx)
  70837c:	48 89 73 28          	mov    %rsi,0x28(%rbx)
  708380:	e9 f0 f9 ff ff       	jmp    707d75 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x365>
  708385:	83 f8 23             	cmp    $0x23,%eax
  708388:	0f 85 eb 00 00 00    	jne    708479 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0xa69>
  70838e:	8b 44 24 30          	mov    0x30(%rsp),%eax
  708392:	83 f8 0d             	cmp    $0xd,%eax
  708395:	0f 84 12 01 00 00    	je     7084ad <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0xa9d>
  70839b:	83 f8 0e             	cmp    $0xe,%eax
  70839e:	0f 85 d5 00 00 00    	jne    708479 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0xa69>
  7083a4:	ba 07 00 00 00       	mov    $0x7,%edx
  7083a9:	e9 04 01 00 00       	jmp    7084b2 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0xaa2>
  7083ae:	c6 84 24 a0 00 00 00 	movb   $0x0,0xa0(%rsp)
  7083b5:	00 
  7083b6:	c7 84 24 a4 00 00 00 	movl   $0x0,0xa4(%rsp)
  7083bd:	00 00 00 00 
  7083c1:	48 8d b4 24 a0 00 00 	lea    0xa0(%rsp),%rsi
  7083c8:	00 
  7083c9:	8b 7c 24 08          	mov    0x8(%rsp),%edi
  7083cd:	ff 15 dd fd 41 00    	call   *0x41fddd(%rip)        # b281b0 <_DYNAMIC+0x4f8>
  7083d3:	66 85 c0             	test   %ax,%ax
  7083d6:	74 2a                	je     708402 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x9f2>
  7083d8:	48 c1 e8 10          	shr    $0x10,%rax
  7083dc:	48 89 df             	mov    %rbx,%rdi
  7083df:	4c 89 f6             	mov    %r14,%rsi
  7083e2:	89 c2                	mov    %eax,%edx
  7083e4:	48 81 c4 28 01 00 00 	add    $0x128,%rsp
  7083eb:	5b                   	pop    %rbx
  7083ec:	41 5c                	pop    %r12
  7083ee:	41 5d                	pop    %r13
  7083f0:	41 5e                	pop    %r14
  7083f2:	41 5f                	pop    %r15
  7083f4:	5d                   	pop    %rbp
  7083f5:	e9 f6 f4 ff ff       	jmp    7078f0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::reject_editor>
  7083fa:	c6 84 24 a0 00 00 00 	movb   $0xff,0xa0(%rsp)
  708401:	ff 
  708402:	4d 8b be 60 06 00 00 	mov    0x660(%r14),%r15
  708409:	49 83 ff ff          	cmp    $0xffffffffffffffff,%r15
  70840d:	0f 84 8e 00 00 00    	je     7084a1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0xa91>
  708413:	48 c7 44 24 28 1f 00 	movq   $0x1f,0x28(%rsp)
  70841a:	00 00 
  70841c:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  708421:	e8 5a f6 fe ff       	call   6f7a80 <core::ptr::drop_glue::<gpui::runtime::Error>>
  708426:	49 8b 86 10 06 00 00 	mov    0x610(%r14),%rax
  70842d:	48 85 c0             	test   %rax,%rax
  708430:	0f 84 af 00 00 00    	je     7084e5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0xad5>
  708436:	48 8b 80 d8 00 00 00 	mov    0xd8(%rax),%rax
  70843d:	48 85 c0             	test   %rax,%rax
  708440:	0f 84 9f 00 00 00    	je     7084e5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0xad5>
  708446:	49 ff c7             	inc    %r15
  708449:	c6 40 13 ff          	movb   $0xff,0x13(%rax)
  70844d:	48 8d 84 24 a0 00 00 	lea    0xa0(%rsp),%rax
  708454:	00 
  708455:	48 89 04 24          	mov    %rax,(%rsp)
  708459:	48 89 df             	mov    %rbx,%rdi
  70845c:	4c 89 f6             	mov    %r14,%rsi
  70845f:	48 8b 54 24 60       	mov    0x60(%rsp),%rdx
  708464:	4c 89 e1             	mov    %r12,%rcx
  708467:	4d 89 f8             	mov    %r15,%r8
  70846a:	44 8b 4c 24 08       	mov    0x8(%rsp),%r9d
  70846f:	e8 2c 06 02 00       	call   728aa0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at>
  708474:	e9 2c f6 ff ff       	jmp    707aa5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x95>
  708479:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  70847e:	48 89 43 30          	mov    %rax,0x30(%rbx)
  708482:	0f 10 44 24 28       	movups 0x28(%rsp),%xmm0
  708487:	0f 10 4c 24 38       	movups 0x38(%rsp),%xmm1
  70848c:	0f 10 54 24 48       	movups 0x48(%rsp),%xmm2
  708491:	0f 11 53 20          	movups %xmm2,0x20(%rbx)
  708495:	0f 11 4b 10          	movups %xmm1,0x10(%rbx)
  708499:	0f 11 03             	movups %xmm0,(%rbx)
  70849c:	e9 04 f6 ff ff       	jmp    707aa5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x95>
  7084a1:	48 c7 03 1f 00 00 00 	movq   $0x1f,(%rbx)
  7084a8:	e9 f8 f5 ff ff       	jmp    707aa5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x95>
  7084ad:	ba 06 00 00 00       	mov    $0x6,%edx
  7084b2:	48 89 df             	mov    %rbx,%rdi
  7084b5:	4c 89 f6             	mov    %r14,%rsi
  7084b8:	e8 33 f4 ff ff       	call   7078f0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::reject_editor>
  7084bd:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  7084c2:	e8 b9 f5 fe ff       	call   6f7a80 <core::ptr::drop_glue::<gpui::runtime::Error>>
  7084c7:	e9 d9 f5 ff ff       	jmp    707aa5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x95>
  7084cc:	48 8d 3d b1 1e 96 ff 	lea    -0x69e14f(%rip),%rdi        # 6a384 <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x3297>
  7084d3:	48 8d 15 a6 18 3f 00 	lea    0x3f18a6(%rip),%rdx        # af9d80 <__frame_dummy_init_array_entry+0x858>
  7084da:	be 28 00 00 00       	mov    $0x28,%esi
  7084df:	ff 15 d3 fc 41 00    	call   *0x41fcd3(%rip)        # b281b8 <_DYNAMIC+0x500>
  7084e5:	48 8d 3d d9 1e 96 ff 	lea    -0x69e127(%rip),%rdi        # 6a3c5 <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x32d8>
  7084ec:	48 8d 15 9d 17 3f 00 	lea    0x3f179d(%rip),%rdx        # af9c90 <__frame_dummy_init_array_entry+0x768>
  7084f3:	be 11 00 00 00       	mov    $0x11,%esi
  7084f8:	ff 15 02 fb 41 00    	call   *0x41fb02(%rip)        # b28000 <_DYNAMIC+0x348>
  7084fe:	48 8d 3d 1b 18 3f 00 	lea    0x3f181b(%rip),%rdi        # af9d20 <__frame_dummy_init_array_entry+0x7f8>
  708505:	ff 15 b5 fa 41 00    	call   *0x41fab5(%rip)        # b27fc0 <_DYNAMIC+0x308>
  70850b:	4c 89 ff             	mov    %r15,%rdi
  70850e:	48 8d 15 23 18 3f 00 	lea    0x3f1823(%rip),%rdx        # af9d38 <__frame_dummy_init_array_entry+0x810>
  708515:	ff 15 f5 fa 41 00    	call   *0x41faf5(%rip)        # b28010 <_DYNAMIC+0x358>
  70851b:	0f 0b                	ud2
  70851d:	48 8d 3d 60 1e 96 ff 	lea    -0x69e1a0(%rip),%rdi        # 6a384 <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x3297>
  708524:	48 8d 15 6d 18 3f 00 	lea    0x3f186d(%rip),%rdx        # af9d98 <__frame_dummy_init_array_entry+0x870>
  70852b:	be 28 00 00 00       	mov    $0x28,%esi
  708530:	ff 15 82 fc 41 00    	call   *0x41fc82(%rip)        # b281b8 <_DYNAMIC+0x500>
  708536:	48 8d 15 13 18 3f 00 	lea    0x3f1813(%rip),%rdx        # af9d50 <__frame_dummy_init_array_entry+0x828>
  70853d:	4c 89 e7             	mov    %r12,%rdi
  708540:	ff 15 ca fa 41 00    	call   *0x41faca(%rip)        # b28010 <_DYNAMIC+0x358>
  708546:	48 8d 15 1b 18 3f 00 	lea    0x3f181b(%rip),%rdx        # af9d68 <__frame_dummy_init_array_entry+0x840>
  70854d:	4c 89 ff             	mov    %r15,%rdi
  708550:	ff 15 ba fa 41 00    	call   *0x41faba(%rip)        # b28010 <_DYNAMIC+0x358>
  708556:	48 89 c3             	mov    %rax,%rbx
  708559:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  70855e:	e8 1d f5 fe ff       	call   6f7a80 <core::ptr::drop_glue::<gpui::runtime::Error>>
  708563:	48 89 df             	mov    %rbx,%rdi
  708566:	e8 05 fc 3e 00       	call   af8170 <_Unwind_Resume@plt>
  70856b:	4c 8b 74 24 20       	mov    0x20(%rsp),%r14
  708570:	48 89 c3             	mov    %rax,%rbx
  708573:	49 8b 75 08          	mov    0x8(%r13),%rsi
  708577:	48 85 f6             	test   %rsi,%rsi
  70857a:	74 0d                	je     708589 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0xb79>
  70857c:	49 8b 55 10          	mov    0x10(%r13),%rdx
  708580:	48 89 ef             	mov    %rbp,%rdi
  708583:	ff 15 77 f9 41 00    	call   *0x41f977(%rip)        # b27f00 <_DYNAMIC+0x248>
  708589:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  70858e:	49 89 06             	mov    %rax,(%r14)
  708591:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  708596:	49 89 44 24 10       	mov    %rax,0x10(%r12)
  70859b:	48 89 df             	mov    %rbx,%rdi
  70859e:	e8 cd fb 3e 00       	call   af8170 <_Unwind_Resume@plt>
  7085a3:	48 89 c3             	mov    %rax,%rbx
  7085a6:	48 8b 7c 24 10       	mov    0x10(%rsp),%rdi
  7085ab:	48 8b 74 24 08       	mov    0x8(%rsp),%rsi
  7085b0:	e8 4b be fe ff       	call   6f4400 <core::ptr::drop_glue::<core::option::Option<gpui::element::Handler>>>
  7085b5:	48 89 df             	mov    %rbx,%rdi
  7085b8:	e8 b3 fb 3e 00       	call   af8170 <_Unwind_Resume@plt>
  7085bd:	ff 15 6d f9 41 00    	call   *0x41f96d(%rip)        # b27f30 <_DYNAMIC+0x278>
