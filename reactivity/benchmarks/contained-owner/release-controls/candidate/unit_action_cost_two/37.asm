
/tmp/gpui-contained-owner-spike-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

0000000000709c90 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action>:
  709c90:	55                   	push   %rbp
  709c91:	41 57                	push   %r15
  709c93:	41 56                	push   %r14
  709c95:	41 55                	push   %r13
  709c97:	41 54                	push   %r12
  709c99:	53                   	push   %rbx
  709c9a:	48 81 ec 28 01 00 00 	sub    $0x128,%rsp
  709ca1:	48 89 fb             	mov    %rdi,%rbx
  709ca4:	80 be 22 07 00 00 00 	cmpb   $0x0,0x722(%rsi)
  709cab:	74 09                	je     709cb6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x26>
  709cad:	48 c7 03 0e 00 00 00 	movq   $0xe,(%rbx)
  709cb4:	eb 6f                	jmp    709d25 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x95>
  709cb6:	49 89 f6             	mov    %rsi,%r14
  709cb9:	48 8b 86 10 06 00 00 	mov    0x610(%rsi),%rax
  709cc0:	48 85 c0             	test   %rax,%rax
  709cc3:	74 59                	je     709d1e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x8e>
  709cc5:	48 83 b8 d8 00 00 00 	cmpq   $0x0,0xd8(%rax)
  709ccc:	00 
  709ccd:	74 4f                	je     709d1e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x8e>
  709ccf:	49 c7 86 08 07 00 00 	movq   $0x0,0x708(%r14)
  709cd6:	00 00 00 00 
  709cda:	48 8b a8 d8 00 00 00 	mov    0xd8(%rax),%rbp
  709ce1:	48 85 ed             	test   %rbp,%rbp
  709ce4:	0f 84 b0 08 00 00    	je     70a59a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x90a>
  709cea:	44 0f b7 65 10       	movzwl 0x10(%rbp),%r12d
  709cef:	0f b6 7d 16          	movzbl 0x16(%rbp),%edi
  709cf3:	44 0f b6 45 12       	movzbl 0x12(%rbp),%r8d
  709cf8:	89 c8                	mov    %ecx,%eax
  709cfa:	66 83 e8 0e          	sub    $0xe,%ax
  709cfe:	41 bf 03 00 00 00    	mov    $0x3,%r15d
  709d04:	44 0f 43 f8          	cmovae %eax,%r15d
  709d08:	66 41 83 ff 03       	cmp    $0x3,%r15w
  709d0d:	75 28                	jne    709d37 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0xa7>
  709d0f:	66 41 39 cc          	cmp    %cx,%r12w
  709d13:	74 22                	je     709d37 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0xa7>
  709d15:	48 c7 03 11 00 00 00 	movq   $0x11,(%rbx)
  709d1c:	eb 07                	jmp    709d25 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x95>
  709d1e:	48 c7 03 1a 00 00 00 	movq   $0x1a,(%rbx)
  709d25:	48 81 c4 28 01 00 00 	add    $0x128,%rsp
  709d2c:	5b                   	pop    %rbx
  709d2d:	41 5c                	pop    %r12
  709d2f:	41 5d                	pop    %r13
  709d31:	41 5e                	pop    %r14
  709d33:	41 5f                	pop    %r15
  709d35:	5d                   	pop    %rbp
  709d36:	c3                   	ret
  709d37:	41 89 cd             	mov    %ecx,%r13d
  709d3a:	41 c1 ed 10          	shr    $0x10,%r13d
  709d3e:	45 0f b7 cf          	movzwl %r15w,%r9d
  709d42:	48 8d 05 5b 1b 95 ff 	lea    -0x6ae4a5(%rip),%rax        # 5b8a4 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x34>
  709d49:	4a 63 34 88          	movslq (%rax,%r9,4),%rsi
  709d4d:	48 01 c6             	add    %rax,%rsi
  709d50:	ff e6                	jmp    *%rsi
  709d52:	44 0f b7 ff          	movzwl %di,%r15d
  709d56:	41 81 cf 00 01 00 00 	or     $0x100,%r15d
  709d5d:	eb 12                	jmp    709d71 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0xe1>
  709d5f:	45 0f b7 f8          	movzwl %r8w,%r15d
  709d63:	41 c1 e7 08          	shl    $0x8,%r15d
  709d67:	66 45 39 e5          	cmp    %r12w,%r13w
  709d6b:	0f 85 f3 02 00 00    	jne    70a064 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x3d4>
  709d71:	b0 01                	mov    $0x1,%al
  709d73:	44 38 ff             	cmp    %r15b,%dil
  709d76:	0f 85 ed 02 00 00    	jne    70a069 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x3d9>
  709d7c:	41 0f b7 cf          	movzwl %r15w,%ecx
  709d80:	c1 e9 08             	shr    $0x8,%ecx
  709d83:	41 38 c8             	cmp    %cl,%r8b
  709d86:	0f 85 dd 02 00 00    	jne    70a069 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x3d9>
  709d8c:	80 7d 13 ff          	cmpb   $0xff,0x13(%rbp)
  709d90:	0f 85 d3 02 00 00    	jne    70a069 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x3d9>
  709d96:	e9 c4 01 00 00       	jmp    709f5f <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x2cf>
  709d9b:	f7 c1 00 00 ff 00    	test   $0xff0000,%ecx
  709da1:	0f 84 5d 02 00 00    	je     70a004 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x374>
  709da7:	48 8b 45 00          	mov    0x0(%rbp),%rax
  709dab:	48 85 c0             	test   %rax,%rax
  709dae:	0f 84 ab 01 00 00    	je     709f5f <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x2cf>
  709db4:	49 3b 86 b0 05 00 00 	cmp    0x5b0(%r14),%rax
  709dbb:	0f 85 d4 01 00 00    	jne    709f95 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x305>
  709dc1:	4c 89 4c 24 18       	mov    %r9,0x18(%rsp)
  709dc6:	48 89 7c 24 10       	mov    %rdi,0x10(%rsp)
  709dcb:	48 89 54 24 60       	mov    %rdx,0x60(%rsp)
  709dd0:	89 4c 24 08          	mov    %ecx,0x8(%rsp)
  709dd4:	4c 8b 65 08          	mov    0x8(%rbp),%r12
  709dd8:	48 c7 44 24 28 11 00 	movq   $0x11,0x28(%rsp)
  709ddf:	00 00 
  709de1:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  709de6:	e8 05 e2 fe ff       	call   6f7ff0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  709deb:	48 8d bc 24 c0 00 00 	lea    0xc0(%rsp),%rdi
  709df2:	00 
  709df3:	4c 89 f6             	mov    %r14,%rsi
  709df6:	4c 89 e2             	mov    %r12,%rdx
  709df9:	e8 22 ef 01 00       	call   728d20 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::resolve_identity>
  709dfe:	48 8b 84 24 c0 00 00 	mov    0xc0(%rsp),%rax
  709e05:	00 
  709e06:	4c 8b a4 24 c8 00 00 	mov    0xc8(%rsp),%r12
  709e0d:	00 
  709e0e:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  709e12:	0f 85 fc 05 00 00    	jne    70a414 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x784>
  709e18:	49 8b 86 10 06 00 00 	mov    0x610(%r14),%rax
  709e1f:	48 85 c0             	test   %rax,%rax
  709e22:	0f 84 2f 06 00 00    	je     70a457 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x7c7>
  709e28:	48 83 b8 d8 00 00 00 	cmpq   $0x0,0xd8(%rax)
  709e2f:	00 
  709e30:	0f 84 21 06 00 00    	je     70a457 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x7c7>
  709e36:	49 8b ae a0 02 00 00 	mov    0x2a0(%r14),%rbp
  709e3d:	48 c7 44 24 28 1a 00 	movq   $0x1a,0x28(%rsp)
  709e44:	00 00 
  709e46:	48 83 fd 1c          	cmp    $0x1c,%rbp
  709e4a:	0f 82 07 06 00 00    	jb     70a457 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x7c7>
  709e50:	48 83 c5 e4          	add    $0xffffffffffffffe4,%rbp
  709e54:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  709e59:	e8 92 e1 fe ff       	call   6f7ff0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  709e5e:	49 83 fc 02          	cmp    $0x2,%r12
  709e62:	0f 93 c0             	setae  %al
  709e65:	49 39 ec             	cmp    %rbp,%r12
  709e68:	0f 92 c1             	setb   %cl
  709e6b:	84 c8                	test   %cl,%al
  709e6d:	0f 84 22 01 00 00    	je     709f95 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x305>
  709e73:	66 41 83 ff 01       	cmp    $0x1,%r15w
  709e78:	0f 84 3d 06 00 00    	je     70a4bb <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x82b>
  709e7e:	83 7c 24 18 03       	cmpl   $0x3,0x18(%rsp)
  709e83:	0f 85 c3 08 00 00    	jne    70a74c <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0xabc>
  709e89:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  709e8e:	4c 89 f6             	mov    %r14,%rsi
  709e91:	4c 89 e2             	mov    %r12,%rdx
  709e94:	8b 4c 24 08          	mov    0x8(%rsp),%ecx
  709e98:	e8 63 fd 01 00       	call   729c00 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::property_value_at>
  709e9d:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  709ea2:	0f 10 44 24 30       	movups 0x30(%rsp),%xmm0
  709ea7:	0f 29 84 24 c0 00 00 	movaps %xmm0,0xc0(%rsp)
  709eae:	00 
  709eaf:	0f 10 44 24 3c       	movups 0x3c(%rsp),%xmm0
  709eb4:	0f 11 84 24 cc 00 00 	movups %xmm0,0xcc(%rsp)
  709ebb:	00 
  709ebc:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  709ec0:	0f 85 a4 06 00 00    	jne    70a56a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x8da>
  709ec6:	0f 28 84 24 c0 00 00 	movaps 0xc0(%rsp),%xmm0
  709ecd:	00 
  709ece:	0f 29 84 24 00 01 00 	movaps %xmm0,0x100(%rsp)
  709ed5:	00 
  709ed6:	0f 10 84 24 cc 00 00 	movups 0xcc(%rsp),%xmm0
  709edd:	00 
  709ede:	0f 11 84 24 0c 01 00 	movups %xmm0,0x10c(%rsp)
  709ee5:	00 
  709ee6:	41 0f b6 c5          	movzbl %r13b,%eax
  709eea:	48 8d 0d c3 19 95 ff 	lea    -0x6ae63d(%rip),%rcx        # 5b8b4 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x44>
  709ef1:	48 63 04 81          	movslq (%rcx,%rax,4),%rax
  709ef5:	48 01 c8             	add    %rcx,%rax
  709ef8:	ff e0                	jmp    *%rax
  709efa:	8b 44 24 08          	mov    0x8(%rsp),%eax
  709efe:	25 00 00 ff 00       	and    $0xff0000,%eax
  709f03:	31 c9                	xor    %ecx,%ecx
  709f05:	3d 00 00 02 00       	cmp    $0x20000,%eax
  709f0a:	0f 94 c1             	sete   %cl
  709f0d:	48 8d 05 14 17 95 ff 	lea    -0x6ae8ec(%rip),%rax        # 5b628 <anon.079f5e587c394fcac2765eb4d0cf0bc2.21.llvm.6319143315422321905+0x48>
  709f14:	f3 0f 10 04 88       	movss  (%rax,%rcx,4),%xmm0
  709f19:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  709f1e:	48 8d b4 24 00 01 00 	lea    0x100(%rsp),%rsi
  709f25:	00 
  709f26:	48 8b 54 24 10       	mov    0x10(%rsp),%rdx
  709f2b:	ff 15 2f f7 41 00    	call   *0x41f72f(%rip)        # b29660 <_DYNAMIC+0x4f0>
  709f31:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  709f36:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  709f3a:	0f 85 c5 06 00 00    	jne    70a605 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x975>
  709f40:	0f 10 44 24 30       	movups 0x30(%rsp),%xmm0
  709f45:	0f 10 4c 24 3c       	movups 0x3c(%rsp),%xmm1
  709f4a:	0f 11 8c 24 ac 00 00 	movups %xmm1,0xac(%rsp)
  709f51:	00 
  709f52:	0f 29 84 24 a0 00 00 	movaps %xmm0,0xa0(%rsp)
  709f59:	00 
  709f5a:	e9 e2 06 00 00       	jmp    70a641 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x9b1>
  709f5f:	41 0f 10 86 60 06 00 	movups 0x660(%r14),%xmm0
  709f66:	00 
  709f67:	41 0f b6 86 20 07 00 	movzbl 0x720(%r14),%eax
  709f6e:	00 
  709f6f:	49 83 be 80 06 00 00 	cmpq   $0x0,0x680(%r14)
  709f76:	00 
  709f77:	74 66                	je     709fdf <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x34f>
  709f79:	84 c0                	test   %al,%al
  709f7b:	74 0a                	je     709f87 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x2f7>
  709f7d:	49 83 be 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%r14)
  709f84:	ff 
  709f85:	74 58                	je     709fdf <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x34f>
  709f87:	49 8b 96 90 06 00 00 	mov    0x690(%r14),%rdx
  709f8e:	b9 01 00 00 00       	mov    $0x1,%ecx
  709f93:	eb 4c                	jmp    709fe1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x351>
  709f95:	48 c7 44 24 68 11 00 	movq   $0x11,0x68(%rsp)
  709f9c:	00 00 
  709f9e:	41 0f 10 86 60 06 00 	movups 0x660(%r14),%xmm0
  709fa5:	00 
  709fa6:	41 0f b6 86 20 07 00 	movzbl 0x720(%r14),%eax
  709fad:	00 
  709fae:	49 83 be 80 06 00 00 	cmpq   $0x0,0x680(%r14)
  709fb5:	00 
  709fb6:	0f 84 26 04 00 00    	je     70a3e2 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x752>
  709fbc:	84 c0                	test   %al,%al
  709fbe:	74 0e                	je     709fce <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x33e>
  709fc0:	49 83 be 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%r14)
  709fc7:	ff 
  709fc8:	0f 84 14 04 00 00    	je     70a3e2 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x752>
  709fce:	49 8b 96 90 06 00 00 	mov    0x690(%r14),%rdx
  709fd5:	b9 01 00 00 00       	mov    $0x1,%ecx
  709fda:	e9 05 04 00 00       	jmp    70a3e4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x754>
  709fdf:	31 c9                	xor    %ecx,%ecx
  709fe1:	48 89 4b 08          	mov    %rcx,0x8(%rbx)
  709fe5:	48 89 53 10          	mov    %rdx,0x10(%rbx)
  709fe9:	0f 11 43 18          	movups %xmm0,0x18(%rbx)
  709fed:	48 c7 43 28 00 00 00 	movq   $0x0,0x28(%rbx)
  709ff4:	00 
  709ff5:	88 43 30             	mov    %al,0x30(%rbx)
  709ff8:	48 c7 03 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rbx)
  709fff:	e9 21 fd ff ff       	jmp    709d25 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x95>
  70a004:	45 0f b7 f8          	movzwl %r8w,%r15d
  70a008:	8d 47 01             	lea    0x1(%rdi),%eax
  70a00b:	89 44 24 18          	mov    %eax,0x18(%rsp)
  70a00f:	48 89 7c 24 10       	mov    %rdi,0x10(%rsp)
  70a014:	89 cf                	mov    %ecx,%edi
  70a016:	89 4c 24 08          	mov    %ecx,0x8(%rsp)
  70a01a:	45 89 c5             	mov    %r8d,%r13d
  70a01d:	e8 ae ab ff ff       	call   704bd0 <<gpui::property::PropertyId>::info>
  70a022:	45 89 e8             	mov    %r13d,%r8d
  70a025:	48 8b 7c 24 10       	mov    0x10(%rsp),%rdi
  70a02a:	44 8b 6c 24 08       	mov    0x8(%rsp),%r13d
  70a02f:	0f b6 40 14          	movzbl 0x14(%rax),%eax
  70a033:	31 c9                	xor    %ecx,%ecx
  70a035:	3c 04                	cmp    $0x4,%al
  70a037:	0f 94 c1             	sete   %cl
  70a03a:	8d 0c 89             	lea    (%rcx,%rcx,4),%ecx
  70a03d:	ff c1                	inc    %ecx
  70a03f:	3c 02                	cmp    $0x2,%al
  70a041:	ba 04 00 00 00       	mov    $0x4,%edx
  70a046:	0f 45 d1             	cmovne %ecx,%edx
  70a049:	0f b6 44 24 18       	movzbl 0x18(%rsp),%eax
  70a04e:	f6 f2                	div    %dl
  70a050:	0f b6 c4             	movzbl %ah,%eax
  70a053:	41 c1 e7 08          	shl    $0x8,%r15d
  70a057:	41 09 c7             	or     %eax,%r15d
  70a05a:	66 45 39 e5          	cmp    %r12w,%r13w
  70a05e:	0f 84 0d fd ff ff    	je     709d71 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0xe1>
  70a064:	31 c0                	xor    %eax,%eax
  70a066:	45 89 ec             	mov    %r13d,%r12d
  70a069:	49 8b 96 60 06 00 00 	mov    0x660(%r14),%rdx
  70a070:	48 ff c2             	inc    %rdx
  70a073:	0f 84 a8 06 00 00    	je     70a721 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0xa91>
  70a079:	41 0f b7 cf          	movzwl %r15w,%ecx
  70a07d:	66 44 89 65 10       	mov    %r12w,0x10(%rbp)
  70a082:	88 4d 16             	mov    %cl,0x16(%rbp)
  70a085:	88 6d 12             	mov    %ch,0x12(%rbp)
  70a088:	c6 45 13 ff          	movb   $0xff,0x13(%rbp)
  70a08c:	84 c0                	test   %al,%al
  70a08e:	0f 85 11 03 00 00    	jne    70a3a5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x715>
  70a094:	49 8b 86 10 06 00 00 	mov    0x610(%r14),%rax
  70a09b:	48 85 c0             	test   %rax,%rax
  70a09e:	0f 84 da 06 00 00    	je     70a77e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0xaee>
  70a0a4:	48 83 b8 d8 00 00 00 	cmpq   $0x0,0xd8(%rax)
  70a0ab:	00 
  70a0ac:	0f 84 cc 06 00 00    	je     70a77e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0xaee>
  70a0b2:	4d 8b be a0 02 00 00 	mov    0x2a0(%r14),%r15
  70a0b9:	49 83 ff 1c          	cmp    $0x1c,%r15
  70a0bd:	0f 82 bb 06 00 00    	jb     70a77e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0xaee>
  70a0c3:	48 89 54 24 60       	mov    %rdx,0x60(%rsp)
  70a0c8:	41 0f b7 fc          	movzwl %r12w,%edi
  70a0cc:	48 89 7c 24 18       	mov    %rdi,0x18(%rsp)
  70a0d1:	ff 15 91 f5 41 00    	call   *0x41f591(%rip)        # b29668 <_DYNAMIC+0x4f8>
  70a0d7:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  70a0dc:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
  70a0e1:	49 8d 7f f7          	lea    -0x9(%r15),%rdi
  70a0e5:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  70a0ec:	48 39 f7             	cmp    %rsi,%rdi
  70a0ef:	0f 83 99 06 00 00    	jae    70a78e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0xafe>
  70a0f5:	49 8b 8e 98 02 00 00 	mov    0x298(%r14),%rcx
  70a0fc:	48 8d 14 bf          	lea    (%rdi,%rdi,4),%rdx
  70a100:	4c 8d 24 d1          	lea    (%rcx,%rdx,8),%r12
  70a104:	48 8b 6c d1 08       	mov    0x8(%rcx,%rdx,8),%rbp
  70a109:	48 85 ed             	test   %rbp,%rbp
  70a10c:	74 36                	je     70a144 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x4b4>
  70a10e:	4c 8b 6c d1 10       	mov    0x10(%rcx,%rdx,8),%r13
  70a113:	49 8b 45 00          	mov    0x0(%r13),%rax
  70a117:	48 85 c0             	test   %rax,%rax
  70a11a:	74 12                	je     70a12e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x49e>
  70a11c:	48 8d 0c d1          	lea    (%rcx,%rdx,8),%rcx
  70a120:	48 83 c1 08          	add    $0x8,%rcx
  70a124:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  70a129:	48 89 ef             	mov    %rbp,%rdi
  70a12c:	ff d0                	call   *%rax
  70a12e:	49 8b 75 08          	mov    0x8(%r13),%rsi
  70a132:	48 85 f6             	test   %rsi,%rsi
  70a135:	74 0d                	je     70a144 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x4b4>
  70a137:	49 8b 55 10          	mov    0x10(%r13),%rdx
  70a13b:	48 89 ef             	mov    %rbp,%rdi
  70a13e:	ff 15 74 f2 41 00    	call   *0x41f274(%rip)        # b293b8 <_DYNAMIC+0x248>
  70a144:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  70a149:	49 89 44 24 08       	mov    %rax,0x8(%r12)
  70a14e:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  70a153:	49 89 44 24 10       	mov    %rax,0x10(%r12)
  70a158:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  70a15d:	8d b8 00 00 01 00    	lea    0x10000(%rax),%edi
  70a163:	ff 15 ff f4 41 00    	call   *0x41f4ff(%rip)        # b29668 <_DYNAMIC+0x4f8>
  70a169:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  70a16e:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
  70a173:	49 8d 7f f9          	lea    -0x7(%r15),%rdi
  70a177:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  70a17e:	48 39 f7             	cmp    %rsi,%rdi
  70a181:	0f 83 07 06 00 00    	jae    70a78e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0xafe>
  70a187:	49 8b 8e 98 02 00 00 	mov    0x298(%r14),%rcx
  70a18e:	48 8d 14 bf          	lea    (%rdi,%rdi,4),%rdx
  70a192:	4c 8d 24 d1          	lea    (%rcx,%rdx,8),%r12
  70a196:	48 8b 6c d1 08       	mov    0x8(%rcx,%rdx,8),%rbp
  70a19b:	48 85 ed             	test   %rbp,%rbp
  70a19e:	74 36                	je     70a1d6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x546>
  70a1a0:	4c 8b 6c d1 10       	mov    0x10(%rcx,%rdx,8),%r13
  70a1a5:	49 8b 45 00          	mov    0x0(%r13),%rax
  70a1a9:	48 85 c0             	test   %rax,%rax
  70a1ac:	74 12                	je     70a1c0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x530>
  70a1ae:	48 8d 0c d1          	lea    (%rcx,%rdx,8),%rcx
  70a1b2:	48 83 c1 08          	add    $0x8,%rcx
  70a1b6:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  70a1bb:	48 89 ef             	mov    %rbp,%rdi
  70a1be:	ff d0                	call   *%rax
  70a1c0:	49 8b 75 08          	mov    0x8(%r13),%rsi
  70a1c4:	48 85 f6             	test   %rsi,%rsi
  70a1c7:	74 0d                	je     70a1d6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x546>
  70a1c9:	49 8b 55 10          	mov    0x10(%r13),%rdx
  70a1cd:	48 89 ef             	mov    %rbp,%rdi
  70a1d0:	ff 15 e2 f1 41 00    	call   *0x41f1e2(%rip)        # b293b8 <_DYNAMIC+0x248>
  70a1d6:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  70a1db:	49 89 44 24 08       	mov    %rax,0x8(%r12)
  70a1e0:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  70a1e5:	49 89 44 24 10       	mov    %rax,0x10(%r12)
  70a1ea:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  70a1ef:	8d b8 00 00 02 00    	lea    0x20000(%rax),%edi
  70a1f5:	ff 15 6d f4 41 00    	call   *0x41f46d(%rip)        # b29668 <_DYNAMIC+0x4f8>
  70a1fb:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  70a200:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
  70a205:	49 8d 7f fa          	lea    -0x6(%r15),%rdi
  70a209:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  70a210:	48 39 f7             	cmp    %rsi,%rdi
  70a213:	0f 83 75 05 00 00    	jae    70a78e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0xafe>
  70a219:	49 8b 8e 98 02 00 00 	mov    0x298(%r14),%rcx
  70a220:	48 8d 14 bf          	lea    (%rdi,%rdi,4),%rdx
  70a224:	4c 8d 24 d1          	lea    (%rcx,%rdx,8),%r12
  70a228:	48 8b 6c d1 08       	mov    0x8(%rcx,%rdx,8),%rbp
  70a22d:	48 85 ed             	test   %rbp,%rbp
  70a230:	74 36                	je     70a268 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x5d8>
  70a232:	4c 8b 6c d1 10       	mov    0x10(%rcx,%rdx,8),%r13
  70a237:	49 8b 45 00          	mov    0x0(%r13),%rax
  70a23b:	48 85 c0             	test   %rax,%rax
  70a23e:	74 12                	je     70a252 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x5c2>
  70a240:	48 8d 0c d1          	lea    (%rcx,%rdx,8),%rcx
  70a244:	48 83 c1 08          	add    $0x8,%rcx
  70a248:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  70a24d:	48 89 ef             	mov    %rbp,%rdi
  70a250:	ff d0                	call   *%rax
  70a252:	49 8b 75 08          	mov    0x8(%r13),%rsi
  70a256:	48 85 f6             	test   %rsi,%rsi
  70a259:	74 0d                	je     70a268 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x5d8>
  70a25b:	49 8b 55 10          	mov    0x10(%r13),%rdx
  70a25f:	48 89 ef             	mov    %rbp,%rdi
  70a262:	ff 15 50 f1 41 00    	call   *0x41f150(%rip)        # b293b8 <_DYNAMIC+0x248>
  70a268:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  70a26d:	49 89 44 24 08       	mov    %rax,0x8(%r12)
  70a272:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  70a277:	49 89 44 24 10       	mov    %rax,0x10(%r12)
  70a27c:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  70a281:	8d b8 00 00 03 00    	lea    0x30000(%rax),%edi
  70a287:	ff 15 db f3 41 00    	call   *0x41f3db(%rip)        # b29668 <_DYNAMIC+0x4f8>
  70a28d:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  70a292:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
  70a297:	49 8d 7f fb          	lea    -0x5(%r15),%rdi
  70a29b:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  70a2a2:	48 39 f7             	cmp    %rsi,%rdi
  70a2a5:	0f 83 e3 04 00 00    	jae    70a78e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0xafe>
  70a2ab:	49 8b 8e 98 02 00 00 	mov    0x298(%r14),%rcx
  70a2b2:	48 8d 14 bf          	lea    (%rdi,%rdi,4),%rdx
  70a2b6:	4c 8d 24 d1          	lea    (%rcx,%rdx,8),%r12
  70a2ba:	48 8b 6c d1 08       	mov    0x8(%rcx,%rdx,8),%rbp
  70a2bf:	48 85 ed             	test   %rbp,%rbp
  70a2c2:	74 36                	je     70a2fa <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x66a>
  70a2c4:	4c 8b 6c d1 10       	mov    0x10(%rcx,%rdx,8),%r13
  70a2c9:	49 8b 45 00          	mov    0x0(%r13),%rax
  70a2cd:	48 85 c0             	test   %rax,%rax
  70a2d0:	74 12                	je     70a2e4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x654>
  70a2d2:	48 8d 0c d1          	lea    (%rcx,%rdx,8),%rcx
  70a2d6:	48 83 c1 08          	add    $0x8,%rcx
  70a2da:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  70a2df:	48 89 ef             	mov    %rbp,%rdi
  70a2e2:	ff d0                	call   *%rax
  70a2e4:	49 8b 75 08          	mov    0x8(%r13),%rsi
  70a2e8:	48 85 f6             	test   %rsi,%rsi
  70a2eb:	74 0d                	je     70a2fa <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x66a>
  70a2ed:	49 8b 55 10          	mov    0x10(%r13),%rdx
  70a2f1:	48 89 ef             	mov    %rbp,%rdi
  70a2f4:	ff 15 be f0 41 00    	call   *0x41f0be(%rip)        # b293b8 <_DYNAMIC+0x248>
  70a2fa:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  70a2ff:	49 89 44 24 08       	mov    %rax,0x8(%r12)
  70a304:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  70a309:	49 89 44 24 10       	mov    %rax,0x10(%r12)
  70a30e:	48 8b 7c 24 18       	mov    0x18(%rsp),%rdi
  70a313:	81 cf 00 00 04 00    	or     $0x40000,%edi
  70a319:	ff 15 49 f3 41 00    	call   *0x41f349(%rip)        # b29668 <_DYNAMIC+0x4f8>
  70a31f:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  70a324:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
  70a329:	49 83 c7 fc          	add    $0xfffffffffffffffc,%r15
  70a32d:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  70a334:	49 39 f7             	cmp    %rsi,%r15
  70a337:	0f 83 4e 04 00 00    	jae    70a78b <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0xafb>
  70a33d:	49 8b 8e 98 02 00 00 	mov    0x298(%r14),%rcx
  70a344:	4b 8d 14 bf          	lea    (%r15,%r15,4),%rdx
  70a348:	4c 8d 24 d1          	lea    (%rcx,%rdx,8),%r12
  70a34c:	48 8b 6c d1 08       	mov    0x8(%rcx,%rdx,8),%rbp
  70a351:	48 85 ed             	test   %rbp,%rbp
  70a354:	74 36                	je     70a38c <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x6fc>
  70a356:	4c 8b 6c d1 10       	mov    0x10(%rcx,%rdx,8),%r13
  70a35b:	49 8b 45 00          	mov    0x0(%r13),%rax
  70a35f:	48 85 c0             	test   %rax,%rax
  70a362:	74 12                	je     70a376 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x6e6>
  70a364:	48 8d 0c d1          	lea    (%rcx,%rdx,8),%rcx
  70a368:	48 83 c1 08          	add    $0x8,%rcx
  70a36c:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  70a371:	48 89 ef             	mov    %rbp,%rdi
  70a374:	ff d0                	call   *%rax
  70a376:	49 8b 75 08          	mov    0x8(%r13),%rsi
  70a37a:	48 85 f6             	test   %rsi,%rsi
  70a37d:	74 0d                	je     70a38c <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x6fc>
  70a37f:	49 8b 55 10          	mov    0x10(%r13),%rdx
  70a383:	48 89 ef             	mov    %rbp,%rdi
  70a386:	ff 15 2c f0 41 00    	call   *0x41f02c(%rip)        # b293b8 <_DYNAMIC+0x248>
  70a38c:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  70a391:	49 89 44 24 08       	mov    %rax,0x8(%r12)
  70a396:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  70a39b:	49 89 44 24 10       	mov    %rax,0x10(%r12)
  70a3a0:	48 8b 54 24 60       	mov    0x60(%rsp),%rdx
  70a3a5:	49 89 96 60 06 00 00 	mov    %rdx,0x660(%r14)
  70a3ac:	49 ff 86 b0 06 00 00 	incq   0x6b0(%r14)
  70a3b3:	49 c7 86 08 07 00 00 	movq   $0x0,0x708(%r14)
  70a3ba:	00 00 00 00 
  70a3be:	41 c6 86 1f 07 00 00 	movb   $0x1,0x71f(%r14)
  70a3c5:	01 
  70a3c6:	48 89 df             	mov    %rbx,%rdi
  70a3c9:	4c 89 f6             	mov    %r14,%rsi
  70a3cc:	48 81 c4 28 01 00 00 	add    $0x128,%rsp
  70a3d3:	5b                   	pop    %rbx
  70a3d4:	41 5c                	pop    %r12
  70a3d6:	41 5d                	pop    %r13
  70a3d8:	41 5e                	pop    %r14
  70a3da:	41 5f                	pop    %r15
  70a3dc:	5d                   	pop    %rbp
  70a3dd:	e9 ae f1 01 00       	jmp    729590 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::present>
  70a3e2:	31 c9                	xor    %ecx,%ecx
  70a3e4:	49 8b b6 08 07 00 00 	mov    0x708(%r14),%rsi
  70a3eb:	48 89 4b 08          	mov    %rcx,0x8(%rbx)
  70a3ef:	48 89 53 10          	mov    %rdx,0x10(%rbx)
  70a3f3:	0f 11 43 18          	movups %xmm0,0x18(%rbx)
  70a3f7:	48 89 73 28          	mov    %rsi,0x28(%rbx)
  70a3fb:	88 43 30             	mov    %al,0x30(%rbx)
  70a3fe:	48 c7 03 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rbx)
  70a405:	48 8d 7c 24 68       	lea    0x68(%rsp),%rdi
  70a40a:	e8 e1 db fe ff       	call   6f7ff0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70a40f:	e9 11 f9 ff ff       	jmp    709d25 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x95>
  70a414:	48 8b 8c 24 f0 00 00 	mov    0xf0(%rsp),%rcx
  70a41b:	00 
  70a41c:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  70a423:	00 
  70a424:	0f 10 84 24 d0 00 00 	movups 0xd0(%rsp),%xmm0
  70a42b:	00 
  70a42c:	0f 10 8c 24 e0 00 00 	movups 0xe0(%rsp),%xmm1
  70a433:	00 
  70a434:	0f 11 8c 24 88 00 00 	movups %xmm1,0x88(%rsp)
  70a43b:	00 
  70a43c:	0f 11 44 24 78       	movups %xmm0,0x78(%rsp)
  70a441:	48 89 44 24 68       	mov    %rax,0x68(%rsp)
  70a446:	4c 89 64 24 70       	mov    %r12,0x70(%rsp)
  70a44b:	48 83 f8 11          	cmp    $0x11,%rax
  70a44f:	0f 84 49 fb ff ff    	je     709f9e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x30e>
  70a455:	eb 2d                	jmp    70a484 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x7f4>
  70a457:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  70a45c:	48 89 84 24 98 00 00 	mov    %rax,0x98(%rsp)
  70a463:	00 
  70a464:	0f 10 44 24 38       	movups 0x38(%rsp),%xmm0
  70a469:	0f 10 4c 24 48       	movups 0x48(%rsp),%xmm1
  70a46e:	0f 11 8c 24 88 00 00 	movups %xmm1,0x88(%rsp)
  70a475:	00 
  70a476:	0f 11 44 24 78       	movups %xmm0,0x78(%rsp)
  70a47b:	48 c7 44 24 68 1a 00 	movq   $0x1a,0x68(%rsp)
  70a482:	00 00 
  70a484:	48 8b 84 24 98 00 00 	mov    0x98(%rsp),%rax
  70a48b:	00 
  70a48c:	48 89 43 30          	mov    %rax,0x30(%rbx)
  70a490:	48 8b 44 24 68       	mov    0x68(%rsp),%rax
  70a495:	48 8b 4c 24 70       	mov    0x70(%rsp),%rcx
  70a49a:	0f 10 44 24 78       	movups 0x78(%rsp),%xmm0
  70a49f:	0f 10 8c 24 88 00 00 	movups 0x88(%rsp),%xmm1
  70a4a6:	00 
  70a4a7:	0f 11 4b 20          	movups %xmm1,0x20(%rbx)
  70a4ab:	0f 11 43 10          	movups %xmm0,0x10(%rbx)
  70a4af:	48 89 03             	mov    %rax,(%rbx)
  70a4b2:	48 89 4b 08          	mov    %rcx,0x8(%rbx)
  70a4b6:	e9 6a f8 ff ff       	jmp    709d25 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x95>
  70a4bb:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  70a4c2:	49 39 f4             	cmp    %rsi,%r12
  70a4c5:	0f 83 eb 02 00 00    	jae    70a7b6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0xb26>
  70a4cb:	49 8b 86 98 02 00 00 	mov    0x298(%r14),%rax
  70a4d2:	4b 8d 0c a4          	lea    (%r12,%r12,4),%rcx
  70a4d6:	44 8b 7c c8 18       	mov    0x18(%rax,%rcx,8),%r15d
  70a4db:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  70a4e0:	49 39 c7             	cmp    %rax,%r15
  70a4e3:	0f 84 2c f8 ff ff    	je     709d15 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x85>
  70a4e9:	48 c7 44 24 28 11 00 	movq   $0x11,0x28(%rsp)
  70a4f0:	00 00 
  70a4f2:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  70a4f7:	e8 f4 da fe ff       	call   6f7ff0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70a4fc:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  70a503:	4c 39 fe             	cmp    %r15,%rsi
  70a506:	0f 86 ba 02 00 00    	jbe    70a7c6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0xb36>
  70a50c:	49 8d be b0 05 00 00 	lea    0x5b0(%r14),%rdi
  70a513:	49 8b 86 98 02 00 00 	mov    0x298(%r14),%rax
  70a51a:	4b 8d 0c bf          	lea    (%r15,%r15,4),%rcx
  70a51e:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
  70a522:	ff 15 48 f1 41 00    	call   *0x41f148(%rip)        # b29670 <_DYNAMIC+0x500>
  70a528:	49 89 c7             	mov    %rax,%r15
  70a52b:	49 89 d4             	mov    %rdx,%r12
  70a52e:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  70a533:	4c 89 f6             	mov    %r14,%rsi
  70a536:	48 89 c2             	mov    %rax,%rdx
  70a539:	4c 89 e1             	mov    %r12,%rcx
  70a53c:	e8 af e6 ff ff       	call   708bf0 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::inspector_app_index>
  70a541:	83 7c 24 28 fe       	cmpl   $0xfffffffe,0x28(%rsp)
  70a546:	75 5f                	jne    70a5a7 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x917>
  70a548:	48 89 df             	mov    %rbx,%rdi
  70a54b:	4c 89 f6             	mov    %r14,%rsi
  70a54e:	4c 89 fa             	mov    %r15,%rdx
  70a551:	4c 89 e1             	mov    %r12,%rcx
  70a554:	48 81 c4 28 01 00 00 	add    $0x128,%rsp
  70a55b:	5b                   	pop    %rbx
  70a55c:	41 5c                	pop    %r12
  70a55e:	41 5d                	pop    %r13
  70a560:	41 5e                	pop    %r14
  70a562:	41 5f                	pop    %r15
  70a564:	5d                   	pop    %rbp
  70a565:	e9 e6 02 00 00       	jmp    70a850 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::inspector_select>
  70a56a:	8b 4c 24 5c          	mov    0x5c(%rsp),%ecx
  70a56e:	89 4b 34             	mov    %ecx,0x34(%rbx)
  70a571:	0f 10 44 24 4c       	movups 0x4c(%rsp),%xmm0
  70a576:	0f 11 43 24          	movups %xmm0,0x24(%rbx)
  70a57a:	0f 10 84 24 cc 00 00 	movups 0xcc(%rsp),%xmm0
  70a581:	00 
  70a582:	0f 11 43 14          	movups %xmm0,0x14(%rbx)
  70a586:	0f 28 84 24 c0 00 00 	movaps 0xc0(%rsp),%xmm0
  70a58d:	00 
  70a58e:	0f 11 43 08          	movups %xmm0,0x8(%rbx)
  70a592:	48 89 03             	mov    %rax,(%rbx)
  70a595:	e9 8b f7 ff ff       	jmp    709d25 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x95>
  70a59a:	48 8d 3d 8f 0b 3f 00 	lea    0x3f0b8f(%rip),%rdi        # afb130 <__frame_dummy_init_array_entry+0x828>
  70a5a1:	ff 15 d1 ee 41 00    	call   *0x41eed1(%rip)        # b29478 <_DYNAMIC+0x308>
  70a5a7:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  70a5ac:	e8 3f da fe ff       	call   6f7ff0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70a5b1:	41 0f 10 86 60 06 00 	movups 0x660(%r14),%xmm0
  70a5b8:	00 
  70a5b9:	41 0f b6 86 20 07 00 	movzbl 0x720(%r14),%eax
  70a5c0:	00 
  70a5c1:	49 83 be 80 06 00 00 	cmpq   $0x0,0x680(%r14)
  70a5c8:	00 
  70a5c9:	74 1c                	je     70a5e7 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x957>
  70a5cb:	84 c0                	test   %al,%al
  70a5cd:	74 0a                	je     70a5d9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x949>
  70a5cf:	49 83 be 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%r14)
  70a5d6:	ff 
  70a5d7:	74 0e                	je     70a5e7 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x957>
  70a5d9:	49 8b 96 90 06 00 00 	mov    0x690(%r14),%rdx
  70a5e0:	b9 01 00 00 00       	mov    $0x1,%ecx
  70a5e5:	eb 02                	jmp    70a5e9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x959>
  70a5e7:	31 c9                	xor    %ecx,%ecx
  70a5e9:	49 8b b6 08 07 00 00 	mov    0x708(%r14),%rsi
  70a5f0:	48 89 4b 08          	mov    %rcx,0x8(%rbx)
  70a5f4:	48 89 53 10          	mov    %rdx,0x10(%rbx)
  70a5f8:	0f 11 43 18          	movups %xmm0,0x18(%rbx)
  70a5fc:	48 89 73 28          	mov    %rsi,0x28(%rbx)
  70a600:	e9 f0 f9 ff ff       	jmp    709ff5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x365>
  70a605:	83 f8 23             	cmp    $0x23,%eax
  70a608:	0f 85 eb 00 00 00    	jne    70a6f9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0xa69>
  70a60e:	8b 44 24 30          	mov    0x30(%rsp),%eax
  70a612:	83 f8 0d             	cmp    $0xd,%eax
  70a615:	0f 84 12 01 00 00    	je     70a72d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0xa9d>
  70a61b:	83 f8 0e             	cmp    $0xe,%eax
  70a61e:	0f 85 d5 00 00 00    	jne    70a6f9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0xa69>
  70a624:	ba 07 00 00 00       	mov    $0x7,%edx
  70a629:	e9 04 01 00 00       	jmp    70a732 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0xaa2>
  70a62e:	c6 84 24 a0 00 00 00 	movb   $0x0,0xa0(%rsp)
  70a635:	00 
  70a636:	c7 84 24 a4 00 00 00 	movl   $0x0,0xa4(%rsp)
  70a63d:	00 00 00 00 
  70a641:	48 8d b4 24 a0 00 00 	lea    0xa0(%rsp),%rsi
  70a648:	00 
  70a649:	8b 7c 24 08          	mov    0x8(%rsp),%edi
  70a64d:	ff 15 25 f0 41 00    	call   *0x41f025(%rip)        # b29678 <_DYNAMIC+0x508>
  70a653:	66 85 c0             	test   %ax,%ax
  70a656:	74 2a                	je     70a682 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x9f2>
  70a658:	48 c1 e8 10          	shr    $0x10,%rax
  70a65c:	48 89 df             	mov    %rbx,%rdi
  70a65f:	4c 89 f6             	mov    %r14,%rsi
  70a662:	89 c2                	mov    %eax,%edx
  70a664:	48 81 c4 28 01 00 00 	add    $0x128,%rsp
  70a66b:	5b                   	pop    %rbx
  70a66c:	41 5c                	pop    %r12
  70a66e:	41 5d                	pop    %r13
  70a670:	41 5e                	pop    %r14
  70a672:	41 5f                	pop    %r15
  70a674:	5d                   	pop    %rbp
  70a675:	e9 f6 f4 ff ff       	jmp    709b70 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::reject_editor>
  70a67a:	c6 84 24 a0 00 00 00 	movb   $0xff,0xa0(%rsp)
  70a681:	ff 
  70a682:	4d 8b be 60 06 00 00 	mov    0x660(%r14),%r15
  70a689:	49 83 ff ff          	cmp    $0xffffffffffffffff,%r15
  70a68d:	0f 84 8e 00 00 00    	je     70a721 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0xa91>
  70a693:	48 c7 44 24 28 1f 00 	movq   $0x1f,0x28(%rsp)
  70a69a:	00 00 
  70a69c:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  70a6a1:	e8 4a d9 fe ff       	call   6f7ff0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70a6a6:	49 8b 86 10 06 00 00 	mov    0x610(%r14),%rax
  70a6ad:	48 85 c0             	test   %rax,%rax
  70a6b0:	0f 84 af 00 00 00    	je     70a765 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0xad5>
  70a6b6:	48 8b 80 d8 00 00 00 	mov    0xd8(%rax),%rax
  70a6bd:	48 85 c0             	test   %rax,%rax
  70a6c0:	0f 84 9f 00 00 00    	je     70a765 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0xad5>
  70a6c6:	49 ff c7             	inc    %r15
  70a6c9:	c6 40 13 ff          	movb   $0xff,0x13(%rax)
  70a6cd:	48 8d 84 24 a0 00 00 	lea    0xa0(%rsp),%rax
  70a6d4:	00 
  70a6d5:	48 89 04 24          	mov    %rax,(%rsp)
  70a6d9:	48 89 df             	mov    %rbx,%rdi
  70a6dc:	4c 89 f6             	mov    %r14,%rsi
  70a6df:	48 8b 54 24 60       	mov    0x60(%rsp),%rdx
  70a6e4:	4c 89 e1             	mov    %r12,%rcx
  70a6e7:	4d 89 f8             	mov    %r15,%r8
  70a6ea:	44 8b 4c 24 08       	mov    0x8(%rsp),%r9d
  70a6ef:	e8 0c 06 02 00       	call   72ad00 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::set_property_value_at>
  70a6f4:	e9 2c f6 ff ff       	jmp    709d25 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x95>
  70a6f9:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  70a6fe:	48 89 43 30          	mov    %rax,0x30(%rbx)
  70a702:	0f 10 44 24 28       	movups 0x28(%rsp),%xmm0
  70a707:	0f 10 4c 24 38       	movups 0x38(%rsp),%xmm1
  70a70c:	0f 10 54 24 48       	movups 0x48(%rsp),%xmm2
  70a711:	0f 11 53 20          	movups %xmm2,0x20(%rbx)
  70a715:	0f 11 4b 10          	movups %xmm1,0x10(%rbx)
  70a719:	0f 11 03             	movups %xmm0,(%rbx)
  70a71c:	e9 04 f6 ff ff       	jmp    709d25 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x95>
  70a721:	48 c7 03 1f 00 00 00 	movq   $0x1f,(%rbx)
  70a728:	e9 f8 f5 ff ff       	jmp    709d25 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x95>
  70a72d:	ba 06 00 00 00       	mov    $0x6,%edx
  70a732:	48 89 df             	mov    %rbx,%rdi
  70a735:	4c 89 f6             	mov    %r14,%rsi
  70a738:	e8 33 f4 ff ff       	call   709b70 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::reject_editor>
  70a73d:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  70a742:	e8 a9 d8 fe ff       	call   6f7ff0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70a747:	e9 d9 f5 ff ff       	jmp    709d25 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0x95>
  70a74c:	48 8d 3d 41 fe 95 ff 	lea    -0x6a01bf(%rip),%rdi        # 6a594 <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x32a7>
  70a753:	48 8d 15 4e 0a 3f 00 	lea    0x3f0a4e(%rip),%rdx        # afb1a8 <__frame_dummy_init_array_entry+0x8a0>
  70a75a:	be 28 00 00 00       	mov    $0x28,%esi
  70a75f:	ff 15 1b ef 41 00    	call   *0x41ef1b(%rip)        # b29680 <_DYNAMIC+0x510>
  70a765:	48 8d 3d 69 fe 95 ff 	lea    -0x6a0197(%rip),%rdi        # 6a5d5 <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x32e8>
  70a76c:	48 8d 15 45 09 3f 00 	lea    0x3f0945(%rip),%rdx        # afb0b8 <__frame_dummy_init_array_entry+0x7b0>
  70a773:	be 11 00 00 00       	mov    $0x11,%esi
  70a778:	ff 15 3a ed 41 00    	call   *0x41ed3a(%rip)        # b294b8 <_DYNAMIC+0x348>
  70a77e:	48 8d 3d c3 09 3f 00 	lea    0x3f09c3(%rip),%rdi        # afb148 <__frame_dummy_init_array_entry+0x840>
  70a785:	ff 15 ed ec 41 00    	call   *0x41eced(%rip)        # b29478 <_DYNAMIC+0x308>
  70a78b:	4c 89 ff             	mov    %r15,%rdi
  70a78e:	48 8d 15 cb 09 3f 00 	lea    0x3f09cb(%rip),%rdx        # afb160 <__frame_dummy_init_array_entry+0x858>
  70a795:	ff 15 2d ed 41 00    	call   *0x41ed2d(%rip)        # b294c8 <_DYNAMIC+0x358>
  70a79b:	0f 0b                	ud2
  70a79d:	48 8d 3d f0 fd 95 ff 	lea    -0x6a0210(%rip),%rdi        # 6a594 <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x32a7>
  70a7a4:	48 8d 15 15 0a 3f 00 	lea    0x3f0a15(%rip),%rdx        # afb1c0 <__frame_dummy_init_array_entry+0x8b8>
  70a7ab:	be 28 00 00 00       	mov    $0x28,%esi
  70a7b0:	ff 15 ca ee 41 00    	call   *0x41eeca(%rip)        # b29680 <_DYNAMIC+0x510>
  70a7b6:	48 8d 15 bb 09 3f 00 	lea    0x3f09bb(%rip),%rdx        # afb178 <__frame_dummy_init_array_entry+0x870>
  70a7bd:	4c 89 e7             	mov    %r12,%rdi
  70a7c0:	ff 15 02 ed 41 00    	call   *0x41ed02(%rip)        # b294c8 <_DYNAMIC+0x358>
  70a7c6:	48 8d 15 c3 09 3f 00 	lea    0x3f09c3(%rip),%rdx        # afb190 <__frame_dummy_init_array_entry+0x888>
  70a7cd:	4c 89 ff             	mov    %r15,%rdi
  70a7d0:	ff 15 f2 ec 41 00    	call   *0x41ecf2(%rip)        # b294c8 <_DYNAMIC+0x358>
  70a7d6:	48 89 c3             	mov    %rax,%rbx
  70a7d9:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  70a7de:	e8 0d d8 fe ff       	call   6f7ff0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70a7e3:	48 89 df             	mov    %rbx,%rdi
  70a7e6:	e8 65 ed 3e 00       	call   af9550 <_Unwind_Resume@plt>
  70a7eb:	4c 8b 74 24 20       	mov    0x20(%rsp),%r14
  70a7f0:	48 89 c3             	mov    %rax,%rbx
  70a7f3:	49 8b 75 08          	mov    0x8(%r13),%rsi
  70a7f7:	48 85 f6             	test   %rsi,%rsi
  70a7fa:	74 0d                	je     70a809 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action+0xb79>
  70a7fc:	49 8b 55 10          	mov    0x10(%r13),%rdx
  70a800:	48 89 ef             	mov    %rbp,%rdi
  70a803:	ff 15 af eb 41 00    	call   *0x41ebaf(%rip)        # b293b8 <_DYNAMIC+0x248>
  70a809:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  70a80e:	49 89 06             	mov    %rax,(%r14)
  70a811:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  70a816:	49 89 44 24 10       	mov    %rax,0x10(%r12)
  70a81b:	48 89 df             	mov    %rbx,%rdi
  70a81e:	e8 2d ed 3e 00       	call   af9550 <_Unwind_Resume@plt>
  70a823:	48 89 c3             	mov    %rax,%rbx
  70a826:	48 8b 7c 24 10       	mov    0x10(%rsp),%rdi
  70a82b:	48 8b 74 24 08       	mov    0x8(%rsp),%rsi
  70a830:	e8 3b a1 fe ff       	call   6f4970 <core::ptr::drop_glue::<core::option::Option<gpui::element::Handler>>>
  70a835:	48 89 df             	mov    %rbx,%rdi
  70a838:	e8 13 ed 3e 00       	call   af9550 <_Unwind_Resume@plt>
  70a83d:	ff 15 a5 eb 41 00    	call   *0x41eba5(%rip)        # b293e8 <_DYNAMIC+0x278>
