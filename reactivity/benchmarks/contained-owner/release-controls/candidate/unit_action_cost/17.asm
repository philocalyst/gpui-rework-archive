
/tmp/gpui-contained-owner-spike-target/release/deps/unit_action_cost-bcf457ce7db1ee75:     file format elf64-x86-64


Disassembly of section .text:

000000000073d780 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>>:
  73d780:	55                   	push   %rbp
  73d781:	41 57                	push   %r15
  73d783:	41 56                	push   %r14
  73d785:	41 55                	push   %r13
  73d787:	41 54                	push   %r12
  73d789:	53                   	push   %rbx
  73d78a:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  73d791:	48 89 f3             	mov    %rsi,%rbx
  73d794:	49 89 ff             	mov    %rdi,%r15
  73d797:	49 c7 c4 68 f3 ff ff 	mov    $0xfffffffffffff368,%r12
  73d79e:	64 4c 8b 34 25 00 00 	mov    %fs:0x0,%r14
  73d7a5:	00 00 
  73d7a7:	4d 01 e6             	add    %r12,%r14
  73d7aa:	64 41 80 bc 24 10 0c 	cmpb   $0x0,%fs:0xc10(%r12)
  73d7b1:	00 00 00 
  73d7b4:	0f 84 b9 04 00 00    	je     73dc73 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x4f3>
  73d7ba:	64 49 83 3c 24 00    	cmpq   $0x0,%fs:(%r12)
  73d7c0:	0f 85 d3 04 00 00    	jne    73dc99 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x519>
  73d7c6:	64 49 c7 04 24 ff ff 	movq   $0xffffffffffffffff,%fs:(%r12)
  73d7cd:	ff ff 
  73d7cf:	64 41 8b 84 24 08 0c 	mov    %fs:0xc08(%r12),%eax
  73d7d6:	00 00 
  73d7d8:	ff c0                	inc    %eax
  73d7da:	64 41 89 84 24 08 0c 	mov    %eax,%fs:0xc08(%r12)
  73d7e1:	00 00 
  73d7e3:	83 f8 40             	cmp    $0x40,%eax
  73d7e6:	0f 83 ba 04 00 00    	jae    73dca6 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x526>
  73d7ec:	89 c0                	mov    %eax,%eax
  73d7ee:	48 8d 04 40          	lea    (%rax,%rax,2),%rax
  73d7f2:	48 c1 e0 04          	shl    $0x4,%rax
  73d7f6:	0f 57 c0             	xorps  %xmm0,%xmm0
  73d7f9:	41 0f 11 44 06 28    	movups %xmm0,0x28(%r14,%rax,1)
  73d7ff:	41 0f 11 44 06 18    	movups %xmm0,0x18(%r14,%rax,1)
  73d805:	41 0f 11 44 06 08    	movups %xmm0,0x8(%r14,%rax,1)
  73d80b:	64 49 c7 04 24 00 00 	movq   $0x0,%fs:(%r12)
  73d812:	00 00 
  73d814:	48 b8 80 02 00 00 e0 	movabs $0x1e000000280,%rax
  73d81b:	01 00 00 
  73d81e:	48 89 44 24 20       	mov    %rax,0x20(%rsp)
  73d823:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%rsp)
  73d82a:	00 
  73d82b:	c7 44 24 18 00 00 4b 	movl   $0x434b0000,0x18(%rsp)
  73d832:	43 
  73d833:	66 c7 44 24 1c 00 00 	movw   $0x0,0x1c(%rsp)
  73d83a:	48 8d 7c 24 60       	lea    0x60(%rsp),%rdi
  73d83f:	48 8d 54 24 10       	lea    0x10(%rsp),%rdx
  73d844:	f3 0f 10 05 b0 6e 92 	movss  -0x6d9150(%rip),%xmm0        # 646fc <anon.079f5e587c394fcac2765eb4d0cf0bc2.312.llvm.6319143315422321905+0x28>
  73d84b:	ff 
  73d84c:	31 f6                	xor    %esi,%esi
  73d84e:	b9 01 00 00 00       	mov    $0x1,%ecx
  73d853:	45 31 c0             	xor    %r8d,%r8d
  73d856:	e8 45 1b fd ff       	call   70f3a0 <<gpui::runtime::Win<unit_action_cost::Model>>::mount_lanes>
  73d85b:	83 7c 24 60 fe       	cmpl   $0xfffffffe,0x60(%rsp)
  73d860:	0f 85 5b 04 00 00    	jne    73dcc1 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x541>
  73d866:	48 8b 44 24 68       	mov    0x68(%rsp),%rax
  73d86b:	48 83 3b 00          	cmpq   $0x0,(%rbx)
  73d86f:	0f 84 cf 03 00 00    	je     73dc44 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x4c4>
  73d875:	4c 8b 73 08          	mov    0x8(%rbx),%r14
  73d879:	4d 85 f6             	test   %r14,%r14
  73d87c:	0f 84 c2 03 00 00    	je     73dc44 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x4c4>
  73d882:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  73d887:	4d 8d a6 40 02 00 00 	lea    0x240(%r14),%r12
  73d88e:	4c 89 e7             	mov    %r12,%rdi
  73d891:	e8 fa ee fe ff       	call   72c790 <<alloc::vec::Vec<alloc::boxed::Box<dyn gpui::source::ComponentSchema<unit_action_cost::Model>>> as core::ops::drop::Drop>::drop>
  73d896:	49 8b 34 24          	mov    (%r12),%rsi
  73d89a:	48 85 f6             	test   %rsi,%rsi
  73d89d:	74 16                	je     73d8b5 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x135>
  73d89f:	49 8b be 48 02 00 00 	mov    0x248(%r14),%rdi
  73d8a6:	48 c1 e6 04          	shl    $0x4,%rsi
  73d8aa:	ba 08 00 00 00       	mov    $0x8,%edx
  73d8af:	ff 15 db 47 3c 00    	call   *0x3c47db(%rip)        # b02090 <_DYNAMIC+0x248>
  73d8b5:	49 8b b6 58 02 00 00 	mov    0x258(%r14),%rsi
  73d8bc:	48 85 f6             	test   %rsi,%rsi
  73d8bf:	74 16                	je     73d8d7 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x157>
  73d8c1:	49 8b be 60 02 00 00 	mov    0x260(%r14),%rdi
  73d8c8:	48 c1 e6 03          	shl    $0x3,%rsi
  73d8cc:	ba 08 00 00 00       	mov    $0x8,%edx
  73d8d1:	ff 15 b9 47 3c 00    	call   *0x3c47b9(%rip)        # b02090 <_DYNAMIC+0x248>
  73d8d7:	4d 8d a6 70 02 00 00 	lea    0x270(%r14),%r12
  73d8de:	4c 89 e7             	mov    %r12,%rdi
  73d8e1:	e8 aa ee fe ff       	call   72c790 <<alloc::vec::Vec<alloc::boxed::Box<dyn gpui::source::ComponentSchema<unit_action_cost::Model>>> as core::ops::drop::Drop>::drop>
  73d8e6:	49 8b 34 24          	mov    (%r12),%rsi
  73d8ea:	48 85 f6             	test   %rsi,%rsi
  73d8ed:	74 16                	je     73d905 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x185>
  73d8ef:	49 8b be 78 02 00 00 	mov    0x278(%r14),%rdi
  73d8f6:	48 c1 e6 04          	shl    $0x4,%rsi
  73d8fa:	ba 08 00 00 00       	mov    $0x8,%edx
  73d8ff:	ff 15 8b 47 3c 00    	call   *0x3c478b(%rip)        # b02090 <_DYNAMIC+0x248>
  73d905:	4d 8d a6 90 02 00 00 	lea    0x290(%r14),%r12
  73d90c:	4c 89 e7             	mov    %r12,%rdi
  73d90f:	e8 9c f1 fe ff       	call   72cab0 <<alloc::vec::Vec<gpui::runtime::Node> as core::ops::drop::Drop>::drop>
  73d914:	49 8b 04 24          	mov    (%r12),%rax
  73d918:	48 85 c0             	test   %rax,%rax
  73d91b:	74 1a                	je     73d937 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x1b7>
  73d91d:	49 8b be 98 02 00 00 	mov    0x298(%r14),%rdi
  73d924:	48 c1 e0 03          	shl    $0x3,%rax
  73d928:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  73d92c:	ba 08 00 00 00       	mov    $0x8,%edx
  73d931:	ff 15 59 47 3c 00    	call   *0x3c4759(%rip)        # b02090 <_DYNAMIC+0x248>
  73d937:	49 8d be 00 02 00 00 	lea    0x200(%r14),%rdi
  73d93e:	e8 4d 2d 00 00       	call   740690 <core::ptr::drop_glue::<gpui::runtime::styles::Styles>>
  73d943:	4d 8d a6 a8 02 00 00 	lea    0x2a8(%r14),%r12
  73d94a:	4c 89 e7             	mov    %r12,%rdi
  73d94d:	e8 ce ef fe ff       	call   72c920 <<alloc::vec::Vec<core::option::Option<gpui::runtime::TextSite>> as core::ops::drop::Drop>::drop>
  73d952:	49 8b 04 24          	mov    (%r12),%rax
  73d956:	48 85 c0             	test   %rax,%rax
  73d959:	74 1a                	je     73d975 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x1f5>
  73d95b:	49 8b be b0 02 00 00 	mov    0x2b0(%r14),%rdi
  73d962:	48 c1 e0 04          	shl    $0x4,%rax
  73d966:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  73d96a:	ba 08 00 00 00       	mov    $0x8,%edx
  73d96f:	ff 15 1b 47 3c 00    	call   *0x3c471b(%rip)        # b02090 <_DYNAMIC+0x248>
  73d975:	49 8b be c0 05 00 00 	mov    0x5c0(%r14),%rdi
  73d97c:	e8 cf 12 00 00       	call   73ec50 <core::ptr::drop_glue::<core::option::Option<alloc::boxed::Box<gpui::runtime::image::Images>>>>
  73d981:	49 8b 86 e8 01 00 00 	mov    0x1e8(%r14),%rax
  73d988:	48 85 c0             	test   %rax,%rax
  73d98b:	74 49                	je     73d9d6 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x256>
  73d98d:	83 f8 01             	cmp    $0x1,%eax
  73d990:	75 1e                	jne    73d9b0 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x230>
  73d992:	49 8b b6 f8 01 00 00 	mov    0x1f8(%r14),%rsi
  73d999:	48 85 f6             	test   %rsi,%rsi
  73d99c:	74 38                	je     73d9d6 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x256>
  73d99e:	49 8b be f0 01 00 00 	mov    0x1f0(%r14),%rdi
  73d9a5:	48 c1 e6 04          	shl    $0x4,%rsi
  73d9a9:	ba 08 00 00 00       	mov    $0x8,%edx
  73d9ae:	eb 20                	jmp    73d9d0 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x250>
  73d9b0:	49 8b 86 f8 01 00 00 	mov    0x1f8(%r14),%rax
  73d9b7:	48 85 c0             	test   %rax,%rax
  73d9ba:	74 1a                	je     73d9d6 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x256>
  73d9bc:	49 8b be f0 01 00 00 	mov    0x1f0(%r14),%rdi
  73d9c3:	48 c1 e0 02          	shl    $0x2,%rax
  73d9c7:	48 8d 34 40          	lea    (%rax,%rax,2),%rsi
  73d9cb:	ba 04 00 00 00       	mov    $0x4,%edx
  73d9d0:	ff 15 ba 46 3c 00    	call   *0x3c46ba(%rip)        # b02090 <_DYNAMIC+0x248>
  73d9d6:	49 8b 8e c8 05 00 00 	mov    0x5c8(%r14),%rcx
  73d9dd:	48 85 c9             	test   %rcx,%rcx
  73d9e0:	74 3b                	je     73da1d <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x29d>
  73d9e2:	49 8b 96 d0 05 00 00 	mov    0x5d0(%r14),%rdx
  73d9e9:	49 8b 86 d8 05 00 00 	mov    0x5d8(%r14),%rax
  73d9f0:	48 c7 44 24 18 00 00 	movq   $0x0,0x18(%rsp)
  73d9f7:	00 00 
  73d9f9:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  73d9fe:	48 89 54 24 28       	mov    %rdx,0x28(%rsp)
  73da03:	48 c7 44 24 38 00 00 	movq   $0x0,0x38(%rsp)
  73da0a:	00 00 
  73da0c:	48 89 4c 24 40       	mov    %rcx,0x40(%rsp)
  73da11:	48 89 54 24 48       	mov    %rdx,0x48(%rsp)
  73da16:	b9 01 00 00 00       	mov    $0x1,%ecx
  73da1b:	eb 04                	jmp    73da21 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x2a1>
  73da1d:	31 c9                	xor    %ecx,%ecx
  73da1f:	31 c0                	xor    %eax,%eax
  73da21:	48 89 4c 24 10       	mov    %rcx,0x10(%rsp)
  73da26:	48 89 4c 24 30       	mov    %rcx,0x30(%rsp)
  73da2b:	48 89 44 24 50       	mov    %rax,0x50(%rsp)
  73da30:	48 8d 7c 24 60       	lea    0x60(%rsp),%rdi
  73da35:	48 8d 74 24 10       	lea    0x10(%rsp),%rsi
  73da3a:	e8 b1 4c fe ff       	call   7226f0 <<alloc::collections::btree::map::IntoIter<gpui::source::FieldId, gpui::runtime::Fanout>>::dying_next>
  73da3f:	48 8b 44 24 60       	mov    0x60(%rsp),%rax
  73da44:	48 85 c0             	test   %rax,%rax
  73da47:	74 56                	je     73da9f <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x31f>
  73da49:	4c 8d 64 24 60       	lea    0x60(%rsp),%r12
  73da4e:	4c 8d 6c 24 10       	lea    0x10(%rsp),%r13
  73da53:	48 8b 2d 36 46 3c 00 	mov    0x3c4636(%rip),%rbp        # b02090 <_DYNAMIC+0x248>
  73da5a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  73da60:	48 8b 4c 24 70       	mov    0x70(%rsp),%rcx
  73da65:	48 c1 e1 05          	shl    $0x5,%rcx
  73da69:	48 8b 34 08          	mov    (%rax,%rcx,1),%rsi
  73da6d:	48 83 fe ff          	cmp    $0xffffffffffffffff,%rsi
  73da71:	74 17                	je     73da8a <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x30a>
  73da73:	48 85 f6             	test   %rsi,%rsi
  73da76:	74 12                	je     73da8a <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x30a>
  73da78:	48 01 c8             	add    %rcx,%rax
  73da7b:	48 8b 78 08          	mov    0x8(%rax),%rdi
  73da7f:	48 c1 e6 02          	shl    $0x2,%rsi
  73da83:	ba 04 00 00 00       	mov    $0x4,%edx
  73da88:	ff d5                	call   *%rbp
  73da8a:	4c 89 e7             	mov    %r12,%rdi
  73da8d:	4c 89 ee             	mov    %r13,%rsi
  73da90:	e8 5b 4c fe ff       	call   7226f0 <<alloc::collections::btree::map::IntoIter<gpui::source::FieldId, gpui::runtime::Fanout>>::dying_next>
  73da95:	48 8b 44 24 60       	mov    0x60(%rsp),%rax
  73da9a:	48 85 c0             	test   %rax,%rax
  73da9d:	75 c1                	jne    73da60 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x2e0>
  73da9f:	49 8d be f8 05 00 00 	lea    0x5f8(%r14),%rdi
  73daa6:	e8 65 7b fe ff       	call   725610 <<alloc::collections::btree::map::BTreeMap<u64, gpui::property::Overlay<gpui::style::Style>> as core::ops::drop::Drop>::drop>
  73daab:	49 8b be 10 06 00 00 	mov    0x610(%r14),%rdi
  73dab2:	e8 39 15 00 00       	call   73eff0 <core::ptr::drop_glue::<core::option::Option<alloc::boxed::Box<gpui::runtime::metadata::Metadata>>>>
  73dab7:	49 8d be 18 06 00 00 	lea    0x618(%r14),%rdi
  73dabe:	e8 7d 6b fe ff       	call   724640 <<alloc::collections::btree::map::BTreeMap<gpui::runtime::scroll::ViewportKey, gpui::runtime::scroll::ViewportState> as core::ops::drop::Drop>::drop>
  73dac3:	49 8d be 30 06 00 00 	lea    0x630(%r14),%rdi
  73daca:	e8 e1 6e fe ff       	call   7249b0 <<alloc::collections::btree::map::BTreeMap<(core::option::Option<u64>, gpui::list::ListId, gpui::element::NodeKind), usize> as core::ops::drop::Drop>::drop>
  73dacf:	49 8d be c0 02 00 00 	lea    0x2c0(%r14),%rdi
  73dad6:	e8 d5 1f 00 00       	call   73fab0 <core::ptr::drop_glue::<gpui_reactivity_core::layout::LayoutTree>>
  73dadb:	49 8b b6 58 05 00 00 	mov    0x558(%r14),%rsi
  73dae2:	48 85 f6             	test   %rsi,%rsi
  73dae5:	74 16                	je     73dafd <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x37d>
  73dae7:	49 8b be 60 05 00 00 	mov    0x560(%r14),%rdi
  73daee:	48 c1 e6 04          	shl    $0x4,%rsi
  73daf2:	ba 08 00 00 00       	mov    $0x8,%edx
  73daf7:	ff 15 93 45 3c 00    	call   *0x3c4593(%rip)        # b02090 <_DYNAMIC+0x248>
  73dafd:	49 8d be 48 06 00 00 	lea    0x648(%r14),%rdi
  73db04:	e8 b7 5f fe ff       	call   723ac0 <<alloc::collections::btree::map::BTreeMap<gpui::list::ListId, alloc::collections::btree::set_val::SetValZST> as core::ops::drop::Drop>::drop>
  73db09:	49 8b 86 88 05 00 00 	mov    0x588(%r14),%rax
  73db10:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  73db14:	0f 84 7e 00 00 00    	je     73db98 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x418>
  73db1a:	4d 8b a6 98 05 00 00 	mov    0x598(%r14),%r12
  73db21:	4d 85 e4             	test   %r12,%r12
  73db24:	74 53                	je     73db79 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x3f9>
  73db26:	4d 8b ae 90 05 00 00 	mov    0x590(%r14),%r13
  73db2d:	49 83 c5 78          	add    $0x78,%r13
  73db31:	48 8b 2d b8 45 3c 00 	mov    0x3c45b8(%rip),%rbp        # b020f0 <_DYNAMIC+0x2a8>
  73db38:	eb 0f                	jmp    73db49 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x3c9>
  73db3a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  73db40:	49 83 c5 50          	add    $0x50,%r13
  73db44:	49 ff cc             	dec    %r12
  73db47:	74 29                	je     73db72 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x3f2>
  73db49:	49 8b 7d b0          	mov    -0x50(%r13),%rdi
  73db4d:	48 85 ff             	test   %rdi,%rdi
  73db50:	74 ee                	je     73db40 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x3c0>
  73db52:	f6 07 01             	testb  $0x1,(%rdi)
  73db55:	75 e9                	jne    73db40 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x3c0>
  73db57:	48 8b 47 08          	mov    0x8(%rdi),%rax
  73db5b:	a8 01                	test   $0x1,%al
  73db5d:	75 e1                	jne    73db40 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x3c0>
  73db5f:	48 8d 47 08          	lea    0x8(%rdi),%rax
  73db63:	f0 48 83 28 02       	lock subq $0x2,(%rax)
  73db68:	75 d6                	jne    73db40 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x3c0>
  73db6a:	48 8b 47 08          	mov    0x8(%rdi),%rax
  73db6e:	ff d5                	call   *%rbp
  73db70:	eb ce                	jmp    73db40 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x3c0>
  73db72:	49 8b 86 88 05 00 00 	mov    0x588(%r14),%rax
  73db79:	48 85 c0             	test   %rax,%rax
  73db7c:	74 1a                	je     73db98 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x418>
  73db7e:	49 8b be 90 05 00 00 	mov    0x590(%r14),%rdi
  73db85:	48 c1 e0 04          	shl    $0x4,%rax
  73db89:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  73db8d:	ba 08 00 00 00       	mov    $0x8,%edx
  73db92:	ff 15 f8 44 3c 00    	call   *0x3c44f8(%rip)        # b02090 <_DYNAMIC+0x248>
  73db98:	4d 8b a6 80 05 00 00 	mov    0x580(%r14),%r12
  73db9f:	4d 85 e4             	test   %r12,%r12
  73dba2:	74 4e                	je     73dbf2 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x472>
  73dba4:	4d 8b ae 78 05 00 00 	mov    0x578(%r14),%r13
  73dbab:	49 83 c5 78          	add    $0x78,%r13
  73dbaf:	48 8b 2d 3a 45 3c 00 	mov    0x3c453a(%rip),%rbp        # b020f0 <_DYNAMIC+0x2a8>
  73dbb6:	eb 11                	jmp    73dbc9 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x449>
  73dbb8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  73dbbf:	00 
  73dbc0:	49 83 c5 50          	add    $0x50,%r13
  73dbc4:	49 ff cc             	dec    %r12
  73dbc7:	74 29                	je     73dbf2 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x472>
  73dbc9:	49 8b 7d b0          	mov    -0x50(%r13),%rdi
  73dbcd:	48 85 ff             	test   %rdi,%rdi
  73dbd0:	74 ee                	je     73dbc0 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x440>
  73dbd2:	f6 07 01             	testb  $0x1,(%rdi)
  73dbd5:	75 e9                	jne    73dbc0 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x440>
  73dbd7:	48 8b 47 08          	mov    0x8(%rdi),%rax
  73dbdb:	a8 01                	test   $0x1,%al
  73dbdd:	75 e1                	jne    73dbc0 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x440>
  73dbdf:	48 8d 47 08          	lea    0x8(%rdi),%rax
  73dbe3:	f0 48 83 28 02       	lock subq $0x2,(%rax)
  73dbe8:	75 d6                	jne    73dbc0 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x440>
  73dbea:	48 8b 47 08          	mov    0x8(%rdi),%rax
  73dbee:	ff d5                	call   *%rbp
  73dbf0:	eb ce                	jmp    73dbc0 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x440>
  73dbf2:	49 8b 86 70 05 00 00 	mov    0x570(%r14),%rax
  73dbf9:	48 85 c0             	test   %rax,%rax
  73dbfc:	74 1a                	je     73dc18 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x498>
  73dbfe:	49 8b be 78 05 00 00 	mov    0x578(%r14),%rdi
  73dc05:	48 c1 e0 04          	shl    $0x4,%rax
  73dc09:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  73dc0d:	ba 08 00 00 00       	mov    $0x8,%edx
  73dc12:	ff 15 78 44 3c 00    	call   *0x3c4478(%rip)        # b02090 <_DYNAMIC+0x248>
  73dc18:	4c 89 f7             	mov    %r14,%rdi
  73dc1b:	e8 40 24 00 00       	call   740060 <core::ptr::drop_glue::<gpui_canvas::canvas::Canvas>>
  73dc20:	49 8b be 98 06 00 00 	mov    0x698(%r14),%rdi
  73dc27:	e8 f4 0c 00 00       	call   73e920 <core::ptr::drop_glue::<core::option::Option<alloc::boxed::Box<gpui::runtime::text_geometry::TextResources>>>>
  73dc2c:	be 28 07 00 00       	mov    $0x728,%esi
  73dc31:	ba 08 00 00 00       	mov    $0x8,%edx
  73dc36:	4c 89 f7             	mov    %r14,%rdi
  73dc39:	ff 15 51 44 3c 00    	call   *0x3c4451(%rip)        # b02090 <_DYNAMIC+0x248>
  73dc3f:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  73dc44:	48 c7 03 01 00 00 00 	movq   $0x1,(%rbx)
  73dc4b:	48 89 43 08          	mov    %rax,0x8(%rbx)
  73dc4f:	48 8d 35 82 76 39 00 	lea    0x397682(%rip),%rsi        # ad52d8 <anon.d860f86f9d097745b4f11ed46a5e2623.0.llvm.6888997129353907345>
  73dc56:	4c 89 ff             	mov    %r15,%rdi
  73dc59:	e8 72 a0 ff ff       	call   737cd0 <<std::thread::local::LocalKey<core::cell::RefCell<allocation_counter::allocator::AllocationInfoStack>>>::with::<allocation_counter::measure<unit_action_cost::ordinary_unit_action_cost::{closure#0}>::{closure#1}, allocation_counter::AllocationInfo>>
  73dc5e:	4c 89 f8             	mov    %r15,%rax
  73dc61:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  73dc68:	5b                   	pop    %rbx
  73dc69:	41 5c                	pop    %r12
  73dc6b:	41 5d                	pop    %r13
  73dc6d:	41 5e                	pop    %r14
  73dc6f:	41 5f                	pop    %r15
  73dc71:	5d                   	pop    %rbp
  73dc72:	c3                   	ret
  73dc73:	ba 0c 0c 00 00       	mov    $0xc0c,%edx
  73dc78:	4c 89 f7             	mov    %r14,%rdi
  73dc7b:	31 f6                	xor    %esi,%esi
  73dc7d:	ff 15 b5 49 3c 00    	call   *0x3c49b5(%rip)        # b02638 <memset@GLIBC_2.2.5>
  73dc83:	64 41 c6 84 24 10 0c 	movb   $0x1,%fs:0xc10(%r12)
  73dc8a:	00 00 01 
  73dc8d:	64 49 83 3c 24 00    	cmpq   $0x0,%fs:(%r12)
  73dc93:	0f 84 2d fb ff ff    	je     73d7c6 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x46>
  73dc99:	48 8d 3d 80 72 39 00 	lea    0x397280(%rip),%rdi        # ad4f20 <anon.ff3cab21037877729def149be6643aa6.6.llvm.17844888298126827638>
  73dca0:	ff 15 9a 49 3c 00    	call   *0x3c499a(%rip)        # b02640 <_DYNAMIC+0x7f8>
  73dca6:	48 8d 3d 97 c1 92 ff 	lea    -0x6d3e69(%rip),%rdi        # 69e44 <anon.ff3cab21037877729def149be6643aa6.3.llvm.17844888298126827638>
  73dcad:	48 8d 15 54 72 39 00 	lea    0x397254(%rip),%rdx        # ad4f08 <anon.ff3cab21037877729def149be6643aa6.5.llvm.17844888298126827638>
  73dcb4:	be 4b 00 00 00       	mov    $0x4b,%esi
  73dcb9:	ff 15 29 44 3c 00    	call   *0x3c4429(%rip)        # b020e8 <_DYNAMIC+0x2a0>
  73dcbf:	eb 53                	jmp    73dd14 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x594>
  73dcc1:	48 8b 84 24 90 00 00 	mov    0x90(%rsp),%rax
  73dcc8:	00 
  73dcc9:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
  73dcce:	0f 10 44 24 60       	movups 0x60(%rsp),%xmm0
  73dcd3:	0f 10 4c 24 70       	movups 0x70(%rsp),%xmm1
  73dcd8:	0f 10 94 24 80 00 00 	movups 0x80(%rsp),%xmm2
  73dcdf:	00 
  73dce0:	0f 29 54 24 30       	movaps %xmm2,0x30(%rsp)
  73dce5:	0f 29 4c 24 20       	movaps %xmm1,0x20(%rsp)
  73dcea:	0f 29 44 24 10       	movaps %xmm0,0x10(%rsp)
  73dcef:	48 8d 3d f2 c6 92 ff 	lea    -0x6d390e(%rip),%rdi        # 6a3e8 <anon.d860f86f9d097745b4f11ed46a5e2623.5.llvm.6888997129353907345>
  73dcf6:	48 8d 0d 13 76 39 00 	lea    0x397613(%rip),%rcx        # ad5310 <anon.d860f86f9d097745b4f11ed46a5e2623.4.llvm.6888997129353907345>
  73dcfd:	4c 8d 05 dc 75 39 00 	lea    0x3975dc(%rip),%r8        # ad52e0 <anon.d860f86f9d097745b4f11ed46a5e2623.0.llvm.6888997129353907345+0x8>
  73dd04:	48 8d 54 24 10       	lea    0x10(%rsp),%rdx
  73dd09:	be 2b 00 00 00       	mov    $0x2b,%esi
  73dd0e:	ff 15 a4 44 3c 00    	call   *0x3c44a4(%rip)        # b021b8 <_DYNAMIC+0x370>
  73dd14:	0f 0b                	ud2
  73dd16:	49 89 c7             	mov    %rax,%r15
  73dd19:	49 ff cc             	dec    %r12
  73dd1c:	74 0f                	je     73dd2d <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x5ad>
  73dd1e:	49 8b 7d 00          	mov    0x0(%r13),%rdi
  73dd22:	49 83 c5 50          	add    $0x50,%r13
  73dd26:	e8 e5 cc fe ff       	call   72aa10 <core::ptr::drop_glue::<core::option::Option<gpui::shared_text::SharedText>>>
  73dd2b:	eb ec                	jmp    73dd19 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x599>
  73dd2d:	49 8b 86 88 05 00 00 	mov    0x588(%r14),%rax
  73dd34:	48 85 c0             	test   %rax,%rax
  73dd37:	0f 84 59 02 00 00    	je     73df96 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x816>
  73dd3d:	49 8b be 90 05 00 00 	mov    0x590(%r14),%rdi
  73dd44:	48 c1 e0 04          	shl    $0x4,%rax
  73dd48:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  73dd4c:	ba 08 00 00 00       	mov    $0x8,%edx
  73dd51:	ff 15 39 43 3c 00    	call   *0x3c4339(%rip)        # b02090 <_DYNAMIC+0x248>
  73dd57:	e9 3a 02 00 00       	jmp    73df96 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x816>
  73dd5c:	ff 15 7e 43 3c 00    	call   *0x3c437e(%rip)        # b020e0 <_DYNAMIC+0x298>
  73dd62:	49 89 c7             	mov    %rax,%r15
  73dd65:	49 ff cc             	dec    %r12
  73dd68:	74 0f                	je     73dd79 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x5f9>
  73dd6a:	49 8b 7d 00          	mov    0x0(%r13),%rdi
  73dd6e:	49 83 c5 50          	add    $0x50,%r13
  73dd72:	e8 99 cc fe ff       	call   72aa10 <core::ptr::drop_glue::<core::option::Option<gpui::shared_text::SharedText>>>
  73dd77:	eb ec                	jmp    73dd65 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x5e5>
  73dd79:	49 8b 86 70 05 00 00 	mov    0x570(%r14),%rax
  73dd80:	48 85 c0             	test   %rax,%rax
  73dd83:	0f 84 19 02 00 00    	je     73dfa2 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x822>
  73dd89:	49 8b be 78 05 00 00 	mov    0x578(%r14),%rdi
  73dd90:	48 c1 e0 04          	shl    $0x4,%rax
  73dd94:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  73dd98:	ba 08 00 00 00       	mov    $0x8,%edx
  73dd9d:	ff 15 ed 42 3c 00    	call   *0x3c42ed(%rip)        # b02090 <_DYNAMIC+0x248>
  73dda3:	e9 fa 01 00 00       	jmp    73dfa2 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x822>
  73dda8:	ff 15 32 43 3c 00    	call   *0x3c4332(%rip)        # b020e0 <_DYNAMIC+0x298>
  73ddae:	49 89 c7             	mov    %rax,%r15
  73ddb1:	e9 00 02 00 00       	jmp    73dfb6 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x836>
  73ddb6:	49 89 c7             	mov    %rax,%r15
  73ddb9:	e9 ec 01 00 00       	jmp    73dfaa <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x82a>
  73ddbe:	49 89 c7             	mov    %rax,%r15
  73ddc1:	e9 c4 01 00 00       	jmp    73df8a <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x80a>
  73ddc6:	49 89 c7             	mov    %rax,%r15
  73ddc9:	e9 8e 01 00 00       	jmp    73df5c <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x7dc>
  73ddce:	49 89 c7             	mov    %rax,%r15
  73ddd1:	e9 7a 01 00 00       	jmp    73df50 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x7d0>
  73ddd6:	49 89 c7             	mov    %rax,%r15
  73ddd9:	e9 66 01 00 00       	jmp    73df44 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x7c4>
  73ddde:	49 89 c7             	mov    %rax,%r15
  73dde1:	e9 52 01 00 00       	jmp    73df38 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x7b8>
  73dde6:	49 89 c7             	mov    %rax,%r15
  73dde9:	e9 3e 01 00 00       	jmp    73df2c <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x7ac>
  73ddee:	e9 2a 01 00 00       	jmp    73df1d <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x79d>
  73ddf3:	49 89 c7             	mov    %rax,%r15
  73ddf6:	e9 02 01 00 00       	jmp    73defd <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x77d>
  73ddfb:	49 89 c7             	mov    %rax,%r15
  73ddfe:	49 8b 04 24          	mov    (%r12),%rax
  73de02:	48 85 c0             	test   %rax,%rax
  73de05:	0f 84 e6 00 00 00    	je     73def1 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x771>
  73de0b:	49 8b be b0 02 00 00 	mov    0x2b0(%r14),%rdi
  73de12:	48 c1 e0 04          	shl    $0x4,%rax
  73de16:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  73de1a:	ba 08 00 00 00       	mov    $0x8,%edx
  73de1f:	ff 15 6b 42 3c 00    	call   *0x3c426b(%rip)        # b02090 <_DYNAMIC+0x248>
  73de25:	e9 c7 00 00 00       	jmp    73def1 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x771>
  73de2a:	49 89 c7             	mov    %rax,%r15
  73de2d:	49 8b 04 24          	mov    (%r12),%rax
  73de31:	48 85 c0             	test   %rax,%rax
  73de34:	0f 84 9f 00 00 00    	je     73ded9 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x759>
  73de3a:	49 8b be 98 02 00 00 	mov    0x298(%r14),%rdi
  73de41:	48 c1 e0 03          	shl    $0x3,%rax
  73de45:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  73de49:	ba 08 00 00 00       	mov    $0x8,%edx
  73de4e:	ff 15 3c 42 3c 00    	call   *0x3c423c(%rip)        # b02090 <_DYNAMIC+0x248>
  73de54:	e9 80 00 00 00       	jmp    73ded9 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x759>
  73de59:	49 89 c7             	mov    %rax,%r15
  73de5c:	49 8b 34 24          	mov    (%r12),%rsi
  73de60:	48 85 f6             	test   %rsi,%rsi
  73de63:	74 68                	je     73decd <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x74d>
  73de65:	49 8b be 78 02 00 00 	mov    0x278(%r14),%rdi
  73de6c:	48 c1 e6 04          	shl    $0x4,%rsi
  73de70:	ba 08 00 00 00       	mov    $0x8,%edx
  73de75:	ff 15 15 42 3c 00    	call   *0x3c4215(%rip)        # b02090 <_DYNAMIC+0x248>
  73de7b:	eb 50                	jmp    73decd <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x74d>
  73de7d:	49 89 c7             	mov    %rax,%r15
  73de80:	49 8b 34 24          	mov    (%r12),%rsi
  73de84:	48 85 f6             	test   %rsi,%rsi
  73de87:	74 16                	je     73de9f <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x71f>
  73de89:	49 8b be 48 02 00 00 	mov    0x248(%r14),%rdi
  73de90:	48 c1 e6 04          	shl    $0x4,%rsi
  73de94:	ba 08 00 00 00       	mov    $0x8,%edx
  73de99:	ff 15 f1 41 3c 00    	call   *0x3c41f1(%rip)        # b02090 <_DYNAMIC+0x248>
  73de9f:	49 8b b6 58 02 00 00 	mov    0x258(%r14),%rsi
  73dea6:	48 85 f6             	test   %rsi,%rsi
  73dea9:	74 16                	je     73dec1 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x741>
  73deab:	49 8b be 60 02 00 00 	mov    0x260(%r14),%rdi
  73deb2:	48 c1 e6 03          	shl    $0x3,%rsi
  73deb6:	ba 08 00 00 00       	mov    $0x8,%edx
  73debb:	ff 15 cf 41 3c 00    	call   *0x3c41cf(%rip)        # b02090 <_DYNAMIC+0x248>
  73dec1:	49 8d be 70 02 00 00 	lea    0x270(%r14),%rdi
  73dec8:	e8 93 15 00 00       	call   73f460 <core::ptr::drop_glue::<alloc::vec::Vec<alloc::boxed::Box<dyn gpui::source::ComponentSchema<unit_action_cost::Model>>>>>
  73decd:	49 8d be 90 02 00 00 	lea    0x290(%r14),%rdi
  73ded4:	e8 77 17 00 00       	call   73f650 <core::ptr::drop_glue::<alloc::vec::Vec<gpui::runtime::Node>>>
  73ded9:	49 8d be 00 02 00 00 	lea    0x200(%r14),%rdi
  73dee0:	e8 ab 27 00 00       	call   740690 <core::ptr::drop_glue::<gpui::runtime::styles::Styles>>
  73dee5:	49 8d be a8 02 00 00 	lea    0x2a8(%r14),%rdi
  73deec:	e8 ff 14 00 00       	call   73f3f0 <core::ptr::drop_glue::<alloc::vec::Vec<core::option::Option<gpui::runtime::TextSite>>>>
  73def1:	49 8b be c0 05 00 00 	mov    0x5c0(%r14),%rdi
  73def8:	e8 53 0d 00 00       	call   73ec50 <core::ptr::drop_glue::<core::option::Option<alloc::boxed::Box<gpui::runtime::image::Images>>>>
  73defd:	49 8d be e8 01 00 00 	lea    0x1e8(%r14),%rdi
  73df04:	e8 87 26 00 00       	call   740590 <core::ptr::drop_glue::<gpui::runtime::identity_index::IdentityIndex>>
  73df09:	49 8d be c8 05 00 00 	lea    0x5c8(%r14),%rdi
  73df10:	e8 9b 5f fe ff       	call   723eb0 <<alloc::collections::btree::map::BTreeMap<gpui::source::FieldId, gpui::runtime::Fanout> as core::ops::drop::Drop>::drop>
  73df15:	eb 09                	jmp    73df20 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x7a0>
  73df17:	ff 15 c3 41 3c 00    	call   *0x3c41c3(%rip)        # b020e0 <_DYNAMIC+0x298>
  73df1d:	49 89 c7             	mov    %rax,%r15
  73df20:	49 8d be f8 05 00 00 	lea    0x5f8(%r14),%rdi
  73df27:	e8 e4 76 fe ff       	call   725610 <<alloc::collections::btree::map::BTreeMap<u64, gpui::property::Overlay<gpui::style::Style>> as core::ops::drop::Drop>::drop>
  73df2c:	49 8b be 10 06 00 00 	mov    0x610(%r14),%rdi
  73df33:	e8 b8 10 00 00       	call   73eff0 <core::ptr::drop_glue::<core::option::Option<alloc::boxed::Box<gpui::runtime::metadata::Metadata>>>>
  73df38:	49 8d be 18 06 00 00 	lea    0x618(%r14),%rdi
  73df3f:	e8 fc 66 fe ff       	call   724640 <<alloc::collections::btree::map::BTreeMap<gpui::runtime::scroll::ViewportKey, gpui::runtime::scroll::ViewportState> as core::ops::drop::Drop>::drop>
  73df44:	49 8d be 30 06 00 00 	lea    0x630(%r14),%rdi
  73df4b:	e8 60 6a fe ff       	call   7249b0 <<alloc::collections::btree::map::BTreeMap<(core::option::Option<u64>, gpui::list::ListId, gpui::element::NodeKind), usize> as core::ops::drop::Drop>::drop>
  73df50:	49 8d be c0 02 00 00 	lea    0x2c0(%r14),%rdi
  73df57:	e8 54 1b 00 00       	call   73fab0 <core::ptr::drop_glue::<gpui_reactivity_core::layout::LayoutTree>>
  73df5c:	49 8b b6 58 05 00 00 	mov    0x558(%r14),%rsi
  73df63:	48 85 f6             	test   %rsi,%rsi
  73df66:	74 16                	je     73df7e <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x7fe>
  73df68:	49 8b be 60 05 00 00 	mov    0x560(%r14),%rdi
  73df6f:	48 c1 e6 04          	shl    $0x4,%rsi
  73df73:	ba 08 00 00 00       	mov    $0x8,%edx
  73df78:	ff 15 12 41 3c 00    	call   *0x3c4112(%rip)        # b02090 <_DYNAMIC+0x248>
  73df7e:	49 8d be 48 06 00 00 	lea    0x648(%r14),%rdi
  73df85:	e8 36 5b fe ff       	call   723ac0 <<alloc::collections::btree::map::BTreeMap<gpui::list::ListId, alloc::collections::btree::set_val::SetValZST> as core::ops::drop::Drop>::drop>
  73df8a:	49 8d be 88 05 00 00 	lea    0x588(%r14),%rdi
  73df91:	e8 7a 12 00 00       	call   73f210 <core::ptr::drop_glue::<core::option::Option<gpui::runtime::Prepared>>>
  73df96:	49 8d be 70 05 00 00 	lea    0x570(%r14),%rdi
  73df9d:	e8 1e 17 00 00       	call   73f6c0 <core::ptr::drop_glue::<alloc::vec::Vec<gpui::runtime::Presented>>>
  73dfa2:	4c 89 f7             	mov    %r14,%rdi
  73dfa5:	e8 b6 20 00 00       	call   740060 <core::ptr::drop_glue::<gpui_canvas::canvas::Canvas>>
  73dfaa:	49 8b be 98 06 00 00 	mov    0x698(%r14),%rdi
  73dfb1:	e8 6a 09 00 00       	call   73e920 <core::ptr::drop_glue::<core::option::Option<alloc::boxed::Box<gpui::runtime::text_geometry::TextResources>>>>
  73dfb6:	be 28 07 00 00       	mov    $0x728,%esi
  73dfbb:	ba 08 00 00 00       	mov    $0x8,%edx
  73dfc0:	4c 89 f7             	mov    %r14,%rdi
  73dfc3:	ff 15 c7 40 3c 00    	call   *0x3c40c7(%rip)        # b02090 <_DYNAMIC+0x248>
  73dfc9:	48 c7 03 01 00 00 00 	movq   $0x1,(%rbx)
  73dfd0:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  73dfd5:	48 89 43 08          	mov    %rax,0x8(%rbx)
  73dfd9:	4c 89 ff             	mov    %r15,%rdi
  73dfdc:	e8 8f 44 39 00       	call   ad2470 <_Unwind_Resume@plt>
  73dfe1:	ff 15 f9 40 3c 00    	call   *0x3c40f9(%rip)        # b020e0 <_DYNAMIC+0x298>
  73dfe7:	49 89 c7             	mov    %rax,%r15
  73dfea:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  73dfef:	e8 fc 23 00 00       	call   7403f0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  73dff4:	4c 89 ff             	mov    %r15,%rdi
  73dff7:	e8 74 44 39 00       	call   ad2470 <_Unwind_Resume@plt>
  73dffc:	64 49 ff 04 24       	incq   %fs:(%r12)
  73e001:	48 89 c7             	mov    %rax,%rdi
  73e004:	e8 67 44 39 00       	call   ad2470 <_Unwind_Resume@plt>
