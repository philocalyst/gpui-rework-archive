
/tmp/gpui-caret-transaction-bin/62e-codegen:     file format elf64-x86-64


Disassembly of section .text:

00000000000200f0 <parley::layout::run::count_graphemes>:
   200f0:	50                   	push   %rax
   200f1:	8b 4f 30             	mov    0x30(%rdi),%ecx
   200f4:	8b 47 34             	mov    0x34(%rdi),%eax
   200f7:	45 31 c0             	xor    %r8d,%r8d
   200fa:	41 b9 00 00 00 00    	mov    $0x0,%r9d
   20100:	39 c1                	cmp    %eax,%ecx
   20102:	74 2e                	je     20132 <parley::layout::run::count_graphemes+0x42>
   20104:	48 8b 77 18          	mov    0x18(%rdi),%rsi
   20108:	48 39 ce             	cmp    %rcx,%rsi
   2010b:	0f 86 f1 00 00 00    	jbe    20202 <parley::layout::run::count_graphemes+0x112>
   20111:	48 ff c8             	dec    %rax
   20114:	48 39 f0             	cmp    %rsi,%rax
   20117:	0f 83 f5 00 00 00    	jae    20212 <parley::layout::run::count_graphemes+0x122>
   2011d:	48 8b 57 10          	mov    0x10(%rdi),%rdx
   20121:	48 8d 0c 49          	lea    (%rcx,%rcx,2),%rcx
   20125:	44 8b 0c ca          	mov    (%rdx,%rcx,8),%r9d
   20129:	48 8d 04 40          	lea    (%rax,%rax,2),%rax
   2012d:	44 8b 44 c2 04       	mov    0x4(%rdx,%rax,8),%r8d
   20132:	48 8b 57 08          	mov    0x8(%rdi),%rdx
   20136:	44 89 c8             	mov    %r9d,%eax
   20139:	44 89 c6             	mov    %r8d,%esi
   2013c:	45 39 c8             	cmp    %r9d,%r8d
   2013f:	0f 82 ad 00 00 00    	jb     201f2 <parley::layout::run::count_graphemes+0x102>
   20145:	48 39 f2             	cmp    %rsi,%rdx
   20148:	0f 82 a4 00 00 00    	jb     201f2 <parley::layout::run::count_graphemes+0x102>
   2014e:	39 f0                	cmp    %esi,%eax
   20150:	75 04                	jne    20156 <parley::layout::run::count_graphemes+0x66>
   20152:	31 c0                	xor    %eax,%eax
   20154:	59                   	pop    %rcx
   20155:	c3                   	ret
   20156:	48 8b 0f             	mov    (%rdi),%rcx
   20159:	48 8d 14 85 00 00 00 	lea    0x0(,%rax,4),%rdx
   20160:	00 
   20161:	48 8d 3c 52          	lea    (%rdx,%rdx,2),%rdi
   20165:	49 89 f0             	mov    %rsi,%r8
   20168:	49 29 c0             	sub    %rax,%r8
   2016b:	44 89 c2             	mov    %r8d,%edx
   2016e:	83 e2 03             	and    $0x3,%edx
   20171:	48 29 f0             	sub    %rsi,%rax
   20174:	48 83 f8 fc          	cmp    $0xfffffffffffffffc,%rax
   20178:	76 06                	jbe    20180 <parley::layout::run::count_graphemes+0x90>
   2017a:	31 f6                	xor    %esi,%esi
   2017c:	31 c0                	xor    %eax,%eax
   2017e:	eb 41                	jmp    201c1 <parley::layout::run::count_graphemes+0xd1>
   20180:	49 83 e0 fc          	and    $0xfffffffffffffffc,%r8
   20184:	4c 8d 0c 0f          	lea    (%rdi,%rcx,1),%r9
   20188:	49 83 c1 2c          	add    $0x2c,%r9
   2018c:	31 f6                	xor    %esi,%esi
   2018e:	31 c0                	xor    %eax,%eax
   20190:	45 0f b6 51 dc       	movzbl -0x24(%r9),%r10d
   20195:	49 01 c2             	add    %rax,%r10
   20198:	41 0f b6 41 e8       	movzbl -0x18(%r9),%eax
   2019d:	45 0f b6 59 f4       	movzbl -0xc(%r9),%r11d
   201a2:	49 01 c3             	add    %rax,%r11
   201a5:	4d 01 d3             	add    %r10,%r11
   201a8:	41 0f b6 01          	movzbl (%r9),%eax
   201ac:	4c 01 d8             	add    %r11,%rax
   201af:	48 83 c6 04          	add    $0x4,%rsi
   201b3:	49 83 c1 30          	add    $0x30,%r9
   201b7:	49 39 f0             	cmp    %rsi,%r8
   201ba:	75 d4                	jne    20190 <parley::layout::run::count_graphemes+0xa0>
   201bc:	48 85 d2             	test   %rdx,%rdx
   201bf:	74 2f                	je     201f0 <parley::layout::run::count_graphemes+0x100>
   201c1:	48 8d 34 76          	lea    (%rsi,%rsi,2),%rsi
   201c5:	48 8d 34 b7          	lea    (%rdi,%rsi,4),%rsi
   201c9:	48 01 f1             	add    %rsi,%rcx
   201cc:	48 83 c1 08          	add    $0x8,%rcx
   201d0:	c1 e2 02             	shl    $0x2,%edx
   201d3:	48 8d 14 52          	lea    (%rdx,%rdx,2),%rdx
   201d7:	31 f6                	xor    %esi,%esi
   201d9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
   201e0:	0f b6 3c 31          	movzbl (%rcx,%rsi,1),%edi
   201e4:	48 01 f8             	add    %rdi,%rax
   201e7:	48 83 c6 0c          	add    $0xc,%rsi
   201eb:	48 39 f2             	cmp    %rsi,%rdx
   201ee:	75 f0                	jne    201e0 <parley::layout::run::count_graphemes+0xf0>
   201f0:	59                   	pop    %rcx
   201f1:	c3                   	ret
   201f2:	48 8d 0d 27 e3 03 00 	lea    0x3e327(%rip),%rcx        # 5e520 <anon.5cab36dad6fad55fc602ca21d50a03ec.38.llvm.4639087895861959750+0x48>
   201f9:	48 89 c7             	mov    %rax,%rdi
   201fc:	ff 15 4e 01 04 00    	call   *0x4014e(%rip)        # 60350 <_DYNAMIC+0x238>
   20202:	48 8d 15 e7 e2 03 00 	lea    0x3e2e7(%rip),%rdx        # 5e4f0 <anon.5cab36dad6fad55fc602ca21d50a03ec.38.llvm.4639087895861959750+0x18>
   20209:	48 89 cf             	mov    %rcx,%rdi
   2020c:	ff 15 36 01 04 00    	call   *0x40136(%rip)        # 60348 <_DYNAMIC+0x230>
   20212:	48 8d 15 ef e2 03 00 	lea    0x3e2ef(%rip),%rdx        # 5e508 <anon.5cab36dad6fad55fc602ca21d50a03ec.38.llvm.4639087895861959750+0x30>
   20219:	48 89 c7             	mov    %rax,%rdi
   2021c:	ff 15 26 01 04 00    	call   *0x40126(%rip)        # 60348 <_DYNAMIC+0x230>
