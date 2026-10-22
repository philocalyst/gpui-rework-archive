
/tmp/gpui-contained-owner-spike-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

000000000074d370 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>>:
  74d370:	55                   	push   %rbp
  74d371:	41 57                	push   %r15
  74d373:	41 56                	push   %r14
  74d375:	41 55                	push   %r13
  74d377:	41 54                	push   %r12
  74d379:	53                   	push   %rbx
  74d37a:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  74d381:	48 89 f3             	mov    %rsi,%rbx
  74d384:	49 89 ff             	mov    %rdi,%r15
  74d387:	49 c7 c4 68 f3 ff ff 	mov    $0xfffffffffffff368,%r12
  74d38e:	64 4c 8b 34 25 00 00 	mov    %fs:0x0,%r14
  74d395:	00 00 
  74d397:	4d 01 e6             	add    %r12,%r14
  74d39a:	64 41 80 bc 24 10 0c 	cmpb   $0x0,%fs:0xc10(%r12)
  74d3a1:	00 00 00 
  74d3a4:	0f 84 b9 04 00 00    	je     74d863 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x4f3>
  74d3aa:	64 49 83 3c 24 00    	cmpq   $0x0,%fs:(%r12)
  74d3b0:	0f 85 d3 04 00 00    	jne    74d889 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x519>
  74d3b6:	64 49 c7 04 24 ff ff 	movq   $0xffffffffffffffff,%fs:(%r12)
  74d3bd:	ff ff 
  74d3bf:	64 41 8b 84 24 08 0c 	mov    %fs:0xc08(%r12),%eax
  74d3c6:	00 00 
  74d3c8:	ff c0                	inc    %eax
  74d3ca:	64 41 89 84 24 08 0c 	mov    %eax,%fs:0xc08(%r12)
  74d3d1:	00 00 
  74d3d3:	83 f8 40             	cmp    $0x40,%eax
  74d3d6:	0f 83 ba 04 00 00    	jae    74d896 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x526>
  74d3dc:	89 c0                	mov    %eax,%eax
  74d3de:	48 8d 04 40          	lea    (%rax,%rax,2),%rax
  74d3e2:	48 c1 e0 04          	shl    $0x4,%rax
  74d3e6:	0f 57 c0             	xorps  %xmm0,%xmm0
  74d3e9:	41 0f 11 44 06 28    	movups %xmm0,0x28(%r14,%rax,1)
  74d3ef:	41 0f 11 44 06 18    	movups %xmm0,0x18(%r14,%rax,1)
  74d3f5:	41 0f 11 44 06 08    	movups %xmm0,0x8(%r14,%rax,1)
  74d3fb:	64 49 c7 04 24 00 00 	movq   $0x0,%fs:(%r12)
  74d402:	00 00 
  74d404:	48 b8 80 02 00 00 e0 	movabs $0x1e000000280,%rax
  74d40b:	01 00 00 
  74d40e:	48 89 44 24 20       	mov    %rax,0x20(%rsp)
  74d413:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%rsp)
  74d41a:	00 
  74d41b:	c7 44 24 18 00 00 4b 	movl   $0x434b0000,0x18(%rsp)
  74d422:	43 
  74d423:	66 c7 44 24 1c 00 00 	movw   $0x0,0x1c(%rsp)
  74d42a:	48 8d 7c 24 60       	lea    0x60(%rsp),%rdi
  74d42f:	48 8d 54 24 10       	lea    0x10(%rsp),%rdx
  74d434:	f3 0f 10 05 7c c2 90 	movss  -0x6f3d84(%rip),%xmm0        # 596b8 <anon.079f5e587c394fcac2765eb4d0cf0bc2.312.llvm.6319143315422321905+0x38>
  74d43b:	ff 
  74d43c:	31 f6                	xor    %esi,%esi
  74d43e:	b9 01 00 00 00       	mov    $0x1,%ecx
  74d443:	45 31 c0             	xor    %r8d,%r8d
  74d446:	e8 b5 e5 fb ff       	call   70ba00 <<gpui::runtime::Win<unit_action_cost_two::Model>>::mount_lanes>
  74d44b:	83 7c 24 60 fe       	cmpl   $0xfffffffe,0x60(%rsp)
  74d450:	0f 85 5b 04 00 00    	jne    74d8b1 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x541>
  74d456:	48 8b 44 24 68       	mov    0x68(%rsp),%rax
  74d45b:	48 83 3b 00          	cmpq   $0x0,(%rbx)
  74d45f:	0f 84 cf 03 00 00    	je     74d834 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x4c4>
  74d465:	4c 8b 73 08          	mov    0x8(%rbx),%r14
  74d469:	4d 85 f6             	test   %r14,%r14
  74d46c:	0f 84 c2 03 00 00    	je     74d834 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x4c4>
  74d472:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  74d477:	4d 8d a6 40 02 00 00 	lea    0x240(%r14),%r12
  74d47e:	4c 89 e7             	mov    %r12,%rdi
  74d481:	e8 fa 67 ff ff       	call   743c80 <<alloc::vec::Vec<alloc::boxed::Box<dyn gpui::source::ComponentSchema<unit_action_cost_two::SecondModel>>> as core::ops::drop::Drop>::drop>
  74d486:	49 8b 34 24          	mov    (%r12),%rsi
  74d48a:	48 85 f6             	test   %rsi,%rsi
  74d48d:	74 16                	je     74d4a5 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x135>
  74d48f:	49 8b be 48 02 00 00 	mov    0x248(%r14),%rdi
  74d496:	48 c1 e6 04          	shl    $0x4,%rsi
  74d49a:	ba 08 00 00 00       	mov    $0x8,%edx
  74d49f:	ff 15 13 bf 3d 00    	call   *0x3dbf13(%rip)        # b293b8 <_DYNAMIC+0x248>
  74d4a5:	49 8b b6 58 02 00 00 	mov    0x258(%r14),%rsi
  74d4ac:	48 85 f6             	test   %rsi,%rsi
  74d4af:	74 16                	je     74d4c7 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x157>
  74d4b1:	49 8b be 60 02 00 00 	mov    0x260(%r14),%rdi
  74d4b8:	48 c1 e6 03          	shl    $0x3,%rsi
  74d4bc:	ba 08 00 00 00       	mov    $0x8,%edx
  74d4c1:	ff 15 f1 be 3d 00    	call   *0x3dbef1(%rip)        # b293b8 <_DYNAMIC+0x248>
  74d4c7:	4d 8d a6 70 02 00 00 	lea    0x270(%r14),%r12
  74d4ce:	4c 89 e7             	mov    %r12,%rdi
  74d4d1:	e8 aa 67 ff ff       	call   743c80 <<alloc::vec::Vec<alloc::boxed::Box<dyn gpui::source::ComponentSchema<unit_action_cost_two::SecondModel>>> as core::ops::drop::Drop>::drop>
  74d4d6:	49 8b 34 24          	mov    (%r12),%rsi
  74d4da:	48 85 f6             	test   %rsi,%rsi
  74d4dd:	74 16                	je     74d4f5 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x185>
  74d4df:	49 8b be 78 02 00 00 	mov    0x278(%r14),%rdi
  74d4e6:	48 c1 e6 04          	shl    $0x4,%rsi
  74d4ea:	ba 08 00 00 00       	mov    $0x8,%edx
  74d4ef:	ff 15 c3 be 3d 00    	call   *0x3dbec3(%rip)        # b293b8 <_DYNAMIC+0x248>
  74d4f5:	4d 8d a6 90 02 00 00 	lea    0x290(%r14),%r12
  74d4fc:	4c 89 e7             	mov    %r12,%rdi
  74d4ff:	e8 9c 6a ff ff       	call   743fa0 <<alloc::vec::Vec<gpui::runtime::Node> as core::ops::drop::Drop>::drop>
  74d504:	49 8b 04 24          	mov    (%r12),%rax
  74d508:	48 85 c0             	test   %rax,%rax
  74d50b:	74 1a                	je     74d527 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x1b7>
  74d50d:	49 8b be 98 02 00 00 	mov    0x298(%r14),%rdi
  74d514:	48 c1 e0 03          	shl    $0x3,%rax
  74d518:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  74d51c:	ba 08 00 00 00       	mov    $0x8,%edx
  74d521:	ff 15 91 be 3d 00    	call   *0x3dbe91(%rip)        # b293b8 <_DYNAMIC+0x248>
  74d527:	49 8d be 00 02 00 00 	lea    0x200(%r14),%rdi
  74d52e:	e8 bd 37 00 00       	call   750cf0 <core::ptr::drop_glue::<gpui::runtime::styles::Styles>>
  74d533:	4d 8d a6 a8 02 00 00 	lea    0x2a8(%r14),%r12
  74d53a:	4c 89 e7             	mov    %r12,%rdi
  74d53d:	e8 ce 68 ff ff       	call   743e10 <<alloc::vec::Vec<core::option::Option<gpui::runtime::TextSite>> as core::ops::drop::Drop>::drop>
  74d542:	49 8b 04 24          	mov    (%r12),%rax
  74d546:	48 85 c0             	test   %rax,%rax
  74d549:	74 1a                	je     74d565 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x1f5>
  74d54b:	49 8b be b0 02 00 00 	mov    0x2b0(%r14),%rdi
  74d552:	48 c1 e0 04          	shl    $0x4,%rax
  74d556:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  74d55a:	ba 08 00 00 00       	mov    $0x8,%edx
  74d55f:	ff 15 53 be 3d 00    	call   *0x3dbe53(%rip)        # b293b8 <_DYNAMIC+0x248>
  74d565:	49 8b be c0 05 00 00 	mov    0x5c0(%r14),%rdi
  74d56c:	e8 af 1c 00 00       	call   74f220 <core::ptr::drop_glue::<core::option::Option<alloc::boxed::Box<gpui::runtime::image::Images>>>>
  74d571:	49 8b 86 e8 01 00 00 	mov    0x1e8(%r14),%rax
  74d578:	48 85 c0             	test   %rax,%rax
  74d57b:	74 49                	je     74d5c6 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x256>
  74d57d:	83 f8 01             	cmp    $0x1,%eax
  74d580:	75 1e                	jne    74d5a0 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x230>
  74d582:	49 8b b6 f8 01 00 00 	mov    0x1f8(%r14),%rsi
  74d589:	48 85 f6             	test   %rsi,%rsi
  74d58c:	74 38                	je     74d5c6 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x256>
  74d58e:	49 8b be f0 01 00 00 	mov    0x1f0(%r14),%rdi
  74d595:	48 c1 e6 04          	shl    $0x4,%rsi
  74d599:	ba 08 00 00 00       	mov    $0x8,%edx
  74d59e:	eb 20                	jmp    74d5c0 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x250>
  74d5a0:	49 8b 86 f8 01 00 00 	mov    0x1f8(%r14),%rax
  74d5a7:	48 85 c0             	test   %rax,%rax
  74d5aa:	74 1a                	je     74d5c6 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x256>
  74d5ac:	49 8b be f0 01 00 00 	mov    0x1f0(%r14),%rdi
  74d5b3:	48 c1 e0 02          	shl    $0x2,%rax
  74d5b7:	48 8d 34 40          	lea    (%rax,%rax,2),%rsi
  74d5bb:	ba 04 00 00 00       	mov    $0x4,%edx
  74d5c0:	ff 15 f2 bd 3d 00    	call   *0x3dbdf2(%rip)        # b293b8 <_DYNAMIC+0x248>
  74d5c6:	49 8b 8e c8 05 00 00 	mov    0x5c8(%r14),%rcx
  74d5cd:	48 85 c9             	test   %rcx,%rcx
  74d5d0:	74 3b                	je     74d60d <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x29d>
  74d5d2:	49 8b 96 d0 05 00 00 	mov    0x5d0(%r14),%rdx
  74d5d9:	49 8b 86 d8 05 00 00 	mov    0x5d8(%r14),%rax
  74d5e0:	48 c7 44 24 18 00 00 	movq   $0x0,0x18(%rsp)
  74d5e7:	00 00 
  74d5e9:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  74d5ee:	48 89 54 24 28       	mov    %rdx,0x28(%rsp)
  74d5f3:	48 c7 44 24 38 00 00 	movq   $0x0,0x38(%rsp)
  74d5fa:	00 00 
  74d5fc:	48 89 4c 24 40       	mov    %rcx,0x40(%rsp)
  74d601:	48 89 54 24 48       	mov    %rdx,0x48(%rsp)
  74d606:	b9 01 00 00 00       	mov    $0x1,%ecx
  74d60b:	eb 04                	jmp    74d611 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x2a1>
  74d60d:	31 c9                	xor    %ecx,%ecx
  74d60f:	31 c0                	xor    %eax,%eax
  74d611:	48 89 4c 24 10       	mov    %rcx,0x10(%rsp)
  74d616:	48 89 4c 24 30       	mov    %rcx,0x30(%rsp)
  74d61b:	48 89 44 24 50       	mov    %rax,0x50(%rsp)
  74d620:	48 8d 7c 24 60       	lea    0x60(%rsp),%rdi
  74d625:	48 8d 74 24 10       	lea    0x10(%rsp),%rsi
  74d62a:	e8 e1 8b ff ff       	call   746210 <<alloc::collections::btree::map::IntoIter<gpui::source::FieldId, gpui::runtime::Fanout>>::dying_next>
  74d62f:	48 8b 44 24 60       	mov    0x60(%rsp),%rax
  74d634:	48 85 c0             	test   %rax,%rax
  74d637:	74 56                	je     74d68f <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x31f>
  74d639:	4c 8d 64 24 60       	lea    0x60(%rsp),%r12
  74d63e:	4c 8d 6c 24 10       	lea    0x10(%rsp),%r13
  74d643:	48 8b 2d 6e bd 3d 00 	mov    0x3dbd6e(%rip),%rbp        # b293b8 <_DYNAMIC+0x248>
  74d64a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  74d650:	48 8b 4c 24 70       	mov    0x70(%rsp),%rcx
  74d655:	48 c1 e1 05          	shl    $0x5,%rcx
  74d659:	48 8b 34 08          	mov    (%rax,%rcx,1),%rsi
  74d65d:	48 83 fe ff          	cmp    $0xffffffffffffffff,%rsi
  74d661:	74 17                	je     74d67a <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x30a>
  74d663:	48 85 f6             	test   %rsi,%rsi
  74d666:	74 12                	je     74d67a <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x30a>
  74d668:	48 01 c8             	add    %rcx,%rax
  74d66b:	48 8b 78 08          	mov    0x8(%rax),%rdi
  74d66f:	48 c1 e6 02          	shl    $0x2,%rsi
  74d673:	ba 04 00 00 00       	mov    $0x4,%edx
  74d678:	ff d5                	call   *%rbp
  74d67a:	4c 89 e7             	mov    %r12,%rdi
  74d67d:	4c 89 ee             	mov    %r13,%rsi
  74d680:	e8 8b 8b ff ff       	call   746210 <<alloc::collections::btree::map::IntoIter<gpui::source::FieldId, gpui::runtime::Fanout>>::dying_next>
  74d685:	48 8b 44 24 60       	mov    0x60(%rsp),%rax
  74d68a:	48 85 c0             	test   %rax,%rax
  74d68d:	75 c1                	jne    74d650 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x2e0>
  74d68f:	49 8d be f8 05 00 00 	lea    0x5f8(%r14),%rdi
  74d696:	e8 95 ba ff ff       	call   749130 <<alloc::collections::btree::map::BTreeMap<u64, gpui::property::Overlay<gpui::style::Style>> as core::ops::drop::Drop>::drop>
  74d69b:	49 8b be 10 06 00 00 	mov    0x610(%r14),%rdi
  74d6a2:	e8 19 1f 00 00       	call   74f5c0 <core::ptr::drop_glue::<core::option::Option<alloc::boxed::Box<gpui::runtime::metadata::Metadata>>>>
  74d6a7:	49 8d be 18 06 00 00 	lea    0x618(%r14),%rdi
  74d6ae:	e8 ad aa ff ff       	call   748160 <<alloc::collections::btree::map::BTreeMap<gpui::runtime::scroll::ViewportKey, gpui::runtime::scroll::ViewportState> as core::ops::drop::Drop>::drop>
  74d6b3:	49 8d be 30 06 00 00 	lea    0x630(%r14),%rdi
  74d6ba:	e8 11 ae ff ff       	call   7484d0 <<alloc::collections::btree::map::BTreeMap<(core::option::Option<u64>, gpui::list::ListId, gpui::element::NodeKind), usize> as core::ops::drop::Drop>::drop>
  74d6bf:	49 8d be c0 02 00 00 	lea    0x2c0(%r14),%rdi
  74d6c6:	e8 45 2a 00 00       	call   750110 <core::ptr::drop_glue::<gpui_reactivity_core::layout::LayoutTree>>
  74d6cb:	49 8b b6 58 05 00 00 	mov    0x558(%r14),%rsi
  74d6d2:	48 85 f6             	test   %rsi,%rsi
  74d6d5:	74 16                	je     74d6ed <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x37d>
  74d6d7:	49 8b be 60 05 00 00 	mov    0x560(%r14),%rdi
  74d6de:	48 c1 e6 04          	shl    $0x4,%rsi
  74d6e2:	ba 08 00 00 00       	mov    $0x8,%edx
  74d6e7:	ff 15 cb bc 3d 00    	call   *0x3dbccb(%rip)        # b293b8 <_DYNAMIC+0x248>
  74d6ed:	49 8d be 48 06 00 00 	lea    0x648(%r14),%rdi
  74d6f4:	e8 e7 9e ff ff       	call   7475e0 <<alloc::collections::btree::map::BTreeMap<gpui::list::ListId, alloc::collections::btree::set_val::SetValZST> as core::ops::drop::Drop>::drop>
  74d6f9:	49 8b 86 88 05 00 00 	mov    0x588(%r14),%rax
  74d700:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  74d704:	0f 84 7e 00 00 00    	je     74d788 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x418>
  74d70a:	4d 8b a6 98 05 00 00 	mov    0x598(%r14),%r12
  74d711:	4d 85 e4             	test   %r12,%r12
  74d714:	74 53                	je     74d769 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x3f9>
  74d716:	4d 8b ae 90 05 00 00 	mov    0x590(%r14),%r13
  74d71d:	49 83 c5 78          	add    $0x78,%r13
  74d721:	48 8b 2d c8 bc 3d 00 	mov    0x3dbcc8(%rip),%rbp        # b293f0 <_DYNAMIC+0x280>
  74d728:	eb 0f                	jmp    74d739 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x3c9>
  74d72a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  74d730:	49 83 c5 50          	add    $0x50,%r13
  74d734:	49 ff cc             	dec    %r12
  74d737:	74 29                	je     74d762 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x3f2>
  74d739:	49 8b 7d b0          	mov    -0x50(%r13),%rdi
  74d73d:	48 85 ff             	test   %rdi,%rdi
  74d740:	74 ee                	je     74d730 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x3c0>
  74d742:	f6 07 01             	testb  $0x1,(%rdi)
  74d745:	75 e9                	jne    74d730 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x3c0>
  74d747:	48 8b 47 08          	mov    0x8(%rdi),%rax
  74d74b:	a8 01                	test   $0x1,%al
  74d74d:	75 e1                	jne    74d730 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x3c0>
  74d74f:	48 8d 47 08          	lea    0x8(%rdi),%rax
  74d753:	f0 48 83 28 02       	lock subq $0x2,(%rax)
  74d758:	75 d6                	jne    74d730 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x3c0>
  74d75a:	48 8b 47 08          	mov    0x8(%rdi),%rax
  74d75e:	ff d5                	call   *%rbp
  74d760:	eb ce                	jmp    74d730 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x3c0>
  74d762:	49 8b 86 88 05 00 00 	mov    0x588(%r14),%rax
  74d769:	48 85 c0             	test   %rax,%rax
  74d76c:	74 1a                	je     74d788 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x418>
  74d76e:	49 8b be 90 05 00 00 	mov    0x590(%r14),%rdi
  74d775:	48 c1 e0 04          	shl    $0x4,%rax
  74d779:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  74d77d:	ba 08 00 00 00       	mov    $0x8,%edx
  74d782:	ff 15 30 bc 3d 00    	call   *0x3dbc30(%rip)        # b293b8 <_DYNAMIC+0x248>
  74d788:	4d 8b a6 80 05 00 00 	mov    0x580(%r14),%r12
  74d78f:	4d 85 e4             	test   %r12,%r12
  74d792:	74 4e                	je     74d7e2 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x472>
  74d794:	4d 8b ae 78 05 00 00 	mov    0x578(%r14),%r13
  74d79b:	49 83 c5 78          	add    $0x78,%r13
  74d79f:	48 8b 2d 4a bc 3d 00 	mov    0x3dbc4a(%rip),%rbp        # b293f0 <_DYNAMIC+0x280>
  74d7a6:	eb 11                	jmp    74d7b9 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x449>
  74d7a8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  74d7af:	00 
  74d7b0:	49 83 c5 50          	add    $0x50,%r13
  74d7b4:	49 ff cc             	dec    %r12
  74d7b7:	74 29                	je     74d7e2 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x472>
  74d7b9:	49 8b 7d b0          	mov    -0x50(%r13),%rdi
  74d7bd:	48 85 ff             	test   %rdi,%rdi
  74d7c0:	74 ee                	je     74d7b0 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x440>
  74d7c2:	f6 07 01             	testb  $0x1,(%rdi)
  74d7c5:	75 e9                	jne    74d7b0 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x440>
  74d7c7:	48 8b 47 08          	mov    0x8(%rdi),%rax
  74d7cb:	a8 01                	test   $0x1,%al
  74d7cd:	75 e1                	jne    74d7b0 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x440>
  74d7cf:	48 8d 47 08          	lea    0x8(%rdi),%rax
  74d7d3:	f0 48 83 28 02       	lock subq $0x2,(%rax)
  74d7d8:	75 d6                	jne    74d7b0 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x440>
  74d7da:	48 8b 47 08          	mov    0x8(%rdi),%rax
  74d7de:	ff d5                	call   *%rbp
  74d7e0:	eb ce                	jmp    74d7b0 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x440>
  74d7e2:	49 8b 86 70 05 00 00 	mov    0x570(%r14),%rax
  74d7e9:	48 85 c0             	test   %rax,%rax
  74d7ec:	74 1a                	je     74d808 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x498>
  74d7ee:	49 8b be 78 05 00 00 	mov    0x578(%r14),%rdi
  74d7f5:	48 c1 e0 04          	shl    $0x4,%rax
  74d7f9:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  74d7fd:	ba 08 00 00 00       	mov    $0x8,%edx
  74d802:	ff 15 b0 bb 3d 00    	call   *0x3dbbb0(%rip)        # b293b8 <_DYNAMIC+0x248>
  74d808:	4c 89 f7             	mov    %r14,%rdi
  74d80b:	e8 b0 2e 00 00       	call   7506c0 <core::ptr::drop_glue::<gpui_canvas::canvas::Canvas>>
  74d810:	49 8b be 98 06 00 00 	mov    0x698(%r14),%rdi
  74d817:	e8 c4 17 00 00       	call   74efe0 <core::ptr::drop_glue::<core::option::Option<alloc::boxed::Box<gpui::runtime::text_geometry::TextResources>>>>
  74d81c:	be 28 07 00 00       	mov    $0x728,%esi
  74d821:	ba 08 00 00 00       	mov    $0x8,%edx
  74d826:	4c 89 f7             	mov    %r14,%rdi
  74d829:	ff 15 89 bb 3d 00    	call   *0x3dbb89(%rip)        # b293b8 <_DYNAMIC+0x248>
  74d82f:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  74d834:	48 c7 03 01 00 00 00 	movq   $0x1,(%rbx)
  74d83b:	48 89 43 08          	mov    %rax,0x8(%rbx)
  74d83f:	48 8d 35 6a e4 3a 00 	lea    0x3ae46a(%rip),%rsi        # afbcb0 <anon.2d1f820267f84878e0cbda50021465a1.0.llvm.17676285964678017166>
  74d846:	4c 89 ff             	mov    %r15,%rdi
  74d849:	e8 b2 fa 01 00       	call   76d300 <<std::thread::local::LocalKey<core::cell::RefCell<allocation_counter::allocator::AllocationInfoStack>>>::with::<allocation_counter::measure<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>::{closure#1}, allocation_counter::AllocationInfo>>
  74d84e:	4c 89 f8             	mov    %r15,%rax
  74d851:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  74d858:	5b                   	pop    %rbx
  74d859:	41 5c                	pop    %r12
  74d85b:	41 5d                	pop    %r13
  74d85d:	41 5e                	pop    %r14
  74d85f:	41 5f                	pop    %r15
  74d861:	5d                   	pop    %rbp
  74d862:	c3                   	ret
  74d863:	ba 0c 0c 00 00       	mov    $0xc0c,%edx
  74d868:	4c 89 f7             	mov    %r14,%rdi
  74d86b:	31 f6                	xor    %esi,%esi
  74d86d:	ff 15 ad c0 3d 00    	call   *0x3dc0ad(%rip)        # b29920 <memset@GLIBC_2.2.5>
  74d873:	64 41 c6 84 24 10 0c 	movb   $0x1,%fs:0xc10(%r12)
  74d87a:	00 00 01 
  74d87d:	64 49 83 3c 24 00    	cmpq   $0x0,%fs:(%r12)
  74d883:	0f 84 2d fb ff ff    	je     74d3b6 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x46>
  74d889:	48 8d 3d 28 f1 3a 00 	lea    0x3af128(%rip),%rdi        # afc9b8 <anon.547532fe00eaf98ca33efb65e1aed586.15.llvm.9042944481482549913>
  74d890:	ff 15 92 c0 3d 00    	call   *0x3dc092(%rip)        # b29928 <_DYNAMIC+0x7b8>
  74d896:	48 8d 3d e3 e5 91 ff 	lea    -0x6e1a1d(%rip),%rdi        # 6be80 <anon.547532fe00eaf98ca33efb65e1aed586.12.llvm.9042944481482549913>
  74d89d:	48 8d 15 fc f0 3a 00 	lea    0x3af0fc(%rip),%rdx        # afc9a0 <anon.547532fe00eaf98ca33efb65e1aed586.14.llvm.9042944481482549913>
  74d8a4:	be 4b 00 00 00       	mov    $0x4b,%esi
  74d8a9:	ff 15 09 bd 3d 00    	call   *0x3dbd09(%rip)        # b295b8 <_DYNAMIC+0x448>
  74d8af:	eb 53                	jmp    74d904 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x594>
  74d8b1:	48 8b 84 24 90 00 00 	mov    0x90(%rsp),%rax
  74d8b8:	00 
  74d8b9:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
  74d8be:	0f 10 44 24 60       	movups 0x60(%rsp),%xmm0
  74d8c3:	0f 10 4c 24 70       	movups 0x70(%rsp),%xmm1
  74d8c8:	0f 10 94 24 80 00 00 	movups 0x80(%rsp),%xmm2
  74d8cf:	00 
  74d8d0:	0f 29 54 24 30       	movaps %xmm2,0x30(%rsp)
  74d8d5:	0f 29 4c 24 20       	movaps %xmm1,0x20(%rsp)
  74d8da:	0f 29 44 24 10       	movaps %xmm0,0x10(%rsp)
  74d8df:	48 8d 3d 7e d6 91 ff 	lea    -0x6e2982(%rip),%rdi        # 6af64 <anon.2d1f820267f84878e0cbda50021465a1.8.llvm.17676285964678017166>
  74d8e6:	48 8d 0d 2b e4 3a 00 	lea    0x3ae42b(%rip),%rcx        # afbd18 <anon.2d1f820267f84878e0cbda50021465a1.7.llvm.17676285964678017166>
  74d8ed:	4c 8d 05 c4 e3 3a 00 	lea    0x3ae3c4(%rip),%r8        # afbcb8 <anon.2d1f820267f84878e0cbda50021465a1.0.llvm.17676285964678017166+0x8>
  74d8f4:	48 8d 54 24 10       	lea    0x10(%rsp),%rdx
  74d8f9:	be 2b 00 00 00       	mov    $0x2b,%esi
  74d8fe:	ff 15 bc bb 3d 00    	call   *0x3dbbbc(%rip)        # b294c0 <_DYNAMIC+0x350>
  74d904:	0f 0b                	ud2
  74d906:	49 89 c7             	mov    %rax,%r15
  74d909:	49 ff cc             	dec    %r12
  74d90c:	74 0f                	je     74d91d <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x5ad>
  74d90e:	49 8b 7d 00          	mov    0x0(%r13),%rdi
  74d912:	49 83 c5 50          	add    $0x50,%r13
  74d916:	e8 d5 44 ff ff       	call   741df0 <core::ptr::drop_glue::<core::option::Option<gpui::shared_text::SharedText>>>
  74d91b:	eb ec                	jmp    74d909 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x599>
  74d91d:	49 8b 86 88 05 00 00 	mov    0x588(%r14),%rax
  74d924:	48 85 c0             	test   %rax,%rax
  74d927:	0f 84 59 02 00 00    	je     74db86 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x816>
  74d92d:	49 8b be 90 05 00 00 	mov    0x590(%r14),%rdi
  74d934:	48 c1 e0 04          	shl    $0x4,%rax
  74d938:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  74d93c:	ba 08 00 00 00       	mov    $0x8,%edx
  74d941:	ff 15 71 ba 3d 00    	call   *0x3dba71(%rip)        # b293b8 <_DYNAMIC+0x248>
  74d947:	e9 3a 02 00 00       	jmp    74db86 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x816>
  74d94c:	ff 15 96 ba 3d 00    	call   *0x3dba96(%rip)        # b293e8 <_DYNAMIC+0x278>
  74d952:	49 89 c7             	mov    %rax,%r15
  74d955:	49 ff cc             	dec    %r12
  74d958:	74 0f                	je     74d969 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x5f9>
  74d95a:	49 8b 7d 00          	mov    0x0(%r13),%rdi
  74d95e:	49 83 c5 50          	add    $0x50,%r13
  74d962:	e8 89 44 ff ff       	call   741df0 <core::ptr::drop_glue::<core::option::Option<gpui::shared_text::SharedText>>>
  74d967:	eb ec                	jmp    74d955 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x5e5>
  74d969:	49 8b 86 70 05 00 00 	mov    0x570(%r14),%rax
  74d970:	48 85 c0             	test   %rax,%rax
  74d973:	0f 84 19 02 00 00    	je     74db92 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x822>
  74d979:	49 8b be 78 05 00 00 	mov    0x578(%r14),%rdi
  74d980:	48 c1 e0 04          	shl    $0x4,%rax
  74d984:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  74d988:	ba 08 00 00 00       	mov    $0x8,%edx
  74d98d:	ff 15 25 ba 3d 00    	call   *0x3dba25(%rip)        # b293b8 <_DYNAMIC+0x248>
  74d993:	e9 fa 01 00 00       	jmp    74db92 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x822>
  74d998:	ff 15 4a ba 3d 00    	call   *0x3dba4a(%rip)        # b293e8 <_DYNAMIC+0x278>
  74d99e:	49 89 c7             	mov    %rax,%r15
  74d9a1:	e9 00 02 00 00       	jmp    74dba6 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x836>
  74d9a6:	49 89 c7             	mov    %rax,%r15
  74d9a9:	e9 ec 01 00 00       	jmp    74db9a <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x82a>
  74d9ae:	49 89 c7             	mov    %rax,%r15
  74d9b1:	e9 c4 01 00 00       	jmp    74db7a <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x80a>
  74d9b6:	49 89 c7             	mov    %rax,%r15
  74d9b9:	e9 8e 01 00 00       	jmp    74db4c <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x7dc>
  74d9be:	49 89 c7             	mov    %rax,%r15
  74d9c1:	e9 7a 01 00 00       	jmp    74db40 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x7d0>
  74d9c6:	49 89 c7             	mov    %rax,%r15
  74d9c9:	e9 66 01 00 00       	jmp    74db34 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x7c4>
  74d9ce:	49 89 c7             	mov    %rax,%r15
  74d9d1:	e9 52 01 00 00       	jmp    74db28 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x7b8>
  74d9d6:	49 89 c7             	mov    %rax,%r15
  74d9d9:	e9 3e 01 00 00       	jmp    74db1c <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x7ac>
  74d9de:	e9 2a 01 00 00       	jmp    74db0d <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x79d>
  74d9e3:	49 89 c7             	mov    %rax,%r15
  74d9e6:	e9 02 01 00 00       	jmp    74daed <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x77d>
  74d9eb:	49 89 c7             	mov    %rax,%r15
  74d9ee:	49 8b 04 24          	mov    (%r12),%rax
  74d9f2:	48 85 c0             	test   %rax,%rax
  74d9f5:	0f 84 e6 00 00 00    	je     74dae1 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x771>
  74d9fb:	49 8b be b0 02 00 00 	mov    0x2b0(%r14),%rdi
  74da02:	48 c1 e0 04          	shl    $0x4,%rax
  74da06:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  74da0a:	ba 08 00 00 00       	mov    $0x8,%edx
  74da0f:	ff 15 a3 b9 3d 00    	call   *0x3db9a3(%rip)        # b293b8 <_DYNAMIC+0x248>
  74da15:	e9 c7 00 00 00       	jmp    74dae1 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x771>
  74da1a:	49 89 c7             	mov    %rax,%r15
  74da1d:	49 8b 04 24          	mov    (%r12),%rax
  74da21:	48 85 c0             	test   %rax,%rax
  74da24:	0f 84 9f 00 00 00    	je     74dac9 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x759>
  74da2a:	49 8b be 98 02 00 00 	mov    0x298(%r14),%rdi
  74da31:	48 c1 e0 03          	shl    $0x3,%rax
  74da35:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  74da39:	ba 08 00 00 00       	mov    $0x8,%edx
  74da3e:	ff 15 74 b9 3d 00    	call   *0x3db974(%rip)        # b293b8 <_DYNAMIC+0x248>
  74da44:	e9 80 00 00 00       	jmp    74dac9 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x759>
  74da49:	49 89 c7             	mov    %rax,%r15
  74da4c:	49 8b 34 24          	mov    (%r12),%rsi
  74da50:	48 85 f6             	test   %rsi,%rsi
  74da53:	74 68                	je     74dabd <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x74d>
  74da55:	49 8b be 78 02 00 00 	mov    0x278(%r14),%rdi
  74da5c:	48 c1 e6 04          	shl    $0x4,%rsi
  74da60:	ba 08 00 00 00       	mov    $0x8,%edx
  74da65:	ff 15 4d b9 3d 00    	call   *0x3db94d(%rip)        # b293b8 <_DYNAMIC+0x248>
  74da6b:	eb 50                	jmp    74dabd <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x74d>
  74da6d:	49 89 c7             	mov    %rax,%r15
  74da70:	49 8b 34 24          	mov    (%r12),%rsi
  74da74:	48 85 f6             	test   %rsi,%rsi
  74da77:	74 16                	je     74da8f <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x71f>
  74da79:	49 8b be 48 02 00 00 	mov    0x248(%r14),%rdi
  74da80:	48 c1 e6 04          	shl    $0x4,%rsi
  74da84:	ba 08 00 00 00       	mov    $0x8,%edx
  74da89:	ff 15 29 b9 3d 00    	call   *0x3db929(%rip)        # b293b8 <_DYNAMIC+0x248>
  74da8f:	49 8b b6 58 02 00 00 	mov    0x258(%r14),%rsi
  74da96:	48 85 f6             	test   %rsi,%rsi
  74da99:	74 16                	je     74dab1 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x741>
  74da9b:	49 8b be 60 02 00 00 	mov    0x260(%r14),%rdi
  74daa2:	48 c1 e6 03          	shl    $0x3,%rsi
  74daa6:	ba 08 00 00 00       	mov    $0x8,%edx
  74daab:	ff 15 07 b9 3d 00    	call   *0x3db907(%rip)        # b293b8 <_DYNAMIC+0x248>
  74dab1:	49 8d be 70 02 00 00 	lea    0x270(%r14),%rdi
  74dab8:	e8 d3 1f 00 00       	call   74fa90 <core::ptr::drop_glue::<alloc::vec::Vec<alloc::boxed::Box<dyn gpui::source::ComponentSchema<unit_action_cost_two::Model>>>>>
  74dabd:	49 8d be 90 02 00 00 	lea    0x290(%r14),%rdi
  74dac4:	e8 b7 21 00 00       	call   74fc80 <core::ptr::drop_glue::<alloc::vec::Vec<gpui::runtime::Node>>>
  74dac9:	49 8d be 00 02 00 00 	lea    0x200(%r14),%rdi
  74dad0:	e8 1b 32 00 00       	call   750cf0 <core::ptr::drop_glue::<gpui::runtime::styles::Styles>>
  74dad5:	49 8d be a8 02 00 00 	lea    0x2a8(%r14),%rdi
  74dadc:	e8 df 1e 00 00       	call   74f9c0 <core::ptr::drop_glue::<alloc::vec::Vec<core::option::Option<gpui::runtime::TextSite>>>>
  74dae1:	49 8b be c0 05 00 00 	mov    0x5c0(%r14),%rdi
  74dae8:	e8 33 17 00 00       	call   74f220 <core::ptr::drop_glue::<core::option::Option<alloc::boxed::Box<gpui::runtime::image::Images>>>>
  74daed:	49 8d be e8 01 00 00 	lea    0x1e8(%r14),%rdi
  74daf4:	e8 f7 30 00 00       	call   750bf0 <core::ptr::drop_glue::<gpui::runtime::identity_index::IdentityIndex>>
  74daf9:	49 8d be c8 05 00 00 	lea    0x5c8(%r14),%rdi
  74db00:	e8 cb 9e ff ff       	call   7479d0 <<alloc::collections::btree::map::BTreeMap<gpui::source::FieldId, gpui::runtime::Fanout> as core::ops::drop::Drop>::drop>
  74db05:	eb 09                	jmp    74db10 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x7a0>
  74db07:	ff 15 db b8 3d 00    	call   *0x3db8db(%rip)        # b293e8 <_DYNAMIC+0x278>
  74db0d:	49 89 c7             	mov    %rax,%r15
  74db10:	49 8d be f8 05 00 00 	lea    0x5f8(%r14),%rdi
  74db17:	e8 14 b6 ff ff       	call   749130 <<alloc::collections::btree::map::BTreeMap<u64, gpui::property::Overlay<gpui::style::Style>> as core::ops::drop::Drop>::drop>
  74db1c:	49 8b be 10 06 00 00 	mov    0x610(%r14),%rdi
  74db23:	e8 98 1a 00 00       	call   74f5c0 <core::ptr::drop_glue::<core::option::Option<alloc::boxed::Box<gpui::runtime::metadata::Metadata>>>>
  74db28:	49 8d be 18 06 00 00 	lea    0x618(%r14),%rdi
  74db2f:	e8 2c a6 ff ff       	call   748160 <<alloc::collections::btree::map::BTreeMap<gpui::runtime::scroll::ViewportKey, gpui::runtime::scroll::ViewportState> as core::ops::drop::Drop>::drop>
  74db34:	49 8d be 30 06 00 00 	lea    0x630(%r14),%rdi
  74db3b:	e8 90 a9 ff ff       	call   7484d0 <<alloc::collections::btree::map::BTreeMap<(core::option::Option<u64>, gpui::list::ListId, gpui::element::NodeKind), usize> as core::ops::drop::Drop>::drop>
  74db40:	49 8d be c0 02 00 00 	lea    0x2c0(%r14),%rdi
  74db47:	e8 c4 25 00 00       	call   750110 <core::ptr::drop_glue::<gpui_reactivity_core::layout::LayoutTree>>
  74db4c:	49 8b b6 58 05 00 00 	mov    0x558(%r14),%rsi
  74db53:	48 85 f6             	test   %rsi,%rsi
  74db56:	74 16                	je     74db6e <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x7fe>
  74db58:	49 8b be 60 05 00 00 	mov    0x560(%r14),%rdi
  74db5f:	48 c1 e6 04          	shl    $0x4,%rsi
  74db63:	ba 08 00 00 00       	mov    $0x8,%edx
  74db68:	ff 15 4a b8 3d 00    	call   *0x3db84a(%rip)        # b293b8 <_DYNAMIC+0x248>
  74db6e:	49 8d be 48 06 00 00 	lea    0x648(%r14),%rdi
  74db75:	e8 66 9a ff ff       	call   7475e0 <<alloc::collections::btree::map::BTreeMap<gpui::list::ListId, alloc::collections::btree::set_val::SetValZST> as core::ops::drop::Drop>::drop>
  74db7a:	49 8d be 88 05 00 00 	lea    0x588(%r14),%rdi
  74db81:	e8 5a 1c 00 00       	call   74f7e0 <core::ptr::drop_glue::<core::option::Option<gpui::runtime::Prepared>>>
  74db86:	49 8d be 70 05 00 00 	lea    0x570(%r14),%rdi
  74db8d:	e8 5e 21 00 00       	call   74fcf0 <core::ptr::drop_glue::<alloc::vec::Vec<gpui::runtime::Presented>>>
  74db92:	4c 89 f7             	mov    %r14,%rdi
  74db95:	e8 26 2b 00 00       	call   7506c0 <core::ptr::drop_glue::<gpui_canvas::canvas::Canvas>>
  74db9a:	49 8b be 98 06 00 00 	mov    0x698(%r14),%rdi
  74dba1:	e8 3a 14 00 00       	call   74efe0 <core::ptr::drop_glue::<core::option::Option<alloc::boxed::Box<gpui::runtime::text_geometry::TextResources>>>>
  74dba6:	be 28 07 00 00       	mov    $0x728,%esi
  74dbab:	ba 08 00 00 00       	mov    $0x8,%edx
  74dbb0:	4c 89 f7             	mov    %r14,%rdi
  74dbb3:	ff 15 ff b7 3d 00    	call   *0x3db7ff(%rip)        # b293b8 <_DYNAMIC+0x248>
  74dbb9:	48 c7 03 01 00 00 00 	movq   $0x1,(%rbx)
  74dbc0:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  74dbc5:	48 89 43 08          	mov    %rax,0x8(%rbx)
  74dbc9:	4c 89 ff             	mov    %r15,%rdi
  74dbcc:	e8 7f b9 3a 00       	call   af9550 <_Unwind_Resume@plt>
  74dbd1:	ff 15 11 b8 3d 00    	call   *0x3db811(%rip)        # b293e8 <_DYNAMIC+0x278>
  74dbd7:	49 89 c7             	mov    %rax,%r15
  74dbda:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  74dbdf:	e8 6c 2e 00 00       	call   750a50 <core::ptr::drop_glue::<gpui::runtime::Error>>
  74dbe4:	4c 89 ff             	mov    %r15,%rdi
  74dbe7:	e8 64 b9 3a 00       	call   af9550 <_Unwind_Resume@plt>
  74dbec:	64 49 ff 04 24       	incq   %fs:(%r12)
  74dbf1:	48 89 c7             	mov    %rax,%rdi
  74dbf4:	e8 57 b9 3a 00       	call   af9550 <_Unwind_Resume@plt>
