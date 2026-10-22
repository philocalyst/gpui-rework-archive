
/tmp/gpui-contained-property-exchange-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

00000000006fe4d0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing>:
  6fe4d0:	55                   	push   %rbp
  6fe4d1:	41 57                	push   %r15
  6fe4d3:	41 56                	push   %r14
  6fe4d5:	41 55                	push   %r13
  6fe4d7:	41 54                	push   %r12
  6fe4d9:	53                   	push   %rbx
  6fe4da:	48 83 ec 78          	sub    $0x78,%rsp
  6fe4de:	48 89 fb             	mov    %rdi,%rbx
  6fe4e1:	80 be 22 07 00 00 01 	cmpb   $0x1,0x722(%rsi)
  6fe4e8:	75 0c                	jne    6fe4f6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0x26>
  6fe4ea:	48 c7 03 0e 00 00 00 	movq   $0xe,(%rbx)
  6fe4f1:	e9 c4 00 00 00       	jmp    6fe5ba <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0xea>
  6fe4f6:	48 3b 8e b0 05 00 00 	cmp    0x5b0(%rsi),%rcx
  6fe4fd:	0f 85 90 00 00 00    	jne    6fe593 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0xc3>
  6fe503:	4d 89 cc             	mov    %r9,%r12
  6fe506:	49 89 d5             	mov    %rdx,%r13
  6fe509:	48 8d 7c 24 30       	lea    0x30(%rsp),%rdi
  6fe50e:	49 89 f6             	mov    %rsi,%r14
  6fe511:	4c 89 c2             	mov    %r8,%rdx
  6fe514:	e8 07 a7 02 00       	call   728c20 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::resolve_identity>
  6fe519:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  6fe51e:	4c 8b 7c 24 38       	mov    0x38(%rsp),%r15
  6fe523:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  6fe527:	75 6f                	jne    6fe598 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0xc8>
  6fe529:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  6fe530:	49 39 f7             	cmp    %rsi,%r15
  6fe533:	0f 83 7d 02 00 00    	jae    6fe7b6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0x2e6>
  6fe539:	4c 89 f0             	mov    %r14,%rax
  6fe53c:	49 8b 8e 98 02 00 00 	mov    0x298(%r14),%rcx
  6fe543:	4b 8d 14 bf          	lea    (%r15,%r15,4),%rdx
  6fe547:	8b 74 d1 20          	mov    0x20(%rcx,%rdx,8),%esi
  6fe54b:	83 e6 07             	and    $0x7,%esi
  6fe54e:	83 fe 02             	cmp    $0x2,%esi
  6fe551:	75 76                	jne    6fe5c9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0xf9>
  6fe553:	48 c7 80 08 07 00 00 	movq   $0x0,0x708(%rax)
  6fe55a:	00 00 00 00 
  6fe55e:	0f 10 80 60 06 00 00 	movups 0x660(%rax),%xmm0
  6fe565:	0f b6 88 20 07 00 00 	movzbl 0x720(%rax),%ecx
  6fe56c:	48 83 b8 80 06 00 00 	cmpq   $0x0,0x680(%rax)
  6fe573:	00 
  6fe574:	74 16                	je     6fe58c <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0xbc>
  6fe576:	84 c9                	test   %cl,%cl
  6fe578:	0f 84 06 01 00 00    	je     6fe684 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0x1b4>
  6fe57e:	48 83 b8 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%rax)
  6fe585:	ff 
  6fe586:	0f 85 f8 00 00 00    	jne    6fe684 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0x1b4>
  6fe58c:	31 c0                	xor    %eax,%eax
  6fe58e:	e9 fd 00 00 00       	jmp    6fe690 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0x1c0>
  6fe593:	b8 11 00 00 00       	mov    $0x11,%eax
  6fe598:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  6fe59d:	48 89 4b 30          	mov    %rcx,0x30(%rbx)
  6fe5a1:	0f 10 44 24 40       	movups 0x40(%rsp),%xmm0
  6fe5a6:	0f 10 4c 24 50       	movups 0x50(%rsp),%xmm1
  6fe5ab:	0f 11 4b 20          	movups %xmm1,0x20(%rbx)
  6fe5af:	0f 11 43 10          	movups %xmm0,0x10(%rbx)
  6fe5b3:	48 89 03             	mov    %rax,(%rbx)
  6fe5b6:	4c 89 7b 08          	mov    %r15,0x8(%rbx)
  6fe5ba:	48 83 c4 78          	add    $0x78,%rsp
  6fe5be:	5b                   	pop    %rbx
  6fe5bf:	41 5c                	pop    %r12
  6fe5c1:	41 5d                	pop    %r13
  6fe5c3:	41 5e                	pop    %r14
  6fe5c5:	41 5f                	pop    %r15
  6fe5c7:	5d                   	pop    %rbp
  6fe5c8:	c3                   	ret
  6fe5c9:	48 8d 2c d1          	lea    (%rcx,%rdx,8),%rbp
  6fe5cd:	48 83 7d 08 00       	cmpq   $0x0,0x8(%rbp)
  6fe5d2:	0f 84 a0 00 00 00    	je     6fe678 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0x1a8>
  6fe5d8:	48 83 c5 08          	add    $0x8,%rbp
  6fe5dc:	48 8d 90 10 07 00 00 	lea    0x710(%rax),%rdx
  6fe5e3:	4c 8d 80 28 02 00 00 	lea    0x228(%rax),%r8
  6fe5ea:	48 8d 0d 27 c3 3f 00 	lea    0x3fc327(%rip),%rcx        # afa918 <__frame_dummy_init_array_entry+0xb0>
  6fe5f1:	4c 8d 0d 40 c3 3f 00 	lea    0x3fc340(%rip),%r9        # afa938 <__frame_dummy_init_array_entry+0xd0>
  6fe5f8:	48 8d 7c 24 30       	lea    0x30(%rsp),%rdi
  6fe5fd:	48 89 ee             	mov    %rbp,%rsi
  6fe600:	48 89 54 24 70       	mov    %rdx,0x70(%rsp)
  6fe605:	ff 15 05 ae 42 00    	call   *0x42ae05(%rip)        # b29410 <_DYNAMIC+0x388>
  6fe60b:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  6fe610:	48 8b 54 24 38       	mov    0x38(%rsp),%rdx
  6fe615:	48 8b 4c 24 40       	mov    0x40(%rsp),%rcx
  6fe61a:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  6fe61f:	48 89 14 24          	mov    %rdx,(%rsp)
  6fe623:	48 89 54 24 18       	mov    %rdx,0x18(%rsp)
  6fe628:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
  6fe62d:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  6fe632:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  6fe636:	0f 84 0a 02 00 00    	je     6fe846 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0x376>
  6fe63c:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  6fe640:	75 71                	jne    6fe6b3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0x1e3>
  6fe642:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  6fe647:	e8 54 66 ff ff       	call   6f4ca0 <core::ptr::drop_glue::<core::result::Result<core::result::Result<gpui::element::Admission, gpui::source::BindError>, alloc::boxed::Box<dyn core::any::Any + core::marker::Send>>>>
  6fe64c:	48 8b 0c 24          	mov    (%rsp),%rcx
  6fe650:	66 85 c9             	test   %cx,%cx
  6fe653:	74 7f                	je     6fe6d4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0x204>
  6fe655:	0f b7 c1             	movzwl %cx,%eax
  6fe658:	83 f8 01             	cmp    $0x1,%eax
  6fe65b:	0f 85 17 01 00 00    	jne    6fe778 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0x2a8>
  6fe661:	48 c1 e9 10          	shr    $0x10,%rcx
  6fe665:	48 89 df             	mov    %rbx,%rdi
  6fe668:	4c 89 f6             	mov    %r14,%rsi
  6fe66b:	4c 89 ea             	mov    %r13,%rdx
  6fe66e:	e8 1d b5 00 00       	call   709b90 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action>
  6fe673:	e9 42 ff ff ff       	jmp    6fe5ba <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0xea>
  6fe678:	48 c7 03 16 00 00 00 	movq   $0x16,(%rbx)
  6fe67f:	e9 36 ff ff ff       	jmp    6fe5ba <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0xea>
  6fe684:	48 8b 90 90 06 00 00 	mov    0x690(%rax),%rdx
  6fe68b:	b8 01 00 00 00       	mov    $0x1,%eax
  6fe690:	48 89 43 08          	mov    %rax,0x8(%rbx)
  6fe694:	48 89 53 10          	mov    %rdx,0x10(%rbx)
  6fe698:	0f 11 43 18          	movups %xmm0,0x18(%rbx)
  6fe69c:	48 c7 43 28 00 00 00 	movq   $0x0,0x28(%rbx)
  6fe6a3:	00 
  6fe6a4:	88 4b 30             	mov    %cl,0x30(%rbx)
  6fe6a7:	48 c7 03 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rbx)
  6fe6ae:	e9 07 ff ff ff       	jmp    6fe5ba <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0xea>
  6fe6b3:	48 c7 03 20 00 00 00 	movq   $0x20,(%rbx)
  6fe6ba:	48 89 43 08          	mov    %rax,0x8(%rbx)
  6fe6be:	48 8b 04 24          	mov    (%rsp),%rax
  6fe6c2:	48 89 43 10          	mov    %rax,0x10(%rbx)
  6fe6c6:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  6fe6cb:	48 89 43 18          	mov    %rax,0x18(%rbx)
  6fe6cf:	e9 e6 fe ff ff       	jmp    6fe5ba <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0xea>
  6fe6d4:	4d 8b be 60 06 00 00 	mov    0x660(%r14),%r15
  6fe6db:	49 ff c7             	inc    %r15
  6fe6de:	0f 84 c6 00 00 00    	je     6fe7aa <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0x2da>
  6fe6e4:	48 c7 44 24 30 1f 00 	movq   $0x1f,0x30(%rsp)
  6fe6eb:	00 00 
  6fe6ed:	48 8d 7c 24 30       	lea    0x30(%rsp),%rdi
  6fe6f2:	e8 f9 97 ff ff       	call   6f7ef0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  6fe6f7:	48 8d 0d 1a c2 3f 00 	lea    0x3fc21a(%rip),%rcx        # afa918 <__frame_dummy_init_array_entry+0xb0>
  6fe6fe:	48 8d 7c 24 30       	lea    0x30(%rsp),%rdi
  6fe703:	48 89 ee             	mov    %rbp,%rsi
  6fe706:	48 8b 54 24 70       	mov    0x70(%rsp),%rdx
  6fe70b:	ff 15 07 ad 42 00    	call   *0x42ad07(%rip)        # b29418 <_DYNAMIC+0x390>
  6fe711:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  6fe716:	48 8b 4c 24 40       	mov    0x40(%rsp),%rcx
  6fe71b:	0f 28 44 24 30       	movaps 0x30(%rsp),%xmm0
  6fe720:	0f 29 44 24 10       	movaps %xmm0,0x10(%rsp)
  6fe725:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  6fe72a:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  6fe72e:	0f 84 ae 00 00 00    	je     6fe7e2 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0x312>
  6fe734:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  6fe738:	75 57                	jne    6fe791 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0x2c1>
  6fe73a:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  6fe73f:	e8 5c 65 ff ff       	call   6f4ca0 <core::ptr::drop_glue::<core::result::Result<core::result::Result<gpui::element::Admission, gpui::source::BindError>, alloc::boxed::Box<dyn core::any::Any + core::marker::Send>>>>
  6fe744:	4d 89 be 60 06 00 00 	mov    %r15,0x660(%r14)
  6fe74b:	49 ff 86 b0 06 00 00 	incq   0x6b0(%r14)
  6fe752:	49 c7 86 08 07 00 00 	movq   $0x0,0x708(%r14)
  6fe759:	00 00 00 00 
  6fe75d:	48 89 df             	mov    %rbx,%rdi
  6fe760:	4c 89 f6             	mov    %r14,%rsi
  6fe763:	4c 89 ea             	mov    %r13,%rdx
  6fe766:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
  6fe76b:	4d 89 e0             	mov    %r12,%r8
  6fe76e:	e8 5d 01 00 00       	call   6fe8d0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing>
  6fe773:	e9 42 fe ff ff       	jmp    6fe5ba <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0xea>
  6fe778:	48 89 df             	mov    %rbx,%rdi
  6fe77b:	4c 89 f6             	mov    %r14,%rsi
  6fe77e:	4c 89 ea             	mov    %r13,%rdx
  6fe781:	4c 89 f9             	mov    %r15,%rcx
  6fe784:	4d 89 e0             	mov    %r12,%r8
  6fe787:	e8 44 f6 ff ff       	call   6fddd0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property>
  6fe78c:	e9 29 fe ff ff       	jmp    6fe5ba <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0xea>
  6fe791:	0f 10 44 24 18       	movups 0x18(%rsp),%xmm0
  6fe796:	0f 11 43 10          	movups %xmm0,0x10(%rbx)
  6fe79a:	48 c7 03 20 00 00 00 	movq   $0x20,(%rbx)
  6fe7a1:	48 89 43 08          	mov    %rax,0x8(%rbx)
  6fe7a5:	e9 10 fe ff ff       	jmp    6fe5ba <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0xea>
  6fe7aa:	48 c7 03 1f 00 00 00 	movq   $0x1f,(%rbx)
  6fe7b1:	e9 04 fe ff ff       	jmp    6fe5ba <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0xea>
  6fe7b6:	48 8d 15 53 c5 3f 00 	lea    0x3fc553(%rip),%rdx        # afad10 <__frame_dummy_init_array_entry+0x4a8>
  6fe7bd:	4c 89 ff             	mov    %r15,%rdi
  6fe7c0:	ff 15 1a ac 42 00    	call   *0x42ac1a(%rip)        # b293e0 <_DYNAMIC+0x358>
  6fe7c6:	48 89 c7             	mov    %rax,%rdi
  6fe7c9:	ff 15 21 ac 42 00    	call   *0x42ac21(%rip)        # b293f0 <_DYNAMIC+0x368>
  6fe7cf:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
  6fe7d4:	48 89 54 24 20       	mov    %rdx,0x20(%rsp)
  6fe7d9:	48 c7 44 24 10 fe ff 	movq   $0xfffffffffffffffe,0x10(%rsp)
  6fe7e0:	ff ff 
  6fe7e2:	4c 89 f7             	mov    %r14,%rdi
  6fe7e5:	e8 c6 aa 02 00       	call   7292b0 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::poison>
  6fe7ea:	48 c7 03 0f 00 00 00 	movq   $0xf,(%rbx)
  6fe7f1:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  6fe7f6:	e8 a5 64 ff ff       	call   6f4ca0 <core::ptr::drop_glue::<core::result::Result<core::result::Result<gpui::element::Admission, gpui::source::BindError>, alloc::boxed::Box<dyn core::any::Any + core::marker::Send>>>>
  6fe7fb:	e9 ba fd ff ff       	jmp    6fe5ba <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0xea>
  6fe800:	ff 15 f2 ab 42 00    	call   *0x42abf2(%rip)        # b293f8 <_DYNAMIC+0x370>
  6fe806:	48 89 c3             	mov    %rax,%rbx
  6fe809:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  6fe80e:	e8 8d 64 ff ff       	call   6f4ca0 <core::ptr::drop_glue::<core::result::Result<core::result::Result<gpui::element::Admission, gpui::source::BindError>, alloc::boxed::Box<dyn core::any::Any + core::marker::Send>>>>
  6fe813:	e9 aa 00 00 00       	jmp    6fe8c2 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0x3f2>
  6fe818:	48 89 c7             	mov    %rax,%rdi
  6fe81b:	ff 15 cf ab 42 00    	call   *0x42abcf(%rip)        # b293f0 <_DYNAMIC+0x368>
  6fe821:	48 89 04 24          	mov    %rax,(%rsp)
  6fe825:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
  6fe82a:	48 8b 04 24          	mov    (%rsp),%rax
  6fe82e:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
  6fe833:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  6fe838:	48 89 44 24 20       	mov    %rax,0x20(%rsp)
  6fe83d:	48 c7 44 24 10 fe ff 	movq   $0xfffffffffffffffe,0x10(%rsp)
  6fe844:	ff ff 
  6fe846:	4c 89 f7             	mov    %r14,%rdi
  6fe849:	e8 62 aa 02 00       	call   7292b0 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::poison>
  6fe84e:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  6fe853:	48 c7 03 0f 00 00 00 	movq   $0xf,(%rbx)
  6fe85a:	49 8b 06             	mov    (%r14),%rax
  6fe85d:	48 85 c0             	test   %rax,%rax
  6fe860:	74 06                	je     6fe868 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0x398>
  6fe862:	48 8b 3c 24          	mov    (%rsp),%rdi
  6fe866:	ff d0                	call   *%rax
  6fe868:	49 8b 76 08          	mov    0x8(%r14),%rsi
  6fe86c:	48 85 f6             	test   %rsi,%rsi
  6fe86f:	0f 84 45 fd ff ff    	je     6fe5ba <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0xea>
  6fe875:	49 8b 56 10          	mov    0x10(%r14),%rdx
  6fe879:	48 8b 3c 24          	mov    (%rsp),%rdi
  6fe87d:	ff 15 4d aa 42 00    	call   *0x42aa4d(%rip)        # b292d0 <_DYNAMIC+0x248>
  6fe883:	e9 32 fd ff ff       	jmp    6fe5ba <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0xea>
  6fe888:	ff 15 6a ab 42 00    	call   *0x42ab6a(%rip)        # b293f8 <_DYNAMIC+0x370>
  6fe88e:	48 89 c3             	mov    %rax,%rbx
  6fe891:	49 8b 76 08          	mov    0x8(%r14),%rsi
  6fe895:	48 85 f6             	test   %rsi,%rsi
  6fe898:	74 28                	je     6fe8c2 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0x3f2>
  6fe89a:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  6fe89f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  6fe8a3:	48 8b 3c 24          	mov    (%rsp),%rdi
  6fe8a7:	ff 15 23 aa 42 00    	call   *0x42aa23(%rip)        # b292d0 <_DYNAMIC+0x248>
  6fe8ad:	48 89 df             	mov    %rbx,%rdi
  6fe8b0:	e8 fb ab 3f 00       	call   af94b0 <_Unwind_Resume@plt>
  6fe8b5:	48 89 c3             	mov    %rax,%rbx
  6fe8b8:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  6fe8bd:	e8 de 63 ff ff       	call   6f4ca0 <core::ptr::drop_glue::<core::result::Result<core::result::Result<gpui::element::Admission, gpui::source::BindError>, alloc::boxed::Box<dyn core::any::Any + core::marker::Send>>>>
  6fe8c2:	48 89 df             	mov    %rbx,%rdi
  6fe8c5:	e8 e6 ab 3f 00       	call   af94b0 <_Unwind_Resume@plt>
  6fe8ca:	ff 15 30 aa 42 00    	call   *0x42aa30(%rip)        # b29300 <_DYNAMIC+0x278>
