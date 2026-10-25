
/tmp/gpui-contained-property-exchange-target/release/deps/unit_action_cost-bcf457ce7db1ee75:     file format elf64-x86-64


Disassembly of section .text:

000000000073d650 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>>:
  73d650:	55                   	push   %rbp
  73d651:	41 57                	push   %r15
  73d653:	41 56                	push   %r14
  73d655:	41 55                	push   %r13
  73d657:	41 54                	push   %r12
  73d659:	53                   	push   %rbx
  73d65a:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  73d661:	48 89 f3             	mov    %rsi,%rbx
  73d664:	49 89 ff             	mov    %rdi,%r15
  73d667:	49 c7 c4 68 f3 ff ff 	mov    $0xfffffffffffff368,%r12
  73d66e:	64 4c 8b 34 25 00 00 	mov    %fs:0x0,%r14
  73d675:	00 00 
  73d677:	4d 01 e6             	add    %r12,%r14
  73d67a:	64 41 80 bc 24 10 0c 	cmpb   $0x0,%fs:0xc10(%r12)
  73d681:	00 00 00 
  73d684:	0f 84 b9 04 00 00    	je     73db43 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x4f3>
  73d68a:	64 49 83 3c 24 00    	cmpq   $0x0,%fs:(%r12)
  73d690:	0f 85 d3 04 00 00    	jne    73db69 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x519>
  73d696:	64 49 c7 04 24 ff ff 	movq   $0xffffffffffffffff,%fs:(%r12)
  73d69d:	ff ff 
  73d69f:	64 41 8b 84 24 08 0c 	mov    %fs:0xc08(%r12),%eax
  73d6a6:	00 00 
  73d6a8:	ff c0                	inc    %eax
  73d6aa:	64 41 89 84 24 08 0c 	mov    %eax,%fs:0xc08(%r12)
  73d6b1:	00 00 
  73d6b3:	83 f8 40             	cmp    $0x40,%eax
  73d6b6:	0f 83 ba 04 00 00    	jae    73db76 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x526>
  73d6bc:	89 c0                	mov    %eax,%eax
  73d6be:	48 8d 04 40          	lea    (%rax,%rax,2),%rax
  73d6c2:	48 c1 e0 04          	shl    $0x4,%rax
  73d6c6:	0f 57 c0             	xorps  %xmm0,%xmm0
  73d6c9:	41 0f 11 44 06 28    	movups %xmm0,0x28(%r14,%rax,1)
  73d6cf:	41 0f 11 44 06 18    	movups %xmm0,0x18(%r14,%rax,1)
  73d6d5:	41 0f 11 44 06 08    	movups %xmm0,0x8(%r14,%rax,1)
  73d6db:	64 49 c7 04 24 00 00 	movq   $0x0,%fs:(%r12)
  73d6e2:	00 00 
  73d6e4:	48 b8 80 02 00 00 e0 	movabs $0x1e000000280,%rax
  73d6eb:	01 00 00 
  73d6ee:	48 89 44 24 20       	mov    %rax,0x20(%rsp)
  73d6f3:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%rsp)
  73d6fa:	00 
  73d6fb:	c7 44 24 18 00 00 4b 	movl   $0x434b0000,0x18(%rsp)
  73d702:	43 
  73d703:	66 c7 44 24 1c 00 00 	movw   $0x0,0x1c(%rsp)
  73d70a:	48 8d 7c 24 60       	lea    0x60(%rsp),%rdi
  73d70f:	48 8d 54 24 10       	lea    0x10(%rsp),%rdx
  73d714:	f3 0f 10 05 80 6f 92 	movss  -0x6d9080(%rip),%xmm0        # 6469c <anon.079f5e587c394fcac2765eb4d0cf0bc2.312.llvm.6319143315422321905+0x28>
  73d71b:	ff 
  73d71c:	31 f6                	xor    %esi,%esi
  73d71e:	b9 01 00 00 00       	mov    $0x1,%ecx
  73d723:	45 31 c0             	xor    %r8d,%r8d
  73d726:	e8 65 1b fd ff       	call   70f290 <<gpui::runtime::Win<unit_action_cost::Model>>::mount_lanes>
  73d72b:	83 7c 24 60 fe       	cmpl   $0xfffffffe,0x60(%rsp)
  73d730:	0f 85 5b 04 00 00    	jne    73db91 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x541>
  73d736:	48 8b 44 24 68       	mov    0x68(%rsp),%rax
  73d73b:	48 83 3b 00          	cmpq   $0x0,(%rbx)
  73d73f:	0f 84 cf 03 00 00    	je     73db14 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x4c4>
  73d745:	4c 8b 73 08          	mov    0x8(%rbx),%r14
  73d749:	4d 85 f6             	test   %r14,%r14
  73d74c:	0f 84 c2 03 00 00    	je     73db14 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x4c4>
  73d752:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  73d757:	4d 8d a6 40 02 00 00 	lea    0x240(%r14),%r12
  73d75e:	4c 89 e7             	mov    %r12,%rdi
  73d761:	e8 1a ef fe ff       	call   72c680 <<alloc::vec::Vec<alloc::boxed::Box<dyn gpui::source::ComponentSchema<unit_action_cost::Model>>> as core::ops::drop::Drop>::drop>
  73d766:	49 8b 34 24          	mov    (%r12),%rsi
  73d76a:	48 85 f6             	test   %rsi,%rsi
  73d76d:	74 16                	je     73d785 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x135>
  73d76f:	49 8b be 48 02 00 00 	mov    0x248(%r14),%rdi
  73d776:	48 c1 e6 04          	shl    $0x4,%rsi
  73d77a:	ba 08 00 00 00       	mov    $0x8,%edx
  73d77f:	ff 15 0b 48 3c 00    	call   *0x3c480b(%rip)        # b01f90 <_DYNAMIC+0x248>
  73d785:	49 8b b6 58 02 00 00 	mov    0x258(%r14),%rsi
  73d78c:	48 85 f6             	test   %rsi,%rsi
  73d78f:	74 16                	je     73d7a7 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x157>
  73d791:	49 8b be 60 02 00 00 	mov    0x260(%r14),%rdi
  73d798:	48 c1 e6 03          	shl    $0x3,%rsi
  73d79c:	ba 08 00 00 00       	mov    $0x8,%edx
  73d7a1:	ff 15 e9 47 3c 00    	call   *0x3c47e9(%rip)        # b01f90 <_DYNAMIC+0x248>
  73d7a7:	4d 8d a6 70 02 00 00 	lea    0x270(%r14),%r12
  73d7ae:	4c 89 e7             	mov    %r12,%rdi
  73d7b1:	e8 ca ee fe ff       	call   72c680 <<alloc::vec::Vec<alloc::boxed::Box<dyn gpui::source::ComponentSchema<unit_action_cost::Model>>> as core::ops::drop::Drop>::drop>
  73d7b6:	49 8b 34 24          	mov    (%r12),%rsi
  73d7ba:	48 85 f6             	test   %rsi,%rsi
  73d7bd:	74 16                	je     73d7d5 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x185>
  73d7bf:	49 8b be 78 02 00 00 	mov    0x278(%r14),%rdi
  73d7c6:	48 c1 e6 04          	shl    $0x4,%rsi
  73d7ca:	ba 08 00 00 00       	mov    $0x8,%edx
  73d7cf:	ff 15 bb 47 3c 00    	call   *0x3c47bb(%rip)        # b01f90 <_DYNAMIC+0x248>
  73d7d5:	4d 8d a6 90 02 00 00 	lea    0x290(%r14),%r12
  73d7dc:	4c 89 e7             	mov    %r12,%rdi
  73d7df:	e8 bc f1 fe ff       	call   72c9a0 <<alloc::vec::Vec<gpui::runtime::Node> as core::ops::drop::Drop>::drop>
  73d7e4:	49 8b 04 24          	mov    (%r12),%rax
  73d7e8:	48 85 c0             	test   %rax,%rax
  73d7eb:	74 1a                	je     73d807 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x1b7>
  73d7ed:	49 8b be 98 02 00 00 	mov    0x298(%r14),%rdi
  73d7f4:	48 c1 e0 03          	shl    $0x3,%rax
  73d7f8:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  73d7fc:	ba 08 00 00 00       	mov    $0x8,%edx
  73d801:	ff 15 89 47 3c 00    	call   *0x3c4789(%rip)        # b01f90 <_DYNAMIC+0x248>
  73d807:	49 8d be 00 02 00 00 	lea    0x200(%r14),%rdi
  73d80e:	e8 4d 2d 00 00       	call   740560 <core::ptr::drop_glue::<gpui::runtime::styles::Styles>>
  73d813:	4d 8d a6 a8 02 00 00 	lea    0x2a8(%r14),%r12
  73d81a:	4c 89 e7             	mov    %r12,%rdi
  73d81d:	e8 ee ef fe ff       	call   72c810 <<alloc::vec::Vec<core::option::Option<gpui::runtime::TextSite>> as core::ops::drop::Drop>::drop>
  73d822:	49 8b 04 24          	mov    (%r12),%rax
  73d826:	48 85 c0             	test   %rax,%rax
  73d829:	74 1a                	je     73d845 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x1f5>
  73d82b:	49 8b be b0 02 00 00 	mov    0x2b0(%r14),%rdi
  73d832:	48 c1 e0 04          	shl    $0x4,%rax
  73d836:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  73d83a:	ba 08 00 00 00       	mov    $0x8,%edx
  73d83f:	ff 15 4b 47 3c 00    	call   *0x3c474b(%rip)        # b01f90 <_DYNAMIC+0x248>
  73d845:	49 8b be c0 05 00 00 	mov    0x5c0(%r14),%rdi
  73d84c:	e8 cf 12 00 00       	call   73eb20 <core::ptr::drop_glue::<core::option::Option<alloc::boxed::Box<gpui::runtime::image::Images>>>>
  73d851:	49 8b 86 e8 01 00 00 	mov    0x1e8(%r14),%rax
  73d858:	48 85 c0             	test   %rax,%rax
  73d85b:	74 49                	je     73d8a6 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x256>
  73d85d:	83 f8 01             	cmp    $0x1,%eax
  73d860:	75 1e                	jne    73d880 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x230>
  73d862:	49 8b b6 f8 01 00 00 	mov    0x1f8(%r14),%rsi
  73d869:	48 85 f6             	test   %rsi,%rsi
  73d86c:	74 38                	je     73d8a6 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x256>
  73d86e:	49 8b be f0 01 00 00 	mov    0x1f0(%r14),%rdi
  73d875:	48 c1 e6 04          	shl    $0x4,%rsi
  73d879:	ba 08 00 00 00       	mov    $0x8,%edx
  73d87e:	eb 20                	jmp    73d8a0 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x250>
  73d880:	49 8b 86 f8 01 00 00 	mov    0x1f8(%r14),%rax
  73d887:	48 85 c0             	test   %rax,%rax
  73d88a:	74 1a                	je     73d8a6 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x256>
  73d88c:	49 8b be f0 01 00 00 	mov    0x1f0(%r14),%rdi
  73d893:	48 c1 e0 02          	shl    $0x2,%rax
  73d897:	48 8d 34 40          	lea    (%rax,%rax,2),%rsi
  73d89b:	ba 04 00 00 00       	mov    $0x4,%edx
  73d8a0:	ff 15 ea 46 3c 00    	call   *0x3c46ea(%rip)        # b01f90 <_DYNAMIC+0x248>
  73d8a6:	49 8b 8e c8 05 00 00 	mov    0x5c8(%r14),%rcx
  73d8ad:	48 85 c9             	test   %rcx,%rcx
  73d8b0:	74 3b                	je     73d8ed <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x29d>
  73d8b2:	49 8b 96 d0 05 00 00 	mov    0x5d0(%r14),%rdx
  73d8b9:	49 8b 86 d8 05 00 00 	mov    0x5d8(%r14),%rax
  73d8c0:	48 c7 44 24 18 00 00 	movq   $0x0,0x18(%rsp)
  73d8c7:	00 00 
  73d8c9:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  73d8ce:	48 89 54 24 28       	mov    %rdx,0x28(%rsp)
  73d8d3:	48 c7 44 24 38 00 00 	movq   $0x0,0x38(%rsp)
  73d8da:	00 00 
  73d8dc:	48 89 4c 24 40       	mov    %rcx,0x40(%rsp)
  73d8e1:	48 89 54 24 48       	mov    %rdx,0x48(%rsp)
  73d8e6:	b9 01 00 00 00       	mov    $0x1,%ecx
  73d8eb:	eb 04                	jmp    73d8f1 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x2a1>
  73d8ed:	31 c9                	xor    %ecx,%ecx
  73d8ef:	31 c0                	xor    %eax,%eax
  73d8f1:	48 89 4c 24 10       	mov    %rcx,0x10(%rsp)
  73d8f6:	48 89 4c 24 30       	mov    %rcx,0x30(%rsp)
  73d8fb:	48 89 44 24 50       	mov    %rax,0x50(%rsp)
  73d900:	48 8d 7c 24 60       	lea    0x60(%rsp),%rdi
  73d905:	48 8d 74 24 10       	lea    0x10(%rsp),%rsi
  73d90a:	e8 d1 4c fe ff       	call   7225e0 <<alloc::collections::btree::map::IntoIter<gpui::source::FieldId, gpui::runtime::Fanout>>::dying_next>
  73d90f:	48 8b 44 24 60       	mov    0x60(%rsp),%rax
  73d914:	48 85 c0             	test   %rax,%rax
  73d917:	74 56                	je     73d96f <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x31f>
  73d919:	4c 8d 64 24 60       	lea    0x60(%rsp),%r12
  73d91e:	4c 8d 6c 24 10       	lea    0x10(%rsp),%r13
  73d923:	48 8b 2d 66 46 3c 00 	mov    0x3c4666(%rip),%rbp        # b01f90 <_DYNAMIC+0x248>
  73d92a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  73d930:	48 8b 4c 24 70       	mov    0x70(%rsp),%rcx
  73d935:	48 c1 e1 05          	shl    $0x5,%rcx
  73d939:	48 8b 34 08          	mov    (%rax,%rcx,1),%rsi
  73d93d:	48 83 fe ff          	cmp    $0xffffffffffffffff,%rsi
  73d941:	74 17                	je     73d95a <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x30a>
  73d943:	48 85 f6             	test   %rsi,%rsi
  73d946:	74 12                	je     73d95a <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x30a>
  73d948:	48 01 c8             	add    %rcx,%rax
  73d94b:	48 8b 78 08          	mov    0x8(%rax),%rdi
  73d94f:	48 c1 e6 02          	shl    $0x2,%rsi
  73d953:	ba 04 00 00 00       	mov    $0x4,%edx
  73d958:	ff d5                	call   *%rbp
  73d95a:	4c 89 e7             	mov    %r12,%rdi
  73d95d:	4c 89 ee             	mov    %r13,%rsi
  73d960:	e8 7b 4c fe ff       	call   7225e0 <<alloc::collections::btree::map::IntoIter<gpui::source::FieldId, gpui::runtime::Fanout>>::dying_next>
  73d965:	48 8b 44 24 60       	mov    0x60(%rsp),%rax
  73d96a:	48 85 c0             	test   %rax,%rax
  73d96d:	75 c1                	jne    73d930 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x2e0>
  73d96f:	49 8d be f8 05 00 00 	lea    0x5f8(%r14),%rdi
  73d976:	e8 85 7b fe ff       	call   725500 <<alloc::collections::btree::map::BTreeMap<u64, gpui::property::Overlay<gpui::style::Style>> as core::ops::drop::Drop>::drop>
  73d97b:	49 8b be 10 06 00 00 	mov    0x610(%r14),%rdi
  73d982:	e8 39 15 00 00       	call   73eec0 <core::ptr::drop_glue::<core::option::Option<alloc::boxed::Box<gpui::runtime::metadata::Metadata>>>>
  73d987:	49 8d be 18 06 00 00 	lea    0x618(%r14),%rdi
  73d98e:	e8 9d 6b fe ff       	call   724530 <<alloc::collections::btree::map::BTreeMap<gpui::runtime::scroll::ViewportKey, gpui::runtime::scroll::ViewportState> as core::ops::drop::Drop>::drop>
  73d993:	49 8d be 30 06 00 00 	lea    0x630(%r14),%rdi
  73d99a:	e8 01 6f fe ff       	call   7248a0 <<alloc::collections::btree::map::BTreeMap<(core::option::Option<u64>, gpui::list::ListId, gpui::element::NodeKind), usize> as core::ops::drop::Drop>::drop>
  73d99f:	49 8d be c0 02 00 00 	lea    0x2c0(%r14),%rdi
  73d9a6:	e8 d5 1f 00 00       	call   73f980 <core::ptr::drop_glue::<gpui_reactivity_core::layout::LayoutTree>>
  73d9ab:	49 8b b6 58 05 00 00 	mov    0x558(%r14),%rsi
  73d9b2:	48 85 f6             	test   %rsi,%rsi
  73d9b5:	74 16                	je     73d9cd <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x37d>
  73d9b7:	49 8b be 60 05 00 00 	mov    0x560(%r14),%rdi
  73d9be:	48 c1 e6 04          	shl    $0x4,%rsi
  73d9c2:	ba 08 00 00 00       	mov    $0x8,%edx
  73d9c7:	ff 15 c3 45 3c 00    	call   *0x3c45c3(%rip)        # b01f90 <_DYNAMIC+0x248>
  73d9cd:	49 8d be 48 06 00 00 	lea    0x648(%r14),%rdi
  73d9d4:	e8 d7 5f fe ff       	call   7239b0 <<alloc::collections::btree::map::BTreeMap<gpui::list::ListId, alloc::collections::btree::set_val::SetValZST> as core::ops::drop::Drop>::drop>
  73d9d9:	49 8b 86 88 05 00 00 	mov    0x588(%r14),%rax
  73d9e0:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  73d9e4:	0f 84 7e 00 00 00    	je     73da68 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x418>
  73d9ea:	4d 8b a6 98 05 00 00 	mov    0x598(%r14),%r12
  73d9f1:	4d 85 e4             	test   %r12,%r12
  73d9f4:	74 53                	je     73da49 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x3f9>
  73d9f6:	4d 8b ae 90 05 00 00 	mov    0x590(%r14),%r13
  73d9fd:	49 83 c5 78          	add    $0x78,%r13
  73da01:	48 8b 2d e8 45 3c 00 	mov    0x3c45e8(%rip),%rbp        # b01ff0 <_DYNAMIC+0x2a8>
  73da08:	eb 0f                	jmp    73da19 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x3c9>
  73da0a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  73da10:	49 83 c5 50          	add    $0x50,%r13
  73da14:	49 ff cc             	dec    %r12
  73da17:	74 29                	je     73da42 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x3f2>
  73da19:	49 8b 7d b0          	mov    -0x50(%r13),%rdi
  73da1d:	48 85 ff             	test   %rdi,%rdi
  73da20:	74 ee                	je     73da10 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x3c0>
  73da22:	f6 07 01             	testb  $0x1,(%rdi)
  73da25:	75 e9                	jne    73da10 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x3c0>
  73da27:	48 8b 47 08          	mov    0x8(%rdi),%rax
  73da2b:	a8 01                	test   $0x1,%al
  73da2d:	75 e1                	jne    73da10 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x3c0>
  73da2f:	48 8d 47 08          	lea    0x8(%rdi),%rax
  73da33:	f0 48 83 28 02       	lock subq $0x2,(%rax)
  73da38:	75 d6                	jne    73da10 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x3c0>
  73da3a:	48 8b 47 08          	mov    0x8(%rdi),%rax
  73da3e:	ff d5                	call   *%rbp
  73da40:	eb ce                	jmp    73da10 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x3c0>
  73da42:	49 8b 86 88 05 00 00 	mov    0x588(%r14),%rax
  73da49:	48 85 c0             	test   %rax,%rax
  73da4c:	74 1a                	je     73da68 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x418>
  73da4e:	49 8b be 90 05 00 00 	mov    0x590(%r14),%rdi
  73da55:	48 c1 e0 04          	shl    $0x4,%rax
  73da59:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  73da5d:	ba 08 00 00 00       	mov    $0x8,%edx
  73da62:	ff 15 28 45 3c 00    	call   *0x3c4528(%rip)        # b01f90 <_DYNAMIC+0x248>
  73da68:	4d 8b a6 80 05 00 00 	mov    0x580(%r14),%r12
  73da6f:	4d 85 e4             	test   %r12,%r12
  73da72:	74 4e                	je     73dac2 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x472>
  73da74:	4d 8b ae 78 05 00 00 	mov    0x578(%r14),%r13
  73da7b:	49 83 c5 78          	add    $0x78,%r13
  73da7f:	48 8b 2d 6a 45 3c 00 	mov    0x3c456a(%rip),%rbp        # b01ff0 <_DYNAMIC+0x2a8>
  73da86:	eb 11                	jmp    73da99 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x449>
  73da88:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  73da8f:	00 
  73da90:	49 83 c5 50          	add    $0x50,%r13
  73da94:	49 ff cc             	dec    %r12
  73da97:	74 29                	je     73dac2 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x472>
  73da99:	49 8b 7d b0          	mov    -0x50(%r13),%rdi
  73da9d:	48 85 ff             	test   %rdi,%rdi
  73daa0:	74 ee                	je     73da90 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x440>
  73daa2:	f6 07 01             	testb  $0x1,(%rdi)
  73daa5:	75 e9                	jne    73da90 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x440>
  73daa7:	48 8b 47 08          	mov    0x8(%rdi),%rax
  73daab:	a8 01                	test   $0x1,%al
  73daad:	75 e1                	jne    73da90 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x440>
  73daaf:	48 8d 47 08          	lea    0x8(%rdi),%rax
  73dab3:	f0 48 83 28 02       	lock subq $0x2,(%rax)
  73dab8:	75 d6                	jne    73da90 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x440>
  73daba:	48 8b 47 08          	mov    0x8(%rdi),%rax
  73dabe:	ff d5                	call   *%rbp
  73dac0:	eb ce                	jmp    73da90 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x440>
  73dac2:	49 8b 86 70 05 00 00 	mov    0x570(%r14),%rax
  73dac9:	48 85 c0             	test   %rax,%rax
  73dacc:	74 1a                	je     73dae8 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x498>
  73dace:	49 8b be 78 05 00 00 	mov    0x578(%r14),%rdi
  73dad5:	48 c1 e0 04          	shl    $0x4,%rax
  73dad9:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  73dadd:	ba 08 00 00 00       	mov    $0x8,%edx
  73dae2:	ff 15 a8 44 3c 00    	call   *0x3c44a8(%rip)        # b01f90 <_DYNAMIC+0x248>
  73dae8:	4c 89 f7             	mov    %r14,%rdi
  73daeb:	e8 40 24 00 00       	call   73ff30 <core::ptr::drop_glue::<gpui_canvas::canvas::Canvas>>
  73daf0:	49 8b be 98 06 00 00 	mov    0x698(%r14),%rdi
  73daf7:	e8 f4 0c 00 00       	call   73e7f0 <core::ptr::drop_glue::<core::option::Option<alloc::boxed::Box<gpui::runtime::text_geometry::TextResources>>>>
  73dafc:	be 28 07 00 00       	mov    $0x728,%esi
  73db01:	ba 08 00 00 00       	mov    $0x8,%edx
  73db06:	4c 89 f7             	mov    %r14,%rdi
  73db09:	ff 15 81 44 3c 00    	call   *0x3c4481(%rip)        # b01f90 <_DYNAMIC+0x248>
  73db0f:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  73db14:	48 c7 03 01 00 00 00 	movq   $0x1,(%rbx)
  73db1b:	48 89 43 08          	mov    %rax,0x8(%rbx)
  73db1f:	48 8d 35 d2 76 39 00 	lea    0x3976d2(%rip),%rsi        # ad51f8 <anon.d860f86f9d097745b4f11ed46a5e2623.0.llvm.11776361448840205442>
  73db26:	4c 89 ff             	mov    %r15,%rdi
  73db29:	e8 72 a0 ff ff       	call   737ba0 <<std::thread::local::LocalKey<core::cell::RefCell<allocation_counter::allocator::AllocationInfoStack>>>::with::<allocation_counter::measure<unit_action_cost::ordinary_unit_action_cost::{closure#0}>::{closure#1}, allocation_counter::AllocationInfo>>
  73db2e:	4c 89 f8             	mov    %r15,%rax
  73db31:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  73db38:	5b                   	pop    %rbx
  73db39:	41 5c                	pop    %r12
  73db3b:	41 5d                	pop    %r13
  73db3d:	41 5e                	pop    %r14
  73db3f:	41 5f                	pop    %r15
  73db41:	5d                   	pop    %rbp
  73db42:	c3                   	ret
  73db43:	ba 0c 0c 00 00       	mov    $0xc0c,%edx
  73db48:	4c 89 f7             	mov    %r14,%rdi
  73db4b:	31 f6                	xor    %esi,%esi
  73db4d:	ff 15 e5 49 3c 00    	call   *0x3c49e5(%rip)        # b02538 <memset@GLIBC_2.2.5>
  73db53:	64 41 c6 84 24 10 0c 	movb   $0x1,%fs:0xc10(%r12)
  73db5a:	00 00 01 
  73db5d:	64 49 83 3c 24 00    	cmpq   $0x0,%fs:(%r12)
  73db63:	0f 84 2d fb ff ff    	je     73d696 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x46>
  73db69:	48 8d 3d d8 72 39 00 	lea    0x3972d8(%rip),%rdi        # ad4e48 <anon.ff3cab21037877729def149be6643aa6.6.llvm.17844888298126827638>
  73db70:	ff 15 ca 49 3c 00    	call   *0x3c49ca(%rip)        # b02540 <_DYNAMIC+0x7f8>
  73db76:	48 8d 3d 17 c2 92 ff 	lea    -0x6d3de9(%rip),%rdi        # 69d94 <anon.ff3cab21037877729def149be6643aa6.3.llvm.17844888298126827638>
  73db7d:	48 8d 15 ac 72 39 00 	lea    0x3972ac(%rip),%rdx        # ad4e30 <anon.ff3cab21037877729def149be6643aa6.5.llvm.17844888298126827638>
  73db84:	be 4b 00 00 00       	mov    $0x4b,%esi
  73db89:	ff 15 59 44 3c 00    	call   *0x3c4459(%rip)        # b01fe8 <_DYNAMIC+0x2a0>
  73db8f:	eb 53                	jmp    73dbe4 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x594>
  73db91:	48 8b 84 24 90 00 00 	mov    0x90(%rsp),%rax
  73db98:	00 
  73db99:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
  73db9e:	0f 10 44 24 60       	movups 0x60(%rsp),%xmm0
  73dba3:	0f 10 4c 24 70       	movups 0x70(%rsp),%xmm1
  73dba8:	0f 10 94 24 80 00 00 	movups 0x80(%rsp),%xmm2
  73dbaf:	00 
  73dbb0:	0f 29 54 24 30       	movaps %xmm2,0x30(%rsp)
  73dbb5:	0f 29 4c 24 20       	movaps %xmm1,0x20(%rsp)
  73dbba:	0f 29 44 24 10       	movaps %xmm0,0x10(%rsp)
  73dbbf:	48 8d 3d 72 c7 92 ff 	lea    -0x6d388e(%rip),%rdi        # 6a338 <anon.d860f86f9d097745b4f11ed46a5e2623.5.llvm.11776361448840205442>
  73dbc6:	48 8d 0d 63 76 39 00 	lea    0x397663(%rip),%rcx        # ad5230 <anon.d860f86f9d097745b4f11ed46a5e2623.4.llvm.11776361448840205442>
  73dbcd:	4c 8d 05 2c 76 39 00 	lea    0x39762c(%rip),%r8        # ad5200 <anon.d860f86f9d097745b4f11ed46a5e2623.0.llvm.11776361448840205442+0x8>
  73dbd4:	48 8d 54 24 10       	lea    0x10(%rsp),%rdx
  73dbd9:	be 2b 00 00 00       	mov    $0x2b,%esi
  73dbde:	ff 15 d4 44 3c 00    	call   *0x3c44d4(%rip)        # b020b8 <_DYNAMIC+0x370>
  73dbe4:	0f 0b                	ud2
  73dbe6:	49 89 c7             	mov    %rax,%r15
  73dbe9:	49 ff cc             	dec    %r12
  73dbec:	74 0f                	je     73dbfd <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x5ad>
  73dbee:	49 8b 7d 00          	mov    0x0(%r13),%rdi
  73dbf2:	49 83 c5 50          	add    $0x50,%r13
  73dbf6:	e8 05 cd fe ff       	call   72a900 <core::ptr::drop_glue::<core::option::Option<gpui::shared_text::SharedText>>>
  73dbfb:	eb ec                	jmp    73dbe9 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x599>
  73dbfd:	49 8b 86 88 05 00 00 	mov    0x588(%r14),%rax
  73dc04:	48 85 c0             	test   %rax,%rax
  73dc07:	0f 84 59 02 00 00    	je     73de66 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x816>
  73dc0d:	49 8b be 90 05 00 00 	mov    0x590(%r14),%rdi
  73dc14:	48 c1 e0 04          	shl    $0x4,%rax
  73dc18:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  73dc1c:	ba 08 00 00 00       	mov    $0x8,%edx
  73dc21:	ff 15 69 43 3c 00    	call   *0x3c4369(%rip)        # b01f90 <_DYNAMIC+0x248>
  73dc27:	e9 3a 02 00 00       	jmp    73de66 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x816>
  73dc2c:	ff 15 ae 43 3c 00    	call   *0x3c43ae(%rip)        # b01fe0 <_DYNAMIC+0x298>
  73dc32:	49 89 c7             	mov    %rax,%r15
  73dc35:	49 ff cc             	dec    %r12
  73dc38:	74 0f                	je     73dc49 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x5f9>
  73dc3a:	49 8b 7d 00          	mov    0x0(%r13),%rdi
  73dc3e:	49 83 c5 50          	add    $0x50,%r13
  73dc42:	e8 b9 cc fe ff       	call   72a900 <core::ptr::drop_glue::<core::option::Option<gpui::shared_text::SharedText>>>
  73dc47:	eb ec                	jmp    73dc35 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x5e5>
  73dc49:	49 8b 86 70 05 00 00 	mov    0x570(%r14),%rax
  73dc50:	48 85 c0             	test   %rax,%rax
  73dc53:	0f 84 19 02 00 00    	je     73de72 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x822>
  73dc59:	49 8b be 78 05 00 00 	mov    0x578(%r14),%rdi
  73dc60:	48 c1 e0 04          	shl    $0x4,%rax
  73dc64:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  73dc68:	ba 08 00 00 00       	mov    $0x8,%edx
  73dc6d:	ff 15 1d 43 3c 00    	call   *0x3c431d(%rip)        # b01f90 <_DYNAMIC+0x248>
  73dc73:	e9 fa 01 00 00       	jmp    73de72 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x822>
  73dc78:	ff 15 62 43 3c 00    	call   *0x3c4362(%rip)        # b01fe0 <_DYNAMIC+0x298>
  73dc7e:	49 89 c7             	mov    %rax,%r15
  73dc81:	e9 00 02 00 00       	jmp    73de86 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x836>
  73dc86:	49 89 c7             	mov    %rax,%r15
  73dc89:	e9 ec 01 00 00       	jmp    73de7a <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x82a>
  73dc8e:	49 89 c7             	mov    %rax,%r15
  73dc91:	e9 c4 01 00 00       	jmp    73de5a <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x80a>
  73dc96:	49 89 c7             	mov    %rax,%r15
  73dc99:	e9 8e 01 00 00       	jmp    73de2c <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x7dc>
  73dc9e:	49 89 c7             	mov    %rax,%r15
  73dca1:	e9 7a 01 00 00       	jmp    73de20 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x7d0>
  73dca6:	49 89 c7             	mov    %rax,%r15
  73dca9:	e9 66 01 00 00       	jmp    73de14 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x7c4>
  73dcae:	49 89 c7             	mov    %rax,%r15
  73dcb1:	e9 52 01 00 00       	jmp    73de08 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x7b8>
  73dcb6:	49 89 c7             	mov    %rax,%r15
  73dcb9:	e9 3e 01 00 00       	jmp    73ddfc <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x7ac>
  73dcbe:	e9 2a 01 00 00       	jmp    73dded <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x79d>
  73dcc3:	49 89 c7             	mov    %rax,%r15
  73dcc6:	e9 02 01 00 00       	jmp    73ddcd <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x77d>
  73dccb:	49 89 c7             	mov    %rax,%r15
  73dcce:	49 8b 04 24          	mov    (%r12),%rax
  73dcd2:	48 85 c0             	test   %rax,%rax
  73dcd5:	0f 84 e6 00 00 00    	je     73ddc1 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x771>
  73dcdb:	49 8b be b0 02 00 00 	mov    0x2b0(%r14),%rdi
  73dce2:	48 c1 e0 04          	shl    $0x4,%rax
  73dce6:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  73dcea:	ba 08 00 00 00       	mov    $0x8,%edx
  73dcef:	ff 15 9b 42 3c 00    	call   *0x3c429b(%rip)        # b01f90 <_DYNAMIC+0x248>
  73dcf5:	e9 c7 00 00 00       	jmp    73ddc1 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x771>
  73dcfa:	49 89 c7             	mov    %rax,%r15
  73dcfd:	49 8b 04 24          	mov    (%r12),%rax
  73dd01:	48 85 c0             	test   %rax,%rax
  73dd04:	0f 84 9f 00 00 00    	je     73dda9 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x759>
  73dd0a:	49 8b be 98 02 00 00 	mov    0x298(%r14),%rdi
  73dd11:	48 c1 e0 03          	shl    $0x3,%rax
  73dd15:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  73dd19:	ba 08 00 00 00       	mov    $0x8,%edx
  73dd1e:	ff 15 6c 42 3c 00    	call   *0x3c426c(%rip)        # b01f90 <_DYNAMIC+0x248>
  73dd24:	e9 80 00 00 00       	jmp    73dda9 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x759>
  73dd29:	49 89 c7             	mov    %rax,%r15
  73dd2c:	49 8b 34 24          	mov    (%r12),%rsi
  73dd30:	48 85 f6             	test   %rsi,%rsi
  73dd33:	74 68                	je     73dd9d <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x74d>
  73dd35:	49 8b be 78 02 00 00 	mov    0x278(%r14),%rdi
  73dd3c:	48 c1 e6 04          	shl    $0x4,%rsi
  73dd40:	ba 08 00 00 00       	mov    $0x8,%edx
  73dd45:	ff 15 45 42 3c 00    	call   *0x3c4245(%rip)        # b01f90 <_DYNAMIC+0x248>
  73dd4b:	eb 50                	jmp    73dd9d <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x74d>
  73dd4d:	49 89 c7             	mov    %rax,%r15
  73dd50:	49 8b 34 24          	mov    (%r12),%rsi
  73dd54:	48 85 f6             	test   %rsi,%rsi
  73dd57:	74 16                	je     73dd6f <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x71f>
  73dd59:	49 8b be 48 02 00 00 	mov    0x248(%r14),%rdi
  73dd60:	48 c1 e6 04          	shl    $0x4,%rsi
  73dd64:	ba 08 00 00 00       	mov    $0x8,%edx
  73dd69:	ff 15 21 42 3c 00    	call   *0x3c4221(%rip)        # b01f90 <_DYNAMIC+0x248>
  73dd6f:	49 8b b6 58 02 00 00 	mov    0x258(%r14),%rsi
  73dd76:	48 85 f6             	test   %rsi,%rsi
  73dd79:	74 16                	je     73dd91 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x741>
  73dd7b:	49 8b be 60 02 00 00 	mov    0x260(%r14),%rdi
  73dd82:	48 c1 e6 03          	shl    $0x3,%rsi
  73dd86:	ba 08 00 00 00       	mov    $0x8,%edx
  73dd8b:	ff 15 ff 41 3c 00    	call   *0x3c41ff(%rip)        # b01f90 <_DYNAMIC+0x248>
  73dd91:	49 8d be 70 02 00 00 	lea    0x270(%r14),%rdi
  73dd98:	e8 93 15 00 00       	call   73f330 <core::ptr::drop_glue::<alloc::vec::Vec<alloc::boxed::Box<dyn gpui::source::ComponentSchema<unit_action_cost::Model>>>>>
  73dd9d:	49 8d be 90 02 00 00 	lea    0x290(%r14),%rdi
  73dda4:	e8 77 17 00 00       	call   73f520 <core::ptr::drop_glue::<alloc::vec::Vec<gpui::runtime::Node>>>
  73dda9:	49 8d be 00 02 00 00 	lea    0x200(%r14),%rdi
  73ddb0:	e8 ab 27 00 00       	call   740560 <core::ptr::drop_glue::<gpui::runtime::styles::Styles>>
  73ddb5:	49 8d be a8 02 00 00 	lea    0x2a8(%r14),%rdi
  73ddbc:	e8 ff 14 00 00       	call   73f2c0 <core::ptr::drop_glue::<alloc::vec::Vec<core::option::Option<gpui::runtime::TextSite>>>>
  73ddc1:	49 8b be c0 05 00 00 	mov    0x5c0(%r14),%rdi
  73ddc8:	e8 53 0d 00 00       	call   73eb20 <core::ptr::drop_glue::<core::option::Option<alloc::boxed::Box<gpui::runtime::image::Images>>>>
  73ddcd:	49 8d be e8 01 00 00 	lea    0x1e8(%r14),%rdi
  73ddd4:	e8 87 26 00 00       	call   740460 <core::ptr::drop_glue::<gpui::runtime::identity_index::IdentityIndex>>
  73ddd9:	49 8d be c8 05 00 00 	lea    0x5c8(%r14),%rdi
  73dde0:	e8 bb 5f fe ff       	call   723da0 <<alloc::collections::btree::map::BTreeMap<gpui::source::FieldId, gpui::runtime::Fanout> as core::ops::drop::Drop>::drop>
  73dde5:	eb 09                	jmp    73ddf0 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x7a0>
  73dde7:	ff 15 f3 41 3c 00    	call   *0x3c41f3(%rip)        # b01fe0 <_DYNAMIC+0x298>
  73dded:	49 89 c7             	mov    %rax,%r15
  73ddf0:	49 8d be f8 05 00 00 	lea    0x5f8(%r14),%rdi
  73ddf7:	e8 04 77 fe ff       	call   725500 <<alloc::collections::btree::map::BTreeMap<u64, gpui::property::Overlay<gpui::style::Style>> as core::ops::drop::Drop>::drop>
  73ddfc:	49 8b be 10 06 00 00 	mov    0x610(%r14),%rdi
  73de03:	e8 b8 10 00 00       	call   73eec0 <core::ptr::drop_glue::<core::option::Option<alloc::boxed::Box<gpui::runtime::metadata::Metadata>>>>
  73de08:	49 8d be 18 06 00 00 	lea    0x618(%r14),%rdi
  73de0f:	e8 1c 67 fe ff       	call   724530 <<alloc::collections::btree::map::BTreeMap<gpui::runtime::scroll::ViewportKey, gpui::runtime::scroll::ViewportState> as core::ops::drop::Drop>::drop>
  73de14:	49 8d be 30 06 00 00 	lea    0x630(%r14),%rdi
  73de1b:	e8 80 6a fe ff       	call   7248a0 <<alloc::collections::btree::map::BTreeMap<(core::option::Option<u64>, gpui::list::ListId, gpui::element::NodeKind), usize> as core::ops::drop::Drop>::drop>
  73de20:	49 8d be c0 02 00 00 	lea    0x2c0(%r14),%rdi
  73de27:	e8 54 1b 00 00       	call   73f980 <core::ptr::drop_glue::<gpui_reactivity_core::layout::LayoutTree>>
  73de2c:	49 8b b6 58 05 00 00 	mov    0x558(%r14),%rsi
  73de33:	48 85 f6             	test   %rsi,%rsi
  73de36:	74 16                	je     73de4e <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x7fe>
  73de38:	49 8b be 60 05 00 00 	mov    0x560(%r14),%rdi
  73de3f:	48 c1 e6 04          	shl    $0x4,%rsi
  73de43:	ba 08 00 00 00       	mov    $0x8,%edx
  73de48:	ff 15 42 41 3c 00    	call   *0x3c4142(%rip)        # b01f90 <_DYNAMIC+0x248>
  73de4e:	49 8d be 48 06 00 00 	lea    0x648(%r14),%rdi
  73de55:	e8 56 5b fe ff       	call   7239b0 <<alloc::collections::btree::map::BTreeMap<gpui::list::ListId, alloc::collections::btree::set_val::SetValZST> as core::ops::drop::Drop>::drop>
  73de5a:	49 8d be 88 05 00 00 	lea    0x588(%r14),%rdi
  73de61:	e8 7a 12 00 00       	call   73f0e0 <core::ptr::drop_glue::<core::option::Option<gpui::runtime::Prepared>>>
  73de66:	49 8d be 70 05 00 00 	lea    0x570(%r14),%rdi
  73de6d:	e8 1e 17 00 00       	call   73f590 <core::ptr::drop_glue::<alloc::vec::Vec<gpui::runtime::Presented>>>
  73de72:	4c 89 f7             	mov    %r14,%rdi
  73de75:	e8 b6 20 00 00       	call   73ff30 <core::ptr::drop_glue::<gpui_canvas::canvas::Canvas>>
  73de7a:	49 8b be 98 06 00 00 	mov    0x698(%r14),%rdi
  73de81:	e8 6a 09 00 00       	call   73e7f0 <core::ptr::drop_glue::<core::option::Option<alloc::boxed::Box<gpui::runtime::text_geometry::TextResources>>>>
  73de86:	be 28 07 00 00       	mov    $0x728,%esi
  73de8b:	ba 08 00 00 00       	mov    $0x8,%edx
  73de90:	4c 89 f7             	mov    %r14,%rdi
  73de93:	ff 15 f7 40 3c 00    	call   *0x3c40f7(%rip)        # b01f90 <_DYNAMIC+0x248>
  73de99:	48 c7 03 01 00 00 00 	movq   $0x1,(%rbx)
  73dea0:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  73dea5:	48 89 43 08          	mov    %rax,0x8(%rbx)
  73dea9:	4c 89 ff             	mov    %r15,%rdi
  73deac:	e8 ff 44 39 00       	call   ad23b0 <_Unwind_Resume@plt>
  73deb1:	ff 15 29 41 3c 00    	call   *0x3c4129(%rip)        # b01fe0 <_DYNAMIC+0x298>
  73deb7:	49 89 c7             	mov    %rax,%r15
  73deba:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  73debf:	e8 fc 23 00 00       	call   7402c0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  73dec4:	4c 89 ff             	mov    %r15,%rdi
  73dec7:	e8 e4 44 39 00       	call   ad23b0 <_Unwind_Resume@plt>
  73decc:	64 49 ff 04 24       	incq   %fs:(%r12)
  73ded1:	48 89 c7             	mov    %rax,%rdi
  73ded4:	e8 d7 44 39 00       	call   ad23b0 <_Unwind_Resume@plt>
