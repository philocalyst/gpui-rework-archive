
/tmp/gpui-text-map-query-refinements/8direct/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

0000000000660850 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>>:
  660850:	55                   	push   %rbp
  660851:	41 57                	push   %r15
  660853:	41 56                	push   %r14
  660855:	41 55                	push   %r13
  660857:	41 54                	push   %r12
  660859:	53                   	push   %rbx
  66085a:	48 81 ec 18 01 00 00 	sub    $0x118,%rsp
  660861:	48 89 d3             	mov    %rdx,%rbx
  660864:	49 89 f6             	mov    %rsi,%r14
  660867:	49 89 fc             	mov    %rdi,%r12
  66086a:	ff 15 38 8f 12 00    	call   *0x128f38(%rip)        # 7897a8 <_DYNAMIC+0x340>
  660870:	89 c5                	mov    %eax,%ebp
  660872:	84 c0                	test   %al,%al
  660874:	0f 84 8f 06 00 00    	je     660f09 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x6b9>
  66087a:	41 8b 16             	mov    (%r14),%edx
  66087d:	41 8b 46 08          	mov    0x8(%r14),%eax
  660881:	39 d0                	cmp    %edx,%eax
  660883:	0f 84 80 06 00 00    	je     660f09 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x6b9>
  660889:	89 d1                	mov    %edx,%ecx
  66088b:	0f 47 c8             	cmova  %eax,%ecx
  66088e:	0f 42 d0             	cmovb  %eax,%edx
  660891:	4c 8d 74 24 28       	lea    0x28(%rsp),%r14
  660896:	4c 89 f7             	mov    %r14,%rdi
  660899:	4c 89 e6             	mov    %r12,%rsi
  66089c:	ff 15 0e 8f 12 00    	call   *0x128f0e(%rip)        # 7897b0 <_DYNAMIC+0x348>
  6608a2:	f3 41 0f 10 44 24 4c 	movss  0x4c(%r12),%xmm0
  6608a9:	f3 0f 59 05 c7 cd 9b 	mulss  -0x643239(%rip),%xmm0        # 1d678 <GCC_except_table0+0x8c>
  6608b0:	ff 
  6608b1:	48 8d bc 24 88 00 00 	lea    0x88(%rsp),%rdi
  6608b8:	00 
  6608b9:	4c 89 e6             	mov    %r12,%rsi
  6608bc:	4c 89 f2             	mov    %r14,%rdx
  6608bf:	ff 15 f3 8e 12 00    	call   *0x128ef3(%rip)        # 7897b8 <_DYNAMIC+0x350>
  6608c5:	48 8b 94 24 e0 00 00 	mov    0xe0(%rsp),%rdx
  6608cc:	00 
  6608cd:	f3 0f 10 84 24 e8 00 	movss  0xe8(%rsp),%xmm0
  6608d4:	00 00 
  6608d6:	f3 0f 11 44 24 24    	movss  %xmm0,0x24(%rsp)
  6608dc:	48 89 5c 24 48       	mov    %rbx,0x48(%rsp)
  6608e1:	48 8b 03             	mov    (%rbx),%rax
  6608e4:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
  6608e9:	48 c7 44 24 10 00 00 	movq   $0x0,0x10(%rsp)
  6608f0:	00 00 
  6608f2:	48 8b 1d c7 8e 12 00 	mov    0x128ec7(%rip),%rbx        # 7897c0 <_DYNAMIC+0x358>
  6608f9:	48 89 54 24 40       	mov    %rdx,0x40(%rsp)
  6608fe:	f3 0f 11 4c 24 04    	movss  %xmm1,0x4(%rsp)
  660904:	f3 0f 11 14 24       	movss  %xmm2,(%rsp)
  660909:	4c 89 6c 24 08       	mov    %r13,0x8(%rsp)
  66090e:	0f 28 f0             	movaps %xmm0,%xmm6
  660911:	0f 28 ef             	movaps %xmm7,%xmm5
  660914:	0f 29 6c 24 70       	movaps %xmm5,0x70(%rsp)
  660919:	0f 29 74 24 60       	movaps %xmm6,0x60(%rsp)
  66091e:	eb 09                	jmp    660929 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0xd9>
  660920:	48 85 c9             	test   %rcx,%rcx
  660923:	0f 85 cb 02 00 00    	jne    660bf4 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x3a4>
  660929:	48 8b 94 24 a0 00 00 	mov    0xa0(%rsp),%rdx
  660930:	00 
  660931:	48 8b b4 24 90 00 00 	mov    0x90(%rsp),%rsi
  660938:	00 
  660939:	48 8b 84 24 98 00 00 	mov    0x98(%rsp),%rax
  660940:	00 
  660941:	48 83 bc 24 88 00 00 	cmpq   $0x1,0x88(%rsp)
  660948:	00 01 
  66094a:	75 44                	jne    660990 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x140>
  66094c:	48 39 c2             	cmp    %rax,%rdx
  66094f:	0f 83 5e 05 00 00    	jae    660eb3 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x663>
  660955:	48 8d 0c 52          	lea    (%rdx,%rdx,2),%rcx
  660959:	8b 3c 8e             	mov    (%rsi,%rcx,4),%edi
  66095c:	4c 8d 40 ff          	lea    -0x1(%rax),%r8
  660960:	48 8d 34 8e          	lea    (%rsi,%rcx,4),%rsi
  660964:	48 83 c6 0c          	add    $0xc,%rsi
  660968:	48 89 d1             	mov    %rdx,%rcx
  66096b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  660970:	49 39 c8             	cmp    %rcx,%r8
  660973:	74 5b                	je     6609d0 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x180>
  660975:	48 ff c1             	inc    %rcx
  660978:	39 3e                	cmp    %edi,(%rsi)
  66097a:	48 8d 76 0c          	lea    0xc(%rsi),%rsi
  66097e:	74 f0                	je     660970 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x120>
  660980:	eb 51                	jmp    6609d3 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x183>
  660982:	66 66 66 66 66 2e 0f 	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  660989:	1f 84 00 00 00 00 00 
  660990:	48 39 c2             	cmp    %rax,%rdx
  660993:	0f 83 1a 05 00 00    	jae    660eb3 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x663>
  660999:	8b 3c d6             	mov    (%rsi,%rdx,8),%edi
  66099c:	4c 8d 40 ff          	lea    -0x1(%rax),%r8
  6609a0:	49 89 d1             	mov    %rdx,%r9
  6609a3:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  6609aa:	84 00 00 00 00 00 
  6609b0:	4d 39 c8             	cmp    %r9,%r8
  6609b3:	74 1b                	je     6609d0 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x180>
  6609b5:	49 8d 49 01          	lea    0x1(%r9),%rcx
  6609b9:	42 39 7c ce 08       	cmp    %edi,0x8(%rsi,%r9,8)
  6609be:	49 89 c9             	mov    %rcx,%r9
  6609c1:	74 ed                	je     6609b0 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x160>
  6609c3:	eb 0e                	jmp    6609d3 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x183>
  6609c5:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  6609cc:	00 00 00 00 
  6609d0:	48 89 c1             	mov    %rax,%rcx
  6609d3:	48 89 8c 24 a0 00 00 	mov    %rcx,0xa0(%rsp)
  6609da:	00 
  6609db:	4c 89 f7             	mov    %r14,%rdi
  6609de:	48 8d b4 24 88 00 00 	lea    0x88(%rsp),%rsi
  6609e5:	00 
  6609e6:	ff d3                	call   *%rbx
  6609e8:	4c 8b 64 24 28       	mov    0x28(%rsp),%r12
  6609ed:	49 83 fc 02          	cmp    $0x2,%r12
  6609f1:	0f 28 6c 24 70       	movaps 0x70(%rsp),%xmm5
  6609f6:	0f 28 74 24 60       	movaps 0x60(%rsp),%xmm6
  6609fb:	0f 84 b2 04 00 00    	je     660eb3 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x663>
  660a01:	4c 8b 6c 24 30       	mov    0x30(%rsp),%r13
  660a06:	4c 8b 7c 24 38       	mov    0x38(%rsp),%r15
  660a0b:	48 8b 94 24 c8 00 00 	mov    0xc8(%rsp),%rdx
  660a12:	00 
  660a13:	48 85 d2             	test   %rdx,%rdx
  660a16:	0f 85 86 03 00 00    	jne    660da2 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x552>
  660a1c:	48 8b 94 24 c0 00 00 	mov    0xc0(%rsp),%rdx
  660a23:	00 
  660a24:	48 8b b4 24 b0 00 00 	mov    0xb0(%rsp),%rsi
  660a2b:	00 
  660a2c:	48 8b 84 24 b8 00 00 	mov    0xb8(%rsp),%rax
  660a33:	00 
  660a34:	48 83 bc 24 a8 00 00 	cmpq   $0x1,0xa8(%rsp)
  660a3b:	00 01 
  660a3d:	75 41                	jne    660a80 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x230>
  660a3f:	48 39 c2             	cmp    %rax,%rdx
  660a42:	0f 83 6b 04 00 00    	jae    660eb3 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x663>
  660a48:	48 8d 0c 52          	lea    (%rdx,%rdx,2),%rcx
  660a4c:	8b 3c 8e             	mov    (%rsi,%rcx,4),%edi
  660a4f:	4c 8d 40 ff          	lea    -0x1(%rax),%r8
  660a53:	48 8d 34 8e          	lea    (%rsi,%rcx,4),%rsi
  660a57:	48 83 c6 0c          	add    $0xc,%rsi
  660a5b:	48 89 d1             	mov    %rdx,%rcx
  660a5e:	66 90                	xchg   %ax,%ax
  660a60:	49 39 c8             	cmp    %rcx,%r8
  660a63:	74 5b                	je     660ac0 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x270>
  660a65:	48 ff c1             	inc    %rcx
  660a68:	39 3e                	cmp    %edi,(%rsi)
  660a6a:	48 8d 76 0c          	lea    0xc(%rsi),%rsi
  660a6e:	74 f0                	je     660a60 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x210>
  660a70:	eb 51                	jmp    660ac3 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x273>
  660a72:	66 66 66 66 66 2e 0f 	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  660a79:	1f 84 00 00 00 00 00 
  660a80:	48 39 c2             	cmp    %rax,%rdx
  660a83:	0f 83 2a 04 00 00    	jae    660eb3 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x663>
  660a89:	8b 3c d6             	mov    (%rsi,%rdx,8),%edi
  660a8c:	4c 8d 40 ff          	lea    -0x1(%rax),%r8
  660a90:	49 89 d1             	mov    %rdx,%r9
  660a93:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  660a9a:	84 00 00 00 00 00 
  660aa0:	4d 39 c8             	cmp    %r9,%r8
  660aa3:	74 1b                	je     660ac0 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x270>
  660aa5:	49 8d 49 01          	lea    0x1(%r9),%rcx
  660aa9:	42 39 7c ce 08       	cmp    %edi,0x8(%rsi,%r9,8)
  660aae:	49 89 c9             	mov    %rcx,%r9
  660ab1:	74 ed                	je     660aa0 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x250>
  660ab3:	eb 0e                	jmp    660ac3 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x273>
  660ab5:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  660abc:	00 00 00 00 
  660ac0:	48 89 c1             	mov    %rax,%rcx
  660ac3:	48 89 8c 24 c0 00 00 	mov    %rcx,0xc0(%rsp)
  660aca:	00 
  660acb:	4c 89 f7             	mov    %r14,%rdi
  660ace:	48 8d b4 24 a8 00 00 	lea    0xa8(%rsp),%rsi
  660ad5:	00 
  660ad6:	ff d3                	call   *%rbx
  660ad8:	48 8b 54 24 28       	mov    0x28(%rsp),%rdx
  660add:	48 83 fa 02          	cmp    $0x2,%rdx
  660ae1:	0f 28 6c 24 70       	movaps 0x70(%rsp),%xmm5
  660ae6:	0f 28 74 24 60       	movaps 0x60(%rsp),%xmm6
  660aeb:	0f 84 c2 03 00 00    	je     660eb3 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x663>
  660af1:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  660af6:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  660afb:	49 83 fc 01          	cmp    $0x1,%r12
  660aff:	75 2f                	jne    660b30 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x2e0>
  660b01:	4d 85 ff             	test   %r15,%r15
  660b04:	0f 84 1f fe ff ff    	je     660929 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0xd9>
  660b0a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  660b10:	41 0f b6 7d 08       	movzbl 0x8(%r13),%edi
  660b15:	40 f6 c7 02          	test   $0x2,%dil
  660b19:	75 67                	jne    660b82 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x332>
  660b1b:	49 83 c5 0c          	add    $0xc,%r13
  660b1f:	49 ff cf             	dec    %r15
  660b22:	75 ec                	jne    660b10 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x2c0>
  660b24:	e9 00 fe ff ff       	jmp    660929 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0xd9>
  660b29:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  660b30:	4d 85 ff             	test   %r15,%r15
  660b33:	0f 84 f0 fd ff ff    	je     660929 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0xd9>
  660b39:	45 8b 65 00          	mov    0x0(%r13),%r12d
  660b3d:	be 01 00 00 00       	mov    $0x1,%esi
  660b42:	4c 29 fe             	sub    %r15,%rsi
  660b45:	49 ff cf             	dec    %r15
  660b48:	48 c7 c7 ff ff ff ff 	mov    $0xffffffffffffffff,%rdi
  660b4f:	90                   	nop
  660b50:	4c 8d 04 3e          	lea    (%rsi,%rdi,1),%r8
  660b54:	49 83 f8 ff          	cmp    $0xffffffffffffffff,%r8
  660b58:	74 42                	je     660b9c <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x34c>
  660b5a:	4c 8d 47 01          	lea    0x1(%rdi),%r8
  660b5e:	45 39 64 fd 10       	cmp    %r12d,0x10(%r13,%rdi,8)
  660b63:	4c 89 c7             	mov    %r8,%rdi
  660b66:	74 e8                	je     660b50 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x300>
  660b68:	4f 8d 6c c5 00       	lea    0x0(%r13,%r8,8),%r13
  660b6d:	31 f6                	xor    %esi,%esi
  660b6f:	4d 85 c0             	test   %r8,%r8
  660b72:	74 37                	je     660bab <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x35b>
  660b74:	45 39 65 f8          	cmp    %r12d,-0x8(%r13)
  660b78:	40 0f 94 c7          	sete   %dil
  660b7c:	40 80 f7 03          	xor    $0x3,%dil
  660b80:	eb 2c                	jmp    660bae <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x35e>
  660b82:	45 8b 65 00          	mov    0x0(%r13),%r12d
  660b86:	41 0f b6 75 0b       	movzbl 0xb(%r13),%esi
  660b8b:	45 0f b7 45 09       	movzwl 0x9(%r13),%r8d
  660b90:	41 c1 e0 08          	shl    $0x8,%r8d
  660b94:	c1 e6 18             	shl    $0x18,%esi
  660b97:	44 09 c6             	or     %r8d,%esi
  660b9a:	eb 12                	jmp    660bae <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x35e>
  660b9c:	4d 89 f8             	mov    %r15,%r8
  660b9f:	4f 8d 6c c5 00       	lea    0x0(%r13,%r8,8),%r13
  660ba4:	31 f6                	xor    %esi,%esi
  660ba6:	4d 85 c0             	test   %r8,%r8
  660ba9:	75 c9                	jne    660b74 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x324>
  660bab:	40 b7 03             	mov    $0x3,%dil
  660bae:	f3 41 0f 10 45 04    	movss  0x4(%r13),%xmm0
  660bb4:	40 0f b6 ff          	movzbl %dil,%edi
  660bb8:	09 f7                	or     %esi,%edi
  660bba:	44 89 64 24 54       	mov    %r12d,0x54(%rsp)
  660bbf:	f3 0f 11 44 24 58    	movss  %xmm0,0x58(%rsp)
  660bc5:	89 7c 24 5c          	mov    %edi,0x5c(%rsp)
  660bc9:	48 83 fa 01          	cmp    $0x1,%rdx
  660bcd:	0f 85 4d fd ff ff    	jne    660920 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0xd0>
  660bd3:	48 85 c9             	test   %rcx,%rcx
  660bd6:	0f 84 4d fd ff ff    	je     660929 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0xd9>
  660bdc:	0f 1f 40 00          	nopl   0x0(%rax)
  660be0:	f6 40 08 01          	testb  $0x1,0x8(%rax)
  660be4:	75 0e                	jne    660bf4 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x3a4>
  660be6:	48 83 c0 0c          	add    $0xc,%rax
  660bea:	48 ff c9             	dec    %rcx
  660bed:	75 f1                	jne    660be0 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x390>
  660bef:	e9 35 fd ff ff       	jmp    660929 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0xd9>
  660bf4:	0f 29 84 24 00 01 00 	movaps %xmm0,0x100(%rsp)
  660bfb:	00 
  660bfc:	44 8b 38             	mov    (%rax),%r15d
  660bff:	f3 0f 10 40 04       	movss  0x4(%rax),%xmm0
  660c04:	0f 29 84 24 f0 00 00 	movaps %xmm0,0xf0(%rsp)
  660c0b:	00 
  660c0c:	4c 8b 6c 24 40       	mov    0x40(%rsp),%r13
  660c11:	4c 89 ef             	mov    %r13,%rdi
  660c14:	44 89 e6             	mov    %r12d,%esi
  660c17:	ba 01 00 00 00       	mov    $0x1,%edx
  660c1c:	ff 15 a6 8b 12 00    	call   *0x128ba6(%rip)        # 7897c8 <_DYNAMIC+0x360>
  660c22:	4c 89 ea             	mov    %r13,%rdx
  660c25:	49 89 c5             	mov    %rax,%r13
  660c28:	48 8b 72 40          	mov    0x40(%rdx),%rsi
  660c2c:	48 39 f0             	cmp    %rsi,%rax
  660c2f:	0f 83 e8 02 00 00    	jae    660f1d <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x6cd>
  660c35:	48 8b 42 38          	mov    0x38(%rdx),%rax
  660c39:	4a 8d 0c 6d 00 00 00 	lea    0x0(,%r13,2),%rcx
  660c40:	00 
  660c41:	4c 01 e9             	add    %r13,%rcx
  660c44:	8b 5c c8 04          	mov    0x4(%rax,%rcx,8),%ebx
  660c48:	4c 89 f7             	mov    %r14,%rdi
  660c4b:	48 89 d6             	mov    %rdx,%rsi
  660c4e:	48 8d 54 24 54       	lea    0x54(%rsp),%rdx
  660c53:	ff 15 77 8b 12 00    	call   *0x128b77(%rip)        # 7897d0 <_DYNAMIC+0x368>
  660c59:	0f 28 9c 24 00 01 00 	movaps 0x100(%rsp),%xmm3
  660c60:	00 
  660c61:	0f 28 bc 24 f0 00 00 	movaps 0xf0(%rsp),%xmm7
  660c68:	00 
  660c69:	0f 2e df             	ucomiss %xmm7,%xmm3
  660c6c:	f3 0f 10 54 24 24    	movss  0x24(%rsp),%xmm2
  660c72:	0f 28 6c 24 70       	movaps 0x70(%rsp),%xmm5
  660c77:	0f 28 74 24 60       	movaps 0x60(%rsp),%xmm6
  660c7c:	75 02                	jne    660c80 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x430>
  660c7e:	7b 09                	jnp    660c89 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x439>
  660c80:	41 39 df             	cmp    %ebx,%r15d
  660c83:	0f 86 a4 00 00 00    	jbe    660d2d <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x4dd>
  660c89:	48 8b 4c 24 40       	mov    0x40(%rsp),%rcx
  660c8e:	48 8b 41 20          	mov    0x20(%rcx),%rax
  660c92:	48 8b 49 28          	mov    0x28(%rcx),%rcx
  660c96:	48 89 ca             	mov    %rcx,%rdx
  660c99:	48 85 c9             	test   %rcx,%rcx
  660c9c:	74 44                	je     660ce2 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x492>
  660c9e:	48 83 f9 01          	cmp    $0x1,%rcx
  660ca2:	75 04                	jne    660ca8 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x458>
  660ca4:	31 d2                	xor    %edx,%edx
  660ca6:	eb 2b                	jmp    660cd3 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x483>
  660ca8:	48 89 ce             	mov    %rcx,%rsi
  660cab:	31 d2                	xor    %edx,%edx
  660cad:	0f 1f 00             	nopl   (%rax)
  660cb0:	48 89 f7             	mov    %rsi,%rdi
  660cb3:	48 d1 ef             	shr    $1,%rdi
  660cb6:	4c 8d 04 17          	lea    (%rdi,%rdx,1),%r8
  660cba:	4f 8d 0c 40          	lea    (%r8,%r8,2),%r9
  660cbe:	46 8b 4c c8 10       	mov    0x10(%rax,%r9,8),%r9d
  660cc3:	4d 39 cd             	cmp    %r9,%r13
  660cc6:	49 0f 47 d0          	cmova  %r8,%rdx
  660cca:	48 29 fe             	sub    %rdi,%rsi
  660ccd:	48 83 fe 01          	cmp    $0x1,%rsi
  660cd1:	77 dd                	ja     660cb0 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x460>
  660cd3:	48 8d 34 52          	lea    (%rdx,%rdx,2),%rsi
  660cd7:	8b 74 f0 10          	mov    0x10(%rax,%rsi,8),%esi
  660cdb:	4c 39 ee             	cmp    %r13,%rsi
  660cde:	48 83 d2 00          	adc    $0x0,%rdx
  660ce2:	48 c1 e2 03          	shl    $0x3,%rdx
  660ce6:	48 8d 14 52          	lea    (%rdx,%rdx,2),%rdx
  660cea:	48 8d 34 10          	lea    (%rax,%rdx,1),%rsi
  660cee:	48 c1 e1 03          	shl    $0x3,%rcx
  660cf2:	48 8d 0c 49          	lea    (%rcx,%rcx,2),%rcx
  660cf6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  660cfd:	00 00 00 
  660d00:	48 39 d1             	cmp    %rdx,%rcx
  660d03:	74 6b                	je     660d70 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x520>
  660d05:	48 89 f7             	mov    %rsi,%rdi
  660d08:	8b 76 10             	mov    0x10(%rsi),%esi
  660d0b:	49 39 f5             	cmp    %rsi,%r13
  660d0e:	75 60                	jne    660d70 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x520>
  660d10:	48 8d 77 18          	lea    0x18(%rdi),%rsi
  660d14:	48 83 c2 18          	add    $0x18,%rdx
  660d18:	44 39 27             	cmp    %r12d,(%rdi)
  660d1b:	77 e3                	ja     660d00 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x4b0>
  660d1d:	44 3b 67 04          	cmp    0x4(%rdi),%r12d
  660d21:	77 dd                	ja     660d00 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x4b0>
  660d23:	0f b6 44 10 fd       	movzbl -0x3(%rax,%rdx,1),%eax
  660d28:	41 39 df             	cmp    %ebx,%r15d
  660d2b:	77 4a                	ja     660d77 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x527>
  660d2d:	0f 28 cb             	movaps %xmm3,%xmm1
  660d30:	f3 0f 5d cf          	minss  %xmm7,%xmm1
  660d34:	0f 28 c1             	movaps %xmm1,%xmm0
  660d37:	f3 0f c2 c1 03       	cmpunordss %xmm1,%xmm0
  660d3c:	0f 28 d0             	movaps %xmm0,%xmm2
  660d3f:	0f 55 d1             	andnps %xmm1,%xmm2
  660d42:	0f 54 c3             	andps  %xmm3,%xmm0
  660d45:	0f 56 c2             	orps   %xmm2,%xmm0
  660d48:	f3 0f 10 4c 24 2c    	movss  0x2c(%rsp),%xmm1
  660d4e:	f3 0f 5c fb          	subss  %xmm3,%xmm7
  660d52:	0f 54 3d 87 45 9c ff 	andps  -0x63ba79(%rip),%xmm7        # 252e0 <anon.1508e9dce0c1a49d095b8c30671814b4.0.llvm.16300762181250184790+0x7e0>
  660d59:	48 8b 1d 60 8a 12 00 	mov    0x128a60(%rip),%rbx        # 7897c0 <_DYNAMIC+0x358>
  660d60:	0f 57 d2             	xorps  %xmm2,%xmm2
  660d63:	0f 2e fa             	ucomiss %xmm2,%xmm7
  660d66:	75 5b                	jne    660dc3 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x573>
  660d68:	0f 8b bb fb ff ff    	jnp    660929 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0xd9>
  660d6e:	eb 53                	jmp    660dc3 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x573>
  660d70:	31 c0                	xor    %eax,%eax
  660d72:	41 39 df             	cmp    %ebx,%r15d
  660d75:	76 b6                	jbe    660d2d <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x4dd>
  660d77:	84 c0                	test   %al,%al
  660d79:	74 04                	je     660d7f <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x52f>
  660d7b:	f3 0f 5c da          	subss  %xmm2,%xmm3
  660d7f:	48 8b 1d 3a 8a 12 00 	mov    0x128a3a(%rip),%rbx        # 7897c0 <_DYNAMIC+0x358>
  660d86:	f3 0f 10 4c 24 2c    	movss  0x2c(%rsp),%xmm1
  660d8c:	0f 28 c3             	movaps %xmm3,%xmm0
  660d8f:	0f 28 fa             	movaps %xmm2,%xmm7
  660d92:	0f 57 d2             	xorps  %xmm2,%xmm2
  660d95:	0f 2e fa             	ucomiss %xmm2,%xmm7
  660d98:	75 29                	jne    660dc3 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x573>
  660d9a:	0f 8b 89 fb ff ff    	jnp    660929 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0xd9>
  660da0:	eb 21                	jmp    660dc3 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x573>
  660da2:	48 c7 84 24 c8 00 00 	movq   $0x0,0xc8(%rsp)
  660da9:	00 00 00 00 00 
  660dae:	4c 89 f7             	mov    %r14,%rdi
  660db1:	48 8d b4 24 a8 00 00 	lea    0xa8(%rsp),%rsi
  660db8:	00 
  660db9:	e8 c2 03 00 00       	call   661180 <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator>::nth>
  660dbe:	e9 15 fd ff ff       	jmp    660ad8 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x288>
  660dc3:	f3 0f 10 54 24 34    	movss  0x34(%rsp),%xmm2
  660dc9:	f6 44 24 10 01       	testb  $0x1,0x10(%rsp)
  660dce:	0f 84 d3 00 00 00    	je     660ea7 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x657>
  660dd4:	4c 39 6c 24 08       	cmp    %r13,0x8(%rsp)
  660dd9:	75 78                	jne    660e53 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x603>
  660ddb:	f3 0f 10 5c 24 04    	movss  0x4(%rsp),%xmm3
  660de1:	0f 2e d9             	ucomiss %xmm1,%xmm3
  660de4:	75 6d                	jne    660e53 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x603>
  660de6:	7a 6b                	jp     660e53 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x603>
  660de8:	f3 0f 10 1c 24       	movss  (%rsp),%xmm3
  660ded:	0f 2e da             	ucomiss %xmm2,%xmm3
  660df0:	75 61                	jne    660e53 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x603>
  660df2:	7a 5f                	jp     660e53 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x603>
  660df4:	0f 28 e0             	movaps %xmm0,%xmm4
  660df7:	f3 0f 58 e7          	addss  %xmm7,%xmm4
  660dfb:	0f 2e e6             	ucomiss %xmm6,%xmm4
  660dfe:	72 4e                	jb     660e4e <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x5fe>
  660e00:	0f 28 de             	movaps %xmm6,%xmm3
  660e03:	f3 0f 58 dd          	addss  %xmm5,%xmm3
  660e07:	0f 2e d8             	ucomiss %xmm0,%xmm3
  660e0a:	72 42                	jb     660e4e <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x5fe>
  660e0c:	0f 28 cb             	movaps %xmm3,%xmm1
  660e0f:	f3 0f 5f cc          	maxss  %xmm4,%xmm1
  660e13:	0f 28 e9             	movaps %xmm1,%xmm5
  660e16:	f3 0f c2 e9 03       	cmpunordss %xmm1,%xmm5
  660e1b:	0f 28 d5             	movaps %xmm5,%xmm2
  660e1e:	0f 55 d1             	andnps %xmm1,%xmm2
  660e21:	0f 54 eb             	andps  %xmm3,%xmm5
  660e24:	0f 56 ea             	orps   %xmm2,%xmm5
  660e27:	0f 28 ce             	movaps %xmm6,%xmm1
  660e2a:	f3 0f 5d c8          	minss  %xmm0,%xmm1
  660e2e:	0f 28 c1             	movaps %xmm1,%xmm0
  660e31:	f3 0f c2 c1 03       	cmpunordss %xmm1,%xmm0
  660e36:	0f 28 d0             	movaps %xmm0,%xmm2
  660e39:	0f 55 d1             	andnps %xmm1,%xmm2
  660e3c:	0f 54 c6             	andps  %xmm6,%xmm0
  660e3f:	0f 56 c2             	orps   %xmm2,%xmm0
  660e42:	f3 0f 5c e8          	subss  %xmm0,%xmm5
  660e46:	0f 28 f0             	movaps %xmm0,%xmm6
  660e49:	e9 c6 fa ff ff       	jmp    660914 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0xc4>
  660e4e:	4c 8b 6c 24 08       	mov    0x8(%rsp),%r13
  660e53:	48 8b 4c 24 18       	mov    0x18(%rsp),%rcx
  660e58:	48 c1 c1 07          	rol    $0x7,%rcx
  660e5c:	66 0f 7e f0          	movd   %xmm6,%eax
  660e60:	48 31 c8             	xor    %rcx,%rax
  660e63:	48 c1 c0 07          	rol    $0x7,%rax
  660e67:	66 0f 6e 5c 24 04    	movd   0x4(%rsp),%xmm3
  660e6d:	66 0f 7e d9          	movd   %xmm3,%ecx
  660e71:	48 31 c1             	xor    %rax,%rcx
  660e74:	48 c1 c1 07          	rol    $0x7,%rcx
  660e78:	66 0f 7e e8          	movd   %xmm5,%eax
  660e7c:	48 31 c8             	xor    %rcx,%rax
  660e7f:	48 c1 c0 07          	rol    $0x7,%rax
  660e83:	66 0f 6e 1c 24       	movd   (%rsp),%xmm3
  660e88:	66 0f 7e d9          	movd   %xmm3,%ecx
  660e8c:	48 31 c1             	xor    %rax,%rcx
  660e8f:	48 c1 c1 07          	rol    $0x7,%rcx
  660e93:	8b 74 24 08          	mov    0x8(%rsp),%esi
  660e97:	48 31 ce             	xor    %rcx,%rsi
  660e9a:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
  660e9f:	48 89 74 24 18       	mov    %rsi,0x18(%rsp)
  660ea4:	48 89 30             	mov    %rsi,(%rax)
  660ea7:	b0 01                	mov    $0x1,%al
  660ea9:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  660eae:	e9 4b fa ff ff       	jmp    6608fe <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0xae>
  660eb3:	f6 44 24 10 01       	testb  $0x1,0x10(%rsp)
  660eb8:	48 8b 54 24 48       	mov    0x48(%rsp),%rdx
  660ebd:	74 4a                	je     660f09 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>+0x6b9>
  660ebf:	48 8b 4c 24 18       	mov    0x18(%rsp),%rcx
  660ec4:	48 c1 c1 07          	rol    $0x7,%rcx
  660ec8:	66 0f 7e f0          	movd   %xmm6,%eax
  660ecc:	48 31 c8             	xor    %rcx,%rax
  660ecf:	48 c1 c0 07          	rol    $0x7,%rax
  660ed3:	66 0f 6e 44 24 04    	movd   0x4(%rsp),%xmm0
  660ed9:	66 0f 7e c1          	movd   %xmm0,%ecx
  660edd:	48 31 c1             	xor    %rax,%rcx
  660ee0:	48 c1 c1 07          	rol    $0x7,%rcx
  660ee4:	66 0f 7e e8          	movd   %xmm5,%eax
  660ee8:	48 31 c8             	xor    %rcx,%rax
  660eeb:	48 c1 c0 07          	rol    $0x7,%rax
  660eef:	66 0f 6e 04 24       	movd   (%rsp),%xmm0
  660ef4:	66 0f 7e c1          	movd   %xmm0,%ecx
  660ef8:	48 31 c1             	xor    %rax,%rcx
  660efb:	48 c1 c1 07          	rol    $0x7,%rcx
  660eff:	8b 44 24 08          	mov    0x8(%rsp),%eax
  660f03:	48 31 c8             	xor    %rcx,%rax
  660f06:	48 89 02             	mov    %rax,(%rdx)
  660f09:	89 e8                	mov    %ebp,%eax
  660f0b:	48 81 c4 18 01 00 00 	add    $0x118,%rsp
  660f12:	5b                   	pop    %rbx
  660f13:	41 5c                	pop    %r12
  660f15:	41 5d                	pop    %r13
  660f17:	41 5e                	pop    %r14
  660f19:	41 5f                	pop    %r15
  660f1b:	5d                   	pop    %rbp
  660f1c:	c3                   	ret
  660f1d:	48 8d 15 5c da 11 00 	lea    0x11da5c(%rip),%rdx        # 77e980 <__frame_dummy_init_array_entry+0x1c0>
  660f24:	4c 89 ef             	mov    %r13,%rdi
  660f27:	ff 15 ab 88 12 00    	call   *0x1288ab(%rip)        # 7897d8 <_DYNAMIC+0x370>
