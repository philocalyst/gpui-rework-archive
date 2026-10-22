
/tmp/gpui-contained-owner-spike-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

00000000006fe560 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing>:
  6fe560:	55                   	push   %rbp
  6fe561:	41 57                	push   %r15
  6fe563:	41 56                	push   %r14
  6fe565:	41 55                	push   %r13
  6fe567:	41 54                	push   %r12
  6fe569:	53                   	push   %rbx
  6fe56a:	48 83 ec 78          	sub    $0x78,%rsp
  6fe56e:	48 89 fb             	mov    %rdi,%rbx
  6fe571:	80 be 22 07 00 00 01 	cmpb   $0x1,0x722(%rsi)
  6fe578:	75 0c                	jne    6fe586 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0x26>
  6fe57a:	48 c7 03 0e 00 00 00 	movq   $0xe,(%rbx)
  6fe581:	e9 c4 00 00 00       	jmp    6fe64a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0xea>
  6fe586:	48 3b 8e b0 05 00 00 	cmp    0x5b0(%rsi),%rcx
  6fe58d:	0f 85 90 00 00 00    	jne    6fe623 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0xc3>
  6fe593:	4d 89 cc             	mov    %r9,%r12
  6fe596:	49 89 d5             	mov    %rdx,%r13
  6fe599:	48 8d 7c 24 30       	lea    0x30(%rsp),%rdi
  6fe59e:	49 89 f6             	mov    %rsi,%r14
  6fe5a1:	4c 89 c2             	mov    %r8,%rdx
  6fe5a4:	e8 07 a7 02 00       	call   728cb0 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::resolve_identity>
  6fe5a9:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  6fe5ae:	4c 8b 7c 24 38       	mov    0x38(%rsp),%r15
  6fe5b3:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  6fe5b7:	75 6f                	jne    6fe628 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0xc8>
  6fe5b9:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  6fe5c0:	49 39 f7             	cmp    %rsi,%r15
  6fe5c3:	0f 83 7d 02 00 00    	jae    6fe846 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0x2e6>
  6fe5c9:	4c 89 f0             	mov    %r14,%rax
  6fe5cc:	49 8b 8e 98 02 00 00 	mov    0x298(%r14),%rcx
  6fe5d3:	4b 8d 14 bf          	lea    (%r15,%r15,4),%rdx
  6fe5d7:	8b 74 d1 20          	mov    0x20(%rcx,%rdx,8),%esi
  6fe5db:	83 e6 07             	and    $0x7,%esi
  6fe5de:	83 fe 02             	cmp    $0x2,%esi
  6fe5e1:	75 76                	jne    6fe659 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0xf9>
  6fe5e3:	48 c7 80 08 07 00 00 	movq   $0x0,0x708(%rax)
  6fe5ea:	00 00 00 00 
  6fe5ee:	0f 10 80 60 06 00 00 	movups 0x660(%rax),%xmm0
  6fe5f5:	0f b6 88 20 07 00 00 	movzbl 0x720(%rax),%ecx
  6fe5fc:	48 83 b8 80 06 00 00 	cmpq   $0x0,0x680(%rax)
  6fe603:	00 
  6fe604:	74 16                	je     6fe61c <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0xbc>
  6fe606:	84 c9                	test   %cl,%cl
  6fe608:	0f 84 06 01 00 00    	je     6fe714 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0x1b4>
  6fe60e:	48 83 b8 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%rax)
  6fe615:	ff 
  6fe616:	0f 85 f8 00 00 00    	jne    6fe714 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0x1b4>
  6fe61c:	31 c0                	xor    %eax,%eax
  6fe61e:	e9 fd 00 00 00       	jmp    6fe720 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0x1c0>
  6fe623:	b8 11 00 00 00       	mov    $0x11,%eax
  6fe628:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  6fe62d:	48 89 4b 30          	mov    %rcx,0x30(%rbx)
  6fe631:	0f 10 44 24 40       	movups 0x40(%rsp),%xmm0
  6fe636:	0f 10 4c 24 50       	movups 0x50(%rsp),%xmm1
  6fe63b:	0f 11 4b 20          	movups %xmm1,0x20(%rbx)
  6fe63f:	0f 11 43 10          	movups %xmm0,0x10(%rbx)
  6fe643:	48 89 03             	mov    %rax,(%rbx)
  6fe646:	4c 89 7b 08          	mov    %r15,0x8(%rbx)
  6fe64a:	48 83 c4 78          	add    $0x78,%rsp
  6fe64e:	5b                   	pop    %rbx
  6fe64f:	41 5c                	pop    %r12
  6fe651:	41 5d                	pop    %r13
  6fe653:	41 5e                	pop    %r14
  6fe655:	41 5f                	pop    %r15
  6fe657:	5d                   	pop    %rbp
  6fe658:	c3                   	ret
  6fe659:	48 8d 2c d1          	lea    (%rcx,%rdx,8),%rbp
  6fe65d:	48 83 7d 08 00       	cmpq   $0x0,0x8(%rbp)
  6fe662:	0f 84 a0 00 00 00    	je     6fe708 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0x1a8>
  6fe668:	48 83 c5 08          	add    $0x8,%rbp
  6fe66c:	48 8d 90 10 07 00 00 	lea    0x710(%rax),%rdx
  6fe673:	4c 8d 80 28 02 00 00 	lea    0x228(%rax),%r8
  6fe67a:	48 8d 0d c7 c2 3f 00 	lea    0x3fc2c7(%rip),%rcx        # afa948 <__frame_dummy_init_array_entry+0xb0>
  6fe681:	4c 8d 0d e0 c2 3f 00 	lea    0x3fc2e0(%rip),%r9        # afa968 <__frame_dummy_init_array_entry+0xd0>
  6fe688:	48 8d 7c 24 30       	lea    0x30(%rsp),%rdi
  6fe68d:	48 89 ee             	mov    %rbp,%rsi
  6fe690:	48 89 54 24 70       	mov    %rdx,0x70(%rsp)
  6fe695:	ff 15 ed ad 42 00    	call   *0x42aded(%rip)        # b29488 <_DYNAMIC+0x388>
  6fe69b:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  6fe6a0:	48 8b 54 24 38       	mov    0x38(%rsp),%rdx
  6fe6a5:	48 8b 4c 24 40       	mov    0x40(%rsp),%rcx
  6fe6aa:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  6fe6af:	48 89 14 24          	mov    %rdx,(%rsp)
  6fe6b3:	48 89 54 24 18       	mov    %rdx,0x18(%rsp)
  6fe6b8:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
  6fe6bd:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  6fe6c2:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  6fe6c6:	0f 84 0a 02 00 00    	je     6fe8d6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0x376>
  6fe6cc:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  6fe6d0:	75 71                	jne    6fe743 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0x1e3>
  6fe6d2:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  6fe6d7:	e8 b4 66 ff ff       	call   6f4d90 <core::ptr::drop_glue::<core::result::Result<core::result::Result<gpui::element::Admission, gpui::source::BindError>, alloc::boxed::Box<dyn core::any::Any + core::marker::Send>>>>
  6fe6dc:	48 8b 0c 24          	mov    (%rsp),%rcx
  6fe6e0:	66 85 c9             	test   %cx,%cx
  6fe6e3:	74 7f                	je     6fe764 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0x204>
  6fe6e5:	0f b7 c1             	movzwl %cx,%eax
  6fe6e8:	83 f8 01             	cmp    $0x1,%eax
  6fe6eb:	0f 85 17 01 00 00    	jne    6fe808 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0x2a8>
  6fe6f1:	48 c1 e9 10          	shr    $0x10,%rcx
  6fe6f5:	48 89 df             	mov    %rbx,%rdi
  6fe6f8:	4c 89 f6             	mov    %r14,%rsi
  6fe6fb:	4c 89 ea             	mov    %r13,%rdx
  6fe6fe:	e8 1d b5 00 00       	call   709c20 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action>
  6fe703:	e9 42 ff ff ff       	jmp    6fe64a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0xea>
  6fe708:	48 c7 03 16 00 00 00 	movq   $0x16,(%rbx)
  6fe70f:	e9 36 ff ff ff       	jmp    6fe64a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0xea>
  6fe714:	48 8b 90 90 06 00 00 	mov    0x690(%rax),%rdx
  6fe71b:	b8 01 00 00 00       	mov    $0x1,%eax
  6fe720:	48 89 43 08          	mov    %rax,0x8(%rbx)
  6fe724:	48 89 53 10          	mov    %rdx,0x10(%rbx)
  6fe728:	0f 11 43 18          	movups %xmm0,0x18(%rbx)
  6fe72c:	48 c7 43 28 00 00 00 	movq   $0x0,0x28(%rbx)
  6fe733:	00 
  6fe734:	88 4b 30             	mov    %cl,0x30(%rbx)
  6fe737:	48 c7 03 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rbx)
  6fe73e:	e9 07 ff ff ff       	jmp    6fe64a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0xea>
  6fe743:	48 c7 03 20 00 00 00 	movq   $0x20,(%rbx)
  6fe74a:	48 89 43 08          	mov    %rax,0x8(%rbx)
  6fe74e:	48 8b 04 24          	mov    (%rsp),%rax
  6fe752:	48 89 43 10          	mov    %rax,0x10(%rbx)
  6fe756:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  6fe75b:	48 89 43 18          	mov    %rax,0x18(%rbx)
  6fe75f:	e9 e6 fe ff ff       	jmp    6fe64a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0xea>
  6fe764:	4d 8b be 60 06 00 00 	mov    0x660(%r14),%r15
  6fe76b:	49 ff c7             	inc    %r15
  6fe76e:	0f 84 c6 00 00 00    	je     6fe83a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0x2da>
  6fe774:	48 c7 44 24 30 1f 00 	movq   $0x1f,0x30(%rsp)
  6fe77b:	00 00 
  6fe77d:	48 8d 7c 24 30       	lea    0x30(%rsp),%rdi
  6fe782:	e8 59 98 ff ff       	call   6f7fe0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  6fe787:	48 8d 0d ba c1 3f 00 	lea    0x3fc1ba(%rip),%rcx        # afa948 <__frame_dummy_init_array_entry+0xb0>
  6fe78e:	48 8d 7c 24 30       	lea    0x30(%rsp),%rdi
  6fe793:	48 89 ee             	mov    %rbp,%rsi
  6fe796:	48 8b 54 24 70       	mov    0x70(%rsp),%rdx
  6fe79b:	ff 15 ef ac 42 00    	call   *0x42acef(%rip)        # b29490 <_DYNAMIC+0x390>
  6fe7a1:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  6fe7a6:	48 8b 4c 24 40       	mov    0x40(%rsp),%rcx
  6fe7ab:	0f 28 44 24 30       	movaps 0x30(%rsp),%xmm0
  6fe7b0:	0f 29 44 24 10       	movaps %xmm0,0x10(%rsp)
  6fe7b5:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  6fe7ba:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  6fe7be:	0f 84 ae 00 00 00    	je     6fe872 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0x312>
  6fe7c4:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  6fe7c8:	75 57                	jne    6fe821 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0x2c1>
  6fe7ca:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  6fe7cf:	e8 bc 65 ff ff       	call   6f4d90 <core::ptr::drop_glue::<core::result::Result<core::result::Result<gpui::element::Admission, gpui::source::BindError>, alloc::boxed::Box<dyn core::any::Any + core::marker::Send>>>>
  6fe7d4:	4d 89 be 60 06 00 00 	mov    %r15,0x660(%r14)
  6fe7db:	49 ff 86 b0 06 00 00 	incq   0x6b0(%r14)
  6fe7e2:	49 c7 86 08 07 00 00 	movq   $0x0,0x708(%r14)
  6fe7e9:	00 00 00 00 
  6fe7ed:	48 89 df             	mov    %rbx,%rdi
  6fe7f0:	4c 89 f6             	mov    %r14,%rsi
  6fe7f3:	4c 89 ea             	mov    %r13,%rdx
  6fe7f6:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
  6fe7fb:	4d 89 e0             	mov    %r12,%r8
  6fe7fe:	e8 5d 01 00 00       	call   6fe960 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing>
  6fe803:	e9 42 fe ff ff       	jmp    6fe64a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0xea>
  6fe808:	48 89 df             	mov    %rbx,%rdi
  6fe80b:	4c 89 f6             	mov    %r14,%rsi
  6fe80e:	4c 89 ea             	mov    %r13,%rdx
  6fe811:	4c 89 f9             	mov    %r15,%rcx
  6fe814:	4d 89 e0             	mov    %r12,%r8
  6fe817:	e8 74 f6 ff ff       	call   6fde90 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property>
  6fe81c:	e9 29 fe ff ff       	jmp    6fe64a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0xea>
  6fe821:	0f 10 44 24 18       	movups 0x18(%rsp),%xmm0
  6fe826:	0f 11 43 10          	movups %xmm0,0x10(%rbx)
  6fe82a:	48 c7 03 20 00 00 00 	movq   $0x20,(%rbx)
  6fe831:	48 89 43 08          	mov    %rax,0x8(%rbx)
  6fe835:	e9 10 fe ff ff       	jmp    6fe64a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0xea>
  6fe83a:	48 c7 03 1f 00 00 00 	movq   $0x1f,(%rbx)
  6fe841:	e9 04 fe ff ff       	jmp    6fe64a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0xea>
  6fe846:	48 8d 15 f3 c4 3f 00 	lea    0x3fc4f3(%rip),%rdx        # afad40 <__frame_dummy_init_array_entry+0x4a8>
  6fe84d:	4c 89 ff             	mov    %r15,%rdi
  6fe850:	ff 15 02 ac 42 00    	call   *0x42ac02(%rip)        # b29458 <_DYNAMIC+0x358>
  6fe856:	48 89 c7             	mov    %rax,%rdi
  6fe859:	ff 15 09 ac 42 00    	call   *0x42ac09(%rip)        # b29468 <_DYNAMIC+0x368>
  6fe85f:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
  6fe864:	48 89 54 24 20       	mov    %rdx,0x20(%rsp)
  6fe869:	48 c7 44 24 10 fe ff 	movq   $0xfffffffffffffffe,0x10(%rsp)
  6fe870:	ff ff 
  6fe872:	4c 89 f7             	mov    %r14,%rdi
  6fe875:	e8 c6 aa 02 00       	call   729340 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::poison>
  6fe87a:	48 c7 03 0f 00 00 00 	movq   $0xf,(%rbx)
  6fe881:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  6fe886:	e8 05 65 ff ff       	call   6f4d90 <core::ptr::drop_glue::<core::result::Result<core::result::Result<gpui::element::Admission, gpui::source::BindError>, alloc::boxed::Box<dyn core::any::Any + core::marker::Send>>>>
  6fe88b:	e9 ba fd ff ff       	jmp    6fe64a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0xea>
  6fe890:	ff 15 da ab 42 00    	call   *0x42abda(%rip)        # b29470 <_DYNAMIC+0x370>
  6fe896:	48 89 c3             	mov    %rax,%rbx
  6fe899:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  6fe89e:	e8 ed 64 ff ff       	call   6f4d90 <core::ptr::drop_glue::<core::result::Result<core::result::Result<gpui::element::Admission, gpui::source::BindError>, alloc::boxed::Box<dyn core::any::Any + core::marker::Send>>>>
  6fe8a3:	e9 aa 00 00 00       	jmp    6fe952 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0x3f2>
  6fe8a8:	48 89 c7             	mov    %rax,%rdi
  6fe8ab:	ff 15 b7 ab 42 00    	call   *0x42abb7(%rip)        # b29468 <_DYNAMIC+0x368>
  6fe8b1:	48 89 04 24          	mov    %rax,(%rsp)
  6fe8b5:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
  6fe8ba:	48 8b 04 24          	mov    (%rsp),%rax
  6fe8be:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
  6fe8c3:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  6fe8c8:	48 89 44 24 20       	mov    %rax,0x20(%rsp)
  6fe8cd:	48 c7 44 24 10 fe ff 	movq   $0xfffffffffffffffe,0x10(%rsp)
  6fe8d4:	ff ff 
  6fe8d6:	4c 89 f7             	mov    %r14,%rdi
  6fe8d9:	e8 62 aa 02 00       	call   729340 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::poison>
  6fe8de:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  6fe8e3:	48 c7 03 0f 00 00 00 	movq   $0xf,(%rbx)
  6fe8ea:	49 8b 06             	mov    (%r14),%rax
  6fe8ed:	48 85 c0             	test   %rax,%rax
  6fe8f0:	74 06                	je     6fe8f8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0x398>
  6fe8f2:	48 8b 3c 24          	mov    (%rsp),%rdi
  6fe8f6:	ff d0                	call   *%rax
  6fe8f8:	49 8b 76 08          	mov    0x8(%r14),%rsi
  6fe8fc:	48 85 f6             	test   %rsi,%rsi
  6fe8ff:	0f 84 45 fd ff ff    	je     6fe64a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0xea>
  6fe905:	49 8b 56 10          	mov    0x10(%r14),%rdx
  6fe909:	48 8b 3c 24          	mov    (%rsp),%rdi
  6fe90d:	ff 15 35 aa 42 00    	call   *0x42aa35(%rip)        # b29348 <_DYNAMIC+0x248>
  6fe913:	e9 32 fd ff ff       	jmp    6fe64a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0xea>
  6fe918:	ff 15 52 ab 42 00    	call   *0x42ab52(%rip)        # b29470 <_DYNAMIC+0x370>
  6fe91e:	48 89 c3             	mov    %rax,%rbx
  6fe921:	49 8b 76 08          	mov    0x8(%r14),%rsi
  6fe925:	48 85 f6             	test   %rsi,%rsi
  6fe928:	74 28                	je     6fe952 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0x3f2>
  6fe92a:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  6fe92f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  6fe933:	48 8b 3c 24          	mov    (%rsp),%rdi
  6fe937:	ff 15 0b aa 42 00    	call   *0x42aa0b(%rip)        # b29348 <_DYNAMIC+0x248>
  6fe93d:	48 89 df             	mov    %rbx,%rdi
  6fe940:	e8 9b ab 3f 00       	call   af94e0 <_Unwind_Resume@plt>
  6fe945:	48 89 c3             	mov    %rax,%rbx
  6fe948:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  6fe94d:	e8 3e 64 ff ff       	call   6f4d90 <core::ptr::drop_glue::<core::result::Result<core::result::Result<gpui::element::Admission, gpui::source::BindError>, alloc::boxed::Box<dyn core::any::Any + core::marker::Send>>>>
  6fe952:	48 89 df             	mov    %rbx,%rdi
  6fe955:	e8 86 ab 3f 00       	call   af94e0 <_Unwind_Resume@plt>
  6fe95a:	ff 15 18 aa 42 00    	call   *0x42aa18(%rip)        # b29378 <_DYNAMIC+0x278>
