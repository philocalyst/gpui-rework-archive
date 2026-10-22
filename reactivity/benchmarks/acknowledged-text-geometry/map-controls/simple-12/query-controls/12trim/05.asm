
/tmp/gpui-text-map-query-controls/12trim/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

0000000000661760 <<gpui_canvas::text::layout::TextGeometry>::move_visual>:
  661760:	55                   	push   %rbp
  661761:	41 57                	push   %r15
  661763:	41 56                	push   %r14
  661765:	41 55                	push   %r13
  661767:	41 54                	push   %r12
  661769:	53                   	push   %rbx
  66176a:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  661771:	48 83 7f 30 ff       	cmpq   $0xffffffffffffffff,0x30(%rdi)
  661776:	0f 84 41 01 00 00    	je     6618bd <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x15d>
  66177c:	41 89 d0             	mov    %edx,%r8d
  66177f:	89 f5                	mov    %esi,%ebp
  661781:	48 89 fb             	mov    %rdi,%rbx
  661784:	4c 8b 7f 38          	mov    0x38(%rdi),%r15
  661788:	4c 8b 77 40          	mov    0x40(%rdi),%r14
  66178c:	4c 89 f0             	mov    %r14,%rax
  66178f:	4d 85 f6             	test   %r14,%r14
  661792:	74 37                	je     6617cb <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x6b>
  661794:	31 c0                	xor    %eax,%eax
  661796:	49 83 fe 01          	cmp    $0x1,%r14
  66179a:	74 23                	je     6617bf <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x5f>
  66179c:	4d 89 f1             	mov    %r14,%r9
  66179f:	90                   	nop
  6617a0:	4c 89 ca             	mov    %r9,%rdx
  6617a3:	48 d1 ea             	shr    $1,%rdx
  6617a6:	48 8d 34 02          	lea    (%rdx,%rax,1),%rsi
  6617aa:	48 8d 3c 76          	lea    (%rsi,%rsi,2),%rdi
  6617ae:	41 39 2c bf          	cmp    %ebp,(%r15,%rdi,4)
  6617b2:	48 0f 42 c6          	cmovb  %rsi,%rax
  6617b6:	49 29 d1             	sub    %rdx,%r9
  6617b9:	49 83 f9 01          	cmp    $0x1,%r9
  6617bd:	77 e1                	ja     6617a0 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x40>
  6617bf:	48 8d 14 40          	lea    (%rax,%rax,2),%rdx
  6617c3:	41 39 2c 97          	cmp    %ebp,(%r15,%rdx,4)
  6617c7:	48 83 d0 00          	adc    $0x0,%rax
  6617cb:	41 8d 78 01          	lea    0x1(%r8),%edi
  6617cf:	48 c1 e0 02          	shl    $0x2,%rax
  6617d3:	48 8d 14 40          	lea    (%rax,%rax,2),%rdx
  6617d7:	49 8d 34 17          	lea    (%r15,%rdx,1),%rsi
  6617db:	48 83 c6 f4          	add    $0xfffffffffffffff4,%rsi
  6617df:	4a 8d 04 b5 00 00 00 	lea    0x0(,%r14,4),%rax
  6617e6:	00 
  6617e7:	48 8d 04 40          	lea    (%rax,%rax,2),%rax
  6617eb:	48 29 d0             	sub    %rdx,%rax
  6617ee:	66 90                	xchg   %ax,%ax
  6617f0:	48 85 c0             	test   %rax,%rax
  6617f3:	0f 84 c4 00 00 00    	je     6618bd <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x15d>
  6617f9:	39 6e 0c             	cmp    %ebp,0xc(%rsi)
  6617fc:	0f 85 bb 00 00 00    	jne    6618bd <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x15d>
  661802:	48 8d 56 0c          	lea    0xc(%rsi),%rdx
  661806:	48 83 c0 f4          	add    $0xfffffffffffffff4,%rax
  66180a:	40 84 7e 14          	test   %dil,0x14(%rsi)
  66180e:	48 89 d6             	mov    %rdx,%rsi
  661811:	74 dd                	je     6617f0 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x90>
  661813:	89 4c 24 14          	mov    %ecx,0x14(%rsp)
  661817:	48 8d 7c 24 44       	lea    0x44(%rsp),%rdi
  66181c:	48 89 de             	mov    %rbx,%rsi
  66181f:	4d 89 c4             	mov    %r8,%r12
  661822:	ff 15 20 5e 12 00    	call   *0x125e20(%rip)        # 787648 <_DYNAMIC+0x398>
  661828:	f3 0f 10 44 24 44    	movss  0x44(%rsp),%xmm0
  66182e:	f3 0f 11 44 24 10    	movss  %xmm0,0x10(%rsp)
  661834:	4c 89 64 24 30       	mov    %r12,0x30(%rsp)
  661839:	41 0f b6 d4          	movzbl %r12b,%edx
  66183d:	48 89 df             	mov    %rbx,%rdi
  661840:	89 ee                	mov    %ebp,%esi
  661842:	ff 15 60 5e 12 00    	call   *0x125e60(%rip)        # 7876a8 <_DYNAMIC+0x3f8>
  661848:	a8 01                	test   $0x1,%al
  66184a:	74 71                	je     6618bd <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x15d>
  66184c:	48 89 d7             	mov    %rdx,%rdi
  66184f:	48 8b 43 28          	mov    0x28(%rbx),%rax
  661853:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  661858:	48 39 c2             	cmp    %rax,%rdx
  66185b:	0f 83 c8 03 00 00    	jae    661c29 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x4c9>
  661861:	48 8b 43 20          	mov    0x20(%rbx),%rax
  661865:	48 89 7c 24 18       	mov    %rdi,0x18(%rsp)
  66186a:	48 8d 0c 7f          	lea    (%rdi,%rdi,2),%rcx
  66186e:	8b 34 c8             	mov    (%rax,%rcx,8),%esi
  661871:	85 f6                	test   %esi,%esi
  661873:	74 5c                	je     6618d1 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x171>
  661875:	4c 89 f2             	mov    %r14,%rdx
  661878:	4d 85 f6             	test   %r14,%r14
  66187b:	74 56                	je     6618d3 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x173>
  66187d:	31 d2                	xor    %edx,%edx
  66187f:	49 83 fe 01          	cmp    $0x1,%r14
  661883:	74 2a                	je     6618af <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x14f>
  661885:	4c 89 f7             	mov    %r14,%rdi
  661888:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  66188f:	00 
  661890:	49 89 f8             	mov    %rdi,%r8
  661893:	49 d1 e8             	shr    $1,%r8
  661896:	4d 8d 0c 10          	lea    (%r8,%rdx,1),%r9
  66189a:	4f 8d 14 49          	lea    (%r9,%r9,2),%r10
  66189e:	43 39 34 97          	cmp    %esi,(%r15,%r10,4)
  6618a2:	49 0f 42 d1          	cmovb  %r9,%rdx
  6618a6:	4c 29 c7             	sub    %r8,%rdi
  6618a9:	48 83 ff 01          	cmp    $0x1,%rdi
  6618ad:	77 e1                	ja     661890 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x130>
  6618af:	48 8d 3c 52          	lea    (%rdx,%rdx,2),%rdi
  6618b3:	41 39 34 bf          	cmp    %esi,(%r15,%rdi,4)
  6618b7:	48 83 d2 00          	adc    $0x0,%rdx
  6618bb:	eb 16                	jmp    6618d3 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x173>
  6618bd:	b2 02                	mov    $0x2,%dl
  6618bf:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  6618c6:	5b                   	pop    %rbx
  6618c7:	41 5c                	pop    %r12
  6618c9:	41 5d                	pop    %r13
  6618cb:	41 5e                	pop    %r14
  6618cd:	41 5f                	pop    %r15
  6618cf:	5d                   	pop    %rbp
  6618d0:	c3                   	ret
  6618d1:	31 d2                	xor    %edx,%edx
  6618d3:	48 8d 04 c8          	lea    (%rax,%rcx,8),%rax
  6618d7:	48 89 44 24 38       	mov    %rax,0x38(%rsp)
  6618dc:	49 29 d6             	sub    %rdx,%r14
  6618df:	48 8d 04 52          	lea    (%rdx,%rdx,2),%rax
  6618e3:	4d 8d 2c 87          	lea    (%r15,%rax,4),%r13
  6618e7:	f3 0f 10 43 4c       	movss  0x4c(%rbx),%xmm0
  6618ec:	f3 0f 59 05 d4 bb 9b 	mulss  -0x64442c(%rip),%xmm0        # 1d4c8 <GCC_except_table0+0x94>
  6618f3:	ff 
  6618f4:	f3 0f 11 44 24 24    	movss  %xmm0,0x24(%rsp)
  6618fa:	f3 0f 10 05 f6 bb 9b 	movss  -0x64440a(%rip),%xmm0        # 1d4f8 <GCC_except_table0+0xc4>
  661901:	ff 
  661902:	f3 0f 11 44 24 08    	movss  %xmm0,0x8(%rsp)
  661908:	b0 02                	mov    $0x2,%al
  66190a:	89 44 24 0c          	mov    %eax,0xc(%rsp)
  66190e:	31 f6                	xor    %esi,%esi
  661910:	4d 89 f7             	mov    %r14,%r15
  661913:	4d 89 ec             	mov    %r13,%r12
  661916:	eb 0b                	jmp    661923 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x1c3>
  661918:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  66191f:	00 
  661920:	40 b6 01             	mov    $0x1,%sil
  661923:	4c 89 e0             	mov    %r12,%rax
  661926:	4c 89 ea             	mov    %r13,%rdx
  661929:	4c 89 f9             	mov    %r15,%rcx
  66192c:	49 83 ff 01          	cmp    $0x1,%r15
  661930:	74 33                	je     661965 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x205>
  661932:	4d 85 ff             	test   %r15,%r15
  661935:	0f 84 4f 02 00 00    	je     661b8a <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x42a>
  66193b:	8b 38                	mov    (%rax),%edi
  66193d:	4c 8d 40 0c          	lea    0xc(%rax),%r8
  661941:	4d 8d 4f 01          	lea    0x1(%r15),%r9
  661945:	b9 01 00 00 00       	mov    $0x1,%ecx
  66194a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  661950:	41 3b 38             	cmp    (%r8),%edi
  661953:	75 10                	jne    661965 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x205>
  661955:	48 ff c1             	inc    %rcx
  661958:	49 83 c0 0c          	add    $0xc,%r8
  66195c:	49 ff c9             	dec    %r9
  66195f:	49 83 f9 02          	cmp    $0x2,%r9
  661963:	77 eb                	ja     661950 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x1f0>
  661965:	49 29 cf             	sub    %rcx,%r15
  661968:	0f 82 93 02 00 00    	jb     661c01 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x4a1>
  66196e:	40 f6 c6 01          	test   $0x1,%sil
  661972:	0f 84 73 01 00 00    	je     661aeb <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x38b>
  661978:	4c 89 f6             	mov    %r14,%rsi
  66197b:	49 83 fe 01          	cmp    $0x1,%r14
  66197f:	74 34                	je     6619b5 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x255>
  661981:	4d 85 f6             	test   %r14,%r14
  661984:	0f 84 00 02 00 00    	je     661b8a <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x42a>
  66198a:	8b 3a                	mov    (%rdx),%edi
  66198c:	4c 8d 42 0c          	lea    0xc(%rdx),%r8
  661990:	4d 8d 4e 01          	lea    0x1(%r14),%r9
  661994:	be 01 00 00 00       	mov    $0x1,%esi
  661999:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  6619a0:	41 3b 38             	cmp    (%r8),%edi
  6619a3:	75 10                	jne    6619b5 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x255>
  6619a5:	48 ff c6             	inc    %rsi
  6619a8:	49 83 c0 0c          	add    $0xc,%r8
  6619ac:	49 ff c9             	dec    %r9
  6619af:	49 83 f9 02          	cmp    $0x2,%r9
  6619b3:	77 eb                	ja     6619a0 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x240>
  6619b5:	49 29 f6             	sub    %rsi,%r14
  6619b8:	0f 82 43 02 00 00    	jb     661c01 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x4a1>
  6619be:	48 8d 3c 76          	lea    (%rsi,%rsi,2),%rdi
  6619c2:	4c 8d 2c ba          	lea    (%rdx,%rdi,4),%r13
  6619c6:	48 8d 3c 49          	lea    (%rcx,%rcx,2),%rdi
  6619ca:	4c 8d 24 b8          	lea    (%rax,%rdi,4),%r12
  6619ce:	48 89 44 24 78       	mov    %rax,0x78(%rsp)
  6619d3:	48 89 8c 24 80 00 00 	mov    %rcx,0x80(%rsp)
  6619da:	00 
  6619db:	48 89 94 24 88 00 00 	mov    %rdx,0x88(%rsp)
  6619e2:	00 
  6619e3:	48 89 b4 24 90 00 00 	mov    %rsi,0x90(%rsp)
  6619ea:	00 
  6619eb:	48 8d 7c 24 40       	lea    0x40(%rsp),%rdi
  6619f0:	48 89 de             	mov    %rbx,%rsi
  6619f3:	f3 0f 10 44 24 24    	movss  0x24(%rsp),%xmm0
  6619f9:	48 8d 54 24 78       	lea    0x78(%rsp),%rdx
  6619fe:	e8 ad fa ff ff       	call   6614b0 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1}>
  661a03:	0f b6 4c 24 44       	movzbl 0x44(%rsp),%ecx
  661a08:	80 f9 02             	cmp    $0x2,%cl
  661a0b:	0f 84 0f ff ff ff    	je     661920 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x1c0>
  661a11:	8b 44 24 40          	mov    0x40(%rsp),%eax
  661a15:	48 8b 54 24 38       	mov    0x38(%rsp),%rdx
  661a1a:	3b 42 04             	cmp    0x4(%rdx),%eax
  661a1d:	0f 87 67 01 00 00    	ja     661b8a <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x42a>
  661a23:	48 8b 54 24 18       	mov    0x18(%rsp),%rdx
  661a28:	48 39 54 24 60       	cmp    %rdx,0x60(%rsp)
  661a2d:	0f 85 ed fe ff ff    	jne    661920 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x1c0>
  661a33:	f6 44 24 70 01       	testb  $0x1,0x70(%rsp)
  661a38:	0f 85 e2 fe ff ff    	jne    661920 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x1c0>
  661a3e:	f3 0f 10 44 24 68    	movss  0x68(%rsp),%xmm0
  661a44:	f3 0f 10 4c 24 6c    	movss  0x6c(%rsp),%xmm1
  661a4a:	8b 7c 24 14          	mov    0x14(%rsp),%edi
  661a4e:	40 84 ff             	test   %dil,%dil
  661a51:	74 23                	je     661a76 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x316>
  661a53:	0f 28 d8             	movaps %xmm0,%xmm3
  661a56:	f3 0f 5f d9          	maxss  %xmm1,%xmm3
  661a5a:	0f 28 d3             	movaps %xmm3,%xmm2
  661a5d:	f3 0f c2 d3 03       	cmpunordss %xmm3,%xmm2
  661a62:	0f 28 e2             	movaps %xmm2,%xmm4
  661a65:	0f 55 e3             	andnps %xmm3,%xmm4
  661a68:	0f 54 d0             	andps  %xmm0,%xmm2
  661a6b:	0f 56 d4             	orps   %xmm4,%xmm2
  661a6e:	f3 0f 5c 54 24 10    	subss  0x10(%rsp),%xmm2
  661a74:	eb 25                	jmp    661a9b <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x33b>
  661a76:	0f 28 d0             	movaps %xmm0,%xmm2
  661a79:	f3 0f 5d d1          	minss  %xmm1,%xmm2
  661a7d:	0f 28 da             	movaps %xmm2,%xmm3
  661a80:	f3 0f c2 da 03       	cmpunordss %xmm2,%xmm3
  661a85:	0f 28 e3             	movaps %xmm3,%xmm4
  661a88:	0f 55 e2             	andnps %xmm2,%xmm4
  661a8b:	0f 54 d8             	andps  %xmm0,%xmm3
  661a8e:	0f 56 dc             	orps   %xmm4,%xmm3
  661a91:	f3 0f 10 54 24 10    	movss  0x10(%rsp),%xmm2
  661a97:	f3 0f 5c d3          	subss  %xmm3,%xmm2
  661a9b:	0f 57 db             	xorps  %xmm3,%xmm3
  661a9e:	0f 2e d3             	ucomiss %xmm3,%xmm2
  661aa1:	40 b6 01             	mov    $0x1,%sil
  661aa4:	0f 86 79 fe ff ff    	jbe    661923 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x1c3>
  661aaa:	f3 0f 10 5c 24 08    	movss  0x8(%rsp),%xmm3
  661ab0:	0f 2e da             	ucomiss %xmm2,%xmm3
  661ab3:	0f 86 6a fe ff ff    	jbe    661923 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x1c3>
  661ab9:	0f 2e c8             	ucomiss %xmm0,%xmm1
  661abc:	0f 96 c2             	setbe  %dl
  661abf:	40 30 fa             	xor    %dil,%dl
  661ac2:	0f 45 44 24 48       	cmovne 0x48(%rsp),%eax
  661ac7:	0f b6 54 24 4c       	movzbl 0x4c(%rsp),%edx
  661acc:	0f b6 c9             	movzbl %cl,%ecx
  661acf:	0f 45 ca             	cmovne %edx,%ecx
  661ad2:	80 e1 01             	and    $0x1,%cl
  661ad5:	89 4c 24 0c          	mov    %ecx,0xc(%rsp)
  661ad9:	40 b6 01             	mov    $0x1,%sil
  661adc:	89 44 24 20          	mov    %eax,0x20(%rsp)
  661ae0:	f3 0f 11 54 24 08    	movss  %xmm2,0x8(%rsp)
  661ae6:	e9 38 fe ff ff       	jmp    661923 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x1c3>
  661aeb:	4d 89 f1             	mov    %r14,%r9
  661aee:	49 83 fe 01          	cmp    $0x1,%r14
  661af2:	74 2d                	je     661b21 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x3c1>
  661af4:	4d 85 f6             	test   %r14,%r14
  661af7:	0f 84 8d 00 00 00    	je     661b8a <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x42a>
  661afd:	8b 32                	mov    (%rdx),%esi
  661aff:	48 8d 7a 0c          	lea    0xc(%rdx),%rdi
  661b03:	4d 8d 46 01          	lea    0x1(%r14),%r8
  661b07:	41 b9 01 00 00 00    	mov    $0x1,%r9d
  661b0d:	3b 37                	cmp    (%rdi),%esi
  661b0f:	75 10                	jne    661b21 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x3c1>
  661b11:	49 ff c1             	inc    %r9
  661b14:	48 83 c7 0c          	add    $0xc,%rdi
  661b18:	49 ff c8             	dec    %r8
  661b1b:	49 83 f8 02          	cmp    $0x2,%r8
  661b1f:	77 ec                	ja     661b0d <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x3ad>
  661b21:	4c 89 f7             	mov    %r14,%rdi
  661b24:	4c 29 cf             	sub    %r9,%rdi
  661b27:	0f 82 d4 00 00 00    	jb     661c01 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x4a1>
  661b2d:	4f 8d 1c 49          	lea    (%r9,%r9,2),%r11
  661b31:	4e 8d 04 9a          	lea    (%rdx,%r11,4),%r8
  661b35:	48 89 fe             	mov    %rdi,%rsi
  661b38:	48 83 ff 01          	cmp    $0x1,%rdi
  661b3c:	74 30                	je     661b6e <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x40e>
  661b3e:	48 85 ff             	test   %rdi,%rdi
  661b41:	74 47                	je     661b8a <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x42a>
  661b43:	45 8b 10             	mov    (%r8),%r10d
  661b46:	4a 8d 14 9a          	lea    (%rdx,%r11,4),%rdx
  661b4a:	48 83 c2 0c          	add    $0xc,%rdx
  661b4e:	4d 29 ce             	sub    %r9,%r14
  661b51:	49 ff c6             	inc    %r14
  661b54:	be 01 00 00 00       	mov    $0x1,%esi
  661b59:	44 3b 12             	cmp    (%rdx),%r10d
  661b5c:	75 10                	jne    661b6e <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x40e>
  661b5e:	48 ff c6             	inc    %rsi
  661b61:	48 83 c2 0c          	add    $0xc,%rdx
  661b65:	49 ff ce             	dec    %r14
  661b68:	49 83 fe 02          	cmp    $0x2,%r14
  661b6c:	77 eb                	ja     661b59 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x3f9>
  661b6e:	48 29 f7             	sub    %rsi,%rdi
  661b71:	0f 82 8a 00 00 00    	jb     661c01 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x4a1>
  661b77:	48 8d 14 76          	lea    (%rsi,%rsi,2),%rdx
  661b7b:	4d 8d 2c 90          	lea    (%r8,%rdx,4),%r13
  661b7f:	49 89 fe             	mov    %rdi,%r14
  661b82:	4c 89 c2             	mov    %r8,%rdx
  661b85:	e9 3c fe ff ff       	jmp    6619c6 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x266>
  661b8a:	8b 54 24 0c          	mov    0xc(%rsp),%edx
  661b8e:	80 fa 02             	cmp    $0x2,%dl
  661b91:	8b 44 24 20          	mov    0x20(%rsp),%eax
  661b95:	0f 85 24 fd ff ff    	jne    6618bf <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x15f>
  661b9b:	80 7c 24 14 00       	cmpb   $0x0,0x14(%rsp)
  661ba0:	74 2b                	je     661bcd <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x46d>
  661ba2:	48 8b 74 24 18       	mov    0x18(%rsp),%rsi
  661ba7:	48 83 fe ff          	cmp    $0xffffffffffffffff,%rsi
  661bab:	48 8b 4c 24 30       	mov    0x30(%rsp),%rcx
  661bb0:	74 68                	je     661c1a <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x4ba>
  661bb2:	48 ff c6             	inc    %rsi
  661bb5:	31 c0                	xor    %eax,%eax
  661bb7:	48 3b 74 24 28       	cmp    0x28(%rsp),%rsi
  661bbc:	0f 92 c0             	setb   %al
  661bbf:	a8 01                	test   $0x1,%al
  661bc1:	74 5d                	je     661c20 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x4c0>
  661bc3:	f3 0f 10 05 39 b9 9b 	movss  -0x6446c7(%rip),%xmm0        # 1d504 <GCC_except_table0+0xd0>
  661bca:	ff 
  661bcb:	eb 27                	jmp    661bf4 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x494>
  661bcd:	48 8b 74 24 18       	mov    0x18(%rsp),%rsi
  661bd2:	48 85 f6             	test   %rsi,%rsi
  661bd5:	48 8b 4c 24 30       	mov    0x30(%rsp),%rcx
  661bda:	74 0a                	je     661be6 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x486>
  661bdc:	48 ff ce             	dec    %rsi
  661bdf:	b8 01 00 00 00       	mov    $0x1,%eax
  661be4:	eb 02                	jmp    661be8 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x488>
  661be6:	31 c0                	xor    %eax,%eax
  661be8:	a8 01                	test   $0x1,%al
  661bea:	74 34                	je     661c20 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x4c0>
  661bec:	f3 0f 10 05 fc b8 9b 	movss  -0x644704(%rip),%xmm0        # 1d4f0 <GCC_except_table0+0xbc>
  661bf3:	ff 
  661bf4:	48 89 df             	mov    %rbx,%rdi
  661bf7:	e8 44 00 00 00       	call   661c40 <<gpui_canvas::text::layout::TextGeometry>::position_on_line>
  661bfc:	e9 be fc ff ff       	jmp    6618bf <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x15f>
  661c01:	48 8d 3d 59 3b 9c ff 	lea    -0x63c4a7(%rip),%rdi        # 25761 <anon.510ecd5b06a31c5d706a3e62c051feab.3.llvm.15957366779061141188+0x9>
  661c08:	48 8d 15 d9 ac 11 00 	lea    0x11acd9(%rip),%rdx        # 77c8e8 <anon.b75840af67eff6c7867889150027a6c7.3.llvm.2112026857664668335+0x78>
  661c0f:	be 13 00 00 00       	mov    $0x13,%esi
  661c14:	ff 15 e6 58 12 00    	call   *0x1258e6(%rip)        # 787500 <_DYNAMIC+0x250>
  661c1a:	31 c0                	xor    %eax,%eax
  661c1c:	a8 01                	test   $0x1,%al
  661c1e:	75 a3                	jne    661bc3 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x463>
  661c20:	89 ca                	mov    %ecx,%edx
  661c22:	89 e8                	mov    %ebp,%eax
  661c24:	e9 96 fc ff ff       	jmp    6618bf <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x15f>
  661c29:	48 8d 15 a0 ac 11 00 	lea    0x11aca0(%rip),%rdx        # 77c8d0 <anon.b75840af67eff6c7867889150027a6c7.3.llvm.2112026857664668335+0x60>
  661c30:	48 8b 74 24 28       	mov    0x28(%rsp),%rsi
  661c35:	ff 15 15 5a 12 00    	call   *0x125a15(%rip)        # 787650 <_DYNAMIC+0x3a0>
