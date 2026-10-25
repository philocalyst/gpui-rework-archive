
/tmp/gpui-contained-owner-unit-baseline-target/release/deps/unit_action_cost-bcf457ce7db1ee75:     file format elf64-x86-64


Disassembly of section .text:

000000000070d8e0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action>:
  70d8e0:	55                   	push   %rbp
  70d8e1:	41 57                	push   %r15
  70d8e3:	41 56                	push   %r14
  70d8e5:	41 55                	push   %r13
  70d8e7:	41 54                	push   %r12
  70d8e9:	53                   	push   %rbx
  70d8ea:	48 81 ec 28 01 00 00 	sub    $0x128,%rsp
  70d8f1:	48 89 fb             	mov    %rdi,%rbx
  70d8f4:	80 be 22 07 00 00 00 	cmpb   $0x0,0x722(%rsi)
  70d8fb:	74 09                	je     70d906 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x26>
  70d8fd:	48 c7 03 0e 00 00 00 	movq   $0xe,(%rbx)
  70d904:	eb 6f                	jmp    70d975 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x95>
  70d906:	49 89 f6             	mov    %rsi,%r14
  70d909:	48 8b 86 10 06 00 00 	mov    0x610(%rsi),%rax
  70d910:	48 85 c0             	test   %rax,%rax
  70d913:	74 59                	je     70d96e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x8e>
  70d915:	48 83 b8 d8 00 00 00 	cmpq   $0x0,0xd8(%rax)
  70d91c:	00 
  70d91d:	74 4f                	je     70d96e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x8e>
  70d91f:	49 c7 86 08 07 00 00 	movq   $0x0,0x708(%r14)
  70d926:	00 00 00 00 
  70d92a:	48 8b a8 d8 00 00 00 	mov    0xd8(%rax),%rbp
  70d931:	48 85 ed             	test   %rbp,%rbp
  70d934:	0f 84 b0 08 00 00    	je     70e1ea <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x90a>
  70d93a:	44 0f b7 65 10       	movzwl 0x10(%rbp),%r12d
  70d93f:	0f b6 7d 16          	movzbl 0x16(%rbp),%edi
  70d943:	44 0f b6 45 12       	movzbl 0x12(%rbp),%r8d
  70d948:	89 c8                	mov    %ecx,%eax
  70d94a:	66 83 e8 0e          	sub    $0xe,%ax
  70d94e:	41 bf 03 00 00 00    	mov    $0x3,%r15d
  70d954:	44 0f 43 f8          	cmovae %eax,%r15d
  70d958:	66 41 83 ff 03       	cmp    $0x3,%r15w
  70d95d:	75 28                	jne    70d987 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0xa7>
  70d95f:	66 41 39 cc          	cmp    %cx,%r12w
  70d963:	74 22                	je     70d987 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0xa7>
  70d965:	48 c7 03 11 00 00 00 	movq   $0x11,(%rbx)
  70d96c:	eb 07                	jmp    70d975 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x95>
  70d96e:	48 c7 03 1a 00 00 00 	movq   $0x1a,(%rbx)
  70d975:	48 81 c4 28 01 00 00 	add    $0x128,%rsp
  70d97c:	5b                   	pop    %rbx
  70d97d:	41 5c                	pop    %r12
  70d97f:	41 5d                	pop    %r13
  70d981:	41 5e                	pop    %r14
  70d983:	41 5f                	pop    %r15
  70d985:	5d                   	pop    %rbp
  70d986:	c3                   	ret
  70d987:	41 89 cd             	mov    %ecx,%r13d
  70d98a:	41 c1 ed 10          	shr    $0x10,%r13d
  70d98e:	45 0f b7 cf          	movzwl %r15w,%r9d
  70d992:	48 8d 05 ff 8c 95 ff 	lea    -0x6a7301(%rip),%rax        # 66698 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x8>
  70d999:	4a 63 34 88          	movslq (%rax,%r9,4),%rsi
  70d99d:	48 01 c6             	add    %rax,%rsi
  70d9a0:	ff e6                	jmp    *%rsi
  70d9a2:	44 0f b7 ff          	movzwl %di,%r15d
  70d9a6:	41 81 cf 00 01 00 00 	or     $0x100,%r15d
  70d9ad:	eb 12                	jmp    70d9c1 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0xe1>
  70d9af:	45 0f b7 f8          	movzwl %r8w,%r15d
  70d9b3:	41 c1 e7 08          	shl    $0x8,%r15d
  70d9b7:	66 45 39 e5          	cmp    %r12w,%r13w
  70d9bb:	0f 85 f3 02 00 00    	jne    70dcb4 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x3d4>
  70d9c1:	b0 01                	mov    $0x1,%al
  70d9c3:	44 38 ff             	cmp    %r15b,%dil
  70d9c6:	0f 85 ed 02 00 00    	jne    70dcb9 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x3d9>
  70d9cc:	41 0f b7 cf          	movzwl %r15w,%ecx
  70d9d0:	c1 e9 08             	shr    $0x8,%ecx
  70d9d3:	41 38 c8             	cmp    %cl,%r8b
  70d9d6:	0f 85 dd 02 00 00    	jne    70dcb9 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x3d9>
  70d9dc:	80 7d 13 ff          	cmpb   $0xff,0x13(%rbp)
  70d9e0:	0f 85 d3 02 00 00    	jne    70dcb9 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x3d9>
  70d9e6:	e9 c4 01 00 00       	jmp    70dbaf <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x2cf>
  70d9eb:	f7 c1 00 00 ff 00    	test   $0xff0000,%ecx
  70d9f1:	0f 84 5d 02 00 00    	je     70dc54 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x374>
  70d9f7:	48 8b 45 00          	mov    0x0(%rbp),%rax
  70d9fb:	48 85 c0             	test   %rax,%rax
  70d9fe:	0f 84 ab 01 00 00    	je     70dbaf <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x2cf>
  70da04:	49 3b 86 b0 05 00 00 	cmp    0x5b0(%r14),%rax
  70da0b:	0f 85 d4 01 00 00    	jne    70dbe5 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x305>
  70da11:	4c 89 4c 24 18       	mov    %r9,0x18(%rsp)
  70da16:	48 89 7c 24 10       	mov    %rdi,0x10(%rsp)
  70da1b:	48 89 54 24 60       	mov    %rdx,0x60(%rsp)
  70da20:	89 4c 24 08          	mov    %ecx,0x8(%rsp)
  70da24:	4c 8b 65 08          	mov    0x8(%rbp),%r12
  70da28:	48 c7 44 24 28 11 00 	movq   $0x11,0x28(%rsp)
  70da2f:	00 00 
  70da31:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  70da36:	e8 35 69 ff ff       	call   704370 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70da3b:	48 8d bc 24 c0 00 00 	lea    0xc0(%rsp),%rdi
  70da42:	00 
  70da43:	4c 89 f6             	mov    %r14,%rsi
  70da46:	4c 89 e2             	mov    %r12,%rdx
  70da49:	e8 32 f8 00 00       	call   71d280 <<gpui::runtime::Runtime<unit_action_cost::Model>>::resolve_identity>
  70da4e:	48 8b 84 24 c0 00 00 	mov    0xc0(%rsp),%rax
  70da55:	00 
  70da56:	4c 8b a4 24 c8 00 00 	mov    0xc8(%rsp),%r12
  70da5d:	00 
  70da5e:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  70da62:	0f 85 fc 05 00 00    	jne    70e064 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x784>
  70da68:	49 8b 86 10 06 00 00 	mov    0x610(%r14),%rax
  70da6f:	48 85 c0             	test   %rax,%rax
  70da72:	0f 84 2f 06 00 00    	je     70e0a7 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x7c7>
  70da78:	48 83 b8 d8 00 00 00 	cmpq   $0x0,0xd8(%rax)
  70da7f:	00 
  70da80:	0f 84 21 06 00 00    	je     70e0a7 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x7c7>
  70da86:	49 8b ae a0 02 00 00 	mov    0x2a0(%r14),%rbp
  70da8d:	48 c7 44 24 28 1a 00 	movq   $0x1a,0x28(%rsp)
  70da94:	00 00 
  70da96:	48 83 fd 1c          	cmp    $0x1c,%rbp
  70da9a:	0f 82 07 06 00 00    	jb     70e0a7 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x7c7>
  70daa0:	48 83 c5 e4          	add    $0xffffffffffffffe4,%rbp
  70daa4:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  70daa9:	e8 c2 68 ff ff       	call   704370 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70daae:	49 83 fc 02          	cmp    $0x2,%r12
  70dab2:	0f 93 c0             	setae  %al
  70dab5:	49 39 ec             	cmp    %rbp,%r12
  70dab8:	0f 92 c1             	setb   %cl
  70dabb:	84 c8                	test   %cl,%al
  70dabd:	0f 84 22 01 00 00    	je     70dbe5 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x305>
  70dac3:	66 41 83 ff 01       	cmp    $0x1,%r15w
  70dac8:	0f 84 3d 06 00 00    	je     70e10b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x82b>
  70dace:	83 7c 24 18 03       	cmpl   $0x3,0x18(%rsp)
  70dad3:	0f 85 c3 08 00 00    	jne    70e39c <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0xabc>
  70dad9:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  70dade:	4c 89 f6             	mov    %r14,%rsi
  70dae1:	4c 89 e2             	mov    %r12,%rdx
  70dae4:	8b 4c 24 08          	mov    0x8(%rsp),%ecx
  70dae8:	e8 03 04 01 00       	call   71def0 <<gpui::runtime::Runtime<unit_action_cost::Model>>::property_value_at>
  70daed:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  70daf2:	0f 10 44 24 30       	movups 0x30(%rsp),%xmm0
  70daf7:	0f 29 84 24 c0 00 00 	movaps %xmm0,0xc0(%rsp)
  70dafe:	00 
  70daff:	0f 10 44 24 3c       	movups 0x3c(%rsp),%xmm0
  70db04:	0f 11 84 24 cc 00 00 	movups %xmm0,0xcc(%rsp)
  70db0b:	00 
  70db0c:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  70db10:	0f 85 a4 06 00 00    	jne    70e1ba <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x8da>
  70db16:	0f 28 84 24 c0 00 00 	movaps 0xc0(%rsp),%xmm0
  70db1d:	00 
  70db1e:	0f 29 84 24 00 01 00 	movaps %xmm0,0x100(%rsp)
  70db25:	00 
  70db26:	0f 10 84 24 cc 00 00 	movups 0xcc(%rsp),%xmm0
  70db2d:	00 
  70db2e:	0f 11 84 24 0c 01 00 	movups %xmm0,0x10c(%rsp)
  70db35:	00 
  70db36:	41 0f b6 c5          	movzbl %r13b,%eax
  70db3a:	48 8d 0d 67 8b 95 ff 	lea    -0x6a7499(%rip),%rcx        # 666a8 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x18>
  70db41:	48 63 04 81          	movslq (%rcx,%rax,4),%rax
  70db45:	48 01 c8             	add    %rcx,%rax
  70db48:	ff e0                	jmp    *%rax
  70db4a:	8b 44 24 08          	mov    0x8(%rsp),%eax
  70db4e:	25 00 00 ff 00       	and    $0xff0000,%eax
  70db53:	31 c9                	xor    %ecx,%ecx
  70db55:	3d 00 00 02 00       	cmp    $0x20000,%eax
  70db5a:	0f 94 c1             	sete   %cl
  70db5d:	48 8d 05 dc 88 95 ff 	lea    -0x6a7724(%rip),%rax        # 66440 <anon.079f5e587c394fcac2765eb4d0cf0bc2.21.llvm.6319143315422321905+0x30>
  70db64:	f3 0f 10 04 88       	movss  (%rax,%rcx,4),%xmm0
  70db69:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  70db6e:	48 8d b4 24 00 01 00 	lea    0x100(%rsp),%rsi
  70db75:	00 
  70db76:	48 8b 54 24 10       	mov    0x10(%rsp),%rdx
  70db7b:	ff 15 67 3a 3f 00    	call   *0x3f3a67(%rip)        # b015e8 <_DYNAMIC+0x4f8>
  70db81:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  70db86:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  70db8a:	0f 85 c5 06 00 00    	jne    70e255 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x975>
  70db90:	0f 10 44 24 30       	movups 0x30(%rsp),%xmm0
  70db95:	0f 10 4c 24 3c       	movups 0x3c(%rsp),%xmm1
  70db9a:	0f 11 8c 24 ac 00 00 	movups %xmm1,0xac(%rsp)
  70dba1:	00 
  70dba2:	0f 29 84 24 a0 00 00 	movaps %xmm0,0xa0(%rsp)
  70dba9:	00 
  70dbaa:	e9 e2 06 00 00       	jmp    70e291 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x9b1>
  70dbaf:	41 0f 10 86 60 06 00 	movups 0x660(%r14),%xmm0
  70dbb6:	00 
  70dbb7:	41 0f b6 86 20 07 00 	movzbl 0x720(%r14),%eax
  70dbbe:	00 
  70dbbf:	49 83 be 80 06 00 00 	cmpq   $0x0,0x680(%r14)
  70dbc6:	00 
  70dbc7:	74 66                	je     70dc2f <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x34f>
  70dbc9:	84 c0                	test   %al,%al
  70dbcb:	74 0a                	je     70dbd7 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x2f7>
  70dbcd:	49 83 be 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%r14)
  70dbd4:	ff 
  70dbd5:	74 58                	je     70dc2f <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x34f>
  70dbd7:	49 8b 96 90 06 00 00 	mov    0x690(%r14),%rdx
  70dbde:	b9 01 00 00 00       	mov    $0x1,%ecx
  70dbe3:	eb 4c                	jmp    70dc31 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x351>
  70dbe5:	48 c7 44 24 68 11 00 	movq   $0x11,0x68(%rsp)
  70dbec:	00 00 
  70dbee:	41 0f 10 86 60 06 00 	movups 0x660(%r14),%xmm0
  70dbf5:	00 
  70dbf6:	41 0f b6 86 20 07 00 	movzbl 0x720(%r14),%eax
  70dbfd:	00 
  70dbfe:	49 83 be 80 06 00 00 	cmpq   $0x0,0x680(%r14)
  70dc05:	00 
  70dc06:	0f 84 26 04 00 00    	je     70e032 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x752>
  70dc0c:	84 c0                	test   %al,%al
  70dc0e:	74 0e                	je     70dc1e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x33e>
  70dc10:	49 83 be 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%r14)
  70dc17:	ff 
  70dc18:	0f 84 14 04 00 00    	je     70e032 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x752>
  70dc1e:	49 8b 96 90 06 00 00 	mov    0x690(%r14),%rdx
  70dc25:	b9 01 00 00 00       	mov    $0x1,%ecx
  70dc2a:	e9 05 04 00 00       	jmp    70e034 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x754>
  70dc2f:	31 c9                	xor    %ecx,%ecx
  70dc31:	48 89 4b 08          	mov    %rcx,0x8(%rbx)
  70dc35:	48 89 53 10          	mov    %rdx,0x10(%rbx)
  70dc39:	0f 11 43 18          	movups %xmm0,0x18(%rbx)
  70dc3d:	48 c7 43 28 00 00 00 	movq   $0x0,0x28(%rbx)
  70dc44:	00 
  70dc45:	88 43 30             	mov    %al,0x30(%rbx)
  70dc48:	48 c7 03 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rbx)
  70dc4f:	e9 21 fd ff ff       	jmp    70d975 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x95>
  70dc54:	45 0f b7 f8          	movzwl %r8w,%r15d
  70dc58:	8d 47 01             	lea    0x1(%rdi),%eax
  70dc5b:	89 44 24 18          	mov    %eax,0x18(%rsp)
  70dc5f:	48 89 7c 24 10       	mov    %rdi,0x10(%rsp)
  70dc64:	89 cf                	mov    %ecx,%edi
  70dc66:	89 4c 24 08          	mov    %ecx,0x8(%rsp)
  70dc6a:	45 89 c5             	mov    %r8d,%r13d
  70dc6d:	e8 ce da ff ff       	call   70b740 <<gpui::property::PropertyId>::info>
  70dc72:	45 89 e8             	mov    %r13d,%r8d
  70dc75:	48 8b 7c 24 10       	mov    0x10(%rsp),%rdi
  70dc7a:	44 8b 6c 24 08       	mov    0x8(%rsp),%r13d
  70dc7f:	0f b6 40 14          	movzbl 0x14(%rax),%eax
  70dc83:	31 c9                	xor    %ecx,%ecx
  70dc85:	3c 04                	cmp    $0x4,%al
  70dc87:	0f 94 c1             	sete   %cl
  70dc8a:	8d 0c 89             	lea    (%rcx,%rcx,4),%ecx
  70dc8d:	ff c1                	inc    %ecx
  70dc8f:	3c 02                	cmp    $0x2,%al
  70dc91:	ba 04 00 00 00       	mov    $0x4,%edx
  70dc96:	0f 45 d1             	cmovne %ecx,%edx
  70dc99:	0f b6 44 24 18       	movzbl 0x18(%rsp),%eax
  70dc9e:	f6 f2                	div    %dl
  70dca0:	0f b6 c4             	movzbl %ah,%eax
  70dca3:	41 c1 e7 08          	shl    $0x8,%r15d
  70dca7:	41 09 c7             	or     %eax,%r15d
  70dcaa:	66 45 39 e5          	cmp    %r12w,%r13w
  70dcae:	0f 84 0d fd ff ff    	je     70d9c1 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0xe1>
  70dcb4:	31 c0                	xor    %eax,%eax
  70dcb6:	45 89 ec             	mov    %r13d,%r12d
  70dcb9:	49 8b 96 60 06 00 00 	mov    0x660(%r14),%rdx
  70dcc0:	48 ff c2             	inc    %rdx
  70dcc3:	0f 84 a8 06 00 00    	je     70e371 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0xa91>
  70dcc9:	41 0f b7 cf          	movzwl %r15w,%ecx
  70dccd:	66 44 89 65 10       	mov    %r12w,0x10(%rbp)
  70dcd2:	88 4d 16             	mov    %cl,0x16(%rbp)
  70dcd5:	88 6d 12             	mov    %ch,0x12(%rbp)
  70dcd8:	c6 45 13 ff          	movb   $0xff,0x13(%rbp)
  70dcdc:	84 c0                	test   %al,%al
  70dcde:	0f 85 11 03 00 00    	jne    70dff5 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x715>
  70dce4:	49 8b 86 10 06 00 00 	mov    0x610(%r14),%rax
  70dceb:	48 85 c0             	test   %rax,%rax
  70dcee:	0f 84 da 06 00 00    	je     70e3ce <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0xaee>
  70dcf4:	48 83 b8 d8 00 00 00 	cmpq   $0x0,0xd8(%rax)
  70dcfb:	00 
  70dcfc:	0f 84 cc 06 00 00    	je     70e3ce <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0xaee>
  70dd02:	4d 8b be a0 02 00 00 	mov    0x2a0(%r14),%r15
  70dd09:	49 83 ff 1c          	cmp    $0x1c,%r15
  70dd0d:	0f 82 bb 06 00 00    	jb     70e3ce <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0xaee>
  70dd13:	48 89 54 24 60       	mov    %rdx,0x60(%rsp)
  70dd18:	41 0f b7 fc          	movzwl %r12w,%edi
  70dd1c:	48 89 7c 24 18       	mov    %rdi,0x18(%rsp)
  70dd21:	ff 15 c9 38 3f 00    	call   *0x3f38c9(%rip)        # b015f0 <_DYNAMIC+0x500>
  70dd27:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  70dd2c:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
  70dd31:	49 8d 7f f7          	lea    -0x9(%r15),%rdi
  70dd35:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  70dd3c:	48 39 f7             	cmp    %rsi,%rdi
  70dd3f:	0f 83 99 06 00 00    	jae    70e3de <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0xafe>
  70dd45:	49 8b 8e 98 02 00 00 	mov    0x298(%r14),%rcx
  70dd4c:	48 8d 14 bf          	lea    (%rdi,%rdi,4),%rdx
  70dd50:	4c 8d 24 d1          	lea    (%rcx,%rdx,8),%r12
  70dd54:	48 8b 6c d1 08       	mov    0x8(%rcx,%rdx,8),%rbp
  70dd59:	48 85 ed             	test   %rbp,%rbp
  70dd5c:	74 36                	je     70dd94 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x4b4>
  70dd5e:	4c 8b 6c d1 10       	mov    0x10(%rcx,%rdx,8),%r13
  70dd63:	49 8b 45 00          	mov    0x0(%r13),%rax
  70dd67:	48 85 c0             	test   %rax,%rax
  70dd6a:	74 12                	je     70dd7e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x49e>
  70dd6c:	48 8d 0c d1          	lea    (%rcx,%rdx,8),%rcx
  70dd70:	48 83 c1 08          	add    $0x8,%rcx
  70dd74:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  70dd79:	48 89 ef             	mov    %rbp,%rdi
  70dd7c:	ff d0                	call   *%rax
  70dd7e:	49 8b 75 08          	mov    0x8(%r13),%rsi
  70dd82:	48 85 f6             	test   %rsi,%rsi
  70dd85:	74 0d                	je     70dd94 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x4b4>
  70dd87:	49 8b 55 10          	mov    0x10(%r13),%rdx
  70dd8b:	48 89 ef             	mov    %rbp,%rdi
  70dd8e:	ff 15 a4 35 3f 00    	call   *0x3f35a4(%rip)        # b01338 <_DYNAMIC+0x248>
  70dd94:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  70dd99:	49 89 44 24 08       	mov    %rax,0x8(%r12)
  70dd9e:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  70dda3:	49 89 44 24 10       	mov    %rax,0x10(%r12)
  70dda8:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  70ddad:	8d b8 00 00 01 00    	lea    0x10000(%rax),%edi
  70ddb3:	ff 15 37 38 3f 00    	call   *0x3f3837(%rip)        # b015f0 <_DYNAMIC+0x500>
  70ddb9:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  70ddbe:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
  70ddc3:	49 8d 7f f9          	lea    -0x7(%r15),%rdi
  70ddc7:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  70ddce:	48 39 f7             	cmp    %rsi,%rdi
  70ddd1:	0f 83 07 06 00 00    	jae    70e3de <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0xafe>
  70ddd7:	49 8b 8e 98 02 00 00 	mov    0x298(%r14),%rcx
  70ddde:	48 8d 14 bf          	lea    (%rdi,%rdi,4),%rdx
  70dde2:	4c 8d 24 d1          	lea    (%rcx,%rdx,8),%r12
  70dde6:	48 8b 6c d1 08       	mov    0x8(%rcx,%rdx,8),%rbp
  70ddeb:	48 85 ed             	test   %rbp,%rbp
  70ddee:	74 36                	je     70de26 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x546>
  70ddf0:	4c 8b 6c d1 10       	mov    0x10(%rcx,%rdx,8),%r13
  70ddf5:	49 8b 45 00          	mov    0x0(%r13),%rax
  70ddf9:	48 85 c0             	test   %rax,%rax
  70ddfc:	74 12                	je     70de10 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x530>
  70ddfe:	48 8d 0c d1          	lea    (%rcx,%rdx,8),%rcx
  70de02:	48 83 c1 08          	add    $0x8,%rcx
  70de06:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  70de0b:	48 89 ef             	mov    %rbp,%rdi
  70de0e:	ff d0                	call   *%rax
  70de10:	49 8b 75 08          	mov    0x8(%r13),%rsi
  70de14:	48 85 f6             	test   %rsi,%rsi
  70de17:	74 0d                	je     70de26 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x546>
  70de19:	49 8b 55 10          	mov    0x10(%r13),%rdx
  70de1d:	48 89 ef             	mov    %rbp,%rdi
  70de20:	ff 15 12 35 3f 00    	call   *0x3f3512(%rip)        # b01338 <_DYNAMIC+0x248>
  70de26:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  70de2b:	49 89 44 24 08       	mov    %rax,0x8(%r12)
  70de30:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  70de35:	49 89 44 24 10       	mov    %rax,0x10(%r12)
  70de3a:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  70de3f:	8d b8 00 00 02 00    	lea    0x20000(%rax),%edi
  70de45:	ff 15 a5 37 3f 00    	call   *0x3f37a5(%rip)        # b015f0 <_DYNAMIC+0x500>
  70de4b:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  70de50:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
  70de55:	49 8d 7f fa          	lea    -0x6(%r15),%rdi
  70de59:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  70de60:	48 39 f7             	cmp    %rsi,%rdi
  70de63:	0f 83 75 05 00 00    	jae    70e3de <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0xafe>
  70de69:	49 8b 8e 98 02 00 00 	mov    0x298(%r14),%rcx
  70de70:	48 8d 14 bf          	lea    (%rdi,%rdi,4),%rdx
  70de74:	4c 8d 24 d1          	lea    (%rcx,%rdx,8),%r12
  70de78:	48 8b 6c d1 08       	mov    0x8(%rcx,%rdx,8),%rbp
  70de7d:	48 85 ed             	test   %rbp,%rbp
  70de80:	74 36                	je     70deb8 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x5d8>
  70de82:	4c 8b 6c d1 10       	mov    0x10(%rcx,%rdx,8),%r13
  70de87:	49 8b 45 00          	mov    0x0(%r13),%rax
  70de8b:	48 85 c0             	test   %rax,%rax
  70de8e:	74 12                	je     70dea2 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x5c2>
  70de90:	48 8d 0c d1          	lea    (%rcx,%rdx,8),%rcx
  70de94:	48 83 c1 08          	add    $0x8,%rcx
  70de98:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  70de9d:	48 89 ef             	mov    %rbp,%rdi
  70dea0:	ff d0                	call   *%rax
  70dea2:	49 8b 75 08          	mov    0x8(%r13),%rsi
  70dea6:	48 85 f6             	test   %rsi,%rsi
  70dea9:	74 0d                	je     70deb8 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x5d8>
  70deab:	49 8b 55 10          	mov    0x10(%r13),%rdx
  70deaf:	48 89 ef             	mov    %rbp,%rdi
  70deb2:	ff 15 80 34 3f 00    	call   *0x3f3480(%rip)        # b01338 <_DYNAMIC+0x248>
  70deb8:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  70debd:	49 89 44 24 08       	mov    %rax,0x8(%r12)
  70dec2:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  70dec7:	49 89 44 24 10       	mov    %rax,0x10(%r12)
  70decc:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  70ded1:	8d b8 00 00 03 00    	lea    0x30000(%rax),%edi
  70ded7:	ff 15 13 37 3f 00    	call   *0x3f3713(%rip)        # b015f0 <_DYNAMIC+0x500>
  70dedd:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  70dee2:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
  70dee7:	49 8d 7f fb          	lea    -0x5(%r15),%rdi
  70deeb:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  70def2:	48 39 f7             	cmp    %rsi,%rdi
  70def5:	0f 83 e3 04 00 00    	jae    70e3de <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0xafe>
  70defb:	49 8b 8e 98 02 00 00 	mov    0x298(%r14),%rcx
  70df02:	48 8d 14 bf          	lea    (%rdi,%rdi,4),%rdx
  70df06:	4c 8d 24 d1          	lea    (%rcx,%rdx,8),%r12
  70df0a:	48 8b 6c d1 08       	mov    0x8(%rcx,%rdx,8),%rbp
  70df0f:	48 85 ed             	test   %rbp,%rbp
  70df12:	74 36                	je     70df4a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x66a>
  70df14:	4c 8b 6c d1 10       	mov    0x10(%rcx,%rdx,8),%r13
  70df19:	49 8b 45 00          	mov    0x0(%r13),%rax
  70df1d:	48 85 c0             	test   %rax,%rax
  70df20:	74 12                	je     70df34 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x654>
  70df22:	48 8d 0c d1          	lea    (%rcx,%rdx,8),%rcx
  70df26:	48 83 c1 08          	add    $0x8,%rcx
  70df2a:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  70df2f:	48 89 ef             	mov    %rbp,%rdi
  70df32:	ff d0                	call   *%rax
  70df34:	49 8b 75 08          	mov    0x8(%r13),%rsi
  70df38:	48 85 f6             	test   %rsi,%rsi
  70df3b:	74 0d                	je     70df4a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x66a>
  70df3d:	49 8b 55 10          	mov    0x10(%r13),%rdx
  70df41:	48 89 ef             	mov    %rbp,%rdi
  70df44:	ff 15 ee 33 3f 00    	call   *0x3f33ee(%rip)        # b01338 <_DYNAMIC+0x248>
  70df4a:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  70df4f:	49 89 44 24 08       	mov    %rax,0x8(%r12)
  70df54:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  70df59:	49 89 44 24 10       	mov    %rax,0x10(%r12)
  70df5e:	48 8b 7c 24 18       	mov    0x18(%rsp),%rdi
  70df63:	81 cf 00 00 04 00    	or     $0x40000,%edi
  70df69:	ff 15 81 36 3f 00    	call   *0x3f3681(%rip)        # b015f0 <_DYNAMIC+0x500>
  70df6f:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  70df74:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
  70df79:	49 83 c7 fc          	add    $0xfffffffffffffffc,%r15
  70df7d:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  70df84:	49 39 f7             	cmp    %rsi,%r15
  70df87:	0f 83 4e 04 00 00    	jae    70e3db <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0xafb>
  70df8d:	49 8b 8e 98 02 00 00 	mov    0x298(%r14),%rcx
  70df94:	4b 8d 14 bf          	lea    (%r15,%r15,4),%rdx
  70df98:	4c 8d 24 d1          	lea    (%rcx,%rdx,8),%r12
  70df9c:	48 8b 6c d1 08       	mov    0x8(%rcx,%rdx,8),%rbp
  70dfa1:	48 85 ed             	test   %rbp,%rbp
  70dfa4:	74 36                	je     70dfdc <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x6fc>
  70dfa6:	4c 8b 6c d1 10       	mov    0x10(%rcx,%rdx,8),%r13
  70dfab:	49 8b 45 00          	mov    0x0(%r13),%rax
  70dfaf:	48 85 c0             	test   %rax,%rax
  70dfb2:	74 12                	je     70dfc6 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x6e6>
  70dfb4:	48 8d 0c d1          	lea    (%rcx,%rdx,8),%rcx
  70dfb8:	48 83 c1 08          	add    $0x8,%rcx
  70dfbc:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  70dfc1:	48 89 ef             	mov    %rbp,%rdi
  70dfc4:	ff d0                	call   *%rax
  70dfc6:	49 8b 75 08          	mov    0x8(%r13),%rsi
  70dfca:	48 85 f6             	test   %rsi,%rsi
  70dfcd:	74 0d                	je     70dfdc <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x6fc>
  70dfcf:	49 8b 55 10          	mov    0x10(%r13),%rdx
  70dfd3:	48 89 ef             	mov    %rbp,%rdi
  70dfd6:	ff 15 5c 33 3f 00    	call   *0x3f335c(%rip)        # b01338 <_DYNAMIC+0x248>
  70dfdc:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  70dfe1:	49 89 44 24 08       	mov    %rax,0x8(%r12)
  70dfe6:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  70dfeb:	49 89 44 24 10       	mov    %rax,0x10(%r12)
  70dff0:	48 8b 54 24 60       	mov    0x60(%rsp),%rdx
  70dff5:	49 89 96 60 06 00 00 	mov    %rdx,0x660(%r14)
  70dffc:	49 ff 86 b0 06 00 00 	incq   0x6b0(%r14)
  70e003:	49 c7 86 08 07 00 00 	movq   $0x0,0x708(%r14)
  70e00a:	00 00 00 00 
  70e00e:	41 c6 86 1f 07 00 00 	movb   $0x1,0x71f(%r14)
  70e015:	01 
  70e016:	48 89 df             	mov    %rbx,%rdi
  70e019:	4c 89 f6             	mov    %r14,%rsi
  70e01c:	48 81 c4 28 01 00 00 	add    $0x128,%rsp
  70e023:	5b                   	pop    %rbx
  70e024:	41 5c                	pop    %r12
  70e026:	41 5d                	pop    %r13
  70e028:	41 5e                	pop    %r14
  70e02a:	41 5f                	pop    %r15
  70e02c:	5d                   	pop    %rbp
  70e02d:	e9 be fa 00 00       	jmp    71daf0 <<gpui::runtime::Runtime<unit_action_cost::Model>>::present>
  70e032:	31 c9                	xor    %ecx,%ecx
  70e034:	49 8b b6 08 07 00 00 	mov    0x708(%r14),%rsi
  70e03b:	48 89 4b 08          	mov    %rcx,0x8(%rbx)
  70e03f:	48 89 53 10          	mov    %rdx,0x10(%rbx)
  70e043:	0f 11 43 18          	movups %xmm0,0x18(%rbx)
  70e047:	48 89 73 28          	mov    %rsi,0x28(%rbx)
  70e04b:	88 43 30             	mov    %al,0x30(%rbx)
  70e04e:	48 c7 03 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rbx)
  70e055:	48 8d 7c 24 68       	lea    0x68(%rsp),%rdi
  70e05a:	e8 11 63 ff ff       	call   704370 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70e05f:	e9 11 f9 ff ff       	jmp    70d975 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x95>
  70e064:	48 8b 8c 24 f0 00 00 	mov    0xf0(%rsp),%rcx
  70e06b:	00 
  70e06c:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  70e073:	00 
  70e074:	0f 10 84 24 d0 00 00 	movups 0xd0(%rsp),%xmm0
  70e07b:	00 
  70e07c:	0f 10 8c 24 e0 00 00 	movups 0xe0(%rsp),%xmm1
  70e083:	00 
  70e084:	0f 11 8c 24 88 00 00 	movups %xmm1,0x88(%rsp)
  70e08b:	00 
  70e08c:	0f 11 44 24 78       	movups %xmm0,0x78(%rsp)
  70e091:	48 89 44 24 68       	mov    %rax,0x68(%rsp)
  70e096:	4c 89 64 24 70       	mov    %r12,0x70(%rsp)
  70e09b:	48 83 f8 11          	cmp    $0x11,%rax
  70e09f:	0f 84 49 fb ff ff    	je     70dbee <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x30e>
  70e0a5:	eb 2d                	jmp    70e0d4 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x7f4>
  70e0a7:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  70e0ac:	48 89 84 24 98 00 00 	mov    %rax,0x98(%rsp)
  70e0b3:	00 
  70e0b4:	0f 10 44 24 38       	movups 0x38(%rsp),%xmm0
  70e0b9:	0f 10 4c 24 48       	movups 0x48(%rsp),%xmm1
  70e0be:	0f 11 8c 24 88 00 00 	movups %xmm1,0x88(%rsp)
  70e0c5:	00 
  70e0c6:	0f 11 44 24 78       	movups %xmm0,0x78(%rsp)
  70e0cb:	48 c7 44 24 68 1a 00 	movq   $0x1a,0x68(%rsp)
  70e0d2:	00 00 
  70e0d4:	48 8b 84 24 98 00 00 	mov    0x98(%rsp),%rax
  70e0db:	00 
  70e0dc:	48 89 43 30          	mov    %rax,0x30(%rbx)
  70e0e0:	48 8b 44 24 68       	mov    0x68(%rsp),%rax
  70e0e5:	48 8b 4c 24 70       	mov    0x70(%rsp),%rcx
  70e0ea:	0f 10 44 24 78       	movups 0x78(%rsp),%xmm0
  70e0ef:	0f 10 8c 24 88 00 00 	movups 0x88(%rsp),%xmm1
  70e0f6:	00 
  70e0f7:	0f 11 4b 20          	movups %xmm1,0x20(%rbx)
  70e0fb:	0f 11 43 10          	movups %xmm0,0x10(%rbx)
  70e0ff:	48 89 03             	mov    %rax,(%rbx)
  70e102:	48 89 4b 08          	mov    %rcx,0x8(%rbx)
  70e106:	e9 6a f8 ff ff       	jmp    70d975 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x95>
  70e10b:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  70e112:	49 39 f4             	cmp    %rsi,%r12
  70e115:	0f 83 eb 02 00 00    	jae    70e406 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0xb26>
  70e11b:	49 8b 86 98 02 00 00 	mov    0x298(%r14),%rax
  70e122:	4b 8d 0c a4          	lea    (%r12,%r12,4),%rcx
  70e126:	44 8b 7c c8 18       	mov    0x18(%rax,%rcx,8),%r15d
  70e12b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  70e130:	49 39 c7             	cmp    %rax,%r15
  70e133:	0f 84 2c f8 ff ff    	je     70d965 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x85>
  70e139:	48 c7 44 24 28 11 00 	movq   $0x11,0x28(%rsp)
  70e140:	00 00 
  70e142:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  70e147:	e8 24 62 ff ff       	call   704370 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70e14c:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  70e153:	4c 39 fe             	cmp    %r15,%rsi
  70e156:	0f 86 ba 02 00 00    	jbe    70e416 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0xb36>
  70e15c:	49 8d be b0 05 00 00 	lea    0x5b0(%r14),%rdi
  70e163:	49 8b 86 98 02 00 00 	mov    0x298(%r14),%rax
  70e16a:	4b 8d 0c bf          	lea    (%r15,%r15,4),%rcx
  70e16e:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
  70e172:	ff 15 80 34 3f 00    	call   *0x3f3480(%rip)        # b015f8 <_DYNAMIC+0x508>
  70e178:	49 89 c7             	mov    %rax,%r15
  70e17b:	49 89 d4             	mov    %rdx,%r12
  70e17e:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  70e183:	4c 89 f6             	mov    %r14,%rsi
  70e186:	48 89 c2             	mov    %rax,%rdx
  70e189:	4c 89 e1             	mov    %r12,%rcx
  70e18c:	e8 5f f5 ff ff       	call   70d6f0 <<gpui::runtime::Runtime<unit_action_cost::Model>>::inspector_app_index>
  70e191:	83 7c 24 28 fe       	cmpl   $0xfffffffe,0x28(%rsp)
  70e196:	75 5f                	jne    70e1f7 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x917>
  70e198:	48 89 df             	mov    %rbx,%rdi
  70e19b:	4c 89 f6             	mov    %r14,%rsi
  70e19e:	4c 89 fa             	mov    %r15,%rdx
  70e1a1:	4c 89 e1             	mov    %r12,%rcx
  70e1a4:	48 81 c4 28 01 00 00 	add    $0x128,%rsp
  70e1ab:	5b                   	pop    %rbx
  70e1ac:	41 5c                	pop    %r12
  70e1ae:	41 5d                	pop    %r13
  70e1b0:	41 5e                	pop    %r14
  70e1b2:	41 5f                	pop    %r15
  70e1b4:	5d                   	pop    %rbp
  70e1b5:	e9 e6 02 00 00       	jmp    70e4a0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::inspector_select>
  70e1ba:	8b 4c 24 5c          	mov    0x5c(%rsp),%ecx
  70e1be:	89 4b 34             	mov    %ecx,0x34(%rbx)
  70e1c1:	0f 10 44 24 4c       	movups 0x4c(%rsp),%xmm0
  70e1c6:	0f 11 43 24          	movups %xmm0,0x24(%rbx)
  70e1ca:	0f 10 84 24 cc 00 00 	movups 0xcc(%rsp),%xmm0
  70e1d1:	00 
  70e1d2:	0f 11 43 14          	movups %xmm0,0x14(%rbx)
  70e1d6:	0f 28 84 24 c0 00 00 	movaps 0xc0(%rsp),%xmm0
  70e1dd:	00 
  70e1de:	0f 11 43 08          	movups %xmm0,0x8(%rbx)
  70e1e2:	48 89 03             	mov    %rax,(%rbx)
  70e1e5:	e9 8b f7 ff ff       	jmp    70d975 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x95>
  70e1ea:	48 8d 3d 27 53 3c 00 	lea    0x3c5327(%rip),%rdi        # ad3518 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.15092672030101349239+0x900>
  70e1f1:	ff 15 81 31 3f 00    	call   *0x3f3181(%rip)        # b01378 <_DYNAMIC+0x288>
  70e1f7:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  70e1fc:	e8 6f 61 ff ff       	call   704370 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70e201:	41 0f 10 86 60 06 00 	movups 0x660(%r14),%xmm0
  70e208:	00 
  70e209:	41 0f b6 86 20 07 00 	movzbl 0x720(%r14),%eax
  70e210:	00 
  70e211:	49 83 be 80 06 00 00 	cmpq   $0x0,0x680(%r14)
  70e218:	00 
  70e219:	74 1c                	je     70e237 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x957>
  70e21b:	84 c0                	test   %al,%al
  70e21d:	74 0a                	je     70e229 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x949>
  70e21f:	49 83 be 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%r14)
  70e226:	ff 
  70e227:	74 0e                	je     70e237 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x957>
  70e229:	49 8b 96 90 06 00 00 	mov    0x690(%r14),%rdx
  70e230:	b9 01 00 00 00       	mov    $0x1,%ecx
  70e235:	eb 02                	jmp    70e239 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x959>
  70e237:	31 c9                	xor    %ecx,%ecx
  70e239:	49 8b b6 08 07 00 00 	mov    0x708(%r14),%rsi
  70e240:	48 89 4b 08          	mov    %rcx,0x8(%rbx)
  70e244:	48 89 53 10          	mov    %rdx,0x10(%rbx)
  70e248:	0f 11 43 18          	movups %xmm0,0x18(%rbx)
  70e24c:	48 89 73 28          	mov    %rsi,0x28(%rbx)
  70e250:	e9 f0 f9 ff ff       	jmp    70dc45 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x365>
  70e255:	83 f8 23             	cmp    $0x23,%eax
  70e258:	0f 85 eb 00 00 00    	jne    70e349 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0xa69>
  70e25e:	8b 44 24 30          	mov    0x30(%rsp),%eax
  70e262:	83 f8 0d             	cmp    $0xd,%eax
  70e265:	0f 84 12 01 00 00    	je     70e37d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0xa9d>
  70e26b:	83 f8 0e             	cmp    $0xe,%eax
  70e26e:	0f 85 d5 00 00 00    	jne    70e349 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0xa69>
  70e274:	ba 07 00 00 00       	mov    $0x7,%edx
  70e279:	e9 04 01 00 00       	jmp    70e382 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0xaa2>
  70e27e:	c6 84 24 a0 00 00 00 	movb   $0x0,0xa0(%rsp)
  70e285:	00 
  70e286:	c7 84 24 a4 00 00 00 	movl   $0x0,0xa4(%rsp)
  70e28d:	00 00 00 00 
  70e291:	48 8d b4 24 a0 00 00 	lea    0xa0(%rsp),%rsi
  70e298:	00 
  70e299:	8b 7c 24 08          	mov    0x8(%rsp),%edi
  70e29d:	ff 15 5d 33 3f 00    	call   *0x3f335d(%rip)        # b01600 <_DYNAMIC+0x510>
  70e2a3:	66 85 c0             	test   %ax,%ax
  70e2a6:	74 2a                	je     70e2d2 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x9f2>
  70e2a8:	48 c1 e8 10          	shr    $0x10,%rax
  70e2ac:	48 89 df             	mov    %rbx,%rdi
  70e2af:	4c 89 f6             	mov    %r14,%rsi
  70e2b2:	89 c2                	mov    %eax,%edx
  70e2b4:	48 81 c4 28 01 00 00 	add    $0x128,%rsp
  70e2bb:	5b                   	pop    %rbx
  70e2bc:	41 5c                	pop    %r12
  70e2be:	41 5d                	pop    %r13
  70e2c0:	41 5e                	pop    %r14
  70e2c2:	41 5f                	pop    %r15
  70e2c4:	5d                   	pop    %rbp
  70e2c5:	e9 f6 f4 ff ff       	jmp    70d7c0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::reject_editor>
  70e2ca:	c6 84 24 a0 00 00 00 	movb   $0xff,0xa0(%rsp)
  70e2d1:	ff 
  70e2d2:	4d 8b be 60 06 00 00 	mov    0x660(%r14),%r15
  70e2d9:	49 83 ff ff          	cmp    $0xffffffffffffffff,%r15
  70e2dd:	0f 84 8e 00 00 00    	je     70e371 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0xa91>
  70e2e3:	48 c7 44 24 28 1f 00 	movq   $0x1f,0x28(%rsp)
  70e2ea:	00 00 
  70e2ec:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  70e2f1:	e8 7a 60 ff ff       	call   704370 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70e2f6:	49 8b 86 10 06 00 00 	mov    0x610(%r14),%rax
  70e2fd:	48 85 c0             	test   %rax,%rax
  70e300:	0f 84 af 00 00 00    	je     70e3b5 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0xad5>
  70e306:	48 8b 80 d8 00 00 00 	mov    0xd8(%rax),%rax
  70e30d:	48 85 c0             	test   %rax,%rax
  70e310:	0f 84 9f 00 00 00    	je     70e3b5 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0xad5>
  70e316:	49 ff c7             	inc    %r15
  70e319:	c6 40 13 ff          	movb   $0xff,0x13(%rax)
  70e31d:	48 8d 84 24 a0 00 00 	lea    0xa0(%rsp),%rax
  70e324:	00 
  70e325:	48 89 04 24          	mov    %rax,(%rsp)
  70e329:	48 89 df             	mov    %rbx,%rdi
  70e32c:	4c 89 f6             	mov    %r14,%rsi
  70e32f:	48 8b 54 24 60       	mov    0x60(%rsp),%rdx
  70e334:	4c 89 e1             	mov    %r12,%rcx
  70e337:	4d 89 f8             	mov    %r15,%r8
  70e33a:	44 8b 4c 24 08       	mov    0x8(%rsp),%r9d
  70e33f:	e8 1c fe 00 00       	call   71e160 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at>
  70e344:	e9 2c f6 ff ff       	jmp    70d975 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x95>
  70e349:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  70e34e:	48 89 43 30          	mov    %rax,0x30(%rbx)
  70e352:	0f 10 44 24 28       	movups 0x28(%rsp),%xmm0
  70e357:	0f 10 4c 24 38       	movups 0x38(%rsp),%xmm1
  70e35c:	0f 10 54 24 48       	movups 0x48(%rsp),%xmm2
  70e361:	0f 11 53 20          	movups %xmm2,0x20(%rbx)
  70e365:	0f 11 4b 10          	movups %xmm1,0x10(%rbx)
  70e369:	0f 11 03             	movups %xmm0,(%rbx)
  70e36c:	e9 04 f6 ff ff       	jmp    70d975 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x95>
  70e371:	48 c7 03 1f 00 00 00 	movq   $0x1f,(%rbx)
  70e378:	e9 f8 f5 ff ff       	jmp    70d975 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x95>
  70e37d:	ba 06 00 00 00       	mov    $0x6,%edx
  70e382:	48 89 df             	mov    %rbx,%rdi
  70e385:	4c 89 f6             	mov    %r14,%rsi
  70e388:	e8 33 f4 ff ff       	call   70d7c0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::reject_editor>
  70e38d:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  70e392:	e8 d9 5f ff ff       	call   704370 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70e397:	e9 d9 f5 ff ff       	jmp    70d975 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0x95>
  70e39c:	48 8d 3d e1 ae 95 ff 	lea    -0x6a511f(%rip),%rdi        # 69284 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x2bf4>
  70e3a3:	48 8d 15 e6 51 3c 00 	lea    0x3c51e6(%rip),%rdx        # ad3590 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.15092672030101349239+0x978>
  70e3aa:	be 28 00 00 00       	mov    $0x28,%esi
  70e3af:	ff 15 bb 2f 3f 00    	call   *0x3f2fbb(%rip)        # b01370 <_DYNAMIC+0x280>
  70e3b5:	48 8d 3d 09 af 95 ff 	lea    -0x6a50f7(%rip),%rdi        # 692c5 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x2c35>
  70e3bc:	48 8d 15 dd 50 3c 00 	lea    0x3c50dd(%rip),%rdx        # ad34a0 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.15092672030101349239+0x888>
  70e3c3:	be 11 00 00 00       	mov    $0x11,%esi
  70e3c8:	ff 15 8a 30 3f 00    	call   *0x3f308a(%rip)        # b01458 <_DYNAMIC+0x368>
  70e3ce:	48 8d 3d 5b 51 3c 00 	lea    0x3c515b(%rip),%rdi        # ad3530 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.15092672030101349239+0x918>
  70e3d5:	ff 15 9d 2f 3f 00    	call   *0x3f2f9d(%rip)        # b01378 <_DYNAMIC+0x288>
  70e3db:	4c 89 ff             	mov    %r15,%rdi
  70e3de:	48 8d 15 63 51 3c 00 	lea    0x3c5163(%rip),%rdx        # ad3548 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.15092672030101349239+0x930>
  70e3e5:	ff 15 7d 30 3f 00    	call   *0x3f307d(%rip)        # b01468 <_DYNAMIC+0x378>
  70e3eb:	0f 0b                	ud2
  70e3ed:	48 8d 3d 90 ae 95 ff 	lea    -0x6a5170(%rip),%rdi        # 69284 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x2bf4>
  70e3f4:	48 8d 15 ad 51 3c 00 	lea    0x3c51ad(%rip),%rdx        # ad35a8 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.15092672030101349239+0x990>
  70e3fb:	be 28 00 00 00       	mov    $0x28,%esi
  70e400:	ff 15 6a 2f 3f 00    	call   *0x3f2f6a(%rip)        # b01370 <_DYNAMIC+0x280>
  70e406:	48 8d 15 53 51 3c 00 	lea    0x3c5153(%rip),%rdx        # ad3560 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.15092672030101349239+0x948>
  70e40d:	4c 89 e7             	mov    %r12,%rdi
  70e410:	ff 15 52 30 3f 00    	call   *0x3f3052(%rip)        # b01468 <_DYNAMIC+0x378>
  70e416:	48 8d 15 5b 51 3c 00 	lea    0x3c515b(%rip),%rdx        # ad3578 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.15092672030101349239+0x960>
  70e41d:	4c 89 ff             	mov    %r15,%rdi
  70e420:	ff 15 42 30 3f 00    	call   *0x3f3042(%rip)        # b01468 <_DYNAMIC+0x378>
  70e426:	48 89 c3             	mov    %rax,%rbx
  70e429:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  70e42e:	e8 3d 5f ff ff       	call   704370 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70e433:	48 89 df             	mov    %rbx,%rdi
  70e436:	e8 a5 33 3c 00       	call   ad17e0 <_Unwind_Resume@plt>
  70e43b:	4c 8b 74 24 20       	mov    0x20(%rsp),%r14
  70e440:	48 89 c3             	mov    %rax,%rbx
  70e443:	49 8b 75 08          	mov    0x8(%r13),%rsi
  70e447:	48 85 f6             	test   %rsi,%rsi
  70e44a:	74 0d                	je     70e459 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action+0xb79>
  70e44c:	49 8b 55 10          	mov    0x10(%r13),%rdx
  70e450:	48 89 ef             	mov    %rbp,%rdi
  70e453:	ff 15 df 2e 3f 00    	call   *0x3f2edf(%rip)        # b01338 <_DYNAMIC+0x248>
  70e459:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  70e45e:	49 89 06             	mov    %rax,(%r14)
  70e461:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  70e466:	49 89 44 24 10       	mov    %rax,0x10(%r12)
  70e46b:	48 89 df             	mov    %rbx,%rdi
  70e46e:	e8 6d 33 3c 00       	call   ad17e0 <_Unwind_Resume@plt>
  70e473:	48 89 c3             	mov    %rax,%rbx
  70e476:	48 8b 7c 24 10       	mov    0x10(%rsp),%rdi
  70e47b:	48 8b 74 24 08       	mov    0x8(%rsp),%rsi
  70e480:	e8 ab 2f ff ff       	call   701430 <core::ptr::drop_glue::<core::option::Option<gpui::element::Handler>>>
  70e485:	48 89 df             	mov    %rbx,%rdi
  70e488:	e8 53 33 3c 00       	call   ad17e0 <_Unwind_Resume@plt>
  70e48d:	ff 15 f5 2e 3f 00    	call   *0x3f2ef5(%rip)        # b01388 <_DYNAMIC+0x298>
