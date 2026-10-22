
/tmp/gpui-contained-property-exchange-target/release/deps/unit_action_cost-bcf457ce7db1ee75:     file format elf64-x86-64


Disassembly of section .text:

000000000070ef30 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::inspector_select>:
  70ef30:	41 57                	push   %r15
  70ef32:	41 56                	push   %r14
  70ef34:	41 55                	push   %r13
  70ef36:	41 54                	push   %r12
  70ef38:	53                   	push   %rbx
  70ef39:	48 83 ec 60          	sub    $0x60,%rsp
  70ef3d:	80 be 22 07 00 00 00 	cmpb   $0x0,0x722(%rsi)
  70ef44:	74 0c                	je     70ef52 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::inspector_select+0x22>
  70ef46:	48 c7 07 0e 00 00 00 	movq   $0xe,(%rdi)
  70ef4d:	e9 69 01 00 00       	jmp    70f0bb <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::inspector_select+0x18b>
  70ef52:	48 3b 96 b0 05 00 00 	cmp    0x5b0(%rsi),%rdx
  70ef59:	0f 85 14 01 00 00    	jne    70f073 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::inspector_select+0x143>
  70ef5f:	49 89 d6             	mov    %rdx,%r14
  70ef62:	48 89 fb             	mov    %rdi,%rbx
  70ef65:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  70ef6a:	49 89 f4             	mov    %rsi,%r12
  70ef6d:	49 89 cf             	mov    %rcx,%r15
  70ef70:	48 89 ca             	mov    %rcx,%rdx
  70ef73:	e8 98 ed 00 00       	call   71dd10 <<gpui::runtime::Runtime<unit_action_cost::Model>>::resolve_identity>
  70ef78:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
  70ef7d:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  70ef82:	48 83 f9 fe          	cmp    $0xfffffffffffffffe,%rcx
  70ef86:	0f 85 ee 00 00 00    	jne    70f07a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::inspector_select+0x14a>
  70ef8c:	49 8b b4 24 10 06 00 	mov    0x610(%r12),%rsi
  70ef93:	00 
  70ef94:	b9 1a 00 00 00       	mov    $0x1a,%ecx
  70ef99:	48 85 f6             	test   %rsi,%rsi
  70ef9c:	48 89 df             	mov    %rbx,%rdi
  70ef9f:	0f 84 29 01 00 00    	je     70f0ce <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::inspector_select+0x19e>
  70efa5:	48 83 be d8 00 00 00 	cmpq   $0x0,0xd8(%rsi)
  70efac:	00 
  70efad:	0f 84 1b 01 00 00    	je     70f0ce <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::inspector_select+0x19e>
  70efb3:	4c 89 e2             	mov    %r12,%rdx
  70efb6:	49 8b b4 24 a0 02 00 	mov    0x2a0(%r12),%rsi
  70efbd:	00 
  70efbe:	48 83 fe 1c          	cmp    $0x1c,%rsi
  70efc2:	0f 82 d2 00 00 00    	jb     70f09a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::inspector_select+0x16a>
  70efc8:	48 83 c6 e4          	add    $0xffffffffffffffe4,%rsi
  70efcc:	48 83 f8 02          	cmp    $0x2,%rax
  70efd0:	0f 93 c1             	setae  %cl
  70efd3:	48 39 f0             	cmp    %rsi,%rax
  70efd6:	0f 92 c0             	setb   %al
  70efd9:	84 c1                	test   %al,%cl
  70efdb:	0f 84 e8 00 00 00    	je     70f0c9 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::inspector_select+0x199>
  70efe1:	4c 8b aa 60 06 00 00 	mov    0x660(%rdx),%r13
  70efe8:	49 83 fd ff          	cmp    $0xffffffffffffffff,%r13
  70efec:	0f 84 f7 00 00 00    	je     70f0e9 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::inspector_select+0x1b9>
  70eff2:	48 c7 44 24 28 1f 00 	movq   $0x1f,0x28(%rsp)
  70eff9:	00 00 
  70effb:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  70f000:	e8 cb 56 ff ff       	call   7046d0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70f005:	49 8b 84 24 10 06 00 	mov    0x610(%r12),%rax
  70f00c:	00 
  70f00d:	48 85 c0             	test   %rax,%rax
  70f010:	0f 84 ba 00 00 00    	je     70f0d0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::inspector_select+0x1a0>
  70f016:	48 8b 80 d8 00 00 00 	mov    0xd8(%rax),%rax
  70f01d:	48 85 c0             	test   %rax,%rax
  70f020:	0f 84 aa 00 00 00    	je     70f0d0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::inspector_select+0x1a0>
  70f026:	4c 89 e6             	mov    %r12,%rsi
  70f029:	49 ff c5             	inc    %r13
  70f02c:	4c 89 30             	mov    %r14,(%rax)
  70f02f:	4c 89 78 08          	mov    %r15,0x8(%rax)
  70f033:	66 c7 40 12 00 ff    	movw   $0xff00,0x12(%rax)
  70f039:	4d 89 ac 24 60 06 00 	mov    %r13,0x660(%r12)
  70f040:	00 
  70f041:	49 ff 84 24 b0 06 00 	incq   0x6b0(%r12)
  70f048:	00 
  70f049:	49 c7 84 24 08 07 00 	movq   $0x0,0x708(%r12)
  70f050:	00 00 00 00 00 
  70f055:	41 c6 84 24 1f 07 00 	movb   $0x1,0x71f(%r12)
  70f05c:	00 01 
  70f05e:	48 89 df             	mov    %rbx,%rdi
  70f061:	48 83 c4 60          	add    $0x60,%rsp
  70f065:	5b                   	pop    %rbx
  70f066:	41 5c                	pop    %r12
  70f068:	41 5d                	pop    %r13
  70f06a:	41 5e                	pop    %r14
  70f06c:	41 5f                	pop    %r15
  70f06e:	e9 0d f5 00 00       	jmp    71e580 <<gpui::runtime::Runtime<unit_action_cost::Model>>::present>
  70f073:	b9 11 00 00 00       	mov    $0x11,%ecx
  70f078:	eb 03                	jmp    70f07d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::inspector_select+0x14d>
  70f07a:	48 89 df             	mov    %rbx,%rdi
  70f07d:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  70f082:	48 89 54 24 20       	mov    %rdx,0x20(%rsp)
  70f087:	0f 10 44 24 38       	movups 0x38(%rsp),%xmm0
  70f08c:	0f 10 4c 24 48       	movups 0x48(%rsp),%xmm1
  70f091:	0f 29 4c 24 10       	movaps %xmm1,0x10(%rsp)
  70f096:	0f 29 04 24          	movaps %xmm0,(%rsp)
  70f09a:	48 89 0f             	mov    %rcx,(%rdi)
  70f09d:	48 89 47 08          	mov    %rax,0x8(%rdi)
  70f0a1:	0f 28 04 24          	movaps (%rsp),%xmm0
  70f0a5:	0f 28 4c 24 10       	movaps 0x10(%rsp),%xmm1
  70f0aa:	0f 11 47 10          	movups %xmm0,0x10(%rdi)
  70f0ae:	0f 11 4f 20          	movups %xmm1,0x20(%rdi)
  70f0b2:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  70f0b7:	48 89 47 30          	mov    %rax,0x30(%rdi)
  70f0bb:	48 83 c4 60          	add    $0x60,%rsp
  70f0bf:	5b                   	pop    %rbx
  70f0c0:	41 5c                	pop    %r12
  70f0c2:	41 5d                	pop    %r13
  70f0c4:	41 5e                	pop    %r14
  70f0c6:	41 5f                	pop    %r15
  70f0c8:	c3                   	ret
  70f0c9:	b9 11 00 00 00       	mov    $0x11,%ecx
  70f0ce:	eb ca                	jmp    70f09a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::inspector_select+0x16a>
  70f0d0:	48 8d 3d 2e a3 95 ff 	lea    -0x6a5cd2(%rip),%rdi        # 69405 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x2c45>
  70f0d7:	48 8d 15 da 4f 3c 00 	lea    0x3c4fda(%rip),%rdx        # ad40b8 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x8d0>
  70f0de:	be 11 00 00 00       	mov    $0x11,%esi
  70f0e3:	ff 15 c7 2f 3f 00    	call   *0x3f2fc7(%rip)        # b020b0 <_DYNAMIC+0x368>
  70f0e9:	48 c7 03 1f 00 00 00 	movq   $0x1f,(%rbx)
  70f0f0:	eb c9                	jmp    70f0bb <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::inspector_select+0x18b>
