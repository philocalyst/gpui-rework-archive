
/tmp/gpui-contained-property-exchange-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

00000000006fb4d0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing>:
  6fb4d0:	55                   	push   %rbp
  6fb4d1:	41 57                	push   %r15
  6fb4d3:	41 56                	push   %r14
  6fb4d5:	41 55                	push   %r13
  6fb4d7:	41 54                	push   %r12
  6fb4d9:	53                   	push   %rbx
  6fb4da:	48 83 ec 78          	sub    $0x78,%rsp
  6fb4de:	48 89 fb             	mov    %rdi,%rbx
  6fb4e1:	80 be 22 08 00 00 01 	cmpb   $0x1,0x822(%rsi)
  6fb4e8:	75 0c                	jne    6fb4f6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0x26>
  6fb4ea:	48 c7 03 0e 00 00 00 	movq   $0xe,(%rbx)
  6fb4f1:	e9 c4 00 00 00       	jmp    6fb5ba <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0xea>
  6fb4f6:	48 3b 8e b0 05 00 00 	cmp    0x5b0(%rsi),%rcx
  6fb4fd:	0f 85 90 00 00 00    	jne    6fb593 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0xc3>
  6fb503:	4d 89 cc             	mov    %r9,%r12
  6fb506:	49 89 d5             	mov    %rdx,%r13
  6fb509:	48 8d 7c 24 30       	lea    0x30(%rsp),%rdi
  6fb50e:	49 89 f6             	mov    %rsi,%r14
  6fb511:	4c 89 c2             	mov    %r8,%rdx
  6fb514:	e8 67 ee 01 00       	call   71a380 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::resolve_identity>
  6fb519:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  6fb51e:	4c 8b 7c 24 38       	mov    0x38(%rsp),%r15
  6fb523:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  6fb527:	75 6f                	jne    6fb598 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0xc8>
  6fb529:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  6fb530:	49 39 f7             	cmp    %rsi,%r15
  6fb533:	0f 83 7d 02 00 00    	jae    6fb7b6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0x2e6>
  6fb539:	4c 89 f0             	mov    %r14,%rax
  6fb53c:	49 8b 8e 98 02 00 00 	mov    0x298(%r14),%rcx
  6fb543:	4b 8d 14 bf          	lea    (%r15,%r15,4),%rdx
  6fb547:	8b 74 d1 20          	mov    0x20(%rcx,%rdx,8),%esi
  6fb54b:	83 e6 07             	and    $0x7,%esi
  6fb54e:	83 fe 02             	cmp    $0x2,%esi
  6fb551:	75 76                	jne    6fb5c9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0xf9>
  6fb553:	48 c7 80 08 07 00 00 	movq   $0x0,0x708(%rax)
  6fb55a:	00 00 00 00 
  6fb55e:	0f 10 80 60 06 00 00 	movups 0x660(%rax),%xmm0
  6fb565:	0f b6 88 20 08 00 00 	movzbl 0x820(%rax),%ecx
  6fb56c:	48 83 b8 80 06 00 00 	cmpq   $0x0,0x680(%rax)
  6fb573:	00 
  6fb574:	74 16                	je     6fb58c <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0xbc>
  6fb576:	84 c9                	test   %cl,%cl
  6fb578:	0f 84 06 01 00 00    	je     6fb684 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0x1b4>
  6fb57e:	48 83 b8 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%rax)
  6fb585:	ff 
  6fb586:	0f 85 f8 00 00 00    	jne    6fb684 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0x1b4>
  6fb58c:	31 c0                	xor    %eax,%eax
  6fb58e:	e9 fd 00 00 00       	jmp    6fb690 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0x1c0>
  6fb593:	b8 11 00 00 00       	mov    $0x11,%eax
  6fb598:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  6fb59d:	48 89 4b 30          	mov    %rcx,0x30(%rbx)
  6fb5a1:	0f 10 44 24 40       	movups 0x40(%rsp),%xmm0
  6fb5a6:	0f 10 4c 24 50       	movups 0x50(%rsp),%xmm1
  6fb5ab:	0f 11 4b 20          	movups %xmm1,0x20(%rbx)
  6fb5af:	0f 11 43 10          	movups %xmm0,0x10(%rbx)
  6fb5b3:	48 89 03             	mov    %rax,(%rbx)
  6fb5b6:	4c 89 7b 08          	mov    %r15,0x8(%rbx)
  6fb5ba:	48 83 c4 78          	add    $0x78,%rsp
  6fb5be:	5b                   	pop    %rbx
  6fb5bf:	41 5c                	pop    %r12
  6fb5c1:	41 5d                	pop    %r13
  6fb5c3:	41 5e                	pop    %r14
  6fb5c5:	41 5f                	pop    %r15
  6fb5c7:	5d                   	pop    %rbp
  6fb5c8:	c3                   	ret
  6fb5c9:	48 8d 2c d1          	lea    (%rcx,%rdx,8),%rbp
  6fb5cd:	48 83 7d 08 00       	cmpq   $0x0,0x8(%rbp)
  6fb5d2:	0f 84 a0 00 00 00    	je     6fb678 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0x1a8>
  6fb5d8:	48 83 c5 08          	add    $0x8,%rbp
  6fb5dc:	48 8d 90 10 07 00 00 	lea    0x710(%rax),%rdx
  6fb5e3:	4c 8d 80 28 02 00 00 	lea    0x228(%rax),%r8
  6fb5ea:	48 8d 0d e7 f2 3f 00 	lea    0x3ff2e7(%rip),%rcx        # afa8d8 <__frame_dummy_init_array_entry+0x70>
  6fb5f1:	4c 8d 0d 00 f3 3f 00 	lea    0x3ff300(%rip),%r9        # afa8f8 <__frame_dummy_init_array_entry+0x90>
  6fb5f8:	48 8d 7c 24 30       	lea    0x30(%rsp),%rdi
  6fb5fd:	48 89 ee             	mov    %rbp,%rsi
  6fb600:	48 89 54 24 70       	mov    %rdx,0x70(%rsp)
  6fb605:	ff 15 05 de 42 00    	call   *0x42de05(%rip)        # b29410 <_DYNAMIC+0x388>
  6fb60b:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  6fb610:	48 8b 54 24 38       	mov    0x38(%rsp),%rdx
  6fb615:	48 8b 4c 24 40       	mov    0x40(%rsp),%rcx
  6fb61a:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  6fb61f:	48 89 14 24          	mov    %rdx,(%rsp)
  6fb623:	48 89 54 24 18       	mov    %rdx,0x18(%rsp)
  6fb628:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
  6fb62d:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  6fb632:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  6fb636:	0f 84 0a 02 00 00    	je     6fb846 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0x376>
  6fb63c:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  6fb640:	75 71                	jne    6fb6b3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0x1e3>
  6fb642:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  6fb647:	e8 54 96 ff ff       	call   6f4ca0 <core::ptr::drop_glue::<core::result::Result<core::result::Result<gpui::element::Admission, gpui::source::BindError>, alloc::boxed::Box<dyn core::any::Any + core::marker::Send>>>>
  6fb64c:	48 8b 0c 24          	mov    (%rsp),%rcx
  6fb650:	66 85 c9             	test   %cx,%cx
  6fb653:	74 7f                	je     6fb6d4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0x204>
  6fb655:	0f b7 c1             	movzwl %cx,%eax
  6fb658:	83 f8 01             	cmp    $0x1,%eax
  6fb65b:	0f 85 17 01 00 00    	jne    6fb778 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0x2a8>
  6fb661:	48 c1 e9 10          	shr    $0x10,%rcx
  6fb665:	48 89 df             	mov    %rbx,%rdi
  6fb668:	4c 89 f6             	mov    %r14,%rsi
  6fb66b:	4c 89 ea             	mov    %r13,%rdx
  6fb66e:	e8 6d d6 00 00       	call   708ce0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action>
  6fb673:	e9 42 ff ff ff       	jmp    6fb5ba <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0xea>
  6fb678:	48 c7 03 16 00 00 00 	movq   $0x16,(%rbx)
  6fb67f:	e9 36 ff ff ff       	jmp    6fb5ba <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0xea>
  6fb684:	48 8b 90 90 06 00 00 	mov    0x690(%rax),%rdx
  6fb68b:	b8 01 00 00 00       	mov    $0x1,%eax
  6fb690:	48 89 43 08          	mov    %rax,0x8(%rbx)
  6fb694:	48 89 53 10          	mov    %rdx,0x10(%rbx)
  6fb698:	0f 11 43 18          	movups %xmm0,0x18(%rbx)
  6fb69c:	48 c7 43 28 00 00 00 	movq   $0x0,0x28(%rbx)
  6fb6a3:	00 
  6fb6a4:	88 4b 30             	mov    %cl,0x30(%rbx)
  6fb6a7:	48 c7 03 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rbx)
  6fb6ae:	e9 07 ff ff ff       	jmp    6fb5ba <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0xea>
  6fb6b3:	48 c7 03 20 00 00 00 	movq   $0x20,(%rbx)
  6fb6ba:	48 89 43 08          	mov    %rax,0x8(%rbx)
  6fb6be:	48 8b 04 24          	mov    (%rsp),%rax
  6fb6c2:	48 89 43 10          	mov    %rax,0x10(%rbx)
  6fb6c6:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  6fb6cb:	48 89 43 18          	mov    %rax,0x18(%rbx)
  6fb6cf:	e9 e6 fe ff ff       	jmp    6fb5ba <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0xea>
  6fb6d4:	4d 8b be 60 06 00 00 	mov    0x660(%r14),%r15
  6fb6db:	49 ff c7             	inc    %r15
  6fb6de:	0f 84 c6 00 00 00    	je     6fb7aa <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0x2da>
  6fb6e4:	48 c7 44 24 30 1f 00 	movq   $0x1f,0x30(%rsp)
  6fb6eb:	00 00 
  6fb6ed:	48 8d 7c 24 30       	lea    0x30(%rsp),%rdi
  6fb6f2:	e8 f9 c7 ff ff       	call   6f7ef0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  6fb6f7:	48 8d 0d da f1 3f 00 	lea    0x3ff1da(%rip),%rcx        # afa8d8 <__frame_dummy_init_array_entry+0x70>
  6fb6fe:	48 8d 7c 24 30       	lea    0x30(%rsp),%rdi
  6fb703:	48 89 ee             	mov    %rbp,%rsi
  6fb706:	48 8b 54 24 70       	mov    0x70(%rsp),%rdx
  6fb70b:	ff 15 07 dd 42 00    	call   *0x42dd07(%rip)        # b29418 <_DYNAMIC+0x390>
  6fb711:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  6fb716:	48 8b 4c 24 40       	mov    0x40(%rsp),%rcx
  6fb71b:	0f 28 44 24 30       	movaps 0x30(%rsp),%xmm0
  6fb720:	0f 29 44 24 10       	movaps %xmm0,0x10(%rsp)
  6fb725:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  6fb72a:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  6fb72e:	0f 84 ae 00 00 00    	je     6fb7e2 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0x312>
  6fb734:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  6fb738:	75 57                	jne    6fb791 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0x2c1>
  6fb73a:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  6fb73f:	e8 5c 95 ff ff       	call   6f4ca0 <core::ptr::drop_glue::<core::result::Result<core::result::Result<gpui::element::Admission, gpui::source::BindError>, alloc::boxed::Box<dyn core::any::Any + core::marker::Send>>>>
  6fb744:	4d 89 be 60 06 00 00 	mov    %r15,0x660(%r14)
  6fb74b:	49 ff 86 b0 06 00 00 	incq   0x6b0(%r14)
  6fb752:	49 c7 86 08 07 00 00 	movq   $0x0,0x708(%r14)
  6fb759:	00 00 00 00 
  6fb75d:	48 89 df             	mov    %rbx,%rdi
  6fb760:	4c 89 f6             	mov    %r14,%rsi
  6fb763:	4c 89 ea             	mov    %r13,%rdx
  6fb766:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
  6fb76b:	4d 89 e0             	mov    %r12,%r8
  6fb76e:	e8 5d 01 00 00       	call   6fb8d0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing>
  6fb773:	e9 42 fe ff ff       	jmp    6fb5ba <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0xea>
  6fb778:	48 89 df             	mov    %rbx,%rdi
  6fb77b:	4c 89 f6             	mov    %r14,%rsi
  6fb77e:	4c 89 ea             	mov    %r13,%rdx
  6fb781:	4c 89 f9             	mov    %r15,%rcx
  6fb784:	4d 89 e0             	mov    %r12,%r8
  6fb787:	e8 44 f6 ff ff       	call   6fadd0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property>
  6fb78c:	e9 29 fe ff ff       	jmp    6fb5ba <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0xea>
  6fb791:	0f 10 44 24 18       	movups 0x18(%rsp),%xmm0
  6fb796:	0f 11 43 10          	movups %xmm0,0x10(%rbx)
  6fb79a:	48 c7 03 20 00 00 00 	movq   $0x20,(%rbx)
  6fb7a1:	48 89 43 08          	mov    %rax,0x8(%rbx)
  6fb7a5:	e9 10 fe ff ff       	jmp    6fb5ba <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0xea>
  6fb7aa:	48 c7 03 1f 00 00 00 	movq   $0x1f,(%rbx)
  6fb7b1:	e9 04 fe ff ff       	jmp    6fb5ba <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0xea>
  6fb7b6:	48 8d 15 53 f5 3f 00 	lea    0x3ff553(%rip),%rdx        # afad10 <__frame_dummy_init_array_entry+0x4a8>
  6fb7bd:	4c 89 ff             	mov    %r15,%rdi
  6fb7c0:	ff 15 1a dc 42 00    	call   *0x42dc1a(%rip)        # b293e0 <_DYNAMIC+0x358>
  6fb7c6:	48 89 c7             	mov    %rax,%rdi
  6fb7c9:	ff 15 21 dc 42 00    	call   *0x42dc21(%rip)        # b293f0 <_DYNAMIC+0x368>
  6fb7cf:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
  6fb7d4:	48 89 54 24 20       	mov    %rdx,0x20(%rsp)
  6fb7d9:	48 c7 44 24 10 fe ff 	movq   $0xfffffffffffffffe,0x10(%rsp)
  6fb7e0:	ff ff 
  6fb7e2:	4c 89 f7             	mov    %r14,%rdi
  6fb7e5:	e8 26 f2 01 00       	call   71aa10 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::poison>
  6fb7ea:	48 c7 03 0f 00 00 00 	movq   $0xf,(%rbx)
  6fb7f1:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  6fb7f6:	e8 a5 94 ff ff       	call   6f4ca0 <core::ptr::drop_glue::<core::result::Result<core::result::Result<gpui::element::Admission, gpui::source::BindError>, alloc::boxed::Box<dyn core::any::Any + core::marker::Send>>>>
  6fb7fb:	e9 ba fd ff ff       	jmp    6fb5ba <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0xea>
  6fb800:	ff 15 f2 db 42 00    	call   *0x42dbf2(%rip)        # b293f8 <_DYNAMIC+0x370>
  6fb806:	48 89 c3             	mov    %rax,%rbx
  6fb809:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  6fb80e:	e8 8d 94 ff ff       	call   6f4ca0 <core::ptr::drop_glue::<core::result::Result<core::result::Result<gpui::element::Admission, gpui::source::BindError>, alloc::boxed::Box<dyn core::any::Any + core::marker::Send>>>>
  6fb813:	e9 aa 00 00 00       	jmp    6fb8c2 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0x3f2>
  6fb818:	48 89 c7             	mov    %rax,%rdi
  6fb81b:	ff 15 cf db 42 00    	call   *0x42dbcf(%rip)        # b293f0 <_DYNAMIC+0x368>
  6fb821:	48 89 04 24          	mov    %rax,(%rsp)
  6fb825:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
  6fb82a:	48 8b 04 24          	mov    (%rsp),%rax
  6fb82e:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
  6fb833:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  6fb838:	48 89 44 24 20       	mov    %rax,0x20(%rsp)
  6fb83d:	48 c7 44 24 10 fe ff 	movq   $0xfffffffffffffffe,0x10(%rsp)
  6fb844:	ff ff 
  6fb846:	4c 89 f7             	mov    %r14,%rdi
  6fb849:	e8 c2 f1 01 00       	call   71aa10 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::poison>
  6fb84e:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  6fb853:	48 c7 03 0f 00 00 00 	movq   $0xf,(%rbx)
  6fb85a:	49 8b 06             	mov    (%r14),%rax
  6fb85d:	48 85 c0             	test   %rax,%rax
  6fb860:	74 06                	je     6fb868 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0x398>
  6fb862:	48 8b 3c 24          	mov    (%rsp),%rdi
  6fb866:	ff d0                	call   *%rax
  6fb868:	49 8b 76 08          	mov    0x8(%r14),%rsi
  6fb86c:	48 85 f6             	test   %rsi,%rsi
  6fb86f:	0f 84 45 fd ff ff    	je     6fb5ba <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0xea>
  6fb875:	49 8b 56 10          	mov    0x10(%r14),%rdx
  6fb879:	48 8b 3c 24          	mov    (%rsp),%rdi
  6fb87d:	ff 15 4d da 42 00    	call   *0x42da4d(%rip)        # b292d0 <_DYNAMIC+0x248>
  6fb883:	e9 32 fd ff ff       	jmp    6fb5ba <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0xea>
  6fb888:	ff 15 6a db 42 00    	call   *0x42db6a(%rip)        # b293f8 <_DYNAMIC+0x370>
  6fb88e:	48 89 c3             	mov    %rax,%rbx
  6fb891:	49 8b 76 08          	mov    0x8(%r14),%rsi
  6fb895:	48 85 f6             	test   %rsi,%rsi
  6fb898:	74 28                	je     6fb8c2 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0x3f2>
  6fb89a:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  6fb89f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  6fb8a3:	48 8b 3c 24          	mov    (%rsp),%rdi
  6fb8a7:	ff 15 23 da 42 00    	call   *0x42da23(%rip)        # b292d0 <_DYNAMIC+0x248>
  6fb8ad:	48 89 df             	mov    %rbx,%rdi
  6fb8b0:	e8 fb db 3f 00       	call   af94b0 <_Unwind_Resume@plt>
  6fb8b5:	48 89 c3             	mov    %rax,%rbx
  6fb8b8:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  6fb8bd:	e8 de 93 ff ff       	call   6f4ca0 <core::ptr::drop_glue::<core::result::Result<core::result::Result<gpui::element::Admission, gpui::source::BindError>, alloc::boxed::Box<dyn core::any::Any + core::marker::Send>>>>
  6fb8c2:	48 89 df             	mov    %rbx,%rdi
  6fb8c5:	e8 e6 db 3f 00       	call   af94b0 <_Unwind_Resume@plt>
  6fb8ca:	ff 15 30 da 42 00    	call   *0x42da30(%rip)        # b29300 <_DYNAMIC+0x278>
