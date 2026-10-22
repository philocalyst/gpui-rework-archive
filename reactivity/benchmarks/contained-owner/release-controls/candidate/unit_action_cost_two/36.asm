
/tmp/gpui-contained-owner-spike-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

0000000000708de0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action>:
  708de0:	55                   	push   %rbp
  708de1:	41 57                	push   %r15
  708de3:	41 56                	push   %r14
  708de5:	41 55                	push   %r13
  708de7:	41 54                	push   %r12
  708de9:	53                   	push   %rbx
  708dea:	48 81 ec 28 01 00 00 	sub    $0x128,%rsp
  708df1:	48 89 fb             	mov    %rdi,%rbx
  708df4:	80 be 22 08 00 00 00 	cmpb   $0x0,0x822(%rsi)
  708dfb:	74 09                	je     708e06 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x26>
  708dfd:	48 c7 03 0e 00 00 00 	movq   $0xe,(%rbx)
  708e04:	eb 6f                	jmp    708e75 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x95>
  708e06:	49 89 f6             	mov    %rsi,%r14
  708e09:	48 8b 86 10 06 00 00 	mov    0x610(%rsi),%rax
  708e10:	48 85 c0             	test   %rax,%rax
  708e13:	74 59                	je     708e6e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x8e>
  708e15:	48 83 b8 d8 00 00 00 	cmpq   $0x0,0xd8(%rax)
  708e1c:	00 
  708e1d:	74 4f                	je     708e6e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x8e>
  708e1f:	49 c7 86 08 07 00 00 	movq   $0x0,0x708(%r14)
  708e26:	00 00 00 00 
  708e2a:	48 8b a8 d8 00 00 00 	mov    0xd8(%rax),%rbp
  708e31:	48 85 ed             	test   %rbp,%rbp
  708e34:	0f 84 b0 08 00 00    	je     7096ea <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x90a>
  708e3a:	44 0f b7 65 10       	movzwl 0x10(%rbp),%r12d
  708e3f:	0f b6 7d 16          	movzbl 0x16(%rbp),%edi
  708e43:	44 0f b6 45 12       	movzbl 0x12(%rbp),%r8d
  708e48:	89 c8                	mov    %ecx,%eax
  708e4a:	66 83 e8 0e          	sub    $0xe,%ax
  708e4e:	41 bf 03 00 00 00    	mov    $0x3,%r15d
  708e54:	44 0f 43 f8          	cmovae %eax,%r15d
  708e58:	66 41 83 ff 03       	cmp    $0x3,%r15w
  708e5d:	75 28                	jne    708e87 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0xa7>
  708e5f:	66 41 39 cc          	cmp    %cx,%r12w
  708e63:	74 22                	je     708e87 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0xa7>
  708e65:	48 c7 03 11 00 00 00 	movq   $0x11,(%rbx)
  708e6c:	eb 07                	jmp    708e75 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x95>
  708e6e:	48 c7 03 1a 00 00 00 	movq   $0x1a,(%rbx)
  708e75:	48 81 c4 28 01 00 00 	add    $0x128,%rsp
  708e7c:	5b                   	pop    %rbx
  708e7d:	41 5c                	pop    %r12
  708e7f:	41 5d                	pop    %r13
  708e81:	41 5e                	pop    %r14
  708e83:	41 5f                	pop    %r15
  708e85:	5d                   	pop    %rbp
  708e86:	c3                   	ret
  708e87:	41 89 cd             	mov    %ecx,%r13d
  708e8a:	41 c1 ed 10          	shr    $0x10,%r13d
  708e8e:	45 0f b7 cf          	movzwl %r15w,%r9d
  708e92:	48 8d 05 e7 29 95 ff 	lea    -0x6ad619(%rip),%rax        # 5b880 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x10>
  708e99:	4a 63 34 88          	movslq (%rax,%r9,4),%rsi
  708e9d:	48 01 c6             	add    %rax,%rsi
  708ea0:	ff e6                	jmp    *%rsi
  708ea2:	44 0f b7 ff          	movzwl %di,%r15d
  708ea6:	41 81 cf 00 01 00 00 	or     $0x100,%r15d
  708ead:	eb 12                	jmp    708ec1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0xe1>
  708eaf:	45 0f b7 f8          	movzwl %r8w,%r15d
  708eb3:	41 c1 e7 08          	shl    $0x8,%r15d
  708eb7:	66 45 39 e5          	cmp    %r12w,%r13w
  708ebb:	0f 85 f3 02 00 00    	jne    7091b4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x3d4>
  708ec1:	b0 01                	mov    $0x1,%al
  708ec3:	44 38 ff             	cmp    %r15b,%dil
  708ec6:	0f 85 ed 02 00 00    	jne    7091b9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x3d9>
  708ecc:	41 0f b7 cf          	movzwl %r15w,%ecx
  708ed0:	c1 e9 08             	shr    $0x8,%ecx
  708ed3:	41 38 c8             	cmp    %cl,%r8b
  708ed6:	0f 85 dd 02 00 00    	jne    7091b9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x3d9>
  708edc:	80 7d 13 ff          	cmpb   $0xff,0x13(%rbp)
  708ee0:	0f 85 d3 02 00 00    	jne    7091b9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x3d9>
  708ee6:	e9 c4 01 00 00       	jmp    7090af <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x2cf>
  708eeb:	f7 c1 00 00 ff 00    	test   $0xff0000,%ecx
  708ef1:	0f 84 5d 02 00 00    	je     709154 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x374>
  708ef7:	48 8b 45 00          	mov    0x0(%rbp),%rax
  708efb:	48 85 c0             	test   %rax,%rax
  708efe:	0f 84 ab 01 00 00    	je     7090af <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x2cf>
  708f04:	49 3b 86 b0 05 00 00 	cmp    0x5b0(%r14),%rax
  708f0b:	0f 85 d4 01 00 00    	jne    7090e5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x305>
  708f11:	4c 89 4c 24 18       	mov    %r9,0x18(%rsp)
  708f16:	48 89 7c 24 10       	mov    %rdi,0x10(%rsp)
  708f1b:	48 89 54 24 60       	mov    %rdx,0x60(%rsp)
  708f20:	89 4c 24 08          	mov    %ecx,0x8(%rsp)
  708f24:	4c 8b 65 08          	mov    0x8(%rbp),%r12
  708f28:	48 c7 44 24 28 11 00 	movq   $0x11,0x28(%rsp)
  708f2f:	00 00 
  708f31:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  708f36:	e8 b5 f0 fe ff       	call   6f7ff0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  708f3b:	48 8d bc 24 c0 00 00 	lea    0xc0(%rsp),%rdi
  708f42:	00 
  708f43:	4c 89 f6             	mov    %r14,%rsi
  708f46:	4c 89 e2             	mov    %r12,%rdx
  708f49:	e8 32 15 01 00       	call   71a480 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::resolve_identity>
  708f4e:	48 8b 84 24 c0 00 00 	mov    0xc0(%rsp),%rax
  708f55:	00 
  708f56:	4c 8b a4 24 c8 00 00 	mov    0xc8(%rsp),%r12
  708f5d:	00 
  708f5e:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  708f62:	0f 85 fc 05 00 00    	jne    709564 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x784>
  708f68:	49 8b 86 10 06 00 00 	mov    0x610(%r14),%rax
  708f6f:	48 85 c0             	test   %rax,%rax
  708f72:	0f 84 2f 06 00 00    	je     7095a7 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x7c7>
  708f78:	48 83 b8 d8 00 00 00 	cmpq   $0x0,0xd8(%rax)
  708f7f:	00 
  708f80:	0f 84 21 06 00 00    	je     7095a7 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x7c7>
  708f86:	49 8b ae a0 02 00 00 	mov    0x2a0(%r14),%rbp
  708f8d:	48 c7 44 24 28 1a 00 	movq   $0x1a,0x28(%rsp)
  708f94:	00 00 
  708f96:	48 83 fd 1c          	cmp    $0x1c,%rbp
  708f9a:	0f 82 07 06 00 00    	jb     7095a7 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x7c7>
  708fa0:	48 83 c5 e4          	add    $0xffffffffffffffe4,%rbp
  708fa4:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  708fa9:	e8 42 f0 fe ff       	call   6f7ff0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  708fae:	49 83 fc 02          	cmp    $0x2,%r12
  708fb2:	0f 93 c0             	setae  %al
  708fb5:	49 39 ec             	cmp    %rbp,%r12
  708fb8:	0f 92 c1             	setb   %cl
  708fbb:	84 c8                	test   %cl,%al
  708fbd:	0f 84 22 01 00 00    	je     7090e5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x305>
  708fc3:	66 41 83 ff 01       	cmp    $0x1,%r15w
  708fc8:	0f 84 3d 06 00 00    	je     70960b <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x82b>
  708fce:	83 7c 24 18 03       	cmpl   $0x3,0x18(%rsp)
  708fd3:	0f 85 c3 08 00 00    	jne    70989c <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0xabc>
  708fd9:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  708fde:	4c 89 f6             	mov    %r14,%rsi
  708fe1:	4c 89 e2             	mov    %r12,%rdx
  708fe4:	8b 4c 24 08          	mov    0x8(%rsp),%ecx
  708fe8:	e8 a3 09 02 00       	call   729990 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::property_value_at>
  708fed:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  708ff2:	0f 10 44 24 30       	movups 0x30(%rsp),%xmm0
  708ff7:	0f 29 84 24 c0 00 00 	movaps %xmm0,0xc0(%rsp)
  708ffe:	00 
  708fff:	0f 10 44 24 3c       	movups 0x3c(%rsp),%xmm0
  709004:	0f 11 84 24 cc 00 00 	movups %xmm0,0xcc(%rsp)
  70900b:	00 
  70900c:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  709010:	0f 85 a4 06 00 00    	jne    7096ba <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x8da>
  709016:	0f 28 84 24 c0 00 00 	movaps 0xc0(%rsp),%xmm0
  70901d:	00 
  70901e:	0f 29 84 24 00 01 00 	movaps %xmm0,0x100(%rsp)
  709025:	00 
  709026:	0f 10 84 24 cc 00 00 	movups 0xcc(%rsp),%xmm0
  70902d:	00 
  70902e:	0f 11 84 24 0c 01 00 	movups %xmm0,0x10c(%rsp)
  709035:	00 
  709036:	41 0f b6 c5          	movzbl %r13b,%eax
  70903a:	48 8d 0d 4f 28 95 ff 	lea    -0x6ad7b1(%rip),%rcx        # 5b890 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x20>
  709041:	48 63 04 81          	movslq (%rcx,%rax,4),%rax
  709045:	48 01 c8             	add    %rcx,%rax
  709048:	ff e0                	jmp    *%rax
  70904a:	8b 44 24 08          	mov    0x8(%rsp),%eax
  70904e:	25 00 00 ff 00       	and    $0xff0000,%eax
  709053:	31 c9                	xor    %ecx,%ecx
  709055:	3d 00 00 02 00       	cmp    $0x20000,%eax
  70905a:	0f 94 c1             	sete   %cl
  70905d:	48 8d 05 c4 25 95 ff 	lea    -0x6ada3c(%rip),%rax        # 5b628 <anon.079f5e587c394fcac2765eb4d0cf0bc2.21.llvm.6319143315422321905+0x48>
  709064:	f3 0f 10 04 88       	movss  (%rax,%rcx,4),%xmm0
  709069:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  70906e:	48 8d b4 24 00 01 00 	lea    0x100(%rsp),%rsi
  709075:	00 
  709076:	48 8b 54 24 10       	mov    0x10(%rsp),%rdx
  70907b:	ff 15 df 05 42 00    	call   *0x4205df(%rip)        # b29660 <_DYNAMIC+0x4f0>
  709081:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  709086:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  70908a:	0f 85 c5 06 00 00    	jne    709755 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x975>
  709090:	0f 10 44 24 30       	movups 0x30(%rsp),%xmm0
  709095:	0f 10 4c 24 3c       	movups 0x3c(%rsp),%xmm1
  70909a:	0f 11 8c 24 ac 00 00 	movups %xmm1,0xac(%rsp)
  7090a1:	00 
  7090a2:	0f 29 84 24 a0 00 00 	movaps %xmm0,0xa0(%rsp)
  7090a9:	00 
  7090aa:	e9 e2 06 00 00       	jmp    709791 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x9b1>
  7090af:	41 0f 10 86 60 06 00 	movups 0x660(%r14),%xmm0
  7090b6:	00 
  7090b7:	41 0f b6 86 20 08 00 	movzbl 0x820(%r14),%eax
  7090be:	00 
  7090bf:	49 83 be 80 06 00 00 	cmpq   $0x0,0x680(%r14)
  7090c6:	00 
  7090c7:	74 66                	je     70912f <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x34f>
  7090c9:	84 c0                	test   %al,%al
  7090cb:	74 0a                	je     7090d7 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x2f7>
  7090cd:	49 83 be 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%r14)
  7090d4:	ff 
  7090d5:	74 58                	je     70912f <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x34f>
  7090d7:	49 8b 96 90 06 00 00 	mov    0x690(%r14),%rdx
  7090de:	b9 01 00 00 00       	mov    $0x1,%ecx
  7090e3:	eb 4c                	jmp    709131 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x351>
  7090e5:	48 c7 44 24 68 11 00 	movq   $0x11,0x68(%rsp)
  7090ec:	00 00 
  7090ee:	41 0f 10 86 60 06 00 	movups 0x660(%r14),%xmm0
  7090f5:	00 
  7090f6:	41 0f b6 86 20 08 00 	movzbl 0x820(%r14),%eax
  7090fd:	00 
  7090fe:	49 83 be 80 06 00 00 	cmpq   $0x0,0x680(%r14)
  709105:	00 
  709106:	0f 84 26 04 00 00    	je     709532 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x752>
  70910c:	84 c0                	test   %al,%al
  70910e:	74 0e                	je     70911e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x33e>
  709110:	49 83 be 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%r14)
  709117:	ff 
  709118:	0f 84 14 04 00 00    	je     709532 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x752>
  70911e:	49 8b 96 90 06 00 00 	mov    0x690(%r14),%rdx
  709125:	b9 01 00 00 00       	mov    $0x1,%ecx
  70912a:	e9 05 04 00 00       	jmp    709534 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x754>
  70912f:	31 c9                	xor    %ecx,%ecx
  709131:	48 89 4b 08          	mov    %rcx,0x8(%rbx)
  709135:	48 89 53 10          	mov    %rdx,0x10(%rbx)
  709139:	0f 11 43 18          	movups %xmm0,0x18(%rbx)
  70913d:	48 c7 43 28 00 00 00 	movq   $0x0,0x28(%rbx)
  709144:	00 
  709145:	88 43 30             	mov    %al,0x30(%rbx)
  709148:	48 c7 03 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rbx)
  70914f:	e9 21 fd ff ff       	jmp    708e75 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x95>
  709154:	45 0f b7 f8          	movzwl %r8w,%r15d
  709158:	8d 47 01             	lea    0x1(%rdi),%eax
  70915b:	89 44 24 18          	mov    %eax,0x18(%rsp)
  70915f:	48 89 7c 24 10       	mov    %rdi,0x10(%rsp)
  709164:	89 cf                	mov    %ecx,%edi
  709166:	89 4c 24 08          	mov    %ecx,0x8(%rsp)
  70916a:	45 89 c5             	mov    %r8d,%r13d
  70916d:	e8 5e ba ff ff       	call   704bd0 <<gpui::property::PropertyId>::info>
  709172:	45 89 e8             	mov    %r13d,%r8d
  709175:	48 8b 7c 24 10       	mov    0x10(%rsp),%rdi
  70917a:	44 8b 6c 24 08       	mov    0x8(%rsp),%r13d
  70917f:	0f b6 40 14          	movzbl 0x14(%rax),%eax
  709183:	31 c9                	xor    %ecx,%ecx
  709185:	3c 04                	cmp    $0x4,%al
  709187:	0f 94 c1             	sete   %cl
  70918a:	8d 0c 89             	lea    (%rcx,%rcx,4),%ecx
  70918d:	ff c1                	inc    %ecx
  70918f:	3c 02                	cmp    $0x2,%al
  709191:	ba 04 00 00 00       	mov    $0x4,%edx
  709196:	0f 45 d1             	cmovne %ecx,%edx
  709199:	0f b6 44 24 18       	movzbl 0x18(%rsp),%eax
  70919e:	f6 f2                	div    %dl
  7091a0:	0f b6 c4             	movzbl %ah,%eax
  7091a3:	41 c1 e7 08          	shl    $0x8,%r15d
  7091a7:	41 09 c7             	or     %eax,%r15d
  7091aa:	66 45 39 e5          	cmp    %r12w,%r13w
  7091ae:	0f 84 0d fd ff ff    	je     708ec1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0xe1>
  7091b4:	31 c0                	xor    %eax,%eax
  7091b6:	45 89 ec             	mov    %r13d,%r12d
  7091b9:	49 8b 96 60 06 00 00 	mov    0x660(%r14),%rdx
  7091c0:	48 ff c2             	inc    %rdx
  7091c3:	0f 84 a8 06 00 00    	je     709871 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0xa91>
  7091c9:	41 0f b7 cf          	movzwl %r15w,%ecx
  7091cd:	66 44 89 65 10       	mov    %r12w,0x10(%rbp)
  7091d2:	88 4d 16             	mov    %cl,0x16(%rbp)
  7091d5:	88 6d 12             	mov    %ch,0x12(%rbp)
  7091d8:	c6 45 13 ff          	movb   $0xff,0x13(%rbp)
  7091dc:	84 c0                	test   %al,%al
  7091de:	0f 85 11 03 00 00    	jne    7094f5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x715>
  7091e4:	49 8b 86 10 06 00 00 	mov    0x610(%r14),%rax
  7091eb:	48 85 c0             	test   %rax,%rax
  7091ee:	0f 84 da 06 00 00    	je     7098ce <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0xaee>
  7091f4:	48 83 b8 d8 00 00 00 	cmpq   $0x0,0xd8(%rax)
  7091fb:	00 
  7091fc:	0f 84 cc 06 00 00    	je     7098ce <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0xaee>
  709202:	4d 8b be a0 02 00 00 	mov    0x2a0(%r14),%r15
  709209:	49 83 ff 1c          	cmp    $0x1c,%r15
  70920d:	0f 82 bb 06 00 00    	jb     7098ce <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0xaee>
  709213:	48 89 54 24 60       	mov    %rdx,0x60(%rsp)
  709218:	41 0f b7 fc          	movzwl %r12w,%edi
  70921c:	48 89 7c 24 18       	mov    %rdi,0x18(%rsp)
  709221:	ff 15 41 04 42 00    	call   *0x420441(%rip)        # b29668 <_DYNAMIC+0x4f8>
  709227:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  70922c:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
  709231:	49 8d 7f f7          	lea    -0x9(%r15),%rdi
  709235:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  70923c:	48 39 f7             	cmp    %rsi,%rdi
  70923f:	0f 83 99 06 00 00    	jae    7098de <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0xafe>
  709245:	49 8b 8e 98 02 00 00 	mov    0x298(%r14),%rcx
  70924c:	48 8d 14 bf          	lea    (%rdi,%rdi,4),%rdx
  709250:	4c 8d 24 d1          	lea    (%rcx,%rdx,8),%r12
  709254:	48 8b 6c d1 08       	mov    0x8(%rcx,%rdx,8),%rbp
  709259:	48 85 ed             	test   %rbp,%rbp
  70925c:	74 36                	je     709294 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x4b4>
  70925e:	4c 8b 6c d1 10       	mov    0x10(%rcx,%rdx,8),%r13
  709263:	49 8b 45 00          	mov    0x0(%r13),%rax
  709267:	48 85 c0             	test   %rax,%rax
  70926a:	74 12                	je     70927e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x49e>
  70926c:	48 8d 0c d1          	lea    (%rcx,%rdx,8),%rcx
  709270:	48 83 c1 08          	add    $0x8,%rcx
  709274:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  709279:	48 89 ef             	mov    %rbp,%rdi
  70927c:	ff d0                	call   *%rax
  70927e:	49 8b 75 08          	mov    0x8(%r13),%rsi
  709282:	48 85 f6             	test   %rsi,%rsi
  709285:	74 0d                	je     709294 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x4b4>
  709287:	49 8b 55 10          	mov    0x10(%r13),%rdx
  70928b:	48 89 ef             	mov    %rbp,%rdi
  70928e:	ff 15 24 01 42 00    	call   *0x420124(%rip)        # b293b8 <_DYNAMIC+0x248>
  709294:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  709299:	49 89 44 24 08       	mov    %rax,0x8(%r12)
  70929e:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  7092a3:	49 89 44 24 10       	mov    %rax,0x10(%r12)
  7092a8:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  7092ad:	8d b8 00 00 01 00    	lea    0x10000(%rax),%edi
  7092b3:	ff 15 af 03 42 00    	call   *0x4203af(%rip)        # b29668 <_DYNAMIC+0x4f8>
  7092b9:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  7092be:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
  7092c3:	49 8d 7f f9          	lea    -0x7(%r15),%rdi
  7092c7:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  7092ce:	48 39 f7             	cmp    %rsi,%rdi
  7092d1:	0f 83 07 06 00 00    	jae    7098de <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0xafe>
  7092d7:	49 8b 8e 98 02 00 00 	mov    0x298(%r14),%rcx
  7092de:	48 8d 14 bf          	lea    (%rdi,%rdi,4),%rdx
  7092e2:	4c 8d 24 d1          	lea    (%rcx,%rdx,8),%r12
  7092e6:	48 8b 6c d1 08       	mov    0x8(%rcx,%rdx,8),%rbp
  7092eb:	48 85 ed             	test   %rbp,%rbp
  7092ee:	74 36                	je     709326 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x546>
  7092f0:	4c 8b 6c d1 10       	mov    0x10(%rcx,%rdx,8),%r13
  7092f5:	49 8b 45 00          	mov    0x0(%r13),%rax
  7092f9:	48 85 c0             	test   %rax,%rax
  7092fc:	74 12                	je     709310 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x530>
  7092fe:	48 8d 0c d1          	lea    (%rcx,%rdx,8),%rcx
  709302:	48 83 c1 08          	add    $0x8,%rcx
  709306:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  70930b:	48 89 ef             	mov    %rbp,%rdi
  70930e:	ff d0                	call   *%rax
  709310:	49 8b 75 08          	mov    0x8(%r13),%rsi
  709314:	48 85 f6             	test   %rsi,%rsi
  709317:	74 0d                	je     709326 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x546>
  709319:	49 8b 55 10          	mov    0x10(%r13),%rdx
  70931d:	48 89 ef             	mov    %rbp,%rdi
  709320:	ff 15 92 00 42 00    	call   *0x420092(%rip)        # b293b8 <_DYNAMIC+0x248>
  709326:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  70932b:	49 89 44 24 08       	mov    %rax,0x8(%r12)
  709330:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  709335:	49 89 44 24 10       	mov    %rax,0x10(%r12)
  70933a:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  70933f:	8d b8 00 00 02 00    	lea    0x20000(%rax),%edi
  709345:	ff 15 1d 03 42 00    	call   *0x42031d(%rip)        # b29668 <_DYNAMIC+0x4f8>
  70934b:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  709350:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
  709355:	49 8d 7f fa          	lea    -0x6(%r15),%rdi
  709359:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  709360:	48 39 f7             	cmp    %rsi,%rdi
  709363:	0f 83 75 05 00 00    	jae    7098de <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0xafe>
  709369:	49 8b 8e 98 02 00 00 	mov    0x298(%r14),%rcx
  709370:	48 8d 14 bf          	lea    (%rdi,%rdi,4),%rdx
  709374:	4c 8d 24 d1          	lea    (%rcx,%rdx,8),%r12
  709378:	48 8b 6c d1 08       	mov    0x8(%rcx,%rdx,8),%rbp
  70937d:	48 85 ed             	test   %rbp,%rbp
  709380:	74 36                	je     7093b8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x5d8>
  709382:	4c 8b 6c d1 10       	mov    0x10(%rcx,%rdx,8),%r13
  709387:	49 8b 45 00          	mov    0x0(%r13),%rax
  70938b:	48 85 c0             	test   %rax,%rax
  70938e:	74 12                	je     7093a2 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x5c2>
  709390:	48 8d 0c d1          	lea    (%rcx,%rdx,8),%rcx
  709394:	48 83 c1 08          	add    $0x8,%rcx
  709398:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  70939d:	48 89 ef             	mov    %rbp,%rdi
  7093a0:	ff d0                	call   *%rax
  7093a2:	49 8b 75 08          	mov    0x8(%r13),%rsi
  7093a6:	48 85 f6             	test   %rsi,%rsi
  7093a9:	74 0d                	je     7093b8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x5d8>
  7093ab:	49 8b 55 10          	mov    0x10(%r13),%rdx
  7093af:	48 89 ef             	mov    %rbp,%rdi
  7093b2:	ff 15 00 00 42 00    	call   *0x420000(%rip)        # b293b8 <_DYNAMIC+0x248>
  7093b8:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  7093bd:	49 89 44 24 08       	mov    %rax,0x8(%r12)
  7093c2:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  7093c7:	49 89 44 24 10       	mov    %rax,0x10(%r12)
  7093cc:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  7093d1:	8d b8 00 00 03 00    	lea    0x30000(%rax),%edi
  7093d7:	ff 15 8b 02 42 00    	call   *0x42028b(%rip)        # b29668 <_DYNAMIC+0x4f8>
  7093dd:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  7093e2:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
  7093e7:	49 8d 7f fb          	lea    -0x5(%r15),%rdi
  7093eb:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  7093f2:	48 39 f7             	cmp    %rsi,%rdi
  7093f5:	0f 83 e3 04 00 00    	jae    7098de <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0xafe>
  7093fb:	49 8b 8e 98 02 00 00 	mov    0x298(%r14),%rcx
  709402:	48 8d 14 bf          	lea    (%rdi,%rdi,4),%rdx
  709406:	4c 8d 24 d1          	lea    (%rcx,%rdx,8),%r12
  70940a:	48 8b 6c d1 08       	mov    0x8(%rcx,%rdx,8),%rbp
  70940f:	48 85 ed             	test   %rbp,%rbp
  709412:	74 36                	je     70944a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x66a>
  709414:	4c 8b 6c d1 10       	mov    0x10(%rcx,%rdx,8),%r13
  709419:	49 8b 45 00          	mov    0x0(%r13),%rax
  70941d:	48 85 c0             	test   %rax,%rax
  709420:	74 12                	je     709434 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x654>
  709422:	48 8d 0c d1          	lea    (%rcx,%rdx,8),%rcx
  709426:	48 83 c1 08          	add    $0x8,%rcx
  70942a:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  70942f:	48 89 ef             	mov    %rbp,%rdi
  709432:	ff d0                	call   *%rax
  709434:	49 8b 75 08          	mov    0x8(%r13),%rsi
  709438:	48 85 f6             	test   %rsi,%rsi
  70943b:	74 0d                	je     70944a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x66a>
  70943d:	49 8b 55 10          	mov    0x10(%r13),%rdx
  709441:	48 89 ef             	mov    %rbp,%rdi
  709444:	ff 15 6e ff 41 00    	call   *0x41ff6e(%rip)        # b293b8 <_DYNAMIC+0x248>
  70944a:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  70944f:	49 89 44 24 08       	mov    %rax,0x8(%r12)
  709454:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  709459:	49 89 44 24 10       	mov    %rax,0x10(%r12)
  70945e:	48 8b 7c 24 18       	mov    0x18(%rsp),%rdi
  709463:	81 cf 00 00 04 00    	or     $0x40000,%edi
  709469:	ff 15 f9 01 42 00    	call   *0x4201f9(%rip)        # b29668 <_DYNAMIC+0x4f8>
  70946f:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  709474:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
  709479:	49 83 c7 fc          	add    $0xfffffffffffffffc,%r15
  70947d:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  709484:	49 39 f7             	cmp    %rsi,%r15
  709487:	0f 83 4e 04 00 00    	jae    7098db <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0xafb>
  70948d:	49 8b 8e 98 02 00 00 	mov    0x298(%r14),%rcx
  709494:	4b 8d 14 bf          	lea    (%r15,%r15,4),%rdx
  709498:	4c 8d 24 d1          	lea    (%rcx,%rdx,8),%r12
  70949c:	48 8b 6c d1 08       	mov    0x8(%rcx,%rdx,8),%rbp
  7094a1:	48 85 ed             	test   %rbp,%rbp
  7094a4:	74 36                	je     7094dc <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x6fc>
  7094a6:	4c 8b 6c d1 10       	mov    0x10(%rcx,%rdx,8),%r13
  7094ab:	49 8b 45 00          	mov    0x0(%r13),%rax
  7094af:	48 85 c0             	test   %rax,%rax
  7094b2:	74 12                	je     7094c6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x6e6>
  7094b4:	48 8d 0c d1          	lea    (%rcx,%rdx,8),%rcx
  7094b8:	48 83 c1 08          	add    $0x8,%rcx
  7094bc:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  7094c1:	48 89 ef             	mov    %rbp,%rdi
  7094c4:	ff d0                	call   *%rax
  7094c6:	49 8b 75 08          	mov    0x8(%r13),%rsi
  7094ca:	48 85 f6             	test   %rsi,%rsi
  7094cd:	74 0d                	je     7094dc <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x6fc>
  7094cf:	49 8b 55 10          	mov    0x10(%r13),%rdx
  7094d3:	48 89 ef             	mov    %rbp,%rdi
  7094d6:	ff 15 dc fe 41 00    	call   *0x41fedc(%rip)        # b293b8 <_DYNAMIC+0x248>
  7094dc:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  7094e1:	49 89 44 24 08       	mov    %rax,0x8(%r12)
  7094e6:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  7094eb:	49 89 44 24 10       	mov    %rax,0x10(%r12)
  7094f0:	48 8b 54 24 60       	mov    0x60(%rsp),%rdx
  7094f5:	49 89 96 60 06 00 00 	mov    %rdx,0x660(%r14)
  7094fc:	49 ff 86 b0 06 00 00 	incq   0x6b0(%r14)
  709503:	49 c7 86 08 07 00 00 	movq   $0x0,0x708(%r14)
  70950a:	00 00 00 00 
  70950e:	41 c6 86 1f 08 00 00 	movb   $0x1,0x81f(%r14)
  709515:	01 
  709516:	48 89 df             	mov    %rbx,%rdi
  709519:	4c 89 f6             	mov    %r14,%rsi
  70951c:	48 81 c4 28 01 00 00 	add    $0x128,%rsp
  709523:	5b                   	pop    %rbx
  709524:	41 5c                	pop    %r12
  709526:	41 5d                	pop    %r13
  709528:	41 5e                	pop    %r14
  70952a:	41 5f                	pop    %r15
  70952c:	5d                   	pop    %rbp
  70952d:	e9 be 17 01 00       	jmp    71acf0 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::present>
  709532:	31 c9                	xor    %ecx,%ecx
  709534:	49 8b b6 08 07 00 00 	mov    0x708(%r14),%rsi
  70953b:	48 89 4b 08          	mov    %rcx,0x8(%rbx)
  70953f:	48 89 53 10          	mov    %rdx,0x10(%rbx)
  709543:	0f 11 43 18          	movups %xmm0,0x18(%rbx)
  709547:	48 89 73 28          	mov    %rsi,0x28(%rbx)
  70954b:	88 43 30             	mov    %al,0x30(%rbx)
  70954e:	48 c7 03 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rbx)
  709555:	48 8d 7c 24 68       	lea    0x68(%rsp),%rdi
  70955a:	e8 91 ea fe ff       	call   6f7ff0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70955f:	e9 11 f9 ff ff       	jmp    708e75 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x95>
  709564:	48 8b 8c 24 f0 00 00 	mov    0xf0(%rsp),%rcx
  70956b:	00 
  70956c:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  709573:	00 
  709574:	0f 10 84 24 d0 00 00 	movups 0xd0(%rsp),%xmm0
  70957b:	00 
  70957c:	0f 10 8c 24 e0 00 00 	movups 0xe0(%rsp),%xmm1
  709583:	00 
  709584:	0f 11 8c 24 88 00 00 	movups %xmm1,0x88(%rsp)
  70958b:	00 
  70958c:	0f 11 44 24 78       	movups %xmm0,0x78(%rsp)
  709591:	48 89 44 24 68       	mov    %rax,0x68(%rsp)
  709596:	4c 89 64 24 70       	mov    %r12,0x70(%rsp)
  70959b:	48 83 f8 11          	cmp    $0x11,%rax
  70959f:	0f 84 49 fb ff ff    	je     7090ee <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x30e>
  7095a5:	eb 2d                	jmp    7095d4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x7f4>
  7095a7:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  7095ac:	48 89 84 24 98 00 00 	mov    %rax,0x98(%rsp)
  7095b3:	00 
  7095b4:	0f 10 44 24 38       	movups 0x38(%rsp),%xmm0
  7095b9:	0f 10 4c 24 48       	movups 0x48(%rsp),%xmm1
  7095be:	0f 11 8c 24 88 00 00 	movups %xmm1,0x88(%rsp)
  7095c5:	00 
  7095c6:	0f 11 44 24 78       	movups %xmm0,0x78(%rsp)
  7095cb:	48 c7 44 24 68 1a 00 	movq   $0x1a,0x68(%rsp)
  7095d2:	00 00 
  7095d4:	48 8b 84 24 98 00 00 	mov    0x98(%rsp),%rax
  7095db:	00 
  7095dc:	48 89 43 30          	mov    %rax,0x30(%rbx)
  7095e0:	48 8b 44 24 68       	mov    0x68(%rsp),%rax
  7095e5:	48 8b 4c 24 70       	mov    0x70(%rsp),%rcx
  7095ea:	0f 10 44 24 78       	movups 0x78(%rsp),%xmm0
  7095ef:	0f 10 8c 24 88 00 00 	movups 0x88(%rsp),%xmm1
  7095f6:	00 
  7095f7:	0f 11 4b 20          	movups %xmm1,0x20(%rbx)
  7095fb:	0f 11 43 10          	movups %xmm0,0x10(%rbx)
  7095ff:	48 89 03             	mov    %rax,(%rbx)
  709602:	48 89 4b 08          	mov    %rcx,0x8(%rbx)
  709606:	e9 6a f8 ff ff       	jmp    708e75 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x95>
  70960b:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  709612:	49 39 f4             	cmp    %rsi,%r12
  709615:	0f 83 eb 02 00 00    	jae    709906 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0xb26>
  70961b:	49 8b 86 98 02 00 00 	mov    0x298(%r14),%rax
  709622:	4b 8d 0c a4          	lea    (%r12,%r12,4),%rcx
  709626:	44 8b 7c c8 18       	mov    0x18(%rax,%rcx,8),%r15d
  70962b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  709630:	49 39 c7             	cmp    %rax,%r15
  709633:	0f 84 2c f8 ff ff    	je     708e65 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x85>
  709639:	48 c7 44 24 28 11 00 	movq   $0x11,0x28(%rsp)
  709640:	00 00 
  709642:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  709647:	e8 a4 e9 fe ff       	call   6f7ff0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70964c:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  709653:	4c 39 fe             	cmp    %r15,%rsi
  709656:	0f 86 ba 02 00 00    	jbe    709916 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0xb36>
  70965c:	49 8d be b0 05 00 00 	lea    0x5b0(%r14),%rdi
  709663:	49 8b 86 98 02 00 00 	mov    0x298(%r14),%rax
  70966a:	4b 8d 0c bf          	lea    (%r15,%r15,4),%rcx
  70966e:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
  709672:	ff 15 f8 ff 41 00    	call   *0x41fff8(%rip)        # b29670 <_DYNAMIC+0x500>
  709678:	49 89 c7             	mov    %rax,%r15
  70967b:	49 89 d4             	mov    %rdx,%r12
  70967e:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  709683:	4c 89 f6             	mov    %r14,%rsi
  709686:	48 89 c2             	mov    %rax,%rdx
  709689:	4c 89 e1             	mov    %r12,%rcx
  70968c:	e8 1f df ff ff       	call   7075b0 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::inspector_app_index>
  709691:	83 7c 24 28 fe       	cmpl   $0xfffffffe,0x28(%rsp)
  709696:	75 5f                	jne    7096f7 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x917>
  709698:	48 89 df             	mov    %rbx,%rdi
  70969b:	4c 89 f6             	mov    %r14,%rsi
  70969e:	4c 89 fa             	mov    %r15,%rdx
  7096a1:	4c 89 e1             	mov    %r12,%rcx
  7096a4:	48 81 c4 28 01 00 00 	add    $0x128,%rsp
  7096ab:	5b                   	pop    %rbx
  7096ac:	41 5c                	pop    %r12
  7096ae:	41 5d                	pop    %r13
  7096b0:	41 5e                	pop    %r14
  7096b2:	41 5f                	pop    %r15
  7096b4:	5d                   	pop    %rbp
  7096b5:	e9 e6 02 00 00       	jmp    7099a0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::inspector_select>
  7096ba:	8b 4c 24 5c          	mov    0x5c(%rsp),%ecx
  7096be:	89 4b 34             	mov    %ecx,0x34(%rbx)
  7096c1:	0f 10 44 24 4c       	movups 0x4c(%rsp),%xmm0
  7096c6:	0f 11 43 24          	movups %xmm0,0x24(%rbx)
  7096ca:	0f 10 84 24 cc 00 00 	movups 0xcc(%rsp),%xmm0
  7096d1:	00 
  7096d2:	0f 11 43 14          	movups %xmm0,0x14(%rbx)
  7096d6:	0f 28 84 24 c0 00 00 	movaps 0xc0(%rsp),%xmm0
  7096dd:	00 
  7096de:	0f 11 43 08          	movups %xmm0,0x8(%rbx)
  7096e2:	48 89 03             	mov    %rax,(%rbx)
  7096e5:	e9 8b f7 ff ff       	jmp    708e75 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x95>
  7096ea:	48 8d 3d 3f 1a 3f 00 	lea    0x3f1a3f(%rip),%rdi        # afb130 <__frame_dummy_init_array_entry+0x828>
  7096f1:	ff 15 81 fd 41 00    	call   *0x41fd81(%rip)        # b29478 <_DYNAMIC+0x308>
  7096f7:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  7096fc:	e8 ef e8 fe ff       	call   6f7ff0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  709701:	41 0f 10 86 60 06 00 	movups 0x660(%r14),%xmm0
  709708:	00 
  709709:	41 0f b6 86 20 08 00 	movzbl 0x820(%r14),%eax
  709710:	00 
  709711:	49 83 be 80 06 00 00 	cmpq   $0x0,0x680(%r14)
  709718:	00 
  709719:	74 1c                	je     709737 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x957>
  70971b:	84 c0                	test   %al,%al
  70971d:	74 0a                	je     709729 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x949>
  70971f:	49 83 be 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%r14)
  709726:	ff 
  709727:	74 0e                	je     709737 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x957>
  709729:	49 8b 96 90 06 00 00 	mov    0x690(%r14),%rdx
  709730:	b9 01 00 00 00       	mov    $0x1,%ecx
  709735:	eb 02                	jmp    709739 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x959>
  709737:	31 c9                	xor    %ecx,%ecx
  709739:	49 8b b6 08 07 00 00 	mov    0x708(%r14),%rsi
  709740:	48 89 4b 08          	mov    %rcx,0x8(%rbx)
  709744:	48 89 53 10          	mov    %rdx,0x10(%rbx)
  709748:	0f 11 43 18          	movups %xmm0,0x18(%rbx)
  70974c:	48 89 73 28          	mov    %rsi,0x28(%rbx)
  709750:	e9 f0 f9 ff ff       	jmp    709145 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x365>
  709755:	83 f8 23             	cmp    $0x23,%eax
  709758:	0f 85 eb 00 00 00    	jne    709849 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0xa69>
  70975e:	8b 44 24 30          	mov    0x30(%rsp),%eax
  709762:	83 f8 0d             	cmp    $0xd,%eax
  709765:	0f 84 12 01 00 00    	je     70987d <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0xa9d>
  70976b:	83 f8 0e             	cmp    $0xe,%eax
  70976e:	0f 85 d5 00 00 00    	jne    709849 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0xa69>
  709774:	ba 07 00 00 00       	mov    $0x7,%edx
  709779:	e9 04 01 00 00       	jmp    709882 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0xaa2>
  70977e:	c6 84 24 a0 00 00 00 	movb   $0x0,0xa0(%rsp)
  709785:	00 
  709786:	c7 84 24 a4 00 00 00 	movl   $0x0,0xa4(%rsp)
  70978d:	00 00 00 00 
  709791:	48 8d b4 24 a0 00 00 	lea    0xa0(%rsp),%rsi
  709798:	00 
  709799:	8b 7c 24 08          	mov    0x8(%rsp),%edi
  70979d:	ff 15 d5 fe 41 00    	call   *0x41fed5(%rip)        # b29678 <_DYNAMIC+0x508>
  7097a3:	66 85 c0             	test   %ax,%ax
  7097a6:	74 2a                	je     7097d2 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x9f2>
  7097a8:	48 c1 e8 10          	shr    $0x10,%rax
  7097ac:	48 89 df             	mov    %rbx,%rdi
  7097af:	4c 89 f6             	mov    %r14,%rsi
  7097b2:	89 c2                	mov    %eax,%edx
  7097b4:	48 81 c4 28 01 00 00 	add    $0x128,%rsp
  7097bb:	5b                   	pop    %rbx
  7097bc:	41 5c                	pop    %r12
  7097be:	41 5d                	pop    %r13
  7097c0:	41 5e                	pop    %r14
  7097c2:	41 5f                	pop    %r15
  7097c4:	5d                   	pop    %rbp
  7097c5:	e9 f6 f4 ff ff       	jmp    708cc0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::reject_editor>
  7097ca:	c6 84 24 a0 00 00 00 	movb   $0xff,0xa0(%rsp)
  7097d1:	ff 
  7097d2:	4d 8b be 60 06 00 00 	mov    0x660(%r14),%r15
  7097d9:	49 83 ff ff          	cmp    $0xffffffffffffffff,%r15
  7097dd:	0f 84 8e 00 00 00    	je     709871 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0xa91>
  7097e3:	48 c7 44 24 28 1f 00 	movq   $0x1f,0x28(%rsp)
  7097ea:	00 00 
  7097ec:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  7097f1:	e8 fa e7 fe ff       	call   6f7ff0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  7097f6:	49 8b 86 10 06 00 00 	mov    0x610(%r14),%rax
  7097fd:	48 85 c0             	test   %rax,%rax
  709800:	0f 84 af 00 00 00    	je     7098b5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0xad5>
  709806:	48 8b 80 d8 00 00 00 	mov    0xd8(%rax),%rax
  70980d:	48 85 c0             	test   %rax,%rax
  709810:	0f 84 9f 00 00 00    	je     7098b5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0xad5>
  709816:	49 ff c7             	inc    %r15
  709819:	c6 40 13 ff          	movb   $0xff,0x13(%rax)
  70981d:	48 8d 84 24 a0 00 00 	lea    0xa0(%rsp),%rax
  709824:	00 
  709825:	48 89 04 24          	mov    %rax,(%rsp)
  709829:	48 89 df             	mov    %rbx,%rdi
  70982c:	4c 89 f6             	mov    %r14,%rsi
  70982f:	48 8b 54 24 60       	mov    0x60(%rsp),%rdx
  709834:	4c 89 e1             	mov    %r12,%rcx
  709837:	4d 89 f8             	mov    %r15,%r8
  70983a:	44 8b 4c 24 08       	mov    0x8(%rsp),%r9d
  70983f:	e8 2c 06 02 00       	call   729e70 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at>
  709844:	e9 2c f6 ff ff       	jmp    708e75 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x95>
  709849:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  70984e:	48 89 43 30          	mov    %rax,0x30(%rbx)
  709852:	0f 10 44 24 28       	movups 0x28(%rsp),%xmm0
  709857:	0f 10 4c 24 38       	movups 0x38(%rsp),%xmm1
  70985c:	0f 10 54 24 48       	movups 0x48(%rsp),%xmm2
  709861:	0f 11 53 20          	movups %xmm2,0x20(%rbx)
  709865:	0f 11 4b 10          	movups %xmm1,0x10(%rbx)
  709869:	0f 11 03             	movups %xmm0,(%rbx)
  70986c:	e9 04 f6 ff ff       	jmp    708e75 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x95>
  709871:	48 c7 03 1f 00 00 00 	movq   $0x1f,(%rbx)
  709878:	e9 f8 f5 ff ff       	jmp    708e75 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x95>
  70987d:	ba 06 00 00 00       	mov    $0x6,%edx
  709882:	48 89 df             	mov    %rbx,%rdi
  709885:	4c 89 f6             	mov    %r14,%rsi
  709888:	e8 33 f4 ff ff       	call   708cc0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::reject_editor>
  70988d:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  709892:	e8 59 e7 fe ff       	call   6f7ff0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  709897:	e9 d9 f5 ff ff       	jmp    708e75 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0x95>
  70989c:	48 8d 3d f1 0c 96 ff 	lea    -0x69f30f(%rip),%rdi        # 6a594 <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x32a7>
  7098a3:	48 8d 15 fe 18 3f 00 	lea    0x3f18fe(%rip),%rdx        # afb1a8 <__frame_dummy_init_array_entry+0x8a0>
  7098aa:	be 28 00 00 00       	mov    $0x28,%esi
  7098af:	ff 15 cb fd 41 00    	call   *0x41fdcb(%rip)        # b29680 <_DYNAMIC+0x510>
  7098b5:	48 8d 3d 19 0d 96 ff 	lea    -0x69f2e7(%rip),%rdi        # 6a5d5 <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x32e8>
  7098bc:	48 8d 15 f5 17 3f 00 	lea    0x3f17f5(%rip),%rdx        # afb0b8 <__frame_dummy_init_array_entry+0x7b0>
  7098c3:	be 11 00 00 00       	mov    $0x11,%esi
  7098c8:	ff 15 ea fb 41 00    	call   *0x41fbea(%rip)        # b294b8 <_DYNAMIC+0x348>
  7098ce:	48 8d 3d 73 18 3f 00 	lea    0x3f1873(%rip),%rdi        # afb148 <__frame_dummy_init_array_entry+0x840>
  7098d5:	ff 15 9d fb 41 00    	call   *0x41fb9d(%rip)        # b29478 <_DYNAMIC+0x308>
  7098db:	4c 89 ff             	mov    %r15,%rdi
  7098de:	48 8d 15 7b 18 3f 00 	lea    0x3f187b(%rip),%rdx        # afb160 <__frame_dummy_init_array_entry+0x858>
  7098e5:	ff 15 dd fb 41 00    	call   *0x41fbdd(%rip)        # b294c8 <_DYNAMIC+0x358>
  7098eb:	0f 0b                	ud2
  7098ed:	48 8d 3d a0 0c 96 ff 	lea    -0x69f360(%rip),%rdi        # 6a594 <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x32a7>
  7098f4:	48 8d 15 c5 18 3f 00 	lea    0x3f18c5(%rip),%rdx        # afb1c0 <__frame_dummy_init_array_entry+0x8b8>
  7098fb:	be 28 00 00 00       	mov    $0x28,%esi
  709900:	ff 15 7a fd 41 00    	call   *0x41fd7a(%rip)        # b29680 <_DYNAMIC+0x510>
  709906:	48 8d 15 6b 18 3f 00 	lea    0x3f186b(%rip),%rdx        # afb178 <__frame_dummy_init_array_entry+0x870>
  70990d:	4c 89 e7             	mov    %r12,%rdi
  709910:	ff 15 b2 fb 41 00    	call   *0x41fbb2(%rip)        # b294c8 <_DYNAMIC+0x358>
  709916:	48 8d 15 73 18 3f 00 	lea    0x3f1873(%rip),%rdx        # afb190 <__frame_dummy_init_array_entry+0x888>
  70991d:	4c 89 ff             	mov    %r15,%rdi
  709920:	ff 15 a2 fb 41 00    	call   *0x41fba2(%rip)        # b294c8 <_DYNAMIC+0x358>
  709926:	48 89 c3             	mov    %rax,%rbx
  709929:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  70992e:	e8 bd e6 fe ff       	call   6f7ff0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  709933:	48 89 df             	mov    %rbx,%rdi
  709936:	e8 15 fc 3e 00       	call   af9550 <_Unwind_Resume@plt>
  70993b:	4c 8b 74 24 20       	mov    0x20(%rsp),%r14
  709940:	48 89 c3             	mov    %rax,%rbx
  709943:	49 8b 75 08          	mov    0x8(%r13),%rsi
  709947:	48 85 f6             	test   %rsi,%rsi
  70994a:	74 0d                	je     709959 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action+0xb79>
  70994c:	49 8b 55 10          	mov    0x10(%r13),%rdx
  709950:	48 89 ef             	mov    %rbp,%rdi
  709953:	ff 15 5f fa 41 00    	call   *0x41fa5f(%rip)        # b293b8 <_DYNAMIC+0x248>
  709959:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  70995e:	49 89 06             	mov    %rax,(%r14)
  709961:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  709966:	49 89 44 24 10       	mov    %rax,0x10(%r12)
  70996b:	48 89 df             	mov    %rbx,%rdi
  70996e:	e8 dd fb 3e 00       	call   af9550 <_Unwind_Resume@plt>
  709973:	48 89 c3             	mov    %rax,%rbx
  709976:	48 8b 7c 24 10       	mov    0x10(%rsp),%rdi
  70997b:	48 8b 74 24 08       	mov    0x8(%rsp),%rsi
  709980:	e8 eb af fe ff       	call   6f4970 <core::ptr::drop_glue::<core::option::Option<gpui::element::Handler>>>
  709985:	48 89 df             	mov    %rbx,%rdi
  709988:	e8 c3 fb 3e 00       	call   af9550 <_Unwind_Resume@plt>
  70998d:	ff 15 55 fa 41 00    	call   *0x41fa55(%rip)        # b293e8 <_DYNAMIC+0x278>
