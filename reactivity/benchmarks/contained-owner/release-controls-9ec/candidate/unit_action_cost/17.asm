
/tmp/gpui-contained-owner-spike-target/release/deps/unit_action_cost-bcf457ce7db1ee75:     file format elf64-x86-64


Disassembly of section .text:

000000000073d750 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>>:
  73d750:	55                   	push   %rbp
  73d751:	41 57                	push   %r15
  73d753:	41 56                	push   %r14
  73d755:	41 55                	push   %r13
  73d757:	41 54                	push   %r12
  73d759:	53                   	push   %rbx
  73d75a:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  73d761:	48 89 f3             	mov    %rsi,%rbx
  73d764:	49 89 ff             	mov    %rdi,%r15
  73d767:	49 c7 c4 68 f3 ff ff 	mov    $0xfffffffffffff368,%r12
  73d76e:	64 4c 8b 34 25 00 00 	mov    %fs:0x0,%r14
  73d775:	00 00 
  73d777:	4d 01 e6             	add    %r12,%r14
  73d77a:	64 41 80 bc 24 10 0c 	cmpb   $0x0,%fs:0xc10(%r12)
  73d781:	00 00 00 
  73d784:	0f 84 b9 04 00 00    	je     73dc43 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x4f3>
  73d78a:	64 49 83 3c 24 00    	cmpq   $0x0,%fs:(%r12)
  73d790:	0f 85 d3 04 00 00    	jne    73dc69 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x519>
  73d796:	64 49 c7 04 24 ff ff 	movq   $0xffffffffffffffff,%fs:(%r12)
  73d79d:	ff ff 
  73d79f:	64 41 8b 84 24 08 0c 	mov    %fs:0xc08(%r12),%eax
  73d7a6:	00 00 
  73d7a8:	ff c0                	inc    %eax
  73d7aa:	64 41 89 84 24 08 0c 	mov    %eax,%fs:0xc08(%r12)
  73d7b1:	00 00 
  73d7b3:	83 f8 40             	cmp    $0x40,%eax
  73d7b6:	0f 83 ba 04 00 00    	jae    73dc76 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x526>
  73d7bc:	89 c0                	mov    %eax,%eax
  73d7be:	48 8d 04 40          	lea    (%rax,%rax,2),%rax
  73d7c2:	48 c1 e0 04          	shl    $0x4,%rax
  73d7c6:	0f 57 c0             	xorps  %xmm0,%xmm0
  73d7c9:	41 0f 11 44 06 28    	movups %xmm0,0x28(%r14,%rax,1)
  73d7cf:	41 0f 11 44 06 18    	movups %xmm0,0x18(%r14,%rax,1)
  73d7d5:	41 0f 11 44 06 08    	movups %xmm0,0x8(%r14,%rax,1)
  73d7db:	64 49 c7 04 24 00 00 	movq   $0x0,%fs:(%r12)
  73d7e2:	00 00 
  73d7e4:	48 b8 80 02 00 00 e0 	movabs $0x1e000000280,%rax
  73d7eb:	01 00 00 
  73d7ee:	48 89 44 24 20       	mov    %rax,0x20(%rsp)
  73d7f3:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%rsp)
  73d7fa:	00 
  73d7fb:	c7 44 24 18 00 00 4b 	movl   $0x434b0000,0x18(%rsp)
  73d802:	43 
  73d803:	66 c7 44 24 1c 00 00 	movw   $0x0,0x1c(%rsp)
  73d80a:	48 8d 7c 24 60       	lea    0x60(%rsp),%rdi
  73d80f:	48 8d 54 24 10       	lea    0x10(%rsp),%rdx
  73d814:	f3 0f 10 05 e0 6e 92 	movss  -0x6d9120(%rip),%xmm0        # 646fc <anon.079f5e587c394fcac2765eb4d0cf0bc2.312.llvm.6319143315422321905+0x28>
  73d81b:	ff 
  73d81c:	31 f6                	xor    %esi,%esi
  73d81e:	b9 01 00 00 00       	mov    $0x1,%ecx
  73d823:	45 31 c0             	xor    %r8d,%r8d
  73d826:	e8 45 1b fd ff       	call   70f370 <<gpui::runtime::Win<unit_action_cost::Model>>::mount_lanes>
  73d82b:	83 7c 24 60 fe       	cmpl   $0xfffffffe,0x60(%rsp)
  73d830:	0f 85 5b 04 00 00    	jne    73dc91 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x541>
  73d836:	48 8b 44 24 68       	mov    0x68(%rsp),%rax
  73d83b:	48 83 3b 00          	cmpq   $0x0,(%rbx)
  73d83f:	0f 84 cf 03 00 00    	je     73dc14 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x4c4>
  73d845:	4c 8b 73 08          	mov    0x8(%rbx),%r14
  73d849:	4d 85 f6             	test   %r14,%r14
  73d84c:	0f 84 c2 03 00 00    	je     73dc14 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x4c4>
  73d852:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  73d857:	4d 8d a6 40 02 00 00 	lea    0x240(%r14),%r12
  73d85e:	4c 89 e7             	mov    %r12,%rdi
  73d861:	e8 fa ee fe ff       	call   72c760 <<alloc::vec::Vec<alloc::boxed::Box<dyn gpui::source::ComponentSchema<unit_action_cost::Model>>> as core::ops::drop::Drop>::drop>
  73d866:	49 8b 34 24          	mov    (%r12),%rsi
  73d86a:	48 85 f6             	test   %rsi,%rsi
  73d86d:	74 16                	je     73d885 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x135>
  73d86f:	49 8b be 48 02 00 00 	mov    0x248(%r14),%rdi
  73d876:	48 c1 e6 04          	shl    $0x4,%rsi
  73d87a:	ba 08 00 00 00       	mov    $0x8,%edx
  73d87f:	ff 15 db 47 3c 00    	call   *0x3c47db(%rip)        # b02060 <_DYNAMIC+0x248>
  73d885:	49 8b b6 58 02 00 00 	mov    0x258(%r14),%rsi
  73d88c:	48 85 f6             	test   %rsi,%rsi
  73d88f:	74 16                	je     73d8a7 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x157>
  73d891:	49 8b be 60 02 00 00 	mov    0x260(%r14),%rdi
  73d898:	48 c1 e6 03          	shl    $0x3,%rsi
  73d89c:	ba 08 00 00 00       	mov    $0x8,%edx
  73d8a1:	ff 15 b9 47 3c 00    	call   *0x3c47b9(%rip)        # b02060 <_DYNAMIC+0x248>
  73d8a7:	4d 8d a6 70 02 00 00 	lea    0x270(%r14),%r12
  73d8ae:	4c 89 e7             	mov    %r12,%rdi
  73d8b1:	e8 aa ee fe ff       	call   72c760 <<alloc::vec::Vec<alloc::boxed::Box<dyn gpui::source::ComponentSchema<unit_action_cost::Model>>> as core::ops::drop::Drop>::drop>
  73d8b6:	49 8b 34 24          	mov    (%r12),%rsi
  73d8ba:	48 85 f6             	test   %rsi,%rsi
  73d8bd:	74 16                	je     73d8d5 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x185>
  73d8bf:	49 8b be 78 02 00 00 	mov    0x278(%r14),%rdi
  73d8c6:	48 c1 e6 04          	shl    $0x4,%rsi
  73d8ca:	ba 08 00 00 00       	mov    $0x8,%edx
  73d8cf:	ff 15 8b 47 3c 00    	call   *0x3c478b(%rip)        # b02060 <_DYNAMIC+0x248>
  73d8d5:	4d 8d a6 90 02 00 00 	lea    0x290(%r14),%r12
  73d8dc:	4c 89 e7             	mov    %r12,%rdi
  73d8df:	e8 9c f1 fe ff       	call   72ca80 <<alloc::vec::Vec<gpui::runtime::Node> as core::ops::drop::Drop>::drop>
  73d8e4:	49 8b 04 24          	mov    (%r12),%rax
  73d8e8:	48 85 c0             	test   %rax,%rax
  73d8eb:	74 1a                	je     73d907 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x1b7>
  73d8ed:	49 8b be 98 02 00 00 	mov    0x298(%r14),%rdi
  73d8f4:	48 c1 e0 03          	shl    $0x3,%rax
  73d8f8:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  73d8fc:	ba 08 00 00 00       	mov    $0x8,%edx
  73d901:	ff 15 59 47 3c 00    	call   *0x3c4759(%rip)        # b02060 <_DYNAMIC+0x248>
  73d907:	49 8d be 00 02 00 00 	lea    0x200(%r14),%rdi
  73d90e:	e8 4d 2d 00 00       	call   740660 <core::ptr::drop_glue::<gpui::runtime::styles::Styles>>
  73d913:	4d 8d a6 a8 02 00 00 	lea    0x2a8(%r14),%r12
  73d91a:	4c 89 e7             	mov    %r12,%rdi
  73d91d:	e8 ce ef fe ff       	call   72c8f0 <<alloc::vec::Vec<core::option::Option<gpui::runtime::TextSite>> as core::ops::drop::Drop>::drop>
  73d922:	49 8b 04 24          	mov    (%r12),%rax
  73d926:	48 85 c0             	test   %rax,%rax
  73d929:	74 1a                	je     73d945 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x1f5>
  73d92b:	49 8b be b0 02 00 00 	mov    0x2b0(%r14),%rdi
  73d932:	48 c1 e0 04          	shl    $0x4,%rax
  73d936:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  73d93a:	ba 08 00 00 00       	mov    $0x8,%edx
  73d93f:	ff 15 1b 47 3c 00    	call   *0x3c471b(%rip)        # b02060 <_DYNAMIC+0x248>
  73d945:	49 8b be c0 05 00 00 	mov    0x5c0(%r14),%rdi
  73d94c:	e8 cf 12 00 00       	call   73ec20 <core::ptr::drop_glue::<core::option::Option<alloc::boxed::Box<gpui::runtime::image::Images>>>>
  73d951:	49 8b 86 e8 01 00 00 	mov    0x1e8(%r14),%rax
  73d958:	48 85 c0             	test   %rax,%rax
  73d95b:	74 49                	je     73d9a6 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x256>
  73d95d:	83 f8 01             	cmp    $0x1,%eax
  73d960:	75 1e                	jne    73d980 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x230>
  73d962:	49 8b b6 f8 01 00 00 	mov    0x1f8(%r14),%rsi
  73d969:	48 85 f6             	test   %rsi,%rsi
  73d96c:	74 38                	je     73d9a6 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x256>
  73d96e:	49 8b be f0 01 00 00 	mov    0x1f0(%r14),%rdi
  73d975:	48 c1 e6 04          	shl    $0x4,%rsi
  73d979:	ba 08 00 00 00       	mov    $0x8,%edx
  73d97e:	eb 20                	jmp    73d9a0 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x250>
  73d980:	49 8b 86 f8 01 00 00 	mov    0x1f8(%r14),%rax
  73d987:	48 85 c0             	test   %rax,%rax
  73d98a:	74 1a                	je     73d9a6 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x256>
  73d98c:	49 8b be f0 01 00 00 	mov    0x1f0(%r14),%rdi
  73d993:	48 c1 e0 02          	shl    $0x2,%rax
  73d997:	48 8d 34 40          	lea    (%rax,%rax,2),%rsi
  73d99b:	ba 04 00 00 00       	mov    $0x4,%edx
  73d9a0:	ff 15 ba 46 3c 00    	call   *0x3c46ba(%rip)        # b02060 <_DYNAMIC+0x248>
  73d9a6:	49 8b 8e c8 05 00 00 	mov    0x5c8(%r14),%rcx
  73d9ad:	48 85 c9             	test   %rcx,%rcx
  73d9b0:	74 3b                	je     73d9ed <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x29d>
  73d9b2:	49 8b 96 d0 05 00 00 	mov    0x5d0(%r14),%rdx
  73d9b9:	49 8b 86 d8 05 00 00 	mov    0x5d8(%r14),%rax
  73d9c0:	48 c7 44 24 18 00 00 	movq   $0x0,0x18(%rsp)
  73d9c7:	00 00 
  73d9c9:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  73d9ce:	48 89 54 24 28       	mov    %rdx,0x28(%rsp)
  73d9d3:	48 c7 44 24 38 00 00 	movq   $0x0,0x38(%rsp)
  73d9da:	00 00 
  73d9dc:	48 89 4c 24 40       	mov    %rcx,0x40(%rsp)
  73d9e1:	48 89 54 24 48       	mov    %rdx,0x48(%rsp)
  73d9e6:	b9 01 00 00 00       	mov    $0x1,%ecx
  73d9eb:	eb 04                	jmp    73d9f1 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x2a1>
  73d9ed:	31 c9                	xor    %ecx,%ecx
  73d9ef:	31 c0                	xor    %eax,%eax
  73d9f1:	48 89 4c 24 10       	mov    %rcx,0x10(%rsp)
  73d9f6:	48 89 4c 24 30       	mov    %rcx,0x30(%rsp)
  73d9fb:	48 89 44 24 50       	mov    %rax,0x50(%rsp)
  73da00:	48 8d 7c 24 60       	lea    0x60(%rsp),%rdi
  73da05:	48 8d 74 24 10       	lea    0x10(%rsp),%rsi
  73da0a:	e8 b1 4c fe ff       	call   7226c0 <<alloc::collections::btree::map::IntoIter<gpui::source::FieldId, gpui::runtime::Fanout>>::dying_next>
  73da0f:	48 8b 44 24 60       	mov    0x60(%rsp),%rax
  73da14:	48 85 c0             	test   %rax,%rax
  73da17:	74 56                	je     73da6f <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x31f>
  73da19:	4c 8d 64 24 60       	lea    0x60(%rsp),%r12
  73da1e:	4c 8d 6c 24 10       	lea    0x10(%rsp),%r13
  73da23:	48 8b 2d 36 46 3c 00 	mov    0x3c4636(%rip),%rbp        # b02060 <_DYNAMIC+0x248>
  73da2a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  73da30:	48 8b 4c 24 70       	mov    0x70(%rsp),%rcx
  73da35:	48 c1 e1 05          	shl    $0x5,%rcx
  73da39:	48 8b 34 08          	mov    (%rax,%rcx,1),%rsi
  73da3d:	48 83 fe ff          	cmp    $0xffffffffffffffff,%rsi
  73da41:	74 17                	je     73da5a <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x30a>
  73da43:	48 85 f6             	test   %rsi,%rsi
  73da46:	74 12                	je     73da5a <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x30a>
  73da48:	48 01 c8             	add    %rcx,%rax
  73da4b:	48 8b 78 08          	mov    0x8(%rax),%rdi
  73da4f:	48 c1 e6 02          	shl    $0x2,%rsi
  73da53:	ba 04 00 00 00       	mov    $0x4,%edx
  73da58:	ff d5                	call   *%rbp
  73da5a:	4c 89 e7             	mov    %r12,%rdi
  73da5d:	4c 89 ee             	mov    %r13,%rsi
  73da60:	e8 5b 4c fe ff       	call   7226c0 <<alloc::collections::btree::map::IntoIter<gpui::source::FieldId, gpui::runtime::Fanout>>::dying_next>
  73da65:	48 8b 44 24 60       	mov    0x60(%rsp),%rax
  73da6a:	48 85 c0             	test   %rax,%rax
  73da6d:	75 c1                	jne    73da30 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x2e0>
  73da6f:	49 8d be f8 05 00 00 	lea    0x5f8(%r14),%rdi
  73da76:	e8 65 7b fe ff       	call   7255e0 <<alloc::collections::btree::map::BTreeMap<u64, gpui::property::Overlay<gpui::style::Style>> as core::ops::drop::Drop>::drop>
  73da7b:	49 8b be 10 06 00 00 	mov    0x610(%r14),%rdi
  73da82:	e8 39 15 00 00       	call   73efc0 <core::ptr::drop_glue::<core::option::Option<alloc::boxed::Box<gpui::runtime::metadata::Metadata>>>>
  73da87:	49 8d be 18 06 00 00 	lea    0x618(%r14),%rdi
  73da8e:	e8 7d 6b fe ff       	call   724610 <<alloc::collections::btree::map::BTreeMap<gpui::runtime::scroll::ViewportKey, gpui::runtime::scroll::ViewportState> as core::ops::drop::Drop>::drop>
  73da93:	49 8d be 30 06 00 00 	lea    0x630(%r14),%rdi
  73da9a:	e8 e1 6e fe ff       	call   724980 <<alloc::collections::btree::map::BTreeMap<(core::option::Option<u64>, gpui::list::ListId, gpui::element::NodeKind), usize> as core::ops::drop::Drop>::drop>
  73da9f:	49 8d be c0 02 00 00 	lea    0x2c0(%r14),%rdi
  73daa6:	e8 d5 1f 00 00       	call   73fa80 <core::ptr::drop_glue::<gpui_reactivity_core::layout::LayoutTree>>
  73daab:	49 8b b6 58 05 00 00 	mov    0x558(%r14),%rsi
  73dab2:	48 85 f6             	test   %rsi,%rsi
  73dab5:	74 16                	je     73dacd <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x37d>
  73dab7:	49 8b be 60 05 00 00 	mov    0x560(%r14),%rdi
  73dabe:	48 c1 e6 04          	shl    $0x4,%rsi
  73dac2:	ba 08 00 00 00       	mov    $0x8,%edx
  73dac7:	ff 15 93 45 3c 00    	call   *0x3c4593(%rip)        # b02060 <_DYNAMIC+0x248>
  73dacd:	49 8d be 48 06 00 00 	lea    0x648(%r14),%rdi
  73dad4:	e8 b7 5f fe ff       	call   723a90 <<alloc::collections::btree::map::BTreeMap<gpui::list::ListId, alloc::collections::btree::set_val::SetValZST> as core::ops::drop::Drop>::drop>
  73dad9:	49 8b 86 88 05 00 00 	mov    0x588(%r14),%rax
  73dae0:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  73dae4:	0f 84 7e 00 00 00    	je     73db68 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x418>
  73daea:	4d 8b a6 98 05 00 00 	mov    0x598(%r14),%r12
  73daf1:	4d 85 e4             	test   %r12,%r12
  73daf4:	74 53                	je     73db49 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x3f9>
  73daf6:	4d 8b ae 90 05 00 00 	mov    0x590(%r14),%r13
  73dafd:	49 83 c5 78          	add    $0x78,%r13
  73db01:	48 8b 2d b8 45 3c 00 	mov    0x3c45b8(%rip),%rbp        # b020c0 <_DYNAMIC+0x2a8>
  73db08:	eb 0f                	jmp    73db19 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x3c9>
  73db0a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  73db10:	49 83 c5 50          	add    $0x50,%r13
  73db14:	49 ff cc             	dec    %r12
  73db17:	74 29                	je     73db42 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x3f2>
  73db19:	49 8b 7d b0          	mov    -0x50(%r13),%rdi
  73db1d:	48 85 ff             	test   %rdi,%rdi
  73db20:	74 ee                	je     73db10 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x3c0>
  73db22:	f6 07 01             	testb  $0x1,(%rdi)
  73db25:	75 e9                	jne    73db10 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x3c0>
  73db27:	48 8b 47 08          	mov    0x8(%rdi),%rax
  73db2b:	a8 01                	test   $0x1,%al
  73db2d:	75 e1                	jne    73db10 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x3c0>
  73db2f:	48 8d 47 08          	lea    0x8(%rdi),%rax
  73db33:	f0 48 83 28 02       	lock subq $0x2,(%rax)
  73db38:	75 d6                	jne    73db10 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x3c0>
  73db3a:	48 8b 47 08          	mov    0x8(%rdi),%rax
  73db3e:	ff d5                	call   *%rbp
  73db40:	eb ce                	jmp    73db10 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x3c0>
  73db42:	49 8b 86 88 05 00 00 	mov    0x588(%r14),%rax
  73db49:	48 85 c0             	test   %rax,%rax
  73db4c:	74 1a                	je     73db68 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x418>
  73db4e:	49 8b be 90 05 00 00 	mov    0x590(%r14),%rdi
  73db55:	48 c1 e0 04          	shl    $0x4,%rax
  73db59:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  73db5d:	ba 08 00 00 00       	mov    $0x8,%edx
  73db62:	ff 15 f8 44 3c 00    	call   *0x3c44f8(%rip)        # b02060 <_DYNAMIC+0x248>
  73db68:	4d 8b a6 80 05 00 00 	mov    0x580(%r14),%r12
  73db6f:	4d 85 e4             	test   %r12,%r12
  73db72:	74 4e                	je     73dbc2 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x472>
  73db74:	4d 8b ae 78 05 00 00 	mov    0x578(%r14),%r13
  73db7b:	49 83 c5 78          	add    $0x78,%r13
  73db7f:	48 8b 2d 3a 45 3c 00 	mov    0x3c453a(%rip),%rbp        # b020c0 <_DYNAMIC+0x2a8>
  73db86:	eb 11                	jmp    73db99 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x449>
  73db88:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  73db8f:	00 
  73db90:	49 83 c5 50          	add    $0x50,%r13
  73db94:	49 ff cc             	dec    %r12
  73db97:	74 29                	je     73dbc2 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x472>
  73db99:	49 8b 7d b0          	mov    -0x50(%r13),%rdi
  73db9d:	48 85 ff             	test   %rdi,%rdi
  73dba0:	74 ee                	je     73db90 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x440>
  73dba2:	f6 07 01             	testb  $0x1,(%rdi)
  73dba5:	75 e9                	jne    73db90 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x440>
  73dba7:	48 8b 47 08          	mov    0x8(%rdi),%rax
  73dbab:	a8 01                	test   $0x1,%al
  73dbad:	75 e1                	jne    73db90 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x440>
  73dbaf:	48 8d 47 08          	lea    0x8(%rdi),%rax
  73dbb3:	f0 48 83 28 02       	lock subq $0x2,(%rax)
  73dbb8:	75 d6                	jne    73db90 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x440>
  73dbba:	48 8b 47 08          	mov    0x8(%rdi),%rax
  73dbbe:	ff d5                	call   *%rbp
  73dbc0:	eb ce                	jmp    73db90 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x440>
  73dbc2:	49 8b 86 70 05 00 00 	mov    0x570(%r14),%rax
  73dbc9:	48 85 c0             	test   %rax,%rax
  73dbcc:	74 1a                	je     73dbe8 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x498>
  73dbce:	49 8b be 78 05 00 00 	mov    0x578(%r14),%rdi
  73dbd5:	48 c1 e0 04          	shl    $0x4,%rax
  73dbd9:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  73dbdd:	ba 08 00 00 00       	mov    $0x8,%edx
  73dbe2:	ff 15 78 44 3c 00    	call   *0x3c4478(%rip)        # b02060 <_DYNAMIC+0x248>
  73dbe8:	4c 89 f7             	mov    %r14,%rdi
  73dbeb:	e8 40 24 00 00       	call   740030 <core::ptr::drop_glue::<gpui_canvas::canvas::Canvas>>
  73dbf0:	49 8b be 98 06 00 00 	mov    0x698(%r14),%rdi
  73dbf7:	e8 f4 0c 00 00       	call   73e8f0 <core::ptr::drop_glue::<core::option::Option<alloc::boxed::Box<gpui::runtime::text_geometry::TextResources>>>>
  73dbfc:	be 28 07 00 00       	mov    $0x728,%esi
  73dc01:	ba 08 00 00 00       	mov    $0x8,%edx
  73dc06:	4c 89 f7             	mov    %r14,%rdi
  73dc09:	ff 15 51 44 3c 00    	call   *0x3c4451(%rip)        # b02060 <_DYNAMIC+0x248>
  73dc0f:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  73dc14:	48 c7 03 01 00 00 00 	movq   $0x1,(%rbx)
  73dc1b:	48 89 43 08          	mov    %rax,0x8(%rbx)
  73dc1f:	48 8d 35 82 76 39 00 	lea    0x397682(%rip),%rsi        # ad52a8 <anon.d860f86f9d097745b4f11ed46a5e2623.0.llvm.15216714876769819238>
  73dc26:	4c 89 ff             	mov    %r15,%rdi
  73dc29:	e8 72 a0 ff ff       	call   737ca0 <<std::thread::local::LocalKey<core::cell::RefCell<allocation_counter::allocator::AllocationInfoStack>>>::with::<allocation_counter::measure<unit_action_cost::ordinary_unit_action_cost::{closure#0}>::{closure#1}, allocation_counter::AllocationInfo>>
  73dc2e:	4c 89 f8             	mov    %r15,%rax
  73dc31:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  73dc38:	5b                   	pop    %rbx
  73dc39:	41 5c                	pop    %r12
  73dc3b:	41 5d                	pop    %r13
  73dc3d:	41 5e                	pop    %r14
  73dc3f:	41 5f                	pop    %r15
  73dc41:	5d                   	pop    %rbp
  73dc42:	c3                   	ret
  73dc43:	ba 0c 0c 00 00       	mov    $0xc0c,%edx
  73dc48:	4c 89 f7             	mov    %r14,%rdi
  73dc4b:	31 f6                	xor    %esi,%esi
  73dc4d:	ff 15 b5 49 3c 00    	call   *0x3c49b5(%rip)        # b02608 <memset@GLIBC_2.2.5>
  73dc53:	64 41 c6 84 24 10 0c 	movb   $0x1,%fs:0xc10(%r12)
  73dc5a:	00 00 01 
  73dc5d:	64 49 83 3c 24 00    	cmpq   $0x0,%fs:(%r12)
  73dc63:	0f 84 2d fb ff ff    	je     73d796 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x46>
  73dc69:	48 8d 3d 80 72 39 00 	lea    0x397280(%rip),%rdi        # ad4ef0 <anon.ff3cab21037877729def149be6643aa6.6.llvm.17844888298126827638>
  73dc70:	ff 15 9a 49 3c 00    	call   *0x3c499a(%rip)        # b02610 <_DYNAMIC+0x7f8>
  73dc76:	48 8d 3d c7 c1 92 ff 	lea    -0x6d3e39(%rip),%rdi        # 69e44 <anon.ff3cab21037877729def149be6643aa6.3.llvm.17844888298126827638>
  73dc7d:	48 8d 15 54 72 39 00 	lea    0x397254(%rip),%rdx        # ad4ed8 <anon.ff3cab21037877729def149be6643aa6.5.llvm.17844888298126827638>
  73dc84:	be 4b 00 00 00       	mov    $0x4b,%esi
  73dc89:	ff 15 29 44 3c 00    	call   *0x3c4429(%rip)        # b020b8 <_DYNAMIC+0x2a0>
  73dc8f:	eb 53                	jmp    73dce4 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x594>
  73dc91:	48 8b 84 24 90 00 00 	mov    0x90(%rsp),%rax
  73dc98:	00 
  73dc99:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
  73dc9e:	0f 10 44 24 60       	movups 0x60(%rsp),%xmm0
  73dca3:	0f 10 4c 24 70       	movups 0x70(%rsp),%xmm1
  73dca8:	0f 10 94 24 80 00 00 	movups 0x80(%rsp),%xmm2
  73dcaf:	00 
  73dcb0:	0f 29 54 24 30       	movaps %xmm2,0x30(%rsp)
  73dcb5:	0f 29 4c 24 20       	movaps %xmm1,0x20(%rsp)
  73dcba:	0f 29 44 24 10       	movaps %xmm0,0x10(%rsp)
  73dcbf:	48 8d 3d 22 c7 92 ff 	lea    -0x6d38de(%rip),%rdi        # 6a3e8 <anon.d860f86f9d097745b4f11ed46a5e2623.5.llvm.15216714876769819238>
  73dcc6:	48 8d 0d 13 76 39 00 	lea    0x397613(%rip),%rcx        # ad52e0 <anon.d860f86f9d097745b4f11ed46a5e2623.4.llvm.15216714876769819238>
  73dccd:	4c 8d 05 dc 75 39 00 	lea    0x3975dc(%rip),%r8        # ad52b0 <anon.d860f86f9d097745b4f11ed46a5e2623.0.llvm.15216714876769819238+0x8>
  73dcd4:	48 8d 54 24 10       	lea    0x10(%rsp),%rdx
  73dcd9:	be 2b 00 00 00       	mov    $0x2b,%esi
  73dcde:	ff 15 a4 44 3c 00    	call   *0x3c44a4(%rip)        # b02188 <_DYNAMIC+0x370>
  73dce4:	0f 0b                	ud2
  73dce6:	49 89 c7             	mov    %rax,%r15
  73dce9:	49 ff cc             	dec    %r12
  73dcec:	74 0f                	je     73dcfd <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x5ad>
  73dcee:	49 8b 7d 00          	mov    0x0(%r13),%rdi
  73dcf2:	49 83 c5 50          	add    $0x50,%r13
  73dcf6:	e8 e5 cc fe ff       	call   72a9e0 <core::ptr::drop_glue::<core::option::Option<gpui::shared_text::SharedText>>>
  73dcfb:	eb ec                	jmp    73dce9 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x599>
  73dcfd:	49 8b 86 88 05 00 00 	mov    0x588(%r14),%rax
  73dd04:	48 85 c0             	test   %rax,%rax
  73dd07:	0f 84 59 02 00 00    	je     73df66 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x816>
  73dd0d:	49 8b be 90 05 00 00 	mov    0x590(%r14),%rdi
  73dd14:	48 c1 e0 04          	shl    $0x4,%rax
  73dd18:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  73dd1c:	ba 08 00 00 00       	mov    $0x8,%edx
  73dd21:	ff 15 39 43 3c 00    	call   *0x3c4339(%rip)        # b02060 <_DYNAMIC+0x248>
  73dd27:	e9 3a 02 00 00       	jmp    73df66 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x816>
  73dd2c:	ff 15 7e 43 3c 00    	call   *0x3c437e(%rip)        # b020b0 <_DYNAMIC+0x298>
  73dd32:	49 89 c7             	mov    %rax,%r15
  73dd35:	49 ff cc             	dec    %r12
  73dd38:	74 0f                	je     73dd49 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x5f9>
  73dd3a:	49 8b 7d 00          	mov    0x0(%r13),%rdi
  73dd3e:	49 83 c5 50          	add    $0x50,%r13
  73dd42:	e8 99 cc fe ff       	call   72a9e0 <core::ptr::drop_glue::<core::option::Option<gpui::shared_text::SharedText>>>
  73dd47:	eb ec                	jmp    73dd35 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x5e5>
  73dd49:	49 8b 86 70 05 00 00 	mov    0x570(%r14),%rax
  73dd50:	48 85 c0             	test   %rax,%rax
  73dd53:	0f 84 19 02 00 00    	je     73df72 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x822>
  73dd59:	49 8b be 78 05 00 00 	mov    0x578(%r14),%rdi
  73dd60:	48 c1 e0 04          	shl    $0x4,%rax
  73dd64:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  73dd68:	ba 08 00 00 00       	mov    $0x8,%edx
  73dd6d:	ff 15 ed 42 3c 00    	call   *0x3c42ed(%rip)        # b02060 <_DYNAMIC+0x248>
  73dd73:	e9 fa 01 00 00       	jmp    73df72 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x822>
  73dd78:	ff 15 32 43 3c 00    	call   *0x3c4332(%rip)        # b020b0 <_DYNAMIC+0x298>
  73dd7e:	49 89 c7             	mov    %rax,%r15
  73dd81:	e9 00 02 00 00       	jmp    73df86 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x836>
  73dd86:	49 89 c7             	mov    %rax,%r15
  73dd89:	e9 ec 01 00 00       	jmp    73df7a <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x82a>
  73dd8e:	49 89 c7             	mov    %rax,%r15
  73dd91:	e9 c4 01 00 00       	jmp    73df5a <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x80a>
  73dd96:	49 89 c7             	mov    %rax,%r15
  73dd99:	e9 8e 01 00 00       	jmp    73df2c <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x7dc>
  73dd9e:	49 89 c7             	mov    %rax,%r15
  73dda1:	e9 7a 01 00 00       	jmp    73df20 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x7d0>
  73dda6:	49 89 c7             	mov    %rax,%r15
  73dda9:	e9 66 01 00 00       	jmp    73df14 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x7c4>
  73ddae:	49 89 c7             	mov    %rax,%r15
  73ddb1:	e9 52 01 00 00       	jmp    73df08 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x7b8>
  73ddb6:	49 89 c7             	mov    %rax,%r15
  73ddb9:	e9 3e 01 00 00       	jmp    73defc <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x7ac>
  73ddbe:	e9 2a 01 00 00       	jmp    73deed <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x79d>
  73ddc3:	49 89 c7             	mov    %rax,%r15
  73ddc6:	e9 02 01 00 00       	jmp    73decd <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x77d>
  73ddcb:	49 89 c7             	mov    %rax,%r15
  73ddce:	49 8b 04 24          	mov    (%r12),%rax
  73ddd2:	48 85 c0             	test   %rax,%rax
  73ddd5:	0f 84 e6 00 00 00    	je     73dec1 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x771>
  73dddb:	49 8b be b0 02 00 00 	mov    0x2b0(%r14),%rdi
  73dde2:	48 c1 e0 04          	shl    $0x4,%rax
  73dde6:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  73ddea:	ba 08 00 00 00       	mov    $0x8,%edx
  73ddef:	ff 15 6b 42 3c 00    	call   *0x3c426b(%rip)        # b02060 <_DYNAMIC+0x248>
  73ddf5:	e9 c7 00 00 00       	jmp    73dec1 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x771>
  73ddfa:	49 89 c7             	mov    %rax,%r15
  73ddfd:	49 8b 04 24          	mov    (%r12),%rax
  73de01:	48 85 c0             	test   %rax,%rax
  73de04:	0f 84 9f 00 00 00    	je     73dea9 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x759>
  73de0a:	49 8b be 98 02 00 00 	mov    0x298(%r14),%rdi
  73de11:	48 c1 e0 03          	shl    $0x3,%rax
  73de15:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  73de19:	ba 08 00 00 00       	mov    $0x8,%edx
  73de1e:	ff 15 3c 42 3c 00    	call   *0x3c423c(%rip)        # b02060 <_DYNAMIC+0x248>
  73de24:	e9 80 00 00 00       	jmp    73dea9 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x759>
  73de29:	49 89 c7             	mov    %rax,%r15
  73de2c:	49 8b 34 24          	mov    (%r12),%rsi
  73de30:	48 85 f6             	test   %rsi,%rsi
  73de33:	74 68                	je     73de9d <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x74d>
  73de35:	49 8b be 78 02 00 00 	mov    0x278(%r14),%rdi
  73de3c:	48 c1 e6 04          	shl    $0x4,%rsi
  73de40:	ba 08 00 00 00       	mov    $0x8,%edx
  73de45:	ff 15 15 42 3c 00    	call   *0x3c4215(%rip)        # b02060 <_DYNAMIC+0x248>
  73de4b:	eb 50                	jmp    73de9d <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x74d>
  73de4d:	49 89 c7             	mov    %rax,%r15
  73de50:	49 8b 34 24          	mov    (%r12),%rsi
  73de54:	48 85 f6             	test   %rsi,%rsi
  73de57:	74 16                	je     73de6f <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x71f>
  73de59:	49 8b be 48 02 00 00 	mov    0x248(%r14),%rdi
  73de60:	48 c1 e6 04          	shl    $0x4,%rsi
  73de64:	ba 08 00 00 00       	mov    $0x8,%edx
  73de69:	ff 15 f1 41 3c 00    	call   *0x3c41f1(%rip)        # b02060 <_DYNAMIC+0x248>
  73de6f:	49 8b b6 58 02 00 00 	mov    0x258(%r14),%rsi
  73de76:	48 85 f6             	test   %rsi,%rsi
  73de79:	74 16                	je     73de91 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x741>
  73de7b:	49 8b be 60 02 00 00 	mov    0x260(%r14),%rdi
  73de82:	48 c1 e6 03          	shl    $0x3,%rsi
  73de86:	ba 08 00 00 00       	mov    $0x8,%edx
  73de8b:	ff 15 cf 41 3c 00    	call   *0x3c41cf(%rip)        # b02060 <_DYNAMIC+0x248>
  73de91:	49 8d be 70 02 00 00 	lea    0x270(%r14),%rdi
  73de98:	e8 93 15 00 00       	call   73f430 <core::ptr::drop_glue::<alloc::vec::Vec<alloc::boxed::Box<dyn gpui::source::ComponentSchema<unit_action_cost::Model>>>>>
  73de9d:	49 8d be 90 02 00 00 	lea    0x290(%r14),%rdi
  73dea4:	e8 77 17 00 00       	call   73f620 <core::ptr::drop_glue::<alloc::vec::Vec<gpui::runtime::Node>>>
  73dea9:	49 8d be 00 02 00 00 	lea    0x200(%r14),%rdi
  73deb0:	e8 ab 27 00 00       	call   740660 <core::ptr::drop_glue::<gpui::runtime::styles::Styles>>
  73deb5:	49 8d be a8 02 00 00 	lea    0x2a8(%r14),%rdi
  73debc:	e8 ff 14 00 00       	call   73f3c0 <core::ptr::drop_glue::<alloc::vec::Vec<core::option::Option<gpui::runtime::TextSite>>>>
  73dec1:	49 8b be c0 05 00 00 	mov    0x5c0(%r14),%rdi
  73dec8:	e8 53 0d 00 00       	call   73ec20 <core::ptr::drop_glue::<core::option::Option<alloc::boxed::Box<gpui::runtime::image::Images>>>>
  73decd:	49 8d be e8 01 00 00 	lea    0x1e8(%r14),%rdi
  73ded4:	e8 87 26 00 00       	call   740560 <core::ptr::drop_glue::<gpui::runtime::identity_index::IdentityIndex>>
  73ded9:	49 8d be c8 05 00 00 	lea    0x5c8(%r14),%rdi
  73dee0:	e8 9b 5f fe ff       	call   723e80 <<alloc::collections::btree::map::BTreeMap<gpui::source::FieldId, gpui::runtime::Fanout> as core::ops::drop::Drop>::drop>
  73dee5:	eb 09                	jmp    73def0 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x7a0>
  73dee7:	ff 15 c3 41 3c 00    	call   *0x3c41c3(%rip)        # b020b0 <_DYNAMIC+0x298>
  73deed:	49 89 c7             	mov    %rax,%r15
  73def0:	49 8d be f8 05 00 00 	lea    0x5f8(%r14),%rdi
  73def7:	e8 e4 76 fe ff       	call   7255e0 <<alloc::collections::btree::map::BTreeMap<u64, gpui::property::Overlay<gpui::style::Style>> as core::ops::drop::Drop>::drop>
  73defc:	49 8b be 10 06 00 00 	mov    0x610(%r14),%rdi
  73df03:	e8 b8 10 00 00       	call   73efc0 <core::ptr::drop_glue::<core::option::Option<alloc::boxed::Box<gpui::runtime::metadata::Metadata>>>>
  73df08:	49 8d be 18 06 00 00 	lea    0x618(%r14),%rdi
  73df0f:	e8 fc 66 fe ff       	call   724610 <<alloc::collections::btree::map::BTreeMap<gpui::runtime::scroll::ViewportKey, gpui::runtime::scroll::ViewportState> as core::ops::drop::Drop>::drop>
  73df14:	49 8d be 30 06 00 00 	lea    0x630(%r14),%rdi
  73df1b:	e8 60 6a fe ff       	call   724980 <<alloc::collections::btree::map::BTreeMap<(core::option::Option<u64>, gpui::list::ListId, gpui::element::NodeKind), usize> as core::ops::drop::Drop>::drop>
  73df20:	49 8d be c0 02 00 00 	lea    0x2c0(%r14),%rdi
  73df27:	e8 54 1b 00 00       	call   73fa80 <core::ptr::drop_glue::<gpui_reactivity_core::layout::LayoutTree>>
  73df2c:	49 8b b6 58 05 00 00 	mov    0x558(%r14),%rsi
  73df33:	48 85 f6             	test   %rsi,%rsi
  73df36:	74 16                	je     73df4e <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x7fe>
  73df38:	49 8b be 60 05 00 00 	mov    0x560(%r14),%rdi
  73df3f:	48 c1 e6 04          	shl    $0x4,%rsi
  73df43:	ba 08 00 00 00       	mov    $0x8,%edx
  73df48:	ff 15 12 41 3c 00    	call   *0x3c4112(%rip)        # b02060 <_DYNAMIC+0x248>
  73df4e:	49 8d be 48 06 00 00 	lea    0x648(%r14),%rdi
  73df55:	e8 36 5b fe ff       	call   723a90 <<alloc::collections::btree::map::BTreeMap<gpui::list::ListId, alloc::collections::btree::set_val::SetValZST> as core::ops::drop::Drop>::drop>
  73df5a:	49 8d be 88 05 00 00 	lea    0x588(%r14),%rdi
  73df61:	e8 7a 12 00 00       	call   73f1e0 <core::ptr::drop_glue::<core::option::Option<gpui::runtime::Prepared>>>
  73df66:	49 8d be 70 05 00 00 	lea    0x570(%r14),%rdi
  73df6d:	e8 1e 17 00 00       	call   73f690 <core::ptr::drop_glue::<alloc::vec::Vec<gpui::runtime::Presented>>>
  73df72:	4c 89 f7             	mov    %r14,%rdi
  73df75:	e8 b6 20 00 00       	call   740030 <core::ptr::drop_glue::<gpui_canvas::canvas::Canvas>>
  73df7a:	49 8b be 98 06 00 00 	mov    0x698(%r14),%rdi
  73df81:	e8 6a 09 00 00       	call   73e8f0 <core::ptr::drop_glue::<core::option::Option<alloc::boxed::Box<gpui::runtime::text_geometry::TextResources>>>>
  73df86:	be 28 07 00 00       	mov    $0x728,%esi
  73df8b:	ba 08 00 00 00       	mov    $0x8,%edx
  73df90:	4c 89 f7             	mov    %r14,%rdi
  73df93:	ff 15 c7 40 3c 00    	call   *0x3c40c7(%rip)        # b02060 <_DYNAMIC+0x248>
  73df99:	48 c7 03 01 00 00 00 	movq   $0x1,(%rbx)
  73dfa0:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  73dfa5:	48 89 43 08          	mov    %rax,0x8(%rbx)
  73dfa9:	4c 89 ff             	mov    %r15,%rdi
  73dfac:	e8 8f 44 39 00       	call   ad2440 <_Unwind_Resume@plt>
  73dfb1:	ff 15 f9 40 3c 00    	call   *0x3c40f9(%rip)        # b020b0 <_DYNAMIC+0x298>
  73dfb7:	49 89 c7             	mov    %rax,%r15
  73dfba:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  73dfbf:	e8 fc 23 00 00       	call   7403c0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  73dfc4:	4c 89 ff             	mov    %r15,%rdi
  73dfc7:	e8 74 44 39 00       	call   ad2440 <_Unwind_Resume@plt>
  73dfcc:	64 49 ff 04 24       	incq   %fs:(%r12)
  73dfd1:	48 89 c7             	mov    %rax,%rdi
  73dfd4:	e8 67 44 39 00       	call   ad2440 <_Unwind_Resume@plt>
