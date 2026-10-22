
/tmp/gpui-contained-owner-spike-target/release/deps/unit_action_cost-bcf457ce7db1ee75:     file format elf64-x86-64


Disassembly of section .text:

000000000070f010 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::inspector_select>:
  70f010:	41 57                	push   %r15
  70f012:	41 56                	push   %r14
  70f014:	41 55                	push   %r13
  70f016:	41 54                	push   %r12
  70f018:	53                   	push   %rbx
  70f019:	48 83 ec 60          	sub    $0x60,%rsp
  70f01d:	80 be 22 07 00 00 00 	cmpb   $0x0,0x722(%rsi)
  70f024:	74 0c                	je     70f032 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::inspector_select+0x22>
  70f026:	48 c7 07 0e 00 00 00 	movq   $0xe,(%rdi)
  70f02d:	e9 69 01 00 00       	jmp    70f19b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::inspector_select+0x18b>
  70f032:	48 3b 96 b0 05 00 00 	cmp    0x5b0(%rsi),%rdx
  70f039:	0f 85 14 01 00 00    	jne    70f153 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::inspector_select+0x143>
  70f03f:	49 89 d6             	mov    %rdx,%r14
  70f042:	48 89 fb             	mov    %rdi,%rbx
  70f045:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  70f04a:	49 89 f4             	mov    %rsi,%r12
  70f04d:	49 89 cf             	mov    %rcx,%r15
  70f050:	48 89 ca             	mov    %rcx,%rdx
  70f053:	e8 98 ed 00 00       	call   71ddf0 <<gpui::runtime::Runtime<unit_action_cost::Model>>::resolve_identity>
  70f058:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
  70f05d:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  70f062:	48 83 f9 fe          	cmp    $0xfffffffffffffffe,%rcx
  70f066:	0f 85 ee 00 00 00    	jne    70f15a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::inspector_select+0x14a>
  70f06c:	49 8b b4 24 10 06 00 	mov    0x610(%r12),%rsi
  70f073:	00 
  70f074:	b9 1a 00 00 00       	mov    $0x1a,%ecx
  70f079:	48 85 f6             	test   %rsi,%rsi
  70f07c:	48 89 df             	mov    %rbx,%rdi
  70f07f:	0f 84 29 01 00 00    	je     70f1ae <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::inspector_select+0x19e>
  70f085:	48 83 be d8 00 00 00 	cmpq   $0x0,0xd8(%rsi)
  70f08c:	00 
  70f08d:	0f 84 1b 01 00 00    	je     70f1ae <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::inspector_select+0x19e>
  70f093:	4c 89 e2             	mov    %r12,%rdx
  70f096:	49 8b b4 24 a0 02 00 	mov    0x2a0(%r12),%rsi
  70f09d:	00 
  70f09e:	48 83 fe 1c          	cmp    $0x1c,%rsi
  70f0a2:	0f 82 d2 00 00 00    	jb     70f17a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::inspector_select+0x16a>
  70f0a8:	48 83 c6 e4          	add    $0xffffffffffffffe4,%rsi
  70f0ac:	48 83 f8 02          	cmp    $0x2,%rax
  70f0b0:	0f 93 c1             	setae  %cl
  70f0b3:	48 39 f0             	cmp    %rsi,%rax
  70f0b6:	0f 92 c0             	setb   %al
  70f0b9:	84 c1                	test   %al,%cl
  70f0bb:	0f 84 e8 00 00 00    	je     70f1a9 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::inspector_select+0x199>
  70f0c1:	4c 8b aa 60 06 00 00 	mov    0x660(%rdx),%r13
  70f0c8:	49 83 fd ff          	cmp    $0xffffffffffffffff,%r13
  70f0cc:	0f 84 f7 00 00 00    	je     70f1c9 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::inspector_select+0x1b9>
  70f0d2:	48 c7 44 24 28 1f 00 	movq   $0x1f,0x28(%rsp)
  70f0d9:	00 00 
  70f0db:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  70f0e0:	e8 fb 56 ff ff       	call   7047e0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70f0e5:	49 8b 84 24 10 06 00 	mov    0x610(%r12),%rax
  70f0ec:	00 
  70f0ed:	48 85 c0             	test   %rax,%rax
  70f0f0:	0f 84 ba 00 00 00    	je     70f1b0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::inspector_select+0x1a0>
  70f0f6:	48 8b 80 d8 00 00 00 	mov    0xd8(%rax),%rax
  70f0fd:	48 85 c0             	test   %rax,%rax
  70f100:	0f 84 aa 00 00 00    	je     70f1b0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::inspector_select+0x1a0>
  70f106:	4c 89 e6             	mov    %r12,%rsi
  70f109:	49 ff c5             	inc    %r13
  70f10c:	4c 89 30             	mov    %r14,(%rax)
  70f10f:	4c 89 78 08          	mov    %r15,0x8(%rax)
  70f113:	66 c7 40 12 00 ff    	movw   $0xff00,0x12(%rax)
  70f119:	4d 89 ac 24 60 06 00 	mov    %r13,0x660(%r12)
  70f120:	00 
  70f121:	49 ff 84 24 b0 06 00 	incq   0x6b0(%r12)
  70f128:	00 
  70f129:	49 c7 84 24 08 07 00 	movq   $0x0,0x708(%r12)
  70f130:	00 00 00 00 00 
  70f135:	41 c6 84 24 1f 07 00 	movb   $0x1,0x71f(%r12)
  70f13c:	00 01 
  70f13e:	48 89 df             	mov    %rbx,%rdi
  70f141:	48 83 c4 60          	add    $0x60,%rsp
  70f145:	5b                   	pop    %rbx
  70f146:	41 5c                	pop    %r12
  70f148:	41 5d                	pop    %r13
  70f14a:	41 5e                	pop    %r14
  70f14c:	41 5f                	pop    %r15
  70f14e:	e9 0d f5 00 00       	jmp    71e660 <<gpui::runtime::Runtime<unit_action_cost::Model>>::present>
  70f153:	b9 11 00 00 00       	mov    $0x11,%ecx
  70f158:	eb 03                	jmp    70f15d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::inspector_select+0x14d>
  70f15a:	48 89 df             	mov    %rbx,%rdi
  70f15d:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  70f162:	48 89 54 24 20       	mov    %rdx,0x20(%rsp)
  70f167:	0f 10 44 24 38       	movups 0x38(%rsp),%xmm0
  70f16c:	0f 10 4c 24 48       	movups 0x48(%rsp),%xmm1
  70f171:	0f 29 4c 24 10       	movaps %xmm1,0x10(%rsp)
  70f176:	0f 29 04 24          	movaps %xmm0,(%rsp)
  70f17a:	48 89 0f             	mov    %rcx,(%rdi)
  70f17d:	48 89 47 08          	mov    %rax,0x8(%rdi)
  70f181:	0f 28 04 24          	movaps (%rsp),%xmm0
  70f185:	0f 28 4c 24 10       	movaps 0x10(%rsp),%xmm1
  70f18a:	0f 11 47 10          	movups %xmm0,0x10(%rdi)
  70f18e:	0f 11 4f 20          	movups %xmm1,0x20(%rdi)
  70f192:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  70f197:	48 89 47 30          	mov    %rax,0x30(%rdi)
  70f19b:	48 83 c4 60          	add    $0x60,%rsp
  70f19f:	5b                   	pop    %rbx
  70f1a0:	41 5c                	pop    %r12
  70f1a2:	41 5d                	pop    %r13
  70f1a4:	41 5e                	pop    %r14
  70f1a6:	41 5f                	pop    %r15
  70f1a8:	c3                   	ret
  70f1a9:	b9 11 00 00 00       	mov    $0x11,%ecx
  70f1ae:	eb ca                	jmp    70f17a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::inspector_select+0x16a>
  70f1b0:	48 8d 3d ae a2 95 ff 	lea    -0x6a5d52(%rip),%rdi        # 69465 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x2c45>
  70f1b7:	48 8d 15 8a 4f 3c 00 	lea    0x3c4f8a(%rip),%rdx        # ad4148 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x8d0>
  70f1be:	be 11 00 00 00       	mov    $0x11,%esi
  70f1c3:	ff 15 b7 2f 3f 00    	call   *0x3f2fb7(%rip)        # b02180 <_DYNAMIC+0x368>
  70f1c9:	48 c7 03 1f 00 00 00 	movq   $0x1f,(%rbx)
  70f1d0:	eb c9                	jmp    70f19b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::inspector_select+0x18b>
