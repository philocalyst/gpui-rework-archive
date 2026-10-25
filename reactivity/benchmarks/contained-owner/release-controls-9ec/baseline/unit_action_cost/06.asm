
/tmp/gpui-contained-owner-unit-baseline-target/release/deps/unit_action_cost-bcf457ce7db1ee75:     file format elf64-x86-64


Disassembly of section .text:

000000000070e4a0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::inspector_select>:
  70e4a0:	41 57                	push   %r15
  70e4a2:	41 56                	push   %r14
  70e4a4:	41 55                	push   %r13
  70e4a6:	41 54                	push   %r12
  70e4a8:	53                   	push   %rbx
  70e4a9:	48 83 ec 60          	sub    $0x60,%rsp
  70e4ad:	80 be 22 07 00 00 00 	cmpb   $0x0,0x722(%rsi)
  70e4b4:	74 0c                	je     70e4c2 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::inspector_select+0x22>
  70e4b6:	48 c7 07 0e 00 00 00 	movq   $0xe,(%rdi)
  70e4bd:	e9 69 01 00 00       	jmp    70e62b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::inspector_select+0x18b>
  70e4c2:	48 3b 96 b0 05 00 00 	cmp    0x5b0(%rsi),%rdx
  70e4c9:	0f 85 14 01 00 00    	jne    70e5e3 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::inspector_select+0x143>
  70e4cf:	49 89 d6             	mov    %rdx,%r14
  70e4d2:	48 89 fb             	mov    %rdi,%rbx
  70e4d5:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  70e4da:	49 89 f4             	mov    %rsi,%r12
  70e4dd:	49 89 cf             	mov    %rcx,%r15
  70e4e0:	48 89 ca             	mov    %rcx,%rdx
  70e4e3:	e8 98 ed 00 00       	call   71d280 <<gpui::runtime::Runtime<unit_action_cost::Model>>::resolve_identity>
  70e4e8:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
  70e4ed:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  70e4f2:	48 83 f9 fe          	cmp    $0xfffffffffffffffe,%rcx
  70e4f6:	0f 85 ee 00 00 00    	jne    70e5ea <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::inspector_select+0x14a>
  70e4fc:	49 8b b4 24 10 06 00 	mov    0x610(%r12),%rsi
  70e503:	00 
  70e504:	b9 1a 00 00 00       	mov    $0x1a,%ecx
  70e509:	48 85 f6             	test   %rsi,%rsi
  70e50c:	48 89 df             	mov    %rbx,%rdi
  70e50f:	0f 84 29 01 00 00    	je     70e63e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::inspector_select+0x19e>
  70e515:	48 83 be d8 00 00 00 	cmpq   $0x0,0xd8(%rsi)
  70e51c:	00 
  70e51d:	0f 84 1b 01 00 00    	je     70e63e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::inspector_select+0x19e>
  70e523:	4c 89 e2             	mov    %r12,%rdx
  70e526:	49 8b b4 24 a0 02 00 	mov    0x2a0(%r12),%rsi
  70e52d:	00 
  70e52e:	48 83 fe 1c          	cmp    $0x1c,%rsi
  70e532:	0f 82 d2 00 00 00    	jb     70e60a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::inspector_select+0x16a>
  70e538:	48 83 c6 e4          	add    $0xffffffffffffffe4,%rsi
  70e53c:	48 83 f8 02          	cmp    $0x2,%rax
  70e540:	0f 93 c1             	setae  %cl
  70e543:	48 39 f0             	cmp    %rsi,%rax
  70e546:	0f 92 c0             	setb   %al
  70e549:	84 c1                	test   %al,%cl
  70e54b:	0f 84 e8 00 00 00    	je     70e639 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::inspector_select+0x199>
  70e551:	4c 8b aa 60 06 00 00 	mov    0x660(%rdx),%r13
  70e558:	49 83 fd ff          	cmp    $0xffffffffffffffff,%r13
  70e55c:	0f 84 f7 00 00 00    	je     70e659 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::inspector_select+0x1b9>
  70e562:	48 c7 44 24 28 1f 00 	movq   $0x1f,0x28(%rsp)
  70e569:	00 00 
  70e56b:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  70e570:	e8 fb 5d ff ff       	call   704370 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70e575:	49 8b 84 24 10 06 00 	mov    0x610(%r12),%rax
  70e57c:	00 
  70e57d:	48 85 c0             	test   %rax,%rax
  70e580:	0f 84 ba 00 00 00    	je     70e640 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::inspector_select+0x1a0>
  70e586:	48 8b 80 d8 00 00 00 	mov    0xd8(%rax),%rax
  70e58d:	48 85 c0             	test   %rax,%rax
  70e590:	0f 84 aa 00 00 00    	je     70e640 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::inspector_select+0x1a0>
  70e596:	4c 89 e6             	mov    %r12,%rsi
  70e599:	49 ff c5             	inc    %r13
  70e59c:	4c 89 30             	mov    %r14,(%rax)
  70e59f:	4c 89 78 08          	mov    %r15,0x8(%rax)
  70e5a3:	66 c7 40 12 00 ff    	movw   $0xff00,0x12(%rax)
  70e5a9:	4d 89 ac 24 60 06 00 	mov    %r13,0x660(%r12)
  70e5b0:	00 
  70e5b1:	49 ff 84 24 b0 06 00 	incq   0x6b0(%r12)
  70e5b8:	00 
  70e5b9:	49 c7 84 24 08 07 00 	movq   $0x0,0x708(%r12)
  70e5c0:	00 00 00 00 00 
  70e5c5:	41 c6 84 24 1f 07 00 	movb   $0x1,0x71f(%r12)
  70e5cc:	00 01 
  70e5ce:	48 89 df             	mov    %rbx,%rdi
  70e5d1:	48 83 c4 60          	add    $0x60,%rsp
  70e5d5:	5b                   	pop    %rbx
  70e5d6:	41 5c                	pop    %r12
  70e5d8:	41 5d                	pop    %r13
  70e5da:	41 5e                	pop    %r14
  70e5dc:	41 5f                	pop    %r15
  70e5de:	e9 0d f5 00 00       	jmp    71daf0 <<gpui::runtime::Runtime<unit_action_cost::Model>>::present>
  70e5e3:	b9 11 00 00 00       	mov    $0x11,%ecx
  70e5e8:	eb 03                	jmp    70e5ed <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::inspector_select+0x14d>
  70e5ea:	48 89 df             	mov    %rbx,%rdi
  70e5ed:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  70e5f2:	48 89 54 24 20       	mov    %rdx,0x20(%rsp)
  70e5f7:	0f 10 44 24 38       	movups 0x38(%rsp),%xmm0
  70e5fc:	0f 10 4c 24 48       	movups 0x48(%rsp),%xmm1
  70e601:	0f 29 4c 24 10       	movaps %xmm1,0x10(%rsp)
  70e606:	0f 29 04 24          	movaps %xmm0,(%rsp)
  70e60a:	48 89 0f             	mov    %rcx,(%rdi)
  70e60d:	48 89 47 08          	mov    %rax,0x8(%rdi)
  70e611:	0f 28 04 24          	movaps (%rsp),%xmm0
  70e615:	0f 28 4c 24 10       	movaps 0x10(%rsp),%xmm1
  70e61a:	0f 11 47 10          	movups %xmm0,0x10(%rdi)
  70e61e:	0f 11 4f 20          	movups %xmm1,0x20(%rdi)
  70e622:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  70e627:	48 89 47 30          	mov    %rax,0x30(%rdi)
  70e62b:	48 83 c4 60          	add    $0x60,%rsp
  70e62f:	5b                   	pop    %rbx
  70e630:	41 5c                	pop    %r12
  70e632:	41 5d                	pop    %r13
  70e634:	41 5e                	pop    %r14
  70e636:	41 5f                	pop    %r15
  70e638:	c3                   	ret
  70e639:	b9 11 00 00 00       	mov    $0x11,%ecx
  70e63e:	eb ca                	jmp    70e60a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::inspector_select+0x16a>
  70e640:	48 8d 3d 7e ac 95 ff 	lea    -0x6a5382(%rip),%rdi        # 692c5 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x2c35>
  70e647:	48 8d 15 52 4e 3c 00 	lea    0x3c4e52(%rip),%rdx        # ad34a0 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.15092672030101349239+0x888>
  70e64e:	be 11 00 00 00       	mov    $0x11,%esi
  70e653:	ff 15 ff 2d 3f 00    	call   *0x3f2dff(%rip)        # b01458 <_DYNAMIC+0x368>
  70e659:	48 c7 03 1f 00 00 00 	movq   $0x1f,(%rbx)
  70e660:	eb c9                	jmp    70e62b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::inspector_select+0x18b>
