
/tmp/gpui-contained-owner-spike-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

0000000000709c20 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action>:
  709c20:	55                   	push   %rbp
  709c21:	41 57                	push   %r15
  709c23:	41 56                	push   %r14
  709c25:	41 55                	push   %r13
  709c27:	41 54                	push   %r12
  709c29:	53                   	push   %rbx
  709c2a:	48 81 ec 28 01 00 00 	sub    $0x128,%rsp
  709c31:	48 89 fb             	mov    %rdi,%rbx
  709c34:	80 be 22 07 00 00 00 	cmpb   $0x0,0x722(%rsi)
  709c3b:	74 09                	je     709c46 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x26>
  709c3d:	48 c7 03 0e 00 00 00 	movq   $0xe,(%rbx)
  709c44:	eb 6f                	jmp    709cb5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x95>
  709c46:	49 89 f6             	mov    %rsi,%r14
  709c49:	48 8b 86 10 06 00 00 	mov    0x610(%rsi),%rax
  709c50:	48 85 c0             	test   %rax,%rax
  709c53:	74 59                	je     709cae <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x8e>
  709c55:	48 83 b8 d8 00 00 00 	cmpq   $0x0,0xd8(%rax)
  709c5c:	00 
  709c5d:	74 4f                	je     709cae <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x8e>
  709c5f:	49 c7 86 08 07 00 00 	movq   $0x0,0x708(%r14)
  709c66:	00 00 00 00 
  709c6a:	48 8b a8 d8 00 00 00 	mov    0xd8(%rax),%rbp
  709c71:	48 85 ed             	test   %rbp,%rbp
  709c74:	0f 84 b0 08 00 00    	je     70a52a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x90a>
  709c7a:	44 0f b7 65 10       	movzwl 0x10(%rbp),%r12d
  709c7f:	0f b6 7d 16          	movzbl 0x16(%rbp),%edi
  709c83:	44 0f b6 45 12       	movzbl 0x12(%rbp),%r8d
  709c88:	89 c8                	mov    %ecx,%eax
  709c8a:	66 83 e8 0e          	sub    $0xe,%ax
  709c8e:	41 bf 03 00 00 00    	mov    $0x3,%r15d
  709c94:	44 0f 43 f8          	cmovae %eax,%r15d
  709c98:	66 41 83 ff 03       	cmp    $0x3,%r15w
  709c9d:	75 28                	jne    709cc7 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0xa7>
  709c9f:	66 41 39 cc          	cmp    %cx,%r12w
  709ca3:	74 22                	je     709cc7 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0xa7>
  709ca5:	48 c7 03 11 00 00 00 	movq   $0x11,(%rbx)
  709cac:	eb 07                	jmp    709cb5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x95>
  709cae:	48 c7 03 1a 00 00 00 	movq   $0x1a,(%rbx)
  709cb5:	48 81 c4 28 01 00 00 	add    $0x128,%rsp
  709cbc:	5b                   	pop    %rbx
  709cbd:	41 5c                	pop    %r12
  709cbf:	41 5d                	pop    %r13
  709cc1:	41 5e                	pop    %r14
  709cc3:	41 5f                	pop    %r15
  709cc5:	5d                   	pop    %rbp
  709cc6:	c3                   	ret
  709cc7:	41 89 cd             	mov    %ecx,%r13d
  709cca:	41 c1 ed 10          	shr    $0x10,%r13d
  709cce:	45 0f b7 cf          	movzwl %r15w,%r9d
  709cd2:	48 8d 05 bb 1b 95 ff 	lea    -0x6ae445(%rip),%rax        # 5b894 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x34>
  709cd9:	4a 63 34 88          	movslq (%rax,%r9,4),%rsi
  709cdd:	48 01 c6             	add    %rax,%rsi
  709ce0:	ff e6                	jmp    *%rsi
  709ce2:	44 0f b7 ff          	movzwl %di,%r15d
  709ce6:	41 81 cf 00 01 00 00 	or     $0x100,%r15d
  709ced:	eb 12                	jmp    709d01 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0xe1>
  709cef:	45 0f b7 f8          	movzwl %r8w,%r15d
  709cf3:	41 c1 e7 08          	shl    $0x8,%r15d
  709cf7:	66 45 39 e5          	cmp    %r12w,%r13w
  709cfb:	0f 85 f3 02 00 00    	jne    709ff4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x3d4>
  709d01:	b0 01                	mov    $0x1,%al
  709d03:	44 38 ff             	cmp    %r15b,%dil
  709d06:	0f 85 ed 02 00 00    	jne    709ff9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x3d9>
  709d0c:	41 0f b7 cf          	movzwl %r15w,%ecx
  709d10:	c1 e9 08             	shr    $0x8,%ecx
  709d13:	41 38 c8             	cmp    %cl,%r8b
  709d16:	0f 85 dd 02 00 00    	jne    709ff9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x3d9>
  709d1c:	80 7d 13 ff          	cmpb   $0xff,0x13(%rbp)
  709d20:	0f 85 d3 02 00 00    	jne    709ff9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x3d9>
  709d26:	e9 c4 01 00 00       	jmp    709eef <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x2cf>
  709d2b:	f7 c1 00 00 ff 00    	test   $0xff0000,%ecx
  709d31:	0f 84 5d 02 00 00    	je     709f94 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x374>
  709d37:	48 8b 45 00          	mov    0x0(%rbp),%rax
  709d3b:	48 85 c0             	test   %rax,%rax
  709d3e:	0f 84 ab 01 00 00    	je     709eef <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x2cf>
  709d44:	49 3b 86 b0 05 00 00 	cmp    0x5b0(%r14),%rax
  709d4b:	0f 85 d4 01 00 00    	jne    709f25 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x305>
  709d51:	4c 89 4c 24 18       	mov    %r9,0x18(%rsp)
  709d56:	48 89 7c 24 10       	mov    %rdi,0x10(%rsp)
  709d5b:	48 89 54 24 60       	mov    %rdx,0x60(%rsp)
  709d60:	89 4c 24 08          	mov    %ecx,0x8(%rsp)
  709d64:	4c 8b 65 08          	mov    0x8(%rbp),%r12
  709d68:	48 c7 44 24 28 11 00 	movq   $0x11,0x28(%rsp)
  709d6f:	00 00 
  709d71:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  709d76:	e8 65 e2 fe ff       	call   6f7fe0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  709d7b:	48 8d bc 24 c0 00 00 	lea    0xc0(%rsp),%rdi
  709d82:	00 
  709d83:	4c 89 f6             	mov    %r14,%rsi
  709d86:	4c 89 e2             	mov    %r12,%rdx
  709d89:	e8 22 ef 01 00       	call   728cb0 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::resolve_identity>
  709d8e:	48 8b 84 24 c0 00 00 	mov    0xc0(%rsp),%rax
  709d95:	00 
  709d96:	4c 8b a4 24 c8 00 00 	mov    0xc8(%rsp),%r12
  709d9d:	00 
  709d9e:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  709da2:	0f 85 fc 05 00 00    	jne    70a3a4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x784>
  709da8:	49 8b 86 10 06 00 00 	mov    0x610(%r14),%rax
  709daf:	48 85 c0             	test   %rax,%rax
  709db2:	0f 84 2f 06 00 00    	je     70a3e7 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x7c7>
  709db8:	48 83 b8 d8 00 00 00 	cmpq   $0x0,0xd8(%rax)
  709dbf:	00 
  709dc0:	0f 84 21 06 00 00    	je     70a3e7 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x7c7>
  709dc6:	49 8b ae a0 02 00 00 	mov    0x2a0(%r14),%rbp
  709dcd:	48 c7 44 24 28 1a 00 	movq   $0x1a,0x28(%rsp)
  709dd4:	00 00 
  709dd6:	48 83 fd 1c          	cmp    $0x1c,%rbp
  709dda:	0f 82 07 06 00 00    	jb     70a3e7 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x7c7>
  709de0:	48 83 c5 e4          	add    $0xffffffffffffffe4,%rbp
  709de4:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  709de9:	e8 f2 e1 fe ff       	call   6f7fe0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  709dee:	49 83 fc 02          	cmp    $0x2,%r12
  709df2:	0f 93 c0             	setae  %al
  709df5:	49 39 ec             	cmp    %rbp,%r12
  709df8:	0f 92 c1             	setb   %cl
  709dfb:	84 c8                	test   %cl,%al
  709dfd:	0f 84 22 01 00 00    	je     709f25 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x305>
  709e03:	66 41 83 ff 01       	cmp    $0x1,%r15w
  709e08:	0f 84 3d 06 00 00    	je     70a44b <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x82b>
  709e0e:	83 7c 24 18 03       	cmpl   $0x3,0x18(%rsp)
  709e13:	0f 85 c3 08 00 00    	jne    70a6dc <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0xabc>
  709e19:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  709e1e:	4c 89 f6             	mov    %r14,%rsi
  709e21:	4c 89 e2             	mov    %r12,%rdx
  709e24:	8b 4c 24 08          	mov    0x8(%rsp),%ecx
  709e28:	e8 63 fd 01 00       	call   729b90 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::property_value_at>
  709e2d:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  709e32:	0f 10 44 24 30       	movups 0x30(%rsp),%xmm0
  709e37:	0f 29 84 24 c0 00 00 	movaps %xmm0,0xc0(%rsp)
  709e3e:	00 
  709e3f:	0f 10 44 24 3c       	movups 0x3c(%rsp),%xmm0
  709e44:	0f 11 84 24 cc 00 00 	movups %xmm0,0xcc(%rsp)
  709e4b:	00 
  709e4c:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  709e50:	0f 85 a4 06 00 00    	jne    70a4fa <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x8da>
  709e56:	0f 28 84 24 c0 00 00 	movaps 0xc0(%rsp),%xmm0
  709e5d:	00 
  709e5e:	0f 29 84 24 00 01 00 	movaps %xmm0,0x100(%rsp)
  709e65:	00 
  709e66:	0f 10 84 24 cc 00 00 	movups 0xcc(%rsp),%xmm0
  709e6d:	00 
  709e6e:	0f 11 84 24 0c 01 00 	movups %xmm0,0x10c(%rsp)
  709e75:	00 
  709e76:	41 0f b6 c5          	movzbl %r13b,%eax
  709e7a:	48 8d 0d 23 1a 95 ff 	lea    -0x6ae5dd(%rip),%rcx        # 5b8a4 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x44>
  709e81:	48 63 04 81          	movslq (%rcx,%rax,4),%rax
  709e85:	48 01 c8             	add    %rcx,%rax
  709e88:	ff e0                	jmp    *%rax
  709e8a:	8b 44 24 08          	mov    0x8(%rsp),%eax
  709e8e:	25 00 00 ff 00       	and    $0xff0000,%eax
  709e93:	31 c9                	xor    %ecx,%ecx
  709e95:	3d 00 00 02 00       	cmp    $0x20000,%eax
  709e9a:	0f 94 c1             	sete   %cl
  709e9d:	48 8d 05 74 17 95 ff 	lea    -0x6ae88c(%rip),%rax        # 5b618 <anon.079f5e587c394fcac2765eb4d0cf0bc2.21.llvm.6319143315422321905+0x48>
  709ea4:	f3 0f 10 04 88       	movss  (%rax,%rcx,4),%xmm0
  709ea9:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  709eae:	48 8d b4 24 00 01 00 	lea    0x100(%rsp),%rsi
  709eb5:	00 
  709eb6:	48 8b 54 24 10       	mov    0x10(%rsp),%rdx
  709ebb:	ff 15 2f f7 41 00    	call   *0x41f72f(%rip)        # b295f0 <_DYNAMIC+0x4f0>
  709ec1:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  709ec6:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  709eca:	0f 85 c5 06 00 00    	jne    70a595 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x975>
  709ed0:	0f 10 44 24 30       	movups 0x30(%rsp),%xmm0
  709ed5:	0f 10 4c 24 3c       	movups 0x3c(%rsp),%xmm1
  709eda:	0f 11 8c 24 ac 00 00 	movups %xmm1,0xac(%rsp)
  709ee1:	00 
  709ee2:	0f 29 84 24 a0 00 00 	movaps %xmm0,0xa0(%rsp)
  709ee9:	00 
  709eea:	e9 e2 06 00 00       	jmp    70a5d1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x9b1>
  709eef:	41 0f 10 86 60 06 00 	movups 0x660(%r14),%xmm0
  709ef6:	00 
  709ef7:	41 0f b6 86 20 07 00 	movzbl 0x720(%r14),%eax
  709efe:	00 
  709eff:	49 83 be 80 06 00 00 	cmpq   $0x0,0x680(%r14)
  709f06:	00 
  709f07:	74 66                	je     709f6f <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x34f>
  709f09:	84 c0                	test   %al,%al
  709f0b:	74 0a                	je     709f17 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x2f7>
  709f0d:	49 83 be 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%r14)
  709f14:	ff 
  709f15:	74 58                	je     709f6f <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x34f>
  709f17:	49 8b 96 90 06 00 00 	mov    0x690(%r14),%rdx
  709f1e:	b9 01 00 00 00       	mov    $0x1,%ecx
  709f23:	eb 4c                	jmp    709f71 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x351>
  709f25:	48 c7 44 24 68 11 00 	movq   $0x11,0x68(%rsp)
  709f2c:	00 00 
  709f2e:	41 0f 10 86 60 06 00 	movups 0x660(%r14),%xmm0
  709f35:	00 
  709f36:	41 0f b6 86 20 07 00 	movzbl 0x720(%r14),%eax
  709f3d:	00 
  709f3e:	49 83 be 80 06 00 00 	cmpq   $0x0,0x680(%r14)
  709f45:	00 
  709f46:	0f 84 26 04 00 00    	je     70a372 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x752>
  709f4c:	84 c0                	test   %al,%al
  709f4e:	74 0e                	je     709f5e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x33e>
  709f50:	49 83 be 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%r14)
  709f57:	ff 
  709f58:	0f 84 14 04 00 00    	je     70a372 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x752>
  709f5e:	49 8b 96 90 06 00 00 	mov    0x690(%r14),%rdx
  709f65:	b9 01 00 00 00       	mov    $0x1,%ecx
  709f6a:	e9 05 04 00 00       	jmp    70a374 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x754>
  709f6f:	31 c9                	xor    %ecx,%ecx
  709f71:	48 89 4b 08          	mov    %rcx,0x8(%rbx)
  709f75:	48 89 53 10          	mov    %rdx,0x10(%rbx)
  709f79:	0f 11 43 18          	movups %xmm0,0x18(%rbx)
  709f7d:	48 c7 43 28 00 00 00 	movq   $0x0,0x28(%rbx)
  709f84:	00 
  709f85:	88 43 30             	mov    %al,0x30(%rbx)
  709f88:	48 c7 03 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rbx)
  709f8f:	e9 21 fd ff ff       	jmp    709cb5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x95>
  709f94:	45 0f b7 f8          	movzwl %r8w,%r15d
  709f98:	8d 47 01             	lea    0x1(%rdi),%eax
  709f9b:	89 44 24 18          	mov    %eax,0x18(%rsp)
  709f9f:	48 89 7c 24 10       	mov    %rdi,0x10(%rsp)
  709fa4:	89 cf                	mov    %ecx,%edi
  709fa6:	89 4c 24 08          	mov    %ecx,0x8(%rsp)
  709faa:	45 89 c5             	mov    %r8d,%r13d
  709fad:	e8 ae ab ff ff       	call   704b60 <<gpui::property::PropertyId>::info>
  709fb2:	45 89 e8             	mov    %r13d,%r8d
  709fb5:	48 8b 7c 24 10       	mov    0x10(%rsp),%rdi
  709fba:	44 8b 6c 24 08       	mov    0x8(%rsp),%r13d
  709fbf:	0f b6 40 14          	movzbl 0x14(%rax),%eax
  709fc3:	31 c9                	xor    %ecx,%ecx
  709fc5:	3c 04                	cmp    $0x4,%al
  709fc7:	0f 94 c1             	sete   %cl
  709fca:	8d 0c 89             	lea    (%rcx,%rcx,4),%ecx
  709fcd:	ff c1                	inc    %ecx
  709fcf:	3c 02                	cmp    $0x2,%al
  709fd1:	ba 04 00 00 00       	mov    $0x4,%edx
  709fd6:	0f 45 d1             	cmovne %ecx,%edx
  709fd9:	0f b6 44 24 18       	movzbl 0x18(%rsp),%eax
  709fde:	f6 f2                	div    %dl
  709fe0:	0f b6 c4             	movzbl %ah,%eax
  709fe3:	41 c1 e7 08          	shl    $0x8,%r15d
  709fe7:	41 09 c7             	or     %eax,%r15d
  709fea:	66 45 39 e5          	cmp    %r12w,%r13w
  709fee:	0f 84 0d fd ff ff    	je     709d01 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0xe1>
  709ff4:	31 c0                	xor    %eax,%eax
  709ff6:	45 89 ec             	mov    %r13d,%r12d
  709ff9:	49 8b 96 60 06 00 00 	mov    0x660(%r14),%rdx
  70a000:	48 ff c2             	inc    %rdx
  70a003:	0f 84 a8 06 00 00    	je     70a6b1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0xa91>
  70a009:	41 0f b7 cf          	movzwl %r15w,%ecx
  70a00d:	66 44 89 65 10       	mov    %r12w,0x10(%rbp)
  70a012:	88 4d 16             	mov    %cl,0x16(%rbp)
  70a015:	88 6d 12             	mov    %ch,0x12(%rbp)
  70a018:	c6 45 13 ff          	movb   $0xff,0x13(%rbp)
  70a01c:	84 c0                	test   %al,%al
  70a01e:	0f 85 11 03 00 00    	jne    70a335 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x715>
  70a024:	49 8b 86 10 06 00 00 	mov    0x610(%r14),%rax
  70a02b:	48 85 c0             	test   %rax,%rax
  70a02e:	0f 84 da 06 00 00    	je     70a70e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0xaee>
  70a034:	48 83 b8 d8 00 00 00 	cmpq   $0x0,0xd8(%rax)
  70a03b:	00 
  70a03c:	0f 84 cc 06 00 00    	je     70a70e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0xaee>
  70a042:	4d 8b be a0 02 00 00 	mov    0x2a0(%r14),%r15
  70a049:	49 83 ff 1c          	cmp    $0x1c,%r15
  70a04d:	0f 82 bb 06 00 00    	jb     70a70e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0xaee>
  70a053:	48 89 54 24 60       	mov    %rdx,0x60(%rsp)
  70a058:	41 0f b7 fc          	movzwl %r12w,%edi
  70a05c:	48 89 7c 24 18       	mov    %rdi,0x18(%rsp)
  70a061:	ff 15 91 f5 41 00    	call   *0x41f591(%rip)        # b295f8 <_DYNAMIC+0x4f8>
  70a067:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  70a06c:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
  70a071:	49 8d 7f f7          	lea    -0x9(%r15),%rdi
  70a075:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  70a07c:	48 39 f7             	cmp    %rsi,%rdi
  70a07f:	0f 83 99 06 00 00    	jae    70a71e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0xafe>
  70a085:	49 8b 8e 98 02 00 00 	mov    0x298(%r14),%rcx
  70a08c:	48 8d 14 bf          	lea    (%rdi,%rdi,4),%rdx
  70a090:	4c 8d 24 d1          	lea    (%rcx,%rdx,8),%r12
  70a094:	48 8b 6c d1 08       	mov    0x8(%rcx,%rdx,8),%rbp
  70a099:	48 85 ed             	test   %rbp,%rbp
  70a09c:	74 36                	je     70a0d4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x4b4>
  70a09e:	4c 8b 6c d1 10       	mov    0x10(%rcx,%rdx,8),%r13
  70a0a3:	49 8b 45 00          	mov    0x0(%r13),%rax
  70a0a7:	48 85 c0             	test   %rax,%rax
  70a0aa:	74 12                	je     70a0be <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x49e>
  70a0ac:	48 8d 0c d1          	lea    (%rcx,%rdx,8),%rcx
  70a0b0:	48 83 c1 08          	add    $0x8,%rcx
  70a0b4:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  70a0b9:	48 89 ef             	mov    %rbp,%rdi
  70a0bc:	ff d0                	call   *%rax
  70a0be:	49 8b 75 08          	mov    0x8(%r13),%rsi
  70a0c2:	48 85 f6             	test   %rsi,%rsi
  70a0c5:	74 0d                	je     70a0d4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x4b4>
  70a0c7:	49 8b 55 10          	mov    0x10(%r13),%rdx
  70a0cb:	48 89 ef             	mov    %rbp,%rdi
  70a0ce:	ff 15 74 f2 41 00    	call   *0x41f274(%rip)        # b29348 <_DYNAMIC+0x248>
  70a0d4:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  70a0d9:	49 89 44 24 08       	mov    %rax,0x8(%r12)
  70a0de:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  70a0e3:	49 89 44 24 10       	mov    %rax,0x10(%r12)
  70a0e8:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  70a0ed:	8d b8 00 00 01 00    	lea    0x10000(%rax),%edi
  70a0f3:	ff 15 ff f4 41 00    	call   *0x41f4ff(%rip)        # b295f8 <_DYNAMIC+0x4f8>
  70a0f9:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  70a0fe:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
  70a103:	49 8d 7f f9          	lea    -0x7(%r15),%rdi
  70a107:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  70a10e:	48 39 f7             	cmp    %rsi,%rdi
  70a111:	0f 83 07 06 00 00    	jae    70a71e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0xafe>
  70a117:	49 8b 8e 98 02 00 00 	mov    0x298(%r14),%rcx
  70a11e:	48 8d 14 bf          	lea    (%rdi,%rdi,4),%rdx
  70a122:	4c 8d 24 d1          	lea    (%rcx,%rdx,8),%r12
  70a126:	48 8b 6c d1 08       	mov    0x8(%rcx,%rdx,8),%rbp
  70a12b:	48 85 ed             	test   %rbp,%rbp
  70a12e:	74 36                	je     70a166 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x546>
  70a130:	4c 8b 6c d1 10       	mov    0x10(%rcx,%rdx,8),%r13
  70a135:	49 8b 45 00          	mov    0x0(%r13),%rax
  70a139:	48 85 c0             	test   %rax,%rax
  70a13c:	74 12                	je     70a150 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x530>
  70a13e:	48 8d 0c d1          	lea    (%rcx,%rdx,8),%rcx
  70a142:	48 83 c1 08          	add    $0x8,%rcx
  70a146:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  70a14b:	48 89 ef             	mov    %rbp,%rdi
  70a14e:	ff d0                	call   *%rax
  70a150:	49 8b 75 08          	mov    0x8(%r13),%rsi
  70a154:	48 85 f6             	test   %rsi,%rsi
  70a157:	74 0d                	je     70a166 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x546>
  70a159:	49 8b 55 10          	mov    0x10(%r13),%rdx
  70a15d:	48 89 ef             	mov    %rbp,%rdi
  70a160:	ff 15 e2 f1 41 00    	call   *0x41f1e2(%rip)        # b29348 <_DYNAMIC+0x248>
  70a166:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  70a16b:	49 89 44 24 08       	mov    %rax,0x8(%r12)
  70a170:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  70a175:	49 89 44 24 10       	mov    %rax,0x10(%r12)
  70a17a:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  70a17f:	8d b8 00 00 02 00    	lea    0x20000(%rax),%edi
  70a185:	ff 15 6d f4 41 00    	call   *0x41f46d(%rip)        # b295f8 <_DYNAMIC+0x4f8>
  70a18b:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  70a190:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
  70a195:	49 8d 7f fa          	lea    -0x6(%r15),%rdi
  70a199:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  70a1a0:	48 39 f7             	cmp    %rsi,%rdi
  70a1a3:	0f 83 75 05 00 00    	jae    70a71e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0xafe>
  70a1a9:	49 8b 8e 98 02 00 00 	mov    0x298(%r14),%rcx
  70a1b0:	48 8d 14 bf          	lea    (%rdi,%rdi,4),%rdx
  70a1b4:	4c 8d 24 d1          	lea    (%rcx,%rdx,8),%r12
  70a1b8:	48 8b 6c d1 08       	mov    0x8(%rcx,%rdx,8),%rbp
  70a1bd:	48 85 ed             	test   %rbp,%rbp
  70a1c0:	74 36                	je     70a1f8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x5d8>
  70a1c2:	4c 8b 6c d1 10       	mov    0x10(%rcx,%rdx,8),%r13
  70a1c7:	49 8b 45 00          	mov    0x0(%r13),%rax
  70a1cb:	48 85 c0             	test   %rax,%rax
  70a1ce:	74 12                	je     70a1e2 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x5c2>
  70a1d0:	48 8d 0c d1          	lea    (%rcx,%rdx,8),%rcx
  70a1d4:	48 83 c1 08          	add    $0x8,%rcx
  70a1d8:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  70a1dd:	48 89 ef             	mov    %rbp,%rdi
  70a1e0:	ff d0                	call   *%rax
  70a1e2:	49 8b 75 08          	mov    0x8(%r13),%rsi
  70a1e6:	48 85 f6             	test   %rsi,%rsi
  70a1e9:	74 0d                	je     70a1f8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x5d8>
  70a1eb:	49 8b 55 10          	mov    0x10(%r13),%rdx
  70a1ef:	48 89 ef             	mov    %rbp,%rdi
  70a1f2:	ff 15 50 f1 41 00    	call   *0x41f150(%rip)        # b29348 <_DYNAMIC+0x248>
  70a1f8:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  70a1fd:	49 89 44 24 08       	mov    %rax,0x8(%r12)
  70a202:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  70a207:	49 89 44 24 10       	mov    %rax,0x10(%r12)
  70a20c:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  70a211:	8d b8 00 00 03 00    	lea    0x30000(%rax),%edi
  70a217:	ff 15 db f3 41 00    	call   *0x41f3db(%rip)        # b295f8 <_DYNAMIC+0x4f8>
  70a21d:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  70a222:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
  70a227:	49 8d 7f fb          	lea    -0x5(%r15),%rdi
  70a22b:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  70a232:	48 39 f7             	cmp    %rsi,%rdi
  70a235:	0f 83 e3 04 00 00    	jae    70a71e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0xafe>
  70a23b:	49 8b 8e 98 02 00 00 	mov    0x298(%r14),%rcx
  70a242:	48 8d 14 bf          	lea    (%rdi,%rdi,4),%rdx
  70a246:	4c 8d 24 d1          	lea    (%rcx,%rdx,8),%r12
  70a24a:	48 8b 6c d1 08       	mov    0x8(%rcx,%rdx,8),%rbp
  70a24f:	48 85 ed             	test   %rbp,%rbp
  70a252:	74 36                	je     70a28a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x66a>
  70a254:	4c 8b 6c d1 10       	mov    0x10(%rcx,%rdx,8),%r13
  70a259:	49 8b 45 00          	mov    0x0(%r13),%rax
  70a25d:	48 85 c0             	test   %rax,%rax
  70a260:	74 12                	je     70a274 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x654>
  70a262:	48 8d 0c d1          	lea    (%rcx,%rdx,8),%rcx
  70a266:	48 83 c1 08          	add    $0x8,%rcx
  70a26a:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  70a26f:	48 89 ef             	mov    %rbp,%rdi
  70a272:	ff d0                	call   *%rax
  70a274:	49 8b 75 08          	mov    0x8(%r13),%rsi
  70a278:	48 85 f6             	test   %rsi,%rsi
  70a27b:	74 0d                	je     70a28a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x66a>
  70a27d:	49 8b 55 10          	mov    0x10(%r13),%rdx
  70a281:	48 89 ef             	mov    %rbp,%rdi
  70a284:	ff 15 be f0 41 00    	call   *0x41f0be(%rip)        # b29348 <_DYNAMIC+0x248>
  70a28a:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  70a28f:	49 89 44 24 08       	mov    %rax,0x8(%r12)
  70a294:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  70a299:	49 89 44 24 10       	mov    %rax,0x10(%r12)
  70a29e:	48 8b 7c 24 18       	mov    0x18(%rsp),%rdi
  70a2a3:	81 cf 00 00 04 00    	or     $0x40000,%edi
  70a2a9:	ff 15 49 f3 41 00    	call   *0x41f349(%rip)        # b295f8 <_DYNAMIC+0x4f8>
  70a2af:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  70a2b4:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
  70a2b9:	49 83 c7 fc          	add    $0xfffffffffffffffc,%r15
  70a2bd:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  70a2c4:	49 39 f7             	cmp    %rsi,%r15
  70a2c7:	0f 83 4e 04 00 00    	jae    70a71b <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0xafb>
  70a2cd:	49 8b 8e 98 02 00 00 	mov    0x298(%r14),%rcx
  70a2d4:	4b 8d 14 bf          	lea    (%r15,%r15,4),%rdx
  70a2d8:	4c 8d 24 d1          	lea    (%rcx,%rdx,8),%r12
  70a2dc:	48 8b 6c d1 08       	mov    0x8(%rcx,%rdx,8),%rbp
  70a2e1:	48 85 ed             	test   %rbp,%rbp
  70a2e4:	74 36                	je     70a31c <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x6fc>
  70a2e6:	4c 8b 6c d1 10       	mov    0x10(%rcx,%rdx,8),%r13
  70a2eb:	49 8b 45 00          	mov    0x0(%r13),%rax
  70a2ef:	48 85 c0             	test   %rax,%rax
  70a2f2:	74 12                	je     70a306 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x6e6>
  70a2f4:	48 8d 0c d1          	lea    (%rcx,%rdx,8),%rcx
  70a2f8:	48 83 c1 08          	add    $0x8,%rcx
  70a2fc:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  70a301:	48 89 ef             	mov    %rbp,%rdi
  70a304:	ff d0                	call   *%rax
  70a306:	49 8b 75 08          	mov    0x8(%r13),%rsi
  70a30a:	48 85 f6             	test   %rsi,%rsi
  70a30d:	74 0d                	je     70a31c <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x6fc>
  70a30f:	49 8b 55 10          	mov    0x10(%r13),%rdx
  70a313:	48 89 ef             	mov    %rbp,%rdi
  70a316:	ff 15 2c f0 41 00    	call   *0x41f02c(%rip)        # b29348 <_DYNAMIC+0x248>
  70a31c:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  70a321:	49 89 44 24 08       	mov    %rax,0x8(%r12)
  70a326:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  70a32b:	49 89 44 24 10       	mov    %rax,0x10(%r12)
  70a330:	48 8b 54 24 60       	mov    0x60(%rsp),%rdx
  70a335:	49 89 96 60 06 00 00 	mov    %rdx,0x660(%r14)
  70a33c:	49 ff 86 b0 06 00 00 	incq   0x6b0(%r14)
  70a343:	49 c7 86 08 07 00 00 	movq   $0x0,0x708(%r14)
  70a34a:	00 00 00 00 
  70a34e:	41 c6 86 1f 07 00 00 	movb   $0x1,0x71f(%r14)
  70a355:	01 
  70a356:	48 89 df             	mov    %rbx,%rdi
  70a359:	4c 89 f6             	mov    %r14,%rsi
  70a35c:	48 81 c4 28 01 00 00 	add    $0x128,%rsp
  70a363:	5b                   	pop    %rbx
  70a364:	41 5c                	pop    %r12
  70a366:	41 5d                	pop    %r13
  70a368:	41 5e                	pop    %r14
  70a36a:	41 5f                	pop    %r15
  70a36c:	5d                   	pop    %rbp
  70a36d:	e9 ae f1 01 00       	jmp    729520 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::present>
  70a372:	31 c9                	xor    %ecx,%ecx
  70a374:	49 8b b6 08 07 00 00 	mov    0x708(%r14),%rsi
  70a37b:	48 89 4b 08          	mov    %rcx,0x8(%rbx)
  70a37f:	48 89 53 10          	mov    %rdx,0x10(%rbx)
  70a383:	0f 11 43 18          	movups %xmm0,0x18(%rbx)
  70a387:	48 89 73 28          	mov    %rsi,0x28(%rbx)
  70a38b:	88 43 30             	mov    %al,0x30(%rbx)
  70a38e:	48 c7 03 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rbx)
  70a395:	48 8d 7c 24 68       	lea    0x68(%rsp),%rdi
  70a39a:	e8 41 dc fe ff       	call   6f7fe0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70a39f:	e9 11 f9 ff ff       	jmp    709cb5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x95>
  70a3a4:	48 8b 8c 24 f0 00 00 	mov    0xf0(%rsp),%rcx
  70a3ab:	00 
  70a3ac:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  70a3b3:	00 
  70a3b4:	0f 10 84 24 d0 00 00 	movups 0xd0(%rsp),%xmm0
  70a3bb:	00 
  70a3bc:	0f 10 8c 24 e0 00 00 	movups 0xe0(%rsp),%xmm1
  70a3c3:	00 
  70a3c4:	0f 11 8c 24 88 00 00 	movups %xmm1,0x88(%rsp)
  70a3cb:	00 
  70a3cc:	0f 11 44 24 78       	movups %xmm0,0x78(%rsp)
  70a3d1:	48 89 44 24 68       	mov    %rax,0x68(%rsp)
  70a3d6:	4c 89 64 24 70       	mov    %r12,0x70(%rsp)
  70a3db:	48 83 f8 11          	cmp    $0x11,%rax
  70a3df:	0f 84 49 fb ff ff    	je     709f2e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x30e>
  70a3e5:	eb 2d                	jmp    70a414 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x7f4>
  70a3e7:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  70a3ec:	48 89 84 24 98 00 00 	mov    %rax,0x98(%rsp)
  70a3f3:	00 
  70a3f4:	0f 10 44 24 38       	movups 0x38(%rsp),%xmm0
  70a3f9:	0f 10 4c 24 48       	movups 0x48(%rsp),%xmm1
  70a3fe:	0f 11 8c 24 88 00 00 	movups %xmm1,0x88(%rsp)
  70a405:	00 
  70a406:	0f 11 44 24 78       	movups %xmm0,0x78(%rsp)
  70a40b:	48 c7 44 24 68 1a 00 	movq   $0x1a,0x68(%rsp)
  70a412:	00 00 
  70a414:	48 8b 84 24 98 00 00 	mov    0x98(%rsp),%rax
  70a41b:	00 
  70a41c:	48 89 43 30          	mov    %rax,0x30(%rbx)
  70a420:	48 8b 44 24 68       	mov    0x68(%rsp),%rax
  70a425:	48 8b 4c 24 70       	mov    0x70(%rsp),%rcx
  70a42a:	0f 10 44 24 78       	movups 0x78(%rsp),%xmm0
  70a42f:	0f 10 8c 24 88 00 00 	movups 0x88(%rsp),%xmm1
  70a436:	00 
  70a437:	0f 11 4b 20          	movups %xmm1,0x20(%rbx)
  70a43b:	0f 11 43 10          	movups %xmm0,0x10(%rbx)
  70a43f:	48 89 03             	mov    %rax,(%rbx)
  70a442:	48 89 4b 08          	mov    %rcx,0x8(%rbx)
  70a446:	e9 6a f8 ff ff       	jmp    709cb5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x95>
  70a44b:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  70a452:	49 39 f4             	cmp    %rsi,%r12
  70a455:	0f 83 eb 02 00 00    	jae    70a746 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0xb26>
  70a45b:	49 8b 86 98 02 00 00 	mov    0x298(%r14),%rax
  70a462:	4b 8d 0c a4          	lea    (%r12,%r12,4),%rcx
  70a466:	44 8b 7c c8 18       	mov    0x18(%rax,%rcx,8),%r15d
  70a46b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  70a470:	49 39 c7             	cmp    %rax,%r15
  70a473:	0f 84 2c f8 ff ff    	je     709ca5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x85>
  70a479:	48 c7 44 24 28 11 00 	movq   $0x11,0x28(%rsp)
  70a480:	00 00 
  70a482:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  70a487:	e8 54 db fe ff       	call   6f7fe0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70a48c:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  70a493:	4c 39 fe             	cmp    %r15,%rsi
  70a496:	0f 86 ba 02 00 00    	jbe    70a756 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0xb36>
  70a49c:	49 8d be b0 05 00 00 	lea    0x5b0(%r14),%rdi
  70a4a3:	49 8b 86 98 02 00 00 	mov    0x298(%r14),%rax
  70a4aa:	4b 8d 0c bf          	lea    (%r15,%r15,4),%rcx
  70a4ae:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
  70a4b2:	ff 15 48 f1 41 00    	call   *0x41f148(%rip)        # b29600 <_DYNAMIC+0x500>
  70a4b8:	49 89 c7             	mov    %rax,%r15
  70a4bb:	49 89 d4             	mov    %rdx,%r12
  70a4be:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  70a4c3:	4c 89 f6             	mov    %r14,%rsi
  70a4c6:	48 89 c2             	mov    %rax,%rdx
  70a4c9:	4c 89 e1             	mov    %r12,%rcx
  70a4cc:	e8 af e6 ff ff       	call   708b80 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::inspector_app_index>
  70a4d1:	83 7c 24 28 fe       	cmpl   $0xfffffffe,0x28(%rsp)
  70a4d6:	75 5f                	jne    70a537 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x917>
  70a4d8:	48 89 df             	mov    %rbx,%rdi
  70a4db:	4c 89 f6             	mov    %r14,%rsi
  70a4de:	4c 89 fa             	mov    %r15,%rdx
  70a4e1:	4c 89 e1             	mov    %r12,%rcx
  70a4e4:	48 81 c4 28 01 00 00 	add    $0x128,%rsp
  70a4eb:	5b                   	pop    %rbx
  70a4ec:	41 5c                	pop    %r12
  70a4ee:	41 5d                	pop    %r13
  70a4f0:	41 5e                	pop    %r14
  70a4f2:	41 5f                	pop    %r15
  70a4f4:	5d                   	pop    %rbp
  70a4f5:	e9 e6 02 00 00       	jmp    70a7e0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::inspector_select>
  70a4fa:	8b 4c 24 5c          	mov    0x5c(%rsp),%ecx
  70a4fe:	89 4b 34             	mov    %ecx,0x34(%rbx)
  70a501:	0f 10 44 24 4c       	movups 0x4c(%rsp),%xmm0
  70a506:	0f 11 43 24          	movups %xmm0,0x24(%rbx)
  70a50a:	0f 10 84 24 cc 00 00 	movups 0xcc(%rsp),%xmm0
  70a511:	00 
  70a512:	0f 11 43 14          	movups %xmm0,0x14(%rbx)
  70a516:	0f 28 84 24 c0 00 00 	movaps 0xc0(%rsp),%xmm0
  70a51d:	00 
  70a51e:	0f 11 43 08          	movups %xmm0,0x8(%rbx)
  70a522:	48 89 03             	mov    %rax,(%rbx)
  70a525:	e9 8b f7 ff ff       	jmp    709cb5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x95>
  70a52a:	48 8d 3d 8f 0b 3f 00 	lea    0x3f0b8f(%rip),%rdi        # afb0c0 <__frame_dummy_init_array_entry+0x828>
  70a531:	ff 15 d1 ee 41 00    	call   *0x41eed1(%rip)        # b29408 <_DYNAMIC+0x308>
  70a537:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  70a53c:	e8 9f da fe ff       	call   6f7fe0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70a541:	41 0f 10 86 60 06 00 	movups 0x660(%r14),%xmm0
  70a548:	00 
  70a549:	41 0f b6 86 20 07 00 	movzbl 0x720(%r14),%eax
  70a550:	00 
  70a551:	49 83 be 80 06 00 00 	cmpq   $0x0,0x680(%r14)
  70a558:	00 
  70a559:	74 1c                	je     70a577 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x957>
  70a55b:	84 c0                	test   %al,%al
  70a55d:	74 0a                	je     70a569 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x949>
  70a55f:	49 83 be 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%r14)
  70a566:	ff 
  70a567:	74 0e                	je     70a577 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x957>
  70a569:	49 8b 96 90 06 00 00 	mov    0x690(%r14),%rdx
  70a570:	b9 01 00 00 00       	mov    $0x1,%ecx
  70a575:	eb 02                	jmp    70a579 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x959>
  70a577:	31 c9                	xor    %ecx,%ecx
  70a579:	49 8b b6 08 07 00 00 	mov    0x708(%r14),%rsi
  70a580:	48 89 4b 08          	mov    %rcx,0x8(%rbx)
  70a584:	48 89 53 10          	mov    %rdx,0x10(%rbx)
  70a588:	0f 11 43 18          	movups %xmm0,0x18(%rbx)
  70a58c:	48 89 73 28          	mov    %rsi,0x28(%rbx)
  70a590:	e9 f0 f9 ff ff       	jmp    709f85 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x365>
  70a595:	83 f8 23             	cmp    $0x23,%eax
  70a598:	0f 85 eb 00 00 00    	jne    70a689 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0xa69>
  70a59e:	8b 44 24 30          	mov    0x30(%rsp),%eax
  70a5a2:	83 f8 0d             	cmp    $0xd,%eax
  70a5a5:	0f 84 12 01 00 00    	je     70a6bd <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0xa9d>
  70a5ab:	83 f8 0e             	cmp    $0xe,%eax
  70a5ae:	0f 85 d5 00 00 00    	jne    70a689 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0xa69>
  70a5b4:	ba 07 00 00 00       	mov    $0x7,%edx
  70a5b9:	e9 04 01 00 00       	jmp    70a6c2 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0xaa2>
  70a5be:	c6 84 24 a0 00 00 00 	movb   $0x0,0xa0(%rsp)
  70a5c5:	00 
  70a5c6:	c7 84 24 a4 00 00 00 	movl   $0x0,0xa4(%rsp)
  70a5cd:	00 00 00 00 
  70a5d1:	48 8d b4 24 a0 00 00 	lea    0xa0(%rsp),%rsi
  70a5d8:	00 
  70a5d9:	8b 7c 24 08          	mov    0x8(%rsp),%edi
  70a5dd:	ff 15 25 f0 41 00    	call   *0x41f025(%rip)        # b29608 <_DYNAMIC+0x508>
  70a5e3:	66 85 c0             	test   %ax,%ax
  70a5e6:	74 2a                	je     70a612 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x9f2>
  70a5e8:	48 c1 e8 10          	shr    $0x10,%rax
  70a5ec:	48 89 df             	mov    %rbx,%rdi
  70a5ef:	4c 89 f6             	mov    %r14,%rsi
  70a5f2:	89 c2                	mov    %eax,%edx
  70a5f4:	48 81 c4 28 01 00 00 	add    $0x128,%rsp
  70a5fb:	5b                   	pop    %rbx
  70a5fc:	41 5c                	pop    %r12
  70a5fe:	41 5d                	pop    %r13
  70a600:	41 5e                	pop    %r14
  70a602:	41 5f                	pop    %r15
  70a604:	5d                   	pop    %rbp
  70a605:	e9 f6 f4 ff ff       	jmp    709b00 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::reject_editor>
  70a60a:	c6 84 24 a0 00 00 00 	movb   $0xff,0xa0(%rsp)
  70a611:	ff 
  70a612:	4d 8b be 60 06 00 00 	mov    0x660(%r14),%r15
  70a619:	49 83 ff ff          	cmp    $0xffffffffffffffff,%r15
  70a61d:	0f 84 8e 00 00 00    	je     70a6b1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0xa91>
  70a623:	48 c7 44 24 28 1f 00 	movq   $0x1f,0x28(%rsp)
  70a62a:	00 00 
  70a62c:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  70a631:	e8 aa d9 fe ff       	call   6f7fe0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70a636:	49 8b 86 10 06 00 00 	mov    0x610(%r14),%rax
  70a63d:	48 85 c0             	test   %rax,%rax
  70a640:	0f 84 af 00 00 00    	je     70a6f5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0xad5>
  70a646:	48 8b 80 d8 00 00 00 	mov    0xd8(%rax),%rax
  70a64d:	48 85 c0             	test   %rax,%rax
  70a650:	0f 84 9f 00 00 00    	je     70a6f5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0xad5>
  70a656:	49 ff c7             	inc    %r15
  70a659:	c6 40 13 ff          	movb   $0xff,0x13(%rax)
  70a65d:	48 8d 84 24 a0 00 00 	lea    0xa0(%rsp),%rax
  70a664:	00 
  70a665:	48 89 04 24          	mov    %rax,(%rsp)
  70a669:	48 89 df             	mov    %rbx,%rdi
  70a66c:	4c 89 f6             	mov    %r14,%rsi
  70a66f:	48 8b 54 24 60       	mov    0x60(%rsp),%rdx
  70a674:	4c 89 e1             	mov    %r12,%rcx
  70a677:	4d 89 f8             	mov    %r15,%r8
  70a67a:	44 8b 4c 24 08       	mov    0x8(%rsp),%r9d
  70a67f:	e8 0c 06 02 00       	call   72ac90 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::set_property_value_at>
  70a684:	e9 2c f6 ff ff       	jmp    709cb5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x95>
  70a689:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  70a68e:	48 89 43 30          	mov    %rax,0x30(%rbx)
  70a692:	0f 10 44 24 28       	movups 0x28(%rsp),%xmm0
  70a697:	0f 10 4c 24 38       	movups 0x38(%rsp),%xmm1
  70a69c:	0f 10 54 24 48       	movups 0x48(%rsp),%xmm2
  70a6a1:	0f 11 53 20          	movups %xmm2,0x20(%rbx)
  70a6a5:	0f 11 4b 10          	movups %xmm1,0x10(%rbx)
  70a6a9:	0f 11 03             	movups %xmm0,(%rbx)
  70a6ac:	e9 04 f6 ff ff       	jmp    709cb5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x95>
  70a6b1:	48 c7 03 1f 00 00 00 	movq   $0x1f,(%rbx)
  70a6b8:	e9 f8 f5 ff ff       	jmp    709cb5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x95>
  70a6bd:	ba 06 00 00 00       	mov    $0x6,%edx
  70a6c2:	48 89 df             	mov    %rbx,%rdi
  70a6c5:	4c 89 f6             	mov    %r14,%rsi
  70a6c8:	e8 33 f4 ff ff       	call   709b00 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::reject_editor>
  70a6cd:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  70a6d2:	e8 09 d9 fe ff       	call   6f7fe0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70a6d7:	e9 d9 f5 ff ff       	jmp    709cb5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x95>
  70a6dc:	48 8d 3d a1 fe 95 ff 	lea    -0x6a015f(%rip),%rdi        # 6a584 <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x32a7>
  70a6e3:	48 8d 15 4e 0a 3f 00 	lea    0x3f0a4e(%rip),%rdx        # afb138 <__frame_dummy_init_array_entry+0x8a0>
  70a6ea:	be 28 00 00 00       	mov    $0x28,%esi
  70a6ef:	ff 15 1b ef 41 00    	call   *0x41ef1b(%rip)        # b29610 <_DYNAMIC+0x510>
  70a6f5:	48 8d 3d c9 fe 95 ff 	lea    -0x6a0137(%rip),%rdi        # 6a5c5 <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x32e8>
  70a6fc:	48 8d 15 45 09 3f 00 	lea    0x3f0945(%rip),%rdx        # afb048 <__frame_dummy_init_array_entry+0x7b0>
  70a703:	be 11 00 00 00       	mov    $0x11,%esi
  70a708:	ff 15 3a ed 41 00    	call   *0x41ed3a(%rip)        # b29448 <_DYNAMIC+0x348>
  70a70e:	48 8d 3d c3 09 3f 00 	lea    0x3f09c3(%rip),%rdi        # afb0d8 <__frame_dummy_init_array_entry+0x840>
  70a715:	ff 15 ed ec 41 00    	call   *0x41eced(%rip)        # b29408 <_DYNAMIC+0x308>
  70a71b:	4c 89 ff             	mov    %r15,%rdi
  70a71e:	48 8d 15 cb 09 3f 00 	lea    0x3f09cb(%rip),%rdx        # afb0f0 <__frame_dummy_init_array_entry+0x858>
  70a725:	ff 15 2d ed 41 00    	call   *0x41ed2d(%rip)        # b29458 <_DYNAMIC+0x358>
  70a72b:	0f 0b                	ud2
  70a72d:	48 8d 3d 50 fe 95 ff 	lea    -0x6a01b0(%rip),%rdi        # 6a584 <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x32a7>
  70a734:	48 8d 15 15 0a 3f 00 	lea    0x3f0a15(%rip),%rdx        # afb150 <__frame_dummy_init_array_entry+0x8b8>
  70a73b:	be 28 00 00 00       	mov    $0x28,%esi
  70a740:	ff 15 ca ee 41 00    	call   *0x41eeca(%rip)        # b29610 <_DYNAMIC+0x510>
  70a746:	48 8d 15 bb 09 3f 00 	lea    0x3f09bb(%rip),%rdx        # afb108 <__frame_dummy_init_array_entry+0x870>
  70a74d:	4c 89 e7             	mov    %r12,%rdi
  70a750:	ff 15 02 ed 41 00    	call   *0x41ed02(%rip)        # b29458 <_DYNAMIC+0x358>
  70a756:	48 8d 15 c3 09 3f 00 	lea    0x3f09c3(%rip),%rdx        # afb120 <__frame_dummy_init_array_entry+0x888>
  70a75d:	4c 89 ff             	mov    %r15,%rdi
  70a760:	ff 15 f2 ec 41 00    	call   *0x41ecf2(%rip)        # b29458 <_DYNAMIC+0x358>
  70a766:	48 89 c3             	mov    %rax,%rbx
  70a769:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  70a76e:	e8 6d d8 fe ff       	call   6f7fe0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70a773:	48 89 df             	mov    %rbx,%rdi
  70a776:	e8 65 ed 3e 00       	call   af94e0 <_Unwind_Resume@plt>
  70a77b:	4c 8b 74 24 20       	mov    0x20(%rsp),%r14
  70a780:	48 89 c3             	mov    %rax,%rbx
  70a783:	49 8b 75 08          	mov    0x8(%r13),%rsi
  70a787:	48 85 f6             	test   %rsi,%rsi
  70a78a:	74 0d                	je     70a799 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0xb79>
  70a78c:	49 8b 55 10          	mov    0x10(%r13),%rdx
  70a790:	48 89 ef             	mov    %rbp,%rdi
  70a793:	ff 15 af eb 41 00    	call   *0x41ebaf(%rip)        # b29348 <_DYNAMIC+0x248>
  70a799:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  70a79e:	49 89 06             	mov    %rax,(%r14)
  70a7a1:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  70a7a6:	49 89 44 24 10       	mov    %rax,0x10(%r12)
  70a7ab:	48 89 df             	mov    %rbx,%rdi
  70a7ae:	e8 2d ed 3e 00       	call   af94e0 <_Unwind_Resume@plt>
  70a7b3:	48 89 c3             	mov    %rax,%rbx
  70a7b6:	48 8b 7c 24 10       	mov    0x10(%rsp),%rdi
  70a7bb:	48 8b 74 24 08       	mov    0x8(%rsp),%rsi
  70a7c0:	e8 9b a1 fe ff       	call   6f4960 <core::ptr::drop_glue::<core::option::Option<gpui::element::Handler>>>
  70a7c5:	48 89 df             	mov    %rbx,%rdi
  70a7c8:	e8 13 ed 3e 00       	call   af94e0 <_Unwind_Resume@plt>
  70a7cd:	ff 15 a5 eb 41 00    	call   *0x41eba5(%rip)        # b29378 <_DYNAMIC+0x278>
