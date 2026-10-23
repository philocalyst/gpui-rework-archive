
/tmp/gpui-caret-transaction-bin/matched-indexed-caret_pair_measure:     file format elf64-x86-64


Disassembly of section .text:

0000000000669350 <<parley::editing::geometry::CursorGeometry<()>>::geometries_at>:
  669350:	55                   	push   %rbp
  669351:	41 57                	push   %r15
  669353:	41 56                	push   %r14
  669355:	41 55                	push   %r13
  669357:	41 54                	push   %r12
  669359:	53                   	push   %rbx
  66935a:	48 81 ec a8 00 00 00 	sub    $0xa8,%rsp
  669361:	48 89 fb             	mov    %rdi,%rbx
  669364:	f3 0f 11 44 24 14    	movss  %xmm0,0x14(%rsp)
  66936a:	48 85 d2             	test   %rdx,%rdx
  66936d:	0f 84 97 01 00 00    	je     66950a <<parley::editing::geometry::CursorGeometry<()>>::geometries_at+0x1ba>
  669373:	48 8b 46 28          	mov    0x28(%rsi),%rax
  669377:	48 8d 4a ff          	lea    -0x1(%rdx),%rcx
  66937b:	48 39 c1             	cmp    %rax,%rcx
  66937e:	0f 83 86 01 00 00    	jae    66950a <<parley::editing::geometry::CursorGeometry<()>>::geometries_at+0x1ba>
  669384:	48 39 c2             	cmp    %rax,%rdx
  669387:	0f 83 7d 01 00 00    	jae    66950a <<parley::editing::geometry::CursorGeometry<()>>::geometries_at+0x1ba>
  66938d:	48 8b 46 20          	mov    0x20(%rsi),%rax
  669391:	44 8b 6c 90 fc       	mov    -0x4(%rax,%rdx,4),%r13d
  669396:	48 8b 4e 10          	mov    0x10(%rsi),%rcx
  66939a:	4c 39 e9             	cmp    %r13,%rcx
  66939d:	0f 86 67 01 00 00    	jbe    66950a <<parley::editing::geometry::CursorGeometry<()>>::geometries_at+0x1ba>
  6693a3:	8b 2c 90             	mov    (%rax,%rdx,4),%ebp
  6693a6:	48 39 e9             	cmp    %rbp,%rcx
  6693a9:	0f 86 5b 01 00 00    	jbe    66950a <<parley::editing::geometry::CursorGeometry<()>>::geometries_at+0x1ba>
  6693af:	4c 8b 7e 08          	mov    0x8(%rsi),%r15
  6693b3:	4d 89 ec             	mov    %r13,%r12
  6693b6:	49 c1 e4 04          	shl    $0x4,%r12
  6693ba:	4d 01 fc             	add    %r15,%r12
  6693bd:	48 89 e8             	mov    %rbp,%rax
  6693c0:	48 c1 e0 04          	shl    $0x4,%rax
  6693c4:	41 8b 0c 24          	mov    (%r12),%ecx
  6693c8:	41 3b 0c 07          	cmp    (%r15,%rax,1),%ecx
  6693cc:	0f 85 38 01 00 00    	jne    66950a <<parley::editing::geometry::CursorGeometry<()>>::geometries_at+0x1ba>
  6693d2:	49 01 c7             	add    %rax,%r15
  6693d5:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  6693da:	41 3b 47 04          	cmp    0x4(%r15),%eax
  6693de:	0f 85 26 01 00 00    	jne    66950a <<parley::editing::geometry::CursorGeometry<()>>::geometries_at+0x1ba>
  6693e4:	48 8b 7e 30          	mov    0x30(%rsi),%rdi
  6693e8:	48 39 8f 18 01 00 00 	cmp    %rcx,0x118(%rdi)
  6693ef:	0f 86 15 01 00 00    	jbe    66950a <<parley::editing::geometry::CursorGeometry<()>>::geometries_at+0x1ba>
  6693f5:	f3 0f 11 44 24 10    	movss  %xmm0,0x10(%rsp)
  6693fb:	48 89 74 24 18       	mov    %rsi,0x18(%rsp)
  669400:	49 89 d6             	mov    %rdx,%r14
  669403:	48 6b d1 70          	imul   $0x70,%rcx,%rdx
  669407:	48 03 97 10 01 00 00 	add    0x110(%rdi),%rdx
  66940e:	48 89 7c 24 68       	mov    %rdi,0x68(%rsp)
  669413:	48 89 54 24 70       	mov    %rdx,0x70(%rsp)
  669418:	89 4c 24 78          	mov    %ecx,0x78(%rsp)
  66941c:	48 8d 7c 24 20       	lea    0x20(%rsp),%rdi
  669421:	48 8d 74 24 68       	lea    0x68(%rsp),%rsi
  669426:	48 89 c2             	mov    %rax,%rdx
  669429:	e8 72 fe ff ff       	call   6692a0 <<parley::layout::line::Line<()>>::item>
  66942e:	83 7c 24 20 01       	cmpl   $0x1,0x20(%rsp)
  669433:	0f 85 c3 00 00 00    	jne    6694fc <<parley::editing::geometry::CursorGeometry<()>>::geometries_at+0x1ac>
  669439:	48 83 7c 24 28 00    	cmpq   $0x0,0x28(%rsp)
  66943f:	4c 89 f2             	mov    %r14,%rdx
  669442:	48 8b 74 24 18       	mov    0x18(%rsp),%rsi
  669447:	f3 0f 10 44 24 10    	movss  0x10(%rsp),%xmm0
  66944d:	0f 84 b7 00 00 00    	je     66950a <<parley::editing::geometry::CursorGeometry<()>>::geometries_at+0x1ba>
  669453:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  669458:	0f b6 80 8c 00 00 00 	movzbl 0x8c(%rax),%eax
  66945f:	48 8d 4d 01          	lea    0x1(%rbp),%rcx
  669463:	31 ff                	xor    %edi,%edi
  669465:	4c 39 e9             	cmp    %r13,%rcx
  669468:	40 0f 94 c7          	sete   %dil
  66946c:	49 ff c5             	inc    %r13
  66946f:	31 c9                	xor    %ecx,%ecx
  669471:	49 39 ed             	cmp    %rbp,%r13
  669474:	0f 94 c1             	sete   %cl
  669477:	24 01                	and    $0x1,%al
  669479:	88 44 24 0f          	mov    %al,0xf(%rsp)
  66947d:	0f 44 f9             	cmove  %ecx,%edi
  669480:	48 8d 44 24 68       	lea    0x68(%rsp),%rax
  669485:	48 89 44 24 20       	mov    %rax,0x20(%rsp)
  66948a:	48 8d 44 24 14       	lea    0x14(%rsp),%rax
  66948f:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  669494:	48 8d 44 24 0f       	lea    0xf(%rsp),%rax
  669499:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  66949e:	4c 89 64 24 38       	mov    %r12,0x38(%rsp)
  6694a3:	4c 89 7c 24 40       	mov    %r15,0x40(%rsp)
  6694a8:	40 84 ff             	test   %dil,%dil
  6694ab:	74 5d                	je     66950a <<parley::editing::geometry::CursorGeometry<()>>::geometries_at+0x1ba>
  6694ad:	48 8d bc 24 88 00 00 	lea    0x88(%rsp),%rdi
  6694b4:	00 
  6694b5:	48 8d 74 24 20       	lea    0x20(%rsp),%rsi
  6694ba:	e8 61 fd ff ff       	call   669220 <<parley::editing::geometry::CursorGeometry<()>>::shared_edge::{closure#0}>
  6694bf:	0f 10 84 24 88 00 00 	movups 0x88(%rsp),%xmm0
  6694c6:	00 
  6694c7:	0f 10 8c 24 98 00 00 	movups 0x98(%rsp),%xmm1
  6694ce:	00 
  6694cf:	0f 29 4c 24 50       	movaps %xmm1,0x50(%rsp)
  6694d4:	0f 29 44 24 40       	movaps %xmm0,0x40(%rsp)
  6694d9:	0f 29 4c 24 30       	movaps %xmm1,0x30(%rsp)
  6694de:	0f 29 44 24 20       	movaps %xmm0,0x20(%rsp)
  6694e3:	0f 11 4b 38          	movups %xmm1,0x38(%rbx)
  6694e7:	0f 11 4b 18          	movups %xmm1,0x18(%rbx)
  6694eb:	0f 11 43 08          	movups %xmm0,0x8(%rbx)
  6694ef:	0f 11 43 28          	movups %xmm0,0x28(%rbx)
  6694f3:	48 c7 03 01 00 00 00 	movq   $0x1,(%rbx)
  6694fa:	eb 17                	jmp    669513 <<parley::editing::geometry::CursorGeometry<()>>::geometries_at+0x1c3>
  6694fc:	4c 89 f2             	mov    %r14,%rdx
  6694ff:	48 8b 74 24 18       	mov    0x18(%rsp),%rsi
  669504:	f3 0f 10 44 24 10    	movss  0x10(%rsp),%xmm0
  66950a:	48 89 df             	mov    %rbx,%rdi
  66950d:	ff 15 4d db 11 00    	call   *0x11db4d(%rip)        # 787060 <_DYNAMIC+0x3d8>
  669513:	48 89 d8             	mov    %rbx,%rax
  669516:	48 81 c4 a8 00 00 00 	add    $0xa8,%rsp
  66951d:	5b                   	pop    %rbx
  66951e:	41 5c                	pop    %r12
  669520:	41 5d                	pop    %r13
  669522:	41 5e                	pop    %r14
  669524:	41 5f                	pop    %r15
  669526:	5d                   	pop    %rbp
  669527:	c3                   	ret
