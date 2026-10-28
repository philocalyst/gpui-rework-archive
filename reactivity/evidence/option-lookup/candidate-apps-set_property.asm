
/tmp/gpui-option-lookup-apps-4ce6cc649f0e16dbafb29422b9fe83c03ae8c259be19afa59f8979a49f4cb322:     file format elf64-x86-64


Disassembly of section .text:

0000000000526580 <_RINvMsp_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB6_3WinNtNtB6_12style_ledger9AdversaryE12set_propertyNtNtCs7XZEQI6Z5Ts_11gpui_canvas5color5ColorEB8_>:
  526580:	55                   	push   %rbp
  526581:	41 57                	push   %r15
  526583:	41 56                	push   %r14
  526585:	41 55                	push   %r13
  526587:	41 54                	push   %r12
  526589:	53                   	push   %rbx
  52658a:	48 81 ec d8 01 00 00 	sub    $0x1d8,%rsp
  526591:	48 89 fb             	mov    %rdi,%rbx
  526594:	4c 8b 36             	mov    (%rsi),%r14
  526597:	4d 85 f6             	test   %r14,%r14
  52659a:	74 16                	je     5265b2 <_RINvMsp_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB6_3WinNtNtB6_12style_ledger9AdversaryE12set_propertyNtNtCs7XZEQI6Z5Ts_11gpui_canvas5color5ColorEB8_+0x32>
  52659c:	41 80 be 5e 09 00 00 	cmpb   $0x0,0x95e(%r14)
  5265a3:	00 
  5265a4:	74 20                	je     5265c6 <_RINvMsp_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB6_3WinNtNtB6_12style_ledger9AdversaryE12set_propertyNtNtCs7XZEQI6Z5Ts_11gpui_canvas5color5ColorEB8_+0x46>
  5265a6:	48 c7 03 0e 00 00 00 	movq   $0xe,(%rbx)
  5265ad:	e9 9c 04 00 00       	jmp    526a4e <_RINvMsp_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB6_3WinNtNtB6_12style_ledger9AdversaryE12set_propertyNtNtCs7XZEQI6Z5Ts_11gpui_canvas5color5ColorEB8_+0x4ce>
  5265b2:	48 c7 03 0d 00 00 00 	movq   $0xd,(%rbx)
  5265b9:	48 c7 43 08 00 00 00 	movq   $0x0,0x8(%rbx)
  5265c0:	00 
  5265c1:	e9 88 04 00 00       	jmp    526a4e <_RINvMsp_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB6_3WinNtNtB6_12style_ledger9AdversaryE12set_propertyNtNtCs7XZEQI6Z5Ts_11gpui_canvas5color5ColorEB8_+0x4ce>
  5265c6:	4d 89 cc             	mov    %r9,%r12
  5265c9:	4d 89 c7             	mov    %r8,%r15
  5265cc:	48 89 74 24 28       	mov    %rsi,0x28(%rsp)
  5265d1:	4c 89 f7             	mov    %r14,%rdi
  5265d4:	48 89 d6             	mov    %rdx,%rsi
  5265d7:	48 89 ca             	mov    %rcx,%rdx
  5265da:	e8 41 a4 08 00       	call   5b0a20 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE6locateB7_>
  5265df:	a8 01                	test   $0x1,%al
  5265e1:	74 7a                	je     52665d <_RINvMsp_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB6_3WinNtNtB6_12style_ledger9AdversaryE12set_propertyNtNtCs7XZEQI6Z5Ts_11gpui_canvas5color5ColorEB8_+0xdd>
  5265e3:	48 89 d5             	mov    %rdx,%rbp
  5265e6:	49 8b b6 c8 02 00 00 	mov    0x2c8(%r14),%rsi
  5265ed:	48 39 f2             	cmp    %rsi,%rdx
  5265f0:	0f 83 9a 04 00 00    	jae    526a90 <_RINvMsp_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB6_3WinNtNtB6_12style_ledger9AdversaryE12set_propertyNtNtCs7XZEQI6Z5Ts_11gpui_canvas5color5ColorEB8_+0x510>
  5265f6:	4d 8b ae 60 08 00 00 	mov    0x860(%r14),%r13
  5265fd:	49 ff c5             	inc    %r13
  526600:	0f 84 81 04 00 00    	je     526a87 <_RINvMsp_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB6_3WinNtNtB6_12style_ledger9AdversaryE12set_propertyNtNtCs7XZEQI6Z5Ts_11gpui_canvas5color5ColorEB8_+0x507>
  526606:	4d 89 f8             	mov    %r15,%r8
  526609:	4c 89 e0             	mov    %r12,%rax
  52660c:	49 8b 8e c0 02 00 00 	mov    0x2c0(%r14),%rcx
  526613:	48 8d 34 ad 00 00 00 	lea    0x0(,%rbp,4),%rsi
  52661a:	00 
  52661b:	48 01 ee             	add    %rbp,%rsi
  52661e:	48 8b 14 f1          	mov    (%rcx,%rsi,8),%rdx
  526622:	49 8b 8e 28 02 00 00 	mov    0x228(%r14),%rcx
  526629:	48 85 c9             	test   %rcx,%rcx
  52662c:	48 89 74 24 20       	mov    %rsi,0x20(%rsp)
  526631:	74 36                	je     526669 <_RINvMsp_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB6_3WinNtNtB6_12style_ledger9AdversaryE12set_propertyNtNtCs7XZEQI6Z5Ts_11gpui_canvas5color5ColorEB8_+0xe9>
  526633:	83 f9 01             	cmp    $0x1,%ecx
  526636:	75 3a                	jne    526672 <_RINvMsp_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB6_3WinNtNtB6_12style_ledger9AdversaryE12set_propertyNtNtCs7XZEQI6Z5Ts_11gpui_canvas5color5ColorEB8_+0xf2>
  526638:	49 8b b6 40 02 00 00 	mov    0x240(%r14),%rsi
  52663f:	41 b9 38 02 00 00    	mov    $0x238,%r9d
  526645:	48 89 ef             	mov    %rbp,%rdi
  526648:	48 39 f5             	cmp    %rsi,%rbp
  52664b:	72 56                	jb     5266a3 <_RINvMsp_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB6_3WinNtNtB6_12style_ledger9AdversaryE12set_propertyNtNtCs7XZEQI6Z5Ts_11gpui_canvas5color5ColorEB8_+0x123>
  52664d:	48 8d 15 8c 24 59 00 	lea    0x59248c(%rip),%rdx        # ab8ae0 <anon.c906c25ea787c8c2757c1f36aabcd0ba.64.llvm.18178969024155037896+0x70>
  526654:	48 89 ef             	mov    %rbp,%rdi
  526657:	ff 15 cb 37 5c 00    	call   *0x5c37cb(%rip)        # ae9e28 <_DYNAMIC+0x278>
  52665d:	48 c7 03 11 00 00 00 	movq   $0x11,(%rbx)
  526664:	e9 e5 03 00 00       	jmp    526a4e <_RINvMsp_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB6_3WinNtNtB6_12style_ledger9AdversaryE12set_propertyNtNtCs7XZEQI6Z5Ts_11gpui_canvas5color5ColorEB8_+0x4ce>
  526669:	48 8d 0d f8 53 b5 ff 	lea    -0x4aac08(%rip),%rcx        # 7ba68 <anon.5f884de6e78125e25881320d811d32df.113.llvm.17146438997930651657+0x8>
  526670:	eb 39                	jmp    5266ab <_RINvMsp_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB6_3WinNtNtB6_12style_ledger9AdversaryE12set_propertyNtNtCs7XZEQI6Z5Ts_11gpui_canvas5color5ColorEB8_+0x12b>
  526672:	49 8b b6 48 02 00 00 	mov    0x248(%r14),%rsi
  526679:	48 39 f5             	cmp    %rsi,%rbp
  52667c:	0f 83 1e 04 00 00    	jae    526aa0 <_RINvMsp_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB6_3WinNtNtB6_12style_ledger9AdversaryE12set_propertyNtNtCs7XZEQI6Z5Ts_11gpui_canvas5color5ColorEB8_+0x520>
  526682:	49 8b b6 38 02 00 00 	mov    0x238(%r14),%rsi
  526689:	49 8b 8e 40 02 00 00 	mov    0x240(%r14),%rcx
  526690:	0f b6 3c 29          	movzbl (%rcx,%rbp,1),%edi
  526694:	41 b9 30 02 00 00    	mov    $0x230,%r9d
  52669a:	48 39 fe             	cmp    %rdi,%rsi
  52669d:	0f 86 0d 04 00 00    	jbe    526ab0 <_RINvMsp_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB6_3WinNtNtB6_12style_ledger9AdversaryE12set_propertyNtNtCs7XZEQI6Z5Ts_11gpui_canvas5color5ColorEB8_+0x530>
  5266a3:	48 6b cf 58          	imul   $0x58,%rdi,%rcx
  5266a7:	4b 03 0c 0e          	add    (%r14,%r9,1),%rcx
  5266ab:	48 8b 71 50          	mov    0x50(%rcx),%rsi
  5266af:	48 89 b4 24 00 01 00 	mov    %rsi,0x100(%rsp)
  5266b6:	00 
  5266b7:	0f 10 41 40          	movups 0x40(%rcx),%xmm0
  5266bb:	0f 29 84 24 f0 00 00 	movaps %xmm0,0xf0(%rsp)
  5266c2:	00 
  5266c3:	0f 10 01             	movups (%rcx),%xmm0
  5266c6:	0f 10 49 10          	movups 0x10(%rcx),%xmm1
  5266ca:	0f 10 51 20          	movups 0x20(%rcx),%xmm2
  5266ce:	0f 10 59 30          	movups 0x30(%rcx),%xmm3
  5266d2:	0f 29 9c 24 e0 00 00 	movaps %xmm3,0xe0(%rsp)
  5266d9:	00 
  5266da:	0f 29 94 24 d0 00 00 	movaps %xmm2,0xd0(%rsp)
  5266e1:	00 
  5266e2:	0f 29 8c 24 c0 00 00 	movaps %xmm1,0xc0(%rsp)
  5266e9:	00 
  5266ea:	0f 29 84 24 b0 00 00 	movaps %xmm0,0xb0(%rsp)
  5266f1:	00 
  5266f2:	49 8d b6 f8 07 00 00 	lea    0x7f8(%r14),%rsi
  5266f9:	8b 78 10             	mov    0x10(%rax),%edi
  5266fc:	89 bc 24 a0 00 00 00 	mov    %edi,0xa0(%rsp)
  526703:	0f 10 00             	movups (%rax),%xmm0
  526706:	0f 29 84 24 90 00 00 	movaps %xmm0,0x90(%rsp)
  52670d:	00 
  52670e:	48 8b 41 50          	mov    0x50(%rcx),%rax
  526712:	48 89 84 24 80 00 00 	mov    %rax,0x80(%rsp)
  526719:	00 
  52671a:	0f 10 41 40          	movups 0x40(%rcx),%xmm0
  52671e:	0f 29 44 24 70       	movaps %xmm0,0x70(%rsp)
  526723:	0f 10 01             	movups (%rcx),%xmm0
  526726:	0f 10 49 10          	movups 0x10(%rcx),%xmm1
  52672a:	0f 10 51 20          	movups 0x20(%rcx),%xmm2
  52672e:	0f 10 59 30          	movups 0x30(%rcx),%xmm3
  526732:	0f 29 5c 24 60       	movaps %xmm3,0x60(%rsp)
  526737:	0f 29 54 24 50       	movaps %xmm2,0x50(%rsp)
  52673c:	0f 29 4c 24 40       	movaps %xmm1,0x40(%rsp)
  526741:	0f 29 44 24 30       	movaps %xmm0,0x30(%rsp)
  526746:	48 8d bc 24 68 01 00 	lea    0x168(%rsp),%rdi
  52674d:	00 
  52674e:	48 8d 4c 24 30       	lea    0x30(%rsp),%rcx
  526753:	4c 8d 8c 24 90 00 00 	lea    0x90(%rsp),%r9
  52675a:	00 
  52675b:	48 89 14 24          	mov    %rdx,(%rsp)
  52675f:	e8 2c bc 1e 00       	call   712390 <_RINvMs5_NtCs6gaF1xUz9Bf_4gpui8propertyNtB6_9Overrides3setNtNtCs7XZEQI6Z5Ts_11gpui_canvas5color5ColorEB8_>
  526764:	44 8b a4 24 68 01 00 	mov    0x168(%rsp),%r12d
  52676b:	00 
  52676c:	44 8b bc 24 6c 01 00 	mov    0x16c(%rsp),%r15d
  526773:	00 
  526774:	41 83 fc 02          	cmp    $0x2,%r12d
  526778:	75 10                	jne    52678a <_RINvMsp_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB6_3WinNtNtB6_12style_ledger9AdversaryE12set_propertyNtNtCs7XZEQI6Z5Ts_11gpui_canvas5color5ColorEB8_+0x20a>
  52677a:	48 c7 03 23 00 00 00 	movq   $0x23,(%rbx)
  526781:	44 89 7b 08          	mov    %r15d,0x8(%rbx)
  526785:	e9 c4 02 00 00       	jmp    526a4e <_RINvMsp_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB6_3WinNtNtB6_12style_ledger9AdversaryE12set_propertyNtNtCs7XZEQI6Z5Ts_11gpui_canvas5color5ColorEB8_+0x4ce>
  52678a:	48 89 6c 24 18       	mov    %rbp,0x18(%rsp)
  52678f:	0f 10 84 24 b0 01 00 	movups 0x1b0(%rsp),%xmm0
  526796:	00 
  526797:	0f 11 84 24 58 01 00 	movups %xmm0,0x158(%rsp)
  52679e:	00 
  52679f:	0f 10 84 24 70 01 00 	movups 0x170(%rsp),%xmm0
  5267a6:	00 
  5267a7:	0f 10 8c 24 80 01 00 	movups 0x180(%rsp),%xmm1
  5267ae:	00 
  5267af:	0f 10 94 24 90 01 00 	movups 0x190(%rsp),%xmm2
  5267b6:	00 
  5267b7:	0f 10 9c 24 a0 01 00 	movups 0x1a0(%rsp),%xmm3
  5267be:	00 
  5267bf:	0f 11 9c 24 48 01 00 	movups %xmm3,0x148(%rsp)
  5267c6:	00 
  5267c7:	0f 11 94 24 38 01 00 	movups %xmm2,0x138(%rsp)
  5267ce:	00 
  5267cf:	0f 11 8c 24 28 01 00 	movups %xmm1,0x128(%rsp)
  5267d6:	00 
  5267d7:	0f 11 84 24 18 01 00 	movups %xmm0,0x118(%rsp)
  5267de:	00 
  5267df:	44 89 a4 24 10 01 00 	mov    %r12d,0x110(%rsp)
  5267e6:	00 
  5267e7:	44 89 bc 24 14 01 00 	mov    %r15d,0x114(%rsp)
  5267ee:	00 
  5267ef:	4d 89 ae 60 08 00 00 	mov    %r13,0x860(%r14)
  5267f6:	49 ff 86 f0 08 00 00 	incq   0x8f0(%r14)
  5267fd:	48 8d ac 24 b0 00 00 	lea    0xb0(%rsp),%rbp
  526804:	00 
  526805:	4c 8d ac 24 10 01 00 	lea    0x110(%rsp),%r13
  52680c:	00 
  52680d:	48 89 ef             	mov    %rbp,%rdi
  526810:	4c 89 ee             	mov    %r13,%rsi
  526813:	e8 c8 7c 13 00       	call   65e4e0 <_RNvXse_NtCs6gaF1xUz9Bf_4gpui5styleNtB5_5StyleNtNtCs4NRVxsYgnAr_4core3cmp9PartialEq2eq>
  526818:	34 01                	xor    $0x1,%al
  52681a:	0f b6 c0             	movzbl %al,%eax
  52681d:	49 89 86 48 09 00 00 	mov    %rax,0x948(%r14)
  526824:	48 89 ef             	mov    %rbp,%rdi
  526827:	4c 89 ee             	mov    %r13,%rsi
  52682a:	e8 b1 7c 13 00       	call   65e4e0 <_RNvXse_NtCs6gaF1xUz9Bf_4gpui5styleNtB5_5StyleNtNtCs4NRVxsYgnAr_4core3cmp9PartialEq2eq>
  52682f:	84 c0                	test   %al,%al
  526831:	0f 85 aa 01 00 00    	jne    5269e1 <_RINvMsp_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB6_3WinNtNtB6_12style_ledger9AdversaryE12set_propertyNtNtCs7XZEQI6Z5Ts_11gpui_canvas5color5ColorEB8_+0x461>
  526837:	44 8b 8c 24 b8 00 00 	mov    0xb8(%rsp),%r9d
  52683e:	00 
  52683f:	0f b6 8c 24 04 01 00 	movzbl 0x104(%rsp),%ecx
  526846:	00 
  526847:	8b 84 24 18 01 00 00 	mov    0x118(%rsp),%eax
  52684e:	0f 10 a4 24 bc 00 00 	movups 0xbc(%rsp),%xmm4
  526855:	00 
  526856:	f3 0f 10 84 24 c0 00 	movss  0xc0(%rsp),%xmm0
  52685d:	00 00 
  52685f:	0f 10 ac 24 1c 01 00 	movups 0x11c(%rsp),%xmm5
  526866:	00 
  526867:	f3 0f 10 8c 24 20 01 	movss  0x120(%rsp),%xmm1
  52686e:	00 00 
  526870:	0f b6 94 24 64 01 00 	movzbl 0x164(%rsp),%edx
  526877:	00 
  526878:	83 bc 24 b0 00 00 00 	cmpl   $0x1,0xb0(%rsp)
  52687f:	01 
  526880:	4c 8b 6c 24 18       	mov    0x18(%rsp),%r13
  526885:	75 27                	jne    5268ae <_RINvMsp_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB6_3WinNtNtB6_12style_ledger9AdversaryE12set_propertyNtNtCs7XZEQI6Z5Ts_11gpui_canvas5color5ColorEB8_+0x32e>
  526887:	66 41 0f 6e d7       	movd   %r15d,%xmm2
  52688c:	f3 0f 10 9c 24 b4 00 	movss  0xb4(%rsp),%xmm3
  526893:	00 00 
  526895:	0f 2e da             	ucomiss %xmm2,%xmm3
  526898:	40 0f 9b c7          	setnp  %dil
  52689c:	41 0f 94 c0          	sete   %r8b
  5268a0:	41 20 f8             	and    %dil,%r8b
  5268a3:	45 84 c4             	test   %r8b,%r12b
  5268a6:	48 8b 34 24          	mov    (%rsp),%rsi
  5268aa:	75 0c                	jne    5268b8 <_RINvMsp_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB6_3WinNtNtB6_12style_ledger9AdversaryE12set_propertyNtNtCs7XZEQI6Z5Ts_11gpui_canvas5color5ColorEB8_+0x338>
  5268ac:	eb 66                	jmp    526914 <_RINvMsp_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB6_3WinNtNtB6_12style_ledger9AdversaryE12set_propertyNtNtCs7XZEQI6Z5Ts_11gpui_canvas5color5ColorEB8_+0x394>
  5268ae:	41 f6 c4 01          	test   $0x1,%r12b
  5268b2:	48 8b 34 24          	mov    (%rsp),%rsi
  5268b6:	75 5c                	jne    526914 <_RINvMsp_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB6_3WinNtNtB6_12style_ledger9AdversaryE12set_propertyNtNtCs7XZEQI6Z5Ts_11gpui_canvas5color5ColorEB8_+0x394>
  5268b8:	41 83 f9 01          	cmp    $0x1,%r9d
  5268bc:	75 1d                	jne    5268db <_RINvMsp_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB6_3WinNtNtB6_12style_ledger9AdversaryE12set_propertyNtNtCs7XZEQI6Z5Ts_11gpui_canvas5color5ColorEB8_+0x35b>
  5268be:	38 d1                	cmp    %dl,%cl
  5268c0:	0f 94 c1             	sete   %cl
  5268c3:	0f 28 c4             	movaps %xmm4,%xmm0
  5268c6:	0f c2 c5 00          	cmpeqps %xmm5,%xmm0
  5268ca:	0f 50 d0             	movmskps %xmm0,%edx
  5268cd:	83 fa 0f             	cmp    $0xf,%edx
  5268d0:	0f 94 c2             	sete   %dl
  5268d3:	20 c2                	and    %al,%dl
  5268d5:	84 ca                	test   %cl,%dl
  5268d7:	74 3b                	je     526914 <_RINvMsp_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB6_3WinNtNtB6_12style_ledger9AdversaryE12set_propertyNtNtCs7XZEQI6Z5Ts_11gpui_canvas5color5ColorEB8_+0x394>
  5268d9:	eb 5d                	jmp    526938 <_RINvMsp_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB6_3WinNtNtB6_12style_ledger9AdversaryE12set_propertyNtNtCs7XZEQI6Z5Ts_11gpui_canvas5color5ColorEB8_+0x3b8>
  5268db:	0f 2e c1             	ucomiss %xmm1,%xmm0
  5268de:	41 0f 9b c0          	setnp  %r8b
  5268e2:	40 0f 94 c7          	sete   %dil
  5268e6:	44 20 c7             	and    %r8b,%dil
  5268e9:	f6 d0                	not    %al
  5268eb:	40 20 f8             	and    %dil,%al
  5268ee:	0f 28 c4             	movaps %xmm4,%xmm0
  5268f1:	0f c2 c5 00          	cmpeqps %xmm5,%xmm0
  5268f5:	44 0f 50 c0          	movmskps %xmm0,%r8d
  5268f9:	44 89 c7             	mov    %r8d,%edi
  5268fc:	40 c0 ef 03          	shr    $0x3,%dil
  526900:	41 c0 e8 02          	shr    $0x2,%r8b
  526904:	41 20 c0             	and    %al,%r8b
  526907:	41 20 f8             	and    %dil,%r8b
  52690a:	38 d1                	cmp    %dl,%cl
  52690c:	0f 94 c0             	sete   %al
  52690f:	41 84 c0             	test   %al,%r8b
  526912:	75 24                	jne    526938 <_RINvMsp_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB6_3WinNtNtB6_12style_ledger9AdversaryE12set_propertyNtNtCs7XZEQI6Z5Ts_11gpui_canvas5color5ColorEB8_+0x3b8>
  526914:	49 8d be 48 08 00 00 	lea    0x848(%r14),%rdi
  52691b:	0f 29 24 24          	movaps %xmm4,(%rsp)
  52691f:	0f 29 ac 24 c0 01 00 	movaps %xmm5,0x1c0(%rsp)
  526926:	00 
  526927:	e8 14 22 20 00       	call   728b40 <_RNvMsi_NtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB5_8BTreeMapyNtNtB7_7set_val9SetValZSTE6insertCs6gaF1xUz9Bf_4gpui>
  52692c:	0f 28 ac 24 c0 01 00 	movaps 0x1c0(%rsp),%xmm5
  526933:	00 
  526934:	0f 28 24 24          	movaps (%rsp),%xmm4
  526938:	0f c2 e5 04          	cmpneqps %xmm5,%xmm4
  52693c:	66 0f c5 c4 06       	pextrw $0x6,%xmm4,%eax
  526941:	49 8b 8e c8 02 00 00 	mov    0x2c8(%r14),%rcx
  526948:	a8 01                	test   $0x1,%al
  52694a:	74 76                	je     5269c2 <_RINvMsp_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB6_3WinNtNtB6_12style_ledger9AdversaryE12set_propertyNtNtCs7XZEQI6Z5Ts_11gpui_canvas5color5ColorEB8_+0x442>
  52694c:	49 39 cd             	cmp    %rcx,%r13
  52694f:	0f 83 68 01 00 00    	jae    526abd <_RINvMsp_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB6_3WinNtNtB6_12style_ledger9AdversaryE12set_propertyNtNtCs7XZEQI6Z5Ts_11gpui_canvas5color5ColorEB8_+0x53d>
  526955:	49 8b 86 c0 02 00 00 	mov    0x2c0(%r14),%rax
  52695c:	48 8b 54 24 20       	mov    0x20(%rsp),%rdx
  526961:	8b 44 d0 20          	mov    0x20(%rax,%rdx,8),%eax
  526965:	89 c2                	mov    %eax,%edx
  526967:	83 e2 07             	and    $0x7,%edx
  52696a:	83 fa 06             	cmp    $0x6,%edx
  52696d:	0f 83 f0 00 00 00    	jae    526a63 <_RINvMsp_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB6_3WinNtNtB6_12style_ledger9AdversaryE12set_propertyNtNtCs7XZEQI6Z5Ts_11gpui_canvas5color5ColorEB8_+0x4e3>
  526973:	c1 e8 03             	shr    $0x3,%eax
  526976:	ff c8                	dec    %eax
  526978:	89 84 24 68 01 00 00 	mov    %eax,0x168(%rsp)
  52697f:	41 0f 10 86 d8 02 00 	movups 0x2d8(%r14),%xmm0
  526986:	00 
  526987:	0f 11 44 24 30       	movups %xmm0,0x30(%rsp)
  52698c:	48 8d 94 24 68 01 00 	lea    0x168(%rsp),%rdx
  526993:	00 
  526994:	48 89 54 24 40       	mov    %rdx,0x40(%rsp)
  526999:	83 f8 ff             	cmp    $0xffffffff,%eax
  52699c:	74 24                	je     5269c2 <_RINvMsp_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB6_3WinNtNtB6_12style_ledger9AdversaryE12set_propertyNtNtCs7XZEQI6Z5Ts_11gpui_canvas5color5ColorEB8_+0x442>
  52699e:	48 8d 7c 24 30       	lea    0x30(%rsp),%rdi
  5269a3:	e8 d8 6c 01 00       	call   53d680 <_RNCNvMsf_NtCs6gaF1xUz9Bf_4gpui7runtimeNtB7_8TextSlot7get_mut0B9_>
  5269a8:	49 89 c4             	mov    %rax,%r12
  5269ab:	48 89 c7             	mov    %rax,%rdi
  5269ae:	e8 5d 2d 00 00       	call   529710 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtB4_6option6OptionNtNtCs6gaF1xUz9Bf_4gpui7runtime6ShapedEEB11_.llvm.18178969024155037896>
  5269b3:	49 c7 04 24 ff ff ff 	movq   $0xffffffffffffffff,(%r12)
  5269ba:	ff 
  5269bb:	49 8b 8e c8 02 00 00 	mov    0x2c8(%r14),%rcx
  5269c2:	49 8d be 28 02 00 00 	lea    0x228(%r14),%rdi
  5269c9:	48 8d 94 24 10 01 00 	lea    0x110(%rsp),%rdx
  5269d0:	00 
  5269d1:	4c 89 ee             	mov    %r13,%rsi
  5269d4:	e8 c7 16 25 00       	call   7780a0 <_RNvMNtNtCs6gaF1xUz9Bf_4gpui7runtime6stylesNtB2_6Styles3set>
  5269d9:	41 c6 86 5b 09 00 00 	movb   $0x1,0x95b(%r14)
  5269e0:	01 
  5269e1:	49 83 be 28 08 00 00 	cmpq   $0x0,0x828(%r14)
  5269e8:	00 
  5269e9:	48 8b 54 24 28       	mov    0x28(%rsp),%rdx
  5269ee:	74 2e                	je     526a1e <_RINvMsp_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB6_3WinNtNtB6_12style_ledger9AdversaryE12set_propertyNtNtCs7XZEQI6Z5Ts_11gpui_canvas5color5ColorEB8_+0x49e>
  5269f0:	48 83 c2 08          	add    $0x8,%rdx
  5269f4:	48 c7 84 24 68 01 00 	movq   $0xffffffffffffffff,0x168(%rsp)
  5269fb:	00 ff ff ff ff 
  526a00:	48 8d 7c 24 30       	lea    0x30(%rsp),%rdi
  526a05:	4c 8d 84 24 68 01 00 	lea    0x168(%rsp),%r8
  526a0c:	00 
  526a0d:	4c 89 f6             	mov    %r14,%rsi
  526a10:	31 c9                	xor    %ecx,%ecx
  526a12:	e8 69 97 01 00       	call   540180 <_RNvMNtNtCs6gaF1xUz9Bf_4gpui7runtime4turnINtB4_10RuntimeMutNtNtB4_12style_ledger9AdversaryuE13describe_withB6_.llvm.18178969024155037896>
  526a17:	83 7c 24 30 fe       	cmpl   $0xfffffffe,0x30(%rsp)
  526a1c:	75 0d                	jne    526a2b <_RINvMsp_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB6_3WinNtNtB6_12style_ledger9AdversaryE12set_propertyNtNtCs7XZEQI6Z5Ts_11gpui_canvas5color5ColorEB8_+0x4ab>
  526a1e:	48 89 df             	mov    %rbx,%rdi
  526a21:	4c 89 f6             	mov    %r14,%rsi
  526a24:	e8 87 a1 08 00       	call   5b0bb0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE7presentB7_.llvm.18178969024155037896>
  526a29:	eb 23                	jmp    526a4e <_RINvMsp_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB6_3WinNtNtB6_12style_ledger9AdversaryE12set_propertyNtNtCs7XZEQI6Z5Ts_11gpui_canvas5color5ColorEB8_+0x4ce>
  526a2b:	48 8b 44 24 60       	mov    0x60(%rsp),%rax
  526a30:	48 89 43 30          	mov    %rax,0x30(%rbx)
  526a34:	0f 10 44 24 30       	movups 0x30(%rsp),%xmm0
  526a39:	0f 10 4c 24 40       	movups 0x40(%rsp),%xmm1
  526a3e:	0f 10 54 24 50       	movups 0x50(%rsp),%xmm2
  526a43:	0f 11 53 20          	movups %xmm2,0x20(%rbx)
  526a47:	0f 11 4b 10          	movups %xmm1,0x10(%rbx)
  526a4b:	0f 11 03             	movups %xmm0,(%rbx)
  526a4e:	48 89 d8             	mov    %rbx,%rax
  526a51:	48 81 c4 d8 01 00 00 	add    $0x1d8,%rsp
  526a58:	5b                   	pop    %rbx
  526a59:	41 5c                	pop    %r12
  526a5b:	41 5d                	pop    %r13
  526a5d:	41 5e                	pop    %r14
  526a5f:	41 5f                	pop    %r15
  526a61:	5d                   	pop    %rbp
  526a62:	c3                   	ret
  526a63:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  526a68:	0f 84 0a ff ff ff    	je     526978 <_RINvMsp_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB6_3WinNtNtB6_12style_ledger9AdversaryE12set_propertyNtNtCs7XZEQI6Z5Ts_11gpui_canvas5color5ColorEB8_+0x3f8>
  526a6e:	48 8d 3d 73 50 b5 ff 	lea    -0x4aaf8d(%rip),%rdi        # 7bae8 <anon.5f884de6e78125e25881320d811d32df.113.llvm.17146438997930651657+0x88>
  526a75:	48 8d 15 24 21 59 00 	lea    0x592124(%rip),%rdx        # ab8ba0 <anon.c906c25ea787c8c2757c1f36aabcd0ba.64.llvm.18178969024155037896+0x130>
  526a7c:	be a1 00 00 00       	mov    $0xa1,%esi
  526a81:	ff 15 a9 33 5c 00    	call   *0x5c33a9(%rip)        # ae9e30 <_DYNAMIC+0x280>
  526a87:	48 c7 03 1e 00 00 00 	movq   $0x1e,(%rbx)
  526a8e:	eb be                	jmp    526a4e <_RINvMsp_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB6_3WinNtNtB6_12style_ledger9AdversaryE12set_propertyNtNtCs7XZEQI6Z5Ts_11gpui_canvas5color5ColorEB8_+0x4ce>
  526a90:	48 8d 15 11 1b 59 00 	lea    0x591b11(%rip),%rdx        # ab85a8 <__frame_dummy_init_array_entry+0x38>
  526a97:	48 89 ef             	mov    %rbp,%rdi
  526a9a:	ff 15 88 33 5c 00    	call   *0x5c3388(%rip)        # ae9e28 <_DYNAMIC+0x278>
  526aa0:	48 8d 15 51 20 59 00 	lea    0x592051(%rip),%rdx        # ab8af8 <anon.c906c25ea787c8c2757c1f36aabcd0ba.64.llvm.18178969024155037896+0x88>
  526aa7:	48 89 ef             	mov    %rbp,%rdi
  526aaa:	ff 15 78 33 5c 00    	call   *0x5c3378(%rip)        # ae9e28 <_DYNAMIC+0x278>
  526ab0:	48 8d 15 59 20 59 00 	lea    0x592059(%rip),%rdx        # ab8b10 <anon.c906c25ea787c8c2757c1f36aabcd0ba.64.llvm.18178969024155037896+0xa0>
  526ab7:	ff 15 6b 33 5c 00    	call   *0x5c336b(%rip)        # ae9e28 <_DYNAMIC+0x278>
  526abd:	48 8d 15 fc 1a 59 00 	lea    0x591afc(%rip),%rdx        # ab85c0 <__frame_dummy_init_array_entry+0x50>
  526ac4:	4c 89 ef             	mov    %r13,%rdi
  526ac7:	48 89 ce             	mov    %rcx,%rsi
  526aca:	ff 15 58 33 5c 00    	call   *0x5c3358(%rip)        # ae9e28 <_DYNAMIC+0x278>
  526ad0:	49 c7 04 24 ff ff ff 	movq   $0xffffffffffffffff,(%r12)
  526ad7:	ff 
  526ad8:	48 89 c7             	mov    %rax,%rdi
  526adb:	e8 f0 07 59 00       	call   ab72d0 <_Unwind_Resume@plt>
