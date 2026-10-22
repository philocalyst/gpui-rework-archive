
/tmp/gpui-contained-property-exchange-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

0000000000709b90 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action>:
  709b90:	55                   	push   %rbp
  709b91:	41 57                	push   %r15
  709b93:	41 56                	push   %r14
  709b95:	41 55                	push   %r13
  709b97:	41 54                	push   %r12
  709b99:	53                   	push   %rbx
  709b9a:	48 81 ec 28 01 00 00 	sub    $0x128,%rsp
  709ba1:	48 89 fb             	mov    %rdi,%rbx
  709ba4:	80 be 22 07 00 00 00 	cmpb   $0x0,0x722(%rsi)
  709bab:	74 09                	je     709bb6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x26>
  709bad:	48 c7 03 0e 00 00 00 	movq   $0xe,(%rbx)
  709bb4:	eb 6f                	jmp    709c25 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x95>
  709bb6:	49 89 f6             	mov    %rsi,%r14
  709bb9:	48 8b 86 10 06 00 00 	mov    0x610(%rsi),%rax
  709bc0:	48 85 c0             	test   %rax,%rax
  709bc3:	74 59                	je     709c1e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x8e>
  709bc5:	48 83 b8 d8 00 00 00 	cmpq   $0x0,0xd8(%rax)
  709bcc:	00 
  709bcd:	74 4f                	je     709c1e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x8e>
  709bcf:	49 c7 86 08 07 00 00 	movq   $0x0,0x708(%r14)
  709bd6:	00 00 00 00 
  709bda:	48 8b a8 d8 00 00 00 	mov    0xd8(%rax),%rbp
  709be1:	48 85 ed             	test   %rbp,%rbp
  709be4:	0f 84 b0 08 00 00    	je     70a49a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x90a>
  709bea:	44 0f b7 65 10       	movzwl 0x10(%rbp),%r12d
  709bef:	0f b6 7d 16          	movzbl 0x16(%rbp),%edi
  709bf3:	44 0f b6 45 12       	movzbl 0x12(%rbp),%r8d
  709bf8:	89 c8                	mov    %ecx,%eax
  709bfa:	66 83 e8 0e          	sub    $0xe,%ax
  709bfe:	41 bf 03 00 00 00    	mov    $0x3,%r15d
  709c04:	44 0f 43 f8          	cmovae %eax,%r15d
  709c08:	66 41 83 ff 03       	cmp    $0x3,%r15w
  709c0d:	75 28                	jne    709c37 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0xa7>
  709c0f:	66 41 39 cc          	cmp    %cx,%r12w
  709c13:	74 22                	je     709c37 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0xa7>
  709c15:	48 c7 03 11 00 00 00 	movq   $0x11,(%rbx)
  709c1c:	eb 07                	jmp    709c25 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x95>
  709c1e:	48 c7 03 1a 00 00 00 	movq   $0x1a,(%rbx)
  709c25:	48 81 c4 28 01 00 00 	add    $0x128,%rsp
  709c2c:	5b                   	pop    %rbx
  709c2d:	41 5c                	pop    %r12
  709c2f:	41 5d                	pop    %r13
  709c31:	41 5e                	pop    %r14
  709c33:	41 5f                	pop    %r15
  709c35:	5d                   	pop    %rbp
  709c36:	c3                   	ret
  709c37:	41 89 cd             	mov    %ecx,%r13d
  709c3a:	41 c1 ed 10          	shr    $0x10,%r13d
  709c3e:	45 0f b7 cf          	movzwl %r15w,%r9d
  709c42:	48 8d 05 eb 1b 95 ff 	lea    -0x6ae415(%rip),%rax        # 5b834 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x34>
  709c49:	4a 63 34 88          	movslq (%rax,%r9,4),%rsi
  709c4d:	48 01 c6             	add    %rax,%rsi
  709c50:	ff e6                	jmp    *%rsi
  709c52:	44 0f b7 ff          	movzwl %di,%r15d
  709c56:	41 81 cf 00 01 00 00 	or     $0x100,%r15d
  709c5d:	eb 12                	jmp    709c71 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0xe1>
  709c5f:	45 0f b7 f8          	movzwl %r8w,%r15d
  709c63:	41 c1 e7 08          	shl    $0x8,%r15d
  709c67:	66 45 39 e5          	cmp    %r12w,%r13w
  709c6b:	0f 85 f3 02 00 00    	jne    709f64 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x3d4>
  709c71:	b0 01                	mov    $0x1,%al
  709c73:	44 38 ff             	cmp    %r15b,%dil
  709c76:	0f 85 ed 02 00 00    	jne    709f69 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x3d9>
  709c7c:	41 0f b7 cf          	movzwl %r15w,%ecx
  709c80:	c1 e9 08             	shr    $0x8,%ecx
  709c83:	41 38 c8             	cmp    %cl,%r8b
  709c86:	0f 85 dd 02 00 00    	jne    709f69 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x3d9>
  709c8c:	80 7d 13 ff          	cmpb   $0xff,0x13(%rbp)
  709c90:	0f 85 d3 02 00 00    	jne    709f69 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x3d9>
  709c96:	e9 c4 01 00 00       	jmp    709e5f <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x2cf>
  709c9b:	f7 c1 00 00 ff 00    	test   $0xff0000,%ecx
  709ca1:	0f 84 5d 02 00 00    	je     709f04 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x374>
  709ca7:	48 8b 45 00          	mov    0x0(%rbp),%rax
  709cab:	48 85 c0             	test   %rax,%rax
  709cae:	0f 84 ab 01 00 00    	je     709e5f <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x2cf>
  709cb4:	49 3b 86 b0 05 00 00 	cmp    0x5b0(%r14),%rax
  709cbb:	0f 85 d4 01 00 00    	jne    709e95 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x305>
  709cc1:	4c 89 4c 24 18       	mov    %r9,0x18(%rsp)
  709cc6:	48 89 7c 24 10       	mov    %rdi,0x10(%rsp)
  709ccb:	48 89 54 24 60       	mov    %rdx,0x60(%rsp)
  709cd0:	89 4c 24 08          	mov    %ecx,0x8(%rsp)
  709cd4:	4c 8b 65 08          	mov    0x8(%rbp),%r12
  709cd8:	48 c7 44 24 28 11 00 	movq   $0x11,0x28(%rsp)
  709cdf:	00 00 
  709ce1:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  709ce6:	e8 05 e2 fe ff       	call   6f7ef0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  709ceb:	48 8d bc 24 c0 00 00 	lea    0xc0(%rsp),%rdi
  709cf2:	00 
  709cf3:	4c 89 f6             	mov    %r14,%rsi
  709cf6:	4c 89 e2             	mov    %r12,%rdx
  709cf9:	e8 22 ef 01 00       	call   728c20 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::resolve_identity>
  709cfe:	48 8b 84 24 c0 00 00 	mov    0xc0(%rsp),%rax
  709d05:	00 
  709d06:	4c 8b a4 24 c8 00 00 	mov    0xc8(%rsp),%r12
  709d0d:	00 
  709d0e:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  709d12:	0f 85 fc 05 00 00    	jne    70a314 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x784>
  709d18:	49 8b 86 10 06 00 00 	mov    0x610(%r14),%rax
  709d1f:	48 85 c0             	test   %rax,%rax
  709d22:	0f 84 2f 06 00 00    	je     70a357 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x7c7>
  709d28:	48 83 b8 d8 00 00 00 	cmpq   $0x0,0xd8(%rax)
  709d2f:	00 
  709d30:	0f 84 21 06 00 00    	je     70a357 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x7c7>
  709d36:	49 8b ae a0 02 00 00 	mov    0x2a0(%r14),%rbp
  709d3d:	48 c7 44 24 28 1a 00 	movq   $0x1a,0x28(%rsp)
  709d44:	00 00 
  709d46:	48 83 fd 1c          	cmp    $0x1c,%rbp
  709d4a:	0f 82 07 06 00 00    	jb     70a357 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x7c7>
  709d50:	48 83 c5 e4          	add    $0xffffffffffffffe4,%rbp
  709d54:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  709d59:	e8 92 e1 fe ff       	call   6f7ef0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  709d5e:	49 83 fc 02          	cmp    $0x2,%r12
  709d62:	0f 93 c0             	setae  %al
  709d65:	49 39 ec             	cmp    %rbp,%r12
  709d68:	0f 92 c1             	setb   %cl
  709d6b:	84 c8                	test   %cl,%al
  709d6d:	0f 84 22 01 00 00    	je     709e95 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x305>
  709d73:	66 41 83 ff 01       	cmp    $0x1,%r15w
  709d78:	0f 84 3d 06 00 00    	je     70a3bb <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x82b>
  709d7e:	83 7c 24 18 03       	cmpl   $0x3,0x18(%rsp)
  709d83:	0f 85 c3 08 00 00    	jne    70a64c <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0xabc>
  709d89:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  709d8e:	4c 89 f6             	mov    %r14,%rsi
  709d91:	4c 89 e2             	mov    %r12,%rdx
  709d94:	8b 4c 24 08          	mov    0x8(%rsp),%ecx
  709d98:	e8 63 fd 01 00       	call   729b00 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::property_value_at>
  709d9d:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  709da2:	0f 10 44 24 30       	movups 0x30(%rsp),%xmm0
  709da7:	0f 29 84 24 c0 00 00 	movaps %xmm0,0xc0(%rsp)
  709dae:	00 
  709daf:	0f 10 44 24 3c       	movups 0x3c(%rsp),%xmm0
  709db4:	0f 11 84 24 cc 00 00 	movups %xmm0,0xcc(%rsp)
  709dbb:	00 
  709dbc:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  709dc0:	0f 85 a4 06 00 00    	jne    70a46a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x8da>
  709dc6:	0f 28 84 24 c0 00 00 	movaps 0xc0(%rsp),%xmm0
  709dcd:	00 
  709dce:	0f 29 84 24 00 01 00 	movaps %xmm0,0x100(%rsp)
  709dd5:	00 
  709dd6:	0f 10 84 24 cc 00 00 	movups 0xcc(%rsp),%xmm0
  709ddd:	00 
  709dde:	0f 11 84 24 0c 01 00 	movups %xmm0,0x10c(%rsp)
  709de5:	00 
  709de6:	41 0f b6 c5          	movzbl %r13b,%eax
  709dea:	48 8d 0d 53 1a 95 ff 	lea    -0x6ae5ad(%rip),%rcx        # 5b844 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x44>
  709df1:	48 63 04 81          	movslq (%rcx,%rax,4),%rax
  709df5:	48 01 c8             	add    %rcx,%rax
  709df8:	ff e0                	jmp    *%rax
  709dfa:	8b 44 24 08          	mov    0x8(%rsp),%eax
  709dfe:	25 00 00 ff 00       	and    $0xff0000,%eax
  709e03:	31 c9                	xor    %ecx,%ecx
  709e05:	3d 00 00 02 00       	cmp    $0x20000,%eax
  709e0a:	0f 94 c1             	sete   %cl
  709e0d:	48 8d 05 a4 17 95 ff 	lea    -0x6ae85c(%rip),%rax        # 5b5b8 <anon.079f5e587c394fcac2765eb4d0cf0bc2.21.llvm.6319143315422321905+0x48>
  709e14:	f3 0f 10 04 88       	movss  (%rax,%rcx,4),%xmm0
  709e19:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  709e1e:	48 8d b4 24 00 01 00 	lea    0x100(%rsp),%rsi
  709e25:	00 
  709e26:	48 8b 54 24 10       	mov    0x10(%rsp),%rdx
  709e2b:	ff 15 47 f7 41 00    	call   *0x41f747(%rip)        # b29578 <_DYNAMIC+0x4f0>
  709e31:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  709e36:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  709e3a:	0f 85 c5 06 00 00    	jne    70a505 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x975>
  709e40:	0f 10 44 24 30       	movups 0x30(%rsp),%xmm0
  709e45:	0f 10 4c 24 3c       	movups 0x3c(%rsp),%xmm1
  709e4a:	0f 11 8c 24 ac 00 00 	movups %xmm1,0xac(%rsp)
  709e51:	00 
  709e52:	0f 29 84 24 a0 00 00 	movaps %xmm0,0xa0(%rsp)
  709e59:	00 
  709e5a:	e9 e2 06 00 00       	jmp    70a541 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x9b1>
  709e5f:	41 0f 10 86 60 06 00 	movups 0x660(%r14),%xmm0
  709e66:	00 
  709e67:	41 0f b6 86 20 07 00 	movzbl 0x720(%r14),%eax
  709e6e:	00 
  709e6f:	49 83 be 80 06 00 00 	cmpq   $0x0,0x680(%r14)
  709e76:	00 
  709e77:	74 66                	je     709edf <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x34f>
  709e79:	84 c0                	test   %al,%al
  709e7b:	74 0a                	je     709e87 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x2f7>
  709e7d:	49 83 be 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%r14)
  709e84:	ff 
  709e85:	74 58                	je     709edf <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x34f>
  709e87:	49 8b 96 90 06 00 00 	mov    0x690(%r14),%rdx
  709e8e:	b9 01 00 00 00       	mov    $0x1,%ecx
  709e93:	eb 4c                	jmp    709ee1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x351>
  709e95:	48 c7 44 24 68 11 00 	movq   $0x11,0x68(%rsp)
  709e9c:	00 00 
  709e9e:	41 0f 10 86 60 06 00 	movups 0x660(%r14),%xmm0
  709ea5:	00 
  709ea6:	41 0f b6 86 20 07 00 	movzbl 0x720(%r14),%eax
  709ead:	00 
  709eae:	49 83 be 80 06 00 00 	cmpq   $0x0,0x680(%r14)
  709eb5:	00 
  709eb6:	0f 84 26 04 00 00    	je     70a2e2 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x752>
  709ebc:	84 c0                	test   %al,%al
  709ebe:	74 0e                	je     709ece <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x33e>
  709ec0:	49 83 be 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%r14)
  709ec7:	ff 
  709ec8:	0f 84 14 04 00 00    	je     70a2e2 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x752>
  709ece:	49 8b 96 90 06 00 00 	mov    0x690(%r14),%rdx
  709ed5:	b9 01 00 00 00       	mov    $0x1,%ecx
  709eda:	e9 05 04 00 00       	jmp    70a2e4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x754>
  709edf:	31 c9                	xor    %ecx,%ecx
  709ee1:	48 89 4b 08          	mov    %rcx,0x8(%rbx)
  709ee5:	48 89 53 10          	mov    %rdx,0x10(%rbx)
  709ee9:	0f 11 43 18          	movups %xmm0,0x18(%rbx)
  709eed:	48 c7 43 28 00 00 00 	movq   $0x0,0x28(%rbx)
  709ef4:	00 
  709ef5:	88 43 30             	mov    %al,0x30(%rbx)
  709ef8:	48 c7 03 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rbx)
  709eff:	e9 21 fd ff ff       	jmp    709c25 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x95>
  709f04:	45 0f b7 f8          	movzwl %r8w,%r15d
  709f08:	8d 47 01             	lea    0x1(%rdi),%eax
  709f0b:	89 44 24 18          	mov    %eax,0x18(%rsp)
  709f0f:	48 89 7c 24 10       	mov    %rdi,0x10(%rsp)
  709f14:	89 cf                	mov    %ecx,%edi
  709f16:	89 4c 24 08          	mov    %ecx,0x8(%rsp)
  709f1a:	45 89 c5             	mov    %r8d,%r13d
  709f1d:	e8 ae ab ff ff       	call   704ad0 <<gpui::property::PropertyId>::info>
  709f22:	45 89 e8             	mov    %r13d,%r8d
  709f25:	48 8b 7c 24 10       	mov    0x10(%rsp),%rdi
  709f2a:	44 8b 6c 24 08       	mov    0x8(%rsp),%r13d
  709f2f:	0f b6 40 14          	movzbl 0x14(%rax),%eax
  709f33:	31 c9                	xor    %ecx,%ecx
  709f35:	3c 04                	cmp    $0x4,%al
  709f37:	0f 94 c1             	sete   %cl
  709f3a:	8d 0c 89             	lea    (%rcx,%rcx,4),%ecx
  709f3d:	ff c1                	inc    %ecx
  709f3f:	3c 02                	cmp    $0x2,%al
  709f41:	ba 04 00 00 00       	mov    $0x4,%edx
  709f46:	0f 45 d1             	cmovne %ecx,%edx
  709f49:	0f b6 44 24 18       	movzbl 0x18(%rsp),%eax
  709f4e:	f6 f2                	div    %dl
  709f50:	0f b6 c4             	movzbl %ah,%eax
  709f53:	41 c1 e7 08          	shl    $0x8,%r15d
  709f57:	41 09 c7             	or     %eax,%r15d
  709f5a:	66 45 39 e5          	cmp    %r12w,%r13w
  709f5e:	0f 84 0d fd ff ff    	je     709c71 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0xe1>
  709f64:	31 c0                	xor    %eax,%eax
  709f66:	45 89 ec             	mov    %r13d,%r12d
  709f69:	49 8b 96 60 06 00 00 	mov    0x660(%r14),%rdx
  709f70:	48 ff c2             	inc    %rdx
  709f73:	0f 84 a8 06 00 00    	je     70a621 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0xa91>
  709f79:	41 0f b7 cf          	movzwl %r15w,%ecx
  709f7d:	66 44 89 65 10       	mov    %r12w,0x10(%rbp)
  709f82:	88 4d 16             	mov    %cl,0x16(%rbp)
  709f85:	88 6d 12             	mov    %ch,0x12(%rbp)
  709f88:	c6 45 13 ff          	movb   $0xff,0x13(%rbp)
  709f8c:	84 c0                	test   %al,%al
  709f8e:	0f 85 11 03 00 00    	jne    70a2a5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x715>
  709f94:	49 8b 86 10 06 00 00 	mov    0x610(%r14),%rax
  709f9b:	48 85 c0             	test   %rax,%rax
  709f9e:	0f 84 da 06 00 00    	je     70a67e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0xaee>
  709fa4:	48 83 b8 d8 00 00 00 	cmpq   $0x0,0xd8(%rax)
  709fab:	00 
  709fac:	0f 84 cc 06 00 00    	je     70a67e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0xaee>
  709fb2:	4d 8b be a0 02 00 00 	mov    0x2a0(%r14),%r15
  709fb9:	49 83 ff 1c          	cmp    $0x1c,%r15
  709fbd:	0f 82 bb 06 00 00    	jb     70a67e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0xaee>
  709fc3:	48 89 54 24 60       	mov    %rdx,0x60(%rsp)
  709fc8:	41 0f b7 fc          	movzwl %r12w,%edi
  709fcc:	48 89 7c 24 18       	mov    %rdi,0x18(%rsp)
  709fd1:	ff 15 a9 f5 41 00    	call   *0x41f5a9(%rip)        # b29580 <_DYNAMIC+0x4f8>
  709fd7:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  709fdc:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
  709fe1:	49 8d 7f f7          	lea    -0x9(%r15),%rdi
  709fe5:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  709fec:	48 39 f7             	cmp    %rsi,%rdi
  709fef:	0f 83 99 06 00 00    	jae    70a68e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0xafe>
  709ff5:	49 8b 8e 98 02 00 00 	mov    0x298(%r14),%rcx
  709ffc:	48 8d 14 bf          	lea    (%rdi,%rdi,4),%rdx
  70a000:	4c 8d 24 d1          	lea    (%rcx,%rdx,8),%r12
  70a004:	48 8b 6c d1 08       	mov    0x8(%rcx,%rdx,8),%rbp
  70a009:	48 85 ed             	test   %rbp,%rbp
  70a00c:	74 36                	je     70a044 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x4b4>
  70a00e:	4c 8b 6c d1 10       	mov    0x10(%rcx,%rdx,8),%r13
  70a013:	49 8b 45 00          	mov    0x0(%r13),%rax
  70a017:	48 85 c0             	test   %rax,%rax
  70a01a:	74 12                	je     70a02e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x49e>
  70a01c:	48 8d 0c d1          	lea    (%rcx,%rdx,8),%rcx
  70a020:	48 83 c1 08          	add    $0x8,%rcx
  70a024:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  70a029:	48 89 ef             	mov    %rbp,%rdi
  70a02c:	ff d0                	call   *%rax
  70a02e:	49 8b 75 08          	mov    0x8(%r13),%rsi
  70a032:	48 85 f6             	test   %rsi,%rsi
  70a035:	74 0d                	je     70a044 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x4b4>
  70a037:	49 8b 55 10          	mov    0x10(%r13),%rdx
  70a03b:	48 89 ef             	mov    %rbp,%rdi
  70a03e:	ff 15 8c f2 41 00    	call   *0x41f28c(%rip)        # b292d0 <_DYNAMIC+0x248>
  70a044:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  70a049:	49 89 44 24 08       	mov    %rax,0x8(%r12)
  70a04e:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  70a053:	49 89 44 24 10       	mov    %rax,0x10(%r12)
  70a058:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  70a05d:	8d b8 00 00 01 00    	lea    0x10000(%rax),%edi
  70a063:	ff 15 17 f5 41 00    	call   *0x41f517(%rip)        # b29580 <_DYNAMIC+0x4f8>
  70a069:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  70a06e:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
  70a073:	49 8d 7f f9          	lea    -0x7(%r15),%rdi
  70a077:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  70a07e:	48 39 f7             	cmp    %rsi,%rdi
  70a081:	0f 83 07 06 00 00    	jae    70a68e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0xafe>
  70a087:	49 8b 8e 98 02 00 00 	mov    0x298(%r14),%rcx
  70a08e:	48 8d 14 bf          	lea    (%rdi,%rdi,4),%rdx
  70a092:	4c 8d 24 d1          	lea    (%rcx,%rdx,8),%r12
  70a096:	48 8b 6c d1 08       	mov    0x8(%rcx,%rdx,8),%rbp
  70a09b:	48 85 ed             	test   %rbp,%rbp
  70a09e:	74 36                	je     70a0d6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x546>
  70a0a0:	4c 8b 6c d1 10       	mov    0x10(%rcx,%rdx,8),%r13
  70a0a5:	49 8b 45 00          	mov    0x0(%r13),%rax
  70a0a9:	48 85 c0             	test   %rax,%rax
  70a0ac:	74 12                	je     70a0c0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x530>
  70a0ae:	48 8d 0c d1          	lea    (%rcx,%rdx,8),%rcx
  70a0b2:	48 83 c1 08          	add    $0x8,%rcx
  70a0b6:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  70a0bb:	48 89 ef             	mov    %rbp,%rdi
  70a0be:	ff d0                	call   *%rax
  70a0c0:	49 8b 75 08          	mov    0x8(%r13),%rsi
  70a0c4:	48 85 f6             	test   %rsi,%rsi
  70a0c7:	74 0d                	je     70a0d6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x546>
  70a0c9:	49 8b 55 10          	mov    0x10(%r13),%rdx
  70a0cd:	48 89 ef             	mov    %rbp,%rdi
  70a0d0:	ff 15 fa f1 41 00    	call   *0x41f1fa(%rip)        # b292d0 <_DYNAMIC+0x248>
  70a0d6:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  70a0db:	49 89 44 24 08       	mov    %rax,0x8(%r12)
  70a0e0:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  70a0e5:	49 89 44 24 10       	mov    %rax,0x10(%r12)
  70a0ea:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  70a0ef:	8d b8 00 00 02 00    	lea    0x20000(%rax),%edi
  70a0f5:	ff 15 85 f4 41 00    	call   *0x41f485(%rip)        # b29580 <_DYNAMIC+0x4f8>
  70a0fb:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  70a100:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
  70a105:	49 8d 7f fa          	lea    -0x6(%r15),%rdi
  70a109:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  70a110:	48 39 f7             	cmp    %rsi,%rdi
  70a113:	0f 83 75 05 00 00    	jae    70a68e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0xafe>
  70a119:	49 8b 8e 98 02 00 00 	mov    0x298(%r14),%rcx
  70a120:	48 8d 14 bf          	lea    (%rdi,%rdi,4),%rdx
  70a124:	4c 8d 24 d1          	lea    (%rcx,%rdx,8),%r12
  70a128:	48 8b 6c d1 08       	mov    0x8(%rcx,%rdx,8),%rbp
  70a12d:	48 85 ed             	test   %rbp,%rbp
  70a130:	74 36                	je     70a168 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x5d8>
  70a132:	4c 8b 6c d1 10       	mov    0x10(%rcx,%rdx,8),%r13
  70a137:	49 8b 45 00          	mov    0x0(%r13),%rax
  70a13b:	48 85 c0             	test   %rax,%rax
  70a13e:	74 12                	je     70a152 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x5c2>
  70a140:	48 8d 0c d1          	lea    (%rcx,%rdx,8),%rcx
  70a144:	48 83 c1 08          	add    $0x8,%rcx
  70a148:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  70a14d:	48 89 ef             	mov    %rbp,%rdi
  70a150:	ff d0                	call   *%rax
  70a152:	49 8b 75 08          	mov    0x8(%r13),%rsi
  70a156:	48 85 f6             	test   %rsi,%rsi
  70a159:	74 0d                	je     70a168 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x5d8>
  70a15b:	49 8b 55 10          	mov    0x10(%r13),%rdx
  70a15f:	48 89 ef             	mov    %rbp,%rdi
  70a162:	ff 15 68 f1 41 00    	call   *0x41f168(%rip)        # b292d0 <_DYNAMIC+0x248>
  70a168:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  70a16d:	49 89 44 24 08       	mov    %rax,0x8(%r12)
  70a172:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  70a177:	49 89 44 24 10       	mov    %rax,0x10(%r12)
  70a17c:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  70a181:	8d b8 00 00 03 00    	lea    0x30000(%rax),%edi
  70a187:	ff 15 f3 f3 41 00    	call   *0x41f3f3(%rip)        # b29580 <_DYNAMIC+0x4f8>
  70a18d:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  70a192:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
  70a197:	49 8d 7f fb          	lea    -0x5(%r15),%rdi
  70a19b:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  70a1a2:	48 39 f7             	cmp    %rsi,%rdi
  70a1a5:	0f 83 e3 04 00 00    	jae    70a68e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0xafe>
  70a1ab:	49 8b 8e 98 02 00 00 	mov    0x298(%r14),%rcx
  70a1b2:	48 8d 14 bf          	lea    (%rdi,%rdi,4),%rdx
  70a1b6:	4c 8d 24 d1          	lea    (%rcx,%rdx,8),%r12
  70a1ba:	48 8b 6c d1 08       	mov    0x8(%rcx,%rdx,8),%rbp
  70a1bf:	48 85 ed             	test   %rbp,%rbp
  70a1c2:	74 36                	je     70a1fa <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x66a>
  70a1c4:	4c 8b 6c d1 10       	mov    0x10(%rcx,%rdx,8),%r13
  70a1c9:	49 8b 45 00          	mov    0x0(%r13),%rax
  70a1cd:	48 85 c0             	test   %rax,%rax
  70a1d0:	74 12                	je     70a1e4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x654>
  70a1d2:	48 8d 0c d1          	lea    (%rcx,%rdx,8),%rcx
  70a1d6:	48 83 c1 08          	add    $0x8,%rcx
  70a1da:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  70a1df:	48 89 ef             	mov    %rbp,%rdi
  70a1e2:	ff d0                	call   *%rax
  70a1e4:	49 8b 75 08          	mov    0x8(%r13),%rsi
  70a1e8:	48 85 f6             	test   %rsi,%rsi
  70a1eb:	74 0d                	je     70a1fa <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x66a>
  70a1ed:	49 8b 55 10          	mov    0x10(%r13),%rdx
  70a1f1:	48 89 ef             	mov    %rbp,%rdi
  70a1f4:	ff 15 d6 f0 41 00    	call   *0x41f0d6(%rip)        # b292d0 <_DYNAMIC+0x248>
  70a1fa:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  70a1ff:	49 89 44 24 08       	mov    %rax,0x8(%r12)
  70a204:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  70a209:	49 89 44 24 10       	mov    %rax,0x10(%r12)
  70a20e:	48 8b 7c 24 18       	mov    0x18(%rsp),%rdi
  70a213:	81 cf 00 00 04 00    	or     $0x40000,%edi
  70a219:	ff 15 61 f3 41 00    	call   *0x41f361(%rip)        # b29580 <_DYNAMIC+0x4f8>
  70a21f:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  70a224:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
  70a229:	49 83 c7 fc          	add    $0xfffffffffffffffc,%r15
  70a22d:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  70a234:	49 39 f7             	cmp    %rsi,%r15
  70a237:	0f 83 4e 04 00 00    	jae    70a68b <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0xafb>
  70a23d:	49 8b 8e 98 02 00 00 	mov    0x298(%r14),%rcx
  70a244:	4b 8d 14 bf          	lea    (%r15,%r15,4),%rdx
  70a248:	4c 8d 24 d1          	lea    (%rcx,%rdx,8),%r12
  70a24c:	48 8b 6c d1 08       	mov    0x8(%rcx,%rdx,8),%rbp
  70a251:	48 85 ed             	test   %rbp,%rbp
  70a254:	74 36                	je     70a28c <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x6fc>
  70a256:	4c 8b 6c d1 10       	mov    0x10(%rcx,%rdx,8),%r13
  70a25b:	49 8b 45 00          	mov    0x0(%r13),%rax
  70a25f:	48 85 c0             	test   %rax,%rax
  70a262:	74 12                	je     70a276 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x6e6>
  70a264:	48 8d 0c d1          	lea    (%rcx,%rdx,8),%rcx
  70a268:	48 83 c1 08          	add    $0x8,%rcx
  70a26c:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  70a271:	48 89 ef             	mov    %rbp,%rdi
  70a274:	ff d0                	call   *%rax
  70a276:	49 8b 75 08          	mov    0x8(%r13),%rsi
  70a27a:	48 85 f6             	test   %rsi,%rsi
  70a27d:	74 0d                	je     70a28c <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x6fc>
  70a27f:	49 8b 55 10          	mov    0x10(%r13),%rdx
  70a283:	48 89 ef             	mov    %rbp,%rdi
  70a286:	ff 15 44 f0 41 00    	call   *0x41f044(%rip)        # b292d0 <_DYNAMIC+0x248>
  70a28c:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  70a291:	49 89 44 24 08       	mov    %rax,0x8(%r12)
  70a296:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  70a29b:	49 89 44 24 10       	mov    %rax,0x10(%r12)
  70a2a0:	48 8b 54 24 60       	mov    0x60(%rsp),%rdx
  70a2a5:	49 89 96 60 06 00 00 	mov    %rdx,0x660(%r14)
  70a2ac:	49 ff 86 b0 06 00 00 	incq   0x6b0(%r14)
  70a2b3:	49 c7 86 08 07 00 00 	movq   $0x0,0x708(%r14)
  70a2ba:	00 00 00 00 
  70a2be:	41 c6 86 1f 07 00 00 	movb   $0x1,0x71f(%r14)
  70a2c5:	01 
  70a2c6:	48 89 df             	mov    %rbx,%rdi
  70a2c9:	4c 89 f6             	mov    %r14,%rsi
  70a2cc:	48 81 c4 28 01 00 00 	add    $0x128,%rsp
  70a2d3:	5b                   	pop    %rbx
  70a2d4:	41 5c                	pop    %r12
  70a2d6:	41 5d                	pop    %r13
  70a2d8:	41 5e                	pop    %r14
  70a2da:	41 5f                	pop    %r15
  70a2dc:	5d                   	pop    %rbp
  70a2dd:	e9 ae f1 01 00       	jmp    729490 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::present>
  70a2e2:	31 c9                	xor    %ecx,%ecx
  70a2e4:	49 8b b6 08 07 00 00 	mov    0x708(%r14),%rsi
  70a2eb:	48 89 4b 08          	mov    %rcx,0x8(%rbx)
  70a2ef:	48 89 53 10          	mov    %rdx,0x10(%rbx)
  70a2f3:	0f 11 43 18          	movups %xmm0,0x18(%rbx)
  70a2f7:	48 89 73 28          	mov    %rsi,0x28(%rbx)
  70a2fb:	88 43 30             	mov    %al,0x30(%rbx)
  70a2fe:	48 c7 03 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rbx)
  70a305:	48 8d 7c 24 68       	lea    0x68(%rsp),%rdi
  70a30a:	e8 e1 db fe ff       	call   6f7ef0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70a30f:	e9 11 f9 ff ff       	jmp    709c25 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x95>
  70a314:	48 8b 8c 24 f0 00 00 	mov    0xf0(%rsp),%rcx
  70a31b:	00 
  70a31c:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  70a323:	00 
  70a324:	0f 10 84 24 d0 00 00 	movups 0xd0(%rsp),%xmm0
  70a32b:	00 
  70a32c:	0f 10 8c 24 e0 00 00 	movups 0xe0(%rsp),%xmm1
  70a333:	00 
  70a334:	0f 11 8c 24 88 00 00 	movups %xmm1,0x88(%rsp)
  70a33b:	00 
  70a33c:	0f 11 44 24 78       	movups %xmm0,0x78(%rsp)
  70a341:	48 89 44 24 68       	mov    %rax,0x68(%rsp)
  70a346:	4c 89 64 24 70       	mov    %r12,0x70(%rsp)
  70a34b:	48 83 f8 11          	cmp    $0x11,%rax
  70a34f:	0f 84 49 fb ff ff    	je     709e9e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x30e>
  70a355:	eb 2d                	jmp    70a384 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x7f4>
  70a357:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  70a35c:	48 89 84 24 98 00 00 	mov    %rax,0x98(%rsp)
  70a363:	00 
  70a364:	0f 10 44 24 38       	movups 0x38(%rsp),%xmm0
  70a369:	0f 10 4c 24 48       	movups 0x48(%rsp),%xmm1
  70a36e:	0f 11 8c 24 88 00 00 	movups %xmm1,0x88(%rsp)
  70a375:	00 
  70a376:	0f 11 44 24 78       	movups %xmm0,0x78(%rsp)
  70a37b:	48 c7 44 24 68 1a 00 	movq   $0x1a,0x68(%rsp)
  70a382:	00 00 
  70a384:	48 8b 84 24 98 00 00 	mov    0x98(%rsp),%rax
  70a38b:	00 
  70a38c:	48 89 43 30          	mov    %rax,0x30(%rbx)
  70a390:	48 8b 44 24 68       	mov    0x68(%rsp),%rax
  70a395:	48 8b 4c 24 70       	mov    0x70(%rsp),%rcx
  70a39a:	0f 10 44 24 78       	movups 0x78(%rsp),%xmm0
  70a39f:	0f 10 8c 24 88 00 00 	movups 0x88(%rsp),%xmm1
  70a3a6:	00 
  70a3a7:	0f 11 4b 20          	movups %xmm1,0x20(%rbx)
  70a3ab:	0f 11 43 10          	movups %xmm0,0x10(%rbx)
  70a3af:	48 89 03             	mov    %rax,(%rbx)
  70a3b2:	48 89 4b 08          	mov    %rcx,0x8(%rbx)
  70a3b6:	e9 6a f8 ff ff       	jmp    709c25 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x95>
  70a3bb:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  70a3c2:	49 39 f4             	cmp    %rsi,%r12
  70a3c5:	0f 83 eb 02 00 00    	jae    70a6b6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0xb26>
  70a3cb:	49 8b 86 98 02 00 00 	mov    0x298(%r14),%rax
  70a3d2:	4b 8d 0c a4          	lea    (%r12,%r12,4),%rcx
  70a3d6:	44 8b 7c c8 18       	mov    0x18(%rax,%rcx,8),%r15d
  70a3db:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  70a3e0:	49 39 c7             	cmp    %rax,%r15
  70a3e3:	0f 84 2c f8 ff ff    	je     709c15 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x85>
  70a3e9:	48 c7 44 24 28 11 00 	movq   $0x11,0x28(%rsp)
  70a3f0:	00 00 
  70a3f2:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  70a3f7:	e8 f4 da fe ff       	call   6f7ef0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70a3fc:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  70a403:	4c 39 fe             	cmp    %r15,%rsi
  70a406:	0f 86 ba 02 00 00    	jbe    70a6c6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0xb36>
  70a40c:	49 8d be b0 05 00 00 	lea    0x5b0(%r14),%rdi
  70a413:	49 8b 86 98 02 00 00 	mov    0x298(%r14),%rax
  70a41a:	4b 8d 0c bf          	lea    (%r15,%r15,4),%rcx
  70a41e:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
  70a422:	ff 15 60 f1 41 00    	call   *0x41f160(%rip)        # b29588 <_DYNAMIC+0x500>
  70a428:	49 89 c7             	mov    %rax,%r15
  70a42b:	49 89 d4             	mov    %rdx,%r12
  70a42e:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  70a433:	4c 89 f6             	mov    %r14,%rsi
  70a436:	48 89 c2             	mov    %rax,%rdx
  70a439:	4c 89 e1             	mov    %r12,%rcx
  70a43c:	e8 af e6 ff ff       	call   708af0 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::inspector_app_index>
  70a441:	83 7c 24 28 fe       	cmpl   $0xfffffffe,0x28(%rsp)
  70a446:	75 5f                	jne    70a4a7 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x917>
  70a448:	48 89 df             	mov    %rbx,%rdi
  70a44b:	4c 89 f6             	mov    %r14,%rsi
  70a44e:	4c 89 fa             	mov    %r15,%rdx
  70a451:	4c 89 e1             	mov    %r12,%rcx
  70a454:	48 81 c4 28 01 00 00 	add    $0x128,%rsp
  70a45b:	5b                   	pop    %rbx
  70a45c:	41 5c                	pop    %r12
  70a45e:	41 5d                	pop    %r13
  70a460:	41 5e                	pop    %r14
  70a462:	41 5f                	pop    %r15
  70a464:	5d                   	pop    %rbp
  70a465:	e9 e6 02 00 00       	jmp    70a750 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::inspector_select>
  70a46a:	8b 4c 24 5c          	mov    0x5c(%rsp),%ecx
  70a46e:	89 4b 34             	mov    %ecx,0x34(%rbx)
  70a471:	0f 10 44 24 4c       	movups 0x4c(%rsp),%xmm0
  70a476:	0f 11 43 24          	movups %xmm0,0x24(%rbx)
  70a47a:	0f 10 84 24 cc 00 00 	movups 0xcc(%rsp),%xmm0
  70a481:	00 
  70a482:	0f 11 43 14          	movups %xmm0,0x14(%rbx)
  70a486:	0f 28 84 24 c0 00 00 	movaps 0xc0(%rsp),%xmm0
  70a48d:	00 
  70a48e:	0f 11 43 08          	movups %xmm0,0x8(%rbx)
  70a492:	48 89 03             	mov    %rax,(%rbx)
  70a495:	e9 8b f7 ff ff       	jmp    709c25 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x95>
  70a49a:	48 8d 3d ef 0b 3f 00 	lea    0x3f0bef(%rip),%rdi        # afb090 <__frame_dummy_init_array_entry+0x828>
  70a4a1:	ff 15 e9 ee 41 00    	call   *0x41eee9(%rip)        # b29390 <_DYNAMIC+0x308>
  70a4a7:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  70a4ac:	e8 3f da fe ff       	call   6f7ef0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70a4b1:	41 0f 10 86 60 06 00 	movups 0x660(%r14),%xmm0
  70a4b8:	00 
  70a4b9:	41 0f b6 86 20 07 00 	movzbl 0x720(%r14),%eax
  70a4c0:	00 
  70a4c1:	49 83 be 80 06 00 00 	cmpq   $0x0,0x680(%r14)
  70a4c8:	00 
  70a4c9:	74 1c                	je     70a4e7 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x957>
  70a4cb:	84 c0                	test   %al,%al
  70a4cd:	74 0a                	je     70a4d9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x949>
  70a4cf:	49 83 be 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%r14)
  70a4d6:	ff 
  70a4d7:	74 0e                	je     70a4e7 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x957>
  70a4d9:	49 8b 96 90 06 00 00 	mov    0x690(%r14),%rdx
  70a4e0:	b9 01 00 00 00       	mov    $0x1,%ecx
  70a4e5:	eb 02                	jmp    70a4e9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x959>
  70a4e7:	31 c9                	xor    %ecx,%ecx
  70a4e9:	49 8b b6 08 07 00 00 	mov    0x708(%r14),%rsi
  70a4f0:	48 89 4b 08          	mov    %rcx,0x8(%rbx)
  70a4f4:	48 89 53 10          	mov    %rdx,0x10(%rbx)
  70a4f8:	0f 11 43 18          	movups %xmm0,0x18(%rbx)
  70a4fc:	48 89 73 28          	mov    %rsi,0x28(%rbx)
  70a500:	e9 f0 f9 ff ff       	jmp    709ef5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x365>
  70a505:	83 f8 23             	cmp    $0x23,%eax
  70a508:	0f 85 eb 00 00 00    	jne    70a5f9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0xa69>
  70a50e:	8b 44 24 30          	mov    0x30(%rsp),%eax
  70a512:	83 f8 0d             	cmp    $0xd,%eax
  70a515:	0f 84 12 01 00 00    	je     70a62d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0xa9d>
  70a51b:	83 f8 0e             	cmp    $0xe,%eax
  70a51e:	0f 85 d5 00 00 00    	jne    70a5f9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0xa69>
  70a524:	ba 07 00 00 00       	mov    $0x7,%edx
  70a529:	e9 04 01 00 00       	jmp    70a632 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0xaa2>
  70a52e:	c6 84 24 a0 00 00 00 	movb   $0x0,0xa0(%rsp)
  70a535:	00 
  70a536:	c7 84 24 a4 00 00 00 	movl   $0x0,0xa4(%rsp)
  70a53d:	00 00 00 00 
  70a541:	48 8d b4 24 a0 00 00 	lea    0xa0(%rsp),%rsi
  70a548:	00 
  70a549:	8b 7c 24 08          	mov    0x8(%rsp),%edi
  70a54d:	ff 15 3d f0 41 00    	call   *0x41f03d(%rip)        # b29590 <_DYNAMIC+0x508>
  70a553:	66 85 c0             	test   %ax,%ax
  70a556:	74 2a                	je     70a582 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x9f2>
  70a558:	48 c1 e8 10          	shr    $0x10,%rax
  70a55c:	48 89 df             	mov    %rbx,%rdi
  70a55f:	4c 89 f6             	mov    %r14,%rsi
  70a562:	89 c2                	mov    %eax,%edx
  70a564:	48 81 c4 28 01 00 00 	add    $0x128,%rsp
  70a56b:	5b                   	pop    %rbx
  70a56c:	41 5c                	pop    %r12
  70a56e:	41 5d                	pop    %r13
  70a570:	41 5e                	pop    %r14
  70a572:	41 5f                	pop    %r15
  70a574:	5d                   	pop    %rbp
  70a575:	e9 f6 f4 ff ff       	jmp    709a70 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::reject_editor>
  70a57a:	c6 84 24 a0 00 00 00 	movb   $0xff,0xa0(%rsp)
  70a581:	ff 
  70a582:	4d 8b be 60 06 00 00 	mov    0x660(%r14),%r15
  70a589:	49 83 ff ff          	cmp    $0xffffffffffffffff,%r15
  70a58d:	0f 84 8e 00 00 00    	je     70a621 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0xa91>
  70a593:	48 c7 44 24 28 1f 00 	movq   $0x1f,0x28(%rsp)
  70a59a:	00 00 
  70a59c:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  70a5a1:	e8 4a d9 fe ff       	call   6f7ef0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70a5a6:	49 8b 86 10 06 00 00 	mov    0x610(%r14),%rax
  70a5ad:	48 85 c0             	test   %rax,%rax
  70a5b0:	0f 84 af 00 00 00    	je     70a665 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0xad5>
  70a5b6:	48 8b 80 d8 00 00 00 	mov    0xd8(%rax),%rax
  70a5bd:	48 85 c0             	test   %rax,%rax
  70a5c0:	0f 84 9f 00 00 00    	je     70a665 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0xad5>
  70a5c6:	49 ff c7             	inc    %r15
  70a5c9:	c6 40 13 ff          	movb   $0xff,0x13(%rax)
  70a5cd:	48 8d 84 24 a0 00 00 	lea    0xa0(%rsp),%rax
  70a5d4:	00 
  70a5d5:	48 89 04 24          	mov    %rax,(%rsp)
  70a5d9:	48 89 df             	mov    %rbx,%rdi
  70a5dc:	4c 89 f6             	mov    %r14,%rsi
  70a5df:	48 8b 54 24 60       	mov    0x60(%rsp),%rdx
  70a5e4:	4c 89 e1             	mov    %r12,%rcx
  70a5e7:	4d 89 f8             	mov    %r15,%r8
  70a5ea:	44 8b 4c 24 08       	mov    0x8(%rsp),%r9d
  70a5ef:	e8 0c 06 02 00       	call   72ac00 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::set_property_value_at>
  70a5f4:	e9 2c f6 ff ff       	jmp    709c25 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x95>
  70a5f9:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  70a5fe:	48 89 43 30          	mov    %rax,0x30(%rbx)
  70a602:	0f 10 44 24 28       	movups 0x28(%rsp),%xmm0
  70a607:	0f 10 4c 24 38       	movups 0x38(%rsp),%xmm1
  70a60c:	0f 10 54 24 48       	movups 0x48(%rsp),%xmm2
  70a611:	0f 11 53 20          	movups %xmm2,0x20(%rbx)
  70a615:	0f 11 4b 10          	movups %xmm1,0x10(%rbx)
  70a619:	0f 11 03             	movups %xmm0,(%rbx)
  70a61c:	e9 04 f6 ff ff       	jmp    709c25 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x95>
  70a621:	48 c7 03 1f 00 00 00 	movq   $0x1f,(%rbx)
  70a628:	e9 f8 f5 ff ff       	jmp    709c25 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x95>
  70a62d:	ba 06 00 00 00       	mov    $0x6,%edx
  70a632:	48 89 df             	mov    %rbx,%rdi
  70a635:	4c 89 f6             	mov    %r14,%rsi
  70a638:	e8 33 f4 ff ff       	call   709a70 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::reject_editor>
  70a63d:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  70a642:	e8 a9 d8 fe ff       	call   6f7ef0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70a647:	e9 d9 f5 ff ff       	jmp    709c25 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x95>
  70a64c:	48 8d 3d d1 fe 95 ff 	lea    -0x6a012f(%rip),%rdi        # 6a524 <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x32a7>
  70a653:	48 8d 15 ae 0a 3f 00 	lea    0x3f0aae(%rip),%rdx        # afb108 <__frame_dummy_init_array_entry+0x8a0>
  70a65a:	be 28 00 00 00       	mov    $0x28,%esi
  70a65f:	ff 15 33 ef 41 00    	call   *0x41ef33(%rip)        # b29598 <_DYNAMIC+0x510>
  70a665:	48 8d 3d f9 fe 95 ff 	lea    -0x6a0107(%rip),%rdi        # 6a565 <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x32e8>
  70a66c:	48 8d 15 a5 09 3f 00 	lea    0x3f09a5(%rip),%rdx        # afb018 <__frame_dummy_init_array_entry+0x7b0>
  70a673:	be 11 00 00 00       	mov    $0x11,%esi
  70a678:	ff 15 52 ed 41 00    	call   *0x41ed52(%rip)        # b293d0 <_DYNAMIC+0x348>
  70a67e:	48 8d 3d 23 0a 3f 00 	lea    0x3f0a23(%rip),%rdi        # afb0a8 <__frame_dummy_init_array_entry+0x840>
  70a685:	ff 15 05 ed 41 00    	call   *0x41ed05(%rip)        # b29390 <_DYNAMIC+0x308>
  70a68b:	4c 89 ff             	mov    %r15,%rdi
  70a68e:	48 8d 15 2b 0a 3f 00 	lea    0x3f0a2b(%rip),%rdx        # afb0c0 <__frame_dummy_init_array_entry+0x858>
  70a695:	ff 15 45 ed 41 00    	call   *0x41ed45(%rip)        # b293e0 <_DYNAMIC+0x358>
  70a69b:	0f 0b                	ud2
  70a69d:	48 8d 3d 80 fe 95 ff 	lea    -0x6a0180(%rip),%rdi        # 6a524 <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x32a7>
  70a6a4:	48 8d 15 75 0a 3f 00 	lea    0x3f0a75(%rip),%rdx        # afb120 <__frame_dummy_init_array_entry+0x8b8>
  70a6ab:	be 28 00 00 00       	mov    $0x28,%esi
  70a6b0:	ff 15 e2 ee 41 00    	call   *0x41eee2(%rip)        # b29598 <_DYNAMIC+0x510>
  70a6b6:	48 8d 15 1b 0a 3f 00 	lea    0x3f0a1b(%rip),%rdx        # afb0d8 <__frame_dummy_init_array_entry+0x870>
  70a6bd:	4c 89 e7             	mov    %r12,%rdi
  70a6c0:	ff 15 1a ed 41 00    	call   *0x41ed1a(%rip)        # b293e0 <_DYNAMIC+0x358>
  70a6c6:	48 8d 15 23 0a 3f 00 	lea    0x3f0a23(%rip),%rdx        # afb0f0 <__frame_dummy_init_array_entry+0x888>
  70a6cd:	4c 89 ff             	mov    %r15,%rdi
  70a6d0:	ff 15 0a ed 41 00    	call   *0x41ed0a(%rip)        # b293e0 <_DYNAMIC+0x358>
  70a6d6:	48 89 c3             	mov    %rax,%rbx
  70a6d9:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  70a6de:	e8 0d d8 fe ff       	call   6f7ef0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70a6e3:	48 89 df             	mov    %rbx,%rdi
  70a6e6:	e8 c5 ed 3e 00       	call   af94b0 <_Unwind_Resume@plt>
  70a6eb:	4c 8b 74 24 20       	mov    0x20(%rsp),%r14
  70a6f0:	48 89 c3             	mov    %rax,%rbx
  70a6f3:	49 8b 75 08          	mov    0x8(%r13),%rsi
  70a6f7:	48 85 f6             	test   %rsi,%rsi
  70a6fa:	74 0d                	je     70a709 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0xb79>
  70a6fc:	49 8b 55 10          	mov    0x10(%r13),%rdx
  70a700:	48 89 ef             	mov    %rbp,%rdi
  70a703:	ff 15 c7 eb 41 00    	call   *0x41ebc7(%rip)        # b292d0 <_DYNAMIC+0x248>
  70a709:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  70a70e:	49 89 06             	mov    %rax,(%r14)
  70a711:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  70a716:	49 89 44 24 10       	mov    %rax,0x10(%r12)
  70a71b:	48 89 df             	mov    %rbx,%rdi
  70a71e:	e8 8d ed 3e 00       	call   af94b0 <_Unwind_Resume@plt>
  70a723:	48 89 c3             	mov    %rax,%rbx
  70a726:	48 8b 7c 24 10       	mov    0x10(%rsp),%rdi
  70a72b:	48 8b 74 24 08       	mov    0x8(%rsp),%rsi
  70a730:	e8 3b a1 fe ff       	call   6f4870 <core::ptr::drop_glue::<core::option::Option<gpui::element::Handler>>>
  70a735:	48 89 df             	mov    %rbx,%rdi
  70a738:	e8 73 ed 3e 00       	call   af94b0 <_Unwind_Resume@plt>
  70a73d:	ff 15 bd eb 41 00    	call   *0x41ebbd(%rip)        # b29300 <_DYNAMIC+0x278>
