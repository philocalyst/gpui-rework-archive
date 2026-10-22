
/tmp/gpui-contained-owner-spike-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

0000000000708d70 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action>:
  708d70:	55                   	push   %rbp
  708d71:	41 57                	push   %r15
  708d73:	41 56                	push   %r14
  708d75:	41 55                	push   %r13
  708d77:	41 54                	push   %r12
  708d79:	53                   	push   %rbx
  708d7a:	48 81 ec 28 01 00 00 	sub    $0x128,%rsp
  708d81:	48 89 fb             	mov    %rdi,%rbx
  708d84:	80 be 22 08 00 00 00 	cmpb   $0x0,0x822(%rsi)
  708d8b:	74 09                	je     708d96 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x26>
  708d8d:	48 c7 03 0e 00 00 00 	movq   $0xe,(%rbx)
  708d94:	eb 6f                	jmp    708e05 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x95>
  708d96:	49 89 f6             	mov    %rsi,%r14
  708d99:	48 8b 86 10 06 00 00 	mov    0x610(%rsi),%rax
  708da0:	48 85 c0             	test   %rax,%rax
  708da3:	74 59                	je     708dfe <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x8e>
  708da5:	48 83 b8 d8 00 00 00 	cmpq   $0x0,0xd8(%rax)
  708dac:	00 
  708dad:	74 4f                	je     708dfe <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x8e>
  708daf:	49 c7 86 08 07 00 00 	movq   $0x0,0x708(%r14)
  708db6:	00 00 00 00 
  708dba:	48 8b a8 d8 00 00 00 	mov    0xd8(%rax),%rbp
  708dc1:	48 85 ed             	test   %rbp,%rbp
  708dc4:	0f 84 b0 08 00 00    	je     70967a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x90a>
  708dca:	44 0f b7 65 10       	movzwl 0x10(%rbp),%r12d
  708dcf:	0f b6 7d 16          	movzbl 0x16(%rbp),%edi
  708dd3:	44 0f b6 45 12       	movzbl 0x12(%rbp),%r8d
  708dd8:	89 c8                	mov    %ecx,%eax
  708dda:	66 83 e8 0e          	sub    $0xe,%ax
  708dde:	41 bf 03 00 00 00    	mov    $0x3,%r15d
  708de4:	44 0f 43 f8          	cmovae %eax,%r15d
  708de8:	66 41 83 ff 03       	cmp    $0x3,%r15w
  708ded:	75 28                	jne    708e17 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0xa7>
  708def:	66 41 39 cc          	cmp    %cx,%r12w
  708df3:	74 22                	je     708e17 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0xa7>
  708df5:	48 c7 03 11 00 00 00 	movq   $0x11,(%rbx)
  708dfc:	eb 07                	jmp    708e05 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x95>
  708dfe:	48 c7 03 1a 00 00 00 	movq   $0x1a,(%rbx)
  708e05:	48 81 c4 28 01 00 00 	add    $0x128,%rsp
  708e0c:	5b                   	pop    %rbx
  708e0d:	41 5c                	pop    %r12
  708e0f:	41 5d                	pop    %r13
  708e11:	41 5e                	pop    %r14
  708e13:	41 5f                	pop    %r15
  708e15:	5d                   	pop    %rbp
  708e16:	c3                   	ret
  708e17:	41 89 cd             	mov    %ecx,%r13d
  708e1a:	41 c1 ed 10          	shr    $0x10,%r13d
  708e1e:	45 0f b7 cf          	movzwl %r15w,%r9d
  708e22:	48 8d 05 47 2a 95 ff 	lea    -0x6ad5b9(%rip),%rax        # 5b870 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x10>
  708e29:	4a 63 34 88          	movslq (%rax,%r9,4),%rsi
  708e2d:	48 01 c6             	add    %rax,%rsi
  708e30:	ff e6                	jmp    *%rsi
  708e32:	44 0f b7 ff          	movzwl %di,%r15d
  708e36:	41 81 cf 00 01 00 00 	or     $0x100,%r15d
  708e3d:	eb 12                	jmp    708e51 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0xe1>
  708e3f:	45 0f b7 f8          	movzwl %r8w,%r15d
  708e43:	41 c1 e7 08          	shl    $0x8,%r15d
  708e47:	66 45 39 e5          	cmp    %r12w,%r13w
  708e4b:	0f 85 f3 02 00 00    	jne    709144 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x3d4>
  708e51:	b0 01                	mov    $0x1,%al
  708e53:	44 38 ff             	cmp    %r15b,%dil
  708e56:	0f 85 ed 02 00 00    	jne    709149 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x3d9>
  708e5c:	41 0f b7 cf          	movzwl %r15w,%ecx
  708e60:	c1 e9 08             	shr    $0x8,%ecx
  708e63:	41 38 c8             	cmp    %cl,%r8b
  708e66:	0f 85 dd 02 00 00    	jne    709149 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x3d9>
  708e6c:	80 7d 13 ff          	cmpb   $0xff,0x13(%rbp)
  708e70:	0f 85 d3 02 00 00    	jne    709149 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x3d9>
  708e76:	e9 c4 01 00 00       	jmp    70903f <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x2cf>
  708e7b:	f7 c1 00 00 ff 00    	test   $0xff0000,%ecx
  708e81:	0f 84 5d 02 00 00    	je     7090e4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x374>
  708e87:	48 8b 45 00          	mov    0x0(%rbp),%rax
  708e8b:	48 85 c0             	test   %rax,%rax
  708e8e:	0f 84 ab 01 00 00    	je     70903f <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x2cf>
  708e94:	49 3b 86 b0 05 00 00 	cmp    0x5b0(%r14),%rax
  708e9b:	0f 85 d4 01 00 00    	jne    709075 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x305>
  708ea1:	4c 89 4c 24 18       	mov    %r9,0x18(%rsp)
  708ea6:	48 89 7c 24 10       	mov    %rdi,0x10(%rsp)
  708eab:	48 89 54 24 60       	mov    %rdx,0x60(%rsp)
  708eb0:	89 4c 24 08          	mov    %ecx,0x8(%rsp)
  708eb4:	4c 8b 65 08          	mov    0x8(%rbp),%r12
  708eb8:	48 c7 44 24 28 11 00 	movq   $0x11,0x28(%rsp)
  708ebf:	00 00 
  708ec1:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  708ec6:	e8 15 f1 fe ff       	call   6f7fe0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  708ecb:	48 8d bc 24 c0 00 00 	lea    0xc0(%rsp),%rdi
  708ed2:	00 
  708ed3:	4c 89 f6             	mov    %r14,%rsi
  708ed6:	4c 89 e2             	mov    %r12,%rdx
  708ed9:	e8 32 15 01 00       	call   71a410 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::resolve_identity>
  708ede:	48 8b 84 24 c0 00 00 	mov    0xc0(%rsp),%rax
  708ee5:	00 
  708ee6:	4c 8b a4 24 c8 00 00 	mov    0xc8(%rsp),%r12
  708eed:	00 
  708eee:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  708ef2:	0f 85 fc 05 00 00    	jne    7094f4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x784>
  708ef8:	49 8b 86 10 06 00 00 	mov    0x610(%r14),%rax
  708eff:	48 85 c0             	test   %rax,%rax
  708f02:	0f 84 2f 06 00 00    	je     709537 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x7c7>
  708f08:	48 83 b8 d8 00 00 00 	cmpq   $0x0,0xd8(%rax)
  708f0f:	00 
  708f10:	0f 84 21 06 00 00    	je     709537 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x7c7>
  708f16:	49 8b ae a0 02 00 00 	mov    0x2a0(%r14),%rbp
  708f1d:	48 c7 44 24 28 1a 00 	movq   $0x1a,0x28(%rsp)
  708f24:	00 00 
  708f26:	48 83 fd 1c          	cmp    $0x1c,%rbp
  708f2a:	0f 82 07 06 00 00    	jb     709537 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x7c7>
  708f30:	48 83 c5 e4          	add    $0xffffffffffffffe4,%rbp
  708f34:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  708f39:	e8 a2 f0 fe ff       	call   6f7fe0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  708f3e:	49 83 fc 02          	cmp    $0x2,%r12
  708f42:	0f 93 c0             	setae  %al
  708f45:	49 39 ec             	cmp    %rbp,%r12
  708f48:	0f 92 c1             	setb   %cl
  708f4b:	84 c8                	test   %cl,%al
  708f4d:	0f 84 22 01 00 00    	je     709075 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x305>
  708f53:	66 41 83 ff 01       	cmp    $0x1,%r15w
  708f58:	0f 84 3d 06 00 00    	je     70959b <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x82b>
  708f5e:	83 7c 24 18 03       	cmpl   $0x3,0x18(%rsp)
  708f63:	0f 85 c3 08 00 00    	jne    70982c <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0xabc>
  708f69:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  708f6e:	4c 89 f6             	mov    %r14,%rsi
  708f71:	4c 89 e2             	mov    %r12,%rdx
  708f74:	8b 4c 24 08          	mov    0x8(%rsp),%ecx
  708f78:	e8 a3 09 02 00       	call   729920 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::property_value_at>
  708f7d:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  708f82:	0f 10 44 24 30       	movups 0x30(%rsp),%xmm0
  708f87:	0f 29 84 24 c0 00 00 	movaps %xmm0,0xc0(%rsp)
  708f8e:	00 
  708f8f:	0f 10 44 24 3c       	movups 0x3c(%rsp),%xmm0
  708f94:	0f 11 84 24 cc 00 00 	movups %xmm0,0xcc(%rsp)
  708f9b:	00 
  708f9c:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  708fa0:	0f 85 a4 06 00 00    	jne    70964a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x8da>
  708fa6:	0f 28 84 24 c0 00 00 	movaps 0xc0(%rsp),%xmm0
  708fad:	00 
  708fae:	0f 29 84 24 00 01 00 	movaps %xmm0,0x100(%rsp)
  708fb5:	00 
  708fb6:	0f 10 84 24 cc 00 00 	movups 0xcc(%rsp),%xmm0
  708fbd:	00 
  708fbe:	0f 11 84 24 0c 01 00 	movups %xmm0,0x10c(%rsp)
  708fc5:	00 
  708fc6:	41 0f b6 c5          	movzbl %r13b,%eax
  708fca:	48 8d 0d af 28 95 ff 	lea    -0x6ad751(%rip),%rcx        # 5b880 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x20>
  708fd1:	48 63 04 81          	movslq (%rcx,%rax,4),%rax
  708fd5:	48 01 c8             	add    %rcx,%rax
  708fd8:	ff e0                	jmp    *%rax
  708fda:	8b 44 24 08          	mov    0x8(%rsp),%eax
  708fde:	25 00 00 ff 00       	and    $0xff0000,%eax
  708fe3:	31 c9                	xor    %ecx,%ecx
  708fe5:	3d 00 00 02 00       	cmp    $0x20000,%eax
  708fea:	0f 94 c1             	sete   %cl
  708fed:	48 8d 05 24 26 95 ff 	lea    -0x6ad9dc(%rip),%rax        # 5b618 <anon.079f5e587c394fcac2765eb4d0cf0bc2.21.llvm.6319143315422321905+0x48>
  708ff4:	f3 0f 10 04 88       	movss  (%rax,%rcx,4),%xmm0
  708ff9:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  708ffe:	48 8d b4 24 00 01 00 	lea    0x100(%rsp),%rsi
  709005:	00 
  709006:	48 8b 54 24 10       	mov    0x10(%rsp),%rdx
  70900b:	ff 15 df 05 42 00    	call   *0x4205df(%rip)        # b295f0 <_DYNAMIC+0x4f0>
  709011:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  709016:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  70901a:	0f 85 c5 06 00 00    	jne    7096e5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x975>
  709020:	0f 10 44 24 30       	movups 0x30(%rsp),%xmm0
  709025:	0f 10 4c 24 3c       	movups 0x3c(%rsp),%xmm1
  70902a:	0f 11 8c 24 ac 00 00 	movups %xmm1,0xac(%rsp)
  709031:	00 
  709032:	0f 29 84 24 a0 00 00 	movaps %xmm0,0xa0(%rsp)
  709039:	00 
  70903a:	e9 e2 06 00 00       	jmp    709721 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x9b1>
  70903f:	41 0f 10 86 60 06 00 	movups 0x660(%r14),%xmm0
  709046:	00 
  709047:	41 0f b6 86 20 08 00 	movzbl 0x820(%r14),%eax
  70904e:	00 
  70904f:	49 83 be 80 06 00 00 	cmpq   $0x0,0x680(%r14)
  709056:	00 
  709057:	74 66                	je     7090bf <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x34f>
  709059:	84 c0                	test   %al,%al
  70905b:	74 0a                	je     709067 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x2f7>
  70905d:	49 83 be 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%r14)
  709064:	ff 
  709065:	74 58                	je     7090bf <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x34f>
  709067:	49 8b 96 90 06 00 00 	mov    0x690(%r14),%rdx
  70906e:	b9 01 00 00 00       	mov    $0x1,%ecx
  709073:	eb 4c                	jmp    7090c1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x351>
  709075:	48 c7 44 24 68 11 00 	movq   $0x11,0x68(%rsp)
  70907c:	00 00 
  70907e:	41 0f 10 86 60 06 00 	movups 0x660(%r14),%xmm0
  709085:	00 
  709086:	41 0f b6 86 20 08 00 	movzbl 0x820(%r14),%eax
  70908d:	00 
  70908e:	49 83 be 80 06 00 00 	cmpq   $0x0,0x680(%r14)
  709095:	00 
  709096:	0f 84 26 04 00 00    	je     7094c2 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x752>
  70909c:	84 c0                	test   %al,%al
  70909e:	74 0e                	je     7090ae <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x33e>
  7090a0:	49 83 be 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%r14)
  7090a7:	ff 
  7090a8:	0f 84 14 04 00 00    	je     7094c2 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x752>
  7090ae:	49 8b 96 90 06 00 00 	mov    0x690(%r14),%rdx
  7090b5:	b9 01 00 00 00       	mov    $0x1,%ecx
  7090ba:	e9 05 04 00 00       	jmp    7094c4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x754>
  7090bf:	31 c9                	xor    %ecx,%ecx
  7090c1:	48 89 4b 08          	mov    %rcx,0x8(%rbx)
  7090c5:	48 89 53 10          	mov    %rdx,0x10(%rbx)
  7090c9:	0f 11 43 18          	movups %xmm0,0x18(%rbx)
  7090cd:	48 c7 43 28 00 00 00 	movq   $0x0,0x28(%rbx)
  7090d4:	00 
  7090d5:	88 43 30             	mov    %al,0x30(%rbx)
  7090d8:	48 c7 03 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rbx)
  7090df:	e9 21 fd ff ff       	jmp    708e05 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x95>
  7090e4:	45 0f b7 f8          	movzwl %r8w,%r15d
  7090e8:	8d 47 01             	lea    0x1(%rdi),%eax
  7090eb:	89 44 24 18          	mov    %eax,0x18(%rsp)
  7090ef:	48 89 7c 24 10       	mov    %rdi,0x10(%rsp)
  7090f4:	89 cf                	mov    %ecx,%edi
  7090f6:	89 4c 24 08          	mov    %ecx,0x8(%rsp)
  7090fa:	45 89 c5             	mov    %r8d,%r13d
  7090fd:	e8 5e ba ff ff       	call   704b60 <<gpui::property::PropertyId>::info>
  709102:	45 89 e8             	mov    %r13d,%r8d
  709105:	48 8b 7c 24 10       	mov    0x10(%rsp),%rdi
  70910a:	44 8b 6c 24 08       	mov    0x8(%rsp),%r13d
  70910f:	0f b6 40 14          	movzbl 0x14(%rax),%eax
  709113:	31 c9                	xor    %ecx,%ecx
  709115:	3c 04                	cmp    $0x4,%al
  709117:	0f 94 c1             	sete   %cl
  70911a:	8d 0c 89             	lea    (%rcx,%rcx,4),%ecx
  70911d:	ff c1                	inc    %ecx
  70911f:	3c 02                	cmp    $0x2,%al
  709121:	ba 04 00 00 00       	mov    $0x4,%edx
  709126:	0f 45 d1             	cmovne %ecx,%edx
  709129:	0f b6 44 24 18       	movzbl 0x18(%rsp),%eax
  70912e:	f6 f2                	div    %dl
  709130:	0f b6 c4             	movzbl %ah,%eax
  709133:	41 c1 e7 08          	shl    $0x8,%r15d
  709137:	41 09 c7             	or     %eax,%r15d
  70913a:	66 45 39 e5          	cmp    %r12w,%r13w
  70913e:	0f 84 0d fd ff ff    	je     708e51 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0xe1>
  709144:	31 c0                	xor    %eax,%eax
  709146:	45 89 ec             	mov    %r13d,%r12d
  709149:	49 8b 96 60 06 00 00 	mov    0x660(%r14),%rdx
  709150:	48 ff c2             	inc    %rdx
  709153:	0f 84 a8 06 00 00    	je     709801 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0xa91>
  709159:	41 0f b7 cf          	movzwl %r15w,%ecx
  70915d:	66 44 89 65 10       	mov    %r12w,0x10(%rbp)
  709162:	88 4d 16             	mov    %cl,0x16(%rbp)
  709165:	88 6d 12             	mov    %ch,0x12(%rbp)
  709168:	c6 45 13 ff          	movb   $0xff,0x13(%rbp)
  70916c:	84 c0                	test   %al,%al
  70916e:	0f 85 11 03 00 00    	jne    709485 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x715>
  709174:	49 8b 86 10 06 00 00 	mov    0x610(%r14),%rax
  70917b:	48 85 c0             	test   %rax,%rax
  70917e:	0f 84 da 06 00 00    	je     70985e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0xaee>
  709184:	48 83 b8 d8 00 00 00 	cmpq   $0x0,0xd8(%rax)
  70918b:	00 
  70918c:	0f 84 cc 06 00 00    	je     70985e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0xaee>
  709192:	4d 8b be a0 02 00 00 	mov    0x2a0(%r14),%r15
  709199:	49 83 ff 1c          	cmp    $0x1c,%r15
  70919d:	0f 82 bb 06 00 00    	jb     70985e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0xaee>
  7091a3:	48 89 54 24 60       	mov    %rdx,0x60(%rsp)
  7091a8:	41 0f b7 fc          	movzwl %r12w,%edi
  7091ac:	48 89 7c 24 18       	mov    %rdi,0x18(%rsp)
  7091b1:	ff 15 41 04 42 00    	call   *0x420441(%rip)        # b295f8 <_DYNAMIC+0x4f8>
  7091b7:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  7091bc:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
  7091c1:	49 8d 7f f7          	lea    -0x9(%r15),%rdi
  7091c5:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  7091cc:	48 39 f7             	cmp    %rsi,%rdi
  7091cf:	0f 83 99 06 00 00    	jae    70986e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0xafe>
  7091d5:	49 8b 8e 98 02 00 00 	mov    0x298(%r14),%rcx
  7091dc:	48 8d 14 bf          	lea    (%rdi,%rdi,4),%rdx
  7091e0:	4c 8d 24 d1          	lea    (%rcx,%rdx,8),%r12
  7091e4:	48 8b 6c d1 08       	mov    0x8(%rcx,%rdx,8),%rbp
  7091e9:	48 85 ed             	test   %rbp,%rbp
  7091ec:	74 36                	je     709224 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x4b4>
  7091ee:	4c 8b 6c d1 10       	mov    0x10(%rcx,%rdx,8),%r13
  7091f3:	49 8b 45 00          	mov    0x0(%r13),%rax
  7091f7:	48 85 c0             	test   %rax,%rax
  7091fa:	74 12                	je     70920e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x49e>
  7091fc:	48 8d 0c d1          	lea    (%rcx,%rdx,8),%rcx
  709200:	48 83 c1 08          	add    $0x8,%rcx
  709204:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  709209:	48 89 ef             	mov    %rbp,%rdi
  70920c:	ff d0                	call   *%rax
  70920e:	49 8b 75 08          	mov    0x8(%r13),%rsi
  709212:	48 85 f6             	test   %rsi,%rsi
  709215:	74 0d                	je     709224 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x4b4>
  709217:	49 8b 55 10          	mov    0x10(%r13),%rdx
  70921b:	48 89 ef             	mov    %rbp,%rdi
  70921e:	ff 15 24 01 42 00    	call   *0x420124(%rip)        # b29348 <_DYNAMIC+0x248>
  709224:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  709229:	49 89 44 24 08       	mov    %rax,0x8(%r12)
  70922e:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  709233:	49 89 44 24 10       	mov    %rax,0x10(%r12)
  709238:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  70923d:	8d b8 00 00 01 00    	lea    0x10000(%rax),%edi
  709243:	ff 15 af 03 42 00    	call   *0x4203af(%rip)        # b295f8 <_DYNAMIC+0x4f8>
  709249:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  70924e:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
  709253:	49 8d 7f f9          	lea    -0x7(%r15),%rdi
  709257:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  70925e:	48 39 f7             	cmp    %rsi,%rdi
  709261:	0f 83 07 06 00 00    	jae    70986e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0xafe>
  709267:	49 8b 8e 98 02 00 00 	mov    0x298(%r14),%rcx
  70926e:	48 8d 14 bf          	lea    (%rdi,%rdi,4),%rdx
  709272:	4c 8d 24 d1          	lea    (%rcx,%rdx,8),%r12
  709276:	48 8b 6c d1 08       	mov    0x8(%rcx,%rdx,8),%rbp
  70927b:	48 85 ed             	test   %rbp,%rbp
  70927e:	74 36                	je     7092b6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x546>
  709280:	4c 8b 6c d1 10       	mov    0x10(%rcx,%rdx,8),%r13
  709285:	49 8b 45 00          	mov    0x0(%r13),%rax
  709289:	48 85 c0             	test   %rax,%rax
  70928c:	74 12                	je     7092a0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x530>
  70928e:	48 8d 0c d1          	lea    (%rcx,%rdx,8),%rcx
  709292:	48 83 c1 08          	add    $0x8,%rcx
  709296:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  70929b:	48 89 ef             	mov    %rbp,%rdi
  70929e:	ff d0                	call   *%rax
  7092a0:	49 8b 75 08          	mov    0x8(%r13),%rsi
  7092a4:	48 85 f6             	test   %rsi,%rsi
  7092a7:	74 0d                	je     7092b6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x546>
  7092a9:	49 8b 55 10          	mov    0x10(%r13),%rdx
  7092ad:	48 89 ef             	mov    %rbp,%rdi
  7092b0:	ff 15 92 00 42 00    	call   *0x420092(%rip)        # b29348 <_DYNAMIC+0x248>
  7092b6:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  7092bb:	49 89 44 24 08       	mov    %rax,0x8(%r12)
  7092c0:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  7092c5:	49 89 44 24 10       	mov    %rax,0x10(%r12)
  7092ca:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  7092cf:	8d b8 00 00 02 00    	lea    0x20000(%rax),%edi
  7092d5:	ff 15 1d 03 42 00    	call   *0x42031d(%rip)        # b295f8 <_DYNAMIC+0x4f8>
  7092db:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  7092e0:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
  7092e5:	49 8d 7f fa          	lea    -0x6(%r15),%rdi
  7092e9:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  7092f0:	48 39 f7             	cmp    %rsi,%rdi
  7092f3:	0f 83 75 05 00 00    	jae    70986e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0xafe>
  7092f9:	49 8b 8e 98 02 00 00 	mov    0x298(%r14),%rcx
  709300:	48 8d 14 bf          	lea    (%rdi,%rdi,4),%rdx
  709304:	4c 8d 24 d1          	lea    (%rcx,%rdx,8),%r12
  709308:	48 8b 6c d1 08       	mov    0x8(%rcx,%rdx,8),%rbp
  70930d:	48 85 ed             	test   %rbp,%rbp
  709310:	74 36                	je     709348 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x5d8>
  709312:	4c 8b 6c d1 10       	mov    0x10(%rcx,%rdx,8),%r13
  709317:	49 8b 45 00          	mov    0x0(%r13),%rax
  70931b:	48 85 c0             	test   %rax,%rax
  70931e:	74 12                	je     709332 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x5c2>
  709320:	48 8d 0c d1          	lea    (%rcx,%rdx,8),%rcx
  709324:	48 83 c1 08          	add    $0x8,%rcx
  709328:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  70932d:	48 89 ef             	mov    %rbp,%rdi
  709330:	ff d0                	call   *%rax
  709332:	49 8b 75 08          	mov    0x8(%r13),%rsi
  709336:	48 85 f6             	test   %rsi,%rsi
  709339:	74 0d                	je     709348 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x5d8>
  70933b:	49 8b 55 10          	mov    0x10(%r13),%rdx
  70933f:	48 89 ef             	mov    %rbp,%rdi
  709342:	ff 15 00 00 42 00    	call   *0x420000(%rip)        # b29348 <_DYNAMIC+0x248>
  709348:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  70934d:	49 89 44 24 08       	mov    %rax,0x8(%r12)
  709352:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  709357:	49 89 44 24 10       	mov    %rax,0x10(%r12)
  70935c:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  709361:	8d b8 00 00 03 00    	lea    0x30000(%rax),%edi
  709367:	ff 15 8b 02 42 00    	call   *0x42028b(%rip)        # b295f8 <_DYNAMIC+0x4f8>
  70936d:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  709372:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
  709377:	49 8d 7f fb          	lea    -0x5(%r15),%rdi
  70937b:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  709382:	48 39 f7             	cmp    %rsi,%rdi
  709385:	0f 83 e3 04 00 00    	jae    70986e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0xafe>
  70938b:	49 8b 8e 98 02 00 00 	mov    0x298(%r14),%rcx
  709392:	48 8d 14 bf          	lea    (%rdi,%rdi,4),%rdx
  709396:	4c 8d 24 d1          	lea    (%rcx,%rdx,8),%r12
  70939a:	48 8b 6c d1 08       	mov    0x8(%rcx,%rdx,8),%rbp
  70939f:	48 85 ed             	test   %rbp,%rbp
  7093a2:	74 36                	je     7093da <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x66a>
  7093a4:	4c 8b 6c d1 10       	mov    0x10(%rcx,%rdx,8),%r13
  7093a9:	49 8b 45 00          	mov    0x0(%r13),%rax
  7093ad:	48 85 c0             	test   %rax,%rax
  7093b0:	74 12                	je     7093c4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x654>
  7093b2:	48 8d 0c d1          	lea    (%rcx,%rdx,8),%rcx
  7093b6:	48 83 c1 08          	add    $0x8,%rcx
  7093ba:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  7093bf:	48 89 ef             	mov    %rbp,%rdi
  7093c2:	ff d0                	call   *%rax
  7093c4:	49 8b 75 08          	mov    0x8(%r13),%rsi
  7093c8:	48 85 f6             	test   %rsi,%rsi
  7093cb:	74 0d                	je     7093da <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x66a>
  7093cd:	49 8b 55 10          	mov    0x10(%r13),%rdx
  7093d1:	48 89 ef             	mov    %rbp,%rdi
  7093d4:	ff 15 6e ff 41 00    	call   *0x41ff6e(%rip)        # b29348 <_DYNAMIC+0x248>
  7093da:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  7093df:	49 89 44 24 08       	mov    %rax,0x8(%r12)
  7093e4:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  7093e9:	49 89 44 24 10       	mov    %rax,0x10(%r12)
  7093ee:	48 8b 7c 24 18       	mov    0x18(%rsp),%rdi
  7093f3:	81 cf 00 00 04 00    	or     $0x40000,%edi
  7093f9:	ff 15 f9 01 42 00    	call   *0x4201f9(%rip)        # b295f8 <_DYNAMIC+0x4f8>
  7093ff:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  709404:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
  709409:	49 83 c7 fc          	add    $0xfffffffffffffffc,%r15
  70940d:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  709414:	49 39 f7             	cmp    %rsi,%r15
  709417:	0f 83 4e 04 00 00    	jae    70986b <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0xafb>
  70941d:	49 8b 8e 98 02 00 00 	mov    0x298(%r14),%rcx
  709424:	4b 8d 14 bf          	lea    (%r15,%r15,4),%rdx
  709428:	4c 8d 24 d1          	lea    (%rcx,%rdx,8),%r12
  70942c:	48 8b 6c d1 08       	mov    0x8(%rcx,%rdx,8),%rbp
  709431:	48 85 ed             	test   %rbp,%rbp
  709434:	74 36                	je     70946c <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x6fc>
  709436:	4c 8b 6c d1 10       	mov    0x10(%rcx,%rdx,8),%r13
  70943b:	49 8b 45 00          	mov    0x0(%r13),%rax
  70943f:	48 85 c0             	test   %rax,%rax
  709442:	74 12                	je     709456 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x6e6>
  709444:	48 8d 0c d1          	lea    (%rcx,%rdx,8),%rcx
  709448:	48 83 c1 08          	add    $0x8,%rcx
  70944c:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  709451:	48 89 ef             	mov    %rbp,%rdi
  709454:	ff d0                	call   *%rax
  709456:	49 8b 75 08          	mov    0x8(%r13),%rsi
  70945a:	48 85 f6             	test   %rsi,%rsi
  70945d:	74 0d                	je     70946c <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x6fc>
  70945f:	49 8b 55 10          	mov    0x10(%r13),%rdx
  709463:	48 89 ef             	mov    %rbp,%rdi
  709466:	ff 15 dc fe 41 00    	call   *0x41fedc(%rip)        # b29348 <_DYNAMIC+0x248>
  70946c:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  709471:	49 89 44 24 08       	mov    %rax,0x8(%r12)
  709476:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  70947b:	49 89 44 24 10       	mov    %rax,0x10(%r12)
  709480:	48 8b 54 24 60       	mov    0x60(%rsp),%rdx
  709485:	49 89 96 60 06 00 00 	mov    %rdx,0x660(%r14)
  70948c:	49 ff 86 b0 06 00 00 	incq   0x6b0(%r14)
  709493:	49 c7 86 08 07 00 00 	movq   $0x0,0x708(%r14)
  70949a:	00 00 00 00 
  70949e:	41 c6 86 1f 08 00 00 	movb   $0x1,0x81f(%r14)
  7094a5:	01 
  7094a6:	48 89 df             	mov    %rbx,%rdi
  7094a9:	4c 89 f6             	mov    %r14,%rsi
  7094ac:	48 81 c4 28 01 00 00 	add    $0x128,%rsp
  7094b3:	5b                   	pop    %rbx
  7094b4:	41 5c                	pop    %r12
  7094b6:	41 5d                	pop    %r13
  7094b8:	41 5e                	pop    %r14
  7094ba:	41 5f                	pop    %r15
  7094bc:	5d                   	pop    %rbp
  7094bd:	e9 be 17 01 00       	jmp    71ac80 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::present>
  7094c2:	31 c9                	xor    %ecx,%ecx
  7094c4:	49 8b b6 08 07 00 00 	mov    0x708(%r14),%rsi
  7094cb:	48 89 4b 08          	mov    %rcx,0x8(%rbx)
  7094cf:	48 89 53 10          	mov    %rdx,0x10(%rbx)
  7094d3:	0f 11 43 18          	movups %xmm0,0x18(%rbx)
  7094d7:	48 89 73 28          	mov    %rsi,0x28(%rbx)
  7094db:	88 43 30             	mov    %al,0x30(%rbx)
  7094de:	48 c7 03 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rbx)
  7094e5:	48 8d 7c 24 68       	lea    0x68(%rsp),%rdi
  7094ea:	e8 f1 ea fe ff       	call   6f7fe0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  7094ef:	e9 11 f9 ff ff       	jmp    708e05 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x95>
  7094f4:	48 8b 8c 24 f0 00 00 	mov    0xf0(%rsp),%rcx
  7094fb:	00 
  7094fc:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  709503:	00 
  709504:	0f 10 84 24 d0 00 00 	movups 0xd0(%rsp),%xmm0
  70950b:	00 
  70950c:	0f 10 8c 24 e0 00 00 	movups 0xe0(%rsp),%xmm1
  709513:	00 
  709514:	0f 11 8c 24 88 00 00 	movups %xmm1,0x88(%rsp)
  70951b:	00 
  70951c:	0f 11 44 24 78       	movups %xmm0,0x78(%rsp)
  709521:	48 89 44 24 68       	mov    %rax,0x68(%rsp)
  709526:	4c 89 64 24 70       	mov    %r12,0x70(%rsp)
  70952b:	48 83 f8 11          	cmp    $0x11,%rax
  70952f:	0f 84 49 fb ff ff    	je     70907e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x30e>
  709535:	eb 2d                	jmp    709564 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x7f4>
  709537:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  70953c:	48 89 84 24 98 00 00 	mov    %rax,0x98(%rsp)
  709543:	00 
  709544:	0f 10 44 24 38       	movups 0x38(%rsp),%xmm0
  709549:	0f 10 4c 24 48       	movups 0x48(%rsp),%xmm1
  70954e:	0f 11 8c 24 88 00 00 	movups %xmm1,0x88(%rsp)
  709555:	00 
  709556:	0f 11 44 24 78       	movups %xmm0,0x78(%rsp)
  70955b:	48 c7 44 24 68 1a 00 	movq   $0x1a,0x68(%rsp)
  709562:	00 00 
  709564:	48 8b 84 24 98 00 00 	mov    0x98(%rsp),%rax
  70956b:	00 
  70956c:	48 89 43 30          	mov    %rax,0x30(%rbx)
  709570:	48 8b 44 24 68       	mov    0x68(%rsp),%rax
  709575:	48 8b 4c 24 70       	mov    0x70(%rsp),%rcx
  70957a:	0f 10 44 24 78       	movups 0x78(%rsp),%xmm0
  70957f:	0f 10 8c 24 88 00 00 	movups 0x88(%rsp),%xmm1
  709586:	00 
  709587:	0f 11 4b 20          	movups %xmm1,0x20(%rbx)
  70958b:	0f 11 43 10          	movups %xmm0,0x10(%rbx)
  70958f:	48 89 03             	mov    %rax,(%rbx)
  709592:	48 89 4b 08          	mov    %rcx,0x8(%rbx)
  709596:	e9 6a f8 ff ff       	jmp    708e05 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x95>
  70959b:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  7095a2:	49 39 f4             	cmp    %rsi,%r12
  7095a5:	0f 83 eb 02 00 00    	jae    709896 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0xb26>
  7095ab:	49 8b 86 98 02 00 00 	mov    0x298(%r14),%rax
  7095b2:	4b 8d 0c a4          	lea    (%r12,%r12,4),%rcx
  7095b6:	44 8b 7c c8 18       	mov    0x18(%rax,%rcx,8),%r15d
  7095bb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  7095c0:	49 39 c7             	cmp    %rax,%r15
  7095c3:	0f 84 2c f8 ff ff    	je     708df5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x85>
  7095c9:	48 c7 44 24 28 11 00 	movq   $0x11,0x28(%rsp)
  7095d0:	00 00 
  7095d2:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  7095d7:	e8 04 ea fe ff       	call   6f7fe0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  7095dc:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  7095e3:	4c 39 fe             	cmp    %r15,%rsi
  7095e6:	0f 86 ba 02 00 00    	jbe    7098a6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0xb36>
  7095ec:	49 8d be b0 05 00 00 	lea    0x5b0(%r14),%rdi
  7095f3:	49 8b 86 98 02 00 00 	mov    0x298(%r14),%rax
  7095fa:	4b 8d 0c bf          	lea    (%r15,%r15,4),%rcx
  7095fe:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
  709602:	ff 15 f8 ff 41 00    	call   *0x41fff8(%rip)        # b29600 <_DYNAMIC+0x500>
  709608:	49 89 c7             	mov    %rax,%r15
  70960b:	49 89 d4             	mov    %rdx,%r12
  70960e:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  709613:	4c 89 f6             	mov    %r14,%rsi
  709616:	48 89 c2             	mov    %rax,%rdx
  709619:	4c 89 e1             	mov    %r12,%rcx
  70961c:	e8 1f df ff ff       	call   707540 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::inspector_app_index>
  709621:	83 7c 24 28 fe       	cmpl   $0xfffffffe,0x28(%rsp)
  709626:	75 5f                	jne    709687 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x917>
  709628:	48 89 df             	mov    %rbx,%rdi
  70962b:	4c 89 f6             	mov    %r14,%rsi
  70962e:	4c 89 fa             	mov    %r15,%rdx
  709631:	4c 89 e1             	mov    %r12,%rcx
  709634:	48 81 c4 28 01 00 00 	add    $0x128,%rsp
  70963b:	5b                   	pop    %rbx
  70963c:	41 5c                	pop    %r12
  70963e:	41 5d                	pop    %r13
  709640:	41 5e                	pop    %r14
  709642:	41 5f                	pop    %r15
  709644:	5d                   	pop    %rbp
  709645:	e9 e6 02 00 00       	jmp    709930 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::inspector_select>
  70964a:	8b 4c 24 5c          	mov    0x5c(%rsp),%ecx
  70964e:	89 4b 34             	mov    %ecx,0x34(%rbx)
  709651:	0f 10 44 24 4c       	movups 0x4c(%rsp),%xmm0
  709656:	0f 11 43 24          	movups %xmm0,0x24(%rbx)
  70965a:	0f 10 84 24 cc 00 00 	movups 0xcc(%rsp),%xmm0
  709661:	00 
  709662:	0f 11 43 14          	movups %xmm0,0x14(%rbx)
  709666:	0f 28 84 24 c0 00 00 	movaps 0xc0(%rsp),%xmm0
  70966d:	00 
  70966e:	0f 11 43 08          	movups %xmm0,0x8(%rbx)
  709672:	48 89 03             	mov    %rax,(%rbx)
  709675:	e9 8b f7 ff ff       	jmp    708e05 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x95>
  70967a:	48 8d 3d 3f 1a 3f 00 	lea    0x3f1a3f(%rip),%rdi        # afb0c0 <__frame_dummy_init_array_entry+0x828>
  709681:	ff 15 81 fd 41 00    	call   *0x41fd81(%rip)        # b29408 <_DYNAMIC+0x308>
  709687:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  70968c:	e8 4f e9 fe ff       	call   6f7fe0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  709691:	41 0f 10 86 60 06 00 	movups 0x660(%r14),%xmm0
  709698:	00 
  709699:	41 0f b6 86 20 08 00 	movzbl 0x820(%r14),%eax
  7096a0:	00 
  7096a1:	49 83 be 80 06 00 00 	cmpq   $0x0,0x680(%r14)
  7096a8:	00 
  7096a9:	74 1c                	je     7096c7 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x957>
  7096ab:	84 c0                	test   %al,%al
  7096ad:	74 0a                	je     7096b9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x949>
  7096af:	49 83 be 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%r14)
  7096b6:	ff 
  7096b7:	74 0e                	je     7096c7 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x957>
  7096b9:	49 8b 96 90 06 00 00 	mov    0x690(%r14),%rdx
  7096c0:	b9 01 00 00 00       	mov    $0x1,%ecx
  7096c5:	eb 02                	jmp    7096c9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x959>
  7096c7:	31 c9                	xor    %ecx,%ecx
  7096c9:	49 8b b6 08 07 00 00 	mov    0x708(%r14),%rsi
  7096d0:	48 89 4b 08          	mov    %rcx,0x8(%rbx)
  7096d4:	48 89 53 10          	mov    %rdx,0x10(%rbx)
  7096d8:	0f 11 43 18          	movups %xmm0,0x18(%rbx)
  7096dc:	48 89 73 28          	mov    %rsi,0x28(%rbx)
  7096e0:	e9 f0 f9 ff ff       	jmp    7090d5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x365>
  7096e5:	83 f8 23             	cmp    $0x23,%eax
  7096e8:	0f 85 eb 00 00 00    	jne    7097d9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0xa69>
  7096ee:	8b 44 24 30          	mov    0x30(%rsp),%eax
  7096f2:	83 f8 0d             	cmp    $0xd,%eax
  7096f5:	0f 84 12 01 00 00    	je     70980d <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0xa9d>
  7096fb:	83 f8 0e             	cmp    $0xe,%eax
  7096fe:	0f 85 d5 00 00 00    	jne    7097d9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0xa69>
  709704:	ba 07 00 00 00       	mov    $0x7,%edx
  709709:	e9 04 01 00 00       	jmp    709812 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0xaa2>
  70970e:	c6 84 24 a0 00 00 00 	movb   $0x0,0xa0(%rsp)
  709715:	00 
  709716:	c7 84 24 a4 00 00 00 	movl   $0x0,0xa4(%rsp)
  70971d:	00 00 00 00 
  709721:	48 8d b4 24 a0 00 00 	lea    0xa0(%rsp),%rsi
  709728:	00 
  709729:	8b 7c 24 08          	mov    0x8(%rsp),%edi
  70972d:	ff 15 d5 fe 41 00    	call   *0x41fed5(%rip)        # b29608 <_DYNAMIC+0x508>
  709733:	66 85 c0             	test   %ax,%ax
  709736:	74 2a                	je     709762 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x9f2>
  709738:	48 c1 e8 10          	shr    $0x10,%rax
  70973c:	48 89 df             	mov    %rbx,%rdi
  70973f:	4c 89 f6             	mov    %r14,%rsi
  709742:	89 c2                	mov    %eax,%edx
  709744:	48 81 c4 28 01 00 00 	add    $0x128,%rsp
  70974b:	5b                   	pop    %rbx
  70974c:	41 5c                	pop    %r12
  70974e:	41 5d                	pop    %r13
  709750:	41 5e                	pop    %r14
  709752:	41 5f                	pop    %r15
  709754:	5d                   	pop    %rbp
  709755:	e9 f6 f4 ff ff       	jmp    708c50 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::reject_editor>
  70975a:	c6 84 24 a0 00 00 00 	movb   $0xff,0xa0(%rsp)
  709761:	ff 
  709762:	4d 8b be 60 06 00 00 	mov    0x660(%r14),%r15
  709769:	49 83 ff ff          	cmp    $0xffffffffffffffff,%r15
  70976d:	0f 84 8e 00 00 00    	je     709801 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0xa91>
  709773:	48 c7 44 24 28 1f 00 	movq   $0x1f,0x28(%rsp)
  70977a:	00 00 
  70977c:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  709781:	e8 5a e8 fe ff       	call   6f7fe0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  709786:	49 8b 86 10 06 00 00 	mov    0x610(%r14),%rax
  70978d:	48 85 c0             	test   %rax,%rax
  709790:	0f 84 af 00 00 00    	je     709845 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0xad5>
  709796:	48 8b 80 d8 00 00 00 	mov    0xd8(%rax),%rax
  70979d:	48 85 c0             	test   %rax,%rax
  7097a0:	0f 84 9f 00 00 00    	je     709845 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0xad5>
  7097a6:	49 ff c7             	inc    %r15
  7097a9:	c6 40 13 ff          	movb   $0xff,0x13(%rax)
  7097ad:	48 8d 84 24 a0 00 00 	lea    0xa0(%rsp),%rax
  7097b4:	00 
  7097b5:	48 89 04 24          	mov    %rax,(%rsp)
  7097b9:	48 89 df             	mov    %rbx,%rdi
  7097bc:	4c 89 f6             	mov    %r14,%rsi
  7097bf:	48 8b 54 24 60       	mov    0x60(%rsp),%rdx
  7097c4:	4c 89 e1             	mov    %r12,%rcx
  7097c7:	4d 89 f8             	mov    %r15,%r8
  7097ca:	44 8b 4c 24 08       	mov    0x8(%rsp),%r9d
  7097cf:	e8 2c 06 02 00       	call   729e00 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at>
  7097d4:	e9 2c f6 ff ff       	jmp    708e05 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x95>
  7097d9:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  7097de:	48 89 43 30          	mov    %rax,0x30(%rbx)
  7097e2:	0f 10 44 24 28       	movups 0x28(%rsp),%xmm0
  7097e7:	0f 10 4c 24 38       	movups 0x38(%rsp),%xmm1
  7097ec:	0f 10 54 24 48       	movups 0x48(%rsp),%xmm2
  7097f1:	0f 11 53 20          	movups %xmm2,0x20(%rbx)
  7097f5:	0f 11 4b 10          	movups %xmm1,0x10(%rbx)
  7097f9:	0f 11 03             	movups %xmm0,(%rbx)
  7097fc:	e9 04 f6 ff ff       	jmp    708e05 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x95>
  709801:	48 c7 03 1f 00 00 00 	movq   $0x1f,(%rbx)
  709808:	e9 f8 f5 ff ff       	jmp    708e05 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x95>
  70980d:	ba 06 00 00 00       	mov    $0x6,%edx
  709812:	48 89 df             	mov    %rbx,%rdi
  709815:	4c 89 f6             	mov    %r14,%rsi
  709818:	e8 33 f4 ff ff       	call   708c50 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::reject_editor>
  70981d:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  709822:	e8 b9 e7 fe ff       	call   6f7fe0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  709827:	e9 d9 f5 ff ff       	jmp    708e05 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x95>
  70982c:	48 8d 3d 51 0d 96 ff 	lea    -0x69f2af(%rip),%rdi        # 6a584 <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x32a7>
  709833:	48 8d 15 fe 18 3f 00 	lea    0x3f18fe(%rip),%rdx        # afb138 <__frame_dummy_init_array_entry+0x8a0>
  70983a:	be 28 00 00 00       	mov    $0x28,%esi
  70983f:	ff 15 cb fd 41 00    	call   *0x41fdcb(%rip)        # b29610 <_DYNAMIC+0x510>
  709845:	48 8d 3d 79 0d 96 ff 	lea    -0x69f287(%rip),%rdi        # 6a5c5 <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x32e8>
  70984c:	48 8d 15 f5 17 3f 00 	lea    0x3f17f5(%rip),%rdx        # afb048 <__frame_dummy_init_array_entry+0x7b0>
  709853:	be 11 00 00 00       	mov    $0x11,%esi
  709858:	ff 15 ea fb 41 00    	call   *0x41fbea(%rip)        # b29448 <_DYNAMIC+0x348>
  70985e:	48 8d 3d 73 18 3f 00 	lea    0x3f1873(%rip),%rdi        # afb0d8 <__frame_dummy_init_array_entry+0x840>
  709865:	ff 15 9d fb 41 00    	call   *0x41fb9d(%rip)        # b29408 <_DYNAMIC+0x308>
  70986b:	4c 89 ff             	mov    %r15,%rdi
  70986e:	48 8d 15 7b 18 3f 00 	lea    0x3f187b(%rip),%rdx        # afb0f0 <__frame_dummy_init_array_entry+0x858>
  709875:	ff 15 dd fb 41 00    	call   *0x41fbdd(%rip)        # b29458 <_DYNAMIC+0x358>
  70987b:	0f 0b                	ud2
  70987d:	48 8d 3d 00 0d 96 ff 	lea    -0x69f300(%rip),%rdi        # 6a584 <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x32a7>
  709884:	48 8d 15 c5 18 3f 00 	lea    0x3f18c5(%rip),%rdx        # afb150 <__frame_dummy_init_array_entry+0x8b8>
  70988b:	be 28 00 00 00       	mov    $0x28,%esi
  709890:	ff 15 7a fd 41 00    	call   *0x41fd7a(%rip)        # b29610 <_DYNAMIC+0x510>
  709896:	48 8d 15 6b 18 3f 00 	lea    0x3f186b(%rip),%rdx        # afb108 <__frame_dummy_init_array_entry+0x870>
  70989d:	4c 89 e7             	mov    %r12,%rdi
  7098a0:	ff 15 b2 fb 41 00    	call   *0x41fbb2(%rip)        # b29458 <_DYNAMIC+0x358>
  7098a6:	48 8d 15 73 18 3f 00 	lea    0x3f1873(%rip),%rdx        # afb120 <__frame_dummy_init_array_entry+0x888>
  7098ad:	4c 89 ff             	mov    %r15,%rdi
  7098b0:	ff 15 a2 fb 41 00    	call   *0x41fba2(%rip)        # b29458 <_DYNAMIC+0x358>
  7098b6:	48 89 c3             	mov    %rax,%rbx
  7098b9:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  7098be:	e8 1d e7 fe ff       	call   6f7fe0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  7098c3:	48 89 df             	mov    %rbx,%rdi
  7098c6:	e8 15 fc 3e 00       	call   af94e0 <_Unwind_Resume@plt>
  7098cb:	4c 8b 74 24 20       	mov    0x20(%rsp),%r14
  7098d0:	48 89 c3             	mov    %rax,%rbx
  7098d3:	49 8b 75 08          	mov    0x8(%r13),%rsi
  7098d7:	48 85 f6             	test   %rsi,%rsi
  7098da:	74 0d                	je     7098e9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0xb79>
  7098dc:	49 8b 55 10          	mov    0x10(%r13),%rdx
  7098e0:	48 89 ef             	mov    %rbp,%rdi
  7098e3:	ff 15 5f fa 41 00    	call   *0x41fa5f(%rip)        # b29348 <_DYNAMIC+0x248>
  7098e9:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  7098ee:	49 89 06             	mov    %rax,(%r14)
  7098f1:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  7098f6:	49 89 44 24 10       	mov    %rax,0x10(%r12)
  7098fb:	48 89 df             	mov    %rbx,%rdi
  7098fe:	e8 dd fb 3e 00       	call   af94e0 <_Unwind_Resume@plt>
  709903:	48 89 c3             	mov    %rax,%rbx
  709906:	48 8b 7c 24 10       	mov    0x10(%rsp),%rdi
  70990b:	48 8b 74 24 08       	mov    0x8(%rsp),%rsi
  709910:	e8 4b b0 fe ff       	call   6f4960 <core::ptr::drop_glue::<core::option::Option<gpui::element::Handler>>>
  709915:	48 89 df             	mov    %rbx,%rdi
  709918:	e8 c3 fb 3e 00       	call   af94e0 <_Unwind_Resume@plt>
  70991d:	ff 15 55 fa 41 00    	call   *0x41fa55(%rip)        # b29378 <_DYNAMIC+0x278>
