
/tmp/gpui-caret-transaction-bin/62e-codegen:     file format elf64-x86-64


Disassembly of section .text:

000000000001e250 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<()>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<false, (), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>::{closure#2}>>:
   1e250:	55                   	push   %rbp
   1e251:	41 57                	push   %r15
   1e253:	41 56                	push   %r14
   1e255:	41 55                	push   %r13
   1e257:	41 54                	push   %r12
   1e259:	53                   	push   %rbx
   1e25a:	48 81 ec 18 02 00 00 	sub    $0x218,%rsp
   1e261:	48 89 d3             	mov    %rdx,%rbx
   1e264:	89 f2                	mov    %esi,%edx
   1e266:	48 89 fe             	mov    %rdi,%rsi
   1e269:	4c 8d bc 24 08 01 00 	lea    0x108(%rsp),%r15
   1e270:	00 
   1e271:	4c 89 ff             	mov    %r15,%rdi
   1e274:	e8 37 14 00 00       	call   1f6b0 <<parley::layout::run::Clusters<()>>::new>
   1e279:	48 8b 03             	mov    (%rbx),%rax
   1e27c:	48 89 84 24 80 00 00 	mov    %rax,0x80(%rsp)
   1e283:	00 
   1e284:	48 8b 43 08          	mov    0x8(%rbx),%rax
   1e288:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
   1e28d:	48 8b 43 20          	mov    0x20(%rbx),%rax
   1e291:	48 89 44 24 78       	mov    %rax,0x78(%rsp)
   1e296:	48 8b 43 28          	mov    0x28(%rbx),%rax
   1e29a:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
   1e29f:	48 8b 43 30          	mov    0x30(%rbx),%rax
   1e2a3:	48 89 44 24 58       	mov    %rax,0x58(%rsp)
   1e2a8:	4c 8b 63 40          	mov    0x40(%rbx),%r12
   1e2ac:	4c 8b 73 48          	mov    0x48(%rbx),%r14
   1e2b0:	48 8b 43 50          	mov    0x50(%rbx),%rax
   1e2b4:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
   1e2b9:	4c 8b 6b 78          	mov    0x78(%rbx),%r13
   1e2bd:	48 8b 83 80 00 00 00 	mov    0x80(%rbx),%rax
   1e2c4:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
   1e2c9:	48 8b 43 38          	mov    0x38(%rbx),%rax
   1e2cd:	48 89 44 24 48       	mov    %rax,0x48(%rsp)
   1e2d2:	48 8b 43 60          	mov    0x60(%rbx),%rax
   1e2d6:	48 89 44 24 60       	mov    %rax,0x60(%rsp)
   1e2db:	48 8b 43 68          	mov    0x68(%rbx),%rax
   1e2df:	48 89 44 24 70       	mov    %rax,0x70(%rsp)
   1e2e4:	48 8b 43 70          	mov    0x70(%rbx),%rax
   1e2e8:	48 89 44 24 50       	mov    %rax,0x50(%rsp)
   1e2ed:	48 8b 43 58          	mov    0x58(%rbx),%rax
   1e2f1:	48 89 44 24 68       	mov    %rax,0x68(%rsp)
   1e2f6:	48 8d bc 24 8c 00 00 	lea    0x8c(%rsp),%rdi
   1e2fd:	00 
   1e2fe:	4c 89 fe             	mov    %r15,%rsi
   1e301:	e8 9a 16 00 00       	call   1f9a0 <<parley::layout::run::Clusters<()>>::advance_cursor>
   1e306:	83 bc 24 8c 00 00 00 	cmpl   $0x1,0x8c(%rsp)
   1e30d:	01 
   1e30e:	0f 85 e3 04 00 00    	jne    1e7f7 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<()>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<false, (), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>::{closure#2}>+0x5a7>
   1e314:	49 8d 45 04          	lea    0x4(%r13),%rax
   1e318:	48 89 44 24 38       	mov    %rax,0x38(%rsp)
   1e31d:	eb 2f                	jmp    1e34e <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<()>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<false, (), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>::{closure#2}>+0xfe>
   1e31f:	90                   	nop
   1e320:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
   1e325:	c6 00 00             	movb   $0x0,(%rax)
   1e328:	48 8d bc 24 8c 00 00 	lea    0x8c(%rsp),%rdi
   1e32f:	00 
   1e330:	4c 8d bc 24 08 01 00 	lea    0x108(%rsp),%r15
   1e337:	00 
   1e338:	4c 89 fe             	mov    %r15,%rsi
   1e33b:	e8 60 16 00 00       	call   1f9a0 <<parley::layout::run::Clusters<()>>::advance_cursor>
   1e340:	80 bc 24 8c 00 00 00 	cmpb   $0x0,0x8c(%rsp)
   1e347:	00 
   1e348:	0f 84 a9 04 00 00    	je     1e7f7 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<()>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<false, (), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>::{closure#2}>+0x5a7>
   1e34e:	48 83 bc 24 c0 01 00 	cmpq   $0x0,0x1c0(%rsp)
   1e355:	00 00 
   1e357:	0f 84 cb 04 00 00    	je     1e828 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<()>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<false, (), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>::{closure#2}>+0x5d8>
   1e35d:	4c 89 bc 24 e8 00 00 	mov    %r15,0xe8(%rsp)
   1e364:	00 
   1e365:	48 8d 84 24 c0 01 00 	lea    0x1c0(%rsp),%rax
   1e36c:	00 
   1e36d:	48 89 84 24 f0 00 00 	mov    %rax,0xf0(%rsp)
   1e374:	00 
   1e375:	48 8d 84 24 90 00 00 	lea    0x90(%rsp),%rax
   1e37c:	00 
   1e37d:	0f 10 00             	movups (%rax),%xmm0
   1e380:	48 8d 84 24 f8 00 00 	lea    0xf8(%rsp),%rax
   1e387:	00 
   1e388:	0f 11 00             	movups %xmm0,(%rax)
   1e38b:	8b ac 24 f8 00 00 00 	mov    0xf8(%rsp),%ebp
   1e392:	8b 94 24 fc 00 00 00 	mov    0xfc(%rsp),%edx
   1e399:	48 8b bc 24 80 00 00 	mov    0x80(%rsp),%rdi
   1e3a0:	00 
   1e3a1:	89 ee                	mov    %ebp,%esi
   1e3a3:	ff 15 b7 1f 04 00    	call   *0x41fb7(%rip)        # 60360 <_DYNAMIC+0x248>
   1e3a9:	48 89 c3             	mov    %rax,%rbx
   1e3ac:	49 89 d7             	mov    %rdx,%r15
   1e3af:	48 8b 84 24 10 01 00 	mov    0x110(%rsp),%rax
   1e3b6:	00 
   1e3b7:	0f b6 80 8c 00 00 00 	movzbl 0x8c(%rax),%eax
   1e3be:	88 44 24 07          	mov    %al,0x7(%rsp)
   1e3c2:	a8 01                	test   $0x1,%al
   1e3c4:	75 5a                	jne    1e420 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<()>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<false, (), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>::{closure#2}>+0x1d0>
   1e3c6:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
   1e3cb:	f3 0f 10 00          	movss  (%rax),%xmm0
   1e3cf:	f3 0f 11 44 24 08    	movss  %xmm0,0x8(%rsp)
   1e3d5:	48 83 bc 24 20 01 00 	cmpq   $0x0,0x120(%rsp)
   1e3dc:	00 00 
   1e3de:	0f 84 81 00 00 00    	je     1e465 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<()>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<false, (), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>::{closure#2}>+0x215>
   1e3e4:	48 8b 84 24 08 01 00 	mov    0x108(%rsp),%rax
   1e3eb:	00 
   1e3ec:	8b bc 24 28 01 00 00 	mov    0x128(%rsp),%edi
   1e3f3:	48 8b b0 18 01 00 00 	mov    0x118(%rax),%rsi
   1e3fa:	48 39 fe             	cmp    %rdi,%rsi
   1e3fd:	0f 86 4b 04 00 00    	jbe    1e84e <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<()>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<false, (), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>::{closure#2}>+0x5fe>
   1e403:	48 8b 80 10 01 00 00 	mov    0x110(%rax),%rax
   1e40a:	48 6b cf 70          	imul   $0x70,%rdi,%rcx
   1e40e:	f3 0f 10 44 08 50    	movss  0x50(%rax,%rcx,1),%xmm0
   1e414:	8b 44 08 54          	mov    0x54(%rax,%rcx,1),%eax
   1e418:	eb 53                	jmp    1e46d <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<()>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<false, (), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>::{closure#2}>+0x21d>
   1e41a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
   1e420:	48 8b 4c 24 78       	mov    0x78(%rsp),%rcx
   1e425:	48 8b 71 10          	mov    0x10(%rcx),%rsi
   1e429:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
   1e42e:	48 8b 00             	mov    (%rax),%rax
   1e431:	48 89 c7             	mov    %rax,%rdi
   1e434:	48 f7 d7             	not    %rdi
   1e437:	48 01 f7             	add    %rsi,%rdi
   1e43a:	0f 83 01 04 00 00    	jae    1e841 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<()>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<false, (), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>::{closure#2}>+0x5f1>
   1e440:	48 8b 49 08          	mov    0x8(%rcx),%rcx
   1e444:	f3 0f 10 04 b9       	movss  (%rcx,%rdi,4),%xmm0
   1e449:	f3 0f 11 44 24 08    	movss  %xmm0,0x8(%rsp)
   1e44f:	48 8b 4c 24 30       	mov    0x30(%rsp),%rcx
   1e454:	48 ff c0             	inc    %rax
   1e457:	48 89 01             	mov    %rax,(%rcx)
   1e45a:	4c 39 fb             	cmp    %r15,%rbx
   1e45d:	0f 83 bd fe ff ff    	jae    1e320 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<()>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<false, (), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>::{closure#2}>+0xd0>
   1e463:	eb 66                	jmp    1e4cb <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<()>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<false, (), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>::{closure#2}>+0x27b>
   1e465:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
   1e46a:	0f 57 c0             	xorps  %xmm0,%xmm0
   1e46d:	48 8b 8c 24 18 01 00 	mov    0x118(%rsp),%rcx
   1e474:	00 
   1e475:	f2 0f 10 49 44       	movsd  0x44(%rcx),%xmm1
   1e47a:	f2 0f 11 4c 24 20    	movsd  %xmm1,0x20(%rsp)
   1e480:	f3 0f 11 44 24 28    	movss  %xmm0,0x28(%rsp)
   1e486:	89 44 24 2c          	mov    %eax,0x2c(%rsp)
   1e48a:	48 8d 7c 24 20       	lea    0x20(%rsp),%rdi
   1e48f:	48 8d b4 24 c0 01 00 	lea    0x1c0(%rsp),%rsi
   1e496:	00 
   1e497:	48 8d 94 24 f8 00 00 	lea    0xf8(%rsp),%rdx
   1e49e:	00 
   1e49f:	31 c9                	xor    %ecx,%ecx
   1e4a1:	ff 15 c9 1e 04 00    	call   *0x41ec9(%rip)        # 60370 <_DYNAMIC+0x258>
   1e4a7:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
   1e4ac:	f3 0f 58 00          	addss  (%rax),%xmm0
   1e4b0:	f3 0f 11 00          	movss  %xmm0,(%rax)
   1e4b4:	48 8b 4c 24 30       	mov    0x30(%rsp),%rcx
   1e4b9:	48 8b 01             	mov    (%rcx),%rax
   1e4bc:	48 ff c0             	inc    %rax
   1e4bf:	48 89 01             	mov    %rax,(%rcx)
   1e4c2:	4c 39 fb             	cmp    %r15,%rbx
   1e4c5:	0f 83 55 fe ff ff    	jae    1e320 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<()>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<false, (), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>::{closure#2}>+0xd0>
   1e4cb:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
   1e4d0:	48 83 b8 50 01 00 00 	cmpq   $0x0,0x150(%rax)
   1e4d7:	00 
   1e4d8:	0f 84 42 fe ff ff    	je     1e320 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<()>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<false, (), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>::{closure#2}>+0xd0>
   1e4de:	48 8b 84 24 28 01 00 	mov    0x128(%rsp),%rax
   1e4e5:	00 
   1e4e6:	48 89 44 24 20       	mov    %rax,0x20(%rsp)
   1e4eb:	89 6c 24 28          	mov    %ebp,0x28(%rsp)
   1e4ef:	f3 0f 10 44 24 08    	movss  0x8(%rsp),%xmm0
   1e4f5:	f3 0f 11 44 24 2c    	movss  %xmm0,0x2c(%rsp)
   1e4fb:	0f b7 84 24 04 01 00 	movzwl 0x104(%rsp),%eax
   1e502:	00 
   1e503:	83 e0 0e             	and    $0xe,%eax
   1e506:	89 44 24 0c          	mov    %eax,0xc(%rsp)
   1e50a:	eb 07                	jmp    1e513 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<()>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<false, (), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>::{closure#2}>+0x2c3>
   1e50c:	0f 1f 40 00          	nopl   0x0(%rax)
   1e510:	48 89 28             	mov    %rbp,(%rax)
   1e513:	49 8b 0c 24          	mov    (%r12),%rcx
   1e517:	48 83 f9 02          	cmp    $0x2,%rcx
   1e51b:	75 39                	jne    1e556 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<()>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<false, (), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>::{closure#2}>+0x306>
   1e51d:	41 80 7c 24 20 00    	cmpb   $0x0,0x20(%r12)
   1e523:	75 0c                	jne    1e531 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<()>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<false, (), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>::{closure#2}>+0x2e1>
   1e525:	49 8b 44 24 10       	mov    0x10(%r12),%rax
   1e52a:	49 3b 44 24 18       	cmp    0x18(%r12),%rax
   1e52f:	76 04                	jbe    1e535 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<()>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<false, (), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>::{closure#2}>+0x2e5>
   1e531:	31 c9                	xor    %ecx,%ecx
   1e533:	eb 18                	jmp    1e54d <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<()>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<false, (), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>::{closure#2}>+0x2fd>
   1e535:	73 0b                	jae    1e542 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<()>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<false, (), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>::{closure#2}>+0x2f2>
   1e537:	48 8d 48 01          	lea    0x1(%rax),%rcx
   1e53b:	49 89 4c 24 10       	mov    %rcx,0x10(%r12)
   1e540:	eb 06                	jmp    1e548 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<()>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<false, (), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>::{closure#2}>+0x2f8>
   1e542:	41 c6 44 24 20 01    	movb   $0x1,0x20(%r12)
   1e548:	b9 01 00 00 00       	mov    $0x1,%ecx
   1e54d:	49 89 0c 24          	mov    %rcx,(%r12)
   1e551:	49 89 44 24 08       	mov    %rax,0x8(%r12)
   1e556:	83 f9 01             	cmp    $0x1,%ecx
   1e559:	0f 85 51 02 00 00    	jne    1e7b0 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<()>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<false, (), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>::{closure#2}>+0x560>
   1e55f:	49 8b 6c 24 08       	mov    0x8(%r12),%rbp
   1e564:	4c 39 fd             	cmp    %r15,%rbp
   1e567:	0f 83 43 02 00 00    	jae    1e7b0 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<()>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<false, (), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>::{closure#2}>+0x560>
   1e56d:	41 80 3e 00          	cmpb   $0x0,(%r14)
   1e571:	74 0a                	je     1e57d <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<()>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<false, (), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>::{closure#2}>+0x32d>
   1e573:	49 3b 6e 08          	cmp    0x8(%r14),%rbp
   1e577:	0f 82 7e 02 00 00    	jb     1e7fb <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<()>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<false, (), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>::{closure#2}>+0x5ab>
   1e57d:	49 c7 04 24 02 00 00 	movq   $0x2,(%r12)
   1e584:	00 
   1e585:	49 c7 06 01 00 00 00 	movq   $0x1,(%r14)
   1e58c:	49 89 6e 08          	mov    %rbp,0x8(%r14)
   1e590:	48 39 dd             	cmp    %rbx,%rbp
   1e593:	75 7b                	jne    1e610 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<()>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<false, (), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>::{closure#2}>+0x3c0>
   1e595:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
   1e59a:	80 38 00             	cmpb   $0x0,(%rax)
   1e59d:	74 1c                	je     1e5bb <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<()>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<false, (), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>::{closure#2}>+0x36b>
   1e59f:	66 83 7c 24 0c 0c    	cmpw   $0xc,0xc(%rsp)
   1e5a5:	0f 94 c0             	sete   %al
   1e5a8:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
   1e5ad:	48 39 19             	cmp    %rbx,(%rcx)
   1e5b0:	0f 95 c1             	setne  %cl
   1e5b3:	08 c1                	or     %al,%cl
   1e5b5:	0f 84 bc 00 00 00    	je     1e677 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<()>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<false, (), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>::{closure#2}>+0x427>
   1e5bb:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
   1e5c0:	48 39 18             	cmp    %rbx,(%rax)
   1e5c3:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
   1e5c8:	f3 0f 10 00          	movss  (%rax),%xmm0
   1e5cc:	b9 00 00 00 00       	mov    $0x0,%ecx
   1e5d1:	48 0f 44 4c 24 38    	cmove  0x38(%rsp),%rcx
   1e5d7:	41 80 7d 00 00       	cmpb   $0x0,0x0(%r13)
   1e5dc:	b8 00 00 00 00       	mov    $0x0,%eax
   1e5e1:	48 0f 44 c8          	cmove  %rax,%rcx
   1e5e5:	48 8d bc 24 a0 00 00 	lea    0xa0(%rsp),%rdi
   1e5ec:	00 
   1e5ed:	48 8b 74 24 18       	mov    0x18(%rsp),%rsi
   1e5f2:	48 89 da             	mov    %rbx,%rdx
   1e5f5:	4c 8d 44 24 20       	lea    0x20(%rsp),%r8
   1e5fa:	e8 f1 f7 ff ff       	call   1ddf0 <parley::editing::geometry::pair_from_entries::<()>>
   1e5ff:	e9 4c 01 00 00       	jmp    1e750 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<()>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<false, (), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>::{closure#2}>+0x500>
   1e604:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
   1e60b:	00 00 00 00 00 
   1e610:	76 1e                	jbe    1e630 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<()>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<false, (), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>::{closure#2}>+0x3e0>
   1e612:	48 c7 84 24 a0 00 00 	movq   $0x0,0xa0(%rsp)
   1e619:	00 00 00 00 00 
   1e61e:	e9 2d 01 00 00       	jmp    1e750 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<()>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<false, (), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>::{closure#2}>+0x500>
   1e623:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   1e62a:	84 00 00 00 00 00 
   1e630:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
   1e635:	48 39 28             	cmp    %rbp,(%rax)
   1e638:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
   1e63d:	f3 0f 10 00          	movss  (%rax),%xmm0
   1e641:	b9 00 00 00 00       	mov    $0x0,%ecx
   1e646:	48 0f 44 4c 24 38    	cmove  0x38(%rsp),%rcx
   1e64c:	41 80 7d 00 00       	cmpb   $0x0,0x0(%r13)
   1e651:	b8 00 00 00 00       	mov    $0x0,%eax
   1e656:	48 0f 44 c8          	cmove  %rax,%rcx
   1e65a:	48 8d bc 24 a0 00 00 	lea    0xa0(%rsp),%rdi
   1e661:	00 
   1e662:	48 8b 74 24 18       	mov    0x18(%rsp),%rsi
   1e667:	48 89 ea             	mov    %rbp,%rdx
   1e66a:	45 31 c0             	xor    %r8d,%r8d
   1e66d:	e8 7e f7 ff ff       	call   1ddf0 <parley::editing::geometry::pair_from_entries::<()>>
   1e672:	e9 d9 00 00 00       	jmp    1e750 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<()>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<false, (), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>::{closure#2}>+0x500>
   1e677:	f3 0f 10 44 24 08    	movss  0x8(%rsp),%xmm0
   1e67d:	f6 44 24 07 01       	testb  $0x1,0x7(%rsp)
   1e682:	74 09                	je     1e68d <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<()>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<false, (), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>::{closure#2}>+0x43d>
   1e684:	48 8b 44 24 50       	mov    0x50(%rsp),%rax
   1e689:	f3 0f 10 00          	movss  (%rax),%xmm0
   1e68d:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
   1e692:	48 8b 40 08          	mov    0x8(%rax),%rax
   1e696:	0f 57 c9             	xorps  %xmm1,%xmm1
   1e699:	f3 0f 5a c8          	cvtss2sd %xmm0,%xmm1
   1e69d:	f3 0f 10 50 40       	movss  0x40(%rax),%xmm2
   1e6a2:	f3 0f 10 58 44       	movss  0x44(%rax),%xmm3
   1e6a7:	0f 28 e2             	movaps %xmm2,%xmm4
   1e6aa:	f3 0f 5d 60 48       	minss  0x48(%rax),%xmm4
   1e6af:	0f 28 ec             	movaps %xmm4,%xmm5
   1e6b2:	f3 0f c2 ec 03       	cmpunordss %xmm4,%xmm5
   1e6b7:	0f 28 f5             	movaps %xmm5,%xmm6
   1e6ba:	0f 55 f4             	andnps %xmm4,%xmm6
   1e6bd:	0f 54 ea             	andps  %xmm2,%xmm5
   1e6c0:	0f 56 ee             	orps   %xmm6,%xmm5
   1e6c3:	0f 57 d2             	xorps  %xmm2,%xmm2
   1e6c6:	f3 0f 5a d5          	cvtss2sd %xmm5,%xmm2
   1e6ca:	48 8b 4c 24 10       	mov    0x10(%rsp),%rcx
   1e6cf:	f3 0f 58 01          	addss  (%rcx),%xmm0
   1e6d3:	f3 0f 5a c0          	cvtss2sd %xmm0,%xmm0
   1e6d7:	0f 28 e3             	movaps %xmm3,%xmm4
   1e6da:	f3 0f 5f 60 4c       	maxss  0x4c(%rax),%xmm4
   1e6df:	0f 28 ec             	movaps %xmm4,%xmm5
   1e6e2:	f3 0f c2 ec 03       	cmpunordss %xmm4,%xmm5
   1e6e7:	0f 28 f5             	movaps %xmm5,%xmm6
   1e6ea:	0f 55 f4             	andnps %xmm4,%xmm6
   1e6ed:	0f 54 eb             	andps  %xmm3,%xmm5
   1e6f0:	0f 56 ee             	orps   %xmm6,%xmm5
   1e6f3:	0f 57 db             	xorps  %xmm3,%xmm3
   1e6f6:	f3 0f 5a dd          	cvtss2sd %xmm5,%xmm3
   1e6fa:	f2 0f 11 8c 24 a8 00 	movsd  %xmm1,0xa8(%rsp)
   1e701:	00 00 
   1e703:	f2 0f 11 94 24 b0 00 	movsd  %xmm2,0xb0(%rsp)
   1e70a:	00 00 
   1e70c:	f2 0f 11 84 24 b8 00 	movsd  %xmm0,0xb8(%rsp)
   1e713:	00 00 
   1e715:	f2 0f 11 9c 24 c0 00 	movsd  %xmm3,0xc0(%rsp)
   1e71c:	00 00 
   1e71e:	f2 0f 11 8c 24 c8 00 	movsd  %xmm1,0xc8(%rsp)
   1e725:	00 00 
   1e727:	f2 0f 11 94 24 d0 00 	movsd  %xmm2,0xd0(%rsp)
   1e72e:	00 00 
   1e730:	f2 0f 11 84 24 d8 00 	movsd  %xmm0,0xd8(%rsp)
   1e737:	00 00 
   1e739:	f2 0f 11 9c 24 e0 00 	movsd  %xmm3,0xe0(%rsp)
   1e740:	00 00 
   1e742:	48 c7 84 24 a0 00 00 	movq   $0x1,0xa0(%rsp)
   1e749:	00 01 00 00 00 
   1e74e:	66 90                	xchg   %ax,%ax
   1e750:	48 8b 44 24 68       	mov    0x68(%rsp),%rax
   1e755:	48 8b 00             	mov    (%rax),%rax
   1e758:	48 33 28             	xor    (%rax),%rbp
   1e75b:	48 83 bc 24 a0 00 00 	cmpq   $0x1,0xa0(%rsp)
   1e762:	00 01 
   1e764:	0f 85 a6 fd ff ff    	jne    1e510 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<()>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<false, (), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>::{closure#2}>+0x2c0>
   1e76a:	f3 0f 6f 84 24 a8 00 	movdqu 0xa8(%rsp),%xmm0
   1e771:	00 00 
   1e773:	f3 0f 6f 8c 24 b8 00 	movdqu 0xb8(%rsp),%xmm1
   1e77a:	00 00 
   1e77c:	f3 0f 6f 94 24 c8 00 	movdqu 0xc8(%rsp),%xmm2
   1e783:	00 00 
   1e785:	66 0f ef d0          	pxor   %xmm0,%xmm2
   1e789:	f3 0f 6f 84 24 d8 00 	movdqu 0xd8(%rsp),%xmm0
   1e790:	00 00 
   1e792:	66 0f ef c1          	pxor   %xmm1,%xmm0
   1e796:	66 0f ef c2          	pxor   %xmm2,%xmm0
   1e79a:	66 0f 70 c8 ee       	pshufd $0xee,%xmm0,%xmm1
   1e79f:	66 0f ef c8          	pxor   %xmm0,%xmm1
   1e7a3:	66 48 0f 7e c9       	movq   %xmm1,%rcx
   1e7a8:	48 31 cd             	xor    %rcx,%rbp
   1e7ab:	e9 60 fd ff ff       	jmp    1e510 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<()>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<false, (), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>::{closure#2}>+0x2c0>
   1e7b0:	48 8b 44 24 60       	mov    0x60(%rsp),%rax
   1e7b5:	4c 89 38             	mov    %r15,(%rax)
   1e7b8:	48 8b 44 24 50       	mov    0x50(%rsp),%rax
   1e7bd:	f3 0f 10 44 24 08    	movss  0x8(%rsp),%xmm0
   1e7c3:	f3 0f 11 00          	movss  %xmm0,(%rax)
   1e7c7:	66 83 7c 24 0c 0c    	cmpw   $0xc,0xc(%rsp)
   1e7cd:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
   1e7d2:	0f 95 00             	setne  (%rax)
   1e7d5:	41 c7 45 00 01 00 00 	movl   $0x1,0x0(%r13)
   1e7dc:	00 
   1e7dd:	0f 10 44 24 20       	movups 0x20(%rsp),%xmm0
   1e7e2:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
   1e7e7:	0f 11 00             	movups %xmm0,(%rax)
   1e7ea:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
   1e7ef:	4c 89 38             	mov    %r15,(%rax)
   1e7f2:	e9 31 fb ff ff       	jmp    1e328 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<()>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<false, (), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>::{closure#2}>+0xd8>
   1e7f7:	b0 ff                	mov    $0xff,%al
   1e7f9:	eb 1b                	jmp    1e816 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<()>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<false, (), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>::{closure#2}>+0x5c6>
   1e7fb:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
   1e800:	f3 0f 10 00          	movss  (%rax),%xmm0
   1e804:	48 8b 7c 24 18       	mov    0x18(%rsp),%rdi
   1e809:	4c 89 e6             	mov    %r12,%rsi
   1e80c:	48 8b 54 24 68       	mov    0x68(%rsp),%rdx
   1e811:	e8 4a e6 ff ff       	call   1ce60 <parley::editing::geometry::visit_direct::<(), (), &mut core::iter::adapters::peekable::Peekable<core::ops::range::RangeInclusive<usize>>, transaction_codegen::atomic::{closure#0}>>
   1e816:	48 81 c4 18 02 00 00 	add    $0x218,%rsp
   1e81d:	5b                   	pop    %rbx
   1e81e:	41 5c                	pop    %r12
   1e820:	41 5d                	pop    %r13
   1e822:	41 5e                	pop    %r14
   1e824:	41 5f                	pop    %r15
   1e826:	5d                   	pop    %rbp
   1e827:	c3                   	ret
   1e828:	48 8d 3d a9 7f fe ff 	lea    -0x18057(%rip),%rdi        # 67d8 <anon.5cab36dad6fad55fc602ca21d50a03ec.0.llvm.4639087895861959750>
   1e82f:	48 8d 15 d2 f9 03 00 	lea    0x3f9d2(%rip),%rdx        # 5e208 <anon.5cab36dad6fad55fc602ca21d50a03ec.2.llvm.4639087895861959750>
   1e836:	be 63 00 00 00       	mov    $0x63,%esi
   1e83b:	ff 15 17 1b 04 00    	call   *0x41b17(%rip)        # 60358 <_DYNAMIC+0x240>
   1e841:	48 8d 15 f0 f9 03 00 	lea    0x3f9f0(%rip),%rdx        # 5e238 <anon.5cab36dad6fad55fc602ca21d50a03ec.3.llvm.4639087895861959750+0x18>
   1e848:	ff 15 fa 1a 04 00    	call   *0x41afa(%rip)        # 60348 <_DYNAMIC+0x230>
   1e84e:	48 8d 15 cb f9 03 00 	lea    0x3f9cb(%rip),%rdx        # 5e220 <anon.5cab36dad6fad55fc602ca21d50a03ec.3.llvm.4639087895861959750>
   1e855:	ff 15 ed 1a 04 00    	call   *0x41aed(%rip)        # 60348 <_DYNAMIC+0x230>
