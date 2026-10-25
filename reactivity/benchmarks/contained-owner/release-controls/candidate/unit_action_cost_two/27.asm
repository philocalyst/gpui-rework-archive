
/tmp/gpui-contained-owner-spike-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

00000000006fe5d0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing>:
  6fe5d0:	55                   	push   %rbp
  6fe5d1:	41 57                	push   %r15
  6fe5d3:	41 56                	push   %r14
  6fe5d5:	41 55                	push   %r13
  6fe5d7:	41 54                	push   %r12
  6fe5d9:	53                   	push   %rbx
  6fe5da:	48 83 ec 78          	sub    $0x78,%rsp
  6fe5de:	48 89 fb             	mov    %rdi,%rbx
  6fe5e1:	80 be 22 07 00 00 01 	cmpb   $0x1,0x722(%rsi)
  6fe5e8:	75 0c                	jne    6fe5f6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0x26>
  6fe5ea:	48 c7 03 0e 00 00 00 	movq   $0xe,(%rbx)
  6fe5f1:	e9 c4 00 00 00       	jmp    6fe6ba <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0xea>
  6fe5f6:	48 3b 8e b0 05 00 00 	cmp    0x5b0(%rsi),%rcx
  6fe5fd:	0f 85 90 00 00 00    	jne    6fe693 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0xc3>
  6fe603:	4d 89 cc             	mov    %r9,%r12
  6fe606:	49 89 d5             	mov    %rdx,%r13
  6fe609:	48 8d 7c 24 30       	lea    0x30(%rsp),%rdi
  6fe60e:	49 89 f6             	mov    %rsi,%r14
  6fe611:	4c 89 c2             	mov    %r8,%rdx
  6fe614:	e8 07 a7 02 00       	call   728d20 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::resolve_identity>
  6fe619:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  6fe61e:	4c 8b 7c 24 38       	mov    0x38(%rsp),%r15
  6fe623:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  6fe627:	75 6f                	jne    6fe698 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0xc8>
  6fe629:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  6fe630:	49 39 f7             	cmp    %rsi,%r15
  6fe633:	0f 83 7d 02 00 00    	jae    6fe8b6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0x2e6>
  6fe639:	4c 89 f0             	mov    %r14,%rax
  6fe63c:	49 8b 8e 98 02 00 00 	mov    0x298(%r14),%rcx
  6fe643:	4b 8d 14 bf          	lea    (%r15,%r15,4),%rdx
  6fe647:	8b 74 d1 20          	mov    0x20(%rcx,%rdx,8),%esi
  6fe64b:	83 e6 07             	and    $0x7,%esi
  6fe64e:	83 fe 02             	cmp    $0x2,%esi
  6fe651:	75 76                	jne    6fe6c9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0xf9>
  6fe653:	48 c7 80 08 07 00 00 	movq   $0x0,0x708(%rax)
  6fe65a:	00 00 00 00 
  6fe65e:	0f 10 80 60 06 00 00 	movups 0x660(%rax),%xmm0
  6fe665:	0f b6 88 20 07 00 00 	movzbl 0x720(%rax),%ecx
  6fe66c:	48 83 b8 80 06 00 00 	cmpq   $0x0,0x680(%rax)
  6fe673:	00 
  6fe674:	74 16                	je     6fe68c <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0xbc>
  6fe676:	84 c9                	test   %cl,%cl
  6fe678:	0f 84 06 01 00 00    	je     6fe784 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0x1b4>
  6fe67e:	48 83 b8 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%rax)
  6fe685:	ff 
  6fe686:	0f 85 f8 00 00 00    	jne    6fe784 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0x1b4>
  6fe68c:	31 c0                	xor    %eax,%eax
  6fe68e:	e9 fd 00 00 00       	jmp    6fe790 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0x1c0>
  6fe693:	b8 11 00 00 00       	mov    $0x11,%eax
  6fe698:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  6fe69d:	48 89 4b 30          	mov    %rcx,0x30(%rbx)
  6fe6a1:	0f 10 44 24 40       	movups 0x40(%rsp),%xmm0
  6fe6a6:	0f 10 4c 24 50       	movups 0x50(%rsp),%xmm1
  6fe6ab:	0f 11 4b 20          	movups %xmm1,0x20(%rbx)
  6fe6af:	0f 11 43 10          	movups %xmm0,0x10(%rbx)
  6fe6b3:	48 89 03             	mov    %rax,(%rbx)
  6fe6b6:	4c 89 7b 08          	mov    %r15,0x8(%rbx)
  6fe6ba:	48 83 c4 78          	add    $0x78,%rsp
  6fe6be:	5b                   	pop    %rbx
  6fe6bf:	41 5c                	pop    %r12
  6fe6c1:	41 5d                	pop    %r13
  6fe6c3:	41 5e                	pop    %r14
  6fe6c5:	41 5f                	pop    %r15
  6fe6c7:	5d                   	pop    %rbp
  6fe6c8:	c3                   	ret
  6fe6c9:	48 8d 2c d1          	lea    (%rcx,%rdx,8),%rbp
  6fe6cd:	48 83 7d 08 00       	cmpq   $0x0,0x8(%rbp)
  6fe6d2:	0f 84 a0 00 00 00    	je     6fe778 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0x1a8>
  6fe6d8:	48 83 c5 08          	add    $0x8,%rbp
  6fe6dc:	48 8d 90 10 07 00 00 	lea    0x710(%rax),%rdx
  6fe6e3:	4c 8d 80 28 02 00 00 	lea    0x228(%rax),%r8
  6fe6ea:	48 8d 0d c7 c2 3f 00 	lea    0x3fc2c7(%rip),%rcx        # afa9b8 <__frame_dummy_init_array_entry+0xb0>
  6fe6f1:	4c 8d 0d e0 c2 3f 00 	lea    0x3fc2e0(%rip),%r9        # afa9d8 <__frame_dummy_init_array_entry+0xd0>
  6fe6f8:	48 8d 7c 24 30       	lea    0x30(%rsp),%rdi
  6fe6fd:	48 89 ee             	mov    %rbp,%rsi
  6fe700:	48 89 54 24 70       	mov    %rdx,0x70(%rsp)
  6fe705:	ff 15 ed ad 42 00    	call   *0x42aded(%rip)        # b294f8 <_DYNAMIC+0x388>
  6fe70b:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  6fe710:	48 8b 54 24 38       	mov    0x38(%rsp),%rdx
  6fe715:	48 8b 4c 24 40       	mov    0x40(%rsp),%rcx
  6fe71a:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  6fe71f:	48 89 14 24          	mov    %rdx,(%rsp)
  6fe723:	48 89 54 24 18       	mov    %rdx,0x18(%rsp)
  6fe728:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
  6fe72d:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  6fe732:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  6fe736:	0f 84 0a 02 00 00    	je     6fe946 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0x376>
  6fe73c:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  6fe740:	75 71                	jne    6fe7b3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0x1e3>
  6fe742:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  6fe747:	e8 54 66 ff ff       	call   6f4da0 <core::ptr::drop_glue::<core::result::Result<core::result::Result<gpui::element::Admission, gpui::source::BindError>, alloc::boxed::Box<dyn core::any::Any + core::marker::Send>>>>
  6fe74c:	48 8b 0c 24          	mov    (%rsp),%rcx
  6fe750:	66 85 c9             	test   %cx,%cx
  6fe753:	74 7f                	je     6fe7d4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0x204>
  6fe755:	0f b7 c1             	movzwl %cx,%eax
  6fe758:	83 f8 01             	cmp    $0x1,%eax
  6fe75b:	0f 85 17 01 00 00    	jne    6fe878 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0x2a8>
  6fe761:	48 c1 e9 10          	shr    $0x10,%rcx
  6fe765:	48 89 df             	mov    %rbx,%rdi
  6fe768:	4c 89 f6             	mov    %r14,%rsi
  6fe76b:	4c 89 ea             	mov    %r13,%rdx
  6fe76e:	e8 1d b5 00 00       	call   709c90 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::window_action>
  6fe773:	e9 42 ff ff ff       	jmp    6fe6ba <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0xea>
  6fe778:	48 c7 03 16 00 00 00 	movq   $0x16,(%rbx)
  6fe77f:	e9 36 ff ff ff       	jmp    6fe6ba <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0xea>
  6fe784:	48 8b 90 90 06 00 00 	mov    0x690(%rax),%rdx
  6fe78b:	b8 01 00 00 00       	mov    $0x1,%eax
  6fe790:	48 89 43 08          	mov    %rax,0x8(%rbx)
  6fe794:	48 89 53 10          	mov    %rdx,0x10(%rbx)
  6fe798:	0f 11 43 18          	movups %xmm0,0x18(%rbx)
  6fe79c:	48 c7 43 28 00 00 00 	movq   $0x0,0x28(%rbx)
  6fe7a3:	00 
  6fe7a4:	88 4b 30             	mov    %cl,0x30(%rbx)
  6fe7a7:	48 c7 03 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rbx)
  6fe7ae:	e9 07 ff ff ff       	jmp    6fe6ba <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0xea>
  6fe7b3:	48 c7 03 20 00 00 00 	movq   $0x20,(%rbx)
  6fe7ba:	48 89 43 08          	mov    %rax,0x8(%rbx)
  6fe7be:	48 8b 04 24          	mov    (%rsp),%rax
  6fe7c2:	48 89 43 10          	mov    %rax,0x10(%rbx)
  6fe7c6:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  6fe7cb:	48 89 43 18          	mov    %rax,0x18(%rbx)
  6fe7cf:	e9 e6 fe ff ff       	jmp    6fe6ba <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0xea>
  6fe7d4:	4d 8b be 60 06 00 00 	mov    0x660(%r14),%r15
  6fe7db:	49 ff c7             	inc    %r15
  6fe7de:	0f 84 c6 00 00 00    	je     6fe8aa <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0x2da>
  6fe7e4:	48 c7 44 24 30 1f 00 	movq   $0x1f,0x30(%rsp)
  6fe7eb:	00 00 
  6fe7ed:	48 8d 7c 24 30       	lea    0x30(%rsp),%rdi
  6fe7f2:	e8 f9 97 ff ff       	call   6f7ff0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  6fe7f7:	48 8d 0d ba c1 3f 00 	lea    0x3fc1ba(%rip),%rcx        # afa9b8 <__frame_dummy_init_array_entry+0xb0>
  6fe7fe:	48 8d 7c 24 30       	lea    0x30(%rsp),%rdi
  6fe803:	48 89 ee             	mov    %rbp,%rsi
  6fe806:	48 8b 54 24 70       	mov    0x70(%rsp),%rdx
  6fe80b:	ff 15 ef ac 42 00    	call   *0x42acef(%rip)        # b29500 <_DYNAMIC+0x390>
  6fe811:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  6fe816:	48 8b 4c 24 40       	mov    0x40(%rsp),%rcx
  6fe81b:	0f 28 44 24 30       	movaps 0x30(%rsp),%xmm0
  6fe820:	0f 29 44 24 10       	movaps %xmm0,0x10(%rsp)
  6fe825:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  6fe82a:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  6fe82e:	0f 84 ae 00 00 00    	je     6fe8e2 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0x312>
  6fe834:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  6fe838:	75 57                	jne    6fe891 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0x2c1>
  6fe83a:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  6fe83f:	e8 5c 65 ff ff       	call   6f4da0 <core::ptr::drop_glue::<core::result::Result<core::result::Result<gpui::element::Admission, gpui::source::BindError>, alloc::boxed::Box<dyn core::any::Any + core::marker::Send>>>>
  6fe844:	4d 89 be 60 06 00 00 	mov    %r15,0x660(%r14)
  6fe84b:	49 ff 86 b0 06 00 00 	incq   0x6b0(%r14)
  6fe852:	49 c7 86 08 07 00 00 	movq   $0x0,0x708(%r14)
  6fe859:	00 00 00 00 
  6fe85d:	48 89 df             	mov    %rbx,%rdi
  6fe860:	4c 89 f6             	mov    %r14,%rsi
  6fe863:	4c 89 ea             	mov    %r13,%rdx
  6fe866:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
  6fe86b:	4d 89 e0             	mov    %r12,%r8
  6fe86e:	e8 5d 01 00 00       	call   6fe9d0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing>
  6fe873:	e9 42 fe ff ff       	jmp    6fe6ba <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0xea>
  6fe878:	48 89 df             	mov    %rbx,%rdi
  6fe87b:	4c 89 f6             	mov    %r14,%rsi
  6fe87e:	4c 89 ea             	mov    %r13,%rdx
  6fe881:	4c 89 f9             	mov    %r15,%rcx
  6fe884:	4d 89 e0             	mov    %r12,%r8
  6fe887:	e8 44 f6 ff ff       	call   6fded0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property>
  6fe88c:	e9 29 fe ff ff       	jmp    6fe6ba <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0xea>
  6fe891:	0f 10 44 24 18       	movups 0x18(%rsp),%xmm0
  6fe896:	0f 11 43 10          	movups %xmm0,0x10(%rbx)
  6fe89a:	48 c7 03 20 00 00 00 	movq   $0x20,(%rbx)
  6fe8a1:	48 89 43 08          	mov    %rax,0x8(%rbx)
  6fe8a5:	e9 10 fe ff ff       	jmp    6fe6ba <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0xea>
  6fe8aa:	48 c7 03 1f 00 00 00 	movq   $0x1f,(%rbx)
  6fe8b1:	e9 04 fe ff ff       	jmp    6fe6ba <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0xea>
  6fe8b6:	48 8d 15 f3 c4 3f 00 	lea    0x3fc4f3(%rip),%rdx        # afadb0 <__frame_dummy_init_array_entry+0x4a8>
  6fe8bd:	4c 89 ff             	mov    %r15,%rdi
  6fe8c0:	ff 15 02 ac 42 00    	call   *0x42ac02(%rip)        # b294c8 <_DYNAMIC+0x358>
  6fe8c6:	48 89 c7             	mov    %rax,%rdi
  6fe8c9:	ff 15 09 ac 42 00    	call   *0x42ac09(%rip)        # b294d8 <_DYNAMIC+0x368>
  6fe8cf:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
  6fe8d4:	48 89 54 24 20       	mov    %rdx,0x20(%rsp)
  6fe8d9:	48 c7 44 24 10 fe ff 	movq   $0xfffffffffffffffe,0x10(%rsp)
  6fe8e0:	ff ff 
  6fe8e2:	4c 89 f7             	mov    %r14,%rdi
  6fe8e5:	e8 c6 aa 02 00       	call   7293b0 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::poison>
  6fe8ea:	48 c7 03 0f 00 00 00 	movq   $0xf,(%rbx)
  6fe8f1:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  6fe8f6:	e8 a5 64 ff ff       	call   6f4da0 <core::ptr::drop_glue::<core::result::Result<core::result::Result<gpui::element::Admission, gpui::source::BindError>, alloc::boxed::Box<dyn core::any::Any + core::marker::Send>>>>
  6fe8fb:	e9 ba fd ff ff       	jmp    6fe6ba <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0xea>
  6fe900:	ff 15 da ab 42 00    	call   *0x42abda(%rip)        # b294e0 <_DYNAMIC+0x370>
  6fe906:	48 89 c3             	mov    %rax,%rbx
  6fe909:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  6fe90e:	e8 8d 64 ff ff       	call   6f4da0 <core::ptr::drop_glue::<core::result::Result<core::result::Result<gpui::element::Admission, gpui::source::BindError>, alloc::boxed::Box<dyn core::any::Any + core::marker::Send>>>>
  6fe913:	e9 aa 00 00 00       	jmp    6fe9c2 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0x3f2>
  6fe918:	48 89 c7             	mov    %rax,%rdi
  6fe91b:	ff 15 b7 ab 42 00    	call   *0x42abb7(%rip)        # b294d8 <_DYNAMIC+0x368>
  6fe921:	48 89 04 24          	mov    %rax,(%rsp)
  6fe925:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
  6fe92a:	48 8b 04 24          	mov    (%rsp),%rax
  6fe92e:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
  6fe933:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  6fe938:	48 89 44 24 20       	mov    %rax,0x20(%rsp)
  6fe93d:	48 c7 44 24 10 fe ff 	movq   $0xfffffffffffffffe,0x10(%rsp)
  6fe944:	ff ff 
  6fe946:	4c 89 f7             	mov    %r14,%rdi
  6fe949:	e8 62 aa 02 00       	call   7293b0 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::poison>
  6fe94e:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  6fe953:	48 c7 03 0f 00 00 00 	movq   $0xf,(%rbx)
  6fe95a:	49 8b 06             	mov    (%r14),%rax
  6fe95d:	48 85 c0             	test   %rax,%rax
  6fe960:	74 06                	je     6fe968 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0x398>
  6fe962:	48 8b 3c 24          	mov    (%rsp),%rdi
  6fe966:	ff d0                	call   *%rax
  6fe968:	49 8b 76 08          	mov    0x8(%r14),%rsi
  6fe96c:	48 85 f6             	test   %rsi,%rsi
  6fe96f:	0f 84 45 fd ff ff    	je     6fe6ba <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0xea>
  6fe975:	49 8b 56 10          	mov    0x10(%r14),%rdx
  6fe979:	48 8b 3c 24          	mov    (%rsp),%rdi
  6fe97d:	ff 15 35 aa 42 00    	call   *0x42aa35(%rip)        # b293b8 <_DYNAMIC+0x248>
  6fe983:	e9 32 fd ff ff       	jmp    6fe6ba <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0xea>
  6fe988:	ff 15 52 ab 42 00    	call   *0x42ab52(%rip)        # b294e0 <_DYNAMIC+0x370>
  6fe98e:	48 89 c3             	mov    %rax,%rbx
  6fe991:	49 8b 76 08          	mov    0x8(%r14),%rsi
  6fe995:	48 85 f6             	test   %rsi,%rsi
  6fe998:	74 28                	je     6fe9c2 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_with_editing+0x3f2>
  6fe99a:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  6fe99f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  6fe9a3:	48 8b 3c 24          	mov    (%rsp),%rdi
  6fe9a7:	ff 15 0b aa 42 00    	call   *0x42aa0b(%rip)        # b293b8 <_DYNAMIC+0x248>
  6fe9ad:	48 89 df             	mov    %rbx,%rdi
  6fe9b0:	e8 9b ab 3f 00       	call   af9550 <_Unwind_Resume@plt>
  6fe9b5:	48 89 c3             	mov    %rax,%rbx
  6fe9b8:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  6fe9bd:	e8 de 63 ff ff       	call   6f4da0 <core::ptr::drop_glue::<core::result::Result<core::result::Result<gpui::element::Admission, gpui::source::BindError>, alloc::boxed::Box<dyn core::any::Any + core::marker::Send>>>>
  6fe9c2:	48 89 df             	mov    %rbx,%rdi
  6fe9c5:	e8 86 ab 3f 00       	call   af9550 <_Unwind_Resume@plt>
  6fe9ca:	ff 15 18 aa 42 00    	call   *0x42aa18(%rip)        # b293e8 <_DYNAMIC+0x278>
