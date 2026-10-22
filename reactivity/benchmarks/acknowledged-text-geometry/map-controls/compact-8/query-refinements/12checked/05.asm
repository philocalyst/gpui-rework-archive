
/tmp/gpui-text-map-query-refinements/12checked/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

0000000000661710 <<gpui_canvas::text::layout::TextGeometry>::move_visual>:
  661710:	55                   	push   %rbp
  661711:	41 57                	push   %r15
  661713:	41 56                	push   %r14
  661715:	41 55                	push   %r13
  661717:	41 54                	push   %r12
  661719:	53                   	push   %rbx
  66171a:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  661721:	48 89 7c 24 08       	mov    %rdi,0x8(%rsp)
  661726:	48 83 7f 30 ff       	cmpq   $0xffffffffffffffff,0x30(%rdi)
  66172b:	0f 84 2b 01 00 00    	je     66185c <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x14c>
  661731:	41 89 d4             	mov    %edx,%r12d
  661734:	89 f5                	mov    %esi,%ebp
  661736:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  66173b:	4c 8b 78 38          	mov    0x38(%rax),%r15
  66173f:	4c 8b 70 40          	mov    0x40(%rax),%r14
  661743:	4c 89 f0             	mov    %r14,%rax
  661746:	4d 85 f6             	test   %r14,%r14
  661749:	74 40                	je     66178b <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x7b>
  66174b:	31 c0                	xor    %eax,%eax
  66174d:	49 83 fe 01          	cmp    $0x1,%r14
  661751:	74 2c                	je     66177f <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x6f>
  661753:	4d 89 f0             	mov    %r14,%r8
  661756:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  66175d:	00 00 00 
  661760:	4c 89 c2             	mov    %r8,%rdx
  661763:	48 d1 ea             	shr    $1,%rdx
  661766:	48 8d 34 02          	lea    (%rdx,%rax,1),%rsi
  66176a:	48 8d 3c 76          	lea    (%rsi,%rsi,2),%rdi
  66176e:	41 39 2c bf          	cmp    %ebp,(%r15,%rdi,4)
  661772:	48 0f 42 c6          	cmovb  %rsi,%rax
  661776:	49 29 d0             	sub    %rdx,%r8
  661779:	49 83 f8 01          	cmp    $0x1,%r8
  66177d:	77 e1                	ja     661760 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x50>
  66177f:	48 8d 14 40          	lea    (%rax,%rax,2),%rdx
  661783:	41 39 2c 97          	cmp    %ebp,(%r15,%rdx,4)
  661787:	48 83 d0 00          	adc    $0x0,%rax
  66178b:	41 8d 7c 24 01       	lea    0x1(%r12),%edi
  661790:	48 c1 e0 02          	shl    $0x2,%rax
  661794:	48 8d 14 40          	lea    (%rax,%rax,2),%rdx
  661798:	49 8d 34 17          	lea    (%r15,%rdx,1),%rsi
  66179c:	48 83 c6 f4          	add    $0xfffffffffffffff4,%rsi
  6617a0:	4a 8d 04 b5 00 00 00 	lea    0x0(,%r14,4),%rax
  6617a7:	00 
  6617a8:	48 8d 04 40          	lea    (%rax,%rax,2),%rax
  6617ac:	48 29 d0             	sub    %rdx,%rax
  6617af:	90                   	nop
  6617b0:	48 85 c0             	test   %rax,%rax
  6617b3:	0f 84 a3 00 00 00    	je     66185c <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x14c>
  6617b9:	39 6e 0c             	cmp    %ebp,0xc(%rsi)
  6617bc:	0f 85 9a 00 00 00    	jne    66185c <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x14c>
  6617c2:	48 8d 56 0c          	lea    0xc(%rsi),%rdx
  6617c6:	48 83 c0 f4          	add    $0xfffffffffffffff4,%rax
  6617ca:	40 84 7e 14          	test   %dil,0x14(%rsi)
  6617ce:	48 89 d6             	mov    %rdx,%rsi
  6617d1:	74 dd                	je     6617b0 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0xa0>
  6617d3:	89 4c 24 04          	mov    %ecx,0x4(%rsp)
  6617d7:	48 8d 7c 24 44       	lea    0x44(%rsp),%rdi
  6617dc:	48 8b 5c 24 08       	mov    0x8(%rsp),%rbx
  6617e1:	48 89 de             	mov    %rbx,%rsi
  6617e4:	ff 15 ce 5c 12 00    	call   *0x125cce(%rip)        # 7874b8 <_DYNAMIC+0x398>
  6617ea:	85 ed                	test   %ebp,%ebp
  6617ec:	0f 95 c1             	setne  %cl
  6617ef:	4c 89 64 24 30       	mov    %r12,0x30(%rsp)
  6617f4:	44 89 e2             	mov    %r12d,%edx
  6617f7:	f6 d2                	not    %dl
  6617f9:	48 8b 43 20          	mov    0x20(%rbx),%rax
  6617fd:	48 8b 73 28          	mov    0x28(%rbx),%rsi
  661801:	49 89 f5             	mov    %rsi,%r13
  661804:	84 ca                	test   %cl,%dl
  661806:	75 68                	jne    661870 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x160>
  661808:	48 85 f6             	test   %rsi,%rsi
  66180b:	0f 84 bc 00 00 00    	je     6618cd <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x1bd>
  661811:	31 c9                	xor    %ecx,%ecx
  661813:	48 83 fe 01          	cmp    $0x1,%rsi
  661817:	74 28                	je     661841 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x131>
  661819:	48 89 f2             	mov    %rsi,%rdx
  66181c:	0f 1f 40 00          	nopl   0x0(%rax)
  661820:	49 89 c9             	mov    %rcx,%r9
  661823:	48 89 d7             	mov    %rdx,%rdi
  661826:	48 d1 ef             	shr    $1,%rdi
  661829:	48 01 f9             	add    %rdi,%rcx
  66182c:	4c 8d 04 49          	lea    (%rcx,%rcx,2),%r8
  661830:	42 39 2c c0          	cmp    %ebp,(%rax,%r8,8)
  661834:	49 0f 47 c9          	cmova  %r9,%rcx
  661838:	48 29 fa             	sub    %rdi,%rdx
  66183b:	48 83 fa 01          	cmp    $0x1,%rdx
  66183f:	77 df                	ja     661820 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x110>
  661841:	48 8d 14 49          	lea    (%rcx,%rcx,2),%rdx
  661845:	45 31 ed             	xor    %r13d,%r13d
  661848:	39 2c d0             	cmp    %ebp,(%rax,%rdx,8)
  66184b:	41 0f 96 c5          	setbe  %r13b
  66184f:	49 01 cd             	add    %rcx,%r13
  661852:	49 83 fd 01          	cmp    $0x1,%r13
  661856:	49 83 d5 ff          	adc    $0xffffffffffffffff,%r13
  66185a:	eb 71                	jmp    6618cd <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x1bd>
  66185c:	b2 02                	mov    $0x2,%dl
  66185e:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  661865:	5b                   	pop    %rbx
  661866:	41 5c                	pop    %r12
  661868:	41 5d                	pop    %r13
  66186a:	41 5e                	pop    %r14
  66186c:	41 5f                	pop    %r15
  66186e:	5d                   	pop    %rbp
  66186f:	c3                   	ret
  661870:	48 85 f6             	test   %rsi,%rsi
  661873:	74 4d                	je     6618c2 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x1b2>
  661875:	45 31 ed             	xor    %r13d,%r13d
  661878:	48 83 fe 01          	cmp    $0x1,%rsi
  66187c:	74 31                	je     6618af <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x19f>
  66187e:	48 89 f1             	mov    %rsi,%rcx
  661881:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  661888:	0f 1f 84 00 00 00 00 
  66188f:	00 
  661890:	48 89 ca             	mov    %rcx,%rdx
  661893:	48 d1 ea             	shr    $1,%rdx
  661896:	4e 8d 04 2a          	lea    (%rdx,%r13,1),%r8
  66189a:	4b 8d 3c 40          	lea    (%r8,%r8,2),%rdi
  66189e:	39 6c f8 04          	cmp    %ebp,0x4(%rax,%rdi,8)
  6618a2:	4d 0f 42 e8          	cmovb  %r8,%r13
  6618a6:	48 29 d1             	sub    %rdx,%rcx
  6618a9:	48 83 f9 01          	cmp    $0x1,%rcx
  6618ad:	77 e1                	ja     661890 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x180>
  6618af:	4a 8d 0c 6d 00 00 00 	lea    0x0(,%r13,2),%rcx
  6618b6:	00 
  6618b7:	4c 01 e9             	add    %r13,%rcx
  6618ba:	39 6c c8 04          	cmp    %ebp,0x4(%rax,%rcx,8)
  6618be:	49 83 d5 00          	adc    $0x0,%r13
  6618c2:	48 8d 4e ff          	lea    -0x1(%rsi),%rcx
  6618c6:	4c 39 e9             	cmp    %r13,%rcx
  6618c9:	4c 0f 42 e9          	cmovb  %rcx,%r13
  6618cd:	49 39 f5             	cmp    %rsi,%r13
  6618d0:	0f 83 a5 03 00 00    	jae    661c7b <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x56b>
  6618d6:	4a 8d 0c 6d 00 00 00 	lea    0x0(,%r13,2),%rcx
  6618dd:	00 
  6618de:	4c 01 e9             	add    %r13,%rcx
  6618e1:	44 8b 1c c8          	mov    (%rax,%rcx,8),%r11d
  6618e5:	45 85 db             	test   %r11d,%r11d
  6618e8:	74 43                	je     66192d <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x21d>
  6618ea:	4c 89 f2             	mov    %r14,%rdx
  6618ed:	4d 85 f6             	test   %r14,%r14
  6618f0:	74 3d                	je     66192f <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x21f>
  6618f2:	31 d2                	xor    %edx,%edx
  6618f4:	49 83 fe 01          	cmp    $0x1,%r14
  6618f8:	74 25                	je     66191f <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x20f>
  6618fa:	4c 89 f7             	mov    %r14,%rdi
  6618fd:	0f 1f 00             	nopl   (%rax)
  661900:	49 89 f8             	mov    %rdi,%r8
  661903:	49 d1 e8             	shr    $1,%r8
  661906:	4d 8d 0c 10          	lea    (%r8,%rdx,1),%r9
  66190a:	4f 8d 14 49          	lea    (%r9,%r9,2),%r10
  66190e:	47 39 1c 97          	cmp    %r11d,(%r15,%r10,4)
  661912:	49 0f 42 d1          	cmovb  %r9,%rdx
  661916:	4c 29 c7             	sub    %r8,%rdi
  661919:	48 83 ff 01          	cmp    $0x1,%rdi
  66191d:	77 e1                	ja     661900 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x1f0>
  66191f:	48 8d 3c 52          	lea    (%rdx,%rdx,2),%rdi
  661923:	45 39 1c bf          	cmp    %r11d,(%r15,%rdi,4)
  661927:	48 83 d2 00          	adc    $0x0,%rdx
  66192b:	eb 02                	jmp    66192f <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x21f>
  66192d:	31 d2                	xor    %edx,%edx
  66192f:	48 89 74 24 28       	mov    %rsi,0x28(%rsp)
  661934:	f3 0f 10 44 24 44    	movss  0x44(%rsp),%xmm0
  66193a:	f3 0f 11 44 24 18    	movss  %xmm0,0x18(%rsp)
  661940:	48 8d 04 c8          	lea    (%rax,%rcx,8),%rax
  661944:	48 89 44 24 38       	mov    %rax,0x38(%rsp)
  661949:	49 29 d6             	sub    %rdx,%r14
  66194c:	48 8d 04 52          	lea    (%rdx,%rdx,2),%rax
  661950:	49 8d 1c 87          	lea    (%r15,%rax,4),%rbx
  661954:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  661959:	f3 0f 10 40 4c       	movss  0x4c(%rax),%xmm0
  66195e:	f3 0f 59 05 62 bb 9b 	mulss  -0x64449e(%rip),%xmm0        # 1d4c8 <GCC_except_table0+0x88>
  661965:	ff 
  661966:	f3 0f 11 44 24 24    	movss  %xmm0,0x24(%rsp)
  66196c:	f3 0f 10 05 84 bb 9b 	movss  -0x64447c(%rip),%xmm0        # 1d4f8 <GCC_except_table0+0xb8>
  661973:	ff 
  661974:	f3 0f 11 44 24 14    	movss  %xmm0,0x14(%rsp)
  66197a:	b0 02                	mov    $0x2,%al
  66197c:	89 44 24 1c          	mov    %eax,0x1c(%rsp)
  661980:	31 f6                	xor    %esi,%esi
  661982:	4d 89 f7             	mov    %r14,%r15
  661985:	49 89 dc             	mov    %rbx,%r12
  661988:	eb 09                	jmp    661993 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x283>
  66198a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  661990:	40 b6 01             	mov    $0x1,%sil
  661993:	4c 89 e0             	mov    %r12,%rax
  661996:	48 89 da             	mov    %rbx,%rdx
  661999:	4c 89 f9             	mov    %r15,%rcx
  66199c:	49 83 ff 01          	cmp    $0x1,%r15
  6619a0:	74 33                	je     6619d5 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x2c5>
  6619a2:	4d 85 ff             	test   %r15,%r15
  6619a5:	0f 84 48 02 00 00    	je     661bf3 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x4e3>
  6619ab:	8b 38                	mov    (%rax),%edi
  6619ad:	4c 8d 40 0c          	lea    0xc(%rax),%r8
  6619b1:	4d 8d 4f 01          	lea    0x1(%r15),%r9
  6619b5:	b9 01 00 00 00       	mov    $0x1,%ecx
  6619ba:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  6619c0:	41 3b 38             	cmp    (%r8),%edi
  6619c3:	75 10                	jne    6619d5 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x2c5>
  6619c5:	48 ff c1             	inc    %rcx
  6619c8:	49 83 c0 0c          	add    $0xc,%r8
  6619cc:	49 ff c9             	dec    %r9
  6619cf:	49 83 f9 02          	cmp    $0x2,%r9
  6619d3:	77 eb                	ja     6619c0 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x2b0>
  6619d5:	49 29 cf             	sub    %rcx,%r15
  6619d8:	0f 82 84 02 00 00    	jb     661c62 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x552>
  6619de:	40 f6 c6 01          	test   $0x1,%sil
  6619e2:	0f 84 6c 01 00 00    	je     661b54 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x444>
  6619e8:	4c 89 f6             	mov    %r14,%rsi
  6619eb:	49 83 fe 01          	cmp    $0x1,%r14
  6619ef:	74 34                	je     661a25 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x315>
  6619f1:	4d 85 f6             	test   %r14,%r14
  6619f4:	0f 84 f9 01 00 00    	je     661bf3 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x4e3>
  6619fa:	8b 3a                	mov    (%rdx),%edi
  6619fc:	4c 8d 42 0c          	lea    0xc(%rdx),%r8
  661a00:	4d 8d 4e 01          	lea    0x1(%r14),%r9
  661a04:	be 01 00 00 00       	mov    $0x1,%esi
  661a09:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  661a10:	41 3b 38             	cmp    (%r8),%edi
  661a13:	75 10                	jne    661a25 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x315>
  661a15:	48 ff c6             	inc    %rsi
  661a18:	49 83 c0 0c          	add    $0xc,%r8
  661a1c:	49 ff c9             	dec    %r9
  661a1f:	49 83 f9 02          	cmp    $0x2,%r9
  661a23:	77 eb                	ja     661a10 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x300>
  661a25:	49 29 f6             	sub    %rsi,%r14
  661a28:	0f 82 34 02 00 00    	jb     661c62 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x552>
  661a2e:	48 8d 3c 76          	lea    (%rsi,%rsi,2),%rdi
  661a32:	48 8d 1c ba          	lea    (%rdx,%rdi,4),%rbx
  661a36:	48 8d 3c 49          	lea    (%rcx,%rcx,2),%rdi
  661a3a:	4c 8d 24 b8          	lea    (%rax,%rdi,4),%r12
  661a3e:	48 89 44 24 78       	mov    %rax,0x78(%rsp)
  661a43:	48 89 8c 24 80 00 00 	mov    %rcx,0x80(%rsp)
  661a4a:	00 
  661a4b:	48 89 94 24 88 00 00 	mov    %rdx,0x88(%rsp)
  661a52:	00 
  661a53:	48 89 b4 24 90 00 00 	mov    %rsi,0x90(%rsp)
  661a5a:	00 
  661a5b:	48 8d 7c 24 40       	lea    0x40(%rsp),%rdi
  661a60:	48 8b 74 24 08       	mov    0x8(%rsp),%rsi
  661a65:	f3 0f 10 44 24 24    	movss  0x24(%rsp),%xmm0
  661a6b:	48 8d 54 24 78       	lea    0x78(%rsp),%rdx
  661a70:	e8 eb f9 ff ff       	call   661460 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1}>
  661a75:	0f b6 4c 24 44       	movzbl 0x44(%rsp),%ecx
  661a7a:	80 f9 02             	cmp    $0x2,%cl
  661a7d:	0f 84 0d ff ff ff    	je     661990 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x280>
  661a83:	8b 44 24 40          	mov    0x40(%rsp),%eax
  661a87:	48 8b 54 24 38       	mov    0x38(%rsp),%rdx
  661a8c:	3b 42 04             	cmp    0x4(%rdx),%eax
  661a8f:	0f 87 5e 01 00 00    	ja     661bf3 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x4e3>
  661a95:	4c 39 6c 24 60       	cmp    %r13,0x60(%rsp)
  661a9a:	0f 85 f0 fe ff ff    	jne    661990 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x280>
  661aa0:	f6 44 24 70 01       	testb  $0x1,0x70(%rsp)
  661aa5:	0f 85 e5 fe ff ff    	jne    661990 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x280>
  661aab:	f3 0f 10 44 24 68    	movss  0x68(%rsp),%xmm0
  661ab1:	f3 0f 10 4c 24 6c    	movss  0x6c(%rsp),%xmm1
  661ab7:	80 7c 24 04 00       	cmpb   $0x0,0x4(%rsp)
  661abc:	74 23                	je     661ae1 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x3d1>
  661abe:	0f 28 d8             	movaps %xmm0,%xmm3
  661ac1:	f3 0f 5f d9          	maxss  %xmm1,%xmm3
  661ac5:	0f 28 d3             	movaps %xmm3,%xmm2
  661ac8:	f3 0f c2 d3 03       	cmpunordss %xmm3,%xmm2
  661acd:	0f 28 e2             	movaps %xmm2,%xmm4
  661ad0:	0f 55 e3             	andnps %xmm3,%xmm4
  661ad3:	0f 54 d0             	andps  %xmm0,%xmm2
  661ad6:	0f 56 d4             	orps   %xmm4,%xmm2
  661ad9:	f3 0f 5c 54 24 18    	subss  0x18(%rsp),%xmm2
  661adf:	eb 25                	jmp    661b06 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x3f6>
  661ae1:	0f 28 d0             	movaps %xmm0,%xmm2
  661ae4:	f3 0f 5d d1          	minss  %xmm1,%xmm2
  661ae8:	0f 28 da             	movaps %xmm2,%xmm3
  661aeb:	f3 0f c2 da 03       	cmpunordss %xmm2,%xmm3
  661af0:	0f 28 e3             	movaps %xmm3,%xmm4
  661af3:	0f 55 e2             	andnps %xmm2,%xmm4
  661af6:	0f 54 d8             	andps  %xmm0,%xmm3
  661af9:	0f 56 dc             	orps   %xmm4,%xmm3
  661afc:	f3 0f 10 54 24 18    	movss  0x18(%rsp),%xmm2
  661b02:	f3 0f 5c d3          	subss  %xmm3,%xmm2
  661b06:	0f 57 db             	xorps  %xmm3,%xmm3
  661b09:	0f 2e d3             	ucomiss %xmm3,%xmm2
  661b0c:	40 b6 01             	mov    $0x1,%sil
  661b0f:	0f 86 7e fe ff ff    	jbe    661993 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x283>
  661b15:	f3 0f 10 5c 24 14    	movss  0x14(%rsp),%xmm3
  661b1b:	0f 2e da             	ucomiss %xmm2,%xmm3
  661b1e:	0f 86 6f fe ff ff    	jbe    661993 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x283>
  661b24:	0f 2e c8             	ucomiss %xmm0,%xmm1
  661b27:	0f 96 c2             	setbe  %dl
  661b2a:	32 54 24 04          	xor    0x4(%rsp),%dl
  661b2e:	0f 45 44 24 48       	cmovne 0x48(%rsp),%eax
  661b33:	0f b6 54 24 4c       	movzbl 0x4c(%rsp),%edx
  661b38:	0f b6 c9             	movzbl %cl,%ecx
  661b3b:	0f 45 ca             	cmovne %edx,%ecx
  661b3e:	80 e1 01             	and    $0x1,%cl
  661b41:	89 4c 24 1c          	mov    %ecx,0x1c(%rsp)
  661b45:	f3 0f 11 54 24 14    	movss  %xmm2,0x14(%rsp)
  661b4b:	89 44 24 20          	mov    %eax,0x20(%rsp)
  661b4f:	e9 3f fe ff ff       	jmp    661993 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x283>
  661b54:	4d 89 f1             	mov    %r14,%r9
  661b57:	49 83 fe 01          	cmp    $0x1,%r14
  661b5b:	74 2d                	je     661b8a <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x47a>
  661b5d:	4d 85 f6             	test   %r14,%r14
  661b60:	0f 84 8d 00 00 00    	je     661bf3 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x4e3>
  661b66:	8b 32                	mov    (%rdx),%esi
  661b68:	48 8d 7a 0c          	lea    0xc(%rdx),%rdi
  661b6c:	4d 8d 46 01          	lea    0x1(%r14),%r8
  661b70:	41 b9 01 00 00 00    	mov    $0x1,%r9d
  661b76:	3b 37                	cmp    (%rdi),%esi
  661b78:	75 10                	jne    661b8a <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x47a>
  661b7a:	49 ff c1             	inc    %r9
  661b7d:	48 83 c7 0c          	add    $0xc,%rdi
  661b81:	49 ff c8             	dec    %r8
  661b84:	49 83 f8 02          	cmp    $0x2,%r8
  661b88:	77 ec                	ja     661b76 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x466>
  661b8a:	4c 89 f7             	mov    %r14,%rdi
  661b8d:	4c 29 cf             	sub    %r9,%rdi
  661b90:	0f 82 cc 00 00 00    	jb     661c62 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x552>
  661b96:	4f 8d 1c 49          	lea    (%r9,%r9,2),%r11
  661b9a:	4e 8d 04 9a          	lea    (%rdx,%r11,4),%r8
  661b9e:	48 89 fe             	mov    %rdi,%rsi
  661ba1:	48 83 ff 01          	cmp    $0x1,%rdi
  661ba5:	74 30                	je     661bd7 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x4c7>
  661ba7:	48 85 ff             	test   %rdi,%rdi
  661baa:	74 47                	je     661bf3 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x4e3>
  661bac:	45 8b 10             	mov    (%r8),%r10d
  661baf:	4a 8d 14 9a          	lea    (%rdx,%r11,4),%rdx
  661bb3:	48 83 c2 0c          	add    $0xc,%rdx
  661bb7:	4d 29 ce             	sub    %r9,%r14
  661bba:	49 ff c6             	inc    %r14
  661bbd:	be 01 00 00 00       	mov    $0x1,%esi
  661bc2:	44 3b 12             	cmp    (%rdx),%r10d
  661bc5:	75 10                	jne    661bd7 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x4c7>
  661bc7:	48 ff c6             	inc    %rsi
  661bca:	48 83 c2 0c          	add    $0xc,%rdx
  661bce:	49 ff ce             	dec    %r14
  661bd1:	49 83 fe 02          	cmp    $0x2,%r14
  661bd5:	77 eb                	ja     661bc2 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x4b2>
  661bd7:	48 29 f7             	sub    %rsi,%rdi
  661bda:	0f 82 82 00 00 00    	jb     661c62 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x552>
  661be0:	48 8d 14 76          	lea    (%rsi,%rsi,2),%rdx
  661be4:	49 8d 1c 90          	lea    (%r8,%rdx,4),%rbx
  661be8:	49 89 fe             	mov    %rdi,%r14
  661beb:	4c 89 c2             	mov    %r8,%rdx
  661bee:	e9 43 fe ff ff       	jmp    661a36 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x326>
  661bf3:	8b 54 24 1c          	mov    0x1c(%rsp),%edx
  661bf7:	80 fa 02             	cmp    $0x2,%dl
  661bfa:	8b 44 24 20          	mov    0x20(%rsp),%eax
  661bfe:	0f 85 5a fc ff ff    	jne    66185e <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x14e>
  661c04:	80 7c 24 04 00       	cmpb   $0x0,0x4(%rsp)
  661c09:	74 14                	je     661c1f <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x50f>
  661c0b:	49 ff c5             	inc    %r13
  661c0e:	4c 3b 6c 24 28       	cmp    0x28(%rsp),%r13
  661c13:	73 3f                	jae    661c54 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x544>
  661c15:	f3 0f 10 05 e7 b8 9b 	movss  -0x644719(%rip),%xmm0        # 1d504 <GCC_except_table0+0xc4>
  661c1c:	ff 
  661c1d:	eb 1b                	jmp    661c3a <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x52a>
  661c1f:	4d 85 ed             	test   %r13,%r13
  661c22:	74 28                	je     661c4c <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x53c>
  661c24:	49 ff cd             	dec    %r13
  661c27:	b8 01 00 00 00       	mov    $0x1,%eax
  661c2c:	48 83 f8 01          	cmp    $0x1,%rax
  661c30:	75 22                	jne    661c54 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x544>
  661c32:	f3 0f 10 05 b6 b8 9b 	movss  -0x64474a(%rip),%xmm0        # 1d4f0 <GCC_except_table0+0xb0>
  661c39:	ff 
  661c3a:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
  661c3f:	4c 89 ee             	mov    %r13,%rsi
  661c42:	e8 49 00 00 00       	call   661c90 <<gpui_canvas::text::layout::TextGeometry>::position_on_line>
  661c47:	e9 12 fc ff ff       	jmp    66185e <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x14e>
  661c4c:	31 c0                	xor    %eax,%eax
  661c4e:	48 83 f8 01          	cmp    $0x1,%rax
  661c52:	74 de                	je     661c32 <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x522>
  661c54:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  661c59:	89 c2                	mov    %eax,%edx
  661c5b:	89 e8                	mov    %ebp,%eax
  661c5d:	e9 fc fb ff ff       	jmp    66185e <<gpui_canvas::text::layout::TextGeometry>::move_visual+0x14e>
  661c62:	48 8d 3d f8 3a 9c ff 	lea    -0x63c508(%rip),%rdi        # 25761 <anon.510ecd5b06a31c5d706a3e62c051feab.3.llvm.15957366779061141188+0x9>
  661c69:	48 8d 15 e8 aa 11 00 	lea    0x11aae8(%rip),%rdx        # 77c758 <anon.0ce93d74e9d39703631c89632b12715b.3.llvm.7854699070981760621+0x78>
  661c70:	be 13 00 00 00       	mov    $0x13,%esi
  661c75:	ff 15 f5 56 12 00    	call   *0x1256f5(%rip)        # 787370 <_DYNAMIC+0x250>
  661c7b:	48 8d 15 be aa 11 00 	lea    0x11aabe(%rip),%rdx        # 77c740 <anon.0ce93d74e9d39703631c89632b12715b.3.llvm.7854699070981760621+0x60>
  661c82:	4c 89 ef             	mov    %r13,%rdi
  661c85:	ff 15 35 58 12 00    	call   *0x125835(%rip)        # 7874c0 <_DYNAMIC+0x3a0>
