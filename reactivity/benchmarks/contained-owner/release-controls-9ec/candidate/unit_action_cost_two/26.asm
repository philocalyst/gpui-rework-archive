
/tmp/gpui-contained-owner-spike-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

00000000006fb590 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing>:
  6fb590:	55                   	push   %rbp
  6fb591:	41 57                	push   %r15
  6fb593:	41 56                	push   %r14
  6fb595:	41 55                	push   %r13
  6fb597:	41 54                	push   %r12
  6fb599:	53                   	push   %rbx
  6fb59a:	48 83 ec 78          	sub    $0x78,%rsp
  6fb59e:	48 89 fb             	mov    %rdi,%rbx
  6fb5a1:	80 be 22 08 00 00 01 	cmpb   $0x1,0x822(%rsi)
  6fb5a8:	75 0c                	jne    6fb5b6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0x26>
  6fb5aa:	48 c7 03 0e 00 00 00 	movq   $0xe,(%rbx)
  6fb5b1:	e9 c4 00 00 00       	jmp    6fb67a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0xea>
  6fb5b6:	48 3b 8e b0 05 00 00 	cmp    0x5b0(%rsi),%rcx
  6fb5bd:	0f 85 90 00 00 00    	jne    6fb653 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0xc3>
  6fb5c3:	4d 89 cc             	mov    %r9,%r12
  6fb5c6:	49 89 d5             	mov    %rdx,%r13
  6fb5c9:	48 8d 7c 24 30       	lea    0x30(%rsp),%rdi
  6fb5ce:	49 89 f6             	mov    %rsi,%r14
  6fb5d1:	4c 89 c2             	mov    %r8,%rdx
  6fb5d4:	e8 37 ee 01 00       	call   71a410 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::resolve_identity>
  6fb5d9:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  6fb5de:	4c 8b 7c 24 38       	mov    0x38(%rsp),%r15
  6fb5e3:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  6fb5e7:	75 6f                	jne    6fb658 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0xc8>
  6fb5e9:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  6fb5f0:	49 39 f7             	cmp    %rsi,%r15
  6fb5f3:	0f 83 7d 02 00 00    	jae    6fb876 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0x2e6>
  6fb5f9:	4c 89 f0             	mov    %r14,%rax
  6fb5fc:	49 8b 8e 98 02 00 00 	mov    0x298(%r14),%rcx
  6fb603:	4b 8d 14 bf          	lea    (%r15,%r15,4),%rdx
  6fb607:	8b 74 d1 20          	mov    0x20(%rcx,%rdx,8),%esi
  6fb60b:	83 e6 07             	and    $0x7,%esi
  6fb60e:	83 fe 02             	cmp    $0x2,%esi
  6fb611:	75 76                	jne    6fb689 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0xf9>
  6fb613:	48 c7 80 08 07 00 00 	movq   $0x0,0x708(%rax)
  6fb61a:	00 00 00 00 
  6fb61e:	0f 10 80 60 06 00 00 	movups 0x660(%rax),%xmm0
  6fb625:	0f b6 88 20 08 00 00 	movzbl 0x820(%rax),%ecx
  6fb62c:	48 83 b8 80 06 00 00 	cmpq   $0x0,0x680(%rax)
  6fb633:	00 
  6fb634:	74 16                	je     6fb64c <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0xbc>
  6fb636:	84 c9                	test   %cl,%cl
  6fb638:	0f 84 06 01 00 00    	je     6fb744 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0x1b4>
  6fb63e:	48 83 b8 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%rax)
  6fb645:	ff 
  6fb646:	0f 85 f8 00 00 00    	jne    6fb744 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0x1b4>
  6fb64c:	31 c0                	xor    %eax,%eax
  6fb64e:	e9 fd 00 00 00       	jmp    6fb750 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0x1c0>
  6fb653:	b8 11 00 00 00       	mov    $0x11,%eax
  6fb658:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  6fb65d:	48 89 4b 30          	mov    %rcx,0x30(%rbx)
  6fb661:	0f 10 44 24 40       	movups 0x40(%rsp),%xmm0
  6fb666:	0f 10 4c 24 50       	movups 0x50(%rsp),%xmm1
  6fb66b:	0f 11 4b 20          	movups %xmm1,0x20(%rbx)
  6fb66f:	0f 11 43 10          	movups %xmm0,0x10(%rbx)
  6fb673:	48 89 03             	mov    %rax,(%rbx)
  6fb676:	4c 89 7b 08          	mov    %r15,0x8(%rbx)
  6fb67a:	48 83 c4 78          	add    $0x78,%rsp
  6fb67e:	5b                   	pop    %rbx
  6fb67f:	41 5c                	pop    %r12
  6fb681:	41 5d                	pop    %r13
  6fb683:	41 5e                	pop    %r14
  6fb685:	41 5f                	pop    %r15
  6fb687:	5d                   	pop    %rbp
  6fb688:	c3                   	ret
  6fb689:	48 8d 2c d1          	lea    (%rcx,%rdx,8),%rbp
  6fb68d:	48 83 7d 08 00       	cmpq   $0x0,0x8(%rbp)
  6fb692:	0f 84 a0 00 00 00    	je     6fb738 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0x1a8>
  6fb698:	48 83 c5 08          	add    $0x8,%rbp
  6fb69c:	48 8d 90 10 07 00 00 	lea    0x710(%rax),%rdx
  6fb6a3:	4c 8d 80 28 02 00 00 	lea    0x228(%rax),%r8
  6fb6aa:	48 8d 0d 57 f2 3f 00 	lea    0x3ff257(%rip),%rcx        # afa908 <__frame_dummy_init_array_entry+0x70>
  6fb6b1:	4c 8d 0d 70 f2 3f 00 	lea    0x3ff270(%rip),%r9        # afa928 <__frame_dummy_init_array_entry+0x90>
  6fb6b8:	48 8d 7c 24 30       	lea    0x30(%rsp),%rdi
  6fb6bd:	48 89 ee             	mov    %rbp,%rsi
  6fb6c0:	48 89 54 24 70       	mov    %rdx,0x70(%rsp)
  6fb6c5:	ff 15 bd dd 42 00    	call   *0x42ddbd(%rip)        # b29488 <_DYNAMIC+0x388>
  6fb6cb:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  6fb6d0:	48 8b 54 24 38       	mov    0x38(%rsp),%rdx
  6fb6d5:	48 8b 4c 24 40       	mov    0x40(%rsp),%rcx
  6fb6da:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  6fb6df:	48 89 14 24          	mov    %rdx,(%rsp)
  6fb6e3:	48 89 54 24 18       	mov    %rdx,0x18(%rsp)
  6fb6e8:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
  6fb6ed:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  6fb6f2:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  6fb6f6:	0f 84 0a 02 00 00    	je     6fb906 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0x376>
  6fb6fc:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  6fb700:	75 71                	jne    6fb773 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0x1e3>
  6fb702:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  6fb707:	e8 84 96 ff ff       	call   6f4d90 <core::ptr::drop_glue::<core::result::Result<core::result::Result<gpui::element::Admission, gpui::source::BindError>, alloc::boxed::Box<dyn core::any::Any + core::marker::Send>>>>
  6fb70c:	48 8b 0c 24          	mov    (%rsp),%rcx
  6fb710:	66 85 c9             	test   %cx,%cx
  6fb713:	74 7f                	je     6fb794 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0x204>
  6fb715:	0f b7 c1             	movzwl %cx,%eax
  6fb718:	83 f8 01             	cmp    $0x1,%eax
  6fb71b:	0f 85 17 01 00 00    	jne    6fb838 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0x2a8>
  6fb721:	48 c1 e9 10          	shr    $0x10,%rcx
  6fb725:	48 89 df             	mov    %rbx,%rdi
  6fb728:	4c 89 f6             	mov    %r14,%rsi
  6fb72b:	4c 89 ea             	mov    %r13,%rdx
  6fb72e:	e8 3d d6 00 00       	call   708d70 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action>
  6fb733:	e9 42 ff ff ff       	jmp    6fb67a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0xea>
  6fb738:	48 c7 03 16 00 00 00 	movq   $0x16,(%rbx)
  6fb73f:	e9 36 ff ff ff       	jmp    6fb67a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0xea>
  6fb744:	48 8b 90 90 06 00 00 	mov    0x690(%rax),%rdx
  6fb74b:	b8 01 00 00 00       	mov    $0x1,%eax
  6fb750:	48 89 43 08          	mov    %rax,0x8(%rbx)
  6fb754:	48 89 53 10          	mov    %rdx,0x10(%rbx)
  6fb758:	0f 11 43 18          	movups %xmm0,0x18(%rbx)
  6fb75c:	48 c7 43 28 00 00 00 	movq   $0x0,0x28(%rbx)
  6fb763:	00 
  6fb764:	88 4b 30             	mov    %cl,0x30(%rbx)
  6fb767:	48 c7 03 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rbx)
  6fb76e:	e9 07 ff ff ff       	jmp    6fb67a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0xea>
  6fb773:	48 c7 03 20 00 00 00 	movq   $0x20,(%rbx)
  6fb77a:	48 89 43 08          	mov    %rax,0x8(%rbx)
  6fb77e:	48 8b 04 24          	mov    (%rsp),%rax
  6fb782:	48 89 43 10          	mov    %rax,0x10(%rbx)
  6fb786:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  6fb78b:	48 89 43 18          	mov    %rax,0x18(%rbx)
  6fb78f:	e9 e6 fe ff ff       	jmp    6fb67a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0xea>
  6fb794:	4d 8b be 60 06 00 00 	mov    0x660(%r14),%r15
  6fb79b:	49 ff c7             	inc    %r15
  6fb79e:	0f 84 c6 00 00 00    	je     6fb86a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0x2da>
  6fb7a4:	48 c7 44 24 30 1f 00 	movq   $0x1f,0x30(%rsp)
  6fb7ab:	00 00 
  6fb7ad:	48 8d 7c 24 30       	lea    0x30(%rsp),%rdi
  6fb7b2:	e8 29 c8 ff ff       	call   6f7fe0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  6fb7b7:	48 8d 0d 4a f1 3f 00 	lea    0x3ff14a(%rip),%rcx        # afa908 <__frame_dummy_init_array_entry+0x70>
  6fb7be:	48 8d 7c 24 30       	lea    0x30(%rsp),%rdi
  6fb7c3:	48 89 ee             	mov    %rbp,%rsi
  6fb7c6:	48 8b 54 24 70       	mov    0x70(%rsp),%rdx
  6fb7cb:	ff 15 bf dc 42 00    	call   *0x42dcbf(%rip)        # b29490 <_DYNAMIC+0x390>
  6fb7d1:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  6fb7d6:	48 8b 4c 24 40       	mov    0x40(%rsp),%rcx
  6fb7db:	0f 28 44 24 30       	movaps 0x30(%rsp),%xmm0
  6fb7e0:	0f 29 44 24 10       	movaps %xmm0,0x10(%rsp)
  6fb7e5:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  6fb7ea:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  6fb7ee:	0f 84 ae 00 00 00    	je     6fb8a2 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0x312>
  6fb7f4:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  6fb7f8:	75 57                	jne    6fb851 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0x2c1>
  6fb7fa:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  6fb7ff:	e8 8c 95 ff ff       	call   6f4d90 <core::ptr::drop_glue::<core::result::Result<core::result::Result<gpui::element::Admission, gpui::source::BindError>, alloc::boxed::Box<dyn core::any::Any + core::marker::Send>>>>
  6fb804:	4d 89 be 60 06 00 00 	mov    %r15,0x660(%r14)
  6fb80b:	49 ff 86 b0 06 00 00 	incq   0x6b0(%r14)
  6fb812:	49 c7 86 08 07 00 00 	movq   $0x0,0x708(%r14)
  6fb819:	00 00 00 00 
  6fb81d:	48 89 df             	mov    %rbx,%rdi
  6fb820:	4c 89 f6             	mov    %r14,%rsi
  6fb823:	4c 89 ea             	mov    %r13,%rdx
  6fb826:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
  6fb82b:	4d 89 e0             	mov    %r12,%r8
  6fb82e:	e8 5d 01 00 00       	call   6fb990 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing>
  6fb833:	e9 42 fe ff ff       	jmp    6fb67a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0xea>
  6fb838:	48 89 df             	mov    %rbx,%rdi
  6fb83b:	4c 89 f6             	mov    %r14,%rsi
  6fb83e:	4c 89 ea             	mov    %r13,%rdx
  6fb841:	4c 89 f9             	mov    %r15,%rcx
  6fb844:	4d 89 e0             	mov    %r12,%r8
  6fb847:	e8 74 f6 ff ff       	call   6faec0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property>
  6fb84c:	e9 29 fe ff ff       	jmp    6fb67a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0xea>
  6fb851:	0f 10 44 24 18       	movups 0x18(%rsp),%xmm0
  6fb856:	0f 11 43 10          	movups %xmm0,0x10(%rbx)
  6fb85a:	48 c7 03 20 00 00 00 	movq   $0x20,(%rbx)
  6fb861:	48 89 43 08          	mov    %rax,0x8(%rbx)
  6fb865:	e9 10 fe ff ff       	jmp    6fb67a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0xea>
  6fb86a:	48 c7 03 1f 00 00 00 	movq   $0x1f,(%rbx)
  6fb871:	e9 04 fe ff ff       	jmp    6fb67a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0xea>
  6fb876:	48 8d 15 c3 f4 3f 00 	lea    0x3ff4c3(%rip),%rdx        # afad40 <__frame_dummy_init_array_entry+0x4a8>
  6fb87d:	4c 89 ff             	mov    %r15,%rdi
  6fb880:	ff 15 d2 db 42 00    	call   *0x42dbd2(%rip)        # b29458 <_DYNAMIC+0x358>
  6fb886:	48 89 c7             	mov    %rax,%rdi
  6fb889:	ff 15 d9 db 42 00    	call   *0x42dbd9(%rip)        # b29468 <_DYNAMIC+0x368>
  6fb88f:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
  6fb894:	48 89 54 24 20       	mov    %rdx,0x20(%rsp)
  6fb899:	48 c7 44 24 10 fe ff 	movq   $0xfffffffffffffffe,0x10(%rsp)
  6fb8a0:	ff ff 
  6fb8a2:	4c 89 f7             	mov    %r14,%rdi
  6fb8a5:	e8 f6 f1 01 00       	call   71aaa0 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::poison>
  6fb8aa:	48 c7 03 0f 00 00 00 	movq   $0xf,(%rbx)
  6fb8b1:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  6fb8b6:	e8 d5 94 ff ff       	call   6f4d90 <core::ptr::drop_glue::<core::result::Result<core::result::Result<gpui::element::Admission, gpui::source::BindError>, alloc::boxed::Box<dyn core::any::Any + core::marker::Send>>>>
  6fb8bb:	e9 ba fd ff ff       	jmp    6fb67a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0xea>
  6fb8c0:	ff 15 aa db 42 00    	call   *0x42dbaa(%rip)        # b29470 <_DYNAMIC+0x370>
  6fb8c6:	48 89 c3             	mov    %rax,%rbx
  6fb8c9:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  6fb8ce:	e8 bd 94 ff ff       	call   6f4d90 <core::ptr::drop_glue::<core::result::Result<core::result::Result<gpui::element::Admission, gpui::source::BindError>, alloc::boxed::Box<dyn core::any::Any + core::marker::Send>>>>
  6fb8d3:	e9 aa 00 00 00       	jmp    6fb982 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0x3f2>
  6fb8d8:	48 89 c7             	mov    %rax,%rdi
  6fb8db:	ff 15 87 db 42 00    	call   *0x42db87(%rip)        # b29468 <_DYNAMIC+0x368>
  6fb8e1:	48 89 04 24          	mov    %rax,(%rsp)
  6fb8e5:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
  6fb8ea:	48 8b 04 24          	mov    (%rsp),%rax
  6fb8ee:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
  6fb8f3:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  6fb8f8:	48 89 44 24 20       	mov    %rax,0x20(%rsp)
  6fb8fd:	48 c7 44 24 10 fe ff 	movq   $0xfffffffffffffffe,0x10(%rsp)
  6fb904:	ff ff 
  6fb906:	4c 89 f7             	mov    %r14,%rdi
  6fb909:	e8 92 f1 01 00       	call   71aaa0 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::poison>
  6fb90e:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  6fb913:	48 c7 03 0f 00 00 00 	movq   $0xf,(%rbx)
  6fb91a:	49 8b 06             	mov    (%r14),%rax
  6fb91d:	48 85 c0             	test   %rax,%rax
  6fb920:	74 06                	je     6fb928 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0x398>
  6fb922:	48 8b 3c 24          	mov    (%rsp),%rdi
  6fb926:	ff d0                	call   *%rax
  6fb928:	49 8b 76 08          	mov    0x8(%r14),%rsi
  6fb92c:	48 85 f6             	test   %rsi,%rsi
  6fb92f:	0f 84 45 fd ff ff    	je     6fb67a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0xea>
  6fb935:	49 8b 56 10          	mov    0x10(%r14),%rdx
  6fb939:	48 8b 3c 24          	mov    (%rsp),%rdi
  6fb93d:	ff 15 05 da 42 00    	call   *0x42da05(%rip)        # b29348 <_DYNAMIC+0x248>
  6fb943:	e9 32 fd ff ff       	jmp    6fb67a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0xea>
  6fb948:	ff 15 22 db 42 00    	call   *0x42db22(%rip)        # b29470 <_DYNAMIC+0x370>
  6fb94e:	48 89 c3             	mov    %rax,%rbx
  6fb951:	49 8b 76 08          	mov    0x8(%r14),%rsi
  6fb955:	48 85 f6             	test   %rsi,%rsi
  6fb958:	74 28                	je     6fb982 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0x3f2>
  6fb95a:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  6fb95f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  6fb963:	48 8b 3c 24          	mov    (%rsp),%rdi
  6fb967:	ff 15 db d9 42 00    	call   *0x42d9db(%rip)        # b29348 <_DYNAMIC+0x248>
  6fb96d:	48 89 df             	mov    %rbx,%rdi
  6fb970:	e8 6b db 3f 00       	call   af94e0 <_Unwind_Resume@plt>
  6fb975:	48 89 c3             	mov    %rax,%rbx
  6fb978:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  6fb97d:	e8 0e 94 ff ff       	call   6f4d90 <core::ptr::drop_glue::<core::result::Result<core::result::Result<gpui::element::Admission, gpui::source::BindError>, alloc::boxed::Box<dyn core::any::Any + core::marker::Send>>>>
  6fb982:	48 89 df             	mov    %rbx,%rdi
  6fb985:	e8 56 db 3f 00       	call   af94e0 <_Unwind_Resume@plt>
  6fb98a:	ff 15 e8 d9 42 00    	call   *0x42d9e8(%rip)        # b29378 <_DYNAMIC+0x278>
