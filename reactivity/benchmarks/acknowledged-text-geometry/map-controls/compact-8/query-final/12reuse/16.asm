
/tmp/gpui-text-map-query-final/12reuse/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

0000000000681340 <<gpui_canvas::text::layout::TextGeometry>::stops>:
  681340:	53                   	push   %rbx
  681341:	89 d0                	mov    %edx,%eax
  681343:	31 d2                	xor    %edx,%edx
  681345:	48 83 7f 30 ff       	cmpq   $0xffffffffffffffff,0x30(%rdi)
  68134a:	4c 8b 47 40          	mov    0x40(%rdi),%r8
  68134e:	49 0f 45 d0          	cmovne %r8,%rdx
  681352:	b9 04 00 00 00       	mov    $0x4,%ecx
  681357:	48 0f 45 4f 38       	cmovne 0x38(%rdi),%rcx
  68135c:	85 f6                	test   %esi,%esi
  68135e:	74 4c                	je     6813ac <<gpui_canvas::text::layout::TextGeometry>::stops+0x6c>
  681360:	48 85 d2             	test   %rdx,%rdx
  681363:	0f 84 96 00 00 00    	je     6813ff <<gpui_canvas::text::layout::TextGeometry>::stops+0xbf>
  681369:	31 ff                	xor    %edi,%edi
  68136b:	48 83 fa 01          	cmp    $0x1,%rdx
  68136f:	74 2d                	je     68139e <<gpui_canvas::text::layout::TextGeometry>::stops+0x5e>
  681371:	4d 89 c1             	mov    %r8,%r9
  681374:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
  68137b:	00 00 00 00 00 
  681380:	4d 89 ca             	mov    %r9,%r10
  681383:	49 d1 ea             	shr    $1,%r10
  681386:	4d 8d 1c 3a          	lea    (%r10,%rdi,1),%r11
  68138a:	4b 8d 1c 5b          	lea    (%r11,%r11,2),%rbx
  68138e:	39 34 99             	cmp    %esi,(%rcx,%rbx,4)
  681391:	49 0f 42 fb          	cmovb  %r11,%rdi
  681395:	4d 29 d1             	sub    %r10,%r9
  681398:	49 83 f9 01          	cmp    $0x1,%r9
  68139c:	77 e2                	ja     681380 <<gpui_canvas::text::layout::TextGeometry>::stops+0x40>
  68139e:	4c 8d 0c 7f          	lea    (%rdi,%rdi,2),%r9
  6813a2:	42 39 34 89          	cmp    %esi,(%rcx,%r9,4)
  6813a6:	48 83 d7 00          	adc    $0x0,%rdi
  6813aa:	eb 0c                	jmp    6813b8 <<gpui_canvas::text::layout::TextGeometry>::stops+0x78>
  6813ac:	31 ff                	xor    %edi,%edi
  6813ae:	be 00 00 00 00       	mov    $0x0,%esi
  6813b3:	48 85 d2             	test   %rdx,%rdx
  6813b6:	74 4d                	je     681405 <<gpui_canvas::text::layout::TextGeometry>::stops+0xc5>
  6813b8:	31 f6                	xor    %esi,%esi
  6813ba:	48 83 fa 01          	cmp    $0x1,%rdx
  6813be:	74 21                	je     6813e1 <<gpui_canvas::text::layout::TextGeometry>::stops+0xa1>
  6813c0:	49 89 f1             	mov    %rsi,%r9
  6813c3:	4d 89 c2             	mov    %r8,%r10
  6813c6:	49 d1 ea             	shr    $1,%r10
  6813c9:	4c 01 d6             	add    %r10,%rsi
  6813cc:	4c 8d 1c 76          	lea    (%rsi,%rsi,2),%r11
  6813d0:	42 39 04 99          	cmp    %eax,(%rcx,%r11,4)
  6813d4:	49 0f 47 f1          	cmova  %r9,%rsi
  6813d8:	4d 29 d0             	sub    %r10,%r8
  6813db:	49 83 f8 01          	cmp    $0x1,%r8
  6813df:	77 df                	ja     6813c0 <<gpui_canvas::text::layout::TextGeometry>::stops+0x80>
  6813e1:	4c 8d 04 76          	lea    (%rsi,%rsi,2),%r8
  6813e5:	42 3b 04 81          	cmp    (%rcx,%r8,4),%eax
  6813e9:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
  6813ed:	48 39 fe             	cmp    %rdi,%rsi
  6813f0:	73 13                	jae    681405 <<gpui_canvas::text::layout::TextGeometry>::stops+0xc5>
  6813f2:	48 8d 0d 67 c5 0f 00 	lea    0xfc567(%rip),%rcx        # 77d960 <anon.11946e5055af849423ef6f6fa3ccb0e0.6.llvm.6812186184794855116+0x60>
  6813f9:	ff 15 a9 64 10 00    	call   *0x1064a9(%rip)        # 7878a8 <_DYNAMIC+0x588>
  6813ff:	48 89 d6             	mov    %rdx,%rsi
  681402:	48 89 d7             	mov    %rdx,%rdi
  681405:	48 29 fe             	sub    %rdi,%rsi
  681408:	48 8d 04 7f          	lea    (%rdi,%rdi,2),%rax
  68140c:	48 8d 04 81          	lea    (%rcx,%rax,4),%rax
  681410:	48 89 f2             	mov    %rsi,%rdx
  681413:	5b                   	pop    %rbx
  681414:	c3                   	ret
