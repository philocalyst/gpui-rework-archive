
/tmp/gpui-text-map-query-refinements/12checked/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

0000000000662390 <<gpui_canvas::text::layout::TextGeometry>::stop_bounds>:
  662390:	53                   	push   %rbx
  662391:	f6 42 08 01          	testb  $0x1,0x8(%rdx)
  662395:	44 8b 02             	mov    (%rdx),%r8d
  662398:	48 8b 4e 20          	mov    0x20(%rsi),%rcx
  66239c:	48 8b 76 28          	mov    0x28(%rsi),%rsi
  6623a0:	74 58                	je     6623fa <<gpui_canvas::text::layout::TextGeometry>::stop_bounds+0x6a>
  6623a2:	45 85 c0             	test   %r8d,%r8d
  6623a5:	74 53                	je     6623fa <<gpui_canvas::text::layout::TextGeometry>::stop_bounds+0x6a>
  6623a7:	48 89 f0             	mov    %rsi,%rax
  6623aa:	48 85 f6             	test   %rsi,%rsi
  6623ad:	74 3e                	je     6623ed <<gpui_canvas::text::layout::TextGeometry>::stop_bounds+0x5d>
  6623af:	31 c0                	xor    %eax,%eax
  6623b1:	48 83 fe 01          	cmp    $0x1,%rsi
  6623b5:	74 29                	je     6623e0 <<gpui_canvas::text::layout::TextGeometry>::stop_bounds+0x50>
  6623b7:	49 89 f1             	mov    %rsi,%r9
  6623ba:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  6623c0:	4d 89 ca             	mov    %r9,%r10
  6623c3:	49 d1 ea             	shr    $1,%r10
  6623c6:	4d 8d 1c 02          	lea    (%r10,%rax,1),%r11
  6623ca:	4b 8d 1c 5b          	lea    (%r11,%r11,2),%rbx
  6623ce:	44 39 44 d9 04       	cmp    %r8d,0x4(%rcx,%rbx,8)
  6623d3:	49 0f 42 c3          	cmovb  %r11,%rax
  6623d7:	4d 29 d1             	sub    %r10,%r9
  6623da:	49 83 f9 01          	cmp    $0x1,%r9
  6623de:	77 e0                	ja     6623c0 <<gpui_canvas::text::layout::TextGeometry>::stop_bounds+0x30>
  6623e0:	4c 8d 0c 40          	lea    (%rax,%rax,2),%r9
  6623e4:	46 39 44 c9 04       	cmp    %r8d,0x4(%rcx,%r9,8)
  6623e9:	48 83 d0 00          	adc    $0x0,%rax
  6623ed:	4c 8d 46 ff          	lea    -0x1(%rsi),%r8
  6623f1:	49 39 c0             	cmp    %rax,%r8
  6623f4:	49 0f 42 c0          	cmovb  %r8,%rax
  6623f8:	eb 4f                	jmp    662449 <<gpui_canvas::text::layout::TextGeometry>::stop_bounds+0xb9>
  6623fa:	48 89 f0             	mov    %rsi,%rax
  6623fd:	48 85 f6             	test   %rsi,%rsi
  662400:	74 47                	je     662449 <<gpui_canvas::text::layout::TextGeometry>::stop_bounds+0xb9>
  662402:	45 31 c9             	xor    %r9d,%r9d
  662405:	48 83 fe 01          	cmp    $0x1,%rsi
  662409:	74 26                	je     662431 <<gpui_canvas::text::layout::TextGeometry>::stop_bounds+0xa1>
  66240b:	48 89 f0             	mov    %rsi,%rax
  66240e:	66 90                	xchg   %ax,%ax
  662410:	4d 89 ca             	mov    %r9,%r10
  662413:	49 89 c3             	mov    %rax,%r11
  662416:	49 d1 eb             	shr    $1,%r11
  662419:	4d 01 d9             	add    %r11,%r9
  66241c:	4b 8d 1c 49          	lea    (%r9,%r9,2),%rbx
  662420:	44 39 04 d9          	cmp    %r8d,(%rcx,%rbx,8)
  662424:	4d 0f 47 ca          	cmova  %r10,%r9
  662428:	4c 29 d8             	sub    %r11,%rax
  66242b:	48 83 f8 01          	cmp    $0x1,%rax
  66242f:	77 df                	ja     662410 <<gpui_canvas::text::layout::TextGeometry>::stop_bounds+0x80>
  662431:	4f 8d 14 49          	lea    (%r9,%r9,2),%r10
  662435:	31 c0                	xor    %eax,%eax
  662437:	46 39 04 d1          	cmp    %r8d,(%rcx,%r10,8)
  66243b:	0f 96 c0             	setbe  %al
  66243e:	4c 01 c8             	add    %r9,%rax
  662441:	48 83 f8 01          	cmp    $0x1,%rax
  662445:	48 83 d0 ff          	adc    $0xffffffffffffffff,%rax
  662449:	48 39 f0             	cmp    %rsi,%rax
  66244c:	73 3d                	jae    66248b <<gpui_canvas::text::layout::TextGeometry>::stop_bounds+0xfb>
  66244e:	48 8d 04 40          	lea    (%rax,%rax,2),%rax
  662452:	f3 0f 10 42 04       	movss  0x4(%rdx),%xmm0
  662457:	f3 0f 10 0d 1d b0 9b 	movss  -0x644fe3(%rip),%xmm1        # 1d47c <GCC_except_table0+0x3c>
  66245e:	ff 
  66245f:	f3 0f 58 c8          	addss  %xmm0,%xmm1
  662463:	f3 0f 5c c8          	subss  %xmm0,%xmm1
  662467:	f3 0f 10 54 c1 08    	movss  0x8(%rcx,%rax,8),%xmm2
  66246d:	f3 0f 10 5c c1 0c    	movss  0xc(%rcx,%rax,8),%xmm3
  662473:	f3 0f 11 07          	movss  %xmm0,(%rdi)
  662477:	f3 0f 11 57 04       	movss  %xmm2,0x4(%rdi)
  66247c:	f3 0f 11 4f 08       	movss  %xmm1,0x8(%rdi)
  662481:	f3 0f 11 5f 0c       	movss  %xmm3,0xc(%rdi)
  662486:	48 89 f8             	mov    %rdi,%rax
  662489:	5b                   	pop    %rbx
  66248a:	c3                   	ret
  66248b:	48 8d 15 7e a2 11 00 	lea    0x11a27e(%rip),%rdx        # 77c710 <anon.0ce93d74e9d39703631c89632b12715b.3.llvm.7854699070981760621+0x30>
  662492:	48 89 c7             	mov    %rax,%rdi
  662495:	ff 15 25 50 12 00    	call   *0x125025(%rip)        # 7874c0 <_DYNAMIC+0x3a0>
