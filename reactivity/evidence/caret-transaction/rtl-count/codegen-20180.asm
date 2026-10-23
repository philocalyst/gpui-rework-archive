
/tmp/gpui-caret-transaction-bin/d54-codegen:     file format elf64-x86-64


Disassembly of section .text:

0000000000020180 <parley::layout::run::count_graphemes>:
   20180:	50                   	push   %rax
   20181:	8b 4f 30             	mov    0x30(%rdi),%ecx
   20184:	8b 47 34             	mov    0x34(%rdi),%eax
   20187:	45 31 c0             	xor    %r8d,%r8d
   2018a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
   20190:	39 c1                	cmp    %eax,%ecx
   20192:	74 2e                	je     201c2 <parley::layout::run::count_graphemes+0x42>
   20194:	48 8b 77 18          	mov    0x18(%rdi),%rsi
   20198:	48 39 ce             	cmp    %rcx,%rsi
   2019b:	0f 86 f1 00 00 00    	jbe    20292 <parley::layout::run::count_graphemes+0x112>
   201a1:	48 ff c8             	dec    %rax
   201a4:	48 39 f0             	cmp    %rsi,%rax
   201a7:	0f 83 f5 00 00 00    	jae    202a2 <parley::layout::run::count_graphemes+0x122>
   201ad:	48 8b 57 10          	mov    0x10(%rdi),%rdx
   201b1:	48 8d 0c 49          	lea    (%rcx,%rcx,2),%rcx
   201b5:	44 8b 0c ca          	mov    (%rdx,%rcx,8),%r9d
   201b9:	48 8d 04 40          	lea    (%rax,%rax,2),%rax
   201bd:	44 8b 44 c2 04       	mov    0x4(%rdx,%rax,8),%r8d
   201c2:	48 8b 57 08          	mov    0x8(%rdi),%rdx
   201c6:	44 89 c8             	mov    %r9d,%eax
   201c9:	44 89 c6             	mov    %r8d,%esi
   201cc:	45 39 c8             	cmp    %r9d,%r8d
   201cf:	0f 82 ad 00 00 00    	jb     20282 <parley::layout::run::count_graphemes+0x102>
   201d5:	48 39 f2             	cmp    %rsi,%rdx
   201d8:	0f 82 a4 00 00 00    	jb     20282 <parley::layout::run::count_graphemes+0x102>
   201de:	39 f0                	cmp    %esi,%eax
   201e0:	75 04                	jne    201e6 <parley::layout::run::count_graphemes+0x66>
   201e2:	31 c0                	xor    %eax,%eax
   201e4:	59                   	pop    %rcx
   201e5:	c3                   	ret
   201e6:	48 8b 0f             	mov    (%rdi),%rcx
   201e9:	48 8d 14 85 00 00 00 	lea    0x0(,%rax,4),%rdx
   201f0:	00 
   201f1:	48 8d 3c 52          	lea    (%rdx,%rdx,2),%rdi
   201f5:	49 89 f0             	mov    %rsi,%r8
   201f8:	49 29 c0             	sub    %rax,%r8
   201fb:	44 89 c2             	mov    %r8d,%edx
   201fe:	83 e2 03             	and    $0x3,%edx
   20201:	48 29 f0             	sub    %rsi,%rax
   20204:	48 83 f8 fc          	cmp    $0xfffffffffffffffc,%rax
   20208:	76 06                	jbe    20210 <parley::layout::run::count_graphemes+0x90>
   2020a:	31 f6                	xor    %esi,%esi
   2020c:	31 c0                	xor    %eax,%eax
   2020e:	eb 41                	jmp    20251 <parley::layout::run::count_graphemes+0xd1>
   20210:	49 83 e0 fc          	and    $0xfffffffffffffffc,%r8
   20214:	4c 8d 0c 0f          	lea    (%rdi,%rcx,1),%r9
   20218:	49 83 c1 2c          	add    $0x2c,%r9
   2021c:	31 f6                	xor    %esi,%esi
   2021e:	31 c0                	xor    %eax,%eax
   20220:	45 0f b6 51 dc       	movzbl -0x24(%r9),%r10d
   20225:	49 01 c2             	add    %rax,%r10
   20228:	41 0f b6 41 e8       	movzbl -0x18(%r9),%eax
   2022d:	45 0f b6 59 f4       	movzbl -0xc(%r9),%r11d
   20232:	49 01 c3             	add    %rax,%r11
   20235:	4d 01 d3             	add    %r10,%r11
   20238:	41 0f b6 01          	movzbl (%r9),%eax
   2023c:	4c 01 d8             	add    %r11,%rax
   2023f:	48 83 c6 04          	add    $0x4,%rsi
   20243:	49 83 c1 30          	add    $0x30,%r9
   20247:	49 39 f0             	cmp    %rsi,%r8
   2024a:	75 d4                	jne    20220 <parley::layout::run::count_graphemes+0xa0>
   2024c:	48 85 d2             	test   %rdx,%rdx
   2024f:	74 2f                	je     20280 <parley::layout::run::count_graphemes+0x100>
   20251:	48 8d 34 76          	lea    (%rsi,%rsi,2),%rsi
   20255:	48 8d 34 b7          	lea    (%rdi,%rsi,4),%rsi
   20259:	48 01 f1             	add    %rsi,%rcx
   2025c:	48 83 c1 08          	add    $0x8,%rcx
   20260:	c1 e2 02             	shl    $0x2,%edx
   20263:	48 8d 14 52          	lea    (%rdx,%rdx,2),%rdx
   20267:	31 f6                	xor    %esi,%esi
   20269:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
   20270:	0f b6 3c 31          	movzbl (%rcx,%rsi,1),%edi
   20274:	48 01 f8             	add    %rdi,%rax
   20277:	48 83 c6 0c          	add    $0xc,%rsi
   2027b:	48 39 f2             	cmp    %rsi,%rdx
   2027e:	75 f0                	jne    20270 <parley::layout::run::count_graphemes+0xf0>
   20280:	59                   	pop    %rcx
   20281:	c3                   	ret
   20282:	48 8d 0d 47 e3 03 00 	lea    0x3e347(%rip),%rcx        # 5e5d0 <anon.5cab36dad6fad55fc602ca21d50a03ec.38.llvm.18336280871641450522+0x48>
   20289:	48 89 c7             	mov    %rax,%rdi
   2028c:	ff 15 6e 01 04 00    	call   *0x4016e(%rip)        # 60400 <_DYNAMIC+0x238>
   20292:	48 8d 15 07 e3 03 00 	lea    0x3e307(%rip),%rdx        # 5e5a0 <anon.5cab36dad6fad55fc602ca21d50a03ec.38.llvm.18336280871641450522+0x18>
   20299:	48 89 cf             	mov    %rcx,%rdi
   2029c:	ff 15 56 01 04 00    	call   *0x40156(%rip)        # 603f8 <_DYNAMIC+0x230>
   202a2:	48 8d 15 0f e3 03 00 	lea    0x3e30f(%rip),%rdx        # 5e5b8 <anon.5cab36dad6fad55fc602ca21d50a03ec.38.llvm.18336280871641450522+0x30>
   202a9:	48 89 c7             	mov    %rax,%rdi
   202ac:	ff 15 46 01 04 00    	call   *0x40146(%rip)        # 603f8 <_DYNAMIC+0x230>
