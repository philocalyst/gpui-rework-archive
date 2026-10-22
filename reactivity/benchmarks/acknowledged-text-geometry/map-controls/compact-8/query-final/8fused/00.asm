
/tmp/gpui-text-map-query-final/8fused/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

0000000000660830 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>>:
  660830:	55                   	push   %rbp
  660831:	41 57                	push   %r15
  660833:	41 56                	push   %r14
  660835:	41 55                	push   %r13
  660837:	41 54                	push   %r12
  660839:	53                   	push   %rbx
  66083a:	48 81 ec 08 01 00 00 	sub    $0x108,%rsp
  660841:	48 89 54 24 58       	mov    %rdx,0x58(%rsp)
  660846:	49 89 f6             	mov    %rsi,%r14
  660849:	49 89 fc             	mov    %rdi,%r12
  66084c:	ff 15 16 90 12 00    	call   *0x129016(%rip)        # 789868 <_DYNAMIC+0x340>
  660852:	89 c5                	mov    %eax,%ebp
  660854:	84 c0                	test   %al,%al
  660856:	0f 84 25 07 00 00    	je     660f81 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x751>
  66085c:	41 8b 16             	mov    (%r14),%edx
  66085f:	41 8b 46 08          	mov    0x8(%r14),%eax
  660863:	39 d0                	cmp    %edx,%eax
  660865:	0f 84 16 07 00 00    	je     660f81 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x751>
  66086b:	89 d1                	mov    %edx,%ecx
  66086d:	0f 47 c8             	cmova  %eax,%ecx
  660870:	0f 42 d0             	cmovb  %eax,%edx
  660873:	4c 8d 74 24 68       	lea    0x68(%rsp),%r14
  660878:	4c 89 f7             	mov    %r14,%rdi
  66087b:	4c 89 e6             	mov    %r12,%rsi
  66087e:	ff 15 ec 8f 12 00    	call   *0x128fec(%rip)        # 789870 <_DYNAMIC+0x348>
  660884:	f3 41 0f 10 44 24 4c 	movss  0x4c(%r12),%xmm0
  66088b:	f3 0f 59 05 05 ce 9b 	mulss  -0x6431fb(%rip),%xmm0        # 1d698 <GCC_except_table0+0x88>
  660892:	ff 
  660893:	48 8d bc 24 a0 00 00 	lea    0xa0(%rsp),%rdi
  66089a:	00 
  66089b:	4c 89 e6             	mov    %r12,%rsi
  66089e:	4c 89 f2             	mov    %r14,%rdx
  6608a1:	ff 15 d1 8f 12 00    	call   *0x128fd1(%rip)        # 789878 <_DYNAMIC+0x350>
  6608a7:	48 8b 84 24 f8 00 00 	mov    0xf8(%rsp),%rax
  6608ae:	00 
  6608af:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  6608b4:	f3 0f 10 84 24 00 01 	movss  0x100(%rsp),%xmm0
  6608bb:	00 00 
  6608bd:	f3 0f 11 44 24 1c    	movss  %xmm0,0x1c(%rsp)
  6608c3:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  6608c8:	48 8b 00             	mov    (%rax),%rax
  6608cb:	48 89 44 24 50       	mov    %rax,0x50(%rsp)
  6608d0:	48 c7 44 24 20 00 00 	movq   $0x0,0x20(%rsp)
  6608d7:	00 00 
  6608d9:	f3 0f 11 54 24 08    	movss  %xmm2,0x8(%rsp)
  6608df:	f3 0f 11 4c 24 0c    	movss  %xmm1,0xc(%rsp)
  6608e5:	4c 89 5c 24 10       	mov    %r11,0x10(%rsp)
  6608ea:	0f 28 d0             	movaps %xmm0,%xmm2
  6608ed:	0f 28 e6             	movaps %xmm6,%xmm4
  6608f0:	0f 29 64 24 30       	movaps %xmm4,0x30(%rsp)
  6608f5:	0f 29 54 24 40       	movaps %xmm2,0x40(%rsp)
  6608fa:	eb 0d                	jmp    660909 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0xd9>
  6608fc:	0f 1f 40 00          	nopl   0x0(%rax)
  660900:	48 85 c9             	test   %rcx,%rcx
  660903:	0f 85 cb 02 00 00    	jne    660bd4 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x3a4>
  660909:	48 8b 94 24 b8 00 00 	mov    0xb8(%rsp),%rdx
  660910:	00 
  660911:	48 8b b4 24 a8 00 00 	mov    0xa8(%rsp),%rsi
  660918:	00 
  660919:	48 8b 84 24 b0 00 00 	mov    0xb0(%rsp),%rax
  660920:	00 
  660921:	48 83 bc 24 a0 00 00 	cmpq   $0x1,0xa0(%rsp)
  660928:	00 01 
  66092a:	75 44                	jne    660970 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x140>
  66092c:	48 39 c2             	cmp    %rax,%rdx
  66092f:	0f 83 f5 05 00 00    	jae    660f2a <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x6fa>
  660935:	48 8d 0c 52          	lea    (%rdx,%rdx,2),%rcx
  660939:	8b 3c 8e             	mov    (%rsi,%rcx,4),%edi
  66093c:	4c 8d 40 ff          	lea    -0x1(%rax),%r8
  660940:	48 8d 34 8e          	lea    (%rsi,%rcx,4),%rsi
  660944:	48 83 c6 0c          	add    $0xc,%rsi
  660948:	48 89 d1             	mov    %rdx,%rcx
  66094b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  660950:	49 39 c8             	cmp    %rcx,%r8
  660953:	74 5b                	je     6609b0 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x180>
  660955:	48 ff c1             	inc    %rcx
  660958:	39 3e                	cmp    %edi,(%rsi)
  66095a:	48 8d 76 0c          	lea    0xc(%rsi),%rsi
  66095e:	74 f0                	je     660950 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x120>
  660960:	eb 51                	jmp    6609b3 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x183>
  660962:	66 66 66 66 66 2e 0f 	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  660969:	1f 84 00 00 00 00 00 
  660970:	48 39 c2             	cmp    %rax,%rdx
  660973:	0f 83 b1 05 00 00    	jae    660f2a <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x6fa>
  660979:	8b 3c d6             	mov    (%rsi,%rdx,8),%edi
  66097c:	4c 8d 40 ff          	lea    -0x1(%rax),%r8
  660980:	49 89 d1             	mov    %rdx,%r9
  660983:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  66098a:	84 00 00 00 00 00 
  660990:	4d 39 c8             	cmp    %r9,%r8
  660993:	74 1b                	je     6609b0 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x180>
  660995:	49 8d 49 01          	lea    0x1(%r9),%rcx
  660999:	42 39 7c ce 08       	cmp    %edi,0x8(%rsi,%r9,8)
  66099e:	49 89 c9             	mov    %rcx,%r9
  6609a1:	74 ed                	je     660990 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x160>
  6609a3:	eb 0e                	jmp    6609b3 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x183>
  6609a5:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  6609ac:	00 00 00 00 
  6609b0:	48 89 c1             	mov    %rax,%rcx
  6609b3:	48 89 8c 24 b8 00 00 	mov    %rcx,0xb8(%rsp)
  6609ba:	00 
  6609bb:	4c 89 f7             	mov    %r14,%rdi
  6609be:	48 8d b4 24 a0 00 00 	lea    0xa0(%rsp),%rsi
  6609c5:	00 
  6609c6:	ff 15 b4 8e 12 00    	call   *0x128eb4(%rip)        # 789880 <_DYNAMIC+0x358>
  6609cc:	4c 8b 64 24 68       	mov    0x68(%rsp),%r12
  6609d1:	49 83 fc 02          	cmp    $0x2,%r12
  6609d5:	0f 28 64 24 30       	movaps 0x30(%rsp),%xmm4
  6609da:	0f 28 54 24 40       	movaps 0x40(%rsp),%xmm2
  6609df:	0f 84 45 05 00 00    	je     660f2a <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x6fa>
  6609e5:	4c 8b 6c 24 70       	mov    0x70(%rsp),%r13
  6609ea:	4c 8b 7c 24 78       	mov    0x78(%rsp),%r15
  6609ef:	48 8b 94 24 e0 00 00 	mov    0xe0(%rsp),%rdx
  6609f6:	00 
  6609f7:	48 85 d2             	test   %rdx,%rdx
  6609fa:	0f 85 ef 03 00 00    	jne    660def <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x5bf>
  660a00:	48 8b 94 24 d8 00 00 	mov    0xd8(%rsp),%rdx
  660a07:	00 
  660a08:	48 8b b4 24 c8 00 00 	mov    0xc8(%rsp),%rsi
  660a0f:	00 
  660a10:	48 8b 84 24 d0 00 00 	mov    0xd0(%rsp),%rax
  660a17:	00 
  660a18:	48 83 bc 24 c0 00 00 	cmpq   $0x1,0xc0(%rsp)
  660a1f:	00 01 
  660a21:	75 4d                	jne    660a70 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x240>
  660a23:	48 39 c2             	cmp    %rax,%rdx
  660a26:	0f 83 fe 04 00 00    	jae    660f2a <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x6fa>
  660a2c:	48 8d 0c 52          	lea    (%rdx,%rdx,2),%rcx
  660a30:	8b 3c 8e             	mov    (%rsi,%rcx,4),%edi
  660a33:	4c 8d 40 ff          	lea    -0x1(%rax),%r8
  660a37:	48 8d 34 8e          	lea    (%rsi,%rcx,4),%rsi
  660a3b:	48 83 c6 0c          	add    $0xc,%rsi
  660a3f:	48 89 d1             	mov    %rdx,%rcx
  660a42:	66 66 66 66 66 2e 0f 	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  660a49:	1f 84 00 00 00 00 00 
  660a50:	49 39 c8             	cmp    %rcx,%r8
  660a53:	74 5b                	je     660ab0 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x280>
  660a55:	48 ff c1             	inc    %rcx
  660a58:	39 3e                	cmp    %edi,(%rsi)
  660a5a:	48 8d 76 0c          	lea    0xc(%rsi),%rsi
  660a5e:	74 f0                	je     660a50 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x220>
  660a60:	eb 51                	jmp    660ab3 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x283>
  660a62:	66 66 66 66 66 2e 0f 	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  660a69:	1f 84 00 00 00 00 00 
  660a70:	48 39 c2             	cmp    %rax,%rdx
  660a73:	0f 83 b1 04 00 00    	jae    660f2a <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x6fa>
  660a79:	8b 3c d6             	mov    (%rsi,%rdx,8),%edi
  660a7c:	4c 8d 40 ff          	lea    -0x1(%rax),%r8
  660a80:	49 89 d1             	mov    %rdx,%r9
  660a83:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  660a8a:	84 00 00 00 00 00 
  660a90:	4d 39 c8             	cmp    %r9,%r8
  660a93:	74 1b                	je     660ab0 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x280>
  660a95:	49 8d 49 01          	lea    0x1(%r9),%rcx
  660a99:	42 39 7c ce 08       	cmp    %edi,0x8(%rsi,%r9,8)
  660a9e:	49 89 c9             	mov    %rcx,%r9
  660aa1:	74 ed                	je     660a90 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x260>
  660aa3:	eb 0e                	jmp    660ab3 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x283>
  660aa5:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  660aac:	00 00 00 00 
  660ab0:	48 89 c1             	mov    %rax,%rcx
  660ab3:	48 89 8c 24 d8 00 00 	mov    %rcx,0xd8(%rsp)
  660aba:	00 
  660abb:	4c 89 f7             	mov    %r14,%rdi
  660abe:	48 8d b4 24 c0 00 00 	lea    0xc0(%rsp),%rsi
  660ac5:	00 
  660ac6:	ff 15 b4 8d 12 00    	call   *0x128db4(%rip)        # 789880 <_DYNAMIC+0x358>
  660acc:	48 8b 54 24 68       	mov    0x68(%rsp),%rdx
  660ad1:	48 83 fa 02          	cmp    $0x2,%rdx
  660ad5:	0f 28 64 24 30       	movaps 0x30(%rsp),%xmm4
  660ada:	0f 28 54 24 40       	movaps 0x40(%rsp),%xmm2
  660adf:	0f 84 45 04 00 00    	je     660f2a <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x6fa>
  660ae5:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  660aea:	48 8b 4c 24 78       	mov    0x78(%rsp),%rcx
  660aef:	49 83 fc 01          	cmp    $0x1,%r12
  660af3:	75 2b                	jne    660b20 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x2f0>
  660af5:	4d 85 ff             	test   %r15,%r15
  660af8:	0f 84 0b fe ff ff    	je     660909 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0xd9>
  660afe:	66 90                	xchg   %ax,%ax
  660b00:	41 0f b6 5d 08       	movzbl 0x8(%r13),%ebx
  660b05:	f6 c3 02             	test   $0x2,%bl
  660b08:	75 74                	jne    660b7e <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x34e>
  660b0a:	49 83 c5 0c          	add    $0xc,%r13
  660b0e:	49 ff cf             	dec    %r15
  660b11:	75 ed                	jne    660b00 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x2d0>
  660b13:	e9 f1 fd ff ff       	jmp    660909 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0xd9>
  660b18:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  660b1f:	00 
  660b20:	4d 85 ff             	test   %r15,%r15
  660b23:	0f 84 e0 fd ff ff    	je     660909 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0xd9>
  660b29:	45 8b 65 00          	mov    0x0(%r13),%r12d
  660b2d:	be 01 00 00 00       	mov    $0x1,%esi
  660b32:	4c 29 fe             	sub    %r15,%rsi
  660b35:	49 ff cf             	dec    %r15
  660b38:	48 c7 c7 ff ff ff ff 	mov    $0xffffffffffffffff,%rdi
  660b3f:	90                   	nop
  660b40:	4c 8d 04 3e          	lea    (%rsi,%rdi,1),%r8
  660b44:	49 83 f8 ff          	cmp    $0xffffffffffffffff,%r8
  660b48:	74 49                	je     660b93 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x363>
  660b4a:	4c 8d 47 01          	lea    0x1(%rdi),%r8
  660b4e:	45 39 64 fd 10       	cmp    %r12d,0x10(%r13,%rdi,8)
  660b53:	4c 89 c7             	mov    %r8,%rdi
  660b56:	74 e8                	je     660b40 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x310>
  660b58:	4f 8d 6c c5 00       	lea    0x0(%r13,%r8,8),%r13
  660b5d:	4d 85 c0             	test   %r8,%r8
  660b60:	74 3e                	je     660ba0 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x370>
  660b62:	45 39 65 f8          	cmp    %r12d,-0x8(%r13)
  660b66:	0f 94 c3             	sete   %bl
  660b69:	80 f3 03             	xor    $0x3,%bl
  660b6c:	f3 41 0f 10 45 04    	movss  0x4(%r13),%xmm0
  660b72:	48 83 fa 01          	cmp    $0x1,%rdx
  660b76:	0f 85 84 fd ff ff    	jne    660900 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0xd0>
  660b7c:	eb 34                	jmp    660bb2 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x382>
  660b7e:	45 8b 65 00          	mov    0x0(%r13),%r12d
  660b82:	f3 41 0f 10 45 04    	movss  0x4(%r13),%xmm0
  660b88:	48 83 fa 01          	cmp    $0x1,%rdx
  660b8c:	74 24                	je     660bb2 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x382>
  660b8e:	e9 6d fd ff ff       	jmp    660900 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0xd0>
  660b93:	4d 89 f8             	mov    %r15,%r8
  660b96:	4f 8d 6c c5 00       	lea    0x0(%r13,%r8,8),%r13
  660b9b:	4d 85 c0             	test   %r8,%r8
  660b9e:	75 c2                	jne    660b62 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x332>
  660ba0:	b3 03                	mov    $0x3,%bl
  660ba2:	f3 41 0f 10 45 04    	movss  0x4(%r13),%xmm0
  660ba8:	48 83 fa 01          	cmp    $0x1,%rdx
  660bac:	0f 85 4e fd ff ff    	jne    660900 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0xd0>
  660bb2:	48 85 c9             	test   %rcx,%rcx
  660bb5:	0f 84 4e fd ff ff    	je     660909 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0xd9>
  660bbb:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  660bc0:	f6 40 08 01          	testb  $0x1,0x8(%rax)
  660bc4:	75 0e                	jne    660bd4 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x3a4>
  660bc6:	48 83 c0 0c          	add    $0xc,%rax
  660bca:	48 ff c9             	dec    %rcx
  660bcd:	75 f1                	jne    660bc0 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x390>
  660bcf:	e9 35 fd ff ff       	jmp    660909 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0xd9>
  660bd4:	41 89 ed             	mov    %ebp,%r13d
  660bd7:	4c 89 f5             	mov    %r14,%rbp
  660bda:	0f 29 84 24 80 00 00 	movaps %xmm0,0x80(%rsp)
  660be1:	00 
  660be2:	44 8b 30             	mov    (%rax),%r14d
  660be5:	f3 0f 10 40 04       	movss  0x4(%rax),%xmm0
  660bea:	0f 29 84 24 90 00 00 	movaps %xmm0,0x90(%rsp)
  660bf1:	00 
  660bf2:	4c 8b 7c 24 28       	mov    0x28(%rsp),%r15
  660bf7:	4c 89 ff             	mov    %r15,%rdi
  660bfa:	44 89 e6             	mov    %r12d,%esi
  660bfd:	ba 01 00 00 00       	mov    $0x1,%edx
  660c02:	ff 15 80 8c 12 00    	call   *0x128c80(%rip)        # 789888 <_DYNAMIC+0x360>
  660c08:	49 89 c3             	mov    %rax,%r11
  660c0b:	49 8b 77 40          	mov    0x40(%r15),%rsi
  660c0f:	48 39 f0             	cmp    %rsi,%rax
  660c12:	0f 83 7d 03 00 00    	jae    660f95 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x765>
  660c18:	49 8b 47 38          	mov    0x38(%r15),%rax
  660c1c:	4b 8d 0c 5b          	lea    (%r11,%r11,2),%rcx
  660c20:	44 8b 4c c8 04       	mov    0x4(%rax,%rcx,8),%r9d
  660c25:	f6 c3 01             	test   $0x1,%bl
  660c28:	f3 0f 10 44 24 1c    	movss  0x1c(%rsp),%xmm0
  660c2e:	0f 28 b4 24 90 00 00 	movaps 0x90(%rsp),%xmm6
  660c35:	00 
  660c36:	0f 28 9c 24 80 00 00 	movaps 0x80(%rsp),%xmm3
  660c3d:	00 
  660c3e:	74 6a                	je     660caa <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x47a>
  660c40:	45 85 e4             	test   %r12d,%r12d
  660c43:	45 89 f7             	mov    %r14d,%r15d
  660c46:	74 6a                	je     660cb2 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x482>
  660c48:	4d 85 db             	test   %r11,%r11
  660c4b:	49 89 ee             	mov    %rbp,%r14
  660c4e:	74 55                	je     660ca5 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x475>
  660c50:	48 8d 0c c8          	lea    (%rax,%rcx,8),%rcx
  660c54:	4c 89 d8             	mov    %r11,%rax
  660c57:	44 39 61 ec          	cmp    %r12d,-0x14(%rcx)
  660c5b:	44 89 ed             	mov    %r13d,%ebp
  660c5e:	75 5b                	jne    660cbb <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x48b>
  660c60:	48 8b 5c 24 28       	mov    0x28(%rsp),%rbx
  660c65:	48 89 df             	mov    %rbx,%rdi
  660c68:	44 89 e6             	mov    %r12d,%esi
  660c6b:	31 d2                	xor    %edx,%edx
  660c6d:	4d 89 dd             	mov    %r11,%r13
  660c70:	44 89 7c 24 64       	mov    %r15d,0x64(%rsp)
  660c75:	45 89 cf             	mov    %r9d,%r15d
  660c78:	ff 15 0a 8c 12 00    	call   *0x128c0a(%rip)        # 789888 <_DYNAMIC+0x360>
  660c7e:	45 89 f9             	mov    %r15d,%r9d
  660c81:	44 8b 7c 24 64       	mov    0x64(%rsp),%r15d
  660c86:	4d 89 eb             	mov    %r13,%r11
  660c89:	0f 28 9c 24 80 00 00 	movaps 0x80(%rsp),%xmm3
  660c90:	00 
  660c91:	0f 28 b4 24 90 00 00 	movaps 0x90(%rsp),%xmm6
  660c98:	00 
  660c99:	f3 0f 10 44 24 1c    	movss  0x1c(%rsp),%xmm0
  660c9f:	48 8b 73 40          	mov    0x40(%rbx),%rsi
  660ca3:	eb 16                	jmp    660cbb <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x48b>
  660ca5:	4c 89 d8             	mov    %r11,%rax
  660ca8:	eb 0e                	jmp    660cb8 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x488>
  660caa:	4c 89 d8             	mov    %r11,%rax
  660cad:	45 89 f7             	mov    %r14d,%r15d
  660cb0:	eb 03                	jmp    660cb5 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x485>
  660cb2:	4c 89 d8             	mov    %r11,%rax
  660cb5:	49 89 ee             	mov    %rbp,%r14
  660cb8:	44 89 ed             	mov    %r13d,%ebp
  660cbb:	48 39 f0             	cmp    %rsi,%rax
  660cbe:	0f 83 e1 02 00 00    	jae    660fa5 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x775>
  660cc4:	0f 2e de             	ucomiss %xmm6,%xmm3
  660cc7:	75 02                	jne    660ccb <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x49b>
  660cc9:	7b 09                	jnp    660cd4 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x4a4>
  660ccb:	45 39 cf             	cmp    %r9d,%r15d
  660cce:	0f 86 a9 00 00 00    	jbe    660d7d <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x54d>
  660cd4:	48 8b 54 24 28       	mov    0x28(%rsp),%rdx
  660cd9:	48 8b 4a 20          	mov    0x20(%rdx),%rcx
  660cdd:	48 8b 52 28          	mov    0x28(%rdx),%rdx
  660ce1:	48 89 d6             	mov    %rdx,%rsi
  660ce4:	48 85 d2             	test   %rdx,%rdx
  660ce7:	74 4c                	je     660d35 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x505>
  660ce9:	44 89 cb             	mov    %r9d,%ebx
  660cec:	48 83 fa 01          	cmp    $0x1,%rdx
  660cf0:	75 04                	jne    660cf6 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x4c6>
  660cf2:	31 f6                	xor    %esi,%esi
  660cf4:	eb 2d                	jmp    660d23 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x4f3>
  660cf6:	48 89 d7             	mov    %rdx,%rdi
  660cf9:	31 f6                	xor    %esi,%esi
  660cfb:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  660d00:	49 89 f8             	mov    %rdi,%r8
  660d03:	49 d1 e8             	shr    $1,%r8
  660d06:	4d 8d 0c 30          	lea    (%r8,%rsi,1),%r9
  660d0a:	4f 8d 14 49          	lea    (%r9,%r9,2),%r10
  660d0e:	46 8b 54 d1 10       	mov    0x10(%rcx,%r10,8),%r10d
  660d13:	4d 39 d3             	cmp    %r10,%r11
  660d16:	49 0f 47 f1          	cmova  %r9,%rsi
  660d1a:	4c 29 c7             	sub    %r8,%rdi
  660d1d:	48 83 ff 01          	cmp    $0x1,%rdi
  660d21:	77 dd                	ja     660d00 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x4d0>
  660d23:	48 8d 3c 76          	lea    (%rsi,%rsi,2),%rdi
  660d27:	8b 7c f9 10          	mov    0x10(%rcx,%rdi,8),%edi
  660d2b:	4c 39 df             	cmp    %r11,%rdi
  660d2e:	48 83 d6 00          	adc    $0x0,%rsi
  660d32:	41 89 d9             	mov    %ebx,%r9d
  660d35:	48 c1 e6 03          	shl    $0x3,%rsi
  660d39:	48 8d 34 76          	lea    (%rsi,%rsi,2),%rsi
  660d3d:	48 8d 3c 31          	lea    (%rcx,%rsi,1),%rdi
  660d41:	48 c1 e2 03          	shl    $0x3,%rdx
  660d45:	48 8d 14 52          	lea    (%rdx,%rdx,2),%rdx
  660d49:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  660d50:	48 39 f2             	cmp    %rsi,%rdx
  660d53:	74 68                	je     660dbd <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x58d>
  660d55:	49 89 f8             	mov    %rdi,%r8
  660d58:	8b 7f 10             	mov    0x10(%rdi),%edi
  660d5b:	49 39 fb             	cmp    %rdi,%r11
  660d5e:	75 5d                	jne    660dbd <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x58d>
  660d60:	49 8d 78 18          	lea    0x18(%r8),%rdi
  660d64:	48 83 c6 18          	add    $0x18,%rsi
  660d68:	45 39 20             	cmp    %r12d,(%r8)
  660d6b:	77 e3                	ja     660d50 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x520>
  660d6d:	45 3b 60 04          	cmp    0x4(%r8),%r12d
  660d71:	77 dd                	ja     660d50 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x520>
  660d73:	0f b6 4c 31 fd       	movzbl -0x3(%rcx,%rsi,1),%ecx
  660d78:	45 39 cf             	cmp    %r9d,%r15d
  660d7b:	77 47                	ja     660dc4 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x594>
  660d7d:	0f 28 cb             	movaps %xmm3,%xmm1
  660d80:	f3 0f 5d ce          	minss  %xmm6,%xmm1
  660d84:	0f 28 c1             	movaps %xmm1,%xmm0
  660d87:	f3 0f c2 c1 03       	cmpunordss %xmm1,%xmm0
  660d8c:	0f 28 d0             	movaps %xmm0,%xmm2
  660d8f:	0f 55 d1             	andnps %xmm1,%xmm2
  660d92:	0f 54 c3             	andps  %xmm3,%xmm0
  660d95:	0f 56 c2             	orps   %xmm2,%xmm0
  660d98:	f3 0f 5c f3          	subss  %xmm3,%xmm6
  660d9c:	0f 54 35 5d 45 9c ff 	andps  -0x63baa3(%rip),%xmm6        # 25300 <anon.1508e9dce0c1a49d095b8c30671814b4.0.llvm.16300762181250184790+0x7e0>
  660da3:	0f 28 64 24 30       	movaps 0x30(%rsp),%xmm4
  660da8:	0f 28 54 24 40       	movaps 0x40(%rsp),%xmm2
  660dad:	0f 57 c9             	xorps  %xmm1,%xmm1
  660db0:	0f 2e f1             	ucomiss %xmm1,%xmm6
  660db3:	75 5b                	jne    660e10 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x5e0>
  660db5:	0f 8b 4e fb ff ff    	jnp    660909 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0xd9>
  660dbb:	eb 53                	jmp    660e10 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x5e0>
  660dbd:	31 c9                	xor    %ecx,%ecx
  660dbf:	45 39 cf             	cmp    %r9d,%r15d
  660dc2:	76 b9                	jbe    660d7d <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x54d>
  660dc4:	84 c9                	test   %cl,%cl
  660dc6:	74 04                	je     660dcc <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x59c>
  660dc8:	f3 0f 5c d8          	subss  %xmm0,%xmm3
  660dcc:	0f 28 c8             	movaps %xmm0,%xmm1
  660dcf:	0f 28 64 24 30       	movaps 0x30(%rsp),%xmm4
  660dd4:	0f 28 54 24 40       	movaps 0x40(%rsp),%xmm2
  660dd9:	0f 28 c3             	movaps %xmm3,%xmm0
  660ddc:	0f 28 f1             	movaps %xmm1,%xmm6
  660ddf:	0f 57 c9             	xorps  %xmm1,%xmm1
  660de2:	0f 2e f1             	ucomiss %xmm1,%xmm6
  660de5:	75 29                	jne    660e10 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x5e0>
  660de7:	0f 8b 1c fb ff ff    	jnp    660909 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0xd9>
  660ded:	eb 21                	jmp    660e10 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x5e0>
  660def:	48 c7 84 24 e0 00 00 	movq   $0x0,0xe0(%rsp)
  660df6:	00 00 00 00 00 
  660dfb:	4c 89 f7             	mov    %r14,%rdi
  660dfe:	48 8d b4 24 c0 00 00 	lea    0xc0(%rsp),%rsi
  660e05:	00 
  660e06:	e8 05 04 00 00       	call   661210 <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator>::nth>
  660e0b:	e9 bc fc ff ff       	jmp    660acc <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x29c>
  660e10:	48 8d 04 40          	lea    (%rax,%rax,2),%rax
  660e14:	48 c1 e0 03          	shl    $0x3,%rax
  660e18:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
  660e1d:	48 03 41 38          	add    0x38(%rcx),%rax
  660e21:	f3 0f 10 50 08       	movss  0x8(%rax),%xmm2
  660e26:	f3 0f 10 48 0c       	movss  0xc(%rax),%xmm1
  660e2b:	f6 44 24 20 01       	testb  $0x1,0x20(%rsp)
  660e30:	0f 84 e8 00 00 00    	je     660f1e <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x6ee>
  660e36:	f3 0f 10 5c 24 0c    	movss  0xc(%rsp),%xmm3
  660e3c:	0f 2e d9             	ucomiss %xmm1,%xmm3
  660e3f:	75 7c                	jne    660ebd <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x68d>
  660e41:	7a 7a                	jp     660ebd <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x68d>
  660e43:	4c 39 5c 24 10       	cmp    %r11,0x10(%rsp)
  660e48:	75 73                	jne    660ebd <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x68d>
  660e4a:	f3 0f 10 5c 24 08    	movss  0x8(%rsp),%xmm3
  660e50:	0f 2e da             	ucomiss %xmm2,%xmm3
  660e53:	75 68                	jne    660ebd <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x68d>
  660e55:	7a 66                	jp     660ebd <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x68d>
  660e57:	0f 28 e0             	movaps %xmm0,%xmm4
  660e5a:	f3 0f 58 e6          	addss  %xmm6,%xmm4
  660e5e:	0f 28 6c 24 40       	movaps 0x40(%rsp),%xmm5
  660e63:	0f 2e e5             	ucomiss %xmm5,%xmm4
  660e66:	72 50                	jb     660eb8 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x688>
  660e68:	0f 28 dd             	movaps %xmm5,%xmm3
  660e6b:	f3 0f 58 5c 24 30    	addss  0x30(%rsp),%xmm3
  660e71:	0f 2e d8             	ucomiss %xmm0,%xmm3
  660e74:	72 42                	jb     660eb8 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x688>
  660e76:	0f 28 cb             	movaps %xmm3,%xmm1
  660e79:	f3 0f 5f cc          	maxss  %xmm4,%xmm1
  660e7d:	0f 28 e1             	movaps %xmm1,%xmm4
  660e80:	f3 0f c2 e1 03       	cmpunordss %xmm1,%xmm4
  660e85:	0f 28 d4             	movaps %xmm4,%xmm2
  660e88:	0f 55 d1             	andnps %xmm1,%xmm2
  660e8b:	0f 54 e3             	andps  %xmm3,%xmm4
  660e8e:	0f 56 e2             	orps   %xmm2,%xmm4
  660e91:	0f 28 cd             	movaps %xmm5,%xmm1
  660e94:	f3 0f 5d c8          	minss  %xmm0,%xmm1
  660e98:	0f 28 c1             	movaps %xmm1,%xmm0
  660e9b:	f3 0f c2 c1 03       	cmpunordss %xmm1,%xmm0
  660ea0:	0f 28 d0             	movaps %xmm0,%xmm2
  660ea3:	0f 55 d1             	andnps %xmm1,%xmm2
  660ea6:	0f 54 c5             	andps  %xmm5,%xmm0
  660ea9:	0f 56 c2             	orps   %xmm2,%xmm0
  660eac:	f3 0f 5c e0          	subss  %xmm0,%xmm4
  660eb0:	0f 28 d0             	movaps %xmm0,%xmm2
  660eb3:	e9 38 fa ff ff       	jmp    6608f0 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0xc0>
  660eb8:	4c 8b 5c 24 10       	mov    0x10(%rsp),%r11
  660ebd:	48 8b 4c 24 50       	mov    0x50(%rsp),%rcx
  660ec2:	48 c1 c1 07          	rol    $0x7,%rcx
  660ec6:	66 0f 6f 5c 24 40    	movdqa 0x40(%rsp),%xmm3
  660ecc:	66 0f 7e d8          	movd   %xmm3,%eax
  660ed0:	48 31 c8             	xor    %rcx,%rax
  660ed3:	48 c1 c0 07          	rol    $0x7,%rax
  660ed7:	66 0f 6e 5c 24 08    	movd   0x8(%rsp),%xmm3
  660edd:	66 0f 7e d9          	movd   %xmm3,%ecx
  660ee1:	48 31 c1             	xor    %rax,%rcx
  660ee4:	48 c1 c1 07          	rol    $0x7,%rcx
  660ee8:	66 0f 6f 5c 24 30    	movdqa 0x30(%rsp),%xmm3
  660eee:	66 0f 7e d8          	movd   %xmm3,%eax
  660ef2:	48 31 c8             	xor    %rcx,%rax
  660ef5:	48 c1 c0 07          	rol    $0x7,%rax
  660ef9:	66 0f 6e 5c 24 0c    	movd   0xc(%rsp),%xmm3
  660eff:	66 0f 7e d9          	movd   %xmm3,%ecx
  660f03:	48 31 c1             	xor    %rax,%rcx
  660f06:	48 c1 c1 07          	rol    $0x7,%rcx
  660f0a:	8b 54 24 10          	mov    0x10(%rsp),%edx
  660f0e:	48 31 ca             	xor    %rcx,%rdx
  660f11:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  660f16:	48 89 54 24 50       	mov    %rdx,0x50(%rsp)
  660f1b:	48 89 10             	mov    %rdx,(%rax)
  660f1e:	b0 01                	mov    $0x1,%al
  660f20:	48 89 44 24 20       	mov    %rax,0x20(%rsp)
  660f25:	e9 af f9 ff ff       	jmp    6608d9 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0xa9>
  660f2a:	f6 44 24 20 01       	testb  $0x1,0x20(%rsp)
  660f2f:	74 50                	je     660f81 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x751>
  660f31:	48 8b 4c 24 50       	mov    0x50(%rsp),%rcx
  660f36:	48 c1 c1 07          	rol    $0x7,%rcx
  660f3a:	66 0f 7e d0          	movd   %xmm2,%eax
  660f3e:	48 31 c8             	xor    %rcx,%rax
  660f41:	48 c1 c0 07          	rol    $0x7,%rax
  660f45:	66 0f 6e 44 24 08    	movd   0x8(%rsp),%xmm0
  660f4b:	66 0f 7e c1          	movd   %xmm0,%ecx
  660f4f:	48 31 c1             	xor    %rax,%rcx
  660f52:	48 c1 c1 07          	rol    $0x7,%rcx
  660f56:	66 0f 7e e0          	movd   %xmm4,%eax
  660f5a:	48 31 c8             	xor    %rcx,%rax
  660f5d:	48 c1 c0 07          	rol    $0x7,%rax
  660f61:	66 0f 6e 44 24 0c    	movd   0xc(%rsp),%xmm0
  660f67:	66 0f 7e c1          	movd   %xmm0,%ecx
  660f6b:	48 31 c1             	xor    %rax,%rcx
  660f6e:	48 c1 c1 07          	rol    $0x7,%rcx
  660f72:	8b 44 24 10          	mov    0x10(%rsp),%eax
  660f76:	48 31 c8             	xor    %rcx,%rax
  660f79:	48 8b 4c 24 58       	mov    0x58(%rsp),%rcx
  660f7e:	48 89 01             	mov    %rax,(%rcx)
  660f81:	89 e8                	mov    %ebp,%eax
  660f83:	48 81 c4 08 01 00 00 	add    $0x108,%rsp
  660f8a:	5b                   	pop    %rbx
  660f8b:	41 5c                	pop    %r12
  660f8d:	41 5d                	pop    %r13
  660f8f:	41 5e                	pop    %r14
  660f91:	41 5f                	pop    %r15
  660f93:	5d                   	pop    %rbp
  660f94:	c3                   	ret
  660f95:	48 8d 15 74 da 11 00 	lea    0x11da74(%rip),%rdx        # 77ea10 <__frame_dummy_init_array_entry+0x1c0>
  660f9c:	4c 89 df             	mov    %r11,%rdi
  660f9f:	ff 15 eb 88 12 00    	call   *0x1288eb(%rip)        # 789890 <_DYNAMIC+0x368>
  660fa5:	48 8d 15 7c da 11 00 	lea    0x11da7c(%rip),%rdx        # 77ea28 <__frame_dummy_init_array_entry+0x1d8>
  660fac:	48 89 c7             	mov    %rax,%rdi
  660faf:	ff 15 db 88 12 00    	call   *0x1288db(%rip)        # 789890 <_DYNAMIC+0x368>
