
/tmp/gpui-contained-owner-spike-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

000000000074d300 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>>:
  74d300:	55                   	push   %rbp
  74d301:	41 57                	push   %r15
  74d303:	41 56                	push   %r14
  74d305:	41 55                	push   %r13
  74d307:	41 54                	push   %r12
  74d309:	53                   	push   %rbx
  74d30a:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  74d311:	48 89 f3             	mov    %rsi,%rbx
  74d314:	49 89 ff             	mov    %rdi,%r15
  74d317:	49 c7 c4 68 f3 ff ff 	mov    $0xfffffffffffff368,%r12
  74d31e:	64 4c 8b 34 25 00 00 	mov    %fs:0x0,%r14
  74d325:	00 00 
  74d327:	4d 01 e6             	add    %r12,%r14
  74d32a:	64 41 80 bc 24 10 0c 	cmpb   $0x0,%fs:0xc10(%r12)
  74d331:	00 00 00 
  74d334:	0f 84 b9 04 00 00    	je     74d7f3 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x4f3>
  74d33a:	64 49 83 3c 24 00    	cmpq   $0x0,%fs:(%r12)
  74d340:	0f 85 d3 04 00 00    	jne    74d819 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x519>
  74d346:	64 49 c7 04 24 ff ff 	movq   $0xffffffffffffffff,%fs:(%r12)
  74d34d:	ff ff 
  74d34f:	64 41 8b 84 24 08 0c 	mov    %fs:0xc08(%r12),%eax
  74d356:	00 00 
  74d358:	ff c0                	inc    %eax
  74d35a:	64 41 89 84 24 08 0c 	mov    %eax,%fs:0xc08(%r12)
  74d361:	00 00 
  74d363:	83 f8 40             	cmp    $0x40,%eax
  74d366:	0f 83 ba 04 00 00    	jae    74d826 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x526>
  74d36c:	89 c0                	mov    %eax,%eax
  74d36e:	48 8d 04 40          	lea    (%rax,%rax,2),%rax
  74d372:	48 c1 e0 04          	shl    $0x4,%rax
  74d376:	0f 57 c0             	xorps  %xmm0,%xmm0
  74d379:	41 0f 11 44 06 28    	movups %xmm0,0x28(%r14,%rax,1)
  74d37f:	41 0f 11 44 06 18    	movups %xmm0,0x18(%r14,%rax,1)
  74d385:	41 0f 11 44 06 08    	movups %xmm0,0x8(%r14,%rax,1)
  74d38b:	64 49 c7 04 24 00 00 	movq   $0x0,%fs:(%r12)
  74d392:	00 00 
  74d394:	48 b8 80 02 00 00 e0 	movabs $0x1e000000280,%rax
  74d39b:	01 00 00 
  74d39e:	48 89 44 24 20       	mov    %rax,0x20(%rsp)
  74d3a3:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%rsp)
  74d3aa:	00 
  74d3ab:	c7 44 24 18 00 00 4b 	movl   $0x434b0000,0x18(%rsp)
  74d3b2:	43 
  74d3b3:	66 c7 44 24 1c 00 00 	movw   $0x0,0x1c(%rsp)
  74d3ba:	48 8d 7c 24 60       	lea    0x60(%rsp),%rdi
  74d3bf:	48 8d 54 24 10       	lea    0x10(%rsp),%rdx
  74d3c4:	f3 0f 10 05 dc c2 90 	movss  -0x6f3d24(%rip),%xmm0        # 596a8 <anon.079f5e587c394fcac2765eb4d0cf0bc2.312.llvm.6319143315422321905+0x38>
  74d3cb:	ff 
  74d3cc:	31 f6                	xor    %esi,%esi
  74d3ce:	b9 01 00 00 00       	mov    $0x1,%ecx
  74d3d3:	45 31 c0             	xor    %r8d,%r8d
  74d3d6:	e8 b5 e5 fb ff       	call   70b990 <<gpui::runtime::Win<unit_action_cost_two::Model>>::mount_lanes>
  74d3db:	83 7c 24 60 fe       	cmpl   $0xfffffffe,0x60(%rsp)
  74d3e0:	0f 85 5b 04 00 00    	jne    74d841 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x541>
  74d3e6:	48 8b 44 24 68       	mov    0x68(%rsp),%rax
  74d3eb:	48 83 3b 00          	cmpq   $0x0,(%rbx)
  74d3ef:	0f 84 cf 03 00 00    	je     74d7c4 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x4c4>
  74d3f5:	4c 8b 73 08          	mov    0x8(%rbx),%r14
  74d3f9:	4d 85 f6             	test   %r14,%r14
  74d3fc:	0f 84 c2 03 00 00    	je     74d7c4 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x4c4>
  74d402:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  74d407:	4d 8d a6 40 02 00 00 	lea    0x240(%r14),%r12
  74d40e:	4c 89 e7             	mov    %r12,%rdi
  74d411:	e8 fa 67 ff ff       	call   743c10 <<alloc::vec::Vec<alloc::boxed::Box<dyn gpui::source::ComponentSchema<unit_action_cost_two::SecondModel>>> as core::ops::drop::Drop>::drop>
  74d416:	49 8b 34 24          	mov    (%r12),%rsi
  74d41a:	48 85 f6             	test   %rsi,%rsi
  74d41d:	74 16                	je     74d435 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x135>
  74d41f:	49 8b be 48 02 00 00 	mov    0x248(%r14),%rdi
  74d426:	48 c1 e6 04          	shl    $0x4,%rsi
  74d42a:	ba 08 00 00 00       	mov    $0x8,%edx
  74d42f:	ff 15 13 bf 3d 00    	call   *0x3dbf13(%rip)        # b29348 <_DYNAMIC+0x248>
  74d435:	49 8b b6 58 02 00 00 	mov    0x258(%r14),%rsi
  74d43c:	48 85 f6             	test   %rsi,%rsi
  74d43f:	74 16                	je     74d457 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x157>
  74d441:	49 8b be 60 02 00 00 	mov    0x260(%r14),%rdi
  74d448:	48 c1 e6 03          	shl    $0x3,%rsi
  74d44c:	ba 08 00 00 00       	mov    $0x8,%edx
  74d451:	ff 15 f1 be 3d 00    	call   *0x3dbef1(%rip)        # b29348 <_DYNAMIC+0x248>
  74d457:	4d 8d a6 70 02 00 00 	lea    0x270(%r14),%r12
  74d45e:	4c 89 e7             	mov    %r12,%rdi
  74d461:	e8 aa 67 ff ff       	call   743c10 <<alloc::vec::Vec<alloc::boxed::Box<dyn gpui::source::ComponentSchema<unit_action_cost_two::SecondModel>>> as core::ops::drop::Drop>::drop>
  74d466:	49 8b 34 24          	mov    (%r12),%rsi
  74d46a:	48 85 f6             	test   %rsi,%rsi
  74d46d:	74 16                	je     74d485 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x185>
  74d46f:	49 8b be 78 02 00 00 	mov    0x278(%r14),%rdi
  74d476:	48 c1 e6 04          	shl    $0x4,%rsi
  74d47a:	ba 08 00 00 00       	mov    $0x8,%edx
  74d47f:	ff 15 c3 be 3d 00    	call   *0x3dbec3(%rip)        # b29348 <_DYNAMIC+0x248>
  74d485:	4d 8d a6 90 02 00 00 	lea    0x290(%r14),%r12
  74d48c:	4c 89 e7             	mov    %r12,%rdi
  74d48f:	e8 9c 6a ff ff       	call   743f30 <<alloc::vec::Vec<gpui::runtime::Node> as core::ops::drop::Drop>::drop>
  74d494:	49 8b 04 24          	mov    (%r12),%rax
  74d498:	48 85 c0             	test   %rax,%rax
  74d49b:	74 1a                	je     74d4b7 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x1b7>
  74d49d:	49 8b be 98 02 00 00 	mov    0x298(%r14),%rdi
  74d4a4:	48 c1 e0 03          	shl    $0x3,%rax
  74d4a8:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  74d4ac:	ba 08 00 00 00       	mov    $0x8,%edx
  74d4b1:	ff 15 91 be 3d 00    	call   *0x3dbe91(%rip)        # b29348 <_DYNAMIC+0x248>
  74d4b7:	49 8d be 00 02 00 00 	lea    0x200(%r14),%rdi
  74d4be:	e8 bd 37 00 00       	call   750c80 <core::ptr::drop_glue::<gpui::runtime::styles::Styles>>
  74d4c3:	4d 8d a6 a8 02 00 00 	lea    0x2a8(%r14),%r12
  74d4ca:	4c 89 e7             	mov    %r12,%rdi
  74d4cd:	e8 ce 68 ff ff       	call   743da0 <<alloc::vec::Vec<core::option::Option<gpui::runtime::TextSite>> as core::ops::drop::Drop>::drop>
  74d4d2:	49 8b 04 24          	mov    (%r12),%rax
  74d4d6:	48 85 c0             	test   %rax,%rax
  74d4d9:	74 1a                	je     74d4f5 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x1f5>
  74d4db:	49 8b be b0 02 00 00 	mov    0x2b0(%r14),%rdi
  74d4e2:	48 c1 e0 04          	shl    $0x4,%rax
  74d4e6:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  74d4ea:	ba 08 00 00 00       	mov    $0x8,%edx
  74d4ef:	ff 15 53 be 3d 00    	call   *0x3dbe53(%rip)        # b29348 <_DYNAMIC+0x248>
  74d4f5:	49 8b be c0 05 00 00 	mov    0x5c0(%r14),%rdi
  74d4fc:	e8 af 1c 00 00       	call   74f1b0 <core::ptr::drop_glue::<core::option::Option<alloc::boxed::Box<gpui::runtime::image::Images>>>>
  74d501:	49 8b 86 e8 01 00 00 	mov    0x1e8(%r14),%rax
  74d508:	48 85 c0             	test   %rax,%rax
  74d50b:	74 49                	je     74d556 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x256>
  74d50d:	83 f8 01             	cmp    $0x1,%eax
  74d510:	75 1e                	jne    74d530 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x230>
  74d512:	49 8b b6 f8 01 00 00 	mov    0x1f8(%r14),%rsi
  74d519:	48 85 f6             	test   %rsi,%rsi
  74d51c:	74 38                	je     74d556 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x256>
  74d51e:	49 8b be f0 01 00 00 	mov    0x1f0(%r14),%rdi
  74d525:	48 c1 e6 04          	shl    $0x4,%rsi
  74d529:	ba 08 00 00 00       	mov    $0x8,%edx
  74d52e:	eb 20                	jmp    74d550 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x250>
  74d530:	49 8b 86 f8 01 00 00 	mov    0x1f8(%r14),%rax
  74d537:	48 85 c0             	test   %rax,%rax
  74d53a:	74 1a                	je     74d556 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x256>
  74d53c:	49 8b be f0 01 00 00 	mov    0x1f0(%r14),%rdi
  74d543:	48 c1 e0 02          	shl    $0x2,%rax
  74d547:	48 8d 34 40          	lea    (%rax,%rax,2),%rsi
  74d54b:	ba 04 00 00 00       	mov    $0x4,%edx
  74d550:	ff 15 f2 bd 3d 00    	call   *0x3dbdf2(%rip)        # b29348 <_DYNAMIC+0x248>
  74d556:	49 8b 8e c8 05 00 00 	mov    0x5c8(%r14),%rcx
  74d55d:	48 85 c9             	test   %rcx,%rcx
  74d560:	74 3b                	je     74d59d <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x29d>
  74d562:	49 8b 96 d0 05 00 00 	mov    0x5d0(%r14),%rdx
  74d569:	49 8b 86 d8 05 00 00 	mov    0x5d8(%r14),%rax
  74d570:	48 c7 44 24 18 00 00 	movq   $0x0,0x18(%rsp)
  74d577:	00 00 
  74d579:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  74d57e:	48 89 54 24 28       	mov    %rdx,0x28(%rsp)
  74d583:	48 c7 44 24 38 00 00 	movq   $0x0,0x38(%rsp)
  74d58a:	00 00 
  74d58c:	48 89 4c 24 40       	mov    %rcx,0x40(%rsp)
  74d591:	48 89 54 24 48       	mov    %rdx,0x48(%rsp)
  74d596:	b9 01 00 00 00       	mov    $0x1,%ecx
  74d59b:	eb 04                	jmp    74d5a1 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x2a1>
  74d59d:	31 c9                	xor    %ecx,%ecx
  74d59f:	31 c0                	xor    %eax,%eax
  74d5a1:	48 89 4c 24 10       	mov    %rcx,0x10(%rsp)
  74d5a6:	48 89 4c 24 30       	mov    %rcx,0x30(%rsp)
  74d5ab:	48 89 44 24 50       	mov    %rax,0x50(%rsp)
  74d5b0:	48 8d 7c 24 60       	lea    0x60(%rsp),%rdi
  74d5b5:	48 8d 74 24 10       	lea    0x10(%rsp),%rsi
  74d5ba:	e8 e1 8b ff ff       	call   7461a0 <<alloc::collections::btree::map::IntoIter<gpui::source::FieldId, gpui::runtime::Fanout>>::dying_next>
  74d5bf:	48 8b 44 24 60       	mov    0x60(%rsp),%rax
  74d5c4:	48 85 c0             	test   %rax,%rax
  74d5c7:	74 56                	je     74d61f <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x31f>
  74d5c9:	4c 8d 64 24 60       	lea    0x60(%rsp),%r12
  74d5ce:	4c 8d 6c 24 10       	lea    0x10(%rsp),%r13
  74d5d3:	48 8b 2d 6e bd 3d 00 	mov    0x3dbd6e(%rip),%rbp        # b29348 <_DYNAMIC+0x248>
  74d5da:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  74d5e0:	48 8b 4c 24 70       	mov    0x70(%rsp),%rcx
  74d5e5:	48 c1 e1 05          	shl    $0x5,%rcx
  74d5e9:	48 8b 34 08          	mov    (%rax,%rcx,1),%rsi
  74d5ed:	48 83 fe ff          	cmp    $0xffffffffffffffff,%rsi
  74d5f1:	74 17                	je     74d60a <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x30a>
  74d5f3:	48 85 f6             	test   %rsi,%rsi
  74d5f6:	74 12                	je     74d60a <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x30a>
  74d5f8:	48 01 c8             	add    %rcx,%rax
  74d5fb:	48 8b 78 08          	mov    0x8(%rax),%rdi
  74d5ff:	48 c1 e6 02          	shl    $0x2,%rsi
  74d603:	ba 04 00 00 00       	mov    $0x4,%edx
  74d608:	ff d5                	call   *%rbp
  74d60a:	4c 89 e7             	mov    %r12,%rdi
  74d60d:	4c 89 ee             	mov    %r13,%rsi
  74d610:	e8 8b 8b ff ff       	call   7461a0 <<alloc::collections::btree::map::IntoIter<gpui::source::FieldId, gpui::runtime::Fanout>>::dying_next>
  74d615:	48 8b 44 24 60       	mov    0x60(%rsp),%rax
  74d61a:	48 85 c0             	test   %rax,%rax
  74d61d:	75 c1                	jne    74d5e0 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x2e0>
  74d61f:	49 8d be f8 05 00 00 	lea    0x5f8(%r14),%rdi
  74d626:	e8 95 ba ff ff       	call   7490c0 <<alloc::collections::btree::map::BTreeMap<u64, gpui::property::Overlay<gpui::style::Style>> as core::ops::drop::Drop>::drop>
  74d62b:	49 8b be 10 06 00 00 	mov    0x610(%r14),%rdi
  74d632:	e8 19 1f 00 00       	call   74f550 <core::ptr::drop_glue::<core::option::Option<alloc::boxed::Box<gpui::runtime::metadata::Metadata>>>>
  74d637:	49 8d be 18 06 00 00 	lea    0x618(%r14),%rdi
  74d63e:	e8 ad aa ff ff       	call   7480f0 <<alloc::collections::btree::map::BTreeMap<gpui::runtime::scroll::ViewportKey, gpui::runtime::scroll::ViewportState> as core::ops::drop::Drop>::drop>
  74d643:	49 8d be 30 06 00 00 	lea    0x630(%r14),%rdi
  74d64a:	e8 11 ae ff ff       	call   748460 <<alloc::collections::btree::map::BTreeMap<(core::option::Option<u64>, gpui::list::ListId, gpui::element::NodeKind), usize> as core::ops::drop::Drop>::drop>
  74d64f:	49 8d be c0 02 00 00 	lea    0x2c0(%r14),%rdi
  74d656:	e8 45 2a 00 00       	call   7500a0 <core::ptr::drop_glue::<gpui_reactivity_core::layout::LayoutTree>>
  74d65b:	49 8b b6 58 05 00 00 	mov    0x558(%r14),%rsi
  74d662:	48 85 f6             	test   %rsi,%rsi
  74d665:	74 16                	je     74d67d <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x37d>
  74d667:	49 8b be 60 05 00 00 	mov    0x560(%r14),%rdi
  74d66e:	48 c1 e6 04          	shl    $0x4,%rsi
  74d672:	ba 08 00 00 00       	mov    $0x8,%edx
  74d677:	ff 15 cb bc 3d 00    	call   *0x3dbccb(%rip)        # b29348 <_DYNAMIC+0x248>
  74d67d:	49 8d be 48 06 00 00 	lea    0x648(%r14),%rdi
  74d684:	e8 e7 9e ff ff       	call   747570 <<alloc::collections::btree::map::BTreeMap<gpui::list::ListId, alloc::collections::btree::set_val::SetValZST> as core::ops::drop::Drop>::drop>
  74d689:	49 8b 86 88 05 00 00 	mov    0x588(%r14),%rax
  74d690:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  74d694:	0f 84 7e 00 00 00    	je     74d718 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x418>
  74d69a:	4d 8b a6 98 05 00 00 	mov    0x598(%r14),%r12
  74d6a1:	4d 85 e4             	test   %r12,%r12
  74d6a4:	74 53                	je     74d6f9 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x3f9>
  74d6a6:	4d 8b ae 90 05 00 00 	mov    0x590(%r14),%r13
  74d6ad:	49 83 c5 78          	add    $0x78,%r13
  74d6b1:	48 8b 2d c8 bc 3d 00 	mov    0x3dbcc8(%rip),%rbp        # b29380 <_DYNAMIC+0x280>
  74d6b8:	eb 0f                	jmp    74d6c9 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x3c9>
  74d6ba:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  74d6c0:	49 83 c5 50          	add    $0x50,%r13
  74d6c4:	49 ff cc             	dec    %r12
  74d6c7:	74 29                	je     74d6f2 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x3f2>
  74d6c9:	49 8b 7d b0          	mov    -0x50(%r13),%rdi
  74d6cd:	48 85 ff             	test   %rdi,%rdi
  74d6d0:	74 ee                	je     74d6c0 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x3c0>
  74d6d2:	f6 07 01             	testb  $0x1,(%rdi)
  74d6d5:	75 e9                	jne    74d6c0 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x3c0>
  74d6d7:	48 8b 47 08          	mov    0x8(%rdi),%rax
  74d6db:	a8 01                	test   $0x1,%al
  74d6dd:	75 e1                	jne    74d6c0 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x3c0>
  74d6df:	48 8d 47 08          	lea    0x8(%rdi),%rax
  74d6e3:	f0 48 83 28 02       	lock subq $0x2,(%rax)
  74d6e8:	75 d6                	jne    74d6c0 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x3c0>
  74d6ea:	48 8b 47 08          	mov    0x8(%rdi),%rax
  74d6ee:	ff d5                	call   *%rbp
  74d6f0:	eb ce                	jmp    74d6c0 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x3c0>
  74d6f2:	49 8b 86 88 05 00 00 	mov    0x588(%r14),%rax
  74d6f9:	48 85 c0             	test   %rax,%rax
  74d6fc:	74 1a                	je     74d718 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x418>
  74d6fe:	49 8b be 90 05 00 00 	mov    0x590(%r14),%rdi
  74d705:	48 c1 e0 04          	shl    $0x4,%rax
  74d709:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  74d70d:	ba 08 00 00 00       	mov    $0x8,%edx
  74d712:	ff 15 30 bc 3d 00    	call   *0x3dbc30(%rip)        # b29348 <_DYNAMIC+0x248>
  74d718:	4d 8b a6 80 05 00 00 	mov    0x580(%r14),%r12
  74d71f:	4d 85 e4             	test   %r12,%r12
  74d722:	74 4e                	je     74d772 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x472>
  74d724:	4d 8b ae 78 05 00 00 	mov    0x578(%r14),%r13
  74d72b:	49 83 c5 78          	add    $0x78,%r13
  74d72f:	48 8b 2d 4a bc 3d 00 	mov    0x3dbc4a(%rip),%rbp        # b29380 <_DYNAMIC+0x280>
  74d736:	eb 11                	jmp    74d749 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x449>
  74d738:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  74d73f:	00 
  74d740:	49 83 c5 50          	add    $0x50,%r13
  74d744:	49 ff cc             	dec    %r12
  74d747:	74 29                	je     74d772 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x472>
  74d749:	49 8b 7d b0          	mov    -0x50(%r13),%rdi
  74d74d:	48 85 ff             	test   %rdi,%rdi
  74d750:	74 ee                	je     74d740 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x440>
  74d752:	f6 07 01             	testb  $0x1,(%rdi)
  74d755:	75 e9                	jne    74d740 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x440>
  74d757:	48 8b 47 08          	mov    0x8(%rdi),%rax
  74d75b:	a8 01                	test   $0x1,%al
  74d75d:	75 e1                	jne    74d740 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x440>
  74d75f:	48 8d 47 08          	lea    0x8(%rdi),%rax
  74d763:	f0 48 83 28 02       	lock subq $0x2,(%rax)
  74d768:	75 d6                	jne    74d740 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x440>
  74d76a:	48 8b 47 08          	mov    0x8(%rdi),%rax
  74d76e:	ff d5                	call   *%rbp
  74d770:	eb ce                	jmp    74d740 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x440>
  74d772:	49 8b 86 70 05 00 00 	mov    0x570(%r14),%rax
  74d779:	48 85 c0             	test   %rax,%rax
  74d77c:	74 1a                	je     74d798 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x498>
  74d77e:	49 8b be 78 05 00 00 	mov    0x578(%r14),%rdi
  74d785:	48 c1 e0 04          	shl    $0x4,%rax
  74d789:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  74d78d:	ba 08 00 00 00       	mov    $0x8,%edx
  74d792:	ff 15 b0 bb 3d 00    	call   *0x3dbbb0(%rip)        # b29348 <_DYNAMIC+0x248>
  74d798:	4c 89 f7             	mov    %r14,%rdi
  74d79b:	e8 b0 2e 00 00       	call   750650 <core::ptr::drop_glue::<gpui_canvas::canvas::Canvas>>
  74d7a0:	49 8b be 98 06 00 00 	mov    0x698(%r14),%rdi
  74d7a7:	e8 c4 17 00 00       	call   74ef70 <core::ptr::drop_glue::<core::option::Option<alloc::boxed::Box<gpui::runtime::text_geometry::TextResources>>>>
  74d7ac:	be 28 07 00 00       	mov    $0x728,%esi
  74d7b1:	ba 08 00 00 00       	mov    $0x8,%edx
  74d7b6:	4c 89 f7             	mov    %r14,%rdi
  74d7b9:	ff 15 89 bb 3d 00    	call   *0x3dbb89(%rip)        # b29348 <_DYNAMIC+0x248>
  74d7bf:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  74d7c4:	48 c7 03 01 00 00 00 	movq   $0x1,(%rbx)
  74d7cb:	48 89 43 08          	mov    %rax,0x8(%rbx)
  74d7cf:	48 8d 35 6a e4 3a 00 	lea    0x3ae46a(%rip),%rsi        # afbc40 <anon.2d1f820267f84878e0cbda50021465a1.0.llvm.17676285964678017166>
  74d7d6:	4c 89 ff             	mov    %r15,%rdi
  74d7d9:	e8 b2 fa 01 00       	call   76d290 <<std::thread::local::LocalKey<core::cell::RefCell<allocation_counter::allocator::AllocationInfoStack>>>::with::<allocation_counter::measure<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>::{closure#1}, allocation_counter::AllocationInfo>>
  74d7de:	4c 89 f8             	mov    %r15,%rax
  74d7e1:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  74d7e8:	5b                   	pop    %rbx
  74d7e9:	41 5c                	pop    %r12
  74d7eb:	41 5d                	pop    %r13
  74d7ed:	41 5e                	pop    %r14
  74d7ef:	41 5f                	pop    %r15
  74d7f1:	5d                   	pop    %rbp
  74d7f2:	c3                   	ret
  74d7f3:	ba 0c 0c 00 00       	mov    $0xc0c,%edx
  74d7f8:	4c 89 f7             	mov    %r14,%rdi
  74d7fb:	31 f6                	xor    %esi,%esi
  74d7fd:	ff 15 ad c0 3d 00    	call   *0x3dc0ad(%rip)        # b298b0 <memset@GLIBC_2.2.5>
  74d803:	64 41 c6 84 24 10 0c 	movb   $0x1,%fs:0xc10(%r12)
  74d80a:	00 00 01 
  74d80d:	64 49 83 3c 24 00    	cmpq   $0x0,%fs:(%r12)
  74d813:	0f 84 2d fb ff ff    	je     74d346 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x46>
  74d819:	48 8d 3d 28 f1 3a 00 	lea    0x3af128(%rip),%rdi        # afc948 <anon.547532fe00eaf98ca33efb65e1aed586.15.llvm.9042944481482549913>
  74d820:	ff 15 92 c0 3d 00    	call   *0x3dc092(%rip)        # b298b8 <_DYNAMIC+0x7b8>
  74d826:	48 8d 3d 43 e6 91 ff 	lea    -0x6e19bd(%rip),%rdi        # 6be70 <anon.547532fe00eaf98ca33efb65e1aed586.12.llvm.9042944481482549913>
  74d82d:	48 8d 15 fc f0 3a 00 	lea    0x3af0fc(%rip),%rdx        # afc930 <anon.547532fe00eaf98ca33efb65e1aed586.14.llvm.9042944481482549913>
  74d834:	be 4b 00 00 00       	mov    $0x4b,%esi
  74d839:	ff 15 09 bd 3d 00    	call   *0x3dbd09(%rip)        # b29548 <_DYNAMIC+0x448>
  74d83f:	eb 53                	jmp    74d894 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x594>
  74d841:	48 8b 84 24 90 00 00 	mov    0x90(%rsp),%rax
  74d848:	00 
  74d849:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
  74d84e:	0f 10 44 24 60       	movups 0x60(%rsp),%xmm0
  74d853:	0f 10 4c 24 70       	movups 0x70(%rsp),%xmm1
  74d858:	0f 10 94 24 80 00 00 	movups 0x80(%rsp),%xmm2
  74d85f:	00 
  74d860:	0f 29 54 24 30       	movaps %xmm2,0x30(%rsp)
  74d865:	0f 29 4c 24 20       	movaps %xmm1,0x20(%rsp)
  74d86a:	0f 29 44 24 10       	movaps %xmm0,0x10(%rsp)
  74d86f:	48 8d 3d de d6 91 ff 	lea    -0x6e2922(%rip),%rdi        # 6af54 <anon.2d1f820267f84878e0cbda50021465a1.8.llvm.17676285964678017166>
  74d876:	48 8d 0d 2b e4 3a 00 	lea    0x3ae42b(%rip),%rcx        # afbca8 <anon.2d1f820267f84878e0cbda50021465a1.7.llvm.17676285964678017166>
  74d87d:	4c 8d 05 c4 e3 3a 00 	lea    0x3ae3c4(%rip),%r8        # afbc48 <anon.2d1f820267f84878e0cbda50021465a1.0.llvm.17676285964678017166+0x8>
  74d884:	48 8d 54 24 10       	lea    0x10(%rsp),%rdx
  74d889:	be 2b 00 00 00       	mov    $0x2b,%esi
  74d88e:	ff 15 bc bb 3d 00    	call   *0x3dbbbc(%rip)        # b29450 <_DYNAMIC+0x350>
  74d894:	0f 0b                	ud2
  74d896:	49 89 c7             	mov    %rax,%r15
  74d899:	49 ff cc             	dec    %r12
  74d89c:	74 0f                	je     74d8ad <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x5ad>
  74d89e:	49 8b 7d 00          	mov    0x0(%r13),%rdi
  74d8a2:	49 83 c5 50          	add    $0x50,%r13
  74d8a6:	e8 d5 44 ff ff       	call   741d80 <core::ptr::drop_glue::<core::option::Option<gpui::shared_text::SharedText>>>
  74d8ab:	eb ec                	jmp    74d899 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x599>
  74d8ad:	49 8b 86 88 05 00 00 	mov    0x588(%r14),%rax
  74d8b4:	48 85 c0             	test   %rax,%rax
  74d8b7:	0f 84 59 02 00 00    	je     74db16 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x816>
  74d8bd:	49 8b be 90 05 00 00 	mov    0x590(%r14),%rdi
  74d8c4:	48 c1 e0 04          	shl    $0x4,%rax
  74d8c8:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  74d8cc:	ba 08 00 00 00       	mov    $0x8,%edx
  74d8d1:	ff 15 71 ba 3d 00    	call   *0x3dba71(%rip)        # b29348 <_DYNAMIC+0x248>
  74d8d7:	e9 3a 02 00 00       	jmp    74db16 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x816>
  74d8dc:	ff 15 96 ba 3d 00    	call   *0x3dba96(%rip)        # b29378 <_DYNAMIC+0x278>
  74d8e2:	49 89 c7             	mov    %rax,%r15
  74d8e5:	49 ff cc             	dec    %r12
  74d8e8:	74 0f                	je     74d8f9 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x5f9>
  74d8ea:	49 8b 7d 00          	mov    0x0(%r13),%rdi
  74d8ee:	49 83 c5 50          	add    $0x50,%r13
  74d8f2:	e8 89 44 ff ff       	call   741d80 <core::ptr::drop_glue::<core::option::Option<gpui::shared_text::SharedText>>>
  74d8f7:	eb ec                	jmp    74d8e5 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x5e5>
  74d8f9:	49 8b 86 70 05 00 00 	mov    0x570(%r14),%rax
  74d900:	48 85 c0             	test   %rax,%rax
  74d903:	0f 84 19 02 00 00    	je     74db22 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x822>
  74d909:	49 8b be 78 05 00 00 	mov    0x578(%r14),%rdi
  74d910:	48 c1 e0 04          	shl    $0x4,%rax
  74d914:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  74d918:	ba 08 00 00 00       	mov    $0x8,%edx
  74d91d:	ff 15 25 ba 3d 00    	call   *0x3dba25(%rip)        # b29348 <_DYNAMIC+0x248>
  74d923:	e9 fa 01 00 00       	jmp    74db22 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x822>
  74d928:	ff 15 4a ba 3d 00    	call   *0x3dba4a(%rip)        # b29378 <_DYNAMIC+0x278>
  74d92e:	49 89 c7             	mov    %rax,%r15
  74d931:	e9 00 02 00 00       	jmp    74db36 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x836>
  74d936:	49 89 c7             	mov    %rax,%r15
  74d939:	e9 ec 01 00 00       	jmp    74db2a <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x82a>
  74d93e:	49 89 c7             	mov    %rax,%r15
  74d941:	e9 c4 01 00 00       	jmp    74db0a <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x80a>
  74d946:	49 89 c7             	mov    %rax,%r15
  74d949:	e9 8e 01 00 00       	jmp    74dadc <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x7dc>
  74d94e:	49 89 c7             	mov    %rax,%r15
  74d951:	e9 7a 01 00 00       	jmp    74dad0 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x7d0>
  74d956:	49 89 c7             	mov    %rax,%r15
  74d959:	e9 66 01 00 00       	jmp    74dac4 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x7c4>
  74d95e:	49 89 c7             	mov    %rax,%r15
  74d961:	e9 52 01 00 00       	jmp    74dab8 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x7b8>
  74d966:	49 89 c7             	mov    %rax,%r15
  74d969:	e9 3e 01 00 00       	jmp    74daac <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x7ac>
  74d96e:	e9 2a 01 00 00       	jmp    74da9d <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x79d>
  74d973:	49 89 c7             	mov    %rax,%r15
  74d976:	e9 02 01 00 00       	jmp    74da7d <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x77d>
  74d97b:	49 89 c7             	mov    %rax,%r15
  74d97e:	49 8b 04 24          	mov    (%r12),%rax
  74d982:	48 85 c0             	test   %rax,%rax
  74d985:	0f 84 e6 00 00 00    	je     74da71 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x771>
  74d98b:	49 8b be b0 02 00 00 	mov    0x2b0(%r14),%rdi
  74d992:	48 c1 e0 04          	shl    $0x4,%rax
  74d996:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  74d99a:	ba 08 00 00 00       	mov    $0x8,%edx
  74d99f:	ff 15 a3 b9 3d 00    	call   *0x3db9a3(%rip)        # b29348 <_DYNAMIC+0x248>
  74d9a5:	e9 c7 00 00 00       	jmp    74da71 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x771>
  74d9aa:	49 89 c7             	mov    %rax,%r15
  74d9ad:	49 8b 04 24          	mov    (%r12),%rax
  74d9b1:	48 85 c0             	test   %rax,%rax
  74d9b4:	0f 84 9f 00 00 00    	je     74da59 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x759>
  74d9ba:	49 8b be 98 02 00 00 	mov    0x298(%r14),%rdi
  74d9c1:	48 c1 e0 03          	shl    $0x3,%rax
  74d9c5:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  74d9c9:	ba 08 00 00 00       	mov    $0x8,%edx
  74d9ce:	ff 15 74 b9 3d 00    	call   *0x3db974(%rip)        # b29348 <_DYNAMIC+0x248>
  74d9d4:	e9 80 00 00 00       	jmp    74da59 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x759>
  74d9d9:	49 89 c7             	mov    %rax,%r15
  74d9dc:	49 8b 34 24          	mov    (%r12),%rsi
  74d9e0:	48 85 f6             	test   %rsi,%rsi
  74d9e3:	74 68                	je     74da4d <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x74d>
  74d9e5:	49 8b be 78 02 00 00 	mov    0x278(%r14),%rdi
  74d9ec:	48 c1 e6 04          	shl    $0x4,%rsi
  74d9f0:	ba 08 00 00 00       	mov    $0x8,%edx
  74d9f5:	ff 15 4d b9 3d 00    	call   *0x3db94d(%rip)        # b29348 <_DYNAMIC+0x248>
  74d9fb:	eb 50                	jmp    74da4d <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x74d>
  74d9fd:	49 89 c7             	mov    %rax,%r15
  74da00:	49 8b 34 24          	mov    (%r12),%rsi
  74da04:	48 85 f6             	test   %rsi,%rsi
  74da07:	74 16                	je     74da1f <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x71f>
  74da09:	49 8b be 48 02 00 00 	mov    0x248(%r14),%rdi
  74da10:	48 c1 e6 04          	shl    $0x4,%rsi
  74da14:	ba 08 00 00 00       	mov    $0x8,%edx
  74da19:	ff 15 29 b9 3d 00    	call   *0x3db929(%rip)        # b29348 <_DYNAMIC+0x248>
  74da1f:	49 8b b6 58 02 00 00 	mov    0x258(%r14),%rsi
  74da26:	48 85 f6             	test   %rsi,%rsi
  74da29:	74 16                	je     74da41 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x741>
  74da2b:	49 8b be 60 02 00 00 	mov    0x260(%r14),%rdi
  74da32:	48 c1 e6 03          	shl    $0x3,%rsi
  74da36:	ba 08 00 00 00       	mov    $0x8,%edx
  74da3b:	ff 15 07 b9 3d 00    	call   *0x3db907(%rip)        # b29348 <_DYNAMIC+0x248>
  74da41:	49 8d be 70 02 00 00 	lea    0x270(%r14),%rdi
  74da48:	e8 d3 1f 00 00       	call   74fa20 <core::ptr::drop_glue::<alloc::vec::Vec<alloc::boxed::Box<dyn gpui::source::ComponentSchema<unit_action_cost_two::Model>>>>>
  74da4d:	49 8d be 90 02 00 00 	lea    0x290(%r14),%rdi
  74da54:	e8 b7 21 00 00       	call   74fc10 <core::ptr::drop_glue::<alloc::vec::Vec<gpui::runtime::Node>>>
  74da59:	49 8d be 00 02 00 00 	lea    0x200(%r14),%rdi
  74da60:	e8 1b 32 00 00       	call   750c80 <core::ptr::drop_glue::<gpui::runtime::styles::Styles>>
  74da65:	49 8d be a8 02 00 00 	lea    0x2a8(%r14),%rdi
  74da6c:	e8 df 1e 00 00       	call   74f950 <core::ptr::drop_glue::<alloc::vec::Vec<core::option::Option<gpui::runtime::TextSite>>>>
  74da71:	49 8b be c0 05 00 00 	mov    0x5c0(%r14),%rdi
  74da78:	e8 33 17 00 00       	call   74f1b0 <core::ptr::drop_glue::<core::option::Option<alloc::boxed::Box<gpui::runtime::image::Images>>>>
  74da7d:	49 8d be e8 01 00 00 	lea    0x1e8(%r14),%rdi
  74da84:	e8 f7 30 00 00       	call   750b80 <core::ptr::drop_glue::<gpui::runtime::identity_index::IdentityIndex>>
  74da89:	49 8d be c8 05 00 00 	lea    0x5c8(%r14),%rdi
  74da90:	e8 cb 9e ff ff       	call   747960 <<alloc::collections::btree::map::BTreeMap<gpui::source::FieldId, gpui::runtime::Fanout> as core::ops::drop::Drop>::drop>
  74da95:	eb 09                	jmp    74daa0 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x7a0>
  74da97:	ff 15 db b8 3d 00    	call   *0x3db8db(%rip)        # b29378 <_DYNAMIC+0x278>
  74da9d:	49 89 c7             	mov    %rax,%r15
  74daa0:	49 8d be f8 05 00 00 	lea    0x5f8(%r14),%rdi
  74daa7:	e8 14 b6 ff ff       	call   7490c0 <<alloc::collections::btree::map::BTreeMap<u64, gpui::property::Overlay<gpui::style::Style>> as core::ops::drop::Drop>::drop>
  74daac:	49 8b be 10 06 00 00 	mov    0x610(%r14),%rdi
  74dab3:	e8 98 1a 00 00       	call   74f550 <core::ptr::drop_glue::<core::option::Option<alloc::boxed::Box<gpui::runtime::metadata::Metadata>>>>
  74dab8:	49 8d be 18 06 00 00 	lea    0x618(%r14),%rdi
  74dabf:	e8 2c a6 ff ff       	call   7480f0 <<alloc::collections::btree::map::BTreeMap<gpui::runtime::scroll::ViewportKey, gpui::runtime::scroll::ViewportState> as core::ops::drop::Drop>::drop>
  74dac4:	49 8d be 30 06 00 00 	lea    0x630(%r14),%rdi
  74dacb:	e8 90 a9 ff ff       	call   748460 <<alloc::collections::btree::map::BTreeMap<(core::option::Option<u64>, gpui::list::ListId, gpui::element::NodeKind), usize> as core::ops::drop::Drop>::drop>
  74dad0:	49 8d be c0 02 00 00 	lea    0x2c0(%r14),%rdi
  74dad7:	e8 c4 25 00 00       	call   7500a0 <core::ptr::drop_glue::<gpui_reactivity_core::layout::LayoutTree>>
  74dadc:	49 8b b6 58 05 00 00 	mov    0x558(%r14),%rsi
  74dae3:	48 85 f6             	test   %rsi,%rsi
  74dae6:	74 16                	je     74dafe <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x7fe>
  74dae8:	49 8b be 60 05 00 00 	mov    0x560(%r14),%rdi
  74daef:	48 c1 e6 04          	shl    $0x4,%rsi
  74daf3:	ba 08 00 00 00       	mov    $0x8,%edx
  74daf8:	ff 15 4a b8 3d 00    	call   *0x3db84a(%rip)        # b29348 <_DYNAMIC+0x248>
  74dafe:	49 8d be 48 06 00 00 	lea    0x648(%r14),%rdi
  74db05:	e8 66 9a ff ff       	call   747570 <<alloc::collections::btree::map::BTreeMap<gpui::list::ListId, alloc::collections::btree::set_val::SetValZST> as core::ops::drop::Drop>::drop>
  74db0a:	49 8d be 88 05 00 00 	lea    0x588(%r14),%rdi
  74db11:	e8 5a 1c 00 00       	call   74f770 <core::ptr::drop_glue::<core::option::Option<gpui::runtime::Prepared>>>
  74db16:	49 8d be 70 05 00 00 	lea    0x570(%r14),%rdi
  74db1d:	e8 5e 21 00 00       	call   74fc80 <core::ptr::drop_glue::<alloc::vec::Vec<gpui::runtime::Presented>>>
  74db22:	4c 89 f7             	mov    %r14,%rdi
  74db25:	e8 26 2b 00 00       	call   750650 <core::ptr::drop_glue::<gpui_canvas::canvas::Canvas>>
  74db2a:	49 8b be 98 06 00 00 	mov    0x698(%r14),%rdi
  74db31:	e8 3a 14 00 00       	call   74ef70 <core::ptr::drop_glue::<core::option::Option<alloc::boxed::Box<gpui::runtime::text_geometry::TextResources>>>>
  74db36:	be 28 07 00 00       	mov    $0x728,%esi
  74db3b:	ba 08 00 00 00       	mov    $0x8,%edx
  74db40:	4c 89 f7             	mov    %r14,%rdi
  74db43:	ff 15 ff b7 3d 00    	call   *0x3db7ff(%rip)        # b29348 <_DYNAMIC+0x248>
  74db49:	48 c7 03 01 00 00 00 	movq   $0x1,(%rbx)
  74db50:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  74db55:	48 89 43 08          	mov    %rax,0x8(%rbx)
  74db59:	4c 89 ff             	mov    %r15,%rdi
  74db5c:	e8 7f b9 3a 00       	call   af94e0 <_Unwind_Resume@plt>
  74db61:	ff 15 11 b8 3d 00    	call   *0x3db811(%rip)        # b29378 <_DYNAMIC+0x278>
  74db67:	49 89 c7             	mov    %rax,%r15
  74db6a:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  74db6f:	e8 6c 2e 00 00       	call   7509e0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  74db74:	4c 89 ff             	mov    %r15,%rdi
  74db77:	e8 64 b9 3a 00       	call   af94e0 <_Unwind_Resume@plt>
  74db7c:	64 49 ff 04 24       	incq   %fs:(%r12)
  74db81:	48 89 c7             	mov    %rax,%rdi
  74db84:	e8 57 b9 3a 00       	call   af94e0 <_Unwind_Resume@plt>
