
/tmp/gpui-text-map-query-controls/12trim/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

0000000000662340 <<gpui_canvas::text::layout::TextGeometry>::caret_line>:
  662340:	55                   	push   %rbp
  662341:	41 56                	push   %r14
  662343:	53                   	push   %rbx
  662344:	48 83 ec 20          	sub    $0x20,%rsp
  662348:	48 83 7f 30 ff       	cmpq   $0xffffffffffffffff,0x30(%rdi)
  66234d:	0f 84 18 01 00 00    	je     66246b <<gpui_canvas::text::layout::TextGeometry>::caret_line+0x12b>
  662353:	48 8b 4f 38          	mov    0x38(%rdi),%rcx
  662357:	48 8b 47 40          	mov    0x40(%rdi),%rax
  66235b:	49 89 c0             	mov    %rax,%r8
  66235e:	48 85 c0             	test   %rax,%rax
  662361:	74 37                	je     66239a <<gpui_canvas::text::layout::TextGeometry>::caret_line+0x5a>
  662363:	45 31 c0             	xor    %r8d,%r8d
  662366:	48 83 f8 01          	cmp    $0x1,%rax
  66236a:	74 22                	je     66238e <<gpui_canvas::text::layout::TextGeometry>::caret_line+0x4e>
  66236c:	49 89 c1             	mov    %rax,%r9
  66236f:	90                   	nop
  662370:	4d 89 ca             	mov    %r9,%r10
  662373:	49 d1 ea             	shr    $1,%r10
  662376:	4f 8d 1c 02          	lea    (%r10,%r8,1),%r11
  66237a:	4b 8d 1c 5b          	lea    (%r11,%r11,2),%rbx
  66237e:	39 34 99             	cmp    %esi,(%rcx,%rbx,4)
  662381:	4d 0f 42 c3          	cmovb  %r11,%r8
  662385:	4d 29 d1             	sub    %r10,%r9
  662388:	49 83 f9 01          	cmp    $0x1,%r9
  66238c:	77 e2                	ja     662370 <<gpui_canvas::text::layout::TextGeometry>::caret_line+0x30>
  66238e:	4f 8d 0c 40          	lea    (%r8,%r8,2),%r9
  662392:	42 39 34 89          	cmp    %esi,(%rcx,%r9,4)
  662396:	49 83 d0 00          	adc    $0x0,%r8
  66239a:	44 8d 4a 01          	lea    0x1(%rdx),%r9d
  66239e:	49 c1 e0 02          	shl    $0x2,%r8
  6623a2:	4f 8d 14 40          	lea    (%r8,%r8,2),%r10
  6623a6:	4c 01 d1             	add    %r10,%rcx
  6623a9:	48 83 c1 f4          	add    $0xfffffffffffffff4,%rcx
  6623ad:	48 c1 e0 02          	shl    $0x2,%rax
  6623b1:	4c 8d 04 40          	lea    (%rax,%rax,2),%r8
  6623b5:	4d 29 d0             	sub    %r10,%r8
  6623b8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  6623bf:	00 
  6623c0:	4d 85 c0             	test   %r8,%r8
  6623c3:	0f 84 a2 00 00 00    	je     66246b <<gpui_canvas::text::layout::TextGeometry>::caret_line+0x12b>
  6623c9:	39 71 0c             	cmp    %esi,0xc(%rcx)
  6623cc:	0f 85 99 00 00 00    	jne    66246b <<gpui_canvas::text::layout::TextGeometry>::caret_line+0x12b>
  6623d2:	48 8d 41 0c          	lea    0xc(%rcx),%rax
  6623d6:	49 83 c0 f4          	add    $0xfffffffffffffff4,%r8
  6623da:	44 84 49 14          	test   %r9b,0x14(%rcx)
  6623de:	48 89 c1             	mov    %rax,%rcx
  6623e1:	74 dd                	je     6623c0 <<gpui_canvas::text::layout::TextGeometry>::caret_line+0x80>
  6623e3:	48 8d 4c 24 10       	lea    0x10(%rsp),%rcx
  6623e8:	48 89 fb             	mov    %rdi,%rbx
  6623eb:	48 89 cf             	mov    %rcx,%rdi
  6623ee:	89 f5                	mov    %esi,%ebp
  6623f0:	48 89 de             	mov    %rbx,%rsi
  6623f3:	49 89 d6             	mov    %rdx,%r14
  6623f6:	48 89 c2             	mov    %rax,%rdx
  6623f9:	ff 15 49 52 12 00    	call   *0x125249(%rip)        # 787648 <_DYNAMIC+0x398>
  6623ff:	89 e9                	mov    %ebp,%ecx
  662401:	85 ed                	test   %ebp,%ebp
  662403:	0f 95 c0             	setne  %al
  662406:	41 f6 d6             	not    %r14b
  662409:	48 8b 73 20          	mov    0x20(%rbx),%rsi
  66240d:	48 8b 53 28          	mov    0x28(%rbx),%rdx
  662411:	41 84 c6             	test   %al,%r14b
  662414:	75 60                	jne    662476 <<gpui_canvas::text::layout::TextGeometry>::caret_line+0x136>
  662416:	b8 01 00 00 00       	mov    $0x1,%eax
  66241b:	48 85 d2             	test   %rdx,%rdx
  66241e:	74 4d                	je     66246d <<gpui_canvas::text::layout::TextGeometry>::caret_line+0x12d>
  662420:	31 ff                	xor    %edi,%edi
  662422:	48 83 fa 01          	cmp    $0x1,%rdx
  662426:	74 29                	je     662451 <<gpui_canvas::text::layout::TextGeometry>::caret_line+0x111>
  662428:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  66242f:	00 
  662430:	49 89 f8             	mov    %rdi,%r8
  662433:	49 89 d1             	mov    %rdx,%r9
  662436:	49 d1 e9             	shr    $1,%r9
  662439:	4c 01 cf             	add    %r9,%rdi
  66243c:	4c 8d 14 7f          	lea    (%rdi,%rdi,2),%r10
  662440:	42 39 0c d6          	cmp    %ecx,(%rsi,%r10,8)
  662444:	49 0f 47 f8          	cmova  %r8,%rdi
  662448:	4c 29 ca             	sub    %r9,%rdx
  66244b:	48 83 fa 01          	cmp    $0x1,%rdx
  66244f:	77 df                	ja     662430 <<gpui_canvas::text::layout::TextGeometry>::caret_line+0xf0>
  662451:	4c 8d 04 7f          	lea    (%rdi,%rdi,2),%r8
  662455:	31 d2                	xor    %edx,%edx
  662457:	42 39 0c c6          	cmp    %ecx,(%rsi,%r8,8)
  66245b:	0f 96 c2             	setbe  %dl
  66245e:	48 01 fa             	add    %rdi,%rdx
  662461:	48 83 fa 01          	cmp    $0x1,%rdx
  662465:	48 83 d2 ff          	adc    $0xffffffffffffffff,%rdx
  662469:	eb 02                	jmp    66246d <<gpui_canvas::text::layout::TextGeometry>::caret_line+0x12d>
  66246b:	31 c0                	xor    %eax,%eax
  66246d:	48 83 c4 20          	add    $0x20,%rsp
  662471:	5b                   	pop    %rbx
  662472:	41 5e                	pop    %r14
  662474:	5d                   	pop    %rbp
  662475:	c3                   	ret
  662476:	48 89 d0             	mov    %rdx,%rax
  662479:	48 85 d2             	test   %rdx,%rdx
  66247c:	74 3e                	je     6624bc <<gpui_canvas::text::layout::TextGeometry>::caret_line+0x17c>
  66247e:	31 c0                	xor    %eax,%eax
  662480:	48 83 fa 01          	cmp    $0x1,%rdx
  662484:	74 2a                	je     6624b0 <<gpui_canvas::text::layout::TextGeometry>::caret_line+0x170>
  662486:	48 89 d7             	mov    %rdx,%rdi
  662489:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  662490:	49 89 f8             	mov    %rdi,%r8
  662493:	49 d1 e8             	shr    $1,%r8
  662496:	4d 8d 0c 00          	lea    (%r8,%rax,1),%r9
  66249a:	4f 8d 14 49          	lea    (%r9,%r9,2),%r10
  66249e:	42 39 4c d6 04       	cmp    %ecx,0x4(%rsi,%r10,8)
  6624a3:	49 0f 42 c1          	cmovb  %r9,%rax
  6624a7:	4c 29 c7             	sub    %r8,%rdi
  6624aa:	48 83 ff 01          	cmp    $0x1,%rdi
  6624ae:	77 e0                	ja     662490 <<gpui_canvas::text::layout::TextGeometry>::caret_line+0x150>
  6624b0:	48 8d 3c 40          	lea    (%rax,%rax,2),%rdi
  6624b4:	39 4c fe 04          	cmp    %ecx,0x4(%rsi,%rdi,8)
  6624b8:	48 83 d0 00          	adc    $0x0,%rax
  6624bc:	48 ff ca             	dec    %rdx
  6624bf:	48 39 c2             	cmp    %rax,%rdx
  6624c2:	48 0f 43 d0          	cmovae %rax,%rdx
  6624c6:	b8 01 00 00 00       	mov    $0x1,%eax
  6624cb:	eb a0                	jmp    66246d <<gpui_canvas::text::layout::TextGeometry>::caret_line+0x12d>
