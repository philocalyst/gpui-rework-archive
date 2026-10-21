
/tmp/gpui-validated-lookup-apps-47b10baaa49b35f2e0adf9713c95b13d4bbe776de05550eb007192163d59af6f:     file format elf64-x86-64


Disassembly of section .text:

0000000000526520 <_RINvMsp_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB6_3WinNtNtB6_12style_ledger9AdversaryE12set_propertyNtNtCs7XZEQI6Z5Ts_11gpui_canvas5color5ColorEB8_>:
  526520:	55                   	push   %rbp
  526521:	41 57                	push   %r15
  526523:	41 56                	push   %r14
  526525:	41 55                	push   %r13
  526527:	41 54                	push   %r12
  526529:	53                   	push   %rbx
  52652a:	48 81 ec c8 01 00 00 	sub    $0x1c8,%rsp
  526531:	48 89 fb             	mov    %rdi,%rbx
  526534:	4c 8b 36             	mov    (%rsi),%r14
  526537:	4d 85 f6             	test   %r14,%r14
  52653a:	74 16                	je     526552 <_RINvMsp_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB6_3WinNtNtB6_12style_ledger9AdversaryE12set_propertyNtNtCs7XZEQI6Z5Ts_11gpui_canvas5color5ColorEB8_+0x32>
  52653c:	41 80 be 5e 09 00 00 	cmpb   $0x0,0x95e(%r14)
  526543:	00 
  526544:	74 20                	je     526566 <_RINvMsp_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB6_3WinNtNtB6_12style_ledger9AdversaryE12set_propertyNtNtCs7XZEQI6Z5Ts_11gpui_canvas5color5ColorEB8_+0x46>
  526546:	48 c7 03 0e 00 00 00 	movq   $0xe,(%rbx)
  52654d:	e9 97 04 00 00       	jmp    5269e9 <_RINvMsp_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB6_3WinNtNtB6_12style_ledger9AdversaryE12set_propertyNtNtCs7XZEQI6Z5Ts_11gpui_canvas5color5ColorEB8_+0x4c9>
  526552:	48 c7 03 0d 00 00 00 	movq   $0xd,(%rbx)
  526559:	48 c7 43 08 00 00 00 	movq   $0x0,0x8(%rbx)
  526560:	00 
  526561:	e9 83 04 00 00       	jmp    5269e9 <_RINvMsp_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB6_3WinNtNtB6_12style_ledger9AdversaryE12set_propertyNtNtCs7XZEQI6Z5Ts_11gpui_canvas5color5ColorEB8_+0x4c9>
  526566:	4d 89 cc             	mov    %r9,%r12
  526569:	4d 89 c7             	mov    %r8,%r15
  52656c:	48 89 74 24 78       	mov    %rsi,0x78(%rsp)
  526571:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  526576:	4c 89 f6             	mov    %r14,%rsi
  526579:	e8 12 a5 08 00       	call   5b0a90 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE6locateB7_>
  52657e:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  526583:	48 8b 54 24 18       	mov    0x18(%rsp),%rdx
  526588:	48 8b 6c 24 20       	mov    0x20(%rsp),%rbp
  52658d:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  526591:	75 4c                	jne    5265df <_RINvMsp_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB6_3WinNtNtB6_12style_ledger9AdversaryE12set_propertyNtNtCs7XZEQI6Z5Ts_11gpui_canvas5color5ColorEB8_+0xbf>
  526593:	4d 8b ae 60 08 00 00 	mov    0x860(%r14),%r13
  52659a:	49 ff c5             	inc    %r13
  52659d:	0f 84 7f 04 00 00    	je     526a22 <_RINvMsp_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB6_3WinNtNtB6_12style_ledger9AdversaryE12set_propertyNtNtCs7XZEQI6Z5Ts_11gpui_canvas5color5ColorEB8_+0x502>
  5265a3:	49 8b 8e 28 02 00 00 	mov    0x228(%r14),%rcx
  5265aa:	48 85 c9             	test   %rcx,%rcx
  5265ad:	4d 89 f8             	mov    %r15,%r8
  5265b0:	4c 89 e0             	mov    %r12,%rax
  5265b3:	74 4c                	je     526601 <_RINvMsp_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB6_3WinNtNtB6_12style_ledger9AdversaryE12set_propertyNtNtCs7XZEQI6Z5Ts_11gpui_canvas5color5ColorEB8_+0xe1>
  5265b5:	83 f9 01             	cmp    $0x1,%ecx
  5265b8:	75 50                	jne    52660a <_RINvMsp_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB6_3WinNtNtB6_12style_ledger9AdversaryE12set_propertyNtNtCs7XZEQI6Z5Ts_11gpui_canvas5color5ColorEB8_+0xea>
  5265ba:	49 8b b6 40 02 00 00 	mov    0x240(%r14),%rsi
  5265c1:	41 b9 38 02 00 00    	mov    $0x238,%r9d
  5265c7:	48 89 ef             	mov    %rbp,%rdi
  5265ca:	48 39 f5             	cmp    %rsi,%rbp
  5265cd:	72 6c                	jb     52663b <_RINvMsp_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB6_3WinNtNtB6_12style_ledger9AdversaryE12set_propertyNtNtCs7XZEQI6Z5Ts_11gpui_canvas5color5ColorEB8_+0x11b>
  5265cf:	48 8d 15 d2 26 59 00 	lea    0x5926d2(%rip),%rdx        # ab8ca8 <anon.2a25786c1a741fd89e690b6b2ddad436.63.llvm.18021777786862421399+0x70>
  5265d6:	48 89 ef             	mov    %rbp,%rdi
  5265d9:	ff 15 f9 39 5c 00    	call   *0x5c39f9(%rip)        # ae9fd8 <_DYNAMIC+0x278>
  5265df:	0f 10 44 24 28       	movups 0x28(%rsp),%xmm0
  5265e4:	0f 10 4c 24 38       	movups 0x38(%rsp),%xmm1
  5265e9:	0f 11 4b 28          	movups %xmm1,0x28(%rbx)
  5265ed:	0f 11 43 18          	movups %xmm0,0x18(%rbx)
  5265f1:	48 89 03             	mov    %rax,(%rbx)
  5265f4:	48 89 53 08          	mov    %rdx,0x8(%rbx)
  5265f8:	48 89 6b 10          	mov    %rbp,0x10(%rbx)
  5265fc:	e9 e8 03 00 00       	jmp    5269e9 <_RINvMsp_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB6_3WinNtNtB6_12style_ledger9AdversaryE12set_propertyNtNtCs7XZEQI6Z5Ts_11gpui_canvas5color5ColorEB8_+0x4c9>
  526601:	48 8d 0d 30 54 b5 ff 	lea    -0x4aabd0(%rip),%rcx        # 7ba38 <anon.5f884de6e78125e25881320d811d32df.113.llvm.17146438997930651657+0x8>
  526608:	eb 39                	jmp    526643 <_RINvMsp_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB6_3WinNtNtB6_12style_ledger9AdversaryE12set_propertyNtNtCs7XZEQI6Z5Ts_11gpui_canvas5color5ColorEB8_+0x123>
  52660a:	49 8b b6 48 02 00 00 	mov    0x248(%r14),%rsi
  526611:	48 39 f5             	cmp    %rsi,%rbp
  526614:	0f 83 11 04 00 00    	jae    526a2b <_RINvMsp_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB6_3WinNtNtB6_12style_ledger9AdversaryE12set_propertyNtNtCs7XZEQI6Z5Ts_11gpui_canvas5color5ColorEB8_+0x50b>
  52661a:	49 8b b6 38 02 00 00 	mov    0x238(%r14),%rsi
  526621:	49 8b 8e 40 02 00 00 	mov    0x240(%r14),%rcx
  526628:	0f b6 3c 29          	movzbl (%rcx,%rbp,1),%edi
  52662c:	41 b9 30 02 00 00    	mov    $0x230,%r9d
  526632:	48 39 fe             	cmp    %rdi,%rsi
  526635:	0f 86 00 04 00 00    	jbe    526a3b <_RINvMsp_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB6_3WinNtNtB6_12style_ledger9AdversaryE12set_propertyNtNtCs7XZEQI6Z5Ts_11gpui_canvas5color5ColorEB8_+0x51b>
  52663b:	48 6b cf 58          	imul   $0x58,%rdi,%rcx
  52663f:	4b 03 0c 0e          	add    (%r14,%r9,1),%rcx
  526643:	48 8b 71 50          	mov    0x50(%rcx),%rsi
  526647:	48 89 b4 24 f0 00 00 	mov    %rsi,0xf0(%rsp)
  52664e:	00 
  52664f:	0f 10 41 40          	movups 0x40(%rcx),%xmm0
  526653:	0f 29 84 24 e0 00 00 	movaps %xmm0,0xe0(%rsp)
  52665a:	00 
  52665b:	0f 10 01             	movups (%rcx),%xmm0
  52665e:	0f 10 49 10          	movups 0x10(%rcx),%xmm1
  526662:	0f 10 51 20          	movups 0x20(%rcx),%xmm2
  526666:	0f 10 59 30          	movups 0x30(%rcx),%xmm3
  52666a:	0f 29 9c 24 d0 00 00 	movaps %xmm3,0xd0(%rsp)
  526671:	00 
  526672:	0f 29 94 24 c0 00 00 	movaps %xmm2,0xc0(%rsp)
  526679:	00 
  52667a:	0f 29 8c 24 b0 00 00 	movaps %xmm1,0xb0(%rsp)
  526681:	00 
  526682:	0f 29 84 24 a0 00 00 	movaps %xmm0,0xa0(%rsp)
  526689:	00 
  52668a:	49 8d b6 f8 07 00 00 	lea    0x7f8(%r14),%rsi
  526691:	8b 78 10             	mov    0x10(%rax),%edi
  526694:	89 bc 24 90 00 00 00 	mov    %edi,0x90(%rsp)
  52669b:	0f 10 00             	movups (%rax),%xmm0
  52669e:	0f 29 84 24 80 00 00 	movaps %xmm0,0x80(%rsp)
  5266a5:	00 
  5266a6:	48 8b 41 50          	mov    0x50(%rcx),%rax
  5266aa:	48 89 44 24 60       	mov    %rax,0x60(%rsp)
  5266af:	0f 10 41 40          	movups 0x40(%rcx),%xmm0
  5266b3:	0f 29 44 24 50       	movaps %xmm0,0x50(%rsp)
  5266b8:	0f 10 01             	movups (%rcx),%xmm0
  5266bb:	0f 10 49 10          	movups 0x10(%rcx),%xmm1
  5266bf:	0f 10 51 20          	movups 0x20(%rcx),%xmm2
  5266c3:	0f 10 59 30          	movups 0x30(%rcx),%xmm3
  5266c7:	0f 29 5c 24 40       	movaps %xmm3,0x40(%rsp)
  5266cc:	0f 29 54 24 30       	movaps %xmm2,0x30(%rsp)
  5266d1:	0f 29 4c 24 20       	movaps %xmm1,0x20(%rsp)
  5266d6:	0f 29 44 24 10       	movaps %xmm0,0x10(%rsp)
  5266db:	48 8d bc 24 58 01 00 	lea    0x158(%rsp),%rdi
  5266e2:	00 
  5266e3:	48 8d 4c 24 10       	lea    0x10(%rsp),%rcx
  5266e8:	4c 8d 8c 24 80 00 00 	lea    0x80(%rsp),%r9
  5266ef:	00 
  5266f0:	48 89 14 24          	mov    %rdx,(%rsp)
  5266f4:	e8 77 be 1e 00       	call   712570 <_RINvMs5_NtCs6gaF1xUz9Bf_4gpui8propertyNtB6_9Overrides3setNtNtCs7XZEQI6Z5Ts_11gpui_canvas5color5ColorEB8_>
  5266f9:	44 8b bc 24 58 01 00 	mov    0x158(%rsp),%r15d
  526700:	00 
  526701:	44 8b a4 24 5c 01 00 	mov    0x15c(%rsp),%r12d
  526708:	00 
  526709:	41 83 ff 02          	cmp    $0x2,%r15d
  52670d:	75 10                	jne    52671f <_RINvMsp_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB6_3WinNtNtB6_12style_ledger9AdversaryE12set_propertyNtNtCs7XZEQI6Z5Ts_11gpui_canvas5color5ColorEB8_+0x1ff>
  52670f:	48 c7 03 23 00 00 00 	movq   $0x23,(%rbx)
  526716:	44 89 63 08          	mov    %r12d,0x8(%rbx)
  52671a:	e9 ca 02 00 00       	jmp    5269e9 <_RINvMsp_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB6_3WinNtNtB6_12style_ledger9AdversaryE12set_propertyNtNtCs7XZEQI6Z5Ts_11gpui_canvas5color5ColorEB8_+0x4c9>
  52671f:	48 89 6c 24 70       	mov    %rbp,0x70(%rsp)
  526724:	0f 10 84 24 a0 01 00 	movups 0x1a0(%rsp),%xmm0
  52672b:	00 
  52672c:	0f 11 84 24 48 01 00 	movups %xmm0,0x148(%rsp)
  526733:	00 
  526734:	0f 10 84 24 60 01 00 	movups 0x160(%rsp),%xmm0
  52673b:	00 
  52673c:	0f 10 8c 24 70 01 00 	movups 0x170(%rsp),%xmm1
  526743:	00 
  526744:	0f 10 94 24 80 01 00 	movups 0x180(%rsp),%xmm2
  52674b:	00 
  52674c:	0f 10 9c 24 90 01 00 	movups 0x190(%rsp),%xmm3
  526753:	00 
  526754:	0f 11 9c 24 38 01 00 	movups %xmm3,0x138(%rsp)
  52675b:	00 
  52675c:	0f 11 94 24 28 01 00 	movups %xmm2,0x128(%rsp)
  526763:	00 
  526764:	0f 11 8c 24 18 01 00 	movups %xmm1,0x118(%rsp)
  52676b:	00 
  52676c:	0f 11 84 24 08 01 00 	movups %xmm0,0x108(%rsp)
  526773:	00 
  526774:	44 89 bc 24 00 01 00 	mov    %r15d,0x100(%rsp)
  52677b:	00 
  52677c:	44 89 a4 24 04 01 00 	mov    %r12d,0x104(%rsp)
  526783:	00 
  526784:	4d 89 ae 60 08 00 00 	mov    %r13,0x860(%r14)
  52678b:	49 ff 86 f0 08 00 00 	incq   0x8f0(%r14)
  526792:	48 8d ac 24 a0 00 00 	lea    0xa0(%rsp),%rbp
  526799:	00 
  52679a:	4c 8d ac 24 00 01 00 	lea    0x100(%rsp),%r13
  5267a1:	00 
  5267a2:	48 89 ef             	mov    %rbp,%rdi
  5267a5:	4c 89 ee             	mov    %r13,%rsi
  5267a8:	e8 13 7f 13 00       	call   65e6c0 <_RNvXse_NtCs6gaF1xUz9Bf_4gpui5styleNtB5_5StyleNtNtCs4NRVxsYgnAr_4core3cmp9PartialEq2eq>
  5267ad:	34 01                	xor    $0x1,%al
  5267af:	0f b6 c0             	movzbl %al,%eax
  5267b2:	49 89 86 48 09 00 00 	mov    %rax,0x948(%r14)
  5267b9:	48 89 ef             	mov    %rbp,%rdi
  5267bc:	4c 89 ee             	mov    %r13,%rsi
  5267bf:	e8 fc 7e 13 00       	call   65e6c0 <_RNvXse_NtCs6gaF1xUz9Bf_4gpui5styleNtB5_5StyleNtNtCs4NRVxsYgnAr_4core3cmp9PartialEq2eq>
  5267c4:	84 c0                	test   %al,%al
  5267c6:	0f 85 b0 01 00 00    	jne    52697c <_RINvMsp_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB6_3WinNtNtB6_12style_ledger9AdversaryE12set_propertyNtNtCs7XZEQI6Z5Ts_11gpui_canvas5color5ColorEB8_+0x45c>
  5267cc:	44 8b 8c 24 a8 00 00 	mov    0xa8(%rsp),%r9d
  5267d3:	00 
  5267d4:	0f b6 8c 24 f4 00 00 	movzbl 0xf4(%rsp),%ecx
  5267db:	00 
  5267dc:	8b 84 24 08 01 00 00 	mov    0x108(%rsp),%eax
  5267e3:	0f 10 a4 24 ac 00 00 	movups 0xac(%rsp),%xmm4
  5267ea:	00 
  5267eb:	f3 0f 10 84 24 b0 00 	movss  0xb0(%rsp),%xmm0
  5267f2:	00 00 
  5267f4:	0f 10 ac 24 0c 01 00 	movups 0x10c(%rsp),%xmm5
  5267fb:	00 
  5267fc:	f3 0f 10 8c 24 10 01 	movss  0x110(%rsp),%xmm1
  526803:	00 00 
  526805:	0f b6 94 24 54 01 00 	movzbl 0x154(%rsp),%edx
  52680c:	00 
  52680d:	83 bc 24 a0 00 00 00 	cmpl   $0x1,0xa0(%rsp)
  526814:	01 
  526815:	4c 8b 6c 24 70       	mov    0x70(%rsp),%r13
  52681a:	75 27                	jne    526843 <_RINvMsp_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB6_3WinNtNtB6_12style_ledger9AdversaryE12set_propertyNtNtCs7XZEQI6Z5Ts_11gpui_canvas5color5ColorEB8_+0x323>
  52681c:	66 41 0f 6e d4       	movd   %r12d,%xmm2
  526821:	f3 0f 10 9c 24 a4 00 	movss  0xa4(%rsp),%xmm3
  526828:	00 00 
  52682a:	0f 2e da             	ucomiss %xmm2,%xmm3
  52682d:	40 0f 9b c7          	setnp  %dil
  526831:	41 0f 94 c0          	sete   %r8b
  526835:	41 20 f8             	and    %dil,%r8b
  526838:	45 84 c7             	test   %r8b,%r15b
  52683b:	48 8b 34 24          	mov    (%rsp),%rsi
  52683f:	75 0c                	jne    52684d <_RINvMsp_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB6_3WinNtNtB6_12style_ledger9AdversaryE12set_propertyNtNtCs7XZEQI6Z5Ts_11gpui_canvas5color5ColorEB8_+0x32d>
  526841:	eb 66                	jmp    5268a9 <_RINvMsp_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB6_3WinNtNtB6_12style_ledger9AdversaryE12set_propertyNtNtCs7XZEQI6Z5Ts_11gpui_canvas5color5ColorEB8_+0x389>
  526843:	41 f6 c7 01          	test   $0x1,%r15b
  526847:	48 8b 34 24          	mov    (%rsp),%rsi
  52684b:	75 5c                	jne    5268a9 <_RINvMsp_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB6_3WinNtNtB6_12style_ledger9AdversaryE12set_propertyNtNtCs7XZEQI6Z5Ts_11gpui_canvas5color5ColorEB8_+0x389>
  52684d:	41 83 f9 01          	cmp    $0x1,%r9d
  526851:	75 1d                	jne    526870 <_RINvMsp_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB6_3WinNtNtB6_12style_ledger9AdversaryE12set_propertyNtNtCs7XZEQI6Z5Ts_11gpui_canvas5color5ColorEB8_+0x350>
  526853:	38 d1                	cmp    %dl,%cl
  526855:	0f 94 c1             	sete   %cl
  526858:	0f 28 c4             	movaps %xmm4,%xmm0
  52685b:	0f c2 c5 00          	cmpeqps %xmm5,%xmm0
  52685f:	0f 50 d0             	movmskps %xmm0,%edx
  526862:	83 fa 0f             	cmp    $0xf,%edx
  526865:	0f 94 c2             	sete   %dl
  526868:	20 c2                	and    %al,%dl
  52686a:	84 ca                	test   %cl,%dl
  52686c:	74 3b                	je     5268a9 <_RINvMsp_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB6_3WinNtNtB6_12style_ledger9AdversaryE12set_propertyNtNtCs7XZEQI6Z5Ts_11gpui_canvas5color5ColorEB8_+0x389>
  52686e:	eb 5d                	jmp    5268cd <_RINvMsp_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB6_3WinNtNtB6_12style_ledger9AdversaryE12set_propertyNtNtCs7XZEQI6Z5Ts_11gpui_canvas5color5ColorEB8_+0x3ad>
  526870:	0f 2e c1             	ucomiss %xmm1,%xmm0
  526873:	41 0f 9b c0          	setnp  %r8b
  526877:	40 0f 94 c7          	sete   %dil
  52687b:	44 20 c7             	and    %r8b,%dil
  52687e:	f6 d0                	not    %al
  526880:	40 20 f8             	and    %dil,%al
  526883:	0f 28 c4             	movaps %xmm4,%xmm0
  526886:	0f c2 c5 00          	cmpeqps %xmm5,%xmm0
  52688a:	44 0f 50 c0          	movmskps %xmm0,%r8d
  52688e:	44 89 c7             	mov    %r8d,%edi
  526891:	40 c0 ef 03          	shr    $0x3,%dil
  526895:	41 c0 e8 02          	shr    $0x2,%r8b
  526899:	41 20 c0             	and    %al,%r8b
  52689c:	41 20 f8             	and    %dil,%r8b
  52689f:	38 d1                	cmp    %dl,%cl
  5268a1:	0f 94 c0             	sete   %al
  5268a4:	41 84 c0             	test   %al,%r8b
  5268a7:	75 24                	jne    5268cd <_RINvMsp_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB6_3WinNtNtB6_12style_ledger9AdversaryE12set_propertyNtNtCs7XZEQI6Z5Ts_11gpui_canvas5color5ColorEB8_+0x3ad>
  5268a9:	49 8d be 48 08 00 00 	lea    0x848(%r14),%rdi
  5268b0:	0f 29 24 24          	movaps %xmm4,(%rsp)
  5268b4:	0f 29 ac 24 b0 01 00 	movaps %xmm5,0x1b0(%rsp)
  5268bb:	00 
  5268bc:	e8 5f 24 20 00       	call   728d20 <_RNvMsi_NtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB5_8BTreeMapyNtNtB7_7set_val9SetValZSTE6insertCs6gaF1xUz9Bf_4gpui>
  5268c1:	0f 28 ac 24 b0 01 00 	movaps 0x1b0(%rsp),%xmm5
  5268c8:	00 
  5268c9:	0f 28 24 24          	movaps (%rsp),%xmm4
  5268cd:	0f c2 e5 04          	cmpneqps %xmm5,%xmm4
  5268d1:	66 0f c5 c4 06       	pextrw $0x6,%xmm4,%eax
  5268d6:	a8 01                	test   $0x1,%al
  5268d8:	74 7c                	je     526956 <_RINvMsp_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB6_3WinNtNtB6_12style_ledger9AdversaryE12set_propertyNtNtCs7XZEQI6Z5Ts_11gpui_canvas5color5ColorEB8_+0x436>
  5268da:	49 8b b6 c8 02 00 00 	mov    0x2c8(%r14),%rsi
  5268e1:	49 39 f5             	cmp    %rsi,%r13
  5268e4:	0f 83 5e 01 00 00    	jae    526a48 <_RINvMsp_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB6_3WinNtNtB6_12style_ledger9AdversaryE12set_propertyNtNtCs7XZEQI6Z5Ts_11gpui_canvas5color5ColorEB8_+0x528>
  5268ea:	49 8b 86 c0 02 00 00 	mov    0x2c0(%r14),%rax
  5268f1:	4a 8d 0c ad 00 00 00 	lea    0x0(,%r13,4),%rcx
  5268f8:	00 
  5268f9:	4c 01 e9             	add    %r13,%rcx
  5268fc:	8b 44 c8 20          	mov    0x20(%rax,%rcx,8),%eax
  526900:	89 c1                	mov    %eax,%ecx
  526902:	83 e1 07             	and    $0x7,%ecx
  526905:	83 f9 06             	cmp    $0x6,%ecx
  526908:	0f 83 f0 00 00 00    	jae    5269fe <_RINvMsp_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB6_3WinNtNtB6_12style_ledger9AdversaryE12set_propertyNtNtCs7XZEQI6Z5Ts_11gpui_canvas5color5ColorEB8_+0x4de>
  52690e:	c1 e8 03             	shr    $0x3,%eax
  526911:	ff c8                	dec    %eax
  526913:	89 84 24 58 01 00 00 	mov    %eax,0x158(%rsp)
  52691a:	41 0f 10 86 d8 02 00 	movups 0x2d8(%r14),%xmm0
  526921:	00 
  526922:	0f 11 44 24 10       	movups %xmm0,0x10(%rsp)
  526927:	48 8d 8c 24 58 01 00 	lea    0x158(%rsp),%rcx
  52692e:	00 
  52692f:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  526934:	83 f8 ff             	cmp    $0xffffffff,%eax
  526937:	74 1d                	je     526956 <_RINvMsp_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB6_3WinNtNtB6_12style_ledger9AdversaryE12set_propertyNtNtCs7XZEQI6Z5Ts_11gpui_canvas5color5ColorEB8_+0x436>
  526939:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  52693e:	e8 cd 6c 01 00       	call   53d610 <_RNCNvMsf_NtCs6gaF1xUz9Bf_4gpui7runtimeNtB7_8TextSlot7get_mut0B9_>
  526943:	49 89 c4             	mov    %rax,%r12
  526946:	48 89 c7             	mov    %rax,%rdi
  526949:	e8 52 2d 00 00       	call   5296a0 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtB4_6option6OptionNtNtCs6gaF1xUz9Bf_4gpui7runtime6ShapedEEB11_.llvm.18021777786862421399>
  52694e:	49 c7 04 24 ff ff ff 	movq   $0xffffffffffffffff,(%r12)
  526955:	ff 
  526956:	49 8d be 28 02 00 00 	lea    0x228(%r14),%rdi
  52695d:	49 8b 8e c8 02 00 00 	mov    0x2c8(%r14),%rcx
  526964:	48 8d 94 24 00 01 00 	lea    0x100(%rsp),%rdx
  52696b:	00 
  52696c:	4c 89 ee             	mov    %r13,%rsi
  52696f:	e8 0c 19 25 00       	call   778280 <_RNvMNtNtCs6gaF1xUz9Bf_4gpui7runtime6stylesNtB2_6Styles3set>
  526974:	41 c6 86 5b 09 00 00 	movb   $0x1,0x95b(%r14)
  52697b:	01 
  52697c:	49 83 be 28 08 00 00 	cmpq   $0x0,0x828(%r14)
  526983:	00 
  526984:	48 8b 54 24 78       	mov    0x78(%rsp),%rdx
  526989:	74 2e                	je     5269b9 <_RINvMsp_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB6_3WinNtNtB6_12style_ledger9AdversaryE12set_propertyNtNtCs7XZEQI6Z5Ts_11gpui_canvas5color5ColorEB8_+0x499>
  52698b:	48 83 c2 08          	add    $0x8,%rdx
  52698f:	48 c7 84 24 58 01 00 	movq   $0xffffffffffffffff,0x158(%rsp)
  526996:	00 ff ff ff ff 
  52699b:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  5269a0:	4c 8d 84 24 58 01 00 	lea    0x158(%rsp),%r8
  5269a7:	00 
  5269a8:	4c 89 f6             	mov    %r14,%rsi
  5269ab:	31 c9                	xor    %ecx,%ecx
  5269ad:	e8 6e 97 01 00       	call   540120 <_RNvMNtNtCs6gaF1xUz9Bf_4gpui7runtime4turnINtB4_10RuntimeMutNtNtB4_12style_ledger9AdversaryuE13describe_withB6_.llvm.18021777786862421399>
  5269b2:	83 7c 24 10 fe       	cmpl   $0xfffffffe,0x10(%rsp)
  5269b7:	75 0d                	jne    5269c6 <_RINvMsp_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB6_3WinNtNtB6_12style_ledger9AdversaryE12set_propertyNtNtCs7XZEQI6Z5Ts_11gpui_canvas5color5ColorEB8_+0x4a6>
  5269b9:	48 89 df             	mov    %rbx,%rdi
  5269bc:	4c 89 f6             	mov    %r14,%rsi
  5269bf:	e8 6c a2 08 00       	call   5b0c30 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18021777786862421399>
  5269c4:	eb 23                	jmp    5269e9 <_RINvMsp_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB6_3WinNtNtB6_12style_ledger9AdversaryE12set_propertyNtNtCs7XZEQI6Z5Ts_11gpui_canvas5color5ColorEB8_+0x4c9>
  5269c6:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
  5269cb:	48 89 43 30          	mov    %rax,0x30(%rbx)
  5269cf:	0f 10 44 24 10       	movups 0x10(%rsp),%xmm0
  5269d4:	0f 10 4c 24 20       	movups 0x20(%rsp),%xmm1
  5269d9:	0f 10 54 24 30       	movups 0x30(%rsp),%xmm2
  5269de:	0f 11 53 20          	movups %xmm2,0x20(%rbx)
  5269e2:	0f 11 4b 10          	movups %xmm1,0x10(%rbx)
  5269e6:	0f 11 03             	movups %xmm0,(%rbx)
  5269e9:	48 89 d8             	mov    %rbx,%rax
  5269ec:	48 81 c4 c8 01 00 00 	add    $0x1c8,%rsp
  5269f3:	5b                   	pop    %rbx
  5269f4:	41 5c                	pop    %r12
  5269f6:	41 5d                	pop    %r13
  5269f8:	41 5e                	pop    %r14
  5269fa:	41 5f                	pop    %r15
  5269fc:	5d                   	pop    %rbp
  5269fd:	c3                   	ret
  5269fe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  526a03:	0f 84 0a ff ff ff    	je     526913 <_RINvMsp_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB6_3WinNtNtB6_12style_ledger9AdversaryE12set_propertyNtNtCs7XZEQI6Z5Ts_11gpui_canvas5color5ColorEB8_+0x3f3>
  526a09:	48 8d 3d a8 50 b5 ff 	lea    -0x4aaf58(%rip),%rdi        # 7bab8 <anon.5f884de6e78125e25881320d811d32df.113.llvm.17146438997930651657+0x88>
  526a10:	48 8d 15 51 23 59 00 	lea    0x592351(%rip),%rdx        # ab8d68 <anon.2a25786c1a741fd89e690b6b2ddad436.63.llvm.18021777786862421399+0x130>
  526a17:	be a1 00 00 00       	mov    $0xa1,%esi
  526a1c:	ff 15 be 35 5c 00    	call   *0x5c35be(%rip)        # ae9fe0 <_DYNAMIC+0x280>
  526a22:	48 c7 03 1e 00 00 00 	movq   $0x1e,(%rbx)
  526a29:	eb be                	jmp    5269e9 <_RINvMsp_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB6_3WinNtNtB6_12style_ledger9AdversaryE12set_propertyNtNtCs7XZEQI6Z5Ts_11gpui_canvas5color5ColorEB8_+0x4c9>
  526a2b:	48 8d 15 8e 22 59 00 	lea    0x59228e(%rip),%rdx        # ab8cc0 <anon.2a25786c1a741fd89e690b6b2ddad436.63.llvm.18021777786862421399+0x88>
  526a32:	48 89 ef             	mov    %rbp,%rdi
  526a35:	ff 15 9d 35 5c 00    	call   *0x5c359d(%rip)        # ae9fd8 <_DYNAMIC+0x278>
  526a3b:	48 8d 15 96 22 59 00 	lea    0x592296(%rip),%rdx        # ab8cd8 <anon.2a25786c1a741fd89e690b6b2ddad436.63.llvm.18021777786862421399+0xa0>
  526a42:	ff 15 90 35 5c 00    	call   *0x5c3590(%rip)        # ae9fd8 <_DYNAMIC+0x278>
  526a48:	48 8d 15 39 1d 59 00 	lea    0x591d39(%rip),%rdx        # ab8788 <__frame_dummy_init_array_entry+0x38>
  526a4f:	4c 89 ef             	mov    %r13,%rdi
  526a52:	ff 15 80 35 5c 00    	call   *0x5c3580(%rip)        # ae9fd8 <_DYNAMIC+0x278>
  526a58:	49 c7 04 24 ff ff ff 	movq   $0xffffffffffffffff,(%r12)
  526a5f:	ff 
  526a60:	48 89 c7             	mov    %rax,%rdi
  526a63:	e8 48 0a 59 00       	call   ab74b0 <_Unwind_Resume@plt>
