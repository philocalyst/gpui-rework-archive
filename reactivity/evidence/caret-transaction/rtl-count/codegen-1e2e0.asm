
/tmp/gpui-caret-transaction-bin/d54-codegen:     file format elf64-x86-64


Disassembly of section .text:

000000000001e2e0 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<()>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<false, (), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>::{closure#2}>>:
   1e2e0:	55                   	push   %rbp
   1e2e1:	41 57                	push   %r15
   1e2e3:	41 56                	push   %r14
   1e2e5:	41 55                	push   %r13
   1e2e7:	41 54                	push   %r12
   1e2e9:	53                   	push   %rbx
   1e2ea:	48 81 ec 18 02 00 00 	sub    $0x218,%rsp
   1e2f1:	48 89 d3             	mov    %rdx,%rbx
   1e2f4:	89 f2                	mov    %esi,%edx
   1e2f6:	48 89 fe             	mov    %rdi,%rsi
   1e2f9:	4c 8d bc 24 08 01 00 	lea    0x108(%rsp),%r15
   1e300:	00 
   1e301:	4c 89 ff             	mov    %r15,%rdi
   1e304:	e8 37 14 00 00       	call   1f740 <<parley::layout::run::Clusters<()>>::new>
   1e309:	48 8b 03             	mov    (%rbx),%rax
   1e30c:	48 89 84 24 80 00 00 	mov    %rax,0x80(%rsp)
   1e313:	00 
   1e314:	48 8b 43 08          	mov    0x8(%rbx),%rax
   1e318:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
   1e31d:	48 8b 43 20          	mov    0x20(%rbx),%rax
   1e321:	48 89 44 24 78       	mov    %rax,0x78(%rsp)
   1e326:	48 8b 43 28          	mov    0x28(%rbx),%rax
   1e32a:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
   1e32f:	48 8b 43 30          	mov    0x30(%rbx),%rax
   1e333:	48 89 44 24 58       	mov    %rax,0x58(%rsp)
   1e338:	4c 8b 63 40          	mov    0x40(%rbx),%r12
   1e33c:	4c 8b 73 48          	mov    0x48(%rbx),%r14
   1e340:	48 8b 43 50          	mov    0x50(%rbx),%rax
   1e344:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
   1e349:	4c 8b 6b 78          	mov    0x78(%rbx),%r13
   1e34d:	48 8b 83 80 00 00 00 	mov    0x80(%rbx),%rax
   1e354:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
   1e359:	48 8b 43 38          	mov    0x38(%rbx),%rax
   1e35d:	48 89 44 24 48       	mov    %rax,0x48(%rsp)
   1e362:	48 8b 43 60          	mov    0x60(%rbx),%rax
   1e366:	48 89 44 24 60       	mov    %rax,0x60(%rsp)
   1e36b:	48 8b 43 68          	mov    0x68(%rbx),%rax
   1e36f:	48 89 44 24 70       	mov    %rax,0x70(%rsp)
   1e374:	48 8b 43 70          	mov    0x70(%rbx),%rax
   1e378:	48 89 44 24 50       	mov    %rax,0x50(%rsp)
   1e37d:	48 8b 43 58          	mov    0x58(%rbx),%rax
   1e381:	48 89 44 24 68       	mov    %rax,0x68(%rsp)
   1e386:	48 8d bc 24 8c 00 00 	lea    0x8c(%rsp),%rdi
   1e38d:	00 
   1e38e:	4c 89 fe             	mov    %r15,%rsi
   1e391:	e8 9a 16 00 00       	call   1fa30 <<parley::layout::run::Clusters<()>>::advance_cursor>
   1e396:	83 bc 24 8c 00 00 00 	cmpl   $0x1,0x8c(%rsp)
   1e39d:	01 
   1e39e:	0f 85 e3 04 00 00    	jne    1e887 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<()>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<false, (), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>::{closure#2}>+0x5a7>
   1e3a4:	49 8d 45 04          	lea    0x4(%r13),%rax
   1e3a8:	48 89 44 24 38       	mov    %rax,0x38(%rsp)
   1e3ad:	eb 2f                	jmp    1e3de <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<()>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<false, (), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>::{closure#2}>+0xfe>
   1e3af:	90                   	nop
   1e3b0:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
   1e3b5:	c6 00 00             	movb   $0x0,(%rax)
   1e3b8:	48 8d bc 24 8c 00 00 	lea    0x8c(%rsp),%rdi
   1e3bf:	00 
   1e3c0:	4c 8d bc 24 08 01 00 	lea    0x108(%rsp),%r15
   1e3c7:	00 
   1e3c8:	4c 89 fe             	mov    %r15,%rsi
   1e3cb:	e8 60 16 00 00       	call   1fa30 <<parley::layout::run::Clusters<()>>::advance_cursor>
   1e3d0:	80 bc 24 8c 00 00 00 	cmpb   $0x0,0x8c(%rsp)
   1e3d7:	00 
   1e3d8:	0f 84 a9 04 00 00    	je     1e887 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<()>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<false, (), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>::{closure#2}>+0x5a7>
   1e3de:	48 83 bc 24 c0 01 00 	cmpq   $0x0,0x1c0(%rsp)
   1e3e5:	00 00 
   1e3e7:	0f 84 cb 04 00 00    	je     1e8b8 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<()>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<false, (), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>::{closure#2}>+0x5d8>
   1e3ed:	4c 89 bc 24 e8 00 00 	mov    %r15,0xe8(%rsp)
   1e3f4:	00 
   1e3f5:	48 8d 84 24 c0 01 00 	lea    0x1c0(%rsp),%rax
   1e3fc:	00 
   1e3fd:	48 89 84 24 f0 00 00 	mov    %rax,0xf0(%rsp)
   1e404:	00 
   1e405:	48 8d 84 24 90 00 00 	lea    0x90(%rsp),%rax
   1e40c:	00 
   1e40d:	0f 10 00             	movups (%rax),%xmm0
   1e410:	48 8d 84 24 f8 00 00 	lea    0xf8(%rsp),%rax
   1e417:	00 
   1e418:	0f 11 00             	movups %xmm0,(%rax)
   1e41b:	8b ac 24 f8 00 00 00 	mov    0xf8(%rsp),%ebp
   1e422:	8b 94 24 fc 00 00 00 	mov    0xfc(%rsp),%edx
   1e429:	48 8b bc 24 80 00 00 	mov    0x80(%rsp),%rdi
   1e430:	00 
   1e431:	89 ee                	mov    %ebp,%esi
   1e433:	ff 15 d7 1f 04 00    	call   *0x41fd7(%rip)        # 60410 <_DYNAMIC+0x248>
   1e439:	48 89 c3             	mov    %rax,%rbx
   1e43c:	49 89 d7             	mov    %rdx,%r15
   1e43f:	48 8b 84 24 10 01 00 	mov    0x110(%rsp),%rax
   1e446:	00 
   1e447:	0f b6 80 8c 00 00 00 	movzbl 0x8c(%rax),%eax
   1e44e:	88 44 24 07          	mov    %al,0x7(%rsp)
   1e452:	a8 01                	test   $0x1,%al
   1e454:	75 5a                	jne    1e4b0 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<()>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<false, (), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>::{closure#2}>+0x1d0>
   1e456:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
   1e45b:	f3 0f 10 00          	movss  (%rax),%xmm0
   1e45f:	f3 0f 11 44 24 08    	movss  %xmm0,0x8(%rsp)
   1e465:	48 83 bc 24 20 01 00 	cmpq   $0x0,0x120(%rsp)
   1e46c:	00 00 
   1e46e:	0f 84 81 00 00 00    	je     1e4f5 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<()>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<false, (), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>::{closure#2}>+0x215>
   1e474:	48 8b 84 24 08 01 00 	mov    0x108(%rsp),%rax
   1e47b:	00 
   1e47c:	8b bc 24 28 01 00 00 	mov    0x128(%rsp),%edi
   1e483:	48 8b b0 18 01 00 00 	mov    0x118(%rax),%rsi
   1e48a:	48 39 fe             	cmp    %rdi,%rsi
   1e48d:	0f 86 4b 04 00 00    	jbe    1e8de <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<()>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<false, (), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>::{closure#2}>+0x5fe>
   1e493:	48 8b 80 10 01 00 00 	mov    0x110(%rax),%rax
   1e49a:	48 6b cf 70          	imul   $0x70,%rdi,%rcx
   1e49e:	f3 0f 10 44 08 50    	movss  0x50(%rax,%rcx,1),%xmm0
   1e4a4:	8b 44 08 54          	mov    0x54(%rax,%rcx,1),%eax
   1e4a8:	eb 53                	jmp    1e4fd <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<()>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<false, (), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>::{closure#2}>+0x21d>
   1e4aa:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
   1e4b0:	48 8b 4c 24 78       	mov    0x78(%rsp),%rcx
   1e4b5:	48 8b 71 10          	mov    0x10(%rcx),%rsi
   1e4b9:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
   1e4be:	48 8b 00             	mov    (%rax),%rax
   1e4c1:	48 89 c7             	mov    %rax,%rdi
   1e4c4:	48 f7 d7             	not    %rdi
   1e4c7:	48 01 f7             	add    %rsi,%rdi
   1e4ca:	0f 83 01 04 00 00    	jae    1e8d1 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<()>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<false, (), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>::{closure#2}>+0x5f1>
   1e4d0:	48 8b 49 08          	mov    0x8(%rcx),%rcx
   1e4d4:	f3 0f 10 04 b9       	movss  (%rcx,%rdi,4),%xmm0
   1e4d9:	f3 0f 11 44 24 08    	movss  %xmm0,0x8(%rsp)
   1e4df:	48 8b 4c 24 30       	mov    0x30(%rsp),%rcx
   1e4e4:	48 ff c0             	inc    %rax
   1e4e7:	48 89 01             	mov    %rax,(%rcx)
   1e4ea:	4c 39 fb             	cmp    %r15,%rbx
   1e4ed:	0f 83 bd fe ff ff    	jae    1e3b0 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<()>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<false, (), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>::{closure#2}>+0xd0>
   1e4f3:	eb 66                	jmp    1e55b <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<()>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<false, (), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>::{closure#2}>+0x27b>
   1e4f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
   1e4fa:	0f 57 c0             	xorps  %xmm0,%xmm0
   1e4fd:	48 8b 8c 24 18 01 00 	mov    0x118(%rsp),%rcx
   1e504:	00 
   1e505:	f2 0f 10 49 44       	movsd  0x44(%rcx),%xmm1
   1e50a:	f2 0f 11 4c 24 20    	movsd  %xmm1,0x20(%rsp)
   1e510:	f3 0f 11 44 24 28    	movss  %xmm0,0x28(%rsp)
   1e516:	89 44 24 2c          	mov    %eax,0x2c(%rsp)
   1e51a:	48 8d 7c 24 20       	lea    0x20(%rsp),%rdi
   1e51f:	48 8d b4 24 c0 01 00 	lea    0x1c0(%rsp),%rsi
   1e526:	00 
   1e527:	48 8d 94 24 f8 00 00 	lea    0xf8(%rsp),%rdx
   1e52e:	00 
   1e52f:	31 c9                	xor    %ecx,%ecx
   1e531:	ff 15 e9 1e 04 00    	call   *0x41ee9(%rip)        # 60420 <_DYNAMIC+0x258>
   1e537:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
   1e53c:	f3 0f 58 00          	addss  (%rax),%xmm0
   1e540:	f3 0f 11 00          	movss  %xmm0,(%rax)
   1e544:	48 8b 4c 24 30       	mov    0x30(%rsp),%rcx
   1e549:	48 8b 01             	mov    (%rcx),%rax
   1e54c:	48 ff c0             	inc    %rax
   1e54f:	48 89 01             	mov    %rax,(%rcx)
   1e552:	4c 39 fb             	cmp    %r15,%rbx
   1e555:	0f 83 55 fe ff ff    	jae    1e3b0 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<()>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<false, (), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>::{closure#2}>+0xd0>
   1e55b:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
   1e560:	48 83 b8 50 01 00 00 	cmpq   $0x0,0x150(%rax)
   1e567:	00 
   1e568:	0f 84 42 fe ff ff    	je     1e3b0 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<()>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<false, (), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>::{closure#2}>+0xd0>
   1e56e:	48 8b 84 24 28 01 00 	mov    0x128(%rsp),%rax
   1e575:	00 
   1e576:	48 89 44 24 20       	mov    %rax,0x20(%rsp)
   1e57b:	89 6c 24 28          	mov    %ebp,0x28(%rsp)
   1e57f:	f3 0f 10 44 24 08    	movss  0x8(%rsp),%xmm0
   1e585:	f3 0f 11 44 24 2c    	movss  %xmm0,0x2c(%rsp)
   1e58b:	0f b7 84 24 04 01 00 	movzwl 0x104(%rsp),%eax
   1e592:	00 
   1e593:	83 e0 0e             	and    $0xe,%eax
   1e596:	89 44 24 0c          	mov    %eax,0xc(%rsp)
   1e59a:	eb 07                	jmp    1e5a3 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<()>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<false, (), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>::{closure#2}>+0x2c3>
   1e59c:	0f 1f 40 00          	nopl   0x0(%rax)
   1e5a0:	48 89 28             	mov    %rbp,(%rax)
   1e5a3:	49 8b 0c 24          	mov    (%r12),%rcx
   1e5a7:	48 83 f9 02          	cmp    $0x2,%rcx
   1e5ab:	75 39                	jne    1e5e6 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<()>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<false, (), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>::{closure#2}>+0x306>
   1e5ad:	41 80 7c 24 20 00    	cmpb   $0x0,0x20(%r12)
   1e5b3:	75 0c                	jne    1e5c1 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<()>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<false, (), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>::{closure#2}>+0x2e1>
   1e5b5:	49 8b 44 24 10       	mov    0x10(%r12),%rax
   1e5ba:	49 3b 44 24 18       	cmp    0x18(%r12),%rax
   1e5bf:	76 04                	jbe    1e5c5 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<()>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<false, (), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>::{closure#2}>+0x2e5>
   1e5c1:	31 c9                	xor    %ecx,%ecx
   1e5c3:	eb 18                	jmp    1e5dd <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<()>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<false, (), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>::{closure#2}>+0x2fd>
   1e5c5:	73 0b                	jae    1e5d2 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<()>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<false, (), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>::{closure#2}>+0x2f2>
   1e5c7:	48 8d 48 01          	lea    0x1(%rax),%rcx
   1e5cb:	49 89 4c 24 10       	mov    %rcx,0x10(%r12)
   1e5d0:	eb 06                	jmp    1e5d8 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<()>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<false, (), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>::{closure#2}>+0x2f8>
   1e5d2:	41 c6 44 24 20 01    	movb   $0x1,0x20(%r12)
   1e5d8:	b9 01 00 00 00       	mov    $0x1,%ecx
   1e5dd:	49 89 0c 24          	mov    %rcx,(%r12)
   1e5e1:	49 89 44 24 08       	mov    %rax,0x8(%r12)
   1e5e6:	83 f9 01             	cmp    $0x1,%ecx
   1e5e9:	0f 85 51 02 00 00    	jne    1e840 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<()>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<false, (), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>::{closure#2}>+0x560>
   1e5ef:	49 8b 6c 24 08       	mov    0x8(%r12),%rbp
   1e5f4:	4c 39 fd             	cmp    %r15,%rbp
   1e5f7:	0f 83 43 02 00 00    	jae    1e840 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<()>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<false, (), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>::{closure#2}>+0x560>
   1e5fd:	41 80 3e 00          	cmpb   $0x0,(%r14)
   1e601:	74 0a                	je     1e60d <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<()>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<false, (), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>::{closure#2}>+0x32d>
   1e603:	49 3b 6e 08          	cmp    0x8(%r14),%rbp
   1e607:	0f 82 7e 02 00 00    	jb     1e88b <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<()>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<false, (), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>::{closure#2}>+0x5ab>
   1e60d:	49 c7 04 24 02 00 00 	movq   $0x2,(%r12)
   1e614:	00 
   1e615:	49 c7 06 01 00 00 00 	movq   $0x1,(%r14)
   1e61c:	49 89 6e 08          	mov    %rbp,0x8(%r14)
   1e620:	48 39 dd             	cmp    %rbx,%rbp
   1e623:	75 7b                	jne    1e6a0 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<()>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<false, (), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>::{closure#2}>+0x3c0>
   1e625:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
   1e62a:	80 38 00             	cmpb   $0x0,(%rax)
   1e62d:	74 1c                	je     1e64b <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<()>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<false, (), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>::{closure#2}>+0x36b>
   1e62f:	66 83 7c 24 0c 0c    	cmpw   $0xc,0xc(%rsp)
   1e635:	0f 94 c0             	sete   %al
   1e638:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
   1e63d:	48 39 19             	cmp    %rbx,(%rcx)
   1e640:	0f 95 c1             	setne  %cl
   1e643:	08 c1                	or     %al,%cl
   1e645:	0f 84 bc 00 00 00    	je     1e707 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<()>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<false, (), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>::{closure#2}>+0x427>
   1e64b:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
   1e650:	48 39 18             	cmp    %rbx,(%rax)
   1e653:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
   1e658:	f3 0f 10 00          	movss  (%rax),%xmm0
   1e65c:	b9 00 00 00 00       	mov    $0x0,%ecx
   1e661:	48 0f 44 4c 24 38    	cmove  0x38(%rsp),%rcx
   1e667:	41 80 7d 00 00       	cmpb   $0x0,0x0(%r13)
   1e66c:	b8 00 00 00 00       	mov    $0x0,%eax
   1e671:	48 0f 44 c8          	cmove  %rax,%rcx
   1e675:	48 8d bc 24 a0 00 00 	lea    0xa0(%rsp),%rdi
   1e67c:	00 
   1e67d:	48 8b 74 24 18       	mov    0x18(%rsp),%rsi
   1e682:	48 89 da             	mov    %rbx,%rdx
   1e685:	4c 8d 44 24 20       	lea    0x20(%rsp),%r8
   1e68a:	e8 d1 f7 ff ff       	call   1de60 <parley::editing::geometry::pair_from_entries::<()>>
   1e68f:	e9 4c 01 00 00       	jmp    1e7e0 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<()>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<false, (), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>::{closure#2}>+0x500>
   1e694:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
   1e69b:	00 00 00 00 00 
   1e6a0:	76 1e                	jbe    1e6c0 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<()>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<false, (), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>::{closure#2}>+0x3e0>
   1e6a2:	48 c7 84 24 a0 00 00 	movq   $0x0,0xa0(%rsp)
   1e6a9:	00 00 00 00 00 
   1e6ae:	e9 2d 01 00 00       	jmp    1e7e0 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<()>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<false, (), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>::{closure#2}>+0x500>
   1e6b3:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   1e6ba:	84 00 00 00 00 00 
   1e6c0:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
   1e6c5:	48 39 28             	cmp    %rbp,(%rax)
   1e6c8:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
   1e6cd:	f3 0f 10 00          	movss  (%rax),%xmm0
   1e6d1:	b9 00 00 00 00       	mov    $0x0,%ecx
   1e6d6:	48 0f 44 4c 24 38    	cmove  0x38(%rsp),%rcx
   1e6dc:	41 80 7d 00 00       	cmpb   $0x0,0x0(%r13)
   1e6e1:	b8 00 00 00 00       	mov    $0x0,%eax
   1e6e6:	48 0f 44 c8          	cmove  %rax,%rcx
   1e6ea:	48 8d bc 24 a0 00 00 	lea    0xa0(%rsp),%rdi
   1e6f1:	00 
   1e6f2:	48 8b 74 24 18       	mov    0x18(%rsp),%rsi
   1e6f7:	48 89 ea             	mov    %rbp,%rdx
   1e6fa:	45 31 c0             	xor    %r8d,%r8d
   1e6fd:	e8 5e f7 ff ff       	call   1de60 <parley::editing::geometry::pair_from_entries::<()>>
   1e702:	e9 d9 00 00 00       	jmp    1e7e0 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<()>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<false, (), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>::{closure#2}>+0x500>
   1e707:	f3 0f 10 44 24 08    	movss  0x8(%rsp),%xmm0
   1e70d:	f6 44 24 07 01       	testb  $0x1,0x7(%rsp)
   1e712:	74 09                	je     1e71d <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<()>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<false, (), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>::{closure#2}>+0x43d>
   1e714:	48 8b 44 24 50       	mov    0x50(%rsp),%rax
   1e719:	f3 0f 10 00          	movss  (%rax),%xmm0
   1e71d:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
   1e722:	48 8b 40 08          	mov    0x8(%rax),%rax
   1e726:	0f 57 c9             	xorps  %xmm1,%xmm1
   1e729:	f3 0f 5a c8          	cvtss2sd %xmm0,%xmm1
   1e72d:	f3 0f 10 50 40       	movss  0x40(%rax),%xmm2
   1e732:	f3 0f 10 58 44       	movss  0x44(%rax),%xmm3
   1e737:	0f 28 e2             	movaps %xmm2,%xmm4
   1e73a:	f3 0f 5d 60 48       	minss  0x48(%rax),%xmm4
   1e73f:	0f 28 ec             	movaps %xmm4,%xmm5
   1e742:	f3 0f c2 ec 03       	cmpunordss %xmm4,%xmm5
   1e747:	0f 28 f5             	movaps %xmm5,%xmm6
   1e74a:	0f 55 f4             	andnps %xmm4,%xmm6
   1e74d:	0f 54 ea             	andps  %xmm2,%xmm5
   1e750:	0f 56 ee             	orps   %xmm6,%xmm5
   1e753:	0f 57 d2             	xorps  %xmm2,%xmm2
   1e756:	f3 0f 5a d5          	cvtss2sd %xmm5,%xmm2
   1e75a:	48 8b 4c 24 10       	mov    0x10(%rsp),%rcx
   1e75f:	f3 0f 58 01          	addss  (%rcx),%xmm0
   1e763:	f3 0f 5a c0          	cvtss2sd %xmm0,%xmm0
   1e767:	0f 28 e3             	movaps %xmm3,%xmm4
   1e76a:	f3 0f 5f 60 4c       	maxss  0x4c(%rax),%xmm4
   1e76f:	0f 28 ec             	movaps %xmm4,%xmm5
   1e772:	f3 0f c2 ec 03       	cmpunordss %xmm4,%xmm5
   1e777:	0f 28 f5             	movaps %xmm5,%xmm6
   1e77a:	0f 55 f4             	andnps %xmm4,%xmm6
   1e77d:	0f 54 eb             	andps  %xmm3,%xmm5
   1e780:	0f 56 ee             	orps   %xmm6,%xmm5
   1e783:	0f 57 db             	xorps  %xmm3,%xmm3
   1e786:	f3 0f 5a dd          	cvtss2sd %xmm5,%xmm3
   1e78a:	f2 0f 11 8c 24 a8 00 	movsd  %xmm1,0xa8(%rsp)
   1e791:	00 00 
   1e793:	f2 0f 11 94 24 b0 00 	movsd  %xmm2,0xb0(%rsp)
   1e79a:	00 00 
   1e79c:	f2 0f 11 84 24 b8 00 	movsd  %xmm0,0xb8(%rsp)
   1e7a3:	00 00 
   1e7a5:	f2 0f 11 9c 24 c0 00 	movsd  %xmm3,0xc0(%rsp)
   1e7ac:	00 00 
   1e7ae:	f2 0f 11 8c 24 c8 00 	movsd  %xmm1,0xc8(%rsp)
   1e7b5:	00 00 
   1e7b7:	f2 0f 11 94 24 d0 00 	movsd  %xmm2,0xd0(%rsp)
   1e7be:	00 00 
   1e7c0:	f2 0f 11 84 24 d8 00 	movsd  %xmm0,0xd8(%rsp)
   1e7c7:	00 00 
   1e7c9:	f2 0f 11 9c 24 e0 00 	movsd  %xmm3,0xe0(%rsp)
   1e7d0:	00 00 
   1e7d2:	48 c7 84 24 a0 00 00 	movq   $0x1,0xa0(%rsp)
   1e7d9:	00 01 00 00 00 
   1e7de:	66 90                	xchg   %ax,%ax
   1e7e0:	48 8b 44 24 68       	mov    0x68(%rsp),%rax
   1e7e5:	48 8b 00             	mov    (%rax),%rax
   1e7e8:	48 33 28             	xor    (%rax),%rbp
   1e7eb:	48 83 bc 24 a0 00 00 	cmpq   $0x1,0xa0(%rsp)
   1e7f2:	00 01 
   1e7f4:	0f 85 a6 fd ff ff    	jne    1e5a0 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<()>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<false, (), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>::{closure#2}>+0x2c0>
   1e7fa:	f3 0f 6f 84 24 a8 00 	movdqu 0xa8(%rsp),%xmm0
   1e801:	00 00 
   1e803:	f3 0f 6f 8c 24 b8 00 	movdqu 0xb8(%rsp),%xmm1
   1e80a:	00 00 
   1e80c:	f3 0f 6f 94 24 c8 00 	movdqu 0xc8(%rsp),%xmm2
   1e813:	00 00 
   1e815:	66 0f ef d0          	pxor   %xmm0,%xmm2
   1e819:	f3 0f 6f 84 24 d8 00 	movdqu 0xd8(%rsp),%xmm0
   1e820:	00 00 
   1e822:	66 0f ef c1          	pxor   %xmm1,%xmm0
   1e826:	66 0f ef c2          	pxor   %xmm2,%xmm0
   1e82a:	66 0f 70 c8 ee       	pshufd $0xee,%xmm0,%xmm1
   1e82f:	66 0f ef c8          	pxor   %xmm0,%xmm1
   1e833:	66 48 0f 7e c9       	movq   %xmm1,%rcx
   1e838:	48 31 cd             	xor    %rcx,%rbp
   1e83b:	e9 60 fd ff ff       	jmp    1e5a0 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<()>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<false, (), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>::{closure#2}>+0x2c0>
   1e840:	48 8b 44 24 60       	mov    0x60(%rsp),%rax
   1e845:	4c 89 38             	mov    %r15,(%rax)
   1e848:	48 8b 44 24 50       	mov    0x50(%rsp),%rax
   1e84d:	f3 0f 10 44 24 08    	movss  0x8(%rsp),%xmm0
   1e853:	f3 0f 11 00          	movss  %xmm0,(%rax)
   1e857:	66 83 7c 24 0c 0c    	cmpw   $0xc,0xc(%rsp)
   1e85d:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
   1e862:	0f 95 00             	setne  (%rax)
   1e865:	41 c7 45 00 01 00 00 	movl   $0x1,0x0(%r13)
   1e86c:	00 
   1e86d:	0f 10 44 24 20       	movups 0x20(%rsp),%xmm0
   1e872:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
   1e877:	0f 11 00             	movups %xmm0,(%rax)
   1e87a:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
   1e87f:	4c 89 38             	mov    %r15,(%rax)
   1e882:	e9 31 fb ff ff       	jmp    1e3b8 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<()>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<false, (), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>::{closure#2}>+0xd8>
   1e887:	b0 ff                	mov    $0xff,%al
   1e889:	eb 1b                	jmp    1e8a6 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<()>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<false, (), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>::{closure#2}>+0x5c6>
   1e88b:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
   1e890:	f3 0f 10 00          	movss  (%rax),%xmm0
   1e894:	48 8b 7c 24 18       	mov    0x18(%rsp),%rdi
   1e899:	4c 89 e6             	mov    %r12,%rsi
   1e89c:	48 8b 54 24 68       	mov    0x68(%rsp),%rdx
   1e8a1:	e8 2a e6 ff ff       	call   1ced0 <parley::editing::geometry::visit_direct::<(), (), &mut core::iter::adapters::peekable::Peekable<core::ops::range::RangeInclusive<usize>>, transaction_codegen::atomic::{closure#0}>>
   1e8a6:	48 81 c4 18 02 00 00 	add    $0x218,%rsp
   1e8ad:	5b                   	pop    %rbx
   1e8ae:	41 5c                	pop    %r12
   1e8b0:	41 5d                	pop    %r13
   1e8b2:	41 5e                	pop    %r14
   1e8b4:	41 5f                	pop    %r15
   1e8b6:	5d                   	pop    %rbp
   1e8b7:	c3                   	ret
   1e8b8:	48 8d 3d 4e 7f fe ff 	lea    -0x180b2(%rip),%rdi        # 680d <anon.5cab36dad6fad55fc602ca21d50a03ec.0.llvm.18336280871641450522>
   1e8bf:	48 8d 15 f2 f9 03 00 	lea    0x3f9f2(%rip),%rdx        # 5e2b8 <anon.5cab36dad6fad55fc602ca21d50a03ec.2.llvm.18336280871641450522>
   1e8c6:	be 63 00 00 00       	mov    $0x63,%esi
   1e8cb:	ff 15 37 1b 04 00    	call   *0x41b37(%rip)        # 60408 <_DYNAMIC+0x240>
   1e8d1:	48 8d 15 10 fa 03 00 	lea    0x3fa10(%rip),%rdx        # 5e2e8 <anon.5cab36dad6fad55fc602ca21d50a03ec.3.llvm.18336280871641450522+0x18>
   1e8d8:	ff 15 1a 1b 04 00    	call   *0x41b1a(%rip)        # 603f8 <_DYNAMIC+0x230>
   1e8de:	48 8d 15 eb f9 03 00 	lea    0x3f9eb(%rip),%rdx        # 5e2d0 <anon.5cab36dad6fad55fc602ca21d50a03ec.3.llvm.18336280871641450522>
   1e8e5:	ff 15 0d 1b 04 00    	call   *0x41b0d(%rip)        # 603f8 <_DYNAMIC+0x230>
