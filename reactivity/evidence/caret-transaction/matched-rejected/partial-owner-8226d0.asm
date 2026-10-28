
/tmp/gpui-caret-transaction-bin/matched-partial-owner:     file format elf64-x86-64


Disassembly of section .text:

00000000008226d0 <parley::layout::run::count_graphemes>:
  8226d0:	50                   	push   %rax
  8226d1:	8b 4f 30             	mov    0x30(%rdi),%ecx
  8226d4:	8b 47 34             	mov    0x34(%rdi),%eax
  8226d7:	45 31 c0             	xor    %r8d,%r8d
  8226da:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8226e0:	39 c1                	cmp    %eax,%ecx
  8226e2:	74 2e                	je     822712 <parley::layout::run::count_graphemes+0x42>
  8226e4:	48 8b 77 18          	mov    0x18(%rdi),%rsi
  8226e8:	48 39 ce             	cmp    %rcx,%rsi
  8226eb:	0f 86 f1 00 00 00    	jbe    8227e2 <parley::layout::run::count_graphemes+0x112>
  8226f1:	48 ff c8             	dec    %rax
  8226f4:	48 39 f0             	cmp    %rsi,%rax
  8226f7:	0f 83 f5 00 00 00    	jae    8227f2 <parley::layout::run::count_graphemes+0x122>
  8226fd:	48 8b 57 10          	mov    0x10(%rdi),%rdx
  822701:	48 8d 0c 49          	lea    (%rcx,%rcx,2),%rcx
  822705:	44 8b 0c ca          	mov    (%rdx,%rcx,8),%r9d
  822709:	48 8d 04 40          	lea    (%rax,%rax,2),%rax
  82270d:	44 8b 44 c2 04       	mov    0x4(%rdx,%rax,8),%r8d
  822712:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  822716:	44 89 c8             	mov    %r9d,%eax
  822719:	44 89 c6             	mov    %r8d,%esi
  82271c:	45 39 c8             	cmp    %r9d,%r8d
  82271f:	0f 82 ad 00 00 00    	jb     8227d2 <parley::layout::run::count_graphemes+0x102>
  822725:	48 39 f2             	cmp    %rsi,%rdx
  822728:	0f 82 a4 00 00 00    	jb     8227d2 <parley::layout::run::count_graphemes+0x102>
  82272e:	39 f0                	cmp    %esi,%eax
  822730:	75 04                	jne    822736 <parley::layout::run::count_graphemes+0x66>
  822732:	31 c0                	xor    %eax,%eax
  822734:	59                   	pop    %rcx
  822735:	c3                   	ret
  822736:	48 8b 0f             	mov    (%rdi),%rcx
  822739:	48 8d 14 85 00 00 00 	lea    0x0(,%rax,4),%rdx
  822740:	00 
  822741:	48 8d 3c 52          	lea    (%rdx,%rdx,2),%rdi
  822745:	49 89 f0             	mov    %rsi,%r8
  822748:	49 29 c0             	sub    %rax,%r8
  82274b:	44 89 c2             	mov    %r8d,%edx
  82274e:	83 e2 03             	and    $0x3,%edx
  822751:	48 29 f0             	sub    %rsi,%rax
  822754:	48 83 f8 fc          	cmp    $0xfffffffffffffffc,%rax
  822758:	76 06                	jbe    822760 <parley::layout::run::count_graphemes+0x90>
  82275a:	31 f6                	xor    %esi,%esi
  82275c:	31 c0                	xor    %eax,%eax
  82275e:	eb 41                	jmp    8227a1 <parley::layout::run::count_graphemes+0xd1>
  822760:	49 83 e0 fc          	and    $0xfffffffffffffffc,%r8
  822764:	4c 8d 0c 0f          	lea    (%rdi,%rcx,1),%r9
  822768:	49 83 c1 2c          	add    $0x2c,%r9
  82276c:	31 f6                	xor    %esi,%esi
  82276e:	31 c0                	xor    %eax,%eax
  822770:	45 0f b6 51 dc       	movzbl -0x24(%r9),%r10d
  822775:	49 01 c2             	add    %rax,%r10
  822778:	41 0f b6 41 e8       	movzbl -0x18(%r9),%eax
  82277d:	45 0f b6 59 f4       	movzbl -0xc(%r9),%r11d
  822782:	49 01 c3             	add    %rax,%r11
  822785:	4d 01 d3             	add    %r10,%r11
  822788:	41 0f b6 01          	movzbl (%r9),%eax
  82278c:	4c 01 d8             	add    %r11,%rax
  82278f:	48 83 c6 04          	add    $0x4,%rsi
  822793:	49 83 c1 30          	add    $0x30,%r9
  822797:	49 39 f0             	cmp    %rsi,%r8
  82279a:	75 d4                	jne    822770 <parley::layout::run::count_graphemes+0xa0>
  82279c:	48 85 d2             	test   %rdx,%rdx
  82279f:	74 2f                	je     8227d0 <parley::layout::run::count_graphemes+0x100>
  8227a1:	48 8d 34 76          	lea    (%rsi,%rsi,2),%rsi
  8227a5:	48 8d 34 b7          	lea    (%rdi,%rsi,4),%rsi
  8227a9:	48 01 f1             	add    %rsi,%rcx
  8227ac:	48 83 c1 08          	add    $0x8,%rcx
  8227b0:	c1 e2 02             	shl    $0x2,%edx
  8227b3:	48 8d 14 52          	lea    (%rdx,%rdx,2),%rdx
  8227b7:	31 f6                	xor    %esi,%esi
  8227b9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  8227c0:	0f b6 3c 31          	movzbl (%rcx,%rsi,1),%edi
  8227c4:	48 01 f8             	add    %rdi,%rax
  8227c7:	48 83 c6 0c          	add    $0xc,%rsi
  8227cb:	48 39 f2             	cmp    %rsi,%rdx
  8227ce:	75 f0                	jne    8227c0 <parley::layout::run::count_graphemes+0xf0>
  8227d0:	59                   	pop    %rcx
  8227d1:	c3                   	ret
  8227d2:	48 8d 0d 27 67 2e 00 	lea    0x2e6727(%rip),%rcx        # b08f00 <anon.97dd8fb1496aa0f0054e7c6c599bcb8c.10.llvm.16205090024431963752+0xc8>
  8227d9:	48 89 c7             	mov    %rax,%rdi
  8227dc:	ff 15 ae af 30 00    	call   *0x30afae(%rip)        # b2d790 <_DYNAMIC+0x290>
  8227e2:	48 8d 15 e7 66 2e 00 	lea    0x2e66e7(%rip),%rdx        # b08ed0 <anon.97dd8fb1496aa0f0054e7c6c599bcb8c.10.llvm.16205090024431963752+0x98>
  8227e9:	48 89 cf             	mov    %rcx,%rdi
  8227ec:	ff 15 de af 30 00    	call   *0x30afde(%rip)        # b2d7d0 <_DYNAMIC+0x2d0>
  8227f2:	48 8d 15 ef 66 2e 00 	lea    0x2e66ef(%rip),%rdx        # b08ee8 <anon.97dd8fb1496aa0f0054e7c6c599bcb8c.10.llvm.16205090024431963752+0xb0>
  8227f9:	48 89 c7             	mov    %rax,%rdi
  8227fc:	ff 15 ce af 30 00    	call   *0x30afce(%rip)        # b2d7d0 <_DYNAMIC+0x2d0>
