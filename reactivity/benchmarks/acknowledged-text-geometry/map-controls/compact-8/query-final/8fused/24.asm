
/tmp/gpui-text-map-query-final/8fused/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

0000000000680320 <<gpui_canvas::text::layout::TextGeometry>::line_tail>:
  680320:	53                   	push   %rbx
  680321:	4c 8b 0e             	mov    (%rsi),%r9
  680324:	4c 8b 56 10          	mov    0x10(%rsi),%r10
  680328:	31 c9                	xor    %ecx,%ecx
  68032a:	49 83 f9 02          	cmp    $0x2,%r9
  68032e:	41 b8 04 00 00 00    	mov    $0x4,%r8d
  680334:	4c 0f 45 46 08       	cmovne 0x8(%rsi),%r8
  680339:	49 0f 45 ca          	cmovne %r10,%rcx
  68033d:	48 8b 46 40          	mov    0x40(%rsi),%rax
  680341:	48 39 c2             	cmp    %rax,%rdx
  680344:	0f 83 ce 00 00 00    	jae    680418 <<gpui_canvas::text::layout::TextGeometry>::line_tail+0xf8>
  68034a:	48 8b 46 38          	mov    0x38(%rsi),%rax
  68034e:	48 8d 14 52          	lea    (%rdx,%rdx,2),%rdx
  680352:	8b 14 d0             	mov    (%rax,%rdx,8),%edx
  680355:	85 d2                	test   %edx,%edx
  680357:	74 48                	je     6803a1 <<gpui_canvas::text::layout::TextGeometry>::line_tail+0x81>
  680359:	48 89 c8             	mov    %rcx,%rax
  68035c:	41 f6 c1 01          	test   $0x1,%r9b
  680360:	75 49                	jne    6803ab <<gpui_canvas::text::layout::TextGeometry>::line_tail+0x8b>
  680362:	48 85 c9             	test   %rcx,%rcx
  680365:	0f 84 88 00 00 00    	je     6803f3 <<gpui_canvas::text::layout::TextGeometry>::line_tail+0xd3>
  68036b:	31 c0                	xor    %eax,%eax
  68036d:	48 83 f9 01          	cmp    $0x1,%rcx
  680371:	74 28                	je     68039b <<gpui_canvas::text::layout::TextGeometry>::line_tail+0x7b>
  680373:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  68037a:	84 00 00 00 00 00 
  680380:	4c 89 d6             	mov    %r10,%rsi
  680383:	48 d1 ee             	shr    $1,%rsi
  680386:	4c 8d 1c 06          	lea    (%rsi,%rax,1),%r11
  68038a:	43 39 14 d8          	cmp    %edx,(%r8,%r11,8)
  68038e:	49 0f 42 c3          	cmovb  %r11,%rax
  680392:	49 29 f2             	sub    %rsi,%r10
  680395:	49 83 fa 01          	cmp    $0x1,%r10
  680399:	77 e5                	ja     680380 <<gpui_canvas::text::layout::TextGeometry>::line_tail+0x60>
  68039b:	49 8d 34 c0          	lea    (%r8,%rax,8),%rsi
  68039f:	eb 46                	jmp    6803e7 <<gpui_canvas::text::layout::TextGeometry>::line_tail+0xc7>
  6803a1:	31 c0                	xor    %eax,%eax
  6803a3:	41 f6 c1 01          	test   $0x1,%r9b
  6803a7:	74 4a                	je     6803f3 <<gpui_canvas::text::layout::TextGeometry>::line_tail+0xd3>
  6803a9:	eb 50                	jmp    6803fb <<gpui_canvas::text::layout::TextGeometry>::line_tail+0xdb>
  6803ab:	48 85 c9             	test   %rcx,%rcx
  6803ae:	74 4b                	je     6803fb <<gpui_canvas::text::layout::TextGeometry>::line_tail+0xdb>
  6803b0:	31 c0                	xor    %eax,%eax
  6803b2:	48 83 f9 01          	cmp    $0x1,%rcx
  6803b6:	74 27                	je     6803df <<gpui_canvas::text::layout::TextGeometry>::line_tail+0xbf>
  6803b8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  6803bf:	00 
  6803c0:	4c 89 d6             	mov    %r10,%rsi
  6803c3:	48 d1 ee             	shr    $1,%rsi
  6803c6:	4c 8d 1c 06          	lea    (%rsi,%rax,1),%r11
  6803ca:	4b 8d 1c 5b          	lea    (%r11,%r11,2),%rbx
  6803ce:	41 39 14 98          	cmp    %edx,(%r8,%rbx,4)
  6803d2:	49 0f 42 c3          	cmovb  %r11,%rax
  6803d6:	49 29 f2             	sub    %rsi,%r10
  6803d9:	49 83 fa 01          	cmp    $0x1,%r10
  6803dd:	77 e1                	ja     6803c0 <<gpui_canvas::text::layout::TextGeometry>::line_tail+0xa0>
  6803df:	48 8d 34 40          	lea    (%rax,%rax,2),%rsi
  6803e3:	49 8d 34 b0          	lea    (%r8,%rsi,4),%rsi
  6803e7:	39 16                	cmp    %edx,(%rsi)
  6803e9:	48 83 d0 00          	adc    $0x0,%rax
  6803ed:	41 f6 c1 01          	test   $0x1,%r9b
  6803f1:	75 08                	jne    6803fb <<gpui_canvas::text::layout::TextGeometry>::line_tail+0xdb>
  6803f3:	49 8d 14 c0          	lea    (%r8,%rax,8),%rdx
  6803f7:	31 f6                	xor    %esi,%esi
  6803f9:	eb 0d                	jmp    680408 <<gpui_canvas::text::layout::TextGeometry>::line_tail+0xe8>
  6803fb:	48 8d 14 40          	lea    (%rax,%rax,2),%rdx
  6803ff:	49 8d 14 90          	lea    (%r8,%rdx,4),%rdx
  680403:	be 01 00 00 00       	mov    $0x1,%esi
  680408:	48 29 c1             	sub    %rax,%rcx
  68040b:	48 89 57 08          	mov    %rdx,0x8(%rdi)
  68040f:	48 89 4f 10          	mov    %rcx,0x10(%rdi)
  680413:	48 89 37             	mov    %rsi,(%rdi)
  680416:	5b                   	pop    %rbx
  680417:	c3                   	ret
  680418:	48 8d 0d 31 f4 0f 00 	lea    0xff431(%rip),%rcx        # 77f850 <anon.02b0c3b15283a2e59147821be92759e6.28.llvm.7075943132055672965+0xf0>
  68041f:	48 89 d7             	mov    %rdx,%rdi
  680422:	48 89 c6             	mov    %rax,%rsi
  680425:	48 89 ca             	mov    %rcx,%rdx
  680428:	ff 15 62 94 10 00    	call   *0x109462(%rip)        # 789890 <_DYNAMIC+0x368>
