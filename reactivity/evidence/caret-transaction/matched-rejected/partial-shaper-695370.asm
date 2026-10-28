
/tmp/gpui-caret-transaction-bin/matched-partial-caret_pair_measure:     file format elf64-x86-64


Disassembly of section .text:

0000000000695370 <parley::layout::run::count_graphemes>:
  695370:	50                   	push   %rax
  695371:	8b 4f 30             	mov    0x30(%rdi),%ecx
  695374:	8b 47 34             	mov    0x34(%rdi),%eax
  695377:	45 31 c0             	xor    %r8d,%r8d
  69537a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  695380:	39 c1                	cmp    %eax,%ecx
  695382:	74 2e                	je     6953b2 <parley::layout::run::count_graphemes+0x42>
  695384:	48 8b 77 18          	mov    0x18(%rdi),%rsi
  695388:	48 39 ce             	cmp    %rcx,%rsi
  69538b:	0f 86 f1 00 00 00    	jbe    695482 <parley::layout::run::count_graphemes+0x112>
  695391:	48 ff c8             	dec    %rax
  695394:	48 39 f0             	cmp    %rsi,%rax
  695397:	0f 83 f5 00 00 00    	jae    695492 <parley::layout::run::count_graphemes+0x122>
  69539d:	48 8b 57 10          	mov    0x10(%rdi),%rdx
  6953a1:	48 8d 0c 49          	lea    (%rcx,%rcx,2),%rcx
  6953a5:	44 8b 0c ca          	mov    (%rdx,%rcx,8),%r9d
  6953a9:	48 8d 04 40          	lea    (%rax,%rax,2),%rax
  6953ad:	44 8b 44 c2 04       	mov    0x4(%rdx,%rax,8),%r8d
  6953b2:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  6953b6:	44 89 c8             	mov    %r9d,%eax
  6953b9:	44 89 c6             	mov    %r8d,%esi
  6953bc:	45 39 c8             	cmp    %r9d,%r8d
  6953bf:	0f 82 ad 00 00 00    	jb     695472 <parley::layout::run::count_graphemes+0x102>
  6953c5:	48 39 f2             	cmp    %rsi,%rdx
  6953c8:	0f 82 a4 00 00 00    	jb     695472 <parley::layout::run::count_graphemes+0x102>
  6953ce:	39 f0                	cmp    %esi,%eax
  6953d0:	75 04                	jne    6953d6 <parley::layout::run::count_graphemes+0x66>
  6953d2:	31 c0                	xor    %eax,%eax
  6953d4:	59                   	pop    %rcx
  6953d5:	c3                   	ret
  6953d6:	48 8b 0f             	mov    (%rdi),%rcx
  6953d9:	48 8d 14 85 00 00 00 	lea    0x0(,%rax,4),%rdx
  6953e0:	00 
  6953e1:	48 8d 3c 52          	lea    (%rdx,%rdx,2),%rdi
  6953e5:	49 89 f0             	mov    %rsi,%r8
  6953e8:	49 29 c0             	sub    %rax,%r8
  6953eb:	44 89 c2             	mov    %r8d,%edx
  6953ee:	83 e2 03             	and    $0x3,%edx
  6953f1:	48 29 f0             	sub    %rsi,%rax
  6953f4:	48 83 f8 fc          	cmp    $0xfffffffffffffffc,%rax
  6953f8:	76 06                	jbe    695400 <parley::layout::run::count_graphemes+0x90>
  6953fa:	31 f6                	xor    %esi,%esi
  6953fc:	31 c0                	xor    %eax,%eax
  6953fe:	eb 41                	jmp    695441 <parley::layout::run::count_graphemes+0xd1>
  695400:	49 83 e0 fc          	and    $0xfffffffffffffffc,%r8
  695404:	4c 8d 0c 0f          	lea    (%rdi,%rcx,1),%r9
  695408:	49 83 c1 2c          	add    $0x2c,%r9
  69540c:	31 f6                	xor    %esi,%esi
  69540e:	31 c0                	xor    %eax,%eax
  695410:	45 0f b6 51 dc       	movzbl -0x24(%r9),%r10d
  695415:	49 01 c2             	add    %rax,%r10
  695418:	41 0f b6 41 e8       	movzbl -0x18(%r9),%eax
  69541d:	45 0f b6 59 f4       	movzbl -0xc(%r9),%r11d
  695422:	49 01 c3             	add    %rax,%r11
  695425:	4d 01 d3             	add    %r10,%r11
  695428:	41 0f b6 01          	movzbl (%r9),%eax
  69542c:	4c 01 d8             	add    %r11,%rax
  69542f:	48 83 c6 04          	add    $0x4,%rsi
  695433:	49 83 c1 30          	add    $0x30,%r9
  695437:	49 39 f0             	cmp    %rsi,%r8
  69543a:	75 d4                	jne    695410 <parley::layout::run::count_graphemes+0xa0>
  69543c:	48 85 d2             	test   %rdx,%rdx
  69543f:	74 2f                	je     695470 <parley::layout::run::count_graphemes+0x100>
  695441:	48 8d 34 76          	lea    (%rsi,%rsi,2),%rsi
  695445:	48 8d 34 b7          	lea    (%rdi,%rsi,4),%rsi
  695449:	48 01 f1             	add    %rsi,%rcx
  69544c:	48 83 c1 08          	add    $0x8,%rcx
  695450:	c1 e2 02             	shl    $0x2,%edx
  695453:	48 8d 14 52          	lea    (%rdx,%rdx,2),%rdx
  695457:	31 f6                	xor    %esi,%esi
  695459:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  695460:	0f b6 3c 31          	movzbl (%rcx,%rsi,1),%edi
  695464:	48 01 f8             	add    %rdi,%rax
  695467:	48 83 c6 0c          	add    $0xc,%rsi
  69546b:	48 39 f2             	cmp    %rsi,%rdx
  69546e:	75 f0                	jne    695460 <parley::layout::run::count_graphemes+0xf0>
  695470:	59                   	pop    %rcx
  695471:	c3                   	ret
  695472:	48 8d 0d 3f a6 0e 00 	lea    0xea63f(%rip),%rcx        # 77fab8 <anon.b42a308b8359851fff1cbab576b7b1be.8.llvm.8969209203732302506+0x138>
  695479:	48 89 c7             	mov    %rax,%rdi
  69547c:	ff 15 ee 3e 0f 00    	call   *0xf3eee(%rip)        # 789370 <_DYNAMIC+0x558>
  695482:	48 8d 15 ff a5 0e 00 	lea    0xea5ff(%rip),%rdx        # 77fa88 <anon.b42a308b8359851fff1cbab576b7b1be.8.llvm.8969209203732302506+0x108>
  695489:	48 89 cf             	mov    %rcx,%rdi
  69548c:	ff 15 e6 3c 0f 00    	call   *0xf3ce6(%rip)        # 789178 <_DYNAMIC+0x360>
  695492:	48 8d 15 07 a6 0e 00 	lea    0xea607(%rip),%rdx        # 77faa0 <anon.b42a308b8359851fff1cbab576b7b1be.8.llvm.8969209203732302506+0x120>
  695499:	48 89 c7             	mov    %rax,%rdi
  69549c:	ff 15 d6 3c 0f 00    	call   *0xf3cd6(%rip)        # 789178 <_DYNAMIC+0x360>
