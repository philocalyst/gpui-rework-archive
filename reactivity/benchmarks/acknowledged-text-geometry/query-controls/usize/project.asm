
/tmp/gpui-ack-query-comparison/usize/client:     file format elf64-x86-64


Disassembly of section .text:

0000000000a69550 <gpui::native::accessibility::project>:
  a69550:	55                   	push   %rbp
  a69551:	41 57                	push   %r15
  a69553:	41 56                	push   %r14
  a69555:	41 55                	push   %r13
  a69557:	41 54                	push   %r12
  a69559:	53                   	push   %rbx
  a6955a:	48 81 ec 58 01 00 00 	sub    $0x158,%rsp
  a69561:	48 b8 57 57 57 57 57 	movabs $0x5757575757575757,%rax
  a69568:	57 57 57 
  a6956b:	48 89 84 24 3f 01 00 	mov    %rax,0x13f(%rsp)
  a69572:	00 
  a69573:	66 0f 28 05 85 3b 72 	movapd -0x8dc47b(%rip),%xmm0        # 18d100 <anon.05933fb6bb17d4b782622fe161e9f81c.121.llvm.18391229140309290632+0xb0>
  a6957a:	ff 
  a6957b:	66 0f 11 84 24 30 01 	movupd %xmm0,0x130(%rsp)
  a69582:	00 00 
  a69584:	66 0f 11 84 24 20 01 	movupd %xmm0,0x120(%rsp)
  a6958b:	00 00 
  a6958d:	66 0f 11 84 24 10 01 	movupd %xmm0,0x110(%rsp)
  a69594:	00 00 
  a69596:	66 0f 11 84 24 00 01 	movupd %xmm0,0x100(%rsp)
  a6959d:	00 00 
  a6959f:	66 0f 11 84 24 f0 00 	movupd %xmm0,0xf0(%rsp)
  a695a6:	00 00 
  a695a8:	c6 84 24 54 01 00 00 	movb   $0x85,0x154(%rsp)
  a695af:	85 
  a695b0:	48 c7 84 24 48 01 00 	movq   $0x0,0x148(%rsp)
  a695b7:	00 00 00 00 00 
  a695bc:	c7 84 24 50 01 00 00 	movl   $0x0,0x150(%rsp)
  a695c3:	00 00 00 00 
  a695c7:	48 c7 84 24 d8 00 00 	movq   $0x0,0xd8(%rsp)
  a695ce:	00 00 00 00 00 
  a695d3:	48 c7 84 24 e0 00 00 	movq   $0x8,0xe0(%rsp)
  a695da:	00 08 00 00 00 
  a695df:	48 c7 84 24 e8 00 00 	movq   $0x0,0xe8(%rsp)
  a695e6:	00 00 00 00 00 
  a695eb:	4d 85 c0             	test   %r8,%r8
  a695ee:	0f 88 18 01 00 00    	js     a6970c <gpui::native::accessibility::project+0x1bc>
  a695f4:	4d 89 cf             	mov    %r9,%r15
  a695f7:	4d 89 c4             	mov    %r8,%r12
  a695fa:	49 89 d5             	mov    %rdx,%r13
  a695fd:	49 89 f6             	mov    %rsi,%r14
  a69600:	48 89 bc 24 d0 00 00 	mov    %rdi,0xd0(%rsp)
  a69607:	00 
  a69608:	74 43                	je     a6964d <gpui::native::accessibility::project+0xfd>
  a6960a:	48 89 8c 24 c8 00 00 	mov    %rcx,0xc8(%rsp)
  a69611:	00 
  a69612:	ff 15 48 63 ac 00    	call   *0xac6348(%rip)        # 152f960 <_DYNAMIC+0x240>
  a69618:	bd 01 00 00 00       	mov    $0x1,%ebp
  a6961d:	be 01 00 00 00       	mov    $0x1,%esi
  a69622:	4c 89 e7             	mov    %r12,%rdi
  a69625:	ff 15 3d 63 ac 00    	call   *0xac633d(%rip)        # 152f968 <_DYNAMIC+0x248>
  a6962b:	48 85 c0             	test   %rax,%rax
  a6962e:	0f 84 da 00 00 00    	je     a6970e <gpui::native::accessibility::project+0x1be>
  a69634:	48 89 c3             	mov    %rax,%rbx
  a69637:	48 89 c7             	mov    %rax,%rdi
  a6963a:	48 8b b4 24 c8 00 00 	mov    0xc8(%rsp),%rsi
  a69641:	00 
  a69642:	4c 89 e2             	mov    %r12,%rdx
  a69645:	ff 15 35 63 ac 00    	call   *0xac6335(%rip)        # 152f980 <memcpy@GLIBC_2.14>
  a6964b:	eb 05                	jmp    a69652 <gpui::native::accessibility::project+0x102>
  a6964d:	bb 01 00 00 00       	mov    $0x1,%ebx
  a69652:	4c 89 64 24 48       	mov    %r12,0x48(%rsp)
  a69657:	48 89 5c 24 50       	mov    %rbx,0x50(%rsp)
  a6965c:	4c 89 64 24 58       	mov    %r12,0x58(%rsp)
  a69661:	c6 44 24 40 03       	movb   $0x3,0x40(%rsp)
  a69666:	48 8d bc 24 d8 00 00 	lea    0xd8(%rsp),%rdi
  a6966d:	00 
  a6966e:	48 8d 54 24 40       	lea    0x40(%rsp),%rdx
  a69673:	be 0f 00 00 00       	mov    $0xf,%esi
  a69678:	ff 15 12 77 ac 00    	call   *0xac7712(%rip)        # 1530d90 <_DYNAMIC+0x1670>
  a6967e:	80 8c 24 51 01 00 00 	orb    $0x8,0x151(%rsp)
  a69685:	08 
  a69686:	66 0f 57 c0          	xorpd  %xmm0,%xmm0
  a6968a:	66 0f 29 44 24 40    	movapd %xmm0,0x40(%rsp)
  a69690:	f2 41 0f 10 4d 28    	movsd  0x28(%r13),%xmm1
  a69696:	0f 14 c8             	unpcklps %xmm0,%xmm1
  a69699:	66 0f 28 05 ef 5b 72 	movapd -0x8da411(%rip),%xmm0        # 18f290 <anon.05933fb6bb17d4b782622fe161e9f81c.309.llvm.18391229140309290632+0x920>
  a696a0:	ff 
  a696a1:	66 0f 56 c8          	orpd   %xmm0,%xmm1
  a696a5:	66 0f 5c c8          	subpd  %xmm0,%xmm1
  a696a9:	66 0f 29 4c 24 50    	movapd %xmm1,0x50(%rsp)
  a696af:	48 8d bc 24 d8 00 00 	lea    0xd8(%rsp),%rdi
  a696b6:	00 
  a696b7:	48 8d 54 24 40       	lea    0x40(%rsp),%rdx
  a696bc:	be 53 00 00 00       	mov    $0x53,%esi
  a696c1:	ff 15 d1 76 ac 00    	call   *0xac76d1(%rip)        # 1530d98 <_DYNAMIC+0x1678>
  a696c7:	4d 8b 6e 38          	mov    0x38(%r14),%r13
  a696cb:	4d 85 ed             	test   %r13,%r13
  a696ce:	74 4f                	je     a6971f <gpui::native::accessibility::project+0x1cf>
  a696d0:	49 8d 5d 01          	lea    0x1(%r13),%rbx
  a696d4:	45 31 e4             	xor    %r12d,%r12d
  a696d7:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  a696de:	00 00 
  a696e0:	4c 89 ff             	mov    %r15,%rdi
  a696e3:	4c 89 f6             	mov    %r14,%rsi
  a696e6:	4c 89 e2             	mov    %r12,%rdx
  a696e9:	e8 52 3c ff ff       	call   a5d340 <<gpui::native::accessibility::text::Cohort>::text_count>
  a696ee:	48 01 c3             	add    %rax,%rbx
  a696f1:	49 ff c4             	inc    %r12
  a696f4:	4d 39 e5             	cmp    %r12,%r13
  a696f7:	75 e7                	jne    a696e0 <gpui::native::accessibility::project+0x190>
  a696f9:	48 b8 f0 f0 f0 f0 f0 	movabs $0xf0f0f0f0f0f0f0,%rax
  a69700:	f0 f0 00 
  a69703:	48 39 c3             	cmp    %rax,%rbx
  a69706:	0f 86 8e 02 00 00    	jbe    a6999a <gpui::native::accessibility::project+0x44a>
  a6970c:	31 ed                	xor    %ebp,%ebp
  a6970e:	48 89 ef             	mov    %rbp,%rdi
  a69711:	4c 89 e6             	mov    %r12,%rsi
  a69714:	ff 15 3e 63 ac 00    	call   *0xac633e(%rip)        # 152fa58 <_DYNAMIC+0x338>
  a6971a:	e9 aa 02 00 00       	jmp    a699c9 <gpui::native::accessibility::project+0x479>
  a6971f:	41 bc 88 00 00 00    	mov    $0x88,%r12d
  a69725:	bb 01 00 00 00       	mov    $0x1,%ebx
  a6972a:	ff 15 30 62 ac 00    	call   *0xac6230(%rip)        # 152f960 <_DYNAMIC+0x240>
  a69730:	bd 08 00 00 00       	mov    $0x8,%ebp
  a69735:	be 08 00 00 00       	mov    $0x8,%esi
  a6973a:	4c 89 e7             	mov    %r12,%rdi
  a6973d:	ff 15 25 62 ac 00    	call   *0xac6225(%rip)        # 152f968 <_DYNAMIC+0x248>
  a69743:	48 85 c0             	test   %rax,%rax
  a69746:	74 c6                	je     a6970e <gpui::native::accessibility::project+0x1be>
  a69748:	48 89 c7             	mov    %rax,%rdi
  a6974b:	48 89 5c 24 08       	mov    %rbx,0x8(%rsp)
  a69750:	48 89 7c 24 10       	mov    %rdi,0x10(%rsp)
  a69755:	48 c7 44 24 18 00 00 	movq   $0x0,0x18(%rsp)
  a6975c:	00 00 
  a6975e:	0f 10 84 24 48 01 00 	movups 0x148(%rsp),%xmm0
  a69765:	00 
  a69766:	0f 11 84 24 b8 00 00 	movups %xmm0,0xb8(%rsp)
  a6976d:	00 
  a6976e:	0f 10 84 24 38 01 00 	movups 0x138(%rsp),%xmm0
  a69775:	00 
  a69776:	0f 11 84 24 a8 00 00 	movups %xmm0,0xa8(%rsp)
  a6977d:	00 
  a6977e:	0f 10 84 24 28 01 00 	movups 0x128(%rsp),%xmm0
  a69785:	00 
  a69786:	0f 11 84 24 98 00 00 	movups %xmm0,0x98(%rsp)
  a6978d:	00 
  a6978e:	0f 10 84 24 18 01 00 	movups 0x118(%rsp),%xmm0
  a69795:	00 
  a69796:	0f 11 84 24 88 00 00 	movups %xmm0,0x88(%rsp)
  a6979d:	00 
  a6979e:	66 0f 10 84 24 d8 00 	movupd 0xd8(%rsp),%xmm0
  a697a5:	00 00 
  a697a7:	66 0f 10 8c 24 e8 00 	movupd 0xe8(%rsp),%xmm1
  a697ae:	00 00 
  a697b0:	0f 10 94 24 f8 00 00 	movups 0xf8(%rsp),%xmm2
  a697b7:	00 
  a697b8:	0f 10 9c 24 08 01 00 	movups 0x108(%rsp),%xmm3
  a697bf:	00 
  a697c0:	0f 11 5c 24 78       	movups %xmm3,0x78(%rsp)
  a697c5:	0f 11 54 24 68       	movups %xmm2,0x68(%rsp)
  a697ca:	66 0f 11 4c 24 58    	movupd %xmm1,0x58(%rsp)
  a697d0:	66 0f 11 44 24 48    	movupd %xmm0,0x48(%rsp)
  a697d6:	48 c7 44 24 40 00 00 	movq   $0x0,0x40(%rsp)
  a697dd:	00 00 
  a697df:	48 85 db             	test   %rbx,%rbx
  a697e2:	48 8b 9c 24 d0 00 00 	mov    0xd0(%rsp),%rbx
  a697e9:	00 
  a697ea:	75 10                	jne    a697fc <gpui::native::accessibility::project+0x2ac>
  a697ec:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  a697f1:	ff 15 c9 75 ac 00    	call   *0xac75c9(%rip)        # 1530dc0 <_DYNAMIC+0x16a0>
  a697f7:	48 8b 7c 24 10       	mov    0x10(%rsp),%rdi
  a697fc:	48 8d 74 24 40       	lea    0x40(%rsp),%rsi
  a69801:	ba 88 00 00 00       	mov    $0x88,%edx
  a69806:	ff 15 74 61 ac 00    	call   *0xac6174(%rip)        # 152f980 <memcpy@GLIBC_2.14>
  a6980c:	48 c7 44 24 18 01 00 	movq   $0x1,0x18(%rsp)
  a69813:	00 00 
  a69815:	48 c7 44 24 28 00 00 	movq   $0x0,0x28(%rsp)
  a6981c:	00 00 
  a6981e:	48 c7 44 24 30 08 00 	movq   $0x8,0x30(%rsp)
  a69825:	00 00 
  a69827:	48 c7 44 24 38 00 00 	movq   $0x0,0x38(%rsp)
  a6982e:	00 00 
  a69830:	48 c7 44 24 20 00 00 	movq   $0x0,0x20(%rsp)
  a69837:	00 00 
  a69839:	48 8d 44 24 28       	lea    0x28(%rsp),%rax
  a6983e:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
  a69843:	4c 89 7c 24 48       	mov    %r15,0x48(%rsp)
  a69848:	48 8d 44 24 08       	lea    0x8(%rsp),%rax
  a6984d:	48 89 44 24 50       	mov    %rax,0x50(%rsp)
  a69852:	48 8d 44 24 20       	lea    0x20(%rsp),%rax
  a69857:	48 89 44 24 58       	mov    %rax,0x58(%rsp)
  a6985c:	48 8d 74 24 40       	lea    0x40(%rsp),%rsi
  a69861:	4c 89 f7             	mov    %r14,%rdi
  a69864:	e8 37 74 ff ff       	call   a60ca0 <<gpui::runtime::query::SemanticSheet>::visit::<gpui::native::accessibility::project::{closure#1}>>
  a69869:	48 c7 44 24 70 00 00 	movq   $0x0,0x70(%rsp)
  a69870:	00 00 
  a69872:	48 c7 44 24 40 ff ff 	movq   $0xffffffffffffffff,0x40(%rsp)
  a69879:	ff ff 
  a6987b:	48 c7 44 24 58 ff ff 	movq   $0xffffffffffffffff,0x58(%rsp)
  a69882:	ff ff 
  a69884:	ff 15 d6 60 ac 00    	call   *0xac60d6(%rip)        # 152f960 <_DYNAMIC+0x240>
  a6988a:	41 be 04 00 00 00    	mov    $0x4,%r14d
  a69890:	bf 04 00 00 00       	mov    $0x4,%edi
  a69895:	be 01 00 00 00       	mov    $0x1,%esi
  a6989a:	ff 15 c8 60 ac 00    	call   *0xac60c8(%rip)        # 152f968 <_DYNAMIC+0x248>
  a698a0:	48 85 c0             	test   %rax,%rax
  a698a3:	0f 84 12 01 00 00    	je     a699bb <gpui::native::accessibility::project+0x46b>
  a698a9:	c7 00 47 50 55 49    	movl   $0x49555047,(%rax)
  a698af:	48 c7 44 24 40 04 00 	movq   $0x4,0x40(%rsp)
  a698b6:	00 00 
  a698b8:	48 89 44 24 48       	mov    %rax,0x48(%rsp)
  a698bd:	48 c7 44 24 50 04 00 	movq   $0x4,0x50(%rsp)
  a698c4:	00 00 
  a698c6:	ff 15 94 60 ac 00    	call   *0xac6094(%rip)        # 152f960 <_DYNAMIC+0x240>
  a698cc:	41 be 05 00 00 00    	mov    $0x5,%r14d
  a698d2:	bf 05 00 00 00       	mov    $0x5,%edi
  a698d7:	be 01 00 00 00       	mov    $0x1,%esi
  a698dc:	ff 15 86 60 ac 00    	call   *0xac6086(%rip)        # 152f968 <_DYNAMIC+0x248>
  a698e2:	48 85 c0             	test   %rax,%rax
  a698e5:	0f 84 d0 00 00 00    	je     a699bb <gpui::native::accessibility::project+0x46b>
  a698eb:	c6 40 04 30          	movb   $0x30,0x4(%rax)
  a698ef:	c7 00 30 2e 31 2e    	movl   $0x2e312e30,(%rax)
  a698f5:	48 c7 44 24 58 05 00 	movq   $0x5,0x58(%rsp)
  a698fc:	00 00 
  a698fe:	48 89 44 24 60       	mov    %rax,0x60(%rsp)
  a69903:	48 c7 44 24 68 05 00 	movq   $0x5,0x68(%rsp)
  a6990a:	00 00 
  a6990c:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  a69911:	48 89 43 10          	mov    %rax,0x10(%rbx)
  a69915:	0f 10 44 24 08       	movups 0x8(%rsp),%xmm0
  a6991a:	0f 11 03             	movups %xmm0,(%rbx)
  a6991d:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  a69922:	48 89 43 48          	mov    %rax,0x48(%rbx)
  a69926:	0f 10 44 24 40       	movups 0x40(%rsp),%xmm0
  a6992b:	48 8b 44 24 50       	mov    0x50(%rsp),%rax
  a69930:	48 8b 4c 24 58       	mov    0x58(%rsp),%rcx
  a69935:	48 8b 54 24 60       	mov    0x60(%rsp),%rdx
  a6993a:	48 89 53 38          	mov    %rdx,0x38(%rbx)
  a6993e:	48 8b 54 24 68       	mov    0x68(%rsp),%rdx
  a69943:	48 89 53 40          	mov    %rdx,0x40(%rbx)
  a69947:	48 89 43 28          	mov    %rax,0x28(%rbx)
  a6994b:	48 89 4b 30          	mov    %rcx,0x30(%rbx)
  a6994f:	0f 11 43 18          	movups %xmm0,0x18(%rbx)
  a69953:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  a69958:	0f 57 c0             	xorps  %xmm0,%xmm0
  a6995b:	0f 11 43 50          	movups %xmm0,0x50(%rbx)
  a6995f:	48 89 43 60          	mov    %rax,0x60(%rbx)
  a69963:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  a69968:	48 85 c0             	test   %rax,%rax
  a6996b:	74 18                	je     a69985 <gpui::native::accessibility::project+0x435>
  a6996d:	48 8b 7c 24 30       	mov    0x30(%rsp),%rdi
  a69972:	48 c1 e0 03          	shl    $0x3,%rax
  a69976:	48 8d 34 40          	lea    (%rax,%rax,2),%rsi
  a6997a:	ba 08 00 00 00       	mov    $0x8,%edx
  a6997f:	ff 15 eb 5f ac 00    	call   *0xac5feb(%rip)        # 152f970 <_DYNAMIC+0x250>
  a69985:	48 89 d8             	mov    %rbx,%rax
  a69988:	48 81 c4 58 01 00 00 	add    $0x158,%rsp
  a6998f:	5b                   	pop    %rbx
  a69990:	41 5c                	pop    %r12
  a69992:	41 5d                	pop    %r13
  a69994:	41 5e                	pop    %r14
  a69996:	41 5f                	pop    %r15
  a69998:	5d                   	pop    %rbp
  a69999:	c3                   	ret
  a6999a:	48 85 db             	test   %rbx,%rbx
  a6999d:	74 10                	je     a699af <gpui::native::accessibility::project+0x45f>
  a6999f:	48 89 d8             	mov    %rbx,%rax
  a699a2:	48 c1 e0 07          	shl    $0x7,%rax
  a699a6:	4c 8d 24 d8          	lea    (%rax,%rbx,8),%r12
  a699aa:	e9 7b fd ff ff       	jmp    a6972a <gpui::native::accessibility::project+0x1da>
  a699af:	bf 08 00 00 00       	mov    $0x8,%edi
  a699b4:	31 db                	xor    %ebx,%ebx
  a699b6:	e9 90 fd ff ff       	jmp    a6974b <gpui::native::accessibility::project+0x1fb>
  a699bb:	bf 01 00 00 00       	mov    $0x1,%edi
  a699c0:	4c 89 f6             	mov    %r14,%rsi
  a699c3:	ff 15 8f 60 ac 00    	call   *0xac608f(%rip)        # 152fa58 <_DYNAMIC+0x338>
  a699c9:	0f 0b                	ud2
  a699cb:	48 89 c3             	mov    %rax,%rbx
  a699ce:	48 8d 7c 24 40       	lea    0x40(%rsp),%rdi
  a699d3:	e8 68 cc ff ff       	call   a66640 <core::ptr::drop_glue::<(accesskit::NodeId, accesskit::Node)>>
  a699d8:	eb 3a                	jmp    a69a14 <gpui::native::accessibility::project+0x4c4>
  a699da:	ff 15 c8 5f ac 00    	call   *0xac5fc8(%rip)        # 152f9a8 <_DYNAMIC+0x288>
  a699e0:	48 89 c3             	mov    %rax,%rbx
  a699e3:	eb 0d                	jmp    a699f2 <gpui::native::accessibility::project+0x4a2>
  a699e5:	48 89 c3             	mov    %rax,%rbx
  a699e8:	48 8d 7c 24 40       	lea    0x40(%rsp),%rdi
  a699ed:	e8 6e bf ff ff       	call   a65960 <core::ptr::drop_glue::<accesskit::TreeInfo>>
  a699f2:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  a699f7:	48 85 c0             	test   %rax,%rax
  a699fa:	74 18                	je     a69a14 <gpui::native::accessibility::project+0x4c4>
  a699fc:	48 8b 7c 24 30       	mov    0x30(%rsp),%rdi
  a69a01:	48 c1 e0 03          	shl    $0x3,%rax
  a69a05:	48 8d 34 40          	lea    (%rax,%rax,2),%rsi
  a69a09:	ba 08 00 00 00       	mov    $0x8,%edx
  a69a0e:	ff 15 5c 5f ac 00    	call   *0xac5f5c(%rip)        # 152f970 <_DYNAMIC+0x250>
  a69a14:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  a69a19:	e8 b2 bc ff ff       	call   a656d0 <core::ptr::drop_glue::<alloc::vec::Vec<(accesskit::NodeId, accesskit::Node)>>>
  a69a1e:	eb 12                	jmp    a69a32 <gpui::native::accessibility::project+0x4e2>
  a69a20:	eb 00                	jmp    a69a22 <gpui::native::accessibility::project+0x4d2>
  a69a22:	48 89 c3             	mov    %rax,%rbx
  a69a25:	48 8d bc 24 d8 00 00 	lea    0xd8(%rsp),%rdi
  a69a2c:	00 
  a69a2d:	e8 5e be ff ff       	call   a65890 <core::ptr::drop_glue::<accesskit::Node>>
  a69a32:	48 89 df             	mov    %rbx,%rdi
  a69a35:	e8 36 08 a5 00       	call   14ba270 <_Unwind_Resume@plt>
  a69a3a:	ff 15 68 5f ac 00    	call   *0xac5f68(%rip)        # 152f9a8 <_DYNAMIC+0x288>
