
/tmp/gpui-caret-transaction-bin/matched-partial-owner:     file format elf64-x86-64


Disassembly of section .text:

00000000007ec280 <<parley::editing::geometry::CursorGeometry<()>>::geometries_at>:
  7ec280:	55                   	push   %rbp
  7ec281:	41 57                	push   %r15
  7ec283:	41 56                	push   %r14
  7ec285:	41 55                	push   %r13
  7ec287:	41 54                	push   %r12
  7ec289:	53                   	push   %rbx
  7ec28a:	48 81 ec c8 00 00 00 	sub    $0xc8,%rsp
  7ec291:	48 89 fb             	mov    %rdi,%rbx
  7ec294:	f3 0f 11 44 24 14    	movss  %xmm0,0x14(%rsp)
  7ec29a:	4c 8b 7e 20          	mov    0x20(%rsi),%r15
  7ec29e:	4c 8b 66 28          	mov    0x28(%rsi),%r12
  7ec2a2:	48 85 d2             	test   %rdx,%rdx
  7ec2a5:	0f 84 b5 01 00 00    	je     7ec460 <<parley::editing::geometry::CursorGeometry<()>>::geometries_at+0x1e0>
  7ec2ab:	48 8d 42 ff          	lea    -0x1(%rdx),%rax
  7ec2af:	4c 39 e0             	cmp    %r12,%rax
  7ec2b2:	0f 83 a8 01 00 00    	jae    7ec460 <<parley::editing::geometry::CursorGeometry<()>>::geometries_at+0x1e0>
  7ec2b8:	45 8b 6c 97 fc       	mov    -0x4(%r15,%rdx,4),%r13d
  7ec2bd:	4c 39 e2             	cmp    %r12,%rdx
  7ec2c0:	0f 83 c1 01 00 00    	jae    7ec487 <<parley::editing::geometry::CursorGeometry<()>>::geometries_at+0x207>
  7ec2c6:	4c 8b 76 08          	mov    0x8(%rsi),%r14
  7ec2ca:	48 8b 6e 10          	mov    0x10(%rsi),%rbp
  7ec2ce:	4c 39 ed             	cmp    %r13,%rbp
  7ec2d1:	0f 86 b8 01 00 00    	jbe    7ec48f <<parley::editing::geometry::CursorGeometry<()>>::geometries_at+0x20f>
  7ec2d7:	45 8b 14 97          	mov    (%r15,%rdx,4),%r10d
  7ec2db:	4c 39 d5             	cmp    %r10,%rbp
  7ec2de:	0f 86 ab 01 00 00    	jbe    7ec48f <<parley::editing::geometry::CursorGeometry<()>>::geometries_at+0x20f>
  7ec2e4:	4d 89 e8             	mov    %r13,%r8
  7ec2e7:	49 c1 e0 04          	shl    $0x4,%r8
  7ec2eb:	4d 01 f0             	add    %r14,%r8
  7ec2ee:	4d 89 d1             	mov    %r10,%r9
  7ec2f1:	49 c1 e1 04          	shl    $0x4,%r9
  7ec2f5:	41 8b 08             	mov    (%r8),%ecx
  7ec2f8:	43 3b 0c 0e          	cmp    (%r14,%r9,1),%ecx
  7ec2fc:	0f 85 8d 01 00 00    	jne    7ec48f <<parley::editing::geometry::CursorGeometry<()>>::geometries_at+0x20f>
  7ec302:	4d 01 f1             	add    %r14,%r9
  7ec305:	41 8b 40 04          	mov    0x4(%r8),%eax
  7ec309:	41 3b 41 04          	cmp    0x4(%r9),%eax
  7ec30d:	0f 85 7c 01 00 00    	jne    7ec48f <<parley::editing::geometry::CursorGeometry<()>>::geometries_at+0x20f>
  7ec313:	48 8b 7e 30          	mov    0x30(%rsi),%rdi
  7ec317:	48 39 8f 18 01 00 00 	cmp    %rcx,0x118(%rdi)
  7ec31e:	0f 86 6b 01 00 00    	jbe    7ec48f <<parley::editing::geometry::CursorGeometry<()>>::geometries_at+0x20f>
  7ec324:	4c 89 54 24 28       	mov    %r10,0x28(%rsp)
  7ec329:	4c 89 4c 24 30       	mov    %r9,0x30(%rsp)
  7ec32e:	4c 89 44 24 38       	mov    %r8,0x38(%rsp)
  7ec333:	f3 0f 11 44 24 10    	movss  %xmm0,0x10(%rsp)
  7ec339:	48 89 74 24 20       	mov    %rsi,0x20(%rsp)
  7ec33e:	48 89 54 24 18       	mov    %rdx,0x18(%rsp)
  7ec343:	48 6b d1 70          	imul   $0x70,%rcx,%rdx
  7ec347:	48 03 97 10 01 00 00 	add    0x110(%rdi),%rdx
  7ec34e:	48 89 bc 24 88 00 00 	mov    %rdi,0x88(%rsp)
  7ec355:	00 
  7ec356:	48 89 94 24 90 00 00 	mov    %rdx,0x90(%rsp)
  7ec35d:	00 
  7ec35e:	89 8c 24 98 00 00 00 	mov    %ecx,0x98(%rsp)
  7ec365:	48 8d 7c 24 40       	lea    0x40(%rsp),%rdi
  7ec36a:	48 8d b4 24 88 00 00 	lea    0x88(%rsp),%rsi
  7ec371:	00 
  7ec372:	48 89 c2             	mov    %rax,%rdx
  7ec375:	e8 56 fe ff ff       	call   7ec1d0 <<parley::layout::line::Line<()>>::item>
  7ec37a:	83 7c 24 40 01       	cmpl   $0x1,0x40(%rsp)
  7ec37f:	0f 85 4a 01 00 00    	jne    7ec4cf <<parley::editing::geometry::CursorGeometry<()>>::geometries_at+0x24f>
  7ec385:	48 83 7c 24 48 00    	cmpq   $0x0,0x48(%rsp)
  7ec38b:	48 8b 54 24 18       	mov    0x18(%rsp),%rdx
  7ec390:	48 8b 74 24 20       	mov    0x20(%rsp),%rsi
  7ec395:	f3 0f 10 44 24 10    	movss  0x10(%rsp),%xmm0
  7ec39b:	0f 84 ee 00 00 00    	je     7ec48f <<parley::editing::geometry::CursorGeometry<()>>::geometries_at+0x20f>
  7ec3a1:	48 8b 44 24 50       	mov    0x50(%rsp),%rax
  7ec3a6:	0f b6 80 8c 00 00 00 	movzbl 0x8c(%rax),%eax
  7ec3ad:	4c 8b 4c 24 28       	mov    0x28(%rsp),%r9
  7ec3b2:	49 8d 49 01          	lea    0x1(%r9),%rcx
  7ec3b6:	31 ff                	xor    %edi,%edi
  7ec3b8:	4c 39 e9             	cmp    %r13,%rcx
  7ec3bb:	40 0f 94 c7          	sete   %dil
  7ec3bf:	49 8d 4d 01          	lea    0x1(%r13),%rcx
  7ec3c3:	45 31 c0             	xor    %r8d,%r8d
  7ec3c6:	4c 39 c9             	cmp    %r9,%rcx
  7ec3c9:	41 0f 94 c0          	sete   %r8b
  7ec3cd:	24 01                	and    $0x1,%al
  7ec3cf:	88 44 24 0f          	mov    %al,0xf(%rsp)
  7ec3d3:	41 0f 44 f8          	cmove  %r8d,%edi
  7ec3d7:	48 8d 84 24 88 00 00 	lea    0x88(%rsp),%rax
  7ec3de:	00 
  7ec3df:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
  7ec3e4:	48 8d 44 24 14       	lea    0x14(%rsp),%rax
  7ec3e9:	48 89 44 24 48       	mov    %rax,0x48(%rsp)
  7ec3ee:	48 8d 44 24 0f       	lea    0xf(%rsp),%rax
  7ec3f3:	48 89 44 24 50       	mov    %rax,0x50(%rsp)
  7ec3f8:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  7ec3fd:	48 89 44 24 58       	mov    %rax,0x58(%rsp)
  7ec402:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  7ec407:	48 89 44 24 60       	mov    %rax,0x60(%rsp)
  7ec40c:	40 84 ff             	test   %dil,%dil
  7ec40f:	74 7e                	je     7ec48f <<parley::editing::geometry::CursorGeometry<()>>::geometries_at+0x20f>
  7ec411:	48 8d bc 24 a8 00 00 	lea    0xa8(%rsp),%rdi
  7ec418:	00 
  7ec419:	48 8d 74 24 40       	lea    0x40(%rsp),%rsi
  7ec41e:	e8 2d fd ff ff       	call   7ec150 <<parley::editing::geometry::CursorGeometry<()>>::shared_edge::{closure#0}>
  7ec423:	0f 10 84 24 a8 00 00 	movups 0xa8(%rsp),%xmm0
  7ec42a:	00 
  7ec42b:	0f 10 8c 24 b8 00 00 	movups 0xb8(%rsp),%xmm1
  7ec432:	00 
  7ec433:	0f 29 4c 24 70       	movaps %xmm1,0x70(%rsp)
  7ec438:	0f 29 44 24 60       	movaps %xmm0,0x60(%rsp)
  7ec43d:	0f 29 4c 24 50       	movaps %xmm1,0x50(%rsp)
  7ec442:	0f 29 44 24 40       	movaps %xmm0,0x40(%rsp)
  7ec447:	0f 11 4b 38          	movups %xmm1,0x38(%rbx)
  7ec44b:	0f 11 4b 18          	movups %xmm1,0x18(%rbx)
  7ec44f:	0f 11 43 08          	movups %xmm0,0x8(%rbx)
  7ec453:	0f 11 43 28          	movups %xmm0,0x28(%rbx)
  7ec457:	48 c7 03 01 00 00 00 	movq   $0x1,(%rbx)
  7ec45e:	eb 5a                	jmp    7ec4ba <<parley::editing::geometry::CursorGeometry<()>>::geometries_at+0x23a>
  7ec460:	31 c9                	xor    %ecx,%ecx
  7ec462:	48 8b 46 30          	mov    0x30(%rsi),%rax
  7ec466:	4c 39 e2             	cmp    %r12,%rdx
  7ec469:	73 40                	jae    7ec4ab <<parley::editing::geometry::CursorGeometry<()>>::geometries_at+0x22b>
  7ec46b:	41 8b 3c 97          	mov    (%r15,%rdx,4),%edi
  7ec46f:	49 89 f9             	mov    %rdi,%r9
  7ec472:	49 c1 e1 04          	shl    $0x4,%r9
  7ec476:	4c 03 4e 08          	add    0x8(%rsi),%r9
  7ec47a:	45 31 c0             	xor    %r8d,%r8d
  7ec47d:	48 39 7e 10          	cmp    %rdi,0x10(%rsi)
  7ec481:	4d 0f 47 c1          	cmova  %r9,%r8
  7ec485:	eb 27                	jmp    7ec4ae <<parley::editing::geometry::CursorGeometry<()>>::geometries_at+0x22e>
  7ec487:	4c 8b 76 08          	mov    0x8(%rsi),%r14
  7ec48b:	48 8b 6e 10          	mov    0x10(%rsi),%rbp
  7ec48f:	4c 89 e8             	mov    %r13,%rax
  7ec492:	48 c1 e0 04          	shl    $0x4,%rax
  7ec496:	4c 01 f0             	add    %r14,%rax
  7ec499:	31 c9                	xor    %ecx,%ecx
  7ec49b:	4c 39 ed             	cmp    %r13,%rbp
  7ec49e:	48 0f 47 c8          	cmova  %rax,%rcx
  7ec4a2:	48 8b 46 30          	mov    0x30(%rsi),%rax
  7ec4a6:	4c 39 e2             	cmp    %r12,%rdx
  7ec4a9:	72 c0                	jb     7ec46b <<parley::editing::geometry::CursorGeometry<()>>::geometries_at+0x1eb>
  7ec4ab:	45 31 c0             	xor    %r8d,%r8d
  7ec4ae:	48 89 df             	mov    %rbx,%rdi
  7ec4b1:	48 89 c6             	mov    %rax,%rsi
  7ec4b4:	ff 15 56 1e 34 00    	call   *0x341e56(%rip)        # b2e310 <_DYNAMIC+0xe10>
  7ec4ba:	48 89 d8             	mov    %rbx,%rax
  7ec4bd:	48 81 c4 c8 00 00 00 	add    $0xc8,%rsp
  7ec4c4:	5b                   	pop    %rbx
  7ec4c5:	41 5c                	pop    %r12
  7ec4c7:	41 5d                	pop    %r13
  7ec4c9:	41 5e                	pop    %r14
  7ec4cb:	41 5f                	pop    %r15
  7ec4cd:	5d                   	pop    %rbp
  7ec4ce:	c3                   	ret
  7ec4cf:	48 8b 54 24 18       	mov    0x18(%rsp),%rdx
  7ec4d4:	48 8b 74 24 20       	mov    0x20(%rsp),%rsi
  7ec4d9:	f3 0f 10 44 24 10    	movss  0x10(%rsp),%xmm0
  7ec4df:	eb ae                	jmp    7ec48f <<parley::editing::geometry::CursorGeometry<()>>::geometries_at+0x20f>
