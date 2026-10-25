
/tmp/gpui-contained-owner-spike-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

00000000006fb5d0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing>:
  6fb5d0:	55                   	push   %rbp
  6fb5d1:	41 57                	push   %r15
  6fb5d3:	41 56                	push   %r14
  6fb5d5:	41 55                	push   %r13
  6fb5d7:	41 54                	push   %r12
  6fb5d9:	53                   	push   %rbx
  6fb5da:	48 83 ec 78          	sub    $0x78,%rsp
  6fb5de:	48 89 fb             	mov    %rdi,%rbx
  6fb5e1:	80 be 22 08 00 00 01 	cmpb   $0x1,0x822(%rsi)
  6fb5e8:	75 0c                	jne    6fb5f6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0x26>
  6fb5ea:	48 c7 03 0e 00 00 00 	movq   $0xe,(%rbx)
  6fb5f1:	e9 c4 00 00 00       	jmp    6fb6ba <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0xea>
  6fb5f6:	48 3b 8e b0 05 00 00 	cmp    0x5b0(%rsi),%rcx
  6fb5fd:	0f 85 90 00 00 00    	jne    6fb693 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0xc3>
  6fb603:	4d 89 cc             	mov    %r9,%r12
  6fb606:	49 89 d5             	mov    %rdx,%r13
  6fb609:	48 8d 7c 24 30       	lea    0x30(%rsp),%rdi
  6fb60e:	49 89 f6             	mov    %rsi,%r14
  6fb611:	4c 89 c2             	mov    %r8,%rdx
  6fb614:	e8 67 ee 01 00       	call   71a480 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::resolve_identity>
  6fb619:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  6fb61e:	4c 8b 7c 24 38       	mov    0x38(%rsp),%r15
  6fb623:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  6fb627:	75 6f                	jne    6fb698 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0xc8>
  6fb629:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  6fb630:	49 39 f7             	cmp    %rsi,%r15
  6fb633:	0f 83 7d 02 00 00    	jae    6fb8b6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0x2e6>
  6fb639:	4c 89 f0             	mov    %r14,%rax
  6fb63c:	49 8b 8e 98 02 00 00 	mov    0x298(%r14),%rcx
  6fb643:	4b 8d 14 bf          	lea    (%r15,%r15,4),%rdx
  6fb647:	8b 74 d1 20          	mov    0x20(%rcx,%rdx,8),%esi
  6fb64b:	83 e6 07             	and    $0x7,%esi
  6fb64e:	83 fe 02             	cmp    $0x2,%esi
  6fb651:	75 76                	jne    6fb6c9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0xf9>
  6fb653:	48 c7 80 08 07 00 00 	movq   $0x0,0x708(%rax)
  6fb65a:	00 00 00 00 
  6fb65e:	0f 10 80 60 06 00 00 	movups 0x660(%rax),%xmm0
  6fb665:	0f b6 88 20 08 00 00 	movzbl 0x820(%rax),%ecx
  6fb66c:	48 83 b8 80 06 00 00 	cmpq   $0x0,0x680(%rax)
  6fb673:	00 
  6fb674:	74 16                	je     6fb68c <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0xbc>
  6fb676:	84 c9                	test   %cl,%cl
  6fb678:	0f 84 06 01 00 00    	je     6fb784 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0x1b4>
  6fb67e:	48 83 b8 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%rax)
  6fb685:	ff 
  6fb686:	0f 85 f8 00 00 00    	jne    6fb784 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0x1b4>
  6fb68c:	31 c0                	xor    %eax,%eax
  6fb68e:	e9 fd 00 00 00       	jmp    6fb790 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0x1c0>
  6fb693:	b8 11 00 00 00       	mov    $0x11,%eax
  6fb698:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  6fb69d:	48 89 4b 30          	mov    %rcx,0x30(%rbx)
  6fb6a1:	0f 10 44 24 40       	movups 0x40(%rsp),%xmm0
  6fb6a6:	0f 10 4c 24 50       	movups 0x50(%rsp),%xmm1
  6fb6ab:	0f 11 4b 20          	movups %xmm1,0x20(%rbx)
  6fb6af:	0f 11 43 10          	movups %xmm0,0x10(%rbx)
  6fb6b3:	48 89 03             	mov    %rax,(%rbx)
  6fb6b6:	4c 89 7b 08          	mov    %r15,0x8(%rbx)
  6fb6ba:	48 83 c4 78          	add    $0x78,%rsp
  6fb6be:	5b                   	pop    %rbx
  6fb6bf:	41 5c                	pop    %r12
  6fb6c1:	41 5d                	pop    %r13
  6fb6c3:	41 5e                	pop    %r14
  6fb6c5:	41 5f                	pop    %r15
  6fb6c7:	5d                   	pop    %rbp
  6fb6c8:	c3                   	ret
  6fb6c9:	48 8d 2c d1          	lea    (%rcx,%rdx,8),%rbp
  6fb6cd:	48 83 7d 08 00       	cmpq   $0x0,0x8(%rbp)
  6fb6d2:	0f 84 a0 00 00 00    	je     6fb778 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0x1a8>
  6fb6d8:	48 83 c5 08          	add    $0x8,%rbp
  6fb6dc:	48 8d 90 10 07 00 00 	lea    0x710(%rax),%rdx
  6fb6e3:	4c 8d 80 28 02 00 00 	lea    0x228(%rax),%r8
  6fb6ea:	48 8d 0d 87 f2 3f 00 	lea    0x3ff287(%rip),%rcx        # afa978 <__frame_dummy_init_array_entry+0x70>
  6fb6f1:	4c 8d 0d a0 f2 3f 00 	lea    0x3ff2a0(%rip),%r9        # afa998 <__frame_dummy_init_array_entry+0x90>
  6fb6f8:	48 8d 7c 24 30       	lea    0x30(%rsp),%rdi
  6fb6fd:	48 89 ee             	mov    %rbp,%rsi
  6fb700:	48 89 54 24 70       	mov    %rdx,0x70(%rsp)
  6fb705:	ff 15 ed dd 42 00    	call   *0x42dded(%rip)        # b294f8 <_DYNAMIC+0x388>
  6fb70b:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  6fb710:	48 8b 54 24 38       	mov    0x38(%rsp),%rdx
  6fb715:	48 8b 4c 24 40       	mov    0x40(%rsp),%rcx
  6fb71a:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  6fb71f:	48 89 14 24          	mov    %rdx,(%rsp)
  6fb723:	48 89 54 24 18       	mov    %rdx,0x18(%rsp)
  6fb728:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
  6fb72d:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  6fb732:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  6fb736:	0f 84 0a 02 00 00    	je     6fb946 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0x376>
  6fb73c:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  6fb740:	75 71                	jne    6fb7b3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0x1e3>
  6fb742:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  6fb747:	e8 54 96 ff ff       	call   6f4da0 <core::ptr::drop_glue::<core::result::Result<core::result::Result<gpui::element::Admission, gpui::source::BindError>, alloc::boxed::Box<dyn core::any::Any + core::marker::Send>>>>
  6fb74c:	48 8b 0c 24          	mov    (%rsp),%rcx
  6fb750:	66 85 c9             	test   %cx,%cx
  6fb753:	74 7f                	je     6fb7d4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0x204>
  6fb755:	0f b7 c1             	movzwl %cx,%eax
  6fb758:	83 f8 01             	cmp    $0x1,%eax
  6fb75b:	0f 85 17 01 00 00    	jne    6fb878 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0x2a8>
  6fb761:	48 c1 e9 10          	shr    $0x10,%rcx
  6fb765:	48 89 df             	mov    %rbx,%rdi
  6fb768:	4c 89 f6             	mov    %r14,%rsi
  6fb76b:	4c 89 ea             	mov    %r13,%rdx
  6fb76e:	e8 6d d6 00 00       	call   708de0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action>
  6fb773:	e9 42 ff ff ff       	jmp    6fb6ba <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0xea>
  6fb778:	48 c7 03 16 00 00 00 	movq   $0x16,(%rbx)
  6fb77f:	e9 36 ff ff ff       	jmp    6fb6ba <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0xea>
  6fb784:	48 8b 90 90 06 00 00 	mov    0x690(%rax),%rdx
  6fb78b:	b8 01 00 00 00       	mov    $0x1,%eax
  6fb790:	48 89 43 08          	mov    %rax,0x8(%rbx)
  6fb794:	48 89 53 10          	mov    %rdx,0x10(%rbx)
  6fb798:	0f 11 43 18          	movups %xmm0,0x18(%rbx)
  6fb79c:	48 c7 43 28 00 00 00 	movq   $0x0,0x28(%rbx)
  6fb7a3:	00 
  6fb7a4:	88 4b 30             	mov    %cl,0x30(%rbx)
  6fb7a7:	48 c7 03 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rbx)
  6fb7ae:	e9 07 ff ff ff       	jmp    6fb6ba <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0xea>
  6fb7b3:	48 c7 03 20 00 00 00 	movq   $0x20,(%rbx)
  6fb7ba:	48 89 43 08          	mov    %rax,0x8(%rbx)
  6fb7be:	48 8b 04 24          	mov    (%rsp),%rax
  6fb7c2:	48 89 43 10          	mov    %rax,0x10(%rbx)
  6fb7c6:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  6fb7cb:	48 89 43 18          	mov    %rax,0x18(%rbx)
  6fb7cf:	e9 e6 fe ff ff       	jmp    6fb6ba <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0xea>
  6fb7d4:	4d 8b be 60 06 00 00 	mov    0x660(%r14),%r15
  6fb7db:	49 ff c7             	inc    %r15
  6fb7de:	0f 84 c6 00 00 00    	je     6fb8aa <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0x2da>
  6fb7e4:	48 c7 44 24 30 1f 00 	movq   $0x1f,0x30(%rsp)
  6fb7eb:	00 00 
  6fb7ed:	48 8d 7c 24 30       	lea    0x30(%rsp),%rdi
  6fb7f2:	e8 f9 c7 ff ff       	call   6f7ff0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  6fb7f7:	48 8d 0d 7a f1 3f 00 	lea    0x3ff17a(%rip),%rcx        # afa978 <__frame_dummy_init_array_entry+0x70>
  6fb7fe:	48 8d 7c 24 30       	lea    0x30(%rsp),%rdi
  6fb803:	48 89 ee             	mov    %rbp,%rsi
  6fb806:	48 8b 54 24 70       	mov    0x70(%rsp),%rdx
  6fb80b:	ff 15 ef dc 42 00    	call   *0x42dcef(%rip)        # b29500 <_DYNAMIC+0x390>
  6fb811:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  6fb816:	48 8b 4c 24 40       	mov    0x40(%rsp),%rcx
  6fb81b:	0f 28 44 24 30       	movaps 0x30(%rsp),%xmm0
  6fb820:	0f 29 44 24 10       	movaps %xmm0,0x10(%rsp)
  6fb825:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  6fb82a:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  6fb82e:	0f 84 ae 00 00 00    	je     6fb8e2 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0x312>
  6fb834:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  6fb838:	75 57                	jne    6fb891 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0x2c1>
  6fb83a:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  6fb83f:	e8 5c 95 ff ff       	call   6f4da0 <core::ptr::drop_glue::<core::result::Result<core::result::Result<gpui::element::Admission, gpui::source::BindError>, alloc::boxed::Box<dyn core::any::Any + core::marker::Send>>>>
  6fb844:	4d 89 be 60 06 00 00 	mov    %r15,0x660(%r14)
  6fb84b:	49 ff 86 b0 06 00 00 	incq   0x6b0(%r14)
  6fb852:	49 c7 86 08 07 00 00 	movq   $0x0,0x708(%r14)
  6fb859:	00 00 00 00 
  6fb85d:	48 89 df             	mov    %rbx,%rdi
  6fb860:	4c 89 f6             	mov    %r14,%rsi
  6fb863:	4c 89 ea             	mov    %r13,%rdx
  6fb866:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
  6fb86b:	4d 89 e0             	mov    %r12,%r8
  6fb86e:	e8 5d 01 00 00       	call   6fb9d0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing>
  6fb873:	e9 42 fe ff ff       	jmp    6fb6ba <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0xea>
  6fb878:	48 89 df             	mov    %rbx,%rdi
  6fb87b:	4c 89 f6             	mov    %r14,%rsi
  6fb87e:	4c 89 ea             	mov    %r13,%rdx
  6fb881:	4c 89 f9             	mov    %r15,%rcx
  6fb884:	4d 89 e0             	mov    %r12,%r8
  6fb887:	e8 44 f6 ff ff       	call   6faed0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property>
  6fb88c:	e9 29 fe ff ff       	jmp    6fb6ba <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0xea>
  6fb891:	0f 10 44 24 18       	movups 0x18(%rsp),%xmm0
  6fb896:	0f 11 43 10          	movups %xmm0,0x10(%rbx)
  6fb89a:	48 c7 03 20 00 00 00 	movq   $0x20,(%rbx)
  6fb8a1:	48 89 43 08          	mov    %rax,0x8(%rbx)
  6fb8a5:	e9 10 fe ff ff       	jmp    6fb6ba <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0xea>
  6fb8aa:	48 c7 03 1f 00 00 00 	movq   $0x1f,(%rbx)
  6fb8b1:	e9 04 fe ff ff       	jmp    6fb6ba <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0xea>
  6fb8b6:	48 8d 15 f3 f4 3f 00 	lea    0x3ff4f3(%rip),%rdx        # afadb0 <__frame_dummy_init_array_entry+0x4a8>
  6fb8bd:	4c 89 ff             	mov    %r15,%rdi
  6fb8c0:	ff 15 02 dc 42 00    	call   *0x42dc02(%rip)        # b294c8 <_DYNAMIC+0x358>
  6fb8c6:	48 89 c7             	mov    %rax,%rdi
  6fb8c9:	ff 15 09 dc 42 00    	call   *0x42dc09(%rip)        # b294d8 <_DYNAMIC+0x368>
  6fb8cf:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
  6fb8d4:	48 89 54 24 20       	mov    %rdx,0x20(%rsp)
  6fb8d9:	48 c7 44 24 10 fe ff 	movq   $0xfffffffffffffffe,0x10(%rsp)
  6fb8e0:	ff ff 
  6fb8e2:	4c 89 f7             	mov    %r14,%rdi
  6fb8e5:	e8 26 f2 01 00       	call   71ab10 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::poison>
  6fb8ea:	48 c7 03 0f 00 00 00 	movq   $0xf,(%rbx)
  6fb8f1:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  6fb8f6:	e8 a5 94 ff ff       	call   6f4da0 <core::ptr::drop_glue::<core::result::Result<core::result::Result<gpui::element::Admission, gpui::source::BindError>, alloc::boxed::Box<dyn core::any::Any + core::marker::Send>>>>
  6fb8fb:	e9 ba fd ff ff       	jmp    6fb6ba <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0xea>
  6fb900:	ff 15 da db 42 00    	call   *0x42dbda(%rip)        # b294e0 <_DYNAMIC+0x370>
  6fb906:	48 89 c3             	mov    %rax,%rbx
  6fb909:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  6fb90e:	e8 8d 94 ff ff       	call   6f4da0 <core::ptr::drop_glue::<core::result::Result<core::result::Result<gpui::element::Admission, gpui::source::BindError>, alloc::boxed::Box<dyn core::any::Any + core::marker::Send>>>>
  6fb913:	e9 aa 00 00 00       	jmp    6fb9c2 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0x3f2>
  6fb918:	48 89 c7             	mov    %rax,%rdi
  6fb91b:	ff 15 b7 db 42 00    	call   *0x42dbb7(%rip)        # b294d8 <_DYNAMIC+0x368>
  6fb921:	48 89 04 24          	mov    %rax,(%rsp)
  6fb925:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
  6fb92a:	48 8b 04 24          	mov    (%rsp),%rax
  6fb92e:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
  6fb933:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  6fb938:	48 89 44 24 20       	mov    %rax,0x20(%rsp)
  6fb93d:	48 c7 44 24 10 fe ff 	movq   $0xfffffffffffffffe,0x10(%rsp)
  6fb944:	ff ff 
  6fb946:	4c 89 f7             	mov    %r14,%rdi
  6fb949:	e8 c2 f1 01 00       	call   71ab10 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::poison>
  6fb94e:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  6fb953:	48 c7 03 0f 00 00 00 	movq   $0xf,(%rbx)
  6fb95a:	49 8b 06             	mov    (%r14),%rax
  6fb95d:	48 85 c0             	test   %rax,%rax
  6fb960:	74 06                	je     6fb968 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0x398>
  6fb962:	48 8b 3c 24          	mov    (%rsp),%rdi
  6fb966:	ff d0                	call   *%rax
  6fb968:	49 8b 76 08          	mov    0x8(%r14),%rsi
  6fb96c:	48 85 f6             	test   %rsi,%rsi
  6fb96f:	0f 84 45 fd ff ff    	je     6fb6ba <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0xea>
  6fb975:	49 8b 56 10          	mov    0x10(%r14),%rdx
  6fb979:	48 8b 3c 24          	mov    (%rsp),%rdi
  6fb97d:	ff 15 35 da 42 00    	call   *0x42da35(%rip)        # b293b8 <_DYNAMIC+0x248>
  6fb983:	e9 32 fd ff ff       	jmp    6fb6ba <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0xea>
  6fb988:	ff 15 52 db 42 00    	call   *0x42db52(%rip)        # b294e0 <_DYNAMIC+0x370>
  6fb98e:	48 89 c3             	mov    %rax,%rbx
  6fb991:	49 8b 76 08          	mov    0x8(%r14),%rsi
  6fb995:	48 85 f6             	test   %rsi,%rsi
  6fb998:	74 28                	je     6fb9c2 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0x3f2>
  6fb99a:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  6fb99f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  6fb9a3:	48 8b 3c 24          	mov    (%rsp),%rdi
  6fb9a7:	ff 15 0b da 42 00    	call   *0x42da0b(%rip)        # b293b8 <_DYNAMIC+0x248>
  6fb9ad:	48 89 df             	mov    %rbx,%rdi
  6fb9b0:	e8 9b db 3f 00       	call   af9550 <_Unwind_Resume@plt>
  6fb9b5:	48 89 c3             	mov    %rax,%rbx
  6fb9b8:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  6fb9bd:	e8 de 93 ff ff       	call   6f4da0 <core::ptr::drop_glue::<core::result::Result<core::result::Result<gpui::element::Admission, gpui::source::BindError>, alloc::boxed::Box<dyn core::any::Any + core::marker::Send>>>>
  6fb9c2:	48 89 df             	mov    %rbx,%rdi
  6fb9c5:	e8 86 db 3f 00       	call   af9550 <_Unwind_Resume@plt>
  6fb9ca:	ff 15 18 da 42 00    	call   *0x42da18(%rip)        # b293e8 <_DYNAMIC+0x278>
