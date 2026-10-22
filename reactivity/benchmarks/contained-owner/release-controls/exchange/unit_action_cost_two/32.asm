
/tmp/gpui-contained-property-exchange-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

000000000074d270 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>>:
  74d270:	55                   	push   %rbp
  74d271:	41 57                	push   %r15
  74d273:	41 56                	push   %r14
  74d275:	41 55                	push   %r13
  74d277:	41 54                	push   %r12
  74d279:	53                   	push   %rbx
  74d27a:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  74d281:	48 89 f3             	mov    %rsi,%rbx
  74d284:	49 89 ff             	mov    %rdi,%r15
  74d287:	49 c7 c4 68 f3 ff ff 	mov    $0xfffffffffffff368,%r12
  74d28e:	64 4c 8b 34 25 00 00 	mov    %fs:0x0,%r14
  74d295:	00 00 
  74d297:	4d 01 e6             	add    %r12,%r14
  74d29a:	64 41 80 bc 24 10 0c 	cmpb   $0x0,%fs:0xc10(%r12)
  74d2a1:	00 00 00 
  74d2a4:	0f 84 b9 04 00 00    	je     74d763 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x4f3>
  74d2aa:	64 49 83 3c 24 00    	cmpq   $0x0,%fs:(%r12)
  74d2b0:	0f 85 d3 04 00 00    	jne    74d789 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x519>
  74d2b6:	64 49 c7 04 24 ff ff 	movq   $0xffffffffffffffff,%fs:(%r12)
  74d2bd:	ff ff 
  74d2bf:	64 41 8b 84 24 08 0c 	mov    %fs:0xc08(%r12),%eax
  74d2c6:	00 00 
  74d2c8:	ff c0                	inc    %eax
  74d2ca:	64 41 89 84 24 08 0c 	mov    %eax,%fs:0xc08(%r12)
  74d2d1:	00 00 
  74d2d3:	83 f8 40             	cmp    $0x40,%eax
  74d2d6:	0f 83 ba 04 00 00    	jae    74d796 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x526>
  74d2dc:	89 c0                	mov    %eax,%eax
  74d2de:	48 8d 04 40          	lea    (%rax,%rax,2),%rax
  74d2e2:	48 c1 e0 04          	shl    $0x4,%rax
  74d2e6:	0f 57 c0             	xorps  %xmm0,%xmm0
  74d2e9:	41 0f 11 44 06 28    	movups %xmm0,0x28(%r14,%rax,1)
  74d2ef:	41 0f 11 44 06 18    	movups %xmm0,0x18(%r14,%rax,1)
  74d2f5:	41 0f 11 44 06 08    	movups %xmm0,0x8(%r14,%rax,1)
  74d2fb:	64 49 c7 04 24 00 00 	movq   $0x0,%fs:(%r12)
  74d302:	00 00 
  74d304:	48 b8 80 02 00 00 e0 	movabs $0x1e000000280,%rax
  74d30b:	01 00 00 
  74d30e:	48 89 44 24 20       	mov    %rax,0x20(%rsp)
  74d313:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%rsp)
  74d31a:	00 
  74d31b:	c7 44 24 18 00 00 4b 	movl   $0x434b0000,0x18(%rsp)
  74d322:	43 
  74d323:	66 c7 44 24 1c 00 00 	movw   $0x0,0x1c(%rsp)
  74d32a:	48 8d 7c 24 60       	lea    0x60(%rsp),%rdi
  74d32f:	48 8d 54 24 10       	lea    0x10(%rsp),%rdx
  74d334:	f3 0f 10 05 0c c3 90 	movss  -0x6f3cf4(%rip),%xmm0        # 59648 <anon.079f5e587c394fcac2765eb4d0cf0bc2.312.llvm.6319143315422321905+0x38>
  74d33b:	ff 
  74d33c:	31 f6                	xor    %esi,%esi
  74d33e:	b9 01 00 00 00       	mov    $0x1,%ecx
  74d343:	45 31 c0             	xor    %r8d,%r8d
  74d346:	e8 b5 e5 fb ff       	call   70b900 <<gpui::runtime::Win<unit_action_cost_two::Model>>::mount_lanes>
  74d34b:	83 7c 24 60 fe       	cmpl   $0xfffffffe,0x60(%rsp)
  74d350:	0f 85 5b 04 00 00    	jne    74d7b1 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x541>
  74d356:	48 8b 44 24 68       	mov    0x68(%rsp),%rax
  74d35b:	48 83 3b 00          	cmpq   $0x0,(%rbx)
  74d35f:	0f 84 cf 03 00 00    	je     74d734 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x4c4>
  74d365:	4c 8b 73 08          	mov    0x8(%rbx),%r14
  74d369:	4d 85 f6             	test   %r14,%r14
  74d36c:	0f 84 c2 03 00 00    	je     74d734 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x4c4>
  74d372:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  74d377:	4d 8d a6 40 02 00 00 	lea    0x240(%r14),%r12
  74d37e:	4c 89 e7             	mov    %r12,%rdi
  74d381:	e8 fa 67 ff ff       	call   743b80 <<alloc::vec::Vec<alloc::boxed::Box<dyn gpui::source::ComponentSchema<unit_action_cost_two::SecondModel>>> as core::ops::drop::Drop>::drop>
  74d386:	49 8b 34 24          	mov    (%r12),%rsi
  74d38a:	48 85 f6             	test   %rsi,%rsi
  74d38d:	74 16                	je     74d3a5 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x135>
  74d38f:	49 8b be 48 02 00 00 	mov    0x248(%r14),%rdi
  74d396:	48 c1 e6 04          	shl    $0x4,%rsi
  74d39a:	ba 08 00 00 00       	mov    $0x8,%edx
  74d39f:	ff 15 2b bf 3d 00    	call   *0x3dbf2b(%rip)        # b292d0 <_DYNAMIC+0x248>
  74d3a5:	49 8b b6 58 02 00 00 	mov    0x258(%r14),%rsi
  74d3ac:	48 85 f6             	test   %rsi,%rsi
  74d3af:	74 16                	je     74d3c7 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x157>
  74d3b1:	49 8b be 60 02 00 00 	mov    0x260(%r14),%rdi
  74d3b8:	48 c1 e6 03          	shl    $0x3,%rsi
  74d3bc:	ba 08 00 00 00       	mov    $0x8,%edx
  74d3c1:	ff 15 09 bf 3d 00    	call   *0x3dbf09(%rip)        # b292d0 <_DYNAMIC+0x248>
  74d3c7:	4d 8d a6 70 02 00 00 	lea    0x270(%r14),%r12
  74d3ce:	4c 89 e7             	mov    %r12,%rdi
  74d3d1:	e8 aa 67 ff ff       	call   743b80 <<alloc::vec::Vec<alloc::boxed::Box<dyn gpui::source::ComponentSchema<unit_action_cost_two::SecondModel>>> as core::ops::drop::Drop>::drop>
  74d3d6:	49 8b 34 24          	mov    (%r12),%rsi
  74d3da:	48 85 f6             	test   %rsi,%rsi
  74d3dd:	74 16                	je     74d3f5 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x185>
  74d3df:	49 8b be 78 02 00 00 	mov    0x278(%r14),%rdi
  74d3e6:	48 c1 e6 04          	shl    $0x4,%rsi
  74d3ea:	ba 08 00 00 00       	mov    $0x8,%edx
  74d3ef:	ff 15 db be 3d 00    	call   *0x3dbedb(%rip)        # b292d0 <_DYNAMIC+0x248>
  74d3f5:	4d 8d a6 90 02 00 00 	lea    0x290(%r14),%r12
  74d3fc:	4c 89 e7             	mov    %r12,%rdi
  74d3ff:	e8 9c 6a ff ff       	call   743ea0 <<alloc::vec::Vec<gpui::runtime::Node> as core::ops::drop::Drop>::drop>
  74d404:	49 8b 04 24          	mov    (%r12),%rax
  74d408:	48 85 c0             	test   %rax,%rax
  74d40b:	74 1a                	je     74d427 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x1b7>
  74d40d:	49 8b be 98 02 00 00 	mov    0x298(%r14),%rdi
  74d414:	48 c1 e0 03          	shl    $0x3,%rax
  74d418:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  74d41c:	ba 08 00 00 00       	mov    $0x8,%edx
  74d421:	ff 15 a9 be 3d 00    	call   *0x3dbea9(%rip)        # b292d0 <_DYNAMIC+0x248>
  74d427:	49 8d be 00 02 00 00 	lea    0x200(%r14),%rdi
  74d42e:	e8 bd 37 00 00       	call   750bf0 <core::ptr::drop_glue::<gpui::runtime::styles::Styles>>
  74d433:	4d 8d a6 a8 02 00 00 	lea    0x2a8(%r14),%r12
  74d43a:	4c 89 e7             	mov    %r12,%rdi
  74d43d:	e8 ce 68 ff ff       	call   743d10 <<alloc::vec::Vec<core::option::Option<gpui::runtime::TextSite>> as core::ops::drop::Drop>::drop>
  74d442:	49 8b 04 24          	mov    (%r12),%rax
  74d446:	48 85 c0             	test   %rax,%rax
  74d449:	74 1a                	je     74d465 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x1f5>
  74d44b:	49 8b be b0 02 00 00 	mov    0x2b0(%r14),%rdi
  74d452:	48 c1 e0 04          	shl    $0x4,%rax
  74d456:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  74d45a:	ba 08 00 00 00       	mov    $0x8,%edx
  74d45f:	ff 15 6b be 3d 00    	call   *0x3dbe6b(%rip)        # b292d0 <_DYNAMIC+0x248>
  74d465:	49 8b be c0 05 00 00 	mov    0x5c0(%r14),%rdi
  74d46c:	e8 af 1c 00 00       	call   74f120 <core::ptr::drop_glue::<core::option::Option<alloc::boxed::Box<gpui::runtime::image::Images>>>>
  74d471:	49 8b 86 e8 01 00 00 	mov    0x1e8(%r14),%rax
  74d478:	48 85 c0             	test   %rax,%rax
  74d47b:	74 49                	je     74d4c6 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x256>
  74d47d:	83 f8 01             	cmp    $0x1,%eax
  74d480:	75 1e                	jne    74d4a0 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x230>
  74d482:	49 8b b6 f8 01 00 00 	mov    0x1f8(%r14),%rsi
  74d489:	48 85 f6             	test   %rsi,%rsi
  74d48c:	74 38                	je     74d4c6 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x256>
  74d48e:	49 8b be f0 01 00 00 	mov    0x1f0(%r14),%rdi
  74d495:	48 c1 e6 04          	shl    $0x4,%rsi
  74d499:	ba 08 00 00 00       	mov    $0x8,%edx
  74d49e:	eb 20                	jmp    74d4c0 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x250>
  74d4a0:	49 8b 86 f8 01 00 00 	mov    0x1f8(%r14),%rax
  74d4a7:	48 85 c0             	test   %rax,%rax
  74d4aa:	74 1a                	je     74d4c6 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x256>
  74d4ac:	49 8b be f0 01 00 00 	mov    0x1f0(%r14),%rdi
  74d4b3:	48 c1 e0 02          	shl    $0x2,%rax
  74d4b7:	48 8d 34 40          	lea    (%rax,%rax,2),%rsi
  74d4bb:	ba 04 00 00 00       	mov    $0x4,%edx
  74d4c0:	ff 15 0a be 3d 00    	call   *0x3dbe0a(%rip)        # b292d0 <_DYNAMIC+0x248>
  74d4c6:	49 8b 8e c8 05 00 00 	mov    0x5c8(%r14),%rcx
  74d4cd:	48 85 c9             	test   %rcx,%rcx
  74d4d0:	74 3b                	je     74d50d <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x29d>
  74d4d2:	49 8b 96 d0 05 00 00 	mov    0x5d0(%r14),%rdx
  74d4d9:	49 8b 86 d8 05 00 00 	mov    0x5d8(%r14),%rax
  74d4e0:	48 c7 44 24 18 00 00 	movq   $0x0,0x18(%rsp)
  74d4e7:	00 00 
  74d4e9:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  74d4ee:	48 89 54 24 28       	mov    %rdx,0x28(%rsp)
  74d4f3:	48 c7 44 24 38 00 00 	movq   $0x0,0x38(%rsp)
  74d4fa:	00 00 
  74d4fc:	48 89 4c 24 40       	mov    %rcx,0x40(%rsp)
  74d501:	48 89 54 24 48       	mov    %rdx,0x48(%rsp)
  74d506:	b9 01 00 00 00       	mov    $0x1,%ecx
  74d50b:	eb 04                	jmp    74d511 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x2a1>
  74d50d:	31 c9                	xor    %ecx,%ecx
  74d50f:	31 c0                	xor    %eax,%eax
  74d511:	48 89 4c 24 10       	mov    %rcx,0x10(%rsp)
  74d516:	48 89 4c 24 30       	mov    %rcx,0x30(%rsp)
  74d51b:	48 89 44 24 50       	mov    %rax,0x50(%rsp)
  74d520:	48 8d 7c 24 60       	lea    0x60(%rsp),%rdi
  74d525:	48 8d 74 24 10       	lea    0x10(%rsp),%rsi
  74d52a:	e8 e1 8b ff ff       	call   746110 <<alloc::collections::btree::map::IntoIter<gpui::source::FieldId, gpui::runtime::Fanout>>::dying_next>
  74d52f:	48 8b 44 24 60       	mov    0x60(%rsp),%rax
  74d534:	48 85 c0             	test   %rax,%rax
  74d537:	74 56                	je     74d58f <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x31f>
  74d539:	4c 8d 64 24 60       	lea    0x60(%rsp),%r12
  74d53e:	4c 8d 6c 24 10       	lea    0x10(%rsp),%r13
  74d543:	48 8b 2d 86 bd 3d 00 	mov    0x3dbd86(%rip),%rbp        # b292d0 <_DYNAMIC+0x248>
  74d54a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  74d550:	48 8b 4c 24 70       	mov    0x70(%rsp),%rcx
  74d555:	48 c1 e1 05          	shl    $0x5,%rcx
  74d559:	48 8b 34 08          	mov    (%rax,%rcx,1),%rsi
  74d55d:	48 83 fe ff          	cmp    $0xffffffffffffffff,%rsi
  74d561:	74 17                	je     74d57a <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x30a>
  74d563:	48 85 f6             	test   %rsi,%rsi
  74d566:	74 12                	je     74d57a <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x30a>
  74d568:	48 01 c8             	add    %rcx,%rax
  74d56b:	48 8b 78 08          	mov    0x8(%rax),%rdi
  74d56f:	48 c1 e6 02          	shl    $0x2,%rsi
  74d573:	ba 04 00 00 00       	mov    $0x4,%edx
  74d578:	ff d5                	call   *%rbp
  74d57a:	4c 89 e7             	mov    %r12,%rdi
  74d57d:	4c 89 ee             	mov    %r13,%rsi
  74d580:	e8 8b 8b ff ff       	call   746110 <<alloc::collections::btree::map::IntoIter<gpui::source::FieldId, gpui::runtime::Fanout>>::dying_next>
  74d585:	48 8b 44 24 60       	mov    0x60(%rsp),%rax
  74d58a:	48 85 c0             	test   %rax,%rax
  74d58d:	75 c1                	jne    74d550 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x2e0>
  74d58f:	49 8d be f8 05 00 00 	lea    0x5f8(%r14),%rdi
  74d596:	e8 95 ba ff ff       	call   749030 <<alloc::collections::btree::map::BTreeMap<u64, gpui::property::Overlay<gpui::style::Style>> as core::ops::drop::Drop>::drop>
  74d59b:	49 8b be 10 06 00 00 	mov    0x610(%r14),%rdi
  74d5a2:	e8 19 1f 00 00       	call   74f4c0 <core::ptr::drop_glue::<core::option::Option<alloc::boxed::Box<gpui::runtime::metadata::Metadata>>>>
  74d5a7:	49 8d be 18 06 00 00 	lea    0x618(%r14),%rdi
  74d5ae:	e8 ad aa ff ff       	call   748060 <<alloc::collections::btree::map::BTreeMap<gpui::runtime::scroll::ViewportKey, gpui::runtime::scroll::ViewportState> as core::ops::drop::Drop>::drop>
  74d5b3:	49 8d be 30 06 00 00 	lea    0x630(%r14),%rdi
  74d5ba:	e8 11 ae ff ff       	call   7483d0 <<alloc::collections::btree::map::BTreeMap<(core::option::Option<u64>, gpui::list::ListId, gpui::element::NodeKind), usize> as core::ops::drop::Drop>::drop>
  74d5bf:	49 8d be c0 02 00 00 	lea    0x2c0(%r14),%rdi
  74d5c6:	e8 45 2a 00 00       	call   750010 <core::ptr::drop_glue::<gpui_reactivity_core::layout::LayoutTree>>
  74d5cb:	49 8b b6 58 05 00 00 	mov    0x558(%r14),%rsi
  74d5d2:	48 85 f6             	test   %rsi,%rsi
  74d5d5:	74 16                	je     74d5ed <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x37d>
  74d5d7:	49 8b be 60 05 00 00 	mov    0x560(%r14),%rdi
  74d5de:	48 c1 e6 04          	shl    $0x4,%rsi
  74d5e2:	ba 08 00 00 00       	mov    $0x8,%edx
  74d5e7:	ff 15 e3 bc 3d 00    	call   *0x3dbce3(%rip)        # b292d0 <_DYNAMIC+0x248>
  74d5ed:	49 8d be 48 06 00 00 	lea    0x648(%r14),%rdi
  74d5f4:	e8 e7 9e ff ff       	call   7474e0 <<alloc::collections::btree::map::BTreeMap<gpui::list::ListId, alloc::collections::btree::set_val::SetValZST> as core::ops::drop::Drop>::drop>
  74d5f9:	49 8b 86 88 05 00 00 	mov    0x588(%r14),%rax
  74d600:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  74d604:	0f 84 7e 00 00 00    	je     74d688 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x418>
  74d60a:	4d 8b a6 98 05 00 00 	mov    0x598(%r14),%r12
  74d611:	4d 85 e4             	test   %r12,%r12
  74d614:	74 53                	je     74d669 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x3f9>
  74d616:	4d 8b ae 90 05 00 00 	mov    0x590(%r14),%r13
  74d61d:	49 83 c5 78          	add    $0x78,%r13
  74d621:	48 8b 2d e0 bc 3d 00 	mov    0x3dbce0(%rip),%rbp        # b29308 <_DYNAMIC+0x280>
  74d628:	eb 0f                	jmp    74d639 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x3c9>
  74d62a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  74d630:	49 83 c5 50          	add    $0x50,%r13
  74d634:	49 ff cc             	dec    %r12
  74d637:	74 29                	je     74d662 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x3f2>
  74d639:	49 8b 7d b0          	mov    -0x50(%r13),%rdi
  74d63d:	48 85 ff             	test   %rdi,%rdi
  74d640:	74 ee                	je     74d630 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x3c0>
  74d642:	f6 07 01             	testb  $0x1,(%rdi)
  74d645:	75 e9                	jne    74d630 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x3c0>
  74d647:	48 8b 47 08          	mov    0x8(%rdi),%rax
  74d64b:	a8 01                	test   $0x1,%al
  74d64d:	75 e1                	jne    74d630 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x3c0>
  74d64f:	48 8d 47 08          	lea    0x8(%rdi),%rax
  74d653:	f0 48 83 28 02       	lock subq $0x2,(%rax)
  74d658:	75 d6                	jne    74d630 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x3c0>
  74d65a:	48 8b 47 08          	mov    0x8(%rdi),%rax
  74d65e:	ff d5                	call   *%rbp
  74d660:	eb ce                	jmp    74d630 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x3c0>
  74d662:	49 8b 86 88 05 00 00 	mov    0x588(%r14),%rax
  74d669:	48 85 c0             	test   %rax,%rax
  74d66c:	74 1a                	je     74d688 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x418>
  74d66e:	49 8b be 90 05 00 00 	mov    0x590(%r14),%rdi
  74d675:	48 c1 e0 04          	shl    $0x4,%rax
  74d679:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  74d67d:	ba 08 00 00 00       	mov    $0x8,%edx
  74d682:	ff 15 48 bc 3d 00    	call   *0x3dbc48(%rip)        # b292d0 <_DYNAMIC+0x248>
  74d688:	4d 8b a6 80 05 00 00 	mov    0x580(%r14),%r12
  74d68f:	4d 85 e4             	test   %r12,%r12
  74d692:	74 4e                	je     74d6e2 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x472>
  74d694:	4d 8b ae 78 05 00 00 	mov    0x578(%r14),%r13
  74d69b:	49 83 c5 78          	add    $0x78,%r13
  74d69f:	48 8b 2d 62 bc 3d 00 	mov    0x3dbc62(%rip),%rbp        # b29308 <_DYNAMIC+0x280>
  74d6a6:	eb 11                	jmp    74d6b9 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x449>
  74d6a8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  74d6af:	00 
  74d6b0:	49 83 c5 50          	add    $0x50,%r13
  74d6b4:	49 ff cc             	dec    %r12
  74d6b7:	74 29                	je     74d6e2 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x472>
  74d6b9:	49 8b 7d b0          	mov    -0x50(%r13),%rdi
  74d6bd:	48 85 ff             	test   %rdi,%rdi
  74d6c0:	74 ee                	je     74d6b0 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x440>
  74d6c2:	f6 07 01             	testb  $0x1,(%rdi)
  74d6c5:	75 e9                	jne    74d6b0 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x440>
  74d6c7:	48 8b 47 08          	mov    0x8(%rdi),%rax
  74d6cb:	a8 01                	test   $0x1,%al
  74d6cd:	75 e1                	jne    74d6b0 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x440>
  74d6cf:	48 8d 47 08          	lea    0x8(%rdi),%rax
  74d6d3:	f0 48 83 28 02       	lock subq $0x2,(%rax)
  74d6d8:	75 d6                	jne    74d6b0 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x440>
  74d6da:	48 8b 47 08          	mov    0x8(%rdi),%rax
  74d6de:	ff d5                	call   *%rbp
  74d6e0:	eb ce                	jmp    74d6b0 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x440>
  74d6e2:	49 8b 86 70 05 00 00 	mov    0x570(%r14),%rax
  74d6e9:	48 85 c0             	test   %rax,%rax
  74d6ec:	74 1a                	je     74d708 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x498>
  74d6ee:	49 8b be 78 05 00 00 	mov    0x578(%r14),%rdi
  74d6f5:	48 c1 e0 04          	shl    $0x4,%rax
  74d6f9:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  74d6fd:	ba 08 00 00 00       	mov    $0x8,%edx
  74d702:	ff 15 c8 bb 3d 00    	call   *0x3dbbc8(%rip)        # b292d0 <_DYNAMIC+0x248>
  74d708:	4c 89 f7             	mov    %r14,%rdi
  74d70b:	e8 b0 2e 00 00       	call   7505c0 <core::ptr::drop_glue::<gpui_canvas::canvas::Canvas>>
  74d710:	49 8b be 98 06 00 00 	mov    0x698(%r14),%rdi
  74d717:	e8 c4 17 00 00       	call   74eee0 <core::ptr::drop_glue::<core::option::Option<alloc::boxed::Box<gpui::runtime::text_geometry::TextResources>>>>
  74d71c:	be 28 07 00 00       	mov    $0x728,%esi
  74d721:	ba 08 00 00 00       	mov    $0x8,%edx
  74d726:	4c 89 f7             	mov    %r14,%rdi
  74d729:	ff 15 a1 bb 3d 00    	call   *0x3dbba1(%rip)        # b292d0 <_DYNAMIC+0x248>
  74d72f:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  74d734:	48 c7 03 01 00 00 00 	movq   $0x1,(%rbx)
  74d73b:	48 89 43 08          	mov    %rax,0x8(%rbx)
  74d73f:	48 8d 35 ca e4 3a 00 	lea    0x3ae4ca(%rip),%rsi        # afbc10 <anon.2d1f820267f84878e0cbda50021465a1.0.llvm.17676285964678017166>
  74d746:	4c 89 ff             	mov    %r15,%rdi
  74d749:	e8 b2 fa 01 00       	call   76d200 <<std::thread::local::LocalKey<core::cell::RefCell<allocation_counter::allocator::AllocationInfoStack>>>::with::<allocation_counter::measure<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>::{closure#1}, allocation_counter::AllocationInfo>>
  74d74e:	4c 89 f8             	mov    %r15,%rax
  74d751:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  74d758:	5b                   	pop    %rbx
  74d759:	41 5c                	pop    %r12
  74d75b:	41 5d                	pop    %r13
  74d75d:	41 5e                	pop    %r14
  74d75f:	41 5f                	pop    %r15
  74d761:	5d                   	pop    %rbp
  74d762:	c3                   	ret
  74d763:	ba 0c 0c 00 00       	mov    $0xc0c,%edx
  74d768:	4c 89 f7             	mov    %r14,%rdi
  74d76b:	31 f6                	xor    %esi,%esi
  74d76d:	ff 15 c5 c0 3d 00    	call   *0x3dc0c5(%rip)        # b29838 <memset@GLIBC_2.2.5>
  74d773:	64 41 c6 84 24 10 0c 	movb   $0x1,%fs:0xc10(%r12)
  74d77a:	00 00 01 
  74d77d:	64 49 83 3c 24 00    	cmpq   $0x0,%fs:(%r12)
  74d783:	0f 84 2d fb ff ff    	je     74d2b6 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x46>
  74d789:	48 8d 3d 60 f1 3a 00 	lea    0x3af160(%rip),%rdi        # afc8f0 <anon.cf030bdcd33bba1955553babc00e59a7.15.llvm.14032215357312518664>
  74d790:	ff 15 aa c0 3d 00    	call   *0x3dc0aa(%rip)        # b29840 <_DYNAMIC+0x7b8>
  74d796:	48 8d 3d 2b e6 91 ff 	lea    -0x6e19d5(%rip),%rdi        # 6bdc8 <anon.cf030bdcd33bba1955553babc00e59a7.12.llvm.14032215357312518664>
  74d79d:	48 8d 15 34 f1 3a 00 	lea    0x3af134(%rip),%rdx        # afc8d8 <anon.cf030bdcd33bba1955553babc00e59a7.14.llvm.14032215357312518664>
  74d7a4:	be 4b 00 00 00       	mov    $0x4b,%esi
  74d7a9:	ff 15 21 bd 3d 00    	call   *0x3dbd21(%rip)        # b294d0 <_DYNAMIC+0x448>
  74d7af:	eb 53                	jmp    74d804 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x594>
  74d7b1:	48 8b 84 24 90 00 00 	mov    0x90(%rsp),%rax
  74d7b8:	00 
  74d7b9:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
  74d7be:	0f 10 44 24 60       	movups 0x60(%rsp),%xmm0
  74d7c3:	0f 10 4c 24 70       	movups 0x70(%rsp),%xmm1
  74d7c8:	0f 10 94 24 80 00 00 	movups 0x80(%rsp),%xmm2
  74d7cf:	00 
  74d7d0:	0f 29 54 24 30       	movaps %xmm2,0x30(%rsp)
  74d7d5:	0f 29 4c 24 20       	movaps %xmm1,0x20(%rsp)
  74d7da:	0f 29 44 24 10       	movaps %xmm0,0x10(%rsp)
  74d7df:	48 8d 3d 0e d7 91 ff 	lea    -0x6e28f2(%rip),%rdi        # 6aef4 <anon.2d1f820267f84878e0cbda50021465a1.8.llvm.17676285964678017166>
  74d7e6:	48 8d 0d 8b e4 3a 00 	lea    0x3ae48b(%rip),%rcx        # afbc78 <anon.2d1f820267f84878e0cbda50021465a1.7.llvm.17676285964678017166>
  74d7ed:	4c 8d 05 24 e4 3a 00 	lea    0x3ae424(%rip),%r8        # afbc18 <anon.2d1f820267f84878e0cbda50021465a1.0.llvm.17676285964678017166+0x8>
  74d7f4:	48 8d 54 24 10       	lea    0x10(%rsp),%rdx
  74d7f9:	be 2b 00 00 00       	mov    $0x2b,%esi
  74d7fe:	ff 15 d4 bb 3d 00    	call   *0x3dbbd4(%rip)        # b293d8 <_DYNAMIC+0x350>
  74d804:	0f 0b                	ud2
  74d806:	49 89 c7             	mov    %rax,%r15
  74d809:	49 ff cc             	dec    %r12
  74d80c:	74 0f                	je     74d81d <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x5ad>
  74d80e:	49 8b 7d 00          	mov    0x0(%r13),%rdi
  74d812:	49 83 c5 50          	add    $0x50,%r13
  74d816:	e8 d5 44 ff ff       	call   741cf0 <core::ptr::drop_glue::<core::option::Option<gpui::shared_text::SharedText>>>
  74d81b:	eb ec                	jmp    74d809 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x599>
  74d81d:	49 8b 86 88 05 00 00 	mov    0x588(%r14),%rax
  74d824:	48 85 c0             	test   %rax,%rax
  74d827:	0f 84 59 02 00 00    	je     74da86 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x816>
  74d82d:	49 8b be 90 05 00 00 	mov    0x590(%r14),%rdi
  74d834:	48 c1 e0 04          	shl    $0x4,%rax
  74d838:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  74d83c:	ba 08 00 00 00       	mov    $0x8,%edx
  74d841:	ff 15 89 ba 3d 00    	call   *0x3dba89(%rip)        # b292d0 <_DYNAMIC+0x248>
  74d847:	e9 3a 02 00 00       	jmp    74da86 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x816>
  74d84c:	ff 15 ae ba 3d 00    	call   *0x3dbaae(%rip)        # b29300 <_DYNAMIC+0x278>
  74d852:	49 89 c7             	mov    %rax,%r15
  74d855:	49 ff cc             	dec    %r12
  74d858:	74 0f                	je     74d869 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x5f9>
  74d85a:	49 8b 7d 00          	mov    0x0(%r13),%rdi
  74d85e:	49 83 c5 50          	add    $0x50,%r13
  74d862:	e8 89 44 ff ff       	call   741cf0 <core::ptr::drop_glue::<core::option::Option<gpui::shared_text::SharedText>>>
  74d867:	eb ec                	jmp    74d855 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x5e5>
  74d869:	49 8b 86 70 05 00 00 	mov    0x570(%r14),%rax
  74d870:	48 85 c0             	test   %rax,%rax
  74d873:	0f 84 19 02 00 00    	je     74da92 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x822>
  74d879:	49 8b be 78 05 00 00 	mov    0x578(%r14),%rdi
  74d880:	48 c1 e0 04          	shl    $0x4,%rax
  74d884:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  74d888:	ba 08 00 00 00       	mov    $0x8,%edx
  74d88d:	ff 15 3d ba 3d 00    	call   *0x3dba3d(%rip)        # b292d0 <_DYNAMIC+0x248>
  74d893:	e9 fa 01 00 00       	jmp    74da92 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x822>
  74d898:	ff 15 62 ba 3d 00    	call   *0x3dba62(%rip)        # b29300 <_DYNAMIC+0x278>
  74d89e:	49 89 c7             	mov    %rax,%r15
  74d8a1:	e9 00 02 00 00       	jmp    74daa6 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x836>
  74d8a6:	49 89 c7             	mov    %rax,%r15
  74d8a9:	e9 ec 01 00 00       	jmp    74da9a <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x82a>
  74d8ae:	49 89 c7             	mov    %rax,%r15
  74d8b1:	e9 c4 01 00 00       	jmp    74da7a <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x80a>
  74d8b6:	49 89 c7             	mov    %rax,%r15
  74d8b9:	e9 8e 01 00 00       	jmp    74da4c <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x7dc>
  74d8be:	49 89 c7             	mov    %rax,%r15
  74d8c1:	e9 7a 01 00 00       	jmp    74da40 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x7d0>
  74d8c6:	49 89 c7             	mov    %rax,%r15
  74d8c9:	e9 66 01 00 00       	jmp    74da34 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x7c4>
  74d8ce:	49 89 c7             	mov    %rax,%r15
  74d8d1:	e9 52 01 00 00       	jmp    74da28 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x7b8>
  74d8d6:	49 89 c7             	mov    %rax,%r15
  74d8d9:	e9 3e 01 00 00       	jmp    74da1c <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x7ac>
  74d8de:	e9 2a 01 00 00       	jmp    74da0d <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x79d>
  74d8e3:	49 89 c7             	mov    %rax,%r15
  74d8e6:	e9 02 01 00 00       	jmp    74d9ed <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x77d>
  74d8eb:	49 89 c7             	mov    %rax,%r15
  74d8ee:	49 8b 04 24          	mov    (%r12),%rax
  74d8f2:	48 85 c0             	test   %rax,%rax
  74d8f5:	0f 84 e6 00 00 00    	je     74d9e1 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x771>
  74d8fb:	49 8b be b0 02 00 00 	mov    0x2b0(%r14),%rdi
  74d902:	48 c1 e0 04          	shl    $0x4,%rax
  74d906:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  74d90a:	ba 08 00 00 00       	mov    $0x8,%edx
  74d90f:	ff 15 bb b9 3d 00    	call   *0x3db9bb(%rip)        # b292d0 <_DYNAMIC+0x248>
  74d915:	e9 c7 00 00 00       	jmp    74d9e1 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x771>
  74d91a:	49 89 c7             	mov    %rax,%r15
  74d91d:	49 8b 04 24          	mov    (%r12),%rax
  74d921:	48 85 c0             	test   %rax,%rax
  74d924:	0f 84 9f 00 00 00    	je     74d9c9 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x759>
  74d92a:	49 8b be 98 02 00 00 	mov    0x298(%r14),%rdi
  74d931:	48 c1 e0 03          	shl    $0x3,%rax
  74d935:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  74d939:	ba 08 00 00 00       	mov    $0x8,%edx
  74d93e:	ff 15 8c b9 3d 00    	call   *0x3db98c(%rip)        # b292d0 <_DYNAMIC+0x248>
  74d944:	e9 80 00 00 00       	jmp    74d9c9 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x759>
  74d949:	49 89 c7             	mov    %rax,%r15
  74d94c:	49 8b 34 24          	mov    (%r12),%rsi
  74d950:	48 85 f6             	test   %rsi,%rsi
  74d953:	74 68                	je     74d9bd <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x74d>
  74d955:	49 8b be 78 02 00 00 	mov    0x278(%r14),%rdi
  74d95c:	48 c1 e6 04          	shl    $0x4,%rsi
  74d960:	ba 08 00 00 00       	mov    $0x8,%edx
  74d965:	ff 15 65 b9 3d 00    	call   *0x3db965(%rip)        # b292d0 <_DYNAMIC+0x248>
  74d96b:	eb 50                	jmp    74d9bd <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x74d>
  74d96d:	49 89 c7             	mov    %rax,%r15
  74d970:	49 8b 34 24          	mov    (%r12),%rsi
  74d974:	48 85 f6             	test   %rsi,%rsi
  74d977:	74 16                	je     74d98f <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x71f>
  74d979:	49 8b be 48 02 00 00 	mov    0x248(%r14),%rdi
  74d980:	48 c1 e6 04          	shl    $0x4,%rsi
  74d984:	ba 08 00 00 00       	mov    $0x8,%edx
  74d989:	ff 15 41 b9 3d 00    	call   *0x3db941(%rip)        # b292d0 <_DYNAMIC+0x248>
  74d98f:	49 8b b6 58 02 00 00 	mov    0x258(%r14),%rsi
  74d996:	48 85 f6             	test   %rsi,%rsi
  74d999:	74 16                	je     74d9b1 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x741>
  74d99b:	49 8b be 60 02 00 00 	mov    0x260(%r14),%rdi
  74d9a2:	48 c1 e6 03          	shl    $0x3,%rsi
  74d9a6:	ba 08 00 00 00       	mov    $0x8,%edx
  74d9ab:	ff 15 1f b9 3d 00    	call   *0x3db91f(%rip)        # b292d0 <_DYNAMIC+0x248>
  74d9b1:	49 8d be 70 02 00 00 	lea    0x270(%r14),%rdi
  74d9b8:	e8 d3 1f 00 00       	call   74f990 <core::ptr::drop_glue::<alloc::vec::Vec<alloc::boxed::Box<dyn gpui::source::ComponentSchema<unit_action_cost_two::Model>>>>>
  74d9bd:	49 8d be 90 02 00 00 	lea    0x290(%r14),%rdi
  74d9c4:	e8 b7 21 00 00       	call   74fb80 <core::ptr::drop_glue::<alloc::vec::Vec<gpui::runtime::Node>>>
  74d9c9:	49 8d be 00 02 00 00 	lea    0x200(%r14),%rdi
  74d9d0:	e8 1b 32 00 00       	call   750bf0 <core::ptr::drop_glue::<gpui::runtime::styles::Styles>>
  74d9d5:	49 8d be a8 02 00 00 	lea    0x2a8(%r14),%rdi
  74d9dc:	e8 df 1e 00 00       	call   74f8c0 <core::ptr::drop_glue::<alloc::vec::Vec<core::option::Option<gpui::runtime::TextSite>>>>
  74d9e1:	49 8b be c0 05 00 00 	mov    0x5c0(%r14),%rdi
  74d9e8:	e8 33 17 00 00       	call   74f120 <core::ptr::drop_glue::<core::option::Option<alloc::boxed::Box<gpui::runtime::image::Images>>>>
  74d9ed:	49 8d be e8 01 00 00 	lea    0x1e8(%r14),%rdi
  74d9f4:	e8 f7 30 00 00       	call   750af0 <core::ptr::drop_glue::<gpui::runtime::identity_index::IdentityIndex>>
  74d9f9:	49 8d be c8 05 00 00 	lea    0x5c8(%r14),%rdi
  74da00:	e8 cb 9e ff ff       	call   7478d0 <<alloc::collections::btree::map::BTreeMap<gpui::source::FieldId, gpui::runtime::Fanout> as core::ops::drop::Drop>::drop>
  74da05:	eb 09                	jmp    74da10 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x7a0>
  74da07:	ff 15 f3 b8 3d 00    	call   *0x3db8f3(%rip)        # b29300 <_DYNAMIC+0x278>
  74da0d:	49 89 c7             	mov    %rax,%r15
  74da10:	49 8d be f8 05 00 00 	lea    0x5f8(%r14),%rdi
  74da17:	e8 14 b6 ff ff       	call   749030 <<alloc::collections::btree::map::BTreeMap<u64, gpui::property::Overlay<gpui::style::Style>> as core::ops::drop::Drop>::drop>
  74da1c:	49 8b be 10 06 00 00 	mov    0x610(%r14),%rdi
  74da23:	e8 98 1a 00 00       	call   74f4c0 <core::ptr::drop_glue::<core::option::Option<alloc::boxed::Box<gpui::runtime::metadata::Metadata>>>>
  74da28:	49 8d be 18 06 00 00 	lea    0x618(%r14),%rdi
  74da2f:	e8 2c a6 ff ff       	call   748060 <<alloc::collections::btree::map::BTreeMap<gpui::runtime::scroll::ViewportKey, gpui::runtime::scroll::ViewportState> as core::ops::drop::Drop>::drop>
  74da34:	49 8d be 30 06 00 00 	lea    0x630(%r14),%rdi
  74da3b:	e8 90 a9 ff ff       	call   7483d0 <<alloc::collections::btree::map::BTreeMap<(core::option::Option<u64>, gpui::list::ListId, gpui::element::NodeKind), usize> as core::ops::drop::Drop>::drop>
  74da40:	49 8d be c0 02 00 00 	lea    0x2c0(%r14),%rdi
  74da47:	e8 c4 25 00 00       	call   750010 <core::ptr::drop_glue::<gpui_reactivity_core::layout::LayoutTree>>
  74da4c:	49 8b b6 58 05 00 00 	mov    0x558(%r14),%rsi
  74da53:	48 85 f6             	test   %rsi,%rsi
  74da56:	74 16                	je     74da6e <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x7fe>
  74da58:	49 8b be 60 05 00 00 	mov    0x560(%r14),%rdi
  74da5f:	48 c1 e6 04          	shl    $0x4,%rsi
  74da63:	ba 08 00 00 00       	mov    $0x8,%edx
  74da68:	ff 15 62 b8 3d 00    	call   *0x3db862(%rip)        # b292d0 <_DYNAMIC+0x248>
  74da6e:	49 8d be 48 06 00 00 	lea    0x648(%r14),%rdi
  74da75:	e8 66 9a ff ff       	call   7474e0 <<alloc::collections::btree::map::BTreeMap<gpui::list::ListId, alloc::collections::btree::set_val::SetValZST> as core::ops::drop::Drop>::drop>
  74da7a:	49 8d be 88 05 00 00 	lea    0x588(%r14),%rdi
  74da81:	e8 5a 1c 00 00       	call   74f6e0 <core::ptr::drop_glue::<core::option::Option<gpui::runtime::Prepared>>>
  74da86:	49 8d be 70 05 00 00 	lea    0x570(%r14),%rdi
  74da8d:	e8 5e 21 00 00       	call   74fbf0 <core::ptr::drop_glue::<alloc::vec::Vec<gpui::runtime::Presented>>>
  74da92:	4c 89 f7             	mov    %r14,%rdi
  74da95:	e8 26 2b 00 00       	call   7505c0 <core::ptr::drop_glue::<gpui_canvas::canvas::Canvas>>
  74da9a:	49 8b be 98 06 00 00 	mov    0x698(%r14),%rdi
  74daa1:	e8 3a 14 00 00       	call   74eee0 <core::ptr::drop_glue::<core::option::Option<alloc::boxed::Box<gpui::runtime::text_geometry::TextResources>>>>
  74daa6:	be 28 07 00 00       	mov    $0x728,%esi
  74daab:	ba 08 00 00 00       	mov    $0x8,%edx
  74dab0:	4c 89 f7             	mov    %r14,%rdi
  74dab3:	ff 15 17 b8 3d 00    	call   *0x3db817(%rip)        # b292d0 <_DYNAMIC+0x248>
  74dab9:	48 c7 03 01 00 00 00 	movq   $0x1,(%rbx)
  74dac0:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  74dac5:	48 89 43 08          	mov    %rax,0x8(%rbx)
  74dac9:	4c 89 ff             	mov    %r15,%rdi
  74dacc:	e8 df b9 3a 00       	call   af94b0 <_Unwind_Resume@plt>
  74dad1:	ff 15 29 b8 3d 00    	call   *0x3db829(%rip)        # b29300 <_DYNAMIC+0x278>
  74dad7:	49 89 c7             	mov    %rax,%r15
  74dada:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  74dadf:	e8 6c 2e 00 00       	call   750950 <core::ptr::drop_glue::<gpui::runtime::Error>>
  74dae4:	4c 89 ff             	mov    %r15,%rdi
  74dae7:	e8 c4 b9 3a 00       	call   af94b0 <_Unwind_Resume@plt>
  74daec:	64 49 ff 04 24       	incq   %fs:(%r12)
  74daf1:	48 89 c7             	mov    %rax,%rdi
  74daf4:	e8 b7 b9 3a 00       	call   af94b0 <_Unwind_Resume@plt>
