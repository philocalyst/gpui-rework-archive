
/tmp/gpui-text-map-query-final/8fused/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

0000000000680760 <<gpui_canvas::text::layout::CaretBuilder>::freeze>:
  680760:	41 57                	push   %r15
  680762:	41 56                	push   %r14
  680764:	41 55                	push   %r13
  680766:	41 54                	push   %r12
  680768:	53                   	push   %rbx
  680769:	49 89 ff             	mov    %rdi,%r15
  68076c:	4c 8b 76 08          	mov    0x8(%rsi),%r14
  680770:	48 8b 5e 10          	mov    0x10(%rsi),%rbx
  680774:	4c 8b 6e 18          	mov    0x18(%rsi),%r13
  680778:	83 3e 01             	cmpl   $0x1,(%rsi)
  68077b:	75 4c                	jne    6807c9 <<gpui_canvas::text::layout::CaretBuilder>::freeze+0x69>
  68077d:	41 bc 01 00 00 00    	mov    $0x1,%r12d
  680783:	4d 39 ee             	cmp    %r13,%r14
  680786:	0f 86 92 00 00 00    	jbe    68081e <<gpui_canvas::text::layout::CaretBuilder>::freeze+0xbe>
  68078c:	49 c1 e6 02          	shl    $0x2,%r14
  680790:	4f 8d 34 76          	lea    (%r14,%r14,2),%r14
  680794:	4d 85 ed             	test   %r13,%r13
  680797:	74 6f                	je     680808 <<gpui_canvas::text::layout::CaretBuilder>::freeze+0xa8>
  680799:	4a 8d 04 ad 00 00 00 	lea    0x0(,%r13,4),%rax
  6807a0:	00 
  6807a1:	4c 8d 24 40          	lea    (%rax,%rax,2),%r12
  6807a5:	ba 04 00 00 00       	mov    $0x4,%edx
  6807aa:	48 89 df             	mov    %rbx,%rdi
  6807ad:	4c 89 f6             	mov    %r14,%rsi
  6807b0:	4c 89 e1             	mov    %r12,%rcx
  6807b3:	ff 15 e7 90 10 00    	call   *0x1090e7(%rip)        # 7898a0 <_DYNAMIC+0x378>
  6807b9:	48 85 c0             	test   %rax,%rax
  6807bc:	74 78                	je     680836 <<gpui_canvas::text::layout::CaretBuilder>::freeze+0xd6>
  6807be:	41 bc 01 00 00 00    	mov    $0x1,%r12d
  6807c4:	48 89 c3             	mov    %rax,%rbx
  6807c7:	eb 55                	jmp    68081e <<gpui_canvas::text::layout::CaretBuilder>::freeze+0xbe>
  6807c9:	4d 39 ee             	cmp    %r13,%r14
  6807cc:	76 32                	jbe    680800 <<gpui_canvas::text::layout::CaretBuilder>::freeze+0xa0>
  6807ce:	49 c1 e6 03          	shl    $0x3,%r14
  6807d2:	4d 85 ed             	test   %r13,%r13
  6807d5:	74 2e                	je     680805 <<gpui_canvas::text::layout::CaretBuilder>::freeze+0xa5>
  6807d7:	4e 8d 24 ed 00 00 00 	lea    0x0(,%r13,8),%r12
  6807de:	00 
  6807df:	ba 04 00 00 00       	mov    $0x4,%edx
  6807e4:	48 89 df             	mov    %rbx,%rdi
  6807e7:	4c 89 f6             	mov    %r14,%rsi
  6807ea:	4c 89 e1             	mov    %r12,%rcx
  6807ed:	ff 15 ad 90 10 00    	call   *0x1090ad(%rip)        # 7898a0 <_DYNAMIC+0x378>
  6807f3:	48 85 c0             	test   %rax,%rax
  6807f6:	74 4e                	je     680846 <<gpui_canvas::text::layout::CaretBuilder>::freeze+0xe6>
  6807f8:	45 31 e4             	xor    %r12d,%r12d
  6807fb:	48 89 c3             	mov    %rax,%rbx
  6807fe:	eb 1e                	jmp    68081e <<gpui_canvas::text::layout::CaretBuilder>::freeze+0xbe>
  680800:	45 31 e4             	xor    %r12d,%r12d
  680803:	eb 19                	jmp    68081e <<gpui_canvas::text::layout::CaretBuilder>::freeze+0xbe>
  680805:	45 31 e4             	xor    %r12d,%r12d
  680808:	ba 04 00 00 00       	mov    $0x4,%edx
  68080d:	48 89 df             	mov    %rbx,%rdi
  680810:	4c 89 f6             	mov    %r14,%rsi
  680813:	ff 15 57 8f 10 00    	call   *0x108f57(%rip)        # 789770 <_DYNAMIC+0x248>
  680819:	bb 04 00 00 00       	mov    $0x4,%ebx
  68081e:	49 89 5f 08          	mov    %rbx,0x8(%r15)
  680822:	4d 89 6f 10          	mov    %r13,0x10(%r15)
  680826:	4d 89 27             	mov    %r12,(%r15)
  680829:	4c 89 f8             	mov    %r15,%rax
  68082c:	5b                   	pop    %rbx
  68082d:	41 5c                	pop    %r12
  68082f:	41 5d                	pop    %r13
  680831:	41 5e                	pop    %r14
  680833:	41 5f                	pop    %r15
  680835:	c3                   	ret
  680836:	bf 04 00 00 00       	mov    $0x4,%edi
  68083b:	4c 89 e6             	mov    %r12,%rsi
  68083e:	ff 15 54 90 10 00    	call   *0x109054(%rip)        # 789898 <_DYNAMIC+0x370>
  680844:	eb 0e                	jmp    680854 <<gpui_canvas::text::layout::CaretBuilder>::freeze+0xf4>
  680846:	bf 04 00 00 00       	mov    $0x4,%edi
  68084b:	4c 89 e6             	mov    %r12,%rsi
  68084e:	ff 15 44 90 10 00    	call   *0x109044(%rip)        # 789898 <_DYNAMIC+0x370>
  680854:	0f 0b                	ud2
  680856:	eb 00                	jmp    680858 <<gpui_canvas::text::layout::CaretBuilder>::freeze+0xf8>
  680858:	49 89 c7             	mov    %rax,%r15
  68085b:	ba 04 00 00 00       	mov    $0x4,%edx
  680860:	48 89 df             	mov    %rbx,%rdi
  680863:	4c 89 f6             	mov    %r14,%rsi
  680866:	ff 15 04 8f 10 00    	call   *0x108f04(%rip)        # 789770 <_DYNAMIC+0x248>
  68086c:	4c 89 ff             	mov    %r15,%rdi
  68086f:	e8 9c cf 0f 00       	call   77d810 <_Unwind_Resume@plt>
