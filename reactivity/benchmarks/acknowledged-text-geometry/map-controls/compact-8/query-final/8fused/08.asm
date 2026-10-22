
/tmp/gpui-text-map-query-final/8fused/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

000000000067d0d0 <<gpui_canvas::text::layout::TextGeometry>::move_visual>:
  67d0d0:	55                   	push   %rbp
  67d0d1:	41 57                	push   %r15
  67d0d3:	41 56                	push   %r14
  67d0d5:	41 55                	push   %r13
  67d0d7:	41 54                	push   %r12
  67d0d9:	53                   	push   %rbx
  67d0da:	48 81 ec 18 01 00 00 	sub    $0x118,%rsp
  67d0e1:	41 89 cf             	mov    %ecx,%r15d
  67d0e4:	41 89 d6             	mov    %edx,%r14d
  67d0e7:	89 f5                	mov    %esi,%ebp
  67d0e9:	48 89 fb             	mov    %rdi,%rbx
  67d0ec:	48 8d 7c 24 60       	lea    0x60(%rsp),%rdi
  67d0f1:	48 89 de             	mov    %rbx,%rsi
  67d0f4:	89 ea                	mov    %ebp,%edx
  67d0f6:	44 89 f1             	mov    %r14d,%ecx
  67d0f9:	ff 15 99 c8 10 00    	call   *0x10c899(%rip)        # 789998 <_DYNAMIC+0x470>
  67d0ff:	83 7c 24 60 01       	cmpl   $0x1,0x60(%rsp)
  67d104:	75 74                	jne    67d17a <<gpui_canvas::text::layout::TextGeometry>::move_visual+0xaa>
  67d106:	85 ed                	test   %ebp,%ebp
  67d108:	0f 95 c1             	setne  %cl
  67d10b:	44 89 f2             	mov    %r14d,%edx
  67d10e:	f6 d2                	not    %dl
  67d110:	48 8b 43 38          	mov    0x38(%rbx),%rax
  67d114:	4c 8b 4b 40          	mov    0x40(%rbx),%r9
  67d118:	84 ca                	test   %cl,%dl
  67d11a:	44 89 7c 24 08       	mov    %r15d,0x8(%rsp)
  67d11f:	4c 89 ca             	mov    %r9,%rdx
  67d122:	75 5e                	jne    67d182 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0xb2>
  67d124:	4d 85 c9             	test   %r9,%r9
  67d127:	0f 84 aa 00 00 00    	je     67d1d7 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x107>
  67d12d:	31 c9                	xor    %ecx,%ecx
  67d12f:	49 83 f9 01          	cmp    $0x1,%r9
  67d133:	74 2c                	je     67d161 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x91>
  67d135:	4c 89 ca             	mov    %r9,%rdx
  67d138:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  67d13f:	00 
  67d140:	48 89 ce             	mov    %rcx,%rsi
  67d143:	48 89 d7             	mov    %rdx,%rdi
  67d146:	48 d1 ef             	shr    $1,%rdi
  67d149:	48 01 f9             	add    %rdi,%rcx
  67d14c:	4c 8d 04 49          	lea    (%rcx,%rcx,2),%r8
  67d150:	42 39 2c c0          	cmp    %ebp,(%rax,%r8,8)
  67d154:	48 0f 47 ce          	cmova  %rsi,%rcx
  67d158:	48 29 fa             	sub    %rdi,%rdx
  67d15b:	48 83 fa 01          	cmp    $0x1,%rdx
  67d15f:	77 df                	ja     67d140 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x70>
  67d161:	48 8d 34 49          	lea    (%rcx,%rcx,2),%rsi
  67d165:	31 d2                	xor    %edx,%edx
  67d167:	39 2c f0             	cmp    %ebp,(%rax,%rsi,8)
  67d16a:	0f 96 c2             	setbe  %dl
  67d16d:	48 01 ca             	add    %rcx,%rdx
  67d170:	48 83 fa 01          	cmp    $0x1,%rdx
  67d174:	48 83 d2 ff          	adc    $0xffffffffffffffff,%rdx
  67d178:	eb 5d                	jmp    67d1d7 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x107>
  67d17a:	41 b5 02             	mov    $0x2,%r13b
  67d17d:	e9 fd 02 00 00       	jmp    67d47f <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x3af>
  67d182:	4d 85 c9             	test   %r9,%r9
  67d185:	74 45                	je     67d1cc <<gpui_canvas::text::layout::TextGeometry>::move_visual+0xfc>
  67d187:	31 d2                	xor    %edx,%edx
  67d189:	49 83 f9 01          	cmp    $0x1,%r9
  67d18d:	74 31                	je     67d1c0 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0xf0>
  67d18f:	4c 89 c9             	mov    %r9,%rcx
  67d192:	66 66 66 66 66 2e 0f 	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  67d199:	1f 84 00 00 00 00 00 
  67d1a0:	48 89 ce             	mov    %rcx,%rsi
  67d1a3:	48 d1 ee             	shr    $1,%rsi
  67d1a6:	48 8d 3c 16          	lea    (%rsi,%rdx,1),%rdi
  67d1aa:	4c 8d 04 7f          	lea    (%rdi,%rdi,2),%r8
  67d1ae:	42 39 6c c0 04       	cmp    %ebp,0x4(%rax,%r8,8)
  67d1b3:	48 0f 42 d7          	cmovb  %rdi,%rdx
  67d1b7:	48 29 f1             	sub    %rsi,%rcx
  67d1ba:	48 83 f9 01          	cmp    $0x1,%rcx
  67d1be:	77 e0                	ja     67d1a0 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0xd0>
  67d1c0:	48 8d 0c 52          	lea    (%rdx,%rdx,2),%rcx
  67d1c4:	39 6c c8 04          	cmp    %ebp,0x4(%rax,%rcx,8)
  67d1c8:	48 83 d2 00          	adc    $0x0,%rdx
  67d1cc:	49 8d 41 ff          	lea    -0x1(%r9),%rax
  67d1d0:	48 39 d0             	cmp    %rdx,%rax
  67d1d3:	48 0f 42 d0          	cmovb  %rax,%rdx
  67d1d7:	4c 89 4c 24 18       	mov    %r9,0x18(%rsp)
  67d1dc:	44 89 74 24 14       	mov    %r14d,0x14(%rsp)
  67d1e1:	f3 0f 10 44 24 64    	movss  0x64(%rsp),%xmm0
  67d1e7:	f3 0f 11 44 24 0c    	movss  %xmm0,0xc(%rsp)
  67d1ed:	48 89 54 24 20       	mov    %rdx,0x20(%rsp)
  67d1f2:	4c 8d 64 24 28       	lea    0x28(%rsp),%r12
  67d1f7:	4c 89 e7             	mov    %r12,%rdi
  67d1fa:	48 89 de             	mov    %rbx,%rsi
  67d1fd:	e8 1e 31 00 00       	call   680320 <<gpui_canvas::text::layout::TextGeometry>::line_tail>
  67d202:	f3 0f 10 43 4c       	movss  0x4c(%rbx),%xmm0
  67d207:	f3 0f 59 05 89 04 9a 	mulss  -0x65fb77(%rip),%xmm0        # 1d698 <GCC_except_table0+0x88>
  67d20e:	ff 
  67d20f:	0f 57 c9             	xorps  %xmm1,%xmm1
  67d212:	0f 11 8c 24 a8 00 00 	movups %xmm1,0xa8(%rsp)
  67d219:	00 
  67d21a:	0f 10 4c 24 28       	movups 0x28(%rsp),%xmm1
  67d21f:	0f 29 4c 24 60       	movaps %xmm1,0x60(%rsp)
  67d224:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  67d229:	48 89 44 24 70       	mov    %rax,0x70(%rsp)
  67d22e:	0f 29 8c 24 80 00 00 	movaps %xmm1,0x80(%rsp)
  67d235:	00 
  67d236:	48 89 84 24 90 00 00 	mov    %rax,0x90(%rsp)
  67d23d:	00 
  67d23e:	48 c7 44 24 78 00 00 	movq   $0x0,0x78(%rsp)
  67d245:	00 00 
  67d247:	48 c7 84 24 98 00 00 	movq   $0x0,0x98(%rsp)
  67d24e:	00 00 00 00 00 
  67d253:	48 c7 84 24 a0 00 00 	movq   $0x1,0xa0(%rsp)
  67d25a:	00 01 00 00 00 
  67d25f:	48 89 9c 24 b8 00 00 	mov    %rbx,0xb8(%rsp)
  67d266:	00 
  67d267:	f3 0f 11 84 24 c0 00 	movss  %xmm0,0xc0(%rsp)
  67d26e:	00 00 
  67d270:	48 89 9c 24 c8 00 00 	mov    %rbx,0xc8(%rsp)
  67d277:	00 
  67d278:	48 8d 44 24 20       	lea    0x20(%rsp),%rax
  67d27d:	48 89 84 24 d0 00 00 	mov    %rax,0xd0(%rsp)
  67d284:	00 
  67d285:	c6 84 24 d8 00 00 00 	movb   $0x0,0xd8(%rsp)
  67d28c:	00 
  67d28d:	48 89 84 24 e0 00 00 	mov    %rax,0xe0(%rsp)
  67d294:	00 
  67d295:	f3 0f 10 05 2b 04 9a 	movss  -0x65fbd5(%rip),%xmm0        # 1d6c8 <GCC_except_table0+0xb8>
  67d29c:	ff 
  67d29d:	f3 0f 11 44 24 10    	movss  %xmm0,0x10(%rsp)
  67d2a3:	41 b5 02             	mov    $0x2,%r13b
  67d2a6:	4c 8d bc 24 e8 00 00 	lea    0xe8(%rsp),%r15
  67d2ad:	00 
  67d2ae:	4c 8d 74 24 60       	lea    0x60(%rsp),%r14
  67d2b3:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  67d2ba:	84 00 00 00 00 00 
  67d2c0:	4c 89 ff             	mov    %r15,%rdi
  67d2c3:	4c 89 f6             	mov    %r14,%rsi
  67d2c6:	e8 b5 35 00 00       	call   680880 <<core::iter::adapters::zip::Zip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>, core::iter::adapters::skip::Skip<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}>>> as core::iter::traits::iterator::Iterator>::next>
  67d2cb:	83 bc 24 e8 00 00 00 	cmpl   $0x2,0xe8(%rsp)
  67d2d2:	02 
  67d2d3:	0f 84 28 01 00 00    	je     67d401 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x331>
  67d2d9:	48 8b b4 24 b8 00 00 	mov    0xb8(%rsp),%rsi
  67d2e0:	00 
  67d2e1:	f3 0f 10 84 24 c0 00 	movss  0xc0(%rsp),%xmm0
  67d2e8:	00 00 
  67d2ea:	4c 89 e7             	mov    %r12,%rdi
  67d2ed:	4c 89 fa             	mov    %r15,%rdx
  67d2f0:	e8 3b fa ff ff       	call   67cd30 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}>
  67d2f5:	0f b6 44 24 2c       	movzbl 0x2c(%rsp),%eax
  67d2fa:	3c 02                	cmp    $0x2,%al
  67d2fc:	74 c2                	je     67d2c0 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x1f0>
  67d2fe:	48 8b 94 24 c8 00 00 	mov    0xc8(%rsp),%rdx
  67d305:	00 
  67d306:	48 8b 8c 24 d0 00 00 	mov    0xd0(%rsp),%rcx
  67d30d:	00 
  67d30e:	48 8b 39             	mov    (%rcx),%rdi
  67d311:	48 8b 72 40          	mov    0x40(%rdx),%rsi
  67d315:	48 39 f7             	cmp    %rsi,%rdi
  67d318:	0f 83 78 01 00 00    	jae    67d496 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x3c6>
  67d31e:	8b 4c 24 28          	mov    0x28(%rsp),%ecx
  67d322:	48 8b 52 38          	mov    0x38(%rdx),%rdx
  67d326:	48 8d 34 7f          	lea    (%rdi,%rdi,2),%rsi
  67d32a:	3b 4c f2 04          	cmp    0x4(%rdx,%rsi,8),%ecx
  67d32e:	0f 87 cd 00 00 00    	ja     67d401 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x331>
  67d334:	48 8b 54 24 48       	mov    0x48(%rsp),%rdx
  67d339:	48 8b b4 24 e0 00 00 	mov    0xe0(%rsp),%rsi
  67d340:	00 
  67d341:	48 3b 16             	cmp    (%rsi),%rdx
  67d344:	0f 85 76 ff ff ff    	jne    67d2c0 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x1f0>
  67d34a:	f6 44 24 58 01       	testb  $0x1,0x58(%rsp)
  67d34f:	0f 85 6b ff ff ff    	jne    67d2c0 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x1f0>
  67d355:	f3 0f 10 44 24 50    	movss  0x50(%rsp),%xmm0
  67d35b:	f3 0f 10 4c 24 54    	movss  0x54(%rsp),%xmm1
  67d361:	80 7c 24 08 00       	cmpb   $0x0,0x8(%rsp)
  67d366:	74 23                	je     67d38b <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x2bb>
  67d368:	0f 28 d8             	movaps %xmm0,%xmm3
  67d36b:	f3 0f 5f d9          	maxss  %xmm1,%xmm3
  67d36f:	0f 28 d3             	movaps %xmm3,%xmm2
  67d372:	f3 0f c2 d3 03       	cmpunordss %xmm3,%xmm2
  67d377:	0f 28 e2             	movaps %xmm2,%xmm4
  67d37a:	0f 55 e3             	andnps %xmm3,%xmm4
  67d37d:	0f 54 d0             	andps  %xmm0,%xmm2
  67d380:	0f 56 d4             	orps   %xmm4,%xmm2
  67d383:	f3 0f 5c 54 24 0c    	subss  0xc(%rsp),%xmm2
  67d389:	eb 25                	jmp    67d3b0 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x2e0>
  67d38b:	0f 28 d0             	movaps %xmm0,%xmm2
  67d38e:	f3 0f 5d d1          	minss  %xmm1,%xmm2
  67d392:	0f 28 da             	movaps %xmm2,%xmm3
  67d395:	f3 0f c2 da 03       	cmpunordss %xmm2,%xmm3
  67d39a:	0f 28 e3             	movaps %xmm3,%xmm4
  67d39d:	0f 55 e2             	andnps %xmm2,%xmm4
  67d3a0:	0f 54 d8             	andps  %xmm0,%xmm3
  67d3a3:	0f 56 dc             	orps   %xmm4,%xmm3
  67d3a6:	f3 0f 10 54 24 0c    	movss  0xc(%rsp),%xmm2
  67d3ac:	f3 0f 5c d3          	subss  %xmm3,%xmm2
  67d3b0:	8b 54 24 04          	mov    0x4(%rsp),%edx
  67d3b4:	0f 57 db             	xorps  %xmm3,%xmm3
  67d3b7:	0f 2e d3             	ucomiss %xmm3,%xmm2
  67d3ba:	76 33                	jbe    67d3ef <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x31f>
  67d3bc:	f3 0f 10 5c 24 10    	movss  0x10(%rsp),%xmm3
  67d3c2:	0f 2e da             	ucomiss %xmm2,%xmm3
  67d3c5:	76 28                	jbe    67d3ef <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x31f>
  67d3c7:	0f 2e c8             	ucomiss %xmm0,%xmm1
  67d3ca:	0f 96 c2             	setbe  %dl
  67d3cd:	32 54 24 08          	xor    0x8(%rsp),%dl
  67d3d1:	0f 45 4c 24 30       	cmovne 0x30(%rsp),%ecx
  67d3d6:	0f b6 54 24 34       	movzbl 0x34(%rsp),%edx
  67d3db:	44 0f b6 e8          	movzbl %al,%r13d
  67d3df:	44 0f 45 ea          	cmovne %edx,%r13d
  67d3e3:	41 80 e5 01          	and    $0x1,%r13b
  67d3e7:	f3 0f 11 54 24 10    	movss  %xmm2,0x10(%rsp)
  67d3ed:	89 ca                	mov    %ecx,%edx
  67d3ef:	89 54 24 04          	mov    %edx,0x4(%rsp)
  67d3f3:	80 bc 24 d8 00 00 00 	cmpb   $0x0,0xd8(%rsp)
  67d3fa:	00 
  67d3fb:	0f 84 bf fe ff ff    	je     67d2c0 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x1f0>
  67d401:	41 80 fd 02          	cmp    $0x2,%r13b
  67d405:	75 6c                	jne    67d473 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x3a3>
  67d407:	48 8b 74 24 20       	mov    0x20(%rsp),%rsi
  67d40c:	80 7c 24 08 00       	cmpb   $0x0,0x8(%rsp)
  67d411:	74 26                	je     67d439 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x369>
  67d413:	48 83 fe ff          	cmp    $0xffffffffffffffff,%rsi
  67d417:	44 8b 6c 24 14       	mov    0x14(%rsp),%r13d
  67d41c:	74 5b                	je     67d479 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x3a9>
  67d41e:	48 ff c6             	inc    %rsi
  67d421:	31 c0                	xor    %eax,%eax
  67d423:	48 3b 74 24 18       	cmp    0x18(%rsp),%rsi
  67d428:	0f 92 c0             	setb   %al
  67d42b:	a8 01                	test   $0x1,%al
  67d42d:	74 50                	je     67d47f <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x3af>
  67d42f:	f3 0f 10 05 9d 02 9a 	movss  -0x65fd63(%rip),%xmm0        # 1d6d4 <GCC_except_table0+0xc4>
  67d436:	ff 
  67d437:	eb 2b                	jmp    67d464 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x394>
  67d439:	48 85 f6             	test   %rsi,%rsi
  67d43c:	44 8b 6c 24 14       	mov    0x14(%rsp),%r13d
  67d441:	74 13                	je     67d456 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x386>
  67d443:	48 ff ce             	dec    %rsi
  67d446:	31 c0                	xor    %eax,%eax
  67d448:	48 3b 74 24 18       	cmp    0x18(%rsp),%rsi
  67d44d:	0f 92 c0             	setb   %al
  67d450:	a8 01                	test   $0x1,%al
  67d452:	75 08                	jne    67d45c <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x38c>
  67d454:	eb 29                	jmp    67d47f <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x3af>
  67d456:	31 c0                	xor    %eax,%eax
  67d458:	a8 01                	test   $0x1,%al
  67d45a:	74 23                	je     67d47f <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x3af>
  67d45c:	f3 0f 10 05 5c 02 9a 	movss  -0x65fda4(%rip),%xmm0        # 1d6c0 <GCC_except_table0+0xb0>
  67d463:	ff 
  67d464:	48 89 df             	mov    %rbx,%rdi
  67d467:	e8 44 00 00 00       	call   67d4b0 <<gpui_canvas::text::layout::TextGeometry>::position_on_line>
  67d46c:	89 44 24 04          	mov    %eax,0x4(%rsp)
  67d470:	41 89 d5             	mov    %edx,%r13d
  67d473:	8b 6c 24 04          	mov    0x4(%rsp),%ebp
  67d477:	eb 06                	jmp    67d47f <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x3af>
  67d479:	31 c0                	xor    %eax,%eax
  67d47b:	a8 01                	test   $0x1,%al
  67d47d:	75 b0                	jne    67d42f <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x35f>
  67d47f:	89 e8                	mov    %ebp,%eax
  67d481:	44 89 ea             	mov    %r13d,%edx
  67d484:	48 81 c4 18 01 00 00 	add    $0x118,%rsp
  67d48b:	5b                   	pop    %rbx
  67d48c:	41 5c                	pop    %r12
  67d48e:	41 5d                	pop    %r13
  67d490:	41 5e                	pop    %r14
  67d492:	41 5f                	pop    %r15
  67d494:	5d                   	pop    %rbp
  67d495:	c3                   	ret
  67d496:	48 8d 15 1b 22 10 00 	lea    0x10221b(%rip),%rdx        # 77f6b8 <anon.02b0c3b15283a2e59147821be92759e6.3.llvm.7075943132055672965+0x60>
  67d49d:	ff 15 ed c3 10 00    	call   *0x10c3ed(%rip)        # 789890 <_DYNAMIC+0x368>
