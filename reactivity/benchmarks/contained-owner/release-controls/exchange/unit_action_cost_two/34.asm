
/tmp/gpui-contained-property-exchange-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

0000000000708ce0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action>:
  708ce0:	55                   	push   %rbp
  708ce1:	41 57                	push   %r15
  708ce3:	41 56                	push   %r14
  708ce5:	41 55                	push   %r13
  708ce7:	41 54                	push   %r12
  708ce9:	53                   	push   %rbx
  708cea:	48 81 ec 28 01 00 00 	sub    $0x128,%rsp
  708cf1:	48 89 fb             	mov    %rdi,%rbx
  708cf4:	80 be 22 08 00 00 00 	cmpb   $0x0,0x822(%rsi)
  708cfb:	74 09                	je     708d06 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x26>
  708cfd:	48 c7 03 0e 00 00 00 	movq   $0xe,(%rbx)
  708d04:	eb 6f                	jmp    708d75 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x95>
  708d06:	49 89 f6             	mov    %rsi,%r14
  708d09:	48 8b 86 10 06 00 00 	mov    0x610(%rsi),%rax
  708d10:	48 85 c0             	test   %rax,%rax
  708d13:	74 59                	je     708d6e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x8e>
  708d15:	48 83 b8 d8 00 00 00 	cmpq   $0x0,0xd8(%rax)
  708d1c:	00 
  708d1d:	74 4f                	je     708d6e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x8e>
  708d1f:	49 c7 86 08 07 00 00 	movq   $0x0,0x708(%r14)
  708d26:	00 00 00 00 
  708d2a:	48 8b a8 d8 00 00 00 	mov    0xd8(%rax),%rbp
  708d31:	48 85 ed             	test   %rbp,%rbp
  708d34:	0f 84 b0 08 00 00    	je     7095ea <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x90a>
  708d3a:	44 0f b7 65 10       	movzwl 0x10(%rbp),%r12d
  708d3f:	0f b6 7d 16          	movzbl 0x16(%rbp),%edi
  708d43:	44 0f b6 45 12       	movzbl 0x12(%rbp),%r8d
  708d48:	89 c8                	mov    %ecx,%eax
  708d4a:	66 83 e8 0e          	sub    $0xe,%ax
  708d4e:	41 bf 03 00 00 00    	mov    $0x3,%r15d
  708d54:	44 0f 43 f8          	cmovae %eax,%r15d
  708d58:	66 41 83 ff 03       	cmp    $0x3,%r15w
  708d5d:	75 28                	jne    708d87 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0xa7>
  708d5f:	66 41 39 cc          	cmp    %cx,%r12w
  708d63:	74 22                	je     708d87 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0xa7>
  708d65:	48 c7 03 11 00 00 00 	movq   $0x11,(%rbx)
  708d6c:	eb 07                	jmp    708d75 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x95>
  708d6e:	48 c7 03 1a 00 00 00 	movq   $0x1a,(%rbx)
  708d75:	48 81 c4 28 01 00 00 	add    $0x128,%rsp
  708d7c:	5b                   	pop    %rbx
  708d7d:	41 5c                	pop    %r12
  708d7f:	41 5d                	pop    %r13
  708d81:	41 5e                	pop    %r14
  708d83:	41 5f                	pop    %r15
  708d85:	5d                   	pop    %rbp
  708d86:	c3                   	ret
  708d87:	41 89 cd             	mov    %ecx,%r13d
  708d8a:	41 c1 ed 10          	shr    $0x10,%r13d
  708d8e:	45 0f b7 cf          	movzwl %r15w,%r9d
  708d92:	48 8d 05 77 2a 95 ff 	lea    -0x6ad589(%rip),%rax        # 5b810 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x10>
  708d99:	4a 63 34 88          	movslq (%rax,%r9,4),%rsi
  708d9d:	48 01 c6             	add    %rax,%rsi
  708da0:	ff e6                	jmp    *%rsi
  708da2:	44 0f b7 ff          	movzwl %di,%r15d
  708da6:	41 81 cf 00 01 00 00 	or     $0x100,%r15d
  708dad:	eb 12                	jmp    708dc1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0xe1>
  708daf:	45 0f b7 f8          	movzwl %r8w,%r15d
  708db3:	41 c1 e7 08          	shl    $0x8,%r15d
  708db7:	66 45 39 e5          	cmp    %r12w,%r13w
  708dbb:	0f 85 f3 02 00 00    	jne    7090b4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x3d4>
  708dc1:	b0 01                	mov    $0x1,%al
  708dc3:	44 38 ff             	cmp    %r15b,%dil
  708dc6:	0f 85 ed 02 00 00    	jne    7090b9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x3d9>
  708dcc:	41 0f b7 cf          	movzwl %r15w,%ecx
  708dd0:	c1 e9 08             	shr    $0x8,%ecx
  708dd3:	41 38 c8             	cmp    %cl,%r8b
  708dd6:	0f 85 dd 02 00 00    	jne    7090b9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x3d9>
  708ddc:	80 7d 13 ff          	cmpb   $0xff,0x13(%rbp)
  708de0:	0f 85 d3 02 00 00    	jne    7090b9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x3d9>
  708de6:	e9 c4 01 00 00       	jmp    708faf <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x2cf>
  708deb:	f7 c1 00 00 ff 00    	test   $0xff0000,%ecx
  708df1:	0f 84 5d 02 00 00    	je     709054 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x374>
  708df7:	48 8b 45 00          	mov    0x0(%rbp),%rax
  708dfb:	48 85 c0             	test   %rax,%rax
  708dfe:	0f 84 ab 01 00 00    	je     708faf <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x2cf>
  708e04:	49 3b 86 b0 05 00 00 	cmp    0x5b0(%r14),%rax
  708e0b:	0f 85 d4 01 00 00    	jne    708fe5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x305>
  708e11:	4c 89 4c 24 18       	mov    %r9,0x18(%rsp)
  708e16:	48 89 7c 24 10       	mov    %rdi,0x10(%rsp)
  708e1b:	48 89 54 24 60       	mov    %rdx,0x60(%rsp)
  708e20:	89 4c 24 08          	mov    %ecx,0x8(%rsp)
  708e24:	4c 8b 65 08          	mov    0x8(%rbp),%r12
  708e28:	48 c7 44 24 28 11 00 	movq   $0x11,0x28(%rsp)
  708e2f:	00 00 
  708e31:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  708e36:	e8 b5 f0 fe ff       	call   6f7ef0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  708e3b:	48 8d bc 24 c0 00 00 	lea    0xc0(%rsp),%rdi
  708e42:	00 
  708e43:	4c 89 f6             	mov    %r14,%rsi
  708e46:	4c 89 e2             	mov    %r12,%rdx
  708e49:	e8 32 15 01 00       	call   71a380 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::resolve_identity>
  708e4e:	48 8b 84 24 c0 00 00 	mov    0xc0(%rsp),%rax
  708e55:	00 
  708e56:	4c 8b a4 24 c8 00 00 	mov    0xc8(%rsp),%r12
  708e5d:	00 
  708e5e:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  708e62:	0f 85 fc 05 00 00    	jne    709464 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x784>
  708e68:	49 8b 86 10 06 00 00 	mov    0x610(%r14),%rax
  708e6f:	48 85 c0             	test   %rax,%rax
  708e72:	0f 84 2f 06 00 00    	je     7094a7 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x7c7>
  708e78:	48 83 b8 d8 00 00 00 	cmpq   $0x0,0xd8(%rax)
  708e7f:	00 
  708e80:	0f 84 21 06 00 00    	je     7094a7 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x7c7>
  708e86:	49 8b ae a0 02 00 00 	mov    0x2a0(%r14),%rbp
  708e8d:	48 c7 44 24 28 1a 00 	movq   $0x1a,0x28(%rsp)
  708e94:	00 00 
  708e96:	48 83 fd 1c          	cmp    $0x1c,%rbp
  708e9a:	0f 82 07 06 00 00    	jb     7094a7 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x7c7>
  708ea0:	48 83 c5 e4          	add    $0xffffffffffffffe4,%rbp
  708ea4:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  708ea9:	e8 42 f0 fe ff       	call   6f7ef0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  708eae:	49 83 fc 02          	cmp    $0x2,%r12
  708eb2:	0f 93 c0             	setae  %al
  708eb5:	49 39 ec             	cmp    %rbp,%r12
  708eb8:	0f 92 c1             	setb   %cl
  708ebb:	84 c8                	test   %cl,%al
  708ebd:	0f 84 22 01 00 00    	je     708fe5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x305>
  708ec3:	66 41 83 ff 01       	cmp    $0x1,%r15w
  708ec8:	0f 84 3d 06 00 00    	je     70950b <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x82b>
  708ece:	83 7c 24 18 03       	cmpl   $0x3,0x18(%rsp)
  708ed3:	0f 85 c3 08 00 00    	jne    70979c <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0xabc>
  708ed9:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  708ede:	4c 89 f6             	mov    %r14,%rsi
  708ee1:	4c 89 e2             	mov    %r12,%rdx
  708ee4:	8b 4c 24 08          	mov    0x8(%rsp),%ecx
  708ee8:	e8 a3 09 02 00       	call   729890 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::property_value_at>
  708eed:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  708ef2:	0f 10 44 24 30       	movups 0x30(%rsp),%xmm0
  708ef7:	0f 29 84 24 c0 00 00 	movaps %xmm0,0xc0(%rsp)
  708efe:	00 
  708eff:	0f 10 44 24 3c       	movups 0x3c(%rsp),%xmm0
  708f04:	0f 11 84 24 cc 00 00 	movups %xmm0,0xcc(%rsp)
  708f0b:	00 
  708f0c:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  708f10:	0f 85 a4 06 00 00    	jne    7095ba <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x8da>
  708f16:	0f 28 84 24 c0 00 00 	movaps 0xc0(%rsp),%xmm0
  708f1d:	00 
  708f1e:	0f 29 84 24 00 01 00 	movaps %xmm0,0x100(%rsp)
  708f25:	00 
  708f26:	0f 10 84 24 cc 00 00 	movups 0xcc(%rsp),%xmm0
  708f2d:	00 
  708f2e:	0f 11 84 24 0c 01 00 	movups %xmm0,0x10c(%rsp)
  708f35:	00 
  708f36:	41 0f b6 c5          	movzbl %r13b,%eax
  708f3a:	48 8d 0d df 28 95 ff 	lea    -0x6ad721(%rip),%rcx        # 5b820 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x20>
  708f41:	48 63 04 81          	movslq (%rcx,%rax,4),%rax
  708f45:	48 01 c8             	add    %rcx,%rax
  708f48:	ff e0                	jmp    *%rax
  708f4a:	8b 44 24 08          	mov    0x8(%rsp),%eax
  708f4e:	25 00 00 ff 00       	and    $0xff0000,%eax
  708f53:	31 c9                	xor    %ecx,%ecx
  708f55:	3d 00 00 02 00       	cmp    $0x20000,%eax
  708f5a:	0f 94 c1             	sete   %cl
  708f5d:	48 8d 05 54 26 95 ff 	lea    -0x6ad9ac(%rip),%rax        # 5b5b8 <anon.079f5e587c394fcac2765eb4d0cf0bc2.21.llvm.6319143315422321905+0x48>
  708f64:	f3 0f 10 04 88       	movss  (%rax,%rcx,4),%xmm0
  708f69:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  708f6e:	48 8d b4 24 00 01 00 	lea    0x100(%rsp),%rsi
  708f75:	00 
  708f76:	48 8b 54 24 10       	mov    0x10(%rsp),%rdx
  708f7b:	ff 15 f7 05 42 00    	call   *0x4205f7(%rip)        # b29578 <_DYNAMIC+0x4f0>
  708f81:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  708f86:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  708f8a:	0f 85 c5 06 00 00    	jne    709655 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x975>
  708f90:	0f 10 44 24 30       	movups 0x30(%rsp),%xmm0
  708f95:	0f 10 4c 24 3c       	movups 0x3c(%rsp),%xmm1
  708f9a:	0f 11 8c 24 ac 00 00 	movups %xmm1,0xac(%rsp)
  708fa1:	00 
  708fa2:	0f 29 84 24 a0 00 00 	movaps %xmm0,0xa0(%rsp)
  708fa9:	00 
  708faa:	e9 e2 06 00 00       	jmp    709691 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x9b1>
  708faf:	41 0f 10 86 60 06 00 	movups 0x660(%r14),%xmm0
  708fb6:	00 
  708fb7:	41 0f b6 86 20 08 00 	movzbl 0x820(%r14),%eax
  708fbe:	00 
  708fbf:	49 83 be 80 06 00 00 	cmpq   $0x0,0x680(%r14)
  708fc6:	00 
  708fc7:	74 66                	je     70902f <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x34f>
  708fc9:	84 c0                	test   %al,%al
  708fcb:	74 0a                	je     708fd7 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x2f7>
  708fcd:	49 83 be 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%r14)
  708fd4:	ff 
  708fd5:	74 58                	je     70902f <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x34f>
  708fd7:	49 8b 96 90 06 00 00 	mov    0x690(%r14),%rdx
  708fde:	b9 01 00 00 00       	mov    $0x1,%ecx
  708fe3:	eb 4c                	jmp    709031 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x351>
  708fe5:	48 c7 44 24 68 11 00 	movq   $0x11,0x68(%rsp)
  708fec:	00 00 
  708fee:	41 0f 10 86 60 06 00 	movups 0x660(%r14),%xmm0
  708ff5:	00 
  708ff6:	41 0f b6 86 20 08 00 	movzbl 0x820(%r14),%eax
  708ffd:	00 
  708ffe:	49 83 be 80 06 00 00 	cmpq   $0x0,0x680(%r14)
  709005:	00 
  709006:	0f 84 26 04 00 00    	je     709432 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x752>
  70900c:	84 c0                	test   %al,%al
  70900e:	74 0e                	je     70901e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x33e>
  709010:	49 83 be 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%r14)
  709017:	ff 
  709018:	0f 84 14 04 00 00    	je     709432 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x752>
  70901e:	49 8b 96 90 06 00 00 	mov    0x690(%r14),%rdx
  709025:	b9 01 00 00 00       	mov    $0x1,%ecx
  70902a:	e9 05 04 00 00       	jmp    709434 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x754>
  70902f:	31 c9                	xor    %ecx,%ecx
  709031:	48 89 4b 08          	mov    %rcx,0x8(%rbx)
  709035:	48 89 53 10          	mov    %rdx,0x10(%rbx)
  709039:	0f 11 43 18          	movups %xmm0,0x18(%rbx)
  70903d:	48 c7 43 28 00 00 00 	movq   $0x0,0x28(%rbx)
  709044:	00 
  709045:	88 43 30             	mov    %al,0x30(%rbx)
  709048:	48 c7 03 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rbx)
  70904f:	e9 21 fd ff ff       	jmp    708d75 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x95>
  709054:	45 0f b7 f8          	movzwl %r8w,%r15d
  709058:	8d 47 01             	lea    0x1(%rdi),%eax
  70905b:	89 44 24 18          	mov    %eax,0x18(%rsp)
  70905f:	48 89 7c 24 10       	mov    %rdi,0x10(%rsp)
  709064:	89 cf                	mov    %ecx,%edi
  709066:	89 4c 24 08          	mov    %ecx,0x8(%rsp)
  70906a:	45 89 c5             	mov    %r8d,%r13d
  70906d:	e8 5e ba ff ff       	call   704ad0 <<gpui::property::PropertyId>::info>
  709072:	45 89 e8             	mov    %r13d,%r8d
  709075:	48 8b 7c 24 10       	mov    0x10(%rsp),%rdi
  70907a:	44 8b 6c 24 08       	mov    0x8(%rsp),%r13d
  70907f:	0f b6 40 14          	movzbl 0x14(%rax),%eax
  709083:	31 c9                	xor    %ecx,%ecx
  709085:	3c 04                	cmp    $0x4,%al
  709087:	0f 94 c1             	sete   %cl
  70908a:	8d 0c 89             	lea    (%rcx,%rcx,4),%ecx
  70908d:	ff c1                	inc    %ecx
  70908f:	3c 02                	cmp    $0x2,%al
  709091:	ba 04 00 00 00       	mov    $0x4,%edx
  709096:	0f 45 d1             	cmovne %ecx,%edx
  709099:	0f b6 44 24 18       	movzbl 0x18(%rsp),%eax
  70909e:	f6 f2                	div    %dl
  7090a0:	0f b6 c4             	movzbl %ah,%eax
  7090a3:	41 c1 e7 08          	shl    $0x8,%r15d
  7090a7:	41 09 c7             	or     %eax,%r15d
  7090aa:	66 45 39 e5          	cmp    %r12w,%r13w
  7090ae:	0f 84 0d fd ff ff    	je     708dc1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0xe1>
  7090b4:	31 c0                	xor    %eax,%eax
  7090b6:	45 89 ec             	mov    %r13d,%r12d
  7090b9:	49 8b 96 60 06 00 00 	mov    0x660(%r14),%rdx
  7090c0:	48 ff c2             	inc    %rdx
  7090c3:	0f 84 a8 06 00 00    	je     709771 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0xa91>
  7090c9:	41 0f b7 cf          	movzwl %r15w,%ecx
  7090cd:	66 44 89 65 10       	mov    %r12w,0x10(%rbp)
  7090d2:	88 4d 16             	mov    %cl,0x16(%rbp)
  7090d5:	88 6d 12             	mov    %ch,0x12(%rbp)
  7090d8:	c6 45 13 ff          	movb   $0xff,0x13(%rbp)
  7090dc:	84 c0                	test   %al,%al
  7090de:	0f 85 11 03 00 00    	jne    7093f5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x715>
  7090e4:	49 8b 86 10 06 00 00 	mov    0x610(%r14),%rax
  7090eb:	48 85 c0             	test   %rax,%rax
  7090ee:	0f 84 da 06 00 00    	je     7097ce <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0xaee>
  7090f4:	48 83 b8 d8 00 00 00 	cmpq   $0x0,0xd8(%rax)
  7090fb:	00 
  7090fc:	0f 84 cc 06 00 00    	je     7097ce <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0xaee>
  709102:	4d 8b be a0 02 00 00 	mov    0x2a0(%r14),%r15
  709109:	49 83 ff 1c          	cmp    $0x1c,%r15
  70910d:	0f 82 bb 06 00 00    	jb     7097ce <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0xaee>
  709113:	48 89 54 24 60       	mov    %rdx,0x60(%rsp)
  709118:	41 0f b7 fc          	movzwl %r12w,%edi
  70911c:	48 89 7c 24 18       	mov    %rdi,0x18(%rsp)
  709121:	ff 15 59 04 42 00    	call   *0x420459(%rip)        # b29580 <_DYNAMIC+0x4f8>
  709127:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  70912c:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
  709131:	49 8d 7f f7          	lea    -0x9(%r15),%rdi
  709135:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  70913c:	48 39 f7             	cmp    %rsi,%rdi
  70913f:	0f 83 99 06 00 00    	jae    7097de <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0xafe>
  709145:	49 8b 8e 98 02 00 00 	mov    0x298(%r14),%rcx
  70914c:	48 8d 14 bf          	lea    (%rdi,%rdi,4),%rdx
  709150:	4c 8d 24 d1          	lea    (%rcx,%rdx,8),%r12
  709154:	48 8b 6c d1 08       	mov    0x8(%rcx,%rdx,8),%rbp
  709159:	48 85 ed             	test   %rbp,%rbp
  70915c:	74 36                	je     709194 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x4b4>
  70915e:	4c 8b 6c d1 10       	mov    0x10(%rcx,%rdx,8),%r13
  709163:	49 8b 45 00          	mov    0x0(%r13),%rax
  709167:	48 85 c0             	test   %rax,%rax
  70916a:	74 12                	je     70917e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x49e>
  70916c:	48 8d 0c d1          	lea    (%rcx,%rdx,8),%rcx
  709170:	48 83 c1 08          	add    $0x8,%rcx
  709174:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  709179:	48 89 ef             	mov    %rbp,%rdi
  70917c:	ff d0                	call   *%rax
  70917e:	49 8b 75 08          	mov    0x8(%r13),%rsi
  709182:	48 85 f6             	test   %rsi,%rsi
  709185:	74 0d                	je     709194 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x4b4>
  709187:	49 8b 55 10          	mov    0x10(%r13),%rdx
  70918b:	48 89 ef             	mov    %rbp,%rdi
  70918e:	ff 15 3c 01 42 00    	call   *0x42013c(%rip)        # b292d0 <_DYNAMIC+0x248>
  709194:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  709199:	49 89 44 24 08       	mov    %rax,0x8(%r12)
  70919e:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  7091a3:	49 89 44 24 10       	mov    %rax,0x10(%r12)
  7091a8:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  7091ad:	8d b8 00 00 01 00    	lea    0x10000(%rax),%edi
  7091b3:	ff 15 c7 03 42 00    	call   *0x4203c7(%rip)        # b29580 <_DYNAMIC+0x4f8>
  7091b9:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  7091be:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
  7091c3:	49 8d 7f f9          	lea    -0x7(%r15),%rdi
  7091c7:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  7091ce:	48 39 f7             	cmp    %rsi,%rdi
  7091d1:	0f 83 07 06 00 00    	jae    7097de <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0xafe>
  7091d7:	49 8b 8e 98 02 00 00 	mov    0x298(%r14),%rcx
  7091de:	48 8d 14 bf          	lea    (%rdi,%rdi,4),%rdx
  7091e2:	4c 8d 24 d1          	lea    (%rcx,%rdx,8),%r12
  7091e6:	48 8b 6c d1 08       	mov    0x8(%rcx,%rdx,8),%rbp
  7091eb:	48 85 ed             	test   %rbp,%rbp
  7091ee:	74 36                	je     709226 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x546>
  7091f0:	4c 8b 6c d1 10       	mov    0x10(%rcx,%rdx,8),%r13
  7091f5:	49 8b 45 00          	mov    0x0(%r13),%rax
  7091f9:	48 85 c0             	test   %rax,%rax
  7091fc:	74 12                	je     709210 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x530>
  7091fe:	48 8d 0c d1          	lea    (%rcx,%rdx,8),%rcx
  709202:	48 83 c1 08          	add    $0x8,%rcx
  709206:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  70920b:	48 89 ef             	mov    %rbp,%rdi
  70920e:	ff d0                	call   *%rax
  709210:	49 8b 75 08          	mov    0x8(%r13),%rsi
  709214:	48 85 f6             	test   %rsi,%rsi
  709217:	74 0d                	je     709226 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x546>
  709219:	49 8b 55 10          	mov    0x10(%r13),%rdx
  70921d:	48 89 ef             	mov    %rbp,%rdi
  709220:	ff 15 aa 00 42 00    	call   *0x4200aa(%rip)        # b292d0 <_DYNAMIC+0x248>
  709226:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  70922b:	49 89 44 24 08       	mov    %rax,0x8(%r12)
  709230:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  709235:	49 89 44 24 10       	mov    %rax,0x10(%r12)
  70923a:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  70923f:	8d b8 00 00 02 00    	lea    0x20000(%rax),%edi
  709245:	ff 15 35 03 42 00    	call   *0x420335(%rip)        # b29580 <_DYNAMIC+0x4f8>
  70924b:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  709250:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
  709255:	49 8d 7f fa          	lea    -0x6(%r15),%rdi
  709259:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  709260:	48 39 f7             	cmp    %rsi,%rdi
  709263:	0f 83 75 05 00 00    	jae    7097de <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0xafe>
  709269:	49 8b 8e 98 02 00 00 	mov    0x298(%r14),%rcx
  709270:	48 8d 14 bf          	lea    (%rdi,%rdi,4),%rdx
  709274:	4c 8d 24 d1          	lea    (%rcx,%rdx,8),%r12
  709278:	48 8b 6c d1 08       	mov    0x8(%rcx,%rdx,8),%rbp
  70927d:	48 85 ed             	test   %rbp,%rbp
  709280:	74 36                	je     7092b8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x5d8>
  709282:	4c 8b 6c d1 10       	mov    0x10(%rcx,%rdx,8),%r13
  709287:	49 8b 45 00          	mov    0x0(%r13),%rax
  70928b:	48 85 c0             	test   %rax,%rax
  70928e:	74 12                	je     7092a2 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x5c2>
  709290:	48 8d 0c d1          	lea    (%rcx,%rdx,8),%rcx
  709294:	48 83 c1 08          	add    $0x8,%rcx
  709298:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  70929d:	48 89 ef             	mov    %rbp,%rdi
  7092a0:	ff d0                	call   *%rax
  7092a2:	49 8b 75 08          	mov    0x8(%r13),%rsi
  7092a6:	48 85 f6             	test   %rsi,%rsi
  7092a9:	74 0d                	je     7092b8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x5d8>
  7092ab:	49 8b 55 10          	mov    0x10(%r13),%rdx
  7092af:	48 89 ef             	mov    %rbp,%rdi
  7092b2:	ff 15 18 00 42 00    	call   *0x420018(%rip)        # b292d0 <_DYNAMIC+0x248>
  7092b8:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  7092bd:	49 89 44 24 08       	mov    %rax,0x8(%r12)
  7092c2:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  7092c7:	49 89 44 24 10       	mov    %rax,0x10(%r12)
  7092cc:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  7092d1:	8d b8 00 00 03 00    	lea    0x30000(%rax),%edi
  7092d7:	ff 15 a3 02 42 00    	call   *0x4202a3(%rip)        # b29580 <_DYNAMIC+0x4f8>
  7092dd:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  7092e2:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
  7092e7:	49 8d 7f fb          	lea    -0x5(%r15),%rdi
  7092eb:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  7092f2:	48 39 f7             	cmp    %rsi,%rdi
  7092f5:	0f 83 e3 04 00 00    	jae    7097de <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0xafe>
  7092fb:	49 8b 8e 98 02 00 00 	mov    0x298(%r14),%rcx
  709302:	48 8d 14 bf          	lea    (%rdi,%rdi,4),%rdx
  709306:	4c 8d 24 d1          	lea    (%rcx,%rdx,8),%r12
  70930a:	48 8b 6c d1 08       	mov    0x8(%rcx,%rdx,8),%rbp
  70930f:	48 85 ed             	test   %rbp,%rbp
  709312:	74 36                	je     70934a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x66a>
  709314:	4c 8b 6c d1 10       	mov    0x10(%rcx,%rdx,8),%r13
  709319:	49 8b 45 00          	mov    0x0(%r13),%rax
  70931d:	48 85 c0             	test   %rax,%rax
  709320:	74 12                	je     709334 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x654>
  709322:	48 8d 0c d1          	lea    (%rcx,%rdx,8),%rcx
  709326:	48 83 c1 08          	add    $0x8,%rcx
  70932a:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  70932f:	48 89 ef             	mov    %rbp,%rdi
  709332:	ff d0                	call   *%rax
  709334:	49 8b 75 08          	mov    0x8(%r13),%rsi
  709338:	48 85 f6             	test   %rsi,%rsi
  70933b:	74 0d                	je     70934a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x66a>
  70933d:	49 8b 55 10          	mov    0x10(%r13),%rdx
  709341:	48 89 ef             	mov    %rbp,%rdi
  709344:	ff 15 86 ff 41 00    	call   *0x41ff86(%rip)        # b292d0 <_DYNAMIC+0x248>
  70934a:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  70934f:	49 89 44 24 08       	mov    %rax,0x8(%r12)
  709354:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  709359:	49 89 44 24 10       	mov    %rax,0x10(%r12)
  70935e:	48 8b 7c 24 18       	mov    0x18(%rsp),%rdi
  709363:	81 cf 00 00 04 00    	or     $0x40000,%edi
  709369:	ff 15 11 02 42 00    	call   *0x420211(%rip)        # b29580 <_DYNAMIC+0x4f8>
  70936f:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  709374:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
  709379:	49 83 c7 fc          	add    $0xfffffffffffffffc,%r15
  70937d:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  709384:	49 39 f7             	cmp    %rsi,%r15
  709387:	0f 83 4e 04 00 00    	jae    7097db <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0xafb>
  70938d:	49 8b 8e 98 02 00 00 	mov    0x298(%r14),%rcx
  709394:	4b 8d 14 bf          	lea    (%r15,%r15,4),%rdx
  709398:	4c 8d 24 d1          	lea    (%rcx,%rdx,8),%r12
  70939c:	48 8b 6c d1 08       	mov    0x8(%rcx,%rdx,8),%rbp
  7093a1:	48 85 ed             	test   %rbp,%rbp
  7093a4:	74 36                	je     7093dc <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x6fc>
  7093a6:	4c 8b 6c d1 10       	mov    0x10(%rcx,%rdx,8),%r13
  7093ab:	49 8b 45 00          	mov    0x0(%r13),%rax
  7093af:	48 85 c0             	test   %rax,%rax
  7093b2:	74 12                	je     7093c6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x6e6>
  7093b4:	48 8d 0c d1          	lea    (%rcx,%rdx,8),%rcx
  7093b8:	48 83 c1 08          	add    $0x8,%rcx
  7093bc:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  7093c1:	48 89 ef             	mov    %rbp,%rdi
  7093c4:	ff d0                	call   *%rax
  7093c6:	49 8b 75 08          	mov    0x8(%r13),%rsi
  7093ca:	48 85 f6             	test   %rsi,%rsi
  7093cd:	74 0d                	je     7093dc <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x6fc>
  7093cf:	49 8b 55 10          	mov    0x10(%r13),%rdx
  7093d3:	48 89 ef             	mov    %rbp,%rdi
  7093d6:	ff 15 f4 fe 41 00    	call   *0x41fef4(%rip)        # b292d0 <_DYNAMIC+0x248>
  7093dc:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  7093e1:	49 89 44 24 08       	mov    %rax,0x8(%r12)
  7093e6:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  7093eb:	49 89 44 24 10       	mov    %rax,0x10(%r12)
  7093f0:	48 8b 54 24 60       	mov    0x60(%rsp),%rdx
  7093f5:	49 89 96 60 06 00 00 	mov    %rdx,0x660(%r14)
  7093fc:	49 ff 86 b0 06 00 00 	incq   0x6b0(%r14)
  709403:	49 c7 86 08 07 00 00 	movq   $0x0,0x708(%r14)
  70940a:	00 00 00 00 
  70940e:	41 c6 86 1f 08 00 00 	movb   $0x1,0x81f(%r14)
  709415:	01 
  709416:	48 89 df             	mov    %rbx,%rdi
  709419:	4c 89 f6             	mov    %r14,%rsi
  70941c:	48 81 c4 28 01 00 00 	add    $0x128,%rsp
  709423:	5b                   	pop    %rbx
  709424:	41 5c                	pop    %r12
  709426:	41 5d                	pop    %r13
  709428:	41 5e                	pop    %r14
  70942a:	41 5f                	pop    %r15
  70942c:	5d                   	pop    %rbp
  70942d:	e9 be 17 01 00       	jmp    71abf0 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::present>
  709432:	31 c9                	xor    %ecx,%ecx
  709434:	49 8b b6 08 07 00 00 	mov    0x708(%r14),%rsi
  70943b:	48 89 4b 08          	mov    %rcx,0x8(%rbx)
  70943f:	48 89 53 10          	mov    %rdx,0x10(%rbx)
  709443:	0f 11 43 18          	movups %xmm0,0x18(%rbx)
  709447:	48 89 73 28          	mov    %rsi,0x28(%rbx)
  70944b:	88 43 30             	mov    %al,0x30(%rbx)
  70944e:	48 c7 03 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rbx)
  709455:	48 8d 7c 24 68       	lea    0x68(%rsp),%rdi
  70945a:	e8 91 ea fe ff       	call   6f7ef0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70945f:	e9 11 f9 ff ff       	jmp    708d75 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x95>
  709464:	48 8b 8c 24 f0 00 00 	mov    0xf0(%rsp),%rcx
  70946b:	00 
  70946c:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  709473:	00 
  709474:	0f 10 84 24 d0 00 00 	movups 0xd0(%rsp),%xmm0
  70947b:	00 
  70947c:	0f 10 8c 24 e0 00 00 	movups 0xe0(%rsp),%xmm1
  709483:	00 
  709484:	0f 11 8c 24 88 00 00 	movups %xmm1,0x88(%rsp)
  70948b:	00 
  70948c:	0f 11 44 24 78       	movups %xmm0,0x78(%rsp)
  709491:	48 89 44 24 68       	mov    %rax,0x68(%rsp)
  709496:	4c 89 64 24 70       	mov    %r12,0x70(%rsp)
  70949b:	48 83 f8 11          	cmp    $0x11,%rax
  70949f:	0f 84 49 fb ff ff    	je     708fee <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x30e>
  7094a5:	eb 2d                	jmp    7094d4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x7f4>
  7094a7:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  7094ac:	48 89 84 24 98 00 00 	mov    %rax,0x98(%rsp)
  7094b3:	00 
  7094b4:	0f 10 44 24 38       	movups 0x38(%rsp),%xmm0
  7094b9:	0f 10 4c 24 48       	movups 0x48(%rsp),%xmm1
  7094be:	0f 11 8c 24 88 00 00 	movups %xmm1,0x88(%rsp)
  7094c5:	00 
  7094c6:	0f 11 44 24 78       	movups %xmm0,0x78(%rsp)
  7094cb:	48 c7 44 24 68 1a 00 	movq   $0x1a,0x68(%rsp)
  7094d2:	00 00 
  7094d4:	48 8b 84 24 98 00 00 	mov    0x98(%rsp),%rax
  7094db:	00 
  7094dc:	48 89 43 30          	mov    %rax,0x30(%rbx)
  7094e0:	48 8b 44 24 68       	mov    0x68(%rsp),%rax
  7094e5:	48 8b 4c 24 70       	mov    0x70(%rsp),%rcx
  7094ea:	0f 10 44 24 78       	movups 0x78(%rsp),%xmm0
  7094ef:	0f 10 8c 24 88 00 00 	movups 0x88(%rsp),%xmm1
  7094f6:	00 
  7094f7:	0f 11 4b 20          	movups %xmm1,0x20(%rbx)
  7094fb:	0f 11 43 10          	movups %xmm0,0x10(%rbx)
  7094ff:	48 89 03             	mov    %rax,(%rbx)
  709502:	48 89 4b 08          	mov    %rcx,0x8(%rbx)
  709506:	e9 6a f8 ff ff       	jmp    708d75 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x95>
  70950b:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  709512:	49 39 f4             	cmp    %rsi,%r12
  709515:	0f 83 eb 02 00 00    	jae    709806 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0xb26>
  70951b:	49 8b 86 98 02 00 00 	mov    0x298(%r14),%rax
  709522:	4b 8d 0c a4          	lea    (%r12,%r12,4),%rcx
  709526:	44 8b 7c c8 18       	mov    0x18(%rax,%rcx,8),%r15d
  70952b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  709530:	49 39 c7             	cmp    %rax,%r15
  709533:	0f 84 2c f8 ff ff    	je     708d65 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x85>
  709539:	48 c7 44 24 28 11 00 	movq   $0x11,0x28(%rsp)
  709540:	00 00 
  709542:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  709547:	e8 a4 e9 fe ff       	call   6f7ef0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70954c:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  709553:	4c 39 fe             	cmp    %r15,%rsi
  709556:	0f 86 ba 02 00 00    	jbe    709816 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0xb36>
  70955c:	49 8d be b0 05 00 00 	lea    0x5b0(%r14),%rdi
  709563:	49 8b 86 98 02 00 00 	mov    0x298(%r14),%rax
  70956a:	4b 8d 0c bf          	lea    (%r15,%r15,4),%rcx
  70956e:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
  709572:	ff 15 10 00 42 00    	call   *0x420010(%rip)        # b29588 <_DYNAMIC+0x500>
  709578:	49 89 c7             	mov    %rax,%r15
  70957b:	49 89 d4             	mov    %rdx,%r12
  70957e:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  709583:	4c 89 f6             	mov    %r14,%rsi
  709586:	48 89 c2             	mov    %rax,%rdx
  709589:	4c 89 e1             	mov    %r12,%rcx
  70958c:	e8 1f df ff ff       	call   7074b0 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::inspector_app_index>
  709591:	83 7c 24 28 fe       	cmpl   $0xfffffffe,0x28(%rsp)
  709596:	75 5f                	jne    7095f7 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x917>
  709598:	48 89 df             	mov    %rbx,%rdi
  70959b:	4c 89 f6             	mov    %r14,%rsi
  70959e:	4c 89 fa             	mov    %r15,%rdx
  7095a1:	4c 89 e1             	mov    %r12,%rcx
  7095a4:	48 81 c4 28 01 00 00 	add    $0x128,%rsp
  7095ab:	5b                   	pop    %rbx
  7095ac:	41 5c                	pop    %r12
  7095ae:	41 5d                	pop    %r13
  7095b0:	41 5e                	pop    %r14
  7095b2:	41 5f                	pop    %r15
  7095b4:	5d                   	pop    %rbp
  7095b5:	e9 e6 02 00 00       	jmp    7098a0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::inspector_select>
  7095ba:	8b 4c 24 5c          	mov    0x5c(%rsp),%ecx
  7095be:	89 4b 34             	mov    %ecx,0x34(%rbx)
  7095c1:	0f 10 44 24 4c       	movups 0x4c(%rsp),%xmm0
  7095c6:	0f 11 43 24          	movups %xmm0,0x24(%rbx)
  7095ca:	0f 10 84 24 cc 00 00 	movups 0xcc(%rsp),%xmm0
  7095d1:	00 
  7095d2:	0f 11 43 14          	movups %xmm0,0x14(%rbx)
  7095d6:	0f 28 84 24 c0 00 00 	movaps 0xc0(%rsp),%xmm0
  7095dd:	00 
  7095de:	0f 11 43 08          	movups %xmm0,0x8(%rbx)
  7095e2:	48 89 03             	mov    %rax,(%rbx)
  7095e5:	e9 8b f7 ff ff       	jmp    708d75 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x95>
  7095ea:	48 8d 3d 9f 1a 3f 00 	lea    0x3f1a9f(%rip),%rdi        # afb090 <__frame_dummy_init_array_entry+0x828>
  7095f1:	ff 15 99 fd 41 00    	call   *0x41fd99(%rip)        # b29390 <_DYNAMIC+0x308>
  7095f7:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  7095fc:	e8 ef e8 fe ff       	call   6f7ef0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  709601:	41 0f 10 86 60 06 00 	movups 0x660(%r14),%xmm0
  709608:	00 
  709609:	41 0f b6 86 20 08 00 	movzbl 0x820(%r14),%eax
  709610:	00 
  709611:	49 83 be 80 06 00 00 	cmpq   $0x0,0x680(%r14)
  709618:	00 
  709619:	74 1c                	je     709637 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x957>
  70961b:	84 c0                	test   %al,%al
  70961d:	74 0a                	je     709629 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x949>
  70961f:	49 83 be 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%r14)
  709626:	ff 
  709627:	74 0e                	je     709637 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x957>
  709629:	49 8b 96 90 06 00 00 	mov    0x690(%r14),%rdx
  709630:	b9 01 00 00 00       	mov    $0x1,%ecx
  709635:	eb 02                	jmp    709639 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x959>
  709637:	31 c9                	xor    %ecx,%ecx
  709639:	49 8b b6 08 07 00 00 	mov    0x708(%r14),%rsi
  709640:	48 89 4b 08          	mov    %rcx,0x8(%rbx)
  709644:	48 89 53 10          	mov    %rdx,0x10(%rbx)
  709648:	0f 11 43 18          	movups %xmm0,0x18(%rbx)
  70964c:	48 89 73 28          	mov    %rsi,0x28(%rbx)
  709650:	e9 f0 f9 ff ff       	jmp    709045 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x365>
  709655:	83 f8 23             	cmp    $0x23,%eax
  709658:	0f 85 eb 00 00 00    	jne    709749 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0xa69>
  70965e:	8b 44 24 30          	mov    0x30(%rsp),%eax
  709662:	83 f8 0d             	cmp    $0xd,%eax
  709665:	0f 84 12 01 00 00    	je     70977d <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0xa9d>
  70966b:	83 f8 0e             	cmp    $0xe,%eax
  70966e:	0f 85 d5 00 00 00    	jne    709749 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0xa69>
  709674:	ba 07 00 00 00       	mov    $0x7,%edx
  709679:	e9 04 01 00 00       	jmp    709782 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0xaa2>
  70967e:	c6 84 24 a0 00 00 00 	movb   $0x0,0xa0(%rsp)
  709685:	00 
  709686:	c7 84 24 a4 00 00 00 	movl   $0x0,0xa4(%rsp)
  70968d:	00 00 00 00 
  709691:	48 8d b4 24 a0 00 00 	lea    0xa0(%rsp),%rsi
  709698:	00 
  709699:	8b 7c 24 08          	mov    0x8(%rsp),%edi
  70969d:	ff 15 ed fe 41 00    	call   *0x41feed(%rip)        # b29590 <_DYNAMIC+0x508>
  7096a3:	66 85 c0             	test   %ax,%ax
  7096a6:	74 2a                	je     7096d2 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x9f2>
  7096a8:	48 c1 e8 10          	shr    $0x10,%rax
  7096ac:	48 89 df             	mov    %rbx,%rdi
  7096af:	4c 89 f6             	mov    %r14,%rsi
  7096b2:	89 c2                	mov    %eax,%edx
  7096b4:	48 81 c4 28 01 00 00 	add    $0x128,%rsp
  7096bb:	5b                   	pop    %rbx
  7096bc:	41 5c                	pop    %r12
  7096be:	41 5d                	pop    %r13
  7096c0:	41 5e                	pop    %r14
  7096c2:	41 5f                	pop    %r15
  7096c4:	5d                   	pop    %rbp
  7096c5:	e9 f6 f4 ff ff       	jmp    708bc0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::reject_editor>
  7096ca:	c6 84 24 a0 00 00 00 	movb   $0xff,0xa0(%rsp)
  7096d1:	ff 
  7096d2:	4d 8b be 60 06 00 00 	mov    0x660(%r14),%r15
  7096d9:	49 83 ff ff          	cmp    $0xffffffffffffffff,%r15
  7096dd:	0f 84 8e 00 00 00    	je     709771 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0xa91>
  7096e3:	48 c7 44 24 28 1f 00 	movq   $0x1f,0x28(%rsp)
  7096ea:	00 00 
  7096ec:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  7096f1:	e8 fa e7 fe ff       	call   6f7ef0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  7096f6:	49 8b 86 10 06 00 00 	mov    0x610(%r14),%rax
  7096fd:	48 85 c0             	test   %rax,%rax
  709700:	0f 84 af 00 00 00    	je     7097b5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0xad5>
  709706:	48 8b 80 d8 00 00 00 	mov    0xd8(%rax),%rax
  70970d:	48 85 c0             	test   %rax,%rax
  709710:	0f 84 9f 00 00 00    	je     7097b5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0xad5>
  709716:	49 ff c7             	inc    %r15
  709719:	c6 40 13 ff          	movb   $0xff,0x13(%rax)
  70971d:	48 8d 84 24 a0 00 00 	lea    0xa0(%rsp),%rax
  709724:	00 
  709725:	48 89 04 24          	mov    %rax,(%rsp)
  709729:	48 89 df             	mov    %rbx,%rdi
  70972c:	4c 89 f6             	mov    %r14,%rsi
  70972f:	48 8b 54 24 60       	mov    0x60(%rsp),%rdx
  709734:	4c 89 e1             	mov    %r12,%rcx
  709737:	4d 89 f8             	mov    %r15,%r8
  70973a:	44 8b 4c 24 08       	mov    0x8(%rsp),%r9d
  70973f:	e8 2c 06 02 00       	call   729d70 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at>
  709744:	e9 2c f6 ff ff       	jmp    708d75 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x95>
  709749:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  70974e:	48 89 43 30          	mov    %rax,0x30(%rbx)
  709752:	0f 10 44 24 28       	movups 0x28(%rsp),%xmm0
  709757:	0f 10 4c 24 38       	movups 0x38(%rsp),%xmm1
  70975c:	0f 10 54 24 48       	movups 0x48(%rsp),%xmm2
  709761:	0f 11 53 20          	movups %xmm2,0x20(%rbx)
  709765:	0f 11 4b 10          	movups %xmm1,0x10(%rbx)
  709769:	0f 11 03             	movups %xmm0,(%rbx)
  70976c:	e9 04 f6 ff ff       	jmp    708d75 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x95>
  709771:	48 c7 03 1f 00 00 00 	movq   $0x1f,(%rbx)
  709778:	e9 f8 f5 ff ff       	jmp    708d75 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x95>
  70977d:	ba 06 00 00 00       	mov    $0x6,%edx
  709782:	48 89 df             	mov    %rbx,%rdi
  709785:	4c 89 f6             	mov    %r14,%rsi
  709788:	e8 33 f4 ff ff       	call   708bc0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::reject_editor>
  70978d:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  709792:	e8 59 e7 fe ff       	call   6f7ef0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  709797:	e9 d9 f5 ff ff       	jmp    708d75 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x95>
  70979c:	48 8d 3d 81 0d 96 ff 	lea    -0x69f27f(%rip),%rdi        # 6a524 <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x32a7>
  7097a3:	48 8d 15 5e 19 3f 00 	lea    0x3f195e(%rip),%rdx        # afb108 <__frame_dummy_init_array_entry+0x8a0>
  7097aa:	be 28 00 00 00       	mov    $0x28,%esi
  7097af:	ff 15 e3 fd 41 00    	call   *0x41fde3(%rip)        # b29598 <_DYNAMIC+0x510>
  7097b5:	48 8d 3d a9 0d 96 ff 	lea    -0x69f257(%rip),%rdi        # 6a565 <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x32e8>
  7097bc:	48 8d 15 55 18 3f 00 	lea    0x3f1855(%rip),%rdx        # afb018 <__frame_dummy_init_array_entry+0x7b0>
  7097c3:	be 11 00 00 00       	mov    $0x11,%esi
  7097c8:	ff 15 02 fc 41 00    	call   *0x41fc02(%rip)        # b293d0 <_DYNAMIC+0x348>
  7097ce:	48 8d 3d d3 18 3f 00 	lea    0x3f18d3(%rip),%rdi        # afb0a8 <__frame_dummy_init_array_entry+0x840>
  7097d5:	ff 15 b5 fb 41 00    	call   *0x41fbb5(%rip)        # b29390 <_DYNAMIC+0x308>
  7097db:	4c 89 ff             	mov    %r15,%rdi
  7097de:	48 8d 15 db 18 3f 00 	lea    0x3f18db(%rip),%rdx        # afb0c0 <__frame_dummy_init_array_entry+0x858>
  7097e5:	ff 15 f5 fb 41 00    	call   *0x41fbf5(%rip)        # b293e0 <_DYNAMIC+0x358>
  7097eb:	0f 0b                	ud2
  7097ed:	48 8d 3d 30 0d 96 ff 	lea    -0x69f2d0(%rip),%rdi        # 6a524 <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x32a7>
  7097f4:	48 8d 15 25 19 3f 00 	lea    0x3f1925(%rip),%rdx        # afb120 <__frame_dummy_init_array_entry+0x8b8>
  7097fb:	be 28 00 00 00       	mov    $0x28,%esi
  709800:	ff 15 92 fd 41 00    	call   *0x41fd92(%rip)        # b29598 <_DYNAMIC+0x510>
  709806:	48 8d 15 cb 18 3f 00 	lea    0x3f18cb(%rip),%rdx        # afb0d8 <__frame_dummy_init_array_entry+0x870>
  70980d:	4c 89 e7             	mov    %r12,%rdi
  709810:	ff 15 ca fb 41 00    	call   *0x41fbca(%rip)        # b293e0 <_DYNAMIC+0x358>
  709816:	48 8d 15 d3 18 3f 00 	lea    0x3f18d3(%rip),%rdx        # afb0f0 <__frame_dummy_init_array_entry+0x888>
  70981d:	4c 89 ff             	mov    %r15,%rdi
  709820:	ff 15 ba fb 41 00    	call   *0x41fbba(%rip)        # b293e0 <_DYNAMIC+0x358>
  709826:	48 89 c3             	mov    %rax,%rbx
  709829:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  70982e:	e8 bd e6 fe ff       	call   6f7ef0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  709833:	48 89 df             	mov    %rbx,%rdi
  709836:	e8 75 fc 3e 00       	call   af94b0 <_Unwind_Resume@plt>
  70983b:	4c 8b 74 24 20       	mov    0x20(%rsp),%r14
  709840:	48 89 c3             	mov    %rax,%rbx
  709843:	49 8b 75 08          	mov    0x8(%r13),%rsi
  709847:	48 85 f6             	test   %rsi,%rsi
  70984a:	74 0d                	je     709859 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0xb79>
  70984c:	49 8b 55 10          	mov    0x10(%r13),%rdx
  709850:	48 89 ef             	mov    %rbp,%rdi
  709853:	ff 15 77 fa 41 00    	call   *0x41fa77(%rip)        # b292d0 <_DYNAMIC+0x248>
  709859:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  70985e:	49 89 06             	mov    %rax,(%r14)
  709861:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  709866:	49 89 44 24 10       	mov    %rax,0x10(%r12)
  70986b:	48 89 df             	mov    %rbx,%rdi
  70986e:	e8 3d fc 3e 00       	call   af94b0 <_Unwind_Resume@plt>
  709873:	48 89 c3             	mov    %rax,%rbx
  709876:	48 8b 7c 24 10       	mov    0x10(%rsp),%rdi
  70987b:	48 8b 74 24 08       	mov    0x8(%rsp),%rsi
  709880:	e8 eb af fe ff       	call   6f4870 <core::ptr::drop_glue::<core::option::Option<gpui::element::Handler>>>
  709885:	48 89 df             	mov    %rbx,%rdi
  709888:	e8 23 fc 3e 00       	call   af94b0 <_Unwind_Resume@plt>
  70988d:	ff 15 6d fa 41 00    	call   *0x41fa6d(%rip)        # b29300 <_DYNAMIC+0x278>
